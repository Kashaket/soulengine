{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{$I php.inc}

library delphi_class2;

uses
 Windows, SysUtils, zendTypes, ZENDAPI, phpTypes, PHPAPI, DelphiFunctions;


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
  php_info_print_table_row(2, PAnsiChar('Delphi classes support'), PAnsiChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RegisterInternalClasses(TSRMLS_DC);
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;



var
  moduleEntry : Tzend_module_entry;
  DelphiTable : array [0..12] of zend_function_entry;


procedure InitDelphiFunctions;
begin
  PHP_FUNCTION(DelphiTable[0], 'delphi_date', @delphi_date);
  PHP_FUNCTION(DelphiTable[1], 'delphi_extract_file_dir', @delphi_extract_file_dir);
  PHP_FUNCTION(DelphiTable[2], 'delphi_extract_file_drive', @delphi_extract_file_drive);
  PHP_FUNCTION(DelphiTable[3], 'delphi_extract_file_name', @delphi_extract_file_name);

  DelphiTable[4].fname := 'delphi_extract_file_ext';
  DelphiTable[4].handler := @delphi_extract_file_ext;
  {$IFDEF PHP4}
  DelphiTable[4].func_arg_types := nil;
  {$ELSE}
  DelphiTable[4].arg_info := nil;
  {$ENDIF}

  DelphiTable[5].fname := 'delphi_show_message';
  DelphiTable[5].handler := @delphi_show_message;
  {$IFDEF PHP4}
  DelphiTable[5].func_arg_types := nil;
  {$ELSE}
  DelphiTable[5].arg_info := nil;
  {$ENDIF}

  DelphiTable[6].fname :=  'register_delphi_object';
  delphitable[6].handler := @register_delphi_object;
  {$IFDEF PHP4}
  DelphiTable[6].func_arg_types := nil;
  {$ELSE}
  DelphiTable[6].arg_info := nil;
  {$ENDIF}

  DelphiTable[7].fname := 'delphi_get_author';
  DelphiTable[7].handler := @delphi_get_author;
  {$IFDEF PHP4}
  DelphiTable[7].func_arg_types := nil;
  {$ELSE}
  DelphiTable[7].arg_info := nil;
  {$ENDIF}

  DelphiTable[8].fname := 'delphi_str_date';
  DelphiTable[8].handler := @delphi_str_date;
  {$IFDEF PHP4}
  DelphiTable[8].func_arg_types := nil;
  {$ELSE}
  DelphiTable[8].arg_info := nil;
  {$ENDIF}


  PHP_FUNCTION(DelphiTable[9], 'delphi_get_system_directory', @delphi_get_system_directory);


  PHP_FUNCTION(DelphiTable[10], 'delphi_input_box', @delphi_input_box);
  PHP_FUNCTION(DelphiTable[11], 'register_delphi_component', @register_delphi_component);
  DelphiTable[12].fname := nil;
  DelphiTable[12].handler := nil;
end;

function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;
  InitDelphiFunctions;
  ModuleEntry.size := sizeof(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.Name := 'delphi_class2';
  ModuleEntry.version := '1.0';
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  {$IFDEF PHP4}
  Module_entry_table[0].func_arg_types := nil;
  {$ENDIF}
  ModuleEntry.functions :=  @DelphiTable[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  {$IFDEF PHP530}
  {$IFNDEF COMPILER_VC9}
  moduleEntry.build_id := strdup(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ELSE}
  moduleEntry.build_id := StrNew(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ENDIF}
  {$ENDIF}
  Result := @ModuleEntry;
end;



exports
  get_module;

end.

