{
  Next Collection
  Copyright (C) 1996-2004 by Berg
  All rights reserved.

  $id:NxPageControl.pas 15/04/2004 bn
}

unit NxPageControl;

interface              

uses
	Windows, Classes, Messages, Types, Controls, Graphics, Dialogs,
  SysUtils, ImgList, ExtCtrls, Menus,
  NxCollection, NxSharedCommon;

const
  sizRightMargin = 23;
  sizDesignButtons = 16;
  sizDesignHeight = 25;

  { Design Arrow Buttons Width }
  sizDsgnArrowBtnWidth = 16;

  { Scroll timer interval }
  intScrollTimer = 100;

  clDiscreetSilver = $00BBBBBB;

type
  TNxTabSheet = class;
  TPopupMenuClass = class of TPopupMenu;

  TTabDisplayMode = (tdTextOnly, tdGlyph, tdImageIndex);
  TBackgroundKind = (bkSolid, bkCustom, bkHorzGradient, bkTransparent, bkVertGradient, bkInveseVertGradient);
  TPageOptions = set of (pgAlwaysShowTabsRect, pgBoldActiveTab, pgCloseButton,
    pgConstantScroll, pgCustomTabsPopup, pgPageBorder, pgScrollButtons, pgTabsPopup, pgTopBorder);
  TTabPosition = (tpTop, tpBottom);
  TTabStyle = (tsClassic, tsFlat, tsOneNote, tsWhidbey{, tsOutlook2007}, tsDexter); //mb+
  TPageButton = (pbNone, pbClose, pbPopup, pbScrollLeft, pbScrollRight);

  TNxCustomTabsPopupEvent = procedure (Sender: TObject; X, Y: Integer) of object;
  TPageChangingEvent = procedure (Sender: TObject; PageIndex: Integer; var AllowChange: Boolean) of object;
  TPageCloseEvent = procedure (Sender: TObject; PageIndex: Integer; var Accept: Boolean) of object;
  TCustomDrawBackground = procedure (Sender: TObject; BackgroundRect: TRect) of object;
  TTabClickEvent = procedure (Sender: TObject; PageIndex: Integer) of object;

  TNxCustomNotebook = class(TCustomControl)
  private
    FActivePage: TNxTabSheet;
    FActivePageIndex: Integer;
    FPageList: TList;
    FOnChange: TNotifyEvent;
    FOnChanging: TPageChangingEvent;
    FOnPageClose: TPageCloseEvent;
    function GetPageCount: Integer;
    function GetPages(Index: Integer): TNxTabSheet;
    procedure SetActivePage(const Value: TNxTabSheet);
    procedure SetActivePageIndex(const Value: Integer);
    procedure SetPages(Index: Integer; const Value: TNxTabSheet);
  protected
    procedure ActivePageChanged; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoChange; dynamic;
    procedure DoChanging(PageIndex: Integer; var AllowChange: Boolean); dynamic;
    procedure DoPageClose(PageIndex: Integer; var Accept: Boolean); dynamic;
    function GetInnerHeight: Integer; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure ValidateInsert(AComponent: TComponent); override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetPageIndex(Page: TNxTabSheet): Integer;
    procedure AddPage(Page: TNxTabSheet; Insert: Boolean = True);
    procedure DeletePage(TabSheet: TNxTabSheet);
    procedure InsertPage(const Index: Integer; TabSheet: TNxTabSheet);
    procedure MovePage(FromPos, ToPos: Integer);
    procedure RefreshPage(const Index: Integer); virtual;
    procedure RemovePage(Page: TNxTabSheet); virtual;
    procedure SetPageIndex(Page: TNxTabSheet; Index: Integer);
    procedure SelectNextPage;
    procedure SelectPrevPage;
    property Canvas;
    property PageCount: Integer read GetPageCount;
    property Pages[Index: Integer]: TNxTabSheet read GetPages write SetPages;
  published
    property ActivePage: TNxTabSheet read FActivePage write SetActivePage;
    property ActivePageIndex: Integer read FActivePageIndex write SetActivePageIndex;
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Hint;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnClick;
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
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnMouseUp;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TPageChangingEvent read FOnChanging write FOnChanging;
    property OnPageClose: TPageCloseEvent read FOnPageClose write FOnPageClose;
    property OnResize;
    property OnStartDrag;
  end;

  TArrowBtnKind = (abNone, abLeft, abRight);

  TNxNotebook = class(TNxCustomNotebook)
  private
    FDesignButtons: Boolean;
    FScrollPos: Integer;
    function GetArrowBtnRect(Kind: TArrowBtnKind): TRect;
    function GetScrollMax: Integer;
    procedure SetDesignButtons(const Value: Boolean);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure DrawArrowBtn(Kind: TArrowBtnKind);
    function GetArrowBtnAtPos(const X, Y: Integer): TArrowBtnKind;
    function GetDesignButtonAtPos(X, Y: Integer): Integer;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure PaintDesignButtons; virtual;
    procedure ScrollButtons(Delta: Integer);
  public
  	constructor Create(AOwner: TComponent); override;
  published
    property DesignButtons: Boolean read FDesignButtons write SetDesignButtons default False;
  end;

  TScrollMethod = (smTab, smPixels, smSelect);

  TNxPageControl = class(TNxCustomNotebook)
  private
    FAdaptiveColors: Boolean;
    FBackgroundColor: TColor;
    FBackgroundKind: TBackgroundKind;
    FCloseBtnBitmap: TBitmap;
    FDownButton: TPageButton;
    FDownTab: TNxTabSheet;
    FDownPageIndex: Integer;
    FHoverButton: TPageButton;
    FHoverPageIndex: Integer;
    FImages: TCustomImageList;
    FIndent: Integer;
    FMargin: Integer;
    FOldHeight: Integer;
    FOldWidth: Integer;
    FOnCustomTabsPopup: TNxCustomTabsPopupEvent;
    FOptions: TPageOptions;
    FScrollMethod: TScrollMethod;
    FScrollPos: Integer;
    FScrollTimer: TTimer;
    FShowTabs: Boolean;
    FSpacing: Integer;
    FTabAlignment: TAlignment;
    FTabHeight: Integer;
    FTabMaxWidth: Integer;
    FTabMoving: Boolean;
    FTabPosition: TTabPosition;
    FTabsPopup: TPopupMenu;
    FTabStyle: TTabStyle;
    FTopIndent: Integer;
    FTabMargin: Integer;
    FPartialTabs: Boolean;
    FOnCustomDrawBackground: TCustomDrawBackground;
    FOnTabClick: TTabClickEvent;
    procedure SetAdaptiveColors(const Value: Boolean);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetBackgroundKind(const Value: TBackgroundKind);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetIndent(const Value: Integer);
    procedure SetMargin(const Value: Integer);
    procedure SetOptions(const Value: TPageOptions);
    procedure SetShowTabs(const Value: Boolean);
    procedure SetSpacing(const Value: Integer);
    procedure SetTabAlignment(const Value: TAlignment);
    procedure SetTabHeight(const Value: Integer);
    procedure SetTabPosition(const Value: TTabPosition);
    procedure SetTabStyle(const Value: TTabStyle);
    procedure SetTopIndent(const Value: Integer);
    procedure SetTabMaxWidth(const Value: Integer);
    procedure SetTabMargin(const Value: Integer);
    procedure SetPartialTabs(const Value: Boolean);
  protected
    procedure ActivePageChanged; override;
    function GetButtonRect(Kind: TPageButton): TRect; virtual;
    function GetFirstVisible: Integer;
    function GetInnerHeight: Integer; override;
    function GetScrollMax: Integer;
    function GetTabsRect: TRect;
    function GetTabsSpacing: Integer; virtual;
    function GetTabsTotalWidth: Integer;
    function IsEndPos: Boolean;
    function IsStartPos: Boolean;
    function TabInView(const Index: Integer): Boolean;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure DoMenuItemClick(Sender: TObject);
    procedure DoScrollTimer(Sender: TObject);
    procedure DoCustomDrawBackground(BackgroundRect: TRect); dynamic;
    procedure DoCustomTabsPopup(X, Y: Integer); dynamic;
    procedure DoTabClick(PageIndex: Integer); dynamic;
    procedure DrawButton(ARect: TRect; Kind: TPageButton);
    procedure DrawClassicTab(r: TRect; Caption: string; TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
    procedure DrawFlatTab(r: TRect; Caption: string; TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
    procedure DrawOutlook2007Tab(r: TRect; Caption: string; TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
    procedure DrawOneNoteTab(r: TRect; Caption: string; TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
    procedure DrawPageBorder(ARect: TRect);
    procedure DrawPolygon(Points: array of TPoint; Rect: TRect); virtual;
    procedure DrawPolyline(Points: array of TPoint; Rect: TRect); virtual;
    procedure DrawTab(r: TRect; Page: TNxTabSheet; Active, First: Boolean); virtual;
    procedure DrawTabsBackground; virtual;
    procedure DrawWhidbeyTab(r: TRect; Caption: string; TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
    procedure DrawDexterTab(r: TRect; Caption: string; TabColor: TColor; Glyph: TBitmap; Active, First: Boolean); //mb+
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure InternalScroll(Delta: Integer);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure SetClipPolygon(Points: array of TPoint; Rect: TRect);
    procedure ShowTabsPopup;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetButtonAtPos(Point: TPoint): TPageButton;
    function GetTabAtPos(const X, Y: Integer): TNxTabSheet;
    function GetTabByCaption(const S: WideString; IgnoreCase: Boolean = False): TNxTabSheet;
    function GetTabClientWidth(APage: TNxTabSheet): Integer;
    function GetTabRect(Index: Integer): TRect;
    function GetTabsClientRect: TRect;
    function GetTabsClientWidth: Integer;
    function GetTabsEdge: Integer;
    function GetTabsRight: Integer;
    function GetTabWidth(APage: TNxTabSheet): Integer;
    function IsTabVisible(APage: TNxTabSheet): Boolean;
    procedure MakeVisible(const Index: Integer);
    procedure RefreshButton(Button: TPageButton);
    procedure RefreshPage(const Index: Integer); override;
    procedure RefreshTabs;
    procedure ScrollToTab(const Index: Integer);
    procedure ScrollTabs(Delta: Integer);
  published
    property AdaptiveColors: Boolean read FAdaptiveColors write SetAdaptiveColors default True;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clSilver;
    property BackgroundKind: TBackgroundKind read FBackgroundKind write SetBackgroundKind default bkSolid;
    property Images: TCustomImageList read FImages write SetImages;
    property Indent: Integer read FIndent write SetIndent default 2;
    property Margin: Integer read FMargin write SetMargin;
    property Options: TPageOptions read FOptions write SetOptions default [pgBoldActiveTab, pgCloseButton, pgScrollButtons, pgTopBorder];
    property PartialTabs: Boolean read FPartialTabs write SetPartialTabs default False;
    property ScrollMethod: TScrollMethod read FScrollMethod write FScrollMethod default smPixels;
    property ShowTabs: Boolean read FShowTabs write SetShowTabs default True;
    property Spacing: Integer read FSpacing write SetSpacing;
    property TabAlignment: TAlignment read FTabAlignment write SetTabAlignment default taCenter;
    property TabMargin: Integer read FTabMargin write SetTabMargin default 0;
    property TabHeight: Integer read FTabHeight write SetTabHeight;
    property TabMaxWidth: Integer read FTabMaxWidth write SetTabMaxWidth default 0;
    property TabPosition: TTabPosition read FTabPosition write SetTabPosition default tpTop;
    property TabStyle: TTabStyle read FTabStyle write SetTabStyle default tsWhidbey;
    property TopIndent: Integer read FTopIndent write SetTopIndent default 3;
    property OnCustomDrawBackground: TCustomDrawBackground read FOnCustomDrawBackground write FOnCustomDrawBackground;
    property OnCustomTabsPopup: TNxCustomTabsPopupEvent read FOnCustomTabsPopup write FOnCustomTabsPopup;
    property OnTabClick: TTabClickEvent read FOnTabClick write FOnTabClick;
  end;

  TNxTabGlyph = class(TPersistent)
  private
    FLeftGlyph: TBitmap;
    FRightGlyph: TBitmap;
    procedure SetLeftGlyph(const Value: TBitmap);
    procedure SetRightGlyph(const Value: TBitmap);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property LeftGlyph: TBitmap read FLeftGlyph write SetLeftGlyph;
    property RightGlyph: TBitmap read FRightGlyph write SetRightGlyph;
  end;

  TNxTabSheet = class(TCustomControl)
  private
    FActiveTabColor: TColor;
    FCaption: WideString;
    FData: TObject;
    FDisplayMode: TTabDisplayMode;
    FGlyph: TBitmap;
    FImageIndex: TImageIndex;
    FMargin: Integer;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FPageControl: TNxCustomNotebook;
    FPageStyle: TNxPanelStyle;
    FPageVisible: Boolean;
    FParentTabFont: Boolean;
    FTabColor: TColor;
    FTabFont: TFont;
    FTabFontUpdating: Boolean;
    FTabVisible: Boolean;
    FTabWidth: Integer;
    FTransparentColor: TColor;
    FUpdating: Boolean;
    FOnPaint: TNotifyEvent;
    function GetPageIndex: Integer;
    procedure SetCaption(const Value: WideString);
    procedure SetDisplayMode(const Value: TTabDisplayMode);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetMargin(const Value: Integer);
    procedure SetPageIndex(const Value: Integer);
    procedure SetPageControl(const Value: TNxCustomNotebook);
    procedure SetPageVisible(const Value: Boolean);
    procedure SetParentTabFont(const Value: Boolean);
    procedure SetTabColor(const Value: TColor);
    procedure SetTabFont(const Value: TFont);
    procedure SetTabVisible(const Value: Boolean);
    procedure SetTabWidth(const Value: Integer);
    procedure SetTransparentColor(const Value: TColor);
    function GetIndex: Integer;
    procedure SetActiveTabColor(const Value: TColor);
    procedure SetPageStyle(const Value: TNxPanelStyle);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure AssignFont(Source: TFont);
    procedure Changed; dynamic;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CreateWnd; override;
    procedure DoGlyphChange(Sender: TObject);
    procedure DoHide; dynamic;
    procedure DoPaint; dynamic;
    procedure DoShow; dynamic;
    procedure DoTabFontChange(Sender: TObject);
    procedure Paint; override;
    procedure RefreshTab;
    procedure SetZOrder(TopMost: Boolean); override;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetParentComponent(Value: TComponent); override;
    property Canvas;
    property Data: TObject read FData write FData;
    property Index: Integer read GetIndex;
    property PageControl: TNxCustomNotebook read FPageControl write SetPageControl;
  published
    property ActiveTabColor: TColor read FActiveTabColor write SetActiveTabColor default clWindow;
    property Caption: WideString read FCaption write SetCaption;
    property Color default clBtnFace;
    property DisplayMode: TTabDisplayMode read FDisplayMode write SetDisplayMode default tdGlyph;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property Height stored False;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Left stored False;
    property Margin: Integer read FMargin write SetMargin default 0;
    property PageIndex: Integer read GetPageIndex write SetPageIndex;
    property PageStyle: TNxPanelStyle read FPageStyle write SetPageStyle default ptDefault;
    property PageVisible: Boolean read FPageVisible write SetPageVisible default True;
    property ParentColor default True;
    property ParentFont;
    property ParentTabFont: Boolean read FParentTabFont write SetParentTabFont default True;
    property TabColor: TColor read FTabColor write SetTabColor default clWindow;
    property TabFont: TFont read FTabFont write SetTabFont;
    property TabVisible: Boolean read FTabVisible write SetTabVisible default True;
    property TabWidth: Integer read FTabWidth write SetTabWidth default 0;
    property Top stored False;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor default clNone;
    property Width stored False;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  end;

  TNxGlyphPageControl = class(TNxCustomNotebook)
  private
    FTopIndent: Integer;
    FTabHeight: Integer;
    FGlyphNormal: TNxTabGlyph;
    FTabPadding: Integer;
    FTabSpacing: Integer;
    FGlyphActive: TNxTabGlyph;
    FFontActive: TFont;
    FBackgroundKind: TBackgroundKind;
    FBackgroundColorFrom: TColor;
    FBackgroundColorTo: TColor;
    FFontNormal: TFont;
    FAlignment: TAlignment;
    function GetTabStart: Integer;
    procedure SetTabHeight(const Value: Integer);
    procedure SetTopIndent(const Value: Integer);
    procedure SetGlyphNormal(const Value: TNxTabGlyph);
    procedure SetTabPadding(const Value: Integer);
    procedure SetTabSpacing(const Value: Integer);
    procedure SetGlyphActive(const Value: TNxTabGlyph);
    procedure SetFontActive(const Value: TFont);
    procedure SetBackgroundColorFrom(const Value: TColor);
    procedure SetBackgroundColorTo(const Value: TColor);
    procedure SetBackgroundKind(const Value: TBackgroundKind);
    procedure SetFontNormal(const Value: TFont);
    procedure SetAlignment(const Value: TAlignment);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure DrawTab(const Index: Integer);
    procedure DrawTabsBackground;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTabAtPos(const X, Y: Integer): TNxTabSheet;
    function GetTabRect(const Index: Integer): TRect;
    function GetTabsWidth: Integer;
    function GetTabWidth(const Index: Integer): Integer;
    procedure RefreshPage(const Index: Integer); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property BackgroundColorFrom: TColor read FBackgroundColorFrom write SetBackgroundColorFrom default clGray;
    property BackgroundColorTo: TColor read FBackgroundColorTo write SetBackgroundColorTo default clGray;
    property BackgroundKind: TBackgroundKind read FBackgroundKind write SetBackgroundKind default bkSolid;
    property FontActive: TFont read FFontActive write SetFontActive;
    property FontNormal: TFont read FFontNormal write SetFontNormal;
    property Font;
    property GlyphActive: TNxTabGlyph read FGlyphActive write SetGlyphActive;
    property GlyphNormal: TNxTabGlyph read FGlyphNormal write SetGlyphNormal;
    property TabHeight: Integer read FTabHeight write SetTabHeight default 21;
    property TabPadding: Integer read FTabPadding write SetTabPadding default 16;
    property TabSpacing: Integer read FTabSpacing write SetTabSpacing default 2;
    property TopIndent: Integer read FTopIndent write SetTopIndent default 10;
  end;

implementation

uses
  NxSharedDraw, Math, Forms, NxThemesSupport;

var
  PageClassRegistered: Boolean = False;

procedure ClipPoly(Canvas: TCanvas; Points: array of TPoint);
var
  CLPRGN: HRGN;
begin
  CLPRGN := CreatePolygonRgn(Points, Length(Points), WINDING);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

{ TNxCustomNotebook }

constructor TNxCustomNotebook.Create(AOwner: TComponent);
begin
  inherited;
  if not PageClassRegistered then
  begin
    RegisterClass(TNxTabSheet);
    PageClassRegistered := True;
  end;
  ControlStyle := [csAcceptsControls, csClickEvents,
    csSetCaption, csDoubleClicks, csReplicatable];
  FPageList := TList.Create;
  Height := 250;
  Width := 300;
end;

destructor TNxCustomNotebook.Destroy;
var
  i: Integer;
begin
  for i := Pred(FPageList.Count) downto 0 do DeletePage(Pages[i]);
  FreeAndNil(FPageList);
  inherited;
end;

procedure TNxCustomNotebook.ActivePageChanged;
begin

end;

procedure TNxCustomNotebook.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
		with WindowClass do
      Style := Style and not(CS_VREDRAW);
end;

function TNxCustomNotebook.GetPageCount: Integer;
begin
  Result := FPageList.Count;
end;

procedure TNxCustomNotebook.SetActivePage(const Value: TNxTabSheet);
var
  AOldIndex, ANewIndex: Integer;
  AllowChange: Boolean;
begin
  if csDestroying in ComponentState then Exit;

  if Assigned(Value) then
  begin
    if Value.PageControl <> Self then Exit;
    ANewIndex := Value.PageIndex;
  end else ANewIndex := -1;

  { prevent change inside event }
  AllowChange := True;
  if not(csLoading in ComponentState)
    then DoChanging(ANewIndex, AllowChange); { event }
  if not AllowChange then Exit;

  { old page }
  if Assigned(FActivePage) then
  begin
    FActivePage.Hide; { page is not hidden in design-time }
    FActivePage.DoHide; { event }
    AOldIndex := FActivePage.PageIndex;
  end else AOldIndex := -1;

  { new page }
  if Assigned(Value) then
  begin
    FActivePage := Value;
    if FActivePage.PageVisible then
    begin
      FActivePage.Show;
      FActivePage.DoShow; { event }
      try
        FActivePage.FUpdating := True;
        FActivePage.BringToFront;
      finally
        FActivePage.FUpdating := False;
      end;
    end;
    FActivePageIndex := FPageList.IndexOf(Value);
    if InRange(ANewIndex, 0, Pred(FPageList.Count)) then
    begin
      ActivePageChanged;
      RefreshPage(FActivePage.PageIndex);
    end;
  end else
  begin
    FActivePage := nil;
  end;
  if AOldIndex >= 0 then RefreshPage(AOldIndex);
  if not(csLoading in ComponentState) then DoChange; { event }
end;

procedure TNxCustomNotebook.SetActivePageIndex(const Value: Integer);
begin
  if InRange(Value, 0, PageCount - 1) then
  begin
    if PageCount > 0
      then ActivePage := TNxTabSheet(FPageList[Value])
      else ActivePage := nil;
  end;
end;

procedure TNxCustomNotebook.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
	{ this will save pages as childrens into dfm }
  for i := 0 to FPageList.Count - 1 do Proc(TNxTabSheet(FPageList[i]));
end;

procedure TNxCustomNotebook.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxCustomNotebook.DoChanging(PageIndex: Integer;
  var AllowChange: Boolean);
begin
  if Assigned(FOnChanging) then FOnChanging(Self, PageIndex, AllowChange);
end;

procedure TNxCustomNotebook.DoPageClose(PageIndex: Integer; var Accept: Boolean);
begin
  if Assigned(FOnPageClose) then FOnPageClose(Self, PageIndex, Accept);
end;

function TNxCustomNotebook.GetInnerHeight: Integer;
begin
  Result := ClientHeight;
end;

procedure TNxCustomNotebook.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent is TNxTabSheet) then
  begin
    if FPageList.IndexOf(AComponent) <> -1
      then FPageList.Delete(FPageList.IndexOf(AComponent));
    if FPageList.Count > 0 then
    begin
      if ActivePage = TNxTabSheet(AComponent) then ActivePageIndex := 0;
    end else ActivePage := nil;
    Invalidate;
  end;
end;

procedure TNxCustomNotebook.ValidateInsert(AComponent: TComponent);
begin
  if not(AComponent is TNxTabSheet) then
    raise EInvalidOperation.CreateFmt('Cannot insert %s into ' + ClassName, [AComponent.ClassName]);
end;

procedure TNxCustomNotebook.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxCustomNotebook.AddPage(Page: TNxTabSheet; Insert: Boolean = True);
begin
  FPageList.Add(Page);
  if Insert then Page.Parent := Self;
  Page.FPageControl := Self;
  Page.FreeNotification(Self);
  if Page.Caption = '' then Page.Caption := Page.Name;
  if Page.ParentTabFont then Page.TabFont.Assign(Font);
  Invalidate;
end;

procedure TNxCustomNotebook.DeletePage(TabSheet: TNxTabSheet);
begin
  if Assigned(TabSheet) then FreeAndNil(TabSheet);
end;

procedure TNxCustomNotebook.InsertPage(const Index: Integer; TabSheet: TNxTabSheet);
begin
  FPageList.Insert(Index, TabSheet);
  TabSheet.Parent := Self;
  TabSheet.FPageControl := Self;
  TabSheet.FreeNotification(Self);
  ActivePage := TabSheet;
  Invalidate;
end;

procedure TNxCustomNotebook.RefreshPage(const Index: Integer);
begin

end;

procedure TNxCustomNotebook.RemovePage(Page: TNxTabSheet);
begin
  FPageList.Delete(FPageList.IndexOf(Page));
  if FActivePageIndex >= PageCount then ActivePageIndex := ActivePageIndex - 1;
end;

function TNxCustomNotebook.GetPageIndex(Page: TNxTabSheet): Integer;
begin
  Result := FPageList.IndexOf(Page);
end;

procedure TNxCustomNotebook.SetPageIndex(Page: TNxTabSheet; Index: Integer);
begin
  FPageList.Move(Page.PageIndex, Index);
end;

function TNxCustomNotebook.GetPages(Index: Integer): TNxTabSheet;
begin
  Result := TNxTabSheet(FPageList[Index]);
end;

procedure TNxCustomNotebook.SetPages(Index: Integer; const Value: TNxTabSheet);
begin

end;

procedure TNxCustomNotebook.Paint;
begin
  inherited;
  if GetPageCount = 0 then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ClientRect);
  end;
end;

procedure TNxCustomNotebook.SelectNextPage;
var
  I: Integer;
begin
  for I := FActivePageIndex to Pred(PageCount) do
    if Pages[I].PageVisible and Pages[I].TabVisible and (I <> FActivePageIndex) then
    begin
      ActivePageIndex := I;
      Exit;
    end;
end;

procedure TNxCustomNotebook.SelectPrevPage;
var
  i: Integer;
begin
  for i := FActivePageIndex downto 0 do
    if Pages[i].PageVisible and Pages[i].TabVisible and (i <> FActivePageIndex) then
    begin
      ActivePageIndex := i;
      Exit;
    end;
end;

procedure TNxCustomNotebook.MovePage(FromPos, ToPos: Integer);
begin
  FPageList.Move(FromPos, ToPos);
  Invalidate;
end;

{ TNxTabSheet }

constructor TNxTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csDoubleClicks, csReplicatable];
  FActiveTabColor := clWindow;
  FDisplayMode := tdGlyph;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FImageIndex := -1;
  FMargin := 0;
  FParentTabFont := True;
  FTransparentColor := clNone;
  FTabColor := clWindow;
  FTabFont := TFont.Create;
  FTabFont.OnChange := DoTabFontChange;
  FTabFontUpdating := False;
  FTabVisible := True;
  FTabWidth := 0;
  FPageStyle := ptDefault;
  FPageVisible := True;
  FUpdating := True;
  ParentColor := True;
end;

destructor TNxTabSheet.Destroy;
begin
  FreeAndNil(FGlyph);
  FreeAndNil(FTabFont);
  FPageControl.RemovePage(Self);
  inherited;
end;

procedure TNxTabSheet.CreateWnd;
begin
  inherited;
  Align := alClient;
end;

procedure TNxTabSheet.AssignFont(Source: TFont);
begin
  FTabFontUpdating := True;
  FTabFont.Assign(Font);
  FTabFontUpdating := False;
end;

procedure TNxTabSheet.Changed;
begin
  if Assigned(FPageControl) then
    FPageControl.Invalidate;
end;

procedure TNxTabSheet.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  InflateRect(Rect, -Margin, -Margin);
end;

procedure TNxTabSheet.DoTabFontChange(Sender: TObject);
begin
  if FTabFontUpdating then Exit;
  FParentTabFont := False;
  Changed;
end;

procedure TNxTabSheet.DoGlyphChange(Sender: TObject);
begin
  SetTransparentColor(TransparentColor);
  Changed;
end;

procedure TNxTabSheet.DoHide;
begin
  if Assigned(FOnHide) then FOnHide(Self);
end;

procedure TNxTabSheet.DoPaint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

procedure TNxTabSheet.DoShow;
begin
  if Assigned(FOnShow) then FOnShow(Self);
end;

function TNxTabSheet.GetPageIndex: Integer;
begin
  if Assigned(FPageControl) then Result := FPageControl.GetPageIndex(Self)
    else Result := -1;
end;

procedure TNxTabSheet.Paint;
var
  r: TRect;
  SecondColor: TColor;
begin
  inherited;
  with Canvas do
  begin
    case FPageStyle of
      ptDefault:
      begin
        Brush.Color := Self.Color;
        FillRect(ClientRect);
      end;
      ptGradient:
      begin
        SecondColor := SchemeColor(seBtnFace);
        DrawVertGradient(Canvas, ClientRect, Color, SecondColor);
      end;
      ptInverseGradient:
      begin
        SecondColor := SchemeColor(seBtnFace);
        DrawVertGradient(Canvas, ClientRect, SecondColor, Color);
      end;
    end;

    if (csDesigning in ComponentState) then
    begin
      if Margin > 0 then
      begin
        Pen.Color := clGrayText;
        Pen.Style := psDot;
        Brush.Style := bsClear;
        r := ClientRect;
        InflateRect(r, -Margin + 1, -Margin + 1);
        Rectangle(r);
        Pen.Style := psSolid;
        Brush.Style := Graphics.bsSolid;
      end;
    end;
  end;
  DoPaint;
end;

procedure TNxTabSheet.RefreshTab;
begin
  if FPageControl <> nil then FPageControl.RefreshPage(PageIndex);
end;

procedure TNxTabSheet.SetParentComponent(Value: TComponent);
begin
  inherited;
  if Value is TNxCustomNotebook then
  begin
    FPageControl := TNxCustomNotebook(Value);
    if Self <> FPageControl.ActivePage then Hide;
    FPageControl.FPageList.Add(Self); { Add page into pages array }
    FreeNotification(FPageControl);
    { TODO 3 -oBoki -cTesting : Hidden page need to be forced to re-size }
    SetBounds(0, 0, FPageControl.Width, FPageControl.GetInnerHeight);
  end;
end;

procedure TNxTabSheet.SetZOrder(TopMost: Boolean);
var
  i: Integer;
begin
  inherited;
  if FUpdating then Exit;
  if FPageControl <> nil then
  begin
    if TopMost then FPageControl.ActivePageIndex := PageIndex else
      if FPageControl.ActivePageIndex = PageIndex then
      begin
        for i := FPageControl.ControlCount - 1 downto 0 do
        begin
          if FPageControl.Controls[i] is TNxTabSheet then FPageControl.ActivePage := FPageControl.Controls[i] as TNxTabSheet;
          Exit;
        end;
      end;
  end;
end;

procedure TNxTabSheet.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Changed;
end;

procedure TNxTabSheet.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Refresh;
  Realign;
end;

procedure TNxTabSheet.SetTabColor(const Value: TColor);
begin
  FTabColor := Value;
  RefreshTab;
end;

procedure TNxTabSheet.SetTabFont(const Value: TFont);
begin
  FTabFont.Assign(Value);
  Changed;
end;

procedure TNxTabSheet.SetPageControl(const Value: TNxCustomNotebook);
begin
  if Value = FPageControl then Exit;
  { remove from old PageControl }
  if Assigned(FPageControl) then FPageControl.RemovePage(Self);
  FPageControl := Value;
  { add to new PageControl (if exist) }
  if FPageControl <> nil then FPageControl.AddPage(Self);
end;

procedure TNxTabSheet.SetPageIndex(const Value: Integer);
begin
  if Assigned(FPageControl) then
  begin
    FPageControl.SetPageIndex(Self, Value);
    FPageControl.Invalidate;
  end;
end;

procedure TNxTabSheet.SetTabWidth(const Value: Integer);
begin
  FTabWidth := Value;
  if Assigned(FPageControl) then FPageControl.Invalidate;  
end;

procedure TNxTabSheet.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxTabSheet.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
  begin
    if IsAccel(CharCode, Caption) then
    begin
      PageControl.ActivePage := Self;
      Result := 1;
    end else inherited;
  end;
end;

procedure TNxTabSheet.CMTextChanged(var Message: TMessage);
begin
  if Assigned(FPageControl) then FPageControl.Invalidate;
end;

procedure TNxTabSheet.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  if FTransparentColor <> clNone then
  begin
    FGlyph.TransparentColor := FTransparentColor;
    FGlyph.Transparent := True;
  end;
end;

procedure TNxTabSheet.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  RefreshTab;
end;

procedure TNxTabSheet.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Changed;
end;

procedure TNxTabSheet.SetDisplayMode(const Value: TTabDisplayMode);
begin
  FDisplayMode := Value;
  Changed;
end;

procedure TNxTabSheet.SetPageVisible(const Value: Boolean);
begin
  FPageVisible := Value;
  if FPageControl <> nil then
  begin
    Visible := Value and (FPageControl.ActivePage = Self);
    FPageControl.Invalidate;
  end else Visible := False;
end;

procedure TNxTabSheet.SetParentTabFont(const Value: Boolean);
begin
  if FParentTabFont <> Value then
  begin
    FParentTabFont := Value;
    FTabFontUpdating := True;
    if FParentTabFont then FTabFont.Assign(FPageControl.Font);
    FTabFontUpdating := False;
    Changed;
  end;
end;

procedure TNxTabSheet.SetTabVisible(const Value: Boolean);
begin
  FTabVisible := Value;
  Changed;
end;

function TNxTabSheet.GetIndex: Integer;
begin
  Result := FPageControl.FPageList.IndexOf(Self);
end;

procedure TNxTabSheet.SetActiveTabColor(const Value: TColor);
begin
  if FActiveTabColor <> Value then
  begin
    FActiveTabColor := Value;
    if Assigned(FPageControl) and (FPageControl.ActivePage = Self)
      then RefreshTab;
  end;
end;

procedure TNxTabSheet.SetPageStyle(const Value: TNxPanelStyle);
begin
  FPageStyle := Value;
  Invalidate;
end;

{ TNxPageControl }

constructor TNxPageControl.Create(AOwner: TComponent);
begin
  inherited;
  FAdaptiveColors := True;
  FBackgroundColor := clSilver;
  FBackgroundKind := bkSolid;
  FCloseBtnBitmap := TBitmap.Create;
  FCloseBtnBitmap.LoadFromResourceName(HInstance, 'CLOSEBTN');
  FCloseBtnBitmap.TransparentColor := clWhite;
  FCloseBtnBitmap.Transparent := True;
  FDownButton := pbNone;
  FDownTab := nil;
  FDownPageIndex := -1;
  FHoverButton := pbNone;
  FHoverPageIndex := -1;
  FIndent := 2;
  FMargin := 0;
  FOldHeight := 0;
  FOldWidth := 0;
  FOptions := [pgBoldActiveTab, pgCloseButton, pgScrollButtons, pgTopBorder];
  FPartialTabs := False;
  FScrollMethod := smPixels;
  FScrollPos := 0;
  FScrollTimer := TTimer.Create(nil);
  FScrollTimer.Enabled := False;
  FScrollTimer.Interval := intScrollTimer;
  FScrollTimer.OnTimer := DoScrollTimer;
  FSpacing := 0;
  FShowTabs := True;
  FTabsPopup := TPopupMenu.Create(nil);
  FTabAlignment := taCenter;
  FTabMargin := 0;
  FTabHeight := 17;
  FTabMoving := False;
  FTabMaxWidth := 0;
  FTabPosition := tpTop;
  FTabStyle := tsWhidbey;
  FTopIndent := 3;
end;

destructor TNxPageControl.Destroy;
begin
  FreeAndNil(FCloseBtnBitmap);
  FreeAndNil(FScrollTimer);
  FreeAndNil(FTabsPopup);
  inherited;
end;

procedure TNxPageControl.ActivePageChanged;
begin
  if InRange(FActivePageIndex, 0, Pred(PageCount))
    and IsTabVisible(Pages[FActivePageIndex]) then ScrollToTab(FActivePageIndex);
end;

function TNxPageControl.GetButtonRect(Kind: TPageButton): TRect;
var
  Start, Y: Integer;
begin
  Y := 0;
  Start := ClientWidth - 4;
  with Result do
  begin
    if pgCloseButton in Options then Dec(Start, 16);
    if Kind <> pbClose then
    begin
      if pgTabsPopup in Options then Dec(Start, 16);
      case Kind of
        pbScrollLeft: Dec(Start, 32);
        pbScrollRight: Dec(Start, 16);
      end;
    end;
    Left := Start;
    Right := Start + 16;
    case FTabPosition of
      tpTop: Y := FTopIndent;
      tpBottom: Y := ClientHeight - FTabHeight - FTopIndent + 1;
    end;
    Top := Y + TabHeight div 2 - 16 div 2;
    Bottom := Result.Top + 16;
  end;
end;

function TNxPageControl.GetFirstVisible: Integer;
var
  i: Integer;
  TabRect: TRect;
begin
  Result := 0;
  for i := 0 to PageCount - 1 do
  begin
    TabRect := GetTabRect(i);
    if TabRect.Right > GetTabsClientRect.Left then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TNxPageControl.GetInnerHeight: Integer;
begin
  Result := ClientHeight - TabHeight - TopIndent;
  if pgTopBorder in Options then Dec(Result);
end;

function TNxPageControl.GetTabsClientRect: TRect;
begin
  with Result do
  begin
    Left := FIndent;
    Right := GetTabsEdge;
    case FTabPosition of
      tpTop:
      begin
        Top := FTopIndent;
        Bottom := Top + FTabHeight;
      end;
      tpBottom:
      begin
        Bottom := ClientHeight - FTopIndent;
        if pgTopBorder in FOptions then Dec(Bottom);
        Top := Bottom - FTabHeight;
      end;
    end;
  end;
end;

function TNxPageControl.GetScrollMax: Integer;
var
  Total: Integer;
begin
  case FScrollMethod of
    smPixels:
    begin
      Total := GetTabsTotalWidth;
      if Total > GetTabsEdge - Indent then Result := Total - (GetTabsEdge - Indent)
        else Result := 0;
    end else
      Result := GetTabsTotalWidth;
  end;
end;

function TNxPageControl.GetTabsEdge: Integer;
begin
  Result := ClientWidth - sizRightMargin;
  if pgCloseButton in Options then Dec(Result, 16);
  if pgTabsPopup in Options then Dec(Result, 16);
  if pgScrollButtons in Options then Dec(Result, 32);
end;

function TNxPageControl.GetTabsRect: TRect;
begin
  case FTabPosition of
    tpTop: Result := Rect(0, 0, ClientWidth, FTabHeight + FTopIndent);
    tpBottom: Result := Rect(0, ClientHeight - (FTabHeight + FTopIndent) - 1, ClientWidth, ClientHeight);
  end;
end;

function TNxPageControl.GetTabsRight: Integer;
var
  I, TabWidth: Integer;
begin
  Result := FIndent;
  if FPageList.Count = 0 then Exit;
  for I := 0 to Pred(FPageList.Count) do
  begin
    if Pages[I].PageVisible and Pages[I].TabVisible then
    begin
      TabWidth := GetTabWidth(Pages[I]);
      if Result + TabWidth > GetTabsEdge then Break;
      if I <> FActivePageIndex then Inc(Result, GetTabWidth(Pages[I]) - GetTabsSpacing)
        else Inc(Result, GetTabWidth(Pages[I]));
    end;
  end;
end;

function TNxPageControl.GetTabsSpacing: Integer;
begin
  Result := 0;
  case FTabStyle of
    tsClassic: Result := 0;
    tsFlat: Result := FTabHeight div 2;
    tsOneNote: Result := FTabHeight - 3;
    tsWhidbey: Result := FTabHeight - 7;
    tsDexter: Result := FTabHeight - 6; //mb+
  end;
end;

function TNxPageControl.GetTabsTotalWidth: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FPageList.Count - 1 do
    if Pages[i].PageVisible and Pages[i].TabVisible then Inc(Result, GetTabClientWidth(Pages[i]));
  if FPageList.Count > 0 then Inc(Result, GetTabsSpacing); { one tab allways have full width }
end;

procedure TNxPageControl.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if ShowTabs then
    case FTabPosition of
      tpTop: Inc(Rect.Top, FTabHeight + FTopIndent + 1);
      tpBottom: Dec(Rect.Bottom, FTabHeight + FTopIndent + 1); 
    end;
  Inc(Rect.Top, FMargin);
  Inc(Rect.Left, FMargin);
  Dec(Rect.Right, FMargin);
  Dec(Rect.Bottom, FMargin);
  if pgPageBorder in Options then
  begin
    Dec(Rect.Bottom);
    Dec(Rect.Right);
    Inc(Rect.Left);
    if not ShowTabs then Inc(Rect.Top);
  end;
end;

procedure TNxPageControl.DrawButton(ARect: TRect; Kind: TPageButton);
  procedure DrawButtonFrame(R: TRect);
  begin
    with Canvas do
    begin
      case FTabStyle of
        tsClassic:
          if FHoverButton = Kind then
          begin
            if FDownButton = Kind then Frame3D(Canvas, R, clBlack, clBtnFace, 1)
            else Frame3D(Canvas, R, clBtnFace, clBlack, 1);
          end;
        tsFlat, tsWhidbey, tsOneNote:
          if FHoverButton = Kind then
          begin
            Pen.Color := clHighlight;
            Brush.Color := BlendColor(clHighlight, clWindow, 80);
            Rectangle(R);
          end;
        tsDexter: //mb+
          if FHoverButton = Kind then
          begin
            Pen.Color := clBtnShadow;
            Brush.Color := clWindow;
            RoundRect(R.Left, R.Top, R.Right - 1, R.Bottom - 1, 6, 6);
          end;
      end;
    end;
  end;

begin
  DrawButtonFrame(ARect);
  case Kind of
    pbPopup:
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := clBlack;
      Canvas.Polygon([Point(ARect.Left + 4, ARect.Top + 7),
        Point(ARect.Left + 11, ARect.Top + 7),
        Point(ARect.Left + 8, ARect.Top + 10),
        Point(ARect.Left + 7, ARect.Top + 10),
        Point(ARect.Left + 4, ARect.Top + 7)]);
    end;
    pbClose:
    begin
      Canvas.Draw(ARect.Left + (ARect.Right - ARect.Left) div 2 - (FCloseBtnBitmap.Width div 2),
        ARect.Top + (ARect.Bottom - ARect.Top) div 2 - (FCloseBtnBitmap.Height div 2), FCloseBtnBitmap);
    end;
    pbScrollRight:
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := clBlack;
      if IsEndPos then
      Canvas.Polyline([Point(ARect.Left + 5, ARect.Top + 3),
        Point(ARect.Left + 5 + 4, ARect.Top + 5 + 2),
        Point(ARect.Left + 5, ARect.Top + 10 + 1),
        Point(ARect.Left + 5, ARect.Top + 3)])
        else
      Canvas.Polygon([Point(ARect.Left + 5, ARect.Top + 3),
        Point(ARect.Left + 5 + 4, ARect.Top + 5 + 2),
        Point(ARect.Left + 5, ARect.Top + 10 + 1),
        Point(ARect.Left + 5, ARect.Top + 3)]);
    end;
    pbScrollLeft:
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := clBlack;
      if IsStartPos then
      Canvas.Polyline([Point(ARect.Right - 7, ARect.Top + 3),
        Point(ARect.Right - 5 - 6, ARect.Top + 5 + 2),
        Point(ARect.Right - 7, ARect.Top + 10 + 1),
        Point(ARect.Right - 7, ARect.Top + 3)])
      else
      Canvas.Polygon([Point(ARect.Right - 7, ARect.Top + 3),
        Point(ARect.Right - 5 - 6, ARect.Top + 5 + 2),
        Point(ARect.Right - 7, ARect.Top + 10 + 1),
        Point(ARect.Right - 7, ARect.Top + 3)])
    end;
  end;
end;

procedure TNxPageControl.DrawClassicTab(r: TRect; Caption: string;
  TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
begin
  with Canvas do
  begin
    if Active then
    begin
      if AdaptiveColors then Canvas.Brush.Color := clBtnFace
        else Canvas.Brush.Color := TabColor;
      FillRect(r);
      Pen.Color := clWhite;
      DrawPolyline([
        Point(r.Left, r.Top),
        Point(r.Left, r.Bottom)
        ], r);
      Pen.Color := clBlack;
      DrawPolyline([
        Point(r.Right - 1, r.Top),
        Point(r.Right - 1, r.Bottom + 1)
        ], r);
    end else
      if not First then
      begin
  {      Canvas.Pen.Color := clGrayText;
        Canvas.MoveTo(r.Left, 2);
        Canvas.LineTo(r.Left, r.Bottom - 2);}
      end;
  end;
end;

procedure TNxPageControl.DrawFlatTab(r: TRect; Caption: string;
  TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
var
  Distance: Integer;
begin
  if Odd(FTabHeight)
    then Distance := FTabHeight div 2
    else Distance := FTabHeight div 2;
  with Canvas do
  begin
    Pen.Color := GetColor(ceWhidbeyTabBorder);
    if AdaptiveColors then
    begin
      if Active then Brush.Color := clWindow else Brush.Color := BlendColor(clInactiveCaption, clWindow, 80);
    end else Brush.Color := TabColor;

    DrawPolyline([Point(r.Left, r.Bottom),
      Point(r.Left + Distance, r.Top),
      Point(r.Right - Distance, r.Top),
      Point(r.Right, r.Bottom)], r);
    Pen.Color := Brush.Color;
    DrawPolygon([Point(r.Left + 1, r.Bottom),
      Point(r.Left + Distance, r.Top + 1),
      Point(r.Right - Distance - 1, r.Top + 1),
      Point(r.Right - 1, r.Bottom)], r);
  end;                                  
end;

procedure TNxPageControl.DrawOutlook2007Tab(r: TRect; Caption: string;
  TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
begin
end;

procedure TNxPageControl.DrawOneNoteTab(r: TRect; Caption: string;
  TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
begin
  with Canvas do
  begin
    Pen.Color := GetSysColor(COLOR_HOTLIGHT);

    { Border }
    if First or Active then
    begin
      DrawPolyline([
        Point(r.Left, r.Bottom - 1),
        Point(r.Left + 1, r.Bottom - 1),
        Point(r.Left + FTabHeight - 2, r.Top + 2),
        Point(r.Left + FTabHeight + 1, r.Top + 1),
        Point(r.Left + FTabHeight + 3, r.Top),
        Point(r.Right - 3, r.Top),
        Point(r.Right - 1, r.Top + 2),
        Point(r.Right - 1, r.Top + 4),
        Point(r.Right - 1, r.Bottom)
        ], r);
    end else
    begin
      DrawPolyline([
        Point(r.Left + FTabHeight - 3, r.Top + 3),
        Point(r.Left + FTabHeight - 0, r.Top + 1),
        Point(r.Left + FTabHeight + 4, r.Top),
        Point(r.Right - 3, r.Top),
        Point(r.Right - 1, r.Top + 2),
        Point(r.Right - 1, r.Top + 4),
        Point(r.Right - 1, r.Bottom)
        ], r);
    end;

    if First or Active then
    begin
      SetClipPolygon([
        Point(r.Left + 1, r.Bottom),
        Point(r.Left + FTabHeight - 2, r.Top + 3),
        Point(r.Left + FTabHeight, r.Top + 2),
        Point(r.Left + FTabHeight + 3, r.Top),
        Point(r.Right - 2, r.Top + 1),
        Point(r.Right - 1, r.Top + 2),
        Point(r.Right - 1, r.Top + 5),
        Point(r.Right - 1, r.Bottom)
        ], r);
    end else
    begin
      SetClipPolygon([
        Point(r.Left + FTabHeight - 3, r.Bottom - 1),
        Point(r.Left + FTabHeight - 3, r.Top + 4),
        Point(r.Left + FTabHeight - 2, r.Top + 3),
        Point(r.Left + FTabHeight, r.Top + 2),
        Point(r.Left + FTabHeight + 3, r.Top),
        Point(r.Right - 2, r.Top + 1),
        Point(r.Right - 1, r.Top + 2),
        Point(r.Right - 1, r.Top + 5),
        Point(r.Right - 1, r.Bottom)
        ], r);
    end;

    if PartialTabs then
    begin
      if r.Left + FTabHeight + 2 > r.Right then Exit;
    end;

    with TGraphicsProvider do
    begin
      if TabColor <> clWindow then DrawGradient(Canvas, r, clWindow, TabColor) else
      begin
        Brush.Color := TabColor;
        FillRect(r);
      end;
      Pen.Color := clWindow;
      DrawPolyline([
        Point(r.Left + 1, r.Bottom),
        Point(r.Left + FTabHeight - 2, r.Top + 3),
        Point(r.Left + FTabHeight + 1, r.Top + 2),
        Point(r.Left + FTabHeight + 2, r.Top + 1),
        Point(r.Right - 2, r.Top + 1)
      ], r);
      if Active then Pen.Color := clWindow
        else Pen.Color := RGB(177, 166, 241);
      DrawPolyline([
        Point(r.Right - 3, r.Top + 1),
        Point(r.Right - 2, r.Top + 2),
        Point(r.Right - 2, r.Bottom)
      ], r);
    end;

  end;
end;

procedure TNxPageControl.DrawPageBorder(ARect: TRect);
begin
  with Canvas do
  begin
    if ShowTabs then
    begin
      Pen.Color := clGrayText;
      case FTabPosition of
        tpBottom:
          Polyline([
            Point(0, ClientHeight - FTopIndent + FTabHeight),
            Point(0, 0),
            Point(ClientWidth - 1, 0),
            Point(ClientWidth - 1, ClientHeight - FTopIndent + FTabHeight)
          ]);
        tpTop:
          Polyline([
            Point(0, FTopIndent + FTabHeight),
            Point(0, ClientHeight - 1),
            Point(ClientWidth - 1, ClientHeight - 1),
            Point(ClientWidth - 1, FTopIndent + FTabHeight)
          ]);
      end;
    end else
    begin
      Brush.Color := clGrayText;
      FrameRect(ARect);
    end;
  end;
end;

procedure TNxPageControl.DrawPolygon(Points: array of TPoint; Rect: TRect);
var
  FlipVert: Boolean;
begin
  FlipVert := False;
  case FTabPosition of
    tpTop:    FlipVert := False;
    tpBottom: FlipVert := True;
  end;
  if FlipVert then FlipPointsVert(Points, Rect);
  Canvas.Polygon(Points);
end;

procedure TNxPageControl.DrawPolyline(Points: array of TPoint;
  Rect: TRect);
var
  FlipVert: Boolean;
begin
  FlipVert := False;
  case FTabPosition of
    tpTop: FlipVert := False;
    tpBottom: FlipVert := True;
  end;
  if FlipVert then FlipPointsVert(Points, Rect);
  Canvas.Polyline(Points);
end;

procedure TNxPageControl.DrawTab(r: TRect; Page: TNxTabSheet; Active,
  First: Boolean);
var
  r1: TRect;
  ImgLeft, ImgTop, ImageWidth, ImageHeight, DrawIndent: Integer;
  TabColor: TColor;
begin
  SetClipRect(Canvas, R);
  case FTabStyle of
    tsClassic:  DrawClassicTab(r, Caption, Page.TabColor, Page.Glyph, Active, First);
    tsFlat:     DrawFlatTab(r, Caption, Page.TabColor, Page.Glyph, Active, First);
    tsOneNote:  DrawOneNoteTab(r, Caption, Page.TabColor, Page.Glyph, Active, First);
    tsWhidbey:
    begin
      if Page = ActivePage
        then TabColor := Page.ActiveTabColor
        else TabColor := Page.TabColor;
      DrawWhidbeyTab(r, Caption, TabColor, Page.Glyph, Active, First);
    end;
    tsDexter:  DrawDexterTab(r, Caption, Page.TabColor, Page.Glyph, Active, First); //mb+
  end;

  { Draw content }
  with Canvas do
  begin
    Font.Assign(Page.TabFont);
    r1 := r;
    case FTabStyle of
      tsClassic:
        begin
          DrawIndent := 6;
          if not Active then Font.Color := clGrayText;
        end;
      tsWhidbey, tsOneNote: DrawIndent := FTabHeight - 6;
      tsDexter: DrawIndent := -FTabHeight div 2; //mb+
      else DrawIndent := 0;
    end;
    Inc(r1.Left, DrawIndent);

    { Determine Image size }

    ImageWidth := 0;
    ImageHeight := 0;
    
    case Page.DisplayMode of
      tdGlyph:
        if not Page.Glyph.Empty then
        begin
          ImageHeight := Page.Glyph.Height;
          ImageWidth := Page.Glyph.Width;
        end;
      tdImageIndex:
        if Assigned(Images) and InRange(Page.ImageIndex, 0 , Images.Count - 1) then
        begin
          ImageHeight := Images.Height;
          ImageWidth := Images.Width;
        end;
    end;

    ImgTop := r.Top + FTabHeight div 2 - ImageHeight div 2;
    Inc(ImgTop); { Top Border - 1px }

    case TabAlignment of
      taLeftJustify:
      begin
        Inc(r1.Left, 2);
      end;
      taRightJustify: Dec(r1.Right, 2);
    end;

    ImgLeft := 0;
    if ImageWidth > 0 then
      case FTabAlignment of
        taCenter:
        begin
          ImgLeft := r1.Left + 4;
          Inc(r1.Left, ImageWidth);
        end;
        taLeftJustify:
        begin
          ImgLeft := r1.Left + 4;
          r1.Left := ImgLeft + ImageWidth + 2;
        end;
        taRightJustify:
        begin
          ImgLeft := r1.Right - ImageWidth - 2;
          r1.Right := ImgLeft - 2;
        end;
      end;

    { Draw Image }
    if not(Page = ActivePage) then Inc(ImgLeft, 4);
    case Page.DisplayMode of
      tdGlyph:
        if not Page.Glyph.Empty then
          TDrawProvider.ApplyBitmap(Canvas, ImgLeft, ImgTop, Page.Glyph);
      tdImageIndex:
        if Assigned(Images) and InRange(Page.ImageIndex, 0 , Images.Count - 1) then
          Images.Draw(Canvas, ImgLeft, ImgTop, Page.ImageIndex);
    end;

    if Active and (pgBoldActiveTab in Options) then Canvas.Font.Style := [fsBold];
    DrawText(Canvas, r1, FTabAlignment, Page.Caption, False);
  end;
end;

procedure TNxPageControl.DrawTabsBackground;
var
  TabsRect: TRect;
  Shift, Pt: TPoint;
  DC: HDC;
begin
  with Canvas do
  begin
    TabsRect := GetTabsRect;
    case FBackgroundKind of
      bkCustom:
      begin
        DoCustomDrawBackground(TabsRect);
      end;
      bkTransparent:
      begin
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
      bkSolid:
      begin
        Brush.Color := BackgroundColor;
        FillRect(TabsRect);
      end;
      bkHorzGradient: TGraphicsProvider.DrawVertGradient(Canvas, TabsRect, BackgroundColor, Color);
      bkVertGradient: TGraphicsProvider.DrawGradient(Canvas, TabsRect, BackgroundColor, Color);
      bkInveseVertGradient: TGraphicsProvider.DrawGradient(Canvas, TabsRect, Color, BackgroundColor);
    end;
    if pgTopBorder in Options then
    begin
      Pen.Color := clGrayText;
      case FTabPosition of
        tpTop: Polyline([Point(0, 0), Point(ClientWidth, 0)]);
        tpBottom: Polyline([Point(0, ClientHeight - 1), Point(ClientWidth, ClientHeight - 1)]);
      end;
    end;
  end;
end;

procedure TNxPageControl.DrawWhidbeyTab(r: TRect; Caption: string;
  TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
begin
  with Canvas do
  begin
    if Active then Pen.Color := GetColor(ceWhidbeyTabBorder) else Pen.Color := clGrayText;
    if AdaptiveColors then
    begin
      if Active then Brush.Color := TabColor else Brush.Color := cl3DLight;
    end else Brush.Color := TabColor;

    { Border }
    if First or Active then
    begin
      DrawPolyline([
        Point(r.Left, r.Bottom - 1),
        Point(r.Left + FTabHeight - 3, r.Top + 2),
        Point(r.Left + FTabHeight, r.Top + 1),
        Point(r.Left + FTabHeight + 2, r.Top),
        Point(r.Right - 3, r.Top),
        Point(r.Right - 1, r.Top + 2),
        Point(r.Right - 1, r.Top + 4),
        Point(r.Right - 1, r.Bottom)
        ], r);
    end else
    begin
      DrawPolyline([
        Point(r.Left + FTabHeight - 7, r.Top + 6),
        Point(r.Left + FTabHeight - 3, r.Top + 2),
        Point(r.Left + FTabHeight, r.Top + 1),
        Point(r.Left + FTabHeight + 2, r.Top),
        Point(r.Right - 3, r.Top),
        Point(r.Right - 1, r.Top + 2),
        Point(r.Right - 1, r.Top + 4),
        Point(r.Right - 1, r.Bottom)
        ], r);
      Pen.Color := Brush.Color;
    end;

    { Fill }
    if not Active then
    begin
      if First then
      begin
        SetClipPolygon([
          Point(r.Left, r.Bottom),
          Point(r.Left + FTabHeight - 3, r.Top + 3),
          Point(r.Left + FTabHeight - 1, r.Top + 2),
          Point(r.Left + FTabHeight + 2, r.Top + 0),
          Point(r.Right - 2, r.Top + 1),
          Point(r.Right - 1, r.Top + 2),
          Point(r.Right - 1, r.Top + 5),
          Point(r.Right - 1, r.Bottom)
        ], r);
      end else
      begin
        SetClipPolygon([
          Point(r.Left + FTabHeight - 7, r.Bottom - 1),
          Point(r.Left + FTabHeight - 7, r.Top + 7),
          Point(r.Left + FTabHeight - 3, r.Top + 3),
          Point(r.Left + FTabHeight - 1, r.Top + 2),
          Point(r.Left + FTabHeight + 2, r.Top + 0),
          Point(r.Right - 2, r.Top + 1),
          Point(r.Right - 1, r.Top + 2),
          Point(r.Right - 1, r.Top + 5),
          Point(r.Right - 1, r.Bottom)
        ], r);
      end;

      with TGraphicsProvider do
      begin
        case IsThemed of
          True:
          begin
            { draw gradients for when theme is on }
            if AdaptiveColors then DrawGradient(Canvas, r, clWindow, clBtnFace)
              else DrawGradient(Canvas, r, TabColor, Self.Color);
            Pen.Color := clWindow;
            DrawPolyline([
              Point(r.Left, r.Bottom),
              Point(r.Left + FTabHeight - 3, r.Top + 3),
              Point(r.Left + FTabHeight + 1, r.Top + 2)
            ], r);
            Pen.Color := clBtnFace;
            DrawPolyline([
              Point(r.Right - 3, r.Top + 1),
              Point(r.Right - 2, r.Top + 2),
              Point(r.Right - 2, r.Bottom)
            ], r);
          end;
          else begin
            if AdaptiveColors then Brush.Color := Self.BackgroundColor
              else Brush.Color := TabColor;
            FillRect(r);
          end;
        end;
      end;
    end else
    begin
      Pen.Color := Brush.Color;
      DrawPolygon([
        Point(r.Left + 1, r.Bottom - 1),
        Point(r.Left + FTabHeight - 3, r.Top + 3),
        Point(r.Left + FTabHeight + 1, r.Top + 2),
        Point(r.Left + FTabHeight + 1, r.Top + 1),
        Point(r.Right - 3, r.Top + 1),
        Point(r.Right - 2, r.Top + 2),
        Point(r.Right - 2, r.Top + 5),
        Point(r.Right - 2, r.Bottom - 1)
        ], r);
    end;
  end;
end;

procedure TNxPageControl.DrawDexterTab(r: TRect; Caption: string; //mb+
  TabColor: TColor; Glyph: TBitmap; Active, First: Boolean);
begin
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    if AdaptiveColors then
    begin
      if Active then
        Brush.Color := clWindow
      else
        Brush.Color := clBtnFace;
    end
    else
      Brush.Color := TabColor;

    if Active then
    begin
      DrawPolygon([
        Point(r.Left, r.Bottom),
        Point(r.Left, r.Top + 6),
        Point(r.Left + 2, r.Top + 3),
        Point(r.Left + 3, r.Top + 2),
        Point(r.Left + 6, r.Top),
        Point(r.Right - 18, r.Top),
        Point(r.Right - 14, r.Top + 2),
        Point(r.Right - 13, r.Top + 3),
        Point(r.Right - 11, r.Top + 6),
        Point(r.Right - 11, r.Top + 7),
        Point(r.Right - 11, r.Bottom - 10),
        Point(r.Right - 10, r.Bottom - 9),
        Point(r.Right - 9, r.Bottom - 5),
        Point(r.Right - 5, r.Bottom - 1),
        Point(r.Right - 1, r.Bottom),
        Point(r.Right, r.Bottom)
        ], r);
    end
    else
    begin
      { Fill }
      SetClipPolygon([
        Point(r.Left, r.Bottom - 1),
        Point(r.Left, r.Top + 6),
        Point(r.Left + 2, r.Top + 3),
        Point(r.Left + 3, r.Top + 2),
        Point(r.Left + 6, r.Top),
        Point(r.Right - 18, r.Top),
        Point(r.Right - 14, r.Top + 2),
        Point(r.Right - 13, r.Top + 3),
        Point(r.Right - 11, r.Top + 6),
        Point(r.Right - 11, r.Top + 7),
        Point(r.Right - 11, r.Bottom - 1)
        ], r);

      with TGraphicsProvider do
      begin
        if IsThemed then
        begin
          { draw gradients for when theme is on }
          if AdaptiveColors then
            DrawGradient(Canvas, r, clWindow, clBtnFace)
          else
            DrawGradient(Canvas, r, TabColor, Self.Color);
        end
        else
        begin
          if AdaptiveColors then
            Brush.Color := Self.BackgroundColor
          else
            Brush.Color := TabColor;
          FillRect(r);
        end;
      end;

      { Border }
      SelectClipRgn(Canvas.Handle, 0);
      Pen.Color := clBtnShadow;
      DrawPolyline([
        Point(r.Left, r.Bottom - 1),
        Point(r.Left, r.Top + 6),
        Point(r.Left + 2, r.Top + 3),
        Point(r.Left + 3, r.Top + 2),
        Point(r.Left + 6, r.Top),
        Point(r.Right - 18, r.Top),
        Point(r.Right - 14, r.Top + 2),
        Point(r.Right - 13, r.Top + 3),
        Point(r.Right - 11, r.Top + 6),
        Point(r.Right - 11, r.Top + 7),
        Point(r.Right - 11, r.Bottom - 1)
        ], r);
    end;
  end;
end;

procedure TNxPageControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_LEFT then SelectPrevPage;
  if Key = VK_RIGHT then SelectNextPage;
end;

procedure TNxPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APage: TNxTabSheet;
begin
  inherited;
  if not(csDesigning in ComponentState) then SetFocus;
  APage := GetTabAtPos(X, Y);
  if Assigned(APage) then
  begin
    if not (ssDouble in Shift) and (APage <> ActivePage)
      then ActivePage := APage;
    FDownTab := APage;
  end;
  FDownButton := GetButtonAtPos(Point(X, Y));
  case FDownButton of
    pbScrollLeft:   if not IsStartPos then InternalScroll(-1);
    pbScrollRight:  if not IsEndPos then InternalScroll(1);
    else Exit;
  end;
  if pgConstantScroll in FOptions then FScrollTimer.Enabled := True;
end;

procedure TNxPageControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Page: TNxTabSheet;
  FOldBtnHover: TPageButton;
begin
  inherited;
  if not(csDesigning in ComponentState) then
  begin
    FOldBtnHover := FHoverButton;
    FHoverButton := GetButtonAtPos(Point(X, Y));
    if FOldBtnHover <> FHoverButton then
    begin
      RefreshButton(FHoverButton);
      RefreshButton(FOldBtnHover);
    end;
    if FTabMoving then
    begin
      Page := GetTabAtPos(X, Y);
      if Assigned(Page) then
      begin

      end;
    end;
  end;
end;

procedure TNxPageControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Accept: Boolean;
  CursorPoint: TPoint;
  PageIndex, PageWidth, NewPos: Integer;
  TabAtPos: TNxTabSheet;
begin
  inherited;
  FScrollTimer.Enabled := False;
  Accept := True;
  if FDownButton <> pbNone then
  begin
    case GetButtonAtPos(Point(X, Y)) of
      pbClose:
        if Assigned(ActivePage) then
        begin
          if csDesigning in ComponentState then
            if MessageDlg('Close Page?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
          PageIndex := ActivePage.PageIndex;
          PageWidth := GetTabClientWidth(ActivePage);
          DoPageClose(PageIndex, Accept); { event }
          if Accept then
          begin
            DeletePage(Pages[PageIndex]);
            if FScrollPos > 0 then
            begin
              NewPos := FScrollPos - PageWidth;
              if NewPos < 0 then NewPos := 0;
              FScrollPos := NewPos;
            end;
          end;
        end;
      pbPopup:
      begin
        ShowTabsPopup;
        GetCursorPos(CursorPoint);
        { Refresh button if cursor is moved }
        CursorPoint := ScreenToClient(CursorPoint);
        if GetButtonAtPos(CursorPoint) <> pbPopup then
        begin
          FHoverButton := pbNone;
          RefreshButton(pbPopup);
        end;
      end;
    end;
  end;

  TabAtPos := GetTabAtPos(X, Y);
  if Assigned(TabAtPos) and (TabAtPos = FDownTab) then
  begin
    { Trigger Event }
    DoTabClick(TabAtPos.Index);
  end;

  FDownButton := pbNone;
  FDownTab := nil;
  FTabMoving := False;
end;

procedure TNxPageControl.Paint;
var
  i, j, X, Y, TabWidth: Integer;
  ActiveRect, TabRect, BorderRect: TRect;
  DrawActiveTab: Boolean;
begin
  inherited;
  DrawActiveTab := False;
  if (PageCount = 0) then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ClientRect);
    if not(pgAlwaysShowTabsRect in Options) then Exit;
  end;

  if ShowTabs then BorderRect := Rect(0, FTabHeight + FTopIndent + 1, ClientWidth, ClientHeight)
    else BorderRect := ClientRect;

  if (ActivePage = nil) or not ActivePage.PageVisible then
  begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.FillRect(BorderRect);
  end;

  if Margin > 0 then
  begin
    if pgPageBorder in Options then
    begin
      InflateRect(BorderRect, -1, 0);
      if ShowTabs then Dec(BorderRect.Bottom) else InflateRect(BorderRect, 0, -1);
    end;
    for i := 1 to Margin do
    begin
      Canvas.Brush.Color := Self.Color;
      Canvas.FrameRect(BorderRect);
      InflateRect(BorderRect, -1, -1);
    end;
  end;

  if pgPageBorder in Options then DrawPageBorder(ClientRect);

  if ShowTabs then
  begin
    DrawTabsBackground;
  end else Exit;
  if ActivePage = nil then Exit;
  X := FIndent - FScrollPos;
  Y := 0;
  case FTabPosition of
    tpTop:    Y := FTopIndent;
    tpBottom: Y := ClientHeight - FTabHeight - FTopIndent - 1;
  end;

 // position of DrawPageBorder moved (inherited DrawParentBackgroundbefore!)
  if pgPageBorder in Options then DrawPageBorder(ClientRect);

  Canvas.Font.Assign(Self.Font);
  j := 0;
  for i := 0 to Pred(PageCount) do
  begin
    if Pages[I].PageVisible and Pages[I].TabVisible then
    begin
      Inc(j);
      TabWidth := GetTabWidth(Pages[I]);
      if PartialTabs then
      begin
        if X > GetTabsEdge then Break;
      end else
      begin
        if X + TabWidth > GetTabsEdge then Break;
      end;
      if X + TabWidth >= 0 then
      begin
        if PartialTabs then
        begin
          TabRect := Rect(X, Y, Min(X + TabWidth, GetTabsEdge), Y + FTabHeight);
        end else
        begin
          TabRect := Rect(X, Y, X + TabWidth, Y + FTabHeight);
        end;
        if Pages[I] <> ActivePage then
        begin
          DrawTab(TabRect, Pages[I], False, j = 1);
        end else
        begin
          ActiveRect := TabRect;
          DrawActiveTab := True;
        end;
      end;
      Inc(X, GetTabWidth(Pages[I]) - GetTabsSpacing);
    end;
  end;

  case FTabPosition of
    tpTop:    Y := FTabHeight + FTopIndent;
    tpBottom: Y := ClientHeight - FTabHeight - FTopIndent - 1;
  end;

  SetClipRect(Canvas, ClientRect);
  if (Assigned(ActivePage)) and DrawActiveTab then
  begin
    case FTabStyle of
      tsClassic:
      begin
        Canvas.Pen.Color := clWhite;
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ActiveRect.Left + 1, Y);
        Canvas.Pen.Color := clBtnFace;
        Canvas.LineTo(ActiveRect.Right, Y);
        Canvas.Pen.Color := clWhite;
        Canvas.LineTo(ClientWidth, Y);
      end;
      tsFlat, tsWhidbey:
      begin
        Canvas.Pen.Color := GetColor(ceWhidbeyTabBorder);
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ActiveRect.Left, Y);
        if AdaptiveColors then Canvas.Pen.Color := clWindow else Canvas.Pen.Color := ActivePage.TabColor;
        Canvas.LineTo(ActiveRect.Right - 1, Y);
        Canvas.Pen.Color := GetColor(ceWhidbeyTabBorder);
        Canvas.MoveTo(ActiveRect.Right - 1, Y);
        Canvas.LineTo(ClientWidth, Y);
      end;
      tsOneNote:
      begin
        Canvas.Pen.Color := GetSysColor(COLOR_HOTLIGHT);
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ActiveRect.Left, Y);
        Canvas.Pen.Color := ActivePage.Color;
        Canvas.LineTo(ActiveRect.Right, Y);
        Canvas.Pen.Color := GetSysColor(COLOR_HOTLIGHT);
        Canvas.LineTo(ClientWidth, Y);
      end;
      tsDexter: //mb+
      begin
        Canvas.Pen.Color := clBtnShadow;
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ActiveRect.Left + 1, Y);
        if AdaptiveColors then Canvas.Pen.Color := clWindow else Canvas.Pen.Color := ActivePage.TabColor;
        Canvas.LineTo(ActiveRect.Right - 1, Y);
        Canvas.Pen.Color := clBtnShadow;
        Canvas.MoveTo(ActiveRect.Right - 2, Y);
        Canvas.LineTo(ClientWidth, Y);
      end;
    end;
    DrawTab(ActiveRect, ActivePage, True, True);
  end else
  begin
    case FTabStyle of
      tsClassic:
      begin
        Canvas.Pen.Color := clWhite;
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ClientWidth, Y);
      end;
      tsFlat, tsWhidbey:
      begin
        Canvas.Pen.Color := GetColor(ceWhidbeyTabBorder);
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ClientWidth, Y);
      end;
      tsOneNote:
      begin
        Canvas.Pen.Color := GetSysColor(COLOR_HOTLIGHT);
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ClientWidth, Y);
      end;
      tsDexter: //mb+
      begin
        Canvas.Pen.Color := clBtnShadow;
        Canvas.MoveTo(0, Y);
        Canvas.LineTo(ClientWidth, Y);
      end;
    end;
  end;

  SetClipRect(Canvas, ClientRect);
  if pgCloseButton in Options then
    DrawButton(GetButtonRect(pbClose), pbClose);

  if pgTabsPopup in Options then
    DrawButton(GetButtonRect(pbPopup), pbPopup);

  if pgScrollButtons in Options then
  begin
    DrawButton(GetButtonRect(pbScrollLeft), pbScrollLeft);
    DrawButton(GetButtonRect(pbScrollRight), pbScrollRight);
  end;

