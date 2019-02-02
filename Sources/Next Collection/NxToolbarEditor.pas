unit NxToolbarEditor;

interface

uses
  DesignWindows, DesignIntf, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NxCollection, NxStdCtrls, ComCtrls, ToolWin, ImgList;

type
  TToolbarEditor = class(TDesignWindow)
    ItemsGrid: TListView;
    TabControl: TNxTabControl;
    ToolsImages: TImageList;
    Tools: TToolBar;
    btnDelete: TToolButton;
    btnClear: TToolButton;
    ToolButton8: TToolButton;
    btnUp: TToolButton;
    btnDown: TToolButton;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControlButtonClick(Sender: TObject; const Index: Integer);
    procedure btnDeleteClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure ItemsGridEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure btnUpClick(Sender: TObject);
    procedure ItemsGridSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FParentComponent: TNxToolbar;
  protected
    procedure CreateItem(ItemClass: TNxToolbarItemClass);
    procedure Notification(AComponent: TComponent; Operation:
      TOperation); override;
  public
    property ParentComponent: TNxToolbar read FParentComponent write FParentComponent;
  end;

var
  ToolbarEditor: TToolbarEditor;

implementation

{$R *.dfm}

function MoveListViewItem(listView: TListView; ItemFrom, ItemTo: Word): Boolean;
var
  Source, Target: TListItem;
begin
  listview.Items.BeginUpdate;
  try
    Source := listview.Items[ItemFrom];
    Target := listview.Items.Insert(ItemTo);
    Target.Assign(Source);
    Source.Free;
    Result := True;
  finally
    listview.Items.EndUpdate;
  end;
end;

{ TToolbarEditor }

procedure TToolbarEditor.FormCreate(Sender: TObject);
begin
  TabControl.AddButton('Standard', TNxToolButton, 0);
  TabControl.AddButton('Standard', TNxToolSeparator, 1);
end;

procedure TToolbarEditor.FormShow(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  FParentComponent.FreeNotification(Self);
  ItemsGrid.Items.Clear;
  for i := 0 to FParentComponent.Items.Count - 1 do
  begin
    Item := TListItem.Create(ItemsGrid.Items);
    if (FParentComponent.Items[i] is TNxToolButton) then Item.Caption := TNxToolButton(FParentComponent.Items[i]).Caption;
    Item.SubItems.Add(FParentComponent.Items[i].ClassName);
    ItemsGrid.Items.AddItem(Item);
  end;
end;

procedure TToolbarEditor.TabControlButtonClick(Sender: TObject;
  const Index: Integer);
var
  ItemClass: TNxToolbarItemClass;
begin
  if TabControl.ButtonExist(Index) then
  begin
    ItemClass := TNxToolbarItemClass(TabControl.Button[Index].ReferenceType);
    CreateItem(ItemClass);
  end;
end;

procedure TToolbarEditor.CreateItem(ItemClass: TNxToolbarItemClass);
var
	NewItem: TNxToolItem;
  ListItem: TListItem;
begin
  NewItem := ItemClass.Create(FParentComponent.Owner);
  try
    NewItem.Name := Designer.UniqueName(NewItem.ClassName);
    FParentComponent.Items.AddItem(NewItem);
    ListItem := TListItem.Create(ItemsGrid.Items);
    if (NewItem is TNxToolButton) then ListItem.Caption := TNxToolButton(NewItem).Caption;
    ListItem.SubItems.Add(NewItem.ClassName);
    ItemsGrid.Items.AddItem(ListItem);
  except
    NewItem.Free;
    raise;
  end;
  Designer.Modified;
end;

procedure TToolbarEditor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  { we need to free (and close) this window
    when FParentComponent (component) has been deleted }
  if (Operation = opRemove) and (AComponent = FParentComponent) then Free;
end;

procedure TToolbarEditor.btnDeleteClick(Sender: TObject);
begin
  if Assigned(ItemsGrid.Selected) then
  begin
    ParentComponent.Items[ItemsGrid.Selected.Index].Free;
    ItemsGrid.Items.Delete(ItemsGrid.Selected.Index);
  end;
end;

procedure TToolbarEditor.ToolButton1Click(Sender: TObject);
begin
  if (Sender as TToolButton).Down then
    FormStyle := fsStayOnTop else FormStyle := fsNormal;
end;

procedure TToolbarEditor.btnClearClick(Sender: TObject);
begin
  FParentComponent.Items.Clear;
  ItemsGrid.Items.Clear;
end;

procedure TToolbarEditor.ItemsGridEdited(Sender: TObject; Item: TListItem;
  var S: String);
var
  ToolItem: TNxToolItem;
begin
  ToolItem := FParentComponent.Items[Item.Index];
  if ToolItem is TNxToolButton then TNxToolButton(ToolItem).Caption := S;
end;

procedure TToolbarEditor.btnUpClick(Sender: TObject);
var
  Index: Integer;
begin
  if Assigned(ItemsGrid.Selected) then
  begin
    Index := ItemsGrid.Selected.Index;
    FParentComponent.Items.Move(ItemsGrid.Selected.Index, ItemsGrid.Selected.Index - 1);
    MoveListViewItem(ItemsGrid, Index, Index - 1);
    ItemsGrid.Selected := ItemsGrid.Items[Index - 1];
  end;
end;

procedure TToolbarEditor.ItemsGridSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Assigned(ItemsGrid.Selected) then
  begin
    btnUp.Enabled := ItemsGrid.Selected.Index > 0;
    btnDown.Enabled := ItemsGrid.Selected.Index < ItemsGrid.Items.Count - 1;
    Designer.SelectComponent(FParentComponent.Items[ItemsGrid.Selected.Index]);
  end;
end;

end.
