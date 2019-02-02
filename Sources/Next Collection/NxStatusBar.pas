unit NxStatusBar;

interface

uses
  Classes, Types, Controls, Graphics,
  NxThemesSupport;

type
  TNxStatusPanel = class;

  TNxPanelPainter = class
  private
    FCanvas: TCanvas;
    FClientRect: TRect;
    FPanel: TNxStatusPanel;
  protected
    procedure Paint; virtual;
    property Canvas: TCanvas read FCanvas write FCanvas;
    property ClientRect: TRect read FClientRect write FClientRect;
  public
    constructor Create(AOwner: TNxStatusPanel);
  end;

  TNxTextPanelPainter = class(TNxPanelPainter)
  protected
    procedure Paint; override;
  end;

  TNxPanelPainterClass = class of TNxPanelPainter;

  TNxStatusPanel = class(TComponent)
  private
    FPainter: TNxPanelPainter;
    FWidth: Integer;
  protected
    function GetPainterClass: TNxPanelPainterClass; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Width: Integer read FWidth write FWidth default 50;
  end;

  TNxStatusPanelClass = class of TNxStatusPanel;

  TNxTextStatusPanel = class(TNxStatusPanel)
  private
    FText: WideString;
    FAlignment: TAlignment;
    procedure SetText(const Value: WideString);
    procedure SetAlignment(const Value: TAlignment);
  protected
    function GetPainterClass: TNxPanelPainterClass; override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Text: WideString read FText write SetText;
  end;

  TNxStatusBar = class;

  TNxStatusBarPanels = class
  private
    FList: TList;
    FStatusBar: TNxStatusBar;
    function GetCount: Integer;
    function GetItem(Index: Integer): TNxStatusPanel;
  protected
    procedure AddPanel(Panel: TNxStatusPanel);
  public
    function Add(StatusPanelClass: TNxStatusPanelClass): TNxStatusPanel;
    constructor Create(StatusBar: TNxStatusBar);
    destructor Destroy; override;
    procedure Clear;
    property Count: Integer read GetCount;
    property Item[Index: Integer]: TNxStatusPanel read GetItem; default;
  end;

  TNxStatusBar = class(TCustomControl)
  private
    FPanels: TNxStatusBarPanels;
    FColorScheme: TColorScheme;
    procedure SetColorScheme(const Value: TColorScheme);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetPanelRect(const Index: Integer): TRect;
  published
    property Align;
    property ColorScheme: TColorScheme read FColorScheme write SetColorScheme default csDefault;
    property Constraints;
    property Panels: TNxStatusBarPanels read FPanels;
  end;

implementation

uses
  SysUtils, ExtCtrls,
  NxSharedCommon, NxSharedDraw;

{ TNxPanelPainter }

constructor TNxPanelPainter.Create(AOwner: TNxStatusPanel);
begin

end;

procedure TNxPanelPainter.Paint;
var
  FromColor, ToColor: TColor;
begin
  FromColor := SchemeColor(seBtnFaceDark, ColorScheme);
  ToColor := SchemeColor(seBtnFace, ColorScheme);
  DrawVertGlass(Canvas, FClientRect, FromColor, ToColor, FClientRect.Bottom div 3);
end;

{ TNxTextPanelPainter }

procedure TNxTextPanelPainter.Paint;
begin
  inherited;
  with FPanel as TNxTextStatusPanel do
  begin
    DrawText(FCanvas, FClientRect, FAlignment, FText);
  end;
end;

{ TNxStatusPanel }

constructor TNxStatusPanel.Create(AOwner: TComponent);
begin
  inherited;
  FPainter := GetPainterClass.Create(Self);
  FWidth := 50;
end;

function TNxStatusPanel.GetPainterClass: TNxPanelPainterClass;
begin
  Result := TNxPanelPainter;
end;

{ TNxTextStatusPanel }

function TNxTextStatusPanel.GetPainterClass: TNxPanelPainterClass;
begin
  Result := TNxTextPanelPainter;
end;

procedure TNxTextStatusPanel.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
end;

procedure TNxTextStatusPanel.SetText(const Value: WideString);
begin
  FText := Value;
end;

{ TNxStatusBarPanels }

function TNxStatusBarPanels.Add(
  StatusPanelClass: TNxStatusPanelClass): TNxStatusPanel;
begin
  Result := StatusPanelClass.Create(nil);
  AddPanel(Result);
end;

procedure TNxStatusBarPanels.AddPanel(Panel: TNxStatusPanel);
begin
  FList.Add(Panel);
  Panel.FPainter.FCanvas := FStatusBar.Canvas;
end;

procedure TNxStatusBarPanels.Clear;
var
  i: Integer;
begin
  for i := 0 to Pred(FList.Count) do
    TNxStatusPanel(FList[0]).Free;
  FList.Clear;
end;

constructor TNxStatusBarPanels.Create(StatusBar: TNxStatusBar);
begin
  FList := TList.Create;
  FStatusBar := StatusBar;
end;

destructor TNxStatusBarPanels.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TNxStatusBarPanels.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TNxStatusBarPanels.GetItem(Index: Integer): TNxStatusPanel;
begin
  Result := TNxStatusPanel(FList[Index]);
end;

{ TNxStatusBar }

constructor TNxStatusBar.Create(AOwner: TComponent);
begin
  inherited;
  FColorScheme := csDefault;
  FPanels := TNxStatusBarPanels.Create(Self);
end;

destructor TNxStatusBar.Destroy;
begin
  FreeAndNil(FPanels);
  inherited;
end;

function TNxStatusBar.GetPanelRect(const Index: Integer): TRect;
var
  i, Pos: Integer;
begin
  Pos := 0;
  for i := 0 to Pred(Index) do
  begin
    Inc(Pos, FPanels.Item[i].Width);
  end;
  Result := Rect(Pos, 0, Pos + FPanels.Item[Index].Width, ClientHeight);
end;

procedure TNxStatusBar.Paint;
var
  i: Integer;
begin
  inherited;
  for i := 0 to Pred(FPanels.Count) do
  begin
    FPanels[i].FPainter.ClientRect := GetPanelRect(i);
    FPanels[i].FPainter.Paint;
  end;
end;

procedure TNxStatusBar.SetColorScheme(const Value: TColorScheme);
begin
  FColorScheme := Value;
end;

end.
