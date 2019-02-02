unit propertiesEngine;

interface

uses
  {$IFDEF typelib} System.ShareMem, {$ENDIF}
  SysUtils, WinAPI.Windows,
  Dialogs, Forms, Graphics, Classes, Controls, StdCtrls, TypInfo, Variants,
  mainLCL, RTTI, ZendApi, php4delphi;
function setProperty(id: integer; prop: string; Value: variant): boolean;
function getProperty(id: integer; prop: string): variant;
function existProperty(id: integer; prop: string): boolean;

function existMethod( id: integer; method: string ): boolean;
function existMethodClass( classname: string; method: string ): boolean;
function callMethod(id: integer; method: string; p: array of TValue): variant;
procedure listMethod( id: integer; arr1: PWSDate );
procedure listMethodfClass( classname: string; arr1: PWSDate );
procedure form_fixwm( Handle: THandle );
function evt_params(classname: string; propname: string): String; overload;
function evt_params(id: integer; propname: string): String; overload;
procedure evt_param_names(classname: string; propname: string; arr1: PWSDate);
procedure evt_param_types(classname: string; propname: string; arr1: PWSDate);

function getProperties(id: integer; tktype: integer): string;
function getPropertiesfClass(classname: string; tktype: integer): string;
function isStrInArray(s: string; a:  array of string): Boolean;
procedure getPropertiesfClassArr(classname: string; tktype: integer; arr1: PWSDate; arr2:  PWSDate);
function getPropReadable(classname: string; propname: string): Boolean;
function getPropWritable(classname: string; propname: string): Boolean;
function getPropertyType(id: integer; prop: string): integer;
function getMethodParams(id: integer; method: string): TArray<TTypeKind>;
procedure getMethodParamsfClass(classname: string; method: string; arr1: PWSDate; arr2: PWSDate);
function getMethodParamss(classname: string; method: string): String;
procedure get_all_classes(arr: PWSDate);
procedure get_all_classes_u(arr: PWSDate);
procedure RegisterClassesA(const AClasses: array of TPersistentClass);
procedure RegisterClassA(AClass: TPersistentClass);
procedure RegisterClassAliasA(AClass: TPersistentClass; Alias: string);
function GetConstructor(rType: TRttiType) : TRttiMethod;
function LoadTypeLib(LibraryName: string) : Boolean;
function LoadTypePackage(PackageName: string) : Boolean;
function gui_create(classname: string; owner: NativeUint): NativeUint;

var Regs, TLLoads, BPLoads, Aliases, AliasesKeys: array of string;
implementation
type
  FindType = function(ClassName: string): TRttiType;
  LibModuleListAddres = function(): PLibModule;
procedure form_fixwm(Handle: THandle);
begin
  if Handle <> 0 then
   SetWindowLong(
      Handle,
      GWL_STYLE,
      GetWindowLong(Handle, GWL_STYLE) And Not WS_ClipChildren
    );
end;
function gui_create(classname: string; owner: NativeUint): NativeUint;
var
  c: TRttiType;
  o: TObject;
  instance: TClass;

begin
    Result := 0;
    c := uc.FindType( classname );
    if not Assigned(c) then Exit;

    instance := (c.AsInstance).MetaclassType;

    if not Assigned(instance) then Exit;
    if not Assigned(GetConstructor(c)) then Exit;
    if (owner = -1) or (owner = 0) then
      o := GetConstructor(c).Invoke(instance, [nil]).AsObject
    else
      o := GetConstructor(c).Invoke(instance, [TObject(owner)]).AsObject;
    if owner > 0 then
      c.GetProperty('Parent').SetValue(o, TObject(owner));
    Result := NativeUint( o );
end;
function LoadTypeLib(LibraryName: string) : Boolean;
var
    GetLibM: LibModuleListAddres;
    DllHandle: THandle;
begin
  Result := True;
  ShowMessage(LibraryName);
  try
    if not isStrInArray(LibraryName, TLLoads) then
   begin
    DllHandle := LoadLibrary(PWideChar(LibraryName));
    SetLength(TLLoads, Length(TLLoads)+1);
    TLLoads[High(TLLoads)] := LibraryName;

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
    BPLoads[High(BPLoads)] := PackageName;
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

procedure get_all_classes(arr: PWSDate);
var x: TUnitType;
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
//Sorry, but you're not permited to edit or download this!
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
  Temp: TObject;

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


procedure evt_param_names(classname: string; propname: string; arr1: PWSDate);
type
  PParamFlags = ^TParamFlags;
var
  TypeData: PTypeData;
  Ptr: PByte;
  B: Byte;
  Flags: TParamFlags;
  ParamName: string;
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
  Flags: TParamFlags;
  ParamName: string;
  TypeInfo: PTypeInfo;

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
             arr1^[High(arr1^)] := String(PShortString(Ptr)^);
            end;
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

function existMethodClass( classname: string; method: string ): boolean;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;

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

procedure listMethodfClass( classname: string; arr1: PWSDate );
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  c       : TObject;
  method : TRttiMethod;

begin
  ctx := TRttiContext.Create;
  SetLength(arr1^, 0);
  if Assigned( GetClass(classname) ) then
    lType:=ctx.GetType( GetClass(classname) );

  try
    if Assigned(lType) then
      begin

        for method in  lType.GetMethods() do
        begin
        if not Assigned(method) then Exit;

        if ( ( not isStrInArray(method.Name, arr1^))  and ( not method.Name.IsEmpty ) ) then
          begin
            SetLength(arr1^, Length(arr1^)+1);
            arr1^[High(arr1^)] :=  method.Name;
          end;
        end;

      end
      else
      begin
        SetLength(arr1^, 1);
        arr1^[0] := '';
      end;
  finally
    ctx.Free;
  end;
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
    lType.Free;
    ctx.Free;
  end;
