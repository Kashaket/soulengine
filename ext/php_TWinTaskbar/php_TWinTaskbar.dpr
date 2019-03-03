library php_TWinTaskbar;

uses
  Windows,
  ZENDTypes,
  ZENDAPI;

const
  SItaskbarInterfaceException = 'ITaskbarList interface is not supported on this OS version';

  SID_ITaskbarList                            = '{56FDF342-FD6D-11D0-958A-006097C9A090}';
  SID_ITaskbarList2                           = '{602D4995-B13A-429B-A66E-1935E44F4317}';
  SID_ITaskbarList3                           = '{EA1AFB91-9E28-4B86-90E9-9E9F8A5EEFAF}';
  SID_ITaskbarList4                           = '{C43DC798-95D1-4BEA-9030-BB99E2983A1A}';

  IID_ITaskbarList: TGUID                            = SID_ITaskbarList;
  IID_ITaskbarList2: TGUID                           = SID_ITaskbarList2;
  IID_ITaskbarList3: TGUID                           = SID_ITaskbarList3;
  IID_ITaskbarList4: TGUID                           = SID_ITaskbarList4;

  CLSID_TaskbarList: TGUID  = '{56FDF344-FD6D-11d0-958A-006097C9A090}';


function CoCreateInstance(const clsid: TGUID; unkOuter: IUnknown;
  dwClsContext: Longint; const iid: TGUID; out pv): HResult; stdcall;  external 'ole32.dll' name 'CoCreateInstance';


 type

  TWordFiller = record
  {$IFDEF CPUX86}
    Filler: array[1..2] of Byte; // Pad word make it 4 Bytes (2+2)
  {$ENDIF}
  {$IFDEF CPUX64}
    Filler: array[1..6] of Byte; // Pad word to make it 8 Bytes (2+6)
  {$ENDIF}
  end;

  TDWordFiller = record
  {$IFDEF CPUX64}
    Filler: array[1..4] of Byte; // Pad DWORD to make it 8 bytes (4+4) [x64 only]
  {$ENDIF}
  end;

{ Generic window message record }

  PMessage = ^TMessage;
  TMessage = record
    Msg: Cardinal;
    case Integer of
      0: (
        WParam: WPARAM;
        LParam: LPARAM;
        Result: LRESULT);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        WParamFiller: TDWordFiller;
        LParamLo: Word;
        LParamHi: Word;
        LParamFiller: TDWordFiller;
        ResultLo: Word;
        ResultHi: Word;
        ResultFiller: TDWordFiller);
  end;


{ Object instance management }

type
  TWndMethod = procedure(var Message: TMessage) of object;

  PObjectInstance = ^TObjectInstance;
  TObjectInstance = packed record
    Code: Byte;
    Offset: Integer;
    case Integer of
      0: (Next: PObjectInstance);
      1: (FMethod: TMethod);
  end;

const
{$IF Defined(CPUX86)}
  CodeBytes = 2;
{$ELSEIF Defined(CPUX64)}
  CodeBytes = 8;
{$ENDIF CPU}
  InstanceCount = (4096 - SizeOf(Pointer) * 2 - CodeBytes) div SizeOf(TObjectInstance) - 1;

type
  PInstanceBlock = ^TInstanceBlock;
  TInstanceBlock = packed record
    Next: PInstanceBlock;
    Code: array[1..CodeBytes] of Byte;
    WndProcPtr: Pointer;
    Instances: array[0..InstanceCount] of TObjectInstance;
  end;

var
  InstBlockList: PInstanceBlock;
  InstFreeList: PObjectInstance;

{ Standard window procedure }
function StdWndProc(Window: HWND; Message: UINT; WParam: WPARAM; LParam: WPARAM): LRESULT; stdcall;
{$IF Defined(CPUX86)}
{ In    ECX = Address of method pointer }
{ Out   EAX = Result }
asm
        XOR     EAX,EAX
        PUSH    EAX
        PUSH    LParam
        PUSH    WParam
        PUSH    Message
        MOV     EDX,ESP
        MOV     EAX,[ECX].Longint[4]
        CALL    [ECX].Pointer
        ADD     ESP,12
        POP     EAX
end;
{$ELSEIF Defined(CPUX64)}
{ In    R11 = Address of method pointer }
{ Out   RAX = Result }
var
  Msg: TMessage;
asm
        .PARAMS 2
        MOV     Msg.Msg,Message
        MOV     Msg.WParam,WParam
        MOV     Msg.LParam,LParam
        MOV     Msg.Result,0
        LEA     RDX,Msg
        MOV     RCX,[R11].TMethod.Data
        CALL    [R11].TMethod.Code
        MOV     RAX,Msg.Result
end;
{$ENDIF CPUX64}

{ Allocate an object instance }

function CalcJmpOffset(Src, Dest: Pointer): Longint;
begin
  Result := IntPtr(Dest) - (IntPtr(Src) + 5);
end;

