unit sConst;
{$I sDefs.inc}
//{$DEFINE LOGGED}
//{$DEFINE MAKEOBJ}

interface

uses
  Graphics, Windows, comctrls, controls, classes, Forms, StdCtrls;

{$R SRES.RES}

{$IFNDEF NOTFORHELP}

type
  TacSkinColorData = record
    Value: TColor;
    Name: ShortString;
  end;

const
  CompatibleSkinVersion = 10.26; // Minimal version of supported skins in the current version of the package
  MaxCompSkinVersion = 14.99;

  // Followed colors are changed according to the skin palette if used with ToSkinColor function

{$IFNDEF DELPHI7UP}
  clSystemColor        = TColor($FF000000);
{$ENDIF}

  slMainColor          = TColor($F1000001);

  slBtnRed             = TColor(clSystemColor or $D5D5FF);
  slBtnRedActive       = TColor(clSystemColor or $BDBDFF);
  slBtnRedText         = TColor(clSystemColor or $0000B4);
  slBtnRedTextActive   = TColor(clSystemColor or $0000A2);

  slBtnGreen           = TColor(clSystemColor or $E1FFD2);
  slBtnGreenActive     = TColor(clSystemColor or $CDFFB4);
  slBtnGreenText       = TColor(clSystemColor or $28851A);
  slBtnGreenTextActive = TColor(clSystemColor or $008E00);

  slBtnBlue            = TColor(clSystemColor or $FFEDC9);
  slBtnBlueActive      = TColor(clSystemColor or $FFE9BE);
  slBtnBlueText        = TColor(clSystemColor or $AE7400);
  slBtnBlueTextActive  = TColor(clSystemColor or $916000);

  slBtnYellow           = TColor(clSystemColor or $CAF3FF);
  slBtnYellowActive     = TColor(clSystemColor or $BAEFFF);
  slBtnYellowText       = TColor(clSystemColor or $00A5D7);
  slBtnYellowTextActive = TColor(clSystemColor or $0098C6);

  slEditGreen          = TColor(clSystemColor or $C9FFD2);
  slEditYellow         = TColor(clSystemColor or $BAFFFF);
  slEditRed            = TColor(clSystemColor or $DBDBFF);

  slEditGreenText      = TColor(clSystemColor or $003E0A);
  slEditYellowText     = TColor(clSystemColor or $004C4C);
  slEditRedText        = TColor(clSystemColor or $00006C);

  acSkinColorNames: array [0..21] of TacSkinColorData = (
    (Value: slBtnRed;             Name: 'slBtnRed'),
    (Value: slBtnRedActive;       Name: 'slBtnRedActive'),
    (Value: slBtnRedText;         Name: 'slBtnRedText'),
    (Value: slBtnRedTextActive;   Name: 'slBtnRedTextActive'),

    (Value: slBtnGreen;           Name: 'slBtnGreen'),
    (Value: slBtnGreenActive;     Name: 'slBtnGreenActive'),
    (Value: slBtnGreenText;       Name: 'slBtnGreenText'),
    (Value: slBtnGreenTextActive; Name: 'slBtnGreenTextActive'),

    (Value: slBtnBlue;            Name: 'slBtnBlue'),
    (Value: slBtnBlueActive;      Name: 'slBtnBlueActive'),
    (Value: slBtnBlueText;        Name: 'slBtnBlueText'),
    (Value: slBtnBlueTextActive;  Name: 'slBtnBlueTextActive'),

    (Value: slBtnYellow;          Name: 'slBtnOrange'),
    (Value: slBtnYellowActive;    Name: 'slBtnOrangeActive'),
    (Value: slBtnYellowText;      Name: 'slBtnOrangeText'),
    (Value: slBtnYellowTextActive;Name: 'slBtnOrangeTextActive'),

    (Value: slEditGreen;          Name: 'slEditGreen'),
    (Value: slEditYellow;         Name: 'slEditYellow'),
    (Value: slEditRed;            Name: 'slEditRed'),

    (Value: slEditGreenText;      Name: 'slEditGreenText'),
    (Value: slEditYellowText;     Name: 'slEditYellowText'),
    (Value: slEditRedText;        Name: 'slEditRedText')
  );

  // Data characters for skins
  ZeroChar      = Char('0');
  CharOne       = Char('1');
  CharQuest     = Char('?');
  CharDiez      = Char('#');

  TexChar       = Char('~');
  CharExt       = Char('!'); // External image separator
  CharGlyph     = Char('@'); // Glyph data separator
  CharMask      = Char('^');

  acCharImg     = Char('&'); // New format since v13.20

  CharMinus     = Char('-');
  CharPlus      = Char('+');
  CharSemicolon = Char(';');

