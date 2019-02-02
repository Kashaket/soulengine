{
  NxSheet
  Copyright (C) 1996-2006 by Berg
  All rights reserved.

  $id:NxColumnList.pas bn
}

unit NxColumnList;

interface

uses
  Classes, Types, Graphics, Controls, ImgList, SysUtils,
  Messages, Windows, NxSheetCell;

const
  spHorzMargin = 8;
  spVertMargin = 7;
  spVertSpacing = 3;

type
  TBorderClickEvent = procedure (Sender: TObject; Position: TBorderPosition) of object;

  TNxBorderPicker = class;

  TNxColumnList = class(TCustomControl)
  private
    FColCount: Integer;
    FItemIndex: Integer;
    FOldHeight: Integer;
    FOldWidth: Integer;
    FRowCount: Integer;
    FSelectedIndex: Integer;
    FOnChange: TNotifyEvent;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetItemIndex(const Value: Integer);
  protected
    function GetItemHeight: Integer; virtual;
    function GetItemWidth: Integer; virtual;
    function GetCount: Integer; virtual;
    procedure DoChange; dynamic;
    procedure DrawItem(const Index: Integer; ItemRect: TRect); virtual;
    procedure DrawItems; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
    procedure UpdateHeight; virtual;
    procedure UpdateWidth; virtual;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    function GetItemAtPos(const Point: TPoint): Integer;
    property Count: Integer read GetCount;
  published
    property ColCount: Integer read FColCount;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNxLineStyleList = class(TNxColumnList)
  private
    FLineColor: TColor;
    FBorderPicker: TNxBorderPicker;
    function GetLineStyle: TLineStyle;
    procedure SetLineStyle(const Value: TLineStyle);
    procedure SetLineColor(const Value: TColor);
    procedure SetBorderPicker(const Value: TNxBorderPicker);
  protected
    function GetCount: Integer; override;
    function GetItemHeight: Integer; override;
    function GetItemWidth: Integer; override;
    procedure DoChange; override;
    procedure DrawItem(const Index: Integer; ItemRect: TRect); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property BorderPicker: TNxBorderPicker read FBorderPicker write SetBorderPicker;
    property Color;
    property LineColor: TColor read FLineColor write SetLineColor;
    property LineStyle: TLineStyle read GetLineStyle write SetLineStyle;
    property ParentColor;
  end;

  TCellCount = 1..2;

  TNxBorderPicker = class(TCustomControl)
  private
    FBorderTop: TNxCellBorder;
    FBorderRight: TNxCellBorder;
    FBorderLeft: TNxCellBorder;
    FBorderBottom: TNxCellBorder;
    FOnBorderClick: TBorderClickEvent;
    FSelected: TNxCellBorder;
    FColCount: TCellCount;
    FRowCount: TCellCount;
    procedure SetBorderBottom(const Value: TNxCellBorder);
    procedure SetBorderLeft(const Value: TNxCellBorder);
    procedure SetBorderRight(const Value: TNxCellBorder);
    procedure SetBorderTop(const Value: TNxCellBorder);
    procedure SetSelected(const Value: TNxCellBorder);
    procedure SetColCount(const Value: TCellCount);
    procedure SetRowCount(const Value: TCellCount);
  protected
    procedure Paint; override;
    procedure DoBorderClick(Position: TBorderPosition); dynamic;
    procedure DrawBorder(X1, Y1, X2, Y2: Integer; Border: TNxCellBorder);
    procedure DrawBorders;
    procedure DrawGrips;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure RefreshBorder(Border: TNxCellBorder); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBorderAtPos(X, Y: Integer): TNxCellBorder;
    property BorderBottom: TNxCellBorder read FBorderBottom write SetBorderBottom;
    property BorderLeft: TNxCellBorder read FBorderLeft write SetBorderLeft;
    property BorderRight: TNxCellBorder read FBorderRight write SetBorderRight;
    property BorderTop: TNxCellBorder read FBorderTop write SetBorderTop;
    property Selected: TNxCellBorder read FSelected write SetSelected;
  published
    property Align;
    property ColCount: TCellCount read FColCount write SetColCount default 1;
    property Color;
    property Constraints;
    property Font;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property RowCount: TCellCount read FRowCount write SetRowCount default 1;

    property OnBorderClick: TBorderClickEvent read FOnBorderClick write FOnBorderClick;
  end;

procedure Register;

implementation

