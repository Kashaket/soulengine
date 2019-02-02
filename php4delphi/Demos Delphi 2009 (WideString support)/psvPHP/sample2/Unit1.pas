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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,  php4delphi, PHPCommon;

type
  TForm1 = class(TForm)
    psvPHP1: TpsvPHP;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    PHPEngine: TPHPEngine;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R WindowsXP.res}

procedure TForm1.Button1Click(Sender: TObject);
begin
  PHPEngine.StartupEngine;
  psvPHP1.Variables.Items[0].Value := AnsiString(Edit1.text);
  psvPHP1.Variables.Items[1].Value := AnsiString(Edit2.text);
  psvPHP1.RunCode('$z =  $x + $y;');
  Label3.Caption := string(psvPHP1.VariableByName('z').Value);
  PHPEngine.ShutdownAndWaitFor;
end;

end.
