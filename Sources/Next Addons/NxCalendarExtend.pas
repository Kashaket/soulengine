{
  Copyright (C) 2009 by Ronny Hößrich
  All rights reserved.

  $id:NxCalendarExtend.pas 25.07.2009
}

unit NxCalendarExtend;

interface

uses
	Types, Classes, Controls, Windows, Graphics, StdCtrls, ExtCtrls,
  Messages, Forms, Dialogs, ExtDlgs, ImgList, RTLConsts, Menus,
  ComCtrls, // for TUpDown
  NxClasses, NxConsts, NxStdCtrls, NxPopupControl, NxThemesSupport,
  NxSharedDraw, NxSharedCommon, NxEdit;

const
  sizExecuteButton = 21;
  sizFastInterval = 20;
  sizSlowInterval = 400;
  crReversedArrow = 1000;
  spGlyphIndent = 2;

  { Space between checkbox and text }
  spChkBoxTextIndent = 4;
  spBorder = 6;

  strNone = 'None';
  strToday = 'Today';
type
  {$IFDEF DELPHI_UNICODE}
  THintInfo = Controls.THintInfo;
  PHintInfo = Controls.PHintInfo;
  {$ENDIF}

  TDayStr = string;
  TMonthStr = string;
  TWeekendBool = Boolean;

  TCalBorderStyle = (cbsNone, cbsSolid);

  TNxMonthCalendarExt = class;

  TCalEvent = class(TPersistent)
  public
    Color: TColor;
    ColorChg: Boolean;
    EventDate: TDate;
    EventText: String;
    EventID: String;
    constructor Create;
    destructor Destroy; override;
  end;

  TCalEvents = class(TPersistent)
  private
    FCalEvents: Array of TCalEvent;
    FEventDefaultColor: TColor;
    procedure SetEventDefaultColor(const Value: TColor);
  public
    constructor Create;
    destructor Destroy; override;
    function AddEvent(fDate: TDate; fEvent: String): Integer;
    procedure ClearEvents;
    function Count(): Integer;
    function CountEvents(Value: TDate): Integer;
    procedure DelEvent(fDate: TDate);
    procedure GetEventStringList(date: TDate; slist: TStringList);
    function HasEvent(Value: TDate): Boolean;
    function GetEventDayColor(Value: TDate): TColor;
    procedure SetEventDayColor(const Value: TDate; edColor: TColor);
    property EventDefaultColor: TColor read FEventDefaultColor write SetEventDefaultColor;
    procedure ResetEventColors();
  end;

  TMonthNames = class(TPersistent)
  private
    FJanuary: TMonthStr;
    FFebruary: TMonthStr;
    FMarch: TMonthStr;
    FApril: TMonthStr;
    FMay: TMonthStr;
    FJune: TMonthStr;
    FJuly: TMonthStr;
    FAugust: TMonthStr;
    FSeptember: TMonthStr;
    FOctober: TMonthStr;
    FNovember: TMonthStr;
    FDecember: TMonthStr;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function GetMonth(i: integer): string;
  published
    property January: TMonthStr read FJanuary write FJanuary;
    property February: TMonthStr read FFebruary write FFebruary;
    property March: TMonthStr read FMarch write FMarch;
    property April: TMonthStr read FApril write FApril;
    property May: TMonthStr read FMay write FMay;
    property June: TMonthStr read FJune write FJune;
    property July: TMonthStr read FJuly write FJuly;
    property August: TMonthStr read FAugust write FAugust;
    property September: TMonthStr read FSeptember write FSeptember;
    property October: TMonthStr read FOctober write FOctober;
    property November: TMonthStr read FNovember write FNovember;
    property December: TMonthStr read FDecember write FDecember;
  end;

  TDayNames = class(TPersistent)
  private
    FMonday: TDayStr;
    FTuesday: TDayStr;
    FWednesday: TDayStr;
    FThursday: TDayStr;
    FFriday: TDayStr;
    FSaturday: TDayStr;
    FSunday: TDayStr;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function GetDay(i: integer): string;
  published
    property Monday: TDayStr read FMonday write FMonday;
    property Tuesday: TDayStr read FTuesday write FTuesday;
    property Wednesday: TDayStr read FWednesday write FWednesday;
    property Thursday: TDayStr read FThursday write FThursday;
    property Friday: TDayStr read FFriday write FFriday;
    property Saturday: TDayStr read FSaturday write FSaturday;
    property Sunday: TDayStr read FSunday write FSunday;
  end;

  TWeekendDays = class(TPersistent)
  private
    Owner: TNxMonthCalendarExt;
    FMonday: TWeekendBool;
    FTuesday: TWeekendBool;
    FWednesday: TWeekendBool;
    FThursday: TWeekendBool;
    FFriday: TWeekendBool;
    FSaturday: TWeekendBool;
    FSunday: TWeekendBool;
    procedure SetWeekend(const Index: Integer; const Value: TWeekendBool);
  protected
  public
    constructor Create(AOwner: TNxMonthCalendarExt);
    destructor Destroy; override;
    function GetDay(i: integer): Boolean;
  published
    property Monday: TWeekendBool index 0 read FMonday write SetWeekend;
    property Tuesday: TWeekendBool index 1 read FTuesday write SetWeekend;
    property Wednesday: TWeekendBool index 2 read FWednesday write SetWeekend;
    property Thursday: TWeekendBool index 3 read FThursday write SetWeekend;
    property Friday: TWeekendBool index 4 read FFriday write SetWeekend;
    property Saturday: TWeekendBool index 5 read FSaturday write SetWeekend;
    property Sunday: TWeekendBool index 6 read FSunday write SetWeekend;
  end;

  TCalMonthColors = class(TPersistent)
  private
    Owner: TNxMonthCalendarExt;
    FTextColor: TColor;
    FTextColorLight: TColor;
    FWeekendColor : TColor;
    FWeekendColorLight: TColor;
    FHeaderColor: TColor;
    FHeaderButtonColor: TColor;
    FWeekDayColor: TColor;
    FWeekNumberColor: TColor;
    FTodayCircleColor: TColor;
    FSelectColor: TColor;
    FBorderColor: TColor;
    FEventDefaultColor: TColor;
    FSelectColorFont: TColor;
    procedure SetColor(Index: Integer; Value: TColor);
    procedure SetAllColors;
  public
    constructor Create(AOwner: TNxMonthCalendarExt);
    procedure Assign(Source: TPersistent); override;
  published
    property TextColor: TColor index 0 read FTextColor write SetColor default clBlack;
    property WeekendColor: TColor index 1 read FWeekendColor write SetColor default clRed;
    property HeaderColor: TColor index 2 read FHeaderColor write SetColor default clBtnFace;
    property HeaderButtonColor: TColor index 3 read FHeaderButtonColor write SetColor default clBlack;
    property WeekDayColor: TColor index 4 read FWeekDayColor write SetColor default clBlue;
    property WeekNumberColor: TColor index 5 read FWeekNumberColor write SetColor default clBlue;
    property TodayCircleColor: TColor index 6 read FTodayCircleColor write SetColor default clHighlight;
    property SelectColor: TColor index 7 read FSelectColor write SetColor default clTeal;
    property BorderColor: TColor index 8 read FBorderColor write SetColor default clGrayText;
    property EventDefaultColor: TColor index 9 read FEventDefaultColor write SetColor default clMoneyGreen;
    property SelectColorFont: TColor index 10 read FSelectColorFont write SetColor default clNone;
  end;

  TNxMonthCalendarExtOptions = set of (
    opOtherMonthColor,
    opButtonNone,
    opButtonToday,
    opSelectWithRMButton,
    opShowEvents,
    opShowCurrentEventsOnly,
    opShowHeader,
    opShowTodayRect,
    opShowDaySelected,
    opShowWeekNumbers,
    opBottomLine,
    opMonthAutoSwitch
  );

  TNxDayFontEvent = procedure(Sender: TObject; Day: Integer; Font: TFont) of object;

  TNxMonthCalendarExt = class(TCustomControl)
  private
    FDate: TDate;
    FDay: Word;
    FDayNames: TDayNames;
    FDown: Boolean;
    FMonth: Word;
    FMonthNames: TMonthNames;
    FNoneButton: TNxMiniButton;
    FNoneCaption: WideString;
    FOldRect: TRect;
    FOnChange: TNotifyEvent;
    FOnDayFont: TNxDayFontEvent;
		FSelectedDate: TDate;
    FStartDay: TStartDayOfWeek;
    FTodayButton: TNxMiniButton;
    FTodayCaption: WideString;
    FYear: Word;
    FWeekendDays: TWeekendDays;
    FspDateStart: Integer;
    FspDateStartY: Integer;
    FDayWidth: Integer;
    FDayHeight: Integer;
    FBorderType: TCalBorderStyle;
    FHeaderFont: TFont;
    FHeaderHeight: Integer;
    FHeaderAutoHeight: Boolean;
    FAutoSize: Boolean;
    FDayAlignment: TAlignment;
    FAutoWidthDays: Boolean;
    FMinWidthDays: Integer;
    FMinHeightDays: Integer;
    FLastWidth: Integer;
    FEvents: TCalEvents;
    FCalColors: TCalMonthColors;
    FFont: TFont;
    FDayTextPadding: Integer;
    FPopupMenu: TPopupMenu;
    FMonthRect: TRect;
    FHeadMonthRect: TRect;
    FHeadYearRect: TRect;
    FHeadYearHeight: Integer;
    FYearEdit: TNxEdit;
    FYearEditUpDown: TUpDown;
    FMonthChanged: Boolean;
    FLastSelectedDate: TDate;
    FOnSelectedEventDay: TNotifyEvent;
    FMinDate: TDate;
    FMaxDate: TDate;
    FOptions: TNxMonthCalendarExtOptions;
    function DateInRange(Value: TDate): Boolean;
    function GetActualStartDay: TStartDayOfWeek;
    function GetDateAtPos(ACol, ARow: Integer): TDate;
    function GetDayOfWeek(Day: TDateTime): Integer;
    function GetMonthName(Month: Integer): WideString;
    procedure CalcNewSizes;
    procedure DoAlignButtons;
    procedure FontChanged(Sender: TObject);
    procedure PopupClick(Sender: TObject);
    procedure OnYearEditUpDown(Sender: TObject);
    procedure SelectDate(X, Y: Integer);
    procedure SetDate(const Value: TDate);
    procedure SetDay(const Value: Word);
    procedure SetMonth(const Value: Word);
    procedure SetNoneCaption(const Value: WideString);
    procedure SetPastMonth(var AYear, AMonth: Integer; Decrease: Boolean = True);
    procedure SetSelectedDate(const Value: TDate);
    procedure SetTodayCaption(const Value: WideString);
    procedure SetYear(const Value: Word);
    procedure SetStartDay(const Value: TStartDayOfWeek);
    procedure SetDayNames(const Value: TDayNames);
    procedure SetMonthNames(const Value: TMonthNames);
    procedure SetWeekendDays(const Value: TWeekendDays);
    procedure SetBorderType(const Value: TCalBorderStyle);
    procedure SetHeaderFont(const Value: TFont);
    procedure SetHeaderAutoHeight(const Value: Boolean);
    procedure SetHeaderHeight(const Value: Integer);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetAutoSize(const Value: Boolean);
    procedure SetDayAlignment(const Value: TAlignment);
    procedure SetAutoWidthDays(const Value: Boolean);
    procedure SetCalColors(const Value: TCalMonthColors);
    procedure SetTextFont(const Value: TFont);
    procedure SetDayTextPadding(const Value: Integer);
    procedure OnYearEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DisableYearEdit;
    procedure SetMinDate(const Value: TDate);
    procedure SetMaxDate(const Value: TDate);
    procedure SetOptions(const Value: TNxMonthCalendarExtOptions);
  protected
    procedure CreateWnd; override;
    function GetDaysRect: TRect;
    function GetMonthRect: TRect;
    function GetWeekRect: TRect;
    procedure DoButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
    	X, Y: Integer);
    procedure DoChange; dynamic;
    procedure DoDayFont(Day: Integer; Font: TFont); dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure PaintDay(Year, Month, Day: Integer; DayRect: TRect);
    procedure PaintMonth(MonthRect: TRect);
    procedure RefreshMonth;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    property Font;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property NoneButton: TNxMiniButton read FNoneButton;
    property TodayButton: TNxMiniButton read FTodayButton;
    property Date: TDate read FDate write SetDate;
    function AddEvent(eDate: TDate; eText: String): TCalEvent;
    function AddEventSelected(eText: String): TCalEvent;
    function EventsCount(Value: TDate): Integer;
    function EventsCountSelected(): Integer;
    function HasEvents(): Boolean;
    function HasEvent(Value: TDate): Boolean;
    function GetEvent(const Index: Integer): TCalEvent;
    function GetEvents(const eDate: TDate; slist: TStringList): Integer;
    function GetEventDayColor(eDate: TDate): TColor;
    procedure SetEventDayColor(const eDate: TDate; edColor: TColor);
    function GetCurrentEventDayColor(): TColor;
    procedure SetCurrentEventDayColor(const edColor: TColor);
    procedure ResetEventColors();
  published
    property Align;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property AutoWidthDays: Boolean read FAutoWidthDays write SetAutoWidthDays;
    property BorderType: TCalBorderStyle read FBorderType write SetBorderType;
    property Colors: TCalMonthColors read FCalColors write SetCalColors;
    property Constraints;
		property Day: Word read FDay write SetDay;
    property DayAlignment: TAlignment read FDayAlignment write SetDayAlignment;
    property DayNames: TDayNames read FDayNames write SetDayNames;
    property DayTextPadding: Integer read FDayTextPadding write SetDayTextPadding;
    property TextFont: TFont read FFont write SetTextFont;
    property HeaderAutoHeight: Boolean read FHeaderAutoHeight write SetHeaderAutoHeight;
    property HeaderFont: TFont read FHeaderFont write SetHeaderFont;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight;
    property MinDate: TDate read FMinDate write SetMinDate;
    property MaxDate: TDate read FMaxDate write SetMaxDate;
		property Month: Word read FMonth write SetMonth;
    property MonthNames: TMonthNames read FMonthNames write SetMonthNames;
    property NoneCaption: WideString read FNoneCaption write SetNoneCaption;
    property SelectedDate: TDate read FSelectedDate write SetSelectedDate;
    property StartDay: TStartDayOfWeek read FStartDay write SetStartDay default dwAutomatic;
    property TodayCaption: WideString read FTodayCaption write SetTodayCaption;
    property Visible;
    property WeekendDays: TWeekendDays read FWeekendDays write SetWeekendDays;
    property Year: Word read FYear write SetYear;
    property Options: TNxMonthCalendarExtOptions read FOptions write SetOptions default [opOtherMonthColor, opShowDaySelected, opShowHeader, opSelectWithRMButton,opShowEvents, opShowTodayRect, opShowWeekNumbers, opBottomLine];
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnSelectedEventDay: TNotifyEvent read FOnSelectedEventDay write FOnSelectedEventDay;
    property OnClick;
    property OnContextPopup;
    property OnDayFont: TNxDayFontEvent read FOnDayFont write FOnDayFont;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  procedure Register;

