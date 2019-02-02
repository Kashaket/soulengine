{
  Next Inspector
  Copyright (C) 1996-2006 by Berg
  All rights reserved.

  $id:NxInspectorReg.pas bn
}

unit NxInspectorReg;

interface

uses
	Classes, Types, Graphics, Controls, Dialogs, Forms, ImgList,
  DesignIntf, DesignEditors, VCLEditors,
  NxItemsEditor, NxDBItemsEditor, NxInspector, NxDBInspector,
  NxPropertyItems, NxPropertyItemClasses, NxDBPropertyItems;

type
  TItemFormClass = class of TItemForm;

  TNextInspectorComponentEditor = class(TDefaultEditor) { Pop-up menu }
  protected
    procedure CreateComponentNames;
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TItemsProperty = class(TPropertyEditor)
  private
    function ShowForm(Owner: TPersistent): Boolean;
  protected
    function GetItemFormClass: TItemFormClass; virtual;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TSelectedProperty = class(TPropertyEditor)
  public
		procedure SetValue(const Value: string); override;
  end;

  {$IFNDEF D2005UP}
  TWideStringProperty = TStringProperty;
  {$ENDIF}

  TWideCaptionProperty = class(TWideStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  TItemCaptionProperty = class(TWideCaptionProperty)
  private
  	procedure FindEditorWindow;
  public
    function GetValue: string; override;
		procedure SetValue(const Value: string); override;
  end;
  
  TDBItemsProperty = class(TItemsProperty)
  protected
    function GetItemFormClass: TItemFormClass; override;
  end;

  TItemFieldsListProperty = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
		function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TItemImageIndexPropertyEditor = class(TIntegerProperty,
    ICustomPropertyListDrawing)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetImageListAt(Index: Integer): TCustomImageList; virtual;

    // ICustomPropertyListDrawing
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);
  end;

  TNxLookupItemListProperty = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TNxLookupItemKeyFieldProperty = class(TNxLookupItemListProperty)
  public
		function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TNxLookupItemListFieldProperty = class(TNxLookupItemListProperty)
  public
		function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

procedure Register;

implementation

uses SysUtils, NxVersions;

procedure Register;
begin
  RegisterComponents('Next Suite', [TNextInspector, TNextDBInspector]);

  { Register Items }
  RegisterNoIcon([TNxCalcItem, TNxDateItem, TNxTrackBarItem, TNxTextItem, TNxSpinItem, TNxComboBoxItem,
    TNxMemoItem, TNxCheckBoxItem, TNxColorItem, TNxFontNameItem, TNxFontStyleItem, TNxImagePathItem,
    TNxButtonItem, TNxAlignmentItem, TNxProgressItem, TNxTimeItem, TNxToolbarItem, TNxVertAlignmentItem, TNxRadioItem, TNxFolderItem]);
  RegisterClasses([TNxCalcItem, TNxDateItem, TNxTrackBarItem, TNxTextItem, TNxSpinItem, TNxComboBoxItem,
    TNxMemoItem, TNxCheckBoxItem, TNxColorItem, TNxFontNameItem, TNxFontStyleItem, TNxImagePathItem,
    TNxButtonItem, TNxAlignmentItem, TNxProgressItem, TNxTimeItem, TNxToolbarItem, TNxVertAlignmentItem, TNxRadioItem, TNxFolderItem]);

  { Db Items }
  RegisterNoIcon([TNxDBCalcItem, TNxDBDateItem, TNxDBTextItem, TNxDBTrackBarItem, TNxDBSpinItem, TNxDBComboBoxItem, TNxDBCheckBoxItem,
    TNxDBMemoItem, TNxDBColorItem, TNxDBFontNameItem, TNxDBFontStyleItem, TNxDBImagePathItem, TNxDBButtonItem,
    TNxDBAlignmentItem, TNxDBProgressItem, TNxDBVertAlignmentItem, TNxDBToolbarItem, TNxDBRadioItem, TNxDBFolderItem, TNxDBLookupItem]);
  RegisterClasses([TNxDBCalcItem, TNxDBDateItem, TNxDBTimeItem, TNxDBTextItem, TNxDBTrackBarItem, TNxDBSpinItem, TNxDBComboBoxItem, TNxDBCheckBoxItem,
    TNxDBMemoItem, TNxDBColorItem, TNxDBFontNameItem, TNxDBFontStyleItem, TNxDBImagePathItem, TNxDBButtonItem,
    TNxDBAlignmentItem, TNxDBProgressItem, TNxDBVertAlignmentItem, TNxDBTimeItem, TNxDBToolbarItem, TNxDBRadioItem, TNxDBFolderItem, TNxDBLookupItem]);

  { Property editors }
  RegisterComponentEditor(TNextInspector, TNextInspectorComponentEditor);
  RegisterPropertyEditor(TypeInfo(WideString), TNxPropertyItem, 'Caption', TItemCaptionProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TNxPropertyItem, 'ImageIndex', TItemImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TPersistent), TNxCustomInspector, 'Associate', TComponentProperty);
  RegisterPropertyEditor(TypeInfo(TShortCut), TNxDBLookupItem, 'NullValueKey', TShortCutProperty);

  { Property editors for both versions }
  RegisterPropertyEditor(TypeInfo(TNxPropertyItems), TNextInspector, 'Items', TItemsProperty);
  RegisterPropertyEditor(TypeInfo(TNxPropertyItems), TNextDBInspector, 'Items', TDBItemsProperty);

  { FieldName list }
  RegisterPropertyEditor(TypeInfo(WideString), TNxPropertyItem, 'FieldName', TItemFieldsListProperty);

  { Lookup Item }
  RegisterPropertyEditor(TypeInfo(string), TNxDBLookupItem, 'KeyFieldName', TNxLookupItemKeyFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TNxDBLookupItem, 'ListFieldName', TNxLookupItemListFieldProperty);
