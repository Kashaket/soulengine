// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TB2MDI.pas' rev: 31.00 (Windows)

#ifndef Tb2mdiHPP
#define Tb2mdiHPP

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
#include <Vcl.Menus.hpp>
#include <TB2Item.hpp>
#include <TB2Toolbar.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tb2mdi
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TTBMDIHandler;
class DELPHICLASS TTBMDIWindowItem;
class DELPHICLASS TTBMDISystemMenuItem;
class DELPHICLASS TTBMDISystemMenuItemViewer;
class DELPHICLASS TTBMDIButtonItem;
class DELPHICLASS TTBMDIButtonItemViewer;
class DELPHICLASS TTBMDISepItem;
class DELPHICLASS TTBMDISepItemViewer;
class DELPHICLASS TTBMDIButtonsItem;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TTBMDIHandler : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TTBMDIButtonsItem* FButtonsItem;
	TTBMDISystemMenuItem* FSystemMenuItem;
	Tb2toolbar::TTBCustomToolbar* FToolbar;
	void __fastcall SetToolbar(Tb2toolbar::TTBCustomToolbar* Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TTBMDIHandler(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBMDIHandler(void);
	
__published:
	__property Tb2toolbar::TTBCustomToolbar* Toolbar = {read=FToolbar, write=SetToolbar};
};


class PASCALIMPLEMENTATION TTBMDIWindowItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	Vcl::Forms::TForm* FForm;
	System::Classes::TNotifyEvent FOnUpdate;
	Vcl::Menus::TMenuItem* FWindowMenu;
	void __fastcall ItemClick(System::TObject* Sender);
	void __fastcall SetForm(Vcl::Forms::TForm* AForm);
	
protected:
	virtual void __fastcall EnabledChanged(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TTBMDIWindowItem(System::Classes::TComponent* AOwner);
	virtual void __fastcall InitiateAction(void);
	
__published:
	__property Enabled = {default=1};
	__property System::Classes::TNotifyEvent OnUpdate = {read=FOnUpdate, write=FOnUpdate};
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBMDIWindowItem(void) { }
	
};


class PASCALIMPLEMENTATION TTBMDISystemMenuItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	Vcl::Controls::TImageList* FImageList;
	void __fastcall CommandClick(System::TObject* Sender);
	
protected:
	virtual Tb2item::TTBItemViewerClass __fastcall GetItemViewerClass(Tb2item::TTBView* AView);
	
public:
	__fastcall virtual TTBMDISystemMenuItem(System::Classes::TComponent* AOwner);
	virtual void __fastcall Click(void);
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBMDISystemMenuItem(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBMDISystemMenuItemViewer : public Tb2item::TTBItemViewer
{
	typedef Tb2item::TTBItemViewer inherited;
	
protected:
	virtual void __fastcall CalcSize(Vcl::Graphics::TCanvas* const Canvas, int &AWidth, int &AHeight);
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* const Canvas, const System::Types::TRect &ClientAreaRect, bool IsSelected, bool IsPushed, bool UseDisabledShadow);
public:
	/* TTBItemViewer.Create */ inline __fastcall virtual TTBMDISystemMenuItemViewer(Tb2item::TTBView* AView, Tb2item::TTBCustomItem* AItem, int AGroupLevel) : Tb2item::TTBItemViewer(AView, AItem, AGroupLevel) { }
	/* TTBItemViewer.Destroy */ inline __fastcall virtual ~TTBMDISystemMenuItemViewer(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TTBMDIButtonType : unsigned char { tbmbMinimize, tbmbRestore, tbmbClose };

class PASCALIMPLEMENTATION TTBMDIButtonItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	TTBMDIButtonType FButtonType;
	
protected:
	virtual Tb2item::TTBItemViewerClass __fastcall GetItemViewerClass(Tb2item::TTBView* AView);
	
public:
	__fastcall virtual TTBMDIButtonItem(System::Classes::TComponent* AOwner);
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBMDIButtonItem(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBMDIButtonItemViewer : public Tb2item::TTBItemViewer
{
	typedef Tb2item::TTBItemViewer inherited;
	
protected:
	virtual void __fastcall CalcSize(Vcl::Graphics::TCanvas* const Canvas, int &AWidth, int &AHeight);
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* const Canvas, const System::Types::TRect &ClientAreaRect, bool IsSelected, bool IsPushed, bool UseDisabledShadow);
public:
	/* TTBItemViewer.Create */ inline __fastcall virtual TTBMDIButtonItemViewer(Tb2item::TTBView* AView, Tb2item::TTBCustomItem* AItem, int AGroupLevel) : Tb2item::TTBItemViewer(AView, AItem, AGroupLevel) { }
	/* TTBItemViewer.Destroy */ inline __fastcall virtual ~TTBMDIButtonItemViewer(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TTBMDISepItem : public Tb2item::TTBSeparatorItem
{
	typedef Tb2item::TTBSeparatorItem inherited;
	
protected:
	virtual Tb2item::TTBItemViewerClass __fastcall GetItemViewerClass(Tb2item::TTBView* AView);
public:
	/* TTBSeparatorItem.Create */ inline __fastcall virtual TTBMDISepItem(System::Classes::TComponent* AOwner) : Tb2item::TTBSeparatorItem(AOwner) { }
	
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBMDISepItem(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTBMDISepItemViewer : public Tb2item::TTBSeparatorItemViewer
{
	typedef Tb2item::TTBSeparatorItemViewer inherited;
	
protected:
	virtual void __fastcall CalcSize(Vcl::Graphics::TCanvas* const Canvas, int &AWidth, int &AHeight);
public:
	/* TTBItemViewer.Create */ inline __fastcall virtual TTBMDISepItemViewer(Tb2item::TTBView* AView, Tb2item::TTBCustomItem* AItem, int AGroupLevel) : Tb2item::TTBSeparatorItemViewer(AView, AItem, AGroupLevel) { }
	/* TTBItemViewer.Destroy */ inline __fastcall virtual ~TTBMDISepItemViewer(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TTBMDIButtonsItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	TTBMDIButtonItem* FMinimizeItem;
	TTBMDIButtonItem* FRestoreItem;
	TTBMDIButtonItem* FCloseItem;
	TTBMDISepItem* FSep1;
	TTBMDISepItem* FSep2;
	void __fastcall InvalidateSystemMenuItem(void);
	void __fastcall ItemClick(System::TObject* Sender);
	void __fastcall UpdateState(HWND W, bool Maximized);
	
public:
	__fastcall virtual TTBMDIButtonsItem(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBMDIButtonsItem(void);
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Tb2mdi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TB2MDI)
using namespace Tb2mdi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tb2mdiHPP
