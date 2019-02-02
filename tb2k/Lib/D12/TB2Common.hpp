// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TB2Common.pas' rev: 31.00 (Windows)

#ifndef Tb2commonHPP
#define Tb2commonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tb2common
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef void __fastcall (*THandleWMPrintNCPaintProc)(HWND Wnd, HDC DC, System::TObject* AppData);

typedef void __fastcall (__closure *TPaintHandlerProc)(Winapi::Messages::TWMPaint &Message);

typedef void * TListItemType;

typedef int ClipToLongint;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 PopupMenuWindowNCSize = System::Int8(0x3);
static const int DT_HIDEPREFIX = int(0x100000);
extern DELPHI_PACKAGE bool __fastcall ApplicationIsActive(void);
extern DELPHI_PACKAGE void __fastcall HandleWMPrint(const HWND Wnd, Winapi::Messages::TMessage &Message, const THandleWMPrintNCPaintProc NCPaintFunc, System::TObject* const AppData);
extern DELPHI_PACKAGE void __fastcall HandleWMPrintClient(const TPaintHandlerProc PaintHandlerProc, const Winapi::Messages::TMessage &Message);
extern DELPHI_PACKAGE int __fastcall GetTextHeight(const HDC DC);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StripAccelChars(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EscapeAmpersands(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StripTrailingPunctuation(const System::UnicodeString S);
extern DELPHI_PACKAGE int __fastcall GetTextWidth(const HDC DC, System::UnicodeString S, const bool Prefix);
extern DELPHI_PACKAGE void __fastcall ProcessPaintMessages(void);
extern DELPHI_PACKAGE void __fastcall RemoveMessages(const int AMin, const int AMax);
extern DELPHI_PACKAGE void __fastcall SelectNCUpdateRgn(HWND Wnd, HDC DC, HRGN Rgn);
extern DELPHI_PACKAGE bool __fastcall AddToList(System::Classes::TList* &List, System::TObject* Item);
extern DELPHI_PACKAGE bool __fastcall AddToFrontOfList(System::Classes::TList* &List, System::TObject* Item);
extern DELPHI_PACKAGE void __fastcall RemoveFromList(System::Classes::TList* &List, System::TObject* Item);
extern DELPHI_PACKAGE int __fastcall GetMenuShowDelay(void);
extern DELPHI_PACKAGE bool __fastcall AreFlatMenusEnabled(void);
extern DELPHI_PACKAGE bool __fastcall AreKeyboardCuesEnabled(void);
extern DELPHI_PACKAGE HBITMAP __fastcall CreateMonoBitmap(const int AWidth, const int AHeight, const System::Byte *ABits, const int ABits_High);
extern DELPHI_PACKAGE HBRUSH __fastcall CreateHalftoneBrush(void);
extern DELPHI_PACKAGE void __fastcall DrawHalftoneInvertRect(const HDC DC, const System::Types::TRect &NewRect, const System::Types::TRect &OldRect, const System::Types::TSize &NewSize, const System::Types::TSize &OldSize);
extern DELPHI_PACKAGE bool __fastcall IsFillRectWithGradientAvailable(void);
extern DELPHI_PACKAGE void __fastcall FillRectWithGradient(const HDC DC, const System::Types::TRect &R, const unsigned StartColor, const unsigned EndColor, const bool HorizontalDirection);
extern DELPHI_PACKAGE void __fastcall DrawSmallWindowCaption(const HWND Wnd, const HDC DC, const System::Types::TRect &ARect, const System::UnicodeString AText, const bool AActive);
extern DELPHI_PACKAGE void __fastcall DoubleBufferedRepaint(const HWND Wnd);
extern DELPHI_PACKAGE bool __fastcall MethodsEqual(const System::TMethod &M1, const System::TMethod &M2);
extern DELPHI_PACKAGE System::Types::TRect __fastcall GetRectOfPrimaryMonitor(const bool WorkArea);
extern DELPHI_PACKAGE bool __fastcall UsingMultipleMonitors(void);
extern DELPHI_PACKAGE System::Types::TRect __fastcall GetRectOfMonitorContainingRect(const System::Types::TRect &R, const bool WorkArea);
extern DELPHI_PACKAGE System::Types::TRect __fastcall GetRectOfMonitorContainingPoint(const System::Types::TPoint &P, const bool WorkArea);
extern DELPHI_PACKAGE System::Types::TRect __fastcall GetRectOfMonitorContainingWindow(const HWND W, const bool WorkArea);
extern DELPHI_PACKAGE void __fastcall InitTrackMouseEvent(void);
extern DELPHI_PACKAGE bool __fastcall CallTrackMouseEvent(const HWND Wnd, const unsigned Flags);
extern DELPHI_PACKAGE void __fastcall CallLockSetForegroundWindow(const bool ALock);
extern DELPHI_PACKAGE int __fastcall DrawTextStr(const HDC DC, const System::UnicodeString AText, System::Types::TRect &ARect, const unsigned AFormat);
extern DELPHI_PACKAGE System::LongBool __fastcall GetTextExtentPoint32Str(const HDC DC, const System::UnicodeString AText, /* out */ System::Types::TSize &ASize);
extern DELPHI_PACKAGE System::LongBool __fastcall TextOutStr(const HDC DC, const int X, const int Y, const System::UnicodeString AText);
extern DELPHI_PACKAGE HFONT __fastcall CreateRotatedFont(HDC DC);
extern DELPHI_PACKAGE void __fastcall DrawRotatedText(const HDC DC, System::UnicodeString AText, const System::Types::TRect &ARect, const unsigned AFormat);
extern DELPHI_PACKAGE bool __fastcall NeedToPlaySound(const System::UnicodeString Alias);
extern DELPHI_PACKAGE void __fastcall PlaySystemSound(const System::UnicodeString Alias);
extern DELPHI_PACKAGE int __fastcall Max(int A, int B);
extern DELPHI_PACKAGE int __fastcall Min(int A, int B);
extern DELPHI_PACKAGE System::WideChar __fastcall FindAccelChar(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall IsWindowsXP(void);
extern DELPHI_PACKAGE unsigned __fastcall GetInputLocaleCodePage(void);
extern DELPHI_PACKAGE System::Types::TPoint __fastcall GetMessagePosAsPoint(void);
extern DELPHI_PACKAGE bool __fastcall GetSystemNonClientMetrics(tagNONCLIENTMETRICSW &Metrics);
extern DELPHI_PACKAGE System::LongBool __fastcall GetSystemParametersInfoBool(const unsigned Param, const System::LongBool Default);
extern DELPHI_PACKAGE System::WideChar __fastcall CharToLower(const System::WideChar C);
}	/* namespace Tb2common */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TB2COMMON)
using namespace Tb2common;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tb2commonHPP
