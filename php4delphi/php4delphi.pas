{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Developers:                                           }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{                                                       }
{ Toby Allen (Documentation)                            }
{ tobyphp@toflidium.com                                 }
{                                                       }
{ http://users.telenet.be/ws36637                       }
{ http://delphi32.blogspot.com                          }
{*******************************************************}
{$I PHP.INC}
{$ifdef fpc}
      {$mode delphi}
{$endif}
{ $Id: php4delphi.pas,v 7.4  02/2019 delphi32 Exp $ }

//  Important:
//  Please check PHP version you are using and change php.inc file
//  See php.inc for more details

{
You can download the latest version of PHP from
http://www.php.net/downloads.php
You have to download and install PHP separately.
It is not included in the package.

For more information on the PHP Group and the PHP project,
please see <http://www.php.net>.
}
unit php4delphi;

interface

uses
  Windows, Messages, SysUtils, System.Types, Classes, VCL.Graphics,
  PHPCommon, WinApi.WinSock,
  ZendTypes, PHPTypes, PHPAPI, ZENDAPI,
  DelphiFunctions, phpFunctions, strUtils, varUtils,
  {$IFDEF soulengine_build} VCL.Dialogs, {$ENDIF}
  System.UITypes;

type

  IPHPEngine = interface (IUnknown)
  ['{484AE2CA-755A-437C-9B60-E3735973D0A9}']
    procedure HandleRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer);
    function GetEngineActive : boolean;
   end;
     TPHPMemoryStream = class(TMemoryStream)
  public
    constructor Create;
    procedure SetInitialSize(ASize : integer);
  end;
  {-- PHP Events --}
  TPHPLogMessage = procedure (Sender : TObject; AText : AnsiString) of object;
  TPHPErrorEvent = procedure (Sender: TObject; AText: AnsiString;
  AType: integer; AFileName: AnsiString; ALineNo: integer) of object;
  TPHPReadPostEvent = procedure(Sender : TObject; Stream : TStream) of object;
  TPHPReadResultEvent = procedure(Sender : TObject; Stream : TStream) of object;

  { TpsvCustomPHP }
  TpsvCustomPHP = class(TPHPComponent)
  private
    FHeaders : TPHPHeaders;
    FMaxExecutionTime : integer;
    FExecuteMethod : TPHPExecuteMethod;
    FSessionActive : boolean;
    FOnRequestStartup : TNotifyEvent;
    FOnRequestShutdown : TNotifyEvent;
    FAfterExecute : TNotifyEvent;
    FBeforeExecute : TNotifyEvent;
    FTerminated : boolean;
    FVariables : TPHPVariables;
    FBuffer : TPHPMemoryStream;
    FOnLogMessage : TPHPLogMessage;
    FOnScriptError : TPHPErrorEvent;
    FFileName : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF};
    {$IFDEF PHP4}
    FWriterHandle : THandle;
    FVirtualReadHandle : THandle;
    FVirtualWriteHandle : THandle;
    FVirtualCode : AnsiString;
    {$ENDIF}
    FUseDelimiters : boolean;
    FUseMapping : boolean;
    FPostStream : TMemoryStream;
    FOnReadPost : TPHPReadPostEvent;
    FRequestType : TPHPRequestType;
    FOnReadResult : TPHPReadResultEvent;
    FContentType: AnsiString;
    {$IFDEF PHP5}
    FVirtualStream : TMemoryStream;
    {$ENDIF}
    procedure SetVariables(Value : TPHPVariables);
    procedure SetHeaders(Value : TPHPHeaders);
    function GetVariableCount: integer;
  protected

    procedure ClearBuffer;
    procedure ClearHeaders;
    procedure PrepareResult; virtual;
    procedure PrepareVariables; virtual;
    function RunTime : boolean;
    function GetThreadSafeResourceManager : pointer;
    function  CreateVirtualFile(ACode : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}) : boolean;
    procedure CloseVirtualFile;
    {$IFDEF PHP4}
    property  VirtualCode : string read FVirtualCode;
    {$ENDIF}
    function GetEngine : IPHPEngine;
  public
     TSRMLS_D : pointer;
     Thread: TThread;
    {fixed}
    procedure StartupRequest; virtual;
    procedure ShutdownRequest; virtual;
    {/fixed}

    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function  EngineActive : boolean;
    function  Execute : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}; overload;
    function  Execute(AFileName : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}) : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}; overload;
    function  RunCode(ACode : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}) : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}; overload;
    function  RunCode(ACode : TStrings) : string; overload;
    function  VariableByName(AName : AnsiString) : TPHPVariable;
    property  PostStream : TMemoryStream read FPostStream;
    property  ExecuteMethod : TPHPExecuteMethod read FExecuteMethod write FExecuteMethod default emServer;
    property  FileName  : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF} read FFileName write FFileName;
    property  Variables : TPHPVariables read FVariables write SetVariables;
    property  VariableCount : integer read GetVariableCount;
    property  OnLogMessage : TPHPLogMessage read FOnLogMessage write FOnLogMessage;
    property  OnScriptError : TPHPErrorEvent read FOnScriptError write FOnScriptError;
    property  OnRequestStartup : TNotifyEvent read FOnRequestStartup write FOnRequestStartup;
    property  OnRequestShutdown : TNotifyEvent read FOnRequestShutdown write FOnRequestShutdown;
    property  BeforeExecute : TNotifyEvent read FBeforeExecute write FBeforeExecute;
    property  AfterExecute : TNotifyEvent read FAfterExecute write FAfterExecute;
    property  ThreadSafeResourceManager : pointer read GetThreadSafeResourceManager;
    property  SessionActive : boolean read FSessionActive;
    property  UseDelimiters : boolean read FUseDelimiters write FUseDelimiters default true;
    property  MaxExecutionTime : integer read FMaxExecutionTime write FMaxExecutionTime default 0;
    property  Headers : TPHPHeaders read FHeaders write SetHeaders;
    property  OnReadPost : TPHPReadPostEvent read FOnReadPost write FOnReadPost;
    property  RequestType : TPHPRequestType read FRequestType write FRequestType default prtGet;
    property  ResultBuffer : TPHPMemoryStream read FBuffer;
    property  OnReadResult : TPHPReadResultEvent read FOnReadResult write FOnReadResult;
    property  ContentType : AnsiString read FContentType write FContentType;
  end;

  TpsvPHP = class(TpsvCustomPHP)
  published
    property About;
    property FileName;
    property Variables;
    property OnLogMessage;
    property OnScriptError;
    property OnRequestStartup;
    property OnRequestShutdown;
    property OnReadPost;
    property BeforeExecute;
    property AfterExecute;
    property UseDelimiters;
    property MaxExecutionTime;
    property RequestType;
    property OnReadResult;
    property ContentType;
  end;

  TCustomPHPLibrary = class(TPHPComponent)
  private
    FExecutor : TpsvCustomPHP;
    FLibraryName : AnsiString;
    FFunctions  : TPHPFunctions;
    FLocked: boolean;
    procedure SetFunctions(const Value : TPHPFunctions);
    procedure SetExecutor(AValue : TpsvCustomPHP);
    procedure SetLibraryName(AValue : AnsiString);
  protected
    procedure RegisterLibrary; virtual;
    procedure UnregisterLibrary; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure Refresh; virtual;
    property Executor : TpsvCustomPHP read FExecutor write SetExecutor;
    property LibraryName : AnsiString read FLibraryName write SetLibraryName;
    property Functions  : TPHPFunctions read FFunctions write SetFunctions;
    property Locked : boolean read FLocked write FLocked;
  end;
  { TPHPEngine }

  TPHPEngine = class(TPHPComponent, IUnknown, IPHPEngine)
  private
    FINIPath : AnsiString;
    FOnEngineStartup  : TNotifyEvent;
    FOnEngineShutdown : TNotifyEvent;
    FEngineActive     : boolean;
    FHandleErrors     : boolean;
    {$IFNDEF PHP540}
    FSafeMode         : boolean;
    FSafeModeGid      : boolean;
    {$ENDIF}
    FRegisterGlobals  : boolean;
    FHTMLErrors       : boolean;
    FMaxInputTime     : integer;
    FConstants        : TphpConstants;
    FDLLFolder        : AnsiString;
    FReportDLLError   : boolean;
    FLock: TRTLCriticalSection;
    FOnScriptError : TPHPErrorEvent;
    FOnLogMessage  : TPHPLogMessage;
    FWaitForShutdown : boolean;
    FHash : TStringList;
    FLibraryModule : Tzend_module_entry;
    FLibraryEntryTable : array  of zend_function_entry;
    FRequestCount : integer;
    procedure SetConstants(Value : TPHPConstants);
    function GetConstantCount: integer;
    function GetEngineActive : boolean;
  protected
    MyFuncs: TStringList;
    TSRMLS_D  : pppointer;
    procedure StartupPHP; virtual;
    procedure PrepareEngine; virtual;
    procedure PrepareIniEntry; virtual;
    procedure RegisterConstants; virtual;
    procedure RegisterInternalConstants(TSRMLS_DC : pointer); virtual;
    procedure HandleRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); virtual;
    property  RequestCount : integer read FRequestCount;
    procedure HandleError (Sender : TObject; AText : string; AType : Integer; AFileName : string; ALineNo : integer);
    procedure HandleLogMessage(Sender : TObject; AText : string);
    procedure RegisterLibrary(ALib : TCustomPHPLibrary);
    procedure RefreshLibrary;
    procedure UnlockLibraries;
    procedure RemoveRequest;
    procedure AddRequest;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AddFunction(FN: AnsiString; Func: Pointer);
    procedure  StartupEngine; virtual;
    procedure  ShutdownEngine; virtual;
    procedure  LockEngine; virtual;
    procedure  UnlockEngine; virtual;
    procedure  PrepareForShutdown; virtual;
    property   EngineActive : boolean read GetEngineActive;
    property   ConstantCount : integer read GetConstantCount;
    property   WaitForShutdown : boolean read FWaitForShutdown;
    procedure  ShutdownAndWaitFor; virtual;
    property   LibraryEntry : Tzend_module_entry read FLibraryModule;
  published
    property  HandleErrors : boolean read FHandleErrors write FHandleErrors default true;
    property  OnEngineStartup  : TNotifyEvent read FOnEngineStartup write FOnEngineStartup;
    property  OnEngineShutdown : TNotifyEvent read FOnEngineShutdown write FOnEngineShutdown;
    property  OnScriptError : TPHPErrorEvent read FOnScriptError write FOnScriptError;
    property  OnLogMessage : TPHPLogMessage read FOnLogMessage write FOnLogMessage;
    property  IniPath : AnsiString read FIniPath write FIniPath;
    {$IFNDEF PHP540}
    property  SafeMode : boolean read FSafeMode write FSafeMode default false;
    property  SafeModeGid : boolean read FSafeModeGid write FSafeModeGid default false;
    {$ENDIF}
    property  RegisterGlobals : boolean read FRegisterGlobals write FRegisterGlobals default true;
    property  HTMLErrors : boolean read FHTMLErrors write FHTMLErrors default false;
    property  MaxInputTime : integer read FMaxInputTime write FMaxInputTime default 0;
    property  Constants : TPHPConstants read FConstants write SetConstants;
    property  DLLFolder : AnsiString read FDLLFolder write FDLLFolder;
    property  ReportDLLError : boolean read FReportDLLError write FReportDLLError;
  end;

  TPHPLibrarian = class
  private
    FLibraries : TList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddLibrary(ALibrary : TCustomPHPLibrary);
    procedure RemoveLibrary(ALibrary : TCustomPHPLibrary);
    function Count : integer;
    function GetLibrary(Index : integer) : TCustomPHPLibrary;
    property Libraries : TList read FLibraries write FLibraries;
  end;
{$IFDEF REGISTER_COLORS}
const
  Colors: array[0..41] of TIdentMapEntry = (
    (Value: clBlack; Name: 'clBlack'),
    (Value: clMaroon; Name: 'clMaroon'),
    (Value: clGreen; Name: 'clGreen'),
    (Value: clOlive; Name: 'clOlive'),
    (Value: clNavy; Name: 'clNavy'),
    (Value: clPurple; Name: 'clPurple'),
    (Value: clTeal; Name: 'clTeal'),
    (Value: clGray; Name: 'clGray'),
    (Value: clSilver; Name: 'clSilver'),
    (Value: clRed; Name: 'clRed'),
    (Value: clLime; Name: 'clLime'),
    (Value: clYellow; Name: 'clYellow'),
    (Value: clBlue; Name: 'clBlue'),
    (Value: clFuchsia; Name: 'clFuchsia'),
    (Value: clAqua; Name: 'clAqua'),
    (Value: clWhite; Name: 'clWhite'),
    (Value: clScrollBar; Name: 'clScrollBar'),
    (Value: clBackground; Name: 'clBackground'),
    (Value: clActiveCaption; Name: 'clActiveCaption'),
    (Value: clInactiveCaption; Name: 'clInactiveCaption'),
    (Value: clMenu; Name: 'clMenu'),
    (Value: clWindow; Name: 'clWindow'),
    (Value: clWindowFrame; Name: 'clWindowFrame'),
    (Value: clMenuText; Name: 'clMenuText'),
    (Value: clWindowText; Name: 'clWindowText'),
    (Value: clCaptionText; Name: 'clCaptionText'),
    (Value: clActiveBorder; Name: 'clActiveBorder'),
    (Value: clInactiveBorder; Name: 'clInactiveBorder'),
    (Value: clAppWorkSpace; Name: 'clAppWorkSpace'),
    (Value: clHighlight; Name: 'clHighlight'),
    (Value: clHighlightText; Name: 'clHighlightText'),
    (Value: clBtnFace; Name: 'clBtnFace'),
    (Value: clBtnShadow; Name: 'clBtnShadow'),
    (Value: clGrayText; Name: 'clGrayText'),
    (Value: clBtnText; Name: 'clBtnText'),
    (Value: clInactiveCaptionText; Name: 'clInactiveCaptionText'),
    (Value: clBtnHighlight; Name: 'clBtnHighlight'),
    (Value: cl3DDkShadow; Name: 'cl3DDkShadow'),
    (Value: cl3DLight; Name: 'cl3DLight'),
    (Value: clInfoText; Name: 'clInfoText'),
    (Value: clInfoBk; Name: 'clInfoBk'),
    (Value: clNone; Name: 'clNone'));
{$ENDIF}
var
 Librarian : TPHPLibrarian = nil;
 delphi_sapi_module : sapi_module_struct;
 PHPEngine : TPHPEngine = nil;
 {$IFDEF soulengine_build}
  log_handler_php: string;
  fatal_handler_php: string;
  phpmd: TpsvPHP;
 {$ENDIF}
