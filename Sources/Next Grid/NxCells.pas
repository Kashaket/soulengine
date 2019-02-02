{
  Next Grid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:NxCustomGrid.pas 12/25/2002 7:10:16 bn
}

{$I '..\NxSuite.inc'}
unit NxCells;

interface

uses
	Classes, Controls, Graphics, SysUtils, DateUtils,
  Dialogs, Windows, NxColumns
  {$IFDEF UITYPES}, UITypes{$ENDIF}
  ;

type
  TIPNumber = array[0..3] of Integer;
  TDisplayState = set of (dsBoldTextSelection, dsFocused, dsSelected, dsHighlightedTextSelection);

  TCells = class;
  TCell = class;

  TCompareFunc = function(Cell1, Cell2: TCell): Boolean of object;

  TCellChangeEvent = procedure(Sender: TObject; ACol, ARow: Integer) of object;
  TCompareEvent = procedure(Sender: TObject; Cell1, Cell2: TCell; var Compare: Integer) of object;
  TRowCompareEvent = procedure(Sender: TObject; Row1, Row2: TCell; var Compare: Integer) of object;

  TNxCellState = set of (cstEmpty, cstLocked);

  TCell = class
  private
  	FCells: TCells;
    FObjectReference: TObject;
    FFontStyle: TFontStyles;
    FColor: TColor;
    FHint: WideString;
    FTextColor: TColor;
    function GetColumnIndex: Integer;
    function GetHighlighted: Boolean;
    function GetRowIndex: Integer;
    procedure SetColor(const Value: TColor);
    procedure SetHint(const Value: WideString);
    procedure SetFontStyle(const Value: TFontStyles);
    function GetLocked: Boolean;
    procedure SetLocked(const Value: Boolean);
    function GetEmpty: Boolean;
    procedure SetEmpty(const Value: Boolean);
    procedure SetTextColor(const Value: TColor);
    function GetDisplayText: WideString;
	protected
    FState: TNxCellState;
    function GetActualColor: TColor; virtual;
    function GetActualFontColor: TColor; virtual;
    function GetAsBoolean: Boolean; virtual; abstract;
    function GetAsDateTime: TDateTime; virtual; abstract;
    function GetAsFloat: Double; virtual; abstract;
    function GetAsInteger: Integer; virtual; abstract;
    function GetAsString: WideString; virtual; abstract;
    procedure Changed; virtual;
    procedure SetAsBoolean(const Value: Boolean); virtual;
    procedure SetAsDateTime(const Value: TDateTime); virtual;
    procedure SetAsFloat(const Value: Double); virtual;
    procedure SetAsInteger(const Value: Integer); virtual;
    procedure SetAsString(const Value: WideString); virtual;
  public
  	constructor Create(Cells: TCells); virtual;
    procedure Clear; virtual;
    property ActualColor: TColor read GetActualColor;
    property ActualFontColor: TColor read GetActualFontColor;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
		property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsString: WideString read GetAsString write SetAsString;
    property FontStyle: TFontStyles read FFontStyle write SetFontStyle;
    property Color: TColor read FColor write SetColor;
    property ColumnIndex: Integer read GetColumnIndex;
    property DisplayText: WideString read GetDisplayText;
    property Empty: Boolean read GetEmpty write SetEmpty;
    property RowIndex: Integer read GetRowIndex;
    property Highlighted: Boolean read GetHighlighted;
    property Hint: WideString read FHint write SetHint;
    property Locked: Boolean read GetLocked write SetLocked;
    property ObjectReference: TObject read FObjectReference write FObjectReference;
    property TextColor: TColor read FTextColor write SetTextColor;
  end;

  TRow = class
  private
    FChildCount: Integer;
    FData: Pointer;
    FExpanded: Boolean;
    FImageIndex: Integer;
    FLevel: Integer;
    FParentRow: TRow;
    FRowHeight: Integer;
    FSelected: Boolean;
    FShown: Boolean;
    FVisible: Boolean;
    function GetHasChildren: Boolean;
  public
    constructor Create;
    procedure AddChild;
    procedure Clear;
    procedure DeleteChild;
    property ChildCount: Integer read FChildCount;
    property Data: Pointer read FData write FData;
    property Expanded: Boolean read FExpanded write FExpanded;
    property HasChildren: Boolean read GetHasChildren;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property Level: Integer read FLevel write FLevel;
    property ParentRow: TRow read FParentRow write FParentRow;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property Selected: Boolean read FSelected write FSelected;
    property Shown: Boolean read FShown;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TCells = class
  private
    FCellsList: array[0..sizMaxColumns] of TList;
		FColCount: Integer;
		FColIndex: Integer;
    FColumns: TNxColumns;
    FGrid: TCustomControl;
    FOnCellChange: TCellChangeEvent;
    FOnCompare: TCompareEvent;
		FRowCount: Integer;
    FRowHeight: Integer;
		FRowIndex: Integer;
    FRowsList: TList;
    FSorted: Boolean;
    FSortIndex: Integer;
		FSortKind: TSortKind;
    FVisibleRowCount: Integer;
    function CreateCell(AColumn: TNxCustomColumn): TCell;
    function GetCell(ACol, ARow: Integer): TCell;
    function GetRow(Index: Integer): TRow;
  protected
    function AlphabeticLessCompare(Cell1, Cell2: TCell): Boolean;
    function AlphabeticGreaterCompare(Cell1, Cell2: TCell): Boolean;
    function AlphabeticUnicodeLessCompare(Cell1, Cell2: TCell): Boolean;
    function AlphabeticUnicodeGreaterCompare(Cell1, Cell2: TCell): Boolean;
    function BooleanLessCompare(Cell1, Cell2: TCell): Boolean;
    function BooleanGreaterCompare(Cell1, Cell2: TCell): Boolean;
    function CaseInsensitiveLessCompare(Cell1, Cell2: TCell): Boolean;
    function CaseInsensitiveGreaterCompare(Cell1, Cell2: TCell): Boolean;
    function CustomLessCompare(Cell1, Cell2: TCell): Boolean;
    function CustomGreaterCompare(Cell1, Cell2: TCell): Boolean;
    function NumericLessCompare(Cell1, Cell2: TCell): Boolean;
    function NumericGreaterCompare(Cell1, Cell2: TCell): Boolean;
    function DateLessCompare(Cell1, Cell2: TCell): Boolean;
    function DateGreaterCompare(Cell1, Cell2: TCell): Boolean;
    function IPLessCompare(Cell1, Cell2: TCell): Boolean;
    function IPGreaterCompare(Cell1, Cell2: TCell): Boolean;
    procedure Changed; dynamic;
    procedure DoCellCompare(Cell1, Cell2: TCell; var Compare: Integer); dynamic;
  public
  	constructor Create(Grid: TCustomControl; Columns: TNxColumns);
    procedure ColumnsChange(ChangeOpearation: TColumnsOperation;
	    Value1: Integer = -1; Value2: Integer = -1);
    destructor Destroy; override;
    function GetAbsoluteIndex(ParentRow, Index: Integer): Integer;
    function GetCellColumnIndex(ACell: TCell): Integer;
    function GetCellRowIndex(ACell: TCell): Integer;
    function GetChildCount(Index: Integer): Integer;
    function GetChildsCount(Index: Integer): Integer;
    function GetRowIndex(ARow: TRow): Integer;
    procedure AddChildRow(const Index, Position: Integer);
		procedure AddColumn;
    procedure AddRow(Count: Integer = 1);
    procedure ClearColumns;
    procedure ClearRows;
    procedure DeleteColumn(const Index: Integer);
    procedure DeleteRow(const Index: Integer);
    procedure ExpandRow(Index: Integer; const Value: Boolean);
    procedure InsertColumn(Pos: Integer);
		procedure InsertRow(Pos: Integer; Count: Integer);
    procedure MoveChildRow(Index: Integer; Parent: TRow);
    procedure MoveColumn(CurIndex, NewIndex: Integer);
		procedure MoveRow(FromPos, ToPos: Integer);
    procedure ShowRow(Index: Integer; const Value: Boolean);
    procedure SortColumn(ACol: Integer; ASortType: TSortType; ASortKind: TSortKind;
      Resort: Boolean);
    procedure SwapRows(FromPos, ToPos: Integer);
    property Cell[ACol, ARow: Integer]: TCell read GetCell; default;
    property Row[Index: Integer]: TRow read GetRow;
    property RowCount: Integer read FRowCount;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property SortIndex: Integer read FSortIndex;
    property SortKind: TSortKind read FSortKind;
    property Sorted: Boolean read FSorted;
    property VisibleRowCount: Integer read FVisibleRowCount;

    property OnCellChange: TCellChangeEvent read FOnCellChange write FOnCellChange;
    property OnCompare: TCompareEvent read FOnCompare write FOnCompare;
  end;

