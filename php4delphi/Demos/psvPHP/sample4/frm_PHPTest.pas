unit frm_PHPTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  php4delphi, StdCtrls, ExtCtrls, PHPCommon;

type
  TfrmPHPTest = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    memoScript: TMemo;
    MemoResult: TMemo;
    psvPHP: TpsvPHP;
    PHPEngine: TPHPEngine;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPHPTest: TfrmPHPTest;

implementation

{$R *.DFM}
{$R WindowsXP.res}

procedure TfrmPHPTest.Button1Click(Sender: TObject);
begin
  MemoResult.Text := psvPHP.RunCode(memoScript.Text);
end;

procedure TfrmPHPTest.FormCreate(Sender: TObject);
begin
   PHPEngine.StartupEngine;
end;

procedure TfrmPHPTest.FormDestroy(Sender: TObject);
begin
   PHPEngine.ShutdownAndWaitFor;
end;

end.