end;

procedure TNxPageControl.SetClipPolygon(Points: array of TPoint;
  Rect: TRect);
var
  FlipVert: Boolean;
begin
  FlipVert := False;
  case FTabPosition of
    tpTop:    FlipVert := False;
    tpBottom: FlipVert := True;
  end;
  if FlipVert then FlipPointsVert(Points, Rect);
  ClipPoly(Canvas, Points);
end;

procedure TNxPageControl.ShowTabsPopup;
var
  i: Integer;
  PopupPoint: TPoint;
  MenuItem: TMenuItem;
begin
  { Popup Point }
  with GetButtonRect(pbPopup)
    do PopupPoint := ClientToScreen(Point(Left, Bottom));

  if pgCustomTabsPopup in FOptions then
  begin
    DoCustomTabsPopup(PopupPoint.X, PopupPoint.Y); { Event }
  end else
  begin
    { Set Images }
    FTabsPopup.Items.Clear;
    FTabsPopup.Images := FImages;

    { Add Items }
    for i := 0 to PageCount - 1 do
      if IsTabVisible(Pages[i]) then
      begin
        MenuItem := TMenuItem.Create(FTabsPopup);
        MenuItem.Caption := Pages[i].Caption;
        MenuItem.OnClick := DoMenuItemClick;
        MenuItem.Tag := i;
        if Pages[i].DisplayMode = tdImageIndex
          then MenuItem.ImageIndex := Pages[i].ImageIndex else
        begin
          MenuItem.ImageIndex := -1;
        end;
        FTabsPopup.Items.Add(MenuItem);
      end;

    { Popup }
    FTabsPopup.Popup(PopupPoint.X, PopupPoint.Y);
  end;
