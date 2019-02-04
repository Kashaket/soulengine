unit dsStdCtrl;

{$I 'sDef.inc'}

interface

uses Forms, Dialogs, SysUtils, Windows, Types, UITypes, TypInfo, Classes, Controls, Buttons,
  Messages, StdCtrls, Graphics, ExtCtrls, ShellAPI, ComCtrls, Vcl.Themes, DragDrop, DropTarget, DragDropFile;
{$M+}
{$TypeInfo On}
type
  TComponentLabel = class(TCustomControl)
  private
    FCaption: string;
    FPanel: TCustomControl;
    procedure SetCaption(const Value: string);
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaption;
  end;

type
  __TNoVisual = class(TCustomControl)
  private
    FGlyph: TBitmap;
    FLabel: TComponentLabel;
    FfileName: string;
    FrealHeight: integer;
    FrealWidth: integer;
    FCaption: string;
    FLabelDblClick: TNotifyEvent;
    // FLabelClick: TNotifyEvent;
    procedure SetfileName(const Value: string);
    procedure SetrealHeight(const Value: integer);
    procedure SetrealWidth(const Value: integer);
    procedure SetCaption(const Value: string);
  protected
    procedure SetName(const Value: TComponentName); override;
    procedure Paint; override;
    procedure initLabel;
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    { процедура для обработки сообщения Wm_move, чтобы метка перемещалась вместе с кнопкой }

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure loadFromFile(fileName: string);
  published
    property __iconName: string read FfileName write SetfileName;
    property realWidth: integer read FrealWidth write SetrealWidth default 26;
    property realHeight: integer read FrealHeight write SetrealHeight
      default 26;
    property Caption: string read FCaption write SetCaption;
    property OnDblClick: TNotifyEvent read FLabelDblClick write FLabelDblClick;
    property Font;
    property Cursor;
    property Visible;
  end;

type
  TDropFilesEvent = procedure(Sender: TObject; Files: TUnicodeStrings; X: integer;
    Y: integer) of object;

  TDropFilesTarget = class(TDropFileTarget)
  private
  FOnDropFiles: TDropFilesEvent; // Notification handler
  published
  procedure hOnDrop(Sender: TObject; ShiftState: TShiftState;
    APoint: TPoint; var Effect: Longint);
    procedure TestOnDrop(Sender: TObject; Files: TUnicodeStrings; X: integer;
    Y: integer);
    procedure setOnDropFiles(AEvent: TDropFilesEvent);
    constructor Create(AOwner: TComponent); override;
    property OnDropFiles: TDropFilesEvent read FOnDropFiles write SetOnDropFiles;
  end;


type
TWMScrollEvent = procedure(Sender: TObject; ScrollCode: integer; var ScrollPos: integer) of object;

  TScrollBox=Class(Forms.TScrollBox)
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  private
    FOnScrollVert: TWMScrollEvent;
    FOnScrollHorz: TWMScrollEvent;
  published
   Property OnScrollVert:TWMScrollEvent read FOnScrollVert Write FonScrollVert;
   Property OnScrollHorz:TWMScrollEvent read FOnScrollHorz Write FonScrollHorz;
  End;

type
  TEdit = class(StdCtrls.TEdit)
  private
    FInitDraw: boolean;
    FOldBackColor: TColor;
    FOldFontColor: TColor;
    FColorOnEnter: TColor;
    FFontColorOnEnter: TColor;
    FAlignment: TAlignment;
    FTabOnEnter: boolean;
    FTextHint: string;
    FOnFocus: TNotifyEvent;
    FOnBlur: TNotifyEvent;
    FMarginLeft: integer;
    FMarginRight: integer;

    procedure SetAlignment(Value: TAlignment);
    procedure SetMarginLeft(const Value: integer);
    procedure SetMarginRight(const Value: integer);
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

    procedure KeyPress(var Key: char); override;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    procedure UpdateMargins;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property TextHint: string read FTextHint write FTextHint;
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property ColorOnEnter: TColor read FColorOnEnter write FColorOnEnter;
    property FontColorOnEnter: TColor read FFontColorOnEnter
      write FFontColorOnEnter;

    property TabOnEnter: boolean read FTabOnEnter write FTabOnEnter;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;

    property MarginLeft: integer read FMarginLeft write SetMarginLeft;
    property MarginRight: integer read FMarginRight write SetMarginRight;
  end;