uses
  NxThemesSupport, NxSheetDraw, NxSharedDraw, Math, ExtCtrls;

procedure Register;
begin
  RegisterComponents('Next Shared', [TNxLineStyleList, TNxBorderPicker]);
end;

{ TNxColumnList }

constructor TNxColumnList.Create(AOwner: TComponent);
begin
  inherited;
  FColCount := 1;
  FItemIndex := 0;
  FOldHeight := 0;
  FOldWidth := 0;
  FRowCount := 1;
  ParentColor := False;
  Color := clWindow;
end;

procedure TNxColumnList.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxColumnList.DrawItem(const Index: Integer;
  ItemRect: TRect);
begin
  if (Index = FItemIndex) or (Index = FSelectedIndex) then
  begin
    Canvas.Pen.Color := clGray;
    DrawDotsRect(Canvas, ItemRect);
  end;
end;

procedure TNxColumnList.DrawItems;
var
  I, Row, X, Y: Integer;
  ItemRect: TRect;
begin
  X := spHorzMargin + 1;
  Y := spVertMargin;
  Row := 0;
  for I := 0 to Count - 1 do
  begin
    ItemRect := Rect(X, Y, X + GetItemWidth, Y + GetItemHeight);
    Inc(Y, GetItemHeight);
    Inc(Y, spVertSpacing);
    DrawItem(I, ItemRect);
    Inc(Row);
    if Row >= FRowCount then
    begin
      Y := spVertMargin;
      Inc(X, spHorzMargin + GetItemWidth);
      Row := 0;
    end;
  end;
end;

function TNxColumnList.GetCount: Integer;
begin
  Result := 0;
end;

function TNxColumnList.GetHeight: Integer;
var
  H: Integer;
begin
  H := Height;
  Dec(H, 2); // borders
  Dec(H, spVertMargin);
  FRowCount := H div (GetItemHeight + spVertSpacing);
  Result := FRowCount * (GetItemHeight + spVertSpacing);
  Inc(Result, 2);
  Inc(Result, spVertMargin);
end;

function TNxColumnList.GetItemAtPos(const Point: TPoint): Integer;
var
  I, Row, X, Y: Integer;
  ItemRect: TRect;
begin
  Result := -1;
  X := spHorzMargin + 1;
  Y := spVertMargin;
  Row := 0;
  for I := 0 to Count - 1 do
  begin
    ItemRect := Rect(X, Y, X + GetItemWidth, Y + GetItemHeight);
    if PtInRect(ItemRect, Point) then
    begin
      Result := I;
      Exit;
    end;
    Inc(Y, GetItemHeight);
    Inc(Y, spVertSpacing);
    Inc(Row);
    if Row >= FRowCount then
    begin
      Y := spVertMargin;
      Inc(X, spHorzMargin + GetItemWidth);
      Row := 0;
    end;
  end;
end;

function TNxColumnList.GetItemHeight: Integer;
begin
  Result := 0;
end;

function TNxColumnList.GetItemWidth: Integer;
begin
  Result := 0;
end;

function TNxColumnList.GetWidth: Integer;
var
  W: Integer;
begin
  W := Width;
  Dec(W, 2); // borders
  Dec(W, spHorzMargin);
  FColCount := W div (GetItemWidth + spHorzMargin);
  Result := FColCount * (GetItemWidth + spHorzMargin);
  Inc(Result, 2);
  Inc(Result, spHorzMargin);
end;

procedure TNxColumnList.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  NewIndex: Integer;
begin
  inherited;
  NewIndex := GetItemAtPos(Point(X, Y));
  if (NewIndex <> -1) and (FSelectedIndex <> NewIndex) then
  begin
    FSelectedIndex := NewIndex;
    Invalidate;
  end;
end;

procedure TNxColumnList.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  NewIndex: Integer;
begin
  inherited;
  NewIndex := GetItemAtPos(Point(X, Y));
  if (NewIndex <> -1) and (FItemIndex <> NewIndex) then
  begin
    if FSelectedIndex = NewIndex then ItemIndex := NewIndex;
  end;
end;

procedure TNxColumnList.Paint;
var
  R: TRect;
begin
  inherited;
  if IsThemed then ThemeRect(Handle, Canvas.Handle, ClientRect, teListView, 1, 1) else
  begin
    R := ClientRect;
    DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_PUSHED);
    InflateRect(R, -2, -2);
    Canvas.Brush.Color := Color;
    Canvas.FillRect(R);
  end;
  Canvas.Font.Assign(Font);
  DrawItems;