function MakeObjectInstance(const AMethod: TWndMethod): Pointer;
const
  BlockCode: array[1..CodeBytes] of Byte = (
{$IF Defined(CPUX86)}
    $59,                       { POP ECX }
    $E9);                      { JMP StdWndProc }
{$ELSEIF Defined(CPUX64)}
    $41,$5b,                   { POP R11 }
    $FF,$25,$00,$00,$00,$00);  { JMP [RIP+0] }
{$ENDIF}
  PageSize = 4096;
var
  Block: PInstanceBlock;
  Instance: PObjectInstance;
begin
  if InstFreeList = nil then
  begin
    Block := VirtualAlloc(nil, PageSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    Block^.Next := InstBlockList;
    Move(BlockCode, Block^.Code, SizeOf(BlockCode));
{$IF Defined(CPUX86)}
    Block^.WndProcPtr := Pointer(CalcJmpOffset(@Block^.Code[2], @StdWndProc));
{$ELSEIF Defined(CPUX64)}
    Block^.WndProcPtr := @StdWndProc;
{$ENDIF}
    Instance := @Block^.Instances;
    repeat
      Instance^.Code := $E8;  { CALL NEAR PTR Offset }
      Instance^.Offset := CalcJmpOffset(Instance, @Block^.Code);
      Instance^.Next := InstFreeList;
      InstFreeList := Instance;
      Inc(PByte(Instance), SizeOf(TObjectInstance));
    until IntPtr(Instance) - IntPtr(Block) >= SizeOf(TInstanceBlock);
    InstBlockList := Block;
  end;
  Result := InstFreeList;
  Instance := InstFreeList;
  InstFreeList := Instance^.Next;
  Instance^.FMethod := TMethod(AMethod);
end;

{ Free an object instance }

procedure FreeObjectInstance(ObjectInstance: Pointer);
begin
  if ObjectInstance <> nil then
  begin
    PObjectInstance(ObjectInstance)^.Next := InstFreeList;
    InstFreeList := ObjectInstance;
  end;
end;

type

{ interface ITaskbarList }
  ITaskbarList = interface(IUnknown)
    ['{56FDF342-FD6D-11D0-958A-006097C9A090}']
    function HrInit: HRESULT; stdcall;
    function AddTab(hwnd: HWND): HRESULT; stdcall;
    function DeleteTab(hwnd: HWND): HRESULT; stdcall;
    function ActivateTab(hwnd: HWND): HRESULT; stdcall;
    function SetActiveAlt(hwnd: HWND): HRESULT; stdcall;
  end;
  {$EXTERNALSYM ITaskbarList}

{ interface ITaskbarList2 }
  ITaskbarList2 = interface(ITaskbarList)
    [SID_ITaskbarList2]
    function MarkFullscreenWindow(hwnd: HWND; fFullscreen: BOOL): HRESULT; stdcall;
  end;
  {$EXTERNALSYM ITaskbarList2}

{ interface ITaskbarList3 }
type
  THUMBBUTTON = record
    dwMask: DWORD;
    iId: UINT;
    iBitmap: UINT;
    hIcon: HICON;
    szTip: packed array[0..259] of WCHAR;
    dwFlags: DWORD;
  end;
  PThumbButton = ^THUMBBUTTON;


type
  ITaskbarList3 = interface(ITaskbarList2)
    [SID_ITaskbarList3]
    function SetProgressValue(hwnd: HWND; ullCompleted: ULONGLONG;
      ullTotal: ULONGLONG): HRESULT; stdcall;
    function SetProgressState(hwnd: HWND; tbpFlags: Integer): HRESULT; stdcall;
    function RegisterTab(hwndTab: HWND; hwndMDI: HWND): HRESULT; stdcall;
    function UnregisterTab(hwndTab: HWND): HRESULT; stdcall;
    function SetTabOrder(hwndTab: HWND; hwndInsertBefore: HWND): HRESULT; stdcall;
    function SetTabActive(hwndTab: HWND; hwndMDI: HWND;
      tbatFlags: Integer): HRESULT; stdcall;
    function ThumbBarAddButtons(hwnd: HWND; cButtons: UINT;
      pButton: PThumbButton): HRESULT; stdcall;
    function ThumbBarUpdateButtons(hwnd: HWND; cButtons: UINT;
      pButton: PThumbButton): HRESULT; stdcall;
    function ThumbBarSetImageList(hwnd: HWND; himl: THandle): HRESULT; stdcall;
    function SetOverlayIcon(hwnd: HWND; hIcon: HICON;
      pszDescription: LPCWSTR): HRESULT; stdcall;
    function SetThumbnailTooltip(hwnd: HWND; pszTip: LPCWSTR): HRESULT; stdcall;
    function SetThumbnailClip(hwnd: HWND; prcClip: PRect): HRESULT; stdcall;
  end;
  {$EXTERNALSYM ITaskbarList3}

{ interface ITaskbarList4 }


{ interface ITaskbarList4 }

type
  ITaskbarList4 = interface(ITaskbarList3)
    [SID_ITaskbarList4]
    function SetTabProperties(hwndTab: HWND; stpFlags: Integer): HRESULT; stdcall;
  end;
  {$EXTERNALSYM ITaskbarList4}

type

  TWinTaskbar = class
  private
    FLastError: Pchar;
    FMainWindow: HWND;
    tsrm :pointer;
    CallBackName: AnsiString;
    this:pzval;
    function ReadMainWindow: HWND;
  protected
    function HrInit: Boolean;
  public
    initialize:Boolean;
    ObjectInstance:Pointer;
    ClientProc:Pointer;

    TaskbarList: ITaskbarList;
    TaskbarList2: ITaskbarList2;
    TaskbarList3: ITaskbarList3;
    TaskbarList4: ITaskBarList4;

    function CheckITB:Boolean;
    function CheckITB2:Boolean;
    function CheckITB3:Boolean;
    function CheckITB4:Boolean;

    procedure NewWndProc(var Message: TMessage);
    //function NewWndProc(Handle: hWnd; Msg, wParam, lParam: Longint): Longint; stdcall;
    //function NewWndProc2:Pointer;   overload;

    constructor Create;



    // ITaskbarList
    function ActivateTab(AHwnd: HWND): Boolean;
    function AddTab(AHwnd: HWND): Boolean;
    function DeleteTab(AHwnd: HWND): Boolean;
    function SetActiveAlt(AHwnd: HWND): Boolean;

    //ITaskBarList2
    function MarkFullscreenWindow(AHwnd: HWND; AFullscreen: BOOL): Boolean;

    //ITaskBarList3
    function RegisterTab(ATabHandle: HWND): boolean;
    function SetOverlayIcon(AIcon: HICON; ADescription: String): Boolean;
    function SetProgressState(AState: Integer): Boolean; overload;
    function SetProgressValue(ACompleted, ATotal: UInt64): Boolean; overload;
    function SetProgressState(AHwndTab: HWND; AState: Integer): Boolean; overload;
    function SetProgressValue(AHwndTab: HWND; ACompleted, ATotal: UInt64): Boolean; overload;
    function SetTabActive(AHwndTab: HWND): Boolean;
    function SetTabOrder(AHwndTab: HWND; AHwndInsertBefore: HWND = 0): Boolean;
    function SetThumbnailClip(AClipRect: TRect): Boolean; overload;
    function SetThumbnailClip(AWindow:HWND; AClipRect: TRect): Boolean; overload;
    function ClearThumbnailClip: Boolean; overload;
    function ClearThumbnailClip(AWindow:HWND): Boolean; overload;
    function SetThumbnailTooltip(ATip: string): Boolean; overload;
    function SetThumbnailTooltip(AWindow:HWND; ATip: string): Boolean; overload;
    function ClearThumbnailTooltip: Boolean;
    function ThumbBarAddButtons(AButtonList: array of THUMBBUTTON; ATabHandle: HWND = 0): Boolean;
    function ThumbBarSetImageList(AHwnd: HWND; AImageList: THandle): Boolean;
    function ThumbBarUpdateButtons(AButtonList: array of THUMBBUTTON; ATabHandle: HWND = 0): Boolean;
    function UnregisterTab(AHwndTab: HWND): Boolean;

    //ITaskBarList4
    function SetTabProperties(AHwndTab: HWND; AStpFlags: Integer): boolean;

    property LastError: Pchar read FLastError;
    property MainWindow: HWND read ReadMainWindow write FMainWindow;
  end;



procedure TWinTaskbar.NewWndProc(var Message: TMessage);
var
  Args: pzval_array_ex;
  Return, Func: pzval;
begin
  if Message.Msg  = $0111 then
  begin
    MAKE_STD_ZVAL(Func);
    MAKE_STD_ZVAL(Return);
    ZvalVAL(Func, CallBackName);
    SetLength(Args, 2);

    Args[0] := this;

    MAKE_STD_ZVAL(Args[1]);
    ZvalVAL(Args[1], INTEGER(LOWORD(Message.WParam)));


    call_user_function(GetExecutorGlobals.function_table, nil, Func, Return, Length(Args), Args, tsrm);
    _zval_dtor(Args[1], nil, 0);
    _zval_dtor(Func, nil, 0);
    _zval_dtor(Return, nil, 0);
  end;
  Message.Result := DefWindowProc(self.MainWindow, Message.Msg, Message.WParam, Message.LParam);

 // CallWindowProc(self.ClientProc, self.MainWindow, Message.Msg, Message.WParam, Message.LParam);
end;


function HRESULTStr(h: HRESULT; S:ShortInt; out R:Boolean): Pchar;
begin
  if S = -1 then
    R := Succeeded(h)
  else
    R := h = S;

  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
    nil, h, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), @Result, 0, nil);
