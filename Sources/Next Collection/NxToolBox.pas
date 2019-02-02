{
  Next Collection
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxToolBox.pas bn
}

unit NxToolBox;

{$R NxToolBoxRes.res}

interface

uses
  Classes, Types, Graphics, Controls, ImgList, Messages,
  NxClasses, NxThemesSupport, NxCollection, NxScrollControl;

const
  spTextDistance = 35;

  { Space between left edge and icon } 
  spOutBarGlyphIndent = 4;

type
  TNxToolBoxCategoryItem = class;
  TNxToolBoxCategories = class;
  TNxToolBoxItem = class;
  TNxToolBox = class;
  TNxOutlookBar = class;

  TNxToolBoxItems = class(TCollection)
  private
    FOwner: TNxToolBoxCategoryItem;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TNxToolBoxCategoryItem);
    function Add: TNxToolBoxItem;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  end;

  TNxToolBoxItem = class(TCollectionItem)
  private
    FCaption: WideString;
    FCategory: TNxToolBoxCategoryItem;
    FData: TObject;
    FImageIndex: TImageIndex;
    FTag: Longint;
    procedure SetCaption(const Value: WideString);
    procedure SetImageIndex(const Value: TImageIndex);
  protected
    procedure Refresh; virtual;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Data: TObject read FData write FData;
  published
    property Caption: WideString read FCaption write SetCaption;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property Tag: Longint read FTag write FTag default 0;
  end;

  TNxToolBoxCategoryItem = class(TNxToolBoxItem)
  private
    FCategories: TNxToolBoxCategories;
    FExpanded: Boolean;
    FItems: TNxToolBoxItems;
    procedure SetExpanded(const Value: Boolean);
    procedure SetItems(const Value: TNxToolBoxItems);
  protected
    procedure Refresh; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Expanded: Boolean read FExpanded write SetExpanded;
    property Items: TNxToolBoxItems read FItems write SetItems;
  end;

  TNxToolBoxCategories = class(TCollection)
  private
    FOwner: TNxToolBox;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TNxToolBox);
    function Add: TNxToolBoxCategoryItem;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  end;

  TNxCategoriesStyle = (casDefault, casBottomLine);

  TNxToolBox = class(TNxScrollControl)
  private
    FCategories: TNxToolBoxCategories;
    FCollapseGlyph: TBitmap;
    FExpandGlyph: TBitmap;
    FImages: TImageList;
    FItemHeight: Integer;
    FSelectedItem: TNxToolBoxItem;
    FOnSelectItem: TNotifyEvent;
    FCategoriesStyle: TNxCategoriesStyle;
    procedure SetItemHeight(const Value: Integer);
    procedure SetCategories(const Value: TNxToolBoxCategories);
    procedure SetSelectedItem(const Value: TNxToolBoxItem);
    procedure SetImages(const Value: TImageList);
    procedure SetCategoriesStyle(const Value: TNxCategoriesStyle);
  protected
    FDownItem: TNxToolBoxItem;
    FHoverItem: TNxToolBoxItem;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function GetVertScrollMax: Integer;
    function GetVertOffset(FromPos, ToPos: Integer): Integer; override;
    function GetVisibleCount: Integer;
    procedure CreateWnd; override;
    procedure DoSelectItem; dynamic;
    procedure DrawBackground; virtual;
    procedure DrawCategoryBackground(ItemRect: TRect); virtual;
    procedure DrawCategoryItem(ItemRect: TRect; Item: TNxToolBoxCategoryItem); virtual;
    procedure DrawItemBackground(ItemRect: TRect; Item: TNxToolBoxItem); virtual;
    procedure DrawItem(ItemRect: TRect; Item: TNxToolBoxItem); virtual;
    procedure Expand(Item: TNxToolBoxItem; Collapse: Boolean = False);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notify(Item: TNxToolBoxItem = nil); virtual;
    procedure Paint; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetItemAtPos(X, Y: Integer): TNxToolBoxItem;
    function GetItemRect(Item: TNxToolBoxItem): TRect;
    procedure RefreshItem(Item: TNxToolBoxItem);
    property SelectedItem: TNxToolBoxItem read FSelectedItem write SetSelectedItem;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Canvas;
    property Categories: TNxToolBoxCategories read FCategories write SetCategories;
    property CategoriesStyle: TNxCategoriesStyle read FCategoriesStyle write SetCategoriesStyle;
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
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 20;
    property ParentBiDiMode;
    property ParentColor default False;
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
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnSelectItem: TNotifyEvent read FOnSelectItem write FOnSelectItem;
    property OnStartDrag;
  end;

  TNxOutlookBarItems = class;

  TNxOutlookBarItem = class(TCollectionItem)
  private
    FVisible: Boolean;
    FCaption: WideString;
    FImageIndex: TImageIndex;
    FItems: TNxOutlookBarItems;
    FObjectReference: TObject;
    FColor: TColor;
    procedure SetCaption(const Value: WideString);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetVisible(const Value: Boolean);
    procedure SetObjectReference(const Value: TObject);
    procedure SetColor(const Value: TColor);
  public               
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Items: TNxOutlookBarItems read FItems;
    property ObjectReference: TObject read FObjectReference write SetObjectReference;
  published
    property Caption: WideString read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TNxOutlookBarItems = class(TCollection)
  private
    FOwner: TNxOutlookBar;
    FVisibleCount: Integer;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TNxOutlookBar);
    function Add: TNxOutlookBarItem;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
    property VisibleCount: Integer read FVisibleCount;
  end;

  TItemDrawStyle = set of (dsDown, dsHover, dsSelected);
  TItemOrientation = (irVertical, irHorizontal);
  TDrawingOptions = (doBackgroundOnly, doNormal, doCustom, doCustomOnly);
  TCustomDrawItemEvent = procedure (Sender: TObject; Item: TNxOutlookBarItem; ItemRect: TRect;
    DrawStyle: TItemDrawStyle) of object;
  TOutlookBarOptions = set of (boOptionsMenu);
  TOutlookBarStyle = (osOffice2007, osWindowsLive);

  TNxOutlookBar = class(TCustomControl)
  private
    FAdaptiveColors: Boolean;
    FBottomPoint: TPoint;
    FButtonsHeight: Integer;
    FColorScheme: TColorScheme;
    FCursor: TCursor;
    FDisplayCount: Integer;
    FDownItem: TNxOutlookBarItem;
    FDrawingOptions: TDrawingOptions;
    FHoverItem: TNxOutlookBarItem;
    FInnerMargins: TNxMargins;
    FItemHeight: Integer;
    FItemIndex: Integer;
    FItems: TNxOutlookBarItems;
    FLargeImages: TImageList;
    FOnChange: TNotifyEvent;
    FOnCustomDrawItem: TCustomDrawItemEvent;
    FOnSelect: TNotifyEvent;
    FOptions: TOutlookBarOptions;
    FSelected: TNxOutlookBarItem;
    FSizing: Boolean;
    FSizingPoint: TPoint;
    FSmallImages: TImageList;
    FSplitterHeight: Integer;
    FStyle: TOutlookBarStyle;
    FTextIndent: Integer;
    FToolbarHeight: Integer;
    function GetButtonsHeight: Integer;
    function GetButtonsTop: Integer;
    function GetItem(const Index: Integer): TNxOutlookBarItem;
    procedure SetAdaptiveColors(const Value: Boolean);
    procedure SetColorScheme(const Value: TColorScheme);
    procedure SetDisplayCount(const Value: Integer);
    procedure SetDownItem(const Value: TNxOutlookBarItem);
    procedure SetDrawingOptions(const Value: TDrawingOptions);
    procedure SetHoverItem(const Value: TNxOutlookBarItem);
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetItemHeight(const Value: Integer);
    procedure SetItemIndex(const Value: Integer);
    procedure SetItems(const Value: TNxOutlookBarItems);
    procedure SetLargeImages(const Value: TImageList);
    procedure SetOptions(const Value: TOutlookBarOptions);
    procedure SetSelected(const Value: TNxOutlookBarItem);
    procedure SetSmallImages(const Value: TImageList);
    procedure SetSplitterHeight(const Value: Integer);
    procedure SetStyle(const Value: TOutlookBarStyle);
    procedure SetTextIndent(const Value: Integer);
    procedure SetToolbarHeight(const Value: Integer);
  protected
    function CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
    function GetButtonWidth: Integer; virtual;
    procedure CreateWnd; override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure DoChange; dynamic;
    procedure DoMarginsChange(Sender: TObject);
    procedure DoCustomDrawItem(Item: TNxOutlookBarItem; ItemRect: TRect;
      DrawStyle: TItemDrawStyle); dynamic;
    procedure DoSelect; dynamic;
    procedure DrawItem(Item: TNxOutlookBarItem; ItemRect: TRect;
      Orient: TItemOrientation);
    procedure DrawItemFill(ItemColor: TColor; const ItemRect: TRect;
      DrawStyle: TItemDrawStyle; Orientation: TItemOrientation); virtual;
    procedure DrawItemData(const ItemRect: TRect; Item: TNxOutlookBarItem;
      DrawStyle: TItemDrawStyle; Orientation: TItemOrientation); virtual;
    procedure DrawSplitter(const SplitterRect: TRect); virtual;
    procedure DrawToolbar(const ToolbarRect: TRect); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure ScrollItems(const Value: Integer);
    procedure SetSchemeColors(DrawStyle: TItemDrawStyle; ColorScheme: TColorScheme;
      var ForeColor: TColor; var BackColor: TColor); virtual;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure UpdateButtonsHeight;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetItemAtPos(const X, Y: Integer): TNxOutlookBarItem;
    function GetItemRect(const Item: TNxOutlookBarItem): TRect;
    function GetSplitterRect: TRect;
    procedure RefreshItem(const Item: TNxOutlookBarItem);
    procedure RefreshHorzItems;
    procedure UpdateBottomPoint;
    procedure UpdateHeight;
    property Item[const Index: Integer]: TNxOutlookBarItem read GetItem; default;
    property Selected: TNxOutlookBarItem read FSelected write SetSelected;
  published
    property AdaptiveColors: Boolean read FAdaptiveColors write SetAdaptiveColors default True;
    property Align;
    property Anchors;
    property BiDiMode;
    property Canvas;
    property Color;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csDefault;
    property Constraints;
    property Ctl3D;
    property DisplayCount: Integer read FDisplayCount write SetDisplayCount default 0;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DrawingOptions: TDrawingOptions read FDrawingOptions write SetDrawingOptions default doNormal;
    property Enabled;
    property Font;
    property Hint;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 31;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default 0;
    property Items: TNxOutlookBarItems read FItems write SetItems;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property Options: TOutlookBarOptions read FOptions write SetOptions default [boOptionsMenu];
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property PopupMenu;
    property ShowHint;
    property SmallImages: TImageList read FSmallImages write SetSmallImages;
    property SplitterHeight: Integer read FSplitterHeight write SetSplitterHeight default 9;
    property Style: TOutlookBarStyle read FStyle write SetStyle default osOffice2007;
    property TabOrder;
    property TabStop;
    property TextIndent: Integer read FTextIndent write SetTextIndent default spTextDistance;
    property ToolbarHeight: Integer read FToolbarHeight write SetToolbarHeight default 30;
    property Visible;
    property Width default 185;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
    property OnStartDrag;
  end;

