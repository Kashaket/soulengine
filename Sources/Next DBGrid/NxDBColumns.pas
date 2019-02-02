{
  Next DBGrid
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:DBColumns.pas bn
}

{$I '..\NxSuite.inc'}

unit NxDBColumns;

interface

uses
	Classes, DB, Graphics, NxColumns, Types, Variants,
  NxClasses, NxDisplays, NxDBDisplays, NxColumnClasses, NxVirtualColumn,
  Math, NxEdit, ImgList, Controls, StdCtrls;

type
  TNxDBCustomColumn = class;
  TNxDBColumnClass = class of TNxDBCustomColumn;
  TColumnDataAwareOptions = set of (daAutoAssign, daAutoDelete, daLinkField);

  TNxDBCustomColumn = class(TNxCustomColumn)
  private
    FField: TField;
    FFieldName: string;
    FDataAwareOptions: TColumnDataAwareOptions;
    FNullText: WideString;
    procedure SetField(const Value: TField);
    procedure SetFieldName(const Value: string);
    procedure SetDataAwareOptions(const Value: TColumnDataAwareOptions);
    procedure SetNullText(const Value: WideString);
    function GetIsFieldNull: Boolean;
  protected
    function GetColumnState: TColumnState; override;
    function GetIsFieldEditable: Boolean; virtual;
    procedure FieldUpdate(AField: TField); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyField(Value: WideString); virtual;
    procedure Assign(Source: TPersistent); override;
    property Field: TField read FField write SetField;
    property IsFieldEditable: Boolean read GetIsFieldEditable;
    property IsFieldNull: Boolean read GetIsFieldNull;
  published
    property FieldName: string read FFieldName write SetFieldName;
    property DataAwareOptions: TColumnDataAwareOptions read FDataAwareOptions write SetDataAwareOptions default [daAutoAssign];
    property NullText: WideString read FNullText write SetNullText;
  end;

