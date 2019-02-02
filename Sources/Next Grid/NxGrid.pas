{
  Next Grid
  Copyright (C) 1996-2007 by Berg
  All rights reserved.

  $id:NextGrid.pas bn
}

{$R NxGridRes.res}
{$I '..\NxSuite.inc'}

unit NxGrid;

interface

uses
  Windows, Classes, Messages, Controls, Graphics, SysUtils,
  NxClasses, NxCustomGridControl, NxCustomGrid, NxColumns, NxThemesSupport,
  NxCells, NxDisplays, NxEdit, NxPopupControl
  {$IFDEF UITYPES}, UITypes{$ENDIF}
  ;

type
  TCellFormatingEvent = procedure(Sender: TObject; ACol, ARow: Integer; var TextColor: TColor;
    var FontStyle: TFontStyles; CellState: TCellState) of object;
  TNxRowExpandEvent = procedure(Sender: TObject; ARow: Integer) of object;

  TChildRowPosition = (crFirst, crLast);

  TNextGrid = class(TNxCustomGrid)
	private
    FCells: TCells;
    FLastAddedRow: Integer;
    FOnCellFormating: TCellFormatingEvent;
    FOnCompare: TCompareEvent;
    FOnExpand: TNxRowExpandEvent;
    FStartRowCount: Integer;
    function GetCellByName(ACol, ARow: Variant): TCell;
    function GetExpanded(Index: Integer): Boolean;
    function GetRow(Index: Integer): TRow;
    procedure GetRowsHeight(Index: Integer; var Count, Height: Integer);
    procedure SetExpanded(Index: Integer; const Value: Boolean);
    procedure SetStartRowCount(const Value: Integer);
  protected
    procedure ParentRowProc(var ARow: Integer; var NextSibling: Integer); dynamic;
    function GetCell(ACol, ARow: Integer): TCell; virtual;
    function GetCellColor(ACol, ARow: Integer): TColor; override;
    function GetCellInfo(ACol, ARow: Integer): TCellInfo; override;
    function GetCellHint(ACol, ARow: Integer): WideString; override;
    function GetCells(ACol, ARow: Integer): WideString; override;
    function GetFirstVisibleRow: Integer; override;
    function GetLastVisibleRow: Integer; override;
    function GetRowHeight(Index: Integer): Integer; override;
    function GetRowCount: Integer; override;
    function GetRowImageIndex(Index: Integer): Integer; override;
    function GetRowLevel(Index: Integer): Integer; override;
    function GetRowVisible(Index: Integer): Boolean; override;
    function GetSelected(Index: Integer): Boolean; override;
    function GetVisibleRows: Integer; override;
    function DrawCellData(ACol, ARow: Integer; CellState: TCellState): Boolean; override;
    procedure ApplyCellFormating(ACol, ARow: Integer; Value: WideString; CellState: TCellState); override;
    procedure ColumnsChange(ChangeOpearation: TColumnsOperation;
      Value1: Integer = -1; Value2: Integer = -1); override;
  	procedure DoCellChange(Sender: TObject; ACol, ARow: Integer);
    procedure DoColumnPlayChange(Sender: TObject); override;
    procedure DoColumnPlayExpand(Sender: TObject); override;
    procedure DoCellFormating(ACol, ARow: Integer; var TextColor: TColor; var FontStyle: TFontStyles;
      CellState: TCellState); dynamic;
    procedure DoCellsCompare(Sender: TObject; Cell1, Cell2: TCell; var Compare: Integer);
    procedure DoCompare(Cell1, Cell2: TCell; var Compare: Integer); dynamic;
    procedure DoExpand(Index: Integer); dynamic;
    procedure ExpandRows(Index, Count: Integer; const Value: Boolean);
    function IsCellEmpty(ACol, ARow: Integer): Boolean; override;
    procedure SetCells(ACol, ARow: Integer; const Value: WideString); override;
    procedure SetColumnPlayAttributes(ColumnPlay: TColumnPlay); override;
    procedure SetDisplayParams(ACol, ARow: Integer; Display: TColumnDisplay); override;
    procedure SetRowHeight(Index: Integer; const Value: Integer); override;
    procedure SetRowSize(const Value: Integer); override;
    procedure SetRowVisible(Index: Integer; const Value: Boolean); override;
    procedure SetSelected(Index: Integer; const Value: Boolean); override;
    procedure ShowRow(Index, ARowHeight: Integer; Show: Boolean);
  public
    function AddRow(Count: Integer = 1): Integer; override;
    procedure AddCells(Values: array of WideString); overload;
    procedure AddCells(Values: array of WideString; ColumnIndex: Integer); overload;
    procedure AddChildRow(const Index: Integer; Position: TChildRowPosition = crLast); virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCellColumnIndex(ACell: TCell): Integer;
    function GetCellRowIndex(ACell: TCell): Integer;
    function GetChildCount(const Index: Integer; Recurse: Boolean = True): Integer;
    function GetDrawText(ACol, ARow: Integer): WideString; override;
    function GetFirstChild(const Index: Integer): Integer;
    function GetHintText(ACol, ARow: Integer): WideString; override;
    function GetLastChild(const Index: Integer): Integer;
    function GetLevel(const Index: Integer): Integer;
    function GetNextSibling(const Index: Integer): Integer;
    function GetParent(const Index: Integer): Integer;
    function GetPrevSibling(const Index: Integer): Integer;
    function GetRowIndex(const ARow: TRow): Integer;
    function HasChildren(const Index: Integer): Boolean;
    procedure CalculateFooter(VisibleOnly: Boolean = False); override;
    procedure ClearChildRows(Index: Integer);
    procedure ClearRows; override;
    procedure ClearRow(const Index: Integer);
    procedure DeleteChildRow(ParentIndex, Index: Integer);
    procedure DeleteRow(Index: Integer); override;
    procedure InsertChildRow(const Pos, Index);
    procedure InsertRow(Pos: Integer; Count: Integer = 1); override;
    procedure MoveRow(FromPos, ToPos: Integer); override;
    procedure ReserveRows(Count: Integer); virtual;
    procedure RevertStyle(const Index: Integer); override;
    procedure SelectRange(FromRow, ToRow: Integer; Value: Boolean); override;
    procedure SortColumn(AColumn: TNxCustomColumn; Asending: Boolean); override;
    procedure SwapRows(FromPos, ToPos: Integer); override;
    property CellByName[ACol, ARow: Variant]: TCell read GetCellByName;
    property Cell[ACol, ARow: Integer]: TCell read GetCell;
    property Expanded[Index: Integer]: Boolean read GetExpanded write SetExpanded;
    property LastAddedRow: Integer read FLastAddedRow;
    property Row[Index: Integer]: TRow read GetRow;
    property VisibleRows: Integer read GetVisibleRows;
  published
    property StartRowCount: Integer read FStartRowCount write SetStartRowCount default 0;
    property OnCellFormating: TCellFormatingEvent read FOnCellFormating write FOnCellFormating;
    property OnCompare: TCompareEvent read FOnCompare write FOnCompare;
    property OnExpand: TNxRowExpandEvent read FOnExpand write FOnExpand;
	end;

  { TNxGridPicker }

  TNxGridPicker = class(TNxPopupEdit)
  private
    FGrid: TNextGrid;
    procedure SetGrid(const Value: TNextGrid);
  protected
    procedure BeforeDrop(var APoint: TPoint); override;
    function GetPopupControlClass: TNxPopupControlClass; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Grid: TNextGrid read FGrid write SetGrid;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

  { TNxGridPopupControl }

  TNxGridPopupControl = class(TNxPopupControl)
  private
    FGrid: TNextGrid;
    procedure SetGrid(const Value: TNextGrid);
  protected
    procedure AcquireValue(X, Y: Integer); override;
  public
    property Grid: TNextGrid read FGrid write SetGrid;
  end;

