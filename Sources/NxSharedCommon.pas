{
  Next Grid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:SharedCommon.pas 12/25/2002 7:10:16 bn
}

{$I NxSuite.inc}

unit NxSharedCommon;

interface

uses
	Types, Classes, Windows, Graphics, Jpeg, ExtCtrls, Dialogs, SysUtils, Math,
  NxClasses, NxConsts, NxThemesSupport
  {$IFDEF UITYPES}, UITypes{$ENDIF}
  ;

const
  PixelCountMax = 32768;

type
  THtmlTag = (htNone, htA, htB, htBr, htFont, htI, htImg, htU, htBackground);
  TTagParameter = (tpNone, tpColor, tpName, tpHref, tpSize, tpSrc);

  PRGBTripleArray = ^TRGBTripleArray; { Windows unit }
  TRGBTripleArray = array[0..PixelCountMax - 1] of TRGBTriple;
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..PixelCountMax - 1] of TRGBQuad;

	TCalcProvider = class
		class function GetRatio(const Value, Max: Double): Double;
		class function PosInRect(Width, Height, Margin: Integer; ARect: TRect;
		  Alignment: TAlignment; VerticalAlignment: TVerticalAlignment): TPoint;
		class function ResizeRect(ARect: TRect; DeltaLeft, DeltaTop,
    	DeltaRight, DeltaBottom: Integer): TRect;
    class function IsRectInRect(GuestRect, HostRect: TRect): Boolean;
  end;

  TGraphicsProvider = class
  	class function BlendColor(Color1, Color2: TColor; Amount: Integer): TColor; overload;
  	class function BlendColor(Color1, Color2: TColor; Ratio: Double): TColor; overload;
		class procedure DrawBitmapFromRes(Canvas: TCanvas; X, Y: Integer; ResStr: string;
	    Transparent: Boolean = True);
  	class procedure DrawButton(Canvas: TCanvas; ARect: TRect; OldStyle: Boolean);
    class procedure DrawFocused(Canvas: TCanvas; R: TRect;
    	XPStyle: Boolean = False);
    class procedure DrawGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
    class procedure DrawVertGradient(Canvas: TCanvas; ARect: TRect; FromColor, ToColor: TColor);
    class procedure DrawCheckBox(Handle: THandle; Canvas: TCanvas; ARect: TRect;
    	Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
      Checked, Grayed, Hover: Boolean);
		class procedure DrawImageFromRes(Canvas: TCanvas; X, Y: Integer;
    	ResStr: string);
		class procedure DrawTextRect(Canvas: TCanvas; ARect: TRect;
    	Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
		class procedure DrawWrapedTextRect(Canvas: TCanvas; ARect: TRect;
    	Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
      WordWrap: Boolean; Text: WideString; BidiMode: TBiDiMode);
		class procedure SetClipingPolygon(Canvas: TCanvas; Points: array of TPoint; Count: Integer = 0);
  end;

  TMaskProvider = class
		class function GetColorLevel(C: TColor): Integer;
		class function MixColors(C1, C2: TColor; W1: Integer): TColor;
		class procedure DrawMaskedImage(Canvas: TCanvas; Left, Top: Integer;
			Image, Mask: TBitmap);
		class procedure GetRGB(C: TColor; out R, G, B: Byte);
  end;

  TDrawProvider = class
		class procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer;
    	Bitmap: TBitmap);
		class procedure DrawBitmap(Canvas: TCanvas; X, Y: Integer;
    	Bitmap: TBitmap; BackgroundColor: TColor);
    class procedure GrayscaleBitmap(Canvas: TCanvas; X, Y: Integer;
      Bitmap: TBitmap; BackgroundColor: TColor);
  end;

  TDisplayProvider = class
    class procedure DrawFontPreview(Canvas: TCanvas; const ARect: TRect; FontName: string);
  end;

  THtmlInfo = record
    TagValue: WideString;
    Size: TSize;
  end;

  TRenderingType = (rtDraw, rtMeasure, rtMouse);

function ProcessHTML(Canvas: TCanvas; Rect: TRect; HTML: WideString;
  Pos: TPoint; Indent: TIndent; Rendering: TRenderingType; WrapKind: TWrapKind): THtmlInfo;