{$IFNDEF DELPHI_10BERLIN}
  WM_DPICHANGED = $02E0;
  SM_CXPADDEDBORDER = 92;
{$ENDIF}

  i360 = 360;
  i270 = 270;
  i180 = 180;
  i90  = 90;

  // States of control
  ACS_PRINTING      = $200; // WM_PRINT in process
  ACS_MNUPDATING    = $400; // Menu updating required
  ACS_LOCKED        = $800; // Drawing of control is blocked
  ACS_FOCUSCHANGING = $1000;
  ACS_CHANGING      = $2000;
  ACS_BGRECEIVING   = $4000;
  ACS_REPAINTNEEDH  = $8000;
  ACS_REPAINTNEEDV  = $10000;
  ACS_CTRLSCALING   = $20000;
  ACS_NCCHANGED     = $40000;

  // Background types
  BGT_NONE          = 0;
  BGT_GRADIENTHORZ  = 1;
  BGT_GRADIENTVERT  = 2;

  BGT_STRETCH       = 4;

  BGT_TEXTURELEFT   = $10;
  BGT_TEXTURETOP    = $20;
  BGT_TEXTURERIGHT  = $40;
  BGT_TEXTUREBOTTOM = $80;

  BGT_TEXTUREVERT   = BGT_TEXTURELEFT or BGT_TEXTURERIGHT;
  BGT_TEXTUREHORZ   = BGT_TEXTURETOP or BGT_TEXTUREBOTTOM;

  BGT_STRETCHVERT   = BGT_STRETCH or BGT_TEXTUREVERT;
  BGT_STRETCHHORZ   = BGT_STRETCH or BGT_TEXTUREHORZ;

  BGT_TOPLEFT       = $100;
  BGT_TOPRIGHT      = $200;
  BGT_BOTTOMLEFT    = $400;
  BGT_BOTTOMRIGHT   = $800;

  RDWA_FRAME       = RDW_INVALIDATE or RDW_FRAME or RDW_NOERASE;
  RDWA_FRAMENOW    = RDWA_FRAME or RDW_UPDATENOW;
  RDWA_REPAINT     = RDW_INVALIDATE or RDW_FRAME or RDW_ERASE;
  RDWA_ERASENOW    = RDW_INVALIDATE or RDW_ERASE or RDW_UPDATENOW;
  RDWA_ALL         = RDWA_REPAINT or RDW_ALLCHILDREN;
  RDWA_ALLNOW      = RDWA_ALL or RDW_UPDATENOW;
  RDWA_ALLCHILDREN = RDW_NOERASE or RDW_NOINTERNALPAINT or RDW_INVALIDATE or RDW_ALLCHILDREN;

  RDWA_NOCHILDREN    = RDW_INVALIDATE or RDW_ERASE or RDW_FRAME or RDW_NOCHILDREN;
  RDWA_NOCHILDRENNOW = RDWA_NOCHILDREN or RDW_UPDATENOW;

  SWPA_FRAMECHANGED = SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOCOPYBITS or SWP_NOSENDCHANGING or SWP_NOREPOSITION or SWP_FRAMECHANGED;
  SWPA_NOCOPYBITS   = SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOCOPYBITS or SWP_NOSENDCHANGING or SWP_NOREPOSITION or SWP_NOREDRAW;
  SWPA_SHOW         = SWP_NOACTIVATE or SWP_NOREDRAW or SWP_SHOWWINDOW or SWP_NOSENDCHANGING or SWP_NOOWNERZORDER;
  SWPA_HIDE         = SWP_NOACTIVATE or SWP_NOREDRAW or SWP_HIDEWINDOW or SWP_NOSENDCHANGING or SWP_NOOWNERZORDER;

  SWPA_SHOWZORDER     = SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOREDRAW or SWP_SHOWWINDOW or SWP_NOSENDCHANGING or SWP_NOOWNERZORDER;
  SWPA_SHOWZORDERONLY = SWPA_SHOWZORDER or SWP_NOMOVE;

  SWPA_ZORDER = SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOREDRAW or SWP_NOSENDCHANGING or SWP_NOOWNERZORDER;
  EllipsFlags = DT_END_ELLIPSIS or DT_PATH_ELLIPSIS or DT_WORD_ELLIPSIS;

  // Predefined internal tags for ListWnd objects
  ACT_RELCAPT = -1; // Release capture after MouseUp

  PNGMagic: array [0..7] of Byte = (137, 80, 78, 71, 13, 10, 26, 10);
  CheckBoxStates: array [0..2] of TCheckBoxState = (cbUnchecked, cbChecked, cbGrayed);
  acAlignmentArray: array [TAlignment] of word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  TextWrapping: array [boolean] of Cardinal = (DT_SINGLELINE, DT_WORDBREAK);
  TextEllips:   array [boolean] of Cardinal = (0, EllipsFlags);
  acMinusPlus:  array [boolean] of integer  = (-1, 1);

  ac_BaseArrowWidth = 5;
  ac_BaseSpacing = 4;

