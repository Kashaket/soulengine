{ NextCollection Suite
  Copyright (C) 2008 by BergSoft
  All rights reserved.

  NxCollection.pas 06/01/2004 7:10:18 bn }

{$R NxCollectionRes.res}
{$R NxExpandPanel.res}
{$I ..\NxSuite.inc}

unit NxCollection;

interface

uses
	Windows, Classes, Messages, Types, Controls, Forms, ExtCtrls, Graphics,
  ComCtrls, Dialogs, SysUtils, ShellApi, StdCtrls, Menus,
  NxClasses, NxConsts, NxStdCtrls, NxThemesSupport, NxSharedCommon, NxSharedDraw, Contnrs, ImgList;

const
  sizCloseButton = 13;
  sizFlipPanelHeaderSize = 18;
  sizHeaderSize = 27;
  sizHeaderBtnHeight = 18;
  sizHeaderBtnWidth = 18;
  spaHeaderBtnMargin = 3;
  sizHeaderCloseButton = 18;

  spaToolbarPadding = 18;
  spaImageToText = 2;
  sizButtonMargin = 16;

  { Space between left edge (or glyph) and text }
  spHeadPnlIndent = 9;

  { Space between left edge and glyph }
  spHeadPnlGlyphIndent = 5;

  { Size of header panel when collapsed }
  szHeadCollapsedWidth = 33;

  { Width and height of collapsing button }
  szHeadPnlButtonWidth = 8;
  szHeadPnlButtonHeight = 7;

  { Size between button and edge }
  spHeadPnlMargin = 3;

  { NxAlertWindow closing delay }
  tmCloseDelay = 5000;

  clIconListBorder = $00cccccc;
  clIconListGradientEnd = $00835d45;
  clIconListGradientStart = $0090664c;
  clDarkTeal = $00f8eade;
  clTealShadow = $00f5e7dd;