type
  TMemo = class(StdCtrls.TMemo)
  private
    FAlignment: TAlignment;
    FTabOnEnter: boolean;

    FOnFocus: TNotifyEvent;
    FOnBlur: TNotifyEvent;

    procedure SetAlignment(Value: TAlignment);
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

    procedure KeyPress(var Key: char); override;

    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;

    property TabOnEnter: boolean read FTabOnEnter write FTabOnEnter;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;

type
  TBitBtn = class(Buttons.TBitBtn)
  private
    FOnFocus: TNotifyEvent;
    FOnBlur: TNotifyEvent;
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  published
    constructor Create(AOwner: TComponent); override;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;

type
  TListBox = class(StdCtrls.TListBox)
  private
    FAlignment: TAlignment;
    FOnFocus: TNotifyEvent;
    FOnBlur: TNotifyEvent;
    FTwoColor: TColor;
    FTwoFontColor: TColor;
    FMarginLeft: integer;
    FBorderSelected: boolean;
    FReadOnly: boolean;
    FFonts: TList;
    FColors: TList;

    procedure SetTwoColor(const Value: TColor);
    procedure SetTwoFontColor(const Value: TColor);
    procedure SetMarginLeft(const Value: integer);
    procedure SetBorderSelected(const Value: boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetReadOnly(const Value: boolean);
  protected
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DrawItem(Index: integer; Rect: TRect;
      State: TOwnerDrawState); override;

  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetColor(Index: integer; Color: TColor);
    function GetColor(Index: integer): TColor;

    procedure ClearColor(Index: integer);

    function GetFont(Index: integer): TFont;
    procedure ClearFont(Index: integer);
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property BorderSelected: boolean read FBorderSelected
      write SetBorderSelected;
    property TwoColor: TColor read FTwoColor write SetTwoColor;
    property TwoFontColor: TColor read FTwoFontColor write SetTwoFontColor;
    property MarginLeft: integer read FMarginLeft write SetMarginLeft;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;

type
  TCheckBox = class(StdCtrls.TCheckBox)
  private
    FOnFocus: TNotifyEvent;
    FOnBlur: TNotifyEvent;
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;

type
  TComboBox = class(StdCtrls.TComboBox)
  private
    FOnFocus: TNotifyEvent;
    FOnBlur: TNotifyEvent;
  protected
    procedure DoEnter; override;
    procedure DoExit; override;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
  end;
type
   TTransparentPanel = class(TPanel)
private
  procedure WMEraseBkGnd(Var Message: TWMEraseBkGnd); message WM_EraseBkGnd;
protected
  procedure SetParent(AParent: TWinControl); override;
  procedure CreateParams(Var Params: TCreateParams); override;
  procedure Paint; override;
published
  constructor Create(AOwner: TComponent); override;
  procedure Invalidate; override;
end;

implementation
{ TEdit }
constructor TEdit.Create(AOwner: TComponent);
begin
  inherited;

  FColorOnEnter := clNone;
  FFontColorOnEnter := clNone;
  FTextHint := '';

  Alignment := taLeftJustify;
  if (TextHint <> '') and (Text = '') then
    Text := TextHint;

  FInitDraw := False;
end; (* Create *)

procedure TEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array [TAlignment] of longword = (ES_Left, ES_Right, ES_Center);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or Alignments[FAlignment];
  if (TextHint <> '') and (Text = '') then
    Text := TextHint;
end;

procedure TEdit.DoEnter;
begin
  FOldBackColor := Color;
  FOldFontColor := Font.Color;
  if FColorOnEnter <> clNone then
    Color := FColorOnEnter;

  if FFontColorOnEnter <> clNone then
    Font.Color := FFontColorOnEnter;

  if (TextHint <> '') and (TextHint = Text) then
    Text := '';

  if Assigned(FOnFocus) then
    FOnFocus(Self);

  UpdateMargins;

  inherited;
end; (* DoEnter *)

procedure TEdit.DoExit;
begin
  Color := FOldBackColor;
  Font.Color := FOldFontColor;

  if (TextHint <> '') and (Text = '') then
    Text := TextHint;

  if Assigned(FOnBlur) then
    FOnBlur(Self);

  UpdateMargins;

  inherited;
end; (* DoExit *)

procedure TEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
    UpdateMargins;
  end;
end;

procedure TEdit.SetMarginLeft(const Value: integer);
begin
  FMarginLeft := Value;
  UpdateMargins;
end;

procedure TEdit.SetMarginRight(const Value: integer);
begin
  FMarginRight := Value;
  UpdateMargins;
end;

procedure TEdit.UpdateMargins;
begin
  SendMessage(Handle, EM_SETMARGINS, EC_LEFTMARGIN, LPARAM(FMarginLeft));
  SendMessage(Handle, EM_SETMARGINS, EC_RIGHTMARGIN, FMarginRight shl 16);
end;

procedure TEdit.WMPaint(var Message: TWMPaint);
begin
  inherited;
  if (TextHint <> '') and (Text = '') then
    Text := TextHint;

  if not FInitDraw then
  begin
    FInitDraw := True;
    UpdateMargins;
  end;

end;

procedure TEdit.KeyPress(var Key: char);
begin
  inherited KeyPress(Key);
  // UpdateMargins;

  if FTabOnEnter and (Owner is TWinControl) then
  begin
    if Key = AnsiChar(VK_RETURN) then
    begin
      if HiWord(GetKeyState(VK_SHIFT)) <> 0 then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0)
      else
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
      Key := #0;
    end;
  end;
