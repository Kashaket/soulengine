unit propertiesEngine;
{$I 'sDef.inc'}
{$I PHP.inc}
interface

uses
  {$IFDEF typelib} System.ShareMem, {$ENDIF}
  SysUtils, WinAPI.Windows,
  Dialogs, Forms, Graphics, Classes, Controls, StdCtrls, TypInfo, Variants,
  mainLCL, RTTI, ZendApi, UnitClass, php4delphi, ZENDTypes
  ;
function setProperty(id: integer; prop: string; Value: variant): boolean;
function getProperty(id: integer; prop: string): variant;
function existProperty(id: integer; prop: string): boolean;
function ValueFromVariant(V: Variant; Kind: TTypeKind): TValue;
function VariantFromValue(v: TValue): Variant;
function existMethod( id: integer; method: string ): boolean;
function hasRType( id: integer; method: string ): boolean;
function existMethodClass( classname: string; method: string ): boolean;
function callMethod(id: integer; method: string; p: array of TValue): TValue;
procedure listMethod( id: integer; arr1: PWSDate );
procedure listMethodfClass( classname: string; arr2: PWSDate; arr1: PWSDate );
function evt_params(classname: string; propname: string): String; overload;
function evt_params(id: integer; propname: string): String; overload;
procedure evt_param_names(classname: string; propname: string; arr1: PWSDate);
procedure evt_param_types(classname: string; propname: string; arr1: PWSDate);

function getProperties(id: integer; tktype: integer): string;
function getPropertiesfClass(classname: string; tktype: integer): string;
function isStrInArray(s: string; a:  TWSDate): Boolean; overload;
procedure getPropertiesfClassArr(classname: string; tktype: integer; arr1: PWSDate; arr2:  PWSDate);
function getPropReadable(classname: string; propname: string): Boolean;
function getPropWritable(classname: string; propname: string): Boolean;
function getPropertyType(id: integer; prop: string): integer;
function getMethodParams(id: integer; method: string): System.TArray<TRttiParameter>;
procedure getMethodParamsfClass(classname: string; method: string; arr1: PWSDate; arr2: PWSDate);
function getMethodParamss(classname: string; method: string): String;
procedure get_all_classes(arr: PWSDate);
procedure get_all_classes_u(arr: PWSDate);
procedure RegisterClassesA(const AClasses: array of TPersistentClass);
procedure RegisterClassA(AClass: TPersistentClass);
procedure RegisterClassAliasA(AClass: TPersistentClass; Alias: string);
procedure RegisterClassAliasesA(AClass: TPersistentClass; Classes: array of string);
function GetConstructor(rType: TRttiType) : TRttiMethod;
function LoadRTL(RTLPath: String): Boolean;
function RTLLoaded(RTLName: String): Boolean;
procedure getEnumPropValues(classname, prop: string; arr1, arr2: PWSDate);
var Regs, TLLoads, BPLoads, Aliases, AliasesKeys: TWSDate;
implementation
type
  FindType = function(ClassName: string): TRttiType;
  LibModuleListAddres = function(): PLibModule;
  //var uc: TUnitClass;
{
function gui_set_event(id: integer; value: string): Boolean;
var hobj: TObject;
begin
  Result := False;
  hobj := TObject(id);
  if Assigned(hobj) then
     Result := HEventObj.EAdd(hobj, 'OnKeyPress',
    procedure(Base: TEventObject; Params: TArray<TValue>)
    begin
      //Inc(Params[0].AsObject.ClassName, Base.EventName);
    end);
end;}

function RTLLoaded(RTLName: string): Boolean;
var RTL: String;
begin
  RTL := ExtractFileName(RTLName);
  Result := isStrInArray(RTL, TLLoads) or isStrInArray(RTL, BPLoads);
end;
function LoadTypeLib(LibraryName: string) : Boolean;
var
    GetLibM: LibModuleListAddres;
    DllHandle: THandle;
begin
  Result := True;
  try
    if not isStrInArray(LibraryName, TLLoads) then
   begin
    DllHandle := LoadLibrary(PWideChar(LibraryName));
    SetLength(TLLoads, Length(TLLoads)+1);
    TLLoads[High(TLLoads)] := ExtractFileName(LibraryName);

    if( DllHandle = 0 ) or ( DllHandle = null ) then
    begin
      Result := False;
      Exit;
    end;

    Pointer(@GetLibM) := getprocaddress(DllHandle, 'LibModuleListAddres');

    RegisterModule(GetLibM());
    end;
  except
    on E: Exception do begin
      Result := False;
      Exit;
    end;
  end;
