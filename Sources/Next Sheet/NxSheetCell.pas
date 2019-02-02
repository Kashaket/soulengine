{
  NxSheet
  Copyright (C) 1996-2006 by Berg
  All rights reserved.

  $id:NxSheetCell.pas bn
}

unit NxSheetCell;

interface

uses
  Classes, Types, Graphics, NxClasses, NxSharedCommon;

const
  szColumnDefaultWidth = 64;
  szRowDefaultHeight = 20;

type
  TCellKind = (ckGeneral, ckNumber, ckDateTime);
  TCellState = set of (cstModified, cstCalculated, cstError, cstMerged, cstSelected);
  TBorderPosition = (bpsNone, bpsBottom, bpsLeft, bpsRight, bpsTop);
  TLineStyle = (lsNone, lsThinDot, lsDot, lsDashDotDot, lsDashDot, lsWideDot,
    lsThinLine, lsWeightDashDotDot, lsSkewDastDot, lsWeightDashDot, lsWeightDash,
    lsSolid, lsWeightSolid, lsDouble);
  TCellAlignment = (caTopLeft, caTopCenter, caTopRight, caCenterLeft, caCenter, caCenterRight,
    caBottomLeft, caBottomCenter, caBottomRight);

  TBorderChangeEvent = procedure (Sender: TObject; ACol, ARow: Integer; Position: TBorderPosition) of object;
  TCellChangeEvent = procedure (Sender: TObject; ACol, ARow: Integer) of object;
  TColumnRowChangeEvent = procedure (Sender: TObject; Index: Integer) of object;
  TSizeChangeEvent = procedure (Sender: TObject; OldSize, NewSize: Integer) of object;
  TValueChangeEvent = procedure (Sender: TObject; ACol, ARow: Integer;
    var Value: WideString) of object;

  TNxCell = class;
  TNxSheetCells = class;

  TFixedElement = class
	private
    FCaption: string;
    FCells: TNxSheetCells;
    FIndex: Integer;
  	FSelected: Boolean;
    FSize: Integer;
    FSizingSize: Integer;
    FOnChange: TNotifyEvent;
  	FOnSizeChange: TSizeChangeEvent;
    procedure SetSize(const Value: Integer);
    procedure SetCaption(const Value: string);
  protected
    procedure Resize(OldSize, NewSize: Integer); virtual;
	public
  	constructor Create(ACells: TNxSheetCells; AIndex: Integer); virtual;
    function IsLast: Boolean;
  	property Caption: string read FCaption write SetCaption;
    property Index: Integer read FIndex;
  	property Selected: Boolean read FSelected write FSelected;
    property Size: Integer read FSize write SetSize;
    property SizingSize: Integer read FSizingSize write FSizingSize;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnSizeChange: TSizeChangeEvent read FOnSizeChange write FOnSizeChange;
  end;

  TNxSheetColumn = class(TFixedElement)
  protected
    procedure Resize(OldSize, NewSize: Integer); override;
  public
  	constructor Create(ACells: TNxSheetCells; AIndex: Integer); override;
  end;

  TNxSheetRow = class(TFixedElement)
  protected
    procedure Resize(OldSize, NewSize: Integer); override;
  public
  	constructor Create(ACells: TNxSheetCells; AIndex: Integer); override;
  end;

  TNxCellBorder = class
  private
    FCell: TNxCell;
    FColor: TColor;
    FLineStyle: TLineStyle;
    FPosition: TBorderPosition;
    procedure SetColor(const Value: TColor);
    procedure SetLineStyle(const Value: TLineStyle);
  public
    constructor Create(ACell: TNxCell; APosition: TBorderPosition);
    procedure Assign(Source: TNxCellBorder); virtual;
    procedure SetBorder(AColor: TColor; ALineStyle: TLineStyle);
    property Color: TColor read FColor write SetColor;
    property LineStyle: TLineStyle read FLineStyle write SetLineStyle;
    property Position: TBorderPosition read FPosition;
  end;

