// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TB2Toolbar.pas' rev: 31.00 (Windows)

#ifndef Tb2toolbarHPP
#define Tb2toolbarHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ActnList.hpp>
#include <TB2Item.hpp>
#include <TB2Dock.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tb2toolbar
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TTBToolbarView;
class DELPHICLASS TTBCustomToolbar;
class DELPHICLASS TTBToolbar;
class DELPHICLASS TTBChevronItem;
class DELPHICLASS TTBChevronItemViewer;
//-- type declarations -------------------------------------------------------
typedef System::TMetaClass* TTBChevronItemClass;

typedef System::TMetaClass* TTBToolbarViewClass;

class PASCALIMPLEMENTATION TTBToolbarView : public Tb2item::TTBView
{
	typedef Tb2item::TTBView inherited;
	
private:
	TTBCustomToolbar* FToolbar;
	
protected:
	virtual void __fastcall AutoSize(int AWidth, int AHeight);
	virtual void __fastcall DoUpdatePositions(System::Types::TPoint &ASize);
	virtual Tb2item::TTBCustomItem* __fastcall GetChevronItem(void);
	virtual Tb2item::TTBCustomItem* __fastcall GetMDIButtonsItem(void);
	virtual Tb2item::TTBCustomItem* __fastcall GetMDISystemMenuItem(void);
	
public:
	__fastcall virtual TTBToolbarView(System::Classes::TComponent* AOwner, Tb2item::TTBView* AParentView, Tb2item::TTBCustomItem* AParentItem, Vcl::Controls::TWinControl* AWindow, bool AIsToolbar, bool ACustomizing, bool AUsePriorityList);
	virtual Vcl::Graphics::TFont* __fastcall GetFont(void);
	virtual void __fastcall InvalidatePositions(void);
public:
	/* TTBView.Destroy */ inline __fastcall virtual ~TTBToolbarView(void) { }
	
};


enum DECLSPEC_DENUM TTBChevronPriorityForNewItems : unsigned char { tbcpHighest, tbcpLowest };