end; (* KeyPress *)

{ TScrollBoxEx }
procedure TScrollBox.WMHScroll(var Message: TWMHScroll);
var x_pos: integer;
begin
   inherited;

   if Assigned(FOnScrollHorz) then
   begin
     x_pos := Self.HorzScrollBar.Position;
     FOnScrollHorz(Self, integer(Message.ScrollCode), x_pos);
     Self.HorzScrollBar.Position := x_pos;
   end;
end;

procedure TScrollBox.WMVScroll(var Message: TWMVScroll);
var y_pos: integer;
begin
   inherited;
   if Assigned(FOnScrollVert) then begin
    y_pos := Self.VertScrollBar.Position;
    FOnScrollVert(Self, integer(Message.ScrollCode), y_pos);
    Self.VertScrollBar.Position := SmallInt( y_pos );
   end;
end;

{ TMemo }

constructor TMemo.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TMemo.CreateParams(var Params: TCreateParams);
const
  Alignments: array [TAlignment] of longword = (ES_Left, ES_Right, ES_Center);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or Alignments[FAlignment];
end;

procedure TMemo.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);

  inherited;
end;

procedure TMemo.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);

  inherited;
end;

procedure TMemo.KeyPress(var Key: char);
begin
  inherited KeyPress(Key);

  if FTabOnEnter and (Owner is TWinControl) then
  begin
    if Key = AnsiChar(VK_RETURN) then
    begin
      if HiWord(GetKeyState(VK_SHIFT)) <> 0 then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0)
      else
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
      Key := #0;
    end;
  end;
end;

procedure TMemo.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

{ TBitBtn }

constructor TBitBtn.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TBitBtn.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);

  inherited;
end;

procedure TBitBtn.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);

  inherited;
end;

{ TListBox }

constructor TListBox.Create(AOwner: TComponent);
begin
  inherited;
  FTwoColor := clNone;
  FTwoFontColor := clNone;
  FMarginLeft := 2;
  FFonts := TList.Create;
  FColors := TList.Create;
  Style := lbOwnerDrawFixed;
  BorderSelected := True;
  FReadOnly := False;
end;

destructor TListBox.Destroy;
var
  i: integer;
begin
  for i := 0 to FFonts.Count - 1 do
    if FFonts[i] <> nil then
      TFont(FFonts[i]).Free;

  FFonts.Free;
  FColors.Free;

  inherited;
end;

procedure TListBox.DoEnter;
begin

  if Assigned(FOnFocus) then
    FOnFocus(Self);

  inherited;
end;

procedure TListBox.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);

  inherited;
end;

