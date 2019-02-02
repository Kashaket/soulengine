{-------------------------------------------------------------}
{----Purpose : NextSheet Component                            }
{    By      : Bojan Nikolic                                  }
{    For     : BergSoft                                       }
{-------------------------------------------------------------}
{ ddmmyyyy comment                                            }
{ -------- ---------------------------------------------------}
{ 14092008-Grid lines may be hidden, soGridLines in Options   }
{          property.                                          }
{ 27062009-Print method                                       }
{-------------------------------------------------------------}
{ Todo :                                                      }
{-------------------------------------------------------------}

{$R NxSheet.res}
{$I ..\NxSuite.inc}

unit NxSheet;

interface

uses
	Classes, Types, NxScrollControl, Windows, SysUtils, Graphics, Controls,
  Forms, Dialogs, Messages, ExtCtrls,
  NxSharedCommon, NxFormulaParser, NxSharedDraw, NxSheetCell,
  NxSheetEdit, NxClasses, NxVersions;

const
  crResizeCol = 7001;
  crResizeRow = 7002;
	crSelectCell = 7003;
  sizDefaultFontSize = 11;
	sizFixedColumnWidth = 26;
	sizFixedRowHeight = 20;
  stDefaultFontName = 'Calibri';

type
  TSheetCellCopyOptions = set of (coValue, coFormating);
  TSheetAppearanceOptions = set of (apIndicateCalculated);
	TSheetOptions = set of (soAutoCalculation, soAutoCellKind, soClipboard, soEditing, soGridLines, soHeadings, soResizing, soSelectionExpandHandle, soShowContent);
  TSheetStyle = (stDefault, stOffice12, stOffice2003, stOffice2007);
  TSheetState = set of (stEditing, stResizingColumn, stResizingRow, stCtrlSelection,
    stShiftSelection);
  TKeysState = set of (ksCapsLock, ksNumLock, ksScrollLock);
  TNxCellState = set of (csSelected, csFocused);
  TNxSheetPrintOptions = set of (poPageNumbers, poPageTitle);

  TCellLocation = (clCorner, clColumn, clRow);
  TDrawCellBackgroundEvent = procedure (Sender: TObject; ACol, ARow: Integer; CellRect: TRect) of object;
  TSelectionMoveDirection = (mdNone, mdUp, mdDown, mdLeft, mdRight);

  TNxCellChangeEvent = procedure (Sender: TObject; ACol, ARow: Integer; Text: WideString) of object;
  TNxAfterEditEvent = procedure (Sender: TObject; ACol, ARow: Integer;
    var Accept: Boolean; var Text: WideString) of object;
  TNxBeforeEditEvent = procedure (Sender: TObject; ACol, ARow: Integer;
    var CanEdit: Boolean; var Text: WideString) of object;
  TNxCellColorEvent = procedure (Sender: TObject; ACol, ARow: Integer;
    var CellColor: TColor; CellState: TNxCellState) of object;

  TSelectCellEvent = procedure (Sender: TObject; ACol, ARow: Integer) of object;

  TCellsRange = packed record
  	EndCol: Integer;
  	EndRow: Integer;
  	StartCol: Integer;
  	StartRow: Integer;
  end;

  TNxBeforeExpandEvent = procedure (Sender: TObject; var Accept: Boolean) of object;
  TNxAfterExpandEvent = procedure (Sender: TObject) of object;

  TNextSheet = class;

  TBorderDisplay = class
  private
    FBorder: TNxCellBorder;
    FCanvas: TCanvas;
    FClientRect: TRect;
    FGridLinesColor: TColor;
    FPosition: TBorderPosition;
  protected
    procedure DrawDashDotDot;
    procedure DrawDot;
    procedure DrawDouble;
    procedure DrawNone;
    procedure DrawSolid;
    procedure DrawThinDot;
    procedure DrawThinLine;
    procedure DrawWeightDashDotDot;
    procedure DrawWeightSolid;
    procedure DrawWideDot;
  public
    constructor Create(ACanvas: TCanvas);
    procedure Draw(Border: TNxCellBorder; ARect: TRect; Position: TBorderPosition);
    property GridLinesColor: TColor read FGridLinesColor write FGridLinesColor;
  end;

  TNxPageSheet = class
  private
    FCaption: TCaption;
    FOwner: TNextSheet;
    FTabColor: TColor;
    procedure SetCaption(const Value: TCaption);
    procedure SetTabColor(const Value: TColor);
    function GetIndex: Integer;
  public
    constructor Create(AOwner: TNextSheet);
    property Index: Integer read GetIndex;
  published
    property Caption: TCaption read FCaption write SetCaption;
    property TabColor: TColor read FTabColor write SetTabColor;
  end;

  TNxStylePainter = class
  private
    FAlignment: TCellAlignment;
    FColor: TColor;
    FFont: TFont;
    FFormatMask: string;
    FKind: TCellKind;
    FOwner: TNextSheet;
  public
    constructor Create(AOwner: TNextSheet);
    destructor Destroy; override;
    property Alignment: TCellAlignment read FAlignment write FAlignment default caBottomCenter;
    property Color: TColor read FColor write FColor default clNone;
    property Font: TFont read FFont write FFont;
    property FormatMask: string read FFormatMask write FFormatMask;
    property Kind: TCellKind read FKind write FKind default ckGeneral;
    procedure Apply(FromCol, FromRow, ToCol, ToRow: Integer);
    procedure Paint(Col, Row: Integer);
  end;

	TNextSheet = class(TNxScrollControl)
  private
    FAppearanceOptions: TSheetAppearanceOptions;
    FBorderDisplay: TBorderDisplay;
    FBorderStyle: TBorderStyle;
    FCells: TNxSheetCells;
    FDrawingList: TList;
    FEditCol: Integer;
    FEditRect: TRect;
    FEditRow: Integer;
    FExpansionRange: TCellsRange;
    FExpandingReady: Boolean;
    FFixedColWidth: Integer;
    FFixedRowHeight: Integer;
    FFormulaParser: TNxFormulaParser;
    FInplaceEdit: TNxSheetEdit;
    FMouseDown: Boolean;
    FOldExpansionRect: TRect;
    FOldMouseOverCell: TNxCell;
    FOldSelectionRect: TRect;
    FOnAfterEdit: TNxAfterEditEvent;
    FOnAfterExpand: TNxAfterExpandEvent;
    FOnBeforeEdit: TNxBeforeEditEvent;
    FOnBeforeExpand: TNxBeforeExpandEvent;
    FOnChange: TNxCellChangeEvent;
    FOnCellColor: TNxCellColorEvent;
    FOnExpanding: TNotifyEvent;
    FOnSelectCell: TSelectCellEvent;
    FOptions: TSheetOptions;
    FResizingCol: Integer;
    FResizingRow: Integer;
    FSelectedCell: TNxCell;
    FSelectedCol: Integer;
    FSelectedRow: Integer;
    FSelection: TCellsRange;
    FSelectionMoveDirection: TSelectionMoveDirection;
    FSheetIndex: Integer;
    FSheetList: TList;
    FSheetState: TSheetState;
    FStyle: TSheetStyle;
    FStylePainter: TNxStylePainter;
    FVersion: string;
    FWantReturns: Boolean;
    FZoom: Integer;
    FExpanding: Boolean;
    function GetCell(ACol, ARow: Integer): TNxCell;
    function GetCellHeight(ACol, ARow: Integer): Integer;
    function GetCellWidth(ACol, ARow: Integer): Integer;
    function GetColumn(Index: Integer): TNxSheetColumn;
    function GetRow(Index: Integer): TNxSheetRow;
    function GetRowCount: Integer;
    function GetSelectionHandleRect: TRect;
    function GetSelected(ACol, ARow: Integer): Boolean;
    function GetSheetCount: Integer;
    function ReadColCount: Integer;
    procedure DrawHeadingRect(ARect: TRect; Location: TCellLocation);
    procedure SetAppearanceOptions(const Value: TSheetAppearanceOptions);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetCell(ACol, ARow: Integer; const Value: TNxCell);
    procedure SetColCount(const Value: Integer);
    procedure SetColumn(Index: Integer; const Value: TNxSheetColumn);
    procedure SetExpanding(const Value: Boolean);
    procedure SetExpandingReady(const Value: Boolean);
    procedure SetFixedColWidth(const Value: Integer);
    procedure SetFixedRowHeight(const Value: Integer);
    procedure SetOptions(const Value: TSheetOptions);
    procedure SetRow(Index: Integer; const Value: TNxSheetRow);
    procedure SetRowCount(const Value: Integer);
    procedure SetSelected(ACol, ARow: Integer; const Value: Boolean);
    procedure SetSelectedCol(const Value: Integer);
    procedure SetSelectedRow(const Value: Integer);
    procedure SetSheetIndex(const Value: Integer);
    procedure SetStyle(const Value: TSheetStyle);
    procedure SetZoom(const Value: Integer);
    procedure SetVersion(const Value: string);
    procedure SetExpansionRange(const Value: TCellsRange);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoCellColor(ACol, ARow: Integer; var CellColor: TColor; CellState: TNxCellState);
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function GetBodyRect: TRect;
	  function GetCellLeft(ACol: Integer): Integer;
    function GetCellTextWidth(ACol, ARow: Integer; S: WideString): Integer;
	  function GetCellTop(ARow: Integer): Integer;
    function GetExpansionRect: TRect;
    function GetFixedSize: TSize;
    function GetHorzOffset(FromPos, ToPos: Integer): Integer; override;
    function GetKeysState: TKeysState;
    function GetSelectionRect: TRect;
    function GetSheetRect: TRect;
    function GetVertOffset(FromPos, ToPos: Integer): Integer; override;
    function IsRectVisible(Rect: TRect): Boolean;
    function IsCellInView(Cell: TNxCell): Boolean;
    function ZoomSize(const Value: Integer): Integer;
    function UnzoomSize(const Value: Integer): Integer;
    procedure CalculateHorzScrollBar;
    procedure CalculateVertScrollBar;
    procedure DblClick; override;
    procedure DoAfterExpand; dynamic;
    procedure DoAfterEdit(ACol, ARow: Integer; var Accept: Boolean; var Text: WideString); dynamic;
    procedure DoBeforeEdit(ACol, ARow: Integer; var CanEdit: Boolean; var Text: WideString); dynamic;
    procedure DoBeforeExpand(var Accept: Boolean); dynamic;
    procedure DoBorderChange(Sender: TObject; ACol, ARow: Integer; Position: TBorderPosition);
    procedure DoCellChange(Sender: TObject; ACol, ARow: Integer);
    procedure DoCellValueChange(Sender: TObject; ACol, ARow: Integer; var Value: WideString);
    procedure DoChange(ACol, ARow: Integer; Text: WideString); dynamic;
    procedure DoColumnChange(Sender: TObject);
    procedure DoColumnResize(Sender: TObject; OldSize, NewSize: Integer);
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoExpanding; dynamic;
    procedure DoRowChange(Sender: TObject);
    procedure DoRowResize(Sender: TObject; OldSize, NewSize: Integer);
    procedure DoSelectCell(ACol, ARow: Integer); dynamic;
  	procedure DrawCell(ACol, ARow: Integer; CellRect: TRect);
  	procedure DrawCellBorder(ACol, ARow: Integer; CellRect: TRect); virtual;
    procedure DrawDotsBackground(Rect: TRect);
    procedure DrawExpansionRange(Erase: Boolean; DoDraw: Boolean = True);
    procedure DrawFixedCell(CellRect: TRect; Text: string; Location: TCellLocation);
    procedure DrawRangeSelection(Erase: Boolean = False);
    procedure DrawSelectionHandle;
    function GetVisibleHeight: Integer;
    function GetVisibleWidth: Integer;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure PaintBackground;
    procedure PaintCells;
    procedure PaintHeadings;
    procedure PrintBorder(Border: TNxCellBorder; R: TRect; Position: TBorderPosition);
  	procedure PrintCellBorder(ACol, ARow: Integer; CellRect: TRect); virtual;
    procedure RefreshColumn(Index: Integer);
    procedure RefreshFixedColumn;
    procedure RefreshFixedRow;
    procedure RefreshRange(ARange: TCellsRange);
    procedure RefreshRow(Index: Integer);
    procedure RefreshSelectionRect;
    procedure ScrollColumns(FromPos, ToPos: Integer);
    procedure ScrollRows(FromPos, ToPos: Integer);
    procedure SetCellBorders(X, Y: Integer); virtual;
    procedure SetCellFont(ACol, ARow: Integer; Font: TFont);
    procedure UpdateSelection(X, Y: Integer);
    function VisibleColCount: Integer;
    function VisibleRowCount: Integer;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    { Properties }
    property Expanding: Boolean read FExpanding write SetExpanding;
    property ExpandingReady: Boolean read FExpandingReady write SetExpandingReady;
    property SelectionHandleRect: TRect read GetSelectionHandleRect;
  public
    procedure AddCells(Values: array of WideString; ACol, ARow: Integer);
    procedure AddColumn(Count: Integer = 1);
    procedure AddRow(Count: Integer = 1);
    procedure AssignColor(FromCol, FromRow, ToCol, ToRow: Integer; const Color: TColor);
    function AddSheet(const Caption: string = ''): TNxPageSheet;
    procedure AssignCell(ACol, ARow, SourceCol, SourceRow: Integer;
      Options: TSheetCellCopyOptions = [coValue, coFormating]);
    procedure CalculateSheet; virtual;
    function CellBounds(ACol, ARow: Integer): Boolean;
    procedure CopyToClipBoard;
  	constructor Create(AOwner: TComponent); override;
    procedure CutToClipBoard;
    destructor Destroy; override;
    function GetCellAtPos(X, Y: Integer): TNxCell;
    function GetCellLocation(const ACell: TNxCell): TCellPosition;
    function GetCellRange(ACol, ARow: Integer): TCellsRange;
    function GetCellRect(ACol, ARow: Integer): TRect;
    function GetColumnAddress(ACol: Integer): string;
    function GetColumnAtPos(Pos: Integer): Integer;
    function GetColumnGripAtPos(X, Y: Integer): Integer;
    function GetFixedRowRect(Index: Integer): TRect;
    function GetCellsRangeRect(const Range: TCellsRange): TRect;
    function GetRowAtPos(Pos: Integer): Integer;
    function GetRowGripAtPos(X, Y: Integer): Integer;
    procedure CancelEdit(Apply: Boolean = True);
    procedure Clear;
    procedure ClearFormating(FromCol, FromRow, ToCol, ToRow: Integer);
    procedure CopyCell(ACol, ARow: Integer);
    procedure DeleteColumn(Index: Integer);
    procedure DeleteRow(Index: Integer);
    procedure Deselect;
    procedure DrawLine(FromCol, FromRow, ToCol, ToRow: Integer; LineStyle: TLineStyle;
      LineColor: TColor; Position: TBorderPosition = bpsBottom);
    procedure EditCell(const ACol, ARow: Integer; Value: WideString = '');
    procedure Erase(FromCol, FromRow, ToCol, ToRow: Integer);
    procedure Expression(const Col, Row: Integer; var Value: WideString);
    procedure FrameCell(ACol, ARow: Integer; LineStyle: TLineStyle; LineColor: TColor);
    procedure FrameRange(Range: TCellsRange; LineStyle: TLineStyle; LineColor: TColor); overload;
    procedure InsertColumn(Index: Integer);
    procedure InsertRow(Index: Integer);
    function IsColInView(Index: Integer): Boolean;
    function IsRowInView(Index: Integer): Boolean;
    procedure MergeCells(FromCol, FromRow, ToCol, ToRow: Integer;
      Alignment: TCellAlignment = caBottomCenter);
    procedure MergeSelection;
    procedure MoveSelection;
    procedure MoveSelectionDown;
    procedure MoveSelectionLeft;
    procedure MoveSelectionRight;
    procedure MoveSelectionUp;
    procedure PasteFromClipBoard;
    procedure Print(Zoom: Integer = 100; Options: TNxSheetPrintOptions = [poPageNumbers, poPageTitle]);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToXLSFile(const FileName: string);
    procedure SaveToCSVFile(const FileName: WideString; Separator: WideChar = ',';
      MultiLineSeparator: WideChar = '|'; EncodingKind: TEncodingKind = ekUnicode);
    procedure ScrollToSelected(First: Boolean = False);
    procedure SelectCell(ACol, ARow: Integer);
    procedure SelectCells(FromCol, FromRow, ToCol, ToRow: Integer);
    procedure SetScrollClipRect; virtual;
    procedure SplitCells(FromCol, FromRow, ToCol, ToRow: Integer);
    procedure RefreshCell(ACol, ARow: Integer; Border: Boolean = False);
    procedure TryToEdit(ACol, ARow: Integer; Value: WideString);
    property Canvas;
    property Cell[ACol, ARow: Integer]: TNxCell read GetCell write SetCell;
    property Column[Index: Integer]: TNxSheetColumn read GetColumn write SetColumn;
    property ExpansionRange: TCellsRange read FExpansionRange write SetExpansionRange;
    property Row[Index: Integer]: TNxSheetRow read GetRow write SetRow;
    property Selected[ACol, ARow: Integer]: Boolean read GetSelected write SetSelected;
    property Selection: TCellsRange read FSelection;
    property SheetCount: Integer read GetSheetCount;
    property SheetState: TSheetState read FSheetState;
    property StylePainter: TNxStylePainter read FStylePainter;
  published
    function mCell(var context: TNxFormulaParser; var s: string): Extended;
  	property Align;
    property Anchors;
    property AppearanceOptions: TSheetAppearanceOptions read FAppearanceOptions write SetAppearanceOptions default [];
    property Caption;
    property Constraints;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
  	property ColCount: Integer read ReadColCount write SetColCount default 1;
    property Color;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColWidth: Integer read FFixedColWidth write SetFixedColWidth default sizFixedColumnWidth;
    property FixedRowHeight: Integer read FFixedRowHeight write SetFixedRowHeight default sizFixedRowHeight;
    property Font;
		property Options: TSheetOptions read FOptions write SetOptions default [soAutoCalculation, soEditing, soGridLines, soHeadings, soResizing];
    property ParentColor default False;
    property ParentFont;
    property PopupMenu;
  	property RowCount: Integer read GetRowCount write SetRowCount default 1;
    property SheetIndex: Integer read FSheetIndex write SetSheetIndex default 0;
    property SelectedCol: Integer read FSelectedCol write SetSelectedCol default 0;
    property SelectedRow: Integer read FSelectedRow write SetSelectedRow default 0;
    property SelectionMoveDirection: TSelectionMoveDirection read FSelectionMoveDirection write FSelectionMoveDirection default mdDown;
    property Style: TSheetStyle read FStyle write SetStyle default stDefault;
    property TabStop;
    property Version: string read FVersion write SetVersion stored False;
    property Visible;
    property WantReturns: Boolean read FWantReturns write FWantReturns default False;
    property Zoom: Integer read FZoom write SetZoom default 100;

    property OnChange: TNxCellChangeEvent read FOnChange write FOnChange;
    property OnClick;
    property OnAfterEdit: TNxAfterEditEvent read FOnAfterEdit write FOnAfterEdit;
    property OnAfterExpand: TNxAfterExpandEvent read FOnAfterExpand write FOnAfterExpand;
    property OnBeforeEdit: TNxBeforeEditEvent read FOnBeforeEdit write FOnBeforeEdit;
    property OnBeforeExpand: TNxBeforeExpandEvent read FOnBeforeExpand write FOnBeforeExpand;
    property OnCellColor: TNxCellColorEvent read FOnCellColor write FOnCellColor;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanding: TNotifyEvent read FOnExpanding write FOnExpanding;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnMouseUp;
    property OnSelectCell: TSelectCellEvent read FOnSelectCell write FOnSelectCell;
    property OnStartDrag;
  end;