end;

{ TNextInspectorComponentEditor }

procedure TNextInspectorComponentEditor.CreateComponentNames;
var
  I: Integer;
begin
  with GetComponent as TNxCustomInspector do
    for I := 0 to Pred(Items.Count) do
    begin
      Items[I].Name := Designer.UniqueName(Items[I].ClassName);
    end;
end;

procedure TNextInspectorComponentEditor.Edit;
begin
  inherited;

end;

procedure TNextInspectorComponentEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
begin
  inherited;
  if (Prop.GetName = 'Items') then
  begin
    Continue := False;
    Prop.Edit; { call TItemsProperty.Edit }
  end;
end;

procedure TNextInspectorComponentEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  with GetComponent as TNxCustomInspector do
    case Index of
      0: Edit;
      1: ShowMessage('Copyright (C) 1996-2011 Berg' + #13#10 +
                     'Version ' + strNextInspectorVer + #13#10 +
                     'http://www.bergsoft.net/');
      3: begin
           if ItemsArrange = taCatagory then ItemsArrange := taName else ItemsArrange := taCatagory;
           Designer.Modified;
         end;
      4: HideTopLevel := not HideTopLevel;
      6: if Associate <> nil then
         begin
           if Items.Count = 0 then Items.AddChild(nil, TNxTextItem);
           LoadProperties(Items[0]);
           CreateComponentNames;
         end;
    end;
end;

function TNextInspectorComponentEditor.GetVerb(Index: Integer): string;
const
  Arrange: array[TItemsArrange] of string = ('&Name', '&Category');
  Status: array[Boolean] of string = ('Show', 'Hide');
begin
  with GetComponent as TNxCustomInspector do
    case Index of
      0: Result := '&Items Editor...';
      1: Result := '&Version...';
      2: Result := '-';
      3: Result := 'Arrange by ' + Arrange[ItemsArrange];
      4: Result := Status[not HideTopLevel] + ' &Top Level Items';
      5: Result := '-';
      6: Result := '&Load Properties';
    end;
end;

function TNextInspectorComponentEditor.GetVerbCount: Integer;
begin
  Result := 7;
end;

{ TItemsProperty }

function TItemsProperty.ShowForm(Owner: TPersistent): Boolean;
var
  i: Integer;
  Form: TCustomForm;
begin
  { try to locate form with
    same owner to show it again }
  Result := False;
  for i := 0 to Screen.FormCount - 1 do
  begin
    Form := Screen.Forms[i];
    if Form is TItemForm then
      if TItemForm(Form).OwnerControl = Owner then
      begin
        Form.Show;
        if Form.WindowState = wsMinimized then Form.WindowState := wsNormal;
        Result := True;
        Exit;
      end;
  end;
end;

function TItemsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog, paReadOnly];
end;

function TItemsProperty.GetValue: string;
begin
  Result := '(' + TNextInspector(GetComponent(0)).Items.ClassName +  ')';
end;

function TItemsProperty.GetItemFormClass: TItemFormClass;
begin
  Result := TItemForm;
end;

procedure TItemsProperty.Edit;
var
  EditorForm: TItemForm;
begin
  inherited;
  if not ShowForm(GetComponent(0)) then { form is already showed }
  begin { else create new form }
    EditorForm := GetItemFormClass.Create(Application);
    try
      EditorForm.OwnerControl := TNextInspector(GetComponent(0));
      EditorForm.Designer := Self.Designer;
      EditorForm.WindowState := wsNormal;
      EditorForm.Show;
    except
      EditorForm.Free;
    end;
  end;
end;

{ TItemCaptionProperty }

procedure TItemCaptionProperty.FindEditorWindow;
var
  i: Integer;
  Form: TCustomForm;
begin
  for i := 0 to Screen.FormCount - 1 do
  begin
    Form := Screen.Forms[i];
    if Form is TItemForm then
      if TItemForm(Form).EditingItem = GetComponent(0) then
      begin
        TItemForm(Form).UpdateItem(TNxPropertyItem(GetComponent(0)));
      end;
  end;
end;

function TItemCaptionProperty.GetValue: string;
begin
  Result := TNxPropertyItem(GetComponent(0)).Caption;
