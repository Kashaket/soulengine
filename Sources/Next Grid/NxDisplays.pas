{
  Next Grid
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:Displays.pas bn
}

{$I '..\NxSuite.inc'}

unit NxDisplays;

interface

uses
  Types, Classes, Windows, Graphics, ImgList, Math, Controls,
  NxClasses, NxColumns, NxColumnClasses, NxThemesSupport, NxSharedCommon, NxCells
  {$IFDEF UITYPES}, UITypes{$ENDIF}
  ;
const
  siSortArrowHeight = 7;
  siSortArrowWidth = 8;
  spArrowDistance = 19;
  spHeaderMargin = 2;
  spTextToImageDist = 2;

type
  TDisplayMedia = (dmPaper, dmScreen);
  TStyleDisplayAttributes = set of (sdaHoverEnabled, sdaInvertFocus, sdaCustomArrow);
  TBoxLocation = (bpAlone, bpBottom, bpTop); 

  TDisplayDrawEvent = procedure (Sender: TObject; Index: Integer; Rect: TRect) of object;

  TStyleDisplay = class(TPersistent)
  private
    FBidiMode: TBiDiMode;
    FCanvas: TCanvas;
    FDefaultDrawing: Boolean;
    FDisplayMedia: TDisplayMedia;
    FEnableThemes: Boolean;
    FTheme: HTHEME;
    FOwner: TComponent;
    FOnDraw: TDisplayDrawEvent;
    FOnHeaderDraw: TDisplayDrawEvent;
    procedure DrawGrid(Rect: TRect; AColor: TColor = clBtnFace);
  protected
    function GetHeaderMargin(Column: TNxCustomColumn): Integer; virtual;
    function GetStyleDisplayAttributes: TStyleDisplayAttributes; virtual;
    procedure AdjustTextRect(var R: TRect); virtual;
    procedure DrawArrow(X, Y: Integer; Ascending: Boolean); virtual;
    procedure DrawFooterContent(Column: TNxCustomColumn; R: TRect); virtual;
    procedure DrawHeaderContent(Column: TNxCustomColumn; R: TRect); virtual;
  public
    constructor Create(AOwner: TComponent); virtual;
    procedure Assign(Source: TPersistent); override;
    function GetHeaderContentWidth(Column: TNxCustomColumn): Integer;
    procedure DoDrawText(Canvas: TCanvas; TextRect: TRect; Caption: WideString;
      MultiLine: Boolean);
    procedure DrawAreaSplitter(R: TRect); virtual;
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); virtual;
    procedure DrawFooter(Column: TNxCustomColumn; R: TRect; Grid: Boolean); virtual;
    procedure DrawHeader(Column: TNxCustomColumn; R: TRect); virtual;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); virtual;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); virtual;
    procedure DrawIndicatorState(R: TRect; Selected, Highlighted: Boolean); virtual;
    procedure DrawInput(Column: TNxCustomColumn; R: TRect;
      Grid, Selected, Focused: Boolean); virtual;
    procedure DrawInactiveHeader(R: TRect); virtual;

    property BiDiMode: TBiDiMode read FBidiMode write FBidiMode;
    property Canvas: TCanvas read FCanvas write FCanvas;
    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing;
    property DisplayMedia: TDisplayMedia read FDisplayMedia write FDisplayMedia;
    property Owner: TComponent read FOwner;
    property StyleDisplayAttributes: TStyleDisplayAttributes read GetStyleDisplayAttributes;
{$IFDEF CUSTOM_STYLES}
    function StyleElements: TStyleElements;
{$ENDIF}
    property Theme: HTHEME read FTheme write FTheme;
    function UseStyles: Boolean;
    property UseThemes: Boolean read FEnableThemes write FEnableThemes;

    property OnDraw: TDisplayDrawEvent read FOnDraw write FOnDraw;
    property OnHeaderDraw: TDisplayDrawEvent read FOnHeaderDraw write FOnHeaderDraw;
  end;

  TDefaultStyleDisplay = class(TStyleDisplay)
  private
    procedure DrawFooterIndicator(R: TRect);
    procedure DrawDefaultFrameBox(Column: TNxCustomColumn; R: TRect); virtual;
    procedure DrawThemedFrameBox(Column: TNxCustomColumn; R: TRect); virtual;
    procedure DrawStyledFrameBox(Column: TNxCustomColumn; R: TRect); virtual;
  protected
    function GetStyleDisplayAttributes: TStyleDisplayAttributes; override;
  public
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); override;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); override;
    procedure DrawInactiveHeader(R: TRect); override;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); override;
  end;

  TFlatStyleDisplay = class(TStyleDisplay)
  private
    procedure DrawDefaultFrameBox(Column: TNxCustomColumn;
      R: TRect); virtual;
  public
    procedure DrawAreaSplitter(R: TRect); override;
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); override;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); override;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); override;
  end;

  TOffice2007StyleDisplay = class(TStyleDisplay)
  private
    procedure DrawFrameBox(Column: TNxCustomColumn;
      R: TRect); virtual;
  protected
    procedure AdjustTextRect(var R: TRect); override;
  public
    procedure DrawAreaSplitter(R: TRect); override;
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); override;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); override;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); override;
  end;

  TOffice2010StyleDisplay = class(TStyleDisplay)
  private
    procedure DrawFrameBox(Column: TNxCustomColumn;
      R: TRect); virtual;
  protected
    procedure AdjustTextRect(var R: TRect); override;
    procedure DrawArrow(X, Y: Integer; Ascending: Boolean); override;
  public
    procedure DrawAreaSplitter(R: TRect); override;
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); override;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); override;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); override;
  end;

  TOldStyleDisplay = class(TStyleDisplay)
  private
    procedure DrawFrameBox(R: TRect);
  protected
    function GetStyleDisplayAttributes: TStyleDisplayAttributes; override;
  public
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); override;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); override;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); override;
  end;

  TOutlookStyleDisplay = class(TStyleDisplay)
  protected
    function GetStyleDisplayAttributes: TStyleDisplayAttributes; override;
    procedure AdjustTextRect(var R: TRect); override;
    procedure DrawFrameBox(Column: TNxCustomColumn; R: TRect); virtual;
  public
    procedure DrawAreaSplitter(R: TRect); override;
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); override;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); override;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); override;
  end;

  TVistaStyleDisplay = class(TStyleDisplay)
  protected
    function GetStyleDisplayAttributes: TStyleDisplayAttributes; override;
    procedure AdjustTextRect(var R: TRect); override;
    procedure DrawArrow(X, Y: Integer; Ascending: Boolean); reintroduce;
    procedure DrawFrameBox(Column: TNxCustomColumn; R: TRect); virtual;
  public
    procedure DrawAreaSplitter(R: TRect); override;
    procedure DrawCornerBox(R: TRect; Location: TBoxLocation = bpAlone); override;
    procedure DrawHeaderBackground(Column: TNxCustomColumn; R: TRect); override;
    procedure DrawIndicator(R: TRect; Index: Integer; Selected, Highlighted: Boolean); override;
  end;

  { Display Classes }
  TCellDisplayOptions = set of (doFocused, doFullRow);

  TTreeColumnDisplay = class(TColumnDisplay)
  private
    function GetButtonRect(ARect: TRect; Level: Integer): TRect;
  protected
    function GetIndent: Integer;
    function GetTextRect: TRect; override;
    procedure DrawImages;
    procedure DrawLines;
  public
    function GetContentWidth: Integer; override;
    procedure Paint; override;
  end;

  TTreeColumnPlay = class(TColumnPlay)
  public
    function GetButtonRect(ARect: TRect; Level: Integer): TRect;
    function IsExpandLock: Boolean;
    procedure KeyPress(var Key: Char); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

  TCheckBoxColumnDisplay = class(TColumnDisplay)
  protected
    procedure DrawCheckBoxState(R: TRect; Checked, Hover, Down: Boolean); virtual;
  public
    function GetContentWidth: Integer; override;
    procedure Paint; override;
  end;

  TDateColumnDisplay = class(TColumnDisplay)
  public
    procedure Paint; override;
  end;

  THtmlColumnDisplay = class(TColumnDisplay)
  public
    function GetTextSize: TSize; override;
    procedure Paint; override;
  end;

  THtmlColumnPlay = class(TColumnPlay)
  public
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

  TImageColumnDisplay = class(TColumnDisplay)
  protected
    procedure DrawImage(Images: TCustomImageList; Index: Integer);
  public
    function GetContentWidth: Integer; override;
    procedure Paint; override;
  end;

  TNumberColumnDisplay = class(TColumnDisplay)
  public
    procedure Paint; override;
  end;

  TProgressColumnDisplay = class(TColumnDisplay)
  protected
    procedure DrawBoxes(R: TRect; Color: TColor);
    procedure DrawProgressBar(ProgressColor, HighValueColor, LowValueColor, BorderColor: TColor;
      Style: TProgressStyle; Pos: Double; Max, Margin, Height, HighBound, LowBound: Integer;
      ShowText, Transparent, RoundCorners: Boolean; TextPosition: TProgressTextPosition;
      Precision: Integer);
  public
    procedure Paint; override;
  end;

  TRateColumnPlay = class(TColumnPlay)
  private
    function GetRatesRect: TRect;
    function GetValueAtPos(X, Y: Integer): Integer; virtual;
  protected
    function GetGlyphHeight: Integer; virtual;
    function GetGlyphWidth: Integer; virtual;
    function GetMax: Integer; virtual;
  public
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Show; override;
  end;

  TRateColumnDisplay = class(TColumnDisplay)
  protected
    procedure DrawRates(Glyph, EmptyGlyph: TBitmap; Max, Value: Integer;
      Transparent: Boolean);
  public
    function GetContentWidth: Integer; override;
    procedure Paint; override;
  end;

  TTextColumnDisplay = class(TColumnDisplay)
  public
    procedure Paint; override;
  end;

  TCheckBoxColumnPlay = class(TColumnPlay)
  private
    function GetCheckBoxRect: TRect;
  protected
    procedure DoChange; override;
  public
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Show; override;
  end;

  TGraphicColumnDisplay = class(TColumnDisplay)
  private
    procedure DrawConstrainedPicture(Graphic: TGraphic; R: TRect);
    procedure DrawActualPicture(Graphic: TGraphic; R: TRect);
  protected
    procedure DrawPicture(Graphic: TGraphic; Margin,
      BorderWidth: Integer; Strecht, ActualSize: Boolean);
  public
    procedure Paint; override;
  end;

  TIncrementColumnDisplay = class(TColumnDisplay)
  public
    procedure Paint; override;
  end;

  TCustomStringsColumnDisplay = class(TTextColumnDisplay)
  protected
    procedure DrawContent(DisplayMode: TDisplayMode; AText: WideString;
      ImageIndex: Integer; Images: TCustomImageList);
  public
    procedure Paint; override;
  end;

  TStringsColumnDisplay = class(TCustomStringsColumnDisplay)
  protected
    function GetTextRect: TRect; override;
  public
    function GetContentWidth: Integer; override;
  end;

  TMemoColumnDisplay = class(TTextColumnDisplay)
  protected
    procedure DrawTextRect(const Value: WideString; ARect: TRect); override;
    function GetTextRect: TRect; override;
  public
    procedure Paint; override;
  end;

  TTimeColumnDisplay = class(TTextColumnDisplay)
  public
    procedure Paint; override;
  end;

  THyperlinkColumnDisplay = class(TColumnDisplay)
  public
    function GetTextSize: TSize; override;
    procedure Paint; override;
  end;

  THyperlinkColumnPlay = class(TColumnPlay)
  protected
    function MouseIsOverHyperlink(X, Y: Integer): Boolean; virtual;
  public
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

  TNxColorColumnDisplay = class(TTextColumnDisplay)
  public
    function GetTextRect: TRect; override;
    procedure Paint; override;
  end;

