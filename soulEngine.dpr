program soulEngine;
{$I PHP.inc}
{$I sDef.inc}
{$IFDEF PHP_UNICODE}
  {$DEFINE Unicode}
{$ENDIF}
uses
  Forms,
  Dialogs,
  SysUtils,
  uMain in 'uMain.pas' {__fMain},
  uMainForm in 'uMainForm.pas' {__mainForm},
  uPHPMod in 'uPHPMod.pas' {phpMOD: TDataModule},
  uGuiScreen in 'uGuiScreen.pas',
  uApplication in 'uApplication.pas',
  regGui in 'regGui.pas';

{$R *.res}


begin
  Application.Initialize;

  Application.MainFormOnTaskBar := false;
  Application.ShowMainForm      := false;


  Application.CreateForm(T__mainForm, __mainForm);
  Application.CreateForm(T__fMain, __fMain);
  Application.CreateForm(TphpMOD, phpMOD);
   T__fMain.loadEngine(dllPHPPath);

    __mainForm.FormActivate(__mainForm);

  Application.Run;
end.