function GetHTMLColorName(ColorName: string): string;
function GetColorFromHTML(HTMLColor: string): TColor;
function HTMLColorToString(Color: TColor): string;
function PointOffset(Point1, Point2: TPoint; Distance: Integer): Boolean;
procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap);
procedure DrawPolyline(Canvas: TCanvas; Points: array of TPoint; Rect: TRect; Flip: Boolean);
procedure DrawTextRect(Canvas: TCanvas; ARect: TRect; Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
procedure DrawVerticalText(Canvas: TCanvas; Rect: TRect; Text: WideString; MultiLine: Boolean);
procedure FlipPointsVert(var Points: array of TPoint; Rect: TRect);
procedure SetClipPoly(Canvas: TCanvas; Points: array of TPoint);
procedure SetClipRect(Canvas: TCanvas; ClipRect: TRect);
procedure Save32BitBitmap(ABitmap: TBitmap; FileName: string);

procedure DrawBitmapFromRes(Canvas: TCanvas; X, Y: Integer;
  ResStr: string; TransparentColor: TColor);

procedure DrawFocusRect(Canvas: TCanvas; ARect: TRect);

function NormalizeRect(ARect: TRect): TRect;

function GetTextSize(Canvas: TCanvas; TextRect: TRect; Text: WideString): TSize;

var
  IsUnicodeSupported: Boolean;

implementation

type
  PStyle = ^TStyle;
  TStyle = record
    BackgroundColor: TColor;
    FontName: TFontName;
    Size: Integer;
    Color: TColor;
    Style: TFontStyles;
    Prev: PStyle;
  end;

  PBufferStyle = ^TBufferStyle;
  TBufferStyle = record
    Text: WideString;
    BackgroundColor: TColor;
    FontName: TFontName;
    Size: Integer;
    Color: TColor;
    Style: TFontStyles;
  end;

procedure AddStyle(Font: TFont; BackgroundColor: TColor; var Last: PStyle);
var
  AStyle: PStyle;
begin
  New(AStyle);
  AStyle^.BackgroundColor := BackgroundColor;
  AStyle^.Color := Font.Color;
  AStyle^.FontName := Font.Name;
  AStyle^.Size := Font.Size;
  AStyle^.Style := Font.Style;
  AStyle^.Prev := Last;
  Last := AStyle;
end;

procedure ClearStyles(var Last: PStyle);
var
  APrev: PStyle;
begin
  while Assigned(Last) do
  begin
    APrev := Last^.Prev;
    Dispose(Last);
    Last := APrev;
  end;
end;

procedure DeleteLast(Font: TFont; var BackgroundColor: TColor; var Last: PStyle);
var
  OldLast: PStyle;
begin
  if Last <> nil then
  begin
    BackgroundColor := Last^.BackgroundColor;
    Font.Color := Last^.Color;
    Font.Name := Last^.FontName;
    Font.Size := Last^.Size;
    Font.Style := Last^.Style;
    OldLast := Last;
    Last := Last^.Prev;
    Dispose(OldLast);
  end;
end;

procedure DrawBitmapFromRes(Canvas: TCanvas; X,
  Y: Integer; ResStr: string; TransparentColor: TColor);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.LoadFromResourceName(HInstance, ResStr);
    bi.Transparent := True;
    bi.TransparentColor := TransparentColor;
    Canvas.Draw(X, Y, bi);
  finally
    bi.Free;
  end;
end;

//potrebno ubaciti provere za OpenQuote

function ProcessHTML(Canvas: TCanvas; Rect: TRect; HTML: WideString; Pos: TPoint;
  Indent: TIndent; Rendering: TRenderingType; WrapKind: TWrapKind): THtmlInfo;
var
  LastStyle: PStyle;
  BufferStyle: PBufferStyle;
  i, X, Y, VertSpace, BufferWidth, DrawingPos: Integer;
  Word, TagBuffer, ParamNameBuffer, ParamValueBuffer, TextBuffer, c, Href, Src, SrcExt: WideString;
  ParamsReading, OpenQuote, TagMarkReading, TagReading, ParamNameReading, ParamValueReading, Closing, LetterAdded, ReadATag: Boolean;
  CurrentTag: THtmlTag;
  TagRect: TRect;
  {TagsCount, }ATagEnd, TagX, TagY: Integer;
  Buffer: TList;
  BackgroundColor: TColor;
  TagWidth: Integer;
  ReadingATag: Boolean;
  WordStart: Integer;
  Graphic: TGraphic;

  procedure BreakLine(Break: Boolean);
  begin
    { 9/2/12: Difference between word-wrap break
              and BR tag break }
    if (Rendering = rtMeasure) and not Break then
    begin
      if VertSpace > Result.Size.cy then
        Result.Size.cy := VertSpace;
      VertSpace := 0;
    end else
    begin
      Inc(Y, VertSpace);
      Result.Size.cy := Y;
      X := Rect.Left + Indent.Left;
      TagY := Y;
      DrawingPos := X;
      VertSpace := 0; 
    end;
    LetterAdded := False;
  end;

  procedure AddStyleToBuffer(Font: TFont; BackgroundColor: TColor; Text: WideString);
  var
    AStyle: PBufferStyle;
    Delta: Integer;
  begin
    if Text = ' ' then
    begin
      if not LetterAdded then Exit;
    end;

    TagY := Y;

    Word := Word + Text;

    LetterAdded := True;

    if Buffer.Count = 0 then
    begin
      DrawingPos := X;
      BufferWidth := 0;
    end;

    if Text = '' then Exit;

    New(AStyle);
    AStyle^.BackgroundColor := BackgroundColor;
    AStyle^.Color := Font.Color;
    AStyle^.FontName := Font.Name;
    AStyle^.Size := Font.Size;
    AStyle^.Style := Font.Style;
    AStyle^.Text := Text;
    Buffer.Add(AStyle);

    Inc(BufferWidth, GetTextWidth(Canvas, Text));

    if GetTextHeight(Canvas, Text) > VertSpace
      then VertSpace := GetTextHeight(Canvas, Text);

    Delta := TagX;
    if Rendering = rtMouse then
    begin
      if (WordStart + BufferWidth >= Rect.Right)
        and (WordStart > Rect.Left + Indent.Left) then
      begin
        Inc(TagY, VertSpace);
        TagX := Rect.Left + Indent.Left;
        Delta := Rect.Left + Indent.Left + (BufferWidth - GetTextWidth(canvas, Text));
      end;
    end;

    if (Rendering = rtMouse) then
    begin
      //pocelo je citanje A taga
      if ReadingATag then
      begin
        if ReadATag then
        begin
          if Delta = TagX then TagRect.Left := TagX - Rect.Left
            else TagRect.Left := Delta - Rect.Left;
          TagRect.Top := TagY - Rect.Top;
          ReadATag := False;
          ATagEnd := TagX;
          TagWidth := 0;
        end;
        Inc(TagWidth, GetTextWidth(Canvas, Text));
      end;
      TagX := TagX + GetTextWidth(Canvas, Text);
    end;

    TextBuffer := '';
  end;

  procedure FinishWord;
  begin

    if X + BufferWidth > Rect.Right then
    begin
      if X > Rect.Left + Indent.Left then
      begin
        if (Word <> ' ') and (Word <> '') then
        begin
          { 7/31/12: Notice. Merged for all Rendering types }
          if WrapKind = wkWordWrap then BreakLine(False);
          LetterAdded := True;
        end;
      end;
    end;

    Inc(X, BufferWidth);
    WordStart := X;

    if X > Result.Size.cx then Result.Size.cx := X;

    BufferWidth := 0;
    Word := '';
  end;

  procedure ClearBuffer;
  var
    i: Integer;
    AStyle: PBufferStyle;
  begin
    for i := Buffer.Count - 1 downto 0 do
    begin
      AStyle := Buffer[i];
      Dispose(AStyle);
    end;
    Buffer.Clear;
  end;

  procedure RemoveQuotes(var S: WideString);
  begin
    if Copy(S, 1, 1) = '"' then Delete(S, 1, 1);
    if Copy(S, Length(S), 1) = '"' then Delete(S, Length(S), 1);
  end;
  
  procedure DrawTextOut(X, Y: Integer; Text: WideString);
  var
    StrText: string;
  begin
    if IsUnicodeSupported then Windows.ExtTextOutW(Canvas.Handle, X, Y, 0, nil,
      PWideChar(Text), Length(Text), nil) else
    begin
      StrText := Text;
      Windows.ExtTextOut(Canvas.Handle, X, Y, 0, nil, PChar(StrText),
        Length(StrText), nil);
    end;
  end;

  function GetTag(const TagName: WideString): THtmlTag;
  begin
    if LowerCase(TagName) = 'a' then Result := htA
    else if LowerCase(TagName) = 'b' then Result := htB
    else if LowerCase(TagName) = 'br' then Result := htBr
    else if LowerCase(TagName) = 'font' then Result := htFont
    else if LowerCase(TagName) = 'i' then Result := htI
    else if LowerCase(TagName) = 'img' then Result := htImg
    else if LowerCase(TagName) = 'u' then Result := htU
    else if LowerCase(TagName) = 'background' then Result := htBackground
    else Result := htNone;
  end;

  function GetParameter(const ParameterName: WideString): TTagParameter;
  begin
    if LowerCase(ParameterName) = 'color' then Result := tpColor
    else if LowerCase(ParameterName) = 'href' then Result := tpHref
    else if LowerCase(ParameterName) = 'name' then Result := tpName
    else if LowerCase(ParameterName) = 'size' then Result := tpSize
    else if LowerCase(ParameterName) = 'src' then Result := tpSrc
    else Result := tpNone;
  end;

  procedure ApplyParameter(Tag: THtmlTag; Parameter: TTagParameter;
    Value: WideString);
  begin
    case Tag of
      htA: Href := Value;
      htBackground:
      case Parameter of
        tpColor: Canvas.Brush.Color := GetColorFromHTML(Value);
      end;
      htFont:
      case Parameter of
        tpColor: Canvas.Font.Color := GetColorFromHTML(Value);
        tpName: Canvas.Font.Name := Value;
        tpSize: Canvas.Font.Size := StrToInt(Value);
      end;
      htImg: if Parameter = tpSrc then Src := Value;
    end;
  end;

  procedure CloseTag(Tag: THtmlTag);
  var
    bc: TColor;
  begin
//    ShowMessage('</' + TagBuffer + '>');
    bc := Canvas.Brush.Color;
    DeleteLast(Canvas.Font, bc, LastStyle);
//    ShowMessage(ColorToString(Canvas.Font.Color));
    if Tag = htA then
    begin
      ReadingATag := False;
      ReadATag := False;
//      ShowMessage(IntToStr(TagWidth));
    end;
    if Tag = htBackground then
    begin
      Canvas.Brush.Color := bc;
      Canvas.Brush.Style := bsClear;
    end;
    if Tag = htImg then
    begin
      if FileExists(Src) then
      begin
        SrcExt := ExtractFileExt(Src);
        try
          if (SrcExt = '.jpg') or (SrcExt = '.jpeg') then Graphic := TJPEGImage.Create
          else if SrcExt = '.bmp' then Graphic := TBitmap.Create
          else Exit;

          Graphic.LoadFromFile(Src);
          Canvas.Draw(X, Y, Graphic);

          Inc(X, Graphic.Width);

          if Graphic.Height > VertSpace then
            VertSpace := Graphic.Height;

          TagX := X;

          Result.Size.cx := X;
          Result.Size.cy := Y;
        finally
          FreeAndNil(Graphic);
        end;
      end;
    end;
  end;

  procedure ApplyTag(Tag: THtmlTag);
  begin
    if Tag = htBr then
    begin
      BreakLine(True);
      Word := '';
    end else
    begin
      AddStyle(Canvas.Font, Canvas.Brush.Color, LastStyle);
      case Tag of
        htA:
        begin
          TagWidth := 0;
//          ShowMessage('1');
          Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
          Canvas.Font.Color := clBlue;
          ReadATag := True;
          ReadingATag := True;
        end;
        htB: Canvas.Font.Style := Canvas.Font.Style + [fsBold];
        htI: Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
        htImg: ;
        htU: Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
      end;
    end;
  end;

  procedure CloseParameter;
  begin
    RemoveQuotes(ParamValueBuffer);
    ApplyParameter(CurrentTag, GetParameter(ParamNameBuffer), ParamValueBuffer);

    ParamValueReading := False;
    ParamValueBuffer := '';
  end;

  procedure PaintWord;
  var
    i, Pos: Integer;
    PrevColor, PrevBackground: TColor;
    PrevStyle: TFontStyles;
    PrevSize: Integer;
    PrevName: TFontName;
  begin
    Pos := DrawingPos;
    PrevColor := Canvas.Font.Color;
    PrevStyle := Canvas.Font.Style;
    PrevSize := Canvas.Font.Size;
    PrevName := Canvas.Font.Name;
    PrevBackground := Canvas.Brush.Color;
    for i := 0 to Buffer.Count - 1 do
    begin
      BufferStyle := Buffer[i];
      Canvas.Font.Name := BufferStyle^.FontName;
      Canvas.Font.Style := BufferStyle^.Style;
      Canvas.Font.Size := BufferStyle^.Size;
      Canvas.Font.Color := BufferStyle^.Color;

      { Background Color }
      Canvas.Brush.Color := BufferStyle^.BackgroundColor;
      if Canvas.Brush.Color <> BackgroundColor
        then Canvas.Brush.Style := bsSolid
        else Canvas.Brush.Style := bsClear;

      if Rendering = rtDraw then DrawTextOut(Pos, Y, BufferStyle^.Text);
      Inc(Pos, GetTextWidth(Canvas, BufferStyle^.Text));
    end;
    Canvas.Font.Color := PrevColor;
    Canvas.Font.Style := PrevStyle;
    Canvas.Font.Size := PrevSize;
    Canvas.Font.Name := PrevName;
    Canvas.Brush.Color := PrevBackground;
    ClearBuffer;
  end;

  procedure MouseMoving;
  begin
    if (Rendering = rtMouse) and (CurrentTag = htA) then
    begin
      TagRect.Right := TagRect.Left + TagWidth;
      TagRect.Bottom := TagY + VertSpace - Rect.Top;
//      TagRect.Bottom := Y + VertSpace - Rect.Top;
      if PtInRect(TagRect, Pos) then Result.TagValue := Href;
      ReadingATag := False;
    end;
  end;

begin
  Result.Size.cx := 0;
  Result.Size.cy := 0;

//  TagsCount := 0;
  ParamsReading := False;
  LetterAdded := False;

  ReadATag := False;
  ReadingATag := False;

  LastStyle := nil;
  X := Rect.Left + Indent.Left{ + 2};
  Y := Rect.Top + Indent.Top{ + 1};
  TagX := X;
  TagY := Y;
  WordStart := X;
  OpenQuote := False;
  TagReading := False;
  TagMarkReading := False;
  Closing := False;
  VertSpace := 0; { html allow only 1 space }
  ParamValueReading := False;
  ParamNameReading := False;
  Buffer := TList.Create;
  //todo:
  Canvas.Brush.Style := bsClear;

  BackgroundColor := Canvas.Brush.Color;

  i := 1;
  while i <= Length(HTML) do
  begin
    c := HTML[i];

      if c = '>' then
        if CurrentTag = htImg then
        begin
          if not OpenQuote then
          begin
            ParamsReading := False;
            CloseParameter;
          end;

          CloseTag(CurrentTag);
          CurrentTag := htNone;
          
          Inc(i);
          Continue;
        end;

    if ParamsReading then
    begin
      if ParamValueReading then
      begin
        if (c = ' ') and not OpenQuote then
        begin
          CloseParameter;
          ParamNameBuffer := '';
          ParamValueReading := False;
          ParamNameReading := True;
          Inc(i);
          Continue;
        end;

        if (c = '>') and not OpenQuote then
        begin
          ParamsReading := False;
          CloseParameter;
          Inc(i);
          Continue;
        end;

      end else
      begin
        ParamNameReading := True;
      end;

      if ParamNameReading then
      begin
        if c = '=' then
        begin
 //         ShowMessage('Param Name: ' + ParamNameBuffer);
          ParamNameReading := False;
          ParamValueReading := True;//now we read param's value
        end else
        begin
          ParamNameBuffer := ParamNameBuffer + c;
        end;
        Inc(i);
        Continue;
      end;

      if ParamValueReading then
      begin
        ParamValueBuffer := ParamValueBuffer + c;
        if c = '"' then OpenQuote := not OpenQuote;
      end;

    end; { ParamsReading }

    if ParamsReading then
    begin
      Inc(i);
      Continue;
    end;

    if TagReading then
    begin
      if Closing then
      begin
        if c = '>' then
        begin
          CurrentTag := GetTag(TagBuffer);
          CloseTag(CurrentTag);
          Closing := False;
          TagReading := False;
          CurrentTag := htNone;
          TagBuffer := '';
        end else TagBuffer := TagBuffer + c;
      end else
      begin
        if (c = ' ') or (c = '>') then
        begin
          //tag reading is done, we have a tag:
          CurrentTag := GetTag(TagBuffer);
//          Inc(TagsCount);//inc tags count

          if CurrentTag = htBr then
          begin
            FinishWord;
            PaintWord;
            ClearBuffer;
            TextBuffer := '';
            TagX := Rect.Left + Indent.Left;
          end;

          ApplyTag(CurrentTag);

          TagBuffer := '';
          TagReading := False;
          Closing := False;

          //move
          if c = ' ' then
          begin
            ParamsReading := True;// we are now reading params
            ParamNameReading := True;
            ParamNameBuffer := '';
            Inc(i);
            Continue;
          end;
        end else TagBuffer := TagBuffer + c;
      end;
    end else { tag reading }
    begin
      if c = '<' then
      begin
        TagMarkReading := True;
      end else
      begin
        if TagMarkReading then
        begin
          TagMarkReading := False;
          TagReading := True;//ok we read tag
          if c = '/' then
          begin
            Closing := True;

            AddStyleToBuffer(Canvas.Font, Canvas.Brush.Color, TextBuffer);//add to buffer!!!

            MouseMoving;
          end else
          begin { not closing }
            Closing := False;
            AddStyleToBuffer(Canvas.Font, Canvas.Brush.Color, TextBuffer);//add to buffer!!!
            Continue;
          end;
        end else
        begin
          // kada naidjemo na razmak, mozemo da ispraznime bafer i iscrtamo tekst
          if c = ' ' then
          begin
            AddStyleToBuffer(Canvas.Font, Canvas.Brush.Color, TextBuffer);//add to buffer!!!

            FinishWord;
            PaintWord;

            ClearBuffer;

            DrawingPos := X;

            AddStyleToBuffer(Canvas.Font, Canvas.Brush.Color, ' ');
            FinishWord;
            PaintWord;
          end else TextBuffer := TextBuffer + c;
        end;
      end;
    end;

    Inc(i);
    if i > Length(HTML) then
    begin
      AddStyleToBuffer(Canvas.Font, Canvas.Brush.Color, TextBuffer);//add to buffer!!!
      FinishWord;
      PaintWord;
    end;
  end; { while }

  Inc(Result.Size.cy, VertSpace);

  Canvas.Brush.Style := bsSolid;

  ClearStyles(LastStyle);

  ClearBuffer;
  Buffer.Free;
end;

{ TCalcProvider }

class function TCalcProvider.GetRatio(const Value, Max: Double): Double;
begin
  Result := (Value / Max) * 100;
end;

class function TCalcProvider.IsRectInRect(GuestRect,
  HostRect: TRect): Boolean;
begin
  Result := not((GuestRect.Right < HostRect.Left) or (GuestRect.Left > HostRect.Right)
		or (GuestRect.Bottom < HostRect.Top) or (GuestRect.Top > HostRect.Bottom));
end;

class function TCalcProvider.PosInRect(Width, Height, Margin: Integer;
  ARect: TRect; Alignment: TAlignment;
  VerticalAlignment: TVerticalAlignment): TPoint;
begin
  case Alignment of
    taLeftJustify: Result.X := Margin + ARect.Left;
    taRightJustify: Result.X := ARect.Right - (Width + Margin);
    taCenter: Result.X := CenterPoint(ARect).X - Width div 2;
  end;
  case VerticalAlignment of
    taAlignTop: Result.Y := Margin + ARect.Top;
    taAlignBottom: Result.Y := ARect.Bottom - (Height + Margin);
    taVerticalCenter: Result.Y := CenterPoint(ARect).Y - Height div 2;
  end;
end;

class function TCalcProvider.ResizeRect(ARect: TRect; DeltaLeft, DeltaTop,
  DeltaRight, DeltaBottom: Integer): TRect;
begin
  with ARect do Result := Rect(Left + DeltaLeft, Top + DeltaTop, Right + DeltaRight, Bottom + DeltaBottom);
end;

{ TGraphicsProvider }

class function TGraphicsProvider.BlendColor(Color1, Color2: TColor;
  Amount: Integer): TColor;
var
  Value: Cardinal;
begin
  Assert(Amount in [0..255]);
  Value := Amount xor 255;
  if Integer(Color1) < 0 then Color1 := GetSysColor(Color1 and $000000FF);
  if Integer(Color2) < 0 then Color2 := GetSysColor(Color2 and $000000FF);
  Result := Integer(
    ((Cardinal(Color1) and $FF00FF) * Cardinal(Amount) +
    (Cardinal(Color2) and $FF00FF) * Value) and $FF00FF00 +
    ((Cardinal(Color1) and $00FF00) * Cardinal(Amount) +
    (Cardinal(Color2) and $00FF00) * Value) and $00FF0000) shr 8;
end;

class function TGraphicsProvider.BlendColor(Color1, Color2: TColor;
  Ratio: Double): TColor;
var
	r, g, b, r0, g0, b0, r1, g1, b1: Integer;
begin
  if Integer(Color1) < 0 then Color1 := GetSysColor(Color1 and $000000FF);
  if Integer(Color2) < 0 then Color2 := GetSysColor(Color2 and $000000FF);
	r0 := GetRValue(Color1);
	g0 := GetGValue(Color1);
	b0 := GetBValue(Color1);
	r1 := GetRValue(Color2);
	g1 := GetGValue(Color2);
	b1 := GetBValue(Color2);
	r := round(Ratio * r1 + (1 - Ratio) * R0);
	g := round(Ratio * g1 + (1 - Ratio) * g0);
	b := round(Ratio * b1 + (1 - Ratio) * b0);
	Result := RGB(r, g, b);
end;

class procedure TGraphicsProvider.SetClipingPolygon(Canvas: TCanvas;
  Points: array of TPoint; Count: Integer = 0);
var
  CLPRGN: HRGN;
begin
  //if Count = 0 then CLPRGN := CreatePolygonRgn(Points, High(Points), WINDING)
  CLPRGN := CreatePolygonRgn(Points, High(Points), WINDING);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

class procedure TGraphicsProvider.DrawBitmapFromRes(Canvas: TCanvas; X,
  Y: Integer; ResStr: string; Transparent: Boolean = True);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.LoadFromResourceName(HInstance, ResStr);
		if Transparent then
    begin
	    bi.Transparent := True;
	    bi.TransparentColor := bi.Canvas.Pixels[0, bi.Height - 1];
    end;
    Canvas.Draw(X, Y, bi);
  finally
    bi.Free;
  end;
end;

class procedure TGraphicsProvider.DrawButton(Canvas: TCanvas; ARect: TRect; OldStyle: Boolean);
var
  InRect: TRect;
begin
	InRect := ARect;
  InflateRect(InRect, -1, -1);
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(InRect);
    if not OldStyle then Frame3D(Canvas, ARect, clBtnHighlight, clBtnShadow, 1)
    	else Frame3D(Canvas, ARect, clBtnHighlight, clWindowFrame, 1);
  end;
end;

class procedure TGraphicsProvider.DrawFocused(Canvas: TCanvas; R: TRect;
	XPStyle: Boolean = False);
var
  PrevBkColor, PrevTextColor: TColorRef;
  DC: HDC;
begin
	if XPStyle then
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := clHighlight;
    Canvas.FrameRect(R);
  end else
  begin
    DC := Canvas.Handle;
    PrevBkColor := SetBkColor(DC, clBlack);
    PrevTextColor := SetTextColor(DC, clWhite);
    Windows.DrawFocusRect(DC, R);
    SetBkColor(DC, PrevBkColor);
    SetTextColor(DC, PrevTextColor);
  end;
end;

class procedure TGraphicsProvider.DrawImageFromRes(Canvas: TCanvas; X,
  Y: Integer; ResStr: string);
var
  bi: TBitmap;
begin
  bi := TBitmap.Create;
  try
    bi.Transparent := True;
    bi.LoadFromResourceName(HInstance, ResStr);
    bi.TransparentColor := bi.Canvas.Pixels[0, bi.Height - 1];
    Canvas.Draw(X, Y, bi);
  finally
    bi.Free;
  end;
end;

class procedure TGraphicsProvider.DrawCheckBox(Handle: THandle; Canvas: TCanvas; ARect: TRect;
	Alignment: TAlignment; VerticalAlignment: TVerticalAlignment; Checked, Grayed, Hover: Boolean);
var
  p: TPoint;
  Theme: THandle;
  Index: Integer;
  r: TRect;
begin
	if IsThemed then
  begin
	  p := TCalcProvider.PosInRect(13, 13, 2, ARect, Alignment, VerticalAlignment);
	  r := Rect(p.X, p.Y, p.X + 13, p.Y + 13);
    Index := 1;
    if Hover then
		begin
    	if Checked then
			begin
	      if Grayed then Index := 7 else Index := 6;
			end else
      begin
	      if Grayed then Index := 3 else Index := 2;
      end;
		end else if Checked then Index := 5;
	  Theme := OpenThemeData(Handle, 'Button');
	  DrawThemeBackground(Theme, Canvas.Handle, 3, Index, r, nil);
	  CloseThemeData(Theme);
  end else
  begin
	  p := TCalcProvider.PosInRect(11, 11, 2, ARect, Alignment, VerticalAlignment);
	  r := Rect(p.X, p.Y, p.X + 11, p.Y + 11);
    with Canvas, ARect, p do
    begin
      if Grayed then Brush.Color := clBtnFace else Brush.Color := clWindow;
      Pen.Color := clBtnShadow;
      Rectangle(r);
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

class procedure TGraphicsProvider.DrawGradient(Canvas: TCanvas; ARect: TRect;
  FromColor, ToColor: TColor);
var
	i, p, Distance: Integer;
begin
  Distance := ARect.Bottom - ARect.Top;
  if Distance = 0 then Exit;
  for i := ARect.Top to ARect.Bottom - 1 do
  begin
  	p := i - ARect.Top;
    Canvas.Pen.Color := BlendColor(FromColor, ToColor, p / Distance);
		Canvas.MoveTo(ARect.Left, i);
		Canvas.LineTo(ARect.Right, i);
		if p >= Distance then Exit;
  end;
end;

class procedure TGraphicsProvider.DrawTextRect(Canvas: TCanvas; ARect: TRect;
	Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or	DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE;
  case Alignment of
    taLeftJustify: Flags := Flags or DT_LEFT;
    taRightJustify: Flags := Flags or DT_RIGHT;
    taCenter: Flags := Flags or DT_CENTER;
  end;
  if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), ARect, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), ARect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