end;

function TWinTaskbar.ActivateTab(AHwnd: HWND): Boolean;
begin
  CheckITB;
  FLastError := HRESULTStr(TaskbarList.ActivateTab(aHwnd), -1, Result);
end;

function TWinTaskbar.AddTab(AHwnd: HWND): Boolean;
begin
  CheckITB;
  FLastError := HRESULTStr(TaskbarList.AddTab(aHwnd), -1, Result);
end;

function TWinTaskbar.CheckITB;
begin
  Result := true;
  if TaskbarList = nil then
  begin
    FLastError := SItaskbarInterfaceException;
    Result := false;
  end;
end;

function TWinTaskbar.CheckITB2;
begin
  Result := true;
  if TaskbarList2 = nil then
  begin
    FLastError := SItaskbarInterfaceException;
    Result := false;
  end;
end;

function TWinTaskbar.CheckITB3;
begin
  Result := true;
  if TaskbarList3 = nil then
  begin
    FLastError := SItaskbarInterfaceException;
    Result := false;
  end;
end;

function TWinTaskbar.CheckITB4;
begin
  Result := true;
  if TaskbarList4 = nil then
  begin
    FLastError := SItaskbarInterfaceException;
    Result := false;
  end;
end;

function TWinTaskbar.ClearThumbnailClip: Boolean;
begin
  Result := ClearThumbnailClip(MainWindow);