implementation

uses
  DateUtils, SysUtils, ClipBrd, Math, StrUtils, NxScrollControl,
{$WARNINGS OFF}
  FileCtrl,
{$WARNINGS ON}
  ActnList;

procedure Register; 
begin
  RegisterComponents('Next Addons', [TNxMonthCalendarExt]);
end;

{ TNxMonthCalendarExt }

function TNxMonthCalendarExt.AddEvent(eDate: TDate; eText: String): TCalEvent;
var cnt : Integer;
begin
  if (eDate > 1000) then begin
    FEvents.AddEvent(eDate, eText);
    if (FEvents.CountEvents(eDate) = 1) then
      Self.Repaint;
  end;
  cnt := High(FEvents.FCalEvents);
  Result := FEvents.FCalEvents[cnt];
end;

function TNxMonthCalendarExt.AddEventSelected(eText: String): TCalEvent;
begin
  Result := AddEvent(FSelectedDate, eText);
end;

procedure TNxMonthCalendarExt.CalcNewSizes;
var
  I: Integer;
  h, w: Integer;
  oldh, oldw: Integer;
begin
  if HandleAllocated = True then begin
    Canvas.Font.Assign(FHeaderFont);
    h := 0;
    for I := 1 to 12 do begin
      oldh := Canvas.TextHeight( FMonthNames.GetMonth(I) );
      if h < oldh then
        h := oldh;
    end;
    FHeaderHeight := h + 4;
    if (opShowHeader in Options) then begin
      FMonthRect.Top := 4;
    end else begin
      FMonthRect.Top := 1;
    end;
    if (FBorderType <> cbsNone) then begin
      Inc(FMonthRect.Top,1);
    end;
    FMonthRect.Bottom := FMonthRect.Top;
    if (opShowHeader in Options) then
      Inc(FMonthRect.Bottom, FHeaderHeight);


    FspDateStartY := FMonthRect.Bottom + 2;

    Canvas.Font.Assign(FFont);
    oldw := Canvas.TextWidth('33');
    oldh := Canvas.TextHeight('33');
    for I := 1 to 7 do begin
      w := Canvas.TextWidth( FDayNames.GetDay(I) );
      h := Canvas.TextHeight( FDayNames.GetDay(I) );
      if oldw < w then oldw := w;
      if oldh < h then oldh := h;
    end;
    if oldw < w then oldw := w;
    if oldh < h then oldh := h;
    FMinWidthDays := oldw + 2 + (FDayTextPadding * 2);
    FMinHeightDays := oldh + 2;

    // calculate minimal window width
    w := (FMinWidthDays * 7) + (spBorder * 2);
    if (opShowWeekNumbers in Options) then
      Inc(w, (FMinWidthDays + 5));

    Constraints.MinWidth := w;
    if (FAutoSize = False) then begin
      Constraints.MaxWidth := 0;
      if (opShowWeekNumbers in Options) then begin
        FDayWidth := (Width - (spBorder * 2) - 5) div 8;
        w := (FDayWidth * 8) + (spBorder * 2) + 5;
        FspDateStart := ((Width - w) div 2) + spBorder + FDayWidth + 5;
      end else begin
        FDayWidth := (Width - (spBorder * 2)) div 7;
        w := (FDayWidth * 7) + (spBorder * 2);
        FspDateStart := ((Width - w) div 2) + spBorder;
      end;
    end else if (FAutoSize = True) then begin
      FDayWidth := FMinWidthDays;
      Constraints.MaxWidth := w;
      FspDateStart := spBorder;
      if (opShowWeekNumbers in Options) then
         Inc(FspDateStart, FDayWidth + 5);
    end;

    h := FspDateStartY + 5;
    // calculate minimal window height
    Inc(h, (FMinHeightDays * 7));
    if (opBottomLine in Options) then
      Inc(h,2);

    if (FTodayButton.Top <> h) then begin
      FTodayButton.Top := h;
      FNoneButton.Top  := h;
    end;


    if (opButtonNone in Options) or (opButtonToday in Options) then begin
      Inc(h,FTodayButton.Height);
      Inc(h,spBorder);
    end;

    if (FAutoSize = False) then begin
      FDayHeight := FMinHeightDays;
    end else if (FAutoSize = True) then begin
      FDayHeight := FMinHeightDays;
    end;

    if (FBorderType = cbsNone) then begin
      Dec(h,1);
    end;

    Constraints.MinHeight := h;
    Constraints.MaxHeight := h;

    FMonthRect.Left := 5;
    FMonthRect.Right := ClientWidth - 5;
    if (FBorderType = cbsNone) then begin
      Dec(FMonthRect.Left,1);
      Inc(FMonthRect.Right,1);
    end;
  end;
