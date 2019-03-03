program syntaxCheck;

uses
  Forms,
  uMain in 'uMain.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := false;
  Application.CreateForm(TfmMain, fmMain);
  mainFunc();
  Application.Terminate;
  Application.Run;
end.
