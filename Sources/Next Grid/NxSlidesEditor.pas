unit NxSlidesEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DesignWindows, DesignIntf, Dialogs, NxColumns, NxCustomGrid, NxFieldChooser,
  Menus;

type
  TSlidesForm = class(TDesignWindow)
    SlidesDesigner: TNxSlidesDesigner;
    PopupMenu1: TPopupMenu;
    AlignToGri1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SlidesDesignerSelectSlide(Sender: TObject;
      Column: TNxCustomColumn);
    procedure AlignToGri1Click(Sender: TObject);
    procedure SlidesDesignerChange(Sender: TObject);
  private
    FParentComponent: TNxCustomGrid;
  protected
    procedure Notification(AComponent: TComponent; Operation:
      TOperation); override;
  public
    property ParentComponent: TNxCustomGrid read FParentComponent write FParentComponent;   
  end;

implementation

{$R *.dfm}

procedure TSlidesForm.FormCreate(Sender: TObject);
begin
  //
end;

procedure TSlidesForm.FormShow(Sender: TObject);
begin
  FParentComponent.FreeNotification(Self);
end;

procedure TSlidesForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  { we need to free (and close) this window
    when FParentComponent (component) has been deleted }
  if (Operation = opRemove) and (AComponent = FParentComponent) then Free;
end;

procedure TSlidesForm.SlidesDesignerSelectSlide(Sender: TObject;
  Column: TNxCustomColumn);
begin
  if Assigned(Column) then Designer.SelectComponent(Column)
    else Designer.ClearSelection;
end;

procedure TSlidesForm.AlignToGri1Click(Sender: TObject);
begin
  SlidesDesigner.AlignToGrid(SlidesDesigner.Selected);
end;

procedure TSlidesForm.SlidesDesignerChange(Sender: TObject);
begin
  Designer.Modified;
end;

end.
