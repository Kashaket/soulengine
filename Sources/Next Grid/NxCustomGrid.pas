{
  Next Grid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:NxCustomGrid.pas 12/25/2002 7:10:16 bn
}

{$I '..\NxSuite.inc'}

unit NxCustomGrid;

interface

uses
  Classes, Types, StrUtils, Windows, ShellApi, Messages, Controls,
  SysUtils, Dialogs, Forms, Graphics, ExtCtrls, ImgList,
  NxClasses, NxColumnDragBox, NxColumns, NxCustomGridControl, NxGridCommon,
  NxSharedCommon, NxDisplays
  {$IFDEF UITYPES}, UITypes{$ENDIF}
  ;

const
  timSearchTimer = 700;

type
  THintPosition = (hpNone, hpFooter, hpHeader, hpTextFit, hpCellHint);
  TSearchOptions = set of (soCaseInsensitive, soContinueFromTop,
    soFromSelected, soSearchInvisible, soExactMatch);

  TNxCustomGrid = class(TNxCustomGridControl)
  private
    FCanDeselect: Boolean;
    FClickOnSelected: Boolean;
    FColumnDragBox: TColumnDragBox;
    FDownDragArrow: TDragArrow;
    FDragDropColumn: TNxCustomColumn;
    FFooterHintColumn: TNxCustomColumn;
    FHeaderHintColumn: TNxCustomColumn;
    FHintPosition: THintPosition;
    FHoverCell: TPoint;
    FLastFoundRow: Integer;
    FLeftResizingGuide: Integer;
    FMouseDownColumn: TNxCustomColumn;
    FMouseDownPoint: TPoint;
    FMouseDownRow: Integer;
    FMoveRow: Integer;
    FOldClickCell: TPoint;
    FOldHeight: Integer;
    FOldRowPosition: Integer;
    FOldWidth: Integer;
    {$IFDEF DELPHI2010UP}
    FPanPoint: TPoint;
    {$ENDIF}
    FRangeEnd: TPoint;
    FResizingRow: Integer;
    FRightResizingGuide: Integer;
    FRowSizingPos: TPoint;
    FSearchBuffer: WideString;
    FSearchTimer: TTimer;
    FSizeDelta: Integer;
    FSizeProgressColumn: TNxCustomColumn;
    FSizeReadyColumn: TNxCustomColumn;
    FUpDragArrow: TDragArrow;
    function GetColumnDropRect: TRect;
    function GetSearchColumn: TNxCustomColumn;
    function Locate(Index, FromRow, ToRow: Integer; S: WideString; Options: TSearchOptions): Boolean;
    function LocateByRow(Indices: array of integer; FromRow, ToRow: Integer; S: WideString; Options: TSearchOptions): Boolean;
    procedure ShowCellHint(ACol, ARow: Integer; HintText: WideString);
  protected
    FHintWindow: THintWindow;
    FMouseOverCell: TPoint;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function GetBodyDownLimit: Integer;
    function GetChildOwner: TComponent; override;
    function GetFormulaValue(AColumn: TNxCustomColumn; Kind: TFormulaKind): Double;
    function GetGridArea(Point: TPoint): TGridArea;
    function IsSameCell(Cell1, Cell2: TPoint): Boolean;
    function UpdateColumnPlay(ACol, ARow: Integer; CellRect: TRect; Event: Boolean): Boolean; virtual;
    procedure CreateWnd; override;
    procedure SetColumnPlayAttributes(ColumnPlay: TColumnPlay); virtual; abstract;
    procedure DoColumnPlayChange(Sender: TObject); virtual;
    procedure DoColumnPlayExpand(Sender: TObject); virtual;
    procedure DoDragBoxDrop(Sender: TObject; X, Y: Integer);
    procedure DoDragBoxMove(Sender: TObject; X, Y: Integer);
    {$IFDEF DELPHI2010UP}
    procedure DoGesture(const EventInfo: TGestureEventInfo; var Handled: Boolean); override;
    {$ENDIF}
    procedure DoSearchTimer(Sender: TObject);
    procedure DragCanceled; override;
    procedure DrawRowPosition(const Index: Integer);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeaveCell;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PostRow; virtual;
    procedure ProcessKeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure RecreateHintWnd; virtual;
    procedure RefreshRowPosition;
    procedure SelectRows(Shift: TShiftState; First, Last: Integer);
    procedure SelectRowsInRange(ARect: TRect);
    procedure ShowCellTextFitHint(ACol, ARow: Integer);
    procedure ShowPositionIndicator(Point: TPoint; HideIndicator: Boolean = False);
    { Delphi Messages }
    procedure CMChildKey(var AMsg: TCMChildKey); message CM_CHILDKEY;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMActivateApp(var Message: TWMActivateApp); message WM_ACTIVATEAPP;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindText(const Index: Integer; S: WideString;
      Options: TSearchOptions = [soCaseInsensitive, soFromSelected]): Boolean;
    function FindTextByRow(const Indices: array of integer; S: WideString;
      Options: TSearchOptions = [soCaseInsensitive, soFromSelected]): Boolean;
    function GetCellAtPos(APoint: TPoint): TPoint;
    function GetColumnSizeGripAtPos(X, Y: Integer): TNxCustomColumn;
    function GetColumnAtPos(Point: TPoint): TNxCustomColumn;
    function GetNearestPosition(Column: TNxCustomColumn; Point: TPoint): Integer;
    function GetNearestRow(const X, Y: Integer): Integer;
		function GetRowAtPos(X, Y: Integer): Integer; overload;
		function GetRowAtPos(Y: Integer): Integer; overload;
		function GetRowSizeGripAtPos(X, Y: Integer): Integer;
    function GetSlideAtPos(X, Y: Integer): Integer;
    function IsTextFit(ACol, ARow: Integer): Boolean;
    function SearchNext(Index: Integer; S: WideString; FromFirst: Boolean = False): Boolean;
    function SearchRow(S: WideString): Boolean;
    procedure HideArrows;
    procedure ShowColumnHint(X, Y: Integer; Text: WideString);
    procedure UpdateArrows(CurPosition, NewPosition: Integer; UseSelf: Boolean = False);
//    property RowVisible[Index: Integer]: Boolean read GetRowVisible write SetRowVisible;
    property Canvas;
    property LastFoundRow: Integer read FLastFoundRow;
  published
    property Align;
    property Anchors;
    property AppearanceOptions;
    property AutoScroll;
    property BiDiMode;
		property BorderStyle;
    property Caption;
    property Columns;
    property Constraints;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EnableVisualStyles;
    property FixedCols;
    property FooterSize;
    property Font;
    property GridStyle;
    property GridLinesColor;
    property GridLinesStyle;
    property HeaderSize;
    property HeaderStyle;
    property HideScrollBar;
    property HighlightedTextColor;
    property Hint;
    property HomeEndBehaviour;
    property InactiveSelectionColor;
    property IndicatorDrawingOptions;
    property InputEnterMode;
    property InputSize;
    property Options;
    property ReadOnly;
    property RowSize;
    property ParentBiDiMode;
    property ParentColor default false;
    property ParentFont;
    property PopupMenu;
    property SelectionColor;
    property SelectionMoveDirection;
    property ShowHint;
    property SlidesOptions;
    property SlideSelectionColor;
    property SlideSize;
    property SortedStyle;
    property TabLeaveControl;
    property TabOrder;
    property TabStop;
    property Version;
    property Visible;
    property WantReturns;
    property WantTabs;

    property OnAfterEdit;
    property OnAfterRowMove;
    property OnAfterSort;
    property OnApplyCell;
    property OnApplyEditText;
    property OnBeforeEdit;
    property OnBeforeSelect;
    property OnCalculateRow;
		property OnCellClick;
    property OnCellColoring;
    property OnCellDblClick;
    property OnCellHint;
    property OnCellShowing;
    property OnChange;
    property OnChangeRowHeight;
    property OnClick;
    property OnColumnFooterValue;
    property OnColumnResize;
    property OnColumnMove;
    property OnContextPopup;
    property OnCustomDrawCell;
    property OnCustomDrawFooter;
    property OnCustomDrawHeader;
    property OnCustomDrawIndicator;
    property OnDataChange;
    property OnDblClick;
    property OnDeselectCell;
    property OnDragDrop;
    property OnDragOver;
		property OnDrawCellBackground;
    property OnEdit;
    property OnEditAccept;
    property OnEditEnter;
    property OnEditExit;
    property OnEditText;
    property OnEndDrag;
    property OnEndEditing;
    property OnEnter;
    property OnExit;
    property OnFooterCalculate;
    property OnFooterClick;
    property OnHeaderClick;
    property OnHeaderDblClick;
    property OnHorizontalScroll;
    property OnInputAccept;
    property OnInputAdded;
    property OnInputSelectCell;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLoadProgress;
    property OnMeasuringRowHeight;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPostDraw;
    property OnResize;
    property OnRowMove;
    property OnSelectCell;
    property OnSlideChange;
    property OnSlideColoring;
    property OnSortColumn;
    property OnStartDrag;
    property OnSelectionMove;
    property OnVerticalScroll;
  end;

implementation

uses
  NxColumnClasses, NxScrollControl, NxEdit, DateUtils, Math;

{ TNxCustomGrid }

