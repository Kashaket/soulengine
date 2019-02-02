{
  Next Grid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:ColumnClasses.pas 12/25/2002 7:10:16 bn
}

{$I '..\NxSuite.inc'}

unit NxColumnClasses;

interface

uses
  Classes, Types, Windows, Graphics, Controls, SysUtils, StdCtrls,
  DateUtils, ImgList, NxColumns, NxClasses, NxEdit;

const
  { Hyperlink related colors }
  clDefaultHyperlink            = $00B36600; { Medium blue }
  clDefaultInvalidatedHyperlink = $000000FF; { Red }
  clDefaultVisitedHyperlink     = $00990066; { Purple }

type
  TProgressStyle = (psSolid, psBoxes, psGradient, psCylinder);

  TNxTreeColumn = class(TNxCustomColumn)
  private
    FExpandLock: Boolean;
    FShowButtons: Boolean;
    FShowLines: Boolean;
    FHighlightButton: Boolean;
    FImages: TCustomImageList;
    procedure SetExpandLock(const Value: Boolean);
    procedure SetShowButtons(const Value: Boolean);
    procedure SetShowLines(const Value: Boolean);
    procedure SetHighlightButton(const Value: Boolean);
    procedure SetImages(const Value: TCustomImageList);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnPlayClass: TColumnPlayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    procedure AdjustEditRect(const Level: Integer; var EditRect: TRect); override;
    constructor Create(AOwner: TComponent); override;
    function IsKeyValid(Key: Char): Boolean; override;
  published
    property ExpandLock: Boolean read FExpandLock write SetExpandLock default False;
    property HighlightButton: Boolean read FHighlightButton write SetHighlightButton default False;
    property Images: TCustomImageList read FImages write SetImages;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property ShowLines: Boolean read FShowLines write SetShowLines default False;
  end;

  TNxTextColumn = class(TNxCustomColumn)
  private
    FMaxLength: Integer;
    FMultiLine: Boolean;
    FTextAfter: WideString;
    FTextBefore: WideString;
    FPasswordChar: TChar;
    procedure SetTextAfter(const Value: WideString);
    procedure SetTextBefore(const Value: WideString);
    procedure SetMultiline(const Value: Boolean);
    procedure SetMaxLength(const Value: Integer);
    procedure SetPasswordChar(const Value: TChar);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetCellBestFit(Value: WideString): Integer; override;
    function GetDisplayOptions: TDisplayOptions; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
  published
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property MultiLine: Boolean read FMultiLine write SetMultiline default False;
    property Options default [coCanClick, coCanSort, coCanInput, coPublicUsing, coShowTextFitHint];
    property PasswordChar: TChar read FPasswordChar write SetPasswordChar default #0;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
    property TextBefore: WideString read FTextBefore write SetTextBefore;
  end;

  TNxTimeColumn = class(TNxTextColumn)
  private
    FHideWhenEmpty: Boolean;
    FEmptyCaption: WideString;
    FFormatMask: string;
    procedure SetHideWhenEmpty(const Value: Boolean);
    procedure SetEmptyCaption(const Value: WideString);
    procedure SetFormatMask(const Value: string);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    procedure UpdateEdit; override;
  published
    property EmptyCaption: WideString read FEmptyCaption write SetEmptyCaption;
    property FormatMask: string read FFormatMask write SetFormatMask;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty default False;
  end;

  TNxButtonColumn = class(TNxTextColumn)
  private
    FButtonCaption: WideString;
    FEditOptions: TNxEditOptions;
    FGlyph: TBitmap;
    FOnButtonClick: TNotifyEvent;
    FShowButton: Boolean;
    FButtonWidth: Integer;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetButtonCaption(const Value: WideString);
    procedure SetButtonWidth(const Value: Integer);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    procedure DoButtonClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
  published
    property ButtonCaption: WideString read FButtonCaption write SetButtonCaption;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 21;
    property EditOptions: TNxEditOptions read FEditOptions write FEditOptions default [];
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property ShowButton: Boolean read FShowButton write FShowButton default True;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

  TNxCheckBoxColumn = class(TNxCustomColumn)
  private
    FOnChange: TNotifyEvent;
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnPlayClass: TColumnPlayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    procedure DoChange; dynamic;                     
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNxHtmlColumn = class(TNxCustomColumn)
  private
    FOnClick: TNxHtmlClickEvent;
    FTagAfter: WideString;
    FTagBefore: WideString;
    procedure SetTagAfter(const Value: WideString);
    procedure SetTagBefore(const Value: WideString);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnPlayClass: TColumnPlayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetHintText(Cell: TCellInfo): WideString; override;
    property TagAfter: WideString read FTagAfter write SetTagAfter;
    property TagBefore: WideString read FTagBefore write SetTagBefore;
  published
    property OnClick: TNxHtmlClickEvent read FOnClick write FOnClick;
  end;

  TNxImageColumn = class(TNxCustomColumn)
  private
    FImages: TCustomImageList;
    FTransparent: Boolean;
    procedure SetImages(const Value: TCustomImageList);
    procedure SetTransparent(const Value: Boolean);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TComponent); override;
    function GetColumnStyle: TColumnStyle; override;
  published
    property Images: TCustomImageList read FImages write SetImages;
    property Transparent: Boolean read FTransparent write SetTransparent default True;
  end;

  TProgressTextPosition = (tpInside, tpBeside);

  TNxProgressColumn = class(TNxCustomColumn)
  private
    FBorderColor: TColor;
    FEmptyValue: Double;
    FHideWhenEmpty: Boolean;
    FMargin: Integer;
    FMax: Integer;
    FProgressColor: TColor;
    FProgressHeight: Integer;
    FProgressStyle: TProgressStyle;
    FShowText: Boolean;
    FTransparent: Boolean;
    FRoundCorners: Boolean;
    FHighValueBound: Integer;
    FLowValueBound: Integer;
    FLowValueColor: TColor;
    FHighValueColor: TColor;
    FTextPosition: TProgressTextPosition;
    FPrecision: Integer;
    procedure SetBorderColor(const Value: TColor);
    procedure SetHideWhenEmpty(const Value: Boolean);
    procedure SetHighValueBound(const Value: Integer);
    procedure SetHighValueColor(const Value: TColor);
    procedure SetLowValueBound(const Value: Integer);
    procedure SetLowValueColor(const Value: TColor);
    procedure SetMargin(const Value: Integer);
    procedure SetMax(const Value: Integer);
    procedure SetProgressColor(const Value: TColor);
    procedure SetProgressHeight(const Value: Integer);
    procedure SetProgressStyle(const Value: TProgressStyle);
    procedure SetRoundCorners(const Value: Boolean);
    procedure SetShowText(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetTextPosition(const Value: TProgressTextPosition);
    procedure SetPrecision(const Value: Integer);
    procedure SetEmptyValue(const Value: Double);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor default clGray;
    property EmptyValue: Double read FEmptyValue write SetEmptyValue;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty;
    property HighValueBound: Integer read FHighValueBound write SetHighValueBound default 0;
    property HighValueColor: TColor read FHighValueColor write SetHighValueColor default clHighlight;
    property LowValueBound: Integer read FLowValueBound write SetLowValueBound default 0;
    property LowValueColor: TColor read FLowValueColor write SetLowValueColor default clHighlight;
    property Margin: Integer read FMargin write SetMargin default 2;
    property Max: Integer read FMax write SetMax default 100;
    property Precision: Integer read FPrecision write SetPrecision default 0;
    property ProgressColor: TColor read FProgressColor write SetProgressColor default clHighlight;
    property ProgressHeight: Integer read FProgressHeight write SetProgressHeight default 0;
    property ProgressStyle: TProgressStyle read FProgressStyle write SetProgressStyle;
    property RoundCorners: Boolean read FRoundCorners write SetRoundCorners default False;
    property ShowText: Boolean read FShowText write SetShowText default False;
    property TextPosition: TProgressTextPosition read FTextPosition write SetTextPosition default tpBeside;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
  end;

  TNxRateColumn = class(TNxCustomColumn)
  private
    FEmptyGlyph: TBitmap;
    FGlyph: TBitmap;
    FMax: Integer;
    FTransparent: Boolean;
    FHideWhenEmpty: Boolean;
    procedure SetEmptyGlyph(const Value: TBitmap);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetMax(const Value: Integer);
    procedure SetTransparent(const Value: Boolean);
    procedure SetHideWhenEmpty(const Value: Boolean);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnPlayClass: TColumnPlayClass; override;
    procedure DoGlyphChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetColumnStyle: TColumnStyle; override;
  published
    property EmptyGlyph: TBitmap read FEmptyGlyph write SetEmptyGlyph;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty default False;
    property Max: Integer read FMax write SetMax default 5;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
  end;

  TNxPopupColumn = class(TNxTextColumn)
  private
    FOnCloseUp: TNotifyEvent;
    FOnSelect: TNotifyEvent;
  protected
    procedure DoCloseUp(Sender: TObject); dynamic;
    procedure DoSelect(Sender: TObject); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
  end;

  TCompoBoxStyle = (cbsDropDown, cbsDropDownList);

  TNxStringsColumn = class(TNxPopupColumn)
  private
    FDropDownCount: Integer;
    FImages: TCustomImageList;
    FItems: TNxStrings;
    FDisplayMode: TDisplayMode;
    FListWidth: Integer;
    FAutoDropDown: Boolean;
    procedure SetImages(const Value: TCustomImageList);
    procedure SetItems(const Value: TNxStrings);
    procedure SetDropDownCount(const Value: Integer);
    procedure SetDisplayMode(const Value: TDisplayMode);
    procedure SetListWidth(const Value: Integer);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
	public
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateEdit; override;
	published
    property AutoDropDown: Boolean read FAutoDropDown write FAutoDropDown default False;
    property DisplayMode: TDisplayMode read FDisplayMode write SetDisplayMode default dmTextOnly;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TNxStrings read FItems write SetItems;
    property ListWidth: Integer read FListWidth write SetListWidth default 0;
  end;

  TNxComboBoxColumn = class(TNxStringsColumn)
  private
    FDataMode: TItemsDisplayMode;
    FStyle: TCompoBoxStyle;
    FAutoComplete: Boolean;
    procedure SetDataMode(const Value: TItemsDisplayMode);
    procedure SetStyle(const Value: TCompoBoxStyle);
 	public
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
  	function GetCellEditorClass: TCellEditorClass; override;
    function IsKeyValid(Key: Char): Boolean; override;
    procedure UpdateEdit; override;
	published
    property AutoComplete: Boolean read FAutoComplete write FAutoComplete default False;
    property DataMode: TItemsDisplayMode read FDataMode write SetDataMode default dmDefault;
    property Style: TCompoBoxStyle read FStyle write SetStyle default cbsDropDown;
  end;

  TNxIncrementColumn = class(TNxCustomColumn)
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
  end;

  TNxListColumn = class(TNxStringsColumn)
  private
    FSorted: Boolean;
  public
    procedure ApplyEditing(var Value: WideString); override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function GetInputDrawText: WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
    procedure UpdateEdit; override;
  public
    function GetInputValue: WideString; override;
  published
    property Sorted: Boolean read FSorted write FSorted default False;
  end;

  TNxCustomNumberColumn = class(TNxCustomColumn)
  private
    FEditOptions: TNxNumberEditOptions;
    FHideWhenEmpty: Boolean;
    FMin: Double;
    FMax: Double;
    FFormatMask: string;
    FEmptyCaption: WideString;
    FTextAfter: WideString;
    FTextBefore: WideString;
    FEmptyValue: Double;
    procedure SetEmptyCaption(const Value: WideString);
    procedure SetFormatMask(const Value: string);
    procedure SetHideWhenEmpty(const Value: Boolean);
    procedure SetMax(const Value: Double);
    procedure SetMin(const Value: Double);
    procedure SetTextAfter(const Value: WideString);
    procedure SetTextBefore(const Value: WideString);
    procedure SetEmptyValue(const Value: Double);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
  published
    property EditOptions: TNxNumberEditOptions read FEditOptions write FEditOptions default [eoAllowFloat];
    property EmptyCaption: WideString read FEmptyCaption write SetEmptyCaption;
    property EmptyValue: Double read FEmptyValue write SetEmptyValue;
    property FormatMask: string read FFormatMask write SetFormatMask;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty default False;
    property Max: Double read FMax write SetMax;
    property Min: Double read FMin write SetMin;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
    property TextBefore: WideString read FTextBefore write SetTextBefore;
  end;

  TNxNumberColumn = class(TNxCustomNumberColumn)
  private
    FIncrement: Double;
    FSpinButtons: Boolean;
    FPrecision: Integer;
    FShowButton: Boolean;
    FButtonCaption: WideString;
    FOnButtonClick: TNotifyEvent;
    procedure SetIncrement(const Value: Double);
    procedure SetSpinButtons(const Value: Boolean);
    procedure SetPrecision(const Value: Integer);
    procedure SetShowButton(const Value: Boolean);
    procedure SetButtonCaption(const Value: WideString);
  protected
    procedure DoButtonClick(Sender: TObject); dynamic;
  	function GetCellEditorClass: TCellEditorClass; override;
	public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    procedure UpdateEdit; override;
	published
    property Alignment default taRightJustify;
    property ButtonCaption: WideString read FButtonCaption write SetButtonCaption;
    property Increment: Double read FIncrement write SetIncrement;
    property Precision: Integer read FPrecision write SetPrecision;
    property ShowButton: Boolean read FShowButton write SetShowButton default False;
    property SpinButtons: Boolean read FSpinButtons write SetSpinButtons default True;

    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

  TNxCalcColumn = class(TNxCustomNumberColumn)
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
  public
    procedure BeginEditing; override;
  end;

  TNxDateColumn = class(TNxPopupColumn)
  private
    FHideWhenEmpty: Boolean;
    FEmptyCaption: WideString;
    FFormatMask: string;
    FDateSeparator: Char;
    FStartDay: TStartDayOfWeek;
    FShowNoneButton: Boolean;
    FTodayCaption: WideString;
    FNoneCaption: WideString;
    procedure SetHideWhenEmpty(const Value: Boolean);
    procedure SetEmptyCaption(const Value: WideString);
    procedure SetFormatMask(const Value: string);
    procedure SetDateSeparator(const Value: Char);
    procedure SetShowNoneButton(const Value: Boolean);
    procedure SetNoneCaption(const Value: WideString);
    procedure SetTodayCaption(const Value: WideString);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
	public
    constructor Create(AOwner: TComponent); override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
    procedure BeginEditing; override;
  published
    property DateSeparator: Char read FDateSeparator write SetDateSeparator default '/';
    property EmptyCaption: WideString read FEmptyCaption write SetEmptyCaption;
    property FormatMask: string read FFormatMask write SetFormatMask;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty default False;
    property NoneCaption: WideString read FNoneCaption write SetNoneCaption;
    property ShowNoneButton: Boolean read FShowNoneButton write SetShowNoneButton default True;
    property StartDay: TStartDayOfWeek read FStartDay write FStartDay default dwSunday;
    property TodayCaption: WideString read FTodayCaption write SetTodayCaption;
  end;

  TNxGraphicColumn = class(TNxCustomColumn)
  private
    FActualSize: Boolean;
    FMargin: Integer;
    FStretch: Boolean;
    FBorderWidth: Integer;
    procedure SetActualSize(const Value: Boolean);
    procedure SetMargin(const Value: Integer);
    procedure SetStretch(const Value: Boolean);
    procedure SetBorderWidth(const Value: Integer);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
	public
    constructor Create(AOwner: TComponent); override;
  published
    property ActualSize: Boolean read FActualSize write SetActualSize default False;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth default 1;
    property Margin: Integer read FMargin write SetMargin default 4;
    property Stretch: Boolean read FStretch write SetStretch default False;
  end;

  TNxMemoColumn = class(TNxButtonColumn)
  private
    FScrollBars: TScrollStyle;
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    procedure BeginEditing; override;
    function GetDisplayOptions: TDisplayOptions; override;
  published
    property ScrollBars: TScrollStyle read FScrollBars write FScrollBars default ssNone;
  end;

  TNxHyperlinkClickEvent = procedure(Sender: TObject; ACol, ARow: Integer; AHyperlink: WideString) of object;

  { TNxHyperlinkColumn }
  TNxHyperlinkColumn = class(TNxCustomColumn)
  private
    { Private declarations }
    FInvalidatedLinkColor: TColor;
    FOnClick: TNxHyperlinkClickEvent;
    FVisitedLinkColor: TColor;
  protected
    { Protected declarations }
    { The lists are protected so that both can be managed correspondingly }
    FInvalidatedHyperlinks: TNxStringList;
    FVisitedHyperlinks: TNxStringList;
    function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnPlayClass: TColumnPlayClass; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddInvalidatedHyperlink(AHyperlink: WideString); virtual;
    procedure AddVisitedHyperlink(AHyperlink: WideString); virtual;
    procedure ClearInvalidatedHyperlinks; virtual;
    procedure ClearVisitedHyperlinks; virtual;
    function HyperlinkHasBeenInvalidated(AHyperlink: WideString): Boolean; virtual;
    function HyperlinkHasBeenVisited(AHyperlink: WideString): Boolean; virtual;
    procedure LoadInvalidatedHyperlinksFromFile(AFileName: WideString); virtual;
    procedure LoadInvalidatedHyperlinksFromStream(AStream: TStream); virtual;
    procedure LoadVisitedHyperlinksFromFile(AFileName: WideString); virtual;
    procedure LoadVisitedHyperlinksFromStream(AStream: TStream); virtual;
    procedure RemoveInvalidatedHyperlink(AHyperlink: WideString); virtual;
    procedure RemoveVisitedHyperlink(AHyperlink: WideString); virtual;
    procedure SaveInvalidatedHyperlinksToFile(AFileName: WideString); virtual;
    procedure SaveInvalidatedHyperlinksToStream(AStream: TStream); virtual;
    procedure SaveVisitedHyperlinksToFile(AFileName: WideString); virtual;
    procedure SaveVisitedHyperlinksToStream(AStream: TStream); virtual;
  published
    { Published declarations }
    property InvalidatedLinkColor: TColor read FInvalidatedLinkColor write FInvalidatedLinkColor default clDefaultInvalidatedHyperlink;
    property VisitedLinkColor: TColor read FVisitedLinkColor write FVisitedLinkColor default clDefaultVisitedHyperlink;
    property OnClick: TNxHyperlinkClickEvent read FOnClick write FOnClick;
  end;

  TNxColorColumn = class(TNxTextColumn)
  private
    FFullSize: Boolean;
    procedure SetFullSize(const Value: Boolean);
  protected
    function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property FullSize: Boolean read FFullSize write SetFullSize default False;
  end;

  function LocateKey(Key: WideChar; Items: TNxStrings): Integer;
  function ValidNumberKey(Key: Char; Options: TNxNumberEditOptions): Boolean;

implementation

uses
  NxGrid, NxGridCommon, NxDisplays, Dialogs, Math;

function LocateKey(Key: WideChar; Items: TNxStrings): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Pred(Items.Count) do
    if (Length(Items[i]) > 0) and
      (WideCompareText(Items[i][1], Key) = 0) then
    begin
      Result := i;
      Exit;
    end;
end;

function ValidNumberKey(Key: Char; Options: TNxNumberEditOptions): Boolean;
begin
  Result := True;
  {$IFDEF DELPHI2009UP}
  if CharInSet(Key, ['1'..'9', '0']) then Exit;
  if (eoAllowSigns in Options) and (CharInSet(Key, ['-', '+'])) then Exit;
  if (eoAllowFloat in Options) and (Key = LocalSettings.DecimalSeparator) then Exit;
  {$ELSE}
  if Key in ['1'..'9', '0'] then Exit;
  if (eoAllowSigns in Options) and (Key in ['-', '+']) then Exit;
  if (eoAllowFloat in Options) and (Key = DecimalSeparator) then Exit;
  {$ENDIF}
  Result := False;
end;

{ TNxTreeColumn }

procedure TNxTreeColumn.AdjustEditRect(const Level: Integer;
  var EditRect: TRect);
var
  Indent: Integer;
begin
  Indent := Level * 19;
  Inc(EditRect.Left, Indent + 16 + Padding);
  if Assigned(Images) then Inc(EditRect.Left, Images.Width);
end;
                                    
constructor TNxTreeColumn.Create(AOwner: TComponent);
begin
  inherited;
  FExpandLock := False;
  FHighlightButton := False;
  FImages := nil;
  FShowButtons := True;
  FShowLines := False;
end;

function TNxTreeColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxEdit;
end;

function TNxTreeColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTreeColumnDisplay;
end;

function TNxTreeColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := TTreeColumnPlay;
end;

function TNxTreeColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csClickable, csDisableSorting, csFitToLargest];
end;

function TNxTreeColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := Ord(Key) > 32;
end;

procedure TNxTreeColumn.SetExpandLock(const Value: Boolean);
begin
  FExpandLock := Value;
end;

procedure TNxTreeColumn.SetHighlightButton(const Value: Boolean);
begin
  FHighlightButton := Value;
  Refresh;
end;

procedure TNxTreeColumn.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  Refresh;
end;

procedure TNxTreeColumn.SetShowButtons(const Value: Boolean);
begin
  FShowButtons := Value;
  Refresh;
end;

procedure TNxTreeColumn.SetShowLines(const Value: Boolean);
begin
  FShowLines := Value;
  Refresh;
end;

{ TNxButtonColumn }

constructor TNxButtonColumn.Create(AOwner: TComponent);
begin
  inherited;
  FButtonCaption := '';
  FButtonWidth := 21;
  FGlyph := TBitmap.Create;
  FShowButton := True;
  DefaultValue := '';
  SetColumnType(ctString);
  SetSortType(stAlphabetic);
  TNxButtonEdit(Editor).OnButtonClick := DoButtonClick;
end;

destructor TNxButtonColumn.Destroy;
begin
  FGlyph.FreeImage;
  FreeAndNil(FGlyph);
  inherited;
end;

procedure TNxButtonColumn.Assign(Source: TPersistent);
begin
  inherited;

