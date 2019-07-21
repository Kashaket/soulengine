unit _dshkdctrls;

interface

uses System.Classes, Forms, System.SysUtils, WinAPI.ShellScaling,
WinAPI.Messages, System.UITypes, VCL.Graphics, Winapi.UXTheme,
WinAPI.Windows, WinAPI.MultiMon, WinApi.DWMAPI, System.Types, Controls;

type
  TChassFrame = class;
  TCustomDSControl = class(TCustomControl)
  private
    FGlassFrame: TChassFrame;
    FTransparentColor: Boolean;
    FTransparentColorValue: TColor;
    FAlphaBlend: Boolean;
    FDesigner: IDesignerHook;
    FScreenSnap: Boolean;
    FSnapBuffer: Integer;
    FAlphaBlendValue: Byte;
    FRefreshGlassFrame: Boolean;
    function GetMonitor: TMonitor;
    procedure SetLayeredAttribs;
    procedure SetTransparentColor(const Value: Boolean);
    procedure SetTransparentColorValue(const Value: TColor);
    procedure SetAlphaBlend(const Value: Boolean);
    procedure SetAlphaBlendValue(const Value: Byte);
    procedure SetCanvas(const Value: TCanvas); overload;
    procedure SetCanvas(const Value: TControlCanvas); overload;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  protected
    FCanvas: TControlCanvas;
    procedure UpdateGlassFrame(Sender: TObject);
    procedure UpdateGlassFrameControls(const Rect: TRect);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintWindow(DC:HDC);
    property Canvas: TControlCanvas read FCanvas write SetCanvas;
  published

    property AlphaBlend: Boolean read FAlphaBlend write SetAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write SetAlphaBlendValue;
    property ScreenSnap: Boolean read FScreenSnap write FScreenSnap default False;
    property SnapBuffer: Integer read FSnapBuffer write FSnapBuffer default 10;
    property Monitor: TMonitor read GetMonitor;
    property TransparentColor: Boolean read FTransparentColor write SetTransparentColor;
    property TransparentColorValue: TColor read FTransparentColorValue write SetTransparentColorValue;
  end;
  TChassFrame = class(TPersistent)
  private
    FClient: TCustomDSControl;
    FEnabled: Boolean;
    FLeft: Integer;
    FTop: Integer;
    FRight: Integer;
    FBottom: Integer;
    FOnChange: TNotifyEvent;
    FSheetOfGlass: Boolean;
    procedure SetEnabled(Value: Boolean);
    procedure SetExtendedFrame(Index: Integer; Value: Integer);
    procedure SetSheetOfGlass(Value: Boolean);
  protected
    procedure Change; virtual;
  public
    constructor Create(Client: TCustomDSControl);
    procedure Assign(Source: TPersistent); override;
    function FrameExtended: Boolean;
    function IntersectsControl(Control: TControl): Boolean;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Left: Integer index 0 read FLeft write SetExtendedFrame default 0;
    property Top: Integer index 1 read FTop write SetExtendedFrame default 0;
    property Right: Integer index 2 read FRight write SetExtendedFrame default 0;
    property Bottom: Integer index 3 read FBottom write SetExtendedFrame default 0;
    property SheetOfGlass: Boolean read FSheetOfGlass write SetSheetOfGlass default False;
  end;

implementation
function ContainsRect(const OuterRect, InnerRect: TRect): Boolean; inline;
begin
  with InnerRect do
    Result := (Left >= OuterRect.Left) and (Right <= OuterRect.Right) and
              (Top >= OuterRect.Top) and (Bottom <= OuterRect.Bottom);
end;

{ TCustomDSControl }
procedure TCustomDSControl.UpdateGlassFrameControls(const Rect: TRect);

  procedure DoUpdateControls(AControl: TWinControl);
  var
    I: Integer;
    LRect: TRect;
    LControl: TControl;
  begin
    for I := 0 to AControl.ControlCount - 1 do
    begin
      LControl := AControl.Controls[I];
      if not FGlassFrame.SheetOfGlass then
      begin
        LRect := LControl.ClientRect;
        LRect.TopLeft := LControl.ClientToParent(LRect.TopLeft, Self);
        LRect.BottomRight := LControl.ClientToParent(LRect.BottomRight, Self);
      end;

      if FGlassFrame.SheetOfGlass or not ContainsRect(Rect, LRect) then
      begin
        if not (csGlassPaint in LControl.ControlState) then
          LControl.ControlState := LControl.ControlState + [csGlassPaint];
      end
      else
        if (csGlassPaint in LControl.ControlState) then
          LControl.ControlState := LControl.ControlState - [csGlassPaint];

      if LControl is TWinControl then
        DoUpdateControls(TWinControl(LControl));
    end;
  end;

