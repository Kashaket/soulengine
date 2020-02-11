unit regGui;

{$I 'sDef.inc'}

interface

uses Forms, Dialogs, SysUtils, Windows, Classes, Controls, Buttons,
  Messages,              ZendTypes,
  propertiesEngine, dsExtraCtrls,
  StdCtrls, ComCtrls, Menus, ExtCtrls, Mask, Grids,
  Tabs, Graphics,  mainLCL, uGuiScreen, cooltrayicon,
  MImage, GIFImage2, svgimage, svgimagelist, vcl.imaging.jpeg,
 { uFreeImageImage, uAnimatedJPEG, uTiffImage, uRawImage, }
  dsStdCtrl, dsCustomControls {, rkSmartTabs}
  {$IFDEF ADD_AC}, sDialogs  {$ENDIF}

{$IFDEF ADD_CHROMIUM}
    , uCefChromium,  uCefChromiumOptions,
   uCEFv8Handler, uCEFv8Value, uCEFTypes, uCEFWindowParent,
  uCEFv8Accessor, uCEFInterfaces, uCEFCookieManager,
  uCEFWinControl,
  uCefApplication
{$ENDIF}
{$IFDEF ADD_SKINS}
  , acPNG,
  sSkinProvider, sSkinManager,
    sSpeedButton, sBitBtn, acProgressBar, sTrackBar, sBevel, sLabel
    {$ELSE}
    ,vcl.imaging.pngimage
    {$ENDIF}
{$IFDEF VS_EDITOR}
    , NxPropertyItems, NxPropertyItemClasses, NxScrollControl,
  NxInspector, DockTabSet,
  CaptionedDockTree2,
  NxEdit,
  {$IFDEF ADD_SYN}
  SynEditHighlighter,

  SynHighlighterPHP,

  {$IFDEF ADD_SYN_OPT} SynHighlighterSQL, SynHighlighterHtml,
  SynHighlighterPas, SynHighlighterXML, SynHighlighterCSS,
  SynHighlighterJScript,
  SynHighlighterCpp,
  SynHighlighterEiffel,
  SynHighlighterFortran,
  SynHighlighterJava,
  SynHighlighterM3,
  SynHighlighterVB,
  SynHighlighterCobol,
  SynHighlighterCS,
  SynHighlighterVBScript,
  SynHighlighterJson,
  SynHighlighterAWK,
  SynHighlighterBAT,
  SynHighlighterDWS,
  SynHighlighterKix,
  SynHighlighterPerl,
  SynHighlighterPython,
  SynHighlighterTclTk,
  SynHighlighterGWS,
  SynHighlighterRuby,
  SynHighlighterUNIXShellScript,
  SynHighlighterCAC,
  SynHighlighterCache,
  SynHighlighterFoxpro,
  SynHighlighterSDD,
  SynHighlighterADSP21xx,
  SynHighlighterASM,
  SynHighlighterHC11,
  SynHighlighterHP48,
  SynHighlighterST,
  SynHighlighterAsmMASM,
  SynHighlighterDML,
  SynHighlighterModelica,
  SynHighlighterSML,
  SynHighlighterDFM,
  SynHighlighterINI,
  SynHighlighterInno,
  SynHighlighterBaan,
  SynHighlighterGalaxy,
  SynHighlighterProgress,
  SynHighlighterMsg,
  SynHighlighterIdl,
  SynHighlighterUnreal,
  SynHighlighterCPM,
  SynHighlighterTeX,
  SynHighlighterHaskell,
  SynHighlighterLDraw,
  SynHighlighterURI,
  SynHighlighterDOT,
  SynHighlighterRC,
  SynHighlighterVrml97,
  SynHighlighterGeneral,
  {$ENDIF}
  SynEdit,
  SynCompletionProposal,
  {$ENDIF}
  dsCategoryButtons
{$ENDIF}
{$IFDEF NOT_LITE}
    , CheckLst
    , VCL.Samples.Spin
{$ENDIF}
{$IFDEF C_SIZECONTROL}
    , SizeControl
{$ENDIF}
    ;

function createComponent(aClass: zend_ustr; aOwner: integer): integer;
function parentControl(id: integer; parent: integer): integer;
function ownerComponent(id: integer): integer;
function objectClass(id: integer): zend_ustr;
function objectIs(id: integer; const aClass: zend_ustr): Boolean;
function ComponentToStringProc(id: integer): string;
function StringToComponentProc(Instance: integer; Value: string): TComponent;

