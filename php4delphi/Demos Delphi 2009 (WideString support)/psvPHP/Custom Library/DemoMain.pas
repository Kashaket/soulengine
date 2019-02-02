unit DemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  phpShellLibrary, StdCtrls, php4delphi, PHPCommon;

type
  TForm1 = class(TForm)
    psvPHP: TpsvPHP;
    PHPEngine: TPHPEngine;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Lib : TphpShellLibrary;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R WindowsXP.res}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Lib := TphpShellLibrary.Create(Self);
  PHPEngine.StartupEngine;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   Lib.Free;
   PHPEngine.ShutdownEngine;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   psvPHP.RunCode('shellexecute(0, "open", "calc.exe", "", "", 0);');
end;

end.