end;

procedure TNxPageControl.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  ATabPage: TNxTabSheet;
begin
  inherited;
  ATabPage := GetTabAtPos(Message.XPos, Message.YPos);
  if (Assigned(ATabPage)) and (ATabPage <> ActivePage)
    or (GetButtonAtPos(Point(Message.XPos, Message.YPos)) <> pbNone)
      then Message.Result := 1 else Message.Result := 0;
end;

procedure TNxPageControl.CMFontChanged(var Message: TMessage);
var
  i: Integer;
begin
  inherited;
  for i := 0 to Pred(FPageList.Count) do
    if Pages[i].ParentTabFont then
      Pages[i].AssignFont(Font);
end;

procedure TNxPageControl.CMMouseLeave(var Message: TMessage);
var
  FOldHoverBtn: TPageButton;
begin
  FOldHoverBtn := FHoverButton;
  FHoverButton := pbNone;
  if (FOldHoverBtn <> FHoverButton) then RefreshButton(FOldHoverBtn);
end;

procedure TNxPageControl.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TNxPageControl.WMSize(var Message: TWMSize);
var
  r: TRect;
begin
  inherited;
  if TabPosition = tpBottom then
  begin
    { vertical resize }
    if FOldHeight <> ClientHeight then
    begin
      RefreshTabs;
      r := Rect(0, FOldHeight, ClientWidth, ClientHeight);
      InvalidateRect(Handle, @r, False);
      FOldHeight := ClientHeight;
    end;
  end;
  if FOldWidth <> ClientWidth then
  begin
    //to-do
    if FScrollPos > 0 then ScrollTabs(FOldWidth - ClientWidth);
    FOldWidth := ClientWidth;
  end;
