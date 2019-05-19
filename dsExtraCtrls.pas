unit dsExtraCtrls;
{$S-,W-,R+,H+,X+}
interface

uses {$IF DEFINED(CLR)}
  System.ComponentModel.Design.Serialization,
{$ENDIF}
  Winapi.Messages, Winapi.Windows, System.SysUtils, System.Classes, System.Contnrs, System.Types, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.Graphics, Vcl.StdCtrls, Vcl.GraphUtil, Vcl.ImgList, Vcl.Themes, Winapi.ShellAPI;


type
TShapeType = (stRectangle, stSquare, stRoundRect, stRoundSquare,
    stEllipse, stCircle, stRhombus, stDiamond,
    //равносторонний-------//равнобедренный
    stEquilateralTriangle, stIsosceleTriangle,
    //прямоугольный-------//свободный
    stRightTriangle, stScaleneTriangle,
    stSunPie);
TShape = class(TGraphicControl)
  private
    FPen: TPen;
    FBrush: TBrush;
    FShape: TShapeType;
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetShape(Value: TShapeType);
  protected
    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure StyleChanged(Sender: TObject);
    property Align;
    property Anchors;
    property Brush: TBrush read FBrush write SetBrush;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Constraints;
    property ParentShowHint;
    property Pen: TPen read FPen write SetPen;
    property Shape: TShapeType read FShape write SetShape default stRectangle;
    property ShowHint;
    property Touch;
    property Visible;
    property AutoSize;
    property OnCanResize;
    property OnConstrainedResize;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnClick;
    property OnDblClick;
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
  end;
TTransientPanel = class(TGraphicControl)

end;
implementation

{ TShape }

constructor TShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 50;
  Height := 50;
  FPen := TPen.Create;
  FPen.OnChange := StyleChanged;
  FBrush := TBrush.Create;
  FBrush.OnChange := StyleChanged;
end;

destructor TShape.Destroy;
begin
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

procedure TShape.ChangeScale(M, D: Integer; isDpiChange: Boolean);
begin
  FPen.Width := MulDiv(FPen.Width, M, D);
  inherited;
end;

procedure TShape.Paint;
const inDev = 'In development process';
var
  X, Y, W, H, S: Integer;
begin
  with Canvas do
  begin
    Pen := FPen;
    Brush := FBrush;
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    if FShape in [stSquare, stRoundSquare, stCircle, stRhombus, stEquilateralTriangle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    if FShape in [stRhombus, stEquilateralTriangle] then
    begin
       if S mod 2 = 0 then
       begin
        Inc(X, 1);
        Inc(Y, 1);
        Dec(S, 1);
         W := S;
         H := S;
       end;
    end;
    case FShape of
      stRectangle, stSquare:
        Rectangle(X, Y, X + W, Y + H);
        //xywh
      stRoundRect, stRoundSquare:
        RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
      stCircle, stEllipse:
        Ellipse(X, Y, X + W, Y + H);
      stRhombus, stDiamond:
        Polygon([
        Point(X + (W div 2), Y),
        Point(X+W-1, Y+(H DIV 2)),
        Point(X+(W DIV 2), Y+H-1),
        Point(X,Y+(H div 2))]);
      stIsosceleTriangle:
        Polygon([
        Point(X, Y+H-1),
        Point(X+(W DIV 2), Y),
        Point(X+W-1, Y+H-1)]);
      stEquilateralTriangle:
        Polygon([
        Point(X+(W DIV 2), Y),
        Point(X, Y+H-1),
        Point(X+W-1, Y+H-1)]);
      stRightTriangle, stScaleneTriangle:
        TextOut(X+((W-TextWidth(inDev)) div 2), Y+(H div 2) - (TextHeight(inDev) div 2), inDev);
      stSunPie:
      begin
        Ellipse(X, Y, X + W, Y + H);
        Polygon([
        Point(X, Y+H-1),
        Point(X+(W DIV 2), Y),
        Point(X+W-1, Y+H-1)]);
      end;
    end;
  end;
end;

procedure TShape.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TShape.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TShape.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TShape.SetShape(Value: TShapeType);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    Invalidate;
  end;
end;

end.
