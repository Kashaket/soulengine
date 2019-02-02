program EncDemo;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Encryption Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
