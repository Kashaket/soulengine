unit DelphiPhp5;

interface

uses Winapi.Windows, FileExists;

const
  DllPHP				      = 'php5ts.dll';
  SUCCESS				      = 0;
  FAILURE				      = -1;
  IS_NULL				      = 0;
  IS_LONG				      = 1;
  IS_DOUBLE				    = 2;
  IS_BOOL				      = 3;
  IS_ARRAY				    = 4;
  IS_OBJECT				    = 5;
  IS_STRING				    = 6;
  IS_RESOURCE			    = 7;
  IS_CONSTANT			    = 8;
  IS_CONSTANT_AST		  = 9;
  IS_CALLABLE			    = 10;
  ZEND_MODULE_API_NO	= 20090626;
 
type
  PPBucket = ^PBucket;
  PBucket = ^TBucket;
  TBucket = record
    h           : ulong;
    nKeyLength  : uint;
    pData       : pointer;
    pDataPtr    : pointer;
    pListNext   : PBucket;
    pListLast   : PBucket;
    pNext       : PBucket;
    pLast       : PBucket;
    arKey       : array [0 .. 1] of AnsiChar;
  end;

  PHashTable = ^THashTable;
  THashTable = record
    nTableSize          : uint;
    nTableMask          : uint;
    nNumOfElements      : uint;
    nNextFreeElement    : ulong;
    pInternalPointer    : PBucket;
    pListHead           : PBucket;
    pListTail           : PBucket;
    arBuckets           : PPBucket;
    pDestructor         : pointer;
    persistent          : boolean;
    nApplyCount         : byte;
    bApplyProtection    : boolean;
  end;

  p_zend_module_entry = ^_zend_module_entry;
  _zend_module_entry = record
    size                  : word;
    zend_api              : dword;
    zend_debug            : byte;
    zts                   : byte;
    ini_entry             : pointer;
    deps                  : pointer;
    name                  : PAnsiChar;
    functions             : Pointer;
    module_startup_func   : pointer;
    module_shutdown_func  : pointer;
    request_startup_func  : pointer;
    request_shutdown_func : pointer;
    info_func             : pointer;
    version               : PAnsiChar;
    globals_size          : size_t;
    globals_id_ptr        : pointer;
    globals_ctor          : pointer;
    globals_dtor          : pointer;
    post_deactivate_func  : pointer;
    module_started        : integer;
    _type                 : byte;
    handle                : pointer;
    module_number         : Integer;
    build_id              : PAnsiChar;
  end;

  P_zend_arg_info = ^_zend_arg_info;
  _zend_arg_info = record
    name              : PAnsiChar;
    name_len          : uint;
    class_name        : PAnsiChar;
    class_name_len    : uint;
    array_type_hint   : boolean;
    allow_null        : boolean;
    pass_by_reference : boolean;
    return_reference  : boolean;
    required_num_args : integer;
  end;

  _zend_function_entry = record
    fname     : PAnsiChar;
    handler   : pointer;
    arg_info  : P_zend_arg_info;
    num_args  : uint;
    flags     : uint;
  end;

  zend_object_value = record
    handle:Integer;
    handlers:Pointer;
  end;

  Pzvalue_value = ^zvalue_value;
  zvalue_value = record
    case integer of
      0: (lval	: Longint;);
      1: (dval	: double;);
      2: (str	: record
					  val	: PAnsiChar;
					  len	: LongInt;
				  end;);
      3: (ht	: PHashTable;);
      4: (obj	: zend_object_value;);
  end;

  pppzval = ^ppzval;
  ppzval = ^pzval;
  pzval = ^zval;

  zval = record
    value         : zvalue_value;
    refcount__gc  : uint;
    _type         : Byte;
    is_ref__gc    : Byte;
  end;

