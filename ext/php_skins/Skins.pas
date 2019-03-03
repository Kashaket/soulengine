unit Skins;

interface

uses Winapi.Windows, FileExists;

const
  SkinDll = 'SkinCrafter.dll';

function LoadSkins(const DllFilename:AnsiString = SkinDll): Integer;
function IsLoadSkin:Boolean;


var
  DLLSkins:THandle = 0;
  InitDecoration:function(mode : Integer):HRESULT; cdecl;
  LoadSkinFromFile:function(const path : WideString):HRESULT; cdecl;
  DoNotDecorate:function(hWnd : Integer):HRESULT; cdecl;
  DoDecorate:function(hWnd : Integer):HRESULT; cdecl;
  IncludeWnd:function(hWnd, withchildren : Integer):HRESULT; cdecl;
  ExcludeWnd:function(hWnd, withchildren : Integer):HRESULT; cdecl;
  DeInitDecoration:function:HRESULT; cdecl;
  DecorateAs:function(hWnd, type_ : Integer):HRESULT; cdecl;
  UpdateControl:function(nID : Integer):HRESULT; cdecl;
  InitLicenKeys:function(const reg_name, company, email, licenkey : LPCTSTR):HRESULT; cdecl;
  UpdateWindow:function(hWnd : Integer):HRESULT; cdecl;
  RemoveSkin:function:HRESULT; cdecl;
  DefineLanguage:function(langID: Integer):HRESULT; cdecl;
  ApplySkin:function:HRESULT; cdecl;
  GetSkinCopyRight:function(const skinpath: WideString; var name, author, date, email: WideString):HRESULT; cdecl;
  AboutSkinCrafter:function:HRESULT; cdecl;
  SetCustomSkinWnd:function(hWnd: Integer; const skinName: WideString; isFrame: Boolean):HRESULT; cdecl;
  AddAdditionalThread:function:HRESULT; cdecl;
  DeleteAdditionalThread:function:HRESULT; cdecl;
  AddSkinFromFile:function(const path: WideString; sID: Smallint):HRESULT; cdecl;
  ApplyAddedSkin:function(hWnd: Integer; sID: Smallint):HRESULT; cdecl;
  RemoveAddedSkin:function(sID: Smallint):HRESULT; cdecl;
  SetCustomScrollbars:function(hWnd: Integer; const skinName: WideString):HRESULT; cdecl;
  SetAddedCustomScrollbars:function(hWnd: Integer; sID: Smallint; const skinName: WideString):HRESULT; cdecl;
  SetAddedCustomSkinWnd:function(hWnd: Integer; sID: Smallint; const skinName: WideString; isFrame: Integer):HRESULT; cdecl;
  LoadSkinFromResource:function(hModule, hrsrcResInfo : Integer):HRESULT; cdecl;
  GetUserDataSize:function(const skinName : WideString; var lptrSize : Integer):HRESULT; cdecl;
  GetUserData:function(const skinName: WideString; lptrData, lDataSize : Integer):HRESULT; cdecl;
  DeleteAddedSkin:function(sID : Smallint):HRESULT; cdecl;
  SetDecorationMode:function(DecorationMode : Integer):HRESULT; cdecl;
  IncludeThreadWindows:function(lThreadId:Integer; withchildren : Boolean):HRESULT; cdecl;
  ExcludeThreadWindows:function (lThreadId:Integer; withchildren : Boolean):HRESULT; cdecl;
  ClearSkin:function:HRESULT; cdecl;
  ClearWnd:function(hWnd:Integer; withchildren: Boolean):HRESULT; cdecl;
  BeginHSL:function(type_, hslID: Integer):HRESULT; cdecl;
  ModifyHSL:function(hslID: Integer; hue, saturation, lightness, opacity: Double):HRESULT; cdecl;
  EndHSL:function(hslID: Integer):HRESULT; cdecl;
  BeginCustomHSL:function(const skinName: WideString; hslID: Integer):HRESULT; cdecl;
  GetAddedUserDataSize:function(sID: Smallint; const skinName: WideString; var lptrSize: Integer):HRESULT; cdecl;
  GetAddedUserData:function(sID: Smallint; const skinName: WideString; lptrData, lDataSize: Integer):HRESULT; cdecl;
  AddAdditionalThreadById:function(lId: Integer):HRESULT; cdecl;
  DeleteAdditionalThreadById:function(lId: Integer):HRESULT; cdecl;
  SetAlphaAnimation:function(hWnd: Integer; nWndType: Smallint; nNumFrames, nSleepInterval: Smallint):HRESULT; cdecl;
  function GetFileAttributes(lpFileName: LPCWSTR): DWORD; stdcall; external kernel32 name 'GetFileAttributesW';