implementation

function AddSlashes(const S: ansistring): ansistring;
begin
  Result := StringReplace(S, chr(8), '8', [rfReplaceAll]);
  Result := StringReplace(S, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '''', '\''', [rfReplaceAll]);
  Result := StringReplace(Result, '<?', '''."<".chr(' + IntToStr(Ord('?')) +
    ').''', [rfReplaceAll]);
end;

{ TCustomPHPLibrary }

constructor TCustomPHPLibrary.Create(AOwner: TComponent);
begin
  inherited;
  FFunctions := TPHPFunctions.Create(Self, TPHPFunction);
  RegisterLibrary;
end;

destructor TCustomPHPLibrary.Destroy;
begin
  UnregisterLibrary;
  FFunctions.Free;
  FFunctions := nil;
  inherited;
end;

procedure TCustomPHPLibrary.Refresh;
begin
end;


procedure TCustomPHPLibrary.RegisterLibrary;
begin
   if Assigned(Librarian) then
    Librarian.AddLibrary(Self);
end;

procedure TCustomPHPLibrary.SetExecutor(AValue: TpsvCustomPHP);
begin
  if FExecutor <> AValue then
  begin
    if Assigned(FExecutor) then
     UnregisterLibrary;
    FExecutor := AValue; //Peter Enz
    if AValue <> nil then
     begin
       Avalue.FreeNotification(Self);
       RegisterLibrary;
     end;
  end;
end;

procedure TCustomPHPLibrary.SetFunctions(const Value: TPHPFunctions);
begin
  FFunctions.Assign(Value);
end;

procedure TCustomPHPLibrary.SetLibraryName(AValue: AnsiString);
begin
  if FLibraryName <> AValue then
   begin
     FLibraryName := AValue;
   end;  
end;

procedure TCustomPHPLibrary.UnregisterLibrary;
begin
  if Assigned(Librarian) then
   Librarian.RemoveLibrary(Self);
end;


procedure InitLibrarian;
begin
  Librarian := TPHPLibrarian.Create;
end;

procedure UninitLibrarian;
begin
  if Assigned(Librarian) then
   try
     Librarian.Free;
   finally
     Librarian := nil;
   end;
end;

{ TPHPLibrarian }

procedure TPHPLibrarian.AddLibrary(ALibrary: TCustomPHPLibrary);
begin
  if FLibraries.IndexOf(ALibrary) = -1 then
   FLibraries.Add(ALibrary);
end;

function TPHPLibrarian.Count: integer;
begin
  Result := FLibraries.Count;
end;

constructor TPHPLibrarian.Create;
begin
  inherited;
  FLibraries := TList.Create;
end;

destructor TPHPLibrarian.Destroy;
begin
  FLibraries.Free;
  inherited;
end;

function TPHPLibrarian.GetLibrary(Index: integer): TCustomPHPLibrary;
begin
  Result := TCustomPHPLibrary(FLibraries[Index]);
end;

procedure TPHPLibrarian.RemoveLibrary(ALibrary: TCustomPHPLibrary);
begin
  FLibraries.Remove(ALibrary);
end;
{ TPHPMemoryStream }

constructor TPHPMemoryStream.Create;
begin
  inherited;
end;

procedure TPHPMemoryStream.SetInitialSize(ASize: integer);
begin
  Capacity := ASize;
end;
{ Startup functions }
function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

{Request initialization}
function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

{Request shutdown}
function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

{$IFDEF PHP5}

{PHP 5 only}
function delphi_stream_reader (handle : pointer; buf : PAnsiChar; len : size_t; TSRMLS_DC : pointer) : size_t; cdecl;
var
 MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS =  nil then
    result := 0
     else
       try
         result := MS.Read(buf^, len);
       except
          result := 0;
       end;
end;

{PHP 5 only}
procedure delphi_stream_closer(handle : pointer; TSRMLS_DC : pointer); cdecl;
var
 MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS <> nil then
   try
     MS.Clear;
   except
   end;
end;

{$IFDEF PHP530}
function delphi_stream_fsizer(handle : pointer; TSRMLS_DC : pointer) : size_t; cdecl;
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS <> nil then
   try
     result := MS.Size;
   except
     Result := 0;
   end
    else
      Result := 0;
end;
{$ELSE}
{$IFDEF PHP510}

{ PHP 5.10 and higher }
function delphi_stream_teller(handle : pointer; TSRMLS_DC : pointer) : longint; cdecl;
var
  MS : TMemoryStream;
begin
  MS := TMemoryStream(handle);
  if MS <> nil then
   try
     result := MS.Size;
   except
     Result := 0;
   end
    else
      Result := 0;
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{ PHP Info functions }
procedure php_info_library(zend_module : Pointer; TSRMLS_DC : pointer); cdecl;
begin
end;

function php_delphi_startup(sapi_module : Psapi_module_struct) : integer; cdecl;
begin
  Result := SUCCESS;
end;

function php_delphi_deactivate(p : pointer) : integer; cdecl;
begin
  result := SUCCESS;
end;

procedure php_delphi_flush(p : pointer); cdecl;
begin
end;

function php_delphi_ub_write(str : pointer; len : uint; p : pointer) : integer; cdecl;
var
 php : TpsvPHP;
 gl : psapi_globals_struct;
begin
  Result := 0;
  gl := GetSAPIGlobals;
  if Assigned(gl) then
   begin
     php := TpsvPHP(gl^.server_context);
     if Assigned(php) then
      begin
        try
         result := php.FBuffer.Write(str^, len);
        except
        end;
      end;
   end;
end;
function php_delphi_header_handler(sapi_header : psapi_header_struct;  sapi_headers : psapi_headers_struct; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SAPI_HEADER_ADD;
end;
function php_delphi_send_header(p1, TSRMLS_DC : pointer) : integer; cdecl;
var
 php : TpsvPHP;
 gl  : psapi_globals_struct;
begin
  gl := GetSAPIGlobals;
  php := TpsvPHP(gl^.server_context);
  if Assigned(p1) and Assigned(php) then
   begin
    with php.Headers.Add do
     Header := String(Psapi_header_struct(p1)^.header);
   end;
  Result := SAPI_HEADER_SENT_SUCCESSFULLY;
end;

function php_delphi_read_cookies(p1 : pointer) : pointer; cdecl;
begin
  result := nil;
end;
function php_delphi_read_post(buf : PAnsiChar; len : uint; TSRMLS_DC : pointer) : integer; cdecl;
var
 gl : psapi_globals_struct;
 php : TpsvPHP;
begin
  gl := GetSAPIGlobals;
  if gl = nil then
   begin
     Result := 0;
     Exit;
   end;

  php := TpsvPHP(gl^.server_context);

  if PHP = nil then
   begin
     Result := 0;
     Exit;
   end;

  if php.PostStream = nil then
   begin
     Result := 0;
     Exit;
   end;

  if php.PostStream.Size = 0 then
   begin
     Result := 0;
     Exit;
   end;

  Result := php.PostStream.Read(buf^, len);
end;
function GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

procedure php_delphi_register_variables(val : pzval; p : pointer); cdecl;
var
 php : TpsvPHP;
 gl : psapi_globals_struct;
 cnt : integer;
 varcnt : integer;
begin
  gl := GetSAPIGlobals;
  if gl = nil then
   Exit;

  php := TpsvPHP(gl^.server_context);

  if PHP = nil then
   begin
     Exit;
   end;

  php_register_variable('PHP_SELF', '_', nil, p);
  php_register_variable('REMOTE_ADDR', PAnsiChar(GetLocalIP()), val, p);
  php_register_variable('IP_ADDRESS', PAnsiChar(GetLocalIP()), val, p);
  {if php.RequestType = prtPost then
   php_register_variable('REQUEST_METHOD', 'POST', val, p)
     else
       php_register_variable('REQUEST_METHOD', 'GET', val, p);}

  varcnt := PHP.Variables.Count;
  if varcnt > 0 then
   begin
      for cnt := 0 to varcnt - 1 do
       begin
         php_register_variable(PAnsiChar(php.Variables[cnt].Name),
                PAnsiChar(php.Variables[cnt].Value), val, p);
       end;
   end;
end;
function wvsprintfA(Output: PAnsiChar; Format: PAnsiChar; arglist: PAnsiChar): Integer; stdcall; external 'user32.dll';
{$IFDEF PHP4}
function WriterProc(Parameter : Pointer) : integer;
var
 n : integer;
 php : TpsvCustomPHP;
 buf : PAnsiChar;
 k : cardinal;
begin
  try
    php := TPsvCustomPHP(Parameter);
    Buf := PAnsiChar(php.FVirtualCode);
    k := length(php.FVirtualCode);
    repeat
      n := _write(php.FVirtualWriteHandle, Buf, k);
      if (n <= 0) then
       break
        else
          begin
            inc(Buf, n);
            dec(K, n);
          end;
    until (n <= 0);
    Close(php.FVirtualWriteHandle);
    php.FVirtualWriteHandle := 0;
  finally
    Result := 0;
    ExitThread(0);
  end;
end;
{$ENDIF}
{$IFDEF soulengine_build}
procedure delphi_error_cb(AType: Integer; const AFname: PAnsiChar; const ALineNo: UINT;
  const AFormat: PAnsiChar; args: PAnsiChar) cdecl;
var
  LText: string;
  LBuffer: array[0..4096] of AnsiChar;
  S: AnsiString;
begin
  case AType of
    E_ERROR:              LText := 'FATAL Error in ';
    E_WARNING:            LText := 'Warning in ';
    E_CORE_ERROR:         LText := 'Core Error in ';
    E_CORE_WARNING:       LText := 'Core Warning in ';
    E_COMPILE_ERROR:      LText := 'Compile Error in ';
    E_COMPILE_WARNING:    LText := 'Compile Warning in ';
    E_USER_ERROR:         LText := 'User Error in ';
    E_USER_WARNING:       LText := 'User Warning in ';
    E_RECOVERABLE_ERROR:  LText := 'Recoverable Error in ';
    E_PARSE:              LText := 'Parse Error in ';
    E_NOTICE:             LText := 'Notice in ';
    E_USER_NOTICE:        LText := 'User Notice in ';
    E_STRICT:             LText := 'Strict Error in ';
    E_CORE:               LText := 'Core Error in ';
    else
      LText := 'Unknown Error(' + inttostr(AType) + '): ' ;
  end;

  wvsprintfA(LBuffer, AFormat, args);

  LText := LText + AFname + '(' + inttostr(ALineNo) + '): ' + LBuffer;
  if (fatal_handler_php <> '') and not(Atype in [E_CORE_ERROR, E_CORE, E_CORE_WARNING]) then
  begin
  S := AnsiString(fatal_handler_php + '(' + IntToStr(integer(AType)) + ',' + '''' +
      AddSlashes(LBuffer) + ''', ''' + AddSlashes(AFName) + ''', ' +
      IntToStr(ALineNo) + ');' + ' ?>');

  if not phpmd.UseDelimiters then
       S := '<? ' + S;

   phpmd.RunCode(S);
   S := '';
  end
  else
  begin
  case AType of
    E_WARNING, E_CORE_WARNING, E_COMPILE_WARNING, E_USER_WARNING:
      MessageDlg(LText, mtWarning, [mbOk], 0)
    ;
    E_NOTICE, E_USER_NOTICE:
      MessageDlg(LText, mtInformation, [mbOk], 0)
    ;

    else
      MessageDlg(LText, mtError, [mbOk], 0)
  end;
  end;
end;
{$ELSE}
procedure delphi_error_cb(_type : integer; const error_filename : PAnsiChar;
   const error_lineno : uint; const _format : PAnsiChar; args : PAnsiChar); cdecl;
var
 buffer  : array[0..1023] of ansichar;
 err_msg : PAnsiChar;
 php : TpsvPHP;
 gl : psapi_globals_struct;
 p : pointer;
 error_type_str : ansistring;
 err : TPHPErrorType;
begin
  wvsprintfa(buffer, _format, args);
  err_msg := buffer;
  p := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(p);
  php := TpsvPHP(gl^.server_context);

  case _type of
   E_ERROR              : err := etError;
   E_WARNING            : err := etWarning;
   E_PARSE              : err := etParse;
   E_NOTICE             : err := etNotice;
   E_CORE_ERROR         : err := etCoreError;
   E_CORE_WARNING       : err := etCoreWarning;
   E_COMPILE_ERROR      : err := etCompileError;
   E_COMPILE_WARNING    : err := etCompileWarning;
   E_USER_ERROR         : err := etUserError;
   E_USER_WARNING       : err := etUserWarning;
   E_USER_NOTICE        : err := etUserNotice;
    else
      err := etUnknown;
  end;

  if assigned(php) then
   begin
     if Assigned(php.OnScriptError) then
        begin
           php.OnScriptError(php, Err_Msg, integer(err), error_filename, error_lineno);
        end
          else
             begin
               case _type of
                E_ERROR,
                E_CORE_ERROR,
                E_COMPILE_ERROR,
                E_USER_ERROR:
                   error_type_str := 'Fatal error';
                E_WARNING,
                E_CORE_WARNING,
                E_COMPILE_WARNING,
                E_USER_WARNING :
                   error_type_str := 'Warning';
                E_PARSE:
                   error_type_str := 'Parse error';
                E_NOTICE,
                E_USER_NOTICE:
                    error_type_str := 'Notice';
                else
                    error_type_str := 'Unknown error';
               end;

                php_log_err(PAnsiChar(AnsiFormat('PHP4DELPHI %s:  %s in %s on line %d', [error_type_str, buffer, error_filename, error_lineno])), p);
             end;
 end;
   if PHPLoaded then
    _zend_bailout(error_filename, error_lineno);
end;
{$ENDIF}
{$IFDEF soulengine_build}
function php_delphi_log_message(msg : PAnsiChar) : integer; cdecl;
var
 php : TpsvPHP;
 gl : psapi_globals_struct;
 S: ansistring;
begin
  Result := 0;
  gl := GetSAPIGlobals;
  if gl = nil then
   Exit;

  php := TpsvPHP(gl^.server_context);
  if Assigned(PHPEngine) then
   begin
     if Assigned(PHPEngine.OnLogMessage) then
       phpEngine.HandleLogMessage(php, msg)
        else
        if log_handler_php <> '' then
        begin
          S :=  AnsiString(fatal_handler_php + '(' + '''' +  AddSlashes(msg) + '''' +
               ');' + ' ?>');

            if not phpmd.UseDelimiters then
             S := '<? ' + S;

            phpmd.RunCode(S);
            S := '';
          end
          else
          MessageBoxA(0, MSG, 'PHP4Delphi', MB_OK)
       end
      else
        MessageBoxA(0, msg, 'PHP4Delphi', MB_OK);
end;
{$ELSE}
function php_delphi_log_message(msg : Pchar) : integer; cdecl;
var
 php : TpsvPHP;
 gl : psapi_globals_struct;
 p : pointer;
begin
  p := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(p);
  php := TpsvPHP(gl^.server_context);
  if Assigned(php) then
   begin
     if Assigned(php.OnLogMessage) then
       php.FOnLogMessage(php, msg)
        else
          MessageBox(0, MSG, 'PHP4Delphi', MB_OK)
    end
      else
        MessageBox(0, msg, 'PHP4Delphi', MB_OK);
  result := 0;
end;
{$ENDIF}
{ Request sender/dispatcher }

{$IFDEF PHP510}
procedure DispatchRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure DispatchRequest(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 php : TpsvPHP;
 gl : psapi_globals_struct;
 Lib : IPHPEngine;
{$IFNDEF PHP510}
 return_value_ptr : ppzval;
{$ENDIF}
begin
  {$IFNDEF PHP510}
  return_value_ptr := nil;
  {$ENDIF}
  ZVAL_NULL(return_value);
  gl := GetSAPIGlobals;
  if gl = nil then
   Exit;
  php := TpsvPHP(gl^.server_context);
  if Assigned(php) then
   begin
     try
       Lib := php.GetEngine;
       if lib <> nil then
       Lib.HandleRequest(ht, return_value, return_value_ptr, this_ptr, return_value_used, TSRMLS_DC);
     except
      ZVAL_NULL(return_value);
     end;
   end;
end;

{ TpsvCustomPHP }

constructor TpsvCustomPHP.Create(AOwner: TComponent);
begin
  inherited;
  FMaxExecutionTime := 0;
  FExecuteMethod := emServer;
  FSessionActive := false;
  FVariables := TPHPVariables.Create(Self);
  FHeaders := TPHPHeaders.Create(Self);
  FUseDelimiters := true;
  FRequestType := prtGet;
  FBuffer := TPHPMemoryStream.Create;
  {$IFDEF PHP4}
  FVirtualCode := '';
  {$ELSE}
  FVirtualStream := TMemoryStream.Create;
  {$ENDIF}
end;

destructor TpsvCustomPHP.Destroy;
begin
  FVariables.Free;
  FHeaders.Free;
  FSessionActive := False;
  FBuffer.Free;
  {$IFDEF PHP4}
  FVirtualCode := '';
  {$ELSE}
  if FVirtualStream <> nil then
   FreeAndNil(FVirtualStream);
  {$ENDIF}
  if Assigned(FPostStream) then
   FreeAndNil(FPostStream);
  inherited;
end;

procedure TpsvCustomPHP.ClearBuffer;
begin
  FBuffer.Clear;
end;

procedure TpsvCustomPHP.ClearHeaders;
begin
  FHeaders.Clear;
end;


function TpsvCustomPHP.Execute : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF};
var
  file_handle : zend_file_handle;
  {$IFDEF PHP4}
  thread_id : cardinal;
  {$ENDIF}
  {$IFDEF PHP5}
  ZendStream : TZendStream;
  {$ENDIF}
begin

  if not EngineActive then
   begin
     Result := '';
     Exit;
   end;

   if PHPEngine.WaitForShutdown then
    begin
      Result := '';
      Exit;
    end;

  PHPEngine.AddRequest;

  try
    ClearHeaders;
    ClearBuffer;

    if Assigned(FBeforeExecute) then
     FBeforeExecute(Self);



    FTerminated := false;
    if not FUseMapping then
     begin
      if not FileExists(FFileName) then
        raise Exception.CreateFmt('File %s does not exists', [FFileName]);
     end;

    StartupRequest;


    ZeroMemory(@file_handle, sizeof(zend_file_handle));

    if FUseMapping then
     begin
       {$IFDEF PHP5}
       ZeroMemory(@ZendStream, sizeof(ZendStream));
       ZendStream.reader := delphi_stream_reader;
       ZendStream.closer := delphi_stream_closer;
       {$IFDEF PHP530}
       ZendStream.fsizer := delphi_stream_fsizer;
       {$ELSE}
       {$IFDEF PHP510}
       ZendStream.fteller := delphi_stream_teller;
       {$ENDIF}
       ZendStream.interactive := 0;
       {$ENDIF}

       ZendStream.handle := FVirtualStream;

       file_handle._type := ZEND_HANDLE_STREAM;
       file_handle.opened_path := nil;
       file_handle.filename := '-';
       file_handle.free_filename := 0;
       file_handle.handle.stream := ZendStream;
       {$ELSE}
       {for PHP4 only}
       file_handle._type := ZEND_HANDLE_FD;
       file_handle.opened_path := nil;
       file_handle.filename := '-';
       file_handle.free_filename := 0;
       file_handle.handle.fd := FVirtualReadHandle;
       FWriterHandle := BeginThread(nil, 8192, @WriterProc, Self, 0, thread_id);
       {$ENDIF}
     end
      else
       begin
         file_handle._type := ZEND_HANDLE_FILENAME;
         file_handle.filename := PAnsiChar(FFileName);
         file_handle.opened_path := nil;
         file_handle.free_filename := 0;
       end;

    try
      php_execute_script(@file_handle, TSRMLS_D);
    except
      FBuffer.Clear;
      try
      ts_free_thread;
      except

      end;
    end;

    PrepareResult;


    if Assigned(FAfterExecute) then
     FAfterExecute(Self);

   //ShutdownRequest;

    FBuffer.Position := 0;
    if Assigned(FOnReadResult) then
     begin
       FOnReadResult(Self, FBuffer);
       Result := '';
     end
       else
         begin
           SetLength(Result, FBuffer.Size);
           FBuffer.Read(Result[1], FBuffer.Size);
         end;
    FBuffer.Clear;
    {$IFDEF PHP4}
    FVirtualCode := '';
    {$ENDIF}
  finally
    PHPEngine.RemoveRequest;
  end;
end;

function TpsvCustomPHP.RunCode(ACode : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}) : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF};
begin
  if not EngineActive then
   begin
     Result := '';
     Exit;
   end;

  ClearHeaders;
  ClearBuffer;
  FUseMapping := true;
  try
   if FUseDelimiters then
    begin
      if Pos('<?', ACode) = 0 then
        ACode := Format('<? %s ?>', [ACode]);
    end;
    if not CreateVirtualFile(ACode) then
      begin
        Result := '';
        Exit;
      end;
     Result := Execute;
     CloseVirtualFile;
     finally
       FUseMapping := false;
     end;
