{
  NxLinkMenu
  Copyright (C) 1996-2009 by Berg
  All rights reserved.

  $id:NxLinkMenu.pas 9/6/2009 1:29:00 bn
}

unit NxLinkMenu;

interface

uses
  Classes, Types, Controls, Windows, Dialogs, SysUtils, ImgList, Graphics, Messages, ExtCtrls,
  NxClasses, NxCollection, NxThemesSupport, NxSharedCommon, NxScrollControl;

const
  spaSectionTextStart = 13;
  spaImgToText = 7;
  sizHeaderSize = 25;
  sizItemSize = 20;

type
  TNxLinkMenu = class;
  TNxSectionItems = class;
  TNxSectionItem = class;
  TShowingItems = set of (siLink, siShowImage);
  TNxSectionClickEvent = procedure(Sender: TObject; Section: Integer) of object;
  TItemClickEvent = procedure(Sender: TObject; Item: TNxSectionItem) of object;

  TNxSection = class(TCollectionItem)
  private
    FCaption: string;
    FExpanded: Boolean;
    FGlyph: TBitmap;
    FItems: TNxSectionItems;
    FSectionMargins: TNxMargins;
    FTransparent: Boolean;
    FTransparentColor: TColor;
    FSpecial: Boolean;
    procedure SetItems(const Value: TNxSectionItems);
    procedure SetExpanded(const Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetSectionMargins(const Value: TNxMargins);
    procedure SetTransparent(const Value: Boolean);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetSpecial(const Value: Boolean);
  protected
    procedure DoGlyphChange(Sender: TObject);
    procedure UpdateGlyph;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaption;
    property Expanded: Boolean read FExpanded write SetExpanded default True;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property Items: TNxSectionItems read FItems write SetItems;
    property SectionMargins: TNxMargins read FSectionMargins write SetSectionMargins;
    property Special: Boolean read FSpecial write SetSpecial default False;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property TransparentColor: TColor read FTransparentColor write SetTransparentColor default clNone;
  end;

  TNxSections = class(TCollection)
  private
    FOwner: TNxLinkMenu;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TNxLinkMenu);
    function Add: TNxSection;
    property Items;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  end;

  TNxSectionItem = class(TCollectionItem)
  private
    FCaption: string;
    FImageIndex: TImageIndex;
    FOptions: TShowingItems;
    FFont: TFont;
    function GetSection: TNxSection;
    procedure SetCaption(const Value: string);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetOptions(const Value: TShowingItems);
    procedure SetFont(const Value: TFont);
  protected
    procedure DoFontChange(Sender: TObject);
    procedure Refresh; virtual;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Section: TNxSection read GetSection;
  published
    property Caption: string read FCaption write SetCaption;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Font: TFont read FFont write SetFont;
    property Options: TShowingItems read FOptions write SetOptions default [siLink, siShowImage];
  end;

  TNxSectionItems = class(TCollection)
  private
    FOwner: TNxSection;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TNxSection);
    function Add: TNxSectionItem;
    property Items;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  end;

  TNxLinkMenu = class(TNxScrollControl)
  private
    FHeaderSize: integer;
    FHoverSection: TNxSection;
    FHoverSectionItem: TNxSectionItem;
    FImages: TImageList;
    FInnerMargins: TNxMargins;
    FItemSize: Integer;
    FOldHoverItem: TNxSectionItem;
    FOldHoverSection: TNxSection;
    FOnItemClick: TItemClickEvent;
    FOnSectionClick: TNxSectionClickEvent;
    FSections: TNxSections;
    FSpacing: Integer;
    FTheme: HTHEME;
    procedure SetSections(const Value: TNxSections);
    procedure SetInnerMargins(const Value: TNxMargins);
    procedure SetHeaderSize(const Value: integer);
    procedure SetImages(const Value: TImageList);
    procedure SetItemSize(const Value: Integer);
    procedure SetSpacing(const Value: Integer);
  protected
    procedure CreateWnd; override;
    function GetVertOffset(FromPos, ToPos: Integer): Integer; override;
    function GetTotalHeight: Integer;
    procedure DoInnerMarginsChange(Sender: TObject);
    procedure DoItemClick(Item: TNxSectionItem); dynamic;
    procedure DoSectionClick(Section: Integer); dynamic;
    procedure DrawArrow(const X, Y: Integer; Expanded, Special: Boolean); virtual;
    procedure DrawBackground; virtual;
    procedure DrawExpandingButton(ASection: TNxSection; SectionRect: TRect; Expanded, Special: Boolean); virtual;
    procedure DrawMarginBkgrnd; virtual;
    procedure DrawRectangle(const Value: TRect); virtual;
    procedure ExpandSection(Expanded: Boolean; Index: integer); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure RefreshItem(Item: TNxSectionItem; IncludeImage: Boolean); virtual;
    procedure RefreshSection(Section: TNxSection; IncludeImage: Boolean); virtual;
    procedure RefreshSectionButton(Section: TNxSection);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintSection(const Index, Pos: integer);
    procedure PaintSectionItem(Item: TNxSectionItem; Rect: TRect);
    procedure SetVertScrollBar;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetButtonRect(Rect: TRect): TRect;
    function GetItemsHeight(const Section: TNxSection): Integer;
    function GetSectionAtPos(const X, Y: Integer): TNxSection;
    function GetSectionHeaderRect(const Section: TNxSection): TRect;
    function GetSectionItem(const Section, Item: Integer): TNxSectionItem;
    function GetSectionItemLeft(Item: TNxSectionItem): Integer;
    function GetSectionItemAtPos(const X, Y: Integer): TNxSectionItem;
    function GetSectionItemRefreshRect(const Item: TNxSectionItem; IncludeImage: Boolean): TRect;
    function GetSectionRect(const Section: TNxSection;
      IncludeHeader: Boolean = False): TRect;
    function GetTotalHeigth: Integer;
    property Canvas;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HeaderSize: integer read FHeaderSize write SetHeaderSize default sizHeaderSize;
    property Images: TImageList read FImages write SetImages;
    property InnerMargins: TNxMargins read FInnerMargins write SetInnerMargins;
    property ItemSize: Integer read FItemSize write SetItemSize default sizItemSize;
    property Sections: TNxSections read FSections write SetSections;
    property Spacing: Integer read FSpacing write SetSpacing;
    property VertScrollBar;
    property Visible;

    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnItemClick: TItemClickEvent read FOnItemClick write FOnItemClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnSectionClick: TNxSectionClickEvent read FOnSectionClick write FOnSectionClick;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  Forms;