class procedure TGraphicsProvider.DrawWrapedTextRect(Canvas: TCanvas;
  ARect: TRect; Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
  WordWrap: Boolean; Text: WideString; BidiMode: TBiDiMode);
var
  Flags: Integer;
  r, rr: TRect;
  StringText: string;
begin
  r := ARect;
  Flags := DT_NOPREFIX; { don't replace & char }
  with Canvas do
  begin
    case Alignment of
      taLeftJustify: Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter: Flags := Flags or DT_CENTER;
    end;
    if WordWrap then
    begin
      Flags := Flags or DT_TOP;
      Flags := Flags or DT_WORDBREAK;
      rr := r;
      StringText := Text;
      if IsUnicodeSupported then
        DrawTextExW(Canvas.Handle, PWideChar(Text), -1, rr, Flags or DT_CALCRECT, nil)
          {$IFDEF DELPHI2009UP}
          else Windows.DrawTextEx(Canvas.Handle, PWideChar(Text), -1, rr, Flags or DT_CALCRECT, nil);
          {$ELSE}
          else Windows.DrawTextEx(Canvas.Handle, PAnsiChar(StringText), -1, rr, Flags or DT_CALCRECT, nil);
          {$ENDIF}
      case VerticalAlignment of
        taAlignTop: Flags := Flags or DT_TOP;
        taVerticalCenter: r.top := r.top + Round((r.bottom - rr.bottom ) / 2);
        taAlignBottom: r.top := r.Bottom - (rr.bottom - rr.top);
      end;
    end else begin
      case VerticalAlignment of
        taAlignTop: Flags := Flags or DT_TOP;
        taVerticalCenter: Flags := Flags or DT_VCENTER;
        taAlignBottom: Flags := Flags or DT_BOTTOM;
      end;
      Flags := Flags or DT_SINGLELINE;
    end;

    if BidiMode = bdRightToLeft then Flags := Flags or DT_RTLREADING;
    Brush.Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), r, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), r, Flags);
              end;
    end;
    Brush.Style := bsSolid;
  end;
