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
    FName: WideString;
    FFileName: WideString;
    function GetACount: Integer;
    procedure SetFileName(const Value: WideString);
  public
    constructor Create(FileName: WideString);
    destructor Destroy;
    procedure ReadData;

    procedure AddStringToExe(Alias, Source: WideString);
    procedure AddComponentToExe(Alias: WideString; OBJ: TComponent);
    procedure AddStreamToExe(Alias: WideString; Stream: TStream);
    procedure AddFileToExe(Alias, FileName: WideString);

    procedure AddFromStream(AName: WideString; AStream: TStream);
    procedure AddFromFile(AName, AFileName: WideString);
    procedure AddFromStrings(AName: WideString; AStrings: TStrings);
    procedure AddFromString(AName, S: WideString);

    procedure AttachToExe(ExeName: WideString);
    procedure ExtractFromExe(ExeName: WideString);

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

  end;

  {
    var
    Exe: WideString;
    _MainExeName: WideString;

    procedure CompressStream(Stream: TStream;
    compressionRate : TCompressionLevel); overload;
    procedure CompressStream( aSource, aTarget : TStream;
    compressionRate : TCompressionLevel ); overload;
    procedure DecompressStream(aSource, aTarget: TStream);



    procedure Stream2Exe(TempStream: TMemoryStream);
    procedure Delay(ms: longint);



  }
procedure String2File(FileName: ansistring);
function File2String(FileName: ansistring): ansistring;
function Stream2String(b: TStream): ansistring; overload;
procedure Stream2String(b: TStream; var a: ansistring); overload;
procedure String2Stream(a: ansistring; b: TMemoryStream);
function WinDrv: char;
procedure String2File2(String2BeSaved, FileName: ansistring);

implementation