end;

function TWinTaskbar.ClearThumbnailClip(AWindow: HWND): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetThumbnailClip(AWindow, nil), -1, Result);
end;

function TWinTaskbar.ClearThumbnailTooltip: Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetThumbnailTooltip(MainWindow, nil), -1, Result);
end;

function Supports(const Instance: IInterface; const IID: TGUID; out Intf): Boolean;
begin
  Result := (Instance <> nil) and (Instance.QueryInterface(IID, Intf) = 0);
end;

constructor TWinTaskbar.Create;
var
  c:IUnknown;
begin
  self.ObjectInstance := nil;
  self.initialize := false;
  self.ClientProc := nil;
  if not Succeeded(CoCreateInstance(CLSID_TaskbarList, nil, $0001 or $0004, IUnknown, c)) then
  begin
    FLastError :=  Pchar('Could not initialize taskbar.');
  end else
  begin
    TaskbarList := c as ITaskbarList;
    Supports(TaskbarList, IID_ITaskbarList2, TaskbarList2);
    Supports(TaskbarList, IID_ITaskbarList3, TaskbarList3);
    Supports(TaskbarList, IID_ITaskbarList3, TaskbarList4);
    if not HrInit then
      FLastError :=  Pchar('Could not initialize taskbar. Error: ' + LastError)
    else
      self.initialize := true;
  end;
end;

function TWinTaskbar.DeleteTab(AHwnd: HWND): Boolean;
begin
  CheckITB;
  FLastError := HRESULTStr(TaskbarList.DeleteTab(AHwnd), S_OK, Result);
end;

function TWinTaskbar.HrInit: Boolean;
begin
  CheckITB;
  FLastError := HRESULTStr(TaskbarList.HrInit, -1, Result);
end;

function TWinTaskbar.MarkFullscreenWindow(AHwnd: HWND; AFullscreen: BOOL): Boolean;
begin
  CheckITB2;
  FLastError := HRESULTStr(TaskbarList2.MarkFullscreenWindow(AHwnd, AFullscreen), -1, Result);
end;

function TWinTaskbar.ReadMainWindow: HWND;
begin
  if FMainWindow = 0 then
  begin
    FMainWindow := GetActiveWindow;
    if GetWindow(FMainWindow, GW_OWNER) <> 0 then
      FMainWindow := GetWindow(FMainWindow, GW_OWNER);
  end;
  Result := FMainWindow;
end;

function TWinTaskbar.RegisterTab(ATabHandle: HWND): boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.RegisterTab(ATabHandle, MainWindow), -1, Result);
end;

function TWinTaskbar.SetActiveAlt(AHwnd: HWND): Boolean;
begin
  CheckITB;
  FLastError := HRESULTStr(TaskbarList.SetActiveAlt(AHwnd), -1, Result);
end;

function TWinTaskbar.SetOverlayIcon(AIcon: HICON; ADescription: String): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetOverlayIcon(MainWindow, AIcon, PWideChar(ADescription)), -1, Result);
end;

function TWinTaskbar.SetProgressState(AState: Integer): Boolean;
begin
  Result := SetProgressState(MainWindow, AState);
end;

function TWinTaskbar.SetProgressValue(ACompleted, ATotal: UInt64): Boolean;
begin
  Result := SetProgressValue(MainWindow, ACompleted, ATotal);
end;

function TWinTaskbar.SetProgressState(AHwndTab: HWND; AState: Integer): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetProgressState(MainWindow, AState), -1, Result);
end;

function TWinTaskbar.SetProgressValue(AHwndTab: HWND; ACompleted, ATotal: UInt64): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetProgressValue(MainWindow, ACompleted, ATotal), -1, Result);
end;

function TWinTaskbar.SetTabActive(AHwndTab: HWND): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetTabActive(AHwndTab, MainWindow, 0), -1, Result);
end;

function TWinTaskbar.SetTabOrder(AHwndTab, AHwndInsertBefore: HWND): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetTabOrder(AHwndTab, AHwndInsertBefore), -1, Result);
end;

