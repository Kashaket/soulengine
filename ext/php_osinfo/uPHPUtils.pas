unit uPHPUtils;

interface

uses
  Windows,
  SysUtils,
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,

  Variants;

  type
  TArrayString = array of string;
  TArrayVariant = array of variant;

  var
  tmpAR: TArrayVariant;
  tmpAR2: TArrayString;
  MT: TMethod;

  var
  prs: TArrayVariant;
  countConst: integer = 0;

  function ToStr(V: Variant): String;
  function ToStrA(V: Variant): AnsiString;
  function ToZStr(V: Variant): zend_ustr;
  function ToPChar(V: Variant): PChar;
  function ToZChar(V: Variant): zend_pchar;
   function ToPCharA(V: Variant): PAnsiChar;
  function readPr(param: pzval_array; index: integer): Variant;
  procedure readPrs(param: pzval_array; ht: integer);
  function checkPrs(ht,count: integer; var TSRMLS_DC : pointer): Boolean;
  function checkPrs2(ht: integer;  var Param: pzval_array; var TSRMLS_DC: pointer): Boolean;
  function toWChar(s: PAnsiChar): PWideChar;
  procedure HashToArray(HT: PHashTable; var AR: TArrayVariant); overload;
  function HashToRect(HT: PHashTable): TRect;
  function HashToPoint(ZN: PHashTable): TPoint;
  procedure ArrayToHash(AR: Array of Variant; var HT: pzval); overload;
  procedure ArrayToHash(Keys,AR: Array of Variant; var HT: pzval); overload;
  procedure regConstL(Name: String; Value: Integer; TSRMLS_DC: pointer = nil);

  implementation


function toWChar(s: PAnsiChar): PWideChar;
  var
  ss: WideString;
  ss2: string;
begin
  ss2 := s;
  ss := ss2;
  Result := PWideChar(ss);
end;

function ZendToVariant(const Value: pppzval): Variant;
  Var
  S: String;
begin
 case Value^^^._type of
 1: Result := Value^^^.value.lval;
 2: Result := Value^^^.value.dval;
 6: begin S := Value^^^.value.str.val; Result := S; end;
 4,5: Result := Unassigned;
 end;
end;

procedure HashToArray(HT: PHashTable; var AR: TArrayVariant); overload;
  Var
  Len,I: Integer;
  tmp : pppzval;
begin
 len := zend_hash_num_elements(HT);
 SetLength(AR,len);
 for i:=0 to len-1 do
  begin
    new(tmp);
    zend_hash_index_find(ht,i,tmp);
     AR[i] := ZendToVariant(tmp);
    freemem(tmp);
  end;
end;


function HashToRect(HT: PHashTable): TRect;
begin
 HashToArray(HT,tmpAR);
 Result.Left := tmpAR[0];
 Result.Top  := tmpAR[1];
 Result.Right := tmpAR[2];
 Result.Bottom := tmpAR[3];

// Result.TopLeft.X := tmpAR[4];
// Result.TopLeft.Y := tmpAR[5];
// Result.BottomRight.X := tmpAR[6];
// Result.BottomRight.Y := tmpAR[7];
end;

function HashToPoint(ZN: PHashTable): TPoint;
begin
 HashToArray(ZN,tmpAR);
 Result.X := tmpAR[0];
 Result.Y := tmpAR[1];
end;

procedure ArrayToHash(AR: Array of Variant; var HT: pzval); overload;
  Var
  I,Len: Integer;
    tmp : pppzval;
    pp: pzval_array;
begin
  _array_init(ht,nil,1);
  len := Length(AR);
  for i:=0 to len-1 do
   begin
     case VarType(AR[i]) of
     varInteger, varSmallint, varLongWord, 17: add_index_long(ht,i,AR[i]);
     varDouble,varSingle: add_index_double(ht,i,AR[i]);
     varBoolean: add_index_bool(ht,i,AR[I]);
     varEmpty: add_index_null(ht,i);
     varString: add_index_string(ht,i,ToZChar(AR[I]),1);
     258: add_index_string(ht,i,zend_pchar(zend_ustr(ToStr(AR[I]))),1);
     end;
   end;
end;

procedure ArrayToHash(Keys,AR: Array of Variant; var HT: pzval); overload;
  Var
  I,Len: Integer;
    tmp : pppzval;
    pp: pzval_array;
    v: Variant;
    key: zend_pchar;
    s: zend_pchar;
begin
  _array_init(ht,nil,1);
  len := Length(AR);
  for i:=0 to len-1 do
   begin
     v := AR[I];
     key := ToZChar(keys[i]);
     s := PAnsiChar(ToStrA(v));
     case VarType(AR[i]) of
     varInteger, varSmallint, varLongWord, 17: add_assoc_long_ex(ht,ToZChar(Keys[i]),strlen(ToPChar(Keys[i]))+1,AR[i]);
     varDouble,varSingle: add_assoc_double_ex(ht,ToZChar(Keys[i]),Length(ToZStr(Keys[i]))+1,AR[i]);
     varBoolean: add_assoc_bool_ex(ht,ToZChar(Keys[i]),Length(ToZStr(Keys[i]))+1,AR[I]);
     varEmpty: add_assoc_null_ex(ht,ToZChar(Keys[i]),Length(ToZStr(Keys[i]))+1);
     varString,258: add_assoc_string_ex(ht,key,Length(zend_ustr(key))+1,s,1);
     end;
   end;
end;


procedure regConstL(Name: String; Value: Integer; TSRMLS_DC: pointer = nil);
begin

    if TSRMLS_DC = nil then
      TSRMLS_DC := ts_resource(0);

  zend_register_long_constant(zend_pchar(zend_ustr(Name)),length(name)+1, value, CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);

end;

function ToStrA(V: Variant): AnsiString;
begin
  Result := V;
end;

function ToStr(V: Variant): String;
begin
  Result := V;
end;

function ToZStr(V: Variant): zend_ustr;
begin
  Result := V;
end;

function ToPChar(V: Variant): PChar;
begin
  Result := PChar(ToStr(V));
end;

function ToZChar(V: Variant): zend_pchar;
begin
  Result := zend_pchar(ToZStr(V));
end;

function ToPCharA(V: Variant): PAnsiChar;
begin
  Result := PAnsiChar(ToStrA(V));
end;

function readPr(param: pzval_array; index: integer): Variant;
begin
    Result := ZendApi.ZendToVariant(param[index]^);
end;

procedure readPrs(param: pzval_array; ht: integer);
  var
  i: integer;
begin
    SetLength(prs,0);
    SetLength(prs,ht);
    for i:=0 to ht-1 do
        prs[i] := readPr(param,i);
end;


function checkPrs(ht,count: integer; var TSRMLS_DC : pointer): Boolean;
begin
  Result := true;
  if ht < count then begin
        zend_wrong_param_count(TSRMLS_DC);
        Result := false;
  end;
end;

function checkPrs2(ht: integer; var Param: pzval_array; var TSRMLS_DC: pointer): Boolean;
begin
  Result := true;
  if ( not (zend_get_parameters_my(ht, Param, TSRMLS_DC) = SUCCESS )) then
    begin
        zend_wrong_param_count(TSRMLS_DC);
        Result := false;
    end;
end;


end.
