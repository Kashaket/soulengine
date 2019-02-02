{
  Next Grid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:NxColumnDragBox.pas 12/25/2002 7:10:16 bn v1.1
}

unit NxColumnDragBox;

interface

uses
  Types, Classes, Windows, Controls, Messages, Graphics,
  NxColumns, NxDisplays, NxSharedCommon, NxFlyoutControl;

type
  TDragBoxEvent = procedure (Sender: TObject; X, Y: Integer) of object;

  TColumnDragBox = class(TNxFlyoutControl)
  private
    FOwner: TComponent;
    FColumn: TNxCustomColumn;
    FColumnDisplay: TStyleDisplay;
    FOnDragBoxDrop: TDragBoxEvent;
    FOnDragBoxMove: TDragBoxEvent;
  protected
    procedure DoDragBoxDrop(X, Y: Integer); dynamic;
    procedure DoDragBoxMove(X, Y: Integer); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Show(X, Y: Integer; AColumn: TNxCustomColumn; Hide: Boolean = False);
    property Font;
    property OnDragBoxDrop: TDragBoxEvent read FOnDragBoxDrop write FOnDragBoxDrop;
    property OnDragBoxMove: TDragBoxEvent read FOnDragBoxMove write FOnDragBoxMove;
  end;

  TArrowKind = (akNone, akUp, akDown);

  TDragArrow = class(TNxFlyoutControl)
  private
    FArrowKind: TArrowKind;
    procedure SetArrowKind(const Value: TArrowKind);
  protected
    procedure Paint; override;
    procedure SetWindowShape; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property ArrowKind: TArrowKind read FArrowKind write SetArrowKind;
  end;

implementation

uses
  ExtCtrls, Dialogs, SysUtils, NxCustomGrid, NxGridCommon,
  NxCustomGridControl;

var
  OldX, OldY: Integer;

{ TColumnDragBox }

constructor TColumnDragBox.Create(AOwner: TComponent);
begin
  inherited;
  FOwner := AOwner;
  FColumnDisplay := TDefaultStyleDisplay.Create(Self);
  FColumnDisplay.Canvas := Canvas;
end;

destructor TColumnDragBox.Destroy;
begin
  FColumnDisplay.Free;
  inherited;
end;

procedure TColumnDragBox.DoDragBoxDrop(X, Y: Integer);
begin
  if Assigned(FOnDragBoxDrop) then FOnDragBoxDrop(Self, X, Y);
end;

procedure TColumnDragBox.DoDragBoxMove(X, Y: Integer);
begin
  if Assigned(FOnDragBoxMove) then FOnDragBoxMove(Self, X, Y);
end;

procedure TColumnDragBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  APoint, CursorPoint, BoxPoint: TPoint;
begin
  APoint := ClientToScreen(Point(X, Y));
  with BoxPoint do
  begin
    X := APoint.X - ClientWidth div 2;
    Y := APoint.Y - ClientHeight + spDragBoxToCursorSpace;
  end;
  with CursorPoint do
  begin
    X := APoint.X;
    Y := APoint.Y;
  end;
  DoDragBoxMove(CursorPoint.X, CursorPoint.Y);
  SetBounds(BoxPoint.X, BoxPoint.Y, ClientWidth, ClientHeight);
end;

procedure TColumnDragBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  CursorPoint: TPoint;
begin
	if Button = mbLeft then
  begin
    Visible := False;
    CursorPoint := ClientToScreen(Point(X, Y));
    DoDragBoxDrop(CursorPoint.X, CursorPoint.Y);
  end;
end;

procedure TColumnDragBox.Paint;
begin
  inherited;
  FColumnDisplay.DrawHeader(FColumn, ClientRect);
  with Canvas do
  begin
    Pen.Color := clBlack;
    MoveTo(0, ClientHeight - 1);
    LineTo(ClientWidth - 1, ClientHeight - 1);
    LineTo(ClientWidth - 1, - 1);
  end;
end;

procedure TColumnDragBox.Show(X, Y: Integer; AColumn: TNxCustomColumn; Hide: Boolean = False);
var
  ClientPoint: TPoint;
begin
  FColumnDisplay.DefaultDrawing := False;
  FColumnDisplay.Canvas.Font := TNxCustomGrid(FOwner).Font;

  Visible := not Hide;
  FColumn := AColumn;
  ClientPoint := ScreenToClient(Point(X, Y));
  OldX := ClientPoint.X;
  OldY := ClientPoint.Y;
  SendMessage(Handle, WM_LBUTTONDOWN, 0, 0); { do MouseDown }
end;

{ TDragArrow }

constructor TDragArrow.Create(AOwner: TComponent);
begin
  inherited;
  FArrowKind := akNone;
  Height := sizDragArrowHeight;
  Width := sizDragArrowWidth;
end;

procedure TDragArrow.SetArrowKind(const Value: TArrowKind);
begin
  FArrowKind := Value;
  SetWindowShape;
end;

procedure TDragArrow.Paint;
begin
  inherited;
  with Canvas do
  begin
    Brush.Color := clRed;
    FillRect(ClientRect);
  end;
end;

procedure TDragArrow.SetWindowShape;
var
  APoints: array[1..8] of TPoint;
  R: HRGN;
begin
  inherited;
  case FArrowKind of
    akDown:
    begin
      APoints[1] := Point(5, 0);
      APoints[2] := Point(3, 0);
      APoints[3] := Point(3, 4);
      APoints[4] := Point(0, 4);
      APoints[5] := Point(4, 9);
      APoints[6] := Point(9, 4);
      APoints[7] := Point(6, 4);
      APoints[8] := Point(6, 0);
    end;
    akUp:
    begin
      APoints[1] := Point(-1, 5);
      APoints[2] := Point(4, -1);
      APoints[3] := Point(9, 5);
      APoints[4] := Point(6, 5);
      APoints[5] := Point(6, 9);
      APoints[6] := Point(3, 9);
      APoints[7] := Point(3, 4);
      APoints[8] := Point(0, 5);
    end;
  end;
  R := CreatePolygonRgn(APoints, 8, WINDING);
  SetWindowRgn(Handle, R, True);
end;

end.