type
  TacIntProperty = 0..MaxInt;
  TacOuterEffectStyle = (oeNone, oeShadow, oeLowered);
  TacOuterVisibility = (ovNone, ovAlways);
  TacGrayedMode = (gmAlways, gmInactive);
  TacSide = (asLeft, asTop, asRight, asBottom);
  TacTabLayout = (tlFirst, tlLast, tlMiddle, tlSingle);

  TsAccessControl = class(TControl) // Will be removed later. Use acntTypes.TacAccessControl
  public
    property AutoSize;
    property ParentColor;
    property Color;
    property ParentFont;
    property PopupMenu;
    property Font;
  end;

{$IFDEF UNICODE}
  ACString = String;
  ACChar   = Char;
  PACChar  = PChar;
{$ELSE} // UNICODE
  {$IFDEF TNTUNICODE}
    ACString = WideString;
    ACChar   = WideChar;
    PACChar  = PWideChar;
  {$ELSE}
    ACString = AnsiString;
    ACChar   = AnsiChar;
    PACChar  = PAnsiChar;
  {$ENDIF}
{$ENDIF} // UNICODE

{$IFDEF DELPHI_XE2}
  ACNativeInt  = NativeInt;
  ACLongInt    = NativeInt;
  ACUInt       = NativeUInt;
  ACNativeUInt = NativeUInt;
{$ELSE}
  ACNativeInt  = LongInt;
  ACLongInt    = LongInt;
  ACUInt       = Cardinal;
  ACNativeUInt = Cardinal;
{$ENDIF}

{$IFNDEF D2007}
  LONG_PTR = Longint;
{$IFDEF BCB}
  {$NODEFINE LONG_PTR}
{$ENDIF}
{$ENDIF}

{$IFNDEF D2005}
  TVerticalAlignment = (taAlignTop, taAlignBottom, taVerticalCenter);
{$ENDIF}

  OldChar  = AnsiChar;
  POldChar = PAnsiChar;

  OldString  = AnsiString;
  POldString = PAnsiString;

  PACString = ^ACString;

  TPaintEvent    = procedure (Sender: TObject; Canvas: TCanvas) of object;
  TBmpPaintEvent = procedure (Sender: TObject; Bmp: Graphics.TBitmap) of object;

  TsSkinName    = string;
  TsDirectory   = string;
  TsSkinSection = string;
  TacStrValue   = string;
  TacRoot  = type string;

  TacAnimType = (atFading, atAero, atDropDown);
  TacAnimTypeCtrl = (atcFade, atcAero, atcBlur, atcBlur2, atcRunup);

  TacBtnEvent = (beMouseEnter, beMouseLeave, beMouseDown, beMouseUp);
  TacBtnEvents = set of TacBtnEvent;

  TacAnimatEvent = (aeMouseEnter, aeMouseLeave, aeMouseDown, aeMouseUp, aeGlobalDef);
  TacAnimatEvents = set of TacAnimatEvent;
  TacImgType = (itisaBorder, itisaTexture, itisaGlyph, itisaGlow, itisaPngGlyph);
  TacFillMode = (fmTiled, fmStretched, fmTiledHorz, fmTiledVert, fmStretchHorzTop, fmStretchVertLeft,
                 fmTileHorBtm, fmTileVertRight, fmStretchHorBtm, fmStretchVertRight,
                 fmDisTiled, fmStretchHorz, fmStretchVert, fmFromBottomToTop, fmReserved1);

  TvaAlign = (vaTop, vaMiddle, vaBottom);
  TacScaleMode = (sm100, sm125, sm150, sm200, smAuto, smOldMode, smVCL, smCustomPPI);


  PacBGInfo = ^TacBGInfo;
  TacBGType = (btUnknown, btFill, btCache, btNotReady); // Returned by control type of BG
  TacBGInfo = record
    Bmp:        Graphics.TBitmap;
    Color:      TColor;    // Color returned if btFill is used
    Offset:     TPoint;    // Offset of bg, used with Cache
    R,                     // Rectangle used if PlsDraw is True
    FillRect:   TRect;     // Rect of part without borders
    BgType:     TacBGType; // btUnknown, btFill, btCache
    PleaseDraw: boolean;   // Parent must fill rectangle(R)
    DrawDC:     hdc;       // Device context for drawing, if PleaseDraw is True
  end;

  TCacheInfo = record
    Bmp:       Graphics.TBitmap;
    X, Y:      integer;
    FillColor: TColor;
    FillRect:  TRect;       // Rect of part without borders
    Ready:     boolean;
  end;

  TacPaintInfo = record
    State,
    FontIndex:   integer;
    R:           TRect;
    SkinManager: TObject;
  end;
  PacPaintInfo = ^TacPaintInfo;
  { Pointer to @link(TPoints)}
  PPoints = ^TPoints;
  { Array of TPoint}
  TPoints = array of TPoint;
  TacIntArray = array of integer;
  { Set of 1..100}
  TPercent = 0..100;
  { Set of controls codes (1..255)}
  TsCodes = set of 1..MaxByte;
{$IFDEF MAKEOBJ}
  TsCharArray = array [1..16] of AnsiChar;
{$ENDIF}
  { Shapes of the shadows (ssRectangle, ssEllipse).}
  TsShadowingShape = (ssRectangle, ssEllipse);
  { Set of window_show types}
  TsWindowShowMode = (soHide, soNormal, soShowMinimized, soMaximize, soShowNoActivate, soShow, soMinimize, soShowMinNoActive, soShowNA, soRestore, soDefault);

  TsColor = packed record
    case integer of
      0: (C: TColor);
      1: (R, G, B, A: Byte);
      2: (I: integer);
    end;

  TsColor_RGB = packed record
    case integer of
      0: (Col: TColor);
      1: (Red, Green, Blue, Alpha: Byte);
      2: (Intg: integer);
    end;

  TsColor_D = packed record // Bytes inverted (for fast calcs)
    case integer of
      0: (DC: TColor);
      1: (DB, DG, DR, DA: Byte);
      2: (DI: integer);
    end;

  TsColor_S = packed record // Bytes inverted
    case integer of
      0: (SC: TColor);
      1: (SB, SG, SR, SA: Byte);
      2: (SI: integer);
    end;

  TsColor_M = packed record // Bytes inverted
    case integer of
      0: (MC: TColor);
      1: (MB, MG, MR, MA: Byte);
      2: (MI: integer);
    end;

  TsColor_ = packed record // Bytes inverted
    case integer of
      0: (C: TColor);
      1: (B, G, R, A: Byte);
      2: (I: integer);
    end;

  TsColor_RGB_ = packed record // Bytes inverted
    case integer of
      0: (Col: TColor);
      1: (Blue, Green, Red, Alpha: Byte);
      2: (Intg: integer);
    end;

  PRGBAArray = ^TRGBAArray;
  TRGBAArray = packed array[0..10000] of TsColor;

  PRGBAArray_ = ^TRGBAArray_;
  TRGBAArray_ = packed array[0..10000] of TsColor_;

  PRGBAArray_D = ^TRGBAArray_D;
  TRGBAArray_D = packed array[0..10000] of TsColor_D;

  PRGBAArray_S = ^TRGBAArray_S;
  TRGBAArray_S = packed array[0..10000] of TsColor_S;

  PRGBAArray_M = ^TRGBAArray_M;
  TRGBAArray_M = packed array[0..10000] of TsColor_M;


  TsDisabledGlyphKind = set of (dgBlended, dgGrayed);
  TsDisabledKind = set of (dkBlended, dkGrayed);
  PsDisabledKind = ^TsDisabledKind;

  TsGradPoint = packed record
    Index: word;
    Mode: integer;
    Color: TsColor;
    Percent: TPercent;
  end;

  TsGradArray = packed array of TsGradPoint;


