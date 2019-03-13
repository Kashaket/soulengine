{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: phpTypes.pas,v 7.4 10/2009 delphi32 Exp $ }

unit PHPTypes;

interface

uses
  {$IFNDEF FPC} Windows{$ELSE} LCLType{$ENDIF}, ZENDTypes;

{$IFDEF PHP4}
const
  phpVersion = 4;
{$ELSE}
const
  phpVersion = 5;
{$ENDIF}
    
const
  TRequestName : array [0..3] of zend_ustr =
  ('GET',
   'PUT',
   'POST',
   'HEAD');


const
 // connection status states
 PHP_CONNECTION_NORMAL   = 0;
 PHP_CONNECTION_ABORTED  = 1;
 PHP_CONNECTION_TIMEOUT  = 2;

 PARSE_POST = 0;
 PARSE_GET  = 1;
 PARSE_COOKIE  = 2;
 PARSE_STRING  = 3;

const
  SAPI_HEADER_ADD = (1 shl 0);
  SAPI_HEADER_DELETE_ALL = (1 shl 1);
  SAPI_HEADER_SEND_NOW = (1 shl 2);
  SAPI_HEADER_SENT_SUCCESSFULLY = 1;
  SAPI_HEADER_DO_SEND = 2;
  SAPI_HEADER_SEND_FAILED = 3;
  SAPI_DEFAULT_MIMETYPE = 'text/html';
  SAPI_DEFAULT_CHARSET = '';
  SAPI_PHP_VERSION_HEADER = 'X-Powered-By: PHP';


const
 short_track_vars_names : array [0..5] of zend_ustr =
  ('_POST',
   '_GET',
   '_COOKIE',
   '_SERVER',
   '_ENV',
   '_FILES' );


const
  PHP_ENTRY_NAME_COLOR = '#ccccff';
  PHP_CONTENTS_COLOR = '#cccccc';
  PHP_HEADER_COLOR = '#9999cc';
  PHP_INFO_GENERAL = (1 shl 0);
  PHP_INFO_CREDITS = (1 shl 1);
  PHP_INFO_CONFIGURATION = (1 shl 2);
  PHP_INFO_MODULES = (1 shl 3);
  PHP_INFO_ENVIRONMENT = (1 shl 4);
  PHP_INFO_VARIABLES = (1 shl 5);
  PHP_INFO_LICENSE = (1 shl 6);
  PHP_INFO_ALL = $FFFFFFFF;
  PHP_CREDITS_GROUP = (1 shl 0);
  PHP_CREDITS_GENERAL = (1 shl 1);
  PHP_CREDITS_SAPI = (1 shl 2);
  PHP_CREDITS_MODULES = (1 shl 3);
  PHP_CREDITS_DOCS = (1 shl 4);
  PHP_CREDITS_FULLPAGE = (1 shl 5);
  PHP_CREDITS_QA = (1 shl 6);
  PHP_CREDITS_WEB = (1 shl 7);
  PHP_CREDITS_ALL = $FFFFFFFF;
  PHP_LOGO_GUID = 'PHPE9568F34-D428-11d2-A769-00AA001ACF42';
  PHP_EGG_LOGO_GUID = 'PHPE9568F36-D428-11d2-A769-00AA001ACF42';
  ZEND_LOGO_GUID = 'PHPE9568F35-D428-11d2-A769-00AA001ACF42';
  PHP_CREDITS_GUID = 'PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000';


const
  ENT_HTML_QUOTE_NONE = 0;
  ENT_HTML_QUOTE_SINGLE = 1;
  ENT_HTML_QUOTE_DOUBLE = 2;
  ENT_COMPAT = ENT_HTML_QUOTE_DOUBLE;
  ENT_QUOTES = (ENT_HTML_QUOTE_DOUBLE or ENT_HTML_QUOTE_SINGLE);
  ENT_NOQUOTES = ENT_HTML_QUOTE_NONE;


const
  PHP_INI_USER = ZEND_INI_USER;
  PHP_INI_PERDIR = ZEND_INI_PERDIR;
  PHP_INI_SYSTEM = ZEND_INI_SYSTEM;
  PHP_INI_ALL = ZEND_INI_ALL;
  PHP_INI_DISPLAY_ORIG = ZEND_INI_DISPLAY_ORIG;
  PHP_INI_DISPLAY_ACTIVE = ZEND_INI_DISPLAY_ACTIVE;
  PHP_INI_STAGE_STARTUP = ZEND_INI_STAGE_STARTUP;
  PHP_INI_STAGE_SHUTDOWN = ZEND_INI_STAGE_SHUTDOWN;
  PHP_INI_STAGE_ACTIVATE = ZEND_INI_STAGE_ACTIVATE;
  PHP_INI_STAGE_DEACTIVATE = ZEND_INI_STAGE_DEACTIVATE;
  PHP_INI_STAGE_RUNTIME = ZEND_INI_STAGE_RUNTIME;