end;
function LoadTypePackage(PackageName: string) : Boolean;
var BPLHandle: THandle;
begin
  Result := True;
  try
    if not isStrInArray(PackageName, BPLoads) then
   begin
    BPLHandle := LoadPackage(PackageName);
    SetLength(BPLoads, Length(BPLoads)+1);
    BPLoads[High(BPLoads)] := ExtractFileName(PackageName);
    if( BPLHandle = 0 ) or ( BPLHandle = null ) then
    begin
      Result := False;
      Exit;
    end;
   end;
   except
    on E: Exception do begin

      ShowMessage( E.ClassName + ': ' + E.Message );
      Result := False;
      Exit;
    end;
   end;
end;

function LoadRTL(RTLPath: string): Boolean;
begin
  Result := False;
  if RTLPath.EndsWith('.bpl', True) then
    Result := LoadTypePackage(RTLPath)
  else if RTLPath.EndsWith('.dll', True) then
       Result := LoadTypeLib(RTLPath);
end;

function GetConstructor(rType: TRttiType) : TRttiMethod;
var
  MaxParams:  integer;
  Methods:    TArray<TRttiMethod>;
  Method:     TRttiMethod;
  Params:     TArray<TRttiParameter>;
begin
  Methods := rType.GetMethods('Create');
  MaxParams := 0;
  for Method in Methods do begin
    Params := Method.GetParameters();
    if (Length(Params) > MaxParams) then begin
      Result := Method;
      MaxParams := Length(Params);
    end;
  end;
end;

procedure RegisterClassesA(const AClasses: array of TPersistentClass);
var
  I: Integer;
begin
  for I := Low(AClasses) to High(AClasses) do begin
    RegisterClass(AClasses[I]);
    SetLength(Regs, Length(Regs)+1);
    Regs[High(Regs)] := AClasses[I].ClassName;
  end;
end;

procedure RegisterClassA(AClass: TPersistentClass);
begin
  RegisterClass(AClass);
  SetLength(Regs, Length(Regs)+1);
  Regs[High(Regs)] := AClass.ClassName;
end;

procedure RegisterClassAliasA(AClass: TPersistentClass; Alias: string);
begin
     RegisterClassAlias(AClass, Alias);
     SetLength(AliasesKeys, Length(AliasesKeys)+1);
     AliasesKeys[High(AliasesKeys)] := Alias;
     SetLength(Aliases, Length(Aliases)+1);
     Aliases[High(Aliases)] := AClass.UnitName + '.' + AClass.ClassName;
end;
procedure RegisterClassAliasesA(AClass: TPersistentClass; Classes: array of string);
  var
  I: Integer;
begin
  for I := Low(Classes) to High(Classes) do begin
    RegisterClassAliasA(AClass, Classes[I]);
  end;
end;
procedure get_all_classes(arr: PWSDate);
var //x: TUnitType;
s: String;
I, b: integer;
begin
  SetLength(arr^, 0);
  for s in Regs do
  begin
      SetLength(arr^, Length(arr^)+1);
      b := -1;
       for I := 0 to Length(AliasesKeys)-1 do
        if AliasesKeys[I] = s then
          b := I;
       if b > -1 then
        begin
          arr^[High(arr^)] := Aliases[b];
        end
        else
        begin
          arr^[High(arr^)] := s;
        end;

  end;
end;

procedure get_all_classes_u(arr: PWSDate);
var x: TUnitType;
begin
    for x in UnitClass.TClassUnits.GetList do
  begin
      SetLength(arr^, Length(arr^)+1);
      arr^[High(arr^)] := x.lowerName2;

  end;
end;
function evt_params(classname: string; propname: string): String; overload;
type
  PParamFlags = ^TParamFlags;
var
  TypeData: PTypeData;
  Ptr: PByte;
  b: integer;
  Flags: TParamFlags;
  ParamName: string;
  TypeInfo: PTypeInfo;

begin

          if not ( Assigned( GetClass(classname) ) ) then begin
           Result := '!';
           Exit;
          end;


          if not ( Assigned( GetPropInfo( GetClass(classname), propname) ) ) then begin
           Result := '!';
           Exit;
          end;

          if not ( Assigned(GetPropInfo( GetClass(classname), propname).PropType) ) then begin
           Result := '!';
           Exit;
          end;

            TypeInfo := GetPropInfo( GetClass(classname), propname)^.PropType^;
          Result := '';
          ParamName := '';
           if not Assigned(TypeInfo) or (TypeInfo^.Kind <> tkMethod) then Exit;
          TypeData := GetTypeData(TypeInfo);
          if not Assigned(TypeData) then Exit;
           Ptr := PByte(@TypeData^.ParamList);
           if TypeData^.ParamCount > 0 then
          begin
           for b := 0 to TypeData^.ParamCount-1 do
           begin

             if (b > 0) and (TypeData^.ParamCount > 1) then Result := Result + ', ';
              Flags := PParamFlags(Ptr)^;
              ParamName := '$';
              Inc(Ptr, SizeOf(TParamFlags));
              if pfVar in Flags then Result := Result;
              if pfConst in Flags then Result := Result + 'constant ';
              if pfArray in Flags then Result := Result + 'array ';
              if pfOut in Flags then Result := Result + '&';
              if pfAddress in Flags then ParamName := '&$';

             ParamName := ParamName + String(PShortString(Ptr)^);

             Inc(Ptr, 1 + Length(PShortString(Ptr)^));
             if Length(PShortString(Ptr)^) > 0 then Result := Result +
             String(PShortString(Ptr)^);
             Result := Result + ' ' + ParamName;
             Inc(Ptr, 1 + Length(PShortString(Ptr)^));
            end;
          end
          else
          begin
            Result := 'void';
          end;