function TWinTaskbar.SetTabProperties(AHwndTab: HWND;
  AStpFlags: Integer): boolean;
begin
  CheckITB4;
  FLastError := HRESULTStr(TaskbarList4.SetTabProperties(AHwndTab, AStpFlags), -1, Result);
end;

function TWinTaskbar.SetThumbnailClip(AClipRect: TRect): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetThumbnailClip(MainWindow, @AClipRect), -1, Result);
end;

function TWinTaskbar.SetThumbnailClip(AWindow:HWND; AClipRect: TRect): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetThumbnailClip(AWindow, @AClipRect), -1, Result);
end;

function TWinTaskbar.SetThumbnailTooltip(AWindow: HWND; ATip: string): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.SetThumbnailTooltip(AWindow, PWideChar(ATip)), -1, Result);
end;

function TWinTaskbar.SetThumbnailTooltip(ATip: string): Boolean;
begin
  Result := SetThumbnailTooltip(MainWindow, ATip);
end;

function TWinTaskbar.ThumbBarAddButtons(AButtonList: array of THUMBBUTTON; ATabHandle: HWND = 0): Boolean;
begin
  CheckITB3;
  if ATabHandle = 0 then
    ATabHandle := MainWindow;
  FLastError := HRESULTStr(TaskbarList3.ThumbBarAddButtons(ATabHandle, Length(AButtonList), @AButtonList), -1, Result);
end;

function TWinTaskbar.ThumbBarSetImageList(AHwnd: HWND; AImageList: THandle): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.ThumbBarSetImageList(AHwnd, AImageList), -1, Result);
end;

function TWinTaskbar.ThumbBarUpdateButtons(AButtonList: array of THUMBBUTTON; ATabHandle: HWND = 0): Boolean;
begin
  CheckITB3;
  if ATabHandle = 0 then
    FLastError := HRESULTStr(TaskbarList3.ThumbBarUpdateButtons(MainWindow, Length(AButtonList), @AButtonList), -1, Result)
  else
    FLastError := HRESULTStr(TaskbarList3.ThumbBarUpdateButtons(ATabHandle, Length(AButtonList), @AButtonList), -1, Result);
end;

function TWinTaskbar.UnregisterTab(AHwndTab: HWND): Boolean;
begin
  CheckITB3;
  FLastError := HRESULTStr(TaskbarList3.UnregisterTab(AHwndTab), -1, Result);
end;




procedure TWinTaskbarCreateCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
 OBJ:TWinTaskbar;
begin
  OBJ := TWinTaskbar.Create;
  OBJ.tsrm := ts_resource_ex(0, nil);
  ZvalVAL(return_value, integer(OBJ));
end;

procedure TBinitializeCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self:ppzval;
begin
  ZvalVAL(return_value, false);
  if ht = 1 then
  begin
    if (zend_get_params_ex(ht, @self) = SUCCESS) then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).initialize);
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


// ITaskbarList

procedure ActivateTabCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwnd:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwnd) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).ActivateTab(ZvalInt(AHwnd^^)) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure AddTabCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwnd:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwnd) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).AddTab(ZvalInt(AHwnd^^)) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure DeleteTabCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwnd:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwnd) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).DeleteTab(ZvalInt(AHwnd^^)) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetActiveAltCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwnd:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwnd) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetActiveAlt(ZvalInt(AHwnd^^)) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;




//ITaskBarList2




procedure MarkFullscreenWindowCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwnd, AFullscreen:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwnd, @AFullscreen) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB2 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).MarkFullscreenWindow(ZvalInt(AHwnd^^), ZvalBool(AFullscreen^^)));
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


//  ITaskBarList3


procedure RegisterTabCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwnd:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwnd) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).RegisterTab(ZvalInt(AHwnd^^)) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetOverlayIconCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AIcon, ADescription:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AIcon, @ADescription) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
      ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetOverlayIcon(HICON(ZvalInt(AIcon^^)), ZvalStr(ADescription^^)));
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


procedure SetProgressStateCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwndTab, State:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwndTab, @State) = SUCCESS) then
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetProgressState(HWND(ZvalInt(AHwndTab^^)), ZvalInt(State^^)) );
  end else if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @State) = SUCCESS) then
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetProgressState(ZvalInt(State^^)) );
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


