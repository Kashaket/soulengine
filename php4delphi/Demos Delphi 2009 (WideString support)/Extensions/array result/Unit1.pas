{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}

{ $Id: Unit1.pas,v 7.4 10/2009 delphi32 Exp $ }

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

  TPHPExtension1 = class(TPHPExtension)
    procedure PHPExtension1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar : TZendVariable; TSRMLS_DC: Pointer);
    procedure PHPExtension1Functions1Execute(Sender: TObject;
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

var
  pval : pzval;
  cnt  : integer;
  MonthName : AnsiString;
begin
 // Function get_my_array returns an array as result
 // This demo shows how to use zend variable and work with complex
 // PHP types

 pval := ZendVar.AsZendVariable;
 if _array_init(pval, nil, 0) = FAILURE then
  begin
    php_error_docref(nil , TSRMLS_DC, E_ERROR, 'Unable to initialize array');
    ZVAL_FALSE(pval);
    Exit;
  end;

  for cnt := 1 to 12 do
   begin
     MonthName := AnsiString(LongMonthNames[cnt]);
     add_next_index_string(pval, PAnsiChar(MonthName),  1);
   end;

end;

procedure TPHPExtension1.PHPExtension1Functions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);
var
  pval : pzval;
  cnt  : integer;
  months : pzval;
  smonths : pzval;

  MonthNameLong  : AnsiString;
  MonthNameShort : AnsiString;
begin
 pval := ZendVar.AsZendVariable;
 if _array_init(pval, nil, 0) = FAILURE then
  begin
    php_error_docref(nil , TSRMLS_DC, E_ERROR, 'Unable to initialize array');
    ZVAL_FALSE(pval);
    Exit;
  end;

  months := MAKE_STD_ZVAL;
  smonths := MAKE_STD_ZVAL;

  _array_init(months, nil, 0);
  _array_init(smonths, nil, 0);

  for cnt := 1 to 12 do
   begin
     MonthNameLong := AnsiString(LongMonthNames[cnt]);
     MonthNameShort := AnsiString(ShortMonthNames[cnt]);
     add_next_index_string(months,  PAnsiChar(MonthNameLong), 1);
     add_next_index_string(smonths, PAnsiChar(MonthNameShort), 1);
   end;

  add_assoc_zval_ex(pval, 'months', strlen('months') + 1, months);
  add_assoc_zval_ex(pval, 'abbrevmonths', strlen('abbrevmonths') + 1, smonths);
  
end;

end.