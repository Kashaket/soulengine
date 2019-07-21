unit dsCustomControls;
{$S-,W-,R+,H+,X+}
interface

uses
  System.Types,
  WinAPI.Windows, Forms, Messages, System.Classes, VCL.Controls, VCL.Graphics;

type
TPenSetEvent   = procedure(Sender:TObject; Value:TPen; var Co: boolean) of object;
TBrushSetEvent = procedure(Sender:TObject; Value:TBrush; var Co: boolean) of object;
TGraphControl = class( TCustomControl )
  private
    FFocused: boolean;
    FCreateNotFired: boolean;
    FPen: TPen;
    FBrush: TBrush;
    foc, fod, fop, fpc, fbc, fOnFocus, fOnBlur: TNotifyEvent;
    fps: TPenSetEvent;
    fbs: TBrushSetEvent;
  protected
    procedure SetBrush(ABrush:TBrush);
    procedure SetPen(APen:TPen);
    procedure ChangeBrush(Sender:TObject);
    procedure ChangePen(Sender:TObject);
    procedure SetOnCreate(A:TNotifyEvent);
    procedure Paint; override;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure setFocused(a:boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Canvas;
    procedure UnFocus;
    property Focused: boolean read FFocused write setFocused;
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: TPen read FPen write SetPen;
    property OnBrushChange: TNotifyEvent read fbc write fbc;
    property OnBrushSet: TBrushSetEvent read fbs write fbs;
    property OnPenChange: TNotifyEvent read fpc write fpc;
    property OnPenSet: TPenSetEvent read fps write fps;

    property OnPaint: TNotifyEvent read fop write fop;
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
  ControlStyle := ControlStyle + [csReplicatable];
  FFocused := False;
  FPen := TPen.Create;
  FPen.OnChange := ChangePen;
  FBrush := TBrush.Create;
  FBrush.OnChange := ChangeBrush;
  FCreateNotFired := True;
end;
procedure TGraphControl.SetBrush(ABrush:TBrush);
var conti: boolean;
begin
  conti := true;
  if Assigned(fbs)then
    fbs(Self as TObject, ABrush, conti);
  if conti and (FBrush <> ABrush) then
    FBrush := ABrush;
end;
procedure TGraphControl.SetPen(APen:TPen);
var conti: boolean;
begin
  conti := true;
  if Assigned(fps)then
    fps(Self as TObject, APen, conti);
  if conti and (FPen <> APen) then
    FPen := APen;
end;
procedure TGraphControl.ChangeBrush(Sender:TObject);
begin
  if Assigned(fbc) then
    fbc(Self as TObject);
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
procedure TGraphControl.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
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
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

end.