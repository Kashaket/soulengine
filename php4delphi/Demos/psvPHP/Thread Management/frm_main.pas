unit frm_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PHPCommon, php4delphi, IdBaseComponent, IdThreadMgr,
  IdThreadMgrPool, StdCtrls, psAPI;

type
  TfrmMain = class(TForm)
    Pool: TIdThreadMgrPool;
    PHPEngine: TPHPEngine;
    btnRun: TButton;
    btnClose: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
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
  Memo1.Lines.Clear;
  for cnt := 0 to 99 do
   begin
     T := TPHPThread(Pool.GetThread);
     T.Pool := Pool;
     T.Start;
   end;
end;

end.