implementation

uses
	NxCellClasses, NxVirtualColumn, NxSharedCommon, NxGrid;

{ TCompareFunc }

function StrToIP(IP: string): TIPNumber;
var
	i, j: Integer;
  buff: string;
begin
  j := 0;
  buff := '';
  Result[0] := 0;
  Result[1] := 0;
  Result[2] := 0;
  Result[3] := 0;
  for i := 1 to Length(IP) do
  begin
    if IP[i] in ['0'..'9'] then buff := buff + IP[i];
    if (IP[i] = '.') or (i = Length(IP)) then
		begin
	    Result[j] := StrToInt(buff);
      Inc(j);
      buff := '';
    end;
  end;
end;

function IsIPSmaler(IP1, IP2: string): Boolean;
var
	i, a, b: Integer;
  num1, num2: TIPNumber;
begin
  Result := True;
  num1 := StrToIP(IP1);
  num2 := StrToIP(IP2);

  for i := 3 downto 0 do
  begin
  	a := num1[i];
  	b := num2[i];
    if a > b then
    begin
      Result := True;  // IP1 > IP2
      Exit;
    end else
    if a < b then
    begin
      Result := False; // IP1 < IP2
      Exit;
    end;
  end;
end;

{ TRow }

constructor TRow.Create;
begin
  FChildCount := 0;
  FExpanded := True;
  FImageIndex := -1;
  FLevel := 0;
  FSelected := False;
  FVisible := True;
  FShown := True;