end;

procedure TNxPageControl.SetAdaptiveColors(const Value: Boolean);
begin
  FAdaptiveColors := Value;
  Invalidate;
end;

procedure TNxPageControl.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  Invalidate;
end;

procedure TNxPageControl.SetBackgroundKind(const Value: TBackgroundKind);
begin
  FBackgroundKind := Value;
  Invalidate;
end;

procedure TNxPageControl.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  if FImages <> nil then FreeNotification(FImages);
  Invalidate;
end;

procedure TNxPageControl.SetIndent(const Value: Integer);
begin
  FIndent := Value;
  Invalidate;
end;

procedure TNxPageControl.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Realign;
  Invalidate;
end;

procedure TNxPageControl.SetOptions(const Value: TPageOptions);
begin
  FOptions := Value;
  Invalidate;
end;

procedure TNxPageControl.SetShowTabs(const Value: Boolean);
begin
  FShowTabs := Value;
  Refresh;
  Realign;
end;

procedure TNxPageControl.SetSpacing(const Value: Integer);
begin
  FSpacing := Value;
  Invalidate;
end;

procedure TNxPageControl.SetTabAlignment(const Value: TAlignment);
begin
  FTabAlignment := Value;
  Invalidate;
end;

procedure TNxPageControl.SetTabHeight(const Value: Integer);
begin
  FTabHeight := Value;
  Invalidate;
  Realign;
