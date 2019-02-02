// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TB2Dock.pas' rev: 31.00 (Windows)

#ifndef Tb2dockHPP
#define Tb2dockHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <System.IniFiles.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tb2dock
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TTBDock;
class DELPHICLASS TTBFloatingWindowParent;
struct TTBReadPositionData;
struct TTBWritePositionData;
class DELPHICLASS TTBCustomDockableWindow;
class DELPHICLASS TTBBasicBackground;
class DELPHICLASS TTBBackground;
//-- type declarations -------------------------------------------------------
typedef Vcl::Forms::TCustomForm TTBCustomForm;

enum DECLSPEC_DENUM TTBDockBoundLinesValues : unsigned char { blTop, blBottom, blLeft, blRight };

typedef System::Set<TTBDockBoundLinesValues, TTBDockBoundLinesValues::blTop, TTBDockBoundLinesValues::blRight> TTBDockBoundLines;

enum DECLSPEC_DENUM TTBDockPosition : unsigned char { dpTop, dpBottom, dpLeft, dpRight };

enum DECLSPEC_DENUM TTBDockType : unsigned char { dtNotDocked, dtFloating, dtTopBottom, dtLeftRight };

typedef System::Set<TTBDockPosition, TTBDockPosition::dpTop, TTBDockPosition::dpRight> TTBDockableTo;

typedef void __fastcall (__closure *TTBInsertRemoveEvent)(System::TObject* Sender, bool Inserting, TTBCustomDockableWindow* Bar);

typedef void __fastcall (__closure *TTBRequestDockEvent)(System::TObject* Sender, TTBCustomDockableWindow* Bar, bool &Accept);