implementation

uses NxSharedDraw, Dialogs, SysUtils, Windows, Math, Forms;

{ TNxToolBox }

constructor TNxToolBox.Create(AOwner: TComponent);
begin
  inherited;
  FCategories := TNxToolBoxCategories.Create(Self);
  FCollapseGlyph := Graphics.TBitmap.Create;
  FCollapseGlyph.LoadFromResourceName(HInstance, 'BUTTONCOLLAPSE');
  FCollapseGlyph.Transparent := True;
  FCollapseGlyph.TransparentColor := FCollapseGlyph.Canvas.Pixels[0, FCollapseGlyph.Height - 1];
  FExpandGlyph := Graphics.TBitmap.Create;
  FExpandGlyph.LoadFromResourceName(HInstance, 'BUTTONEXPAND');
  FExpandGlyph.Transparent := True;
  FExpandGlyph.TransparentColor := FExpandGlyph.Canvas.Pixels[0, FExpandGlyph.Height - 1];
  FDownItem := nil;
  FItemHeight := 20;
  FHoverItem := nil;
  ScrollStyle := [];
  Width := 185;
  Height := 250;
end;

procedure TNxToolBox.CreateWnd;
begin
  inherited;
  HorzScrollBar.Visible := False;
  VertScrollBar.Visible := False;
end;

destructor TNxToolBox.Destroy;
begin
  FreeAndNil(FCollapseGlyph);
  FreeAndNil(FExpandGlyph);
  FCategories.Clear;
  FCategories.Free;
  inherited;
end;

procedure TNxToolBox.DoSelectItem;
begin
  if Assigned(FOnSelectItem) then FOnSelectItem(Self);
end;

procedure TNxToolBox.DrawBackground;
begin
  DrawHorzGradient(Canvas, ClientRect, Color, BlendColor(clGrayText, Color, 20));