implementation

uses
{$IFDEF CUSTOM_STYLES}
  Themes,
{$ENDIF}
  ExtCtrls, NxCustomGrid, NxCustomGridControl,
  NxGridCommon, NxSharedDraw, SysUtils, MaskUtils, Dialogs, Forms;

function AlignInRect(Source, Destination: TRect; Alignment: TAlignment;
  VerticalAlignment: TVerticalAlignment): TRect;
var
  X, Y, Width, Height: Integer;
begin
  X := 0;
  Y := 0;
  Width := Source.Right - Source.Left;
  Height := Source.Bottom - Source.Top;
  case Alignment of
    taLeftJustify: X := Destination.Left;
    taRightJustify: X := Destination.Right - Width;
    taCenter: X := CenterPoint(Destination).X - Width div 2;
  end;
  case VerticalAlignment of
    taAlignTop: Y := Destination.Top;
    taAlignBottom: Y := Destination.Bottom - Height;
    taVerticalCenter: Y := CenterPoint(Destination).Y - Height div 2;
  end;
  Result := Rect(X, Y, X + Width, Y + Height);
end;

type
  TPenStyleArray = array[1..2] of DWORD;

const
  ThinDotPenStyle: array[1..2] of DWORD = (0, 2);

procedure DrawDotLine(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
var
  LogBrush: TLogBrush;
begin
  LogBrush.lbStyle := BS_SOLID;
  LogBrush.lbColor := ColorToRGB(Canvas.Pen.Color);
  Canvas.Pen.Handle := ExtCreatePen(PS_COSMETIC or PS_DOT,
    1, LogBrush, 0, nil);
  Canvas.MoveTo(X1, Y1);
  Canvas.LineTo(X2, Y2);
end;

procedure MakeTransparent(ABitmap: TBitmap);
begin
  ABitmap.Transparent := True;
  ABitmap.TransparentColor := ABitmap.Canvas.Pixels[0, ABitmap.Height - 1];
end;

{ TStyleDisplay }

constructor TStyleDisplay.Create(AOwner: TComponent);
begin
  FDefaultDrawing := True;
  FDisplayMedia := dmScreen;
  FOwner := AOwner;
end;

procedure TStyleDisplay.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TStyleDisplay then
  begin

  end
end;

function TStyleDisplay.GetHeaderContentWidth(Column: TNxCustomColumn): Integer;
var
  TextWidth, GlyphWidth: Integer;
begin
  Result := 8;
  with Column.Header do
  begin
    case Orientation of
      hoHorizontal: TextWidth := Canvas.TextWidth(Caption);
      else TextWidth := Canvas.TextHeight(Caption);
    end;
    GlyphWidth := Glyph.Width;
    case DisplayMode of
      dmImageOnly: Result := GlyphWidth;
      dmTextAndImage: Result := TextWidth + spTextToImageDist + GlyphWidth;
      dmTextOnly: Result := TextWidth;
    end;
  end;
end;

procedure TStyleDisplay.DoDrawText(Canvas: TCanvas;
  TextRect: TRect; Caption: WideString; MultiLine: Boolean);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or	DT_VCENTER or DT_END_ELLIPSIS or
    DT_EXTERNALLEADING or DT_LEFT;
  if MultiLine = False then Flags := Flags or DT_SINGLELINE;
  if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True:   DrawTextW(Canvas.Handle, PWideChar(Caption), Length(Caption), TextRect, Flags);
      False:  begin
                StringText := Caption;
                Windows.DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), TextRect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

procedure TStyleDisplay.DrawGrid(Rect: TRect; AColor: TColor);
begin
  with Canvas, Rect do
  begin
    Pen.Color := AColor;
    PolyLine([Point(Left, Bottom - 1), Point(Right - 1, Bottom - 1)]);
    PolyLine([Point(Right - 1, Top), Point(Right - 1, Bottom + 1)]);
  end;
end;

procedure TStyleDisplay.DrawArrow(X, Y: Integer; Ascending: Boolean);
begin
  with Canvas do
   	if UseThemes then
    begin
	    if Ascending then
	    begin
	      Canvas.Brush.Color := clGrayText;
        Pen.Color := clGrayText;
        Polygon([Point(X, Y + 4), Point(X + 4, Y), Point(X + 8, Y + 4)]);
	    end else
	    begin
	      Canvas.Brush.Color := clGrayText;
        Pen.Color := clGrayText;
        Polygon([Point(X, Y), Point(X + 4, Y + 4), Point(X + 8, Y)]);
	    end;
    end else
    begin
	    if Ascending then
	    begin
	      Pen.Color := clBtnShadow;
	      Polyline([Point(X + 7, Y + 6), Point(X + 0, Y + 6), Point(X + 0, Y + 5), Point(X + 1, Y + 5),
	                  Point(X + 1, Y + 3), Point(X + 2, Y + 3), Point(X + 2, Y + 1), Point(X + 3, Y + 1),
	                    Point(X + 3, Y - 1)]);
	      Pen.Color := clBtnHighlight;
	      Polyline([Point(X + 7, Y + 5), Point(X + 6, Y + 5), Point(X + 6, Y + 3), Point(X + 5, Y + 3),
	                  Point(X + 5, Y + 1), Point(X + 4, Y + 1), Point(X + 4, Y - 1)]);
	    end else
	    begin
	      Pen.Color := clBtnShadow;
	      Polyline([Point(X + 7, Y + 0), Point(X + 0, Y + 0), Point(X + 0, Y + 1), Point(X + 1, Y + 1),
	                  Point(X + 1, Y + 3), Point(X + 2, Y + 3), Point(X + 2, Y + 5), Point(X + 3, Y + 5),
	                    Point(X + 3, Y + 7)]);
	      Pen.Color := clBtnHighlight;
	      Polyline([Point(X + 7, Y + 1), Point(X + 6, Y + 1), Point(X + 6, Y + 3), Point(X + 5, Y + 3),
	        Point(X + 5, Y + 5), Point(X + 4, Y + 5), Point(X + 4, Y + 7)]);
	    end;
   	end; { old style }
end;

procedure TStyleDisplay.DrawFooter(Column: TNxCustomColumn; R: TRect; Grid: Boolean);
var
  AClipRect, DrawingRect: TRect;
  Back: Integer;
begin
  if Grid then Back := -1 else Back := 0;

  { Exclude Grid }
  DrawingRect := TCalcProvider.ResizeRect(R, 0, 0, Back, Back);

  if not (Column.Footer.DrawingOptions = doCustomOnly) then
    with Canvas do
    begin
      Font.Assign(Column.Font);
      Brush.Color := Column.Footer.Color;
      FillRect(DrawingRect);
    end;

  if Grid then DrawGrid(R);

  GetClipBox(Canvas.Handle, AClipRect);
  SetClipRect(Canvas, R);

  if (Column.Footer.DrawingOptions = doNormal)
    or (Column.Footer.DrawingOptions = doCustom) then
  begin
    { Draw Content }
    DrawFooterContent(Column, DrawingRect);
  end;

  { Custom Drwing Event }
  FOnDraw(Self, Column.Index, DrawingRect);

  SetClipRect(Canvas, AClipRect);
end;

procedure TStyleDisplay.DrawHeader(Column: TNxCustomColumn; R: TRect);
begin
  if (FDisplayMedia = dmScreen)
    and not(Column.Header.DrawingOptions = doCustomOnly)
      then DrawHeaderBackground(Column, R);

  if (Column.Header.DrawingOptions = doNormal)
    or (Column.Header.DrawingOptions = doCustom) then
  begin
    { Draw Content }
    DrawHeaderContent(Column, R);
  end;

  { Custom Drwing Event }
  if Assigned(FOnHeaderDraw) then FOnHeaderDraw(Self, Column.Index, R);
end;

procedure TStyleDisplay.DrawHeaderBackground(Column: TNxCustomColumn;
  R: TRect);
begin

end;

procedure TStyleDisplay.DrawFooterContent(Column: TNxCustomColumn;
  R: TRect);
var
  CaptionRect: TRect;
  CaptionWidth: Integer;
  ImgPos, TextPos: TPoint;
  FormatedText: WideString;
begin
  with Canvas, Column.Footer do
  begin
    CaptionWidth := 0;

    if FormatMask <> '' then
    begin
      case Column.Footer.FormatMaskKind of
        mkText: FormatedText := FormatMaskText(FormatMask, Caption);
        mkFloat: FormatedText := FormatFloat(FormatMask, StrToFloatDef(Caption, 0));
      end;
    end else FormatedText := Caption;

    FormatedText := Concat(TextBefore, FormatedText, TextAfter);
    if DisplayMode <> dmImageOnly then CaptionWidth := TextWidth(FormatedText);

    TextPos.X := R.Left + spHeaderMargin;
    if not(Glyph.Empty or (DisplayMode = dmTextOnly)) then { show glyph }
    begin
      ImgPos.Y := R.Top + (R.Bottom - R.Top) div 2 - Glyph.Height div 2;
      case Alignment of
        taLeftJustify:
        begin
          ImgPos.X := R.Left + spHeaderMargin + 1;
          TextPos.X := ImgPos.X + Glyph.Width + spTextToImageDist;
        end;
        taRightJustify:
        begin
          ImgPos.X := R.Right - Glyph.Width - CaptionWidth - spHeaderMargin - Column.Padding;
          if Column.Sorted then Dec(ImgPos.X, spArrowDistance + 12);
          TextPos.X := ImgPos.X + Glyph.Width + spTextToImageDist;
        end;
        taCenter:
        begin
          ImgPos.X := R.Left + (R.Right - R.Left) div 2 - (CaptionWidth + Glyph.Width) div 2;
          TextPos.X := ImgPos.X + Glyph.Width + spTextToImageDist;
        end;
      end;
      Glyph.Transparent := True;
      ApplyBitmap(Canvas, ImgPos.X, ImgPos.Y, Glyph);
    end else
    begin
      case Alignment of
        taLeftJustify: TextPos.X := R.Left + spHeaderMargin;
        taRightJustify: TextPos.X := R.Right - CaptionWidth - Column.Padding;
        taCenter: TextPos.X := R.Left + (R.Right - R.Left) div 2 - CaptionWidth div 2;
      end;
    end;
    if DisplayMode <> dmImageOnly then { show text }
    begin
      if TextPos.X < R.Left then TextPos := R.TopLeft;
      CaptionRect := Rect(TextPos.X, R.Top, R.Right, R.Bottom);
      DoDrawText(Canvas, CaptionRect, FormatedText, False);
    end;
  end;