begin
  if not (csDesigning in ComponentState) and DwmCompositionEnabled then
    DoUpdateControls(Self);
end;
function TCustomDSControl.GetMonitor:TMonitor;
  var
  HM: HMonitor;
  I: Integer;
begin
  Result := nil;
  HM := MonitorFromWindow(Handle, MONITOR_DEFAULTTONEAREST);

{$IF DEFINED(CLR)}
  if HM = 0 then
    RaiseLastWin32Error;
{$ENDIF}
  for I := 0 to Screen.MonitorCount - 1 do
    if Screen.Monitors[I].Handle = HM then
    begin
      Result := Screen.Monitors[I];
      Exit;
    end;

  //if we get here, the Monitors array has changed, so we need to clear and reinitialize it
  Screen.Monitors[0];
  for I := 0 to Screen.MonitorCount - 1 do
    if Screen.Monitors[I].Handle = HM then
    begin
      Result := Screen.Monitors[I];
      Exit;
    end;
end;
procedure TCustomDSControl.SetLayeredAttribs;
const
  cUseAlpha: array [Boolean] of Integer = (0, LWA_ALPHA);
  cUseColorKey: array [Boolean] of Integer = (0, LWA_COLORKEY);
var
  AStyle: Integer;
begin
  if not (csDesigning in ComponentState) and
    (Assigned(@SetLayeredWindowAttributes)) and HandleAllocated then
  begin
    AStyle := GetWindowLong(Handle, GWL_EXSTYLE);
    if FAlphaBlend or FTransparentColor then
    begin
      if (AStyle and WS_EX_LAYERED) = 0 then
        SetWindowLong(Handle, GWL_EXSTYLE, AStyle or WS_EX_LAYERED);
      SetLayeredWindowAttributes(Handle, ColorToRGB(FTransparentColorValue), FAlphaBlendValue,
        cUseAlpha[FAlphaBlend] or cUseColorKey[FTransparentColor]);
    end
    else
    begin
      SetWindowLong(Handle, GWL_EXSTYLE, AStyle and not WS_EX_LAYERED);
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
    end;
  end;
end;
procedure TCustomDSControl.SetCanvas(const Value: TCanvas);
begin
  FCanvas.Assign(TControlCanvas(Value));
end;
procedure TCustomDSControl.SetCanvas(const Value: TControlCanvas);
begin
  FCanvas.Assign(Value);
end;
procedure TCustomDSControl.SetAlphaBlendValue(const Value: Byte);
begin
  if FAlphaBlendValue <> Value then
  begin
    FAlphaBlendValue := Value;
    SetLayeredAttribs;
  end;
end;
procedure TCustomDSControl.SetAlphaBlend(const Value: Boolean);
begin
  if FAlphaBlend <> Value then
  begin
    FAlphaBlend := Value;
    SetLayeredAttribs;
  end;
end;
procedure TCustomDSControl.SetTransparentColor(const Value: Boolean);
BEGIN
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    if FTransparentColor and FGlassFrame.Enabled then
      FGlassFrame.Enabled := False; // GlassFrame and TransparentColor are mutually exclusive
    SetLayeredAttribs;
  end;
END;

procedure TCustomDSControl.SetTransparentColorValue(const Value: TColor);
BEGIN
  if FTransparentColorValue <> Value then
  begin
    FTransparentColorValue := Value;
    SetLayeredAttribs;
  end;
END;

//-----------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
constructor TCustomDSControl.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self;
  FGlassFrame := TChassFrame.Create(Self);
  FGlassFrame.OnChange := UpdateGlassFrame;
  FRefreshGlassFrame := False;
  FloatingDockSiteClass := TWinControlClass(ClassType);
  FAlphaBlendValue := 255;
  FTransparentColorValue := 0;
  Visible := False;
  ParentColor := False;
  ParentFont := False;
  ParentDoubleBuffered := False;
end;
//------------------------------------------------------------------------------
destructor TCustomDSControl.Destroy;
begin
    FGlassFrame.Destroy;
    inherited;
end;
//------------------------------------------------------------------------------
//  Some very useful information
//------------------------------------------------------------------------------
procedure TCustomDSControl.UpdateGlassFrame(Sender: TObject);
  var
  LMargins: WinAPI.UXTheme.Margins;
