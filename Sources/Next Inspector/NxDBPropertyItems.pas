{
  Next DBInspector
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxDBPropertyItems.pas bn
}

unit NxDBPropertyItems;

interface

uses
  DB, Classes, Variants, NxPropertyItems,
  NxPropertyItemClasses, NxClasses;

type
  TNxDBLookupItem = class;

  TNxLookupItemDataLink = class(TDataLink)
  private
    FItem: TNxDBLookupItem;
  protected
  	procedure ActiveChanged; override;
    procedure UpdateData; override;
  public
    constructor Create;
  end;

  TNxDBLookupItem = class(TNxComboBoxItem)
  private
    FDataLink: TNxLookupItemDataLink;
    FKeyFieldName: string;
    FListDataSource: TDataSource;
    FListFieldName: string;
    FNullValueKey: TShortCut;
    FUpdating: Boolean;
    procedure SetKeyFieldName(const Value: string);
    procedure SetListDataSource(const Value: TDataSource);
    procedure SetListFieldName(const Value: string);
    function GetField: TField;
  protected
    property Field: TField read GetField;
    function GetDisplayText: WideString; override;
    function IsDataSetReady: Boolean;
    function IsFieldsReady: Boolean;
    procedure LoadItems; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure AssignEditing; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateEditor; override;
  published
    property FieldName;
    property KeyFieldName: string read FKeyFieldName write SetKeyFieldName;
    property ListDataSource: TDataSource read FListDataSource write SetListDataSource;
    property ListFieldName: string read FListFieldName write SetListFieldName;
    property NullValueKey: TShortCut read FNullValueKey write FNullValueKey default 0;
  end;

  TNxDBTextItem = class(TNxTextItem)
  published
    property FieldName;
  end;

  TNxDBTimeItem = class(TNxTimeItem)
  published
    property FieldName;
  end;

  TNxDBTrackBarItem = class(TNxTrackBarItem)
  published
    property FieldName;
  end;

  TNxDBToolbarItem = class(TNxToolbarItem)
  published
    property FieldName;
  end;

  TNxDBSpinItem = class(TNxSpinItem)
  published
    property FieldName;
  end;

  TNxDBCheckBoxItem = class(TNxCheckBoxItem)
  published
    property FieldName;
  end;

  TNxDBFontStyleItem = class(TNxFontStyleItem)
  published
    property FieldName;
  end;

  TNxDBComboBoxItem = class(TNxComboBoxItem)
  published
    property FieldName;
  end;

  TNxDBDateItem = class(TNxDateItem)
  published
    property FieldName;
  end;

  TNxDBFontNameItem = class(TNxFontNameItem)
  published
    property FieldName;
  end;

  TNxDBAlignmentItem = class(TNxAlignmentItem)
  published
    property FieldName;
  end;

  TNxDBVertAlignmentItem = class(TNxVertAlignmentItem)
  published
    property FieldName;
  end;

  TNxDBButtonItem = class(TNxButtonItem)
  published
    property FieldName;
  end;

  TNxDBImagePathItem = class(TNxImagePathItem)
  published
    property FieldName;
  end;

  TNxDBCalcItem = class(TNxCalcItem)
  published
    property FieldName;
  end;

  TNxDBColorItem = class(TNxColorItem)
  published
    property FieldName;
  end;

  TNxDBRadioItem = class(TNxRadioItem)
  published
    property FieldName;
  end;

  TNxDBMemoItem = class(TNxMemoItem)
  published
    property FieldName;
  end;

  TNxDBProgressItem = class(TNxProgressItem)
  published
    property FieldName;
  end;

  TNxDBFolderItem = class(TNxFolderItem)
  published
    property FieldName;
  end;

implementation

uses
  SysUtils, Dialogs, NxDBInspector, NxEdit, Controls;

{ TNxLookupItemDataLink }

procedure TNxLookupItemDataLink.ActiveChanged;
begin
  inherited;
  if DataSet = nil then Exit;
  if DataSet.Active then FItem.LoadItems
    else FItem.Lines.Clear;
end;

constructor TNxLookupItemDataLink.Create;
begin
  inherited Create;
  VisualControl := False;
end;

procedure TNxLookupItemDataLink.UpdateData;
begin
  inherited;
  if DataSet.Active then FItem.LoadItems;
end;

{ TNxDBLookupItem }

procedure TNxDBLookupItem.AssignEditing;
begin
  ItemIndex := AsInteger;
end;

constructor TNxDBLookupItem.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TNxLookupItemDataLink.Create;
  FDataLink.FItem := Self;
  FItemDataType := idtLookup;
//  FNullValueKey := 0; GJK
end;

destructor TNxDBLookupItem.Destroy;
begin
  FreeAndNil(FDataLink);
  inherited;
end;

function TNxDBLookupItem.GetDisplayText: WideString;
begin
  try
    if IsDataSetReady and IsFieldsReady
      then Result := VarToStr(ListDataSource.DataSet.Lookup(KeyFieldName, Field.AsVariant, ListFieldName));
  except
    Result := '';
  end;
end;

function TNxDBLookupItem.GetField: TField;
begin
  Result := nil;
  with GetParentControl as TNextDBInspector do
  begin
    if IsDataSetReady then
      Result := DataSource.DataSet.FindField(FieldName); 
  end;
end;

function TNxDBLookupItem.IsDataSetReady: Boolean;
begin
  Result := Assigned(ListDataSource)
    and Assigned(ListDataSource.DataSet)
    and ListDataSource.DataSet.Active;
end;

function TNxDBLookupItem.IsFieldsReady: Boolean;
begin
  Result := (FieldName <> '') and (FKeyFieldName <> '') and (FListFieldName <> '');
end;

procedure TNxDBLookupItem.LoadItems;
begin
  if not FUpdating then
  begin
    try
      FUpdating := True; { prevent stack overload }
      if IsDataSetReady and (ListFieldName <> '') then
      begin
        FListDataSource.DataSet.DisableControls;
        ListDataSource.DataSet.First;
        Lines.Clear;
        repeat
          Lines.Add(ListDataSource.DataSet.FieldByName(ListFieldName).AsString);
          ListDataSource.DataSet.Next;
        until ListDataSource.DataSet.Eof;
        FListDataSource.DataSet.EnableControls;
      end;
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TNxDBLookupItem.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FListDataSource) then
  begin
    FListDataSource := nil;
    Change(ckRefresh);
  end;
end;

procedure TNxDBLookupItem.SetKeyFieldName(const Value: string);
begin
  if FKeyFieldName <> Value then
  begin
    FKeyFieldName := Value;
    LoadItems;
    Change(ckRefresh);
  end;
end;

procedure TNxDBLookupItem.SetListDataSource(const Value: TDataSource);
begin
  FListDataSource := Value;
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
  if FDataLink.Active then FDataLink.ActiveChanged;
end;

procedure TNxDBLookupItem.SetListFieldName(const Value: string);
begin
  if FListFieldName <> Value then
  begin
    FListFieldName := Value;
    LoadItems;
    Change(ckRefresh);
  end;
end;

procedure TNxDBLookupItem.UpdateEditor;
var
  // Index: Integer; GJK
  S: string;
begin
  if not IsDataSetReady then Exit;
  with Editor as TNxComboBox do
  begin
    S := VarToStr(ListDataSource.DataSet.Lookup(KeyFieldName, Field.AsVariant, ListFieldName));
    ItemIndex := Lines.IndexOf(S);                // GJK
    // Index := Lines.IndexOf(S);                 // GJK
    // if Index <> -1 then ItemIndex := Index;    // GJK
  end;
end;

end.