end;

procedure TStyleDisplay.DrawHeaderContent(Column: TNxCustomColumn; R: TRect);
var
  CaptionRect, InvertRect: TRect;
  CaptionWidth: Integer;
  ArrowPos, ImgPos, TextPos: TPoint;
{$IFDEF CUSTOM_STYLES}
  TextColor: TColor;
{$ENDIF}
begin
//  SetClipRect(Canvas, R);
  with Canvas, Column.Header do
  begin
    CaptionWidth := 0;
    case Orientation of
      hoHorizontal: if DisplayMode <> dmImageOnly then
        begin
          if Column.Header.MultiLine
            then CaptionWidth := GetMultilineTextWidth(Canvas, Caption)
            else CaptionWidth := GetTextWidth(Canvas, Caption);
          Inc(CaptionWidth, spTextToImageDist);
        end;
      hoVertical: if DisplayMode <> dmImageOnly then CaptionWidth := GetTextHeight(Canvas, Caption) + spTextToImageDist;
    end;
    TextPos.X := R.Left + spHeaderMargin;
    if not(Glyph.Empty or (DisplayMode = dmTextOnly)) then { show glyph }
    begin
      ImgPos.Y := R.Top + (R.Bottom - R.Top) div 2 - Glyph.Height div 2;
      case Alignment of
        taLeftJustify:
        begin
          ImgPos.X := R.Left + spHeaderMargin + 1;
          TextPos.X := ImgPos.X + Glyph.Width + spTextToImageDist;
        end;
        taRightJustify:
        begin
          ImgPos.X := R.Right - Glyph.Width - CaptionWidth - spHeaderMargin;
          if Column.Sorted then Dec(ImgPos.X, spArrowDistance + 12);
          TextPos.X := ImgPos.X + Glyph.Width + spTextToImageDist;
          if TextPos.X < R.Left then TextPos.X := R.Left;
        end;
        taCenter:
        begin
          ImgPos.X := R.Left + (R.Right - R.Left) div 2 - (CaptionWidth + Glyph.Width) div 2;
          TextPos.X := ImgPos.X + Glyph.Width + spTextToImageDist;
        end;
      end;
      Glyph.Transparent := True;
      if ImgPos.X >= R.Left then
      begin
        ApplyBitmap(Canvas, ImgPos.X, ImgPos.Y, Glyph);
      end;
    end else
    begin
      case Alignment of
        taLeftJustify: TextPos.X := R.Left + spHeaderMargin;
        taRightJustify:
        begin
          TextPos.X := R.Right - CaptionWidth - spHeaderMargin;
          if TextPos.X < R.Left then TextPos.X := R.Left;
          if Column.Sorted then Dec(TextPos.X, spArrowDistance + 12);
        end;
        taCenter: if CaptionWidth<(R.Right - R.Left) then TextPos.X := R.Left + ((R.Right - R.Left - CaptionWidth) shr 1);
      end;
    end;

    { Render Text }
    if DisplayMode <> dmImageOnly then
    begin

{$IFDEF CUSTOM_STYLES}
      if UseStyles
        and (seFont in StyleElements) then
      begin
        with StyleServices do
        begin
          if GetElementColor(GetElementDetails(thHeaderItemNormal), ecTextColor, TextColor)
            and (TextColor <> clNone) then
          begin
            Canvas.Font.Color := TextColor;
          end;
        end;
      end;
{$ENDIF}

      CaptionRect := Rect(TextPos.X, R.Top, R.Right, R.Bottom);
      AdjustTextRect(CaptionRect);
      case Orientation of
        hoHorizontal: DoDrawText(Canvas, CaptionRect, Caption, Column.Header.MultiLine);
        hoVertical: DrawVerticalText(Canvas, CaptionRect, Caption, Column.Header.MultiLine);
      end;
    end;
  end;

  if not DefaultDrawing then Exit;

  if Column.Sorted then
  begin
    ArrowPos.Y := R.Top + (R.Bottom - R.Top) div 2 - siSortArrowHeight div 2 - 1;
    ArrowPos.X := TextPos.X + CaptionWidth + spArrowDistance;
    if ((ArrowPos.X + siSortArrowWidth < R.Right) or not Column.Header.HideArrow) and
      not(sdaCustomArrow in StyleDisplayAttributes) then
        DrawArrow(ArrowPos.X, ArrowPos.Y, Column.SortKind = skAscending);
  end;

  if (Column.Focused) and (sdaInvertFocus in StyleDisplayAttributes) then
  begin
    with R do
    begin
      if not Column.IsAlone then InvertRect := Rect(Left, Top, Right - 1, Bottom)
        else InvertRect := Rect(Left - 1, Top - 1, Right, Bottom);
      Canvas.CopyMode := cmDstInvert;
      Canvas.CopyRect(InvertRect, Canvas, InvertRect);
      Canvas.CopyMode := cmSrcCopy;
    end;
  end;
end;

procedure TStyleDisplay.DrawInput(Column: TNxCustomColumn;
  R: TRect; Grid, Selected, Focused: Boolean);
var
  InputValue: WideString;
  ATextRect: TRect;
  Back: Integer;
begin
  if Grid and Selected then Back := -1 else Back := 0;
  ATextRect := TCalcProvider.ResizeRect(R, 2, 0, -1, -1);
  with Canvas do
  begin
    Font.Assign(Column.Font);
    if Selected and (not Column.Input) then
    begin
      Font.Color := clHighlightText;
      Font.Style := [];
      if Focused then Brush.Color := clHighlight else Brush.Color := clBtnFace;
      if Column.Selected then
			begin
	      Brush.Color := Column.Color;
	      Font.Color := clGrayText;
			end;
    end else
    begin
      Font.Color := clGrayText;
      Font.Style := [];
      Brush.Color := Column.Color;
    end;
    if not Column.Input
    	then FillRect(TCalcProvider.ResizeRect(R, 0, 0, Back, Back))
      	else FrameRect(TCalcProvider.ResizeRect(R, 0, 0, Back, Back));
    if Grid and Selected then DrawGrid(R, clHighlight);
    if Column.InputValue <> '' then
    begin
      InputValue := Column.GetInputDrawText;
      TGraphicsProvider.DrawTextRect(Canvas, ATextRect, Column.Alignment, InputValue, BiDiMode)
    end else
    begin
      TGraphicsProvider.DrawTextRect(Canvas, ATextRect, taCenter, Column.InputCaption, BiDiMode);
    end;
  end;
end;

function TStyleDisplay.GetHeaderMargin(Column: TNxCustomColumn): Integer;
begin
  Result := 0;
  if (DefaultDrawing) and (DisplayMedia = dmScreen) then
  begin
    if (UseThemes) and (Column.Header.DisplayMode = dmTextOnly) then Result := spThemedHeaderMargin else Result := spHeaderMargin;
  end; 
end;

function TStyleDisplay.GetStyleDisplayAttributes: TStyleDisplayAttributes;
begin
  Result := [];
end;

{$IFDEF CUSTOM_STYLES}
function TStyleDisplay.StyleElements: TStyleElements;
begin
  Result := TControl(FOwner).StyleElements;
end;
{$ENDIF}

function TStyleDisplay.UseStyles: Boolean;
begin
  Result := False;
  {$IFDEF CUSTOM_STYLES}
  Result := StyleServices.Enabled;
  {$ENDIF}
end;

procedure TStyleDisplay.AdjustTextRect(var R: TRect);
begin

end;

procedure TStyleDisplay.DrawCornerBox(R: TRect; Location: TBoxLocation);
begin
  with Canvas do
  begin
    Brush.Color := TNxCustomGrid(FOwner).Color;
    FillRect(R);
  end;
end;

procedure TStyleDisplay.DrawInactiveHeader(R: TRect);
begin
  with Canvas do
  begin
    Brush.Color := TNxCustomGrid(FOwner).Color;
    FillRect(R);
  end;      
end;

procedure TStyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
var
	r1: TRect;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    r1 := Rect(1, R.Top + 1, R.Right - 1, R.Bottom);
    FillRect(r1);
    Pen.Color := clBtnHighlight;
    MoveTo(0, R.Top);
    LineTo(0, R.Bottom + 1);
    if Index > 0 then
    begin
      Pixels[1, R.Top] := clBtnFace;
      Pixels[R.Right - 2, R.Top] := clBtnFace;
      MoveTo(2, R.Top);
      LineTo(R.Right - 2, R.Top);
    end else
    begin
      MoveTo(1, R.Top);
      LineTo(R.Right - 1, R.Top);
    end;
    Pen.Color := clBtnShadow;
    Pixels[1, R.Bottom - 1] := clBtnFace;
    Pixels[R.Right - 2, R.Bottom - 1] := clBtnFace;
    MoveTo(R.Right - 1, R.Top);
    LineTo(R.Right - 1, R.Bottom);
    MoveTo(2, R.Bottom - 1);
    LineTo(R.Right - 2, R.Bottom - 1);
  end;
end;

procedure TStyleDisplay.DrawIndicatorState(R: TRect; Selected,
  Highlighted: Boolean);
var
  p: TPoint;
begin
  with Canvas do
  begin
    if Selected then
    begin
      Pen.Color := clWindowText;
      p := TCalcProvider.PosInRect(6, 11, 0, R, taCenter, taVerticalCenter);
      Brush.Color := clWindowText;
      Polygon([Point(p.X, p.Y), Point(p.X + 5, p.Y + 5), Point(p.X, p.Y + 10)]);
    end;
    if Highlighted then
    begin
      CopyMode := cmDstInvert;
      CopyRect(R, Canvas, R);
      CopyMode := cmSrcCopy;
    end;
  end;
end;