end;

{class procedure TGraphicsProvider.DrawWrapedTextRect(Canvas: TCanvas;
  ARect: TRect; Alignment: TAlignment; VerticalAlignment: TVerticalAlignment;
  WordWrap: Boolean; Text: WideString; BidiMode: TBiDiMode);
var
  Flags: Integer;
  r: TRect;
  StringText: string;
begin
  r := ARect;
  Flags := DT_NOPREFIX;
  with Canvas do
  begin
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
    if WordWrap then Flags := Flags or DT_WORDBREAK else Flags := Flags or DT_SINGLELINE;
    if BidiMode = bdRightToLeft then Flags := Flags or DT_RTLREADING;
    Brush.Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), r, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), r, Flags);
              end;
    end;
    Brush.Style := bsSolid;
  end;
end;                   }

class procedure TGraphicsProvider.DrawVertGradient(Canvas: TCanvas;
  ARect: TRect; FromColor, ToColor: TColor);
var
	i, p, Distance: Integer;
begin
  Distance := ARect.Right - ARect.Left;
  if Distance = 0 then Exit;
  for i := ARect.Left to ARect.Right - 1 do
  begin
  	p := i - ARect.Left;
    Canvas.Pen.Color := BlendColor(FromColor, ToColor, p / Distance);
		Canvas.MoveTo(i, ARect.Top);
		Canvas.LineTo(i, ARect.Bottom);
		if p >= Distance then Exit;
  end;
