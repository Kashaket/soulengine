unit NxBusy;

{$I ..\NxSuite.inc}

interface

uses
  Classes, Types, Messages, Graphics, Controls, Windows, Contnrs;

{$IFDEF DELPHI6}
const
  clSystemColor = $FF000000;
{$ENDIF DELPHI6}

type
  TNxBusyThread = class;

  TNxBusy = class(TGraphicControl)
  private
    FActive: Boolean;
    FActualColor: TColorRef;
    FBrushStack: TObjectStack;
    FBusyThread: TNxBusyThread;
    FCycle: TColorRef;
    FEnabled: Boolean;
    FInterval: Integer;
    FPenStack: TObjectStack;
    FPriority: TThreadPriority;
    FSpacing: Integer;
    FSpeed: Integer;
    procedure DrawRect(const aLeft, aTop: Integer; const aColor: TColorRef);
    procedure SetActive(const Value: boolean);
    procedure SetPriority(const Value: TThreadPriority);
    procedure SetSpacing(const Value: Integer);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
  protected
    function GetEnabled: Boolean; override;
    function GetCycleB: Byte;
    function GetCycleG: Byte;
    function GetCycleR: Byte;
    procedure Loaded; override;
    procedure Paint; override;
    procedure SetCycleB(const Value: Byte);
    procedure SetCycleG(const Value: Byte);
    procedure SetCycleR(const Value: Byte);
    procedure SetEnabled(Value: Boolean); override;
    procedure StartTimer;
    procedure StopTimer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Anchors;
    property Align;
    property BoundsRect;
    property Constraints;
    property ShowHint;
    property Visible;
    {: Activates the animation at runtime and designtime. }
    property Active: boolean read FActive write SetActive stored false default False;
    {: Slightly changed Color, it updates the control even if not active. }
    property Color: TColor read GetColor write SetColor;
    {: Blue color difference between each of the 4 rectangles. }
    property CycleB: Byte read GetCycleB write SetCycleB default 32;
    {: Green color difference between each of the 4 rectangles. }
    property CycleG: Byte read GetCycleG write SetCycleG default 0;
    {: Red color difference between each of the 4 rectangles. }
    property CycleR: Byte read GetCycleR write SetCycleR default 0;
    {: Delay between animation frames. }
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Interval: Integer read FInterval write FInterval default 25;
    {: Animation Thread Priority. }
    property Priority: TThreadPriority read FPriority write SetPriority default tpLower;
    {: Spacing in Pixels between the 4 rectangles. }
    property Spacing: Integer read FSpacing write SetSpacing default 2;
    {: Increment of RGB Color values between animation frames. }
    property Speed: Integer read FSpeed write FSpeed default 8;
  end;
  
  TNxBusyThread = class(TThread)
  protected
    FBusy: TNxBusy;
    procedure DoExecute;
  public
    constructor Create(Busy: TNxBusy); reintroduce;
    procedure Execute; override;
  end;

implementation

uses SysUtils;

function TColorRed(c: TColor): Byte;
begin
  Result := DWord(c) mod 256;
end;

function TColorGreen(c: TColor): Byte;
begin
  Result := (c div 256) mod 256;
end;

function TColorBlue(c: TColor): Byte;
begin
  Result := ((c div 256) div 256) mod 256;
end;

function TColor2RGB(c: TColor): TColorRef;
begin
  Result := RGB(TColorRed(c), TColorGreen(c), TColorBlue(c));
end;

function MakeTColor(rgb: TColorRef): TColor; overload;
begin
  Result := (DWord(GetBValue(rgb)) * 256 + DWord(GetGValue(rgb))) * 256 + DWord(GetRValue(rgb));
end;

function MakeTColor(r, g, b: Byte): TColor; overload;
begin
  Result := (DWord(b) * 256 + DWord(g)) * 256 + DWord(r);
end;

function Color2Lumicance(rgb: TColorRef): TColor;
var
  Y: Integer;
