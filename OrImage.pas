{------------------------------------------------------------------------------
                    Component TOrImage v1.0
         (c) 20.03.03 by Yurij Orishenko  e-mail: yraor@omen.ru
         Tested in Delphi 5
-------------------------------------------------------------------------------

1. TOrImage component is a TImage that allow programmer to change picture characteristic:
Brightness, Contrast, Lightness, Darkness, Color saturation and add some grafic effects
in design and run time, togethe or by ones.

2. To set picture characteristic and grafic  effects in design time your can use property editor or
Object Inspector directly.

3. TOrImage support any of register in your Delphi grafic files format:
*.jpg, *.bmp, *.gif, *.wmf, *.ico and other.

4. This are TOrImage new or modified propertys and methods:

  public
    property IsMouseEntering: Boolean;  readonly;  Set to True if mouse above the component
    property Picture: TPicture;  readonly;         Picture bitmap (TBitmap) after transform (Set automatically from PictureOriginal)
    procedure UpdateEffects;                       Update Picture transform (use if your change property Picture indirectly)
    procedure ResetEffects;                        Reset any transform and set Picture to PictureOriginal

  published
    property PictureOriginal: TPicture;            Save original picture bitmap as TBitmap (convert from any of register in your Delphi grafic format, successors of TGrafic)
    property PicBrightness: Integer;               Brightness:          -255..255
    property PicContrast: Integer;                 Contrast:            -255..MaxInt
    property PicGrayScale: Boolean;                Gray scale only, if true
    property PicLightness: Integer;                Lightness:           -MaxInt...255
    property PicDarkness: Integer;                 Darkness:            -MaxInt...255
    property PicSaturation: Integer;               Color saturation:    -255..MaxInt
    property PicSplitlight: Integer;               Split light:         0..10
    property PicInvert: Boolean;                   Invert colors, if true

    property PicColorNoise: Integer;       *1      Add color noise:     0..MaxInt
    property PicMonoNoise: Integer;        *1      Add mono noise:      0..MaxInt

    property PicPosterize: Integer;        *2      Posterize effect:    0..MaxInt
    property PicSolorize: Integer;         *2      Solorize effect:     0..MaxInt

    property PicEmboss: Boolean;           *3      Set Emboss effect, if true
    property PicMosaic: Integer;           *3      Mosaic effect:       0..MAX(Pic.W,Pic.H)
    property PicSplitBlur: Integer;        *3      SplitBlur effect:    0..255;
    property PicGaussianBlur: Integer;     *3      GaussianBlur effect: 0..50;
    property PicAntiAlias: Integer;        *3      AntiAlias effect:    0..50;
    property PicTrace: Integer;            *3      Trace effect:        0..10;
    property PicTile: Integer;             *3      Tile effect:         0..MAX(Pic.W,Pic.H)div 10;

    property PictureEffects;                       Run effects property EDITOR;


    Events:

    property OnMouseEnter: TNotifyEvent;           Event handler to respond when the mouse entering to client rectangle
    property OnMouseExit: TNotifyEvent;            Event handler to respond when the mouse exiting of client rectangle


    *1, *2, *3  -  group of effects. Your can set only one effect from each group at one time.
                                     Other automatic set to 0.

Note:
  Some algoritm of grafic effects are deriving from TProEffectImage, written by Babak Sateli


}


unit OrImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

Const
  MAXAntiAlias    = 50;
  MAXTrace        = 10;
  MIN_TileSize    = 10;
  MAXGaussianBlur = 50;
  MAXSplitBlur    = 255;
  MAXSolorize     = 255;
  MAXSplitlight   = 10;
  MINSaturation   =-255;
  MAXDarkness     = 255;
  MAXLightness    = 255;
  MINContrast     =-255;
  MINBrightness   =-255;
  MAXBrightness   = 255;