end;


function TpsvCustomPHP.RunCode(ACode: TStrings): string;
begin
  if Assigned(ACode) then
   Result := RunCode(ACode.Text);
end;


procedure TpsvCustomPHP.SetVariables(Value: TPHPVariables);
begin
  FVariables.Assign(Value);
end;

procedure TpsvCustomPHP.SetHeaders(Value : TPHPHeaders);
begin
  FHeaders.Assign(Value);
end;



function TpsvCustomPHP.Execute(AFileName: {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}): {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF};
begin
  FFileName := AFileName;
  Result := Execute;
end;

procedure TpsvCustomPHP.PrepareResult;
var
  ht  : PHashTable;
  data: ^ppzval;
  cnt : integer;
  variable : pzval;
  {$IFDEF PHP5}
  EG : pzend_executor_globals;
  {$ENDIF}
begin
  if FVariables.Count = 0 then
   Exit;

  if FExecuteMethod = emServer then
  {$IFDEF PHP4}
   ht := GetSymbolsTable
  {$ELSE}
    begin
     EG := GetExecutorGlobals;
     if Assigned(EG) then
     ht := @EG.symbol_table
      else
        ht := nil;
    end
  {$ENDIF}
    else
     ht := GetTrackHash('_GET');
  if Assigned(ht) then
   begin
     for cnt := 0 to FVariables.Count - 1  do
      begin
        new(data);
        try
          if zend_hash_find(ht, PAnsiChar(FVariables[cnt].Name),
          strlen(PAnsiChar(FVariables[cnt].Name)) + 1, data) = SUCCESS then
          begin
            variable := data^^;
            convert_to_string(variable);
            FVariables[cnt].Value := variable^.value.str.val;
          end;
        finally
          freemem(data);
        end;
      end;
   end;
