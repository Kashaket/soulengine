unit NxThirdPartyReg;

interface

procedure Register;

implementation

uses
  Classes, NxCellSource, NxGridPrint;

procedure Register;
begin
  RegisterComponents('Next Suite', [TNxDataCellSource, TNxGridPrint]);
end;

end.
 