//  TNxCellState = set of (ctParentFont);

  TNxCell = class
  private
    FAlignment: TCellAlignment;
    FAngle: TTextAngle;
    FBorderBottom: TNxCellBorder;
    FBorderLeft: TNxCellBorder;
    FBorderRight: TNxCellBorder;
    FBorderTop: TNxCellBorder;
    FColor: TColor;
    FColumn: TNxSheetColumn;
    FDataKind: TDataKind;
    FDockCell: TNxCell;
    FFont: TFont;
    FFormatMask: string;
    FKind: TCellKind;
    FNumber: Extended;
    FRow: TNxSheetRow;
    FSelected: Boolean;
    FState: TCellState;
    FText: WideString;
    FValue: WideString;
    FMultiLine: Boolean;
    function GetActive: Boolean;
    function GetCells: TNxSheetCells;
    function GetCol: Integer;
    function GetMerged: Boolean;
    function GetModified: Boolean;
    function GetRow: Integer;
    procedure SetAlignment(const Value: TCellAlignment);
    procedure SetAngle(const Value: TTextAngle);
    procedure SetBorderBottom(const Value: TNxCellBorder);
    procedure SetBorderLeft(const Value: TNxCellBorder);
    procedure SetBorderRight(const Value: TNxCellBorder);
    procedure SetBorderTop(const Value: TNxCellBorder);
    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetKind(const Value: TCellKind);
    procedure SetNumber(const Value: Extended);
    procedure SetSelected(const Value: Boolean);
    procedure SetText(const Value: WideString);
    function GetDisplayText: WideString;
    procedure SetFormatMask(const Value: string);
  protected
    procedure BorderChanged(Position: TBorderPosition); virtual;
    procedure Changed; virtual;
    procedure CreateBorders(ACol, ARow: Integer);
    procedure DoFontChange(Sender: TObject); dynamic;
    procedure ValueChanged(var Value: WideString); virtual;
  public
  	constructor Create(AColumn: TNxSheetColumn; ARow: TNxSheetRow);
    destructor Destroy; override;
    procedure ClearFormating;
    procedure GetBorder(Position: TBorderPosition; var LineStyle: TLineStyle; var BorderColor: TColor);
    procedure SetBorder(Position: TBorderPosition; LineStyle: TLineStyle; Color: TColor);
    procedure SetBorders(LineStyle: TLineStyle; Color: TColor);
    procedure Update;
    property Active: Boolean read GetActive;
    property Alignment: TCellAlignment read FAlignment write SetAlignment;
    property Angle: TTextAngle read FAngle write SetAngle default 0;
    property BorderBottom: TNxCellBorder read FBorderBottom write SetBorderBottom;
    property BorderLeft: TNxCellBorder read FBorderLeft write SetBorderLeft;
    property BorderRight: TNxCellBorder read FBorderRight write SetBorderRight;
    property BorderTop: TNxCellBorder read FBorderTop write SetBorderTop;
    property Cells: TNxSheetCells read GetCells;
    property Col: Integer read GetCol;
    property Color: TColor read FColor write SetColor;
    property DataKind: TDataKind read FDataKind;
    property DisplayText: WideString read GetDisplayText;
    property DockCell: TNxCell read FDockCell write FDockCell;
    property Font: TFont read FFont write SetFont;
    property FormatMask: string read FFormatMask write SetFormatMask;
  	property Kind: TCellKind read FKind write SetKind;
    property Merged: Boolean read GetMerged;
    property MultiLine: Boolean read FMultiLine write FMultiLine;
    property Modified: Boolean read GetModified;
    property Number: Extended read FNumber write SetNumber;
    property Row: Integer read GetRow;
    property Selected: Boolean read FSelected write SetSelected;
    property State: TCellState read FState;
    property Text: WideString read FText write SetText;
    property Value: WideString read FValue write FValue;
  end;

  TNxSheetCells = class
  private
    FCellsList: TList;
		FClientHeight: Integer;
  	FClientWidth: Integer;
    FColCount: Integer;
    FColumnsList: TList;
    FOnBorderChange: TBorderChangeEvent;
    FOnCellChange: TCellChangeEvent;
    FOnColumnChange: TColumnRowChangeEvent;
  	FOnColumnResize: TSizeChangeEvent;
    FOnRowChange: TColumnRowChangeEvent;
  	FOnRowResize: TSizeChangeEvent;
    FOnValueChange: TValueChangeEvent;
    FRowCount: Integer;
    FRowsList: TList;
    function GetCell(ACol, ARow: Integer): TNxCell;
    function GetColumn(Index: Integer): TNxSheetColumn;
    function GetRow(Index: Integer): TNxSheetRow;
    procedure SetCell(ACol, ARow: Integer; const Value: TNxCell);
    procedure SetColCount(const Value: Integer);
    procedure SetColumn(Index: Integer; const Value: TNxSheetColumn);
    procedure SetRow(Index: Integer; const Value: TNxSheetRow);
    procedure SetRowCount(const Value: Integer);
  protected
    procedure BorderChanged(ACol, ARow: Integer; Position: TBorderPosition);
    procedure Changed(ACol, ARow: Integer);
    function CreateCells: TList;
    procedure CreateColumnBorders(Index: Integer);
    procedure CreateRowBorders(Index: Integer);
    procedure DestroyColumnBorder(Index: Integer);
    procedure DestroyRowBorder(Index: Integer);
    procedure DoCellChange(ACol, ARow: Integer); dynamic;
		procedure DoColumnChange(Index: Integer); dynamic;
		procedure DoColumnResize(OldSize, NewSize: Integer); dynamic;
		procedure DoRowChange(Index: Integer); dynamic;
		procedure DoRowResize(OldSize, NewSize: Integer); dynamic;
    procedure DoValueChange(ACol, ARow: Integer; var Value: WideString);  dynamic;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddColumn(Count: Integer = 1);
    procedure AddFirstCell;
    procedure AddRow(Count: Integer = 1);
    procedure AddState(ACol, ARow: Integer; AState: TCellState);
    procedure Clear;
    procedure DeleteColumn(Index: Integer);
    procedure DeleteRow(Index: Integer);
    procedure FrameCell(ACol, ARow: Integer; LineStyle: TLineStyle; LineColor: TColor);
    procedure InsertColumn(Index: Integer);
    procedure InsertRow(Index: Integer);
    procedure RemoveState(ACol, ARow: Integer; AState: TCellState);
    property Cell[ACol, ARow: Integer]: TNxCell read GetCell write SetCell;
    property ClientHeight: Integer read FClientHeight;
    property ClientWidth: Integer read FClientWidth;
    property ColCount: Integer read FColCount write SetColCount;
    property Column[Index: Integer]: TNxSheetColumn read GetColumn write SetColumn;
    property OnBorderChange: TBorderChangeEvent read FOnBorderChange write FOnBorderChange;
    property OnCellChange: TCellChangeEvent read FOnCellChange write FOnCellChange;
    property OnColumnChange: TColumnRowChangeEvent read FOnColumnChange write FOnColumnChange;
    property OnColumnResize: TSizeChangeEvent read FOnColumnResize write FOnColumnResize;
    property OnRowChange: TColumnRowChangeEvent read FOnRowChange write FOnRowChange;
    property OnRowResize: TSizeChangeEvent read FOnRowResize write FOnRowResize;
    property OnValueChange: TValueChangeEvent read FOnValueChange write FOnValueChange;
    property Row[Index: Integer]: TNxSheetRow read GetRow write SetRow;
    property RowCount: Integer read FRowCount write SetRowCount;
  end;

  function GetAlignment(CellAlignment: TCellAlignment): TAlignment;
  function GetVerticalAlignment(CellAlignment: TCellAlignment): TVerticalAlignment;

