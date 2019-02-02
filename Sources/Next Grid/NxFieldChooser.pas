{
  Next Grid
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxFieldChooser.pas 12/25/2002 7:10:16 bn
}

unit NxFieldChooser;

interface

uses
  Classes, Types, Graphics, Controls, ExtCtrls, Messages, Windows,
  NxClasses, NxScrollControl, NxSharedCommon, NxColumns, NxFlyoutControl,
  NxColumnDragBox, NxCustomGrid;

const
  sizButtonHeight = 19;
  spDragBoxToCursorSpace = 4;

resourcestring
  strNoFieldsAvailable = '(no fields available)';

type
  TNxFieldChooser = class;
  TSelectSlideEvent = procedure (Sender: TObject; Column: TNxCustomColumn) of object;

  TNxFieldDragBox = class(TNxFlyoutControl)
  private
    FCaption: string;
    FDragDropColumn: TNxCustomColumn;
    FOwner: TNxFieldChooser;
    procedure SetCaption(const Value: string);
  protected
    function GetColumnDropRect: TRect;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure UpdateArrows(X, Y: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Open;
    property Caption: string read FCaption write SetCaption;
  end;

  TNxFieldCategory = class(TCollectionItem)
  private
    FList: TList;
    FCaption: string;
    FOwner: TNxFieldChooser;
    function GetColumns(Index: Integer): TNxCustomColumn;
    procedure SetCaption(const Value: string);
  protected
    procedure ColumnNotification(Sender: TNxCustomColumn; Operation:
      TColumnNotifyOperation);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Add(Column: TNxCustomColumn);
    procedure AddAllColumns;
    procedure Delete(Index: Integer);
    property Columns[Index: Integer]: TNxCustomColumn read GetColumns;
  published
    property Caption: string read FCaption write SetCaption;
  end;

  TNxFieldCategories = class(TCollection)
  private
    FOwner: TNxFieldChooser;
    function GetItem(Index: Integer): TNxFieldCategory;
    procedure SetItem(Index: Integer; const Value: TNxFieldCategory);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TNxFieldChooser);
    function Add: TNxFieldCategory;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
    property Items[Index: Integer]: TNxFieldCategory read GetItem write SetItem; default;
  end;

  TNxFieldChooser = class(TNxScrollControl)
  private
    FAssociate: TNxCustomGrid;
    FCategories: TNxFieldCategories;
    FCategory: Integer;
    FDownDragArrow: TDragArrow;
    FDragBox: TNxFieldDragBox;
    FEmptyCaption: WideString;
    FFirstRow: Integer;
    FItemIndex: Integer;
    FMouseDown: Boolean;
    FMouseDownPoint: TPoint;
    FMoving: Boolean;
    FUpDragArrow: TDragArrow;
    FVisibleFields: Integer;
    function GetCategoryCount: Integer;
    function GetColumns(Index: Integer): TNxCustomColumn;
    function GetFieldCount: Integer;
    function IsShown(Column: TNxCustomColumn): Boolean;
    procedure SetAssociate(const Value: TNxCustomGrid);
    procedure SetCategory(const Value: Integer);
    procedure SetEmptyCaption(const Value: WideString);
    procedure SetItemIndex(const Value: Integer);
  protected
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function GetItemAtPos(X, Y: Integer): Integer;
    function GetItemRect(Index: Integer): TRect;
    function GetVertOffset(FromPos, ToPos: Integer): Integer; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DrawItem(ItemRect: TRect; Index: Integer);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure RefreshItem(Index: Integer);
    procedure ShowDragBox(X, Y: Integer);
    procedure UpdateVertScrollBar;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddCategory(Caption: string): TNxFieldCategory;
    procedure AddColumn(Category: Integer; Column: TNxCustomColumn);
    procedure DeleteCategory(Index: Integer);
    property Category: Integer read FCategory write SetCategory;
    property CategoryCount: Integer read GetCategoryCount;
    property Columns[Index: Integer]: TNxCustomColumn read GetColumns;
    property FieldCount: Integer read GetFieldCount;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
  published
    property Align;
    property Anchors;
    property Associate: TNxCustomGrid read FAssociate write SetAssociate;
    property Categories: TNxFieldCategories read FCategories;
    property Color;
    property Constraints;
    property Enabled;
    property EmptyCaption: WideString read FEmptyCaption write SetEmptyCaption;
    property Font;
    property ShowHint;
    property ParentShowHint;
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
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TDesignerState = set of (dsMoving, dsSizingRight, dsSizingBottom,
    dsSizingBottomRight);
  TSizeGrip = (sgNone, sgMove, sgTopLeft, sgTop, sgTopRight, sgRight, sgBottomRight,
    sgBottom, sgBottomLeft, sgLeft);

  TNxSlidesDesigner = class(TCustomControl)
  private
    FAssociate: TNxCustomGrid;
    FDownX: Integer;
    FDownY: Integer;
    FDrawBorders: Boolean;
    FGridXSize: Integer;
    FGridYSize: Integer;
    FHintWindow: THintWindow;
    FMoveX: Integer;
    FMoveY: Integer;
    FOnChange: TNotifyEvent;
    FOnSelectSlide: TSelectSlideEvent;
    FSelected: TNxCustomColumn;
    FSelectedGrip: TSizeGrip;
    FShowGrid: Boolean;
    FSnapToGrid: Boolean;
    FState: TDesignerState;
    procedure SetAssociate(const Value: TNxCustomGrid);
    procedure SetDrawBorders(const Value: Boolean);
    procedure SetGridXSize(const Value: Integer);
    procedure SetGridYSize(const Value: Integer);
    procedure SetSelected(const Value: TNxCustomColumn);
    procedure SetShowGrid(const Value: Boolean);
    procedure SetSnapToGrid(const Value: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoChange; dynamic;
    procedure DoSelectSlide(Column: TNxCustomColumn); dynamic;
    procedure DrawGrips(const SlideRect: TRect);
    procedure DrawSlide(const SlideRect: TRect; Column: TNxCustomColumn);
    procedure DrawSlideCaption(Column: TNxCustomColumn);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure RefreshSlide(Column: TNxCustomColumn; const Selected: Boolean = True);
    procedure ShowHintWindow(X, Y: Integer; Value: string);
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    property State: TDesignerState read FState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AlignToGrid(Column: TNxCustomColumn);
    function GetGripAtPos(const X, Y: Integer; SlideRect: TRect): TSizeGrip;
    function GetGripCursor(const SizeGrip: TSizeGrip): TCursor;
    function GetGripRect(const SizeGrip: TSizeGrip; SlideRect: TRect): TRect;
    function GetSlideAtPos(const X, Y: Integer): TNxCustomColumn;
    function GetSlideCaptionRect(Column: TNxCustomColumn): TRect;
    procedure OffsetSlide(Column: TNxCustomColumn; dx, dy: Integer);
    procedure ResizeSlide(Column: TNxCustomColumn; dx, dy: Integer);
    property Selected: TNxCustomColumn read FSelected write SetSelected;
    property SelectedGrip: TSizeGrip read FSelectedGrip;
  published
    property Align;
    property Associate: TNxCustomGrid read FAssociate write SetAssociate;
    property Color;
    property Constraints;
    property DrawBorders: Boolean read FDrawBorders write SetDrawBorders default True;
    property Enabled;
    property Font;
    property GridXSize: Integer read FGridXSize write SetGridXSize default 8;
    property GridYSize: Integer read FGridYSize write SetGridYSize default 8;
    property ShowGrid: Boolean read FShowGrid write SetShowGrid default True;
    property ShowHint;
    property SnapToGrid: Boolean read FSnapToGrid write SetSnapToGrid default True;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSelectSlide: TSelectSlideEvent read FOnSelectSlide write FOnSelectSlide;
  end;

implementation

uses SysUtils, Forms, Dialogs, NxGridCommon;

{ TNxFieldDragBox }

constructor TNxFieldDragBox.Create(AOwner: TComponent);
begin
  inherited;
  FOwner := TNxFieldChooser(AOwner);
  Height := sizButtonHeight;
end;

procedure TNxFieldDragBox.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

function TNxFieldDragBox.GetColumnDropRect: TRect;
var
	r: Integer;
begin
  with FOwner.Associate do
  begin
  	r := GetHeaderRect.Right;
    if r > ClientWidth then r := ClientWidth;
    Result := Rect(0, 0, r, GetBodyRect.Top);
  end;
end;

procedure TNxFieldDragBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  APoint, CursorPoint, BoxPoint: TPoint;
begin
  APoint := ClientToScreen(Point(X, Y));
  with BoxPoint do
  begin
    X := APoint.X - ClientWidth div 2;
    Y := APoint.Y - ClientHeight + spDragBoxToCursorSpace;
  end;
  with CursorPoint do
  begin
    X := APoint.X;
    Y := APoint.Y;
  end;
  SetBounds(BoxPoint.X, BoxPoint.Y, ClientWidth, ClientHeight);
  UpdateArrows(APoint.X, APoint.Y);
end;

procedure TNxFieldDragBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  CursorPoint, ClickPoint: TPoint;
  CurrPos, NewPos: Integer;
begin
	if Button = mbLeft then
  begin
    Visible := False;
    CursorPoint := ClientToScreen(Point(X, Y));
    ClickPoint := FOwner.FAssociate.ScreenToClient(CursorPoint);
    FOwner.FMouseDown := False;
    Screen.Cursor := crDefault;
    FOwner.FAssociate.HideArrows;
    if Assigned(FDragDropColumn) then
    begin
      CurrPos := FOwner.Columns[FOwner.FItemIndex].Position;
      NewPos := FOwner.Associate.GetNearestPosition(FDragDropColumn, ClickPoint);
      FOwner.Associate.Columns.ChangePosition(CurrPos, NewPos);
      FOwner.Categories.Items[FOwner.Category].Columns[FOwner.FItemIndex].Visible := True;
      FDragDropColumn := nil;
    end;
  end;
end;

procedure TNxFieldDragBox.Paint;
var
  r: TRect;
begin
  inherited;
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(ClientRect);
  r := ClientRect;
  Frame3D(Canvas, r, clBtnHighlight, clBtnShadow, 1);
  Canvas.Font.Assign(Font);
  DrawTextRect(Canvas, r, taCenter, Caption);
end;

procedure TNxFieldDragBox.Open;
begin
  SendMessage(Handle, WM_LBUTTONDOWN, 0, 0); { do MouseDown }
end;

procedure TNxFieldDragBox.UpdateArrows(X, Y: Integer);
var
  MovePoint: TPoint;
  NewPos: Integer;
begin
  MovePoint := FOwner.Associate.ScreenToClient(Point(X, Y));
  FDragDropColumn := nil;
  with FOwner do
  begin
    if PtInRect(GetColumnDropRect, MovePoint)
      or ((FAssociate.Columns.VisibleCount = 0) and PtInRect(FAssociate.ClientRect, MovePoint)) then
    begin
      FDragDropColumn := Columns[FItemIndex];
      NewPos := FAssociate.GetNearestPosition(FDragDropColumn, MovePoint);
      FAssociate.UpdateArrows(Columns[FItemIndex].Position, NewPos, True);
      Screen.Cursor := crDefault;
    end else
    begin
      FAssociate.HideArrows;
      Screen.Cursor := crNo;
    end;
  end;
end;

{ TNxFieldCategory }

constructor TNxFieldCategory.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FList := TList.Create;
  FOwner := TNxFieldCategories(Collection).FOwner;
end;

destructor TNxFieldCategory.Destroy;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    Columns[i].UnregisterNotification(ColumnNotification);
  FreeAndNil(FList);
  inherited;
end;

function TNxFieldCategory.GetColumns(Index: Integer): TNxCustomColumn;
begin
  Result := TNxCustomColumn(FList[Index]);
end;

procedure TNxFieldCategory.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TNxFieldCategory.ColumnNotification(Sender: TNxCustomColumn;
  Operation: TColumnNotifyOperation);
begin
  if (Operation = ccVisibleChange) and (Index = FOwner.Category)
    and (FList.IndexOf(Sender) <> -1) then
  begin
    case Sender.Visible of
      True: Dec(FOwner.FVisibleFields);
      False: Inc(FOwner.FVisibleFields);
    end;
    FOwner.Invalidate;
    FOwner.UpdateVertScrollBar;
  end;
end;

procedure TNxFieldCategory.AddAllColumns;
var
  I: Integer;
begin
  for I := 0 to FOwner.FAssociate.Columns.Count - 1 do
    Add(FOwner.FAssociate.Columns[i]);
end;

procedure TNxFieldCategory.Add(Column: TNxCustomColumn);
begin
  if FList.IndexOf(Column) = -1 then
  begin
    FList.Add(Column);
    if Index = FOwner.FCategory then FOwner.RefreshItem(FList.IndexOf(Column));
    Column.RegisterNotification(ColumnNotification);
    if FOwner.IsShown(Column) then Inc(FOwner.FVisibleFields);
  end;
end;
                                       
procedure TNxFieldCategory.Delete(Index: Integer);
begin
  if FOwner.IsShown(Columns[Index]) then Dec(FOwner.FVisibleFields);
  FList.Delete(Index);
  FOwner.Invalidate;
end;

{ TNxFieldChooser }

constructor TNxFieldChooser.Create(AOwner: TComponent);
begin
  inherited;
  ScrollStyle := ScrollStyle - [rsRoll];
  FCategories := TNxFieldCategories.Create(Self);
  FDownDragArrow := TDragArrow.Create(Self);
  FDownDragArrow.Visible := False;
  FDownDragArrow.ArrowKind := akDown;
  FEmptyCaption := strNoFieldsAvailable; 
  FUpDragArrow := TDragArrow.Create(Self);
  FUpDragArrow.Visible := False;
  FUpDragArrow.ArrowKind := akUp;
  FDragBox := TNxFieldDragBox.Create(Self);
  FDragBox.Visible := False;
  FFirstRow := 0;
  FItemIndex := -1;
  FMoving := False;
  FMouseDown := False;
  FVisibleFields := 0;
  ParentColor := False;
  Color := clWindow;
  Width := 170;
  Height := 228;
end;

destructor TNxFieldChooser.Destroy;
begin
  FreeAndNil(FCategories);
  FreeAndNil(FDownDragArrow);
  FreeAndNil(FDragBox);
  FreeAndNil(FUpDragArrow);
  inherited;
end;

procedure TNxFieldChooser.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TNxFieldChooser.CreateWnd;
begin
  inherited;
  FDownDragArrow.Parent := Self;
  FUpDragArrow.Parent := Self;
  FDragBox.Parent := Self;
  HorzScrollBar.Visible := False;
  VertScrollBar.Max := 0;
//  VertScrollBar.Visible := True;
  VertScrollBar.Enabled := False;   
  VertScrollBar.AutoHide := False;
end;

function TNxFieldChooser.GetCategoryCount: Integer;
begin
  Result := FCategories.Count;
end;

procedure TNxFieldChooser.SetAssociate(const Value: TNxCustomGrid);
begin
  FAssociate := Value;
  if Assigned(FAssociate) then FreeNotification(FAssociate);
end;

procedure TNxFieldChooser.SetCategory(const Value: Integer);
var
  i: Integer;
begin
  FCategory := Value;
  FVisibleFields := 0;
  for i := 0 to Categories[FCategory].FList.Count - 1 do
    if IsShown(Columns[i]) then Inc(FVisibleFields);
  UpdateVertScrollBar;
  Invalidate;
end;

function TNxFieldChooser.GetColumns(Index: Integer): TNxCustomColumn;
begin
  Result := Categories[Category].Columns[Index];
end;

function TNxFieldChooser.GetFieldCount: Integer;
begin
  Result := Categories[Category].FList.Count;
end;

procedure TNxFieldChooser.SetItemIndex(const Value: Integer);
begin
  FItemIndex := Value;
end;

function TNxFieldChooser.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  inherited DoMouseWheelDown(Shift, MousePos);
  VertScrollBar.Next;
  Result := True;
end;

function TNxFieldChooser.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  inherited DoMouseWheelUp(Shift, MousePos);
  VertScrollBar.Prior;
  Result := True;
end;

function TNxFieldChooser.GetItemAtPos(X, Y: Integer): Integer;
var
  i, ATop: Integer;
begin
  ATop := 0;
  Result := -1;
  for i := VertScrollBar.Position to Categories[Category].FList.Count - 1 do
  begin
    if IsShown(Categories[Category].Columns[i]) then
    begin
      if (Y >= ATop) and (Y < ATop + sizButtonHeight) then
      begin
        Result := i;
        Exit;
      end;
      Inc(ATop, sizButtonHeight);
    end;
  end;
end;

function TNxFieldChooser.GetItemRect(Index: Integer): TRect;
var
  i: Integer;
begin
  with Result do
  begin
    Top := 0;
    Left := 0;
    Right := ClientWidth;
    for i := VertScrollBar.Position to Index - 1 do
      if IsShown(Categories[Category].Columns[i])
        then Inc(Top, sizButtonHeight);
    Bottom := Top + sizButtonHeight;
  end;
end;

function TNxFieldChooser.GetVertOffset(FromPos, ToPos: Integer): Integer;
var
  I, C: Integer;
begin
  Result := 0;
  if FromPos < ToPos then
  begin
    C := 0;
    while FFirstRow < Categories[Category].FList.Count do
    begin
      if IsShown(Columns[FFirstRow]) then
      begin
        Inc(C);
        if C > (ToPos - FromPos) then Break;
        Dec(Result, sizButtonHeight);
      end;
      Inc(FFirstRow);
    end;
  end;

  if FromPos > ToPos then
  begin
    I := FFirstRow - 1;
    C := 0;
    while (I >= 0) and (C < FromPos - ToPos) do
    begin
      Dec(FFirstRow);
      if IsShown(Columns[I]) then
      begin
        Inc(C);
        Inc(Result, sizButtonHeight);
      end;
      Dec(I);
    end;
  end;
end;

procedure TNxFieldChooser.DrawItem(ItemRect: TRect; Index: Integer);
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(ItemRect);
    Frame3D(Canvas, ItemRect, clBtnFace, cl3DDkShadow, 1);
    Pen.Color := clBtnHighlight;
    Polyline([
      Point(ItemRect.Left, ItemRect.Bottom - 2),
      Point(ItemRect.Left, ItemRect.Top),
      Point(ItemRect.Right, ItemRect.Top)]);
    InflateRect(ItemRect, -1, -1);
    Pen.Color := clBtnShadow;
    Polyline([
      Point(ItemRect.Right, ItemRect.Top - 1),
      Point(ItemRect.Right, ItemRect.Bottom),
      Point(ItemRect.Left - 2, ItemRect.Bottom)]);
    Font.Assign(Self.Font);
    DrawTextRect(Canvas, ItemRect, taLeftJustify, Categories[Category].Columns[Index].Header.Caption);
    if FItemIndex = Index then
    begin
      CopyMode := cmDstInvert;
      CopyRect(ItemRect, Canvas, ItemRect);
      CopyMode := cmSrcCopy;
    end;
  end;
end;

procedure TNxFieldChooser.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FAssociate) and (Operation = opRemove) then FAssociate := nil;
end;