end;

function TpsvCustomPHP.VariableByName(AName: AnsiString): TPHPVariable;
begin
  Result := FVariables.ByName(AName);
end;

{Indicates activity of PHP Engine}
function TpsvCustomPHP.EngineActive : boolean;
begin
  if Assigned(PHPEngine) then
   Result := PHPEngine.EngineActive
    else
      Result := false;
end;

procedure TpsvCustomPHP.StartupRequest;
var
 gl  : psapi_globals_struct;
 TimeStr : string;
begin
  if not EngineActive then
   raise EDelphiErrorEx.Create('PHP engine is not active ');

  if FSessionActive then
   Exit;

  TSRMLS_D := tsrmls_fetch;

  gl := GetSAPIGlobals;
  gl^.server_context := Self;

  if PHPEngine.RegisterGlobals then
   GetPHPGlobals(TSRMLS_D)^.register_globals := true;

  try
    if Assigned(FOnReadPost) then
     FOnReadPost(Self, FPostStream);

    zend_alter_ini_entry('max_execution_time', 19, PAnsiChar(TimeStr), Length(TimeStr), ZEND_INI_SYSTEM, ZEND_INI_STAGE_RUNTIME);

    php_request_startup(TSRMLS_D);
    if Assigned(FOnRequestStartup) then
      FOnRequestStartup(Self);

    FSessionActive := true;
  except
    FSessionActive := false;
  end;