{ TNxLinkMenu }

procedure TNxLinkMenu.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNxLinkMenu.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHoverSection := nil;
  FHoverSectionItem := nil;
  Screen.Cursor := Cursor;
  Invalidate;
end;

constructor TNxLinkMenu.Create(AOwner: TComponent);
begin
  inherited;
  FHeaderSize := sizHeaderSize;
  FInnerMargins := TNxMargins.Create;
  FInnerMargins.SetRect(10, 10, 10, 10);
  FInnerMargins.OnChange := DoInnerMarginsChange;
  FItemSize := sizItemSize;
  FOldHoverItem := nil;
  FOldHoverSection := nil;
  FSections := TNxSections.Create(Self);
  FSpacing := 10;
  Width := 200;
  Height := 350;
  ParentColor := False;
  Color := clWindow;
end;

procedure TNxLinkMenu.CreateWnd;
begin
  inherited;
  HorzScrollBar.Visible := False;
  VertScrollBar.Visible := False;
  if IsThemed then FTheme := OpenThemeData(Handle, teExplorerBar);
end;

destructor TNxLinkMenu.Destroy;
begin
  FreeAndNil(FSections);
  FreeAndNil(FInnerMargins);
  CloseThemeData(FTheme);
  inherited;
end;

procedure TNxLinkMenu.DoInnerMarginsChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNxLinkMenu.DoItemClick(Item: TNxSectionItem);
begin
  if Assigned(FOnItemClick) then FOnItemClick(Self, Item);
end;

procedure TNxLinkMenu.DoSectionClick(Section: Integer);
begin
  if Assigned(FOnSectionClick) then FOnSectionClick(Self, Section);
end;

