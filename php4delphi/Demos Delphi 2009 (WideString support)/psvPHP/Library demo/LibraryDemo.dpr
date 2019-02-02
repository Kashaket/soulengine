program LibraryDemo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmLibDemo},
  dm_Main in 'dm_Main.pas' {dmMain: TDataModule},
  frm_dialog in 'frm_dialog.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Library Demo';
  Application.CreateForm(TfrmLibDemo, frmLibDemo);
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
