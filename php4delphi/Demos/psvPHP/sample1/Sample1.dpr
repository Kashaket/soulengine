program Sample1;

uses
  Forms,
  frm_phpDemo in 'frm_phpDemo.pas' {frmPHPDemo},
  zendAPI,
  php4delphi,
  phpAPI;

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPHPDemo, frmPHPDemo);
  Application.Run;
end.
