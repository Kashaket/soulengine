unit guiProperties;

{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  Classes,
  SysUtils,
  zendTypes,
  ZENDAPI,
  PHPAPI,
  php4delphi,
  propertiesEngine,
  RTTI;

procedure InitializeGuiProperties(PHPEngine: TPHPEngine);

procedure gui_propGet(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ��������
procedure gui_propType(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
  //��������� ���� ��������
procedure gui_propExists(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
  //�������� �������� �� �������������
procedure gui_propList(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
  //��������� ������ ������� �������/���������� ������
procedure gui_class_propList(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
  //��������� ������ ������� ������
procedure gui_class_propArray(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
  //��������� ������� ������� ������
procedure gui_propSet(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //�������/��������� �������� ��������
procedure gui_methodList(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ �������
procedure gui_methodExists(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //�������� ������ �� �������������
procedure gui_class_method_exist
(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //�������� ������ �� ������������� (��� �������)
procedure gui_methodCall(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //����� ������
procedure gui_get_evt_paramss(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ ���������� (������) ��� ���������
procedure gui_get_evt_paramnames(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ �������� ����������
procedure gui_get_evt_paramtypes(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ ����� ���������� (� ����� �����)
procedure gui_get_evt_assci(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� �������������� ������ ����������, ��� ���� - ��������, � �������� - ��� ���������
procedure gui_class_methodList(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ ������� ������
procedure gui_get_method_params(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ ���������� ������ ������
procedure gui_method_params(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ ���������� ������ ������
procedure  gcreate(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //�������� ������� (�������������� �������)
procedure gui_get_all_unitsclasses(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //��������� ������ ���� �������
procedure lbpll(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //���������/�������� bpl-����������
procedure ldl(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
  //���������/�������� dll-����������
procedure gpreadable(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
procedure gpwritable(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
procedure gui_form_fixdwm(ht: integer; return_value: pzval; return_value_ptr: pzval;
  this_ptr: pzval; return_value_used: integer; TSRMLS_DC: pointer); cdecl;
implementation

procedure gui_propGet;
var
  p: pzval_array;
begin
  if ht <> 2 then //�������� ���������� ���������� ����������, ���� ������ ����, ��...
  begin
    zend_wrong_param_count(TSRMLS_DC);//����� ������ "������� �������� ������������ ����������"
    Exit;
    //����� �� ���������
  end;


  zend_get_parameters_my(ht, p, TSRMLS_DC);//��������� ���������� �������� ���-��
 if(p[1]^._type = IS_STRING) THEN //���� ��� ������� ���������/��������� - ������, ��
      begin
      //�������� ������� ��������� �������� �������� � ���������� ���������
        variant2zval(getProperty(integer(Z_LVAL(p[0]^)),Z_STRVAL(p[1]^)), return_value);
      end;

  dispose_pzval_array(p);
end;


procedure gui_propType;
var
  p: pzval_array;
begin
  if ht <> 2 then  //��������� ���������� ���������� ����������
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  //�������� ���������
  zend_get_parameters_my(ht, p, TSRMLS_DC);
  //���������� � ���-������ return_value ���/��� ���������/�������� �������
  ZVAL_LONG(return_value, getPropertyType(Z_LVAL(p[0]^), Z_STRVAL(p[1]^)));

  dispose_pzval_array(p);
end;

procedure gui_propExists;
var
  p: pzval_array;
begin
  if ht <> 2 then //��������� ���������� ���������� ����������
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  //�������� ���������
  zend_get_parameters_my(ht, p, TSRMLS_DC);
  //��������� �������� �� �������������,
  //��������� ������ ����� = 0 u 1
  ZVAL_BOOL(return_value, existProperty(Z_LVAL(p[0]^), Z_STRVAL(p[1]^)));

  dispose_pzval_array(p);
end;

procedure gui_methodExists;
var
  p: pzval_array;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);
  //��������� ����� �� �������������,
  //��������� ������ ����� = 0 u 1
  ZVAL_BOOL(return_value, existMethod(Z_LVAL(p[0]^), Z_STRVAL(p[1]^)));

  dispose_pzval_array(p);
end;

procedure gui_methodCall;
var
  p: pzval_array; //���-������ ������������ ����������
  ar: TArrayVariant; //���-������ ��� ����������� �������
  arr: array of TValue; //������, ������ ��� ������ ������ � �������� ��� ����������
  x: variant;           //����� �������(���������� ������ ����)
  params: TArray<TTypeKind>;//���� ������������ ���������� (����� ��� �������� ����� ���������)
  I: integer;           //����� ��� ������������ � ������� ���� ����������
  method: ^TNotifyEvent;//����������, ��� �����
begin
  if (ht < 2) or (ht > 3) then //�������, ������-��� � ����������� Switch-Case ���� Default:
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  case ht of //�������� ���������� ���������� ����������
    2: begin
      //���� ��������� ��� - ��������������, ��������� ������ ������ �� ��������,
      //������� ��� ������ ������
      variant2zval(callMethod(Z_LVAL(p[0]^), Z_STRVAL(p[1]^), []), return_value);
    end;
    3: begin
      if p[2]^._type <> IS_ARRAY then
      //���� ��� �������� ������(������������, ��� ����� �������� ._.)
       begin
        zend_wrong_param_count(TSRMLS_DC);
        Exit;
       end;
      HashToArray(p[2]^.value.ht, ar);//���������� ��� �� ���-������� � ������
      if (Length(ar) = 0) then //���� ����� ������� ����� ���� (���� �� ������)
      begin
        //���������� ��������� ������ �������/������ � ��������� ������� ������� ����������.
        variant2zval(callMethod(Z_LVAL(p[0]^), Z_STRVAL(p[1]^), []), return_value);
      end
      else
      begin
      //����� ����� ������� ��� �������� �������
        SetLength(arr, 0);
        //�������� ��� ���� ���������� ������
        params := getMethodParams(Z_LVAL(p[0]^), Z_STRVAL(p[1]^));
        //���� ���������� ��������� � ���������� ���������� �������, ��...
        if  Length(ar) = Length(params) then
        begin
        //����������� �� ������� ���������� (����� ����������)
          for I := 0 to High(params) do
          begin
            SetLength(arr, Length(arr)+1);
            case params[I] of
              tkUnknown:      begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkInteger:      begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkChar:         begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              ///tkEnumeration<???>///
              ///  �� ���� ��� ��������, �� ��������� ��������
              ///  �.� ��� ������������� ������-�������������
              ///  ��� Iterable � PHP...
              tkFloat:        begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkString:       begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              //tkSet
              tkClass:        begin
              {///?
               Throws Access Violation
              ?}///
              ///  ����������� ������ Access Violation
                arr[High(arr)]  := TValue.From<TObject>( TObject(integer(ar[I])) );
              end;
              ///tkMethod  - do not add (non-applicable for this)
              ///or not, idk==
              ///  ������ �� ��������
              tkMethod:       begin
                method          := Pointer(integer(ar[I]));
                arr[High(arr)]  := TValue.From<TNotifyEvent>( method^ );
              end;
              tkWChar:        begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkLString:      begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkWString:      begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkVariant:      begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkArray:        begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkRecord:       begin
              ///???///
              ///  ������ ����������� ������
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkInterface:    begin
              ///???///
              ///  ������ ����������� ������
                arr[High(arr)]  := TValue.FromVariant(integer(ar[I]));
              end;
              tkInt64:        begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkDynArray:     begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              tkUString:      begin
                arr[High(arr)]  := TValue.FromVariant(ar[I]);
              end;
              ///tkClassRef<???>///
              ///����� �������� ���-��, �� ���� ���, ���� �� ����///
              tkPointer:      begin
                arr[High(arr)]  := TValue( Pointer(integer(ar[I])) );
              end;
              tkProcedure:    begin
                arr[High(arr)]  := TValue( Pointer(integer(ar[I])) );
              end;
            end;
            //arr[High(arr)] := TValue.FromVariant(ar[I]);
         end;
          variant2zval(callMethod(Z_LVAL(p[0]^), Z_STRVAL(p[1]^), arr), return_value);
        end
        else
        begin
            //���� �� ������� - �����, ��� ���������� �������� ������������
            zend_wrong_param_count(TSRMLS_DC);
            Exit;
        end;
      end;
    end;
  end;

  dispose_pzval_array(p);
end;

procedure gui_methodList;
var
  p: pzval_array;
  arrn: TWSDate;
begin
  if ht <> 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);
  listMethod(Z_LVAL(p[0]^), @arrn);
  ZVAL_ARRAY(return_value, arrn);

  dispose_pzval_array(p);
end;

procedure gui_propList;
var
  p: pzval_array;
begin
  if (ht < 1) or (ht > 2) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);

  if ht <2 then
  begin
     ZVAL_STRINGW(return_value, PWideChar(getProperties(Z_LVAL(p[0]^), -1)), True);
  dispose_pzval_array(p);
  end
  else
  begin
    ZVAL_STRINGW(return_value, PWideChar(getProperties(Z_LVAL(p[0]^), Z_LVAL(p[1]^))), True);
  dispose_pzval_array(p);
  end;

end;

procedure gui_class_propList;
var
  p: pzval_array;
begin
  if (ht < 1) or (ht > 2) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);

  if ht <2 then
  begin
     ZVAL_STRINGW(return_value, PWideChar(getPropertiesfClass(Z_STRVAL(p[0]^), -1)), True);
  dispose_pzval_array(p);
  end
  else
  begin
    ZVAL_STRINGW(return_value, PWideChar(getPropertiesfClass(Z_STRVAL(p[0]^), Z_LVAL(p[1]^))), True);
  dispose_pzval_array(p);
  end;

end;
procedure gui_class_propArray;
var
  p: pzval_array;
  arrn:  TWSDate;
  arrv:  TWSDate;
begin
  if (ht < 1) or (ht > 2) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);

  if ht < 2 then
  begin
     getPropertiesfClassArr(Z_STRVAL(p[0]^), -1, @arrn, @arrv);
     ZVAL_ARRAYWS(return_value, arrn, arrv);
    dispose_pzval_array(p);
  end
  else
  begin
     getPropertiesfClassArr(Z_STRVAL(p[0]^), Z_LVAL(p[1]^), @arrn, @arrv);
     ZVAL_ARRAYWS(return_value, arrn, arrv);
    dispose_pzval_array(p);
  end;

end;
procedure gui_propSet;
var
  p: pzval_array;
begin
  if ht <> 3 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);
  if p[2]^^._type in [IS_LONG, IS_BOOL, IS_DOUBLE, IS_STRING] then
    ZVAL_BOOL(return_value, setProperty(Z_LVAL(p[0]^), Z_STRVAL(p[1]^), zval2variant(p[2]^^)));

  dispose_pzval_array(p);
end;

procedure gui_get_evt_paramss;
var
  p: pzval_array;
  pw: PWideChar;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  if (p[0]^^._type = IS_LONG) and (p[1]^^._type = IS_STRING) then
  begin
    ZVAL_STRINGW(return_value, PWideChar(
    evt_params( Z_LVAL(p[0]^), Z_STRVAL(p[1]^) )
    ), True);
  end
  else
  begin
    ZVAL_STRINGW(return_value, PWideChar(
    evt_params( Z_STRVAL(p[0]^), Z_STRVAL(p[1]^) )
    ), True);
  end;

  dispose_pzval_array(p);
end;

procedure gui_get_evt_paramnames;
var
  p: pzval_array;
  arrn:  TWSDate;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);

     evt_param_names(Z_STRVAL(p[0]^), Z_STRVAL(p[1]^), @arrn);
     ZVAL_ARRAY(return_value, arrn);
    dispose_pzval_array(p);

end;

procedure gui_get_evt_paramtypes;
var
  p: pzval_array;
  arrn:  TWSDate;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);

     evt_param_types(Z_STRVAL(p[0]^), Z_STRVAL(p[1]^), @arrn);
     ZVAL_ARRAY(return_value, arrn);
    dispose_pzval_array(p);

end;

procedure gui_get_evt_assci;
var
  p: pzval_array;
  arrn, arrv:  TWSDate;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);
     evt_param_names(Z_STRVAL(p[0]^), Z_STRVAL(p[1]^), @arrn);
     evt_param_types(Z_STRVAL(p[0]^), Z_STRVAL(p[1]^), @arrv);
     ZVAL_ARRAYWS(return_value, arrn, arrv);
    dispose_pzval_array(p);

end;
procedure gui_class_methodList;
var
  p: pzval_array;
  arrv:  TWSDate;
begin
  if ht <> 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);
     listMethodfClass( Z_STRVAL(p[0]^), @arrv );
     ZVAL_ARRAY(return_value, arrv);
    dispose_pzval_array(p);

end;

procedure gui_get_method_params;
var
  p: pzval_array;
  arrn:  TWSDate;
  arrv:  TWSDate;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  zend_get_parameters_my(ht, p, TSRMLS_DC);
getMethodParamsfClass(Z_STRVAL(p[0]^), Z_STRVAL(p[1]^), @arrn, @arrv);
     ZVAL_ARRAYWS(return_value, arrn, arrv);
    dispose_pzval_array(p);

end;
procedure gui_class_method_exist;
var
  p: pzval_array;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);
  //��������� ����� �� �������������,
  //��������� ������ ����� = 0 u 1
  ZVAL_BOOL(return_value, existMethodClass(Z_STRVAL(p[0]^), Z_STRVAL(p[1]^)));

  dispose_pzval_array(p);
end;
procedure gui_method_params;
var
  p: pzval_array;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_STRINGW(return_value, PWideChar(getMethodParamss(Z_STRVAL(p[0]^), Z_STRVAL(p[1]^))), True);

  dispose_pzval_array(p);
end;
procedure  gcreate;
var
  p: pzval_array;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_LONG(return_value, gui_create(Z_STRVAL(p[0]^), Z_LVAL(p[1]^)));

  dispose_pzval_array(p);
end;
procedure gui_get_all_unitsclasses;
var
  arrv: TWSDate;
begin
  if ht <> 0 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  get_all_classes(@arrv);
  ZVAL_ARRAY(return_value, arrv);
end;
procedure ldl;
var
  p: pzval_array;
begin
  if ht <> 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_BOOL(return_value, LoadTypeLib(string(Z_STRVAL(p[0]^))));

  dispose_pzval_array(p);
end;
procedure lbpll;
var
  p: pzval_array;
begin
  if ht <> 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_BOOL(return_value, LoadTypePackage(string(Z_STRVAL(p[0]^))));

  dispose_pzval_array(p);
end;
procedure gpreadable;
var
  p: pzval_array;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_BOOL(return_value, getPropReadable(string(Z_STRVAL(p[0]^)), string(Z_STRVAL(p[1]^))));

  dispose_pzval_array(p);
end;
procedure gpwritable;
var
  p: pzval_array;
begin
  if ht <> 2 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);

  ZVAL_BOOL(return_value, getPropWritable(string(Z_STRVAL(p[0]^)), string(Z_STRVAL(p[1]^))));

  dispose_pzval_array(p);
end;

procedure gui_form_fixdwm;
var
  p: pzval_array;
begin
if ht <> 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_my(ht, p, TSRMLS_DC);
  form_fixwm(THandle(Z_STRVAL(p[0]^)));
  dispose_pzval_array(p);
end;
procedure InitializeGuiProperties(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('gui_propGet', @gui_propGet);
  PHPEngine.AddFunction('gui_propType', @gui_propType);
  PHPEngine.AddFunction('gui_propExists', @gui_propExists);
  PHPEngine.AddFunction('gui_methodList', @gui_methodList);
  PHPEngine.AddFunction('gui_methodExists', @gui_methodExists);
  PHPEngine.AddFunction('gui_methodCall', @gui_methodCall);
  PHPEngine.AddFunction('gui_propList', @gui_propList);
  PHPEngine.AddFunction('gui_class_propList', @gui_class_propList);
  PHPEngine.AddFunction('gui_class_propArray', @gui_class_propArray);
  PHPEngine.AddFunction('gui_propSet', @gui_propSet);
  PHPEngine.AddFunction('gui_get_event_paramss', @gui_get_evt_paramss);
  PHPEngine.AddFunction('gui_get_event_param_names', @gui_get_evt_paramnames);
  PHPEngine.AddFunction('gui_get_event_param_types', @gui_get_evt_paramtypes);
  PHPEngine.AddFunction('gui_get_event_assoc_info', @gui_get_evt_assci);
  PHPEngine.AddFunction('gui_class_methodList', @gui_class_methodList);
  PHPEngine.AddFunction('gui_get_method_params', @gui_get_method_params);
  PHPEngine.AddFunction('gui_method_paramss', @gui_method_params);
  PHPEngine.AddFunction('gui_get_all_unitsclasses', @gui_get_all_unitsclasses);
  PHPEngine.AddFunction('gui_class_prop_isreadable', @gpreadable);
  PHPEngine.AddFunction('gui_class_prop_iswritable', @gpwritable);
  PHPEngine.AddFunction('gui_form_fixdwm', @gui_form_fixdwm);

  PHPEngine.AddFunction('ldtl', @ldl);
  PHPEngine.AddFunction('lbpl', @lbpll);

  PHPEngine.AddFunction('guiccreate', @gcreate);
end;


end.
