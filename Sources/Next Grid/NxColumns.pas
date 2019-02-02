{
  Next Grid
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxColumns.pas bn
}

{$I ..\NxSuite.inc}

unit NxColumns;

interface

uses
  Types, Windows, Messages, Classes, Controls, Graphics,
  SysUtils, Math, Forms, StdCtrls, NxClasses, NxGridCommon, NxSharedCommon, NxEdit;
              
const
  sizMaxColumns = 1024;

type
  TNxColumns = class;
  TNxColumnsClass = class of TNxColumns;
  TNxCustomColumn = class;
  TNxColumnClass = class of TNxCustomColumn;
  TColumnDisplay = class;
  TColumnDisplayClass = class of TColumnDisplay;
  TColumnPlay = class;
  TColumnPlayClass = class of TColumnPlay;
  TColumnPartClass = class of TColumnPart;
  TCellState = set of (csBoldTextSelection, csEmpty, csFocused, csSelected);
  TColumnChangeKind = (ccFieldName, ccInputChange, ccPosition, ccRevertStyle, ccSlideChanged,
    ccSorted, ccSortTypeChange, ccUndefined, ccVisible, ccUnsorted, ccWidth);
  TColumnLocation = (clAlone, clLeftSide, clMiddle, clRightSide);
  TColumnState = set of (ceEditable, ceCanInput);
  TColumnStyle = set of (csClickable, csCanEdit, csDisableSorting,
    csFitToLargest, csRedrawInplaceEdit, csTextFitHint, csWantReturns);
  TDisplayMode = (dmImageOnly, dmTextAndImage, dmTextOnly);
  TFormulaKind = (fkNone, fkAverage, fkCount, fkDistinct, fkMaximum,
    fkMinimum, fkSum, fkCustom);
  THeaderOrientation = (hoHorizontal, hoVertical);
  TColumnType = (ctAutoInc, ctBoolean, ctNone, ctDate,
    ctFloat, ctGraphic, ctGuid, ctInteger, ctString, ctLookup, ctMemo, ctVirtual);
  TColumnKind = (ckTextual, ckBlob, ckNumeric, ckImage, ckComboBox,
    ckCheckBox, ckDate, ckProgress, ckRate, ckIncrement, ckHtml);
  TColumnPartKind = (cpFooter, cpHeader);
  TColumnNotifyOperation = (ccAlignChange, cnCaptionChange, cnColorChange, ccDrawingChange,
    cnNameChange, cnOptionsChange, ccVisibleChange);
  TColumnNotifyProc = procedure(Sender: TNxCustomColumn; Operation: TColumnNotifyOperation) of object;
  PColumnNotifyProc = ^TColumnNotifyProc;
  TColumnMemberKind = (ckFooter, ckHeader, ckInactiveHeader, ckIndicator, ckInput);
  TColumnOptions = set of (coAutoSize, coCanClick, coCanInput, coCanSort,
    coDisableMoving, coDontHighlight, coEditing, coEditorAutoSelect, coFixedSize, coImageForIcon,
    coPublicUsing, coFullResort, coSearchColumn, coShowTextFitHint, coTextForCaption);
  TColumnsOperation = (opAdd, opDelete, opClear, opInsert, opMove);
  TDisplayDataKind = (dkBoolean, dkDateTime, dkFloat, dkInteger, dkString);
  TSlideCatpionLocation = (clLeft, clTop);
  TSortKind = (skAscending, skDescending);
	TSortType = (stAlphabetic, stBoolean, stCaseInsensitive,
    stCustom, stNumeric, stDate, stIP, stUnicodeAlphabetic);
  TDisplayOptions = set of (doMultiLine);
  TColumnChangeEvent = procedure (Sender: TObject; AColumn: TNxCustomColumn; ChangeKind: TColumnChangeKind;
    Param: Integer = -1) of object;
  TColumnsChangeEvent = procedure (Sender: TObject; ChangeOpearation:	TColumnsOperation;
	  Value1: Integer = -1; Value2: Integer = -1) of object;
  TColumnGetTextEvent = procedure (Sender: TObject; var Text: WideString) of object;
  TSlideOptions = set of (soAutoSize);

  TCellInfo = record
    AsBoolean: Boolean;
		AsDateTime: TDateTime;
    AsFloat: Double;
    AsInteger: Integer;
    AsString: WideString;
    AsVariant: Variant;
    ObjectReference: TObject;
  end;

  TColumnPart = class(TPersistent)
  private
    FCaption: WideString;
    FColor: TColor;
    FColumn: TNxCustomColumn;
    FDisplayMode: TDisplayMode;
    FGlyph: TBitmap;
    FHint: WideString;
    FObjectReference: TObject;
    FOnChange: TNotifyEvent;
    FDrawingOptions: TDrawingOptions;
    procedure SetCaption(const Value: WideString);
    procedure SetColor(const Value: TColor);
    procedure SetDisplayMode(const Value: TDisplayMode);
    procedure SetDrawingOptions(const Value: TDrawingOptions);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetHint(const Value: WideString);
  protected
    procedure DoChange(Sender: TObject);
    procedure DoGlyphChanged(Sender: TObject);
  public
    constructor Create(AColumn: TNxCustomColumn); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Column: TNxCustomColumn read FColumn;
    property ObjectReference: TObject read FObjectReference write FObjectReference;
  published
    property Color: TColor read FColor write SetColor;
    property Caption: WideString read FCaption write SetCaption;
    property DisplayMode: TDisplayMode read FDisplayMode write SetDisplayMode default dmTextOnly;
    property DrawingOptions: TDrawingOptions read FDrawingOptions write SetDrawingOptions default doNormal;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property Hint: WideString read FHint write SetHint;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TFormatMaskKind = (mkText, mkFloat);

  TColumnFooter = class(TColumnPart)
  private
    FAlignment: TAlignment;
    FFormatMask: string;
    FFormatMaskKind: TFormatMaskKind;
    FFormulaKind: TFormulaKind;
    FFormulaValue: Double;
    FTextAfter: WideString;
    FTextBefore: WideString;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetFormatMask(const Value: string);
    procedure SetFormatMaskKind(const Value: TFormatMaskKind);
    procedure SetFormulaKind(const Value: TFormulaKind);
    procedure SetFormulaValue(const Value: Double);
    procedure SetTextAfter(const Value: WideString);
    procedure SetTextBefore(const Value: WideString);
  public
    constructor Create(AColumn: TNxCustomColumn); override;
    procedure Assign(Source: TPersistent); override;
    property FormulaValue: Double read FFormulaValue write SetFormulaValue;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Color default clWindow;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
    property TextBefore: WideString read FTextBefore write SetTextBefore;
    property FormulaKind: TFormulaKind read FFormulaKind write SetFormulaKind default fkNone;
    property FormatMask: string read FFormatMask write SetFormatMask;
    property FormatMaskKind: TFormatMaskKind read FFormatMaskKind write SetFormatMaskKind default mkText;
  end;

  TColumnHeader = class(TColumnPart)
  private
    FOrientation: THeaderOrientation;
    FAlignment: TAlignment;
    FMultiLine: Boolean;
    FFont: TFont;
    FHideArrow: Boolean;
    FParentFont: Boolean;
    procedure SetOrientation(const Value: THeaderOrientation);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetMultiLine(const Value: Boolean);
    procedure SetHideArrow(const Value: Boolean);
    procedure SetParentFont(const Value: Boolean);
    procedure SetFont(const Value: TFont);
  protected
    procedure DoFontChange(Sender: TObject);
  public
    constructor Create(AColumn: TNxCustomColumn); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Color default clBtnFace;
    property Font: TFont read FFont write SetFont;
    property HideArrow: Boolean read FHideArrow write SetHideArrow default True;
    property MultiLine: Boolean read FMultiLine write SetMultiLine default False;
    property Orientation: THeaderOrientation read FOrientation write SetOrientation default hoHorizontal;
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
  end;

  TNxSlideBounds = class(TPersistent)
  private
    FOwner: TNxCustomColumn;
    FLeft: Integer;
    FTop: Integer;
    FHeight: Integer;
    FWidth: Integer;
    function GetBottom: Integer;
    function GetRight: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  public
    constructor Create(AOwner: TNxCustomColumn); virtual;
    procedure Assign(Source: TPersistent); override;
    property Bottom: Integer read GetBottom;
    property Right: Integer read GetRight;
  published
    property Height: Integer read FHeight write SetHeight default 16;
    property Left: Integer read FLeft write SetLeft default 8;
    property Top: Integer read FTop write SetTop default 8;
    property Width: Integer read FWidth write SetWidth default 80;
  end;

  TDrawCellEvent = procedure (Sender: TObject; ACol, ARow: Integer; CellRect: TRect; CellState: TCellState) of object;

  TNxCustomColumn = class(TComponent)
  private
    FAlignment: TAlignment;
    FAutoEdit: Boolean;
    FBiDiMode: TBiDiMode;
    FColor: TColor;
    FColumns: TNxColumns;
    FColumnType: TColumnType;
    FCursor: TCursor;
    FDefaultValue: WideString;
    FDefaultWidth: Integer;
    FDisplay: TColumnDisplay;
    FDrawingOptions: TDrawingOptions;
    FEditor: TNxCustomEdit;
    FEnabled: Boolean;
    FFont: TFont;
    FFooter: TColumnFooter;
    FHeader: TColumnHeader;
    FInplaceEdit: TNxCustomEdit;
    FInput: Boolean;
    FInputCaption: WideString;
    FInputValue: WideString;
    FLeft: Integer;
    FNotifyList: TList;
    FOptions: TColumnOptions;
    FParentCellColor: Boolean;
    FParentFont: Boolean;
    FParentFontUpdating: Boolean;
    FPlay: TColumnPlay;
    FPosition: Integer;
    FSilentWidth: Integer;
    FSlideBounds: TNxSlideBounds;
    FSlideCaption: TCaption;
    FSlideCaptionLocation: TSlideCatpionLocation;
    FSorted: Boolean;
    FSortKind: TSortKind;
    FSortType: TSortType;
    FTempFooterValue: Double;
    FVerticalAlignment: TVerticalAlignment;
    FVisible: Boolean;
    FVisibleIndex: Integer;
    FWidth: Integer;
    FWrapKind: TWrapKind;
    FStyleClass: string;
    FMinWidth: Integer;
    FPadding: Integer;
    FSlideOptions: TSlideOptions;
    FSlideAnchors: TAnchors;
    FObjectReference: TObject;
    FOnGetDrawText: TColumnGetTextEvent;
    FOnSetCell: TDrawCellEvent;
    FTagString: WideString;
    function GetAbsoluteLeft: Integer;
    function GetClientRect: TRect;
    function GetEditing: boolean;
    function GetFirst: Boolean;
    function GetFocused: Boolean;
    function GetGridComponent: TComponent;
    function GetHover: Boolean;
    function GetIndex: Integer;
    function GetLast: Boolean;
    function GetLocation: TColumnLocation;
    function GetNextColumn: TNxCustomColumn;
    function GetPrevColumn: TNxCustomColumn;
    function GetSelected: Boolean;
    function GetSlideRect: TRect;
    function GetSlideWidth: Integer;
    function IsFontStored: Boolean;
    procedure DestroyNotifications;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetBiDiMode(const Value: TBiDiMode);
    procedure SetColor(const Value: TColor);
    procedure SetCursor(const Value: TCursor);
    procedure SetDefaultValue(const Value: WideString);
    procedure SetDefaultWidth(const Value: Integer);
    procedure SetDrawingOptions(const Value: TDrawingOptions);
    procedure SetEditing(const Value: boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetFont(const Value: TFont);
    procedure SetFooter(const Value: TColumnFooter);
    procedure SetHeader(const Value: TColumnHeader);
    procedure SetIndex(const Value: Integer);
    procedure SetInplaceEdit(const Value: TNxCustomEdit);
    procedure SetInputCaption(const Value: WideString);
    procedure SetInputValue(const Value: WideString);
    procedure SetMinWidth(const Value: Integer);
    procedure SetOptions(const Value: TColumnOptions);
    procedure SetPadding(const Value: Integer);
    procedure SetParentCellColor(const Value: Boolean);
    procedure SetParentFont(const Value: Boolean);
    procedure SetPosition(const Value: Integer);
    procedure SetSilentWidth(const Value: Integer);
    procedure SetSlideAnchors(const Value: TAnchors);
    procedure SetSlideBounds(const Value: TNxSlideBounds);
    procedure SetSlideCaption(const Value: TCaption);
    procedure SetSlideCaptionLocation(const Value: TSlideCatpionLocation);
    procedure SetSlideOptions(const Value: TSlideOptions);
    procedure SetSorted(const Value: Boolean);
    procedure SetSortKind(const Value: TSortKind);
    procedure SetVerticalAlignment(const Value: TVerticalAlignment);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
    procedure SetWrapKind(const Value: TWrapKind);
  protected
    function GetCellEditorClass: TCellEditorClass; virtual;
    function GetColumnDisplayClass: TColumnDisplayClass; virtual;
    function GetColumnPlayClass: TColumnPlayClass; virtual;
    function GetColumnState: TColumnState; virtual;
    function GetColumnStyle: TColumnStyle; virtual;
    procedure DoColumnPartChange(Sender: TObject);
    procedure DoFontChange(Sender: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Notify(Operation: TColumnNotifyOperation);
    procedure NotifyColumnChange(ChangeKind: TColumnChangeKind;
      Param: Integer = -1);
    procedure ReadState(Reader: TReader); override;
    procedure SetColumnType(ColumnType: TColumnType); virtual;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetParentComponent(Value: TComponent); override;
    procedure SetSortType(const Value: TSortType);
    procedure TryUpdateColumns(UpdatePositions: Boolean = False);
    property SilentWidth: Integer read FSilentWidth write SetSilentWidth;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCellBestFit(Value: WideString): Integer; virtual;
    function GetDisplayOptions: TDisplayOptions; virtual;
    function GetDrawText(Cell: TCellInfo): WideString; virtual;
    function GetHintText(Cell: TCellInfo): WideString; virtual;
    function GetInputDrawText: WideString; virtual;
    function GetInputValue: WideString; virtual;
    function GetMemberRect(ColumnMemberKind: TColumnMemberKind): TRect;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    function IsAlone: Boolean;
    function IsClipped: Boolean;
    function IsKeyValid(Key: Char): Boolean; virtual;
    procedure AdjustEditRect(const Level: Integer; var EditRect: TRect); virtual;
    procedure ApplyEditing(var Value: WideString); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; virtual;
    procedure Refresh(GridArea: TGridArea = gaNone);
    procedure RegisterNotification(ANotify: TColumnNotifyProc);
    procedure Resort;
    procedure RevertStyle;
    procedure UnregisterNotification(ANotify: TColumnNotifyProc);
    procedure UpdateEdit; virtual;
    property AbsoluteLeft: Integer read GetAbsoluteLeft;
    property ClientRect: TRect read GetClientRect;
    property Columns: TNxColumns read FColumns;
    property ColumnStyle: TColumnStyle read GetColumnStyle;
    property ColumnState: TColumnState read GetColumnState;
    property ColumnType: TColumnType read FColumnType;
    property Display: TColumnDisplay read FDisplay;
    property Editing: boolean read GetEditing write SetEditing;
    property Editor: TNxCustomEdit read FEditor;
    property First: Boolean read GetFirst;
    property Focused: Boolean read GetFocused;
    property GridComponent: TComponent read GetGridComponent;
    property Hover: Boolean read GetHover;
    property Index: Integer read GetIndex write SetIndex;
    property Input: Boolean read FInput write FInput;
    property Last: Boolean read GetLast;
    property Left: Integer read FLeft;
    property Location: TColumnLocation read GetLocation;
    property NextColumn: TNxCustomColumn read GetNextColumn;
    property Play: TColumnPlay read FPlay;
    property PrevColumn: TNxCustomColumn read GetPrevColumn;
    property Selected: Boolean read GetSelected;
    property SlideRect: TRect read GetSlideRect;
    property SlideWidth: Integer read GetSlideWidth;
    property VisibleIndex: Integer read FVisibleIndex;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoEdit: Boolean read FAutoEdit write FAutoEdit default False;
    property BiDiMode: TBiDiMode read FBiDiMode write SetBiDiMode default bdLeftToRight;
    property Color: TColor read FColor write SetColor default clWindow;
    property Cursor: TCursor read FCursor write SetCursor default crDefault;
    property DefaultValue: WideString read FDefaultValue write SetDefaultValue;
		property DefaultWidth: Integer read FDefaultWidth write SetDefaultWidth default 80;
    property DrawingOptions: TDrawingOptions read FDrawingOptions write SetDrawingOptions default doNormal;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property Footer: TColumnFooter read FFooter write SetFooter;
    property Header: TColumnHeader read FHeader write SetHeader;
    property InplaceEdit: TNxCustomEdit read FInplaceEdit write SetInplaceEdit;
    property InputCaption: WideString read FInputCaption write SetInputCaption;
    property InputValue: WideString read FInputValue write SetInputValue;
    property MinWidth: Integer read FMinWidth write SetMinWidth default 8;
    property ObjectReference: TObject read FObjectReference write FObjectReference;
    property Options: TColumnOptions read FOptions write SetOptions default [coCanClick, coCanSort, coCanInput, coPublicUsing];
    property Padding: Integer read FPadding write SetPadding default 0;
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property ParentCellColor: Boolean read FParentCellColor write SetParentCellColor default False;
    property Position: Integer read FPosition write SetPosition;
    property SlideAnchors: TAnchors read FSlideAnchors write SetSlideAnchors default [akLeft, akTop];
    property SlideBounds: TNxSlideBounds read FSlideBounds write SetSlideBounds;
    property SlideCaption: TCaption read FSlideCaption write SetSlideCaption;
    property SlideCaptionLocation: TSlideCatpionLocation read FSlideCaptionLocation write SetSlideCaptionLocation default clTop;
    property SlideOptions: TSlideOptions read FSlideOptions write SetSlideOptions default [];
    property Sorted: Boolean read FSorted write SetSorted default False;
    property SortKind: TSortKind read FSortKind write SetSortKind default skAscending;
    property SortType: TSortType read FSortType write SetSortType;
    property StyleClass: string read FStyleClass write FStyleClass;
    property Tag;
    property TagString: WideString read FTagString write FTagString;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write SetVerticalAlignment default taVerticalCenter;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read FWidth write SetWidth default 80;
    property WrapKind: TWrapKind read FWrapKind write SetWrapKind default wkEllipsis;
    { Events }
    property OnSetCell: TDrawCellEvent read FOnSetCell write FOnSetCell;
    property OnGetDrawText: TColumnGetTextEvent read FOnGetDrawText write FOnGetDrawText;
  end;

  TNxColumns = class(TComponent)
  private
    FFixedCols: Integer;
    FFixedWidth: Integer;
    FItemsList: TList;
    FLastAdded: TNxCustomColumn;
    FPositionItemsList: TList;
    FOnColumnChange: TColumnChangeEvent;
    FOnChange: TColumnsChangeEvent;
    FOnRepaint: TColumnsChangeEvent;
    function GetClientWidth: Integer;
    function GetColumn(Value: string): TNxCustomColumn;
    function GetCount: Integer;
    function GetEmpty: Boolean;
    function GetFirst: TNxCustomColumn;
    function GetLast: TNxCustomColumn;
    function GetVisibleCount: integer;
    function GetPositionItem(Index: Integer): TNxCustomColumn;
    function IsReadingState: Boolean;
    procedure DestroyItems;
    procedure SetPositionItem(Index: Integer;
      const Value: TNxCustomColumn);
    function GetFirstEnabled: TNxCustomColumn;
    function GetLastEnabled: TNxCustomColumn;
  protected
    function IsFirstEnabled(const Column: TNxCustomColumn): Boolean;
    function IsLastEnabled(const Column: TNxCustomColumn): Boolean;
    function GetItem(Index: Integer): TNxCustomColumn; virtual;
    function GetNextColumn(const Column: TNxCustomColumn): TNxCustomColumn;
    function GetPrevColumn(const Column: TNxCustomColumn): TNxCustomColumn;
    procedure DoColumnChange(AColumn: TNxCustomColumn; ChangeKind: TColumnChangeKind;
      Param: Integer = -1); dynamic;
    procedure DoChange(ChangeOpearation: TColumnsOperation; ColumnType: TColumnType;
    	Value1: Integer = -1; Value2: Integer = -1); dynamic;
    procedure DoRepaint(ChangeOpearation: TColumnsOperation; ColumnType: TColumnType;
    	Value1: Integer = -1; Value2: Integer = -1); dynamic;
		procedure DoUpdateColumns(Sender: TObject);
    procedure UpdateFixedWidth;
    procedure UpdatePositionList(AColumn: TNxCustomColumn);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(Source: TNxCustomColumn): TNxCustomColumn; overload;
    function Add(ColumnClass: TNxColumnClass; ACaption: WideString = ''): TNxCustomColumn; overload;
    procedure AddColumns(ColumnClass: TNxColumnClass; Count: Integer = 1);
    function Clipped(Column: TNxCustomColumn): Boolean;
    function Exists(const Index: Integer): Boolean;
    function IndexOf(Column: TNxCustomColumn): Integer;
    function Insert(ColumnClass: TNxColumnClass; Pos: Integer): TNxCustomColumn;
    function UniqueName(const BaseName: string): string;
    procedure AddColumn(AColumn: TNxCustomColumn); virtual;
    procedure AnchorSlides(OldWidth, NewWidth: Integer);
    procedure AutoSizeSlides(OldWidth, NewWidth: Integer);
    procedure ChangePosition(CurPosition, NewPosition: Integer);
    procedure Clear;
    procedure Delete(Index: Integer);
    function Duplicate(const Index: Integer): TNxCustomColumn;
    procedure HideAll;
    procedure InsertColumn(Column: TNxCustomColumn; Pos: Integer);
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Remove(Column: TNxCustomColumn);
    procedure ResizeColumns(Column: TNxCustomColumn = nil; UseColumn: Boolean = False);
    procedure SetFixedCols(const Value: Integer);
    procedure UpdateColumn(AColumn: TNxCustomColumn; GridArea: TGridArea);
    procedure UpdateColumns(UpdatePosition: Boolean = False);
    property ClientWidth: Integer read GetClientWidth;
    property Column[Value: string]: TNxCustomColumn read GetColumn;
    property Count: Integer read GetCount;
    property Empty: Boolean read GetEmpty;
    property First: TNxCustomColumn read GetFirst;
    property FirstEnabled: TNxCustomColumn read GetFirstEnabled;
    property FixedWidth: Integer read FFixedWidth;
    property Item[Index: Integer]: TNxCustomColumn read GetItem; default;
    property Last: TNxCustomColumn read GetLast;
    property LastAdded: TNxCustomColumn read FLastAdded;
    property LastEnabled: TNxCustomColumn read GetLastEnabled;
    property PositionItem[Index: Integer]: TNxCustomColumn read GetPositionItem write SetPositionItem;
    property VisibleCount: Integer read GetVisibleCount;
    property OnChange: TColumnsChangeEvent read FOnChange write FOnChange;
    property OnRepaint: TColumnsChangeEvent read FOnRepaint write FOnRepaint;
    property OnColumnChange: TColumnChangeEvent read FOnColumnChange write FOnColumnChange;
  end;

  TVirtualColElement = class(TPersistent)
  private
    FAsBoolean: Boolean;
		FAsDateTime: TDateTime;
    FAsFloat: Double;
    FAsInteger: Integer;
    FAsString: WideString;
    FCanvas: TCanvas;
    FClientRect: TRect;
    FColumn: TNxCustomColumn;
    FObjectReference: TObject;
    FHandle: HWND;
  public
    constructor Create(AColumn: TNxCustomColumn); virtual;
    property AsBoolean: Boolean read FAsBoolean write FAsBoolean;
		property AsDateTime: TDateTime read FAsDateTime write FAsDateTime;
    property AsFloat: Double read FAsFloat write FAsFloat;
    property AsInteger: Integer read FAsInteger write FAsInteger;
    property AsString: WideString read FAsString write FAsString;
    property ClientRect: TRect read FClientRect write FClientRect;
    property Canvas: TCanvas read FCanvas write FCanvas;
    property Column: TNxCustomColumn read FColumn write FColumn;
    property Handle: HWND read FHandle write FHandle;
    property ObjectReference: TObject read FObjectReference write FObjectReference;
  end;

  TParentRowProc = procedure(var ARow: Integer; var NextSibling: Integer) of object;

  TColumnDisplay = class(TVirtualColElement)
  private
    FChildCount: Integer;
    FExpanded: Boolean;
    FHighlighted: Boolean;
    FHighlightedTextColor: TColor;
    FImageIndex: Integer;
    FIsLast: Boolean;
    FIsParentLast: Boolean;
    FLevel: Integer;
    FOnParentRow: TParentRowProc;
    FRowIndex: Integer;
    FSelected: Boolean;
    FIsFirst: Boolean;
    procedure PrepareDrawText(const Value: WideString; var Rect: TRect;
      var Flags: Integer; Modify: Boolean);
  protected
    procedure AdjustTextRect(var R: TRect; var Flags: Integer; Text: WideString;
      VerticalAlignment: TVerticalAlignment);
    function GetTextRect: TRect; virtual;
    procedure DrawTextRect(const Value: WideString; Rect: TRect); virtual;
  public
    constructor Create(AColumn: TNxCustomColumn); override;
    procedure DrawHintMark; virtual;
    function GetContentHeight: Integer; virtual;
    function GetContentWidth: Integer; virtual;
    function GetTextSize: TSize; virtual;
    procedure Paint; virtual; abstract;
    procedure PaintBackground(CellColor: TColor; ClientCell: Boolean);
    property ChildCount: Integer read FChildCount write FChildCount;
    property Expanded: Boolean read FExpanded write FExpanded;
    property IsFirst: Boolean read FIsFirst write FIsFirst;
    property Highlighted: Boolean read FHighlighted write FHighlighted;
    property HighlightedTextColor: TColor read FHighlightedTextColor write FHighlightedTextColor;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property IsLast: Boolean read FIsLast write FIsLast;
    property IsParentLast: Boolean read FIsParentLast write FIsParentLast;
    property Level: Integer read FLevel write FLevel;
    property RowIndex: Integer read FRowIndex write FRowIndex;
    property Selected: Boolean read FSelected write FSelected;
    property OnParentRow: TParentRowProc read FOnParentRow write FOnParentRow;
  end;

  TColumnPlay = class(TVirtualColElement)
  private
    FCol: Integer;
    FLevel: Integer;
    FRow: Integer;
    FOnChange: TNotifyEvent;
    FOnExpand: TNotifyEvent;
    procedure SetCol(const Value: Integer);
    procedure SetRow(const Value: Integer);
  protected
    procedure DoChange; dynamic;
    procedure DoExpand; dynamic;
  public
    procedure KeyPress(var Key: Char); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseLeave; virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure Show; virtual;
    property Col: Integer read FCol write SetCol;
    property Level: Integer read FLevel write FLevel;
    property Row: Integer read FRow write SetRow;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnExpand: TNotifyEvent read FOnExpand write FOnExpand;
  end;         

implementation

uses
  NxCustomGrid, NxColumnClasses, NxScrollControl, NxCustomGridControl,
  NxCellClasses, Dialogs, NxDisplays;

{ TColumnPart }

constructor TColumnPart.Create(AColumn: TNxCustomColumn);
begin
  FColumn := AColumn;
  FDisplayMode := dmTextOnly;
  FDrawingOptions := doNormal;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChanged;
  FHint := '';
end;

destructor TColumnPart.Destroy;
begin
  SetLength(FCaption, 0);
  FColumn := nil;
  FreeAndNil(FGlyph);
  inherited;
end;

procedure TColumnPart.Assign(Source: TPersistent);
begin
  if Source is TColumnPart then
  begin
    Caption := TColumnPart(Source).Caption;
    Color := TColumnPart(Source).Color;
    DisplayMode := TColumnHeader(Source).DisplayMode;
    Glyph.Assign(TColumnPart(Source).Glyph);
  end else inherited Assign(Source);
end;

procedure TColumnPart.SetCaption(const Value: WideString);
begin
  FCaption := Value;
  FColumn.Notify(cnCaptionChange);
  FColumn.Refresh;
end;

procedure TColumnPart.SetColor(const Value: TColor);
begin
  FColor := Value;
  FColumn.Refresh;
end;

procedure TColumnPart.DoChange(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Sender);
end;

procedure TColumnPart.DoGlyphChanged(Sender: TObject);
begin
  (Sender as TBitmap).TransparentColor := (Sender as TBitmap).Canvas.Pixels[0, (Sender as TBitmap).Height - 1];
  (Sender as TBitmap).Transparent := True;
  DoChange(Self);
end;

procedure TColumnPart.SetDisplayMode(const Value: TDisplayMode);
begin
  FDisplayMode := Value;
  DoChange(Self);
end;

procedure TColumnPart.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  DoChange(Self);
end;

procedure TColumnPart.SetHint(const Value: WideString);
begin
  FHint := Value;
end;

procedure TColumnPart.SetDrawingOptions(const Value: TDrawingOptions);
begin
  FDrawingOptions := Value;
  DoChange(Self);
end;

{ TColumnFooter }

constructor TColumnFooter.Create(AColumn: TNxCustomColumn);
begin
  inherited;
  Color := clWindow;
  FAlignment := taLeftJustify;
  FFormulaKind := fkNone;
  FFormulaValue := 0;
  FFormatMask := '';
  FFormatMaskKind := mkText;
end;

procedure TColumnFooter.Assign(Source: TPersistent);
begin
  if Source is TColumnFooter then
  begin
    Alignment := TColumnFooter(Source).Alignment;
    DrawingOptions := TColumnFooter(Source).DrawingOptions;
    FormulaKind := TColumnFooter(Source).FormulaKind;
    FormatMask := TColumnFooter(Source).FormatMask;
    TextAfter := TColumnFooter(Source).TextBefore;
    TextBefore := TColumnFooter(Source).TextBefore;
  end else inherited Assign(Source);
end;

procedure TColumnFooter.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  FColumn.Refresh(gaFooter);
end;

procedure TColumnFooter.SetFormulaKind(const Value: TFormulaKind);
begin
  FFormulaKind := Value;
  DoChange(Self);
end;

procedure TColumnFooter.SetFormulaValue(const Value: Double);
begin
  FFormulaValue := Value;
  DoChange(Self);
end;

procedure TColumnFooter.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
  DoChange(Self);
end;

procedure TColumnFooter.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
  DoChange(Self);
end;

procedure TColumnFooter.SetTextBefore(const Value: WideString);
begin
  FTextBefore := Value;
  DoChange(Self);
end;

procedure TColumnFooter.SetFormatMaskKind(const Value: TFormatMaskKind);
begin
  FFormatMaskKind := Value;
  DoChange(Self);
end;

{ TColumnHeader }

constructor TColumnHeader.Create(AColumn: TNxCustomColumn);
begin
  inherited;
  Color := clBtnFace;
  FAlignment := taLeftJustify;
  FFont := TFont.Create;
  FFont.OnChange := DoFontChange;
  FHideArrow := True;
  FMultiLine := False;
  FOrientation := hoHorizontal;
  FParentFont := True;
end;

procedure TColumnHeader.Assign(Source: TPersistent);
begin
  if Source is TColumnHeader then
  begin
    Alignment := TColumnHeader(Source).Alignment;
    Caption := TColumnHeader(Source).Caption;
    Color := TColumnHeader(Source).Color;
    DisplayMode := TColumnHeader(Source).DisplayMode;
    Font.Assign(TColumnHeader(Source).Font);
    Glyph.Assign(TColumnHeader(Source).Glyph);
    Hint := TColumnHeader(Source).Hint;
    MultiLine := TColumnHeader(Source).MultiLine;
    Orientation := TColumnHeader(Source).Orientation;
    ParentFont := TColumnHeader(Source).ParentFont;
  end else inherited Assign(Source);
end;

procedure TColumnHeader.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  FColumn.Refresh(gaHeader);
end;

procedure TColumnHeader.SetMultiLine(const Value: Boolean);
begin
  FMultiLine := Value;
  FColumn.Refresh(gaHeader);
end;

procedure TColumnHeader.SetOrientation(const Value: THeaderOrientation);
begin
  FOrientation := Value;
  FColumn.Refresh(gaHeader);
end;

procedure TColumnHeader.SetHideArrow(const Value: Boolean);
begin
  FHideArrow := Value;
  FColumn.Refresh(gaHeader);
end;

procedure TColumnHeader.DoFontChange(Sender: TObject);
begin
  if not ParentFont then DoChange(Self);
end;

procedure TColumnHeader.SetParentFont(const Value: Boolean);
begin
  if Value <> FParentFont then
  begin
    FParentFont := Value;
    DoChange(Self);
  end;
end;

procedure TColumnHeader.SetFont(const Value: TFont);
begin
  if Value <> FFont then
  begin
    FFont.Assign(Value);
    if FParentFont then DoChange(Self);
  end;
end;

destructor TColumnHeader.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

{ TNxSlideBounds }

constructor TNxSlideBounds.Create(AOwner: TNxCustomColumn);
begin
  FOwner := AOwner;
  FHeight := 16;
  FLeft := 8;
  FTop := 8;
  FWidth := 80;
end;

procedure TNxSlideBounds.Assign(Source: TPersistent);
begin
  if Source is TNxSlideBounds then
  begin
    Height := TNxSlideBounds(Source).Height;
    Left := TNxSlideBounds(Source).Left;
    Top := TNxSlideBounds(Source).Top;
    Width := TNxSlideBounds(Source).Width;
  end
  else inherited Assign(Source);
end;

function TNxSlideBounds.GetBottom: Integer;
begin
  Result := Top + Height;
end;

function TNxSlideBounds.GetRight: Integer;
begin
  Result := Left + Width;
end;

procedure TNxSlideBounds.SetHeight(const Value: Integer);
begin
  if Value <> FHeight then
  begin
    FHeight := Value;
    FOwner.NotifyColumnChange(ccSlideChanged);
  end;
end;

procedure TNxSlideBounds.SetLeft(const Value: Integer);
begin
  FLeft := Value;
  FOwner.NotifyColumnChange(ccSlideChanged);
end;

procedure TNxSlideBounds.SetTop(const Value: Integer);
begin
  FTop := Value;
  FOwner.NotifyColumnChange(ccSlideChanged);
end;

procedure TNxSlideBounds.SetWidth(const Value: Integer);
begin
  if Value <> FWidth then
  begin
    FWidth := Value;
    FOwner.NotifyColumnChange(ccSlideChanged);
  end;
end;

{ TNxCustomColumn }

constructor TNxCustomColumn.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taLeftJustify;
  FAutoEdit := False;
  if GetCellEditorClass <> nil then
  begin
    FEditor := GetCellEditorClass.Create(Self);
    FEditor.Visible := False;
  end;
  FCursor := crDefault;
  FDisplay := GetColumnDisplayClass.Create(Self);
  if GetColumnPlayClass <> nil then FPlay := GetColumnPlayClass.Create(Self);
  FDrawingOptions := doNormal;
  FDefaultWidth := 80;
  FEnabled := True;
  FColor := clWindow;
  FFont := TFont.Create;
  FFont.OnChange := DoFontChange;
  FFooter := TColumnFooter.Create(Self);
  FFooter.OnChange := DoColumnPartChange;
  FHeader := TColumnHeader.Create(Self);
  FHeader.OnChange := DoColumnPartChange;
  FInplaceEdit := nil;
  FInput := False;
  FInputCaption := '';
  FLeft := 0;
  FMinWidth := 8;
  FOptions := [coCanClick, coCanSort, coCanInput, coPublicUsing];
  FPadding := 0;
  FParentCellColor := False;
  FParentFont := True;
  FParentFontUpdating := False;
  FPosition := -1;
  FSlideAnchors := [akLeft, akTop];
  FSlideBounds := TNxSlideBounds.Create(Self);
  FSlideCaption := '';
  FSlideCaptionLocation := clTop;
  FSorted := False;
  FSortKind := skAscending;
  FSortType := stAlphabetic;
  FTagString := EmptyStr;
  FTempFooterValue := 0;
  FVerticalAlignment := taVerticalCenter;
  FVisible := True;
  FWidth := 80;
  FWrapKind := wkEllipsis;
  SetColumnType(ctString);
end;

destructor TNxCustomColumn.Destroy;
begin
  if FColumns <> nil then begin
    FColumns.Remove(Self);
  end;
  FreeAndNil(FEditor);
  FreeAndNil(FFont);
  FreeAndNil(FFooter);
  FreeAndNil(FHeader);
  FreeAndNil(FSlideBounds);
  if Assigned(FDisplay) then FreeAndNil(FDisplay);
  if Assigned(FPlay) then FreeAndNil(FPlay);
  DestroyNotifications;
  inherited;
end;

procedure TNxCustomColumn.AdjustEditRect(const Level: Integer;
  var EditRect: TRect);
begin

end;

procedure TNxCustomColumn.ApplyEditing(var Value: WideString);
begin

end;

procedure TNxCustomColumn.Assign(Source: TPersistent);
begin
  if Source is TNxCustomColumn then
  begin
    Alignment := TNxCustomColumn(Source).Alignment;
    AutoEdit := TNxCustomColumn(Source).AutoEdit;
    Color := TNxCustomColumn(Source).Color;
    Cursor := TNxCustomColumn(Source).Cursor;
    DefaultValue := TNxCustomColumn(Source).DefaultValue;
    DrawingOptions := TNxCustomColumn(Source).DrawingOptions;
    Font := TNxCustomColumn(Source).Font;
    Footer.Assign(TNxCustomColumn(Source).Footer);
    Header.Assign(TNxCustomColumn(Source).Header);
    InputCaption := TNxCustomColumn(Source).InputCaption;
    InputValue := TNxCustomColumn(Source).InputValue;
    Options := TNxCustomColumn(Source).Options;
    ParentFont := TNxCustomColumn(Source).ParentFont;
    Position := TNxCustomColumn(Source).Position;
    SlideBounds.Assign(TNxCustomColumn(Source).SlideBounds);
    Sorted := TNxCustomColumn(Source).Sorted;
    SortKind := TNxCustomColumn(Source).SortKind;
    VerticalAlignment := TNxCustomColumn(Source).VerticalAlignment;
    Visible := TNxCustomColumn(Source).Visible;
    Width := TNxCustomColumn(Source).Width;
    WrapKind := TNxCustomColumn(Source).WrapKind;
  end else inherited Assign(Source);
end;

function TNxCustomColumn.GetAbsoluteLeft: Integer;
begin
  with FColumns.Owner as TNxCustomGrid do
    if Position >= FixedCols
      then Result := Self.Left - HorzScrollBar.Position
      else Result := Self.Left;
end;

function TNxCustomColumn.GetClientRect: TRect;
begin
  with FColumns.Owner as TNxCustomGrid do
  begin
    Result.Left := GetAbsoluteLeft;
    Result.Top := HeaderSize;
    Result.Right := Result.Left + Self.Width;
    Result.Bottom := ClientHeight - HeaderSize - 4;
  end;
end;

function TNxCustomColumn.GetFirst: Boolean;
begin
  Result := FColumns.IsFirstEnabled(Self);
end;

function TNxCustomColumn.GetFocused: Boolean;
begin
  Result := Self = TNxCustomGrid(FColumns.Owner).FocusedColumn;
end;

function TNxCustomColumn.GetGridComponent: TComponent;
begin
  Result := FColumns.Owner;
end;

function TNxCustomColumn.GetHover: Boolean;
begin
  Result := Self = TNxCustomGrid(FColumns.Owner).HoverColumn;
end;

function TNxCustomColumn.GetIndex: Integer;
begin
  Result := FColumns.FItemsList.IndexOf(Self);
end;

function TNxCustomColumn.GetLast: Boolean;
begin
  Result := FColumns.IsLastEnabled(Self);
end;

function TNxCustomColumn.GetLocation: TColumnLocation;
begin
  if FColumns.VisibleCount = 1 then Result := clAlone else
  begin
    if VisibleIndex = 0
      then Result := clLeftSide
        else if VisibleIndex = FColumns.VisibleCount - 1 then Result := clRightSide
          else Result := clMiddle;
      end;
end;

function TNxCustomColumn.GetNextColumn: TNxCustomColumn;
begin
  Result := FColumns.GetNextColumn(Self);
end;

function TNxCustomColumn.GetPrevColumn: TNxCustomColumn;
begin
  Result := FColumns.GetPrevColumn(Self);
end;

function TNxCustomColumn.GetSelected: Boolean;
begin
  Result := Index = TNxCustomGrid(FColumns.Owner).SelectedColumn;
end;

function TNxCustomColumn.GetSlideRect: TRect;
begin
  Result := Rect(SlideBounds.Left, SlideBounds.Top, SlideBounds.Right, SlideBounds.Bottom);
end;

procedure TNxCustomColumn.DestroyNotifications;
var
  I: Integer;
begin
  if FNotifyList <> nil then begin
    for I := FNotifyList.Count - 1 downto 0 do
      Dispose(PColumnNotifyProc(FNotifyList[I]));
    FreeAndNil(FNotifyList);
  end;
end;

procedure TNxCustomColumn.DoColumnPartChange(Sender: TObject);
begin
  { occur when Header or Footer is changed }
  if Assigned(FColumns) then FColumns.DoColumnChange(Self, ccUndefined);
end;

procedure TNxCustomColumn.DoFontChange(Sender: TObject);
begin
  if FParentFontUpdating then Exit;
  ParentFont := False;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.ReadState(Reader: TReader);
begin
  { Here Column read itself from dfm file
    and we need to save this informations }
	inherited;
  if Reader.Parent is TNxCustomGrid then
  begin
    if FColumns <> nil then
    begin
      FColumns.UpdatePositionList(Self);
      FColumns.UpdateColumns(False);
    end;
  end;
end;

procedure TNxCustomColumn.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Notify(ccAlignChange);
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetBiDiMode(const Value: TBiDiMode);
begin
  FBiDiMode := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetColor(const Value: TColor);
begin
  FColor := Value;
  Notify(cnColorChange);
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetCursor(const Value: TCursor);
begin
  FCursor := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetDefaultValue(const Value: WideString);
begin
  FDefaultValue := Value;
end;

procedure TNxCustomColumn.SetDrawingOptions(const Value: TDrawingOptions);
begin
  FDrawingOptions := Value;
  Notify(ccDrawingChange);
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetFont(const Value: TFont);
begin
  if Assigned(Value) then
  begin
    FFont.Assign(Value);
    NotifyColumnChange(ccUndefined);
  end;
end;

procedure TNxCustomColumn.SetFooter(const Value: TColumnFooter);
begin
  FFooter := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetHeader(const Value: TColumnHeader);
begin
  FHeader := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetIndex(const Value: Integer);
begin
  if Value <> GetIndex then FColumns.Move(GetIndex, Value);
end;

procedure TNxCustomColumn.SetInplaceEdit(const Value: TNxCustomEdit);
begin
  if FInplaceEdit <> Value then
  begin
    if Assigned(FInplaceEdit) then RemoveFreeNotification(FInplaceEdit);
    FInplaceEdit := Value;
    if Assigned(FInplaceEdit) then FreeNotification(FInplaceEdit);
  end;
end;

procedure TNxCustomColumn.SetInputCaption(const Value: WideString);
begin
  FInputCaption := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetInputValue(const Value: WideString);
begin
  FInputValue := Value;
  NotifyColumnChange(ccInputChange);
end;

procedure TNxCustomColumn.SetMinWidth(const Value: Integer);
begin
  FMinWidth := Value;
end;

procedure TNxCustomColumn.SetOptions(const Value: TColumnOptions);
var
	i: Integer;
  AutoSized: Boolean;
begin
	{ exclude coSearchColumn for other columns }
  if (coSearchColumn in Value) and (not (coSearchColumn in FOptions)) then
		for i := 0 to FColumns.Count - 1 do
			if FColumns[i] <> Self then FColumns[i].FOptions := FColumns[i].FOptions - [coSearchColumn];

  AutoSized := (coAutoSize in FOptions) and (coAutoSize in Value);
  FOptions := Value;

  if Assigned(FColumns) and (not FColumns.IsReadingState) then
  begin
    if not AutoSized then FColumns.ResizeColumns(Self, True);
    NotifyColumnChange(ccUndefined);
    Notify(cnColorChange);
  end;
end;

procedure TNxCustomColumn.SetParentFont(const Value: Boolean);
begin
  FParentFont := Value;
  if Value and (Assigned(FColumns)) then
  begin
    FParentFontUpdating := True;
    FFont.Assign(TNxCustomGrid(FColumns.Owner).Font);
    FParentFontUpdating := False;
  end;
end;

procedure TNxCustomColumn.SetSortType(const Value: TSortType);
begin
  FSortType := Value;
  NotifyColumnChange(ccSortTypeChange);
end;

procedure TNxCustomColumn.SetPosition(const Value: Integer);
begin
  if (Assigned(FColumns)) and (not (csReading in ComponentState)) and (not FColumns.IsReadingState) then
  begin
    FColumns.ChangePosition(Position, Value);
    NotifyColumnChange(ccPosition);
  end;
	FPosition := Value;
end;

procedure TNxCustomColumn.SetSilentWidth(const Value: Integer);
var
  FDelta: Integer;
begin
  FSilentWidth := Value;
  if FSilentWidth < FMinWidth then FSilentWidth := FMinWidth;
  FDelta := FSilentWidth - FWidth;
  FWidth := FSilentWidth;
  if Assigned(FColumns) and (not(csReading in ComponentState))
    then FColumns.UpdateColumns; { adjust left property for columns }
  NotifyColumnChange(ccWidth, FDelta); { refresh column }
end;

procedure TNxCustomColumn.SetSlideBounds(const Value: TNxSlideBounds);
begin
  FSlideBounds := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetSlideCaption(const Value: TCaption);
begin
  FSlideCaption := Value;
  Refresh;
end;

procedure TNxCustomColumn.SetSorted(const Value: Boolean);
var
  i: Integer;
begin
  if not(csDisableSorting in ColumnStyle) then
    if Value then
    begin
      for i := 0 to FColumns.Count - 1 do if FColumns[i].FSorted then FColumns[i].Sorted := False;
      FSorted := Value;
      NotifyColumnChange(ccSorted);
    end else
    begin
      FSorted := Value;
      NotifyColumnChange(ccUnsorted);
    end;
end;

procedure TNxCustomColumn.SetSortKind(const Value: TSortKind);
begin
  FSortKind := Value;
  NotifyColumnChange(ccSortTypeChange);
end;

procedure TNxCustomColumn.SetVerticalAlignment(const Value: TVerticalAlignment);
begin
  FVerticalAlignment := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Notify(ccVisibleChange);
    NotifyColumnChange(ccVisible); { Update HorzScrollBar }
    if Assigned(FColumns) and (not(csReading in ComponentState)) then
    begin
      TryUpdateColumns(False);
      FColumns.ResizeColumns;
    end;
  end;
end;

procedure TNxCustomColumn.SetWidth(const Value: Integer);
begin
  SilentWidth := Value;
  if Assigned(FColumns) then
  begin
    FColumns.ResizeColumns(Self);
    if csDesigning in FColumns.Owner.ComponentState
      then FDefaultWidth := FWidth;
  end;
end;

procedure TNxCustomColumn.SetWrapKind(const Value: TWrapKind);
begin
  FWrapKind := Value;
  Refresh(gaBody);
end;

function TNxCustomColumn.GetCellBestFit(Value: WideString): Integer;
begin
  Result := Display.Canvas.TextWidth(Value);
  Inc(Result, 6);
  if Result < 8 then Result := 8;
end;

function TNxCustomColumn.GetDisplayOptions: TDisplayOptions;
begin
  Result := [];
end;

function TNxCustomColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := Cell.AsString;
  { Event }
  if Assigned(OnGetDrawText) then OnGetDrawText(Self, Result);
end;

function TNxCustomColumn.GetHintText(Cell: TCellInfo): WideString;
begin
  Result := GetDrawText(Cell);
end;

function TNxCustomColumn.GetInputDrawText: WideString;
begin
  Result := FInputValue;
  { Column (e.g. ListColumn) may override this method
    to draw value text different }
end;

function TNxCustomColumn.GetMemberRect(
  ColumnMemberKind: TColumnMemberKind): TRect;
begin
  with FColumns.Owner as TNxCustomGrid do
    case ColumnMemberKind of
      ckFooter: Result := Rect(GetAbsoluteLeft, GetFooterRect.Top + sizFooterSplitter, GetAbsoluteLeft + Self.Width, GetFooterRect.Bottom);
      ckHeader: Result := Rect(GetAbsoluteLeft, GetHeaderRect.Top, GetAbsoluteLeft + Self.Width, GetHeaderRect.Bottom);
      ckInput: Result := Rect(GetAbsoluteLeft, GetInputRect.Top, GetAbsoluteLeft + Self.Width, GetInputRect.Bottom - sizInputSplitter);
    end;
end;

function TNxCustomColumn.GetParentComponent: TComponent;
begin
  { nil by default in TComponent }
  Result := FColumns.Owner;
end;

function TNxCustomColumn.HasParent: Boolean;
begin
  Result := True;
end;

function TNxCustomColumn.IsAlone: Boolean;
begin
  Result := FColumns.VisibleCount = 1;
end;

function TNxCustomColumn.IsClipped: Boolean;
begin
  Result := FColumns.Clipped(Self);
end;

function TNxCustomColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := nil;
end;

function TNxCustomColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := nil;
end;

function TNxCustomColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := nil;
end;

function TNxCustomColumn.GetColumnState: TColumnState;
begin
  Result := [];
  if Enabled and ((csCanEdit in ColumnStyle) or (FInplaceEdit <> nil)) then
  begin
    if coEditing in Options then Include(Result, ceEditable);
    if coCanInput in Options then Include(Result, ceCanInput);
  end;
end;

function TNxCustomColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [];
end;

procedure TNxCustomColumn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FInplaceEdit) and (Operation = opRemove)
    then FInplaceEdit := nil;
end;

procedure TNxCustomColumn.Notify(Operation: TColumnNotifyOperation);
var
  I: Integer;
  P: PColumnNotifyProc;
  Proc: TColumnNotifyProc;
begin
  if FNotifyList <> nil then begin
    for I := 0 to FNotifyList.Count - 1 do
    begin
      P := FNotifyList.Items[I];
      Proc := P^;
      Proc(Self, Operation);
    end;
  end;
end;

procedure TNxCustomColumn.NotifyColumnChange(ChangeKind: TColumnChangeKind;
  Param: Integer = -1);
begin
	if Assigned(FColumns) then FColumns.DoColumnChange(Self, ChangeKind, Param);
end;

procedure TNxCustomColumn.TryUpdateColumns(UpdatePositions: Boolean);
begin
	if Assigned(FColumns) then FColumns.UpdateColumns(UpdatePositions);
end;

procedure TNxCustomColumn.RegisterNotification(ANotify: TColumnNotifyProc);
var
  Data: PColumnNotifyProc;
begin
  if FNotifyList = nil then FNotifyList := TList.Create;
  FNotifyList.Expand;
  New(Data);
  Data^ := ANotify;
  FNotifyList.Add(Data);
end;

procedure TNxCustomColumn.Refresh(GridArea: TGridArea);
begin
	if Assigned(FColumns) then FColumns.UpdateColumn(Self, GridArea);
end;

procedure TNxCustomColumn.UnregisterNotification(ANotify: TColumnNotifyProc);
var
  P: PColumnNotifyProc;
  Proc: TColumnNotifyProc;
  I: Integer;
begin
  if FNotifyList = nil then Exit;
  for i := FNotifyList.Count - 1 downto 0 do begin
    P := FNotifyList[i];
    Proc := P^;
    if (TMethod(Proc).Code = TMethod(ANotify).Code) and
      (TMethod(Proc).Data = TMethod(ANotify).Data) then FNotifyList.Delete(i);
  end;
end;

procedure TNxCustomColumn.SetColumnType(ColumnType: TColumnType);
begin
  FColumnType := ColumnType;
end;

procedure TNxCustomColumn.SetName(const NewName: TComponentName);
begin
  if Name <> NewName then begin
    inherited;
    Notify(cnCaptionChange);
  end;
end;

procedure TNxCustomColumn.SetParentComponent(Value: TComponent);
begin
  if Value is TNxCustomGrid then
  begin
    FColumns := TNxCustomGrid(Value).Columns;
    FColumns.FItemsList.Add(Self);
    FColumns.DoChange(opAdd, ctNone);
  end;
end;

procedure TNxCustomColumn.SetDefaultWidth(const Value: Integer);
begin
  FDefaultWidth := Value;
end;

function TNxCustomColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := False;
end;

procedure TNxCustomColumn.BeginEditing;
begin
  FEditor.EditorUpdating := True;
  FEditor.Alignment := Alignment;
  FEditor.BorderStyle := bsNone;
  FEditor.BorderWidth := 0;
  FEditor.EditMargins.Left := 1;
end;

procedure TNxCustomColumn.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

function TNxCustomColumn.GetSlideWidth: Integer;
begin
  Result := FSlideBounds.Right - FSlideBounds.Left;
end;

procedure TNxCustomColumn.Resort;
begin
  NotifyColumnChange(ccSorted);
end;

procedure TNxCustomColumn.RevertStyle;
begin
  NotifyColumnChange(ccRevertStyle);
end;

procedure TNxCustomColumn.SetSlideCaptionLocation(
  const Value: TSlideCatpionLocation);
begin
  FSlideCaptionLocation := Value;
  NotifyColumnChange(ccUndefined);
end;

procedure TNxCustomColumn.SetParentCellColor(const Value: Boolean);
begin
  FParentCellColor := Value;
  Refresh(gaBody);
end;

procedure TNxCustomColumn.UpdateEdit;
begin

end;

procedure TNxCustomColumn.SetPadding(const Value: Integer);
begin
  FPadding := Value;
  Refresh(gaBody);
end;

function TNxCustomColumn.GetInputValue: WideString;
begin
  Result := InputValue;
end;

function TNxCustomColumn.GetEditing: boolean;
begin
  Result := coEditing in Options;
end;

procedure TNxCustomColumn.SetEditing(const Value: boolean);
begin
  if Value then
    Options := Options + [coEditing]
  else
    Options := Options - [coEditing];
end;

procedure TNxCustomColumn.SetSlideOptions(const Value: TSlideOptions);
begin
  FSlideOptions := Value;
  NotifyColumnChange(ccSlideChanged);
end;

procedure TNxCustomColumn.SetSlideAnchors(const Value: TAnchors);
begin
  FSlideAnchors := Value;
end;

function TNxCustomColumn.IsFontStored: Boolean;
begin
  Result := not FParentFont;
end;

{ TNxColumns }

constructor TNxColumns.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItemsList := TList.Create;
  FLastAdded := nil;
  FPositionItemsList := TList.Create;
  TNxCustomGrid(Owner).OnUpdateColumns := DoUpdateColumns;
end;

destructor TNxColumns.Destroy;
begin
  DestroyItems;
  FreeAndNil(FItemsList);
  FreeAndNil(FPositionItemsList);
  inherited;
end;

procedure TNxColumns.DestroyItems;
var
  I: Integer;
begin
  for I := FItemsList.Count - 1 downto 0 do
    Item[I].Free;
end;

function TNxColumns.GetClientWidth: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to GetCount - 1 do if Item[i].Visible then Result := Result + Item[i].FWidth;
end;

function TNxColumns.GetCount: Integer;
begin
  Result := FItemsList.Count;
end;

function TNxColumns.GetEmpty: Boolean;
begin
  Result := FItemsList.Count = 0;
end;

function TNxColumns.GetFirst: TNxCustomColumn;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FPositionItemsList.Count - 1 do
    if PositionItem[i].Visible then
    begin
      Result := PositionItem[i];
      Exit;
    end;
end;

function TNxColumns.GetFirstEnabled: TNxCustomColumn;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FPositionItemsList.Count - 1 do
    if PositionItem[i].Visible and PositionItem[i].Enabled then
    begin
      Result := PositionItem[i];
      Exit;
    end;
end;

function TNxColumns.GetLast: TNxCustomColumn;
var
  i: Integer;
begin
  Result := nil;
  for i := FPositionItemsList.Count - 1 downto 0 do
    if PositionItem[i].Visible then
    begin
      Result := PositionItem[i];
      Exit;
    end;
end;

function TNxColumns.GetLastEnabled: TNxCustomColumn;
var
  i: Integer;
begin
  Result := nil;
  for i := FPositionItemsList.Count - 1 downto 0 do
    if PositionItem[i].Visible and PositionItem[i].Enabled then
    begin
      Result := PositionItem[i];
      Exit;
    end;
end;

function TNxColumns.GetItem(Index: Integer): TNxCustomColumn;
begin
  Result := TNxCustomColumn(FItemsList[Index]);
end;

function TNxColumns.GetNextColumn(
  const Column: TNxCustomColumn): TNxCustomColumn;
var
  i, Pos: Integer;
begin
  Pos := FPositionItemsList.IndexOf(Column);
  Result := Column;
  for i := Pos to FPositionItemsList.Count - 1 do
    if (PositionItem[i] <> Column) and (PositionItem[i].Enabled) and (PositionItem[i].Visible) then
    begin
      Result := PositionItem[i];
      Exit;
    end;
end;

function TNxColumns.GetPrevColumn(
  const Column: TNxCustomColumn): TNxCustomColumn;
var
  i, Pos: Integer;
begin
  Pos := FPositionItemsList.IndexOf(Column);
  Result := Column;
  for i := Pos downto 0 do
    if (PositionItem[i] <> Column) and (PositionItem[i].Enabled) and (PositionItem[i].Visible) then
    begin
      Result := PositionItem[i];
      Exit;
    end;
end;

function TNxColumns.GetPositionItem(Index: Integer): TNxCustomColumn;
begin
  Result := TNxCustomColumn(FPositionItemsList[Index]);
end;

function TNxColumns.GetVisibleCount: integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to GetCount - 1 do
    if Item[i].Visible then Inc(Result);
end;

function TNxColumns.IsFirstEnabled(const Column: TNxCustomColumn): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FPositionItemsList.Count - 1 do
  begin
    if PositionItem[i].Visible and PositionItem[i].Enabled then
    begin
      if PositionItem[i] = Column then Result := True;
      Exit;
    end;
  end;
end;

function TNxColumns.IsLastEnabled(const Column: TNxCustomColumn): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := FPositionItemsList.Count - 1 downto 0 do
  begin
    if PositionItem[i].Visible and PositionItem[i].Enabled then
    begin
      if PositionItem[i] = Column then Result := True;
      Exit;
    end;
  end;
end;

function TNxColumns.IsReadingState: Boolean;
var
  Grid: TNxCustomGrid;
begin
  Grid := TNxCustomGrid(Owner);
  if csReading in Grid.ComponentState then Result := True else Result := False;
end;

procedure TNxColumns.DoChange(ChangeOpearation: TColumnsOperation;  ColumnType: TColumnType;
	Value1, Value2: Integer);
begin
  if Assigned(FOnChange) then FOnChange(Self, ChangeOpearation, Value1, Value2);
end;

procedure TNxColumns.DoRepaint(ChangeOpearation: TColumnsOperation;
  ColumnType: TColumnType; Value1, Value2: Integer);
begin
  if Assigned(FOnRepaint) then FOnRepaint(Self, ChangeOpearation, Value1, Value2);
end;

procedure TNxColumns.DoColumnChange(AColumn: TNxCustomColumn; ChangeKind: TColumnChangeKind;
  Param: Integer = -1);
begin
  if Assigned(FOnColumnChange) then FOnColumnChange(Self, AColumn, ChangeKind, Param);
end;

procedure TNxColumns.DoUpdateColumns(Sender: TObject);
begin
  UpdateColumns;
end;

function TNxColumns.Duplicate(const Index: Integer): TNxCustomColumn;
begin
  Result := nil;
  if Exists(Index) then
  begin
    Result := TNxColumnClass(Item[Index].ClassType).Create(Owner);

    Result.Assign(Item[Index]);

    AddColumn(Result);
  end;
end;

procedure TNxColumns.UpdateColumns(UpdatePosition: Boolean);
var
  i, c, Pos: Integer;
begin
  with Owner as TNxCustomGrid do
  begin
    UpdateFixedWidth;
    Pos := GetBodyRect.Left;

    c := 0;
    for i := 0 to Count - 1 do
    begin
      if PositionItem[i].Visible then
      begin
        PositionItem[i].FLeft := Pos;
        PositionItem[i].FVisibleIndex := c;
        Inc(Pos, PositionItem[i].Width);
        Inc(c);
      end else PositionItem[i].FVisibleIndex := -1;
      if UpdatePosition then PositionItem[i].FPosition := i;
    end;
  end; { Owner }
  { Add Event }
end;

procedure TNxColumns.UpdateFixedWidth;
var
  i: Integer;
begin
  i := 0;
  FFixedWidth := 0;
  while (i < Count) and (i < FFixedCols) do
  begin
    if PositionItem[i].Visible then
      Inc(FFixedWidth, PositionItem[i].Width);
    Inc(i);
  end;
end;

procedure TNxColumns.UpdatePositionList(AColumn: TNxCustomColumn);
var
	i: Integer;
begin
  { note: this method shift column on right position }
  if FPositionItemsList.Count > 0 then
		for i := 0 to FPositionItemsList.Count - 1 do
 		begin
      // fix by IVO GELOV
      if (AColumn.Name <> '') and (AColumn.Name = PositionItem[i].Name) then
      begin
        PositionItem[i].Assign(AColumn);
        Exit;
      end;

			if (AColumn.Position < PositionItem[i].Position) then
      begin
      	FPositionItemsList.Insert(i, AColumn);
				Exit;
      end;
	  end;
  FPositionItemsList.Add(AColumn);
end;

function TNxColumns.Add(Source: TNxCustomColumn): TNxCustomColumn;
begin
  if Assigned(Source) then
  begin
    { Create New Column with same type as Source }
    Result := Add(TNxColumnClass(Source.ClassType));

    { Copy Properties }
    Result.Assign(Source);
  end
  else Result := nil;
end;

function TNxColumns.Add(ColumnClass: TNxColumnClass;
	ACaption: WideString = ''): TNxCustomColumn;
begin
  try
    Result := ColumnClass.Create(Self);
    AddColumn(Result);
    with Owner as TNxCustomGrid do
    begin
      Result.Color := Color;
      Result.Cursor := Cursor;
      if Result.FParentFont then Result.Font.Assign(Font);
      Result.Header.Caption := ACaption;
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TNxColumns.AddColumns(ColumnClass: TNxColumnClass; Count: Integer);
var
  i: Integer;
begin
  for i := 1 to Count do
  begin
    Add(ColumnClass, '');
  end;
end;

function TNxColumns.Clipped(Column: TNxCustomColumn): Boolean;
begin
  with Owner as TNxCustomGrid do
  begin
    Result := (Column.Position >= FFixedCols) and
      ((Column.Left + Column.Width) - HorzScrollBar.Position < FFixedWidth);       
  end;
end;

function TNxColumns.Exists(const Index: Integer): Boolean;
begin
  Result := (GetCount > 0) and (Index >= 0) and (Index < GetCount);
end;

function TNxColumns.IndexOf(Column: TNxCustomColumn): Integer;
begin
  Result := FItemsList.IndexOf(Column as TNxCustomColumn);
end;

function TNxColumns.Insert(ColumnClass: TNxColumnClass; Pos: Integer): TNxCustomColumn;
begin
  Result := ColumnClass.Create(Self);
  Result.FColumns := Self;
  with Owner as TNxCustomGrid do
  begin
    Result.Color := Color;
    Result.Cursor := Cursor;
    Result.Font.Assign(Font);
  end;
  InsertColumn(Result, Pos);
end;

function TNxColumns.UniqueName(const BaseName: string): string;
var
  I: Integer;
begin
  I := 1;
  while Owner.Owner.FindComponent(BaseName + IntToStr(I)) <> nil do Inc(I);
  Result := BaseName + IntToStr(I);
end;

procedure TNxColumns.AddColumn(AColumn: TNxCustomColumn);
begin
  AColumn.FColumns := Self;
  FItemsList.Add(AColumn);
  AColumn.FPosition := FPositionItemsList.Add(AColumn);
  UpdateColumns;
  ResizeColumns;
  FLastAdded := AColumn;
  DoChange(opAdd, ctNone);
  DoRepaint(opAdd, ctNone);
end;

procedure TNxColumns.ChangePosition(CurPosition, NewPosition: Integer);
begin
  if CurPosition <> NewPosition then
  begin
    FPositionItemsList.Move(CurPosition, NewPosition);
    UpdateColumns(True);
    DoColumnChange(PositionItem[NewPosition], ccPosition, CurPosition);
  end;
end;

procedure TNxColumns.Clear;
begin
  DestroyItems;
  FItemsList.Clear;
  FPositionItemsList.Clear;
  DoChange(opClear, ctNone);
  DoRepaint(opClear, ctNone);
end;

procedure TNxColumns.Delete(Index: Integer);
var
  Column: TNxCustomColumn;
begin
  Column := FItemsList.Items[Index];
  FreeAndNil(Column); { destroy }
end;

procedure TNxColumns.HideAll;
var
  I: Integer;
begin
  for i := 0 to FItemsList.Count - 1 do
  begin
    Item[I].FVisible := False;
    Item[I].FVisibleIndex := -1;
    Item[I].FLeft := 0;
    Item[I].Notify(ccVisibleChange);
    Item[I].NotifyColumnChange(ccVisible);
  end;
  DoRepaint(opDelete, ctNone);
end;

procedure TNxColumns.InsertColumn(Column: TNxCustomColumn; Pos: Integer);
begin
  Column.FColumns := Self;
  FItemsList.Insert(Pos, Column);
  FPositionItemsList.Add(Column);
  UpdateColumns(True);
  ResizeColumns; { all columns need to be resized in order to accept new column }
  DoChange(opInsert, ctNone, Pos);
  DoRepaint(opInsert, ctNone, Pos);
end;

procedure TNxColumns.Move(CurIndex, NewIndex: Integer);
begin
  if (CurIndex < 0) or (NewIndex < 0) or (CurIndex >= GetCount) or (NewIndex >= GetCount) then Exit;
  FItemsList.Move(CurIndex, NewIndex);
  UpdateColumns;
  DoChange(opMove, ctNone, CurIndex, NewIndex);
  DoRepaint(opMove, ctNone, CurIndex, NewIndex);
end;

procedure TNxColumns.Remove(Column: TNxCustomColumn);
var
  I, P: Integer;
begin
  I := FItemsList.IndexOf(Column);
  if I <> -1 then begin
    FItemsList.Delete(I);
    DoChange(opDelete, ctNone, I);
  end;
  P := FPositionItemsList.IndexOf(Column);
  if P <> -1 then { position }
    FPositionItemsList.Delete(P);
  { note: when grid is destroying state, updating
          is skipped } 
  if not(csDestroying in Owner.ComponentState) then
  begin
    UpdateColumns(True);
    ResizeColumns;
    DoRepaint(opDelete, ctNone, I);
  end;
end;

procedure TNxColumns.AutoSizeSlides(OldWidth, NewWidth: Integer);
var
  i: Integer;
  ratio: Double;
begin
  for i := 0 to Count - 1 do
  begin
    if (soAutoSize in Item[i].SlideOptions) then
    begin
      ratio := (Item[i].SlideBounds.Width / OldWidth) * 100;
      Item[i].SlideBounds.Width := Round((NewWidth * ratio) / 100);

      ratio := (Item[i].SlideBounds.Left / OldWidth) * 100;
      Item[i].SlideBounds.Left := Round((NewWidth * ratio) / 100);
    end;
  end;
end;

procedure TNxColumns.ResizeColumns(Column: TNxCustomColumn; UseColumn: Boolean);
var
  l, d, i, s, f, v, indicator: Integer;
  ratio: Extended;
  xRemainder: extended;
  xTmpWidth: integer;
  xLastCol: TNxCustomColumn;
begin
  if IsReadingState then Exit;
  xLastCol := nil;
  if goIndicator in TNxCustomGrid(Owner).Options then indicator := sizIndicator else indicator := 0;
  if Assigned(Column) then
  begin
    if UseColumn then
    begin
      s := Column.Position;
      l := Column.Left;
    end else
    begin
      s := Column.Position + 1;
      if Column.Visible then l := Column.Left + Column.Width else l := Column.Left;
    end;
    Dec(l, indicator);
  end else
  begin
    s := 0;
    l := 0;
  end;

  { return total space ready to occupy }
  d := TNxCustomGrid(Owner).InnerWidth - l;

  f := 0; { total width of fixed columns }
  v := 0; { total width of auto size columns }

  for i := s to Count - 1 do
    with PositionItem[i] do
    begin
      if Visible then if not(coAutoSize in Options) then Inc(f, Width) else Inc(v, Width);
    end;

  { delete fixed part from available space }
  Dec(d, f);
  xRemainder := 0;
  for i := s to Count - 1 do
    with PositionItem[i] do
    begin
      if Visible and (coAutoSize in Options) then
      begin
        if v <> 0 then ratio := Width / v else ratio := 0;
        // SilentWidth := Round(d * ratio);
        xTmpWidth := Trunc(d * ratio);
        xRemainder := xRemainder + d*ratio - xTmpWidth;
        if xRemainder >= 1. then begin
        SilentWidth := xTmpWidth + 1;
        xRemainder := xRemainder - 1;
      end else
      begin
        SilentWidth := xTmpWidth;
        xLastCol := PositionItem[i];
      end;
    end;
  end;
  if xRemainder > 0.001 then
  begin
    xLastCol.SilentWidth := xLastCol.SilentWidth + 1;
  end;
end;
 
procedure TNxColumns.UpdateColumn(AColumn: TNxCustomColumn; GridArea: TGridArea);
begin
  TNxCustomGrid(Owner).RefreshColumn(AColumn, GridArea);
end;

function TNxColumns.GetColumn(Value: string): TNxCustomColumn;
var
	i: Integer;
begin
  Result := nil;
	for i := 0 to FItemsList.Count - 1 do
    if SameText(TNxCustomColumn(Item[i]).Name, Value) then
		begin
	    Result := Item[i];
  		Exit;
		end;
end;

procedure TNxColumns.SetFixedCols(const Value: Integer);
begin
  FFixedCols := Value;
  UpdateColumns;
end;

procedure TNxColumns.SetPositionItem(Index: Integer;
  const Value: TNxCustomColumn);
begin
  FPositionItemsList.Items[Index] := Value;
end;

procedure TNxColumns.AnchorSlides(OldWidth, NewWidth: Integer);
var
  i, Delta: Integer;
  Column: TNxCustomColumn;
begin
  for i := 0 to Count - 1 do
  begin
    Column := Item[i];
    if akRight in Column.SlideAnchors then
    begin
      Delta := NewWidth - OldWidth;
      if akLeft in Column.SlideAnchors then
      begin
        Column.SlideBounds.Width := Column.SlideBounds.Width + Delta;
      end else Column.SlideBounds.Left := Column.SlideBounds.Left + Delta;
    end;
  end;
end;

{ TVirtualColElement }

constructor TVirtualColElement.Create(AColumn: TNxCustomColumn);
begin
  FColumn := AColumn;
end;

{ TColumnDisplay }

procedure TColumnDisplay.AdjustTextRect(var R: TRect; var Flags: Integer;
  Text: WideString; VerticalAlignment: TVerticalAlignment);
var
  CR: TRect;
  StringText: string;
begin
  Flags := Flags or DT_TOP;
  CR := R;
  StringText := Text;
  if IsUnicodeSupported then
    DrawTextExW(Canvas.Handle, PWideChar(Text), -1, CR, Flags or DT_CALCRECT, nil)
      {$IFDEF DELPHI2009UP}
      else Windows.DrawTextEx(Canvas.Handle, PWideChar(Text), -1, CR, Flags or DT_CALCRECT, nil);
      {$ELSE}
      else Windows.DrawTextEx(Canvas.Handle, PAnsiChar(StringText), -1, CR, Flags or DT_CALCRECT, nil);
      {$ENDIF}
  case VerticalAlignment of
    taAlignTop: Flags := Flags or DT_TOP;
    taVerticalCenter: R.Top := R.Top + Round((R.Bottom - CR.Bottom ) / 2);
    taAlignBottom: R.Top := R.Bottom - (CR.Bottom - CR.Top);
  end;
end;

constructor TColumnDisplay.Create(AColumn: TNxCustomColumn);
begin
  inherited;

end;

procedure TColumnDisplay.DrawHintMark;
begin
  with Canvas do
  begin
    Pen.Color := clRed;
    Brush.Color := clRed;
 	  Polygon([Point(ClientRect.Right - 5, ClientRect.Top),
    	Point(ClientRect.Right - 1, ClientRect.Top),
      Point(ClientRect.Right - 1, ClientRect.Top + 4)]);
  end;
end;

procedure TColumnDisplay.DrawTextRect(const Value: WideString; Rect: TRect);
var
  Flags: Integer;
  StringText: string;
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    PrepareDrawText(Value, Rect, Flags, True);
    case IsUnicodeSupported of
      True:   DrawTextExW(Canvas.Handle, PWideChar(Value), Length(Value), Rect, Flags, nil);
      False:  begin
                StringText := Value;
                {$IFDEF DELPHI2009UP}
                DrawTextEx(Canvas.Handle, PWideChar(StringText), Length(StringText), Rect, Flags, nil);
                {$ELSE}
                DrawTextEx(Canvas.Handle, PAnsiChar(StringText), Length(StringText), Rect, Flags, nil);
                {$ENDIF}
              end;
    end;
    Brush.Style := bsSolid;
  end;
end;

function TColumnDisplay.GetContentHeight: Integer;
begin
  Result := 0;
end;

function TColumnDisplay.GetContentWidth: Integer;
begin
  Result := GetTextSize.cx;
end;

function TColumnDisplay.GetTextRect: TRect;
begin
  Result := TCalcProvider.ResizeRect(ClientRect, 2, 0, -2, 0);
end;

function TColumnDisplay.GetTextSize: TSize;
var
  Flags: Integer;
  Rect: TRect;
  {$IFNDEF DELPHI2009UP}
  StringText: string;
  {$ENDIF}
begin
  Rect := GetTextRect;
  PrepareDrawText(AsString, Rect, Flags, False);
  Flags := Flags or DT_NOCLIP	or DT_CALCRECT;

  if UnicodeSupported then
    DrawTextExW(Canvas.Handle, PWideChar(AsString), -1, Rect, Flags or DT_CALCRECT, nil)
  {$IFDEF DELPHI2009UP}
  else Windows.DrawTextExW(Canvas.Handle, PWideChar(AsString), -1, Rect, Flags or DT_CALCRECT, nil);
  {$ElSE}
  else begin
    StringText := AsString;
    Windows.DrawTextEx(Canvas.Handle, PAnsiChar(StringText), -1, Rect, Flags or DT_CALCRECT, nil);
  end;
  {$ENDIF}
  with Result do
  begin
    cx := Rect.Right - Rect.Left;
    cy := Rect.Bottom - Rect.Top;
  end;
end;

procedure TColumnDisplay.PaintBackground(CellColor: TColor;
  ClientCell: Boolean);
begin
  with Canvas do
  begin
    Brush.Color := CellColor;
    if ClientCell then FillRect(ClientRect) else FrameRect(ClientRect);
  end;
end;

procedure TColumnDisplay.PrepareDrawText(const Value: WideString;
  var Rect: TRect; var Flags: Integer; Modify: Boolean);
begin
  Flags := DT_NOPREFIX; { don't replace & char }
  with Column, Canvas do
  begin
    if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
    case Alignment of
      taLeftJustify: Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter: Flags := Flags or DT_CENTER;
    end;
    case VerticalAlignment of
      taAlignTop: Flags := Flags or DT_TOP;
      taVerticalCenter: Flags := Flags or DT_VCENTER;
      taAlignBottom: Flags := Flags or DT_BOTTOM;
    end;
    case WrapKind of
      wkEllipsis: if Modify then Flags := Flags or DT_END_ELLIPSIS;
      wkPathEllipsis: if Modify then Flags := Flags or DT_PATH_ELLIPSIS;
      wkWordWrap:
      begin
        Flags := Flags or DT_WORDBREAK or DT_EDITCONTROL;
      end;
    end;
    if (WrapKind <> wkWordWrap) and not (doMultiLine in Column.GetDisplayOptions) then
      Flags := Flags or DT_SINGLELINE else
    begin
      { MultiLine text need to be manualy aligned verticaly }
      if VerticalAlignment <> taAlignTop then
        AdjustTextRect(Rect, Flags, Value, VerticalAlignment);
    end;
  end;
end;

{ TColumnPlay }

procedure TColumnPlay.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TColumnPlay.DoExpand;
begin
  if Assigned(FOnExpand) then FOnExpand(Self);
end;

procedure TColumnPlay.KeyPress(var Key: Char);
begin

end;

procedure TColumnPlay.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin

end;

procedure TColumnPlay.MouseLeave;
begin

end;

procedure TColumnPlay.MouseMove(Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TColumnPlay.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin

end;

procedure TColumnPlay.SetCol(const Value: Integer);
begin
  FCol := Value;
end;

procedure TColumnPlay.SetRow(const Value: Integer);
begin
  FRow := Value;
end;

procedure TColumnPlay.Show;
begin
  AsBoolean := Column.Display.AsBoolean;
  Column.Display.Paint;
end;

end.