end;

procedure TNxButtonColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxButtonEdit do
  begin
    ButtonCaption := Self.ButtonCaption;
    ButtonWidth := Self.ButtonWidth;
    ButtonGlyph.Assign(FGlyph);
    Options := Self.EditOptions;
    ShowButton := Self.ShowButton;
    TransparentColor := FGlyph.TransparentColor;
  end;
end;

function TNxButtonColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxButtonEdit;
end;

procedure TNxButtonColumn.SetButtonCaption(const Value: WideString);
begin
  FButtonCaption := Value;
end;

function TNxButtonColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTextColumnDisplay;
end;

procedure TNxButtonColumn.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  FGlyph.Transparent := True;
  FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
end;

procedure TNxButtonColumn.DoButtonClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then FOnButtonClick(Self);
end;

procedure TNxButtonColumn.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
end;

{ TNxCheckBoxColumn }

constructor TNxCheckBoxColumn.Create(AOwner: TComponent);
begin
  inherited;
  DefaultValue := '';
  SetColumnType(ctBoolean);
  SetSortType(stBoolean);
end;

procedure TNxCheckBoxColumn.Assign(Source: TPersistent);
begin
  inherited;

end;

function TNxCheckBoxColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TCheckBoxColumnDisplay;
end;

function TNxCheckBoxColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := TCheckBoxColumnPlay;
end;

function TNxCheckBoxColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csClickable];
end;

procedure TNxCheckBoxColumn.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

{ TNxHtmlColumn }

constructor TNxHtmlColumn.Create(AOwner: TComponent);
begin
  inherited;
  FTagAfter := '';
  FTagBefore := '';
  SetSortType(stAlphabetic);
  SetColumnType(ctString);
end;

function TNxHtmlColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := nil;
end;

function TNxHtmlColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := THtmlColumnDisplay;
end;

function TNxHtmlColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := THtmlColumnPlay;
end;

function TNxHtmlColumn.GetHintText(Cell: TCellInfo): WideString;
var
  i, j: Integer;
  InHtml: Boolean;
begin
  Result := inherited GetHintText(Cell);
  InHtml := False;
  j := 1;
  for i := 1 to Length(Result) do
  begin
    if Result[i] = '<' then InHtml := True else if Result[i] = '>' then InHtml := False
    else if not InHtml then
    begin
      Result[j] := Result[i];
      inc(j);
    end;
  end;
  SetLength(Result, j - 1);
end;

procedure TNxHtmlColumn.SetTagAfter(const Value: WideString);
begin
  FTagAfter := Value;
  Refresh;
end;

procedure TNxHtmlColumn.SetTagBefore(const Value: WideString);
begin
  FTagBefore := Value;
  Refresh;
end;

{ TNxImageColumn }

constructor TNxImageColumn.Create(AOwner: TComponent);
begin
  inherited;
  FTransparent := True;
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctInteger);
end;

procedure TNxImageColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxImageColumn then
  begin
    Images := TNxImageColumn(Source).Images;
  end;
end;

procedure TNxImageColumn.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TNxImageColumn.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;

function TNxImageColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TImageColumnDisplay;
end;

function TNxImageColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csFitToLargest];
end;

{ TNxProgressColumn }

constructor TNxProgressColumn.Create(AOwner: TComponent);
begin
  inherited;
  FBorderColor := clGray;
  FEmptyValue := 0;
  FHighValueBound := 0;
  FHighValueColor := clHighlight;
  FLowValueBound := 0;
  FMargin := 2;
  FMax := 100;
  FPrecision := 0;
  FProgressColor := clHighlight;
  FProgressHeight := 0;
  FRoundCorners := False;
  FShowText := False;
  FTextPosition := tpBeside;
  FTransparent := False;
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctFloat);
end;

procedure TNxProgressColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxProgressColumn then
  begin
    BorderColor := TNxProgressColumn(Source).BorderColor;
    EmptyValue := TNxProgressColumn(Source).EmptyValue;
    Margin := TNxProgressColumn(Source).Margin;
    Max := TNxProgressColumn(Source).Max;
    ProgressColor := TNxProgressColumn(Source).ProgressColor;
    ProgressStyle := TNxProgressColumn(Source).ProgressStyle;
    TextPosition := TNxProgressColumn(Source).TextPosition;
    ShowText := TNxProgressColumn(Source).ShowText;
  end;
end;

procedure TNxProgressColumn.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
end;

procedure TNxProgressColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
	Refresh(gaBody);
end;

procedure TNxProgressColumn.SetProgressColor(const Value: TColor);
begin
  FProgressColor := Value;
	Refresh(gaBody);
end;

procedure TNxProgressColumn.SetProgressHeight(const Value: Integer);
begin
  FProgressHeight := Value;
	Refresh(gaBody);
end;

procedure TNxProgressColumn.SetHighValueBound(const Value: Integer);
begin
  FHighValueBound := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetHighValueColor(const Value: TColor);