{

  procedure CompressStream( aSource, aTarget : TStream;
  compressionRate : TCompressionLevel ); overload;
  var comprStream : TCompressionStream;
  begin
  // compression level : (clNone, clFastest, clDefault, clMax)
  comprStream := TCompressionStream.Create( compressionRate, aTarget );
  try
  comprStream.CopyFrom( aSource, aSource.Size );
  comprStream.CompressionRate;
  finally
  comprStream.Free;
  End;
  End;

  procedure CompressStream(Stream: TStream;
  compressionRate : TCompressionLevel); overload;
  Var
  TG: TMemoryStream;
  begin
  TG := TMemoryStream.Create;
  CompressStream(Stream,TG,compressionRate);
  Stream.Free;
  Stream := TStream.Create;
  Stream.CopyFrom(TG,TG.Size);
  TG.Free;
  end;

  procedure DecompressStream(aSource, aTarget: TStream);
  var decompStream : TDecompressionStream;
  nRead : Integer;
  buffer : array[0..1023] of AnsiChar;
  begin
  decompStream := TDecompressionStream.Create( aSource );
  try
  repeat
  nRead:=decompStream.Read( buffer, 1024 );
  aTarget.Write( buffer, nRead );
  Until nRead < 1024;
  finally
  decompStream.Free;
  End;
  End;

  procedure Delay(ms: longint);
  var
  TheTime: LongInt;
  begin
  TheTime := GetTickCount + ms;
  while GetTickCount < TheTime do
  Application.ProcessMessages;
  end;



  procedure ReadExe;
  var
  ExeStream: TFileStream;
  begin
  ExeStream := TFileStream.Create(_MainExeName, fmOpenRead
  or fmShareDenyNone);
  try
  SetLength(Exe, ExeStream.Size);
  ExeStream.ReadBuffer(Pointer(Exe)^, ExeStream.Size);
  finally
  ExeStream.Free;
  end;
  end;


  //===================================================

  //===================================================


  procedure ExtractFromExe(DemarcStr: WideString; var ExtractedStr: WideString);
  var
  d, e: integer;
  begin
  if Length(Exe) = 0 then ReadExe;
  if Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Exe) > 0 then
  begin
  d := Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Exe)
  + length(Q_UpperCase('so!#' + DemarcStr + chr(182)));

  e := Q_PosStr(Q_UpperCase('eo!#' + DemarcStr), Exe);
  ExtractedStr := Copy(Exe, d, e - d);
  end;
  end;

  procedure ExtractFromFile(DemarcStr: WideString; DataFile: WideString; var ExtractedStr: WideString);
  var
  d, e: integer;
  Temp: WideString;
  begin
  Temp := File2String(DataFile);
  if Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Temp) > 0 then
  begin
  d := Q_PosStr(Q_UpperCase('so!#' + DemarcStr + chr(182)), Temp)
  + length(Q_UpperCase('so!#' + DemarcStr + chr(182)));
  e := Q_PosStr(Q_UpperCase('eo!#' + DemarcStr), Temp);
  ExtractedStr := Copy(Temp, d, e - d);
  end;
  end;

  procedure DelFromString(DemarcStr: WideString; var String2Change: WideString);
  var
  a, b: WideString;
  begin
  a := Q_UpperCase('so!#' + DemarcStr + chr(182));
  b := Q_UpperCase('eo!#' + DemarcStr);
  delete(String2Change, Q_PosStr(a, String2Change), (Q_PosStr(b, String2Change)
  + length(b) - Q_PosStr(a, String2Change)));
  end;

  procedure DelFromExe(DemarcStr: WideString);
  begin
  If Exe = '' then ReadExe;
  DelFromString(DemarcStr,Exe);
  end;

  procedure DelFromFile(DemarcStr, FileName: WideString);
  var
  MyString: WideString;
  begin
  MyString := File2String(FileName);
  DelFromString(DemarcStr, MyString);
  String2File(MyString, FileName);
  end;

  procedure Add2File(DemarcStr, FileName, String2Add: WideString);
  var
  MyString: WideString;
  begin
  If DemarcStr = '' then Exit;
  MyString := File2String(FileName);
  MyString := MyString + Q_uppercase('so!#' + DemarcStr + chr(182)) + String2Add + Q_uppercase
  ('eo!#' + DemarcStr);
  String2File(MyString, FileName);
  end;

  procedure ReplaceInFile(DemarcStr, FileName, ReplacementString: WideString);
  begin
  If DemarcStr = '' then Exit;
  DelFromFile(DemarcStr, FileName);
  Add2File(DemarcStr, FileName, ReplacementString);
  end;

  procedure TackOnFile(DemarcStr, FileName, File2Add: WideString);
  var
  Mystring: WideString;
  begin
  If DemarcStr = '' then Exit;
  MyString := File2String(File2add);
  Add2File(DemarcStr, FileName, MyString);
  end;



  procedure ReplaceInString(DemarcStr, ReplacementString: WideString;
  var String2Alter: WideString);
  begin
  If DemarcStr = '' then Exit;
  if q_posstr(q_uppercase('so!#' + DemarcStr + chr(182)), String2Alter) = 0 then exit;
  DelFromString(DemarcStr, String2Alter);
  Add2String(DemarcStr, ReplacementString, String2Alter);
  end;

  procedure ReplaceInExe(DemarcStr, ReplacementString: WideString);
  begin
  If DemarcStr = '' then Exit;
  if q_posstr(q_uppercase('so!#' + DemarcStr + chr(182)), Exe) = 0 then exit;
  DelFromString(DemarcStr, Exe);
  Add2String(DemarcStr, ReplacementString, Exe);
  end;

  procedure InsOrReplaceInString(DemarcStr, ReplacementString: WideString;
  var String2Alter: WideString);
  begin
  If DemarcStr = '' then Exit;
  DelFromString(DemarcStr, String2Alter);
  Add2String(DemarcStr, ReplacementString, String2Alter);
  end;

  procedure InsOrReplaceInExe(DemarcStr, ReplacementString: WideString);
  begin
  If DemarcStr = '' then Exit;
  If Exe = '' Then ReadExe;
  DelFromString(DemarcStr, Exe);
  Add2String(DemarcStr, ReplacementString, Exe);
  end;

  procedure ExtractAndStrip(DemarcStr, FileName: WideString);
  var
  Temp: WideString;
  begin
  ExtractFromExe(DemarcStr, Temp);
  if Length(Temp) <> 0 then
  begin
  DelFromString(DemarcStr, Exe);
  String2File(Temp, FileName);
  end;
  end;

  procedure Exe2File(FileName: WideString);
  begin
  if Exe = '' then ReadExe;
  String2File(Exe, FileName);
  end;

  procedure Extract2File(DemarcStr, FileName: WideString);
  var
  MyString: WideString;
  begin
  ExtractFromExe(DemarcStr, MyString);
  if MyString <> '' then String2File(MyString, FileName);
  end;

  procedure Add2Exe(DemarcStr, String2Add: WideString);
  begin
  If DemarcStr = '' then Exit;
  if Exe = '' then readExe;
  Add2String(DemarcStr, String2Add, Exe);
  end;

  procedure Stream2Exe(TempStream: TMemoryStream);
  begin
  SetCurrentDir(ExtractFilePath(_MainExeName));
  TempStream.SaveToFile('temp0a0.exe');
  ShellExecute(0, 'open', PChar('temp0a0.exe'),
  PChar(ExtractFilename(_MainExeName)), nil, SW_SHOW);
  Application.Terminate;
  end;

  procedure AddFile2Exe(DemarcStr, FileName: WideString);
  var
  MyString: WideString;
  begin
  If DemarcStr = '' then Exit;
  MyString := File2String(FileName);
  if Exe = '' then ReadExe;
  Add2String(DemarcStr, MyString, Exe);
  end;

  constructor TExeStream.Create(FileName:WideString);
  begin
  inherited Create;
  FName := FileName;
  _MainExeName := FName;


  ReadExe;
  end;


  procedure TExeStream.ReadData;
  begin
  ReadExe;
  end;


  procedure TExeStream.AddStringToExe(Alias,Source:WideString);
  begin
  Add2String(Alias,Source,Exe);
  end;

  procedure TExeStream.AddComponentToExe(Alias: WideString; OBJ: TComponent);
  Var
  M: TMemoryStream;
  begin
  M := TMemoryStream.Create;
  M.Position := 0;
  M.WriteComponent(OBJ);
  AddStringToExe(Alias,WideString(M.Memory^));
  M.Free;
  end;

  procedure TExeStream.AddStreamToExe(Alias:WideString; Stream:TStream);
  begin
  Add2String(Alias,Stream2String(Stream),Exe);
  end;

  procedure TExeStream.AddFileToExe(Alias,FileName:WideString);
  begin
  Add2String(Alias,File2String(FileName),Exe);
  end;

  procedure TExeStream.SaveAsExe(FileName:WideString);
  begin
  //ShowMessage( FileName );
  Exe2File(FileName);
  end;


  procedure TExeStream.ExtractToFile(Alias,FileName:WideString);
  Var
  tmp: WideString;
  begin
  If not DirectoryExists(ExtractFileDir(FileName)) then
  ForceDirectories(ExtractFileDir(FileName));
  ExeMod.ExtractFromExe(Alias,tmp);
  String2File(tmp,FileName);
  Finalize(tmp);
  end;

  procedure TExeStream.ExtractToStream(Alias:WideString; Stream:TMemoryStream);
  Var
  tmp: WideString;
  begin
  ExeMod.ExtractFromExe(Alias,tmp);
  String2Stream(tmp, Stream);
  Finalize(tmp);
  end;

  procedure TExeStream.EraseAlias(Alias:WideString);
  begin
  DelFromExe(Alias);
  end;
  procedure TExeStream.SetFileName(const Value: WideString);
  begin
  FFileName := Value;
  _MainExeName := Value;
  ReadExe;
  end;

  procedure TExeStream.AddFromFile(AName, AFileName: WideString);
  begin
  Self.AddFileToExe(AName,AFileName);
  end;

  procedure TExeStream.AddFromStream(AName: WideString; AStream: TStream);
  begin
  Self.AddStreamToExe(AName,AStream);
  end;

  procedure TExeStream.AddFromString(AName, S: WideString);
  begin
  Self.AddStringToExe(AName,S);
  end;

  procedure TExeStream.AddFromStrings(AName: WideString; AStrings: TStrings);
  begin
  Self.AddStringToExe(AName,AStrings.Text);
  end;

  procedure TExeStream.AttachToExe(ExeName: WideString);
  begin
  SaveAsExe(ExeName);
  end;

  procedure TExeStream.ExtractFromExe(ExeName: WideString);
  begin
  FileName := ExeName;
  ReadExe;
  end;

  procedure TExeStream.ExtractToString(const Alias:WideString; var Source:WideString);
  begin
  ExeMod.ExtractFromExe(Alias,Source);
  end;
  function TExeStream.ExtractToString(AName: WideString): WideString;
  begin
  Self.ExtractToString(AName,Result);
  end;



}

