{
  ThemesSupport
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:NxThemesSupport.pas v1.0 bn
}
{$I NxSuite.inc}
unit NxThemesSupport;

{$HPPEMIT ''}
{$HPPEMIT '#include "uxtheme.h"'}
{$HPPEMIT ''}

interface

uses
  Windows, SysUtils, Graphics, Classes, Controls, NxConsts;

const
  teButton = 'button';
  teComboBox = 'combobox';
  teHeader = 'header';
  teEdit = 'edit';
  teExplorerBar = 'explorerbar';
  teListView = 'listview';
  teTab = 'tab';
  teToolbar = 'toolbar';
  teTrackBar = 'trackbar';
  teTreeView = 'treeview';
  teRebar = 'rebar';
  teScrollBar = 'scrollbar';
  teSpin = 'spin';

  { teTreeView }
  tcExpandingButton = 2;

  { teToolbar }
  tcToolbarButton = 1;

  tcToolbarButtonHover = 2;
  tcToolbarButtonDown = 3;

  { teButton }
  tcCheckBox = 3;
  tcRadioButton = 2;

  { teButton & tcRadioButton }
  tiRadioCheckedDisabled = 8;
  tiRadioCheckedDown = 7;
  tiRadioCheckedHover = 6;
  tiRadioChecked = 5;
  tiRadioDisabled = 4;

  tiCollapsed = 1;
  tiExpanded = 2;

  { teHeader }
  tcHeader = 1;
  tiHeaderNormal = 1;
  tiHeaderHover = 2;
  tiHeaderPasive = 7;

  { teScrollBar }
  tcHorzGrip = 9;

  { teSpin }
  tcSpinUp = 1;
  tcSpinDown = 2;

  { teTab }
  tcTab = 1;
  tcTabPage = 9;

  { tcTab }
  tiTab = 1;
  tiTabActive = 3;

type
  HIMAGELIST = THandle;
  HTHEME = THandle;
  {$EXTERNALSYM HTHEME}

