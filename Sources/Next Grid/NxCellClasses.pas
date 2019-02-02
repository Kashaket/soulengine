unit NxCellClasses;

interface

uses
	DateUtils, NxColumns, NxCells;

type
  TBooleanCell = class(TCell)
  private
  	FValue: Boolean;
	protected
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
  	constructor Create(Cells: TCells); override;
    procedure Clear; override;
  end;

  TDateTimeCell = class(TCell)
  private
  	FValue: Double;
	protected
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
  	constructor Create(Cells: TCells); override;
    procedure Clear; override;
  end;

  TFloatCell = class(TCell)
  private
  	FValue: Double;
	protected
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
  	constructor Create(Cells: TCells); override;
    procedure Clear; override;
  end;

  TIntegerCell = class(TCell)
  private
  	FValue: Integer;
	protected
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
  	constructor Create(Cells: TCells); override;
    procedure Clear; override;
  end;

  TStringCell = class(TCell)
  private
  	FValue: WideString;
	protected
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
  public
  	constructor Create(Cells: TCells); override;
    procedure Clear; override;
  end;

  TIncrementCell = class(TCell)
	protected
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
  public
    procedure Clear; override;
  end;

implementation

uses
	SysUtils, Math;

{ TBooleanCell }

procedure TBooleanCell.Clear;
begin
  FValue := False;
  inherited;
end;

constructor TBooleanCell.Create(Cells: TCells);
begin
  inherited;

end;

function TBooleanCell.GetAsBoolean: Boolean;
begin
  Result := FValue;
end;

function TBooleanCell.GetAsDateTime: TDateTime;
begin
  Result := 0;
end;

function TBooleanCell.GetAsFloat: Double;
begin
  Result := IfThen(FValue, 1, 0);
end;

function TBooleanCell.GetAsInteger: Integer;
begin
  Result := IfThen(FValue, 1, 0);
end;

function TBooleanCell.GetAsString: WideString;
begin
	Result := BoolToStr(FValue, True);
end;

procedure TBooleanCell.SetAsBoolean(const Value: Boolean);
begin
  FValue := Value;
	inherited;
end;

procedure TBooleanCell.SetAsDateTime(const Value: TDateTime);
begin
  FValue := False;
  inherited;
end;

procedure TBooleanCell.SetAsFloat(const Value: Double);
begin
	if Value = 0 then FValue := False else FValue := True;
	inherited;
end;

procedure TBooleanCell.SetAsInteger(const Value: Integer);
begin
	if Value = 0 then FValue := False else FValue := True;
	inherited;
end;

procedure TBooleanCell.SetAsString(const Value: WideString);
begin
  FValue := (Value = '1') or (LowerCase(Value) = 'true');
	inherited;
end;

{ TDateTimeCell }

procedure TDateTimeCell.Clear;
begin
  FValue := 0;
  inherited;
end;

constructor TDateTimeCell.Create(Cells: TCells);
begin
  inherited;

end;

function TDateTimeCell.GetAsBoolean: Boolean;
begin
  Result := False;
end;

function TDateTimeCell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TDateTimeCell.GetAsFloat: Double;
begin
  Result := FValue;
end;

function TDateTimeCell.GetAsInteger: Integer;
begin
  Result := Trunc(FValue);
end;

function TDateTimeCell.GetAsString: WideString;
begin
  Result := DateTimeToStr(FValue);
end;

procedure TDateTimeCell.SetAsBoolean(const Value: Boolean);
begin
  FValue := Today;
  inherited;
end;

procedure TDateTimeCell.SetAsDateTime(const Value: TDateTime);
begin
  FValue := Value;
  inherited;
end;

procedure TDateTimeCell.SetAsFloat(const Value: Double);
begin
  FValue := Value;
  inherited;
end;

procedure TDateTimeCell.SetAsInteger(const Value: Integer);
begin
  FValue := Value;
  inherited;
end;

procedure TDateTimeCell.SetAsString(const Value: WideString);
begin
  if Value = '' then FValue := 0 else FValue := StrToDateTimeDef(Value, 0);
  inherited;
end;

{ TFloatCell }

procedure TFloatCell.Clear;
begin
  FValue := 0;
  inherited;
end;

constructor TFloatCell.Create(Cells: TCells);
begin
  inherited;

end;

function TFloatCell.GetAsBoolean: Boolean;
begin
  Result := False;
end;

