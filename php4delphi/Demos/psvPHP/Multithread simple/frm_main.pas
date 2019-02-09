unit frm_main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PHPCommon, php4delphi, StdCtrls;

type
  TfrmMain = class(TForm)
    PHPEngine: TPHPEngine;
    btnRun: TButton;
    btnClose: TButton;
    procedure btnRunClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses php_thread;

{$R *.DFM}
{$R WindowsXP.res}

procedure TfrmMain.btnRunClick(Sender: TObject);
var
 cnt : integer;
 T : TPHPThread;
begin
  for cnt := 0 to 99 do
   begin
     T := TPHPThread.Create(true);
     T.FreeOnTerminate := true;
     T.Resume;
   end;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  PHPEngine.StartupEngine;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  PHPEngine.ShutdownAndWaitFor;
end;

end.