procedure registerGui();

implementation

function objectClass(id: integer): zend_ustr;
begin
  Result := #0;
  if id <> 0 then
  begin
    if (toObject(id) <> nil) then
      begin
          Result := zend_ustr(toObject(id).ClassName);
      end;
  end
end;

function objectIs(id: integer; const aClass: zend_ustr): Boolean;
var
  CL: TClass;
begin
  CL := GetClass(string(aClass));
  Result := (CL <> NIL) and (id <> 0) and (toObject(id) is CL);
end;

function createComponent(aClass: zend_ustr; aOwner: integer): integer;
Var
  Owner: TComponent;
  P: TComponentClass;
begin
Result := 0;
  try
    if aOwner = 0 then
      Owner := nil
    else
      Owner := TComponent(toObject(aOwner));
    P := TComponentClass(GetClass(string(aClass)));
    if (P <> nil) then
      Result := toID(TComponentClass(P).Create(Owner))
  except
  end;
end;

function parentControl(id: integer; parent: integer): integer;
begin
  Result := 0;

  if toObject(id) is TControl then
    if parent = -1 then
      Result := toID(toControl(id).parent)
    else
      toControl(id).parent := toWControl(parent);
end;

function ownerComponent(id: integer): integer;
begin
  if toObject(id) is TComponent then
    Result := toID(TComponent(id).Owner)
  else
    Result := 0;
end;

function ComponentToStringProc(id: integer): string;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
  s: string;
  Component: TComponent;
begin
  Component := TComponent(toObject(id));
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function StringToComponentProc(Instance: integer; Value: string): TComponent;
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(TComponent(toObject(Instance)));
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

procedure registerArr(Classes: array of TPersistentClass);
begin

  RegisterClassesA(Classes);
end;

procedure registerButtons;
begin
  registerArr([TSpeedButton
{$IFDEF NOT_LITE}, TButton, TButtonControl {$ENDIF}
    ]);
  {$IFDEF ADD_SKINS}
  RegisterClassA(sBitbtn.TsBitBtn);
  RegisterClassAlias(sBitbtn.TsBitBtn, 'TBitBtn');
  {$ELSE}
  RegisterClassA(Buttons.TBitBtn);
  UnRegisterClass(Buttons.TBitBtn);
  RegisterClassAlias(dsStdCtrl.TBitBtn, 'TBitBtn');
  {$ENDIF}
end;

procedure registerStandart;
begin
  registerButtons;

  registerArr([TMainMenu, Menus.TMenuItem, Menus.TMenu, Menus.TPopupMenu,
    TRadioButton, TRadioGroup, TLabel, TGroupBox, TPadding, TMargins

{$IFDEF NOT_LITE}
    ,TScrollBar
{$ENDIF}
]);

  RegisterClassA(StdCtrls.TEdit);
  UnRegisterClass(StdCtrls.TEdit);
  RegisterClassAlias(dsStdCtrl.TEdit, 'TEdit');

  RegisterClassA(StdCtrls.TMemo);
  UnRegisterClass(StdCtrls.TMemo);
  RegisterClassAlias(dsStdCtrl.TMemo, 'TMemo');

  RegisterClassA(StdCtrls.TListBox);
  UnRegisterClass(StdCtrls.TListBox);
  RegisterClassAlias(dsStdCtrl.TListBox, 'TListBox');

  RegisterClassA(StdCtrls.TCheckBox);
  UnRegisterClass(StdCtrls.TCheckBox);
  RegisterClassAlias(dsStdCtrl.TCheckBox, 'TCheckBox');

  RegisterClassA(StdCtrls.TComboBox);
  UnRegisterClass(StdCtrls.TComboBox);
  RegisterClassAlias(dsStdCtrl.TComboBox, 'TComboBox');

  RegisterClassA(ExtCtrls.TPanel);
  RegisterClassA(TDSPanel);
        {$IFDEF VS_EDITOR}
  RegisterClassA({[TDragDockObjectCep,} TCustomDockFormCep{]});
        {$ENDIF}
  RegisterClassAliasA(dsCustomControls.TGraphControl, 'TTransparentPanel');
end;