end;

function TpsvCustomPHP.RunTime: boolean;
begin
  Result :=   not (csDesigning in ComponentState);
end;

function TpsvCustomPHP.GetThreadSafeResourceManager: pointer;
begin
  Result := TSRMLS_D;
end;

function TpsvCustomPHP.GetVariableCount: integer;
begin
  Result := FVariables.Count;
end;


procedure TpsvCustomPHP.ShutdownRequest;
var
 gl  : psapi_globals_struct;
begin
  if not FSessionActive then
   Exit;
  try

    if not FTerminated then
     begin
       try
        php_request_shutdown(nil);
       except
       end;
       gl := GetSAPIGlobals;
       gl^.server_context := nil;
     end;


    if Assigned(FOnRequestShutdown) then
      FOnRequestShutdown(Self);

  finally
    FSessionActive := false;
  end;

end;


procedure TpsvCustomPHP.PrepareVariables;
var
  ht  : PHashTable;
  data: ^ppzval;
  cnt : integer;
  {$IFDEF PHP5}
  EG : pzend_executor_globals;
  {$ENDIF}
begin
  {$IFDEF PHP4}
   ht := GetSymbolsTable;
  {$ELSE}
    begin
     EG := GetExecutorGlobals;
     if Assigned(EG) then
     ht := @EG.symbol_table
      else
        ht := nil;
    end;
  {$ENDIF}

  if Assigned(ht) then
   begin
     for cnt := 0 to FVariables.Count - 1  do
      begin
        new(data);
        try
          if zend_hash_find(ht, PAnsiChar(FVariables[cnt].Name),
          strlen(PAnsiChar(FVariables[cnt].Name)) + 1, data) = SUCCESS then
          begin
            if (data^^^._type = IS_STRING) then
             begin
               efree(data^^^.value.str.val);
               ZVAL_STRING(data^^, PAnsiChar(FVariables[cnt].Value), true);
             end
               else
                 begin
                   ZVAL_STRING(data^^, PAnsiChar(FVariables[cnt].Value), true);
                 end;
          end;
        finally
          freemem(data);
        end;
      end;
   end;
