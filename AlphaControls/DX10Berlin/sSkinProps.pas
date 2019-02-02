unit sSkinProps;
{$I sDefs.inc}

interface

uses StdCtrls, sConst;

const
  // Images
  s_BordersMask          = 'BORDERSMASK';
  s_OuterMask            = 'OUTERMASK';
  s_ExBorder             = 'EXBORDER';
  s_LightRegion          = 'LRGN';
  s_Glow                 = 'GLOW';
  s_GlowMargin           = 'GLOWMARGIN';
  s_GripImage            = 'GRIPIMAGE';
  s_GripHorz             = 'GRIPHORZ';
  s_GripVert             = 'GRIPVERT';
  s_StatusPanelMask      = 'STATUSPANELMASK';
  s_SliderChannelMask    = 'SLIDERCHANNEL';

  s_ImgTopLeft           = 'IMGTOPLEFT';
  s_ImgTopRight          = 'IMGTOPRIGHT';
  s_ImgBottomLeft        = 'IMGBTMLEFT';
  s_ImgBottomRight       = 'IMGBTMRIGHT';

  s_NormalTitleBar       = 'TITLEBAR';

  s_BorderIconClose      = 'BICONCLOSE';
  s_BorderIconCloseAlone = 'BICLOSEALONE';
  s_BorderIconMaximize   = 'BICONMAX';
  s_BorderIconNormalize  = 'BICONNORM';
  s_BorderIconMinimize   = 'BICONMIN';
  s_BorderIconHelp       = 'BICONHELP';
  s_TitleButtonMask      = 'TITLEBUTTON';

  s_SmallIconNormalize   = 'SICONNORM';
  s_SmallIconMinimize    = 'SICONMIN';
  s_SmallIconMaximize    = 'SICONMAX';
  s_SmallIconClose       = 'SICONCLOSE';
  s_SmallIconHelp        = 'SICONHELP';

  s_ItemGlyph            = 'GLYPHMASK';
  s_SliderHorzMask       = 'SLIDERMASK';
  s_SliderVertMask       = 'SLIDERVMASK';
  s_TickVert             = 'TICKVERT';
  s_TickHorz             = 'TICKHORZ';
  s_ProgVert             = 'PROGVERT';
  s_ProgHorz             = 'PROGHORZ';

  s_NA                   = 'N/A';
  // Properties common for SkinSections <<<<<<<<<
  s_ParentClass          = 'PARENTCLASS';
  s_ReservedBoolean      = 'RESERVEDBOOLEAN';
  s_GiveOwnFont          = 'GIVEOWNFONT';
  s_ShiftOnClick         = 'SHIFTCLICK';
  s_ShowFocus            = 'SHOWFOCUS';
  s_UseState2            = 'USESTATE2';
  // State 0
  s_FontColor            = 'FONTCOLOR';
  s_TCLeft               = 'TCLEFT';
  s_TCTop                = 'TCTOP';
  s_TCRight              = 'TCRIGHT';
  s_TCBottom             = 'TCBOTTOM';
  s_Color                = 'COLOR';
  s_Transparency         = 'TRANSPARENCY';
  s_GradientPercent      = 'GRADIENTPERCENT';
  s_GradientData         = 'GRADIENTDATA';
  s_ImagePercent         = 'IMAGEPERCENT';
  s_Pattern              = 'PATTERN';
  s_GlowColor            = 'GCOL';
  s_GlowSize             = 'GSIZE';
  // State 1
  s_HotFontColor         = 'HOT' + s_FontColor;
  s_HotTCLeft            = 'HOT' + s_TCLeft;
  s_HotTCTop             = 'HOT' + s_TCTop;
  s_HotTCRight           = 'HOT' + s_TCRight;
  s_HotTCBottom          = 'HOT' + s_TCBottom;
  s_HotColor             = 'HOT' + s_Color;
  s_HotTransparency      = 'HOT' + s_Transparency;
  s_HotGradientPercent   = 'HOT' + s_GradientPercent;
  s_HotGradientData      = 'HOT' + s_GradientData;
  s_HotImagePercent      = 'HOT' + s_ImagePercent;
  s_HotPattern           = 'HOT' + s_Pattern;
  s_HotGlowColor         = 'H'   + s_GlowColor;
  s_HotGlowSize          = 'H'   + s_GlowSize;
  // State 2
  s_FontColor2         = s_FontColor       + '2';
  s_TCLeft2            = s_TCLeft          + '2';
  s_TCTop2             = s_TCTop           + '2';
  s_TCRight2           = s_TCRight         + '2';
  s_TCBottom2          = s_TCBottom        + '2';
  s_Color2             = s_Color           + '2';
  s_Transparency2      = s_Transparency    + '2';
  s_GradientPercent2   = s_GradientPercent + '2';
  s_GradientData2      = s_GradientData    + '2';
  s_ImagePercent2      = s_ImagePercent    + '2';
  s_Pattern2           = s_Pattern         + '2';
  s_GlowColor2         = s_GLOWCOLOR       + '2';
  s_GlowSize2          = s_GLOWSIZE        + '2';
  // End of common props >>>>>>>>>>>>>>>>>>>>>>>>

  s_BorderColor1         = 'BORDERCOLOR1';
  s_BorderColor2         = 'BORDERCOLOR2';
  s_BorderWidth          = 'BORDERWIDTH';
  s_TitleHeight          = 'TITLEHEIGHT';
  s_FormOffset           = 'FORMOFFSET';         // Content offset

  s_ShadowOffset         = 'ALIGNOFFSET';        // Additional offset for a shadow
  s_ShadowOffsetR        = 'ALIGNOFFSETR';
  s_ShadowOffsetT        = 'ALIGNOFFSETT';
  s_ShadowOffsetB        = 'ALIGNOFFSETB';

  s_WndShadowRadius      = 'WSHRAD';
  s_WndShadowOffset      = 'WSHOFFS';
  s_WndShadowSize        = 'WSHSIZE';
  s_WndShadowColorN      = 'WSHCOLN';
  s_WndShadowColorA      = 'WSHCOLA';

  s_CenterOffset         = 'CENTEROFFSET';
  s_MaxTitleHeight       = 'MAXHEIGHT';
  s_BorderMode           = 'BORDERMODE';

  s_BrightMin            = 'BRIGHTMIN';
  s_BrightMax            = 'BRIGHTMAX';

  // Global Colors
  s_BorderColor          = 'BORDERCOLOR';

  s_EditTextOk           = 'EDITTEXT_OK';
  s_EditTextWarning      = 'EDITTEXT_WARN';
  s_EditTextAlert        = 'EDITTEXT_ALERT';
  s_EditTextHighlight1   = 'EDITTEXT_H1';
  s_EditTextHighlight2   = 'EDITTEXT_H2';
  s_EditTextHighlight3   = 'EDITTEXT_H3';

  s_EditText_Inverted    = 'EDITTEXT_INV';
  s_EditBG_Inverted      = 'EDITBG_INV';
  s_EditBG_OddRow        = 'EDITBG_ODD';
  s_EditBG_EvenRow       = 'EDITBG_EVEN';

  s_EditBGOk             = 'EDITBG_OK';
  s_EditBGWarning        = 'EDITBG_WARN';
  s_EditBGAlert          = 'EDITBG_ALERT';

  s_EditGridLine         = 'GRIDLINE';

  s_MainColor            = 'MAINCOLOR';   // Just filled by main skin color

  s_BtnColor1Active      = 'BTNCOLOR1ACTIVE';
  s_BtnColor2Active      = 'BTNCOLOR2ACTIVE';
  s_BtnBorderActive      = 'BTNBORDERACTIVE';
  s_BtnFontActive        = 'BTNFONTACTIVE';

  s_BtnColor1Normal      = 'BTNCOLOR1NORMAL';
  s_BtnColor2Normal      = 'BTNCOLOR2NORMAL';
  s_BtnBorderNormal      = 'BTNBORDERNORMAL';
  s_BtnFontNormal        = 'BTNFONTNORMAL';

  s_BtnColor1Pressed     = 'BTNCOLOR1PRESSED';
  s_BtnColor2Pressed     = 'BTNCOLOR2PRESSED';
  s_BtnBorderPressed     = 'BTNBORDERPRESSED';
  s_BtnFontPressed       = 'BTNFONTPRESSED';


  // Standard mandatory SkinSections
  s_GlobalInfo           = 'GLOBALINFO';
  s_Transparent          = 'TRANSPARENT'; // Special fully transparent section

  s_Caption              = 'CAPTION';
  s_FormTitle            = 'FORMTITLE';
  s_Form                 = 'FORM';
  s_Dialog               = 'DIALOG';
  s_Hint                 = 'HINT';
  s_MDIArea              = 'MDIAREA';
  s_MainMenu             = 'MAINMENU';
  s_MenuItem             = 'MENUITEM';
  s_Selection            = 'SELECTION';
  s_MenuIcoLine          = 'ICOLINE';
  s_MenuExtraLine        = 'EXTRALINE';
  s_ScrollBar1H          = 'SCROLLBAR1H';
  s_ScrollBar1V          = 'SCROLLBAR1V';
  s_ScrollBar2H          = 'SCROLLBAR2H';
  s_ScrollBar2V          = 'SCROLLBAR2V';
  s_ScrollSliderV        = 'SCROLLSLIDERV';
  s_ScrollSliderH        = 'SCROLLSLIDERH';
  s_ScrollBtnLeft        = 'SCROLLBTNLEFT';
  s_ScrollBtnTop         = 'SCROLLBTNTOP';
  s_ScrollBtnRight       = 'SCROLLBTNRIGHT';
  s_ScrollBtnBottom      = 'SCROLLBTNBOTTOM';
  s_Divider              = 'DIVIDER';
  s_DividerV             = 'DIVIDERV';
  s_ColHeader            = 'COLHEADER';
  s_ProgressH            = 'PROGRESSH';
  s_ProgressV            = 'PROGRESSV';
  s_AlphaEdit            = 'ALPHAEDIT';

  s_TabTop               = 'TABTOP';
  s_RibbonTab            = 'RIBBONTAB';
  s_TabBottom            = 'TABBOTTOM';
  s_TabLeft              = 'TABLEFT';
  s_TabRight             = 'TABRIGHT';

  s_Edit                 = 'EDIT';
  s_ToolButton           = 'TOOLBUTTON';
  s_ComboBox             = 'COMBOBOX';
  s_ComboBtn             = 'COMBOBTN';
  s_AlphaComboBox        = 'ALPHACOMBOBOX';
  s_ComboNoEdit          = 'COMBONOEDIT';
  s_UpDown               = 'UPDOWNBTN';
  s_Button               = 'BUTTON';
  s_ButtonBig            = 'BUTTON_BIG';
  s_ButtonHuge           = 'BUTTON_HUGE';
  s_SpeedButton          = 'SPEEDBUTTON';
  s_SpeedButton_Small    = 'SPEEDBUTTON_SMALL';
  s_Panel                = 'PANEL';
  s_PanelLow             = 'PANEL_LOW';
  s_TabControl           = 'TABCONTROL';
  s_PageControl          = 'PAGECONTROL';
  s_RibbonPage           = 'RIBBONPAGE';
  s_TabSheet             = 'TABSHEET';
  s_StatusBar            = 'STATUSBAR';
  s_ToolBar              = 'TOOLBAR';
  s_Splitter             = 'SPLITTER';
  s_GroupBox             = 'GROUPBOX';
  s_Gauge                = 'GAUGE';
  s_TrackBar             = 'TRACKBAR';
  s_CheckBox             = 'CHECKBOX';
  s_RadioButton          = 'CHECKBOX';
  s_DragBar              = 'DRAGBAR';
  s_Bar                  = 'BAR';
  s_BarTitle             = 'BARTITLE';
  s_BarPanel             = 'BARPANEL';
  s_WebBtn               = 'WEBBUTTON';

  s_GripH                = 'GRIPH';
  s_GripV                = 'GRIPV';

  // Standard auxiliary SkinSections
  s_MenuCaption          = 'MENUCAPTION';
  s_DialogTitle          = 'DIALOGTITLE';
  s_MenuButton           = 'MENUBTN';
  s_MenuLine             = 'MENULINE';
  s_FormHeader           = 'FORMHEADER';

  s_TBBtn                = 'TB_BTN';
  s_TBMenuBtn            = 'TB_MENUBTN';
  s_TBTab                = 'TB_TAB';

  s_ColHeaderA           = 'COLHEADERA'; // Alone column skin
  s_ColHeaderL           = 'COLHEADERL';
  s_ColHeaderR           = 'COLHEADERR';

  s_Slider_Off           = 'SLIDER_OFF';
  s_Slider_On            = 'SLIDER_ON';
  s_Thumb_Off            = 'THUMB_OFF';
  s_Thumb_On             = 'THUMB_ON';

  s_TabLeftFirst         = 'TABLEFTFIRST';
  s_TabTopFirst          = 'TABTOPFIRST';
  s_TabRightFirst        = 'TABRIGHTFIRST';
  s_TabBottomFirst       = 'TABBOTTOMFIRST';

  s_TabLeftLast          = 'TABLEFTLAST';
  s_TabTopLast           = 'TABTOPLAST';
  s_TabRightLast         = 'TABRIGHTLAST';
  s_TabBottomLast        = 'TABBOTTOMLAST';

  s_TabLeftMiddle        = 'TABLEFTMIDDLE';
  s_TabTopMiddle         = 'TABTOPMIDDLE';
  s_TabRightMiddle       = 'TABRIGHTMIDDLE';
  s_TabBottomMiddle      = 'TABBOTTOMMIDDLE';

  // Reserved words
  s_MasterBitmap         = 'MASTERBITMAP';
  s_Preview              = 'PREVIEW';
  s_CheckGlyph           = 'CHECK';
  s_CheckBoxChecked      = 'BOXCHECKED';
  s_CheckBoxUnChecked    = 'BOXUNCHECKED';
  s_CheckBoxGrayed       = 'BOXGRAYED';
  s_RadioButtonChecked   = 'RADIOCHECKED';
  s_RadioButtonUnChecked = 'RADIOUNCHECKED';
  s_SmallBoxChecked      = 'SMALLCHECKED';
  s_SmallBoxUnChecked    = 'SMALLUNCHECKED';
  s_SmallBoxGrayed       = 'SMALLGRAYED';

  s_Version              = 'VERSION';
  s_Author               = 'AUTHOR';
  s_Description          = 'DESCRIPTION';

  s_ColorToneRed         = 'COLORTONERED';
  s_ColorToneGreen       = 'COLORTONEGREEN';
  s_ColorToneBlue        = 'COLORTONEBLUE';
  s_ColorToneYellow      = 'COLORTONEYELLOW';

  s_ColorToneRedActive   = 'COLORTONEREDACTIVE';
  s_ColorToneGreenActive = 'COLORTONEGREENACTIVE';
  s_ColorToneBlueActive  = 'COLORTONEBLUEACTIVE';
  s_ColorToneYellowActive = 'COLORTONEYELLOWACTIVE';

  s_ColorRedText         = 'COLORTONEREDTEXT';
  s_ColorGreenText       = 'COLORTONEGREENTEXT';
  s_ColorBlueText        = 'COLORTONEBLUETEXT';
  s_ColorYellowText      = 'COLORTONEYELLOWTEXT';

  s_ColorRedTextActive   = 'COLORTONEREDTEXTACTIVE';
  s_ColorGreenTextActive = 'COLORTONEGREENTEXTACTIVE';
  s_ColorBlueTextActive  = 'COLORTONEBLUETEXTActive';
  s_ColorYellowTextActive = 'COLORTONEYELLOWTEXTActive';

  s_Shadow1Color         = 'SHADOW1COLOR';
  s_Shadow1Offset        = 'SHADOW1OFFSET';
  s_Shadow1Blur          = 'SHADOW1BLUR';
  s_Shadow1Transparency  = 'SHADOW1TRANSPARENCY';

  s_BISpacing            = 'BISPACE';
  s_BIVAlign             = 'BIVALIGN';
  s_BIRightMargin        = 'BIRIGHT';
  s_BILeftMargin         = 'BILEFT';
  s_BITopMargin          = 'BITOP';
  s_BIKeepHUE            = 'BIKEEPHUE';

  s_TabsCovering         = 'TABSCOVERING';
  s_ArrowLineWidth       = 'ARROWLINE';
  s_ArrowStyle           = 'ARROWSTYLE';

  s_States               = 'STATES';

  s_UseAeroBluring       = 'AEROBLUR';

  s_ComboMargin          = 'COMBOMARGIN';
  s_SliderMargin         = 'SLIDERMARGIN';

  // Outer effects
  s_OuterOffsL           = 'OUTOFFSL';
  s_OuterOffsT           = 'OUTOFFST';
  s_OuterOffsR           = 'OUTOFFSR';
  s_OuterOffsB           = 'OUTOFFSB';

  s_OuterMode            = 'OUTERMODE'; // 0 - None, 1 - Lowered (work if OUTERMASK is empty), 2 - Shadow, 3 - Custom (calculated or raster)
  s_OuterOpacity         = 'OUTOPACITY';

  s_OuterColorL           = 'OUTCOLL';
  s_OuterColorT           = 'OUTCOLT';
  s_OuterColorR           = 'OUTCOLR';
  s_OuterColorB           = 'OUTCOLB';
  s_OuterBlur             = 'OUTBLUR';
  s_OuterRadius           = 'OUTRADIUS';

  s_ShOERadius           = 'SH_RADIUS_OE';
  s_LoOERadius           = 'LO_RADIUS_OE';
  s_ShOEBlur             = 'SH_BLUR_OE';
  s_LoOEBlur             = 'LO_BLUR_OE';
  s_ShadowColorL         = 'SH_COLORL'; // Main shadow
{
  s_ShadowColorT         = 'SH_COLORT';
  s_ShadowColorR         = 'SH_COLORR';
  s_ShadowColorB         = 'SH_COLORB';
}
  s_ShadowWidthL         = 'SH_WIDTHL';
  s_ShadowWidthT         = 'SH_WIDTHT';
  s_ShadowWidthR         = 'SH_WIDTHR';
  s_ShadowWidthB         = 'SH_WIDTHB';

  s_ShadowOffsL          = 'SH_OFFSETL';
  s_ShadowOffsT          = 'SH_OFFSETT';
  s_ShadowOffsR          = 'SH_OFFSETR';
  s_ShadowOffsB          = 'SH_OFFSETB';

  s_ShadowSource         = 'SH_SOURCE';
  s_ShadowOpacity        = 'SH_OPACITY';
  s_ShadowMask           = 'SH_MASK';

  s_LowColorL            = 'LO_COLORL'; // Main lowered
  s_LowColorT            = 'LO_COLORT';
  s_LowColorR            = 'LO_COLORR';
  s_LowColorB            = 'LO_COLORB';

  s_LowWidthL            = 'LO_WIDTHL';
  s_LowWidthT            = 'LO_WIDTHT';
  s_LowWidthR            = 'LO_WIDTHR';
  s_LowWidthB            = 'LO_WIDTHB';

  s_LowOffsL             = 'LO_OFFSETL';
  s_LowOffsT             = 'LO_OFFSETT';
  s_LowOffsR             = 'LO_OFFSETR';
  s_LowOffsB             = 'LO_OFFSETB';

  s_LowSource            = 'LO_SOURCE';
  s_LowOpacity           = 'LO_OPACITY';
  s_LowMask              = 'LO_MASK';

  acTabSections: array [TacTabLayout, TacSide] of string = (
    (s_TabLeftFirst,  s_TabTopFirst,  s_TabRightFirst,  s_TabBottomFirst),  // tpFirst
    (s_TabLeftLast,   s_TabTopLast,   s_TabRightLast,   s_TabBottomLast),   // tpLast
    (s_TabLeftMiddle, s_TabTopMiddle, s_TabRightMiddle, s_TabBottomMiddle), // tpMiddle
    (s_TabLeft,       s_TabTop,       s_TabRight,       s_TabBottom)        // tpSingle
  );

  acScrollBtns:  array [TacSide] of string = (s_ScrollBtnLeft, s_ScrollBtnTop, s_ScrollBtnRight, s_ScrollBtnBottom);
  acScrollParts: array [TacSide] of string = (s_ScrollBar1H,   s_ScrollBar1V,  s_ScrollBar2H,    s_ScrollBar2V);
  acUpDownBtns:  array [TacSide] of string = (s_UpDown + '_LEFT', s_UpDown + '_TOP', s_UpDown + 'RIGHT', s_UpDown + '_BOTTOM');

  acScrollSliders: array [boolean] of string = (s_ScrollSliderH, s_ScrollSliderV);

  acRadioGlyphs: array [boolean] of string = (s_RadioButtonUnChecked, s_RadioButtonChecked);
  acCheckGlyphs: array [TCheckBoxState] of string = (s_CheckBoxUnChecked, s_CheckBoxChecked, s_CheckBoxGrayed);
  acSmallChecks: array [TCheckBoxState] of string = (s_SmallBoxUnChecked, s_SmallBoxChecked, s_SmallBoxGrayed);

implementation

end.
