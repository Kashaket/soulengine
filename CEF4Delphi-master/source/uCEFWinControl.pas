// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright © 2018 Salvador Diaz Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit uCEFWinControl;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$IFNDEF CPUX64}
  {$ALIGN ON}
  {$MINENUMSIZE 4}
{$ENDIF}

{$I cef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    {$IFDEF MSWINDOWS}WinApi.Windows, {$ENDIF}Forms, Messages,
    Themes, System.Classes, Vcl.Controls, Vcl.Graphics,
  {$ELSE}
    {$IFDEF MSWINDOWS}Windows,{$ENDIF} Classes, Forms, Controls, Graphics,
    {$IFDEF FPC}
    LCLProc, LCLType, LCLIntf, LResources, InterfaceBase,
    {$ENDIF}
  {$ENDIF}
  uCEFTypes, uCEFInterfaces;

type
  TCEFWinControl = class(TScrollingWinControl)
    protected
      function  GetChildWindowHandle : THandle; virtual;
      procedure Resize; override;

    public
      function  TakeSnapshot(var aBitmap : TBitmap) : boolean;
      function  DestroyChildWindow : boolean;
      procedure CreateHandle; override;
      procedure UpdateSize;

      property  ChildWindowHandle : THandle   read GetChildWindowHandle;

    published
      property  Align;
      property  Anchors;
      property  Color;
      property  Constraints;
      property  TabStop;
      property  TabOrder;
      property  Visible;
      property  Enabled;
      property  ShowHint;
      property  Hint;
      property  OnResize;
      property  DoubleBuffered;
      {$IFDEF DELPHI12_UP}
      property  ParentDoubleBuffered;
      {$ENDIF}
  end;
  TCEFScrollBox = class(TCEFWinControl)
  private
    FBorderStyle: TBorderStyle;
    {$IFNDEF FPC}
    class constructor Create;
    class destructor Destroy;
    procedure SetBorderStyle(Value: TBorderStyle);
    {$ENDIF}
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    {$IFNDEF FPC}
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    {$ENDIF}
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintWindow(DC: HDC); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoScroll default True;
    property AutoSize;
    {$IFDEF FPC}
    property BorderSpacing;
    {$ELSE}
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    {$ENDIF}
    property BiDiMode;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Color nodefault;
    {$IFNDEF FPC}
    property Ctl3D;
    {$ENDIF}
    property Font;
    {$IFNDEF FPC}
    property Padding;
    {$ENDIF}
    property ParentBiDiMode;
    property ParentBackground default False;
    property ParentColor;
    {$IFNDEF FPC}
    property ParentCtl3D;
    {$ENDIF}
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    {$IFNDEF FPC}
    property Touch;
    property StyleElements;
    property OnCanResize;
    {$ENDIF}
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFNDEF FPC}
    property OnGesture;
    {$ENDIF}
    property OnGetSiteInfo;
    {$IFNDEF FPC}
    property OnMouseActivate;
    {$ENDIF}
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;
implementation

uses
  uCEFMiscFunctions, uCEFClient, uCEFConstants;

function TCEFWinControl.GetChildWindowHandle : THandle;
begin
  if not(csDesigning in ComponentState) and HandleAllocated then
    Result := GetWindow(Handle, GW_CHILD)
   else
    Result := 0;
end;

procedure TCEFWinControl.CreateHandle;
begin
  inherited CreateHandle;
end;

procedure TCEFWinControl.UpdateSize;
var
  TempRect : TRect;
  TempHWND : THandle;
begin
  TempHWND := ChildWindowHandle;
  if (TempHWND = 0) then exit;

  TempRect := GetClientRect;

  SetWindowPos(TempHWND, 0,
               0, 0, TempRect.right, TempRect.bottom,
               SWP_NOZORDER);
end;

function TCEFWinControl.TakeSnapshot(var aBitmap : TBitmap) : boolean;
var
  TempHWND   : HWND;
  TempDC     : HDC;
  TempRect   : TRect;
  TempWidth  : Integer;
  TempHeight : Integer;
begin
  Result := False;
  if (aBitmap = nil) then exit;

  TempHWND := ChildWindowHandle;
  if (TempHWND = 0) then exit;

  {$IFDEF DELPHI16_UP}Winapi.{$ENDIF}Windows.GetClientRect(TempHWND, TempRect);
  TempDC     := GetDC(TempHWND);
  TempWidth  := TempRect.Right  - TempRect.Left;
  TempHeight := TempRect.Bottom - TempRect.Top;

  aBitmap        := TBitmap.Create;
  aBitmap.Height := TempHeight;
  aBitmap.Width  := TempWidth;

  Result := BitBlt(aBitmap.Canvas.Handle, 0, 0, TempWidth, TempHeight,
                   TempDC, 0, 0, SRCCOPY);

  ReleaseDC(TempHWND, TempDC);
end;

function TCEFWinControl.DestroyChildWindow : boolean;
var
  TempHWND : HWND;
begin
  TempHWND := ChildWindowHandle;
  Result   := (TempHWND <> 0) and DestroyWindow(TempHWND);
end;

procedure TCEFWinControl.Resize;
begin
  inherited Resize;

  UpdateSize;
end;
{ TCEFScrollBox }
{$IFNDEF FPC}
class constructor TCEFScrollBox.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TCEFScrollBox, TScrollBoxStyleHook);
end;
{$ENDIF}
constructor TCEFScrollBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks{$IFNDEF FPC}, csPannable, csGestures{$ENDIF}];
  AutoScroll := True;
  Width := 185;
  Height := 41;
  FBorderStyle := bsSingle;
end;
{$IFNDEF FPC}
class destructor TCEFScrollBox.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TCEFScrollBox, TScrollBoxStyleHook);
end;
{$ENDIF}
procedure TCEFScrollBox.CMVisibleChanged(var Message: TMessage);
begin
  inherited;
  if Visible then
    UpdateSize;
end;

procedure TCEFScrollBox.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls {$IFNDEF FPC}and Ctl3D{$ENDIF} and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;
{$IFNDEF FPC}
procedure TCEFScrollBox.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;
{$ENDIF}
procedure TCEFScrollBox.WMNCHitTest(var Message: TWMNCHitTest);
begin
  DefaultHandler(Message);
end;
{$IFNDEF FPC}
procedure TCEFScrollBox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;
{$ENDIF}
procedure TCEFScrollBox.PaintWindow(DC: HDC);
begin
  //  Do nothing
end;
end.
