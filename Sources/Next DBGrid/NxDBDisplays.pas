{
  Next DBGrid
  Copyright (C) 1996-2004 by Berg
  All rights reserved.

  $id:DBDisplays.pas bn
}

unit NxDBDisplays;

interface

uses
  Classes, Types, Controls, Forms,
  NxClasses, NxColumns, NxDisplays;

type
  TNxDBCheckBoxColumnDisplay = class(TCheckBoxColumnDisplay)
  public
    procedure Paint; override;
  end;

  TNxDBGraphicColumnDisplay = class(TGraphicColumnDisplay)
  public
    procedure Paint; override;
  end;

  TNxDBHtmlColumnDisplay = class(THtmlColumnDisplay)
  public
    function GetTextSize: TSize; override;
    procedure Paint; override;
  end;

  TNxDBHtmlColumnPlay = class(TColumnPlay)
  public
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

  TNxDBImageColumnDisplay = class(TImageColumnDisplay)
  public
    function GetContentWidth: Integer; override;
    procedure Paint; override;
  end;

  { TNxDBComboBoxColumn, TNxDBListBoxColumn }

  TNxDBStringsColumnDisplay = class(TCustomStringsColumnDisplay)
  public
    function GetContentWidth: Integer; override;
    function GetTextRect: TRect; override;
    procedure Paint; override;
  end;

  TNxDBProgressColumnDisplay = class(TProgressColumnDisplay)
  public
    procedure Paint; override;
  end;

  TNxDBRateColumnDisplay = class(TRateColumnDisplay)
  public
    function GetContentWidth: Integer; override;
    procedure Paint; override;
  end;

  TNxDBRateColumnPlay = class(TRateColumnPlay)
  protected
    function GetGlyphHeight: Integer; override;
    function GetGlyphWidth: Integer; override;
    function GetMax: Integer; override;
  end;

implementation

uses
  NxDBColumns, SysUtils, DateUtils, Graphics, Dialogs, NxSharedCommon;

{ TNxDBCheckBoxColumnDisplay }

procedure TNxDBCheckBoxColumnDisplay.Paint;
var
  Value: Boolean;
begin
  with Column as TNxDBCheckBoxColumn do
  begin
    if WideSameText(AsString, ValueChecked) then Value := True
    else if WideSameText(AsString, ValueUnchecked) then Value := False
    else Exit;
    DrawCheckBoxState(Self.ClientRect, Value, False, False);
  end;
end;

{ TGraphicColumnDisplay }

procedure TNxDBGraphicColumnDisplay.Paint;
begin
  if Assigned(ObjectReference) then
  begin
    with Column as TNxDBGraphicColumn do
      DrawPicture(TGraphic(Self.ObjectReference), Margin, BorderWidth, Strecht, ActualSize);
    Self.ObjectReference.Free;
  end;
end;

{ THtmlColumnDisplay }

function TNxDBHtmlColumnDisplay.GetTextSize: TSize;
begin
  with Column as TNxDBHtmlColumn do
    Result := ProcessHTML(Canvas, Self.ClientRect, TagBefore + AsString + TagBefore, Point(0, 0), Indent(2, 1), rtMeasure, WrapKind).Size;
end;

procedure TNxDBHtmlColumnDisplay.Paint;
begin
  with Column as TNxDBHtmlColumn do
    ProcessHTML(Canvas, Self.ClientRect, TagBefore + AsString + TagBefore, Point(0, 0), Indent(2, 1), rtDraw, WrapKind);
end;

{ THtmlColumnPlay }

procedure TNxDBHtmlColumnPlay.MouseLeave;
begin
  inherited;
  Screen.Cursor := Column.Cursor;
end;

procedure TNxDBHtmlColumnPlay.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Param: WideString;
begin
  Param := ProcessHTML(Canvas, ClientRect, AsString, Point(X, Y), Indent(2, 1), rtMouse, Column.WrapKind).TagValue;
  if Param <> '' then Screen.Cursor := crHandPoint
    else Screen.Cursor := Column.Cursor;
