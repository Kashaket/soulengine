unit uForms;

interface

  uses Classes, Types, Forms, Controls, mainLCL,

  {$ifdef fpc}
  fileUtil,
  {$endif}

  Dialogs;
  function Form_ShowModal(id: integer): Integer; cdecl;
  procedure SetAsMainForm(aForm:integer);

implementation


function toForm(id: integer): TForm;
begin

  Result := TForm(toObject(id));
end;

procedure SetAsMainForm(aForm:integer);
var
  P: Pointer;
begin
  P := @Forms.Application.Mainform;
  Pointer(P^) := toForm( aForm );
end;

function Form_ShowModal(id: integer): Integer; cdecl;
begin
   Result := toForm(id).ShowModal();
end;


end.

