{$I PHP.inc}
unit guiForms;
{$I PHP.inc}
{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  Classes, SysUtils, UITypes, Dialogs, Controls, Forms,

  {$ifdef fpc}
  LCLType,
  {$endif}
  {$IFDEF PHP7} hzend_types, {$ENDIF}
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  php4delphi,
  mainLCL,
  uPhpEvents,
  uForms;

procedure InitializeGuiForms(PHPEngine: TPHPEngine);

procedure gui_formShowModal(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;

procedure gui_formSetMain(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;

procedure gui_Message(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
procedure gui_SafeMessage(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;

implementation

procedure gui_formShowModal;
var
  p: pzval_array;
begin
  if ht < 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_ex(ht, p);

  variant2zval(Form_ShowModal(Z_LVAL(p[0]^)), return_value);
  dispose_pzval_array(p);
end;

procedure gui_formSetMain(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;

  procedure SetAsMainForm(aForm: TForm);
  var
    P: Pointer;
  begin
    P := @Application.Mainform;
    Pointer(P^) := aForm;
  end;

var
  p: pzval_array;
  obj: TObject;
begin
  if ht < 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_ex(ht, p);

  obj := toObject(Z_LVAL(p[0]^));
  if (obj = nil) or not (obj is TForm) then
  begin
    ZVAL_BOOL(return_value, False);
  end
  else
  begin
    SetAsMainForm(TForm(Obj));
  end;
  dispose_pzval_array(p);
end;

procedure gui_Message;
var
  p: pzval_array;
begin
  if ht < 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_ex(ht, p);

  ShowMessage( Z_STRVAL(p[0]^) );

  dispose_pzval_array(p);
end;

procedure gui_SafeMessage;
var
  p: pzval_array;
  msg: zend_pstr;
begin
  if ht < 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_ex(ht, p);

  New(Msg);
  Msg^ := Z_STRVAL(p[0]^);
  TScriptSafeCommand_Message.Create(Msg);

  dispose_pzval_array(p);
end;




procedure InitializeGuiForms(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('gui_formShowModal', @gui_formShowModal);
  PHPEngine.AddFunction('gui_formSetMain', @gui_formSetMain);
  PHPEngine.AddFunction('gui_message', @gui_Message);
  PHPEngine.AddFunction('gui_safeMessage', @gui_safeMessage);
end;




end.