implementation

function IsLoadSkin:Boolean;
begin
  result := DLLSkins <> 0;
end;

function LoadSkins;
begin
  result := 0;
  if FileExists_(DllFilename) then begin
    DLLSkins := LoadLibraryA(PAnsiChar(DllFilename));
    if DLLSkins <> 0 then begin
        InitDecoration := GetProcAddress(DLLSkins, 'InitDecoration');
        LoadSkinFromFile := GetProcAddress(DLLSkins, 'LoadSkinFromFile');
        DoNotDecorate := GetProcAddress(DLLSkins, 'DoNotDecorate');
        DoDecorate := GetProcAddress(DLLSkins, 'DoDecorate');
        IncludeWnd := GetProcAddress(DLLSkins, 'IncludeWnd');
        ExcludeWnd := GetProcAddress(DLLSkins, 'ExcludeWnd');
        DeInitDecoration := GetProcAddress(DLLSkins, 'DeInitDecoration');
        DecorateAs := GetProcAddress(DLLSkins, 'DecorateAs');
        UpdateControl := GetProcAddress(DLLSkins, 'UpdateControl');
        InitLicenKeys := GetProcAddress(DLLSkins, 'InitLicenKeys');
        UpdateWindow := GetProcAddress(DLLSkins, 'UpdateWindow');
        RemoveSkin := GetProcAddress(DLLSkins, 'RemoveSkin');
        DefineLanguage := GetProcAddress(DLLSkins, 'DefineLanguage');
        ApplySkin := GetProcAddress(DLLSkins, 'ApplySkin');
        GetSkinCopyRight := GetProcAddress(DLLSkins, 'GetSkinCopyRight');
        AboutSkinCrafter := GetProcAddress(DLLSkins, 'AboutSkinCrafter');
        SetCustomSkinWnd := GetProcAddress(DLLSkins, 'SetCustomSkinWnd');
        AddAdditionalThread := GetProcAddress(DLLSkins, 'AddAdditionalThread');
        DeleteAdditionalThread := GetProcAddress(DLLSkins, 'DeleteAdditionalThread');
        AddSkinFromFile := GetProcAddress(DLLSkins, 'AddSkinFromFile');
        ApplyAddedSkin := GetProcAddress(DLLSkins, 'ApplyAddedSkin');
        RemoveAddedSkin := GetProcAddress(DLLSkins, 'RemoveAddedSkin');
        SetCustomScrollbars := GetProcAddress(DLLSkins, 'SetCustomScrollbars');
        SetAddedCustomScrollbars := GetProcAddress(DLLSkins, 'SetAddedCustomScrollbars');
        SetAddedCustomSkinWnd := GetProcAddress(DLLSkins, 'SetAddedCustomSkinWnd');
        LoadSkinFromResource := GetProcAddress(DLLSkins, 'LoadSkinFromResource');
        GetUserDataSize := GetProcAddress(DLLSkins, 'GetUserDataSize');
        GetUserData := GetProcAddress(DLLSkins, 'GetUserData');
        DeleteAddedSkin := GetProcAddress(DLLSkins, 'DeleteAddedSkin');
        SetDecorationMode := GetProcAddress(DLLSkins, 'SetDecorationMode');
        IncludeThreadWindows := GetProcAddress(DLLSkins, 'IncludeThreadWindows');
        ExcludeThreadWindows := GetProcAddress(DLLSkins, 'ExcludeThreadWindows');
        ClearSkin := GetProcAddress(DLLSkins, 'ClearSkin');
        ClearWnd := GetProcAddress(DLLSkins, 'ClearWnd');
        BeginHSL := GetProcAddress(DLLSkins, 'BeginHSL');
        ModifyHSL := GetProcAddress(DLLSkins, 'ModifyHSL');
        EndHSL := GetProcAddress(DLLSkins, 'EndHSL');
        BeginCustomHSL := GetProcAddress(DLLSkins, 'BeginCustomHSL');
        GetAddedUserDataSize := GetProcAddress(DLLSkins, 'GetAddedUserDataSize');
        GetAddedUserData := GetProcAddress(DLLSkins, 'GetAddedUserData');
        AddAdditionalThreadById := GetProcAddress(DLLSkins, 'AddAdditionalThreadById');
        DeleteAdditionalThreadById := GetProcAddress(DLLSkins, 'DeleteAdditionalThreadById');
        SetAlphaAnimation := GetProcAddress(DLLSkins, 'SetAlphaAnimation');
        result := 1;
    end;
  end;
end;

end.