procedure TListBox.DrawItem(Index: integer; Rect: TRect;
  State: TOwnerDrawState);
var
  MyColor, MyFontColor: TColor;
  H: integer;
  ItemHeight: integer;
begin

  if (not BorderSelected) and (odFocused in State) then
  begin
    DrawFocusRect(Canvas.Handle, Rect);
    exit;
  end;

  if FReadOnly then
  begin
    MyColor := Color;
    MyFontColor := Font.Color;
  end
  else
  begin
    MyColor := Canvas.Brush.Color;
    MyFontColor := Canvas.Font.Color;
  end;

  if not(odSelected in State) or FReadOnly then
  begin
    if (Index + 1) mod 2 = 0 then
    begin
      if (FTwoColor <> clNone) then
        MyColor := TwoColor;

      if (FTwoFontColor <> clNone) then
        MyFontColor := TwoFontColor;
    end;

    if (FColors.Count > Index) and (TColor(FColors[Index]) <> clNone) then
    begin
      MyColor := TColor(FColors[Index]);
    end;
  end;

  Canvas.Pen.Style := psClear;
  Canvas.Brush.Color := MyColor;
  Canvas.FillRect(Rect);

  if (FFonts.Count > Index) and (FFonts[Index] <> nil) then
  begin
    MyFontColor := Canvas.Font.Color;
    Canvas.Font.Assign(TFont(FFonts[Index]));
    if (odSelected in State) and not FReadOnly then
      Canvas.Font.Color := MyFontColor;
  end
  else
    Canvas.Font.Color := MyFontColor;

  if Self.ItemHeight > 0 then
    ItemHeight := Self.ItemHeight
  else
    ItemHeight := Canvas.TextHeight(Items[Index]);

  H := Rect.Top + ItemHeight div 2 - Canvas.TextHeight(Items[Index]) div 2;

  case FAlignment of
    taLeftJustify:
      Canvas.TextOut(Rect.Left + MarginLeft, H, Items[Index]);
    taRightJustify:
      Canvas.TextOut(Rect.Right - MarginLeft - Canvas.TextWidth(Items[Index]),
        H, Items[Index]);
    taCenter:
      Canvas.TextOut(Rect.Left + ((Rect.Right - Rect.Left) div 2) -
        (Canvas.TextWidth(Items[Index]) div 2), H, Items[Index]);
  end;
end;

procedure TListBox.ClearColor(Index: integer);
begin
  if (FColors.Count > Index) and (Index > -1) then
    FColors[Index] := Pointer(clNone);
end;

procedure TListBox.ClearFont(Index: integer);
begin
  if (Index > Items.Count - 1) or (Index < 0) or (Index > FFonts.Count - 1) then
    exit;

  if (FFonts[Index] <> nil) then
    TFont(FFonts[Index]).Free;

  FFonts[Index] := nil;
  Invalidate;
end;

function TListBox.GetColor(Index: integer): TColor;
begin
  if (FColors.Count > Index) and (Index > -1) then
    Result := TColor(FColors[Index])
  else
    Result := clNone;
end;

function TListBox.GetFont(Index: integer): TFont;
var
  Font: TFont;
  i: integer;
begin

  if Items.Count < FFonts.Count then
  begin
    for i := FFonts.Count - 1 downto Items.Count do
    begin
      if FFonts[i] <> nil then
        TFont(FFonts[i]).Free;

      FFonts.Delete(i);
    end;
  end;

  if (Index > Items.Count - 1) or (Index < 0) then
  begin
    Result := nil;
    exit;
  end;

  if Index > FFonts.Count - 1 then
  begin
    Font := TFont.Create;
    Font.Assign(Self.Font);
    for i := FFonts.Count to Index - 1 do
    begin
      FFonts.Add(nil);
    end;
    FFonts.Add(Font);
    Result := Font;
    exit;
  end;

  if FFonts[Index] = nil then
  begin
    Font := TFont.Create;
    Font.Assign(Self.Font);
    FFonts[Index] := Font;
    Result := Font;
  end
  else
    Result := FFonts[Index];
end;

procedure TListBox.SetMarginLeft(const Value: integer);
begin
  FMarginLeft := Value;
  Invalidate;