procedure TNxFieldChooser.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  FOldIndex: Integer;
begin
  inherited;
  if CanFocus then SetFocus;
  if FVisibleFields = 0 then Exit;
  if Button = mbLeft then
  begin
    FOldIndex := FItemIndex;
    FItemIndex := GetItemAtPos(X, Y);
    if FItemIndex > FAssociate.Columns.Count - 1 then
      FItemIndex := FOldIndex;
    if FOldIndex <> FItemIndex then
    begin
      RefreshItem(FOldIndex);
      RefreshItem(FItemIndex);
    end;
    FMouseDownPoint := Point(X, Y);
    FMouseDown := True;
  end;
end;

procedure TNxFieldChooser.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FMouseDown and (FItemIndex <> -1) then
  begin
    if (Abs(X - FMouseDownPoint.X) >= 2)
      or (Abs(Y - FMouseDownPoint.Y) >= 2) then ShowDragBox(X, Y);
  end;
end;

procedure TNxFieldChooser.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  FMoving := False;
  FMouseDown := False;
end;

procedure TNxFieldChooser.Paint;
var
  i, Bottom: Integer;
begin
  inherited;
  VertScrollClipRect := ClientRect;
  Bottom := 0;
  with Canvas do
  begin
    if Assigned(FAssociate) and (FCategories.Count > 0)
      and (FVisibleFields > 0) then
    begin
      for i := FFirstRow to Categories[Category].FList.Count - 1 do
        if IsShown(Categories[Category].Columns[i]) then
        begin
          DrawItem(Rect(0, Bottom, ClientWidth, Bottom + sizButtonHeight), i);
          Inc(Bottom, sizButtonHeight);
        end;
      Brush.Color := Self.Color;
      FillRect(Rect(0, Bottom, ClientWidth, ClientHeight));
    end else
    begin
      Brush.Color := clBtnFace;
      FillRect(ClientRect);
      Font.Assign(Self.Font);
      Font.Color := clGrayText;
      DrawTextRect(Canvas, ClientRect, taCenter, FEmptyCaption);
    end;
  end;