begin
  FHighValueColor := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetLowValueBound(const Value: Integer);
begin
  FLowValueBound := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetLowValueColor(const Value: TColor);
begin
  FLowValueColor := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetMax(const Value: Integer);
begin
  FMax := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetProgressStyle(const Value: TProgressStyle);
begin
  FProgressStyle := Value;
  Refresh(gaBody);
end;

procedure TNxProgressColumn.SetRoundCorners(const Value: Boolean);
begin
  FRoundCorners := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetShowText(const Value: Boolean);
begin
  FShowText := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  Refresh;
end;

function TNxProgressColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TProgressColumnDisplay;
end;

procedure TNxProgressColumn.SetTextPosition(
  const Value: TProgressTextPosition);
begin
  FTextPosition := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetPrecision(const Value: Integer);
begin
  FPrecision := Value;
  Refresh;
end;

procedure TNxProgressColumn.SetEmptyValue(const Value: Double);
begin
  FEmptyValue := Value;
end;

{ TNxRateColumn }

constructor TNxRateColumn.Create(AOwner: TComponent);
begin
  inherited;
  FEmptyGlyph := TBitmap.Create;
  FEmptyGlyph.OnChange := DoGlyphChanged;
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := DoGlyphChanged;
  FMax := 5;
  FTransparent := False;
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctInteger);
end;

destructor TNxRateColumn.Destroy;
begin
  FEmptyGlyph.Free;
  FGlyph.Free;
  inherited;
end;

procedure TNxRateColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxRateColumn then
  begin
    EmptyGlyph.Assign(TNxRateColumn(Source).EmptyGlyph);
    Glyph.Assign(TNxRateColumn(Source).Glyph);
    Max := TNxRateColumn(Source).Max;
    Transparent := TNxRateColumn(Source).Transparent;
  end;
end;

procedure TNxRateColumn.SetEmptyGlyph(const Value: TBitmap);
begin
  FEmptyGlyph.Assign(Value);
end;

procedure TNxRateColumn.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
end;

procedure TNxRateColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
  Refresh(gaBody);
end;

procedure TNxRateColumn.SetMax(const Value: Integer);
begin
  if FMax <> Value then
  begin
	  FMax := Value;
	  Refresh(gaBody);
  end;
end;

procedure TNxRateColumn.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  Refresh(gaBody);
end;

procedure TNxRateColumn.DoGlyphChanged(Sender: TObject);
begin
	if FTransparent then
  begin
    (Sender as TBitmap).TransparentColor := (Sender as TBitmap).Canvas.Pixels[0, (Sender as TBitmap).Height - 1];
    (Sender as TBitmap).Transparent := True;
  end;
end;

function TNxRateColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TRateColumnDisplay;
end;

function TNxRateColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := TRateColumnPlay;
end;

function TNxRateColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csFitToLargest];
end;

{ TNxTextColumn }

constructor TNxTextColumn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxLength := 0;
  FMultiLine := False;
  FTextAfter := '';
  FTextBefore := '';
  FPasswordChar := #0;
  DefaultValue := '';
  Options := [coCanClick, coCanSort, coCanInput,
    coPublicUsing, coShowTextFitHint];
end;

function TNxTextColumn.GetDisplayOptions: TDisplayOptions;
begin
  if MultiLine then Result := [doMultiLine];
end;

procedure TNxTextColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxTextColumn then
  begin
    FMaxLength := TNxTextColumn(Source).MaxLength;
    FMultiLine := TNxTextColumn(Source).MultiLine;
    FPasswordChar := TNxTextColumn(Source).PasswordChar;
    FTextAfter := TNxTextColumn(Source).TextAfter;
    FTextBefore := TNxTextColumn(Source).TextBefore;
  end;
end;

procedure TNxTextColumn.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
  Refresh(gaBody);
end;

procedure TNxTextColumn.SetTextBefore(const Value: WideString);
begin
  FTextBefore := Value;
  Refresh(gaBody);
end;

function TNxTextColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxEdit;
end;

function TNxTextColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTextColumnDisplay;
end;

function TNxTextColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := Ord(Key) > 32;
end;

function TNxTextColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

procedure TNxTextColumn.BeginEditing;
begin
  inherited;
  with Editor do
  begin
    InplaceEditor := True;
    MaxLength := FMaxLength;
    PasswordChar := FPasswordChar;
  end;
end;

function TNxTextColumn.GetCellBestFit(Value: WideString): Integer;
begin
  Result := GetTextWidth(Display.Canvas, Value);
  Inc(Result, 5);
end;

procedure TNxTextColumn.SetMultiline(const Value: Boolean);
begin
  FMultiLine := Value;
  Refresh(gaBody);
end;

procedure TNxTextColumn.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;
  Refresh(gaBody);
end;

function TNxTextColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := FTextBefore + inherited GetDrawText(Cell) + FTextAfter;
  if PasswordChar <> #0 then Result := StringOfChar(PasswordChar, Length(Result));
end;

procedure TNxTextColumn.SetPasswordChar(const Value: TChar);
begin
  FPasswordChar := Value;
  Refresh(gaBody);
end;

{ TNxStringsColumn }

procedure TNxStringsColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxStringsColumn then
  begin
    DropDownCount := TNxComboBoxColumn(Source).DropDownCount;
    Items.Assign(TNxComboBoxColumn(Source).Items);
  end;
end;

procedure TNxStringsColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxComboBox do
  begin
    AutoDropDown := Self.AutoDropDown;
    DropDownCount := Self.DropDownCount;
    Images := Self.Images;
    Items.Assign(Self.Items);
    ListWidth := FListWidth;
    PreviewBorder := False;
    ShowPreview := Self.DisplayMode <> dmTextOnly;
  end;
end;

constructor TNxStringsColumn.Create(AOwner: TComponent);
begin
  inherited;
  FAutoDropDown := False;
  FDropDownCount := 8;
  FDisplayMode := dmTextOnly;
  FItems := TNxStringList.Create;
  FImages := nil;
  FListWidth := 0;
  DefaultValue := '';
end;

destructor TNxStringsColumn.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

function TNxStringsColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TStringsColumnDisplay;
end;

procedure TNxStringsColumn.SetDisplayMode(const Value: TDisplayMode);
begin
  FDisplayMode := Value;
  Refresh;
end;

procedure TNxStringsColumn.SetDropDownCount(const Value: Integer);
begin
  FDropDownCount := Value;
end;

procedure TNxStringsColumn.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
end;

procedure TNxStringsColumn.SetItems(const Value: TNxStrings);
begin
  FItems.Assign(Value);
end;

procedure TNxStringsColumn.SetListWidth(const Value: Integer);
begin
  FListWidth := Value;
end;

