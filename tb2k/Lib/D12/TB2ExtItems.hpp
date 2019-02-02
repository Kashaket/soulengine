// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TB2ExtItems.pas' rev: 31.00 (Windows)

#ifndef Tb2extitemsHPP
#define Tb2extitemsHPP

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
#include <TB2Item.hpp>
#include <System.UITypes.hpp>
#include <System.Actions.hpp>
#include <Vcl.ImgList.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tb2extitems
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TTBEditAction;
class DELPHICLASS TTBEditItemActionLink;
class DELPHICLASS TTBEditItem;
class DELPHICLASS TTBEditItemViewer;
class DELPHICLASS TTBVisibilityToggleItem;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TTBEditItemOption : unsigned char { tboUseEditWhenVertical };

typedef System::Set<TTBEditItemOption, TTBEditItemOption::tboUseEditWhenVertical, TTBEditItemOption::tboUseEditWhenVertical> TTBEditItemOptions;

typedef void __fastcall (__closure *TTBAcceptTextEvent)(System::TObject* Sender, System::UnicodeString &NewText, bool &Accept);

typedef void __fastcall (__closure *TTBBeginEditEvent)(TTBEditItem* Sender, TTBEditItemViewer* Viewer, Vcl::Stdctrls::TEdit* EditControl);

class PASCALIMPLEMENTATION TTBEditAction : public Vcl::Actnlist::TAction
{
	typedef Vcl::Actnlist::TAction inherited;
	
private:
	TTBEditItemOptions FEditOptions;
	System::UnicodeString FEditCaption;
	int FEditWidth;
	TTBAcceptTextEvent FOnAcceptText;
	System::UnicodeString FText;
	void __fastcall SetEditCaption(System::UnicodeString Value);
	void __fastcall SetEditOptions(TTBEditItemOptions Value);
	void __fastcall SetEditWidth(int Value);
	void __fastcall SetOnAcceptText(TTBAcceptTextEvent Value);
	void __fastcall SetText(System::UnicodeString Value);
	
public:
	__fastcall virtual TTBEditAction(System::Classes::TComponent* AOwner);
	
__published:
	__property System::UnicodeString EditCaption = {read=FEditCaption, write=SetEditCaption};
	__property TTBEditItemOptions EditOptions = {read=FEditOptions, write=SetEditOptions, default=0};
	__property int EditWidth = {read=FEditWidth, write=SetEditWidth, default=64};
	__property System::UnicodeString Text = {read=FText, write=SetText};
	__property TTBAcceptTextEvent OnAcceptText = {read=FOnAcceptText, write=SetOnAcceptText};
public:
	/* TCustomAction.Destroy */ inline __fastcall virtual ~TTBEditAction(void) { }
	
};


class PASCALIMPLEMENTATION TTBEditItemActionLink : public Tb2item::TTBCustomItemActionLink
{
	typedef Tb2item::TTBCustomItemActionLink inherited;
	
protected:
	virtual void __fastcall AssignClient(System::TObject* AClient);
	virtual bool __fastcall IsEditCaptionLinked(void);
	virtual bool __fastcall IsEditOptionsLinked(void);
	virtual bool __fastcall IsEditWidthLinked(void);
	virtual bool __fastcall IsOnAcceptTextLinked(void);
	virtual bool __fastcall IsTextLinked(void);
	virtual void __fastcall SetEditCaption(const System::UnicodeString Value);
	virtual void __fastcall SetEditOptions(TTBEditItemOptions Value);
	virtual void __fastcall SetEditWidth(const int Value);
	virtual void __fastcall SetOnAcceptText(TTBAcceptTextEvent Value);
	virtual void __fastcall SetText(const System::UnicodeString Value);
public:
	/* TBasicActionLink.Create */ inline __fastcall virtual TTBEditItemActionLink(System::TObject* AClient) : Tb2item::TTBCustomItemActionLink(AClient) { }
	/* TBasicActionLink.Destroy */ inline __fastcall virtual ~TTBEditItemActionLink(void) { }
	
};