{ TExeStream }

var
  SS: TStringStream;
  _MainExeName: WideString;

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

function GetDemarcCount: Integer;
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

  SS := TStringStream.Create;
  SS.LoadFromFile(FileName);
end;

procedure String2File(FileName: ansistring);
begin
  SetCurrentDir(ExtractFilePath(_MainExeName));

  SS.SaveToFile(FileName);

end;

procedure Add2String(DemarcStr, String2Add: WideString);
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
  inherited Destroy;
end;

procedure TExeStream.EraseAlias(Alias: WideString);
begin
  ShowMessage('EraseAlias:' + Alias);
end;

procedure TExeStream.ExtractFromExe(ExeName: WideString);
begin
  ShowMessage('ExtractFromExe:' + ExeName);
end;

procedure ExtractFromExe(DemarcStr: WideString; var ExtractedStr: WideString);
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
  ExeMod.ExtractFromExe(Alias, S);
  List.Text := S;
  Finalize(S);
end;

procedure TExeStream.ExtractToStream(Alias: WideString; Stream: TMemoryStream);
begin
  ShowMessage('ExtractToStream:' + Alias);
end;

procedure TExeStream.ExtractToString(const Alias: WideString;
  var Source: WideString);
begin
  ExeMod.ExtractFromExe(Alias, Source);
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
begin
  Result := GetDemarcCount;
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