procedure registerAdditional;
begin
  registerArr([TImage, dsExtraCtrls.TShape, dsCustomControls.TGraphControl, TBevel, __TNoVisual
{$IFDEF C_SIZECONTROL}
    , TSizeCtrl
{$ENDIF}
{$IFDEF NOT_LITE}
    , TColorBox, TColorListBox, TLabeledEdit,
    TCheckListBox, TDateTimePicker, TStaticText, TSplitter, TSplitter, TDrawGrid, TControlBar, TMaskEdit,  TComboboxEx,
    TStringGrid, TStringGridStrings, TMonthCalendar, TCoolTrayIcon,
    TDropFilesTarget, TTabSet, TButtonedEdit, TFlowPanel, TGridPanel,
    TBalloonHint, TCategoryPanelGroup

{$ENDIF}
    ]);
end;

procedure registerWin32;
begin
  registerArr([TImageList, TTabControl, TPageControl,
    // TSmartTabs,
{$IFDEF NOT_LITE}
    TTrackBar, TRichEdit, TTabSheet, TUpDown, THotKey, TAnimate,
    TDateTimePicker, TMonthCalendar, TTreeView, TTreeNode, TTreeNodes,
    THeaderControl, THeader, TToolBar, TCoolBar, TPageScroller, TComboBoxEx,
    TListView, TIconOptions, TListItems, TListItem, TListColumn, TListColumns,
{$ENDIF}
    TProgressBar, TStatusBar, TToolBar, TPageScroller]);
end;

procedure registerSystem;
begin
  registerArr([TTimer, { TMediaPlayer, } {$IFDEF NOT_LITE}TPaintBox, {$ENDIF}
    TSizeConstraints
{$IFDEF NOT_LITE}, THintWindow{$ENDIF}{ , TOleContainer }
    ]);
end;

procedure registerGraph;
begin
  registerArr([TFont, TMImage, TGraphic,
  Graphics.TGraphicsObject, Graphics.TPen,
    Graphics.TBrush, Graphics.TPicture,
    Graphics.TCustomCanvas, Graphics.TCanvas,Graphics.TMetafileCanvas,
    Graphics.TBitmap, TWICImage, TPNGImage, TJpegImage, TSVGGraphic,
    TSVGImage, TSVGImageList, TGIFImage, TGIFImagelist,
    Graphics.TMetafile, Graphics.TMetafileCanvas,
    Graphics.TIcon]);
end;

procedure registerSamples;
begin
{$IFDEF NOT_LITE}
   registerArr([
   TSpinButton, TSpinEdit
   ]);
{$ENDIF}
end;

procedure registerForms;
begin
  registerArr([TControl, TWinControl, Forms.TCustomFrame, Forms.TCustomForm,
  Forms.TCustomActiveForm,Forms.TForm,
    Forms.TApplication,
{$IFDEF NOT_LITE}
    TFrame,
    TColorDialog, TCommonDialog,
    TDataModule,
    TFontDialog,
    Forms.TControlScrollBar, Forms.TScrollingWinControl,
    Forms.TScreen, TScreenEx, TOpenDialog, TSaveDialog
    , Dialogs.TPrinterSetupDialog, Dialogs.TPrintDialog,
    Dialogs.TPageSetupDialog, Dialogs.TFindDialog, Dialogs.TReplaceDialog
{$ENDIF}
    ]);
  RegisterClassAliasA(Forms.TForm, 'TForm');
{$IFDEF NOT_LITE}
  RegisterClassA(Forms.TScrollBox);
  UnRegisterClass(Forms.TScrollBox);
  RegisterClassAlias(dsStdCtrl.TScrollBox, 'TScrollBox');
{$IFNDEF ADD_AC}
RegisterClassAlias(TColorDialog, 'TDMSColorDialog');
{$ENDIF}  {$ENDIF}
end;

