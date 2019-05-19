unit uMain;
{$I 'PHP.inc'}
{$I 'sDef.inc'}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, php4delphi, PHPCommon,
  phpFunctions, ZENDTypes, zendAPI, uPhpEvents,
  Menus, Buttons,
  AppEvnts, phpAPI, Clipbrd, System.UITypes,
  core, SynEditHighlighter, SynHighlighterPHP, SynEdit, SynMemo, Vcl.ExtCtrls
  {$IFDEF ADD_SKINS}
  ,sSkinProvider, sSkinManager,

    sSpeedButton, sBitBtn, acProgressBar, sTrackBar, sBevel, sLabel
{$ENDIF};

function TempDir: zend_ustr;

type
  T__fMain = class(TForm)
    b_R1: TButton;
    b_R0: TButton;
    n: TMainMenu;
    fi: TMenuItem;
    Script1: TMenuItem;
    o1: TMenuItem;
    s: TMenuItem;
    s1: TMenuItem;
    r: TMenuItem;
    r1: TMenuItem;
    od: TOpenDialog;
    ApplicationEvents: TApplicationEvents;
    sd: TSaveDialog;
    M1: TSynMemo;
    sps: TSynPHPSyn;
    fr: TBevel;
    sc: TMenuItem;
    Close: TMenuItem;
    Exits: TMenuItem;
    R2: TMenuItem;
    procedure b_R1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure b_R0Click(Sender: TObject);
    procedure sClick(Sender: TObject);
    procedure o1Click(Sender: TObject);
    procedure s1Click(Sender: TObject);
    procedure M1DropFiles(Sender: TObject; X, Y: Integer; AFiles: TStrings);
    procedure scClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure ExitsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure R2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure loadEngine(DLLFolder: string = '');
  end;

var
  __fMain: T__fMain;
  appShow: boolean;
  LFile: string;

implementation

uses uPHPMod, uMainForm;

{$R *.dfm}

procedure T__fMain.b_R0Click(Sender: TObject);
begin
  if not selfEnabled then
  begin
    phpMOD.psvPHP.ShutdownRequest;
    phpMOD.PHPEngine.ShutdownEngine;
    T__fMain.loadEngine();
  end;
end;

procedure T__fMain.b_R1Click(Sender: TObject);
begin
  if not selfEnabled then
  begin
    phpMOD.psvPHP.UseDelimiters := False;
    phpMOD.RunCode('$self = c(' + IntToStr(integer(Sender)) + ');' + #10 + #13
    + 'if(!isset($GLOBALS["__echoController"])) $GLOBALS["__echoController"] = "pre"; ob_start();'
    + M1.Lines.Text + #10 + #13 +
    '$controller = $GLOBALS["__echoController"]; $_rt = ob_get_contents(); ob_end_clean();'
    + 'if (is_numeric($controller)) $controller = c($controller);'
    + 'if ($controller) if (is_object($controller)){'
    + #10 + #13
    + 'if ($controller instanceof TChromium) $controller->html = $_rt; else $controller->text = $_rt;'
    + #10 + #13
    + '} elseif (is_callable($controller)){'
    + 'if ($_rt) call_user_func($controller, $_rt); '
    + #10 + #13 + ' }'
    );
    phpMOD.psvPHP.UseDelimiters := True;
  end;
end;



procedure T__fMain.CloseClick(Sender: TObject);
begin
  M1.Lines.Clear;
  LFile            := '!';
  Self.Caption     := 'Soul Engine';
  sc.Enabled       := False;
  close.Enabled    := False;
end;

procedure T__fMain.ExitsClick(Sender: TObject);
begin
 if not LFile.Equals('!') then
 begin
  MessageBeep(3);
  case MessageDlg('Do you want to save the file before the exit?', mtConfirmation, mbYesNoCancel, 0) of
     mrYes: M1.Lines.SaveToFile(LFile);
     mrCancel: Exit;
  end;
 end;
  Application.Terminate;
end;

procedure T__fMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if not LFile.Equals('!') then begin
    MessageBeep(33);
    case MessageDlg('Do you want to save the file before the exit?', mtConfirmation, mbYesNoCancel, 0) of
       mrYes: M1.Lines.SaveToFile(LFile);
       mrCancel: CanClose := False;
    end;
  end;
end;

procedure T__fMain.FormShow(Sender: TObject);
begin
  if not selfEnabled and FileExists(LFile) then
  begin
    M1.Lines.LoadFromFile(LFile);
    Self.Caption     := 'Soul Engine - ' + LFile;
  end;
end;

class procedure T__fMain.loadEngine(DLLFolder: string = '');

  function FindFileSize(Filename: string): integer;
  var
    sr: TSearchRec;
  begin
    if FindFirst(Filename, faAnyFile - faDirectory, sr) = 0 then
      Result := sr.Size
    else
      Result := -1;
    FindClose(sr);
  end;

