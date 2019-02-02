{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: Unit1.pas,v 7.0 04/2007 delphi32 Exp $ }

//This demo project shows how to access published property
//of Delphi components from PHP script

{$I PHP.INC}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, php4delphi, PHPCommon;

type

  TMyButton = class(TButton)
  private
    function GetFontSize: integer;
    procedure SetFontSize(const Value: integer);
  published
    property FontSize : integer read GetFontSize write SetFontSize;
  end;

  TfrmTest = class(TForm)
    memScript: TMemo;
    btnExecute: TButton;
    PHP: TpsvPHP;
    Label1: TLabel;
    PHPEngine: TPHPEngine;
    procedure btnExecuteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    btnClose : TMyButton;
  end;

var
  frmTest: TfrmTest;

implementation

{$R *.DFM}
{$R WindowsXP.res}

procedure TfrmTest.btnExecuteClick(Sender: TObject);
begin
  PHP.RunCode(memScript.Lines.Text);
end;

procedure TfrmTest.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTest.FormCreate(Sender: TObject);
begin
  btnClose := TMyButton.Create(Self);
  with btnClose do
  begin
    Name := 'btnClose';
    Parent := Self;
    Left := 384;
    Top := 42;
    Width := 75;
    Height := 25;
    Caption := '&Close';
    TabOrder := 2;
    OnClick := btnCloseClick;
  end;

   memScript.Lines.Clear;
   with memScript.Lines do
   begin
  {$IFDEF PHP4}
    Add('$btnClose = register_delphi_component("btnClose");');
    Add('$frmTest =   register_delphi_component("frmTest");');
    Add('$btnClose->Caption = "&Exit";');
    Add('$frmTest->Caption = "PHP4Delphi demo";');
    Add('$btnClose->Top =  150;');
    Add('$btnClose->Font->Size = 10;');
    Add('$btnClose->Cursor = -21;');
    Add('$frmTest->Color = clGreen;');
    Add('$st = delphi_input_box("InputBox", "Type your message", "Done");');
    Add('delphi_show_message($st);');
  {$ELSE}
    Add('$btnClose = register_delphi_component("btnClose");');
    Add('$frmTest =   register_delphi_component("frmTest");');
    Add('$btnClose->Caption = "&Exit";');
    Add('$frmTest->Caption = "PHP4Delphi demo";');
    Add('$btnClose->Top =  150;');
    Add('$btnClose->FontSize = 10;');
    Add('$btnClose->Cursor = -21;');
    Add('$frmTest->Color = clGreen;');
    Add('$st = delphi_input_box("InputBox", "Type your message", "Done");');
    Add('delphi_show_message($st);');
  {$ENDIF}
   end;
   PHPEngine.StartupEngine;
end;

procedure TfrmTest.FormDestroy(Sender: TObject);
begin
   btnClose.Free;
   PHPEngine.ShutdownEngine;
end;

{ TMyButton }

function TMyButton.GetFontSize: integer;
begin
  Result := Font.Size;
end;

procedure TMyButton.SetFontSize(const Value: integer);
begin
  Font.Size := Value;
end;

end.