{$WARNINGS OFF}
  TNxDBColumns = class(TNxColumns)
  protected
    function GetItem(Index: Integer): TNxDBCustomColumn; reintroduce;
  public
    function Add(ColumnClass: TNxColumnClass; AutoDelete: Boolean = False): TNxDBCustomColumn; overload;
    procedure AddColumn(AColumn: TNxDBCustomColumn; AutoDelete: Boolean); overload;
    function ColumnByField(AField: TField): TNxDBCustomColumn;
    property Item[Index: Integer]: TNxDBCustomColumn read GetItem; default;
  end;
{$WARNINGS ON}

	TNxDBTextColumn = class(TNxDBCustomColumn)
  private
    FAutoExecute: Boolean;
    FMaxLength: Integer;
    FMultiLine: Boolean;
    FTextAfter: WideString;
    FTextBefore: WideString;
    FPasswordChar: TChar;
    procedure SetAutoExecute(const Value: Boolean);
    procedure SetMaxLength(const Value: Integer);
    procedure SetMultiLine(const Value: Boolean);
    procedure SetTextAfter(const Value: WideString);
    procedure SetTextBefore(const Value: WideString);
    procedure SetPasswordChar(const Value: TChar);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    function IsKeyValid(Key: Char): Boolean; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
  published
    property AutoExecute: Boolean read FAutoExecute write SetAutoExecute default False;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property MultiLine: Boolean read FMultiLine write SetMultiLine default False;
    property PasswordChar: TChar read FPasswordChar write SetPasswordChar default #0;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
    property TextBefore: WideString read FTextBefore write SetTextBefore;
  end;

  TNxDBButtonColumn = class(TNxDBTextColumn)
  private
    FShowButton: Boolean;
    FButtonCaption: WideString;
    FGlyph: TBitmap;
    FOnButtonClick: TNotifyEvent;
    FButtonWidth: Integer;
    procedure SetButtonCaption(const Value: WideString);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetButtonWidth(const Value: Integer);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnState: TColumnState; override;
    function GetColumnStyle: TColumnStyle; override;
    procedure DoButtonClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
  published
    property ShowButton: Boolean read FShowButton write FShowButton default True;
    property ButtonCaption: WideString read FButtonCaption write SetButtonCaption;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 21;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

  TBlobType = (btDefault, btOleObject);
  
  TNxDBGraphicColumn = class(TNxDBCustomColumn)
  private
    FActualSize: Boolean;
    FBlobType: TBlobType;
    FBorderWidth: Integer;
    FMargin: Integer;
    FStrecht: Boolean;
    procedure SetActualSize(const Value: Boolean);
    procedure SetMargin(const Value: Integer);
    procedure SetStrecht(const Value: Boolean);
    procedure SetBorderWidth(const Value: Integer);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ActualSize: Boolean read FActualSize write SetActualSize default False;
    property BlobType: TBlobType read FBlobType write FBlobType default btDefault;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property Margin: Integer read FMargin write SetMargin;
    property Strecht: Boolean read FStrecht write SetStrecht default False;
  end;

  TNxDBPopupColumn = class(TNxDBTextColumn)
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

  TNxDBProgressColumn = class(TNxDBCustomColumn)
  private
    FBorderColor: TColor;
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
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  published
    property BorderColor: TColor read FBorderColor write SetBorderColor;
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

	TNxDBStringsColumn = class(TNxDBPopupColumn)
  private
    FDisplayMode: TDisplayMode;
    FDropDownCount: Integer;
    FImages: TCustomImageList;
    FItems: TNxStrings;
    FShowImages: Boolean;
    FListWidth: Integer;
    FAutoDropDown: Boolean;
    procedure SetDisplayMode(const Value: TDisplayMode);
    procedure SetDropDownCount(const Value: Integer);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetItems(const Value: TNxStrings);
    procedure SetListWidth(const Value: Integer);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
	public
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  	function GetCellEditorClass: TCellEditorClass; override;
    procedure UpdateEdit; override;
  published
    property AutoDropDown: Boolean read FAutoDropDown write FAutoDropDown default False;
    property DisplayMode: TDisplayMode read FDisplayMode write SetDisplayMode default dmTextOnly;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TNxStrings read FItems write SetItems;
    property ListWidth: Integer read FListWidth write SetListWidth default 0;
  end;

  TNxDBComboBoxColumn = class(TNxDBStringsColumn)
  private
    FStyle: TCompoBoxStyle;
    FItemsMode: TItemsDisplayMode;
    procedure SetStyle(const Value: TCompoBoxStyle);
    procedure SetItemsMode(const Value: TItemsDisplayMode);
	public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyField(Value: WideString); override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
    function NameOfValue(S: WideString): WideString;
    procedure UpdateEdit; override;
    function ValueOfName(S: WideString): WideString;
	published
    property ItemsMode: TItemsDisplayMode read FItemsMode write SetItemsMode default dmDefault;
    property Style: TCompoBoxStyle read FStyle write SetStyle default cbsDropDown;
  end;

  TNxDBListColumn = class(TNxDBStringsColumn)
	public
    procedure ApplyEditing(var Value: WideString); override;
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function GetInputDrawText: WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
    procedure UpdateEdit; override;
  end;

  TNxLookupColumn = class;

  TLookupDataLink = class(TDataLink)
  private
    FColumn: TNxLookupColumn;
  protected
  	procedure ActiveChanged; override;
    procedure UpdateData; override;
  end;

	TNxLookupColumn = class(TNxDBComboBoxColumn)
  private
    FDataLink: TLookupDataLink;
    FKeyFieldName: string;
    FListDataSource: TDataSource;
    FListFieldName: string;
    FUpdating: Boolean;
    procedure SetListDataSource(const Value: TDataSource);
    procedure SetListFieldName(const Value: string);
    procedure SetKeyFieldName(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyField(Value: WideString); override;
    procedure LoadItems; virtual;
  published
    property KeyFieldName: string read FKeyFieldName write SetKeyFieldName;
    property ListDataSource: TDataSource read FListDataSource write SetListDataSource;
    property ListFieldName: string read FListFieldName write SetListFieldName;
  end;

	TNxDBCustomNumberColumn = class(TNxDBCustomColumn)
  private
    FEditOptions: TNxNumberEditOptions;
    FEmptyCaption: WideString;
    FFormatMask: string;
    FHideWhenEmpty: Boolean;
    FMax: Double;
    FMin: Double;
    FPrecision: Integer;
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
    procedure SetPrecision(const Value: Integer);
    procedure SetEmptyValue(const Value: Double);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    function IsKeyValid(Key: Char): Boolean; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    procedure Assign(Source: TPersistent); override;
    procedure FieldUpdate(AField: TField); override;
  published
    property EditOptions: TNxNumberEditOptions read FEditOptions write FEditOptions default [eoAllowFloat];
    property EmptyCaption: WideString read FEmptyCaption write SetEmptyCaption;
    property EmptyValue: Double read FEmptyValue write SetEmptyValue;
    property FormatMask: string read FFormatMask write SetFormatMask;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty default False;
    property Max: Double read FMax write SetMax;
    property Min: Double read FMin write SetMin;
    property Precision: Integer read FPrecision write SetPrecision;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
    property TextBefore: WideString read FTextBefore write SetTextBefore;
  end;

	TNxDBNumberColumn = class(TNxDBCustomNumberColumn)
  private
    FIncrement: Double;
    FSpinButtons: Boolean;
    FPasswordChar: TChar;
    procedure SetIncrement(const Value: Double);
    procedure SetSpinButtons(const Value: Boolean);
    procedure SetPasswordChar(const Value: TChar);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
	public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginEditing; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    procedure UpdateEdit; override;
	published
    property Alignment default taRightJustify;
    property Increment: Double read FIncrement write SetIncrement;
    property PasswordChar: TChar read FPasswordChar write SetPasswordChar default #0;
    property SpinButtons: Boolean read FSpinButtons write SetSpinButtons default True;
  end;

  TNxDBCalcColumn = class(TNxDBCustomNumberColumn)
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
  public
    procedure BeginEditing; override;
  end;

	TNxDBCheckBoxColumn = class(TNxDBCustomColumn)
  private
    FValueChecked: WideString;
    FValueUnchecked: WideString;
    procedure SetValueChecked(const Value: WideString);
    procedure SetValueUnchecked(const Value: WideString);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnPlayClass: TColumnPlayClass; override;
    function GetColumnStyle: TColumnStyle; override;
    procedure FieldUpdate(AField: TField); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    procedure ApplyField(Value: WideString); override;
  published
    property ValueChecked: WideString read FValueChecked write SetValueChecked;
    property ValueUnchecked: WideString read FValueUnchecked write SetValueUnchecked;
  end;

	TNxDBDateColumn = class(TNxDBPopupColumn)
  private
    FFormatDateMask: String;
    FHideWhenEmpty: Boolean;
    FEmptyCaption: WideString;
    FStartDay: TStartDayOfWeek;
    FShowNoneButton: Boolean;
    FTodayCaption: WideString;
    FNoneCaption: WideString;
    procedure SetFormatDateMask(const Value: string);
    procedure SetHideWhenEmpty(const Value: Boolean);
    procedure SetEmptyCaption(const Value: WideString);
    procedure SetShowNoneButton(const Value: Boolean);
    procedure SetNoneCaption(const Value: WideString);
    procedure SetTodayCaption(const Value: WideString);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
	public
    procedure BeginEditing; override;
    constructor Create(AOwner: TComponent); override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
  published
    property EmptyCaption: WideString read FEmptyCaption write SetEmptyCaption;
    property FormatDateMask: String read FFormatDateMask write SetFormatDateMask;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty;
    property NoneCaption: WideString read FNoneCaption write SetNoneCaption;
    property ShowNoneButton: Boolean read FShowNoneButton write SetShowNoneButton default True;
    property StartDay: TStartDayOfWeek read FStartDay write FStartDay default dwSunday;
    property TodayCaption: WideString read FTodayCaption write SetTodayCaption;
  end;

  TNxDBRateColumn = class(TNxDBCustomColumn)
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
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetColumnStyle: TColumnStyle; override;
  published
    property EmptyGlyph: TBitmap read FEmptyGlyph write SetEmptyGlyph;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty;
    property Max: Integer read FMax write SetMax;
    property Transparent: Boolean read FTransparent write SetTransparent;
  end;

  TNxDBImageColumn = class(TNxDBCustomColumn)
  private
    FImages: TImageList;
    FTransparent: Boolean;
    procedure SetImages(const Value: TImageList);
    procedure SetTransparent(const Value: Boolean);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    function GetColumnStyle: TColumnStyle; override;
  published
    property Images: TImageList read FImages write SetImages;
    property Transparent: Boolean read FTransparent write SetTransparent;
  end;

  TNxDBIncrementColumn = class(TNxDBCustomColumn)
  private
    FTextAfter: WideString;
    FOffset: Integer;
    procedure SetTextAfter(const Value: WideString);
    procedure SetOffset(const Value: Integer);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetColumnStyle: TColumnStyle; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
  published
    property Offset: Integer read FOffset write SetOffset default 1;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
  end;

	TNxDBHtmlColumn = class(TNxDBCustomColumn)
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

  TNxDBMemoColumn = class(TNxDBButtonColumn)
  private
    FScrollBars: TScrollStyle;
    FMemoDisplayOptions: TMemoDisplayOptions;
    procedure SetMemoDisplayOptions(const Value: TMemoDisplayOptions);
  protected
  	function GetCellEditorClass: TCellEditorClass; override;
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginEditing; override;
    function GetDisplayOptions: TDisplayOptions; override;
  published
    property MemoDisplayOptions: TMemoDisplayOptions read FMemoDisplayOptions write SetMemoDisplayOptions default mdDefault;
    property ScrollBars: TScrollStyle read FScrollBars write FScrollBars default ssNone;
  end;

  TNxDBTimeColumn = class(TNxDBTextColumn)
  private
    FEmptyCaption: WideString;
    FFormatMask: string;
    FHideWhenEmpty: Boolean;
    procedure SetEmptyCaption(const Value: WideString);
    procedure SetFormatMask(const Value: string);
    procedure SetHideWhenEmpty(const Value: Boolean);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
  published
    property EmptyCaption: WideString read FEmptyCaption write SetEmptyCaption;
    property FormatMask: string read FFormatMask write SetFormatMask;
    property HideWhenEmpty: Boolean read FHideWhenEmpty write SetHideWhenEmpty default False;
  end;

implementation

uses NxDBGrid, NxGridCommon, SysUtils, DateUtils, Dialogs, Forms, StrUtils;

{ TNxDBColumns }

function TNxDBColumns.Add(ColumnClass: TNxColumnClass; AutoDelete: Boolean): TNxDBCustomColumn;
begin
  Result := Add(ColumnClass, '') as TNxDBCustomColumn;
  if AutoDelete then Include(Result.FDataAwareOptions, daAutoDelete);
end;

procedure TNxDBColumns.AddColumn(AColumn: TNxDBCustomColumn;
  AutoDelete: Boolean);
begin
  if AutoDelete then Include(AColumn.FDataAwareOptions, daAutoDelete);
  AddColumn(AColumn);
end;

function TNxDBColumns.ColumnByField(AField: TField): TNxDBCustomColumn;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Item[i].Field = AField then
    begin
      Result := Item[i];
      Exit;
    end;
  end;
end;

function TNxDBColumns.GetItem(Index: Integer): TNxDBCustomColumn;
begin
  Result := TNxDBCustomColumn(inherited GetItem(Index));
end;

{ TNxDBCustomColumn }

procedure TNxDBCustomColumn.ApplyField(Value: WideString);
begin
  if Value = '' then
  begin
    FField.Clear;
    Exit;
  end;
  case FField.DataType of
    ftWideString: TWideStringField(FField).Value := Value; { WideString }
    else FField.Text := Value;
  end;
end;

procedure TNxDBCustomColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBCustomColumn then
  begin
    FieldName := TNxDBCustomColumn(Source).FieldName;
  end;
end;

constructor TNxDBCustomColumn.Create(AOwner: TComponent);
begin
  inherited;
  FField := nil;
  FDataAwareOptions := [daAutoAssign];
end;

function TNxDBCustomColumn.GetIsFieldEditable: Boolean;
begin
  { some field can't be edited in grid }            
  Result := (Field <> nil) and Field.CanModify and not Field.IsBlob;
end;

function TNxDBCustomColumn.GetIsFieldNull: Boolean;
begin
  Result := not Assigned(Field) or Field.IsNull;
end;

procedure TNxDBCustomColumn.SetField(const Value: TField);
begin
  if FField = Value then Exit;

  if Assigned(FField) and (Value = nil) then
    FField.RemoveFreeNotification(Columns.Owner);

  FField := Value;
  if FField <> nil then
  begin
    FFieldName := Value.FieldName;
    FieldUpdate(FField);
    FField.FreeNotification(Columns.Owner);
  end;
  Refresh;
end;

procedure TNxDBCustomColumn.SetFieldName(const Value: string);
var
  DataField: TField;
  DataGrid: TNextDBGrid;
begin
  DataField := nil;
  FFieldName := Value;
  if Assigned(Columns) then
  begin
    DataGrid := TNextDBGrid(Columns.Owner);
    if Assigned(DataGrid) and Assigned(DataGrid.DataLink.DataSet) and
      not (csLoading in DataGrid.ComponentState) and (Length(FFieldName) > 0) then
    begin
      DataField := DataGrid.DataLink.DataSet.FindField(FFieldName); { no exceptions }
    end;
    SetField(DataField);
  end;
end;

procedure TNxDBCustomColumn.SetDataAwareOptions(const Value: TColumnDataAwareOptions);
begin
  FDataAwareOptions := Value;
  if (daLinkField in DataAwareOptions) then FieldUpdate(FField);
end;

function TNxDBCustomColumn.GetColumnState: TColumnState;
begin
  Result := [];
  if Enabled and IsFieldEditable and ((csCanEdit in ColumnStyle) or (InplaceEdit <> nil)) then
  begin
    if coEditing in Options then Include(Result, ceEditable);
    if coCanInput in Options then Include(Result, ceCanInput);
  end;
end;

procedure TNxDBCustomColumn.FieldUpdate(AField: TField);
begin
  if AField <> nil then
  begin
    if Header.Caption = '' then Header.Caption := AField.DisplayLabel;
    if daLinkField in DataAwareOptions then
    begin
      Alignment := AField.Alignment;
      Visible := AField.Visible;
    end;
  end;
end;

procedure TNxDBCustomColumn.SetNullText(const Value: WideString);
begin
  FNullText := Value;
  Refresh(gaBody);
end;

{ TLookupDataLink }

procedure TLookupDataLink.ActiveChanged;
begin
  if Assigned(DataSet) then
  begin
    if DataSet.Active then FColumn.LoadItems else FColumn.Items.Clear;
    FColumn.Refresh;
  end;
end;

procedure TLookupDataLink.UpdateData;
begin
  inherited;
  if Assigned(DataSet) then
  begin
    if DataSet.Active then FColumn.LoadItems;
    FColumn.Refresh;
  end;
end;

{ TNxLookupColumn }

constructor TNxLookupColumn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TLookupDataLink.Create;
  FDataLink.FColumn := Self;
  SetColumnType(ctLookup);
end;

procedure TNxLookupColumn.ApplyField(Value: WideString);
begin
  Field.Value := ListDataSource.DataSet.Lookup(ListFieldName, Value, KeyFieldName);
end;

destructor TNxLookupColumn.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;

procedure TNxLookupColumn.LoadItems;
begin
  if not FUpdating then
  begin
    FUpdating := True; { prevent stack overload }
    if Assigned(ListDataSource)
      and Assigned(ListDataSource.DataSet)
      and ListDataSource.DataSet.Active
      and (ListFieldName <> '') then
    begin
      FListDataSource.DataSet.DisableControls;
      ListDataSource.DataSet.First;
      Items.Clear;
      repeat
        Items.Add(ListDataSource.DataSet.FieldByName(ListFieldName).AsString);
        ListDataSource.DataSet.Next;
      until ListDataSource.DataSet.Eof;
      FListDataSource.DataSet.EnableControls;
    end;
    FUpdating := False;
  end;
end;

procedure TNxLookupColumn.SetKeyFieldName(const Value: string);
begin
  FKeyFieldName := Value;
  LoadItems;
  Refresh;
end;

procedure TNxLookupColumn.SetListDataSource(const Value: TDataSource);
begin
  FListDataSource := Value;
  FDataLink.DataSource := Value;
  if FDataLink.Active then FDataLink.ActiveChanged;
  Refresh;
end;

procedure TNxLookupColumn.SetListFieldName(const Value: string);
begin
  FListFieldName := Value;
  LoadItems;
  Refresh;
end;

{ TNxDBCheckBoxColumn }

constructor TNxDBCheckBoxColumn.Create(AOwner: TComponent);
begin
  inherited;
  DefaultValue := '';
  FValueChecked := '';
  FValueUnchecked := '';
  SetSortType(stBoolean);
  SetColumnType(ctBoolean);
end;

procedure TNxDBCheckBoxColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBCheckBoxColumn then
  begin
    ValueChecked := TNxDBCheckBoxColumn(Source).ValueChecked;
    ValueUnchecked := TNxDBCheckBoxColumn(Source).ValueUnchecked;
  end;
end;

function TNxDBCheckBoxColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxDBCheckBoxColumnDisplay;
end;

function TNxDBCheckBoxColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := TCheckBoxColumnPlay;
end;

procedure TNxDBCheckBoxColumn.SetValueChecked(const Value: WideString);
begin
  FValueChecked := Value;
  Refresh;
end;

procedure TNxDBCheckBoxColumn.SetValueUnchecked(const Value: WideString);
begin
  FValueUnchecked := Value;
  Refresh;
end;

procedure TNxDBCheckBoxColumn.ApplyField(Value: WideString);
var
  B: Boolean;
begin
  B := StrToBoolDef(Value, False);
  case B of
    True: if FField.DataType = ftBoolean then
            FField.AsBoolean := True else FField.Text := ValueChecked;

    False: if FField.DataType = ftBoolean then
             FField.AsBoolean := False else FField.Text := ValueUnchecked;
  end;
end;

procedure TNxDBCheckBoxColumn.FieldUpdate(AField: TField);
begin
  inherited;
  if (FField <> nil) and (FField.DataType = ftBoolean)
    and (daLinkField in DataAwareOptions) then
  begin
    ValueChecked := 'True';
    ValueUnchecked := 'False';
  end;
end;

function TNxDBCheckBoxColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest];
end;

{ TNxDBIncrementColumn }

constructor TNxDBIncrementColumn.Create(AOwner: TComponent);
begin
  inherited;
  FOffset := 1;
  FTextAfter := '';
  SetColumnType(ctAutoInc);
end;

function TNxDBIncrementColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TIncrementColumnDisplay;
end;

function TNxDBIncrementColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csDisableSorting, csTextFitHint, csFitToLargest]; 
end;

function TNxDBIncrementColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := IntToStr(Cell.AsInteger + FOffset) + TextAfter;
end;

procedure TNxDBIncrementColumn.SetOffset(const Value: Integer);
begin
  if Value <> FOffset then
  begin
    FOffset := Value;
    Refresh(gaBody);
  end;
end;

procedure TNxDBIncrementColumn.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
  Refresh(gaBody);
end;

{ TNxDBCustomNumberColumn }

constructor TNxDBCustomNumberColumn.Create(AOwner: TComponent);
begin
  inherited;
  FEditOptions := [eoAllowFloat];
  FEmptyValue := 0;
  FFormatMask := '';
  FMax := 0;
  FMin := 0;
  FTextAfter := '';
  FTextBefore := '';
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctFloat);
end;

procedure TNxDBCustomNumberColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBCustomNumberColumn then
  begin
    EditOptions := TNxDBCustomNumberColumn(Source).EditOptions;
    EmptyCaption := TNxDBCustomNumberColumn(Source).EmptyCaption;
    EmptyValue := TNxDBCustomNumberColumn(Source).EmptyValue;
    FormatMask := TNxDBCustomNumberColumn(Source).FormatMask;
    HideWhenEmpty := TNxDBCustomNumberColumn(Source).HideWhenEmpty;
    Max := TNxDBCustomNumberColumn(Source).Max;
    Min := TNxDBCustomNumberColumn(Source).Min;
    Precision := TNxDBCustomNumberColumn(Source).Precision;
    TextAfter := TNxDBCustomNumberColumn(Source).TextAfter;
    TextBefore := TNxDBCustomNumberColumn(Source).TextBefore;
  end;