procedure TNxStringsColumn.UpdateEdit;
begin
  if FAutoDropDown then
    TNxComboBox(Editor).DroppedDown := True;
end;

{ TNxComboBoxColumn }

procedure TNxComboBoxColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxComboBoxColumn then
  begin
    DataMode := TNxComboBoxColumn(Source).DataMode;
    Style := TNxComboBoxColumn(Source).Style;
  end;
end;

procedure TNxComboBoxColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxComboBox do
  begin
    if FStyle = cbsDropDownList then Style := dsDropDownList
      else Style := dsDropDown;
    AutoComplete := Self.AutoComplete;
    DisplayMode := FDataMode;
  end;
end;

constructor TNxComboBoxColumn.Create(AOwner: TComponent);
begin
  inherited;
  FAutoComplete := False;
  FDataMode := dmDefault;
  FStyle := cbsDropDown;
end;

procedure TNxComboBoxColumn.SetDataMode(const Value: TItemsDisplayMode);
begin
  FDataMode := Value;
end;

procedure TNxComboBoxColumn.SetStyle(const Value: TCompoBoxStyle);
begin
  FStyle := Value;
end;

function TNxComboBoxColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxComboBox;
end;    

function TNxComboBoxColumn.IsKeyValid(Key: Char): Boolean;
begin
  if Style = cbsDropDownList then
  begin
    Result := (LocateKey(WideChar(Key), FItems) <> -1) or FAutoDropDown;
  end else Result := inherited IsKeyValid(Key);
end;

procedure TNxComboBoxColumn.UpdateEdit;
var
  Index: Integer;                  
begin
  if Style = cbsDropDownList then
    with Editor as TNxComboBox do
    begin
      Index := Items.IndexOf(AsString);
      if Index <> -1 then ItemIndex := Index;
    end;
  inherited;
end;

{ TNxCustomNumberColumn }

constructor TNxCustomNumberColumn.Create(AOwner: TComponent);
begin
  inherited;
  FEditOptions := [eoAllowFloat];
  FEmptyCaption := '';
  FEmptyValue := 0;
  FFormatMask := '';
  FHideWhenEmpty := False;
  FMax := 0;
  FMin := 0;
  FTextAfter := '';
  FTextBefore := '';
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctFloat);
end;

procedure TNxCustomNumberColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxCustomNumberColumn then
  begin
    EmptyCaption := TNxNumberColumn(Source).EmptyCaption;
    EmptyValue := TNxNumberColumn(Source).EmptyValue;
    FormatMask := TNxNumberColumn(Source).FormatMask;
    HideWhenEmpty := TNxNumberColumn(Source).HideWhenEmpty;
    Max := TNxNumberColumn(Source).Max;
    Min := TNxNumberColumn(Source).Min;
    TextAfter := TNxNumberColumn(Source).TextAfter;
    TextBefore := TNxNumberColumn(Source).TextBefore;
  end;
end;

procedure TNxCustomNumberColumn.SetEmptyCaption(const Value: WideString);
begin
  FEmptyCaption := Value;
  Refresh(gaBody);
end;

procedure TNxCustomNumberColumn.SetEmptyValue(const Value: Double);
begin
  FEmptyValue := Value;
  Refresh(gaBody);
end;

procedure TNxCustomNumberColumn.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
  Refresh(gaBody);
end;

procedure TNxCustomNumberColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
  Refresh(gaBody);
end;

procedure TNxCustomNumberColumn.SetMax(const Value: Double);
begin
  FMax := Value;
end;

procedure TNxCustomNumberColumn.SetMin(const Value: Double);
begin
  FMin := Value;
end;

procedure TNxCustomNumberColumn.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
  Refresh(gaBody);
end;

procedure TNxCustomNumberColumn.SetTextBefore(const Value: WideString);
begin
  FTextBefore := Value;
  Refresh(gaBody);
end;

function TNxCustomNumberColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNumberColumnDisplay;
end;

function TNxCustomNumberColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

function TNxCustomNumberColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := ValidNumberKey(Key, FEditOptions);
end;

function TNxCustomNumberColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  if HideWhenEmpty and (Cell.AsFloat = FEmptyValue) then Result := EmptyCaption else
  begin
    if FormatMask <> ''	then Result := TextBefore + FormatFloat(FormatMask, Cell.AsFloat) + TextAfter
      else Result := TextBefore + FloatToStr(Cell.AsFloat) + TextAfter;
  end;

  { Trigger event }
  if Assigned(OnGetDrawText) then OnGetDrawText(Self, Result);
end;

{ TNxNumberColumn }

procedure TNxNumberColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxNumberColumn then
  begin
    Increment := TNxNumberColumn(Source).Increment;
    SpinButtons := TNxNumberColumn(Source).SpinButtons;
  end;
end;

procedure TNxNumberColumn.BeginEditing;
begin
  inherited;
	with Editor as TNxSpinEdit do
  begin
    ButtonCaption := Self.ButtonCaption;
    Options := Self.EditOptions;
    Increment := Self.Increment;
    Max := Self.Max;
    Min := Self.Min;
    ShowButton := Self.ShowButton;
    SpinButtons := Self.SpinButtons;
    OnButtonClick := DoButtonClick;
  end;
end;

constructor TNxNumberColumn.Create(AOwner: TComponent);
begin
  inherited;
  Alignment := taRightJustify;
  FIncrement := 1;
  FShowButton := False;
  FSpinButtons := True;
end;

procedure TNxNumberColumn.DoButtonClick;
begin
  if Assigned(FOnButtonClick) then FOnButtonClick(Self);
end;

function TNxNumberColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxSpinEdit;
end;

procedure TNxNumberColumn.SetButtonCaption(const Value: WideString);
begin
  FButtonCaption := Value;
end;

procedure TNxNumberColumn.SetIncrement(const Value: Double);
begin
  FIncrement := Value;
end;

procedure TNxNumberColumn.SetPrecision(const Value: Integer);
begin
  FPrecision := Value;
end;

procedure TNxNumberColumn.SetShowButton(const Value: Boolean);
begin
  FShowButton := Value;
end;

procedure TNxNumberColumn.SetSpinButtons(const Value: Boolean);
begin
  FSpinButtons := Value;
end;

procedure TNxNumberColumn.UpdateEdit;
begin
  with Editor as TNxSpinEdit do
  begin
    Precision := Self.Precision;
  end;
end;

{ TNxDateColumn }

procedure TNxDateColumn.BeginEditing;
begin
  inherited;
	with Editor as TNxDatePicker do
  begin
    ShowNoneButton := FShowNoneButton;
    Style := dsDropDown;
    StartDay := FStartDay;
    NoneCaption := FNoneCaption;
    TodayCaption := FTodayCaption;
  end;
end;