procedure TNxLinkMenu.DrawArrow(const X, Y: Integer; Expanded, Special: Boolean);
begin
  with Canvas do
  begin
    if Special then Pen.Color := clHighlightText else Pen.Color := clWindowText;
    if Expanded then
    begin
      MoveTo(X + 5, Y + 6);
      LineTo(X + 8, Y + 3);
      LineTo(X + 11, Y + 6);
      LineTo(X + 10, Y + 6);
      LineTo(X + 8, Y + 4);
      LineTo(X + 5, Y + 7);
      MoveTo(X + 5, Y + 10);
      LineTo(X + 8, Y + 7);
      LineTo(X + 11, Y + 10);
      LineTo(X + 10, Y + 10);
      LineTo(X + 8, Y + 8);
      LineTo(X + 5, Y + 11);
    end else
    begin
      MoveTo(X + 5, Y + 4);
      LineTo(X + 8, Y + 7);
      LineTo(X + 11, Y + 4);
      LineTo(X + 11, Y + 4);
      LineTo(X + 10, Y + 4);
      LineTo(X + 8, Y + 6);
      LineTo(X + 6, Y + 4);
      LineTo(X + 5, Y + 3);
      MoveTo(X + 5, Y + 8);
      LineTo(X + 8, Y + 11);
      LineTo(X + 11, Y + 8);
      LineTo(X + 11, Y + 8);
      LineTo(X + 10, Y + 8);
      LineTo(X + 8, Y + 10);
      LineTo(X + 6, Y + 8);
      LineTo(X + 5, Y + 7);
    end;
  end;
end;

procedure TNxLinkMenu.DrawBackground;
begin
  inherited;
  if IsThemed
    then DrawThemeBackground(FTheme, Canvas.Handle, 0, 1, ClientRect, nil)
    else DrawMarginBkgrnd;
end;

procedure TNxLinkMenu.DrawExpandingButton(ASection: TNxSection; SectionRect: TRect;
  Expanded, Special: Boolean);
const
  NormalState: array[Boolean] of Integer = (7, 6);
  SpecialState: array[Boolean] of Integer = (11, 10);
var
  Rect: TRect;
  m: Integer;
begin
  m := SectionRect.Top + (SectionRect.Bottom - SectionRect.Top) div 2;
  if IsThemed then
  begin
    with Rect do
    begin
      Right := SectionRect.Right - 6;
      Left := Right - 17;
      Top := m - 10;
      Bottom := m + 8;
    end;
    if Special then
      DrawThemeBackground(FTheme, Canvas.Handle, SpecialState[Expanded], 1, Rect, nil)
        else DrawThemeBackground(FTheme, Canvas.Handle, NormalState[Expanded], 1, Rect, nil);
  end else
  begin
    with Rect do
    begin
      Right := SectionRect.Right - 6;
      Left := Right - 17;
      Top := m - 8;
      Bottom := m + 8;
    end;
    DrawArrow(Rect.Left, Rect.Top, ASection.Expanded, ASection.Special);
    if FHoverSection = ASection
      then Frame3D(Canvas, Rect, clBtnHighlight, clBtnShadow, 1);
  end;
end;

procedure TNxLinkMenu.DrawMarginBkgrnd;
begin
  DrawRectangle(Rect(0, 0, FInnerMargins.Left, ClientHeight));
  DrawRectangle(Rect(ClientWidth - FInnerMargins.Right, 0, ClientWidth, ClientHeight));
  DrawRectangle(Rect(0, 0, ClientWidth, FInnerMargins.Top));
end;

procedure TNxLinkMenu.DrawRectangle(const Value: TRect);
begin
  Canvas.Brush.Color := clWindow;
  Canvas.FillRect(Value);
end;

procedure TNxLinkMenu.ExpandSection(Expanded: Boolean; Index: integer);
var
  Delta: Integer;
  ClpRect: TRect;
begin
  ClpRect := GetSectionRect(TNxSection(FSections.Items[Index]));
  ClpRect.Bottom := ClientHeight;
  Delta := GetItemsHeight(TNxSection(FSections.Items[Index]));
  if Expanded then
  begin
    ScrollWindowEx(Handle, 0, Delta, nil, @ClpRect, 0, @ClpRect, SW_INVALIDATE);
  end else
  begin
    ScrollWindowEx(Handle, 0, -Delta, nil, @ClpRect, 0, @ClpRect, SW_INVALIDATE);
  end;
  RefreshSectionButton(TNxSection(FSections.Items[Index]));