end;
 
function evt_params(id: integer; propname: string): String; overload;
type
  PParamFlags = ^TParamFlags;
var
  TypeData: PTypeData;
  Ptr: PByte;
  b: integer;
  Flags: TParamFlags;
  ParamName: string;
  TypeInfo: PTypeInfo;

begin
          if not ( Assigned( TObject(id) ) ) then begin
           Result := '!';
           Exit;
          end;
          if not ( Assigned( GetPropInfo(TObject(id), propname) ) ) then begin
           Result := '!';
           Exit;
          end;

            TypeInfo := GetPropInfo(TObject(id), propname)^.PropType^;
          Result := '';
          ParamName := '';
           if not Assigned(TypeInfo) or (TypeInfo^.Kind <> tkMethod) then Exit;

          TypeData := GetTypeData(TypeInfo);
          if not Assigned(TypeData) then Exit;
           Ptr := PByte(@TypeData^.ParamList);
          try
           if TypeData^.ParamCount > 0 then
          begin
           for b := 0 to TypeData^.ParamCount-1 do
           begin

             if (b > 0) and (TypeData^.ParamCount > 1) then Result := Result + ', ';
              Flags := PParamFlags(Ptr)^;
              ParamName := '$';
              Inc(Ptr, SizeOf(TParamFlags));
              if pfVar in Flags then Result := Result;
              if pfConst in Flags then Result := Result + 'constant ';
              if pfArray in Flags then Result := Result + 'array ';
              if pfOut in Flags then Result := Result + '&';
              if pfAddress in Flags then ParamName := '&$';

             ParamName := ParamName + String(PShortString(Ptr)^);

             Inc(Ptr, 1 + Length(PShortString(Ptr)^));
             if Length(PShortString(Ptr)^) > 0 then Result := Result +
             String(PShortString(Ptr)^);
             Result := Result + ' ' + ParamName;
             Inc(Ptr, 1 + Length(PShortString(Ptr)^));
            end;
          end
          else
          begin
            Result := 'void';
          end;
          except
            on E: exception do
            Result := '!';
          end;
end;


procedure evt_param_names(classname: string; propname: string; arr1: PWSDate);
type
  PParamFlags = ^TParamFlags;
var
  TypeData: PTypeData;
  Ptr: PByte;
  B: Byte;
  Flags: TParamFlags;
  TypeInfo: PTypeInfo;
  Result: string;

begin
    SetLength(arr1^, 0);
          if( Assigned( GetClass( classname ) ) ) then
            TypeInfo := GetPropInfo( GetClass( classname ), propname)^.PropType^;
           if not Assigned(TypeInfo) or (TypeInfo^.Kind <> tkMethod) then Exit;

          TypeData := GetTypeData(TypeInfo);
           Ptr := PByte(@TypeData^.ParamList);
           if TypeData^.ParamCount > 0 then
          begin
           for b := 0 to TypeData^.ParamCount-1 do
           begin
             SetLength(arr1^, Length(arr1^) + 1);
              Result := '';
              Flags := PParamFlags(Ptr)^;
              Inc(Ptr, SizeOf(TParamFlags));
              if pfConst in Flags then Result := Result + 'constant ';
              if pfArray in Flags then Result := Result + 'array of ';
             Inc(Ptr, 1 + Length(PShortString(Ptr)^));
             if Length(PShortString(Ptr)^) > 0 then Result := Result +
             String(PShortString(Ptr)^);

             Inc(Ptr, 1 + Length(PShortString(Ptr)^));
             arr1^[High(arr1^)] := Result;
            end;
          end;
end;

procedure evt_param_types(classname: string; propname: string; arr1: PWSDate);
type
  PParamFlags = ^TParamFlags;
var
  TypeData: PTypeData;
  Ptr: PByte;
  B: Byte;
  TypeInfo: PTypeInfo;
  S: string;
