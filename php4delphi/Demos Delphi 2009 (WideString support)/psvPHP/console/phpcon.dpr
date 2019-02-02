{$APPTYPE CONSOLE}

{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: phpcon.dpr,v 7.0 04/2007 delphi32 Exp $ }

program phpcon;

uses SysUtils, php4delphi;

var
 php    : TpsvPHP;
 Engine : TPHPEngine;
begin
 if ParamCount <> 1 then
  begin
    writeln(Format('Usage: %s <filename.php>', [ParamStr(0)]));
    Halt(1);
  end;
 Engine := TPHPEngine.Create(nil);
 Engine.StartupEngine;
 php := TpsvPHP.Create(nil);
 php.FileName := AnsiString(ParamStr(1));
 write(php.Execute);
 php.Free;
 Engine.ShutdownEngine;
 Engine.Free;
end.
