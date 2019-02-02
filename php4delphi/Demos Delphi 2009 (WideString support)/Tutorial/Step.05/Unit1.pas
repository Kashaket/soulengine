{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

unit Unit1;

{ $Id: Unit1.pas,v 7.0 04/2007 delphi32 Exp $ }

interface

uses
   Windows,
   Messages,
   SysUtils,
   Classes,
   Forms,
   zendTypes,
   zendAPI,
   phpTypes,
   phpAPI,
   phpFunctions,
   PHPModules;

type

  TPHPExtension1 = class(TPHPExtension)
    procedure PHPExtension1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar : TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PHPExtension1: TPHPExtension1;

implementation

{$R *.DFM}

procedure TPHPExtension1.PHPExtension1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);

begin
  //just returns the received value back
  ReturnValue := Parameters[0].Value;
end;

end.