begin
    SetLength(arr1^, 0);
          if( Assigned( GetClass( classname ) ) ) then
            TypeInfo := GetPropInfo( GetClass( classname ), propname)^.PropType^;
           if not Assigned(TypeInfo) or (TypeInfo^.Kind <> tkMethod) then Exit;

          TypeData := GetTypeData(TypeInfo);
           Ptr := PByte(@TypeData^.ParamList);
           if TypeData^.ParamCount > 0 then
          begin
           for b := 0 to TypeData^.ParamCount-1 do
           begin
             Inc(Ptr, SizeOf(TParamFlags));
             SetLength(arr1^, Length(arr1^) + 1);
             S := String(PShortString(Ptr)^);
             if S = 'Sender' then
              arr1^[High(arr1^)] := '$self'
             else
              arr1^[High(arr1^)] :=  '$' + LowerCase(S);

              Inc(Ptr, 1 + Length(PShortString(Ptr)^));
              Inc(Ptr, 1 + Length(PShortString(Ptr)^));
            end;
          end;
end;

function hasRType( id: integer; method: string ): boolean;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;

begin
  Result := False;
  ctx := TRttiContext.Create;

  c   := TObject(integer(id));
  lType:=ctx.GetType(c.ClassInfo);

  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned( lMethod.ReturnType )  then
       if lMethod.ReturnType.TypeKind <> tkUnknown then
       begin
        Result := True;
       end;
      end;
  finally
  if Assigned(lType) then
  begin
    lType.Free;
  if Assigned(lMethod) then
    lMethod.Free;
  end;
    ctx.Free;
  end;
end;

function existMethod( id: integer; method: string ): boolean;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;

begin
  Result := False;
  ctx := TRttiContext.Create;

  c   := TObject(integer(id));
  lType:=ctx.GetType(c.ClassInfo);

  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
       begin
        Result := True;
       end;
      end;
  finally
  if Assigned(lType) then
  begin
    lType.Free;
  if Assigned(lMethod) then
    lMethod.Free;
  end;
    ctx.Free;
  end;
end;

function existMethodClass( classname: string; method: string ): boolean;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;

begin
  Result := False;
  ctx := TRttiContext.Create;
  if Assigned(GetClass(classname)) then

  lType:=ctx.GetType( GetClass(classname) );

  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
       begin
        Result := True;
       end

      end;
  finally
  if Assigned(lType) then
  begin
    lType.Free;
  if Assigned(lMethod) then
    lMethod.Free;
  end;
    ctx.Free;
  end;
end;

procedure listMethodfClass( classname: string; arr2: PWSDate; arr1: PWSDate );
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  method  : TRttiMethod;
  apr     : System.TArray<Rtti.TRttiParameter>;
  param   : TRttiParameter;
  params  : string;
  I,L     : Byte;
  isesc: boolean;
begin
  ctx := TRttiContext.Create;
  SetLength(arr1^, 0);
  SetLength(arr2^, 0);
  if not Assigned( GetClass(classname) ) then EXIT;
    lType:=ctx.GetType( GetClass(classname) );
    if Assigned(lType) then
      begin
        try


        for method in  lType.GetMethods() do
        begin
        if method = nil then Exit;

        if ( ( not isStrInArray(method.Name, arr2^))  and ( not method.Name.IsEmpty ) )
         then
          begin
          apr := method.GetParameters;

            SetLength(arr1^, Length(arr1^)+1);
            SetLength(arr2^, Length(arr2^)+1);
            arr2^[High(arr2^)] := method.Name;
            if not Assigned(apr) then begin
             arr1^[High(arr1^)] := '( void )';
              continue;
            end;

            if length(apr) > 0 then
            begin
                try
                  params := '( ';
                  I := 0;
                  L := Length(apr) - 1;
                    for param in apr do
                    begin
                      if param = nil then begin
                        exit;
                      end;
                      if param.ParamType = nil then
                      begin
                        isesc := True;
                        break;
                      end else isesc := False;
                      params := params + param.ParamType.ToString;
                      if param.Flags * [pfVar, pfOut] <> [] then
                        params := params + ' &'
                      else
                        params := params + ' ';
                        params := params + param.Name;
                      if I < L then
                      params := params + ', ';
                      I := I + 1;
                    end;
                  params := params + ' )';
                  if isesc then begin
                     arr1^[High(arr1^)] := '( void )';
                     continue;
                  end;

                  arr1^[High(arr1^)] := params;
                except
                 on E: exception do
                 begin
                 ShowMessage('Very bad error' + #10 + #13 +
                    'Method Name:' + method.Name + #10 + #13 +
                    'Method Kind:' + inttostr(integer(method.MethodKind)) +#10 + #13
                 +  'Method Visibility:' + inttostr(integer(method.Visibility)) +#10 + #13
                 +  'Has Extended Info:' + BoolToStr(method.HasExtendedInfo,true)+#10+ #13
                 +  'Is Static:' + BoolToStr(method.IsStatic,true)+#10+#13
                 +  'Dispatch Kind:' + inttostr(integer(method.DispatchKind)) +#10 + #13
                 +  'Is Class Method:' + BoolToStr(method.IsClassMethod,true)+#10+#13
                 +  'CallConv:' + inttostr(integer(method.CallingConvention))+#10+#13
                );
                ShowMessage( E.Message );
                    SetLength(arr2^, Length(arr2^)-1);
                    SetLength(arr1^, Length(arr1^)-1);
                 end;

                end;
            end else
                arr1^[High(arr1^)] := '( void )';

          end;
        end;
        except
         on E: exception do
         begin
         ShowMessage( E.Message );
           SetLength(arr2^, Length(arr2^)-1);
           SetLength(arr1^, Length(arr1^)-1);
         end;
        end;
      end;
  ctx.Free;
