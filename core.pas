unit core;
{$I 'sDef.inc'}
{$ifdef fpc}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  Classes, SysUtils, Forms, php4delphi, zendAPI, phpAPI, PHPTypes,
  regGui, guiComponents, guiForms, guiWinAPI, guiProperties, dsUtils,
  {$IFDEF EXT_WINCALL}
  php_WinCall_ext,
  {$ENDIF}
  {$IFDEF ADD_CHROMIUM}
  guiChromium,
  {$ENDIF}

  uPhpEvents;

var
  myPHPEngine: TPHPEngine;
  mypsvPHP: TpsvPHP;

function getPsvPHP(): TpsvPHP;
procedure core_Init(aPHPEngine: TPHPEngine = nil; aPsvPHP: TpsvPHP = nil);


implementation

function getPsvPHP(): TpsvPHP;
begin
  Result := mypsvPHP;
end;

procedure core_Init(aPHPEngine: TPHPEngine = nil; aPsvPHP: TpsvPHP = nil);
begin
{$IFDEF ADD_CHROMIUM}
    LoadChromium;
  {$ENDIF}
  regGui.registerGui();

  if aPHPEngine = nil then
    myPHPEngine := TPHPEngine.Create(Application)
  else
    myPHPEngine := aPHPEngine;

  if aPsvPHP = nil then
    mypsvPHP := TpsvPHP.Create(Application)
  else
    mypsvPHP := aPsvPHP;

  InitializeEventSystem(myPHPEngine);
  InitializeGuiComponents(myPHPEngine);
  InitializeGuiForms(myPHPEngine);
  InitializeGuiWinAPI(myPHPEngine);
  InitializeGuiProperties(myPHPEngine);

  {$IFDEF ADD_CHROMIUM}
  InitializeGuiChromium(myPHPEngine);
  {$ENDIF}
  InitializeDsUtils(myPHPEngine);
  {$IFDEF EXT_WINCALL}
  myPHPEngine.AddModule( php_WinCall_ext.get_module );
  {$ENDIF}
  myPHPEngine.StartupEngine;
  {$IFDEF EXT_WINCALL}
  php_WinCall_ext.Init( aPsvPHP );
  {$ENDIF}
end;


end.


