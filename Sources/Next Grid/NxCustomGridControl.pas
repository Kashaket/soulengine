{
  Next Grid
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxCustomGridControl.pas bn
}

{$I '..\NxSuite.inc'}

unit NxCustomGridControl;

interface

uses
  Classes, Windows, Controls, Messages, StdCtrls, Graphics, IniFiles, Forms,
  NxScrollControl, NxColumns, NxColumnClasses, NxDisplays,
  NxSharedCommon, NxGridCommon, NxEdit, NxCellClasses, NxColumnDragBox,
  NxThemesSupport, NxVersions, NxClasses
  {$IFDEF UITYPES}, UITypes{$ENDIF}
  ;

type
  TSlideState = set of (stFocused, stSelected);
  TGridState = set of (gtColumnResizing, gtColumnHeaderDown, gtColumnMoving,
  	gtEdit, gtEditorMoving,	gtIndicatorMouseDown, gtInput,
    gtMultiSelect, gtRolling, gtRowMoving, gtHorzScrolling, gtUpdating);
  TGridStyle = (gsReport, gsSlides);
  TGridLinesStyle = (lsNormal, lsActiveHorzOnly, lsActiveRows, lsFramed, lsHorizontalOnly, lsVerticalOnly);
  TGridLinePosition = (lpLeft, lpTop, lpRight, lpBottom, lpTopBottom);
  TSelectionMoveDirection = (mdNone, mdUp, mdDown, mdLeft, mdRight);
  TAppearanceOptions = set of (ao3DGridLines, aoAlphaBlendedSelection, aoBoldTextSelection,
    aoDontFillCells, aoHideFocus, aoHideSelection, aoHighlightSlideCells, aoHintMarks, aoIndicateSelectedCell, aoIndicateSortedColumn);
  TGridOptions = set of (goArrowKeyExitEditing, goCanHideColumn, goDisableColumnMoving, goDisableKeys,
  	goEscClearEdit, goFooter,	goGrid, goHeader, goIndicator, goInput, goLockFixedCols, goMultiSelect,
    goRowResizing, goRowMoving, goSecondClickEdit, goSelectFullRow, goUseDefaultValues, goInplaceEditEvents);
  THeaderStyle = (hsAuto, hsFlatBorders, hsOffice2007, hsOffice2010, hsOldStyle, hsOutlook, hsVista);
  TRowOperation = (roAdd, roClear, roDelete, roInsert, roMove, roReserve, roRowHeight);
  TSortedStyle = (soDefault, soDarker, soWhite);
  TBestFitMode = (bfBoth, bfCells, bfHeader);
  TSlideOptions = set of (soFrame, soHideSelection);
  TNxHtmlSaveSettings = set of (hsAllRows, hsCreateStyleSheet, hsSaveHeaders,
    hsSaveFooter, hsSaveCaption);
  TInputEnterMode = (imAllways, imEditing);
  THomeEndBehaviour = (hebTopBottom, hebLeftRight);
  TDataChange = (dcAddColumn, dcAddChildRow, dcAddRow, dcInsertColumn, dcInsertRow, dcDeleteColumn, dcDeleteRow, dcClearRows);
  TMoveSelectionKey = (mkUndefined, mkArrows, mkTab, mkEnter);
  TResizeKind = (rkShrink, rkExpansion);

  TCellEvent = procedure (Sender: TObject; ACol, ARow: Integer) of object;
  TColumnEvent = procedure (Sender: TObject; ACol: Integer) of object;

  TAfterRowMoveEvent = procedure (Sender: TObject; FromPos, ToPos: Integer) of object;
  TApplyCellEvent = procedure (Sender: TObject; ACol, ARow: Integer; var Value: WideString) of object;
  TApplyEditText = procedure (Sender: TObject; ACol, ARow: Integer; var Value: WideString) of object;
  TBeforeEditEvent = procedure (Sender: TObject; ACol, ARow: Integer; var Accept: Boolean) of object;
  TCalculateRowEvent = procedure (Sender: TObject; Index: Integer; var Accept: Boolean) of object;
  TCellColoringEvent = procedure (Sender: TObject; ACol, ARow: Integer; var CellColor, GridColor: TColor; CellState: TCellState) of object;
  TCellHintEvent = procedure (Sender: TObject; ACol, ARow: Integer; var Value: WideString) of object;
  TChangeEvent = procedure (Sender: TObject; ACol, ARow: Integer) of object;
  TChangeRowHeightEvent = procedure (Sender: TObject; Index, Height: Integer) of object;
  TColumnFooterValueEvent = procedure (Sender: TObject; ACol: Integer; var Value: Double) of object;
  TColumnMoveEvent = procedure (Sender: TObject; ACol, FromPos, ToPos: Integer) of object;
  TColumnResizeEvent = procedure (Sender: TObject; ACol: Integer) of object;
  TCustomDrawCellEvent = procedure (Sender: TObject; ACol, ARow: Integer; CellRect: TRect; CellState: TCellState) of object;
  TCustomDrawFooterEvent = procedure (Sender: TObject; Index: Integer; FooterRect: TRect) of object;
  TCustomDrawHeaderEvent = procedure (Sender: TObject; Index: Integer; HeaderRect: TRect) of object;
  TCustomDrawIndicatorEvent = procedure (Sender: TObject; Index: Integer; IndicatorRect: TRect; Selected, Highlighted: Boolean) of object;
  TDrawCellBackgroundEvent = procedure (Sender: TObject; ACol, ARow: Integer; CellRect: TRect; CellState: TCellState; var DefaultDrawing: Boolean) of object;
  TEditAcceptEvent = procedure (Sender: TObject; ACol, ARow: Integer; Value: WideString; var Accept: Boolean) of object;
  TEditEvent = procedure (Sender: TObject; ACol, ARow: Integer; Value: WideString) of object;
  TEditTextEvent = procedure (Sender: TObject; ACol, ARow: Integer; var Value: WideString) of object;
  TFooterCalculateEvent = procedure (Sender: TObject; ACol: Integer; var Value: Double) of object;
  THeaderClickEvent = procedure (Sender: TObject; ACol: Integer) of object;
  TInputAcceptEvent = procedure (Sender: TObject; var Accept: Boolean) of object;
  TLoadProgressEvent = procedure (Sender: TObject; ACol, ARow: Integer) of object;
  TMeasuringRowHeightEvent = procedure (Sender: TObject; Index: Integer; var RowHeight: Integer) of object;
  TRowMoveEvent = procedure (Sender: TObject; FromPos, ToPos: Integer; var Accept: Boolean) of object;
  TScrollEvent = procedure (Sender: TObject; Kind: TScrollBarKind; var Accept: Boolean) of object;
  TSlideColoringEvent = procedure (Sender: TObject; Index: Integer; var SlideColor, GridColor: TColor; SlideState: TSlideState) of object;
  TSortColumnEvent = procedure (Sender: TObject; ACol: Integer; Ascending: Boolean) of object;
  TDataChangeEvent = procedure (Sender: TObject; AChangeType: TDataChange; const AIndex: Integer) of object;
  TSelectionMoveEvent = procedure (Sender: TObject; var ACol: Integer; ARow: Integer; Key: TMoveSelectionKey) of object;
  TEndEditingEvent = procedure (Sender: TObject; ACol, ARow: Integer; var Value: WideString; var Accept: Boolean) of object;
  TCellShowingEvent = procedure (Sender: TObject; ACol, ARow: Integer; var Showing: Boolean) of object;

  TNxCustomGridControl = class(TNxScrollControl)
  private
    FAppearanceOptions: TAppearanceOptions;
    FAutoScroll: Boolean;
    FBorderStyle: TBorderStyle;
    FCaption: WideString;
    FCurrentStyleDisplay: TStyleDisplay;
    FDefaultStyleDisplay: TStyleDisplay;
    FEditingCell: TPoint;
    FEditingDisplay: TColumnDisplay;
    FEnableVisualStyles: Boolean;
    FFixedCols: Integer;
    FFlatStyleDisplay: TStyleDisplay;
    FFooterSize: Integer;
    FFromSelected: Integer;
    FGridLinesColor: TColor;
    FGridLinesStyle: TGridLinesStyle;
    FGridSpace: array[lpLeft..lpTopBottom] of Integer;
    FGridStyle: TGridStyle;
    FHeaderSize: Integer;
    FHeaderStyle: THeaderStyle;
    FHideScrollBar: Boolean;
    FHighlightedTextColor: TColor;
    FInactiveSelectionColor: TColor;
    FIndicatorDrawingOptions: TDrawingOptions;
    FInplaceEdit: TNxCustomEdit;
    FInplaceEditUpdate: Boolean;
    FInputingColumn: Integer;
    FInputSelected: Boolean;
    FInputSize: Integer;
    FOffice2007StyleDisplay: TStyleDisplay;
    FOffice2010StyleDisplay: TStyleDisplay;
    FOldStyleDisplay: TStyleDisplay;
    FOnAfterEdit: TEditEvent;
    FOnAfterRowMove: TAfterRowMoveEvent;
    FOnAfterSort: TColumnEvent;
    FOnApplyCell: TApplyCellEvent;
    FOnApplyEditText: TApplyEditText;
    FOnBeforeEdit: TBeforeEditEvent;
    FOnBeforeScroll: TScrollEvent;
    FOnBeforeSelect: TBeforeEditEvent;
    FOnCalculateRow: TCalculateRowEvent;
		FOnCellClick: TCellEvent;
    FOnCellColoring: TCellColoringEvent;
		FOnCellDblClick: TCellEvent;
    FOnCellHint: TCellHintEvent;
    FOnCellShowing: TCellShowingEvent;
    FOnChange: TChangeEvent;
    FOnChangeRowHeight: TChangeRowHeightEvent;
    FOnColumnFooterValue: TColumnFooterValueEvent;
    FOnColumnMove: TColumnMoveEvent;
    FOnColumnResize: TColumnResizeEvent;
    FOnCustomDrawCell: TCustomDrawCellEvent;
    FOnCustomDrawFooter: TCustomDrawFooterEvent;
    FOnCustomDrawHeader: TCustomDrawHeaderEvent;
    FOnCustomDrawIndicator: TCustomDrawIndicatorEvent;
    FOnDataChange: TDataChangeEvent;
    FOnDeselectCell: TCellEvent;
    FOnDrawCellBackground: TDrawCellBackgroundEvent;
		FOnEdit: TEditEvent;
    FOnEditAccept: TEditAcceptEvent;
    FOnEditEnter: TNotifyEvent;
    FOnEditExit: TNotifyEvent;
    FOnEditText: TEditTextEvent;
    FOnEndEditing: TEndEditingEvent;
    FOnFooterCalculate: TFooterCalculateEvent;
    FOnFooterClick: THeaderClickEvent;
    FOnHeaderClick: THeaderClickEvent;
    FOnHeaderDblClick: THeaderClickEvent;
    FOnInputAccept: TInputAcceptEvent;
    FOnInputAdded: TNotifyEvent;
    FOnInputSelectCell: TColumnEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnLoadProgress: TLoadProgressEvent;
    FOnMeasuringRowHeight: TMeasuringRowHeightEvent;
    FOnPostDraw: TNotifyEvent;
    FOnRowMove: TRowMoveEvent;
    FOnSelectCell: TCellEvent;
    FOnSlideChange: TColumnEvent;
    FOnSlideColoring: TSlideColoringEvent;
    FOnSortColumn: TSortColumnEvent;
    FOnSelectionMove: TSelectionMoveEvent;
    FOnUpdateColumns: TNotifyEvent;
    FOptions: TGridOptions;
    FOutlookStyleDisplay: TStyleDisplay;
    FPaintingCell: TPoint;
    FReadOnly: Boolean;
    FRowSize: Integer;
    FSelectedColumn: Integer;
    FSelectionColor: TColor;
		FSelectionMoveDirection: TSelectionMoveDirection;
    FSlideOptions: TSlideOptions;
    FSlideSelectionColor: TColor;
    FSlideSize: Integer;
    FSortedColumn: TNxCustomColumn;
    FSortedStyle: TSortedStyle;
    FUpdateCount: Integer;
    FVersion: string;
    FVistaStyleDisplay: TStyleDisplay;
		FWantReturns: Boolean;
    FWantTabs: Boolean;
    FSlideCaptionColor: TColor;
    FInputEnterMode: TInputEnterMode;
    FHomeEndBehaviour: THomeEndBehaviour;
    FTabLeaveControl: Boolean;
    function GetCellsByName(ACol, ARow: Variant): WideString;
    function GetColumnByName(Value: string): TNxCustomColumn;
    function GetInnerWidth: Integer;
    function GetSelectedCell: TPoint;
    procedure SetAppearanceOptions(const Value: TAppearanceOptions);
    procedure SetAutoScroll(const Value: Boolean);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetCaption(const Value: WideString);
    procedure SetCellsByName(ACol, ARow: Variant; const Value: WideString);
    procedure SetEditingCell(const Value: TPoint);
    procedure SetEnableVisualStyles(const Value: Boolean);
    procedure SetFixedCols(const Value: Integer);
    procedure SetFooterSize(const Value: Integer);
    procedure SetGridLinesColor(const Value: TColor);
    procedure SetGridLinesStyle(const Value: TGridLinesStyle);
    procedure SetGridStyle(const Value: TGridStyle);
    procedure SetHeaderSize(const Value: Integer);
    procedure SetHeaderStyle(const Value: THeaderStyle);
    procedure SetHideScrollBar(const Value: Boolean);
    procedure SetHighlightedTextColor(const Value: TColor);
    procedure SetInactiveSelectionColor(const Value: TColor);
    procedure SetIndicatorDrawingOptions(const Value: TDrawingOptions);
    procedure SetInplaceEdit(const Value: TNxCustomEdit);
    procedure SetInputSelected(const Value: Boolean);
    procedure SetInputSize(const Value: Integer);
    procedure SetOptions(const Value: TGridOptions);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetSelectedColumn(const Value: Integer);
    procedure SetSelectionColor(const Value: TColor);
    procedure SetSlideOptions(const Value: TSlideOptions);
    procedure SetSlideCaptionColor(const Value: TColor);
    procedure SetSlideSelectionColor(const Value: TColor);
    procedure SetSlideSize(const Value: Integer);
    procedure SetSortedStyle(const Value: TSortedStyle);
    procedure SetVersion(const Value: string);
    procedure SetRowCount(const Value: Integer);
    function GetMultiSelect: Boolean;
    function GetEditing: Boolean;
  protected
    FColumns: TNxColumns;
    FFirstRow: Integer;
    FFirstVisibleRow: Integer;
    FFocusedColumn: TNxCustomColumn;
    FGridState: TGridState;
    FHoverColumn: TNxCustomColumn;
    FLastRow: Integer;
    FLastVisibleRow: Integer;
    FMouseDownCell: TPoint;
    FSelectedRow: Integer;
    FTheme: HTHEME;
    FVertResizeKind: TResizeKind;
    procedure CellsScrolled(Delta: Integer); virtual;
    procedure CompleteEdit(const ACol, ARow: Integer; const Value: WideString); virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function CanMoveRow(FromPos, ToPos: Integer): Boolean;
    function CanEdit: Boolean; virtual;
    function CanSelectCell(ACol, ARow: Integer): Boolean; virtual;
    function DrawCellData(ACol, ARow: Integer; CellState: TCellState): Boolean; virtual;
    function GetCaptionRect: TRect;
    function GetCellByVariant(ACol, ARow: Variant): TPoint;
    function GetCellColor(ACol, ARow: Integer): TColor; virtual;
    function GetCellHint(ACol, ARow: Integer): WideString; virtual;
    function GetCellInfo(ACol, ARow: Integer): TCellInfo; virtual; abstract;
    function GetCells(ACol, ARow: Integer): WideString; virtual; abstract;
    function GetColumnsClass: TNxColumnsClass; virtual;
    function GetDrawText(ACol, ARow: Integer): WideString; virtual; abstract;
    function GetEditingRect(IncludeGrid: Boolean = False): TRect;
    function GetFirstRow: Integer;
    function GetFirstVisibleRow: Integer; virtual; abstract;
    function GetGridSpace(Index: TGridLinePosition): Integer;
    function GetHintText(ACol, ARow: Integer): WideString; virtual; abstract;
    function GetHorzClipRect: TRect;
    function GetHorzMax: Integer; virtual;
    function GetHorzOffset(FromPos, ToPos: Integer): Integer; override;
    function GetLastRowInViewProp: Integer;
    function GetLastRowInView(Count: Integer): Integer;
    function GetLastVisibleRow: Integer; virtual; abstract;
    function GetRowCount: Integer; virtual; abstract;
    function GetRowHeight(Index: Integer): Integer; virtual;
    function GetRowImageIndex(Index: Integer): Integer; virtual;
    function GetRowLevel(Index: Integer): Integer; virtual;
    function GetRowsInRange(FromRow, ToRow: Integer): Integer;
    function GetRowVisible(Index: Integer): Boolean; virtual;
    function GetSelected(Index: Integer): Boolean; virtual; abstract;
    function GetSelectedCount: Integer; virtual;
    function GetSelectedRow: Integer; virtual;
    function GetTextStr(Separator: Char = ';'): string; virtual;
    function GetVertMax: Integer; virtual;
    function GetVertOffset(FromPos, ToPos: Integer): Integer; override;
    function GetVisibleRows: Integer; virtual; abstract;
    function IntegralHeight: Boolean; virtual;
    function IsUpdating: Boolean;
    procedure ApplyCellFormating(ACol, ARow: Integer; Value: WideString; CellState: TCellState); virtual;
    procedure ColumnsChange(ChangeOpearation: TColumnsOperation; Value1: Integer = -1;
      Value2: Integer = -1); virtual;
    procedure DoAfterEdit(ACol, ARow: Integer; Value: WideString); dynamic;
    procedure DoAfterRowMove(FromPos, ToPos: Integer); dynamic;
    procedure DoAfterSort(ACol: Integer); dynamic;
    procedure DoApplyCell(ACol, ARow: Integer; var Value: WideString); dynamic;
    procedure DoApplyEditText(ACol, ARow: Integer; var Value: WideString); dynamic;
    procedure DoBeforeEdit(ACol, ARow: Integer; var Accept: Boolean); dynamic;
    procedure DoBeforeSelect(ACol, ARow: Integer; var Accept: Boolean); dynamic;
    procedure DoCalculateRow(Index: Integer; var Accept: Boolean); dynamic;
    procedure DoCellClick(ACol, ARow: Integer); dynamic;
    procedure DoCellColoring(ACol, ARow: Integer; var CellColor, GridColor: TColor; CellState: TCellState); dynamic;
    procedure DoCellDblClick(ACol, ARow: Integer); dynamic;
    procedure DoCellHint(ACol, ARow: Integer; var Value: WideString); dynamic;
    procedure DoCellShowing(ACol, ARow: Integer; var Showing: Boolean); dynamic;
    procedure DoChange(ACol, ARow: Integer); dynamic;
    procedure DoColumnFooterValue(ACol: Integer; var Value: Double); dynamic;
    procedure DoColumnMove(ACol, FromPos, ToPos: Integer); dynamic;
    procedure DoColumnResize(ACol: Integer); dynamic;
    procedure DoCustomDrawCell(ACol, ARow: Integer; CellRect: TRect; CellState: TCellState); dynamic;
    procedure DoCustomDrawIndicator(Index: Integer; IndicatorRect: TRect; Selected, Highlighted: Boolean); dynamic;
    procedure DoDataChange(AChangeType: TDataChange; const AIndex: Integer); dynamic;
    procedure DoDeselectCell(ACol, ARow: Integer); dynamic;
		procedure DoDrawCellBackground(ACol, ARow: Integer; CellRect: TRect; CellState: TCellState; var DefaultDrawing: Boolean); dynamic;
    procedure DoEdit(ACol, ARow: Integer; Value: WideString); dynamic;
    procedure DoEditAccept(ACol, ARow: Integer; Value: WideString; var Accept: Boolean); dynamic;
    procedure DoEditEnter; dynamic;
    procedure DoEditExit; dynamic;
    procedure DoEditText(ACol, ARow: Integer; var Value: WideString); dynamic;
    procedure DoEndEditing(ACol, ARow: Integer; var Value: WideString; var Accept: Boolean); dynamic;
    procedure DoFooterCalculate(ACol: Integer; var Value: Double); dynamic;
    procedure DoFooterClick(ACol: Integer); dynamic;
    procedure DoHeaderClick(ACol: Integer); dynamic;
    procedure DoHeaderDblClick(ACol: Integer); dynamic;
    procedure DoInputAccept(var Accept: Boolean); dynamic;
    procedure DoInputAdded; dynamic;
    procedure DoInputSelectCell(ACol: Integer); dynamic;
    procedure DoMeasuringRowHeight(Index: Integer; var RowHeight: Integer); dynamic;
    procedure DoPostDraw; dynamic;
    procedure DoSelectCell(ACol, ARow: Integer); dynamic;
    procedure DoSlideChange(ACol: Integer); dynamic;
    procedure DoSlideColoring(Index: Integer; var SlideColor, GridColor: TColor; SlideState: TSlideState); dynamic;
    procedure DoSortColumn(ACol: Integer; Ascending: Boolean); dynamic;
    procedure DoColumnChange(Sender: TObject; AColumn: TNxCustomColumn;
    	ChangeKind: TColumnChangeKind; Param: Integer = -1); virtual;
    procedure DoColumnsRepaint(Sender: TObject; ChangeOpearation: TColumnsOperation;
    	Value1: Integer = -1; Value2: Integer = -1); virtual;
    procedure DoUpdateColumns; dynamic;
		procedure DoCellEditorChange(Sender: TObject);
		procedure DoCellEditorExit(Sender: TObject);
		procedure DoCellEditorEnter(Sender: TObject);
    procedure DoCellEditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoCellEditorKeyPress(Sender: TObject; var Key: Char);
    procedure DoCellEditorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoColumnsChange(Sender: TObject; ChangeOpearation: TColumnsOperation;
	    Value1: Integer = -1; Value2: Integer = -1);
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoFooterDraw(Sender: TObject; Index: Integer; Rect: TRect); virtual;
    procedure DoHeaderDraw(Sender: TObject; Index: Integer; Rect: TRect); virtual;
    procedure DoSelectionMove(var ACol: Integer; var ARow: Integer; Key: TMoveSelectionKey); dynamic;
    procedure DrawCell(ACol, ARow: Integer; CellRect: TRect); virtual;
    procedure DrawEmptyCell(ACol, ARow: Integer; CellRect: TRect);
		procedure DrawFocusCell;
    procedure DrawGrid(ACol, ARow: Integer;	ARect: TRect; LineColor: TColor);
    procedure DrawHeaders;
    procedure DrawRowIndicator(Index: Integer; Selected, Highlighted: Boolean); virtual;
    procedure DrawSlideCaption(ACol, ARow: Integer);
    procedure ExpandColumn(Column: TNxCustomColumn; Delta: Integer;
      HeadersOnly: Boolean = False);
    function GetFirstVisible(const FromRow: Integer): Integer;
    function GetLastVisible(const FromRow: Integer): Integer;
    function GetLastRow: Integer;
    function IsCalculateRow(const Index: Integer): Boolean;
    function IsCellEmpty(ACol, ARow: Integer): Boolean; virtual;
    procedure GridStyleChanged; virtual;
    procedure LoadFromIniFile(Name: WideString; IniFile: TCustomIniFile; ID: string);
    procedure Paint; override;
    procedure PaintReport; virtual;
    procedure PaintReportParts; virtual;
    procedure PaintReportRows; virtual;
    procedure PaintSlides; virtual;
    procedure PaintSlidesParts; virtual;
    procedure PaintSlidesRows; virtual;
    procedure PrepareEdit; virtual;
    procedure RecalculateGridSpace;
    procedure RecreateStyleDisplay;
    procedure RedrawBorder;
    procedure RefreshArea(Area: TGridArea);
    procedure RefreshCellEditor;
    procedure RefreshFromColumn(FromColumn: TNxCustomColumn);
    procedure RefreshIndicator(Index: Integer);
		procedure RefreshRect(ARect: TRect);
    procedure RefreshSelectedCells;
    procedure RefreshSelectedSlides;
    procedure RefreshVisibleRows(FromPos, ToPos: Integer);
    procedure ScrollRows(FromRow, ToRow: Integer);
    procedure SaveToIniFile(Name: WideString; IniFile: TCustomIniFile; ID: string);
    procedure SetActiveRow(const Index: Integer); virtual;
    procedure SetCells(ACol, ARow: Integer; const Value: WideString); virtual; abstract;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    procedure SetClipCellRect(ARect: TRect);
    procedure SetDisplayCell(Column: TNxCustomColumn; ACol, ARow: Integer; CellRect: TRect; CellState: TCellState);
    procedure SetDisplayParams(ACol, ARow: Integer; Display: TColumnDisplay); virtual;
    procedure SetInplaceEditEvents; virtual;
    procedure SetRowHeight(Index: Integer; const Value: Integer); virtual;
    procedure SetRowSize(const Value: Integer); virtual;
    procedure SetRowVisible(Index: Integer; const Value: Boolean); virtual;
    procedure SetSelected(Index: Integer; const Value: Boolean); virtual; abstract;
    procedure SetSelectedCell(ACol, ARow: Integer);
    procedure SetSelectedRow(const Value: Integer); virtual;
    procedure SortColumn(AColumn: TNxCustomColumn; Asending: Boolean); virtual;
    procedure UpdateHorzScrollBar; virtual;
    procedure UpdateVertScrollBar; virtual;
    procedure WMThemeChanged(var Message: TMessage); message WM_THEMECHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
	  function ApplyEditing: Boolean; virtual;
    function CellBounds(ACol, ARow: Integer): Boolean;
    function GetActualCellColor(ACol, ARow: Integer): TColor; virtual;
    function GetActualCellFontColor(ACol, ARow: Integer): TColor; virtual;
    function GetActualRowHeight(const Index: Integer): Integer;
    function GetBodyRect: TRect;
    function GetCellHeight(const ACol, ARow: Integer): Integer;
    function GetCellRect(const ACol, ARow: Integer): TRect; virtual;
    function GetCellState(ACol, ARow: Integer): TCellState;
    function GetCellTop(ACol, ARow: Integer): Integer;
    function GetFixedColumnsRect: TRect;
    function GetFixedWidth: Integer;
    function GetFooterRect: TRect;
    function GetHeaderRect: TRect;
    function GetIndicatorRect: TRect;
    function GetInputRect: TRect;
    function GetInputCellRect(const ACol: Integer): TRect;
    function GetRowRect(Index: Integer): TRect;
    function GetRowTop(Index: Integer): Integer;
    function GetScrollRect: TRect;
    function GetSlideRect(Index: Integer): TRect;
    function GetSlideTop(Index: Integer): Integer;
    function GetVisibleCount(Expand: Boolean = False): Integer;
    function Focused: Boolean; override;
    function IsCellHighlighted(ACol, ARow: Integer): Boolean;
    function IsRowInView(const Index: Integer): Boolean;
    function RowExist(Index: Integer): Boolean;
    function AddRow(Count: Integer = 1): Integer; virtual; abstract;
    procedure AddRowFromInput; virtual;
    procedure BeginUpdate;
    procedure BestFitColumn(Index: Integer; BestFitMode: TBestFitMode = bfCells; OnlyVisible: Boolean = True);
    procedure BestFitColumns(BestFitMode: TBestFitMode = bfCells; OnlyVisible: Boolean = True);
    procedure BestFitRow(const Index: Integer); overload;
    procedure BestFitRow(const ARow, ACol: Integer); overload;
    procedure CalculateFooter(VisibleOnly: Boolean = False); virtual; abstract;
    procedure ClearRows; virtual;
    procedure ClearSelection; virtual;
    procedure DeleteRow(Index: Integer); virtual;
    procedure EndEditing; virtual;
    procedure EditCell(ACol, ARow: Integer; AText: WideString = ''); virtual;
    procedure EndUpdate(CanUpdate: Boolean = True);
    procedure ExcludeGrid(var CellRect: TRect);
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure InputColumn(Column: TNxCustomColumn; Value: WideString = '');
    procedure InsertRow(Pos: Integer; Count: Integer = 1); virtual;
    procedure LoadFromIni(const FileName: WideString; ID: string = '');
    procedure LoadFromRegistry(const KeyName: WideString; ID: string = '');
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromTextFile(const FileName: WideString; Separator: WideChar = ',';
      MultiLineSeparator: WideChar = '|'; StartRow: Integer = 0);
    procedure MoveByRow(MoveDown: Boolean; Shift: TShiftState = []);
    procedure MoveRow(FromPos, ToPos: Integer); virtual;
    procedure MoveSelectionDown(Shift: TShiftState = [];
      NextControl: Boolean = False; SelectFirst: Boolean = False); virtual;
    procedure MoveSelectionLeft(Key: TMoveSelectionKey = mkUndefined);
    procedure MoveSelectionRight(Key: TMoveSelectionKey = mkUndefined);
    procedure MoveSelectionUp(Shift: TShiftState = []); virtual;
    procedure MoveSelectionBy(Distance: Integer);
    procedure MoveToNextCell(TabKey: Boolean = False);
    procedure MoveToPrevCell(TabKey: Boolean = False);
    procedure NoSelection;
    procedure RefreshCell(ACol, ARow: Integer); virtual;
    procedure RefreshColumn(Column: TNxCustomColumn; Area: TGridArea = gaNone); virtual;
    procedure RefreshColumnSlide(Column: TNxCustomColumn); virtual;
    procedure RefreshRange(FromPos, ToPos: Integer);
    procedure RefreshRow(const Index: Integer; BorderOnly: Boolean = False);
    procedure RefreshRowGrid(const Index: Integer);
    procedure RefreshSlide(Index: Integer; BorderOnly: Boolean = False);
    procedure ResetView;
    procedure Resort;
    procedure RevertStyle(const Index: Integer); virtual;
    procedure SetTextStr(const Value: string; Separator: Char);
    procedure SaveToHtml(const FileName: WideString; SaveSettings: TNxHtmlSaveSettings = [hsSaveHeaders]);
    procedure SaveToIni(const FileName: WideString; ID: string = '');
    procedure SaveToRegistry(const KeyName: WideString; ID: string = ''; RootKey: HKEY = HKEY_CURRENT_USER);
    procedure SaveToStream(Stream: TStream; Separator: Char = ';');
    procedure SaveToXMLFile(const FileName: WideString; UniEncoding: TUniEncoding = enUTF_8);
    procedure SaveToTextFile(const FileName: WideString; Separator: WideChar = ','; MultiLineSeparator: WideChar = '|';
      EncodingKind: TEncodingKind = ekUnicode);
    procedure ScrollToColumn(AColumn: TNxCustomColumn);
    procedure ScrollToRow(Index: Integer);
    procedure SelectAll;
    procedure SelectCell(ACol, ARow: Integer; Shift: TShiftState = []; Deselect: Boolean = True; AutoEdit: Boolean = False); virtual;
    procedure SelectFirstColumn;
    procedure SelectFirstRow(Shift: TShiftState = []); virtual;
    procedure SelectLastColumn;
    procedure SelectLastRow(Shift: TShiftState = []); virtual;
    procedure SelectRange(FromRow, ToRow: Integer; Value: Boolean); virtual; abstract;
    procedure SetMultiSelected;
    procedure StartEdit(const ACol, ARow: Integer; Key: Char);
    procedure StartInput(const Index: Integer; Key: Char);
    procedure SwapRows(FromPos, ToPos: Integer); virtual; abstract;

    property AppearanceOptions: TAppearanceOptions read FAppearanceOptions write SetAppearanceOptions default [aoHideSelection, aoHighlightSlideCells];
    property AutoScroll: Boolean read FAutoScroll write SetAutoScroll default False;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Caption: WideString read FCaption write SetCaption;
    property Cells[ACol, ARow: Integer]: WideString read GetCells write SetCells; default;
    property CellsByName[ACol, ARow: Variant]: WideString read GetCellsByName write SetCellsByName;
    property ColumnByName[Value: string]: TNxCustomColumn read GetColumnByName;
    property Columns: TNxColumns read FColumns;
    property CurrentStyleDisplay: TStyleDisplay read FCurrentStyleDisplay;
    property Editing: Boolean read GetEditing;
    property EditingCell: TPoint read FEditingCell write SetEditingCell;
    property EnableVisualStyles: Boolean read FEnableVisualStyles write SetEnableVisualStyles default True;
    property FirstRow: Integer read FFirstRow;
    property FirstVisibleRow: Integer read GetFirstVisibleRow;
    property FixedCols: Integer read FFixedCols write SetFixedCols default 0;
    property FocusedColumn: TNxCustomColumn read FFocusedColumn;
    property FooterSize: Integer read FFooterSize write SetFooterSize default 18;
    property GridLinesColor: TColor read FGridLinesColor write SetGridLinesColor default clBtnFace;
    property GridLinesStyle: TGridLinesStyle read FGridLinesStyle write SetGridLinesStyle default lsNormal;
    property GridSpace[Index: TGridLinePosition]: Integer read GetGridSpace;
    property GridState: TGridState read FGridState;
    property GridStyle: TGridStyle read FGridStyle write SetGridStyle default gsReport;
    property HeaderSize: Integer read FHeaderSize write SetHeaderSize default 18;
    property HeaderStyle: THeaderStyle read FHeaderStyle write SetHeaderStyle default hsAuto;
		property HideScrollBar: Boolean read FHideScrollBar write SetHideScrollBar default True;
    property HighlightedTextColor: TColor read FHighlightedTextColor write SetHighlightedTextColor default clHighlightText;
    property HomeEndBehaviour: THomeEndBehaviour read FHomeEndBehaviour write FHomeEndBehaviour default hebTopBottom;
    property HoverColumn: TNxCustomColumn read FHoverColumn;
    property InactiveSelectionColor: TColor read FInactiveSelectionColor write SetInactiveSelectionColor default clBtnFace;
    property IndicatorDrawingOptions: TDrawingOptions read FIndicatorDrawingOptions write SetIndicatorDrawingOptions default doNormal;
    property InnerWidth: Integer read GetInnerWidth;
    property InplaceEdit: TNxCustomEdit read FInplaceEdit write SetInplaceEdit;
    property InputingColumn: Integer read FInputingColumn;
    property InputEnterMode: TInputEnterMode read FInputEnterMode write FInputEnterMode default imEditing;
    property InputSelected: Boolean read FInputSelected write SetInputSelected;
    property InputSize: Integer read FInputSize write SetInputSize default 16;
    property LastRow: Integer read FLastRow;
    property LastRowInView: Integer read GetLastRowInViewProp;
    property LastVisibleRow: Integer read GetLastVisibleRow;
    property MultiSelect: Boolean read GetMultiSelect;
    property Options: TGridOptions read FOptions write SetOptions default [goHeader];
    property PaintingCell: TPoint read FPaintingCell;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property RowCount: Integer read GetRowCount write SetRowCount;
    property RowHeight[Index: Integer]: Integer read GetRowHeight write SetRowHeight;
    property RowSize: Integer read FRowSize write SetRowSize default 16;
    property RowVisible[Index: Integer]: Boolean read GetRowVisible write SetRowVisible;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property SelectedCell: TPoint read GetSelectedCell;
    property SelectedColumn: Integer read FSelectedColumn write SetSelectedColumn;
    property SelectedCount: Integer read GetSelectedCount;
    property SelectedRow: Integer read GetSelectedRow write SetSelectedRow;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor default clHighlight;
    property SelectionMoveDirection: TSelectionMoveDirection read FSelectionMoveDirection write FSelectionMoveDirection default mdDown;
    property SlidesOptions: TSlideOptions read FSlideOptions write SetSlideOptions default [soFrame, soHideSelection];
    property SlideCaptionColor: TColor read FSlideCaptionColor write SetSlideCaptionColor default clGrayText;
    property SlideSelectionColor: TColor read FSlideSelectionColor write SetSlideSelectionColor default clWindow;
    property SlideSize: Integer read FSlideSize write SetSlideSize default 80;
    property SortedColumn: TNxCustomColumn read FSortedColumn;
    property SortedStyle: TSortedStyle read FSortedStyle write SetSortedStyle default soDefault;
    property TabLeaveControl: Boolean read FTabLeaveControl write FTabLeaveControl default True;
    property UpdateCount: Integer read FUpdateCount;
    property Version: string read FVersion write SetVersion stored False;
    property WantReturns: Boolean read FWantReturns write FWantReturns default False;
    property WantTabs: Boolean read FWantTabs write FWantTabs default False;

    property OnAfterEdit: TEditEvent read FOnAfterEdit write FOnAfterEdit;
    property OnAfterRowMove: TAfterRowMoveEvent read FOnAfterRowMove write FOnAfterRowMove;
    property OnAfterSort: TColumnEvent read FOnAfterSort write FOnAfterSort;
    property OnApplyCell: TApplyCellEvent read FOnApplyCell write FOnApplyCell;
    property OnApplyEditText: TApplyEditText read FOnApplyEditText write FOnApplyEditText;
		property OnBeforeEdit: TBeforeEditEvent read FOnBeforeEdit write FOnBeforeEdit;
		property OnBeforeSelect: TBeforeEditEvent read FOnBeforeSelect write FOnBeforeSelect;
		property OnBeforeScroll: TScrollEvent read FOnBeforeScroll write FOnBeforeScroll;
    property OnCalculateRow: TCalculateRowEvent read FOnCalculateRow write FOnCalculateRow;
		property OnCellClick: TCellEvent read FOnCellClick write FOnCellClick;
    property OnCellColoring: TCellColoringEvent read FOnCellColoring write FOnCellColoring;
		property OnCellDblClick: TCellEvent read FOnCellDblClick write FOnCellDblClick;
    property OnCellHint: TCellHintEvent read FOnCellHint write FOnCellHint;
    property OnCellShowing: TCellShowingEvent read FOnCellShowing write FOnCellShowing;
    property OnChange: TChangeEvent read FOnChange write FOnChange;
    property OnChangeRowHeight: TChangeRowHeightEvent read FOnChangeRowHeight write FOnChangeRowHeight;
    property OnColumnFooterValue: TColumnFooterValueEvent read FOnColumnFooterValue write FOnColumnFooterValue;
    property OnColumnMove: TColumnMoveEvent read FOnColumnMove write FOnColumnMove;
    property OnColumnResize: TColumnResizeEvent read FOnColumnResize write FOnColumnResize;
    property OnCustomDrawCell: TCustomDrawCellEvent read FOnCustomDrawCell write FOnCustomDrawCell;
    property OnCustomDrawFooter: TCustomDrawFooterEvent read FOnCustomDrawFooter write FOnCustomDrawFooter;
    property OnCustomDrawHeader: TCustomDrawHeaderEvent read FOnCustomDrawHeader write FOnCustomDrawHeader;
    property OnCustomDrawIndicator: TCustomDrawIndicatorEvent read FOnCustomDrawIndicator write FOnCustomDrawIndicator;
    property OnDataChange: TDataChangeEvent read FOnDataChange write FOnDataChange;
    property OnDeselectCell: TCellEvent read FOnDeselectCell write FOnDeselectCell;
		property OnDrawCellBackground: TDrawCellBackgroundEvent read FOnDrawCellBackground write FOnDrawCellBackground;
    property OnEdit: TEditEvent read FOnEdit write FOnEdit;
    property OnEditAccept: TEditAcceptEvent read FOnEditAccept write FOnEditAccept;
    property OnEditEnter: TNotifyEvent read FOnEditEnter write FOnEditEnter;
    property OnEditExit: TNotifyEvent read FOnEditExit write FOnEditExit;
    property OnEditText: TEditTextEvent read FOnEditText write FOnEditText;
    property OnEndEditing: TEndEditingEvent read FOnEndEditing write FOnEndEditing;
    property OnFooterCalculate: TFooterCalculateEvent read FOnFooterCalculate write FOnFooterCalculate;
    property OnFooterClick: THeaderClickEvent read FOnFooterClick write FOnFooterClick;
    property OnHeaderClick: THeaderClickEvent read FOnHeaderClick write FOnHeaderClick;
    property OnHeaderDblClick: THeaderClickEvent read FOnHeaderDblClick write FOnHeaderDblClick;
    property OnInputAccept: TInputAcceptEvent read FOnInputAccept write FOnInputAccept;
    property OnInputAdded: TNotifyEvent read FOnInputAdded write FOnInputAdded;
    property OnInputSelectCell: TColumnEvent read FOnInputSelectCell write FOnInputSelectCell;
    property OnLoadProgress: TLoadProgressEvent read FOnLoadProgress write FOnLoadProgress;
    property OnMeasuringRowHeight: TMeasuringRowHeightEvent read FOnMeasuringRowHeight write FOnMeasuringRowHeight;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnPostDraw: TNotifyEvent read FOnPostDraw write FOnPostDraw;
    property OnRowMove: TRowMoveEvent read FOnRowMove write FOnRowMove;
    property OnSelectCell: TCellEvent read FOnSelectCell write FOnSelectCell;
    property OnSlideChange: TColumnEvent read FOnSlideChange write FOnSlideChange;
    property OnSlideColoring: TSlideColoringEvent read FOnSlideColoring write FOnSlideColoring;
    property OnSortColumn: TSortColumnEvent read FOnSortColumn write FOnSortColumn;
    property OnSelectionMove: TSelectionMoveEvent read FOnSelectionMove write FOnSelectionMove;
    property OnUpdateColumns: TNotifyEvent read FOnUpdateColumns write FOnUpdateColumns;
  end;

