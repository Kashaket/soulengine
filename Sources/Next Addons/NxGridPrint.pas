{
  Add Ons 1.1
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxGridPrint.pas bn
}

unit NxGridPrint;

interface

uses
	Windows, Classes, Printers, Graphics, NxCellClasses, NxGrid, NxColumnClasses,
  NxCustomGridControl, NxCustomGrid, ExtCtrls, NxSharedCommon, NxDisplays, NxColumns, Dialogs;

type
	TGridPrintOptions = set of (poHorzGridLines, poIgnoreColumnColor,
	  poSelectedRows);

  TPrintState = (psIdle, psPrinting);

	TMargins = class(TPersistent)
  private
    FTop: Integer;
    FBottom: Integer;
    FRight: Integer;
    FLeft: Integer;
    procedure SetBottom(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetRight(const Value: Integer);
    procedure SetTop(const Value: Integer);
  published
  	property Bottom: Integer read FBottom write SetBottom default 20;
  	property Left: Integer read FLeft write SetLeft default 10;
  	property Right: Integer read FRight write SetRight default 20;
  	property Top: Integer read FTop write SetTop default 10;
  end;

  TPrintMedia = (pmPaper, pmScreen);

	TNxCustomGridPrint = class(TComponent)
  private
    FActualToRow: Integer;
    FColumnDisplay: TStyleDisplay;
    FCurrentRow: Integer;
    FHeaderSize: Integer;
    FInnerMargins: TMargins;
    FOptions: TGridPrintOptions;
    FPageHeight: Integer;
    FPageWidth: Integer;
    FPrintState: TPrintState;
    FRowSize: Integer;
    FToRow: Integer;
    FFromRow: Integer;
    FLinePos: Integer;
    FPageNumber: Integer;
    FPrintMedia: TPrintMedia;
    FOnApplyCell: TApplyCellEvent;
    function GetClientRect: TRect;
    function GetClientWidth: Integer;
    procedure SetFromRow(const Value: Integer);
    procedure SetHeaderSize(const Value: Integer);
    procedure SetInnerMargins(const Value: TMargins);
    procedure SetLinePos(const Value: Integer);
    procedure SetOptions(const Value: TGridPrintOptions);
    procedure SetPageHeight(const Value: Integer);
    procedure SetPageWidth(const Value: Integer);
    procedure SetPrintMedia(const Value: TPrintMedia);
    procedure SetRowSize(const Value: Integer);
    procedure SetToRow(const Value: Integer);
  protected
    FCanvas: TCanvas;
    FGrid: TNxCustomGrid;
    function GetLastRow: Integer;
    function GetSpace(const Height: Integer): Boolean;
    procedure AfterPrint; virtual;
    procedure BeforePrint; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PrintCell(ACol, ARow: Integer; AColor: TColor); virtual;
    procedure PrintHeaders; virtual;
    procedure PrintLine(Y, LineHeight: Integer); virtual;
    procedure PrintPage; virtual;
    procedure PrintRow(const Index: Integer); virtual;
    procedure PrintRows; virtual;
    procedure SetPrintState(const Value: TPrintState);
    procedure SetGridControl(const Grid: TNxCustomGrid);
    property ColumnDisplay: TStyleDisplay read FColumnDisplay;
  public
  	constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
  	function Print: Boolean;
    procedure NewPage; virtual;
    procedure PrintToCanvas(ACanvas: TCanvas);
    property ClientRect: TRect read GetClientRect;
    property ClientWidth: Integer read GetClientWidth;
    property LinePos: Integer read FLinePos write SetLinePos;
    property CurrentRow: Integer read FCurrentRow;
    property PageNumber: Integer read FPageNumber;
  published
  	property FromRow: Integer read FFromRow write SetFromRow default 0;
    property HeaderSize: Integer read FHeaderSize write SetHeaderSize;
    property InnerMargins: TMargins read FInnerMargins write SetInnerMargins;
    property Options: TGridPrintOptions read FOptions write SetOptions;
    property PageHeight: Integer read FPageHeight write SetPageHeight;
    property PageWidth: Integer read FPageWidth write SetPageWidth;
    property PrintMedia: TPrintMedia read FPrintMedia write SetPrintMedia default pmPaper;
    property RowSize: Integer read FRowSize write SetRowSize;
		property ToRow: Integer read FToRow write SetToRow default 0;

    property OnApplyCell: TApplyCellEvent read FOnApplyCell write FOnApplyCell;
  end;

  TNxGridPrint = class(TNxCustomGridPrint)
  private
    FAssociate: TNextGrid;
    procedure SetAssociate(const Value: TNextGrid);
  protected
    procedure BeforePrint; override;
    procedure PrintCell(ACol, ARow: Integer; AColor: TColor); override;
    procedure PrintRows; override;
  published
    property Associate: TNextGrid read FAssociate write SetAssociate;
  end;

implementation

uses
	SysUtils;

{ TMargins }

procedure TMargins.SetBottom(const Value: Integer);
begin                             
  FBottom := Value;
end;

procedure TMargins.SetLeft(const Value: Integer);
begin
  FLeft := Value;
end;

procedure TMargins.SetRight(const Value: Integer);
begin
  FRight := Value;
end;

procedure TMargins.SetTop(const Value: Integer);
begin
  FTop := Value;
end;

{ TNxCustomGridPrint }

constructor TNxCustomGridPrint.Create(AOnwer: TComponent);
begin
  inherited;
  FColumnDisplay := TFlatStyleDisplay.Create(Self);
  FColumnDisplay.DisplayMedia := dmPaper;
  FCurrentRow := 0;
  FFromRow := 0;
  FInnerMargins := TMargins.Create;
  FInnerMargins.Left := 10;
  FInnerMargins.Top := 10;
  FInnerMargins.Right := 20;
  FInnerMargins.Bottom := 20;
  FOptions := [poHorzGridLines];
  FPrintMedia := pmPaper;
  FPrintState := psIdle;
  FToRow := 0;
  FActualToRow := 0;
  FRowSize := 86;
  FHeaderSize := 100;
end;

destructor TNxCustomGridPrint.Destroy;
begin
  FreeAndNil(FColumnDisplay);
  FreeAndNil(FInnerMargins);
  inherited;
end;

function TNxCustomGridPrint.GetClientRect: TRect;
begin
  Result := Rect(FInnerMargins.Left, FInnerMargins.Top, FPageWidth - FInnerMargins.Right, FPageHeight - FInnerMargins.Bottom);
end;

function TNxCustomGridPrint.GetClientWidth: Integer;
begin
  Result := FPageWidth - InnerMargins.Left - InnerMargins.Right;
end;

function TNxCustomGridPrint.GetLastRow: Integer;
begin
  if FToRow = 0 then Result := FGrid.RowCount - 1 else Result := FToRow;
end;

procedure TNxCustomGridPrint.SetFromRow(const Value: Integer);
begin
  FFromRow := Value;
end;

procedure TNxCustomGridPrint.SetHeaderSize(const Value: Integer);
begin
  FHeaderSize := Value;
end;

procedure TNxCustomGridPrint.SetLinePos(const Value: Integer);
begin
  FLinePos := Value;
end;

procedure TNxCustomGridPrint.SetInnerMargins(const Value: TMargins);
begin
  FInnerMargins := Value;
end;

procedure TNxCustomGridPrint.SetOptions(const Value: TGridPrintOptions);
begin
  FOptions := Value;
end;

procedure TNxCustomGridPrint.SetPageHeight(const Value: Integer);
begin
  FPageHeight := Value;
end;

procedure TNxCustomGridPrint.SetPageWidth(const Value: Integer);
begin
  FPageWidth := Value;
end;

procedure TNxCustomGridPrint.SetPrintMedia(const Value: TPrintMedia);
begin
  FPrintMedia := Value;
end;

procedure TNxCustomGridPrint.SetRowSize(const Value: Integer);
begin
  FRowSize := Value;
end;

procedure TNxCustomGridPrint.SetToRow(const Value: Integer);
begin
  FToRow := Value;
end;

procedure TNxCustomGridPrint.AfterPrint;
begin

end;

procedure TNxCustomGridPrint.BeforePrint;
begin
  FPrintState := psPrinting;
end;

procedure TNxCustomGridPrint.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FGrid) then SetGridControl(nil);
end;