end;

procedure TRow.AddChild;
begin
  Inc(FChildCount);
end;

procedure TRow.Clear;
begin
  FChildCount := 0;
end;

procedure TRow.DeleteChild;
begin
  Dec(FChildCount);
end;

function TRow.GetHasChildren: Boolean;
begin
  Result := ChildCount > 0;
end;

{ TCells }

constructor TCells.Create(Grid: TCustomControl; Columns: TNxColumns);
begin
  FGrid := Grid;
  FColCount := 0;
  FColumns := Columns;
  FRowCount := 0;
  FRowsList := TList.Create;
  FVisibleRowCount := 0;
end;

function TCells.CreateCell(AColumn: TNxCustomColumn): TCell;
begin
 	case AColumn.ColumnType of
    ctBoolean: Result := TBooleanCell.Create(Self);
    ctDate: Result := TDateTimeCell.Create(Self);
    ctFloat: Result := TFloatCell.Create(Self);
    ctInteger: Result := TIntegerCell.Create(Self);
    ctAutoInc: Result := TIncrementCell.Create(Self);
    ctVirtual:
    begin
      {$WARNINGS OFF}
      Result := TVirtualCell.Create(Self);
      TVirtualCell(Result).Column := TNxVirtualColumn(AColumn);
      {$WARNINGS ON}
    end;
    else Result := TStringCell.Create(Self);
  end;
  Result.FFontStyle := AColumn.Font.Style;
  Result.FColor := AColumn.Color;
  Result.Locked := False;
end;

destructor TCells.Destroy;
begin
  ClearRows;
  ClearColumns;
  FreeAndNil(FRowsList);
  inherited;
end;

function TCells.GetCell(ACol, ARow: Integer): TCell;
begin
  FColIndex := ACol;
  FRowIndex := ARow;
  Result := TCell(FCellsList[ACol].Items[ARow]);
end;

function TCells.GetRow(Index: Integer): TRow;
begin
  Result := TRow(FRowsList[Index]);
end;

function TCells.GetAbsoluteIndex(ParentRow, Index: Integer): Integer;
var
  i: Integer;
begin
  Result := ParentRow;
  i := 0;
  while i < FRowCount do
  begin
    if Row[i].Level = Row[Index].Level then Inc(Result);
    Inc(i);
  end;
end;

function TCells.GetCellColumnIndex(ACell: TCell): Integer;
var
  i, Row: Integer;
begin
  Result := -1;
  for i := 0 to Pred(FColCount) do
  begin
    Row := FCellsList[i].IndexOf(ACell);
    if Row <> -1 then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TCells.GetCellRowIndex(ACell: TCell): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Pred(FColCount) do
  begin
    Result := FCellsList[i].IndexOf(ACell);
    if Result <> -1 then Exit;
  end;
end;

function TCells.GetChildCount(Index: Integer): Integer;
var
  i: Integer;
  Level: Integer;
