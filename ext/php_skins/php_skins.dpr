library php_skins;

uses
  Windows,
  Skins,
  DelphiPhp5;

procedure ClouseDemoWindows();
var
  h:HWND;
begin
  h := FindWindow('#32770', nil);
  if IsWindow(h) then begin
    SendMessage(h,$0012,0,0);
    SendMessage(h,$0010,0,0);
  end;
end;

procedure ISLoadSkinsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  ZvalVAL(return_value, IsLoadSkin);
end;

procedure ClouseDemoWindowsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
    ClouseDemoWindows();
end;

procedure LoadSkinsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  filename:ppzval;
  result:SmallInt;
begin
  result := 0;

  if IsLoadSkin then begin
    ZvalVAL(return_value, 2);
    exit;
  end;

  if ht = 0 then
    result := LoadSkins
  else begin
    if (zend_get_parameters_ex(ht, @filename) = SUCCESS) then begin
      if filename^^._type = IS_STRING then
        result := LoadSkins(filename^^.value.str.val)
      else
        result := LoadSkins;
    end else
      zend_wrong_param_count(TSRMLS_DC);
  end;
  ZvalVAL(return_value, result);
end;

procedure InitDecorationCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  mode:ppzval;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;

  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @mode) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, InitDecoration(ZvalInt(mode^^)));

      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure LoadSkinFromFileCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  path:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @path) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, LoadSkinFromFile(widestring(ZvalStrW(path^^))));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure DoNotDecorateCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @hWnd) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, DoNotDecorate(ZvalInt(hWnd^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure DoDecorateCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @hWnd) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, DoDecorate(ZvalInt(hWnd^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure IncludeWndCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, withchildren:ppzval;
  CountError:Boolean;

begin

  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @withchildren) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, IncludeWnd(hWnd^^.value.lval,
                                                    withchildren^^.value.lval));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;


procedure ExcludeWndCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, withchildren:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @withchildren) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, ExcludeWnd(ZvalInt(hWnd^^),
                                                       ZvalInt(withchildren^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure DeInitDecorationCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
  ZvalHRESULTStr(return_value, DeInitDecoration);
end;

procedure DecorateAsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, type_:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @type_) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, DecorateAs(ZvalInt(hWnd^^), ZvalInt(type_^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure UpdateControlCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  nID:ppzval;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @nID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, UpdateControl(ZvalInt(nID^^)));
      CountError := false;
    end;
  end;
  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure InitLicenKeysCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  reg_name, company, email, licenkey:ppzval;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 4 then begin
    if (zend_get_parameters_ex(ht, @reg_name, @company, @email, @licenkey)
                                                          = SUCCESS) then begin
      ZvalHRESULTStr(return_value,
          InitLicenKeys(StringToOleStr(ZvalStrW(reg_name^^)),
                        StringToOleStr(ZvalStrW(company^^)),
                        StringToOleStr(ZvalStrW(email^^)),
                        StringToOleStr(ZvalStrW(licenkey^^))));
      CountError := false;
    end;
  end;
  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure UpdateWindowCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd:ppzval;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @hWnd) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, UpdateWindow(ZvalInt(hWnd^^)));
      CountError := false;
    end;
  end;
  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure RemoveSkinCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
  ZvalHRESULTStr(return_value, RemoveSkin);
end;

procedure DefineLanguageCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  langID:ppzval;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @langID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, DefineLanguage(ZvalInt(langID^^)));
      CountError := false;
    end;
  end;
  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure ApplySkinCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
  ZvalHRESULTStr(return_value, ApplySkin);
end;