end;

{ TGraphicsProvider }

class function TMaskProvider.GetColorLevel(C: TColor): Integer;
begin
  if C < 0 then C := GetSysColor(C and $FF);
  Result := ((C shr 16 and $FF) * 28 + (C shr 8 and $FF) * 151 +
    (C and $FF) * 77) shr 8;
end;

class function TMaskProvider.MixColors(C1, C2: TColor; W1: Integer): TColor;
var
  W2: Cardinal;
begin
  Assert(W1 in [0..255]);
  W2 := W1 xor 255;
  if Integer(C1) < 0 then C1 := GetSysColor(C1 and $000000FF);
  if Integer(C2) < 0 then C2 := GetSysColor(C2 and $000000FF);
  Result := Integer(
    ((Cardinal(C1) and $FF00FF) * Cardinal(W1) +
    (Cardinal(C2) and $FF00FF) * W2) and $FF00FF00 +
    ((Cardinal(C1) and $00FF00) * Cardinal(W1) +
    (Cardinal(C2) and $00FF00) * W2) and $00FF0000) shr 8;
end;

class procedure TMaskProvider.DrawMaskedImage(Canvas: TCanvas; Left, Top: Integer;
	Image, Mask: TBitmap);
var
	x, y, level: Integer;
  c: TColor;
  P, Pa, Pb : PRGBTripleArray;
  Background: TBitmap;
  r1, r2: TRect;
