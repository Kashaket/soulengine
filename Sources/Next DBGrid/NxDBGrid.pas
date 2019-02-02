{
  Next DBGrid
  Copyright (C) 1996-2010 by Berg
  All rights reserved.

  $id:NxDBGrid.pas bn
}

{$DEFINE _TRIAL}
{$DEFINE _FETCH_BUG}
{$DEFINE _NX_DEBUG}
{$I '..\NxSuite.inc'}

unit NxDBGrid;

interface

uses
	Classes, Graphics, Messages, NxCustomGridControl, NxCustomGrid, DB, NxColumns, Forms,
  NxDBColumns, Dialogs, SysUtils, DateUtils, NxGridCommon, Windows,
  NxScrollControl, NxColumnClasses, Jpeg, NxClasses, DbGrids, Controls;

type
	TNextDBGrid = class;
  TNextDBGridHelper = class;
  
	TDataAwareOptions = set of (doAddColumns, doAddIncrementColumn,
    doAutoAssignFieldName, doBufferRecords, doClearColumnsOnDeactivate,
    doRetrieveRecords, doSetColumnWidth, doInsDelKeys, doImmediatePost, doStandardBrowsing);
  TDataState = set of (dsScrolling, dsUpdating);
  TDBCellFormatingEvent = procedure (Sender: TObject; ACol, ARow: Integer; Value: WideString;
    var TextColor: TColor; var FontStyle: TFontStyles; CellState: TCellState) of object;
  TColumnAddedEvent = procedure (Sender: TObject; Column: TNxDBCustomColumn) of object;
  TColumnCreateEvent = procedure (Sender: TObject; Field: TField; var ColumnClass:
    TNxDBColumnClass; var AddColumn: Boolean) of object;
  TColumnFormatingEvent = procedure (Sender: TObject; Column: TNxCustomColumn; Field: TField) of object;
  TRowVisibleEvent = procedure (Sender: TObject; Index: Integer; var Visible: Boolean) of object;
  TDeleteRecordEvent = procedure (Sender: TObject; var Accept: Boolean) of object;

  TNxSelectionList = class
  private
    FList: TList;
  protected
    function Find(Index: Integer): Integer;
    function GetSelected(const Index: Integer): Boolean;
    procedure Put(Index: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function GetCount: Integer;
    procedure Clear;
    procedure SetCount(const Value: Integer);
    procedure SetSelected(const Index: Integer; Value: Boolean);
  end;

  TRecordCount = record
    Count: Integer;
    VisibleCount: Integer;
  end;

	TNxGridDataLink = class(TDataLink)
  private
    FCanEdit: Boolean;
    FChanging: Boolean;
  	FGrid: TNextDBGrid;
    FRecNo: Integer;
    FRecordCount: Integer;
    procedure DeactivateDataSet;
	protected
  	procedure ActiveChanged; override;
    procedure DataEvent(Event: TDataEvent; Info: {$IFDEF XE2}NativeInt{$ELSE}Longint{$ENDIF}); override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure EditingChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure RecountBufferCount(AutoShift: Boolean = True);
    procedure UpdateData; override;
    procedure UpdateScrollBar(Distance: Integer);
  public
    constructor Create;
    procedure PageDown;
    procedure PageUp;
  end;

  TNextDBGrid = class(TNxCustomGrid)
  private
    FBottomLimit: Integer;
    FDataAwareOptions: TDataAwareOptions;
  	FDataLink: TNxGridDataLink;
    FDataSource: TDataSource;
    FDataState: TDataState;
    FHelper: TNextDBGridHelper;
    FOnCellFormating: TDBCellFormatingEvent;
    FOnColumnAdded: TColumnAddedEvent;
    FOnColumnCreate: TColumnCreateEvent;
    FOnDeleteRecord: TDeleteRecordEvent;
    FOnRowVisible: TRowVisibleEvent;
    FSelectionList: TNxSelectionList;
    FSequencedScroll: Boolean;
    FTracking: Boolean;
    FUpdating: Boolean;
    function GetCellField(ACol, ARow: Integer): TField;
    function GetPageRecordCount(const IntegralHeight: Boolean): TRecordCount;
    function IsDataSetActive: Boolean;
    procedure AssignFieldNames;
    procedure SetDataAwareOptions(const Value: TDataAwareOptions);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetHelper(const Value: TNextDBGridHelper);
  protected
    procedure ApplyCellFormating(ACol, ARow: Integer; Value: WideString; CellState: TCellState); override;
    function BufferedMode: Boolean;
    function CalculateColumn(Column: TNxDBCustomColumn; FormulaKind: TFormulaKind;
      VisibleOnly: Boolean = False): Double; virtual;
    function CanEdit: Boolean; override;
    procedure CellsScrolled(Delta: Integer); override;
    procedure CompleteEdit(const ACol, ARow: Integer; const Value: WideString); override;
    function DrawCellData(ACol, ARow: Integer; CellState: TCellState): Boolean; override;
    function GetCellColor(ACol, ARow: Integer): TColor; override;
    function GetCellInfo(ACol, ARow: Integer): TCellInfo; override;
    function GetCells(ACol, ARow: Integer): WideString; override;
    function GetColumns: TNxDBColumns;
    function GetColumnsClass: TNxColumnsClass; override;
    function GetDrawText(ACol, ARow: Integer): WideString; override;
    function GetFirstVisibleRow: Integer; override;
    function GetHintText(ACol, ARow: Integer): WideString; override;
    function GetLastVisibleRow: Integer; override;
    function GetRowCount: Integer; override;
    function GetRowHeight(Index: Integer): Integer; override;
    function GetRowVisible(Index: Integer): Boolean; override;
    function GetSelected(Index: Integer): Boolean; override;
    function GetSelectedCount: Integer; override;
    function GetSelectedRow: Integer; override;
    function GetVertMax: Integer; override;
    function GetVisibleRows: Integer; override;
    function IntegralHeight: Boolean; override;
  	procedure BeforeScroll(ScrollBarKind: TScrollBarKind); override;
		procedure CreateWnd; override;
    { Event Handlers }
    procedure DoCellFormating(ACol, ARow: Integer; Value: WideString; var TextColor: TColor; var FontStyle: TFontStyles; CellState: TCellState); dynamic;
    procedure DoColumnPlayChange(Sender: TObject); override;
    procedure DoColumnAdded(Column: TNxDBCustomColumn); dynamic;
    procedure DoColumnCreate(Field: TField; var ColumnClass: TNxDBColumnClass; var AddColumn: Boolean); dynamic;
    procedure DoColumnsChange(Sender: TObject; ChangeOpearation: TColumnsOperation; Value1: Integer = -1; Value2: Integer = -1);
    procedure DoDeleteRecord(var Accept: Boolean); dynamic;
    procedure DoRowVisible(Index: Integer; var Visible: Boolean); dynamic;
    procedure DoSelectCell(ACol, ARow: Integer); override;
    { Common Methods }
    procedure DrawCell(ACol, ARow: Integer; CellRect: TRect); override;
    procedure FillDefaultValues;
    procedure GridStyleChanged; override;
    procedure ProcessKeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MoveToRecord(RowIndex: Integer);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure PostRow; override;
    procedure PrepareEdit; override;
    procedure RecordChanged(Field: TField);
    procedure SetActiveRow(const Index: Integer); override;
    procedure SetFieldObjects;
    procedure SetCells(ACol, ARow: Integer; const Value: WideString); override;
    procedure SetColumnPlayAttributes(ColumnPlay: TColumnPlay); override;
    procedure SetSelected(Index: Integer; const Value: Boolean); override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddRow(Count: Integer = 1): Integer; override;
    procedure AddRowFromInput; override;
    procedure CalculateFooter(VisibleOnly: Boolean = False); override;
    procedure ClearRows; override;
    procedure ClearSelection; override;
    procedure CreateColumns; virtual;
    procedure DeleteRow(ARow: Integer); override;
    procedure EndEditing; override;
    procedure InsertRow(Pos: Integer; Count: Integer = 1); override;
    procedure MoveSelectionDown(Shift: TShiftState = [];
      NextControl: Boolean = False; SelectFirst: Boolean = False); override;
    procedure MoveSelectionUp(Shift: TShiftState = []); override;
    procedure SelectFirstRow(Shift: TShiftState = []); override;
    procedure SelectLastRow(Shift: TShiftState = []); override;
    procedure SelectRange(FromRow, ToRow: Integer; Value: Boolean); override;
    procedure SortColumn(AColumn: TNxCustomColumn; Asending: Boolean); override;
    property CellField[ACol, ARow: Integer]: TField read GetCellField;

    function  GetColumnByFieldName(const AFieldName: string): TNxDBCustomColumn;
    function  GetCellValue(ACol, ARow: Integer): Variant;
    procedure SetCellValue(ACol, ARow: Integer; const Value: Variant);

    {$IFDEF NX_DEBUG}
    function GetDraw(ACol, ARow: Integer): WideString;
    procedure Test;
    {$ENDIF}

    procedure PrintInHelper(S: string);

    property DataLink: TNxGridDataLink read FDataLink;
    property DataState: TDataState read FDataState;
    property RowHeight[Index: Integer]: Integer read GetRowHeight write SetRowHeight;

    property CellValue[ACol, ARow: Integer]: Variant read GetCellValue write SetCellValue; default;
    property Helper: TNextDBGridHelper read FHelper write SetHelper;
    //
  published
    property Columns: TNxDBColumns read GetColumns;
  	property DataAwareOptions: TDataAwareOptions read FDataAwareOptions write SetDataAwareOptions default [doAddColumns];
  	property DataSource: TDataSource read FDataSource write SetDataSource;
    property SequencedScroll: Boolean read FSequencedScroll write FSequencedScroll default False;
    property Tracking: Boolean read FTracking write FTracking default True;

    property OnCellFormating: TDBCellFormatingEvent read FOnCellFormating write FOnCellFormating;
    property OnColumnAdded: TcolumnAddedEvent read FOnColumnAdded write FOnColumnAdded;
    property OnColumnCreate: TColumnCreateEvent read FOnColumnCreate write FOnColumnCreate;
    property OnDeleteRecord: TDeleteRecordEvent read FOnDeleteRecord write FOnDeleteRecord;
    property OnRowVisible: TRowVisibleEvent read FOnRowVisible write FOnRowVisible; 
  end;

  TNextDBGridHelper = class(TCustomControl)
  private
    FControl: TNextDBGrid;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Print(S: string);
    property Control: TNextDBGrid read FControl write FControl;
  end;

implementation

uses
  DBConsts, Variants, Types, StdCtrls,
  NxDBCommon, NxEdit, NxVirtualColumn;

function BoolToInt(const Value: Boolean): Integer;
begin
  if Value then Result := 1 else Result := 0;
end;

function StrToDateTimeEx(const S: WideString): TDateTime;
begin
  if S = '' then Result := 0 else Result := StrToDateTime(S);
end;

function StrToFloatEx(const S: WideString): Extended;
begin
  if S = '' then Result := 0 else Result := StrToFloat(S);
end;

function StrToIntEx(const S: WideString): Integer;
begin
  if S = '' then Result := 0 else Result := StrToInt(S);
end;

{ TNxSelectionList }

procedure TNxSelectionList.Clear;
var
  i: Integer;
begin
  for i := 0 to Pred(FList.Count) do Dispose(FList[i]);
  FList.Clear;
end;

constructor TNxSelectionList.Create;
begin
  FList := TList.Create;
end;

destructor TNxSelectionList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited;
end;

function TNxSelectionList.Find(Index: Integer): Integer;
var
  i: Integer;
  P: PInteger;
begin
  for i := 0 to Pred(FList.Count) do
  begin
    P := FList[i];
    if P^ = Index then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TNxSelectionList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TNxSelectionList.GetSelected(const Index: Integer): Boolean;
begin
  Result := Find(Index) <> -1;
end;

procedure TNxSelectionList.Put(Index: Integer);
var
  i: Integer;
  P: PInteger;
begin
  i := 0;
  P := nil;
  while (i < FList.Count) and (P <> nil) and (P^ < Index) do
  begin
    P := FList[i];
    Inc(i);
  end;
  New(P);
  P^ := Index;
  FList.Insert(i, P);
end;

procedure TNxSelectionList.SetCount(const Value: Integer);
begin
  FList.Count := Value;
end;

procedure TNxSelectionList.SetSelected(const Index: Integer;
  Value: Boolean);
var
  P: PInteger;
  Loc: Integer;
begin
  Loc := Find(Index);
  if Loc = -1 then // not in list
  begin
    if Value then Put(Index);
  end else
    if not Value then
    begin
      P := FList[Loc];
      Dispose(P);
      FList.Delete(Loc);
    end;
end;

{ TNxGridDataLink }

procedure TNxGridDataLink.ActiveChanged;
begin
  inherited;
  if Active then
  begin
    if (doAddColumns in FGrid.DataAwareOptions) and (FGrid.Columns.Count = 0)
      then FGrid.CreateColumns else FGrid.SetFieldObjects;
    if doAutoAssignFieldName in FGrid.DataAwareOptions then FGrid.AssignFieldNames;
    if doRetrieveRecords in FGrid.DataAwareOptions then DataSet.Last;
    RecountBufferCount;
    DataSet.First;
    ActiveRecord := 0;
    FGrid.Refresh;
  end else DeactivateDataSet;
  FGrid.FSelectionList.Clear;
  FGrid.UpdateVertScrollBar;
end;

procedure TNxGridDataLink.DataEvent(Event: TDataEvent; Info: {$IFDEF XE2}NativeInt{$ELSE}Longint{$ENDIF});
begin
  inherited;
  if Event in [deDataSetChange, {$IFNDEF DELPHI6}deDisabledStateChange,{$ENDIF} deLayoutChange] then
  begin
{$IFNDEF DELPHI6}
    if (Event = deDisabledStateChange) and (Info = 1) then FGrid.SetFieldObjects;
    if (Event = deLayoutChange) then FGrid.SetFieldObjects;
{$ENDIF}
    if DataSet.ControlsDisabled then Exit;
    RecountBufferCount;
    FRecNo := ActiveRecord;

    if FRecordCount <> DataSet.RecordCount then
    begin
      FRecordCount := DataSet.RecordCount;
      FGrid.FSelectionList.Clear;
    end;

    if not FGrid.FUpdating then
    begin
      { 6/24/07: !! Calling DataSet.RecordCount too often, may decrease
                    performance. }
      FGrid.UpdateVertScrollBar;
      { 3/1/07: after append, DataSet go EOF and grid
                need to be scrolled }
      if FGrid.AutoScroll then FGrid.ScrollToRow(FGrid.SelectedRow);

      ValidateRect(FGrid.Handle, nil);

      UpdateScrollBar(0);

      FGrid.Invalidate;

      DeactivateHint(FGrid.FHintWindow);
    end;
  end;
end;

constructor TNxGridDataLink.Create;
begin
  inherited;
  FCanEdit := False;
  FChanging := False;
end;

procedure TNxGridDataLink.DeactivateDataSet;
var
  i: Integer;
begin
  BufferCount := 0;
  FGrid.FFirstRow := 0;
  with FGrid do
  begin
    EndEditing;
    i := 0;
    while i < Columns.Count do
    begin
      if daAutoDelete in Columns[i].DataAwareOptions then
      begin
        Columns.Delete(i);
      end else
      begin
        if Columns[i] is TNxDBCustomColumn then
          Columns[i].Field := nil;
        Inc(i);
      end;
    end;
  end;
end;

{ 4/21/07:  In buffered mode BufferCount is equal to DataSet.RecordCount.
            In non-buffered mode BufferCount is equal to number of visible
            rows on screen, even if there is a only few records }
procedure TNxGridDataLink.RecountBufferCount(AutoShift: Boolean);
var
  Value: Integer;
begin
  if Active then
  begin
    if doBufferRecords in FGrid.DataAwareOptions then
    begin
      { 4/4/07: In buffered mode, buffer is number of TOTAL records
                in DataSet. If DataSet is dsInsert we need to increment buffer }
      Value := DataSet.RecordCount;
      if DataSet.State = dsInsert then Inc(Value);
    end else Value := FGrid.GetPageRecordCount(True).Count;
    { 4/30/07:  When ActiveRecord > BufferCount - 1, DataSet is automatically
                scrolled. Here we prevent this }

    if AutoShift then
      if Value > 0 then
      begin
        if ActiveRecord > Pred(Value) then ActiveRecord := Pred(Value);
      end else ActiveRecord := 0;

  end else Value := 0;

  if Value <> BufferCount then
    BufferCount := Value; { ok }
end;

procedure TNxGridDataLink.UpdateData;
begin
  inherited;
  if FChanging then Exit;
  { Desc: occur on DataSet.Post }
  if gtEdit in FGrid.GridState then
  begin
    { If Post is called outside grid (e.g. with Navigator),
      we need to finish editing. }
    FGrid.ApplyEditing;
    FGrid.EndEditing;
  end;
  RecountBufferCount; { need to recount buffer count }
end;

procedure TNxGridDataLink.DataSetScrolled(Distance: Integer);
begin
  if FChanging then Exit;

  FGrid.EndEditing;
  FGrid.RefreshRow(FGrid.SelectedRow);
  FRecNo := ActiveRecord;
  FGrid.RefreshSelectedCells;
  if FGrid.GridStyle = gsSlides then
  begin
    { 4/22/07:  In non-buffered mode, changing ActiveRecord
                from outside require refresh }
    if not FGrid.BufferedMode then FGrid.RefreshSelectedSlides else
  end else
  begin
    if goIndicator in FGrid.Options then
      FGrid.RefreshIndicator(FGrid.SelectedRow);
  end;

  inherited;

  RecountBufferCount;

  {$IFDEF FETCH_BUG}FGrid.Invalidate;{$ENDIF}
  { note: doesn't occur when first and last buttons
          on navigator are clicked. Distance parameter is empty }
  { After DataSet is crolled scrollbar must be updated }
  UpdateScrollBar(Distance);          
end;

procedure TNxGridDataLink.EditingChanged;
begin
  { Desc: occur on DataSet.Edit }
  inherited;
  { Do not edit cell and steal focus from other component }
  if not FGrid.Focused then Exit;
  if not Assigned(DataSource) or FChanging then Exit;
  if DataSet.State = dsEdit then
  begin
    try
      FCanEdit := True;
      FGrid.EditCell(FGrid.SelectedColumn, FGrid.SelectedRow);
    finally
      FCanEdit := False;
    end;
  end else
  begin
    FGrid.EndEditing;
  end;
end;

procedure TNxGridDataLink.PageDown;
begin
  ActiveRecord := Pred(RecordCount);
  MoveBy(RecordCount);
  RecountBufferCount;
end;

procedure TNxGridDataLink.PageUp;
begin
  ActiveRecord := 0;
  MoveBy(-RecordCount);
  RecountBufferCount;
end;

procedure TNxGridDataLink.RecordChanged(Field: TField);
begin
  inherited;
  { note: occur when you call Fields[n].AsString := ... }
  if FChanging then Exit;
  if Field <> nil then FGrid.RecordChanged(Field);
end;

procedure TNxGridDataLink.UpdateScrollBar(Distance: Integer);
begin
  { 6/19/11: !! Update ScrollBar on any change }
  if not FGrid.FUpdating and DataSet.Active then
  begin
    { Update ScrollBar Thumb position }
    if FGrid.BufferedMode
      then FGrid.ScrollToRow(Pred(DataSet.RecNo)) else
    begin

      try
        if not (dsScrolling in FGrid.DataState) then
          if DataSet.RecNo > -1 then
          begin
            FGrid.FUpdating := True;
            FGrid.ScrollToRow(Pred(DataSet.RecNo));
            FGrid.FUpdating := False;
          end;

      except

      end;
    end;
  end;
end;

procedure TNxGridDataLink.DataSetChanged;
begin
  inherited;

end;

{ TNextDBGrid }

procedure TNextDBGrid.ApplyCellFormating(ACol, ARow: Integer;
  Value: WideString; CellState: TCellState);
var
  TextColor: TColor;
  FontStyle: TFontStyles;
begin
  with Canvas do
  begin
    FontStyle := Columns[ACol].Font.Style;
    TextColor := Font.Color;
    if csBoldTextSelection in CellState then Font.Style := Font.Style + [fsBold];
    DoCellFormating(ACol, ARow, Value, TextColor, FontStyle, CellState);
    Font.Color := TextColor;
    Font.Style := FontStyle;
  end;
end;

procedure TNextDBGrid.BeforeScroll(ScrollBarKind: TScrollBarKind);
begin
//  if not(doBufferRecords in FDataAwareOptions) then
//    FDataLink.RecountBufferCount;
  { KeyDown scrolling }
  if GridStyle = gsReport then RefreshRow(SelectedRow)
    else RefreshSlide(SelectedRow);
end;

function TNextDBGrid.CanEdit: Boolean;
begin
  { Expl: DBGrid may be edited directly only if AutoEdit is True }
  Result := FDataSource.AutoEdit or FDataLink.FCanEdit;
end;

procedure TNextDBGrid.CompleteEdit;
var
  Field: TField;
begin
  try
    FDataLink.FChanging := True; { DataLink.EditingChanged will not be executed }
    if Columns[ACol] is TNxDBCustomColumn then
    begin
      Field := Columns[ACol].Field;
      if (Field <> nil) and Field.CanModify then Columns[ACol].ApplyField(Value);
    end;
    case Columns[ACol].ColumnType of
      ctVirtual: TNxVirtualColumn(Columns[ACol]).DoSetText(ACol, ARow, Value);
    end;
  finally
    FDataLink.FChanging := False;
  end;
end;

constructor TNextDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Columns.OnChange := DoColumnsChange;
  FDataAwareOptions := [doAddColumns];
  FDataLink := TNxGridDataLink.Create;
  FDataLink.FGrid := Self;
  FSequencedScroll := False;
  FSelectionList := TNxSelectionList.Create;
  FTracking := True;
end;

procedure TNextDBGrid.CreateWnd;
begin
  inherited;
	{$IFDEF TRIAL}
  if not(FindWindow('TAppBuilder', nil) > 0) then
	begin
  	if MessageDlg('This version of Next DBGrid Component work only while IDE is runnig. ' + #10#13 +
                  'Do you want to order component now?', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
		  ShellExecute(Handle, 'open', PChar('http://www.bergsoft.net/order/'), '', '', SW_NORMAL);
    end;
    Halt;
	end;
  {$ENDIF}
end;

destructor TNextDBGrid.Destroy;
begin
  FreeAndNil(FDataLink);
  FreeAndNil(FSelectionList);
  inherited;
end;

function TNextDBGrid.GetCellField(ACol, ARow: Integer): TField;
begin
  MoveToRecord(ARow);

  if Columns[ACol] is TNxDBCustomColumn then
    Result := Columns[ACol].Field
  else Result := nil;
end;

function TNextDBGrid.GetColumnByFieldName(const AFieldName: string): TNxDBCustomColumn;
var
	i: Integer;
begin
  Result := nil;
	for i := 0 to FColumns.Count - 1 do
    if (FColumns[i] is TNxDBCustomColumn) and SameText(TNxDBCustomColumn(FColumns[i]).FieldName, AFieldName) then
		begin
	    Result := TNxDBCustomColumn(FColumns[i]);
  		Break;
		end;
end;

function TNextDBGrid.GetColumns: TNxDBColumns;
begin
  Result := TNxDBColumns(FColumns);
end;

function TNextDBGrid.GetColumnsClass: TNxColumnsClass;
begin
  Result := TNxDBColumns;
end;

{ Return total number of visible rows on screen }
{ 4/22/07:  In buffered mode, number of buffered records may be 1 more
            than visible records count. GetVertScrollMax need full sized rows }

function TNextDBGrid.GetPageRecordCount(const IntegralHeight: Boolean): TRecordCount;
var
  i, Y, Delta, VisibleHeight: Integer;
  Done: Boolean;
begin
  FBottomLimit := 0;
  Delta := 0;

  Result.Count := 0;
  Result.VisibleCount := 0;

  Done := False;

  if FDataLink.Active then
  begin
    Y := 0;

    VisibleHeight := GetBodyRect.Bottom - GetBodyRect.Top;

    i := FFirstRow;       

    while not Done do
    begin

      if RowVisible[i] then
      begin

        case GridStyle of
          gsReport: Delta := GetRowHeight(i);
          gsSlides: Delta := SlideSize;
        end;

        Inc(Delta, GridSpace[lpTopBottom]);
        FBottomLimit := Y;

        Inc(Y, Delta);

        if Y > VisibleHeight then
        begin

          if not IntegralHeight then
          begin
            Inc(Result.VisibleCount);
            Inc(Result.Count);
          end;

          { done }
          Exit;
        end;

        { Plus one }
        Inc(Result.VisibleCount);

      end;

      Inc(Result.Count);
      Inc(i);

    end;
  end;

end;

function TNextDBGrid.IsDataSetActive: Boolean;
begin
  Result := Assigned(DataSource) and Assigned(DataSource.DataSet)
    and FDataLink.Active and not DataSource.DataSet.IsUniDirectional;
end;

procedure TNextDBGrid.AssignFieldNames;
var
  CurrFld, CurrCol: Integer;
begin
  CurrCol := 0;
  CurrFld := 0;
  while (CurrCol < Columns.Count) and (CurrFld < FDataLink.DataSet.FieldCount) do
  begin
    while not(daAutoAssign in Columns[CurrCol].DataAwareOptions) or not (Columns[CurrCol] is TNxDBCustomColumn) do
    begin
      Inc(CurrCol);
      if CurrCol >= Columns.Count then Exit;
    end;

    Columns[CurrCol].Field := FDataLink.DataSet.Fields[CurrFld];

    Inc(CurrFld);
    Inc(CurrCol);
  end;
end;

function TNextDBGrid.GetCells(ACol, ARow: Integer): WideString;
var
  DataField: TField;
begin
  Result := '';
  if FDataLink.Active = False then Exit;
	with FDataLink do
  begin
    if Columns[ACol] is TNxDBCustomColumn then DataField := Columns[ACol].Field else DataField := nil;

    if Assigned(DataField) then
    begin
      { set active record }
      FRecNo := ActiveRecord;

      if doBufferRecords in DataAwareOptions
        then ActiveRecord := ARow
          else ActiveRecord := ARow - FFirstRow;

      case Columns[ACol].ColumnType of
        ctLookup: with Columns[ACol] as TNxLookupColumn do
                  begin
                    if (Assigned(ListDataSource)) and (ListDataSource.DataSet.Active)
                      then Result := VarToStr(ListDataSource.DataSet.Lookup(KeyFieldName, DataField.AsVariant, ListFieldName));
                  end;
        ctString:
          case DataField.DataType of
            ftWideString: Result := TWideStringField(DataField).Value;
            ftMemo: Result := DataField.AsString { Memo Blob }
            else Result := DataField.DisplayText;
          end;
        ctMemo:
          { mdContent, display content of Memo Field }
          if TNxDBMemoColumn(Columns[ACol]).MemoDisplayOptions = mdContent then
            {$IFDEF DELPHI2006}
            Result := DataField.AsWideString;
            {$ELSE}
            Result := DataField.AsString;
            {$ENDIF}
        else Result := DataField.DisplayText;
      end;
      ActiveRecord := FRecNo;
    end else
    begin
      case Columns[ACol].ColumnType of
        ctAutoInc: Result := IntToStr(ARow);
        ctVirtual: TNxVirtualColumn(Columns[ACol]).DoGetText(ACol, ARow, Result);
        else Result := '';
      end;
    end;
  end;
end;

function TNextDBGrid.GetCellValue(ACol, ARow: Integer): Variant;
var
  AField: TField;
  S: WideString;
begin
exit;

  Result := Null;

  if FDataLink.Active = False then Exit;

	with FDataLink do
  begin
    if Columns[ACol] is TNxDBCustomColumn then
      AField := Columns[ACol].Field
    else AField := nil;

    if Assigned(AField) then
    begin

      try
        { Save curr ActiveRecord }
        FRecNo := ActiveRecord;

        if doBufferRecords in DataAwareOptions
          then ActiveRecord := ARow
            else ActiveRecord := ARow - FFirstRow;

        case Columns[ACol].ColumnType of
          ctLookup: with Columns[ACol] as TNxLookupColumn do
                    begin
                      if (Assigned(ListDataSource)) and Assigned(ListDataSource.DataSet) and (ListDataSource.DataSet.Active)
                        then Result := ListDataSource.DataSet.Lookup(KeyFieldName, AField.AsVariant, ListFieldName);
                    end;
          ctString:
            case AField.DataType of
              ftWideString: Result := TWideStringField(AField).Value;
              ftMemo{, ftWideMemo}: Result := AField.Value { Memo Blob }
              else Result := AField.Value;
            end;

          else Result := AField.Value;
        end;

      finally
        ActiveRecord := FRecNo;
      end;

    end else
    begin
      case Columns[ACol].ColumnType of
        ctAutoInc: Result := ARow;
        ctVirtual:
          begin
            S := '';
            TNxVirtualColumn(Columns[ACol]).DoGetText(ACol, ARow, S);
            if S = '' then
              Result := Null
            else Result := S;
          end
        else Result := Null;
      end;
    end;
  end;
end;

procedure TNextDBGrid.ProcessKeyDown(var Key: Word; Shift: TShiftState);
var
  AcceptDelete: Boolean;
begin
  { Support for Insert and Delete keys }
  if (doInsDelKeys in FDataAwareOptions)
    and IsDataSetActive
    and not FDataLink.ReadOnly
    and not(gtEdit in GridState) then
  begin
    case Key of
      VK_INSERT: FDataLink.DataSet.Insert;
      VK_DELETE:
        begin
          if not FDataLink.DataSet.IsEmpty then
          begin
            AcceptDelete := True;
            DoDeleteRecord(AcceptDelete);
            if AcceptDelete then FDataLink.DataSet.Delete;
          end;
        end;
      VK_ESCAPE: FDataLink.DataSet.Cancel;
    end;
  end;

  if not BufferedMode then
  begin

	  case Key of
     { PageUp }
	    VK_PRIOR:
        if doStandardBrowsing in FDataAwareOptions then
        begin

          if SelectedRow > FirstRow then SelectedRow := FirstRow else
          begin
            { If First Row is selected }
            FDataLink.PageUp;
          end;

        end else VertScrollBar.PageUp;

      { PageDown }
	    VK_NEXT:
        if doStandardBrowsing in FDataAwareOptions then
        begin

          { Check if Last Row in View is selected }
          if SelectedRow = LastRowInView then
          begin
            { Move Record one Screen down }
            FDataLink.PageDown;
          end
          else SelectedRow := LastRowInView;

        end else
        begin
          { PageDown }
//          if not VertScrollBar.IsLast then VertScrollBar.PageDown;
          SendMessage(Handle, WM_VSCROLL, SB_PAGEDOWN, 0);
        end;

      VK_HOME:
        if not ((gtEdit in GridState)
            or (gtInput in GridState))
          then SendMessage(Handle, WM_VSCROLL, SB_TOP, 0);

      VK_END:
        if not ((gtEdit in GridState)
            or (gtInput in GridState))
          then SendMessage(Handle, WM_VSCROLL, SB_BOTTOM, 0);

      else inherited; { Other Keys }
  	end;

  end else inherited; { Non-Buffered Mode }
end;

procedure TNextDBGrid.MoveToRecord(RowIndex: Integer);
var
  ActiveRec, Delta: Integer;
begin
  if InputSelected then Exit;
  
  case doBufferRecords in DataAwareOptions of
    True:
    begin
      ActiveRec := RowIndex;
      Delta := RowIndex - FDataLink.ActiveRecord;
      { example:  RowIndex = 5, ActiveRecord = 3
                  Delta = 2 (move for 2 records) }
    end;
    else
    begin
      ActiveRec := RowIndex - FFirstRow;

      Delta := RowIndex - SelectedRow;

      PrintInHelper('Delta: ' + IntToStr(Delta));
    end;
  end;
  
  { 2/22/07:  MoveBy cause DataSet exit from stInsert state }
  if Delta <> 0 then
  begin
    { 3/25/07:  if ActiveRec < 0 mean that first row in view is selected,
                and that scrollbar will be scrolled up (and call MoveBy) }
    if ActiveRec < 0 then Exit;

    FDataLink.MoveBy(Delta);

    FDataLink.ActiveRecord := ActiveRec;
    FDataLink.FRecNo := FDataLink.ActiveRecord;

{$IFDEF NX_DEBUG}
    Invalidate;

    Exit;
{$ENDIF}

    { Refresh }
    case GridStyle of
      gsReport: if goSelectFullRow in Options
                  then RefreshRow(RowIndex)
                  else RefreshCell(SelectedColumn, RowIndex);
      gsSlides: RefreshSlide(RowIndex);
    end;
  end;
end;

procedure TNextDBGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if (Operation = opRemove) then
  begin
     if (FDataLink <> nil) and (AComponent = FDataSource) then
       FDataSource := nil
  end else if (AComponent is TField) then
  begin
    try
      for i := 0 to Columns.Count - 1 do
      with Columns[i] do if Field = AComponent then Field := nil;
    finally

    end;
  end;
end;

procedure TNextDBGrid.PostRow;
begin
  if FDataLink.Editing then FDataLink.DataSet.Post;
end;

procedure TNextDBGrid.PrepareEdit;
begin
  with DataLink do
    if not (DataSet.State = dsEdit) and DataSource.AutoEdit then DataSet.Edit;
end;

procedure TNextDBGrid.RecordChanged(Field: TField);
var
  i, ARow: Integer;
begin
  { note: RecordChanged occur when Field is changed }
  { 2/23/07:  if dsInsert state, complete grid need refresh
              ADO put new record at end, it may be optimized }
  if FDataLink.DataSet.State = dsInsert then RefreshArea(gaBody) else
  begin
    { find currently active cell in data set }
    ARow := -1;
    case doBufferRecords in DataAwareOptions of
      True: ARow := FDataLink.ActiveRecord;
      False: ARow := FDataLink.ActiveRecord + FFirstRow;
    end;
    for i := 0 to Columns.Count - 1 do
      if Columns[i] is TNxDBCustomColumn then
        if Columns[i].Field = Field then
          RefreshCell(i, ARow);
  end;
end;

procedure TNextDBGrid.SetActiveRow(const Index: Integer);
begin
  FDataLink.ActiveRecord := Index;
end;

procedure TNextDBGrid.SetFieldObjects;
var
  I: Integer;
begin
  for I := 0 to Columns.Count - 1 do
    if (Columns[I] is TNxDBCustomColumn) then
      with TNxDBCustomColumn(Columns[I]) do
        if Length(FieldName) > 0 then
          Field := FDataLink.DataSet.FindField(FieldName)
        else
          Field := nil;
end;

procedure TNextDBGrid.SetCells(ACol, ARow: Integer; const Value: WideString);
var
  DataField: TField;
begin
  FUpdating := True;
  try
    MoveToRecord(ARow);
    if FColumns[ACol] is TNxDBCustomColumn then
    begin
      DataField := Columns[ACol].Field;
      if Assigned(DataField) and DataField.CanModify then
      begin
        FDataLink.DataSet.Edit;
        Columns[ACol].ApplyField(Value);
        if (FDataLink.Dataset.State in [dsInsert, dsEdit]) then
          FDataLink.Dataset.Post;
      end;
    end;
    case Columns[ACol].ColumnType of
      ctVirtual: TNxVirtualColumn(Columns[ACol]).DoSetText(ACol, ARow, Value);
    end;
    { 2/23/07:  After Field set, selected row may changed }
    DoChange(ACol, ARow); { event }
  finally
    FUpdating := False;
  end;
end;

procedure TNextDBGrid.SetCellValue(ACol, ARow: Integer; const Value: Variant);
var
  DataField: TField;
begin
  FUpdating := True;
  try
    MoveToRecord(ARow);
    if FColumns[ACol] is TNxDBCustomColumn then
    begin
      DataField := Columns[ACol].Field;
      if Assigned(DataField) and DataField.CanModify then
      begin
        FDataLink.DataSet.Edit;
        DataField.AsVariant := Value;
      	FDataLink.DataSet.Post;
      end;
    end;
    case Columns[ACol].ColumnType of
      ctVirtual: TNxVirtualColumn(Columns[ACol]).DoSetText(ACol, ARow, VarToWideStr(Value));
    end;
    { 2/23/07:  After Field set, selected row may changed }
    DoChange(ACol, ARow); { event }
  finally
    FUpdating := False;
  end;
end;

procedure TNextDBGrid.SetColumnPlayAttributes(ColumnPlay: TColumnPlay);
begin
  with FDataLink do
  begin
    FRecNo := ActiveRecord; { remember active record in buffer }
    case doBufferRecords in DataAwareOptions of
      True: ActiveRecord := ColumnPlay.Row;
      False: ActiveRecord := ColumnPlay.Row - FFirstRow;
    end;
    { Read data from current record }
    with GetCellInfo(ColumnPlay.Col, ColumnPlay.Row) do
    begin
      case ColumnPlay.Column.ColumnType of
        ctString: ColumnPlay.AsString := AsString;
        ctBoolean: ColumnPlay.AsBoolean := AsString = TNxDBCheckBoxColumn(ColumnPlay.Column).ValueChecked;
        ctInteger: ColumnPlay.AsInteger := AsInteger;
        { Other ColumnTypes don't have a Play }
      end;
    end;
    { Go to previously active record }
    ActiveRecord := FRecNo;
  end;
end;

procedure TNextDBGrid.SetSelected(Index: Integer; const Value: Boolean);
begin
  FSelectionList.SetSelected(Index, Value);
  case GridStyle of
    gsReport: RefreshRow(Index);
    gsSlides: RefreshSlide(Index);
  end;
end;

procedure TNextDBGrid.SetDataAwareOptions(const Value: TDataAwareOptions);
begin
  if Value <> FDataAwareOptions then
  begin
    FDataAwareOptions := Value;
    FDataLink.RecountBufferCount;
    RefreshArea(gaBody);
  end;
end;

function TNextDBGrid.BufferedMode: Boolean;
begin
  Result := doBufferRecords in FDataAwareOptions;
end;

function TNextDBGrid.CalculateColumn(Column: TNxDBCustomColumn;
  FormulaKind: TFormulaKind; VisibleOnly: Boolean): Double;
var
  i, RecNo, RecCount: Integer;
  S: WideString;
  FormulaSum: Double;
  StringList: TStringList;

  function GetFieldValue(Field: TField): Double;
  begin
    case Column.Field.DataType of
      ftBoolean:  Result := BoolToInt(Field.AsBoolean);
      else        Result := Field.AsFloat;
    end;
  end;

begin
  if FDataLink.Editing then FDataLink.DataSet.Cancel;

  if not (Column is TNxDBCustomColumn)
    or not Assigned(Column.Field) then Exit;

  if Column.Footer.FormulaKind = fkNone then Exit;

  { Default }
  Result := 0;
  FormulaSum := 0;
  RecNo := FDataLink.ActiveRecord;
  RecCount := 0;

  try
    { First }
    FDataLink.ActiveRecord := 0;

    { Preparing }
    case FormulaKind of
      fkMaximum, fkMinimum: FormulaSum := GetFieldValue(Column.Field);
      fkDistinct: StringList := TStringList.Create;
    end;

    { Processing }
    for i := 0 to Pred(FDataLink.BufferCount) do
    begin
      FDataLink.ActiveRecord := i;

      if IsCalculateRow(i)
        and (VisibleOnly or RowVisible[i]) then
      begin
        { Visible count }
        Inc(RecCount);

        case FormulaKind of
          fkSum, fkAverage: FormulaSum := FormulaSum + GetFieldValue(Column.Field);
          fkMaximum: if Column.Field.AsFloat > FormulaSum then FormulaSum := GetFieldValue(Column.Field);
          fkMinimum: if Column.Field.AsFloat < FormulaSum then FormulaSum := GetFieldValue(Column.Field);
          fkDistinct:
          begin
            S := Column.Field.DisplayText;
            if StringList.IndexOf(S) = -1 then StringList.Add(S);
          end;
        end;
      end;

    end;

    { Result }
    case FormulaKind of
      fkCount: Result := RecCount;
      fkSum, fkMaximum, fkMinimum: Result := FormulaSum;
      fkAverage: Result := FormulaSum / RecCount;
      fkDistinct:
      begin
        Result := StringList.Count;
        FreeAndNil(StringList);
      end;
      fkCustom:
      begin
        DoColumnFooterValue(Column.Index, FormulaSum);
        Result := FormulaSum;
      end;
    end;

  finally
    { Revert }
    FDataLink.ActiveRecord := RecNo;
  end;

end;

procedure TNextDBGrid.CellsScrolled(Delta: Integer);
begin
  { In non-buffered mode, when scroll bar is set from code,
    DataSet need to be scrolled too }
  if IsDataSetActive then
    with FDataLink do
      if not BufferedMode and not FUpdating then
      begin
        ActiveRecord := 0;

        try
          FUpdating := True;

          if Delta > 0
            then MoveBy(RecordCount + Succ(Delta))
          else if Delta < 0
            then MoveBy(Delta);

        finally
          FUpdating := False;
        end;
      end
      else RecountBufferCount(False);
end;

procedure TNextDBGrid.CalculateFooter;
var
  i: Integer;
  FormulaResult: Double;
  Column: TNxDBCustomColumn;
begin
  if FDataLink.Active then
  for i := 0 to Columns.Count - 1 do
  begin
    Column := Columns[i];
    if Column.Footer.FormulaKind <> fkNone then
    begin
      FormulaResult := CalculateColumn(Column, Column.Footer.FormulaKind);
      DoFooterCalculate(i, FormulaResult);
      Column.Footer.Caption := FloatToStr(FormulaResult);
      Column.Footer.FormulaValue := FormulaResult;
    end;
  end;
end;

function TNextDBGrid.GetRowCount: Integer;
begin
  try
    if FDataLink.Active and (Columns.Count > 0) then
    begin
      Result := FDataLink.FRecordCount;
      if FDataLink.DataSet.State = dsInsert then
        Inc(Result); { get one more row for insert record }
    end else Result := 0;
  except
    Result := 0;
  end;
end;

function TNextDBGrid.GetRowHeight(Index: Integer): Integer;
var
  ActiveRecord: Integer;
begin
  Result := RowSize;

  if IsDataSetActive
    and (Index < FDataLink.FRecordCount) then
  begin
    try
      ActiveRecord := FDataLink.ActiveRecord;

      case doBufferRecords in DataAwareOptions of
        True: FDataLink.ActiveRecord := Index;
        False: FDataLink.ActiveRecord := Index - FFirstRow;
      end;

      { Trigger event }
      DoMeasuringRowHeight(Index, Result);
    finally
      FDataLink.ActiveRecord := ActiveRecord;
    end;
  end
  else DoMeasuringRowHeight(Index, Result);
end;

function TNextDBGrid.GetRowVisible(Index: Integer): Boolean;
begin
  { Default, visible }
  Result := True;

  { Trigger event }
  DoRowVisible(Index, Result);
end;

function TNextDBGrid.GetSelected(Index: Integer): Boolean;
begin
  if goMultiSelect in Options then
  begin
    Result := FSelectionList.GetSelected(Index);
  end
  else Result := SelectedRow = Index;
end;

function TNextDBGrid.GetSelectedCount: Integer;
begin
  Result := FSelectionList.GetCount;
end;

function TNextDBGrid.GetSelectedRow: Integer;
begin
  { Default, in-active DataSet }
  Result := -1;

  if IsDataSetActive then
    case doBufferRecords in DataAwareOptions of
      True: Result := FDataLink.FRecNo;
      else  Result := FFirstRow + FDataLink.FRecNo;
    end;

  { Set Field }
  FSelectedRow := Result;
end;

function TNextDBGrid.GetVertMax: Integer;

  function GetRecordCount: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    
    for i := 0 to Pred(FDataLink.DataSet.RecordCount) do
      if RowVisible[i] then Inc(Result);
  end;

begin
  { Default }
  Result := 0;

  if not IsUpdating
    and IsDataSetActive
      then Result := GetVisibleRows;

end;

function TNextDBGrid.GetVisibleRows: Integer;
var
  i: Integer;
begin
  { Default }
  Result := 0;

  if FDataLink.Active then
  begin
    Result := 0;

    for i := 0 to Pred(FDataLink.DataSet.RecordCount) do
      if RowVisible[i] then Inc(Result);

    if FDataLink.DataSet.State = dsInsert
      then Inc(Result);
  end;
  
end;

function TNextDBGrid.IntegralHeight: Boolean;
begin
  Result := not(doBufferRecords in DataAwareOptions);
end;

procedure TNextDBGrid.SetDataSource(const Value: TDataSource);
begin
  FDataLink.BufferCount := 0;
  EndEditing;
  { set datasource and datalink }
  FDataSource := Value;
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
  if FDataLink.Active then FDataLink.ActiveChanged;
end;

procedure TNextDBGrid.SetHelper(const Value: TNextDBGridHelper);
begin
  FHelper := Value;
  if Assigned(FHelper) then
  begin
    FHelper.Control := Self;
  end;
end;

procedure TNextDBGrid.DoCellFormating(ACol, ARow: Integer;
  Value: WideString; var TextColor: TColor; var FontStyle: TFontStyles;
  CellState: TCellState);
begin
  if Assigned(FOnCellFormating) then FOnCellFormating(Self, ACol, ARow, Value, TextColor, FontStyle, CellState);
end;

procedure TNextDBGrid.DrawCell(ACol, ARow: Integer; CellRect: TRect);
begin
  with FDataLink do
    try
      { Save prev. ActiveRecord }
      FRecNo := ActiveRecord;

      case doBufferRecords in DataAwareOptions of
        True: ActiveRecord := ARow;
        False: ActiveRecord := ARow - FFirstRow;
      end;

      { note: calling inherited method will
              call DrawCellData() method }
      inherited DrawCell(ACol, ARow, CellRect);

    finally
      { Set back }
      ActiveRecord := FRecNo;
    end;
end;

procedure TNextDBGrid.DoColumnPlayChange(Sender: TObject);
var
  Accept: Boolean;
begin
  Accept := True;
  with Sender as TColumnPlay, FDataLink do
  begin
    DoEditAccept(Col, Row, AsString, Accept);
    if Accept then
    begin
      case Column.ColumnType of
        ctBoolean: Cells[Col, Row] := BoolToStr(AsBoolean, True);
        ctInteger: Cells[Col, Row] := IntToStr(AsInteger);
      end;
      DoAfterEdit(Col, Row, AsString);
    end;
  end;
end;

procedure TNextDBGrid.DoColumnsChange(Sender: TObject;
  ChangeOpearation: TColumnsOperation; Value1, Value2: Integer);
begin
	if (ChangeOpearation = opClear)	or (ChangeOpearation = opDelete) then EndEditing;
  UpdateHorzScrollBar;
end;

procedure TNextDBGrid.DoDeleteRecord(var Accept: Boolean);
begin
  if Assigned(FOnDeleteRecord) then FOnDeleteRecord(Self, Accept);
end;

procedure TNextDBGrid.DoColumnAdded(Column: TNxDBCustomColumn);
begin
  if Assigned(FOnColumnAdded) then FOnColumnAdded(Self, Column);
end;

procedure TNextDBGrid.DoColumnCreate(Field: TField;
  var ColumnClass: TNxDBColumnClass; var AddColumn: Boolean);
begin
  if Assigned(FOnColumnCreate) then FOnColumnCreate(Self, Field, ColumnClass, AddColumn);
end;

procedure TNextDBGrid.DoRowVisible(Index: Integer; var Visible: Boolean);
begin
  if Assigned(FOnRowVisible) then FOnRowVisible(Self, Index, Visible);
end;

procedure TNextDBGrid.DoSelectCell(ACol, ARow: Integer);
begin
  if InputSelected = False then
  begin
    MoveToRecord(ARow);
  end;
  inherited DoSelectCell(ACol, ARow);
end;

function TNextDBGrid.DrawCellData(ACol, ARow: Integer; CellState: TCellState): Boolean;
var
  DisplayText: WideString;
begin
	inherited DrawCellData(ACol, ARow, CellState);
  with GetCellInfo(ACol, ARow) do
  begin
    DisplayText := AsString;
    Columns[ACol].Display.AsBoolean := AsBoolean;
    Columns[ACol].Display.AsDateTime := AsDateTime;
    Columns[ACol].Display.AsFloat := AsFloat;
    Columns[ACol].Display.AsInteger := AsInteger;
    Columns[ACol].Display.AsString := AsString;
    Columns[ACol].Display.ObjectReference := ObjectReference;
  end;
  ApplyCellFormating(ACol, ARow, DisplayText, CellState);
  Result := True;
end;

procedure TNextDBGrid.FillDefaultValues;
var
	i: Integer;
begin
  FDataLink.DataSet.Edit; { set DataSet in edit state }
 	for i := 0 to Columns.Count - 1 do
  begin
    if (Columns[i] is TNxDBCustomColumn) and Assigned(Columns[i].Field) and Columns[i].Field.CanModify then
      Columns[i].Field.AsString := Columns[i].DefaultValue;
  end;
  FDataLink.DataSet.Post;
end;

procedure TNextDBGrid.GridStyleChanged;
begin
  inherited;
  FDataLink.RecountBufferCount;
end;

function TNextDBGrid.GetCellColor(ACol, ARow: Integer): TColor;
begin
  Result := Columns[ACol].Color;
end;

function TNextDBGrid.GetCellInfo(ACol, ARow: Integer): TCellInfo;
var
  DataField: TField;
  DataType: TFieldType;
  Graphic: TGraphic;
  C: TNxCustomColumn;
  IsNull: Boolean;
begin
  if FDataLink.Active = False then Exit;

  IsNull := False;

  C := TNxCustomColumn(Columns[ACol]);

  ZeroMemory(@Result, SizeOf(Result));

  if C is TNxDBCustomColumn then
  begin
    DataField := TNxDBCustomColumn(C).Field;

    if Assigned(DataField) then
    begin
      IsNull := DataField.IsNull;
      DataType := DataField.DataType;

      { Set DisplayText }
      if DataField.IsNull then Result.AsString := TNxDBCustomColumn(C).NullText else
      begin
        case DataType of
          {$IFDEF D2006UP}ftWideMemo,{$ENDIF}
          ftWideString : Result.AsString := TWideStringField(DataField).Value;
          else           Result.AsString := DataField.DisplayText;
        end;
      end;
      Result.AsVariant := DataField.AsVariant;
    end else
    begin
      { IsNull can't be set to True, because it will ruin OnApplyCell event }
      Result.AsVariant := Null;
    end;
  end else
  begin
    DataField := nil;
    IsNull := True;
    Result.AsString := '';
    Result.AsVariant := Null;
  end;

  if Assigned(OnApplyCell) then
  begin
    DoApplyCell(ACol, ARow, Result.AsString); { event }
    Result.AsVariant := Result.AsString;
  end;

  case C.ColumnType of
    ctAutoInc: Result.AsInteger := ARow;

    ctBoolean:
      if not IsNull then
        if not Assigned(OnApplyCell) then
        begin
          with C as TNxDBCheckBoxColumn do
          begin
            Result.AsBoolean := (ValueChecked = Result.AsString);
          end;
        end;

    ctDate:
      if not IsNull then
        if not Assigned(OnApplyCell) and Assigned(DataField) then Result.AsDateTime := DataField.AsDateTime else Result.AsDateTime := StrToDateTimeEx(Result.AsString);

    ctFloat:
      if not IsNull then
        if not Assigned(OnApplyCell) and Assigned(DataField) then Result.AsFloat := DataField.AsFloat else Result.AsFloat := StrToFloatEx(Result.AsString);

    ctInteger:
      if not IsNull then
        if not Assigned(OnApplyCell) and Assigned(DataField) then Result.AsInteger := DataField.AsInteger else Result.AsInteger := StrToIntEx(Result.AsString);

    ctString:
      if not IsNull then
        if not Assigned(OnApplyCell) and Assigned(DataField) then
        begin
          if DataField.DataType = ftWideString then
          {$IFDEF D2006UP}
            Result.AsString := DataField.AsWideString
          {$ELSE}
            Result.AsString := TWideStringField(DataField).Value
          {$ENDIF}
              else Result.AsString := DataField.DisplayText;
        end;

    ctLookup:
      with C as TNxLookupColumn do
      begin
        if not IsNull
          and Assigned(ListDataSource)
          and Assigned(ListDataSource.DataSet)
          and ListDataSource.DataSet.Active
          and Assigned(ListDataSource.DataSet.FindField(KeyFieldName))
          and Assigned(ListDataSource.DataSet.FindField(ListFieldName)) then
        begin
          Result.AsString := VarToStr(ListDataSource.DataSet.Lookup(KeyFieldName, DataField.AsVariant, ListFieldName));
        end else Result.AsString := '';
      end;

    ctGraphic:
      if Assigned(DataField) and DataField.IsBlob and (C is TNxDBGraphicColumn) then
      begin
        try
          case TNxDBGraphicColumn(Columns[ACol]).BlobType of
            btDefault:  Graphic := GetBlobGraphic(TBlobField(DataField));
            else        Graphic := GetADOBlobGraphic(TBlobField(DataField), jsEighth, jpBestSpeed);
          end;
          Result.ObjectReference := Graphic;
        except
          Result.ObjectReference := nil;
        end;
      end;

    ctMemo:
      if not IsNull and Assigned(DataField) then
      begin
        case DataField.DataType of
          ftWideString: Result.AsString := TWideStringField(DataField).Value;
          ftMemo:
            { mdContent, display content of Memo Field }
            if TNxDBMemoColumn(Columns[ACol]).MemoDisplayOptions = mdContent then
              {$IFDEF DELPHI2006}
              Result.AsString := DataField.AsWideString;
              {$ELSE}
              Result.AsString := DataField.AsString;
              {$ENDIF}
        end;
      end;

    ctVirtual:
      begin
        TNxVirtualColumn(Columns[ACol]).DoGetText(ACol, ARow, Result.AsString);
      end;
  end; { case }
end;

function TNextDBGrid.GetDrawText(ACol, ARow: Integer): WideString;
var
  DataField: TField;
  ARecNo: Integer;
begin
  with FDataLink do
  begin
    FRecNo := ActiveRecord;

    { set active record }
    if doBufferRecords in DataAwareOptions
      then ARecNo := ARow
        else ARecNo := ARow - VertScrollBar.Position;

    if ARecNo >= 0 then ActiveRecord := ARecNo;

    if Columns[ACol] is TNxDBCustomColumn then
      DataField := Columns[ACol].Field
    else DataField := nil;

    if Assigned(DataField) and DataField.IsNull then Result := Columns[ACol].NullText
      else Result := Columns[ACol].GetDrawText(GetCellInfo(ACol, ARow));

    ActiveRecord := FRecNo;
  end;
end;

function TNextDBGrid.GetFirstVisibleRow: Integer;
begin
  Result := GetFirstVisible(0);
end;

function TNextDBGrid.GetHintText(ACol, ARow: Integer): WideString;
var
  DataField: TField;
  ARecNo: Integer;
begin
  with FDataLink do
  begin
    FRecNo := ActiveRecord;

    { set active record }
    if doBufferRecords in DataAwareOptions
      then ARecNo := ARow
        else ARecNo := ARow - FFirstRow;

    if ARecNo >= 0 then ActiveRecord := ARecNo;

    if Columns[ACol] is TNxDBCustomColumn then
      DataField := Columns[ACol].Field
    else DataField := nil;

    if Assigned(DataField) and DataField.IsNull then Result := Columns[ACol].NullText
      else Result := Columns[ACol].GetHintText(GetCellInfo(ACol, ARow));

    ActiveRecord := FRecNo;
  end;
end;

function TNextDBGrid.GetLastVisibleRow: Integer;
begin
  Result := GetLastVisible(Pred(RowCount));
end;

function TNextDBGrid.AddRow(Count: Integer): Integer;
var
	i: Integer;
begin
  FDataLink.DataSet.DisableControls;
  for i := RowCount - Count to RowCount - 1 do
  begin
    FDataLink.DataSet.Append;
    if goUseDefaultValues in Options then FillDefaultValues;
  end;
  FDataLink.DataSet.EnableControls;
  FDataLink.RecountBufferCount;
  Result := DataLink.FRecordCount;
  Invalidate;
end;

procedure TNextDBGrid.AddRowFromInput;
var
  i: Integer;
  Accept: Boolean;
  NewText: WideString;
  DataField: TField;
begin
  if not FDataLink.DataSet.Active then Exit;
  Accept := True;
  DoInputAccept(Accept); { event }
  if Accept then
  begin
    FDataLink.DataSet.Append;
    for i := 0 to Pred(Columns.Count) do
    begin
      NewText := Columns[i].InputValue;
      if NewText = '' then NewText := Columns[i].DefaultValue;

      if Columns[i] is TNxDBCustomColumn then
        DataField := Columns[i].Field
      else DataField := nil;

      if Assigned(DataField) and DataField.CanModify then
      begin
        if NewText <> '' then Columns[i].ApplyField(NewText);
        Columns[i].InputValue := '';
      end;
    end;
    FDataLink.DataSet.Post;
    ScrollToRow(Pred(RowCount));
    DoInputAdded; { event }
  end;
end;

procedure TNextDBGrid.ClearRows;
var
	i: Integer;
begin
  inherited ClearRows;
  if FDataLink.Active then
  begin
    FUpdating := True;
		if doBufferRecords in DataAwareOptions then
    begin
	  	FDataLink.DataSet.DisableControls;
  		FDataLink.ActiveRecord := 0;
	  	for i := 0 to FDataLink.RecordCount - 1 do FDataLink.DataSet.Delete;
  		FDataLink.BufferCount := 0;
	  	FDataLink.DataSet.EnableControls;
    	RefreshArea(gaBody);
    end else
    begin

    end;
    FUpdating := False;
  end;
end;

procedure TNextDBGrid.ClearSelection;
begin
  FSelectionList.Clear;
end;

procedure TNextDBGrid.CreateColumns;
var
	I: Integer;
  AColumn: TNxDBCustomColumn;
  AddColumn: Boolean;
  AField: TField;
  ColumnClass: TNxDBColumnClass;
begin
  if doAddIncrementColumn in DataAwareOptions
    then Columns.Add(TNxDBIncrementColumn, True);
	for i := Columns.Count to FDataLink.DataSet.FieldCount - 1 do
  begin
    AField := FDataLink.DataSet.Fields[i];
    case AField.FieldKind of
      fkData:
      case AField.DataType of
        ftString, ftUnknown, ftTime, ftWideString, ftGuid,
          ftFixedChar: ColumnClass := TNxDBTextColumn;
        ftFloat, ftInteger, ftSmallint, ftWord, ftCurrency, ftAutoInc,
          ftLargeint, ftBCD, ftFmtBCD: ColumnClass := TNxDBNumberColumn;
        ftMemo, ftFmtMemo: ColumnClass := TNxDBTextColumn;
        ftBoolean: ColumnClass := TNxDBCheckBoxColumn;
        ftDate, ftDateTime: ColumnClass := TNxDBDateColumn;
        ftGraphic, ftBytes, ftVarBytes: ColumnClass := TNxDBGraphicColumn;
        else ColumnClass := TNxDBTextColumn;  
      end;
      fkLookup: ColumnClass := TNxLookupColumn;
    end;

    AddColumn := AField.Visible;
    DoColumnCreate(AField, ColumnClass, AddColumn); { event }
    if AddColumn then
    begin
      AColumn := ColumnClass.Create(Owner);
      try
        Columns.AddColumn(AColumn, True);
        AColumn.Name := Columns.UniqueName(AColumn.ClassName);
        AColumn.Field := AField;
        AColumn.Header.Caption := AField.DisplayName;
        AColumn.ParentFont := True;
        if doSetColumnWidth in DataAwareOptions then
          AColumn.Width := AField.DisplayWidth;
        DoColumnAdded(AColumn); { event }
      except
        AColumn.Free;
      end;
    end;
  end;
end;

procedure TNextDBGrid.DeleteRow(ARow: Integer);
begin
  if doBufferRecords in DataAwareOptions then FDataLink.ActiveRecord := ARow
    else FDataLink.ActiveRecord := ARow - FFirstRow;
  FDataLink.DataSet.Delete;
end;

procedure TNextDBGrid.EndEditing;
begin
  inherited;
  if doImmediatePost in FDataAwareOptions then
  begin
    if IsDataSetActive and (FDataLink.DataSet.State = dsEdit)
      then FDataLink.DataSet.Post;
  end;
end;

procedure TNextDBGrid.InsertRow(Pos: Integer; Count: Integer);
var
	InsRect: TRect;
begin
	with FDataLink do
  begin
    FUpdating := True;
		if doBufferRecords in DataAwareOptions then
    begin
			InsRect := GetRowRect(Pos);
    	InsRect.Bottom := GetBodyRect.Bottom;
		  ActiveRecord := Pos;
		  DataSet.Insert;
		  FillDefaultValues;
      RefreshRect(InsRect);
    end else
    begin

    end;
		FUpdating := False;
  end;
end;

procedure TNextDBGrid.MoveSelectionDown(Shift: TShiftState;
  NextControl: Boolean; SelectFirst: Boolean);
var
  I, R: Integer;
begin
  if BufferedMode then
  begin
    inherited;
    
    Exit;
  end;

  R := -1;

  if InputSelected then
  begin
    InputSelected := False;
    if GetRowCount > 0 then R := 0;
  end
  else
  begin
    if SelectedRow >= Pred(RowCount) then
    begin
      if NextControl
        then SelectNextControl;

      if SelectFirst then SelectFirstRow;

      Exit;
    end;

    { Find 1st next row }
    for I := Succ(SelectedRow) to Pred(GetRowCount) do
      if (GetRowVisible(i)) and (i <> SelectedRow) then
      begin
        R := I;
        Break;
      end;
  end;

  if R = -1 then Exit;

  { Record outside buffer? }
  if Succ(DataLink.ActiveRecord) > Pred(DataLink.BufferCount) then
  begin
    SendMessage(Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  end
    else SelectCell(SelectedColumn, R, Shift);
end;

procedure TNextDBGrid.MoveSelectionUp(Shift: TShiftState);
var
  I, R: Integer;
begin
  if BufferedMode then
  begin
    inherited;

    Exit;
  end;

  R := 0;
  if (SelectedRow = 0) and (goInput in Options)
    and (GridStyle = gsReport) then
  begin
    InputSelected := True;
    Exit;
  end;

  if (not InputSelected) and (RowCount > 0) then
    for I := SelectedRow downto 0 do
      if (GetRowVisible(I)) and (I <> SelectedRow) then begin
        R := I;
        Break;
      end;

  if FDataLink.ActiveRecord = 0 then
  begin
    SendMessage(Handle, WM_VSCROLL, SB_LINEUP, 0);
  end;

  SelectCell(SelectedColumn, R, Shift);
end;

procedure TNextDBGrid.SelectFirstRow;
begin
  if IsDataSetActive then
  begin
    InputSelected := False;
    if BufferedMode then SelectedRow := FirstVisibleRow else
    begin
      VertScrollBar.First;
      FDataLink.DataSet.First;
      RefreshSelectedCells;
    end;
  end;
end;

procedure TNextDBGrid.SelectLastRow;
begin
  if IsDataSetActive then
  begin
    InputSelected := False;
    if BufferedMode then SelectedRow := LastVisibleRow else
    begin
      ScrollToRow(Pred(RowCount));
      RefreshSelectedCells;
    end;
  end;
end;

procedure TNextDBGrid.SelectRange(FromRow, ToRow: Integer; Value: Boolean);
var
  I: Integer;
begin
  if FromRow <> ToRow then
  begin
    if RowExist(FromRow) and RowExist(ToRow) then
    begin
      for I := FromRow to ToRow do FSelectionList.SetSelected(I, Value);
      RefreshRange(FromRow, ToRow);
    end;
    Include(FGridState, gtMultiSelect);
  end;
end;

procedure TNextDBGrid.SortColumn(AColumn: TNxCustomColumn;
  Asending: Boolean);
begin
  inherited SortColumn(AColumn, Asending);
  if SortedColumn <> nil then Refresh;
end;

procedure TNextDBGrid.Paint;
begin
  inherited Paint;
  if not(doBufferRecords in DataAwareOptions) then
  begin
    VertScrollClipRect := Rect(0, GetBodyRect.Top, GetBodyRect.Right, GetBodyRect.Top + FBottomLimit);
  end;

  {$IFDEF NX_DEBUG}
  if FDataLink.Active then
    with Canvas do
    begin
      Brush.Color := clAqua;
      Canvas.Font.Color := clBlack;
//      TextRect(Rect(10, 0, 60, 18), 10, 0, 'PagS: ' + IntToStr(VertScrollBar.PageSize));
//      TextRect(Rect(10, 20, 60, 38), 10, 20, 'Max: ' + IntToStr(VertScrollBar.Max));
//      TextRect(Rect(10, 40, 90, 58), 10, 40, 'RecCount: ' + IntToStr(DataSource.DataSet.RecordCount));
    end;

  if FDataLink.Active then
    with Canvas do
    begin
      Brush.Color := clAqua;
      Canvas.Font.Color := clBlack;
      TextRect(Rect(10, 0, 60, 18), 10, 0, 'AC: ' + IntToStr(FDataLink.ActiveRecord));
      TextRect(Rect(60, 0, 120, 18), 60, 0, 'BC: ' + IntToStr(FDataLink.BufferCount));
      TextRect(Rect(120, 0, 180, 18), 120, 0, 'FR RW: ' + IntToStr(FFirstRow));
      TextRect(Rect(220, 0, 300, 18), 220, 0, 'VS CO: ' + IntToStr(GetPageRecordCount(True).Count) + ' ' + IntToStr(GetPageRecordCount(True).VisibleCount));
//      TextRect(Rect(120, 0, 180, 18), 120, 0, 'FRC: ' + IntToStr(FDataLink.FRecNo));
//      TextRect(Rect(120, 0, 180, 18), 120, 0, 'SR: ' + IntToStr(FSelectedRow));
      if FDataLink.Eof then
      begin
        TextRect(Rect(180, 0, 220, 18), 180, 0, 'EOF: Yes');
      end;
//      TextRect(Rect(220, 0, 300, 18), 240, 0, '| RC: ' + IntToStr(FDataLink.DataSet.RecordCount));
    end;
  {$ENDIF}
end;

procedure TNextDBGrid.WMSize(var Message: TWMSize);
var
  Delta: Integer;
begin
	inherited;
  if IsDataSetActive then
  begin
    if not BufferedMode
      and (FVertResizeKind = rkShrink)
      and (FDataLink.ActiveRecord = Pred(FDataLink.BufferCount)) then
//      and {FDataLink.Eof and}
    begin
      Delta := GetPageRecordCount(True).Count - FDataLink.RecordCount;
      if Delta <> 0 then FDataLink.MoveBy(Delta);
    end;

    FDataLink.RecountBufferCount;

    if not BufferedMode then
    begin
      { 3/23/07:  when grid is not in buffered mode, last visible
                  must be refreshed [solved] }
      case GridStyle of
        gsReport: RefreshRow(Pred(FLastRow));
        gsSlides: RefreshSlide(Pred(FLastRow));
      end;
    end;
  end;
  {$IFDEF NX_DEBUG}
  RefreshArea(gaHeader);
  {$ENDIF}
end;

procedure TNextDBGrid.WMVScroll(var Message: TWMVScroll);
var
	PrevFirst, Delta: Integer;
  SI: TScrollInfo;

  function InvisibleCount(FromPos, ToPos: Integer): Integer;
  var
    i: Integer;
  begin
    Result := 0;

    for i := FromPos to ToPos do
    begin
      if not RowVisible[i] then Inc(Result);
    end;

  end;
begin
  { ToDo: add to v6 too }
  if not CanScroll(VertScrollBar, Message.ScrollCode)
    then Exit;

  { fix AV when scrolling }
  if gtEdit in GridState then EndEditing;

  try
    FUpdating := True;
    Include(FDataState, dsScrolling);

    { Pre-procssing }
    if IsDataSetActive and not BufferedMode then
    begin

      with Message, FDataLink do

        case ScrollCode of
          SB_LINEDOWN:
            MoveBy(RecordCount - ActiveRecord);

          SB_LINEUP:
            if VertScrollBar.Position > 0 then MoveBy(-Pred(ActiveRecord));

          SB_PAGEDOWN:
            begin
              ActiveRecord := Pred(RecordCount);
              MoveBy(VertScrollBar.LargeChange);
            end;

          SB_PAGEUP:
            begin
              ActiveRecord := 0;
              MoveBy(-VertScrollBar.LargeChange);
            end;

          SB_THUMBTRACK, SB_THUMBPOSITION:
            begin
              if (Message.ScrollCode = SB_THUMBTRACK)
                and not FTracking then Exit;

              if DataSet.IsSequenced and FSequencedScroll then
              begin
                SI.cbSize := sizeof(SI);
                SI.fMask := SIF_ALL;
                GetScrollInfo(Self.Handle, SB_VERT, SI);
                if SI.nTrackPos <= 1 then DataSet.First
                else if SI.nTrackPos >= DataSet.RecordCount then DataSet.Last
                else DataSet.RecNo := SI.nTrackPos;
              end else
              begin

                Delta := Message.Pos - VertScrollBar.Position;

                { Scroll down }
                if Delta > 0 then
                begin
                  ActiveRecord := Pred(RecordCount);
                  MoveBy(Delta);
                end

                { Scroll up }
                else if Delta < 0 then
                begin
                  ActiveRecord := 0;
                  MoveBy(Delta);
                end

                { No scroll }
                else Exit;
              end;
              
            end;

          SB_BOTTOM:
          begin
            DataSet.Last;
            Invalidate;
          end;

          SB_TOP:
          begin
            DataSet.First;
            Invalidate;
          end;
        end;
    end;

  PrevFirst := FFirstRow;

  { Scrolling pixels, updating First index,
    scroll bars, etc. }
	inherited;
                 
  { Post-processing }
  if IsDataSetActive and not BufferedMode then
    with Message, FDataLink do
      case ScrollCode of
        SB_LINEDOWN: MoveBy(Pred(FFirstRow - PrevFirst));
        SB_LINEUP: MoveBy(Pred(FFirstRow - PrevFirst));
        SB_TOP, SB_BOTTOM, SB_PAGEDOWN, SB_PAGEUP:
        begin
          { Notice: DataSetScrolled don't occur on
                    DataSet.First & DataSet.Last }
          DataLink.RecountBufferCount;
        end;
        SB_THUMBPOSITION, SB_THUMBTRACK:
        begin
          if Delta > 0
            then
              MoveBy(InvisibleCount(PrevFirst, FFirstRow))
            else
              MoveBy(-InvisibleCount(FFirstRow, PrevFirst))
        end;
      end;

  finally
    FUpdating := False;
    Exclude(FDataState, dsScrolling);
  end;

  if IsDataSetActive
    and not BufferedMode
      then SetSelectedCell(SelectedColumn, GetSelectedRow);

{$IFDEF NX_DEBUG}
  Invalidate;
{$ENDIF}
end;

procedure TNextDBGrid.PrintInHelper(S: string);
begin
  if Assigned(FHelper) then FHelper.Print(S);
end;

{$IFDEF NX_DEBUG}
procedure TNextDBGrid.Test;
begin
  ShowMessage(IntToStr(FDataLink.BufferCount));
  FDataLink.RecountBufferCount(False);
//  FDataLink.BufferCount := 18;
  ShowMessage(IntToStr(FDataLink.BufferCount));

//  DataLink.MoveBy(DataLink.RecordCount - DataLink.ActiveRecord);
//  Invalidate;
//  VertScrollBar.Position := 1;
end;

function TNextDBGrid.GetDraw(ACol, ARow: Integer): WideString;
begin
  if IsDataSetActive then
    Result := GetDrawText(ACol, ARow);
end;
{$ENDIF}

constructor TNextDBGridHelper.Create(AOwner: TComponent);
begin
  inherited;
  FControl := TNextDBGrid(AOwner);
  FControl.Helper := Self;
end;

procedure TNextDBGridHelper.Paint;
var
  Y, i, PrevActiveRecord: Integer;
begin
  inherited;
  Y := 60;

  with Canvas, FControl do
  begin

    if DataLink.Active and Assigned(FControl) then
    begin
      TextOut(0, 0, 'BufferCount: ' + IntToStr(DataLink.BufferCount));
      TextOut(0, 20, 'RecNo:      ' + IntToStr(DataLink.DataSet.RecNo));
      TextOut(80, 0, 'Delta:      ' + IntToStr(DataLink.RecordCount - DataLink.ActiveRecord));

      try
        PrevActiveRecord := DataLink.ActiveRecord;

        DataLink.ActiveRecord := 0;

        for i := 0 to DataLink.BufferCount do
        begin

          TextOut(8, Y, DataLink.DataSet.Fields[1].AsString);


          DataLink.ActiveRecord := DataLink.ActiveRecord + 1;

          Inc(Y, 16);
        end;

      finally
        DataLink.ActiveRecord := PrevActiveRecord;
      end;

    end;

  end;

end;

procedure TNextDBGridHelper.Print(S: string);
begin
  with Canvas, FControl do
  begin
    Canvas.Brush.Color := clRed;
    Canvas.Font.Color := clWhite;
    TextRect(Bounds(0, 0, 100, 20), 0, 0, 'Output: ' + S);
  end;
end;

end.
