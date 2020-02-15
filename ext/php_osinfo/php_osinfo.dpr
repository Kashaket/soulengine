library php_osinfo;

{$I PHP.INC}
//{$smartlink on}

uses
  SysUtils,
  Classes,
  Math, NB30,
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  Variants,
  u2Registry,
  uPHPUtils, windows;

{$R *.res}
function GetAdapterInfo(Lana: AnsiChar): String;
var
  Adapter: TAdapterStatus;
  NCB: TNCB;
begin
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBRESET);
  NCB.ncb_lana_num := Lana;
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin 
    Result := 'mac not found'; 
    Exit; 
  end; 

  FillChar(NCB, SizeOf(NCB), 0); 
  NCB.ncb_command := Char(NCBASTAT);
  NCB.ncb_lana_num := Lana;
  NCB.ncb_callname := '*';

  FillChar(Adapter, SizeOf(Adapter), 0);
  NCB.ncb_buffer := @Adapter;
  NCB.ncb_length := SizeOf(Adapter);
  if Netbios(@NCB) <> Char(NRC_GOODRET) then
  begin 
    Result := 'mac not found'; 
    Exit; 
  end; 
  Result := 
    IntToHex(Byte(Adapter.adapter_address[0]), 2) + '-' + 
    IntToHex(Byte(Adapter.adapter_address[1]), 2) + '-' + 
    IntToHex(Byte(Adapter.adapter_address[2]), 2) + '-' + 
    IntToHex(Byte(Adapter.adapter_address[3]), 2) + '-' + 
    IntToHex(Byte(Adapter.adapter_address[4]), 2) + '-' + 
    IntToHex(Byte(Adapter.adapter_address[5]), 2); 
end; 

function GetMACAddress: string; 
var 
  AdapterList: TLanaEnum;
  NCB: TNCB; 
begin 
  FillChar(NCB, SizeOf(NCB), 0);
  NCB.ncb_command := Char(NCBENUM);
  NCB.ncb_buffer := @AdapterList;
  NCB.ncb_length := SizeOf(AdapterList);
  Netbios(@NCB);
  if Byte(AdapterList.length) > 0 then 
    Result := GetAdapterInfo(AdapterList.lana[0])
  else 
    Result := ''; 
end;

function GetDisplayDevice: string;
var
lpDisplayDevice: TDisplayDevice;
begin
lpDisplayDevice.cb := sizeof(lpDisplayDevice);
EnumDisplayDevices(nil, 0, lpDisplayDevice , 0);
Result:=lpDisplayDevice.DeviceString;
end;


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
  php_info_print_table_row(2, zend_pchar('php_OSINFO'), zend_pchar('enabled'));
  php_info_print_table_end();
end;