implementation

uses
{$IFDEF CUSTOM_STYLES}
  Themes,
{$ENDIF}
  SysUtils, MaskUtils, Dialogs, Types, Math, Variants, Registry, StrUtils;

{ TNxCustomGridControl }

procedure TNxCustomGridControl.AddRowFromInput;
var
  i: Integer;
  Accept: Boolean;
  NewText: WideString;
begin
  Accept := True;
  DoInputAccept(Accept); { event }
  if Accept then
  begin
    AddRow;
    for i := 0 to Columns.Count - 1 do
    begin                                 
      NewText := Columns[i].InputValue;
      if NewText = '' then NewText := Columns[i].DefaultValue;
      if NewText <> '' then Cells[i, RowCount - 1] := NewText;
      Columns[i].InputValue := '';
    end;
    DoInputAdded; { event }
  end;
end;

function TNxCustomGridControl.ApplyEditing: Boolean;
var
	Accept: Boolean;
  Value: WideString;
begin
  Result := False;
  if (gtEdit in GridState) then
	begin
	  Accept := True;
    { 9/7/07: Spin edit need to adjust bounds on editing done }
    FInplaceEdit.ApplyEditing;
    Value := FInplaceEdit.Text;

    Columns[FEditingCell.X].ApplyEditing(Value);

    DoEditAccept(FEditingCell.X, FEditingCell.Y, Value, Accept); { event }

    { first we need to check that cell still exist }
    if (RowCount = 0) or (FEditingCell.Y > RowCount)
      or (FEditingCell.X = -1) or (FEditingCell.Y = -1) then Exit;

		if Accept then
    begin
      DoEditText(FEditingCell.X, FEditingCell.Y, Value);
      CompleteEdit(FEditingCell.X, FEditingCell.Y, Value);
      DoAfterEdit(FEditingCell.X, FEditingCell.Y, Value);
      Result := True;
    end;
  end;
  if (gtInput in GridState)	then
  begin    
    InplaceEdit.ApplyEditing;
    Value := FInplaceEdit.Text;
    Columns[FInputingColumn].ApplyEditing(Value);

    Columns[FInputingColumn].InputValue := Value;
    Columns[FInputingColumn].Input := False;
    Result := True;
  end;
end;

function TNxCustomGridControl.CanEdit: Boolean;
begin
  Result := True;
end;

function TNxCustomGridControl.CanSelectCell(ACol, ARow: Integer): Boolean;
begin
  Result := True;
end;

procedure TNxCustomGridControl.CompleteEdit;
begin
  Cells[FEditingCell.X, FEditingCell.Y] := Value;
end;

constructor TNxCustomGridControl.Create(AOwner: TComponent);
begin
  inherited;
  FPaintingCell := Point(-1, -1);
  FGridSpace[lpLeft] := 0;
  FGridSpace[lpTop] := 0;
  FGridSpace[lpRight] := 0;
  FGridSpace[lpBottom] := 0;
  FAppearanceOptions := [aoHideSelection, aoHighlightSlideCells];
  FAutoScroll := False;
  FBorderStyle := bsSingle;
  FColumns := GetColumnsClass.Create(Self);
  FColumns.OnRepaint := DoColumnsRepaint;
  FColumns.OnColumnChange := DoColumnChange;
  FColumns.OnChange := DoColumnsChange;
  FDefaultStyleDisplay := TDefaultStyleDisplay.Create(Self);
  FCurrentStyleDisplay := FDefaultStyleDisplay;
  FCurrentStyleDisplay.Canvas := Canvas;
  FEditingCell := Point(-1, -1);
  FEditingDisplay := nil;
  FEnableVisualStyles := True;
  FFirstRow := 0;
  FFirstVisibleRow := 0;
  FFixedCols := 0;
  FFlatStyleDisplay := TFlatStyleDisplay.Create(Self);
  FFocusedColumn := nil;
  FFooterSize := 18;
  FFromSelected := -1;
  FGridLinesColor := clBtnFace;
  FGridState := [];
  FGridStyle := gsReport;
  FHeaderSize := 18;
  FHeaderStyle := hsAuto;
  FHideScrollBar := True;
  FHighlightedTextColor := clHighlightText;
  FHoverColumn := nil;
  FInactiveSelectionColor := clBtnFace;
  FIndicatorDrawingOptions := doNormal;
  FInplaceEdit := nil;
  FInplaceEditUpdate := False;
  FInputEnterMode := imEditing;
  FInputingColumn := -1;
  FInputSelected := False;
  FInputSize := 16;
  FLastVisibleRow := 0;
  FOffice2007StyleDisplay := TOffice2007StyleDisplay.Create(Self);
  FOffice2010StyleDisplay := TOffice2010StyleDisplay.Create(Self);
  FOldStyleDisplay := TOldStyleDisplay.Create(Self);
  FOutlookStyleDisplay := TOutlookStyleDisplay.Create(Self);
  FOptions := [goHeader];
  FReadOnly := False;
  FRowSize := 16;
  FSelectedColumn := 0;
  FSelectedRow := -1;
  FSelectionColor := clHighlight;
  FSelectionMoveDirection := mdDown;
  FSlideCaptionColor := clGrayText;
  FSlideOptions := [soFrame, soHideSelection];
  FSlideSelectionColor := clWindow;
  FSlideSize := 80;
  FSortedColumn := nil;
  FSortedStyle := soDefault;
  FUpdateCount := 0;
  FVersion := strNextGridVer;
  FVistaStyleDisplay := TVistaStyleDisplay.Create(Self);
  FWantTabs := False;
  FWantReturns := False;
  FTabLeaveControl := True;
  TabStop := True;
  Width := 250;
  Height := 150;
end;