implementation

uses SysUtils, Dialogs;

function GetAlignment(CellAlignment: TCellAlignment): TAlignment;
begin
  case CellAlignment of
    caTopLeft, caCenterLeft, caBottomLeft: Result := taLeftJustify;
    caTopCenter, caCenter, caBottomCenter: Result := taCenter;
    else Result := taRightJustify;
  end;
end;

function GetVerticalAlignment(CellAlignment: TCellAlignment): TVerticalAlignment;
begin
  case CellAlignment of
    caTopLeft, caTopCenter, caTopRight: Result := taAlignTop;
    caCenterLeft, caCenter, caCenterRight: Result := taVerticalCenter;
    else Result := taAlignBottom;
  end;
end;

{ TFixedElement }

constructor TFixedElement.Create;
begin
  FCaption := '';
  FCells := ACells;
  FIndex := AIndex;
  FSelected := False;
end;

function TFixedElement.IsLast: Boolean;
begin
  Result := Index = Pred(FCells.ColCount);
end;

procedure TFixedElement.SetCaption(const Value: string);
begin
  FCaption := Value;
//  FCells.do
end;

procedure TFixedElement.SetSize(const Value: Integer);
var
	FOldSize: Integer;
begin
  FOldSize := FSize;
  FSize := Value;
  FSizingSize := FSize;
  Resize(FSize, FOldSize);
end;

procedure TFixedElement.Resize(OldSize, NewSize: Integer);
begin

end;

{ TNxSheetColumn }

constructor TNxSheetColumn.Create;
begin
	inherited;
  FSize := szColumnDefaultWidth;
  FSizingSize := FSize;
end;

procedure TNxSheetColumn.Resize(OldSize, NewSize: Integer);
begin
  inherited;
  Inc(FCells.FClientWidth, OldSize - NewSize);
  FCells.DoColumnResize(OldSize, NewSize);
end;

{ TNxSheetRow }

constructor TNxSheetRow.Create;
begin
  inherited;
  FSize := szRowDefaultHeight;
  FSizingSize := FSize;
end;

procedure TNxSheetRow.Resize(OldSize, NewSize: Integer);
begin
  Inc(FCells.FClientHeight, OldSize - NewSize);
  FCells.DoRowResize(OldSize, NewSize);