end;

function TNxLinkMenu.GetButtonRect(Rect: TRect): TRect;
var
  m: Integer;
begin
  m := Rect.Top + (Rect.Bottom - Rect.Top) div 2;
  with Result do
  begin
    Right := Rect.Right - 6;
    Left := Right - 17;
    Top := m - 8;
    Bottom := m + 8;
  end;
end;

function TNxLinkMenu.GetItemsHeight(const Section: TNxSection): Integer;
var
  i: Integer;
begin
  Result := Section.FSectionMargins.Top + Section.FSectionMargins.Bottom;
  for i := 0 to Pred(Section.FItems.Count) do
  begin
    Inc(Result, ItemSize);
  end;
end;

function TNxLinkMenu.GetSectionAtPos(const X, Y: Integer): TNxSection;
var
  i, j, YPos: Integer;
  Section: TNxSection;
begin
  Result := nil;
  YPos := FInnerMargins.Top - VertScrollBar.Position;
  for i := 0 to FSections.Count - 1 do
  begin
    Section := TNxSection(FSections.Items[i]);
    if (Y >= YPos) and (Y <= YPos + FHeaderSize) then
    begin
      Result := Section;
      Exit;
    end;
    Inc(YPos, FHeaderSize);
    if Section.Expanded then
    begin
      Inc(YPos, Section.FSectionMargins.Top);
      Inc(YPos, Section.FSectionMargins.Bottom);
      for j := 0 to Section.Items.Count - 1 do
      begin
        Inc(YPos, ItemSize);
      end;
    end;
    Inc(YPos, Spacing);
  end;
end;

function TNxLinkMenu.GetSectionHeaderRect(
  const Section: TNxSection): TRect;
var
  ASection: TNxSection;
  i, j, Y: Integer;
begin
  Y := FInnerMargins.Top - VertScrollBar.Position;
  for i := 0 to Sections.Count - 1 do
  begin
    ASection := TNxSection(Sections.Items[i]);
    if ASection = Section then
    begin
      Result := Rect(FInnerMargins.Left, Y, ClientWidth - FInnerMargins.Right, Y + FHeaderSize);
    end;
    Inc(Y, FHeaderSize);
    if ASection.Expanded then
    begin
      Inc(Y, ASection.FSectionMargins.Top);
      for j := 0 to ASection.FItems.Count - 1 do
      begin
        Inc(Y, ItemSize);
      end;
      Inc(Y, ASection.FSectionMargins.Bottom);
    end;
    Inc(Y, FSpacing);
  end;
end;

function TNxLinkMenu.GetSectionItem(const Section,
  Item: Integer): TNxSectionItem;
begin
  Result := TNxSectionItem(TNxSection(Sections.Items[Section]).Items.Items[Item]);
end;

function TNxLinkMenu.GetSectionItemAtPos(const X, Y: Integer): TNxSectionItem;
var
  i, j, YPos: integer;
  Section: TNxSection;
  Item: TNxSectionItem;
begin
  inherited;
  Result := nil;
  YPos := FInnerMargins.Top - VertScrollBar.Position;
  for i := 0 to FSections.Count - 1 do
  begin
    Section := TNxSection(FSections.Items[i]);
    Inc(YPos, FHeaderSize);
    if Section.Expanded then
    begin
      Inc(YPos, Section.SectionMargins.Top);
      for j := 0 to Section.FItems.Count - 1 do
      begin
        Item := TNxSectionItem(Section.FItems.Items[j]);
        if (Y >= YPos) and (Y <= YPos + ItemSize) then
        begin
          Result := Item;
          Exit;
        end;
        Inc(YPos, ItemSize);
      end;
      Inc(YPos, Section.SectionMargins.Bottom);
    end; { Expanded }
    YPos := YPos + FSpacing;
  end;
end;

function TNxLinkMenu.GetSectionItemRefreshRect(const Item: TNxSectionItem; IncludeImage: Boolean): TRect;
var
  i, j, YPos: Integer;
  SectionItem: TNxSectionItem;
  Section: TNxSection;