procedure TNxCustomGridPrint.PrintHeaders;
var
  I, X, NewWidth: Integer;
  Ratio: Double;
  HeaderRect: TRect;
begin
  X := FInnerMargins.Left;
  with FGrid do
  begin
    GetSpace(HeaderSize);
    for I := 0 to Columns.Count - 1 do
    begin
      if Columns.PositionItem[i].Visible then
      begin
        Ratio := (Columns.PositionItem[i].Width / Columns.ClientWidth) * 100;
        NewWidth := Round(Self.ClientWidth * (Ratio / 100));
        HeaderRect := Rect(X, FLinePos, X + NewWidth, FLinePos + FHeaderSize);
        FColumnDisplay.DrawHeader(Columns.PositionItem[i], HeaderRect);
        Inc(X, NewWidth);
      end;
    end;
  end;
  Inc(FLinePos, FHeaderSize);
end;

procedure TNxCustomGridPrint.PrintRows;
begin

end;

procedure TNxCustomGridPrint.SetPrintState(const Value: TPrintState);
begin
  FPrintState := Value;
end;

procedure TNxCustomGridPrint.SetGridControl(const Grid: TNxCustomGrid);
begin
  FGrid := Grid;
  if Assigned(FGrid) then FGrid.FreeNotification(Self);
end;

function TNxCustomGridPrint.GetSpace(const Height: Integer): Boolean;
begin
  if FLinePos + Height > FPageHeight - FInnerMargins.Bottom then
  begin
    FLinePos := FInnerMargins.Top;
    Result := False;
  end else Result := True;