end;

function TNxDBCustomNumberColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNumberColumnDisplay;
end;

function TNxDBCustomNumberColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := ValidNumberKey(Key, FEditOptions);
end;

function TNxDBCustomNumberColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  if IsFieldNull then Result := inherited GetDrawText(Cell) else
    if HideWhenEmpty and (Cell.AsFloat = FEmptyValue) then Result := EmptyCaption else
    begin
      if Length(FormatMask) > 0
        then Result := TextBefore + FormatFloat(FormatMask, Cell.AsFloat) + TextAfter
        else Result := TextBefore + FloatToStr(Cell.AsFloat) + TextAfter;
    end;
end;

procedure TNxDBCustomNumberColumn.SetEmptyCaption(const Value: WideString);
begin
  FEmptyCaption := Value;
  Refresh;
end;

procedure TNxDBCustomNumberColumn.SetEmptyValue(const Value: Double);
begin
  FEmptyValue := Value;
  Refresh(gaBody);
end;

procedure TNxDBCustomNumberColumn.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
  Refresh;
end;

procedure TNxDBCustomNumberColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
  Refresh;
end;

procedure TNxDBCustomNumberColumn.SetMax(const Value: Double);
begin
  FMax := Value;
end;

procedure TNxDBCustomNumberColumn.SetMin(const Value: Double);
begin
  FMin := Value;