procedure TStyleDisplay.DrawAreaSplitter(R: TRect);
begin
  DrawCornerBox(R);
end;

{ TDefaultStyleDisplay }

procedure TDefaultStyleDisplay.DrawCornerBox(R: TRect; Location: TBoxLocation);
begin
  if UseStyles then
  begin
    {$IFDEF CUSTOM_STYLES}
    StyleServices.DrawElement(Canvas.Handle, StyleServices.GetElementDetails(thHeaderItemLeftNormal), R);
    {$ENDIF}
  end
  else
    if UseThemes then
      case Location of
        bpAlone: DrawThemeBackground(FTheme, Canvas.Handle, tcHeader, 1, R, nil);
        bpBottom: DrawFooterIndicator(R);
      end
    else
      case Location of
        bpAlone: TGraphicsProvider.DrawButton(Canvas, R, False);
        bpBottom: DrawFooterIndicator(R);
      end;
end;

procedure TDefaultStyleDisplay.DrawDefaultFrameBox(Column: TNxCustomColumn;
  R: TRect);
var
  InRect: TRect;
begin
  InRect := R;
  InflateRect(InRect, -1, -1);
  with Canvas, R do
  begin
    Brush.Color := Column.Header.Color;
    FillRect(InRect);
    if Column.Location = clAlone then Frame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1) else
    begin
      Pen.Color := clBtnHighlight; { Highlight }
      Polyline([Point(Left, Top), Point(Right, Top)]);
      if Column.Location = clLeftSide then Polyline([Point(Left, Top + 1), Point(Left, Bottom - 1)]) else
      begin
        Polyline([Point(Left, Top + 2), Point(Left, Bottom - 2)]);
        Pixels[Left, Top + 1] := Column.Header.Color;
        Pixels[Left, Bottom - 2] := Column.Header.Color;
      end;
      Pen.Color := clBtnShadow; { Shadow }
      Polyline([Point(Left, Bottom - 1), Point(Right, Bottom - 1)]);
      if Column.Location = clRightSide then Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1)]) else
      begin
        Polyline([Point(Right - 1, Top + 2), Point(Right - 1, Bottom - 2)]);
        Pixels[Right - 1, Top + 1] := Column.Header.Color;
        Pixels[Right - 1, Bottom - 2] := Column.Header.Color;
      end;
    end;
  end;
end;

procedure TDefaultStyleDisplay.DrawFooterIndicator(R: TRect);
var
  r1: TRect;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    r1 := Rect(1, R.Top + 1, R.Right - 1, R.Bottom);
    FillRect(r1);

    Pen.Color := clBtnHighlight;
    MoveTo(0, R.Top);
    LineTo(0, R.Bottom);

    Pixels[1, R.Top + 1] := clBtnFace;
    Pixels[R.Right - 2, R.Top + 1] := clBtnFace;

    { light grip }
    MoveTo(2, R.Top + 1);
    LineTo(R.Right - 2, R.Top + 1);

    Pen.Color := clBtnShadow;
    Pixels[1, R.Top] := clBtnFace;
    Pixels[R.Right - 2, R.Top] := clBtnFace;

    { right line }
    MoveTo(R.Right - 1, R.Top);
    LineTo(R.Right - 1, R.Bottom - 1);
    LineTo(R.Left - 1, R.Bottom - 1);
    { dark grip }
    MoveTo(2, R.Top);
    LineTo(R.Right - 2, R.Top);
  end;
end;

procedure TDefaultStyleDisplay.DrawHeaderBackground(Column: TNxCustomColumn; R: TRect);
begin
  if UseStyles then DrawStyledFrameBox(Column, R)
    else if UseThemes then DrawThemedFrameBox(Column, R)
      else DrawDefaultFrameBox(Column, R);
  inherited;
end;

procedure TDefaultStyleDisplay.DrawInactiveHeader(R: TRect);
begin
  if UseStyles then
  begin
    {$IFDEF CUSTOM_STYLES}
    StyleServices.DrawElement(Canvas.Handle, StyleServices.GetElementDetails(thHeaderItemRightNormal), R);
    {$ENDIF}
  end
  else
    case UseThemes of
      True: DrawThemeBackground(FTheme, Canvas.Handle, 2, 1, R, nil);
      False: inherited;
    end;
end;

procedure TDefaultStyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
begin
  if UseStyles then
  begin
    {$IFDEF CUSTOM_STYLES}
    StyleServices.DrawElement(Canvas.Handle, StyleServices.GetElementDetails(thHeaderItemLeftNormal), R);
    {$ENDIF}
  end
  else inherited;
end;

procedure TDefaultStyleDisplay.DrawStyledFrameBox(Column: TNxCustomColumn;
  R: TRect);
{$IFDEF CUSTOM_STYLES}
var
  Detail: TThemedHeader;
begin
  Detail := thHeaderItemNormal;
  if Column.Hover then Detail := thHeaderItemHot;
  if Column.Focused then Detail := thHeaderItemPressed;
  StyleServices.DrawElement(Canvas.Handle, StyleServices.GetElementDetails(Detail), R);
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TDefaultStyleDisplay.DrawThemedFrameBox(Column: TNxCustomColumn;
  R: TRect);
var
  Item: Integer;
begin
  if Column.Hover then Item := tiHeaderHover else Item := tiHeaderNormal;
  if Column.Focused then Item := 3;
  DrawThemeBackground(FTheme, Canvas.Handle, tcHeader, Item, R, nil);
end;

function TDefaultStyleDisplay.GetStyleDisplayAttributes: TStyleDisplayAttributes;
begin
  if UseThemes then Result := [sdaHoverEnabled] else Result := [sdaInvertFocus];
end;

{ TFlatStyleDisplay }

procedure TFlatStyleDisplay.DrawAreaSplitter(R: TRect);
begin
  with Canvas, R do
  begin
    Brush.Color := clBtnFace;
    FillRect(R);
  end;
end;

procedure TFlatStyleDisplay.DrawCornerBox(R: TRect; Location: TBoxLocation);
begin
  with Canvas, R do
  begin
    Brush.Color := clBtnFace;
    FillRect(R);
    Pen.Color := clGrayText;
    MoveTo(Right - 1, Top);
    LineTo(Right - 1, Bottom - 1);
    LineTo(Left - 1, Bottom - 1);
  end;
end;

procedure TFlatStyleDisplay.DrawDefaultFrameBox(Column: TNxCustomColumn; R: TRect);
begin
  with Canvas, R do
  begin
    Brush.Color := Column.Header.Color;
    FillRect(R);
    Pen.Color := clGrayText;
    MoveTo(Right - 1, Top);
    LineTo(Right - 1, Bottom - 1);
    LineTo(Left - 1, Bottom - 1);
  end;
end;

procedure TFlatStyleDisplay.DrawHeaderBackground(Column: TNxCustomColumn; R: TRect);
begin
  DrawDefaultFrameBox(Column, R);
  inherited;
end;

procedure TFlatStyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
begin
  with Canvas, R do
  begin
    Brush.Color := clBtnFace;
    FillRect(R);
    Pen.Color := clGrayText;
    MoveTo(Right - 1, Top);
    LineTo(Right - 1, Bottom - 1);
    LineTo(Left - 1, Bottom - 1);
  end;
end;

function GetSmaller(Value1, Value2: Integer): Integer;
begin
  if Value2 < Value1 then Result := Value2 else Result := Value1;
end;

{ TTreeColumnDisplay }

function TTreeColumnDisplay.GetButtonRect(ARect: TRect; Level: Integer): TRect;
var
  m, t: Integer;
begin
  m := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  t := m - 5;
  with Result do
  begin
    Left := Level * 19 + Column.Padding;
    Left := ARect.Left + Level * 19;
    Right := Left + 9;
    Top := ARect.Top;
    Bottom := Top + 9;
  end;
  OffsetRect(Result, 2, t - Result.Top);
end;

function TTreeColumnDisplay.GetIndent: Integer;
begin
  Result := Level * 19;
end;

function TTreeColumnDisplay.GetTextRect: TRect;
begin
  Result := inherited GetTextRect;
  Inc(Result.Left, GetIndent + 16);
  with Column as TNxTreeColumn do
  begin
    if Images <> nil then Inc(Result.Left, Images.Width);
  end;
end;

procedure TTreeColumnDisplay.DrawImages;
var
  ImageLeft, ImageTop: Integer;
begin
  ImageLeft := ClientRect.Left + GetIndent + 16;
  with Column as TNxTreeColumn do
  begin
    if Assigned(Images) and (ImageIndex >= 0) then
    begin
      ImageTop := Self.ClientRect.Top + (Self.ClientRect.Bottom - Self.ClientRect.Top) div 2;
      ImageTop := ImageTop - Images.Height div 2;
      Images.Draw(Canvas, ImageLeft, ImageTop, ImageIndex);
    end;
  end;
end;

procedure TTreeColumnDisplay.DrawLines;
var
  i, m, n, X, ARow, NextSibling: Integer;
begin
  m := Round(ClientRect.Top + (ClientRect.Bottom - ClientRect.Top) / 2);
  with Canvas do
  begin
    Pen.Color := clGrayText;
    ARow := RowIndex;

    { Vertical lines }
    if IsLast then
    begin
      X := ClientRect.Left + (Level * 19) + 6;
      if ChildCount > 0 then
      begin
        if not IsFirst then Polyline([Point(X, ClientRect.Top), Point(X, m - 4)])
      end else
      begin
        if not IsFirst then Polyline([Point(X, ClientRect.Top), Point(X, m)])
      end;
    end;

    for i := Level downto 0 do
    begin
      X := ClientRect.Left + (i * 19) + 6;
      OnParentRow(ARow, NextSibling);

      if NextSibling <> -1 then
      begin
        if (i = Level) and (ChildCount > 0) then
        begin
          if not IsFirst then Polyline([Point(X, ClientRect.Top), Point(X, m - 4)]);
          if not IsLast then Polyline([Point(X, m + 4), Point(X, ClientRect.Bottom)]);
        end else
        begin
          if not IsFirst then Polyline([Point(X, ClientRect.Top), Point(X, ClientRect.Bottom)])
            else Polyline([Point(X, m), Point(X, ClipRect.Bottom)]);
        end;
      end;
    end;

    { Horizontal lines - }
    X := ClientRect.Left + (Level * 19) + 6;;
    n := X;
    if ChildCount > 0 then Inc(n, 4);
    Polyline([Point(n, m - 1), Point(X + 9, m - 1)]);
  end;
end;

procedure TTreeColumnDisplay.Paint;
var
  ButtonRect: TRect;
  Item: Integer;
