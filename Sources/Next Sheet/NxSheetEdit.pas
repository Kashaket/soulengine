{
  NxSheet
  Copyright (C) 1996-2006 by Berg
  All rights reserved.

  $id:NxSheetEdit.pas bn
}

unit NxSheetEdit;

interface

uses
  Classes, Types, Graphics, Controls, Windows, SysUtils;

type
  TNxSheetEdit = class
  private
    FCanvas: TCanvas;
    FColor: TColor;
    FCursorPos: Integer;
    FHeight: Integer;
    FLeft: Integer;
    FMouseDown: Boolean;
    FMouseDownStart: Integer;
    FOldSelStart: Integer;
    FSelCount: Integer;
    FSelLength: Integer;
    FSelEnd: Integer;
    FSelStart: Integer;
    FText: TCaption;
    FTop: Integer;
    FWidth: Integer;
    FFont: TFont;
    function GetClientRect: TRect;
    function GetCursorPos: Integer;
    function GetSelLength: Integer;
    function GetSelText: string;
    procedure Backspace;
    procedure DeleteSelected;
    procedure EndKey(Select: Boolean = False);
    procedure Home(Select: Boolean = False);
    procedure SetSelText(const Value: string);
    procedure SetSelLength(const Value: Integer);
  public
    constructor Create(ACanvas: TCanvas);
    destructor Destroy; override;
    function GetCursorAtPos(const X, Y: Integer): Integer;
    procedure DblClick;
    procedure DrawCursor;
    procedure DrawText;
    procedure KeyDown(var Key: Word; Shift: TShiftState); dynamic;
    procedure KeyPress(var Key: Char); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MoveCursor(Distance: Integer; Select: Boolean = False);
    procedure Paint; dynamic;
    procedure SelectAll;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); virtual;
    property ClientRect: TRect read GetClientRect;
    property Color: TColor read FColor write FColor;
    property Font: TFont read FFont write FFont;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read FSelStart write FSelStart;
    property SelText: string read GetSelText write SetSelText;
    property Text: TCaption read FText write FText;
  end;

implementation

uses
  NxSharedCommon, Math;

{ TNxSheetEdit }

constructor TNxSheetEdit.Create(ACanvas: TCanvas);
begin
  FCanvas := ACanvas;
  FCursorPos := 0;
  FFont := TFont.Create;
  FMouseDown := False;
  FMouseDownStart := -1;
  FOldSelStart := 0;
  FSelCount := 0;
  FSelLength := 0;
  FSelStart := 1;
end;

destructor TNxSheetEdit.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

procedure TNxSheetEdit.Backspace;
begin
  if SelLength > 0 then
  begin
    DeleteSelected;
    Paint;
  end else
  begin
    if FSelStart > 1 then
    begin
      System.Delete(FText, FSelStart - 1, 1);
      Dec(FSelStart);
      Paint;
    end;
  end;
end;

procedure TNxSheetEdit.DeleteSelected;
var
  Start: Integer;
begin
  if FSelCount > 0 then
  begin
    if FSelStart > FSelEnd then Start := FSelEnd else Start := FSelStart;
    System.Delete(FText, Start, Abs(FSelStart - FSelEnd));
    FSelCount := 0;
    FSelEnd := Start;
    FSelStart := Start;
  end else
  begin
    System.Delete(FText, FSelStart, 1);
  end;
  Paint;
end;

procedure TNxSheetEdit.EndKey(Select: Boolean);
begin
  if Select then
  begin
    FSelStart := FSelEnd;
    FSelEnd := 1;
  end else
  begin
    FSelStart := Length(Text) + 1;
    FSelEnd := FSelStart;
  end;
  Paint;
end;

procedure TNxSheetEdit.Home;
begin
  if Select then
  begin
    FSelStart := FSelEnd;
    FSelEnd := 1;
  end else
  begin
    FSelStart := 1;
    FSelEnd := 1;
  end;
  Paint;
end;

procedure TNxSheetEdit.DblClick;
begin
  SelectAll;
end;

procedure TNxSheetEdit.DrawCursor;
begin
  FCursorPos := GetCursorPos + FLeft + 2;
  with FCanvas do
  begin
    Pen.Mode := pmNot;
    Polyline([Point(FCursorPos, FTop), Point(FCursorPos, FTop + FHeight)]);
    Pen.Mode := pmCopy;
  end;
end;

procedure TNxSheetEdit.DrawText;
var
  i, Pos, PosY, CharWidth, Max, Min: Integer;
  CharRect, BlankRect: TRect;