end;

procedure TNxMonthCalendarExt.CMFontChanged(var Message: TMessage);
begin
  inherited;

  if HandleAllocated = True then begin
    CalcNewSizes;
    Self.Repaint;
  end;
end;

constructor TNxMonthCalendarExt.Create(AOwner: TComponent);
begin
  inherited;
  FDay := 1;
  FDown := False;
  FMonth := 1;
  FYear := 1;
  Date := Today;

  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FHeaderFont := TFont.Create;
  FHeaderFont.OnChange := FontChanged;
  FHeaderFont.Height := 16;
  FHeaderFont.Color := clBlack;

  FTodayCaption := strToday;
  FTodayButton := TNxMiniButton.Create(Self);
  FTodayButton.Parent := Self;
  FTodayButton.Visible := (opButtonToday in Options);
  FTodayButton.SetBounds(20, 133, 47, 20);
  FTodayButton.Text := FTodayCaption;
  FTodayButton.Tag := 0;
  FTodayButton.OnMouseUp := DoButtonMouseUp;

  FNoneCaption := strNone;
  FNoneButton := TNxMiniButton.Create(Self);
  FNoneButton.Parent := Self;
  FNoneButton.Visible := (opButtonNone in Options);
  FNoneButton.SetBounds(82, 133, 47, 20);
  FNoneButton.Text := FNoneCaption;
  FNoneButton.Tag := 1;
  FNoneButton.OnMouseUp := DoButtonMouseUp;

  FYearEdit := TNxEdit.Create(Self);
  FYearEdit.Parent := Self;
  FYearEdit.AutoSize := False;
  FYearEdit.ReadOnly := True;
  if (csDesigning in ComponentState) then begin
    FYearEdit.Height := 0;
    FYearEdit.Left   := 0;
    FYearEdit.Top    := 0;
    FYearEdit.Width  := 0;
  end else begin
    FYearEdit.Height := 17;
    FYearEdit.Left   := 30;
  end;
  FYearEdit.BorderStyle := bsNone;
  FYearEdit.AutoSelect := False;
  FYearEdit.OnChange := OnYearEditUpDown;
  FYearEdit.OnKeyDown := OnYearEditKeyDown;
  FYearEdit.Visible := False;

  FYearEditUpDown := TUpDown.Create(Self);
  FYearEditUpDown.Parent := Self;
  FYearEditUpDown.Min := 1899;
  FYearEditUpDown.Max := 2199;
  FYearEditUpDown.Thousands := False;
  FYearEditUpDown.Associate := FYearEdit;
  FYearEditUpDown.Visible := False;

  FPopupMenu := TPopupMenu.Create(Self);
  FPopupMenu.Items.Clear;

  FMonthNames := TMonthNames.Create;
  FDayNames := TDayNames.Create;

  FWeekendDays := TWeekendDays.Create(Self);
  FCalColors := TCalMonthColors.Create(Self);
  FCalColors.SetAllColors;

  FDayWidth  := 18;
  FDayHeight := 15;
  FDayTextPadding := 0;
  FBorderType  := cbsSolid;

  FHeaderHeight := 15;
  FAutoSize := False;
  FAutoWidthDays := True;
  FDayAlignment := taRightJustify;
  FLastWidth := 100;
  FMonthChanged := False;
  FEvents := TCalEvents.Create;

  SetMinDate(0);
  FMaxDate := 0;
  Options := [opOtherMonthColor, opShowDaySelected, opShowHeader, opSelectWithRMButton,opShowEvents, opShowTodayRect, opShowWeekNumbers, opBottomLine];
  Color := clWindow;
  ParentColor := False;

  Height := 200;
  Width := 162;
end;

procedure TNxMonthCalendarExt.CreateWnd;
begin
  inherited;
end;


function TNxMonthCalendarExt.DateInRange(Value: TDate): Boolean;
begin
  if ( (FMinDate = 0) or ((FMinDate > 0) and (Value >= FMinDate)) ) and
     ( (FMaxDate = 0) or ((FMaxDate > 0) and (Value <= FMaxDate)) )
  then
    Result := True
  else
    Result := False;
end;

destructor TNxMonthCalendarExt.Destroy;
begin
  FreeAndNil(FYearEdit);
  FreeAndNil(FPopupMenu);
  FreeAndNil(FEvents);
  FreeAndNil(FDayNames);
  FreeAndNil(FMonthNames);
  FreeAndNil(FNoneButton);
  FreeAndNil(FTodayButton);
  FreeAndNil(FWeekendDays);
  inherited Destroy;
  FCalColors.Free;
end;

procedure TNxMonthCalendarExt.DisableYearEdit;
begin
  FYearEdit.Visible := False;
  FYearEditUpDown.Visible := False;
end;

procedure TNxMonthCalendarExt.DoAlignButtons;
var
  w: Integer;
begin
  if (csDesigning in ComponentState) or ((FNoneButton.Visible) and (FTodayButton.Visible)) then begin
    w := FTodayButton.Width + FNoneButton.Width;
    FTodayButton.Left := ClientWidth div 2 - w div 2 - 3;
    FNoneButton.Left  := FTodayButton.Left + FTodayButton.Width + 3;
  end else
  if (FTodayButton.Visible = True) then begin
    FTodayButton.Left := ClientWidth div 2 - FTodayButton.Width div 2;
  end else
  begin
    FNoneButton.Left := ClientWidth div 2 - FNoneButton.Width div 2;
  end;
end;

procedure TNxMonthCalendarExt.DoButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender as TNxMiniButton).Tag = 0 then begin
    Date := Today;
  end else
  if (Sender as TNxMiniButton).Tag = 1 then begin
    //Date := Today;
    SelectedDate := 0;
  end;
  RefreshMonth;
end;

procedure TNxMonthCalendarExt.DoChange;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TNxMonthCalendarExt.DoDayFont(Day: Integer; Font: TFont);
begin
  if Assigned(FOnDayFont) then FOnDayFont(Self, Day, Font);
