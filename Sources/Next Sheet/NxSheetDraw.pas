{
  NxSheet
  Copyright (C) 1996-2006 by Berg
  All rights reserved.

  $id:NxSheetDraw.pas bn
}

unit NxSheetDraw;

interface

uses
  Classes, Types, Graphics, Windows, NxClasses;

procedure DrawAngledText(Canvas: TCanvas; R: TRect; Text: WideString; Angle: TTextAngle);
procedure DrawDashDotDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
procedure DrawDashDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
procedure DrawDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
procedure DrawDotsRect(Canvas: TCanvas; R: TRect);
procedure DrawThinDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
procedure DrawThinLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
procedure DrawWideDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);

implementation

const
  DashDotDotPenStyle: array[1..6] of DWORD = (8, 4, 2, 4, 2, 4);
  DashDotPenStyle: array[1..4] of DWORD = (8, 4, 2, 4);
  DotPenStyle: array[1..2] of DWORD = (1, 3);
  ThinDotPenStyle: array[1..2] of DWORD = (0, 2);
  WideDotPenStyle: array[1..2] of DWORD = (2, 2);

procedure DrawAngledText(Canvas: TCanvas; R: TRect; Text: WideString; Angle: TTextAngle);
var
  LogFont: TLogFont;
  OldFont, NewFont: HFONT;
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or DT_TOP or DT_EXTERNALLEADING
    or DT_SINGLELINE or DT_RIGHT;
  with Canvas do
  begin
    Brush.Style := bsClear;
    GetObject(Font.Handle, SizeOf(LogFont), @LogFont);
    with LogFont do
    begin
      if Angle < 0
        then lfEscapement := (360 + Angle) * 10
        else lfEscapement := Angle * 10;

      lfOutPrecision := OUT_TT_ONLY_PRECIS;
      lfPitchAndFamily := DEFAULT_PITCH or FF_DONTCARE;
    end;
    NewFont := CreateFontIndirect(LogFont);
    OldFont := SelectObject(Canvas.Handle, NewFont);
    case UnicodeSupported of
      True:   DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), R, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), R, Flags);
              end;
    end;
    NewFont := SelectObject(Canvas.Handle, OldFont);
    DeleteObject(NewFont);
  end;
end;

procedure DrawLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer; Style: Array of DWORD);
var
  LogBrush: TLogBrush;
  C: TColor;
begin
  LogBrush.lbStyle := BS_SOLID;
  C := Canvas.Pen.Color;
  if Integer(C) < 0 then C := GetSysColor(C and $000000FF);
  LogBrush.lbColor := C;
  Canvas.Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_USERSTYLE,
    Canvas.Pen.Width, LogBrush, Length(Style), @Style);
  Canvas.MoveTo(X1, Y1);
  Canvas.LineTo(X2, Y2);
end;

procedure DrawDashDotDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  DrawLine(Canvas, X1, Y1, X2, Y2, DashDotDotPenStyle);
end;

procedure DrawDashDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  DrawLine(Canvas, X1, Y1, X2, Y2, DashDotPenStyle);
end;

procedure DrawDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  DrawLine(Canvas, X1, Y1, X2, Y2, DotPenStyle);
end;

procedure DrawDotsRect(Canvas: TCanvas; R: TRect);
var
  LogBrush: TLogBrush;
begin
  LogBrush.lbStyle := BS_SOLID;
  LogBrush.lbColor := Canvas.Pen.Color;
  Canvas.Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_USERSTYLE,
    Canvas.Pen.Width, LogBrush, Length(ThinDotPenStyle), @ThinDotPenStyle);
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(R);
end;

procedure DrawThinDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  DrawLine(Canvas, X1, Y1, X2, Y2, ThinDotPenStyle);
end;

procedure DrawThinLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  Canvas.Pen.Style := psSolid;
  Canvas.MoveTo(X1, Y1);
  Canvas.LineTo(X2, Y2);
end;

procedure DrawWideDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  DrawLine(Canvas, X1, Y1, X2, Y2, WideDotPenStyle);
end;

end.
