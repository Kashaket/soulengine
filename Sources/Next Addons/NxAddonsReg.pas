{$I '..\NxSuite.inc'}

unit NxAddonsReg;

interface

uses
  Classes, Types;

procedure Register;

implementation

uses
  NxAutoCompletion, NxProgress, NxBusy, NxFocus{$IFNDEF DELPHI2010UP}, NxPreview, NxVirtualDataSet;{$ELSE};{$ENDIF}

procedure Register;
begin
  RegisterComponents('Next Addons', [TNxAutoCompletion, TNxBusy, TNxFocus,
    TNxProgress]);
  {$IFNDEF DELPHI2010UP}
  RegisterComponents('Next Addons', [TNxPreview, TNxVirtualDataSet]);
  {$ENDIF}
end;

end.
