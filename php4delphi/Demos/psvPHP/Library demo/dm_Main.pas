unit dm_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PHPCommon, PHPCustomLibrary, phpLibrary, PHPFunctions, ZendTypes;

type
  TdmMain = class(TDataModule)
    PHPLibrary1: TPHPLibrary;
    procedure PHPLibrary1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: pzval; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

uses frm_dialog;

{$R *.DFM}

procedure TdmMain.PHPLibrary1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
  TSRMLS_DC: Pointer);
begin
  Form2 := TForm2.Create(Application);
  Form2.ShowModal;
  Form2.Free;
end;

end.
