library phpisapitest;

uses
  Windows,
  ActiveX,
  ComObj,
  WebBroker,
  ISAPIApp,
  ISAPIThreadPool,
  ZendTypes,
  PHPTypes,
  ZendAPI,
  PHPAPI,
  php4Delphi,
  dmMain in 'dmMain.pas' {MainModule: TWebModule},
  dmEngine in 'dmEngine.pas' {EngineModule: TDataModule};

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

var
  OrgDLLProc : TDLLProc;
  EngineModule : TEngineModule;

procedure HandlerExitProc(reason : integer);
begin
  case Reason of
  DLL_THREAD_DETACH:
    begin
      ts_free_thread;
    end;
   DLL_PROCESS_DETACH:
    begin
      EngineModule.Free;
    end;
  end;

  if Assigned(OrgDLLProc) then
   OrgDLLProc(reason);
end;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  EngineModule := TEngineModule.Create(nil);
  Application.Initialize;
  OrgDLLProc := DLLProc;
  DLLProc := HandlerExitProc;
  Application.CreateForm(TMainModule, MainModule);
  Application.Run;
end.