end;

procedure TNxColumnList.SetItemIndex(const Value: Integer);
begin
  if InRange(Value, 0, Count - 1) then
  begin
    FItemIndex := Value;
    DoChange; { Event }
    Invalidate;
  end;
end;

procedure TNxColumnList.UpdateHeight;
var
  NewHeight: Integer;
begin
  NewHeight := GetHeight;   
  if NewHeight <> Height then
  begin
    Height := NewHeight;
    FOldHeight := Height;
  end;
end;

procedure TNxColumnList.UpdateWidth;
var
  NewWidth: Integer;
begin
  NewWidth := GetWidth;
  if NewWidth <> Width then
  begin
    Width := NewWidth;
    FOldWidth := Width;
  end;
end;

procedure TNxColumnList.WMSize(var Message: TWMSize);
begin
  inherited;
  if Height <> FOldHeight then UpdateHeight;
  if Width <> FOldWidth then UpdateWidth;
end;

{ TNxLineStyleList }

constructor TNxLineStyleList.Create(AOwner: TComponent);
begin
  inherited;
  FBorderPicker := nil;
  Height := 121;
  Width := 96;
end;

procedure TNxLineStyleList.DoChange;
begin
  inherited;
  if FBorderPicker <> nil then
  begin
    FBorderPicker.Selected.LineStyle := GetLineStyle;
    FBorderPicker.Selected.Color := FLineColor;
  end;
end;

procedure TNxLineStyleList.DrawItem(const Index: Integer;
  ItemRect: TRect);
var
  Y: Integer;
  TxtRect: TRect;
begin
  Canvas.Pen.Color := FLineColor;
  Y := ItemRect.Top + ((ItemRect.Bottom - ItemRect.Top) div 2);
  case Index of
    0:  begin
          TxtRect := ItemRect;
          InflateRect(TxtRect, -4, -1);
          DrawTextRect(Canvas, TxtRect, 'None');
        end;
    1:  DrawThinDotLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    2:  DrawDotLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    3:  DrawDashDotDotLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    4:  DrawDashDotLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    5:  DrawWideDotLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    6:  DrawThinLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    7:  begin
          DrawDashDotDotLine(Canvas, ItemRect.Left, Y - 1, ItemRect.Right, Y - 1);
          DrawDashDotDotLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
        end;
    8:  DrawThinLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    9:  DrawThinLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
    11: begin
          DrawThinLine(Canvas, ItemRect.Left, Y - 1, ItemRect.Right, Y - 1);
          DrawThinLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
        end;
    12: begin
          DrawThinLine(Canvas, ItemRect.Left, Y - 1, ItemRect.Right, Y - 1);
          DrawThinLine(Canvas, ItemRect.Left, Y, ItemRect.Right, Y);
          DrawThinLine(Canvas, ItemRect.Left, Y + 1, ItemRect.Right, Y + 1);
        end;
    13: begin
          DrawThinLine(Canvas, ItemRect.Left, Y - 1, ItemRect.Right, Y - 1);
          DrawThinLine(Canvas, ItemRect.Left, Y + 1, ItemRect.Right, Y + 1);
        end;
  end;
  inherited;
end;

function TNxLineStyleList.GetCount: Integer;
begin
  Result := 14;
end;

function TNxLineStyleList.GetItemHeight: Integer;
begin
  Result := 13;
end;

function TNxLineStyleList.GetItemWidth: Integer;
begin
  Result := 35;
end;

function TNxLineStyleList.GetLineStyle: TLineStyle;
begin
  case ItemIndex of
    0:  Result := lsNone;
    1:  Result := lsThinDot;
    2:  Result := lsDot;
    3:  Result := lsDashDotDot;
    4:  Result := lsDashDot;
    5:  Result := lsWideDot;
    6:  Result := lsThinLine;
    7:  Result := lsWeightDashDotDot;
    else Result := lsNone;
  end;
end;

procedure TNxLineStyleList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FBorderPicker) and (Operation = opRemove)
    then FBorderPicker := nil;
end;

procedure TNxLineStyleList.SetBorderPicker(const Value: TNxBorderPicker);
begin
  FBorderPicker := Value;
  FreeNotification(FBorderPicker);
  Invalidate;
end;

procedure TNxLineStyleList.SetLineColor(const Value: TColor);
begin
  FLineColor := Value;
  DoChange;
  Invalidate;