end;

function TNxMonthCalendarExt.EventsCount(Value: TDate): Integer;
begin
  Result := FEvents.CountEvents(Value);
end;

function TNxMonthCalendarExt.EventsCountSelected: Integer;
begin
  Result := FEvents.CountEvents(FSelectedDate);
end;

procedure TNxMonthCalendarExt.FontChanged(Sender: TObject);
begin
  Perform(CM_FONTCHANGED, 0, 0);
end;

function TNxMonthCalendarExt.GetActualStartDay: TStartDayOfWeek;
var
  D: array[0..1] of char;
begin
  case FStartDay of
    dwAutomatic:
    begin
      GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_IFIRSTDAYOFWEEK, D, SizeOf(D));
      case StrToInt(D) of
        0: Result := dwMonday;
        else Result := dwSunday;
      end;
    end
    else Result := FStartDay;
  end;
end;

function TNxMonthCalendarExt.GetDateAtPos(ACol, ARow: Integer): TDate;
var
	PastMonth, PastYear, StartingDay, LastDayInPastMonth, DaysInPastMonth, delta: Integer;
  p, ADay: Integer;
begin
	p := ARow * 7 + ACol;
  StartingDay := GetDayOfWeek(StartOfAMonth(Year, Month));
  if p < StartingDay - 1 then
  begin
    PastYear := Year;
    PastMonth := Month;
    SetPastMonth(PastYear, PastMonth);
    LastDayInPastMonth := GetDayOfWeek(EndOfAMonth(PastYear, PastMonth));
    DaysInPastMonth := DaysInAMonth(PastYear, PastMonth);
    delta := LastDayInPastMonth - (ACol + 1);
    Result := EncodeDate(PastYear, PastMonth, DaysInPastMonth - delta);
  end
  else if p + 2 > StartingDay + DaysInAMonth(Year, Month) then
  begin
    PastYear := Year;
    PastMonth := Month;
    SetPastMonth(PastYear, PastMonth, False);
    ADay := p - (StartingDay + DaysInAMonth(Year, Month)) + 2;
    Result := EncodeDate(PastYear, PastMonth, ADay);
  end
  else Result := EncodeDate(Year, Month, (ARow * 7) + (ACol - StartingDay + 2));
end;

function TNxMonthCalendarExt.GetDayOfWeek(Day: TDateTime): Integer;
begin
  Result := 0;
  case GetActualStartDay of
    dwSunday: Result := DayOfWeek(Day);
    dwMonday: Result := DayOfTheWeek(Day);
  end;
end;

function TNxMonthCalendarExt.GetDaysRect: TRect;
var
  Y: Integer;
begin
  Y := (FspDateStartY + FDayHeight);
  Result := Rect(FspDateStart, Y, ClientWidth - spBorder, Y + (FDayHeight * 6) );
end;

function TNxMonthCalendarExt.GetEvent(const Index: Integer): TCalEvent;
begin
  Result := FEvents.FCalEvents[Index];
end;

function TNxMonthCalendarExt.GetEventDayColor(eDate: TDate): TColor;
begin
  Result := FEvents.GetEventDayColor(eDate);
end;

function TNxMonthCalendarExt.GetEvents(const eDate: TDate; slist: TStringList): Integer;
begin
  FEvents.GetEventStringList(eDate,slist);
  Result := slist.Count;
end;

function TNxMonthCalendarExt.GetMonthName(Month: Integer): WideString;
begin
  if Assigned(FMonthNames) and InRange(Month, 1, 12) then
    Result := FMonthNames.GetMonth(Month)
  else
    Result := LocalSettings.LongMonthNames[Month];
end;

function TNxMonthCalendarExt.GetMonthRect: TRect;
begin
  Result := FMonthRect;
end;

function TNxMonthCalendarExt.GetWeekRect: TRect;
begin
  if HandleAllocated = True then begin
    if (opShowWeekNumbers in Options) then begin
      Result := Rect(FspDateStart - FDayWidth - 5, FspDateStartY + FDayHeight, FspDateStart - 2, FspDateStartY + (FDayHeight*7));
    end else begin
      Result := Rect(0, 0, 0, 0);
    end;
  end;
end;


function TNxMonthCalendarExt.HasEvent(Value: TDate): Boolean;
begin
  Result := FEvents.HasEvent(Value);
end;

function TNxMonthCalendarExt.HasEvents: Boolean;
begin
  Result := FEvents.HasEvent(FSelectedDate);
end;

procedure TNxMonthCalendarExt.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  fpoint: TPoint;
  tmpstr, tmpstr2: String;
  tmpdate: TDate;
  tmppos: Integer;
  cnt: Integer;
begin
  inherited;
  if (opShowHeader in Options) then begin
    if (PtInRect(FHeadYearRect, Point(X, Y))) then
    begin
      if (Button = mbRight) then begin
        FPopupMenu.Items.Clear;
        tmpstr := IntToStr(FDay);
        tmpdate := IncYear(FDate, - 5);
        cnt := 0;
        for I := 1 to 12 do begin
          if (DateInRange(tmpdate) = True) then begin
            if (tmpdate <> FDate) then begin
              tmpstr  := FormatDateTime('yyyy', tmpdate);
              tmpstr2 := FormatDateTime('dd_mm_yyyy', tmpdate);
              FPopupMenu.Items.Add([ NewItem(tmpstr,0,False,True,PopupClick,0, 'dstr_'+tmpstr2) ]);
              Inc(cnt);
            end else begin
              if (cnt>0) then
                FPopupMenu.Items.Add([ NewItem('----',0,False,True,NIL,0,'') ]);
            end;
          end;
          tmpdate := IncYear(tmpdate, 1);
        end;
        fpoint := ClientToScreen(Point(X,Y));
        FPopupMenu.Popup(fpoint.X, fpoint.Y);
      end else if (Button = mbLeft) then begin
        if (FMinDate > 0) and (FMaxDate>0) and (YearOf(FMinDate) = YearOf(FMaxDate)) then
          Exit;
        FYearEdit.Font.Assign(FHeaderFont);
        FYearEdit.Font.Color := FCalColors.FHeaderColor;
        FYearEdit.Color := FHeaderFont.Color;
        FYearEdit.Left := FHeadYearRect.Left;
        FYearEdit.Top  := FHeadYearRect.Top; // (FHeadYearRect.Bottom - FHeadYearRect.Top) div 2 - (FHeadYearHeight div 2) + FHeadYearRect.Top - 1;
        FYearEdit.Height := FHeadYearHeight;
        FYearEdit.Width := FHeadYearRect.Right - FHeadYearRect.Left + 2;

        tmppos := FYearEdit.Left + FYearEdit.Width;
        if ((tmppos + FYearEditUpDown.Width + 2) > ClientWidth) then
          FYearEditUpDown.Left := FYearEdit.Left - FYearEditUpDown.Width
        else
          FYearEditUpDown.Left := FYearEdit.Left + FYearEdit.Width;

        FYearEditUpDown.Height := FHeadYearHeight;
        FYearEditUpDown.Position := Year;
        FYearEdit.Visible := True;
        FYearEditUpDown.Visible := True;
        FYearEdit.SetFocus;
      end;
    end else begin
      if (FYearEdit.Visible = True) then begin
        DisableYearEdit();
        exit;
      end;
    end;

    if (Button = mbLeft) then begin
      // Button Month forward
      if PtInRect(Rect(0, 0, 18, FHeaderHeight+4), Point(X, Y)) then
      begin
        if Month > 1 then Month := Month - 1 else
        begin
          Year := Year - 1;
          Month := 12;
        end;
      end;
      // Button Month back
      if PtInRect(Rect(ClientWidth - 18, 0, ClientWidth, FHeaderHeight+4), Point(X, Y)) then
      begin
        if Month < 12 then Month := Month + 1 else
        begin
          Year := Year + 1;
          Month := 1;
        end;
      end;
    end;

    // Popup Menu for Months
    if (Button = mbRight) and (PtInRect(FHeadMonthRect, Point(X, Y))) then
    begin
      FPopupMenu.Items.Clear;
      tmpstr := IntToStr(FDay);
      tmpdate := IncMonth(FDate, - 5);
      cnt := 0;
      for I := 1 to 12 do begin
        if (DateInRange(tmpdate) = True) then begin
          if (tmpdate <> FDate) then begin
            tmpstr  := FormatDateTime('mmmm yyyy', tmpdate);
            tmpstr2 := FormatDateTime('dd_mm_yyyy', tmpdate);
            FPopupMenu.Items.Add([ NewItem(tmpstr,0,False,True,PopupClick,0, 'dstr_'+tmpstr2) ]);
            Inc(cnt);
          end else begin
            if (cnt > 0) then
              FPopupMenu.Items.Add([ NewItem('----------------',0,False,True,NIL,0,'') ]);
          end;
        end;
        tmpdate := IncMonth(tmpdate, 1);
      end;
      fpoint := ClientToScreen(Point(X,Y));
      FPopupMenu.Popup(fpoint.X, fpoint.Y);
    end;
  end;

  // Button Days
  if ((opSelectWithRMButton in Options) and ((Button = mbLeft) or (Button = mbRight))) or (not(opSelectWithRMButton in Options) and (Button = mbLeft)) then begin
    if PtInRect(Rect(FspDateStart, FspDateStartY + FDayHeight, FspDateStart + (FDayWidth*7), FspDateStartY + (FDayHeight*7) ), Point(X, Y)) then
    begin
      FDown := True;
      SelectDate(X, Y);
    end;
  end;
