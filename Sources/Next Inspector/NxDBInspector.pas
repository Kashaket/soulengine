{
  Next DBInspector
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxDBInspector.pas bn
}

unit NxDBInspector;

interface

uses
  Classes, NxInspector, NxPropertyItems, NxDBPropertyItems, DB, Dialogs, Windows,
  NxClasses;

type
  TNextDBInspector = class;
  TPropertiesState = set of (psUpdating);

  TItemDataLink = class(TDataLink)
  private
    FOwner: TNextDBInspector;
  protected
  	procedure ActiveChanged; override;
    procedure DataSetChanged; override;
		procedure DataSetScrolled(Distance: Integer); override;
    procedure RecordChanged(Field: TField); override;
    procedure SetField(Field: TField; Item: TNxPropertyItem);
    procedure UpdateItem(Field: TField);
    procedure UpdateItems;
  public
    constructor Create(AOwner: TNextDBInspector);
  end;

  TNextDBInspector = class(TNextInspector)
  private
    FDataLink: TItemDataLink;
    FDataSource: TDataSource;
    FPropertiesState: TPropertiesState;
    procedure SetDataSource(const Value: TDataSource);
  protected
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure ValueChanged(Item: TNxPropertyItem; const Value: WideString); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property PropertiesState: TPropertiesState read FPropertiesState;
  published
  	property DataSource: TDataSource read FDataSource write SetDataSource;
  end;

implementation

uses
  Menus, Variants;

var
  Registered: Boolean = False;

