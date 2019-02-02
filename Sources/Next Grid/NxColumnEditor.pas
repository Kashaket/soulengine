{
  NextGrid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:NxColumnEditor.pas 01/04/2005 22:46:35 bn
}

{$R NxButtonImagesRes.res}

unit NxColumnEditor;

interface

uses
	DesignWindows, DesignIntf, Windows, Classes, Controls, ComCtrls, ImgList,
  SysUtils, Graphics, Forms, ToolWin, Types, CommCtrl, Dialogs, Menus,
  NxGrid, NxCustomGrid, NxColumns, NxColumnClasses, NxCustomGridControl,
  NxScrollControl, NxStdCtrls, ExtCtrls, System.ImageList;

type
  TCustomColumnForm = class(TDesignWindow)
  private
    FImages: TImageList;
    FTabControl: TNxTabControl;
  protected
    procedure AddButton(TabButtons: string; ReferenceType: TComponentClass;
      ImageIndex: Integer); virtual;
    procedure CreateButtons; virtual;
    procedure CreateImages; virtual;
  public
    procedure AddImage(ResString: string);
    property Images: TImageList read FImages write FImages;
    property TabControl: TNxTabControl read FTabControl write FTabControl;
  end;

  TColumnForm = class(TCustomColumnForm)
    ToolsImages: TImageList;
    MarksImages: TImageList;
    PopupMenu1: TPopupMenu;
    ShowGrid1: TMenuItem;
    ToolbarImages: TImageList;
    ConvertTo: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    SetName1: TMenuItem;
    N2: TMenuItem;
    ColumnsGrid: TNextGrid;
    Tools: TToolBar;
    btnDelete: TToolButton;
    btnClear: TToolButton;
    ToolButton8: TToolButton;
    btnUp: TToolButton;
    btnDown: TToolButton;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ColumnsPalette: TNxTabControl;
    Duplicate1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure ColumnsGridCustomDrawCell(Sender: TObject; ACol,
      ARow: Integer; CellRect: TRect; CellState: TCellState);
    procedure FormDestroy(Sender: TObject);
    procedure ColumnsGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ColumnsGridDblClick(Sender: TObject);
    procedure ShowGrid1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetName1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ColumnsGridRowMove(Sender: TObject; FromPos, ToPos: Integer;
      var Accept: Boolean);
    procedure ColumnsPaletteButtonClick(Sender: TObject;
      const Index: Integer);
    procedure ColumnsGridKeyPress(Sender: TObject; var Key: Char);
    procedure Duplicate1Click(Sender: TObject);
  private
    FDesigner: IDesigner;
    FEditingColumn: TNxCustomColumn;
    FParentComponent: TNxCustomGrid;
    procedure SelectColumns;
    procedure SetEditingColumn(const Value: TNxCustomColumn);
  protected
    function GetColumnImageIndex(ColumnClass: TNxColumnClass): Integer; virtual;
    procedure AddButton(TabButtons: string; ReferenceType: TComponentClass;
      ImageIndex: Integer); override;
    procedure AddImage(ResString: string);
    procedure CreateButtons; override;
    procedure CreateColumn(ColumnClass: TNxColumnClass); virtual;
    procedure CreateImages; override;
    procedure ColumnNotification(Sender: TNxCustomColumn; Operation:
      TColumnNotifyOperation);
    procedure DoConvertMenuClick(Sender: TObject);
    procedure Notification(AComponent: TComponent; Operation:
      TOperation); override;
    procedure ColumnChanged(Index: Integer);
    procedure RefreshList;
  public
  	procedure UpdateColumnInEditor(Column: TNxCustomColumn);
    property Designer: IDesigner read FDesigner write FDesigner;
    property EditingColumn: TNxCustomColumn read FEditingColumn write SetEditingColumn;
    property ParentComponent: TNxCustomGrid read FParentComponent write FParentComponent;
  end;

implementation

uses NxClasses, NxVirtualColumn;

{$R *.dfm}

{ TCustomColumnForm }

procedure TCustomColumnForm.AddButton(TabButtons: string; ReferenceType: TComponentClass;
  ImageIndex: Integer);
begin
  with FTabControl.AddButton(TabButtons, ReferenceType, ImageIndex) do
  begin
    ShowHint := True;
    Hint := ReferenceType.ClassName;
  end;
end;

procedure TCustomColumnForm.AddImage(ResString: string);
var
  ABitmap: TBitmap;
begin
  ABitmap := TBitmap.Create;
  ABitmap.LoadFromResourceName(HInstance, ResString);
  FImages.AddMasked(ABitmap, ABitmap.Canvas.Pixels[0, ABitmap.Height - 1]);
