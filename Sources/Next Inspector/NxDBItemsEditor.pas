{
  Next Inspector
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxDBItemsEditor.pas bn
}

unit NxDBItemsEditor;

interface

uses
  NxItemsEditor, NxPropertyItems, NxDBPropertyItems;

type
  TDBItemForm = class(TItemForm)
  protected
    procedure CreateButtons; override;
  end;

implementation

{ TDBItemForm }

procedure TDBItemForm.CreateButtons;
begin
  AddButton('Standard', TNxDBTextItem, 1);
  AddButton('Standard', TNxDBSpinItem, 2);
  AddButton('Standard', TNxDBCheckBoxItem, 3);
  AddButton('Standard', TNxDBComboBoxItem, 4);
  AddButton('Standard', TNxDBCalcItem, 5);
  AddButton('Standard', TNxDBDateItem, 6);
  AddButton('Standard', TNxDBTimeItem, 7);
  AddButton('Standard', TNxDBButtonItem, 8);
  AddButton('Standard', TNxDBColorItem, 9);
  AddButton('Standard', TNxDBImagePathItem, 10);
  AddButton('Standard', TNxDBFolderItem, 11);
  AddButton('Additional', TNxDBMemoItem, 12);
  AddButton('Additional', TNxDBFontNameItem, 13);
  AddButton('Additional', TNxDBTrackBarItem, 14);
  AddButton('Additional', TNxDBProgressItem, 15);
  AddButton('Additional', TNxDBRadioItem, 16);
  AddButton('Additional', TNxDBLookupItem, 4);
  AddButton('Toolbar Items', TNxDBToolbarItem, 17);
  AddButton('Toolbar Items', TNxDBFontStyleItem, 18);
  AddButton('Toolbar Items', TNxDBAlignmentItem, 19);
  AddButton('Toolbar Items', TNxDBVertAlignmentItem, 20);
end;

end.