end;

procedure TpsvCustomPHP.CloseVirtualFile;
begin
  {$IFDEF PHP4}
  if FWriterHandle <> 0 then
   begin
     WaitForSingleObject(FWriterHandle, INFINITE);
     CloseHandle(FWriterHandle);
     FWriterHandle := 0;
   end;
  {$ELSE}
  FVirtualStream.Clear;
  {$ENDIF}
end;

function TpsvCustomPHP.CreateVirtualFile(ACode : {$IFDEF PHP_UNICE}UTF8String{$ELSE}AnsiString{$ENDIF}): boolean;
{$IFDEF PHP4}
var
 _handles : array[0..1] of THandle;
{$ENDIF}
begin

  Result := false;
  {$IFDEF PHP4}
  if ACode = '' then
   begin
     FVirtualReadHandle := 0;
     FVirtualWriteHandle := 0;
     Exit; {empty buffer was provided}
   end;

  FVirtualCode := ACode;

  if pipe(@_handles, 4096, 0) = -1 then
   begin
     FVirtualReadHandle := 0;
     FVirtualWriteHandle := 0;
     FVirtualCode := '';
     Exit;
   end;

  FVirtualReadHandle := _handles[0];
  FVirtualWriteHandle := _handles[1];
  Result := true;
  {$ELSE}
  if ACode = '' then
   Exit;
  try
    FVirtualStream.Clear;
    FVirtualStream.Write(ACode[1], Length(ACode));
    FVirtualStream.Position := 0;
    Result := true;
  except
    Result := false;
  end;
  {$ENDIF}
end;


function TpsvCustomPHP.GetEngine: IPHPEngine;
begin
  Result := PHPEngine;
end;

{ TPHPEngine }


constructor TPHPEngine.Create(AOwner: TComponent);
begin
  inherited;
  if Assigned(PHPEngine) then
   raise Exception.Create('Only one instance of PHP engine per application');
  FEngineActive := false;
  FHandleErrors := true;
  {$IFNDEF PHP540}
  FSafeMode := false;
  FSafeModeGid := false;
  {$ENDIF}
  FRegisterGlobals := true;
  FHTMLErrors := false;
  FMaxInputTime := 0;
  FWaitForShutdown := false;
  FConstants := TPHPConstants.Create(Self);
  FRequestCount := 0;
  FHash := TStringList.Create;
  FHash.Duplicates := dupError;
  FHash.Sorted := true;
  InitializeCriticalSection(FLock);
  PHPEngine := Self;

  MyFuncs := TStringList.Create;
end;

destructor TPHPEngine.Destroy;
begin
  ShutdownAndWaitFor;
  FEngineActive := false;
  FConstants.Free;
  FHash.Free;
  MyFuncs.Free;
  DeleteCriticalSection(FLock);
  if (PHPEngine = Self) then
   PHPEngine := nil;
  inherited;
  if PHPLoaded then
     UnloadPHP;
end;

function TPHPEngine.GetConstantCount: integer;
begin
  Result := FConstants.Count;
end;

procedure TPHPEngine.HandleRequest(ht: integer; return_value: pzval;
  return_value_ptr: ppzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer);

var
  Params : pzval_array;
  AFunction : TPHPFunction;
  j  : integer;
  FActiveFunctionName : string;
  FunctionIndex : integer;
  FZendVar : TZendVariable;
  FParameters : TFunctionParams;
  ReturnValue : variant;
