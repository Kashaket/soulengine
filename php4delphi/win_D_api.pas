unit Win_D_api;

interface
uses System.Types;
type
{ Translated from WINDEF.H }
  WCHAR = WideChar;
  {$EXTERNALSYM WCHAR}
  PWChar = MarshaledString;

  LPSTR = MarshaledAString;
  {$EXTERNALSYM LPSTR}
  PLPSTR = ^LPSTR;
  {$EXTERNALSYM PLPSTR}
  LPCSTR = MarshaledAString;
  {$EXTERNALSYM LPCSTR}
  LPCTSTR = {$IFDEF UNICODE}MarshaledString{$ELSE}MarshaledAString{$ENDIF};
  {$EXTERNALSYM LPCTSTR}
  LPTSTR = {$IFDEF UNICODE}MarshaledString{$ELSE}MarshaledAString{$ENDIF};
  {$EXTERNALSYM LPTSTR}
  PLPCTSTR = {$IFDEF UNICODE}PMarshaledString{$ELSE}PMarshaledAString{$ENDIF};
  {$EXTERNALSYM LPCTSTR}
  PLPTSTR = {$IFDEF UNICODE}PMarshaledString{$ELSE}PMarshaledAString{$ENDIF};
  {$EXTERNALSYM LPTSTR}
  LPWSTR = PWideChar;
  {$EXTERNALSYM LPWSTR}
  PLPWSTR = ^LPWSTR;
  LPCWSTR = PWideChar;
  {$EXTERNALSYM LPCWSTR}
  ULONG_PTR = NativeUInt;
  DWORD = System.Types.DWORD;
  {$EXTERNALSYM DWORD}
  BOOL = LongBool;
  {$EXTERNALSYM BOOL}
  PBOOL = ^BOOL;
  {$EXTERNALSYM PBOOL}
  PByte = System.Types.PByte;
  LPBYTE = PByte;
  {$EXTERNALSYM LPBYTE}
  PINT = ^Integer;
  {$EXTERNALSYM PINT}
  PSingle = ^Single;
  PWORD = ^Word;
  {$EXTERNALSYM PWORD}
  PDWORD = ^DWORD;
  {$EXTERNALSYM PDWORD 'unsigned*'}
  LPDWORD = PDWORD;
  {$EXTERNALSYM LPDWORD}
  LPVOID = Pointer;
  {$EXTERNALSYM LPVOID}
  LPCVOID = Pointer;
  {$EXTERNALSYM LPCVOID}
  ULONG32 = LongWord;
  {$EXTERNALSYM ULONG32}
  LONG = Longint;
  {$EXTERNALSYM LONG}
  PVOID = Pointer;
  {$EXTERNALSYM PVOID}
  PPVOID = ^PVOID;
  {$EXTERNALSYM PPVOID}
  LONG64 = Int64;
  {$EXTERNALSYM LONG64}
  ULONG64 = UInt64;
  {$EXTERNALSYM ULONG64}
  DWORD64 = UInt64;
  {$EXTERNALSYM DWORD64}
  PLONG64 = ^LONG64;
  {$EXTERNALSYM PLONG64}
  PULONG64 = ^ULONG64;
  {$EXTERNALSYM PULONG64}
  PDWORD64 = ^DWORD64;
  {$EXTERNALSYM PDWORD64}

  UCHAR = Byte;
  {$EXTERNALSYM UCHAR}
  PUCHAR = ^Byte;
  {$EXTERNALSYM PUCHAR}
  SHORT = Smallint;
  {$EXTERNALSYM SHORT}
  USHORT = Word;
  {$EXTERNALSYM USHORT}
  PSHORT = System.PSmallint;
  {$EXTERNALSYM PSHORT}
  PUSHORT = System.PWord;
  {$EXTERNALSYM PUSHORT}
  UINT = LongWord;
  {$EXTERNALSYM UINT}
  PUINT = ^UINT;
  {$EXTERNALSYM PUINT}
  ULONG = Cardinal;
  {$EXTERNALSYM ULONG}
  PULONG = ^ULONG;
  {$EXTERNALSYM PULONG}
  PLongint = System.PLongint;
  {$EXTERNALSYM PLongint}
  PInteger = System.PInteger;
  {$EXTERNALSYM PInteger}
  PLongWord = System.PLongWord;
  {$EXTERNALSYM PLongWord}
  PSmallInt = System.PSmallInt;
  {$EXTERNALSYM PSmallInt}
  PDouble = System.PDouble;
  {$EXTERNALSYM PDouble}
  PShortInt = System.PShortInt;
  {$EXTERNALSYM PShortInt}

  LCID = DWORD;
  {$EXTERNALSYM LCID}
  LANGID = Word;
  {$EXTERNALSYM LANGID}

  THandle = System.THandle;
  PHandle = ^THandle;