end;

procedure TNxDBCustomNumberColumn.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
  Refresh;
end;

procedure TNxDBCustomNumberColumn.SetTextBefore(const Value: WideString);
begin
  FTextBefore := Value;
  Refresh;
end;

procedure TNxDBCustomNumberColumn.SetPrecision(const Value: Integer);
begin
  FPrecision := Value;
end;

procedure TNxDBCustomNumberColumn.FieldUpdate(AField: TField);
begin
  inherited;
  if (AField <> nil) and (AField is TFloatField)
    and (daLinkField in DataAwareOptions) then
  begin
    FMax := TFloatField(AField).MaxValue;
    FMin := TFloatField(AField).MinValue;
    FPrecision := TFloatField(AField).Precision;
  end;
end;

function TNxDBCustomNumberColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

{ TNxDBTextColumn }

procedure TNxDBTextColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBTextColumn then
  begin
    FAutoExecute := TNxDBTextColumn(Source).AutoExecute;
    FMaxLength := TNxDBTextColumn(Source).MaxLength;
    FMultiLine := TNxDBTextColumn(Source).MultiLine;
    FTextAfter := TNxDBTextColumn(Source).TextAfter;
    FTextBefore := TNxDBTextColumn(Source).TextBefore;
  end;
end;

procedure TNxDBTextColumn.BeginEditing;
begin
  inherited;
  with Editor do
  begin
    InplaceEditor := True;
    MaxLength := FMaxLength;
    PasswordChar := FPasswordChar;
  end;
end;

constructor TNxDBTextColumn.Create(AOwner: TComponent);
begin
  inherited;
  DefaultValue := '';
  FAutoExecute := False;
  FMaxLength := 0;
  FMultiLine := False;
  FPasswordChar := #0;
  FTextAfter := '';
  FTextBefore := '';
  Options := Options + [coShowTextFitHint];
end;

function TNxDBTextColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxEdit;
end;

function TNxDBTextColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTextColumnDisplay;
end;

function TNxDBTextColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

function TNxDBTextColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := FTextBefore + inherited GetDrawText(Cell) + FTextAfter;
  if PasswordChar <> #0 then Result := StringOfChar(PasswordChar, Length(Result));
end;

function TNxDBTextColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := Ord(Key) > 32;
end;

procedure TNxDBTextColumn.SetAutoExecute(const Value: Boolean);
begin
  FAutoExecute := Value;
end;

procedure TNxDBTextColumn.SetMaxLength(const Value: Integer);
begin
  FMaxLength := Value;
  Refresh(gaBody);
end;

procedure TNxDBTextColumn.SetMultiLine(const Value: Boolean);
begin
  FMultiLine := Value;
  Refresh(gaBody);
end;

procedure TNxDBTextColumn.SetPasswordChar(const Value: TChar);
begin
  FPasswordChar := Value;
  Refresh(gaBody);
end;

procedure TNxDBTextColumn.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
  Refresh(gaBody);
end;

procedure TNxDBTextColumn.SetTextBefore(const Value: WideString);
begin
  FTextBefore := Value;
  Refresh(gaBody);
end;

{ TNxDBStringsColumn }

constructor TNxDBStringsColumn.Create(AOwner: TComponent);
begin
  inherited;
  DefaultValue := '';
  FAutoDropDown := False;
  FDisplayMode := dmTextOnly;
  FDropDownCount := 8;
  FImages := nil;
  FItems := TNxStringList.Create;
  FListWidth := 0;
  FShowImages := False;
end;

destructor TNxDBStringsColumn.Destroy;
begin
  FItems.Free;
  FItems := nil;
  inherited;
end;

procedure TNxDBStringsColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBStringsColumn then
  begin
    DisplayMode := TNxDBStringsColumn(Source).DisplayMode;
    DropDownCount := TNxDBStringsColumn(Source).DropDownCount;
    Items.Assign(TNxDBStringsColumn(Source).Items);
  end;
end;

procedure TNxDBStringsColumn.SetDropDownCount(const Value: Integer);
begin
  FDropDownCount := Value;
end;

procedure TNxDBStringsColumn.SetItems(const Value: TNxStrings);
begin
  FItems.Assign(Value);
end;

function TNxDBStringsColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxComboBox;
end;

procedure TNxDBStringsColumn.SetDisplayMode(const Value: TDisplayMode);
begin
  FDisplayMode := Value;
  Refresh(gaBody);
end;

procedure TNxDBStringsColumn.SetImages(const Value: TCustomImageList);
begin
  FImages := Value;
  Refresh(gaBody);
end;

procedure TNxDBStringsColumn.BeginEditing;
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

function TNxDBStringsColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxDBStringsColumnDisplay;
end;

procedure TNxDBStringsColumn.UpdateEdit;
begin
  with Editor as TNxComboBox do
  begin
    ItemIndex := Items.IndexOf(AsString);
  end;
end;

procedure TNxDBStringsColumn.SetListWidth(const Value: Integer);
begin
  FListWidth := Value;
end;

{ TNxDBDateColumn }

procedure TNxDBDateColumn.BeginEditing;
begin
  inherited;
	with Editor as TNxDatePicker do
  begin
    NoneCaption := FNoneCaption;
    ShowNoneButton := FShowNoneButton;
    Style := dsDropDown;
    StartDay := FStartDay;
    TodayCaption := FTodayCaption;
  end;
end;

constructor TNxDBDateColumn.Create(AOwner: TComponent);
begin
  inherited;
  DefaultValue := DateTimeToStr(Today);
  FNoneCaption := strNone;
  FShowNoneButton := True;
  FStartDay := dwSunday;
  FTodayCaption := strToday;
  SetSortType(stDate);
  SetColumnType(ctDate);