begin
  with FCanvas do
  begin
    Font.Assign(FFont);
    FillRect(Rect(FLeft, FTop, FLeft + 2, FTop + FHeight));
    Pos := FLeft + 2;
    if FSelCount > 0 then
    begin
      if FSelStart > FSelEnd then
      begin
        Min := FSelEnd;
        Max := FSelStart - 1;
      end else
      begin
        Min := FSelStart;
        Max := FSelEnd - 1;
      end;
    end else
    begin
      Min := FSelStart;
      Max := FSelEnd - 1;
    end;
    for I := 1 to Length(FText) do
    begin
      CharWidth := FCanvas.TextWidth(FText[i]);
      SetRoundMode(rmUp);
      PosY := (FTop + FHeight) - TextHeight(FText) - 0;
      CharRect := Rect(Pos, FTop, Pos + CharWidth, FTop + FHeight);
      TextRect(CharRect, Pos, PosY, FText[i]);
      if FSelCount <> 0 then
      begin
        if InRange(I, Min, Max) then
        begin
          CopyMode := cmDstInvert;
          CopyRect(CharRect, FCanvas, CharRect);
          CopyMode := cmSrcCopy;
        end;
      end;
      Inc(Pos, CharWidth);
    end;
    if Pos < FLeft + FWidth then
    begin
      BlankRect := Rect(Pos, FTop, FLeft + FWidth, FTop + FHeight);
      FillRect(BlankRect);
      if Max = Length(FText) then
      begin
        FCanvas.CopyMode := cmDstInvert;
        FCanvas.CopyRect(BlankRect, FCanvas, BlankRect);
        FCanvas.CopyMode := cmSrcCopy;
      end;
    end;
  end;
end;

function TNxSheetEdit.GetClientRect: TRect;
begin
  Result := Rect(FLeft, FTop, FLeft + FWidth, FTop + FHeight);
end;

function TNxSheetEdit.GetCursorAtPos(const X, Y: Integer): Integer;
var
  i, Pos, CharWidth: Integer;
begin
  Result := Length(FText) + 1;
  Pos := FLeft;
  for i := 1 to Length(FText) do
  begin
    CharWidth := FCanvas.TextWidth(FText[i]);
    if InRange(X, Pos, Pos + CharWidth) then
    begin
      Result := i;
      Exit;
    end;
    Inc(Pos, CharWidth);
  end;
end;

function TNxSheetEdit.GetCursorPos: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(FText) do
  begin
    if i = FSelStart then Exit;
    Inc(Result, FCanvas.TextWidth(FText[i]));
  end;
end;

function TNxSheetEdit.GetSelLength: Integer;
begin
  Result := Abs(FSelCount);
end;

function TNxSheetEdit.GetSelText: string;
var
  Start: Integer;
begin
  if FSelStart > FSelEnd then Start := FSelEnd else Start := FSelStart;
  Result := Copy(FText, Start, Abs(FSelCount));
end;

procedure TNxSheetEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_LEFT:  MoveCursor(-1, ssShift in Shift);
    VK_RIGHT: MoveCursor(1, ssShift in Shift);
    VK_BACK:  Backspace;
    VK_DELETE:DeleteSelected;
    VK_HOME:  Home(ssShift in Shift);
    VK_END:   EndKey(ssShift in Shift);
  end;
end;

procedure TNxSheetEdit.KeyPress(var Key: Char);
begin
  if Abs(FSelCount) > 0 then DeleteSelected;
  Insert(Key, FText, FSelStart);
  Inc(FSelStart);
  Paint;
end;

procedure TNxSheetEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FMouseDown := True;
  FSelStart := GetCursorAtPos(X, Y);
  FMouseDownStart := FSelStart;
  FSelEnd := 0;
  FSelCount := 0;
  Paint;
end;

procedure TNxSheetEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Pos: Integer;
begin
  if FMouseDown then
  begin
    Pos := GetCursorAtPos(X, Y);
    FSelEnd := FMouseDownStart;
    FSelStart := Pos;
    FSelCount := Abs(Pos - FSelEnd);
    Paint;
  end;
end;

procedure TNxSheetEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  FMouseDown := False;
end;

procedure TNxSheetEdit.MoveCursor(Distance: Integer;
  Select: Boolean);
begin
  FOldSelStart := FSelStart;
  Inc(FSelStart, Distance);
  if FSelStart < 1 then FSelStart := 1;
  if FSelStart > Length(FText) + 1 then FSelStart := Length(FText) + 1;
  if Select then
  begin
    if FSelCount = 0 then FSelEnd := FOldSelStart;
    FSelCount := FSelCount + FSelStart - FOldSelStart;
  end else
  begin
    FSelEnd := 0;
    FSelCount := 0;
  end;
  Paint;
end;

procedure TNxSheetEdit.Paint;
begin
  with FCanvas do
  begin
    Brush.Color := Color;
    DrawText;
    DrawCursor;
  end;
end;

procedure TNxSheetEdit.SelectAll;
begin
  FSelStart := 1;
  FSelEnd := Length(FText);
  FSelCount := Length(FText);
  Paint;
end;

procedure TNxSheetEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
end;

procedure TNxSheetEdit.SetSelText(const Value: string);
begin

end;

procedure TNxSheetEdit.SetSelLength(const Value: Integer);
begin

end;

end.