end;

{ TNxCellBorder }

procedure TNxCellBorder.Assign(Source: TNxCellBorder);
begin
  if Source is TNxCellBorder then
  begin                       
    FColor := TNxCellBorder(Source).Color;
    FLineStyle := TNxCellBorder(Source).LineStyle;
  end;
end;

constructor TNxCellBorder.Create(ACell: TNxCell; APosition: TBorderPosition);
begin
  FCell := ACell;
  FColor := clNone;
  FLineStyle := lsNone;
  FPosition := APosition;
end;

procedure TNxCellBorder.SetBorder(AColor: TColor; ALineStyle: TLineStyle);
begin
  FColor := AColor;
  FLineStyle := ALineStyle;          
  if Assigned(FCell) then FCell.BorderChanged(FPosition);
end;

procedure TNxCellBorder.SetColor(const Value: TColor);
begin
  FColor := Value;
  if Assigned(FCell) then FCell.BorderChanged(FPosition);
end;

procedure TNxCellBorder.SetLineStyle(const Value: TLineStyle);
begin
  FLineStyle := Value;
  if Assigned(FCell) then FCell.BorderChanged(FPosition);
end;

{ TNxCell }

procedure TNxCell.BorderChanged;
begin
{ Because one border is shared between 2 cells, both cells
  need to be updated }
  Cells.BorderChanged(Col, Row, Position);
  case Position of
    bpsLeft:
    begin
      if Col > 0 then Cells.BorderChanged(Pred(Col), Row, bpsRight);
    end;
    bpsTop:
    begin
      if Row > 0 then Cells.BorderChanged(Col, Pred(Row), bpsBottom);
    end;
    bpsRight:
    begin
      if Col < Pred(Cells.ColCount) then Cells.BorderChanged(Succ(Col), Row, bpsLeft);
    end;
    bpsBottom:
    begin
      if Row < Pred(Cells.RowCount) then Cells.BorderChanged(Col, Succ(Row), bpsTop);
    end;
  end;
end;

procedure TNxCell.Changed;
begin
  FColumn.FCells.Changed(FColumn.FIndex, FRow.FIndex);
end;

procedure TNxCell.ClearFormating;
begin
  FState := [];
end;

constructor TNxCell.Create;
begin
  FAlignment := caCenterLeft;
  FAngle := 0;
  FColor := clNone;
  FColumn := AColumn;
  FFont := TFont.Create;
  FFont.OnChange := DoFontChange;
  FFormatMask := '';
  FMultiLine := False;
  FRow := ARow;
  FText := '';
  CreateBorders(AColumn.Index, ARow.Index);
end;

procedure TNxCell.CreateBorders(ACol, ARow: Integer);
begin
  FBorderBottom := TNxCellBorder.Create(Self, bpsBottom);
  FBorderRight := TNxCellBorder.Create(Self, bpsRight);

  if ACol = 0 then
  begin
    FBorderLeft := TNxCellBorder.Create(Self, bpsLeft);
  end else
  begin
    FBorderLeft := FColumn.FCells.Cell[ACol - 1, ARow].BorderRight;
  end;

  if ARow = 0 then
  begin
    FBorderTop := TNxCellBorder.Create(Self, bpsTop);
  end else
  begin
    FBorderTop := FRow.FCells.Cell[ACol, ARow - 1].BorderBottom;
  end;
end;

destructor TNxCell.Destroy;
begin
  inherited;
  FreeAndNil(FFont);
end;

procedure TNxCell.DoFontChange(Sender: TObject);
begin
//  Include(FState, ctParentFont);
end;

function TNxCell.GetActive: Boolean;
begin
  Result := (not Assigned(FDockCell)) or (FDockCell = Self);
end;

procedure TNxCell.GetBorder(Position: TBorderPosition;
  var LineStyle: TLineStyle; var BorderColor: TColor);
var
  ABorder: TNxCellBorder;
begin
  ABorder := nil;
  LineStyle := lsNone;
  BorderColor := clNone;
  case Position of
    bpsBottom: ABorder := BorderBottom;
    bpsLeft: ABorder := BorderLeft;
    bpsRight: ABorder := BorderRight;
    bpsTop: ABorder := BorderTop;
  end;
  if Assigned(ABorder) then
  begin
    LineStyle := ABorder.FLineStyle;
    BorderColor := ABorder.FColor;
  end;
end;

function TNxCell.GetCells: TNxSheetCells;
begin
  Result := FColumn.FCells;
end;

function TNxCell.GetCol: Integer;
begin
  Result := FColumn.FIndex;
end;