end;

procedure TNxLineStyleList.SetLineStyle(const Value: TLineStyle);
begin
  case Value of
    lsNone: ItemIndex := 0;
    lsThinDot: ItemIndex := 1;
    lsDot: ItemIndex := 2;
    lsDashDotDot: ItemIndex := 3;
    lsDashDot: ItemIndex := 4;
    lsWideDot: ItemIndex := 5;
    lsThinLine: ItemIndex := 6;
    lsWeightDashDotDot: ItemIndex := 7;
  end;
end;

{ TNxBorderPicker }

constructor TNxBorderPicker.Create(AOwner: TComponent);
begin
  inherited;
  FBorderBottom := TNxCellBorder.Create(nil, bpsBottom);
  FBorderLeft := TNxCellBorder.Create(nil, bpsLeft);
  FBorderRight := TNxCellBorder.Create(nil, bpsRight);
  FBorderTop := TNxCellBorder.Create(nil, bpsTop);
  FColCount := 1;
  FRowCount := 1;
  FSelected := TNxCellBorder.Create(nil, bpsNone);
  Width := 150;
  Height := 98;
  ParentColor := False;
  Color := clWindow;
end;

destructor TNxBorderPicker.Destroy;
begin
  FBorderBottom.Free;
  FBorderLeft.Free;
  FBorderRight.Free;
  FBorderTop.Free;
  FSelected.Free;
  inherited;
end;

procedure TNxBorderPicker.DoBorderClick(Position: TBorderPosition);
begin
  if Assigned(FOnBorderClick) then FOnBorderClick(Self, Position);
end;

procedure TNxBorderPicker.DrawBorder(X1, Y1, X2, Y2: Integer;
  Border: TNxCellBorder);
begin
  Canvas.Pen.Color := Border.Color;

{  TLineStyle = (lsNone, lsThinDot, lsDot, lsDashDotDot, lsDashDot, lsWideDot,
    lsThinLine, lsWeightDashDotDot, lsSkewDastDot, lsWeightDashDot, lsWeightDash,
    lsSolid, lsWeightSolid, lsDouble);}

  case Border.LineStyle of
    lsThinDot: DrawThinDotLine(Canvas, X1, Y1, X2, Y2);
    lsDot: DrawDotLine(Canvas, X1, Y1, X2, Y2);
    lsDashDotDot: DrawDashDotDotLine(Canvas, X1, Y1, X2, Y2);
    lsDashDot: DrawDashDotLine(Canvas, X1, Y1, X2, Y2);
    lsWideDot: DrawWideDotLine(Canvas, X1, Y1, X2, Y2);
    lsThinLine: DrawThinLine(Canvas, X1, Y1, X2, Y2);
    lsWeightDashDotDot:
      case Border.Position of
        bpsTop, bpsBottom:
        begin
          DrawDashDotDotLine(Canvas, X1, Y1, X2, Y2);
          DrawDashDotDotLine(Canvas, X1, Y1 - 1, X2, Y2 - 1);
        end;
        bpsLeft, bpsRight:
        begin
          DrawDashDotDotLine(Canvas, X1, Y1, X2, Y2);
          DrawDashDotDotLine(Canvas, X1 - 1, Y1, X2 - 1, Y2);
        end;
      end;
    lsSkewDastDot: Exit;
    lsWeightDashDot: Exit;
    lsWeightDash: Exit;
    lsSolid: Exit;
    lsWeightSolid: Exit;
    lsDouble: Exit;
  end;
end;

procedure TNxBorderPicker.DrawBorders;
begin
  DrawBorder(10, 10, 10, ClientHeight - 10, BorderLeft);
  DrawBorder(10, 10, ClientWidth - 10, 10, BorderTop);
  DrawBorder(10, ClientHeight - 10, ClientWidth - 10, ClientHeight - 10, BorderBottom);
  DrawBorder(ClientWidth - 10, 10, ClientWidth - 10, ClientHeight - 10, BorderRight);
end;

procedure TNxBorderPicker.DrawGrips;
var
  X, Y: Integer;
