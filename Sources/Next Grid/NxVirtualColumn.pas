{
  Next Grid
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxVirtualColumn.pas wim
}

unit NxVirtualColumn;

interface 

uses 
  Classes, NxEdit, NxColumns, NxColumnClasses, NxDisplays, NxCells; 

type
  TGetTextEvent = procedure (Sender: TObject; const ACol, ARow: Integer; var Value: WideString) of object;
  TSetTextEvent = procedure (Sender: TObject; const ACol, ARow: Integer; const Value: WideString) of object; 

  TNxVirtualColumn = class;
  TNxGuidColumn = class;

  TGuidCell = class(TCell)
  private
    FValue: TGUID;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: WideString; override;
    function GetAsGuid: TGuid;
    procedure SetAsBoolean(const Value: Boolean); override;
    procedure SetAsDateTime(const Value: TDateTime); override;
    procedure SetAsFloat(const Value: Double); override;
    procedure SetAsInteger(const Value: Integer); override;
    procedure SetAsString(const Value: WideString); override;
    procedure SetAsGuid(const Value: TGuid);
  public
    constructor Create(Cells: TCells); override;
    property AsGuid : TGUID read GetAsGuid write SetAsGuid;
  end;

  TNxGuidColumn = class(TNxCustomColumn)
  private
    FTextAfter: WideString;
    FTextBefore: WideString;
    FAutoExecute: Boolean;
    procedure SetAutoExecute(const Value: Boolean);
    procedure SetTextAfter(const Value: WideString);
    procedure SetTextBefore(const Value: WideString);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TComponent); override;
    function GetCellEditorClass: TCellEditorClass; override;
    function IsKeyValid(Key: Char): Boolean; override;
  published
    property AutoExecute: Boolean read FAutoExecute write SetAutoExecute;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
    property TextBefore: WideString read FTextBefore write SetTextBefore;
  end;

  TNxGuidColumnDisplay = class(TColumnDisplay)
  public
    procedure Paint; override;
  end;

  TVirtualCell = class(TCell)
  private
    FColumn: TNxVirtualColumn;
    procedure SetColumn(const Value: TNxVirtualColumn);
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
    property Column: TNxVirtualColumn read FColumn write SetColumn;
  end;

  TNxVirtualColumn = class(TNxCustomColumn)
  private 
    FTextAfter: WideString; 
    FTextBefore: WideString; 
    FAutoExecute: Boolean;
    FOnGetText: TGetTextEvent;
    FOnSetText: TSetTextEvent;
    procedure SetAutoExecute(const Value: Boolean);
    procedure SetTextAfter(const Value: WideString);
    procedure SetTextBefore(const Value: WideString);
  protected
    function GetColumnDisplayClass: TColumnDisplayClass; override;
    function GetColumnStyle: TColumnStyle; override;
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner: TComponent); override;
    function GetCellEditorClass: TCellEditorClass; override;
    function GetDrawText(Cell: TCellInfo): WideString; override;
    function IsKeyValid(Key: Char): Boolean; override;
    procedure DoGetText(const ACol, ARow: Integer; var Value: WideString); dynamic;
    procedure DoSetText(const ACol, ARow: Integer; const Value: WideString); dynamic;
  published
    property AutoExecute: Boolean read FAutoExecute write SetAutoExecute;
    property TextAfter: WideString read FTextAfter write SetTextAfter;
    property TextBefore: WideString read FTextBefore write SetTextBefore;
    property OnGetText: TGetTextEvent read FOnGetText write FOnGetText;
    property OnSetText: TSetTextEvent read FOnSetText write FOnSetText;
  end;

implementation 

uses 
  NxGrid, SysUtils, Dialogs, ActiveX;

{ TNxGuidColumn } 

procedure TNxGuidColumn.Assign(Source: TPersistent); 
begin 
  inherited;
  if Source is TNxGuidColumn then
  begin
    AutoExecute := TNxGuidColumn(Source).AutoExecute;
    TextAfter := TNxGuidColumn(Source).TextAfter;
    TextBefore := TNxGuidColumn(Source).TextBefore;
  end;
end;

constructor TNxGuidColumn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoExecute := False;
  FTextAfter := '';
  FTextBefore := '';
  DefaultValue := '';
  Options := Options + [coShowTextFitHint];
  SetSortType(stAlphabetic);
  SetColumnType(ctGuid);
end;

procedure TNxGuidColumn.SetAutoExecute(const Value: Boolean); 
begin 
  FAutoExecute := Value;
end;

procedure TNxGuidColumn.SetTextAfter(const Value: WideString);
begin
  FTextAfter := Value;
end;

procedure TNxGuidColumn.SetTextBefore(const Value: WideString);
begin
  FTextBefore := Value;
end;

function TNxGuidColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TNxGuidColumnDisplay;
end;

function TNxGuidColumn.GetCellEditorClass: TCellEditorClass;
begin 
  Result := TNxEdit;
end;

function TNxGuidColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

function TNxGuidColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := Ord(Key) > 32;
end;

{ TGuidCell }

constructor TGuidCell.Create(Cells: TCells);
begin
  inherited Create(Cells);
  CoCreateGuid(FValue);
end;

function TGuidCell.GetAsBoolean: Boolean;
begin
  Result := StrToBool(GetAsString);
end;

function TGuidCell.GetAsDateTime: TDateTime;
begin
  Result := StrToDateTime(GetAsString);
end;

