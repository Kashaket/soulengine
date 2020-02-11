unit dsCustomControls;
{$S-,W-,R+,H+,X+}
interface

uses
  VCL.Dialogs,
  WinAPI.Windows, Forms, Messages, System.Classes, VCL.Controls, VCL.Graphics;

type
TPenSetEvent   = procedure(Sender:TObject; Value:TPen; var Co: boolean) of object;
TBrushSetEvent = procedure(Sender:TObject; Value:TBrush; var Co: boolean) of object;
TFontSetEvent  = procedure(Sender:TObject; Value:TFont; var Co: boolean) of object;
THitTestEvent  = procedure(Sender:TObject; var HitResult:integer) of object;
THackedWinControl = class(TWinControl)
  public
    procedure PaintControls(DC: HDC; First: TControl);
end;
TGraphControl = class( TCustomTransparentControl )
  private
    FFocused: boolean;
    FCreateNotFired: boolean;
    foc, fod, fop, fpc, fbc, ffc, fOnFocus, fOnBlur: TNotifyEvent;
    fps: TPenSetEvent;
    fbs: TBrushSetEvent;
    ffs: TFontSetEvent;
    fontps: THitTestEvent;
    function FBrush: TBrush;
    function FFont: TFont;
    function FPen: TPen;
  protected
    procedure SetBrush(ABrush:TBrush);
    procedure SetFont(AFont:TFont);
    procedure SetPen(APen:TPen);
    procedure ChangeBrush(Sender:TObject);
    procedure ChangeFont(Sender:TObject);
    procedure ChangePen(Sender:TObject);
    procedure SetOnCreate(A:TNotifyEvent);
    procedure Paint; override;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure setFocused(a:boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Anchors;
    property Align;
    property Canvas;
    procedure UnFocus;
    property Focused: boolean read FFocused write setFocused;
    procedure Repaint; override;
    procedure Invalidate; override;
    procedure Refresh; reintroduce;

    property Brush: TBrush read FBrush write SetBrush;
    property Pen: TPen read FPen write SetPen;
    property Font: TFont read FFont write SetFont;
    property OnBrushChange: TNotifyEvent read fbc write fbc;
    property OnBrushSet: TBrushSetEvent read fbs write fbs;
    property OnFontChange:TNotifyEvent read ffc write ffc;
    property OnFontSet:TFontSetEvent read ffs write ffs;
    property OnPenChange: TNotifyEvent read fpc write fpc;
    property OnPenSet: TPenSetEvent read fps write fps;

    property OnPaint: TNotifyEvent read fop write fop;
    property OnHitTest: THitTestEvent read fontps write fontps;
    property OnCreate: TNotifyEvent read foc write SetOnCreate;
    property OnDestroy: TNotifyEvent read fod write fod;

    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Constraints;
    property ShowHint;
    property ParentShowHint;
    property Touch;
    property Visible;
    property AutoSize;
    property OnCanResize;
    property OnConstrainedResize;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    {OnClick, OnDblClick, OnMouseActivate,
    OnMouseEnter ,OnMouseLeave, OnMouseMove,
    OnMouseDown, OnMouseUp, OnMouseWheel,
    OnGesture, OnDragOver,OnDragDrop,
    OnStartDrag, OnStartDock, OnEndDock,
    OnEndDrag, OnFocus, OnBlur}
    property OnClick;
    property OnDblClick;
    property OnKeyPress;
    property OnKeyUp;
    property OnKeyDown;
    property OnMouseActivate;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnGesture;
    property OnContextPopup;
    property OnStartDock;
    property OnStartDrag;
    property onFocus:TNotifyEvent read FOnFocus write FOnFocus;
    property onBlur:TNotifyEvent read FOnBlur write FOnBlur;
end;
implementation
procedure THackedWinControl.PaintControls(DC: HDC; First: TControl);
begin
  inherited PaintControls(DC, First);
end;
procedure TGraphControl.Repaint;
begin
  Invalidate;
  Update;
end;
procedure TGraphControl.Invalidate;
var DC: HDC;
begin
  if (Visible or (csDesigning in ComponentState) and
    not (csNoDesignVisible in ControlStyle)) and (Parent <> nil) and
    Parent.HandleAllocated then
    begin
      DC := GetDC(Parent.Handle);
      try
        IntersectClipRect(DC, Left, Top, Left + Width, Top + Height);
        THackedWinControl(Parent).PaintControls(DC, Self);
      finally
        ReleaseDC(Parent.Handle, DC);
      end;
    end;
end;
procedure TGraphControl.Refresh;
begin
  Repaint;
end;
procedure TGraphControl.setFocused(a: Boolean);
begin
  if FFocused = a then Exit;
  if a then
    SetFocus
  else
    UnFocus;
end;
procedure TGraphControl.UnFocus;
var
  Parent: TCustomForm;
begin
  Parent := GetParentForm(Self);
  if Parent <> nil then
  begin
    FFocused := False;
    Parent.DeFocusControl(Self,False);
  end
  else
    ValidParentForm(Self);
end;
constructor TGraphControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFocused := False;
  Canvas.Brush.Assign(inherited Brush);
  (inherited Brush).OnChange := ChangeBrush;
  Canvas.Brush.OnChange := ChangeBrush;
  (inherited Font).OnChange := ChangeFont;
  Canvas.Font.OnChange := ChangeFont;
  Canvas.Font.Assign(inherited Font);
  Canvas.Pen.OnChange := ChangePen;
  ControlStyle := ControlStyle + [csReplicatable];
  ParentDoubleBuffered := False;
  DoubleBuffered := False;
  FCreateNotFired := True;
end;
procedure TGraphControl.WMNCHitTest(var Message: TWMNCHitTest);
var hResult: integer;
begin
  hResult := HTCLIENT;

  if ((csDesigning in ComponentState) and (Parent <> nil)) or (not Assigned(fontps)) then
    Message.Result := HTCLIENT
  else
  begin
    fontps(Self as TObject, hresult);
    Message.Result := hresult;
  end;
end;
function TGraphControl.FBrush: TBrush;
begin
  Result := inherited Brush;
end;

function TGraphControl.FFont: TFont;
begin
  Result := inherited Font;
end;

function TGraphControl.FPen: TPen;
begin
  Result := Canvas.Pen;
end;

procedure TGraphControl.SetBrush(ABrush:TBrush);
var conti: boolean;
begin
  conti := true;
  if Assigned(fbs)then
    fbs(Self as TObject, ABrush, conti);
  if conti and (inherited Brush <> ABrush) then
  Begin
    (inherited Brush).Assign(ABrush);
     Canvas.Brush.Assign(ABrush);
  End;
end;
procedure TGraphControl.SetFont(AFont:TFont);
  var conti: boolean;
begin
  conti := true;
  if Assigned(ffs)then
    ffs(Self as TObject, AFont, conti);
  if conti and (inherited Font <> AFont) then
  Begin
    (inherited Font).Assign(AFont);
     Canvas.Font.Assign(AFont);
  End;
end;
procedure TGraphControl.SetPen(APen:TPen);
var conti: boolean;
begin
  conti := true;
  if Assigned(fps)then
    fps(Self as TObject, APen, conti);
  if conti and (Canvas.Pen <> APen) then
    Canvas.Pen.Assign(APen);
end;
procedure TGraphControl.ChangeBrush(Sender:TObject);
begin
  if TBrush(Sender) = Canvas.Brush then
    (inherited Brush).Assign(TBrush(Sender))
  else
    Canvas.Brush.Assign(TBrush(Sender));

  if Assigned(fbc) then
    fbc(Self as TObject);
end;
procedure TGraphControl.ChangeFont(Sender:TObject);
begin
  if TFont(Sender) = Canvas.Font then
    (inherited Font).Assign(TFont(Sender))
  else
    Canvas.Font.Assign(TFont(Sender));

  if Assigned(ffc) then
    ffc(Self as TObject);
end;
procedure TGraphControl.ChangePen(Sender:TObject);
begin
  if Assigned(fpc) then
    fpc(Self as TObject);
end;
procedure TGraphControl.SetOnCreate(A:TNotifyEvent);
begin
  foc := A;
  if FCreateNotFired then
  begin
   foc(Self as TObject);
   FCreateNotFired := False;
  end;
end;
procedure TGraphControl.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocused := True;
  if Assigned(fOnFocus) then
    fOnFocus(Self as TObject);
  inherited;
end;
procedure TGraphControl.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocused := False;
  if Assigned(fOnBlur) then
    fOnBlur(Self as TObject);
  inherited;
end;
procedure TGraphControl.Paint;
begin
  if Assigned(fop) then
    fop(Self as TObject);
end;
destructor TGraphControl.Destroy;
begin
  if Assigned(fod) then
    fod(Self as TObject);

  inherited Destroy;
end;

end.