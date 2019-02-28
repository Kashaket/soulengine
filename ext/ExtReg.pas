unit ExtReg;

interface
 {$DEFINE Testing}
uses Windows, Classes, SysUtils, TypInfo, Rtti, UnitClass
{$IFDEF Testing}, vcl.dialogs{$ENDIF};


function GetUnitName(lType: TRttiType): string;
procedure registerUnit(UnitName: String);
function GetUnitNames(): TArray<string>; overload;
function GetUnitNames(StartWith: string): TArray<string>; overload;
function getClasses(UnitName: String): TArray<string>;
procedure regUnits(StartWith: string);
procedure regUnitNames(StartWith: string);
function isIn(s: string; arr: TArray<string>): boolean;
exports GetUnitName, registerUnit, GetUnitNames, getClasses, regUnits, regUnitNames;
implementation

function GetUnitName(lType: TRttiType): string; overload;
begin

    Result := StringReplace(ltype.UnitName, '.' + lType.Name, '',[rfReplaceAll])
end;

function isIn(s: string; arr: TArray<string>): boolean;
var I: integer;
begin
  Result := False;
  if Length(arr) = 0 then
      Exit;

  for I := 0 to Length(arr) do
    if arr[I] = s then
    begin
      Result := true;
      Exit;
    end;
end;

function GetUnitNames(): TArray<string>;
var u: TUnitClass;
t: string;
begin
  SetLength(Result, 0);
   for t in u.GetUnits  do
      if not isIn(t, Result) then
      begin
      //Задаёт длину массива, чтоб не словить overflow
      SetLength(Result, Length(Result) + 1);
      //Задаёт последний элемент массива, в соответствии с именем юнита
      Result[High(Result)] := t;
      end;
end;

function GetUnitNames(StartWith: string): TArray<string>; overload;
var u: TUnitClass;
t: string;
begin
  SetLength(Result, 0);
   for t in u.GetUnits  do
   if (Pos(StartWith, t) > 0) and (not isIn(t, Result)) then
   begin
      //Задаёт длину массива, чтоб не словить overflow
      SetLength(Result, Length(Result) + 1);
      //Задаёт последний элемент массива, в соответствии с именем юнита
      Result[High(Result)] := t;
   end;
end;

procedure regUnitNames(StartWith: string);
var u: TUnitClass;
t: string;
chk: TArray<string>;
begin
SetLength(chk, 0);
   for t in u.GetUnits  do
   if not t.IsEmpty then
   if (Pos(StartWith, t) > 0) then
   begin
   {$IFDEF Testing}
      ShowMessage( t );
   {$ENDIF}
      //RegisterUnit(t);
      SetLength(chk, Length(chk) + 1);
      chk[High(chk)] := t;
   end;
end;

function getClasses(UnitName: String): TArray<string>;
var t: TRttiType;
begin
//f.b чтобы  не словить ошибку на Length()
  SetLength(Result, 0);
  for t in TRttiContext.Create.GetTypes do
   if SameText(UnitName,GetUnitName(t)) and (t.IsInstance) then
    begin
      //Задаёт длину массива, чтоб не словить overflow
      SetLength(Result, Length(Result) + 1);
      //Задаёт последний элемент массива, в соответствии с именем класса
      Result[High(Result)] := t.Name;
    end;
end;

procedure registerUnit(UnitName: String);
var t: TRttiType;
begin
  for t in TRttiContext.Create.GetTypes do
   if SameText(UnitName,GetUnitName(t)) and (t.IsInstance) then
   //Регистрирует класс динамически
     RegisterClass( TPersistentClass(t.AsInstance.MetaclassType) );
end;

procedure regUnits(StartWith: string);
var t: TRttiType;
begin
   for t in TRttiContext.Create.GetTypes do
   if t.isInstance and (Pos(StartWith, GetUnitName(t)) > 0) then
   begin
      RegisterClass( TPersistentClass(t.AsInstance.MetaclassType) );
   end;
end;

initialization
end.
