unit sRegisterIt;
{$I sDefs.inc}

interface


uses
  Classes,
  sScrollBar, sLabel, sButton, sBitBtn, sSpeedButton, sPanel, sListBox, acTitleBar, sComboBoxes, sGroupBox, sTrackBar,
{$IFNDEF ALITE}
  {$IFDEF USEHINTMANAGER}
  sHintManager,
  {$ENDIF}
  sToolBar, sColorSelect, sDialogs, sCurrencyEdit, sSpinEdit, sRadioButton, sComboEdit, sPageControl,
  sCurrEdit, sToolEdit, sMonthCalendar, sBevel, sStatusBar, sCalculator,
  sMaskEdit, sSplitter, sTabControl, sFontCtrls, sScrollBox, sRichEdit, sFileCtrl,
  sTreeView, sFrameAdapter, sUpDown, acSlider, acImage, sFrameBar, acShellCtrls, acCoolBar, acFloatCtrls,
  acProgressBar, acNotebook, acAlphaHints, acHeaderControl, acMagn, acPageScroller, acMeter, acPopupCtrls,
  {$IFNDEF BCB}
    {$IFDEF DELPHI7UP}
  acWebBrowser,
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  sListView, sGauge, sEdit, sSkinManager, sSkinProvider, sComboBox, sCheckBox, acAlphaImageList, sMemo, sCheckListBox;


procedure Register;


implementation


uses Registry, Windows, Graphics, SysUtils,
  {$IFDEF SPLASH}ToolsAPI, {$ENDIF}
  {$IFNDEF ALITE}acArcControls, acPathDialog, sColorDialog, sStoreUtils, {$ENDIF}
  acntUtils, acFontStore;


{$IFDEF ALITE}
const
  s_AlphaLite = 'AlphaLite';
{$ENDIF}

{$IFDEF SPLASH}
{$R ACLOGO.RES}
procedure RegisterWithSplashScreen;
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.LoadFromResourceName(hInstance, 'ACLOGO');
  try
    SplashScreenServices.AddPluginBitmap('AlphaControls 2019', Bmp.Handle, False,
{$IFNDEF ALITE}
      {$IFDEF RUNIDEONLY}'Trial edition'{$ELSE}'Registered'{$ENDIF},
{$ELSE}
      'Lite Edition',
{$ENDIF}
      '(version ' + sSkinManager.acCurrentVersion + ')');
  finally
    Bmp.Free;
  end;
end;
{$ENDIF}


procedure Register;
begin
{$IFDEF SPLASH}
  RegisterWithSplashScreen;
{$ENDIF}

{$IFNDEF ALITE}
  RegisterComponents('AlphaStandard', [
    TsLabel, TsEdit, TsMemo, TsButton, TsCheckBox, TsRadioButton,
    TsListBox, TsComboBox, TsScrollBar, TsGroupBox, TsRadioGroup, TsPanel, TsBitBtn,
    TsSpeedButton, TsMaskEdit, TsBevel, TsScrollBox, TsCheckListBox, TsSplitter,
    TsTabControl, TsPageControl, TsRichEdit, TsTrackBar, TsProgressBar, TsUpDown, TsTreeView,
    TsListView, TsHeaderControl, TsStatusBar, TsToolBar, TsGauge, TsSpinEdit, TsCoolBar,
    TsNotebook, TsImage]);

  RegisterComponents('AlphaAdditional', [
    TsWebLabel, TsDecimalSpinEdit, TsColorSelect, TsDragBar, TsComboBoxEx, TsColorBox,
    TsMonthCalendar, TsComboEdit, TsCurrencyEdit, TsDateEdit, TsCalcEdit, TsDirectoryEdit,
    TsFileNameEdit, TsFilterComboBox, TsFontComboBox, TsFontListBox, TsLabelFX,
    TsFrameBar, TsColorsPanel, TsStickyLabel, TsShellTreeView, TsShellComboBox,
    TsShellListView, TsTimePicker, TsSlider, TsHTMLLabel, TsPageScroller
    {$IFNDEF BCB}{$IFDEF DELPHI7UP}, TsWebBrowser{$ENDIF}{$ENDIF}, TsTreeViewEx,
    TsPopupBox, TsTrackEdit, TsSkinSelector, TsGradientPanel, TsImgLabel, TsRollOutPanel, 
    TsRangeSelector, TsSplitView, TsSysButton]);

  RegisterComponents('AlphaTools', [
    TsSkinManager, TsSkinProvider, TsFrameAdapter, TsCalculator, TsOpenDialog,
    TsSaveDialog, TsOpenPictureDialog, TsSavePictureDialog, TsMagnifier,
    TsColordialog, TsPathDialog, TsAlphaImageList, TsVirtualImageList,
    {$IFDEF USEHINTMANAGER} TsHintManager, {$ENDIF}
    TsAlphaHints, TsTitleBar, TsFloatButtons, TsCharImageList, TsFontStore
    ]);

  RegisterComponents('AlphaArcControls', [TsMeter, TsArcGauge, TsArcPreloader, TsArcHandle,
    TsArcDial, TsRoundBtn, TsBadgeBtn]);

  RegisterNoIcon([TsTabSheet]);
  RegisterClasses([TsTabSheet, TsEditLabel, TsStdColorsPanel, TsDlgShellListView, TsPage]);
{$ELSE}
  RegisterComponents(s_AlphaLite, [
    TsSkinManager, TsSkinProvider, TsEdit, TsCheckBox, TsPanel, TsButton, TsBitBtn, TsScrollBar, TsGroupBox, TsTrackBar,
    TsLabel, TsWebLabel, TsLabelFX, TsComboBox, TsListBox, TsCheckListBox, TsGauge, TsAlphaImageList, TsTitleBar, TsFontStore, TsSkinSelector]);

  RegisterClasses([TsSpeedButton, TsListView, TsMemo]);
  RegisterNoIcon([TsSpeedButton, TsListView, TsMemo]);
{$ENDIF}
end;

end.