type
	TTaskbarPosition = (tbBottom, tbLeft, tbTop, tbRight);
  TAlertDirection = (adNone, adUp, adDown);
  TAlertOptions = set of (aoAutoSize, aoCloseButton, aoHtmlText, aoOptionsLink);

  TBackgroundStyle = (btAuto, btSolid, btCustom);
  TFlipKind = (fkNone, fkButton, fkHeaderAndButton);
	THeaderStyle = (hsAuto, hsFadeAway, hsGradient, hsInverseGradient,
    hsOffice2007, hsSolid, hsTopGradient, hsTransparent, hsVista, hsWindowsLive);
  TFlipBackgroundStyle = (bsSolid, bsVertGradient, bsTransparent);
  TDisplayStyle = (dsNormal, dsHeaderOnly, dsPanelOnly);

  TPopupLocation = (plLeft, plRight);
  TGlyphPosition = (gpLeft, gpLeftTop, gpTop);

  TCustomDrawEvent = procedure (Sender: TObject; DrawRect: TRect) of object;

  TNxIndent = class(TPersistent)
  private
    FLeft: Integer;
    FTop: Integer;
    FOnChange: TNotifyEvent;
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
	protected
  	procedure DoChange; dynamic;
  public
  	constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Left: Integer read FLeft write SetLeft default 0;
    property Top: Integer read FTop write SetTop default 0;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

	TNxMargins = class(TNxIndent)
  private
    FBottom: Integer;
    FRight: Integer;
    procedure SetBottom(const Value: Integer);
    procedure SetRight(const Value: Integer);
  public
    function AsRect(Width, Height: Integer): TRect;
    procedure Assign(Source: TPersistent); override;
  	constructor Create; override;
    procedure SetRect(ALeft, ATop, ARight, ABottom: Integer);
  published
  	property Bottom: Integer read FBottom write SetBottom default 0;
  	property Right: Integer read FRight write SetRight default 0;
  end;

  TNxCollectionControl = class(TCustomControl)
  public
  	constructor Create(AOwner: TComponent); override;
  published
    {$IFDEF DELPHI2010UP}
    property Touch;
    property OnGesture;
    {$ENDIF}
  end;

  TMessageBeepSound = (msNone, msIconExclamation, msIconHand, msOk,
    msIconQuestion, msIconAsterisk);

	TNxAlertWindow = class(TCustomControl)
  private
    FAdaptiveColors: Boolean;
  	FAlertDirection: TAlertDirection;
    FAlignment: TAlignment;
    FAutoResizing: Boolean;
    FBackgroundStyle: TBackgroundStyle;
    FCaption: WideString;
    FCloseButtonState: TButtonState;
    FCloseDelay: Integer;
    FCloseGlyph: TNxActiveGlyphSettings;
    FDelayTimer: TTimer;
    FFixedHeight: Integer;
    FForegroundColor: TColor;
    FFullOpen: Boolean;
    FGlyphPosition: TGlyphPosition;
    FHeaderFont: TFont;
    FHeaderSize: Integer;
    FIndent: Integer;
    FInProgress: Boolean;
    FLargeGlyph: TNxGlyphSettings;
    FOnClose: TNotifyEvent;
    FOnCloseClick: TNotifyEvent;
    FOnCustomDrawHeader: TCustomDrawEvent;
    FOnCustomDrawMessage: TCustomDrawEvent;
    FOnOptionsClick: TNotifyEvent;
    FOnPopup: TNotifyEvent;
    FOptions: TAlertOptions;
    FOptionsText: string;
    FPopupLocation: TPopupLocation;
    FPopupSound: TMessageBeepSound;
    FPopupTimer: TTimer;
    FPreparing: Boolean;
    FRealHeight: Integer;
    FSmallGlyph: TNxGlyphSettings;
    FText: WideString;
    FTextMargins: TNxMargins;
    FVerticalAlignment: TVerticalAlignment;
    FWordWrap: Boolean;
    FOnLinkClick: TNxHtmlClickEvent;
    FOnClosing: TNotifyEvent;
    function FindTaskbar(var ARect: TRect): Integer;
    function GetHeaderRect: TRect;
    function GetPopupLeft: Integer;
    function GetTextRect: TRect;
    procedure SetAdaptiveColors(const Value: Boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetBackgroundStyle(const Value: TBackgroundStyle);
    procedure SetCaption(const Value: WideString);
    procedure SetCloseButtonState(const Value: TButtonState);
    procedure SetCloseDelay(const Value: Integer);
    procedure SetCloseGlyph(const Value: TNxActiveGlyphSettings);
    procedure SetForegroundColor(const Value: TColor);
    procedure SetGlyphPosition(const Value: TGlyphPosition);
    procedure SetHeaderFont(const Value: TFont);
    procedure SetHeaderSize(const Value: Integer);
    procedure SetLargeGlyph(const Value: TNxGlyphSettings);
    procedure SetOptions(const Value: TAlertOptions);
    procedure SetOptionsText(const Value: string);
    procedure SetSmallGlyph(const Value: TNxGlyphSettings);
    procedure SetText(const Value: WideString);
    procedure SetTextMargins(const Value: TNxMargins);
    procedure SetVerticalAlignment(const Value: TVerticalAlignment);
    procedure SetWordWrap(const Value: Boolean);
  protected
    procedure AdjustSize;
    function GetCloseButtonRect: TRect; virtual;
    function GetFillColor: TColor;
    function GetOptionsTextRect: TRect; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoDelayTimer(Sender: TObject);
    procedure DoPopupTimer(Sender: TObject);
    procedure DoTextMarginsChange(Sender: TObject);
    procedure DrawCloseButton(Rect: TRect); virtual;
    procedure DrawHeader(Rect: TRect); virtual;
    procedure DrawHeaderContent(Rect: TRect); virtual;
    procedure DrawMessage(Rect: TRect); virtual;
    procedure DrawMessageContent(Rect: TRect); virtual;
    procedure DoCloseClick; dynamic;
    procedure DoClose; dynamic;
    procedure DoCustomDrawHeader(DrawRect: TRect); dynamic;
    procedure DoCustomDrawMessage(DrawRect: TRect); dynamic;
    procedure DoGlyphChange(Sender: TObject);
    procedure DoHeaderFontChange(Sender: TObject); dynamic;
    procedure DoLinkClick(Href: WideString); dynamic;
    procedure DoOptionsClick; dynamic;
    procedure DoPopup; dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure RedrawBorder; virtual;
    procedure SetGlyphs; virtual;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Close;
  	procedure Popup; overload;
  	procedure Popup(const Text: WideString; CloseDelay: Integer = 0); overload;
    procedure Popup(const AFormat: string; const Args: array of const); overload;
    property Canvas;
    property AlerDirection: TAlertDirection read FAlertDirection;
    property FixedHeight: Integer read FFixedHeight;
    property FullOpen: Boolean read FFullOpen;
    property InProgress: Boolean read FInProgress;

    { Non-published event Used for NxAlertList }
    property OnClosing: TNotifyEvent read FOnClosing write FOnClosing;
  published
  	property AdaptiveColors: Boolean read FAdaptiveColors write SetAdaptiveColors default True;
  	property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property BackgroundStyle: TBackgroundStyle read FBackgroundStyle write SetBackgroundStyle default btAuto;
    property BiDiMode;
  	property Caption: WideString read FCaption write SetCaption;
    property CloseDelay: Integer read FCloseDelay write SetCloseDelay default tmCloseDelay;
    property CloseGlyph: TNxActiveGlyphSettings read FCloseGlyph write SetCloseGlyph;
    property Color;
    property Font;
    property ForegroundColor: TColor read FForegroundColor write SetForegroundColor;
    property GlyphPosition: TGlyphPosition read FGlyphPosition write SetGlyphPosition default gpLeft;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
  	property HeaderSize: Integer read FHeaderSize write SetHeaderSize default 22;
  	property LargeGlyph: TNxGlyphSettings read FLargeGlyph write SetLargeGlyph;
    property Options: TAlertOptions read FOptions write SetOptions default [aoCloseButton, aoOptionsLink];
    property OptionsText: string read FOptionsText write SetOptionsText;
    property ParentColor default False;
    property ParentFont;
    property PopupLocation: TPopupLocation read FPopupLocation write FPopupLocation default plRight;
    property PopupSound: TMessageBeepSound read FPopupSound write FPopupSound default msNone;
  	property SmallGlyph: TNxGlyphSettings read FSmallGlyph write SetSmallGlyph;
    property Text: WideString read FText write SetText;
    property TextMargins: TNxMargins read FTextMargins write SetTextMargins;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write SetVerticalAlignment default taVerticalCenter;
		property WordWrap: Boolean read FWordWrap write SetWordWrap default False;

    property OnClick;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnCloseClick: TNotifyEvent read FOnCloseClick write FOnCloseClick;
    property OnContextPopup;
    property OnCustomDrawHeader: TCustomDrawEvent read FOnCustomDrawHeader write FOnCustomDrawHeader;
    property OnCustomDrawMessage: TCustomDrawEvent read FOnCustomDrawMessage write FOnCustomDrawMessage;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnLinkClick: TNxHtmlClickEvent read FOnLinkClick write FOnLinkClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnOptionsClick: TNotifyEvent read FOnOptionsClick write FOnOptionsClick;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxAlertList = class(TComponent)
  private
    FAlerts: TList;
    FAutoRelease: Boolean;
    FAutoRemove: Boolean;
    function GetAlert(const Index: Integer): TNxAlertWindow;
    procedure SetAlert(const Index: Integer; const Value: TNxAlertWindow);
  protected
    procedure DoAlertClosing(Sender: TObject); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(Alert: TNxAlertWindow; AutoPopup: Boolean = False); overload;
    function Add(ACaption, AText: WideString; AutoPopup: Boolean = False): TNxAlertWindow; overload;
    procedure AddCopy(Alert: TNxAlertWindow; AutoPopup: Boolean = False);
    function IndexOf(Alert: TNxAlertWindow): Integer;
    procedure Clear;
    procedure Remove(Alert: TNxAlertWindow);
    property Alert[const Index: Integer]: TNxAlertWindow read GetAlert write SetAlert; default;
  published
    property AutoRelease: Boolean read FAutoRelease write FAutoRelease default True;
    property AutoRemove: Boolean read FAutoRemove write FAutoRemove default True;
  end;

	TNxFlipContainer = class(TScrollingWinControl)
	private
    FBorderStyle: TBorderStyle;
    procedure SetBorderStyle(const Value: TBorderStyle);
	protected
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure RedrawBorder;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
	public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CollapseAll;
    procedure ExpandAll;
	published
  	property Align;
    property Anchors;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    property Color;
    property Constraints;
  	property Font;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabStop;
    property Visible;
    
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

	TNxFlipPanel = class(TNxCollectionControl)
  private
    FAdaptiveColors: Boolean;
    FAllowFlip: Boolean;
    FAutoCollapse: Boolean;
    FBackgroundColor: TColor;
    FBackgroundStyle: TFlipBackgroundStyle;
    FBorderColor: TColor;
    FCaption: WideString;
    FCollapseGlyph: TBitmap;
    FColorScheme: TColorScheme;
    FDrawDirection: TDirection;
    FExpanded: Boolean;
    FExpandGlyph: TBitmap;
    FExpanding: Boolean;
    FFlipKind: TFlipKind;
    FFullHeight: Integer;
    FGlyph: TBitmap;
    FHeaderColor: TColor;
    FHeaderFont: TFont;
    FHeaderFontUpdating: Boolean;
    FHeaderHeight: Integer;
    FHeaderStyle: THeaderStyle;
    FIndent: Integer;
    FInnerMargins: TNxMargins;
    FMouseDown: Boolean;
    FOldX: Integer;
    FOldY: Integer;
    FOnChange: TNotifyEvent;
    FParentHeaderFont: Boolean;
    FShowButtons: Boolean;
    FShowGlyph: Boolean;
    FTransparentButtons: Boolean;
    FTransparentGlyph: Boolean;
    FCaptionCollapsed: WideString;
    function GetBodyRect: TRect;
  	function GetButtonRect: TRect;
  	function GetHeaderRect: TRect;
    procedure CollapsePanels;
    procedure ResizeParentFlip(Delta: Integer);
    procedure SetAdaptiveColors(const Value: Boolean);
    procedure SetAutoCollapse(const Value: Boolean);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetBackgroundStyle(const Value: TFlipBackgroundStyle);
    procedure SetCaption(const Value: WideString);
    procedure SetCollapseGlyph(const Value: TBitmap);
    procedure SetColorScheme(const Value: TColorScheme);
    procedure SetDrawDirection(const Value: TDirection);
    procedure SetExpanded(const Value: Boolean);
    procedure SetExpandGlyph(const Value: TBitmap);
    procedure SetFlipKind(const Value: TFlipKind);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetHeaderColor(const Value: TColor);
    procedure SetHeaderFont(const Value: TFont);
    procedure SetHeaderHeight(const Value: Integer);
    procedure SetHeaderStyle(const Value: THeaderStyle);
    procedure SetIndent(const Value: Integer);
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetParentHeaderFont(const Value: Boolean);
    procedure SetShowButtons(const Value: Boolean);
    procedure SetShowGlyph(const Value: Boolean);
    procedure SetTransparentButtons(const Value: Boolean);
    procedure SetTransparentGlyph(const Value: Boolean);
    procedure SetBorderColor(const Value: TColor);
    procedure SetCaptionCollapsed(const Value: WideString);
	protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure ChangeScale(M, D: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoChange; dynamic;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoHeaderFontChange(Sender: TObject); dynamic;
    procedure DoInnerMarginsChange(Sender: TObject);
    procedure DoBitmapsChange(Sender: TObject);
  	procedure DrawPlusButton(X, Y: Integer);
    procedure PaintBackground; virtual;
    procedure PaintHeader; virtual;
    procedure Paint; override;
    procedure ReadFullHeight(Reader: TReader);
    procedure RedrawBorder; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WriteFullHeight(Writer: TWriter);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
	public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CollapseAll;
    procedure ExpandAll;
    procedure Flip;
    procedure RefreshBody;
    property FullHeight: Integer read FFullHeight write FFullHeight;
  published
  	property AdaptiveColors: Boolean read FAdaptiveColors write SetAdaptiveColors default True;
  	property Align;
    property AllowFlip: Boolean read FAllowFlip write FAllowFlip default True;
    property Anchors;
    property AutoCollapse: Boolean read FAutoCollapse write SetAutoCollapse default False;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clBtnFace;
    property BackgroundStyle: TFlipBackgroundStyle read FBackgroundStyle write SetBackgroundStyle default bsSolid;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBlack;
    property BorderWidth default 0;
    property Caption: WideString read FCaption write SetCaption;
    property CaptionCollapsed: WideString read FCaptionCollapsed write SetCaptionCollapsed;
		property CollapseGlyph: TBitmap read FCollapseGlyph write SetCollapseGlyph;
    property Color;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csDefault;
    property Constraints;
    property DrawDirection: TDirection read FDrawDirection write SetDrawDirection default diLeftToRight;
  	property Expanded: Boolean read FExpanded write SetExpanded default True;
    property ExpandGlyph: TBitmap read FExpandGlyph write SetExpandGlyph;
    property FlipKind: TFlipKind read FFlipKind write SetFlipKind default fkHeaderAndButton;
  	property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clBtnFace;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default sizFlipPanelHeaderSize;
    property HeaderStyle: THeaderStyle read FHeaderStyle write SetHeaderStyle default hsSolid;
    property Height default 200;
    property Indent: Integer read FIndent write SetIndent default 4;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property ParentColor default False;
    property ParentFont;
    property ParentHeaderFont: Boolean read FParentHeaderFont write SetParentHeaderFont default True;
    property ParentShowHint;
    property PopupMenu;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property ShowGlyph: Boolean read FShowGlyph write SetShowGlyph default True;
    property ShowHint;
    property TabStop;
    property TransparentGlyph: Boolean read FTransparentGlyph write SetTransparentGlyph default False;
    property TransparentButtons: Boolean read FTransparentButtons write SetTransparentButtons default False;
    property Visible;
    property Width default 200;

    property OnClick;
    property OnContextPopup;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxFlipBox = class(TNxFlipPanel)
  end;

  TMargins = class(TPersistent) 
  private 
    FHorizontal: Integer;
    FOnUpdate: TNotifyEvent;
    FVertical: Integer;
    procedure SetHorizontal(const Value: Integer);
    procedure SetOnUpdate(const Value: TNotifyEvent);
    procedure SetVertical(const Value: Integer);
  public
    constructor Create;
  published
    property Horizontal: Integer read FHorizontal write SetHorizontal;
    property Vertical: Integer read FVertical write SetVertical;
    property OnUpdate: TNotifyEvent read FOnUpdate write SetOnUpdate;
  end;

  THorizontalPosition = (hpLeft, hpCenter, hpRight);
  TVerticalPosition = (vpTop, vpMiddle, vpBottom);

  TNxLabel = class(TLabel) 
  private
    FAssociate: TControl;
    FInnerHorizontal: Boolean;
    FInnerVertical: Boolean;
    FInnerMargins: TMargins;
    FHorizontalPosition: THorizontalPosition;
    FVerticalPosition: TVerticalPosition;
    FWindowProc: TWndMethod;
    procedure DoInnerMarginsUpdate(Sender: TObject);
    procedure SetAssociate(const Value: TControl);
    procedure SetInnerHorizontal(const Value: Boolean);
    procedure SetInnerVertical(const Value: Boolean);
    procedure SetInnerMargins(const Value: TMargins);
    procedure SetHorizontalPosition(const Value: THorizontalPosition);
    procedure SetVerticalPosition(const Value: TVerticalPosition);
  protected
    procedure MyWndProc(var Message: TMessage);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateLabel;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Associate: TControl read FAssociate write SetAssociate;
    property HorizontalPosition: THorizontalPosition read FHorizontalPosition write SetHorizontalPosition;
    property InnerHorizontal: Boolean read FInnerHorizontal write SetInnerHorizontal;
    property InnerVertical: Boolean read FInnerVertical write SetInnerVertical;
    property InnerMargins: TMargins read FInnerMargins write SetInnerMargins;
    property VerticalPosition: TVerticalPosition read FVerticalPosition write SetVerticalPosition;
  end;

  TLinkLabelDisplayMode = (dmNone, dmGlyph, dmImageList);

  TNxLinkLabel = class(TNxCollectionControl)
  private
    FCaption: WideString;
    FDisplayMode: TLinkLabelDisplayMode;
    FGlyph: TBitmap;
    FHover: Boolean;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FTextDistance: Integer;
    FTransparent: Boolean;
    FTransparentColor: TColor;
    FVertSpacing: Integer;
    FHoverColor: TColor;
    procedure ApplyTransparentColor(const Value: TColor);
    procedure MakeAutoSize(var NewWidth: Integer; var NewHeight: Integer);
    procedure SetCaption(const Value: WideString);
    procedure SetDisplayMode(const Value: TLinkLabelDisplayMode);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetTextDistance(const Value: Integer);
    procedure SetTransparent(const Value: Boolean);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetVertSpacing(const Value: Integer);
    procedure SetHoverColor(const Value: TColor);
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure Changed;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
	  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoGlyphChange(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure RefreshText;
    procedure SetName(const Value: TComponentName); override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;	public
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property Anchors;
    property AutoSize default True;
    property Caption: WideString read FCaption write SetCaption;
    property Color;
    property Constraints;
    property DisplayMode: TLinkLabelDisplayMode read FDisplayMode write SetDisplayMode default dmGlyph;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property HoverColor: TColor read FHoverColor write SetHoverColor;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Images: TCustomImageList read FImages write SetImages;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TextDistance: Integer read FTextDistance write SetTextDistance;
    property TabStop;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor default clNone;
    property Visible;
    property VertSpacing: Integer read FVertSpacing write SetVertSpacing;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxHtmlLabel = class(TGraphicControl)
  private
    FCaption: WideString;
    FCursor: TCursor;
    FOnLinkClick: TNxHtmlClickEvent;
    FTransparentSet: Boolean;
    procedure SetCaption(const Value: WideString);
    function GetTransparent: Boolean;
    procedure SetTransparent(const Value: Boolean);
  protected
    procedure AdjustBounds; dynamic;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property Anchors;
    property AutoSize default False;
    property Caption: WideString read FCaption write SetCaption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Transparent: Boolean read GetTransparent write SetTransparent stored FTransparentSet;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnLinkClick: TNxHtmlClickEvent read FOnLinkClick write FOnLinkClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxSplitter = class(TSplitter)
  private
    FColorScheme: TColorScheme;
    FAdaptiveColors: Boolean;
    procedure SetColorScheme(const Value: TColorScheme);
    procedure SetAdaptiveColors(const Value: Boolean);
  protected
  	procedure Paint; override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AdaptiveColors: Boolean read FAdaptiveColors write SetAdaptiveColors default True;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csDefault;
    property Width default 9;
    property OnDblClick;
  end;

  TBackgroundDrawStyle = (bdsOpaque, bdsSkip, bdsTransparent);

  TNxGlyphButton = class(TCustomControl)
  private
    FAlignment: TAlignment;
    FAutoCheck: Boolean;
  	FBufferBitmap: TBitmap;
    FChecked: Boolean;
    FDown: Boolean;
    FDownImage: TBitmap;
    FHover: Boolean;
    FHoverImage: TBitmap;
    FImage: TBitmap;
    FMargin: Integer;
    FPressed: Boolean;
    FTransparent: Boolean;
    FBackgroundDrawStyle: TBackgroundDrawStyle;
    FDisabledImage: TBitmap;
    procedure SetImage(const Value: TBitmap);
    procedure SetDown(const Value: Boolean);
    procedure SetDownImage(const Value: TBitmap);
    procedure SetHoverImage(const Value: TBitmap);
    procedure SetChecked(const Value: Boolean);
    procedure SetAutoCheck(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetMargin(const Value: Integer);
    procedure SetBackgroundDrawStyle(const Value: TBackgroundDrawStyle);
    procedure SetDisabledImage(const Value: TBitmap);
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoImageChange(Sender: TObject);
  	procedure Paint; override;
	  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Anchors;
    property AutoCheck: Boolean read FAutoCheck write SetAutoCheck default False;
    property AutoSize;
    property BackgroundDrawStyle: TBackgroundDrawStyle read FBackgroundDrawStyle write SetBackgroundDrawStyle default bdsSkip;
    property Caption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Color;
    property Constraints;
    property DisabledImage: TBitmap read FDisabledImage write SetDisabledImage;
    property Down: Boolean read FDown write SetDown default False;
    property DownImage: TBitmap read FDownImage write SetDownImage;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HoverImage: TBitmap read FHoverImage write SetHoverImage;
  	property Image: TBitmap read FImage write SetImage;
    property Margin: Integer read FMargin write SetMargin;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  THeaderOptions = set of (hoClickOnBodyExpand, hoColorSchemeFont, hoCollapseButton);
  TNxHeaderStyle = (psFlat, psNormal, psSectionHeader, psVista, psWindowsLive);
  TNxPanelStyle = (ptDefault, ptGradient, ptInverseGradient);

  TCollapseEvent = procedure (Sender: TObject; var Accept: Boolean) of object;

  TNxHeaderPanel = class(TNxCollectionControl)
  private
    FAdaptiveColors: Boolean;
    FBorderColor: TColor;
    FBtnState: TButtonState;
    FCaption: WideString;
    FCollapseWidth: Integer;
    FColorScheme: TColorScheme;
    FDisplayStyle: TDisplayStyle;
    FDrawDirection: TDirection;
    FExpanded: Boolean;
    FExpanding: Boolean;
    FFullWidth: Integer;
    FGlyph: TBitmap;
    FHeaderColor: TColor;
    FHeaderFont: TFont;
    FHeaderMouseDown: Boolean;
    FHeaderSize: Integer;
    FHeaderStyle: TNxHeaderStyle;
    FIndent: Integer;
    FInnerMargins: TNxMargins;
    FOnChange: TNotifyEvent;
    FOnCollapse: TCollapseEvent;
    FOnExpand: TCollapseEvent;
    FOnGlyphClick: TNotifyEvent;
    FOnHeaderClick: TNotifyEvent;
    FOptions: THeaderOptions;
    FPanelStyle: TNxPanelStyle;
    FParentHeaderFont: Boolean;
    FPicture: TPicture;
    function GetGlyphPos: TPoint;
    function GetGlyphRect: TRect;
    procedure SetAdaptiveColors(const Value: Boolean);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBtnState(const Value: TButtonState);
    procedure SetCaption(const Value: WideString);
    procedure SetColorScheme(const Value: TColorScheme);
    procedure SetDisplayStyle(const Value: TDisplayStyle);
    procedure SetDrawDirection(const Value: TDirection);
    procedure SetExpanded(const Value: Boolean);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetHeaderColor(const Value: TColor);
    procedure SetHeaderFont(const Value: TFont);
    procedure SetHeaderSize(const Value: Integer);
    procedure SetHeaderStyle(const Value: TNxHeaderStyle);
    procedure SetIndent(const Value: Integer);
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetOptions(const Value: THeaderOptions);
    procedure SetPanelStyle(const Value: TNxPanelStyle);
    procedure SetParentHeaderFont(const Value: Boolean);
    procedure SetPicture(const Value: TPicture);
	protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoCollapse(var Accept: Boolean); dynamic;
    procedure DoExpand(var Accept: Boolean); dynamic;
    {$IFDEF DELPHI2010UP}
    procedure DoGesture(const EventInfo: TGestureEventInfo; var Handled: Boolean); virtual;
    {$ENDIF}
    procedure DoGlyphChange(Sender: TObject);
    procedure DoGlyphClick; dynamic;
    procedure DoHeaderClick; dynamic;
    procedure DoHeaderFontChange(Sender: TObject);
    procedure DoMaginsChange(Sender: TObject);
    procedure DoPictureChanged(Sender: TObject);
    procedure DrawBackground(ARect: TRect);
    procedure DrawButton(const ButtonRect: TRect); virtual;
    procedure DrawButtonBackground(const ButtonRect: TRect); virtual;
    procedure DrawFlatHeader(const HeaderRect: TRect); virtual;
    procedure DrawNormalHeader(const HeaderRect: TRect); virtual;
    procedure DrawSectionHeader(const HeaderRect: TRect); virtual;
    procedure DrawVistaHeader(const HeaderRect: TRect); virtual;
    procedure DrawWindowsLiveHeader(const HeaderRect: TRect); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  	procedure Paint; override;
    procedure ReadFullWidth(Reader: TReader);
    procedure RedrawBorder; virtual;
    procedure RefreshCollapseButton;
    procedure UpdateSize;
    procedure NXMColorSchemeChanged(var Message: TMessage); message NXM_COLORSCHEMECHANGED;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WriteFullWidth(Writer: TWriter);
  public
    function GetButtonRect: TRect;
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
	published
    property AdaptiveColors: Boolean read FAdaptiveColors write SetAdaptiveColors default True;
  	property Align;
    property Anchors;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBlack;
    property BorderWidth default 1;
    property Caption: WideString read FCaption write SetCaption;
    property CollapseWidth: Integer read FCollapseWidth write FCollapseWidth default szHeadCollapsedWidth;
  	property Color;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csDefault;
    property Constraints;
    property DisplayStyle: TDisplayStyle read FDisplayStyle write SetDisplayStyle default dsNormal;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DrawDirection: TDirection read FDrawDirection write SetDrawDirection default diLeftToRight;
  	property Expanded: Boolean read FExpanded write SetExpanded default True;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clActiveCaption;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property HeaderSize: Integer read FHeaderSize write SetHeaderSize default sizHeaderSize;
    property HeaderStyle: TNxHeaderStyle read FHeaderStyle write SetHeaderStyle default psNormal;
    property Height default 245;
    property Indent: Integer read FIndent write SetIndent default spHeadPnlIndent;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property Options: THeaderOptions read FOptions write SetOptions default [hoColorSchemeFont];
    property PanelStyle: TNxPanelStyle read FPanelStyle write SetPanelStyle default ptDefault;
    property ParentColor default False;
    property ParentFont;
    property ParentHeaderFont: Boolean read FParentHeaderFont write SetParentHeaderFont default True;
    property Picture: TPicture read FPicture write SetPicture;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width default 245;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnCollapse: TCollapseEvent read FOnCollapse write FOnCollapse;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpand: TCollapseEvent read FOnExpand write FOnExpand;
    property OnGlyphClick: TNotifyEvent read FOnGlyphClick write FOnGlyphClick;
    property OnHeaderClick: TNotifyEvent read FOnHeaderClick write FOnHeaderClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxImage = class(TNxCollectionControl)
  private
    FDrawFrame: Boolean;
    FFocusImage: Boolean;
    FFrameSize: Integer;
    FMargin: Integer;
    FPicture: TPicture;
    FShowFocus: Boolean;
    FCenter: Boolean;
    FDrawBackground: Boolean;
    procedure SetDrawFrame(const Value: Boolean);
    procedure SetFrameSize(const Value: Integer);
    procedure SetMargin(const Value: Integer);
    procedure SetPicture(const Value: TPicture);
    procedure SetShowFocus(const Value: Boolean);
    procedure SetCenter(const Value: Boolean);
    procedure SetDrawBackground(const Value: Boolean);
  protected
    function GetPictureRect(ARect: TRect; Graphic: TGraphic): TRect;
    procedure DoPictureChange(Sender: TObject); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintBackground(Rect: TRect);
    procedure PaintFrame(var ARect: TRect; Size: Integer);
    procedure PaintPicture(var ARect: TRect; Graphic: TGraphic);
    procedure Paint; override;
    procedure RefreshPicture;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Caption;
    property Center: Boolean read FCenter write SetCenter default False;
    property Constraints;
  	property Color;
    property DrawBackground: Boolean read FDrawBackground write SetDrawBackground default False;
    property DrawFrame: Boolean read FDrawFrame write SetDrawFrame default True;
    property FocusImage: Boolean read FFocusImage write FFocusImage default True;
    property Font;
    property FrameSize: Integer read FFrameSize write SetFrameSize default 2;
    property Margin: Integer read FMargin write SetMargin default 4;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property Picture: TPicture read FPicture write SetPicture;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxGlyph = class(TGraphicControl)
  private
    FAutoSize: Boolean;
    FGlyph: TBitmap;
    FTransparent: Boolean;
    procedure ResizeGlyph;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetAutoSize(const Value: Boolean); reintroduce;
    procedure SetTransparent(const Value: Boolean);
	protected
    procedure DoGlyphChange(Sender: TObject);
  	procedure Paint; override;
	public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
	published
    property Action;
  	property Align;
    property Anchors;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Constraints;
  	property Color;
    property Font;
    property Hint;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxButtonLayout = (blGlyphBottom, blGlyphLeft, blGlyphRight, blGlyphTop);

  TNxButton = class(TNxCollectionControl)
  private
    FActive: Boolean;
    FCancel: Boolean;
    FDefault: Boolean;
    FDown: Boolean;
    FGlyph: TBitmap;
    FGlyphSpacing: Integer;
    FGrayGlyph: TBitmap;
    FLayout: TNxButtonLayout;
    FModalResult: TModalResult;
    FShowArrow: Boolean;
    FTheme: HTHEME;
    FTransparent: Boolean;
    FEnableDblClick: Boolean;
    procedure ApplyTransparency;
    procedure SetDefault(const Value: Boolean);
    procedure SetDown(const Value: Boolean);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetTransparent(const Value: Boolean);
    procedure SetLayout(const Value: TNxButtonLayout);
    procedure SetShowArrow(const Value: Boolean);
    procedure SetGlyphSpacing(const Value: Integer);
    procedure SetEnableDblClick(const Value: Boolean);
	protected
    FHover: Boolean;
    FKeyPressed: Boolean;
    FPressed: Boolean;
    procedure CreateWnd; override;
    procedure DoGlyphChange(Sender: TObject);
    procedure DrawButton(Canvas: TCanvas); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  	procedure Paint; override;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
	  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMThemeChanged(var Message: TMessage); message WM_THEMECHANGED;
	public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
	published
    property Action;
  	property Align;
    property Anchors;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Caption;
    property Constraints;
  	property Color;
    property Default: Boolean read FDefault write SetDefault default False;
    property Down: Boolean read FDown write SetDown default False;
    property Enabled;
    property EnableDblClick: Boolean read FEnableDblClick write SetEnableDblClick default True;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property GlyphSpacing: Integer read FGlyphSpacing write SetGlyphSpacing default 3;
    property Height default 23;
    property Hint;
    property Layout: TNxButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowArrow: Boolean read FShowArrow write SetShowArrow default False;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNxOptionButton = class(TCustomControl)
  private
    FDown: Boolean;
    FGlyph: TBitmap;
    FGrayGlyph: TBitmap;
    FHover: Boolean;
    FTransparent: Boolean;
    FGlyphIndent: Integer;
    FCaption: WideString;
    FInnerMargins: TNxMargins;
    FTransparentColor: TColor;
    FWrapKind: TWrapKind;
    FText: WideString;
    FFixedMargin: Boolean;
    FTextSpacing: Integer;
    procedure ApplyTransparency;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetGlyphIndent(const Value: Integer);
    procedure SetCaption(const Value: WideString);
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetText(const Value: WideString);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetWrapKind(const Value: TWrapKind);
    procedure SetTransparent(const Value: Boolean);
    procedure SetFixedMargin(const Value: Boolean);
    procedure SetTextSpacing(const Value: Integer);
  protected
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DoGlyphChange(Sender: TObject);
    procedure DoInnerMarginsChange(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption: WideString read FCaption write SetCaption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedMargin: Boolean read FFixedMargin write SetFixedMargin default False;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property GlyphIndent: Integer read FGlyphIndent write SetGlyphIndent default 5;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property ParentBiDiMode;
    {$IFDEF DELPHI7}
    property ParentBackground;
    {$ENDIF}
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text: WideString read FText write SetText;
    property TextSpacing: Integer read FTextSpacing write SetTextSpacing default 2;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor default clNone;
    property UseDockManager default True;
    property Visible;
    property WrapKind: TWrapKind read FWrapKind write SetWrapKind default wkWordWrap;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TNxPanelBackgroundStyle = (pbControl, pbHorzGradient, pbSolid, pbTransparent,
    pbVertGradient);

  TPanelBorders = set of (boBottom, boLeft, boRight, boTop);

  TNxPanel = class(TNxCollectionControl)
  private
    FAdaptiveColors: Boolean;
    FBackgroundStyle: TNxPanelBackgroundStyle;
    FBorderPen: TPen;
    FColorScheme: TColorScheme;
    FInnerMargins: TNxMargins;
    FPanelBorders: TPanelBorders;
    FFullRepaint: Boolean;
    procedure SetAdaptiveColors(const Value: Boolean);
    procedure SetBackgroundStyle(const Value: TNxPanelBackgroundStyle);
    procedure SetBorderPen(const Value: TPen);
    procedure SetColorScheme(const Value: TColorScheme);
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetPanelBorders(const Value: TPanelBorders);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoInnerMarginsChange(Sender: TObject);
    procedure DoStyleChange(Sender: TObject);
    procedure Paint; override;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  	property AdaptiveColors: Boolean read FAdaptiveColors write SetAdaptiveColors default True;
    property Align;
    property Anchors;
    property AutoSize;
    property BackgroundStyle: TNxPanelBackgroundStyle read FBackgroundStyle write SetBackgroundStyle default pbSolid;
    property BiDiMode;
    property BorderPen: TPen read FBorderPen write SetBorderPen;
    property BorderWidth;
    property Caption;
    property Color;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csDefault;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FullRepaint: Boolean read FFullRepaint write FFullRepaint default False;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property PanelBorders: TPanelBorders read FPanelBorders write SetPanelBorders default [boBottom, boLeft, boRight, boTop];
    property ParentBiDiMode;
    {$IFDEF DELPHI7}
    property ParentBackground;
    {$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TNxGroupHeader = class(TGraphicControl)
  private
    FColorScheme: TColorScheme;
    FAlignment: TAlignment;
    FFillStyle: TFillPaintStyle;
    FGlyph: TBitmap;
    FTransparentColor: TColor;
    FGlyphVisible: Boolean;
    procedure SetColorScheme(const Value: TColorScheme);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetFillStyle(const Value: TFillPaintStyle);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetGlyphVisible(const Value: Boolean);
  protected
    procedure ApplyTransparentColor(AColor: TColor);
    procedure DoGlyphChange(Sender: TObject);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  	property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Anchors;
    property Caption;
    property Constraints;
    property Color;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csBlue;
    property Enabled;
    property Font;
    property FillStyle: TFillPaintStyle read FFillStyle write SetFillStyle default fsSolid;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor default clNone;
    property GlyphVisible: Boolean read FGlyphVisible write SetGlyphVisible default True;
    property PopupMenu;
    property ParentColor;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TInfoPanelOptions = set of (ipBorder, ipStaticPanel, ipHtmlText);

  TNxInfoPanel = class(TGraphicControl)
  private
    FAlignment: TAlignment;
    FBorderColor: TColor;
    FButtonState: TButtonState;
    FCaption: WideString;
    FColorScheme: TColorScheme;
    FFillStyle: TFillPaintStyle;
    FGlyph: TBitmap;
    FIndent: Integer;
    FInnerMargins: TNxMargins;
    FOptions: TInfoPanelOptions;
    FOuterMargins: TNxMargins;
    FSpacing: Integer;
    FText: WideString;
    FTransparentColor: TColor;
    FVerticalAlignment: TVerticalAlignment;
    FWrapKind: TWrapKind;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetCaption(const Value: WideString);
    procedure SetColorScheme(const Value: TColorScheme);
    procedure SetFillStyle(const Value: TFillPaintStyle);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetIndent(const Value: Integer);
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetOptions(const Value: TInfoPanelOptions);
    procedure SetOuterMargins(const Value: TNxMargins);
    procedure SetSpacing(const Value: Integer);
    procedure SetText(const Value: WideString);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetVerticalAlignment(const Value: TVerticalAlignment);
    procedure SetWrapKind(const Value: TWrapKind);
    procedure SetBorderColor(const Value: TColor);
  protected
    procedure ApplyTransparentColor(AColor: TColor);
    procedure ChangeState(State: TButtonState); virtual;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
	  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DoGlyphChange(Sender: TObject);
    procedure DoInnerMarginsChange(Sender: TObject);
    procedure DoOuterMarginsChange(Sender: TObject);
    procedure GetPaintColors(var PenColor, ForeColor, BackColor, FontColor: TColor); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    property ButtonState: TButtonState read FButtonState write FButtonState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
  	property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Anchors;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBlack;
    property FillStyle: TFillPaintStyle read FFillStyle write SetFillStyle default fsSolid;
    property Caption: WideString read FCaption write SetCaption;
    property Constraints;
    property Color;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csDefault;
    property Enabled;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property Indent: Integer read FIndent write SetIndent default 4;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property Options: TInfoPanelOptions read FOptions write SetOptions default [];
    property OuterMargins: TNxMargins read FOuterMargins write SetOuterMargins;
    property ParentColor;
    property PopupMenu;
    property Spacing: Integer read FSpacing write SetSpacing default 2;
    property Text: WideString read FText write SetText;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor default clNone;
    property Visible;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write SetVerticalAlignment default taAlignTop;
    property WrapKind: TWrapKind read FWrapKind write SetWrapKind default wkNone;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TPathItemDrawStyle = set of (pdsButtonDown, pdsDown, pdsButtonHover, pdsHover, pdsTitleHover);
  TPathItemPart = (pipTitle, pipButton);
  TPathItemState = set of (psButtonDown, psButtonHover, psDown, psTitleHover); 

  TNxPathControl = class;

  TNxPathNode = class(TNxTreeNode)
  private
    FImageIndex: TImageIndex;
    FState: TPathItemState;
    procedure SetImageIndex(const Value: TImageIndex);
  public
    constructor Create; override;
    property State: TPathItemState read FState;
  published
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
  end;

  TNxPathNodes = class(TNxTreeNodes)
  private
    function GetPathItem(const Index: Integer): TNxPathNode;
  protected
    function GetTreeNodeClass: TNxTreeNodeClass; override;
  public
    property Item[const Index: Integer]: TNxPathNode read GetPathItem; default;
  end;

  TPathButtonState = (ptNormal, ptDown, ptHover, ptHoverActive);
  TPathButtonStyle = (bsDefault, bsOffice2007);

  TNodeNotifyEvent = procedure (Sender: TObject; Node: TNxPathNode) of object;

  TNxPathControl = class(TNxCollectionControl)
  private
    FButtonDown: Boolean;
    FButtonStyle: TPathButtonStyle;
    FDownItem: TNxPathNode;
    FFirstClick: Boolean;
    FFirstItem: Integer;
    FHoverItem: TNxPathNode;
    FHoverItemPart: TPathItemPart;
    FImages: TCustomImageList;
    FItems: TNxPathNodes;
    FOldDownItem: TNxPathNode;
    FOnPopup: TNodeNotifyEvent;
    FOnSelect: TNotifyEvent;
    FPopup: TPopupMenu;
    FRootItemDown: Boolean;
    FRootItemHover: Boolean;
    FSelected: TNxPathNode;
    FEnableVisualStyles: Boolean;
    FUpdateCount: Integer;
    FOnItemMouseMove: TNodeNotifyEvent;
    function GetFirstItem: Integer;
    function GetRootItemWidth: Integer;
    function GetSelectedItem(const Index: Integer): TNxPathNode;
    procedure SetButtonStyle(const Value: TPathButtonStyle);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetPopupItems(PathItem: TNxPathNode);
    procedure SetRootItemDown(const Value: Boolean);
    procedure SetRootItemHover(const Value: Boolean);
    procedure SetSelected(const Value: TNxPathNode);
    procedure SetEnableVisualStyles(const Value: Boolean);
  protected
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DoMenuItemClick(Sender: TObject);
    procedure DoItemMouseEnter(Item: TNxPathNode); dynamic;
    procedure DoNodeDeleted(Sender: TObject; Item: TNxTreeNode); dynamic;
    procedure DoPopup(Node: TNxPathNode); dynamic;
    procedure DoSelect; dynamic;
    procedure DrawButtonEdge(const ButtonRect: TRect; Edge: TButtonEdge;
      State: TPathButtonState);
    procedure DrawItem(ItemRect: TRect; Item: TNxPathNode; DrawStyle: TPathItemDrawStyle);
    procedure DrawItems;
    procedure DrawRootItem(DrawStyle: TPathItemDrawStyle);
    function GetPopupButtonWidth: Integer; virtual;
    function GetItemWidth(Item: TNxPathNode): Integer; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure RefreshRootItem;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    procedure BeginUpdate;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EndUpdate;
    function GetItemAtPos(X, Y: Integer): TNxPathNode; overload;
    function GetItemAtPos(X, Y: Integer; var ItemPart: TPathItemPart): TNxPathNode; overload;
    function GetItemRect(Item: TNxPathNode): TRect;
    function GetRootItemRect: TRect;
    procedure RefreshItem(Item: TNxPathNode);
    property Items: TNxPathNodes read FItems;
    property Selected: TNxPathNode read FSelected write SetSelected;
    property SelectedItem[const Index: Integer]: TNxPathNode read GetSelectedItem;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property ButtonStyle: TPathButtonStyle read FButtonStyle write SetButtonStyle default bsDefault;
    property Caption;
    property Constraints;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EnableVisualStyles: Boolean read FEnableVisualStyles write SetEnableVisualStyles default True;
    property Font;
    property Hint;
    property Images: TCustomImageList read FImages write SetImages;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnItemMouseMove: TNodeNotifyEvent read FOnItemMouseMove write FOnItemMouseMove;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPopup: TNodeNotifyEvent read FOnPopup write FOnPopup;
    property OnResize;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
    property OnStartDrag;
  end;

  TNxFloatPanel = class(TCustomControl)
  private                                    
    FBorderColor: TColor;
    procedure SetBorderColor(const Value: TColor);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function GetCloseButtonRect: TRect; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure Paint; override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
  	constructor Create(AOwner: TComponent); override;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor default wsclDarkGray;
    property Color default clWindow;
    property ParentColor default False;
  end;

  TNxProgressBar = class(TCustomControlBar)
  private
    FOrientation: TProgressBarOrientation;
    FStep: Integer;
    procedure SetOrientation(const Value: TProgressBarOrientation);
  protected
    procedure Paint; override;
  public
  	constructor Create(AOwner: TComponent); override;
  published
    property Orientation: TProgressBarOrientation read FOrientation write SetOrientation default pbHorizontal;
    property Step: Integer read FStep write FStep default 10;
  end;

  TNxTextStyle = (tsNormal, tsHtml);

  TNxTreeView = class(TCustomControl)
  private
    FFirst: Integer;
    FItems: TNxTreeNodes;
    FTextStyle: TNxTextStyle;
    procedure SetTextStyle(const Value: TNxTextStyle);
  protected
    function GetNodeHeight: Integer; virtual;
    procedure Paint; override;
    procedure PaintButton(NodeRect: TRect; Expanded: Boolean); virtual;
    procedure PaintItems; virtual;
    procedure PaintNode(Node: TNxTreeNode; NodeRect: TRect); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Items: TNxTreeNodes read FItems;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Constraints;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Hint;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TextStyle: TNxTextStyle read FTextStyle write SetTextStyle default tsNormal;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
  end;

  TNxContainer = class(TCustomControl)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNxExpandPanel = class(TNxCollectionControl)
  private
    FButtonLeft: Integer;
    FButtonTop: Integer;
    FDown: Boolean;
    FFullHeight: Integer;
    FHover: Boolean;
    FExpanded: Boolean;
    FInnerMargins: TNxMargins;
    FOnCollapse: TNotifyEvent;
    FOnExpand: TNotifyEvent;
    FExpandedText: WideString;
    FCollapsedText: WideString;
    FResizeForm: Boolean;
    function GetCollapsedHeight: Integer;
    procedure HideChildrens;
    procedure ShowChildrens;
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetButtonLeft(const Value: Integer);
    procedure SetButtonTop(const Value: Integer);
    procedure SetExpanded(const Value: Boolean);
    procedure SetHover(const Value: Boolean);
    procedure SetDown(const Value: Boolean);
    procedure SetExpandedText(const Value: WideString);
    procedure SetCollapsedText(const Value: WideString);
    procedure SetResizeForm(const Value: Boolean);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoCollapse; dynamic;
    procedure DoExpand; dynamic;
    procedure DoInnerMarginsChange(Sender: TObject);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure ReadFullHeight(Reader: TReader);
    procedure RefreshButton;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WriteFullHeight(Writer: TWriter);
    property Down: Boolean read FDown write SetDown;
    property Hover: Boolean read FHover write SetHover;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetButtonRect: TRect;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property ButtonLeft: Integer read FButtonLeft write SetButtonLeft default 10;
    property ButtonTop: Integer read FButtonTop write SetButtonTop default 10;
    property Constraints;
    property CollapsedText: WideString read FCollapsedText write SetCollapsedText;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Expanded: Boolean read FExpanded write SetExpanded default True;
    property ExpandedText: WideString read FExpandedText write SetExpandedText;
    property Font;
    property Hint;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ResizeForm: Boolean read FResizeForm write SetResizeForm default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnClick;
    property OnCollapse: TNotifyEvent read FOnCollapse write FOnCollapse;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpand: TNotifyEvent read FOnExpand write FOnExpand;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
  end;

  TNxIconList = class(TCustomControl)
  private
    FHoverIndex: Integer;
    FImages: TImageList;
    FItems: TNxStrings;
    FOldPosition: Integer;
    FIndent: Integer;
    FPosition: Integer;
    FSpacing: Integer;
    FThumbPressed: Boolean;
    FThumbMousePos: Integer;
    FBorderColor: TColor;
    FItemIndex: Integer;
    FScrollBarColor: TColor;
    FOnChange: TNotifyEvent;
    FScrollBarHeight: TColor;
    procedure SetImages(const Value: TImageList);
    procedure SetItems(const Value: TNxStrings);
    procedure SetSpacing(const Value: Integer);
    procedure SetBorderColor(const Value: TColor);
    procedure SetItemIndex(const Value: Integer);
    procedure SetScrollBarColor(const Value: TColor);
    procedure SetScrollBarHeight(const Value: TColor);
  protected
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function GetPageClientSize: Integer; virtual;
    function GetPageSize: Integer; virtual;
    function GetScrollArea: TRect; virtual;
    function GetScrollMax: Integer; virtual;
    function GetScrollRect: TRect; virtual;
    function GetInnerRect: TRect; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure RefreshItem(const Index: Integer; Expand: Boolean); virtual;
    procedure ScrollThumb(Delta: Integer); virtual;
    procedure ScrollContent(Delta: Integer); virtual;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetItemAtPos(const X, Y: Integer): Integer;
    function GetItemRect(const Index: Integer; Expand: Boolean): TRect;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property Constraints;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Hint;
    property Images: TImageList read FImages write SetImages;
    property Items: TNxStrings read FItems write SetItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ScrollBarColor: TColor read FScrollBarColor write SetScrollBarColor default clHighlight;
    property ScrollBarHeight: TColor read FScrollBarHeight write SetScrollBarHeight default 16;
    property ShowHint;
    property Spacing: Integer read FSpacing write SetSpacing;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
  end;

  TNxHint = class(TComponent)
  private
    FIndent: TNxIndent;
    procedure SetIndent(const Value: TNxIndent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Indent: TNxIndent read FIndent write SetIndent;
  end;

  TNxHintWindow = class(THintWindow)
  private
    FHint: TNxHint;
    FText: string;
  protected
    function GetHintComponent: TNxHint;
    procedure Paint; override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    constructor Create(AOwner: TComponent); override;
  end;

  TNxToolbar = class;
  TNxToolbarItems = class;
  TNxToolbarItemClass = class of TNxToolItem;

  TNxToolbarItemPosition = (tipLeft, tipRight);
  TNxToolItemState = set of (isDown, isHover);

  TNxToolItem = class(TComponent)
  private
    FCaption: WideString;
    FItems: TNxToolbarItems;
    FPosition: TNxToolbarItemPosition;
    FOnClick: TNotifyEvent;
    FVisible: Boolean;
    procedure SetCaption(const Value: WideString);
    procedure SetPosition(const Value: TNxToolbarItemPosition);
    function GetIndex: Integer;
    procedure SetVisible(const Value: Boolean);
  protected
    procedure DoClick; dynamic;
    function GetItemSize: TSize; virtual;
    procedure Paint(ARect: TRect; State: TNxToolItemState); virtual;
    procedure SetParentComponent(Value: TComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    property Index: Integer read GetIndex;
  published
    property Caption: WideString read FCaption write SetCaption;
    property Position: TNxToolbarItemPosition read FPosition write SetPosition default tipLeft;
    property Visible: Boolean read FVisible write SetVisible default True;

    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TNxToolButton = class(TNxToolItem)
  private
    FHint: string;
    FImageIndex: TImageIndex;
    FPopupMenu: TPopupMenu;
    procedure SetHint(const Value: string);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetPopupMenu(const Value: TPopupMenu);
  protected
    function GetItemSize: TSize; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint(ARect: TRect; State: TNxToolItemState); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Hint: string read FHint write SetHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
  end;

  TNxToolSeparator = class(TNxToolItem)
  protected
    function GetItemSize: TSize; override;
    procedure Paint(ARect: TRect; State: TNxToolItemState); override;
  published

  end;

  TNxToolbarItems = class
  private
    FToolbar: TNxToolbar;
    FItems: TList;
    function GetItem(Index: Integer): TNxToolItem;
    procedure SetItem(Index: Integer; const Value: TNxToolItem);
    function GetCount: Integer;
  public
    function Add(ItemClass: TNxToolbarItemClass): TNxToolItem;
    procedure AddItem(Item: TNxToolItem);
    procedure Clear;
    constructor Create(AToolbar: TNxToolbar); virtual;
    destructor Destroy; override;
    function IndexOf(AItem: TNxToolItem): Integer;
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Remove(AItem: TNxToolItem);
    property Count: Integer read GetCount;
    property Item[Index: Integer]: TNxToolItem read GetItem write SetItem; default;
  end;

  TNxToolbar = class(TNxCollectionControl)
  private
    FHoverItem: TNxToolItem;
    FImages: TCustomImageList;
    FItems: TNxToolbarItems;
    FDownItem: TNxToolItem;
    procedure SetImages(const Value: TCustomImageList);
    procedure SetHoverItem(const Value: TNxToolItem);
    procedure SetItems(const Value: TNxToolbarItems);
    procedure SetDownItem(const Value: TNxToolItem);
  protected
    function GetChildOwner: TComponent; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    procedure SetPosition(const Index: Integer; Position: TNxToolbarItemPosition);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetItemAtPos(const X, Y: Integer): TNxToolItem;
    function GetItemRect(AItem: TNxToolItem): TRect;
    function IndexOf(AItem: TNxToolItem): Integer;
    procedure RefreshItem(Item: TNxToolItem);
    property DownItem: TNxToolItem read FDownItem write SetDownItem;
    property HoverItem: TNxToolItem read FHoverItem write SetHoverItem;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Hint;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TNxToolbarItems read FItems write SetItems;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;  end;

  procedure DrawGrips(Canvas: TCanvas; Dest: TRect; Count: Integer;
    Orientation: TOrientation; ColorScheme: TColorScheme);

implementation

uses
  Math, StrUtils, DateUtils;

const
  spSpacingLeft = 4;
  spSpacingRight = 6;

var
  AlertIndent: Integer = 0;
  IndentList: TList;

procedure MinValue(var Value: Integer; Min: Integer);
begin
  if Value < Min then Value := Min;
end;

function GetHighestIndent: Integer;
var
  i: Integer;
  P: PInteger;
begin
  Result := 0;
  if IndentList = nil then IndentList := TList.Create else
    for i := 0 to Pred(IndentList.Count) do
    begin
      P := IndentList[i];
      if P^ > Result then Result := P^;
    end;
end;

procedure AddIndent(Indent: Integer);
var
  P: PInteger;
begin
  if IndentList = nil then IndentList := TList.Create;
  New(P);
  P^ := Indent;
  IndentList.Add(P);
end;

procedure ClearIndents;
var
  i: Integer;
  P: PInteger;
begin
  for i := 0 to Pred(IndentList.Count) do
  begin
    P := IndentList[i];
    Dispose(P);
  end;
  FreeAndNil(IndentList);
end;

procedure RemoveIndent(Indent: Integer);
var
  i: Integer;
  P: PInteger;
begin
  for i := 0 to Pred(IndentList.Count) do
  begin
    P := IndentList[i];
    if P^ = Indent then
    begin
      Dispose(P);
      IndentList.Delete(i);
      Exit;
    end;
  end;
end;

procedure Draw32BitBitmapFromRes(Canvas: TCanvas; X,
  Y: Integer; ResStr: string);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.LoadFromResourceName(HInstance, ResStr);
    ApplyBitmap(Canvas, X, Y, bi);
  finally
    bi.Free;
  end;
end;

procedure DrawBitmapFromRes(Canvas: TCanvas; X,
  Y: Integer; ResStr: string; TransparentColor: TColor);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.LoadFromResourceName(HInstance, ResStr);
    bi.Transparent := True;
    bi.TransparentColor := TransparentColor;
    Canvas.Draw(X, Y, bi);
  finally
    bi.Free;
  end;
end;

procedure DrawFocusFrame(Canvas: TCanvas; R: TRect);
var
  PrevBkColor, PrevTextColor: TColorRef;
  DC: HDC;
begin
  DC := Canvas.Handle;
  PrevBkColor := SetBkColor(DC, clBlack);
  PrevTextColor := SetTextColor(DC, clWhite);
  Windows.DrawFocusRect(DC, R);
  SetBkColor(DC, PrevBkColor);
  SetTextColor(DC, PrevTextColor);
end;

procedure DrawGrips(Canvas: TCanvas; Dest: TRect; Count: Integer;
  Orientation: TOrientation; ColorScheme: TColorScheme);
type
  TGripParts = (gpHighlight, gpShadow, gpSpace);
const
  sizGrip = 3;
var
  Colors: array[TColorScheme, TGripParts] of Integer;
  Size, X, Y, i: Integer;
begin
  if ColorScheme = csDefault then ColorScheme := NxThemesSupport.ColorScheme;
  Colors[csBlue, gpHighlight] := $00FBF9F9;
  Colors[csBlue, gpShadow] := $00CF9365;
  Colors[csBlue, gpSpace] := $00FFD1AD;

  Colors[csSilver, gpHighlight] := $00FBF9F9;
  Colors[csSilver, gpShadow] := $007C7C7C;
  Colors[csSilver, gpSpace] := $00CCCCCC;

  Colors[csBlack, gpHighlight] := $00FBF9F9;
  Colors[csBlack, gpShadow] := $007C7C7C;
  Colors[csBlack, gpSpace] := $00CCCCCC;

  Size := (sizGrip * Count) + (Count - 1);
  case Orientation of
    orHorizontal:
      begin
        X := Dest.Left + (Dest.Right - Dest.Left) div 2 - Size div 2;
        Y := Dest.Top + (Dest.Bottom - Dest.Top) div 2 - sizGrip div 2;
      end;
    else
      begin
        X := Dest.Left + (Dest.Right - Dest.Left) div 2 - sizGrip div 2;
        Y := Dest.Top + (Dest.Bottom - Dest.Top) div 2 - Size div 2;
      end;
  end;
  with Canvas do
    for i := 1 to Count do
    begin
      Brush.Color := Colors[ColorScheme, gpShadow];
      FrameRect(Rect(X, Y, X + 2, Y + 2));
      Brush.Color := Colors[ColorScheme, gpHighlight];
      FrameRect(Rect(X + 1, Y + 1, X + 3, Y + 3));
      Canvas.Pixels[X + 1, Y + 1] := Colors[ColorScheme, gpSpace];
      if Orientation = orHorizontal then Inc(X, 4) else Inc(Y, 4);
    end;
end;

procedure DrawFmtText(Canvas: TCanvas; TextRect: TRect; Value: WideString; Alignment: TAlignment;
  VerticalAlignment: TVerticalAlignment; WrapKind: TWrapKind; BiDiMode: TBiDiMode; Disabled: Boolean = False);
var
  Flags: Integer;
  R: TRect;
  StringText: string;
begin
  R := TextRect;
  Flags := DT_NOPREFIX; { don't replace & char }
  with Canvas do
  begin
    case Alignment of
      taLeftJustify: Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter: Flags := Flags or DT_CENTER;
    end;
    case VerticalAlignment of
      taAlignTop: Flags := Flags or DT_TOP;
      taVerticalCenter: Flags := Flags or DT_VCENTER;
      taAlignBottom: Flags := Flags or DT_BOTTOM;
    end;
    case WrapKind of
      wkNone: Flags := Flags or DT_SINGLELINE;
      wkEllipsis: Flags := Flags or DT_END_ELLIPSIS or DT_SINGLELINE;
      wkPathEllipsis: Flags := Flags or DT_PATH_ELLIPSIS;
      wkWordWrap: Flags := Flags or DT_WORDBREAK;
    end;
    if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
    Brush.Style := bsClear;
    case IsUnicodeSupported of
      True:   begin
                if Disabled then
                begin
                  OffsetRect(R, 1, 1);
                  Font.Color := clBtnHighlight;
                end;
                DrawTextW(Canvas.Handle, PWideChar(Value), Length(Value), r, Flags);
                if Disabled then
                begin
                  OffsetRect(R, -1, -1);
                  Font.Color := clBtnShadow;
                  DrawTextW(Canvas.Handle, PWideChar(Value), Length(Value), r, Flags);
                end;
              end;
      False:  begin
                StringText := Value;
                Windows.DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), R, Flags);
              end;
    end;
    Brush.Style := Graphics.bsSolid;
  end;
end;

{ hoved
  actual hover
  down
}

procedure DrawOffice2007Edge(Canvas: TCanvas; const ButtonRect: TRect;
  Edge: TButtonEdge; State: TPathButtonState);
var
  R: TRect;
begin
  R := ButtonRect;
  with Canvas do
  begin
    case State of
      ptDown:
      begin
        Pen.Color := SchemeColor(seMenuSelectionBorderDown);;
        Brush.Color := SchemeColor(seMenuSelectionBorderDown);;
        Rectangle(r);
      end;
      ptNormal:
      begin
        Brush.Color := Canvas.Brush.Color;
        FillRect(r);
      end;
      ptHoverActive:
      begin
        Pen.Color := SchemeColor(seMenuSelectionBorder);;
        Brush.Color := SchemeColor(seMenuHighlight);;
        Rectangle(r);
      end;
      ptHover:
      begin
        Pen.Color := SchemeColor(seBorder);;
        Brush.Color := SchemeColor(seBtnFace);;
        Rectangle(r);
      end;
    end;
  end;
end;

procedure DrawClassicButtonEdge(Canvas: TCanvas; const ButtonRect: TRect;
  Edge: TButtonEdge; State: TPathButtonState);
var
  R: TRect;
begin
  R := ButtonRect;
  with Canvas do
  begin
    case State of
      ptDown:
      begin
        Brush.Color := clBtnFace;
        FillRect(r);
        Brush.Color := clBtnShadow;
        FrameRect(r);
      end;
      ptNormal:
      begin
        Brush.Color := Canvas.Brush.Color;
        FillRect(r);
      end;
      ptHoverActive:
      begin
        Brush.Color := clBtnFace;
        FillRect(r);
        Frame3D(Canvas, r, clBtnHighlight, cl3DDkShadow, 1);
        Pen.Color := clBtnShadow;
        InflateRect(r, -1, -1);
        Polyline([
          Point(r.Right, r.Top - 1),
          Point(r.Right, r.Bottom),
          Point(r.Left - 2, r.Bottom)]);
      end;
      ptHover:
      begin
        Brush.Color := clBtnFace;
        FillRect(r);
        Frame3D(Canvas, r, clBtnHighlight, cl3DDkShadow, 1);
      end;
    end;
  end;
end;

procedure DrawThemedButtonEdge(AControl: TCustomControl; Canvas: TCanvas; const ButtonRect: TRect;
  Edge: TButtonEdge; State: TPathButtonState);
var
  R: TRect;
begin
  R := ButtonRect;
  with Canvas do
  begin
    case State of
      ptDown:
      begin
        ThemeRect(AControl.Handle, Canvas.Handle, r, teButton, 1, 3);
      end;
      ptNormal:
      begin
        Brush.Color := Canvas.Brush.Color;
        FillRect(r);
      end;
      ptHoverActive:
      begin
        ThemeRect(AControl.Handle, Canvas.Handle, r, teButton, 1, 2);
      end;
      ptHover:
      begin
        ThemeRect(AControl.Handle, Canvas.Handle, r, teButton, 1, 1);
      end;
    end;
  end;
end;

{ TNxIndent }

procedure TNxIndent.Assign(Source: TPersistent);
begin
  if Source is TNxIndent then
  begin
    Left := TNxIndent(Source).Left;
    Top := TNxIndent(Source).Top;
  end else inherited;
end;

constructor TNxIndent.Create;
begin
  inherited;
  FLeft := 0;
  FTop := 0;
end;

procedure TNxIndent.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxIndent.SetLeft(const Value: Integer);
begin
  FLeft := Value;
  DoChange;
end;

procedure TNxIndent.SetTop(const Value: Integer);
begin
  FTop := Value;
  DoChange;
end;

{ TNxCollectionControl }

constructor TNxCollectionControl.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF DELPHI2010UP}
  ControlStyle := ControlStyle + [csGestures];
  {$ENDIF}
end;

{ TNxAlertWindow }

constructor TNxAlertWindow.Create(AOwner: TComponent);
begin
  inherited;
  AutoSize := False;
  Visible := csDesigning in ComponentState;
  ControlStyle := ControlStyle + [csAcceptsControls, csSetCaption, csReplicatable];
  FAdaptiveColors := True;
  FAlertDirection := adNone;
  FAlignment := taLeftJustify;
  FAutoResizing := False;
  FBackgroundStyle := btAuto;
  FCloseDelay := tmCloseDelay;
  FCloseGlyph := TNxActiveGlyphSettings.Create;
  FCloseGlyph.OnChange := DoGlyphChange;
  FFixedHeight := Height;
  FForegroundColor := clSkyBlue;
  FFullOpen := True;
  FGlyphPosition := gpLeft;
  FHeaderFont := TFont.Create;
  FHeaderFont.OnChange := DoHeaderFontChange;
  FHeaderSize := 22;
  FIndent := 0;
  FInProgress := False;
  FLargeGlyph := TNxGlyphSettings.Create;
  FLargeGlyph.OnChange := DoGlyphChange;
  FSmallGlyph := TNxGlyphSettings.Create;
  FSmallGlyph.OnChange := DoGlyphChange;
  FDelayTimer := TTimer.Create(Self);
  FDelayTimer.Enabled := False;
  FDelayTimer.OnTimer := DoDelayTimer;
  FDelayTimer.Interval := FCloseDelay;
  FOptions := [aoCloseButton, aoOptionsLink];
  FOptionsText := 'Options';
  FPopupLocation := plRight;
  FPopupSound := msNone;
  FPopupTimer := TTimer.Create(Self);
  FPopupTimer.Enabled := False;
  FPopupTimer.OnTimer := DoPopupTimer;
  FPopupTimer.Interval := 1;
  FPreparing := False;
  FTextMargins := TNxMargins.Create;
  FTextMargins.OnChange := DoTextMarginsChange;
  FVerticalAlignment := taVerticalCenter;
  FWordWrap := False;
  ParentColor := False;
  Color := clWindow;
  Height := 116;
  Width := 211;
  SetGlyphs;
end;

destructor TNxAlertWindow.Destroy;
begin
  if FInProgress then DoClose;
  FreeAndNil(FCloseGlyph);
  FreeAndNil(FHeaderFont);
  FreeAndNil(FDelayTimer);
  FreeAndNil(FLargeGlyph);
  FreeAndNil(FPopupTimer);
  FreeAndNil(FSmallGlyph);
  FreeAndNil(FTextMargins);
  inherited;
end;

procedure TNxAlertWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  	if not (csDesigning in ComponentState) then
    begin
	    WndParent := GetDesktopWindow;
   	  Style := WS_CLIPSIBLINGS or WS_CHILD;
	 	  ExStyle := WS_EX_TOPMOST or WS_EX_TOOLWINDOW;
   	  WindowClass.Style := CS_DBLCLKS or CS_SAVEBITS and not(CS_HREDRAW or CS_VREDRAW);
	  end;
end;

procedure TNxAlertWindow.CreateWnd;
begin
  inherited;

end;


function TNxAlertWindow.GetCloseButtonRect: TRect;
begin
  with Result do
  begin
    Top := FHeaderSize div 2 - FCloseGlyph.NormalGlyph.Height div 2;
    Inc(Top, 2);
    Left := Self.Width - FCloseGlyph.NormalGlyph.Width - 7;
    Bottom := Top + FCloseGlyph.NormalGlyph.Height;
    Right := Left + FCloseGlyph.NormalGlyph.Width;
  end;
end;

function TNxAlertWindow.GetFillColor: TColor;
begin
  if FAdaptiveColors then
  begin
    Result := SchemeColor(seBtnFace);
  end else
  begin
    Result := FForegroundColor;
  end;
end;

function TNxAlertWindow.GetOptionsTextRect: TRect;
begin
  with Result do
  begin
    Right := ClientWidth;
    Left := Right - Canvas.TextWidth(FOptionsText) - 4;
    Bottom := FFixedHeight - 4;
    Top := Bottom - Canvas.TextHeight(FOptionsText);
  end;
end;

procedure TNxAlertWindow.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetAdaptiveColors(const Value: Boolean);
begin
  FAdaptiveColors := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetBackgroundStyle(const Value: TBackgroundStyle);
begin
  FBackgroundStyle := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetCloseButtonState(const Value: TButtonState);
var
  BitmapRect: TRect;
begin
  if Value <> FCloseButtonState then
  begin
    FCloseButtonState := Value;
    BitmapRect := GetCloseButtonRect;
    InvalidateRect(Handle, @BitmapRect, False);
  end;
end;

procedure TNxAlertWindow.SetCloseDelay(const Value: Integer);
begin
  FCloseDelay := Value;
  FDelayTimer.Interval := Value;
end;

procedure TNxAlertWindow.SetCloseGlyph(const Value: TNxActiveGlyphSettings);
begin
  FCloseGlyph.Assign(Value);
end;

procedure TNxAlertWindow.SetLargeGlyph(const Value: TNxGlyphSettings);
begin
  FLargeGlyph.Assign(Value);
  Invalidate;
end;

procedure TNxAlertWindow.SetForegroundColor(const Value: TColor);
begin
  FForegroundColor := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetGlyphPosition(const Value: TGlyphPosition);
begin
  FGlyphPosition := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetHeaderFont(const Value: TFont);
begin
  FHeaderFont.Assign(Value);
  Invalidate;
end;

procedure TNxAlertWindow.SetHeaderSize(const Value: Integer);
begin
  FHeaderSize := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetOptions(const Value: TAlertOptions);
begin
  FOptions := Value;
  AdjustSize;
  Invalidate;
end;

procedure TNxAlertWindow.SetOptionsText(const Value: string);
begin
  FOptionsText := Value;
  AdjustSize;
  Invalidate;
end;

procedure TNxAlertWindow.SetSmallGlyph(const Value: TNxGlyphSettings);
begin
  FSmallGlyph.Assign(Value);
  Invalidate;
end;

procedure TNxAlertWindow.SetTextMargins(const Value: TNxMargins);
begin
  FTextMargins.Assign(Value);
end;

procedure TNxAlertWindow.SetVerticalAlignment(const Value: TVerticalAlignment);
begin
  FVerticalAlignment := Value;
  Invalidate;
end;

procedure TNxAlertWindow.SetWordWrap(const Value: Boolean);
begin
  FWordWrap := Value;
  AdjustSize;
  Invalidate;
end;

procedure TNxAlertWindow.DoDelayTimer(Sender: TObject);
var
  CursorPos: TPoint;
begin
  GetCursorPos(CursorPos);
  CursorPos := ScreenToClient(CursorPos);
  if not PtInRect(ClientRect, CursorPos) then
  begin
    FFullOpen := False;
    FAlertDirection := adDown;
    FPopupTimer.Enabled := True;
  end;
end;

procedure TNxAlertWindow.DoPopupTimer(Sender: TObject);
var
	Delta, h, Y, Sound: Integer;
  TaskbarRect: TRect;
  TaskbarPosition: Integer;
begin
  Delta := 0;
  TaskbarPosition := FindTaskbar(TaskbarRect);
  case TaskbarPosition of
    ABE_BOTTOM, ABE_TOP: Delta := TaskbarRect.Bottom - TaskbarRect.Top;
    ABE_LEFT, ABE_RIGHT: Delta := TaskbarRect.Right - TaskbarRect.Left;
  end;

  case FAlertDirection of
    adUp:
      if Height + 5 >= FRealHeight then { full open }
      begin
        case TaskbarPosition of
          ABE_BOTTOM, ABE_LEFT, ABE_RIGHT:
          begin
            SetWindowPos(Handle, HWND_TOPMOST, GetPopupLeft,
              (Screen.Height - delta) - FRealHeight - FIndent, Width, FRealHeight, SWP_SHOWWINDOW);
          end;
          ABE_TOP:
          begin
            SetWindowPos(Handle, HWND_TOPMOST, GetPopupLeft,
              TaskbarRect.Bottom + FIndent, Width, FRealHeight, SWP_SHOWWINDOW);
          end;
        end;

        FPopupTimer.Enabled := False;
        FDelayTimer.Enabled := FCloseDelay <> -1;
        FFullOpen := True;
        DoPopup;
        if FPopupSound <> msNone then { play sound }
        begin
          Sound := 0;
          case FPopupSound of
            msIconAsterisk: Sound := MB_ICONASTERISK;
            msIconExclamation: Sound := MB_ICONEXCLAMATION;
            msIconHand: Sound := MB_ICONHAND;
            msIconQuestion: Sound := MB_ICONQUESTION;
            msOk: Sound := MB_OK;
          end;
          MessageBeep(Sound);
        end;
      end else
      begin { in progress }
        case TaskbarPosition of
          ABE_BOTTOM, ABE_LEFT, ABE_RIGHT:
          begin
            h := Height + 5;
            Y := TaskbarRect.Top - h - FIndent;
          end;
          else {ABE_TOP}
          begin
            h := Height + 5;
            Y := TaskbarRect.Bottom + FIndent;
          end
        end;
        SetWindowPos(Handle, HWND_TOPMOST, GetPopupLeft, Y,
          Width, h, SWP_SHOWWINDOW);
      end;
    adDown:
      if Height <= 0 then
      begin
        DoClose;
      end else
      begin
        case TaskbarPosition of
          ABE_BOTTOM, ABE_LEFT, ABE_RIGHT:
          begin
            h := Height - 5;
            Y := TaskbarRect.Top - h - FIndent;
          end;
          else {ABE_TOP}
          begin
            h := Height - 5;
            Y := TaskbarRect.Bottom + FIndent;
          end;
        end;
        SetWindowPos(Handle, HWND_TOPMOST, GetPopupLeft, Y,
          Width, h, SWP_SHOWWINDOW);
      end;
  end; { case }
end;

procedure TNxAlertWindow.DoTextMarginsChange(Sender: TObject);
begin
  AdjustSize;
  Invalidate;
end;

procedure TNxAlertWindow.DrawCloseButton(Rect: TRect);
var
  FBitmap: TBitmap;
begin
  if btHover in FCloseButtonState then
  begin
    FBitmap := FCloseGlyph.HoverGlyph;
  end else
  begin
    FBitmap := FCloseGlyph.NormalGlyph;
  end;
  if not FBitmap.Empty then ApplyBitmap(Canvas, Rect.Left, Rect.Top, FBitmap);
end;

procedure TNxAlertWindow.DrawHeader(Rect: TRect);
var
  FromColor, ToColor: TColor;
  PaintRect: TRect;
begin
  PaintRect := Rect;
  Dec(PaintRect.Bottom, 2);
  with Canvas do
  begin
    case FBackgroundStyle of
      btSolid: FillRect(PaintRect);
      btAuto:
      begin
        FromColor := GetFillColor;
        ToColor := clWhite;
        DrawVertGradient(Canvas, PaintRect, FromColor, ToColor);
      end;
      btCustom:
      if csDesigning in ComponentState then
      begin
        Brush.Color := clBtnFace;
        FillRect(PaintRect);
      end else DoCustomDrawHeader(PaintRect);
    end;
    Pen.Color := GetFillColor;
    Polyline([Point(2, PaintRect.Bottom),
      Point(ClientWidth - 2, PaintRect.Bottom)]);
    Pen.Color := clWhite;
    Polyline([Point(2, PaintRect.Bottom + 1),
      Point(ClientWidth - 2, PaintRect.Bottom + 1)]);
  end;
end;

procedure TNxAlertWindow.DrawHeaderContent(Rect: TRect);
var
  X, Y: Integer;
begin
  with Canvas do
  begin
    { Draw Text }
    X := 5;
    Font.Assign(FHeaderFont);
    Y := Rect.Top + FHeaderSize div 2 - FSmallGlyph.NormalGlyph.Height div 2 - 1;
    if Assigned(SmallGlyph) then
    begin
      ApplyBitmap(Canvas, X, Y, SmallGlyph.NormalGlyph);
    end;
    DrawTextRect(Canvas, Types.Rect(10 + FSmallGlyph.NormalGlyph.Width, 2, ClientWidth, HeaderSize + 2), Caption, BiDiMode);
  end;
end;

procedure TNxAlertWindow.DrawMessage(Rect: TRect);
var
  I, r, d: Integer;
begin
  D := FFixedHeight - HeaderSize;
  with Canvas do
  begin
    case FBackgroundStyle of
      btSolid: FillRect(Rect);
      btAuto:
        for i := Rect.Top to Rect.Bottom do
        begin
          r := Abs((d div 2) - I);
          Pen.Color := TGraphicsProvider.BlendColor(Color, GetFillColor, (r / d) * 0.5);
          MoveTo(Rect.Left, I);
          LineTo(Rect.Right, I);
        end;
      btCustom:
        if csDesigning in ComponentState then
        begin
          Brush.Color := clBtnFace;
          FillRect(Rect);
        end;
    end;
    DoCustomDrawMessage(Rect);
  end;
end;

procedure TNxAlertWindow.DrawMessageContent(Rect: TRect);
var
  D, X, Y: Integer;
  FramedRect: TRect;
  WrapKind: TWrapKind;
begin
  D := FFixedHeight - HeaderSize;
  X := 0;
  Y := 0;
  case FGlyphPosition of
    gpLeft:
    begin
      X := 10;
      Y := FHeaderSize + ((d div 2) - (LargeGlyph.NormalGlyph.Height div 2));
    end;
    gpLeftTop:
    begin
      X := 10;
      Y := GetTextRect.Top;
    end;
    gpTop:
    begin
      X := ClientWidth div 2 - LargeGlyph.NormalGlyph.Width div 2;
      Y := FHeaderSize + 5;
    end;
  end;
  if Assigned(LargeGlyph.NormalGlyph) then ApplyBitmap(Canvas, X, Y, LargeGlyph.NormalGlyph);
  with Canvas do
  begin
    if csDesigning in ComponentState then
    begin
      FramedRect := GetTextRect;
      Pen.Color := clGrayText;
      Pen.Style := psDot;
      Brush.Style := bsClear;
      Rectangle(FramedRect);
      Brush.Style := Graphics.bsSolid;
      Pen.Style := psSolid;
    end;
    Font.Assign(Self.Font);
    if aoHtmlText in Options then
    begin
      ProcessHTML(Canvas, GetTextRect, Text, Point(0, 0), Indent(0, 0), rtDraw, wkWordWrap);
    end else
    begin
      if WordWrap then WrapKind := wkWordWrap
        else WrapKind := wkNone;
      DrawFmtText(Canvas, GetTextRect, Text, Alignment, VerticalAlignment, WrapKind, BiDiMode);
    end;
  end;
end;

procedure TNxAlertWindow.DoCloseClick;
begin
  if Assigned(FOnCloseClick) then FOnCloseClick(Self);
end;

procedure TNxAlertWindow.DoClose;
begin
  FAlertDirection := adNone;

  //  FInProgress := False; { Bojan: Original position, moved bellow }

  FPopupTimer.Enabled := False;
  FDelayTimer.Enabled := False;

  ShowWindow(Handle, SW_HIDE);

  Height := FRealHeight;

  FInProgress := False;

  { remove occupied space }
  RemoveIndent(FIndent + FFixedHeight);

  { trigger event }
  if Assigned(FOnClose) then FOnClose(Self);

  { used for NxAlertList }
  if Assigned(FOnClosing) then FOnClosing(Self);
end;

procedure TNxAlertWindow.DoCustomDrawHeader(DrawRect: TRect);
begin
  if Assigned(FOnCustomDrawHeader) then FOnCustomDrawHeader(Self, DrawRect);
end;

procedure TNxAlertWindow.DoCustomDrawMessage(DrawRect: TRect);
begin
  if Assigned(FOnCustomDrawMessage) then FOnCustomDrawMessage(Self, DrawRect);
end;

procedure TNxAlertWindow.DoGlyphChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxAlertWindow.DoHeaderFontChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxAlertWindow.DoOptionsClick;
begin
  if Assigned(FOnOptionsClick) then FOnOptionsClick(Self);
end;

procedure TNxAlertWindow.DoPopup;
begin
  if Assigned(FOnPopup) then FOnPopup(Self);
end;

procedure TNxAlertWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ButtonState: TButtonState;
  TagValue: WideString;
begin
  inherited;
  if aoHtmlText in Options then
  begin
    TagValue := ProcessHTML(Canvas, GetTextRect, Text, Point(X - GetTextRect.Left, Y - GetTextRect.Top), Indent(0, 0), rtMouse, wkWordWrap).TagValue;
    if TagValue <> '' then Screen.Cursor := crHandPoint else Screen.Cursor := Cursor;
  end;
  ButtonState := FCloseButtonState;
  case PtInRect(GetCloseButtonRect, Point(X, Y)) of
    True:  Include(ButtonState, btHover);
    False: Exclude(ButtonState, btHover);
  end;
  SetCloseButtonState(ButtonState);
end;

procedure TNxAlertWindow.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  TagValue: WideString;
begin
  inherited;
  if aoOptionsLink in Options then
  begin
    if PtInRect(GetOptionsTextRect, Point(X, Y)) then DoOptionsClick;
  end;
  if aoHtmlText in Options then
  begin
    TagValue := ProcessHTML(Canvas, GetTextRect, Text, Point(X - GetTextRect.Left, Y - GetTextRect.Top), Indent(0, 0), rtMouse, wkWordWrap).TagValue;
    if TagValue <> '' then DoLinkClick(TagValue);
  end;
  if aoCloseButton in Options then
  begin
    if PtInRect(GetCloseButtonRect, Point(X, Y)) then
    begin
      DoCloseClick;
      DoClose;
    end;
  end;
end;

procedure TNxAlertWindow.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TNxAlertWindow.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxAlertWindow.WMSize(var Message: TWMSize);
begin
  AdjustSize;
end;

procedure TNxAlertWindow.Close;
begin
  FAlertDirection := adDown;
  FPopupTimer.Enabled := True;
end;

procedure TNxAlertWindow.Popup;
var
  AIndent: Integer;
begin
  FPreparing := True;

  ShowWindow(Handle, SW_HIDE);
	if not(FAlertDirection = adNone) then
  begin
    Height := FRealHeight; { reset height }
	  FAlertDirection := adNone;
  end else FRealHeight := Height;

  FFullOpen := False;
	FPopupTimer.Enabled := False;
 	FFixedHeight := Height;

  { if there are more alert windows }
  if not FInProgress then
  begin
    AIndent := GetHighestIndent;
    FIndent := AIndent;
    AddIndent(FIndent + FFixedHeight);
  end;

  FCloseButtonState := [];

  FPreparing := False;

 	FInProgress := True; { Bojan: Moved here since Heigh is changed }
  Height := 0;

  FAlertDirection := adUp;

  { enable showing timer }
  FPopupTimer.Enabled := True;
end;

procedure TNxAlertWindow.Paint;
var
  BorderRect: TRect;
begin
  inherited;
  if csDesigning in ComponentState then FFixedHeight := Height;
	with Canvas do
  begin
    BorderRect := ClientRect;
    BorderRect.Bottom := FFixedHeight;
    Brush.Color := Lighten(GetFillColor, -53);

    FrameRect(BorderRect);
    InflateRect(BorderRect, -1, -1);
    Brush.Color := clWhite;
    FrameRect(BorderRect);

    DrawHeader(GetHeaderRect);
    DrawHeaderContent(GetHeaderRect);
    DrawMessage(Rect(2, FHeaderSize + 2, ClientWidth - 2, FFixedHeight - 2));
    DrawMessageContent(Rect(2, FHeaderSize + 2, ClientWidth - 2, FFixedHeight - 2));

    if aoOptionsLink in Options then
    begin
      Font.Color := clHighlight;
      TGraphicsProvider.DrawTextRect(Canvas, GetOptionsTextRect, taLeftJustify, FOptionsText);
    end;

    if aoCloseButton in Options then DrawCloseButton(GetCloseButtonRect);
  end;
end;

procedure TNxAlertWindow.RedrawBorder;
var
  DC: HDC;
  HighlightPen, ShadowPen, HighlightPen2, ShadowPen2: HPEN;
  R: TRect;
begin
  DC := GetWindowDC(Handle);
  HighlightPen := CreatePen(PS_SOLID, 1, $00cfb4a6);
  ShadowPen := CreatePen(PS_SOLID, 1, $00905645);
  HighlightPen2 := CreatePen(PS_SOLID, 1, $00ffffff);
  ShadowPen2 := CreatePen(PS_SOLID, 1, $00f4decf);
  try
    GetWindowRect(Handle, R);
    OffsetRect(R, -R.Left, -R.Top);
    { Highlight 1 }
    SelectObject(DC, HighlightPen);
    MoveToEx(DC, R.Left, R.Bottom - 1, nil);
    LineTo(DC, R.Left, R.Top);
    LineTo(DC, R.Right - 1, R.Top);
    { Shadow 1 }
    SelectObject(DC, ShadowPen);
    LineTo(DC, R.Right - 1, R.Bottom - 1);
    LineTo(DC, R.Left, R.Bottom - 1);
    { Highlight 2 }
    SelectObject(DC, HighlightPen2);
    MoveToEx(DC, R.Left + 1, R.Bottom - 3, nil);
    LineTo(DC, R.Left + 1, R.Top + 1);
    LineTo(DC, R.Right - 2, R.Top + 1);
    { Shadow 2 }
    SelectObject(DC, ShadowPen2);
    LineTo(DC, R.Right - 2, R.Bottom - 2);
    LineTo(DC, R.Left, R.Bottom - 2);
  finally
    DeleteObject(HighlightPen);
    DeleteObject(ShadowPen);
    DeleteObject(HighlightPen2);
    DeleteObject(ShadowPen2);
    ReleaseDC(Handle, DC);
  end;
end;

procedure TNxAlertWindow.SetGlyphs;
begin
  with FCloseGlyph do
  begin
    NormalGlyph.LoadFromResourceName(HInstance, 'ALERTCLOSE');
    HoverGlyph.LoadFromResourceName(HInstance, 'ALERTCLOSEHOVER');
    TransparentColor := clLime;
    Transparent := True;
  end;
end;

function TNxAlertWindow.FindTaskbar(var ARect: TRect): Integer;
var
	AppData: TAppBarData;
begin
	AppData.Hwnd := FindWindow('Shell_TrayWnd', nil);
  AppData.cbSize := SizeOf(TAppBarData);
  if SHAppBarMessage(ABM_GETTASKBARPOS, AppData) = 0 then
  begin
    Result := ABE_BOTTOM;
    ARect := Rect(0, Screen.Height, Screen.Width, Screen.Height);
  end else
  begin
    Result := AppData.uEdge;
    ARect := AppData.rc;
  end;
end;

function TNxAlertWindow.GetHeaderRect: TRect;
begin
  Result := Rect(2, 2, ClientWidth - 2, 2 + FHeaderSize);
end;

function TNxAlertWindow.GetPopupLeft: Integer;
begin
  Result := 0;
  case FPopupLocation of
    plLeft: Result := 16;
    plRight: Result := (Screen.Width - Width) - 16
  end;
end;

function TNxAlertWindow.GetTextRect: TRect;
begin
  Result := Rect(2, FHeaderSize + 2, ClientWidth - 2, ClientHeight - 2);
  with Result do
  begin
    Left := 2 + FTextMargins.Left;
    Top := 2 + FHeaderSize + FTextMargins.Top;
    Right := ClientWidth - (2 + FTextMargins.Right);
    Bottom := FFixedHeight - (2 + FTextMargins.Bottom);
  end;
end;

procedure TNxAlertWindow.Popup(const Text: WideString; CloseDelay: Integer = 0);
begin
  if Text <> '' then FText := Text;
  if CloseDelay <> 0 then FCloseDelay := CloseDelay;
  Popup;
end;

procedure TNxAlertWindow.SetText(const Value: WideString);
begin
  FText := Value;
  AdjustSize;
  Invalidate;
end;

procedure TNxAlertWindow.DoLinkClick(Href: WideString);
begin
  if Assigned(OnLinkClick) then OnLinkClick(Self, Href);
end;

procedure TNxAlertWindow.Popup(const AFormat: string;
  const Args: array of const);
begin
  Popup(Format(AFormat, Args));
end;

procedure TNxAlertWindow.AdjustSize;
var
  ANewHeight: Integer;
  AHtmlInfo: THtmlInfo;
begin
  if FPreparing or FInProgress or FAutoResizing then Exit;

  if aoAutoSize in FOptions then
  begin
    FAutoResizing := True;

    ANewHeight := FTextMargins.Top + FTextMargins.Bottom;
    Inc(ANewHeight, FHeaderSize);
    if aoHtmlText in Options then
    begin
      AHtmlInfo := ProcessHTML(Canvas, GetTextRect, Text, Point(0, 0), Indent(0, 0), rtMouse, wkWordWrap);
      Inc(ANewHeight, AHtmlInfo.Size.cy);
    end else
    begin
      if WordWrap then
      begin
        Inc(ANewHeight, GetTextSize(Canvas, GetTextRect, Text).cy);
      end else Inc(ANewHeight, Canvas.TextHeight(Text));
    end;
    if aoOptionsLink in Options then Inc(ANewHeight, Canvas.TextHeight(FOptionsText));

    if ANewHeight <> Height then Height := ANewHeight;

    FAutoResizing := False;
  end;
end;

procedure TNxAlertWindow.Assign(Source: TPersistent);
begin
  if Source is TNxAlertWindow then
  begin
    AdaptiveColors := TNxAlertWindow(Source).AdaptiveColors;
    Alignment := TNxAlertWindow(Source).Alignment;
    BackgroundStyle := TNxAlertWindow(Source).BackgroundStyle;
    Caption := TNxAlertWindow(Source).Caption;
    CloseDelay := TNxAlertWindow(Source).CloseDelay;
    CloseGlyph.Assign(TNxAlertWindow(Source).CloseGlyph);
    ForegroundColor := TNxAlertWindow(Source).ForegroundColor;
    GlyphPosition := TNxAlertWindow(Source).GlyphPosition;
    HeaderFont.Assign(TNxAlertWindow(Source).HeaderFont);
    HeaderSize := TNxAlertWindow(Source).HeaderSize;
    Height := TNxAlertWindow(Source).Height;
    LargeGlyph.Assign(TNxAlertWindow(Source).LargeGlyph);
    Options := TNxAlertWindow(Source).Options;
    OptionsText := TNxAlertWindow(Source).OptionsText;
    PopupLocation := TNxAlertWindow(Source).PopupLocation;
    PopupSound := TNxAlertWindow(Source).PopupSound;
    SmallGlyph.Assign(TNxAlertWindow(Source).SmallGlyph);
    Text := TNxAlertWindow(Source).Text;
    TextMargins.Assign(TNxAlertWindow(Source).TextMargins);
    VerticalAlignment := TNxAlertWindow(Source).VerticalAlignment;
    Width := TNxAlertWindow(Source).Width;
    WordWrap := TNxAlertWindow(Source).WordWrap;

    OnClick := TNxAlertWindow(Source).OnClick;
    OnClose := TNxAlertWindow(Source).OnClose;
    OnCloseClick := TNxAlertWindow(Source).OnCloseClick;
    OnCustomDrawHeader := TNxAlertWindow(Source).OnCustomDrawHeader;
    OnCustomDrawMessage := TNxAlertWindow(Source).OnCustomDrawMessage;
    OnLinkClick := TNxAlertWindow(Source).OnLinkClick;
    OnOptionsClick := TNxAlertWindow(Source).OnOptionsClick;
    OnPopup := TNxAlertWindow(Source).OnPopup;
  end else inherited;
end;

{ TNxMargins }

function TNxMargins.AsRect(Width, Height: Integer): TRect;
begin
  Result := Rect(FLeft, FTop, Width - FRight, Height - FBottom);
end;

procedure TNxMargins.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxMargins then
  begin
    Bottom := TNxMargins(Source).Bottom;
    Right := TNxMargins(Source).Right;
  end;
end;

constructor TNxMargins.Create;
begin
  inherited;
  FBottom := 0;
  FRight := 0;
end;

procedure TNxMargins.SetBottom(const Value: Integer);
begin
  FBottom := Value;
  DoChange;
end;

procedure TNxMargins.SetRect(ALeft, ATop, ARight, ABottom: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FRight := ARight;
  FBottom := ABottom;
  DoChange;
end;

procedure TNxMargins.SetRight(const Value: Integer);
begin
  FRight := Value;
  DoChange;
end;

{ TNxFlipContainer }

constructor TNxFlipContainer.Create(AOwner: TComponent);
begin
	inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csSetCaption, csReplicatable];
  AutoScroll := True;
  BorderWidth := 2;
  FBorderStyle := bsSingle;
  ParentColor := False;
  Color := clWindow;
  Width := 200;
  Height := 300;
end;

destructor TNxFlipContainer.Destroy;
begin
  inherited;

end;

procedure TNxFlipContainer.CollapseAll;
var
	i: Integer;
begin
	for i := 0 to ControlCount - 1 do
  	if Controls[i] is TNxFlipPanel then
		begin
		  TNxFlipPanel(Controls[i]).Expanded := False;
	  end;
end;

procedure TNxFlipContainer.ExpandAll;
var
	i: Integer;
begin
	for i := 0 to ControlCount - 1 do
  	if Controls[i] is TNxFlipPanel then
		begin
		  TNxFlipPanel(Controls[i]).Expanded := True;
			TNxFlipPanel(Controls[i]).ExpandAll;
  	end;
end;

function TNxFlipContainer.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := False;
  inherited DoMouseWheelDown(Shift, MousePos);
  VertScrollBar.Position := VertScrollBar.Position + 10;
end;

function TNxFlipContainer.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := False;
  inherited DoMouseWheelUp(Shift, MousePos);
  VertScrollBar.Position := VertScrollBar.Position - 10;
end;

procedure TNxFlipContainer.RedrawBorder;
var
  DC: HDC;
  R, R1: TRect;
  BR, BR2: HBRUSH;
begin
  DC := GetWindowDC(Handle);
  R := Rect(0, 0, Width, Height);
  GetWindowRect(Handle, R);
  OffsetRect(R, -R.Left, -R.Top);
  { drawing }
  case IsThemed of
    True:
    begin
		  R1 := R;
		  InflateRect(R1, -2, -2);
		  ExcludeClipRect(DC, R1.Left, R1.Top, R1.Right, R1.Bottom);
      ThemeRect(Handle, DC, R, teListView, 1, 0);
      ReleaseDC(Handle, DC);
    end;
    False:
    begin
      BR := CreateSolidBrush(ColorToRGB(clGrayText));
      BR2:= CreateSolidBrush(ColorToRGB(clBtnFace));
      try
        FrameRect(DC, R, BR);
        R1 := R;
        InflateRect(R1, -1, -1);
        FrameRect(DC, R1, BR2);
      finally
        DeleteObject(BR);
        DeleteObject(BR2);
        ReleaseDC(Handle, DC);
      end;
    end;
  end;
end;

procedure TNxFlipContainer.WMNCPaint(var Message: TMessage);
begin
  inherited;
  if BorderStyle = bsSingle then RedrawBorder;
end;

procedure TNxFlipContainer.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  case FBorderStyle of
    bsNone: BorderWidth := 0;
    bsSingle: BorderWidth := 2;
  end;
end;

{ TNxFlipPanel }

constructor TNxFlipPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks, csReplicatable];
  FAdaptiveColors := True;
  FAllowFlip := True;
  FAutoCollapse := False;
  FBackgroundColor := clBtnFace;
  FBackgroundStyle := bsSolid;
  FBorderColor := clBlack;
  FDrawDirection := diLeftToRight;
  FExpanded := True;
  FExpanding := False;
  FFlipKind := fkHeaderAndButton;
  FGlyph := TBitmap.Create;
  FHeaderColor := clBtnFace;
  FHeaderFont := TFont.Create;
  FHeaderFont.OnChange := DoHeaderFontChange;
  FHeaderFontUpdating := False;
  FHeaderHeight := sizFlipPanelHeaderSize;
  FHeaderStyle := hsSolid;
  FIndent := 4;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.OnChange := DoInnerMarginsChange;
  FMouseDown := False;
  FFullHeight := 0;
  FShowButtons := True;
  FShowGlyph := True;
  FExpandGlyph := TBitmap.Create;
  FExpandGlyph.LoadFromResourceName(HInstance, 'FLIPPLUS');
  FExpandGlyph.OnChange := DoBitmapsChange;
  FCollapseGlyph := TBitmap.Create;
  FCollapseGlyph.OnChange := DoBitmapsChange;
  FCollapseGlyph.LoadFromResourceName(HInstance, 'COLLAPSE');
  FParentHeaderFont := True;
  FTransparentButtons := False;
  FTransparentGlyph := False;
  ParentColor := False;
  Color := clWindow;
  Width := 200;
  Height := 200;
  SchemeNotification(Self);
end;

destructor TNxFlipPanel.Destroy;
begin
  FreeAndNil(FHeaderFont);
  FreeAndNil(FGlyph);
  FreeAndNil(FExpandGlyph);
  FreeAndNil(FCollapseGlyph);
  FreeAndNil(FInnerMargins);
  RemoveSchemeNotification(Self);  
  inherited;
end;

procedure TNxFlipPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  Inc(Rect.Left, FInnerMargins.Left);
  Inc(Rect.Top, FHeaderHeight + FInnerMargins.Top);
  Dec(Rect.Right, FInnerMargins.Right);
  Dec(Rect.Bottom, FInnerMargins.Bottom);
end;

procedure TNxFlipPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if csDesigning in ComponentState then
    	with WindowClass do Style := Style or CS_HREDRAW and not(CS_VREDRAW);
  end;
end;

procedure TNxFlipPanel.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('FullHeight', ReadFullHeight, WriteFullHeight, True);
end;

procedure TNxFlipPanel.CollapsePanels;
var
  i: Integer;
begin
  if FAutoCollapse then
    for i := 0 to Parent.ControlCount - 1 do
      if (Parent.Controls[i] is TNxFlipPanel)
        and (Parent.Controls[i] <> Self) then
      begin
        (Parent.Controls[i] as TNxFlipPanel).Expanded := False;
      end;
end;

procedure TNxFlipPanel.ReadFullHeight(Reader: TReader);
begin
  FFullHeight := Reader.ReadInteger;
end;

procedure TNxFlipPanel.WriteFullHeight(Writer: TWriter);
begin
  Writer.WriteInteger(FFullHeight);
end;

procedure TNxFlipPanel.ResizeParentFlip(Delta: Integer);
begin
  if Parent is TNxFlipPanel then
	begin
	  Parent.Height := Parent.Height + Delta;
    TNxFlipPanel(Parent).ResizeParentFlip(Delta);
	end;
end;

procedure TNxFlipPanel.SetAdaptiveColors(const Value: Boolean);
begin
  FAdaptiveColors := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetAutoCollapse(const Value: Boolean);
begin
  FAutoCollapse := Value;
end;

procedure TNxFlipPanel.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetBackgroundStyle(
  const Value: TFlipBackgroundStyle);
begin
  FBackgroundStyle := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetCaptionCollapsed(const Value: WideString);
begin
  FCaptionCollapsed := Value;
  if not Expanded then Invalidate;
end;

procedure TNxFlipPanel.SetCollapseGlyph(const Value: TBitmap);
begin
  FCollapseGlyph.Assign(Value);
end;

procedure TNxFlipPanel.SetExpanded(const Value: Boolean);
var
	r: TRect;
begin
	if Value = FExpanded then Exit;
  if not FAllowFlip then Exit;

  FExpanding := True;
  if Value then
  begin
    ResizeParentFlip(FFullHeight - Height);
    Height := FFullHeight;
  end else
  begin
    FFullHeight := Height;
    MinValue(FFullHeight, FHeaderHeight + FInnerMargins.Top);

    if not (csReading in ComponentState) then
    begin
      Height := FHeaderHeight + FInnerMargins.Top;
      ResizeParentFlip(Height - FFullHeight);
    end;
  end;

  FExpanded := Value;
  DoChange; { event }
  r := GetButtonRect;
  InvalidateRect(Handle, @r, False);
  { collapse all other panels }
  if Value then CollapsePanels;
  if Value then Realign;
  FExpanding := False;
end;

procedure TNxFlipPanel.SetExpandGlyph(const Value: TBitmap);
var
	r: TRect;
begin
  FExpandGlyph.Assign(Value);
  r := GetHeaderRect;
  InvalidateRect(Handle, @r, False);
end;

procedure TNxFlipPanel.SetHeaderColor(const Value: TColor);
var
	r: TRect;
begin
  FHeaderColor := Value;
  r := GetHeaderRect;
  InvalidateRect(Handle, @r, False);
end;

procedure TNxFlipPanel.SetHeaderFont(const Value: TFont);
begin
  FHeaderFont.Assign(Value);
  Invalidate;
end;

procedure TNxFlipPanel.SetHeaderHeight(const Value: Integer);
begin
  FHeaderHeight := Value;
  Realign;
  Invalidate;
end;

procedure TNxFlipPanel.SetHeaderStyle(const Value: THeaderStyle);
var
	r: TRect;
begin
  FHeaderStyle := Value;
  r := GetHeaderRect;
  InvalidateRect(Handle, @r, False);
end;

procedure TNxFlipPanel.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins := Value;
end;

procedure TNxFlipPanel.SetParentHeaderFont(const Value: Boolean);
begin
  if FParentHeaderFont <> Value then
  begin
    FParentHeaderFont := Value;
    FHeaderFontUpdating := True;
    if FParentHeaderFont then FHeaderFont.Assign(Font);
    FHeaderFontUpdating := False;
    Invalidate;
  end;
end;

procedure TNxFlipPanel.SetTransparentButtons(const Value: Boolean);
begin
  FTransparentButtons := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetTransparentGlyph(const Value: Boolean);
begin
  FTransparentGlyph := Value;
  FGlyph.Transparent := Value;
  if Value then
  begin
    FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
  end;
  Invalidate;
end;

procedure TNxFlipPanel.SetShowButtons(const Value: Boolean);
begin
  FShowButtons := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetShowGlyph(const Value: Boolean);
begin
  FShowGlyph := Value;
  Invalidate;
end;

function TNxFlipPanel.GetBodyRect: TRect;
begin
  Result := Rect(0, FHeaderHeight, ClientWidth, ClientHeight); 
end;

function TNxFlipPanel.GetButtonRect: TRect;
var
  ButtonLeft: Integer;
begin
  ButtonLeft := 0;
  case FDrawDirection of
    diLeftToRight: ButtonLeft := FIndent;
    diRightToLeft: ButtonLeft := ClientWidth - FExpandGlyph.Width - 4;
  end;
  case IsThemed of
    True: with Result do
          begin
            Left := ButtonLeft;
            Top := HeaderHeight div 2 - (FExpandGlyph.Height div 2) - 1;
            Right := Left + FExpandGlyph.Width;
            Bottom := Top + FExpandGlyph.Height;
          end;
    False:  with Result do
            begin
              Left := ButtonLeft;
              Top := FHeaderHeight div 2 - 5;
              Right := Left + 9;
              Bottom := Top + 9;
            end;
  end;
end;

function TNxFlipPanel.GetHeaderRect: TRect;
begin
  Result := Rect(0, 0, ClientWidth, FHeaderHeight);
end;

procedure TNxFlipPanel.DoEnter;
begin
  inherited;

end;

procedure TNxFlipPanel.DoExit;
begin
  inherited;

end;

procedure TNxFlipPanel.DoHeaderFontChange(Sender: TObject);
begin
  if FHeaderFontUpdating then Exit;
  FParentHeaderFont := False;
  Invalidate;
end;

procedure TNxFlipPanel.DoBitmapsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxFlipPanel.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxFlipPanel.DoInnerMarginsChange(Sender: TObject);
begin
  Invalidate;
  Realign;
end;

procedure TNxFlipPanel.DrawPlusButton(X, Y: Integer);
  procedure DrawThemedExpandingButton;
  begin
  	if TransparentButtons then
    begin
      FCollapseGlyph.Transparent := True;
      FCollapseGlyph.TransparentColor := FCollapseGlyph.Canvas.Pixels[0, FCollapseGlyph.Height - 1];
      FExpandGlyph.Transparent := True;
      FExpandGlyph.TransparentColor := FExpandGlyph.Canvas.Pixels[0, FExpandGlyph.Height - 1];
    end;
  	if Expanded then TDrawProvider.ApplyBitmap(Canvas, X, Y, FCollapseGlyph)
	    else TDrawProvider.ApplyBitmap(Canvas, X, Y, FExpandGlyph);
  end;
  procedure DrawClassicExpandingButton;
  begin
    with Canvas do
	  begin
      Pen.Color := clBlack;
	    Brush.Color := clGrayText;
      FrameRect(Rect(X, Y, X + 9, Y + 9));
	    MoveTo(X + 2, Y + 4);
	    LineTo(X + 7, Y + 4);
	    if not Expanded then
	    begin
	      MoveTo(X + 4, Y + 2);
	      LineTo(X + 4, Y + 7);
	    end;
    end;
  end;

begin
 	if (IsThemed)
  	then DrawThemedExpandingButton
   	else DrawClassicExpandingButton;
end;

procedure TNxFlipPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FMouseDown := True;
  FOldX := X;
  FOldY := Y;
end;

procedure TNxFlipPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  
end;

procedure TNxFlipPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FMouseDown := False;
  if Button = mbLeft then
    case FFlipKind of
      fkButton: if (PtInRect(GetButtonRect, Point(X, Y)) and ShowButtons)
                          then Expanded := not Expanded;
      fkHeaderAndButton: if (PtInRect(GetHeaderRect, Point(X, Y)))
                          then Expanded := not Expanded;

    end;
end;

procedure TNxFlipPanel.Paint;
var
	r, CaptionRect, r1: TRect;
  X, ButtonLeft, GlyphLeft: Integer;
begin
	r := Rect(0, 0, ClientWidth, FHeaderHeight);
	with Canvas do
  begin
    Font.Assign(Self.Font);
    PaintHeader;

    if Focused then
    begin
      r1 := Rect(0, 0, ClientWidth, FHeaderHeight);
      TGraphicsProvider.DrawFocused(Canvas, r1);
    end;

    PaintBackground;
    Font.Assign(FHeaderFont);

    X := FIndent;

		CaptionRect := r;
    Inc(CaptionRect.Left, 2);

    { Draw Expand buttons }
    if ShowButtons then
    begin
      case FDrawDirection of
        diLeftToRight:
        begin
          ButtonLeft := X;
          Inc(X, FExpandGlyph.Width + 4);
        end;
        else { diRightToLeft }
        begin
          CaptionRect.Left := FIndent;
          ButtonLeft := ClientWidth - FExpandGlyph.Width - 4;
        end;
      end;
      case IsThemed of
        True: DrawPlusButton(ButtonLeft, FHeaderHeight div 2 - (FExpandGlyph.Height div 2) - 1);
        False: DrawPlusButton(ButtonLeft, FHeaderHeight div 2 - 5);
      end;
    end;

    { Draw Glyph }
    if not FGlyph.Empty and ShowGlyph then
    begin
      GlyphLeft := 0;
      case FDrawDirection of
        diLeftToRight: GlyphLeft := ClientWidth - FGlyph.Width - 2;
        diRightToLeft:
        begin
          GlyphLeft := X;
          Inc(X, FGlyph.Width + 2);
        end;
      end;
      ApplyBitmap(Canvas, GlyphLeft, FHeaderHeight div 2 - FGlyph.Height div 2, FGlyph);
    end;

    CaptionRect := r;
    CaptionRect.Left := X;
    if (CaptionCollapsed <> '') and not Expanded
      then DrawText(Canvas, CaptionRect, taLeftJustify, CaptionCollapsed, False)
      else DrawText(Canvas, CaptionRect, taLeftJustify, Caption, False);

    if (csDesigning in ComponentState) and Expanded then
    begin
      Brush.Color := clBtnFace;
			r1 := Rect(FInnerMargins.Left, FHeaderHeight + FInnerMargins.Top, ClientWidth - FInnerMargins.Right,
	      ClientHeight - FInnerMargins.Bottom);
      InflateRect(r1, 1, 1);
      FrameRect(r1);
    end;
  end;
end;

procedure TNxFlipPanel.PaintBackground;
var
  Shift, Pt: TPoint;
  DC: HDC;
begin
  case FBackgroundStyle of
    bsSolid:
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(GetBodyRect);
    end;
    bsVertGradient: DrawVertGradient(Canvas, GetBodyRect, Color, FBackgroundColor);
    bsTransparent:
      if (HeaderStyle <> hsTransparent) and (HeaderStyle <> hsVista) then
        if (Parent <> nil) then
          if Parent.HandleAllocated then
          begin                                   
            DC := Self.Canvas.Handle;
            Shift.X := 0;
            Shift.Y := 0;
            Shift := Parent.ScreenToClient(Self.ClientToScreen(Shift));
            SaveDC(DC);
            try
              OffsetWindowOrgEx(DC, Shift.X, Shift.Y, nil);
              GetBrushOrgEx(DC, Pt);
              SetBrushOrgEx(DC, Pt.X + Shift.X, Pt.Y + Shift.Y, nil);
              Parent.Perform(WM_ERASEBKGND, WParam(DC), 0);
              Parent.Perform(WM_PAINT, WParam(DC), 0);
            finally
              RestoreDC(DC, -1);
            end;
          end;
        end;
end;

procedure TNxFlipPanel.PaintHeader;
var
  HeaderRect: TRect;
  FillColor, FromColor, ToColor: TColor;
begin
  with Canvas do
  begin
    if FAdaptiveColors then
    begin
	    case IsThemed of
  	    True: if Parent is TNxFlipPanel then Brush.Color := Color else Brush.Color := SchemeColor(seInactiveDockCaption, FColorScheme);
	      False: if Parent is TNxFlipPanel then Brush.Color := Color else Brush.Color := clBtnFace;
	    end;
    end else Brush.Color := FHeaderColor;
    HeaderRect := Rect(0, 0, ClientWidth, FHeaderHeight);
    case FHeaderStyle of
      hsAuto: if IsThemed
                then ThemeRect(Self.Handle, Handle, HeaderRect, 'explorerbar', 0, 1)
      				  else FillRect(Rect(0, 0, ClientWidth, FHeaderHeight));
      hsSolid: FillRect(Rect(0, 0, ClientWidth, FHeaderHeight));
      hsTopGradient:
      begin
        DrawVertGradient(Canvas, Rect(0, 0, ClientWidth, 4), Brush.Color, Self.Color);
        Brush.Color := Self.Color;
        FillRect(Rect(0, 4, ClientWidth, ClientHeight));
      end;
      hsGradient: TGraphicsProvider.DrawGradient(Canvas, Rect(0, 0, ClientWidth, FHeaderHeight), Self.Color, Canvas.Brush.Color);
      hsInverseGradient: TGraphicsProvider.DrawGradient(Canvas, Rect(0, 0, ClientWidth, FHeaderHeight), Canvas.Brush.Color, Self.Color);
      hsFadeAway: TGraphicsProvider.DrawVertGradient(Canvas, Rect(0, 0, ClientWidth, FHeaderHeight), Canvas.Brush.Color, Self.Color);
      hsTransparent: DrawTransparent(Self, Canvas);
      hsVista:
      begin
        Brush.Color := clBlack;
        FillRect(GetHeaderRect);
        DrawVertFade(Canvas, GetHeaderRect);
      end;
      hsOffice2007:
      begin
        FromColor := SchemeColor(seBtnFaceDark, ColorScheme);
        ToColor := SchemeColor(seBtnFace, ColorScheme);
        DrawVertGlass(Canvas, GetHeaderRect, FromColor, ToColor, FHeaderHeight div 2);
      end;
      hsWindowsLive:
      begin
        FrameRect(HeaderRect);
        InflateRect(HeaderRect, -1, -1);
        FillColor := Brush.Color;
        Brush.Color := Color;
        FrameRect(HeaderRect);
        InflateRect(HeaderRect, -1, -1);
        DrawVertShine(Canvas, HeaderRect, FillColor, Color, (HeaderRect.Bottom - HeaderRect.Top) div 2);
      end;
    end;
  end;
end;

procedure TNxFlipPanel.CMDialogChar(var Message: TCMDialogChar);
begin
  inherited;
  with Message do
  begin
    if IsAccel(CharCode, Caption) then
    begin
      Flip;
      Result := 1;
    end else inherited;
  end;
end;

procedure TNxFlipPanel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FHeaderFontUpdating := True;
  if FParentHeaderFont then FHeaderFont.Assign(Font);
  FHeaderFontUpdating := False;
end;

procedure TNxFlipPanel.CMMouseLeave(var Message: TMessage);
begin

end;

procedure TNxFlipPanel.CMTextChanged(var Message: TMessage);
begin
	Invalidate;
end;

procedure TNxFlipPanel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;  
end;

procedure TNxFlipPanel.WMSize(var Message: TWMSize);
begin
  inherited;
  { 6/6/07: If width go below FInnerMargins.Top + FHeaderHeight,
            set Expanded to False }
  if csReading in ComponentState then Exit;
{ -- causes a problems with big fonts -- 
  if FExpanding = False then
  begin
    if Height > FInnerMargins.Top + FHeaderHeight then
    begin
      FFullHeight := Height;
      Expanded := True;
    end else Expanded := False;
  end;
}
  if BackgroundStyle = bsVertGradient then RefreshBody;
end;

procedure TNxFlipPanel.WMWindowPosChanged(
  var Message: TWMWindowPosChanged);
begin
  inherited;
  if ((HeaderStyle = hsTransparent)
    or (HeaderStyle = hsVista)) and not FExpanding then Invalidate;
end;

procedure TNxFlipPanel.ExpandAll;
var
	i: Integer;
begin
	if Expanded then
		for i := 0 to ControlCount - 1 do
		  if Controls[i] is TNxFlipPanel then
	  	begin
		    TNxFlipPanel(Controls[i]).Expanded := True;
				TNxFlipPanel(Controls[i]).ExpandAll;
		  end;
end;

procedure TNxFlipPanel.CollapseAll;
var
	i: Integer;
begin
	for i := 0 to ControlCount - 1 do
  	if Controls[i] is TNxFlipPanel then
		begin
		  TNxFlipPanel(Controls[i]).Expanded := False;
		  TNxFlipPanel(Controls[i]).CollapseAll;
	  end;
end;

procedure TNxFlipPanel.SetFlipKind(const Value: TFlipKind);
begin
  FFlipKind := Value;
end;

procedure TNxFlipPanel.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

procedure TNxFlipPanel.Flip;
begin
  Expanded := not Expanded; 
end;

procedure TNxFlipPanel.RefreshBody;
var
  R: TRect;
begin
  R := GetBodyRect;
  InvalidateRect(Handle, @R, False);  
end;

procedure TNxFlipPanel.SetDrawDirection(const Value: TDirection);
begin
  FDrawDirection := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
  Invalidate;
end;

procedure TNxFlipPanel.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  RedrawBorder;
end;

procedure TNxFlipPanel.RedrawBorder;
var
  DC: HDC;
  R: TRect;
  BR: HBRUSH;
  i: Integer;
begin
	inherited;
  DC := GetWindowDC(Handle);
  R := Rect(0, 0, Width, Height);
  GetWindowRect(Handle, R);
  OffsetRect(R, -R.Left, -R.Top);
  if AdaptiveColors then
  begin
    BR := CreateSolidBrush(ColorToRGB(SchemeColor(seBorder, FColorScheme)));
  end else BR := CreateSolidBrush(ColorToRGB(FBorderColor));
  for i := 1 to BorderWidth do
  begin
    FrameRect(DC, R, BR);
    InflateRect(R, -1, -1);
  end;
  DeleteObject(BR);
  ReleaseDC(Handle, DC);
end;

procedure TNxFlipPanel.WMNCPaint(var Message: TMessage);
begin
  inherited;
  RedrawBorder;
end;

procedure TNxFlipPanel.ChangeScale(M, D: Integer);
begin
  inherited;
  FFullHeight := FFullHeight * M div D;
  FHeaderHeight := FHeaderHeight * M div D;
  Height := Height * M div D;
  FInnerMargins.Top := FInnerMargins.Top * M div D;
end;

{ TNxLinkLabel }

constructor TNxLinkLabel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents, csSetCaption,
    csDoubleClicks, csReplicatable];
  DoubleBuffered := True;
  AutoSize := True;
  FDisplayMode := dmGlyph;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FImageIndex := -1;
  FImages := nil;
  FTransparentColor := clNone;
  FHover := False;
  FHoverColor := Font.Color;
  FTextDistance := 2;
  FTransparent := False;
  FVertSpacing := 2;
  ParentColor := True;
end;

destructor TNxLinkLabel.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

function TNxLinkLabel.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
var
  ANewWidth, ANewHeight: Integer;
begin
  Result := True;
  MakeAutoSize(ANewWidth, ANewHeight);
  if Align in [alNone, alLeft, alRight] then
    NewWidth := ANewWidth;
  if Align in [alNone, alTop, alBottom] then
    NewHeight := ANewHeight;
end;

procedure TNxLinkLabel.Changed;
begin
  if AutoSize then AdjustSize
    else Invalidate;
end;

procedure TNxLinkLabel.CreateParams(var Params: TCreateParams);
begin
  inherited;

end;

procedure TNxLinkLabel.CreateWnd;
begin
  inherited;

end;

procedure TNxLinkLabel.ApplyTransparentColor(const Value: TColor);
begin
  FGlyph.Transparent := True;
  FGlyph.TransparentColor := Value;
end;

procedure TNxLinkLabel.MakeAutoSize(var NewWidth: Integer; var NewHeight: Integer);
begin
  if HandleAllocated then
  begin
    Canvas.Font.Assign(Font);
    NewHeight := Canvas.TextHeight(Caption);
    NewWidth := Canvas.TextWidth(Caption) + 1;
    case FDisplayMode of
      dmGlyph:
        if not Glyph.Empty then with Canvas do
        begin
          if FGlyph.Height > NewHeight then NewHeight := FGlyph.Height;
          Inc(NewWidth, FGlyph.Width + FTextDistance);
        end;
      dmImageList:
        if Assigned(FImages) and InRange(FImageIndex, 0, FImages.Count) then
        begin
          if FImages.Height > NewWidth then NewHeight := FImages.Height;
          Inc(NewWidth, FImages.Width + FTextDistance);
        end;
    end;
    NewHeight := NewHeight + FVertSpacing;
  end;
end;

procedure TNxLinkLabel.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Changed;
end;

procedure TNxLinkLabel.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  ApplyTransparentColor(FTransparentColor);
end;

procedure TNxLinkLabel.SetTextDistance(const Value: Integer);
begin
  FTextDistance := Value;
  Changed;
end;

procedure TNxLinkLabel.SetVertSpacing(const Value: Integer);
begin
  FVertSpacing := Value;
  Changed;
end;

procedure TNxLinkLabel.DoEnter;
begin
  inherited;
  Invalidate;
end;

procedure TNxLinkLabel.DoExit;
begin
  inherited;
  Invalidate;
end;

procedure TNxLinkLabel.DoGlyphChange(Sender: TObject);
begin
  ApplyTransparentColor(FGlyph.Canvas.Pixels[0, FGlyph.Height - 1]);
  Changed;
end;

procedure TNxLinkLabel.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RefreshText;
end;

procedure TNxLinkLabel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FHoverColor := Font.Color;
  Changed;
end;

procedure TNxLinkLabel.CMMouseEnter(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) then
  begin
    FHover := True;
    RefreshText;
  end;
end;

procedure TNxLinkLabel.CMMouseLeave(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) then
  begin
    FHover := False;
    RefreshText;
  end;
end;

procedure TNxLinkLabel.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
  Realign;
end;

procedure TNxLinkLabel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxLinkLabel.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  Invalidate;
end;

procedure TNxLinkLabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if TabStop then
  begin
    SetFocus;
    Invalidate;
  end;
end;

procedure TNxLinkLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages) then FImages := nil;
end;

procedure TNxLinkLabel.Paint;
var
	X, Y: Integer;
  fr: TRect;
begin
  inherited;
	X := 0;
  with Canvas do
  begin
    Font.Assign(Self.Font);
    if Transparent then DrawTransparent(Self, Canvas) else
    begin
      Brush.Color := Self.Color;
      FillRect(ClientRect);
    end;
    case FDisplayMode of
      dmGlyph:
      if not(FGlyph.Empty) then
      begin
      	Y := (Height div 2) - (FGlyph.Height div 2);
        FGlyph.Transparent := True;
        ApplyBitmap(Canvas, X, Y, FGlyph);
        Inc(X, FGlyph.Width + FTextDistance);
      end;
      dmImageList: if Assigned(FImages) and
        InRange(FImageIndex, 0, FImages.Count) then
      begin
      	Y := (Height div 2) - (Images.Height div 2);
        FGlyph.Transparent := True;
        FImages.Draw(Canvas, X, Y, FImageIndex);
        Inc(X, FImages.Width + FTextDistance);
      end;
    end;
    if FHover then
    begin
      Font.Style := Font.Style + [fsUnderline];
      Font.Color := FHoverColor;
    end;
    if not Enabled then Font.Color := clGrayText;
    TGraphicsProvider.DrawTextRect(Canvas, Rect(X, 0, Width, Height), taLeftJustify, Caption);
    fr := Rect(0, 0, Width, Height);
    if Focused then TGraphicsProvider.DrawFocused(Canvas, fr);
  end;
end;

procedure TNxLinkLabel.RefreshText;
var
  r: TRect;
begin
  if not(FGlyph.Empty) then r := Rect(FGlyph.Width + FTextDistance, 0, ClientWidth, ClientHeight) else r := ClientRect;
  InvalidateRect(Handle, @r, False);
end;

procedure TNxLinkLabel.SetName(const Value: TComponentName);
begin
  inherited;
  if not (csLoading in ComponentState) then
    if Caption = '' then Caption := Name;
end;

procedure TNxLinkLabel.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  if Value <> nil then
  begin
    FImages.FreeNotification(Self);
  end else
  begin
    FImages.RemoveFreeNotification(Self);
  end;
end;

procedure TNxLinkLabel.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Changed;
end;

procedure TNxLinkLabel.SetDisplayMode(const Value: TLinkLabelDisplayMode);
begin
  FDisplayMode := Value;
  Changed;
end;

procedure TNxLinkLabel.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Invalidate;
end;

procedure TNxLinkLabel.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  Invalidate;
end;

procedure TNxLinkLabel.WMWindowPosChanged(
  var Message: TWMWindowPosChanged);
begin
  inherited;
  if Transparent then Invalidate;
end;

procedure TNxLinkLabel.SetHoverColor(const Value: TColor);
begin
  FHoverColor := Value;
end;

{ TNxHtmlLabel }

procedure TNxHtmlLabel.AdjustBounds;
var
  HtmlInfo: THtmlInfo;
  NewWidth, NewHeight: Integer;
begin
  if not (csReading in ComponentState) and AutoSize then
  begin
    HtmlInfo := ProcessHTML(Canvas, ClientRect, Caption, Point(0, 0), Indent(0, 0), rtMeasure, wkWordWrap);
    NewWidth := HtmlInfo.Size.cx;
    NewHeight := HtmlInfo.Size.cy;
    Height := NewHeight;
    Width := NewWidth;
  end;
end;

function TNxHtmlLabel.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
var
  HtmlInfo: THtmlInfo;
begin
  inherited CanAutoSize(NewWidth, NewHeight);
  Result := True;
  HtmlInfo := ProcessHTML(Canvas, ClientRect, Caption, Point(0, 0), Indent(0, 0), rtMeasure, wkWordWrap);
  NewWidth := HtmlInfo.Size.cx;
  NewHeight := HtmlInfo.Size.cy;
end;

procedure TNxHtmlLabel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if Screen.Cursor = crHandPoint then Screen.Cursor := FCursor;
end;

constructor TNxHtmlLabel.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TNxHtmlLabel.Destroy;
begin

  inherited;
end;

function TNxHtmlLabel.GetTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TNxHtmlLabel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

procedure TNxHtmlLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  TagValue: WideString;
begin
  inherited;
  TagValue := ProcessHTML(Canvas, Self.ClientRect, Caption, Point(X, Y), Indent(0, 0), rtMouse, wkWordWrap).TagValue;
  if TagValue <> '' then Screen.Cursor := crHandPoint else Screen.Cursor := FCursor;
end;

procedure TNxHtmlLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  TagValue: WideString;
begin
  inherited;
  TagValue := ProcessHTML(Canvas, Self.ClientRect, Caption, Point(X, Y), Indent(0, 0), rtMouse, wkWordWrap).TagValue;
  if TagValue <> '' then if Assigned(OnLinkClick) then OnLinkClick(Self, TagValue);
end;

procedure TNxHtmlLabel.Paint;
begin
  inherited;
  with Canvas do
  begin
    Brush.Color := Color;
    if not Transparent then FillRect(ClientRect);
    Font.Assign(Self.Font);
  end;
  ProcessHTML(Canvas, ClientRect, Caption, Point(0, 0), Indent(0, 0), rtDraw, wkWordWrap);
end;

procedure TNxHtmlLabel.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
  AdjustBounds;
end;

procedure TNxHtmlLabel.SetTransparent(const Value: Boolean);
begin
  if Transparent <> Value then
  begin
    if Value then
      ControlStyle := ControlStyle - [csOpaque] 
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
  FTransparentSet := True;
end;

procedure TNxHtmlLabel.WMSetCursor(var Message: TWMSetCursor);
begin
  inherited;
  FCursor := Cursor;
end;

{ TNxSplitter }

constructor TNxSplitter.Create(AOwner: TComponent);
begin
  inherited;
  FAdaptiveColors := True;
  Width := 9;
  SchemeNotification(Self);
end;

destructor TNxSplitter.Destroy;
begin
  RemoveSchemeNotification(Self);
  inherited;
end;

procedure TNxSplitter.Paint;
var
  FromColor, ToColor: TColor;
  GradRect: TRect;
begin
 	with Canvas do
  begin
    if FAdaptiveColors then
    begin
      FromColor := SchemeColor(seSplitterGradientStart, FColorScheme);
      ToColor := SchemeColor(seSplitterGradientEnd, FColorScheme);
    end else
    begin
      FromColor := clWhite;
      ToColor := Color;
    end;

    case Align of
      alLeft, alRight:
      begin
        Pen.Color := clWhite;
        Polyline([Point(1, 0), Point(1, ClientHeight)]);

        Pen.Color := SchemeColor(seBorder, FColorScheme);
        Polyline([Point(0, 0), Point(0, ClientHeight)]);
        Polyline([Point(ClientWidth - 1, 0), Point(ClientWidth - 1, ClientHeight)]);

        GradRect := Rect(2, 0, ClientWidth - 1, ClientHeight);
        DrawHorzGradient(Canvas, GradRect, FromColor, ToColor);

        DrawGrips(Canvas, ClientRect, 5, orVertical, FColorScheme);
      end
      else begin
        Pen.Color := clWhite;
        Polyline([Point(0, 1), Point(ClientWidth, 1)]);

        Pen.Color := SchemeColor(seBorder, FColorScheme);
        Polyline([Point(0, 0), Point(ClientWidth, 0)]);
        Polyline([Point(0, ClientHeight - 1), Point(ClientWidth, ClientHeight - 1)]);

        GradRect := Rect(0, 2, ClientWidth, ClientHeight - 1);

        DrawVertGradient(Canvas, GradRect, FromColor, ToColor);

        DrawGrips(Canvas, ClientRect, 5, orHorizontal, FColorScheme);
      end;
    end;
  end;
end;

procedure TNxSplitter.SetAdaptiveColors(const Value: Boolean);
begin
  FAdaptiveColors := Value;
  Invalidate;
end;

procedure TNxSplitter.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
  Invalidate;
end;

procedure TNxSplitter.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

{ TNxGlyphButton }

constructor TNxGlyphButton.Create(AOwner: TComponent);
begin
	inherited;
  FAlignment := taLeftJustify;
  FAutoCheck := False;
  FBackgroundDrawStyle := bdsSkip;
  FBufferBitmap := TBitmap.Create;
  FChecked := False;
  FDown := False;
  FDisabledImage := TBitmap.Create;
  FDisabledImage.OnChange := DoImageChange;
  FDownImage := TBitmap.Create;
  FDownImage.OnChange := DoImageChange;
  FHoverImage := TBitmap.Create;
  FHoverImage.OnChange := DoImageChange;
  FHover := False;
  FImage := TBitmap.Create;
  FImage.OnChange := DoImageChange;
  FMargin := 2;
  Width := 75;
  Height := 23;
end;

destructor TNxGlyphButton.Destroy;
begin
  FreeAndNil(FBufferBitmap);
  FreeAndNil(FDisabledImage);
  FreeAndNil(FDownImage);
  FreeAndNil(FHoverImage);
  FreeAndNil(FImage);
  inherited;
end;

function TNxGlyphButton.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
begin
  Result := True;
  if Assigned(FImage) and not(csDesigning in ComponentState) or (FImage.Width > 0) and
    (FImage.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      NewWidth := FImage.Width;
    if Align in [alNone, alTop, alBottom] then
      NewHeight := FImage.Height;
  end;
end;

procedure TNxGlyphButton.DoImageChange(Sender: TObject);
begin
  if AutoSize then
    if Assigned(FImage) and not FImage.Empty then
    begin
      SetBounds(Left, Top, FImage.Width, FImage.Height);
      Invalidate;
    end;
  if Transparent then
	  with Sender as TBitmap do
	  begin
	    Transparent := True;
	    TransparentColor := Canvas.Pixels[0, Height - 1];
	  end;
end;

procedure TNxGlyphButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    FPressed := True;
	  Invalidate;
  end;
end;

procedure TNxGlyphButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FPressed := False;
  if (Button = mbLeft)
  	and (PtInRect(ClientRect, Point(X, Y))) then
  begin
	  if FAutoCheck then Checked := not Checked;
  end;
  Invalidate;
end;

procedure TNxGlyphButton.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TNxGlyphButton.SetAutoCheck(const Value: Boolean);
begin
  FAutoCheck := Value;
end;

procedure TNxGlyphButton.SetChecked(const Value: Boolean);
begin
  FChecked := Value;
  Invalidate;
end;

procedure TNxGlyphButton.SetDownImage(const Value: TBitmap);
begin
  FDownImage.Assign(Value);
end;

procedure TNxGlyphButton.SetHoverImage(const Value: TBitmap);
begin
  FHoverImage.Assign(Value);
end;

procedure TNxGlyphButton.SetImage(const Value: TBitmap);
begin
  FImage.Assign(Value);
end;

procedure TNxGlyphButton.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Invalidate;
end;

procedure TNxGlyphButton.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  DoImageChange(FImage);
  DoImageChange(FDownImage);
  DoImageChange(FHoverImage);
end;

procedure TNxGlyphButton.CMMouseEnter(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) then
  begin
    FHover := True;
    Invalidate;
  end;
end;

procedure TNxGlyphButton.CMMouseLeave(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) then
  begin
    FHover := False;
    Invalidate;
  end;
end;

procedure TNxGlyphButton.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TNxGlyphButton.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  if csDesigning in ComponentState then Message.Result := 0 else
  begin
  	if not Transparent then Message.Result := 1;
  end;
end;

procedure TNxGlyphButton.Paint;
var
	r1: TRect;
  procedure DrawButtonText;
  var
    tr: TRect;
  begin
    Canvas.Font.Assign(Self.Font);
    tr := ClientRect;
    InflateRect(tr, -Margin, 0);
    TGraphicsProvider.DrawTextRect(Canvas, tr, Alignment, Caption);
  end;
begin
  inherited;
  if FImage.Empty then
	begin
    Canvas.Pen.Color := clGrayText;
    Canvas.Pen.Style := psDot;
    Canvas.Rectangle(ClientRect);
    DrawButtonText;
	  Exit;
	end;
  case FBackgroundDrawStyle of
    bdsOpaque:
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(ClientRect);
    end;
    bdsTransparent: DrawTransparent(Self, Canvas);
  end;
	r1 := Rect(0, 0, FImage.Width, FImage.Height);
  FBufferBitmap.Width := FImage.Width;
  FBufferBitmap.Height := FImage.Height;
  FBufferBitmap.Canvas.CopyRect(r1, Canvas, r1);
  if Enabled then
  begin
    if Enabled then
    begin
      case FDown or FPressed or FChecked of
        True: FBufferBitmap.Canvas.Draw(0, 0, FDownImage);
        False:
        begin
          if FHover then FBufferBitmap.Canvas.Draw(0, 0, FHoverImage)
            else FBufferBitmap.Canvas.Draw(0, 0, FImage);
        end;
      end;
    end;
  end else FBufferBitmap.Canvas.Draw(0, 0, FDisabledImage);
  Canvas.CopyRect(r1, FBufferBitmap.Canvas, r1);
  DrawButtonText;
end;

procedure TNxGlyphButton.SetBackgroundDrawStyle(
  const Value: TBackgroundDrawStyle);
begin
  FBackgroundDrawStyle := Value;
  Invalidate;
end;

procedure TNxGlyphButton.SetDisabledImage(const Value: TBitmap);
begin
  FDisabledImage.Assign(Value);
  Invalidate;
end;

procedure TNxGlyphButton.SetDown(const Value: Boolean);
begin
  FDown := Value;
  Invalidate;
end;

{ TNxHeaderPanel }

constructor TNxHeaderPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks, csReplicatable];
  BorderWidth := 1;
  FAdaptiveColors := True;
  FBorderColor := clBlack;
  FBtnState := [];
  FCollapseWidth := szHeadCollapsedWidth;
  FDisplayStyle := dsNormal;
  FExpanded := True;
  FExpanding := False;
  FFullWidth := 0;
  FHeaderFont := TFont.Create;
  FHeaderMouseDown := False;
  FHeaderSize := sizHeaderSize;
  FHeaderStyle := psNormal;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FOptions := [hoColorSchemeFont];
  FPicture := TPicture.Create;
  FPicture.OnChange := DoPictureChanged;
  ParentColor := False;
  Color := clWindow;
  FHeaderColor := clActiveCaption;
  FHeaderFont.Assign(Font);
  FHeaderFont.OnChange := DoHeaderFontChange;
  FIndent := spHeadPnlIndent;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.OnChange := DoMaginsChange;
  FParentHeaderFont := True;
  Width := 245;
  Height := 245;
  SchemeNotification(Self);
end;

destructor TNxHeaderPanel.Destroy;
begin
  RemoveSchemeNotification(Self);
  FreeAndNil(FGlyph);
  FreeAndNil(FHeaderFont);
  FreeAndNil(FInnerMargins);
  FreeAndNil(FPicture);
  inherited;
end;

procedure TNxHeaderPanel.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('FullWidth', ReadFullWidth, WriteFullWidth, True);
end;

procedure TNxHeaderPanel.SetAdaptiveColors(const Value: Boolean);
begin
  FAdaptiveColors := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.SetHeaderColor(const Value: TColor);
begin
  FHeaderColor := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.SetHeaderStyle(const Value: TNxHeaderStyle);
begin
  FHeaderStyle := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.SetOptions(const Value: THeaderOptions);
begin
  FOptions := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.SetParentHeaderFont(const Value: Boolean);
begin
  FParentHeaderFont := Value;
  if Value then FHeaderFont.Assign(Font);
end;

procedure TNxHeaderPanel.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TNxHeaderPanel.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins := Value;
end;

procedure TNxHeaderPanel.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  RedrawBorder;
end;

procedure TNxHeaderPanel.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.SetBtnState(const Value: TButtonState);
var
  R: TRect;
begin
  if Value <> FBtnState then
  begin
    FBtnState := Value;
    R := GetButtonRect;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TNxHeaderPanel.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.SetDisplayStyle(const Value: TDisplayStyle);
begin
  FDisplayStyle := Value;
  UpdateSize;
  Invalidate;
  Realign;
end;

procedure TNxHeaderPanel.SetExpanded(const Value: Boolean);
begin
  if not Value and (Width < szHeadCollapsedWidth) then
    Width := szHeadCollapsedWidth;
  if Value = FExpanded then Exit;
  FExpanding := True;
  if Value then Width := FFullWidth else
  begin
    FFullWidth := Width;
    Width := CollapseWidth;
  end;
  FExpanded := Value;
  if Assigned(FOnChange) then FOnChange(Self); { event }
  if Value then Realign;
  FExpanding := False;
end;

function TNxHeaderPanel.GetButtonRect: TRect;
begin
  with Result do
  begin
    Left := ClientWidth - sizHeaderCloseButton - spHeadPnlMargin;
    if not Expanded and (FDrawDirection = diRightToLeft) then
    begin
      Left := spHeadPnlMargin + 1;
    end;
    Right := Left + sizHeaderCloseButton;
    Top := FHeaderSize div 2 - sizHeaderCloseButton div 2;
    Bottom := Top + sizHeaderCloseButton;
  end;
end;

function TNxHeaderPanel.GetGlyphPos: TPoint;
begin
  with Result do
  begin
    X := 5;
    Y := FHeaderSize div 2 - FGlyph.Height div 2;
  end;
end;

function TNxHeaderPanel.GetGlyphRect: TRect;
begin
  with GetGlyphPos do Result := Rect(X, Y, X + FGlyph.Width, Y + FGlyph.Height);
end;

procedure TNxHeaderPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if FDisplayStyle <> dsPanelOnly then Inc(Rect.Top, FHeaderSize);
  Inc(Rect.Left, FInnerMargins.Left);
  Inc(Rect.Top, FInnerMargins.Top);
  Dec(Rect.Right, FInnerMargins.Right);
  Dec(Rect.Bottom, FInnerMargins.Bottom);
end;

procedure TNxHeaderPanel.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if ParentFont and FParentHeaderFont then FHeaderFont.Assign(Font);
end;

procedure TNxHeaderPanel.CMTextChanged(var Message: TMessage);
var
	r: TRect;
begin
  if HandleAllocated then
  begin
  	r := Rect(0, 0, ClientWidth, HeaderSize);
    InvalidateRect(Handle, @r, False);
  end;
end;

procedure TNxHeaderPanel.DoGlyphClick;
begin
  if Assigned(FOnGlyphClick) then FOnGlyphClick(Self);
end;

procedure TNxHeaderPanel.DoHeaderClick;
begin
  if Assigned(FOnHeaderClick) then FOnHeaderClick(Self);
end;

{$IFDEF DELPHI2010UP}
procedure TNxHeaderPanel.DoGesture(const EventInfo: TGestureEventInfo;
  var Handled: Boolean);
begin
  inherited;
end;
{$ENDIF}

procedure TNxHeaderPanel.DoGlyphChange(Sender: TObject);
begin
  Invalidate;
  FGlyph.Transparent := True;
  FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
end;

procedure TNxHeaderPanel.DoHeaderFontChange(Sender: TObject);
begin
  Invalidate;
  FParentHeaderFont := False;
end;

procedure TNxHeaderPanel.DoMaginsChange(Sender: TObject);
begin
  Invalidate;
  Realign;
end;

procedure TNxHeaderPanel.DoPictureChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxHeaderPanel.DrawButton(const ButtonRect: TRect);
const
  ResStr: array[Boolean] of string = ('HEADEREXPAND', 'HEADERCOLLAPSE');
var
  GlyphPoint: TPoint;
  ResName: string;
begin
  DrawButtonBackground(ButtonRect);
  with GlyphPoint do
  begin
    X := ButtonRect.Left + ((ButtonRect.Right - ButtonRect.Left) div 2 - szHeadPnlButtonWidth div 2);
    Y := ButtonRect.Top + ((ButtonRect.Bottom - ButtonRect.Top) div 2 - szHeadPnlButtonHeight div 2);
  end;
  if FDrawDirection = diRightToLeft then ResName := ResStr[not Expanded]
    else ResName := ResStr[Expanded];
  DrawBitmapFromRes(Canvas, GlyphPoint.X, GlyphPoint.Y, ResName, clLime);
end;

procedure TNxHeaderPanel.DrawButtonBackground(const ButtonRect: TRect);
const
  DownColors: array[Boolean] of TColor = ($00087FE8, $007AD9F7);
  HoverColors: array[Boolean] of TColor = ($00DCFFFF, $005FC2F8);
begin
  if btDown in FBtnState then
  begin
    DrawVertGradient(Canvas, ButtonRect, DownColors[False], DownColors[True]);
  end else if btHover in FBtnState then
  begin
    DrawVertGradient(Canvas, ButtonRect, HoverColors[False], HoverColors[True]);
  end;
end;

procedure TNxHeaderPanel.DrawFlatHeader(const HeaderRect: TRect);
begin
  with Canvas do
  begin
    Brush.Color := HeaderColor;
    FillRect(HeaderRect);
  end;
end;

procedure TNxHeaderPanel.DrawNormalHeader(const HeaderRect: TRect);
var
	FromColor, ToColor: TColor;
  InnerRect: TRect;
begin
  InnerRect := HeaderRect;
  InflateRect(InnerRect, 0, -1);
  Inc(InnerRect.Left);
  with Canvas do
  begin
    Pen.Color := clWhite;
    Polyline([Point(0, HeaderRect.Bottom),
      Point(0, HeaderRect.Top),
      Point(ClientWidth, HeaderRect.Top)]);
    Pen.Color := SchemeColor(seHeaderShadow, FColorScheme);
    Polyline([Point(0, HeaderRect.Bottom - 1), Point(ClientWidth, HeaderRect.Bottom - 1)]);
    if FAdaptiveColors then
    begin
      FromColor := SchemeColor(seHeaderGradientStart, FColorScheme);
      ToColor := SchemeColor(seHeaderGradientEnd, FColorScheme);
    end else
    begin
      FromColor := clWindow;
      ToColor := FHeaderColor;
    end;
    DrawVertGradient(Canvas, InnerRect, FromColor, ToColor);
  end;
end;

procedure TNxHeaderPanel.DrawSectionHeader(const HeaderRect: TRect);
var
	FromColor, ToColor: TColor;
begin
  with Canvas do
  begin
    if IsThemed then
    begin
      if FAdaptiveColors then
      begin
        FromColor := BlendColor(clHighlight, clInactiveCaption, 112);
        ToColor := BlendColor(clActiveCaption, clBlack, 170);
      end else
      begin
        FromColor := FHeaderColor;
        ToColor := BlendColor(FHeaderColor, clBlack, 170);
      end;
      DrawVertGradient(Canvas, HeaderRect, FromColor, ToColor);
    end else
    begin
      if FAdaptiveColors then
      begin
        Brush.Color := clGrayText;
        FillRect(HeaderRect);
      end else
      begin
        FromColor := FHeaderColor;
        ToColor := BlendColor(FHeaderColor, clBlack, 170);
        DrawVertGradient(Canvas, HeaderRect, FromColor, ToColor);
      end;
    end;
  end;
end;

procedure TNxHeaderPanel.DrawVistaHeader(const HeaderRect: TRect);
begin
  with Canvas do
  begin
    Brush.Color := clBlack;
    FillRect(HeaderRect);
    DrawVertFade(Canvas, HeaderRect);
  end;
end;

procedure TNxHeaderPanel.DrawWindowsLiveHeader(const HeaderRect: TRect);
var
	DrawColor: TColor;
  InnerRect: TRect;
begin
  case FAdaptiveColors of
    True: DrawColor := SchemeColor(seInactiveDockCaption, FColorScheme);
    else DrawColor := FHeaderColor;
  end;
  InnerRect := HeaderRect;
  with Canvas do
  begin
    Pen.Color := clWhite;
    Polyline([
      Point(0, HeaderRect.Top),
      Point(ClientWidth, HeaderRect.Top)]);
    Polyline([
      Point(0, HeaderRect.Bottom - 2),
      Point(ClientWidth, HeaderRect.Bottom - 2)]);

    if AdaptiveColors then Pen.Color := SchemeColor(seInactiveDockCaption, FColorScheme)
      else Pen.Color := BorderColor;

    Polyline([Point(0, HeaderRect.Bottom - 1), Point(ClientWidth, HeaderRect.Bottom - 1)]);
    InflateRect(InnerRect, 0, -1);
    Dec(InnerRect.Bottom);
    DrawVertShine(Canvas, InnerRect, DrawColor, Color, (InnerRect.Bottom - InnerRect.Top) div 2);
  end;
end;

procedure TNxHeaderPanel.DrawBackground(ARect: TRect);
var
  SecondColor: TColor;
begin
  case FPanelStyle of
    ptDefault:
      with Canvas do
      begin
        Brush.Color := Self.Color;
        FillRect(ARect);
      end;
    ptGradient:
      begin
        SecondColor := SchemeColor(seBtnFace);
        DrawVertGradient(Canvas, ARect, clWindow, SecondColor);
      end;
    ptInverseGradient:
      begin
        SecondColor := SchemeColor(seBtnFace);
        DrawVertGradient(Canvas, ARect, SecondColor, clWindow);
      end;
  end;
end;

procedure TNxHeaderPanel.Paint;
var
  GlyphPoint: TPoint;
  HeaderRect, BodyRect, MarginRect, CaptionRect: TRect;
  TextLeft, TextRight: Integer;
begin
  inherited;
  if FDisplayStyle = dsPanelOnly then
  begin
    DrawBackground(ClientRect); // paint complete paint area.
    Exit;
  end;

	with Canvas do
  begin
    if FDisplayStyle <> dsHeaderOnly then
    begin
      BodyRect := Rect(0, FHeaderSize, ClientWidth, ClientHeight);
  		Brush.Color := Self.Color;
      if not Assigned(Picture.Graphic) or Picture.Graphic.Empty then
      begin
        DrawBackground(BodyRect);
      end else StretchDraw(BodyRect, Picture.Graphic);

      if csDesigning in ComponentState then
      begin
        Brush.Color := clBtnFace;
  			MarginRect := Rect(FInnerMargins.Left, FHeaderSize + FInnerMargins.Top, ClientWidth - FInnerMargins.Right,
  	      ClientHeight - FInnerMargins.Bottom);
        InflateRect(MarginRect, 1, 1);
        FrameRect(MarginRect);
      end;
    end;

    Font.Assign(FHeaderFont);
    if hoColorSchemeFont in FOptions then Font.Color := SchemeColor(seHeaderFont);
    HeaderRect := Rect(0, 0, ClientWidth, FHeaderSize);
    case FHeaderStyle of
      psFlat: DrawFlatHeader(HeaderRect);
      psNormal: DrawNormalHeader(HeaderRect);
      psSectionHeader: DrawSectionHeader(HeaderRect);
      psVista: DrawVistaHeader(HeaderRect);
      psWindowsLive: DrawWindowsLiveHeader(HeaderRect);
    end;

    TextLeft := FIndent;
    TextRight := ClientWidth;

    { Draw Close Button }
    if (hoCollapseButton in Options) then
    begin
      DrawButton(GetButtonRect);
      TextRight := GetButtonRect.Left;
    end;

    { Draw Glyph }
    if Expanded and Assigned(FGlyph) and not FGlyph.Empty then
    begin
      GlyphPoint := GetGlyphPos;
      ApplyBitmap(Canvas, GlyphPoint.X, GlyphPoint.Y, FGlyph);
      Inc(TextLeft, FGlyph.Width + spHeadPnlGlyphIndent + 2);
    end;

    { Draw Text }
    if FExpanded then
    begin
      CaptionRect := Rect(TextLeft, 0, TextRight, FHeaderSize);
  		DrawTextRect(Canvas, CaptionRect, Caption);
    end;
  end;
end;

procedure TNxHeaderPanel.RedrawBorder;
var
  DC: HDC;
  R: TRect;
  BR: HBRUSH;
  i: Integer;
begin
	inherited;
  DC := GetWindowDC(Handle);
  R := Rect(0, 0, Width, Height);
  GetWindowRect(Handle, R);
  OffsetRect(R, -R.Left, -R.Top);
  if AdaptiveColors then
  begin
    BR := CreateSolidBrush(ColorToRGB(SchemeColor(seBorder, FColorScheme)));
  end else BR := CreateSolidBrush(ColorToRGB(FBorderColor));
  for i := 1 to BorderWidth do
  begin
    FrameRect(DC, R, BR);
    InflateRect(R, -1, -1);
  end;
  DeleteObject(BR);
  ReleaseDC(Handle, DC);
end;

procedure TNxHeaderPanel.RefreshCollapseButton;
var
  R: TRect;
begin
  R := GetButtonRect;
  InvalidateRect(Handle, @R, False);
end;

procedure TNxHeaderPanel.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
end;

procedure TNxHeaderPanel.SetHeaderFont(const Value: TFont);
begin
  FHeaderFont.Assign(Value);
  Invalidate;
end;

procedure TNxHeaderPanel.SetHeaderSize(const Value: Integer);
begin
  FHeaderSize := Value;
  Realign;
  Invalidate;
end;

procedure TNxHeaderPanel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxHeaderPanel.WMNCPaint(var Message: TMessage);
begin
  RedrawBorder;
end;

procedure TNxHeaderPanel.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateSize;
  { 6/6/07: If width go below szHeadCollapsedWidth,
            set Expanded to False }
  if csReading in ComponentState then Exit;
  if FExpanding = False then
  begin
    if Width > szHeadCollapsedWidth then
    begin
      FFullWidth := Width;
      Expanded := True;
    end else
    begin
      Expanded := False;
    end;
  end;
end;

procedure TNxHeaderPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if PtInRect(Rect(0, 0, ClientWidth, HeaderSize), Point(X, Y)) then
  begin
    FHeaderMouseDown := True;
  end;
  if PtInRect(GetButtonRect, Point(X, Y))
    then SetBtnState(FBtnState + [btDown]);
end;

procedure TNxHeaderPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if PtInRect(GetButtonRect, Point(X, Y))
    then SetBtnState(FBtnState + [btHover])
      else SetBtnState(FBtnState - [btHover]);
end;

procedure TNxHeaderPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  AcceptChange: Boolean;
begin
  inherited;
  if PtInRect(Rect(0, 0, ClientWidth, HeaderSize), Point(X, Y)) and FHeaderMouseDown then
  begin
    DoHeaderClick;
    if Assigned(FGlyph) and PtInRect(GetGlyphRect, Point(X, Y)) then DoGlyphClick;
  end;
  { Click on collapse button }
  if (hoCollapseButton in FOptions) and PtInRect(GetButtonRect, Point(X, Y)) then
  begin
    if Expanded then
    begin
      AcceptChange := True;
      DoCollapse(AcceptChange);
      if AcceptChange then Expanded := False;
    end else
    begin
      AcceptChange := True;
      DoExpand(AcceptChange);
      if AcceptChange then Expanded := True;
      SetFocus;
    end;
  end;
  if (hoClickOnBodyExpand in FOptions) and PtInRect(Rect(0, FHeaderSize, ClientWidth, ClientHeight), Point(X, Y)) then
  begin
    Expanded := True;
  end;
  SetBtnState([]);
  FHeaderMouseDown := False;
end;

procedure TNxHeaderPanel.UpdateSize;
begin
  if FDisplayStyle = dsHeaderOnly then ClientHeight := FHeaderSize;
end;

procedure TNxHeaderPanel.ReadFullWidth(Reader: TReader);
begin
  FFullWidth := Reader.ReadInteger;
end;
                                     
procedure TNxHeaderPanel.WriteFullWidth(Writer: TWriter);
begin
  Writer.WriteInteger(FFullWidth);
end;

procedure TNxHeaderPanel.CMMouseLeave(var Message: TMessage);
begin
  SetBtnState(FBtnState - [btHover]);
end;

procedure TNxHeaderPanel.NXMColorSchemeChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNxHeaderPanel.SetDrawDirection(const Value: TDirection);
begin
  FDrawDirection := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;

end;

procedure TNxHeaderPanel.SetPanelStyle(const Value: TNxPanelStyle);
begin
  FPanelStyle := Value;
  Invalidate;
end;

procedure TNxHeaderPanel.DoCollapse(var Accept: Boolean);
begin
  if Assigned(FOnCollapse) then FOnCollapse(Self, Accept);
end;

procedure TNxHeaderPanel.DoExpand(var Accept: Boolean);
begin
  if Assigned(FOnExpand) then FOnExpand(Self, Accept);
end;

{ TNxGlyph }

constructor TNxGlyph.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csOpaque];
  FAutoSize := True;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FTransparent := False;
  Width := 100;
  Height := 100;
end;

destructor TNxGlyph.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

procedure TNxGlyph.DoGlyphChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxGlyph.Paint;
begin
  inherited;
  if (not Assigned(Glyph)) or (FGlyph.Empty) then
  begin
  	if csDesigning in ComponentState then
	  	with Canvas do
  	  begin
	      Pen.Color := clGrayText;
	      Pen.Style := psDot;
  	    Brush.Color := Color;
	      Rectangle(ClientRect);
	    end;
  end else
  	case FGlyph.PixelFormat of
      pf32bit:
        case FTransparent of
          True: ApplyBitmap(Canvas, 0, 0, FGlyph);
          False: DrawBitmap(Canvas, 0, 0, FGlyph, Color);
        end;
    	else Canvas.Draw(0, 0, FGlyph);
    end;
end;

procedure TNxGlyph.ResizeGlyph;
begin
	if (FAutoSize) and (not FGlyph.Empty) then
  begin
    Width := FGlyph.Width;
    Height := FGlyph.Height;
  end;
end;

procedure TNxGlyph.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  ResizeGlyph;
end;

procedure TNxGlyph.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  ResizeGlyph;
end;

procedure TNxGlyph.SetTransparent(const Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    if Value
      then ControlStyle := ControlStyle - [csOpaque]
        else ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
    FTransparent := Value;
  end;
end;

{ TNxButton }

constructor TNxButton.Create(AOwner: TComponent);
begin
  inherited;
  FEnableDblClick := True;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FGlyphSpacing := 3;
  FGrayGlyph := TBitmap.Create;
  FHover := False;
  FKeyPressed := False;
  FLayout := blGlyphLeft;
  FPressed := False;
  FShowArrow := False;
  FTransparent := False;
  ControlStyle := ControlStyle + [csSetCaption, csDoubleClicks];
  Height := 23;
  TabStop := True;
  Width := 75;
end;

destructor TNxButton.Destroy;
begin
  FreeAndNil(FGlyph);
  FreeAndNil(FGrayGlyph);
  if IsThemed then CloseThemeData(FTheme);
  inherited;
end;

procedure TNxButton.CreateWnd;
begin
  inherited;
  FActive := FDefault;
  if IsThemed then FTheme := OpenThemeData(Handle, teButton);
end;

procedure TNxButton.DoGlyphChange(Sender: TObject);
begin
  FGrayGlyph.Assign(FGlyph);
  { Set transparent colors for both glyphs }
  ApplyTransparency;
  GrayscaleBitmap(FGrayGlyph);
  Invalidate;
end;

procedure TNxButton.DrawButton(Canvas: TCanvas);
var
  r: TRect;
  Index: Integer;
begin
  with Canvas do
  begin
    case IsThemed of
      True:
      begin
        Brush.Color := Self.Color;
        FillRect(ClientRect);
        if FKeyPressed then Index := 3 else
        begin
          if FHover then
          begin
            if FPressed or FDown then Index := 3 else Index := 2;
          end else
          begin
            if FDown then Index := 3 else
            if Focused then Index := 5 else Index := 1;
          end;
        end;
        if not Enabled then Index := 4;
        DrawThemeBackground(FTheme, Canvas.Handle, 1, Index, ClientRect, nil);
      end;
      False:
      begin
        r := ClientRect;
        if Focused then
        begin
          Brush.Color := clWindowFrame;
          FrameRect(r);          
          InflateRect(r, -1, -1);
        end;
        if (FPressed and FHover) or FDown or FKeyPressed then
        begin
          Brush.Color := clBtnFace;
          FillRect(r);
          Brush.Color := clBtnShadow;
          FrameRect(r);
        end else
        begin
          Brush.Color := clBtnFace;
          FillRect(r);
          Frame3D(Canvas, r, clBtnHighlight, cl3DDkShadow, 1);
          Pen.Color := clBtnShadow;
          InflateRect(r, -1, -1);
          Polyline([
            Point(r.Right, r.Top - 1),
            Point(r.Right, r.Bottom),
            Point(r.Left - 2, r.Bottom)]);
        end;
      end;
    end;
  end;
end;

procedure TNxButton.ApplyTransparency;
begin
  case FTransparent of
    True: begin
            FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
            FGlyph.Transparent := True;

            FGrayGlyph.TransparentColor := FGrayGlyph.Canvas.Pixels[0, FGrayGlyph.Height - 1];
            FGrayGlyph.Transparent := True;
          end;
    False:
      begin
        FGlyph.Transparent := False;
        FGrayGlyph.Transparent := False;
      end;
  end;
end;

procedure TNxButton.SetDefault(const Value: Boolean);
var
  Form: TCustomForm;
begin
  FDefault := Value;
  if HandleAllocated then
  begin
    Form := GetParentForm(Self);
    if Form <> nil then
      Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
  end;
end;

procedure TNxButton.SetDown(const Value: Boolean);
begin
  FDown := Value;
  Invalidate;
end;

procedure TNxButton.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
end;

procedure TNxButton.SetLayout(const Value: TNxButtonLayout);
begin
  FLayout := Value;
  Invalidate;
end;

procedure TNxButton.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  if FGlyph.Empty then Exit;
  ApplyTransparency;
  Invalidate;
end;

procedure TNxButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNxButton.CMEnter(var Message: TCMEnter);
begin
  inherited;
  Invalidate;
end;

procedure TNxButton.CMExit(var Message: TCMExit);
begin
  inherited;
  Invalidate;
end;

procedure TNxButton.CMMouseEnter(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) then
  begin
    FHover := True;
    Invalidate;
  end;
end;

procedure TNxButton.CMMouseLeave(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) then
  begin
    FHover := False;
    Invalidate;
  end;
end;

procedure TNxButton.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TNxButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then
  begin
    FKeyPressed := True;
    Invalidate;
  end;
end;

procedure TNxButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  FKeyPressed := False;
  if Key = VK_SPACE then
  begin
    Invalidate;
    Click;
  end;
end;

procedure TNxButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  PopupPoint: TPoint;
begin
  inherited;
  FPressed := True;
  if not Focused then SetFocus;
  Invalidate;
  if ShowArrow then
  begin
    if Assigned(PopupMenu) then
    begin
      PopupPoint := Point(0, ClientHeight);
      PopupPoint := ClientToScreen(PopupPoint);
      PopupMenu.Popup(PopupPoint.X, PopupPoint.Y);
      FPressed := False;
      Invalidate;
    end;
  end;
end;

procedure TNxButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  FPressed := False;
  Invalidate;
end;

procedure TNxButton.Paint;
var
  CaptionAlignment: TAlignment;
  X, Y, Space, CaptionHeight, CaptionWidth: Integer;
  FBuffer, AGlyph: TBitmap;
  CaptionRect: TRect;
begin
  inherited Paint;

  { Set Buffer bitmap }
  FBuffer := TBitmap.Create;
  FBuffer.Width := Width;
  FBuffer.Height := Height;

  with FBuffer.Canvas do
  begin
    if Enabled then AGlyph := FGlyph
      else AGlyph := FGrayGlyph;

    DrawButton(FBuffer.Canvas);

    Font.Assign(Self.Font);
    if Assigned(AGlyph) and not AGlyph.Empty then
    begin
      if not Enabled then Font.Color := clGrayText;

      CaptionWidth := TextWidth(Caption);
      CaptionHeight := TextHeight(Caption);

      if Caption = '' then Space := 0
        else Space := GlyphSpacing;

      X := ClientWidth div 2 - AGlyph.Width div 2;
      Y := ClientHeight div 2 - AGlyph.Height div 2;

      case FLayout of
        blGlyphBottom:
        begin
          Inc(Y, CaptionHeight div 2);
          TDrawProvider.ApplyBitmap(FBuffer.Canvas, X, Y, AGlyph);
          Dec(Y, CaptionHeight);
        end;

        blGlyphLeft:
        begin
          Dec(X, CaptionWidth div 2);
          TDrawProvider.ApplyBitmap(FBuffer.Canvas, X, Y, AGlyph);
          Inc(X, AGlyph.Width + Space);
        end;

        blGlyphTop:
        begin
          Dec(Y, CaptionHeight div 2);
          TDrawProvider.ApplyBitmap(FBuffer.Canvas, X, Y, AGlyph);
          Inc(Y, AGlyph.Height);
        end;

        else
        begin
          Inc(X, CaptionWidth div 2);
          TDrawProvider.ApplyBitmap(FBuffer.Canvas, X, Y, AGlyph);
          Dec(X, Space + CaptionWidth);
        end;
      end;

      case FLayout of
        blGlyphLeft, blGlyphRight:
        begin
          CaptionAlignment := taLeftJustify;
          CaptionRect := Rect(X, 0, ClientWidth, ClientHeight - 1);
        end else
        begin
          CaptionAlignment := taCenter;
          CaptionRect := Rect(0, Y, ClientWidth - 1, Y + TextHeight(Caption));
        end;
      end;

      { Draw Text }
      if Enabled
        then DrawText(FBuffer.Canvas, CaptionRect, CaptionAlignment, Caption)
          else DrawDisabledText(FBuffer.Canvas, CaptionRect, Caption, CaptionAlignment);

    end else { no image }
    begin
      CaptionRect := Rect(0, 0, ClientWidth, ClientHeight - 1);
      if Enabled then
        DrawText(FBuffer.Canvas, CaptionRect, taCenter, Caption, False)
          else DrawDisabledText(FBuffer.Canvas, CaptionRect, Caption, taCenter, False);
    end;

    if FShowArrow then
    begin
      FBuffer.Canvas.Brush.Color := clBlack;
      FBuffer.Canvas.Pen.Color := clBlack;
      X := ClientWidth - 20;
      Y := ClientHeight div 2 - 2;
      FBuffer.Canvas.Polygon([Point(X + 1,  Y),
                              Point(X + 8,  Y),
                              Point(X + 4,  Y + 4),
                              Point(X,  Y)
                            ]);
    end;

    { Draw image from buffer }
    Canvas.Draw(0, 0, FBuffer);
    FBuffer.FreeImage;
    FBuffer.Free;
  end;
end;

procedure TNxButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
  begin
    if IsAccel(CharCode, Caption) then
    begin
      Click;
      Result := 1;
    end else inherited;
  end;
end;

procedure TNxButton.CMFocusChanged(var Message: TCMFocusChanged);
begin
  with Message do
    if Sender is TNxButton then
      FActive := Sender = Self
    else
      FActive := FDefault;
  inherited;
end;

procedure TNxButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
  begin
    if Enabled
      and (((CharCode = VK_RETURN) and FActive) or ((CharCode = VK_ESCAPE) and FCancel))
      and (KeyDataToShiftState(Message.KeyData) = []) then
    begin
      Click;
      { Note: Won't trigger KeyDown,
              so I comment it! }
//      Result := 1;
    end else inherited;
  end;
end;

procedure TNxButton.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TNxButton.Click;
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if Form <> nil then Form.ModalResult := ModalResult;
  inherited Click;
end;

procedure TNxButton.SetShowArrow(const Value: Boolean);
begin
  FShowArrow := Value;
  Invalidate;
end;

procedure TNxButton.SetGlyphSpacing(const Value: Integer);
begin
  FGlyphSpacing := Value;
  Invalidate;
end;

procedure TNxButton.WMThemeChanged(var Message: TMessage);
begin
  inherited;
  if IsThemed then
  begin
    CloseThemeData(FTheme);
    FTheme := OpenThemeData(Handle, teButton);
  end;
end;

procedure TNxButton.SetEnableDblClick(const Value: Boolean);
begin
  FEnableDblClick := Value;
  if FEnableDblClick then ControlStyle := ControlStyle + [csDoubleClicks]
    else ControlStyle := ControlStyle - [csDoubleClicks]
end;

{ TNxLabel }

constructor TNxLabel.Create(AOwner: TComponent); 
begin 
  inherited; 
  FAssociate := nil;
  FHorizontalPosition := hpLeft;
  FInnerHorizontal := True;
  FInnerVertical := False;
  FInnerMargins := TMargins.Create;
  FInnerMargins.OnUpdate := DoInnerMarginsUpdate;
  FInnerMargins.Horizontal := 0;
  FInnerMargins.Vertical := 2;
  FVerticalPosition := vpTop;
  FWindowProc := nil;
end;

destructor TNxLabel.Destroy; 
begin
  if Assigned(FAssociate) then
  begin
    FAssociate.WindowProc := FWindowProc;
    FAssociate := nil;
  end;
  FInnerMargins.OnUpdate := nil;
  FreeAndNil(FInnerMargins);
  inherited;
end;

procedure TNxLabel.Assign(Source: TPersistent);
begin
  if Source is TNxLabel then
  begin
    FAssociate := TNxLabel(Source).Associate;
    FHorizontalPosition := TNxLabel(Source).HorizontalPosition;
    FInnerMargins := TNxLabel(Source).InnerMargins;
    FVerticalPosition := TNxLabel(Source).VerticalPosition;
  end;
  inherited Assign(Source);
end;

procedure TNxLabel.SetHorizontalPosition(const Value: THorizontalPosition);
begin
  FHorizontalPosition := Value;
  UpdateLabel;
end;

procedure TNxLabel.SetVerticalPosition(const Value: TVerticalPosition);
begin
  FVerticalPosition := Value;
  UpdateLabel;
end;

procedure TNxLabel.DoInnerMarginsUpdate(Sender: TObject);
begin
  UpdateLabel;
end;

procedure TNxLabel.UpdateLabel;
var
  l: Integer;
  t: Integer;
begin
  if Assigned(FAssociate) then
  begin
    l := 0;
    t := 0;
    case FHorizontalPosition of
      hpLeft: if FInnerHorizontal then l := FAssociate.Left + InnerMargins.Horizontal
                else l := FAssociate.Left - Width - InnerMargins.Horizontal;
      hpCenter: l := FAssociate.Left + FAssociate.Width div 2 - Width div 2 + InnerMargins.Horizontal;
      hpRight: if FInnerHorizontal then l := FAssociate.Left + FAssociate.Width - Width - InnerMargins.Horizontal
                else l := FAssociate.Left + FAssociate.Width + InnerMargins.Horizontal;
    end;
    case FVerticalPosition of
      vpTop: if FInnerVertical then t := FAssociate.Top + InnerMargins.Vertical
              else t := FAssociate.Top - Height - InnerMargins.Vertical;
      vpMiddle: t := FAssociate.Top + FAssociate.Height div 2 - Height div 2 + InnerMargins.Vertical;
      vpBottom: if FInnerVertical then t := FAssociate.Top + FAssociate.Height - Height + InnerMargins.Vertical
                  else t := FAssociate.Top + FAssociate.Height + InnerMargins.Vertical;
    end;
    SetBounds(l, t, Width, Height);
  end;
end;

procedure TNxLabel.MyWndProc(var Message: TMessage); 
begin 
  if Assigned(FWindowProc) then
  begin
    case (Message.Msg) of
      WM_MOVE: UpdateLabel;
      WM_SIZE: UpdateLabel;
    end;
    FWindowProc(message);
  end;
end;

procedure TNxLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FAssociate) and (Operation = opRemove) then Associate := nil;
end;

procedure TNxLabel.SetAssociate(const Value: TControl);
begin
  if (FAssociate <> Value) and (Value <> Self) then
  begin
    if Assigned(FAssociate) then
    begin
      FAssociate.WindowProc := FWindowProc; { return WindowProc }
      FAssociate.RemoveFreeNotification(Self);
    end;
    if Value <> nil then
    begin
      FAssociate := Value;
      FWindowProc := FAssociate.WindowProc;
      FAssociate.WindowProc := MyWndProc;
      FAssociate.FreeNotification(Self);
      UpdateLabel;
    end else
    begin
      FWindowProc := nil;
      FAssociate := nil;
    end;
  end;
end;

procedure TNxLabel.SetInnerHorizontal(const Value: Boolean);
begin
  FInnerHorizontal := Value;
  UpdateLabel;
end;

procedure TNxLabel.SetInnerVertical(const Value: Boolean);
begin
  FInnerVertical := Value;
  UpdateLabel;
end;

procedure TNxLabel.SetInnerMargins(const Value: TMargins);
begin
  if (FInnerMargins.Horizontal <> Value.Horizontal) or 
    (FInnerMargins.Vertical <> Value.Vertical) then
  begin
    FInnerMargins := Value;
    UpdateLabel;
  end; 
end;

procedure TNxLabel.CMTextChanged(var Message: TMessage);
begin
  inherited;
  UpdateLabel;
end;

{ TMargins }

constructor TMargins.Create; 
begin 
  inherited;
  Horizontal := 0;
  Vertical := 0;
end;

procedure TMargins.SetHorizontal(const Value: Integer);
begin
  if FHorizontal <> Value then
  begin
    FHorizontal := Value;
    if Assigned(FOnUpdate) then FOnUpdate(Self);
  end;
end; 

procedure TMargins.SetOnUpdate(const Value: TNotifyEvent); 
begin 
  FOnUpdate := Value; 
end; 

procedure TMargins.SetVertical(const Value: Integer);
begin 
  if FVertical <> Value then
  begin
    FVertical := Value;
    if Assigned(FOnUpdate) then FOnUpdate(Self);
  end;
end;

{ TNxImage }

constructor TNxImage.Create(AOwner: TComponent);
begin
  inherited;
  FCenter := False;
  FDrawBackground := False;
  FFocusImage := True;
  FDrawFrame := True;
  FFrameSize := 2;
  FMargin := 4;
  FPicture := TPicture.Create;
  FPicture.OnChange := DoPictureChange;
  FShowFocus := False;
end;

destructor TNxImage.Destroy;
begin
  FreeAndNil(FPicture);
  inherited;
end;

procedure TNxImage.SetDrawFrame(const Value: Boolean);
begin
  FDrawFrame := Value;
  Invalidate;
end;

procedure TNxImage.SetFrameSize(const Value: Integer);
begin
  FFrameSize := Value;
  Invalidate;
end;

procedure TNxImage.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Invalidate;
end;

procedure TNxImage.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
  Invalidate;
end;

procedure TNxImage.SetShowFocus(const Value: Boolean);
begin
  FShowFocus := Value;
  Invalidate;
end;

function TNxImage.GetPictureRect(ARect: TRect; Graphic: TGraphic): TRect;
var
  ScaleHor, ScaleVer, Scale: Double;
  NewWidth, NewHeight, ATop, ALeft: Integer;
begin
  with ARect do
  begin
    if Center then
    begin
      Result.Left := ARect.Left + (ARect.Right - ARect.Left) div 2 - Graphic.Width div 2;
      Result.Top := ARect.Top + (ARect.Bottom - ARect.Top) div 2 - Graphic.Height div 2;
      Result.Right := Result.Left + Graphic.Width;
      Result.Bottom := Result.Top + Graphic.Height;
      InflateRect(Result, FrameSize, FFrameSize);
    end else
    begin
      ScaleHor := (Right - Left) / Graphic.Width;
      ScaleVer := (Bottom - Top) / Graphic.Height;
      Scale := Min(ScaleHor, ScaleVer);
      NewWidth  := Round(Graphic.Width * Scale);
      NewHeight := Round(Graphic.Height * Scale);
      if ScaleHor < ScaleVer then
      begin
        ATop := Top + ((Bottom - Top) div 2 - (NewHeight div 2));
        Result := Rect(Left, ATop, Left + NewWidth, ATop + NewHeight);
      end else
      begin
        ALeft := Left + ((Right - Left) div 2 - (NewWidth div 2));
        Result := Rect(ALeft, Top, ALeft + NewWidth, Top + NewHeight);
      end;
    end;
  end;
end;

procedure TNxImage.DoPictureChange(Sender: TObject);
begin
  RefreshPicture;
end;

procedure TNxImage.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if FFocusImage and (Focused = False) then
  begin
    SetFocus;
    RefreshPicture;
  end;
end;

procedure TNxImage.PaintFrame(var ARect: TRect; Size: Integer);
var
  I: Integer;
begin
  with Canvas do
  begin
    if Focused then Brush.Color := clHighlight else
      Brush.Color := clBtnFace; 
    for I := 1 to Size do
    begin
      FrameRect(ARect);
      InflateRect(ARect, -1, -1);
    end;
  end;
end;

procedure TNxImage.PaintPicture(var ARect: TRect; Graphic: TGraphic);
begin
  if FDrawFrame then
    PaintFrame(ARect, FFrameSize);
  Canvas.StretchDraw(ARect, Graphic);
end;

procedure TNxImage.Paint;
var
  BorderRect, DrawRect, FocusRect, PictureRect: TRect;
begin
  inherited;
  DrawRect := ClientRect;
  BorderRect := DrawRect;
  InflateRect(DrawRect, -Margin, -Margin);
  InflateRect(DrawRect, -1, -1);

  if Assigned(FPicture.Graphic)
    and not FPicture.Graphic.Empty then
  begin
    PictureRect := GetPictureRect(DrawRect, FPicture.Graphic);
    FocusRect := PictureRect;
    if not FDrawBackground then
      ExcludeClipRect(Canvas.Handle, PictureRect.Left, PictureRect.Top,
        PictureRect.Right, PictureRect.Bottom);
    PaintBackground(BorderRect);
    SetClipRect(Canvas, ClientRect);

    PaintPicture(PictureRect, FPicture.Graphic);

    if Focused and ShowFocus then DrawFocusFrame(Canvas, FocusRect);
  end else
  begin
    PaintBackground(BorderRect);
    Canvas.Font.Assign(Font); 
    DrawText(Canvas, BorderRect, taCenter, Caption, True);
  end;
end;

procedure TNxImage.PaintBackground(Rect: TRect);
begin
  if IsThemed then
    ThemeRect(Handle, Canvas.Handle, Rect, teListView, 1, 1) else
  begin
    Frame3D(Canvas, Rect, clBtnShadow, clBtnHighlight, 1);
    Canvas.Brush.Color := Color;
    Canvas.FillRect(Rect);
  end;
end;

procedure TNxImage.RefreshPicture;
begin
  if Assigned(FPicture.Graphic) and (not FPicture.Graphic.Empty)
    then Invalidate;
end;

procedure TNxImage.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNxImage.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxImage.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  RefreshPicture;
end;

procedure TNxImage.SetCenter(const Value: Boolean);
begin
  FCenter := Value;
  Invalidate;
end;

procedure TNxImage.SetDrawBackground(const Value: Boolean);
begin
  FDrawBackground := Value;
  Invalidate;
end;

{ TNxPanel }

procedure TNxPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  Inc(Rect.Left, FInnerMargins.Left);
  Inc(Rect.Top, FInnerMargins.Top);
  Dec(Rect.Right, FInnerMargins.Right);
  Dec(Rect.Bottom, FInnerMargins.Bottom);
end;

function TNxPanel.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  TextWidth, TextHeight: Integer;
begin
  Result := True;
  inherited CanAutoSize(NewWidth, NewHeight);

  TextWidth := FInnerMargins.Right + FInnerMargins.Left
    + GetTextWidth(Canvas, Caption) + 2;
  TextHeight := FInnerMargins.Top + FInnerMargins.Bottom
    + GetTextHeight(Canvas, Caption);

  if NewWidth < TextWidth then
    NewWidth := TextWidth;

  if NewHeight < TextHeight then
    NewHeight := TextHeight;
end;

procedure TNxPanel.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

constructor TNxPanel.Create(AOwner: TComponent);
begin
  inherited;
  FAdaptiveColors := True;
  FBackgroundStyle := pbSolid;
  FBorderPen := TPen.Create;
  FBorderPen.OnChange := DoStyleChange;
  FColorScheme := csDefault;
  FFullRepaint := False;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.SetRect(0, 0, 0, 0);
  FInnerMargins.OnChange := DoInnerMarginsChange;
  FPanelBorders := [boBottom, boLeft, boRight, boTop];
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks, csReplicatable];
  SchemeNotification(Self);
end;

procedure TNxPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if NewStyleControls then
    begin
      if BackgroundStyle = pbTransparent then
        ExStyle := ExStyle or WS_EX_TRANSPARENT;
    end;
  end;
end;

destructor TNxPanel.Destroy;
begin
  FreeAndNil(FBorderPen);
  FreeAndNil(FInnerMargins);
  RemoveSchemeNotification(Self);
  inherited;
end;

procedure TNxPanel.DoInnerMarginsChange(Sender: TObject);
begin
  Invalidate;
  Realign;
end;

procedure TNxPanel.DoStyleChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxPanel.Paint;
var
  BrushColor: TColor;
  Indent: Integer;
  PaintRect: TRect;
  RoundMode: TFPURoundingMode;
begin
  inherited;
  with Canvas do
  begin
    Pen.Style := psSolid;
    
    PaintRect := ClientRect;
    with PaintRect do
    begin
      if FBorderPen.Style = psSolid then
      begin
        if boLeft in FPanelBorders then Inc(Left, BorderPen.Width);
        if boTop in FPanelBorders then Inc(Top, BorderPen.Width);
        if boRight in FPanelBorders then Dec(Right, BorderPen.Width);
        if boBottom in FPanelBorders then Dec(Bottom, BorderPen.Width);
      end;
    end;

    if AdaptiveColors then
    begin
      BrushColor := SchemeColor(seBtnFace, FColorScheme);
    end else BrushColor := Color;

    Font.Assign(Self.Font);
    case FBackgroundStyle of
      pbControl:
        if IsThemed then ThemeRect(Self.Handle, Canvas.Handle, PaintRect, teEdit, 1, 0) else
        begin
          Brush.Color := BrushColor;
          FillRect(PaintRect);
        end;
      pbSolid:
      begin
        Brush.Color := BrushColor;
        FillRect(PaintRect);
      end;
      pbTransparent:
      begin
        DrawTransparent(Self, Canvas);
      end;
      pbHorzGradient:
      begin
        DrawHorzGradient(Canvas, PaintRect, clWindow, BrushColor);
      end;
      pbVertGradient:
      begin
        DrawVertGradient(Canvas, PaintRect, clWindow, BrushColor);
      end;
    end;

    DrawText(Canvas, PaintRect, taCenter, Caption, True);

    { draw borders }
    Pen.Assign(FBorderPen);

    Indent := Pen.Width div 2;
    if boLeft in FPanelBorders then Polyline([Point(Indent, 0), Point(Indent, ClientHeight)]);
    if boTop in FPanelBorders then Polyline([Point(0, Indent), Point(ClientWidth, Indent)]);

    RoundMode := GetRoundMode;
    SetRoundMode(rmUp);
    Indent := Round(Pen.Width / 2);
    if boBottom in FPanelBorders then Polyline([Point(0, ClientHeight - Indent), Point(ClientWidth, ClientHeight - Indent)]);
    if boRight in FPanelBorders then Polyline([Point(ClientWidth - Indent, 0), Point(ClientWidth - Indent, ClientHeight - 1)]);
    SetRoundMode(RoundMode);
  end;
end;

procedure TNxPanel.SetAdaptiveColors(const Value: Boolean);
begin
  FAdaptiveColors := Value;
  Invalidate;
end;

procedure TNxPanel.SetBackgroundStyle(
  const Value: TNxPanelBackgroundStyle);
begin
  FBackgroundStyle := Value;
  Invalidate;
end;

procedure TNxPanel.SetBorderPen(const Value: TPen);
begin
  FBorderPen := Value;
  Invalidate;
end;

procedure TNxPanel.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
  Invalidate;
end;

procedure TNxPanel.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins.Assign(Value);
  Realign;
end;

procedure TNxPanel.SetPanelBorders(const Value: TPanelBorders);
begin
  FPanelBorders := Value;
  Invalidate;
end;

procedure TNxPanel.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  if not FFullRepaint then Message.Result := 1;
end;

procedure TNxPanel.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  if BackgroundStyle = pbTransparent then Invalidate;
end;

{ TNxGroupHeader }

procedure TNxGroupHeader.ApplyTransparentColor(AColor: TColor);
begin
  if (FGlyph = nil) or FGlyph.Empty then Exit;
  FGlyph.TransparentColor := AColor;
  FGlyph.Transparent := AColor <> clNone;
end;

procedure TNxGroupHeader.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

constructor TNxGroupHeader.Create(AOwner: TComponent);
begin
  inherited;
  FColorScheme := csBlue;
  Height := 22;
  Width := 200;
  FFillStyle := fsSolid;
  FTransparentColor := clNone;
  ControlStyle := ControlStyle - [csOpaque];
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FGlyphVisible:=True;
end;

destructor TNxGroupHeader.Destroy;
begin
  FreeAndNil(FGlyph);
  inherited;
end;

procedure TNxGroupHeader.DoGlyphChange(Sender: TObject);
begin
  Invalidate;
  ApplyTransparentColor(FTransparentColor);
end;

procedure TNxGroupHeader.Paint;
var
  TextIndent: Integer;
  ForeColor: TColor;
  BrushRect,
  TxtRect: TRect;
begin
  inherited;
  with Canvas do
  begin
    Brush.Color := SchemeColor(seGroupHeader, FColorScheme);
    Pen.Color := $00C5C5C5;
    FillRect(Rect(0, 0, ClientWidth, ClientHeight - 1));

    ForeColor:=SchemeColor(seBtnFaceDark, FColorScheme);
    BrushRect:=Rect(0, 0, ClientWidth, ClientHeight - 1);
    case FFillStyle of
      fsSolid: FillRect(BrushRect);
      fsHorzGradient: DrawHorzGradient(Canvas, BrushRect, ForeColor, Color);
      fsVertGradient: DrawVertGradient(Canvas, BrushRect, ForeColor, Color);
      fsGlass: DrawVertGlass(Canvas, BrushRect, ForeColor, Color, Height div 2);
    end;
    TextIndent := 2;
    if not FGlyph.Empty and FGlyphVisible then
    begin
      ApplyBitmap(Canvas, TextIndent, ClientHeight div 2 - FGlyph.Height div 2, Glyph);
      Inc(TextIndent, FGlyph.Width + 2);
    end;

    Polyline([Point(0, ClientHeight - 1), Point(ClientWidth, ClientHeight - 1)]);
    TxtRect := ClientRect;
    InflateRect(TxtRect, -5, 0);
    TxtRect.Left := TextIndent;
    Font.Assign(Self.Font);
    DrawText(Canvas, TxtRect, FAlignment, Caption, True);
  end;
end;

procedure TNxGroupHeader.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TNxGroupHeader.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
  Invalidate;
end;

procedure TNxGroupHeader.SetFillStyle(const Value: TFillPaintStyle);
begin
  FFillStyle := Value;
  Invalidate;
end;

procedure TNxGroupHeader.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  ApplyTransparentColor(FTransparentColor);
  Invalidate;
end;

procedure TNxGroupHeader.SetGlyphVisible(const Value: Boolean);
begin
  FGlyphVisible:=Value;
  ApplyTransparentColor(FTransparentColor);
  Invalidate;
end;

procedure TNxGroupHeader.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  ApplyTransparentColor(FTransparentColor);
  Invalidate;
end;

{ TNxInfoPanel }

procedure TNxInfoPanel.ApplyTransparentColor(AColor: TColor);
begin
  if (FGlyph = nil) or FGlyph.Empty then Exit;
  FGlyph.TransparentColor := AColor;
  FGlyph.Transparent := AColor <> clNone;
end;

procedure TNxInfoPanel.ChangeState(State: TButtonState);
begin
  if (csDesigning in ComponentState)
    or (ipStaticPanel in FOptions) then FButtonState := [] else
  begin
    FButtonState := State;
    Invalidate;
  end;
end;

procedure TNxInfoPanel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNxInfoPanel.CMMouseEnter(var Message: TMessage);
begin
  ChangeState(FButtonState + [btHover]);
end;

procedure TNxInfoPanel.CMMouseLeave(var Message: TMessage);
begin
  ChangeState(FButtonState - [btHover]);
end;

constructor TNxInfoPanel.Create(AOwner: TComponent);
begin
  inherited;
  FBorderColor := clBlack;
  FColorScheme := csDefault;
  FFillStyle := fsSolid;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FIndent := 4;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.OnChange := DoInnerMarginsChange;
  FOuterMargins := TNxMargins.Create;
  FOuterMargins.SetRect(0, 0, 0, 0);
  FOuterMargins.OnChange := DoInnerMarginsChange;
  FSpacing := 2;
  FTransparentColor := clNone;
  ControlStyle := ControlStyle - [csOpaque];
  SchemeNotification(Self);
end;

destructor TNxInfoPanel.Destroy;
begin
  RemoveSchemeNotification(Self);
  FreeAndNil(FGlyph);
  FreeAndNil(FInnerMargins);
  FreeAndNil(FOuterMargins);
  inherited;
end;

procedure TNxInfoPanel.DoGlyphChange(Sender: TObject);
begin
  Invalidate;
  ApplyTransparentColor(FTransparentColor);
end;

procedure TNxInfoPanel.DoInnerMarginsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxInfoPanel.DoOuterMarginsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxInfoPanel.GetPaintColors(var PenColor, ForeColor, BackColor, FontColor: TColor);
begin
  PenColor := BorderColor;
  if btDown in FButtonState then
  begin
    ForeColor := SchemeColor(seMenuSelectionBorderDown, FColorScheme);
    FontColor := clHighlightText;
  end else if btHover in FButtonState then
  begin
    ForeColor := SchemeColor(seMenuSelectionBorder, FColorScheme);
  end else
  begin
    ForeColor := SchemeColor(seBtnFaceDark, FColorScheme);
    FontColor := Font.Color;
  end;
end;

procedure TNxInfoPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  ChangeState(FButtonState + [btDown]);
end;

procedure TNxInfoPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  PopupPoint: TPoint;
begin
  inherited;
  ChangeState(FButtonState - [btDown]);
  if Button = mbLeft then
  begin
    if Assigned(PopupMenu) then
    begin
      PopupPoint := ClientToScreen(Point(X, Y));
      PopupMenu.Popup(PopupPoint.X, PopupPoint.Y);
      ChangeState(FButtonState - [btHover]);
    end;
  end;
end;

procedure TNxInfoPanel.Paint;
var
  PenColor, ForeColor, BackColor, FontColor: TColor;
  TextIndent, TextTop: Integer;
  InnerRect, BrushRect, CaptionRect, TxtRect, MarginRect: TRect;
begin
  inherited;
  InnerRect := FOuterMargins.AsRect(Width, Height);
  with Canvas do
  begin
    GetPaintColors(PenColor, ForeColor, BackColor, FontColor);
    BrushRect := InnerRect;
    if ipBorder in Options then
    begin
      Brush.Color := PenColor;
      FrameRect(BrushRect);
      InflateRect(BrushRect, -1, -1);
    end;
    Brush.Color := ForeColor;
    case FFillStyle of
      fsSolid: FillRect(BrushRect);
      fsHorzGradient: DrawHorzGradient(Canvas, BrushRect, ForeColor, Color);
      fsVertGradient: DrawVertGradient(Canvas, BrushRect, ForeColor, Color);
      fsGlass: DrawVertGlass(Canvas, BrushRect, ForeColor, Color, Height div 2);
    end;

    Inc(InnerRect.Left, FInnerMargins.Left);
    Inc(InnerRect.Top, FInnerMargins.Top);
    Dec(InnerRect.Right, FInnerMargins.Right);
    Dec(InnerRect.Bottom, FInnerMargins.Bottom);

    TextIndent := InnerRect.Left;
    if not FGlyph.Empty then
    begin
      Inc(TextIndent, FGlyph.Width + FIndent);
      ApplyBitmap(Canvas, InnerRect.Left, InnerRect.Top, Glyph);
    end;

    TextTop := InnerRect.Top;
    if Caption <> '' then
    begin
      CaptionRect := InnerRect;
      CaptionRect.Left := TextIndent;
      CaptionRect.Bottom := CaptionRect.Top + TextHeight(Caption);
      Inc(TextTop, TextHeight(Caption));
      Inc(TextTop, FSpacing);
    end;

    TxtRect := FInnerMargins.AsRect(Width, Height);
    TxtRect.Left := TextIndent;
    TxtRect.Top := TextTop;

    Font.Assign(Self.Font);
    Font.Color := FontColor;

    { Draw Caption }
    Font.Style := [fsBold];
    DrawTextRect(Canvas, CaptionRect, Caption);

    { Draw Text }
    if ipHtmlText in Options
      then ProcessHTML(Canvas, TxtRect, FText, Point(0, 0), NxClasses.Indent(0, 0), rtDraw, wkWordWrap) else
    begin
      Font.Style := [];
      DrawFmtText(Canvas, TxtRect, FText, FAlignment, FVerticalAlignment, FWrapKind, BiDiMode);
    end;

    if csDesigning in ComponentState then
    begin
      Brush.Color := clBtnFace;
			MarginRect := InnerRect;
      InflateRect(MarginRect, 1, 1);
      FrameRect(MarginRect);
    end;
  end;
end;

procedure TNxInfoPanel.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetFillStyle(const Value: TFillPaintStyle);
begin
  FFillStyle := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  ApplyTransparentColor(FTransparentColor);
  Invalidate;
end;

procedure TNxInfoPanel.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetOptions(const Value: TInfoPanelOptions);
begin
  FOptions := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetOuterMargins(const Value: TNxMargins);
begin
  FOuterMargins := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetSpacing(const Value: Integer);
begin
  FSpacing := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetText(const Value: WideString);
begin
  if FText <> Value then
  begin
    FText := Value;
    Invalidate;
  end;
end;

procedure TNxInfoPanel.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  ApplyTransparentColor(FTransparentColor);
  Invalidate;
end;

procedure TNxInfoPanel.SetVerticalAlignment(
  const Value: TVerticalAlignment);
begin
  FVerticalAlignment := Value;
  Invalidate;
end;

procedure TNxInfoPanel.SetWrapKind(const Value: TWrapKind);
begin
  FWrapKind := Value;
  Invalidate;
end;

procedure TNxInfoPanel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

{ TNxPathNode }

constructor TNxPathNode.Create;
begin
  inherited;
  FImageIndex := -1;
end;

procedure TNxPathNode.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
end;

{ TNxPathNodes }

function TNxPathNodes.GetPathItem(const Index: Integer): TNxPathNode;
begin
  Result := GetItem(Index) as TNxPathNode;
end;

function TNxPathNodes.GetTreeNodeClass: TNxTreeNodeClass;
begin
  Result := TNxPathNode;
end;

{ TNxPath }

procedure TNxPathControl.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TNxPathControl.CMMouseLeave(var Message: TMessage);
var
  OldHoverItem: TNxPathNode;
begin
  OldHoverItem := FHoverItem;
  FHoverItem := nil;
  RefreshItem(OldHoverItem);
  SetRootItemHover(False);
end;

constructor TNxPathControl.Create(AOwner: TComponent);
begin
  inherited;
  FButtonDown := False;
  FButtonStyle := bsDefault;
  FFirstClick := True;
  FFirstItem := 0;
  FEnableVisualStyles := True;
  FImages := nil;
  FItems := TNxPathNodes.Create(Self);
  FItems.OnDeleted := DoNodeDeleted;
  FOldDownItem := nil;
  FPopup := TPopupMenu.Create(Self);
  FRootItemHover := False;
  FUpdateCount := 0;
  Height := 21;
  Width := 250;
end;

destructor TNxPathControl.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TNxPathControl.DoMenuItemClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    Selected := FItems[Tag] as TNxPathNode;
end;

procedure TNxPathControl.DoItemMouseEnter(Item: TNxPathNode);
begin
  if Assigned(FOnItemMouseMove) then FOnItemMouseMove(Self, Item);
end;

procedure TNxPathControl.DoNodeDeleted(Sender: TObject; Item: TNxTreeNode);
begin
  if csDestroying in ComponentState then Exit;
  if FUpdateCount > 0 then Exit;
  if Item = FSelected then
  begin
    if Item.Parent = nil then Selected := nil else
      Selected := TNxPathNode(Item.Parent);
  end;
end;

procedure TNxPathControl.DoPopup(Node: TNxPathNode);
begin
  if Assigned(FOnPopup) then FOnPopup(Self, Node);
end;

procedure TNxPathControl.DoSelect;
begin
  if Assigned(FOnSelect) then FOnSelect(Self);
end;

procedure TNxPathControl.DrawButtonEdge(const ButtonRect: TRect;
  Edge: TButtonEdge; State: TPathButtonState);
begin
  case ButtonStyle of
    bsDefault:
    if IsThemed and EnableVisualStyles then
      DrawThemedButtonEdge(Self, Canvas, ButtonRect, Edge, State)
            else
      DrawClassicButtonEdge(Canvas, ButtonRect, Edge, State);
    bsOffice2007: DrawOffice2007Edge(Canvas, ButtonRect, Edge, State);
  end;
end;

procedure TNxPathControl.DrawItem(ItemRect: TRect; Item: TNxPathNode;
  DrawStyle: TPathItemDrawStyle);
var
  TxtRect, TitleRect, ButtonRect: TRect;
  AState: TPathButtonState;
  w1, w2, X, Y: Integer;
begin
  with Canvas do
  begin
    TxtRect := ItemRect;
    ButtonRect := ItemRect;
    ButtonRect.Left := ButtonRect.Right - GetPopupButtonWidth;
    TitleRect := ItemRect;
    if Item.Count > 0 then TitleRect.Right := ButtonRect.Left;

    Inc(TxtRect.Left, spSpacingLeft);
    if Items.GetItemCount(Item) > 0 then
    begin
      TxtRect.Right := TxtRect.Right - GetPopupButtonWidth;
    end;

    if pdsHover in DrawStyle then
    begin
      if pdsTitleHover in DrawStyle then
      begin
        AState := ptHoverActive;
        if pdsDown in DrawStyle then AState := ptDown;
      end else AState := ptHover;

      DrawButtonEdge(TitleRect, beLeft, AState);

      if Items.GetItemCount(Item) > 0 then
      begin
        if pdsButtonHover in DrawStyle then AState := ptHoverActive
          else AState := ptHover;
        if pdsDown in DrawStyle then AState := ptDown;
        DrawButtonEdge(ButtonRect, beRight, AState);
      end else

    end else
    begin
      Brush.Color := Color;
      FillRect(ItemRect);
    end;

    X := ButtonRect.Left + (ButtonRect.Right - ButtonRect.Left) div 2;
    Y := ButtonRect.Top + (ButtonRect.Bottom - ButtonRect.Top) div 2;
    w1 := (X - ButtonRect.Left) - 4;
    w2 := w1 div 2;

    if Items.GetItemCount(Item) > 0 then
    begin
      Pen.Color := clBlack;
      Brush.Color := clBlack;
      if pdsDown in DrawStyle then
        Polygon([
          Point(X - w1, Y),
          Point(X + w1, Y),
          Point(X, Y + w1)
        ])
      else
        Polygon([
          Point(X - w2, Y - w1),
          Point(X + w2, Y),
          Point(X - w2, Y + w1)
        ]);
    end;

    DrawText(Canvas, TxtRect, taLeftJustify, Item.Text, True);
  end;
end;

procedure TNxPathControl.DrawItems;
var
  i, X, ItemWidth: Integer;
  AItem: TNxPathNode;
  DrawStyle: TPathItemDrawStyle;
begin
  X := GetRootItemWidth;

  for i := FFirstItem to Selected.Level do
  begin
    AItem := SelectedItem[i];
    ItemWidth := GetItemWidth(AItem);

    DrawStyle := [];
    if AItem = FHoverItem then
    begin
      DrawStyle := [pdsHover];
      case FHoverItemPart of
        pipTitle: Include(DrawStyle, pdsTitleHover);
        pipButton: Include(DrawStyle, pdsButtonHover);
      end;
      if AItem = FDownItem then
      begin
        Include(DrawStyle, pdsDown);
        if FButtonDown then Include(DrawStyle, pdsButtonDown);
      end;
    end;

    DrawItem(Rect(X, 0, X + ItemWidth, ClientHeight), AItem, DrawStyle);
    Inc(X, ItemWidth);
  end;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(Rect(X, 0, ClientWidth, ClientHeight));
end;

procedure TNxPathControl.EndUpdate;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  if FUpdateCount = 0 then Invalidate;
end;

function TNxPathControl.GetItemAtPos(X, Y: Integer): TNxPathNode;
var
  i, Pos: Integer;
  AItem: TNxPathNode;
begin
  Result := nil;
  if not PtInRect(ClientRect, Point(X, Y)) then Exit;
  Pos := GetRootItemWidth;
  for i := FFirstItem to Selected.Level + 1 do
  begin
    AItem := SelectedItem[i];
    if InRange(X, Pos, Pos + GetItemWidth(AItem)) then
    begin
      Result := AItem;
      Exit;
    end;
    Inc(Pos, GetItemWidth(AItem));
  end;
end;

procedure TNxPathControl.DrawRootItem;
var
  ImageIndex: TImageIndex;
  RoundingMode: TFPURoundingMode;
  AState: TPathButtonState;
  X, Y, w1, w2: Integer;
  ARect: TRect;
begin
  with Canvas do
  begin
    ARect := GetRootItemRect;
    AState := ptNormal;

    Brush.Color := Self.Color;
    FillRect(ARect);
    
    if pdsHover in DrawStyle then
    begin
      AState := ptHoverActive;
      if pdsDown in DrawStyle then AState := ptDown;
    end;

    DrawButtonEdge(GetRootItemRect, beClient, AState);

    if Assigned(FImages) then
    begin
      if Assigned(Selected)
        then ImageIndex := SelectedItem[0].ImageIndex
        else ImageIndex := -1;

      if InRange(ImageIndex, 0, FImages.Count - 1) then
      begin
        RoundingMode := GetRoundMode;
        SetRoundMode(rmUp);
        Y := Round(ClientHeight / 2 - FImages.Height / 2);
        SetRoundMode(RoundingMode);
        FImages.Draw(Canvas, 2, Y, ImageIndex);
      end;
    end;

    ARect.Left := ARect.Right - GetPopupButtonWidth;

    X := ARect.Left + (ARect.Right - ARect.Left) div 2;
    Y := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
    w1 := (X - ARect.Left) - 4;
    w2 := w1 div 2;

    Pen.Color := clBlack;
    Brush.Color := clBlack;
    if pdsDown in DrawStyle then
      Polygon([
        Point(X - w1, Y),
        Point(X + w1, Y),
        Point(X, Y + w1)
      ])
    else
      Polygon([
        Point(X - w2, Y - w1),
        Point(X + w2, Y),
        Point(X - w2, Y + w1)
      ]);
  end;
end;

function TNxPathControl.GetItemAtPos(X, Y: Integer;
  var ItemPart: TPathItemPart): TNxPathNode;
var
  i, Pos, Right: Integer;
  AItem: TNxPathNode;
begin
  Result := nil;
  if not PtInRect(ClientRect, Point(X, Y)) then Exit;
  Pos := GetRootItemWidth;
  for i := FFirstItem to Selected.Level do
  begin
    AItem := SelectedItem[i];
    Right := Pos + GetItemWidth(AItem);
    if InRange(X, Pos, Right) then
    begin
      if (Items.GetItemCount(AItem) > 0)
        and InRange(X, Right - GetPopupButtonWidth, Right) then
          ItemPart := pipButton else ItemPart := pipTitle;
      Result := AItem;
      Exit;
    end;
    Inc(Pos, GetItemWidth(AItem));
  end;
end;

function TNxPathControl.GetItemRect(Item: TNxPathNode): TRect;
var
  i, X: Integer;
  AItem: TNxPathNode;
begin
  X := GetRootItemWidth;
  Result := ClientRect;
  for i := FFirstItem to Item.Level do
  begin
    AItem := SelectedItem[i];
    Result.Left := X;
    Inc(X, GetItemWidth(AItem));
    Result.Right := X;
  end;
end;

function TNxPathControl.GetRootItemRect: TRect;
begin
  Result := Rect(0, 0, GetRootItemWidth, ClientHeight);
end;

function TNxPathControl.GetItemWidth(Item: TNxPathNode): Integer;
begin
  with Canvas do
  begin
    if Item = nil then
    begin
      Result := 40;
    end else
    begin
      Result := spSpacingLeft + TextWidth(Item.Text) + spSpacingRight;
      if Item.Count > 0 then Inc(Result, GetPopupButtonWidth);
    end;
  end;
end;

function TNxPathControl.GetPopupButtonWidth: Integer;
begin
  Result := Round(ClientHeight / 1.6);
end;

function TNxPathControl.GetFirstItem: Integer;
var
  i, ItemWidth, W, TotalWidth: Integer;
begin
  TotalWidth := ClientWidth - GetRootItemWidth;
  w := 0;
  for i := Selected.Level downto 0 do
  begin
    ItemWidth := GetItemWidth(SelectedItem[i]);
    Inc(w, ItemWidth);
    if w > TotalWidth then
    begin
      Result := i + 1;
      Exit;
    end;
  end;
  Result := 0;
end;

function TNxPathControl.GetRootItemWidth: Integer;
begin
  Result := 32;
end;

function TNxPathControl.GetSelectedItem(const Index: Integer): TNxPathNode;
var
  i: Integer;
begin
  i := Selected.Level;
  Result := Selected;
  while i > Index do
  begin
    Result := TNxPathNode(Result.Parent);
    Dec(i);
  end;
end;

procedure TNxPathControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  MouseDownItem: TNxPathNode;
  PopupPoint, CursorPoint: TPoint;
  ItemRect: TRect;
  ItemPart: TPathItemPart;
begin
  inherited;
  if Items.Empty then Exit;

  if PtInRect(GetRootItemRect, Point(X, Y)) then
  begin
    FFirstClick := not FFirstClick;
    if FFirstClick then Exit;

    SetRootItemDown(True);

    DoPopup(nil); { event }
    SetPopupItems(nil);
    PopupPoint := ClientToScreen(Point(0, ClientHeight));

    FPopup.Popup(PopupPoint.X, PopupPoint.Y);
    { note: after popup is closed, root item is set back
            to normal state }
    SetRootItemDown(False);

    GetCursorPos(CursorPoint);
    CursorPoint := ScreenToClient(CursorPoint);
    if not PtInRect(GetRootItemRect, CursorPoint) then
    begin
      FFirstClick := True;
      SetRootItemHover(False);
    end;
  end else
  begin
    SetRootItemDown(False);
    if Selected = nil then Exit;
    MouseDownItem := GetItemAtPos(X, Y, ItemPart);
    if MouseDownItem = nil then Exit;
    ItemRect := GetItemRect(MouseDownItem);

    FDownItem := MouseDownItem;
    FOldDownItem := FDownItem;

    if FDownItem = nil then Exit;

    if ItemPart = pipButton then
    begin
      FFirstClick := not FFirstClick;
      if FFirstClick then Exit;

      DoPopup(FDownItem); { event }
      SetPopupItems(FDownItem);

      PopupPoint := ClientToScreen(Point(ItemRect.Right - GetPopupButtonWidth, ItemRect.Bottom));
      try
        FButtonDown := True;
        RefreshItem(FDownItem);

        FPopup.Popup(PopupPoint.X, PopupPoint.Y);
        { 3/18/07:  when popup-menu is closed, next line of code will execute }
      finally
        FButtonDown := False;
        RefreshItem(FDownItem);
        FDownItem := nil;

        GetCursorPos(CursorPoint);
        CursorPoint := ScreenToClient(CursorPoint);
        FHoverItem := GetItemAtPos(CursorPoint.X, CursorPoint.Y);
        FFirstClick := FHoverItem <> FOldDownItem;
        RefreshItem(FHoverItem);
      end;
    end else
    begin
      FFirstClick := True;
      RefreshItem(FDownItem);
    end;
  end;
end;

procedure TNxPathControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  MouseMoveItem, OldHoverItem: TNxPathNode;
  ItemPart: TPathItemPart;  
begin
  inherited;
  if not PtInRect(ClientRect, Point(X, Y)) or Items.Empty then Exit;

  OldHoverItem := FHoverItem;
  if PtInRect(GetRootItemRect, Point(X, Y)) then
  begin
    SetRootItemHover(True);
    FHoverItem := nil;
  end else
  begin
    SetRootItemHover(False);
    if Selected = nil then Exit;
    MouseMoveItem := GetItemAtPos(X, Y, ItemPart);
    FHoverItem := MouseMoveItem;
    DoItemMouseEnter(MouseMoveItem);
  end;
  if (OldHoverItem <> FHoverItem)
    or (FHoverItemPart <> ItemPart) then
  begin
    FHoverItemPart := ItemPart;
    RefreshItem(FHoverItem);
    RefreshItem(OldHoverItem);
  end;
end;

procedure TNxPathControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  MouseUpItem, MouseDownItem: TNxPathNode;
  ItemPart: TPathItemPart;
begin
  inherited;
  if Selected = nil then Exit;
  SetRootItemDown(False);
  MouseDownItem := FDownItem;
  FDownItem := nil;
  if Assigned(MouseDownItem) then RefreshItem(MouseDownItem);
  MouseUpItem := GetItemAtPos(X, Y, ItemPart);
  if MouseUpItem = nil then Exit;
  if (MouseUpItem = MouseDownItem) and (ItemPart = pipTitle) then
    Selected := MouseUpItem;
end;

procedure TNxPathControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FImages) and (Operation = opRemove) then FImages := nil;
end;