begin
 FParameters := TFunctionParams.Create(nil, TFunctionParam);
 try

  if ht > 0 then
   begin
     if ( not (zend_get_parameters_ex(ht, Params) = SUCCESS )) then
      begin
        zend_wrong_param_count(TSRMLS_DC);
        Exit;
      end;
    end;

  FActiveFunctionName := get_active_function_name(TSRMLS_DC);
  if FHash.Find(FActiveFunctionName, FunctionIndex) then
    AFunction := TPHPFunction(FHash.Objects[FunctionIndex])
     else
       AFunction := nil;

   if Assigned(AFunction) then
    begin
      if AFunction.Collection = nil then
       Exit; {library was destroyed}

      if Assigned(AFunction.OnExecute) then
        begin
           if AFunction.Parameters.Count <> ht then
             begin
               zend_wrong_param_count(TSRMLS_DC);
               Exit;
             end;

           FParameters.Assign(AFunction.Parameters);
           if ht > 0 then
             begin
               for j := 0 to ht - 1 do
                 begin
                   if not IsParamTypeCorrect(FParameters[j].ParamType, Params[j]^) then
                     begin
                       zend_error(E_WARNING, PAnsiChar(AnsiFormat('Wrong parameter type for %s()', [FActiveFunctionName])));
                       Exit;
                     end;
                   FParameters[j].ZendValue := (Params[j]^);
                 end;
             end; { if ht > 0}

          FZendVar := TZendVariable.Create;
          try
           FZendVar.AsZendVariable := return_value;
           AFunction.OnExecute(Self, FParameters, ReturnValue, FZendVar, TSRMLS_DC);
           if FZendVar.ISNull then   {perform variant conversion}
             variant2zval(ReturnValue, return_value);
          finally
            FZendVar.Free;
          end;
      end; {if assigned AFunction.OnExecute}
    end;

  finally
    FParameters.Free;
    dispose_pzval_array(Params);
  end;
end;

procedure TPHPEngine.PrepareIniEntry;
var
  p   : integer;
  TimeStr : string;