end;

procedure TNxCustomGridPrint.NewPage;
begin
  if PrintMedia = pmPaper then Printer.NewPage
    else SetPrintState(psIdle);
end;

function TNxCustomGridPrint.Print: Boolean;
begin
	if Assigned(FGrid) then
  begin
    Printer.BeginDoc;
    if PrintMedia = pmPaper then
    begin
      FPageHeight := Printer.PageHeight;
      FPageWidth := Printer.PageWidth;
    end;
    PrintToCanvas(Printer.Canvas);
    Printer.EndDoc;
  end;
  Result := True;
end;

procedure TNxCustomGridPrint.PrintCell(ACol, ARow: Integer; AColor: TColor);
begin

end;

procedure TNxCustomGridPrint.PrintLine(Y, LineHeight: Integer);
var
  I: Integer;
begin
  with FCanvas do
  begin
    if not GetSpace(LineHeight) then
    begin
      NewPage;
      Exit;             
    end;
    Pen.Color := clBlack;
    for i := 1 to LineHeight do
    begin
      MoveTo(FInnerMargins.Left, Y);
      LineTo(FPageWidth - InnerMargins.Right, Y);
      Inc(Y);
    end;
    Inc(FLinePos, LineHeight);
  end;
end;

procedure TNxCustomGridPrint.PrintPage;
begin
  PrintHeaders;
  PrintRows;
end;

procedure TNxCustomGridPrint.PrintRow(const Index: Integer);
var
  I, X, NewWidth: Integer;
  Ratio: Double;
  CellColor: TColor;
begin
  X := InnerMargins.Left;
  with FGrid do
  begin
    for i := 0 to Columns.Count - 1 do
    begin
      if Columns.PositionItem[i].Visible then
      begin
        Ratio := (Columns.PositionItem[i].Width / Columns.ClientWidth) * 100;
        NewWidth := Round(Self.ClientWidth * (Ratio / 100));
        with Columns.PositionItem[i].Display do
        begin
          Canvas := FCanvas;
          ClientRect := Rect(X, LinePos, X + NewWidth, LinePos + Self.RowSize);
          if (poIgnoreColumnColor in Self.Options)
            then CellColor := Color
              else CellColor := Columns.PositionItem[i].Color;
				  Font.Assign(FGrid.Columns.PositionItem[i].Font);
          PrintCell(FGrid.Columns.PositionItem[i].Index, CurrentRow, CellColor);
        end;
        Inc(X, NewWidth);
      end;
    end;
  end;
end;

procedure TNxCustomGridPrint.PrintToCanvas(ACanvas: TCanvas);
begin
  if Assigned(FGrid) then
  begin
    if FToRow = 0 then FActualToRow := FGrid.RowCount - 1
      else FActualToRow := FToRow;
    FLinePos := FInnerMargins.Top;
    FCanvas := ACanvas;
    FColumnDisplay.Canvas := FCanvas;
    FPageNumber := 0;
    BeforePrint;
    while FPrintState <> psIdle do PrintPage;
    AfterPrint;
  end;
end;

{ TNxGridPrint }

procedure TNxGridPrint.SetAssociate(const Value: TNextGrid);
begin
  FAssociate := Value;
  SetGridControl(FAssociate);
end;

procedure TNxGridPrint.BeforePrint;
begin
  inherited;
  FCurrentRow := FFromRow;
end;

procedure TNxGridPrint.PrintCell(ACol, ARow: Integer; AColor: TColor);
begin
  with FGrid as TNextGrid, FGrid.Columns[ACol] do
  begin
    with Display.Canvas do
    begin
      Font.Assign(Columns[ACol].Font);
    end;
    case ColumnType of
      ctAutoInc: Display.AsInteger := ARow;
      ctBoolean: Display.AsBoolean := Cell[ACol, ARow].AsBoolean;
      ctDate: Display.AsDateTime := Cell[ACol, ARow].AsDateTime;
      ctFloat: Display.AsFloat := Cell[ACol, ARow].AsFloat;
      ctInteger: Display.AsInteger := Cell[ACol, ARow].AsInteger;
      ctString: Display.AsString := Cell[ACol, ARow].AsString;
    end;
    Display.Paint;
  end;
end;

procedure TNxGridPrint.PrintRows;
begin
  while FCurrentRow <= FActualToRow do
  begin
    with FGrid do
    begin
      if not GetSpace(RowSize) then
      begin
        NewPage;
        Exit;
      end;
      if (not(poSelectedRows in FOptions) or Selected[FCurrentRow])
        and RowVisible[FCurrentRow] then
      begin
        PrintRow(FCurrentRow);
        LinePos := LinePos + Self.RowSize;
        if poHorzGridLines in FOptions then PrintLine(FLinePos, 1);
      end;
      Inc(FCurrentRow);
    end;
  end;
  { stop with printing }
  if FCurrentRow >= FActualToRow
    then SetPrintState(psIdle);
end;

end.