end;

function TNxDBDateColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxDatePicker;
end;

function TNxDBDateColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TDateColumnDisplay;
end;

function TNxDBDateColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

function TNxDBDateColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  if IsFieldNull then Result := inherited GetDrawText(Cell)
    else if (Cell.AsDateTime = 0) and HideWhenEmpty then Result := EmptyCaption else
      begin
        if FormatDateMask <> '' then Result := FormatDateTime(FormatDateMask, Cell.AsDateTime)
          else Result := DateTimeToStr(Cell.AsDateTime);
        Result := TextBefore + Result + TextAfter;
      end;
end;

function TNxDBDateColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := Key in ['1'..'9', '0', LocalSettings.DateSeparator];
end;

procedure TNxDBDateColumn.SetEmptyCaption(const Value: WideString);
begin
  FEmptyCaption := Value;
end;

procedure TNxDBDateColumn.SetFormatDateMask(const Value: string);
begin
  FFormatDateMask := Value;
  Refresh;
end;

procedure TNxDBDateColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
	Refresh;
end;

procedure TNxDBDateColumn.SetNoneCaption(const Value: WideString);
begin
  FNoneCaption := Value;
end;

procedure TNxDBDateColumn.SetShowNoneButton(const Value: Boolean);
begin
  FShowNoneButton := Value;
end;

procedure TNxDBDateColumn.SetTodayCaption(const Value: WideString);
begin
  FTodayCaption := Value;
end;

{ TNxDBGraphicColumn }

constructor TNxDBGraphicColumn.Create(AOwner: TComponent);
begin
  inherited;
  FActualSize := False;
  FBlobType := btDefault;
  FBorderWidth := 1;
  FMargin := 4;
  FStrecht := False;
  DefaultValue := '';
  SetSortType(stAlphabetic);
  SetColumnType(ctGraphic);
end;

function TNxDBGraphicColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxDBGraphicColumnDisplay;
end;

procedure TNxDBGraphicColumn.SetActualSize(const Value: Boolean);
begin
  FActualSize := Value;
  Refresh;
end;

procedure TNxDBGraphicColumn.SetBorderWidth(const Value: Integer);
begin
  FBorderWidth := Value;
  Refresh;
end;

procedure TNxDBGraphicColumn.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Refresh;
end;

procedure TNxDBGraphicColumn.SetStrecht(const Value: Boolean);
begin
  FStrecht := Value;
  Refresh;
end;

{ TNxDBRateColumn }

constructor TNxDBRateColumn.Create(AOwner: TComponent);
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

destructor TNxDBRateColumn.Destroy;
begin
  FEmptyGlyph.Free;
  FGlyph.Free;
  inherited;
end;

procedure TNxDBRateColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBRateColumn then
  begin
    EmptyGlyph.Assign(TNxDBRateColumn(Source).EmptyGlyph);
    Glyph.Assign(TNxDBRateColumn(Source).Glyph);
    Max := TNxDBRateColumn(Source).Max;
    Transparent := TNxDBRateColumn(Source).Transparent;
  end;
end;

procedure TNxDBRateColumn.SetEmptyGlyph(const Value: TBitmap);
begin
  FEmptyGlyph.Assign(Value);
end;

procedure TNxDBRateColumn.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
end;

procedure TNxDBRateColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
  Refresh;
end;

procedure TNxDBRateColumn.SetMax(const Value: Integer);
begin
  if FMax <> Value then
  begin
	  FMax := Value;
	  Refresh;
  end;
end;

procedure TNxDBRateColumn.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  Refresh;
end;

procedure TNxDBRateColumn.DoGlyphChanged(Sender: TObject);
begin
	if FTransparent then
  begin
    (Sender as TBitmap).TransparentColor := (Sender as TBitmap).Canvas.Pixels[0, (Sender as TBitmap).Height - 1];
    (Sender as TBitmap).Transparent := True;
  end;
end;

function TNxDBRateColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxDBRateColumnDisplay;
end;

function TNxDBRateColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := TNxDBRateColumnPlay;
end;

function TNxDBRateColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest];
end;

{ TNxDBImageColumn }

procedure TNxDBImageColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBImageColumn then
  begin
    Images := TNxDBImageColumn(Source).Images;
  end;
end;

constructor TNxDBImageColumn.Create(AOwner: TComponent);
begin
  inherited;
  FTransparent := True;
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctInteger);
end;

function TNxDBImageColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxDBImageColumnDisplay;
end;

function TNxDBImageColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csFitToLargest];
end;

procedure TNxDBImageColumn.SetImages(const Value: TImageList);
begin
  FImages := Value;
end;

procedure TNxDBImageColumn.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;

{ TNxDBHtmlColumn }

constructor TNxDBHtmlColumn.Create(AOwner: TComponent);
begin
  inherited;
  FTagAfter := '';
  FTagBefore := '';
  SetSortType(stAlphabetic);
  SetColumnType(ctString);
end;

function TNxDBHtmlColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := nil;
end;

function TNxDBHtmlColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxDBHtmlColumnDisplay;
end;

function TNxDBHtmlColumn.GetColumnPlayClass: TColumnPlayClass;
begin
  Result := TNxDBHtmlColumnPlay; 
end;

function TNxDBHtmlColumn.GetHintText(Cell: TCellInfo): WideString;
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

procedure TNxDBHtmlColumn.SetTagAfter(const Value: WideString);
begin
  FTagAfter := Value;
  Refresh;
end;

procedure TNxDBHtmlColumn.SetTagBefore(const Value: WideString);
begin
  FTagBefore := Value;
  Refresh;
end;

{ TNxDBButtonColumn }

procedure TNxDBButtonColumn.Assign(Source: TPersistent);
begin
  inherited;

end;

constructor TNxDBButtonColumn.Create(AOwner: TComponent);
begin
  inherited;
  FShowButton := True;
  FButtonCaption := '';
  FButtonWidth := 21;
  FGlyph := TBitmap.Create;
  DefaultValue := '';
  SetColumnType(ctString);
  SetSortType(stAlphabetic);
  TNxButtonEdit(Editor).OnButtonClick := DoButtonClick;
end;

destructor TNxDBButtonColumn.Destroy;
begin
  FreeAndNil(FGlyph);
  inherited;
end;