begin
  inherited;
  YPos := FInnerMargins.Top - VertScrollBar.Position;
  for i := 0 to Pred(FSections.Count) do
  begin
    Section := TNxSection(FSections.Items[i]);
    if Section.Expanded then
    begin
      Inc(YPos, FHeaderSize);
      Inc(YPos, Section.SectionMargins.Top);
      for j := 0 to Pred(Section.Items.Count) do
      begin
        SectionItem := TNxSectionItem(Section.Items.Items[j]);
        if SectionItem = Item then
        begin
          with Result do
          begin      
            Left := GetSectionItemLeft(SectionItem);
            Top := YPos;
            Right := Left + GetTextWidth(Canvas, SectionItem.Caption);
            Bottom := YPos + ItemSize;
          end;
        end;
        Inc(YPos, ItemSize);
      end;
      Inc(YPos, Section.SectionMargins.Bottom);
    end;
    Inc(YPos, Spacing);
  end;
end;

function TNxLinkMenu.GetSectionItemLeft(Item: TNxSectionItem): Integer;
begin
  Canvas.Font.Assign(Item.Font);
  Result := FInnerMargins.Left;
  Inc(Result, Item.Section.FSectionMargins.Left);
  if Assigned(FImages) then
  begin
    Inc(Result, FImages.Width);
    Inc(Result, spaImgToText);
  end;
end;

function TNxLinkMenu.GetSectionRect(const Section: TNxSection;
  IncludeHeader: Boolean = False): TRect;
var
  ASection: TNxSection;
  i, j, SectionTop, Y: Integer;
  Done: Boolean;
begin
  SectionTop := -1;
  Done := False;
  Y := FInnerMargins.Top - VertScrollBar.Position;
  for i := 0 to Sections.Count - 1 do
  begin
    Inc(Y, FHeaderSize);
    ASection := TNxSection(Sections.Items[i]);
    if ASection = Section then
    begin
      SectionTop := Y;
      Done := True;
    end;
    if ASection.Expanded then
    begin
      Inc(Y, ASection.FSectionMargins.Top);
      for j := 0 to ASection.FItems.Count - 1 do
      begin
        Inc(Y, ItemSize);
      end;
      Inc(Y, ASection.FSectionMargins.Bottom);
    end;
    if Done then
    begin
      Result := Rect(FInnerMargins.Left, SectionTop, ClientWidth - FInnerMargins.Right, Y);
      Exit;
    end;
    Inc(Y, FSpacing);
  end;
end;

function TNxLinkMenu.GetTotalHeigth: Integer;
var
  i, j: Integer;
begin
  Result := FInnerMargins.Top;
  for i := 0 to FSections.Count - 1 do
  begin
    if TNxSection(FSections.Items[i]).Expanded then
    begin
      Result := Result + FHeaderSize;
      Result := Result + TNxSection(FSections.Items[i]).FSectionMargins.Top;
      for j := 0 to TNxSection(FSections.Items[i]).Items.Count-1
        do Result := Result + FItemSize;
      Result := Result + TNxSection(FSections.Items[i]).FSectionMargins.Bottom;
    end else Result := Result + FHeaderSize;
    if i = FSections.Count - 1 then Result := Result + FInnerMargins.Bottom
      else Result := Result + FSpacing;
  end;
end;

function TNxLinkMenu.GetVertOffset(FromPos, ToPos: Integer): Integer;
begin
  Result := 0;
  case VertScrollBar.ScrollKind of
    rkThumb, rkPage, rkTopBottom: Result := FromPos - ToPos;
    rkLine: Result := FromPos - ToPos;
  end;
end;

function TNxLinkMenu.GetTotalHeight: Integer;
var
  i, j: Integer;
  Section: TNxSection;
begin
  Result := FInnerMargins.Top;
  for i := 0 to Pred(FSections.Count) do
  begin
    Section := TNxSection(FSections.Items[i]);
    Inc(Result, FHeaderSize);
    if Section.Expanded then
    begin
      Inc(Result, Section.SectionMargins.Top);
      for j := 0 to Pred(Section.FItems.Count) do
      begin
        Inc(Result, ItemSize);
      end;
      Inc(Result, Section.SectionMargins.Bottom);
    end;
    if i < Pred(FSections.Count)-1 then Inc(Result, Spacing);
    Inc(Result, FInnerMargins.Bottom);
  end;
