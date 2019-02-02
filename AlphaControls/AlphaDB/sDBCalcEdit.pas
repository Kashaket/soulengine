unit sDBCalcEdit;
{$I sDefs.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, DB,
  sMaskEdit, sCustomComboEdit, sCurrEdit, sCalcUnit;


type
{$IFDEF DELPHI_XE3}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}
  TsDBCalcEdit = class(TsCalcEdit)
  private
    FDataLink: TFieldDataLink;
    FNullIfZero: boolean;
    procedure CalcWindowClose(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function  GetDataField: string;
    function  GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure UpdateData(Sender: TObject);
  protected
    function CanEdit: boolean;
    function EditCanModify: Boolean; override;
    function GetDisplayText: string; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PopupWindowShow; override;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    procedure Change; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetReadOnly: Boolean; override;
    procedure SetReadOnly(Value: Boolean); override;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataField: string read GetDataField write SetDataField;
    property DirectInput;
    property DisplayFormat;
    property NullIfZero: boolean read FNullIfZero write FNullIfZero default False;
  end;


implementation

uses
  {$IFNDEF DELPHI5}MaskUtils, {$ENDIF}
  sGlyphUtils, acntUtils;


constructor TsDBCalcEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDefBmpID := iBTN_CALC;
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FNullIfZero := False;
end;


procedure TsDBCalcEdit.DataChange(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
    if (FDataLink <> nil) and (FDataLink.Field <> nil) then
      Value := FDataLink.Field.AsFloat
    else
      Value := 0;
end;


procedure TsDBCalcEdit.EditingChange(Sender: TObject);
begin
//
end;


procedure TsDBCalcEdit.UpdateData(Sender: TObject);
var
  V: Extended;
begin
  ValidateEdit;
  V := Value;
  if (V <> 0) or not FNullIfZero then begin
    FDataLink.Edit;
    FDataLink.Field.AsFloat := V;
  end
  else
    FDataLink.Field.Clear;
end;


function TsDBCalcEdit.GetDataSource: TDataSource;
begin
  if Assigned(FDataLink) and Assigned(FDataLink.DataSource) then
    Result := FDataLink.DataSource else Result := nil;
end;


procedure TsDBCalcEdit.SetDataSource(const Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;

  if Value <> nil then
    Value.FreeNotification(Self);
end;


function TsDBCalcEdit.GetDataField: string;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.FieldName
  else
    Result := '';
end;


procedure TsDBCalcEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;


procedure TsDBCalcEdit.KeyPress(var Key: Char);
begin
  inherited;
  if not CanEdit then begin
    Key := #0;
    Exit;
  end;
  if CharInSet(Key, [#32..#255]) and
       (FDataLink.Field <> nil) and
         not CharInSet(Key, ['0'..'9']) and
           (Key <> {$IFDEF DELPHI_XE2}FormatSettings.{$ENDIF}DecimalSeparator) and
             (Key <> '-') then begin

    MessageBeep(16);
    Key := #0;
  end;
  if Key = {$IFDEF DELPHI_XE2}FormatSettings.{$ENDIF}DecimalSeparator then
    FDataLink.Edit;

  case Key of
    ^H, ^V, ^X, '0'..'9', '-':
      FDataLink.Edit;

    #27: begin // Esc
      FDataLink.Reset;
      SelectAll;
      Key := #0;
    end;
  end;
end;


procedure TsDBCalcEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if not CanEdit then
    Key := 0
  else
    if not ReadOnly and ((Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift))) then
      FDataLink.Edit;
end;


procedure TsDBCalcEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource) then
    DataSource := nil;
end;


function TsDBCalcEdit.EditCanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;


function TsDBCalcEdit.CanEdit: boolean;
begin
  Result := Assigned(FDataLink) and Assigned(FDataLink.DataSource) and
              not ReadOnly and
                not (csDesigning in ComponentState) and
                  FDataLink.Active and
                    FDataLink.CanModify and
                      (FDataLink.Editing or FDataLink.DataSource.AutoEdit)
end;


procedure TsDBCalcEdit.Change;
begin
  if Assigned(FDataLink) and not Formatting then
    FDataLink.Modified;

  inherited;
end;


procedure TsDBCalcEdit.PopupWindowShow;
begin
  if CanEdit then begin
    inherited;
    TsCalcForm(FPopupWindow).OnResultClick := CalcWindowClose;
  end;
end;


procedure TsDBCalcEdit.CalcWindowClose(Sender: TObject);
begin
  if (DataSource <> nil) and (DataSource.DataSet <> nil) and DataSource.DataSet.CanModify then
    EditCanModify;
end;


destructor TsDBCalcEdit.Destroy;
begin
  FreeAndNil(FDataLink);
  inherited;
end;


procedure TsDBCalcEdit.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  finally
    inherited;
  end;
end;


function TsDBCalcEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;


function TsDBCalcEdit.GetDisplayText: string;
begin
  if (FDataLink <> nil) and (FDataLink.Field <> nil) and FDataLink.Field.IsNull then
    Result := ''
  else
    Result := FormatFloat(DisplayFormat, Value);
end;


procedure TsDBCalcEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

end.