end;

procedure TNxToolBox.DrawCategoryBackground(ItemRect: TRect);
begin
  with Canvas do
  begin
    case FCategoriesStyle of
      casDefault:
        begin
          DrawVertGradient(Canvas, Rect(0, ItemRect.Top + 1, ClientWidth, ItemRect.Bottom - 2),
          clInactiveBorder, clGrayText);
          Pen.Color := clInactiveBorder;
          MoveTo(0, ItemRect.Bottom - 1);
          LineTo(ClientWidth, ItemRect.Bottom - 1);
        end;
      casBottomLine:
        begin
          Pen.Color := clInactiveBorder;
          MoveTo(0, ItemRect.Bottom - 1);
          LineTo(ClientWidth, ItemRect.Bottom - 1);
        end;
    end;
  end;
end;

procedure TNxToolBox.DrawCategoryItem(ItemRect: TRect; Item: TNxToolBoxCategoryItem);
const
  Distance = 21;
  ChbDist = 5;
var
  ti, Y, ImageY: Integer;
  br: TRect;
begin
  with Canvas do
  begin
    DrawCategoryBackground(ItemRect);
    if IsThemed then
    begin
      br := Rect(ChbDist, ItemRect.Top, ChbDist + 9, ItemRect.Bottom);
      if Item.Expanded then ti := tiExpanded else ti := tiCollapsed;
      ThemeRect(Self.Handle, Canvas.Handle, br, teTreeView, tcExpandingButton, ti);
    end else
    begin
      Y := ItemRect.Top + (ItemRect.Bottom - ItemRect.Top) div 2 - 9 div 2;
      if Item.Expanded then Canvas.Draw(ChbDist, Y, FCollapseGlyph)
        else Canvas.Draw(ChbDist, Y, FExpandGlyph);
    end;
    Font.Style := [fsBold];
    DrawTextRect(Canvas, Rect(Distance, ItemRect.Top, ItemRect.Right, ItemRect.Bottom), Item.Caption);
    if Assigned(FImages) and (Item.ImageIndex > -1) then
    begin
      ImageY := ItemRect.Top + (ItemRect.Bottom - ItemRect.Top) div 2 - FImages.Height div 2;
      FImages.Draw(Canvas, ClientWidth - 2 - FImages.Width, ImageY, Item.ImageIndex);
    end;
  end;
end;

procedure TNxToolBox.DrawItemBackground(ItemRect: TRect; Item: TNxToolBoxItem);
const
  Distance = 28;
begin
  with Canvas do
  begin
    Pen.Color := clHighlight;
    if Item = FSelectedItem then
    begin
      if Item = FDownItem then Brush.Color := BlendColor(clHighlight, clWindow, 40)
      else if Item = FHoverItem then Brush.Color := BlendColor(clHighlight, clWindow, 100)
      else Brush.Color := BlendColor(clHighlight, clWindow, 40);
      Rectangle(ItemRect);
    end else
    begin
      if Item = FHoverItem then
      begin
        Brush.Color := BlendColor(clHighlight, clWindow, 70);
        Rectangle(ItemRect);
      end
    end;
  end;
end;

procedure TNxToolBox.DrawItem(ItemRect: TRect; Item: TNxToolBoxItem);
const
  Distance = 28;
begin
  with Canvas do
  begin
    DrawItemBackground(Rect(3, ItemRect.Top, ItemRect.Right - 1, ItemRect.Bottom), Item);
    Font.Style := [];
    DrawTextRect(Canvas, Rect(Distance, ItemRect.Top, ItemRect.Right, ItemRect.Bottom), Item.Caption);
    if (Images <> nil) and (Item.ImageIndex > -1)
      and (Item.ImageIndex < Images.Count) then
    begin
      Images.Draw(Canvas, 6, ItemRect.Top + (ItemRect.Bottom - ItemRect.Top) div 2 - Images.Height div 2, Item.ImageIndex);
    end;
  end;
end;

function TNxToolBox.GetItemAtPos(X, Y: Integer): TNxToolBoxItem;
var
  i, j, Pos: Integer;
begin
  Pos := -VertScrollBar.Position;
  Result := nil;
  for i := 0 to Categories.Count - 1 do
  begin
    with Categories.Items[i] as TNxToolBoxCategoryItem do
    begin
      if (Y >= Pos) and (Y <= Pos + 17) then
      begin
        Result := TNxToolBoxCategoryItem(Categories.Items[i]);
        Exit;
      end;

      Inc(Pos, 17);
      if Expanded then
        for j := 0 to Items.Count - 1 do
          if (Y >= Pos) and (Y <= Pos + ItemHeight) then
          begin
            Result := TNxToolBoxItem(Items.Items[j]);
            Exit;
          end else Inc(Pos, ItemHeight);
    end;
  end;
end;

function TNxToolBox.GetVertScrollMax: Integer;
var
  i, j, c: Integer;
begin
  c := 0;
  for i := 0 to Categories.Count - 1 do
  begin
    Inc(c, 17);
    if TNxToolBoxCategoryItem(Categories.Items[i]).Expanded then
      for j := 0 to TNxToolBoxCategoryItem(Categories.Items[i]).Items.Count - 1 do
      begin
        Inc(c, ItemHeight);
      end;
  end;
  Result := c - ClientHeight;
end;

function TNxToolBox.GetVertOffset(FromPos, ToPos: Integer): Integer;
begin
  Result := 0;
  case VertScrollBar.ScrollKind of
    rkThumb, rkPage, rkTopBottom: Result := FromPos - ToPos;
    rkLine: Result := FromPos - ToPos;
  end;
end;

procedure TNxToolBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not Focused then SetFocus;
  if Button = mbLeft then
  begin
    FDownItem := GetItemAtPos(X, Y);
    if FDownItem is TNxToolBoxCategoryItem then
    begin
      TNxToolBoxCategoryItem(FDownItem).Expanded := not TNxToolBoxCategoryItem(FDownItem).Expanded;
    end else
    begin
      SelectedItem := FDownItem;
      if Assigned(FDownItem) then RefreshItem(FDownItem);
    end;
  end;
end;

procedure TNxToolBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AItem: TNxToolBoxItem;
begin
  inherited;
  AItem := GetItemAtPos(X, Y);
  if (FDownItem = nil) and (AItem <> FHoverItem) then
  begin
    if (Assigned(FHoverItem)) and (not(FHoverItem is TNxToolBoxCategoryItem)) then RefreshItem(FHoverItem);
    FHoverItem := AItem;
    if (Assigned(FHoverItem)) and (not(FHoverItem is TNxToolBoxCategoryItem)) then RefreshItem(FHoverItem);
  end;