begin
	if (Image.Width <> Mask.Width) or (Image.Height <> Mask.Height) then
  begin
		raise Exception.Create('Image and Mask size differ');
    Exit;    
  end;
  Background := TBitmap.Create;
  Background.Width := Image.Width;
  Background.Height := Image.Height;
  r1 := Rect(Left, Top, Left + Image.Width, Top + Image.Height);
  r2 := Rect(0, 0, Image.Width, Image.Height);
  Background.Canvas.CopyRect(r2, Canvas, r1);

  Image.PixelFormat := pf24bit;
  Mask.PixelFormat := pf24bit;
  Background.PixelFormat := pf24bit;
	for y := 0 to Image.Height - 1 do
  begin
  	P := Image.ScanLine[y];
  	Pa := Mask.ScanLine[y];
    Pb := Background.ScanLine[y];
		for x := 0 to Image.Width -1 do
		begin
	  	level := TMaskProvider.GetColorLevel(RGB(Pa[x].rgbtRed, Pa[x].rgbtGreen, Pa[x].rgbtBlue));
      with P[x] do
      begin
	    	c := TMaskProvider.MixColors(RGB(rgbtRed, rgbtGreen, rgbtBlue), RGB(Pb[x].rgbtRed, Pb[x].rgbtGreen, Pb[x].rgbtBlue), level);
        TMaskProvider.GetRGB(c, Pb[x].rgbtRed, Pb[x].rgbtGreen, Pb[x].rgbtBlue);
      end;
		end;
  end;
  Canvas.Draw(Left, Top, Background);
  Background.Free;
end;

class procedure TMaskProvider.GetRGB(C: TColor; out R, G, B: Byte);
begin
  if Integer(C) < 0 then C := GetSysColor(C and $000000FF);
  R := C and $FF;
  G := C shr 8 and $FF;
  B := C shr 16 and $FF;
end;

{ TDrawProvider }