class PASCALIMPLEMENTATION TTBDock : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	TTBDockPosition FPosition;
	bool FAllowDrag;
	TTBDockBoundLines FBoundLines;
	TTBBasicBackground* FBackground;
	bool FBkgOnToolbars;
	bool FFixAlign;
	bool FCommitNewPositions;
	bool FLimitToOneRow;
	TTBInsertRemoveEvent FOnInsertRemoveBar;
	TTBRequestDockEvent FOnRequestDock;
	int FDisableArrangeToolbars;
	bool FArrangeToolbarsNeeded;
	int FNonClientWidth;
	int FNonClientHeight;
	void __fastcall SetAllowDrag(bool Value);
	void __fastcall SetBackground(TTBBasicBackground* Value);
	void __fastcall SetBackgroundOnToolbars(bool Value);
	void __fastcall SetBoundLines(TTBDockBoundLines Value);
	void __fastcall SetFixAlign(bool Value);
	void __fastcall SetPosition(TTBDockPosition Value);
	int __fastcall GetToolbarCount(void);
	TTBCustomDockableWindow* __fastcall GetToolbars(int Index);
	void __fastcall BackgroundChanged(System::TObject* Sender);
	void __fastcall ChangeDockList(const bool Insert, TTBCustomDockableWindow* const Bar);
	void __fastcall CommitPositions(void);
	void __fastcall DrawNCArea(const bool DrawToDC, const HDC ADC, const HRGN Clip);
	int __fastcall GetDesignModeRowOf(const int XY);
	void __fastcall RelayMsgToFloatingBars(Winapi::Messages::TMessage &Message);
	void __fastcall ToolbarVisibilityChanged(TTBCustomDockableWindow* const Bar, const bool ForceRemove);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogKey(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMSysColorChange(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMMove(Winapi::Messages::TWMMove &Message);
	HIDESBASE MESSAGE void __fastcall WMNCCalcSize(Winapi::Messages::TWMNCCalcSize &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPrint(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSysCommand(Winapi::Messages::TWMSysCommand &Message);
	
protected:
	System::Classes::TList* DockList;
	System::Classes::TList* DockVisibleList;
	virtual bool __fastcall Accepts(TTBCustomDockableWindow* ADockableWindow);
	virtual void __fastcall AlignControls(Vcl::Controls::TControl* AControl, System::Types::TRect &Rect);
	void __fastcall ChangeWidthHeight(const int NewWidth, const int NewHeight);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall DrawBackground(HDC DC, const System::Types::TRect &DrawRect);
	DYNAMIC HPALETTE __fastcall GetPalette(void);
	bool __fastcall HasVisibleToolbars(void);
	void __fastcall InvalidateBackgrounds(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	bool __fastcall ToolbarVisibleOnDock(TTBCustomDockableWindow* const AToolbar);
	virtual void __fastcall Paint(void);
	virtual bool __fastcall UsingBackground(void);
	__property bool ArrangeToolbarsNeeded = {read=FArrangeToolbarsNeeded, write=FArrangeToolbarsNeeded, nodefault};
	__property int DisableArrangeToolbars = {read=FDisableArrangeToolbars, write=FDisableArrangeToolbars, nodefault};
	
public:
	__fastcall virtual TTBDock(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBDock(void);
	virtual void __fastcall ArrangeToolbars(void);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	int __fastcall GetCurrentRowSize(const int Row, bool &AFullSize);
	int __fastcall GetHighestRow(const bool HighestEffective);
	int __fastcall GetMinRowSize(const int Row, TTBCustomDockableWindow* const ExcludeControl);
	__property bool CommitNewPositions = {read=FCommitNewPositions, write=FCommitNewPositions, nodefault};
	__property int NonClientWidth = {read=FNonClientWidth, nodefault};
	__property int NonClientHeight = {read=FNonClientHeight, nodefault};
	__property int ToolbarCount = {read=GetToolbarCount, nodefault};
	__property TTBCustomDockableWindow* Toolbars[int Index] = {read=GetToolbars};
	
__published:
	__property bool AllowDrag = {read=FAllowDrag, write=SetAllowDrag, default=1};
	__property TTBBasicBackground* Background = {read=FBackground, write=SetBackground};
	__property bool BackgroundOnToolbars = {read=FBkgOnToolbars, write=SetBackgroundOnToolbars, default=1};
	__property TTBDockBoundLines BoundLines = {read=FBoundLines, write=SetBoundLines, default=0};
	__property Color = {default=-16777201};
	__property bool FixAlign = {read=FFixAlign, write=SetFixAlign, default=0};
	__property bool LimitToOneRow = {read=FLimitToOneRow, write=FLimitToOneRow, default=0};
	__property PopupMenu;
	__property TTBDockPosition Position = {read=FPosition, write=SetPosition, default=0};
	__property Visible = {default=1};
	__property OnContextPopup;
	__property TTBInsertRemoveEvent OnInsertRemoveBar = {read=FOnInsertRemoveBar, write=FOnInsertRemoveBar};
	__property OnMouseActivate;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property TTBRequestDockEvent OnRequestDock = {read=FOnRequestDock, write=FOnRequestDock};
	__property OnResize;
public:
	/* TWinControl.CreateParented */ inline __fastcall TTBDock(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


enum DECLSPEC_DENUM TTBToolWindowNCRedrawWhatElement : unsigned char { twrdBorder, twrdCaption, twrdCloseButton };

typedef System::Set<TTBToolWindowNCRedrawWhatElement, TTBToolWindowNCRedrawWhatElement::twrdBorder, TTBToolWindowNCRedrawWhatElement::twrdCloseButton> TTBToolWindowNCRedrawWhat;

typedef System::TMetaClass* TTBFloatingWindowParentClass;

class PASCALIMPLEMENTATION TTBFloatingWindowParent : public Vcl::Forms::TCustomForm
{
	typedef Vcl::Forms::TCustomForm inherited;
	
private:
	bool FCloseButtonDown;
	TTBCustomDockableWindow* FDockableWindow;
	Vcl::Forms::TCustomForm* FParentForm;
	bool FShouldShow;
	void __fastcall CallRecreateWnd(void);
	System::Types::TRect __fastcall GetCaptionRect(const bool AdjustForBorder, const bool MinusCloseButton);
	System::Types::TRect __fastcall GetCloseButtonRect(const bool AdjustForBorder);
	void __fastcall SetCloseButtonState(bool Pushed);
	void __fastcall RedrawNCArea(const TTBToolWindowNCRedrawWhat RedrawWhat);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogKey(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMActivate(Winapi::Messages::TWMActivate &Message);
	HIDESBASE MESSAGE void __fastcall WMClose(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMGetMinMaxInfo(Winapi::Messages::TWMGetMinMaxInfo &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	HIDESBASE MESSAGE void __fastcall WMMove(Winapi::Messages::TWMMove &Message);
	HIDESBASE MESSAGE void __fastcall WMNCCalcSize(Winapi::Messages::TWMNCCalcSize &Message);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Message);
	MESSAGE void __fastcall WMNCLButtonDblClk(Winapi::Messages::TWMNCHitMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCLButtonDown(Winapi::Messages::TWMNCHitMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMNCRButtonUp(Winapi::Messages::TWMNCHitMessage &Message);
	MESSAGE void __fastcall WMPrint(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall AlignControls(Vcl::Controls::TControl* AControl, System::Types::TRect &Rect);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	DYNAMIC void __fastcall DrawNCArea(const bool DrawToDC, const HDC ADC, const HRGN Clip, TTBToolWindowNCRedrawWhat RedrawWhat);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	__property TTBCustomDockableWindow* DockableWindow = {read=FDockableWindow};
	__property bool CloseButtonDown = {read=FCloseButtonDown, nodefault};
	
public:
	__property Vcl::Forms::TCustomForm* ParentForm = {read=FParentForm};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TTBFloatingWindowParent(System::Classes::TComponent* AOwner) : Vcl::Forms::TCustomForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TTBFloatingWindowParent(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TCustomForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TTBFloatingWindowParent(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TTBFloatingWindowParent(HWND ParentWindow) : Vcl::Forms::TCustomForm(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TTBDockChangingEvent)(System::TObject* Sender, bool Floating, TTBDock* DockingTo);

enum DECLSPEC_DENUM TTBDragHandleStyle : unsigned char { dhDouble, dhNone, dhSingle };

enum DECLSPEC_DENUM TTBDockMode : unsigned char { dmCanFloat, dmCannotFloat, dmCannotFloatOrChangeDocks };

enum DECLSPEC_DENUM TTBFloatingMode : unsigned char { fmOnTopOfParentForm, fmOnTopOfAllForms };

enum DECLSPEC_DENUM TTBSizeHandle : unsigned char { twshLeft, twshRight, twshTop, twshTopLeft, twshTopRight, twshBottom, twshBottomLeft, twshBottomRight };

typedef void * TTBPositionExtraData;

typedef int __fastcall (*TTBPositionReadIntProc)(const System::UnicodeString ToolbarName, const System::UnicodeString Value, const int Default, const void * ExtraData);

typedef System::UnicodeString __fastcall (*TTBPositionReadStringProc)(const System::UnicodeString ToolbarName, const System::UnicodeString Value, const System::UnicodeString Default, const void * ExtraData);

typedef void __fastcall (*TTBPositionWriteIntProc)(const System::UnicodeString ToolbarName, const System::UnicodeString Value, const int Data, const void * ExtraData);

typedef void __fastcall (*TTBPositionWriteStringProc)(const System::UnicodeString ToolbarName, const System::UnicodeString Value, const System::UnicodeString Data, const void * ExtraData);

struct DECLSPEC_DRECORD TTBReadPositionData
{
public:
	TTBPositionReadIntProc ReadIntProc;
	TTBPositionReadStringProc ReadStringProc;
	void *ExtraData;
};


struct DECLSPEC_DRECORD TTBWritePositionData
{
public:
	TTBPositionWriteIntProc WriteIntProc;
	TTBPositionWriteStringProc WriteStringProc;
	void *ExtraData;
};


enum DECLSPEC_DENUM Tb2dock__3 : unsigned char { tbdsResizeEightCorner, tbdsResizeClipCursor };

typedef System::Set<Tb2dock__3, Tb2dock__3::tbdsResizeEightCorner, Tb2dock__3::tbdsResizeClipCursor> TTBDockableWindowStyles;

enum DECLSPEC_DENUM TTBShrinkMode : unsigned char { tbsmNone, tbsmWrap, tbsmChevron };

class PASCALIMPLEMENTATION TTBCustomDockableWindow : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	bool FAutoResize;
	bool FDblClickUndock;
	int FDockPos;
	int FDockRow;
	int FEffectiveDockPos;
	int FEffectiveDockRow;
	bool FDocked;
	TTBDock* FCurrentDock;
	TTBDock* FDefaultDock;
	TTBDock* FLastDock;
	int FCurrentSize;
	bool FFloating;
	System::Classes::TNotifyEvent FOnClose;
	System::Classes::TNotifyEvent FOnDockChanged;
	System::Classes::TNotifyEvent FOnMove;
	System::Classes::TNotifyEvent FOnRecreated;
	System::Classes::TNotifyEvent FOnRecreating;
	System::Classes::TNotifyEvent FOnVisibleChanged;
	Vcl::Forms::TCloseQueryEvent FOnCloseQuery;
	TTBDockChangingEvent FOnDockChanging;
	TTBDockChangingEvent FOnDockChangingHidden;
	bool FActivateParent;
	bool FHideWhenInactive;
	bool FCloseButton;
	bool FCloseButtonWhenDocked;
	bool FFullSize;
	bool FResizable;
	bool FShowCaption;
	bool FStretch;
	bool FUseLastDock;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	TTBDockMode FDockMode;
	TTBDragHandleStyle FDragHandleStyle;
	TTBDockableTo FDockableTo;
	TTBFloatingMode FFloatingMode;
	bool FSmoothDrag;
	TTBDockableWindowStyles FDockableWindowStyles;
	int FLastRowSize;
	bool FInsertRowBefore;
	int FUpdatingBounds;
	int FDisableArrange;
	int FDisableOnMove;
	int FHidden;
	bool FArrangeNeeded;
	bool FMoved;
	bool FInactiveCaption;
	System::Types::TPoint FFloatingPosition;
	System::Classes::TList* FDockForms;
	bool FSavedAtRunTime;
	bool FDragMode;
	bool FDragSplitting;
	bool FDragCanSplit;
	bool FSmoothDragging;
	bool FCloseButtonDown;
	bool FCloseButtonHover;
	TTBFloatingWindowParent* FFloatParent;
	int __fastcall GetNonClientWidth(void);
	int __fastcall GetNonClientHeight(void);
	bool __fastcall IsLastDockStored(void);
	bool __fastcall IsWidthAndHeightStored(void);
	void __fastcall SetAutoResize(bool Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetCloseButton(bool Value);
	void __fastcall SetCloseButtonWhenDocked(bool Value);
	void __fastcall SetCurrentDock(TTBDock* Value);
	void __fastcall SetDefaultDock(TTBDock* Value);
	void __fastcall SetDockPos(int Value);
	void __fastcall SetDockRow(int Value);
	void __fastcall SetDragHandleStyle(TTBDragHandleStyle Value);
	void __fastcall SetFloating(bool Value);
	void __fastcall SetFloatingMode(TTBFloatingMode Value);
	void __fastcall SetFloatingPosition(const System::Types::TPoint &Value);
	void __fastcall SetFullSize(bool Value);
	void __fastcall SetLastDock(TTBDock* Value);
	void __fastcall SetResizable(bool Value);
	void __fastcall SetShowCaption(bool Value);
	void __fastcall SetStretch(bool Value);
	void __fastcall SetUseLastDock(bool Value);
	void __fastcall CancelNCHover(void);
	void __fastcall DrawDraggingOutline(const HDC DC, const System::Types::TRect &NewRect, const System::Types::TRect &OldRect, const bool NewDocking, const bool OldDocking);
	void __fastcall RedrawNCArea(void);
	void __fastcall SetCloseButtonState(bool Pushed);
	void __fastcall ShowNCContextMenu(const short PosX, const short PosY);
	void __fastcall Moved(void);
	bool __fastcall GetShowingState(void);
	void __fastcall UpdateCaptionState(void);
	void __fastcall UpdateTopmostFlag(void);
	void __fastcall UpdateVisibility(void);
	void __fastcall ReadSavedAtRunTime(System::Classes::TReader* Reader);
	void __fastcall WriteSavedAtRunTime(System::Classes::TWriter* Writer);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMVisibleChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMContextMenu(Winapi::Messages::TWMContextMenu &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMMove(Winapi::Messages::TWMMove &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMNCCalcSize(Winapi::Messages::TWMNCCalcSize &Message);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Message);
	MESSAGE void __fastcall WMNCMouseLeave(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMNCMouseMove(Winapi::Messages::TWMNCHitMessage &Message);
	MESSAGE void __fastcall WMNCLButtonDblClk(Winapi::Messages::TWMNCHitMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCLButtonDown(Winapi::Messages::TWMNCHitMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMNCRButtonUp(Winapi::Messages::TWMNCHitMessage &Message);
	MESSAGE void __fastcall WMCaptureChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPrint(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Message);
	
protected:
	__property bool ActivateParent = {read=FActivateParent, write=FActivateParent, default=1};
	__property bool AutoResize = {read=FAutoResize, write=SetAutoResize, default=1};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property Color = {default=-16777201};
	__property bool CloseButton = {read=FCloseButton, write=SetCloseButton, default=1};
	__property bool CloseButtonDown = {read=FCloseButtonDown, nodefault};
	__property bool CloseButtonHover = {read=FCloseButtonHover, nodefault};
	__property bool CloseButtonWhenDocked = {read=FCloseButtonWhenDocked, write=SetCloseButtonWhenDocked, default=0};
	__property TTBDock* DefaultDock = {read=FDefaultDock, write=SetDefaultDock};
	__property TTBDockableTo DockableTo = {read=FDockableTo, write=FDockableTo, default=15};
	__property TTBDockableWindowStyles DockableWindowStyles = {read=FDockableWindowStyles, write=FDockableWindowStyles, nodefault};
	__property TTBDockMode DockMode = {read=FDockMode, write=FDockMode, default=0};
	__property TTBDragHandleStyle DragHandleStyle = {read=FDragHandleStyle, write=SetDragHandleStyle, default=2};
	__property TTBFloatingMode FloatingMode = {read=FFloatingMode, write=SetFloatingMode, default=0};
	__property bool FullSize = {read=FFullSize, write=SetFullSize, default=0};
	__property bool InactiveCaption = {read=FInactiveCaption, nodefault};
	__property bool HideWhenInactive = {read=FHideWhenInactive, write=FHideWhenInactive, default=1};
	__property bool Resizable = {read=FResizable, write=SetResizable, default=1};
	__property bool ShowCaption = {read=FShowCaption, write=SetShowCaption, default=1};
	__property bool SmoothDrag = {read=FSmoothDrag, write=FSmoothDrag, default=1};
	__property bool Stretch = {read=FStretch, write=SetStretch, default=0};
	__property bool UseLastDock = {read=FUseLastDock, write=SetUseLastDock, default=1};
	__property System::Classes::TNotifyEvent OnClose = {read=FOnClose, write=FOnClose};
	__property Vcl::Forms::TCloseQueryEvent OnCloseQuery = {read=FOnCloseQuery, write=FOnCloseQuery};
	__property System::Classes::TNotifyEvent OnDockChanged = {read=FOnDockChanged, write=FOnDockChanged};
	__property TTBDockChangingEvent OnDockChanging = {read=FOnDockChanging, write=FOnDockChanging};
	__property TTBDockChangingEvent OnDockChangingHidden = {read=FOnDockChangingHidden, write=FOnDockChangingHidden};
	__property System::Classes::TNotifyEvent OnMove = {read=FOnMove, write=FOnMove};
	__property System::Classes::TNotifyEvent OnRecreated = {read=FOnRecreated, write=FOnRecreated};
	__property System::Classes::TNotifyEvent OnRecreating = {read=FOnRecreating, write=FOnRecreating};
	__property System::Classes::TNotifyEvent OnVisibleChanged = {read=FOnVisibleChanged, write=FOnVisibleChanged};
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	DYNAMIC HPALETTE __fastcall GetPalette(void);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC bool __fastcall PaletteChanged(bool Foreground);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	void __fastcall Arrange(void);
	virtual System::Types::TPoint __fastcall CalcNCSizes(void);
	virtual bool __fastcall CanDockTo(TTBDock* ADock);
	void __fastcall ChangeSize(int AWidth, int AHeight);
	DYNAMIC bool __fastcall ChildControlTransparent(Vcl::Controls::TControl* Ctl);
	void __fastcall Close(void);
	virtual void __fastcall ControlExistsAtPos(const System::Types::TPoint &P, bool &ControlExists);
	virtual System::Types::TPoint __fastcall DoArrange(bool CanMoveControls, TTBDockType PreviousDockType, bool NewFloating, TTBDock* NewDock) = 0 ;
	DYNAMIC void __fastcall DoDockChangingHidden(bool NewFloating, TTBDock* DockingTo);
	void __fastcall DoubleClick(void);
	virtual void __fastcall DrawNCArea(const bool DrawToDC, const HDC ADC, const HRGN Clip);
	virtual void __fastcall GetBaseSize(System::Types::TPoint &ASize) = 0 ;
	virtual System::Types::TRect __fastcall GetDockedCloseButtonRect(bool LeftRight);
	DYNAMIC TTBFloatingWindowParentClass __fastcall GetFloatingWindowParentClass(void);
	virtual void __fastcall GetMinShrinkSize(int &AMinimumSize);
	virtual void __fastcall GetMinMaxSize(int &AMinClientWidth, int &AMinClientHeight, int &AMaxClientWidth, int &AMaxClientHeight);
	virtual TTBShrinkMode __fastcall GetShrinkMode(void);
	DYNAMIC void __fastcall InitializeOrdering(void);
	bool __fastcall IsAutoResized(void);
	DYNAMIC void __fastcall ResizeBegin(TTBSizeHandle SizeHandle);
	DYNAMIC void __fastcall ResizeEnd(void);
	DYNAMIC void __fastcall ResizeTrack(System::Types::TRect &Rect, const System::Types::TRect &OrigRect);
	DYNAMIC void __fastcall ResizeTrackAccept(void);
	virtual void __fastcall SizeChanging(const int AWidth, const int AHeight);
	__property int EffectiveDockPosAccess = {read=FEffectiveDockPos, write=FEffectiveDockPos, nodefault};
	__property int EffectiveDockRowAccess = {read=FEffectiveDockRow, write=FEffectiveDockRow, nodefault};
	
public:
	__property bool DblClickUndock = {read=FDblClickUndock, write=FDblClickUndock, default=1};
	__property bool Docked = {read=FDocked, nodefault};
	__property Canvas;
	__property TTBDock* CurrentDock = {read=FCurrentDock, write=SetCurrentDock, stored=false};
	__property int CurrentSize = {read=FCurrentSize, write=FCurrentSize, nodefault};
	__property int DockPos = {read=FDockPos, write=SetDockPos, default=-1};
	__property int DockRow = {read=FDockRow, write=SetDockRow, default=0};
	__property bool DragMode = {read=FDragMode, nodefault};
	__property bool DragSplitting = {read=FDragSplitting, nodefault};
	__property int EffectiveDockPos = {read=FEffectiveDockPos, nodefault};
	__property int EffectiveDockRow = {read=FEffectiveDockRow, nodefault};
	__property bool Floating = {read=FFloating, write=SetFloating, default=0};
	__property System::Types::TPoint FloatingPosition = {read=FFloatingPosition, write=SetFloatingPosition};
	__property TTBDock* LastDock = {read=FLastDock, write=SetLastDock, stored=IsLastDockStored};
	__property int NonClientWidth = {read=GetNonClientWidth, nodefault};
	__property int NonClientHeight = {read=GetNonClientHeight, nodefault};
	__fastcall virtual TTBCustomDockableWindow(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBCustomDockableWindow(void);
	DYNAMIC System::Classes::TComponent* __fastcall GetParentComponent(void);
	DYNAMIC bool __fastcall HasParent(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall AddDockForm(Vcl::Forms::TCustomForm* const Form);
	void __fastcall AddDockedNCAreaToSize(System::Types::TPoint &S, const bool LeftRight);
	void __fastcall AddFloatingNCAreaToSize(System::Types::TPoint &S);
	void __fastcall BeginMoving(const int InitX, const int InitY);
	void __fastcall BeginSizing(const TTBSizeHandle ASizeHandle);
	void __fastcall BeginUpdate(void);
	DYNAMIC void __fastcall DoneReadingPositionData(const TTBReadPositionData &Data);
	void __fastcall EndUpdate(void);
	void __fastcall GetDockedNCArea(System::Types::TPoint &TopLeft, System::Types::TPoint &BottomRight, const bool LeftRight);
	virtual System::Types::TPoint __fastcall GetFloatingBorderSize(void);
	void __fastcall GetFloatingNCArea(System::Types::TPoint &TopLeft, System::Types::TPoint &BottomRight);
	bool __fastcall IsMovable(void);
	void __fastcall MoveOnScreen(const bool OnlyIfFullyOffscreen);
	DYNAMIC void __fastcall ReadPositionData(const TTBReadPositionData &Data);
	void __fastcall RemoveDockForm(Vcl::Forms::TCustomForm* const Form);
	DYNAMIC void __fastcall WritePositionData(const TTBWritePositionData &Data);
	
__published:
	__property Height = {stored=IsWidthAndHeightStored};
	__property Width = {stored=IsWidthAndHeightStored};
public:
	/* TWinControl.CreateParented */ inline __fastcall TTBCustomDockableWindow(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TTBBasicBackground : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
protected:
	virtual void __fastcall Draw(HDC DC, const System::Types::TRect &DrawRect) = 0 ;
	virtual HPALETTE __fastcall GetPalette(void) = 0 ;
	virtual void __fastcall RegisterChanges(System::Classes::TNotifyEvent Proc) = 0 ;
	virtual void __fastcall SysColorChanged(void) = 0 ;
	virtual void __fastcall UnregisterChanges(System::Classes::TNotifyEvent Proc) = 0 ;
	virtual bool __fastcall UsingBackground(void) = 0 ;
public:
	/* TComponent.Create */ inline __fastcall virtual TTBBasicBackground(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TTBBasicBackground(void) { }
	
};


class PASCALIMPLEMENTATION TTBBackground : public TTBBasicBackground
{
	typedef TTBBasicBackground inherited;
	
private:
	Vcl::Graphics::TBitmap* FBitmap;
	Vcl::Graphics::TBitmap* FBitmapCache;
	System::Uitypes::TColor FBkColor;
	System::Classes::TList* FNotifyList;
	bool FTransparent;
	void __fastcall BitmapChanged(System::TObject* Sender);
	void __fastcall SetBitmap(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetBkColor(System::Uitypes::TColor Value);
	void __fastcall SetTransparent(bool Value);
	
protected:
	virtual void __fastcall Draw(HDC DC, const System::Types::TRect &DrawRect);
	virtual HPALETTE __fastcall GetPalette(void);
	virtual void __fastcall RegisterChanges(System::Classes::TNotifyEvent Proc);
	virtual void __fastcall SysColorChanged(void);
	virtual void __fastcall UnregisterChanges(System::Classes::TNotifyEvent Proc);
	virtual bool __fastcall UsingBackground(void);
	
public:
	__fastcall virtual TTBBackground(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBBackground(void);
	
__published:
	__property Vcl::Graphics::TBitmap* Bitmap = {read=FBitmap, write=SetBitmap};
	__property System::Uitypes::TColor BkColor = {read=FBkColor, write=SetBkColor, default=-16777201};
	__property bool Transparent = {read=FTransparent, write=SetTransparent, default=0};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TTBDockType __fastcall TBGetDockTypeOf(TTBDock* const Control, const bool Floating);
extern DELPHI_PACKAGE Vcl::Forms::TCustomForm* __fastcall TBGetToolWindowParentForm(TTBCustomDockableWindow* const ToolWindow);
extern DELPHI_PACKAGE Vcl::Forms::TCustomForm* __fastcall TBValidToolWindowParentForm(TTBCustomDockableWindow* const ToolWindow);
extern DELPHI_PACKAGE void __fastcall TBCustomLoadPositions(System::Classes::TComponent* const OwnerComponent, const TTBPositionReadIntProc ReadIntProc, const TTBPositionReadStringProc ReadStringProc, const void * ExtraData);
extern DELPHI_PACKAGE void __fastcall TBCustomSavePositions(System::Classes::TComponent* const OwnerComponent, const TTBPositionWriteIntProc WriteIntProc, const TTBPositionWriteStringProc WriteStringProc, const void * ExtraData);
extern DELPHI_PACKAGE void __fastcall TBIniLoadPositions(System::Classes::TComponent* const OwnerComponent, System::Inifiles::TCustomIniFile* const IniFile, const System::UnicodeString SectionNamePrefix)/* overload */;
extern DELPHI_PACKAGE void __fastcall TBIniLoadPositions(System::Classes::TComponent* const OwnerComponent, const System::UnicodeString Filename, const System::UnicodeString SectionNamePrefix)/* overload */;
extern DELPHI_PACKAGE void __fastcall TBIniSavePositions(System::Classes::TComponent* const OwnerComponent, System::Inifiles::TCustomIniFile* const IniFile, const System::UnicodeString SectionNamePrefix)/* overload */;
extern DELPHI_PACKAGE void __fastcall TBIniSavePositions(System::Classes::TComponent* const OwnerComponent, const System::UnicodeString Filename, const System::UnicodeString SectionNamePrefix)/* overload */;
extern DELPHI_PACKAGE void __fastcall TBRegLoadPositions(System::Classes::TComponent* const OwnerComponent, const unsigned RootKey, const System::UnicodeString BaseRegistryKey);
extern DELPHI_PACKAGE void __fastcall TBRegSavePositions(System::Classes::TComponent* const OwnerComponent, const unsigned RootKey, const System::UnicodeString BaseRegistryKey);
}	/* namespace Tb2dock */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TB2DOCK)
using namespace Tb2dock;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tb2dockHPP