end;

procedure TNxLinkMenu.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;

end;

procedure TNxLinkMenu.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  Section: TNxSection;
  SectionItem: TNxSectionItem;
begin
  inherited;

  Section := GetSectionAtPos(X, Y);
  if Assigned(Section) then
  begin
    if Section <> FOldHoverSection then
    begin
      FHoverSection := Section;
      FOldHoverSection := Section;
      if FOldHoverSection <> nil then RefreshSection(FOldHoverSection, False);
    end;
  end else
  begin
    if FOldHoverSection <> nil then RefreshSection(FOldHoverSection, False);
    FHoverSection := nil;
    FOldHoverSection := nil;
  end;

  SectionItem := GetSectionItemAtPos(X, Y);
  if SectionItem <> nil then
  begin
    Screen.Cursor := crHandPoint;
    FHoverSectionItem := SectionItem;
    if SectionItem <> FOldHoverItem then
    begin
      if FOldHoverItem <> nil then RefreshItem(FOldHoverItem, False);
      RefreshItem(SectionItem, False);
      FOldHoverItem := SectionItem;
    end;
  end else
  begin
    FHoverSectionItem := nil;
    if FOldHoverItem <> nil then RefreshItem(FOldHoverItem, False);
    FOldHoverItem := nil;
    Screen.Cursor := Cursor;
  end;
end;

procedure TNxLinkMenu.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Section: TNxSection;
  Item: TNxSectionItem;
begin
  inherited;
  if (X < InnerMargins.Left) or (X >= ClientWidth - InnerMargins.Right) then Exit;

  Section := GetSectionAtPos(X, Y);
  if Assigned(Section) then
  begin
    Section.Expanded := not Section.Expanded;
    DoSectionClick(Section.Index);
  end;

  Item := GetSectionItemAtPos(X, Y);
  if Assigned(Item) then
  begin
    DoItemClick(Item);
  end;
end;

procedure TNxLinkMenu.Paint;
var
  i, j, Y: Integer;
  Section: TNxSection;
  SectionRect, ItemRect: TRect;
begin
  inherited;
  VertScrollClipRect := ClientRect;
  SetVertScrollBar;
  DrawBackground;

  Y := FInnerMargins.Top - VertScrollBar.Position;
  for i := 0 to FSections.Count - 1 do
  begin
    Section := TNxSection(FSections.Items[i]);
    PaintSection(i, Y);
    Inc(Y, FHeaderSize);
    if Section.Expanded then
    begin
      SectionRect := Rect(FInnerMargins.Left, Y, ClientWidth - FInnerMargins.Right,
        Y + GetItemsHeight(Section));
      if IsThemed then
      begin
        DrawThemeBackground(FTheme, Canvas.Handle, 5, 1, SectionRect, nil);
      end else
      begin
        if Section.Special then
        begin
          Canvas.Brush.Color := clWindow;
          Canvas.Pen.Color := clHighlight;
        end else
        begin
          Canvas.Pen.Color := clBtnFace;
        end;
        Canvas.FillRect(SectionRect);
        Canvas.MoveTo(SectionRect.Left, SectionRect.Top);
        Canvas.LineTo(SectionRect.Left, SectionRect.Bottom - 1);
        Canvas.LineTo(SectionRect.Right - 1, SectionRect.Bottom - 1);
        Canvas.LineTo(SectionRect.Right - 1, SectionRect.Top - 1);
      end;
      Inc(Y, Section.FSectionMargins.Top);
      for j := 0 to Section.FItems.Count - 1 do
      begin
        ItemRect := Rect(FInnerMargins.Left + Section.SectionMargins.Left, Y,
          ClientWidth - FInnerMargins.Right - Section.SectionMargins.Right, Y + ItemSize);
        PaintSectionItem(TNxSectionItem(Section.FItems.Items[j]), ItemRect);
        Inc(Y, ItemSize);
      end;
      Inc(Y, Section.FSectionMargins.Bottom);
    end;
    if IsThemed then
    begin

    end else
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(Rect(FInnerMargins.Left, Y, ClientWidth - FInnerMargins.Right, Y + Spacing));
    end;
    Inc(Y, Spacing);
  end; { for sections }
  if not IsThemed then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(Rect(FInnerMargins.Left, Y, ClientWidth - FInnerMargins.Right, ClientHeight));
  end;