function TNxCell.GetDisplayText: WideString;
begin
  if FValue = '' then Exit;
  Result := FValue;
  if FFormatMask <> '' then
    case FKind of
      ckNumber: Result := FormatFloat(FFormatMask, StrToFloat(FValue));
      ckDateTime: Result := FormatDateTime(FFormatMask, StrToDateTime(FValue));
    end;
end;

function TNxCell.GetMerged: Boolean;
begin
	Result := Assigned(FDockCell);
end;

function TNxCell.GetModified: Boolean;
begin
  Result := cstModified in FState;
end;

function TNxCell.GetRow: Integer;
begin
  Result := FRow.FIndex;
end;

procedure TNxCell.SetAlignment(const Value: TCellAlignment);
begin
  FAlignment := Value;
  Changed;
end;

procedure TNxCell.SetAngle(const Value: TTextAngle);
begin
  FAngle := Value;
  Changed;
end;

procedure TNxCell.SetBorder(Position: TBorderPosition;
  LineStyle: TLineStyle; Color: TColor);
begin
  case Position of
    bpsBottom: BorderBottom.SetBorder(Color, LineStyle);
    bpsLeft: BorderLeft.SetBorder(Color, LineStyle);
    bpsRight: BorderRight.SetBorder(Color, LineStyle);
    bpsTop: BorderTop.SetBorder(Color, LineStyle);
  end;
end;

procedure TNxCell.SetBorderBottom(const Value: TNxCellBorder);
begin
  FBorderBottom := Value;
end;

procedure TNxCell.SetBorderLeft(const Value: TNxCellBorder);
begin
  FBorderLeft := Value;
end;

procedure TNxCell.SetBorderRight(const Value: TNxCellBorder);
begin
  FBorderRight := Value;
end;

procedure TNxCell.SetBorders(LineStyle: TLineStyle; Color: TColor);
begin
  BorderLeft.Color := Color;
  BorderTop.Color := Color;
  BorderBottom.Color := Color;
  BorderRight.Color := Color;
  BorderLeft.LineStyle := LineStyle;
  BorderTop.LineStyle := LineStyle;
  BorderBottom.LineStyle := LineStyle;
  BorderRight.LineStyle := LineStyle;
  inherited;
end;

procedure TNxCell.SetBorderTop(const Value: TNxCellBorder);
begin
  FBorderTop := Value;
end;

procedure TNxCell.SetColor(const Value: TColor);
begin
  FColor := Value;
  Changed;
end;

procedure TNxCell.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Changed;
end;

procedure TNxCell.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
end;

procedure TNxCell.SetKind(const Value: TCellKind);
begin
  FKind := Value;
  Changed;
end;

procedure TNxCell.SetNumber(const Value: Extended);
begin
  FNumber := Value;
  FKind := ckNumber;
  Changed;
end;

procedure TNxCell.SetSelected(const Value: Boolean);
begin
	if Value <> FSelected then
  begin
	  FSelected := Value;
    Changed;
  end;
end;

procedure TNxCell.SetText(const Value: WideString);
begin
  if FText <> Value then
  begin
    FText := Value;
    FValue := FText;
    FDataKind := GetDataKind(FText);
    ValueChanged(FValue);
    Include(FState, cstModified);
  end;
end;

procedure TNxCell.Update;
begin
  FValue := FText;
  ValueChanged(FValue);
end;

procedure TNxCell.ValueChanged(var Value: WideString);
begin
  Cells.DoValueChange(Col, Row, Value);
end;

{ TNxSheetCells }

procedure TNxSheetCells.AddColumn(Count: Integer);
var
	i, j: Integer;
  ACell: TNxCell;
  ACellsList: TList;
  AColumn: TNxSheetColumn;
begin
  if Count = 0 then Exit;
  for j := 0 to Count - 1 do
  begin
    AColumn := TNxSheetColumn.Create(Self, FColCount);
    FColumnsList.Add(AColumn);

    ACellsList := TList.Create;
    FCellsList.Add(ACellsList);
		for i := 0 to FRowCount - 1 do
    begin
      ACell := TNxCell.Create(AColumn, Row[i]);
    	ACellsList.Add(ACell);
    end;
		Inc(FColCount);
    Inc(FClientWidth, AColumn.Size);
  end;
end;

procedure TNxSheetCells.AddFirstCell;
var
	ACell: TNxCell;
  AColumn: TNxSheetColumn;
  ARow: TNxSheetRow;
begin
  AColumn := TNxSheetColumn.Create(Self, 0);
  ARow := TNxSheetRow.Create(Self, 0);

  ACell := TNxCell.Create(AColumn, ARow);
  CreateCells.Add(ACell);

  FColumnsList.Add(AColumn);
  FRowsList.Add(ARow);

  Inc(FClientWidth, AColumn.Size);
  Inc(FClientHeight, ARow.Size);

  FRowCount := 1;
  FColCount := 1;