const
  NCS_DROPSHADOW = $20000;
{$IFNDEF D2010}
//{$IFNDEF DELPHI_XE3}
  BS_SPLITBUTTON    = 12;
  BS_DEFSPLITBUTTON = 13;
  BS_COMMANDLINK    = 14;
  BS_DEFCOMMANDLINK = 15;
{$ENDIF}

  EmptyCI: TCacheInfo = (Bmp: nil; X: -99; Y: -99; FillColor: clFuchsia; Ready: False);
  sFuchsia: TsColor = (C: $FF00FF); // Transparent color
  sTabPositions: array [TTabPosition] of string = ('', 'BOTTOM', 'LEFT', 'RIGHT');
  acMaxScaleNdx = 3;
  aScalePercents: array [0..acMaxScaleNdx] of integer = (100, 125, 150, 200);
  aPPIArray:      array [0..acMaxScaleNdx] of integer = (96, 120, 144, 192);
  aSfxs:          array [0..acMaxScaleNdx] of string = ('', '*125', '*150', '*200');

  s_RegName        = 'AlphaSkins';
  s_IntSkinsPath   = 'IntSkinsPath';
  s_WinControlForm = 'TWinControlForm';
  s_NoFocusProp    = 'ACNOFOCUS';
  s_acScale        = 'ACSCALE';
  s_MainFont       = 'MainFont';
  s_FontCount      = 'FontCount';
  s_FontName       = 'FontName';
  s_FontFile       = 'FontFile';

  s_Arial          = 'Arial';
  s_MSSansSerif    = 'MS Sans Serif';
  s_Webdings       = 'Webdings';
  s_Marlett        = 'Marlett';
  s_FontAwesome    = 'FontAwesome';