begin
  Result := 0;
  Level := Row[Index].Level;
  i := Index + 1;
  while (i < FRowCount) and (Level < Row[i].Level) do
  begin
    Inc(Result);
    Inc(i);
  end;
end;

function TCells.GetChildsCount(Index: Integer): Integer;
var
  i: Integer;
  Level: Integer;
begin
  Result := 0;
  Level := Row[Index].Level;
  i := Index + 1;
  while (i < FRowCount) and (Level < Row[i].Level) do
  begin
    if Row[i].Level = Level + 1 then Inc(Result);
    Inc(i);
  end;
end;

function TCells.GetRowIndex(ARow: TRow): Integer;
begin
  Result := FRowsList.IndexOf(ARow);
end;

function TCells.AlphabeticGreaterCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := Cell1.AsString >= Cell2.AsString;
end;

function TCells.AlphabeticLessCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := Cell1.AsString <= Cell2.AsString;
end;

function TCells.AlphabeticUnicodeGreaterCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := WideCompareStr(Cell1.AsString, Cell2.AsString) > 0;
end;

function TCells.AlphabeticUnicodeLessCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := WideCompareStr(Cell1.AsString, Cell2.AsString) < 0;
end;

function TCells.BooleanGreaterCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := Cell1.AsBoolean >= Cell2.AsBoolean;
end;

function TCells.BooleanLessCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := Cell1.AsBoolean <= Cell2.AsBoolean;
end;

function TCells.CaseInsensitiveGreaterCompare(Cell1,
  Cell2: TCell): Boolean;
begin
  Result := LowerCase(Cell1.AsString) >= LowerCase(Cell2.AsString);
end;

function TCells.CaseInsensitiveLessCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := LowerCase(Cell1.AsString) <= LowerCase(Cell2.AsString);
end;

function TCells.CustomGreaterCompare(Cell1, Cell2: TCell): Boolean;
var
  Compare: Integer;
begin
  Compare := 0;
  DoCellCompare(Cell1, Cell2, Compare);
  Result := Compare >= 0;
end;

function TCells.CustomLessCompare(Cell1, Cell2: TCell): Boolean;
var
  Compare: Integer;
begin
  Compare := 0;
  DoCellCompare(Cell1, Cell2, Compare);
  Result := Compare <= 0;
end;

function TCells.DateGreaterCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := Cell1.AsDateTime >= Cell2.AsDateTime;
end;

function TCells.DateLessCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := Cell1.AsDateTime <= Cell2.AsDateTime;
end;

function TCells.IPGreaterCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := IsIPSmaler(Cell2.AsString, Cell1.AsString);
end;

function TCells.IPLessCompare(Cell1, Cell2: TCell): Boolean;
begin
  Result := IsIPSmaler(Cell1.AsString, Cell2.AsString);
end;

function TCells.NumericGreaterCompare(Cell1, Cell2: TCell): Boolean;
begin
  try
    Result := Cell1.AsFloat >= Cell2.AsFloat;
  except
    on EConvertError do Result := Cell1.AsString >= Cell2.AsString;
  end;
end;

function TCells.NumericLessCompare(Cell1, Cell2: TCell): Boolean;
begin
  try
    Result := Cell1.AsFloat <= Cell2.AsFloat;
  except
    on EConvertError do Result := Cell1.AsString <= Cell2.AsString;
  end;
end;

procedure TCells.DoCellCompare(Cell1, Cell2: TCell; var Compare: Integer);
begin
  if Assigned(FOnCompare) then FOnCompare(Self, Cell1, Cell2, Compare);
end;

procedure TCells.ColumnsChange(ChangeOpearation: TColumnsOperation;
	Value1, Value2: Integer);
begin
  case ChangeOpearation of
    opAdd: AddColumn;
    opMove: MoveColumn(Value1, Value2);
    opDelete: DeleteColumn(Value1);
    opClear: ClearColumns;
    opInsert: InsertColumn(Value1);
  end;        
end;

procedure TCells.AddChildRow(const Index, Position: Integer);
var
  i: Integer;
  NewRow: TRow;