constructor TNxCustomGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCanDeselect := False;

  FClickOnSelected := False;
  { note: Arrows need to be created
          before FColumnDragBox to
          get desired z order }
  FHintWindow := nil;
  FHeaderHintColumn := nil;
  FFooterHintColumn := nil;

  FDownDragArrow := TDragArrow.Create(Self);
  FDownDragArrow.Parent := Self;
  FDownDragArrow.Visible := False;

  FLastFoundRow := -1;

  FUpDragArrow := TDragArrow.Create(Self);
  FUpDragArrow.Parent := Self;
  FUpDragArrow.Visible := False;

  FColumnDragBox := TColumnDragBox.Create(Self);
  FColumnDragBox.Parent := Self;
  FColumnDragBox.OnDragBoxDrop := DoDragBoxDrop; { event handle }
  FColumnDragBox.OnDragBoxMove := DoDragBoxMove; { event handle }
  FColumnDragBox.Visible := False;

  FMouseDownCell := Point(-1, -1);
  FMouseDownColumn := nil;
  FMouseDownPoint := Point(-1, -1);
  FMouseDownRow := -1;

  ParentColor := False;
  Color := clWindow;

  FSearchBuffer := '';
  FSearchTimer := TTimer.Create(Self);
  FSearchTimer.Enabled := False;
  FSearchTimer.OnTimer := DoSearchTimer;
  FSearchTimer.Interval := timSearchTimer;

  FDragDropColumn := nil;

  FOldClickCell := Point(-1, -1);
  FOldHeight := 0;
  FOldRowPosition := -1;
  FOldWidth := 0;
  FRangeEnd := Point(-1, -1);
  FResizingRow := -1;
  FSizeProgressColumn := nil;
  FSizeReadyColumn := nil;

  FHoverCell := Point(-1, -1);

  ControlStyle := ControlStyle + [csDoubleClicks, csReplicatable];
  {$IFDEF DELPHI2010UP}
  ControlStyle := ControlStyle + [csGestures];
  Touch.InteractiveGestures := [igPan, igPressAndTap];
  Touch.InteractiveGestureOptions := [igoPanInertia,
    igoPanSingleFingerHorizontal, igoPanSingleFingerVertical,
    igoPanGutter, igoParentPassthrough];
  {$ENDIF}
  Screen.Cursors[crColumnNoDragDrop] := LoadCursor(HInstance, 'COLUMNNODRAG');
  Screen.Cursors[crHorzSplit] := LoadCursor(HInstance, 'HORZSPLIT');
  Screen.Cursors[crVertSplit] := LoadCursor(HInstance, 'VERTSPLIT');
  Screen.Cursors[crIndicatorSelect] := LoadCursor(HInstance, 'INDICATORSELECT');
end;

destructor TNxCustomGrid.Destroy;
begin
  FColumns.OnChange := nil;
  FColumns.OnColumnChange := nil;
  FreeAndNil(FColumnDragBox);
  FreeAndNil(FDownDragArrow);
  FreeAndNil(FUpDragArrow);
  DeactivateHint(FHintWindow); { Free may cause AV }
  FHintWindow := nil;
  inherited;
end;

procedure TNxCustomGrid.CreateWnd;
begin
  inherited;
  FDownDragArrow.ArrowKind := akDown;
  FUpDragArrow.ArrowKind := akUp;
  HorzScrollBar.LargeChange := 10;
  HorzScrollBar.SmallChange := 5;
  VertScrollBar.LargeChange := 10;
end;

{ event handlers }

procedure TNxCustomGrid.DoColumnPlayChange(Sender: TObject);
begin

end;

procedure TNxCustomGrid.DoColumnPlayExpand(Sender: TObject);
begin
  
end;

procedure TNxCustomGrid.DoDragBoxDrop(Sender: TObject; X, Y: Integer);
var
  DropPoint: TPoint;
  CurrPos, NewPos: Integer;
begin
  Screen.Cursor := crDefault;
  DropPoint := ScreenToClient(Point(X, Y));
  if PtInRect(GetColumnDropRect, DropPoint) then
  begin
    CurrPos := FMouseDownColumn.Position;
    NewPos := GetNearestPosition(FMouseDownColumn, DropPoint);
    if (not(goLockFixedCols in Options)) or
      ((NewPos >= FixedCols) and (CurrPos >= FixedCols))
        then Columns.ChangePosition(CurrPos, NewPos);
  end else
  begin
    if goCanHideColumn in Options then FMouseDownColumn.Visible := False;
  end;
  RefreshColumn(FMouseDownColumn, gaHeader);
  FMouseDownColumn := nil;
  FMouseDownPoint := Point(-1, -1);
  FFocusedColumn := nil;
  FDragDropColumn := nil; { column with arrows }
  FDownDragArrow.Visible := False; { hide down red drag arrow }
  FUpDragArrow.Visible := False; { hide up red drag arrow }
  Exclude(FGridState, gtColumnMoving);
end;

procedure TNxCustomGrid.DoDragBoxMove(Sender: TObject; X, Y: Integer);
var
  MovePoint: TPoint;
  OldPos, NewPos: Integer;
begin
  MovePoint := ScreenToClient(Point(X, Y));
  if PtInRect(GetColumnDropRect, MovePoint) then
  begin
    OldPos := FMouseDownColumn.Position;
    NewPos := GetNearestPosition(FMouseDownColumn, MovePoint);
    if (goLockFixedCols in Options)
      and ((NewPos < FixedCols) or (OldPos < FixedCols)) then
    begin
      HideArrows;
      Screen.Cursor := crColumnNoDragDrop;
      Exit;
    end;
    if Columns.PositionItem[NewPos].Visible
      then UpdateArrows(FMouseDownColumn.Position, NewPos);
    Screen.Cursor := crDefault;
  end else
  begin
    HideArrows;
    Screen.Cursor := crColumnNoDragDrop;
  end;
end;

{$IFDEF DELPHI2010UP}
procedure TNxCustomGrid.DoGesture(const EventInfo: TGestureEventInfo;
  var Handled: Boolean);
begin
  inherited;
  if EventInfo.GestureID = igiPan then
  begin
    Handled := True;
    if gfBegin in EventInfo.Flags then FPanPoint := EventInfo.Location else
    begin
      VertScrollBar.Position := VertScrollBar.Position - (EventInfo.Location.Y - FPanPoint.Y);
      HorzScrollBar.Position := HorzScrollBar.Position - (EventInfo.Location.X - FPanPoint.X);
      FPanPoint := EventInfo.Location;
    end;
  end;
end;
{$ENDIF}

{ other protected methods }

function TNxCustomGrid.GetRowAtPos(X, Y: Integer): Integer;
var
 	Pos: Integer;
  RowsRect: TRect;
begin
  Result := -1;
  RowsRect := GetBodyRect;
  RowsRect.Left := 0; // Include Indicator area
  if not PtInRect(RowsRect, Point(X, Y)) then Exit;
  Pos := GetBodyRect.Top;

  { Default }
  Result := FFirstRow;

  while Result < RowCount do
  begin

    if GetRowVisible(Result) then
    begin
      Inc(Pos, GetRowHeight(Result) + GridSpace[lpTop]);

      if Y <= Pos
        then Exit;

      Inc(Pos, GridSpace[lpBottom]);
    end;

    { Add one }
    Inc(Result);
  end;

  Result := -1;
end;

function TNxCustomGrid.GetRowAtPos(Y: Integer): Integer;
var
 	Pos: Integer;
  RowsRect: TRect;
begin
  RowsRect := GetBodyRect;
  RowsRect.Left := 0; // Include Indicator area
  Pos := GetBodyRect.Top;
  Result := FFirstRow;
  while Result <= RowCount - 1 do
  begin
    if GetRowVisible(Result) then
    begin
      Inc(Pos, GetRowHeight(Result) + GridSpace[lpTop]);
      if Y <= Pos then Exit;
      Inc(Pos, GridSpace[lpBottom]);
    end;
    Inc(Result);
  end;
  Result := -1;
end;

function TNxCustomGrid.GetRowSizeGripAtPos(X, Y: Integer): Integer;
var
 	i, Pos: Integer;
begin
  Pos := GetBodyRect.Top;
  i := FFirstRow;
  Result := -1;
  if (Y < Pos) or (X > sizIndicator) then Exit;
  while (i <= Pred(RowCount)) do
  begin
    if GetRowVisible(i) then
    begin
      Inc(Pos, GetRowHeight(i) + GridSpace[lpRight]);
      if (Y > Pos - 3) and (Y < Pos + 1) then
      begin
        Result := i;
        Exit;
      end;
    end;
    Inc(i);
  end;
end;

function TNxCustomGrid.GetSlideAtPos(X, Y: Integer): Integer;
var
 	Pos: Integer;
begin
  Pos := GetBodyRect.Top;
  Result := FFirstRow;
  if Y < Pos then Exit;
  while (Result <= RowCount - 1) do begin
    if GetRowVisible(Result) then
    begin
      Inc(Pos, SlideSize + GridSpace[lpTop]);
      if Y <= Pos then Exit;
      Inc(Pos, GridSpace[lpBottom]);
    end;
    Inc(Result);
  end;
end;

function TNxCustomGrid.IsTextFit(ACol, ARow: Integer): Boolean;
var
  CellState: TCellState;
  ContentWidth, CellWidth: Integer;
  Display: TColumnDisplay;
  Value: WideString;
begin
  Display := Columns[ACol].Display;
                     
  CellState := GetCellState(ACol, ARow);

  with Display do
  begin
    Display.Canvas := Self.Canvas;
    Display.ClientRect := GetCellRect(ACol, Arow);
    Value := GetDrawText(ACol, ARow); { get drawing text }
    DoApplyCell(ACol, ARow, Value); { event }
    AsString := Value;
  end;

  Canvas.Font.Assign(Columns[ACol].Font);
  ApplyCellFormating(ACol, ARow, Value, CellState);

  with Canvas do if csBoldTextSelection in CellState then Font.Style := Font.Style + [fsBold];

  ContentWidth := Display.GetContentWidth;
  case GridStyle of
    gsReport: CellWidth := Columns[ACol].Width;
    else CellWidth := Columns[ACol].SlideWidth;
  end;
  Result := ContentWidth + 5 <= CellWidth;
end;

function TNxCustomGrid.GetSearchColumn: TNxCustomColumn;
var
  i: Integer;
begin
  Result := nil;
	for i := 0 to Columns.Count - 1 do
		if coSearchColumn in Columns[i].Options then
    begin
      Result := Columns[i];
      Break;
    end;
end;