end;

procedure TNxFieldChooser.RefreshItem(Index: Integer);
var
  r: TRect;
begin
  r := GetItemRect(Index);
  InvalidateRect(Handle, @r, False);
end;

procedure TNxFieldChooser.ShowDragBox(X, Y: Integer);
var
  ScreenPoint: TPoint;
begin
  with FDragBox do
  begin
    ScreenPoint := ClientToScreen(Point(X, Y));
    Caption := Categories[Category].Columns[FItemIndex].Header.Caption;
    Font.Assign(Self.Font);
    SetBounds(ScreenPoint.X - (Self.ClientWidth div 2), ScreenPoint.Y, Self.ClientWidth, sizButtonHeight);
    Visible := True;
    Open;
  end;
end;

procedure TNxFieldChooser.UpdateVertScrollBar;
begin
  VertScrollBar.Max := FVisibleFields - (ClientHeight div sizButtonHeight);
end;

function TNxFieldChooser.AddCategory(Caption: string): TNxFieldCategory;
begin
  Result := Categories.Add;
  Result.Caption := Caption;
end;

procedure TNxFieldChooser.DeleteCategory(Index: Integer);
begin
  FCategories.Delete(Index);
end;

procedure TNxFieldChooser.AddColumn(Category: Integer; Column: TNxCustomColumn);
begin