begin

  /// /  PHPEngine.AddFunction('my_call', @ex_dec);
  // InitializeEventSystem( PHPEngine );

  PHPEngine.HandleErrors := True;

  // phpMOD.RunFile(engineDir+'include.php');
  if (DLLFolder = '') then
    DLLFolder := ExtractFilePath(ParamStr(0));

  if FileExists(engineDir + '\php.ini') then
    PHPEngine.IniPath := AnsiString(engineDir + '\php.ini')
  else if FileExists(iniDir + '\php.ini') then
    PHPEngine.IniPath := AnsiString(iniDir)
  else if FileExists(progDir + '\php.ini') then
    PHPEngine.IniPath := AnsiString(progDir)
  else
    PHPEngine.IniPath := AnsiString(PHPEngine.DLLFolder);

  /// FS := TFileStream.Create(PHPEngine.IniPath, fmOpenRead, fmShareDenyWrite);

  core_Init(PHPEngine, phpMOD.psvPHP);

  addVar('progDir', progDir);
  addVar('moduleDir', moduleDir);
  addVar('engineDir', engineDir);

  if (FileExists(engineDir + 'include.php')) and (not selfEnabled) then
    phpMOD.RunFile(engineDir + 'include.php');
end;


procedure T__fMain.M1DropFiles(Sender: TObject; X, Y: Integer;
  AFiles: TStrings);
var ext: PWideChar;
splits: TArray<System.string>;
begin
splits := AFiles.ToStringArray[0].Split(['.']);
ext    := PWideChar( splits[High(splits)].ToLower );
if (ext = 'php') or (ext = 'phpe') or (ext = 'pse') or (ext = 'php3') or (ext = 'psex') or (ext = 'psec') then
begin
  sc.Enabled       := True;
  close.Enabled    := True;
  if  AFiles.ToStringArray[0] = LFile then  begin
    MessageBeep(3);
    case MessageDlg('Do you just want to reload the file?', mtConfirmation, mbYesNo, 0) of
       mrYes: M1.Lines.LoadFromFile(LFile);
       mrNo: Exit;
    end;
  end;
  MessageBeep(3);
  case MessageDlg('When you load new file, the changes in the old may not be saved.'
    + #10 + #13 + 'Save changes in "' +LFile+ '"?', mtConfirmation, mbYesNoCancel, 1) of
    mrYes: M1.Lines.SaveToFile(LFile);
    mrCancel: Exit;
  end;

  if FileExists(  AFiles.ToStringArray[0] ) then
  begin
      M1.Lines.LoadFromFile(  AFiles.ToStringArray[0] );
      LFile :=  AFiles.ToStringArray[0];
      Self.Caption     := 'Soul Engine - ' + LFile;
  end
  else
  begin
      MessageBeep(37);
      MessageDlg('Where did you move "' +  AFiles.ToStringArray[0] + '"?' + #10 + #13 + 'Program cannot load it anymore!', mtError, mbOKCancel, 10);
  end;
end
else
begin
  MessageBeep(1);
  MessageDlg('Sorry, try another file format', mtError, [mbOk], 1);
end;
end;

function TempDir: zend_ustr;
var
  WinDir: array [0 .. 1023] of char;
begin
  GetTempPath(1023, WinDir);
  Result := zend_ustr(StrPas(WinDir));
end;

procedure T__fMain.o1Click(Sender: TObject);
begin
if od.Execute then
begin
  sc.Enabled       := True;
  close.Enabled    := True;
  if  od.FileName = LFile then begin
    MessageBeep(3);
    case MessageDlg('Do you just want to reload the file?', mtConfirmation, mbYesNo, 0) of
       mrYes: M1.Lines.LoadFromFile(LFile);
       mrNo: Exit;
    end;
  end;

  if not Lfile.Equals('!') then begin
    MessageBeep(3);
    case MessageDlg('When you load new file, the changes in the old may not be saved.'
      + #10 + #13 + 'Save changes in "' +LFile+ '"?', mtConfirmation, mbYesNoCancel, 1) of
      mrYes: M1.Lines.SaveToFile(LFile);
      mrCancel: Exit;
    end;
  end;

  if FileExists(  od.FileName ) then
  begin
      M1.Lines.LoadFromFile(  od.FileName );
      LFile :=  od.FileName;
      Self.Caption     := 'Soul Engine - ' + LFile;
  end
  else
  begin
      MessageBeep( 7 );
      MessageDlg('Where did you move "' +  od.FileName + '"?' + #10 + #13 + 'Program cannot load it anymore!', mtError, mbOKCancel, 10);
  end;
end;
end;

procedure T__fMain.R2Click(Sender: TObject);
begin
if od.Execute then
    phpMOD.RunFile(od.FileName);
end;

procedure T__fMain.s1Click(Sender: TObject);
begin
  if sd.Execute then
  begin
    M1.Lines.SaveToFile( sd.FileName );
    M1.Modified := False;
    LFile := sd.FileName;
  end;
end;

procedure T__fMain.scClick(Sender: TObject);
begin
  if LFile.Equals('!') then
  Exit;
  M1.Lines.SaveToFile(LFile);
  M1.Modified := False;
  M1.Lines.Clear;
  LFile            := '!';
  Self.Caption     := 'Soul Engine';
  sc.Enabled       := False;
  close.Enabled    := False;
end;

procedure T__fMain.sClick(Sender: TObject);
begin
  if LFile.Equals('!') then Exit;

  M1.Lines.SaveToFile(LFile);
  M1.Modified := False;
end;


  initialization
  ReportMemoryLeaksOnShutdown := True;
  LFile := GetLocaleFile('code.php');
end.