procedure ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(HotKey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
  Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
  Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
  Modifiers := Modifiers or MOD_CONTROL;
end;

{ TItemDataLink }

constructor TItemDataLink.Create(AOwner: TNextDBInspector);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TItemDataLink.ActiveChanged;
begin
  inherited;
  if Assigned(DataSet) and DataSet.Active then UpdateItems;
end;

procedure TItemDataLink.DataSetChanged;
begin
  inherited;
  UpdateItems;
end;

procedure TItemDataLink.DataSetScrolled(Distance: Integer);
begin
  inherited;
  UpdateItems;
end;

procedure TItemDataLink.UpdateItems;
var
  i: Integer;
  DataField: TField;
begin
  if FOwner.IsUpdating then Exit;
  with FOwner do
  Include(FPropertiesState, psUpdating);
  for i := 0 to FOwner.Items.Count - 1 do
    with FOwner.Items[i] do
    begin
      DataField := DataSet.Fields.FindField(FieldName);
      if Assigned(DataField) then
      begin
        if not DataField.IsNull then
        begin
          if (FOwner.Items[i] is TNxDBComboBoxItem) then UpdateField(DataField.Value)
            else
          case DataField.DataType of
            ftString: AsString := DataField.DisplayText;
            ftWideString: AsString := TWideStringField(DataField).Value;
            ftInteger, ftWord, ftSmallint, ftAutoInc, ftLargeint: AsInteger := DataField.AsInteger;
            ftFloat, ftCurrency, ftBCD, ftFMTBcd: AsFloat := DataField.AsFloat;
            ftBoolean: AsBoolean := DataField.AsBoolean;
            ftDate, ftDatetime, ftTime, ftTimeStamp: AsDatetime := DataField.AsDateTime;
            ftMemo: AsString := DataField.AsString;
            { case }
            else AsString := DataField.AsString;
          end;
        end else AsString := ''; // IsNull
      end;
      UpdateEditor;
    end;
  with FOwner do Exclude(FPropertiesState, psUpdating);
end;


procedure TItemDataLink.RecordChanged(Field: TField);
begin
  inherited;
  UpdateItem(Field);
end;

procedure TItemDataLink.UpdateItem(Field: TField);
var
  i: Integer;
  Item: TNxPropertyItem;
begin
  if FOwner.IsUpdating then Exit;
  if Assigned(Field) then
    with FOwner do
    begin
      { Start updating }
      Include(FPropertiesState, psUpdating);

      { Loop trough items }
      for i := 0 to Items.Count - 1 do
      begin
        Item := Items[i];
        if Field.FieldName = Item.FieldName then
        begin
          SetField(Field, Item);
          if (Item = SelectedItem) and Assigned(Item.Editor)
            then Item.UpdateEditor;
        end;
      end;

      { Exit from updating state }
      Exclude(FPropertiesState, psUpdating);
    end;
end;

procedure TItemDataLink.SetField(Field: TField; Item: TNxPropertyItem);
begin
  if Field.IsNull then Item.AsString := '' else
    if (Item is TNxDBComboBoxItem)
      then Item.UpdateField(Field.Value) else
    begin
      case Field.DataType of
        ftString: Item.AsString := Field.DisplayText;
        ftWideString: Item.AsString := TWideStringField(Field).Value;
        ftInteger, ftWord, ftSmallint, ftAutoInc: Item.AsInteger := Field.AsInteger;
        ftLargeint:
        begin
          if Field is TLargeintField then
          begin
            Item.AsInteger := TLargeintField(Field).AsLargeInt;
          end
          else Item.AsInteger := Field.AsInteger;
        end;
        ftFloat, ftCurrency, ftBCD, ftFMTBcd: Item.AsFloat := Field.AsFloat;
        ftBoolean: Item.AsBoolean := Field.AsBoolean;
        ftDate, ftDatetime, ftTime, ftTimeStamp: Item.AsDatetime := Field.AsDateTime;
        ftMemo: Item.AsString := Field.AsString;
        { case }
        else Item.AsString := Field.AsString;
      end;
    end;
end;

{ TNextDBInspector }

constructor TNextDBInspector.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TItemDataLink.Create(Self);
end;

destructor TNextDBInspector.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

procedure TNextDBInspector.CreateWnd;
begin
  inherited;
  if Assigned(DataSource) then FDataLink.DataSource := DataSource;
end;

procedure TNextDBInspector.KeyDown(var Key: Word; Shift: TShiftState);
var
  ShortCutKey: Word;
  Modifiers: Uint;
  DataField: TField;
begin
  inherited;
  if SelectedItem is TNxDBLookupItem then
    with SelectedItem as TNxDBLookupItem do
  begin
    ShortCutToHotKey(NullValueKey, ShortCutKey, Modifiers);
    if Key = ShortCutKey then
    begin
      DataField := FDataLink.DataSet.FindField(SelectedItem.FieldName);
      if DataField <> nil then
      begin
        FDataLink.DataSet.Edit;
        DataField.Clear;
        UpdateEditor;
      end;
    end;
  end;
end;

procedure TNextDBInspector.SetDataSource(const Value: TDataSource);
begin
  FDataSource := Value;
  FDataLink.DataSource := Value;
	if Assigned(Value) and Assigned(Value.DataSet) then FDataLink.ActiveChanged;
end;

procedure TNextDBInspector.ValueChanged(Item: TNxPropertyItem;
  const Value: WideString);
var
  DataField: TField;
begin
  inherited;
  if psUpdating in FPropertiesState then Exit;
  if not FDataLink.Active then Exit;
  if Item.FieldName = '' then Exit;
  DataField := FDataLink.DataSet.FindField(Item.FieldName);
  if Assigned(DataField) then
  begin
    with FDataLink do
    begin
 	    DataSet.Edit;
      case Item.DataType of
        idtBoolean:   DataField.AsBoolean := Item.AsBoolean;
        idtDateTime:  DataField.AsDateTime := Item.AsDateTime;
        idtFloat:     DataField.AsFloat := Item.AsFloat;
        idtInteger:   DataField.AsInteger := Item.AsInteger;
        idtLookup:    with Item as TNxDBLookupItem do
                      begin
                        DataField.Value := ListDataSource.DataSet.Lookup(ListFieldName, Value, KeyFieldName);
                      end;
        else DataField.AsString := Item.GetStoreValue;
      end;
      DataSet.Post;
    end;
  end;
end;

end.