function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin

  regConstL('MEMORY_LOAD', 0, TSRMLS_DC);
  regConstL('MEMORY_TOTALPHYS', 1, TSRMLS_DC);
  regConstL('MEMORY_AVAILPHYS', 2, TSRMLS_DC);
  regConstL('MEMORY_TOTALPAGEFILE', 3, TSRMLS_DC);
  regConstL('MEMORY_AVAILPAGEFILE',4, TSRMLS_DC);
  regConstL('MEMORY_TOTALVIRTUAL', 5, TSRMLS_DC);
  regConstL('MEMORY_AVAILVIRTUAL', 6, TSRMLS_DC);

  regConstL('LOCALE_USE_CP_ACP',$40000000, TSRMLS_DC);

  regConstL('LOCALE_ILANGUAGE',$000001, TSRMLS_DC);
  regConstL('LOCALE_SLANGUAGE',$000002, TSRMLS_DC);
  regConstL('LOCALE_SENGLANGUAGE',$001001, TSRMLS_DC);
  regConstL('LOCALE_SABBREVLANGNAME',$000003, TSRMLS_DC);
  regConstL('LOCALE_SNATIVELANGNAME',$000004, TSRMLS_DC);

  regConstL('LOCALE_ICOUNTRY',$000005, TSRMLS_DC);
  regConstL('LOCALE_SCOUNTRY',$000006, TSRMLS_DC);
  regConstL('LOCALE_SENGCOUNTRY',$001002, TSRMLS_DC);
  regConstL('LOCALE_SABBREVCTRYNAME',$000007, TSRMLS_DC);
  regConstL('LOCALE_SNATIVECTRYNAME',$000008, TSRMLS_DC);

  regConstL('LOCALE_IDEFAULTLANGUAGE',$000009, TSRMLS_DC);
  regConstL('LOCALE_IDEFAULTCOUNTRY',$00000A, TSRMLS_DC);
  regConstL('LOCALE_IDEFAULTCODEPAGE',$00000B, TSRMLS_DC);
  regConstL('LOCALE_IDEFAULTANSICODEPAGE',$001004, TSRMLS_DC);
  regConstL('LOCALE_IDEFAULTMACCODEPAGE',$001011, TSRMLS_DC);

  regConstL('LOCALE_SLIST',$00000C, TSRMLS_DC);
  regConstL('LOCALE_IMEASURE',$00000D, TSRMLS_DC);

  regConstL('LOCALE_SDECIMAL',$00000E, TSRMLS_DC);
  regConstL('LOCALE_STHOUSAND',$00000F, TSRMLS_DC);
  regConstL('LOCALE_SGROUPING',$000010, TSRMLS_DC);
  regConstL('LOCALE_IDIGITS',$000011, TSRMLS_DC);
  regConstL('LOCALE_ILZERO',$000012, TSRMLS_DC);
  regConstL('LOCALE_INEGNUMBER',$001010, TSRMLS_DC);
  regConstL('LOCALE_SNATIVEDIGITS',$000013, TSRMLS_DC);

  regConstL('LOCALE_SCURRENCY',$000014, TSRMLS_DC);
  regConstL('LOCALE_SINTLSYMBOL',$000015, TSRMLS_DC);
  regConstL('LOCALE_SMONDECIMALSEP',$000016, TSRMLS_DC);
  regConstL('LOCALE_SMONTHOUSANDSEP',$000017, TSRMLS_DC);
  regConstL('LOCALE_SMONGROUPING',$000018, TSRMLS_DC);
  regConstL('LOCALE_ICURRDIGITS',$000019, TSRMLS_DC);
  regConstL('LOCALE_IINTLCURRDIGITS',$00001A, TSRMLS_DC);
  regConstL('LOCALE_ICURRENCY',$00001B, TSRMLS_DC);
  regConstL('LOCALE_INEGCURR',$00001C, TSRMLS_DC);

  regConstL('LOCALE_SDATE',$00001D, TSRMLS_DC);
  regConstL('LOCALE_STIME',$00001E, TSRMLS_DC);
  regConstL('LOCALE_SSHORTDATE',$00001F, TSRMLS_DC);
  regConstL('LOCALE_SLONGDATE',$000020, TSRMLS_DC);
  regConstL('LOCALE_STIMEFORMAT',$001003, TSRMLS_DC);
  regConstL('LOCALE_IDATE',$000021, TSRMLS_DC);
  regConstL('LOCALE_ILDATE',$000022, TSRMLS_DC);
  regConstL('LOCALE_ITIME',$000023, TSRMLS_DC);
  regConstL('LOCALE_ITIMEMARKPOSN',$001005, TSRMLS_DC);
  regConstL('LOCALE_ICENTURY',$000024, TSRMLS_DC);
  regConstL('LOCALE_ITLZERO',$000025, TSRMLS_DC);
  regConstL('LOCALE_IDAYLZERO',$000026, TSRMLS_DC);
  regConstL('LOCALE_IMONLZERO',$000027, TSRMLS_DC);
  regConstL('LOCALE_S1159',$000028, TSRMLS_DC);
  regConstL('LOCALE_S2359',$000029, TSRMLS_DC);

  regConstL('LOCALE_ICALENDARTYPE',$001009, TSRMLS_DC);
  regConstL('LOCALE_IOPTIONALCALENDAR',$00100B, TSRMLS_DC);
  regConstL('LOCALE_IFIRSTDAYOFWEEK',$00100C, TSRMLS_DC);
  regConstL('LOCALE_IFIRSTWEEKOFYEAR',$00100D, TSRMLS_DC);

  regConstL('LOCALE_SDAYNAME1',$00002A, TSRMLS_DC);
  regConstL('LOCALE_SDAYNAME2',$00002B, TSRMLS_DC);
  regConstL('LOCALE_SDAYNAME3',$00002C, TSRMLS_DC);
  regConstL('LOCALE_SDAYNAME4',$00002D, TSRMLS_DC);
  regConstL('LOCALE_SDAYNAME5',$00002E, TSRMLS_DC);
  regConstL('LOCALE_SDAYNAME6',$00002F, TSRMLS_DC);
  regConstL('LOCALE_SDAYNAME7',$000030, TSRMLS_DC);
  regConstL('LOCALE_SABBREVDAYNAME1',$000031, TSRMLS_DC);
  regConstL('LOCALE_SABBREVDAYNAME2',$000032, TSRMLS_DC);
  regConstL('LOCALE_SABBREVDAYNAME3',$000033, TSRMLS_DC);
  regConstL('LOCALE_SABBREVDAYNAME4',$000034, TSRMLS_DC);
  regConstL('LOCALE_SABBREVDAYNAME5',$000035, TSRMLS_DC);
  regConstL('LOCALE_SABBREVDAYNAME6',$000036, TSRMLS_DC);
  regConstL('LOCALE_SABBREVDAYNAME7',$000037, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME1',$000038, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME2',$000039, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME3',$00003A, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME4',$00003B, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME5',$00003C, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME6',$00003D, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME7',$00003E, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME8',$00003F, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME9',$000040, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME10',$000041, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME11',$000042, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME12',$000043, TSRMLS_DC);
  regConstL('LOCALE_SMONTHNAME13',$00100E, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME1',$000044, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME2',$000045, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME3',$000046, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME4',$000047, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME5',$000048, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME6',$000049, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME7',$00004A, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME8',$00004B, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME9',$00004C, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME10',$00004D, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME11',$00004E, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME12',$00004F, TSRMLS_DC);
  regConstL('LOCALE_SABBREVMONTHNAME13',$00100F, TSRMLS_DC);

  regConstL('LOCALE_SPOSITIVESIGN',$000050, TSRMLS_DC);
  regConstL('LOCALE_SNEGATIVESIGN',$000051, TSRMLS_DC);
  regConstL('LOCALE_IPOSSIGNPOSN',$000052, TSRMLS_DC);
  regConstL('LOCALE_INEGSIGNPOSN',$000053, TSRMLS_DC);
  regConstL('LOCALE_IPOSSYMPRECEDES',$000054, TSRMLS_DC);
  regConstL('LOCALE_IPOSSEPBYSPACE',$000055, TSRMLS_DC);
  regConstL('LOCALE_INEGSYMPRECEDES',$000056, TSRMLS_DC);
  regConstL('LOCALE_INEGSEPBYSPACE',$000057, TSRMLS_DC);

  regConstL('LOCALE_FONTSIGNATURE',$000058, TSRMLS_DC);
  regConstL('LOCALE_SISO639LANGNAME',$000059, TSRMLS_DC);
  regConstL('LOCALE_SISO3166CTRYNAME',$00005A, TSRMLS_DC);

  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;