begin
  Y := Round(0.299 * GetRValue(rgb) + 0.587 * GetGValue(rgb) + 0.114 * GetBValue(rgb));
  if (Y > 255) then y := 255 else if (Y < 0) then y := 0;
  Result := MakeTColor(y, y, y);
end;

{ TNxBusy }

constructor TNxBusy.Create(AOwner: TComponent);
begin
  inherited;

  FActive := False;

  FPriority := tpNormal;

  FPenStack := TObjectStack.Create;
  FBrushStack := TObjectStack.Create;

  FInterval := 25;

  FSpacing := 2;

  //veg:Default to Blue Clockwise Rotation
  Color := clBlue;
  FCycle := RGB(0, 0, 196);

  FActualColor := Color;

  FEnabled := True;

  FSpeed := 8;

  Width := 32;
  Height := 32;
end;

destructor TNxBusy.Destroy;
begin
  try
    if Active then
      Active := False;
  except
  end;

  FreeAndNil(FPenStack);
  FreeAndNil(FBrushStack);

  inherited;
end;

procedure TNxBusy.DrawRect(const aLeft, aTop: Integer; const aColor: TColorRef);
var
  dx                            : Integer;
  dy                            : Integer;
begin
  with Canvas do
    begin
      FPenStack.Push(Pen);
      FBrushStack.Push(Brush);

      Pen.Color := MakeTColor(aColor);
      Brush.Color := Pen.Color;

      dx := (Width - Spacing) div 2;
      dy := (Height - Spacing) div 2;

      FillRect(Rect(aLeft, aTop, aLeft + dx, aTop + dy));

      Pen := TPen(FPenStack.Pop);
      Brush := TBrush(FBrushStack.Pop);
    end;
end;

procedure TNxBusy.Loaded;
begin
  inherited;

  FActualColor := TColor2RGB(Color);
  FActive := False;
end;

procedure TNxBusy.Paint;
var
  dx                            : Integer;
  dy                            : Integer;
  tmpColor                      : TColorRef;

  procedure CycleColor(var aColor: TColorRef);
  var
    r                           : Byte;
    g                           : Byte;
    b                           : Byte;
  begin
    r := Byte((Integer(GetRValue(aColor)) - CycleR) mod 256);
    g := Byte((Integer(GetGValue(aColor)) - CycleG) mod 256);
    b := Byte((Integer(GetBValue(aColor)) - CycleB) mod 256);

    aColor := RGB(r, g, b);

    if not inherited Enabled then
      aColor := TColor2RGB(Color2Lumicance(aColor));
  end;

begin
  dx := (Width + Spacing) div 2;
  dy := (Height + Spacing) div 2;

  tmpColor := FActualColor;

  //Top Left
  if not inherited Enabled then
    DrawRect(0, 0, TColor2RGB(Color2Lumicance(tmpColor)))
  else
    DrawRect(0, 0, tmpColor);
  CycleColor(tmpColor);

  //Top Right
  if not inherited Enabled then
    DrawRect(dx, 0, TColor2RGB(Color2Lumicance(tmpColor)))
  else
    DrawRect(dx, 0, tmpColor);
  CycleColor(tmpColor);

  //Bottom Right
  if not inherited Enabled then
    DrawRect(dx, dy, TColor2RGB(Color2Lumicance(tmpColor)))
  else
    DrawRect(dx, dy, tmpColor);
  CycleColor(tmpColor);

  //Bottom Left
  if not inherited Enabled then
    DrawRect(0, dy, TColor2RGB(Color2Lumicance(tmpColor)))
  else
    DrawRect(0, dy, tmpColor);
end;

procedure TNxBusy.StartTimer;
begin
  if not FActive and not (csLoading in ComponentState) then
    begin
      FActualColor := TColor2RGB(Color);

      FBusyThread := TNxBusyThread.Create(Self);
      with FBusyThread do
        begin
          Priority := FPriority;

          FreeOnTerminate := True;

          Resume;
        end;

      FActive := True;                                                          //Signals Running...
    end;
