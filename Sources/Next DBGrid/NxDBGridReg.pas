{
  Next Grid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:Next NxDBGridReg.pas 12/25/2002 7:10:18 bn
}

unit NxDBGridReg;

interface

uses
 	DesignIntf, DesignEditors, Classes, Dialogs,
  NxGridReg, NxDBGrid, NxColumns, NxDBColumns, NxDBColumnEditor;

type
  TNxDBColumnsProperty = class(TNxColumnsProperty)
  protected
  	function GetColumnFormClass: TColumnFormClass; override;
  public
    function GetValue: string; override;
  end;

  TNxFieldNameProperty = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TNxLookupListProperty = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TNxLookupKeyFieldProperty = class(TNxLookupListProperty)
  public
		function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TNxLookupListFieldProperty = class(TNxLookupListProperty)
  public
		function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Next Suite', [TNextDBGrid]);
  RegisterPropertyEditor(TypeInfo(TNxDBColumns), TNextDBGrid, 'Columns', TNxDBColumnsProperty);
  RegisterPropertyEditor(TypeInfo(string), TNxDBCustomColumn, 'FieldName', TNxFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TNxLookupColumn, 'KeyFieldName', TNxLookupKeyFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TNxLookupColumn, 'ListFieldName', TNxLookupListFieldProperty);
  RegisterNoIcon([TNxDBButtonColumn, TNxDBCalcColumn, TNxDBGraphicColumn, TNxDBCheckBoxColumn, TNxDBDateColumn, TNxDBHtmlColumn,
    TNxDBImageColumn, TNxDBIncrementColumn, TNxDBComboBoxColumn, TNxDBListColumn, TNxDBMemoColumn, TNxDBNumberColumn, TNxDBProgressColumn, TNxDBRateColumn,
    TNxDBTextColumn, TNxDBTimeColumn, TNxLookupColumn]);
  RegisterClasses([TNxDBButtonColumn, TNxDBCalcColumn, TNxDBGraphicColumn, TNxDBCheckBoxColumn, TNxDBDateColumn, TNxDBHtmlColumn,
    TNxDBImageColumn, TNxDBIncrementColumn, TNxDBComboBoxColumn, TNxDBListColumn, TNxDBMemoColumn, TNxDBNumberColumn, TNxDBProgressColumn, TNxDBRateColumn,
    TNxDBTextColumn, TNxDBTimeColumn, TNxLookupColumn]);
end;

{ TNxDBColumnsProperty }

function TNxDBColumnsProperty.GetColumnFormClass: TColumnFormClass;
begin
  Result := TDBColumnForm;
end;

function TNxDBColumnsProperty.GetValue: string;
begin
  Result := '(' + TNextDBGrid(GetComponent(0)).Columns.ClassName +  ')';
end;

{ TFieldsListProperty }

function TNxFieldNameProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paValueList];
end;

function TNxFieldNameProperty.GetValue: string;
begin
	Result := (GetComponent(0) as TNxDBCustomColumn).FieldName;
end;

procedure TNxFieldNameProperty.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  Column: TNxCustomColumn;
  DBGrid: TNextDBGrid;
begin
  Column := GetComponent(0) as TNxCustomColumn;
  DBGrid := TNextDBGrid(Column.GridComponent);
	if Assigned(DBGrid.DataSource)
    and Assigned(DBGrid.DataSource.DataSet) then
  begin
	  for i := 0 to DBGrid.DataSource.DataSet.FieldCount - 1 do
	    Proc(DBGrid.DataSource.DataSet.Fields[i].FieldName);

    { Aggregate Fields }
	  for i := 0 to DBGrid.DataSource.DataSet.AggFields.Count - 1 do
	    Proc(DBGrid.DataSource.DataSet.AggFields[i].FieldName);
  end;
end;

procedure TNxFieldNameProperty.SetValue(const Value: string);
begin
  inherited;
	(GetComponent(0) as TNxDBCustomColumn).FieldName := Value;
  Designer.Modified;
end;

{ TLookupListProperty }

function TNxLookupListProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paValueList];
end;

procedure TNxLookupListProperty.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  Column: TNxLookupColumn;
begin
  Column := GetComponent(0) as TNxLookupColumn;
	if Assigned(Column.ListDataSource) and Assigned(Column.ListDataSource.DataSet) then
	  for i := 0 to Column.ListDataSource.DataSet.FieldCount - 1 do
	    Proc(Column.ListDataSource.DataSet.Fields[i].FieldName);
end;

{ TLookupKeyFieldListProperty }

function TNxLookupKeyFieldProperty.GetValue: string;
begin
	Result := (GetComponent(0) as TNxLookupColumn).KeyFieldName;
end;

procedure TNxLookupKeyFieldProperty.SetValue(const Value: string);
begin
  inherited;
	(GetComponent(0) as TNxLookupColumn).KeyFieldName := Value;
end;

{ TLookupListFieldProperty }

function TNxLookupListFieldProperty.GetValue: string;
begin
	Result := (GetComponent(0) as TNxLookupColumn).ListFieldName;
end;

procedure TNxLookupListFieldProperty.SetValue(const Value: string);
begin
  inherited;
	(GetComponent(0) as TNxLookupColumn).ListFieldName := Value;
end;

end.