end;

procedure TCustomColumnForm.CreateButtons;
begin

end;

procedure TCustomColumnForm.CreateImages;
begin
  AddImage('TEXTCOLUMN');
  AddImage('IMAGECOLUMN');
  AddImage('NUMBERCOLUMN');
  AddImage('CHECKBOXCOLUMN');
  AddImage('COMBOBOXCOLUMN');
  AddImage('LISTCOLUMN');
  AddImage('DATECOLUMN');
  AddImage('TIMECOLUMN');
  AddImage('MEMOCOLUMN');
  AddImage('BUTTONCOLUMN');
  AddImage('INCREMENTCOLUMN');
  
  AddImage('PROGRESSCOLUMN');
  AddImage('RATECOLUMN');
  AddImage('CALCCOLUMN');
  AddImage('HTMLCOLUMN');
  AddImage('GRAPHICCOLUMN');
end;

{ TColumnForm }

procedure TColumnForm.FormCreate(Sender: TObject);
begin
  TabControl := ColumnsPalette;
  Images := ToolbarImages;
  CreateImages;
  CreateButtons;
  btnUp.Enabled := False;
  btnDown.Enabled := False;
end;

procedure TColumnForm.AddButton(TabButtons: string; ReferenceType: TComponentClass;
  ImageIndex: Integer);
var
  MenuItem: TMenuItem;
begin
  inherited;
  MenuItem := TMenuItem.Create(ConvertTo);
  MenuItem.Caption := ReferenceType.ClassName;
  MenuItem.OnClick := DoConvertMenuClick;
  MenuItem.ImageIndex := ImageIndex;
  ConvertTo.Add(MenuItem);
end;

procedure TColumnForm.AddImage(ResString: string);
var
  ABitmap: TBitmap;
begin
  ABitmap := TBitmap.Create;
  ABitmap.LoadFromResourceName(HInstance, ResString);
  ToolbarImages.AddMasked(ABitmap, ABitmap.Canvas.Pixels[0, ABitmap.Height - 1]);
end;

procedure TColumnForm.CreateButtons;
begin
  AddButton('Standard', TNxTextColumn, 0);
  AddButton('Standard', TNxImageColumn, 1);
  AddButton('Standard', TNxNumberColumn, 2);
  AddButton('Standard', TNxCheckBoxColumn, 3);
  AddButton('Standard', TNxComboBoxColumn, 4);
  AddButton('Standard', TNxListColumn, 5);
  AddButton('Standard', TNxDateColumn, 6);
  AddButton('Standard', TNxTimeColumn, 7);
  AddButton('Standard', TNxMemoColumn, 8);
  AddButton('Standard', TNxButtonColumn, 9);
  AddButton('Standard', TNxIncrementColumn, 10);
  AddButton('Additional', TNxProgressColumn, 11);
  AddButton('Additional', TNxRateColumn, 12);
  AddButton('Additional', TNxCalcColumn, 13);
  AddButton('Additional', TNxHtmlColumn, 14);
  AddButton('Additional', TNxGraphicColumn, 15);
  AddButton('Additional', TNxTreeColumn, 16);
  AddButton('Additional', TNxVirtualColumn, 17);
  AddButton('Additional', TNxGuidColumn, 18);
  AddButton('Additional', TNxHyperlinkColumn, 19);
  AddButton('Additional', TNxColorColumn, 20);
end;

procedure TColumnForm.CreateColumn(ColumnClass: TNxColumnClass);
var
	NewColumn: TNxCustomColumn;
begin
  NewColumn := ColumnClass.Create(FParentComponent.Owner);
  try
    NewColumn.Name := Designer.UniqueName(NewColumn.ClassName);
    FParentComponent.Columns.AddColumn(NewColumn);
    NewColumn.ParentFont := True;
  except
    NewColumn.Free;
    raise;
  end;
  with ColumnsGrid do { Designer grid }
  begin
    AddRow;
    ColumnChanged(NewColumn.Index);
    NewColumn.RegisterNotification(ColumnNotification);
    SelectLastRow;
  end;
  btnUp.Enabled := ColumnsGrid.RowCount > 1;
  Designer.Modified;
end;

procedure TColumnForm.CreateImages;
begin
  inherited;
  AddImage('TREECOLUMN');
  AddImage('VIRTUALCOLUMN');
  AddImage('GUIDCOLUMN');
  AddImage('HYPERLINKCOLUMN');
  AddImage('COLORCOLUMN');
end;

function TColumnForm.GetColumnImageIndex(
  ColumnClass: TNxColumnClass): Integer;
