unit UnitClass;

interface

uses Windows, Generics.Collections, Rtti, TypInfo, System.SysUtils, vcl.dialogs;

Type
  UnitArray = array of UTF8String;

  TUnitType = record
    lowerName, lowerName2: string;
    base: PTypeInfo;
  end;

  TUnitTypeArray = array of TUnitType;

  TUnitClass = record
  private
    TypeCount, UnitsCount: Integer;

    Test: TUnitTypeArray;

    Units: UnitArray;
  public
    Rtti: TRttiContext;

    function GetUnits: UnitArray;
    function IsUnits(UnitName: string): Boolean;

    procedure PTypeInfoUpdute();

    function FindTypeInfo(ClassName: string): PTypeInfo; overload;
    function FindTypeInfo(TType: PTypeInfo): string; overload;

    function FindType(ClassName: string): TRttiType; overload;
    function FindType(TType: PTypeInfo): TRttiType; overload;
    function GetList(): TUnitTypeArray;
  end;

var
  TClassUnits: TUnitClass;

implementation

function TUnitClass.GetList(): TUnitTypeArray;
begin
  if TypeCount <> LibModuleList^.TypeInfo^.TypeCount then
    PTypeInfoUpdute();

  Result := Test;
end;

procedure TUnitClass.PTypeInfoUpdute();
var
  T: TPackageTypeInfo;
  Units: UnitArray;
  currUnit: Integer;
  I, r, idx: Integer;
  typeIter: PPTypeInfo;
  typeName, tmp: string;
begin
  T := LibModuleList^.TypeInfo^;
  TypeCount := T.TypeCount;
  idx := 0;
  currUnit := 0;
  Units := GetUnits;

  FillChar(Test, sizeof(TUnitTypeArray), 0);

  SetLength(Test, TypeCount);

  for I := 0 to TypeCount - 1 do
  begin
    typeIter := T.TypeTable^[I];
    if typeIter = nil then
      Continue;
    if IntPtr(typeIter) = 1 then
    begin
      Inc(currUnit);
      Continue;
    end;
    if typeIter^ = nil then
      Continue;

    typeName := Units[currUnit] + '.' + typeIter^^.NameFld.ToString;
    tmp := '';
    for r := 1 to Length(typeName) do
    begin
      case typeName[r] of
        ',':
          tmp := tmp + '.';
        '.':
          tmp := tmp + '\';
        '<', '>':
          ;
      else
        tmp := tmp + typeName[r];
      end;
    end;

    Test[idx].lowerName := Lowercase(tmp);
    Test[idx].lowerName2 := Lowercase(typeIter^^.NameFld.ToString);
    Test[idx].base := typeIter^;
    Inc(idx);
  end;
  SetLength(Test, idx);
end;

function TUnitClass.FindTypeInfo(ClassName: string): PTypeInfo;
var
  v: TUnitType;
begin
  ClassName := Lowercase(ClassName);
  for v in GetList do
  begin
    if (v.lowerName = ClassName) or (v.lowerName2 = ClassName) then
      exit(v.base);
  end;

  Result := nil;
end;

function TUnitClass.FindTypeInfo(TType: PTypeInfo): string;
var
  v: TUnitType;
begin
  for v in GetList do
  begin
    if v.base = TType then
      exit(v.lowerName);
  end;
  Result := '';
end;

function TUnitClass.FindType(ClassName: string): TRttiType;
begin
  Result := Rtti.GetType(FindTypeInfo(ClassName));
end;

function TUnitClass.FindType(TType: PTypeInfo): TRttiType;
begin
  Result := Rtti.GetType(TType);
end;

function TUnitClass.GetUnits: UnitArray;
var
  P: Pointer;
  I, len, Offset: Integer;
  T: TPackageTypeInfo;
begin
  T := LibModuleList^.TypeInfo^;

  if UnitsCount <> T.UnitCount then
  begin
    UnitsCount := T.UnitCount;

    SetLength(Units, UnitsCount);
    P := Pointer(T.UnitNames);
    Offset := 0;
    for I := 0 to UnitsCount - 1 do
    begin
      len := PByte(NativeInt(P) + Offset)^;
      if len = 0 then
        Continue;

      Inc(Offset, 1);

      SetLength(Units[I], len);
      Move(Pointer(NativeInt(P) + Offset)^, Units[I][1], len);

      Inc(Offset, len);
    end;
  end;
  Result := Units;
end;

function TUnitClass.IsUnits(UnitName: string): Boolean;
var
  TUnitName: UTF8String;
begin
  UnitName := Lowercase(UnitName);
  for TUnitName in GetUnits do
    if Lowercase(String(TUnitName)) = UnitName then
      exit(true);
  Result := false;
end;

initialization

finalization

SetLength(TClassUnits.Units, 0);
SetLength(TClassUnits.Test, 0);

end.