function DotNetVersion: string;
var
  R: TRegistry;
  L: TStringList;
  S: string;
  i, MaxIndex, N, Code: Integer;
  V, MaxVersion: Double;
const
  RegKey = 'Software\Microsoft\.NETFramework\Policy';
begin
  Result := '';
  R := TRegistry.Create;
  try
    R.RootKey := HKEY_LOCAL_MACHINE;
    if R.KeyExists(RegKey) then
    begin
      R.OpenKeyReadOnly(RegKey);
      L := TStringList.Create;
      try
        R.GetKeyNames(L);
        MaxVersion := -1.0;
        MaxIndex := -1;
        for i := 0 to L.Count - 1 do
        begin
          S := L[i];
          if UpCase(S[1]) = 'V' then
          begin
            Delete(S, 1, 1);
            Val(S, V, Code);
            if (Code = 0) and (V > MaxVersion) then
            begin
              MaxVersion := V;
              MaxIndex := i;
            end;
          end;
        end;
        if MaxIndex <> -1 then
        begin
          S := L[MaxIndex];
          R.CloseKey;
          R.OpenKeyReadOnly(RegKey + '\' + S);
          R.GetValueNames(L);
          MaxIndex := -1;
          for i := 0 to L.Count - 1 do
          begin
            Val(L[i], N, Code);
            if (Code = 0) and (N > MaxIndex) then
              MaxIndex := N;
          end;
          Result := S;
          Delete(Result, 1, 1);
          if MaxIndex <> -1 then
            Result := Result + '.' + IntToStr(MaxIndex);
        end;
      finally
        L.Free;
      end;
    end;
  finally
    R.Free;
  end;
end;


procedure osinfo_dotnet(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        ZVAL_STRING(return_value, DotNetVersion, true);
   except
       ZValVal(return_value);
   end;
end;


function isWin9x: Boolean; {True=Win9x} {False=NT}
asm
  xor eax, eax
  mov ecx, cs
  xor cl, cl
  jecxz @@quit
  inc eax
@@quit:
end;


procedure osinfo_isnt(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        ZValVal(return_value, not isWin9x);
   except
       ZValVal(return_value);
   end;
end;


procedure osinfo_winver(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    WinVersion: Word;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        WinVersion := GetVersion and $0000FFFF;

        ZVAL_STRING(return_value, IntToStr(Lo(WinVersion))+'.'+IntToStr(Hi(WinVersion)), false);
   except
       ZValVal(return_value);
   end;
end;

procedure osinfo_dosver(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    DosVersion: Word;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        //readPrs(param,ht);
        DosVersion := GetVersion shr 16;

        ZVAL_STRING(return_value, IntToStr(Hi(DosVersion))+'.'+IntToStr(Lo(DosVersion)), false);
   except
       ZValVal(return_value);
   end;
end;


function GetLocaleInformation(Flag: Integer): String;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfoW(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 then
    pcLCA[0] := #0;
  Result := pcLCA;
end;


procedure osinfo_locale(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var param : pzval_array;
begin
  if not checkPrs(ht,1,TSRMLS_DC) then exit;
   if not checkPrs2(ht,param,TSRMLS_DC) then exit;

   try
        readPrs(param,ht);

        ZVAL_STRING(return_value, GetLocaleInformation( prs[0] ), false);
   except
       ZValVal(return_value);
   end;
   dispose_pzval_array(param);
end;


procedure osinfo_memory(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var param : pzval_array;
    res: Cardinal;
    MS: TMemoryStatus;
begin
  if not checkPrs(ht,1,TSRMLS_DC) then exit;
   if not checkPrs2(ht,param,TSRMLS_DC) then exit;

   try
        readPrs(param,ht);


        MS.dwLength := SizeOf(TMemoryStatus);
        GlobalMemoryStatus(MS);

        case prs[0] of
          0: res := MS.dwMemoryLoad;
          1: res := MS.dwTotalPhys;
          2: res := MS.dwAvailPhys;
          3: res := MS.dwTotalPageFile;
          4: res := MS.dwAvailPageFile;
          5: res := MS.dwTotalVirtual;
          6: res := MS.dwAvailVirtual;
        end;

        ZValVal(return_value, res);
   except
       ZValVal(return_value);
   end;
   dispose_pzval_array(param);
end;


const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =
    (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;


function IsAdmin: Boolean;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: LongBool;
begin
  Result   := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
        hAccessToken);
  end;
  if bSuccess then
  begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
      ptgGroups, 1024, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
        0, 0, 0, 0, 0, 0, psidAdministrators);
      {$R-}
     for x := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
      {$R+}
     FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;
 
procedure osinfo_isadmin(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        ZValVal(return_value, IsAdmin);
   except
       ZValVal(return_value);
   end;
end;

function GetHardDiskSerial(const DriveLetter: Char): string;
type
  VolumeInfo = array[0..MAX_PATH] of Char;
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  VolumeSerialNumber: DWORD;
begin
  GetVolumeInformationW(PChar(DriveLetter + ':\'),
    nil, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed,
    VolumeFlags, nil, 0);
  Result := Format('%8.8X',
    [VolumeSerialNumber])
end;


procedure osinfo_diskserial(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var param : pzval_array;
    res: String;
begin
  if not checkPrs(ht,1,TSRMLS_DC) then exit;
   if not checkPrs2(ht,param,TSRMLS_DC) then exit;

   try
        readPrs(param,ht);

        res := prs[0];
        Res := GetHardDiskSerial( res[1] );

        ZVAL_STRING(return_value, Res, false);
   except
       ZValVal(return_value);
   end;
   dispose_pzval_array(param);
end;

function GetDiskSize(drive: Char; var free_size, total_size: Int64): Boolean;
 var
   RootPath: array[0..4] of Char;
   RootPtr: PChar;
   current_dir: string;
 begin
   RootPath[0] := Drive;
   RootPath[1] := ':';
   RootPath[2] := '\';
   RootPath[3] := #0;
   RootPtr := RootPath;
   current_dir := GetCurrentDir;
   if SetCurrentDir(drive + ':\') then
   begin
      GetDiskFreeSpaceExW(RootPtr, Free_size, Total_size, nil);
      // this to turn back to original dir
      SetCurrentDir(current_dir);
      Result := True;
   end
   else
   begin
     Result := False;
     Free_size  := -1;
     Total_size := -1;
   end;
 end;


procedure osinfo_diskfree(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var param : pzval_array;
    res: String;
    size,size2: Int64;
    r: Double;
begin
  if not checkPrs(ht,1,TSRMLS_DC) then exit;
   if not checkPrs2(ht,param,TSRMLS_DC) then exit;

   try
        readPrs(param,ht);

        res := prs[0];

        GetDiskSize( res[1], size, size2 );
        r   := size;
        ZValVal(return_value, r);
   except
       ZValVal(return_value);
   end;
   dispose_pzval_array(param);
end;

procedure osinfo_disktotal(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var param : pzval_array;
    res: String;
    size,size2: Int64;
    r: double;
begin
  if not checkPrs(ht,1,TSRMLS_DC) then exit;
   if not checkPrs2(ht,param,TSRMLS_DC) then exit;

   try
        res := Z_STRVAL(param[0]^);
        GetDiskSize( res[1], size, size2 );
        r := size2;
        ZValVal(return_value, r);
   except
       ZValVal(return_value);
   end;
   dispose_pzval_array(param);
end;

procedure osinfo_macaddress(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    res: String;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        res := GetMACAddress;
        if res = 'mac not found' then
          ZValVal(return_value, FALSE)
        else
          ZVAL_STRING(return_value, res, false);

   except
       ZValVal(return_value);
   end;
end;

procedure osinfo_get(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var param : pzval_array;
    res: Cardinal;
SysInfo: TSystemInfo;
begin
  if not checkPrs(ht,1,TSRMLS_DC) then exit;
   if not checkPrs2(ht,param,TSRMLS_DC) then exit;

   try
        readPrs(param,ht);
        GetSystemInfo(SysInfo);
        res := 20121221;
        case prs[0] of
          0: res := SysInfo.dwOemId;
          1: res := SysInfo.wProcessorArchitecture;
          2: res := SysInfo.wReserved;
          3: res := SysInfo.dwPageSize;
          4: res := SysInfo.dwActiveProcessorMask;
          5: res := SysInfo.dwNumberOfProcessors;
          6: res := SysInfo.dwProcessorType;
          7: res := SysInfo.dwAllocationGranularity;
          8: res := SysInfo.wProcessorLevel;
          9: res := SysInfo.wProcessorRevision;
        end;

        ZValVal(return_value, res);

   except
       ZValVal(return_value);
   end;
   dispose_pzval_array(param);
end;


procedure osinfo_displaydevice(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    res: String;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        res := GetDisplayDevice;
        if res = '' then
          ZValVal(return_value, FALSE)
        else
          ZVAL_STRING(return_value, res, false);

   except
       ZValVal(return_value);
   end;
end;


procedure osinfo_drivetype(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var param : pzval_array;
    res: Cardinal;
begin
  if not checkPrs(ht,1,TSRMLS_DC) then exit;
   if not checkPrs2(ht,param,TSRMLS_DC) then exit;

   try
        readPrs(param,ht);

        res := GetDriveTypeW(ToPChar(prs[0]));

        ZValVal(return_value, res);

   except
       ZValVal(return_value);
   end;
   dispose_pzval_array(param);
end;


function ReadComputerName:String;
var
i:DWORD;
p:PChar;
begin
  i:=255;
  GetMem(p, i);
  GetComputerNameW(p, i);
  Result:=String(p);
  FreeMem(p);
end;

procedure osinfo_computername(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        ZVAL_STRING(return_value,  ReadComputerName, false);

   except
       ZValVal(return_value);
   end;
end;


function GetUserFromWindows: String;
var
UserName : string;
UserNameLen : Dword;
begin
UserNameLen := 255;
SetLength(userName, UserNameLen);
if GetUserNameW(PChar(UserName), UserNameLen) then
   Result := Copy(UserName,1,UserNameLen - 1)
else
   Result := '';
end;


procedure osinfo_username(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        ZVAL_STRING(return_value, GetUserFromWindows, false);
   except
       ZValVal(return_value);
   end;
end;



procedure osinfo_syslang(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not checkPrs(ht,0,TSRMLS_DC) then exit;

   try
        ZVAL_STRING(return_value, GetLocaleInformation($0000003), false);

   except
       ZValVal(return_value);
   end;
end;

var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..16]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;
  ModuleEntry.size := sizeOf(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zend_debug := 0;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.name :=  'osinfo';
  ModuleEntry.functions := nil;
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  ModuleEntry.version := '2.1';

  ModuleEntry.module_started := 0;
  ModuleEntry._type := MODULE_PERSISTENT;
  ModuleEntry.handle := nil;
  ModuleEntry.module_number := 0;
  {$IFDEF PHP530}
  {$IFNDEF COMPILER_VC9}
  ModuleEntry.build_id := strdup(zend_pchar(ZEND_MODULE_BUILD_ID));
  {$ELSE}
  ModuleEntry.build_id := DupStr(zend_pchar(ZEND_MODULE_BUILD_ID));
  {$ENDIF}
  {$ENDIF}


  // ���������� �������...
  Module_entry_table[0].fname := 'osinfo_dotnet';
  Module_entry_table[0].handler := @osinfo_dotnet;

  Module_entry_table[1].fname := 'osinfo_isnt';
  Module_entry_table[1].handler := @osinfo_isnt;

  Module_entry_table[2].fname := 'osinfo_winver';
  Module_entry_table[2].handler := @osinfo_winver;

  Module_entry_table[3].fname := 'osinfo_dosver';
  Module_entry_table[3].handler := @osinfo_dosver;

  Module_entry_table[4].fname := 'osinfo_locale';
  Module_entry_table[4].handler := @osinfo_locale;

  Module_entry_table[5].fname := 'osinfo_memory';
  Module_entry_table[5].handler := @osinfo_memory;

  Module_entry_table[6].fname := 'osinfo_isadmin';
  Module_entry_table[6].handler := @osinfo_isadmin;

  Module_entry_table[7].fname := 'osinfo_diskserial';
  Module_entry_table[7].handler := @osinfo_diskserial;

  Module_entry_table[8].fname := 'osinfo_disktotal';
  Module_entry_table[8].handler := @osinfo_disktotal;

  Module_entry_table[9].fname := 'osinfo_diskfree';
  Module_entry_table[9].handler := @osinfo_diskfree;

  Module_entry_table[10].fname := 'osinfo_macaddress';
  Module_entry_table[10].handler := @osinfo_macaddress;

  Module_entry_table[11].fname := 'osinfo_get';
  Module_entry_table[11].handler := @osinfo_get;

  Module_entry_table[12].fname := 'osinfo_displaydevice';
  Module_entry_table[12].handler := @osinfo_displaydevice;

  { **** drives * }
  Module_entry_table[13].fname := 'osinfo_drivetype';
  Module_entry_table[13].handler := @osinfo_drivetype;

  Module_entry_table[14].fname := 'osinfo_computername';
  module_entry_table[14].handler := @osinfo_computername;

  Module_entry_table[15].fname := 'osinfo_username';
  module_entry_table[15].handler := @osinfo_username;

  Module_entry_table[16].fname := 'osinfo_syslang';
  module_entry_table[16].handler := @osinfo_syslang;

  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.