begin
  NewRow := TRow.Create;
  NewRow.ParentRow := TRow(FRowsList[Index]);

  NewRow.FShown := NewRow.ParentRow.Expanded and NewRow.ParentRow.Shown;
  NewRow.ParentRow.AddChild;
  NewRow.RowHeight := RowHeight;
  NewRow.FLevel := NewRow.ParentRow.Level + 1;

  FRowsList.Insert(Position, NewRow);
  Inc(FRowCount);

  if NewRow.Shown then Inc(FVisibleRowCount);

  for i := 0 to FColCount - 1 do
    FCellsList[i].Insert(Position, CreateCell(FColumns[i]));
end;

procedure TCells.AddColumn;
var
  i: integer;
  ACell: TCell;
begin
  FCellsList[FColCount] := TList.Create;
  for i := 0 to FRowCount - 1 do
  begin
  	case FColumns[FColumns.Count - 1].ColumnType of
    	ctBoolean: ACell := TBooleanCell.Create(Self);
    	ctDate: ACell := TDateTimeCell.Create(Self);
    	ctFloat: ACell := TFloatCell.Create(Self);
    	ctInteger: ACell := TIntegerCell.Create(Self);
      ctAutoInc: ACell := TIncrementCell.Create(Self);
      ctGuid: ACell := TGuidCell.Create(Self);
      ctVirtual:
      begin
        {$WARNINGS OFF}
        ACell := TVirtualCell.Create(Self);
        TVirtualCell(ACell).Column := TNxVirtualColumn(FColumns[FColumns.Count - 1]);
        {$WARNINGS ON}
      end;
    	else ACell := TStringCell.Create(Self);
    end;
    ACell.FFontStyle := FColumns[FColumns.Count - 1].Font.Style;
    ACell.FTextColor := FColumns[FColumns.Count - 1].Font.Color;
    ACell.FColor := FColumns[FColumns.Count - 1].Color;
    ACell.Locked := False;
    FCellsList[FColCount].Add(ACell);
  end;
  Inc(FColCount);
end;

procedure TCells.AddRow(Count: Integer = 1);
var
  i, j: Integer;
  ACell: TCell;
  ARow: TRow;
begin
  for j := 0 to Count - 1 do
  begin
    ARow := TRow.Create;
    ARow.RowHeight := FRowHeight;
    Inc(FVisibleRowCount);
    FRowsList.Add(ARow);
    for i := 0 to FColCount - 1 do
    begin
	  	case FColumns[i].ColumnType of
	    	ctBoolean: ACell := TBooleanCell.Create(Self);
	    	ctDate: ACell := TDateTimeCell.Create(Self);
	    	ctFloat: ACell := TFloatCell.Create(Self);
	    	ctInteger: ACell := TIntegerCell.Create(Self);
        ctAutoInc: ACell := TIncrementCell.Create(Self);
        ctGuid: ACell := TGuidCell.Create(Self);
        ctVirtual:  begin
                      {$WARNINGS OFF}
                      ACell := TVirtualCell.Create(Self);
                      TVirtualCell(ACell).Column := TNxVirtualColumn(FColumns[I]);
                      {$WARNINGS ON}
                    end;
	    	else ACell := TStringCell.Create(Self);
	    end;
      ACell.FFontStyle := FColumns[i].Font.Style;
      ACell.FTextColor := FColumns[i].Font.Color;
      ACell.FColor := FColumns[i].Color;
	    ACell.Locked := False;
      FCellsList[i].Add(ACell);
    end;
	  Inc(FRowCount); { Increase count }
  end;
  FSorted := False;
end;

procedure TCells.ClearColumns;
var
  i: Integer;
begin
	for i := 0 to FColCount - 1 do
  begin
    FCellsList[i].Clear;
    FCellsList[i].Free;
    FCellsList[i] := nil;
  end;
  FColCount := 0;
  FRowCount := 0;
  FVisibleRowCount := 0;
end;

procedure TCells.ClearRows;
var
  i, j: Integer;
begin
  { clear cells }
	for i := 0 to FColCount - 1 do
  begin
		for j := 0 to FRowCount - 1 do TCell(FCellsList[i].Items[j]).Free;
    FCellsList[i].Clear;
  end;
  
  { clear rows }
  for i := 0 to FRowCount - 1 do TRow(FRowsList[i]).Free;
  FRowsList.Clear;
  FRowCount := 0;
  FVisibleRowCount := 0;
  FSorted := False;
end;

procedure TCells.DeleteColumn(const Index: Integer);
var
	i: Integer;
begin
	for i := 0 to FRowCount - 1 do TCell(FCellsList[Index].Items[i]).Free;
  FCellsList[Index].Clear;
  FCellsList[Index].Free;
  FCellsList[Index] := nil;
  for i := Index + 1 to FColCount - 1 do FCellsList[i - 1] := FCellsList[i];
  Dec(FColCount);
  if FColCount = 0 then FRowCount := 0;