end;

procedure listMethod( id: integer; arr1: PWSDate );
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  c       : TObject;
  method : TRttiMethod;

begin
  ctx := TRttiContext.Create;
  SetLength(arr1^, 0);
  c   := TObject(integer(id));
  lType:=ctx.GetType(c.ClassInfo);

  try
    if Assigned(lType) then
      begin

        for method in  lType.GetMethods() do
        if ( ( not isStrInArray(method.Name, arr1^))  and ( not method.Name.IsEmpty ) ) then
          begin
            SetLength(arr1^, Length(arr1^)+1);
            arr1^[High(arr1^)] :=  method.Name;
          end;

      end
      else
      begin
        SetLength(arr1^, 1);
        arr1^[0] := '';
      end;
  finally
   if Assigned(lType) then
    lType.Free;
    ctx.Free;
  end;
end;

function VariantFromValue(v: TValue): Variant;
begin
   case v.Kind of
            tkInteger:
              Result := v.AsInteger;
            tkEnumeration:
              Result := zend_ustr( v.ToString );
            tkInt64:
              Result := v.AsInt64;
            tkWChar:
              Result := v.AsType<WideChar>;
            tkChar:
              Result := v.AsType<AnsiChar>;
            tkFloat:
              Result := v.AsExtended;
            tkString:
              Result := String(v.AsType<ShortString>);
            tkUString:
              Result := v.AsType<UTF8String>;
            tkClass:
              Result := integer( v.AsObject );
            tkPointer:
              Result := integer( v.AsType<Pointer> );
            tkAnsiString:
              Result := v.AsType<AnsiString>;
            tkWString:
              Result := v.AsType<WideString>;
            tkVariant:
              Result := v.AsVariant;
            end;
end;
function ValueFromVariant(V: Variant; Kind: TTypeKind): TValue;
begin
    if VarType(V) = varNull then
      Result := Result.Empty;
   case Kind of
            tkInteger:
              Result := Result.From<integer>( integer(V) );
            tkInt64:
              Result := Result.From<int64>( Int64(V) );
            tkWChar:
              Result := Result.From<WideChar>( WideString(zend_ustr(V))[1] );
            tkAnsiChar:
              Result := Result.From<AnsiChar>( AnsiString(zend_ustr(V))[1] );
            tkFloat:
              Result := Result.From<Extended>( Extended(V) );
            tkString:
              Result := Result.From<ShortString>( ShortString(V) );
            tkClass:
              Result := Result.From<TObject>( TObject( integer( V ) ) );
            tkUString:
              Result := Result.From<Utf8String>( zend_ustr(V) );
            tkPointer:
              Result := Pointer( integer( V ) );
            tkAnsiString:
              Result := Result.From<AnsiString>( AnsiString(zend_ustr(V)) );
            tkWString:
              Result := Result.From<WideString>( WideString(zend_ustr(V)) );
            tkEnumeration:
              Result := Result.From<String>( zend_ustr(V) );
            tkVariant:
              Result := Result.FromVariant(V)
            end;
end;

function callMethod(id: integer; method: string; p: array of TValue): TValue;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;
begin
  Result := TValue.Empty;
  ctx := TRttiContext.Create;
  c   := TObject(integer(id));
  lType:=ctx.GetType(c.ClassInfo);
  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
       begin
              Result := lMethod.Invoke(c, p);
       end;
      end;
  finally
  if Assigned(lType) then
  begin
      lType.Free;
    if Assigned(lMethod) then
      lMethod.Free;
  end;
    ctx.Free;
  end;
end;

function getMethodParams(id: integer; method: string): System.TArray<TRttiParameter>;
label x1;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;

begin
  ctx := TRttiContext.Create;

  c   := TObject(integer(id));
  if not Assigned(c) then goto x1;

  lType:=ctx.GetType(c.ClassInfo);
  if not Assigned(lType) then goto x1;
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
          Result := lMethod.GetParameters;
       lType.Free;
      end;
x1:
  ctx.Free;
end;

