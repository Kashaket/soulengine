unit frm_main;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, PHPCommon, php4delphi, IdBaseComponent, IdThreadMgr,
  IdThreadMgrPool, StdCtrls, psAPI, PHPCustomLibrary, phpLibrary,
  phpFunctions, ZendAPI, PHPAPI, ZendTypes, PHPTypes;

type
  TfrmMain = class(TForm)
    Pool: TIdThreadMgrPool;
    PHPEngine: TPHPEngine;
    btnRun: TButton;
    btnClose: TButton;
    MemoCode: TMemo;
    MemoOut: TMemo;
    PHPLibrary1: TPHPLibrary;
    btnNoThreads: TButton;
    psvPHP: TpsvPHP;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure PHPLibrary1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar : TZendVariable; TSRMLS_DC: Pointer);
    procedure btnNoThreadsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses php_thread;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   PHPEngine.StartupEngine;
   Pool.ThreadClass := TPHPThread;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  PHPEngine.ShutdownAndWaitFor;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
var
 cnt : integer;
 T : TPHPThread;
begin
  EmptyWorkingSet(GetCurrentProcess);
  MemoOut.Lines.Clear;
  for cnt := 0 to 100 do
   begin
     T := TPHPThread(Pool.GetThread);
     T.Pool := Pool;
     T.Code := memoCode.Text;
     T.Start;
   end;
end;

procedure TfrmMain.PHPLibrary1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue:= Parameters[0].ZendVariable.AsString;
end;

procedure TfrmMain.btnNoThreadsClick(Sender: TObject);
var
 cnt : integer;
begin
  MemoOut.Lines.Clear;
  for cnt := 0 to 100 do
   MemoOut.Lines.Add(psvPHP.RunCode(MemoCode.Lines));
end;

end.