end;

procedure TNxMonthCalendarExt.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (FDown) and
    (PtInRect(Rect(FspDateStart, FspDateStartY + FDayHeight, FspDateStart + (FDayWidth*7), FspDateStartY + (FDayHeight*7) ), Point(X, Y))) then
  begin
    SelectDate(X, Y);
  end;
end;

procedure TNxMonthCalendarExt.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
	if not PtInRect(Rect(0, 0, ClientWidth, 19), Point(X, Y)) then inherited;
  FDown := False;
  if ((opMonthAutoSwitch in Options)) or (FMonthChanged = True) then begin
    SetDate(FSelectedDate);
    FMonthChanged := False;
  end;
  if (FLastSelectedDate <> SelectedDate) then begin
    FLastSelectedDate := SelectedDate;
    if (opShowEvents in Options) and
       (FEvents.HasEvent(SelectedDate) = True) and
       ( not(opShowCurrentEventsOnly in Options) or
          (
            (opShowCurrentEventsOnly in Options) and (Month = MonthOf(SelectedDate) )
          )
       )
    then begin
      // If the day changed and a event is selected then do the notify event
      if Assigned(FOnSelectedEventDay) then FOnSelectedEventDay(Self);
    end;
  end;

end;

procedure TNxMonthCalendarExt.OnYearEditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then begin
    DisableYearEdit();
  end;
end;

procedure TNxMonthCalendarExt.OnYearEditUpDown(Sender: TObject);
begin
  if (FYearEditUpDown.Position > 1899) then begin
    if FYearEditUpDown.Position <> Year then begin
      SetDate( EncodeDate(FYearEditUpDown.Position, Month, Day));
    end;
  end;
end;

procedure TNxMonthCalendarExt.Paint;
var
	dayn: Integer;
  dt: TDateTime;
  dtw: Integer;
  YWeek: Integer;
  XWeek: Integer;
  dow: Integer;
  i, X, Y, p: Integer;
	dy, dm, dd, diw: Integer;
  r: TRect;
  showevent : Boolean;
begin
  if not assigned(FDayNames) then exit;
  if not assigned(FMonthNames) then exit;

  inherited;
  X := FspDateStart;
  Y := (FspDateStartY + FDayHeight); // 38 !!
  p := 0;
  with Canvas do
  begin
    Canvas.Font.Assign(FFont);
    Font.Color := clWindowText;
    Brush.Color := Self.Color;
    if (FBorderType = cbsSolid) then begin
      Pen.Color := FCalColors.BorderColor;
      Rectangle(0, 0, ClientWidth, ClientHeight);
    end else begin
      Pen.Color := Brush.Color;
      Rectangle(0, 0, ClientWidth, ClientHeight);
    end;

    Pen.Color := clGrayText;
    PaintMonth(GetMonthRect);

    Canvas.Font.Assign(FFont);
    Font.Color := FCalColors.WeekDayColor;

    for i := 1 to 7 do
    begin
      if GetActualStartDay = dwSunday then
        dayn := i + 6
      else
        dayn := i;

      TGraphicsProvider.DrawTextRect(Canvas, Rect(X, FspDateStartY, X + FDayWidth - 2, FspDateStartY + FDayHeight - 1), FDayAlignment, FDayNames.GetDay(dayn));
      Inc(X, FDayWidth);
    end;
    if (opShowWeekNumbers in Options) and (FspDateStart > (5 + FDayWidth + 4)) then begin
      Pen.Color := clGrayText;
      MoveTo(FspDateStart - 2, FspDateStartY );
      LineTo(FspDateStart - 2, FspDateStartY + (FDayHeight*7) + 1 );

      r := GetWeekRect;
      XWeek := r.Left;
      YWeek := r.Top;
      Font.Color := FCalColors.WeekNumberColor;
      //dtw := DateToWeek(1, Month, Year);
      dt := EncodeDate(Year, Month, 1);
      for i := 1 to 6 do
      begin
        dtw := WeekOf(dt);
        TGraphicsProvider.DrawTextRect(Canvas, Rect(XWeek, YWeek, XWeek + FDayWidth, YWeek + FDayHeight ), taRightJustify, IntToStr(dtw));
        dt := IncWeek(dt,1);
        Inc(YWeek, FDayHeight);
      end;
    end;

	  X := FspDateStart;
    Pen.Color := clGrayText;
    MoveTo(spBorder, FspDateStartY + FDayHeight - 2 );
    LineTo(ClientWidth - spBorder, FspDateStartY + FDayHeight - 2);

    // Line under dates
    if (opBottomLine in Options) then begin
      Pen.Color := clGrayText;
      MoveTo(spBorder, FspDateStartY + (FDayHeight*7) + 1);
      LineTo(ClientWidth - spBorder, FspDateStartY + (FDayHeight*7) + 1);
    end;

    dy := Year;
    dm := Month;
    diw := 1;
    if GetDayOfWeek(StartOfAMonth(Year, Month)) > 1 then
    begin
      SetPastMonth(dy, dm);
      dd := DaysInAMonth(dy, dm) - GetDayOfWeek(StartOfAMonth(Year, Month)) + 2;
    end else dd := 1;
    while p < 42 do
    begin
      dt := EncodeDate(dy, dm, dd);
    	r := Rect(X + 2, Y, X + FDayWidth - 2, Y + FDayHeight);
      dow := DayOfTheWeek(EncodeDate(dy, dm, dd));
      if (opShowEvents in Options) and ((not(opShowCurrentEventsOnly in Options)) or (opShowCurrentEventsOnly in Options) and (dm =  Month)) then begin
        showevent := True;
      end else begin
        showevent := False;
      end;
      if (showevent) and (HasEvent(dt)) then begin
          Brush.Color := FEvents.GetEventDayColor(dt);
          FillRect(Rect(X, Y, X + FDayWidth, Y + FDayHeight));
      end;

      if (dm = Month) or ( (showevent) and (HasEvent(dt)) ) or not (opOtherMonthColor in Options) then begin
        if (FWeekendDays.GetDay(dow) = True) then
          Font.Color := FCalColors.FWeekendColor
        else
          Font.Color := FCalColors.FTextColor;
      end else
      begin
        if (opOtherMonthColor in Options) then begin
          if (FWeekendDays.GetDay(dow) = True) then
            Font.Color := FCalColors.FWeekendColorLight
          else
            Font.Color := FCalColors.FTextColorLight;
        end;
      end;

      if EncodeDate(dy, dm, dd) = SelectedDate then
      begin
        if (opShowDaySelected in Options) then begin
          Brush.Color := FCalColors.SelectColor;
          FillRect(Rect(X, Y, X + FDayWidth , Y + FDayHeight));
          FOldRect := Rect(X, Y, X + FDayWidth, Y + FDayHeight);
          if (FCalColors.SelectColorFont <> clNone) then
            Font.Color := FCalColors.SelectColorFont;
        end;
      end;

      if (EncodeDate(dy, dm, dd) = Today) and (opShowTodayRect in Options) then
      begin
        Brush.Color := FCalColors.FTodayCircleColor;
        FrameRect(Rect(X, Y, X + FDayWidth, Y + FDayHeight));
      end;

      PaintDay(dy, dm, dd, r);
      Inc(p);
      Inc(dd);
      if dd > DaysInAMonth(dy, dm) then
			begin
	      SetPastMonth(dy, dm, False);
        dd := 1;
			end;
      Inc(X, FDayWidth);
      Inc(diw);
      if diw > 7 then
      begin
        X := FspDateStart;
        Inc(Y, FDayHeight);
        diw := 1;
      end;
    end;
  end;
end;

procedure TNxMonthCalendarExt.PaintDay(Year, Month, Day: Integer; DayRect: TRect);
var
  StringText: string;