end;

procedure TNxToolBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AItm: TNxToolBoxItem;
begin
  inherited;
  AItm := FDownItem;
  FDownItem := nil;
  if Assigned(AItm) then RefreshItem(AItm);
end;

procedure TNxToolBox.Notify(Item: TNxToolBoxItem);
begin
  VertScrollBar.Max := GetVertScrollMax;
  VertScrollBar.Visible := VertScrollBar.Max > 0;
  Refresh;
end;

procedure TNxToolBox.Paint;
var
  i, j, Y: Integer;
  R: TRect;
  ACategoryItem: TNxToolBoxCategoryItem;
  AItem: TNxToolBoxItem;
begin
  inherited;
  VertScrollClipRect := ClientRect;
  DrawBackground;
  Y := 0 - VertScrollBar.Position;
  Canvas.Font.Assign(Font);
  for i := 0 to Categories.Count - 1 do
  begin
    ACategoryItem := TNxToolBoxCategoryItem(Categories.Items[i]);
    R := Rect(0, Y, ClientWidth, Y + 17);
    DrawCategoryItem(R, ACategoryItem);
    Inc(Y, 17);
    if ACategoryItem.Expanded then
    begin
      for j := 0 to ACategoryItem.Items.Count - 1 do
      begin
        AItem := TNxToolBoxItem(ACategoryItem.Items.Items[j]);
        R := Rect(0, Y, ClientWidth, Y + ItemHeight);
        DrawItem(R, AItem);
        Inc(Y, ItemHeight);
      end;
    end;
  end;
  VertScrollBar.Max := GetVertScrollMax;
  VertScrollBar.Visible := VertScrollBar.Max > 0;
end;

procedure TNxToolBox.SetCategories(const Value: TNxToolBoxCategories);
begin
  FCategories.Assign(Value);
end;

procedure TNxToolBox.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure TNxToolBox.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
  VertScrollBar.SmallChange := ItemHeight;
end;

procedure TNxToolBox.SetSelectedItem(const Value: TNxToolBoxItem);
var
  FOldItm: TNxToolBoxItem;
begin
  FOldItm := FSelectedItem;
  if FOldItm <> Value then
  begin
    FSelectedItem := Value;
    if Assigned(FSelectedItem) then RefreshItem(FSelectedItem);
    if Assigned(FOldItm) then RefreshItem(FOldItm);
  end;
  DoSelectItem;
end;

function TNxToolBox.GetVisibleCount: Integer;
begin
  Result := 0;
end;

function TNxToolBox.GetItemRect(Item: TNxToolBoxItem): TRect;
var
  i, j, Pos: Integer;
  ACatItem: TNxToolBoxCategoryItem;
  AItem: TNxToolBoxItem;
begin
  Pos := - VertScrollBar.Position;
  for i := 0 to Categories.Count - 1 do
  begin
    ACatItem := TNxToolBoxCategoryItem(Categories.Items[i]);
    if ACatItem = Item then
    begin
      Result := Rect(3, Pos, ClientWidth - 1, Pos + 17);
      Exit;
    end;
    Inc(Pos, 17);
    if ACatItem.Expanded then
      for j := 0 to ACatItem.Items.Count - 1 do
      begin
        AItem := TNxToolBoxItem(ACatItem.Items.Items[j]);
        if AItem = Item then
        begin
          Result := Rect(3, Pos, ClientWidth - 1, Pos + ItemHeight);
          Exit;
        end;
        Inc(Pos, ItemHeight);
      end;
  end;
end;

procedure TNxToolBox.RefreshItem(Item: TNxToolBoxItem);
var
  r: TRect;
begin
  r := GetItemRect(Item);
  InvalidateRect(Handle, @r, False);
end;

procedure TNxToolBox.CMMouseLeave(var Message: TMessage);
var
  AItm: TNxToolBoxItem;
begin
  AItm := FHoverItem;
  FHoverItem := nil;
  if Assigned(AItm) then RefreshItem(AItm);
end;

function TNxToolBox.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
	inherited DoMouseWheelDown(Shift, MousePos);
  VertScrollBar.Next;
  Result := True;
end;

function TNxToolBox.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  inherited DoMouseWheelUp(Shift, MousePos);
  VertScrollBar.Prior;
  Result := True;
end;

procedure TNxToolBox.Expand(Item: TNxToolBoxItem; Collapse: Boolean);
var
  ClpRect, RepaintRect: TRect;
  Delta: Integer;
begin
  ClpRect := ClientRect;
  RepaintRect.Left := 0;
  RepaintRect.Top := GetItemRect(Item).Bottom;
  RepaintRect.Bottom := ClientHeight;
  RepaintRect.Right := ClientWidth;
  Delta := TNxToolBoxCategoryItem(Item).Items.Count * ItemHeight;
  if Collapse then
  begin
    Delta := -Delta;
  end;
  ScrollWindowEx(Handle, 0, Delta, nil, @RepaintRect, 0, @ClpRect, SW_INVALIDATE);
end;

procedure TNxToolBox.SetCategoriesStyle(const Value: TNxCategoriesStyle);
begin
  FCategoriesStyle := Value;
  Invalidate;
end;

{ TNxToolBoxItem }

constructor TNxToolBoxItem.Create(Collection: TCollection);
begin
  inherited;
  FCaption := '';
  FImageIndex := -1;
  if Collection is TNxToolBoxItems then FCategory := TNxToolBoxItems(Collection).FOwner
    else FCategory := nil;
  FTag := 0;
end;

destructor TNxToolBoxItem.Destroy;
begin

  inherited;
end;

procedure TNxToolBoxItem.Refresh;
begin
  if Assigned(FCategory) then FCategory.FCategories.FOwner.RefreshItem(Self);
end;

procedure TNxToolBoxItem.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  Refresh;
end;

procedure TNxToolBoxItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Refresh;
end;

{ TNxToolBoxItems }

constructor TNxToolBoxItems.Create(AOwner: TNxToolBoxCategoryItem);
begin
  inherited Create(TNxToolBoxItem);
  FOwner := AOwner;
end;

function TNxToolBoxItems.Add: TNxToolBoxItem;
begin
  Result := TNxToolBoxItem(inherited Add);
  FOwner.FCategories.FOwner.Notify(Result);
end;

function TNxToolBoxItems.GetOwner: TPersistent;
begin
  Result := FOwner;  
end;

procedure TNxToolBoxItems.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  FOwner.FCategories.FOwner.Invalidate;
end;

{ TNxToolBoxCategoryItem }