var
  { External DLL's }
  OpenThemeData: function(hwnd: HWND; pszClassList: LPCWSTR): HTHEME; stdcall;
  {$EXTERNALSYM OpenThemeData}
  CloseThemeData: function(hTheme: HTHEME): HRESULT; stdcall;
  {$EXTERNALSYM CloseThemeData}
  DrawThemeBackground: function(hTheme: HTHEME; hdc: HDC; iPartId, iStateId: Integer;
    const Rect: TRect; pClipRect: PRect): HRESULT; stdcall;
  {$EXTERNALSYM DrawThemeBackground}
  DrawThemeEdge: function(hTheme: HTHEME; hdc: HDC; iPartId, iStateId: Integer;
	  const pDestRect: TRect; uEdge, uFlags: UINT; pContentRect: PRECT): HRESULT; stdcall;
  {$EXTERNALSYM DrawThemeEdge}
  GetThemeSysSize: function(hTheme: HTHEME; iSizeId: Integer): Integer; stdcall;
  {$EXTERNALSYM GetThemeSysSize}
  IsThemeActive: function: BOOL; stdcall;
  {$EXTERNALSYM IsThemeActive}
  IsAppThemed: function: BOOL; stdcall;
  {$EXTERNALSYM IsAppThemed}

  function IsStyled: Boolean;
  function IsThemed: Boolean;
  procedure InitThemes;
  procedure ReleaseThemes;
  { Custom procedures }
  procedure ThemeRect(Handle: HWND; DC: HDC; ARect: TRect; Element: PWideChar;
    Category, Item: Integer);

type
  TColorScheme = (csDefault, csBlack, csBlue, csSilver, csBlue2010, csSilver2010, csBlack2010);
  TColorSchemes = csBlack..csBlack2010;

  TColorSchemeElement = (
    seBackgroundGradientStart,
    seBackgroundGradientEnd,
    seBorder,
    seBtnFace,
    seBtnFaceDark,
    seDown,
    seGridHeaderGradientStart,
    seGridHeaderGradientEnd,
    seGroupHeader,
    seHeaderFont,
    seHeaderDivider,
    seHeaderGradientEnd,
    seHeaderGradientStart,
    seHeaderShadow,
    seHighlight,
    seHover,
    seHighlightHoverFore,
    seHighlightDownFore,
    seInactiveDockCaption,
    seMenuHighlight,
    seMenuSelectionBorder,
    seMenuSelectionBorderDown,
    seSplitterGradientStart,
    seSplitterGradientEnd);

  TSchemeColors = array[TColorScheme, TColorSchemeElement] of TColor;

  TNxColorScheme = class(TComponent)
  private
    FColorScheme: TColorSchemes;
    FOnChange: TNotifyEvent;
    procedure SetColorScheme(const Value: TColorSchemes);
  protected
    procedure DoChange; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ColorScheme: TColorSchemes read FColorScheme write SetColorScheme default csBlue;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

var
  ShemeColors: TSchemeColors;
  ColorScheme: TColorSchemes = csBlue;
  ControlsList: TList;

  { Remove AControl from ControlsList } 
  procedure RemoveSchemeNotification(AControl: TControl);

  { Return scheme color based on element } 
  function SchemeColor(Element: TColorSchemeElement; Scheme: TColorScheme = csDefault): TColor; overload;

  { Add AControl into ControlsList (TList) }
  procedure SchemeNotification(AControl: TControl);

implementation

uses
{$IFDEF CUSTOM_STYLES}
  Themes,
{$ENDIF}
  Forms, Math;

const
  dllUxTheme = 'uxtheme.dll';

var
	FDllHandle: THandle;

{ Windows XP/Vista Themes }

procedure InitThemes;
begin
  if FDllHandle = 0 then
  begin
    FDllHandle := LoadLibrary(dllUxTheme);
    if FDllHandle > 0 then
    begin
      CloseThemeData := GetProcAddress(FDllHandle, 'CloseThemeData');
      DrawThemeBackground := GetProcAddress(FDllHandle, 'DrawThemeBackground');
      DrawThemeEdge := GetProcAddress(FDllHandle, 'DrawThemeEdge');
      GetThemeSysSize := GetProcAddress(FDllHandle, 'GetThemeSysSize');
      IsThemeActive := GetProcAddress(FDllHandle, 'IsThemeActive');
      IsAppThemed := GetProcAddress(FDllHandle, 'IsAppThemed');
      OpenThemeData := GetProcAddress(FDllHandle, 'OpenThemeData');
    end;
  end;
end;

function IsThemed: Boolean;
begin
	try
	  Result := (FDllHandle > 0) and IsAppThemed and IsThemeActive;
    { note: uncomment for debug }
//    Result := False;
  except
    raise Exception.Create('Error in Themes');
  end;
end;

function IsStyled: Boolean;
begin
  Result := False;
  {$IFDEF CUSTOM_STYLES}
  Result := StyleServices.Enabled;
  {$ENDIF}
end;

function IsThemesSupported: Boolean;
begin
  Result := (FDllHandle > 0) and IsAppThemed;
end;

procedure ReleaseThemes;
begin
  if FDllHandle <> 0 then
  begin
    FreeLibrary(FDllHandle);
    FDllHandle := 0;
    CloseThemeData := nil;
    DrawThemeBackground := nil;
    DrawThemeEdge := nil;
    GetThemeSysSize := nil;
    IsThemeActive := nil;
    IsAppThemed := nil;
    OpenThemeData := nil;
  end;
end;

procedure ThemeRect(Handle: HWND; DC: HDC; ARect: TRect; Element: PWideChar;
  Category, Item: Integer);
var
  Theme: THandle;
begin
  Theme := OpenThemeData(Handle, Element);
  if Theme <> 0 then
    try
      DrawThemeBackground(Theme, DC, Category, Item, ARect, @ARect);
    finally
      CloseThemeData(Theme);
    end;
end;

{ ColorScheme }

procedure RemoveSchemeNotification(AControl: TControl);
var
  Index: Integer;
begin
  if Assigned(ControlsList) then
  begin
    Index := ControlsList.IndexOf(AControl);
    if InRange(Index, 0, Pred(ControlsList.Count))
      then ControlsList.Delete(Index);
  end;
end;

function SchemeColor(Element: TColorSchemeElement; Scheme: TColorScheme = csDefault): TColor;
begin
  if Scheme = csDefault then Scheme := ColorScheme;
  Result := ShemeColors[Scheme, Element];
end;

procedure SchemeNotification(AControl: TControl);
begin
  if Assigned(ControlsList) then ControlsList.Add(AControl);
end;

{ TNxColorCheme }

constructor TNxColorScheme.Create(AOwner: TComponent);
begin
  inherited;
  FColorScheme := NxThemesSupport.ColorScheme;
end;

procedure TNxColorScheme.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxColorScheme.SetColorScheme(const Value: TColorSchemes);
var
  i: Integer;
  R: TRect;
  AControl: TControl;
begin
  FColorScheme := Value;
  if FColorScheme <> NxThemesSupport.ColorScheme then
  begin
    NxThemesSupport.ColorScheme := FColorScheme;
    DoChange;
  end;
  for i := 0 to Pred(ControlsList.Count) do
  begin
    AControl := ControlsList[i];
    if AControl is TWinControl then
    begin
      R := AControl.ClientRect;
      RedrawWindow(TWinControl(AControl).Handle, @R, 0, RDW_FRAME or RDW_INVALIDATE or RDW_NOCHILDREN);
    end else AControl.Invalidate;
  end;
end;

initialization
  { Blue }
  ShemeColors[csBlue, seBackgroundGradientEnd] := $00CE9266;
  ShemeColors[csBlue, seBorder] := $00CF9365;
  ShemeColors[csBlue, seBtnFace] := $00FFEFE3;
  ShemeColors[csBlue, seBtnFaceDark] := $00F0D9C2; // info panel

  ShemeColors[csBlue, seGridHeaderGradientStart] := $00ffffff;
  ShemeColors[csBlue, seGridHeaderGradientEnd] := $00FFD2AF;

  ShemeColors[csBlue, seGroupHeader] := $00EEE7DD;

  ShemeColors[csBlue, seHeaderDivider] := $00ffc69a;
  ShemeColors[csBlue, seHeaderFont] := $008B4215;
  ShemeColors[csBlue, seHeaderGradientEnd] := $00FFD2AF;
  ShemeColors[csBlue, seHeaderGradientStart] := $00FFEFE3;
  ShemeColors[csBlue, seHeaderShadow] := ShemeColors[csBlue, seBorder];

  ShemeColors[csBlue, seHighlight] := $00c9b0a7;

  ShemeColors[csBlue, seInactiveDockCaption] := $00E9CFB8;

  ShemeColors[csBlue, seMenuHighlight] := $00A2E7FF;
  ShemeColors[csBlue, seMenuSelectionBorder] := $0069BDFF; //info panel hover
  ShemeColors[csBlue, seMenuSelectionBorderDown] := $003C8CFB; //info panel down

  ShemeColors[csBlue, seSplitterGradientStart] := $00FFEFE3;
  ShemeColors[csBlue, seSplitterGradientEnd] := $00FFD6B6;

  { Silver }
  ShemeColors[csSilver, seBackgroundGradientEnd] := $00A69F9B;
  ShemeColors[csSilver, seBorder] := $0074706F;
  ShemeColors[csSilver, seBtnFace] := $00F2F1F0;
  ShemeColors[csSilver, seBtnFaceDark] := $00E1D6D2; // info panel

  ShemeColors[csSilver, seGroupHeader] := $00EBEBEB;

  ShemeColors[csSilver, seGridHeaderGradientStart] := $00ffffff;
  ShemeColors[csSilver, seGridHeaderGradientEnd] := $00E7DFDA;

  ShemeColors[csSilver, seHeaderDivider] := $008f6d6e;
  ShemeColors[csSilver, seHeaderFont] := $008B4215;
  ShemeColors[csSilver, seHeaderGradientEnd] := $00E7DFDA;
  ShemeColors[csSilver, seHeaderGradientStart] := $00F8F7F6;
  ShemeColors[csSilver, seHeaderShadow] := ShemeColors[csSilver, seBorder];

  ShemeColors[csSilver, seHighlight] := $00c9b0a7;

  ShemeColors[csSilver, seInactiveDockCaption] := $00C2B7B2;

  ShemeColors[csSilver, seMenuHighlight] := $00C2EEFF;
  ShemeColors[csSilver, seMenuSelectionBorder] := $006FC0FF; //info panel hover
  ShemeColors[csSilver, seMenuSelectionBorderDown] := $003E80FE; //info panel down

  ShemeColors[csSilver, seSplitterGradientStart] := $00BFA7A8;
  ShemeColors[csSilver, seSplitterGradientEnd] := $00977778;

  { Black }
  ShemeColors[csBlack, seBackgroundGradientEnd] := $000A0A0A;
  ShemeColors[csBlack, seBorder] := $005C534C;
  ShemeColors[csBlack, seBtnFace] := $00F2F1F0;
  ShemeColors[csBlack, seBtnFaceDark] := $00E1D6D2; // info panel

  ShemeColors[csBlack, seDown] := $003C8CFB;

  ShemeColors[csBlack, seGridHeaderGradientStart] := $00ffffff;
  ShemeColors[csBlack, seGridHeaderGradientEnd] := $00C9C2BD;

  ShemeColors[csBlack, seGroupHeader] := $00EBEBEB; // menu groups header

  ShemeColors[csBlack, seHeaderDivider] := $00a49991;
  ShemeColors[csBlack, seHeaderFont] := $00000000;
  ShemeColors[csBlack, seHeaderGradientEnd] := $00C9C2BD;
  ShemeColors[csBlack, seHeaderGradientStart] := $00F2F1F0;
  ShemeColors[csBlack, seHeaderShadow] := $00B6ADA7;

  ShemeColors[csBlack, seHighlight] := $00c9b0a7;

  ShemeColors[csBlack, seInactiveDockCaption] := $00A0A09E;

  ShemeColors[csBlack, seMenuHighlight] := $00A2E7FF;
  ShemeColors[csBlack, seMenuSelectionBorder] := $0069BDFF; //info panel hover
  ShemeColors[csBlack, seMenuSelectionBorderDown] := $003C8CFB; //info panel down

  ShemeColors[csBlack, seSplitterGradientStart] := $00F2F1F0;
  ShemeColors[csBlack, seSplitterGradientEnd] := $00CEC8C4;

  { Blue 2010 }
  ShemeColors[csBlue2010, seBackgroundGradientEnd] := $00CE9266;
  ShemeColors[csBlue2010, seBorder] := $00bd9d84;
  ShemeColors[csBlue2010, seBtnFace] := $00e5d0bf;
  ShemeColors[csBlue2010, seBtnFaceDark] := $00F0D9C2; // info panel

  ShemeColors[csBlue2010, seGridHeaderGradientStart] := $00fbf5ef;
  ShemeColors[csBlue2010, seGridHeaderGradientEnd] := $00faece1;

  ShemeColors[csBlue2010, seGroupHeader] := $00f5f2f0;

  ShemeColors[csBlue2010, seHeaderDivider] := $00bd9d84;
  ShemeColors[csBlue2010, seHeaderFont] := $008B4215;
  ShemeColors[csBlue2010, seHeaderGradientEnd] := $00E7DFDA;
  ShemeColors[csBlue2010, seHeaderGradientStart] := $00F8F7F6;
  ShemeColors[csBlue2010, seHeaderShadow] := ShemeColors[csBlue2010, seBorder];

  ShemeColors[csBlue2010, seHighlight] := $00f0cda7;

  ShemeColors[csBlue2010, seInactiveDockCaption] := $00C2B7B2;

  ShemeColors[csBlue2010, seMenuHighlight] := $00C2EEFF;
  ShemeColors[csBlue2010, seMenuSelectionBorder] := $006FC0FF; //info panel hover
  ShemeColors[csBlue2010, seMenuSelectionBorderDown] := $003E80FE; //info panel down

  ShemeColors[csBlue2010, seSplitterGradientStart] := $00BFA7A8;
  ShemeColors[csBlue2010, seSplitterGradientEnd] := $00977778;

  { Silver 2010 }
  ShemeColors[csSilver2010, seBackgroundGradientEnd] := $00A69F9B;
  ShemeColors[csSilver2010, seBorder] := $00b5aca5;
  ShemeColors[csSilver2010, seBtnFace] := $00e0dbd6;
  ShemeColors[csSilver2010, seBtnFaceDark] := $00E1D6D2; // info panel

  ShemeColors[csSilver2010, seGridHeaderGradientStart] := $00f9f7f5;
  ShemeColors[csSilver2010, seGridHeaderGradientEnd] := $00f6f2ef;

  ShemeColors[csSilver2010, seGroupHeader] := $00EBEBEB;

  ShemeColors[csSilver2010, seHeaderDivider] := $00b5aca5;
  ShemeColors[csSilver2010, seHeaderFont] := $008B4215;
  ShemeColors[csSilver2010, seHeaderGradientEnd] := $00E7DFDA;
  ShemeColors[csSilver2010, seHeaderGradientStart] := $00F8F7F6;
  ShemeColors[csSilver2010, seHeaderShadow] := ShemeColors[csSilver2010, seBorder];

  ShemeColors[csSilver2010, seHighlight] := $00f0cda7;

  ShemeColors[csSilver2010, seInactiveDockCaption] := $00C2B7B2;

  ShemeColors[csSilver2010, seMenuHighlight] := $00C2EEFF;
  ShemeColors[csSilver2010, seMenuSelectionBorder] := $006FC0FF; //info panel hover
  ShemeColors[csSilver2010, seMenuSelectionBorderDown] := $003E80FE; //info panel down

  ShemeColors[csSilver2010, seSplitterGradientStart] := $00BFA7A8;
  ShemeColors[csSilver2010, seSplitterGradientEnd] := $00977778;

  { Black 2010 }
  ShemeColors[csBlack2010, seBackgroundGradientEnd] := $00A69F9B;
  ShemeColors[csBlack2010, seBorder] := $003b3b3b;
  ShemeColors[csBlack2010, seBtnFace] := $00858585;
  ShemeColors[csBlack2010, seBtnFaceDark] := $00E1D6D2; // info panel

  ShemeColors[csBlack2010, seGridHeaderGradientStart] := $00f9f7f5;
  ShemeColors[csBlack2010, seGridHeaderGradientEnd] := $00f6f2ef;

  ShemeColors[csBlack2010, seGroupHeader] := $00f5f2f0;

  ShemeColors[csBlack2010, seHeaderDivider] := $00b5aca5;
  ShemeColors[csBlack2010, seHeaderFont] := $008B4215;
  ShemeColors[csBlack2010, seHeaderGradientEnd] := $00E7DFDA;
  ShemeColors[csBlack2010, seHeaderGradientStart] := $00F8F7F6;
  ShemeColors[csBlack2010, seHeaderShadow] := ShemeColors[csBlack2010, seBorder];

  ShemeColors[csBlack2010, seHighlight] := $00f0cda7;

  ShemeColors[csBlack2010, seInactiveDockCaption] := $00C2B7B2;

  ShemeColors[csBlack2010, seMenuHighlight] := $00C2EEFF;
  ShemeColors[csBlack2010, seMenuSelectionBorder] := $006FC0FF; //info panel hover
  ShemeColors[csBlack2010, seMenuSelectionBorderDown] := $003E80FE; //info panel down

  ShemeColors[csBlack2010, seSplitterGradientStart] := $00BFA7A8;
  ShemeColors[csBlack2010, seSplitterGradientEnd] := $00977778;

  InitThemes;

  ControlsList := TList.Create;

finalization
  FreeAndNil(ControlsList);

end.