function TNxCustomGrid.Locate(Index, FromRow, ToRow: Integer; S: WideString;
  Options: TSearchOptions): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := FromRow to ToRow do
  begin
    if (soSearchInvisible in Options) or GetRowVisible(i) then
    begin
      if soCaseInsensitive in Options then
      begin  
        if soExactMatch in Options then Result := WideCompareText(Cells[Index, i], S) = 0
        else Result := Pos(WideLowerCase(S), WideLowerCase(Cells[Index, i])) > 0;
      end else
      begin
        if soExactMatch in Options then Result := WideCompareStr(Cells[Index, i], S) = 0
        else Result := Pos(S, Cells[Index, i]) > 0;;
      end;
      if Result then
      begin
        SelectedRow := i;
        FLastFoundRow := i;
        if not IsUpdating then ScrollToRow(i);
        Break;
      end;
    end; { invisible }
  end; { for }
end;

procedure TNxCustomGrid.ShowCellHint(ACol, ARow: Integer; HintText: WideString);
var
	HintRect: TRect;
  APoint: TPoint;
  HintLeft: Integer;
begin
  if not ParentFormActive(Self) then Exit;
  if not Application.ShowHint then Exit;

  RecreateHintWnd;

  FHintPosition := hpCellHint;
  HintRect := GetCellRect(ACol, ARow);
  case GridStyle of
    gsReport: HintLeft := HintRect.Left + Columns[ACol].Width;
    else HintLeft := HintRect.Left + Columns[ACol].SlideBounds.Width;
  end;
  if HintLeft > ClientWidth then HintLeft := ClientWidth;
  APoint := ClientToScreen(Point(HintLeft, HintRect.Top - 20));
  HintRect := CalcHintRect(FHintWindow, 250, HintText);
  OffsetRect(HintRect, APoint.X, APoint.Y);
  ActivateHint(FHintWindow, HintRect, HintText);
end;

  { Protected }

function TNxCustomGrid.GetBodyDownLimit: Integer;
var
  i: Integer;
begin
  Result := GetBodyRect.Top;
  i := FFirstRow;
  while (Result <= GetBodyRect.Bottom) and (i < RowCount) do
  begin
    Inc(Result, GetRowHeight(i) + GridSpace[lpBottom]);
    Inc(i);
  end;
end;

function TNxCustomGrid.GetChildOwner: TComponent;
begin
  Result := nil;//Self;
end;

function TNxCustomGrid.GetFormulaValue(AColumn: TNxCustomColumn; Kind: TFormulaKind): Double;
var
  i: Integer;
begin
  Result := 0;
  if (Kind = fkMinimum) and (GetRowCount > 0) then Result := StrToFloat(GetCells(AColumn.Index, 0));
  for i := 0 to GetRowCount - 1 do
  begin
    if (Kind = fkAverage) or (Kind = fkSum) then Result := Result + StrToFloat(GetCells(AColumn.Index, i));
    if Kind = fkMaximum then if StrToFloat(GetCells(AColumn.Index, i)) > Result then Result := StrToFloat(GetCells(AColumn.Index, i));
    if Kind = fkMinimum then if StrToFloat(GetCells(AColumn.Index, i)) < Result then Result := StrToFloat(GetCells(AColumn.Index, i));
  end;
  if (Result <> 0) and (GetRowCount <> 0) and (Kind = fkAverage) then Result := Result / GetRowCount;
end;

function TNxCustomGrid.GetGridArea(Point: TPoint): TGridArea;
begin
  Result := gaNone;
  case GridStyle of
    gsReport:
    begin
      if (goHeader in Options) and (PtInRect(TCalcProvider.ResizeRect(GetHeaderRect, 0, 0, -1, -1), Point)) then Result := gaHeader else
      if (goInput in Options) and (PtInRect(TCalcProvider.ResizeRect(GetInputRect, 0, 0, -1, -1), Point)) then Result := gaInput else
      if (PtInRect(TCalcProvider.ResizeRect(GetBodyRect, 0, 0, -1, -1), Point)) then Result := gaBody else
      if (goFooter in Options) and (PtInRect(TCalcProvider.ResizeRect(GetFooterRect, 0, 0, -1, -1), Point)) then Result := gaFooter else
      if (goIndicator in Options) and (PtInRect(TCalcProvider.ResizeRect(GetIndicatorRect, 0, 0, -1, -1), Point)) then Result := gaIndicator else Result := gaNone;
    end;
    gsSlides:
    begin
      if (goHeader in Options) and (PtInRect(TCalcProvider.ResizeRect(GetHeaderRect, 0, 0, -1, -1), Point)) then Result := gaHeader else
      Result := gaBody;
    end;
    
  end;
end;

function TNxCustomGrid.IsSameCell(Cell1, Cell2: TPoint): Boolean;
begin
  Result := (Cell1.X = Cell2.X) and (Cell1.Y = Cell2.Y);
end;

procedure TNxCustomGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  ProcessKeyDown(Key, Shift);
end;