end;

procedure TNxBusy.StopTimer;
begin
  if Assigned(FBusyThread) and not (FBusyThread.Terminated) then
    begin
      FBusyThread.Terminate;
//    FBusyThread.WaitFor;
    end;

  FActive := False;
end;

procedure TNxBusy.SetActive(const Value: boolean);
begin
  if (FActive <> Value) then
    case Value of
      true: StartTimer;
      false: StopTimer;
    end;
end;

function TNxBusy.GetCycleB: Byte;
begin
  Result := GetBValue(FCycle);
end;

procedure TNxBusy.SetCycleB(const Value: Byte);
begin
  FCycle := RGB(GetRValue(FCycle), GetGValue(FCycle), Value);
  FActualColor := TColor2RGB(Color);
  Invalidate;
end;

function TNxBusy.GetCycleG: Byte;
begin
  Result := GetGValue(FCycle);
end;

procedure TNxBusy.SetCycleG(const Value: Byte);
begin
  FCycle := RGB(GetRValue(FCycle), Value, GetBValue(FCycle));
  FActualColor := TColor2RGB(Color);
  Invalidate;
end;

function TNxBusy.GetCycleR: Byte;
begin
  Result := GetRValue(FCycle);
end;

procedure TNxBusy.SetCycleR(const Value: Byte);
begin
  FCycle := RGB(Value, GetGValue(FCycle), GetBValue(FCycle));
  FActualColor := TColor2RGB(Color);
  Invalidate;
end;

procedure TNxBusy.SetPriority(const Value: TThreadPriority);
begin
  FPriority := Value;

  if Assigned(FBusyThread) and not (FBusyThread.Terminated) then
    begin
      case FBusyThread.Suspended of
        true:
          FBusyThread.Priority := Value;
        false:
          begin
            FBusyThread.Suspend;
            FBusyThread.Priority := Value;
            FBusyThread.Resume;
          end;
      end;
    end;
end;

procedure TNxBusy.SetSpacing(const Value: Integer);
begin
  if (Value < Width) then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

function TNxBusy.GetColor: TColor;
begin
  Result := inherited Color;
end;

procedure TNxBusy.SetColor(const Value: TColor);
begin
  if ((Value and clSystemColor) = 0) then
  begin
    inherited Color := Value;
    FActualColor := TColor2RGB(Color);
    Invalidate;
  end;
end;

function TNxBusy.GetEnabled: Boolean;
begin
  Result := {inherited} FEnabled;
end;

procedure TNxBusy.SetEnabled(Value: Boolean);
begin
  {inherited}FEnabled := Value;

  Invalidate;
end;

{ TBusyThread }

constructor TNxBusyThread.Create(Busy: TNxBusy);
begin
  inherited Create(True);

  FBusy := Busy;
end;

procedure TNxBusyThread.DoExecute;
var
  r                             : Byte;
  g                             : Byte;
  b                             : Byte;
begin
  inherited;

//  GetRValue()
//  TColor
//  RGB();

  if Assigned(FBusy) then
    with FBusy do
      begin
        r := GetRValue(FActualColor);
        if (CycleR <> 0) then
          r := Byte((-Speed + r) mod 256);

        g := GetGValue(FActualColor);
        if (CycleG <> 0) then
          g := Byte((-Speed + g) mod 256);

        b := GetBValue(FActualColor);
        if (CycleB <> 0) then
          b := Byte((-Speed + b) mod 256);

        FActualColor := RGB(r, g, b);

        Paint;
      end;
end;

procedure TNxBusyThread.Execute;
begin
  while not Terminated and Assigned(FBusy) do
    begin
      Synchronize(DoExecute);

      if Assigned(FBusy) then
        Sleep(FBusy.Interval);
    end;
end;

end.