end;

procedure TNxPageControl.SetTabPosition(const Value: TTabPosition);
begin
  FTabPosition := Value;
  Invalidate;
  Realign;
end;

procedure TNxPageControl.SetTabStyle(const Value: TTabStyle);
begin
  FTabStyle := Value;
  Invalidate;
end;

procedure TNxPageControl.SetTopIndent(const Value: Integer);
begin
  FTopIndent := Value;
  Invalidate;
  Realign;
end;

function TNxPageControl.GetButtonAtPos(Point: TPoint): TPageButton;
begin
  Result := pbNone;
  if pgCloseButton in Options then
  begin
    if PtInRect(GetButtonRect(pbClose), Point) then Result := pbClose;
  end;
  if pgScrollButtons in Options then
  begin
    if PtInRect(GetButtonRect(pbScrollLeft), Point) then Result := pbScrollLeft
    else if PtInRect(GetButtonRect(pbScrollRight), Point) then Result := pbScrollRight;
  end;
  if pgTabsPopup in Options then
  begin
    if PtInRect(GetButtonRect(pbPopup), Point) then Result := pbPopup;
  end;
end;

function TNxPageControl.GetTabAtPos(const X, Y: Integer): TNxTabSheet;
var
  I, P, e, TabWidth, TabRight, Xs, Ys, Xl, Yl: Integer;

  function GetNextTab(Index: Integer): Integer;
  begin
    Result := Index + 1;
    while (Result < PageCount) and not IsTabVisible(Pages[Result]) do Inc(Result);
  end;
  
