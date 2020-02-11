unit dsExtraCtrls;
{$S-,W-,R+,H+,X+}
interface

uses {$IF DEFINED(CLR)}
  System.ComponentModel.Design.Serialization,
{$ENDIF}
  Dialogs,
  Winapi.Messages, Winapi.Windows, System.SysUtils, System.Classes, System.Contnrs, System.Types, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.Graphics, Vcl.StdCtrls, Vcl.GraphUtil, Vcl.ImgList, Vcl.Themes, Winapi.ShellAPI;


type
TShapeType = (stRectangle, stSquare, stRoundRect, stRoundSquare,
    stEllipse, stCircle, stRhombus, stDiamond,
    //равносторонний-------//равнобедренный
    stEquilateralTriangle, stIsosceleTriangle,
    //прямоугольный-------//свободный
    stRightTriangle, stScaleneTriangle,
    //Солтреуг//Полифигура
    stSunPie, stPoly);//, stArc, stPie, stPath);
TShape = class(TGraphicControl)
  private
    FPen: TPen;
    FBrush: TBrush;
    FShape: TShapeType;
    FSides, FAngle: integer;
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetShape(Value: TShapeType);
    procedure SetAngle(Value: integer);
    procedure SetSides(Value: integer);
  protected
    procedure PerformRotatedPolygon(mx, my: integer; const Input: array of TPoint);
    procedure DrawPolyShape(A, B: integer);
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
    property Pen: TPen read FPen write SetPen;
    property Shape: TShapeType read FShape write SetShape default stRectangle;
    property Sides: integer read FSides write SetSides default 4;
    property Angle: integer read FAngle write SetAngle default 0;
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

procedure BlendBit(src1, src2, dst: tbitmap; amount: extended);
implementation

procedure BlendBit(src1, src2, dst: tbitmap; amount: extended);
var w,h,x,y:integer;
    ps1,ps2,pd:pbytearray;
begin
w:=src1.Width ;
h:=src1.Height;
dst.Width :=w;
dst.Height :=h;
src1.PixelFormat :=pf24bit;
src2.PixelFormat:=pf24bit;
dst.PixelFormat :=pf24bit;
for y:=0 to h-1 do begin
 ps1:=src1.ScanLine [y];
 ps2:=src2.ScanLine [y];
 pd:=dst.ScanLine [y];
 for x:=0 to w-1 do begin
  if ((ps2[x*3]=$FF) and (ps2[x*3+1]=$FF) and (ps2[x*3+2]=$FF)) then begin
    pd[x*3]:=$FF;
    pd[x*3+2]:=$FF;
    pd[x*3+2]:=$FF;
   end
   else begin
    pd[x*3]:=round((1-amount)*ps1[x*3]+amount*ps2[x*3]);
    pd[x*3+1]:=round((1-amount)*ps1[x*3+1]+amount*ps2[x*3+1]);
    pd[x*3+2]:=round((1-amount)*ps1[x*3+2]+amount*ps2[x*3+2]);
    end;
  end;
 end;
end;
{ TShape }

constructor TShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FSides := 4;
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
  fbitmap: TBitmap;