end;

procedure TNxLinkMenu.PaintSection(const Index, Pos: integer);
const
  State: array[Boolean] of Integer = (8, 12);
var
  Section: TNxSection;
  SectionRect, ButtonRect: TRect;
  GlyphY: Integer;
begin
  Section := TNxSection(FSections.Items[Index]);

  Canvas.Pen.Color := clBtnFace;
  SectionRect := Rect(InnerMargins.Left, Pos, ClientWidth - InnerMargins.Right, Pos + HeaderSize);
  ButtonRect := SectionRect;

  if IsThemed then DrawThemeBackground(FTheme, Canvas.Handle, State[Section.Special], 1, SectionRect, nil) else
  begin
    if Section.Special then Canvas.Brush.Color := clHighlight
      else Canvas.Brush.Color := clBtnFace;
    Canvas.FillRect(SectionRect);
  end;

  Inc(SectionRect.Left, 2);
  if Assigned(Section.Glyph) and not Section.Glyph.Empty then
  begin
    GlyphY := Pos + FHeaderSize div 2 - Section.Glyph.Height div 2;
    Canvas.Draw(SectionRect.Left, GlyphY, Section.Glyph);
    Inc(SectionRect.Left, Section.Glyph.Width + 2);
  end;

  with Canvas do
  begin
    Font.Assign(Self.Font);
    Font.Style := [fsBold];
    if IsThemed then
    begin
      if Section.Special then Font.Color := clHighlightText
        else Font.Color := clHighlight;
    end else
    begin
      if Section.Special then Font.Color := clHighlightText
        else Font.Color := clWindowText;
    end;
    DrawTextRect(Canvas, SectionRect, taLeftJustify, Section.Caption);
    DrawExpandingButton(Section, ButtonRect, Section.Expanded, Section.Special);
  end;
end;

procedure TNxLinkMenu.PaintSectionItem(Item: TNxSectionItem; Rect: TRect);
var
  ImgY: Integer;
begin
  with Canvas do
  begin
    Font.Assign(Item.Font);
    if Assigned(FImages) then
    begin
      ImgY := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - FImages.Height div 2;
      if Item.ImageIndex > -1 then FImages.Draw(Canvas, Rect.Left, ImgY, Item.ImageIndex);
      Inc(Rect.Left, FImages.Width);
      Inc(Rect.Left, spaImgToText);
    end;
    if Item = FHoverSectionItem then
    begin
      Font.Style := Font.Style + [fsUnderline];
    end;
    DrawTextRect(Canvas, Rect, taLeftJustify, Item.Caption);
  end;
end;

procedure TNxLinkMenu.RefreshItem(Item: TNxSectionItem; IncludeImage: Boolean);
var
  R: TRect;
begin
  R := GetSectionItemRefreshRect(Item, IncludeImage);
  InvalidateRect(Handle, @R, False);
end;

procedure TNxLinkMenu.RefreshSection(Section: TNxSection;
  IncludeImage: Boolean);
var
  R: TRect;
begin
  R := GetSectionHeaderRect(Section);
  InvalidateRect(Handle, @R, False);
end;

procedure TNxLinkMenu.SetHeaderSize(const Value: integer);
begin
  FHeaderSize := Value;
  Invalidate;
end;

procedure TNxLinkMenu.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    if Assigned(FImages) then FImages.FreeNotification(Self);
    Invalidate;
  end else FImages.RemoveFreeNotification(Self);  
end;

procedure TNxLinkMenu.SetInnerMargins(const Value: TNxMargins);
begin
  FInnerMargins := Value;
end;

procedure TNxLinkMenu.SetItemSize(const Value: Integer);
begin
  FItemSize := Value;
  Invalidate;
end;

procedure TNxLinkMenu.SetSections(const Value: TNxSections);
begin
  FSections := Value;
end;

procedure TNxLinkMenu.SetSpacing(const Value: Integer);
begin
  FSpacing := Value;
end;

procedure TNxLinkMenu.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TNxLinkMenu.SetVertScrollBar;
var
  ScrollMax, PageSize: Integer;

