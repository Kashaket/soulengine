{
  Next Collection
  Copyright (C) 1996-2005 by Berg
  All rights reserved.

  $id:NxTBXToolBox.pas bn
}

unit NxTBXToolBox;

interface

uses
  Classes, Types, Graphics, Windows, Messages, NxClasses, NxToolBox, NxCollection,
  NxSharedDraw, TBX, TBXThemes;

type
  TThemeOptions = set of (bxDisplayBackground, bxEnableThemes);

  TNxTBXToolBox = class(TNxToolBox)
  private
    FThemeOptions: TThemeOptions;
    procedure SetThemeOptions(const Value: TThemeOptions);
  protected
    procedure DrawBackground; override;
    procedure DrawCategoryBackground(ItemRect: TRect); override;
    procedure DrawItemBackground(ItemRect: TRect; Item: TNxToolBoxItem); override;
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ThemeOptions: TThemeOptions read FThemeOptions write SetThemeOptions;
  end;

  TNxTBXButton = class(TNxButton)
  private
    FThemeOptions: TThemeOptions;
    procedure SetThemeOptions(const Value: TThemeOptions);
  protected
    procedure DrawButton(Canvas: TCanvas); override;
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ThemeOptions: TThemeOptions read FThemeOptions write SetThemeOptions;
  end;

  TNxTBXFlipPanel = class(TNxFlipPanel)
  protected
    procedure PaintBackground; override;
    procedure PaintHeader; override;
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TNxTBXAlertWindow = class(TNxAlertWindow)
  protected
    procedure DrawHeader(Rect: TRect); override;
    procedure DrawMessage(Rect: TRect); override;
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TNxTBXOutlookBar = class(TNxOutlookBar)
  protected
    procedure DrawItemFill(ItemColor: TColor; const ItemRect: TRect;
      DrawStyle: TItemDrawStyle; Orientation: TItemOrientation); override;
    procedure DrawSplitter(const SplitterRect: TRect); override;
    procedure DrawToolbar(const ToolbarRect: TRect); override;
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure Register;

implementation

uses Controls;

procedure Register;
begin
  RegisterComponents('Next TBX', [TNxTBXButton, TNxTBXFlipPanel, TNxTBXToolBox,
    TNxTBXAlertWindow, TNxTBXOutlookBar]);
end;

procedure SetItemInfo(State: string; var IInfo: TTBXItemInfo);
begin
  FillChar(IInfo, SizeOf(TTBXItemInfo), 0);
  IInfo.ViewType := TVT_NORMALTOOLBAR;
  IInfo.ItemOptions := IO_TOOLBARSTYLE or IO_APPACTIVE;
  IInfo.IsVertical := False; //set to True if you want it vertical
  if State = 'normal' then
  begin
   IInfo.Pushed := False;
   IInfo.Selected := False;
   IInfo.HoverKind := hkNone;
  end;
  if State = 'hot' then
  begin
    IInfo.Pushed := False;
    IInfo.Selected := False;
    IInfo.HoverKind := hkMouseHover;
  end;
  if State = 'down' then
  begin
    IInfo.Pushed := True;
    IInfo.Selected := True;
    IInfo.HoverKind := hkMouseHover;
  end;
  if State = 'checked' then
  begin
    IInfo.Pushed := False;
    IInfo.Selected := True;
    IInfo.HoverKind := hkNone;
  end;
  if State = 'checked-hot' then
  begin
    IInfo.Pushed := False;
    IInfo.Selected := True;
    IInfo.HoverKind := hkMouseHover;
  end;
  if State = 'checked-down' then
  begin
    IInfo.Pushed := True;
    IInfo.Selected := True;
    IInfo.HoverKind := hkMouseHover;
  end;
end;

{ TNxTBXToolBox }

constructor TNxTBXToolBox.Create(AOwner: TComponent);
begin
  inherited;
  FThemeOptions := [bxDisplayBackground, bxEnableThemes];
  AddThemeNotification(Self);
end;

destructor TNxTBXToolBox.Destroy;
begin
//  RemoveThemeNotification(Self);
  inherited;
end;

procedure TNxTBXToolBox.SetThemeOptions(const Value: TThemeOptions);
begin
  FThemeOptions := Value;
  Refresh;
end;

procedure TNxTBXToolBox.DrawBackground;
var
  ItemInfo: TTBXItemInfo;
begin
  if (bxEnableThemes in FThemeOptions) and
    (bxDisplayBackground in FThemeOptions) and
      (CurrentTheme.SolidToolbarClientArea) then
  begin
    with Canvas do
    begin
      if CurrentTheme.PaintDockBackground then
        CurrentTheme.PaintDock(Canvas, ClientRect, ClientRect, DP_TOP);
      Font.Assign(Font);
      SetItemInfo('normal', ItemInfo);
      ItemInfo.Enabled := Enabled;
      CurrentTheme.PaintFrame(Canvas, ClientRect, ItemInfo);
      Font.Color := CurrentTheme.GetItemTextColor(ItemInfo);
    end;
  end else inherited;
