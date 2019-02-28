unit ExeMod;
{
}

interface

uses
  Windows, SysUtils, Classes, Forms, ShellAPI,
  Dialogs, TypInfo, ZLib, ZLibConst;

type
  TExeStream = class(TObject)
  private
    SS: TStringStream;
    FName: WideString;
    _MainExeName: WideString;
    FFileName: WideString;
    function GetACount: Integer;
    procedure SetFileName(const Value: WideString);
    procedure Add2String(DemarcStr, String2Add: WideString);
  public
    constructor Create(FileName: WideString);
    destructor Destroy;
    procedure ReadData;

    procedure AddStringToExe(Alias, Source: WideString);
    procedure AddComponentToExe(Alias: WideString; OBJ: TComponent);
    procedure AddStreamToExe(Alias: WideString; Stream: TStream);
    procedure AddFileToExe(Alias, FileName: WideString);
   procedure GetDemarcName(DNumber: Integer; var DName: WideString);
    procedure AddFromStream(AName: WideString; AStream: TStream);
    procedure AddFromFile(AName, AFileName: WideString);
    procedure AddFromStrings(AName: WideString; AStrings: TStrings);
    procedure AddFromString(AName, S: WideString);

    procedure AttachToExe(ExeName: WideString);
    procedure ExtractFromExe(DemarcStr: WideString; var ExtractedStr: WideString);
    procedure String2File(FileName: ansistring);
    function IndexOf(Name: WideString): Integer;
    procedure SaveAsExe(FileName: WideString);
    property FileName: WideString read FFileName write SetFileName;
    function ExtractToString(AName: WideString): WideString; overload;
    procedure ExtractToStrings(Alias: WideString; List: TStrings);
    procedure ExtractToString(const Alias: WideString;
      var Source: WideString); overload;
    procedure ExtractToList(Alias: WideString; List: TStrings);
    property AliasCount: Integer read GetACount;
    procedure EraseAlias(Alias: WideString);
    procedure ExtractToFile(Alias, FileName: WideString);
    procedure ExtractToStream(Alias: WideString; Stream: TMemoryStream);
    procedure Save;
  end;

function File2String(FileName: ansistring): ansistring;
function Stream2String(b: TStream): ansistring; overload;
procedure Stream2String(b: TStream; var a: ansistring); overload;
procedure String2Stream(a: ansistring; b: TMemoryStream);
function WinDrv: char;
function getcnt: integer;
procedure String2File2(String2BeSaved, FileName: ansistring);

implementation

{ TExeStream }

var
  EsCount: integer = 0;
function getcnt: integer;
begin
  Result := EsCount;
end;
function WinDrv: char;
var
  WinDir: WideString;
  n: Integer;
begin
  SetLength(WinDir, 256);
  n := GetWindowsDirectory(PChar(WinDir), 256);
  SetLength(WinDir, n);
  Result := WinDir[1];
end;
procedure TExeStream.AddComponentToExe(Alias: WideString; OBJ: TComponent);
begin

  ShowMessage('AddComponentToExe:' + Alias);
end;

procedure TExeStream.AddFileToExe(Alias, FileName: WideString);
begin
  ShowMessage('AddFileToExe:' + Alias + '::' + FileName);

end;

procedure TExeStream.AddFromFile(AName, AFileName: WideString);
begin
  ShowMessage('AddFromFile:' + AName + '::' + AFileName);
end;

procedure TExeStream.AddFromStream(AName: WideString; AStream: TStream);
begin
  ShowMessage('AddFromStream:' + AName);
end;

procedure TExeStream.AddFromString(AName, S: WideString);
begin
  ShowMessage('AddFromString:' + AName + '::' + S);
end;

procedure TExeStream.AddFromStrings(AName: WideString; AStrings: TStrings);
begin
  ShowMessage('AddFromStrings:' + AName);
end;

procedure TExeStream.AddStreamToExe(Alias: WideString; Stream: TStream);
begin
  ShowMessage('AddStreamToExe:' + Alias);
end;

constructor TExeStream.Create(FileName: WideString);
begin
  inherited Create;
  FName := FileName;
  _MainExeName := FName;
  inc(EsCount);
  SS := TStringStream.Create;
  SS.LoadFromFile(FileName);
end;

procedure TExeStream.String2File(FileName: ansistring);
begin
  SetCurrentDir(ExtractFilePath(_MainExeName));

  SS.SaveToFile(FileName);

end;

procedure TExeStream.Add2String(DemarcStr, String2Add: WideString);
var
  DemarcStr2: ansistring;
begin
  DemarcStr2 := ansistring(string(DemarcStr).ToUpper);
  SS.Position := SS.Size;
  SS.WriteString(WideString('SO!#' + DemarcStr2 + chr(182)) + String2Add +
    WideString('EO!#' + DemarcStr2));
end;

procedure TExeStream.AddStringToExe(Alias, Source: WideString);
begin
  Add2String(Alias, Source);
end;

procedure TExeStream.SaveAsExe(FileName: WideString);
begin
  SS.SaveToFile(FileName);
end;

procedure TExeStream.AttachToExe(ExeName: WideString);
begin
  ShowMessage('AttachToExe:' + ExeName);

end;

destructor TExeStream.Destroy;
begin
  _MainExeName := '';
  Dec(EsCount);
  SS.Destroy;
  inherited Destroy;
end;

procedure TExeStream.EraseAlias(Alias: WideString);
begin
  ShowMessage('EraseAlias:' + Alias);
end;

procedure TExeStream

. ExtractFromExe(DemarcStr: WideString; var ExtractedStr: WideString);
var
  d, e: Integer;
  Exe: ansistring;
  DemarcStr2: ansistring;
  rl: Integer;