procedure getMethodParamsfClass(classname: string; method: string; arr1: PWSDate; arr2: PWSDate);
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  x       : TRttiParameter;
  params  : TArray<TRttiParameter>;

begin
  ctx := TRttiContext.Create;
  SetLength(arr1^, 0);
  SetLength(arr2^, 0);
  if( Assigned(GetClass(classname)) ) then
    lType:=ctx.GetType(GetClass(classname));
  if not Assigned(lType) then Exit;

  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
        if not lMethod.IsConstructor then
        begin
        params := lMethod.GetParameters;
        if not Assigned( params ) then Exit;
          for x in params do
          begin
          if not Assigned(x) then Exit;

          if (not x.Name.IsEmpty) then
            begin
              SetLength(arr1^, Length(arr1^)+1);
              arr1^[High(arr1^)] := x.Name;

              SetLength(arr2^, Length(arr2^)+1);
              arr2^[High(arr2^)] := x.ParamType.ToString();
            end;
          end;
        end;
      end;
  finally
    ctx.Free();
  end;
end;

function getMethodParamss(classname: string; method: string): String;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  b       : integer;
  x       : Rtti.TRttiParameter;
  ParamName: String;
  params: TArray<TRttiParameter>;

begin
  Result := 'void';
  ctx := TRttiContext.Create;
  b   := 0;
  if( Assigned(GetClass(classname)) ) then
    lType:=ctx.GetType(GetClass(classname));
  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
       begin
        if lMethod.IsStatic or lMethod.IsConstructor or lMethod.IsDestructor then
          begin
            Result := '!';
            Exit;
          end;
       end
       else
       BEGIN

          params := lMethod.GetParameters;
          if not Assigned(params) then
            Exit;

          for x in params do
          begin
          if not Assigned(x) then Exit;

          if (not x.Name.IsEmpty) then
            begin
              ParamName := '$';
              if (b > 0) and (Length(params)>1) then Result := Result + ', ';
              b := b + 1;

              if pfConst in x.Flags then Result := Result + 'constant ';
              if pfArray in x.Flags then Result := Result + 'array ';
              if pfOut in x.Flags then Result := Result + '&';
              if pfAddress in x.Flags then ParamName := '&$';
              if not Assigned(x.ParamType) then Exit;

              Result := Result + x.ParamType.ToString() + ' ' + ParamName + x.Name;
            end;
          end;
      end;
      end;
  finally
    ctx.Free();
  end;
end;

{$IFDEF NEWRTTI}
function getProperty2(id: integer; prop: string): variant;
var
  o: TObject;
  inf: TRTTIType;
  ctx: TRTTIContext;
  p: TRttiProperty;
  v: TValue;
begin
  o := TObject(integer(id));
  Result := Null;
  if Assigned(o) then
  begin
    ctx := RTTI.TRttiContext.Create;

    inf := ctx.GetType(o.ClassType);
      if Assigned(inf) then
      begin
        p := Inf.GetProperty(prop);
        if Assigned(p) then
        begin
          v := p.GetValue(o);
          if v.Kind = tkEnumeration then
          begin
            Result := VariantFromValue(v);//GetDynArrayProp(o, prop);
          end
          else
          begin
            Result := VariantFromValue(v);
          end;
          p.Free;
          inf.Free;
          end;
      end;
      ctx.Free;
  end;
end;
function setProperty2(o: TObject; prop: string; value: Variant): boolean;
var
  inf: TRTTIType;
  ctx: TRTTIContext;
  p: TRttiProperty;
begin
  Result := False;
  if Assigned(o) then
  begin
  try
    ctx := RTTI.TRttiContext.Create;
    if not Assigned(GetClass(o.ClassName)) then begin
                                                ctx.Free;
                                                Exit;
                                                end;

    inf := ctx.GetType(o.ClassType);
      if Assigned(inf) then
      begin
        p := Inf.GetProperty(prop);
        if Assigned(p) then begin
            {if prop = 'HintColor' then
              ShowMessage( inttostr( integer( p.PropertyType.TypeKind ) ) );
           }if p.IsWritable then
              if p.PropertyType.TypeKind in [ tkInteger, tkInt64 ,  tkWChar
            ,tkChar, tkFloat, tkString, {tkClass, tkPointer,} tkUString, tkAnsiString,
            tkWString {, tkVariant}] then
              p.SetValue(o, ValueFromVariant(value, p.PropertyType.TypeKind))
              else if p.PropertyType.TypeKind in [ tkClass, tkClassRef ] then
              if VarType(value) = varNull then
                 p.SetValue(o, TValue.From<TObject>(nil))
              else
              p.SetValue(o, TValue.From<TObject>(TObject(integer(value))));
            Result := True;
            p.Free;
          end;
          inf.Free;
      end;
  except
    on E:exception do
    begin
      ctx.Free;
      Exit;
    end;
  end;
  end;