implementation

uses
  NxColumnClasses, NxGridCommon, NxScrollControl, Dialogs, Math;

{ TNextGrid }

constructor TNextGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCells := TCells.Create(Self, Columns);
  FCells.RowHeight := RowSize;
  FCells.OnCellChange := DoCellChange;
  FCells.OnCompare := DoCellsCompare;
  FStartRowCount := 0;
end;

destructor TNextGrid.Destroy;
begin
  FreeAndNil(FCells);
  inherited;
end;

function TNextGrid.GetCellByName(ACol, ARow: Variant): TCell;
begin
  with GetCellByVariant(ACol, ARow) do Result := GetCell(X, Y);
end;

function TNextGrid.GetExpanded(Index: Integer): Boolean;
begin
  Result := FCells.Row[Index].Expanded;
end;

function TNextGrid.GetRow(Index: Integer): TRow;
begin
  Result := FCells.Row[Index];
end;

procedure TNextGrid.GetRowsHeight(Index: Integer; var Count, Height: Integer);
var
  Row: Integer;
  procedure SetRowsDelta(Index: Integer; var Delta, Row: Integer;
    Visible: Boolean);
  var
    I: Integer;
  begin
    Row := Index;
    for I := 1 to FCells.Row[Index].ChildCount do
    begin
      Inc(Row);
      Inc(Count);
      if Visible then Inc(Delta, GetRowHeight(Row) + GridSpace[lpTopBottom]);
      if FCells.Row[Row].ChildCount > 0 then
        SetRowsDelta(Row, Delta, Row, Visible and FCells.Row[Row].Expanded)
    end;
  end;
begin
  Row := 0;
  Count := 0;
  Height := RowHeight[Index] + GridSpace[lpTopBottom];
  SetRowsDelta(Index, Height, Row, FCells.Row[Index].Expanded);
end;

procedure TNextGrid.SetExpanded(Index: Integer; const Value: Boolean);
begin
  if Row[Index].Expanded <> Value then
  begin
    { Set Property and Refresh }
    Row[Index].Expanded := Value;
    RefreshRow(Index);

    if Row[Index].HasChildren then
    begin
      ExpandRows(Index, Row[Index].ChildCount, Value);
      { 1/15/12: ScrollBar Updated inside ExpandRows }
//      UpdateVertScrollBar;
    end;

    { Trigger Event }
    DoExpand(Index);
  end;
end;

procedure TNextGrid.SetRowVisible(Index: Integer; const Value: Boolean);
var
  ARowHeight: Integer;