begin
  if csDestroying in ComponentState then Exit;
  PageSize := ClientHeight;
  ScrollMax := GetTotalHeight;

  if ScrollMax > PageSize then
  begin
    VertScrollBar.Max := ScrollMax;
    VertScrollBar.PageSize := PageSize + 1;
    VertScrollBar.LargeChange := VertScrollBar.PageSize;
  end else VertScrollBar.Max := 0;
end;

procedure TNxLinkMenu.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages)
    then Images := nil;
end;

procedure TNxLinkMenu.RefreshSectionButton(Section: TNxSection);
var
  R: TRect;
begin
  InvalidateRect(Handle, @R, False);
end;

{ TNxSections }

function TNxSections.Add: TNxSection;
begin
  Result := TNxSection(inherited Add);
end;

constructor TNxSections.Create(AOwner: TNxLinkMenu);
begin
  inherited Create(TNxSection);
  FOwner := AOwner;
end;

function TNxSections.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TNxSections.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  FOwner.Invalidate;
end;

{ TNxSection }

constructor TNxSection.Create(Collection: TCollection);
begin
  inherited;
  FExpanded := True;
  FItems := TNxSectionItems.Create(Self);
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChange;
  FSectionMargins := TNxMargins.Create;
  FSectionMargins.Left := 5;
  FSectionMargins.Right := 5;
  FSectionMargins.Top := 5;
  FSectionMargins.Bottom := 5;
  FSpecial := False;
  FTransparent := False;
  FTransparentColor := clNone;
end;

destructor TNxSection.Destroy;
begin
  FItems.Free;
  FGlyph.Free;
  FSectionMargins.Free;
  inherited;
end;

procedure TNxSection.DoGlyphChange;
begin
  UpdateGlyph;
  TNxSections(Collection).FOwner.RefreshSection(Self, True);
end;

procedure TNxSection.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TNxSection.SetExpanded(const Value: Boolean);
begin
  if Value <> FExpanded then
  begin
    FExpanded := Value;
    TNxSections(Collection).FOwner.ExpandSection(Value, Index);
  end;     
end;

procedure TNxSection.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  UpdateGlyph;
end;

procedure TNxSection.SetItems(const Value: TNxSectionItems);
begin
  FItems := Value;
end;

procedure TNxSection.SetSectionMargins(const Value: TNxMargins);
begin
  FSectionMargins := Value;
end;

procedure TNxSection.SetSpecial(const Value: Boolean);
begin
  FSpecial := Value;
end;

procedure TNxSection.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  UpdateGlyph;
end;

procedure TNxSection.SetTransparentColor(const Value: TColor);
begin
  FTransparentColor := Value;
  UpdateGlyph;
end;

procedure TNxSection.UpdateGlyph;
begin
  FGlyph.Transparent := FTransparent;
  FGlyph.TransparentColor := FTransparentColor;
end;

{ TNxSectionItem }

constructor TNxSectionItem.Create(Collection: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FFont := TFont.Create;
  FFont.OnChange := DoFontChange;
  FOptions := [siLink, siShowImage];
end;

destructor TNxSectionItem.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

procedure TNxSectionItem.DoFontChange(Sender: TObject);
begin
  Refresh;
end;

function TNxSectionItem.GetSection: TNxSection;
begin
  Result := TNxSectionItems(Collection).FOwner;
end;

procedure TNxSectionItem.Refresh;
begin
  TNxLinkMenu(Section.Collection.Owner).RefreshItem(Self, True);
end;

procedure TNxSectionItem.SetCaption(const Value: string);
begin
  FCaption := Value;
  Refresh;
end;

procedure TNxSectionItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TNxSectionItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Refresh;
end;

procedure TNxSectionItem.SetOptions(const Value: TShowingItems);
begin
  FOptions := Value;
  Refresh;
end;

{ TNxSectionItems }

function TNxSectionItems.Add: TNxSectionItem;
begin
  Result := TNxSectionItem(inherited Add);
end;

constructor TNxSectionItems.Create(AOwner: TNxSection);
begin
  inherited Create(TNxSectionItem);
  FOwner := AOwner;
end;

function TNxSectionItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TNxSectionItems.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  TNxSections(FOwner.Collection).FOwner.Invalidate;
end;

end.
