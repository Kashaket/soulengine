{
  Add Ons 1.1
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxCellSource.pas
}

unit NxCellSource;

interface

uses
  Windows, Messages, SysUtils, Classes, DB, NxGrid, NxColumns, NxColumnClasses;

type
	TAddRowEvent = procedure (Sender: TObject; Index: Integer) of object;
  TCellLoadEvent = procedure (Sender: TObject; ACol, ARow: Integer) of object;

  TNxCustomCellSource = class(TComponent)
  private
    FActive: Boolean;
    FCalculateFooter: Boolean;
    FAssociate: TNextGrid;
    FOnAddRow: TAddRowEvent;
    FOnCellLoad: TCellLoadEvent;
    procedure SetGrid(const Value: TNextGrid);
    procedure SetActive(const Value: Boolean);
  protected
    function IsReady: Boolean; virtual; abstract;
  	procedure DoAddRow(Index: Integer); dynamic;
  	procedure DoCellLoad(ACol, ARow: Integer); dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute: Boolean; virtual;
    function Update: Boolean; virtual;
    constructor Create(AOwner: TComponent); override;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Associate: TNextGrid read FAssociate write SetGrid;
    property CalculateFooter: Boolean read FCalculateFooter write FCalculateFooter default False;
    property OnAddRow: TAddRowEvent read FOnAddRow write FOnAddRow;
    property OnCellLoad: TCellLoadEvent read FOnCellLoad write FOnCellLoad;
  end;

  TNxDataCellSource = class(TNxCustomCellSource)
  private
    FDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
  protected
    procedure AddColumns; virtual;
    function IsReady: Boolean; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Execute: Boolean; override;
    function Update: Boolean; override;
  published
    property DataSet: TDataSet read FDataSet write SetDataSet;
  end;

implementation

{ TNxCustomCellSource }

constructor TNxCustomCellSource.Create(AOwner: TComponent);
begin
  inherited;
  FActive := False;
  FCalculateFooter := False;
  FAssociate := nil;
end;

procedure TNxCustomCellSource.SetActive(const Value: Boolean);
begin
  if Assigned(FAssociate) then
  begin
    FActive := Value;
    if Value = True then Execute else FAssociate.ClearRows;
  end;
end;

procedure TNxCustomCellSource.SetGrid(const Value: TNextGrid);
begin
  if FAssociate <> Value then
  begin
    FAssociate := Value;
    if Value <> nil then FreeNotification(FAssociate)
      else RemoveFreeNotification(FAssociate);
  end;
end;

procedure TNxCustomCellSource.DoAddRow(Index: Integer);
begin
  if Assigned(FOnAddRow) then FOnAddRow(Self, Index);
end;

procedure TNxCustomCellSource.DoCellLoad(ACol, ARow: Integer);
begin
  if Assigned(FOnCellLoad) then FOnCellLoad(Self, ACol, ARow);
end;

function TNxCustomCellSource.Execute: Boolean;
begin
  Result := IsReady;
end;

function TNxCustomCellSource.Update: Boolean;
begin
  Result := IsReady;
end;

procedure TNxCustomCellSource.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FAssociate) and (Operation = opRemove) then FAssociate := nil;
end;

{ TNxDataCellSource }

procedure TNxDataCellSource.AddColumns;
var
  I: Integer;
  Column: TNxCustomColumn;
  ColumnClass: TNxColumnClass;
begin
  if Associate.Columns.Count = 0 then begin
    for I := 0 to FDataSet.FieldCount - 1 do
    begin
      case FDataSet.Fields[I].DataType of
        ftBoolean: ColumnClass := TNxCheckBoxColumn;
        ftFloat, ftLargeint, ftInteger, ftWord, ftSmallint, ftCurrency: ColumnClass := TNxNumberColumn;
        ftDate, ftDateTime: ColumnClass := TNxDateColumn;
        else ColumnClass := TNxTextColumn;
      end;
      Column := ColumnClass.Create(FAssociate.Owner);
      try
        if csDesigning in ComponentState
          then Column.Name := Associate.Columns.UniqueName(Column.ClassName);
        Column.Options := Column.Options + [coPublicUsing];
        Column.Header.Caption := FDataSet.Fields[I].FieldName;
        Associate.Columns.AddColumn(Column);
      except
        Column.Free;
      end;
    end;
  end;