constructor TNxToolBoxCategoryItem.Create(Collection: TCollection);
begin
  inherited;
  FCaption := '';
  FCategories := TNxToolBoxCategories(Collection);
  FExpanded := True;
  FItems := TNxToolBoxItems.Create(Self);
end;

destructor TNxToolBoxCategoryItem.Destroy;
begin
  FItems.Clear;
  FItems.Free;
  inherited;
end;

procedure TNxToolBoxCategoryItem.Refresh;
begin
  FCategories.FOwner.RefreshItem(Self);
end;

procedure TNxToolBoxCategoryItem.SetExpanded(const Value: Boolean);
begin
  if Value <> FExpanded then
  begin
    FExpanded := Value;
    FCategories.FOwner.Expand(Self, not Value);
  end;
end;

procedure TNxToolBoxCategoryItem.SetItems(const Value: TNxToolBoxItems);
begin
  FItems.Assign(Value);
end;

{ TNxToolBoxCategories }

constructor TNxToolBoxCategories.Create(AOwner: TNxToolBox);
begin
  inherited Create(TNxToolBoxCategoryItem);
  FOwner := AOwner;
end;

function TNxToolBoxCategories.Add: TNxToolBoxCategoryItem;
begin
  Result := TNxToolBoxCategoryItem(inherited Add);
  FOwner.Notify(Result);
end;

function TNxToolBoxCategories.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TNxToolBoxCategories.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  FOwner.Invalidate;
end;

{ TNxOutlookBar }

constructor TNxOutlookBar.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks, csReplicatable];
  FAdaptiveColors := True;
  FColorScheme := csDefault;
//  FDisplayCount := 0;
  FDownItem := nil;
  FDrawingOptions := doNormal;
  FHoverItem := nil;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.OnChange := DoMarginsChange;
  FItemHeight := 31;
  FItemIndex := 0;
  FItems := TNxOutlookBarItems.Create(Self);
  FOptions := [boOptionsMenu];
  FSizing := False;
  FSplitterHeight := 9;
  FTextIndent := spTextDistance;
  FToolbarHeight := 30;
  ParentColor := False;
  Color := clWindow;
  Height := 265;
  Width := 185;
  SchemeNotification(Self);
end;

destructor TNxOutlookBar.Destroy;
begin
  RemoveSchemeNotification(Self);
  FInnerMargins.Free;
  FItems.Free;
  inherited;
end;

procedure TNxOutlookBar.CreateWnd;
begin
  UpdateButtonsHeight; { Set height, then re-align }
  inherited;
end;

procedure TNxOutlookBar.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  Inc(Rect.Left, FInnerMargins.Left);
  Inc(Rect.Top, FInnerMargins.Top);
  Dec(Rect.Right, FInnerMargins.Right);
  Dec(Rect.Bottom, FInnerMargins.Bottom + FButtonsHeight);
end;

function TNxOutlookBar.GetButtonsHeight: Integer;
var
  ACount: Integer;
begin
  Result := FToolbarHeight;
  ACount := FDisplayCount;
  if ACount > FItems.VisibleCount then ACount := FItems.VisibleCount;
  Inc(Result, FSplitterHeight);
  Inc(Result, ACount * Succ(FItemHeight));
end;

function TNxOutlookBar.GetButtonsTop: Integer;
begin
  Result := ClientHeight - FButtonsHeight;
end;

function TNxOutlookBar.GetItem(const Index: Integer): TNxOutlookBarItem;
begin
  Result := TNxOutlookBarItem(FItems.Items[Index]);
end;

procedure TNxOutlookBar.SetLargeImages(const Value: TImageList);
begin
  FLargeImages := Value;
  if Assigned(FLargeImages) then FLargeImages.FreeNotification(Self);
  Invalidate;
end;

procedure TNxOutlookBar.SetDownItem(const Value: TNxOutlookBarItem);
var
  FOldDown: TNxOutlookBarItem;
begin
  if Value <> FDownItem then
  begin
    FOldDown := FDownItem;
    FDownItem := Value;
    if FOldDown <> nil then RefreshItem(FOldDown);
    if FDownItem <> nil then RefreshItem(FDownItem);
  end;
end;

procedure TNxOutlookBar.SetDrawingOptions(const Value: TDrawingOptions);
begin
  FDrawingOptions := Value;
  Invalidate;
end;

procedure TNxOutlookBar.SetHoverItem(const Value: TNxOutlookBarItem);
var
  FOldHover: TNxOutlookBarItem;
begin
  if Value <> FHoverItem then
  begin
    FOldHover := FHoverItem;
    FHoverItem := Value;
    if FOldHover <> nil then RefreshItem(FOldHover);
    if FHoverItem <> nil then RefreshItem(FHoverItem);
  end;
end;

procedure TNxOutlookBar.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins := Value;
end;

procedure TNxOutlookBar.SetAdaptiveColors(const Value: Boolean);
begin
  FAdaptiveColors := Value;
  Invalidate;
end;

procedure TNxOutlookBar.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
  Invalidate;
end;

procedure TNxOutlookBar.SetDisplayCount(const Value: Integer);
begin
  if Value <> FDisplayCount then
  begin
    FDisplayCount := Value;
    FButtonsHeight := GetButtonsHeight;
    Realign;
    Invalidate;
    DoChange; { event }
  end;
end;

procedure TNxOutlookBar.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
  FButtonsHeight := GetButtonsHeight;
  Realign;
  Invalidate;
end;

procedure TNxOutlookBar.SetItemIndex(const Value: Integer);
var
  FOldSelected: TNxOutlookBarItem;
begin
  FOldSelected := Selected;
  FItemIndex := Value;
  if InRange(Value, 0, FItems.Count - 1) then
    SetSelected(FItems.Items[FItemIndex] as TNxOutlookBarItem)
  else
    SetSelected(nil);
  if Assigned(Selected) then RefreshItem(Selected);
  if Assigned(FOldSelected) then RefreshItem(FOldSelected);
end;

procedure TNxOutlookBar.SetItems(const Value: TNxOutlookBarItems);
begin
  FItems := Value;
end;

procedure TNxOutlookBar.SetSelected(const Value: TNxOutlookBarItem);
var
  FOldSelected: TNxOutlookBarItem;
begin
  if Value <> FSelected then
  begin
    FOldSelected := FSelected;
    FSelected := Value;
    if FOldSelected <> nil then RefreshItem(FOldSelected);
    if FSelected <> nil then RefreshItem(FSelected);
    if FSelected <> nil then
      FItemIndex := FSelected.Index
    else
      FItemIndex := -1;
    DoSelect; { event }
  end;
end;