procedure SetProgressValueCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwndTab, ACompleted, ATotal:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 4 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwndTab, @ACompleted, @ATotal) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetProgressValue(HWND(ZvalInt(AHwndTab^^)), UInt64(ZvalInt(ACompleted^^)), UInt64(ZvalInt(ATotal^^))));
    end;
  end else if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @ACompleted, @ATotal) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetProgressValue(UInt64(ZvalInt(ACompleted^^)), UInt64(ZvalInt(ATotal^^))));
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetTabActiveCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwndTab:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwndTab) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetTabActive(HWND(ZvalInt(AHwndTab^^))) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetTabOrderCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwndTab, AHwndInsertBefore:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwndTab, @AHwndInsertBefore) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetTabOrder(HWND(ZvalInt(AHwndTab^^)), HWND(ZvalInt(AHwndInsertBefore^^))) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetThumbnailClipCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  AWindow, self, AClipRect:ppzval;
  Left, Top, Right, Bottom:pzval;
  TR:TRect;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AWindow, @AClipRect) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
      begin
        if AClipRect^._type <> IS_ARRAY then
          exit;

        TR.Left   := 0;
        TR.Top    := 0;
        TR.Right  := 0;
        TR.Bottom := 0;

        if ZValArrayKeyExists(AClipRect^, 'left', Left) then
          TR.Left := ZvalInt(Left^);

        if ZValArrayKeyExists(AClipRect^, 'top', Left) then
          TR.Top := ZvalInt(Top^);

        if ZValArrayKeyExists(AClipRect^, 'right', Left) then
          TR.Right := ZvalInt(Right^);

        if ZValArrayKeyExists(AClipRect^, 'bottom', Left) then
          TR.Bottom := ZvalInt(Bottom^);


        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetThumbnailClip(HWND(ZvalInt(AWindow^^)), TR));
      end;
    end;
  end else if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AClipRect) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
      begin
        if AClipRect^._type <> IS_ARRAY then
          exit;

        TR.Left   := 0;
        TR.Top    := 0;
        TR.Right  := 0;
        TR.Bottom := 0;

        if ZValArrayKeyExists(AClipRect^, 'left', Left) then
          TR.Left := ZvalInt(Left^);

        if ZValArrayKeyExists(AClipRect^, 'top', Left) then
          TR.Top := ZvalInt(Top^);

        if ZValArrayKeyExists(AClipRect^, 'right', Left) then
          TR.Right := ZvalInt(Right^);

        if ZValArrayKeyExists(AClipRect^, 'bottom', Left) then
          TR.Bottom := ZvalInt(Bottom^);


        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetThumbnailClip(TR));
      end;

      end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure ClearThumbnailClipCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AWindow:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 1 then
  begin
    if (zend_get_params_ex(ht, @self) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
      ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).ClearThumbnailClip);
    end;
  end else if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AWindow) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).ClearThumbnailClip(HWND(ZvalInt(AWindow^^))));
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


procedure SetThumbnailTooltipCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AWindow, ATip:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AWindow, @ATip) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetThumbnailTooltip(HWND(ZvalInt(AWindow^^)), ZvalStr(ATip^^)));
    end;
  end else if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @ATip) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetThumbnailTooltip(ZvalStr(ATip^^)));
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure ClearThumbnailTooltipCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 1 then
  begin
    if (zend_get_params_ex(ht, @self) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).ClearThumbnailTooltip );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

function StrMove(Dest: PWideChar; const Source: PWideChar; Count: Cardinal): PWideChar;
begin
  Result := Dest;
  Move(Source^, Dest^, Count * SizeOf(WideChar));
end;

function WideStrAlloc(Size: Cardinal): PWideChar;
begin
  //BJK: Size should probably be char count, not bytes; but at least 'div 2' below prevents overrun.
  Size := Size * SizeOf(WideChar);
  Inc(Size, SizeOf(Cardinal));
  GetMem(Result, Size);
  Cardinal(Pointer(Result)^) := Size;
  Inc(Result, SizeOf(Cardinal) div 2);
end;


function StrNew(const Str: PWideChar): PWideChar;
var
  Size: Cardinal;
begin
  if Str = nil then Result := nil else
  begin
    Size := Length(Str) + 1;
    Result := StrMove(WideStrAlloc(Size), Str, Size);
  end;
end;


procedure ThumbBarAddButtonsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AButtonList, ATabHandle:ppzval;
  ABList: array of THUMBBUTTON;
  i,ir:Integer;
  pData: pzval;
  dwMask, iId, iBitmap,hIcon, szTip, dwFlags:pzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht,@self,  @AButtonList, @ATabHandle) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
      begin
        if AButtonList^._type <> IS_ARRAY then
          exit;

        if AButtonList^.value.ht.nNumOfElements = 0  then
          exit;

        for Ir := 0 to AButtonList^.value.ht.nNumOfElements - 1 do
        begin
          if ZValArrayKeyExists(AButtonList^, Ir, pData) then
            if pData._type = IS_ARRAY then
            BEGIN
              if High(ABList) = -1 then
                SetLength(ABList, 1)
              else
                SetLength(ABList, Length(ABList) + 1);
              i := High(ABList);
              if ZValArrayKeyExists(pData, 'dwmask', dwMask) then
                ABList[i].dwMask := DWORD(ZvalInt(dwMask^));
              if ZValArrayKeyExists(pData, 'iid', iId) then
                ABList[i].iId := UINT(ZvalInt(iId^));
              if ZValArrayKeyExists(pData, 'ibitmap', iBitmap) then
                ABList[i].iBitmap := UINT(ZvalInt(iBitmap^));
              if ZValArrayKeyExists(pData, 'icon', hIcon) then
                 ABList[i].hIcon :=  LoadImageA(GetModuleHandle(nil), PAnsiChar( ZvalStr(hIcon^)), 1, 0, 0, 64 or 16);
              if ZValArrayKeyExists(pData, 'dwflags', dwFlags) then
                ABList[i].dwFlags := DWORD(ZvalInt(dwFlags^));
              if ZValArrayKeyExists(pData, 'sztip', szTip) then
                lstrcpyw( ABList[i].szTip, StrNew (PChar( ZvalStrw(szTip^) )) );
            END;
        end;

        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).ThumbBarAddButtons(ABList, HWND(ZvalInt(ATabHandle^^) )) );
      end;
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