procedure TNxPathControl.Paint;
var
  ItemDrawStyle: TPathItemDrawStyle;
begin
  inherited;
  if FUpdateCount > 0 then Exit;

  if (csDesigning in ComponentState)
    and (FItems.Count = 0) then
  with Canvas do
  begin
    Pen.Color := clGrayText;
    Pen.Style := psDot;
    Brush.Color := Color;
    Rectangle(ClientRect);
    Exit;
  end;

  { Draw root item }
  ItemDrawStyle := [];
  if FRootItemHover then Include(ItemDrawStyle, pdsHover);
  if FRootItemDown then Include(ItemDrawStyle, pdsDown);
  DrawRootItem(ItemDrawStyle);

  if Selected = nil then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(Rect(GetRootItemWidth, 0, ClientWidth, ClientHeight));
  end else
  begin
    Canvas.Font.Assign(Self.Font);
    DrawItems;
  end;
end;

procedure TNxPathControl.RefreshItem(Item: TNxPathNode);
var
  ItemRect: TRect;
begin
  if Item = nil then Exit;
  ItemRect := GetItemRect(Item);
  InvalidateRect(Handle, @ItemRect, False);
end;

procedure TNxPathControl.RefreshRootItem;
var
  ItemRect: TRect;
begin
  ItemRect := GetRootItemRect;
  InvalidateRect(Handle, @ItemRect, False);