begin
  if not PHPLoaded then
   Exit;

   if FHandleErrors then
   begin
    // p := integer(GetProcAddress(PHPLib, 'zend_do_print'));
     p := integer(GetProcAddress(PHPLib, 'zend_error_cb'));
     asm
       mov edx, dword ptr [p]
       mov dword ptr [edx], offset delphi_error_cb
     end;
   end;
    {$IFNDEF PHP540}
  if FSafeMode then
   zend_alter_ini_entry('safe_mode', 10, '1', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP)
    else
    {$ENDIF}
      zend_alter_ini_entry('safe_mode', 10, '0', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP);
     {$IFNDEF PHP540}
  if FSafeModeGID then
   zend_alter_ini_entry('safe_mode_gid', 14, '1', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP)
    else
    {$ENDIF}
      zend_alter_ini_entry('safe_mode_gid', 14, '0', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP);

  zend_alter_ini_entry('register_argc_argv', 19, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  if FRegisterGlobals then
    zend_alter_ini_entry('register_globals',   17, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE)
      else
        zend_alter_ini_entry('register_globals',   17, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  if FHTMLErrors then
   zend_alter_ini_entry('html_errors',        12, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE)
     else
       zend_alter_ini_entry('html_errors',        12, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  zend_alter_ini_entry('implicit_flush',     15, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  TimeStr := IntToStr(FMaxInputTime);
  zend_alter_ini_entry('max_input_time', 15, PAnsiChar(TimeStr), Length(TimeStr), ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);
end;

procedure TPHPEngine.PrepareEngine;
begin
  delphi_sapi_module.name := 'embed';  {to solve a problem with dl()}
  delphi_sapi_module.pretty_name := 'PHP for Delphi';
  delphi_sapi_module.startup := php_delphi_startup;
  delphi_sapi_module.shutdown := nil; //php_module_shutdown_wrapper;
  delphi_sapi_module.activate:= nil;
  delphi_sapi_module.deactivate := @php_delphi_deactivate;
  delphi_sapi_module.ub_write := @php_delphi_ub_write;
  delphi_sapi_module.flush := @php_delphi_flush;
  delphi_sapi_module.stat:= nil;
  delphi_sapi_module.getenv:= nil;
  delphi_sapi_module.sapi_error := @zend_error;
  delphi_sapi_module.header_handler := @php_delphi_header_handler;
  delphi_sapi_module.send_headers := nil;
  delphi_sapi_module.send_header := @php_delphi_send_header;
  delphi_sapi_module.read_post := @php_delphi_read_post;
  delphi_sapi_module.read_cookies := @php_delphi_read_cookies;
  delphi_sapi_module.register_server_variables := @php_delphi_register_variables;
  delphi_sapi_module.log_message := @php_delphi_log_message;
  if FIniPath <> '' then
     delphi_sapi_module.php_ini_path_override := PAnsiChar(FIniPath)
  else
     delphi_sapi_module.php_ini_path_override :=  nil;
  delphi_sapi_module.block_interruptions := nil;
  delphi_sapi_module.unblock_interruptions := nil;
  delphi_sapi_module.default_post_reader := nil;
  delphi_sapi_module.treat_data := nil;
  delphi_sapi_module.executable_location := nil;
  delphi_sapi_module.php_ini_ignore := 0;

  FLibraryModule.size := sizeOf(Tzend_module_entry);
  FLibraryModule.zend_api := ZEND_MODULE_API_NO;
  {$IFDEF PHP_DEBUG}
  FLibraryModule.zend_debug := 1;
  {$ELSE}
  FLibraryModule.zend_debug := 0;
  {$ENDIF}
  FLibraryModule.zts := USING_ZTS;
  FLibraryModule.name :=  'php4delphi_internal';
  FLibraryModule.functions := nil;
  FLibraryModule.module_startup_func := @minit;
  FLibraryModule.module_shutdown_func := @mshutdown;
  FLibraryModule.info_func := @php_info_library;
  FLibraryModule.version := '8.0 ds';

  FLibraryModule.request_shutdown_func := @rshutdown;
  FLibraryModule.request_startup_func := @rinit;

  FLibraryModule.module_started := 0;
  FLibraryModule._type := MODULE_PERSISTENT;
  FLibraryModule.handle := nil;
  FLibraryModule.module_number := 0;
  FLibraryModule.build_id := DupStr(PAnsiChar(ZEND_MODULE_BUILD_ID));
end;

procedure TPHPEngine.RegisterConstants;
var
 cnt : integer;
 ConstantName : AnsiString;
 ConstantValue : AnsiString;
begin
  for cnt := 0 to FConstants.Count - 1 do
  begin
    ConstantName  := FConstants[cnt].Name;
    ConstantValue := FConstants[cnt].Value;
    zend_register_string_constant(PAnsiChar(ConstantName),
      strlen(PAnsiChar(ConstantName)) + 1,
      PAnsiChar(ConstantValue), CONST_PERSISTENT or CONST_CS, 0, TSRMLS_D);
  end;

  RegisterInternalConstants(TSRMLS_D);
end;

procedure TPHPEngine.RegisterInternalConstants(TSRMLS_DC: pointer);
{$IFDEF REGISTER_COLORS}
var
 i : integer;
 ColorName : AnsiString;
{$ENDIF}
begin
 {$IFDEF REGISTER_COLORS}
  for I := Low(Colors) to High(Colors) do
  begin
   ColorName := AnsiString(Colors[i].Name);
   zend_register_long_constant( PAnsiChar(ColorName), strlen(PAnsiChar(ColorName)) + 1, Colors[i].Value,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
  end;
 {$ENDIF}
end;


procedure TPHPEngine.SetConstants(Value: TPHPConstants);
begin
  FConstants.Assign(Value);
end;

procedure TPHPEngine.ShutdownEngine;
begin

  if PHPEngine <> Self then
   raise EDelphiErrorEx.Create('Only active engine can be stopped');


  if not FEngineActive then
   Exit;

  try

   if @delphi_sapi_module.shutdown <> nil then
    delphi_sapi_module.shutdown(@delphi_sapi_module);
    sapi_shutdown;
     {Shutdown PHP thread safe resource manager}
     if Assigned(FOnEngineShutdown) then
       FOnEngineShutdown(Self);

    try
    tsrm_shutdown();
    except

    end;
    FHash.Clear;
   finally
     FEngineActive := false;
     FWaitForShutdown := False;
   end;
end;

procedure TPHPEngine.RegisterLibrary(ALib : TCustomPHPLibrary);
var
 cnt : integer;
 skip : boolean;
 FN : AnsiString;
begin
  skip := false;
  ALib.Refresh;

  {No functions defined, skip this library}
  if ALib.Functions.Count = 0 then
   Exit;

  for cnt := 0 to ALib.Functions.Count - 1 do
   begin
      FN := AnsiLowerCase(ALib.Functions[cnt].FunctionName);
      if FHash.IndexOf(FN) > -1 then
      begin
        skip := true;
        break;
      end;
   end;

  if not skip then
   begin
      for cnt := 0 to ALib.Functions.Count - 1 do
       begin
         FN := AnsiLowercase(ALib.Functions[cnt].FunctionName);
         FHash.AddObject(FN, ALib.Functions[cnt]);
       end;
      ALib.Locked := true;
   end;
end;

procedure TPHPEngine.RefreshLibrary;
var
 cnt, offset : integer;
 HashName : AnsiString;
begin
  SetLength(FLibraryEntryTable, FHash.Count + MyFuncs.Count + 2);

  PHP_FUNCTION(FLibraryEntryTable[0], 'InputBox', @delphi_input_box);


    for cnt := 0 to FHash.Count - 1 do
    begin
      HashName := FHash[cnt];

      {$IFNDEF COMPILER_VC9}
      FLibraryEntryTable[cnt+1].fname := strdup(PAnsiChar(HashName));
      {$ELSE}
      FLibraryEntryTable[cnt+1].fname := DupStr(PAnsiChar(HashName));
      {$ENDIF}

      FLibraryEntryTable[cnt+1].handler := @DispatchRequest;
      {$IFDEF PHP4}
      FLibraryEntryTable[cnt+1].func_arg_types := nil;
      {$ENDIF}
    end;

    offset := FHash.Count + 1;
    for cnt := 0 to MyFuncs.Count - 1 do
    begin
        HashName := MyFuncs[cnt];
        {$IFNDEF COMPILER_VC9}
        FLibraryEntryTable[cnt+offset].fname := strdup(PAnsiChar(HashName));
        {$ELSE}
        FLibraryEntryTable[cnt+offset].fname := DupStr(PAnsiChar(HashName));
        {$ENDIF}

         FLibraryEntryTable[cnt+offset].handler := MyFuncs.Objects[ cnt ];
        {$IFDEF PHP4}
         FLibraryEntryTable[cnt+offset].func_arg_types := nil;
        {$ENDIF}
    end;


    FLibraryEntryTable[FHash.Count+MyFuncs.Count+1].fname := nil;
    FLibraryEntryTable[FHash.Count+MyFuncs.Count+1].handler := nil;
    {$IFDEF PHP4}
    FLibraryEntryTable[FHash.Count+MyFuncs.Count+1].func_arg_types := nil;
    {$ENDIF}

    FLibraryModule.functions := @FLibraryEntryTable[0];
end;

procedure TPHPEngine.StartupEngine;
var
 i : integer;
begin
  if PHPEngine <> Self then
   begin
     raise EDelphiErrorEx.Create('Only one PHP engine can be activated');
   end;

   if FEngineActive then
       raise EDelphiErrorEx.Create('PHP engine already active');

     StartupPHP;
     PrepareEngine;
//     ini := GetExecutorGlobals.ini_directives;



     if not PHPLoaded then //Peter Enz
       begin
         raise EDelphiErrorEx.Create('PHP engine is not loaded');
       end;

     try
      FHash.Clear;

      for i := 0 to Librarian.Count -1 do
      begin
         RegisterLibrary(Librarian.GetLibrary(I));
      end;


      //Start PHP thread safe resource manager
      tsrm_startup(128, 1, 0 , nil);

      sapi_startup(@delphi_sapi_module);

      RefreshLibrary;


      php_module_startup(@delphi_sapi_module, @FLibraryModule, 1);


      TSRMLS_D := ts_resource_ex(0, nil);

      PrepareIniEntry;
      RegisterConstants;

      if Assigned(FOnEngineStartup) then
       FOnEngineStartup(Self);

      FEngineActive := true;
      except
       FEngineActive := false;
      end;
end;

procedure TPHPEngine.StartupPHP;
var
 DLLName : string;
begin
   if not PHPLoaded then
    begin
      if FDLLFolder <> '' then
         DLLName := IncludeTrailingBackSlash(FDLLFolder) + PHPWin
           else
             DLLName := PHPWin;
      LoadPHP(DLLName);
      if FReportDLLError then
       begin
         if PHPLib = 0 then raise Exception.CreateFmt('%s not found', [DllName]);
       end;
    end;
end;

procedure TPHPEngine.LockEngine;
begin
  EnterCriticalSection(FLock);
end;

procedure TPHPEngine.UnlockEngine;
begin
  LeaveCriticalSection(FLock);
end;

procedure TPHPEngine.HandleError(Sender: TObject; AText: string;
  AType: Integer; AFileName: string; ALineNo: integer);
begin
  LockEngine;
  try
    if Assigned(FOnScriptError) then


       FOnScriptError(Sender, AText, AType, AFileName, ALineNo);
      //ShowMessage( AText + #10#13 +  AType.ToString + #10#13 + AFileName + #10#13 + ALineNo.ToString );
     // FOnScriptError(Sender, AText, AType, AFileName, ALineNo);
  finally
    UnlockEngine;
  end;
end;

procedure TPHPEngine.HandleLogMessage(Sender: TObject; AText: string);
begin
  LockEngine;
  try
    if Assigned(FOnLogMessage) then
     FOnLogMessage(Sender, AText);
  finally
    UnlockEngine;
  end;
end;

procedure TPHPEngine.PrepareForShutdown;
begin
  LockEngine;
  try
   FWaitForShutdown := true;
  finally
    UnlockEngine;
  end;
end;

procedure TPHPEngine.ShutdownAndWaitFor;
var
 cnt : integer;
 AllClear : boolean;
begin
  PrepareForShutdown;

  AllClear := false;
  while not AllClear do
   begin
      cnt := FRequestCount;
      if cnt <= 0 then
        AllClear := true
         else
           Sleep(250);
   end;
  ShutdownEngine;
end;

function TPHPEngine.GetEngineActive: boolean;
begin
  Result := FEngineActive;
end;

procedure TPHPEngine.UnlockLibraries;
var
 cnt : integer;
begin
  if Assigned(Librarian) then
   begin
     for cnt := 0 to Librarian.Count - 1 do
      Librarian.GetLibrary(cnt).Locked := false;
   end;
end;

procedure TPHPEngine.RemoveRequest;
begin
  InterlockedDecrement(FRequestCount);
end;

procedure TPHPEngine.AddFunction(FN: AnsiString; Func: Pointer);
begin
 if MyFuncs.IndexOf(FN) = -1 then
    MyFuncs.AddObject(FN, TObject(Func));
end;

procedure TPHPEngine.AddRequest;
begin
  InterlockedIncrement(FRequestCount);
end;

initialization
  InitLibrarian;

finalization
  UnInitLibrarian;

end.