begin
  if (Column as TNxTreeColumn).ShowLines then DrawLines;
  if Assigned(TNxTreeColumn(Column).Images) then DrawImages;
  if ChildCount > 0 then
  begin
    ButtonRect := GetButtonRect(ClientRect, Level);
    with Canvas do
    begin
      if (Column as TNxTreeColumn).ShowLines then
      begin
        Pen.Color := clGrayText;
      end;
      if (Column as TNxTreeColumn).ShowButtons then
      begin
        if IsThemed then
        begin
          if Expanded then Item := tiExpanded else Item := tiCollapsed;
          ThemeRect(Self.Handle, Canvas.Handle, ButtonRect, NxThemesSupport.teTreeView, tcExpandingButton, Item);
        end else
        begin
          if Self.Selected and (Column as TNxTreeColumn).HighlightButton then
          begin
            Brush.Color := clHighlightText;
            Pen.Color := clHighlightText;
          end else
          begin
            Brush.Color := clGrayText;
            Pen.Color := clBlack;
          end;
          FrameRect(ButtonRect);
          MoveTo(ButtonRect.Left + 2, ButtonRect.Top + 4);
          LineTo(ButtonRect.Right - 2, ButtonRect.Top + 4);
          if Expanded = False then
          begin
            MoveTo(ButtonRect.Left + 4, ButtonRect.Top + 2);
            LineTo(ButtonRect.Left + 4, ButtonRect.Bottom - 2);
          end;
        end;
      end;
    end;
  end;
  DrawTextRect(AsString, GetTextRect);
end;

function TTreeColumnDisplay.GetContentWidth: Integer;
begin
  Result := inherited GetContentWidth + GetIndent + 16;
end;

{ TTreeColumnPlay }

function TTreeColumnPlay.GetButtonRect(ARect: TRect; Level: Integer): TRect;
var
  m, t: Integer;
begin
  m := (ARect.Bottom - ARect.Top) div 2;
  t := m - 5;
  with Result do
  begin
    // Left := Level * 19;
    Left := Level * 19 + Column.Padding;
    Right := Left + 9;
    Top := 0;
    Bottom := Top + 9;
  end;
  OffsetRect(Result, 2, t - Result.Top);
end;

function TTreeColumnPlay.IsExpandLock: Boolean;
begin
  Result := TNxTreeColumn(Column).ExpandLock;
end;

procedure TTreeColumnPlay.KeyPress(var Key: Char);
begin
  inherited;
  if not IsExpandLock and (Key in ['-', '+'])
    then DoExpand;
end;

procedure TTreeColumnPlay.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if not IsExpandLock
    and PtInRect(GetButtonRect(ClientRect, Level), Point(X, Y))
    then DoExpand;
end;

{ TCheckBoxColumnDisplay }

const
  szCheckBox = 11;
  szCheckBoxThemed = 13;

  CheckBoxSize: array[Boolean] of Integer = (szCheckBox, szCheckBoxThemed);

procedure TCheckBoxColumnDisplay.DrawCheckBoxState(R: TRect; Checked, Hover, Down: Boolean);
var
  p: TPoint;
  Theme: THandle;
  Index: Integer;
  ARect: TRect;
{$IFDEF CUSTOM_STYLES}
  Detail: TThemedButton;
{$ENDIF}
begin
  if IsStyled then
  begin
    {$IFDEF CUSTOM_STYLES}
	  p := TCalcProvider.PosInRect(16, 16, 2, R,
      Column.Alignment, Column.VerticalAlignment);

	  ARect := Bounds(p.X, p.Y, 16, 16);

    Detail := tbCheckBoxUncheckedNormal;
    if Checked then Detail := tbCheckBoxCheckedNormal;
    StyleServices.DrawElement(Canvas.Handle, StyleServices.GetElementDetails(Detail), ARect);
    {$ENDIF}
  end
	else if IsThemed then
  begin
	  p := TCalcProvider.PosInRect(szCheckBoxThemed, szCheckBoxThemed, 2, R,
      Column.Alignment, Column.VerticalAlignment);
	  ARect := Rect(p.X, p.Y, p.X + szCheckBoxThemed, p.Y + szCheckBoxThemed);
    Index := 1;
    if Hover then
		begin
    	if Checked then
			begin
	      if Down then Index := 7 else Index := 6;
			end else
      begin
	      if Down then Index := 3 else Index := 2;
      end;
		end else if Checked then Index := 5;
	  Theme := OpenThemeData(Handle, 'Button');
	  DrawThemeBackground(Theme, Canvas.Handle, 3, Index, ARect, nil);
	  CloseThemeData(Theme);
  end else
  begin
	  p := TCalcProvider.PosInRect(szCheckBox, szCheckBox, 2, R, Column.Alignment, Column.VerticalAlignment);
	  ARect := Rect(p.X, p.Y, p.X + szCheckBox, p.Y + szCheckBox);
    with Canvas, R, p do
    begin
      if Down then Brush.Color := clBtnFace else Brush.Color := clWindow;
      Pen.Color := clBtnShadow;
      Rectangle(ARect);
      Pen.Color := clWindowText;
      if Checked = true then
      begin
        Polyline([Point(X + 2, Y + 4), Point(X + 4, Y + 6), Point(X + 9, Y + 1)]);
        Polyline([Point(X + 2, Y + 5), Point(X + 4, Y + 7), Point(X + 9, Y + 2)]);
        Polyline([Point(X + 2, Y + 6), Point(X + 4, Y + 8), Point(X + 9, Y + 3)]);
      end;
    end;
  end;
end;

function TCheckBoxColumnDisplay.GetContentWidth: Integer;
begin
  Result := CheckBoxSize[IsThemed];
end;

procedure TCheckBoxColumnDisplay.Paint;
begin
  DrawCheckBoxState(ClientRect, AsBoolean, False, False);
end;

{ TDateColumnDisplay }

procedure TDateColumnDisplay.Paint;
var
  Cell: TCellInfo;
begin
  Cell.AsDateTime := AsDateTime;
  Cell.AsString := AsString;
  DrawTextRect(Column.GetDrawText(Cell), GetTextRect);
end;

{ THtmlColumnDisplay }

function THtmlColumnDisplay.GetTextSize: TSize;
begin
  with Column as TNxHtmlColumn do
    Result := ProcessHTML(Canvas, Self.ClientRect, TagBefore + AsString + TagBefore, Point(0, 0), Indent(2, 1), rtMeasure, WrapKind).Size;
end;

procedure THtmlColumnDisplay.Paint;
begin
  with Column as TNxHtmlColumn do
    ProcessHTML(Canvas, Self.ClientRect, TagBefore + AsString + TagBefore, Point(0, 0), Indent(2, 1), rtDraw, WrapKind);
end;

{ THtmlColumnPlay }

procedure THtmlColumnPlay.MouseLeave;
begin
  inherited;
  Screen.Cursor := Column.Cursor;
end;

procedure THtmlColumnPlay.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  TagValue: WideString;
begin
  inherited;
  TagValue := ProcessHTML(Canvas, Self.ClientRect, Self.AsString, Point(X, Y), Indent(2, 1), rtMouse, Column.WrapKind).TagValue;
  if TagValue <> '' then Screen.Cursor := crHandPoint else Screen.Cursor := Column.Cursor;
end;

procedure THtmlColumnPlay.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  TagValue: WideString;
begin
  inherited;
  with Column as TNxHtmlColumn do
  begin
    TagValue := ProcessHTML(Canvas, Self.ClientRect, Self.AsString, Point(X, Y), Indent(2, 1), rtMouse, WrapKind).TagValue;
    if TagValue <> '' then if Assigned(OnClick) then OnClick(Self, TagValue);
  end;
end;

{ TImageColumnDisplay }

procedure TImageColumnDisplay.DrawImage(Images: TCustomImageList; Index: Integer);
var
  ImgPosPoint: TPoint;
begin
  ImgPosPoint := TCalcProvider.PosInRect(Images.Width, Images.Height, 2,
    Self.ClientRect, Column.Alignment, Column.VerticalAlignment);
  Images.Draw(Canvas, ImgPosPoint.X, ImgPosPoint.Y, Index); { draw flat }
end;

function TImageColumnDisplay.GetContentWidth: Integer;
begin
  with Column as TNxImageColumn do
  begin
    if Images <> nil then Result := Images.Width
      else Result := 0;
  end;
end;

procedure TImageColumnDisplay.Paint;
begin
  with Column as TNxImageColumn do
  begin
    if (Images <> nil) and (AsInteger >= 0)
      and (AsInteger < Images.Count) then DrawImage(Images, AsInteger);
  end;
end;

{ TNumberColumnDisplay }

procedure TNumberColumnDisplay.Paint;
var
  Cell: TCellInfo;
begin
  Cell.AsFloat := AsFloat;
  Cell.AsString := AsString;
  DrawTextRect(Column.GetDrawText(Cell), GetTextRect);
end;

{ TProgressColumnDisplay }

procedure TProgressColumnDisplay.DrawBoxes(R: TRect; Color: TColor);
var
  Pos, S: Integer;
begin
  Pos := R.Left;
  S := Round((R.Bottom - R.Top) / 1.5);
  while Pos + S < R.Right do
  begin                               
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(Rect(Pos, R.Top, Pos + S, R.Bottom));
    end;
    Inc(Pos, S + 2);
  end;
end;

procedure TProgressColumnDisplay.DrawProgressBar(ProgressColor, HighValueColor,
  LowValueColor, BorderColor: TColor; Style: TProgressStyle;
  Pos: Double; Max, Margin, Height, HighBound, LowBound: Integer;
  ShowText, Transparent, RoundCorners: Boolean; TextPosition: TProgressTextPosition;
  Precision: Integer);
const
  spaTextToBar = 30;
var
  Ratio: Double;
  BorderRect, BoxRect, ProgressRect: TRect;
  Distance: Integer;
  FillColor: TColor;