procedure Register;

implementation

uses NxSheetDraw, NxXLSDocument, Printers, Math, ClipBrd;

procedure Register;
begin
  RegisterComponents('Next Suite', [TNextSheet, TNxFormulaParser]);
end;

{Desc: Routine for parsing CELL function calls }

function Preparse(Value: string): string;
var
  CharPtr                       : Integer;                                      //Current letter being examined
  ch                            : Char;                                         //veg: Moved, Only one ch for this and nested functions!

  //Used for expansion of blocks and replacement with Cell function.

  function NextChar(var aCh: Char): Char;                                       //Get the next character
  begin
    if (Length(Value) >= CharPtr) then
      aCh := Upcase(Value[CharPtr])
    else
      aCh := #0;
    Inc(CharPtr);
    Result := aCh;
  end;

  function PeekChar(var aCh: Char): Char;                                       //veg: Added Just look at the current character
  begin
    if (Length(Value) >= CharPtr) then
      aCh := Upcase(Value[CharPtr])
    else
      aCh := #0;
    Result := aCh;
  end;

  function GetCellRef: string;                                                  //Get a Cell reference.
  var
    op                          : Integer;
  begin
    Result := '';

    { TODO -oveg -ctodo : This parsing needs to be improved to find longer names like A100 or AB60 too... }
    { TODO -oveg -ctodo : $ Syntax is untested, basically it's something used when copying and
                          pasting formula's so we can just remove them during evaluation... }


    op := CharPtr;
    case NextChar(ch) of
      'A'..'Z':                                                                 //veg: lowercase does not happen (see Next/PeekChar)
        begin
          while PeekChar(ch) in ['A'..'Z'] do                                   //veg: Skip all letters first
            NextChar(ch);
          if (PeekChar(ch) in ['0'..'9']) then
            while NextChar(ch) in ['0'..'9'] do                                 //veg: Then get the numericals
              Result := UpperCase(Copy(Value, op, CharPtr - op));
        end;
    end;
  end;



  function Cell2Point(cell: string): TPoint;
  var
    i                           : Integer;
  begin
    Result.X := 0;                                                              //veg: Improved for larger references
    Result.Y := 0;

    for i := 1 to Length(cell) do
      case cell[i] of
        'A'..'Z': Result.X := Result.X * 26 + Ord(cell[i]) - Ord('@');
//        'a'..'z': Result.X := Result.X * 26 + Ord(cell[i]) - Ord('`');
        '0'..'9': Result.Y := Result.Y * 10 + Ord(cell[i]) - Ord('0');
      end;

    Dec(Result.X);                                                              //veg: Starting at 0 instead of 1
    Dec(Result.Y);                                                              //veg: Starting at 0 instead of 1;
  end;

  function Point2Cell(x: Integer; y: Integer): string;                          //veg:Added
  var
    i                           : Integer;
    s1                          : string;
    s2                          : string;
  begin
    s1 := '';                                                                   //veg: Improved for larger references

    i := x + 1;                                                                 //veg: Starting at 0 instead of 1
    while i > 0 do
      begin
        s1 := Chr((i mod 26) + Ord('@')) + s1;
        i := i div 26;
      end;

    s2 := '';
    i := y + 1;                                                                 //veg: Starting at 0 instead of 1
    while i > 0 do
      begin
        s2 := Chr((i mod 10) + Ord('0')) + s2;
        i := i div 10;
      end;

    Result := s1 + s2;
  end;

var
  cellA                         : string;
  cellB                         : string;
  ptA                           : TPoint;
  ptB                           : TPoint;
  s                             : string;
  x                             : Integer;
  y                             : Integer;
  Expr                          : string;                                       //The expression in conversion
begin
  Expr := '';
  CharPtr := 1;

  //parsing := False;
  repeat
    case NextChar(ch) of
      '=':
        repeat
          cellA := '';
          cellB := '';
          repeat
            if (PeekChar(ch) = '(') then
              NextChar(ch);
            cellA := GetCellRef();
          until (CellA <> '') or (CharPtr >= Length(Value));

          if (CellA <> '') then
            begin
              //Convert Cell from A2 to Cell("A2")
              Expr := Expr + Copy(Value, 1, CharPtr - Length(CellA) - 2);
              Delete(Value, 1, CharPtr - 1);
              CharPtr := 1;

              if (ch = '(') then
                Expr := Expr + cellA                                            //veg: We have mistaken functions like LOG10 for a Cell.
              else if (ch <> ':') then
                Expr := Expr + 'CELL("' + cellA + '")';

              case ch of
                //'(': Expr := expr + ch;                                       //veg: Now done by the else clause
                //')': Expr := expr + ch;                                       //veg: Now done by the else clause
                ':':                                                            // Expand Cell Block Reference & Convert it to Cell functions.
                  begin
                    cellB := GetCellRef();                                      //veg: GetCellRef calls NextChar()!

                    Delete(Value, 1, Length(cellB));
                    CharPtr := 1;

                    ptA := Cell2Point(CellA);
                    ptB := Cell2Point(CellB);

                    s := '';
                   for x := ptA.X to ptB.X do
                     for y := ptA.Y to ptB.Y do
                        if s = '' then
                         s := s + 'CELL("' + Point2Cell(x, y) + '")'
                       else
                         s := s + ', CELL("' + Point2Cell(x, y) + '")';

                    Expr := Expr + s;

                    if (ch = ')') then
                      begin
                        Expr := Expr + ')';
                        Delete(Value, 1, 1);
                        PeekChar(ch);
                      end;
                  end;
                #0: ;
                else
                  begin
                    if (ch in [LocalSettings.ListSeparator, ';']) then                        // Just replace this by a comma.
                      Expr := Expr + ','
                    else
                      Expr := Expr + ch;
                  end;
              end;
            end
          else
            begin
              Expr := Expr + Value;

              //veg: Bail-out.
              Value := '';
              ch := #0;
            end;
       until (ch = #0) and (CharPtr >= Length(Value));
    end
  until (ch = #0) and (CharPtr >= Length(Value));

  Result := Expr;
end;

{Desc: Return TCellsRange based on specified parameters }

function CellRange(AStartCol, AStartRow, AEndCol, AEndRow: Integer): TCellsRange;
begin
  with Result do
  begin
    StartCol := AStartCol;
    StartRow := AStartRow;
    EndCol := AEndCol;
    EndRow := AEndRow;
  end;
end;

{ Desc: Return True if there are more than 1 cell in range }

function IsRange(Range: TCellsRange): Boolean;
begin
  Result := (Range.EndCol <> Range.StartCol) or (Range.EndRow <> Range.StartRow);
end;

function SameRange(Range1, Range2: TCellsRange): Boolean;
begin
  Result := (Range1.StartCol = Range2.StartCol) and (Range1.EndCol = Range2.EndCol) and
    (Range1.StartRow = Range2.StartRow) and (Range1.EndRow = Range2.EndRow);
end;

{ TBorderDisplay }

constructor TBorderDisplay.Create(ACanvas: TCanvas);
begin
  FCanvas := ACanvas;
end;

procedure TBorderDisplay.DrawDashDotDot;
begin
  { - - --- - - }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom: DrawDashDotDotLine(FCanvas, Left, Bottom - 1, Right, Bottom - 1);
      bpsRight: DrawDashDotDotLine(FCanvas, Right - 1, Top, Right - 1, Bottom);
    end;
  end;
end;

procedure TBorderDisplay.DrawDot;
begin
  { - - - - }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom: DrawDotLine(FCanvas, Left, Bottom - 1, Right, Bottom - 1);
      bpsRight: DrawDotLine(FCanvas, Right - 1, Top, Right - 1, Bottom);
    end;
  end;
end;

procedure TBorderDisplay.DrawDouble;
begin
  { double = }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom:
      begin
        MoveTo(Left, Bottom - 2);
        LineTo(Right, Bottom - 2);
        MoveTo(Left, Bottom);
        LineTo(Right, Bottom);
      end;
      bpsRight:
      begin
        MoveTo(Right - 2, Top);
        LineTo(Right - 2, Bottom);
        MoveTo(Right, Top);
        LineTo(Right, Bottom);
      end;
    end;
  end;
end;

procedure TBorderDisplay.DrawNone;
begin
  with FCanvas, FClientRect do
  begin
    case FPosition of
      bpsBottom:
      begin
        Pen.Color := FGridLinesColor;
        MoveTo(Left, Bottom - 1);
        LineTo(Right, Bottom - 1);
      end;
      bpsRight:
      begin
        Pen.Color := FGridLinesColor;
        MoveTo(Right - 1, Top);
        LineTo(Right - 1, Bottom);
      end;
    end;
  end;
end;

procedure TBorderDisplay.DrawSolid;
begin
  { solid 2px wide line }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom:
      begin
        MoveTo(Left - 2, Bottom - 2);
        LineTo(Right, Bottom - 2);
        MoveTo(Left - 1, Bottom - 1);
        LineTo(Right, Bottom - 1);
      end;
      bpsRight:
      begin
        MoveTo(Right - 2, Top - 1);
        LineTo(Right - 2, Bottom);
        MoveTo(Right - 1, Top - 2);
        LineTo(Right - 1, Bottom);
      end;
    end;
  end;
end;

procedure TBorderDisplay.DrawThinLine;
begin
  { solid 1px line }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom:
      begin
        MoveTo(Left, Bottom - 1);
        LineTo(Right, Bottom - 1);
      end;
      bpsRight:
      begin
        MoveTo(Right - 1, Top);
        LineTo(Right - 1, Bottom);
      end;
    end;
  end;
end;

procedure TBorderDisplay.DrawWeightDashDotDot;
begin
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom:
      begin
        DrawDashDotDotLine(FCanvas, Left, Bottom - 1, Right, Bottom - 1);
        DrawDashDotDotLine(FCanvas, Left, Bottom - 2, Right, Bottom - 2);
      end;
      bpsRight:
      begin
        MoveTo(Right - 2, Top - 1);
        LineTo(Right - 2, Bottom);
        MoveTo(Right - 1, Top - 2);
        LineTo(Right - 1, Bottom);
      end;
    end;
  end;
end;

procedure TBorderDisplay.DrawWeightSolid;
begin
  { 3px solid line }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom:
      begin
        MoveTo(Left, Bottom - 2);
        LineTo(Right, Bottom - 2);
        MoveTo(Left, Bottom - 1);
        LineTo(Right, Bottom - 1);
        MoveTo(Left, Bottom);
        LineTo(Right, Bottom);
      end;
      bpsRight:
      begin
        MoveTo(Right - 2, Top);
        LineTo(Right - 2, Bottom);
        MoveTo(Right - 1, Top);
        LineTo(Right - 1, Bottom);
        MoveTo(Right, Top);
        LineTo(Right, Bottom);
      end;
    end;
  end;
end;

procedure TBorderDisplay.Draw(Border: TNxCellBorder; ARect: TRect;
  Position: TBorderPosition);
begin
  FBorder := Border;
  FClientRect := ARect;
  FPosition := Position;
  with FCanvas do
  begin
    case Border.LineStyle of
      lsDashDot: begin end;
      lsDashDotDot: DrawDashDotDot;
      lsDot: DrawDot;
      lsDouble: DrawDouble;
      lsNone: DrawNone;
      lsSkewDastDot: begin end;
      lsSolid: DrawSolid;
      lsThinDot: DrawThinDot;
      lsThinLine: DrawThinLine;
      lsWeightDash: begin end;
      lsWeightDashDot: begin end;
      lsWeightDashDotDot: DrawWeightDashDotDot;
      lsWeightSolid: DrawWeightSolid;
      lsWideDot: DrawWideDot;
    end;
  end;
end;

procedure TBorderDisplay.DrawThinDot;
begin
  { 1px ...... }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom: DrawThinDotLine(FCanvas, Left, Bottom - 1, Right, Bottom - 1);
      bpsRight: DrawThinDotLine(FCanvas, Right - 1, Top, Right - 1, Bottom);
    end;
  end;
end;

procedure TBorderDisplay.DrawWideDot;
begin
  { 1px ------- }
  with FCanvas, FClientRect do
  begin
    Pen.Color := FBorder.Color;
    case FPosition of
      bpsBottom: DrawWideDotLine(FCanvas, Left, Bottom - 1, Right, Bottom - 1);
      bpsRight: DrawWideDotLine(FCanvas, Right - 1, Top, Right - 1, Bottom);
    end;
  end;
end;

{ TNxStylePainter }

constructor TNxStylePainter.Create(AOwner: TNextSheet);
begin
  FAlignment := caBottomCenter;
  FColor := clNone;
  FFont := TFont.Create;
  FOwner := AOwner;
end;

procedure TNxStylePainter.Apply(FromCol, FromRow, ToCol, ToRow: Integer);
var
  i, j: Integer;
begin
  for i := FromCol to ToCol do
    for j := FromRow to ToRow do
    begin
      with FOwner.Cell[i, j] do
      begin
        Alignment := FAlignment;
        Color := FColor;
        Font.Assign(FFont);
        FormatMask := FFormatMask;
        Kind := FKind;
      end;
    end;
end;

destructor TNxStylePainter.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

procedure TNxStylePainter.Paint(Col, Row: Integer);
begin
  with FOwner.Cell[Col, Row] do
  begin
    Alignment := FAlignment;
    Color := FColor;
    Font.Assign(FFont);
    FormatMask := FFormatMask;
    Kind := FKind;
  end;
end;

{ TNxPageSheet }

constructor TNxPageSheet.Create(AOwner: TNextSheet);
begin
  FOwner := AOwner;
end;

function TNxPageSheet.GetIndex: Integer;
begin
  Result := FOwner.FSheetList.IndexOf(Self);
end;

procedure TNxPageSheet.SetCaption(const Value: TCaption);
begin
  FCaption := Value;
end;

procedure TNxPageSheet.SetTabColor(const Value: TColor);
begin
  FTabColor := Value;
end;

{ TNextSheet }

procedure TNextSheet.AddCells(Values: array of WideString; ACol, ARow: Integer);
var
  i: Integer;
begin
  i := 0;
  while i < Length(Values) do
  begin
    Cell[ACol, ARow].Text := Values[i];
    Inc(ACol);
    if(ACol) >= ColCount then
    begin
      ACol := 0;
      Inc(ARow);
      if (ARow >= RowCount) and not (i + 1 >= Length(Values)) then RowCount := RowCount + 1;
    end;          
    Inc(i);
  end;
end;

procedure TNextSheet.CalculateSheet;
var
  i, j: Integer;
  s: WideString;
begin
  for i := 0 to ColCount - 1 do
  begin
    for j := 0 to RowCount - 1 do
    begin
      s := Cell[i, j].Text;
      Expression(i, j, s);
      if Cell[i, j].Value <> s then
      begin
        Cell[i, j].Value := s;
        RefreshCell(i, j);
      end;
    end;
  end;
end;

constructor TNextSheet.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csDoubleClicks];
  FAppearanceOptions := [];
  FBorderDisplay := TBorderDisplay.Create(Canvas);
  FBorderDisplay.FGridLinesColor := clSilver;
  FBorderStyle := bsSingle;
  FCells := TNxSheetCells.Create;
  FCells.OnBorderChange := DoBorderChange;
  FCells.OnCellChange := DoCellChange;
  FCells.OnColumnResize := DoColumnResize;
  FCells.OnRowResize := DoRowResize;
  FCells.OnValueChange := DoCellValueChange;
  FFixedColWidth := sizFixedColumnWidth;
  FFixedRowHeight := sizFixedRowHeight;

  { Formula Parser }
  FFormulaParser := TNxFormulaParser.Create(Self);
  FFormulaParser.ObjectReference := Self;
  FFormulaParser.Addobject(Self, 'CELL', tfp_m_1str);
  FFormulaParser.Addermsg(40, 'Invalid Cell Address'); {Error 40}
  FFormulaParser.Addermsg(41, 'Invalid Cell Address Format'); {Error 41}

  FInplaceEdit := TNxSheetEdit.Create(Canvas);

  FExpanding := False;
  FExpandingReady := False;
  FExpansionRange := CellRange(-1, -1, -1, -1);

  FOptions := [soAutoCalculation, soEditing, soHeadings, soGridLines, soResizing];
  FSelectedCell := nil;
  FSelectedCol := 0;
  FSelectedRow := 0;
  FSelectionMoveDirection := mdDown;
  FStyle := stDefault;
  FStylePainter := TNxStylePainter.Create(Self);
  FVersion := strNextSheetVer;
  FZoom := 100;
  Color := clWhite;
  ParentColor := False;
  Screen.Cursors[crResizeCol] := LoadCursor(HInstance, 'RESIZECOL');
  Screen.Cursors[crResizeRow] := LoadCursor(HInstance, 'RESIZEROW');
  Screen.Cursors[crSelectCell] := LoadCursor(HInstance, 'SELECTCELL');
  Width := 320;
  Height := 120;
  FCells.AddFirstCell;

  FDrawingList := TList.Create;
end;

procedure TNextSheet.CutToClipBoard;
begin
  CopyToClipBoard;
  Erase(Selection.StartCol,Selection.StartRow,Selection.EndCol,Selection.EndRow);
end;

destructor TNextSheet.Destroy;
begin
  FreeAndNil(FBorderDisplay);
  FreeAndNil(FCells);
  FreeAndNil(FDrawingList);
  FreeAndNil(FFormulaParser);
  FreeAndNil(FInplaceEdit);
  FreeAndNil(FStylePainter);
  inherited;
end;

procedure TNextSheet.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    case BorderStyle of
      bsNone: ExStyle := ExStyle and not WS_EX_STATICEDGE;
      bsSingle: ExStyle := ExStyle or WS_EX_STATICEDGE;
    end;
		with WindowClass do Style := Style and not(CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TNextSheet.CreateWnd;
begin
  inherited;
  VertScrollBar.Visible := False;
  HorzScrollBar.Visible := False;
end;

procedure TNextSheet.DoCellColor(ACol, ARow: Integer;
  var CellColor: TColor; CellState: TNxCellState);
begin
  if Assigned(FOnCellColor) then FOnCellColor(Self, ACol, ARow, CellColor, CellState);
end;

function TNextSheet.GetHorzOffset(FromPos, ToPos: Integer): Integer;
var
  i: Integer;
begin
  // to-do: optimize for large steps
  Result := 0;
  if FromPos < ToPos then
  begin
    for i := FromPos to ToPos - 1 do Dec(Result, ZoomSize(Column[i].Size));
  end;
  if FromPos > ToPos then
  begin
    for i := ToPos to FromPos - 1 do Inc(Result, ZoomSize(Column[i].Size));
  end;
end;

function TNextSheet.GetKeysState: TKeysState;
begin
  Result := [];
  if 0 <> (GetKeyState(VK_SCROLL) and $01) then Include(Result, ksScrollLock);
end;

function TNextSheet.GetVertOffset(FromPos, ToPos: Integer): Integer;
var
  i: Integer;
begin
  // to-do: optimize for large steps
  Result := 0;
  if FromPos < ToPos then
  begin
    for i := FromPos to ToPos - 1 do Dec(Result, ZoomSize(Row[i].Size));
  end;
  if FromPos > ToPos then
  begin
    for i := ToPos to FromPos - 1 do Inc(Result, ZoomSize(Row[i].Size));
  end;
end;

procedure TNextSheet.DrawHeadingRect(ARect: TRect; Location: TCellLocation);
var
  Side: Integer;
begin
  with Canvas do
	case FStyle of
    stDefault:
    begin
      Frame3D(Canvas, ARect, clBtnHighlight, clBtnShadow, 1);
      Brush.Color := clBtnFace;
      FillRect(ARect);
    end;
  	stOffice2003:
    begin
      Brush.Color := cl3DLight;
      FillRect(ARect);
      Pen.Color := cl3DDkShadow;
      MoveTo(ARect.Left, ARect.Bottom - 1);
      LineTo(ARect.Right - 1, ARect.Bottom - 1);
      LineTo(ARect.Right - 1, ARect.Top - 1);
    end;
  	stOffice12:
    begin
      if Location = clCorner then Pen.Color := $00A4877D
        else Pen.Color := $00C3B1AA;
      MoveTo(ARect.Left, ARect.Bottom - 1);
      LineTo(ARect.Right - 1, ARect.Bottom - 1);
      LineTo(ARect.Right - 1, ARect.Top - 1);
      Dec(ARect.Right);
      Dec(ARect.Bottom);
      if Location = clRow then
      begin
        Brush.Color := $00F3EBE9;
        FillRect(ARect);
      end else if Location = clCorner then
      begin
        Frame3D(Canvas, ARect, $00F5EBE1, $00E6D4CA, 1);
        DrawVertGradient(Canvas, ARect, $00D0C3BB, $00BAAAA3);
        Brush.Color := $00FFFFFF;
        Pen.Color := $00FFFFFF;
        Side := (ARect.Bottom - ARect.Top) - 4;
        SetClipPoly(Canvas, [Point(ARect.Right - 3, ARect.Top + 2),
          Point(ARect.Right - Side - 2, ARect.Bottom - 2),
          Point(ARect.Right - 3, ARect.Bottom - 2)]);
        DrawVertGradient(Canvas, ARect, $00FCFBFA, $00E3D9D6);
        SetClipRect(Canvas, ClientRect);
      end else DrawVertGradient(Canvas, ARect, $00FCFBFA, $00E3D9D7);
    end;
    stOffice2007:
    begin
      Pen.Color := $00CEB69E;
      MoveTo(ARect.Left, ARect.Bottom - 1);
      LineTo(ARect.Right - 1, ARect.Bottom - 1);
      LineTo(ARect.Right - 1, ARect.Top - 1);
      Dec(ARect.Right);
      Dec(ARect.Bottom);
      if Location = clRow then
      begin
        Brush.Color := $00F7ECE4;
        FillRect(ARect);
      end else if Location = clCorner then
      begin
        Frame3D(Canvas, ARect, $00F2E4D5, $00F7CFB0, 1);
        Brush.Color := $00E9C4A9;
        FillRect(ARect);
        Brush.Color := $00FFFFFF;
        Pen.Color := $00FFFFFF;
        Side := (ARect.Bottom - ARect.Top) - 4;
        SetClipPoly(Canvas, [Point(ARect.Right - 3, ARect.Top + 2),
          Point(ARect.Right - Side - 2, ARect.Bottom - 2),
          Point(ARect.Right - 3, ARect.Bottom - 2)]);
        DrawVertGradient(Canvas, ARect, $00FCFBFA, $00E3D9D6);
        SetClipRect(Canvas, ClientRect);
      end else DrawVertGradient(Canvas, ARect, $00FDFCF9, $00E9DCD3);
    end;
  end;
end;

function TNextSheet.ReadColCount: Integer;
begin
  Result := FCells.ColCount;
end;

function TNextSheet.GetColumn(Index: Integer): TNxSheetColumn;
begin
  Result := FCells.Column[Index];
end;

function TNextSheet.GetRow(Index: Integer): TNxSheetRow;
begin
  Result := FCells.Row[Index];
end;

function TNextSheet.GetRowCount: Integer;
begin
  Result := FCells.RowCount;
end;

procedure TNextSheet.SetAppearanceOptions(
  const Value: TSheetAppearanceOptions);
begin
  FAppearanceOptions := Value;
  Invalidate;
end;

procedure TNextSheet.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  RecreateWnd;
end;

procedure TNextSheet.SetColCount(const Value: Integer);
begin
  FCells.ColCount := Value;
  CalculateHorzScrollBar;
  Invalidate;
end;

procedure TNextSheet.SetColumn(Index: Integer; const Value: TNxSheetColumn);
begin

end;

procedure TNextSheet.SetExpanding(const Value: Boolean);
begin
  if Value <> FExpanding then
  begin
    FExpanding := Value;

    { Done with expanding }
    if not FExpanding then
    begin
      with FExpansionRange do
      begin
        { Call event }
        DoAfterExpand;

        SelectCells(StartCol, StartRow, EndCol, EndRow);
      end;

      DrawExpansionRange(True, False);
      FOldExpansionRect := Bounds(0, 0, 0, 0);
      FExpansionRange := CellRange(-1, -1, -1, -1);
    end;

  end;
end;

procedure TNextSheet.SetExpandingReady(const Value: Boolean);
begin
  if Value <> FExpandingReady then
  begin
    FExpandingReady := Value;
    if FExpandingReady then
      Screen.Cursor := crSizeNWSE
    else
      Screen.Cursor := crDefault;
  end;
end;

procedure TNextSheet.SetExpansionRange(const Value: TCellsRange);
begin
  if (Value.StartCol <> FExpansionRange.StartCol)
    or (Value.StartRow <> FExpansionRange.StartRow)
    or (Value.EndCol <> FExpansionRange.EndCol)
    or (Value.EndRow <> FExpansionRange.EndRow) then
  begin
    FExpansionRange := Value;
    if FExpanding then
    begin
      DrawExpansionRange(True);

      { Call event }
      DoExpanding;
    end;
  end;
end;

procedure TNextSheet.SetFixedColWidth(const Value: Integer);
begin
  FFixedColWidth := Value;
  Invalidate;
end;

procedure TNextSheet.SetFixedRowHeight(const Value: Integer);
begin
  FFixedRowHeight := Value;
  Invalidate;
end;

procedure TNextSheet.SetOptions(const Value: TSheetOptions);
begin
  FOptions := Value;
  Invalidate;
end;

procedure TNextSheet.SetRow(Index: Integer; const Value: TNxSheetRow);
begin

end;

procedure TNextSheet.SetZoom(const Value: Integer);
begin
  if InRange(Value, 10, 400) then
  begin
    FZoom := Value;
    Invalidate;
    CalculateHorzScrollBar;
    CalculateVertScrollBar;
  end;
end;

procedure TNextSheet.SetRowCount(const Value: Integer);
begin
  FCells.RowCount := Value;
  CalculateVertScrollBar;
  Invalidate;
end;

function TNextSheet.GetSelected(ACol, ARow: Integer): Boolean;
begin
  Result := Cell[ACol, ARow].Selected or
    PtInRect(Rect(Selection.StartCol, Selection.StartRow, Selection.EndCol + 1, Selection.EndRow + 1), Point(ACol, ARow));
end;

function TNextSheet.GetSheetCount: Integer;
begin
  Result := FSheetList.Count;
end;

procedure TNextSheet.SetSheetIndex(const Value: Integer);
begin
  FSheetIndex := Value;
end;

procedure TNextSheet.SetSelected(ACol, ARow: Integer;
  const Value: Boolean);
begin

end;

procedure TNextSheet.SetSelectedCol(const Value: Integer);
begin
  if InRange(Value, 0, ColCount - 1) then FSelectedCol := Value;
  UpdateSelection(FSelectedCol, FSelectedRow);
end;

procedure TNextSheet.SetSelectedRow(const Value: Integer);
begin
  if InRange(Value, 0, RowCount - 1) then FSelectedRow := Value;
  UpdateSelection(FSelectedCol, FSelectedRow);
end;

procedure TNextSheet.SetStyle(const Value: TSheetStyle);
begin
  FStyle := Value;
  case FStyle of
    stDefault, stOffice2003: FBorderDisplay.GridLinesColor := clSilver;
    stOffice12: FBorderDisplay.GridLinesColor := $00E5D7D0;
  end;
  Invalidate;
end;

procedure TNextSheet.CalculateHorzScrollBar;
begin
	if ZoomSize(FCells.ClientWidth) > GetVisibleWidth then
  begin
    HorzScrollBar.Max := ColCount - VisibleColCount;
    HorzScrollBar.Visible := True;
  end else
  begin
    HorzScrollBar.Max := 0;
    HorzScrollBar.Visible := False;
  end;
end;

function TNextSheet.GetVisibleHeight: Integer;
begin
  if soHeadings in Options then Result := ClientHeight - ZoomSize(FFixedRowHeight)
    else Result := ClientHeight;
end;

function TNextSheet.GetVisibleWidth: Integer;
begin
  if soHeadings in Options then Result := ClientWidth - ZoomSize(FFixedColWidth)
    else Result := ClientWidth;
end;

function TNextSheet.VisibleColCount: Integer;
var
  i, w: Integer;
begin
  Result := 0;
  w := 0;
  i := HorzScrollBar.Position;
  while (i < ColCount) and (w + ZoomSize(Column[i].Size) <= GetVisibleWidth) do
  begin
    Inc(w, ZoomSize(Column[i].Size));
    Inc(i);
    Inc(Result);
  end;
end;

function TNextSheet.VisibleRowCount: Integer;
var
  i, w: Integer;
begin
  Result := 0;
  w := 0;
  i := VertScrollBar.Position;
  while (i < RowCount) and (w + ZoomSize(Row[i].Size) <= GetVisibleHeight) do
  begin
    Inc(w, ZoomSize(Row[i].Size));
    Inc(i);
    Inc(Result);
  end;
end;

procedure TNextSheet.CalculateVertScrollBar;
var
	VisibleHeight: Integer;
  function VisibleRowsCount: Integer;
	var
  	i, Pos: Integer;
  begin
    Result := 0;
    Pos := 0;
    i := VertScrollBar.Position;

    while i < RowCount do
    begin
      Inc(Pos, ZoomSize(Row[i].Size));
      if Pos > VisibleHeight then Exit;
      Inc(i);
      Inc(Result);
    end;
  end;
begin
  if soHeadings in Options
    then VisibleHeight := ClientHeight - ZoomSize(FFixedRowHeight)
    else VisibleHeight := ClientHeight;
	if ZoomSize(FCells.ClientHeight) > VisibleHeight then
  begin
    VertScrollBar.Max := RowCount - VisibleRowsCount;
    VertScrollBar.Visible := True;
  end else
  begin
    VertScrollBar.Max := 0;
    VertScrollBar.Visible := False;
  end;
end;

procedure TNextSheet.DoBorderChange(Sender: TObject; ACol, ARow: Integer;
  Position: TBorderPosition);
var
  i: Integer;
  ALineStyle: TLineStyle;
  ABorderColor: TColor;
  ARange: TCellsRange;
begin
  RefreshCell(ACol, ARow, True);
  if Cell[ACol, ARow].Active then
  begin
    Cell[ACol, ARow].GetBorder(Position, ALineStyle, ABorderColor);
    ARange := GetCellRange(ACol, ARow);

    case Position of
      bpsBottom:
        for i := ARange.StartCol to ARange.EndCol do
          if (i <> ACol) or (ARange.EndRow <> ARow) then
            Cell[i, ARange.EndRow].SetBorder(Position, ALineStyle, ABorderColor);

      bpsLeft:
        for i := ARange.StartRow to ARange.EndRow do
          if (ARange.StartCol <> ACol) or (i <> ARow) then
            Cell[ARange.StartCol, i].SetBorder(Position, ALineStyle, ABorderColor);

      bpsRight:
        for i := ARange.StartRow to ARange.EndRow do
          if (ARange.EndCol <> ACol) or (i <> ARow) then
            Cell[ARange.EndCol, i].SetBorder(Position, ALineStyle, ABorderColor);

      bpsTop:
        for i := ARange.StartCol to ARange.EndCol do
          if (i <> ACol) or (ARange.StartRow <> ARow) then
            Cell[i, ARange.StartRow].SetBorder(Position, ALineStyle, ABorderColor);
    end;
  end;
end;

procedure TNextSheet.DoCellChange(Sender: TObject; ACol, ARow: Integer);
begin
  RefreshCell(ACol, ARow, True);
end;                                   

procedure TNextSheet.DoCellValueChange(Sender: TObject; ACol, ARow: Integer;
  var Value: WideString);
begin
  if soAutoCellKind in FOptions then
  begin
    case GetDataKind(Value) of
      dkString: Cell[ACol, ARow].Kind := ckGeneral;
      dkFloat, dkInteger: Cell[ACol, ARow].Kind := ckNumber;
    end;
  end;
  if soAutoCalculation in FOptions then CalculateSheet;
  DoChange(ACol, ARow, Value); { event }
  RefreshCell(ACol, ARow, True);
end;

procedure TNextSheet.DoChange(ACol, ARow: Integer; Text: WideString);
begin
  if Assigned(FOnChange) then FOnChange(Self, ACol, ARow, Text);
end;

procedure TNextSheet.DoColumnChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNextSheet.DoColumnResize(Sender: TObject;
	OldSize, NewSize: Integer);
begin
  CalculateHorzScrollBar;
  Invalidate;
end;

procedure TNextSheet.DblClick;
begin
  inherited;

end;

procedure TNextSheet.DoAfterEdit(ACol, ARow: Integer; var Accept: Boolean;
  var Text: WideString);
begin
  if Assigned(FOnAfterEdit) then FOnAfterEdit(Self, ACol, ARow, Accept, Text);
end;

procedure TNextSheet.DoAfterExpand;
begin
  if Assigned(FOnAfterExpand) then FOnAfterExpand(Self);
end;

procedure TNextSheet.DoBeforeEdit(ACol, ARow: Integer;
  var CanEdit: Boolean; var Text: WideString);
begin
  if Assigned(FOnBeforeEdit) then FOnBeforeEdit(Self, ACol, ARow, CanEdit, Text);
end;

procedure TNextSheet.DoBeforeExpand(var Accept: Boolean);
begin
  if Assigned(FOnBeforeExpand) then FOnBeforeExpand(Self, Accept);
end;

procedure TNextSheet.DoEnter;
begin
  inherited;
  Invalidate;
end;

procedure TNextSheet.DoExit;
begin
  inherited;
  Invalidate;
end;

procedure TNextSheet.DoExpanding;
begin
  if Assigned(FOnExpanding) then FOnExpanding(Self);
end;

function TNextSheet.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := False;
  inherited DoMouseWheelDown(Shift, MousePos);
  if VertScrollBar.Visible then VertScrollBar.Next else HorzScrollBar.Next;
end;

function TNextSheet.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := False;
  inherited DoMouseWheelUp(Shift, MousePos);
  if VertScrollBar.Visible then VertScrollBar.Prior else HorzScrollBar.Prior;
end;

procedure TNextSheet.DoRowChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TNextSheet.DoRowResize(Sender: TObject; OldSize,
  NewSize: Integer);
begin
  CalculateVertScrollBar;
  Invalidate;
end;

procedure TNextSheet.DoSelectCell(ACol, ARow: Integer);
begin
  if Assigned(FOnSelectCell) then FOnSelectCell(Self, ACol, ARow);
end;

procedure TNextSheet.DrawCell(ACol, ARow: Integer; CellRect: TRect);
var
  DrawRect, TxtRect, UpdRect: TRect;
  AText: WideString;
  CellColor: TColor;
  CellState: TNxCellState;
begin
  CellState := [];
  with Canvas do
  begin
    DrawRect := CellRect;

    GetClipBox(Canvas.Handle, UpdRect);

    if (DrawRect.Right < UpdRect.Left) or (DrawRect.Left > UpdRect.Right)
  		or (DrawRect.Bottom < UpdRect.Top) or (DrawRect.Top > UpdRect.Bottom) then Exit;

    CellColor := Cell[ACol, ARow].Color;

    if CellColor = clNone then CellColor := Self.Color;
  	if (Selected[ACol, ARow]) and ((ACol <> SelectedCol) or (ARow <> SelectedRow))
    	then
    begin
      CellColor := TGraphicsProvider.BlendColor(Brush.Color, clHighlight, 167);
      Include(CellState, csSelected);
    end;

    Pen.Color := Brush.Color;

    if not IsRectVisible(DrawRect) then Exit;

    if Cell[ACol, ARow].Color <> clNone then
    begin
      Dec(DrawRect.Left);
      Dec(DrawRect.Top);
    end;

    SetClipRect(Canvas, GetBodyRect);

    DoCellColor(ACol, ARow, CellColor, CellState);

    Brush.Color := CellColor;
    FillRect(DrawRect);
    with Canvas do
    begin
      SetCellFont(ACol, ARow, Font);
      Font.Size := ZoomSize(Font.Size);
    end;

    TxtRect := DrawRect;

    if soShowContent in FOptions
      then AText := Cell[ACol, ARow].Text
      else AText := Cell[ACol, ARow].DisplayText;

    InflateRect(TxtRect, -2, -1);

    if Cell[ACol, ARow].Angle = 0 then
    begin
      TGraphicsProvider.DrawWrapedTextRect(Canvas, TxtRect,
        GetAlignment(Cell[ACol, ARow].Alignment),
        GetVerticalAlignment(Cell[ACol, ARow].Alignment),
        Cell[ACol, ARow].MultiLine, AText, BidiMode);
    end else
    begin
      DrawAngledText(Canvas, TxtRect, AText, Cell[ACol, ARow].Angle);
    end;

    if apIndicateCalculated in FAppearanceOptions then
    begin
      if cstCalculated in Cell[ACol, ARow].State then
      begin
        Brush.Color := clBlue;
        Pen.Color := clBlue;
        Polygon([
          Point(DrawRect.Right - 1, DrawRect.Bottom - 7),
          Point(DrawRect.Right - 1, DrawRect.Bottom - 1),
          Point(DrawRect.Right - 7, DrawRect.Bottom - 1),
          Point(DrawRect.Right - 1, DrawRect.Bottom - 7)
        ]);
      end;
    end;

    SetClipRect(Canvas, ClientRect);
  end;
end;

procedure TNextSheet.DrawCellBorder(ACol, ARow: Integer; CellRect: TRect);
var
  DrawRect: TRect;
  DrawBottom, DrawRight: Boolean;

  function CellBottomClear: Boolean;
  begin
    Result := True;
    if ARow < RowCount - 1 then
    begin
      if Cell[ACol, ARow + 1].Active then Result := Cell[ACol, ARow + 1].Color = clNone
        else Result := Cell[ACol, ARow + 1].DockCell.Color = clNone;
    end;
  end;

  function CellRightClear: Boolean;
  begin
    Result := True;
    if ACol < ColCount - 1 then
    begin
      if Cell[ACol + 1, ARow].Active then Result := Cell[ACol + 1, ARow].Color = clNone
        else Result := Cell[ACol + 1, ARow].DockCell.Color = clNone;
    end;
  end;

  function CellRightMerged: Boolean;
  begin
    Result := False;
    if ACol < ColCount - 1 then
    begin
      Result := not Cell[ACol + 1, ARow].Active
        and not (Cell[ACol, ARow].DockCell <> Cell[ACol + 1, ARow].DockCell)
    end;
  end;

  function CellBottomMerged: Boolean;
  begin
    Result := False;
    if ARow < RowCount - 1 then
    begin
      Result := not Cell[ACol, ARow + 1].Active
        and not (Cell[ACol, ARow].DockCell <> Cell[ACol, ARow + 1].DockCell)
    end;
  end;

begin
  SetClipRect(Canvas, GetBodyRect);
  DrawRect := CellRect;

  case Cell[ACol, ARow].BorderTop.LineStyle of
    lsDouble, lsWeightSolid: DrawRect.Top := DrawRect.Top + 1;
  end;

  case Cell[ACol, ARow].BorderLeft.LineStyle of
    lsDouble, lsWeightSolid: DrawRect.Left := DrawRect.Left + 1;
  end;

  DrawBottom := (Cell[ACol, ARow].Color = clNone) and CellBottomClear;
  DrawBottom := DrawBottom or (Cell[ACol, ARow].BorderBottom.Color <> clNone);
  DrawBottom := DrawBottom and not CellBottomMerged;
  DrawBottom := DrawBottom and ((Cell[ACol, ARow].BorderBottom.Color <> clNone) or (soGridLines in FOptions));

  DrawRight := (Cell[ACol, ARow].Color = clNone) and CellRightClear;
  DrawRight := DrawRight or (Cell[ACol, ARow].BorderRight.Color <> clNone);
  DrawRight := DrawRight and not CellRightMerged;
  DrawRight := DrawRight and ((Cell[ACol, ARow].BorderRight.Color <> clNone) or (soGridLines in FOptions));

  if DrawRight then FBorderDisplay.Draw(Cell[ACol, ARow].BorderRight, CellRect, bpsRight);
  if DrawBottom then FBorderDisplay.Draw(Cell[ACol, ARow].BorderBottom, CellRect, bpsBottom);

  SetClipRect(Canvas, ClientRect);
end;

procedure TNextSheet.DrawDotsBackground;
var
  Bmp: TBitmap;
  P: PByte;
  Y, X: Integer;
  s, Ind, Row: Byte;
  V: Double;
  R, G, B, R1, G1, B1, R2, G2, B2: Byte;
begin
  Bmp := TBitmap.Create;
  Bmp.PixelFormat := pf24bit;
  Bmp.Width := ClientWidth;
  Bmp.Height := ClientHeight;
  s := 1;
  Row := 1;
  Ind := 0;
  R1 := $93;
  G1 := $9B;
  B1 := $B2;
  R2 := $DA;
  G2 := $DE;
  B2 := $E7;
  for Y := 0 to Bmp.Height - 1 do
  begin
    P := Bmp.ScanLine[Y];
    V := Y / Bmp.Height;
  	R := Round(V * $8C + (1 - V) * $C2);
  	G := Round(V * $96 + (1 - V) * $C8);
  	B := Round(V * $AC + (1 - V) * $D7);
    for X := 0 to Bmp.Width - 1 do
    begin
      if s = 0 then
      begin
        s := 3;
        if Row = 0 then
        begin
          P^ := B1;
          Inc(P);
          P^ := G1;
          Inc(P);
          P^ := R1;
          Inc(P);
        end else
        begin
          P^ := B2;
          Inc(P);
          P^ := G2;
          Inc(P);
          P^ := R2;
          Inc(P);
        end;
      end else
      begin
        P^ := B;
        Inc(P);
        P^ := G;
        Inc(P);
        P^ := R;
        Inc(P);
        Dec(s);
      end;
    end;
    if Row = 0 then Row := 1 else
    begin
      Row := 0;     
      if Ind = 3 then Ind := 1 else Ind := 3;
    end;
    s := Ind;
  end;
  Canvas.Draw(0, 0, Bmp);
  Bmp.Free;
end;

procedure TNextSheet.DrawExpansionRange(Erase: Boolean; DoDraw: Boolean);
begin
  with Canvas do
  begin
    SetClipRect(Canvas, GetBodyRect);
    Brush.Style := bsClear;
    Pen.Width := 3;
    Pen.Mode := pmNot;

    if Erase then Rectangle(FOldExpansionRect);
    FOldExpansionRect := GetExpansionRect;
    if DoDraw then Rectangle(FOldExpansionRect);

    { Reset back }
    Pen.Width := 1;
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
    SetClipRect(Canvas, ClientRect);
  end;
end;

procedure TNextSheet.DrawFixedCell(CellRect: TRect; Text: string;
  Location: TCellLocation);
begin
  DrawHeadingRect(CellRect, Location);
  with Canvas do
  begin
    Font.Assign(Self.Font);
    Font.Size := ZoomSize(Font.Size);
    NxSharedCommon.DrawTextRect(Canvas, CellRect, taCenter, Text);
  end;
end;

procedure TNextSheet.DrawRangeSelection(Erase: Boolean = False);
begin
  with Canvas do
  begin
    SetClipRect(Canvas, GetBodyRect);
    Brush.Style := bsClear;
    Pen.Width := 2;
    Pen.Mode := pmNot;
    if Erase then Rectangle(FOldSelectionRect);
    FOldSelectionRect := GetSelectionRect;
    Rectangle(FOldSelectionRect);
    Pen.Width := 1;
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
    SetClipRect(Canvas, ClientRect);

    { Square at the right-bottom edge }
    if soSelectionExpandHandle in Options then DrawSelectionHandle;
  end;
end;

procedure TNextSheet.DrawSelectionHandle;
begin
  with Canvas do
  begin
    Pen.Color := clWhite;
    Brush.Color := clBlack;
    Rectangle(SelectionHandleRect);
  end;
end;

function TNextSheet.GetBodyRect: TRect;
var
	LeftIndent, TopIndent: Integer;
begin
  if soHeadings in Options then
  begin
    with GetFixedSize do
    begin
      LeftIndent := cx;
      TopIndent := cy;
    end;
  end else
  begin
    LeftIndent := 0;
    TopIndent := 0;
  end;
  Result := Rect(LeftIndent, TopIndent, ClientWidth, ClientHeight);
end;

function TNextSheet.GetCellLeft(ACol: Integer): Integer;
var
 	I: Integer;
begin
	if soHeadings in Options then Result := GetFixedSize.cx else Result := 0;
  if ACol >= HorzScrollBar.Position then
  begin
    for I := HorzScrollBar.Position to ACol - 1 do
      Inc(Result, Column[i].Size * FZoom div 100)
  end else
  begin
  	for I := ACol to HorzScrollBar.Position - 1 do
      Dec(Result, Column[i].Size * FZoom div 100);
  end;
end;

function TNextSheet.GetCellTextWidth(ACol, ARow: Integer;
  S: WideString): Integer;
var
  W, i: Integer;
begin
  W := GetTextWidth(Canvas, S);
  Result := Column[ACol].Size;
  if ACol < Pred(ColCount) then
  begin
    i := ACol + 1;
    while (Result < W) and (i < ColCount) do
    begin
      Inc(Result, Column[i].Size);
      Inc(i);
    end;
  end;
end;

function TNextSheet.GetCellTop(ARow: Integer): Integer;
var
 	i: Integer;
begin
	if soHeadings in Options then Result := GetFixedSize.cy else Result := 0;

  if ARow >= VertScrollBar.Position then
  begin
    for i := VertScrollBar.Position to ARow - 1 do
      Inc(Result, Row[i].Size * FZoom div 100)
  end else
  begin
  	for i := ARow to VertScrollBar.Position - 1 do
      Dec(Result, Row[i].Size * FZoom div 100);
  end;
end;

function TNextSheet.GetFixedSize: TSize;
begin
  with Result do
  begin
    cx := FFixedColWidth * Zoom div 100;
    cy := FFixedRowHeight * Zoom div 100;
  end;
end;

function TNextSheet.GetSelectionHandleRect: TRect;
begin
  with GetSelectionRect do
  begin
    Result := Bounds(Right - 3, Bottom - 3, 5, 5);
  end;
end;

function TNextSheet.GetSelectionRect: TRect;
var
  EndCol, EndRow: Integer;
begin
  if Selection.EndCol > Pred(ColCount) then EndCol := Pred(ColCount) else EndCol := Selection.EndCol;
  if Selection.EndRow > Pred(RowCount) then EndRow := Pred(RowCount) else EndRow := Selection.EndRow;
	with Result do
  begin
    Left := GetCellLeft(Selection.StartCol);
    Top := GetCellTop(Selection.StartRow);
    Right := GetCellLeft(EndCol) + ZoomSize(Column[EndCol].Size);
    Bottom := GetCellTop(EndRow) + ZoomSize(Row[EndRow].Size);
  end;
end;

function TNextSheet.GetSheetRect: TRect;
var
  i, X, Y, cw, ch: Integer;
begin
  X := 0;
  Y := 0;
  if soHeadings in FOptions then
  begin
    with GetFixedSize do
    begin
      X := cx;
      Y := cy;
    end;
  end;
  for i := HorzScrollBar.Position to ColCount - 1 do
  begin
    if stResizingColumn in FSheetState then cw := Column[i].SizingSize else cw := Column[i].Size;
    Inc(X, ZoomSize(cw));
    if X > ClientWidth then Break;
  end;
  for i := VertScrollBar.Position to RowCount - 1 do
  begin
    if stResizingRow in FSheetState then ch := Row[i].SizingSize else ch := Row[i].Size;

    Inc(Y, ZoomSize(ch));
    if Y > ClientHeight then Break;
  end;
  Result := Rect(0, 0, X, Y);
end;

function TNextSheet.IsRectVisible(Rect: TRect): Boolean;
var
	UpdRect: TRect;
begin
  GetClipBox(Canvas.Handle, UpdRect);
  Result := not((Rect.Right < UpdRect.Left) or (Rect.Left > UpdRect.Right)
		or (Rect.Bottom < UpdRect.Top) or (Rect.Top > UpdRect.Bottom));
end;

function TNextSheet.IsRowInView(Index: Integer): Boolean;
begin
  Result := (Index > VertScrollBar.Position) and (Index < VertScrollBar.Position + VisibleRowCount);
end;

function TNextSheet.IsCellInView(Cell: TNxCell): Boolean;
begin
  Result := (Cell.Col >= HorzScrollBar.Position)
    and (Cell.Row > VertScrollBar.Position)
    and (Cell.Col < HorzScrollBar.Position + VisibleColCount)
    and (Cell.Row < VertScrollBar.Position + VisibleRowCount);
end;

function TNextSheet.IsColInView(Index: Integer): Boolean;
begin
  Result := (Index > HorzScrollBar.Position) and (Index < HorzScrollBar.Position + VisibleColCount);
end;

function TNextSheet.ZoomSize(const Value: Integer): Integer;
begin
  Result := Value * Zoom div 100;
end;

function TNextSheet.UnzoomSize(const Value: Integer): Integer;
begin
  Result := Value;// div Zoom * 100;
end;

procedure TNextSheet.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (soClipboard in FOptions) then
  begin
    if Chr(Key) = 'C' then CopyToClipBoard;
    if (soEditing in FOptions) then
    begin
      if Chr(Key) = 'X' then CutToClipBoard;
      if Chr(Key) = 'V' then PasteFromClipBoard;
    end;
  end;
  if stEditing in FSheetState then
  begin
    case Key of
      VK_RETURN:
      begin
        CancelEdit;
        MoveSelection;
      end;
      VK_ESCAPE: CancelEdit(False);
      else FInplaceEdit.KeyDown(Key, Shift);
    end;
  end else
  begin
    if Key = VK_DELETE then
    begin
      if soEditing in FOptions then
        Erase(Selection.StartCol, Selection.StartRow, Selection.EndCol, Selection.EndRow);
    end;
    if ksScrollLock in GetKeysState then
    begin
      case Key of
        VK_RETURN: if FWantReturns then MoveSelection;
        VK_LEFT: HorzScrollBar.Prior;
        VK_RIGHT: HorzScrollBar.Next;
        VK_UP: VertScrollBar.Prior;
        VK_DOWN: VertScrollBar.Next;
      end;
    end else
    begin
      case Key of
        VK_RETURN: if FWantReturns then MoveSelection;
        VK_UP: MoveSelectionUp;
        VK_DOWN: MoveSelectionDown;
        VK_LEFT: MoveSelectionLeft;
        VK_RIGHT: MoveSelectionRight;
        VK_HOME:
          begin
            SelectCells(0, Selection.StartRow, 0, Selection.StartRow);
            SelectedCol := 0;
          end;
      end;
    end;
  end;
end;

procedure TNextSheet.KeyPress(var Key: Char);
begin
  inherited;
  if soEditing in Options then
  begin
    if Key in [#0, #3, #8, #9, #13, #22, #24, #27] then Exit;
    if stEditing in FSheetState then FInplaceEdit.KeyPress(Key)
      else EditCell(SelectedCol, SelectedRow, Key);
  end;
end;

procedure TNextSheet.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  ACol, ARow: Integer;
  AcceptExpand: Boolean;
begin
  inherited;

  if not Focused then TryFocus;

  if Button = mbLeft then
  begin
    FMouseDown := True;

    { Pointer is inside Selection Handle }
    if ExpandingReady then
    begin
      AcceptExpand := True;

      DoBeforeExpand(AcceptExpand);

      if AcceptExpand then
      begin
        ExpansionRange := Selection;
        Expanding := True;
      end else
      begin
        { Cancel mouse press }
        FMouseDown := False;
        Beep;
      end;

      Exit;
    end;

    if soResizing in FOptions then
    begin
      FResizingCol := GetColumnGripAtPos(X, Y);
      if FResizingCol <> -1 then
      begin
        Include(FSheetState, stResizingColumn);
        Exit;
      end;

      FResizingRow := GetRowGripAtPos(X, Y);
      if FResizingRow <> -1 then
      begin
        Include(FSheetState, stResizingRow);
        Exit;
      end;
    end;

    ACol := GetColumnAtPos(X);
    ARow := GetRowAtPos(Y);

    if ssCtrl in Shift then Include(FSheetState, stCtrlSelection)
      else Exclude(FSheetState, stCtrlSelection);

    if CellBounds(ACol, ARow) and not(stCtrlSelection in FSheetState) then Deselect;

    if stEditing in FSheetState then
    begin
      if not PtInRect(FEditRect, Point(X, Y)) then CancelEdit else
      begin
        FInplaceEdit.MouseDown(Button, Shift, X, Y);
        Exit;
      end;
    end;

    if CellBounds(ACol, ARow) then
    begin
      if Cell[ACol, ARow].Active then FSelectedCell := Cell[ACol, ARow] else
      begin
        FSelectedCell := Cell[ACol, ARow].DockCell;
        with FSelectedCell do
        begin
          ACol := Col;
          ARow := Row;
        end;
      end;
    end else Exit;

    if (SelectedCol <> ACol) or (SelectedRow <> ARow) then
    begin
      if CellBounds(SelectedCol, SelectedRow) then RefreshCell(SelectedCol, SelectedRow, True);
      SelectedCol := ACol;
      SelectedRow := ARow;
      if CellBounds(SelectedCol, SelectedRow) then RefreshCell(SelectedCol, SelectedRow, True);
      if CellBounds(ACol, ARow) then
      begin
        SelectCells(ACol, ARow, ACol, ARow);
        Cell[ACol, ARow].Selected := True;
        DoSelectCell(ACol, ARow);
      end;
    end;
    DrawRangeSelection(True);

    if (ssDouble in Shift) and (soEditing in FOptions) then
    begin
      if (stEditing in FSheetState) and
        (ACol = FEditCol) and (ARow = FEditRow) then
      begin
        FInplaceEdit.SelectAll;
      end else
      begin
        EditCell(ACol, ARow, Cell[ACol, ARow].Text);
        FInplaceEdit.MouseDown(Button, Shift, X, Y);
      end;
    end;
  end;
end;

procedure TNextSheet.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  FOldSelection, AExpansionRange: TCellsRange;
	ACell: TNxCell;
  ACol, ARow, ASizeCol, ASizeRow, ColLeft, RowTop, Delta: Integer;
  ExpandReadyRect: TRect;
begin
  inherited;

  if (not FMouseDown) and not (stEditing in FSheetState) then
    if soSelectionExpandHandle in Options then
    begin
      ExpandReadyRect := SelectionHandleRect;
      InflateRect(ExpandReadyRect, 2, 2);
      ExpandingReady := PtInRect(ExpandReadyRect, Point(X, Y));

      if ExpandingReady then Exit;
    end;

  { Selection Handle is being drag }
  if Expanding then
  begin
    AExpansionRange := ExpansionRange;
    with AExpansionRange do
    begin
      EndCol := GetColumnAtPos(X);
      EndRow := GetRowAtPos(Y);

      { Check bounds }
      if CellBounds(EndCol, EndRow) then
      begin
        ExpansionRange := AExpansionRange;
      end;
    end;

    { Stop everything else }
    Exit;
  end;

  ACol := GetColumnAtPos(X);
  ARow := GetRowAtPos(Y);
  if stResizingColumn in FSheetState then
  begin
    ColLeft := GetCellLeft(FResizingCol);
    Delta := X - ColLeft;
    Column[FResizingCol].SizingSize := Delta;
    RefreshFixedRow;
    Exit;
  end;
  if stResizingRow in FSheetState then
  begin
    RowTop := GetCellTop(FResizingRow);
    Delta := Y - RowTop;
    Row[FResizingRow].SizingSize := Delta;
    RefreshFixedColumn;     
    Exit;
  end;
  if stEditing in FSheetState then
  begin
    if PtInRect(FEditRect, Point(X, Y)) then Screen.Cursor := crIBeam
      else Screen.Cursor := crDefault;
  end else
  begin
    ASizeCol := GetColumnGripAtPos(X, Y);
    if ASizeCol <> -1 then
    begin
      Screen.Cursor := crResizeCol;
      Exit;
    end;

    ASizeRow := GetRowGripAtPos(X, Y);
    if ASizeRow <> -1 then
    begin
      Screen.Cursor := crResizeRow;
      Exit;
    end;

    if PtInRect(GetBodyRect, Point(X, Y)) then Screen.Cursor := crSelectCell
      else Screen.Cursor := crDefault;
    if (ACol >= 0) and (ACol < ColCount) and (ARow >= 0) and (ARow < RowCount)
      then ACell := Cell[ACol, ARow] else Exit;

    { Select range }
    if FMouseDown then
      if (ACell <> FOldMouseOverCell) then
    	begin
        FOldMouseOverCell := ACell;
        FOldSelection := FSelection;

  	    SelectCells(FSelectedCol, FSelectedRow, ACol, ARow);

        if (FSelectedCol <> ACol) and (FSelectedRow <> ARow)
          then Include(FSheetState, stShiftSelection)
          else Exclude(FSheetState, stShiftSelection);

        if not SameRange(FOldSelection, FSelection) then
        begin
          RefreshRange(FOldSelection);
          RefreshSelectionRect;

          DrawRangeSelection(True);
        end;
  	  end;
  end;
  if stEditing in FSheetState then FInplaceEdit.MouseMove(Shift, X, Y);
end;

procedure TNextSheet.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FMouseDown := False;
  Expanding := False;

  if stResizingColumn in FSheetState then
  begin
    if Column[FResizingCol].SizingSize < 0 then Column[FResizingCol].SizingSize := 0;
    Column[FResizingCol].Size := Column[FResizingCol].SizingSize;
  end;

  if stResizingRow in FSheetState then
  begin
    if Row[FResizingRow].SizingSize < 0 then Row[FResizingRow].SizingSize := 0;
    Row[FResizingRow].Size := Row[FResizingRow].SizingSize;
  end;

  FSheetState := FSheetState - [stResizingColumn, stResizingRow];
  if stEditing in FSheetState then FInplaceEdit.MouseUp(Button, Shift, X, Y);
end;

procedure TNextSheet.Paint;
var
  r: TRect;
begin
  inherited;
  r := GetSheetRect;
  ExcludeClipRect(Canvas.Handle, r.Left, r.Top, r.Right, r.Bottom);
  PaintBackground;
  SetClipRect(Canvas, ClientRect);

  if soHeadings in FOptions
    then PaintHeadings;
  if (ColCount > 0) and (RowCount > 0) then
  begin
    PaintCells;
    FDrawingList.Clear;
  	if Enabled then DrawRangeSelection;
    if stEditing in FSheetState
      then FInplaceEdit.Paint;
  end;
end;

procedure TNextSheet.PaintBackground;
begin
  with Canvas do
  begin
    case FStyle of
      stDefault, stOffice2003: begin
        Brush.Color := clSilver;
        FillRect(ClientRect);
      end;
      stOffice12: DrawDotsBackground(ClientRect);
      stOffice2007:
      begin
        Brush.Color := $00EBC3A4;
        FillRect(ClientRect);
      end;
    end;
  end;
end;

procedure TNextSheet.PaintCells;
var
  i, j, cw, ch, s, X, Y: Integer;
  CellRect: TRect;
  DockCell: TNxCell;
begin
  if soHeadings in FOptions then
  begin
    with GetFixedSize do
    begin
      s := cx;
      X := s;
      Y := cy;
    end;
  end else
  begin
    s := 0;
    X := 0;
    Y := 0;
  end;

  for i := VertScrollBar.Position to RowCount - 1 do
  begin
    for j := HorzScrollBar.Position to ColCount - 1 do
    begin
      if Cell[j, i].Active then
      begin
        cw := ZoomSize(GetCellWidth(j, i));
        ch := ZoomSize(GetCellHeight(j, i));
        CellRect := Rect(X, Y, X + cw, Y + ch);
        DrawCell(j, i, CellRect);
      end else
      begin
        { Cell is not active but it
          have dock cell }
        DockCell := Cell[j, i].DockCell;
        if FDrawingList.IndexOf(DockCell) = -1 then
        begin
          CellRect :=GetCellRect(DockCell.Col, DockCell.Row);
          if not IsCellInView(DockCell) then DrawCell(DockCell.Col, DockCell.Row, CellRect);
          FDrawingList.Add(DockCell);
        end;
      end;

      Inc(X, ZoomSize(Column[j].Size));
      if X > ClientWidth then Break;
    end;
    Inc(Y, ZoomSize(Row[i].Size));
    if soHeadings in FOptions then X := s else X := 0;
    if Y > ClientHeight then Break;
  end;

  if soHeadings in FOptions then
  begin
    with GetFixedSize do
    begin
      s := cx;
      X := s;
      Y := cy;
    end;
  end else
  begin
    s := 0;
    X := 0;
    Y := 0;
  end;

  for i := VertScrollBar.Position to RowCount - 1 do
  begin
    for j := HorzScrollBar.Position to ColCount - 1 do
    begin
      cw := ZoomSize(Column[j].Size);
      ch := ZoomSize(Row[i].Size);

      CellRect := Rect(X, Y, X + cw, Y + ch);

      DrawCellBorder(j, i, CellRect);

      Inc(X, ZoomSize(Column[j].Size));
      if X > ClientWidth then Break;
    end;
    Inc(Y, ZoomSize(Row[i].Size));
    if soHeadings in FOptions then X := s else X := 0;
    if Y > ClientHeight then Break;
  end;
end;

procedure TNextSheet.PaintHeadings;
var
  i, cw, rh, X, Y: Integer;
  HeadingRect: TRect;
  ct: string;
begin
  with GetFixedSize do
  begin
    DrawHeadingRect(Rect(0, 0, cx, cy), clCorner);
    X := cx;
    for i := HorzScrollBar.Position to ColCount - 1 do
    begin
      if stResizingColumn in FSheetState
        then cw := ZoomSize(Column[i].SizingSize)
        else cw := ZoomSize(Column[i].Size);
      HeadingRect := Rect(X, 0, X + cw, cy);
      if Column[i].Caption = ''
        then ct := GetColumnAddress(i)
        else ct := Column[i].Caption;
      {$IFDEF NX_DEBUG}
      ct := IntToStr(Column[i].Index);
      {$ENDIF}
      DrawFixedCell(HeadingRect, ct, clColumn);
      Inc(X, cw);
      if X > ClientWidth then Break;
    end;
    Y := cy;
    for i := VertScrollBar.Position to RowCount - 1 do
    begin
      if stResizingRow in FSheetState
        then rh := ZoomSize(Row[i].SizingSize)
        else rh := ZoomSize(Row[i].Size);
      HeadingRect := Rect(0, Y, cx, Y + rh);
      if Row[i].Caption = ''
        then ct := IntToStr(i + 1)
        else ct := Row[i].Caption;
      {$IFDEF NX_DEBUG}
      ct := IntToStr(Row[i].Index);
      {$ENDIF}
      DrawFixedCell(HeadingRect, ct, clRow);
      Inc(Y, rh);
      if Y > ClientHeight then Break;
    end;
  end;
end;

procedure TNextSheet.RefreshColumn(Index: Integer);
var
	r: TRect;
  l: Integer;
begin
	l := GetCellLeft(Index);
	r := Rect(l, 0, l + Column[Index].Size, ClientHeight);
  InvalidateRect(Handle, @r, False);
end;

procedure TNextSheet.RefreshFixedColumn;
var
  R: TRect;
begin
  with GetFixedSize do
  begin
    R := Rect(0, cy, cx, ClientHeight);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TNextSheet.RefreshFixedRow;
var
  R: TRect;
begin
  with GetFixedSize do
  begin
    R := Rect(cx, 0, ClientWidth, cy);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TNextSheet.RefreshRange(ARange: TCellsRange);
var
  r: TRect;
begin
	with r do
  begin
    Left := GetCellLeft(ARange.StartCol);
    Top := GetCellTop(ARange.StartRow);
    Right := GetCellLeft(ARange.EndCol) + ZoomSize(Column[ARange.EndCol].Size);
    Bottom := GetCellTop(ARange.EndRow) + ZoomSize(Row[ARange.EndRow].Size);
  end;
  InflateRect(r, 1, 1);
  InvalidateRect(Handle, @r, False);
end;

procedure TNextSheet.RefreshSelectionRect;
var
	r: TRect;
begin
	r := GetSelectionRect;
  InflateRect(r, 1, 1);
  InvalidateRect(Handle, @r, False);
end;

procedure TNextSheet.ScrollColumns(FromPos, ToPos: Integer);
var
  i, Delta: Integer;
  RepaintRect: TRect;
begin
  Delta := 0;
  if FromPos > ToPos then for i := ToPos to FromPos - 1 do Inc(Delta, Column[i].Size);
  if FromPos < ToPos then for i := FromPos to ToPos - 1 do Dec(Delta, Column[i].Size);
  RepaintRect := ClientRect;
  if soHeadings in Options then RepaintRect.Left := FixedColWidth;
  ScrollWindowEx(Handle, Delta, 0, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
end;

procedure TNextSheet.ScrollRows(FromPos, ToPos: Integer);
var
  i, Delta: Integer;
  RepaintRect: TRect;
begin
  Delta := 0;
  if FromPos > ToPos then for i := ToPos to FromPos - 1 do Inc(Delta, Row[i].Size);
  if FromPos < ToPos then for i := FromPos to ToPos - 1 do Dec(Delta, Row[i].Size);
  RepaintRect := ClientRect;
  if soHeadings in Options then RepaintRect.Top := FixedRowHeight;
  ScrollWindowEx(Handle, 0, Delta, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
end;

procedure TNextSheet.ScrollToSelected;
begin
  if not IsColInView(SelectedCol)
    or First then HorzScrollBar.Position := SelectedCol;

  if not IsRowInView(SelectedRow)
    or First then VertScrollBar.Position := SelectedRow;
end;

procedure TNextSheet.SetCellBorders(X, Y: Integer);
begin

end;

procedure TNextSheet.SetCellFont(ACol, ARow: Integer; Font: TFont);
begin
  if Cell[ACol, ARow].Modified
    then Font.Assign(Cell[ACol, ARow].Font)
    else Font.Assign(Self.Font);
end;

procedure TNextSheet.UpdateSelection(X, Y: Integer);
begin
  FSelection.StartCol := X;
  FSelection.StartRow := Y;
  FSelection.EndCol := X;
  FSelection.EndRow := Y;
end;

procedure TNextSheet.RefreshRow(Index: Integer);
var
	r: TRect;
  t: Integer;
begin
	t := GetCellTop(Index);
	r := Rect(0, t, ClientWidth, t + Row[Index].Size);
  InvalidateRect(Handle, @r, False);
end;

procedure TNextSheet.CMMouseLeave(var Message: TMessage);
begin
	inherited;
  Screen.Cursor := crDefault;
end;

procedure TNextSheet.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTARROWS;
end;

procedure TNextSheet.WMSize(var Message: TWMSize);
begin
  inherited;
  SetScrollClipRect;
  CalculateHorzScrollBar;
  CalculateVertScrollBar;
end;

procedure TNextSheet.WMHScroll(var Message: TWMHScroll);
begin
	inherited;
  CalculateHorzScrollBar;
end;

procedure TNextSheet.WMVScroll(var Message: TWMVScroll);
begin
	inherited;
  CalculateVertScrollBar;
end;

procedure TNextSheet.AddColumn(Count: Integer);
begin
  FCells.AddColumn(Count);
  CalculateHorzScrollBar;
  RefreshColumn(ColCount - 1);
end;

procedure TNextSheet.AddRow(Count: Integer);
begin
  if Count = 0 then Exit;
  FCells.AddRow(Count);
  CalculateVertScrollBar;
  Invalidate;
end;

procedure TNextSheet.AssignColor(FromCol, FromRow, ToCol, ToRow: Integer;
  const Color: TColor);
var
	i, j: Integer;
begin
	for i := FromRow to ToRow do
  	for j	:= FromCol to ToCol do
    	Cell[j, i].Color := Color;
end;

procedure TNextSheet.CancelEdit(Apply: Boolean = True);
var
  Accept: Boolean;
  EditText: WideString;
  RepaintRect: TRect;
begin
  Exclude(FSheetState, stEditing);
  if Apply then
  begin
    Accept := True;
    EditText := FInplaceEdit.Text;
    DoAfterEdit(FEditCol, FEditRow, Accept, EditText);
    if Accept then Cell[FEditCol, FEditRow].Text := EditText;
  end;
  RepaintRect := FEditRect;
  RepaintRect.Right := RepaintRect.Left + Canvas.TextWidth(EditText) + 4;
  InvalidateRect(Handle, @RepaintRect, False);
end;

procedure TNextSheet.Clear;
begin
  FCells.Clear;
  Invalidate;
end;

procedure TNextSheet.ClearFormating(FromCol, FromRow, ToCol,
  ToRow: Integer);
var
  i, j: Integer;
begin
  for i := FromCol to ToCol do
    for j := FromRow to ToRow do
    begin
      Cell[i, j].Color := clNone;
      Cell[i, j].BorderLeft.LineStyle := lsNone;
      Cell[i, j].BorderTop.LineStyle := lsNone;
      Cell[i, j].BorderRight.LineStyle := lsNone;
      Cell[i, j].BorderBottom.LineStyle := lsNone;
    end;
end;

procedure TNextSheet.CopyCell(ACol, ARow: Integer);
begin
  Clipboard.AsText := Cell[ACol, ARow].Text;
end;

procedure TNextSheet.DeleteColumn(Index: Integer);
begin
  FCells.DeleteColumn(Index);
  CalculateHorzScrollBar;
  Invalidate;
end;

procedure TNextSheet.DeleteRow(Index: Integer);
begin
  FCells.DeleteRow(Index);
  CalculateVertScrollBar;
  Invalidate;
end;

procedure TNextSheet.Deselect;
var
	i, j: Integer;
begin
	for i := 0 to RowCount - 1 do
    for j := 0 to ColCount - 1 do
    begin
      Cell[j, i].Selected := False;
    end;
end;

procedure TNextSheet.DrawLine(FromCol, FromRow, ToCol, ToRow: Integer;
  LineStyle: TLineStyle; LineColor: TColor; Position: TBorderPosition);
var
  ACol, ARow: Integer;
begin
  ACol := FromCol;
  ARow := FromRow;
  while (ACol <> ToCol) and (ARow <> ToRow) do
  begin
    case Position of
      bpsBottom: Cell[ACol, ARow].BorderBottom.SetBorder(LineColor, LineStyle);
      bpsLeft: Cell[ACol, ARow].BorderLeft.SetBorder(LineColor, LineStyle);
      bpsRight: Cell[ACol, ARow].BorderRight.SetBorder(LineColor, LineStyle);
      bpsTop: Cell[ACol, ARow].BorderTop.SetBorder(LineColor, LineStyle);
    end;
  end;
end;

procedure TNextSheet.EditCell(const ACol, ARow: Integer;
  Value: WideString = '');
var
  CanEdit: Boolean;
  CellColor: TColor;
begin
  CanEdit := True;
  DoBeforeEdit(ACol, ARow, CanEdit, Value);
  if CanEdit then
  begin
    Include(FSheetState, stEditing);
    FEditCol := ACol;
    FEditRow := ARow;
    FEditRect := GetCellRect(Selection.StartCol, Selection.StartRow);
    SetCellFont(ACol, ARow, FInplaceEdit.Font);

    if FEditRect.Right < FEditRect.Left + GetCellTextWidth(ACol, ARow, Value) then
    begin
      FEditRect.Right := FEditRect.Left + GetCellTextWidth(ACol, ARow, Value);
    end;

    CellColor := Cell[ACol, ARow].Color;
    if CellColor = clNone then CellColor := Color;
    FInplaceEdit.Color := CellColor;
    if Length(Value) = 0 then FInplaceEdit.Text := Cell[ACol, ARow].Text else
    begin
      FInplaceEdit.Text := Value;
      FInplaceEdit.SelStart := 2;
    end;
    FInplaceEdit.SetBounds(FEditRect.Left, FEditRect.Top,
      FEditRect.Right - FEditRect.Left - 1, FEditRect.Bottom - FEditRect.Top - 1);
    InvalidateRect(Handle, @FEditRect, False);
    RefreshCell(ACol, ARow, True);
  end;
end;

procedure TNextSheet.Erase(FromCol, FromRow, ToCol, ToRow: Integer);
var
  i, j: Integer;
begin
  for i := FromCol to ToCol do
    for j := FromRow to ToRow do
    begin
      TryToEdit(i, j, '');
    end;
end;

procedure TNextSheet.Expression(const Col, Row: Integer; var Value: WideString);
begin
  if (Value <> '') and (Value[1] = '=') then
  begin
    { Evaluate Expression }
    Value := Preparse(Value);

    Value := Copy(Value, 2, Length(Value) - 1);

    FFormulaParser.Expression := Value;
    Value := FloatToStr(FFormulaParser.RealResult);

    { Set Cell's State }
    FCells.AddState(Col, Row, [cstCalculated]);
  end
    else FCells.RemoveState(Col, Row, [cstCalculated]);
end;

procedure TNextSheet.FrameCell(ACol, ARow: Integer; LineStyle: TLineStyle;
  LineColor: TColor);
var
  Range: TCellsRange;
begin
  if Cell[ACol, ARow].Active then
  begin
    Range := GetCellRange(ACol, ARow);
    if IsRange(Range) then
      FrameRange(Range, LineStyle, LineColor) else
    begin
      with Cell[ACol, ARow] do
      begin
        BorderTop.SetBorder(LineColor, LineStyle);
        BorderBottom.SetBorder(LineColor, LineStyle);
        BorderLeft.SetBorder(LineColor, LineStyle);
        BorderRight.SetBorder(LineColor, LineStyle);
      end;
    end;
    RefreshCell(ACol, ARow, True);
  end;
end;

procedure TNextSheet.FrameRange(Range: TCellsRange; LineStyle: TLineStyle;
  LineColor: TColor);
var
  i: Integer;
begin
  for i := Range.StartCol to Range.EndCol do
  begin
    Cell[i, Range.StartRow].BorderTop.SetBorder(LineColor, LineStyle);
    Cell[i, Range.EndRow].BorderBottom.SetBorder(LineColor, LineStyle);
  end;
  for i := Range.StartRow to Range.EndRow do
  begin
    Cell[Range.StartCol, i].BorderLeft.SetBorder(LineColor, LineStyle);
    Cell[Range.EndCol, i].BorderRight.SetBorder(LineColor, LineStyle);
  end;
end;

procedure TNextSheet.InsertColumn(Index: Integer);
begin
  FCells.InsertColumn(Index);
  CalculateHorzScrollBar;
  Invalidate;
end;

procedure TNextSheet.InsertRow(Index: Integer);
begin
  FCells.InsertRow(Index);
  CalculateVertScrollBar;
  Invalidate;
end;

function TNextSheet.GetCell(ACol, ARow: Integer): TNxCell;
begin
  Result := FCells.Cell[ACol, ARow];
end;

function TNextSheet.GetCellHeight(ACol, ARow: Integer): Integer;
var
  I: Integer;
begin
  Result := Row[ARow].Size;
  if ARow < RowCount - 1 then
    for I := ARow + 1 to RowCount - 1 do
      if Cell[ACol, I].DockCell = Cell[ACol, ARow]
        then Inc(Result, Row[I].Size) else Exit;
end;

function TNextSheet.GetCellWidth(ACol, ARow: Integer): Integer;
var
  I: Integer;
begin
  Result := Column[ACol].Size;
  if ACol < ColCount - 1 then
    for i := ACol + 1 to ColCount - 1 do
      if Cell[i, ARow].DockCell = Cell[ACol, ARow]
        then Inc(Result, Column[i].Size) else Exit;
end;

procedure TNextSheet.SetCell(ACol, ARow: Integer; const Value: TNxCell);
begin

end;

function TNextSheet.AddSheet(const Caption: string): TNxPageSheet;
begin
  try
    Result := TNxPageSheet.Create(Self);
    FSheetList.Add(Result);
  except
    Result := nil;
  end;
end;

procedure TNextSheet.AssignCell(ACol, ARow, SourceCol,
  SourceRow: Integer; Options: TSheetCellCopyOptions);
begin
  if coValue in Options then
  begin
    Cell[ACol, ARow].Text := Cell[SourceCol, SourceRow].Text;
  end;
  if coFormating in Options then
  begin
    with Cell[SourceCol, SourceRow] do
    begin
      Cell[ACol, ARow].BorderBottom.Assign(BorderBottom);
      Cell[ACol, ARow].BorderLeft.Assign(BorderLeft);
      Cell[ACol, ARow].BorderTop.Assign(BorderTop);
      Cell[ACol, ARow].BorderRight.Assign(BorderRight);
      Cell[ACol, ARow].Font.Assign(Font);
      Cell[ACol, ARow].Color := Color;
    end;
  end;
end;

function TNextSheet.CellBounds(ACol, ARow: Integer): Boolean;
begin
  Result := InRange(ACol, 0, Pred(ColCount)) and
    InRange(ARow, 0, Pred(RowCount));
end;

procedure TNextSheet.CopyToClipBoard;
var
  Buffer: array of char;
  c,
  r,
  b,
  s: Integer;
  str: string;
begin
  b := 0;
  SetLength(Buffer, 500000); // It resets the buffer
  for r := Selection.StartRow to Selection.EndRow do
    for c := Selection.StartCol to Selection.EndCol do
    begin
      str := Cell[c, r].Text;   // str gets the cell contents
      s := 1;
      If str <> '' then  // If str is not empty...
      begin
        repeat
          Buffer[b] := str[s]; // The str contents is transfered to the buffer
          s := s + 1;
          b := b + 1;
        until s > length(str);
      end;
      If (c < Selection.EndCol) then //If the current collumn does not exceed the limit...
      begin
        If Selected[c + 1,r] then // If the next cell is selected a tab is added
        begin                             // separating their contents in the buffer
          Buffer[b] := #9;
          b := b + 1;
        end else
        If not(Selected[c + 1, r])then // If the next cell is not selected the line
        begin                             // is broken in the buffer (#13#10)
           Buffer[b] := #$D;
          b:= b+1;
          Buffer[b] := #$A;
          b:= b+1;
        end;
      end else // If the number of collumns for the given row has been exceeded, the line
      begin    // is borken in the buffer.
        Buffer[b] := #$D;
        b := b + 1;
        Buffer[b] := #$A;
        b := b + 1;
      end;
    end;
  ClipBoard.SetTextBuf(PChar(Buffer));
end;

function TNextSheet.GetCellAtPos(X, Y: Integer): TNxCell;
var
  ACol, ARow: Integer;
begin
  Result := nil;
  ACol := GetColumnAtPos(X);
  ARow := GetRowAtPos(Y);
  if (ACol >= 0) and (ACol < ColCount) and (ARow >= 0) and (ARow < RowCount) then
  begin
	  Result := Cell[ACol, ARow];
	  if Assigned(Result.DockCell) then Result := Result.DockCell;
  end;
end;

function TNextSheet.GetCellLocation(const ACell: TNxCell): TCellPosition;
begin

end;

function TNextSheet.GetCellRange(ACol, ARow: Integer): TCellsRange;
var
	i: Integer;
begin
  Result := CellRange(ACol, ARow, ACol, ARow);
  if ACol < Pred(ColCount) then
  	for i := Succ(ACol) to Pred(ColCount) do
      if Cell[i, ARow].DockCell = Cell[ACol, ARow] then Result.EndCol := i else Break;

  if ARow < Pred(RowCount) then
  	for i := Succ(ARow) to Pred(RowCount) do
      if Cell[ACol, i].DockCell = Cell[ACol, ARow] then Result.EndRow := i else Break;
end;

function TNextSheet.GetCellRect(ACol, ARow: Integer): TRect;
var
	i: Integer;
begin
  if ACol > Pred(ColCount) then ColCount := Pred(ColCount);
  if ARow > Pred(RowCount) then RowCount := Pred(RowCount);
  with Result do
  begin
    Left := GetCellLeft(ACol);
    Top := GetCellTop(ARow);
    Right := Left + ZoomSize(Column[ACol].Size);
		if ACol < ColCount - 1 then
			for i := ACol + 1 to ColCount - 1 do
        if Cell[i, ARow].DockCell = Cell[ACol, ARow] then Right := Right + Column[i].Size else Break;
    Bottom := Top + ZoomSize(Row[ARow].Size);
		if ARow < RowCount - 1 then
			for i := ARow + 1 to RowCount - 1 do
        if Cell[ACol, i].DockCell = Cell[ACol, ARow] then Bottom := Bottom + Row[i].Size else Break;
  end;
end;

function TNextSheet.GetColumnAddress(ACol: Integer): string;
var
  S: string;
begin
  Result := '';

  if (ACol div 702) > 0  then
  begin
    ACol := ACol - 26;
    S := Char(65 + (ACol div 676) - 1);
    ACol := (ACol mod 676) + 26
  end else S := '';

  Result := S;

  if (ACol div 26) > 0 then S := Char(65 + (ACol div 26)-1) else S := '';

  Result := Result + S + Char(65 + (ACol mod 26));
end;

function TNextSheet.GetColumnAtPos(Pos: Integer): Integer;
var
 	i, w: Integer;
begin
  if soHeadings in Options then w := ZoomSize(FFixedColWidth) else w := 0;
  i := HorzScrollBar.Position;
  Result := -1;
  while (i <= ColCount - 1) do
  begin
    Inc(w, ZoomSize(Column[i].Size));
  	if Pos <= w then
    begin
      Result := i;
      Exit;
    end;
    Inc(i);
  end;
end;

function TNextSheet.GetColumnGripAtPos(X, Y: Integer): Integer;
var
  I, Pos: Integer;
begin
  Result := -1;
  if not(soHeadings in Options) or (Y > GetFixedSize.cy) then Exit;
  if soHeadings in Options then Pos := GetFixedSize.cx else Pos := 0;
  for I := HorzScrollBar.Position to ColCount - 1 do
  begin
    Inc(Pos, ZoomSize(Column[I].Size));
    if InRange(X, Pos - 5, Pos + 5) then
    begin
      Result := I;
      if i < ColCount - 1 then
      begin
        if Column[i + 1].Size = 0 then
        begin
          if InRange(X, Pos + 2, Pos + 5) then Result := i + 1;
        end;
      end;
      Break;
    end;
  end;
end;

function TNextSheet.GetExpansionRect: TRect;
var
  EndCol, EndRow: Integer;
begin
  if FExpansionRange.EndCol > Pred(ColCount) then EndCol := Pred(ColCount) else EndCol := FExpansionRange.EndCol;
  if FExpansionRange.EndRow > Pred(RowCount) then EndRow := Pred(RowCount) else EndRow := FExpansionRange.EndRow;
	with Result do
  begin

    Left := GetCellLeft(FExpansionRange.StartCol);
    Top := GetCellTop(FExpansionRange.StartRow);
    Right := GetCellLeft(EndCol);
    Bottom := GetCellTop(EndRow);

    if FExpansionRange.StartCol > EndCol then
    begin
      Inc(Left, ZoomSize(Column[FExpansionRange.StartCol].Size));
    end else
    begin
      Inc(Right, ZoomSize(Column[EndCol].Size));
    end;

    if FExpansionRange.StartRow > EndRow then
    begin
      Inc(Top, ZoomSize(Row[FExpansionRange.StartRow].Size));
    end else
    begin
      Inc(Bottom,  + ZoomSize(Row[EndRow].Size));
    end;

  end;
end;

function TNextSheet.GetFixedRowRect(Index: Integer): TRect;
begin
  with Result do
  begin
    Left := GetCellLeft(Index);
    Top := 0;
    Right := Left + Column[Index].Size * FZoom div 100;
    Bottom := ZoomSize(FFixedRowHeight);
  end;
end;

function TNextSheet.GetCellsRangeRect(const Range: TCellsRange): TRect;
begin
  with Result do
  begin
    Left := GetCellLeft(Range.StartCol);
    Top := GetCellTop(Range.StartRow);
    Right := GetCellLeft(Range.EndCol) + Column[Range.EndCol].Size;
    Bottom := GetCellTop(Range.EndRow) + Row[Range.EndRow].Size;
  end;
end;

function TNextSheet.GetRowAtPos(Pos: Integer): Integer;
var
 	i, w: Integer;
begin
  if soHeadings in Options then w := ZoomSize(FFixedRowHeight) else w := 0;
  i := VertScrollBar.Position;
  Result := -1;
  while (i <= RowCount - 1) do
  begin
    Inc(w, ZoomSize(Row[i].Size));
  	if Pos <= w then
    begin
      Result := i;
      Exit;
    end;
    Inc(i);
  end;
end;

function TNextSheet.GetRowGripAtPos(X, Y: Integer): Integer;
var
  I, Pos: Integer;
begin
  Result := -1;
  if not(soHeadings in Options) or (X > GetFixedSize.cx) then Exit;
  if soHeadings in Options then Pos := GetFixedSize.cy else Pos := 0;
  for I := VertScrollBar.Position to RowCount - 1 do
  begin
    Inc(Pos, ZoomSize(Row[I].Size));
    if InRange(Y, Pos - 5, Pos + 5) then
    begin
      Result := I;
      if i < RowCount - 1 then
      begin
        if Row[i + 1].Size = 0 then
        begin
         if InRange(Y, Pos + 2, Pos + 5) then Result := i + 1;
        end;
      end;
      Break;
    end;
  end;
end;

function TNextSheet.mCell(var context: TNxFormulaParser;
  var s: string): Extended;
var
  i: Integer;
  pt: TPoint;
  fp: TNxFormulaParser;
begin
  if (Length(s) >= 2) then
  begin
    pt.X := 0;
    pt.Y := 0;

    for i := 1 to Length(s) do
      case s[i] of
        'A'..'Z': pt.X := (pt.X * 26) + (Ord(s[i]) - Ord('@'));
       // 'a'..'z': pt.X := (pt.X * 26) + (Ord(s[i]) - Ord('`'));
        '0'..'9': pt.Y := (pt.Y * 10) + (Ord(s[i]) - Ord('0'));
        else break;
      end;

    //veg: Added 1 based to 0 based indexing!

    Dec(pt.X);
    Dec(pt.Y);                      

    if InRange(pt.X, 0, Pred(ColCount)) and
      InRange(pt.Y, 0, Pred(RowCount)) then
    begin
      fp := TNxFormulaParser.Create(Self);
      fp.Addobject(Self, 'CELL', tfp_m_1str);
      fp.Addermsg(40, 'Invalid Cell Address');
      fp.Addermsg(41, 'Invalid Cell Address Format');
      fp.Expression := Cell[pt.X, pt.Y].Value;

      Result := fp.RealResult;

      context.Seternr(fp.Ernr);

      FreeAndNil(fp);
    end else
    begin
      Result := 0;
      context.Seternr(40);
    end;
  end else
  begin
    Result := 0;
    context.Seternr(41);
  end;
end;

procedure TNextSheet.MergeCells(FromCol, FromRow, ToCol, ToRow: Integer;
  Alignment: TCellAlignment);
var
	i, j: Integer;
begin
	for i := FromRow to ToRow do
  	for j	:= FromCol to ToCol do
    begin
    	Cell[j, i].DockCell := Cell[FromCol, FromRow];
      Cell[j, i].BorderRight.Assign(Cell[FromCol, FromRow].BorderRight);
      Cell[j, i].BorderBottom.Assign(Cell[FromCol, FromRow].BorderBottom);
    end;

  Cell[FromCol, FromRow].Alignment := Alignment;
  RefreshCell(FromCol, FromRow, True);
end;

procedure TNextSheet.MergeSelection;
begin
  MergeCells(Selection.StartCol, Selection.StartRow, Selection.EndCol, Selection.EndRow);
end;

procedure TNextSheet.MoveSelection;
begin
  Cell[SelectedCol, SelectedRow].Selected := False;
  case FSelectionMoveDirection of
    mdUp: SelectedRow := SelectedRow - 1;
    mdDown: SelectedRow := SelectedRow + 1;
    mdLeft: SelectedCol := SelectedCol - 1;
    mdRight: SelectedCol := SelectedCol + 1;
  end;
  RefreshCell(SelectedCol, SelectedRow, True);
end;

procedure TNextSheet.MoveSelectionDown;
begin
  if SelectedRow + 1 < RowCount then
  begin
    SelectCell(SelectedCol, SelectedRow + 1);
    SelectCells(SelectedCol, SelectedRow, SelectedCol, SelectedRow);
  end;
end;

procedure TNextSheet.MoveSelectionLeft;
begin
  if SelectedCol - 1 >= 0 then
  begin
    SelectCell(SelectedCol - 1, SelectedRow);
    SelectCells(SelectedCol, SelectedRow, SelectedCol, SelectedRow);
  end;
end;

procedure TNextSheet.MoveSelectionRight;
begin
  if SelectedCol + 1 < ColCount then
  begin
    SelectCell(SelectedCol + 1, SelectedRow);
    SelectCells(SelectedCol, SelectedRow, SelectedCol, SelectedRow);
  end;
end;

procedure TNextSheet.MoveSelectionUp;
begin
  if SelectedRow - 1 >= 0 then
  begin
    SelectCell(SelectedCol, SelectedRow - 1);
    SelectCells(SelectedCol, SelectedRow, SelectedCol, SelectedRow);
  end;
end;

procedure TNextSheet.PasteFromClipBoard;
var
  i, RefCol, ACol, ARow: Integer;
  Buffer: array of Char;
begin
  ACol := SelectedCol;
  ARow := SelectedRow;
  RefCol := ACol; // It keeps the original valid indexes
  If ClipBoard.HasFormat(CF_TEXT) then  // If the content of the clipboard is text...
  begin
    SetLength(Buffer, 500000); // It initiates the text buffer
    ClipBoard.GetTextBuf(PChar(Buffer), 500000); // It transfers the contents of the clipboard to
                                                // the buffer
    TryToEdit(ACol, ARow, ''); // The current cell is cleared
    i := 0; // The buffer is zero indexed
    while (Buffer[i] <> #0) do  // While the caracter is not null...
    begin
      // If it is not a separator nor a nrew line...
      If (Buffer[i] <> #9) and (Buffer[i] <> #$D) and (Buffer[i] <> #$A) then
      begin
        // If the character is a valid one...
        If (ACol <= ColCount - 1) and (ARow <= RowCount - 1) then
        begin
          TryToEdit(ACol, ARow, Cell[ACol, ARow].Text + Buffer[i]);
        end;
      end;
      // If it is a new line... (#13#10)
      If (Buffer[i] = #$D) and (Buffer[i+1] = #$A) then
      begin
        // The row is incremented and the collumn reset.
        ARow := ARow + 1;
        ACol := RefCol;
        If (ACol <= ColCount - 1) and (ARow <= RowCount - 1) then
          TryToEdit(ACol, ARow, ''); // The current cell is cleared
      end;
      // A tab character indicates a new collumn in a given row
      If (Buffer[i] = #9) then
      begin
        ACol := ACol + 1;
        TryToEdit(ACol, ARow, ''); // The current cell is cleared
      end;
      i:= i + 1;
    end;
  end;
end;

procedure TNextSheet.Print(Zoom: Integer; Options: TNxSheetPrintOptions);
var
  i, j, X, Y, cw, ch, MapMode, PrevMapMode, PageNumber: Integer;
  CellRect: TRect;

  function InchToMm(Inch: Double): Double;
  begin
    Result := Inch * 25.4;
  end;

  function GetHorzDpi: Integer;
  begin
    Result := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  end;

  function GetVertDpi: Integer;
  begin
    Result := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  end;

  function GetPageHeight: Double;
  begin
  { note: Default page height set
          in printer settings }
    Result := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT) / GetVertDpi;
    Result := InchToMm(Result);
  end;

  function GetPageWidth: Double;
  begin
  { note: Default page width set
          in printer settings }
    Result := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH) / GetHorzDpi;
    Result := InchToMm(Result);
  end;

  function ZoomSize(const Value: Integer): Integer;
  begin
    Result := Value * Zoom div 100;
  end;

  procedure PrintCell(R: TRect; Col, Row: Integer);
  var Fill: TRect;
  begin
    Printer.Canvas.Font.Assign(Cell[Col, Row].Font);
    Printer.Canvas.Font.Height := ZoomSize(Printer.Canvas.Font.Height);

    { Fill cell }
    if Cell[Col, Row].Color <> clNone then
    begin
      Fill := R;
      Dec(Fill.Top, ZoomSize(1));
      Printer.Canvas.Brush.Color := Cell[Col, Row].Color;
      Printer.Canvas.FillRect(Fill);
    end;

    { Print cell text }
    TGraphicsProvider.DrawWrapedTextRect(Printer.Canvas, R,
      GetAlignment(Cell[Col, Row].Alignment),
      GetVerticalAlignment(Cell[Col, Row].Alignment),
      False, Cell[Col, Row].DisplayText, BidiMode);

    { Print borders }
    PrintCellBorder(Col, Row, R);
  end;

  procedure PrintPageNumber;
  var
    XPos, YPos: Integer;
  begin
    Printer.Canvas.Font.Assign(Font);
    Printer.Canvas.Font.Height := -3 * 10;
    XPos := (Round(GetPageWidth) * 10) - Printer.Canvas.TextWidth(IntToStr(PageNumber)) * 10;
    YPos := (Round(GetPageHeight) * 10) - Printer.Canvas.TextHeight(IntToStr(PageNumber)) * 10;
    Printer.Canvas.TextOut(XPos, -YPos, IntToStr(PageNumber));
  end;

  procedure PrintPageTitle;
  begin
    Printer.Canvas.Font.Assign(Font);
    Printer.Canvas.Font.Height := -3 * 10; { 3mm }
    Printer.Canvas.TextOut(0, 0, Caption);
    Inc(Y, 80); { 8 mm }
  end;

begin
  PageNumber := 1;

  Printer.BeginDoc;

  { Get previous map mode }
  PrevMapMode := GetMapMode(Printer.Handle);

  { Set map mode to 0.1 mm }
  MapMode := MM_LOMETRIC;
  SetMapMode(Printer.Handle, MapMode);

  X := 0;
  Y := 0;
  ch := 0;
  cw := 0;

  { Print page title }
  if poPageTitle in Options then PrintPageTitle;

  { Print first page number }
  if poPageNumbers in Options then PrintPageNumber;

  for i := 0 to Pred(RowCount) do
  begin
    for j := 0 to Pred(ColCount) do
    begin
      if Cell[j, i].Active then
      begin
        { Default size is 0.1 mm }
        cw := GetCellWidth(j, i) * 10;
        ch := GetCellHeight(j, i) * 10;

        { Apply a zoom }
        cw := ZoomSize(cw);
        ch := ZoomSize(ch);

        CellRect := Rect(X, -Y, X + cw, -(Y + ch));
        PrintCell(CellRect, j, i);
      end;
      Inc(X, cw);
    end;

    X := 0;
    Inc(Y, ch);

    { Start new page }
    if Y > GetPageHeight * 10 then
    begin
      Printer.NewPage;
      Inc(PageNumber);

      { Print title on new page }
      if poPageTitle in Options then PrintPageTitle;

      { Print page number on new page }
      if poPageNumbers in Options then PrintPageNumber;

      Y := 0;
    end;
  end;

  { Turn back old map mode }
  SetMapMode(Printer.Handle, PrevMapMode);
  Printer.EndDoc;
end;

procedure TNextSheet.PrintBorder(Border: TNxCellBorder; R: TRect;
  Position: TBorderPosition);

  procedure PrintDot;
  begin
    with Printer.Canvas, R do
    begin
      Pen.Color := Border.Color;
      case Position of
        bpsBottom: DrawDotLine(Printer.Canvas, Left, Bottom - 1, Right, Bottom - 1);
        bpsRight: DrawDotLine(Printer.Canvas, Right - 1, Top, Right - 1, Bottom);
      end;
    end;
  end;

  procedure PrintDouble;
  begin
    { double = }
    with Printer.Canvas, R do
    begin
      Pen.Color := Border.Color;
      case Position of
        bpsBottom:
        begin
          MoveTo(Left, Bottom - 2);
          LineTo(Right, Bottom - 2);
          MoveTo(Left, Bottom);
          LineTo(Right, Bottom);
        end;
        bpsRight:
        begin
          MoveTo(Right - 2, Top);
          LineTo(Right - 2, Bottom);
          MoveTo(Right, Top);
          LineTo(Right, Bottom);
        end;
      end;
    end;
  end;

  procedure PrintSolid;
  begin
    { solid 2px wide line }
    with Printer.Canvas, R do
    begin
      Pen.Color := Border.Color;
      case Position of
        bpsBottom:
        begin
          MoveTo(Left - 2, Bottom - 2);
          LineTo(Right, Bottom - 2);
          MoveTo(Left - 1, Bottom - 1);
          LineTo(Right, Bottom - 1);
        end;
        bpsRight:
        begin
          MoveTo(Right - 2, Top - 1);
          LineTo(Right - 2, Bottom);
          MoveTo(Right - 1, Top - 2);
          LineTo(Right - 1, Bottom);
        end;
      end;
    end;
  end;

  procedure PrintThinLine;
  begin
    { solid 1px line }
    with Printer.Canvas, R do
    begin
      Pen.Color := Border.Color;
      case Position of
        bpsBottom:
        begin
          MoveTo(Left, Bottom - 1);
          LineTo(Right, Bottom - 1);
        end;
        bpsRight:
        begin
          MoveTo(Right - 1, Top);
          LineTo(Right - 1, Bottom);
        end;
      end;
    end;
  end;

begin
  case Border.LineStyle of
    lsDot:      PrintDot;
    lsDouble:   PrintDouble;
    lsSolid:    PrintSolid;
    lsThinLine: PrintThinLine;
  end;
end;

procedure TNextSheet.PrintCellBorder(ACol, ARow: Integer; CellRect: TRect);
var
  PrintRect: TRect;
  PrintBottom, PrintRight: Boolean;

  function CellBottomClear: Boolean;
  begin
    Result := True;
    if ARow < RowCount - 1 then
    begin
      if Cell[ACol, ARow + 1].Active then Result := Cell[ACol, ARow + 1].Color = clNone
        else Result := Cell[ACol, ARow + 1].DockCell.Color = clNone;
    end;
  end;

  function CellRightClear: Boolean;
  begin
    Result := True;
    if ACol < ColCount - 1 then
    begin
      if Cell[ACol + 1, ARow].Active then Result := Cell[ACol + 1, ARow].Color = clNone
        else Result := Cell[ACol + 1, ARow].DockCell.Color = clNone;
    end;
  end;

  function CellRightMerged: Boolean;
  begin
    Result := False;
    if ACol < ColCount - 1 then
    begin
      Result := not Cell[ACol + 1, ARow].Active
        and not (Cell[ACol, ARow].DockCell <> Cell[ACol + 1, ARow].DockCell)
    end;
  end;

  function CellBottomMerged: Boolean;
  begin
    Result := False;
    if ARow < RowCount - 1 then
    begin
      Result := not Cell[ACol, ARow + 1].Active
        and not (Cell[ACol, ARow].DockCell <> Cell[ACol, ARow + 1].DockCell)
    end;
  end;

begin
  PrintRect := CellRect;

  case Cell[ACol, ARow].BorderTop.LineStyle of
    lsDouble, lsWeightSolid: PrintRect.Top := PrintRect.Top + 1;
  end;

  case Cell[ACol, ARow].BorderLeft.LineStyle of
    lsDouble, lsWeightSolid: PrintRect.Left := PrintRect.Left + 1;
  end;

  PrintBottom := (Cell[ACol, ARow].Color = clNone) and CellBottomClear;
  PrintBottom := PrintBottom or (Cell[ACol, ARow].BorderBottom.Color <> clNone);
  PrintBottom := PrintBottom and not CellBottomMerged;
  PrintBottom := PrintBottom and ((Cell[ACol, ARow].BorderBottom.Color <> clNone) or (soGridLines in FOptions));

  PrintRight := (Cell[ACol, ARow].Color = clNone) and CellRightClear;
  PrintRight := PrintRight or (Cell[ACol, ARow].BorderRight.Color <> clNone);
  PrintRight := PrintRight and not CellRightMerged;
  PrintRight := PrintRight and ((Cell[ACol, ARow].BorderRight.Color <> clNone) or (soGridLines in FOptions));

  if PrintBottom then PrintBorder(Cell[ACol, ARow].BorderBottom, CellRect, bpsBottom);
  if PrintRight then PrintBorder(Cell[ACol, ARow].BorderRight, CellRect, bpsRight);
end;

procedure TNextSheet.RefreshCell(ACol, ARow: Integer; Border: Boolean = False);
var
	r: TRect;
begin
	r := GetCellRect(ACol, ARow);
  if Border then InflateRect(r, 2, 2);
  InvalidateRect(Handle, @r, False);
end;

procedure TNextSheet.SaveToXLSFile(const FileName: string);
var
  Document: TNxXLSDocument;
  Col, Row: Integer;
begin
  Document := TNxXLSDocument.Create;
  try
    for Col := 0 to Pred(ColCount) do
    begin
      for Row := 0 to Pred(RowCount) do
      begin
        if Cell[Col, Row].Text <> '' then
          case Cell[Col, Row].DataKind of
            dkString: Document.Text(Row, Col, Cell[Col, Row].Text, taLeftJustify, 'Arial', 10);
            dkFloat, dkInteger: Document.FloatingNumber(Row, Col, StrToFloat(Cell[Col, Row].Text));
          end;
      end;
    end;
    Document.SaveToFile(FileName);
  finally
    Document.Free;
  end;
end;

procedure TNextSheet.SaveToCSVFile(const FileName: WideString;
	Separator: WideChar = ','; MultiLineSeparator: WideChar = '|'; EncodingKind: TEncodingKind = ekUnicode);

  function GetValid(s: WideString): WideString;
	var
    i: Integer;
  begin
  	Result := '';
		for i := 1 to Length(s) do
      if s[i] = '"'	then
      begin
        if (i = 1) or (i = Length(s)) then Result := Result + '"' + s[i] else Result := Result + s[i] + '"';
      end else
      begin
        if s[i] = #13 then Result := Result + MultiLineSeparator else
          if s[i] <> #10 then Result := Result + s[i];
      end;
    if (Pos(Separator, s) <> 0) or (Pos('"', s) <> 0) then Result := '"' + Result + '"';
  end;

  procedure WriteUnicode;
  var
    i, j, z: Integer;
    f: TWideFile;
    q: WideString;
    wchr: WideChar;
  begin
    AssignFile(f, FileName);
    Rewrite(f);
    case EncodingKind of
      ekUnicode: wchr := #$FEFF;
      ekUnicodeBigEndian: wchr := #$FFFE;
    end;

    Write(f, wchr);

    for i := 0 to RowCount - 1 do
      for j := 0 to ColCount - 1 do
      begin
        q := GetValid(Cell[j, i].Text);
        for z := 1 to Length(q) do Write(f, q[z]);
        if not(j = ColCount - 1) then Write(f, Separator);
        { add new row }
        if j = ColCount - 1 then
        begin
          wchr := #13;
          Write(f, wchr);
          wchr := #10;
          Write(f, wchr);
        end;
      end;
    CloseFile(f);
  end;

  procedure WriteAnsi;
  var
    f: System.Text;
    i, j: Integer;
  begin
    AssignFile(f, FileName);
    Rewrite(f);
    for i := 0 to RowCount - 1 do
    begin
      for j := 0 to ColCount - 1 do
      begin
        Write(f, GetValid(Cell[j, i].Text));
        if (j <> ColCount - 1) then Write(f, Separator)
      end;
      Writeln(f);
    end;
    CloseFile(f);
  end;

begin
  case EncodingKind of
    ekAnsi: WriteAnsi;
    ekUnicode, ekUnicodeBigEndian: WriteUnicode;
  end;
end;

procedure TNextSheet.SelectCell(ACol, ARow: Integer);
begin
  SelectCells(ACol, ARow, ACol, ARow);
  SelectedCol := ACol;
  SelectedRow := ARow;
end;

procedure TNextSheet.SelectCells(FromCol, FromRow, ToCol, ToRow: Integer);
var
	AFromCol, AFromRow, AToCol, AToRow, c, r: Integer;
  AOldSelection: TCellsRange;

  function RightCell(ACol, ARow: Integer): Integer;
  var
    i: Integer;
  begin
    Result := ACol;
    i := ACol;
    while (i < ColCount) and (Cell[i, ARow].DockCell = Cell[ACol, ARow]) do
    begin
      if Cell[i, ARow] <> Cell[ACol, ARow] then Inc(Result);
      Inc(i);
    end;
  end;

  function BottomCell(ACol, ARow: Integer): Integer;
  var
    i: Integer;
  begin
    Result := ARow;
    i := ARow;
    while (i < RowCount) and (Cell[ACol, i].DockCell = Cell[ACol, ARow]) do
    begin
      if Cell[ACol, i] <> Cell[ACol, ARow] then Inc(Result);
      Inc(i);
    end;
  end;

  procedure SetSelection(var AStartCol, AStartRow, AEndCol, AEndRow: Integer);
  var
    i, j: Integer;
  begin
    for i := AStartRow to AEndRow do
    begin
      for j	:= AStartCol to AEndCol do
      begin
        if not Cell[j, i].Active then { cell is merged }
        begin
          Cell[j, i].DockCell.Selected := True;
          with Cell[j, i].DockCell do
          begin
            if Col < AStartCol then
            begin
              AStartCol := Col;
              SetSelection(AStartCol, AStartRow, AEndCol, AEndRow);
            end;

            if Row < AStartRow then
            begin
              AStartRow := Row;
              SetSelection(AStartCol, AStartRow, AEndCol, AEndRow);
            end;

            if RightCell(Col, Row) > AEndCol then
            begin
              AEndCol := RightCell(Col, Row);
              SetSelection(AStartCol, AStartRow, AEndCol, AEndRow);
            end;

            if BottomCell(Col, Row) > AEndRow then
            begin
              AEndRow := BottomCell(Col, Row);
              SetSelection(AStartCol, AStartRow, AEndCol, AEndRow);
            end;

          end;
        end else { normal cell }
        begin
          with Cell[j, i] do
          begin
            if RightCell(Col, Row) > AEndCol then
            begin
              AEndCol := RightCell(Col, Row);
              SetSelection(AStartCol, AStartRow, AEndCol, AEndRow);
            end;

            if BottomCell(Col, Row) > AEndRow then
            begin
              AEndRow := BottomCell(Col, Row);
              SetSelection(AStartCol, AStartRow, AEndCol, AEndRow);
            end;
          end;
        end;
      end;
    end;
  end;

begin
  AOldSelection := FSelection;

	if FromCol <= ToCol then
  begin
    AFromCol := FromCol;
    AToCol := ToCol;
  end else
  begin
    AFromCol := ToCol;
    AToCol := FromCol;
  end;
	if FromRow <= ToRow then
  begin
    AFromRow := FromRow;
    AToRow := ToRow;
  end else
  begin
    AFromRow := ToRow;
    AToRow := FromRow;
  end;

  SetSelection(AFromCol, AFromRow, AToCol, AToRow);

  with FSelection do
  begin
    StartCol := AFromCol;
    StartRow := AFromRow;
    EndCol := AToCol;
    EndRow := AToRow;
  end;

  if not SameRange(FSelection, AOldSelection) then
  begin
  	if not(stCtrlSelection in FSheetState) then Deselect;
    for c := AFromCol to AToCol do
      for r := AFromRow to AToRow do
        Cell[c, r].Selected := True;
  end;
  DoSelectCell(SelectedCol, SelectedRow); { event }
end;

procedure TNextSheet.SetScrollClipRect;
var
  RH, RV: TRect;
begin
  RH := ClientRect;
  RV := RH;
  if soHeadings in FOptions then
  begin
    Inc(RH.Left, ZoomSize(FFixedColWidth));
    Inc(RV.Top, ZoomSize(FFixedRowHeight));
  end;
  VertScrollClipRect := RV;
  HorzScrollClipRect := RH;
end;

procedure TNextSheet.SplitCells(FromCol, FromRow, ToCol, ToRow: Integer);
var
	i, j: Integer;
begin
	for i := FromRow to ToRow do
  	for j	:= FromCol to ToCol do
    begin
    	Cell[j, i].DockCell := nil;
		  RefreshCell(FromCol, FromRow, True);
    end;
end;

procedure TNextSheet.SetVersion(const Value: string);
begin
  FVersion := strNextSheetVer;
end;

procedure TNextSheet.TryToEdit(ACol, ARow: Integer; Value: WideString);
var
  CanEdit: Boolean;
begin
  CanEdit := True;
  DoBeforeEdit(ACol, ARow, CanEdit, Value);
  if CanEdit then Cell[ACol, ARow].Text := Value;
end;

procedure TNextSheet.SaveToStream(Stream: TStream);
var
  c, r: Integer;
begin

  for r := 0 to Pred(RowCount) do
  begin

    for c := 0 to Pred(ColCount) do
    begin
//      Stream.WriteBuffer(Cell[r, c]);
    end;

  end;

end;

end.