class PASCALIMPLEMENTATION TTBEditItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	System::Uitypes::TEditCharCase FCharCase;
	System::UnicodeString FEditCaption;
	TTBEditItemOptions FEditOptions;
	int FEditWidth;
	bool FExtendedAccept;
	int FMaxLength;
	TTBAcceptTextEvent FOnAcceptText;
	TTBBeginEditEvent FOnBeginEdit;
	System::UnicodeString FText;
	bool __fastcall IsEditCaptionStored(void);
	bool __fastcall IsEditOptionsStored(void);
	bool __fastcall IsEditWidthStored(void);
	bool __fastcall IsTextStored(void);
	void __fastcall SetCharCase(System::Uitypes::TEditCharCase Value);
	void __fastcall SetEditCaption(System::UnicodeString Value);
	void __fastcall SetEditOptions(TTBEditItemOptions Value);
	void __fastcall SetEditWidth(int Value);
	void __fastcall SetMaxLength(int Value);
	void __fastcall SetText(System::UnicodeString Value);
	
protected:
	DYNAMIC void __fastcall ActionChange(System::TObject* Sender, bool CheckDefaults);
	virtual bool __fastcall DoAcceptText(System::UnicodeString &NewText);
	virtual void __fastcall DoBeginEdit(TTBEditItemViewer* Viewer);
	virtual void __fastcall DoTextChanging(const System::UnicodeString OldText, System::UnicodeString &NewText, int Reason);
	virtual void __fastcall DoTextChanged(int Reason);
	DYNAMIC Tb2item::TTBCustomItemActionLinkClass __fastcall GetActionLinkClass(void);
	virtual Tb2item::TTBItemViewerClass __fastcall GetItemViewerClass(Tb2item::TTBView* AView);
	virtual bool __fastcall NeedToRecreateViewer(Tb2item::TTBItemViewer* AViewer);
	__property bool ExtendedAccept = {read=FExtendedAccept, write=FExtendedAccept, default=0};
	void __fastcall SetTextEx(System::UnicodeString Value, int Reason);
	
public:
	__fastcall virtual TTBEditItem(System::Classes::TComponent* AOwner);
	HIDESBASE void __fastcall Clear(void);
	virtual void __fastcall Click(void);
	
__published:
	__property Action;
	__property AutoCheck = {default=0};
	__property Caption = {default=0};
	__property System::Uitypes::TEditCharCase CharCase = {read=FCharCase, write=SetCharCase, default=0};
	__property Checked = {default=0};
	__property DisplayMode = {default=0};
	__property System::UnicodeString EditCaption = {read=FEditCaption, write=SetEditCaption, stored=IsEditCaptionStored};
	__property TTBEditItemOptions EditOptions = {read=FEditOptions, write=SetEditOptions, stored=IsEditOptionsStored, nodefault};
	__property int EditWidth = {read=FEditWidth, write=SetEditWidth, stored=IsEditWidthStored, nodefault};
	__property int MaxLength = {read=FMaxLength, write=SetMaxLength, default=0};
	__property Enabled = {default=1};
	__property GroupIndex = {default=0};
	__property HelpContext = {default=0};
	__property Hint = {default=0};
	__property ImageIndex = {default=-1};
	__property InheritOptions = {default=1};
	__property MaskOptions = {default=0};
	__property Options = {default=0};
	__property RadioItem = {default=0};
	__property ShortCut = {default=0};
	__property System::UnicodeString Text = {read=FText, write=SetText, stored=IsTextStored};
	__property Visible = {default=1};
	__property TTBAcceptTextEvent OnAcceptText = {read=FOnAcceptText, write=FOnAcceptText};
	__property TTBBeginEditEvent OnBeginEdit = {read=FOnBeginEdit, write=FOnBeginEdit};
	__property OnClick;
	__property OnSelect;
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBEditItem(void) { }
	
};