begin
  Result := nil;
  e := GetTabsEdge;
  if not PtInRect(GetTabsClientRect, Point(X, Y)) then Exit;
  P := Indent - FScrollPos;
  for i := 0 to Pred(PageCount) do
  begin
    if Pages[i].PageVisible and Pages[i].TabVisible then
    begin
      TabWidth := GetTabWidth(Pages[i]);
      if PartialTabs then
      begin
        TabRight := Min(P + TabWidth, GetTabsEdge);
      end else
      begin
        TabRight := P + TabWidth;
      end;

      if TabRight > E then Exit;

      if (X >= P) and (X < TabRight) then
      begin
        if GetNextTab(i) = FActivePageIndex then
        begin
          Xs := TabRight - GetTabsSpacing;
          Xl := X - Xs;
          case FTabPosition of
            tpTop: begin
              Ys := GetTabsClientRect.Bottom - GetTabsSpacing;
              Yl := Y - Ys;
            end;
            else begin
              Ys := GetTabsClientRect.Top;
              Yl := Y - Ys;
              Yl := GetTabsSpacing - Yl;
            end;
          end;
          if Xl + Yl >= Pred(GetTabsSpacing) then
          begin
            Inc(P, TabWidth - GetTabsSpacing);
            Continue;
          end;
        end;
        Result := Pages[i];
        Exit;
      end else Inc(P, TabWidth - GetTabsSpacing);
    end;
  end;