end;

function TNxDataCellSource.Execute;
var
  i, CurrFld, CurrCol: Integer;
begin
  Result := False;
  if not inherited Execute then Exit;
  AddColumns;
  Associate.BeginUpdate;
  Associate.ClearRows;
	try
    try
      FDataSet.First;
      for i := 1 to FDataSet.RecordCount do
      begin
        CurrCol := 0;
        CurrFld := 0;
        Associate.AddRow;
        while (CurrCol < Associate.Columns.Count) and (CurrFld < FDataSet.FieldCount) do
        begin
          while not(coPublicUsing in Associate.Columns[CurrCol].Options) do
          begin
            Inc(CurrCol);
            if CurrCol >= Associate.Columns.Count then Break;
          end;
          if Associate.Columns.Count > CurrCol then
          begin
          	with FDataSet do
	          	case Fields[CurrFld].DataType of
                ftBoolean: Associate.Cell[CurrCol, i - 1].AsBoolean := Fields[CurrFld].AsBoolean;
	              ftDate, ftDateTime: Associate.Cell[CurrCol, i - 1].AsDateTime := Fields[CurrFld].AsDateTime;
                ftTime, ftTimeStamp: Associate.Cell[CurrCol, i - 1].AsString := Fields[CurrFld].AsString;
	              ftFloat, ftCurrency: Associate.Cell[CurrCol, i - 1].AsFloat := Fields[CurrFld].AsFloat;
								ftInteger, ftWord, ftSmallint, ftBytes, ftAutoInc, ftLargeint: Associate.Cell[CurrCol, i - 1].AsInteger := Fields[CurrFld].AsInteger;
								else Associate.Cell[CurrCol, i - 1].AsString := Fields[CurrFld].AsString;
	            end;
            DoCellLoad(CurrCol, i - 1);
          end;
          Inc(CurrFld);
          Inc(CurrCol);
        end;
        FDataSet.Next;
        DoAddRow(i - 1);
      end;
    except
      Result := False;
      Exit;
    end;
  finally
	  Associate.EndUpdate;
  end;
  if CalculateFooter then Associate.CalculateFooter; 
  Result := True;
end;

function TNxDataCellSource.IsReady: Boolean;
begin
  Result := (Assigned(Associate)) and (Assigned(FDataSet))
    and (not DataSet.IsUniDirectional) and (FDataSet.Active);
end;

procedure TNxDataCellSource.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;

function TNxDataCellSource.Update: Boolean;
var
  i, CurrFld, CurrCol: Integer;
begin
  Result := False;
  if not inherited Execute then Exit;
  Associate.BeginUpdate;
	try
    try
      FDataSet.First;
      for i := 1 to FDataSet.RecordCount do
      begin
        CurrCol := 0;
        CurrFld := 0;
        if Associate.RowCount < i then Associate.AddRow;
        while (CurrCol < Associate.Columns.Count) and (CurrFld < FDataSet.FieldCount) do
        begin
          while not(coPublicUsing in Associate.Columns[CurrCol].Options) do
          begin
            Inc(CurrCol);
            if CurrCol >= Associate.Columns.Count then Break;
          end;
          if (Associate.Columns.Count > CurrCol)
          	and (Associate.Cells[CurrCol, i - 1] <> FDataSet.Fields[CurrFld].AsString)
            	then
          begin
            Associate.Cells[CurrCol, i - 1] := FDataSet.Fields[CurrFld].AsString;
          end;
          Inc(CurrFld);
          Inc(CurrCol);
        end;
        FDataSet.Next;
      end;
    except
      Result := False;
      Exit;
    end;
  finally
	  Associate.EndUpdate;
  end;
  Result := True;
end;

procedure TNxDataCellSource.SetDataSet(const Value: TDataSet);
begin
  if FDataSet <> Value then
  begin
    FDataSet := Value;
    if Value <> nil then
    begin
      FreeNotification(FDataSet);
      if FActive and FDataSet.Active then Execute;
    end else RemoveFreeNotification(FDataSet);
  end;
end;

end.