destructor TNxCustomGridControl.Destroy;
begin
  FreeAndNil(FColumns);
  FCurrentStyleDisplay := nil;
  FreeAndNil(FDefaultStyleDisplay);
  FreeAndNil(FFlatStyleDisplay);
  FreeAndNil(FOffice2007StyleDisplay);
  FreeAndNil(FOffice2010StyleDisplay);
  FreeAndNil(FOldStyleDisplay);
  FreeAndNil(FOutlookStyleDisplay);
  FreeAndNil(FVistaStyleDisplay);
  FInplaceEdit := nil;
  if IsThemed then CloseThemeData(FTheme);
  inherited;
end;

procedure TNxCustomGridControl.CellsScrolled(Delta: Integer);
begin
  { This method is called after ScrollToRow call }
end;

procedure TNxCustomGridControl.CreateParams(var Params: TCreateParams);
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

procedure TNxCustomGridControl.CreateWnd;
begin
  inherited;
  if IsThemed then
  begin
    if FTheme = 0 then
    begin
      FTheme := OpenThemeData(Handle, NxThemesSupport.teHeader);
      FDefaultStyleDisplay.Theme := FTheme;
    end;
  end;
end;

function TNxCustomGridControl.GetCellColor(ACol, ARow: Integer): TColor;
begin
  Result := FColumns[ACol].Color;
end;

function TNxCustomGridControl.GetCellHeight(const ACol, ARow: Integer): Integer;
var
  CellState: TCellState;
  Display: TColumnDisplay;
  CellValue: WideString;
begin
  Display := Columns[ACol].Display;
  Display.Canvas := Canvas;
  Display.Level := GetRowLevel(ARow);
  Display.ClientRect := Rect(0, 0, GridSpace[lpLeft] + Columns[ACol].Width - GridSpace[lpRight], RowSize);

  Canvas.Font.Assign(Columns[ACol].Font);
  CellState := GetCellState(ACol, ARow);

  CellValue := GetDrawText(ACol, ARow);
  DoApplyCell(ACol, ARow, CellValue);

  Display.AsString := CellValue;
  ApplyCellFormating(ACol, ARow, CellValue, CellState);

  Result := Display.GetTextSize.cy;
end;

function TNxCustomGridControl.GetCellHint(ACol, ARow: Integer): WideString;
begin
  DoCellHint(ACol, ARow, Result); { event }
end;

function TNxCustomGridControl.GetColumnsClass: TNxColumnsClass;
begin
  Result := TNxColumns;
end;

function TNxCustomGridControl.GetHorzOffset(FromPos, ToPos: Integer): Integer;
begin
  Result := FromPos - ToPos;
end;

function TNxCustomGridControl.GetLastRowInViewProp: Integer;
var
  Pos, i: Integer;
begin
  Result := FFirstRow;
  Pos := 0;
  for i := FFirstRow to Pred(RowCount) do
    if GetRowVisible(i) then
    begin
      Inc(Pos, GetRowHeight(i) + FGridSpace[lpTopBottom]);
      if Pos > GetBodyRect.Bottom - GetBodyRect.Top
        then Exit
          else Result := i;
    end;
end;

function TNxCustomGridControl.GetLastRowInView(Count: Integer): Integer;
var
  i: Integer;
begin
  i := 0;
  Result := FirstRow;
  if Count > 0 then
  begin
    while (i < Abs(Count) - 1) and (Result < RowCount) do
    begin
      Inc(Result);
      if GetRowVisible(Result) then Inc(i);
    end;
  end;
end;

function TNxCustomGridControl.GetVertOffset(FromPos, ToPos: Integer): Integer;
var
  i, C: Integer;
begin
  Result := 0;
  if FromPos < ToPos then
  begin
    C := 0;
    while FFirstRow < RowCount do
    begin
      if GetRowVisible(FFirstRow) then
      begin
        Inc(C);
        if C > (ToPos - FromPos) then Break;
        Dec(Result, GetActualRowHeight(FFirstRow) + GridSpace[lpTop] + GridSpace[lpBottom]);
      end;
      Inc(FFirstRow);
    end;
  end;

  if FromPos > ToPos then
  begin
    i := FFirstRow - 1;
    C := 0;
    while (i >= 0) and (C < FromPos - ToPos) do
    begin
      Dec(FFirstRow);
      if GetRowVisible(i) then
      begin
        Inc(C);
        Inc(Result, GetActualRowHeight(i) + GridSpace[lpTop] + GridSpace[lpBottom]);
      end;
      Dec(i);
    end;
  end;
end;

procedure TNxCustomGridControl.ApplyCellFormating(ACol,
  ARow: Integer; Value: WideString; CellState: TCellState);
begin

end;

procedure TNxCustomGridControl.ColumnsChange(
  ChangeOpearation: TColumnsOperation; Value1, Value2: Integer);
begin
 	if (ChangeOpearation = opClear)
    or (ChangeOpearation = opDelete) then EndEditing;
  UpdateHorzScrollBar;
end;

procedure TNxCustomGridControl.ClearRows;
begin
  FFirstRow := 0;
  FSelectedColumn := 0;
  FSelectedRow := -1;
  EndEditing;
end;

procedure TNxCustomGridControl.ClearSelection;
var
  i: Integer;
begin
  for i := 0 to RowCount - 1 do
    if Selected[i] then Selected[i] := False;
end;

procedure TNxCustomGridControl.BestFitColumn(Index: Integer;
  BestFitMode: TBestFitMode; OnlyVisible: Boolean);
var
  i, ContentWidth, BestWidth: Integer;
  CellState: TCellState;
  Display: TColumnDisplay;
  CellValue: WideString;
begin
  Display := Columns[Index].Display;
  Display.Canvas := Canvas;

  BestWidth := 8;

  if BestFitMode <> bfCells then
  begin
    FCurrentStyleDisplay.Canvas.Font.Assign(Self.Font);
    BestWidth := FCurrentStyleDisplay.GetHeaderContentWidth(Columns[Index]);
  end;

  if BestFitMode <> bfHeader then
  begin
    for i := 0 to RowCount - 1 do
    begin
      if GetRowVisible(i) or not OnlyVisible then
      begin
        Display.ClientRect := Rect(0, 0, Columns[Index].Width, GetRowHeight(i));

        Canvas.Font.Assign(Columns[Index].Font);
        CellState := GetCellState(Index, i);

        CellValue := GetDrawText(Index, i);
        DoApplyCell(Index, i, CellValue);

        Display.AsString := CellValue;
        ApplyCellFormating(Index, i, CellValue, CellState);

        ContentWidth := Display.GetContentWidth;
        if ContentWidth > BestWidth then BestWidth := ContentWidth;
      end;
    end;
  end;

  Columns[Index].Width := BestWidth + 5 + Columns[Index].Padding * 2;
end;

procedure TNxCustomGridControl.BestFitColumns(BestFitMode: TBestFitMode = bfCells;
  OnlyVisible: Boolean = True);
var
  i: Integer;
begin
  for i := 0 to Columns.Count - 1 do
    BestFitColumn(i, BestFitMode, OnlyVisible);
end;

procedure TNxCustomGridControl.BestFitRow(const ARow, ACol: Integer);
var
  CellHeight, BestHeight: Integer;
begin
  { Default Height }
  BestHeight := RowSize;

  if CellBounds(ACol, ARow) then
  begin
    CellHeight := GetCellHeight(ACol, ARow);

    if CellHeight > BestHeight
      then BestHeight := CellHeight;
  end;

  { Set New Height }
  RowHeight[ARow] := BestHeight;
end;

procedure TNxCustomGridControl.BestFitRow(const Index: Integer);
var
  i, CellHeight, BestHeight: Integer;
begin
  BestHeight := RowSize;
  for i := 0 to Pred(Columns.Count) do
    if Columns[i].Visible then
    begin
      CellHeight := GetCellHeight(i, Index);
      if CellHeight > BestHeight
        then BestHeight := CellHeight;
    end;
  RowHeight[Index] := BestHeight;
end;

procedure TNxCustomGridControl.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
var
  i: Integer;
begin
	{ this will save columns as childrens into dfm }
  for i := 0 to Columns.Count - 1 do
    Proc(FColumns.Item[i]);
end;

function TNxCustomGridControl.GetCellsByName(ACol,
  ARow: Variant): WideString;
begin
  with GetCellByVariant(ACol, ARow) do Result := GetCells(X, Y);
end;

function TNxCustomGridControl.GetColumnByName(
  Value: string): TNxCustomColumn;
begin
  Result := FColumns.Column[Value];
end;

function TNxCustomGridControl.GetInnerWidth: Integer;
begin
  case GridStyle of
    gsReport: if goIndicator in Options
                then Result := ClientWidth - sizIndicator
                else Result := ClientWidth;
    else Result := ClientWidth;
  end;
end;

function TNxCustomGridControl.GetRowHeight(Index: Integer): Integer;
begin
  Result := RowSize;
end;

function TNxCustomGridControl.GetRowImageIndex(Index: Integer): Integer;
begin
  Result := -1;
end;

function TNxCustomGridControl.GetRowLevel(Index: Integer): Integer;
begin
  Result := 0;
end;