end;
{$ENDIF}
function setProperty(id: integer; prop: string; Value: variant): boolean;
var
  o: TObject;
  inf: PPropInfo;
  oc: TObject;
begin
Result := False;
o := TObject(id);
if not Assigned(o) then Exit;
  try

    inf := TypInfo.GetPropInfo(o, prop);
    if inf <> nil then
    begin
      Result := True;
      if inf^.PropType^.Kind in [tkClass, tkClassRef] then
      begin
        if VarType(Value) = varNull then
        begin
          oc := nil;
        end else
        if VarType(Value) = varString then
          oc := TObject(StrToInt(String(Value)))
        else
        begin
          oc := TObject(Integer(Value));
        end;
        SetObjectProp(o, prop, oc);
      end
      else
        SetPropValue(o, prop, Value);
      inf := nil;
    end {$IFDEF NEWRTTI}else Result:=setProperty2(o, prop, Value){$ENDIF};
  except
    on E: Exception do
    begin
      inf := nil;
      Result := False;
    end;
  end;
end;
function getProperty(id: integer; prop: string): variant;
var
  o: TObject;
  inf: PPropInfo;
begin
  o := TObject(integer(id));
  if Assigned(o) then
  begin
    inf := TypInfo.GetPropInfo(o, prop);
      if inf <> nil then
      begin
        Result := GetPropValue(o, prop);
        inf := nil;
      end
      else
        Result := {$IFDEF NEWRTTI}getProperty2(id, prop){$ELSE}Null{$ENDIF};
  end;
end;
procedure getEnumPropValues(classname, prop: string; arr1, arr2: PWSDate);
var a:  TRttiOrdinalType;
ab: PTypeInfo;
e: TRttiField;
var i: integer;
  ctx: TRttiContext;
  p: TRttiProperty;
begin
    SetLength(arr1^, 0);
    SetLength(arr2^, 0);
    ctx :=  TRttiContext.Create();
    p := ctx.GetType(GetClass(classname)).GetProperty(prop);
   if p <> nil then
   begin
     if Assigned(p.PropertyType) then
     begin
      if p.PropertyType.IsOrdinal then
      begin
        a := p.PropertyType.AsOrdinal;
        for I := a.MinValue to a.MaxValue do
        begin
          SetLength(arr1^, Length(arr1^) + 1);
          SetLength(arr2^, Length(arr2^) + 1);
          arr1^[High(arr1^)] := GetEnumName( a.Handle, I );
          arr2^[High(arr2^)] := inttostr(I);
        end;
      end
      else if p.PropertyType.IsSet then
      begin
        ab := p.PropertyType.AsSet.Handle.TypeData.CompType^;
        for I:= ab.TypeData.MinValue to ab.TypeData.MaxValue do
        begin
          SetLength(arr1^, Length(arr1^) + 1);
          SetLength(arr2^, Length(arr2^) + 1);
          arr1^[High(arr1^)] := GetSetElementName(ab, I);
          arr2^[High(arr2^)] := IntToStr(I);
        end;
      end else if p.PropertyType.IsRecord then
      begin
        for e in p.PropertyType.AsRecord.GetFields do
        begin
          SetLength(arr1^, Length(arr1^) + 1);
          SetLength(arr2^, Length(arr2^) + 1);
          arr1^[High(arr1^)] := e.Name;
          arr2^[High(arr2^)] := inttostr(integer(e.FieldType.TypeKind));
        end;
      end;

     end;
      p.Free;
   end;
   ctx.Free;
end;
function getPropertyType(id: integer; prop: string): integer;
var
  o: TObject;
  inf: PPropInfo;
  ctx: TRttiContext;
  p: TRttiProperty;
begin
Result := -1;
  o := TObject(integer(id));
  if not Assigned(o) then Exit;
  if prop = 'owner' then  Exit;

  inf := TypInfo.GetPropInfo(o, prop);
  if inf <> nil then
    Result := integer(inf^.PropType^.Kind)
  else
  begin
    ctx :=  TRttiContext.Create();
    p := ctx.GetType(o.ClassType).GetProperty(prop);
   if p <> nil then
   begin
     if Assigned(p.PropertyType) then
     begin
      Result := integer(p.PropertyType.TypeKind);
     end;
      p.Free;
   end;
   ctx.Free;
  end;
  inf := nil;
end;

function existProperty(id: integer; prop: string): boolean;
var
  o: TObject;
  ctx: TRTTIContext;
begin
  Result := False;
  o := TObject(integer(id));
  if o = nil then exit;
  ctx := TRttiContext.Create();
  //inf := TypInfo._InternalGetPropInfo(o.ClassInfo, prop);
  Result := (TypInfo.GetPropInfo(o, prop) <> nil) or (ctx.GetType(o.ClassType).GetProperty(prop) <> nil);
  ctx.Free();