constructor TNxDateColumn.Create(AOwner: TComponent);
begin
  inherited;
  FDateSeparator := '/';
  FFormatMask := '';
  FEmptyCaption := '';
  FHideWhenEmpty := False;
  FNoneCaption := strNone;
  FShowNoneButton := True;
  FStartDay := dwSunday;
  FTodayCaption := strToday;
  DefaultValue := DateTimeToStr(Today);
  SetSortType(stDate);
  SetColumnType(ctDate);
end;

function TNxDateColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxDatePicker;
end;

function TNxDateColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TDateColumnDisplay;
end;

function TNxDateColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

function TNxDateColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  if (Cell.AsDateTime = 0) and HideWhenEmpty
    then Result := EmptyCaption else
  begin
   	if FormatMask <> '' then Result := FormatDateTime(FormatMask, Cell.AsDateTime)
      else Result := DateTimeToStr(Cell.AsDateTime);
    Result := TextBefore + Result + TextAfter;
  end;

  { Trigger event }
  if Assigned(OnGetDrawText) then OnGetDrawText(Self, Result);
end;

function TNxDateColumn.IsKeyValid(Key: Char): Boolean;
begin
  {$IFDEF DELPHI20009UP}
  Result := CharInSet(Key, ['1'..'9', '0', DateSeparator]);
  {$ELSE}
  Result := Key in ['1'..'9', '0', DateSeparator];
  {$ENDIF}
end;

procedure TNxDateColumn.SetDateSeparator(const Value: Char);
begin
  FDateSeparator := Value;
  Refresh;
end;

procedure TNxDateColumn.SetEmptyCaption(const Value: WideString);
begin
  FEmptyCaption := Value;
end;

procedure TNxDateColumn.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
  Refresh(gaBody);
end;

procedure TNxDateColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
	Refresh(gaBody);
end;

procedure TNxDateColumn.SetNoneCaption(const Value: WideString);
begin
  FNoneCaption := Value;
end;

procedure TNxDateColumn.SetShowNoneButton(const Value: Boolean);
begin
  FShowNoneButton := Value;
end;

procedure TNxDateColumn.SetTodayCaption(const Value: WideString);
begin
  FTodayCaption := Value;
end;

{ TNxIncrementColumn }

constructor TNxIncrementColumn.Create(AOwner: TComponent);
begin
  inherited;
  SetColumnType(ctAutoInc);
end;

function TNxIncrementColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TIncrementColumnDisplay;
end;

function TNxIncrementColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csFitToLargest, csTextFitHint];
end;

function TNxIncrementColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := IntToStr(Cell.AsInteger + 1);

  { Trigger event }
  if Assigned(OnGetDrawText) then OnGetDrawText(Self, Result);
end;

{ TNxGraphicColumn }

constructor TNxGraphicColumn.Create(AOwner: TComponent);
begin
  inherited;
  FActualSize := False;
  FBorderWidth := 1;
  FMargin := 4;
  FStretch := False;
  DefaultValue := '';
  SetSortType(stAlphabetic);
  SetColumnType(ctGraphic);
end;

function TNxGraphicColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TGraphicColumnDisplay;
end;

procedure TNxGraphicColumn.SetActualSize(const Value: Boolean);
begin
  if Value <> FActualSize then
  begin
    FActualSize := Value;
    Refresh;
  end;
end;

procedure TNxGraphicColumn.SetBorderWidth(const Value: Integer);
begin
  FBorderWidth := Value;
  Refresh;
end;

procedure TNxGraphicColumn.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Refresh;
end;

procedure TNxGraphicColumn.SetStretch(const Value: Boolean);
begin
  FStretch := Value;
  Refresh;
end;

{ TNxPopupColumn }

constructor TNxPopupColumn.Create(AOwner: TComponent);
begin
  inherited;
  with Editor as TNxPopupEdit do
  begin
    OnCloseUp := DoCloseUp;
    OnSelect := DoSelect;
  end;
end;

procedure TNxPopupColumn.DoCloseUp(Sender: TObject);
begin
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TNxPopupColumn.DoSelect(Sender: TObject);
begin
  if Assigned(FOnSelect) then FOnSelect(Self);
end;

{ TNxCalcColumn }

function TNxCalcColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxCalcEdit;
end;

procedure TNxCalcColumn.BeginEditing;
begin
  inherited;
	with Editor as TNxCalcEdit do
  begin
    Max := Self.Max;
    Min := Self.Min;
  end;
end;

{ TNxListColumn }

procedure TNxListColumn.ApplyEditing(var Value: WideString);
var
  ACombo: TNxComboBox;
begin
  if InplaceEdit <> nil then
  begin
    if InplaceEdit is TNxComboBox then
      ACombo := TNxComboBox(InplaceEdit) else Exit;
  end else ACombo := TNxComboBox(Editor);
  Value := IntToStr(ACombo.ItemIndex);
end;

procedure TNxListColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxComboBox do
  begin
    Style := dsDropDownList;
    with Items as TNxStringList do Sorted := FSorted;
  end;
end;

constructor TNxListColumn.Create(AOwner: TComponent);
begin
  inherited;
  FSorted := False;
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctInteger);
end;

function TNxListColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxComboBox;
end;

function TNxListColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  { Bn: Draw blank cell if index is out of range }
  if InRange(Cell.AsInteger, 0, Items.Count - 1) then
  begin
    Result := TextBefore + Items[Cell.AsInteger] + TextAfter;
  end else Result := '';

  { Trigger event }
  if Assigned(OnGetDrawText) then OnGetDrawText(Self, Result);
end;

function TNxListColumn.GetInputDrawText: WideString;
var
  Index: Integer;
begin
  Result := '';
  if InputValue <> '' then
    try
      Index := StrToInt(InputValue);
      if InRange(Index, 0, Items.Count - 1) then Result := FItems[Index];
    except
      Result := '';
    end;
end;

function TNxListColumn.GetInputValue: WideString;
begin
  try
    Result := FItems[StrToInt(InputValue)];
  except
    Result := '';
  end;
end;

function TNxListColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := LocateKey(WideChar(Key), Items) <> -1;
end;

procedure TNxListColumn.UpdateEdit;
begin
  with Editor as TNxComboBox do
  begin
    if Text <> '' then ItemIndex := AsInteger
      else ItemIndex := 0;
  end;
  inherited;
end;

{ TNxMemoColumn }

procedure TNxMemoColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxMemoInplaceEdit do
  begin
    ScrollBars := Self.ScrollBars;
  end;
end;

function TNxMemoColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxMemoInplaceEdit;
end;

function TNxMemoColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TMemoColumnDisplay;
end;

function TNxMemoColumn.GetColumnStyle: TColumnStyle;     
begin
  Result := [csCanEdit, csFitToLargest, csRedrawInplaceEdit, csTextFitHint, csWantReturns];
end;

function TNxMemoColumn.GetDisplayOptions: TDisplayOptions;
begin
  Result := [doMultiLine];
end;