end;

procedure TNxSheetCells.AddRow(Count: Integer);
var
  i, j: Integer;
	ACell: TNxCell;
  ARow: TNxSheetRow;
begin
  for j := 0 to Count - 1 do
  begin
    ARow := TNxSheetRow.Create(Self, FRowCount);
		for i := 0 to FColCount - 1 do
	  begin
      ACell := TNxCell.Create(Column[i], ARow);
    	TList(FCellsList.Items[i]).Add(ACell);
	  end;
    FRowsList.Add(ARow);
    Inc(FClientHeight, ARow.Size);
	  Inc(FRowCount);
  end;
end;

procedure TNxSheetCells.AddState(ACol, ARow: Integer;
  AState: TCellState);
begin
  Cell[ACol, ARow].FState := Cell[ACol, ARow].FState + AState;
end;

procedure TNxSheetCells.BorderChanged;
begin
  if Assigned(FOnBorderChange) then FOnBorderChange(Self, ACol, ARow, Position);
end;

procedure TNxSheetCells.Changed;
begin
  DoCellChange(ACol, ARow);
end;

procedure TNxSheetCells.Clear;
var
  i: Integer;
begin
  for i := 0 to Pred(FColCount) do DeleteColumn(0);
  AddFirstCell;
end;

constructor TNxSheetCells.Create;
begin
  FCellsList := TList.Create;
  FColumnsList := TList.Create;
  FRowsList := TList.Create;
end;

function TNxSheetCells.CreateCells: TList;
begin
  Result := TList.Create;
  FCellsList.Add(Result);
end;

procedure TNxSheetCells.CreateColumnBorders(Index: Integer);
var
  i: Integer;
begin
  if RowCount = 0 then Exit;
  Cell[Index, 0].BorderTop := TNxCellBorder.Create(Cell[Index, 0], bpsTop);

  for i := 0 to Pred(RowCount) do
  begin
    if Index = 0 then { first column }
    begin
      Cell[Index, i].BorderLeft := TNxCellBorder.Create(Cell[Index, i], bpsLeft);
      if ColCount = 1 then
      begin
        Cell[Index, i].BorderRight := TNxCellBorder.Create(Cell[Index, i], bpsRight);
      end else
      begin
        Cell[Index, i].BorderRight := Cell[Index + 1, i].BorderLeft;
      end;
    end else if Index = Pred(ColCount) then { last column }
    begin
      Cell[Index, i].BorderRight := TNxCellBorder.Create(Cell[Index, i], bpsRight);
      Cell[Index, i].BorderLeft := Cell[Index - 1, i].BorderRight;
    end else
    begin
      Cell[Index, i].BorderRight := TNxCellBorder.Create(Cell[Index, i], bpsRight);
      Cell[Index + 1, i].BorderLeft := Cell[Index, i].BorderRight;
      Cell[Index, i].BorderLeft := Cell[Index - 1, i].BorderRight;
    end;
    Cell[Index, i].BorderBottom := TNxCellBorder.Create(Cell[Index, i], bpsBottom);
  end;
end;

procedure TNxSheetCells.CreateRowBorders(Index: Integer);
var
  i: Integer;
begin
  if ColCount = 0 then Exit;
  Cell[0, Index].BorderLeft := TNxCellBorder.Create(Cell[0, Index], bpsLeft);

  for i := 0 to Pred(ColCount) do
  begin
    if Index = 0 then { first row }
    begin
      Cell[i, Index].BorderTop := TNxCellBorder.Create(Cell[i, Index], bpsTop);
      if RowCount = 1 then
      begin
        Cell[i, Index].BorderBottom := TNxCellBorder.Create(Cell[i, Index], bpsBottom);
      end else
      begin
        Cell[i, Index].BorderBottom := Cell[i, Index + 1].BorderTop;
      end;
    end else if Index = Pred(RowCount) then { last row }
    begin
      Cell[i, Index].BorderBottom := TNxCellBorder.Create(Cell[i, Index], bpsBottom);
      Cell[i, Index].BorderTop := Cell[i, Index - 1].BorderBottom;
    end else
    begin
      Cell[i, Index].BorderBottom := TNxCellBorder.Create(Cell[i, Index], bpsBottom);
      Cell[i, Index + 1].BorderTop := Cell[i, Index].BorderBottom;
      Cell[i, Index].BorderTop := Cell[i, Index - 1].BorderBottom;
    end;
    Cell[i, Index].BorderRight := TNxCellBorder.Create(Cell[i, Index], bpsRight);
  end;
end;