type
  TMImage = class(TGraphicControl)
  private
    FPictureOriginal: TPicture;
    FNoise: TBitmap;
    FEffectBMP: TBitmap;
    FIsMouseEntering: Boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseExit: TNotifyEvent;
    FPictureOriginalChangedONprocess: Boolean;
    FProportional: boolean;
    FBrightness: Integer;
    FContrast: Integer;
    FGrayScale: Boolean;
    FLightness: Integer;
    FDarkness: Integer;
    FSaturation: Integer;
    FSplitlight: Integer;
    FInvert: Boolean;
    FColorNoise: Integer;
    FMonoNoise: Integer;
    FPosterize: Integer;
    FSolorize: Integer;
    FEmboss: Boolean;
    FMosaic: Integer;
    FSplitBlur: Integer;
    FGaussianBlur: Integer;
    FAntiAlias: Integer;
    FTrace: Integer;
    FTile: Integer;
    FPictureEffects: String;
    FPicture: TPicture;
    FOnProgress: TProgressEvent;
    FStretch: Boolean;
    FCenter: Boolean;
    FIncrementalDisplay: Boolean;
    FTransparent: Boolean;
    FDrawing: Boolean;
    function GetCanvas: TCanvas;
    procedure PictureChanged(Sender: TObject);
    procedure PictureOriginalChanged(Sender: TObject);
    procedure SetCenter(Value: Boolean);
    procedure SetPictureOriginal(Value: TPicture);
    procedure SetStretch(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
    procedure SetBrightness(Value: Integer);
    procedure SetContrast(Value: Integer);
    procedure SetGrayScale(Value: Boolean);
    procedure SetLightness(Value: Integer);
    procedure SetDarkness(Value: Integer);
    procedure SetSaturation(Value: Integer);
    procedure SetSplitlight(Value: Integer);
    procedure SetInvert(Value: Boolean);
    procedure SetColorNoise(Value: Integer);
    procedure SetMonoNoise(Value: Integer);
    procedure SetPosterize(Value: Integer);
    procedure SetSolorize(Value: Integer);
    procedure SetEmboss(Value: Boolean);
    procedure SetMosaic(Value: Integer);
    procedure SetSplitBlur(Value: Integer);
    procedure SetGaussianBlur(Value: Integer);
    procedure SetAntiAlias(Value: Integer);
    procedure SetProportional(Value: boolean);
    procedure SetTrace(Value: Integer);
    procedure SetTile(Value: Integer);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    function DestRect: TRect;
    function DoPaletteChange: Boolean;
    function GetPalette: HPALETTE; override;
    procedure Paint; override;
    procedure Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    property IsMouseEntering: Boolean read FIsMouseEntering;
    property Canvas: TCanvas read GetCanvas;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateEffects;
    procedure ResetEffects;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property Center: Boolean read FCenter write SetCenter default False;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property IncrementalDisplay: Boolean read FIncrementalDisplay write FIncrementalDisplay default False;
    property ParentShowHint;
    property Picture: TPicture read FPicture;
     property Proportional: boolean
      read FProportional write SetProportional default False;
    property PictureOriginal: TPicture read FPictureOriginal write SetPictureOriginal;
    property PicBrightness: Integer read FBrightness write SetBrightness;
    property PicContrast: Integer read FContrast write SetContrast;
    property PicGrayScale: Boolean read FGrayScale write SetGrayScale;
    property PicLightness: Integer read FLightness write SetLightness;
    property PicDarkness: Integer read FDarkness write SetDarkness;
    property PicSaturation: Integer read FSaturation write SetSaturation;
    property PicSplitlight: Integer read FSplitlight write SetSplitlight;
    property PicInvert: Boolean read FInvert write SetInvert;
    property PicColorNoise: Integer read FColorNoise write SetColorNoise;
    property PicMonoNoise: Integer read FMonoNoise write SetMonoNoise;
    property PicPosterize: Integer read FPosterize write SetPosterize;
    property PicSolorize: Integer read FSolorize write SetSolorize;
    property PicEmboss: Boolean read FEmboss write SetEmboss;
    property PicMosaic: Integer read FMosaic write SetMosaic;
    property PicSplitBlur: Integer read FSplitBlur write SetSplitBlur;
    property PicGaussianBlur: Integer read FGaussianBlur write SetGaussianBlur;
    property PicAntiAlias: Integer read FAntiAlias write SetAntiAlias;
    property PicTrace: Integer read FTrace write SetTrace;
    property PicTile: Integer read FTile write SetTile;
    property PictureEffects: String read FPictureEffects write FPictureEffects;
    property PopupMenu;
    property ShowHint;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseExit: TNotifyEvent read FOnMouseExit write FOnMouseExit;
    property OnMouseUp;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnStartDock;
    property OnStartDrag;
  end;


const
    MaxPixelCount   =  32768;

type
    pRGBArray  =  ^TRGBArray;
    TRGBArray  =  ARRAY[0..MaxPixelCount-1] OF TRGBTriple;

function Min(a, b: integer): integer;
function Max(a, b: integer): integer;
function IntToByte(i:Integer):Byte;




implementation

{$R orimage.res}

uses Consts;


{ TMImage }

constructor TMImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FEffectBMP:=nil;
  FNoise:=nil;

  FBrightness:=0;
  FContrast:=0;
  FGrayScale:=false;
  FLightness:=0;
  FDarkness:=0;
  FSaturation:=0; 
  FSplitlight:=0;
  FInvert:=false;
  FColorNoise:=0;
  FMonoNoise:=0;
  FPosterize:=0;
  FSolorize:=0;
  FEmboss:=false;
  FMosaic:=0;
  FSplitBlur:=0;
  FGaussianBlur:=0;
  FAntiAlias:=0;
  FTrace:=0;
  FTile:=0;

  FIsMouseEntering:=false;
  FPictureOriginalChangedONprocess:=false;
  FPictureOriginal := TPicture.Create;
  FPictureOriginal.OnChange := PictureOriginalChanged;
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FPicture.OnProgress := Progress;
  Height := 105;
  Width := 105;
end;

destructor TMImage.Destroy;
begin
  FPictureOriginal.Free;
  FPicture.Free;

  if FNoise<>nil then FNoise.Free;
  FNoise:=nil;
  if FEffectBMP<>nil then FEffectBMP.Free;
  FEffectBMP:=nil;

  inherited Destroy;
end;

procedure TMImage.ResetEffects;
begin
  FBrightness:=0;
  FContrast:=0;
  FGrayScale:=false;
  FLightness:=0;
  FDarkness:=0;
  FSaturation:=0;
  FSplitlight:=0;
  FInvert:=false;
  FColorNoise:=0;
  FMonoNoise:=0;
  FPosterize:=0;
  FSolorize:=0;
  FEmboss:=false;
  FMosaic:=0;
  FSplitBlur:=0;
  FGaussianBlur:=0;
  FAntiAlias:=0;
  FTrace:=0;
  FTile:=0;

  if FNoise<>nil then FNoise.Free;
  FNoise:=nil;
  if FEffectBMP<>nil then FEffectBMP.Free;
  FEffectBMP:=nil;
  FPicture.Assign(FPictureOriginal);
end;

function TMImage.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture.Graphic <> nil then
    Result := FPicture.Graphic.Palette;
end;

function TMImage.DestRect: TRect;
var
  w, h, cw, ch: integer;
  xyaspect: double;
begin
  w := Picture.Width;
  h := Picture.Height;
  cw := ClientWidth;
  ch := ClientHeight;
  if Stretch or (Proportional and ((w > cw) or (h > ch))) then
  begin
    if Proportional and (w > 0) and (h > 0) then
    begin
      xyaspect := w / h;
      if w > h then
      begin
        w := cw;
        h := Trunc(cw / xyaspect);
        if h > ch then  // woops, too big
        begin
          h := ch;
          w := Trunc(ch * xyaspect);
        end;
      end
      else
      begin
        h := ch;
        w := Trunc(ch * xyaspect);
        if w > cw then  // woops, too big
        begin
          w := cw;
          h := Trunc(cw / xyaspect);
        end;
      end;
    end
    else
    begin
      w := cw;
      h := ch;
    end;
  end;

  with Result do
  begin
    Left := 0;
    Top := 0;
    Right := w;
    Bottom := h;
  end;

  if Center then
    OffsetRect(Result, (cw - w) div 2, (ch - h) div 2);
end;

procedure TMImage.Paint;
var
  Save: Boolean;
begin
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
  Save := FDrawing;
  FDrawing := True;
  try
    with inherited Canvas do
      StretchDraw(DestRect, Picture.Graphic);
  finally
    FDrawing := Save;
  end;
end;

function TMImage.DoPaletteChange: Boolean;
var
  ParentForm: TCustomForm;
  Tmp: TGraphic;
begin
  Result := False;
  Tmp := Picture.Graphic;
  if Visible and (not (csLoading in ComponentState)) and (Tmp <> nil) and
    (Tmp.PaletteModified) then
  begin
    if (Tmp.Palette = 0) then
      Tmp.PaletteModified := False
    else
    begin
      ParentForm := GetParentForm(Self);
      if Assigned(ParentForm) and ParentForm.Active and Parentform.HandleAllocated then
      begin
        if FDrawing then
          ParentForm.Perform(wm_QueryNewPalette, 0, 0)
        else
          PostMessage(ParentForm.Handle, wm_QueryNewPalette, 0, 0);
        Result := True;
        Tmp.PaletteModified := False;
      end;
    end;
  end;
end;

procedure TMImage.Progress(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
begin
  if FIncrementalDisplay and RedrawNow then
  begin
    if DoPaletteChange then Update
    else Paint;
  end;
  if Assigned(FOnProgress) then FOnProgress(Sender, Stage, PercentDone, RedrawNow, R, Msg);
end;

function TMImage.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if Picture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      Picture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if Picture.Graphic is TBitmap then
    Result := TBitmap(Picture.Graphic).Canvas
  else
    raise EInvalidOperation.Create(SImageCanvasNeedsBitmap);
end;

procedure TMImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
     PictureChanged(Self);
  end;
end;

procedure TMImage.SetPictureOriginal(Value: TPicture);
begin
  FPictureOriginal.Assign(Value);
end;

procedure TMImage.SetStretch(Value: Boolean);
begin
  if Value <> FStretch then
  begin
    FStretch := Value;
    PictureChanged(Self);
  end;
end;

procedure TMImage.SetTransparent(Value: Boolean);
begin
  if Value <> FTransparent then
  begin
    FTransparent := Value;
    PictureChanged(Self);
  end;
end;

procedure TMImage.PictureOriginalChanged(Sender: TObject);
var
  bmp: TBitmap;
begin
  if FPictureOriginalChangedONprocess then Exit;

  if FPictureOriginal.Graphic=nil then FPicture.Assign(nil)
  else if FPictureOriginal.Graphic is TBitmap then
  begin
    FPictureOriginal.Bitmap.PixelFormat := pf24bit;
    FPicture.Assign(FPictureOriginal.Graphic);
    if FNoise<>nil then FNoise.Free;
    FNoise:=nil;
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
    UpdateEffects;
  end
  else begin
    bmp:=TBitmap.Create;
    FPictureOriginalChangedONprocess:=true;
    FPictureOriginal.Graphic.OnChange:=nil;
    try
      bmp.PixelFormat := pf24bit;
      bmp.Width:=FPictureOriginal.Graphic.Width;
      bmp.Height:=FPictureOriginal.Graphic.Height;
      bmp.Canvas.Draw(0,0,FPictureOriginal.Graphic);
      FPictureOriginal.Assign(nil);
      FPicture.Assign(bmp);
      FPictureOriginal.Assign(FPicture);
    finally
      FPictureOriginalChangedONprocess:=false;
      bmp.Free;
    end;
    if FNoise<>nil then FNoise.Free;
    FNoise:=nil;
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
    UpdateEffects;
  end;
end;

function Min(a, b: integer): integer;
begin
  if a < b then result := a
  else result := b;
end;

function Max(a, b: integer): integer;
begin
  if a > b then result := a
  else result := b;
end;

function IntToByte(i:Integer):Byte;
begin
  if      i>255 then Result:=255
  else if i<0   then Result:=0
  else               Result:=i;
end;

procedure TMImage.UpdateEffects;
var i, j, isl: Integer;
    OrigRow, DestRow, NoiseRow: pRGBArray;
    Gray: Integer;
    RO, GO, BO: Integer;
    R,  G,  B : Integer;
    RD, GD, BD: Integer;
    cr, cg, cb: Integer;
    dr, dg, db: Integer;
    lr, lg, lb: Integer;
    nr, ng, nb: Integer;
    BmpOriginal: TBitmap;
begin
 if (FPictureOriginal.Graphic<>nil)and(FPicture.Graphic<>nil) then
 if (FPictureOriginal.Graphic is TBitmap)and(FPicture.Graphic is TBitmap) then
 begin

  // Create FNoise Bitmap, if need
  if (FColorNoise>0)and(FNoise=nil)then SetColorNoise(FColorNoise);
  if (FMonoNoise>0)and(FNoise=nil)then SetMonoNoise(FMonoNoise);

  // Set BmpOriginal to Emboss or Mosaic or SplitBlur or GaussianBlur or FAntiAlias or Trace or Tile
  if FEmboss then
  begin
    if FEffectBMP=nil then SetEmboss(FEmboss); // Create FEffectBMP Bitmap, if need
    BmpOriginal:=FEffectBMP;
  end else if FMosaic>0 then
  begin
    if FEffectBMP=nil then SetMosaic(FMosaic); // Create FEffectBMP Bitmap, if need
    BmpOriginal:=FEffectBMP;
  end else if FSplitBlur>0 then
  begin
    if FEffectBMP=nil then SetSplitBlur(FSplitBlur); // Create FEffectBMP Bitmap, if need
    BmpOriginal:=FEffectBMP;
  end else if FGaussianBlur>0 then
  begin
    if FEffectBMP=nil then SetGaussianBlur(FGaussianBlur); // Create FEffectBMP Bitmap, if need
    BmpOriginal:=FEffectBMP;
  end else if FAntiAlias>0 then
  begin
    if FEffectBMP=nil then SetAntiAlias(FAntiAlias); // Create FEffectBMP Bitmap, if need
    BmpOriginal:=FEffectBMP;
  end else if FTrace>0 then
  begin
    if FEffectBMP=nil then SetTrace(FTrace); // Create FEffectBMP Bitmap, if need
    BmpOriginal:=FEffectBMP;
  end else if FTile>0 then
  begin
    if FEffectBMP=nil then SetTile(FTile); // Create FEffectBMP Bitmap, if need
    BmpOriginal:=FEffectBMP;
  end else
    BmpOriginal:=FPictureOriginal.Bitmap; // No transform effects selected

  // for each row of pixels
  for i := 0 to BmpOriginal.Height - 1 do
  begin
    OrigRow := BmpOriginal.ScanLine[i];
    DestRow := FPicture.Bitmap.ScanLine[i];
    if FNoise<>nil then NoiseRow :=FNoise.ScanLine[i]
    else NoiseRow:=OrigRow;

      // for each pixel in row
    for j := 0 to BmpOriginal.Width - 1 do
    begin

      RO:=OrigRow[j].rgbtRed;
      GO:=OrigRow[j].rgbtGreen;
      BO:=OrigRow[j].rgbtBlue;

      //Calculate Posterize or Solorize
      if FPosterize<>0 then
      begin
        RO:=round(RO/FPosterize)*FPosterize;
        GO:=round(GO/FPosterize)*FPosterize;
        BO:=round(BO/FPosterize)*FPosterize;
      end else if FSolorize<>0 then
      begin
        Gray:=(RO+GO+BO) div 3;
        if Gray > 255-FSolorize then
        begin
          RO:=255-RO;
          GO:=255-GO;
          BO:=255-BO;
        end;
      end;


      //Read Color or Mono Noise from FNoise Bitmap
      if FNoise<>nil then
      begin
        nr:=NoiseRow[j].rgbtRed;
        ng:=NoiseRow[j].rgbtGreen;
        nb:=NoiseRow[j].rgbtBlue;
      end else
      begin
        nr:=0;
        ng:=0;
        nb:=0;
      end;

      //Calculate Contrast
      if FContrast<>0 then
      begin
       cr:=(Abs(127-RO)*FContrast)div 255;
       cg:=(Abs(127-GO)*FContrast)div 255;
       cb:=(Abs(127-BO)*FContrast)div 255;
       if RO > 127 then cr:=cr else cr:=-cr;
       if GO > 127 then cg:=cg else cg:=-cg;
       if BO > 127 then cb:=cb else cb:=-cb;
      end else
      begin
        cr:=0;
        cg:=0;
        cb:=0;
      end;

      //Calculete Lightness
      if FLightness<>0 then
      begin
        lr:=((255-RO)*FLightness)div 255;
        lg:=((255-GO)*FLightness)div 255;
        lb:=((255-BO)*FLightness)div 255;
      end else
      begin
        lr:=0;
        lg:=0;
        lb:=0;
      end;

      //Calculete Darkness
      if FDarkness<>0 then
      begin
        dr:=-(RO*FDarkness)div 255;
        dg:=-(GO*FDarkness)div 255;
        db:=-(BO*FDarkness)div 255;
      end else
      begin
        dr:=0;
        dg:=0;
        db:=0;
      end;

      //Summary: Color or Mono Noise + Contrast + Lightness + Darkness + Brightness
      R:=IntToByte(RO+nr+cr+lr+dr+FBrightness);
      G:=IntToByte(GO+ng+cg+lg+dg+FBrightness);
      B:=IntToByte(BO+nb+cb+lb+db+FBrightness);

      //Calculete Splitlight
      for isl:=1 to FSplitlight do
      begin
        R:=variant(sin(R/255*pi/2)*255);
        G:=variant(sin(G/255*pi/2)*255);
        B:=variant(sin(B/255*pi/2)*255);
      end;

      //Calculete color saturation
      if FGrayScale then
      begin //Set only gray colors
        Gray:=Round(R * 0.3 + G * 0.59 + B * 0.11);
        RD := Gray;
        GD := Gray;
        BD := Gray;
      end else
      begin // All colors
        if FSaturation=0 then
        begin //Dont change Saturation
          RD := R;
          GD := G;
          BD := B;
        end else
        begin //Calculete Saturation
          Gray:=(R+G+B)div 3;
          RD := IntToByte(Gray+(((R-Gray)*(FSaturation+255))div 255));
          GD := IntToByte(Gray+(((G-Gray)*(FSaturation+255))div 255));
          BD := IntToByte(Gray+(((B-Gray)*(FSaturation+255))div 255));
        end;
      end;

      //Calculete Invert and all effects set to desrenation bitmap
      if FInvert then
      begin
        DestRow[j].rgbtRed   := not RD;
        DestRow[j].rgbtGreen := not GD;
        DestRow[j].rgbtBlue  := not BD;
      end else
      begin
        DestRow[j].rgbtRed   := RD;
        DestRow[j].rgbtGreen := GD;
        DestRow[j].rgbtBlue  := BD;
      end;
    end;
  end;
  Repaint;
 end;
end;

procedure TMImage.SetBrightness(Value: Integer);
begin
  if value < MINBrightness then FBrightness:=MINBrightness
  else if value > MAXBrightness then FBrightness:=MAXBrightness
  else FBrightness:=value;
  UpdateEffects;
end;

procedure TMImage.SetContrast(Value: Integer);
begin
  if value < MINContrast then FContrast:=MINContrast
  else FContrast:=value;
  UpdateEffects;
end;

procedure TMImage.SetGrayScale(Value: Boolean);
begin
  FGrayScale:=value;
  UpdateEffects;
end;

procedure TMImage.SetLightness(Value: Integer);
begin
  if value > MAXLightness then FLightness:=MAXLightness
  else FLightness:=value;
  UpdateEffects;
end;

procedure TMImage.SetDarkness(Value: Integer);
begin
  if value > MAXDarkness then FDarkness:=MAXDarkness
  else FDarkness:=value;
  UpdateEffects;
end;

procedure TMImage.SetSaturation(Value: Integer);
begin
  if value < MINSaturation then FSaturation:=MINSaturation
  else FSaturation:=value;
  UpdateEffects;
end;

procedure TMImage.SetSplitlight(Value: Integer);
begin
  if Value < 0 then FSplitlight:=0
  else if Value > MAXSplitlight then FSplitlight:=MAXSplitlight
  else FSplitlight:=value;
  UpdateEffects;
end;

procedure TMImage.SetInvert(Value: Boolean);
begin
  FInvert:=value;
  UpdateEffects;
end;

procedure TMImage.SetPosterize(Value: Integer);
begin
  if Value < 0 then FPosterize:=0
  else FPosterize:=value;
  FSolorize:=0;
  UpdateEffects;
end;

procedure TMImage.SetSolorize(Value: Integer);
begin
  if Value < 0 then FSolorize:=0
  else if Value > MAXSolorize then FSolorize:=MAXSolorize
  else FSolorize:=value;
  FPosterize:=0;
  UpdateEffects;
end;

procedure _Emboss(var Bm: TBitmap);
Var
  i,j: Integer;
  Row1,Row2: pRGBArray;
begin
  for i:=0 to Bm.Height-2 do
  begin
    Row1:=Bm.scanline[i];
    Row2:=Bm.scanline[i+1];
    for j:=0 to Bm.Width-4 do
    begin
      Row1[j].rgbtRed   :=(Row1[j].rgbtRed   +(Row2[j+3].rgbtRed   xor $FF))shr 1;
      Row1[j].rgbtGreen :=(Row1[j].rgbtGreen +(Row2[j+3].rgbtGreen xor $FF))shr 1;
      Row1[j].rgbtBlue  :=(Row1[j].rgbtBlue  +(Row2[j+3].rgbtBlue  xor $FF))shr 1;
    end;
    for j:=Bm.Width-3 to Bm.Width-1 do
    begin
      Row1[j].rgbtRed   :=(Row1[j].rgbtRed   +(Row2[j].rgbtRed   xor $FF))shr 1;
      Row1[j].rgbtGreen :=(Row1[j].rgbtGreen +(Row2[j].rgbtGreen xor $FF))shr 1;
      Row1[j].rgbtBlue  :=(Row1[j].rgbtBlue  +(Row2[j].rgbtBlue  xor $FF))shr 1;
    end;
  end;
  Row1:=Bm.scanline[Bm.Height-1];
  Row2:=Bm.scanline[Bm.Height-2];
  for j:=0 to Bm.Width-4 do
  begin
    Row1[j].rgbtRed   :=(Row1[j].rgbtRed   +(Row2[j+3].rgbtRed   xor $FF))shr 1;
    Row1[j].rgbtGreen :=(Row1[j].rgbtGreen +(Row2[j+3].rgbtGreen xor $FF))shr 1;
    Row1[j].rgbtBlue  :=(Row1[j].rgbtBlue  +(Row2[j+3].rgbtBlue  xor $FF))shr 1;
  end;
  for j:=Bm.Width-3 to Bm.Width-1 do
  begin
    Row1[j].rgbtRed   :=(Row1[j].rgbtRed   +(Row2[j].rgbtRed   xor $FF))shr 1;
    Row1[j].rgbtGreen :=(Row1[j].rgbtGreen +(Row2[j].rgbtGreen xor $FF))shr 1;
    Row1[j].rgbtBlue  :=(Row1[j].rgbtBlue  +(Row2[j].rgbtBlue  xor $FF))shr 1;
  end;
end;

procedure TMImage.SetEmboss(Value: Boolean);
begin
  FEmboss:=value;
  FMosaic:=0;
  FGaussianBlur:=0;
  FSplitBlur:=0;
  FAntiAlias:=0;
  FTrace:=0;
  FTile:=0;
  if FEmboss and (FPictureOriginal.Graphic<>nil) then
  begin
    if FEffectBMP=nil then FEffectBMP:=TBitmap.Create;
    FEffectBMP.Assign(FPictureOriginal.Graphic);
    _Emboss(FEffectBMP);
  end else
  begin
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
  end;
  UpdateEffects;
end;

// deriving from TProEffectImage, written by Babak Sateli
procedure _Mosaic(var Bm: TBitmap; size: Integer);
var
   x,y,i,j:integer;
   p1,p2:pbytearray;
   r,g,b:byte;
begin
  y:=0;
  repeat
    p1:=bm.scanline[y];
    repeat
      j:=1;
      repeat
      p2:=bm.scanline[y];
      x:=0;
      repeat
        r:=p1[x*3];
        g:=p1[x*3+1];
        b:=p1[x*3+2];
        i:=1;
       repeat
       p2[x*3]:=r;
       p2[x*3+1]:=g;
       p2[x*3+2]:=b;
       inc(x);
       inc(i);
       until (x>=bm.width) or (i>size);
      until x>=bm.width;
      inc(j);
      inc(y);
      until (y>=bm.height) or (j>size);
    until (y>=bm.height) or (x>=bm.width);
  until y>=bm.height;
end;

procedure TMImage.SetMosaic(Value: Integer);
begin
  if Value < 0 then FMosaic:=0
  else begin
    FMosaic:=value;
    if (FPictureOriginal.Graphic<>nil)then
      FMosaic:=Min(FMosaic,Max(FPictureOriginal.Graphic.Height,FPictureOriginal.Graphic.Width));
  end;
  FEmboss:=false;
  FGaussianBlur:=0;
  FSplitBlur:=0;
  FAntiAlias:=0;
  FTrace:=0;
  FTile:=0;
  if (FMosaic>0) and (FPictureOriginal.Graphic<>nil) then
  begin
    if FEffectBMP=nil then FEffectBMP:=TBitmap.Create;
    FEffectBMP.Assign(FPictureOriginal.Graphic);
    _Mosaic(FEffectBMP,FMosaic);
  end else
  begin
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
  end;
  UpdateEffects;
end;

// deriving from TProEffectImage, written by Babak Sateli
procedure _SplitBlur(var clip: tbitmap; Amount: integer);
var
p0,p1,p2:pbytearray;
cx,x,y: Integer;
Buf:   array[0..3,0..2]of byte;
begin
  if Amount=0 then Exit;
  for y:=0 to clip.Height-1 do
  begin
    p0:=clip.scanline[y];
    if y-Amount<0         then p1:=clip.scanline[y]
    else {y-Amount>0}          p1:=clip.ScanLine[y-Amount];
    if y+Amount<clip.Height    then p2:=clip.ScanLine[y+Amount]
    else {y+Amount>=Height}    p2:=clip.ScanLine[clip.Height-y];

    for x:=0 to clip.Width-1 do
    begin
      if x-Amount<0     then cx:=x
      else {x-Amount>0}      cx:=x-Amount;
      Buf[0,0]:=p1[cx*3];
      Buf[0,1]:=p1[cx*3+1];
      Buf[0,2]:=p1[cx*3+2];
      Buf[1,0]:=p2[cx*3];
      Buf[1,1]:=p2[cx*3+1];
      Buf[1,2]:=p2[cx*3+2];
      if x+Amount<clip.Width     then cx:=x+Amount
      else {x+Amount>=Width}     cx:=clip.Width-x;
      Buf[2,0]:=p1[cx*3];
      Buf[2,1]:=p1[cx*3+1];
      Buf[2,2]:=p1[cx*3+2];
      Buf[3,0]:=p2[cx*3];
      Buf[3,1]:=p2[cx*3+1];
      Buf[3,2]:=p2[cx*3+2];
      p0[x*3]:=(Buf[0,0]+Buf[1,0]+Buf[2,0]+Buf[3,0])shr 2;
      p0[x*3+1]:=(Buf[0,1]+Buf[1,1]+Buf[2,1]+Buf[3,1])shr 2;
      p0[x*3+2]:=(Buf[0,2]+Buf[1,2]+Buf[2,2]+Buf[3,2])shr 2;
    end;
  end;
end;

procedure TMImage.SetSplitBlur(Value: Integer);
begin
  if Value < 0 then FSplitBlur:=0
  else if Value > MAXSplitBlur then FSplitBlur:=MAXSplitBlur
  else FSplitBlur:=value;

  FEmboss:=false;
  FGaussianBlur:=0;
  FMosaic:=0;
  FAntiAlias:=0;
  FTrace:=0;
  FTile:=0;
  if (FSplitBlur>0) and (FPictureOriginal.Graphic<>nil) then
  begin
    if FEffectBMP=nil then FEffectBMP:=TBitmap.Create;
    FEffectBMP.Assign(FPictureOriginal.Graphic);
    _SplitBlur(FEffectBMP,FSplitBlur);
  end else
  begin
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
  end;
  UpdateEffects;
end;

procedure TMImage.SetGaussianBlur(Value: Integer);
var
  i: Integer;
begin
  if Value < 0 then FGaussianBlur:=0
  else if Value > MAXGaussianBlur then FGaussianBlur:=MAXGaussianBlur
  else FGaussianBlur:=value;

  FMosaic:=0;
  FEmboss:=false;
  FSplitBlur:=0;
  FAntiAlias:=0;
  FTrace:=0;
  FTile:=0;
  if (FGaussianBlur>0) and (FPictureOriginal.Graphic<>nil) then
  begin
    if FEffectBMP=nil then FEffectBMP:=TBitmap.Create;
    FEffectBMP.Assign(FPictureOriginal.Graphic);
    for i:=FGaussianBlur downto 0 do _SplitBlur(FEffectBMP,3);
 end else
  begin
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
  end;
  UpdateEffects;
end;

// deriving from TProEffectImage, written by Babak Sateli
procedure _AntiAliasRect(clip: tbitmap; XOrigin, YOrigin,
  XFinal, YFinal: Integer);
var Memo,x,y: Integer; (* Composantes primaires des points environnants *)
    p0,p1,p2:pbytearray;

begin
   if XFinal<XOrigin then begin Memo:=XOrigin; XOrigin:=XFinal; XFinal:=Memo; end;  (* Inversion des valeurs   *)
   if YFinal<YOrigin then begin Memo:=YOrigin; YOrigin:=YFinal; YFinal:=Memo; end;  (* si diff‚rence n‚gative*)
   XOrigin:=max(1,XOrigin);
   YOrigin:=max(1,YOrigin);
   XFinal:=min(clip.width-2,XFinal);
   YFinal:=min(clip.height-2,YFinal);
   clip.PixelFormat :=pf24bit;
   for y:=YOrigin to YFinal do begin
    p0:=clip.ScanLine [y-1];
    p1:=clip.scanline [y];
    p2:=clip.ScanLine [y+1];
    for x:=XOrigin to XFinal do begin
      p1[x*3]:=(p0[x*3]+p2[x*3]+p1[(x-1)*3]+p1[(x+1)*3])div 4;
      p1[x*3+1]:=(p0[x*3+1]+p2[x*3+1]+p1[(x-1)*3+1]+p1[(x+1)*3+1])div 4;
      p1[x*3+2]:=(p0[x*3+2]+p2[x*3+2]+p1[(x-1)*3+2]+p1[(x+1)*3+2])div 4;
      end;
   end;
end;

procedure TMImage.SetAntiAlias(Value: Integer);
var
  i: Integer;
begin
  if Value < 0 then FAntiAlias:=0
  else if Value > MAXAntiAlias then FAntiAlias:=MAXAntiAlias
  else FAntiAlias:=value;

  FGaussianBlur:=0;
  FMosaic:=0;
  FEmboss:=false;
  FSplitBlur:=0;
  FTrace:=0;
  FTile:=0;
  if (FAntiAlias>0) and (FPictureOriginal.Graphic<>nil) then
  begin
    if FEffectBMP=nil then FEffectBMP:=TBitmap.Create;
    FEffectBMP.Assign(FPictureOriginal.Graphic);
    for i:=1 to FAntiAlias do
      _AntiAliasRect(FEffectBMP,0,0,FEffectBMP.width,FEffectBMP.height);
 end else
  begin
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
  end;
  UpdateEffects;
end;

// deriving from TProEffectImage, written by Babak Sateli
procedure _Trace (src:Tbitmap;intensity:integer);
var
  x,y,i : integer;
  P1,P2,P3,P4 : PByteArray;
  tb,TraceB:byte;
  hasb:boolean;
  bitmap:tbitmap;
begin
  bitmap:=tbitmap.create;
  bitmap.width:=src.width;
  bitmap.height:=src.height;
  bitmap.canvas.draw(0,0,src);
  bitmap.PixelFormat :=pf8bit;
  src.PixelFormat :=pf24bit;
  hasb:=false;
  TraceB:=$00;
  tb:=0;
  for i:=1 to Intensity do begin
    for y := 0 to BitMap.height -2 do begin
      P1 := BitMap.ScanLine[y];
      P2 := BitMap.scanline[y+1];
      P3 := src.scanline[y];
      P4 := src.scanline[y+1];
      x:=0;
      repeat
        if p1[x]<>p1[x+1] then begin
           if not hasb then begin
             tb:=p1[x+1];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p3[(x+1)*3]:=TraceB;
                 p3[(x+1)*3+1]:=TraceB;
                 p3[(x+1)*3+1]:=TraceB;
                 end;
             end;
           end;
        if p1[x]<>p2[x] then begin
           if not hasb then begin
             tb:=p2[x];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p4[x*3]:=TraceB;
                 p4[x*3+1]:=TraceB;
                 p4[x*3+2]:=TraceB;
                 end;
             end;
           end;
      inc(x);
      until x>=(BitMap.width -2);
    end;
    if i>1 then
    for y := BitMap.height -1 downto 1 do begin
      P1 := BitMap.ScanLine[y];
      P2 := BitMap.scanline[y-1];
      P3 := src.scanline[y];
      P4 := src.scanline [y-1];
      x:=Bitmap.width-1;
      repeat
        if p1[x]<>p1[x-1] then begin
           if not hasb then begin
             tb:=p1[x-1];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p3[(x-1)*3]:=TraceB;
                 p3[(x-1)*3+1]:=TraceB;
                 p3[(x-1)*3+2]:=TraceB;
                 end;
             end;
           end;
        if p1[x]<>p2[x] then begin
           if not hasb then begin
             tb:=p2[x];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p4[x*3]:=TraceB;
                 p4[x*3+1]:=TraceB;
                 p4[x*3+2]:=TraceB;
                 end;
             end;
           end;
      dec(x);
      until x<=1;
    end;
  end;
bitmap.free;
end;

procedure TMImage.SetTrace(Value: Integer);
begin
  if Value < 0 then FTrace:=0
  else if Value > MAXTrace then FTrace:=MAXTrace
  else FTrace:=value;

  FAntiAlias:=0;
  FGaussianBlur:=0;
  FMosaic:=0;
  FEmboss:=false;
  FSplitBlur:=0;
  FTile:=0;
  if (FTrace>0) and (FPictureOriginal.Graphic<>nil) then
  begin
    if FEffectBMP=nil then FEffectBMP:=TBitmap.Create;
    FEffectBMP.Assign(FPictureOriginal.Graphic);
    _Trace (FEffectBMP,FTrace);
 end else
  begin
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
  end;
  UpdateEffects;
end;

// deriving from TProEffectImage, written by Babak Sateli
procedure _SmoothResize(const Src: TBitmap; var Dst: TBitmap);
var
x,y,xP,yP,
yP2,xP2:     Integer;
Read,Read2:  PByteArray;
t,z,z2,iz2:  Integer;
pc:PBytearray;
w1,w2,w3,w4: Integer;
Col1r,col1g,col1b,Col2r,col2g,col2b:   byte;
begin
  xP2:=((src.Width-1)shl 15)div Dst.Width;
  yP2:=((src.Height-1)shl 15)div Dst.Height;
  yP:=0;
  for y:=0 to Dst.Height-1 do
  begin
    xP:=0;
    Read:=src.ScanLine[yP shr 15];
    if yP shr 16<src.Height-1 then
      Read2:=src.ScanLine [yP shr 15+1]
    else
      Read2:=src.ScanLine [yP shr 15];
    pc:=Dst.scanline[y];
    z2:=yP and $7FFF;
    iz2:=$8000-z2;
    for x:=0 to Dst.Width-1 do
    begin
      t:=xP shr 15;
      Col1r:=Read[t*3];
      Col1g:=Read[t*3+1];
      Col1b:=Read[t*3+2];
      Col2r:=Read2[t*3];
      Col2g:=Read2[t*3+1];
      Col2b:=Read2[t*3+2];
      z:=xP and $7FFF;
      w2:=(z*iz2)shr 15;
      w1:=iz2-w2;
      w4:=(z*z2)shr 15;
      w3:=z2-w4;
      pc[x*3+2]:=
        (Col1b*w1+Read[(t+1)*3+2]*w2+
         Col2b*w3+Read2[(t+1)*3+2]*w4)shr 15;
      pc[x*3+1]:=
        (Col1g*w1+Read[(t+1)*3+1]*w2+
         Col2g*w3+Read2[(t+1)*3+1]*w4)shr 15;
      pc[x*3]:=
        (Col1r*w1+Read2[(t+1)*3]*w2+
         Col2r*w3+Read2[(t+1)*3]*w4)shr 15;
      Inc(xP,xP2);
    end;
    Inc(yP,yP2);
  end;
end;

procedure TMImage.SetTile(Value: Integer);
Var
  i,j,h,w: Integer;
  Bmp: TBitmap;
begin
  h:=MIN_TileSize;
  w:=MIN_TileSize;
  if value <=0 then FTile:=0
  else begin
    FTile:=value;
    if (FPictureOriginal.Graphic<>nil) then
    begin
      h:=Max(MIN_TileSize,FPictureOriginal.Graphic.Height div FTile);
      w:=Max(MIN_TileSize,FPictureOriginal.Graphic.Width div FTile);
      if (h=MIN_TileSize)and(w=MIN_TileSize)then
        FTile:=Max(FPictureOriginal.Graphic.Height,FPictureOriginal.Graphic.Width) div MIN_TileSize;
    end;
  end;

  FTrace:=0;
  FAntiAlias:=0;
  FGaussianBlur:=0;
  FMosaic:=0;
  FEmboss:=false;
  FSplitBlur:=0;
  if (FTile>0) and (FPictureOriginal.Graphic<>nil) then
  begin
    if FEffectBMP=nil then FEffectBMP:=TBitmap.Create;
    FEffectBMP.Assign(FPictureOriginal.Graphic);

    Bmp:=TBitmap.Create;
    Bmp.Width:=w;
    Bmp.Height:=h;
    Bmp.PixelFormat :=pf24bit;
    _smoothresize(FPictureOriginal.Bitmap,Bmp);
    j:=0;
    while j*h <= FPictureOriginal.Graphic.Height do
    begin
      i:=0;
      while i*w <= FPictureOriginal.Graphic.Width do
      begin
        FEffectBMP.Canvas.Draw (i*w,j*h,Bmp);
        inc(i);
      end;
      inc(j);
    end;
    Bmp.Free;
 end else
  begin
    if FEffectBMP<>nil then FEffectBMP.Free;
    FEffectBMP:=nil;
  end;
  UpdateEffects;
end;

procedure TMImage.SetColorNoise(Value: Integer);
Var
  i,j: Integer;
  Row: pRGBArray;
begin
  if Value < 0 then FColorNoise:=0
  else FColorNoise:=value;

  FMonoNoise:=0;
  if (FColorNoise>0) and (FPictureOriginal.Graphic<>nil) then
  begin
    if FNoise=nil then FNoise:=TBitmap.Create;
    FNoise.PixelFormat := pf24bit;
    FNoise.Width:=FPictureOriginal.Graphic.Width;
    FNoise.Height:=FPictureOriginal.Graphic.Height;
    // for each row of pixels
    for i := 0 to FNoise.Height - 1 do
    begin
      Row := FNoise.ScanLine[i];
      // for each pixel in row
      for j := 0 to FNoise.Width - 1 do
      begin
        Row[j].rgbtRed   :=IntToByte(Random(FColorNoise)-(FColorNoise shr 1));
        Row[j].rgbtGreen :=IntToByte(Random(FColorNoise)-(FColorNoise shr 1));
        Row[j].rgbtBlue  :=IntToByte(Random(FColorNoise)-(FColorNoise shr 1));
      end;
    end;
  end else begin
    if FNoise<>nil then FNoise.Free;
    FNoise:=nil;
  end;
  UpdateEffects;
end;

procedure TMImage.SetMonoNoise(Value: Integer);
Var
  i,j: Integer;
  Row: pRGBArray;
begin
  if value < 0 then FMonoNoise:=0
  else FMonoNoise:=value;

  FColorNoise:=0;
  if (FMonoNoise>0)and(FPictureOriginal.Graphic<>nil) then
  begin
    if FNoise=nil then FNoise:=TBitmap.Create;
    FNoise.PixelFormat := pf24bit;
    FNoise.Width:=FPictureOriginal.Graphic.Width;
    FNoise.Height:=FPictureOriginal.Graphic.Height;
    // for each row of pixels
    for i := 0 to FNoise.Height - 1 do
    begin
      Row := FNoise.ScanLine[i];
      // for each pixel in row
      for j := 0 to FNoise.Width - 1 do
      begin
        Row[j].rgbtRed   :=IntToByte(Random(FMonoNoise)-(FMonoNoise shr 1));
        Row[j].rgbtGreen :=Row[j].rgbtRed;
        Row[j].rgbtBlue  :=Row[j].rgbtRed;
      end;
    end;
  end else begin
    if FNoise<>nil then FNoise.Free;
    FNoise:=nil;
  end;
  UpdateEffects;
end;

procedure TMImage.SetProportional(Value: boolean);
begin
  if FProportional <> Value then
  begin
    FProportional := Value;
    PictureChanged(Self);
  end;
end;

procedure TMImage.PictureChanged(Sender: TObject);
var
  G: TGraphic;
begin
  if AutoSize and (Picture.Width > 0) and (Picture.Height > 0) then
    SetBounds(Left, Top, Picture.Width, Picture.Height);
  G := Picture.Graphic;
  if G <> nil then
  begin
    if not ((G is TMetaFile) or (G is TIcon)) then
      G.Transparent := FTransparent;
    if (not G.Transparent) and Stretch and not Proportional then
      ControlStyle := ControlStyle + [csOpaque]
    else  // picture might not cover entire clientrect
      ControlStyle := ControlStyle - [csOpaque];
    if DoPaletteChange and FDrawing then
      Update;
  end
  else ControlStyle := ControlStyle - [csOpaque];
  if not FDrawing then Invalidate;
end;

function TMImage.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if not (csDesigning in ComponentState) or (Picture.Width > 0) and
    (Picture.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      NewWidth := Picture.Width;
    if Align in [alNone, alTop, alBottom] then
      NewHeight := Picture.Height;
  end;
end;

procedure TMImage.CMMouseLeave(var Message: TMessage);
begin
  FIsMouseEntering:=false;
  if assigned(FOnMouseExit) then FOnMouseExit(Self);
end;

procedure TMImage.CMMouseEnter(var Message: TMessage);
begin
  FIsMouseEntering:=true;
  if assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TMImage.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  FIsMouseEntering:=true;
  inherited;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TMImage]);
end;
end.