procedure ThumbBarSetImageListCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwnd, AImageList:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwnd, @AImageList) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).ThumbBarSetImageList( HWND(ZvalInt(AHwnd^^)), THandle(ZvalInt(AImageList^^)) ) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;



procedure ThumbBarUpdateButtonsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AButtonList, ATabHandle:ppzval;
  ABList: array of THUMBBUTTON;
  i,ir:Integer;
  pData: pzval;
  dwMask, iId, iBitmap,hIcon, szTip, dwFlags:pzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht,@self,  @AButtonList, @ATabHandle) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
      begin
        if AButtonList^._type <> IS_ARRAY then exit;
        if AButtonList^.value.ht.nNumOfElements = 0  then exit;
        for Ir := 0 to AButtonList^.value.ht.nNumOfElements - 1 do
        begin
          if ZValArrayKeyExists(AButtonList^, Ir, pData) then
            if pData._type = IS_ARRAY then
            BEGIN
              if High(ABList) = -1 then
                SetLength(ABList, 1)
              else
                SetLength(ABList, Length(ABList) + 1);
              i := High(ABList);
              if ZValArrayKeyExists(pData, 'dwmask', dwMask) then
                ABList[i].dwMask := DWORD(ZvalInt(dwMask^));
              if ZValArrayKeyExists(pData, 'iid', iId) then
                ABList[i].iId := UINT(ZvalInt(iId^));
              if ZValArrayKeyExists(pData, 'ibitmap', iBitmap) then
                ABList[i].iBitmap := UINT(ZvalInt(iBitmap^));
              if ZValArrayKeyExists(pData, 'icon', hIcon) then
                 ABList[i].hIcon :=  LoadImageA(GetModuleHandle(nil), PAnsiChar( ZvalStr(hIcon^)), 1, 0, 0, 64 or 16);
              if ZValArrayKeyExists(pData, 'dwflags', dwFlags) then
                ABList[i].dwFlags := DWORD(ZvalInt(dwFlags^));
              if ZValArrayKeyExists(pData, 'sztip', szTip) then
                lstrcpyw( ABList[i].szTip, StrNew (PChar( ZvalStrw(szTip^) )) );
            END;
        end;
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).ThumbBarUpdateButtons(ABList, HWND(ZvalInt(ATabHandle^^) )) );
      end;
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


procedure UnregisterTabCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwndTab:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwndTab) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB3 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).UnregisterTab(HWND(ZvalInt(AHwndTab^^))) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;



//ITaskBarList4

procedure SetTabPropertiesCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, AHwndTab, AStpFlags:ppzval;
  R:Boolean;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @AHwndTab, @AStpFlags) = SUCCESS) then begin
      if TWinTaskbar(ZvalInt(self^^)).CheckITB4 then
        ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).SetTabProperties(HWND(ZvalInt(AHwndTab^^)), ZvalInt(AStpFlags^^)) );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

procedure LastErrorCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self:ppzval;
  R:Boolean;
begin
  if ht = 1 then
  begin
    if (zend_get_params_ex(ht, @self) = SUCCESS) then begin
      ZvalVAL(return_value, TWinTaskbar(ZvalInt(self^^)).LastError );
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;



procedure MainWindowCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self, v:ppzval;
  R:Boolean;
begin
  if ht = 1 then
  begin
    if (zend_get_params_ex(ht, @self) = SUCCESS) then
      ZvalVAL(return_value, integer(TWinTaskbar(ZvalInt(self^^)).MainWindow) );
  end else if ht = 2 then
  begin
    if (zend_get_params_ex(ht, @self, @v) = SUCCESS) then
      TWinTaskbar(ZvalInt(self^^)).MainWindow := ZvalInt(v^^);
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;

var
  ff:Integer = 0;
procedure SetFormCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self,zCallBackName, this:ppzval;
  OBJ:TWinTaskbar;