end;

procedure TListBox.SetReadOnly(const Value: boolean);
begin
  FReadOnly := Value;
  ItemIndex := -1;
end;

procedure TListBox.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

procedure TListBox.SetBorderSelected(const Value: boolean);
begin
  FBorderSelected := Value;
  Invalidate;
end;

procedure TListBox.SetColor(Index: integer; Color: TColor);
var
  i: integer;
begin
  if (Index < 0) or (Index > Items.Count - 1) then
    exit;

  for i := FColors.Count to Items.Count - 1 do
    FColors.Add(Pointer(clNone));

  FColors[Index] := Pointer(Color);
  Invalidate;
end;

procedure TListBox.SetTwoColor(const Value: TColor);
begin
  FTwoColor := Value;
  Invalidate;
end;

procedure TListBox.SetTwoFontColor(const Value: TColor);
begin
  FTwoFontColor := Value;
  Invalidate;
end;

{ TCheckBox }

constructor TCheckBox.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TCheckBox.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);

  inherited;
end;

procedure TCheckBox.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);

  inherited;
end;

{ TComboBox }
constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TComboBox.DoEnter;
begin
  if Assigned(FOnFocus) then
    FOnFocus(Self);

  inherited;
end;

procedure TComboBox.DoExit;
begin
  if Assigned(FOnBlur) then
    FOnBlur(Self);

  inherited;
end;
{ TTransparentPanel }

constructor TTransparentPanel.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque];
end;

procedure TTransparentPanel.CreateParams(Var Params: TCreateParams);
begin
  Inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
end;

procedure TTransparentPanel.WMEraseBkGnd(Var Message: TWMEraseBkGnd);
begin
    {Do Nothing}
    Message.Result := 1;
end;
procedure TTransparentPanel.Paint;
Begin
Canvas.Brush.Style := bsClear;
end;

