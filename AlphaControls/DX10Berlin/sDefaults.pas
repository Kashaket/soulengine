unit sDefaults;
{$i sDefs.inc}

interface

uses
  Forms, Windows,
  {$IFNDEF FPC}ComCtrls, {$ENDIF}
  sConst;


{$IFNDEF NOTFORHELP}
type // Do not change types
  TacThirdPartyTypes = (tpEdit, tpButton, tpBitBtn, tpCheckBox, tpComboBox, tpGrid, tpGroupBox, tpListView,
    tpPanel, tpTreeView, tpwwEdit, tpGridEh, tpVirtualTree, tpPageControl, tpTabControl, tpToolBar,
    tpStatusBar, tpSpeedButton, tpScrollControl, tpUpDownBtn, {$IFDEF ADDWEBBROWSER} tpWebBrowser, {$ENDIF}
    tpScrollBar, tpStaticText, tpNativePaint);


const
  acLastSupportedType = tpNativePaint; // Do not change this line

// Names of standard and 3rd-party controls for automatic skinning (may be changed before recompiling of the package)
{$IFNDEF RUNIDEONLY} // Third-party list is empty by definition now because is not used in most projects AC2013
  sl_Third_Edit          = s_Space;
  sl_Third_Panel         = s_Space;
  sl_Third_Button        = 'TButton';
  sl_Third_BitBtn        = s_Space;
  sl_Third_CheckBox      = s_Space;
  sl_Third_GroupBox      = s_Space;
  sl_Third_Grid          = s_Space;
  sl_Third_TreeView      = s_Space;
  sl_Third_ComboBox      = s_Space;
  sl_Third_ListView      = s_Space;
  sl_Third_WWEdit        = s_Space;
  sl_Third_GridEH        = s_Space;
  sl_Third_VirtualTree   = s_Space;
  sl_Third_PageControl   = s_Space;
  sl_Third_TabControl    = s_Space;
  sl_Third_ToolBar       = s_Space;
  sl_Third_StatusBar     = s_Space;
  sl_Third_SpeedButton   = s_Space;
  sl_Third_ScrollControl = s_Space;
  sl_Third_UpDownBtn     = s_Space;
  sl_Third_ScrollBar     = s_Space;
  sl_Third_WebBrowser    = s_Space;
  sl_Third_StaticText    = s_Space;
  sl_Third_NativePaint   = s_Space;
{$ELSE}                            
  sl_Third_Edit =
{$IFDEF TNTUNICODE}
    'TTntEdit'           + s_0D0A +
    'TTntMemo'           + s_0D0A +
    'TTntListBox'        + s_0D0A +
    'TTntCheckListBox'   + s_0D0A +
    'TTntRichEdit'       + s_0D0A +
    'TTntDBEdit'         + s_0D0A +
    'TTntDBMemo'         + s_0D0A +
    'TTntDBRichEdit'     + s_0D0A +
{$ENDIF}
    'TEdit'              + s_0D0A +
    'TMemo'              + s_0D0A +
    'TMaskEdit'          + s_0D0A +
    'TLabeledEdit'       + s_0D0A +
    'THotKey'            + s_0D0A +
    'TListBox'           + s_0D0A +
    'TCheckListBox'      + s_0D0A +
    'TRichEdit'          + s_0D0A +
    'TDateTimePicker';

  sl_Third_Panel =
{$IFDEF TNTUNICODE}
    'TTntPanel'          + s_0D0A +
{$ENDIF}
    'TPanel';

  sl_Third_Button =
{$IFDEF TNTUNICODE}
    'TTntButton'         + s_0D0A +
{$ENDIF}
    'TButton';

  sl_Third_BitBtn =
{$IFDEF USEPNG}
    'TPngBitBtn'         + s_0D0A +
{$ENDIF}
{$IFDEF TNTUNICODE}
    'TTntBitBtn'         + s_0D0A +
{$ENDIF}
    'TBitBtn';

  sl_Third_CheckBox =
{$IFDEF TNTUNICODE}
    'TTntCheckBox'       + s_0D0A +
    'TTntRadioButton'    + s_0D0A +
    'TTntDBCheckBox'     + s_0D0A +
    'TTntDBRadioButton'  + s_0D0A +
    'TTntGroupButton'    + s_0D0A +
{$ENDIF}
    'TCheckBox'          + s_0D0A +
    'TRadioButton'       + s_0D0A +
    'TGroupButton';

  sl_Third_GroupBox =
{$IFDEF TNTUNICODE}
    'TTntGroupBox'       + s_0D0A +
    'TTntRadioGroup'     + s_0D0A +
    'TTntDBRadioGroup'   + s_0D0A +
{$ENDIF}
    'TGroupBox'          + s_0D0A +
    'TRadioGroup';

  sl_Third_Grid =
{$IFDEF TNTUNICODE}
    'TTntStringGrid'     + s_0D0A +
    'TTntDrawGrid'       + s_0D0A +
    'TTntDBGrid'         + s_0D0A +
{$ENDIF}
    'TStringGrid'        + s_0D0A +
    'TDrawGrid';

  sl_Third_TreeView =
{$IFDEF TNTUNICODE}
    'TTntTreeView'       + s_0D0A +
{$ENDIF}
    'TTreeView';

  sl_Third_ComboBox =
{$IFDEF TNTUNICODE}
    'TTntComboBox'       + s_0D0A +
    'TTntDBComboBox'     + s_0D0A +
{$ENDIF}
    'TComboBox'          + s_0D0A +
    'TColorBox';

  sl_Third_ListView =
{$IFDEF TNTUNICODE}
    'TTntListView'       + s_0D0A +
{$ENDIF}
    'TListView';

  sl_Third_WWEdit =
    s_Space;

  sl_Third_GridEH =
    s_Space;

  sl_Third_VirtualTree =
    s_Space;

  sl_Third_PageControl =
    'TPageControl';

  sl_Third_TabControl =
    'TTabControl';

  sl_Third_ToolBar =
    'TToolBar';

  sl_Third_StatusBar =
    'TStatusBar';

  sl_Third_SpeedButton =
{$IFDEF TNTUNICODE}
    'TTntSpeedButton' + s_0D0A +
{$ENDIF}
    'TSpeedButton';

  sl_Third_ScrollControl =
    'TScrollBox';

  sl_Third_UpDownBtn =
    'TUpDown';

  sl_Third_ScrollBar =
    'TScrollBar';

  sl_Third_WebBrowser =
    'TWebBrowser';

  sl_Third_StaticText =
    'TStaticText';

  sl_Third_NativePaint =
    s_Space;
{$ENDIF}

  // Do not change
  acThirdNames: array [0..ord(acLastSupportedType)] of string = (sl_Third_Edit, sl_Third_Button, sl_Third_BitBtn, sl_Third_CheckBox,
    sl_Third_ComboBox, sl_Third_Grid, sl_Third_GroupBox, sl_Third_ListView, sl_Third_Panel, sl_Third_TreeView, sl_Third_wwEdit,
    sl_Third_GridEh, sl_Third_VirtualTree, sl_Third_PageControl, sl_Third_TabControl, sl_Third_ToolBar, sl_Third_StatusBar,
    sl_Third_SpeedButton, sl_Third_ScrollControl, sl_Third_UpDownBtn, {$IFDEF ADDWEBBROWSER} sl_Third_WebBrowser, {$ENDIF} sl_Third_ScrollBar,
    sl_Third_StaticText, sl_Third_NativePaint);

  acThirdCaptions: array [0..ord(acLastSupportedType)] of string = ('Edit', 'Button', 'BitBtn', 'CheckBox', 'ComboBox', 'Grid', 'GroupBox',
    'ListView', 'Panel', 'TreeView', 'wwEdit', 'GridEh', 'VirtualTree', 'PageControl', 'TabControl', 'ToolBar', 'StatusBar', 'SpeedButton',
    'ScrollControl', 'UpDownBtn', {$IFDEF ADDWEBBROWSER}'WebBrowser', {$ENDIF}'ScrollBar', 'StaticText', 'NativePaint');
{$ENDIF}

  // Values which may be changed before package installing:
  // Skins
  DefSkinsDir = 'c:\Skins'; // Default directory with skins
  // Buttons
  DefDisabledKind = [dkBlended]; // [dkBlended, dkGrayed];
  DefDisabledGlyphKind = [];     // [dgBlended, dgGrayed];
  DefBoundLabelParentFont = True;
  DefMakeSkinMenu = False;
  DefButtonMargin = -1;
  // Calendar
{$IFNDEF FPC}
  DefWeekends = [dowSunday];
{$ENDIF}


var
  ACPngFirst: boolean = True;//False;   // If True then ACPng handler have first priority (solves an issue in using of Png in Button.Glyph in design-time)
  DefDisabledBlend: real = 0.4;         // 0..1
  DefBlendDisabled: byte = 100;         // 0..255
  DefDisabledSaturation: integer = -90; // -100..100

implementation

{$IFDEF ACDPIAWARE}
var
  ac_SetProcessDPIAware: function(): BOOL; stdcall;
  huser32: HMODULE = 0;
  
initialization
  huser32 := LoadLibrary(user32);
  if huser32 <> 0 then begin
    ac_SetProcessDPIAware := GetProcAddress(huser32, 'SetProcessDPIAware');
    if Assigned(ac_SetProcessDPIaware) and ((Application.MainForm = nil) or (Application.MainForm.ClassName <> 'TAppBuilder')) {if not in design-time} then
      ac_SetProcessDPIaware;

    FreeLibrary(huser32);
  end;

finalization
{$ENDIF}

end.
