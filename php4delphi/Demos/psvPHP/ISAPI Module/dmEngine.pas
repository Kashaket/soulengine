unit dmEngine;

interface

uses
  SysUtils, Classes, PHPCommon, php4delphi, PHPCustomLibrary, phpLibrary,
  PHPFunctions;

type
  TEngineModule = class(TDataModule)
    PHPEngine: TPHPEngine;
    PHPLibrary: TPHPLibrary;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure PHPLibraryFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EngineModule: TEngineModule;

implementation

uses dmMain;

{$R *.dfm}

procedure TEngineModule.DataModuleCreate(Sender: TObject);
begin
   PHPEngine.StartupEngine;
end;

procedure TEngineModule.DataModuleDestroy(Sender: TObject);
begin
  PHPEngine.ShutdownAndWaitFor;
end;

procedure TEngineModule.PHPLibraryFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant;
  ZendVar: TZendVariable; TSRMLS_DC: Pointer);
var
  DM : TMainModule;
begin
  DM := TMainModule(Parameters.ParamByName('nb_pointer').ZendVariable.AsInteger);
  if DM <> nil then
    ZendVar.AsString := DM.EventString
      else
        ZendVar.AsString := 'Result is not defined';
end;

end.