end;

procedure TNxPathControl.SetButtonStyle(const Value: TPathButtonStyle);
begin
  FButtonStyle := Value;
  Invalidate;
end;

procedure TNxPathControl.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    if Assigned(FImages) and not Assigned(Value)
      then FImages.RemoveFreeNotification(Self);
    FImages := Value;
    FPopup.Images := Value;
    if Assigned(FImages) then FImages.FreeNotification(Self);
  end;
end;

procedure TNxPathControl.SetEnableVisualStyles(const Value: Boolean);
begin
  FEnableVisualStyles := Value;
  Invalidate;
end;

procedure TNxPathControl.SetPopupItems(PathItem: TNxPathNode);
var
  i: Integer;
  MenuItem: TMenuItem;
begin
  FPopup.Items.Clear;
  if PathItem = nil then
  begin
    for i := 0 to FItems.Count - 1 do
    begin
      if FItems[i].Level = 0 then
      begin
        MenuItem := TMenuItem.Create(FPopup);
        MenuItem.Caption := FItems[i].Text;
        MenuItem.Tag := i;
        MenuItem.ImageIndex := FItems[i].ImageIndex;
        MenuItem.OnClick := DoMenuItemClick;
        FPopup.Items.Add(MenuItem);
      end;
    end;
  end else
  begin
    for i := 0 to FItems.Count - 1 do
    begin
      if FItems[i].Parent = PathItem then
      begin
        MenuItem := TMenuItem.Create(FPopup);
        MenuItem.Caption := FItems[i].Text;
        MenuItem.Tag := i;
        MenuItem.ImageIndex := FItems[i].ImageIndex;
        MenuItem.OnClick := DoMenuItemClick;
        FPopup.Items.Add(MenuItem);
      end;
    end;

  end;