class procedure TDrawProvider.ApplyBitmap(Canvas: TCanvas; X, Y: Integer;
  Bitmap: TBitmap);
	procedure SetColorValues24(var P: PByte; var r, g, b: Byte);
  begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
    Inc(P);
  end;

	procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

	procedure PutColorValues(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

  procedure Draw24BitBitmap;
  var
    i, j: Integer;
    Back :TBitmap;
    BackRow: PRGBTripleArray;
    ForeRow: PRGBQuadArray;
    function DoCombine(F, B, A :byte) :byte;
    begin
      Result := EnsureRange((Round(F * A / 255) + Round(B * (1 - (A / 255)))), 0, 255);
    end;
  begin
    back := TBitmap.Create;
    back.Width := Bitmap.Width;
    back.Height := Bitmap.Height;
    back.PixelFormat := pf24bit;
    back.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(X, Y, X + Bitmap.Width, Y + Bitmap.Height));

    for i := 0 to Bitmap.Height -1 do
    begin
      BackRow := Back.ScanLine[i];
      ForeRow := Bitmap.ScanLine[i];
      for j := 0 to Bitmap.Width -1 do
      begin
        BackRow[j].rgbtRed := DoCombine(ForeRow[j].rgbRed, BackRow[j].rgbtRed, ForeRow[j].rgbReserved);
        BackRow[j].rgbtGreen := DoCombine(ForeRow[j].rgbGreen, BackRow[j].rgbtGreen, ForeRow[j].rgbReserved);
        BackRow[j].rgbtBlue := DoCombine(ForeRow[j].rgbBlue, BackRow[j].rgbtBlue, ForeRow[j].rgbReserved);
      end;
    end;
    Canvas.Draw(X, Y, Back);
    back.Free;
  end;

	procedure Draw32BitBitmap;
	var
		i, j: Integer;
	  c: TColor;
	  P, P2, P3: PByte;
    r, g, b, r2, g2, b2, level: Byte;
    bmp, back: TBitmap;
	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

    back := TBitmap.Create;
    back.Width := Bitmap.Width;
    back.Height := Bitmap.Height;
    back.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(X, Y, X + Bitmap.Width, Y + Bitmap.Height));

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
      P3 := back.ScanLine[i];
			for j := 0 to Bitmap.Width -1 do
			begin
        SetColorValues32(P, r, g, b, level);
        SetColorValues24(P3, r2, g2, b2);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), RGB(r2, g2, b2), level);
        PutColorValues(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
    back.Free;
  end;
begin
	case Bitmap.PixelFormat of
    pf32bit: Draw24BitBitmap;
  	else Canvas.Draw(X, Y, Bitmap);
  end;
end;

class procedure TDrawProvider.DrawBitmap(Canvas: TCanvas; X, Y: Integer;
  Bitmap: TBitmap; BackgroundColor: TColor);
	procedure SetColorValues(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

	procedure PutColorValues(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

	procedure Draw32BitBitmap;
	var
		i, j: Integer;
	  c: TColor;
	  P, P2: PByte;
    r, g, b, level: Byte;
    bmp: TBitmap;
	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
			for j := 0 to Bitmap.Width - 1 do
			begin
        SetColorValues(P, r, g, b, level);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), BackgroundColor, level);
        PutColorValues(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
  end;
begin
	case Bitmap.PixelFormat of
    pf32bit: Draw32BitBitmap;
  	else Canvas.Draw(X, Y, Bitmap);
  end;
end;

class procedure TDrawProvider.GrayscaleBitmap(Canvas: TCanvas; X, Y: Integer;
  Bitmap: TBitmap; BackgroundColor: TColor);
  procedure GrayscaleBitmap;
  type
    TRGBArray = array[0..32767] of TRGBTriple;
    PRGBArray = ^TRGBArray;
  var
    x, y, Gray: Integer;
    Row: PRGBArray;
  begin
    Bitmap.PixelFormat := pf24Bit;
    for y := 0 to Bitmap.Height - 1 do
    begin
      Row := Bitmap.ScanLine[y];
      for x := 0 to Bitmap.Width - 1 do
      begin
        Gray := (Row[x].rgbtRed + Row[x].rgbtGreen + Row[x].rgbtBlue) div 3;
        Row[x].rgbtRed := Gray;
        Row[x].rgbtGreen := Gray;
        Row[x].rgbtBlue := Gray;
      end;
    end;
  end;

	procedure SetColorValues(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

  procedure PutColorValues32(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

	procedure Grayscale32BitBitmap;
	var
		i, j: Integer;
	  c, gr: TColor;
	  P, P2: PByte;
    r, g, b, level: Byte;
    bmp: TBitmap;
	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
			for j := 0 to Bitmap.Width - 1 do
			begin
        SetColorValues(P, r, g, b, level);
        gr := (r + g + b) div 3;
	    	c := TMaskProvider.MixColors(gr, BackgroundColor, level);
        PutColorValues32(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
  end;

begin
	case Bitmap.PixelFormat of
    pf32bit: Grayscale32BitBitmap;
  	else GrayscaleBitmap;
  end;
end;

{ TDisplayProvider }

class procedure TDisplayProvider.DrawFontPreview(Canvas: TCanvas;
  const ARect: TRect; FontName: string);
begin
  with Canvas do
  begin
    Brush.Color := clHighlight;
    Font.Size := 8;
    Font.Color := clHighlightText;
    Font.Name := FontName;
    TextRect(ARect, ARect.Left, ARect.Top, 'ab');
  end;
end;

function GetHTMLColorName(ColorName: string): string;
var
  AColorName: TColorName;
  i : integer;
begin
  Result := ColorName;
  for i := 0 to 140 do
  begin
    AColorName := WebColorNames[i];
    if AColorName[cnColorName] = LowerCase(ColorName) then
    begin
      Result := AColorName[cnColorValue];
      Break;
    end;
  end;
end;

function GetColorFromHTML(HTMLColor: string): TColor;
var
  sc: string;
begin
  try
    sc := GetHTMLColorName(HTMLColor);
    Delete(sc, 1, 1); { delete # char }
    sc := '$00' + sc; { alpha chanel }
    Result := StringToColor(sc);
    Result := (((Result and $ff) shl 16) + (Result and $ff00) + (Result and $ff0000) shr 16);
  except
    Result := clNone;
  end;
end;

function HTMLColorToString(Color: TColor): string;
begin
  if Integer(Color) < 0 then Color := GetSysColor(Color and $000000FF);
  Result := '#' + IntToHex(((Color and $ff) shl 16) + (Color and $ff00) + (Color and $ff0000) shr 16, 6);
end;

function PointOffset(Point1, Point2: TPoint; Distance: Integer): Boolean;
begin
  Result := (Point1.X < Point2.X - Distance) or (Point1.X > Point2.X + Distance)
    or (Point1.Y < Point2.Y - Distance) or (Point1.Y > Point2.Y + Distance);
end;

procedure ApplyBitmap(Canvas: TCanvas; X, Y: Integer; Bitmap: TBitmap);
	procedure SetColorValues24(var P: PByte; var r, g, b: Byte);
  begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
    Inc(P);
  end;

	procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
  end;

	procedure PutColorValues(var P: PByte; r, g, b: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    Inc(P); // skip alpha chanel
  end;

	procedure Draw32BitBitmap;
	var
		i, j: Integer;
	  c: TColor;
	  P, P2, P3: PByte;
    r, g, b, r2, g2, b2, level: Byte;
    bmp, back: TBitmap;
    function DoCombine(F, B, A :byte) :byte;
    begin
      //(foreground_color * alpha) + (background_color * (100% - alpha)).
      Result := EnsureRange((Round(F*A/255) +Round(B*(1-(A/255)))), 0, 255);  //EnsureRange is implemented in Math unit
    end;

	begin
    bmp := TBitmap.Create;
    bmp.Width := Bitmap.Width;
    bmp.Height := Bitmap.Height;
    bmp.Assign(Bitmap);

    back := TBitmap.Create;
    back.Width := Bitmap.Width;
    back.Height := Bitmap.Height;
    back.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height), Canvas, Rect(X, Y, X + Bitmap.Width, Y + Bitmap.Height));

		for i := 0 to Bitmap.Height - 1 do
	  begin
	  	P := Bitmap.ScanLine[i];
      P2 := bmp.ScanLine[i];
      P3 := back.ScanLine[i];
			for j := 0 to Bitmap.Width -1 do
			begin
        SetColorValues32(P, r, g, b, level);
        SetColorValues24(P3, r2, g2, b2);
	    	c := TMaskProvider.MixColors(RGB(r, g, b), RGB(r2, g2, b2), level);
        PutColorValues(P2, GetRValue(c), GetGValue(c), GetBValue(c));
			end;
	  end;
	  Canvas.Draw(X, Y, bmp);
    bmp.Free;
    back.Free;
  end;
begin
	case Bitmap.PixelFormat of
    pf32bit: Draw32BitBitmap;
  	else Canvas.Draw(X, Y, Bitmap);
  end;
end;

procedure Save32BitBitmap(ABitmap: TBitmap; FileName: string);
	procedure PutColorValues(var P: PByte; r, g, b, alpha: Byte);
  begin
    P^ := b;
    Inc(P);
    P^ := g;
    Inc(P);
    P^ := r;
    Inc(P);
    P^ := alpha;
    Inc(P);
  end;

	procedure SetColorValues32(var P: PByte; var r, g, b, alpha: Byte);
	begin
	  b := PByte(P)^;
    Inc(P);
	  g := PByte(P)^;
    Inc(P);
	  r := PByte(P)^;
    Inc(P);
	  alpha := PByte(P)^;
    Inc(P);
   end;
var
  Bitmap: TBitmap;
  i, j: Integer;
  Pa, Pb: PByte;
  r, g, b, alpha: byte;
begin
  Bitmap := TBitmap.Create;
  Bitmap.Width := ABitmap.Width;
  Bitmap.Height := ABitmap.Height;
  Bitmap.PixelFormat := ABitmap.PixelFormat;
  for i := 0 to ABitmap.Height - 1 do
  begin
    Pa := ABitmap.ScanLine[i];
    Pb := Bitmap.ScanLine[i];
    for j := 0 to ABitmap.Width - 1 do
    begin
      SetColorValues32(Pa, r, g, b, alpha);
      //ShowMessage(IntToStr(r) + ',' + IntToStr(g) + ',' + IntToStr(b) + ' ' + IntToStr(alpha));
      PutColorValues(Pb, r, g, b, alpha);
    end;
  end;
  Bitmap.SaveToFile(FileName);
  FreeAndNil(Bitmap);
end;

procedure DrawVerticalText(Canvas: TCanvas; Rect: TRect;
  Text: WideString; MultiLine: Boolean);
var
  LogRec: TLOGFONT;
  OldFont, NewFont: HFONT;
  Flags: Integer;
  StringList: TStringlist;
  i, H: Integer;
  s: string;
begin
  Flags := DT_NOPREFIX or DT_BOTTOM or DT_EXTERNALLEADING or DT_SINGLELINE;
  with Canvas do
  begin
    Brush.Style := bsClear;
    GetObject(Font.Handle, SizeOf(LogRec), @LogRec);
    LogRec.lfEscapement := 900;
    LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
    NewFont := CreateFontIndirect(LogRec);
    OldFont := SelectObject(Canvas.Handle, NewFont);
    if (Pos(#13, Text) = 0) or not MultiLine then
    begin
      case IsUnicodeSupported of
        True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), Rect, Flags);
        else DrawText(Canvas.Handle, PAnsiChar(Text), Length(Text), Rect, Flags)
      end;
    end else
    begin
      // Windows.DrawText has a bug that can't handle multiple lines in non-horizontal orientation.
      // See http://msdn.microsoft.com/en-us/library/dd162498(VS.85).aspx
      StringList := TStringlist.Create;
      StringList.Text := Text;
      H := TextHeight(Text);
      For i := 0 to StringList.Count - 1 do
      begin
        S := StringList.Strings[i];
        case IsUnicodeSupported of
          True: DrawTextW(Canvas.Handle, PWideChar(S), Length(S), Rect, Flags);
          else DrawText(Canvas.Handle, PAnsiChar(S), Length(S), Rect, Flags)
        end;
        Inc(Rect.Left, H);
      end;
      StringList.Free;
    end;
    NewFont := SelectObject(Canvas.Handle,OldFont);
    DeleteObject(NewFont);
  end;
end;

procedure DrawPolyline(Canvas: TCanvas; Points: array of TPoint; Rect: TRect; Flip: Boolean);
begin
  if Flip then FlipPointsVert(Points, Rect);
  Canvas.Polyline(Points);
end;

procedure DrawTextRect(Canvas: TCanvas; ARect: TRect;
	Alignment: TAlignment; Text: WideString; BiDiMode: TBiDiMode = bdLeftToRight);
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or	DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_SINGLELINE;
  case Alignment of
    taLeftJustify: Flags := Flags or DT_LEFT;
    taRightJustify: Flags := Flags or DT_RIGHT;
    taCenter: Flags := Flags or DT_CENTER;
  end;
  if BiDiMode <> bdLeftToRight then Flags := Flags or DT_RTLREADING;
  with Canvas.Brush do
  begin
    Style := bsClear;
    case IsUnicodeSupported of
      True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), ARect, Flags);
      False:  begin
                StringText := Text;
                DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), ARect, Flags);
              end;
    end;
    Style := bsSolid;
  end;
end;

procedure FlipPointsVert(var Points: array of TPoint; Rect: TRect);
var                   
  i, m: Integer;
begin
  m := Rect.Top + (Rect.Bottom - Rect.Top) div 2;
  for i := 0 to Length(Points) - 1 do
    Points[i].Y := m - (Points[i].Y - m);
end;

procedure SetClipPoly(Canvas: TCanvas; Points: array of TPoint);
var
  CLPRGN: HRGN;
begin
  CLPRGN := CreatePolygonRgn(Points, Length(Points), WINDING);
  SelectClipRgn(Canvas.Handle, CLPRGN);
  DeleteObject(CLPRGN);
end;

procedure SetClipRect(Canvas: TCanvas; ClipRect: TRect);
var
  CLPRGN: HRGN;
  P: TPoint;
begin
  with ClipRect do
    CLPRGN := CreateRectRgn(Left, Top, Right, Bottom);
    try
      GetWindowOrgEx(Canvas.Handle, P);
      OffsetRgn(CLPRGN, -P.X, -P.Y);

      SelectClipRgn(Canvas.Handle, CLPRGN);
    finally
      DeleteObject(CLPRGN);
    end;
end;

procedure DrawFocusRect(Canvas: TCanvas; ARect: TRect);
var
  PrevBkColor, PrevTextColor: TColorRef;
  DC: HDC;
begin
  DC := Canvas.Handle;
  PrevBkColor := SetBkColor(DC, clBlack);
  PrevTextColor := SetTextColor(DC, clWhite);
  Windows.DrawFocusRect(DC, ARect);
  SetBkColor(DC, PrevBkColor);
  SetTextColor(DC, PrevTextColor);
end;

function NormalizeRect(ARect: TRect): TRect;
var
  Tmp: Integer;
begin
  if (ARect.Left > ARect.Right) then
  begin
    Tmp := ARect.Left;
    ARect.Left := ARect.Right;
    ARect.Right := Tmp;
  end;
  if (ARect.Top > ARect.Bottom) then
  begin
    Tmp := ARect.Top;
    ARect.Top := ARect.Bottom;
    ARect.Bottom := Tmp;
  end;
  Result := ARect;
end;

function GetTextSize(Canvas: TCanvas; TextRect: TRect; Text: WideString): TSize;
var
  Flags: Integer;
  StringText: string;
begin
  Flags := DT_NOPREFIX or	DT_VCENTER or DT_END_ELLIPSIS or DT_EXTERNALLEADING or DT_CALCRECT or DT_WORDBREAK;
  case UnicodeSupported of
    True: DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), TextRect, Flags);
    False:
    begin
      StringText := Text;
      DrawText(Canvas.Handle, PAnsiChar(StringText), Length(StringText), TextRect, Flags);
    end;
  end;
  with Result do
  begin
    cx := TextRect.Right - TextRect.Left;
    cy := TextRect.Bottom - TextRect.Top;
  end;
end;

initialization
  IsUnicodeSupported := (Win32Platform = VER_PLATFORM_WIN32_NT);

end.