begin
  if RowVisible[Index] <> Value then
  begin
    FCells.ShowRow(Index, Value);
    case GridStyle of
      gsReport: ARowHeight := GetRowHeight(Index);
      gsSlides: ARowHeight := SlideSize;
      else ARowHeight := 0;
    end;
    { Bn: FirstRow is set inside ShowRow }
    if not IsUpdating then { don't show if begin/end update }
      ShowRow(Index, ARowHeight, Value);
    inherited;
  end;
end;

procedure TNextGrid.SetRowHeight(Index: Integer; const Value: Integer);
var
  DeltaY: Integer;
  RepaintRect: TRect;
begin
  if RowHeight[Index] <> Value then
  begin
    DeltaY := Value - GetRowHeight(Index);
    FCells.Row[Index].RowHeight := Value;
    inherited;
    if GetRowVisible(Index) then
    begin
      if not IsUpdating then
      begin
        RefreshRow(Index);
        RepaintRect := GetBodyRect;
        RepaintRect.Left := 0;
        RepaintRect.Top := GetRowTop(Index) + Value;
        ScrollWindowEx(Handle, 0, DeltaY, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
        UpdateVertScrollBar;
      end;
    end;
  end;
end;

procedure TNextGrid.SetRowSize(const Value: Integer);
begin
  inherited;
  FCells.RowHeight := Value;
end;

procedure TNextGrid.ApplyCellFormating(ACol, ARow: Integer;
  Value: WideString; CellState: TCellState);
var
  TextColor: TColor;
  AFontStyle: TFontStyles;
begin
  with Canvas do
  begin
    AFontStyle := Cell[ACol, ARow].FontStyle;
    TextColor := Font.Color;
    if not(csSelected in CellState) then TextColor := Cell[ACol, ARow].TextColor;
    if csBoldTextSelection in CellState then AFontStyle := AFontStyle + [fsBold];
    DoCellFormating(ACol, ARow, TextColor, AFontStyle, CellState);
    Font.Color := TextColor;
    Font.Style := AFontStyle;
  end;
end;

procedure TNextGrid.DoCellChange(Sender: TObject; ACol, ARow: Integer);
begin
	if not IsUpdating then
  begin
    RefreshCell(ACol, ARow);
    DoChange(ACol, ARow);
  end;
end;

procedure TNextGrid.DoCellFormating(ACol, ARow: Integer;
  var TextColor: TColor; var FontStyle: TFontStyles;
  CellState: TCellState);
begin
  if Assigned(FOnCellFormating) then FOnCellFormating(Self, ACol, ARow, TextColor, FontStyle, CellState);
end;

procedure TNextGrid.DoCompare(Cell1, Cell2: TCell; var Compare: Integer);
begin
  if Assigned(FOnCompare) then FOnCompare(Self, Cell1, Cell2, Compare);
end;

procedure TNextGrid.DoExpand(Index: Integer);
begin
  if Assigned(FOnExpand) then FOnExpand(Self, Index); 
end;

procedure TNextGrid.DoCellsCompare(Sender: TObject; Cell1, Cell2: TCell;
  var Compare: Integer);
begin
  DoCompare(Cell1, Cell2, Compare);
end;

procedure TNextGrid.ExpandRows(Index, Count: Integer;
  const Value: Boolean);

  procedure Collapse(const Index: Integer);
  var
    i: Integer;
  begin
    i := Succ(Index);
    while (i < RowCount)
      and (Row[i].Level > Row[Index].Level) do
    begin
      if Row[i].Shown then
      begin
        FCells.ExpandRow(i, False);

        if i > FLastVisibleRow then
          Dec(FLastVisibleRow);

        { Hide Row, and Scroll content }
        ShowRow(i, Row[i].RowHeight, False);
      end;
      Inc(i);
    end;
  end;

  procedure Expand(Index: Integer);
  var
    i: Integer;
  begin
    i := Succ(Index);
    while (i < RowCount)
      and (Row[i].Level > Row[Index].Level) do
    begin
      if not Row[i].Shown then
      begin
        { Set Shown to True,
          and Inc FVisibleRowCount }
        FCells.ExpandRow(i, True);

        if i > FLastVisibleRow
          then FLastVisibleRow := i;

        ShowRow(i, Row[i].RowHeight, True);
      end;

      if not Row[i].Expanded then
        Inc(i, GetChildCount(i, True));

      Inc(i);
    end;
  end;

begin
  if Value then Expand(Index)
    else Collapse(Index);
end;

function TNextGrid.IsCellEmpty(ACol, ARow: Integer): Boolean;
begin
  Result := Cell[ACol, ARow].Empty or inherited IsCellEmpty(ACol, ARow);
end;

procedure TNextGrid.ColumnsChange(ChangeOpearation: TColumnsOperation;
  Value1, Value2: Integer);
begin
  inherited ColumnsChange(ChangeOpearation, Value1, Value2);
  FCells.ColumnsChange(ChangeOpearation, Value1, Value2);
end;

procedure TNextGrid.DoColumnPlayChange(Sender: TObject);
var
  Accept: Boolean;
begin
  Accept := True;
  with Sender as TColumnPlay do
  begin
    DoEditAccept(Col, Row, AsString, Accept);
    if Accept then
    begin
      case Column.ColumnType of
        ctBoolean: Cell[Col, Row].AsBoolean := AsBoolean;
        ctInteger: Cell[Col, Row].AsInteger := AsInteger;
      end;
      DoAfterEdit(Col, Row, Cell[Col, Row].AsString);
    end;
  end;
end;

procedure TNextGrid.DoColumnPlayExpand(Sender: TObject);
begin
  with Sender as TColumnPlay do
  begin
    Expanded[Row] := not Expanded[Row];
  end;
end;

function TNextGrid.DrawCellData(ACol, ARow: Integer; CellState: TCellState): Boolean;
var
  DisplayText: WideString;
  CellInfo: TCellInfo;
begin
	inherited DrawCellData(ACol, ARow, CellState);
  CellInfo := GetCellInfo(ACol, ARow);
  with CellInfo, Columns[ACol] do
  begin
    DisplayText := AsString;
    case ColumnType of
      ctAutoInc: Display.AsInteger := ARow;
      ctBoolean: Display.AsBoolean := AsBoolean;
      ctDate: Display.AsDateTime := AsDateTime;
      ctFloat: Display.AsFloat := AsFloat;
      ctInteger: Display.AsInteger := AsInteger;
      ctString: Display.AsString := AsString;
      ctGraphic: Display.ObjectReference := CellInfo.ObjectReference;
      ctGuid: Display.AsString := AsString;
      ctVirtual: Display.AsString := AsString;
    end;
  end;
  ApplyCellFormating(ACol, ARow, DisplayText, CellState);
  Result := True;
end;

procedure TNextGrid.ParentRowProc(var ARow: Integer; var NextSibling: Integer);
begin
  NextSibling := GetNextSibling(ARow);
  ARow := GetParent(ARow);
end;

function TNextGrid.GetCell(ACol, ARow: Integer): TCell;
begin
  Result := FCells.Cell[ACol, ARow];
end;

function TNextGrid.GetCellColor(ACol, ARow: Integer): TColor;
begin
  if not Columns[ACol].ParentCellColor then Result := FCells[ACol, ARow].Color
    else Result := inherited GetCellColor(ACol, ARow);
end;

function TNextGrid.GetCellInfo(ACol, ARow: Integer): TCellInfo;
begin
  with Result do
  begin
    case Columns[ACol].ColumnType of
      ctAutoInc: AsInteger := ARow;
      ctBoolean: AsBoolean := Cell[ACol, ARow].AsBoolean;
      ctDate: AsDateTime := Cell[ACol, ARow].AsDateTime;
      ctFloat: AsFloat := Cell[ACol, ARow].AsFloat;
      ctInteger: AsInteger := Cell[ACol, ARow].AsInteger;
      ctString, ctGuid, ctVirtual: AsString := Cell[ACol, ARow].AsString;
      ctGraphic: ObjectReference := Cell[ACol, ARow].ObjectReference;
    end;
  end;
end;

function TNextGrid.GetCellHint(ACol, ARow: Integer): WideString;
begin
  Result := FCells[ACol, ARow].Hint;
  DoCellHint(ACol, ARow, Result); { event }
end;

procedure TNextGrid.SetCells(ACol, ARow: Integer; const Value: WideString);
begin
  try
    if (ARow < 0) or (ARow > RowCount - 1) or (ACol < 0)
      or (ACol > Columns.Count - 1) then raise Exception.Create(exCellOut + ' (' + IntToStr(ACol) + ', ' + IntToStr(ARow) + ')');
  except
    Exit;
  end;
  Cell[ACol, ARow].AsString := Value;
end;

procedure TNextGrid.SetDisplayParams(ACol, ARow: Integer;
  Display: TColumnDisplay);
begin
  inherited;
  if Columns[ACol] is TNxTreeColumn then
  begin
    Display.OnParentRow := ParentRowProc;
    Display.RowIndex := ARow;
    Display.IsFirst := FFirstVisibleRow = ARow;
    Display.IsLast := GetNextSibling(ARow) = -1;
    Display.ChildCount := FCells.Row[ARow].ChildCount;
    Display.Level := FCells.Row[ARow].Level;
    Display.Expanded := FCells.Row[ARow].Expanded;
  end;
end;

procedure TNextGrid.SetColumnPlayAttributes(ColumnPlay: TColumnPlay);
begin
  ColumnPlay.Level := FCells.Row[ColumnPlay.Row].Level;
  case ColumnPlay.Column.ColumnType of
    ctBoolean:  ColumnPlay.AsBoolean := Cell[ColumnPlay.Col, ColumnPlay.Row].AsBoolean;
    ctInteger:  ColumnPlay.AsInteger := Cell[ColumnPlay.Col, ColumnPlay.Row].AsInteger;
    ctString:   ColumnPlay.AsString := GetDrawText(ColumnPlay.Col, ColumnPlay.Row);
  end;
end;

procedure TNextGrid.SetSelected(Index: Integer; const Value: Boolean);
begin
  if RowExist(Index) and (Selected[Index] <> Value) then
  begin
    FCells.Row[Index].Selected := Value;

    { boki: Need code when there are rows selected }
    //todo: causes a problem with checkbox column and editing
    //if Value then Include(FGridState, gtMultiSelect);

    case GridStyle of
      gsReport: RefreshRow(Index);
      gsSlides: RefreshSlide(Index, soHideSelection in SlidesOptions);
    end;
  end
end;

procedure TNextGrid.ShowRow(Index, ARowHeight: Integer; Show: Boolean);
var
  RepaintRect: TRect;
  Delta: Integer;
begin
  RepaintRect := GetBodyRect;
  RepaintRect.Left := 0;

  if VisibleRows = 0 then
  begin
    RepaintRect.Top := GetRowTop(Index);
    Delta := 0 - ARowHeight - GridSpace[lpTopBottom];
    FFirstRow := 0;
    ScrollWindowEx(Handle, 0, Delta, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
  end;

  if Index = FFirstRow then
  begin
    if Show then Delta := ARowHeight + GridSpace[lpBottom] else
    begin                 
      if not VertScrollBar.IsLast then
      begin
        if GetVisibleRows > 0 then
          while (FFirstRow < RowCount) and not GetRowVisible(FFirstRow)
            do Inc(FFirstRow);
        { Bn: If row is last, Pos will be larger than Max,
              and pos will be moved and scrolled back }
      end;
      Delta := -(ARowHeight + GridSpace[lpTopBottom]);
      if VertScrollBar.IsLast then VertScrollBar.Prior;
    end;
    ScrollWindowEx(Handle, 0, Delta, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
  end else if Index > FFirstRow then
  begin
    if IsUpdating then Exit;
    case GridStyle of
      gsReport: RepaintRect.Top := GetRowTop(Index);
      gsSlides: RepaintRect.Top := GetSlideTop(Index);
    end;
    Delta := ARowHeight + GridSpace[lpTopBottom];
    if not Show then Delta := -Delta;
    ScrollWindowEx(Handle, 0, Delta, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
    { 1/16/12: Need investigation }
    if VertScrollBar.IsLast then VertScrollBar.Prior;
  end else if Index < FFirstRow then
  begin
    { Bn: Row is outside view, before current scroll pos }
    if not VertScrollBar.IsFirst then
    begin
      try
        VertScrollBar.BeginUpdate;
        if Show then VertScrollBar.Next else
        begin
          { Hide }
          if VertScrollBar.IsLast then VertScrollBar.Next
            else VertScrollBar.Prior;
        end;
      finally
        VertScrollBar.EndUpdate;
      end;
    end else
    begin
      if Show then
      begin
        FFirstRow := Index;
        Delta := ARowHeight + GridSpace[lpTopBottom];
      end else Delta := -ARowHeight + GridSpace[lpTopBottom];
      ScrollWindowEx(Handle, 0, Delta, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
    end;
  end;

  UpdateVertScrollBar;
end;

function TNextGrid.GetCells(ACol, ARow: Integer): WideString;
begin
  try
    if (ARow < 0) or (ARow > RowCount - 1) or (ACol < 0) or (ACol > Columns.Count - 1)
      then raise Exception.Create(exCellOut + ' (' + IntToStr(ACol) + ', ' + IntToStr(ARow) + ')');
  except
    Exit;
  end;
  Result := Cell[ACol, ARow].AsString;
end;

function TNextGrid.GetRowCount: Integer;
begin
  Result := FCells.RowCount;
end;

function TNextGrid.GetRowLevel(Index: Integer): Integer;
begin
  Result := FCells.Row[Index].Level;
end;

function TNextGrid.GetRowVisible(Index: Integer): Boolean;
begin
  Result := Row[Index].Visible and Row[Index].Shown;
end;

function TNextGrid.GetRowHeight(Index: Integer): Integer;
begin
  { Default }
  Result := RowSize;

  { Inside bounds }
  if RowExist(Index)
    then Result := FCells.Row[Index].RowHeight;

  { Trigger event }
  DoMeasuringRowHeight(Index, Result);
end;

function TNextGrid.GetRowImageIndex(Index: Integer): Integer;
begin
  Result := FCells.Row[Index].ImageIndex;
end;

function TNextGrid.GetRowIndex(const ARow: TRow): Integer;
begin
  Result := FCells.GetRowIndex(ARow);
end;

function TNextGrid.GetSelected(Index: Integer): Boolean;
begin
  Result := FCells.Row[Index].Selected;
end;

function TNextGrid.GetVisibleRows: Integer;
begin                  
  Result := FCells.VisibleRowCount;
end;

function TNextGrid.GetCellColumnIndex(ACell: TCell): Integer;
begin
  Result := FCells.GetCellColumnIndex(ACell);
end;

function TNextGrid.GetCellRowIndex(ACell: TCell): Integer;
begin
  Result := FCells.GetCellRowIndex(ACell);
end;

function TNextGrid.GetChildCount(const Index: Integer;
  Recurse: Boolean = True): Integer;
begin
  if Recurse then Result := FCells.GetChildCount(Index)
    else Result := FCells.GetChildsCount(Index);
end;

function TNextGrid.GetDrawText(ACol, ARow: Integer): WideString;
begin
  Result := Columns[ACol].GetDrawText(GetCellInfo(ACol, ARow));
end;

function TNextGrid.GetFirstChild(const Index: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  if RowCount = 0 then Exit;
  for i := Index + 1 to Pred(RowCount) do
  begin
    if GetLevel(i) > GetLevel(Index) then
    begin
      Result := i;
      Break
    end else Exit;
  end;
end;

function TNextGrid.GetFirstVisibleRow: Integer;
begin
  Result := FFirstVisibleRow;
end;

function TNextGrid.GetHintText(ACol, ARow: Integer): WideString;
begin
  Result := Columns[ACol].GetHintText(GetCellInfo(ACol, ARow));
end;

function TNextGrid.GetLastVisibleRow: Integer;
begin
  Result := FLastVisibleRow;
end;

function TNextGrid.GetLastChild(const Index: Integer): Integer;
var
  i, i2: Integer;
begin
  Result := -1;
  if RowCount = 0 then Exit;
  i2 := Index + 1;
  for i := i2 to Pred(RowCount) do
  begin
    if GetLevel(i) <= GetLevel(Index) then
    begin
      Result := i2;
      Exit;
    end;
    i2 := i;
  end;
  Result := i2;
end;

function TNextGrid.GetLevel(const Index: Integer): Integer;
begin
  Result := FCells.Row[Index].Level;
end;

function TNextGrid.GetNextSibling(const Index: Integer): Integer;
var 
  i: Integer; 
begin 
  Result := -1;
  for i := Index + 1 to Pred(RowCount) do
    if GetLevel(i) >= GetLevel(Index) then
    begin
      if GetLevel(i) = GetLevel(Index) then
      begin
        Result := i;
        Break;
      end
    end else Exit;
end;

function TNextGrid.GetParent(const Index: Integer): Integer;
var
  r: TRow;
  i: Integer;
begin
  Result := -1;
  if (GetLevel(Index) > 0) then
  begin
    r := FCells.Row[Index].ParentRow;
    { Find Index of Parent row }
    if Assigned(r) then
      for i := 0 to Pred(RowCount) do
        if (r = FCells.Row[i]) then
        begin
          Result := i;
          Break;
        end;
  end;
end;

function TNextGrid.GetPrevSibling(const Index: Integer): Integer;
var 
  i: Integer;
begin 
  Result := -1;
  for i := Index - 1 downto 0 do
    if GetLevel(i) >= GetLevel(Index) then
    begin
      if GetLevel(i) = GetLevel(Index) then
      begin
        Result := i;
        Break;
      end
    end else Exit;
end;

function TNextGrid.HasChildren(const Index: Integer): Boolean;
begin
  Result := FCells.Row[Index].ChildCount > 0;
end;

procedure TNextGrid.AddCells(Values: array of WideString);
var
  i, Col: Integer;
begin
  AddRow;
  i := 0;
  if Columns.Empty then Exit;
  while i < Length(Values) do
  begin
    for Col := 0 to Columns.Count - 1 do
    begin
      Cells[Col, RowCount - 1] := Values[i];
      Inc(i);
      if i >= Length(Values) then Exit;
    end;
    if i < Length(Values) then AddRow;
  end;
end;

procedure TNextGrid.AddCells(Values: array of WideString;
  ColumnIndex: Integer);
var
  i: Integer;
begin
  if Length(Values) > RowCount then
    RowCount := Length(Values);
  for i := 0 to Length(Values) - 1 do
  begin
    Cell[ColumnIndex, i].AsString := Values[i];
  end;
end;

procedure TNextGrid.AddChildRow(const Index: Integer;
  Position: TChildRowPosition);
var
  Pos, Col: Integer;
begin
  case Position of
    crFirst: Pos := Index + 1;
    else Pos := Index + GetChildCount(Index) + 1;
  end;

  { Add Row into List }
  FCells.AddChildRow(Index, Pos);

  { Set Default Values }
  if goUseDefaultValues in Options then
  begin
    for Col := 0 to Pred(Columns.Count) do
      if Columns[Col].DefaultValue <> EmptyStr
        then Cells[Col, Pos] := Columns[Col].DefaultValue;
  end;

  { FFirstRow push }
  if Pos <= FFirstRow then Inc(FFirstRow);

  if Row[Pos].Shown then
    ShowRow(Pos, RowSize, True);

  { LastRow in View, must be set
    before RefreshRow may be called }
  FLastRow := LastRowInView;

  { Refresh +/- Sign }
  if not IsUpdating
    and Row[Index].Shown
    and (Row[Index].ChildCount = 1)
      then RefreshRow(Index);

  FLastAddedRow := Pos;

  if Row[Pos].Shown then
  begin
    { Update FLastVisibleRow }
    if Pos > FLastVisibleRow
      then FLastVisibleRow := Pos;
  end else
    if Pos <= FLastVisibleRow then
      Inc(FLastVisibleRow);

  if not IsUpdating then
    UpdateVertScrollBar;

  { Trigger Event }
  DoDataChange(dcAddChildRow, FLastAddedRow);
end;

function TNextGrid.AddRow(Count: Integer = 1): Integer;
var
  I, J, PrevCount: Integer;
begin

  Result := FLastAddedRow;
  if (Count < 1) then Exit;
  PrevCount := RowCount;
  FCells.AddRow(Count);

	if goUseDefaultValues in Options then { using default values may slow down adding rows }
  begin
	  for I := RowCount - Count to RowCount - 1 do
			for J := 0 to Columns.Count - 1 do
	    	if Columns[J].DefaultValue <> '' then Cells[J, I] := Columns[J].DefaultValue;
  end;

  if UpdateCount = 0 then
  begin
  	if (GridLinesStyle = lsFramed) and (goGrid in Options)
      and (RowCount > 1) and (PrevCount > 0) then RefreshRowGrid(PrevCount - 1);
    RefreshRowGrid(RowCount - 1);
    { refresh added items }
    RefreshVisibleRows(RowCount - Count, RowCount - 1);
  end;

  FLastAddedRow := RowCount - 1;
  FLastVisibleRow := FLastAddedRow;
  if not IsUpdating then UpdateVertScrollBar;

  Result := FLastAddedRow;
  DoDataChange(dcAddRow, FLastAddedRow);
end;

procedure TNextGrid.CalculateFooter;
var
  i, ActualRowCount: Integer;
  FormulaResult: Double;

  procedure ColumnSum(Index: Integer; var Sum: Double);
  var
    i: Integer;
  begin
    for i := 1 to Pred(RowCount) do
      if (not VisibleOnly or RowVisible[i])
        and IsCalculateRow(i)
          then Sum := Sum + Cell[Index, i].AsFloat;
  end;

  function CalculateColumn(Index: Integer; FormulaKind: TFormulaKind): Double;
  var
    i: Integer;
    FormulaSum: Double;
    s: WideString;
    sl: TStringList;
  begin
    FormulaSum := 0;

    if (not VisibleOnly or RowVisible[FFirstVisibleRow])
      and (FormulaKind <> fkCount)
      and (FormulaKind <> fkCustom)
        then FormulaSum := Cell[Index, FFirstVisibleRow].AsFloat;

    case FormulaKind of
      fkAverage:  begin
                    ColumnSum(Index, FormulaSum);
                    FormulaSum := FormulaSum / ActualRowCount;
                  end;
      fkCount:    FormulaSum := ActualRowCount;
      fkCustom:   DoColumnFooterValue(Index, FormulaSum);
      fkDistinct: begin
                    sl := TStringList.Create;
                    for i := 0 to RowCount - 1 do
                      if (not VisibleOnly or RowVisible[i]) { visible only }
                        and IsCalculateRow(i) then
                      begin
                        s := Cells[Index, i];
                        if sl.IndexOf(s)= - 1 then
                        sl.Add(s);
                      end;
                    FormulaSum := sl.Count;
                    FreeAndNil(sl);
                  end;
      fkMaximum:  for i := 1 to Pred(RowCount) do
                    if (not VisibleOnly or RowVisible[i])
                      and IsCalculateRow(i)
                        and (Cell[Index, i].AsFloat > FormulaSum)
                          then FormulaSum := Cell[Index, i].AsFloat;
      fkMinimum:  for i := 1 to Pred(RowCount) do
                    if (not VisibleOnly or RowVisible[i])
                      and IsCalculateRow(i)
                        and (Cell[Index, i].AsFloat < FormulaSum)
                          then FormulaSum := Cell[Index, i].AsFloat;
      fkSum:      ColumnSum(Index, FormulaSum);
    end;
    DoFooterCalculate(Index, FormulaSum); { event }
    Result := FormulaSum;
  end;
begin
  if VisibleOnly then ActualRowCount := FCells.VisibleRowCount
    else ActualRowCount := RowCount;

  for i := 0 to Pred(Columns.Count) do
  begin
    if Columns[i].Footer.FormulaKind <> fkNone then
      if ActualRowCount = 0 then
      begin
        Columns[i].Footer.Caption := '0';
        Columns[i].Footer.FormulaValue := 0;
      end else
      begin
        FormulaResult := CalculateColumn(i, Columns[i].Footer.FormulaKind);
        Columns[i].Footer.Caption := FloatToStr(FormulaResult);
        Columns[i].Footer.FormulaValue := FormulaResult;
      end;
  end;
end;

procedure TNextGrid.ClearRows;
begin
  inherited ClearRows;
  FCells.ClearRows;
  FFirstRow := 0;
  FFirstVisibleRow := 0;
  FLastVisibleRow := 0;
  RefreshArea(gaBody);
  RefreshArea(gaFooter);
  RefreshArea(gaIndicator);
  UpdateHorzScrollBar;
  UpdateVertScrollBar;
  DoDataChange(dcClearRows, -1);
end;

procedure TNextGrid.ClearRow(const Index: Integer);
var
  I: Integer;
begin
  if RowExist(Index) then
    for I := 0 to Pred(Columns.Count) do Cell[I, Index].Clear;  
end;

procedure TNextGrid.ClearChildRows(Index: Integer);
var
  Row, RowCount, RowHeight: Integer;
begin
  GetRowsHeight(Index, RowCount, RowHeight);
  for Row := Index + RowCount downto Index + 1 do FCells.DeleteRow(Row);
  FCells.Row[Index].Clear;
  Invalidate;
end;

procedure TNextGrid.DeleteChildRow(ParentIndex, Index: Integer);
var
  Count: Integer;
begin
  Count := GetChildCount(ParentIndex);
  if Count > 0 then
  begin
    DeleteRow(FCells.GetAbsoluteIndex(ParentIndex, Index));
    if Count = 1 then RefreshRow(ParentIndex);
  end;
end;

procedure TNextGrid.DeleteRow(Index: Integer);
var
  RowHeight: Integer;
  AVisible: Boolean;
begin
  inherited;
  if FCells.Row[Index].ChildCount > 0
    then ClearChildRows(Index);

  if Assigned(FCells.Row[Index].ParentRow)
    then FCells.Row[Index].ParentRow.DeleteChild;

  if GridStyle = gsReport
    then RowHeight := Self.RowHeight[Index]
    else RowHeight := SlideSize;

  AVisible := GetRowVisible(Index);
  FCells.DeleteRow(Index);

  if AVisible then { Row was visible }
  begin
    if Index < FFirstVisibleRow then FFirstVisibleRow := GetFirstVisible(0);
    if Index >= FLastVisibleRow then FLastVisibleRow := GetLastVisible(RowCount - 1)
      else Dec(FLastVisibleRow);
    if (Index < FFirstRow) and (FFirstRow > 0) then Dec(FFirstRow);
  end;

  ShowRow(Index, RowHeight, False); { Update FFirstRow if neccesary }

  { Select last visible row if needed }
//  if SelectedRow >= FLastVisibleRow then SetSelectedCell(SelectedColumn, FLastVisibleRow);
  if SelectedRow >= FLastVisibleRow then
  begin
    DoDeselectCell(SelectedColumn,SelectedRow);
    SetSelectedCell(SelectedColumn, FLastVisibleRow);
  end;
  RefreshSelectedCells;
  UpdateVertScrollBar;
  DoDataChange(dcDeleteRow, Index);

  { Update LastAddedRow }
  if FLastAddedRow > Pred(RowCount) then FLastAddedRow := Pred(RowCount);
end;

procedure TNextGrid.InsertChildRow(const Pos, Index);
begin

end;

procedure TNextGrid.InsertRow(Pos: Integer; Count: Integer);
var
  i, ARowHeight: Integer;
begin
  if Count > 0 then
  begin
    { Stop editing & Set FirstVisible }
    inherited InsertRow(Pos, Count);

    FCells.InsertRow(Pos, Count);

    case GridStyle of
      gsReport: ARowHeight := RowSize;
      else ARowHeight := SlideSize;
    end;

    { Shift rows }
    for i := 0 to Pred(Count) do
      ShowRow(Pos + i, ARowHeight, True);

    if Pos > FLastVisibleRow then
    begin
      FLastVisibleRow := Pos + Count;
    end
    else Inc(FLastVisibleRow, Count);

    { LastAddedRow Prop. }
    FLastAddedRow := Pos;

    { Move Sel. }
    SelectedRow := SelectedRow + Count;

    { Trigger event }
    DoDataChange(dcInsertRow, Pos);
  end;
end;

{procedure TNextGrid.MoveChild(const Index, ParentIndex: Integer;
  Position: TChildRowPosition);
var
  Pos, i, Delta: Integer;
  ParentRow: TRow;
begin
  ParentRow := Row[ParentIndex];
  if FCells.Row[ParentIndex] <> FCells.Row[Index].ParentRow then
  begin
    ParentRow.AddChild;
    if Index > ParentIndex then
    begin
      case Position of
        crFirst: Pos := ParentIndex + 1;
        else Pos := ParentIndex + FCells.GetChildCount(ParentIndex) + 1;
      end;
    end else if ParentIndex > Index then
    begin
      case Position of
        crFirst: Pos := ParentIndex + 1;
        else Pos := ParentIndex + FCells.GetChildCount(ParentIndex);
      end;
    end else Exit;
    FCells.MoveRow(Index, Pos);
    if ParentRow.ChildCount > 0 then
    begin
      Delta := ParentRow.Level - Row[Index].Level;
      for i := Index to Row[Index].ChildCount do
      begin
        Row[i].Level := Row[i].Level + Delta;
      end;
    end;
    FCells.Row[Pos].ParentRow := Row[ParentIndex];
    FCells.MoveChildRow(Pos, ParentRow);
  end;
end; }

procedure TNextGrid.MoveRow(FromPos, ToPos: Integer);
var
  FromVisible, ToVisible: Boolean;
begin
  inherited;
  if FromPos = ToPos then Exit;
  FromVisible := RowVisible[FromPos];
  ToVisible := RowVisible[ToPos];
  FCells.MoveRow(FromPos, ToPos);
  if FromVisible then
  begin
    if FromPos > ToPos then
    begin
      if ToPos < FFirstVisibleRow then FFirstVisibleRow := ToPos;
      if FromPos = FLastVisibleRow then FLastVisibleRow := GetLastVisible(FromPos);
    end else
    begin
      if FromPos = FFirstVisibleRow then FFirstVisibleRow := GetFirstVisible(FromPos);
      if ToPos > FLastVisibleRow then FLastVisibleRow := ToPos;
    end;
    if not ToVisible then ShowRow(ToPos, RowHeight[ToPos], True);
  end;
end;

procedure TNextGrid.ReserveRows(Count: Integer);
begin
  FCells.AddRow(Count);
  FLastAddedRow := RowCount - 1;
  FLastVisibleRow := FLastAddedRow;
  Invalidate;
  RefreshCellEditor;
end;

procedure TNextGrid.RevertStyle(const Index: Integer);
var
  i: Integer;
begin
  if Columns.Exists(Index) then
  begin
    for i := 0 to Pred(RowCount) do
    begin
      Cell[Index, i].Color := Columns[Index].Color;
      Cell[Index, i].FontStyle := Columns[Index].Font.Style;
      Cell[Index, i].TextColor := Columns[Index].Font.Color;
    end;
  end;
end;

procedure TNextGrid.SelectRange(FromRow, ToRow: Integer; Value: Boolean);
var
  i: Integer;
begin
  if RowExist(FromRow) and RowExist(ToRow) then
  begin
    for i := FromRow to ToRow do
      FCells.Row[i].Selected := Value;
    RefreshRange(FromRow, ToRow);
  end;
end;

procedure TNextGrid.SortColumn(AColumn: TNxCustomColumn; Asending: Boolean);
var
	ASortKind: TSortKind;
  ASelectedRow: TRow;
begin
  inherited;
  ASelectedRow := nil;
  if coCanSort in AColumn.Options then
  begin
  	if Asending then ASortKind := skAscending
      else ASortKind := skDescending;

    { Remember selected row }
    if RowExist(SelectedRow) then ASelectedRow := FCells.Row[SelectedRow];
    FCells.SortColumn(AColumn.Index, AColumn.SortType, ASortKind, coFullResort in AColumn.Options);

    { Find old selected row (after sorting) and set it active }
    if Assigned(ASelectedRow) then SelectedRow := FCells.GetRowIndex(ASelectedRow);
    if SelectedRow > -1 then ScrollToRow(SelectedRow);

    { Retreive FFirstRow again. Find row with visible (!) index = VertScrollBar.Position }
    FFirstRow := GetFirstRow;

    FFirstVisibleRow := GetFirstVisible(0);
    FLastVisibleRow := GetLastVisible(Pred(RowCount));

    RefreshArea(gaBody);
    if goIndicator in Options then RefreshArea(gaIndicator);

    DoAfterSort(AColumn.Index);
  end;
end;

procedure TNextGrid.SwapRows(FromPos, ToPos: Integer);
begin
  FCells.SwapRows(FromPos, ToPos);
  if UpdateCount = 0 then
  begin
  RefreshRow(FromPos);
  RefreshRow(ToPos);
  end;
end;

procedure TNextGrid.SetStartRowCount(const Value: Integer);
var
  i: Integer;
begin
  if Value = FStartRowCount then Exit;
  if Value < 0 then Exit;
  if Value > FStartRowCount then
  begin
    AddRow(Value - FStartRowCount);
  end else
  begin
    if FStartRowCount < RowCount then
    begin
      for i := Value + 1 to FStartRowCount do DeleteRow(0);
    end else
    begin
      for i := Value + 1 to RowCount do DeleteRow(0);
    end;
  end;
  FStartRowCount := Value;
  Invalidate;
end;

{ TNxGridEdit }

procedure TNxGridPicker.BeforeDrop(var APoint: TPoint);
begin
  inherited;
  with PopupControl as TNxGridPopupControl do
  begin
    Parent := Self;
    Width := 200;
    Height := 200;
    Grid := Self.Grid;
//    Parent := get
  end;
end;

constructor TNxGridPicker.Create(AOwner: TComponent);
begin
  inherited;
  FGrid := nil;
end;

function TNxGridPicker.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if Assigned(FGrid)
    then Result := FGrid.DoMouseWheelDown(Shift, MousePos)
    else Result := inherited DoMouseWheelDown(Shift, MousePos);
end;

function TNxGridPicker.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if Assigned(FGrid)
    then Result := FGrid.DoMouseWheelUp(Shift, MousePos)
    else Result := inherited DoMouseWheelUp(Shift, MousePos);
end;

function TNxGridPicker.GetPopupControlClass: TNxPopupControlClass;
begin
  Result := TNxGridPopupControl;
end;

procedure TNxGridPicker.SetGrid(const Value: TNextGrid);
begin
  FGrid := Value;
end;

{ TNxGridPopupControl }

procedure TNxGridPopupControl.AcquireValue(X, Y: Integer);
begin

end;

procedure TNxGridPopupControl.SetGrid(const Value: TNextGrid);
begin
  if Value <> FGrid then
  begin
    FGrid := Value;

    if Assigned(FGrid) then
    begin
      FGrid.Parent := Self;
      FGrid.Align := alClient;
    end;
  end;
end;

end.