{$IFNDEF DISABLEPREVIEWMODE} // Used with ASkinEditor
  s_PreviewKey     = '/acpreview';         //
  s_EditorCapt     = 'AlphaSkins Editor';  //
  ASE_CLOSE  = 1;                          //
  ASE_UPDATE = 2;                          //
  ASE_HELLO  = 3;                          //
  ASE_ALIVE  = 4; // Must return 1         //
  ASE_MSG    = $A06A + 918; // $A400;      //
{$ENDIF}

  MasterBmpName  = 'Master.bmp';
  OptionsDatName = 'Options.dat';
  acSkinExt      = 'asz';
  acPngExt       = 'png';
  acIcoExt       = 'ico';

  s_MinusOne     = '-1';
  s_TrueStr      = 'TRUE';
  s_NewFolder    = 'New folder';             // Name for new created folder in the PathDialog
  s_SkinSelectItemName = 'SkinSelectItem';   // "Available skins" Menu item
  s_SkinData     = 'SkinData';
  s_Slash        = Char('\');
  s_Space        = Char(' ');
  s_Comma        = Char(',');
  s_Dot          = Char('.');
  s_0D0A         = #13#10;
  s_Ellipsis     = '...';
  s_Yy           = 'Yy';

  ac_MaxPropsIndex = 2;                      // Max amount of states for drawing (normal and hot)
  NOCHILDRENPRINT = -2;

  // Borders draw modes
  BDM_STRETCH    = 1;
  BDM_ACTIVEONLY = 2;
  BDM_FILL       = 4;
  BDM_NOSCALE    = 8;
  BDM_ALPHA      = 16;

  HTSB_LEFT_BUTTON   = 100;
  HTSB_RIGHT_BUTTON  = 101;
  HTSB_TOP_BUTTON    = 102;
  HTSB_BOTTOM_BUTTON = 103;
  HTSB_H_SCROLL      = 104;
  HTSB_HB_SCROLL     = 105;
  HTSB_V_SCROLL      = 106;
  HTSB_VB_SCROLL     = 107;

  { WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes for MDI form}
  HTCHILDCLOSE       = 101;
  HTCHILDMAX         = 102;
  HTCHILDMIN         = 103;

  acCloseBtnSize = 15;

  acMultipNormal  = 3;
  acMaxIterations = 6 {$IFDEF ACDEBUG} * 1 { Changing of animaton speed for tests } {$ENDIF};
  acTimerInterval = 12;

  acImgTypes:  array [0..4]  of TacImgType = (itisaBorder, itisaTexture, itisaGlyph, itisaGlow, itisaPngGlyph);
  acFillModes: array [0..14] of TacFillMode = (fmTiled, fmStretched, fmTiledHorz, fmTiledVert, fmStretchHorzTop,
    fmStretchVertLeft, fmTileHorBtm, fmTileVertRight, fmStretchHorBtm, fmStretchVertRight, fmDisTiled,
    fmStretchHorz, fmStretchVert, fmFromBottomToTop, fmReserved1
  );
  acBtnEvents: array [TacAnimatEvent] of TacBtnEvent = (beMouseEnter, beMouseLeave, beMouseDown, beMouseUp, beMouseUp);

  COC_TsCustom           = 1;

  COC_TsSpinEdit         = 2;
  COC_TsEdit             = 3;
  COC_TsMemo             = 7;
  COC_TsListBox          = 8;

  COC_TsColorBox         = 9;
  COC_TsListView         = 10;
  COC_TsCurrencyEdit     = 12;
  COC_TsComboBox         = 13;
  COC_TsTreeView         = 14;

  COC_TsComboBoxEx       = 18;

  COC_TsFrameBar         = 19;
  COC_TsBarTitle         = 20;
  COC_TsCheckBox         = 32;
  COC_TsDBCheckBox       = 32;
  COC_TsRadioButton      = 33;
  COC_TsSlider           = 34;

  COC_TsImage            = 50;
  COC_TsPanel            = 51;
  COC_TsCoolBar          = 53;
  COC_TsToolBar          = 54;
  COC_TsDragBar          = 56;
  COC_TsTabSheet         = 57;
  COC_TsScrollBox        = 58;
  COC_TsMonthCalendar    = 59;
  COC_TsGroupBox         = 74;
  COC_TsSplitter         = 75;
  // DB-aware controls
  COC_TsDBEdit           = 76;
  COC_TsDBMemo           = 78;
  COC_TsDBComboBox       = 81;
  COC_TsDBLookupComboBox = 82;
  COC_TsDBListBox        = 83;
  COC_TsDBLookupListBox  = 84;
  COC_TsDBGrid           = 85;
  // -------------- >>
  COC_TsSpeedButton      = 92;
  COC_TsButton           = 93;
  COC_TsBitBtn           = 94;

  COC_TsNavButton        = 98;
  COC_TsBevel            = 110;

  COC_TsFileDirEdit      = 132;
  COC_TsFilenameEdit     = 133;
  COC_TsDirectoryEdit    = 134;
  COC_TsCustomDateEdit   = 137;
  COC_TsComboEdit        = 138;
  COC_TsDateEdit         = 140;

  COC_TsPageControl      = 141;
  COC_TsScrollBar        = 142;
  COC_TsTabControl       = 143;
  COC_TsStatusBar        = 151;
  COC_TsHeaderControl    = 152;
  COC_TsGauge            = 161;
  COC_TsTrackBar         = 165;

  COC_TsSkinProvider     = 224;
  COC_TsMDIForm          = 225;
  COC_TsFrameAdapter     = 226;
  COC_TsCircleControl    = 227;

  COC_TsAdapter          = 230;
  COC_TsAdapterEdit      = 231;

  COC_Unknown            = 250;

  // Codes of components, who don't catch mouse events
  sForbidMouse: TsCodes = [COC_TsFrameBar, COC_TsPanel..COC_TsGroupBox, COC_TsBevel, COC_TsPageControl..COC_TsGauge];
  sNoHotEdits : TsCodes = [COC_TsSpinEdit..COC_TsComboBoxEx, COC_TsDBEdit..COC_TsDBGrid, COC_TsFileDirEdit..COC_TsDateEdit, COC_TsAdapterEdit];

  // Contols that can have one state only
  ssCanNotBeHot: TsCodes = [COC_TsPanel, COC_TsToolBar, COC_TsDragBar, COC_TsTabSheet,
                           COC_TsScrollBox, COC_TsMonthCalendar,
                           COC_TsGroupBox, COC_TsBevel, COC_TsPageControl, COC_TsTabControl,
                           COC_TsStatusBar, COC_TsGauge, COC_TsFrameAdapter];

  sEditCtrls:   TsCodes = [COC_TsSpinEdit..COC_TsComboBoxEx, COC_TsCurrencyEdit, COC_TsDBEdit..COC_TsDBLookupListBox,
                           COC_TsTreeView, COC_TsFileDirEdit..COC_TsDateEdit, COC_TsAdapterEdit];

  ssScrolledEdits: TsCodes = [COC_TsMemo, COC_TsListBox, COC_TsListView, COC_TsDBGrid, COC_TsDBMemo, COC_TsDBListBox, COC_TsTreeView, COC_TsAdapterEdit];

  ssButtons: TsCodes       = [COC_TsButton, COC_TsBitBtn, COC_TsSpeedButton];

var
  ExceptTag: integer = $100 {256}; // Bit Mask for the tag value in 3rd-party controls which will not be skinned automatically (Old value is -98)
  acWinVer: integer;
  SysPopupCount: integer = 0;
  sPopupCalendar: TForm;
  acDebugMode: boolean = False;
  acCheckScale: boolean = False;
  acDialogPosIsCenter: boolean = False;

{$IFDEF LOGGED}
  acDebugCount: integer = 0;
{$ENDIF}

{$IFNDEF DISABLEPREVIEWMODE}
  acPreviewHandle: THandle = 0;           //
  acPreviewNeeded: boolean = False;       // Preview mode for SkinEditor
  acSkinPreviewUpdating: boolean = False; //
{$ENDIF}
  acIgnoreMenuOwnerDraw: boolean = False;
  acHtmlStdBreak:        boolean = False;
  acAnimCount:           integer = 0;

  acScrollBtnLength:     integer = 16;
  acArrowSize:           integer = ac_BaseArrowWidth;
  acSpacing:             integer = ac_BaseSpacing;
  acLineWidth:           integer = 2;

  ShowHintStored:  boolean = False;
  FadingForbidden: boolean = False;
  x64woAero:       boolean = False;

  AppShowHint:  boolean;
  TempControl:  pointer = nil;
  fGlobalFlag:  boolean = False;
  acMagnForm:   TWinControl = nil;
  cMenuCaption: char = CharMinus;
  acCurrentScaleMode: TacScaleMode = smVCL;
{$ENDIF} // NOTFORHELP


type
  TsCaptionLayout = (sclLeft, sclTopLeft, sclTopCenter, sclTopRight, sclLeftTop, sclBottomLeft, sclBottomCenter, sclBottomRight, sclRight, sclRightTop, sclLeftLeft, sclRightRight);
{$IFNDEF FPC}
  TDaysOfWeek = set of TCalDayOfWeek;         // Set of days of week
{$ENDIF}
  TDateOrder = (doMDY, doDMY, doYMD);         // Order of date representation - (doMDY, doDMY, doYMD)
  TPopupWindowAlign = (pwaRight, pwaLeft);    // Set of popup window alignes - (pwaRight, pwaLeft)
{$IFNDEF NOTFORHELP}
  TacOptimizingPriority = (opSpeed, opMemory);
{$ENDIF}


var
  // Variables that can change a mode of the package work
  ac_UseSysCharSet:      boolean = True;   // Use system character set in form titles (if False then character set from Form.Font.Charset property will be used)
  ac_KeepOwnFont:        boolean = False;  // If true then fonts will not be changed in standard ot 3rd-party controls
  ac_OldGlyphsMode:      boolean = True;   // Drawing of glyhs in comboedits from old resources

  DrawSkinnedMDIWall:    boolean = True;   // Use skinning for MDI area
  DrawSkinnedMDIScrolls: boolean = True;   // Use skinning for MDI area scrolls

{$IFNDEF NOTFORHELP}
  ac_DialogsLevel:        integer = 2;     // Deep of system dialogs skinning
  ac_ChangeThumbPreviews: boolean = False; // Allow a changing of Aero preview window by AlphaControls (is not ready currently)
  ac_AllowHotEdits:       boolean = False; // Allow to repaint edit controls when hovered by mouse pointer

//  ac_CXSIZEFRAME:  integer = -1;
//  ac_CXFIXEDFRAME: integer = 0;

const
  SC_DRAGMOVE      = $F012;
{$IFDEF DELPHI5}
  WS_EX_LAYERED    = $00080000;
  WS_EX_NOACTIVATE = $08000000;
  WS_EX_LAYOUTRTL  = $00400000;

  ULW_ALPHA        = $00000002;
  AC_SRC_ALPHA     = $01;
  CS_DROPSHADOW    = $20000;
{$ENDIF}
  DefBlend: TBlendFunction = (BlendOp: AC_SRC_OVER; BlendFlags: 0; SourceConstantAlpha: 0; AlphaFormat: AC_SRC_ALPHA);

{$IFDEF RUNIDEONLY}
  sIsRunIDEOnlyMessage = 'Trial version of the AlphaControls package has been used.' + s_0D0A +
                         'For purchasing the fully functional version visit www.alphaskins.com, please.' + s_0D0A +
                         'Thank you!';
{$ENDIF}

var
  // These global string variables will be initialized by values from resource
  // and may be replaced for program localization at any time
  acs_MsgDlgOK             : acString; // "OK"
  acs_MsgDlgCancel         : acString; // "Cancel"
  acs_MsgDlgHelp           : acString; // "Help"

  acs_RestoreStr           : acString; // "Restore"
  acs_MoveStr              : acString; // "Move"
  acs_SizeStr              : acString; // "Size"
  acs_MinimizeStr          : acString; // "Minimize"
  acs_MaximizeStr          : acString; // "Maximize"
  acs_CloseStr             : acString; // "Close"

  acs_Calculator           : acString; // "Calculator"

  acs_FileOpen             : acString; // "File open"

  acs_AvailSkins           : acString; // "Available skins"
  acs_InternalSkin         : acString; // "(internal)"

  acs_InvalidDate          : acString; // "Invalid date"

  acs_ColorDlgAdd          : acString; // "Add to custom colors set"
  acs_ColorDlgDefine       : acString; // "Define colors"
  acs_ColorDlgAddPal       : acString; // "Additional colors :"
  acs_ColorDlgTitle        : acString; // "Color"
  acs_ColorDlgRed          : acString; // "Red :"
  acs_ColorDlgGreen        : acString; // "Green :"
  acs_ColorDlgBlue         : acString; // "Blue :"
  acs_ColorDlgDecimal      : acString; // "Decimal - "
  acs_ColorDlgHex          : acString; // "Hex - "

  // Frame adapter
  acs_FrameAdapterError1   : acString; // "TsFrameAdapter adapter must be placed on the handled frame";

  acs_Font                 : acString; // "Font"
  acs_FontColor            : acString;
  // File dialogs
  acs_Root                 : acString; // "Root:"
  acs_SelectDir            : acString; // "Select directory"
  acs_Create               : acString; // "Create"

  // Select skin dialog
  acs_DirWithSkins         : acString; // "Directory with skins:"
  acs_SelectSkinTitle      : acString; // "Select skin"
  acs_SkinPreview          : acString; // "Skin preview"

procedure InitSysVariables;
{$ENDIF}


implementation

uses
  SysUtils, sStrings;

var
  Lib: HModule = 0;

//_DwmIsCompositionEnabled:       function(out pfEnabled: BOOL): HResult; stdcall;

procedure InitSysVariables;
begin
  if acScrollBtnLength < 0 then begin
    acScrollBtnLength := GetSystemMetrics(SM_CXHSCROLL);
//    ac_CXSIZEFRAME    := GetSystemMetrics(SM_CXSIZEFRAME);
//    ac_CXFIXEDFRAME   := GetSystemMetrics(SM_CXFIXEDFRAME);
  end;
end;


procedure acLoadResStr(var AValue: acString; ALib: HModule; AIdent, DefValue: integer; Suffix: acString = ''); overload;
var
  ResStringRec: TResStringRec;
begin
  if Lib <> 0 then begin
    ResStringRec.Module := {$IFDEF DELPHI5}@acNativeInt(ALib){$ELSE}@ALib{$ENDIF};
    ResStringRec.Identifier := AIdent;
    AValue := LoadResString(@ResStringRec);
    if AValue = '' then begin
      if DefValue <> 0 then
        AValue := LoadStr(DefValue)
    end
    else
      if Suffix <> '' then
        AValue := AValue + Suffix;
  end;
end;


procedure acLoadResStr(var AValue: acString; ALib: HModule; AIdent: integer; DefValue: acString; Suffix: acString = ''); overload;
var
  ResStringRec: TResStringRec;
begin
  if Lib <> 0 then begin
    ResStringRec.Module := {$IFDEF DELPHI5}@acNativeInt(ALib){$ELSE}@ALib{$ENDIF};
    ResStringRec.Identifier := AIdent;
    AValue := LoadResString(@ResStringRec);
    if AValue = '' then begin
      if DefValue <> '' then
        AValue := DefValue
    end
    else
      if Suffix <> '' then
        AValue := AValue + Suffix;
  end;
end;


initialization
  if (Win32MajorVersion = 6) and (Win32MinorVersion = 2) or (Win32MajorVersion > 6) then
    acWinVer := 8
  else
    acWinVer := Win32MajorVersion;

  InitSysVariables;

  Lib := LoadLibrary(user32);
  acLoadResStr(acs_MsgDlgOK,       Lib, 800, s_MsgDlgOK);
  acLoadResStr(acs_MsgDlgCancel,   Lib, 801, s_MsgDlgCancel);
  acLoadResStr(acs_MsgDlgHelp,     Lib, 808, s_MsgDlgHelp);
  acLoadResStr(acs_CloseStr,       Lib, 905, s_CloseStr);
  FreeLibrary(Lib);

  Lib := LoadLibrary('colorui.dll');
  acLoadResStr(acs_ColorDlgAdd,    Lib, 1810, s_ColorDlgAdd);
  FreeLibrary(Lib);

  Lib := LoadLibrary('shell32.dll');
  acLoadResStr(acs_ColorDlgDefine,  Lib, 4151,  s_ColorDlgDefine);
  acLoadResStr(acs_ColorDlgAddPal,  Lib, 31153, s_ColorDlgAddPal,  ':');
  acLoadResStr(acs_ColorDlgDecimal, Lib, 16514, s_ColorDlgDecimal, ' - ');
  acLoadResStr(acs_Root,            Lib, 33015, s_Root,            ':');
  acLoadResStr(acs_Create,          Lib, 4151,  s_Create);
  FreeLibrary(Lib);

  Lib := LoadLibrary(comctl32);
  acLoadResStr(acs_RestoreStr,     Lib, 33056, s_RestoreStr);
  acLoadResStr(acs_SizeStr,        Lib, 32768, s_SizeStr);
  acLoadResStr(acs_MoveStr,        Lib, 32784, s_MoveStr);
  acLoadResStr(acs_MaximizeStr,    Lib, 32816, s_MaximizeStr);
  acLoadResStr(acs_MinimizeStr,    Lib, 32800, s_MinimizeStr);
  FreeLibrary(Lib);

  acs_Calculator := 'Calculator';

  Lib := LoadLibrary('comdlg32.dll');
  acLoadResStr(acs_FileOpen,      Lib, 436,  s_FileOpen);
  acLoadResStr(acs_SelectDir,     Lib, 439,  s_SelectDir);
  acLoadResStr(acs_ColorDlgRed,   Lib, 1049, s_ColorDlgRed,   ':');
  acLoadResStr(acs_ColorDlgGreen, Lib, 1042, s_ColorDlgGreen, ':');
  acLoadResStr(acs_ColorDlgBlue,  Lib, 1052, s_ColorDlgBlue,  ':');
  FreeLibrary(Lib);

  Lib := LoadLibrary('compstui.dll');
  acLoadResStr(acs_ColorDlgTitle,    Lib, 64744, s_ColorDlgTitle);
  FreeLibrary(Lib);

  acs_ColorDlgHex          := LoadStr(s_ColorDlgHex);

  Lib := LoadLibrary('inetres.dll');
  acLoadResStr(acs_Font,      Lib, 1175, s_Font);
  acLoadResStr(acs_FontColor, Lib, 5273, 'Font color:', ':');
  FreeLibrary(Lib);

  acs_InvalidDate          := LoadStr(s_InvalidDate);
  acs_AvailSkins           := LoadStr(s_AvailSkins);
  acs_InternalSkin         := LoadStr(s_InternalSkin);

  if acs_InvalidDate = '' then
    acs_InvalidDate := 'Invalid date';

  acs_DirWithSkins         := s_DirWithSkins;
  acs_SelectSkinTitle      := s_SelectSkinTitle;
  acs_SkinPreview          := s_SkinPreview;

  // Frame adapter
  acs_FrameAdapterError1   := LoadStr(s_FrameAdapterError1);

finalization

end.