begin
  with Canvas.Brush do
  begin
    Style := bsClear;
    StringText := IntToStr(Day);
    DoDayFont(Day, Canvas.Font);
    TGraphicsProvider.DrawWrapedTextRect(Canvas, DayRect, FDayAlignment, taVerticalCenter, False, StringText, bdLeftToRight);
    Style := bsSolid;
  end;
end;

procedure TNxMonthCalendarExt.PaintMonth(MonthRect: TRect);
var
  PosY: Integer;
  txtrect: TRect;
  str1: String;
  dt: TDate;
  tmpw1, tmpw2, tmpc1, tmpc2, tmph1: Integer;
begin
  Canvas.Font.Assign(FHeaderFont);
  if not (opShowHeader in Options) then exit;

  with Canvas do
  begin
    str1 := GetMonthName(Month) + ' ' + IntToStr(Year);
    Brush.Color := FCalColors.FHeaderColor;
    FillRect(MonthRect);
    txtrect := MonthRect;
    Inc(txtrect.Left, 15);
    Dec(txtrect.Right, 15);
    tmpw1 := Canvas.TextWidth(GetMonthName(Month) + ' ');
    tmpw2 := Canvas.TextWidth(IntToStr(Year));
    tmpc1 := (tmpw1 + tmpw2) div 2;
    tmpc2 := (txtrect.Right - txtrect.Left) div 2 - tmpc1 + txtrect.Left;

    tmph1 := Canvas.TextHeight(str1);
    FHeadYearHeight := Canvas.TextHeight(IntToStr(Year));

    FHeadMonthRect.Left   := tmpc2;
    FHeadMonthRect.Right  := tmpc2 + tmpw1;
    FHeadMonthRect.Top    := (txtrect.Bottom - txtrect.Top) div 2 - (tmph1 div 2) + txtrect.Top;
    FHeadMonthRect.Bottom := FHeadMonthRect.Top + tmph1;

    FHeadYearRect.Left    := FHeadMonthRect.Right;
    FHeadYearRect.Right   := FHeadYearRect.Left + tmpw2;
    FHeadYearRect.Top     := FHeadMonthRect.Top;
    FHeadYearRect.Bottom  := FHeadYearRect.Top + tmph1;

    DrawTextRect(Canvas, txtrect, taCenter, str1);
    Canvas.Font.Style := Canvas.Font.Style - [fsBold];

    { draw left and right arrow }
    PosY := MonthRect.Top + (MonthRect.Bottom - MonthRect.Top) div 2 - 8 div 2;
    dt := EncodeDate(FYear, FMonth, 1);
    if ( (FMinDate = 0) or ((FMinDate > 0) and (dt > FMinDate)) ) then begin
      Brush.Color := FCalColors.FHeaderButtonColor;
    end else begin
      Brush.Color :=  Lighten(FCalColors.FHeaderColor, -30);
    end;
    Pen.Color := Brush.Color;
    Polygon([
        Point(15, PosY),
        Point(15, PosY + 8),
        Point(11, PosY + 4)]);

    if ( (FMaxDate = 0) or ((FMaxDate > 0) and (IncMonth(dt,1) < FMaxDate)) ) then begin
      Brush.Color := FCalColors.FHeaderButtonColor;
    end else begin
      Brush.Color :=  Lighten(FCalColors.FHeaderColor, -30);
    end;
    Pen.Color := Brush.Color;
    Polygon([
      Point(ClientWidth - 15, PosY),
      Point(ClientWidth - 15, PosY + 8),
      Point(ClientWidth - 11, PosY + 4)]);
  end;
end;

procedure TNxMonthCalendarExt.PopupClick(Sender: TObject);
var
  sname: String;
  sdate: TDate;
  year, month, day:Word;
begin
  if (Sender is TMenuItem) then begin
    sname := (Sender as TMenuItem).Name;
    sname := RightStr(sname, 10);
    sname := StringReplace(sname,'_','.', [rfReplaceAll]);
    year  := StrToInt(Copy(sname,7,4));
    month := StrToInt(Copy(sname,4,2));
    day   := StrToInt(Copy(sname,1,2));
    sdate := EncodeDate(year, month, day);
    SetDate(sdate);
  end;
end;

procedure TNxMonthCalendarExt.RefreshMonth;
var
  R: TRect;
begin
  if not HandleAllocated then Exit;
  R := GetMonthRect;
  InvalidateRect(Handle, @R, False);
  R := GetDaysRect;
  InvalidateRect(Handle, @R, False);
  R := GetWeekRect;
  InvalidateRect(Handle, @R, False);
end;

procedure TNxMonthCalendarExt.ResetEventColors;
begin
  FEvents.ResetEventColors();
  Self.Repaint;
end;

procedure TNxMonthCalendarExt.SelectDate(X, Y: Integer);
var
	l, t, col, row: Integer;
	r: TRect;
  sd: TDate;
begin
	col := (X - FspDateStart) div FDayWidth;
  row := (y - (FspDateStartY + FDayHeight )) div FDayHeight;
  sd := GetDateAtPos(col, row);

  if (DateInRange(sd)=False) then begin
    if (FMinDate > 0) and (sd < FMinDate) and (FMinDate <> SelectedDate) then begin
      SelectedDate := FMinDate;
      Self.Repaint;
    end else
    if (FMaxDate > 0) and (sd >= FMaxDate) and (FMaxDate <> SelectedDate) then begin
      SelectedDate := FMaxDate;
      Self.Repaint;
    end;
    Exit;
  end;

  if (opMonthAutoSwitch in Options) and ((MonthOf(sd)<>MonthOf(SelectedDate)) or (YearOf(sd)<>YearOf(SelectedDate))) then begin
    FMonthChanged := True;
  end;

  if sd = SelectedDate then
    Exit
  else
    SelectedDate := sd;

  l := FspDateStart + (col * FDayWidth);
  t := (FspDateStartY + FDayHeight) + (row * FDayHeight);
  r := Rect(l, t, l + FDayWidth, t + FDayHeight);
  InvalidateRect(Handle, @FOldRect, False);
  InvalidateRect(Handle, @r, False);
end;

procedure TNxMonthCalendarExt.SetAutoSize(const Value: Boolean);
begin
    FAutoSize := Value;
    FAutoWidthDays := False;
    CalcNewSizes;
end;

procedure TNxMonthCalendarExt.SetAutoWidthDays(const Value: Boolean);
begin
  if (FAutoWidthDays <> Value) then begin
    FAutoSize := False;
    FAutoWidthDays := Value;
    CalcNewSizes;
  end;
end;


procedure TNxMonthCalendarExt.SetBorderType(const Value: TCalBorderStyle);
begin
  FBorderType := Value;
  CalcNewSizes;
end;

function TNxMonthCalendarExt.GetCurrentEventDayColor: TColor;
begin
  Result := GetEventDayColor(FSelectedDate);
end;

procedure TNxMonthCalendarExt.SetCalColors(const Value: TCalMonthColors);
begin
  FCalColors := Value;
  Self.Repaint;
end;

procedure TNxMonthCalendarExt.SetCurrentEventDayColor(
  const edColor: TColor);
begin
  SetEventDayColor(FSelectedDate, edColor);
end;

procedure TNxMonthCalendarExt.SetDate(const Value: TDate);
var dt: TDate;
   yof,mof,dof: Word;
begin
  if (FSelectedDate <> Value) or (FDate <> Value) then begin
    yof := YearOf(Value);
    mof := MonthOf(Value);
    dof := DayOf(Value);
    dt := EncodeDate(yof, mof, dof);
    if (DateInRange(dt)) then begin
      FDate := dt;
    end else
    if (FMinDate > 0) and (dt < FMinDate) then begin
      FDate := FMinDate;
    end else
    if (FMaxDate > 0) and (dt > FMaxDate) then begin
      FDate := FMaxDate;
    end else
      FDate := Now;
    FSelectedDate := FDate;
    FYear := YearOf(FDate);
    FMonth := MonthOf(FDate);
    FDay := DayOf(FDate);
    RefreshMonth;
  end;
end;

procedure TNxMonthCalendarExt.SetDay(const Value: Word);
var dt: TDate;
begin
  if (FDay <> Value) then
  begin
    dt := EncodeDate(FYear, FMonth, Value);
    if ( (FMinDate = 0) or ((FMinDate > 0) and (dt >= FMinDate)) ) and
       ( (FMaxDate = 0) or ((FMaxDate > 0) and (dt <= FMaxDate)) )
    then begin
      FDay := Value;
    end;
  end;
end;

procedure TNxMonthCalendarExt.SetDayAlignment(const Value: TAlignment);
begin
  FDayAlignment := Value;
  Self.Repaint;