function TFloatCell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TFloatCell.GetAsFloat: Double;
begin
  Result := FValue;
end;

function TFloatCell.GetAsInteger: Integer;
begin
  Result := Round(FValue);
end;

function TFloatCell.GetAsString: WideString;
begin
  Result := FloatToStr(FValue);
end;

procedure TFloatCell.SetAsBoolean(const Value: Boolean);
begin
  FValue := 0;
  inherited;
end;

procedure TFloatCell.SetAsDateTime(const Value: TDateTime);
begin
  FValue := Value;
  inherited;
end;

procedure TFloatCell.SetAsFloat(const Value: Double);
begin
  FValue := Value;
  inherited;
end;

procedure TFloatCell.SetAsInteger(const Value: Integer);
begin
  FValue := Value;
  inherited;
end;

procedure TFloatCell.SetAsString(const Value: WideString);
begin
	FValue := StrToFloat(Value);
  inherited;
end;

{ TIntegerCell }

procedure TIntegerCell.Clear;
begin
  FValue := 0;
  inherited;
end;

constructor TIntegerCell.Create(Cells: TCells);
begin
  inherited;

end;

function TIntegerCell.GetAsBoolean: Boolean;
begin
  Result := FValue > 0;
end;

function TIntegerCell.GetAsDateTime: TDateTime;
begin
  Result := 0;
end;

function TIntegerCell.GetAsFloat: Double;
begin
  Result := FValue;
end;

function TIntegerCell.GetAsInteger: Integer;
begin
  Result := FValue;
end;

function TIntegerCell.GetAsString: WideString;
begin
  Result := IntToStr(FValue);
end;

procedure TIntegerCell.SetAsBoolean(const Value: Boolean);
begin
  if Value then FValue := 1 else FValue := 0;
  inherited;
end;

procedure TIntegerCell.SetAsDateTime(const Value: TDateTime);
begin
  FValue := 0;
  inherited;
end;

procedure TIntegerCell.SetAsFloat(const Value: Double);
begin
  FValue := Round(Value);
  inherited;
end;

procedure TIntegerCell.SetAsInteger(const Value: Integer);
begin
  FValue := Value;
  inherited;
end;

procedure TIntegerCell.SetAsString(const Value: WideString);
begin
  if Value <> '' then FValue := StrToInt(Value) else FValue := 0;
  inherited;
end;

{ TStringCell }

procedure TStringCell.Clear;
begin
  FValue := '';
  inherited;
end;

constructor TStringCell.Create(Cells: TCells);
begin
  inherited;

end;

function TStringCell.GetAsBoolean: Boolean;
begin
  Result := StrToBool(FValue);
end;

function TStringCell.GetAsDateTime: TDateTime;
begin
  if FValue <> '' then Result := StrToDateTime(FValue)
    else Result := 0;
end;

function TStringCell.GetAsFloat: Double;
begin
  Result := StrToFloat(FValue);
end;

function TStringCell.GetAsInteger: Integer;
begin
  Result := StrToInt(FValue);
end;

function TStringCell.GetAsString: WideString;
begin
  Result := FValue;
end;

procedure TStringCell.SetAsBoolean(const Value: Boolean);
begin
  FValue := BoolToStr(Value, True);
  inherited;
end;

procedure TStringCell.SetAsDateTime(const Value: TDateTime);
begin
  FValue := DateTimeToStr(Value);
  inherited;
end;

procedure TStringCell.SetAsFloat(const Value: Double);
begin
  FValue := FloatToStr(Value);
  inherited;
end;

procedure TStringCell.SetAsInteger(const Value: Integer);
begin
  FValue := IntToStr(Value);
  inherited;
end;

procedure TStringCell.SetAsString(const Value: WideString);
begin
  FValue := Value;
  inherited;
end;

{ TIncrementCell }

procedure TIncrementCell.Clear;
begin

end;

function TIncrementCell.GetAsBoolean: Boolean;
begin
  Result := False;
end;

function TIncrementCell.GetAsDateTime: TDateTime;
begin
  Result := 0;
end;

function TIncrementCell.GetAsFloat: Double;
begin
  Result := RowIndex + 1;
end;

function TIncrementCell.GetAsInteger: Integer;
begin
  Result := RowIndex + 1;
end;

function TIncrementCell.GetAsString: WideString;
begin
  Result := IntToStr(RowIndex + 1);
end;

end.
