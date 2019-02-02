{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: Unit1.pas,v 7.0 04/2007 delphi32 Exp $ }

//This sample shows how to return an array as a result of PHP function
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PHPCustomLibrary, phpLibrary, php4delphi, phpFunctions, ZendAPI, PHPAPI,
  StdCtrls, ZendTypes, phpTypes, PHPCommon;

type
  TForm1 = class(TForm)
    psvPHP1: TpsvPHP;
    PHPLibrary1: TPHPLibrary;
    Button1: TButton;
    ListBox1: TListBox;
    PHPEngine: TPHPEngine;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExecuteGetArray(Sender: TObject; Parameters: TFunctionParams;
      var ReturnValue: Variant; ZendVar: TZendVariable;
      TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
    ar : array of string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R WindowsXP.res}


procedure TForm1.Button1Click(Sender: TObject);
var
 cnt : integer;
begin
  //Clear array
  SetLength(ar,0);
  //Execute code
  psvPHP1.RunCode('$z=0; $y=0; $ar=array("la","hu"); $x=45; $z = $x + $y; $count=count($ar); get_php_array();');
  //Display new value of the array
  ListBox1.Items.Clear;
  for cnt := 0 to Length(ar) - 1 do
   ListBox1.Items.Add(ar[cnt]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PHPEngine.StartupEngine;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   PHPEngine.ShutdownEngine;
end;

procedure TForm1.ExecuteGetArray(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant;
  ZendVar: TZendVariable; TSRMLS_DC: Pointer);
var
  ht  : PHashTable;
  data: ^ppzval;
  cnt : integer;
  variable : pzval;
  tmp : ^ppzval;
begin
  ht := GetSymbolsTable;
  if Assigned(ht) then
   begin
      new(data);
       if zend_hash_find(ht, 'ar', 3, data) = SUCCESS then
          begin
            variable := data^^;
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
             end;
          end;
       freemem(data);
   end;
end;

end.