var
  PHP5dll				        : THandle = 0;
  ZEND_MODULE_BUILD_ID	: PAnsiChar = 'API20090626,TS,VC9';

  zend_get_parameters_ex : function(param_count : Integer; Args : ppzval) :integer; cdecl varargs;
  _estrndup : function(s : PAnsiChar; Len : Cardinal; zend_filename : PAnsiChar;
                        zend_lineno : uint; zend_orig_filename : PAnsiChar;
                                    zend_orig_line_no : uint) : PAnsiChar; cdecl;
  zend_wrong_param_count : procedure(TSRMLS_D : pointer); cdecl;

  function ZvalGetFloat(z:zval):Double;

  procedure ZVAL_TRUE(value:pzval);
  procedure ZVAL_FALSE(value:pzval);
  procedure ZvalString(z:pzval) overload;
  procedure ZvalString(z:pzval; s:PAnsiChar; len:Integer = 0) overload;
  procedure ZvalString(z:pzval; s:PWideChar; len:Integer = 0) overload;
  procedure ZvalString(z:pzval; s:string; len:Integer = 0) overload;
  function HRESULTStr(h:HRESULT):Pchar;
  procedure ZvalHRESULTStr(z:pzval; h:HRESULT);
  function estrndup(s: PAnsiChar; len: Cardinal): PAnsiChar;
  function ISPHPLib : boolean;
  function LoadZEND(const DllFilename:AnsiString = DllPHP): boolean;
  procedure UnloadZEND;


  function ZvalInt(z:zval):Integer;
  function ZvalDouble(z:zval):Double;
  function ZvalBool(z:zval):Boolean;

  function ZvalStrS(z:zval) : string;
  function ZvalStr(z:zval)  : AnsiString;
  function ZvalStrW(z:zval) : WideString;

  procedure ZvalVAL(z:pzval; v:Boolean) overload;
  procedure ZvalVAL(z:pzval; v:Integer; const _type:Integer = IS_LONG) overload;
  procedure ZvalVAL(z:pzval) overload;
  procedure ZvalVAL(z:pzval; v:Double) overload;

implementation

function ISPHPLib : boolean;
begin
  Result := PHP5dll <> 0;
end;

function LoadZEND;
begin
  result := false;
  if FileExists_(string(DllFilename)) then begin
    PHP5dll := LoadLibraryA(PAnsiChar(DllFilename));
    if (PHP5dll <> 0) then begin
      zend_get_parameters_ex := GetProcAddress(PHP5dll, 'zend_get_parameters_ex');
      _estrndup := GetProcAddress(PHP5dll, '_estrndup');
      result := true;
    end;
  end;
end;

procedure UnloadZEND;
begin
  if ISPHPLib then
    FreeLibrary(PHP5dll);
end;

function ZvalGetFloat;
begin
  Result := 0;
  if z._type = IS_LONG then
    Result := z.value.lval
  else if z._type = IS_DOUBLE then
    Result := z.value.dval;
end;

function estrndup;
begin
  if assigned(s) then
    Result := _estrndup(s, len, nil, 0, nil, 0)
  else
    Result := nil;
end;


function HRESULTStr(h:HRESULT):Pchar;
begin
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, nil, h,MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),@Result,0,nil);
end;


function ZvalInt;
begin
  Result := z.value.lval;
end;

function ZvalDouble;
begin
  Result := z.value.dval;
end;

function ZvalBool;
begin
  Result := boolean(z.value.lval);
end;

function ZvalStrS;
begin
 Result := z.value.str.val;
end;

function ZvalStr;
begin
 Result := z.value.str.val;
end;

function ZvalStrW;
begin
 Result := WideString(z.value.str.val);
end;

procedure ZvalVAL(z:pzval; v:Boolean);
Begin
  z._type := IS_BOOL;
  z.value.lval := integer(v);
End;

procedure ZvalVAL(z:pzval; v:Integer; const _type:Integer = IS_LONG);
Begin
  z._type := _type;
  z.value.lval := v;
End;

procedure ZvalVAL(z:pzval);
Begin
  z._type := IS_NULL;
End;

procedure ZvalVAL(z:pzval; v:Double);
Begin
  z._type := IS_LONG;
  z.value.dval := v;
End;

procedure ZVAL_TRUE;
begin
  value^._type := IS_BOOL;
  value^.value.lval := 1;
end;

procedure ZVAL_FALSE;
begin
  value^._type := IS_BOOL;
  value^.value.lval := 0;
end;

procedure ZvalString(z:pzval);
begin
  z^.value.str.len := 0;
  z^.value.str.val := '';
  z^._type := IS_STRING;
end;

procedure ZvalString(z:pzval; s:PAnsiChar; len:Integer = 0);
var
  lens:Integer;
begin
  if not assigned(s) then
    ZvalString(z)
  else begin
    if len = 0 then
      lens := Length(s)
    else
      lens := len;

    z^.value.str.len := lens;
    z^.value.str.val := estrndup(s, lens);
    z^._type := IS_STRING;
  end;
end;

procedure ZvalString(z:pzval; s:PWideChar; len:Integer = 0);
begin
  if not assigned(s) then
    ZvalString(z)
  else
    ZvalString(z, PAnsiChar(AnsiString(WideString(s))), len);
end;

procedure ZvalString(z:pzval; s:string; len:Integer = 0);
var
  _s:PWideChar;
begin
  _s := PWideChar(s);

  if not assigned(_s) then
    ZvalString(z)
  else
    ZvalString(z, _s, len);
end;

procedure ZvalHRESULTStr(z:pzval; h:HRESULT);
begin
  ZvalString(z, HRESULTStr(h));
end;

end.
