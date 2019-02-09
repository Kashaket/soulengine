library rarp;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  Unit1 in 'Unit1.pas' {OneWireWrapper: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TOneWireWrapper, OneWireWrapper);
  Application.Run;
end.