procedure TNxDBButtonColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxButtonEdit do
  begin
    ButtonCaption := Self.ButtonCaption;
    ButtonGlyph.Assign(FGlyph);
    ButtonWidth := Self.ButtonWidth;
    ShowButton := Self.ShowButton;
    TransparentColor := FGlyph.TransparentColor;
    ReadOnly := not IsFieldEditable;
  end;
end;

function TNxDBButtonColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxButtonEdit;
end;

function TNxDBButtonColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTextColumnDisplay;
end;

function TNxDBButtonColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

procedure TNxDBButtonColumn.SetButtonCaption(const Value: WideString);
begin
  FButtonCaption := Value;
end;

procedure TNxDBButtonColumn.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  FGlyph.Transparent := True;
  FGlyph.TransparentColor := FGlyph.Canvas.Pixels[0, FGlyph.Height - 1];
end;

procedure TNxDBButtonColumn.DoButtonClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then FOnButtonClick(Self);
end;

function TNxDBButtonColumn.GetColumnState: TColumnState;
begin
  Result := [];
  if Enabled and (IsFieldEditable or FShowButton) and
    ((csCanEdit in ColumnStyle) or (InplaceEdit <> nil)) then
  begin
    if coEditing in Options then Include(Result, ceEditable);
    if coCanInput in Options then Include(Result, ceCanInput);
  end;
end;

procedure TNxDBButtonColumn.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
end;

{ TNxDBPopupColumn }

constructor TNxDBPopupColumn.Create(AOwner: TComponent);
begin
  inherited;
  with Editor as TNxPopupEdit do
  begin
    OnCloseUp := DoCloseUp;
    OnSelect := DoSelect;
  end;
end;

procedure TNxDBPopupColumn.DoCloseUp(Sender: TObject);
begin
  if Assigned(FOnCloseUp) then FOnCloseUp(Self);
end;

procedure TNxDBPopupColumn.DoSelect(Sender: TObject);
begin
  if Assigned(FOnSelect) then FOnSelect(Self);
end;

{ TNxDBProgressColumn }

constructor TNxDBProgressColumn.Create(AOwner: TComponent);
begin
  inherited;
  FBorderColor := clGray;
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

procedure TNxDBProgressColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBProgressColumn then
  begin
    BorderColor := TNxDBProgressColumn(Source).BorderColor;
    Margin := TNxDBProgressColumn(Source).Margin;
    Max := TNxDBProgressColumn(Source).Max;
    ProgressColor := TNxDBProgressColumn(Source).ProgressColor;
    ProgressStyle := TNxDBProgressColumn(Source).ProgressStyle;
    TextPosition := TNxDBProgressColumn(Source).TextPosition;
    ShowText := TNxDBProgressColumn(Source).ShowText;
  end;
end;

procedure TNxDBProgressColumn.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
end;

procedure TNxDBProgressColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
	Refresh(gaBody);
end;

procedure TNxDBProgressColumn.SetProgressColor(const Value: TColor);
begin
  FProgressColor := Value;
	Refresh(gaBody);
end;

procedure TNxDBProgressColumn.SetProgressHeight(const Value: Integer);
begin
  FProgressHeight := Value;
	Refresh(gaBody);
end;

procedure TNxDBProgressColumn.SetHighValueBound(const Value: Integer);
begin
  FHighValueBound := Value;
  Refresh;
end;

procedure TNxDBProgressColumn.SetHighValueColor(const Value: TColor);
begin
  FHighValueColor := Value;
  Refresh;
end;

procedure TNxDBProgressColumn.SetLowValueBound(const Value: Integer);
begin
  FLowValueBound := Value;
  Refresh;
end;

procedure TNxDBProgressColumn.SetLowValueColor(const Value: TColor);
begin
  FLowValueColor := Value;
  Refresh;
end;

procedure TNxDBProgressColumn.SetMargin(const Value: Integer);
begin
  FMargin := Value;
  Refresh;
end;

procedure TNxDBProgressColumn.SetMax(const Value: Integer);
begin
  FMax := Value;
  Refresh;
end;

procedure TNxDBProgressColumn.SetProgressStyle(const Value: TProgressStyle);
begin
  FProgressStyle := Value;
  Refresh(gaBody);
end;

procedure TNxDBProgressColumn.SetRoundCorners(const Value: Boolean);
begin
  FRoundCorners := Value;
  Refresh;
end;

procedure TNxDBProgressColumn.SetShowText(const Value: Boolean);
begin
  FShowText := Value;
end;

procedure TNxDBProgressColumn.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
end;

function TNxDBProgressColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxDBProgressColumnDisplay;
end;

procedure TNxDBProgressColumn.SetTextPosition(
  const Value: TProgressTextPosition);
begin
  FTextPosition := Value;
  Refresh(gaBody);
end;

procedure TNxDBProgressColumn.SetPrecision(const Value: Integer);
begin
  FPrecision := Value;
  Refresh(gaBody);
end;

{ TNxDBNumberColumn }

constructor TNxDBNumberColumn.Create(AOwner: TComponent);
begin
  inherited;
  Alignment := taRightJustify;
  FIncrement := 1;
  FPasswordChar := #0;
  FSpinButtons := True;
end;

procedure TNxDBNumberColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBNumberColumn then
  begin
    Increment := TNxDBNumberColumn(Source).Increment;
    SpinButtons := TNxDBNumberColumn(Source).SpinButtons;
  end;
end;

procedure TNxDBNumberColumn.BeginEditing;
begin
  inherited;
	with Editor as TNxSpinEdit do
  begin
    Options := Self.EditOptions;
    Increment := Self.Increment;
    Max := Self.Max;
    Min := Self.Min;
    PasswordChar := Self.PasswordChar;
    SpinButtons := Self.SpinButtons;
  end;
end;

function TNxDBNumberColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxSpinEdit;
end;

procedure TNxDBNumberColumn.SetIncrement(const Value: Double);
begin
  FIncrement := Value;
end;

procedure TNxDBNumberColumn.SetPasswordChar(const Value: TChar);
begin
  FPasswordChar := Value;
end;

procedure TNxDBNumberColumn.SetSpinButtons(const Value: Boolean);
begin
  FSpinButtons := Value;
end;

procedure TNxDBNumberColumn.UpdateEdit;
begin
  with Editor as TNxSpinEdit do
  begin
    Precision := Self.Precision;
  end;
end;

function TNxDBNumberColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := inherited GetDrawText(Cell);
  if PasswordChar <> #0 then Result := StringOfChar(PasswordChar, Length(Result));
end;

{ TNxDBCalcColumn }

function TNxDBCalcColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxCalcEdit;
end;

procedure TNxDBCalcColumn.BeginEditing;
begin
  inherited;
	with Editor as TNxCalcEdit do
  begin
    Max := Self.Max;
    Min := Self.Min;
  end;
end;

{ TNxDBMemoColumn }

procedure TNxDBMemoColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxMemoInplaceEdit do
  begin
    ScrollBars := Self.ScrollBars;
  end;
end;

constructor TNxDBMemoColumn.Create(AOwner: TComponent);
begin
  inherited;
  SetColumnType(ctMemo);
  FMemoDisplayOptions := mdDefault;
  FScrollBars := ssNone;
end;

function TNxDBMemoColumn.GetCellEditorClass: TCellEditorClass;
begin
  Result := TNxMemoInplaceEdit;
end;

function TNxDBMemoColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TMemoColumnDisplay;
end;

function TNxDBMemoColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csRedrawInplaceEdit, csTextFitHint, csWantReturns];
end;

procedure TNxDBMemoColumn.SetMemoDisplayOptions(
  const Value: TMemoDisplayOptions);
begin
  FMemoDisplayOptions := Value;
  Refresh(gaBody);
end;

function TNxDBMemoColumn.GetDisplayOptions: TDisplayOptions;
begin
  Result := [doMultiLine];
end;

{ TNxDBTimeColumn }

constructor TNxDBTimeColumn.Create(AOwner: TComponent);
begin
  inherited;
  SetColumnType(ctDate);
  FHideWhenEmpty := False;
end;

function TNxDBTimeColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTimeColumnDisplay;
end;

function TNxDBTimeColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  if (Cell.AsDateTime = 0) and HideWhenEmpty then Result := EmptyCaption else
  begin
   	if FormatMask <> ''	then
    begin
      Result := FormatDateTime(FormatMask, Cell.AsDateTime);
    end else Result := TimeToStr(Cell.AsDateTime);
  end;
end;

procedure TNxDBTimeColumn.SetEmptyCaption(const Value: WideString);
begin
  FEmptyCaption := Value;
end;

procedure TNxDBTimeColumn.SetFormatMask(const Value: string);
begin
  FFormatMask := Value;
end;

procedure TNxDBTimeColumn.SetHideWhenEmpty(const Value: Boolean);
begin
  FHideWhenEmpty := Value;
end;

{ TNxDBComboBoxColumn }

procedure TNxDBComboBoxColumn.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TNxDBComboBoxColumn then
  begin
    Style := TNxDBComboBoxColumn(Source).Style;
  end;
end;

procedure TNxDBComboBoxColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxComboBox do
  begin
    if Self.Style = cbsDropDownList then Style := dsDropDownList
      else Style := dsDropDown;
    DisplayMode := Self.ItemsMode;
  end;
end;

constructor TNxDBComboBoxColumn.Create(AOwner: TComponent);
begin
  inherited;
  FItemsMode := dmDefault;
  FStyle := cbsDropDown;
end;

function TNxDBComboBoxColumn.IsKeyValid(Key: Char): Boolean;
begin
  if Style = cbsDropDownList then
  begin
    Result := (LocateKey(WideChar(Key), FItems) <> -1) or FAutoDropDown;
  end else Result := inherited IsKeyValid(Key);
end;

procedure TNxDBComboBoxColumn.SetItemsMode(const Value: TItemsDisplayMode);
begin
  FItemsMode := Value;
end;

procedure TNxDBComboBoxColumn.SetStyle(const Value: TCompoBoxStyle);
begin
  FStyle := Value;
end;

procedure TNxDBComboBoxColumn.UpdateEdit;
var
  Index: Integer;                  
begin
  with Editor as TNxComboBox do
  begin
    Index := Items.IndexOf(AsString);
    if Index <> -1 then ItemIndex := Index;
    case FItemsMode of
      dmValueList: Editor.AsString := FItems.Values[Editor.AsString]
    end;
  end;
end;

procedure TNxDBComboBoxColumn.ApplyField(Value: WideString);
begin
  case FItemsMode of
    dmValueList: Value := NameOfValue(Value);
  end;
  inherited;
end;

function TNxDBComboBoxColumn.NameOfValue(S: WideString): WideString;
var
  i, P: Integer;
  S2: WideString;
begin
  Result := '';
  for i := 0 to Pred(FItems.Count) do
  begin
    S2 := FItems[i];
    P := Pos(S, S2);
    if P > 0 then
    begin
      Result := LeftStr(S2, P - 2);
      Exit;
    end;
  end;
end;

function TNxDBComboBoxColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := inherited GetDrawText(Cell);
  case FItemsMode of
    dmValueList: Result := ValueOfName(Cell.AsString);
  end;
end;

function TNxDBComboBoxColumn.ValueOfName(S: WideString): WideString;
var
  i, P: Integer;
  S2: WideString;
begin
  Result := '';
  for i := 0 to Pred(FItems.Count) do
  begin
    S2 := FItems[i];
    P := Pos(S, S2);
    if P > 0 then
    begin
      Result := Copy(S2, P + Length(s) + 1, MaxInt);
      Exit;
    end;
  end;
end;

{ TNxDBListColumn }

procedure TNxDBListColumn.ApplyEditing(var Value: WideString);
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

procedure TNxDBListColumn.BeginEditing;
begin
  inherited;
  with Editor as TNxComboBox do
  begin
    Style := dsDropDownList;
  end;
end;

constructor TNxDBListColumn.Create(AOwner: TComponent);
begin
  inherited;
  DefaultValue := '0';
  SetSortType(stNumeric);
  SetColumnType(ctInteger);
end;

function TNxDBListColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  if InRange(Cell.AsInteger, 0, Items.Count - 1) then
  begin
    Result := TextBefore + Items[Cell.AsInteger] + TextAfter;
  end else Result := '';
end;

function TNxDBListColumn.GetInputDrawText: WideString;
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

function TNxDBListColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := LocateKey(WideChar(Key), Items) <> -1;
end;

procedure TNxDBListColumn.UpdateEdit;
begin
  with Editor as TNxComboBox do
  begin
    if Text <> '' then ItemIndex := AsInteger
      else ItemIndex := 0;
  end;
end;

end.