procedure TNxSheetCells.DeleteColumn(Index: Integer);
var
	i: Integer;
  AList: TList;
begin
  DestroyColumnBorder(Index);

  { Delete column's cells array }
  AList := TList(FCellsList[Index]);
  for i := 0 to Pred(AList.Count) do
  begin
    TNxCell(AList[i]).Free; { destroy cell }
  end;
  FreeAndNil(AList);

  { Delete TList from TList array }
  FCellsList.Delete(Index);

  Dec(FClientWidth, Column[Index].Size);
  for i := Index to Pred(FColumnsList.Count) do Dec(Column[i].FIndex);

  Column[Index].Free;
  FColumnsList.Delete(Index);

  Dec(FColCount);
end;

procedure TNxSheetCells.DeleteRow(Index: Integer);
var
	i: Integer;
  AList: TList;
begin
  DestroyRowBorder(Index);

  for i := 0 to Pred(ColCount) do
  begin
    AList := TList(FCellsList[i]);
    TNxCell(AList[Index]).Free;
    AList.Delete(Index);
  end;

  Dec(FClientHeight, Row[Index].Size);
  for i := Index to Pred(FRowsList.Count) do Dec(Row[i].FIndex);

  Row[Index].Free;
  FRowsList.Delete(Index);

  Dec(FRowCount);
end;

destructor TNxSheetCells.Destroy;
var
  i: Integer;
begin
  for i := 0 to Pred(FColCount)
    do DeleteColumn(0);

  FreeAndNil(FCellsList);

  for i := 0 to Pred(FColumnsList.Count) do TNxSheetColumn(FColumnsList[i]).Free;
  FreeAndNil(FColumnsList);

  for i := 0 to Pred(FRowsList.Count) do TNxSheetRow(FRowsList[i]).Free;
  FreeAndNil(FRowsList);
  inherited;
end;

procedure TNxSheetCells.DestroyColumnBorder(Index: Integer);
var
  i: Integer;
begin
  if RowCount = 0 then Exit;
  Cell[Index, 0].BorderTop.Free;
  Cell[Index, 0].BorderTop := nil;

  for i := 0 to Pred(RowCount) do
  begin
    if Index = 0 then { first column }
    begin
      Cell[Index, i].BorderLeft.Free;
      Cell[Index, i].BorderLeft := nil;
      if ColCount = 1 then
      begin
        Cell[Index, i].BorderRight.Free;
        Cell[Index, i].BorderRight := nil;
      end;
    end else if Index = Pred(ColCount) then { last column }
    begin
      Cell[Index, i].BorderRight.Free;
      Cell[Index, i].BorderRight := nil;
    end else
    begin
      Cell[Index, i].BorderLeft.Free;
      Cell[Index, i].BorderLeft := nil;
      Cell[Index - 1, i].BorderRight := Cell[Index + 1, i].BorderLeft;
    end;
    Cell[Index, i].BorderBottom.Free;
    Cell[Index, i].BorderBottom := nil;
  end;
end;

procedure TNxSheetCells.DestroyRowBorder(Index: Integer);
var
  i: Integer;
begin
  if ColCount = 0 then Exit;
  Cell[0, Index].BorderLeft.Free;
  Cell[0, Index].BorderLeft := nil;

  for i := 0 to Pred(ColCount) do
  begin
    if Index = 0 then
    begin
      Cell[i, Index].BorderTop.Free;
      Cell[i, Index].BorderTop := nil;
      if RowCount = 1 then
      begin
        Cell[i, Index].BorderBottom.Free;
        Cell[i, Index].BorderBottom := nil;
      end;
    end else if Index = Pred(RowCount) then
    begin
      Cell[i, Index].BorderBottom.Free;
      Cell[i, Index].BorderBottom := nil;
    end else
    begin
      Cell[i, Index].BorderTop.Free;
      Cell[i, Index].BorderTop := nil;
      Cell[i, Index - 1].BorderBottom := Cell[i, Index + 1].BorderTop;
    end;
    Cell[i, Index].BorderRight.Free;
    Cell[i, Index].BorderRight := nil;
  end;
end;

procedure TNxSheetCells.DoCellChange(ACol, ARow: Integer);
begin
  if Assigned(FOnCellChange) then FOnCellChange(Self, ACol, ARow);
end;

procedure TNxSheetCells.DoColumnChange(Index: Integer);
begin
  if Assigned(FOnColumnChange) then FOnColumnChange(Self, Index);
end;

procedure TNxSheetCells.DoColumnResize(OldSize, NewSize: Integer);
begin
  if Assigned(FOnColumnResize) then FOnColumnResize(Self, OldSize, NewSize);
end;

procedure TNxSheetCells.DoRowChange(Index: Integer);
begin
  if Assigned(FOnRowChange) then FOnRowChange(Self, Index);
end;

procedure TNxSheetCells.DoRowResize(OldSize, NewSize: Integer);
begin
  if Assigned(FOnRowResize) then FOnRowResize(Self, OldSize, NewSize);
end;

procedure TNxSheetCells.DoValueChange(ACol, ARow: Integer; var Value: WideString);
begin
  if Assigned(FOnValueChange) then FOnValueChange(Self, ACol, ARow, Value);
end;

procedure TNxSheetCells.FrameCell(ACol, ARow: Integer;
  LineStyle: TLineStyle; LineColor: TColor);
begin
  with Cell[ACol, ARow] do
  begin
    BorderLeft.FColor := LineColor;
    BorderTop.FColor := LineColor;
    BorderRight.FColor := LineColor;
    BorderBottom.FColor := LineColor;

    BorderLeft.FLineStyle := LineStyle;
    BorderTop.FLineStyle := LineStyle;
    BorderRight.FLineStyle := LineStyle;
    BorderBottom.FLineStyle := LineStyle;

  end;
  BorderChanged(ACol, ARow, bpsLeft);
  BorderChanged(ACol, ARow, bpsTop);
  BorderChanged(ACol, ARow, bpsRight);
  BorderChanged(ACol, ARow, bpsBottom);
end;

function TNxSheetCells.GetCell(ACol, ARow: Integer): TNxCell;
begin
  Result := TNxCell(TList(FCellsList.Items[ACol]).Items[ARow]);
end;

function TNxSheetCells.GetColumn(Index: Integer): TNxSheetColumn;
begin
  Result := TNxSheetColumn(FColumnsList[Index]);
end;

function TNxSheetCells.GetRow(Index: Integer): TNxSheetRow;
begin
  Result := TNxSheetRow(FRowsList[Index]);
end;

procedure TNxSheetCells.InsertColumn(Index: Integer);
var
  i: Integer;
  ACell: TNxCell;
  ACellsList: TList;
  AColumn: TNxSheetColumn;
begin
  for i := Index to Pred(FColumnsList.Count) do Inc(Column[i].FIndex);

  AColumn := TNxSheetColumn.Create(Self, Index);
  FColumnsList.Insert(Index, AColumn);

  ACellsList := TList.Create;
  FCellsList.Insert(Index, ACellsList);
	for i := 0 to FRowCount - 1 do
  begin
    ACell := TNxCell.Create(AColumn, Row[i]);
  	ACellsList.Add(ACell);
  end;
  Inc(FColCount);
  Inc(FClientWidth, AColumn.Size);

  CreateColumnBorders(Index); { Create Borders }
end;

procedure TNxSheetCells.InsertRow(Index: Integer);
var
  i: Integer;
  ACell: TNxCell;
  ACellsList: TList;
  ARow: TNxSheetRow;
begin
  for i := Index to Pred(FRowsList.Count) do Inc(Row[i].FIndex);

  ARow := TNxSheetRow.Create(Self, Index);
  FRowsList.Insert(Index, ARow);

	for i := 0 to FColCount - 1 do
  begin
    ACellsList := FCellsList[i];
    ACell := TNxCell.Create(Column[i], ARow);
  	ACellsList.Insert(Index, ACell);
  end;
  Inc(FRowCount);
  Inc(FClientHeight, ARow.Size);

  CreateRowBorders(Index);
end;

procedure TNxSheetCells.RemoveState(ACol, ARow: Integer;
  AState: TCellState);
begin
  Cell[ACol, ARow].FState := Cell[ACol, ARow].FState - AState;
end;

procedure TNxSheetCells.SetCell(ACol, ARow: Integer; const Value: TNxCell);
begin

end;

procedure TNxSheetCells.SetColCount(const Value: Integer);
var
  i: Integer;
begin
	if (Value = FColCount) or (Value < 1) then Exit;
	if Value > FColCount then AddColumn(Value - FColCount)
    else for i := 1 to FColCount - Value do DeleteColumn(Pred(FColCount));
end;

procedure TNxSheetCells.SetColumn(Index: Integer;
  const Value: TNxSheetColumn);
begin

end;

procedure TNxSheetCells.SetRow(Index: Integer; const Value: TNxSheetRow);
begin

end;

procedure TNxSheetCells.SetRowCount(const Value: Integer);
var
	i: Integer;
begin
	if (Value = FRowCount) or (Value < 0) then Exit;
	if Value > FRowCount then AddRow(Value - FRowCount)
    else for i := 1 to FRowCount - Value do DeleteRow(Pred(FRowCount));
end;

end.