{ TNxTimeColumn }

constructor TNxTimeColumn.Create(AOwner: TComponent);
begin
  inherited;
  FHideWhenEmpty := False;
  SetColumnType(ctDate);
  SetSortType(stDate);
end;

function TNxTimeColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxTimeEdit;
end;

function TNxTimeColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTimeColumnDisplay;
end;

function TNxTimeColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  if (Cell.AsDateTime = 0) and HideWhenEmpty then Result := EmptyCaption else
  begin
   	if FormatMask <> ''	then
    begin
      Result := FormatDateTime(FormatMask, Cell.AsDateTime);
    end else Result := TimeToStr(Cell.AsDateTime);
  end;

  { Trigger event }
  if Assigned(OnGetDrawText) then OnGetDrawText(Self, Result);
end;

procedure TNxTimeColumn.SetEmptyCaption(const Value: WideString);
begin
  FEmptyCaption := Value;
  Refresh(gaBody);
end;

procedure TNxTimeColumn.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
  Refresh(gaBody);
end;

procedure TNxTimeColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
  Refresh(gaBody);
end;

procedure TNxTimeColumn.UpdateEdit;
var
  Output: string;
begin
 	if FormatMask <> ''	then
  begin
    Output := FormatDateTime(FormatMask, Editor.AsDateTime);
  end else Output := TimeToStr(Editor.AsDateTime);
  Editor.AsString := Output;
end;

{ TNxHyperlinkColumn }

procedure TNxHyperlinkColumn.AddInvalidatedHyperlink(AHyperlink: WideString);
var
  iIndex : Integer;
begin
  FInvalidatedHyperlinks.Add(AHyperlink);
  iIndex := FVisitedHyperlinks.IndexOf(AHyperlink);
  if (iIndex <> -1) then
    FVisitedHyperlinks.Delete(iIndex);
end;

procedure TNxHyperlinkColumn.AddVisitedHyperlink(AHyperlink: WideString);
var
  iIndex : Integer;
begin
  FVisitedHyperlinks.Add(AHyperlink);
  iIndex := FInvalidatedHyperlinks.IndexOf(AHyperlink);
  if (iIndex <> -1) then
    FInvalidatedHyperlinks.Delete(iIndex);
end;

procedure TNxHyperlinkColumn.ClearInvalidatedHyperlinks;
begin
  FInvalidatedHyperlinks.Clear;
end;

procedure TNxHyperlinkColumn.ClearVisitedHyperlinks;
begin
  FVisitedHyperlinks.Clear;
end;

constructor TNxHyperlinkColumn.Create(AOwner: TComponent);
begin
  inherited;
  SetSortType(stAlphabetic);
  SetColumnType(ctString);
  Options := [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint];
  { Font }
  Font.Color := clDefaultHyperlink;
  Font.Style := [fsUnderline];
  { Colors }
  FInvalidatedLinkColor := clDefaultInvalidatedHyperlink;
  FVisitedLinkColor := clDefaultVisitedHyperlink;
  { Invalidated Hyperlinks }
  FInvalidatedHyperlinks := TNxStringList.Create;
  FInvalidatedHyperlinks.Sorted := True;
  FInvalidatedHyperlinks.Duplicates := dupIgnore;
  { Visited Hyperlinks }
  FVisitedHyperlinks := TNxStringList.Create;
  FVisitedHyperlinks.Sorted := True;
  FVisitedHyperlinks.Duplicates := dupIgnore;
end;

destructor TNxHyperlinkColumn.Destroy;
begin
  FreeAndNil(FInvalidatedHyperlinks);
  FreeAndNil(FVisitedHyperlinks);
  inherited;
end;

function TNxHyperlinkColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := nil;
end;

function TNxHyperlinkColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := THyperlinkColumnDisplay;
end;

function TNxHyperlinkColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := THyperlinkColumnPlay;
end;

function TNxHyperlinkColumn.HyperlinkHasBeenInvalidated(
  AHyperlink: WideString): Boolean;
begin
  Result := FInvalidatedHyperlinks.IndexOf(AHyperlink) <> -1;
end;

function TNxHyperlinkColumn.HyperlinkHasBeenVisited(AHyperlink: WideString): Boolean;
begin
  Result := FVisitedHyperlinks.IndexOf(AHyperlink) <> -1;
end;

procedure TNxHyperlinkColumn.LoadInvalidatedHyperlinksFromFile(AFileName: WideString);
begin
  FInvalidatedHyperlinks.LoadFromFile(AFileName);
end;

procedure TNxHyperlinkColumn.LoadInvalidatedHyperlinksFromStream(AStream: TStream);
begin
  FInvalidatedHyperlinks.LoadFromStream(AStream);
end;

procedure TNxHyperlinkColumn.LoadVisitedHyperlinksFromFile(AFileName: WideString);
begin
  FVisitedHyperlinks.LoadFromFile(AFileName);
end;

procedure TNxHyperlinkColumn.LoadVisitedHyperlinksFromStream(AStream: TStream);
begin
  FVisitedHyperlinks.LoadFromStream(AStream);
end;

procedure TNxHyperlinkColumn.RemoveInvalidatedHyperlink(AHyperlink: WideString);
var
  iIndex : Integer;
begin
  iIndex := FInvalidatedHyperlinks.IndexOf(AHyperlink);
  if (iIndex <> -1) then
    FInvalidatedHyperlinks.Delete(iIndex);
end;

procedure TNxHyperlinkColumn.RemoveVisitedHyperlink(AHyperlink: WideString);
var
  iIndex : Integer;
begin
  iIndex := FVisitedHyperlinks.IndexOf(AHyperlink);
  if (iIndex <> -1) then
    FVisitedHyperlinks.Delete(iIndex);
end;

procedure TNxHyperlinkColumn.SaveInvalidatedHyperlinksToFile(AFileName: WideString);
begin
  FInvalidatedHyperlinks.SaveToFile(AFileName);
end;

procedure TNxHyperlinkColumn.SaveInvalidatedHyperlinksToStream(AStream: TStream);
begin
  FInvalidatedHyperlinks.SaveToStream(AStream);
end;

procedure TNxHyperlinkColumn.SaveVisitedHyperlinksToFile(AFileName: WideString);
begin
  FVisitedHyperlinks.SaveToFile(AFileName);
end;

procedure TNxHyperlinkColumn.SaveVisitedHyperlinksToStream(AStream: TStream);
begin
  FVisitedHyperlinks.SaveToStream(AStream);
end;

{ TNxColorColumn }

constructor TNxColorColumn.Create(AOwner: TComponent);
begin
  inherited;
  FFullSize := False;
end;

function TNxColorColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxColorPicker;
end;

function TNxColorColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxColorColumnDisplay;
end;

procedure TNxColorColumn.SetFullSize(const Value: Boolean);
begin
  FFullSize := Value;
end;

end.