end;

procedure TNxPathControl.SetRootItemHover(const Value: Boolean);
begin
  if FRootItemHover <> Value then
  begin
    FRootItemHover := Value;
    RefreshRootItem;
  end;
end;

procedure TNxPathControl.SetRootItemDown(const Value: Boolean);
begin
  if FRootItemDown <> Value then
  begin
    FRootItemDown := Value;
    RefreshRootItem;
  end;
end;

procedure TNxPathControl.SetSelected(const Value: TNxPathNode);
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    DoSelect;
    Invalidate;
  end;
end;

procedure TNxPathControl.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxPathControl.WMSize(var Message: TWMSize);
begin
  inherited;
  if Selected <> nil then FFirstItem := GetFirstItem
    else FFirstItem := 0;
end;


{ TNxFloatPanel }

constructor TNxFloatPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csSetCaption, csReplicatable];
  ParentColor := False;
  Color := clWindow;
  FBorderColor := wsclDarkGray;
  Height := 200;
  Width := 185;
end;

procedure TNxFloatPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
{  	if not (csDesigning in ComponentState) then
    begin
      with Params do begin
        Style := (Style and not (WS_CHILD or WS_GROUP or WS_TABSTOP)) or WS_POPUP;
        ExStyle := ExStyle or WS_EX_TOPMOST or WS_EX_TOOLWINDOW;
        WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if IsWindowsXP then
      WindowClass.Style := WindowClass.Style or CS_DROPSHADOW;
    end;}
  end;