end;

function TNxFieldChooser.IsShown(
  Column: TNxCustomColumn): Boolean;
begin
  Result := not Column.Visible;
end;

procedure TNxFieldChooser.SetEmptyCaption(const Value: WideString);
begin
  FEmptyCaption := Value;
  Invalidate;
end;

{ TNxFieldCategories }

constructor TNxFieldCategories.Create(AOwner: TNxFieldChooser);
begin
  inherited Create(TNxFieldCategory);
  FOwner := AOwner;
end;

function TNxFieldCategories.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TNxFieldCategories.GetItem(Index: Integer): TNxFieldCategory;
begin
  Result := TNxFieldCategory(inherited GetItem(Index));
end;

procedure TNxFieldCategories.SetItem(Index: Integer;
  const Value: TNxFieldCategory);
begin
  inherited SetItem(Index, Value);
end;

function TNxFieldCategories.Add: TNxFieldCategory;
begin
  Result := TNxFieldCategory(inherited Add);
end;

procedure TNxFieldCategories.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;

end;

{ TNxSlidesDesigner }

procedure TNxSlidesDesigner.AlignToGrid(Column: TNxCustomColumn);
begin
  if Assigned(Column) then
  begin
    RefreshSlide(Column);
    with Column.SlideBounds do
    begin
      Left := (Left div FGridXSize) * FGridXSize;
      Top := (Top div FGridXSize) * FGridYSize;
    end;
    RefreshSlide(Column);
  end;
