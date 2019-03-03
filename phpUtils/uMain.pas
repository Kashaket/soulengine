unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  php4delphi, PHPCommon, ExeMod, Dialogs;

  procedure mainFunc();

type
  TfmMain = class(TForm)
    psvPHP: TpsvPHP;
    PHPEngine: TPHPEngine;
    procedure FormCreate(Sender: TObject);
    procedure PHPEngineScriptError(Sender: TObject; AText: string;
      AType: TPHPErrorType; AFileName: string; ALineNo: Integer);
    procedure FormShow(Sender: TObject);
    procedure PHPEngineEngineShutdown(Sender: TObject);
    procedure psvPHPAfterExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;
  FilesCheck: TStringList;
  errResult: String;
  bCompilerCode: String;

implementation

{$R *.dfm}
procedure bcAddClass(AClass: String);
begin
  bCompilerCode := bCompilerCode +
  'bcompiler_write_class($fh, ''' +AClass+ ''');'+#13;
end;

procedure bcAddFunc(AFunc: String);
begin
  bCompilerCode := bCompilerCode +
  'bcompiler_write_function($fh, ''' +AFunc+ ''');'+#13;
end;

procedure bcAddConst(AConst: String);
begin
  bCompilerCode := bCompilerCode +
  'bcompiler_write_constant($fh, ''' +AConst+ ''');'+#13;
end;


function bcAnalize(): Boolean;
  var
  arr: Array of String;
  aFile, aCFile, aParams: String;
  i: integer;
begin
  Result := false;
  SetLength(arr, ParamCount);
  for i := 0 to ParamCount - 1 do
    arr[i] := ParamStr(i);

 { SetLength(arr, 4);
  arr[1] := 'bcompiler';
  arr[2] := 'E:/Projects/Multimedia/Mess Box PHP//system//models/compile.php';
  arr[3] := 'E:/Projects/Multimedia/Mess Box PHP//system//models/compile.phb';
  arr[4] := 'YTozOntzOjk6ImNvbnN0YW50cyI7YTowOnt9czo5OiJmdW5jdGlvbnMiO2E6MDp7fXM6NzoiY2xhc3NlcyI7YTowOnt9fQ=='
  };

  if Length(arr) > 0 then
  if arr[1] = 'bcompiler'  then
  begin
     aFile  := arr[2];
     aCFile := arr[3];

     aParams:= arr[4]; // параметры в сериализованном виде php

     bCompilerCode := '/*dl(''php_bcompiler.dll''); dl(''php_bz2.dll'');*/';
     bCompilerCode := bCompilerCode + 'require '''+StringReplace(aFile,'\','/',[rfReplaceAll])+''';';
     bCompilerCode := bCompilerCode + '$fh = fopen('''+StringReplace(aCFile,'\','/',[rfReplaceAll])+''', "w");';
     bCompilerCode := bCompilerCode + '$arParams = unserialize(base64_decode('''+aParams+'''));';

     bCompilerCode := bCompilerCode + 'bcompiler_write_header($fh);';
// записываем константы
     bCompilerCode := bCompilerCode +
'foreach((array)$arParams["constants"] as $name) bcompiler_write_constant($fh, $name);';

// функциии
     bCompilerCode := bCompilerCode +
'foreach((array)$arParams["functions"] as $name) bcompiler_write_function($fh, $name);';

// классы
     bCompilerCode := bCompilerCode +
'foreach((array)$arParams["classes"] as $name){ bcompiler_write_class($fh, $name); }';


     bCompilerCode := bCompilerCode + 'bcompiler_write_footer($fh);';
     bCompilerCode := bCompilerCode + 'fclose($fh);';
     
     //MessageBox(0, pchar(bCompilerCode), '', 0);
     Result := true;
  end;
end;

function checkCode(AFile: string): String;
   var
   s: string;
begin

  s := Trim( File2String(AFile) );
  errResult := '';
  fmMain.psvPHP.UseDelimiters := false;
  if (Pos('<?', s) < 5) and (Pos('<?', s) <> 0) then
    fmMain.psvPHP.RunCode( '<? return; ?>' + s )
  else begin
    fmMain.psvPHP.RunCode( '<? return;' + s );
  end;
  Result := errResult;
end;


procedure mainFunc();
   var
   saveFile: String;
   resultList: TStringList;
   i: integer;
   pDir: string;
begin

  pDir := ExtractFilePath(ParamStr(0));


  if FileExists(pDir+'\..\..\php\php5ts.dll') then begin
    fmMain.PHPEngine.DLLFolder := pDir + '\..\..\php\';
    fmMain.PHPEngine.IniPath   := pDir + '\..\..\php\';
  end;

  if FileExists(pDir+'\php5ts.dll') then begin
    fmMain.PHPEngine.DLLFolder := pDir;
    fmMain.PHPEngine.IniPath   := pDir;
    if FileExists(pDir + '\core\php.ini') then
      fmMain.PHPEngine.IniPath   := pDir + '\core\';
  end;

  if FileExists(pDir+'\..\php\php5ts.dll') then begin
    fmMain.PHPEngine.DLLFolder := pDir + '\..\php\';
    fmMain.PHPEngine.IniPath   := pDir + '\..\php\';
  end;

  fmMain.PHPEngine.StartupEngine;

  if bcAnalize then
  begin
    fmMain.PHPEngine.OnScriptError := nil;
    fmMain.psvPHP.RunCode(bCompilerCode);
    if FileExists(ParamStr(5)) then
      // записываем error.log
      if errResult <> '' then
        String2File2(errResult, ParamStr(5));

    ExitProcess(0);
    exit;
  end;

  resultList := TStringList.Create;
  saveFile := ParamStr(2);
  if saveFile = '' then
    saveFile := pDir+'\error.log';

  if FileExists(ParamStr(1)) then
  
  FilesCheck.LoadFromFile(ParamStr(1));

  for I := 0 to FilesCheck.Count - 1 do
    resultList.Add( ExtractFileName(FilesCheck[i])+'|'+checkCode(FilesCheck[i]) );

  ForceDirectories(ExtractFileDir(saveFile));
  resultList.SaveToFile(saveFile);

  resultList.Free;
  ExitProcess(0);
    exit;
end;


procedure TfmMain.FormCreate(Sender: TObject);
begin
  FilesCheck := TStringList.Create;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin

  Close;
end;

procedure TfmMain.PHPEngineEngineShutdown(Sender: TObject);
begin

end;

procedure TfmMain.PHPEngineScriptError(Sender: TObject; AText: string;
  AType: TPHPErrorType; AFileName: string; ALineNo: Integer);
begin

  errResult :=
  AText + '|' + IntToStr(integer(AType)) + '|' + IntToStr(ALineNo);
end;

procedure TfmMain.psvPHPAfterExecute(Sender: TObject);
begin

end;

end.