var
  I, J: Integer;
begin
  Result := -1;
  for I := 0 to Pred(TabControl.Count) do
    for J := 0 to Pred(TabControl.TabButtons[TabControl.ActiveIndex].Count) do
      if TabControl.TabButtons[I].Button[J].ReferenceType = ColumnClass then
      begin
        Result := TabControl.TabButtons[I].Button[J].ImageIndex;
        Exit;
      end;
end;

procedure TColumnForm.ColumnNotification(Sender: TNxCustomColumn;
  Operation: TColumnNotifyOperation);
var
  I: Integer;
begin
  I := FParentComponent.Columns.IndexOf(Sender);
  ColumnChanged(I);
end;

procedure TColumnForm.DoConvertMenuClick(Sender: TObject);
var
	NewColumn: TNxCustomColumn;
  ColumnClass: TNxColumnClass;
  I, Pos: Integer;
  OldName: TComponentName;
begin
  Designer.NoSelection;
  ColumnClass := TNxColumnClass(GetClass((Sender as TMenuItem).Caption));
  for i := 0 to ColumnsGrid.RowCount - 1 do
  begin
    if ColumnsGrid.Selected[i] then
    begin
      NewColumn := ColumnClass.Create(FParentComponent.Owner);
      try
        NewColumn.Name := Designer.UniqueName(NewColumn.ClassName);
        { Copy properties from old column }
        NewColumn.Assign(FParentComponent.Columns[I]);
        NewColumn.RegisterNotification(ColumnNotification);

        Pos := FParentComponent.Columns[I].Position;
        OldName := FParentComponent.Columns[I].Name;

        { Delete old column }
        FParentComponent.Columns[I].UnregisterNotification(ColumnNotification);
        FParentComponent.Columns.Delete(I);

        { Insert new column into Columns array }
        FParentComponent.Columns.InsertColumn(NewColumn, I);
        NewColumn.Name := OldName;
        NewColumn.Position := Pos;
      except
        NewColumn.Free;
        raise;
      end;
      ColumnChanged(NewColumn.Index);
    end;
  end;
  Designer.Modified; { update IDE }
end;

procedure TColumnForm.RefreshList;
var
  i: Integer;
begin
  ColumnsGrid.ClearRows;
  for i := 0 to FParentComponent.Columns.Count - 1 do
  begin
    ColumnsGrid.AddRow;
    ColumnChanged(i);
    FParentComponent.Columns[i].RegisterNotification(ColumnNotification);
  end;
end;

procedure TColumnForm.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  { we need to free (and close) this window
    when FParentComponent (component) has been deleted }
  if (Operation = opRemove) and (AComponent = FParentComponent) then Free;
end;

procedure TColumnForm.SetEditingColumn(const Value: TNxCustomColumn);
begin
  FEditingColumn := Value;
end;

procedure TColumnForm.FormShow(Sender: TObject);
begin
  { note: next line notify window (Self)
          that FParentComponent will be destroyed }
  FParentComponent.FreeNotification(Self);
  RefreshList;
  if ColumnsGrid.RowCount > 0 then ColumnsGrid.SelectedRow := 0;
  Caption := 'Column Editor - ' + FParentComponent.Name;
end;

procedure TColumnForm.btnDeleteClick(Sender: TObject);
var
  I: Integer;
begin
  Designer.Modified;
  if ColumnsGrid.RowCount = 0 then Exit;
  { Note: Can't delete column because this control is
    showed in Object Inspector ! }
  Designer.NoSelection;

  I := 0;
  while I < ColumnsGrid.RowCount do { delete all selected columns }
  begin
    if ColumnsGrid.Selected[I] then
    begin
      FParentComponent.Columns[I].UnregisterNotification(ColumnNotification);
		  FParentComponent.Columns.Delete(I); { will call notify }
      ColumnsGrid.DeleteRow(I);
    end else Inc(I);
  end;
end;

procedure TColumnForm.btnClearClick(Sender: TObject);
begin
  Designer.NoSelection;
  FParentComponent.Columns.Clear;
  ColumnsGrid.ClearRows;
  Designer.Modified;
  btnUp.Enabled := False;
  btnDown.Enabled := False;
end;

procedure TColumnForm.btnUpClick(Sender: TObject);
begin
  ColumnsGrid.MoveRow(ColumnsGrid.SelectedRow, ColumnsGrid.SelectedRow - 1);
  FParentComponent.Columns.Move(ColumnsGrid.SelectedRow, ColumnsGrid.SelectedRow - 1);
  FParentComponent.Columns.ChangePosition(ColumnsGrid.SelectedRow, ColumnsGrid.SelectedRow - 1);
  ColumnsGrid.SelectedRow := ColumnsGrid.SelectedRow - 1;
  Designer.Modified;