end;

procedure TCells.DeleteRow(const Index: Integer);
var
  i: Integer;
begin
	for i := 0 to FColCount - 1 do
	begin
	  TCell(FCellsList[i].Items[Index]).Free;
  	FCellsList[i].Delete(Index);
	end;
  Dec(FRowCount);

  if TRow(FRowsList[Index]).Visible and TRow(FRowsList[Index]).Shown
    then Dec(FVisibleRowCount);

  TRow(FRowsList[Index]).Free;
  FRowsList.Delete(Index);
end;

procedure TCells.ExpandRow(Index: Integer; const Value: Boolean);
begin
  if Value <> Row[Index].FShown then
  begin
    Row[Index].FShown := Value;
    if Value then Inc(FVisibleRowCount) else Dec(FVisibleRowCount);
  end;
end;

procedure TCells.InsertColumn(Pos: Integer);
var
  ACellsList: TList;
  ACell: TCell;
  i: Integer;
begin
  Inc(FColCount);
  ACellsList := TList.Create;
  for i := 0 to FRowCount - 1 do
  begin
    case FColumns[Pos].ColumnType of
      ctBoolean: ACell := TBooleanCell.Create(Self);
      ctDate: ACell := TDateTimeCell.Create(Self);
      ctFloat: ACell := TFloatCell.Create(Self);
      ctInteger, ctAutoInc: ACell := TIntegerCell.Create(Self);
      ctGuid: ACell := TGuidCell.Create(Self);
      ctVirtual:
      begin
        {$WARNINGS OFF}
        ACell := TVirtualCell.Create(Self);
        TVirtualCell(ACell).Column := TNxVirtualColumn(FColumns[FColumns.Count - 1]);
        {$WARNINGS ON}
      end;
      else ACell := TStringCell.Create(Self);
    end;
    ACell.FFontStyle := FColumns[Pos].Font.Style;
    ACell.FTextColor := FColumns[Pos].Font.Color;
    ACell.FColor := FColumns[Pos].Color;
    ACell.Locked := False;
    ACellsList.Add(ACell);
  end;
  FSorted := False;
  for i := FColCount - 1 downto Pos do FCellsList[i + 1] := FCellsList[i];
  FCellsList[Pos] := ACellsList;
end;

procedure TCells.InsertRow(Pos: Integer; Count: Integer);
var
  j, i: Integer;
  ACell: TCell;
  ARow: TRow;
begin
  for j := 1 to Count do
  begin
    for i := 0 to FColCount - 1 do
    begin
      case FColumns[i].ColumnType of
        ctBoolean: ACell := TBooleanCell.Create(Self);
        ctDate: ACell := TDateTimeCell.Create(Self);
        ctFloat: ACell := TFloatCell.Create(Self);
        ctInteger, ctAutoInc: ACell := TIntegerCell.Create(Self);
        ctVirtual:
        begin
          {$WARNINGS OFF}
          ACell := TVirtualCell.Create(Self);
          TVirtualCell(ACell).Column := TNxVirtualColumn(FColumns[I]);
          {$WARNINGS ON}
        end;
        else ACell := TStringCell.Create(Self);
      end;
      ACell.FFontStyle := FColumns[i].Font.Style;
      ACell.FTextColor := FColumns[i].Font.Color;
      ACell.Color := FColumns[i].Color;
      ACell.Locked := False;
      FCellsList[i].Insert(Pos, ACell);
    end;
    ARow := TRow.Create;
    ARow.RowHeight := FRowHeight;
    FRowsList.Insert(Pos, ARow);

    { Increase count }
    Inc(FVisibleRowCount);
    Inc(FRowCount);
  end;
  FSorted := False;
end;

procedure TCells.MoveChildRow(Index: Integer; Parent: TRow);
var
  ARow: TRow;
begin
  ARow := Row[Index];
  ARow.FShown := Parent.Expanded; // --------- changed
 // ARow.Level := Parent.Level + 1;
  ARow.RowHeight := RowHeight;
end;

procedure TCells.MoveColumn(CurIndex, NewIndex: Integer);
var
  ACellsList: TList;
  i: integer;
