unit Unit1;

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

  TOneWireWrapper = class(TPHPExtension)
    procedure OneWireWrapperFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar : TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OneWireWrapper: TOneWireWrapper;

implementation

{$R *.DFM}

procedure TOneWireWrapper.OneWireWrapperFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);
var
 variable : pzval;
 ar : array of AnsiString;
 cnt : integer;
 tmp : ^ppzval;
begin
  //This function reads array parameter
  variable := Parameters.ParamByName('a').ZendValue;
  if variable^._type = IS_ARRAY then
   begin
     SetLength(ar, zend_hash_num_elements(variable^.value.ht));
     for cnt := 0 to zend_hash_num_elements(variable^.value.ht) -1  do
      begin
        new(tmp);
        zend_hash_index_find(variable^.value.ht, cnt, tmp);
        ar[cnt] := tmp^^^.value.str.val;
        freemem(tmp);
      end;
     //Array is stored now in "ar" variable
     //Lets do something with it
     ReturnValue := '';
     for cnt := 0 to Length(ar) - 1 do
      ReturnValue := ReturnValue + ar[cnt];
   end
    else
      ReturnValue := '';
end;

end.