end;

procedure TNxMonthCalendarExt.SetDayNames(const Value: TDayNames);
begin
  FDayNames := Value;
  Self.Repaint;
end;

procedure TNxMonthCalendarExt.SetDayTextPadding(const Value: Integer);
var x:Integer;
begin
  if (Value < 0) then x := 0
  else if (Value > 20) then x := 20
  else x := Value;
  if (FDayTextPadding <> x) then begin
    FDayTextPadding := x;
    CalcNewSizes;
  end;
end;

procedure TNxMonthCalendarExt.SetEventDayColor(const eDate: TDate;
  edColor: TColor);
begin
  FEvents.SetEventDayColor(eDate, edColor);
end;

procedure TNxMonthCalendarExt.SetTextFont(const Value: TFont);
begin
  FFont := Value;
  CalcNewSizes;
end;

procedure TNxMonthCalendarExt.SetHeaderAutoHeight(const Value: Boolean);
var
  I: Integer;
  x: Integer;
  oldx: Integer;
begin
  x := 0;
  if (FHeaderAutoHeight <> Value) then begin
    FHeaderAutoHeight := Value;
    if Value = True then begin
        Canvas.Font.Assign( FHeaderFont );
        for I := 1 to 12 do begin
          oldx := Canvas.TextHeight( FMonthNames.GetMonth(I) );
          if oldx > x then
            x := oldx;
        end;
        FHeaderHeight := x + 4;
    end;
    Self.Repaint;
  end;
end;

procedure TNxMonthCalendarExt.SetHeaderFont(const Value: TFont);
begin
  FHeaderFont.Assign(Value);
  CalcNewSizes;
end;

procedure TNxMonthCalendarExt.SetHeaderHeight(const Value: Integer);
begin
  if (FHeaderAutoHeight = False) then begin
    FHeaderHeight := Value;
    Self.Repaint;
  end;
end;

procedure TNxMonthCalendarExt.SetMaxDate(const Value: TDate);
var DateValue : TDate;
begin
  DateValue := Floor(Value);
  if (DateValue <> FMaxDate) then begin
    if (DateValue = 0) or
       ((DateValue <> FMaxDate) and ((FMinDate = 0) or (DateValue > FMinDate))) then
    begin
      FMaxDate := DateValue;
      FYearEditUpDown.Max := YearOf(DateValue);
    end;
    if (DateValue < FSelectedDate) then
      SetDate(FMaxDate);
  end;
end;

procedure TNxMonthCalendarExt.SetMinDate(const Value: TDate);
var DateValue : TDate;
begin
  DateValue := Floor(Value);
  if (FMinDate <> DateValue) then begin
    if (DateValue = 0) or
       ((FMaxDate > 0) and (DateValue < FMaxDate)) or
       ((FMaxDate = 0) and (DateValue > 0)) then
    begin
      FMinDate := DateValue;
      if (DateValue = 0) then
        FYearEditUpDown.Min := 1899
      else
        FYearEditUpDown.Min := YearOf(DateValue);
      if (FMinDate > FSelectedDate) then SetDate(FMinDate);
    end;
  end;
end;

procedure TNxMonthCalendarExt.SetMonth(const Value: Word);
var dt: TDate;
begin
  if (FMonth <> Value)
  then begin
    dt := EncodeDate(FYear, Value, FDay);
    if ( (FMinDate = 0) or ((FMinDate > 0) and (dt >= FMinDate)) ) and
       ( (FMaxDate = 0) or ((FMaxDate > 0) and (dt <= FMaxDate)) )
    then begin
      FMonth := Value;
      RefreshMonth;
    end;
  end;
end;

procedure TNxMonthCalendarExt.SetMonthNames(const Value: TMonthNames);
begin
  FMonthNames := Value;
  Self.Repaint;
end;

procedure TNxMonthCalendarExt.SetNoneCaption(const Value: WideString);
begin
  FNoneCaption := Value;
  FNoneButton.Text := FNoneCaption;
end;

procedure TNxMonthCalendarExt.SetOptions(
  const Value: TNxMonthCalendarExtOptions);
begin
  FTodayButton.Visible := (opButtonToday in Value);
  FNoneButton.Visible  := (opButtonNone in Value);

  if ((opButtonToday in FOptions) <> (opButtonToday in Value)) or
     ((opButtonNone in FOptions) <> (opButtonNone in Value))
  then begin
    DoAlignButtons;
  end;

  FOptions := Value;
  CalcNewSizes;
  Invalidate;
end;

procedure TNxMonthCalendarExt.SetPastMonth(var AYear, AMonth: Integer;
  Decrease: Boolean);
begin
	case Decrease of
  	True: if AMonth > 1 then AMonth := AMonth - 1 else
				  begin
				    AYear := AYear - 1;
				    AMonth := 12;
				  end;
    False:	if AMonth < 12 then AMonth := AMonth + 1 else
					  begin
					    AYear := AYear + 1;
					    AMonth := 1;
					  end;
  end;
end;

procedure TNxMonthCalendarExt.SetSelectedDate(const Value: TDate);
begin
  if FSelectedDate <> Value then
  begin
    FSelectedDate := Value;
    DoChange; { Event }
  end;
end;

procedure TNxMonthCalendarExt.SetStartDay(const Value: TStartDayOfWeek);
begin
  FStartDay := Value;
  Invalidate;
end;

procedure TNxMonthCalendarExt.SetTodayCaption(const Value: WideString);
begin
  FTodayCaption := Value;
  FTodayButton.Text := FTodayCaption;
end;

procedure TNxMonthCalendarExt.SetWeekendDays(const Value: TWeekendDays);
begin
  FWeekendDays := Value;
  Self.Repaint;
end;

procedure TNxMonthCalendarExt.SetYear(const Value: Word);
var dt1, dt2: TDate;
begin
  if FYear <> Value then
  begin
    dt1 := 0;
    dt2 := 0;
    if (FMinDate > 0) then
      dt1:= EncodeDate(Value, MonthOf(FMinDate), DayOf(FMinDate));
    if (FMaxDate > 0) then
      dt2:= EncodeDate(Value, MonthOf(FMaxDate), DayOf(FMaxDate));

    if ( (FMinDate = 0) or ((FMinDate > 0) and (dt1 >= FMinDate)) ) and
       ( (FMaxDate = 0) or ((FMaxDate > 0) and (dt2 <= FMaxDate)) )
    then begin
      FYear := Value;
      RefreshMonth;
    end;
  end;
end;

procedure TNxMonthCalendarExt.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
//  Message.Result := 1;
end;


procedure TNxMonthCalendarExt.WMKillFocus(var Message: TMessage);
begin
//
end;

procedure TNxMonthCalendarExt.WMSize(var Message: TWMSize);
begin
  if FLastWidth <> Width then begin
    FLastWidth := Width;
    CalcNewSizes;
  end;
  DoAlignButtons;
  RefreshMonth;
end;

{ TDayNames }

constructor TDayNames.Create;
begin
  inherited Create;
  FSunday := LocalSettings.ShortDayNames[1];
  FMonday := LocalSettings.ShortDayNames[2];
  FTuesday := LocalSettings.ShortDayNames[3];
  FWednesday := LocalSettings.ShortDayNames[4];
  FThursday := LocalSettings.ShortDayNames[5];
  FFriday := LocalSettings.ShortDayNames[6];
  FSaturday := LocalSettings.ShortDayNames[7];
end;

destructor TDayNames.Destroy;
begin
  inherited;
end;

function TDayNames.GetDay(i: integer): string;
begin
  case i of
    1, 8: Result := FMonday;
    2, 9: Result := FTuesday;
    3, 10: Result := FWednesday;
    4, 11: Result := FThursday;
    5, 12: Result := FFriday;
    6, 13: Result := FSaturday;
    7, 14: Result := FSunday;
  else
    Result := '';
  end;
end;

{ TMonthNames }

constructor TMonthNames.Create;
begin
  inherited Create;
  FJanuary := LocalSettings.LongMonthNames[1];
  FFebruary := LocalSettings.LongMonthNames[2];
  FMarch := LocalSettings.LongMonthNames[3];
  FApril := LocalSettings.LongMonthNames[4];
  FMay := LocalSettings.LongMonthNames[5];
  FJune := LocalSettings.LongMonthNames[6];
  FJuly := LocalSettings.LongMonthNames[7];
  FAugust := LocalSettings.LongMonthNames[8];
  FSeptember := LocalSettings.LongMonthNames[9];
  FOctober := LocalSettings.LongMonthNames[10];
  FNovember := LocalSettings.LongMonthNames[11];
  FDecember := LocalSettings.LongMonthNames[12];