procedure PokeExeString(StartByte: Integer; String2Insert: WideString);
var
  X: Integer;
  Exe: string;
Begin
  Exe := SS.DataString;
  If StartByte + Length(String2Insert) > Length(Exe) then
    Exit;
  If StartByte < 1 then
    Exit;
  For X := 1 to Length(String2Insert) do
  begin
    Exe[X + StartByte - 1] := String2Insert[X];
  end;
end;

procedure AlterExe;
var
  Exe: ansistring;
begin
  Exe := SS.DataString;
  if (Exe) <> '' then
  begin
    String2File('temp0a0.exe');
    ShellExecute(0, 'open', PChar('temp0a0.exe'),
      PChar('"' + ExtractFilename(_MainExeName) + '"'), nil, SW_SHOW);
    Application.Terminate;
  end;
end;

procedure PokeExeStringI(StartByte: Integer; String2Insert: WideString);
var
  X: Integer;
  Exe: string;
Begin
  Exe := SS.DataString;
  If StartByte + Length(String2Insert) > Length(Exe) then
    Exit;
  If StartByte < 1 then
    Exit;
  For X := 1 to Length(String2Insert) do
  begin
    Exe[X + StartByte - 1] := String2Insert[X];
  end;
  AlterExe;
end;

procedure PokeExeByte(Byte2set: Integer; ByteVal: byte);
Var
  Exe: string;
Begin
  Exe := SS.DataString;
  If Byte2set > Length(Exe) then
    Exit;
  Exe[Byte2set] := chr(ByteVal);
end;

procedure PokeExeByteI(Byte2set: Integer; ByteVal: byte);
Var
  Exe: string;
Begin
  Exe := SS.DataString;
  If Byte2set > Length(Exe) then
    Exit;
  Exe[Byte2set] := chr(ByteVal);
  AlterExe;
end;

procedure GetDemarcName(DNumber: Integer; var DName: WideString);
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
  SetCurrentDir(ExtractFilePath(_MainExeName));
  MyStream := TMemoryStream.Create;
  try
    MyStream.WriteBuffer(pointer(String2BeSaved)^, Length(String2BeSaved));

    MyStream.SaveToFile(FileName);
  finally
    MyStream.Free;
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
  MyString: ansistring;
begin
  MyStream := TMemoryStream.Create;
  try
    MyStream.LoadFromFile(FileName);
    MyStream.Position := 0;
    SetLength(MyString, MyStream.Size);
    MyStream.ReadBuffer(pointer(MyString)^, MyStream.Size);
  finally
    MyStream.Free;
  end;
  Result := MyString;
end;

initialization

begin
  SetCurrentDir(ExtractFilePath(_MainExeName));
end;

end.