end;

procedure TNxFloatPanel.CreateWnd;
begin
  inherited;
end;

function TNxFloatPanel.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := True;
end;

function TNxFloatPanel.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

function TNxFloatPanel.GetCloseButtonRect: TRect;
begin
  with Result do
  begin
    Top := 12;
    Right := ClientWidth - 12;
    Bottom := Top + 8;
    Left := Right - 8;
  end;
end;

procedure TNxFloatPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);

end;

procedure TNxFloatPanel.Paint;
begin
  inherited;
  with Canvas do
  begin
    Pen.Color := clGray;
    Brush.Color := Color;
    Rectangle(ClientRect);
  end;
end;

procedure TNxFloatPanel.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TNxFloatPanel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

{ TNxOptionButton }

procedure TNxOptionButton.ApplyTransparency;
begin
  case FTransparent of
    True: begin
            if FTransparentColor = clNone then
            begin
              FGrayGlyph.TransparentColor := FGrayGlyph.Canvas.Pixels[0, FGrayGlyph.Height - 1];
              FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
            end else
            begin
              FGrayGlyph.TransparentColor := FGrayGlyph.Canvas.Pixels[0, FGrayGlyph.Height - 1];
              FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
            end;
            FGlyph.Transparent := True;
            FGrayGlyph.Transparent := True;
          end;
    False:
      begin
        FGlyph.Transparent := False;
        FGrayGlyph.Transparent := False;
      end;
  end;