begin
  ACellsList := FCellsList[CurIndex];
  if CurIndex < NewIndex then
    for i := CurIndex + 1 to NewIndex do FCellsList[i - 1] := FCellsList[i]
      else for i := CurIndex downto NewIndex + 1 do FCellsList[i] := FCellsList[i - 1];
  FCellsList[NewIndex] := ACellsList;
end;

procedure TCells.MoveRow(FromPos, ToPos: Integer);
var
  i: Integer;
begin
  FRowsList.Move(FromPos, ToPos);
	for i := 0 to FColCount - 1 do FCellsList[i].Move(FromPos, ToPos);
  FSorted := False;
end;

procedure TCells.ShowRow(Index: Integer; const Value: Boolean);
begin
  if Value <> Row[Index].FVisible then
  begin
    Row[Index].FVisible := Value;
    if Value then Inc(FVisibleRowCount) else Dec(FVisibleRowCount);
  end;
end;

procedure TCells.SortColumn(ACol: Integer; ASortType: TSortType;
  ASortKind: TSortKind; Resort: Boolean);
var
	ALessCompFunc: TCompareFunc;
	AGreaterCompFunc: TCompareFunc;
  procedure Exchange(s, t: Integer);
  var
    P: Pointer;
    i: Integer;
  begin
    P := FRowsList[s];
    FRowsList[s] := FRowsList[t];
    FRowsList[t] := P;
    for i := 0 to FColCount - 1 do
    begin
      P := FCellsList[i].Items[s];
      FCellsList[i].Items[s] := FCellsList[i].Items[t];
      FCellsList[i].Items[t] := P;
    end;
  end;

  procedure InverseSort;
  var
    i, No: Integer;
  begin
    if FRowCount > 0 then
    begin
      No := (FRowCount div 2) - 1;
      for i := 0 to No do
        Exchange(i, FRowCount - 1 - i);
    end;
  end;

  function DivideAsc(l, r: Integer; LessCompFunc,
  	GreaterCompFunc: TCompareFunc): Integer;
  var
    i, j: Integer;
    pivot: TCell;
  begin
  	pivot := GetCell(ACol, l + 1 + Random(r - l));
    i := l - 1;
    j := r + 1;
    repeat
      repeat Inc(i) until LessCompFunc(pivot, GetCell(ACol, i));
	    repeat Dec(j) until GreaterCompFunc(pivot, GetCell(ACol, j));
      if (GetCell(ACol, j) <> GetCell(ACol, i)) then Exchange(i, j)
		until j <= i;
    if (GetCell(ACol, j) <> GetCell(ACol, i)) then Exchange(i, j);
    Result := i;
  end;

  function DivideDesc(l, r: Integer; LessCompFunc,
  	GreaterCompFunc: TCompareFunc): Integer;
  var
    i, j: Integer;
    pivot: TCell;
  begin
  	pivot := GetCell(ACol, l + 1 + Random(r - l));
    i := l - 1;
    j := r + 1;
    repeat
      repeat Inc(i) until GreaterCompFunc(pivot, GetCell(ACol, i));
	    repeat Dec(j) until LessCompFunc(pivot, GetCell(ACol, j));
      if (GetCell(ACol, j) <> GetCell(ACol, i)) then Exchange(i, j)
		until j <= i;
    if (GetCell(ACol, j) <> GetCell(ACol, i)) then Exchange(i, j);
    Result := i;
  end;

  procedure Quicksort(l, r: Integer);
  var
    Middle: Integer;
  begin
    if l < r then
    begin
	    if FSortKind = skAscending
      	then Middle := DivideAsc(l, r, ALessCompFunc, AGreaterCompFunc)
      	else Middle := DivideDesc(l, r, ALessCompFunc, AGreaterCompFunc);
      Quicksort(l, Middle - 1);
      Quicksort(Middle, r);
    end;
  end;