end;

constructor TNxSlidesDesigner.Create(AOwner: TComponent);
begin
  inherited;
  FDrawBorders := True;
  FGridXSize := 8;
  FGridYSize := 8;
  FHintWindow := HintWindowClass.Create(Self);
  FHintWindow.Color := Application.HintColor;
  FShowGrid := True;
  FSnapToGrid := True;
  Width := 245;
  Height := 165;
end;

destructor TNxSlidesDesigner.Destroy;
begin
  FreeAndNil(FHintWindow);
  inherited;
end;

procedure TNxSlidesDesigner.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params.WindowClass do Style := Style and not(CS_HREDRAW or CS_VREDRAW);
end;

procedure TNxSlidesDesigner.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxSlidesDesigner.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FAssociate) and (Operation = opRemove) then FAssociate := nil;
end;

procedure TNxSlidesDesigner.SetAssociate(const Value: TNxCustomGrid);
begin
  FAssociate := Value;
  Invalidate;
end;

procedure TNxSlidesDesigner.SetDrawBorders(const Value: Boolean);
begin
  FDrawBorders := Value;
  Invalidate;
end;

procedure TNxSlidesDesigner.SetGridXSize(const Value: Integer);
begin
  FGridXSize := Value;
  Invalidate;
end;

procedure TNxSlidesDesigner.SetGridYSize(const Value: Integer);
begin
  FGridYSize := Value;
  Invalidate;
end;

procedure TNxSlidesDesigner.SetSelected(const Value: TNxCustomColumn);
begin
  if FSelected <> Value then
  begin
    if FSelected <> nil then RefreshSlide(FSelected);
    FSelected := Value;
    if FSelected <> nil then RefreshSlide(FSelected);
    DoSelectSlide(FSelected);
  end;
end;

procedure TNxSlidesDesigner.SetShowGrid(const Value: Boolean);
begin
  FShowGrid := Value;
  Invalidate;
end;

procedure TNxSlidesDesigner.SetSnapToGrid(const Value: Boolean);
begin
  FSnapToGrid := Value;
end;

function TNxSlidesDesigner.GetGripAtPos(const X, Y: Integer; SlideRect: TRect): TSizeGrip;
begin
  Result := sgNone;
  if PtInRect(GetGripRect(sgTopLeft, SlideRect), Point(X, Y)) then Result := sgTopLeft else
  if PtInRect(GetGripRect(sgTop, SlideRect), Point(X, Y)) then Result := sgTop else
  if PtInRect(GetGripRect(sgTopRight, SlideRect), Point(X, Y)) then Result := sgTopRight else
  if PtInRect(GetGripRect(sgRight, SlideRect), Point(X, Y)) then Result := sgRight else
  if PtInRect(GetGripRect(sgBottomRight, SlideRect), Point(X, Y)) then Result := sgBottomRight else
  if PtInRect(GetGripRect(sgBottom, SlideRect), Point(X, Y)) then Result := sgBottom else
  if PtInRect(GetGripRect(sgBottomLeft, SlideRect), Point(X, Y)) then Result := sgBottomLeft else
  if PtInRect(GetGripRect(sgLeft, SlideRect), Point(X, Y)) then Result := sgLeft else
  if PtInRect(SlideRect, Point(X, Y)) then Result := sgMove;