end;

procedure TItemCaptionProperty.SetValue(const Value: string);
begin
  inherited;
	TNxPropertyItem(GetComponent(0)).Caption := Value;
  FindEditorWindow;
end;

{ TDBItemsProperty }

function TDBItemsProperty.GetItemFormClass: TItemFormClass;
begin
  Result := TDBItemForm;
end;

{ TItemFieldsListProperty }

function TItemFieldsListProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paValueList];
end;

function TItemFieldsListProperty.GetValue: string;
begin
	Result := (GetComponent(0) as TNxPropertyItem).FieldName;
end;

procedure TItemFieldsListProperty.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  AItem: TNxPropertyItem;
begin
  AItem := GetComponent(0) as TNxPropertyItem;
  with AItem.GetParentControl as TNextDBInspector do
  begin
    if Assigned(DataSource) and Assigned(DataSource.DataSet) then
    begin
      for i := 0 to DataSource.DataSet.FieldCount - 1 do
      Proc(DataSource.DataSet.Fields[i].FieldName);
    end;
  end;
end;

procedure TItemFieldsListProperty.SetValue(const Value: string);
begin
  inherited;
	(GetComponent(0) as TNxPropertyItem).FieldName := Value;
  Designer.Modified;
end;

{ TItemImageIndexPropertyEditor }

function TItemImageIndexPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

function TItemImageIndexPropertyEditor.GetImageListAt(
  Index: Integer): TCustomImageList;
var
  C: TPersistent;
  Item: TNxPropertyItem;
  Inspector: TNxCustomInspector;
begin
  Result := nil;
  { ? I'm guessing that the Index parameter is a component index (one that
    would be passed to the GetComponent function). }
  C := GetComponent(Index);
  if C is TNxPropertyItem then
  begin
    Item := TNxPropertyItem(C);
    Inspector := TNxCustomInspector(Item.Items.Owner);
    Result := Inspector.Images;
  end;
end;

procedure TItemImageIndexPropertyEditor.GetValues(Proc: TGetStrProc);
var
  ImgList: TCustomImageList;
  I: Integer;
begin
  ImgList := GetImageListAt(0);
  if Assigned(ImgList) then
    for I := 0 to ImgList.Count-1 do
      Proc(IntToStr(I));
end;

procedure TItemImageIndexPropertyEditor.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  ImgList: TCustomImageList;
  X: Integer;
begin
  ImgList := GetImageListAt(0);
  ACanvas.FillRect(ARect);
  X := ARect.Left + 2;
  if Assigned(ImgList) then begin
    ImgList.Draw(ACanvas, X, ARect.Top + 2, StrToInt(Value));
    Inc(X, ImgList.Width);
  end;
  ACanvas.TextOut(X + 3, ARect.Top + 1, Value);
end;

procedure TItemImageIndexPropertyEditor.ListMeasureHeight(
  const Value: string; ACanvas: TCanvas; var AHeight: Integer);
var
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  AHeight := ACanvas.TextHeight(Value) + 2;
  if Assigned(ImgList) and (ImgList.Height + 4 > AHeight) then
    AHeight := ImgList.Height + 4;
end;

procedure TItemImageIndexPropertyEditor.ListMeasureWidth(
  const Value: string; ACanvas: TCanvas; var AWidth: Integer);
var
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  AWidth := ACanvas.TextWidth(Value) + 4;
  if Assigned(ImgList) then
    Inc(AWidth, ImgList.Width);
end;

{ TSelectedProperty }

procedure TSelectedProperty.SetValue(const Value: string);
begin
  inherited;

end;

{ TWideCaptionProperty }

function TWideCaptionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paAutoUpdate];
end;

{ TNxLookupItemListProperty }

function TNxLookupItemListProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paValueList];
end;

procedure TNxLookupItemListProperty.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  Item: TNxDBLookupItem;
begin
  Item := GetComponent(0) as TNxDBLookupItem;
	if Assigned(Item.ListDataSource) and Assigned(Item.ListDataSource.DataSet) then
	  for i := 0 to Item.ListDataSource.DataSet.FieldCount - 1 do
	    Proc(Item.ListDataSource.DataSet.Fields[i].FieldName);
end;

{ TNxLookupItemKeyFieldProperty }

function TNxLookupItemKeyFieldProperty.GetValue: string;
begin
	Result := (GetComponent(0) as TNxDBLookupItem).KeyFieldName;
end;

procedure TNxLookupItemKeyFieldProperty.SetValue(const Value: string);
begin
  inherited;
	(GetComponent(0) as TNxDBLookupItem).KeyFieldName := Value;
end;

{ TNxLookupItemListFieldProperty }

function TNxLookupItemListFieldProperty.GetValue: string;
begin
	Result := (GetComponent(0) as TNxDBLookupItem).ListFieldName;
end;

procedure TNxLookupItemListFieldProperty.SetValue(const Value: string);
begin
  inherited;
	(GetComponent(0) as TNxDBLookupItem).ListFieldName := Value;
end;

end.