end;

procedure TNxTBXToolBox.DrawCategoryBackground(ItemRect: TRect);
begin
  if bxEnableThemes in FThemeOptions then
  begin
    with Canvas do
    begin
      SetClipRect(Canvas, ItemRect);
      if CurrentTheme.PaintDockBackground then
        CurrentTheme.PaintDock(Canvas, ItemRect, ItemRect, DP_TOP);
      CurrentTheme.PaintBackgnd(Canvas, ItemRect, ItemRect, ItemRect,
        CurrentTheme.GetViewColor(TVT_NORMALTOOLBAR), False, TVT_NORMALTOOLBAR);
      SetClipRect(Canvas, ClientRect);
    end;
  end else inherited;
end;

procedure TNxTBXToolBox.DrawItemBackground(ItemRect: TRect;
  Item: TNxToolBoxItem);
var
  ItemInfo: TTBXItemInfo;
begin
  ItemRect.Top := ItemRect.Top + 1;
  if bxEnableThemes in FThemeOptions then
  begin
    if Item = SelectedItem then
    begin
      if Item = FDownItem then SetItemInfo('checked-down', ItemInfo)
      else if Item = FHoverItem then SetItemInfo('checked-hot', ItemInfo)
      else SetItemInfo('checked', ItemInfo);
    end else
    begin
      if Item = FHoverItem then SetItemInfo('hot', ItemInfo)
      else if Item = FDownItem then SetItemInfo('down', ItemInfo)
      else SetItemInfo('normal', ItemInfo);
    end;
    ItemInfo.Enabled := Enabled;
    CurrentTheme.PaintButton(Canvas, ItemRect, ItemInfo);
  end else inherited;
end;

procedure TNxTBXToolBox.TBMThemeChange(var Message: TMessage);
begin
  if Message.WParam = TSC_VIEWCHANGE then Refresh;
end;

{ TNxTBXButton }

constructor TNxTBXButton.Create(AOwner: TComponent);
begin
  inherited;
  FThemeOptions := [bxDisplayBackground, bxEnableThemes];
  AddThemeNotification(Self);
end;

destructor TNxTBXButton.Destroy;
begin
  RemoveThemeNotification(Self);
  inherited;
end;

procedure TNxTBXButton.SetThemeOptions(const Value: TThemeOptions);
begin
  FThemeOptions := Value;
  Invalidate;
end;

procedure TNxTBXButton.DrawButton(Canvas: TCanvas);
var
  ItemInfo: TTBXItemInfo;
begin
  if bxEnableThemes in FThemeOptions then
  begin
    if Down then SetItemInfo('down', ItemInfo)
    else if FHover then SetItemInfo('hot', ItemInfo)
    else SetItemInfo('normal', ItemInfo);
    ItemInfo.Enabled := Enabled;
    CurrentTheme.PaintButton(Canvas, ClientRect, ItemInfo);
  end else inherited;
end;

procedure TNxTBXButton.TBMThemeChange(var Message: TMessage);
begin
  if Message.WParam = TSC_VIEWCHANGE then Refresh;
end;

{ TNxTBXFlipPanel }

constructor TNxTBXFlipPanel.Create(AOwner: TComponent);
begin
  inherited;
  AddThemeNotification(Self);
end;

destructor TNxTBXFlipPanel.Destroy;
begin
  RemoveThemeNotification(Self);
  inherited;
end;

procedure TNxTBXFlipPanel.PaintBackground;
var
  ItemInfo: TTBXItemInfo;
  BackRect: TRect;
begin
  inherited;
  BackRect := Rect(0, HeaderHeight, ClientWidth, ClientHeight);
  SetClipRect(Canvas, BackRect);
    with Canvas do
    begin
      if CurrentTheme.PaintDockBackground then
        CurrentTheme.PaintDock(Canvas, BackRect, BackRect, DP_TOP);
      Font.Assign(Font);
      SetItemInfo('normal', ItemInfo);
      ItemInfo.Enabled := Enabled;
      CurrentTheme.PaintFrame(Canvas, BackRect, ItemInfo);
      Font.Color := CurrentTheme.GetItemTextColor(ItemInfo);
    end;
  SetClipRect(Canvas, ClientRect);
end;

procedure TNxTBXFlipPanel.PaintHeader;
var
  HeaderRect: TRect;
begin
  HeaderRect := Rect(0, 0, ClientWidth, HeaderHeight);
  with Canvas do
  begin
    SetClipRect(Canvas, HeaderRect);
    if CurrentTheme.PaintDockBackground then
      CurrentTheme.PaintDock(Canvas, HeaderRect, HeaderRect, DP_TOP);
    CurrentTheme.PaintBackgnd(Canvas, HeaderRect, HeaderRect, HeaderRect,
      CurrentTheme.GetViewColor(TVT_NORMALTOOLBAR), False, TVT_NORMALTOOLBAR);
    SetClipRect(Canvas, ClientRect);
  end;
