unit sMessages;
{$I sDefs.inc}

interface

uses Windows, Controls {$IFDEF FPC}, LMessages{$ENDIF};

type
  TacSectionInfo = record
    siName: string;
    siSkinIndex: integer;
    siRepaintNeeded: boolean;
  end;

  PacSectionInfo = ^TacSectionInfo;

const
  SM_ALPHACMD               = $A100;

  AC_SETNEWSKIN             = 1;
  AC_REMOVESKIN             = 2;
  AC_REFRESH                = 3; // if WParamLo = 1 then message will not be broadcasted to children
  AC_GETPROVIDER            = 4;
  AC_GETCACHE               = 5;
  AC_ENDPARENTUPDATE        = 6;
  AC_CTRLHANDLED            = 7;
  AC_UPDATING               = 8;
  AC_GETDEFINDEX            = 9; // Get skin index if SkinSection is empty (incremented to 1)
  AC_PREPARING              = 10;
  AC_GETHALFVISIBLE         = 11;
  AC_GETLISTSW              = 12;

  AC_UPDATESECTION          = 13;
  AC_DROPPEDDOWN            = 14;
  AC_SETSECTION             = 15;

  AC_STOPFADING             = 16;
  AC_SETBGCHANGED           = 17;
  AC_INVALIDATE             = 18;
  AC_CHILDCHANGED           = 19;
  AC_SETCHANGEDIFNECESSARY  = 20;  // Defines BgChanged to True if required, with repainting if WParamLo = 1
  AC_GETCONTROLCOLOR        = 21;  // Returns control BG color
  AC_SETHALFVISIBLE         = 22;
  AC_PREPARECACHE           = 23;
  AC_DRAWANIMAGE            = 24;
  AC_CONTROLLOADED          = 25;
  AC_GETSKININDEX           = 26;
  AC_GETSERVICEINT          = 27;
  AC_UPDATECHILDREN         = 28;
  AC_MOUSEENTER             = 29;
  AC_MOUSELEAVE             = 30;
  AC_BEGINUPDATE            = 31;
  AC_ENDUPDATE              = 32;
  AC_CLEARCACHE             = 33;

  AC_GETBG                  = 34;
  AC_GETDISKIND             = 35;  // Init a look of disabled control

  AC_FONTSCHANGED           = 36;  // Updates default font in application (default font is Application.MainForm.Font.Name)
  AC_GETSKINDATA            = 37;
  AC_PRINTING               = 38;

  AC_PAINTOUTER             = 40;  // Paint a Shadow or other effect, LParam is PBGInfo, if WParamLo is 1 - use cached BG if exists 

  AC_BEFORESCROLL           = 51;
  AC_AFTERSCROLL            = 52;
  AC_REINITSCROLLS          = 53;
  AC_GETCOLORTONE           = 54;
  AC_GETAPPLICATION         = 60;
  AC_PARENTCLOFFSET         = 61;
  AC_NCPAINT                = 62;
  AC_SETPOSCHANGING         = 63;
  AC_GETPOSCHANGING         = 64;
  AC_SETALPHA               = 65;
  AC_GETFONTINDEX           = 66;
  AC_GETBORDERWIDTH         = 67;
  AC_SETSCALE               = 68;
  AC_GETSCALE               = 69;

  AC_GETOUTRGN              = 70;
  AC_COPYDATA               = 71;

  AC_POPUPCLOSED            = 72;
  AC_UPDATESHADOW           = 73;

  AC_SKINCHANGED            = 74;
  AC_SKINLISTCHANGED        = 75;

  AC_PAINTFLOATITEMS        = 76;
  AC_UPDATEFLOATITEMS       = 77;
  AC_UPDATEITEMSALPHA       = 78;
  AC_UPDATEPAGEBTN          = AC_UPDATEITEMSALPHA;
  AC_GETTOPWND              = 79;
  AC_SETFLOATZORDER         = 80;
  AC_UPDATEFLOATBITMAPS     = 81;
  AC_KILLTIMERS             = 82;
  AC_SETNCSKINNED           = 83; // LPARAM = 0 or 1
  AC_REFLECTLAYOUT          = 84;
  AC_ISOPAQUE               = 85;
  AC_GETCOMMONSKINDATA      = 86;

  AC_ANIMSCALE              = 87; // WParamLo: new PPI

  AC_GETBG_HI               = WPARAM(AC_GETBG           shl 16);
  AC_REFRESH_HI             = WPARAM(AC_REFRESH         shl 16);
  AC_UPDATING_HI            = WPARAM(AC_UPDATING        shl 16);
  AC_SETNEWSKIN_HI          = WPARAM(AC_SETNEWSKIN      shl 16);
  AC_GETSERVICEINT_HI       = WPARAM(AC_GETSERVICEINT   shl 16);
  AC_REMOVESKIN_HI          = WPARAM(AC_REMOVESKIN      shl 16);
  AC_PREPARECACHE_HI        = WPARAM(AC_PREPARECACHE    shl 16);
  AC_BEGINUPDATE_HI         = WPARAM(AC_BEGINUPDATE     shl 16);
  AC_ENDUPDATE_HI           = WPARAM(AC_ENDUPDATE       shl 16);
  AC_PAINTOUTER_HI          = WPARAM(AC_PAINTOUTER      shl 16);
  AC_SETBGCHANGED_HI        = WPARAM(AC_SETBGCHANGED    shl 16);
  AC_GETCONTROLCOLOR_HI     = WPARAM(AC_GETCONTROLCOLOR shl 16);
  AC_GETDEFINDEX_HI         = WPARAM(AC_GETDEFINDEX     shl 16);
  AC_CLEARCACHE_HI          = WPARAM(AC_CLEARCACHE      shl 16);
  AC_SETSCALE_HI            = WPARAM(AC_SETSCALE        shl 16);
  AC_GETSKINDATA_HI         = WPARAM(AC_GETSKINDATA     shl 16);
  AC_MOUSELEAVE_HI          = WPARAM(AC_MOUSELEAVE      shl 16);
  AC_GETPROVIDER_HI         = WPARAM(AC_GETPROVIDER     shl 16);
  AC_ENDPARENTUPDATE_HI     = WPARAM(AC_ENDPARENTUPDATE shl 16);
//  AC_GETSKINSTATE_HI        = WPARAM(AC_GETSKINSTATE    shl 16);
  AC_CTRLHANDLED_HI         = WPARAM(AC_CTRLHANDLED     shl 16);
  AC_GETFONTINDEX_HI        = WPARAM(AC_GETFONTINDEX    shl 16);
  AC_STOPFADING_HI          = WPARAM(AC_STOPFADING      shl 16);

  WM_DRAWMENUBORDER         = CN_NOTIFY + 101;
  WM_DRAWMENUBORDER2        = CN_NOTIFY + 102;

{$IFNDEF D2010}
  {$EXTERNALSYM WM_DWMSENDICONICTHUMBNAIL}
  WM_DWMSENDICONICTHUMBNAIL         = $0323;
  {$EXTERNALSYM WM_DWMSENDICONICLIVEPREVIEWBITMAP}
  WM_DWMSENDICONICLIVEPREVIEWBITMAP = $0326;
{$ENDIF}

implementation

end.
