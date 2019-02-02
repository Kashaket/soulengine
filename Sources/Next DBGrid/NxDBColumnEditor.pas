unit NxDBColumnEditor;

interface

uses
	NxColumnEditor, NxColumns, NxDBColumns, NxVirtualColumn, Forms,
  Dialogs;

type
 	TDBColumnForm = class(TColumnForm)
  protected
    procedure CreateButtons; override;
    procedure CreateImages; override;
  end;

implementation

{ TDBColumnForm }

procedure TDBColumnForm.CreateButtons;
begin
  AddButton('Standard', TNxDBTextColumn, 0);
  AddButton('Standard', TNxDBImageColumn, 1);
  AddButton('Standard', TNxDBNumberColumn, 2);
  AddButton('Standard', TNxDBCheckBoxColumn, 3);
  AddButton('Standard', TNxDBComboBoxColumn, 4);
  AddButton('Standard', TNxDBListColumn, 5);
  AddButton('Standard', TNxDBDateColumn, 6);
  AddButton('Standard', TNxDBTimeColumn, 7);
  AddButton('Standard', TNxDBMemoColumn, 8);
  AddButton('Standard', TNxDBButtonColumn, 9);
  AddButton('Standard', TNxDBIncrementColumn, 10);
  AddButton('Additional', TNxDBProgressColumn, 11);
  AddButton('Additional', TNxDBRateColumn, 12);
  AddButton('Additional', TNxDBCalcColumn, 13);
  AddButton('Additional', TNxDBHtmlColumn, 14);
  AddButton('Additional', TNxDBGraphicColumn, 15);
  AddButton('Additional', TNxVirtualColumn, 17);
  AddButton('Additional', TNxLookupColumn, 20);
end;

procedure TDBColumnForm.CreateImages;
begin
  inherited;
  AddImage('LOOKUPCOLUMN');
end;

end.