begin
  DemarcStr2 := ansistring(string(DemarcStr).ToUpper);

  Exe := SS.DataString;

  rl := Pos('SO!#' + DemarcStr2 + chr(182), Exe);

  if rl > 0 then
  begin
    d := rl + Length('SO!#' + DemarcStr2 + chr(182));

    e := Pos('EO!#' + DemarcStr2, Exe);
    ExtractedStr := Copy(Exe, d, e - d);
  end;
end;

procedure TExeStream.ExtractToFile(Alias, FileName: WideString);
begin
  ShowMessage('ExtractToFile:' + Alias + '::' + FileName);
end;

procedure TExeStream.ExtractToList(Alias: WideString; List: TStrings);
Var
  S: WideString;
begin
  ExtractFromExe(Alias, S);
  List.Text := S;
  Finalize(S);
end;

procedure TExeStream.ExtractToStream(Alias: WideString; Stream: TMemoryStream);
begin
  ShowMessage('ExtractToStream:' + Alias);
end;
procedure TExeStream.Save;
begin
  SaveAsExe(FName);
end;
procedure TExeStream.ExtractToString(const Alias: WideString;
  var Source: WideString);
begin
  ExtractFromExe(Alias, Source);
  // ShowMessage('ExtractToString:' + Alias + '::' + Source);
end;

function TExeStream.ExtractToString(AName: WideString): WideString;
begin
  Self.ExtractToString(AName, Result);
  // ShowMessage('ExtractToString:' + AName);
end;

procedure TExeStream.ExtractToStrings(Alias: WideString; List: TStrings);
begin
  ExtractToList(Alias, List);
end;

function TExeStream.GetACount: Integer;
  var
  Count, X: Integer;
  Exe: ansistring;
begin
  Exe := SS.DataString;
  Count := 0;
  For X := 1 to Length(Exe) - 10 do
  begin
    If (Exe[X] = 'S') and (Exe[X + 1] = 'O') and (Exe[X + 2] = '!') and
      (Exe[X + 3] = '#') then
    begin
      Inc(Count);
    end;
  end;
  Result := Count;
end;

function PeekExeByte(Byte2Get: Integer): byte;
Begin
  If Byte2Get < 1 then
    Exit;
  Result := byte(pointer(Hinstance + Byte2Get - 1)^);
End;

function PeekExeWord(Word2Get: Integer): word;
Begin
  If Word2Get < 1 then
    Exit;
  Result := word(pointer(Hinstance + Word2Get - 1)^);
End;

procedure PeekExeString(StartByte, Count: Integer; var ReturnedStr: WideString);
var
  X: Integer;
Begin
  If StartByte < 1 then
    Exit;
  For X := StartByte to StartByte + Count - 1 do
  begin
    ReturnedStr := ReturnedStr + (AnsiChar(pointer(Hinstance + X - 1)^));
  end;
End;

procedure TExeStream.GetDemarcName(DNumber: Integer; var DName: WideString);
var
  Count, X, Y: Integer;
  Exe: string;
begin
  Count := 0;
  Exe := SS.DataString;
  For X := 1 to Length(Exe) - 10 do
  begin
    If (Exe[X] = 'S') and (Exe[X + 1] = 'O') and (Exe[X + 2] = '!') and
      (Exe[X + 3] = '#') then
    begin
      Inc(Count);
      If Count = DNumber then
      begin
        Y := X + 4;
        While Exe[Y] <> chr(182) do
        begin
          DName := DName + Exe[Y];
          Inc(Y);
        end;
      end;
    end;
  end;
end;

function TExeStream.IndexOf(Name: WideString): Integer;
Var
  Len: Integer;
  S: WideString;
begin
  Len := AliasCount;
  Name := ansistring(string(Name).ToUpper);
  for Result := 0 to Len - 1 do
  begin
    GetDemarcName(Result, S);
    if ansistring(string(S).ToUpper) = Name then
      Exit;
  end;
  Result := -1;
end;

procedure TExeStream.ReadData;
begin
  ShowMessage('ReadData:');
end;

procedure TExeStream.SetFileName(const Value: WideString);
begin
  ShowMessage('SetFileName:' + Value);
end;

procedure String2File2(String2BeSaved, FileName: ansistring);
var
  MyStream: TMemoryStream;
begin
  if String2BeSaved = '' then
    Exit;
  SetCurrentDir(ExtractFilePath(Filename));
  MyStream := TMemoryStream.Create;
  try
    MyStream.WriteBuffer(pointer(String2BeSaved)^, Length(String2BeSaved));

    MyStream.SaveToFile(FileName);
  finally
    MyStream.Destroy;
  end;
end;

procedure String2Stream(a: ansistring; b: TMemoryStream);
begin
  b.Position := 0;
  b.WriteBuffer(pointer(a)^, Length(a));
  b.Position := 0;
end;

procedure Stream2String(b: TStream; var a: ansistring); overload;
begin
  b.Position := 0;
  SetLength(a, b.Size);
  b.ReadBuffer(pointer(a)^, b.Size);
  b.Position := 0;
end;

function Stream2String(b: TStream): ansistring; overload;
begin
  Stream2String(b, Result);
end;

function File2String(FileName: ansistring): ansistring;
var
  MyStream: TMemoryStream;
begin
  MyStream := TMemoryStream.Create;
  try
    MyStream.LoadFromFile(FileName);
    MyStream.Position := 0;
    SetLength(Result, MyStream.Size);
    MyStream.ReadBuffer(pointer(Result)^, MyStream.Size);
  finally
    MyStream.Destroy;
  end;
end;

initialization

begin
  SetCurrentDir(ExtractFilePath(ParamStr(0)));
end;

end.
