program MultithreadSample;

uses
  Forms,
  frm_main in 'frm_main.pas' {frmMain},
  php_thread in 'php_thread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