begin
  with Canvas do
  begin
    Pen.Color := clGray;
    MoveTo(5, 10);
    LineTo(10, 10);
    MoveTo(10, 9);
    LineTo(10, 4);
    MoveTo(ClientWidth - 10, 5);
    LineTo(ClientWidth - 10, 10);
    LineTo(ClientWidth - 5, 10);
    MoveTo(10, ClientHeight - 6);
    LineTo(10, ClientHeight - 10);
    LineTo(4, ClientHeight - 10);
    MoveTo(ClientWidth - 10, ClientHeight - 6);
    LineTo(ClientWidth - 10, ClientHeight - 10);
    LineTo(ClientWidth - 5, ClientHeight - 10);
    if ColCount = 2 then
    begin
      X := ClientWidth div 2;
      Polyline([Point(X, 5), Point(X, 9)]);
      Polyline([Point(X - 3, 9), Point(X + 3, 9)]);
      Polyline([Point(X, ClientHeight - 6), Point(X, ClientHeight - 9)]);
      Polyline([Point(X - 3, ClientHeight - 9), Point(X + 3, ClientHeight - 9)]);
    end;
    if RowCount = 2 then
    begin
      Y := ClientHeight div 2;
      Polyline([Point(5, Y), Point(9, Y)]);
      Polyline([Point(9, Y - 3), Point(9, Y + 3)]);
      Polyline([Point(ClientWidth - 6, Y), Point(ClientWidth - 9, Y)]);
      Polyline([Point(ClientWidth - 9, Y - 3), Point(ClientWidth - 9, Y + 3)]);
    end;
  end;
end;

function TNxBorderPicker.GetBorderAtPos(X, Y: Integer): TNxCellBorder;
begin
  Result := nil;
  if X <= 20 then
  begin
    Result := FBorderLeft;
  end else if X > ClientWidth - 20 then
  begin
    Result := FBorderRight;
  end else if Y <= 20 then
  begin
    Result := FBorderTop;
  end else if Y >= ClientHeight - 20 then
  begin
    Result := FBorderBottom; 
  end;
end;

procedure TNxBorderPicker.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ABorder: TNxCellBorder;
begin
  inherited;
  ABorder := GetBorderAtPos(X, Y);
  if Assigned(ABorder) then
  begin
    if (ABorder.LineStyle = Selected.LineStyle) and (ABorder.Color = Selected.Color) then
      ABorder.LineStyle := lsNone else ABorder.Assign(FSelected);
    DoBorderClick(ABorder.Position); { event }
    RefreshBorder(ABorder);
  end;
end;

procedure TNxBorderPicker.Paint;
var
  R: TRect;
begin
  inherited;
  if IsThemed then ThemeRect(Handle, Canvas.Handle, ClientRect, teListView, 1, 1) else
  begin
    R := ClientRect;
    DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_PUSHED);
    InflateRect(R, -2, -2);
    Canvas.Brush.Color := Color;
    Canvas.FillRect(R);
  end;
  DrawBorders;
  DrawGrips;
end;

procedure TNxBorderPicker.RefreshBorder(Border: TNxCellBorder);
var
  R: TRect;
begin
  case Border.Position of
    bpsLeft: R := Rect(9, 10, 12, ClientHeight - 9);
    bpsTop: R := Rect(10, 9, ClientWidth - 9, 12);
    bpsRight: R := Rect(ClientWidth - 8, 10, ClientWidth - 11, ClientHeight - 9);
    bpsBottom: R := Rect(10, ClientHeight - 8, ClientWidth - 9, ClientHeight - 11);
  end;
  InvalidateRect(Handle, @R, False);
end;

procedure TNxBorderPicker.SetBorderBottom(const Value: TNxCellBorder);
begin
  FBorderBottom.Assign(Value);
  Invalidate;
end;

procedure TNxBorderPicker.SetBorderLeft(const Value: TNxCellBorder);
begin
  FBorderLeft.Assign(Value);
  Invalidate;
end;

procedure TNxBorderPicker.SetBorderRight(const Value: TNxCellBorder);
begin
  FBorderRight.Assign(Value);
  Invalidate;
end;

procedure TNxBorderPicker.SetBorderTop(const Value: TNxCellBorder);
begin
  FBorderTop.Assign(Value);
  Invalidate;
end;

procedure TNxBorderPicker.SetColCount(const Value: TCellCount);
begin
  FColCount := Value;
  Invalidate;
end;

procedure TNxBorderPicker.SetRowCount(const Value: TCellCount);
begin
  FRowCount := Value;
  Invalidate;
end;

procedure TNxBorderPicker.SetSelected(const Value: TNxCellBorder);
begin
  FSelected := Value;
end;

end.