end;

procedure TNxOptionButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNxOptionButton.CMMouseLeave(var Message: TMessage);
begin
  if FHover and not FDown then
  begin
    FHover := False;
    FDown := False;
    Invalidate;
  end;
end;

constructor TNxOptionButton.Create(AOwner: TComponent);
begin
  inherited;
  FHover := False;
  FDown := False;
  FFixedMargin := False;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FGlyphIndent := 5;
  FGrayGlyph := TBitmap.Create;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.OnChange := DoInnerMarginsChange;
  FTextSpacing := 2;
  FTransparent := False;
  FTransparentColor := clNone;
  FWrapKind := wkWordWrap;
  ParentColor := False;
  Color := clBtnFace;
end;

destructor TNxOptionButton.Destroy;
begin
  FreeAndNil(FGlyph);
  FreeAndNil(FGrayGlyph);
  FreeAndNil(FInnerMargins);
  inherited;
end;

procedure TNxOptionButton.DoGlyphChange(Sender: TObject);
begin
  FGrayGlyph.Assign(FGlyph);
  { Set transparent colors for both glyphs }
  ApplyTransparency;
  GrayscaleBitmap(FGrayGlyph);
  Invalidate;
end;

procedure TNxOptionButton.DoInnerMarginsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxOptionButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FDown := True;
  Invalidate;
end;

procedure TNxOptionButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not FHover then
  begin
    FHover := True;
    Invalidate;
  end;
end;

procedure TNxOptionButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if FDown then
  begin
    FDown := False;
    Invalidate;
  end;
end;

procedure TNxOptionButton.Paint;
const
  HoverIndex: array[Boolean] of Integer = (1, 2);
  DownIndex: array[Boolean] of Integer = (2, 3);
var
  AGlyph: TBitmap;
  R, InnerRect, CaptionRect, TxtRect, MarginRect: TRect;
begin
  inherited;
  { Draw Background }
  if FHover then
  begin
    if IsThemed then
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(ClientRect);
      if FDown then
        ThemeRect(Handle, Canvas.Handle, ClientRect, teToolbar, tcToolbarButton, DownIndex[FDown and FHover])
      else
        ThemeRect(Handle, Canvas.Handle, ClientRect, teToolbar, tcToolbarButton, HoverIndex[FHover])
    end else
    begin
      R := ClientRect;
      if FDown then
      begin
        Frame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1);
      end else Frame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1);
      Canvas.Brush.Color := Color;
      Canvas.FillRect(R);
    end;
  end else
  begin
    R := ClientRect;
    Canvas.Brush.Color := Color;
    Canvas.FillRect(R);
  end;

  { Draw Content }
  InnerRect := FInnerMargins.AsRect(Width, Height);

  CaptionRect := InnerRect;
  CaptionRect.Left := FInnerMargins.Left;
  CaptionRect.Top := FInnerMargins.Top;

  if Enabled then AGlyph := FGlyph else AGlyph := FGrayGlyph;
  if not AGlyph.Empty then
  begin
    TDrawProvider.ApplyBitmap(Canvas, FInnerMargins.Left, FInnerMargins.Top, AGlyph);
    if not FFixedMargin then Inc(CaptionRect.Left, AGlyph.Width + 8)
      else CaptionRect.Left := FInnerMargins.Left;
  end;

  Canvas.Font.Assign(Font);
  with Canvas do
  begin
    { Draw Caption }
    Font.Style := [fsBold];
    CaptionRect.Bottom := CaptionRect.Top + GetTextHeight(Canvas, Caption);

    if Enabled then
      DrawTextRect(Canvas, CaptionRect, Caption)
        else DrawDisabledText(Canvas, CaptionRect, Caption, taLeftJustify, False);

    { Draw Text }
    TxtRect := Rect(CaptionRect.Left, CaptionRect.Bottom + FTextSpacing, ClientWidth - InnerMargins.Right, ClientHeight - InnerMargins.Bottom);
    Font.Style := [];

    DrawFmtText(Canvas, TxtRect, FText, taLeftJustify, taAlignTop, FWrapKind, BiDiMode, not Enabled);

    if csDesigning in ComponentState then
    begin
      Pen.Color := clGrayText;
      Pen.Style := psDot;
      Brush.Style := bsClear;
			MarginRect := InnerRect;
      InflateRect(MarginRect, 1, 1);
      Rectangle(MarginRect);
      Brush.Style := Graphics.bsSolid;
    end;
  end;
end;

procedure TNxOptionButton.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TNxOptionButton.SetFixedMargin(const Value: Boolean);
begin
  FFixedMargin := Value;
  Invalidate;
end;

procedure TNxOptionButton.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

procedure TNxOptionButton.SetGlyphIndent(const Value: Integer);
begin
  FGlyphIndent := Value;
  Invalidate;
end;

procedure TNxOptionButton.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins := Value;
  Invalidate;
end;

procedure TNxOptionButton.SetText(const Value: WideString);
begin
  FText := Value;
  Invalidate;
end;

procedure TNxOptionButton.SetTextSpacing(const Value: Integer);
begin
  FTextSpacing := Value;
  Invalidate;
end;

procedure TNxOptionButton.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  if FGlyph.Empty then Exit;
  ApplyTransparency;
  Invalidate;
end;

procedure TNxOptionButton.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  if FGlyph.Empty then Exit;
  ApplyTransparency;
  Invalidate;
end;

procedure TNxOptionButton.SetWrapKind(const Value: TWrapKind);
begin
  FWrapKind := Value;
end;

procedure TNxOptionButton.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

{ TNxProgressBar }

constructor TNxProgressBar.Create(AOwner: TComponent);
begin
  inherited;
  FOrientation := pbHorizontal;
  FStep := 10;
end;

procedure TNxProgressBar.Paint;
begin
  inherited;

end;

procedure TNxProgressBar.SetOrientation(
  const Value: TProgressBarOrientation);
begin
  FOrientation := Value;
end;

{ TNxTreeView }

constructor TNxTreeView.Create(AOwner: TComponent);
begin
  inherited;
  FFirst := 0;
  FItems := TNxTreeNodes.Create(Self);
  FTextStyle := tsNormal;
  ParentColor := False;
  Color := clWindow;
end;

function TNxTreeView.GetNodeHeight: Integer;
var
  DC: HDC;
  Metrics: TTextMetric;
begin
  DC := Canvas.Handle;
  GetTextMetrics(DC, Metrics);
  Result := Metrics.tmHeight + 3;
end;

procedure TNxTreeView.Paint;
begin
  inherited;
  Canvas.Font.Assign(Font);
  PaintItems;
end;

procedure TNxTreeView.PaintButton(NodeRect: TRect; Expanded: Boolean);
var
  Y, X: Integer;
begin
  x := 4;
  Y := NodeRect.Top + ((NodeRect.Bottom - NodeRect.Top) div 2) - 3;
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    Brush.Style := bsClear;
    Rectangle(X, Y, X + 9, Y + 9);
    Brush.Style := Graphics.bsSolid;
    Pen.Color := clBtnText;

    { Draw + - sign }
    Polyline([Point(X + 2, Y + 4), Point(X + 7, Y + 4)]);
    if not Expanded then Polyline([Point(X + 4, Y + 2), Point(X + 4, Y + 7)]);
  end;
end;

procedure TNxTreeView.PaintItems;
var
  i, Y: Integer;
  NodeRect: TRect;
begin
  Y := 0;
  i := FFirst;
  while i < FItems.Count do
  begin
    NodeRect := Rect(0, Y, ClientWidth, Y + GetNodeHeight);
    PaintNode(FItems.Item[i], NodeRect);
    if FItems.Item[i].HasChildren then
      if FItems.Item[i].Expanded then
      begin

      end else
      begin
        Inc(i);
        Continue;
      end;
    Inc(i);
    Inc(Y, GetNodeHeight);
  end;
end;

procedure TNxTreeView.PaintNode(Node: TNxTreeNode; NodeRect: TRect);
var
  TextRect: TRect;
begin
  TextRect := Rect(20, NodeRect.Top + 1, ClientWidth, NodeRect.Bottom);
  case FTextStyle of
    tsNormal: DrawText(Canvas, TextRect, taLeftJustify, Node.Text);
    tsHtml: ProcessHTML(Canvas, TextRect, Node.Text, Point(-1, -1), Indent(0, 0), rtDraw, wkWordWrap);
  end;
  if Node.HasChildren then PaintButton(NodeRect, Node.Expanded);
end;

procedure TNxTreeView.SetTextStyle(const Value: TNxTextStyle);
begin
  FTextStyle := Value;
end;

{ TNxExpandPanel }

procedure TNxExpandPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  Inc(Rect.Left, FInnerMargins.Left);
  Inc(Rect.Top, GetCollapsedHeight + FInnerMargins.Top);
  Dec(Rect.Right, FInnerMargins.Right);
  Dec(Rect.Bottom, FInnerMargins.Bottom);
end;

procedure TNxExpandPanel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  Hover := False;
end;

constructor TNxExpandPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents,
    csDoubleClicks, csReplicatable];
  FButtonLeft := 10;
  FButtonTop := 10;
  FExpanded := True;
  FHover := False;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.OnChange := DoInnerMarginsChange;
  FResizeForm := False;
  ParentColor := False;
  Color := clVistaDialog;
  Height := 145;
  Width := 245;
end;

procedure TNxExpandPanel.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('FullHeight', ReadFullHeight, WriteFullHeight, True);
end;

destructor TNxExpandPanel.Destroy;
begin
  FreeAndNil(FInnerMargins);
  inherited;
end;

procedure TNxExpandPanel.DoCollapse;
begin
  if Assigned(FOnCollapse) then FOnCollapse(Self);
end;

procedure TNxExpandPanel.DoExpand;
begin
  if Assigned(FOnExpand) then FOnExpand(Self);
end;

procedure TNxExpandPanel.DoInnerMarginsChange(Sender: TObject);
begin
  Invalidate;
  Realign;
end;

function TNxExpandPanel.GetButtonRect: TRect;
begin
  Result := Rect(FButtonLeft, FButtonTop, FButtonLeft + 19, FButtonTop + 19);
end;

function TNxExpandPanel.GetCollapsedHeight: Integer;
begin
  Result := FButtonTop + 19 + 10;
end;

procedure TNxExpandPanel.HideChildrens;
var
  i: Integer;
begin
  for i := 0 to ControlCount -1 do
  begin
    Controls[i].Visible := False;
  end;
end;

procedure TNxExpandPanel.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then Expanded := not Expanded;
end;

procedure TNxExpandPanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  Down := PtInRect(GetButtonRect, Point(X, Y));
  if not Focused then SetFocus;
end;

procedure TNxExpandPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  Hover := PtInRect(GetButtonRect, Point(X, Y));
end;

procedure TNxExpandPanel.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Down then
  begin
    Expanded := not Expanded;
    FDown := False;
  end;
end;

procedure TNxExpandPanel.Paint;
const
  ExpandedStr: array[Boolean] of string = ('OPEN', 'CLOSE');
  HoverStr: array[Boolean] of string = ('', 'HOVER');
  DownStr: array[Boolean] of string = ('', 'DOWN');
var
  ResStr, s: string;
begin
  inherited; 
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(ClientRect);

    Pen.Style := psSolid;

    Pen.Color := clVistaDialogDivider;
    MoveTo(0, 0);
    LineTo(ClientWidth, 0);

    if Expanded then
    begin
      MoveTo(0, GetCollapsedHeight - 1);
      LineTo(ClientWidth, GetCollapsedHeight - 1);
      Pen.Color := clWhite;
      MoveTo(0, GetCollapsedHeight);
      LineTo(ClientWidth, GetCollapsedHeight);
    end;

    if (csDesigning in ComponentState) and Expanded then
    begin
      Pen.Color := clGrayText;
      Pen.Style := psDot;
      Rectangle(Rect(FInnerMargins.Left, GetCollapsedHeight + FInnerMargins.Top,
        ClientWidth - FInnerMargins.Right, ClientHeight - FInnerMargins.Bottom));
    end;
  end;
  ResStr := 'BUTTON';
  ResStr := ResStr + ExpandedStr[FExpanded];
  if not FDown then ResStr := ResStr + HoverStr[FHover]
    else ResStr := ResStr + DownStr[FDown];
  Draw32BitBitmapFromRes(Canvas, FButtonLeft, FButtonTop, ResStr);
  if Expanded then s := ExpandedText else s := CollapsedText;
  Canvas.Font.Assign(Font);
  Canvas.TextOut(FButtonLeft + 19 + 9, FButtonTop + 3, s);
end;

procedure TNxExpandPanel.ReadFullHeight(Reader: TReader);
begin
  FFullHeight := Reader.ReadInteger;
end;

procedure TNxExpandPanel.RefreshButton;
var
  R: TRect;
begin
  R := GetButtonRect;
  InvalidateRect(Handle, @R, False);
end;

procedure TNxExpandPanel.SetButtonLeft(const Value: Integer);
begin
  FButtonLeft := Value;
end;

procedure TNxExpandPanel.SetButtonTop(const Value: Integer);
begin
  FButtonTop := Value;
end;

procedure TNxExpandPanel.SetCollapsedText(const Value: WideString);
begin
  FCollapsedText := Value;
  Invalidate;
end;

procedure TNxExpandPanel.SetDown(const Value: Boolean);
begin
  if FDown <> Value then
  begin
    FDown := Value;
    RefreshButton;
  end;
end;

procedure TNxExpandPanel.SetExpanded(const Value: Boolean);
var
  Form: TCustomForm;
begin
  if FExpanded <> Value then
  begin
    FExpanded := Value;
    RefreshButton;
    Form := GetParentForm(Self);
    if FExpanded then
    begin
      ShowChildrens;
      if ResizeForm then Form.Height := Form.Height + (FFullHeight - Height);
      Height := FFullHeight;
      DoExpand; { event }
    end else
    begin
      FFullHeight := Height;
      Height := FButtonTop + 19 + 10;
      if ResizeForm then Form.Height := Form.Height - (FFullHeight - Height);
      HideChildrens;
      DoCollapse; { event }
    end;
  end;
end;

procedure TNxExpandPanel.SetExpandedText(const Value: WideString);
begin
  FExpandedText := Value;
  Invalidate;
end;

procedure TNxExpandPanel.SetHover(const Value: Boolean);
begin
  if FHover <> Value then
  begin
    FHover := Value;
    RefreshButton;
  end;
end;

procedure TNxExpandPanel.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins.Assign(Value);
end;