procedure TNxCustomGrid.KeyPress(var Key: Char);
begin
  inherited;
  { 2/23/07:  don't react when grid is in edit state }
  if (gtEdit in GridState) or (gtInput in GridState)
    or (goDisableKeys in Options) then Exit;
  if Key = #27 then Exit;
  if Key = #13 then
  begin
    if WantReturns then
    begin
      if InputSelected then
      begin
        if InputEnterMode = imAllways then
        begin
          ApplyEditing;
          if Assigned(InplaceEdit) then
          begin
            InplaceEdit.Text := '';
          end;
          AddRowFromInput;
          if InputingColumn <> -1 then
          begin
            InplaceEdit.Text := Columns[InputingColumn].InputValue;
            InplaceEdit.SelectAll;
          end;
        end;
      end else
      begin
        case SelectionMoveDirection of
          mdDown: MoveSelectionDown;
          mdUp: MoveSelectionUp;
          mdLeft: MoveSelectionLeft(mkEnter);
          mdRight: MoveSelectionRight(mkEnter);
        end;
      end;
    end;

    { Prevent Beep sound }
    Key := #0;
  end;
  if not Columns.Exists(SelectedColumn) then Exit;
  if not InputSelected and not RowExist(SelectedRow) then Exit;

  if Assigned(Columns[SelectedColumn].Play)
    and not ReadOnly
    and not InputSelected then { TColumnPlay }
  begin
    if ((coEditing in Columns[SelectedColumn].Options)
      or (csClickable in Columns[SelectedColumn].ColumnStyle))
      and UpdateColumnPlay(SelectedColumn, SelectedRow, GetCellRect(SelectedColumn, SelectedRow), True)
        then Columns[SelectedColumn].Play.KeyPress(Key);
  end;

  if Key = #9 then
  begin
    Key := #0;

    Exit;
  end;

  if Columns[SelectedColumn].IsKeyValid(Key) then
  begin
    if InputSelected then StartInput(SelectedColumn, Key)
      else StartEdit(SelectedColumn, SelectedRow, Key);
  end;

  if not InputSelected and not(coEditing in Columns[SelectedColumn].Options) then
    if (GetSearchColumn <> nil) and (RowCount > 0) then
		begin
      FSearchTimer.Enabled := False;
      FSearchTimer.Enabled := True;
      FSearchBuffer := FSearchBuffer + Key;
	    SearchNext(GetSearchColumn.Index, FSearchBuffer);
		end;
end;

procedure TNxCustomGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Deselect: Boolean;
  RealLeft: Integer;
  Column: TNxCustomColumn;
  ARow: Integer;

  procedure BodyMouseDown;
  var
    ACol, ARow, XL, YL: Integer;
    ClickBodyRect, CellRect: TRect;
    AColumn: TNxCustomColumn;
  begin
    if (gtEdit in GridState) or (gtInput in GridState) then
    begin
      ApplyEditing;
      if gtInput in GridState then AddRowFromInput;
      EndEditing;
    end;

    ClickBodyRect := TCalcProvider.ResizeRect(GetBodyRect, 0, 0, -1, 0);
    case GridStyle of
      gsReport: InputSelected := False;
    end;

    ACol := FMouseDownCell.X;
    ARow := FMouseDownCell.Y;

    FClickOnSelected := IsSameCell(FMouseDownCell, SelectedCell);

    { 02/29/08: If multi-select is enabled and user click on already selected cell, we will exit
                to give possibility for Drag & Drop }

    if (goMultiSelect in Options)
      and (goSelectFullRow in Options) then { multi-select? }
    begin
      if Button = mbLeft then
      begin
        if RowExist(ARow) and GetSelected(ARow) and Dragging then
        begin
          Deselect := False;
          FCanDeselect := True;
        end;
      end else if Button = mbRight then
      begin
        if RowExist(ARow) and not GetSelected(ARow) then
        begin
          Deselect := True;
          FCanDeselect := True;
        end;
      end;
    end;

    { 4/16/07:  In slides mode, column may be out-of bounds }
    if not RowExist(ARow) then
    begin
      Exit;
    end;
    FMouseDownRow := ARow;
    if (ARow < 0) or (ARow >= RowCount) then ARow := SelectedRow;
    if (ACol < 0) or (ACol >= Columns.Count) then ACol := SelectedColumn;

    { Column Play }
    AColumn := Columns[ACol];
    CellRect := GetCellRect(ACol, ARow);
    if Assigned(AColumn.Play) and ((coEditing in AColumn.Options)
      or (csClickable in AColumn.ColumnStyle)) then
    begin
      if (ARow >= 0) and (ARow < RowCount) then
      begin
        with CellRect do
        begin
          XL := X - Left;
          YL := Y - Top;
          if not ReadOnly and UpdateColumnPlay(ACol, ARow, CellRect, True) then
            Columns[ACol].Play.MouseDown(Button, Shift, XL, YL);
        end;
      end;
    end;
    { 6/25/07:  if click cell is partialy visible,
                we will scroll down to show it }
    SelectCell(ACol, ARow, Shift, Deselect, False);
    case GridStyle of
      gsSlides: if GetSlideRect(ARow).Bottom > GetBodyRect.Bottom then VertScrollBar.Next;
      gsReport: if CellRect.Bottom > GetBodyRect.Bottom then ScrollToRow(ARow);
    end;
  end;

  procedure IndicatorMouseDown;
  begin
    if goRowResizing in Options then { rows resizing }
    begin
      FResizingRow := GetRowSizeGripAtPos(X, Y);
      if FResizingRow <> -1 then
      begin
        with Canvas do
        begin
          Pen.Mode := pmNot;
          FRowSizingPos := Point(X, Y);
          MoveTo(0, FRowSizingPos.Y);
          LineTo(ClientWidth, FRowSizingPos.Y);
          Pen.Mode := pmCopy;
          Exit;
        end;
      end;
    end;
    SelectedRow := GetRowAtPos(X, Y);
  end;

  procedure HeaderMouseDown;
  begin
    if csDesigning in ComponentState then Exit;
    if ssDouble in Shift then Exit;
    if Button = mbLeft then
    begin
      FMouseDownColumn := GetColumnAtPos(Point(X, Y));
      if coCanClick in FMouseDownColumn.Options then
      begin
        Include(FGridState, gtColumnHeaderDown);
        FFocusedColumn := FMouseDownColumn;
        RefreshColumn(FFocusedColumn, gaHeader);
      end else FMouseDownColumn := nil;
    end;
  end;

  procedure InputMouseDown;
  begin

  end;

begin
  inherited;
  Deselect := Button = mbLeft;

 	FMouseDownPoint := Point(X, Y);
  FMouseDownCell := GetCellAtPos(FMouseDownPoint);

  if ssDouble in Shift then
  begin
    if Assigned(FSizeReadyColumn) and
      (csFitToLargest in FSizeReadyColumn.ColumnStyle) then
    begin
      BestFitColumn(FSizeReadyColumn.Index);
      FSizeReadyColumn := nil;
    end else
    begin
      case GetGridArea(FMouseDownPoint) of
        gaBody:
        begin
          if CellBounds(FMouseDownCell.X, FMouseDownCell.Y) then
            DoCellDblClick(FMouseDownCell.X, FMouseDownCell.Y);
        end;
        gaHeader:
        begin
          Column := GetColumnAtPos(FMouseDownPoint);
          if Assigned(Column) then DoHeaderDblClick(Column.Index); { event }
        end;
        gaIndicator:
        begin
          if goRowResizing in Options then
          begin
            ARow := GetRowSizeGripAtPos(X, Y);
            if RowExist(ARow) then BestFitRow(ARow);
          end;
        end;
      end;
    end;
   	FMouseDownPoint := Point(-1, -1);
    Exit;
  end;

  if not(csDesigning in ComponentState) //and (GetParentForm(Self).Active)
    and Visible and Enabled then TryFocus;

	if Columns.Count = 0 then Exit;
  case Button of
    mbLeft, mbRight:
    begin
      {! if (Button = mbRight) and (gtMultiSelect in GridState) then Exit; !}

      if (Button = mbLeft) and (goHeader in Options)
        and PtInRect(GetHeaderRect, Point(X, Y)) then
      begin
  		  FSizeProgressColumn := GetColumnSizeGripAtPos(X, Y);
      end;

		  if Assigned(FSizeProgressColumn) then { resizing }
		  begin
		    with Canvas, FSizeProgressColumn do
		    begin
          Include(FGridState, gtColumnResizing);
		      FSizeDelta := 0;
          RealLeft := Left;
          if FSizeProgressColumn.Position >= FixedCols then Dec(RealLeft, HorzScrollBar.Position);

          if Index = 0 then FLeftResizingGuide := RealLeft else FLeftResizingGuide := RealLeft - 1;
          FRightResizingGuide := RealLeft + Width - 1;

          Pen.Mode := pmNot;
          Polyline([Point(FLeftResizingGuide, 0), Point(FLeftResizingGuide, ClientHeight)]);
          Polyline([Point(FRightResizingGuide, 0), Point(FRightResizingGuide, ClientHeight)]);
          Pen.Mode := pmCopy;
		    end;
	  	end else
		  begin
		    case GetGridArea(Point(X, Y)) of
		      gaBody: BodyMouseDown;
		      gaHeader: HeaderMouseDown;
          gaIndicator: IndicatorMouseDown;
		      gaInput: InputMouseDown;
          gaFooter: ;
          else  begin
                  ApplyEditing;
                  EndEditing;
                  PostRow;
                end;
		    end;
        if gtIndicatorMouseDown in GridState then BodyMouseDown;
		  end; { else }
    end; { mbLeft, mbRight }
  end; { case }
end;

procedure TNxCustomGrid.MouseLeaveCell;
begin
  if not CellBounds(FHoverCell.X, FHoverCell.Y) then Exit;
  if not IsPointNil(Point(FHoverCell.X, FHoverCell.Y)) then
    if Assigned(Columns[FHoverCell.X].Play) then
    begin
      Columns[FHoverCell.X].Play.MouseLeave;
    end;
end;

procedure TNxCustomGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  FMouseMoveColumn: TNxCustomColumn;
  FOldHoverColumn: TNxCustomColumn;
  FOldMouseOverCell: TPoint;
  GridArea: TGridArea;
  ResizingRow, FLinePos, Indent: Integer;
  ScreenPoint: TPoint;

  procedure BodyMouseMove;
  var
    Col, Row, XL, YL: Integer;
    CellHint: WideString;
    CellRect: TRect;
  begin
    FMouseOverCell := GetCellAtPos(Point(X, Y));
    Col := FMouseOverCell.X;
    Row := FMouseOverCell.Y;

    { MouseLeave }
    if not IsSameCell(FHoverCell, FMouseOverCell) then MouseLeaveCell;
    FHoverCell := FMouseOverCell;

    { Column Play }
    if CellBounds(Col, Row) then
    begin
      if Assigned(Columns[Col].Play) then
      begin
        CellRect := GetCellRect(Col, Row);
        with CellRect do
        begin
          XL := X - Left;
          YL := Y - Top;
          if not ReadOnly and UpdateColumnPlay(Col, Row, CellRect, False) then
            Columns[Col].Play.MouseMove(Shift, XL, YL);
        end;
      end;
    end;

    if (FMouseDownRow <> -1) and (goRowMoving in Options)
      and (ssLeft in Shift) then
    begin
      if PointOffset(FMouseDownPoint, Point(X, Y), 5) then
      begin
        Include(FGridState, gtRowMoving);
        Screen.Cursor := crDrag;
      end;
    end;

    if gtRowMoving in GridState then
    begin
      FOldRowPosition := FMoveRow;
      FMoveRow := GetNearestRow(X, Y);
      if FMoveRow <> FOldRowPosition then
      begin
        RefreshRowPosition;
        if FMoveRow = FFirstRow then VertScrollBar.Prior;
        if FMoveRow = GetLastRowInView(GetVisibleCount) + 1 then VertScrollBar.Next;
        DrawRowPosition(FMoveRow);
      end;
    end;

    if (FMouseOverCell.X < 0) or (FMouseOverCell.Y >= RowCount)
      or (FMouseOverCell.X >= Columns.Count) or (FMouseOverCell.Y < 0) then
    begin
      { Hover cell is not exist }
      Self.Cursor := crDefault;
      FHintPosition := hpNone;
      DeactivateHint(FHintWindow);
      Exit;
    end;

    if IsSameCell(EditingCell, FMouseOverCell) then
    begin
      DeactivateHint(FHintWindow);
    end else
    begin
      if Assigned(Columns[FMouseOverCell.X]) then Self.Cursor := Columns[FMouseOverCell.X].Cursor else Self.Cursor := crDefault;
      if IsSameCell(FMouseOverCell, FOldMouseOverCell) then Exit;
      if (coShowTextFitHint in Columns[FMouseOverCell.X].Options)
        and (not IsTextFit(FMouseOverCell.X, FMouseOverCell.Y)) then
      begin
        ShowCellTextFitHint(FMouseOverCell.X, FMouseOverCell.Y);
        Exit;
      end;
    end;
    with FMouseOverCell do
    begin
      if IsSameCell(FMouseOverCell, FOldMouseOverCell) then Exit;
      if (FHintPosition <> hpTextFit) then
      begin
        CellHint := GetCellHint(Col, Row);
        if CellHint <> '' then
        begin
          ShowCellHint(FMouseOverCell.X, FMouseOverCell.Y, CellHint);
          Exit;
        end;
      end;
    end;
    FHintPosition := hpNone;
    DeactivateHint(FHintWindow);
  end;

  procedure FooterMouseMove;
  begin
    FMouseMoveColumn := GetColumnAtPos(Point(X, Y));
    if Assigned(FMouseMoveColumn) and (FMouseMoveColumn.Footer.Hint <> '') then
    begin
      if FFooterHintColumn <> FMouseMoveColumn then
      begin
        FHintPosition := hpFooter;
        FFooterHintColumn := FMouseMoveColumn;
        ShowColumnHint(FMouseMoveColumn.AbsoluteLeft, ClientHeight + 2,
          FMouseMoveColumn.Footer.Hint);
      end;
    end else
    begin
      DeactivateHint(FHintWindow);
      FFooterHintColumn := nil;
    end;
  end;

  procedure HeaderMouseMove;
  begin
    if csDesigning in ComponentState then Exit;
    FSizeReadyColumn := GetColumnSizeGripAtPos(X, Y);
    if FSizeReadyColumn <> nil then Self.Cursor := crHorzSplit
      else Self.Cursor := crDefault;
    { Column Moving }
    if (Assigned(FMouseDownColumn) and (ssLeft in Shift)
      and not(coDisableMoving in FMouseDownColumn.Options)
      and not(goDisableColumnMoving in Options)) then
    begin
      if PointOffset(Point(X, Y), FMouseDownPoint, spAllowDragDistance) then
        with FMouseDownColumn do
        begin
          Include(FGridState, gtColumnMoving);
          ScreenPoint := ClientToScreen(Point(Left, 0));
          FColumnDragBox.Font.Assign(Self.Font);
          FColumnDragBox.SetBounds(ScreenPoint.X, ScreenPoint.Y, Width, HeaderSize);
          FColumnDragBox.Show(X, Y, FMouseDownColumn);
        end;
    end else
    begin
      FOldHoverColumn := FHoverColumn;
      FHoverColumn := GetColumnAtPos(Point(X, Y));
      if Assigned(FHoverColumn ) and (FHoverColumn.Header.Hint <> '') then
      begin
        if FHeaderHintColumn <> FHoverColumn then
        begin
          FHintPosition := hpHeader;
          FHeaderHintColumn := FHoverColumn;
          ShowColumnHint(FHoverColumn.AbsoluteLeft, HeaderSize + 2,
            FHoverColumn.Header.Hint);
        end;
      end else
      begin
        DeactivateHint(FHintWindow);
        FHeaderHintColumn := nil;
      end;

      if sdaHoverEnabled in CurrentStyleDisplay.StyleDisplayAttributes then
      begin
        if FOldHoverColumn <> FHoverColumn then
        begin
          RefreshColumn(FHoverColumn, gaHeader);
          if FOldHoverColumn <> nil then RefreshColumn(FOldHoverColumn, gaHeader);
        end;
      end;
    end;
  end;

  procedure IndicatorMouseMove;
  begin
    ResizingRow := GetRowSizeGripAtPos(X, Y);
    if (ResizingRow > -1) and (goRowResizing in Options)
      then Self.Cursor := crVertSplit else
    begin
      if (Y > GetBodyRect.Top) and (Y < GetBodyDownLimit) then
      begin
        Self.Cursor := crIndicatorSelect;
      end else Self.Cursor := crDefault;
    end;
  end;

  procedure ResetHeader;
  begin
    FSizeReadyColumn := nil;
    FOldHoverColumn := FHoverColumn;
    FHoverColumn := nil;
    if FOldHoverColumn <> nil then RefreshColumn(FOldHoverColumn, gaHeader);
  end;

begin
  inherited;
  FOldMouseOverCell := FMouseOverCell;
  FMouseOverCell := Point(-1, -1);

  if Columns.Count = 0 then Exit;
  if vsRolling in ViewState then Exit;

  if Assigned(FSizeProgressColumn) then
  begin
    with Canvas, FSizeProgressColumn do
    begin
      Include(FGridState, gtColumnResizing);

      Pen.Mode := pmNot;
      Polyline([Point(FRightResizingGuide, 0), Point(FRightResizingGuide, ClientHeight)]);

      if Position >= FixedCols then Indent := HorzScrollBar.Position else Indent := 0;
      FSizeDelta := (X - (Left + Width)) + Indent;
      if Width + FSizeDelta < FSizeProgressColumn.MinWidth then FSizeDelta := -(Width - FSizeProgressColumn.MinWidth);

      FRightResizingGuide := (Left + Width + FSizeDelta) - 1;
      if Position >= FixedCols then Dec(FRightResizingGuide, HorzScrollBar.Position);

      Polyline([Point(FRightResizingGuide, 0), Point(FRightResizingGuide, ClientHeight)]);
      Pen.Mode := pmCopy;

      Exit;
    end;
  end;

  if goRowResizing in Options then { rows resizing }
  begin
    if FResizingRow <> -1 then { resizing in progress }
    begin
      with Canvas do
      begin
        Pen.Mode := pmNot;
        MoveTo(0, FRowSizingPos.Y);
        LineTo(ClientWidth, FRowSizingPos.Y);
        FLinePos := Y;
        if FLinePos < GetRowTop(FResizingRow) + 8
          then FLinePos := GetRowTop(FResizingRow) + 8;
        FRowSizingPos := Point(X, FLinePos);
        MoveTo(0, FRowSizingPos.Y);
        LineTo(ClientWidth, FRowSizingPos.Y);
        Pen.Mode := pmCopy;
      end;
      Exit;
    end;
  end;

  GridArea := GetGridArea(Point(X, Y));

  if GridArea = gaHeader then
  begin
    HeaderMouseMove;
  end else
  begin
    if FHintPosition = hpHeader then DeactivateHint(FHintWindow);
    FHeaderHintColumn := nil;
    ResetHeader;
  end;

  if GridArea = gaFooter then
  begin
    FooterMouseMove;
  end else
  begin
    if FHintPosition = hpFooter then DeactivateHint(FHintWindow);
    FFooterHintColumn := nil;
  end;

  if GridArea = gaBody then
  begin
    BodyMouseMove;
  end else
  begin
    if (FHintPosition = hpTextFit)
      or (FHintPosition = hpCellHint)
        then DeactivateHint(FHintWindow);
    MouseLeaveCell;
  end;

  if GridArea = gaIndicator then
  begin
    IndicatorMouseMove;
  end;

  if GridArea = gaNone then
  begin
    DeactivateHint(FHintWindow);
    Self.Cursor := crDefault;
  end;
end;

procedure TNxCustomGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
  SameCell, Deselect: Boolean;
  GridArea: TGridArea;
  AMouseUpCell: TPoint;
  NearestRow: Integer;
  FDownColumn: TNxCustomColumn;

  procedure FooterMouseUp;
  var
    ClickCol: TNxCustomColumn;
  begin
    ClickCol := GetColumnAtPos(Point(X, Y));
    if Assigned(ClickCol) then DoFooterClick(ClickCol.Index);
  end;

  procedure HeaderMouseUp;
  var
    ClickColumn: TNxCustomColumn;
  begin
    if csDesigning in ComponentState then Exit;
    ClickColumn := GetColumnAtPos(Point(X, Y));
    if ClickColumn <> FDownColumn then Exit;
    if coCanSort in ClickColumn.Options then
      if not ClickColumn.Sorted then ClickColumn.Sorted := True else
      begin
        if ClickColumn.SortKind = skDescending
        	then ClickColumn.SortKind := skAscending
            else ClickColumn.SortKind := skDescending;
      end;
  end;

  procedure IndicatorMouseUp;
  begin
    if FResizingRow <> -1 then
    begin
      with Canvas do
      begin
        Pen.Mode := pmNot;
        MoveTo(0, FRowSizingPos.Y);
        LineTo(ClientWidth, FRowSizingPos.Y);
        Pen.Mode := pmCopy;
      end;
      SetRowHeight(FResizingRow, FRowSizingPos.Y - GetRowTop(FResizingRow));
      FResizingRow := -1;
    end;
  end;

  procedure BodyMouseUp;
  var
    XL, YL: Integer;
    AColumn: TNxCustomColumn;
    CellRect: TRect;
  begin
    with GetCellAtPos(Point(X, Y)) do
    begin
      ACol := X;
      ARow := Y;
    end;

    AMouseUpCell := GetCellAtPos(Point(X, Y));

    if (ACol >= 0) and (ARow >= 0) and (ARow < RowCount) then
    begin
      SameCell := IsSameCell(AMouseUpCell, FMouseDownCell);
      if SameCell then DoCellClick(AMouseUpCell.X, AMouseUpCell.Y);
    end;
    if InRange(ACol, 0, Columns.Count - 1) = False then Exit;

    if not(gtMultiSelect in GridState) then
    begin
      if SameCell then
      begin
        AColumn := Columns[ACol];
        if not CellBounds(ACol, ARow) then Exit;

        { Column Play }
        CellRect := GetCellRect(ACol, ARow);
        if Assigned(AColumn.Play) and ((coEditing in Columns[ACol].Options)
          or (csClickable in Columns[ACol].ColumnStyle)) then
        begin
          if (ARow >= 0) and (ARow < RowCount) then
          begin
            with CellRect do
            begin
              XL := X - Left;
              YL := Y - Top;
              if not ReadOnly and UpdateColumnPlay(ACol, ARow, CellRect, True) then
                Columns[AMouseUpCell.X].Play.MouseUp(Button, Shift, XL, YL);
            end;
          end;
        end;

        { If row is deleted in OnEditAccept }
        if CellBounds(ACol, ARow) then
        begin
          { Edit Box }
          AColumn.AdjustEditRect(GetRowLevel(ARow), CellRect);
          if PtInRect(CellRect, Point(X, Y)) then
          begin
            if not(goSecondClickEdit in Options) or FClickOnSelected then
            begin
              if CanSelectCell(ACol, ARow) then EditCell(ACol, ARow);
            end;
          end;
        end;

      end;
    end else
    begin { multi-select }
      if (ARow = -1) and Deselect then ClearSelection;
    end;
  end;

begin
  inherited;
  FDownColumn := FMouseDownColumn;
  FMouseDownColumn := nil;
  FMouseDownPoint := Point(-1, -1);
  Deselect := True;

  { Row Moving }
  if gtRowMoving in GridState then
  begin
    NearestRow := GetNearestRow(X, Y);
    if NearestRow > -1 then
    begin
      if FMouseDownRow < NearestRow then Dec(NearestRow);
      if CanMoveRow(FMouseDownRow, NearestRow) then
      begin
        if FMouseDownRow <> -1 then
        begin
          MoveRow(FMouseDownRow, NearestRow);
          DoAfterRowMove(FMouseDownRow, NearestRow);
          SelectedRow := NearestRow;
        end;
      end;
    end else
    begin
      RefreshRowPosition;
    end;
    Exclude(FGridState, gtRowMoving);
    FMouseDownRow := -1;
  end;

  FGridState := FGridState - [gtColumnHeaderDown, gtIndicatorMouseDown];
  if Assigned(FSizeProgressColumn) and (gtColumnResizing in GridState) then
  begin
    FSizeProgressColumn.Width := FSizeProgressColumn.Width + FSizeDelta;
    FSizeProgressColumn := nil;
    FSizeReadyColumn := nil;
    Exclude(FGridState, gtColumnresizing);
    with Canvas do   
    begin
      Pen.Mode := pmNot;
      Polyline([Point(FLeftResizingGuide, 0), Point(FLeftResizingGuide, ClientHeight)]);
      Polyline([Point(FRightResizingGuide, 0), Point(FRightResizingGuide, ClientHeight)]);
      Pen.Mode := pmCopy;
    end;
    Exit;
  end else Exclude(FGridState, gtColumnResizing);

  IndicatorMouseUp;

  if Assigned(FFocusedColumn) then
  begin
    DoHeaderClick(FFocusedColumn.Index); { event }
    RefreshColumn(FFocusedColumn, gaHeader);
    FFocusedColumn := nil;
  end;
  GridArea := GetGridArea(Point(X, Y));
  if Button = mbLeft then
  begin
	  case GridArea of
	    gaHeader: HeaderMouseUp;
      gaBody: if not(csDesigning in ComponentState) then BodyMouseUp;
      gaInput: if not(csDesigning in ComponentState) then InputColumn(GetColumnAtPos(Point(X, Y)), '');
      gaFooter: FooterMouseUp;
      else
      begin
        if (gtMultiSelect in GridState) and Deselect then ClearSelection;
      end;
	  end;
  end else
  begin
    { 9/29/07: Prevent focus on invisible component }
    EndEditing;
  end;
end;

procedure TNxCustomGrid.PostRow;
begin

end;

procedure TNxCustomGrid.ProcessKeyDown(var Key: Word; Shift: TShiftState);
var
  Delta: Integer;
begin
  if goDisableKeys in Options then Exit;

  if (gtEdit in GridState) or (gtInput in GridState) then
  begin
    case Key of
      VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END: Exit;
    end;
  end;

  case Key of
    65: if (ssCtrl in Shift) then SelectAll;
    VK_TAB: if (ssShift in Shift) then MoveToPrevCell(True) else MoveToNextCell(True);
    VK_LEFT:
    begin
      if InputSelected or not(goSelectFullRow in Options)
        or (aoIndicateSelectedCell in AppearanceOptions)
          then MoveSelectionLeft(mkArrows) else HorzScrollBar.Prior;
    end;
    VK_RIGHT:
    begin
      if InputSelected or not(goSelectFullRow in Options)
        or (aoIndicateSelectedCell in AppearanceOptions)
          then MoveSelectionRight(mkArrows) else HorzScrollBar.Next;
    end;
    VK_UP: MoveSelectionUp(Shift);
    VK_DOWN: MoveSelectionDown(Shift);

    VK_HOME:
    begin
      if RowCount > 0 then
      begin
        SelectRows(Shift, 0, IfThen(SelectedRow > -1, SelectedRow, LastVisibleRow));
        case HomeEndBehaviour of
          hebTopBottom: if FColumns.Exists(SelectedColumn) then SelectFirstRow(Shift);
          hebLeftRight: SelectFirstColumn;
        end;
      end;
    end;

    VK_END:
    begin
      if RowCount > 0 then
      begin
        SelectRows(Shift, IfThen(SelectedRow > -1, SelectedRow, FirstVisibleRow), RowCount - 1);
        case HomeEndBehaviour of
          hebTopBottom: if FColumns.Exists(SelectedColumn) then SelectLastRow(Shift);
          hebLeftRight: SelectLastColumn;
        end;
      end;
    end;

    VK_PRIOR:
      if not VertScrollBar.IsFirst then
      begin
        Delta := GetVisibleCount; { n rows are shown in view }
        if SelectedRow > FFirstRow
          then SelectedRow := FFirstRow else
        begin
          { Bn: First row in view is selected }
          MoveSelectionBy(-Delta); { move for n visible rows }
          ScrollToRow(SelectedRow);
        end;
      end else SelectFirstRow;

    VK_NEXT:
      if not VertScrollBar.IsLast then
      begin
        Delta := GetVisibleCount; { n rows are shown in view }

        if SelectedRow < Pred(FFirstRow + Delta) then
        begin
          { Bn: Real index of last row in view }
          SelectedRow := GetLastRowInView(Delta);
        end else
        begin
          if SelectedRow + Delta > RowCount then
          begin
            SelectLastRow;
            Exit;
          end;
          { Bn: Last row in view is selected }
          MoveSelectionBy(Delta);
          ScrollToRow(SelectedRow);
        end;
      end;

  end; { case }
end;

procedure TNxCustomGrid.RecreateHintWnd;
begin
  if FHintWindow <> nil then
  begin
    if FHintWindow is HintWindowClass then Exit;
    FHintWindow.Free;
  end;
  FHintWindow := HintWindowClass.Create(Self);
  FHintWindow.Color := Application.HintColor;
end;

procedure TNxCustomGrid.RefreshRowPosition;
var
  Y, X: Integer;
  RowRect: TRect;
begin
//  12/16/13: Bug. 
//  if not RowExist(FOldRowPosition) then Exit;

  case GridStyle of
    gsReport: RowRect := GetRowRect(FOldRowPosition);
    else      RowRect := GetSlideRect(FOldRowPosition);
  end;
  Y := RowRect.Top;
  X := RowRect.Right;
  if FOldRowPosition <> FFirstRow then Dec(Y);
  RefreshRect(Rect(0, Y - 5, 7, Y + 6));
  RefreshRect(Rect(X - 7, Y - 5, X + 1, Y + 6));
  RefreshRect(Rect(7, Y, RowRect.Right, Y + 1));
end;

procedure TNxCustomGrid.CMChildKey(var AMsg: TCMChildKey);
begin
  inherited;
    { 10/23/11: If Child is FInplaceEdit then send KeyDown and
                stop further processing if FInplaceEdit is released
                within KeyDown (!) }
  if InplaceEdit = AMsg.Sender then
  begin
    { Ask InplaceEdit first (!) }
    if AMsg.CharCode in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN] then
    begin
      if InplaceEdit.CanDispatchKey(AMsg.CharCode) then
        if goArrowKeyExitEditing in Options then
        begin
          ApplyEditing;
          EndEditing;
          KeyDown(AMsg.CharCode, []);
        end;
    end;

    { 2/18/12: Potential problem with Tab key
               and Button InplaceEdit's  }
    { 4/8/12:  Disabled line because TAB can't leave cell bug }
//    if (AMsg.CharCode = VK_TAB) and not WantTabs then AMsg.Result := 1;

    { 10/22/11: Must be set in order to stop processing
                if FInplaceEdit is nil (!) }
    if InplaceEdit = nil then AMsg.Result := 1;
  end;

end;

procedure TNxCustomGrid.CMDesignHitTest(var Message: TCMDesignHitTest);
begin
  Message.Result := 0;
	if PtInRect(GetHeaderRect, Point(Message.XPos, Message.YPos))
  	or (gtColumnResizing in GridState)
	  	or (gtColumnHeaderDown in GridState)
			  then Message.Result := 1;
end;

procedure TNxCustomGrid.CMFontChanged(var Message: TMessage);
var
  i: Integer;
begin
  inherited;
  for i := 0 to Columns.Count - 1 do
    if Columns[i].ParentFont then Columns[i].ParentFont := True;
end;

procedure TNxCustomGrid.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if Assigned(OnMouseEnter) then
    OnMouseEnter(Self);
end;

procedure TNxCustomGrid.CMMouseLeave(var Message: TMessage);
var
	FOldHoverColumn: TNxCustomColumn;
begin
  inherited;
  RefreshRowPosition;
  FHintPosition := hpNone;
  DeactivateHint(FHintWindow);
  FHeaderHintColumn := nil;
  FOldHoverColumn := FHoverColumn;
  FHoverColumn := nil;
  if Assigned(FOldHoverColumn) then RefreshColumn(FOldHoverColumn, gaHeader);
  if Assigned(OnMouseLeave) then OnMouseLeave(Self);
end;

procedure TNxCustomGrid.CMParentFontChanged(var Message: TMessage);
var
  i: Integer;
begin
  inherited;
  if ParentFont then
  begin
    for i := 0 to Columns.Count - 1 do
      if Columns[i].ParentFont then
        Columns[i].Font.Assign(Self.Font);
  end;
end;

procedure TNxCustomGrid.CMShowingChanged(var Message: TMessage);
begin
  inherited;

end;

function TNxCustomGrid.UpdateColumnPlay(ACol, ARow: Integer; CellRect: TRect; Event: Boolean): Boolean;
begin
  Result := True;
  with Columns[ACol] do
  begin
    if Event then DoBeforeEdit(ACol, ARow, Result);
    if Result then
    begin
      Play.Col := ACol;
      Play.Row := ARow;
      Play.Canvas := Canvas;
      Play.Canvas.Font := Columns[ACol].Font;
      SetColumnPlayAttributes(Play);
      Play.Column := Columns[ACol];
      Play.ClientRect := CellRect;
      Play.OnChange := DoColumnPlayChange;
      Play.OnExpand := DoColumnPlayExpand;
    end;
  end;
end;

procedure TNxCustomGrid.WMActivateApp(var Message: TWMActivateApp);
begin
	inherited;
	if not Message.Active then
  begin
    { reset all stuff when ALT + TAB is pressed }
    FMouseDownColumn := nil;
    FMouseDownPoint := Point(-1, -1);
    FMouseDownCell := Point(-1, -1);
    FDragDropColumn := nil;
    FFocusedColumn := nil;
    FDownDragArrow.Visible := False;
    FUpDragArrow.Visible := False;
    FColumnDragBox.Visible := False;
    Self.Cursor := crDefault;
  end;
  RefreshSelectedCells;
end;

procedure TNxCustomGrid.WMGetDlgCode(var Message: TWMGetDlgCode);
var
  SkipTab: Boolean;
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
  SkipTab := (Columns.VisibleCount = 0) or ((RowCount = 0) and not InputSelected);
  if WantTabs and not SkipTab then Message.Result := Message.Result or DLGC_WANTTAB
  else Message.Result := Message.Result and not DLGC_WANTTAB;
end;

procedure TNxCustomGrid.WMHScroll(var Message: TWMHScroll);
begin
  EndEditing;
  if not(aoAlphaBlendedSelection in AppearanceOptions) then DrawFocusCell;
  inherited;
  if not(aoAlphaBlendedSelection in AppearanceOptions) then DrawFocusCell;
end;

procedure TNxCustomGrid.WMKillFocus(var Message: TWMSetFocus);
var
  FOldHoverColumn: TNxCustomColumn;
begin
	inherited;

  DeactivateHint(FHintWindow);

  FGridState := FGridState - [gtColumnResizing, gtColumnMoving,
    gtRolling, gtRowMoving, gtColumnHeaderDown];
  RefreshSelectedCells;
  if GridStyle = gsSlides then
  begin
    RefreshSelectedSlides;
    RefreshSlide(SelectedRow);
  end;

  if goHeader in Options then
  begin
    if Assigned(FHoverColumn) then
    begin
      FOldHoverColumn := FHoverColumn;
      FHoverColumn := nil;
      FOldHoverColumn.Refresh(gaHeader);
    end;
  end;

  FMouseDownRow := -1;
  FResizingRow := -1;
  FSizeProgressColumn := nil;
  FHoverColumn := nil;
  FMouseDownColumn := nil;
  FFocusedColumn := nil;
end;

procedure TNxCustomGrid.WMNCPaint(var Message: TMessage);
begin
	inherited;
  RedrawBorder;
end;

procedure TNxCustomGrid.WMSetCursor(var Msg: TWMSetCursor);
begin
	inherited;

end;

procedure TNxCustomGrid.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if RowCount > 0 then
  begin
    RefreshSelectedCells;
    if GridStyle = gsSlides then
    begin
      RefreshSelectedSlides;
      RefreshSlide(SelectedRow);
    end;
  end else if goInput in Options then
  begin
    InputSelected := True;
  	RefreshArea(gaInput);
  end;
end;

procedure TNxCustomGrid.WMSize(var Message: TWMSize);
var
	UpdateRect, IndicatorRect: TRect;

  function GetDownLimit: Integer;
  var
    j: Integer;
  begin
    Result := GetBodyRect.Top;
    j := FFirstRow;
    while (j < RowCount) and (Result <= GetBodyRect.Bottom) do
    begin
      Inc(Result, RowHeight[j] + GetGridSpace(lpTopBottom));
      Inc(j);
    end;
  end;

  procedure VertScrollBack;
  var
    ResizeDelta, i: Integer;
  begin
    ResizeDelta := GetBodyRect.Bottom - GetDownLimit;
    if ResizeDelta > 0 then
    begin
      for i := FFirstRow - 1 downto 0 do
      begin
        if RowVisible[i] then
        begin
          if (ResizeDelta >= RowHeight[i] + GetGridSpace(lpTopBottom)) then
          begin
            VertScrollBar.MoveBy(-1);
            Dec(ResizeDelta, RowHeight[i] + GetGridSpace(lpTopBottom));
          end else Exit;
        end;
      end;
    end;
  end;

begin
	{ note: we need to set vert scrollbar data
  				to properly calculate columns width }

  { Vertical resize }
  if FOldHeight <> ClientHeight then
  begin

		if GridStyle = gsReport then
		begin
      if goFooter in Options then
      begin
  		  RefreshArea(gaFooter);
        if goIndicator in Options then
        begin
          { refresh indicator/footer box }
          IndicatorRect := Rect(0, GetFooterRect.Top, sizIndicator, ClientHeight);
          InvalidateRect(Handle, @IndicatorRect, False);
        end;
	      UpdateRect := Rect(0, GetFooterRect.Top - (Height - FOldHeight), ClientWidth, GetFooterRect.Top);
	      InvalidateRect(Handle, @UpdateRect, False);
      end;
		end else
    begin
      UpdateRect := Rect(0, ClientHeight - (Height - FOldHeight), ClientWidth, ClientHeight);
      InvalidateRect(Handle, @UpdateRect, False);
    end;

    { Update VertScrollBar if ScrollBar is
      on last position }
    if Height > FOldHeight then
    begin
      VertScrollBack;
      FVertResizeKind := rkExpansion;
    end else FVertResizeKind := rkShrink;

    FOldHeight := ClientHeight;
    UpdateVertScrollBar;
  end;

  { Horizontal resize }
	if FOldWidth <> ClientWidth then
  begin
    if HorzScrollBar.Position > 0 then UpdateRect := ClientRect
    else UpdateRect := Rect(ClientWidth - (ClientWidth - FOldWidth), 0, ClientWidth, ClientHeight);
    if GridStyle = gsSlides then
    begin
      UpdateRect.Left := UpdateRect.Left - 3;
    end;
    InvalidateRect(Handle, @UpdateRect, False);

    { Slides resizing }
    Columns.AnchorSlides(FOldWidth, ClientWidth);

    FOldWidth := ClientWidth;
    Columns.ResizeColumns;
    UpdateHorzScrollBar;
    if (Caption <> '') and (GetVisibleRows = 0)
      then RefreshRect(GetCaptionRect);
  end;

  if gtEdit in GridState then EndEditing;
  inherited;
end;

procedure TNxCustomGrid.WMVScroll(var Message: TWMVScroll);
begin
	if gtEdit in GridState then EndEditing;
  UpdateVertScrollBar;
	inherited;
end;

function TNxCustomGrid.GetColumnDropRect: TRect;
var
	r: Integer;
begin
	r := GetHeaderRect.Right;
  if r > ClientWidth then r := ClientWidth;
  Result := Rect(0, 0, r, GetBodyRect.Top);
end;

procedure TNxCustomGrid.SelectRows(Shift: TShiftState; First, Last: Integer);
var
  i: Integer;
begin
  if (Last = First) or not Multiselect then Exit;
  Include(FGridState, gtMultiSelect);
  if Last < First then First := Last;
  for i := First to Last do
  begin
    if GetRowVisible(i) then Selected[i] := True;
  end;
end;

procedure TNxCustomGrid.SelectRowsInRange(ARect: TRect);
var
  i: Integer;
  FromRow, ToRow: Integer;
  ASelected: Boolean;
begin
  FromRow := GetRowAtPos(ARect.Top);
  ToRow := GetRowAtPos(ARect.Bottom);
  if (ToRow = -1) and not (FromRow = -1) then ToRow := RowCount - 1;
  Include(FGridState, gtMultiSelect);
  for i := 0 to RowCount - 1 do
  begin
    ASelected := (i >= FromRow) and (i <= ToRow) and GetRowVisible(i);
    if ASelected <> Selected[i] then Selected[i] := ASelected;
  end;
end;

procedure TNxCustomGrid.ShowCellTextFitHint(ACol, ARow: Integer);
var
  HintText: WideString;
	HintRect: TRect;
  APoint: TPoint;
begin
  if not ParentFormActive(Self) then Exit;

  RecreateHintWnd;

  FHintPosition := hpTextFit;
  HintRect := GetCellRect(ACol, ARow);
  APoint := Point(HintRect.Left, HintRect.Top);

  HintText := GetHintText(ACol, ARow);
  DoApplyCell(ACol, ARow, HintText);

  if HintText <> '' then
  begin
    HintRect := CalcHintRect(FHintWindow, ClientWidth, HintText);
    APoint := ClientToScreen(APoint);
    OffsetRect(HintRect, APoint.X, APoint.Y);
    ActivateHint(FHintWindow, HintRect, HintText);
  end else DeactivateHint(FHintWindow);
end;

procedure TNxCustomGrid.ShowPositionIndicator(Point: TPoint;
  HideIndicator: Boolean = False);
begin
  if HideIndicator = False then
  begin
    FDownDragArrow.SetBounds(Point.X - 4, Point.Y - 12,
      FDownDragArrow.Width, FDownDragArrow.Height);
    FDownDragArrow.Visible := True;
    FUpDragArrow.SetBounds(Point.X - 4, Point.Y + HeaderSize - 1,
      FUpDragArrow.Width, FUpDragArrow.Height);
    FUpDragArrow.Visible := True;
  end else
  begin
    FDownDragArrow.Visible := False;
    FUpDragArrow.Visible := False;
  end;
end;

function TNxCustomGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if Result and not(gtEdit in GridState) then
  begin
    case (VertScrollBar.Max > 0) and (VertScrollBar.Position < VertScrollBar.Max) of
      True: if ssCtrl in Shift then VertScrollBar.PageDown else VertScrollBar.Next;
      else if (GridStyle = gsReport) and (HorzScrollBar.Max > 0) and not VertScrollBar.Visible
        then if ssCtrl in Shift then HorzScrollBar.PageDown else HorzScrollBar.Next;
    end;
  end;
end;

function TNxCustomGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if Result and not(gtEdit in GridState) then
  begin
    case VertScrollBar.Max > 0 of
      True: if ssCtrl in Shift then VertScrollBar.PageUp else VertScrollBar.Prior;
      else if (GridStyle = gsReport) and (HorzScrollBar.Max > 0)
        then if ssCtrl in Shift then HorzScrollBar.PageUp else HorzScrollBar.Prior;
    end;
  end;
end;

procedure TNxCustomGrid.DoSearchTimer(Sender: TObject);
begin
  FSearchBuffer := '';
  FSearchTimer.Enabled := False;
end;

procedure TNxCustomGrid.DrawRowPosition(const Index: Integer);
var
  RowRect: TRect;
  Y, X: Integer;
begin
  if Index < 0 then Exit;
  with Canvas do
  begin
    case GridStyle of
      gsReport: RowRect := GetRowRect(Index);
      gsSlides: RowRect := GetSlideRect(Index);
    end;
    Pen.Color := clRed;
    Brush.Color := clRed;
    Y := RowRect.Top;
    if Index <> FFirstRow then Dec(Y);
    Polygon([Point(0, Y - 2), Point(2, Y - 2), Point(2, Y - 5),
      Point(7, Y), Point(2, Y + 5), Point(2, Y + 2),
      Point(0, Y + 2), Point(0, Y - 2)]);
    X := RowRect.Right - 1;
    Polygon([Point(X, Y - 2), Point(X - 2, Y - 2), Point(X - 2, Y - 5),
      Point(X - 7, Y), Point(X - 2, Y + 5), Point(X - 2, Y + 2),
      Point(X, Y + 2), Point(X, Y - 2)]);
    Polyline([Point(8, Y), Point(X - 7, Y)]);
  end;
end;

function TNxCustomGrid.FindText(const Index: Integer; S: WideString;
  Options: TSearchOptions): Boolean;
begin
  Result := False;
  if RowCount = 0 then Exit;
  if soFromSelected in Options then
  begin
    Result := Locate(Index, SelectedRow + 1, RowCount - 1, S, Options);
    if not Result and (soContinueFromTop in Options) then Locate(Index, 0, RowCount - 1, S, Options);
  end else Result := Locate(Index, 0, RowCount - 1, S, Options);
end;

function TNxCustomGrid.GetCellAtPos(APoint: TPoint): TPoint;
var
  I, Pos: Integer;
  Column: TNxCustomColumn;
begin
  Result := Point(-1, -1);
  case GridStyle of
    gsReport:
    begin
      Column := GetColumnAtPos(APoint);
      if Assigned(Column) then Result.X := Column.Index;
      Result.Y := GetRowAtPos(APoint.X, APoint.Y);
    end;
    gsSlides:
    begin
      Result.Y := GetSlideAtPos(APoint.X, APoint.Y);
      Pos := APoint.Y - GetSlideTop(Result.Y);
      for I := 0 to Columns.Count - 1 do
        if (APoint.X >= Columns[I].SlideBounds.Left) and (APoint.X < Columns[I].SlideBounds.Right)
          and (Pos >= Columns[I].SlideBounds.Top) and (Pos < Columns[I].SlideBounds.Bottom) then
        begin
          Result.X := Columns[I].Index;
          Break;
        end;
    end;
  end;
end;

function TNxCustomGrid.GetColumnSizeGripAtPos(X,
  Y: Integer): TNxCustomColumn;
var
  I, Indent, Pos: Integer;
  Column: TNxCustomColumn;
begin
  Result := nil;
  for I := 0 to Columns.Count - 1 do
  begin
    Column := Columns.PositionItem[I];
    if I >= FixedCols then Indent := HorzScrollBar.Position else Indent := 0;
    Pos := Column.Left + Column.Width - Indent;
    if Column.Visible and (not (coFixedSize in Column.Options))
      and (X >= (Pos) - 3) and (X <= (Pos) + 2)
        and not((I >= FixedCols) and (X < GetFixedWidth)) then
    begin
      Result := Column;
      Break;
    end;
  end;
end;

function TNxCustomGrid.GetColumnAtPos(Point: TPoint): TNxCustomColumn;
var
  I, Indent, Pos: Integer;
  Column: TNxCustomColumn;
begin
  Result := nil;
  for I := 0 to Columns.Count - 1 do
  begin
    Column := Columns.PositionItem[I];
    if I >= FixedCols then Indent := HorzScrollBar.Position else Indent := 0;
    Pos := Column.Left + Column.Width - Indent;
    if Column.Visible and (Point.X >= Column.Left - Indent) and (Point.X <= Pos) then
    begin
      Result := Column;
      Break;
    end;
  end;
end;

function TNxCustomGrid.GetNearestPosition(Column: TNxCustomColumn; Point: TPoint): Integer;
var
  I, Indent, Pos, Middle: Integer;
  Clipped: Boolean;
  CurColumn, PrevColumn: TNxCustomColumn;
begin
  Result := Column.Position;
  PrevColumn := nil;
  for I := 0 to Columns.Count - 1 do
  begin
    CurColumn := Columns.PositionItem[I];
    if CurColumn.Visible or (CurColumn = Column) then
    begin
      if PrevColumn = nil then PrevColumn := CurColumn;
      if I >= FixedCols then Indent := HorzScrollBar.Position else Indent := 0;
      Pos := CurColumn.Left + CurColumn.Width - Indent;
      if (Point.X >= CurColumn.Left - Indent) and (Point.X <= Pos) then
      begin
        Middle := Pos - CurColumn.Width div 2;
        if Column <> CurColumn then
        begin
          if Point.X > Middle then
          begin
            if CurColumn.Position > Column.Position then Result := CurColumn.Position
              else Result := CurColumn.Position + 1;
          end else
          begin
            if CurColumn.Position < Column.Position then Result := CurColumn.Position
              else Result := PrevColumn.Position;
          end;
        end;
        Clipped := (Result >= FixedCols) and (Pos - CurColumn.Width < GetFixedWidth);
        if Clipped then Result := Column.Position;
        Break;
      end; { hit a spot }
      PrevColumn := CurColumn;
    end; {if visible }
  end;
end;

function TNxCustomGrid.GetNearestRow(const X, Y: Integer): Integer;
var
  Pos, Row, middle, Size: Integer;
begin
  Result := -1;
  Pos := GetBodyRect.Top;
  Row := FirstRow;

  if Y < GetBodyRect.Top then
  begin
    Result := -1;
    Exit;
  end;

  while (Pos < GetBodyRect.Bottom) and (Row < RowCount) do
  begin
    if GetRowVisible(Row) then
    begin
      case GridStyle of
        gsReport: Size := GetRowHeight(Row);
        else Size := SlideSize;
      end;
      if (Y > Pos) and (Y <= Pos + Size + GridSpace[lpTopBottom]) then
      begin
        middle := Pos + (Size div 2);
        if Y > middle then Inc(Row);
        Result := Row;
        Exit;
      end;
      Inc(Pos, Size + GridSpace[lpTopBottom]);
    end;
    Inc(Row);
  end;
end;

function TNxCustomGrid.SearchNext(Index: Integer; S: WideString;
  FromFirst: Boolean = False): Boolean;

  function SearchText(FromRow, ToRow: Integer): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := FromRow to ToRow do
    begin
      { Help: Compares Unicode strings based on the current locale
              WITHOUT case sensitivity. }
      if GetRowVisible(i) then
        Result := WideCompareText(LeftStr(Cells[Index, i], Length(S)), S) = 0;
      if Result then
      begin
        SelectedRow := i;
        if not IsUpdating then ScrollToRow(i);
        Break;
      end;
    end;
  end;

begin
  Result := False;
  if RowCount = 0 then Exit;
  if FromFirst then Result := SearchText(0, Pred(RowCount)) else
  begin
    Result := SearchText(Succ(SelectedRow), Pred(RowCount))
      or SearchText(0, SelectedRow);
  end;
end;

procedure TNxCustomGrid.HideArrows;
begin
  FUpDragArrow.Visible := False;
  FDownDragArrow.Visible := False;
end;

procedure TNxCustomGrid.ShowColumnHint(X, Y: Integer; Text: WideString);
var
  HintRect: TRect;
  APoint: TPoint;
begin
  if not ParentFormActive(Self) then Exit;
  if not Application.ShowHint then Exit;

  RecreateHintWnd;

  HintRect := CalcHintRect(FHintWindow, ClientWidth, Text);
  APoint := ClientToScreen(Point(X, Y));
  OffsetRect(HintRect, APoint.X, APoint.Y);
  ActivateHint(FHintWindow, HintRect, Text);
end;

procedure TNxCustomGrid.UpdateArrows(CurPosition, NewPosition: Integer;
  UseSelf: Boolean = False);
var
  ArrowPoint: TPoint;
  DragColumn, TargetColumn: TNxCustomColumn;
  X: Integer;
begin
  if csDesigning in ComponentState then Exit;
  TargetColumn := Columns.PositionItem[NewPosition];
  DragColumn := Columns.PositionItem[CurPosition];
  if CurPosition <> NewPosition then
  begin
    if DragColumn.Visible then
    begin
      case CurPosition < NewPosition of
        True: case TargetColumn.Location of
                clAlone, clLeftSide: X := TargetColumn.Left;
                else X := TargetColumn.Left + TargetColumn.Width;
              end;
        else X := TargetColumn.Left;
      end;
    end else
    begin
      if NewPosition > CurPosition then
      begin
        case TargetColumn.Location of
          clAlone, clLeftSide: X := TargetColumn.Left + TargetColumn.Width;
          else X := TargetColumn.Left + TargetColumn.Width;
        end;
      end else
      begin
        X := TargetColumn.Left;
      end;
    end;
  end else
  begin
    if UseSelf then
    begin
      X := TargetColumn.Left;
    end else
    begin
      ShowPositionIndicator(Point(0, 0), True);
      Exit;
    end;
  end;
  ArrowPoint := ClientToScreen(Point(X, 0));
  if NewPosition >= FixedCols then Dec(ArrowPoint.X, HorzScrollBar.Position);
  ShowPositionIndicator(ArrowPoint);
end;

procedure TNxCustomGrid.DragCanceled;
begin
  inherited;
  if FCanDeselect then
  begin
    SelectCell(SelectedColumn, SelectedRow);
    FCanDeselect := False;
  end;
end;

function TNxCustomGrid.SearchRow(S: WideString): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Columns.Count - 1 do
  begin
    SearchNext(i, S);
  end;
end;

function TNxCustomGrid.FindTextByRow(const Indices: array of integer;
  S: WideString; Options: TSearchOptions): Boolean;
begin
  Result := False;
  if RowCount = 0 then Exit;
  if soFromSelected in Options then
  begin
        Result := LocateByRow(Indices, SelectedRow + 1, RowCount - 1, S, Options);
        if not Result and (soContinueFromTop in Options) then LocateByRow(Indices, 0, RowCount - 1, S, Options);
  end else Result := LocateByRow(Indices, 0, RowCount - 1, S, Options);
end;

function TNxCustomGrid.LocateByRow(Indices: array of integer; FromRow,
  ToRow: Integer; S: WideString; Options: TSearchOptions): Boolean;
var
  i, a, b: Integer;
begin
  Result := False;
  for i := FromRow to ToRow do
  begin
        for a := 0 to Length(Indices)-1 do
        begin
          b := Indices[a];
          if (b < 0) or (b > RowCount-1) then
                Break;
          if (soSearchInvisible in Options) or GetRowVisible(i) then
          begin
                if soCaseInsensitive in Options then
                begin
                  if soExactMatch in Options then Result := WideCompareText(Cells[b, i], S) = 0
                  else Result := Pos(WideLowerCase(S), WideLowerCase(Cells[b, i])) > 0;
                end else
                begin
                  if soExactMatch in Options then Result := WideCompareStr(Cells[b, i], S) = 0
                  else Result := Pos(S, Cells[b, i]) > 0;;
                end;
                if Result then
                begin
                  SelectedRow := i;
                  FLastFoundRow := i;
                  if not IsUpdating then ScrollToRow(i);
                  Exit;
                end;
          end; { invisible }
        end;
  end; { for }
end;

end.