class PASCALIMPLEMENTATION TTBCustomToolbar : public Tb2dock::TTBCustomDockableWindow
{
	typedef Tb2dock::TTBCustomDockableWindow inherited;
	
private:
	System::Types::TPoint FBaseSize;
	TTBChevronItem* FChevronItem;
	bool FChevronMoveItems;
	TTBChevronPriorityForNewItems FChevronPriorityForNewItems;
	int FDisableAlignArrange;
	int FFloatingWidth;
	bool FIgnoreMouseLeave;
	Tb2item::TTBRootItem* FItem;
	int FLastWrappedLines;
	bool FMenuBar;
	Vcl::Forms::TShortCutEvent FOnShortCut;
	bool FProcessShortCuts;
	bool FMainWindowHookInstalled;
	Tb2dock::TTBShrinkMode FShrinkMode;
	System::TObject* FSizeData;
	bool FSystemFont;
	bool FUpdateActions;
	void __fastcall CancelHover(void);
	int __fastcall CalcChevronOffset(Tb2dock::TTBDock* const ADock, const Tb2item::TTBViewOrientation AOrientation);
	int __fastcall CalcWrapOffset(Tb2dock::TTBDock* const ADock);
	Tb2item::TTBControlItem* __fastcall CreateWrapper(int Index, Vcl::Controls::TControl* Ctl);
	Tb2item::TTBControlItem* __fastcall FindWrapper(Vcl::Controls::TControl* Ctl);
	System::UnicodeString __fastcall GetChevronHint(void);
	Vcl::Imglist::TCustomImageList* __fastcall GetImages(void);
	Tb2item::TTBCustomItem* __fastcall GetItems(void);
	Vcl::Menus::TPopupMenu* __fastcall GetItemsPopupMenu(void);
	Tb2item::TTBCustomItem* __fastcall GetLinkSubitems(void);
	Tb2item::TTBItemOptions __fastcall GetOptions(void);
	void __fastcall InstallMainWindowHook(void);
	bool __fastcall IsChevronHintStored(void);
	__classmethod bool __fastcall MainWindowHook(Winapi::Messages::TMessage &Message);
	void __fastcall SetChevronHint(const System::UnicodeString Value);
	void __fastcall SetChevronMoveItems(bool Value);
	void __fastcall SetChevronPriorityForNewItems(TTBChevronPriorityForNewItems Value);
	void __fastcall SetFloatingWidth(int Value);
	void __fastcall SetImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetItemsPopupMenu(Vcl::Menus::TPopupMenu* Value);
	void __fastcall SetLinkSubitems(Tb2item::TTBCustomItem* Value);
	void __fastcall SetMainWindowHook(void);
	void __fastcall SetMenuBar(bool Value);
	void __fastcall SetOptions(Tb2item::TTBItemOptions Value);
	void __fastcall SetProcessShortCuts(bool Value);
	void __fastcall SetShrinkMode(Tb2dock::TTBShrinkMode Value);
	void __fastcall SetSystemFont(bool Value);
	void __fastcall UninstallMainWindowHook(void);
	void __fastcall UpdateViewProperties(void);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMControlChange(Vcl::Controls::TCMControlChange &Message);
	HIDESBASE MESSAGE void __fastcall CMControlListChange(Vcl::Controls::TCMControlListChange &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogKey(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMHintShow(Vcl::Controls::TCMHintShow &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMShowHintChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMWinIniChange(Winapi::Messages::TWMWinIniChange &Message);
	HIDESBASE MESSAGE void __fastcall WMCancelMode(Winapi::Messages::TWMNoParams &Message);
	MESSAGE void __fastcall WMGetObject(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCMouseMove(Winapi::Messages::TWMNCHitMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Message);
	HIDESBASE MESSAGE void __fastcall WMSysCommand(Winapi::Messages::TWMSysCommand &Message);
	
protected:
	Tb2item::TTBCustomItem* FMDIButtonsItem;
	Tb2item::TTBCustomItem* FMDISystemMenuItem;
	TTBToolbarView* FView;
	virtual void __fastcall AlignControls(Vcl::Controls::TControl* AControl, System::Types::TRect &Rect);
	DYNAMIC void __fastcall BuildPotentialSizesList(System::Classes::TList* SizesList);
	virtual void __fastcall ControlExistsAtPos(const System::Types::TPoint &P, bool &ControlExists);
	virtual System::Types::TPoint __fastcall DoArrange(bool CanMoveControls, Tb2dock::TTBDockType PreviousDockType, bool NewFloating, Tb2dock::TTBDock* NewDock);
	DYNAMIC void __fastcall DoContextPopup(const System::Types::TPoint &MousePos, bool &Handled);
	virtual void __fastcall GetBaseSize(System::Types::TPoint &ASize);
	void __fastcall GetMinBarSize(System::Types::TPoint &MinimumSize);
	virtual void __fastcall GetMinShrinkSize(int &AMinimumSize);
	virtual Tb2dock::TTBShrinkMode __fastcall GetShrinkMode(void);
	DYNAMIC TTBChevronItemClass __fastcall GetChevronItemClass(void);
	DYNAMIC Tb2item::TTBRootItemClass __fastcall GetItemClass(void);
	DYNAMIC TTBToolbarViewClass __fastcall GetViewClass(void);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall ResizeBegin(Tb2dock::TTBSizeHandle ASizeHandle);
	DYNAMIC void __fastcall ResizeTrack(System::Types::TRect &Rect, const System::Types::TRect &OrigRect);
	DYNAMIC void __fastcall ResizeTrackAccept(void);
	DYNAMIC void __fastcall ResizeEnd(void);
	DYNAMIC void __fastcall SetChildOrder(System::Classes::TComponent* Child, int Order);
	__property bool SystemFont = {read=FSystemFont, write=SetSystemFont, default=1};
	__property Vcl::Forms::TShortCutEvent OnShortCut = {read=FOnShortCut, write=FOnShortCut};
	
public:
	__fastcall virtual TTBCustomToolbar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBCustomToolbar(void);
	HIDESBASE void __fastcall BeginUpdate(void);
	HIDESBASE void __fastcall EndUpdate(void);
	void __fastcall CreateWrappersForAllControls(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC void __fastcall GetTabOrderList(System::Classes::TList* List);
	virtual void __fastcall InitiateAction(void);
	bool __fastcall IsShortCut(Winapi::Messages::TWMKey &Message);
	bool __fastcall KeyboardOpen(System::WideChar Key, bool RequirePrimaryAccel);
	DYNAMIC void __fastcall ReadPositionData(const Tb2dock::TTBReadPositionData &Data);
	DYNAMIC void __fastcall WritePositionData(const Tb2dock::TTBWritePositionData &Data);
	__property System::UnicodeString ChevronHint = {read=GetChevronHint, write=SetChevronHint, stored=IsChevronHintStored};
	__property bool ChevronMoveItems = {read=FChevronMoveItems, write=SetChevronMoveItems, default=1};
	__property TTBChevronPriorityForNewItems ChevronPriorityForNewItems = {read=FChevronPriorityForNewItems, write=SetChevronPriorityForNewItems, default=0};
	__property int FloatingWidth = {read=FFloatingWidth, write=SetFloatingWidth, default=0};
	__property Vcl::Imglist::TCustomImageList* Images = {read=GetImages, write=SetImages};
	__property Tb2item::TTBRootItem* Items = {read=FItem};
	__property Vcl::Menus::TPopupMenu* ItemsPopupMenu = {read=GetItemsPopupMenu, write=SetItemsPopupMenu};
	__property Tb2item::TTBCustomItem* LinkSubitems = {read=GetLinkSubitems, write=SetLinkSubitems};
	__property Tb2item::TTBItemOptions Options = {read=GetOptions, write=SetOptions, default=0};
	__property bool MenuBar = {read=FMenuBar, write=SetMenuBar, default=0};
	__property bool ProcessShortCuts = {read=FProcessShortCuts, write=SetProcessShortCuts, default=0};
	__property Tb2dock::TTBShrinkMode ShrinkMode = {read=FShrinkMode, write=SetShrinkMode, default=2};
	__property bool UpdateActions = {read=FUpdateActions, write=FUpdateActions, default=1};
	__property TTBToolbarView* View = {read=FView};
	
__published:
	__property Hint = {stored=false, default=0};
public:
	/* TWinControl.CreateParented */ inline __fastcall TTBCustomToolbar(HWND ParentWindow) : Tb2dock::TTBCustomDockableWindow(ParentWindow) { }
	
private:
	void *__ITBItems;	// Tb2item::ITBItems 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {A5C0D7CC-3EC4-4090-A0F8-3D03271877EA}
	operator Tb2item::_di_ITBItems()
	{
		Tb2item::_di_ITBItems intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Tb2item::ITBItems*(void) { return (Tb2item::ITBItems*)&__ITBItems; }
	#endif
	
};


class PASCALIMPLEMENTATION TTBToolbar : public TTBCustomToolbar
{
	typedef TTBCustomToolbar inherited;
	
__published:
	__property ActivateParent = {default=1};
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property AutoResize = {default=1};
	__property BorderStyle = {default=1};
	__property Caption = {default=0};
	__property ChevronHint = {default=0};
	__property ChevronMoveItems = {default=1};
	__property ChevronPriorityForNewItems = {default=0};
	__property CloseButton = {default=1};
	__property CloseButtonWhenDocked = {default=0};
	__property Color = {default=-16777201};
	__property CurrentDock;
	__property DefaultDock;
	__property DockableTo = {default=15};
	__property DockMode = {default=0};
	__property DockPos = {default=-1};
	__property DockRow = {default=0};
	__property DragHandleStyle = {default=2};
	__property FloatingMode = {default=0};
	__property FloatingWidth = {default=0};
	__property Font;
	__property FullSize = {default=0};
	__property HideWhenInactive = {default=1};
	__property Images;
	__property Items;
	__property ItemsPopupMenu;
	__property LastDock;
	__property LinkSubitems;
	__property MenuBar = {default=0};
	__property Options = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ProcessShortCuts = {default=0};
	__property Resizable = {default=1};
	__property ShowCaption = {default=1};
	__property ShowHint;
	__property ShrinkMode = {default=2};
	__property SmoothDrag = {default=1};
	__property Stretch = {default=0};
	__property SystemFont = {default=1};
	__property TabOrder = {default=-1};
	__property UpdateActions = {default=1};
	__property UseLastDock = {default=1};
	__property Visible = {default=1};
	__property OnClose;
	__property OnCloseQuery;
	__property OnContextPopup;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnMouseActivate;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMove;
	__property OnRecreated;
	__property OnRecreating;
	__property OnDockChanged;
	__property OnDockChanging;
	__property OnDockChangingHidden;
	__property OnResize;
	__property OnShortCut;
	__property OnVisibleChanged;
public:
	/* TTBCustomToolbar.Create */ inline __fastcall virtual TTBToolbar(System::Classes::TComponent* AOwner) : TTBCustomToolbar(AOwner) { }
	/* TTBCustomToolbar.Destroy */ inline __fastcall virtual ~TTBToolbar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TTBToolbar(HWND ParentWindow) : TTBCustomToolbar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TTBChevronItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	TTBCustomToolbar* FToolbar;
	System::UnicodeString __fastcall GetDefaultHint(void);
	
protected:
	virtual Tb2item::TTBView* __fastcall GetChevronParentView(void);
	virtual Tb2item::TTBItemViewerClass __fastcall GetItemViewerClass(Tb2item::TTBView* AView);
	__property TTBCustomToolbar* Toolbar = {read=FToolbar};
	
public:
	__fastcall virtual TTBChevronItem(System::Classes::TComponent* AOwner);
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBChevronItem(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBChevronItemViewer : public Tb2item::TTBItemViewer
{
	typedef Tb2item::TTBItemViewer inherited;
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* const Canvas, const System::Types::TRect &ClientAreaRect, bool IsSelected, bool IsPushed, bool UseDisabledShadow);
public:
	/* TTBItemViewer.Create */ inline __fastcall virtual TTBChevronItemViewer(Tb2item::TTBView* AView, Tb2item::TTBCustomItem* AItem, int AGroupLevel) : Tb2item::TTBItemViewer(AView, AItem, AGroupLevel) { }
	/* TTBItemViewer.Destroy */ inline __fastcall virtual ~TTBChevronItemViewer(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 tbChevronSize = System::Int8(0xc);
}	/* namespace Tb2toolbar */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TB2TOOLBAR)
using namespace Tb2toolbar;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tb2toolbarHPP