begin
  with Canvas, Column do
  begin
    Ratio := TCalcProvider.GetRatio(Pos, Max);
    BorderRect := Self.ClientRect;
    InflateRect(BorderRect, -Margin, -Margin); { margin }

    if Height > 0 then
    begin
      case VerticalAlignment of
        taAlignTop: BorderRect.Top := BorderRect.Top;
        taVerticalCenter: BorderRect.Top := BorderRect.Top + (BorderRect.Bottom - BorderRect.Top) div 2 - Height div 2;
        taAlignBottom: BorderRect.Top := BorderRect.Bottom - Height;
      end;
      BorderRect.Bottom := BorderRect.Top + Height;
    end;

    if ShowText and (TextPosition = tpBeside) then
    begin
      BorderRect.Left := BorderRect.Left + spaTextToBar;
    end;

    Brush.Color := BorderColor;
    if Transparent then FrameRect(BorderRect) else
    begin
      Brush.Color := Color;
      Pen.Color := BorderColor;
      if RoundCorners
        then RoundRect(BorderRect.Left, BorderRect.Top, BorderRect.Right, BorderRect.Bottom, 4, 4)
          else Rectangle(BorderRect);
    end;

    BoxRect := BorderRect;
    InflateRect(BoxRect, -2, -2);

    Distance := Round((BoxRect.Right - BoxRect.Left) * (Ratio / 100));
    with ProgressRect do
    begin
      Left := BoxRect.Left;
      Right := BoxRect.Left + Distance;
      if Right >= BorderRect.Right - 2 then Right := BorderRect.Right - 2;
      Top := BoxRect.Top;
      Bottom := BoxRect.Bottom;
    end;

    FillColor := ProgressColor;

    if not ((HighBound = 0) and (LowBound = 0)) then
    begin
      if Pos >= HighBound then FillColor := HighValueColor
      else if Pos <= LowBound then FillColor := LowValueColor
    end;

    Brush.Color := FillColor; { fill }
    case Style of
      psSolid: FillRect(ProgressRect);
      psBoxes: DrawBoxes(ProgressRect, FillColor);
      psGradient: TGraphicsProvider.DrawVertGradient(Canvas, ProgressRect, Color, FillColor);
      psCylinder: TGraphicsProvider.DrawGradient(Canvas, ProgressRect, Color, FillColor);
    end;

    if ShowText then
      case TextPosition of
        tpBeside: DrawTextRect(FloatToStrF(Ratio, ffFixed, 18, Precision) + '%', GetTextRect);
        tpInside:
        begin
          Canvas.Font.Color := Column.Font.Color;
          DrawTextRect(FloatToStrF(Ratio, ffFixed, 18, Precision) + '%', GetTextRect);
        end;
      end;
  end;
end;

procedure TProgressColumnDisplay.Paint;
begin
  with Column as TNxProgressColumn do
  begin
    if not((AsFloat = EmptyValue) and HideWhenEmpty) then
    begin
      DrawProgressBar(ProgressColor, HighValueColor, LowValueColor, BorderColor,
        ProgressStyle, AsFloat, Max, Margin, ProgressHeight,
        HighValueBound, LowValueBound, ShowText, Transparent, RoundCorners, TextPosition, Precision);
    end;
  end;
end;

{ TRateColumnDisplay }

procedure TRateColumnDisplay.DrawRates(Glyph, EmptyGlyph: TBitmap; Max,
  Value: Integer; Transparent: Boolean);
var
  i, X, Y: Integer;
  P: TPoint;
begin
  with Canvas, Column do
  begin
    P := TCalcProvider.PosInRect(Glyph.Width * Max, Glyph.Height, 0, Self.ClientRect, Alignment, VerticalAlignment);
    X := P.X;
    Y := P.Y;
    for i := 1 to Max do
    begin
      if i <= Value then                         
			begin
				if Transparent then MakeTransparent(Glyph);
        ApplyBitmap(Canvas, X, Y, Glyph);
			end else
      begin
  			if Transparent then MakeTransparent(EmptyGlyph);
        ApplyBitmap(Canvas, X, Y, EmptyGlyph);
      end;
      Inc(X, Glyph.Width);
    end;
  end;
end;

function TRateColumnDisplay.GetContentWidth: Integer;
begin
  with Column as TNxRateColumn do
    if not((AsInteger = 0) and HideWhenEmpty) then
      Result := Glyph.Width * Max else Result := 0;
end;

procedure TRateColumnDisplay.Paint;
begin
  with Column as TNxRateColumn do
    if not((AsInteger = 0) and HideWhenEmpty) then
    begin
      DrawRates(Glyph, EmptyGlyph, Max, AsInteger, Transparent);
    end;
end;

{ TTextColumnDisplay }

procedure TTextColumnDisplay.Paint;
var
  Cell: TCellInfo;
begin
  Cell.AsString := AsString;
  DrawTextRect(Column.GetDrawText(Cell), GetTextRect);
end;

{ TCheckBoxColumnPlay }

procedure TCheckBoxColumnPlay.DoChange;
begin
  inherited;
  if Column is TNxCheckBoxColumn then
    (Column as TNxCheckBoxColumn).DoChange; {event}
end;

function TCheckBoxColumnPlay.GetCheckBoxRect: TRect;
var
	CellRect: TRect;
  APoint: TPoint;
  CheckWidth: Integer;
begin
  CellRect := ClientRect;
  OffsetRect(CellRect, -CellRect.Left, -CellRect.Top);
	InflateRect(CellRect, 1, 1);
  if IsStyled then CheckWidth := 16
  else if IsThemed then CheckWidth := 13
  else CheckWidth := 11;
  APoint := TCalcProvider.PosInRect(CheckWidth, CheckWidth, 2, CellRect, Column.Alignment, Column.VerticalAlignment);
  Result := Rect(APoint.X, APoint.Y, APoint.X + CheckWidth, APoint.Y + CheckWidth);
end;

procedure TCheckBoxColumnPlay.KeyPress(var Key: Char);
begin
  if Key = ' ' then { space }
  begin
    AsBoolean := not AsBoolean;
    AsString := BoolToStr(AsBoolean, True);
    DoChange;
  end;
end;

procedure TCheckBoxColumnPlay.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TCheckBoxColumnPlay.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (coCanClick in Column.Options) and PtInRect(GetCheckBoxRect, Point(X, Y)) then
  begin
    AsBoolean := not AsBoolean;
    AsString := BoolToStr(AsBoolean, True);
    DoChange;
  end;
end;

procedure TCheckBoxColumnPlay.Show;
begin
  inherited;
  AsBoolean := True;
  Column.Display.Paint;
end;

{ TGraphicColumnDisplay }

procedure TGraphicColumnDisplay.DrawActualPicture(Graphic: TGraphic; R: TRect);
var
  PictureRect: TRect;

  function CenterRect(const TargetRect: TRect): TRect;
  var
    Width, Height: Integer;
    X, Y: Integer;
  begin
    Width := TargetRect.Right - TargetRect.Left;
    Height := TargetRect.Bottom - TargetRect.Top;
    X := (R.Right + R.Left) div 2;
    Y := (R.Top + R.Bottom) div 2;
    Result := Rect(X - Width div 2, Y - Height div 2, X + (Width + 1) div 2, Y + (Height + 1) div 2);
  end;

begin
  if Assigned(Graphic) then
  begin
    PictureRect := CenterRect(Bounds(0, 0, Graphic.Width, Graphic.Height));
    Canvas.StretchDraw(PictureRect, Graphic);
  end;
end;

procedure TGraphicColumnDisplay.DrawConstrainedPicture(
  Graphic: TGraphic; R: TRect);
var
  ScaleHor, ScaleVer, Scale: Double;
  NewWidth, NewHeight, ATop, ALeft: Integer;
  PaintRect: TRect;
begin
  if not Assigned(Graphic) then exit;

  ScaleHor := (R.Right - R.Left) / Graphic.Width;
  ScaleVer := (R.Bottom - R.Top) / Graphic.Height;
  Scale := Min(ScaleHor, ScaleVer);
  NewWidth  := Round(Graphic.Width * Scale);
  NewHeight := Round(Graphic.Height * Scale);

  if ScaleHor < ScaleVer then
  begin
    NewWidth := R.Right - R.Left;
    ATop := R.Top + ((R.Bottom - R.Top) div 2 - (NewHeight div 2));
    PaintRect := Rect(R.Left, ATop, R.Left + NewWidth, ATop + NewHeight);
  end else
  begin
    NewHeight := R.Bottom - R.Top;
    ALeft := R.Left + ((R.Right - R.Left) div 2 - (NewWidth div 2));
    PaintRect := Rect(ALeft, R.Top, ALeft + NewWidth, R.Top + NewHeight);
  end;
  Canvas.StretchDraw(PaintRect, Graphic);
end;

procedure TGraphicColumnDisplay.DrawPicture(Graphic: TGraphic; Margin,
  BorderWidth: Integer; Strecht, ActualSize: Boolean);
var
  Rect: TRect;
  i: Integer;
begin
  Rect := ClientRect;
  InflateRect(Rect, -Margin, -Margin);
  if BorderWidth > 0 then
  begin
    if not Highlighted then Canvas.Brush.Color := clBtnFace else Canvas.Brush.Color := clHighlightText;
    for i := 1 to BorderWidth do
    begin
      Canvas.FrameRect(Rect);
      InflateRect(Rect, -1, -1);
    end;
  end;
  if Assigned(ObjectReference) and (not TGraphic(ObjectReference).Empty) then
    case Strecht of
      True: Canvas.StretchDraw(Rect, Graphic);
      False:
        if ActualSize
          then DrawActualPicture(Graphic, Rect)
          else DrawConstrainedPicture(Graphic, Rect);
    end;
end;

procedure TGraphicColumnDisplay.Paint;
begin
  with Column as TNxGraphicColumn do DrawPicture(TGraphic(Self.ObjectReference), Margin, BorderWidth, Stretch, ActualSize);
end;

{ TIncrementColumnDisplay }

procedure TIncrementColumnDisplay.Paint;
var
  Cell: TCellInfo;
begin
  Cell.AsInteger := AsInteger;
  DrawTextRect(Column.GetDrawText(Cell), GetTextRect);
end;

{ TOldStyleDisplay }

procedure TOldStyleDisplay.DrawCornerBox(R: TRect; Location: TBoxLocation);
begin
  DrawFrameBox(R);
end;

procedure TOldStyleDisplay.DrawFrameBox(R: TRect);
var
  InRect: TRect;
begin
	InRect := R;
  InflateRect(InRect, -1, -1);
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(InRect);
    Frame3D(Canvas, R, clBtnHighlight, clWindowFrame, 1);
  end;
end;

procedure TOldStyleDisplay.DrawHeaderBackground(Column: TNxCustomColumn; R: TRect);
begin
  DrawFrameBox(R);
  inherited;
end;

procedure TOldStyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
var
  InRect: TRect;
begin
	InRect := R;
  InflateRect(InRect, -1, -1);
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(InRect);
    Frame3D(Canvas, R, clBtnHighlight, clWindowFrame, 1);
  end;
end;

function TOldStyleDisplay.GetStyleDisplayAttributes: TStyleDisplayAttributes;
begin
  Result := [sdaInvertFocus];
end;

{ TOutlookStyleDisplay }

procedure TOutlookStyleDisplay.DrawAreaSplitter(R: TRect);
begin
  TGraphicsProvider.DrawButton(Canvas, R, False);
end;

procedure TOutlookStyleDisplay.DrawCornerBox(R: TRect; Location: TBoxLocation);
var
  InRect: TRect;