end;

procedure TNxDBHtmlColumnPlay.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Param: WideString;
begin
  Param := ProcessHTML(Canvas, Self.ClientRect, Self.AsString, Point(X, Y), Indent(2, 1), rtMouse, Column.WrapKind).TagValue;
  with Column as TNxDBHtmlColumn do
    if Param <> '' then if Assigned(OnClick) then OnClick(Self, Param);
end;

{ TImageColumnDisplay }

function TNxDBImageColumnDisplay.GetContentWidth: Integer;
begin
  with Column as TNxDBImageColumn do
  begin
    if Images <> nil then Result := Images.Width
      else Result := 0;
  end;
end;

procedure TNxDBImageColumnDisplay.Paint;
begin
  with Column as TNxDBImageColumn do
  begin
    if (Images <> nil) and (AsInteger >= 0)
      and (AsInteger < Images.Count) then DrawImage(Images, AsInteger);
  end;
end;

{ TNxDBRateColumnDisplay }

function TNxDBRateColumnDisplay.GetContentWidth: Integer;
begin
  with Column as TNxDBRateColumn do
    if not((AsInteger = 0) and HideWhenEmpty) then
      Result := Glyph.Width * Max else Result := 0;
end;

procedure TNxDBRateColumnDisplay.Paint;
begin
  with Column as TNxDBRateColumn do
  begin
    if not((AsInteger = 0) and HideWhenEmpty) then
    begin
      DrawRates(Glyph, EmptyGlyph, Max, AsInteger, Transparent);
    end;
  end;
end;

{ TNxDBProgressColumnDisplay }

procedure TNxDBProgressColumnDisplay.Paint;
var
  Pos: Double;
begin
  with Column as TNxDBProgressColumn do
  begin
    if AsString = '' then Pos := 0
      else Pos := StrToFloat(AsString);
    if not((Pos = 0) and HideWhenEmpty) then
    begin
      DrawProgressBar(ProgressColor, HighValueColor, LowValueColor, BorderColor,
        ProgressStyle, Pos, Max, Margin, ProgressHeight,
        HighValueBound, LowValueBound, ShowText, Transparent, RoundCorners, TextPosition, Precision);
    end;
  end;
end;

{ TNxDBRateColumnPlay }

function TNxDBRateColumnPlay.GetGlyphHeight: Integer;
begin
  with Column as TNxDBRateColumn do Result := Glyph.Height;
end;

function TNxDBRateColumnPlay.GetGlyphWidth: Integer;
begin
  with Column as TNxDBRateColumn do Result := Glyph.Width;
end;

function TNxDBRateColumnPlay.GetMax: Integer;
begin
  with Column as TNxDBRateColumn do Result := Max; 
end;

{ TNxDBStringsColumnDisplay }

function TNxDBStringsColumnDisplay.GetContentWidth: Integer;
begin
  Result := 0;
  with Column as TNxDBStringsColumn do
  begin
    case DisplayMode of
      dmImageOnly: if Images <> nil then Result := Images.Width;
      dmTextAndImage: begin
        Result := inherited GetContentWidth;
        if Images <> nil then Inc(Result, Images.Width + 4);
      end;
      else Result := inherited GetContentWidth;
    end;
  end;
end;

function TNxDBStringsColumnDisplay.GetTextRect: TRect;
begin
  Result := inherited GetTextRect;
  with Column as TNxDBStringsColumn do
  begin
    if Assigned(Images) and (DisplayMode <> dmTextOnly)
      then Inc(Result.Left, 4 + Images.Width);
  end;
end;

procedure TNxDBStringsColumnDisplay.Paint;
var
  Cell: TCellInfo;
begin
  with Column as TNxDBStringsColumn do
  begin
    Cell.AsInteger := AsInteger;
    Cell.AsString := AsString;
    DrawContent(DisplayMode, GetDrawText(Cell), Cell.AsInteger, Images);
  end;
end;

end.
