{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

unit Unit1;

{$I PHP.INC}

{ $Id: Unit1.pas,v 7.0 04/2007 delphi32 Exp $ }

interface

uses
  Windows, Messages, SysUtils,
  {$IFDEF VERSION6} Variants, {$ENDIF} Classes, Graphics, Controls, Forms,
  Dialogs, php4delphi, StdCtrls, PHPCommon;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    psvPHP1: TpsvPHP;
    PHPEngine: TPHPEngine;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R WindowsXP.res}

procedure TForm1.Button1Click(Sender: TObject);
begin
  psvPHP1.RunCode(Memo1.Lines.text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  psvPHP1.RunCode(Memo2.Lines.text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShowMessage(psvPHP1.RunCode(Memo3.Lines.text));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PHPEngine.StartupEngine;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PHPEngine.ShutdownAndWaitFor;
end;

end.