end;

destructor TMonthNames.Destroy;
begin
  inherited Destroy;
end;

function TMonthNames.GetMonth(i: integer): string;
begin
  case i of
    1: Result := FJanuary;
    2: Result := FFebruary;
    3: Result := FMarch;
    4: Result := FApril;
    5: Result := FMay;
    6: Result := FJune;
    7: Result := FJuly;
    8: Result := FAugust;
    9: Result := FSeptember;
    10: Result := FOctober;
    11: Result := FNovember;
    12: Result := FDecember;
  else
    Result := '';
  end;
end;

{ TWeekendDays }
constructor TWeekendDays.Create(AOwner: TNxMonthCalendarExt);
begin
  inherited Create;
  Owner := AOwner;
  FSunday := True;
  FMonday := False;
  FTuesday := False;
  FWednesday := False;
  FThursday := False;
  FFriday := False;
  FSaturday := True;
end;

destructor TWeekendDays.Destroy;
begin
  inherited Destroy;
end;

function TWeekendDays.GetDay(i: integer): Boolean;
begin
  case i of
    1, 8: Result := FMonday;
    2, 9: Result := FTuesday;
    3, 10: Result := FWednesday;
    4, 11: Result := FThursday;
    5, 12: Result := FFriday;
    6, 13: Result := FSaturday;
    7, 14: Result := FSunday;
  else
    Result := False;
  end;
end;

procedure TWeekendDays.SetWeekend(const Index: Integer; const Value: TWeekendBool);
begin
  case Index of
    0: FMonday  := Value;
    1: FTuesday := Value;
    2: FWednesday := Value;
    3: FThursday := Value;
    4: FFriday := Value;
    5: FSaturday := Value;
    6: FSunday := Value;
  end;
  if Owner.HandleAllocated = True then
    Owner.Repaint;
end;

{ TCalEvents }

function TCalEvents.AddEvent(fDate: TDate; fEvent: String): Integer;
var
  i: Integer;
begin
  i := Length(FCalEvents);
  SetLength(FCalEvents, (i+1));
  FCalEvents[i] := TCalEvent.Create;
  FCalEvents[i].Color := FEventDefaultColor;
  FCalEvents[i].EventDate := Floor(fDate);
  FCalEvents[i].EventText := fEvent;
  FCalEvents[i].EventID := '';
  Result := i;
end;

procedure TCalEvents.ClearEvents;
var
  I: Integer;
begin
  for I := High(FCalEvents) downto Low(FCalEvents) do begin
    FCalEvents[I].Free;
  end;
end;

function TCalEvents.Count: Integer;
begin
  Result := Length(FCalEvents);
end;

function TCalEvents.CountEvents(Value: TDate): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(FCalEvents) to High(FCalEvents) do begin
    if (FCalEvents[I].EventDate = Floor(Value)) then begin
      Inc(Result);
    end;
  end;
end;

constructor TCalEvents.Create;
begin
  FEventDefaultColor := clMoneyGreen;
end;

procedure TCalEvents.DelEvent(fDate: TDate);
begin
//
end;

destructor TCalEvents.Destroy;
begin
  ClearEvents;
  inherited;
end;

procedure TCalEvents.GetEventStringList(date: TDate; slist: TStringList);
var
  I: Integer;
begin
  if not Assigned(slist) then
    slist := TStringList.Create
  else
    slist.Clear;
  for I := Low(FCalEvents) to High(FCalEvents) do begin
    if (FCalEvents[I].EventDate = Floor(date)) then begin
      slist.Add(FCalEvents[I].EventText);
    end;
  end;
end;

function TCalEvents.GetEventDayColor(Value: TDate): TColor;
var
  I: Integer;
begin
  Result := clWhite;
  for I := Low(FCalEvents) to High(FCalEvents) do begin
    if (FCalEvents[I].EventDate = Floor(Value)) then begin
      Result := FCalEvents[I].Color;
      Exit;
    end;
  end;
end;

function TCalEvents.HasEvent(Value: TDate): Boolean;
var
  I: Integer;
begin
  for I := Low(FCalEvents) to High(FCalEvents) do begin
    if (FCalEvents[I].EventDate = Floor(Value)) then begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TCalEvents.ResetEventColors;
var
  I: Integer;
begin
  for I := Low(FCalEvents) to High(FCalEvents) do begin
    FCalEvents[I].Color := FEventDefaultColor;
  end;
end;

procedure TCalEvents.SetEventDayColor(const Value: TDate; edColor: TColor);
var
  I: Integer;
begin
  for I := Low(FCalEvents) to High(FCalEvents) do begin
    if (FCalEvents[I].EventDate = Floor(Value)) then begin
      FCalEvents[I].Color := edColor;
    end;
  end;
end;

procedure TCalEvents.SetEventDefaultColor(const Value: TColor);
var
  I: Integer;
begin
  if (FEventDefaultColor <> Value) then begin
    if Length(FCalEvents) > 0 then
      for I := Low(FCalEvents) to High(FCalEvents) do begin
        if (FCalEvents[I].Color = FEventDefaultColor) then
          FCalEvents[I].Color := Value;
      end;
    FEventDefaultColor := Value;
  end;
end;

{ TCalEvent }

constructor TCalEvent.Create;
begin
  Color := clLtGray;
  EventText := '';
  EventID := '';
  ColorChg := False;
end;

destructor TCalEvent.Destroy;
begin

  inherited;
end;

{ TCalMonthColors }

procedure TCalMonthColors.Assign(Source: TPersistent);
var
  SourceName: string;
begin
  if Source = nil then SourceName := 'nil'
  else SourceName := Source.ClassName;
  if (Source = nil) or not (Source is TCalMonthColors) then
    raise EConvertError.CreateResFmt(@SAssignError, [SourceName, ClassName]);
  FTextColor := TCalMonthColors(Source).TextColor;
  FWeekendColor := TCalMonthColors(Source).WeekendColor;
  FHeaderColor := TCalMonthColors(Source).HeaderColor;
  FHeaderButtonColor := TCalMonthColors(Source).HeaderButtonColor;
  FWeekDayColor := TCalMonthColors(Source).WeekDayColor;
  FWeekNumberColor := TCalMonthColors(Source).WeekNumberColor;
  FTodayCircleColor := TCalMonthColors(Source).TodayCircleColor;
  FSelectColor := TCalMonthColors(Source).SelectColor;
  FBorderColor := TCalMonthColors(Source).BorderColor;
  FEventDefaultColor := TCalMonthColors(Source).EventDefaultColor;
  FSelectColorFont := TCalMonthColors(Source).SelectColorFont;
end;

constructor TCalMonthColors.Create(AOwner: TNxMonthCalendarExt);
begin
  Owner := AOwner;
  FTextColor := clBlack;
  FWeekendColor := clRed;
  FHeaderColor := clBtnFace;
  FHeaderButtonColor := clBlack;
  FWeekDayColor := clBlue;
  FWeekNumberColor := clBlue;
  FBorderColor := clGrayText;
  FEventDefaultColor := clMoneyGreen;
  FSelectColorFont := clNone;
  if IsThemed then begin
    FSelectColor := RGB(251, 230, 148);
    FTodayCircleColor := clMaroon;
  end else begin
    FSelectColor := clSilver;
    FTodayCircleColor := clHighlight;
  end;
end;

procedure TCalMonthColors.SetAllColors;
begin
  SetColor(0, FTextColor);
  SetColor(1, FWeekendColor);
  SetColor(2, FHeaderColor);
  SetColor(3, FHeaderButtonColor);
  SetColor(4, FWeekDayColor);
  SetColor(5, FWeekNumberColor);
  SetColor(6, FTodayCircleColor);
  SetColor(7, FSelectColor);
  SetColor(8, FBorderColor);
  SetColor(9, FEventDefaultColor);
  SetColor(10,FSelectColorFont);
end;

procedure TCalMonthColors.SetColor(Index: Integer; Value: TColor);
begin
  case Index of
    0: FTextColor := Value;
    1: FWeekendColor := Value;
    2: FHeaderColor := Value;
    3: FHeaderButtonColor := Value;
    4: FWeekDayColor := Value;
    5: FWeekNumberColor := Value;
    6: FTodayCircleColor := Value;
    7: FSelectColor := Value;
    8: FBorderColor := Value;
    9: FEventDefaultColor := Value;
   10: FSelectColorFont := Value;
  end;
  case Index of
    0: FTextColorLight := Lighten(FTextColor,150);
    1: FWeekendColorLight := Lighten(FWeekendColor,150);
  end;
  if Owner.HandleAllocated = True then
    Owner.Repaint;
end;

end.
