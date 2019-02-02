{-------------------------------------------------------------}
{----Purpose : Focus Indicator                                }
{    By      : Ir. G.W. van der Vegt                          }
{    For     : Myself                                         }
{-------------------------------------------------------------}
{ ddmmyy comment                                              }
{ ------ -----------------------------------------------------}
{ 17022008-Initial version.                                   }
{         -Fixed positioning for controls inside a container  }
{          by making the parent of the TnxFocus equal to the  }
{          FocusControl's parent.                             }
{         -Fixed initial values of TNxFocus properties.       }
{-------------------------------------------------------------}
{ TODO:                                                       }
{-------------------------------------------------------------}

unit NxFocus;

interface

uses
  SysUtils, Classes, Forms, Types, Controls, ExtCtrls, Graphics;

type
  TNxFocusEvent = procedure(const Sender: TObject;
    const Target: TwinControl;
    var aBorderColor: TColor;
    var aBorderWidth, aBorderMargin: Integer) of object;

  TNxDeFocusEvent = procedure(const Sender: TObject;
    const Target: TwinControl) of object;

  TNxFocus = class(TShape)
  private
    FBorderColor: TColor;
    FBorderMargin: Integer;
    FBorderWidth: Integer;
    FLastActiveControl: TwinControl;
    FOnActiveControlChange: TNotifyEvent;
    FOnDeFocus: TNxDeFocusEvent;
    FOnFocus: TNxFocusEvent;
    {:
    Sets Pen.Color to clRed making the focus rectangle visible.
    }
    procedure EnterColor(Sender: TWinControl);
    {:
    Sets Pen.Color back to ParentForm.Color.
    }
    procedure ExitColor(Sender: TWinControl);
    {:
    Internal function to enlarge a rectangle.
    }
    function Inflate(const Value: TRect; const Pixels: Integer = 1): TRect;
    function SameRect(const r1, r2: TRect): Boolean;
    {:
    Dependent on the focus change Enter or ExitColor is called.
    }
    procedure ScreenActiveControlChange(Sender: TObject);
    {:
    Sets border color and updates the control.
    }
    procedure SetBorderColor(const Value: TColor);
    {:
    Sets border margin and updates the control.
    }
    procedure SetBorderMargin(const Value: Integer);
    {:
    Sets border width and updates the control.
    }
    procedure SetBorderWidth(const Value: Integer);
  public
    {:
    The Constructor temporarily sets the constraints for designtime and
    hooks into the TScreen.ActiveControlChange Event.
    }
    constructor Create(AOwner: TComponent); override;
    {:
    Unhooks into the TScreen.ActiveControlChange Event.
    }
    destructor Destroy; override;
    {:
    public method Loaded.

    Used to enable the control at runtime.
    }
    procedure Loaded; override;
  published
    {:
    The Color of the Focus Rectangle.
    }
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    {:
    Spacing between the control and the NxFocus rectangle.
    }
    property BorderMargin: Integer read FBorderMargin write SetBorderMargin;
    {:
    The Width of the Focus Rectangle.
    }
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    {:
     Event occurs when a control looses focus.
    }
    property OnDeFocus: TNxDeFocusEvent read FOnDeFocus write FOnDeFocus;
    {:
    Event occurs when a control gains focus. This is also the place to
    Specify control dependend values for BorderMargin, BorderWidth and
    BorderColor.

    Note: Setting the BorderWidth to 0 will hide the Focus Rectangle.
    }
    property OnFocus: TNxFocusEvent read FOnFocus write FOnFocus;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Next Addons', [TNxFocus]);
end;

{ TNxFocus }

constructor TNxFocus.Create(AOwner: TComponent);
begin
  inherited;

  Brush.Style := bsClear;

  FBorderColor := clRed;
  FBorderMargin := 1;
  FBorderWidth := 1;

  Pen.Width := FBorderWidth;
  Pen.Color := FBorderColor;

  FLastActiveControl := nil;

  FOnDeFocus := nil;
  FOnFocus := nil;

  Left := 10;
  Top := 10;
  Width := 28;
  Height := 28;

  //So it looks like a regular Component...
  Constraints.MinHeight := 28;
  Constraints.MaxHeight := 28;

  Constraints.MinWidth := 28;
  Constraints.MaxWidth := 28;
end;

destructor TNxFocus.Destroy;
begin
  Hide;

  Screen.OnActiveControlChange := fOnActiveControlChange;

  inherited;
end;

procedure TNxFocus.EnterColor(Sender: TWinControl);
var
  m                             : Integer;
  w                             : Integer;
  c                             : TColor;
  NewRect                       : TRect;
begin
  if Sender <> nil then
    begin
      w := FBorderWidth;
      m := FBorderMargin;
      c := FBorderColor;

      if Assigned(OnFocus) then
        FOnFocus(Self, Sender, c, w, m);

      if (Pen.Color <> c) then
        Pen.Color := c;

      NewRect := Inflate(Sender.BoundsRect, m);
      if not SameRect(BoundsRect, NewRect) then
        BoundsRect := NewRect;

      //BoundsRect := Inflate(Sender.BoundsRect, m);

      //Set Parent to Senders Parent so the Focus Rectangle is positioned and showed correctly.
      if (Self.Parent <> Sender.Parent) then
        Self.Parent := Sender.Parent;

      if (w <> 0) then
        begin
          Pen.Width := w;

          Show;
        end;

      if (Anchors <> Sender.Anchors) then
        Anchors := Sender.Anchors;
    end;
end;

procedure TNxFocus.ExitColor(Sender: TWinControl);
begin
  if Sender <> nil then
    begin
      Hide;

      if Assigned(OnDeFocus) then
        FOnDeFocus(Self, Sender);

     if (Anchors<>[akLeft,akTop]) then
       Anchors := [akLeft,akTop];
    end;
end;

function TNxFocus.Inflate(const Value: TRect; const Pixels: Integer = 1): TRect;
begin
  Result := Value;

  Dec(Result.Left, Pixels);
  Dec(Result.Top, Pixels);
  Inc(Result.Right, Pixels);
  Inc(Result.Bottom, Pixels);
end;

function TNxFocus.SameRect(const r1, r2: TRect): Boolean;
begin
  Result :=
    (r1.Left = r2.Left) and
    (r1.Right = r2.Right) and
    (r1.Top = r2.Top) and
    (r1.Bottom = r2.Bottom);
end;

procedure TNxFocus.Loaded;
begin
  inherited;

  if not (csDesigning in ComponentState) then
    begin
      //Release the size of the Component so it no longer mimics a TComponent.
      Constraints.MinHeight := 0;
      Constraints.MaxHeight := 0;

      Constraints.MinWidth := 0;
      Constraints.MaxWidth := 0;

      FBorderColor := Pen.Color;

      fOnActiveControlChange := Screen.OnActiveControlChange;
      Screen.OnActiveControlChange := ScreenActiveControlChange;
    end;
end;

procedure TNxFocus.ScreenActiveControlChange(Sender: TObject);
var
  doEnter                       : Boolean;
  doExit                        : Boolean;
  previousActiveControl         : TWinControl;
begin
  if Screen.ActiveControl = nil then
    begin
      fLastActiveControl := nil;

      Exit;
    end;

  doEnter := True;
  doExit := True;

  //Exclusions
  //if Screen.ActiveControl is TButtonControl then
  //  doEnter := false;

  previousActiveControl := fLastActiveControl;

  if previousActiveControl <> nil then
    begin
      //    Exclusions
      //    if previousActiveControl is TButtonControl then
      //      doExit := false;
    end;

  fLastActiveControl := Screen.ActiveControl;

  if doExit then
    ExitColor(previousActiveControl);

  if doEnter then
    EnterColor(fLastActiveControl);

  if Assigned(fOnActiveControlChange) then
    fOnActiveControlChange(Sender);
end;

procedure TNxFocus.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;

  //Update only in non Designing state.
  if not (csDesigning in ComponentState) then
    ScreenActiveControlChange(Self);
end;

procedure TNxFocus.SetBorderMargin(const Value: Integer);
begin
  FBorderMargin := Value;

  //Update only in non Designing state.
  if not (csDesigning in ComponentState) then
    ScreenActiveControlChange(Self);
end;

procedure TNxFocus.SetBorderWidth(const Value: Integer);
begin
  FBorderWidth := Value;

  //Update only in non Designing state.
  if not (csDesigning in ComponentState) then
    ScreenActiveControlChange(Self);
end;

end.
