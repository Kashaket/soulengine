{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.telenet.be/ws36637                       }
{*******************************************************}
{$I PHP.INC}

{ $Id: DelphiFunctions.pas,v 7.4 10/2009 delphi32 Exp $ }

unit DelphiFunctions;

interface
uses
  SysUtils, Classes,
  ZendTypes, ZendAPI, PHPTypes, PHPAPI, VCL.Dialogs;

{$ifdef fpc}
   {$mode delphi}
{$endif}

//proto string delphi_input_box(string caption, string prompt, string default)
{$IFDEF PHP510}
procedure delphi_input_box(ht : integer; return_value : pzval; return_value_ptr : ppzval;
        this_ptr : pzval;  return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_input_box(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}

implementation

//proto string delphi_input_box(string caption, string prompt, string default)
{$IFDEF PHP510}
procedure delphi_input_box(ht : integer; return_value : pzval; return_value_ptr : ppzval;
        this_ptr : pzval;  return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_input_box(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var p: pzval_array;
begin
if ht <> 3 then
begin
  zend_wrong_param_count(TSRMLS_DC);
  exit;
end;
   zend_get_parameters_my(ht, p, TSRMLS_DC);
   ZVAL_STRINGW(return_value, PWideChar(InputBox( Z_STRVAL(p[0]^), Z_STRVAL(p[1]^), Z_STRVAL(p[2]^)  )), true);
   dispose_pzval_array(p);
end;

end.