function TGuidCell.GetAsFloat: Double;
begin
  Result := StrToFloat(GetAsString);
end;

function TGuidCell.GetAsGuid: TGuid;
begin
  Result := FValue;
end;

function TGuidCell.GetAsInteger: Integer;
begin
  Result := StrToInt(GetAsString);
end;

function TGuidCell.GetAsString: WideString;
begin
  Result := GuidToString(FValue);
end;

procedure TGuidCell.SetAsBoolean(const Value: Boolean);
begin
  SetAsString(BoolToStr(Value, True));
  inherited;
end;

procedure TGuidCell.SetAsDateTime(const Value: TDateTime);
begin
  SetAsString(DateTimeToStr(Value));
  inherited;
end;

procedure TGuidCell.SetAsFloat(const Value: Double);
begin
  SetAsString(FloatToStr(Value));
  inherited;
end;

procedure TGuidCell.SetAsInteger(const Value: Integer);
begin
  SetAsString(IntToStr(Value));
  inherited;
end;

procedure TGuidCell.SetAsString(const Value: WideString);
begin
  FValue := StringToGuid(Value);
  inherited;
end;

procedure TGuidCell.SetAsGuid(const Value: TGuid);
begin
  FValue := Value;
end;

{ TNxGuidColumnDisplay }

procedure TNxGuidColumnDisplay.Paint;
begin
  with Column as TNxGuidColumn do
    DrawTextRect(TextBefore + AsString + TextAfter, GetTextRect);
end;

{ TNxVirtualColumn } 

procedure TNxVirtualColumn.Assign(Source: TPersistent); 
begin 
  inherited; 
  if Source is TNxVirtualColumn then 
  begin
    AutoExecute := TNxVirtualColumn(Source).AutoExecute;
    TextAfter := TNxVirtualColumn(Source).TextAfter;
    TextBefore := TNxVirtualColumn(Source).TextBefore;
  end; 
end; 

constructor TNxVirtualColumn.Create(AOwner: TComponent);
begin 
  inherited Create(AOwner);
  FAutoExecute := False;
  FTextAfter := '';
  FTextBefore := ''; 
  DefaultValue := ''; 
  Options := Options + [coShowTextFitHint]; 
  SetSortType(stAlphabetic);
  SetColumnType(ctVirtual); 
end; 

procedure TNxVirtualColumn.SetAutoExecute(const Value: Boolean); 
begin 
  FAutoExecute := Value; 
end; 

procedure TNxVirtualColumn.SetTextAfter(const Value: WideString); 
begin 
  FTextAfter := Value; 
end; 

procedure TNxVirtualColumn.SetTextBefore(const Value: WideString); 
begin
  FTextBefore := Value;
end;

function TNxVirtualColumn.GetColumnDisplayClass: TColumnDisplayClass;
begin
  Result := TTextColumnDisplay;
end;

function TNxVirtualColumn.GetCellEditorClass: TCellEditorClass;
begin 
  Result := TNxEdit;
end;

function TNxVirtualColumn.GetDrawText(Cell: TCellInfo): WideString;
begin
  Result := TextBefore + Cell.AsString + TextAfter;
end;

function TNxVirtualColumn.IsKeyValid(Key: Char): Boolean;
begin
  Result := Ord(Key) > 32;
end;

procedure TNxVirtualColumn.DoGetText(const ACol, ARow: Integer; var Value: WideString);
begin
  if Assigned(FOnGetText) then FOnGetText(Self, ACol, ARow, Value);
end;

procedure TNxVirtualColumn.DoSetText(const ACol, ARow: Integer; const Value: WideString);
begin
  if Assigned(FOnSetText) then FOnSetText(Self, ACol, ARow, Value);
end;

function TNxVirtualColumn.GetColumnStyle: TColumnStyle;
begin
  Result := [csCanEdit, csFitToLargest, csTextFitHint];
end;

{ TVirtualCell }

constructor TVirtualCell.Create(Cells: TCells);
begin
  inherited;  
end;

procedure TVirtualCell.SetColumn(const Value: TNxVirtualColumn);
begin
  FColumn := Value;
end;

function TVirtualCell.GetAsBoolean: Boolean;
begin
  Result := StrToBool(GetAsString);
end;

function TVirtualCell.GetAsDateTime: TDateTime;
begin
  Result := StrToDateTime(GetAsString);
end;

function TVirtualCell.GetAsFloat: Double;
begin
  Result := StrToFloat(GetAsString);
end;

function TVirtualCell.GetAsInteger: Integer;
begin
  Result := StrToInt(GetAsString);
end;

function TVirtualCell.GetAsString: WideString;
begin
  FColumn.DoGetText(ColumnIndex, RowIndex, Result);
end;

procedure TVirtualCell.SetAsBoolean(const Value: Boolean);
begin
  SetAsString(BoolToStr(Value, True));
  inherited;
end;

procedure TVirtualCell.SetAsDateTime(const Value: TDateTime);
begin
  SetAsString(DateTimeToStr(Value));
  inherited;
end;

procedure TVirtualCell.SetAsFloat(const Value: Double);
begin
  SetAsString(FloatToStr(Value));
  inherited;
end;

procedure TVirtualCell.SetAsInteger(const Value: Integer);
begin
  SetAsString(IntToStr(Value));
  inherited;
end;

procedure TVirtualCell.SetAsString(const Value: WideString);
begin
  FColumn.DoSetText(ColumnIndex, RowIndex, Value);
  inherited; 
end;

end.

 