begin
  ZvalVAL(return_value, false);
  if ht = 3 then
  begin
    if (zend_get_params_ex(ht, @self, @zCallBackName, @this) = SUCCESS) then
    begin
      OBJ := TWinTaskbar(ZvalInt(self^^));

      if not Assigned(OBJ.ClientProc) then
      begin
        OBJ.FLastError := 'Операция успешно завершена.!';
        OBJ.CallBackName := ZvalStr(zCallBackName^^);

        MAKE_STD_ZVAL(OBJ.this);
        OBJ.this._type := this^._type;
        OBJ.this.value.obj := this^.value.obj;
        OBJ.this.value.ht := this^.value.ht;
        OBJ.this.is_ref := this^.is_ref;
        OBJ.this.refcount := this^.refcount;

        OBJ.ObjectInstance := nil;
        OBJ.ClientProc := nil;

        OBJ.ObjectInstance := MakeObjectInstance(OBJ.NewWndProc);
        OBJ.ClientProc := pointer(SetWindowLong(OBJ.MainWindow, gwl_WndProc, Nativeint(OBJ.ObjectInstance)));
        ZvalVAL(return_value, true);
      end else
        OBJ.FLastError := '"OnWMCommand" - Уже зарегистрирован';
    end;
  end else
     OBJ.FLastError := 'Wrong parameter count for ()';
end;

procedure FreeObjectInstanceCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  self:ppzval;
  R:Boolean;
  OBJ:TWinTaskbar;
  Instance: Pointer;
begin
  if ht = 1 then
  begin
    if (zend_get_params_ex(ht, @self) = SUCCESS) then
    begin
      OBJ := TWinTaskbar(ZvalInt(self^^));
      if Assigned(OBJ.ClientProc) then
      begin
        FreeObjectInstance(OBJ.ObjectInstance);
        OBJ.ObjectInstance := nil;

        SetWindowLong(OBJ.MainWindow, gwl_WndProc, Nativeint(OBJ.ClientProc));
        OBJ.ClientProc := nil;
      end;
    end;
  end else
      zend_wrong_param_count(TSRMLS_DC);
end;


procedure TImageListCreateCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  ZvalVAL(return_value, integer(TWinTaskbar.Create) );
end;

var
  moduleEntry : _zend_module_entry;
  module_entry_table : array of _zend_function_entry;

procedure AddFuction(Name:PAnsiChar; CallBackFunc:Pointer);
var
  i:Integer;
begin
  if High(module_entry_table) = -1 then
    SetLength(module_entry_table, 1);

  SetLength(module_entry_table, Length(module_entry_table) + 1);
  i := High(module_entry_table) - 1;
  module_entry_table[i].fname := Name;
  module_entry_table[i].arg_info := nil;
  module_entry_table[i].handler := CallBackFunc;
end;



function get_module : p_zend_module_entry; cdecl;
begin
  ModuleEntry.size := sizeof(_zend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  moduleEntry.build_id := PAnsiChar(ZEND_MODULE_BUILD_ID);
  ModuleEntry.Name := 'TWinTaskbar';
  Result := @ModuleEntry;

  if not LoadZEND then exit;

  AddFuction('TWinTaskbarCreate', @TWinTaskbarCreateCallBack);

  // ITaskbarList
  AddFuction('TBActivateTab', @ActivateTabCallBack);
  AddFuction('TBAddTab', @AddTabCallBack);
  AddFuction('TBDeleteTab', @DeleteTabCallBack);
  AddFuction('TBSetActiveAlt', @SetActiveAltCallBack);

  //ITaskBarList2
  AddFuction('TBMarkFullscreenWindow', @MarkFullscreenWindowCallBack);


  //ITaskBarList3
  AddFuction('TBRegisterTab', @RegisterTabCallBack);
  AddFuction('TBSetOverlayIcon', @SetOverlayIconCallBack);
  AddFuction('TBSetProgressState', @SetProgressStateCallBack);
  AddFuction('TBSetProgressValue', @SetProgressValueCallBack);
  AddFuction('TBSetTabActive', @SetTabActiveCallBack);
  AddFuction('TBSetTabOrder', @SetTabOrderCallBack);
  AddFuction('TBSetThumbnailClip', @SetThumbnailClipCallBack);
  AddFuction('TBClearThumbnailClip', @ClearThumbnailClipCallBack);
  AddFuction('TBSetThumbnailTooltip', @SetThumbnailTooltipCallBack);
  AddFuction('TBClearThumbnailTooltip', @ClearThumbnailTooltipCallBack);
  AddFuction('TBThumbBarAddButtons', @ThumbBarAddButtonsCallBack);
  AddFuction('TBThumbBarSetImageList', @ThumbBarSetImageListCallBack);
  AddFuction('TBThumbBarUpdateButtons', @ThumbBarUpdateButtonsCallBack);


  AddFuction('TBUnregisterTab', @UnregisterTabCallBack);


  //ITaskBarList4
  AddFuction('TBSetTabProperties', @SetTabPropertiesCallBack);
  AddFuction('TBLastError', @LastErrorCallBack);
  AddFuction('TBMainWindow', @MainWindowCallBack);

  AddFuction('TBWMCommandApplication', @SetFormCallBack);
  AddFuction('TBUnregisterWMCommandApplication', @FreeObjectInstanceCallBack);



  AddFuction('TBInitialize', @TBinitializeCallBack);


  ModuleEntry.functions := @module_entry_table[0];

  Result := @ModuleEntry;
end;

exports get_module;

end.