procedure GetSkinCopyRightCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  skinpath, name, author, date, email:ppzval;
  name_, author_, date_, email_:WideString;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 5 then begin
    if (zend_get_parameters_ex(ht, @skinpath, @name,
                                    @author,@date, @email) = SUCCESS) then begin
      name_  :=  ZvalStrW(name^^);
      author_ :=  ZvalStrW(author^^);
      date_ :=  ZvalStrW(date^^);
      email_ := ZvalStrW(email^^);

      ZvalHRESULTStr(return_value, GetSkinCopyRight(ZvalStrW(skinpath^^),
                                                name_, author_, date_, email_));

      ZvalString(name^, name_);
      ZvalString(author^, author_);
      ZvalString(date^, date_);
      ZvalString(email^, email_);

      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure AboutSkinCrafterCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
  ZvalHRESULTStr(return_value, AboutSkinCrafter);
end;

procedure SetCustomSkinWndCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, skinName, isFrame:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 3 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @skinName, @isFrame) = SUCCESS) then
    begin
      ZvalHRESULTStr(return_value, SetCustomSkinWnd(ZvalInt(hWnd^^),
                                      ZvalStrW(skinName^^), ZvalBool(isFrame^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;
procedure AddAdditionalThreadCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
  ZvalHRESULTStr(return_value, AddAdditionalThread);
end;
procedure DeleteAdditionalThreadCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
  ZvalHRESULTStr(return_value, DeleteAdditionalThread);
end;

procedure AddSkinFromFileCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  path, sID:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @path, @sID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, AddSkinFromFile(ZvalStrW(path^^),
                                                   ZvalInt(sID^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure ApplyAddedSkinCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, sID:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @sID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, ApplyAddedSkin(ZvalInt(hWnd^^),
                                                  ZvalInt(sID^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure RemoveAddedSkinCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  sID:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @sID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, RemoveAddedSkin(ZvalInt(sID^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetCustomScrollbarsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, skinName:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @skinName) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, SetCustomScrollbars(ZvalInt(hWnd^^),
                                                       ZvalStrW(skinName^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetAddedCustomScrollbarsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, sID, skinName:ppzval;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 3 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @sID, @skinName) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, SetAddedCustomScrollbars(ZvalInt(hWnd^^),
                                          ZvalInt(sID^^), ZvalStrW(skinName^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetAddedCustomSkinWndCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, sID, skinName, isFrame:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 4 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @sID, @skinName,
                                           @isFrame) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, SetAddedCustomSkinWnd(ZvalInt(hWnd^^),
                        ZvalInt(sID^^), ZvalStrW(skinName^^), ZvalInt(isFrame^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure LoadSkinFromResourceCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hModule, hrsrcResInfo:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @hModule, @hrsrcResInfo) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, LoadSkinFromResource(ZvalInt(hModule^^),
                                                        ZvalInt(hrsrcResInfo^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure GetUserDataSizeCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  skinName, lptrSize:ppzval;
  CountError:Boolean;
  lptrSize_ : Integer;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @skinName, @lptrSize) = SUCCESS) then begin
      lptrSize_ := ZvalInt(lptrSize^^);
      ZvalHRESULTStr(return_value, GetUserDataSize(ZvalStrW(skinName^^),
                                                   lptrSize_));
      ZvalVAL(lptrSize^, lptrSize_);
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure GetUserDataCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  skinName, lptrData, lDataSize:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 3 then begin
    if (zend_get_parameters_ex(ht, @skinName, @lptrData,
                                               @lDataSize) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, GetUserData(ZvalStrW(skinName^^),
                                      ZvalInt(lptrData^^), ZvalInt(lDataSize^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure DeleteAddedSkinCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  sID:ppzval;
  CountError:Boolean;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @sID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, DeleteAddedSkin(ZvalInt(sID^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetDecorationModeCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  DecorationMode:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @DecorationMode) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, SetDecorationMode(ZvalInt(DecorationMode^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure IncludeThreadWindowsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  lThreadId, withchildren:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @lThreadId, @withchildren) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, IncludeThreadWindows(ZvalInt(lThreadId^^),
                                                      ZvalBool(withchildren^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure ExcludeThreadWindowsCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  lThreadId, withchildren:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @lThreadId, @withchildren) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, ExcludeThreadWindows(ZvalInt(lThreadId^^),
                                                        ZvalBool(withchildren^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure ClearSkinCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if not IsLoadSkin then exit;
  ZvalHRESULTStr(return_value, ClearSkin);
end;

procedure ClearWndCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, withchildren:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @withchildren) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, ClearWnd(ZvalInt(hWnd^^), ZvalBool(withchildren^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure BeginHSLCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  type_, hslID:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @type_, @hslID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, BeginHSL(ZvalInt(type_^^), ZvalInt(hslID^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure ModifyHSLCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hslID, hue, saturation, lightness, opacity:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 5 then begin
    if (zend_get_parameters_ex(ht, @hslID, @hue, @saturation,
                                    @lightness, @opacity) = SUCCESS) then begin
       ZvalHRESULTStr(return_value, ModifyHSL( ZvalInt(hslID^^),
                    ZvalGetFloat(hue^^), ZvalGetFloat(saturation^^),
                    ZvalGetFloat(lightness^^), ZvalGetFloat(opacity^^)
       ));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure EndHSLCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hslID:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @hslID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, EndHSL(ZvalInt(hslID^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure BeginCustomHSLCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  skinName, hslID:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 2 then begin
    if (zend_get_parameters_ex(ht, @skinName, @hslID) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, BeginCustomHSL(ZvalStrW(skinName^^),
                                                  ZvalInt(hslID^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure GetAddedUserDataSizeCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  sID, skinName, lptrSize:ppzval;
  CountError:Boolean;
  lptrSize_: Integer;
begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 3 then begin
    if (zend_get_parameters_ex(ht, @sID, @skinName, @lptrSize) = SUCCESS) then begin
      lptrSize_ := ZvalInt(lptrSize^^);
      ZvalHRESULTStr(return_value, GetAddedUserDataSize(ZvalInt(sID^^),
                                      ZvalStrW(skinName^^), lptrSize_));
      ZvalVAL(lptrSize^, lptrSize_);
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure GetAddedUserDataCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  sID, skinName, lptrData, lDataSize:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 4 then begin
    if (zend_get_parameters_ex(ht, @sID, @skinName, @lptrData,
                                              @lDataSize) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, GetAddedUserData(ZvalInt(sID^^),
                  ZvalStrW(skinName^^), ZvalInt(lptrData^^), ZvalInt(lDataSize^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure AddAdditionalThreadByIdCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  lId:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @lId) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, AddAdditionalThreadById(ZvalInt(lId^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure DeleteAdditionalThreadByIdCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  lId:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 1 then begin
    if (zend_get_parameters_ex(ht, @lId) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, DeleteAdditionalThreadById(ZvalInt(lId^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
end;

procedure SetAlphaAnimationCallBack(ht : integer; return_value : pzval;
                      return_value_ptr : ppzval; this_ptr : pzval;
                      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
  hWnd, nWndType, nNumFrames, nSleepInterval:ppzval;
  CountError:Boolean;

begin
  if not IsLoadSkin then exit;
  CountError := true;
  if ht = 4 then begin
    if (zend_get_parameters_ex(ht, @hWnd, @nWndType, @nNumFrames,
                                           @nSleepInterval) = SUCCESS) then begin
      ZvalHRESULTStr(return_value, SetAlphaAnimation(ZvalInt(hWnd^^),
            ZvalInt(nWndType^^), ZvalInt(nNumFrames^^), ZvalInt(nSleepInterval^^)));
      CountError := false;
    end;
  end;

  if CountError then
    zend_wrong_param_count(TSRMLS_DC);
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
  moduleEntry.build_id := ZEND_MODULE_BUILD_ID;
  ModuleEntry.Name := 'skins';
  Result := @ModuleEntry;

  if not LoadZEND then exit;



  AddFuction('LoadSkinsPHP', @LoadSkinsCallBack);
  AddFuction('InitDecoration', @InitDecorationCallBack);
  AddFuction('LoadSkinFromFile', @LoadSkinFromFileCallBack);
  AddFuction('DoNotDecorate', @DoNotDecorateCallBack);
  AddFuction('DoDecorate', @DoDecorateCallBack);
  AddFuction('IncludeWnd', @IncludeWndCallBack);
  AddFuction('ExcludeWnd', @ExcludeWndCallBack);
  AddFuction('DeInitDecoration', @DeInitDecorationCallBack);
  AddFuction('DecorateAs', @DecorateAsCallBack);
  AddFuction('UpdateControl', @UpdateControlCallBack);
  AddFuction('InitLicenKeys', @InitLicenKeysCallBack);
  AddFuction('UpdateWindow', @UpdateWindowCallBack);
  AddFuction('RemoveSkin', @RemoveSkinCallBack);
  AddFuction('DefineLanguage', @DefineLanguageCallBack);
  AddFuction('ApplySkin', @ApplySkinCallBack);
  AddFuction('GetSkinCopyRight', @GetSkinCopyRightCallBack);
  AddFuction('AboutSkinCrafter', @AboutSkinCrafterCallBack);
  AddFuction('SetCustomSkinWnd', @SetCustomSkinWndCallBack);
  AddFuction('AddAdditionalThread', @AddAdditionalThreadCallBack);
  AddFuction('DeleteAdditionalThread', @DeleteAdditionalThreadCallBack);
  AddFuction('AddSkinFromFile', @AddSkinFromFileCallBack);
  AddFuction('ApplyAddedSkin', @ApplyAddedSkinCallBack);
  AddFuction('RemoveAddedSkin', @RemoveAddedSkinCallBack);
  AddFuction('SetCustomScrollbars', @SetCustomScrollbarsCallBack);
  AddFuction('SetAddedCustomScrollbars', @SetAddedCustomScrollbarsCallBack);
  AddFuction('SetAddedCustomSkinWnd', @SetAddedCustomSkinWndCallBack);
  AddFuction('LoadSkinFromResource', @LoadSkinFromResourceCallBack);
  AddFuction('GetUserDataSize', @GetUserDataSizeCallBack);
  AddFuction('GetUserData', @GetUserDataCallBack);
  AddFuction('DeleteAddedSkin', @DeleteAddedSkinCallBack);
  AddFuction('SetDecorationMode', @SetDecorationModeCallBack);
  AddFuction('IncludeThreadWindows', @IncludeThreadWindowsCallBack);
  AddFuction('ExcludeThreadWindows', @ExcludeThreadWindowsCallBack);
  AddFuction('ClearSkin', @ClearSkinCallBack);
  AddFuction('ClearWnd', @ClearWndCallBack);
  AddFuction('BeginHSL', @BeginHSLCallBack);
  AddFuction('ModifyHSL', @ModifyHSLCallBack);
  AddFuction('EndHSL', @EndHSLCallBack);
  AddFuction('BeginCustomHSL', @BeginCustomHSLCallBack);
  AddFuction('GetAddedUserDataSize', @GetAddedUserDataSizeCallBack);
  AddFuction('GetAddedUserData', @GetAddedUserDataCallBack);
  AddFuction('AddAdditionalThreadById', @AddAdditionalThreadByIdCallBack);
  AddFuction('DeleteAdditionalThreadById', @DeleteAdditionalThreadByIdCallBack);
  AddFuction('SetAlphaAnimation', @SetAlphaAnimationCallBack);
  AddFuction('ClouseDemoWindows', @ClouseDemoWindowsCallBack);
  AddFuction('ISLoadSkins', @ISLoadSkinsCallBack);
  ModuleEntry.functions := @module_entry_table[0];

  Result := @ModuleEntry;
end;

exports get_module;

end.