procedure TTransparentPanel.SetParent(AParent: TWinControl);
begin
  Inherited SetParent(AParent);
  {The trick needed to make it all work! I don't know if changing the parent's
  style is a good idea, but it only removes the WS_CLIPCHILDREN style which
  shouldn't cause any problems.}
  if Parent <> Nil then
    SetWindowLong(
      Parent.Handle,
      GWL_STYLE,
      GetWindowLong(Parent.Handle, GWL_STYLE) And Not WS_ClipChildren
    );
end;

procedure TTransparentPanel.Invalidate;
var
  Rect:TRect;
begin
  Rect := BoundsRect;
    if (Parent <> Nil) and Parent.HandleAllocated then
      InvalidateRect(Parent.Handle, @Rect, True)
    else
      Inherited Invalidate;
end;
{ TForm }

{ TDropFilesInfo }
{
constructor TDropFilesInfo.Create;
begin
  inherited;
  FFiles := TStringList.Create;
end;

destructor TDropFilesInfo.Destroy;
begin
  FreeAndNil(FFiles);
  inherited;
end;

procedure TDropFilesInfo.Assign(Source: TPersistent);
begin
  if Source is TDropFilesInfo then
  begin
    FControl := TDropFilesInfo(Source).Control;
    FStamp := TDropFilesInfo(Source).Stamp;
    FPoint := TDropFilesInfo(Source).Point;
    FFiles.Assign(TDropFilesInfo(Source).Files);
  end
  else
    inherited Assign(Source);
end;

{ TDropFilesTarget }

constructor TDropFilesTarget.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.OnDrop  := Self.hOnDrop;
  Self.DragTypes := [dtMove, dtCopy];
  Self.Target := TWinControl( AOwner );
end;
procedure TDropFilesTarget.setOnDropFiles(AEvent: TDropFilesEvent);
begin
  FOnDropFiles := AEvent;
end;
procedure TDropFilesTarget.TestOnDrop(Sender: TObject; Files: TUnicodeStrings; X: integer;
    Y: integer);
begin
  ShowMessage('It works!');
end;
procedure TDropFilesTarget.hOnDrop(Sender: TObject; ShiftState: TShiftState;
    APoint: TPoint; var Effect: Longint);
Begin

  if Assigned(FOnDropFiles) then
  begin
   FOnDropFiles(Sender, Files, APoint.X, APoint.Y);
  end;
End;
{
destructor TDropFilesTarget.Destroy;
begin
  TargetControl := nil; // This detaches any attached control
  inherited;
end;

procedure TDropFilesTarget.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if Operation = opRemove then
    if AComponent = FTargetControl then
      TargetControl := nil;
end;

{ Do the dropping. Note that DragFinish is called in the window
  procedure and not here.
}    {
procedure TDropFilesTarget.DropFiles(hDrop: hDrop);
var
  Info: TDropFilesInfo;
  Count, Index, Len: integer;
  fileName: PChar;
begin
  Info := TDropFilesInfo.Create;
  try
    Info.FStamp := Now;
    Info.FControl := FTargetControl;
    DragQueryPoint(hDrop, Info.FPoint);

    Count := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
    for Index := 0 to Count - 1 do
    begin
      Len := DragQueryFile(hDrop, Index, nil, 0);
      fileName := AllocMem(Len + 1);
      try
        DragQueryFile(hDrop, Index, fileName, Len + 1);
        TStringList(Info.FFiles).Add(StrPas(fileName));
      finally
        FreeMem(fileName);
      end;
    end;

    FOnDropFiles(Self, Info.FFiles, Info.Point.X, Info.Point.Y);
  finally
    Info.Free;
  end;
end;

{ The new Window procedure for the attached drop target control.
}     {
procedure TDropFilesTarget.NewWndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
  begin
    try
      if Assigned(FOnDropFiles) then
        DropFiles(Msg.WParam);
    finally
      DragFinish(Msg.WParam);
    end;
    Msg.Result := 0;
  end
  else
  begin
    if Msg.Msg = WM_DESTROY then
      if FAcceptingWindow <> 0 then
        // Don't clear FAcceptingWindow
        DragAcceptFiles(FAcceptingWindow, False);

    FOldWndProc(Msg);

    if Msg.Msg = WM_CREATE then
      // Make it believe the window handle must be refreshed
      FAcceptingWindow := 0;

    if FTargetControl.HandleAllocated then
      if FAcceptingWindow <> FTargetControl.Handle then
      begin
        FAcceptingWindow := FTargetControl.Handle;
        DragAcceptFiles(FAcceptingWindow, True);
      end;
  end;
end;

{ Attach to FTargetControl: subclass, force a window handle and call
  DragAcceptFiles with Accept=true.
}      {
procedure TDropFilesTarget.AttachControl;
begin
  if [csDesigning, csDestroying] * ComponentState <> [] then
    exit;

  if (FTargetControl = nil) or (not FEnabled) then
    exit;

  if [csDesigning, csDestroying] * FTargetControl.ComponentState <> [] then
    exit;

  FOldWndProc := FTargetControl.WindowProc;
  FTargetControl.WindowProc := NewWndProc;

  // Note: If we don't force a handle here we get problems with controls
  // that call ReCreateWnd before they even got a handle (-> RichEdit).
  FTargetControl.HandleNeeded;
  FAcceptingWindow := FTargetControl.Handle;
  DragAcceptFiles(FAcceptingWindow, True);
end;

{ Detach from FTargetControl: call DragAcceptFiles with Accept=false and
  remove subclassing.
}       {
procedure TDropFilesTarget.DetachControl;
begin
  if FAcceptingWindow <> 0 then
  begin
    DragAcceptFiles(FAcceptingWindow, False);
    FAcceptingWindow := 0;
  end;

  if @FOldWndProc <> nil then
  begin
    FTargetControl.WindowProc := FOldWndProc;
    FOldWndProc := nil;
  end;
end;

procedure TDropFilesTarget.SetEnabled(AEnabled: boolean);
begin
  if FEnabled <> AEnabled then
  begin
    DetachControl;
    FEnabled := AEnabled;
    AttachControl;
  end;
end;

procedure TDropFilesTarget.SetTargetControl(AControl: TWinControl);
begin
  if FTargetControl <> AControl then
  begin
    DetachControl;

    if FTargetControl <> nil then
      FTargetControl.RemoveFreeNotification(Self);

    FTargetControl := AControl;

    if FTargetControl <> nil then
      FTargetControl.FreeNotification(Self);

    AttachControl;
  end;
end;

{ TComponentLabel }

constructor TComponentLabel.Create(AOwner: TComponent);
begin
  inherited;
  Width := 1;
  Height := 1;
end;

procedure TComponentLabel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_NOPARENTNOTIFY;
end;

destructor TComponentLabel.Destroy;
begin

  inherited;
end;

procedure TComponentLabel.Paint;
begin
  // inherited;
  Visible := FPanel.Visible;
  if not Visible then
    exit;

  Width := Canvas.TextWidth(Caption) + 2;
  Height := Canvas.TextHeight(Caption) + 2;

  Canvas.Pen.Style := psClear;
  Canvas.Pen.Width := 0;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(0, 0, Width, Height);
  Canvas.TextOut(1, 1, Caption);
end;

procedure TComponentLabel.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

{ __TNoVisual }

constructor __TNoVisual.Create(AOwner: TComponent);
begin
  inherited;
  FGlyph := TBitmap.Create;
  FLabel := TComponentLabel.Create(Self);

  FGlyph.Transparent := True;
  FGlyph.TransparentMode := tmAuto;
  realWidth := 25;
  realHeight := 25;
  Color := clBtnFace;

  Parent := TWinControl(AOwner);
end;

destructor __TNoVisual.Destroy;
begin

  // FLabel.Free;
  FGlyph.Free;
  inherited;
end;

procedure __TNoVisual.initLabel;
begin
  if Parent = nil then
    exit;

  FLabel.Parent := Self.Parent;
  FLabel.Font.Assign(Self.Font);
  FLabel.Color := Color;
  FLabel.Caption := Name;
  FLabel.FPanel := Self;
  FLabel.BringToFront;

  FLabel.Left := Round(Left + (realWidth / 2) - (FLabel.Canvas.TextWidth(Name)
    / 2) - 1);
  FLabel.Top := Top + Height + 3;
  FLabel.OnDblClick := OnDblClick;
  FLabel.OnClick := OnClick;
end;

procedure __TNoVisual.loadFromFile(fileName: string);
begin
  FfileName := fileName;
  FGlyph.loadFromFile(fileName);
end;

procedure __TNoVisual.Paint;
begin
  // if not Visible then exit;
  inherited;
  if Parent = nil then
    exit;

  Canvas.Pen.Style := psAlternate;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(0, 0, Width, Height);

  if FLabel <> nil then
  begin
    FLabel.Caption := Name;
    FLabel.Left := Round(Left + (realWidth / 2) -
      (Canvas.TextWidth(Name) / 2) - 1);
    FLabel.Top := Top + Height + 3;
    FLabel.Paint;
  end;

  if not FGlyph.Empty then
  begin
    Canvas.Draw(Round((Width / 2) - (FGlyph.Width / 2)),
      Round((Height / 2) - (FGlyph.Height / 2)), FGlyph);
  end;

end;

procedure __TNoVisual.SetCaption(const Value: string);
begin
  FCaption := Value;
  initLabel;
end;

procedure __TNoVisual.SetfileName(const Value: string);
begin
  if Value = '' then
    FGlyph.FreeImage
  else
    loadFromFile(Value);

  FfileName := '';
  initLabel;
end;

procedure __TNoVisual.SetName(const Value: TComponentName);
begin
  inherited;
  if FLabel <> nil then
  begin
    FLabel.Caption := Name;
    FLabel.Left := Round(Left + (realWidth / 2) -
      (Canvas.TextWidth(Name) / 2) - 1);
    FLabel.Top := Top + Height + 3;
    FLabel.Paint;
  end;
end;

procedure __TNoVisual.SetrealHeight(const Value: integer);
begin
  FrealHeight := Value;
  Height := Value;
  Constraints.MinHeight := Value;
  Constraints.MaxHeight := Value;
end;

procedure __TNoVisual.SetrealWidth(const Value: integer);
begin
  FrealWidth := Value;
  Width := Value;
  Constraints.MinWidth := Value;
  Constraints.MaxWidth := Value;
end;

procedure __TNoVisual.WMMove(var Msg: TWMMove);
begin
  inherited;
  initLabel;
end;

end.