procedure TNxOutlookBar.SetSmallImages(const Value: TImageList);
begin
  FSmallImages := Value;
  if Assigned(FSmallImages) then FSmallImages.FreeNotification(Self);
  Invalidate;
end;

procedure TNxOutlookBar.SetSplitterHeight(const Value: Integer);
begin
  FSplitterHeight := Value;
//  UpdateHeight;
  Invalidate;
end;

procedure TNxOutlookBar.SetTextIndent(const Value: Integer);
begin
  FTextIndent := Value;
  Invalidate;
end;

procedure TNxOutlookBar.SetToolbarHeight(const Value: Integer);
begin
  if (Value <> FToolbarHeight) and (Value >= 0) then
  begin
    FToolbarHeight := Value;
    UpdateHeight;
    Invalidate;
  end;
end;

function TNxOutlookBar.CanResize(var NewWidth,
  NewHeight: Integer): Boolean;
begin
  Result := inherited CanResize(NewWidth, NewHeight);
end;

function TNxOutlookBar.GetButtonWidth: Integer;
begin
  if Assigned(FSmallImages) then Result := FSmallImages.Width + 6
    else Result := 22;
end;

procedure TNxOutlookBar.DoMarginsChange(Sender: TObject);
begin
  Realign;
  Invalidate;
end;

procedure TNxOutlookBar.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxOutlookBar.DoCustomDrawItem(Item: TNxOutlookBarItem;
  ItemRect: TRect; DrawStyle: TItemDrawStyle);
begin
  if Assigned(FOnCustomDrawItem) then FOnCustomDrawItem(Self, Item, ItemRect, DrawStyle);
end;

procedure TNxOutlookBar.DoSelect;
begin
  if Assigned(FOnSelect) then FOnSelect(Self);
end;

procedure TNxOutlookBar.DrawItem(Item: TNxOutlookBarItem; ItemRect: TRect;
  Orient: TItemOrientation);
var
  DrawStyle: TItemDrawStyle;
begin
  DrawStyle := [];
  if Item = FSelected then Include(DrawStyle, dsSelected);
  if Item = FDownItem then Include(DrawStyle, dsDown);
  if Item = FHoverItem then Include(DrawStyle, dsHover);

  if FDrawingOptions <> doCustomOnly
    then DrawItemFill(Item.Color, ItemRect, DrawStyle, Orient);
  if (FDrawingOptions <> doBackgroundOnly) and (FDrawingOptions <> doCustomOnly)
    then DrawItemData(ItemRect, Item, DrawStyle, Orient);

  DoCustomDrawItem(Item, ItemRect, DrawStyle); { event }
end;

procedure TNxOutlookBar.DrawItemFill(ItemColor: TColor; const ItemRect: TRect;
  DrawStyle: TItemDrawStyle; Orientation: TItemOrientation);
var
  ForeColor, BackColor: TColor;
begin
  SetSchemeColors(DrawStyle, FColorScheme, ForeColor, BackColor);
  if not AdaptiveColors then ForeColor := ItemColor;
  if (Orientation = irVertical) or (DrawStyle <> []) then
  begin
    case FStyle of
      osOffice2007: DrawVertGlass(Canvas, ItemRect, ForeColor, BackColor, 12);
      osWindowsLive: DrawVertShine(Canvas, ItemRect, ForeColor, BackColor, 12);
    end;
  end;
end;

procedure TNxOutlookBar.DrawItemData(const ItemRect: TRect;
  Item: TNxOutlookBarItem; DrawStyle: TItemDrawStyle;
  Orientation: TItemOrientation);
var
  ImgX, ImgY: Integer;
  TxtRect: TRect;
  DrawIcon: Boolean;
begin
  with Canvas, Item do
  begin
    case Orientation of
      irVertical:
      begin
        DrawIcon := (Assigned(FLargeImages)) and (Item.ImageIndex > -1)
          and (Item.ImageIndex < FLargeImages.Count);
        if DrawIcon then
        begin
          ImgX := spOutBarGlyphIndent;
          ImgY := ItemRect.Top + (ItemRect.Bottom - ItemRect.Top) div 2 - FLargeImages.Height div 2;
          FLargeImages.Draw(Canvas, ImgX, ImgY, Item.ImageIndex);
        end;
        TxtRect := ItemRect;
        TxtRect.Left := FTextIndent;

        if IsThemed then Font.Color := clWindowText else
        begin
          if (dsHover in DrawStyle) and ((dsSelected in DrawStyle) or (dsDown in DrawStyle))
            then Font.Color := clHighlightText else Font.Color := clWindowText;
        end;
        if ClientWidth > ItemHeight then
        begin
          Font.Style := [fsBold];
          DrawTextRect(Canvas, TxtRect, Item.Caption);
        end;
      end;
      
      irHorizontal:
      begin
        DrawIcon := (Assigned(FSmallImages)) and (Item.ImageIndex > -1)
          and (Item.ImageIndex < FSmallImages.Count);
        if DrawIcon then
        begin
          ImgX := ItemRect.Left + (ItemRect.Right - ItemRect.Left) div 2 - FSmallImages.Width div 2;
          ImgY := ItemRect.Top + (ItemRect.Bottom - ItemRect.Top) div 2 - FSmallImages.Height div 2;
          FSmallImages.Draw(Canvas, ImgX, ImgY, ImageIndex);
        end;
      end;
    end;
  end;
end;

procedure TNxOutlookBar.DrawSplitter(const SplitterRect: TRect);
var
  FromColor, ToColor: TColor;
  GradientRect: TRect;
begin
 	with Canvas do
  begin
    FromColor := SchemeColor(seSplitterGradientStart, FColorScheme);
    ToColor := SchemeColor(seSplitterGradientEnd, FColorScheme);

    Pen.Color := clWhite;
    Polyline([Point(0, SplitterRect.Top + 1), Point(ClientWidth, SplitterRect.Top + 1)]);

    Pen.Color := SchemeColor(seBorder, FColorScheme);
    Polyline([Point(0, SplitterRect.Top), Point(ClientWidth, SplitterRect.Top)]);
    Polyline([Point(0, SplitterRect.Bottom - 1), Point(ClientWidth, SplitterRect.Bottom - 1)]);

    GradientRect := SplitterRect;
    InflateRect(GradientRect, 0, -1);
    Inc(GradientRect.Top);
    DrawVertGradient(Canvas, GradientRect, FromColor, ToColor);

    DrawGrips(Canvas, SplitterRect, 5, orHorizontal, FColorScheme);
  end;
end;

procedure TNxOutlookBar.DrawToolbar(const ToolbarRect: TRect);
begin
  DrawItemFill(clBtnFace, ToolbarRect, [], irVertical);
