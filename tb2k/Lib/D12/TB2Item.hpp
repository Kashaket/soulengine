// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TB2Item.pas' rev: 31.00 (Windows)

#ifndef Tb2itemHPP
#define Tb2itemHPP

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
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ActnList.hpp>
#include <Vcl.ImgList.hpp>
#include <TB2Anim.hpp>
#include <System.Actions.hpp>
#include <System.UITypes.hpp>
#include <System.ImageList.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tb2item
{
//-- forward type declarations -----------------------------------------------
struct TTBDoneActionData;
class DELPHICLASS ETBItemError;
class DELPHICLASS TTBImageChangeLink;
struct TTBPopupPositionRec;
class DELPHICLASS TTBCustomItem;
class DELPHICLASS TTBCustomItemActionLink;
class DELPHICLASS TTBBaseAccObject;
class DELPHICLASS TTBItemViewer;
class DELPHICLASS TTBView;
class DELPHICLASS TTBRootItem;
class DELPHICLASS TTBItem;
class DELPHICLASS TTBGroupItem;
class DELPHICLASS TTBSubmenuItem;
class DELPHICLASS TTBSeparatorItem;
class DELPHICLASS TTBSeparatorItemViewer;
class DELPHICLASS TTBControlItem;
class DELPHICLASS TTBPopupView;
__interface ITBPopupWindow;
typedef System::DelphiInterface<ITBPopupWindow> _di_ITBPopupWindow;
class DELPHICLASS TTBPopupWindow;
__interface ITBItems;
typedef System::DelphiInterface<ITBItems> _di_ITBItems;
class DELPHICLASS TTBItemContainer;
class DELPHICLASS TTBPopupMenu;
class DELPHICLASS TTBCustomImageList;
class DELPHICLASS TTBImageList;
class DELPHICLASS TTBModalHandler;
//-- type declarations -------------------------------------------------------
typedef System::TMetaClass* TTBCustomItemClass;

typedef System::TMetaClass* TTBCustomItemActionLinkClass;

typedef System::TMetaClass* TTBItemViewerClass;

typedef System::TMetaClass* TTBPopupWindowClass;

typedef void __fastcall (__closure *TTBAdjustImageIndexEvent)(TTBCustomItem* Sender, System::Uitypes::TImageIndex &AImageIndex);

enum DECLSPEC_DENUM TTBDoneAction : unsigned char { tbdaNone, tbdaCancel, tbdaClickItem, tbdaOpenSystemMenu, tbdaHelpContext };

struct DECLSPEC_DRECORD TTBDoneActionData
{
public:
	TTBDoneAction DoneAction;
	TTBCustomItem* ClickItem;
	bool Sound;
	HWND Wnd;
	System::Word Key;
	int ContextID;
};


typedef void __fastcall (__closure *TTBInsertItemProc)(System::Classes::TComponent* AParent, TTBCustomItem* AItem);

enum DECLSPEC_DENUM TTBItemChangedAction : unsigned char { tbicInserted, tbicDeleting, tbicSubitemsChanged, tbicSubitemsBeginUpdate, tbicSubitemsEndUpdate, tbicInvalidate, tbicInvalidateAndResize, tbicRecreateItemViewers, tbicNameChanged, tbicSubMenuImagesChanged };

typedef void __fastcall (__closure *TTBItemChangedProc)(TTBCustomItem* Sender, bool Relayed, TTBItemChangedAction Action, int Index, TTBCustomItem* Item);

enum DECLSPEC_DENUM TTBItemDisplayMode : unsigned char { nbdmDefault, nbdmTextOnly, nbdmTextOnlyInMenus, nbdmImageAndText };

enum DECLSPEC_DENUM TTBItemOption : unsigned char { tboDefault, tboDropdownArrow, tboImageAboveCaption, tboLongHintInMenuOnly, tboNoAutoHint, tboNoRotation, tboSameWidth, tboShowHint, tboToolbarStyle, tboToolbarSize };

typedef System::Set<TTBItemOption, TTBItemOption::tboDefault, TTBItemOption::tboToolbarSize> TTBItemOptions;

enum DECLSPEC_DENUM Tb2item__1 : unsigned char { tbisSubmenu, tbisSelectable, tbisSeparator, tbisEmbeddedGroup, tbisClicksTransparent, tbisCombo, tbisNoAutoOpen, tbisSubitemsEditable, tbisNoLineBreak, tbisRightAlign, tbisDontSelectFirst, tbisRedrawOnSelChange, tbisRedrawOnMouseOverChange, tbisStretch };

typedef System::Set<Tb2item__1, Tb2item__1::tbisSubmenu, Tb2item__1::tbisStretch> TTBItemStyle;

enum DECLSPEC_DENUM TTBOrientation : unsigned char { tboHorizontal, tboVertical };

enum DECLSPEC_DENUM TTBPopupAlignment : unsigned char { tbpaLeft, tbpaRight, tbpaCenter };

typedef void __fastcall (__closure *TTBPopupEvent)(TTBCustomItem* Sender, bool FromLink);

typedef void __fastcall (__closure *TTBSelectEvent)(TTBCustomItem* Sender, TTBItemViewer* Viewer, bool Selecting);

#pragma pack(push,4)
class PASCALIMPLEMENTATION ETBItemError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall ETBItemError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ETBItemError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall ETBItemError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ETBItemError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ETBItemError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall ETBItemError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall ETBItemError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ETBItemError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ETBItemError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ETBItemError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ETBItemError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ETBItemError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ETBItemError(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TTBImageChangeLink : public Vcl::Imglist::TChangeLink
{
	typedef Vcl::Imglist::TChangeLink inherited;
	
private:
	int FLastWidth;
	int FLastHeight;
public:
	/* TChangeLink.Create */ inline __fastcall virtual TTBImageChangeLink(void) : Vcl::Imglist::TChangeLink() { }
	
public:
	/* TImageLink.Destroy */ inline __fastcall virtual ~TTBImageChangeLink(void) { }
	
};


struct DECLSPEC_DRECORD TTBPopupPositionRec
{
	
public:
	union
	{
		struct 
		{
			bool HorzHideSeparators;
			int HorzWrapOffset;
			TTBOrientation PopupOrientation;
		};
		struct 
		{
			bool PositionAsSubmenu;
			TTBPopupAlignment Alignment;
			bool Opposite;
			System::Types::TRect MonitorRect;
			System::Types::TRect ParentItemRect;
			int NCSizeX;
			int NCSizeY;
			int X;
			int Y;
			int W;
			int H;
			Tb2anim::TTBAnimationDirection AnimDir;
			bool PlaySound;
		};
		
	};
};


class PASCALIMPLEMENTATION TTBCustomItem : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	TTBCustomItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TTBCustomItemActionLink* FActionLink;
	bool FAutoCheck;
	System::UnicodeString FCaption;
	bool FChecked;
	TTBItemDisplayMode FDisplayMode;
	bool FEnabled;
	TTBItemOptions FEffectiveOptions;
	int FGroupIndex;
	System::Classes::THelpContext FHelpContext;
	System::UnicodeString FHint;
	System::Uitypes::TImageIndex FImageIndex;
	Vcl::Imglist::TCustomImageList* FImages;
	TTBImageChangeLink* FImagesChangeLink;
	System::Classes::TList* FItems;
	TTBItemStyle FItemStyle;
	System::Classes::TList* FLinkParents;
	TTBItemOptions FMaskOptions;
	TTBItemOptions FOptions;
	Vcl::Menus::TPopupMenu* FPopupMenu;
	bool FInheritOptions;
	System::Classes::TList* FNotifyList;
	TTBAdjustImageIndexEvent FOnAdjustImageIndex;
	System::Classes::TNotifyEvent FOnClick;
	TTBPopupEvent FOnPopup;
	TTBSelectEvent FOnSelect;
	TTBCustomItem* FParent;
	System::Classes::TComponent* FParentComponent;
	bool FRadioItem;
	System::Classes::TShortCut FShortCut;
	Vcl::Menus::TPopupMenu* FSubitemsPopupMenu;
	Vcl::Imglist::TCustomImageList* FSubMenuImages;
	TTBImageChangeLink* FSubMenuImagesChangeLink;
	TTBCustomItem* FLinkSubitems;
	bool FVisible;
	void __fastcall DoActionChange(System::TObject* Sender);
	bool __fastcall ChangeImages(Vcl::Imglist::TCustomImageList* &AImages, Vcl::Imglist::TCustomImageList* const Value, TTBImageChangeLink* &AChangeLink);
	__classmethod void __fastcall ClickWndProc(Winapi::Messages::TMessage &Message);
	TTBCustomItem* __fastcall FindItemWithShortCut(System::Classes::TShortCut AShortCut, TTBCustomItem* &ATopmostParent);
	TTBItemOptions __fastcall FixOptions(const TTBItemOptions AOptions);
	System::Classes::TBasicAction* __fastcall GetAction(void);
	int __fastcall GetCount(void);
	TTBCustomItem* __fastcall GetItem(int Index);
	void __fastcall ImageListChangeHandler(System::TObject* Sender);
	void __fastcall InternalNotify(TTBCustomItem* Ancestor, int NestingLevel, TTBItemChangedAction Action, int Index, TTBCustomItem* Item);
	void __fastcall InternalSetPopupMenu(Vcl::Menus::TPopupMenu* &Menu, Vcl::Menus::TPopupMenu* NewMenu);
	bool __fastcall IsAutoCheckStored(void);
	bool __fastcall IsCaptionStored(void);
	bool __fastcall IsCheckedStored(void);
	bool __fastcall IsEnabledStored(void);
	bool __fastcall IsHelpContextStored(void);
	bool __fastcall IsHintStored(void);
	bool __fastcall IsImageIndexStored(void);
	bool __fastcall IsOnClickStored(void);
	bool __fastcall IsShortCutStored(void);
	bool __fastcall IsVisibleStored(void);
	void __fastcall Notify(TTBItemChangedAction Action, int Index, TTBCustomItem* Item);
	void __fastcall RefreshOptions(void);
	void __fastcall SetAction(System::Classes::TBasicAction* Value);
	void __fastcall SetCaption(System::UnicodeString Value);
	void __fastcall SetChecked(bool Value);
	void __fastcall SetDisplayMode(TTBItemDisplayMode Value);
	void __fastcall SetEnabled(bool Value);
	void __fastcall SetGroupIndex(int Value);
	void __fastcall SetImageIndex(System::Uitypes::TImageIndex Value);
	void __fastcall SetImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetInheritOptions(bool Value);
	void __fastcall SetLinkSubitems(TTBCustomItem* Value);
	void __fastcall SetMaskOptions(TTBItemOptions Value);
	void __fastcall SetOptions(TTBItemOptions Value);
	void __fastcall SetPopupMenu(Vcl::Menus::TPopupMenu* Value);
	void __fastcall SetRadioItem(bool Value);
	void __fastcall SetSubitemsPopupMenu(Vcl::Menus::TPopupMenu* Value);
	void __fastcall SetSubMenuImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetVisible(bool Value);
	void __fastcall SubMenuImagesChanged(void);
	void __fastcall TurnSiblingsOff(void);
	
protected:
	DYNAMIC void __fastcall ActionChange(System::TObject* Sender, bool CheckDefaults);
	virtual void __fastcall Change(bool NeedResize);
	virtual TTBPopupWindow* __fastcall CreatePopup(TTBView* const ParentView, TTBItemViewer* const ParentViewer, const bool PositionAsSubmenu, const bool SelectFirstItem, const bool Customizing, const System::Types::TPoint &APopupPoint, const TTBPopupAlignment Alignment);
	virtual void __fastcall DoPopup(TTBCustomItem* Sender, bool FromLink);
	virtual void __fastcall EnabledChanged(void);
	DYNAMIC TTBCustomItemActionLinkClass __fastcall GetActionLinkClass(void);
	virtual TTBView* __fastcall GetChevronParentView(void);
	virtual bool __fastcall GetChevronPopupPosition(TTBPopupPositionRec &PopupPositionRec);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	virtual System::Uitypes::TImageIndex __fastcall GetImageIndex(void);
	virtual TTBItemViewerClass __fastcall GetItemViewerClass(TTBView* AView);
	virtual void __fastcall GetPopupPosition(TTBView* ParentView, TTBPopupWindow* PopupWindow, TTBPopupPositionRec &PopupPositionRec);
	virtual TTBPopupWindowClass __fastcall GetPopupWindowClass(void);
	__classmethod void __fastcall IndexError();
	virtual void __fastcall Loaded(void);
	virtual bool __fastcall NeedToRecreateViewer(TTBItemViewer* AViewer);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	TTBCustomItem* __fastcall OpenPopup(const bool SelectFirstItem, const bool TrackRightButton, const System::Types::TPoint &PopupPoint, const TTBPopupAlignment Alignment, const bool ReturnClickedItemOnly);
	void __fastcall RecreateItemViewers(void);
	DYNAMIC void __fastcall SetChildOrder(System::Classes::TComponent* Child, int Order);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	DYNAMIC void __fastcall SetParentComponent(System::Classes::TComponent* Value);
	__property TTBCustomItemActionLink* ActionLink = {read=FActionLink, write=FActionLink};
	__property TTBItemStyle ItemStyle = {read=FItemStyle, write=FItemStyle, nodefault};
	
public:
	__fastcall virtual TTBCustomItem(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBCustomItem(void);
	DYNAMIC bool __fastcall HasParent(void);
	DYNAMIC System::Classes::TComponent* __fastcall GetParentComponent(void);
	void __fastcall Add(TTBCustomItem* AItem);
	void __fastcall Clear(void);
	virtual void __fastcall Click(void);
	bool __fastcall ContainsItem(TTBCustomItem* AItem);
	void __fastcall Delete(int Index);
	TTBItemStyle __fastcall GetItemStyle(void);
	System::UnicodeString __fastcall GetShortCutText(void);
	int __fastcall IndexOf(TTBCustomItem* AItem);
	virtual void __fastcall InitiateAction(void);
	HIDESBASE void __fastcall Insert(int NewIndex, TTBCustomItem* AItem);
	bool __fastcall IsShortCut(Winapi::Messages::TWMKey &Message);
	void __fastcall Move(int CurIndex, int NewIndex);
	TTBCustomItem* __fastcall Popup(int X, int Y, bool TrackRightButton, TTBPopupAlignment Alignment = (TTBPopupAlignment)(0x0), bool ReturnClickedItemOnly = false);
	void __fastcall PostClick(void);
	void __fastcall RegisterNotification(TTBItemChangedProc ANotify);
	HIDESBASE void __fastcall Remove(TTBCustomItem* Item);
	void __fastcall UnregisterNotification(TTBItemChangedProc ANotify);
	void __fastcall ViewBeginUpdate(void);
	void __fastcall ViewEndUpdate(void);
	__property System::Classes::TBasicAction* Action = {read=GetAction, write=SetAction};
	__property bool AutoCheck = {read=FAutoCheck, write=FAutoCheck, stored=IsAutoCheckStored, default=0};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption, stored=IsCaptionStored};
	__property int Count = {read=GetCount, nodefault};
	__property bool Checked = {read=FChecked, write=SetChecked, stored=IsCheckedStored, default=0};
	__property TTBItemDisplayMode DisplayMode = {read=FDisplayMode, write=SetDisplayMode, default=0};
	__property TTBItemOptions EffectiveOptions = {read=FEffectiveOptions, nodefault};
	__property bool Enabled = {read=FEnabled, write=SetEnabled, stored=IsEnabledStored, default=1};
	__property int GroupIndex = {read=FGroupIndex, write=SetGroupIndex, default=0};
	__property System::Classes::THelpContext HelpContext = {read=FHelpContext, write=FHelpContext, stored=IsHelpContextStored, default=0};
	__property System::UnicodeString Hint = {read=FHint, write=FHint, stored=IsHintStored};
	__property System::Uitypes::TImageIndex ImageIndex = {read=GetImageIndex, write=SetImageIndex, stored=IsImageIndexStored, default=-1};
	__property Vcl::Imglist::TCustomImageList* Images = {read=FImages, write=SetImages};
	__property bool InheritOptions = {read=FInheritOptions, write=SetInheritOptions, default=1};
	__property TTBCustomItem* Items[int Index] = {read=GetItem/*, default*/};
	__property TTBCustomItem* LinkSubitems = {read=FLinkSubitems, write=SetLinkSubitems};
	__property TTBItemOptions MaskOptions = {read=FMaskOptions, write=SetMaskOptions, default=0};
	__property TTBItemOptions Options = {read=FOptions, write=SetOptions, default=0};
	__property TTBCustomItem* Parent = {read=FParent};
	__property System::Classes::TComponent* ParentComponent = {read=FParentComponent, write=FParentComponent};
	__property Vcl::Menus::TPopupMenu* PopupMenu = {read=FPopupMenu, write=SetPopupMenu};
	__property bool RadioItem = {read=FRadioItem, write=SetRadioItem, default=0};
	__property System::Classes::TShortCut ShortCut = {read=FShortCut, write=FShortCut, stored=IsShortCutStored, default=0};
	__property Vcl::Imglist::TCustomImageList* SubMenuImages = {read=FSubMenuImages, write=SetSubMenuImages};
	__property Vcl::Menus::TPopupMenu* SubitemsPopupMenu = {read=FSubitemsPopupMenu, write=SetSubitemsPopupMenu};
	__property bool Visible = {read=FVisible, write=SetVisible, stored=IsVisibleStored, default=1};
	__property TTBAdjustImageIndexEvent OnAdjustImageIndex = {read=FOnAdjustImageIndex, write=FOnAdjustImageIndex};
	__property System::Classes::TNotifyEvent OnClick = {read=FOnClick, write=FOnClick, stored=IsOnClickStored};
	__property TTBPopupEvent OnPopup = {read=FOnPopup, write=FOnPopup};
	__property TTBSelectEvent OnSelect = {read=FOnSelect, write=FOnSelect};
};


class PASCALIMPLEMENTATION TTBCustomItemActionLink : public Vcl::Actnlist::TActionLink
{
	typedef Vcl::Actnlist::TActionLink inherited;
	
protected:
	TTBCustomItem* FClient;
	virtual void __fastcall AssignClient(System::TObject* AClient);
	virtual bool __fastcall IsAutoCheckLinked(void);
	virtual bool __fastcall IsCaptionLinked(void);
	virtual bool __fastcall IsCheckedLinked(void);
	virtual bool __fastcall IsEnabledLinked(void);
	virtual bool __fastcall IsHelpContextLinked(void);
	virtual bool __fastcall IsHintLinked(void);
	virtual bool __fastcall IsImageIndexLinked(void);
	virtual bool __fastcall IsShortCutLinked(void);
	virtual bool __fastcall IsVisibleLinked(void);
	virtual bool __fastcall IsOnExecuteLinked(void);
	virtual void __fastcall SetAutoCheck(bool Value);
	virtual void __fastcall SetCaption(const System::UnicodeString Value);
	virtual void __fastcall SetChecked(bool Value);
	virtual void __fastcall SetEnabled(bool Value);
	virtual void __fastcall SetHelpContext(System::Classes::THelpContext Value);
	virtual void __fastcall SetHint(const System::UnicodeString Value);
	virtual void __fastcall SetImageIndex(int Value);
	virtual void __fastcall SetShortCut(System::Classes::TShortCut Value);
	virtual void __fastcall SetVisible(bool Value);
	virtual void __fastcall SetOnExecute(System::Classes::TNotifyEvent Value);
public:
	/* TBasicActionLink.Create */ inline __fastcall virtual TTBCustomItemActionLink(System::TObject* AClient) : Vcl::Actnlist::TActionLink(AClient) { }
	/* TBasicActionLink.Destroy */ inline __fastcall virtual ~TTBCustomItemActionLink(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBBaseAccObject : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
public:
	virtual void __fastcall ClientIsDestroying(void) = 0 ;
	HRESULT __stdcall GetTypeInfoCount(/* out */ int &Count);
	HRESULT __stdcall GetTypeInfo(int Index, int LocaleID, /* out */ void *TypeInfo);
	HRESULT __stdcall GetIDsOfNames(const GUID &IID, void * Names, int NameCount, int LocaleID, void * DispIDs);
	HRESULT __stdcall Invoke(int DispID, const GUID &IID, int LocaleID, System::Word Flags, void *Params, void * VarResult, void * ExcepInfo, void * ArgErr);
public:
	/* TObject.Create */ inline __fastcall TTBBaseAccObject(void) : System::TInterfacedObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TTBBaseAccObject(void) { }
	
private:
	void *__IDispatch;	// IDispatch 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00020400-0000-0000-C000-000000000046}
	operator _di_IDispatch()
	{
		_di_IDispatch intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IDispatch*(void) { return (IDispatch*)&__IDispatch; }
	#endif
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBItemViewer : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	enum DECLSPEC_DENUM _TTBItemViewer__1 : unsigned char { tbisInvalidated, tbisLineSep };
	
	
private:
	System::Types::TRect FBoundsRect;
	bool FClipped;
	int FGroupLevel;
	TTBCustomItem* FItem;
	bool FOffEdge;
	bool FShow;
	TTBView* FView;
	void __fastcall AccSelect(const bool AExecute);
	int __fastcall GetIndex(void);
	
protected:
	TTBBaseAccObject* FAccObjectInstance;
	virtual void __fastcall CalcSize(Vcl::Graphics::TCanvas* const Canvas, int &AWidth, int &AHeight);
	DYNAMIC bool __fastcall CaptionShown(void);
	virtual bool __fastcall DoExecute(void);
	virtual void __fastcall DrawItemCaption(Vcl::Graphics::TCanvas* const Canvas, const System::Types::TRect &ARect, const System::UnicodeString ACaption, bool ADrawDisabledShadow, unsigned AFormat);
	virtual void __fastcall Entering(TTBItemViewer* OldSelected);
	virtual int __fastcall GetAccRole(void);
	virtual bool __fastcall GetAccValue(System::WideString &Value);
	virtual System::UnicodeString __fastcall GetCaptionText(void);
	virtual void __fastcall GetCursor(const System::Types::TPoint &Pt, HICON &ACursor);
	Vcl::Imglist::TCustomImageList* __fastcall GetImageList(void);
	bool __fastcall ImageShown(void);
	bool __fastcall IsRotated(void);
	virtual bool __fastcall IsToolbarSize(void);
	virtual bool __fastcall IsPtInButtonPart(int X, int Y);
	virtual void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall Leaving(void);
	virtual void __fastcall LosingCapture(void);
	virtual void __fastcall MouseDown(System::Classes::TShiftState Shift, int X, int Y, bool &MouseDownOnMenu);
	virtual void __fastcall MouseMove(int X, int Y);
	virtual void __fastcall MouseUp(int X, int Y, bool MouseWasDownOnMenu);
	virtual void __fastcall MouseWheel(int WheelDelta, int X, int Y, bool &Handled);
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* const Canvas, const System::Types::TRect &ClientAreaRect, bool IsSelected, bool IsPushed, bool UseDisabledShadow);
	void __fastcall PostAccSelect(const bool AExecute);
	virtual bool __fastcall UsesSameWidth(void);
	
public:
	System::Set<_TTBItemViewer__1, _TTBItemViewer__1::tbisInvalidated, _TTBItemViewer__1::tbisLineSep> State;
	__property System::Types::TRect BoundsRect = {read=FBoundsRect};
	__property bool Clipped = {read=FClipped, nodefault};
	__property int Index = {read=GetIndex, nodefault};
	__property TTBCustomItem* Item = {read=FItem};
	__property bool OffEdge = {read=FOffEdge, nodefault};
	__property bool Show = {read=FShow, nodefault};
	__property TTBView* View = {read=FView};
	__fastcall virtual TTBItemViewer(TTBView* AView, TTBCustomItem* AItem, int AGroupLevel);
	__fastcall virtual ~TTBItemViewer(void);
	void __fastcall Execute(bool AGivePriority);
	TTBBaseAccObject* __fastcall GetAccObject(void);
	System::UnicodeString __fastcall GetHintText(void);
	DYNAMIC Vcl::Menus::TPopupMenu* __fastcall GetPopupMenu(void);
	bool __fastcall IsAccessible(void);
	virtual bool __fastcall IsToolbarStyle(void);
	System::Types::TPoint __fastcall ScreenToClient(const System::Types::TPoint &P);
};

#pragma pack(pop)

enum DECLSPEC_DENUM TTBViewOrientation : unsigned char { tbvoHorizontal, tbvoVertical, tbvoFloating };

enum DECLSPEC_DENUM Tb2item__8 : unsigned char { tbetMouseDown, tbetExecuteSelected, tbetFromMSAA };

typedef System::Set<Tb2item__8, Tb2item__8::tbetMouseDown, Tb2item__8::tbetFromMSAA> TTBEnterToolbarLoopOptions;

enum DECLSPEC_DENUM Tb2item__9 : unsigned char { vsModal, vsMouseInWindow, vsDrawInOrder, vsOppositePopup, vsIgnoreFirstMouseUp, vsShowAccels, vsDropDownMenus, vsNoAnimation };

typedef System::Set<Tb2item__9, Tb2item__9::vsModal, Tb2item__9::vsNoAnimation> TTBViewState;

enum DECLSPEC_DENUM Tb2item__01 : unsigned char { vsMenuBar, vsUseHiddenAccels, vsAlwaysShowHints };

typedef System::Set<Tb2item__01, Tb2item__01::vsMenuBar, Tb2item__01::vsAlwaysShowHints> TTBViewStyle;

enum DECLSPEC_DENUM TTBViewTimerID : unsigned char { tiOpen, tiClose, tiScrollUp, tiScrollDown };

typedef System::TMetaClass* TTBViewClass;

class PASCALIMPLEMENTATION TTBView : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	System::Classes::TList* FViewers;
	System::Set<TTBViewTimerID, TTBViewTimerID::tiOpen, TTBViewTimerID::tiScrollDown> FActiveTimers;
	System::Uitypes::TColor FBackgroundColor;
	System::Types::TPoint FBaseSize;
	bool FCapture;
	HWND FCaptureWnd;
	int FChevronOffset;
	TTBView* FChevronParentView;
	int FChevronSize;
	TTBCustomItem* FCurParentItem;
	bool FCustomizing;
	TTBDoneActionData FDoneActionData;
	int FInternalViewersAtEnd;
	int FInternalViewersAtFront;
	bool FIsPopup;
	bool FIsToolbar;
	int FMaxHeight;
	System::Types::TRect FMonitorRect;
	bool FMouseOverSelected;
	bool FNewViewersGetHighestPriority;
	TTBItemViewer* FOpenViewer;
	TTBView* FOpenViewerView;
	TTBPopupWindow* FOpenViewerWindow;
	TTBView* FParentView;
	TTBCustomItem* FParentItem;
	System::Classes::TList* FPriorityList;
	TTBViewOrientation FOrientation;
	int FScrollOffset;
	TTBItemViewer* FSelected;
	bool FSelectedViaMouse;
	bool FShowDownArrow;
	bool FShowUpArrow;
	TTBViewState FState;
	TTBViewStyle FStyle;
	int FUpdating;
	bool FUsePriorityList;
	bool FValidated;
	int FWheelAccumulator;
	Vcl::Controls::TWinControl* FWindow;
	int FWrapOffset;
	void __fastcall DeletingViewer(TTBItemViewer* Viewer);
	void __fastcall DrawItem(TTBItemViewer* Viewer, Vcl::Graphics::TCanvas* DrawTo, bool Offscreen);
	void __fastcall FreeViewers(void);
	TTBItemViewer* __fastcall GetViewer(int Index);
	int __fastcall GetViewerCount(void);
	void __fastcall ImagesChanged(void);
	int __fastcall InsertItemViewers(const int NewIndex, TTBCustomItem* const AItem, const int AGroupLevel, const bool AddToPriorityList, const bool TopOfPriorityList);
	void __fastcall ItemNotification(TTBCustomItem* Ancestor, bool Relayed, TTBItemChangedAction Action, int Index, TTBCustomItem* Item);
	void __fastcall LinkNotification(TTBCustomItem* Ancestor, bool Relayed, TTBItemChangedAction Action, int Index, TTBCustomItem* Item);
	void __fastcall RecreateItemViewer(const int I);
	void __fastcall Scroll(bool ADown);
	void __fastcall SetCustomizing(bool Value);
	void __fastcall SetSelected(TTBItemViewer* Value);
	void __fastcall SetUsePriorityList(bool Value);
	void __fastcall StartTimer(const TTBViewTimerID ATimer, const int Interval);
	void __fastcall StopAllTimers(void);
	void __fastcall StopTimer(const TTBViewTimerID ATimer);
	void __fastcall UpdateCurParentItem(void);
	
protected:
	TTBBaseAccObject* FAccObjectInstance;
	virtual void __fastcall AutoSize(int AWidth, int AHeight);
	bool __fastcall CalculatePositions(const bool CanMoveControls, const TTBViewOrientation AOrientation, int AWrapOffset, int AChevronOffset, int AChevronSize, System::Types::TPoint &ABaseSize, System::Types::TPoint &TotalSize, int &AWrappedLines);
	virtual void __fastcall DoUpdatePositions(System::Types::TPoint &ASize);
	virtual TTBCustomItem* __fastcall GetChevronItem(void);
	virtual void __fastcall GetMargins(TTBViewOrientation AOrientation, System::Types::TRect &Margins);
	virtual TTBCustomItem* __fastcall GetMDIButtonsItem(void);
	virtual TTBCustomItem* __fastcall GetMDISystemMenuItem(void);
	TTBView* __fastcall GetParentToolbarView(void);
	TTBView* __fastcall GetRootView(void);
	bool __fastcall HandleWMGetObject(Winapi::Messages::TMessage &Message);
	void __fastcall InitiateActions(void);
	virtual void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall MouseWheel(int WheelDelta, int X, int Y);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetAccelsVisibility(bool AShowAccels);
	void __fastcall SetState(TTBViewState AState);
	__property TTBDoneActionData DoneActionData = {read=FDoneActionData, write=FDoneActionData};
	__property bool ShowDownArrow = {read=FShowDownArrow, nodefault};
	__property bool ShowUpArrow = {read=FShowUpArrow, nodefault};
	
public:
	__fastcall virtual TTBView(System::Classes::TComponent* AOwner, TTBView* AParentView, TTBCustomItem* AParentItem, Vcl::Controls::TWinControl* AWindow, bool AIsToolbar, bool ACustomizing, bool AUsePriorityList);
	__fastcall virtual ~TTBView(void);
	void __fastcall BeginUpdate(void);
	void __fastcall CancelCapture(void);
	void __fastcall CancelChildPopups(void);
	void __fastcall CancelMode(void);
	void __fastcall CloseChildPopups(void);
	bool __fastcall ContainsView(TTBView* AView);
	void __fastcall DrawSubitems(Vcl::Graphics::TCanvas* ACanvas);
	void __fastcall EndModal(void);
	void __fastcall EndModalWithClick(TTBItemViewer* AViewer);
	void __fastcall EndModalWithHelp(int AContextID);
	void __fastcall EndModalWithSystemMenu(HWND AWnd, System::Word AKey);
	void __fastcall EndUpdate(void);
	void __fastcall EnterToolbarLoop(TTBEnterToolbarLoopOptions Options);
	void __fastcall ExecuteSelected(bool AGivePriority);
	TTBItemViewer* __fastcall Find(TTBCustomItem* Item);
	TTBItemViewer* __fastcall FirstSelectable(void);
	TTBBaseAccObject* __fastcall GetAccObject(void);
	HWND __fastcall GetCaptureWnd(void);
	virtual Vcl::Graphics::TFont* __fastcall GetFont(void);
	void __fastcall GetOffEdgeControlList(System::Classes::TList* const List);
	void __fastcall GivePriority(TTBItemViewer* AViewer);
	void __fastcall HandleHintShowMessage(Vcl::Controls::TCMHintShow &Message);
	TTBItemViewer* __fastcall HighestPriorityViewer(void);
	void __fastcall Invalidate(TTBItemViewer* AViewer);
	virtual void __fastcall InvalidatePositions(void);
	int __fastcall IndexOf(TTBItemViewer* AViewer);
	bool __fastcall IsModalEnding(void);
	TTBItemViewer* __fastcall NextSelectable(TTBItemViewer* CurViewer, bool GoForward);
	TTBItemViewer* __fastcall NextSelectableWithAccel(TTBItemViewer* CurViewer, System::WideChar Key, bool RequirePrimaryAccel, bool &IsOnlyItemWithAccel);
	void __fastcall NotifyFocusEvent(void);
	bool __fastcall OpenChildPopup(const bool SelectFirstItem);
	void __fastcall RecreateAllViewers(void);
	void __fastcall ScrollSelectedIntoView(void);
	void __fastcall Select(TTBItemViewer* Value, bool ViaMouse);
	void __fastcall SetCapture(void);
	void __fastcall TryValidatePositions(void);
	void __fastcall UpdateSelection(const System::Types::TPoint &P, const bool AllowNewSelection);
	System::Types::TPoint __fastcall UpdatePositions(void);
	void __fastcall ValidatePositions(void);
	TTBItemViewer* __fastcall ViewerFromPoint(const System::Types::TPoint &P);
	__property System::Uitypes::TColor BackgroundColor = {read=FBackgroundColor, write=FBackgroundColor, nodefault};
	__property System::Types::TPoint BaseSize = {read=FBaseSize};
	__property bool Capture = {read=FCapture, nodefault};
	__property int ChevronOffset = {read=FChevronOffset, write=FChevronOffset, nodefault};
	__property int ChevronSize = {read=FChevronSize, write=FChevronSize, nodefault};
	__property bool Customizing = {read=FCustomizing, write=SetCustomizing, nodefault};
	__property bool IsPopup = {read=FIsPopup, nodefault};
	__property bool IsToolbar = {read=FIsToolbar, nodefault};
	__property bool MouseOverSelected = {read=FMouseOverSelected, nodefault};
	__property bool NewViewersGetHighestPriority = {read=FNewViewersGetHighestPriority, write=FNewViewersGetHighestPriority, nodefault};
	__property TTBView* ParentView = {read=FParentView};
	__property TTBCustomItem* ParentItem = {read=FParentItem};
	__property TTBItemViewer* OpenViewer = {read=FOpenViewer};
	__property TTBView* OpenViewerView = {read=FOpenViewerView};
	__property TTBViewOrientation Orientation = {read=FOrientation, write=FOrientation, nodefault};
	__property TTBItemViewer* Selected = {read=FSelected, write=SetSelected};
	__property bool SelectedViaMouse = {read=FSelectedViaMouse, nodefault};
	__property TTBViewState State = {read=FState, nodefault};
	__property TTBViewStyle Style = {read=FStyle, write=FStyle, nodefault};
	__property bool UsePriorityList = {read=FUsePriorityList, write=SetUsePriorityList, nodefault};
	__property TTBItemViewer* Viewers[int Index] = {read=GetViewer};
	__property int ViewerCount = {read=GetViewerCount, nodefault};
	__property Vcl::Controls::TWinControl* Window = {read=FWindow};
	__property int WrapOffset = {read=FWrapOffset, write=FWrapOffset, nodefault};
};


typedef System::TMetaClass* TTBRootItemClass;

class PASCALIMPLEMENTATION TTBRootItem : public TTBCustomItem
{
	typedef TTBCustomItem inherited;
	
public:
	/* TTBCustomItem.Create */ inline __fastcall virtual TTBRootItem(System::Classes::TComponent* AOwner) : TTBCustomItem(AOwner) { }
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBRootItem(void) { }
	
};


class PASCALIMPLEMENTATION TTBItem : public TTBCustomItem
{
	typedef TTBCustomItem inherited;
	
__published:
	__property Action;
	__property AutoCheck = {default=0};
	__property Caption = {default=0};
	__property Checked = {default=0};
	__property DisplayMode = {default=0};
	__property Enabled = {default=1};
	__property GroupIndex = {default=0};
	__property HelpContext = {default=0};
	__property Hint = {default=0};
	__property ImageIndex = {default=-1};
	__property Images;
	__property InheritOptions = {default=1};
	__property MaskOptions = {default=0};
	__property Options = {default=0};
	__property PopupMenu;
	__property RadioItem = {default=0};
	__property ShortCut = {default=0};
	__property Visible = {default=1};
	__property OnAdjustImageIndex;
	__property OnClick;
	__property OnSelect;
public:
	/* TTBCustomItem.Create */ inline __fastcall virtual TTBItem(System::Classes::TComponent* AOwner) : TTBCustomItem(AOwner) { }
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBItem(void) { }
	
};


class PASCALIMPLEMENTATION TTBGroupItem : public TTBCustomItem
{
	typedef TTBCustomItem inherited;
	
public:
	__fastcall virtual TTBGroupItem(System::Classes::TComponent* AOwner);
	
__published:
	__property InheritOptions = {default=1};
	__property LinkSubitems;
	__property MaskOptions = {default=0};
	__property Options = {default=0};
	__property SubitemsPopupMenu;
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBGroupItem(void) { }
	
};


class PASCALIMPLEMENTATION TTBSubmenuItem : public TTBCustomItem
{
	typedef TTBCustomItem inherited;
	
private:
	bool __fastcall GetDropdownCombo(void);
	void __fastcall SetDropdownCombo(bool Value);
	
public:
	__fastcall virtual TTBSubmenuItem(System::Classes::TComponent* AOwner);
	
__published:
	__property Action;
	__property AutoCheck = {default=0};
	__property Caption = {default=0};
	__property Checked = {default=0};
	__property DisplayMode = {default=0};
	__property bool DropdownCombo = {read=GetDropdownCombo, write=SetDropdownCombo, default=0};
	__property Enabled = {default=1};
	__property GroupIndex = {default=0};
	__property HelpContext = {default=0};
	__property Hint = {default=0};
	__property ImageIndex = {default=-1};
	__property Images;
	__property InheritOptions = {default=1};
	__property LinkSubitems;
	__property MaskOptions = {default=0};
	__property Options = {default=0};
	__property PopupMenu;
	__property RadioItem = {default=0};
	__property ShortCut = {default=0};
	__property SubitemsPopupMenu;
	__property SubMenuImages;
	__property Visible = {default=1};
	__property OnAdjustImageIndex;
	__property OnClick;
	__property OnPopup;
	__property OnSelect;
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBSubmenuItem(void) { }
	
};


class PASCALIMPLEMENTATION TTBSeparatorItem : public TTBCustomItem
{
	typedef TTBCustomItem inherited;
	
private:
	bool FBlank;
	void __fastcall SetBlank(bool Value);
	
protected:
	virtual TTBItemViewerClass __fastcall GetItemViewerClass(TTBView* AView);
	
public:
	__fastcall virtual TTBSeparatorItem(System::Classes::TComponent* AOwner);
	
__published:
	__property bool Blank = {read=FBlank, write=SetBlank, default=0};
	__property Hint = {default=0};
	__property Visible = {default=1};
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBSeparatorItem(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBSeparatorItemViewer : public TTBItemViewer
{
	typedef TTBItemViewer inherited;
	
protected:
	virtual void __fastcall CalcSize(Vcl::Graphics::TCanvas* const Canvas, int &AWidth, int &AHeight);
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* const Canvas, const System::Types::TRect &ClientAreaRect, bool IsSelected, bool IsPushed, bool UseDisabledShadow);
	virtual bool __fastcall UsesSameWidth(void);
public:
	/* TTBItemViewer.Create */ inline __fastcall virtual TTBSeparatorItemViewer(TTBView* AView, TTBCustomItem* AItem, int AGroupLevel) : TTBItemViewer(AView, AItem, AGroupLevel) { }
	/* TTBItemViewer.Destroy */ inline __fastcall virtual ~TTBSeparatorItemViewer(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TTBControlItem : public TTBCustomItem
{
	typedef TTBCustomItem inherited;
	
private:
	Vcl::Controls::TControl* FControl;
	bool FDontFreeControl;
	void __fastcall SetControl(Vcl::Controls::TControl* Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TTBControlItem(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBControlItem(void);
	__property bool DontFreeControl = {read=FDontFreeControl, write=FDontFreeControl, nodefault};
	
__published:
	__property Vcl::Controls::TControl* Control = {read=FControl, write=SetControl};
};


class PASCALIMPLEMENTATION TTBPopupView : public TTBView
{
	typedef TTBView inherited;
	
protected:
	virtual void __fastcall AutoSize(int AWidth, int AHeight);
	
public:
	virtual Vcl::Graphics::TFont* __fastcall GetFont(void);
public:
	/* TTBView.Create */ inline __fastcall virtual TTBPopupView(System::Classes::TComponent* AOwner, TTBView* AParentView, TTBCustomItem* AParentItem, Vcl::Controls::TWinControl* AWindow, bool AIsToolbar, bool ACustomizing, bool AUsePriorityList) : TTBView(AOwner, AParentView, AParentItem, AWindow, AIsToolbar, ACustomizing, AUsePriorityList) { }
	/* TTBView.Destroy */ inline __fastcall virtual ~TTBPopupView(void) { }
	
};


__interface  INTERFACE_UUID("{E45CBE74-1ECF-44CB-B064-6D45B1924708}") ITBPopupWindow  : public System::IInterface 
{
	
};

class PASCALIMPLEMENTATION TTBPopupWindow : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	bool FAccelsVisibilitySet;
	Tb2anim::TTBAnimationDirection FAnimationDirection;
	TTBView* FView;
	HIDESBASE MESSAGE void __fastcall CMHintShow(Vcl::Controls::TCMHintShow &Message);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMClose(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	MESSAGE void __fastcall WMGetObject(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCCalcSize(Winapi::Messages::TWMNCCalcSize &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	MESSAGE void __fastcall WMPrint(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPrintClient(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMTB2kAnimationEnded(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWindowHandle(void);
	DYNAMIC System::Types::TPoint __fastcall GetNCSize(void);
	DYNAMIC TTBViewClass __fastcall GetViewClass(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall PaintScrollArrows(void);
	__property Tb2anim::TTBAnimationDirection AnimationDirection = {read=FAnimationDirection, nodefault};
	
public:
	__fastcall virtual TTBPopupWindow(System::Classes::TComponent* AOwner, TTBView* const AParentView, TTBCustomItem* const AItem, const bool ACustomizing);
	__fastcall virtual ~TTBPopupWindow(void);
	__property TTBView* View = {read=FView};
public:
	/* TCustomControl.Create */ inline __fastcall virtual TTBPopupWindow(System::Classes::TComponent* AOwner) : Vcl::Controls::TCustomControl(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TTBPopupWindow(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
private:
	void *__ITBPopupWindow;	// ITBPopupWindow 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {E45CBE74-1ECF-44CB-B064-6D45B1924708}
	operator _di_ITBPopupWindow()
	{
		_di_ITBPopupWindow intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator ITBPopupWindow*(void) { return (ITBPopupWindow*)&__ITBPopupWindow; }
	#endif
	
};


__interface  INTERFACE_UUID("{A5C0D7CC-3EC4-4090-A0F8-3D03271877EA}") ITBItems  : public System::IInterface 
{
	virtual TTBCustomItem* __fastcall GetItems(void) = 0 ;
};

class PASCALIMPLEMENTATION TTBItemContainer : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TTBRootItem* FItem;
	Vcl::Imglist::TCustomImageList* __fastcall GetImages(void);
	TTBCustomItem* __fastcall GetItems(void);
	Vcl::Menus::TPopupMenu* __fastcall GetItemsPopupMenu(void);
	void __fastcall SetImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetItemsPopupMenu(Vcl::Menus::TPopupMenu* Value);
	
protected:
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	
public:
	__fastcall virtual TTBItemContainer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBItemContainer(void);
	
__published:
	__property Vcl::Imglist::TCustomImageList* Images = {read=GetImages, write=SetImages};
	__property TTBRootItem* Items = {read=FItem};
	__property Vcl::Menus::TPopupMenu* ItemsPopupMenu = {read=GetItemsPopupMenu, write=SetItemsPopupMenu};
private:
	void *__ITBItems;	// ITBItems 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {A5C0D7CC-3EC4-4090-A0F8-3D03271877EA}
	operator _di_ITBItems()
	{
		_di_ITBItems intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator ITBItems*(void) { return (ITBItems*)&__ITBItems; }
	#endif
	
};


class PASCALIMPLEMENTATION TTBPopupMenu : public Vcl::Menus::TPopupMenu
{
	typedef Vcl::Menus::TPopupMenu inherited;
	
private:
	TTBRootItem* FItem;
	Vcl::Imglist::TCustomImageList* __fastcall GetImages(void);
	TTBCustomItem* __fastcall GetItems(void);
	TTBCustomItem* __fastcall GetLinkSubitems(void);
	TTBItemOptions __fastcall GetOptions(void);
	Vcl::Menus::TPopupMenu* __fastcall GetItemsPopupMenu(void);
	void __fastcall RootItemClick(System::TObject* Sender);
	HIDESBASE void __fastcall SetImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetLinkSubitems(TTBCustomItem* Value);
	void __fastcall SetOptions(TTBItemOptions Value);
	void __fastcall SetItemsPopupMenu(Vcl::Menus::TPopupMenu* Value);
	
protected:
	DYNAMIC TTBRootItemClass __fastcall GetRootItemClass(void);
	DYNAMIC void __fastcall SetChildOrder(System::Classes::TComponent* Child, int Order);
	
public:
	__fastcall virtual TTBPopupMenu(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBPopupMenu(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC bool __fastcall IsShortCut(Winapi::Messages::TWMKey &Message);
	virtual void __fastcall Popup(int X, int Y);
	TTBCustomItem* __fastcall PopupEx(int X, int Y, bool ReturnClickedItemOnly = false);
	
__published:
	__property Vcl::Imglist::TCustomImageList* Images = {read=GetImages, write=SetImages};
	__property TTBRootItem* Items = {read=FItem};
	__property Vcl::Menus::TPopupMenu* ItemsPopupMenu = {read=GetItemsPopupMenu, write=SetItemsPopupMenu};
	__property TTBCustomItem* LinkSubitems = {read=GetLinkSubitems, write=SetLinkSubitems};
	__property TTBItemOptions Options = {read=GetOptions, write=SetOptions, default=0};
private:
	void *__ITBItems;	// ITBItems 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {A5C0D7CC-3EC4-4090-A0F8-3D03271877EA}
	operator _di_ITBItems()
	{
		_di_ITBItems intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator ITBItems*(void) { return (ITBItems*)&__ITBItems; }
	#endif
	
};


class PASCALIMPLEMENTATION TTBCustomImageList : public Vcl::Controls::TImageList
{
	typedef Vcl::Controls::TImageList inherited;
	
private:
	Vcl::Imglist::TCustomImageList* FCheckedImages;
	Vcl::Imglist::TChangeLink* FCheckedImagesChangeLink;
	Vcl::Imglist::TCustomImageList* FDisabledImages;
	Vcl::Imglist::TChangeLink* FDisabledImagesChangeLink;
	Vcl::Imglist::TCustomImageList* FHotImages;
	Vcl::Imglist::TChangeLink* FHotImagesChangeLink;
	Vcl::Graphics::TBitmap* FImagesBitmap;
	System::Uitypes::TColor FImagesBitmapMaskColor;
	void __fastcall ChangeImages(Vcl::Imglist::TCustomImageList* &AImageList, Vcl::Imglist::TCustomImageList* Value, Vcl::Imglist::TChangeLink* AChangeLink);
	void __fastcall ImageListChanged(System::TObject* Sender);
	void __fastcall ImagesBitmapChanged(System::TObject* Sender);
	void __fastcall SetCheckedImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetDisabledImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetHotImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetImagesBitmap(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetImagesBitmapMaskColor(System::Uitypes::TColor Value);
	
protected:
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	__property Vcl::Imglist::TCustomImageList* CheckedImages = {read=FCheckedImages, write=SetCheckedImages};
	__property Vcl::Imglist::TCustomImageList* DisabledImages = {read=FDisabledImages, write=SetDisabledImages};
	__property Vcl::Imglist::TCustomImageList* HotImages = {read=FHotImages, write=SetHotImages};
	__property Vcl::Graphics::TBitmap* ImagesBitmap = {read=FImagesBitmap, write=SetImagesBitmap};
	__property System::Uitypes::TColor ImagesBitmapMaskColor = {read=FImagesBitmapMaskColor, write=SetImagesBitmapMaskColor, default=16711935};
	
public:
	__fastcall virtual TTBCustomImageList(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBCustomImageList(void);
	virtual void __fastcall DrawState(Vcl::Graphics::TCanvas* Canvas, int X, int Y, int Index, bool Enabled, bool Selected, bool Checked);
public:
	/* TCustomImageList.CreateSize */ inline __fastcall TTBCustomImageList(int AWidth, int AHeight) : Vcl::Controls::TImageList(AWidth, AHeight) { }
	
};


class PASCALIMPLEMENTATION TTBImageList : public TTBCustomImageList
{
	typedef TTBCustomImageList inherited;
	
__published:
	__property CheckedImages;
	__property DisabledImages;
	__property HotImages;
	__property ImagesBitmap;
	__property ImagesBitmapMaskColor = {default=16711935};
public:
	/* TTBCustomImageList.Create */ inline __fastcall virtual TTBImageList(System::Classes::TComponent* AOwner) : TTBCustomImageList(AOwner) { }
	/* TTBCustomImageList.Destroy */ inline __fastcall virtual ~TTBImageList(void) { }
	
public:
	/* TCustomImageList.CreateSize */ inline __fastcall TTBImageList(int AWidth, int AHeight) : TTBCustomImageList(AWidth, AHeight) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBModalHandler : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FCreatedWnd;
	bool FInited;
	HWND FWnd;
	TTBPopupWindow* FRootPopup;
	HWND FSaveFocusWnd;
	void __fastcall WndProc(Winapi::Messages::TMessage &Msg);
	
public:
	__fastcall TTBModalHandler(HWND AExistingWnd);
	__fastcall virtual ~TTBModalHandler(void);
	void __fastcall Loop(TTBView* const RootView, const bool AMouseDown, const bool AExecuteSelected, const bool AFromMSAA, const bool TrackRightButton);
	__property TTBPopupWindow* RootPopup = {read=FRootPopup, write=FRootPopup};
	__property HWND Wnd = {read=FWnd, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word WM_TB2K_POPUPSHOWING = System::Word(0x62a);
static const System::Int8 TPS_ANIMSTART = System::Int8(0x1);
static const System::Int8 TPS_ANIMFINISHED = System::Int8(0x2);
static const System::Int8 TPS_NOANIM = System::Int8(0x3);
static const int tbMenuBkColor = int(-16777212);
static const int tbMenuTextColor = int(-16777209);
static const System::Int8 tbMenuVerticalMargin = System::Int8(0x4);
static const System::Int8 tbMenuImageTextSpace = System::Int8(0x1);
static const System::Int8 tbMenuLeftTextMargin = System::Int8(0x2);
static const System::Int8 tbMenuRightTextMargin = System::Int8(0x3);
static const System::Int8 tbMenuSeparatorOffset = System::Int8(0xc);
static const System::Int8 tbMenuScrollArrowHeight = System::Int8(0x13);
static const System::Int8 tbDropdownArrowWidth = System::Int8(0x8);
static const System::Int8 tbDropdownArrowMargin = System::Int8(0x3);
static const System::Int8 tbDropdownComboArrowWidth = System::Int8(0xb);
static const System::Int8 tbDropdownComboMargin = System::Int8(0x2);
static const System::Int8 tbLineSpacing = System::Int8(0x6);
static const System::Int8 tbLineSepOffset = System::Int8(0x1);
static const System::Int8 tbDockedLineSepOffset = System::Int8(0x4);
static const System::Word WM_TB2K_CLICKITEM = System::Word(0x500);
extern DELPHI_PACKAGE Vcl::Graphics::TFont* ToolbarFont;
extern DELPHI_PACKAGE TTBCustomItem* __fastcall TBGetItems(System::TObject* const AObject);
extern DELPHI_PACKAGE TTBCustomItem* __fastcall ProcessDoneAction(const TTBDoneActionData &DoneActionData, const bool ReturnClickedItemOnly);
extern DELPHI_PACKAGE void __fastcall TBInitToolbarSystemFont(void);
}	/* namespace Tb2item */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TB2ITEM)
using namespace Tb2item;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tb2itemHPP
