unit guiChromium;
{$I PHP.inc}
{$ifdef fpc}
{$mode delphi}{$H+}
{$ELSE}
{$M+}
{$ENDIF}
interface

uses
  Classes, SysUtils, phpUtils, Forms, regGUI, Controls,
  {$IFDEF PHP7} hzend_types, {$ENDIF}
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  php4delphi,
  uPhpEvents,
  uPHPMod,
  Graphics, Dialogs, dwsHashtables,
  uCefApplication, uCefChromium,  uCefChromiumOptions,
   uCEFv8Handler, uCEFv8Value, uCEFTypes,
  uCEFv8Accessor, uCEFInterfaces, uCEFMiscFunctions;

procedure InitializeGuiChromium(PHPEngine: TPHPEngine);

procedure chromium_allowedcall(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;

procedure chromium_settings(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
procedure LoadChromium;

type
  TExtension = class(TCefv8HandlerOwn)
  private

  protected
    function Execute(const Name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var Exception: ustring): boolean; override;
  end;

implementation

var
  AllowedCall: TStringHashTable;
  SelfStarted: boolean = false;

procedure chromium_settings;
var
  p: pzval_array;
begin
  if ht < 10 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  GlobalCEFApp.Cache :=     Z_STRVAL(p[0]^);
  GlobalCEFApp.UserAgent := Z_STRVAL(p[1]^);
  GlobalCEFApp.ProductVersion := Z_STRVAL(p[2]^);
  GlobalCEFApp.Locale := Z_STRVAL(p[3]^);
  GlobalCEFApp.LogFile := Z_STRVAL(p[4]^);
  GlobalCEFApp.FrameworkDirPath := Z_STRVAL(p[5]^);
  GlobalCEFApp.FlashEnabled := Z_BVAL(p[6]^);
  GlobalCEFApp.NoSandbox := Z_BVAL(p[7]^);
  GLobalCEFAPP.JavaScriptFlags := Z_STRVAL(p[8]^);
  GlobalCEfApp.RemoteDebuggingPort := Z_LVAL(p[9]^);
  dispose_pzval_array(p);
end;

procedure chromium_allowedcall;
var
  p: pzval_array;
  i: integer;
  tmp: ^ppzval;
  arr: {$IFDEF PHP7}Pzend_array{$ELSE}PHashTable{$ENDIF};
begin
  if ht < 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  AllowedCall.Clear;

  if
   {$IFDEF PHP7}p[0]^^.u1.v._type{$ELSE}p[0]^^._type{$ENDIF}
    = IS_ARRAY then
    arr := {$IFDEF PHP7}p[0]^^.Value.arr{$ELSE}p[0]^^.Value.ht{$ENDIF}
  else
    arr := nil;

  if arr <> nil then
  begin
    New(tmp);
    for i := zend_hash_num_elements(arr) - 1 downto 0 do
    begin
      zend_hash_index_find(arr, i, tmp);
      AllowedCall.SetValue(LowerCase(String(Z_STRVAL(tmp^^))), '');
    end;
    Dispose(tmp);
  end;

  dispose_pzval_array(p);
end;

procedure V8_ZVAL(Value: ICefv8Value; arg: pzval);
var
  S: zend_ustr;
begin
  if Value.IsUndefined or Value.IsNull then
    ZVAL_NULL(arg)
  else if Value.IsBool then
    ZVAL_BOOL(arg, Value.GetBoolValue)
  else if Value.IsInt then
    ZVAL_LONG(arg, Value.GetIntValue)
  else if Value.IsDouble then
    ZVAL_DOUBLE(arg, Value.GetDoubleValue)
  else if Value.IsDate then
    ZVAL_DOUBLE(arg, Value.GetDateValue)
  else if Value.IsString then
  begin
    S := zend_ustr(Value.GetStringValue);
    if S = '' then
      ZVAL_EMPTY_STRING(arg)
    else
      ZVAL_STRINGL(arg, zend_pchar(S), Length(S), True);
  end
  else
    ZVAL_NULL(arg);
end;

function ZVAL_V8(arg: pzval): ICefv8Value;
begin
  case {$IFDEF PHP7}arg.u1.v._type{$ELSE}arg._type{$ENDIF} of
    IS_LONG: Result := TCefv8ValueRef.NewInt(arg.Value.lval);
    IS_DOUBLE: Result := TCefv8ValueRef.NewDouble(arg.Value.dval);
    IS_BOOL: Result := TCefv8ValueRef.NewBool(boolean(arg.Value.lval));
    IS_STRING: Result := TCefv8ValueRef.NewString(String(Z_STRVAL(arg)));
    else
      Result := TCefv8ValueRef.NewNull;
  end;
end;

function TExtension.Execute(const Name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var Exception: ustring): boolean;
  label ex1;
  var
  S: zend_ustr;
  {$IFDEF PHP7}
  tmp: pzval;
  {$ENDIF}
  Args: {$IFDEF PHP7}pzval{$ELSE}pzval_array_ex{$ENDIF};
  Return, Func: pzval;
  i: integer;
begin
   {if name = 'eval' then
   begin
      if length(arguments) > 0 then
      begin
         phpMOD.RunCode( arguments[0].GetStringValue );
      end;
   end else}
  if Name = 'call' then
  begin
    if length(arguments) > 0 then
    begin
      S := arguments[0].GetStringValue;
      if (AllowedCall.FSize = 0) or (not AllowedCall.HasKey(LowerCase(S))) then
      begin
        Result := False;
        goto ex1;
      end;

      Func := MAKE_STD_ZVAL;
      Return := MAKE_STD_ZVAL;


      ZVAL_STRING(Func, zend_pchar(S), True);
      {$IFDEF PHP7}
      args.value.arr.nNumOfElements := length(arguments)-1;
      for i := 0 to (length(arguments)-1) do
      begin
        tmp := MAKE_STD_ZVAL;
        V8_ZVAL(arguments[i + 1], tmp);
        _zend_hash_index_add(args.value.arr, i, tmp);
      end;
      {$ELSE}
      SetLength(args, length(arguments) - 1);
      for i := 0 to high(args) do
      begin
        args[i] := MAKE_STD_ZVAL;
        V8_ZVAL(arguments[i + 1], args[i]);
      end;
      {$ENDIF}
      {$IFDEF PHP7}
      {$IFDEF P_CUT}
      call_user_function(
        Func,
        Args,
        Args.value.arr.nNumOfElements
        );
      {$ELSE}
      call_user_function(
        GetExecutorGlobals.function_table.value.arr,
        nil,
        Func,
        Return,
        Args.value.arr.nNumOfElements,
        Args.value.arr,
        phpMOD.psvPHP.TSRMLS_D
        );
        {$ENDIF}
      {$ELSE}
      call_user_function(
        GetExecutorGlobals.function_table,
        nil,
        Func,
        Return,
        Length(Args),
        Args,
        phpMOD.psvPHP.TSRMLS_D
        );
      {$ENDIF}
      {$IFDEF PHP7}
      for i := 0 to (args.value.arr.nNumOfElements-1) do
      begin
        _zval_dtor( zend_hash_index_findZval(args, i), nil, 0);
      end;
      {$ELSE}
      for i := 0 to high(args) do
      begin
        _zval_dtor(args[0], nil, 0);
      end;
      {$ENDIF}

      retval := ZVAL_V8(Return);
      Result := True;

      _zval_dtor(Func, nil, 0);
      _zval_dtor(Return, nil, 0);
    end;
  end;
  ex1:

{  if length(args) > 0 then
  for x in args do
     Freemem(x); }
end;

const
  code =
    'var PHP;' + 'if (!PHP)' + '  PHP = {};' + '(function() {' +
  (* '  PHP.eval = function(code) {'+
   '    native function eval(code);'+
   '    return eval(code);'+
   '  };'+   *)
    '  PHP.call = function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15) {' +
    '    native function call(arguments);' + '    return call.apply(null, arguments);' +
    '  };' + '})();';

// after load chromium callback
procedure callback_CefLoadLib;
begin
  CefRegisterExtension('v8/PHP', code, TExtension.Create as ICefV8Handler);
end;

procedure InitializeGuiChromium(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('chromium_settings', @chromium_settings);
  {$MESSAGE 'Check wether else method exist'}
  //PHPEngine.AddFunction('chromium_allowedcall', @chromium_allowedcall);
   //GlobalCEFApp.StartMainProcess;
  //CefLoadLibAfter := callback_CefLoadLib;
end;
procedure LoadChromium;
begin
if FileExists('cef.pak') and not SelfStarted then begin
      GlobalCEFApp := TCefApplication.Create;
      GlobalCEFApp.SingleProcess := True;
      GlobalCEFApp.NoSandbox := True;
      GlobalCEFApp.StartMainProcess;
      SelfStarted := True;
  end;
end;

initialization
  //AllowedCall := TStringHashTable.Create(256);
end.