begin
  case ASortType of
    stAlphabetic:	begin
						    		ALessCompFunc := AlphabeticLessCompare;
                    AGreaterCompFunc := AlphabeticGreaterCompare;
                  end;
    stBoolean:	begin
					    		ALessCompFunc := BooleanLessCompare;
                  AGreaterCompFunc := BooleanGreaterCompare;
                end;
    stCaseInsensitive:  begin
                          ALessCompFunc := CaseInsensitiveLessCompare;
                          AGreaterCompFunc := CaseInsensitiveGreaterCompare;
                        end;
    stCustom: begin
                ALessCompFunc := CustomLessCompare;
                AGreaterCompFunc := CustomGreaterCompare;
              end;
    stNumeric:	begin
							    ALessCompFunc := NumericLessCompare;
							    AGreaterCompFunc := NumericGreaterCompare;
                end;
    stDate:	begin
					    ALessCompFunc := DateLessCompare;
					    AGreaterCompFunc := DateGreaterCompare;
            end;
    stIP:	begin
				    ALessCompFunc := IPLessCompare;
				    AGreaterCompFunc := IPGreaterCompare;
          end;
    stUnicodeAlphabetic:
                  begin
						    		ALessCompFunc := AlphabeticUnicodeLessCompare;
                    AGreaterCompFunc := AlphabeticUnicodeGreaterCompare;
                  end;
  end;
	if (ACol = FSortIndex) and FSorted and (ASortKind <> FSortKind) and not Resort then
  begin
    FSortKind := ASortKind;
    InverseSort;
  end else
  begin
    FSortKind := ASortKind;
    Quicksort(0, FRowCount - 1);
  end;
  FSortIndex := ACol;
  FSorted := True;
end;

procedure TCells.SwapRows(FromPos, ToPos: Integer);
var
  P: Pointer;
  i: Integer;
begin
  P := FRowsList[FromPos];
  FRowsList[FromPos] := FRowsList[ToPos];
  FRowsList[ToPos] := P;
  for i := 0 to FColCount - 1 do
  begin
    P := FCellsList[i].Items[FromPos];
    FCellsList[i].Items[FromPos] := FCellsList[i].Items[ToPos];
    FCellsList[i].Items[ToPos] := p;
  end;
end;

procedure TCells.Changed;
begin
  if Assigned(FOnCellChange) then FOnCellChange(Self, FColIndex, FRowIndex);
  FSorted := False;
end;

{ TCell }

constructor TCell.Create(Cells: TCells);
begin
  FCells := Cells;
  FFontStyle := [];
  FState := [cstLocked];
end;

function TCell.GetActualColor: TColor;
begin
	Result := TNextGrid(FCells.FGrid).GetActualCellColor(ColumnIndex, RowIndex);
end;

function TCell.GetActualFontColor: TColor;
begin
	Result := TNextGrid(FCells.FGrid).GetActualCellFontColor(ColumnIndex, RowIndex);
end;

function TCell.GetColumnIndex: Integer;
begin
  Result := FCells.FColIndex;
end;

function TCell.GetDisplayText: WideString;
begin
	Result := TNextGrid(FCells.FGrid).GetDrawText(ColumnIndex, RowIndex);
end;

function TCell.GetHighlighted: Boolean;
begin
	Result := TNextGrid(FCells.FGrid).IsCellHighlighted(ColumnIndex, RowIndex);
end;

function TCell.GetRowIndex: Integer;
begin
  Result := FCells.FRowIndex;
end;

procedure TCell.SetAsBoolean(const Value: Boolean);
begin
  Changed;
end;

procedure TCell.SetAsDateTime(const Value: TDateTime);
begin
  Changed;
end;

procedure TCell.SetAsFloat(const Value: Double);
begin
  Changed;
end;

procedure TCell.SetAsInteger(const Value: Integer);
begin
  Changed;
end;

procedure TCell.SetAsString(const Value: WideString);
begin
  Changed;
end;

procedure TCell.SetFontStyle(const Value: TFontStyles);
begin
  FFontStyle := Value;
  if not Locked then Changed;
end;

procedure TCell.SetColor(const Value: TColor);
begin
  FColor := Value;
  if not Locked then Changed;
end;

procedure TCell.SetHint(const Value: WideString);
begin
  FHint := Value;
  if not Locked then Changed;
end;

procedure TCell.Changed;
begin
  FCells.Changed;
end;

procedure TCell.Clear;
begin
  Changed;
end;

function TCell.GetLocked: Boolean;
begin
  Result := cstLocked in FState;
end;

procedure TCell.SetLocked(const Value: Boolean);
begin
  if Value then Include(FState, cstLocked) else Exclude(FState, cstLocked);
end;

function TCell.GetEmpty: Boolean;
begin
  Result := cstEmpty in FState;
end;

procedure TCell.SetEmpty(const Value: Boolean);
begin
  if Value then Include(FState, cstEmpty) else Exclude(FState, cstEmpty);
  Changed;
end;

procedure TCell.SetTextColor(const Value: TColor);
begin
  FTextColor := Value;
  if not Locked then Changed;
end;

end.
