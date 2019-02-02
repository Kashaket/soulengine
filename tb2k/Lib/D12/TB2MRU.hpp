// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TB2MRU.pas' rev: 31.00 (Windows)

#ifndef Tb2mruHPP
#define Tb2mruHPP

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
#include <TB2Item.hpp>
#include <System.IniFiles.hpp>
#include <System.Win.Registry.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tb2mru
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TTBMRUList;
class DELPHICLASS TTBMRUListItem;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TTBMRUListClickEvent)(System::TObject* Sender, const System::UnicodeString Filename);

class PASCALIMPLEMENTATION TTBMRUList : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	bool FAddFullPath;
	Tb2item::TTBCustomItem* FContainer;
	bool FHidePathExtension;
	System::Classes::TStrings* FList;
	int FMaxItems;
	System::Classes::TNotifyEvent FOnChange;
	TTBMRUListClickEvent FOnClick;
	System::UnicodeString FPrefix;
	void __fastcall ClickHandler(System::TObject* Sender);
	void __fastcall SetHidePathExtension(bool Value);
	void __fastcall SetList(System::Classes::TStrings* Value);
	void __fastcall SetMaxItems(int Value);
	
protected:
	__property Tb2item::TTBCustomItem* Container = {read=FContainer};
	virtual Tb2item::TTBCustomItemClass __fastcall GetItemClass(void);
	virtual void __fastcall SetItemCaptions(void);
	
public:
	__fastcall virtual TTBMRUList(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TTBMRUList(void);
	void __fastcall Add(System::UnicodeString Filename);
	HIDESBASE void __fastcall Remove(const System::UnicodeString Filename);
	void __fastcall LoadFromIni(System::Inifiles::TCustomIniFile* Ini, const System::UnicodeString Section);
	void __fastcall LoadFromRegIni(System::Win::Registry::TRegIniFile* Ini, const System::UnicodeString Section);
	void __fastcall SaveToIni(System::Inifiles::TCustomIniFile* Ini, const System::UnicodeString Section);
	void __fastcall SaveToRegIni(System::Win::Registry::TRegIniFile* Ini, const System::UnicodeString Section);
	
__published:
	__property bool AddFullPath = {read=FAddFullPath, write=FAddFullPath, default=1};
	__property bool HidePathExtension = {read=FHidePathExtension, write=SetHidePathExtension, default=1};
	__property int MaxItems = {read=FMaxItems, write=SetMaxItems, default=4};
	__property System::Classes::TStrings* Items = {read=FList, write=SetList};
	__property TTBMRUListClickEvent OnClick = {read=FOnClick, write=FOnClick};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property System::UnicodeString Prefix = {read=FPrefix, write=FPrefix};
};


class PASCALIMPLEMENTATION TTBMRUListItem : public Tb2item::TTBCustomItem
{
	typedef Tb2item::TTBCustomItem inherited;
	
private:
	TTBMRUList* FMRUList;
	void __fastcall SetMRUList(TTBMRUList* Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TTBMRUListItem(System::Classes::TComponent* AOwner);
	
__published:
	__property TTBMRUList* MRUList = {read=FMRUList, write=SetMRUList};
public:
	/* TTBCustomItem.Destroy */ inline __fastcall virtual ~TTBMRUListItem(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Tb2mru */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TB2MRU)
using namespace Tb2mru;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tb2mruHPP