const
  TRACK_VARS_POST = 0;
  TRACK_VARS_GET = 1;
  TRACK_VARS_COOKIE = 2;
  TRACK_VARS_SERVER = 3;
  TRACK_VARS_ENV = 4;
  TRACK_VARS_FILES = 5;

type
 error_handling_t = (EH_NORMAL, EH_SUPPRESS, EH_THROW);


type
  TRequestType = (rtGet, rtPut, rtPost, rtHead);
  TPHPRequestType = (prtGet, prtPost);

type
  Psapi_header_struct = ^Tsapi_header_struct;
  sapi_header_struct =
    record
      header : zend_pchar;
      header_len : uint;
      {$IFNDEF PHP530}
      replace : zend_bool;
      {$ENDIF}
    end;
  Tsapi_header_struct = sapi_header_struct;

  Psapi_headers_struct = ^Tsapi_headers_struct;
  sapi_headers_struct =
    record
      headers : zend_llist;
      http_response_code : Integer;
      send_default_content_type : Byte;
      mimetype : zend_pchar;
      http_status_line : zend_pchar;
    end;
   Tsapi_headers_struct = sapi_headers_struct;


  Psapi_post_entry =  ^Tsapi_post_entry;
  sapi_post_entry =
    record
      content_type : zend_pchar;
      content_type_len : uint;
      post_reader : pointer;  //void (*post_reader)(TSRMLS_D);
      post_handler : pointer; //void (*post_handler)(char *content_type_dup, void *arg TSRMLS_DC);
    end;
  Tsapi_post_entry = sapi_post_entry;