end;

function callMethod(id: integer; method: string; p: array of TValue): variant;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;

begin
  ctx := TRttiContext.Create;

  c   := TObject(integer(id));
  lType:=ctx.GetType(c.ClassInfo);

  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
          if Length(lMethod.GetParameters) = Length(p) then
            Result := lMethod.Invoke(c, p).AsVariant;
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

function getMethodParams(id: integer; method: string): TArray<TTypeKind>;
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;
  x       : TRttiParameter;

begin
  SetLength(Result, 0);
  ctx := TRttiContext.Create;

  c   := TObject(integer(id));
  if not Assigned(c) then Exit;

  lType:=ctx.GetType(c.ClassInfo);
  if not Assigned(lType) then Exit;


  try
    if Assigned(lType) then
      begin
       lMethod:=lType.GetMethod(method);

       if Assigned(lMethod) then
          for x in lMethod.GetParameters do
          begin
              if not Assigned(x) then Exit;

              SetLength(Result, Length(Result)+1);
              Result[High(Result)] := x.ParamType.TypeKind;
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

procedure getMethodParamsfClass(classname: string; method: string; arr1: PWSDate; arr2: PWSDate);
var
  ctx     : TRttiContext;
  lType   : TRttiType;
  lMethod : TRttiMethod;
  c       : TObject;
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
  x       : TRttiParameter;
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


function setProperty(id: integer; prop: string; Value: variant): boolean;
var
  o: TObject;
  inf: PPropInfo;
  oc: TObject;
  intl: integer;
begin
  try
    o := TObject(integer(id));
    inf := TypInfo.GetPropInfo(o, prop);
    if inf <> nil then
    begin
      if inf^.PropType^.Kind in [tkClass, tkClassRef] then
      begin
        intl := Value;
        oc :=  TObject(intl);
        if Assigned(oc) then
        begin
          SetObjectProp(o, prop, oc)
        end
        else
        begin
          Result := False;
          exit;
        end;
      end
      else
      begin
        SetPropValue(o, prop, Value);
      end;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      exit;
    end;
  end;
  Result := inf <> nil;
end;

{function setPObj(id: integer; prop: string; Value: integer): boolean;
var
  o: TObject;
  inf: PPropInfo;
begin
  try
    o := TObject(integer(id));
    inf := TypInfo.GetPropInfo(o, prop);

    if inf <> nil then
      SetObjectProp(o, prop, TObject(Value));
  except
    on E: Exception do
    begin
      Result := False;
      exit;
    end;
  end;
  Result := inf <> nil;
end;          }

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
        Result := GetPropValue(o, prop)
      else
        Result := Null;
  end;
end;

function getPropertyType(id: integer; prop: string): integer;
var
  o: TObject;
  inf: PPropInfo;
begin
  o := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o, prop);
  if inf <> nil then
    Result := integer(inf^.PropType^.Kind)
  else
    Result := -1;
end;

function existProperty(id: integer; prop: string): boolean;
var
  o: TObject;
  inf: PPropInfo;
begin
  o := TObject(integer(id));
  inf := TypInfo.GetPropInfo(o, prop);
  Result := inf <> nil;
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
        end;
    finally
        ctx.Free();
    end;

  Result := res.Text;
  res.Free;
end;
function isStrInArray(s: string; a:  array of string): Boolean;
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
        if not Assigned(rt) then Exit;

        for prop in rt.GetProperties() do begin
            if not Assigned(prop) then Exit;

            if tktype > -1 then
            begin
              if prop.PropertyType.TypeKind <> TTypeKind(tktype) then
                continue;
            end;

            if ( ( not isStrInArray(prop.Name, arr1^))  and ( not prop.Name.IsEmpty ) ) then
            begin

               SetLength( arr1^, Length(arr1^)+1);
               arr1^[High( arr1^)]  := prop.Name;

               SetLength( arr2^, Length( arr2^)+1);
               arr2^[High( arr2^)] := prop.PropertyType.Name;
            end;
        end;
        end;
    finally
        ctx.Free();
    end;

end;
function getPropReadable(classname: string; propname: string): Boolean;
var
 ctx: TRttiContext;
  rt : TRttiType;
  prop : TRttiProperty;
begin
    Result := False;
    ctx := TRttiContext.Create;

        if Assigned(GetClass(classname)) then
        begin
        rt := ctx.GetType(   GetClass( classname ) );
        if( Assigned(rt) ) then
          if( Assigned( rt.GetProperty(propname) ) ) then
            Result := rt.GetProperty(propname).IsReadable;
        end;
        ctx.Free();
end;
function getPropWritable(classname: string; propname: string): Boolean;
var
 ctx: TRttiContext;
  rt : TRttiType;
  prop : TRttiProperty;
begin
    Result := False;
    ctx := TRttiContext.Create;

        if Assigned(GetClass(classname)) then
        begin
        rt := ctx.GetType(   GetClass( classname ) );
        if( Assigned(rt) ) then
          if( Assigned( rt.GetProperty(propname) ) ) then
            Result := rt.GetProperty(propname).IsWritable;
        end;
        ctx.Free();
end;
end.
