{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: Unit1.pas,v 7.0 04/2007 delphi32 Exp $ }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PHPCustomLibrary, phpLibrary, php4delphi, PHPAPI, ZENDAPI,
  PHPFunctions, ZendTypes, phpTypes, PHPCommon;

type
  TfrmLibDemo = class(TForm)
    psvPHP1: TpsvPHP;
    PHPLibrary1: TPHPLibrary;
    Memo1: TMemo;
    Button1: TButton;
    btnExecute: TButton;
    PHPEngine: TPHPEngine;
    procedure Button1Click(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure PHPLibrary1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar : TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPLibrary1Functions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar : TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLibDemo: TfrmLibDemo;

implementation

{$R *.DFM}
{$R WindowsXP.res}

procedure TfrmLibDemo.Button1Click(Sender: TObject);
begin
  ShowMessage('Click');
end;

procedure TfrmLibDemo.btnExecuteClick(Sender: TObject);
begin
  PHPEngine.StartupEngine;
  psvPhp1.RunCode(memo1.Lines.text);
  PHPEngine.ShutdownAndWaitFor;
end;

procedure TfrmLibDemo.PHPLibrary1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);
begin
  frmLibDemo.Caption := Parameters[0].Value;
end;

procedure TfrmLibDemo.PHPLibrary1Functions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);
begin
  Button1.Click;
end;

end.
