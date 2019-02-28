unit mainLCL;
interface

uses
  SysUtils, Controls, Classes, Types, VCL.Forms, VCL.Dialogs

 {$ifdef fpc}
  ,fileUtil
 {$endif}
  ;

function toID(o: TObject): integer;
function ToStr(S: PAnsiChar; Len: integer): AnsiString; overload;
function ToStr(V: variant): AnsiString; overload;
function ToStrA(V: variant): AnsiString;
function ToPChar(V: variant): PAnsiChar;
function toObject(id: integer): TObject;
function toWControl(id: integer): TWinControl;
function toControl(id: integer): TControl;
function encStr(S: string): string;
function file_exists(const aFile: string): boolean;

var
  fromANSI: boolean = False;

implementation


function file_exists(const aFile: string): boolean;
begin
{$ifdef fpc}
  Result := FileExistsUTF8(aFile);
{$else}
  Result := FileExists(aFile);
{$endif}
end;

function encStr(S: string): string;
begin
  if fromANSI then
    s := String(AnsiToUtf8(s));

  Result := s;
end;

function ToStrA(V: variant): AnsiString;
begin

  Result := AnsiString(V);
end;

function ToStr(S: PAnsiChar; Len: integer): AnsiString; overload;
var
  i: integer;
begin
  Result := '';
  for i := 0 to len - 1 do
  begin
    Inc(S);
    Result := Result + s^;
  end;
end;

function ToStr(V: variant): AnsiString;
begin
  Result := AnsiString(V);
end;

function ToPChar(V: variant): PAnsiChar;
begin
  Result := PAnsiChar(ToStr(V));
end;

function toID(o: TObject): integer;
begin
  if o = nil then
    Result := 0
  else
    Result := integer(o);
end;

function toWControl(id: integer): TWinControl;
begin
  if id = 0 then
    Result := nil
  else
    Result := TWinControl(integer(id));
end;

function toControl(id: integer): TControl;
begin
  if id = 0 then
    Result := nil
  else
    Result := TControl(integer(id));
end;

function toComponent(id: integer): TComponent;
begin
  if id = 0 then
    Result := nil
  else
    Result := TComponent(integer(id));
end;

function toObject(id: integer): TObject;
begin
  if (id = 0) or (id = -1) then
  begin
    Result := nil
  end
  else
  begin
         Result := TObject(Pointer(id));
  end;

end;


end.