end;

function TNxSlidesDesigner.GetGripCursor(
  const SizeGrip: TSizeGrip): TCursor;
begin
  case SizeGrip of
    sgMove: Result := crSizeAll;
    sgTopLeft: Result := crSizeNWSE;
    sgTop: Result := crSizeNS;
    sgTopRight: Result := crSizeNESW;
    sgRight: Result := crSizeWE;
    sgBottomRight: Result := crSizeNWSE;
    sgBottom: Result := crSizeNS;
    sgBottomLeft: Result := crSizeNESW;
    sgLeft: Result := crSizeWE
    else Result := crDefault;
  end;
end;

function TNxSlidesDesigner.GetGripRect(const SizeGrip: TSizeGrip;
  SlideRect: TRect): TRect;
var
  HorzMiddle, VertMiddle: Integer;
begin
  with SlideRect do
  begin
    HorzMiddle := SlideRect.Left + (SlideRect.Right - SlideRect.Left) div 2;
    VertMiddle := SlideRect.Top + (SlideRect.Bottom - SlideRect.Top) div 2;
    case SizeGrip of
      sgLeft: Result := Rect(Left - 5, VertMiddle - 3, Left + 1, VertMiddle + 3);
      sgTopLeft: Result := Rect(Left - 5, Top - 5, Left + 1, Top + 1);
      sgTop: Result := Rect(HorzMiddle - 3, Top - 5, HorzMiddle + 3, Top + 1);
      sgBottomLeft: Result := Rect(Left - 5, Bottom - 1, Left + 1, Bottom + 5);
      sgRight: Result := Rect(Right - 1, VertMiddle - 3, Right + 5, VertMiddle + 3);
      sgTopRight: Result := Rect(Right - 1, Top - 5, Right + 5, Top + 1);
      sgBottom: Result := Rect(HorzMiddle - 3, Bottom - 1, HorzMiddle + 3, Bottom + 5);
      sgBottomRight: Result := Rect(Right - 1, Bottom - 1, Right + 5, Bottom + 5);
    end;
  end;
end;

function TNxSlidesDesigner.GetSlideAtPos(const X,
  Y: Integer): TNxCustomColumn;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FAssociate.Columns.Count - 1 do
    if PtInRect(FAssociate.Columns[I].SlideRect, Point(X, Y)) then
    begin
      Result := FAssociate.Columns[I];
      Exit;
    end;
end;

function TNxSlidesDesigner.GetSlideCaptionRect(
  Column: TNxCustomColumn): TRect;
var
  TextHeight, TextWidth: Integer;
begin
  Result := Column.SlideRect;
  case Column.SlideCaptionLocation of
    clLeft:
    begin
      TextWidth := Canvas.TextWidth(Column.SlideCaption);
      Result.Right := Result.Left;
      Result.Left := Result.Left - (TextWidth + spCellTextMargin);
    end;
    clTop:
    begin
      TextHeight := Canvas.TextHeight(Column.SlideCaption);
      Result.Bottom := Result.Top;
      Result.Top := Result.Top - (TextHeight + spCellTextMargin);
    end;
  end;
end;

procedure TNxSlidesDesigner.DoSelectSlide(Column: TNxCustomColumn);
begin
  if Assigned(FOnSelectSlide) then FOnSelectSlide(Self, Column);
end;

procedure TNxSlidesDesigner.DrawGrips(const SlideRect: TRect);
begin
  Canvas.Pen.Color := $008F8F8F;
  with Canvas, SlideRect do
  begin
    with GetGripRect(sgLeft, SlideRect) do Rectangle(Left, Top, Right, Bottom);
    with GetGripRect(sgTopLeft, SlideRect) do Rectangle(Left, Top, Right, Bottom);
    with GetGripRect(sgTop, SlideRect) do Rectangle(Left, Top, Right, Bottom);
    with GetGripRect(sgTopRight, SlideRect) do Rectangle(Left, Top, Right, Bottom);
    with GetGripRect(sgRight, SlideRect) do Rectangle(Left, Top, Right, Bottom);
    with GetGripRect(sgBottomRight, SlideRect) do Rectangle(Left, Top, Right, Bottom);
    with GetGripRect(sgBottom, SlideRect) do Rectangle(Left, Top, Right, Bottom);
    with GetGripRect(sgBottomLeft, SlideRect) do Rectangle(Left, Top, Right, Bottom);
  end;
end;

procedure TNxSlidesDesigner.DrawSlide(const SlideRect: TRect;
  Column: TNxCustomColumn);
var
  R, LocRect: TRect;
  M: Integer;
