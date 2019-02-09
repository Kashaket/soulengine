program ManageThreads;

uses
  Forms,
  frm_main in 'frm_main.pas' {frmMain},
  php_thread in 'php_thread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