begin
  InRect := R;
  InRect.Bottom := InRect.Bottom - 3;
  with Canvas, R do
  begin
    Brush.Color := clBtnFace;
    FillRect(InRect);
    Pen.Color := clBtnShadow; { Shadow }
    Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1)]);
    { bottom gradient }
    Pen.Color := BlendColor(clBtnShadow, clBtnFace, 50);
    Polyline([Point(Left, Bottom - 3), Point(Right, Bottom - 3)]);
    Pen.Color := BlendColor(clBtnShadow, clBtnFace, 100);
    Polyline([Point(Left, Bottom - 2), Point(Right, Bottom - 2)]);
    Pen.Color := BlendColor(clBtnShadow, clBtnFace, 150);
    Polyline([Point(Left, Bottom - 1), Point(Right, Bottom - 1)]);
  end;
end;

function TOutlookStyleDisplay.GetStyleDisplayAttributes: TStyleDisplayAttributes;
begin
  Result := [sdaInvertFocus];
end;

procedure TOutlookStyleDisplay.AdjustTextRect(var R: TRect);
begin
  R.Bottom := R.Bottom - 3;
end;

procedure TOutlookStyleDisplay.DrawFrameBox(Column: TNxCustomColumn;
  R: TRect);
var
  InRect: TRect;
begin
  InRect := R;
  InRect.Bottom := InRect.Bottom - 3;
  with Canvas, R do
  begin
    Brush.Color := Column.Header.Color;
    FillRect(InRect);

    Pen.Color := clBtnHighlight; { Highlight }
    if (Column.Location = clLeftSide) or (Column.Location = clAlone)
      then Polyline([Point(Left, Top), Point(Left, Bottom - 3)]) else
    begin
      Polyline([Point(Left, Top + 2), Point(Left, Bottom - 4)]);
    end;
    Pen.Color := clBtnShadow; { Shadow }
    if (Column.Location = clRightSide) or (Column.Location = clAlone)
      then Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1)]) else
    begin
      Polyline([Point(Right - 1, Top + 2), Point(Right - 1, Bottom - 4)]);
    end;

    { Bottom gradient }
    Pen.Color := BlendColor(clBtnShadow, Column.Header.Color, 50);
    Polyline([Point(Left, Bottom - 3), Point(Right, Bottom - 3)]);
    Pen.Color := BlendColor(clBtnShadow, Column.Header.Color, 100);
    Polyline([Point(Left, Bottom - 2), Point(Right, Bottom - 2)]);
    Pen.Color := BlendColor(clBtnShadow, Column.Header.Color, 150);
    Polyline([Point(Left, Bottom - 1), Point(Right, Bottom - 1)]);
  end;
end;

procedure TOutlookStyleDisplay.DrawHeaderBackground(Column: TNxCustomColumn; R: TRect);
begin
  DrawFrameBox(Column, R);
  inherited;
end;

procedure TOutlookStyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
begin
  inherited;

end;

{ TVistaStyleDisplay }

function TVistaStyleDisplay.GetStyleDisplayAttributes: TStyleDisplayAttributes;
begin
  Result := [sdaCustomArrow];
end;

procedure TVistaStyleDisplay.AdjustTextRect(var R: TRect);
begin
  R.Left := R.Left + 2;
end;

procedure TVistaStyleDisplay.DrawAreaSplitter(R: TRect);
begin
  inherited;

end;

procedure TVistaStyleDisplay.DrawArrow(X, Y: Integer; Ascending: Boolean);
begin
  with Canvas do
  begin
    if Ascending then
    begin
      Pen.Color := clWhite;
      Brush.Color := clWhite;
      Polygon([
        Point(X + 3, Y),
        Point(X + 6, Y + 3),
        Point(X, Y + 3),
        Point(X + 3, Y)
      ]);
    end else
    begin
      Pen.Color := clWhite;
      Brush.Color := clWhite;
      Polygon([
        Point(X, Y),
        Point(X + 3, Y + 3),
        Point(X + 6, Y),
        Point(X, Y)
      ]);
    end;
  end;
end;

procedure TVistaStyleDisplay.DrawCornerBox(R: TRect; Location: TBoxLocation);
begin
  inherited;

end;

procedure TVistaStyleDisplay.DrawFrameBox(Column: TNxCustomColumn;
  R: TRect);
var
  InRect, GradRect: TRect;
  X: Integer;
begin
	InRect := R;
  InflateRect(InRect, -1, 0);
  with Canvas do
  begin
    Pen.Color := clWhite;
    Polyline([
      Point(R.Left, R.Top),
      Point(R.Left, R.Bottom)
      ]);
    Pen.Color := clBtnFace;
    Polyline([
      Point(R.Right - 1, R.Top),
      Point(R.Right - 1, R.Bottom)
      ]);
    if Column.Sorted then
    begin
      GradRect := InRect;
      GradRect.Bottom := GradRect.Top + 6;
      DrawVertGradient(Canvas, GradRect, RGB(175, 220, 240), clWhite);
      InRect.Top := GradRect.Bottom;
      Brush.Color := clWhite;
      FillRect(InRect);
      X := R.Left + (R.Right - R.Left) div 2 - 3;
      DrawArrow(X, 0, Column.SortKind = skAscending);
    end else
    begin
      Brush.Color := RGB(240, 240, 240);
      FillRect(InRect);
    end;
  end;
end;

procedure TVistaStyleDisplay.DrawHeaderBackground(Column: TNxCustomColumn; R: TRect);
begin
  DrawFrameBox(Column, R);
  inherited;
end;

procedure TVistaStyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
var
  InRect: TRect;
begin
	InRect := R;
  InflateRect(InRect, -1, 0);
  with Canvas do
  begin
    Pen.Color := clWhite;
    Polyline([
      Point(R.Left, R.Top),
      Point(R.Left, R.Bottom)
      ]);
    Pen.Color := clBtnFace;
    Polyline([
      Point(R.Right - 1, R.Top),
      Point(R.Right - 1, R.Bottom)
      ]);
    Brush.Color := RGB(240, 240, 240);
    FillRect(InRect);
  end;
end;

{ TCustomStringsColumnDisplay }

procedure TCustomStringsColumnDisplay.DrawContent(DisplayMode: TDisplayMode;
  AText: WideString; ImageIndex: Integer; Images: TCustomImageList);
var
  Y: Integer;
begin
  if DisplayMode <> dmImageOnly then DrawTextRect(AText, GetTextRect);
  if (DisplayMode <> dmTextOnly)
    and (Assigned(Images)) then
  begin
    Y := Self.ClientRect.Top + (Self.ClientRect.Bottom - Self.ClientRect.Top) div 2 - Images.Height div 2;
    Images.Draw(Canvas, Self.ClientRect.Left + spCellTextMargin, Y, ImageIndex);
  end;
end;

procedure TCustomStringsColumnDisplay.Paint;
var
  Cell: TCellInfo;
begin
  with Column as TNxStringsColumn do
  begin
    Cell.AsInteger := AsInteger;
    if Column is TNxComboBoxColumn then Cell.AsInteger := Items.IndexOf(AsString);
    Cell.AsString := AsString;
    DrawContent(DisplayMode, GetDrawText(Cell), Cell.AsInteger, Images);
  end;
end;

{ TStringsColumnDisplay }

function TStringsColumnDisplay.GetContentWidth: Integer;
begin
  Result := 0;
  with Column as TNxStringsColumn do
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

function TStringsColumnDisplay.GetTextRect: TRect;
begin
  Result := inherited GetTextRect;
  with Column as TNxStringsColumn do
  begin
    if Assigned(Images) and (DisplayMode <> dmTextOnly)
      then Inc(Result.Left, 4 + Images.Width);
  end;
end;

{ TRateColumnPlay }

function TRateColumnPlay.GetGlyphHeight: Integer;
begin
  with Column as TNxRateColumn do Result := Glyph.Height;
end;

function TRateColumnPlay.GetGlyphWidth: Integer;
begin
  with Column as TNxRateColumn do Result := Glyph.Width;
end;

function TRateColumnPlay.GetMax: Integer;
begin
  with Column as TNxRateColumn do Result := Max;
end;

function TRateColumnPlay.GetRatesRect: TRect;
var
  RatesRect: TRect;
begin
  with Column do
  begin
    RatesRect := Rect(0, 0, GetGlyphWidth * GetMax, GetGlyphHeight);
    Result := AlignInRect(RatesRect, Self.ClientRect, Alignment, VerticalAlignment);
  end;
end;

function TRateColumnPlay.GetValueAtPos(X, Y: Integer): Integer;
var
	RatesRect: TRect;
  Distance: Integer;
begin
  Result := -1;
  RatesRect := GetRatesRect;
  OffsetRect(RatesRect, -ClientRect.Left, -ClientRect.Top);
  if PtInRect(RatesRect, Point(X, Y)) then
    with Column do
    begin
      Distance := X - RatesRect.Left;
      Result := Distance div GetGlyphWidth + 1;
    end;
end;

procedure TRateColumnPlay.KeyPress(var Key: Char);
var
  Value: Integer;
begin
  inherited;
  case Key of
    '0'..'9':
      begin
        Value := StrToInt(Key);
        if Value <= GetMax then
        begin
          AsInteger := StrToInt(Key);
          AsString := IntToStr(AsInteger); { needed for OnEditAccept event }
          DoChange;
        end;
      end;
    '-':
      if AsInteger > 0 then
      begin
        AsInteger := AsInteger - 1;
        AsString := IntToStr(AsInteger);
        DoChange;
      end;
    '+':
      if AsInteger < GetMax then
      begin
        AsInteger := AsInteger + 1;
        AsString := IntToStr(AsInteger);
        DoChange;
      end;
  end;
end;

procedure TRateColumnPlay.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Value: Integer;
begin
  Value := GetValueAtPos(X, Y);
  if InRange(Value, 0, GetMax) and (Value <> AsInteger) then
  begin
    AsInteger := Value;
    AsString := IntToStr(AsInteger);
    DoChange;
  end;
end;

procedure TRateColumnPlay.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin

end;

procedure TRateColumnPlay.Show;
begin
  inherited;
  Column.Display.Paint;
end;

{ TMemoColumnDisplay }

procedure TMemoColumnDisplay.DrawTextRect(const Value: WideString;
  ARect: TRect);
var
  Flags: Integer;
  R: TRect;
  StringText: string;