begin
  //fbitmap := TBitmap.Create;
  //fbitmap.Height := Height;
  //fbitmap.Width := Width;

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
    if FShape in [stSquare, stRoundSquare, stPoly,
    stCircle, stRhombus, stEquilateralTriangle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    if (FShape in [stRhombus, stEquilateralTriangle]) then
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
    if (FShape = stPoly) and ((FSides mod 2 <> 0) and (FSides mod 3 = 0)) then
    begin
      while (S - 1) mod 3 <> 0 do
      begin
        Dec(S, 1);
      end;
      W := S;
      H := S;
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
        PerformRotatedPolygon(X+W-1, Y+H-1,
        [
        Point(X + (W div 2), Y),
        Point(X+W-1, Y+(H DIV 2)),
        Point(X+(W DIV 2), Y+H-1),
        Point(X,Y+(H div 2))
        ]
        );
      stIsosceleTriangle:
        PerformRotatedPolygon(X+W-1, Y+H-1,
        [
        Point(X, Y+H-1),
        Point(X+(W DIV 2), Y),
        Point(X+W-1, Y+H-1)
        ]
        );
      stEquilateralTriangle:
        PerformRotatedPolygon(X+W-1, Y+H-1,
        [
        Point(X+(W DIV 2), Y),
        Point(X, Y+H-1),
        Point(X+W-1, Y+H-1)
        ]
        );
      stRightTriangle:
        PerformRotatedPolygon(X+W-1, Y+H-1,
        [
        Point(X, Y),
        Point(X, Y+H-1),
        Point(X+W-1, Y+H-1)
        ]
        );
      stScaleneTriangle:
        TextOut(X+((W-TextWidth(inDev)) div 2), Y+(H div 2) - (TextHeight(inDev) div 2), inDev);
      stSunPie:
      begin
        Ellipse(X, Y, X + W, Y + H);
        Polygon([
        Point(X, Y+H-1),
        Point(X+(W DIV 2), Y),
        Point(X+W-1, Y+H-1)]);
      end;
      stPoly:
        DrawPolyShape((W div 2) - 1, (H div 2) - 1);
    end;
  end;
end;
procedure TShape.PerformRotatedPolygon(mx, my: integer;const Input: array of TPoint);
var
    i, diff, x, y: integer;
    // Double := E.ZZ
    // Extended := E.n{Z}
    RotationAngle, xCenter, yCenter:  double;
    Result: array of TPoint;
begin
    diff := 0;
    if Angle > 0 then
    begin
    // Convert degrees to radians
    RotationAngle := Angle * PI/180;

    // Copy Result length from Input length
    SetLength(Result, Length(Input));

    // Specify rotation center
    xCenter := Width DIV 2;
    yCenter := Height DIV 2;
    // Walk
    for i := Low(Result) to High(Result) do
    begin

     // Perform rotation
     x :=
           ROUND(
                 xCenter + (Input[i].X - xCenter)* COS(RotationAngle)
                         - (Input[i].Y - yCenter)* SIN(RotationAngle) );

     y :=
           ROUND(
                 yCenter + (Input[i].X - xCenter)* SIN(RotationAngle)
                         + (Input[i].Y - yCenter)* COS(RotationAngle) );
    // Check if X violates bounds
    If x < 0 then
      if (diff < Abs(x)) then diff := Abs(x)
    Else
      if (x > Width - 1) and (diff < (x - mx)) then diff := x - mx;

    // Check if Y violates bounds
    If y < 0 then
      if (diff < Abs(y)) then diff := Abs(y)
    Else
      if (y > Height - 1) and (diff < (y - my)) then diff := y - my;

      Result[i]  := Point(x, y);
    end;
    // Perform square decrease
    if diff > 0 then
    begin
     // diff := diff + 1;
      for i := Low(Result) to High(Result) do
      begin
        y := Result[i].Y;
        x := Result[i].X;
        If x < 0 then
          Result[i].X := x + diff
        Else
          Result[i].X := x - diff;

        If y < 0 then
          Result[i].Y := y + diff
        Else
          Result[i].Y := y - diff;
      end;
    end;
    if diff < 0 then ShowMessage('ПИЗДЕЦ');

      // Draw the end-point polygon
    Canvas.Polygon(Result);
    end
    else
      Canvas.Polygon(Input);
end;
procedure TShape.DrawPolyShape(A, B: integer);
  var
    i:  integer;
    RotationAngle,theta:  Double;
    x,xCenter,y,yCenter:  Double;
    res: array of TPoint;
Begin

  RotationAngle := Angle *
                   PI/180 {degrees to radians};
    xCenter := Width div 2;
    yCenter := Height div 2;
    SetLength(res, Sides+1);
    for i := 0 to Sides do
    Begin
      theta := 360*(i/Sides) {degrees} * (PI/180) {radians/degree};
      //to make multigonal shape
      x := xCenter + A*COS(theta);
      y := yCenter + B*SIN(theta);
      //rotated x,y
      res[i] := Point(ROUND(
                 xCenter + (x - xCenter)* COS(RotationAngle)
                         - (y - yCenter)* SIN(RotationAngle) )
                   ,  ROUND(
                 yCenter + (x - xCenter)* SIN(RotationAngle)
                         + (y - yCenter)* COS(RotationAngle) ));

    End;
    Canvas.Polygon(res);
End;


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

procedure TShape.SetAngle(Value: integer);
begin
  if (FAngle <> Value) and (-360 <= Value) and (Value <= 360) then
  begin
    FAngle := Value;
    Invalidate;
  end;
end;

procedure TShape.SetSides(Value: integer);
begin
  if (FSides <> Value) and (Value > 1) then
  begin
    FSides := Value;
    Invalidate;
  end;
end;

end.