procedure TNxExpandPanel.SetResizeForm(const Value: Boolean);
begin
  FResizeForm := Value;
end;

procedure TNxExpandPanel.ShowChildrens;
var
  i: Integer;
begin
  for i := 0 to ControlCount -1 do
  begin
    Controls[i].Visible := True;
  end;
end;

procedure TNxExpandPanel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxExpandPanel.WriteFullHeight(Writer: TWriter);
begin
  Writer.WriteInteger(FFullHeight);
end;

{ TNxContainer }

constructor TNxContainer.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csAcceptsControls];
end;

{ TNxIconList }

procedure TNxIconList.CMMouseLeave(var Message: TMessage);
var
  FOldHoverIndex: Integer;
begin
  FOldHoverIndex := FHoverIndex;
  FHoverIndex := -1;
  RefreshItem(FOldHoverIndex, True);
end;

constructor TNxIconList.Create(AOwner: TComponent);
begin
  inherited;
  FHoverIndex := -1;
  FItems := TNxStringList.Create;
  FItemIndex := 0;
  FIndent := 0;
  FScrollBarColor := clHighlight;
  FScrollBarHeight := 16;
  FSpacing := 20;
  FThumbPressed := False;
  FThumbMousePos := 0;
  BorderColor := clGrayText;
  ParentColor := False;
  Color := clWindow;
end;

destructor TNxIconList.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

function TNxIconList.GetInnerRect: TRect;
begin
  Result := ClientRect;
  Dec(Result.Bottom, FScrollBarHeight);
  Inc(Result.Top, 1);
  Dec(Result.Right, 1);
  Inc(Result.Left, 1);
end;

function TNxIconList.GetItemAtPos(const X, Y: Integer): Integer;
var
  i, f, BmpY, TxtY: Integer;
begin
  Result := -1;
  f := -FIndent;
  for i := 0 to FItems.Count - 1 do
  begin
    Inc(f, FSpacing);
    BmpY := (GetInnerRect.Bottom - GetInnerRect.Top) div 2 - (FImages.Height + Canvas.TextHeight(FItems[i]) + 8) div 2;
    TxtY := BmpY + FImages.Height + 8 + Canvas.TextHeight(FItems[i]);
    if (X >= f) and (X <= f + FImages.Width) and (Y >= BmpY) and (Y <= TxtY) then
    begin
      Result := i;
      Exit;
    end;
    Inc(f, FImages.Width);
    Inc(f, FSpacing);
  end;
end;

function TNxIconList.GetItemRect(const Index: Integer;
  Expand: Boolean): TRect;
var
  i, f, BmpY: Integer;
begin
  f := -FIndent;
  for i := 0 to FItems.Count - 1 do
  begin
    Inc(f, FSpacing);
    if i = Index then
    begin
      BmpY := (GetInnerRect.Bottom - GetInnerRect.Top) div 2 - (FImages.Height + Canvas.TextHeight(FItems[i]) + 8) div 2;
      Result := Rect(f, BmpY, f + FImages.Width, BmpY + FImages.Height);
      if Expand then InflateRect(Result, 5, 5);
      Exit;
    end;
    Inc(f, FImages.Width);
    Inc(f, FSpacing);
  end;
end;

function TNxIconList.GetPageClientSize: Integer;
var
  p: Integer;
begin
  p := GetScrollArea.Right - GetScrollArea.Left;
  Result := GetScrollMax - (GetScrollArea.Right - GetScrollArea.Left);
  Result := p - Result;
end;

function TNxIconList.GetPageSize: Integer;
begin
  Result := GetPageClientSize;
  if Result < 10 then Result := 10;
end;

function TNxIconList.GetScrollArea: TRect;
begin
  Result := Rect(5, GetInnerRect.Bottom + 5, ClientWidth - 5, ClientHeight - 5);
end;

function TNxIconList.GetScrollMax: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FItems.Count - 1 do
  begin
    Inc(Result, FSpacing);
    Inc(Result, FImages.Width);
    Inc(Result, FSpacing);
  end;
end;

function TNxIconList.GetScrollRect: TRect;
begin
  Result :=  Rect(5 + FPosition, GetInnerRect.Bottom + 5,
                  5 + FPosition + GetPageSize, ClientHeight - 5);
end;

procedure TNxIconList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_LEFT: if FPosition > 0 then FPosition := FPosition - 1;
    VK_RIGHT: if FPosition + GetPageSize < GetScrollArea.Right - GetScrollArea.Left
      then FPosition := FPosition + 1;
  end;
  FIndent := FPosition;
  Invalidate;
end;

procedure TNxIconList.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  SetFocus;
  if PtInRect(GetScrollRect, Point(X, Y)) then
  begin
    FThumbPressed := True;
    FThumbMousePos := X - GetScrollRect.Left;
  end;
end;

procedure TNxIconList.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldHoverIndex, delta: Integer;
begin
  inherited;
  { Icons }
  OldHoverIndex := FHoverIndex;
  FHoverIndex := GetItemAtPos(X, Y);
  if FHoverIndex <> OldHoverIndex then
  begin
    if OldHoverIndex > -1 then RefreshItem(OldHoverIndex, True);
    if FHoverIndex > -1 then RefreshItem(FHoverIndex, True);
  end else Screen.Cursor := crDefault;
  if FHoverIndex > -1 then Screen.Cursor := crHandPoint;

  { Scroll Bar }
  if FThumbPressed then
  begin
    if GetPageClientSize > 0 then
    begin
      FOldPosition := FIndent;
      FIndent := X - FThumbMousePos;
      if FIndent < 0 then FIndent := 0;
      if FIndent + GetPageSize > GetScrollArea.Right - GetScrollArea.Left
        then FIndent := (GetScrollArea.Right - GetScrollArea.Left) - GetPageSize;
      if FOldPosition <> FIndent then
      begin
        FPosition := FIndent;
        ScrollContent(FOldPosition - FIndent);
        ScrollThumb(FIndent - FOldPosition);
      end;
    end else
    begin
      FOldPosition := FPosition;
      FPosition := X - FThumbMousePos;
      if FPosition < 0 then FPosition := 0;
      if FPosition + GetPageSize > GetScrollArea.Right - GetScrollArea.Left
        then FPosition := (GetScrollArea.Right - GetScrollArea.Left) - GetPageSize;

      delta := (GetScrollArea.Right - GetScrollArea.Left);

      FIndent := FPosition * Round(GetScrollMax / delta);

      Invalidate;
    end;
  end;
end;

procedure TNxIconList.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Index: Integer;
begin
  inherited;
  FThumbPressed := False;
  Index := GetItemAtPos(X, Y);
  if Index > -1 then
  begin
    ItemIndex := Index;
  end;
end;

procedure TNxIconList.Paint;
var
  Buffer: TBitmap;
  i, BmpX, BmpY, TxtX, TxtY: Integer;
  ScrollBarRect, StretchRect, BufferRect: TRect;
  StretchBitmap: TBitmap;
begin
  inherited;
  Buffer := TBitmap.Create;
  Buffer.Height := ClientHeight;
  Buffer.Width := ClientWidth;
  with Buffer.Canvas do
  begin
    Font.Assign(Self.Font);

    { Draw Background }
    Brush.Color := FBorderColor;
    FrameRect(ClientRect);
    FillRect(Rect(1, GetInnerRect.Bottom, ClientWidth - 1, ClientHeight - 1));

    Brush.Color := Self.Color;
    FillRect(GetInnerRect);

    { Draw Images }
    SetClipRect(Buffer.Canvas, GetInnerRect);
    BmpX := -FIndent;
    for i := 0 to FItems.Count - 1 do
    begin
      BmpY := (GetInnerRect.Bottom - GetInnerRect.Top) div 2 - (FImages.Height + TextHeight(FItems[i]) + 8) div 2;
      Inc(BmpX, FSpacing);

      if i < FImages.Count then
        if (FHoverIndex = i) or (FItemIndex = i) then
        begin
          StretchBitmap := TBitmap.Create;
          StretchBitmap.Width := FImages.Width;
          StretchBitmap.Height := FImages.Height;
          StretchBitmap.Canvas.Brush.Color := Self.Color;
          StretchBitmap.Canvas.FillRect(StretchBitmap.Canvas.ClipRect);
          FImages.Draw(StretchBitmap.Canvas, 0, 0, i);
          StretchRect := Rect(BmpX - 5, BmpY - 5, BmpX + FImages.Width + 5, BmpY + FImages.Height);
          StretchDraw(StretchRect, StretchBitmap);
          FreeAndNil(StretchBitmap);
        end else FImages.Draw(Buffer.Canvas, BmpX, BmpY, i);

      { Draw text }
      TxtX := BmpX + FImages.Width div 2 - TextWidth(FItems[i]) div 2;
      TxtY := BmpY + FImages.Height + 8;
      Brush.Style := bsClear;
      TextOut(TxtX, TxtY, FItems[i]);
      Brush.Style := Graphics.bsSolid;

      { Inc horizontal drawing position }
      Inc(BmpX, FImages.Width);
      Inc(BmpX, FSpacing);
    end;

    SetClipRect(Buffer.Canvas, ClientRect);

    { Draw ScrollBar }
    ScrollBarRect := GetScrollRect;
    Brush.Color := FScrollBarColor;
    FillRect(ScrollBarRect);
  end;
  BufferRect := Rect(0, 0, Buffer.Width, Buffer.Height);
  Canvas.CopyRect(BufferRect, Buffer.Canvas, BufferRect);
  FreeAndNil(Buffer);
end;

procedure TNxIconList.RefreshItem(const Index: Integer;
  Expand: Boolean);
var
  R: TRect;
begin
  R := GetItemRect(Index, Expand);
  InvalidateRect(Handle, @R, False);
end;

procedure TNxIconList.ScrollContent(Delta: Integer);
var
  UpdateRect: TRect;
begin
  UpdateRect := GetInnerRect;
  ScrollWindowEx(Handle, Delta, 0, nil, @UpdateRect, 0, @UpdateRect, SW_INVALIDATE);
end;

procedure TNxIconList.ScrollThumb(Delta: Integer);
var
  ScrollRect, ClipRect: TRect;
begin
  ClipRect := GetScrollArea;
  ScrollRect := GetScrollRect;
  ScrollWindowEx(Handle, Delta, 0, nil, @ClipRect, 0, @ScrollRect, SW_INVALIDATE);
end;

procedure TNxIconList.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TNxIconList.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure TNxIconList.SetItemIndex(const Value: Integer);
var
  OldItemIndex: Integer;
begin
  if csLoading in ComponentState then Exit;
  if Value = FItemIndex then Exit;
  OldItemIndex := FItemIndex;
  FItemIndex := Value;
  if OldItemIndex > -1 then RefreshItem(OldItemIndex, True);
  if FItemIndex > -1 then RefreshItem(FItemIndex, True);
  if Assigned(FOnChange) then FOnChange(Self); { event }
end;

procedure TNxIconList.SetItems(const Value: TNxStrings);
begin
  FItems.Assign(Value);
end;

procedure TNxIconList.SetScrollBarColor(const Value: TColor);
begin
  FScrollBarColor := Value;
  Invalidate;
end;

procedure TNxIconList.SetScrollBarHeight(const Value: TColor);
begin
  FScrollBarHeight := Value;
  Invalidate;
end;

procedure TNxIconList.SetSpacing(const Value: Integer);
begin
  FSpacing := Value;
  Invalidate;
end;

procedure TNxIconList.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxIconList.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

{ TNxHintWindow }

procedure TNxHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  AHeight, AWidth: Integer;
begin
  FText := AHint;
  with ProcessHTML(Canvas, ClientRect, FText, Point(0, 0),
    Indent(FHint.Indent.Left, FHint.Indent.Top), rtMeasure, wkWordWrap) do
  begin
    //Inc(Rect.Bottom, 24);

    //Set the "Width" Property of the Hint
    //Rect.Right := 400;
    UpdateBoundsRect(Rect);
    AWidth := Size.cx + 8;
    AHeight := Size.cy + 8;
  end;
  if Rect.Top + Height > Screen.DesktopHeight then
    Rect.Top := Screen.DesktopHeight - Height;
  if Rect.Left + Width > Screen.DesktopWidth then
    Rect.Left := Screen.DesktopWidth - Width;
  if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
  if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
  SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, AWidth, AHeight,
    SWP_SHOWWINDOW or SWP_NOACTIVATE);
  Invalidate;
end;

constructor TNxHintWindow.Create(AOwner: TComponent);
begin
  inherited;
  FHint := GetHintComponent;
end;

function TNxHintWindow.GetHintComponent: TNxHint;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Application.MainForm.ComponentCount - 1 do
    if Application.MainForm.Components[i] is TNxHint then
    begin
      Result := TNxHint(Application.MainForm.Components[i]);
      Exit;
    end;
end;

procedure TNxHintWindow.Paint;
begin
  ProcessHTML(Canvas, ClientRect, FText, Point(0, 0),
    Indent(FHint.Indent.Left, FHint.Indent.Top), rtDraw, wkWordWrap);
end;

{ TNxHint }

constructor TNxHint.Create(AOwner: TComponent);
begin
  inherited;
  FIndent := TNxIndent.Create;
end;

destructor TNxHint.Destroy;
begin
  FreeAndNil(FIndent);
  inherited;
end;

procedure TNxHint.SetIndent(const Value: TNxIndent);
begin
  FIndent := Value;
end;

{ TNxToolbar }

procedure DrawToolbarButton(Canvas: TCanvas; Rect: TRect; Down: Boolean = false);
begin
  with Canvas do
  begin
    if Down then
    begin
      Pen.Color := $00d3bcaa;
      Brush.Color := $00ecdbcf;
      RoundRect(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom, 3, 3);
    end else
    begin
      //DrawVistaToolbar(Canvas, Rect, clDarkTeal, clTealShadow);
      Pen.Color := $00d9c5b5;
      Brush.Style := bsClear;
      RoundRect(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom, 3, 3);
      Pen.Color := clWhite;
      InflateRect(Rect, -1, -1);
      RoundRect(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom, 2, 2);
      Brush.Style := Graphics.bsSolid;
    end;
  end;
end;

procedure TNxToolbar.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  HoverItem := nil;
end;

constructor TNxToolbar.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TNxToolbarItems.Create(Self);
  FImages := nil;
  FHoverItem := nil;
  Width := 250;
  Height := 31;
end;

destructor TNxToolbar.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

function TNxToolbar.GetChildOwner: TComponent;
begin
  Result := nil;
end;

procedure TNxToolbar.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  inherited;
	{ this will save items as childrens into dfm }
  for i := 0 to FItems.Count - 1 do Proc(FItems[i]);
end;

function TNxToolbar.GetItemAtPos(const X, Y: Integer): TNxToolItem;
var
  i, Pos, StartPos, ButtonSize: Integer;
begin
  Result := nil;
  i := 0;
  Pos := spaToolbarPadding;
  while (i < FItems.Count) and (Items[i].Position = tipLeft) do
  begin
    if Items[i].Visible then
    begin
      StartPos := Pos;
      ButtonSize := Items[i].GetItemSize.cx;
      if (X >= StartPos) and (X <= Pos + ButtonSize) then
      begin
        Result := Items[i];
        Exit;
      end;
      Inc(Pos, ButtonSize);
    end;
    Inc(i);
  end;

  if i < FItems.Count then
  begin
    Pos := ClientWidth - spaToolbarPadding;
    i := FItems.Count - 1;
    while (i < FItems.Count) and (Items[i].Position = tipRight) do
    begin
      if Items[i].Visible then
      begin
        ButtonSize := Items[i].GetItemSize.cx;
        if (X <= Pos) and (X >= Pos - ButtonSize) then
        begin
          Result := Items[i];
          Exit;
        end;
        Dec(Pos, ButtonSize);
      end;
      Dec(i);
    end;
  end;
end;

function TNxToolbar.GetItemRect(AItem: TNxToolItem): TRect;
var
  i, Pos: Integer;
begin
  { Left aligned items }
  Pos := spaToolbarPadding;
  i := 0;
  while (i < FItems.Count) and (Items[i].Position = tipLeft) do
  begin
    if Items[i].Visible then
    begin
      if Items[i] = AItem then
      begin
        Result := Rect(Pos, 0, Pos + Items[i].GetItemSize.cx, ClientHeight);
        Exit;
      end;
      Inc(Pos, Items[i].GetItemSize.cx);
    end;
    Inc(i);
  end;

  { Right aligned items }
  if i < FItems.Count then
  begin
    Pos := ClientWidth - spaToolbarPadding;
    i := FItems.Count - 1;
    while (i < FItems.Count) and (Items[i].Position = tipRight) do
    begin
      if Items[i].Visible then
      begin
        if Items[i] = AItem then
        begin
          Result := Rect(Pos - Items[i].GetItemSize.cx, 0, Pos, ClientHeight);
          Exit;
        end;
        Dec(Pos, Items[i].GetItemSize.cx);
      end;
      Dec(i);
    end;
  end;
end;

function TNxToolbar.IndexOf(AItem: TNxToolItem): Integer;
begin
  Result := FItems.IndexOf(AItem);
end;

procedure TNxToolbar.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  FPopupPoint: TPoint;
begin
  inherited;
  DownItem := GetItemAtPos(X, Y);
  if DownItem is TNxToolButton then
  begin
    if Assigned(TNxToolButton(DownItem).PopupMenu) then
    begin
      FPopupPoint.Y := ClientHeight - 2;
      FPopupPoint.X := GetItemRect(DownItem).Left;
      FPopupPoint := ClientToScreen(FPopupPoint);
      TNxToolButton(DownItem).PopupMenu.Popup(FPopupPoint.X, FPopupPoint.Y);
    end;
  end;
end;

procedure TNxToolbar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not Assigned(DownItem) then HoverItem := GetItemAtPos(X, Y);
end;

procedure TNxToolbar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  UpItem: TNxToolItem;
begin
  inherited;
  UpItem := GetItemAtPos(X, Y);
  if Assigned(UpItem) and (UpItem = DownItem) then
  begin
    UpItem.DoClick;
  end;
  DownItem := nil;
end;

procedure TNxToolbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages) then FImages := nil;
end;

procedure TNxToolbar.Paint;
var
  i, X, ButtonSize: Integer;
  BarRect, BorderRect: TRect;
  ItemState: TNxToolItemState;
begin
  inherited;
  Canvas.Font.Assign(Font);
  BarRect := ClientRect;
  Dec(BarRect.Bottom, 2);
  DrawVistaToolbar(Canvas, BarRect, clTealShadow, clDarkTeal);
  with Canvas do
  begin
    Pen.Color := $00ebdbcf;
    Polyline([Point(0, ClientHeight - 2), Point(ClientWidth, ClientHeight - 2)]);
    Pen.Color := $00c5b1a2;
    Polyline([Point(0, ClientHeight - 1), Point(ClientWidth, ClientHeight - 1)]);
  end;

  i := 0;
  X := spaToolbarPadding;

  { Draw left items }
  while (i < FItems.Count) and (Items[i].Position = tipLeft) do
  begin
    if Items[i].Visible then
    begin
      ButtonSize := FItems[i].GetItemSize.cx;
      BorderRect := Rect(X, 0, X + ButtonSize, ClientHeight);
      BorderRect.Top := 3;
      BorderRect.Bottom := ClientHeight - 4;
      ItemState := [];
      if HoverItem = Items[i] then ItemState := [isHover];
      if DownItem = Items[i] then Include(ItemState, isDown);
      FItems[i].Paint(BorderRect, ItemState);
      Inc(X, ButtonSize)
    end;
    Inc(i);
  end;

  if i < FItems.Count then
  begin
    X := ClientWidth - spaToolbarPadding;
    i := FItems.Count - 1;
    while (i < FItems.Count) and (Items[i].Position = tipRight) do
    begin
      if Items[i].Visible then
      begin
        ButtonSize := FItems[i].GetItemSize.cx;
        BorderRect := Rect(X - ButtonSize, 0, X, ClientHeight);
        BorderRect.Top := 3;
        BorderRect.Bottom := ClientHeight - 4;
        ItemState := [];
        if HoverItem = Items[i] then ItemState := [isHover];
        if DownItem = Items[i] then Include(ItemState, isDown);
        FItems[i].Paint(BorderRect, ItemState);
        Dec(X, ButtonSize);
      end;
      Dec(i);
    end;
  end;
end;

procedure TNxToolbar.RefreshItem(Item: TNxToolItem);
var
  R: TRect;
begin
  if Assigned(Item) then
  begin
    R := GetItemRect(Item);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TNxToolbar.SetChildOrder(Child: TComponent; Order: Integer);
begin

end;

procedure TNxToolbar.SetDownItem(const Value: TNxToolItem);
var
  OldDownItem: TNxToolItem;
begin
  if FDownItem <> Value then
  begin
    OldDownItem := FDownItem;
    FDownItem := Value;
    if FDownItem <> OldDownItem then
    begin
      if Assigned(OldDownItem) then RefreshItem(OldDownItem);
      if Assigned(FDownItem) then RefreshItem(FDownItem);
    end;
  end;
end;

procedure TNxToolbar.SetHoverItem(const Value: TNxToolItem);
var
  OldHoverItem: TNxToolItem;
begin
  if FHoverItem <> Value then
  begin
    OldHoverItem := FHoverItem;
    FHoverItem := Value;
    if FHoverItem <> OldHoverItem then
    begin
      if Assigned(OldHoverItem) then RefreshItem(OldHoverItem);
      if Assigned(FHoverItem) then RefreshItem(FHoverItem);
    end;
  end;
end;

procedure TNxToolbar.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    if Assigned(Value) then FImages.FreeNotification(Self)
      else FImages.RemoveFreeNotification(Self);
  end;
end;

procedure TNxToolbar.SetItems(const Value: TNxToolbarItems);
begin
  FItems := Value;
end;

procedure TNxToolbar.SetPosition(const Index: Integer;
  Position: TNxToolbarItemPosition);
var
  i: Integer;
begin
  if Position <> Items[Index].Position then
  begin
    if Position = tipLeft then
    begin
      for i := Index downto 0 do
      begin
        Items[i].FPosition := tipLeft;
      end;
    end else
    begin
      for i := Index to FItems.Count - 1 do
      begin
        Items[i].FPosition := tipRight;
      end;
    end;
  end;
end;

procedure TNxToolbar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

{ TNxToolItem }

constructor TNxToolItem.Create(AOwner: TComponent);
begin
  inherited;
  if Assigned(FItems) and (FItems.Count > 0) then
  begin
    FPosition := FItems.Item[FItems.Count - 1].FPosition;
  end else FPosition := tipLeft;
  FVisible := True;
end;

destructor TNxToolItem.Destroy;
begin
  FItems.Remove(Self);
  inherited;
end;

procedure TNxToolItem.DoClick;
begin
  if Assigned(FOnClick) then FOnClick(Self);
end;

function TNxToolItem.GetIndex: Integer;
begin
  Result := FItems.IndexOf(Self);
end;

function TNxToolItem.GetItemSize: TSize;
begin

end;

function TNxToolItem.GetParentComponent: TComponent;
begin
  Result := FItems.FToolbar;
end;

function TNxToolItem.HasParent: Boolean;
begin
  Result := True;
end;

procedure TNxToolItem.Paint(ARect: TRect; State: TNxToolItemState);
begin

end;

procedure TNxToolItem.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  if Assigned(FItems) then FItems.FToolbar.RefreshItem(Self);
end;

procedure TNxToolItem.SetParentComponent(Value: TComponent);
begin
  if Value is TNxToolbar then
  begin
    TNxToolbar(Value).Items.AddItem(Self);
  end;
end;

procedure TNxToolItem.SetPosition(const Value: TNxToolbarItemPosition);
begin
  if FPosition <> Value then
  begin
    FItems.FToolbar.SetPosition(Index, Value);
    FPosition := Value;
    if Assigned(FItems) then FItems.FToolbar.Invalidate;
  end;
end;

procedure TNxToolItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  if Assigned(FItems) then FItems.FToolbar.Invalidate;
end;

{ TNxToolbarItems }

function TNxToolbarItems.Add(
  ItemClass: TNxToolbarItemClass): TNxToolItem;
begin
  Result := TNxToolbarItemClass.Create(FToolbar);
  FItems.Add(Result);
end;

procedure TNxToolbarItems.AddItem(Item: TNxToolItem);
begin
  Item.FItems := Self;
  FItems.Add(Item);
  FToolbar.RefreshItem(Item);
end;

procedure TNxToolbarItems.Clear;
var
  i: Integer;
begin
  for i := FItems.Count - 1 downto 0 do Item[i].Free;
  FToolbar.Invalidate;
end;

constructor TNxToolbarItems.Create(AToolbar: TNxToolbar);
begin
  FToolbar := AToolbar;
  FItems := TList.Create;
end;

destructor TNxToolbarItems.Destroy;
var
  i: Integer;
begin
  for i := FItems.Count - 1 downto 0 do
  begin
    Item[i].Free;
  end;
  FreeAndNil(FItems);
  inherited;
end;

function TNxToolbarItems.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TNxToolbarItems.GetItem(Index: Integer): TNxToolItem;
begin
  Result := TNxToolItem(FItems[Index]);
end;

function TNxToolbarItems.IndexOf(AItem: TNxToolItem): Integer;
begin
  if Assigned(FItems) then Result := FItems.IndexOf(AItem) else Result := -1;
end;

procedure TNxToolbarItems.Move(CurIndex, NewIndex: Integer);
begin
  FItems.Move(CurIndex, NewIndex);
end;

procedure TNxToolbarItems.Remove(AItem: TNxToolItem);
begin
  FItems.Delete(FItems.IndexOf(AItem));
end;

procedure TNxToolbarItems.SetItem(Index: Integer;
  const Value: TNxToolItem);
begin

end;

{ TNxToolButton }

constructor TNxToolButton.Create(AOwner: TComponent);
begin
  inherited;
  FImageIndex := -1;
end;

function TNxToolButton.GetItemSize: TSize;
begin
  Result.cy := FItems.FToolbar.Height - 3 - 4;
  Result.cx := sizButtonMargin;
  if Assigned(FItems.FToolbar.FImages)
    and (InRange(ImageIndex, 0, FItems.FToolbar.Images.Count - 1)) then
  begin
    Inc(Result.cx, FItems.FToolbar.Images.Width);
    if Caption <> '' then Inc(Result.cx, spaImageToText);
  end;
  if Caption <> '' then Inc(Result.cx, FItems.FToolbar.Canvas.TextWidth(Caption));
  Inc(Result.cx, sizButtonMargin);
  if Assigned(FPopupMenu) then Inc(Result.cx, 16);
end;

procedure TNxToolButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FPopupMenu) then FPopupMenu := nil;
end;

procedure TNxToolButton.Paint(ARect: TRect; State: TNxToolItemState);
var
  X, Y, M: Integer;
  TextRect: TRect;
begin
  if (isDown in State) then
  begin
    DrawToolbarButton(FItems.FToolbar.Canvas, ARect, True);
  end else if (isHover in State) then DrawToolbarButton(FItems.FToolbar.Canvas, ARect);
  X := ARect.Left + sizButtonMargin;
  Y := 0;
  if Assigned(FItems.FToolbar.FImages) then
  begin
    Y := FItems.FToolbar.ClientHeight div 2 - FItems.FToolbar.FImages.Height div 2;
  end;
  if Assigned(FItems.FToolbar.Images) and
    InRange(ImageIndex, 0, FItems.FToolbar.Images.Count - 1) then
  begin
    FItems.FToolbar.FImages.Draw(FItems.FToolbar.Canvas, X, Y, ImageIndex);
    Inc(X, FItems.FToolbar.FImages.Width);
    Inc(X, spaImageToText);
    if Caption <> '' then Inc(X, spaImageToText);
  end;
  TextRect := Rect(X, 0, X + FItems.FToolbar.Canvas.TextWidth(Caption), FItems.FToolbar.ClientHeight);
  if Caption <> '' then
  begin
    DrawTextRect(FItems.FToolbar.Canvas, TextRect, Caption);
    Inc(X, FItems.FToolbar.Canvas.TextWidth(Caption));
  end;
  if Assigned(PopupMenu) then
  begin
    Inc(X, 8);
    M := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
    with FItems.FToolbar.Canvas do
    begin
      Pen.Color := clBlack;
      Brush.Color := clBlack;
    end;
    FItems.FToolbar.Canvas.Polygon([
      Point(X, M),
      Point(X + 6, M),
      Point(X + 3, M +3 )
    ]);
  end;
end;

procedure TNxToolButton.SetHint(const Value: string);
begin
  FHint := Value;
end;

procedure TNxToolButton.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  if Assigned(FItems) then FItems.FToolbar.RefreshItem(Self);
end;

procedure TNxToolButton.SetPopupMenu(const Value: TPopupMenu);
begin
  if FPopupMenu <> Value then
  begin
    FPopupMenu := Value;
    if Assigned(Value) then FPopupMenu.FreeNotification(Self)
      else FPopupMenu.RemoveFreeNotification(Self);
    if Assigned(FItems) then FItems.FToolbar.RefreshItem(Self);
  end;
end;

{ TNxToolSeparator }

function TNxToolSeparator.GetItemSize: TSize;
begin
  Result.cy := FItems.FToolbar.ClientHeight;
  Result.cx := sizButtonMargin + 2 + sizButtonMargin;
end;

procedure TNxToolSeparator.Paint(ARect: TRect; State: TNxToolItemState);
begin
  with FItems.FToolbar.Canvas do
  begin
    Pen.Color := $00d9c5b5;
    MoveTo(ARect.Left+ sizButtonMargin, ARect.Top + 3);
    LineTo(ARect.Left+ sizButtonMargin, ARect.Bottom - 5);
    Pen.Color := clWhite;
    MoveTo(ARect.Left + sizButtonMargin + 1, ARect.Top + 3);
    LineTo(ARect.Left + sizButtonMargin + 1, ARect.Bottom - 5);
  end;
end;

{ TNxAlertList }

function TNxAlertList.Add(ACaption, AText: WideString; AutoPopup: Boolean): TNxAlertWindow;
begin
  Result := TNxAlertWindow.Create(Self);
  Result.Caption := ACaption;
  Result.Text := AText;
  Result.OnClosing := DoAlertClosing;
  Add(Result, AutoPopup);
end;

procedure TNxAlertList.Add(Alert: TNxAlertWindow; AutoPopup: Boolean);
begin
  FAlerts.Add(Alert);
  if AutoPopup then Alert.Popup;
end;

procedure TNxAlertList.AddCopy(Alert: TNxAlertWindow; AutoPopup: Boolean);
var
  NewAlert: TNxAlertWindow;
begin
  NewAlert := TNxAlertWindow.Create(Self);
  NewAlert.Assign(Alert);
  NewAlert.OnClosing := DoAlertClosing;
  Add(NewAlert, AutoPopup);
end;

procedure TNxAlertList.Clear;
var
  i: Integer;
begin
  for i := 0 to Pred(FAlerts.Count) do Alert[i].Free;
  FAlerts.Clear;
end;

constructor TNxAlertList.Create(AOwner: TComponent);
begin
  inherited;
  FAlerts := TList.Create;
  FAutoRelease := True;
  FAutoRemove := True;
end;

destructor TNxAlertList.Destroy;
var
  i: Integer;
begin
  for i := Pred(FAlerts.Count) downto 0 do
  begin
    if TNxAlertWindow(FAlerts[i]).InProgress then
      TNxAlertWindow(FAlerts[i]).DoClose;
  end;
  FreeAndNil(FAlerts);
  inherited;
end;

procedure TNxAlertList.DoAlertClosing(Sender: TObject);
begin
  if AutoRemove then Remove(Sender as TNxAlertWindow);
  if AutoRelease then FreeAndNil(Sender);
end;

function TNxAlertList.GetAlert(const Index: Integer): TNxAlertWindow;
begin
  Result := TNxAlertWindow(FAlerts[Index]);
end;

function TNxAlertList.IndexOf(Alert: TNxAlertWindow): Integer;
begin
  Result := FAlerts.IndexOf(Alert);
end;

procedure TNxAlertList.Remove(Alert: TNxAlertWindow);
var
  Index: Integer;
begin
  Index := FAlerts.IndexOf(Alert);
  if InRange(Index, 0, Pred(FAlerts.Count)) then FAlerts.Delete(Index);
end;

procedure TNxAlertList.SetAlert(const Index: Integer;
  const Value: TNxAlertWindow);
begin
  FAlerts[Index] := Value;
end;

initialization

finalization
  if IndentList <> nil then ClearIndents;

end.