end;

procedure TNxOutlookBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  AItem: TNxOutlookBarItem;
begin
  inherited;
  if not Focused then SetFocus;
  if Button = mbLeft then
  begin
    AItem := GetItemAtPos(X, Y);
    if Assigned(AItem) then SetDownItem(AItem);
    FSizing := PtInRect(GetSplitterRect, Point(X, Y));
    if FSizing then FSizingPoint := Point(X, Y);
  end;
end;

procedure TNxOutlookBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Distance, Count: Integer;
  RoundMode: TFPURoundingMode;
begin
  inherited;
  if Y > GetButtonsTop then
  begin
    if PtInRect(GetSplitterRect, Point(X, Y)) or FSizing then Cursor := crSizeNS
      else Cursor := crHandPoint;
  end else Cursor := crDefault;

  if FSizing then
  begin
    Distance := ClientHeight - Y;
    Dec(Distance, FToolbarHeight + FSplitterHeight);

    RoundMode := GetRoundMode;
    SetRoundMode(rmUp);
    { how many items may be shown max }
    Count := Round(Distance / Succ(FItemHeight));
    if Count > FItems.VisibleCount then Count := FItems.VisibleCount;
    SetRoundMode(RoundMode);

    if (Count <> FDisplayCount) and InRange(Count, 0, Items.Count) then
    begin
      FButtonsHeight := (Count * Succ(FItemHeight)) + FToolbarHeight + FSplitterHeight;
      ScrollItems(FDisplayCount - Count);
      FDisplayCount := Count;
      RefreshHorzItems;
      Realign;
    end;
  end else SetHoverItem(GetItemAtPos(X, Y));
end;

procedure TNxOutlookBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Item: TNxOutlookBarItem;
begin
  inherited;
  if not FSizing then
  begin
    if Button = mbLeft then
    begin
      Item := GetItemAtPos(X, Y);
      if Assigned(Item) then Selected := GetItemAtPos(X, Y);
      SetDownItem(nil);
    end;
  end else FSizing := False;
end;

procedure TNxOutlookBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FLargeImages then FLargeImages := nil;
    if AComponent = FSmallImages then FSmallImages := nil;
  end;
end;

procedure TNxOutlookBar.Paint;
var
  I, J, Pos: Integer;
  ItemRect, MarginsRect: TRect;
begin
  inherited;
  Canvas.Brush.Color := Self.Color;
  Canvas.FillRect(Rect(0, 0, ClientWidth, GetButtonsTop));

  Pos := Height - FButtonsHeight;

  DrawSplitter(Rect(0, Pos, ClientWidth, Pos + FSplitterHeight));
  Inc(Pos, FSplitterHeight);

  Canvas.Font.Assign(Font);

  DrawToolbar(Rect(0, ClientHeight - FToolbarHeight, ClientWidth, ClientHeight));

  if csDesigning in ComponentState then
  begin
    MarginsRect := Rect(FInnerMargins.Left, FInnerMargins.Top, ClientWidth - FInnerMargins.Right,
      ClientHeight - FButtonsHeight - FInnerMargins.Bottom);
    Canvas.Brush.Color := clBtnFace;
    Canvas.FrameRect(MarginsRect);
  end;

  I := 0;
  while (Pos < ClientHeight - FToolbarHeight) and (I < FItems.Count) do
  begin
    if (FItems.Items[I] as TNxOutlookBarItem).Visible then
    begin
      ItemRect := Rect(0, Pos, ClientWidth, Pos + FItemHeight);
      Inc(Pos, FItemHeight);
      case FColorScheme of
        csBlack: Canvas.Pen.Color := SchemeColor(seBorder, FColorScheme);
      end;
      Canvas.Pen.Color := SchemeColor(seBorder, FColorScheme);
      Canvas.Polyline([Point(0, Pos), Point(ClientWidth, Pos)]);
      DrawItem(Item[I], ItemRect, irVertical);
      Inc(Pos);
    end;
    Inc(I);
  end;
  if I = FItems.Count then Exit;

  Pos := ClientWidth;
  J := FItems.Count - 1;
  while (J >= I) do
  begin
    if (FItems.Items[J] as TNxOutlookBarItem).Visible then
    begin
      ItemRect := Rect(Pos - GetButtonWidth, ClientHeight - FToolbarHeight, Pos, ClientHeight);
      Dec(Pos, GetButtonWidth);
      DrawItem(Item[J], ItemRect, irHorizontal);
    end;
    Dec(J);
  end;
end;

procedure TNxOutlookBar.ScrollItems(const Value: Integer);
var
  RepaintRect, ClpRect: TRect;
  BtnTop, Delta: Integer;
begin
  Delta := Value * Succ(FItemHeight);
  BtnTop := GetButtonsTop;
  if Delta > 0 then Dec(BtnTop, Delta); 
  ClpRect := Rect(0, BtnTop, ClientWidth, ClientHeight - FToolbarHeight);
  RepaintRect := Rect(0, GetButtonsTop, ClientWidth, ClientHeight);
  ScrollWindowEx(Handle, 0, Delta, nil, @ClpRect, 0, @RepaintRect, SW_INVALIDATE);
end;

procedure TNxOutlookBar.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  SetHoverItem(nil);
end;

procedure TNxOutlookBar.UpdateButtonsHeight;
begin
  FButtonsHeight := GetButtonsHeight;
end;

procedure TNxOutlookBar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxOutlookBar.WMSetCursor(var Message: TWMSetCursor);
begin
  inherited;
  FCursor := Cursor;  
end;

procedure TNxOutlookBar.WMSize(var Message: TWMSize);
begin
  inherited;

end;

function TNxOutlookBar.GetItemAtPos(const X,
  Y: Integer): TNxOutlookBarItem;
var
  I, J, Pos: Integer;
begin
  Result := nil;
  Pos := GetButtonsTop + FSplitterHeight;

  { Vertical Items }
  I := 0;
  while (Pos < ClientHeight - FToolbarHeight) and (I < FItems.Count) do
  begin
    if (FItems.Items[I] as TNxOutlookBarItem).Visible then
    begin
      if (Y >= Pos) and (Y < Pos + FItemHeight) then
      begin
        Result := FItems.Items[I] as TNxOutlookBarItem;
        Exit;
      end;
      Inc(Pos, FItemHeight);
      Inc(Pos);
    end;
    Inc(I);
  end;
  if I = FItems.Count then Exit;

  { Horizontal Items }
  Pos := ClientWidth;
  J := FItems.Count-1;      
  while (J >= I) do
  begin
    if (FItems.Items[J] as TNxOutlookBarItem).Visible then
    begin
      if (Y > ClientHeight - FToolbarHeight) and (X < Pos) and (X >= Pos - GetButtonWidth) then
      begin
        Result := FItems.Items[J] as TNxOutlookBarItem;
        Exit;
      end;
      Dec(Pos, GetButtonWidth);
    end;
    Dec(J);
  end;