begin
  with Canvas, Column do
  begin
    R := SlideRect;
    if DrawBorders then
    begin
      if Self.Selected = Column then
      begin
        Brush.Color := clHighlight;
        FrameRect(R);
      end else
      begin
        Pen.Color := $00BBBBBB;
        Polyline([Point(R.Left, R.Bottom - 1), Point(R.Left, R.Top), Point(R.Right, R.Top)]);
        Pen.Color := $008F8F8F;
        Polyline([Point(R.Right - 1, R.Top + 1), Point(R.Right - 1, R.Bottom - 1), Point(R.Left, R.Bottom - 1)]);
      end;
      InflateRect(R, -1, -1);
    end;
    Brush.Color := Color;
    Canvas.FillRect(R);
    Canvas.Font.Assign(Column.Font);
    TGraphicsProvider.DrawWrapedTextRect(Canvas, R, Alignment, VerticalAlignment, WrapKind = wkWordWrap, Name, BiDiMode);
    if Self.Selected = Column then
    begin
      case SlideCaptionLocation of
        clLeft:
        begin
          M := R.Top + (R.Bottom - R.Top) div 2;
          LocRect := Rect(R.Left - 2, M - 2, R.Left + 2, M + 2);
        end;
        clTop:
        begin
          M := R.Left + (R.Right - R.Left) div 2;
          LocRect := Rect(M - 2, R.Top - 2, M + 2, R.Top + 2);
        end;
      end;
      Pen.Color := clGreen;
      Rectangle(LocRect);
    end;
  end;
end;

procedure TNxSlidesDesigner.DrawSlideCaption(Column: TNxCustomColumn);
begin
  with Canvas do
  begin
    Font.Style := [];
    Font.Color := clWindowText;
    DrawTextRect(Canvas, GetSlideCaptionRect(Column), taLeftJustify, Column.SlideCaption);
  end;
end;

procedure TNxSlidesDesigner.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Assigned(Selected) then
  begin
    if ssCtrl in Shift then
    begin
      case Key of
        VK_UP: OffsetSlide(Selected, 0, -1);
        VK_DOWN: OffsetSlide(Selected, 0, 1);
        VK_LEFT: OffsetSlide(Selected, -1, 0);
        VK_RIGHT: OffsetSlide(Selected, 1, 0);
      end;
    end;
    if ssShift in Shift then
    begin
      case Key of
        VK_UP: ResizeSlide(Selected, 0, -1);
        VK_DOWN: ResizeSlide(Selected, 0, 1);
        VK_LEFT: ResizeSlide(Selected, -1, 0);
        VK_RIGHT: ResizeSlide(Selected, 1, 0);
      end;
    end;
  end;
end;

procedure TNxSlidesDesigner.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SizeGrip: TSizeGrip;
begin
  inherited;
  if not Focused then SetFocus;
  if Assigned(FAssociate) then
  begin
    FDownX := X;
    FDownY := Y;
    if Assigned(Selected) then // aready selected
    begin
      SizeGrip := GetGripAtPos(X, Y, Selected.SlideRect);
      FMoveX := X - Selected.SlideBounds.Left;
      FMoveY := Y - Selected.SlideBounds.Top;
      case SizeGrip of
        sgMove: Include(FState, dsMoving);
        sgRight: Include(FState, dsSizingRight);
        sgBottom: Include(FState, dsSizingBottom);
        sgBottomRight: Include(FState, dsSizingBottomRight);
      end;
      if SizeGrip <> sgNone then Exit;
    end;
    Selected := GetSlideAtPos(X, Y);
    if Assigned(Selected) then
    begin
      FMoveX := X - Selected.SlideBounds.Left;
      FMoveY := Y - Selected.SlideBounds.Top;
      Include(FState, dsMoving);
    end;
  end;
end;

procedure TNxSlidesDesigner.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  SizeGrip: TSizeGrip;
  ALeft, ATop, DeltaX, DeltaY: Integer;
begin
  inherited;
  if not Assigned(FAssociate) then Exit;
  Cursor := crDefault;

  if GetSlideAtPos(X, Y) <> nil
    then Cursor := crSizeAll;

  if Assigned(Selected) then
  begin
    SizeGrip := GetGripAtPos(X, Y, FSelected.SlideRect);
    Cursor := GetGripCursor(SizeGrip);

    if dsMoving in FState then
    begin
      DeltaX := X - Selected.SlideBounds.Left - FMoveX;
      DeltaY := Y - Selected.SlideBounds.Top - FMoveY;
      R := Selected.SlideRect;
      if FSnapToGrid then
      begin
        DeltaX := DeltaX div FGridXSize * FGridXSize;
        DeltaY := DeltaY div FGridYSize * FGridYSize;
      end;
      ALeft := Selected.SlideBounds.Left + DeltaX;
      ATop := Selected.SlideBounds.Top + DeltaY;

      if (ALeft <> Selected.SlideBounds.Left) or
        (ATop <> Selected.SlideBounds.Top) then
      begin
        RefreshSlide(Selected, True);
        Selected.SlideBounds.Left := ALeft;
        Selected.SlideBounds.Top := ATop;
        DoChange; { event }
        RefreshSlide(Selected, True);
        ShowHintWindow(X, Y + 20, IntToStr(Selected.SlideBounds.Left) + ', '
          + IntToStr(Selected.SlideBounds.Top));
      end;
    end;

    if dsSizingRight in FState then
    begin
      DeltaX := X - Selected.SlideBounds.Left;
      if FSnapToGrid then DeltaX := DeltaX div FGridXSize * FGridXSize;
      R := Selected.SlideRect;
      if DeltaX < 4 then DeltaX := 4;
      if Selected.SlideBounds.Width <> DeltaX then
      begin
        RefreshSlide(Selected);
        Selected.SlideBounds.Width := DeltaX;
        RefreshSlide(Selected);
        DoChange; { event }
      end;
      ShowHintWindow(X, Y + 20, IntToStr(Selected.SlideBounds.Width) + ' x '
        + IntToStr(Selected.SlideBounds.Height));
    end;

    if dsSizingBottom in FState then
    begin
      DeltaY := Y - Selected.SlideBounds.Top;
      if FSnapToGrid then DeltaY := DeltaY div FGridYSize * FGridYSize;
      R := Selected.SlideRect;
      if DeltaY < 4 then DeltaY := 4;
      if Selected.SlideBounds.Height <> DeltaY then
      begin
        RefreshSlide(Selected);
        Selected.SlideBounds.Height := DeltaY;
        RefreshSlide(Selected);
        DoChange; { event }
      end;
      ShowHintWindow(X, Y + 20, IntToStr(Selected.SlideBounds.Width) + ' x '
        + IntToStr(Selected.SlideBounds.Height));
    end;

    if dsSizingBottomRight in FState then
    begin
      DeltaX := X - Selected.SlideBounds.Left;
      DeltaY := Y - Selected.SlideBounds.Top;
      if FSnapToGrid then
      begin
        DeltaX := DeltaX div FGridXSize * FGridXSize;
        DeltaY := DeltaY div FGridYSize * FGridYSize;
      end;
      R := Selected.SlideRect;
      if DeltaX < 4 then DeltaX := 4;
      if DeltaY < 4 then DeltaY := 4;
      if (Selected.SlideBounds.Width <> DeltaX)
        or (Selected.SlideBounds.Height <> DeltaY) then
      begin
        RefreshSlide(Selected);
        Selected.SlideBounds.Width := DeltaX;
        Selected.SlideBounds.Height := DeltaY;
        RefreshSlide(Selected);
        DoChange; { event }
      end;
      ShowHintWindow(X, Y + 20, IntToStr(Selected.SlideBounds.Width) + ' x '
        + IntToStr(Selected.SlideBounds.Height));
    end;
  end;
  FDownX := X;
  FDownY := Y;
