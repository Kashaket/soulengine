{-----------------------------------------------------------}
{----Purpose : Autocompletion, Windows style.               }
{    By      : Ir. G.W. van der Vegt                        }
{    For     : Myself                                       }
{    Based on: 1) AutoCompetion code found on the Internet  }
{                   (TACEdit)                               }
{              2) http://www.codeproject.com/csharp/        }
{                   csdoesshell4.asp                        }
{              3) http://msdn.microsoft.com/library/        }
{                   default.asp?url=/library/en-us/shellcc/ }
{                    platform/shell/programmersguide/       }
{                    shell_int/shell_int_programming/       }
{                    ac_ovw.asp                             }
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{         -Created.                                         }
{         -Used Assign in Strings setter. (fixes errors)    }
{         -Disable Associate just before changing the source}
{          (fixes errors).                                  }
{         -asList        works (ACStrings)                  }
{         -asHistory     works (IE History)                 }
{         -asMRU         works (Run History)                }
{         -asShell       works (Filenames/Directory names)  }
{         -Added Associate than can be linked to other      }
{          TWinControls.                                    }
{         -Instantiate all enums and add routines to set    }
{          the special options for some of them             }
{          (like path/pidl for FAcShell).                   }
{ 01022007-Added WideStrings (UniCode) support at Runtime.  }
{ 19022007-Added IAutoCompleteDropDown interface definition.}
{ 23022007-Added two option to TNxAcOptions.                }
{         -Tested with Unicode filenames shows unicode.     }
{         -Added two new optioms to IACList2.               }
{         -Added IACList to TNxEnumWideString. Add to       }
{          others to with an event there.                   }
{         -Got the Widestrings (Unicode) working!           }
{ 13032007-Added support for Handles as mechanism for       }
{          associating controls. This gives the opportunity }
{          to attach a NxAutoCompletion to a T(nt)ComboBox. }
{          The Handle property is now used internally too   }
{          to store the Handle of the Associate TWinControl.}
{         -Added initial value for Handle to constructor.   }
{ 14032007-Added IAcList Interface to TNxEnumString too.    }
{         -Added SHAutoCompletion class function.           }
{         -Added SHACF_* Constants.                         }
{         -Added fix for TComboBox and TntComboBox Handles  }
{          in associate.                                    }
{         -Added fix for TComboBoxEx handle in associate.   }
{ 05052007-Simplified SetEnable and SetHandle.              }
{         -Added safeguard to Setup & Teardown so they      }
{          do not work on invalid handles or a disabled     }
{          component.                                       }
{         -Added some debugging output.                     }
{         -Removed memory leaks (I think).                  }
{ 23042008-Switched to TntWideList for Unicode support when }
{          TnT is used.                                     }
{         -Introduced TAcWideStrings for support for Tnt    }
{          and native Delphi 7+. For Delphi 6 Tnt is needed }
{          for Unicode support as the Wsdl unit is not      }
{          present in that version.                         }
{-----------------------------------------------------------}
{ Todo:                                                     }
{         -Add predefined PIDL's to asShell.                }
{         -Add some more options for the various sources.   }
{         -Support pqszQuickComplete for format string in   }
{          IAutoComplete.Init.                              }
{         -See when the dropdown interface does.            }
{         -Add event for Expand.                            }
{                                                           }
{         -Use TAutoCompleteOption(s) from ComCtrls?        }
{         -Change SHAutoComplete to LoadLibrary.            }
{                                                           }
{         -Add support for:                                 }
{          IACLList                                         }
{          IACLList2                                        }
{          IACLCustomBrowserMRU.                            }
{-----------------------------------------------------------}

{$I ..\NxSuite.inc}

{(*}
{$IFDEF TNTUNICODE}
  {$DEFINE UNICODE}                                                             //Automatic Unicode if TNT is used too.
{$ELSE}
  {$IFNDEF DELPHI6}                                                             //Delphi 6 does not have a TWideString class so ignore UNICODE.
    {$DEFINE UNICODE}                                                           //For use without TNT, replace . by $ to enable Unicode support.
  {$ENDIF DELPHI6}
{$ENDIF}

{$DEFINE SHAUTOCOMPLETE}                                                        //Enable simple SHAutoComplete support.
{$DEFINE COMBOBOXEX}                                                            //Enable ComboBoxEx Support.

{$IFDEF UNICODE}
  {$MESSAGE HINT 'TNxAutoCompletion with Unicode support.'}                     //Just a Hint during Compilation.
{$ENDIF UNICODE}

{.DEFINE TRACEAC}                                                               //Debug option.
{*)}

unit NxAutoCompletion;

interface

uses
  Windows, SysUtils, Controls, Classes, ActiveX, ShlObj, ComObj, StdCtrls,
  Forms, Messages {$IFDEF TNTUNICODE},TntClasses{$ELSE TNTUNICODE}
  {$IFDEF UNICODE},WSDLIntf{$ENDIF UNICODE}{$ENDIF};

{$IFDEF TNTUNICODE}
type
  TAcWideStrings = TTntStringList;                                              //TntWideStrings gives to many warnings due to abstract members
{$ELSE TNTUNICODE}
{$IFDEF UNICODE}
type
  {$IFDEF DELPHI2009UP}
  TAcWideStrings = TStringList;
  {$ELSE}
  TAcWideStrings = TWideStrings;
  {$ENDIF}
{$ENDIF UNICODE}
{$ENDIF}

type
  { First Define some interfaces and their options not present in Delphi 7. }
  IACList = interface(IUnknown)
    ['{77A130B0-94FD-11D0-A544-00C04FD7d062}']
    function Expand(pszExpand: POLESTR): HResult; stdcall;
  end;

const
  {Options for IACList2}
  ACLO_NONE                     = $000;                                         //don't enumerate anything
  ACLO_CURRENTDIR               = $001;                                         //enumerate current directory
  ACLO_MYCOMPUTER               = $002;                                         //enumerate MyComputer
  ACLO_DESKTOP                  = $004;                                         //enumerate Desktop Folder
  ACLO_FAVORITES                = $008;                                         //enumerate Favorites Folder
  ACLO_FILESYSONLY              = $010;                                         //enumerate only the file system
  ACLO_NOPREFIXFILTERING        = $020;                                         //Indicates that the file system dirs, UNC shares, and UNC servers should be enumerated
  ACLO_VIRTUALNAMESPACE         = $040;                                         //Indicates that the virual namespace should be enumerated.

type
  IACList2 = interface(IACList)
    ['{470141a0-5186-11d2-bbb6-0060977b464c}']
    function SetOptions(dwFlag: DWord): HResult; stdcall;
    function GetOptions(var pdwFlag: DWord): HResult; stdcall;
  end;

type
  IAutoComplete = interface(IUnknown)
    ['{00bb2762-6a77-11d0-a535-00c04fd7d062}']
    function Init(hwndEdit: HWND; const punkACL: IUnknown; pwszRegKeyPath,
      pwszQuickComplete: POLESTR): HResult; stdcall;
    function Enable(fEnable: BOOL): HResult; stdcall;
  end;

const
  {: Options for IAutoComplete2. }
  ACO_NONE                      = $000;
  ACO_AUTOSUGGEST               = $001;                                         //Public Option
  ACO_AUTOAPPEND                = $002;                                         //Public Option
  ACO_SEARCH                    = $004;
  ACO_FILTERPREFIXES            = $008;
  ACO_USETAB                    = $010;
  ACO_UPDOWNKEYDROPSLIST        = $020;                                         //Public Option
  ACO_RTLREADING                = $040;
  ACO_WORD_FILTER               = $080;
  ACO_NOPREFIXFILTERING         = $100;

type
  IAutoComplete2 = interface(IAutoComplete)
    ['{EAC04BC0-3791-11d2-BB95-0060977B464C}']
    function SetOptions(dwFlag: DWord): HResult; stdcall;
    function GetOptions(out pdwFlag: DWord): HResult; stdcall;
  end;

type
  IObjMgr = interface(IUnknown)
    ['{00BB2761-6A77-11D0-A535-00C04FD7D062}']
    function Append(obj: IEnumString): HResult; stdcall;
    function Remove(obj: IEnumString): HResult; stdcall;
  end;

type
  ICurrentWorkingDirectory = interface(IUnknown)
    ['{91956D21-9276-11D1-921A-006097DF5BD4}']
    function GetDirectory(pwzPath: PWideChar; cchSize: DWord): HResult; stdcall;
    function SetDirectory(pwzPath: PWideChar): HResult; stdcall;
  end;

const
  ACDD_VISIBLE                  = $0001;

type
  IAutoCompleteDropDown = interface(IUnknown)
    ['{3CD141F4-3C6A-11D2-BCAA-00C04FD929DB}']
    function GetDropDownStatus(out dwFlag: DWord; ppwszString: PWideChar): HResult; stdcall;
    {
        [out]A pointer to a value indicating whether the autocomplete drop - down list is currently displayed.This parameter can be NULL on entry if this information is not needed.The following values are recognized as the target of this pointer.
          0 x0000
          The list is not visible.
          ACDD_VISIBLE
          The list is visible.
          ppwszString
          [out]A pointer to a buffer containing the first select item in the drop - down list, if the value pointed to by pdwFlags is ACDD_VISIBLE.This value can be NULL on entry if this information is not needed.
          if pdwFlags is zero on exit, then this value will be NULL.

        if this value is not NULL on exit, the buffer it points to must be freed using CoTaskMemFree when it is no longer needed.
    }
    function ResetEnumerator: HRESULT; stdcall;
  end;

type
  {: Define a kind of TStringList that can be passed into the Windows
     AutoCompletion Api and allows us ot supply our own picklist. }
  TNxEnumString = class(TInterfacedObject, IEnumString, IACList)
  private
    FCurrIndex: Integer;
    FStrings: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    {: Implementing IEnumString }
    function Clone(out enm: IEnumString): HResult; stdcall;
    {: Implementing IEnumString }
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    {: Implementing IEnumString }
    function Reset: HResult; stdcall;
    {: Implementing IEnumString }
    function Skip(celt: Longint): HResult; stdcall;
    {: Implementing IACList }
    function Expand(pszExpand: POLESTR): HResult; stdcall;
  end;

{$IFDEF UNICODE}
type
  {: Define a kind of TStringList that can be passed into the Windows
     AutoCompletion Api and allows us ot supply our own picklist. }
  TNxEnumWideString = class(TInterfacedObject, IEnumString, IACList)
  private
    FCurrIndex: Integer;
    FWideStrings: TAcWideStrings;
  public
    constructor Create;
    destructor Destroy; override;
    {: Implementing IEnumString }
    function Clone(out enm: IEnumString): HResult; stdcall;
    {: Implementing IEnumString }
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    {: Implementing IEnumString }
    function Reset: HResult; stdcall;
    {: Implementing IEnumString }
    function Skip(celt: Longint): HResult; stdcall;
    {: Implementing IACList }
    function Expand(pszExpand: POLESTR): HResult; stdcall;
  end;
{$ENDIF UNICODE}

type
  {: Some options for the Autocompletion Api. }
  TNxAcOption = (aoAutoAppend, aoAutoSuggest, aoUseArrowKey, aoSearch, aoFilterPrefixes, aoUseTab, aoRtlReading, aoWordFilter, aoNoPrefixFiltering);
  TNxAcOptions = set of TNxAcOption;

  {: Some sources for the Autocompletion Api. }
  TNxAcSource = (
    asList,                                                                     //Custom List of Strings
{$IFDEF UNICODE}
    asWideList,
{$ENDIF UNICODE}
    asHistory,                                                                  //Run History
    asMRU,                                                                      //Mru
    asShell);                                                                   //Shell
  TNxAcSources = set of TNxAcSource;

const
  SHACF_FILESYSTEM              = $00000001;                                    //This includes the File System as well as the rest of the shell (Desktop\My Computer\Control Panel\)
  SHACF_URLHISTORY              = $00000002;                                    //URLs in the User's History
  SHACF_URLMRU                  = $00000004;                                    //URLs in the User's Recently Used list.
  SHACF_USETAB                  = $00000008;                                    //Use the tab to move thru the autocomplete possibilities instead of to the next dialog/window control.
  SHACF_FILESYS_ONLY            = $00000010;                                    //This includes the File System
  SHACF_FILESYS_DIRS            = $00000020;                                    //Same as SHACF_FILESYS_ONLY except it only includes directories, UNC servers, and UNC server shares.

  SHACF_URLALL                  = SHACF_URLHISTORY or SHACF_URLMRU;
  SHACF_DEFAULT                 = SHACF_FILESYSTEM or SHACF_URLALL;

  SHACF_AUTOSUGGEST_FORCE_ON    = $10000000;                                    //Ignore the registry default and force the feature on.
  SHACF_AUTOSUGGEST_FORCE_OFF   = $20000000;                                    //Ignore the registry default and force the feature on.
  SHACF_AUTOAPPEND_FORCE_ON     = $40000000;                                    //Ignore the registry default and force the feature on.
  SHACF_AUTOAPPEND_FORCE_OFF    = $80000000;                                    //Ignore the registry default and force the feature on.

type
  {: This component implements the AutoCompletion but can be linked to a
     TWinControl descendant so it will provide autocompletion for this linked
     component.
     This is a totally different approax to various components that have
     autocompletion built into them.}
  TNxAutoCompletion = class(TComponent)
  private
    FAssociate: TWinControl;
    FAutoComplete: IAutoComplete;
    FEnabled: Boolean;
    FStrings: TStringList;
{$IFDEF UNICODE}
    FWideStrings: TAcWideStrings;
{$ENDIF UNICODE}
    {: Storage for all four supported IAutoCompletion Sources. }
    FAcSources: TNxAcSources;
    FAcList: TNxEnumString;
{$IFDEF UNICODE}
    FAcWideList: TNxEnumWideString;
{$ENDIF UNICODE}
    FAcHistory: IEnumString;
    FAcMru: IEnumString;
    FAcShell: IEnumString;
    {: IAutoCompletion Option Storage }
    FAcOptions: TNxAcOptions;
    {: The IEnumString used to insert the stringlist into the IAutoCompletion
       Api. }
    FEnum: IEnumString;
    FHandle: THandle;
    function GetStrings: TStringList;
{$IFDEF UNICODE}
    function GetWideStrings: TAcWideStrings;
{$ENDIF UNICODE}
    procedure SetEnabled(const Value: Boolean);
    procedure SetOptions(const Value: TNxAcOptions);
    procedure SetSources(const Value: TNxAcSources);
    procedure SetStrings(const Value: TStringList);
{$IFDEF UNICODE}
    procedure SetWideStrings(const Value: TAcWideStrings);
{$ENDIF UNICODE}
    procedure SetAssociate(const Value: TWinControl);
    {: Setup Autocompletion. }
    procedure Setup;
    {: Cleanup Autocompletion. }
    procedure TearDown;
    procedure SetHandle(const Value: THandle);
  protected
    {: Used for delayed Enabling of the Component. }
    procedure Loaded; override;
  public
    {: The constructor. }
    constructor Create(AOwner: TComponent); override;
    {: The destructor. }
    destructor Destroy; override;

    class function AutoComplete(const handle: HWND; const flags: DWord): HRESULT;

{$IFDEF UNICODE}
    {: WideStrings used for the asWideList type of Source. The strings added here are
       published into the IAutoCompletion Api through an IEnumWideString object. }
    property WideStrings: TAcWideStrings read GetWideStrings write SetWideStrings;
{$ENDIF UNICODE}
    {: Used to associate to some controls that don't expose the correct Handle
       property like the T(nt)ComboBox. Example code:

       var
         ChildHandle                   : THandle;
       begin
         ChildHandle := GetWindow(ComboBox1.Handle, GW_CHILD);
         if ComboBox1.Style = csSimple then
           ChildHandle := GetWindow(ChildHandle, GW_HWNDNEXT);
         NxAutoCompletion1.Handle := ChildHandle;
         NxAutoCompletion1.Enabled := True;
       end;

       Note the Handle property itself is now used internally also to store the
       handle of the Associated TWincontrol.
    }
    property Handle: THandle read FHandle write SetHandle stored False;
  published
    {: Assiocate is where the control is defined for which IAutoCompletion
       is performed. }
    property Associate: TWinControl read FAssociate write SetAssociate;
    {: Enable or Disable IAutocompletion.
       When modifying other properties it's best to disable it temporarily. }
    property Enabled: Boolean read FEnabled write SetEnabled default False;     // stored False;
    {: General Options for all IAutoCompletion Sources. }
    property Options: TNxAcOptions read FAcOptions write SetOptions default [aoAutoAppend, aoAutoSuggest, aoUseArrowKey];
    {: A set of IAutoCompletion Sources. }
    property Sources: TNxAcSources read FAcSources write SetSources;
    {: Strings used for the asList type of Source. The strings added here are
       published into the IAutoCompletion Api through an IEnumString object. }
    property Strings: TStringList read GetStrings write SetStrings;
  end;

implementation

{$IFDEF COMBOBOXEX}
uses
  ComCtrls;
{$ENDIF COMBOBOXEX}

{ Define some Guids. }

const
  {: IAutoComplete Guid's. }
  IID_IAutoComplete             : TGUID = '{00bb2762-6a77-11d0-a535-00c04fd7d062}';
  IID_IAutoComplete2            : TGUID = '{EAC04BC0-3791-11d2-BB95-0060977B464C}';
  CLSID_IAutoComplete           : TGUID = '{00BB2763-6A77-11D0-A535-00C04FD7D062}';

  {: (EnumString) Lists as source. }
  IID_IACList                   : TGUID = '{77A130B0-94FD-11D0-A544-00C04FD7d062}';
  IID_IACList2                  : TGUID = '{470141a0-5186-11d2-bbb6-0060977b464c}';

  {: An autocomplete source that matches against the URL list in the user's
     History list.}
  CLSID_ACLHistory              : TGUID = '{00BB2764-6A77-11D0-A535-00C04FD7D062}';

  {: An autocomplete source that matches against items in the Shell namespace,
     including files on the user's computer as well as items in virtual folders
     such as My Computer and Control Panel. }
  CLSID_ACListISF               : TGUID = '{03C036F1-A186-11D0-824A-00AA005B4383}';

  {: An autocomplete source that matches against the URL list in the user's
     Recently Used list. }
  CLSID_ACLMRU                  : TGUID = '{6756a641-de71-11d0-831b-00aa005b4383}';

  {: Mutiple Sources, note in some saplle code sources it starts with 00BB2761-  }
  CLSID_ACLMULTI                : TGUID = '{00BB2765-6A77-11D0-A535-00C04FD7D062}';

  { : ? }
  CLSID_CURRENTWORKINGDIRECTORY : TGUID = '{91956D21-9276-11D1-921A-006097DF5BD4}';

{$IFDEF SHAUTOCOMPLETE}

function SHAutoComplete(handle: HWND; flags: DWord): HResult; stdcall; external 'SHLWAPI.DLL' name 'SHAutoComplete';

{$ENDIF SHAUTOCOMPLETE}

const
  CBEM_GETEDITCONTROL           = 1031;

  { TNxEnumString }

constructor TNxEnumString.Create;
begin
  inherited Create;

{$IFDEF TRACEAC}
  OutputDebugString('TNxEnumString.Create');
{$ENDIF TRACEAC}

  FStrings := TStringList.Create;
  FCurrIndex := 0;
end;

destructor TNxEnumString.Destroy;
begin
  if Assigned(FStrings) then                                                    //veg:05-05-2007
    FreeAndNil(FStrings);

{$IFDEF TRACEAC}
  OutputDebugString('TNxEnumString.Destroy');
{$ENDIF TRACEAC}

  inherited;
end;

function TNxEnumString.Clone(out enm: IEnumString): HResult;
begin
  Result := E_NOTIMPL;

  pointer(enm) := nil;
end;

function TNxEnumString.Next(celt: Integer; out elt; pceltFetched: PLongint): HResult;
var
  I                             : Integer;
  wStr                          : WideString;
begin
  //Return the next celt strings.
  I := 0;
  while (I < celt) and (FCurrIndex < FStrings.Count) do
    begin
      wStr := FStrings[FCurrIndex];
      TPointerList(elt)[I] := CoTaskMemAlloc(2 * (Length(wStr) + 1));
      StringToWideChar(wStr, TPointerList(elt)[I], 2 * (Length(wStr) + 1));
      Inc(I);
      Inc(FCurrIndex);
    end;

  if pceltFetched <> nil then
    pceltFetched^ := I;

  if I = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;

function TNxEnumString.Reset: HResult;
begin
  FCurrIndex := 0;

  Result := S_OK;
end;

function TNxEnumString.Skip(celt: Integer): HResult;
begin
  //Skip the next celt strings.
  if (FCurrIndex + celt) <= FStrings.Count then
    begin
      Inc(FCurrIndex, celt);
      Result := S_OK;
    end
  else
    begin
      FCurrIndex := FStrings.Count;
      Result := S_FALSE;
    end;
end;

function TNxEnumString.Expand(pszExpand: POLESTR): HResult;
begin
{$IFDEF TRACEAC}
  OutputDebugString(PChar(string(pszExpand)));
{$ENDIF TRACEAC}

  Result := S_OK;
end;

{ TNxEnumWideString }

{$IFDEF UNICODE}

constructor TNxEnumWideString.Create;
begin
  inherited Create;

{$IFDEF TRACEAC}
  OutputDebugString('TNxEnumWideString.Create');
{$ENDIF TRACEAC}

  FWideStrings := TAcWideStrings.Create;
  FCurrIndex := 0;
end;

destructor TNxEnumWideString.Destroy;
begin
  if Assigned(FWideStrings) then                                                //veg:05-05-2007
    FreeAndNil(FWideStrings);

{$IFDEF TRACEAC}
  OutputDebugString('TNxEnumWideString.Destroy');
{$ENDIF TRACEAC}

  inherited;
end;

function TNxEnumWideString.Clone(out enm: IEnumString): HResult;
begin
  Result := E_NOTIMPL;

  pointer(enm) := nil;
end;

function TNxEnumWideString.Next(celt: Integer; out elt; pceltFetched: PLongint): HResult;
var
  I                             : Integer;
  wStr                          : WideString;

  procedure _ExactStrCopyW(pDest, pSource: PWideChar; Count: Integer);
  var
    i                           : Integer;
  begin
    for i := 1 to Count do
      begin
        pDest^ := pSource^;
        Inc(PSource);
        Inc(pDest);
      end;
  end;

begin
  //Return the next celt strings.
  I := 0;
  while (I < celt) and (FCurrIndex < FWideStrings.Count) do
    begin
      wStr := FWideStrings[FCurrIndex];

      TPointerList(elt)[I] := CoTaskMemAlloc(2 * (Length(wStr) + 1));
      _ExactStrCopyW(TPointerList(elt)[I], PWideChar(wStr), Length(wStr) + 1);

      Inc(I);
      Inc(FCurrIndex);
    end;

  if pceltFetched <> nil then
    pceltFetched^ := I;

  if I = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;

function TNxEnumWideString.Reset: HResult;
begin
  FCurrIndex := 0;

  Result := S_OK;
end;

function TNxEnumWideString.Skip(celt: Integer): HResult;
begin
  //Skip the next celt strings.
  if (FCurrIndex + celt) <= FWideStrings.Count then
    begin
      Inc(FCurrIndex, celt);
      Result := S_OK;
    end
  else
    begin
      FCurrIndex := FWideStrings.Count;
      Result := S_FALSE;
    end;
end;

function TNxEnumWideString.Expand(pszExpand: POLESTR): HResult;
begin
{$IFDEF TRACEAC}
  OutputDebugString(PChar(string(pszExpand)));
{$ENDIF TRACEAC}

  Result := S_OK;
end;

{$ENDIF UNICODE}

{ TNxAutoCompletion }

constructor TNxAutoCompletion.Create(AOwner: TComponent);
begin
  inherited;

  FStrings := TStringList.Create;

{$IFDEF UNICODE}
  FWideStrings := TAcWideStrings.Create;
{$ENDIF UNICODE}

  //Always start disabled, see OnLoaded method.
  FEnabled := False;

  //Default IAutoCompletion options.
  FAcOptions := [aoAutoAppend, aoAutoSuggest, aoUseArrowKey];

  FHandle := INVALID_HANDLE_VALUE;

  FAssociate := nil;
end;

destructor TNxAutoCompletion.Destroy;
begin
  //Destroy IAutoComplete.
  Enabled := False;

  TearDown;

  if Assigned(FStrings) then
    FreeAndNil(FStrings);
{$IFDEF UNICODE}
  if Assigned(FWideStrings) then
    FreeAndNil(FWideStrings);
{$ENDIF UNICODE}

  inherited;
end;

function TNxAutoCompletion.GetStrings: TStringList;
begin
  Result := FStrings;
end;

{$IFDEF UNICODE}

function TNxAutoCompletion.GetWideStrings: TAcWideStrings;
begin
  Result := FWideStrings;
end;

{$ENDIF UNICODE}

procedure TNxAutoCompletion.Loaded;
begin
  inherited;

  //Make sure we're working when the component is fully loaded.
  SetEnabled(FEnabled);
end;

procedure TNxAutoCompletion.SetAssociate(const Value: TWinControl);
var
  ChildHandle                   : THandle;
  dwStyle                       : DWord;
begin
  //Set Affected Control.
  FAssociate := Value;

  if Assigned(FAssociate) then
    begin
      if (FAssociate is TCustomComboBox) then
        begin
          ChildHandle := GetWindow(FAssociate.Handle, GW_CHILD);
          dwStyle := GetWindowLong(FAssociate.Handle, GWL_STYLE);
          if ((dwStyle and CBS_SIMPLE) = CBS_SIMPLE) and
            ((dwStyle and CBS_DROPDOWN) <> CBS_DROPDOWN) then
            ChildHandle := GetWindow(ChildHandle, GW_HWNDNEXT);
          Handle := ChildHandle;
        end
{$IFDEF COMBOBOXEX}
      else if (FAssociate is TCustomComboBoxEx) then
        Handle := SendMessage(FAssociate.Handle, CBEM_GETEDITCONTROL, 0, 0)
{$ENDIF COMBOBOXEX}
      else
        Handle := FAssociate.Handle                                             //Setup
    end
  else
    Handle := INVALID_HANDLE_VALUE                                              //TearDown;
end;

procedure TNxAutoCompletion.SetEnabled(const Value: Boolean);
begin
  if (Value <> FEnabled) then
    begin
      TearDown;

      FEnabled := Value;                                                        //Set Enabled value.

      Setup
    end;
end;

procedure TNxAutoCompletion.SetOptions(const Value: TNxAcOptions);
begin
  FAcOptions := Value;
end;

procedure TNxAutoCompletion.SetSources(const Value: TNxAcSources);
begin
  if (FAcSources <> Value) then
    begin
      TearDown;

      FAcSources := Value;

      Setup
    end;
end;

procedure TNxAutoCompletion.SetStrings(const Value: TStringList);
begin
  FStrings.Text := Value.Text;

  if Assigned(FAcList) then
    FAcList.FStrings.Text := Value.Text;
end;

{$IFDEF UNICODE}

procedure TNxAutoCompletion.SetWideStrings(const Value: TAcWideStrings);
var
  i                             : Integer;
begin
  FWideStrings.Clear;
  for i := 0 to Pred(Value.Count) do
    FWideStrings.Add(Value[i]);

  if Assigned(FAcWideList) then
    for i := 0 to Pred(Value.Count) do
      FAcWideList.FWideStrings.Add(Value[i]);
end;
{$ENDIF UNICODE}

procedure TNxAutoCompletion.Setup;
const
  Options                       : array[TNxAcOption] of Integer =
    (
    ACO_AUTOAPPEND,
    ACO_AUTOSUGGEST,
    ACO_UPDOWNKEYDROPSLIST,
    ACO_SEARCH,
    ACO_FILTERPREFIXES,
    ACO_USETAB,
    ACO_RTLREADING,
    ACO_WORD_FILTER,
    ACO_NOPREFIXFILTERING
    );
var
  Dummy                         : IUnknown;
  Option                        : TNxAcOption;
  Opt                           : DWord;
  AC2                           : IAutoComplete2;
{$IFDEF UNICODE}
  i                             : Integer;
{$ENDIF UNICODE}
  { Future work...
    Malloc            : IMalloc;
    pid               : PItemIDList;
    ppf               : IPersistFolder;
    pacl              : IACList2;
    cwd               : ICurrentWorkingDirectory;
  }
begin
  if (FHandle <> INVALID_HANDLE_VALUE) and (FEnabled) then
    begin
{$IFDEF TRACEAC}
      OutputDebugString('TNxAutoCompletion.Setup');
{$ENDIF TRACEAC}

      //Create EnumString Object Container.
      FEnum := CreateComObject(CLSID_ACLMulti) as IEnumString;

      //Create EnumString Lists.
      FAcShell := CreateComObject(CLSID_ACListISF) as IEnumString;
      FAcHistory := CreateComObject(CLSID_ACLHistory) as IEnumString;
      FAcMru := CreateComObject(CLSID_ACLMRU) as IEnumString;

      if not assigned(FAclist) then                                             //veg:05-05-2007, this balances create/destroy
        FreeAndNil(FAcList);
      FAcList := TNxEnumString.Create;
{$IFDEF UNICODE}
      if not Assigned(FAcWideList) then                                         //veg:05-05-2007, this balances create/destroy
        FreeAndNil(FAcWideList);
      FAcWideList := TNxEnumWideString.Create;
{$ENDIF UNICODE}

      //Copy Enum Strings into IEnumString Object
      if Assigned(FStrings) then
        FAcList.FStrings.Text := FStrings.Text;

      //Copy Enum Strings into IEnumString Object
{$IFDEF UNICODE}
      if Assigned(FWideStrings) then
        for i := 0 to Pred(FWideStrings.Count) do
          FAcWideList.FWideStrings.Add(FWideStrings[i]);
{$ENDIF UNICODE}

      if FEnabled and {Assigned(FAssociate)}(Handle <> INVALID_HANDLE_VALUE) {and (FAssociate.HandleAllocated)} then
        try
          //Create IAutoComplete.
          Dummy := CreateComObject(CLSID_IAutoComplete);
          if (Dummy <> nil) and (Dummy.QueryInterface(IID_IAutoComplete, FAutoComplete) =
            S_OK) then
            begin
              //Insert the AutoCompletion Sources

              { Future work: Set Specific Options for various Sources. }

              if (asHistory in Sources) then
                (FEnum as IObjMgr).Append(FAcHistory);

              if (asMru in Sources) then
                (FEnum as IObjMgr).Append(FAcMru);

              { Future work: Use two shells, one for a path and one for PIDL's. }
              (*
                if (asShell in Sources) then                                          //Paths, Works
                begin
                  SHGetMalloc(Malloc);
                  SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, pid);
                  // Create the ACList object and specify the PIDL
                  FAcEnum.QueryInterface(IID_IPersistFolder, ppf);
                  ppf.Initialize(pid);
                  // Clean up
                  Malloc.Free(pid);

                  punkSource.QueryInterface(IID_IACList2, pacl);
                  pacl.SetOptions(ACLO_CURRENTDIR);
                end;
                if (asShell in Sources) then                                          //Paths, Works too
                   (FAcEnum as ICurrentWorkingDirectory).SetDirectory('c:\temp');
              *)
              if (asShell in Sources) then
                (FEnum as IObjMgr).Append(FAcShell);

              if (asList in Sources) then
                (FEnum as IObjMgr).Append(FAcList);
{$IFDEF UNICODE}
              if (asWideList in Sources) then
                (FEnum as IObjMgr).Append(FAcWideList);
{$ENDIF UNICODE}

              //Init IAutoComplete and Set Options.
              if (S_OK = FAutoComplete.Init({FAssociate.}Handle, FEnum, nil, nil)) and
                (S_OK = FAutoComplete.QueryInterface(IID_IAutoComplete2, AC2)) then
                begin
                  Opt := ACO_NONE;
                  for Option := Low(Options) to High(Options) do
                    begin
                      if (Option in FAcOptions) then
                        Opt := Opt or DWord(Options[Option]);
                    end;
                  AC2.SetOptions(Opt);
                end;
            end;
        except
          {CLSID_IAutoComplete or CLSID_IAutoComplete2 is not available.}
        end
    end;
end;

procedure TNxAutoCompletion.TearDown;
var
  AC2                           : IAutoComplete2;
begin
  if (FHandle <> INVALID_HANDLE_VALUE) then
    begin
{$IFDEF TRACEAC}
      OutputDebugString('TNxAutoCompletion.TearDown');
{$ENDIF TRACEAC}

      //Destroy IAutoComplete if present.
      if (FAutoComplete <> nil) and (S_OK = FAutoComplete.QueryInterface(IID_IAutoComplete2, AC2)) then
        AC2.SetOptions(ACO_NONE);

      //Remove the AutoCompletion Sources.
      if Assigned(FEnum) then
        begin
          //Remove Lists from Container.
          if (asList in Sources) then
            begin
              (FEnum as IObjMgr).Remove(FAcList);
              FAcList := nil;
            end;
{$IFDEF UNICODE}
          if (asWideList in Sources) then
            begin
              (FEnum as IObjMgr).Remove(FAcWideList);
              FAcWideList := nil;
            end;
{$ENDIF UNICODE}
          if (asHistory in Sources) then
            (FEnum as IObjMgr).Remove(FAcHistory);
          if (asMru in Sources) then
            (FEnum as IObjMgr).Remove(FAcMru);
          if (asShell in Sources) then
            (FEnum as IObjMgr).Remove(FAcShell);
        end;

      //Kill Autocompletion Object
      if Assigned(FAutoComplete) then
        begin
          FAutoComplete.Enable(False);
          FAutoComplete := nil;
        end;

      //Destroy AcEnum
      FEnum := nil;

      //Destroy Lists of ACEnum.
      if Assigned(FAcList) then
        FreeAndNil(FAcList);
{$IFDEF UNICODE}
      if Assigned(FAcWideList) then
        FreeAndNil(FAcWideList);
{$ENDIF UNICODE}
      FAcHistory := nil;
      FAcShell := nil;
      FAcMru := nil;
    end;
end;

procedure TNxAutoCompletion.SetHandle(const Value: THandle);
begin
  if (FHandle <> Value) then
    begin
      TearDown;

      if (Value = 0) then
        FHandle := INVALID_HANDLE_VALUE
      else
        FHandle := Value;

      Setup;
    end;
end;

class function TNxAutoCompletion.AutoComplete(const handle: HWND; const flags:
  DWord): HRESULT;
begin
{$IFDEF SHAUTOCOMPLETE}
  Result := SHAutoComplete(handle, FLags);
{$ELSE SHAUTOCOMPLETE}
  Result := E_NOTIMPL;
{$ENDIF SHAUTOCOMPLETE}
end;

initialization
  //PlaceHolder.

finalization
  //PlaceHolder.

end.