end;

function TNxPageControl.GetTabClientWidth(APage: TNxTabSheet): Integer;
begin
  { cut overlaping parts }
  Result := GetTabWidth(APage) - GetTabsSpacing;
end;

function TNxPageControl.GetTabRect(Index: Integer): TRect;
var
  i, start: Integer;
begin
  start := Indent - FScrollPos;
  for i := 0 to Index - 1 do
    if Pages[i].PageVisible and Pages[i].TabVisible
      then Inc(start, GetTabWidth(Pages[i]) - GetTabsSpacing);
  with Result do
  begin
    case FTabPosition of
      tpTop: Top := TopIndent;
      tpBottom: Top := ClientHeight - FTabHeight - TopIndent;
    end;    
    Left := start;
    Right := Left + GetTabWidth(Pages[Index]);
    Bottom := Top + FTabHeight;
  end;
end;

function TNxPageControl.GetTabWidth(APage: TNxTabSheet): Integer;
var
  TextWidth: Integer;
begin
  if APage.TabWidth = 0 then
  begin
    Result := 0;
    Canvas.Font.Assign(APage.FTabFont);
    Canvas.Font.Style := [fsBold];
    TextWidth := Canvas.TextWidth(APage.Caption);
    if TextWidth = 0 then TextWidth := 8;

    case FTabStyle of
      tsClassic:  Result := TextWidth + 12;
      tsFlat:     Result := TextWidth + FTabHeight;
      tsOneNote:  Result := TextWidth + FTabHeight + 36;
      tsWhidbey:  Result := TextWidth + FTabHeight;
      tsDexter:  Result := TextWidth + FTabHeight; //mb+
    end;
    Inc(Result, FTabMargin * 2);
    case APage.DisplayMode of
      tdGlyph: if not APage.Glyph.Empty then Inc(Result, APage.Glyph.Width + 4);
      tdImageIndex: if (Images <> nil) and (APage.ImageIndex > -1) and (APage.ImageIndex < Images.Count) then Inc(Result, Images.Width + 4);
    end;
    if (FTabMaxWidth > 0) and (Result > FTabMaxWidth) then Result := FTabMaxWidth;
  end else Result := APage.TabWidth;
end;

function TNxPageControl.IsTabVisible(APage: TNxTabSheet): Boolean;
begin
  Result := APage.TabVisible and APage.PageVisible;
end;

procedure TNxPageControl.MakeVisible(const Index: Integer);
var
  I, P: Integer;
begin
  P := 0;
  for I := 0 to Pred(PageCount) do
    if Pages[I].PageIndex <= Index then
      Inc(P, GetTabWidth(Pages[I]));
  ScrollTabs(GetTabsEdge - P);
end;

procedure TNxPageControl.RefreshButton(Button: TPageButton);
var
  r: TRect;
begin
  r := GetButtonRect(Button);
  InvalidateRect(Handle, @r, False);
end;

procedure TNxPageControl.RefreshPage(const Index: Integer);
var
  r: TRect;
begin
  r := GetTabRect(Index);
  case FTabPosition of
    tpTop: Inc(r.Bottom);
    tpBottom: Dec(r.Top);
  end;
  InvalidateRect(Handle, @r, False);
end;

procedure TNxPageControl.RefreshTabs;
var
  r: TRect;
begin
  r := GetTabsRect;
  case FTabPosition of
    tpTop:    Inc(r.Bottom);
    tpBottom: Dec(r.Top);
  end;
  InvalidateRect(Handle, @r, False);
end;

procedure TNxPageControl.ScrollTabs(Delta: Integer);
var
  OldPos, Max: Integer;
  ClippingRect: TRect;
begin

  ClippingRect := GetTabsRect;
  ClippingRect.Right := GetTabsEdge;
  case FTabPosition of
    tpTop:    Inc(ClippingRect.Bottom);
    tpBottom: Dec(ClippingRect.Top);
  end;

  OldPos := FScrollPos;
  Delta := -Delta;
  FScrollPos := FScrollPos - Delta;
  if FScrollPos < 0 then FScrollPos := 0;
  Max := GetScrollMax;
  if FScrollPos > max then FScrollPos := Max;
  if ((OldPos = 0) and (FScrollPos > 0)) or
    ((OldPos > 0) and (FScrollPos = 0)) then RefreshButton(pbScrollLeft);
  if ((OldPos = max) and (FScrollPos < max)) or
    ((OldPos < max) and (FScrollPos = max)) then RefreshButton(pbScrollRight);

  InvalidateRect(Handle, @ClippingRect, False);
end;

procedure TNxPageControl.ScrollToTab(const Index: Integer);
var
  TabRect: TRect;