const
OFS_MAXPATHNAME = 128;
kernel32  = 'kernel32.dll';
{$IF Defined(NEXTGEN) and Declared(System.Embedded)}
  kernelbase = 'kernelbase.dll';
{$ELSE}
  kernelbase = 'kernel32.dll';
{$ENDIF}
type
  ATOM = Word;
  {$EXTERNALSYM ATOM}
  TAtom = Word;

  HGLOBAL = THandle;
  {$EXTERNALSYM HGLOBAL}
  HLOCAL = THandle;
  {$EXTERNALSYM HLOCAL}
  FARPROC = Pointer;
  {$EXTERNALSYM FARPROC}
  TFarProc = Pointer;
  PROC_22 = Pointer;
type
  POFStruct = ^TOFStruct;
  _OFSTRUCT = record
    cBytes: Byte;
    fFixedDisk: Byte;
    nErrCode: Word;
    Reserved1: Word;
    Reserved2: Word;
{$IF DECLARED(AnsiChar)}
    szPathName: array[0..OFS_MAXPATHNAME-1] of AnsiChar;
{$ELSE}
    szPathName: array[0..OFS_MAXPATHNAME-1] of Byte;
{$ENDIF}
  end;
  {$EXTERNALSYM _OFSTRUCT}
  TOFStruct = _OFSTRUCT;
  OFSTRUCT = _OFSTRUCT;
  {$EXTERNALSYM OFSTRUCT}

function InterlockedCompareExchange(var Destination: Integer; Exchange: Integer; Comparand: Integer): Integer stdcall;
{$EXTERNALSYM InterlockedCompareExchange}
function InterlockedCompareExchangePointer(var Destination: Pointer; Exchange: Pointer; Comparand: Pointer): Pointer; {$IFDEF WIN32} inline; {$ENDIF}
{$EXTERNALSYM InterlockedCompareExchangePointer}
function InterlockedExchange(var Target: Integer; Value: Integer): Integer; stdcall;
{$EXTERNALSYM InterlockedExchange}
function InterlockedExchangePointer(var Target: Pointer; Value: Pointer): Pointer; {$IFDEF WIN32} inline; {$ENDIF}
{$EXTERNALSYM InterlockedExchangePointer}
function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall; overload;
{$EXTERNALSYM GetProcAddress}
function GetProcAddress(hModule: HMODULE; lpProcName: LPCWSTR): FARPROC; stdcall; overload;
{$EXTERNALSYM GetProcAddress}
function LoadLibrary(lpLibFileName: LPCWSTR): HMODULE;{$IF Declared(System.Embedded)} inline; {$ELSE} stdcall; {$ENDIF}
{$EXTERNALSYM LoadLibrary}
function LoadLibraryA(lpLibFileName: LPCSTR): HMODULE;{$IF Declared(System.Embedded)} inline; {$ELSE} stdcall; {$ENDIF}
{$EXTERNALSYM LoadLibraryA}
function FreeLibrary(hLibModule: HMODULE): BOOL; stdcall;
{$EXTERNALSYM FreeLibrary}
procedure FreeLibraryAndExitThread(hLibModule: HMODULE; dwExitCode: DWORD); stdcall;
{$EXTERNALSYM FreeLibraryAndExitThread}
procedure ZeroMemory(Destination: Pointer; Length: NativeUInt); inline;
{$EXTERNALSYM ZeroMemory}
implementation
function InterlockedCompareExchange; external kernel32 name 'InterlockedCompareExchange';
procedure ZeroMemory(Destination: Pointer; Length: NativeUInt);
begin
  FillChar(Destination^, Length, 0);
end;
function InterlockedCompareExchangePointer(var Destination: Pointer; Exchange: Pointer; Comparand: Pointer): Pointer; inline;
begin
  Result := Pointer(IntPtr(InterlockedCompareExchange(Integer(IntPtr(Destination)), IntPtr(Exchange), IntPtr(Comparand))));
end;
function InterlockedExchange; external kernel32 name 'InterlockedExchange';
function InterlockedExchangePointer(var Target: Pointer; Value: Pointer): Pointer;
begin
  Result := Pointer(IntPtr(InterlockedExchange(Integer(IntPtr(Target)), IntPtr(Value))));
end;
function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; external kernel32 name 'GetProcAddress';
function GetProcAddress(hModule: HMODULE; lpProcName: LPCWSTR): FARPROC;
begin
  if ULONG_PTR(lpProcName) shr 16 = 0 then // IS_INTRESOURCE
    Result := GetProcAddress(hModule, LPCSTR(lpProcName))
  else
    Result := GetProcAddress(hModule, LPCSTR(TMarshal.AsAnsi(lpProcName)));
end;
function LoadLibrary; external kernelbase name 'LoadLibraryW';
function LoadLibraryA; external kernelbase name 'LoadLibraryA';
function FreeLibrary; external kernel32 name 'FreeLibrary';
procedure FreeLibraryAndExitThread; external kernel32 name 'FreeLibraryAndExitThread';
end.