end;

procedure TNxSlidesDesigner.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FState := [];
  FHintWindow.ReleaseHandle;
end;

procedure TNxSlidesDesigner.OffsetSlide(Column: TNxCustomColumn; dx,
  dy: Integer);
begin
  if Assigned(Column) then
  begin
    RefreshSlide(Selected);
    Column.SlideBounds.Left := Selected.SlideBounds.Left + dx;
    Column.SlideBounds.Top := Selected.SlideBounds.Top + dy;
    DoChange;
    RefreshSlide(Selected);
  end;
end;

procedure TNxSlidesDesigner.Paint;
var
  X, Y, I, SlideSize: Integer;
  GripRect, MarginRect: TRect;
begin
  inherited;
  with Canvas do
  begin
    if FAssociate <> nil then SlideSize := FAssociate.SlideSize
      else SlideSize := ClientHeight;
    Brush.Color := clWindow;//Self.Color;
    FillRect(ClientRect);
    if FShowGrid then
    begin
      X := 0;
      Y := 0;
      while (Y < ClientHeight) and (Y < SlideSize) do
      begin
        while X < ClientWidth do
        begin
          if not Assigned(Selected)
            or not PtInRect(Selected.SlideRect, Point(X, Y)) then
              Pixels[X, Y] := clGrayText;
          Inc(X, FGridXSize);
        end;
        Inc(Y, FGridYSize);
        X := 0;
      end;
    end;
    if Assigned(FAssociate) then
    begin
      { slide size }
      Pen.Color := clGrayText;
      MoveTo(0, FAssociate.SlideSize);
      LineTo(ClientWidth, FAssociate.SlideSize);

      { selection margin }
      Brush.Color := clBtnFace;
      MarginRect := Rect(2, 2, ClientWidth - 2, FAssociate.SlideSize - 2);
      FrameRect(MarginRect);

      for i := 0 to FAssociate.Columns.Count - 1 do
      begin
        DrawSlide(FAssociate.Columns[I].SlideRect, FAssociate.Columns[I]);
        DrawSlideCaption(FAssociate.Columns[I]);
      end;

      if Assigned(FSelected) then
      begin
        GripRect := Selected.SlideRect;
        DrawGrips(GripRect);
      end;
    end;
  end;
end;

procedure TNxSlidesDesigner.RefreshSlide(Column: TNxCustomColumn;
  const Selected: Boolean);
var
  R: TRect;
begin
  R := Column.SlideRect;
  if Selected then InflateRect(R, 5, 5);
  InvalidateRect(Handle, @R, False);
  R := GetSlideCaptionRect(Column);
  InvalidateRect(Handle, @R, False);
end;

procedure TNxSlidesDesigner.ResizeSlide(Column: TNxCustomColumn;
  dx, dy: Integer);
begin
  if Assigned(Column) then
  begin
    RefreshSlide(Selected);
    Column.SlideBounds.Width := Selected.SlideBounds.Width + dx;
    Column.SlideBounds.Height := Selected.SlideBounds.Height + dy;
    DoChange;
    RefreshSlide(Selected);
  end;
end;

procedure TNxSlidesDesigner.ShowHintWindow(X, Y: Integer; Value: string);
var
  HintRect: TRect;
  MousePoint: TPoint;
begin
  HintRect := FHintWindow.CalcHintRect(ClientWidth, Value, nil);
  MousePoint := ClientToScreen(Point(X, Y));
  OffsetRect(HintRect, MousePoint.X, MousePoint.Y);
  FHintWindow.ActivateHint(HintRect, Value);
end;

procedure TNxSlidesDesigner.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure TNxSlidesDesigner.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

end.