begin
  if DwmCompositionEnabled and HandleAllocated then
  begin
    with LMargins, FGlassFrame do
    begin
      if Enabled then
      begin
        if not SheetOfGlass then
        begin
          cxLeftWidth := Left;
          cxRightWidth := Right;
          cyTopHeight := Top;
          cyBottomHeight := Bottom;
        end
        else
        begin
          cxLeftWidth := -1;
          cxRightWidth := -1;
          cyTopHeight := -1;
          cyBottomHeight := -1;
        end;
        if not (csDesigning in ComponentState) then
          ControlState := ControlState + [csGlassPaint];
      end
      else
      begin
        ControlState := ControlState - [csGlassPaint];
{$IF NOT DEFINED(CLR)}
        FillChar(LMargins, SizeOf(LMargins), 0);
{$ENDIF}
      end;
    end;
    if (csDesigning in ComponentState) then
      InvalidateRect(Handle, nil, True)
    else
    begin
      DwmExtendFrameIntoClientArea(Handle, LMargins);
      Invalidate;
    end;
  end
  else
  begin
    ControlState := ControlState - [csGlassPaint];
    if (csDesigning in ComponentState) then
      InvalidateRect(Handle, nil, True)
  end;
end;

procedure TCustomDSControl.WMWindowPosChanging(var Message: TWMWindowPosChanging);
const
  SWP_STATECHANGED = $8000;  // Undocumented

  procedure HandleEdge(var Edge: Integer; SnapToEdge: Integer;
    SnapDistance: Integer = 0);
  begin
    if (Abs(Edge + SnapDistance - SnapToEdge) < FSnapBuffer) then
      Edge := SnapToEdge - SnapDistance;
  end;

var
  DeltaY, DeltaX: Integer;
  LClientRect, RefreshRect, LRect: TRect;
{$IF DEFINED(CLR)}
  WindowPos: TWindowPos;
{$ELSE}
  WindowPos: PWindowPos;
{$ENDIF}
begin
  WindowPos := Message.WindowPos;
  if FScreenSnap and ((Parent = nil) or not (csDesigning in ComponentState)) and
    ((WindowPos.X <> 0) or (WindowPos.Y <> 0)) and
    ((WindowPos.cx = Width) and (WindowPos.cy = Height)) then
  begin
    LRect := Monitor.WorkareaRect;
    HandleEdge(WindowPos.x, LRect.Left, 0);
    HandleEdge(WindowPos.y, LRect.Top, 0);
    HandleEdge(WindowPos.x, LRect.Right, Width);
    HandleEdge(WindowPos.y, LRect.Bottom, Height);
{$IF DEFINED(CLR)}
    Message.WindowPos := WindowPos;
{$ENDIF}
  end;
  inherited;
  with FGlassFrame do
    if FrameExtended and not SheetOfGlass and (Visible or (csDesigning in ComponentState)) then
    begin
      if (WindowPos.cx <> 0) or (WindowPos.cy <> 0) then
      begin
        DeltaX := WindowPos.cx - Width;
        DeltaY := WindowPos.cy - Height;
        if (DeltaX <> 0) or (DeltaY <> 0) then
        begin
          LClientRect := ClientRect;
          RefreshRect := Rect(Left, Top, LClientRect.Right - Right, LClientRect.Bottom - Bottom);

          if (RefreshRect.Bottom <= Top) and (DeltaY > 0) then
          begin
            RefreshRect.Bottom := RefreshRect.Top - DeltaY;
            RefreshRect.Top := Bottom;
            FRefreshGlassFrame := True;
          end
          else
          begin
            if DeltaY > 0 then
              Inc(RefreshRect.Bottom, DeltaY);
            if RefreshRect.Bottom < RefreshRect.Top then
                RefreshRect.Bottom := RefreshRect.Top;
          end;

          if (RefreshRect.Right < Left) and (DeltaX > 0) then
          begin
            RefreshRect.Left := RefreshRect.Right - DeltaX;
            RefreshRect.Right := Left;
            FRefreshGlassFrame := True;
          end
          else
          begin
            if DeltaX > 0 then
              Inc(RefreshRect.Right, DeltaX);
            if RefreshRect.Right < RefreshRect.Left then
              RefreshRect.Right := RefreshRect.Left;
          end;

          InvalidateRect(Handle, RefreshRect, False);
        end;
      end;
    end;
end;


procedure TCustomDSControl.PaintWindow(DC: HDC);
var
  LClientRect: TRect;
  SaveIndex: Integer;
begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      SaveIndex := SaveDC(DC);
      try
        with FGlassFrame do
        begin
          if FrameExtended or ((FDesigner <> nil) and Enabled) then
          begin
            LClientRect := ClientRect;
            if not SheetOfGlass and not FRefreshGlassFrame then
              ExcludeClipRect(DC, Left, Top, LClientRect.Right - Right, LClientRect.Bottom - Bottom)
            else
              FRefreshGlassFrame := False;

            if FDesigner = nil then
              FillRect(FCanvas.Handle, LClientRect, GetStockObject(BLACK_BRUSH))
            else
            begin
              FCanvas.Brush.Color := clActiveCaption;
              FCanvas.Brush.Style := bsBDiagonal;
              SetBkColor(FCanvas.Handle, ColorToRGB(Color));
              FCanvas.FillRect(LClientRect);
            end;
          end;
        end;
      finally
        RestoreDC(DC, SaveIndex);
      end;
      if FDesigner <> nil then
        FDesigner.PaintGrid
      else
        Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;


{ TChassFrame }

constructor TChassFrame.Create(Client: TCustomDSControl);
begin
  inherited Create;
  FClient := Client;
  FLeft := 0;
  FTop := 0;
  FRight := 0;
  FBottom := 0;
  FSheetOfGlass := False;
end;

procedure TChassFrame.Assign(Source: TPersistent);
begin
  if Source is TChassFrame then
  begin
    FEnabled := TChassFrame(Source).Enabled;
    FLeft := TChassFrame(Source).Left;
    FTop := TChassFrame(Source).Top;
    FRight := TChassFrame(Source).Right;
    FBottom := TChassFrame(Source).Bottom;
    FSheetOfGlass := TChassFrame(Source).SheetOfGlass;
    Change;
  end else
    inherited Assign(Source);
end;

procedure TChassFrame.Change;
begin
  if not (csLoading in FClient.ComponentState) then
  begin
    if Assigned(FOnChange) then
      FOnChange(Self);
    FClient.UpdateGlassFrameControls(System.Types.Rect(Left, Top,
      FClient.ClientWidth - Right, FClient.ClientHeight - Bottom));
  end;
end;

function TChassFrame.FrameExtended: Boolean;
begin
  Result := FEnabled and DwmCompositionEnabled and
    (FSheetOfGlass or (Left <> 0) or (Top <> 0) or (Right <> 0) or (Bottom <> 0));
end;

function TChassFrame.IntersectsControl(Control: TControl): Boolean;
var
  ControlRect: TRect;
  NonGlassRect: TRect;
begin
  Result := False;
  if FEnabled and DwmCompositionEnabled then
  begin
    Result := FSheetOfGlass;
    if not Result then
    begin
      ControlRect := Control.ClientRect;
      ControlRect.TopLeft := Control.ClientToParent(ControlRect.TopLeft, FClient);
      ControlRect.BottomRight := Control.ClientToParent(ControlRect.BottomRight, FClient);
      NonGlassRect := FClient.ClientRect;
      NonGlassRect := Rect(FLeft, FTop, NonGlassRect.Right - FRight,
        NonGlassRect.Bottom - FBottom);
      Result := not (NonGlassRect.Contains(ControlRect.TopLeft) and
        NonGlassRect.Contains(ControlRect.BottomRight));
    end;
  end;
end;

procedure TChassFrame.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    if FEnabled and FClient.TransparentColor then
      FClient.TransparentColor := False;  // GlassFrame and TransparentColor are mutually exclusive
    Change;
  end;
end;

procedure TChassFrame.SetExtendedFrame(Index: Integer; Value: Integer);
begin
  case Index of
    0:
      if Value <> FLeft then
      begin
        FLeft := Value;
        if Value = -1 then
          FSheetOfGlass := True;
      end;
    1:
      if Value <> FTop then
      begin
        FTop := Value;
        if Value = -1 then
          FSheetOfGlass := True;
      end;
    2:
      if Value <> FRight then
      begin
        FRight := Value;
        if Value = -1 then
          FSheetOfGlass := True;
      end;
    3:
      if Value <> FBottom then
      begin
        FBottom := Value;
        if Value = -1 then
          FSheetOfGlass := True;
      end;
    else
      Exit;
  end;
  Change;
end;

procedure TChassFrame.SetSheetOfGlass(Value: Boolean);
begin
  if (Value <> FSheetOfGlass) and not
     (FSheetOfGlass and ((FLeft = -1) or (FTop = -1) or (FRight = -1) or (FBottom = -1))) then
  begin
    FSheetOfGlass := Value;
    Change;
  end;
end;

end.