end;

function getProperties(id: integer; tktype: integer): string;
var
  o: TObject;
 ctx: TRttiContext;
  rt : TRttiType;
  prop : TRttiProperty;
  res: TStrings;
begin
    o := TObject(integer(id));
    ctx := TRttiContext.Create;
    res := TStringList.Create;
    res.Clear;
    try
        rt := ctx.GetType(o.ClassType);
        if Assigned(rt) then
        begin
        for prop in rt.GetProperties() do begin
            if not prop.IsWritable then continue;
            if tktype > -1 then
            begin
              if prop.PropertyType.TypeKind <> TTypeKind(tktype) then
                continue;
            end;
            if (res.IndexOf( prop.Name ) = -1) and (not prop.Name.IsEmpty) then
              res.Add(prop.Name);
        end;
        rt.Free;
        end;
    finally
        ctx.Free();
    end;

  Result := res.Text;
  res.Free;
end;

function getPropertiesfClass(classname: string; tktype: integer): string;
var
 ctx: TRttiContext;
  rt : TRttiType;
  prop : TRttiProperty;
  res: TStrings;
begin
    ctx := TRttiContext.Create;
    res := TStringList.Create;

    try
        if Assigned(GetClass(classname)) then
        begin
        rt := ctx.GetType(   GetClass( classname ) );
        if Assigned(rt) then
        begin
        for prop in rt.GetProperties() do begin
            if not prop.IsWritable then continue;
            if tktype > -1 then
            begin
              if prop.PropertyType.TypeKind <> TTypeKind(tktype) then
                continue;
            end;
            if (res.IndexOf( prop.Name ) = -1) and (not prop.Name.IsEmpty) then
              res.Add(prop.Name);
        end;
        rt.Free;
        end;
        end;
    finally
        ctx.Free();
    end;

  Result := res.Text;
  res.Free;
end;
function isStrInArray(s: string; a:  TWSDate): Boolean;
var e: string;
begin
  Result := False;
  if Length(a) = 0 then
      Exit;

  for e in a do
    if e = s then
    begin
      Result := True;
      Exit;
    end;
end;
procedure getPropertiesfClassArr(classname: string; tktype: integer; arr1:  PWSDate; arr2: PWSDate);
var
 ctx: TRttiContext;
  rt : TRttiType;
  prop : TRttiProperty;
begin
    ctx := TRttiContext.Create;
      SetLength(arr1^, 0);
      SetLength(arr2^, 0);
    try
        if Assigned(GetClass(classname)) then
        begin
        rt := ctx.GetType(   GetClass( classname ) );
        if not Assigned(rt) then begin
                                   rt.Free;
                                   Exit;
                                 end;
        for prop in rt.GetProperties() do begin
            if not Assigned(prop) then begin
                                   rt.Free;
                                   Exit;
                                 end;
            if not Assigned(prop.PropertyType) then Continue;

            if tktype > -1 then
            begin
              if integer(prop.PropertyType.TypeKind) <> tktype then
                continue;
            end;

            if ( ( not prop.Name.IsEmpty ) and ( not isStrInArray(prop.Name, arr1^)) ) then
            begin

               SetLength( arr1^, Length(arr1^)+1);
               arr1^[High( arr1^)]  := prop.Name;

               SetLength( arr2^, Length( arr2^)+1);
               arr2^[High( arr2^)] := prop.PropertyType.Name;
            end;
        end;
        rt.Free;
        end;
    except
      on E: exception do
      begin
        ctx.Free;
        SetLength(arr1^, 0);
        SetLength(arr2^, 0);
        Exit;
      end;
    end;
    ctx.Free;
end;
function getPropReadable(classname: string; propname: string): Boolean;
var
 ctx: TRttiContext;
  rt : TRttiType;
begin
    Result := False;
    ctx := TRttiContext.Create;

        if Assigned(GetClass(classname)) then
        begin
        rt := ctx.GetType(   GetClass( classname ) );
        if( Assigned(rt) ) then
        begin
          if( Assigned( rt.GetProperty(propname) ) ) then
            Result := rt.GetProperty(propname).IsReadable;
          rt.Free;
        end;
        end;
        ctx.Free();
end;
function getPropWritable(classname: string; propname: string): Boolean;
var
 ctx: TRttiContext;
  rt : TRttiType;
begin
    Result := False;
    ctx := TRttiContext.Create;

        if Assigned(GetClass(classname)) then
        begin
        rt := ctx.GetType(   GetClass( classname ) );
        if( Assigned(rt) ) then
        begin
          if( Assigned( rt.GetProperty(propname) ) ) then
            Result := rt.GetProperty(propname).IsWritable;
            rt.Free;
        end;
        end;
        ctx.Free();
end;

end.