begin
  { if tab is completelly in view (no partial)
    don't scroll }
  if TabInView(Index) then Exit;
  TabRect := GetTabRect(Index);
  if TabRect.Left > FIndent then
  begin
    Dec(FScrollPos, GetTabsEdge - TabRect.Right);
    if FScrollPos > GetScrollMax then FScrollPos := GetScrollMax;
  end else
  begin
    FScrollPos := TabRect.Left + FScrollPos;
  end;
  RefreshTabs;
end;

procedure TNxPageControl.SetTabMaxWidth(const Value: Integer);
begin
  FTabMaxWidth := Value;
  Invalidate;
end;

function TNxPageControl.GetTabByCaption(const S: WideString;
  IgnoreCase: Boolean = False): TNxTabSheet;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pred(FPageList.Count) do
    if IgnoreCase then begin
       if CompareText(Pages[i].Caption, S) = 0 then begin
          Result := Pages[i];
          Exit;
       end;
    end else begin
       if Pages[i].Caption = S then begin
          Result := Pages[i];
          Exit;
       end;
    end;
end;

procedure TNxPageControl.DoMenuItemClick(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    ActivePageIndex := Tag;
  end;
end;

procedure TNxPageControl.DoScrollTimer(Sender: TObject);
begin
  case FDownButton of
    pbScrollLeft:   if not IsStartPos then InternalScroll(-1);
    pbScrollRight:  if not IsEndPos then InternalScroll(1);
  end;
end;

procedure TNxPageControl.DoTabClick(PageIndex: Integer);
begin
  if Assigned(FOnTabClick) then FOnTabClick(Self, PageIndex);
end;

procedure TNxPageControl.InternalScroll(Delta: Integer);
  function CalcAbsoluteScrollPos(PageIndex: Integer): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to PageIndex do
      Result := Result + GetTabClientWidth(Pages[i]);
  end;
var
  FOldPos: Integer;
  NewScrollPos: Integer;
begin
  FOldPos := FScrollPos;
  case FScrollMethod of
    smPixels: ScrollTabs(Delta * 10);
    smTab:
    begin
      NewScrollPos := FScrollPos;
      if Delta < 0 then
      begin
        if GetFirstVisible = 0 then NewScrollPos := 0
        else if GetFirstVisible > 0 then
        begin
          if GetTabsSpacing < 1 then
            NewScrollPos := CalcAbsoluteScrollPos(GetFirstVisible - 2)
          else
            NewScrollPos := CalcAbsoluteScrollPos(GetFirstVisible - 1);
        end;
      end else if Delta > 0 then
      begin
        if FScrollPos = 0 then NewScrollPos := CalcAbsoluteScrollPos(GetFirstVisible)
        else if CalcAbsoluteScrollPos(PageCount - 1) - FScrollPos >= GetTabsEdge then
        begin
          if GetTabsSpacing < 1 then
            NewScrollPos := CalcAbsoluteScrollPos(GetFirstVisible)
          else
            NewScrollPos := CalcAbsoluteScrollPos(GetFirstVisible + 1);
        end;
      end;
      if NewScrollPos <> FScrollPos then ScrollTabs(NewScrollPos - FOldPos);
    end;
    smSelect: if Delta < 0 then SelectPrevPage else SelectNextPage;
  end;
  if FOldPos <> FScrollPos then
  begin
    RefreshButton(pbScrollLeft);
    RefreshButton(pbScrollRight);
  end;
end;

function TNxPageControl.TabInView(const Index: Integer): Boolean;
var
  TabRect: TRect;
begin
  { Tabs is in view completelly }
  TabRect := GetTabRect(Index);
  with GetTabsClientRect do Result := (TabRect.Left >= Left) and (TabRect.Right <= Right)
end;

function TNxPageControl.GetTabsClientWidth: Integer;
begin
  Result := ClientWidth - FIndent - GetTabsRight;
end;

function TNxPageControl.IsEndPos: Boolean;
begin
  case FScrollMethod of
    smPixels, smTab: Result := FScrollPos >= GetScrollMax;
    else Result := ActivePageIndex >= Pred(PageCount);
  end;
end;

function TNxPageControl.IsStartPos: Boolean;
begin
  case FScrollMethod of
    smPixels, smTab: Result := FScrollPos = 0;
    else Result := ActivePageIndex = 0;
  end;
end;

procedure TNxPageControl.DoCustomTabsPopup(X, Y: Integer);
begin
  if Assigned(FOnCustomTabsPopup) then FOnCustomTabsPopup(Self, X, Y);
end;

procedure TNxPageControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
end;

procedure TNxPageControl.SetTabMargin(const Value: Integer);
begin
  FTabMargin := Value;
  Invalidate;
end;

procedure TNxPageControl.SetPartialTabs(const Value: Boolean);
begin
  FPartialTabs := Value;
  Invalidate;
end;

procedure TNxPageControl.DoCustomDrawBackground(BackgroundRect: TRect);
begin
  if Assigned(FOnCustomDrawBackground) then FOnCustomDrawBackground(Self, BackgroundRect);
end;

{ TNxNotebook }

procedure TNxNotebook.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  if (csDesigning in ComponentState) or FDesignButtons
    then Dec(Rect.Bottom, sizDesignHeight);
end;

procedure TNxNotebook.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  ButtonIndex: Integer;
begin
  if csDesigning in ComponentState then
  begin
    ButtonIndex := GetDesignButtonAtPos(Message.XPos, Message.YPos);
    if (InRange(ButtonIndex, 0, GetPageCount - 1) and (ButtonIndex <> ActivePageIndex))
      or (GetArrowBtnAtPos(Message.XPos, Message.YPos) <> abNone)
      then Message.Result := 1 else Message.Result := 0;
  end;
end;

constructor TNxNotebook.Create(AOwner: TComponent);
begin
  inherited;
  FDesignButtons := False;
  FScrollPos := 0;
end;

procedure TNxNotebook.DrawArrowBtn(Kind: TArrowBtnKind);
var
  r: TRect;
begin
  r := GetArrowBtnRect(Kind);
  with Canvas do
  begin
    case Kind of
      abLeft: begin
        if FScrollPos = 0 then
        begin
          Brush.Color := clBtnFace;
          Pen.Color := clBtnFace;
          FrameRect(r);
        end else
        begin
          Brush.Color := clDiscreetSilver;
          FrameRect(r);
          Brush.Color := clWindowText;
          Pen.Color := clWindowText;
        end;
        Canvas.Polygon([
          Point(r.Right - 7, r.Top + 6),
          Point(r.Left + 5, r.Top + (r.Bottom - r.Top) div 2),
          Point(r.Right - 7, r.Bottom - 7)]);
      end;
      abRight: begin
        if FScrollPos >= GetScrollMax then
        begin
          Brush.Color := clBtnFace;
          Pen.Color := clBtnFace;
          FrameRect(r);
        end else
        begin
          Brush.Color := clDiscreetSilver;
          FrameRect(r);
          Brush.Color := clWindowText;
          Pen.Color := clWindowText;
        end;
        Canvas.Polygon([
          Point(r.Left + 6, r.Top + 6),
          Point(r.Right - 6, r.Top + (r.Bottom - r.Top) div 2),
          Point(r.Left + 6, r.Bottom - 7)]);
      end;
    end;
  end;
end;

function TNxNotebook.GetArrowBtnAtPos(const X, Y: Integer): TArrowBtnKind;
begin
  if PtInRect(GetArrowBtnRect(abLeft), Point(X, Y)) then
  begin
    Result := abLeft;
  end else if PtInRect(GetArrowBtnRect(abRight), Point(X, Y)) then
  begin
    Result := abRight;
  end else Result := abNone;
end;

function TNxNotebook.GetArrowBtnRect(Kind: TArrowBtnKind): TRect;
begin
  with Result do
  begin
    Top := ClientHeight - sizDesignHeight + 2;
    Bottom := ClientHeight - 2;
    case Kind of
      abLeft:
      begin
        Left := 2;
        Right := Left + sizDsgnArrowBtnWidth;
      end;
      abRight:
      begin
        Right := ClientWidth - 2;
        Left := Right - sizDsgnArrowBtnWidth;
      end;
    end;
  end;
end;

function TNxNotebook.GetDesignButtonAtPos(X, Y: Integer): Integer;
var
  i, posx, posy, w: Integer;
  r: TRect;
begin
  Result := -1;
  posx := GetArrowBtnRect(abLeft).Right + 2;
  posy := ClientHeight - sizDesignHeight - 2;
  for i := FScrollPos to GetPageCount - 1 do
  begin
    w := Canvas.TextWidth(Pages[i].Name) + 8;
    if posx + w >= GetArrowBtnRect(abRight).Left then Exit;
    r := Rect(posx, posy, posx + w, ClientHeight - 2);
    if PtInRect(r, Point(X, Y)) then
    begin
      Result := i;
      Exit;
    end;
    Inc(posx, w + 2);
  end;
end;

function TNxNotebook.GetScrollMax: Integer;
var
  i, x, w, c: Integer;
begin
  c := 0;
  x := GetArrowBtnRect(abLeft).Right + 2;
  for i := FScrollPos to GetPageCount - 1 do
  begin
    w := Canvas.TextWidth(Pages[i].Name) + 8;
    if x + w >= GetArrowBtnRect(abRight).Left then Break;
    Inc(x, w + 2);
    Inc(c);
  end;
  Result := PageCount - c;
end;

procedure TNxNotebook.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  ButtonIndex: Integer;
begin
  inherited;
  if (csDesigning in ComponentState) or FDesignButtons then
  begin
    case GetArrowBtnAtPos(X, Y) of
      abLeft: ScrollButtons(-1);
      abRight: ScrollButtons(1);
      abNone:
      begin
        ButtonIndex := GetDesignButtonAtPos(X, Y);
        if InRange(ButtonIndex, 0, Pred(PageCount))
          then ActivePageIndex := ButtonIndex;
      end;
    end;
    Invalidate;
  end;
end;

procedure TNxNotebook.Paint;
begin
  inherited;
  if (csDesigning in ComponentState) or FDesignButtons then
  begin
    Canvas.Brush.Color := clWindow;
    Canvas.FillRect(Rect(0, ClientHeight - sizDesignHeight, ClientWidth, ClientHeight));
    PaintDesignButtons;
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clGrayText;
    Canvas.Brush.Color := clBtnFace;
    Canvas.Rectangle(Rect(0, 0, ClientWidth, ClientHeight - sizDesignHeight));
  end;
end;

procedure TNxNotebook.PaintDesignButtons;
var
  i, x, y, w: Integer;
  r: TRect;
begin
  DrawArrowBtn(abLeft);
  y := ClientHeight - sizDesignHeight;
  x := GetArrowBtnRect(abLeft).Right + 2;

  Canvas.Font.Assign(Self.Font);
  for i := FScrollPos to GetPageCount - 1 do
  begin
    w := Canvas.TextWidth(Pages[i].Name) + 8;
    if x + w >= GetArrowBtnRect(abRight).Left then Break;
    r := Rect(x, y + 2, x + w, ClientHeight - 2);

    with Canvas do
    begin
      if Pages[i].PageVisible then
      begin
        Brush.Color := clDiscreetSilver;
        Font.Color := clWindowText;
      end else
      begin
        Brush.Color := clBtnFace;
        Font.Color := clGrayText;
      end;

      if Pages[i] = ActivePage then
      begin
        Brush.Color := clHighlight;
        FrameRect(r);
        InflateRect(r, -1, -1);
        FrameRect(r);
      end else
      begin
        FrameRect(r);
        InflateRect(r, -1, -1);
      end;

      DrawText(Canvas, r, taCenter, Pages[i].Name, True);
    end;
    Inc(x, w + 2);
  end;
  DrawArrowBtn(abRight);
end;

procedure TNxNotebook.ScrollButtons(Delta: Integer);
var
  Max: Integer;
begin
  Max := GetScrollMax;
  Inc(FScrollPos, Delta);
  if FScrollPos < 0 then FScrollPos := 0;
  if FScrollPos > Max then FScrollPos := Max;
end;

procedure TNxNotebook.SetDesignButtons(const Value: Boolean);
begin
  FDesignButtons := Value;
  if not(csDesigning in ComponentState) then Invalidate;
end;

{ TNxGlyphPageControl }

procedure TNxGlyphPageControl.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  Inc(Rect.Top, FTopIndent);
  Inc(Rect.Top, FTabHeight);
end;

procedure TNxGlyphPageControl.CMDesignHitTest(
  var Message: TCMDesignHitTest);
var
  ATabPage: TNxTabSheet;
begin
  inherited;
  ATabPage := GetTabAtPos(Message.XPos, Message.YPos);
  if Assigned(ATabPage) and (ATabPage <> ActivePage)
      then Message.Result := 1 else Message.Result := 0;
end;

constructor TNxGlyphPageControl.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taCenter;
  FBackgroundColorFrom := clGray;
  FBackgroundColorTo := clGray;
  FBackgroundKind := bkSolid;
  FFontActive := TFont.Create;
  FFontNormal := TFont.Create;
  FGlyphActive := TNxTabGlyph.Create(Self);
  FGlyphNormal := TNxTabGlyph.Create(Self);
  FTopIndent := 10;
  FTabHeight := 21;
  FTabPadding := 16;
  FTabSpacing := 2;
end;

destructor TNxGlyphPageControl.Destroy;
begin
  FreeAndNil(FFontActive);
  FreeAndNil(FFontNormal);
  FreeAndNil(FGlyphActive);
  FreeAndNil(FGlyphNormal);
  inherited;
end;

procedure TNxGlyphPageControl.DrawTab(const Index: Integer);
var
  LeftBitmap, RightBitmap: TBitmap;
  TabRect, LeftRect, RightRect: TRect;
begin
  TabRect := GetTabRect(Index);

  if ActivePage <> Pages[Index] then
  begin
    LeftBitmap := FGlyphNormal.LeftGlyph;
    RightBitmap := FGlyphNormal.RightGlyph;
    Canvas.Font.Assign(FFontNormal);
  end else
  begin
    LeftBitmap := FGlyphActive.LeftGlyph;
    RightBitmap := FGlyphActive.RightGlyph;
    Canvas.Font.Assign(FFontActive);
  end;

  LeftRect := TabRect;
  Dec(LeftRect.Right, RightBitmap.Width);
  BitmapInRect(Canvas, LeftRect, LeftBitmap);

  RightRect := TabRect;
  RightRect.Left := RightRect.Right - RightBitmap.Width;
  BitmapInRect(Canvas, RightRect, RightBitmap);

  DrawText(Canvas, TabRect, taCenter, Pages[Index].Caption);
  //  Canvas.Brush.Color := clYellow;
  //  Canvas.FrameRect(TabRect);
end;

procedure TNxGlyphPageControl.DrawTabsBackground;
var
  TabsRect: TRect;
  Shift, Pt: TPoint;
  DC: HDC;
begin
  with Canvas do
  begin
    TabsRect := ClientRect;
    TabsRect.Bottom := FTabHeight + FTopIndent;
    case FBackgroundKind of
      bkTransparent:
      begin
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
      bkSolid:
      begin
        Brush.Color := BackgroundColorFrom;
        FillRect(TabsRect);
      end;
      bkHorzGradient: TGraphicsProvider.DrawVertGradient(Canvas, TabsRect, BackgroundColorFrom, BackgroundColorTo);
      bkVertGradient: TGraphicsProvider.DrawGradient(Canvas, TabsRect, BackgroundColorFrom, BackgroundColorTo);
      bkInveseVertGradient: TGraphicsProvider.DrawGradient(Canvas, TabsRect, BackgroundColorTo, BackgroundColorFrom);
    end;
  end;
end;

function TNxGlyphPageControl.GetTabAtPos(const X, Y: Integer): TNxTabSheet;
var
  i, Pos: Integer;
begin
  Result := nil;
  Pos := GetTabStart;
  for i := 0 to FPageList.Count - 1 do
  begin
    if Pages[i].TabVisible then
    begin
      if (X >= Pos) and (X <= Pos + GetTabWidth(i)) then
      begin
        Result := Pages[i];
        Exit;
      end;
      Inc(Pos, GetTabWidth(i) + TabSpacing);
    end;
  end;
end;

function TNxGlyphPageControl.GetTabRect(const Index: Integer): TRect;
var
  TabLeft, TabTop, i: Integer;
begin
  TabLeft := GetTabStart;
  TabTop := FTopIndent;
  for i := 0 to Index - 1 do
  begin
    Inc(TabLeft, GetTabWidth(i));
    if i < Index then Inc(TabLeft, FTabSpacing);
  end;
  with Result do
  begin
    Left := TabLeft;
    Right := TabLeft + GetTabWidth(Index);
    Top := TabTop;
    Bottom := FTabHeight + FTopIndent;
  end;
end;

function TNxGlyphPageControl.GetTabStart: Integer;
begin
  case FAlignment of
    taLeftJustify: Result := 10;
    taRightJustify: Result := ClientWidth - GetTabsWidth - 10;
    else Result := ClientWidth div 2 - GetTabsWidth div 2;
  end;
end;

function TNxGlyphPageControl.GetTabsWidth: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FPageList.Count - 1 do
  begin
    Inc(Result, GetTabWidth(i));
    if i < FPageList.Count - 1 then Inc(Result, FTabSpacing);
  end;
end;

function TNxGlyphPageControl.GetTabWidth(const Index: Integer): Integer;
begin
  Canvas.Font.Assign(Font);
  if Index = ActivePageIndex then
  begin
    Canvas.Font.Assign(FFontActive);
    Canvas.Font.Style := [];
  end;
  Result := Canvas.TextWidth(Pages[Index].Caption) + FTabPadding * 2;
end;

procedure TNxGlyphPageControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  MouseUpTab: TNxTabSheet;
begin
  inherited;
  MouseUpTab := GetTabAtPos(X, Y);
  if Assigned(MouseUpTab) and (MouseUpTab <> ActivePage) then
  begin
    ActivePage := MouseUpTab;
  end;
end;

procedure TNxGlyphPageControl.Paint;
var
  i: Integer;
begin
  inherited;
  DrawTabsBackground;
  for i := 0 to FPageList.Count - 1 do
  begin
    if Pages[i].TabVisible then DrawTab(i);
  end;
  Canvas.Pen.Color := clLime;
//  Canvas.MoveTo(GetTabStart, 0);
//  Canvas.LineTo(GetTabStart, Height);
end;

procedure TNxGlyphPageControl.RefreshPage(const Index: Integer);
var
  R: TRect;
begin
  R := GetTabRect(Index);
  InvalidateRect(Handle, @R, False);
end;

procedure TNxGlyphPageControl.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TNxGlyphPageControl.SetBackgroundColorFrom(const Value: TColor);
begin
  FBackgroundColorFrom := Value;
  Invalidate;
end;

procedure TNxGlyphPageControl.SetBackgroundColorTo(const Value: TColor);
begin
  FBackgroundColorTo := Value;
  Invalidate;
end;

procedure TNxGlyphPageControl.SetBackgroundKind(
  const Value: TBackgroundKind);
begin
  FBackgroundKind := Value;
end;

procedure TNxGlyphPageControl.SetFontActive(const Value: TFont);
begin
  FFontActive.Assign(Value);
end;

procedure TNxGlyphPageControl.SetFontNormal(const Value: TFont);
begin
  FFontNormal.Assign(Value);
end;

procedure TNxGlyphPageControl.SetGlyphActive(const Value: TNxTabGlyph);
begin
  FGlyphActive.Assign(Value);
end;

procedure TNxGlyphPageControl.SetGlyphNormal(const Value: TNxTabGlyph);
begin
  FGlyphNormal.Assign(Value);
  Invalidate;
end;

procedure TNxGlyphPageControl.SetTabHeight(const Value: Integer);
begin
  FTabHeight := Value;
end;

procedure TNxGlyphPageControl.SetTabPadding(const Value: Integer);
begin
  FTabPadding := Value;
  Invalidate;
end;

procedure TNxGlyphPageControl.SetTabSpacing(const Value: Integer);
begin
  FTabSpacing := Value;
  Invalidate;
end;

procedure TNxGlyphPageControl.SetTopIndent(const Value: Integer);
begin
  FTopIndent := Value;
end;

{ TNxTabGlyph }

constructor TNxTabGlyph.Create(AOwner: TComponent);
begin
  FLeftGlyph := TBitmap.Create;
  FRightGlyph := TBitmap.Create;
end;

destructor TNxTabGlyph.Destroy;
begin
  FreeAndNil(FLeftGlyph);
  FreeAndNil(FRightGlyph);
  inherited;
end;

procedure TNxTabGlyph.SetLeftGlyph(const Value: TBitmap);
begin
  FLeftGlyph.Assign(Value);
end;

procedure TNxTabGlyph.SetRightGlyph(const Value: TBitmap);
begin
  FRightGlyph.Assign(Value);
end;

end.