end;

procedure TColumnForm.btnDownClick(Sender: TObject);
begin
  ColumnsGrid.MoveRow(ColumnsGrid.SelectedRow, ColumnsGrid.SelectedRow + 1);
	FParentComponent.Columns.Move(ColumnsGrid.SelectedRow, ColumnsGrid.SelectedRow + 1);
 	FParentComponent.Columns.ChangePosition(ColumnsGrid.SelectedRow, ColumnsGrid.SelectedRow + 1);
  ColumnsGrid.SelectedRow := ColumnsGrid.SelectedRow + 1;
  Designer.Modified;
end;

procedure TColumnForm.ColumnsGridCustomDrawCell(Sender: TObject; ACol,
  ARow: Integer; CellRect: TRect; CellState: TCellState);
var
  SmallRect: TRect;
begin
  if ACol = 2 then begin
    with ColumnsGrid.Canvas do
    begin
      Pen.Color := clGrayText;
      SmallRect := CellRect;
      InflateRect(SmallRect, -4, -2);
      case FParentComponent.Columns[ARow].DrawingOptions of
        doNormal, doBackgroundOnly: begin
          Brush.Color := FParentComponent.Columns[ARow].Color;
          Rectangle(SmallRect);
        end;
        doCustom: begin
          Pen.Style := psDot;
          Brush.Color := FParentComponent.Columns[ARow].Color;
          Rectangle(SmallRect);
        end;
        doCustomOnly: begin
          Pen.Style := psDot;
          Brush.Color := clWindow;
          Rectangle(SmallRect);
        end;
      end;
      Pen.Style := Graphics.psSolid;
    end;
  end;
end;

procedure TColumnForm.FormDestroy(Sender: TObject);
begin
  FParentComponent.RemoveFreeNotification(Self);
end;

procedure TColumnForm.SelectColumns;
var
  CompList: IDesignerSelections;
  ColumnPersistent: TPersistent;
  i: Integer;
begin
  CompList := CreateSelectionList;
  for i := 0 to ColumnsGrid.RowCount - 1 do
  	if ColumnsGrid.Selected[i] then
		begin
      ColumnPersistent := FParentComponent.Columns[i];
			CompList.Add(ColumnPersistent);
	  end;
  if CompList.Count > 0 then
	begin
    EditingColumn := FParentComponent.Columns[ColumnsGrid.SelectedRow];
	  Designer.SetSelections(CompList);
	end;
end;

procedure TColumnForm.ColumnsGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  btnUp.Enabled := ARow > 0;
  btnDown.Enabled := ARow < ColumnsGrid.RowCount - 1;
  if ColumnsGrid.RowCount = 0 then Exit;
  SelectColumns;
end;

procedure TColumnForm.ColumnChanged(Index: Integer);
var
  Column: TNxCustomColumn;
begin
  with ColumnsGrid do
  begin
    Column := FParentComponent.Columns[Index];
    Cell[0, Index].AsInteger := GetColumnImageIndex(TNxColumnClass(FParentComponent.Columns[Index].ClassType));
    if coFixedSize in FParentComponent.Columns[Index].Options
      then Cells[1, Index] := '-1' else
    begin
      if coAutoSize in FParentComponent.Columns[Index].Options
        then Cells[1, Index] := '1'
          else Cells[1, Index] := '0';
    end;
    if coEditing in Column.Options then
    begin
      if coEditorAutoSelect in Column.Options then Cells[3, Index] := '3' else Cells[3, Index] := '2';
    end else Cells[3, Index] := '-1';
    case FParentComponent.Columns[Index].Visible of
      True: Cells[4, Index] := '4';
      False: Cells[4, Index] := '-1';
    end;
    Cells[5, Index] := IntToStr(Index) + ': ' + FParentComponent.Columns[Index].Header.Caption;
    Cells[6, Index] := FParentComponent.Columns[Index].Name;
    Cells[7, Index] := FParentComponent.Columns[Index].ClassName;
  end;
end;

procedure TColumnForm.UpdateColumnInEditor(Column: TNxCustomColumn);
begin
  ColumnsGrid.Cells[3, Column.Index] := IntToStr(Column.Index) + ': ' + Column.Header.Caption;
end;

procedure TColumnForm.FormActivate(Sender: TObject);
begin
  ActiveControl := ColumnsGrid;
  SelectColumns;   
end;

procedure TColumnForm.ColumnsGridDblClick(Sender: TObject);
var
  CursorPoint, ACell: TPoint;
  ACol: Integer;