function TNxCustomGridControl.GetRowsInRange(FromRow,
  ToRow: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  if ToRow = FromRow then Exit;
  if ToRow < FromRow then Exchange(ToRow, FromRow);
  i := FromRow;
  while i < ToRow do
  begin
    if GetRowVisible(i) then Inc(Result);
    Inc(i);
  end;
end;

function TNxCustomGridControl.GetRowVisible(Index: Integer): Boolean;
begin
  Result := True;
end;

function TNxCustomGridControl.GetSelectedCell: TPoint;
begin
  Result := Point(FSelectedColumn, FSelectedRow);
end;

function TNxCustomGridControl.GetSelectedCount: Integer;
var
	i: Integer;
begin                                 
  Result := 0;
	for i := 0 to RowCount - 1 do if Selected[i] then Inc(Result);
end;

procedure TNxCustomGridControl.SetAppearanceOptions(
  const Value: TAppearanceOptions);
begin
  FAppearanceOptions := Value;
  RecalculateGridSpace;
  Invalidate;
  RedrawBorder;
end;

procedure TNxCustomGridControl.SetAutoScroll(const Value: Boolean);
begin
  FAutoScroll := Value;
end;

function TNxCustomGridControl.GetSelectedRow: Integer;
begin
	Result := FSelectedRow;
end;

{$HINTS OFF}
function TNxCustomGridControl.GetTextStr(Separator: Char = ';'): string;
var
  i, j, Size, Count, L: Integer;
  P: PChar;
  S: string;

begin
  Size := 0;
  for i := 0 to RowCount - 1 do
    for j := 0 to Columns.Count - 1 do
    begin
      S:=Cells[j, i];
      Inc(Size,Length(S));
      while pos(sLineBreak,S)<> 0 do
      begin
           Inc(Size,Length('%'));
           S := rightstr(S,Length(S)-(pos(sLineBreak,S)+1));
      end;
      if j = Columns.Count - 1 then
      begin
        if i <> RowCount -1 then Inc(Size,Length(Separator + sLineBreak))
      end else Inc(Size, Length(Separator));
    end;
  Size := Size + Length(Separator);
  SetString(Result, nil, Size);
  P := Pointer(Result);
  System.Move(Separator, P^, 1);
  Inc(P, 1);

  for i := 0 to RowCount - 1do
  begin
    for j := 0 to Columns.Count - 1 do
    begin
      S := Cells[j, i];
      S := StringReplace(S,sLineBreak,'%'+ sLineBreak,[rfReplaceAll,rfIgnoreCase]);
      if j = Columns.Count - 1 then
      begin
        if i <> RowCount -1 then S := S + Separator + sLineBreak
      end else S := S + Separator;
      L := Length(S);
      if L <> 0 then
      begin
        System.Move(Pointer(S)^, P^, L);
        Inc(P, L);
      end;
    end;

  end;

end;
{$HINTS ON}

procedure TNxCustomGridControl.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  RecreateWnd;
end;

procedure TNxCustomGridControl.SetCaption(const Value: WideString);
var
	r: TRect;
begin
  FCaption := Value;
  r := GetBodyRect;
  r.Right := ClientWidth;
  RedrawWindow(Handle, @r, 0, RDW_INVALIDATE);
end;

procedure TNxCustomGridControl.SetCellsByName(ACol, ARow: Variant;
  const Value: WideString);
begin
  with GetCellByVariant(ACol, ARow) do SetCells(X, Y, Value);
end;

procedure TNxCustomGridControl.SetEditingCell(const Value: TPoint);
begin
  EditCell(Value.X, Value.Y);
end;

procedure TNxCustomGridControl.SetEnableVisualStyles(
  const Value: Boolean);
begin
  FEnableVisualStyles := Value;
  Invalidate;
  RedrawBorder;
end;

procedure TNxCustomGridControl.SetFixedCols(const Value: Integer);
begin
  FFixedCols := Value;
  FColumns.SetFixedCols(Value);
  Invalidate;
end;

procedure TNxCustomGridControl.SetFooterSize(const Value: Integer);
begin
  FFooterSize := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetGridLinesColor(const Value: TColor);
begin
  FGridLinesColor := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetGridLinesStyle(
  const Value: TGridLinesStyle);
begin
  FGridLinesStyle := Value;
  RecalculateGridSpace;
  Invalidate;
end;

procedure TNxCustomGridControl.SetGridStyle(const Value: TGridStyle);
begin
  if FGridStyle <> Value then
  begin
    FGridStyle := Value;
    GridStyleChanged;
    case GridStyle of
      gsSlides:
      begin
        EndEditing;
        InputSelected := False;
      end;
    end;
    Invalidate;
    RefreshCellEditor;
    UpdateHorzScrollBar;
    UpdateVertScrollBar;
  end;
end;

procedure TNxCustomGridControl.SetHeaderSize(const Value: Integer);
begin
  FHeaderSize := Value;
  Invalidate;
  RefreshCellEditor;
end;

procedure TNxCustomGridControl.SetHeaderStyle(const Value: THeaderStyle);
begin
  if Value <> FHeaderStyle then
  begin
    FHeaderStyle := Value;
    RecreateStyleDisplay;
  end;
end;

procedure TNxCustomGridControl.SetHideScrollBar(const Value: Boolean);
begin
  FHideScrollBar := Value;
  VertScrollBar.AutoHide := FHideScrollBar;
end;

procedure TNxCustomGridControl.SetHighlightedTextColor(
  const Value: TColor);
begin
  FHighlightedTextColor := Value;
  RefreshSelectedCells;
end;

procedure TNxCustomGridControl.SetInactiveSelectionColor(
  const Value: TColor);
begin
  FInactiveSelectionColor := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetIndicatorDrawingOptions(const Value: TDrawingOptions);
begin
  FIndicatorDrawingOptions := Value;
  RefreshArea(gaIndicator);
end;

procedure TNxCustomGridControl.SetInplaceEdit(
  const Value: TNxCustomEdit);
begin
  FInplaceEdit := Value;
  if Assigned(FInplaceEdit) then
  begin
    { Clear events }
    FInplaceEdit.OnChange := nil; { don't call DoEdit when Text is chaged }
    FInplaceEdit.Parent := Self;
    FInplaceEdit.Text := '';
    FInplaceEdit.WantTabs := WantTabs;
    FInplaceEdit.BiDiMode := BiDiMode;
  end;
end;

procedure TNxCustomGridControl.SetInputSelected(const Value: Boolean);
begin
  if Value <> FInputSelected then
  begin
    FInputSelected := Value;
    if Value then
    begin
      Selected[FSelectedRow] := False;
    end else
    begin
      EndEditing;
    end;
    RefreshArea(gaInput);
    RefreshArea(gaIndicator);
    RefreshSelectedCells;
  end;
end;

procedure TNxCustomGridControl.SetInputSize(const Value: Integer);
begin
  FInputSize := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetOptions(const Value: TGridOptions);
var
	FOldOptions: TGridOptions;
begin
  FOldOptions := FOptions;
  FOptions := Value;
  if (goIndicator in Value) <> (goIndicator in FOldOptions) then DoUpdateColumns;
  RecalculateGridSpace;

  if HandleAllocated then
  begin
    Invalidate;
    RefreshCellEditor;
    UpdateHorzScrollBar;
  end;
end;

procedure TNxCustomGridControl.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

procedure TNxCustomGridControl.SetRowHeight(Index: Integer;
  const Value: Integer);
begin
  if Assigned(FOnChangeRowHeight) then FOnChangeRowHeight(Self, Index, Value);
end;

procedure TNxCustomGridControl.SetRowSize(const Value: Integer);
begin
  if Value < 1 then Exit;
  FRowSize := Value;
  RefreshArea(gaBody);
  RefreshArea(gaInput);
  RefreshArea(gaIndicator);
  RefreshCellEditor;
end;

procedure TNxCustomGridControl.SetRowVisible(Index: Integer;
  const Value: Boolean);
begin
  if Value then
  begin
    { if row become visible, and this row have smaller Index,
      it become FFirstVisibleRow }
    if Index < FFirstVisibleRow then FFirstVisibleRow := Index;
    if Index > FLastVisibleRow then FLastVisibleRow := Index;
  end else
  begin
    if Index = FFirstVisibleRow then FFirstVisibleRow := GetFirstVisible(FFirstVisibleRow);
    FLastVisibleRow := GetLastVisible(FLastVisibleRow);
  end;
end;

procedure TNxCustomGridControl.SetSelectedColumn(const Value: Integer);
begin
  if (Columns.Count > 0) and InRange(Value, 0, Pred(Columns.Count)) then
  begin
    SelectCell(Value, FSelectedRow);
  end;
end;

procedure TNxCustomGridControl.SetSelectionColor(const Value: TColor);
begin
  FSelectionColor := Value;
end;

procedure TNxCustomGridControl.SetSelectedCell(ACol, ARow: Integer);
begin
  FSelectedColumn := ACol;
  FSelectedRow := ARow;
end;

procedure TNxCustomGridControl.SetSelectedRow(const Value: Integer);
begin
  if (RowCount > 0) and InRange(Value, -1, Pred(RowCount)) then
  begin
 	  InputSelected := False;
	  SelectCell(FSelectedColumn, Value);
  end;
end;

procedure TNxCustomGridControl.SortColumn(AColumn: TNxCustomColumn;
  Asending: Boolean);
begin          
  if coCanSort in AColumn.Options then
  begin
    EndEditing;
    FSortedColumn := AColumn;
    DoSortColumn(AColumn.Index, AColumn.SortKind = skAscending);
  end;
end;

procedure TNxCustomGridControl.SetSlideCaptionColor(const Value: TColor);
begin
  FSlideCaptionColor := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetSlideOptions(const Value: TSlideOptions);
begin
  FSlideOptions := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetSlideSelectionColor(const Value: TColor);
begin
  FSlideSelectionColor := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetSlideSize(const Value: Integer);
begin
  FSlideSize := Value;
  UpdateVertScrollBar;
  Invalidate;
end;

procedure TNxCustomGridControl.SetSortedStyle(const Value: TSortedStyle);
begin
  FSortedStyle := Value;
  Invalidate;
end;

procedure TNxCustomGridControl.SetVersion(const Value: string);
begin
  FVersion := strNextGridVer;
end;

function TNxCustomGridControl.CanMoveRow(FromPos, ToPos: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnRowMove) then FOnRowMove(Self, FromPos, ToPos, Result);
end;

function TNxCustomGridControl.GetActualCellColor(ACol, ARow: Integer): TColor;
begin
	Result := GetCellColor(ACol, ARow);
  if (aoIndicateSortedColumn in FAppearanceOptions) and (Columns[ACol].Sorted)
   	then Result := TGraphicsProvider.BlendColor(clBlack, Result, 10);
  if IsCellHighlighted(ACol, ARow) then
    if Focused then
    begin
      if aoAlphaBlendedSelection in AppearanceOptions
        then Result := TGraphicsProvider.BlendColor(Result, GetSysColor(COLOR_HIGHLIGHT), 0.25)
        else Result := FSelectionColor
    end else Result := FInactiveSelectionColor;
end;

function TNxCustomGridControl.GetActualCellFontColor(ACol,
  ARow: Integer): TColor;
begin
  Result := FColumns[ACol].Font.Color;
 	if IsCellHighlighted(ACol, ARow) and Focused then Result := FHighlightedTextColor;
end;

function TNxCustomGridControl.GetActualRowHeight(
  const Index: Integer): Integer;
begin
  case GridStyle of
    gsReport: Result := GetRowHeight(Index);
    else Result := SlideSize;
  end;
end;

function TNxCustomGridControl.GetBodyRect: TRect;
begin
  with Result do
    case GridStyle of
      gsReport:
      begin
		    if goIndicator in Options then Left := sizIndicator else Left := 0;
        Top := 0;
        if goHeader in Options then Inc(Top, FHeaderSize);
        if goInput in Options then
        begin
          Inc(Top, FInputSize + 6);
          Inc(Top, GridSpace[lpBottom]);
        end;
        Right := (Columns.ClientWidth - HorzScrollBar.Position) + Left;
        if Right > ClientWidth then Right := ClientWidth;
        if goFooter in Options then
        begin
          Bottom := ClientHeight - FFooterSize - 4;
          Dec(Bottom, GridSpace[lpBottom]);
        end else Bottom := ClientHeight;
      end;
      gsSlides:
      begin
        Result := ClientRect;
        if goIndicator in Options then Inc(Left, sizIndicator);
        if goHeader in Options then Inc(Top, FHeaderSize);
      end;
    end;
end;

function TNxCustomGridControl.GetCellRect(const ACol, ARow: Integer): TRect;
var
  Pos: Integer;
  CurColumn: TNxCustomColumn;
begin
  case GridStyle of
    gsReport:
    begin
      Pos := Columns[ACol].Position;
      CurColumn := Columns.PositionItem[Pos];
      Result.Top := GetRowTop(ARow);
      Result.Left := CurColumn.Left;
      if Pos >= FixedCols then Dec(Result.Left, HorzScrollBar.Position);
      Result.Right := Result.Left + CurColumn.Width;
      if ARow < RowCount then Result.Bottom := Result.Top + GetRowHeight(ARow)
        else Result.Bottom := Result.Top + RowSize;
    end;
    gsSlides:
    begin
      Result.Left := Columns[ACol].SlideBounds.Left;
      Result.Right := Result.Left + Columns[ACol].SlideBounds.Width;
      Result.Top := GetSlideTop(ARow) + Columns[ACol].SlideBounds.Top;
      Result.Bottom := Result.Top + Columns[ACol].SlideBounds.Height;
    end;
  end;
end;

function TNxCustomGridControl.GetCellState(ACol, ARow: Integer): TCellState;
var
  GridColor, CellColor: TColor;
begin
  Result := [];
  GridColor := FGridLinesColor;
  with Canvas do
  begin
    Font.Assign(Columns[ACol].Font);
    CellColor := GetActualCellColor(ACol, ARow);
  end;
  if IsCellHighlighted(ACol, ARow) then
  begin
    Include(Result, csSelected);
    if aoBoldTextSelection in AppearanceOptions then
      Include(Result, csBoldTextSelection);
  end;
  if (Focused) and (not(aoHideFocus in AppearanceOptions)) then
    Include(Result, csFocused);

  DoCellColoring(ACol, ARow, CellColor, GridColor, Result); { event }
end;

function TNxCustomGridControl.GetCellTop(ACol, ARow: Integer): Integer;
begin
  case GridStyle of
    gsReport: Result := GetRowTop(ARow);
    gsSlides: begin
                Result := GetSlideTop(ARow);
                Result := Result + Columns[ACol].SlideBounds.Top;
              end;
    else Result := -1;
  end;
end;

function TNxCustomGridControl.GetFixedColumnsRect: TRect;
begin
  with Result do
  begin
    if goIndicator in Options then Left := sizIndicator else Left := 0;
    Inc(Left, GetFixedWidth);
    if goHeader in Options then Top := HeaderSize else Top := 0;
    if goInput in Options then Inc(Top, FInputSize + 6 + GridSpace[lpBottom]);
    if goFooter in Options then
    begin
      Bottom := ClientHeight - FHeaderSize - 4;
      Dec(Bottom, GridSpace[lpBottom]);
    end else Bottom := ClientHeight;
  end;
end;

function TNxCustomGridControl.GetFixedWidth: Integer;
begin
  Result := Columns.FixedWidth;
end;

function TNxCustomGridControl.GetFooterRect: TRect;
begin
  with Result do
    case GridStyle of
      gsReport:
      begin
		    if goIndicator in Options then Left := sizIndicator else Left := 0;
		    Top := ClientHeight - (FFooterSize + 4);
        Dec(Top, GridSpace[lpBottom]);
		    Right := (Columns.ClientWidth - HorzScrollBar.Position) + Left;
		    Bottom := ClientHeight;
		  end;
      gsSlides: Result := Rect(0, 0, 0, 0);
  end;
end;

function TNxCustomGridControl.GetEditing: Boolean;
begin
  Result := (gtEdit in FGridState);
end;

function TNxCustomGridControl.GetEditingRect(
  IncludeGrid: Boolean): TRect;
begin
  if gtEdit in GridState then Result := GetCellRect(FEditingCell.X, FEditingCell.Y);
  if gtInput in GridState	then Result := GetInputCellRect(FInputingColumn);
end;

function TNxCustomGridControl.GetGridSpace(Index:
  TGridLinePosition): Integer;
begin
  Result := FGridSpace[Index];
end;

function TNxCustomGridControl.GetHeaderRect: TRect;
begin
  with Result do
  begin
    if goIndicator in Options then Left := sizIndicator else Left := 0;
    Top := 0;
    Right := (Columns.ClientWidth - HorzScrollBar.Position) + Left;
    Bottom := HeaderSize;
  end;
end;

function TNxCustomGridControl.GetIndicatorRect: TRect;
begin
  with Result do
  begin
    Left := 0;
    Right := sizIndicator;
    Top := 0;
    Bottom := ClientHeight;
  end;
end;

function TNxCustomGridControl.GetHorzMax: Integer;
var
	e: Integer;
begin
	if goIndicator in Options then e := sizIndicator else e := 0;
  if Columns.ClientWidth > ClientWidth - e
    then Result := Columns.ClientWidth - (ClientWidth - e)
      else Result := 0;
end;

function TNxCustomGridControl.GetHorzClipRect: TRect;
begin

end;

function TNxCustomGridControl.GetInputRect: TRect;
begin
  with Result do
  begin
    if goIndicator in Options then Left := sizIndicator else Left := 0;
    if goHeader in Options then Top := HeaderSize else Top := 0;
    Right := (Columns.ClientWidth - HorzScrollBar.Position) + Left;
    Bottom := Top + FInputSize + 6;
    Inc(Bottom, GridSpace[lpBottom]);
  end;
end;

function TNxCustomGridControl.GetInputCellRect(const ACol: Integer): TRect;
var
  CurColumn: TNxCustomColumn;
begin
  with Result do
  begin
    CurColumn := Columns[ACol];
    Top := GetInputRect.Top;
    Left := CurColumn.Left - HorzScrollBar.Position;
    Right := Left + CurColumn.Width;
    Bottom := Top + InputSize;
  end;
end;

function TNxCustomGridControl.GetRowRect(Index: Integer): TRect;
var
  ARowHeight: Integer;
begin
  with Result do
  begin
    Top := GetRowTop(Index);
    Left := 0;
    Right := GetBodyRect.Right;
    if Index < RowCount then ARowHeight := GetRowHeight(Index) else ARowHeight := RowSize;
    Bottom := Top + ARowHeight + GetGridSpace(lpBottom);
  end;
end;

function TNxCustomGridControl.GetRowTop(Index: Integer): Integer;
var
  i, Delta: Integer;
begin
  Result := GetBodyRect.Top + GridSpace[lpTop];
  for i := FFirstRow to Index - 1 do
  begin
    if i < RowCount then
    begin
      if GetRowVisible(i) then Delta := GetRowHeight(i) else Delta := 0;
    end else Delta := RowSize;
    if Delta > 0 then
    begin
      Inc(Result, Delta);       
      Inc(Result, GridSpace[lpTopBottom]);
    end;
  end;
end;

function TNxCustomGridControl.GetScrollRect: TRect;
begin
  with Result do
  begin                                                           
    Top := 0;
    Left := GetFixedWidth;
    if goIndicator in Options then Inc(Left, sizIndicator);
    Right := ClientWidth;
    Bottom := ClientHeight;
  end;
end;

function TNxCustomGridControl.GetSlideRect(Index: Integer): TRect;
var
  i: Integer;
begin
  with Result do
  begin
    Result := ClientRect;
    Top := GetBodyRect.Top + GridSpace[lpTop];
    for i := FFirstRow to Index - 1 do
    begin
      if GetRowVisible(i) then
      begin
        Inc(Top, GridSpace[lpTopBottom]);
        Inc(Top, SlideSize);
      end;
    end;
    Bottom := Top + SlideSize;
  end;
end;

function TNxCustomGridControl.GetSlideTop(Index: Integer): Integer;
var
  i, Delta: Integer;
begin
  Result := GetBodyRect.Top;
  for i := FFirstRow to Index - 1 do
  begin
    if GetRowVisible(i) then
    begin
      Delta := SlideSize;
      Inc(Result, Delta);
      Inc(Result, GridSpace[lpTopBottom]);
    end;
  end;
end;

function TNxCustomGridControl.GetVisibleCount(Expand: Boolean = False): Integer;
var
  i, Pos, VisibleHeight: Integer;
begin
  Result := 0;
  Pos := 0;
  VisibleHeight := GetBodyRect.Bottom - GetBodyRect.Top;
  i := FFirstRow;
  while i < RowCount do
  begin
    if GetRowVisible(i) then
    begin
      Inc(Pos, GetActualRowHeight(i));
      Inc(Pos, GridSpace[lpTopBottom]);
      if Pos > VisibleHeight then Exit;
      Inc(Result);
    end;
    Inc(i);
  end;
  { 4/28/07:  If there is more space and Position = Max
              upper rows will be counted too until remaining
              space is filled }
  if not Expand then Exit;
  i := FFirstRow - 1;
  while i > Pred(0) do
  begin
    if GetRowVisible(i) then
    begin
      Inc(Pos, GetActualRowHeight(i));
      Inc(Pos, GridSpace[lpTopBottom]);
      if Pos > VisibleHeight then Exit;
      Inc(Result);
    end;
    Dec(i);
  end;
end;

function TNxCustomGridControl.GetCellByVariant(ACol,
  ARow: Variant): TPoint;
begin
  if CompareText(ARow, 'First') = 0 then Result.Y := 0
  else if CompareText(ARow, 'Last') = 0 then Result.Y := Pred(RowCount)
  else if CompareText(ARow, 'Selected') = 0 then Result.Y := SelectedRow
  else try
    Result.Y := ARow;
  except 
    raise Exception.CreateFmt('Invalid Rowname '#39'%s'#39' for '#39'%s:%s'#39'.', [VarToStr(ARow), Self.ClassName, Self.Name]); 
  end;
  if CompareText(ACol, 'First') = 0 then Result.X := 0
  else if CompareText(ACol, 'Last') = 0 then Result.X := Pred(Columns.Count)
  else if CompareText(ACol, 'Selected') = 0 then Result.X := SelectedColumn
  else if Columns.Column[ACol] <> nil then Result.X := Columns.Column[ACol].Index
  else try
    Result.X := ACol;
  except
    raise Exception.CreateFmt('Invalid Columnname '#39'%s'#39' for '#39'%s:%s'#39'.', [VarToStr(ACol), Self.ClassName, Self.Name]);
  end;
end;

function TNxCustomGridControl.GetVertMax: Integer;
begin
  { 4/28/07:  GetVisibleRows return total number of
              visible rows in grid }
  Result := 0;
  if (RowCount = 0) or (Columns.Count = 0) then Exit;
  Result := GetVisibleRows;
end;

{ events }

procedure TNxCustomGridControl.DoCellColoring(ACol, ARow: Integer;
	var CellColor, GridColor: TColor; CellState: TCellState);
begin
  if Assigned(FOnCellColoring) then FOnCellColoring(Self, ACol, ARow, CellColor, GridColor, CellState);
end;

procedure TNxCustomGridControl.DoCellDblClick(ACol, ARow: Integer);
begin
  if Assigned(FOnCellDblClick) then FOnCellDblClick(Self, ACol, ARow);
end;

procedure TNxCustomGridControl.DoCellHint(ACol, ARow: Integer;
  var Value: WideString);
begin
  if Assigned(FOnCellHint) then FOnCellHint(Self, ACol, ARow, Value);
end;

procedure TNxCustomGridControl.DoCellShowing(ACol, ARow: Integer;
  var Showing: Boolean);
begin
  if Assigned(FOnCellShowing) then FOnCellShowing(Self, ACol, ARow, Showing);
end;

procedure TNxCustomGridControl.DoChange(ACol, ARow: Integer);
begin
	if Assigned(FOnChange) then FOnChange(Self, ACol, ARow);
end;

procedure TNxCustomGridControl.DoColumnFooterValue(ACol: Integer;
  var Value: Double);
begin
  if Assigned(FOnColumnFooterValue) then FOnColumnFooterValue(Self, ACol, Value);
end;

procedure TNxCustomGridControl.DoColumnMove(ACol, FromPos,
  ToPos: Integer);
begin
  if Assigned(FOnColumnMove) then FOnColumnMove(Self, ACol, FromPos, ToPos);
end;

procedure TNxCustomGridControl.DoSelectCell(ACol, ARow: Integer);
begin
  if Assigned(FOnSelectCell) then FOnSelectCell(Self, ACol, ARow);
end;

procedure TNxCustomGridControl.DoSlideChange(ACol: Integer);
begin
  if Assigned(FOnSlideChange) then FOnSlideChange(Self, ACol);
end;

procedure TNxCustomGridControl.DoSlideColoring(Index: Integer;
  var SlideColor, GridColor: TColor; SlideState: TSlideState);
begin
  if Assigned(FOnSlideColoring) then FOnSlideColoring(Self, Index, SlideColor, GridColor, SlideState);
end;

procedure TNxCustomGridControl.DoSortColumn(ACol: Integer; Ascending: Boolean);
begin
  if Assigned(FOnSortColumn) then FOnSortColumn(Self, ACol, Ascending);
end;

procedure TNxCustomGridControl.DoSelectionMove(var ACol: Integer;
  var ARow: Integer; Key: TMoveSelectionKey);
begin
  if Assigned(FOnSelectionMove) then FOnSelectionMove(Self, ACol, ARow, Key);
end;

procedure TNxCustomGridControl.DoUpdateColumns;
begin
	if Assigned(FOnUpdateColumns) then FOnUpdateColumns(Self);
end;

procedure TNxCustomGridControl.DoCustomDrawCell(ACol, ARow: Integer;
	CellRect: TRect; CellState: TCellState);
begin
  if Assigned(FOnCustomDrawCell) then FOnCustomDrawCell(Self, ACol, ARow, CellRect, CellState);
end;

procedure TNxCustomGridControl.DoCustomDrawIndicator(Index: Integer; IndicatorRect: TRect;
  Selected, Highlighted: Boolean);
begin
  if Assigned(FOnCustomDrawIndicator) then FOnCustomDrawIndicator(Self, Index, IndicatorRect, Selected, Highlighted);
end;

procedure TNxCustomGridControl.DoDataChange(AChangeType: TDataChange;
  const AIndex: Integer);
begin
  if Assigned(FOnDataChange) then FOnDataChange(Self, AChangeType, AIndex);
end;

procedure TNxCustomGridControl.DoDeselectCell(ACol, ARow: Integer);
begin
  if Assigned(FOnDeselectCell) then FOnDeselectCell(Self, ACol, ARow);
end;

procedure TNxCustomGridControl.DoDrawCellBackground(ACol, ARow: Integer;
  CellRect: TRect; CellState: TCellState; var DefaultDrawing: Boolean);
begin
  if Assigned(FOnDrawCellBackground) then FOnDrawCellBackground(Self, ACol, ARow, CellRect, CellState, DefaultDrawing);
end;

procedure TNxCustomGridControl.DoPostDraw;
begin
  if Assigned(FOnPostDraw) then FOnPostDraw(Self);
end;

procedure TNxCustomGridControl.DoEdit(ACol, ARow: Integer;
	Value: WideString);
begin
  if Assigned(FOnEdit) then FOnEdit(Self, ACol, ARow, Value);
end;

procedure TNxCustomGridControl.DoEditAccept(ACol, ARow: Integer;
  Value: WideString; var Accept: Boolean);
begin
  if Assigned(FOnEditAccept) then FOnEditAccept(Self, ACol, ARow, Value, Accept);
end;

procedure TNxCustomGridControl.DoEditEnter;
begin
  if Assigned(FOnEditEnter) then FOnEditEnter(Self);  
end;

procedure TNxCustomGridControl.DoEditExit;
begin
  if Assigned(FOnEditExit) then FOnEditExit(Self);
end;

procedure TNxCustomGridControl.DoEditText(ACol, ARow: Integer;
  var Value: WideString);
begin
  if Assigned(FOnEditText) then FOnEditText(Self, ACol, ARow, Value);
end;

procedure TNxCustomGridControl.DoEndEditing(ACol, ARow: Integer;
  var Value: WideString; var Accept: Boolean);
begin
  if Assigned(FOnEndEditing) then FOnEndEditing(Self, ACol, ARow, Value, Accept);
end;

procedure TNxCustomGridControl.DoEnter;
begin
  inherited;
  RefreshArea(gaIndicator);
end;

procedure TNxCustomGridControl.DoExit;
begin
  if (gtEdit in GridState) or (gtInput in GridState) then
  begin
    ApplyEditing;
    EndEditing;
  end;
  inherited;
end;

procedure TNxCustomGridControl.DoFooterDraw(Sender: TObject;
  Index: Integer; Rect: TRect);
begin
  if Assigned(FOnCustomDrawFooter) then FOnCustomDrawFooter(Self, Index, Rect);
end;

procedure TNxCustomGridControl.DoHeaderDraw(Sender: TObject;
  Index: Integer; Rect: TRect);
begin
  if Assigned(FOnCustomDrawHeader) then FOnCustomDrawHeader(Self, Index, Rect);
end;

procedure TNxCustomGridControl.DoFooterCalculate(ACol: Integer;
  var Value: Double);
begin
  if Assigned(FOnFooterCalculate) then FOnFooterCalculate(Self, ACol, Value);
end;

procedure TNxCustomGridControl.DoFooterClick(ACol: Integer);
begin
  if Assigned(FOnFooterClick) then FOnFooterClick(Self, ACol);
end;

procedure TNxCustomGridControl.DoHeaderClick(ACol: Integer);
begin
  if Assigned(FOnHeaderClick) then FOnHeaderClick(Self, ACol);
end;

procedure TNxCustomGridControl.DoHeaderDblClick(ACol: Integer);
begin
  if Assigned(FOnHeaderDblClick) then FOnHeaderDblClick(Self, ACol);
end;

procedure TNxCustomGridControl.DoCellEditorChange(Sender: TObject);
begin
  if not FInplaceEditUpdate then DoEdit(FEditingCell.X, FEditingCell.Y, FInplaceEdit.Text);
end;

procedure TNxCustomGridControl.DoCellEditorEnter(Sender: TObject);
begin
	if not Focused then Invalidate;
end;

procedure TNxCustomGridControl.DoCellEditorExit(Sender: TObject);
begin
	if not Focused then Invalidate;
end;

procedure TNxCustomGridControl.DoCellEditorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	case Key of
    VK_TAB:
    begin
      ApplyEditing;
      EndEditing;
    end;
   	VK_RETURN:
    	begin
	      if (gtEdit in GridState)
          and not(ssCtrl in Shift)  then
        begin
          if not(csWantReturns in Columns[FEditingCell.X].ColumnStyle) then
          begin
            ApplyEditing;
            EndEditing;
            SetFocus;
          end;
        end;
        if (gtInput in GridState)
          and not(ssCtrl in Shift) then
				begin
          ApplyEditing;
	        AddRowFromInput;
          if FInputingColumn <> -1 then
          begin
            InplaceEdit.Text := Columns[FInputingColumn].GetInputValue;
          //--InplaceEdit.SelectAll;
          end;
				end;
      end;
    VK_ESCAPE:
      if goEscClearEdit in FOptions then InplaceEdit.Clear else
      begin
        EndEditing;
        SetFocus;
      end;
  end;
  KeyDown(Key, Shift);
end;

procedure TNxCustomGridControl.DoCellEditorKeyPress(Sender: TObject;
  var Key: Char);
begin
  KeyPress(Key);
end;

procedure TNxCustomGridControl.DoCellEditorKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  KeyUp(Key, Shift);
end;

procedure TNxCustomGridControl.DoInputAccept(var Accept: Boolean);
begin
  if Assigned(FOnInputAccept) then FOnInputAccept(Self, Accept);
end;

procedure TNxCustomGridControl.DoInputAdded;
begin
  if Assigned(FOnInputAdded) then FOnInputAdded(Self);
end;

procedure TNxCustomGridControl.DoInputSelectCell(ACol: Integer);
begin
  if Assigned(FOnInputSelectCell) then FOnInputSelectCell(Self, ACol);
end;

procedure TNxCustomGridControl.DoMeasuringRowHeight(Index: Integer;
  var RowHeight: Integer);
begin
  if Assigned(FOnMeasuringRowHeight) then FOnMeasuringRowHeight(Self, Index, RowHeight);
end;

procedure TNxCustomGridControl.DoApplyCell(ACol, ARow: Integer;
  var Value: WideString);
begin
  if Assigned(FOnApplyCell) then FOnApplyCell(Self, ACol, ARow, Value);
end;

procedure TNxCustomGridControl.DoApplyEditText(ACol, ARow: Integer;
  var Value: WideString);
begin
  if Assigned(FOnApplyEditText) then FOnApplyEditText(Self, ACol, ARow, Value);
end;

procedure TNxCustomGridControl.DoAfterEdit(ACol, ARow: Integer;
  Value: WideString);
begin
  if Assigned(FOnAfterEdit) then FOnAfterEdit(Self, ACol, ARow, Value);
end;

procedure TNxCustomGridControl.DoAfterRowMove(FromPos, ToPos: Integer);
begin
  if Assigned(FOnAfterRowMove) then FOnAfterRowMove(Self, FromPos, ToPos);
end;

procedure TNxCustomGridControl.DoAfterSort(ACol: Integer);
begin
  if Assigned(FOnAfterSort) then FOnAfterSort(Self, ACol);
end;

procedure TNxCustomGridControl.DoBeforeEdit(ACol, ARow: Integer;
  var Accept: Boolean);
begin
  if Assigned(FOnBeforeEdit) then FOnBeforeEdit(Self, ACol, ARow, Accept);
end;

procedure TNxCustomGridControl.DoBeforeSelect(ACol, ARow: Integer;
  var Accept: Boolean);
begin
  if Assigned(FOnBeforeSelect) then FOnBeforeSelect(Self, ACol, ARow, Accept);
end;

procedure TNxCustomGridControl.DoCalculateRow(Index: Integer; var Accept: Boolean);
begin
  if Assigned(FOnCalculateRow) then FOnCalculateRow(Self, Index, Accept);
end;

procedure TNxCustomGridControl.DoCellClick(ACol, ARow: Integer);
begin
  if Assigned(FOnCellClick) then FOnCellClick(Self, ACol, ARow);
end;

procedure TNxCustomGridControl.DrawCell(ACol, ARow: Integer; CellRect: TRect);
var
  DrawRect, UpdRect, ClpRect, EditRect, PaddingRect: TRect;
  CellColor, GridColor: TColor;
  CellState: TCellState;
  DefaultDraw: Boolean;
begin
  if not Columns[ACol].Visible then Exit;

  CellState := [];
  GridColor := FGridLinesColor;
  DefaultDraw := True;

  DrawRect := CellRect;
  GetClipBox(Canvas.Handle, UpdRect);

  if (DrawRect.Right < UpdRect.Left) or (DrawRect.Left > UpdRect.Right)
 	 	or (DrawRect.Bottom < UpdRect.Top) or (DrawRect.Top > UpdRect.Bottom) then Exit;

  Canvas.Font.Assign(Columns[ACol].Font);
  CellColor := GetActualCellColor(ACol, ARow);
  if IsCellHighlighted(ACol, ARow) then
  begin
    Include(CellState, csSelected);
    Columns[ACol].Display.Highlighted := True;
    if aoBoldTextSelection in AppearanceOptions then Include(CellState, csBoldTextSelection);
  end else Columns[ACol].Display.Highlighted := False;
  if (Focused) and (not(aoHideFocus in AppearanceOptions)) then Include(CellState, csFocused);

  DoCellColoring(ACol, ARow, CellColor, GridColor, CellState); { event }

  if (Columns[ACol].Sorted) and not(csSelected in CellState) then
  begin
    case FSortedStyle of
      soDarker: CellColor := TGraphicsProvider.BlendColor(clBlack, CellColor, 10);
      soWhite: CellColor := clWhite;
    end;
  end;

  ClpRect := DrawRect;

  if Columns[ACol].Position >= FFixedCols then
  begin
    if ClpRect.Left < GetScrollRect.Left then ClpRect.Left := GetScrollRect.Left;
  end;

  SetClipCellRect(ClpRect);

  { 1/9/15: StyleServices require this hack. Maybe
            can be done better. }
  Canvas.Pen.Color := clBlack;

  if (goGrid in Options) and (GridStyle = gsReport) then
  begin
    DrawGrid(ACol, ARow, DrawRect, GridColor);
  end;

  ExcludeGrid(DrawRect);

  if (aoDontFillCells in FAppearanceOptions)
    or (Columns[ACol].DrawingOptions = doCustomOnly) then DefaultDraw := False;

  try
    FPaintingCell := Point(ACol, ARow);

    { Background }
    DoDrawCellBackground(ACol, ARow, DrawRect, CellState, DefaultDraw);

    { Content }
    with Columns[ACol].Display do
    begin
      Handle := Self.Handle;
      Canvas := Self.Canvas;
      BiDiMode := Self.BiDiMode;
      ClientRect := DrawRect;
      ImageIndex := GetRowImageIndex(ARow);
      HighlightedTextColor := Self.HighlightedTextColor;
      SetDisplayParams(ACol, ARow, Columns[ACol].Display);

      EditRect := GetEditingRect;

      if (gtEdit in GridState) and (FEditingCell.X = ACol) and (FEditingCell.Y = ARow) then
      begin
        Column.AdjustEditRect(GetRowLevel(ARow), EditRect);
        InflateRect(EditRect, -1, -1);
        Dec(EditRect.Right);
        ExcludeClipRect(Canvas.Handle, EditRect.Left, EditRect.Top, EditRect.Right, EditRect.Bottom);
      end;

      { Event }
      SetDisplayCell(Column, ACol, ARow, DrawRect, CellState);

      if DefaultDraw then PaintBackground(CellColor, True);

      Selected := (ACol = SelectedColumn) and (ARow = SelectedRow);

      { Inflate rect for Padding }
      PaddingRect := ClientRect;
      InflateRect(PaddingRect, -Column.Padding, 0);
      ClientRect := PaddingRect;

      { call virtual method for drawing data }
      if (Columns[ACol].DrawingOptions = doNormal)
        or (Columns[ACol].DrawingOptions = doCustom) then
      begin
        if not IsCellEmpty(ACol, ARow) and DrawCellData(ACol, ARow, CellState)
          then Paint;
      end;

      { draw hints }
      if (aoHintMarks in AppearanceOptions) and (GetCellHint(ACol, ARow) <> '')
        then Columns[ACol].Display.DrawHintMark;
    end;

    if Columns[ACol].DrawingOptions <> doNormal then DoCustomDrawCell(Columns[ACol].Index, ARow, DrawRect, CellState); { Event method }
    if not(goSelectFullRow in Options) and (SelectedColumn = ACol) and (SelectedRow = ARow) then DrawFocusCell;

  finally
    FPaintingCell := Point(-1, -1);
    SetClipRect(Canvas, ClientRect);
  end;

end;

function TNxCustomGridControl.DrawCellData(ACol, ARow: Integer;
  CellState: TCellState): Boolean;
begin
  Result := False;
  with Canvas do
  begin
    Font.Assign(Columns[ACol].Font);
    if not Enabled then Font.Color := clGrayText else
      Font.Color := GetActualCellFontColor(ACol, ARow);
    if csBoldTextSelection in CellState then
      Font.Style := Font.Style + [fsBold];
  end;
end;

function TNxCustomGridControl.GetCaptionRect: TRect;
begin
  with Result do
  begin
    Left := GetBodyRect.Left - HorzScrollBar.Position;
    Top := GetBodyRect.Top + 4;
    Right := -HorzScrollBar.Position + ClientWidth;
    Bottom := Top + Canvas.TextHeight(Caption);
  end;
end;

procedure TNxCustomGridControl.DrawGrid(ACol, ARow: Integer;
	ARect: TRect; LineColor: TColor);
begin
  with Canvas do
  begin
    if GridSpace[lpBottom] > 0 then
    begin
      if (ARow = RowCount - 1) and (GridLinesStyle = lsFramed)
        then Pen.Color := clBlack else Pen.Color := LineColor;
      PolyLine([Point(ARect.Left, ARect.Bottom), Point(ARect.Right + 1, ARect.Bottom)]);
    end;

    if GridSpace[lpTop] > 0 then
    begin
      Pen.Color := clBtnHighlight;
      PolyLine([Point(ARect.Left, ARect.Top - 1), Point(ARect.Right + 1, ARect.Top - 1)]);
    end;

    if GridSpace[lpLeft] > 0 then
    begin
      Pen.Color := clBtnHighlight;
      PolyLine([Point(ARect.Left, ARect.Top - 1), Point(ARect.Left, ARect.Bottom + 1)]);
    end;

    if GridSpace[lpRight] > 0 then
    begin
	    if (Columns[ACol].Location = clRightSide) and (ARow < RowCount)
	      and (GridLinesStyle = lsFramed)
          then Pen.Color := clBlack
            else Pen.Color := LineColor;
      PolyLine([Point(ARect.Right - 1, ARect.Top - 1), Point(ARect.Right - 1, ARect.Bottom + 1)]);
    end;
  end;
end;

procedure TNxCustomGridControl.DrawHeaders;
var
  col, pos: Integer;
  Column: TNxCustomColumn;
begin
  col := 0;
  pos := GetBodyRect.Left - HorzScrollBar.Position;
  while (col < Columns.Count) and (pos < ClientWidth) do
  begin
    Column := Columns.PositionItem[col];
    
    if Column.Visible then
    begin
      pos := pos + Column.Width;
      if pos + Column.Width >= 0 then
      begin
        { Font }
        if Column.Header.ParentFont
        then
          Canvas.Font.Assign(Self.Font)
        else
          Canvas.Font.Assign(Column.Header.Font);

        FCurrentStyleDisplay.UseThemes := EnableVisualStyles and IsThemed;
        FCurrentStyleDisplay.Canvas := Canvas;

        FCurrentStyleDisplay.DrawHeader(Column, Column.GetMemberRect(ckHeader));
      end;
    end; { if visible }
    Inc(col);
  end;
  if Pos < ClientWidth then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(Rect(pos, 0, ClientWidth, HeaderSize));
  end;
end;

procedure TNxCustomGridControl.SetClipCellRect(ARect: TRect);
var
	cr: TRect;
begin
	with ARect do
  begin
    cr := Rect(Left - GridSpace[lpLeft], Top - GridSpace[lpTop],
      Right + GridSpace[lpRight], Bottom + GridSpace[lpBottom]);
    if cr.Bottom > GetBodyRect.Bottom then cr.Bottom := GetBodyRect.Bottom;
    SetClipRect(Canvas, cr);
  end;
end;

procedure TNxCustomGridControl.SetDisplayCell(Column: TNxCustomColumn; ACol, ARow: Integer;
  CellRect: TRect; CellState: TCellState);
begin
  try
    BeginUpdate;

    if Assigned(Column.OnSetCell) then
      Column.OnSetCell(Column, ACol, ARow, CellRect, CellState);

  finally
    EndUpdate(False);
  end;
end;

procedure TNxCustomGridControl.SetDisplayParams(ACol, ARow: Integer;
  Display: TColumnDisplay);
begin

end;

procedure TNxCustomGridControl.SetInplaceEditEvents;
begin
  if Assigned(FInplaceEdit) then
  begin
    with FInplaceEdit do
    begin
      OnChange := DoCellEditorChange;
      OnExit := DoCellEditorExit;
      OnEnter := DoCellEditorEnter;
      OnKeyDown := DoCellEditorKeyDown;
      OnKeyPress := DoCellEditorKeyPress;
      OnKeyUp := DoCellEditorKeyUp;
    end;
  end;
end;

procedure TNxCustomGridControl.RefreshArea(Area: TGridArea);
var
  ARect: TRect;
  function GridAreaVisible: Boolean;
  begin
    case Area of
    	gaBody: Result := True;
    	gaFooter: Result := goFooter in Options;
    	gaHeader: Result := goHeader in Options;
    	gaIndicator: Result := goIndicator in Options;
    	gaInput: Result := goInput in Options;
      else Result := False;
    end;
  end;
begin
  case Area of
    gaBody: ARect := GetBodyRect;
    gaFooter: ARect := GetFooterRect;
    gaHeader: ARect := GetHeaderRect;
    gaIndicator: ARect := GetIndicatorRect;
    gaInput: ARect := GetInputRect;
  end;
  if GridAreaVisible then RedrawWindow(Handle, @ARect, 0, RDW_INVALIDATE);
end;

procedure TNxCustomGridControl.RefreshCell(ACol, ARow: Integer);
var
	CellRect: TRect;
begin
  if CellBounds(ACol, ARow) then
  begin
    CellRect := GetCellRect(ACol, ARow);
    CellRect.Right := CellRect.Right + GridSpace[lpBottom];
    CellRect.Bottom := CellRect.Bottom + GridSpace[lpBottom];
    RedrawWindow(Handle, @CellRect, 0, RDW_INVALIDATE);
  end;
end;

procedure TNxCustomGridControl.RefreshColumn(Column: TNxCustomColumn;
  Area: TGridArea);
var
	ARect: TRect;
begin
  if IsUpdating then Exit;
  if Assigned(Column) then
  begin
    case Area of
      gaBody: ARect := GetBodyRect;
      gaFooter: ARect := GetFooterRect;
      gaHeader: ARect := GetHeaderRect;
      gaIndicator: ARect := GetIndicatorRect;
      gaInput: ARect := GetInputRect
      else ARect := ClientRect;
    end;
    ARect.Left := Column.Left;
    if Column.Position >= FixedCols then Dec(ARect.Left, HorzScrollBar.Position);
    ARect.Right := ARect.Left + Column.Width;
    RedrawWindow(Handle, @ARect, 0, RDW_INVALIDATE);
  end;
end;

procedure TNxCustomGridControl.RefreshColumnSlide(Column: TNxCustomColumn);
var
  i, Y: Integer;
  R: TRect;
begin
  Invalidate;
  Exit;
  Y := GetBodyRect.Top;
  for i := VertScrollBar.Position to RowCount - 1 do
  begin
    R := Column.SlideRect;
    Inc(R.Top, Y);
    Inc(R.Bottom, Y);
    InvalidateRect(Handle, @R, False);
    Inc(Y, SlideSize + GridSpace[lpBottom]);
    if Y > ClientHeight then Exit;
  end;
end;

procedure TNxCustomGridControl.RefreshRange(FromPos, ToPos: Integer);
var
  T, Y1, Y2: Integer;
  R: TRect;
begin
  if FromPos > ToPos then
  begin
    T := FromPos;
    FromPos := ToPos;
    ToPos := T;
  end;
  case FGridStyle of
    gsReport:
    begin
      Y1 := GetRowTop(FromPos);
      Y2 := GetRowTop(ToPos) + GetRowHeight(ToPos);
    end;
    gsSlides:
    begin
      Y1 := GetSlideTop(FromPos);
      Y2 := GetSlideTop(ToPos) + SlideSize;
    end else
    begin
      Y1 := 0;
      Y2 := 0;
    end;
  end;
  R := Rect(0, Y1, GetBodyRect.Right, Y2);
  InvalidateRect(Handle, @R, False);  
end;

procedure TNxCustomGridControl.RecalculateGridSpace;
begin
  FGridSpace[lpLeft] := 0;
  FGridSpace[lpTop] := 0;
  FGridSpace[lpRight] := 0;
  FGridSpace[lpBottom] := 0;
  if goGrid in FOptions then         
  begin
    if (FGridLinesStyle <> lsHorizontalOnly)
      and (FGridLinesStyle <> lsActiveHorzOnly) then
    begin
      FGridSpace[lpRight] := 1;
      if ao3DGridLines in FAppearanceOptions then FGridSpace[lpLeft] := 1;
    end;
    if FGridLinesStyle <> lsVerticalOnly then
    begin
      FGridSpace[lpBottom] := 1;
      if ao3DGridLines in FAppearanceOptions then FGridSpace[lpTop] := 1;
    end;
  end;
  FGridSpace[lpTopBottom] := FGridSpace[lpTop] + FGridSpace[lpBottom];
end;

procedure TNxCustomGridControl.UpdateHorzScrollBar;

  function GetColTotalWidth: Integer;
  var
    i: integer;
  begin
    Result := 0;
    for i := 0 to Columns.Count - 1 do
    begin
      if Columns[i].Visible then Inc(Result, Columns[i].Width);
    end;
    if goIndicator in Options then Inc(Result, sizIndicator);
  end;

var
  m, ps, lc, p: Integer;
begin
  case GridStyle of
    gsReport:
    begin
      m := GetColTotalWidth;
      ps := ClientWidth + 1;
      lc := HorzScrollBar.PageSize - 10;
      p := GetRealScrollPosition(HorzScrollBar);

      if ClientWidth > GetSystemMetrics(SM_CXHSCROLL) then
      begin
        HorzScrollBar.Visible := m > ps;
      end else HorzScrollBar.Visible := False;

      // 12/9/14: Values must be set if Visible or not
      HorzScrollBar.SetValues(m, ps, lc);
      if HorzScrollBar.Visible then HorzScrollBar.Position := p;

    end else HorzScrollBar.Visible := False;
  end;
end;

procedure TNxCustomGridControl.RefreshCellEditor;
const
  RedrawEdit: array[Boolean] of DWORD = (SWP_NOREDRAW, 0);
var
  Column: TNxCustomColumn;
  EditRect, R: TRect;
begin
  Column := nil;
  if gtEdit in GridState then
	begin
	  if (FEditingCell.X >= 0) and (FEditingCell.Y >= 0) then
		begin
      Column := Columns[FEditingCell.X];
	    EditRect := GetCellRect(FEditingCell.X, FEditingCell.Y);
      Column.AdjustEditRect(GetRowLevel(FEditingCell.Y), EditRect);
      ExcludeGrid(EditRect); { exclude left and right grid lines }
      if not (goGrid in FOptions) then Dec(EditRect.Right);
		  if EditRect.Top < GetBodyRect.Top then
			begin
		    FInplaceEdit.Visible := False;
			  Exit;
			end;
      if EditRect.Left < GetBodyRect.Left
        then EditRect.Left := GetBodyRect.Left;
		end;
	end else if gtInput in GridState then
  begin
    Column := Columns[FInputingColumn];
    EditRect := GetInputCellRect(FInputingColumn);
  end else Exit;

  InflateRect(EditRect, -1, -1);
  if EditRect.Left < 0 then EditRect.Left := 0;
  if EditRect.Left < GetBodyRect.Left then EditRect.Right := GetBodyRect.Left;

  with FInplaceEdit do
  begin
    ShowWindow(Handle, SW_HIDE);
		SetWindowPos(Handle, HWND_TOP, EditRect.Left, EditRect.Top,
    	EditRect.Right - EditRect.Left, EditRect.Bottom - EditRect.Top,
	    SWP_SHOWWINDOW or RedrawEdit[csRedrawInplaceEdit in Column.ColumnStyle]);
    Windows.SetFocus(Handle);
    R := ClientRect;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TNxCustomGridControl.RefreshFromColumn(
  FromColumn: TNxCustomColumn);
var
  r: TRect;
begin
  r := Rect(VertScrollBar.Position - FromColumn.Left, 0,
    ClientWidth, ClientHeight);
  InvalidateRect(Handle, @r, False);
end;

procedure TNxCustomGridControl.RefreshIndicator(Index: Integer);
var
  R: TRect;
begin
  if InRange(Index, 0, Pred(RowCount)) then
  begin
    R := GetRowRect(Index);
    { Include Grid Gaps }
    Dec(R.Top, GridSpace[lpTop]);
    Inc(R.Bottom, GridSpace[lpBottom]);
    R.Right := sizIndicator;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TNxCustomGridControl.RefreshRow(const Index: Integer; BorderOnly: Boolean);
var
  R: TRect;
begin
  if RowExist(Index) and InRange(Index, FFirstRow, FLastRow) then
  begin
    R := GetRowRect(Index);
    R := Rect(0, R.Top, GetBodyRect.Right, R.Bottom);
    InvalidateRect(Handle, @R, False);
    if BorderOnly then
    begin
      InflateRect(R, -1, -1);
      ValidateRect(Handle, @R);
    end;
  end;
end;

procedure TNxCustomGridControl.RefreshRowGrid(const Index: Integer);
var
  TotalRect: TRect;
begin
  case FGridStyle of
    gsReport: TotalRect := GetRowRect(Index);
    gsSlides: TotalRect := GetSlideRect(Index);
  end;
  TotalRect.Top := TotalRect.Bottom - 1;
  TotalRect.Bottom := TotalRect.Top + GridSpace[lpBottom];
  InvalidateRect(Handle, @TotalRect, False);
end;

procedure TNxCustomGridControl.RefreshSlide(Index: Integer; BorderOnly: Boolean);
var
  R: TRect;
begin
  R := GetSlideRect(Index);
  InvalidateRect(Handle, @R, False);
  if BorderOnly then
  begin
    InflateRect(R, -3, -4);
    ValidateRect(Handle, @r);
  end;
end;

procedure TNxCustomGridControl.ResetView;
begin
  FFirstRow := 0;
  VertScrollBar.Position := 0;
end;

procedure TNxCustomGridControl.Resort;
begin
  if Assigned(FSortedColumn) then
    SortColumn(FSortedColumn, FSortedColumn.SortKind = skAscending);
end;

procedure TNxCustomGridControl.RevertStyle(const Index: Integer);
begin

end;

procedure TNxCustomGridControl.UpdateVertScrollBar;
var
  ScrollMax, PageSize: Integer;

  function GetFirstVisibleRowNumber:integer;
  var
   i:integer;
  begin
    Result := 0;
    for i := 0 to FFirstRow - 1 do
    begin
      if GetRowVisible(i) then
         Inc(Result);
    end;
  end;

  function GetRowsInPage: Integer;
  var
    i, Pos: Integer;
  begin
    Pos := GetBodyRect.Top;;
    Result := 0;
    for i := FFirstRow to Pred(RowCount) do
      if GetRowVisible(i) then
      begin
        if Pos + RowHeight[i] + GridSpace[lpTopBottom] > GetBodyRect.Bottom then Break;
        Inc(Result);
        Inc(Pos, RowHeight[i] + GridSpace[lpTopBottom]);
      end;
  end;

  function GetSlidesTotalHeight: Integer;
  var
    i, Pos: Integer;
  begin
    Pos := GetBodyRect.Top;;
    Result := 0;
    for i := FFirstRow to Pred(RowCount) do
      if GetRowVisible(i) then
      begin
        if Pos + SlideSize + GridSpace[lpTopBottom] > GetBodyRect.Bottom then Break;
        Inc(Result);
        Inc(Pos, SlideSize + GridSpace[lpTopBottom]);
      end;
  end;

begin
  ScrollMax := GetVisibleRows;

  { When only one row exists, scrollbar won't be visible }
  if GetRowCount = 1 then ScrollMax := 0;

  if GridStyle = gsReport
    then PageSize := GetRowsInPage
    else PageSize := GetSlidesTotalHeight;

  if ScrollMax > PageSize then
  begin
    VertScrollBar.Max := ScrollMax;
    VertScrollBar.PageSize := PageSize + 1;
    VertScrollBar.LargeChange := VertScrollBar.PageSize;
  end
  else VertScrollBar.Max := 0;

  if ScrollMax <= PageSize + 1 then
     VertScrollbar.Position := GetFirstVisibleRowNumber;
end;

function TNxCustomGridControl.CellBounds(ACol, ARow: Integer): Boolean;
begin
  Result := (ACol < Columns.Count) and (ARow < RowCount)
    and (ACol >= 0) and (ARow >= 0);
end;

procedure TNxCustomGridControl.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TNxCustomGridControl.DeleteRow(Index: Integer);
begin
  EndEditing;
end;

procedure TNxCustomGridControl.EndUpdate;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  if (FUpdateCount = 0) and CanUpdate then
  begin
    Invalidate;
    UpdateVertScrollBar;
    UpdateHorzScrollBar;
  end;
end;

procedure TNxCustomGridControl.ExcludeGrid(var CellRect: TRect);
begin
  Inc(CellRect.Left, GridSpace[lpLeft]);
  Dec(CellRect.Right, GridSpace[lpRight]);
end;

function TNxCustomGridControl.Focused: Boolean;
begin
  Result := (inherited Focused) or ((Assigned(InplaceEdit))
  	and (InplaceEdit.Focused));
end;

procedure TNxCustomGridControl.EndEditing;
var
  Accept: Boolean;
  S: WideString;
begin
  Accept := True;
  if (gtEdit in GridState) and Assigned(InplaceEdit) then
  begin
    S := InplaceEdit.AsString;
    DoEndEditing(FEditingCell.X, FEditingCell.Y, S, Accept);
    InplaceEdit.AsString := S;
  end;
  if not Accept then Exit;
	if Assigned(InplaceEdit) then
	begin
    ShowWindow(InplaceEdit.Handle, SW_HIDE);
    if gtEdit in GridState then RefreshCell(FEditingCell.X, FEditingCell.Y);
    if gtInput in GridState then RefreshColumn(Columns[FInputingColumn], gaInput);
    SetClipRect(Canvas, ClientRect);
	end;
  if gtEdit in FGridState then
  begin
    DoEditExit; { event }
  end;
	FGridState := FGridState - [gtEdit, gtInput];
  FEditingCell := Point(-1, -1);
  if FInputingColumn <> -1 then
  begin
    Columns[FInputingColumn].Input := False;
    FInputingColumn := -1;
  end;
  InplaceEdit := nil; { important }
end;

procedure TNxCustomGridControl.EditCell(ACol, ARow: Integer;
  AText: WideString);
var
	ContinueEditing: Boolean;
  EditText: WideString;
begin
  if (ACol = FEditingCell.X) and (ARow = FEditingCell.Y)
    or (not(ceEditable in Columns[ACol].ColumnState)) or ReadOnly or not CanEdit then Exit;

  if not Assigned(Columns[ACol].InplaceEdit) and
    not Assigned(Columns[ACol].Editor) then Exit;

  if not CellBounds(ACol, ARow) then Exit;

  ContinueEditing := True;
  DoBeforeEdit(ACol, ARow, ContinueEditing);
  if not ContinueEditing then Exit;

  ApplyEditing;
  EndEditing;

  Include(FGridState, gtEdit);
  FEditingCell := Point(ACol, ARow);

  if Length(AText) > 0 then EditText := AText
    else EditText := Cells[ACol, ARow];

  if not Assigned(Columns[ACol].InplaceEdit) then
  begin
    if Columns[ACol].Editor = nil then Exit;
    InplaceEdit := Columns[ACol].Editor;
    SetInplaceEditEvents;
    with InplaceEdit do
    begin
      Columns[ACol].BeginEditing;
      EditorUpdating := False;
      Color := GetCellColor(ACol, ARow);
      Font.Assign(Columns[ACol].Font);
      BeginEditing;
    end;
  end else
  begin
    InplaceEdit := Columns[ACol].InplaceEdit;
    if not(goInplaceEditEvents in Options) then SetInplaceEditEvents;
  end;

  { 2/24/07:  OnEdit not occur when text is empty }
  if AText = '' then FInplaceEditUpdate := True;

  DoApplyEditText(ACol, ARow, EditText); { event }
  InplaceEdit.Text := EditText;

  PrepareEdit;

  { Set Position }
  RefreshCellEditor;

  { update edit after text is set }
  Columns[ACol].UpdateEdit;

  FInplaceEditUpdate := False;

  if coEditorAutoSelect in Columns[ACol].Options
    then FInplaceEdit.SelectAll else FInplaceEdit.SelStart := Length(FInplaceEdit.Text);

  DoEditEnter; { Event }
end;

procedure TNxCustomGridControl.InputColumn(Column: TNxCustomColumn;
  Value: WideString);
begin
  InputSelected := True;
  SelectedColumn := Column.Index;
  if (gtEdit in GridState) or (gtInput in GridState) then
  begin
    ApplyEditing;
    EndEditing;
  end;

  if (Column.Editor = nil) and (Column.InplaceEdit = nil) then Exit;
  if (not(ceCanInput in Column.ColumnState)) or ReadOnly then Exit;

  Include(FGridState, gtInput);

  if not Assigned(Column.InplaceEdit) then
  begin
    InplaceEdit := Column.Editor;
    SetInplaceEditEvents;
    with InplaceEdit do
    begin
      Column.BeginEditing;
      EditorUpdating := False;
      Color := Column.Color;
      AutoSelect := False;
      Font.Color := Column.Font.Color;
      BeginEditing;
    end;
  end else
  begin
    InplaceEdit := Column.InplaceEdit;
    if not(goInplaceEditEvents in Options) then SetInplaceEditEvents;
  end;

  { event }
  FInputingColumn := Column.Index;
  Column.Input := True;

  FInplaceEditUpdate := True;

  if Value <> '' then InplaceEdit.Text := Value else InplaceEdit.Text := Column.InputValue;
  Column.UpdateEdit;

  FInplaceEditUpdate := False;

  FEditingCell := Point(Column.Index, -1);

  RefreshCellEditor;
  if coEditorAutoSelect in Column.Options then InplaceEdit.SelectAll
    else FInplaceEdit.SelStart := Length(FInplaceEdit.Text);

  DoInputSelectCell(Column.Index); { Event }
end;

procedure TNxCustomGridControl.InsertRow(Pos: Integer; Count: Integer);
begin
  EndEditing;
  if Pos < FFirstVisibleRow then FFirstVisibleRow := Pos;
  if VertScrollBar.Position = 0 then FFirstRow := FFirstVisibleRow;
end;

function TNxCustomGridControl.IsCellHighlighted(ACol, ARow: Integer): Boolean;
begin
  Result := False;
  if (GridStyle = gsSlides) and not(aoHighlightSlideCells in AppearanceOptions) then Exit;
  if (InputSelected) then Exit;
  if (coDontHighlight in Columns[ACol].Options) then Exit;
  if (not Focused) and (aoHideSelection in AppearanceOptions) then Exit;
  if goSelectFullRow in Options then
  begin
    if Selected[ARow] then
      if (SelectedColumn = ACol) and (SelectedRow = ARow) then
      begin
      	Result := not((aoIndicateSelectedCell in AppearanceOptions) or
        	((ACol = FEditingCell.X) and (ARow = FEditingCell.Y)))
      end else Result := True;
  end else
  begin
    Result := ((SelectedColumn = ACol) and (SelectedRow = ARow))
     	and (not ((ACol = FEditingCell.X) and (ARow = FEditingCell.Y)));
  end;
end;

function TNxCustomGridControl.IsRowInView(const Index: Integer): Boolean;
begin
  Result := (Index < (FFirstRow + GetVisibleCount)) and (Index >= FFirstRow);
  //Result := SelectedRow < Pred(FFirstRow + GetVisibleCount);
end;

procedure TNxCustomGridControl.LoadFromIni(const FileName: WideString; ID: string);
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(FileName);
    LoadFromIniFile(FileName, IniFile, ID);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TNxCustomGridControl.LoadFromRegistry(const KeyName: WideString;
  ID: string);
var
  IniFile: TRegistryIniFile;
begin
  try
    IniFile := TRegistryIniFile.Create(KeyName);
    LoadFromIniFile(KeyName, IniFile, ID);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TNxCustomGridControl.LoadFromStream(Stream: TStream);
var
  Size: Int64;
  S: string;
  Separator: Char;
begin
  if (Stream.Size = 1) or (Stream.Size = Stream.Position) then exit;
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetString(S, nil, Size);
    Stream.Read(Pointer(S)^, Size);
    Separator := S[1];
    S := rightstr(S,Length(S)-Length(Separator));
    SetTextStr(S,Separator);
  finally
    EndUpdate;
  end;
end;

procedure TNxCustomGridControl.LoadFromIniFile(Name: WideString; IniFile: TCustomIniFile;
  ID: string);
var
  i, pos: Integer;
begin
  for i := 0 to Columns.Count - 1 do
  begin
    if IniFile.ReadString('Columns Sort Kind' + ID, 'Column' + IntToStr(i), 'Ascending') = 'Ascending'
        then Columns[i].SortKind := skAscending else Columns[i].SortKind := skDescending;
    Columns[i].Visible := IniFile.ReadBool('Visible Columns' + ID, 'Column' + IntToStr(i), True);
    Columns[i].Sorted := IniFile.ReadBool('Sorted' + ID, 'Column' + IntToStr(i), False);
    pos := IniFile.ReadInteger('Positions' + ID, 'Column' + IntToStr(i), i);
    Columns.PositionItem[pos] := Columns[i];
    Columns[i].Width := IniFile.ReadInteger('Columns Sizes' + ID, 'Column' + IntToStr(i), Columns[i].Width);
    Columns.UpdateColumns(True);
  end;
end;

procedure TNxCustomGridControl.LoadFromTextFile(const FileName: WideString;
	Separator: WideChar = ','; MultiLineSeparator: WideChar = '|';
  StartRow: Integer = 0);
var
  b: Byte;
  w: Word;
  fw: File of WideChar;
  f: File of Byte;
  fa: File of Char;
  QChar, wc: WideChar;
  Ch: Char;
  QNo: Integer;
  Value: WideString;
  UnicodeFile, UnicodeBigEndian, AddValue, NewRow, EofF: Boolean;
  ColumnIndex, RowIndex, ReadIndex: Integer;
begin
  QChar := '"';
  ClearRows;
  ColumnIndex := -1;
  RowIndex := -1;
  ReadIndex := 0;
  UnicodeFile := False;
  UnicodeBigEndian := False;

  { check file encoding }
  AssignFile(f, FileName);
  FileMode := 0;
  Reset(F);
  if FileSize(F) >= 2 then
  begin
    Read(f, b); { read first byte }
    if b = 255 then
    begin
      Read(f, b);
      if b = 254 then UnicodeFile := True;
    end else if b = 254 then
    begin
      Read(f, b);
      if b = 255 then
      begin
        UnicodeBigEndian := True;
        UnicodeFile := True;
      end;
    end;
  end;
  Close(F);

  { open file for reading }
  if UnicodeFile then
  begin
    AssignFile(fw, Filename);
    FileMode := 0;
    Reset(fw);
    { ignore first widechar }
    Read(fw, wc);
    EofF := Eof(fw);
  end else
  begin
    AssignFile(fa, Filename);
    FileMode := 0;
    Reset(fa);
    EofF := Eof(fa);
  end;

  AddValue := False;
  NewRow := True;
  QNo := 0;
  while not EofF do
  begin
    if UnicodeFile then
    begin
      Read(fw, wc);
      if UnicodeBigEndian then
      begin
        w := Ord(wc);
        wc := Widechar(((w and $255) shl 8) + (w  shr 8)); { rotate bytes }
      end;
      EofF := Eof(fw);
    end else
    begin
      Read(fa, ch);
      wc := WideChar(ch);
      EofF := Eof(fa);
    end;

    if wc = Separator then
    begin
      if (QNo mod 2 = 0) then AddValue := True else Value := Value + wc;
    end else if wc = MultiLineSeparator then
    begin
      Value := Value + #13#10;
    end else if wc = QChar then
    begin
      Inc(QNo);
      if (QNo mod 2 = 1) and ((Value <> '') or (QNo = 3)) then Value := Value + QChar;
    end else if wc = #13 then
    begin

    end else if wc = #10 then AddValue := True else Value := Value + wc;

    if AddValue then
    begin
      QNo := 0;
      AddValue := False;
      if NewRow then
      begin
        NewRow := False;
        if ReadIndex >= StartRow then
        begin
          AddRow;
          Inc(RowIndex);
        end;
        Inc(ReadIndex); { Row in file }
        ColumnIndex := -1;
      end;

      Inc(ColumnIndex);

      if ReadIndex > StartRow then
      begin
        { Assign Value to Cell }
        Cells[ColumnIndex, RowIndex] := Value;

        { Event }
        if Assigned(FOnLoadProgress) then FOnLoadProgress(Self, ColumnIndex, RowIndex);
      end;

      Value := '';

      if wc = #10 then NewRow := true;
    end;
  end; { while }

  if Value <> '' then
  begin
    Inc(ColumnIndex);
    Cells[ColumnIndex,RowIndex] := Value;
  end;
  if UnicodeFile then Close(fw) else Close(fa);
end;

procedure TNxCustomGridControl.MoveRow(FromPos, ToPos: Integer);
begin
  Invalidate;
  EndEditing;
end;

procedure TNxCustomGridControl.MoveByRow(MoveDown: Boolean; Shift: TShiftState = []);
var
  NewSelected, i, g: Integer;
begin
  if MoveDown then
  begin
    for i := SelectedRow + 1 to RowCount - 1 do
    begin
      if GetRowVisible(i) and CanSelectCell(SelectedColumn, i) then
      begin
        NewSelected := i;
        SelectCell(SelectedColumn, NewSelected, Shift, True, Columns[SelectedColumn].AutoEdit);
        g := LastRowInView;
        if NewSelected >= g then ScrollToRow(NewSelected);
        Break;
      end;
    end;
  end else
  begin { MoveUp }
    if (SelectedRow = FFirstVisibleRow) and (goInput in Options)
      then InputSelected := True else
    begin
      for i := SelectedRow - 1 downto 0 do
      begin
        if GetRowVisible(i) and CanSelectCell(SelectedColumn, i) then
        begin
          NewSelected := i;
          SelectCell(SelectedColumn, NewSelected, Shift, True, Columns[SelectedColumn].AutoEdit);
          if NewSelected < FFirstRow then VertScrollBar.Position := VertScrollBar.Position - 1;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TNxCustomGridControl.MoveSelectionDown(Shift: TShiftState;
  NextControl: Boolean; SelectFirst: Boolean);
begin
  if RowCount = 0 then Exit;
  if InputSelected then InputSelected := False else
  begin
    if SelectedRow <= -1 then Exit;
    if SelectedRow >= GetLastVisibleRow then
    begin
      if NextControl then SelectNextControl;
      if SelectFirst then SelectFirstRow;
      Exit;
    end;
  end;
  MoveByRow(True, Shift);
end;

procedure TNxCustomGridControl.MoveSelectionLeft;
var
  PrevColumn: TNxCustomColumn;
  ACol, ARow: Integer;
begin
  if Columns.Exists(SelectedColumn) then
  begin
    PrevColumn := Columns[SelectedColumn].PrevColumn;
    ACol := PrevColumn.Index;
    ARow := SelectedRow;
    DoSelectionMove(ACol, ARow, Key); { event }
    SelectCell(ACol, SelectedRow, [], True, Columns[ACol].AutoEdit);
    if FGridStyle = gsReport then ScrollToColumn(Columns[ACol]);
  end;
end;

procedure TNxCustomGridControl.MoveSelectionRight;
var
  NextColumn: TNxCustomColumn;
  ACol, ARow: Integer;
begin
  if Columns.Exists(SelectedColumn) then
  begin
    NextColumn := Columns[SelectedColumn].NextColumn;
    ACol := NextColumn.Index;
    ARow := SelectedRow;
    DoSelectionMove(ACol, ARow, Key); { event }
    SelectCell(ACol, SelectedRow, [], True, Columns[ACol].AutoEdit);
    if FGridStyle = gsReport then ScrollToColumn(Columns[ACol]);
  end;
end;

procedure TNxCustomGridControl.MoveSelectionUp(Shift: TShiftState);
var
  i, Row: Integer;
begin
  Row := -1;
  if SelectedRow <= -1 then Exit;
  if SelectedRow = FirstVisibleRow then
  begin
    if (goInput in Options) and (GridStyle = gsReport) then
    begin
      InputSelected := True;
      Exit;
    end;
  end;
  if not InputSelected and (RowCount > 0) then
    for i := SelectedRow downto 0 do
      if GetRowVisible(i) and (i <> SelectedRow)
        and CanSelectCell(SelectedColumn, i) then
      begin
        Row := i;
        Break;
      end;
  if Row <> -1 then
  begin
    SelectCell(SelectedColumn, Row, Shift, True, Columns[SelectedColumn].AutoEdit);
    if Row < FFirstRow then VertScrollBar.Prior;
  end;
end;

procedure TNxCustomGridControl.MoveSelectionBy(Distance: Integer);
var
  i, Row: Integer;
begin
  i := 0;
  Row := SelectedRow;
  if Distance > 0 then
  begin
    while (i < Abs(Distance)) and (Row < LastVisibleRow) do
    begin
      Inc(Row);
      if GetRowVisible(Row) then Inc(i);
    end;
  end else if Distance < 0 then
  begin
    while (i < Abs(Distance)) and (Row > FirstVisibleRow) do
    begin
      Dec(Row);
      if GetRowVisible(Row) then Inc(i);
    end;
  end else Exit;
  SelectedRow := Row;
end;

procedure TNxCustomGridControl.MoveToNextCell(TabKey: Boolean);
var
  ACol, ARow: Integer;
  Key: TMoveSelectionKey;
begin
  if not Columns.Exists(SelectedColumn) then Exit;
  { If column is last visible and enabled column,
    move selection down }
  if Columns[SelectedColumn].Last then
  begin
    if not InputSelected then
    begin
      MoveSelectionDown([], TabKey and TabLeaveControl, TabKey);
      ACol := Columns.FirstEnabled.Index;
      ARow := SelectedRow;
      if TabKey then Key := mkTab else Key := mkUndefined;
      DoSelectionMove(ACol, ARow, Key); { event }
      SelectedColumn := ACol;
    end else if TabLeaveControl then SelectNextControl;
  end else
  begin
    if TabKey then MoveSelectionRight(mkTab) else MoveSelectionRight;
  end;
end;

procedure TNxCustomGridControl.MoveToPrevCell(TabKey: Boolean);
var
  ACol, ARow: Integer;
  Key: TMoveSelectionKey;
begin
  if not Columns.Exists(SelectedColumn) then Exit;
  { If Column is first visible and enabled column,
    move selection up }
  if Columns[SelectedColumn].First then
  begin
    if not InputSelected and (SelectedRow > FirstVisibleRow) then
    begin
      MoveSelectionUp;
      ACol := Columns.LastEnabled.Index;
      ARow := SelectedRow;
      if TabKey then Key := mkTab else Key := mkUndefined;
      DoSelectionMove(ACol, ARow, Key); { event }
      SelectedColumn := ACol;
    end else if FTabLeaveControl then SelectPrevControl;
  end else
  begin
    if TabKey then MoveSelectionLeft(mkTab)
      else MoveSelectionLeft;
  end;
end;

procedure TNxCustomGridControl.SaveToIni(const FileName: WideString; ID: string = '');
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(FileName);
    SaveToIniFile(FileName, IniFile, ID);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TNxCustomGridControl.SaveToIniFile(Name: WideString; IniFile: TCustomIniFile; ID: string);
var
  i: Integer;
begin
  IniFile.WriteInteger('Common' + ID, 'ColumnsCount', Columns.Count);
  for i := 0 to Columns.Count - 1 do
  begin
  	if Columns[i].SortKind = skAscending
      then IniFile.WriteString('Columns Sort Kind' + ID, 'Column' + IntToStr(i), 'Ascending')
	 		else IniFile.WriteString('Columns Sort Kind' + ID, 'Column' + IntToStr(i), 'Descending');
    IniFile.WriteBool('Visible Columns' + ID, 'Column' + IntToStr(i), Columns[i].Visible);
    IniFile.WriteBool('Sorted' + ID, 'Column' + IntToStr(i), Columns[i].Sorted);
    IniFile.WriteInteger('Positions' + ID, 'Column' + IntToStr(i), Columns[i].Position);
    IniFile.WriteInteger('Columns Sizes' + ID, 'Column' + IntToStr(i), Columns[i].Width);
  end;
  IniFile.UpdateFile;
end;

procedure TNxCustomGridControl.SaveToRegistry(const KeyName: WideString;
  ID: string; RootKey: HKEY);
var
  IniFile: TRegistryIniFile;
begin
  try
    IniFile := TRegistryIniFile.Create(KeyName);
    IniFile.RegIniFile.RootKey := RootKey;
    SaveToIniFile(KeyName, IniFile, ID);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TNxCustomGridControl.SetTextStr(const Value: string;
  Separator: Char);
var
  ColumnIndex,RowIndex: integer;
  P, Start: PChar;
  S, ts: string;
  NewRow: Boolean;
begin
  BeginUpdate;
  try
    ClearRows;
    ColumnIndex := -1;
    RowIndex := -1;
    NewRow := True;
    P := Pointer(Value);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not (P^ in [Separator,#0]) do Inc(P);
        SetString(S, Start, P - Start);
        S := StringReplace(S,'%'+ sLineBreak, sLineBreak, [rfReplaceAll]);
        if NewRow then
        begin
          NewRow := False;
          AddRow;
          Inc(RowIndex);
          ColumnIndex := 0;
        end
        else Inc(ColumnIndex);
        Cells[ColumnIndex,RowIndex] := S;
        if (P^ <> #0) then
        begin
             if P^ = Separator then Inc(P);
             SetString(ts,P,Length(sLineBreak));
             if ts = sLineBreak then
             begin
                  NewRow := True;
                  Inc(P,Length(sLineBreak));
             end;
        end;
      end;
  finally
    EndUpdate;
  end;
end;

function TNxCustomGridControl.RowExist(Index: Integer): Boolean;
begin
  Result := (Index >= 0) and (RowCount > 0) and (Index < RowCount);
end;

procedure TNxCustomGridControl.SaveToHtml(const FileName: WideString;
  SaveSettings: TNxHtmlSaveSettings);
var
	i, j: Integer;
  Html, Css: TNxStringList;
  HtmlFile, CssFile: TextFile;
  S: WideString;
  CssFileName: string;

  function ExtractName(const FileName: string): string;
  var
    s: string;
  begin
    S := ExtractFileName(FileName);
    Result := LeftStr(S, Length(S) - Length(ExtractFileExt(S)));
  end;

  function Content(S: WideString): WideString;
  begin
    if S <> '' then Result := Trim(S) else Result := '&nbsp;';
  end;
begin
  Html := TNxStringList.Create;

  { Save Headers: HTML, HEAD, BODY }
  if hsSaveHeaders in SaveSettings then
  begin
    Html.Add('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"' + #13#10#9 + '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
    Html.Add('<html>');
    Html.Add(#9'<head>');
    Html.Add(#9#9'<title>Report</title>');
    Html.Add(#9#9'<meta http-equiv="Content-Type" content="text/html; charset=utf-8">');
    if hsCreateStyleSheet in SaveSettings then
    begin
      Html.Add(#9#9'<link href="' + ExtractName(FileName) + '_styles.css" rel="stylesheet" type="text/css" />');
    end;
    Html.Add(#9'</head>');
    Html.Add(#9'<body>');
  end;

  Html.Add(#9#9'<table>');

  { Save Caption }
  if hsSaveCaption in SaveSettings then
    Html.Add(#9#9#9'<caption>' + Caption + '</caption>');

  { Render Headers }
  Html.Add(#9#9#9'<tr>');
  for i := 0 to Columns.Count - 1 do
  	if Columns.PositionItem[i].Visible then
	  begin
		  Html.Add(#9#9#9#9'<th>' + Content(Columns.PositionItem[i].Header.Caption) + '</th>');
	  end;
  Html.Add(#9#9#9'</tr>');

  { Render Data }
  for j := 0 to RowCount - 1 do
    if GetRowVisible(j) or (hsAllRows in SaveSettings) then
    begin
      SetActiveRow(j); { move record in NextDBGrid }
      Html.Add(#9#9#9'<tr>');
      for i := 0 to Pred(Columns.Count) do
        if Columns.PositionItem[i].Visible then
        begin
          S := Columns.PositionItem[i].GetDrawText(GetCellInfo(i, j));
          S := Content(S);

          if Columns.PositionItem[i].StyleClass <> '' then
            Html.Add(#9#9#9#9'<td class="' + Columns.PositionItem[i].StyleClass + '">' + S + '</td>')
          else
            Html.Add(#9#9#9#9'<td>' + S + '</td>')
        end; { Visible }
      Html.Add(#9#9#9'</tr>');
    end; { Row Visible }

  { SaveFooter }
  if hsSaveFooter in SaveSettings then
  begin
    Html.Add(#9#9#9'<tr class="footer">');
    for i := 0 to Columns.VisibleCount - 1 do
      with Columns.PositionItem[i] do
        if Visible then
        begin
          if Footer.FormatMask <> '' then
          begin
            case Footer.FormatMaskKind of
              mkText: S := FormatMaskText(Footer.FormatMask, Footer.Caption);
              mkFloat: S := FormatFloat(Footer.FormatMask, StrToFloatDef(Footer.Caption, 0));
            end;
          end else S := Footer.Caption;
          S := Concat(Footer.TextBefore, S, Footer.TextAfter);
          Html.Add(#9#9#9#9'<td>' + Content(S) + '</td>');
        end;
    Html.Add(#9#9#9'</tr>');
  end;
  Html.Add(#9#9'</table>');

  if hsSaveHeaders in SaveSettings then
  begin
    Html.Add(#9'</body>');
    Html.Add('<html>');
  end;

  { Finish writing .htm file }
  try
    AssignFile(HtmlFile, FileName);
    Rewrite(HtmlFile);
    Writeln(HtmlFile, Html.text);
  finally
    CloseFile(HtmlFile);
    FreeAndNil(Html);
  end;

  if hsCreateStyleSheet in SaveSettings then
  begin
    Css := TNxStringList.Create;

    Css.Add('body, table {');
    Css.Add(#9'font-family: Verdana, Arial, Helvetica, sans-serif;');
    Css.Add(#9'font-size: small;');
    Css.Add('}');

    Css.Add('');

    Css.Add('table {');
    Css.Add(#9'border: 1px #CCC;');
    Css.Add(#9'border-collapse: collapse;');
    Css.Add('}');

    Css.Add('');

    Css.Add('table caption {');
    Css.Add(#9'color: #999;');
    Css.Add(#9'font-style: italic;');
    Css.Add('}');

    Css.Add('');

    Css.Add('td, th {');
    Css.Add(#9'padding: 2px;');
    Css.Add(#9'border: 1px solid #CCC;');
    Css.Add('}');

    Css.Add('');

    Css.Add('th {');
    Css.Add(#9'background-color: #CCC;');
    Css.Add(#9'border-bottom: 1px solid black;');
    Css.Add(#9'border-right: 1px solid black;');
    Css.Add('}');

    Css.Add('');

    Css.Add('tr.footer { border-top: 2px solid black; }');

    Css.Add('');

    { Add custom classes }
    for i := 0 to Columns.VisibleCount - 1 do
      with Columns.PositionItem[i] do
        if Visible and (StyleClass <> '') then
          Css.Add('td.' + StyleClass + ' { }');


    { Finish writing .css file }
    try
      CssFileName := ExtractFilePath(FileName) + ExtractName(FileName) + '_styles.css';
      AssignFile(CssFile, CssFileName);
      Rewrite(CssFile);
      Writeln(CssFile, Css.Text);
    finally
      CloseFile(CssFile);
      FreeAndNil(Css);
    end;
  end;
end;

procedure TNxCustomGridControl.SaveToStream(Stream: TStream; Separator: Char = ';');
var
  S: string;
begin
  S := GetTextStr(Separator);
  Stream.WriteBuffer(Pointer(S)^, Length(S));
end;

procedure TNxCustomGridControl.SaveToTextFile(const FileName: WideString;
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
      for j := 0 to Columns.Count - 1 do
      begin
        q := GetValid(Cells[j, i]);
        for z := 1 to Length(q) do Write(f, q[z]);
        if not(j = Columns.Count - 1) then Write(f, Separator);
        { add new row }
        if j = Columns.Count - 1 then
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
      for j := 0 to Columns.Count - 1 do
      begin
        Write(f, GetValid(Cells[j, i]));
        if (j <> Columns.Count - 1) then Write(f, Separator)
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

{*<summary>Dump grid contents onto disk in XML format</summary>
  <calledby>application interface (public method)</calledby>
  <param name='Filename'>Path and name of file to be created. If the file
   already exists, it is overwritten.</param>
  <param name='UniEncoding'>Enumerated type defining character encoding. The
   default is UTF-8. In UTF-8, every code point from 0-127 is stored in a
   single byte. Only code points 128 and above are stored using 2, 3, in fact,
   up to 6 bytes. For discussion of the pros and cons of utf-8 see:
   http://www.micro-isv.asia/2009/03/why-not-use-utf-8-for-everything/</param>
  <param name='ApplyUft8BOM'>Boolean, defaulted to False. It is usual practice
   not to provide a BOM for uft-8 encoding, see:
   http://en.wikipedia.org/wiki/Byte-order_mark for further information.</param>
  <returns></returns>
  <lastchange>v4.5.9.1</lastchange>
 *}
procedure TNxCustomGridControl.SaveToXMLFile(const FileName: WideString;
 UniEncoding: TUniEncoding = enUTF_8);
{*
 * This method is split into two parts - (1) the collation of the XML formatted
 * data using a TMemoryStream, and then (2) the conversion into the Unicode
 * encoding required before writing to disk.
 *}
var
   m: TMemoryStream;
   ColNames : TStrings;

{----Write widestring to MemoryStream----}
   procedure MemWrite(Indent: Integer; S: WideString);
   begin
      if S <> '' then
      begin
         if Indent = 1 then S := '  '+S;
         S := S + #13#10;
         m.Write(S[1], length(S)*SizeOf(WideChar));
      end;
   end;

{----Read MemoryStream as widestring----}
   function MemRead: WideString;
   const
      NullTerminator: WideChar = #0;
   begin
      m.Write( NullTerminator, SizeOf(WideChar));
      Result := PWideChar(m.Memory);
   end;

{----format a datetime stamp to the XML standard----}
   function XMLDateTime(dt: TDateTime): Widestring;
   var
      p: Integer;
   begin
      // if a time column then date part is a 0, 1, or a 2
      if dt <= 3 then Result := FormatDateTime('hh:nn:ss', dt)
      else begin
         Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', dt);
         p := Pos(' ', Result);
         if p > 0 then Result[p] := 'T';
      end;
   end;


{-------------------------------------------}
   procedure WriteXMLHeader;
   begin
      case UniEncoding of
           enUnspecified: MemWrite(0, '<?xml version="1.0" ?>');
           enISO_8859_1 : MemWrite(0, '<?xml version="1.0" encoding="iso-8859-1" ?>');
           enUTF_16     : MemWrite(0, '<?xml version="1.0" encoding="utf-16" ?>');
           enUTF_8      : MemWrite(0, '<?xml version="1.0" encoding="utf-8" ?>');
      end;
      //we are going to use 'NxGrid' as the document root element and ..
      // ..the name of the grid as the namespace. Any better ideas?
      MemWrite(0, '<NxGrid xmlns="urn:'+GetNamePath+'" '+
                      'createdDate="'+XMLDateTime(Now)+'" '+
                      'totalRows="'+IntToStr(RowCount)+'">');
   end;


{----Ensure elements are XML valid strings----}
   function Legalize( OriginalStr, DefaultName: String): Widestring;
   {* XML names cannot start with 'xml', and the initial character can only be an
    * Unicode letter or an underscore (_) or colon(:). The remaining chars can only
    * be an Unicode letter or number, or an underscore (_), a colon(:), a hypen (-)
    * or a fullstop (.).
    *}
   {TODO : existing code restricts character to ANSI letters, instead of Unicode letters.} 
   const
      Initials: set of Char = ['a'..'z', 'A'..'Z', '_',':'];
      Remains : set of Char = ['0'..'9', 'a'..'z', 'A'..'Z', '_',':','-','.'];
   var
      startpos, i: integer;
      firsttime: Boolean;
   begin
      Result := '';
      firsttime := True;
      if UpperCase( Copy(OriginalStr,1,3) ) = 'XML'
         then startpos := 4 else startpos := 1;
      for i := startpos to length(OriginalStr) do
      begin
         if firsttime then
         begin
            if OriginalStr[i] in Initials then
            begin
               Result := OriginalStr[i];
               firsttime := False;
            end //otherwise skip this character and keep firsttime true.
         end else
         begin
            if OriginalStr[i] in Remains  then Result := Result + OriginalStr[i];
         end;
      end;
      if Result = '' then Result := DefaultName;
   end;


{-------------------------------------------}
   procedure BuildColumnNames;
   var i: integer;
   begin
      for i := 0 to Columns.Count -1 do
      begin
         ColNames.Add( Legalize(Columns[i].Header.Caption, 'Column'+IntToStr(i)) );
      end;
   end;


{-------------------------------------------}
   function EntityTranslate(OriginalStr: String): Widestring;
   {* An entity reference is a legal XML string, preceded by an ampersamd (&) and
    * followed by a semi-colon (;) character. The following 5 entity refs are built
    * into XML and are used as escape sequences for the XML markup delimiters.
    *}
   const
      Delims:   array[0..4] of Char   = ( '&', '<', '>', '"', '''');
      Entities: array[0..4] of String = ( '&amp;','&lt;','&gt;','&quot;','&apos;' );
   var
      i,j: integer;
   begin
      Result := '';
      for i := 1 to length(OriginalStr) do
      begin
         for j := 0 to High(Delims) do
         begin
            if OriginalStr[i] = Delims[j] then //we have a reserved character
            begin
               Result := Result + Entities[j];
               Break
            end;
            if j = High(Delims) then // [i] is not a reserved character
               Result := Result + OriginalStr[i];
         end;
      end;
   end;


{-------------------------------------------}
   procedure WriteXMLBody;
   var j,k: Integer;
       S: Widestring;
   begin
      for j := 0 to RowCount - 1 do
      begin
         MemWrite(0, '<Row>');
         for k := 0 to Columns.Count - 1 do
         begin
            S := '<'+ColNames[k]+'>';
            case Columns[k].ColumnType of
               ctDate: S := S + XMLDateTime(GetCellInfo(k, j).AsDateTime);
               else    S := S + EntityTranslate(Cells[k, j])
            end;
            S := S + '</'+ColNames[k]+'>';
            MemWrite(1, S );
         end;
         MemWrite(0, '</Row>');
      end;
   end;

{-------------------------------------------}
   procedure WriteXMLEpilog;
   begin
      MemWrite(0, '</NxGrid>');
   end;

{=========main body of SaveToXMLFile========}
const
   UTF16_BE_ByteOrderMark: WideChar = #$fffe;
   UTF16_LE_ByteOrderMark: WideChar = #$feff;
   UTF8_ByteOrderMark = AnsiString(#$EF#$BB#$BF);
var
   f: TFileStream;
   xml_16: Widestring;
   xml_8 : UTF8String;
   xml_S : AnsiString;
begin
   if RowCount = 0 then
   begin
      MessageBox(0, 'Nothing to save', 'Save to XML', MB_ICONWARNING or MB_OK);
      exit
   end;
   m := TMemoryStream.Create;
   ColNames := TStringList.Create;
   try
      WriteXMLHeader;
      BuildColumnNames;
      WriteXMLBody;
      WriteXMLEpilog;
      //ready to write to disk
      f := TFileStream.Create( FileName, fmCreate );   //or fmShareExclusive
      try
         case UniEncoding of
         enUTF_16: begin
                   xml_16 := MemRead;
                   f.Write(UTF16_LE_ByteOrderMark, 2);
                   f.Write(xml_16[1], length(xml_16)*SizeOf(WideChar));
                   end;
         enISO_8859_1: begin
                   xml_S := MemRead;
                   f.Write(xml_S[1], length(xml_S));
                   end;
         else      begin    //for enUnspecified and enUTF_8 options
                   xml_8 := UTF8Encode(MemRead);
                   //if ApplyUft8BOM then f.Write(UTF8_ByteOrderMark, SizeOf(UTF8_ByteOrderMark));
                   f.Write(xml_8[1], length(xml_8));   //this won't work in D2009
                   end;
         end;
      finally
         f.Free;
      end;
   finally
      m.Free;
      ColNames.Free;
   end;
end;

procedure TNxCustomGridControl.ScrollToColumn(AColumn: TNxCustomColumn);
var
  ColumnLeft, Delta: Integer;
begin
  if AColumn.Position >= FFixedCols then { Skip FixedCols }
  begin
    ColumnLeft := AColumn.Left - HorzScrollBar.Position;
    if ColumnLeft < GetScrollRect.Left then
    begin
      Delta := ColumnLeft - GetScrollRect.Left;
      HorzScrollBar.MoveBy(Delta);
      RefreshCellEditor;
    end
    else if ColumnLeft + AColumn.Width > GetScrollRect.Right then
    begin
      Delta := (ColumnLeft + AColumn.Width) - GetScrollRect.Right;
      HorzScrollBar.MoveBy(Delta);
      RefreshCellEditor;
    end;
  end;
end;

function TNxCustomGridControl.GetLastRow: Integer;
var
  i, Pos: Integer;
begin
  Pos := GetBodyRect.Top;
  Result := FFirstRow;
  for i := FFirstRow to RowCount - 1 do
  begin
    if GetRowVisible(i) then
    begin
      Inc(Pos, GetActualRowHeight(i));
      Inc(Pos, GetGridSpace(lpTopBottom));
      if Pos > GetBodyRect.Bottom then Break;
      Result := i;
    end;
  end;
end;

procedure TNxCustomGridControl.ScrollToRow(Index: Integer);
var
  Delta, LastRow, n, i: Integer;
begin
  Delta := 0;
  if (Index >= 0) and (Index < RowCount) then
  begin
    LastRow := GetLastRow;
    if Index > LastRow then
    begin

      case GridStyle of
        gsReport: n := GetRowTop(Index) + RowHeight[Index];
        else n := GetSlideTop(Index) + SlideSize;
      end;

      for i := Index downto FFirstRow do
      begin
        if RowVisible[i] then
        begin
          Dec(n, GetActualRowHeight(i) + FGridSpace[lpTopBottom]);
          Inc(Delta);
          if n <= GetBodyRect.Bottom then Break;
        end;
      end;
      VertScrollBar.MoveBy(Delta);

      CellsScrolled(Delta);
    end else if Index < FFirstRow then
    begin
      Delta := GetRowsInRange(Index, FFirstRow);
      VertScrollBar.Position := VertScrollBar.Position - Delta;
    end else Exit;
  end;
end;

procedure TNxCustomGridControl.SelectAll;
var
	I: Integer;
begin
  if (goMultiSelect in Options) and (goSelectFullRow in Options) then
  begin
    BeginUpdate;
  	for i := 0 to RowCount - 1 do Selected[i] := True;
    Include(FGridState, gtMultiSelect);
    EndUpdate;
  end;
end;

procedure TNxCustomGridControl.SelectCell;
var
  OldCol, OldRow, i: Integer;
  CanSelect: Boolean;
begin
  CanSelect := CanSelectCell(ACol, ARow);
  DoBeforeSelect(ACol, ARow, CanSelect); { Event }
  if not CanSelect then Exit;
  if gtMultiSelect in GridState then
  begin
  	if not((ssShift in Shift) or (ssCtrl in Shift))
      and Deselect then NoSelection; { stop with multi select }
  end;
  if Columns.Exists(ACol) and Columns[ACol].Enabled = False then Exit;
  OldCol := FSelectedColumn;
  OldRow := FSelectedRow;
  FSelectedColumn := ACol;
  FSelectedRow := ARow;
  if (OldCol <> ACol) or (OldRow <> ARow) then
  begin
    if CellBounds(OldCol, OldRow) then
      DoDeselectCell(OldCol, OldRow); { event }
    if gtEdit in GridState then EndEditing;
  end;
                     
  if AutoScroll and InRange(ARow, 0, RowCount - 1)
    then ScrollToRow(ARow);

  if InputSelected then { input line }
  begin
    if (ACol <> OldCol) then
    begin
      DoInputSelectCell(ACol);
      RefreshColumn(Columns[ACol], gaInput);
      if InRange(OldCol, 0, Pred(Columns.Count))
        then RefreshColumn(Columns[OldCol], gaInput);
    end;
    Exit;
  end;

  if GetRowCount = 0 then Exit;

  if goSelectFullRow in Options then
  begin
    if goMultiSelect in Options then
    begin
      { 8/15/07:  Ctrl + Shift extends current selection }
      if (ssCtrl in Shift) and not (ssShift in Shift) then
      begin
        FFromSelected := ARow;
        FGridState := FGridState + [gtMultiSelect];
        Selected[ARow] := not Selected[ARow]; { first set selected then DoSelectEvent! }
        if OldRow <> ARow then
        begin
          if FGridStyle = gsSlides then RefreshSlide(OldRow, True);
          RefreshRow(OldRow);
        end;
        DoSelectCell(ACol, ARow);
        Exit;
      end;
      if ssShift in Shift then
      begin
        FGridState := FGridState + [gtMultiSelect];
        if FFromSelected < ARow then { up -> down }
        begin
          if not (ssCtrl in Shift) then { don't clear if Ctrl is pressed }
          begin
            for i := 0 to FFromSelected - 1 do Selected[i] := False;
            for i := ARow + 1 to RowCount - 1 do Selected[i] := False;
          end;
          SelectRange(FFromSelected, ARow, True);
        end else {if ARow < FFromSelected then}
        begin
          if not (ssCtrl in Shift) then { don't clear if Ctrl is pressed }
          begin
            for i := 0 to ARow - 1 do Selected[i] := False;
            for i := FFromSelected + 1 to RowCount - 1 do Selected[i] := False;
          end;
          SelectRange(ARow, FFromSelected, True);
        end;
        if OldRow <> ARow then
        begin
          RefreshRow(ARow);
          RefreshRow(OldRow);
          if FGridStyle = gsSlides then RefreshSlide(ARow);
          if FGridStyle = gsSlides then RefreshSlide(OldRow);
        end;
        DoSelectCell(ACol, ARow);
        Exit;
      end;
    end; { multi select }

    if OldRow <> ARow then
    begin
      if not(gtMultiSelect in GridState) then Selected[OldRow] := False
    end else
    begin
      if (aoIndicateSelectedCell in AppearanceOptions) and (OldCol <> ACol) then
      begin
        RefreshCell(ACol, ARow);
        if InRange(OldCol, 0, Pred(Columns.Count))
          then RefreshCell(OldCol, OldRow);
      end;
    end;
    Selected[ARow] := True;
    FFromSelected := ARow;

    if UpdateCount = 0 then
      case GridStyle of
        gsReport:
        begin
          RefreshRow(ARow);
          RefreshRow(OldRow);
        end;
        gsSlides:
        begin
          RefreshSlide(ARow, False);
          RefreshSlide(OldRow, False);
        end;
      end;
    DoSelectCell(ACol, ARow);
  end else
  begin { single cell select }
    if (OldCol <> ACol) or (OldRow <> ARow) then
    begin
      if OldRow <> ARow then
      begin
        case GridStyle of
          gsReport:
          begin
            RefreshIndicator(ARow);
            RefreshIndicator(OldRow);
          end;
          gsSlides:
          begin
            RefreshSlide(ARow, True);
            RefreshSlide(OldRow, True);
          end;
        end;
      end;
      RefreshCell(ACol, ARow);
      RefreshCell(OldCol, OldRow);
    end;
    DoSelectCell(ACol, ARow);
  end;

  if AutoEdit then EditCell(ACol, ARow);
end;

procedure TNxCustomGridControl.SelectFirstRow;
begin
  InputSelected := False;
  SelectCell(SelectedColumn, FirstVisibleRow, Shift);
  VertScrollBar.First;
end;

procedure TNxCustomGridControl.SelectLastRow;
begin
  InputSelected := False;
  SelectCell(SelectedColumn, LastVisibleRow, Shift);
  VertScrollBar.Last;
end;

procedure TNxCustomGridControl.NoSelection;
begin
  BeginUpdate;
  ClearSelection;
  EndUpdate;
  Exclude(FGridState, gtMultiSelect);
  FSelectedRow := -1;
  FSelectedColumn := 0;
end;

procedure TNxCustomGridControl.PaintReport;
begin
  PaintReportRows;
  PaintReportParts;
end;

procedure TNxCustomGridControl.PaintSlides;
begin
  PaintSlidesParts;
  PaintSlidesRows;
end;

procedure TNxCustomGridControl.PaintSlidesParts;
begin
  if goHeader in FOptions then
  begin
    DrawHeaders;
    if goIndicator in Options then FCurrentStyleDisplay.DrawCornerBox(Rect(0, 0, sizIndicator, HeaderSize));
  end;
end;

procedure TNxCustomGridControl.PaintSlidesRows;
var
  Done: Boolean;
  Col, Y: Integer;
  CellPos: TPoint;
  SlideRect, CellRect: TRect;
  GridColor, SlideColor: TColor;
  SlideState: TSlideState;
begin
  Done := False;
  FLastRow := FFirstRow;
  with Canvas do
  begin
    Y := GetBodyRect.Top;
    while not Done and (FLastRow < GetRowCount) do
    begin
      if GetRowVisible(FLastRow) then
      begin
        Inc(Y, GridSpace[lpTop]);

        SlideRect := Rect(0, Y, ClientWidth, Y + SlideSize);

        SlideRect.Bottom := SlideRect.Bottom + GridSpace[lpBottom];

        Pen.Color := Color;

        if ao3DGridLines in FAppearanceOptions then
          Polyline([Point(0, Y - 1), Point(ClientWidth, Y - 1)]);

        SetClipCellRect(SlideRect);

        if Selected[FLastRow] then
        begin
          if soHideSelection in FSlideOptions then SlideColor := Self.Color else
          begin
            if Focused then SlideColor := FSlideSelectionColor else SlideColor := clBtnFace;
          end;
        end else SlideColor := Self.Color;

        { Set slide state }
        SlideState := [];
        if SelectedRow = FLastRow then
        begin
          Include(SlideState, stSelected);
          if soFrame in FSlideOptions then Include(SlideState, stFocused);
        end;

        GridColor := FGridLinesColor;

        DoSlideColoring(FLastRow, SlideColor, GridColor, SlideState); { event }

        Brush.Color := SlideColor;
        FillRect(SlideRect);
        
        for Col := 0 to Columns.Count - 1 do
          if Columns[col].Visible then
        begin
          if not(IntegralHeight and (Y + SlideSize + GridSpace[lpBottom] > GetBodyRect.Bottom)) then
          begin

            with Columns[col] do
            begin
              CellPos := Point(SlideBounds.Left, SlideBounds.Top + Y);

              CellRect := Bounds(CellPos.X, CellPos.Y, SlideBounds.Width, SlideBounds.Height);
            end;

            DrawCell(col, FLastRow, CellRect);

            DrawSlideCaption(col, FLastRow);

          end else Done := True;
        end;
        { Drawing Frame }
        if stFocused in SlideState then
        begin
          if Focused then Brush.Color := FSelectionColor
            else Brush.Color := FInactiveSelectionColor;
          FrameRect(TCalcProvider.ResizeRect(SlideRect, 1, 1, -1, -2));
          FrameRect(TCalcProvider.ResizeRect(SlideRect, 2, 2, -2, -3));
        end;
        Inc(Y, SlideSize + GridSpace[lpBottom]);
        Pen.Color := GridColor;
        if goGrid in Options then Polyline([Point(0, Y - 1), Point(ClientWidth, Y - 1)]);
        SetClipCellRect(Self.ClientRect);
        if Y > ClientHeight then Done := True;
      end;                       
      Inc(FLastRow);
      if FLastRow >= RowCount then Done := True;
    end;
    if Y < ClientHeight then
    begin
      Brush.Color := Color;
      FillRect(Rect(0, Y, ClientWidth, ClientHeight));
    end;
  end;
end;

procedure TNxCustomGridControl.PrepareEdit;
begin
  { note: Run before editing started. Descendants may override this method. }
end;

procedure TNxCustomGridControl.RecreateStyleDisplay;
begin
  case FHeaderStyle of
    hsAuto: FCurrentStyleDisplay := FDefaultStyleDisplay;
    hsFlatBorders: FCurrentStyleDisplay := FFlatStyleDisplay;
    hsOffice2007: FCurrentStyleDisplay := FOffice2007StyleDisplay;
    hsOffice2010: FCurrentStyleDisplay := FOffice2010StyleDisplay;
    hsOldStyle: FCurrentStyleDisplay := FOldStyleDisplay;
    hsOutlook: FCurrentStyleDisplay := FOutlookStyleDisplay;
    hsVista: FCurrentStyleDisplay := FVistaStyleDisplay;
  end;
  FCurrentStyleDisplay.Canvas := Canvas;
  Invalidate;
  RedrawBorder;
end;

procedure TNxCustomGridControl.RedrawBorder;
const
  DataName: PWideChar = 'listview';
var
  Theme: THandle;
  DC: HDC;
  R, R1: TRect;
  M: Integer;
  BR: HBRUSH;
begin
  if ((FHeaderStyle = hsOffice2007) or (FHeaderStyle = hsOffice2010))
    and (BorderStyle <> bsNone) then
  begin
	  DC := GetWindowDC(Handle);
    GetWindowRect(Handle, R);
	  OffsetRect(R, -R.Left, -R.Top);
    BR := CreateSolidBrush(ColorToRGB(SchemeColor(seBorder, ColorScheme)));
    FrameRect(DC, R, BR);
	  ReleaseDC(Handle, DC);
    DeleteObject(BR);
    Exit;
  end;
  if IsThemed and EnableVisualStyles
    and (BorderStyle <> bsNone) then
	begin
    BorderWidth := 0;
	  DC := GetWindowDC(Handle);
    GetWindowRect(Handle, R);
	  OffsetRect(R, -R.Left, -R.Top);
	  Theme := OpenThemeData(Handle, DataName);
    R1 := R;
    M := -BorderWidth -1;
	  InflateRect(R1, M, M);
	  ExcludeClipRect(DC, R1.Left, R1.Top, R1.Right, R1.Bottom);
    
	  DrawThemeBackground(Theme, DC, 1, 0, R, @R);
	  ReleaseDC(Handle, DC);
    CloseThemeData(Theme);
	end else BorderWidth := 0;
end;

procedure TNxCustomGridControl.RefreshRect(ARect: TRect);
begin
  InvalidateRect(Handle, @ARect, False);
end;

procedure TNxCustomGridControl.RefreshSelectedCells;
var
	i: Integer;
begin
	if InputSelected then RefreshArea(gaInput);
	if (Columns.Count > 0) and (RowCount > 0) then
    case goSelectFullRow in Options of
      True: for i := FFirstRow to RowCount - 1 do
            begin
              if Selected[i] then RefreshRow(i);
              if i > FFirstRow + GetVisibleCount then Break;
            end;
      False: RefreshCell(SelectedColumn, SelectedRow);
    end;
end;

procedure TNxCustomGridControl.RefreshSelectedSlides;
var
  i, VisibleCount: Integer;
begin
  VisibleCount := GetVisibleCount;
  for i := FFirstRow to Pred(RowCount) do
  begin
    if Selected[i] then RefreshSlide(i);
    if i > FFirstRow + VisibleCount then Break;
  end;
end;

procedure TNxCustomGridControl.RefreshVisibleRows(FromPos, ToPos: Integer);
var
  I, Bottom: Integer;
  RowRect: TRect;
begin
  case GridStyle of
    gsReport: RowRect := GetRowRect(FromPos);
    gsSlides: RowRect := GetSlideRect(FromPos)
  end;
  Bottom := GetBodyRect.Bottom;
  for I := FromPos to ToPos - 1 do
  begin
    if RowRect.Bottom < Bottom
      then RowRect.Bottom := RowRect.Bottom + GetActualRowHeight(i) + GridSpace[lpBottom]
        else Break;
  end;
  InvalidateRect(Handle, @RowRect, False);
end;

procedure TNxCustomGridControl.ScrollRows(FromRow, ToRow: Integer);
var
  i, Delta: Integer;
  RepaintRect: TRect;
begin
  Delta := 0;
  if FromRow > ToRow then for i := ToRow to FromRow - 1 do Inc(Delta, GetRowHeight(i) + GridSpace[lpBottom]);
  if FromRow < ToRow then for i := FromRow to ToRow - 1 do Dec(Delta, GetRowHeight(i) + GridSpace[lpBottom]);
  RepaintRect := GetBodyRect;
  RepaintRect.Left := 0;
  ScrollWindowEx(Handle, 0, Delta, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
end;

procedure TNxCustomGridControl.SetActiveRow(const Index: Integer);
begin

end;

procedure TNxCustomGridControl.SetChildOrder(Child: TComponent;
  Order: Integer);
begin

end;

procedure TNxCustomGridControl.DrawEmptyCell(ACol, ARow: Integer; CellRect: TRect);
var
  DrawRect, ClpRect: TRect;
  CellColor, GridColor: TColor;
  CellState: TCellState;
  DefaultDraw: Boolean;
begin
  CellColor := Color;
  if (aoIndicateSortedColumn in AppearanceOptions) and (Columns[ACol].Sorted)
   	then CellColor := TGraphicsProvider.BlendColor(clBlack, CellColor, 10);

  if (GridLinesStyle = lsActiveRows) or (GridLinesStyle = lsActiveHorzOnly)
    then GridColor := CellColor else GridColor := FGridLinesColor;

  CellState := [csEmpty];

  DrawRect := CellRect;
  ClpRect := DrawRect;
  if Columns[ACol].Position >= FFixedCols then
  begin
    if ClpRect.Left < GetScrollRect.Left then ClpRect.Left := GetScrollRect.Left;
  end;
  SetClipCellRect(ClpRect);

  DoCellColoring(ACol, ARow, CellColor, GridColor, CellState); { event }
  if goGrid in Options then DrawGrid(ACol, ARow, DrawRect, GridColor);

  ExcludeGrid(DrawRect);

  with Canvas do
  begin
    DefaultDraw := True;
    DoDrawCellBackground(ACol, ARow, DrawRect, CellState, DefaultDraw);
    Canvas.Brush.Color := CellColor;
    if DefaultDraw then FillRect(DrawRect);
  end;
  SetClipRect(Canvas, ClientRect);
end;

procedure TNxCustomGridControl.DrawFocusCell;
var
	CellRect, ClipRect: TRect;

  function GetFullRowRect(Index: Integer): TRect;
  begin
    with Result do
    begin
      Left := GetBodyRect.Left - HorzScrollBar.Position;
      Top := GetRowTop(Index);
      Right := Left + Columns.ClientWidth;
      Bottom := Top + GetRowHeight(Index);
    end;
  end;
begin
	if (SelectedColumn < 0) or (SelectedRow < 0)
	  or (SelectedColumn >= Columns.Count)
      or (SelectedRow >= RowCount)
        or (SelectedRow < FFirstRow) then Exit;

  if goSelectFullRow in Options then
  begin
    CellRect := GetFullRowRect(SelectedRow);
    Dec(CellRect.Left, HorzScrollBar.Position);
    with CellRect do
    begin
      Dec(Left, GridSpace[lpLeft]);
      Dec(Right, GridSpace[lpRight]);
    end;
    ClipRect := CellRect;
    ClipRect.Left := GetBodyRect.Left;
  end else { single cell }
  begin
    CellRect := GetCellRect(SelectedColumn, SelectedRow);
    ClipRect := CellRect;
    Inc(CellRect.Left, GridSpace[lpLeft]);
    Dec(CellRect.Right, GridSpace[lpRight]);
    if Columns[SelectedColumn].Position >= FFixedCols then
      if ClipRect.Left < GetScrollRect.Left then ClipRect.Left := GetScrollRect.Left;
    ExcludeGrid(ClipRect);
    SetClipCellRect(ClipRect);
  end;
  if (not InputSelected) and (RowCount > 0) and (Focused) and (TCalcProvider.IsRectInRect(CellRect, GetBodyRect))
	  and (not InputSelected) and (not (aoHideFocus in AppearanceOptions)) then
  begin
    SetClipRect(Canvas, ClipRect);
    TGraphicsProvider.DrawFocused(Canvas, CellRect, aoAlphaBlendedSelection in AppearanceOptions);
    SetClipRect(Canvas, ClientRect);
  end;
end;

procedure TNxCustomGridControl.DrawRowIndicator(Index: Integer; Selected, Highlighted: Boolean);
var
  IndicatorRect: TRect;
  Y, IndicatorTop, IndicatorHeight: Integer;
begin
  IndicatorTop := GetRowTop(Index);
  Y := IndicatorTop - GridSpace[lpTop];
  if Index < RowCount then IndicatorHeight := GetRowHeight(Index)
    else IndicatorHeight := RowSize;

  IndicatorRect := Rect(0, Y, sizIndicator, IndicatorTop + IndicatorHeight + GridSpace[lpBottom]);

  with FCurrentStyleDisplay do
  begin
    if IndicatorDrawingOptions in [doNormal, doBackgroundOnly] then
    begin
      DrawIndicator(IndicatorRect, Index, Selected, Highlighted);
    end;

    if IndicatorDrawingOptions in [doNormal, doCustom] then
    begin
      DrawIndicatorState(IndicatorRect, Selected, Highlighted);
    end;

    if IndicatorDrawingOptions <> doNormal then
    begin
      DoCustomDrawIndicator(Index, IndicatorRect, Selected, Highlighted); { Trigger Event }
    end;
  end;
end;

procedure TNxCustomGridControl.DrawSlideCaption(ACol, ARow: Integer);
var
  SlideRect: TRect;
  TextHeight, TextWidth: Integer;
begin
  with SlideRect do
  begin
    TextHeight := Canvas.TextHeight(Columns[ACol].SlideCaption);
    TextWidth := Canvas.TextWidth(Columns[ACol].SlideCaption);
    case Columns[ACol].SlideCaptionLocation of
      clTop:
      begin
        Left := Columns[ACol].SlideBounds.Left + spCellTextMargin;
        Right := Left + TextWidth;
        Top := GetCellTop(ACol, ARow) - (TextHeight + spCellTextMargin);
        Bottom := Top + TextHeight;
      end;
      clLeft:
      begin
        Left := Columns[ACol].SlideBounds.Left - (TextWidth + spCellTextMargin);
        Right := Left + TextWidth;
        Top := GetCellTop(ACol, ARow);
        Bottom := Top + Columns[ACol].SlideBounds.Height;
      end;
    end;
  end;
  with Canvas do
  begin
    Font.Style := [];
    Font.Color := FSlideCaptionColor;
    DrawTextRect(Canvas, SlideRect, taLeftJustify, Columns[ACol].SlideCaption);
  end;
end;

procedure TNxCustomGridControl.ExpandColumn(Column: TNxCustomColumn;
  Delta: Integer; HeadersOnly: Boolean = False);
var
  RepaintRect: TRect;
begin
  RefreshColumn(Column);
  with RepaintRect do
  begin
    Left := (Column.Left + Column.Width) - HorzScrollBar.Position;
    Top := 0;
    Right := ClientWidth;
    if HeadersOnly then Bottom := FHeaderSize else Bottom := ClientHeight;
  end;
  ScrollWindowEx(Handle, Delta, 0, nil, @RepaintRect, 0, @RepaintRect, SW_INVALIDATE);
end;

function TNxCustomGridControl.GetFirstVisible(
  const FromRow: Integer): Integer;
var
  i: Integer;
begin
  for i := FromRow to Pred(RowCount) do
  begin
    if GetRowVisible(i) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := FromRow;
end;

function TNxCustomGridControl.GetLastVisible(
  const FromRow: Integer): Integer;
var
  i: Integer;
begin
  for i := FromRow downto 0 do
  begin
    if GetRowVisible(i) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := FromRow;
end;

function TNxCustomGridControl.IsCalculateRow(const Index: Integer): Boolean;
begin
  { True by Default }
  Result := True;
  DoCalculateRow(Index, Result); { Trigger Event }
end;

function TNxCustomGridControl.IsCellEmpty(ACol, ARow: Integer): Boolean;
var
  Showing: Boolean;
begin
  Showing := True;
  DoCellShowing(ACol, ARow, Showing);
  Result := not Showing;
end;

procedure TNxCustomGridControl.GridStyleChanged;
begin

end;

procedure TNxCustomGridControl.PaintReportParts;
var
  I, Indent: Integer;
  Column: TNxCustomColumn;
  Clipped: Boolean;
begin
  I := 0;
  while I < Columns.Count do
  begin
    Column := Columns.PositionItem[I];
    if Column.Visible then
    begin
      if I >= FixedCols then Indent := HorzScrollBar.Position else Indent := 0;
      if Column.Left - Indent > ClientWidth then Break;
      Clipped := (I >= FFixedCols) and (Column.Left + Column.Width - Indent < GetFixedWidth);
      if (Column.Left >= 0) and (Clipped = False) then
      begin
        if I >= FixedCols then SetClipRect(Canvas, GetScrollRect);
        with FCurrentStyleDisplay do
        begin
          UseThemes := EnableVisualStyles and IsThemed;
          Canvas := Self.Canvas;

          { Font }
          if Column.Header.ParentFont
          then
            Canvas.Font.Assign(Self.Font)
          else
            Canvas.Font.Assign(Column.Header.Font);

          if goHeader in Options then
          begin
            OnHeaderDraw := DoHeaderDraw;
            DrawHeader(Column, Column.GetMemberRect(ckHeader));
          end;
          if goInput in Options then DrawInput(Column, Column.GetMemberRect(ckInput), goGrid in Options, InputSelected, Focused);
          if goFooter in Options then
          begin
            OnDraw := DoFooterDraw;
            DrawFooter(Column, Column.GetMemberRect(ckFooter), goGrid in Options);
          end;
        end;
        SetClipRect(Canvas, Self.ClientRect);
      end;
    end; { if visible }
    Inc(I);
  end;
  if goInput in Options then
  begin
    FCurrentStyleDisplay.DrawAreaSplitter(Rect(GetFooterRect.Left - HorzScrollBar.Position, GetInputRect.Bottom - 6, GetInputRect.Right, GetInputRect.Bottom));
  end;
  if goFooter in Options then
  begin
    FCurrentStyleDisplay.DrawAreaSplitter(Rect(GetFooterRect.Left - HorzScrollBar.Position, GetFooterRect.Top, GetFooterRect.Right, GetFooterRect.Top + 4));
  end;
  if goIndicator in Options then
  begin
    if goInput in Options then FCurrentStyleDisplay.DrawCornerBox(Rect(0, GetInputRect.Top, sizIndicator, GetInputRect.Bottom));
    if goFooter in Options then FCurrentStyleDisplay.DrawCornerBox(Rect(0, GetFooterRect.Top, sizIndicator, GetFooterRect.Bottom), bpBottom);
    if goHeader in Options then FCurrentStyleDisplay.DrawCornerBox(Rect(0, 0, sizIndicator, HeaderSize));
  end;
end;

procedure TNxCustomGridControl.PaintReportRows;
var
  I, Limit, Indent, ARowCount, RowHeight: Integer;
  Done, Clipped: Boolean;
  CellRect: TRect;
  DrawPos: TPoint;
begin
  { Start Pos }
  DrawPos := GetBodyRect.TopLeft;

  Limit := GetBodyRect.Top;
  Done := False;
  FLastRow := FFirstRow;
  ARowCount := RowCount;

  while not Done do
  begin

    if FLastRow < ARowCount then
    begin
      if GetRowVisible(FLastRow) then
      begin
        { Note: Prevent multiple calls
                of OnMeasureRowHeight }
        RowHeight := GetRowHeight(FLastRow);

        Inc(Limit, GridSpace[lpTop]);
        Inc(DrawPos.Y, GridSpace[lpTop]);

        for i := 0 to Pred(Columns.Count) do
        begin
          with Columns.PositionItem[i] do
          begin
            if I >= FFixedCols then Indent := HorzScrollBar.Position else Indent := 0;

            DrawPos.X := Left - Indent;

            Clipped := (I >= FFixedCols) and (DrawPos.X + Width < GetFixedWidth);

            DrawPos.X := Left - Indent;

            if Visible
              and not Clipped
              and (DrawPos.X <= ClientWidth)
              and (DrawPos.X + Width >= 0) then
            begin

              CellRect := Bounds(DrawPos.X, DrawPos.Y, Width, RowHeight);

              if IntegralHeight
                and (limit + RowHeight + GridSpace[lpBottom] > GetBodyRect.Bottom)
              then DrawEmptyCell(Index, FLastRow, CellRect)
              else DrawCell(Index, FLastRow, CellRect);
            end;
          end;
        end;

        if goIndicator in Options then
        begin
          DrawRowIndicator(FLastRow, (FLastRow = SelectedRow) and (not InputSelected), (not InputSelected) and ((Selected[FLastRow]) or (FLastRow = SelectedRow)));
        end;

        Inc(Limit, RowHeight + GridSpace[lpBottom]);
        Inc(DrawPos.Y, RowHeight + GridSpace[lpBottom]);
      end;

      Inc(FLastRow);

    end
    else
    begin
      RowHeight := GetRowHeight(FLastRow);

      Inc(Limit, GridSpace[lpTop]);
      Inc(DrawPos.Y, GridSpace[lpTop]);

      for i := 0 to Pred(Columns.Count) do
        with Columns.PositionItem[i] do
        begin
          if i >= FFixedCols
            then Indent := HorzScrollBar.Position
            else Indent := 0;

          DrawPos.X := Left - Indent;

          Clipped := (I >= FFixedCols) and (DrawPos.X + Width < GetFixedWidth);

          if Visible
            and not Clipped
            and (DrawPos.X <= ClientWidth)
            and (DrawPos.X + Width >= 0) then
          begin
            CellRect := Bounds(DrawPos.X, DrawPos.Y, Width, RowHeight);

            DrawEmptyCell(Index, FLastRow, CellRect);
          end;
        end;

      if goIndicator in Options
        then DrawRowIndicator(FLastRow, False, False);

      Inc(FLastRow);
      Inc(DrawPos.Y, RowHeight + GridSpace[lpBottom]);
      Inc(Limit, RowSize + GridSpace[lpBottom]);
    end;

    { Escape loop }
    if Limit > GetBodyRect.Bottom
      then Done := True;

  end;

  if goSelectFullRow in Options
    then DrawFocusCell;
end;

procedure TNxCustomGridControl.DoColumnChange(Sender: TObject;
  AColumn: TNxCustomColumn; ChangeKind: TColumnChangeKind; Param: Integer = -1);
begin
  if not HandleAllocated then Exit;
  if ChangeKind = ccInputChange then
  begin
    RefreshColumn(AColumn, gaInput);
    Exit;
  end;
  if (gtEdit in GridState) or (gtInput in GridState) then
  begin
		if (ChangeKind = ccVisible) or (ChangeKind = ccSorted)
     	or (ChangeKind = ccWidth) or (ChangeKind = ccPosition)
        then RefreshCellEditor;
  end;
  if ChangeKind = ccPosition then
  begin
    DoColumnMove(AColumn.Index, Param, AColumn.Position);
    Invalidate;
  end;
  if ChangeKind = ccVisible then
  begin
    UpdateHorzScrollBar;
    Invalidate;
  end;

  if ChangeKind = ccUndefined then RefreshColumn(AColumn);

  if ChangeKind = ccRevertStyle then RevertStyle(AColumn.Index);

  if ChangeKind = ccSlideChanged then
  begin
    RefreshColumnSlide(AColumn);
    DoSlideChange(AColumn.Index);
  end;

  if ChangeKind = ccUnsorted then
  begin
    RefreshColumn(AColumn, gaHeader);
    if aoIndicateSortedColumn in AppearanceOptions
      then RefreshColumn(AColumn, gaBody);
    if AColumn = FSortedColumn then FSortedColumn := nil;
  end;

  if ChangeKind = ccWidth then
  begin
    if not IsUpdating then ExpandColumn(AColumn, Param, GridStyle = gsSlides);
    DoColumnResize(AColumn.Index);
    UpdateHorzScrollBar;
  end;

  if ((ChangeKind = ccSorted) or (ChangeKind = ccSortTypeChange))
    and (AColumn.Sorted) then
	begin
    RefreshColumn(AColumn, gaHeader);
		SortColumn(AColumn, AColumn.SortKind = skAscending);
	end;
end;

procedure TNxCustomGridControl.DoColumnResize(ACol: Integer);
begin
  if Assigned(FOnColumnResize) then FOnColumnResize(Self, ACol);
end;

procedure TNxCustomGridControl.DoColumnsChange(Sender: TObject;
  ChangeOpearation: TColumnsOperation; Value1, Value2: Integer);
var
  DataChange: TDataChange;
begin
  ColumnsChange(ChangeOpearation, Value1, Value2);
  if Value1 <> -1 then
  begin
    DataChange := dcAddColumn;
    case ChangeOpearation of
      opAdd: DataChange := dcAddColumn;
      opDelete: DataChange := dcDeleteColumn;
      opInsert: DataChange := dcInsertColumn;
    end;
    DoDataChange(DataChange, Value1);
  end;
end;

procedure TNxCustomGridControl.DoColumnsRepaint(Sender: TObject;
  ChangeOpearation: TColumnsOperation; Value1, Value2: Integer);
begin
	case ChangeOpearation of
    opClear: 
    else RefreshCellEditor;
  end;
  Invalidate;
end;

function TNxCustomGridControl.IntegralHeight: Boolean;
begin
	Result := False;
end;

function TNxCustomGridControl.IsUpdating: Boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TNxCustomGridControl.Paint;
var
  CaptionRect: TRect;
  BackgroundColor: TColor;
begin
  inherited;

  { Postpone paint }
  if UpdateCount > 0
    then Exit;

  { 05/07/03: moving inplace editor
              causes Invalidate! }
  case GridStyle of
    gsReport:
    begin
      HorzScrollClipRect := Rect(GetBodyRect.Left + GetFixedWidth, 0, ClientWidth, ClientHeight);
      VertScrollClipRect := Rect(0, GetBodyRect.Top, ClientWidth, GetBodyRect.Bottom);
      PaintReport;

      with Canvas do
      begin
        if Columns.ClientWidth - HorzScrollBar.Position < ClientWidth then
        begin
          BackgroundColor := Color;
          Brush.Color := BackgroundColor;
          if (IsThemed) and (HeaderStyle = hsAuto) then
          begin
            FCurrentStyleDisplay.DrawInactiveHeader(Rect(GetBodyRect.Right, 0, ClientWidth, GetHeaderRect.Bottom));
            FillRect(Rect(GetBodyRect.Right, GetInputRect.Top, ClientWidth, ClientHeight));
            FillRect(Rect(GetBodyRect.Right, GetBodyRect.Bottom, ClientWidth, ClientHeight));
          end else
          begin
	          FillRect(Rect(GetBodyRect.Right, 0, ClientWidth, ClientHeight));
          end;
        end;
      end;
    end;
    gsSlides:
    begin
      if (goHeader in Options) and (IsThemed)
        and (HeaderStyle = hsAuto) then
      begin
        FCurrentStyleDisplay.DrawInactiveHeader(Rect(Columns.ClientWidth, 0, ClientWidth, GetHeaderRect.Bottom));
      end;
      HorzScrollClipRect := ClientRect;
      VertScrollClipRect := Rect(0, GetBodyRect.Top, ClientWidth, ClientHeight);
      PaintSlides;
    end;
  end;
  if GetVisibleRows = 0 then
  begin
    Canvas.Font.Assign(Self.Font);
    if not Enabled then Canvas.Font.Color := clGrayText;
    CaptionRect := GetCaptionRect;
    TGraphicsProvider.DrawTextRect(Canvas, CaptionRect, taCenter, Caption);
  end;
  DoPostDraw;
end;

procedure TNxCustomGridControl.SetMultiSelected;
begin
  Include(FGridState, gtMultiSelect);
end;

procedure TNxCustomGridControl.SetRowCount(const Value: Integer);
var
  i: Integer;
begin
  if Value < 0 then Exit;
  if Value > RowCount then
  begin
    AddRow(Value - RowCount);
  end else
  begin
    for i := 1 to RowCount - Value do DeleteRow(RowCount - 1);
  end;
end;

procedure TNxCustomGridControl.StartEdit(const ACol, ARow: Integer; Key: Char);
var
	ContinueEditing: Boolean;
begin
  if (ACol = FEditingCell.X) and (ARow = FEditingCell.Y)
    or not(ceEditable in Columns[ACol].ColumnState) or ReadOnly or not CanEdit then Exit;

  if (Columns[ACol].InplaceEdit = nil) and (Columns[ACol].Editor = nil) then Exit;

  if (ARow >= RowCount) or (ARow < 0) or (ACol >= Columns.Count) or (ACol < 0) then Exit;

  ContinueEditing := True;
  DoBeforeEdit(ACol, ARow, ContinueEditing);
  if not ContinueEditing then Exit;

  ApplyEditing;
  EndEditing;

  Include(FGridState, gtEdit);
  FEditingCell := Point(ACol, ARow);

  if not Assigned(Columns[ACol].InplaceEdit) then
  begin
    if Columns[ACol].Editor = nil then Exit;
    InplaceEdit := Columns[ACol].Editor;
    SetInplaceEditEvents;
    with InplaceEdit do
    begin
      Columns[ACol].BeginEditing;
      EditorUpdating := False;
      Color := GetCellColor(ACol, ARow);
      Font.Assign(Columns[ACol].Font);
      SetInplaceEditEvents;
      BeginEditing;
    end;
  end else
  begin
    InplaceEdit := Columns[ACol].InplaceEdit;
    if not(goInplaceEditEvents in Options) then SetInplaceEditEvents;
  end;

  RefreshCellEditor;//newpos

  InplaceEdit.AutoSelect := False;
  SendMessage(InplaceEdit.Handle, WM_CHAR, Ord(Key), 0);

{ bn: if editing is canceled then exit }
  if InplaceEdit = nil then Exit;

  InplaceEdit.AutoSelect := True;
  PrepareEdit;

  FInplaceEditUpdate := False;
//  RefreshCellEditor;

  { move cursor to last pos }
  FInplaceEdit.SelStart := Length(FInplaceEdit.Text);

  DoEditEnter; { Event }
end;

procedure TNxCustomGridControl.StartInput(const Index: Integer; Key: Char);
var
  Column: TNxCustomColumn;
begin
  Column := Columns[Index];
  InputSelected := True;
  if (gtEdit in GridState) or (gtInput in GridState) then
  begin
    ApplyEditing;
    EndEditing;
  end;

  if (Column.Editor = nil) and (Column.InplaceEdit = nil) then Exit;
  if (not(ceCanInput in Column.ColumnState)) or ReadOnly then Exit;

  Include(FGridState, gtInput);

  if not Assigned(Column.InplaceEdit) then
  begin
    InplaceEdit := Column.Editor;
    SetInplaceEditEvents;
    with InplaceEdit do
    begin
      Column.BeginEditing;
      EditorUpdating := False;
      Color := Column.Color;
      AutoSelect := False;
      Font.Color := Column.Font.Color;
      BeginEditing;
    end;
  end else
  begin
    InplaceEdit := Column.InplaceEdit;
    if not(goInplaceEditEvents in Options) then SetInplaceEditEvents;
  end;

  { event }
  FInputingColumn := Column.Index;
  Column.Input := True;

  FInplaceEditUpdate := True;

  SendMessage(InplaceEdit.Handle, WM_CHAR, Ord(Key), 0);

  FInplaceEditUpdate := False;

  FEditingCell := Point(-1, -1);
  RefreshCellEditor;
  if coEditorAutoSelect in Column.Options then InplaceEdit.SelectAll
    else FInplaceEdit.SelStart := Length(FInplaceEdit.Text);

  DoInputSelectCell(Column.Index); { Event }
end;

procedure TNxCustomGridControl.SelectFirstColumn;
var
  i: Integer;
begin
  for i := 0 to Columns.Count - 1 do
  begin
    if (Columns.PositionItem[i].Visible) and (Columns.PositionItem[i].Enabled) then
    begin
      SelectedColumn := i;
      ScrollToColumn(Columns.PositionItem[i]);
      Exit;
    end;
  end;
end;

procedure TNxCustomGridControl.SelectLastColumn;
var
  i: Integer;
begin
  for i := Columns.Count - 1 downto 0 do
  begin
    if Columns.PositionItem[i].Visible then
    begin
      SelectedColumn := i;
      ScrollToColumn(Columns.PositionItem[i]);
      Exit;
    end;
  end;
end;      

function TNxCustomGridControl.GetMultiSelect: Boolean;
begin
  Result := (goMultiSelect in FOptions) and (goSelectFullRow in FOptions)
end;

procedure TNxCustomGridControl.WMThemeChanged(var Message: TMessage);
begin
  inherited;
  if IsThemed then
  begin
    CloseThemeData(FTheme);
    FTheme := OpenThemeData(Handle, NxThemesSupport.teHeader);
    FDefaultStyleDisplay.Theme := FTheme;
  end;
end;

function TNxCustomGridControl.GetFirstRow: Integer;
var
  i, c: Integer;
begin
  Result := 0;
  c := VertScrollBar.Position;
  i := 0;
  while i < c do
  begin
    if GetRowVisible(Result) then Inc(i);
    Inc(Result);
  end;
end;

end.