end;

function TNxOutlookBar.GetItemRect(const Item: TNxOutlookBarItem): TRect;
var
  I, J, Pos: Integer;
begin
  Pos := GetButtonsTop + FSplitterHeight;
  Result := Rect(0, 0, ClientWidth, 0);

  I := 0;
  while (Pos < ClientHeight - FToolbarHeight) and (I < FItems.Count) do
  begin
    if (FItems.Items[I] as TNxOutlookBarItem).Visible then
    begin
      if Item = FItems.Items[I] then
      begin
        Result := Rect(0, Pos, ClientWidth, Pos + FItemHeight);
        Exit;
      end;
      Inc(Pos, FItemHeight);
      Inc(Pos);
    end;
    Inc(I);
  end;
  if I = FItems.Count then Exit;

  Pos := ClientWidth;
  J := FItems.Count - 1;
  while (J >= I) do
  begin
    if (FItems.Items[J] as TNxOutlookBarItem).Visible then
    begin
      if Item = FItems.Items[J] then
      begin
        Result := Rect(Pos - GetButtonWidth, ClientHeight - FToolbarHeight, Pos + 1, ClientHeight);
        Exit;
      end;
      Dec(Pos, GetButtonWidth);
    end;
    Dec(J);
  end;
end;

function TNxOutlookBar.GetSplitterRect: TRect;
var
  FButtonsTop: Integer;
begin
  FButtonsTop := GetButtonsTop;
  Result := Rect(0, FButtonsTop, ClientWidth, FButtonsTop + FSplitterHeight);
end;

procedure TNxOutlookBar.RefreshHorzItems;
var
  R: TRect;
begin
  R := Rect(0, ClientHeight - FToolbarHeight, ClientWidth, ClientHeight);
  InvalidateRect(Handle, @R, False);
end;

procedure TNxOutlookBar.RefreshItem(const Item: TNxOutlookBarItem);
var
  R: TRect;
begin
  R := GetItemRect(Item);
  InvalidateRect(Handle, @R, False);
end;

procedure TNxOutlookBar.UpdateBottomPoint;
begin
  FBottomPoint := Point(ClientWidth, ClientHeight);
  FBottomPoint := ClientToScreen(FBottomPoint);
end;

procedure TNxOutlookBar.UpdateHeight;
begin
  if FDisplayCount > FItems.VisibleCount then FDisplayCount := FItems.VisibleCount;
  FButtonsHeight := GetButtonsHeight;
end;

procedure TNxOutlookBar.SetSchemeColors(DrawStyle: TItemDrawStyle; ColorScheme: TColorScheme;
  var ForeColor: TColor; var BackColor: TColor);
type
  TColorElement = (
    ceNormalStart, ceNormalEnd,
    ceHoverStart, ceHoverEnd,
    ceSelectedStart, ceSelectedEnd,
    cePressedStart, cePressedEnd);
begin
  if ColorScheme = csDefault then
    ColorScheme := NxThemesSupport.ColorScheme;

  if dsDown in DrawStyle then
  begin
    ForeColor := $001193EE;
    BackColor := $0065D3FF;
  end else if dsHover in DrawStyle then
  begin
    if dsSelected in DrawStyle then
    begin
      ForeColor := $001193DD;
      BackColor := $0065D3FF;
    end else
    begin
      ForeColor := $001193EE;
      BackColor := $009FE6FF;
    end;
  end else
  begin
    if dsSelected in DrawStyle then
    begin
      ForeColor := $001193EE;
      BackColor := $007BE1FE;
    end else
    begin
      ForeColor := SchemeColor(seBtnFaceDark, ColorScheme);
      BackColor := SchemeColor(seBtnFace, ColorScheme);
    end;
  end;
end;

procedure TNxOutlookBar.SetOptions(const Value: TOutlookBarOptions);
begin
  FOptions := Value;
  Invalidate;
end;

procedure TNxOutlookBar.SetStyle(const Value: TOutlookBarStyle);
begin
  FStyle := Value;
  Invalidate;
end;

procedure TNxOutlookBar.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_DOWN: if ItemIndex < Items.Count - 1 then ItemIndex := ItemIndex + 1;
    VK_UP: if ItemIndex > 0 then ItemIndex := ItemIndex - 1;
  end;
end;

procedure TNxOutlookBar.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

{ TNxOutlookBarItems }

constructor TNxOutlookBarItems.Create(AOwner: TNxOutlookBar);
begin
  inherited Create(TNxOutlookBarItem);
  FOwner := AOwner;
  FVisibleCount := 0;
end;

function TNxOutlookBarItems.Add: TNxOutlookBarItem;
begin
  Result := TNxOutlookBarItem(inherited Add);
  FOwner.Invalidate;
end;

function TNxOutlookBarItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TNxOutlookBarItems.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  case Action of
    cnAdded:
      begin
        Inc(FVisibleCount);
        FOwner.UpdateButtonsHeight;
      end;
    cnDeleting, cnExtracting:
      begin
        Dec(FVisibleCount);
        FOwner.UpdateButtonsHeight;
      end;
  end;
  FOwner.Invalidate;
end;

{ TNxOutlookBarItem }

constructor TNxOutlookBarItem.Create(Collection: TCollection);
begin
  inherited;
  FItems := Collection as TNxOutlookBarItems;
  FImageIndex := -1;
  FColor := clBtnFace;
  FObjectReference := nil;
  FVisible := True;
end;

destructor TNxOutlookBarItem.Destroy;
begin

  inherited;
end;

procedure TNxOutlookBarItem.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  FItems.FOwner.RefreshItem(Self);
end;

procedure TNxOutlookBarItem.SetColor(const Value: TColor);
begin
  FColor := Value;
  FItems.FOwner.RefreshItem(Self);
end;

procedure TNxOutlookBarItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  FItems.FOwner.RefreshItem(Self);
end;

procedure TNxOutlookBarItem.SetObjectReference(const Value: TObject);
begin
  FObjectReference := Value;
end;

procedure TNxOutlookBarItem.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    if FVisible then Inc(FItems.FVisibleCount) else
    begin
      FItems.FOwner.UpdateHeight;
      Dec(FItems.FVisibleCount);
    end;
    FItems.FOwner.UpdateHeight;
    FItems.FOwner.Invalidate;
  end;
end;

end.