typedef System::TMetaClass* TEditClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBEditItemViewer : public Tb2item::TTBItemViewer
{
	typedef Tb2item::TTBItemViewer inherited;
	
	
private:
	enum DECLSPEC_DENUM _TTBEditItemViewer__1 : unsigned char { ecsContinueLoop, ecsAccept, ecsClose };
	
	
private:
	Vcl::Stdctrls::TEdit* FEditControl;
	System::Set<_TTBEditItemViewer__1, _TTBEditItemViewer__1::ecsContinueLoop, _TTBEditItemViewer__1::ecsClose> FEditControlStatus;
	bool __fastcall EditLoop(const HWND CapHandle);
	void __fastcall EditWndProc(Winapi::Messages::TMessage &Message);
	void __fastcall MouseBeginEdit(void);
	
protected:
	virtual void __fastcall CalcSize(Vcl::Graphics::TCanvas* const Canvas, int &AWidth, int &AHeight);
	DYNAMIC bool __fastcall CaptionShown(void);
	virtual bool __fastcall DoExecute(void);
	virtual int __fastcall GetAccRole(void);
	virtual bool __fastcall GetAccValue(System::WideString &Value);
	virtual System::UnicodeString __fastcall GetCaptionText(void);
	virtual void __fastcall GetCursor(const System::Types::TPoint &Pt, HICON &ACursor);
	virtual TEditClass __fastcall GetEditControlClass(void);
	virtual void __fastcall GetEditRect(System::Types::TRect &R);
	virtual void __fastcall MouseDown(System::Classes::TShiftState Shift, int X, int Y, bool &MouseDownOnMenu);
	virtual void __fastcall MouseUp(int X, int Y, bool MouseWasDownOnMenu);
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* const Canvas, const System::Types::TRect &ClientAreaRect, bool IsSelected, bool IsPushed, bool UseDisabledShadow);
	virtual bool __fastcall UsesSameWidth(void);
	
public:
	__property Vcl::Stdctrls::TEdit* EditControl = {read=FEditControl};
public:
	/* TTBItemViewer.Create */ inline __fastcall virtual TTBEditItemViewer(Tb2item::TTBView* AView, Tb2item::TTBCustomItem* AItem, int AGroupLevel) : Tb2item::TTBItemViewer(AView, AItem, AGroupLevel) { }
	/* TTBItemViewer.Destroy */ inline __fastcall virtual ~TTBEditItemViewer(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TTBVisibilityToggleItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	Vcl::Controls::TControl* FControl;
	void __fastcall SetControl(Vcl::Controls::TControl* Value);
	void __fastcall UpdateProps(void);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	virtual void __fastcall Click(void);
	virtual void __fastcall InitiateAction(void);
	
__published:
	__property Caption = {default=0};
	__property Vcl::Controls::TControl* Control = {read=FControl, write=SetControl};
	__property DisplayMode = {default=0};
	__property Enabled = {default=1};
	__property HelpContext = {default=0};
	__property Hint = {default=0};
	__property ImageIndex = {default=-1};
	__property Images;
	__property InheritOptions = {default=1};
	__property MaskOptions = {default=0};
	__property Options = {default=0};
	__property ShortCut = {default=0};
	__property Visible = {default=1};
	__property OnAdjustImageIndex;
	__property OnClick;
	__property OnSelect;
public:
	/* TTBCustomItem.Create */ inline __fastcall virtual TTBVisibilityToggleItem(System::Classes::TComponent* AOwner) : Tb2item::TTBCustomItem(AOwner) { }
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBVisibilityToggleItem(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define EditItemDefaultEditOptions System::Set<System::Byte>()
static const System::Int8 EditItemDefaultEditWidth = System::Int8(0x40);
static const System::Int8 tcrSetProperty = System::Int8(0x0);
static const System::Int8 tcrActionLink = System::Int8(0x1);
static const System::Int8 tcrEditControl = System::Int8(0x2);
}	/* namespace Tb2extitems */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TB2EXTITEMS)
using namespace Tb2extitems;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tb2extitemsHPP