end;

procedure TNxTBXFlipPanel.TBMThemeChange(var Message: TMessage);
begin
  if Message.WParam = TSC_VIEWCHANGE then Refresh;
end;

{ TNxTBXAlertWindow }

constructor TNxTBXAlertWindow.Create(AOwner: TComponent);
begin
  inherited;
  AddThemeNotification(Self);
end;

destructor TNxTBXAlertWindow.Destroy;
begin
  RemoveThemeNotification(Self);
  inherited;
end;

procedure TNxTBXAlertWindow.DrawHeader(Rect: TRect);
begin
  case BackgroundStyle of
    btAuto:
    begin
      SetClipRect(Canvas, Rect);
      CurrentTheme.PaintBackgnd(Canvas, Rect, Rect, Rect,
        CurrentTheme.GetViewColor(TVT_NORMALTOOLBAR), False, TVT_NORMALTOOLBAR);
      SetClipRect(Canvas, ClientRect);
    end;
    else inherited;
  end;
end;

procedure TNxTBXAlertWindow.DrawMessage(Rect: TRect);
var
  R: TRect;
begin
  case BackgroundStyle of
    btAuto:
    begin
      R := Rect;
     // R.Bottom := FixedHeight;
      SetClipRect(Canvas, R);
      CurrentTheme.PaintBackgnd(Canvas, R, R, R,
        CurrentTheme.GetViewColor(TVT_NORMALTOOLBAR), False, TVT_NORMALTOOLBAR);
      SetClipRect(Canvas, ClientRect);
    end;
    else inherited;
  end;
end;

procedure TNxTBXAlertWindow.TBMThemeChange(var Message: TMessage);
begin
  if Message.WParam = TSC_VIEWCHANGE then Refresh;
end;

{ TNxTBXOutlookBar }

constructor TNxTBXOutlookBar.Create(AOwner: TComponent);
begin
  inherited;
  AddThemeNotification(Self);
end;

destructor TNxTBXOutlookBar.Destroy;
begin
  RemoveThemeNotification(Self);
  inherited;
end;

procedure TNxTBXOutlookBar.DrawItemFill(ItemColor: TColor; const ItemRect: TRect;
  DrawStyle: TItemDrawStyle; Orientation: TItemOrientation);
var
  R: TRect;
  ItemInfo: TTBXItemInfo;
begin
  R := ItemRect;
  if (Orientation = irHorizontal) and (DrawStyle = []) then Exit;
  SetClipRect(Canvas, R);

  if dsDown in DrawStyle then
  begin
    SetItemInfo('checked-down', ItemInfo);
      ItemInfo.Enabled := Enabled;
    CurrentTheme.PaintButton(Canvas, ItemRect, ItemInfo);
  end else if dsHover in DrawStyle then
  begin
    if dsSelected in DrawStyle then
    begin
      SetItemInfo('checked-down', ItemInfo);
    end else
    begin
      SetItemInfo('hot', ItemInfo);
    end;
    ItemInfo.Enabled := Enabled;
    CurrentTheme.PaintButton(Canvas, ItemRect, ItemInfo);
  end else
  begin
    if dsSelected in DrawStyle then
    begin
      SetItemInfo('checked-hot', ItemInfo);
      ItemInfo.Enabled := Enabled;
      CurrentTheme.PaintButton(Canvas, ItemRect, ItemInfo);
    end else
    begin
      CurrentTheme.PaintBackgnd(Canvas, R, R, R,
        CurrentTheme.GetViewColor(TVT_NORMALTOOLBAR), False, TVT_NORMALTOOLBAR);
    end;
  end;
  SetClipRect(Canvas, ClientRect);
end;

procedure TNxTBXOutlookBar.DrawSplitter(const SplitterRect: TRect);
begin
  CurrentTheme.PaintBackgnd(Canvas, SplitterRect, SplitterRect, SplitterRect,
    CurrentTheme.GetViewColor(TVT_NORMALTOOLBAR), False, TVT_NORMALTOOLBAR);
  DrawGrips(Canvas, SplitterRect, 5, orHorizontal, ColorScheme);
end;

procedure TNxTBXOutlookBar.DrawToolbar(const ToolbarRect: TRect);
begin
  SetClipRect(Canvas, ToolbarRect);
  CurrentTheme.PaintBackgnd(Canvas, ToolbarRect, ToolbarRect, ToolbarRect,
    CurrentTheme.GetViewColor(TVT_NORMALTOOLBAR), False, TVT_NORMALTOOLBAR);
  SetClipRect(Canvas, ClientRect);
end;

procedure TNxTBXOutlookBar.TBMThemeChange(var Message: TMessage);
begin
  if Message.WParam = TSC_VIEWCHANGE then Refresh;
end;

end.