{* Some values in this structure needs to be filled in before
 * calling sapi_activate(). We WILL change the `char *' entries,
 * so make sure that you allocate a separate buffer for them
 * and that you free them after sapi_deactivate().
 *}

  Psapi_request_info = ^Tsapi_request_info;
  sapi_request_info =
    record
      request_method : zend_pchar;
      query_string   : zend_pchar;
      post_data      : zend_pchar;
      raw_post_data  : zend_pchar;
      cookie_data    : zend_pchar;
      content_length : Longint;
      post_data_length : uint;
      raw_post_data_length : uint;
      path_translated : zend_pchar;
      request_uri     : zend_pchar;
      content_type    : zend_pchar;
      headers_only    : zend_bool;
      no_headers      : zend_bool;
      {$IFDEF PHP5}
      headers_read    : zend_bool;
      {$ENDIF}
      post_entry      : PSapi_post_entry;
      content_type_dup : zend_pchar;
      //for HTTP authentication
      auth_user : zend_pchar;
      auth_password : zend_pchar;
      {$IFDEF PHP510}
      auth_digest : zend_pchar;
      {$ENDIF}
      //this is necessary for the CGI SAPI module
      argv0 : zend_pchar;
      //this is necessary for Safe Mode
      current_user : zend_pchar;
      current_user_length : Integer;
      //this is necessary for CLI module
      argc : Integer;
      argv : ^zend_pchar;
      {$IFDEF PHP510}
      proto_num : integer;
      {$ENDIF}
    end;
   Tsapi_request_info = sapi_request_info;

  Psapi_header_line = ^Tsapi_header_line;
  sapi_header_line =
    record
      line : zend_pchar;
      line_len : uint;
      response_code : Longint;
    end;
   Tsapi_header_line = sapi_header_line;

  Psapi_globals_struct = ^Tsapi_globals_struct;
  _sapi_globals_struct =
    record
      server_context : Pointer;
      request_info : sapi_request_info;
      sapi_headers : sapi_headers_struct;
      read_post_bytes : Integer;
      headers_sent : Byte;
      global_stat : stat;
      default_mimetype : zend_pchar;
      default_charset : zend_pchar;
      rfc1867_uploaded_files : PHashTable;
      post_max_size : Longint;
      options : Integer;
      {$IFDEF PHP5}
      sapi_started : zend_bool;
      {$IFDEF PHP510}
      global_request_time : longint;
      known_post_content_types : THashTable;
      {$ENDIF}
      {$ENDIF}
    end;
  Tsapi_globals_struct = _sapi_globals_struct;


 Psapi_module_struct = ^Tsapi_module_struct;

 TModuleShutdownFunc = function (globals : pointer) : Integer; cdecl;
 TModuleStartupFunc  = function (sapi_module : psapi_module_struct) : integer; cdecl;

  sapi_module_struct =
    record
      name : PAnsiChar;
      pretty_name : PAnsiChar;

      startup  : TModuleStartupFunc;
      //int (*startup)(struct _sapi_module_struct *sapi_module);

      shutdown : TModuleShutdownFunc;
      //int (*shutdown)(struct _sapi_module_struct *sapi_module);

      activate : Pointer;
      // int (*activate)(TSRMLS_D);

      deactivate : Pointer;
      // int (*activate)(TSRMLS_D);

      ub_write : pointer;
      flush : pointer;
      stat : pointer;
      getenv : pointer;

      sapi_error : pointer;

      header_handler : pointer;
      send_headers : pointer;
      send_header : pointer;

      read_post : pointer;
      read_cookies : pointer;

      register_server_variables : pointer;
      log_message : pointer;
      get_request_time : pointer;
      terminate_process : pointer;

      php_ini_path_override : PAnsiChar;

      block_interruptions : pointer;
      unblock_interruptions : pointer;

      default_post_reader : pointer;
      treat_data : pointer;
      executable_location : PAnsiChar;

      php_ini_ignore : Integer;

      // PHP 5.4
      php_ini_ignore_cwd : Integer;

      get_fd : pointer;
      force_http_10 : pointer;
      get_target_uid : pointer;
      get_target_gid : pointer;

      input_filter : pointer;

      ini_defaults : pointer;

      phpinfo_as_text : integer;

      ini_entries : PAnsiChar;

      additional_functions: Pointer;
      input_filter_init : Pointer;
    end;

   Tsapi_module_struct = sapi_module_struct;


type
  PPHP_URL = ^TPHP_URL;
  Tphp_url =
    record
      scheme : zend_pchar;
      user : zend_pchar;
      pass : zend_pchar;
      host : zend_pchar;
      port : Smallint;
      path : zend_pchar;
      query : zend_pchar;
      fragment : zend_pchar;
    end;


type
  arg_separators =
    record
      output : zend_pchar;
      input : zend_pchar;
    end;

type
    Pphp_Core_Globals = ^TPHP_core_globals;
    Tphp_core_globals =
    record
      magic_quotes_gpc     : zend_bool;
      magic_quotes_runtime : zend_bool;
      magic_quotes_sybase  : zend_bool;
      safe_mode            : zend_bool;
      allow_call_time_pass_reference : boolean;
      implicit_flush : boolean;
      output_buffering : Integer;
      safe_mode_include_dir : zend_pchar;
      safe_mode_gid : boolean;
      sql_safe_mode : boolean;
      enable_dl :boolean;
      output_handler : zend_pchar;
      unserialize_callback_func : zend_pchar;
      safe_mode_exec_dir : zend_pchar;
      memory_limit : Longint;
      max_input_time : Longint;
      track_errors : boolean;
      display_errors : boolean;
      display_startup_errors : boolean;
      log_errors : boolean;
      log_errors_max_len : Longint;
      ignore_repeated_errors : boolean;
      ignore_repeated_source : boolean;
      report_memleaks : boolean;
      error_log : zend_pchar;
      doc_root : zend_pchar;
      user_dir : zend_pchar;
      include_path : zend_pchar;
      open_basedir : zend_pchar;
      extension_dir : zend_pchar;
      upload_tmp_dir : zend_pchar;
      upload_max_filesize : Longint;
      error_append_string : zend_pchar;
      error_prepend_string : zend_pchar;
      auto_prepend_file : zend_pchar;
      auto_append_file : zend_pchar;
      arg_separator : arg_separators;
      gpc_order : zend_pchar;
      variables_order : zend_pchar;
      rfc1867_protected_variables : THashTable;
      connection_status : Smallint;
      ignore_user_abort : Smallint;
      header_is_being_sent : Byte;
      tick_functions : zend_llist;
      http_globals : array[0..5] of pzval;
      expose_php : boolean;
      register_globals : boolean;
      register_argc_argv : boolean;
      y2k_compliance : boolean;
      docref_root : zend_pchar;
      docref_ext : zend_pchar;
      html_errors : boolean;
      xmlrpc_errors : boolean;
      xmlrpc_error_number : Longint;
      modules_activated : boolean;
      file_uploads : boolean;
      during_request_startup : boolean;
      allow_url_fopen : boolean;
      always_populate_raw_post_data : boolean;
      {$IFDEF PHP510}
      report_zend_debug : boolean;
      last_error_message : zend_pchar;
      last_error_file : zend_pchar;
      last_error_lineno : integer;
      {$IFNDEF PHP530}
      error_handling : error_handling_t;
      exception_class : Pointer;
      {$ENDIF}
      disable_functions : zend_pchar;
      disable_classes : zend_pchar;
      {$ENDIF}
      {$IFDEF PHP520}
      allow_url_include : zend_bool;
      com_initialized : zend_bool;
      max_input_nesting_level : longint;
      in_user_include : zend_bool;
      {$ENDIF}

      {$IFDEF PHP530}
      user_ini_filename : zend_pchar;
      user_ini_cache_ttl : longint;
      request_order : zend_pchar;
      mail_x_header : zend_bool;
      mail_log : zend_pchar;
      {$ENDIF}
    end;

implementation

end.