procedure registerVSEditor;
begin
{$IFDEF VS_EDITOR}
  registerArr([
     DockTabSet.TDockTabSet, DockTabSet.TTabDockPanel,
     DockTabSet.TDockClientInfo,
    TNxCustomInspector, TNxScrollBar, TNxControl, TNxTextItem, TNxTimeItem,
    TNxPopupItem, TNxToolbarItemButton, TNxToolbarItem, TNxCheckBoxItem,
    TNxButtonItem, TNxMemoItem, TNxAlignmentItem, TNxVertAlignmentItem,
    TNxColorItem, TNxCustomNumberItem, TNxSpinItem, TNxTrackBarItem,
    TNxRadioItem, TNxPropertyItem, TNxPropertyItems, TNxProgressItem,
    TNxColorItem, TNxColorPicker,
    TNextInspector, TNxComboBoxItem,
    TNxButtonEdit,
TNxCalcEdit,
TNxFolderEdit,
TNxImagePathEdit,
TNxCheckBox,
TNxComboBox,
TNxDatePicker,
TNxFontComboBox,
TNxSpinEdit,
TNxEdit,
TNxMemo,
TNxMemoInplaceEdit,
TNxNumberEdit,
TNxRadioButton,
TNxTimeEdit,
TNxMonthCalendar,
TNxTimePicker,
    {$IFDEF ADD_AC}
    sDialogs.TsOpenDialog, sDialogs.TsOpenPictureDialog,
    sDialogs.TsSaveDialog, sDialogs.TsSavePictureDialog,
    sDialogs.TsColorDialog,
    {$ENDIF}
    {$IFDEF ADD_SYN}
    TSynEdit, TSynPHPSyn, TSynForm, TSynBaseCompletionProposal,
     TSynBaseCompletionProposalForm,
    {$IFDEF ADD_SYN_OPT}
     TSynGeneralSyn, TSynCppSyn, TSynCssSyn, TSynHTMLSyn, TSynSQLSyn,
    TSynJScriptSyn, TSynXMLSyn, TSynEiffelSyn,
    //startmy
    TSynFortranSyn, TSynJavaSyn, TSynM3Syn, TSynPasSyn, TSynVBSyn, TSynCobolSyn,
    TSynCSSyn, TSynVBScriptSyn, TSynJsonSyn, TSynDWSSyn, TSynBATSyn, TSynAWKSyn,
    TSynKIXSyn, TSynPerlSyn, TSynPythonSyn, TSynGWScriptSyn, TSynRubySyn,
    TSynUNIXShellScriptSyn, TSynCACSyn, TSynCacheSyn, TSynFoxproSyn, TSynSDDSyn,
    TSynADSP21xxSyn, TSynASMSyn, TSynAsmMASMSyn, TSynHC11Syn, TSynHP48Syn,
    TSynSTSyn, TSynDMLSyn, TSynModelicaSyn, TSynDFMSyn, TSynINISyn, TSynINNOSyn,
    TSynBaanSyn, TSynGalaxySyn,
    TSynProgressSyn, TSynMSGSyn,
    TSynIDLSyn, TSynUnrealSyn, TSynCPMSyn, TSynTeXSyn, TSynHaskellSyn, TSynLDRSyn,
    TSynURISyn, TSynDotSyn, TSynRCSyn,
    //endmy

    {$ENDIF}
    TSynCompletionProposal, TSynHighlighterAttributes,
    {$ENDIF}
    TButtonCategory, TButtonCategories, TButtonItem, TCategoryButtons,
    TButtonCollection
    ]);
{$ENDIF}
{$IFDEF ADD_AC}
RegisterClassAlias(sDialogs.TsColorDialog, 'TDMSColorDialog');
{$ENDIF}
end;
{$IFDEF ADD_SKINS}
procedure registerSkins;
begin

{$IFDEF IFEDF}
  registerArr([
     TsSkinManager, TsSkinProvider,
      TsSpeedButton, TsTrackBar, TsProgressBar,
      TsBevel, TsLabel, TsLabelFX
    ]);
{$ENDIF}

end;
{$ENDIF}
var
  Registered: Boolean = false;

procedure registerGui();
begin

  if Registered then
    exit;
   {$IFDEF ADD_SKINS}
   acPng.UseACPng := True;
   {$ENDIF}
  registerForms;
  registerStandart;
  registerAdditional;
  registerWin32;
  registerSystem;
  registerSamples;
  registerGraph;
  //DefaultDockTreeClass := CaptionedDockTree2.TCaptionedDockTree;
{$IFDEF ADD_SKINS}
  registerSkins;
{$ENDIF}

{$IFDEF ADD_CHROMIUM}
  registerArr([TChromium, TCefWindowParent, TChromiumOptions]);
{$ENDIF}
  registerVSEditor;
  Registered := true;
end;

initialization
registerGui;

end.