begin
  R := ARect;
  Flags := DT_NOPREFIX; { don't replace & char }
  with Column, Canvas do
  begin
    if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
    case Alignment of
      taLeftJustify: Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter: Flags := Flags or DT_CENTER;
    end;
    case VerticalAlignment of
      taAlignTop: Flags := Flags or DT_TOP;
      taVerticalCenter: Flags := Flags or DT_VCENTER;
      taAlignBottom: Flags := Flags or DT_BOTTOM;
    end;
    case WrapKind of
      wkEllipsis: Flags := Flags or DT_END_ELLIPSIS;
      wkPathEllipsis: Flags := Flags or DT_PATH_ELLIPSIS;
      wkWordWrap: Flags := Flags or DT_WORDBREAK or DT_EDITCONTROL;
    end;
    if VerticalAlignment <> taAlignTop then
      AdjustTextRect(R, Flags, Value, VerticalAlignment);
    Brush.Style := bsClear;
    case IsUnicodeSupported of
      True:   DrawTextW(Canvas.Handle, PWideChar(Value), Length(Value), r, Flags);
      False:  begin
                StringText := Value;
                Windows.DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), R, Flags);
              end;
    end;
    Brush.Style := bsSolid;
  end;
end;

function TMemoColumnDisplay.GetTextRect: TRect;
begin
  Result := ClientRect;
  ResizeRect(Result, 2, 1, -1, 0);
end;

procedure TMemoColumnDisplay.Paint;
begin
  DrawTextRect(AsString, GetTextRect);
end;

{ TTimeColumnDisplay }

procedure TTimeColumnDisplay.Paint;
var
  Cell: TCellInfo;
begin
  Cell.AsDateTime := AsDateTime;
  DrawTextRect(Column.GetDrawText(Cell), GetTextRect);
end;

{ THyperlinkColumnDisplay }

function THyperlinkColumnDisplay.GetTextSize: TSize;
var
  iLength : Integer;
begin                                                
  Result.cx := 0;
  Result.cy := 0;
  iLength := Length(AsString);
  if (iLength > 0) then
  begin
    with (Column as TNxHyperlinkColumn) do
    begin
      if Display.Canvas.Handle > 0 then
      begin
        if UnicodeSupported then
          Windows.GetTextExtentPoint32W(Display.Canvas.Handle, PWideChar(AsString), iLength, Result)
        else
          Result := Display.Canvas.TextExtent(AsString);
      end;
    end;
  end;
end;

procedure THyperlinkColumnDisplay.Paint;
var
  Cell : TCellInfo;
begin
  with (Column as TNxHyperlinkColumn) do
  begin
    if HyperlinkHasBeenVisited(AsString) then
    begin
      if (VisitedLinkColor <> Display.Canvas.Font.Color) then
        Display.Canvas.Font.Color := VisitedLinkColor;
    end
    else if HyperlinkHasBeenInvalidated(AsString) then
    begin
      if (InvalidatedLinkColor <> Display.Canvas.Font.Color) then
        Display.Canvas.Font.Color := InvalidatedLinkColor;
    end;
  end;
  Cell.AsString := AsString;
  DrawTextRect(Column.GetDrawText(Cell), GetTextRect);
end;

{ THyperlinkColumnPlay }

function THyperlinkColumnPlay.MouseIsOverHyperlink(X, Y: Integer): Boolean;
var
    CellRect : TRect;
  Pt       : TPoint;
  Size     : TSize;
begin
  Result := False;
  if Length(AsString) > 0 then
  begin
    CellRect := ClientRect;
    OffsetRect(CellRect, -CellRect.Left, -CellRect.Top);
    Size := (Column as TNxHyperlinkColumn).Display.GetTextSize;
    CellRect := Bounds(CellRect.Left, CellRect.Top, Size.cx, CellRect.Bottom);
    Pt := Point(X, Y);
    Result := Types.PtInRect(CellRect, Pt);
  end;
end;

procedure THyperlinkColumnPlay.MouseLeave;
begin
  inherited;
  Screen.Cursor := crDefault;
end;

procedure THyperlinkColumnPlay.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if MouseIsOverHyperlink(X, Y) then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := Column.Cursor;
end;

procedure THyperlinkColumnPlay.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if MouseIsOverHyperlink(X, Y) then
  begin
    with (Column as TNxHyperlinkColumn) do
    begin
      if Assigned(OnClick) then
        OnClick(Self, Col, Row, AsString);
    end;
  end;
end;

{ TNxColorColumnDisplay }

function TNxColorColumnDisplay.GetTextRect: TRect;
begin
  Result := inherited GetTextRect;
  Inc(Result.Left, 26);
end;

procedure TNxColorColumnDisplay.Paint;
var
  Right: Integer;
begin
  inherited;
  if TNxColorColumn(Column).FullSize then
  begin
    Right := ClientRect.Right - 1;
  end else Right := ClientRect.Left + 21;

  with Canvas do
  begin
    if AsString <> '' then
    begin
      try
        Pen.Color := clGray;
        Brush.Color := StringToColor(AsString);
      except
        Brush.Color := 0;
      end;
      Rectangle(ClientRect.Left + 1, ClientRect.Top + 1, Right, ClientRect.Bottom - 1);
    end else
    begin
      Pen.Color := clGray;
      Brush.Color := clWhite;
      Rectangle(ClientRect.Left + 1, ClientRect.Top + 1, Right, ClientRect.Bottom - 1);
      Pen.Color := clRed;
      MoveTo(ClientRect.Left + 2, ClientRect.Top + 2);
      LineTo(ClientRect.Left + 20, ClientRect.Bottom - 2);
      MoveTo(ClientRect.Left + 2, ClientRect.Bottom - 3);
      LineTo(ClientRect.Left + 20, ClientRect.Top + 1);
    end;
  end;
end;

{ TOffice2007StyleDisplay }

procedure TOffice2007StyleDisplay.AdjustTextRect(var R: TRect);
begin
  inherited AdjustTextRect(R);
  R.Left := R.Left + 2;
end;

procedure TOffice2007StyleDisplay.DrawAreaSplitter(R: TRect);
begin
  with Canvas do
  begin
    Brush.Color := SchemeColor(seHeaderGradientEnd, ColorScheme);
    FillRect(R);
  end;
end;

procedure TOffice2007StyleDisplay.DrawCornerBox(R: TRect;
  Location: TBoxLocation);
begin
  DrawVertGradient(Canvas, R, clWhite, SchemeColor(seHeaderGradientEnd, ColorScheme));
  with Canvas, R do
  begin
    { Bottom line }
    Pen.Color := SchemeColor(seBorder, ColorScheme);
    Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1), Point(Left - 1, Bottom - 1)]);
  end;
end;

procedure TOffice2007StyleDisplay.DrawFrameBox(
  Column: TNxCustomColumn; R: TRect);
var
	FromColor, ToColor: TColor;
begin
  FromColor := clWhite;
  ToColor := SchemeColor(seHeaderGradientEnd, ColorScheme);

  { Draw Fill }
  if Column.Focused then
    DrawVertGradient(Canvas, R, ToColor, FromColor)
      else DrawVertGradient(Canvas, R, FromColor, ToColor);

  with Canvas, R do
  begin
    Pen.Color := SchemeColor(seBorder, ColorScheme);

    if (Column.Location = clRightSide) or (Column.Location = clAlone)
      then Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1)]) else
    begin
      Pen.Color := SchemeColor(seHeaderDivider, ColorScheme);
      Polyline([Point(Right - 1, Top + 2), Point(Right - 1, Bottom - 3)]);
    end;

    { Bottom line }
    Pen.Color := SchemeColor(seBorder, ColorScheme);
    Polyline([Point(Left, Bottom - 1), Point(Right, Bottom - 1)]);
  end;
end;

procedure TOffice2007StyleDisplay.DrawHeaderBackground(
  Column: TNxCustomColumn; R: TRect);
begin
  DrawFrameBox(Column, R);
end;

procedure TOffice2007StyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
begin
  DrawCornerBox(R);
end;

{ TOffice2010StyleDisplay }

procedure TOffice2010StyleDisplay.AdjustTextRect(var R: TRect);
begin
  inherited AdjustTextRect(R);
  R.Left := R.Left + 2;
end;

procedure TOffice2010StyleDisplay.DrawAreaSplitter(R: TRect);
begin
  with Canvas do
  begin
    Brush.Color := SchemeColor(seHeaderGradientEnd, ColorScheme);
    FillRect(R);
  end;
end;

procedure TOffice2010StyleDisplay.DrawArrow(X, Y: Integer;
  Ascending: Boolean);
begin
  with Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := $00b5aca5;
    if Ascending then
    begin
      Polygon([
        Point(X, Y + 4),
        Point(X + 4, Y),
        Point(X + 8, Y + 4)
      ]);
    end else
    begin
      Polygon([
        Point(X, Y),
        Point(X + 4, Y + 4),
        Point(X + 8, Y + 0)
      ]);
    end;
  end;
end;

procedure TOffice2010StyleDisplay.DrawCornerBox(R: TRect;
  Location: TBoxLocation);
begin
  DrawVertGradient(Canvas, R, SchemeColor(seGridHeaderGradientStart, ColorScheme), SchemeColor(seGridHeaderGradientEnd, ColorScheme));
  with Canvas, R do
  begin
    { Bottom line }
    Pen.Color := SchemeColor(seBorder, ColorScheme);
    Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1), Point(Left - 1, Bottom - 1)]);
  end;
end;

procedure TOffice2010StyleDisplay.DrawFrameBox(Column: TNxCustomColumn;
  R: TRect);
var
	FromColor, ToColor: TColor;
begin
  FromColor := SchemeColor(seGridHeaderGradientStart, ColorScheme);
  ToColor := SchemeColor(seGridHeaderGradientEnd, ColorScheme);

  { Draw Fill }
  if Column.Focused then
    DrawVertGradient(Canvas, R, ToColor, FromColor)
      else DrawVertGradient(Canvas, R, FromColor, ToColor);

  with Canvas, R do
  begin
    Pen.Color := SchemeColor(seBorder, ColorScheme);

    if (Column.Location = clRightSide) or (Column.Location = clAlone)
      then Polyline([Point(Right - 1, Top), Point(Right - 1, Bottom - 1)]) else
    begin
      Pen.Color := SchemeColor(seHeaderDivider, ColorScheme);
      Polyline([Point(Right - 1, Top + 2), Point(Right - 1, Bottom - 3)]);
    end;

    { Bottom line }
    Pen.Color := SchemeColor(seBorder, ColorScheme);
    Polyline([Point(Left, Bottom - 1), Point(Right, Bottom - 1)]);
  end;
end;

procedure TOffice2010StyleDisplay.DrawHeaderBackground(
  Column: TNxCustomColumn; R: TRect);
begin
  DrawFrameBox(Column, R);
end;

procedure TOffice2010StyleDisplay.DrawIndicator(R: TRect; Index: Integer;
  Selected, Highlighted: Boolean);
begin
  DrawCornerBox(R);
end;

end.