begin
  inherited;
  GetCursorPos(CursorPoint);
  CursorPoint := ColumnsGrid.ScreenToClient(CursorPoint);
	ACell := ColumnsGrid.GetCellAtPos(CursorPoint);
  if (PtInRect(ColumnsGrid.GetBodyRect, CursorPoint) = False)
    or (ACell.Y >= ColumnsGrid.RowCount) then Exit;
	if ACell.X = 1 then
  begin
	  with FParentComponent do
	  	if coFixedSize in Columns[ACell.Y].Options then
	    begin
	    	ColumnsGrid.Cells[ACell.X, ACell.Y] := '-1';
	      Exit;
	    end;
		if ColumnsGrid.Cells[ACell.X, ACell.Y] = '1' then
    begin
    	ColumnsGrid.Cells[ACell.X, ACell.Y] := '0';
  		with FParentComponent do Columns[ACell.Y].Options := Columns[ACell.Y].Options - [coAutoSize];
    end else
    begin
    	ColumnsGrid.Cells[ACell.X, ACell.Y] := '1';
  		with FParentComponent do Columns[ACell.Y].Options := Columns[ACell.Y].Options + [coAutoSize];
    end;
  end;
  ACol := ColumnsGrid.SelectedRow;
  if ACell.X = 3 then
  begin
    if coEditing in FParentComponent.Columns[ACol].Options then
    begin
      FParentComponent.Columns[ACol].Options := FParentComponent.Columns[ACol].Options - [coEditing];
    end else
    begin
      FParentComponent.Columns[ACol].Options := FParentComponent.Columns[ACol].Options + [coEditing];
    end;
    Designer.Modified;
  end;
  if ACell.X = 4 then
  begin
    FParentComponent.Columns[ACol].Visible := not FParentComponent.Columns[ACol].Visible;
  end;
end;

procedure TColumnForm.ShowGrid1Click(Sender: TObject);
begin
  if TMenuItem(Sender).Checked then ColumnsGrid.Options := ColumnsGrid.Options + [goGrid]
    else ColumnsGrid.Options := ColumnsGrid.Options - [goGrid];
end;

procedure TColumnForm.SetName1Click(Sender: TObject);
var
  i: Integer;
begin
  { recreate column name }
  with FParentComponent do begin
    for I := 0 to ColumnsGrid.RowCount - 1 do
    begin
      if ColumnsGrid.Selected[I] then
        Columns[i].Name := Designer.UniqueName(Columns[i].ClassName);
    end;
  end;
  Designer.Modified;
end;

procedure TColumnForm.ToolButton1Click(Sender: TObject);
begin
  if TToolButton(Sender).Down then FormStyle := fsStayOnTop
    else FormStyle := fsNormal;
end;

procedure TColumnForm.ColumnsGridRowMove(Sender: TObject; FromPos,
  ToPos: Integer; var Accept: Boolean);
begin
  FParentComponent.Columns.Move(FromPos, ToPos);
  FParentComponent.Columns.ChangePosition(FromPos, ToPos);
  Designer.Modified;
end;

procedure TColumnForm.ColumnsPaletteButtonClick(Sender: TObject;
  const Index: Integer);
var
  ColumnClass: TNxColumnClass;
begin
  if TabControl.ButtonExist(Index) then
  begin
    ColumnClass := TNxColumnClass(TabControl.Button[Index].ReferenceType);
    CreateColumn(ColumnClass);
  end;
end;

procedure TColumnForm.ColumnsGridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #9 then btnDeleteClick(btnDelete);
end;

procedure TColumnForm.Duplicate1Click(Sender: TObject);
var
  ColumnClass: TNxColumnClass;
	NewColumn: TNxCustomColumn;
  i: Integer;
begin
  Designer.NoSelection;
  for i := 0 to Pred(ColumnsGrid.RowCount) do
  begin
    if ColumnsGrid.Selected[i] then
    begin
      ColumnClass := TNxColumnClass(FParentComponent.Columns[i].ClassType);
      NewColumn := ColumnClass.Create(FParentComponent.Owner);
      try
        NewColumn.Name := Designer.UniqueName(NewColumn.ClassName);
        NewColumn.Assign(FParentComponent.Columns[i]);
        NewColumn.RegisterNotification(ColumnNotification);
        FParentComponent.Columns.AddColumn(NewColumn);
      except
        NewColumn.Free;
        raise;
      end;
      ColumnsGrid.AddRow;
      ColumnChanged(NewColumn.Index);
    end;
  end;
  Designer.Modified; { update IDE }
end;

end.

