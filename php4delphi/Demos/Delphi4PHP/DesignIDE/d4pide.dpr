{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{$I php.inc}

library d4pide;

uses
 Windows, SysUtils, Classes, zendTypes, ZENDAPI, phpTypes, PHPAPI, jclRegistry,
 jclSysInfo;


function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin  
  Result := SUCCESS;
end;

procedure php_info_module(zend_module : Pzend_module_entry; TSRMLS_DC : pointer); cdecl;
begin  
  php_info_print_table_start();
  php_info_print_table_row(2, PChar('Delphi for PHP support'), PChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

procedure d4p_getversion (ht : integer; return_value : pzval;  return_value_ptr : pointer; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  str : string;
begin
  str := '1.0';
  ZVAL_STRING(return_value, PChar(str), true);
end;

procedure d4p_getroot (ht : integer; return_value : pzval;  return_value_ptr : pointer; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  str : string;
begin
  str := RegReadStringDef(HKEY_CURRENT_USER, 'Software\CodeGear\Delphi for PHP\1.0', 'App', '');
  ZVAL_STRING(return_value, PChar(str), true);
end;

procedure d4p_getpackages (ht : integer; return_value : pzval;  return_value_ptr : pointer; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
 L : TStringList;
 cnt : integer;
begin
 if _array_init(return_value, nil, 0) = FAILURE then
  begin
    php_error_docref(nil , TSRMLS_DC, E_ERROR, 'Unable to initialize array');
    ZVAL_FALSE(return_value);
    Exit;
  end;

  L := TStringList.Create;
  try
    RegGetValueNames (HKEY_CURRENT_USER, 'Software\CodeGear\Delphi for PHP\1.0\Packages', L);
  except
    L.Clear;
  end;
  for cnt := 0 to L.Count - 1 do

   add_next_index_string(return_value, PChar(RegReadString(HKEY_CURRENT_USER, 'Software\CodeGear\Delphi for PHP\1.0\Packages', L[cnt])), 1);

  L.Free;
end;

procedure d4p_getphpdir (ht : integer; return_value : pzval;  return_value_ptr : pointer; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  str : string;
begin
  str := RegReadStringDef(HKEY_CURRENT_USER, 'Software\CodeGear\Delphi for PHP\1.0\Internal webserver', 'PHP Directory', '');
  ZVAL_STRING(return_value, PChar(str), true);
end;

procedure d4p_getport (ht : integer; return_value : pzval;  return_value_ptr : pointer; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  str : string;
begin
  str := RegReadStringDef(HKEY_CURRENT_USER, 'Software\CodeGear\Delphi for PHP\1.0\Internal webserver', 'Port', '');
  ZVAL_STRING(return_value, PChar(str), true);
end;

procedure d4p_isrunning (ht : integer; return_value : pzval;  return_value_ptr : pointer; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
 H : DWORD;
begin
  H := GetPidFromProcessName('delphiforphp.exe');
  if H = INVALID_HANDLE_VALUE then
   ZVAL_FALSE(return_value)
    else
      ZVAL_TRUE(return_value);
end;

var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..6]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;
  ModuleEntry.size := sizeof(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.Name := 'd4pide';
  ModuleEntry.version := '1.0';
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;

  Module_entry_table[0].fname := 'd4p_getversion';
  Module_entry_table[0].handler := @d4p_getversion;
  Module_entry_table[1].fname := 'd4p_getroot';
  Module_entry_table[1].handler := @d4p_getroot;
  Module_entry_table[2].fname := 'd4p_getpackages';
  Module_entry_table[2].handler := @d4p_getpackages;
  Module_entry_table[3].fname := 'd4p_getphpdir';
  Module_entry_table[3].handler := @d4p_getphpdir;
  Module_entry_table[4].fname := 'd4p_getport';
  Module_entry_table[4].handler := @d4p_getport;
  Module_entry_table[5].fname := 'd4p_isrunning';
  Module_entry_table[5].handler := @d4p_isrunning;
  Module_entry_table[6].fname := nil;
  Module_entry_table[6].handler := nil;

  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.

