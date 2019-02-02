unit acLFPainter;
{$I cxVer.inc} {$undef DELPHI5}
{$I sDefs.inc}

// WARNING! This unit is compatible with Devexpress version 2011 and newer
// for older versions used the acLFPainter6.pas unit

{$DEFINE VER18} // cxGrid version 18 and newer
{$DEFINE VER17_1_4}
{$DEFINE VER16_2_2}
{$DEFINE VER16_1_4}
{$DEFINE VER14_1_2}
{$DEFINE VER13_2_2}
{$DEFINE VER12_2_3}
{$DEFINE VER12_1_6}
{$DEFINE VER26}
{$DEFINE VER23}

//{$DEFINE EXPRESSBARS} // Uncomment this key for support of ExpressBars

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ImgList,
  cxLookAndFeelPainters, cxGraphics, cxClasses, dxCore,
{$IFDEF VER17_1_4}
  cxGeometry,
{$ENDIF}
{$IFDEF VER12_1_6}
  cxPCPainters, cxPC, cxLookAndFeels, cxPCPaintersFactory, 
  {$IFDEF EXPRESSBARS} dxStatusBar, dxBar, {$ENDIF}
  {$IFDEF VER14_1_2} dxSkinsLookAndFeelPainter, {$ENDIF}
{$ENDIF}
  {$IFNDEF DELPHI5} Types, {$ENDIF}
  sSkinManager, sStyleSimply, sMaskData;


type
  TsDevExProvider = class(TComponent);

  TcxACLookAndFeelPainter = class(TcxStandardLookAndFeelPainter)
  public
    function LookAndFeelName: string; override;
    // colors
    function DefaultContentColor: TColor; override;
    function DefaultContentEvenColor: TColor; override;
    function DefaultContentOddColor: TColor; override;
    function DefaultContentTextColor: TColor; override;
    function DefaultEditorBackgroundColor(AIsDisabled: Boolean): TColor; override;
    function DefaultEditorBackgroundColorEx(AKind: TcxEditStateColorKind): TColor; override;
    function DefaultEditorTextColor(AIsDisabled: Boolean): TColor; override;
    function DefaultEditorTextColorEx(AKind: TcxEditStateColorKind): TColor; override;
    function DefaultFilterBoxColor: TColor; override;
    function DefaultFilterBoxTextColor: TColor; override;
    function DefaultFixedSeparatorColor: TColor; override;
    function DefaultFooterColor: TColor; override;
    function DefaultFooterTextColor: TColor; override;
    function DefaultGridDetailsSiteColor: TColor; override;
    function DefaultGridLineColor: TColor; override;
    function DefaultGroupByBoxColor: TColor; override;
    function DefaultGroupByBoxTextColor: TColor; override;
    function DefaultGroupColor: TColor; override;
    function DefaultGroupTextColor: TColor; override;
    function DefaultHeaderBackgroundColor: TColor; override;
    function DefaultHeaderBackgroundTextColor: TColor; override;
    function DefaultHeaderColor: TColor; override;
    function DefaultHeaderTextColor: TColor; override;
    function DefaultHyperlinkTextColor: TColor; override;
    function DefaultInactiveColor: TColor; override;
    function DefaultInactiveTextColor: TColor; override;
    function DefaultPreviewTextColor: TColor; override;
    function DefaultRecordSeparatorColor: TColor; override;
    function DefaultSizeGripAreaColor: TColor; override;

    function DefaultVGridCategoryColor: TColor; override;
    function DefaultVGridCategoryTextColor: TColor; override;
    function DefaultVGridLineColor: TColor; override;
    function DefaultVGridBandLineColor: TColor; override;

    function DefaultDateNavigatorHeaderColor: TColor; override;
    function DefaultDateNavigatorSelectionColor: TColor; override;
    function DefaultDateNavigatorSelectionTextColor: TColor; override;
    function DefaultDateNavigatorTextColor: TColor; override;
    function DefaultDateNavigatorTodayTextColor: TColor; {$IFNDEF VER16_1_4} override; {$ENDIF}

    function DefaultSchedulerBackgroundColor: TColor; override;
    function DefaultSchedulerTextColor: TColor; override;
    function DefaultSchedulerBorderColor: TColor; override;
    function DefaultSchedulerControlColor: TColor; override;
    function DefaultSchedulerNavigatorColor: TColor; override;
    function DefaultSchedulerViewContentColor: TColor; override;
    function DefaultSchedulerViewSelectedTextColor: TColor; override;
    function DefaultSchedulerViewTextColor: TColor; override;
    function DefaultSelectionColor: TColor; override;
    function DefaultSelectionTextColor: TColor; override;
    function DefaultSeparatorColor: TColor; override;
    function DefaultTabColor: TColor; override;
    function DefaultTabTextColor: TColor; override;
    function DefaultTabsBackgroundColor: TColor; override;

    function DefaultTimeGridMajorScaleColor: TColor; override;
    function DefaultTimeGridMajorScaleTextColor: TColor; override;
    function DefaultTimeGridMinorScaleColor: TColor; override;
    function DefaultTimeGridMinorScaleTextColor: TColor; override;
    function DefaultTimeGridSelectionBarColor: TColor; override;

    function DefaultChartDiagramValueBorderColor: TColor; override;
    function DefaultChartDiagramValueCaptionTextColor: TColor; override;
    function DefaultChartHistogramAxisColor: TColor; override;
    function DefaultChartHistogramGridLineColor: TColor; override;
    function DefaultChartHistogramPlotColor: TColor; override;
    function DefaultChartPieDiagramSeriesSiteBorderColor: TColor; override;
    function DefaultChartPieDiagramSeriesSiteCaptionColor: TColor; override;
    function DefaultChartPieDiagramSeriesSiteCaptionTextColor: TColor; override;
    function DefaultChartToolBoxDataLevelInfoBorderColor: TColor; override;
    function DefaultChartToolBoxItemSeparatorColor: TColor; override;
    // border
    function BorderSize: Integer; override;
    procedure DrawBorder(ACanvas: TcxCanvas; R: TRect); override;
    procedure DrawContainerBorder(ACanvas: TcxCanvas; const R: TRect; AStyle: TcxContainerBorderStyle;
      AWidth: Integer; AColor: TColor; ABorders: TcxBorders); override;
    // buttons
{$IFNDEF VER23}
    function AdjustGroupButtonDisplayRect(const R: TRect; AButtonCount, AButtonIndex: Integer): TRect; override;
    function ButtonGroupBorderSizes(AButtonCount, AButtonIndex: Integer): TRect; override;
    procedure DrawButtonInGroup(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AButtonCount, AButtonIndex: Integer;
                                ABackgroundColor: TColor); override;
    procedure DrawButtonGroupBorder(ACanvas: TcxCanvas; R: TRect; AInplace, ASelected: Boolean); override;
{$ENDIF}
    function ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function ButtonColor(AState: TcxButtonState): TColor; override;
    function ButtonFocusRect(ACanvas: TcxCanvas; R: TRect): TRect; {$IFNDEF VER17_1_4} override;{$ENDIF}
    function ButtonTextOffset: Integer; {$IFNDEF VER17_1_4} override;{$ENDIF}
    function ButtonTextShift: Integer; {$IFNDEF VER17_1_4} override;{$ENDIF}
    function ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault): TColor; override;
    function ButtonSymbolState(AState: TcxButtonState): TcxButtonState; override;
{$IFDEF VER17_1_4}
    procedure DrawScaledButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState;
      AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True; AColor: TColor = clDefault;
      ATextColor: TColor = clDefault; AWordWrap: Boolean = False; AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton); override;

    procedure DrawScaledExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault{$IFDEF VER18}; AState: TcxExpandButtonState = cebsNormal{$ENDIF}); override;
    function ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledCheckButtonSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
      AChecked: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
      ACheckState: TcxCheckBoxState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState;
      AChecked, AFocused: Boolean; ABrushColor: TColor; AScaleFactor: TdxScaleFactor; AIsDesigning: Boolean = False); override;
    function ScaledRadioButtonSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False; AIsGroup: Boolean = False); override;
    procedure DrawScaledHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); override;
    function ScaledFilterActivateButtonSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    function ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    procedure DrawScaledIndicatorCustomizationMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledScrollBarPart(ACanvas: TcxCanvas; AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    function ScaledSizeGripSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
      const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer; AScaleFactor: TdxScaleFactor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawScaledEditorButton(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition = cxbpRight); override;
    procedure DrawScaledEditorButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition = cxbpRight); override;
    function TrackBarScaledThumbSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize; override;
    function GetScaledSplitterSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledSplitter(ACanvas: TcxCanvas; const ARect: TRect;
      AHighlighted, AClicked, AHorizontal: Boolean; AScaleFactor: TdxScaleFactor); override;
{$ELSE}
    procedure DrawButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState;
      ADrawBorder: Boolean = True; AColor: TColor = clDefault; ATextColor: TColor = clDefault;
      AWordWrap: Boolean = False; AIsToolButton: Boolean = False
      {$IFDEF VER13_2_2}; APart: TcxButtonPart = cxbpButton{$ENDIF}); override;

    procedure DrawExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AColor: TColor = clDefault); override;
    function ExpandButtonSize: Integer; override;
    function CheckButtonSize: TSize; override;
    procedure DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean); overload; override;
    procedure DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; ACheckState: TcxCheckBoxState); overload; override;
    procedure DrawRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState; AChecked, AFocused: Boolean;
      ABrushColor: TColor;  AIsDesigning: Boolean = False); override;
    function RadioButtonSize: TSize; override;
    procedure DrawHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
      ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False;
      AIsGroup: Boolean = False); override;
    procedure DrawHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
      ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean); override;
    procedure DrawFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean); override;
    function FilterActivateButtonSize: TPoint; override;
    function FilterCloseButtonSize: TPoint; override;
    procedure DrawIndicatorCustomizationMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor); override;
    procedure DrawScrollBarPart(ACanvas: TcxCanvas; AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState); override;
    function SizeGripSize: TSize; override;
    procedure DrawMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect;
      const AText: string; ANeighbors: TcxNeighbors; const AViewParams: TcxViewParams;
      AArrows: {$IFDEF VER23} TcxArrowDirections {$ELSE} TcxHeaderArrows {$ENDIF}; ASideWidth: Integer; AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawEditorButton(ACanvas: TcxCanvas; const ARect: TRect;
      AButtonKind: TcxEditBtnKind; AState: TcxButtonState; APosition: TcxEditBtnPosition = cxbpRight); override;
{$IFDEF VER14_1_2}
    procedure DrawEditorButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      AButtonKind: TcxEditBtnKind; AState: TcxButtonState; APosition: TcxEditBtnPosition = cxbpRight); override;
{$ENDIF}
    function TrackBarThumbSize(AHorizontal: Boolean): TSize; override;
    function GetSplitterSize(AHorizontal: Boolean): TSize; override;
    procedure DrawSplitter(ACanvas: TcxCanvas; const ARect: TRect; AHighlighted: Boolean; AClicked: Boolean; AHorizontal: Boolean); override;
{$ENDIF}
    procedure DrawButtonBorder(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); override;
    function DrawExpandButtonFirst: Boolean; override;
    function IsButtonHotTrack: Boolean; override;
    function IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean; override;
    // checkbox
    function CheckBorderSize: Integer; override;
{$IFDEF VER12_2_3}
    function CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor; override;
{$ELSE}
    function CheckButtonColor(AState: TcxButtonState): TColor; override;
{$ENDIF}
    // RadioButton
    // header
    procedure DrawHeaderBorder(ACanvas: TcxCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders); override;
    procedure DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect); override;
    procedure DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState); override;
    procedure DrawHeaderControlSectionContent(ACanvas: TcxCanvas; const ABounds,
      ATextAreaBounds: TRect; AState: TcxButtonState; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor); override;
    procedure DrawHeaderControlSectionText(ACanvas: TcxCanvas;
      const ATextAreaBounds: TRect; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
      AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor: TColor); override;
    procedure DrawHeaderSeparator(ACanvas: TcxCanvas; const ABounds: TRect; AIndentSize: Integer; AColor: TColor; AViewParams: TcxViewParams); override;
    function HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders; override;
    function HeaderBorderSize: Integer; override;
    function HeaderBounds(const ABounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders = cxBordersAll): TRect; override;
    function HeaderDrawCellsFirst: Boolean; override;
    function HeaderControlSectionBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function HeaderControlSectionTextAreaBounds(ABounds: TRect; AState: TcxButtonState): TRect; override;
    function HeaderControlSectionContentBounds(const ABounds: TRect; AState: TcxButtonState): TRect; override;
    function IsHeaderHotTrack: Boolean; override;
    // grid
    procedure DrawGroupByBox(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap); override;
    // footer
    function FooterBorders: TcxBorders; override;
    function FooterBorderSize: Integer; override;
    function FooterCellBorderSize: Integer; override;
    function FooterCellOffset: Integer; override;
    function FooterDrawCellsFirst: Boolean; override;
    function FooterSeparatorColor: TColor; override;
    function FooterSeparatorSize: Integer; override;
    procedure DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect); override;
    procedure DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect); override;
    procedure DrawFooterContent(ACanvas: TcxCanvas; const ARect: TRect; const AViewParams: TcxViewParams); override;
    procedure DrawFooterSeparator(ACanvas: TcxCanvas; const R: TRect); override;
    // filter

    procedure DrawFilterPanel(ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: {$IFNDEF VER17_1_4}TBitmap{$ELSE}TGraphic{$ENDIF}); override;
    // popup
    procedure DrawWindowContent(ACanvas: TcxCanvas; const ARect: TRect); override;
    function PopupBorderStyle: TcxPopupBorderStyle; override;
    // tabs
    procedure DrawTab(ACanvas: TcxCanvas; R: TRect; ABorders: TcxBorders;
      const AText: string; AState: TcxButtonState; AVertical: Boolean; AFont: TFont;
      ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False); override;
    procedure DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean); override;
    procedure DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean); override;
    function IsDrawTabImplemented(AVertical: Boolean): Boolean; override;
    function IsTabHotTrack(AVertical: Boolean): Boolean; override;
    function TabBorderSize(AVertical: Boolean): Integer; override;
    // indicator
    function IndicatorDrawItemsFirst: Boolean; override;
    // size grip
    procedure DrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor = clDefault; ACorner: TdxCorner = coBottomRight); override;
    // ms outlook
    procedure CalculateSchedulerNavigationButtonRects(AIsNextButton: Boolean;
      ACollapsed: Boolean; APrevButtonTextSize: TSize; ANextButtonTextSize: TSize;
      var ABounds: TRect; out ATextRect: TRect; out AArrowRect: TRect{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF}); override;
    procedure DrawSchedulerBorder(ACanvas: TcxCanvas; R: TRect); override;
    procedure DrawSchedulerEventProgress(ACanvas: TcxCanvas;
      const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean); override;
    procedure DrawSchedulerNavigationButton(ACanvas: TcxCanvas;
      const ARect: TRect; AIsNextButton: Boolean; AState: TcxButtonState;
      const AText: string; const ATextRect: TRect; const AArrowRect: TRect{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF}); override;
    procedure DrawSchedulerNavigationButtonArrow(ACanvas: TcxCanvas; const ARect: TRect; AIsNextButton: Boolean; AColor: TColor{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF}); override;
    procedure DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean); override;
    function SchedulerEventProgressOffsets: TRect; override;
    procedure SchedulerNavigationButtonSizes(AIsNextButton: Boolean;
      var ABorders: TRect; var AArrowSize: TSize; var AHasTextArea: Boolean{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF}); override;
    // chart view
    function ChartToolBoxDataLevelInfoBorderSize: Integer; override;
    function EditButtonTextOffset: Integer; override;
    function EditButtonSize: TSize; override;
    function EditButtonTextColor: TColor; override;
    function GetContainerBorderColor(AIsHighlightBorder: Boolean): TColor; override;
    // navigator
{$IFNDEF VER23}
    procedure DrawNavigatorGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList;
      AImageIndex: TImageIndex; AButtonIndex: Integer; const AGlyphRect: TRect;
      AEnabled: Boolean; AUserGlyphs: Boolean); override;
    function NavigatorGlyphSize: TSize; override;
{$ENDIF}
    // ProgressBar
    procedure DrawProgressBarBorder(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean); override;
    procedure DrawProgressBarChunk(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean); override;
    function ProgressBarBorderSize(AVertical: Boolean): TRect; override;
    function ProgressBarTextColor: TColor; override;
    // GroupBox
    procedure DrawGroupBoxBackground(ACanvas: TcxCanvas; ABounds: TRect; ARect: TRect); override;
{$IFDEF VER26}
    procedure DrawGroupBoxCaption(ACanvas: TcxCanvas; const ACaptionRect, ATextRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition); override;
{$ELSE}
    procedure DrawGroupBoxCaption(ACanvas: TcxCanvas; ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition); override;
{$ENDIF}
    procedure DrawGroupBoxContent(ACanvas: TcxCanvas; ABorderRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition; ABorders: TcxBorders = cxBordersAll); override;
    function GroupBoxBorderSize(ACaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TRect; override;
    function GroupBoxTextColor (AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor; override;
    function IsGroupBoxTransparent(AIsCaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean; override;
    // Panel
    procedure DrawPanelBackground(ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect;
      AColorFrom: TColor = clDefault; AColorTo: TColor = clDefault); override;
    procedure DrawPanelBorders(ACanvas: TcxCanvas; const ABorderRect: TRect); override;
    procedure DrawPanelCaption(ACanvas: TcxCanvas; const ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition); override;
    procedure DrawPanelContent(ACanvas: TcxCanvas; const ABorderRect: TRect; ABorder: Boolean); override;
    function PanelBorderSize: TRect; override;
    function PanelTextColor: TColor; override;
    // Color Gallery
{$IFDEF VER14_1_2}
    function GetGalleryGroupTextColor: TColor; override;
    procedure DrawGalleryBackground(ACanvas: TcxCanvas; const ABounds: TRect); override;
{$ENDIF}
    // TrackBar
    procedure CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign); override;
    procedure DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect); override;
{$IFDEF VER14_1_2}
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas; const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints); override;
{$ELSE}
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas; const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPointArray); override;
{$ENDIF}
    procedure DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect); override;
    function TrackBarTicksColor(AText: Boolean): TColor; override;
    // BreadcrumbEdit
    function BreadcrumbEditBordersSize: TRect; override;
    function BreadcrumbEditBackgroundColor(AState: TdxBreadcrumbEditState): TColor; override;
    function BreadcrumbEditNodeTextColor(AState: TdxBreadcrumbEditButtonState): TColor; override;
  end;

{$IFDEF VER12_1_6}
  TcxACPCPainter = class(TcxPCTabsPainter)
  protected
    function GetFreeSpaceColor: TColor; override;
    function AlwaysColoredTabs: Boolean; override;
    procedure DrawTabImageAndText(ACanvas: TcxCanvas; ATabVisibleIndex: Integer); override;
    procedure InternalPaintTab(ACanvas: TcxCanvas; ATabVisibleIndex: Integer); override;
    function GetClientColor: TColor; override;
    function GetTabBodyColor(TabVisibleIndex: Integer): TColor; override;
    procedure PaintFrameBorder(ACanvas: TcxCanvas; R: TRect); override;
  public
    class function GetStyleID: TcxPCStyleID; override;
    class function GetStyleName: TCaption; override;
  end;

  {$IFDEF EXPRESSBARS}
  TdxACStatusBarSkinPainter = class(TdxStatusBarPainter)
  public
    class function SeparatorSize{$IFDEF VER17_1_4}(AStatusBar: TdxCustomStatusBar){$ENDIF}: Integer; override;
    class function TopBorderSize: Integer; override;
    class function GripAreaSize{$IFDEF VER17_1_4}(AStatusBar: TdxCustomStatusBar){$ENDIF}: TSize; override;
    class procedure AdjustTextColor(AStatusBar: TdxCustomStatusBar; var AColor: TColor; Active: Boolean); override;
    class procedure DrawPanelBorder(AStatusBar: TdxCustomStatusBar; ABevel: TdxStatusBarPanelBevel; ACanvas: TcxCanvas; var R: TRect); override;
    class procedure DrawPanelSeparator(AStatusBar: TdxCustomStatusBar; ACanvas: TcxCanvas; const R: TRect); override;
    class procedure DrawTopBorder(AStatusBar: TdxCustomStatusBar; ACanvas: TcxCanvas; const R: TRect); override;
    class function GetPanelColor(AStatusBar: TdxCustomStatusBar; APanel: TdxStatusBarPanel): TColor; override;
    class procedure DrawSizeGrip(AStatusBar: TdxCustomStatusBar; ACanvas: TcxCanvas; R: TRect{$IFNDEF VER14_1_2}; AOverlapped: Boolean{$ENDIF}); override;
  end;
  TdxACBarPainter = class(TdxBarFlatPainter);
  {$ENDIF}

{$ENDIF}


implementation

uses
  math, ComCtrls, StdCtrls,
  dxSkinInfo, cxControls,
  sGraphUtils, sSkinProps, acntUtils, sConst, sAlphaGraph, sVCLUtils, sThirdParty, sDefaults, sCommonData;


var
  DefManager: TsSkinManager = nil;


type
  TAccesscxControl = class(TcxControl);


const
  s_AlphaSkins = 'AlphaSkins';
  GetState: array [cxbsDefault..cxbsDisabled] of integer = (0, 0, 1, 2, 0);
  StateValues: array [TcxButtonState] of integer = (1, 0, 1, 2, 0);


procedure Register;
begin
  RegisterComponents('AlphaAdditional', [TsDevExProvider]);
end;


procedure Debugalert(const s: string);
begin
{$IFDEF ACDEBUG}
  Alert(s);
{$ENDIF}
end;


function Skinned(Ctrl: TControl = nil): boolean;
var
  F: TCustomForm;
begin
  Result := False;
  DefManager := DefaultManager;
  if DefManager <> nil then begin
    if Ctrl <> nil then begin
      F := GetParentForm(Ctrl);
      if (F = nil) or not WndIsSkinned(F.Handle) then
        Exit;
    end;
    Result := DefManager.CommonSkinData.Active
  end;
end;


{$IFNDEF VER23}
function TcxACLookAndFeelPainter.AdjustGroupButtonDisplayRect(const R: TRect; AButtonCount, AButtonIndex: Integer): TRect;
begin
  Result := inherited AdjustGroupButtonDisplayRect(R, AButtonCount, AButtonIndex);
end;


function TcxACLookAndFeelPainter.ButtonGroupBorderSizes(AButtonCount, AButtonIndex: Integer): TRect;
begin
  Result := inherited ButtonGroupBorderSizes(AButtonCount, AButtonIndex)
end;


procedure TcxACLookAndFeelPainter.DrawButtonGroupBorder(ACanvas: TcxCanvas; R: TRect; AInplace, ASelected: Boolean);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawButtonInGroup(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AButtonCount, AButtonIndex: Integer; ABackgroundColor: TColor);
var
  i: integer;
  TmpBmp: TBitmap;
  CI: TCacheInfo;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.Sections[ssToolButton];
    if DefaultManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(R);
      CI.Bmp := nil;
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      PaintItem(i, CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
      BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else inherited
end;


procedure TcxACLookAndFeelPainter.DrawNavigatorGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList;
  AImageIndex: TImageIndex; AButtonIndex: Integer; const AGlyphRect: TRect; AEnabled, AUserGlyphs: Boolean);
begin
  inherited;
end;


function TcxACLookAndFeelPainter.NavigatorGlyphSize: TSize;
begin
  Result := cxClasses.Size(10, 12) // inherited NavigatorGlyphSize
end;


{$ENDIF}
function TcxACLookAndFeelPainter.BorderSize: Integer;
begin
  if Skinned then
    Result := 2
  else
    Result := inherited BorderSize;
end;


function TcxACLookAndFeelPainter.BreadcrumbEditBackgroundColor(AState: TdxBreadcrumbEditState): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited BreadcrumbEditBackgroundColor(AState);
end;


function TcxACLookAndFeelPainter.BreadcrumbEditBordersSize: TRect;
begin
  if Skinned then
    Result := MkRect
  else
    Result := inherited BreadcrumbEditBordersSize;
end;


function TcxACLookAndFeelPainter.BreadcrumbEditNodeTextColor(AState: TdxBreadcrumbEditButtonState): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited BreadcrumbEditNodeTextColor(AState);
end;


function TcxACLookAndFeelPainter.ButtonBorderSize(AState: TcxButtonState): Integer;
begin
  if Skinned then
    Result := 4
  else
    Result := inherited ButtonBorderSize(AState)
end;


function TcxACLookAndFeelPainter.ButtonColor(AState: TcxButtonState): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited ButtonColor(AState);
end;


function TcxACLookAndFeelPainter.ButtonFocusRect(ACanvas: TcxCanvas; R: TRect): TRect;
begin
  Result := inherited ButtonFocusRect(ACanvas, R);
end;


function TcxACLookAndFeelPainter.ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor): TColor;
var
  i: integer;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.Sections[ssButton];
    if DefaultManager.IsValidSkinIndex(i) then
      with DefaultManager.gd[i] do
        Result := Props[StateValues[AState]].FontColor.Color
    else
      Result := 0;
  end
  else
    Result := inherited ButtonSymbolColor(AState, ADefaultColor);
end;


function TcxACLookAndFeelPainter.ButtonSymbolState(AState: TcxButtonState): TcxButtonState;
begin
  Result := inherited ButtonSymbolState(AState);
end;


function TcxACLookAndFeelPainter.ButtonTextOffset: Integer;
begin
  Result := inherited ButtonTextOffset;
end;


function TcxACLookAndFeelPainter.ButtonTextShift: Integer;
begin
  Result := inherited ButtonTextShift
end;


procedure TcxACLookAndFeelPainter.CalculateSchedulerNavigationButtonRects(
  AIsNextButton, ACollapsed: Boolean; APrevButtonTextSize, ANextButtonTextSize: TSize; var ABounds: TRect;
  out ATextRect, AArrowRect: TRect{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF});
begin
  inherited CalculateSchedulerNavigationButtonRects(AIsNextButton, ACollapsed, APrevButtonTextSize, ANextButtonTextSize, ABounds, ATextRect, AArrowRect);
end;


function TcxACLookAndFeelPainter.ChartToolBoxDataLevelInfoBorderSize: Integer;
begin
  Result := inherited ChartToolBoxDataLevelInfoBorderSize;
end;


function TcxACLookAndFeelPainter.CheckBorderSize: Integer;
begin
  if Skinned then
    Result := 0
  else
    Result := inherited CheckBorderSize;
end;


{$IFDEF VER12_2_3}
function TcxACLookAndFeelPainter.CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited CheckButtonColor(AState, ACheckState);
end;
{$ELSE}
function TcxACLookAndFeelPainter.CheckButtonColor(AState: TcxButtonState): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited CheckButtonColor(AState);
end;
{$ENDIF}


{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.ScaledCheckButtonSize(AScaleFactor: TdxScaleFactor): TSize;
{$ELSE}
function TcxACLookAndFeelPainter.CheckButtonSize: TSize;
{$ENDIF}
var
  Ndx: integer;
begin
  if Skinned then begin
    if DefaultManager.CommonSkinData.SmallCheckBox[cbChecked] >= 0 then
      Ndx := DefaultManager.CommonSkinData.SmallCheckBox[cbChecked]
    else
      Ndx := DefaultManager.CommonSkinData.CheckBox[cbChecked];

    if Ndx >= 0 then
      Result := MkSize(DefaultManager.ma[Ndx])
    else
      Result := inherited;
  end
  else
    Result := inherited;
end;


function TcxACLookAndFeelPainter.DefaultSizeGripAreaColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetActiveEditColor
  else
    Result := inherited DefaultSizeGripAreaColor
end;


function TcxACLookAndFeelPainter.DefaultVGridCategoryColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultVGridCategoryColor;
end;


function TcxACLookAndFeelPainter.DefaultVGridCategoryTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultVGridCategoryTextColor;
end;


function TcxACLookAndFeelPainter.DefaultVGridLineColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, 77)
  else
    Result := inherited DefaultVGridLineColor;
end;


function TcxACLookAndFeelPainter.DefaultVGridBandLineColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, 77)
  else
    Result := inherited DefaultVGridBandLineColor;
end;


function TcxACLookAndFeelPainter.DefaultContentColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetGlobalColor, 127)
  else
    Result := inherited DefaultContentColor;
end;


function TcxACLookAndFeelPainter.DefaultContentEvenColor: TColor;
begin
  Result := DefaultManager.Palette[pcEditBG_EvenRow];
end;


function TcxACLookAndFeelPainter.DefaultContentOddColor: TColor;
begin
  Result := DefaultManager.Palette[pcEditBG_OddRow];
end;


function TcxACLookAndFeelPainter.DefaultContentTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.Palette[pcEditText]
  else
    Result := inherited DefaultContentTextColor;
end;


function TcxACLookAndFeelPainter.DefaultDateNavigatorHeaderColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultDateNavigatorHeaderColor;
end;


function TcxACLookAndFeelPainter.DefaultDateNavigatorSelectionColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetHighLightColor
  else
    Result := inherited DefaultDateNavigatorSelectionColor;
end;


function TcxACLookAndFeelPainter.DefaultDateNavigatorSelectionTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetHighLightFontColor
  else
    Result := inherited DefaultDateNavigatorSelectionTextColor;
end;


function TcxACLookAndFeelPainter.DefaultDateNavigatorTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultDateNavigatorTextColor;
end;


function TcxACLookAndFeelPainter.DefaultDateNavigatorTodayTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultDateNavigatorTextColor;
end;


function TcxACLookAndFeelPainter.DefaultEditorBackgroundColor(AIsDisabled: Boolean): TColor;
begin
  if Skinned then
    if AIsDisabled then
      Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetGlobalColor, 127)
    else
      Result := DefaultManager.GetActiveEditColor
  else
    Result := inherited DefaultEditorBackgroundColor(AIsDisabled);
end;


function TcxACLookAndFeelPainter.DefaultEditorBackgroundColorEx(AKind: TcxEditStateColorKind): TColor;
begin
  if Skinned then
    case AKind of
      esckDisabled:
        Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetGlobalColor, DefBlendDisabled)
      else
        Result := DefaultManager.GetActiveEditColor
    end
  else
    Result := inherited DefaultEditorBackgroundColorEx(AKind);
end;


function TcxACLookAndFeelPainter.DefaultEditorTextColor(AIsDisabled: Boolean): TColor;
begin
  if Skinned then
    if AIsDisabled then
      Result := BlendColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, DefBlendDisabled)
    else
      Result := DefaultManager.GetActiveEditFontColor
  else
    Result := inherited DefaultEditorTextColor(AIsDisabled);
end;


function TcxACLookAndFeelPainter.DefaultEditorTextColorEx(AKind: TcxEditStateColorKind): TColor;
begin
  if Skinned then
    case AKind of
      esckDisabled:
        Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, DefBlendDisabled)
      else
        Result := DefaultManager.GetActiveEditFontColor
    end
  else
    Result := inherited DefaultEditorTextColorEx(AKind);
end;


function TcxACLookAndFeelPainter.DefaultSchedulerBackgroundColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultSchedulerBackgroundColor;
end;


function TcxACLookAndFeelPainter.DefaultSchedulerTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultSchedulerTextColor;
end;


function TcxACLookAndFeelPainter.DefaultSchedulerBorderColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.Palette[pcBorder]
  else
    Result := inherited DefaultSchedulerBorderColor;
end;


function TcxACLookAndFeelPainter.DefaultSchedulerControlColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultSchedulerControlColor;
end;


function TcxACLookAndFeelPainter.DefaultSchedulerNavigatorColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultSchedulerNavigatorColor;
end;


function TcxACLookAndFeelPainter.DefaultSchedulerViewContentColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetGlobalColor, 127)
  else
    Result := inherited DefaultSchedulerViewContentColor;
end;


function TcxACLookAndFeelPainter.DefaultSchedulerViewSelectedTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetHighLightFontColor
  else
    Result := inherited DefaultSchedulerViewSelectedTextColor;
end;


function TcxACLookAndFeelPainter.DefaultSchedulerViewTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetActiveEditFontColor
  else
    Result := inherited DefaultSchedulerViewTextColor;
end;


function TcxACLookAndFeelPainter.DefaultSelectionColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetHighLightColor
  else
    Result := inherited DefaultSelectionColor;
end;


function TcxACLookAndFeelPainter.DefaultSelectionTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetHighLightFontColor
  else
    Result := inherited DefaultSelectionTextColor;
end;


function TcxACLookAndFeelPainter.DefaultSeparatorColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultSeparatorColor;
end;


function TcxACLookAndFeelPainter.DefaultFilterBoxColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultFilterBoxColor
end;


function TcxACLookAndFeelPainter.DefaultFilterBoxTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultFilterBoxTextColor
end;


function TcxACLookAndFeelPainter.DefaultFixedSeparatorColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.Palette[pcMainColor], DefaultManager.Palette[pcLabelText], 204)
  else
    Result := inherited DefaultFixedSeparatorColor;
end;


function TcxACLookAndFeelPainter.DefaultFooterColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultFooterColor
end;


function TcxACLookAndFeelPainter.DefaultFooterTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetActiveEditFontColor
  else
    Result := inherited DefaultFooterTextColor
end;


function TcxACLookAndFeelPainter.DefaultGridDetailsSiteColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultGridDetailsSiteColor;
end;


function TcxACLookAndFeelPainter.DefaultGridLineColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.Palette[pcGrid]
  else
    Result := inherited DefaultGridLineColor;
end;


function TcxACLookAndFeelPainter.DefaultGroupByBoxColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultGroupByBoxColor
end;


function TcxACLookAndFeelPainter.DefaultHeaderTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetActiveEditFontColor
  else
    Result := inherited DefaultHeaderTextColor;
end;


function TcxACLookAndFeelPainter.DefaultHyperlinkTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.Palette[pcWebText]
  else
    Result := inherited DefaultHyperlinkTextColor;
end;


function TcxACLookAndFeelPainter.DefaultGroupByBoxTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultGroupByBoxTextColor
end;


function TcxACLookAndFeelPainter.DefaultGroupColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultGroupColor;
end;


function TcxACLookAndFeelPainter.DefaultGroupTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultGroupTextColor
end;


function TcxACLookAndFeelPainter.DefaultHeaderBackgroundColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultHeaderBackgroundColor
end;


function TcxACLookAndFeelPainter.DefaultHeaderBackgroundTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultHeaderBackgroundTextColor;
end;


function TcxACLookAndFeelPainter.DefaultHeaderColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultHeaderColor
end;


function TcxACLookAndFeelPainter.DefaultInactiveColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetHighLightColor(False)
  else
    Result := inherited DefaultInactiveColor
end;


function TcxACLookAndFeelPainter.DefaultInactiveTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetHighLightFontColor(False)
  else
    Result := inherited DefaultInactiveTextColor;
end;


function TcxACLookAndFeelPainter.DefaultPreviewTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultPreviewTextColor;
end;


function TcxACLookAndFeelPainter.DefaultRecordSeparatorColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultRecordSeparatorColor;
end;


function TcxACLookAndFeelPainter.DefaultTabColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultTabColor
end;


function TcxACLookAndFeelPainter.DefaultTabTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultTabTextColor;
end;


function TcxACLookAndFeelPainter.DefaultTabsBackgroundColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultTabsBackgroundColor
end;


function TcxACLookAndFeelPainter.DefaultChartDiagramValueBorderColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 51)
  else
    Result := inherited DefaultChartDiagramValueBorderColor;
end;


function TcxACLookAndFeelPainter.DefaultChartDiagramValueCaptionTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetActiveEditFontColor
  else
    Result := inherited DefaultChartDiagramValueCaptionTextColor;
end;


function TcxACLookAndFeelPainter.DefaultChartHistogramAxisColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 77)
  else
    Result := inherited DefaultChartHistogramAxisColor;
end;


function TcxACLookAndFeelPainter.DefaultChartHistogramGridLineColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 204)
  else
    Result := inherited DefaultChartHistogramGridLineColor;
end;


function TcxACLookAndFeelPainter.DefaultChartHistogramPlotColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetActiveEditColor
  else
    Result := inherited DefaultChartHistogramPlotColor;
end;


function TcxACLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteBorderColor: TColor;
begin
  if Skinned then
    Result := clNavy
  else
    Result := inherited DefaultChartPieDiagramSeriesSiteBorderColor;
end;


function TcxACLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteCaptionColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited DefaultChartPieDiagramSeriesSiteCaptionColor;
end;


function TcxACLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteCaptionTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultChartPieDiagramSeriesSiteCaptionTextColor;
end;


function TcxACLookAndFeelPainter.DefaultChartToolBoxDataLevelInfoBorderColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 127)
  else
    Result := inherited DefaultChartToolBoxDataLevelInfoBorderColor;
end;


function TcxACLookAndFeelPainter.DefaultChartToolBoxItemSeparatorColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 204)
  else
    Result := inherited DefaultChartToolBoxItemSeparatorColor;
end;


function TcxACLookAndFeelPainter.DefaultTimeGridMajorScaleColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetGlobalColor, DefaultManager.GetActiveEditColor, 127)
  else
    Result := inherited DefaultTimeGridMajorScaleColor
end;


function TcxACLookAndFeelPainter.DefaultTimeGridMajorScaleTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultTimeGridMajorScaleTextColor
end;


function TcxACLookAndFeelPainter.DefaultTimeGridMinorScaleColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetGlobalColor, DefaultManager.GetActiveEditColor, 230)
  else
    Result := inherited DefaultTimeGridMinorScaleColor
end;


function TcxACLookAndFeelPainter.DefaultTimeGridMinorScaleTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited DefaultTimeGridMinorScaleTextColor
end;


function TcxACLookAndFeelPainter.DefaultTimeGridSelectionBarColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetGlobalColor, DefaultManager.GetActiveEditColor, 127)
  else
    Result := inherited DefaultTimeGridSelectionBarColor
end;


procedure TcxACLookAndFeelPainter.DrawBorder(ACanvas: TcxCanvas; R: TRect);
var
  m: integer;
  Bmp: TBitmap;
begin
  if Skinned then begin
    if DefaultManager.CommonSkinData.Sections[ssEdit] >= 0 then begin
      m := DefaultManager.gd[DefaultManager.CommonSkinData.Sections[ssEdit]].BorderIndex;
      if DefaultManager.IsValidImgIndex(m) then begin
        Bmp := CreateBmp32(R);
        PaintSection(Bmp, s_Edit, s_Edit, 0, DefaultManager.CommonSkinData, R.TopLeft, DefaultManager.GetGlobalColor);
        BitBltBorder(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom, Bmp.Canvas.Handle, 0, 0, 3);
        FreeAndNil(Bmp);
      end;
    end;
  end
  else
    inherited DrawBorder(ACanvas, R)
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState;
      AScaleFactor: cxGeometry.TdxScaleFactor; ADrawBorder: Boolean = True; AColor: TColor = clDefault;
      ATextColor: TColor = clDefault; AWordWrap: Boolean = False; AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState;
      ADrawBorder: Boolean = True; AColor: TColor = clDefault; ATextColor: TColor = clDefault;
      AWordWrap: Boolean = False; AIsToolButton: Boolean = False
      {$IFDEF VER13_2_2}; APart: TcxButtonPart = cxbpButton{$ENDIF});
{$ENDIF}
var
  State, i: integer;
  TmpBmp: TBitmap;
  CI: TCacheInfo;
  rText: TRect;
{$IFDEF VER13_2_2}
  C: TColor;
{$ENDIF}
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.Sections[ssButton];
    if DefaultManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(R);
      CI.Bmp := nil;
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      PaintItem(i, CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
      ACanvas.Font.Color := DefaultManager.gd[i].Props[StateValues[AState]].FontColor.Color;
      if ACaption <> '' then begin
        TmpBmp.Canvas.Font.Color := ACanvas.Font.Color;
        TmpBmp.Canvas.Brush.Style := bsClear;
        rText := MkRect(TmpBmp);
        DrawText(TmpBmp.Canvas.Handle, PChar(ACaption), Length(ACaption), rText, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_SINGLELINE);
      end;
{$IFDEF VER13_2_2}
      if APart = cxbpDropDownRightPart then begin
        State := mini(StateValues[AState], ac_MaxPropsIndex);
        if i >= 0 then
          C := DefaultManager.gd[i].Props[State].FontColor.Color
        else
          C := ColorToRGB(clWindowText);

        sGraphUtils.DrawArrow(TmpBmp, C, clNone, MkRect(TmpBmp), asBottom, 0, 0, 0, DefaultManager.Options.ActualArrowStyle);
      end;
{$ENDIF}
      if cxbsDisabled = AState then
        BlendTransBitmap(TmpBmp, DefBlendDisabled, TsColor(CI.FillColor));

      BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawButtonBorder(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin
  if not Skinned then
    inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; ACheckState: TcxCheckBoxState; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; ACheckState: TcxCheckBoxState);
{$ENDIF}
var
  State, i: integer;
  TmpBmp: TBitmap;
  Size: TSize;
  C: TsColor;
begin
  if Skinned then begin
    i := -1;
    with DefaultManager.CommonSkinData do
      case ACheckState of
        cbsUnchecked:
          if SmallCheckBox[cbUnChecked] >= 0 then
            i := SmallCheckBox[cbUnChecked]
          else
            i := CheckBox[cbUnChecked];

        cbsChecked:
          if SmallCheckBox[cbChecked] >= 0 then
            i := SmallCheckBox[cbChecked]
          else
            i := CheckBox[cbChecked];

        cbsGrayed:
          if SmallCheckBox[cbGrayed] >= 0 then
            i := SmallCheckBox[cbGrayed]
          else
            i := CheckBox[cbGrayed];
      end;

    if DefaultManager.IsValidImgIndex(i) then begin
      Size := MkSize(DefaultManager.ma[i]);
      TmpBmp := CreateBmp32(Size);
      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Size.cx, Size.cy, ACanvas.Handle, R.Left, R.Top, SRCCOPY);
      State := StateValues[AState];
      if State >= DefaultManager.ma[i].ImageCount then
        State := DefaultManager.ma[i].ImageCount - 1;

      DrawSkinGlyph(TmpBmp, MkPoint, State, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      if cxbsDisabled = AState then begin
        C.C := DefaultManager.GetGlobalColor;
        BlendTransBitmap(TmpBmp, DefBlendDisabled, C);
      end;

      BitBlt(ACanvas.Handle, R.Left, R.Top, Size.cx, Size.cy, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawContainerBorder(ACanvas: TcxCanvas;
  const R: TRect; AStyle: TcxContainerBorderStyle; AWidth: Integer; AColor: TColor; ABorders: TcxBorders);
var
  m: integer;
  Bmp: TBitmap;
begin
  if Skinned and (AStyle = cbs3D) then begin
    if DefaultManager.CommonSkinData.Sections[ssEdit] >= 0 then begin
      m := DefaultManager.gd[DefaultManager.CommonSkinData.Sections[ssEdit]].BorderIndex;
      if DefaultManager.IsValidImgIndex(m) then begin
        Bmp := CreateBmp32(R);
        PaintSection(Bmp, s_Edit, s_Edit, 0, DefaultManager.CommonSkinData, R.TopLeft, DefaultManager.GetGlobalColor);
        BitBltBorder(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom, Bmp.Canvas.Handle, 0, 0, 2);
        FreeAndNil(Bmp);
      end;
    end;
  end
  else
    inherited
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledEditorButton(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition = cxbpRight);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawEditorButton(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind; AState: TcxButtonState; APosition: TcxEditBtnPosition = cxbpRight);
{$ENDIF}
var
  w, h, sIndex, glIndex, State: integer;
  TmpBmp: TBitmap;
  CI: TCacheInfo;
  R: TRect;
  s: string;
  Side: TacSide;
{$IFNDEF VER14_1_2}
  C: TColor;
{$ENDIF}
begin
  if Skinned then begin
    w := WidthOf(ARect);
    h := HeightOf(ARect);
    glIndex := -1;
    case AButtonKind of
      cxbkSpinUpBtn: begin
        if w < h then
          Side := asRight
        else
          Side := asTop;

        sIndex := DefaultManager.CommonSkinData.UpDownBtns[Side].SkinIndex;
      end;

      cxbkSpinDownBtn: begin
        if w < h then
          Side := asLeft
        else
          Side := asBottom;

        sIndex := DefaultManager.CommonSkinData.UpDownBtns[Side].SkinIndex;
      end

      else begin
        sIndex := DefaultManager.CommonSkinData.Sections[ssUpDown];
{$IFNDEF VER14_1_2}
        Side := asBottom;
{$ENDIF}
      end;
    end;
    if sIndex < 0 then
      sIndex := DefaultManager.CommonSkinData.Sections[ssButton];

    R := ARect;
    TmpBmp := CreateBmp32(R);
    CI.Bmp := nil;
    CI.Ready := False;
    CI.FillColor := DefaultManager.GetActiveEditColor;
    if DefaultManager.IsValidSkinIndex(sIndex) then
      PaintItem(sIndex, CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData)
    else
      FillDC(TmpBmp.Canvas.Handle, MkRect(TmpBmp), CI.FillColor);

    case AButtonKind of
{$IFNDEF VER14_1_2}
{      cxbkSpinUpBtn,
      cxbkSpinDownBtn,
      cxbkSpinLeftBtn,
      cxbkSpinRightBtn: glIndex := DefaultManager.CommonSkinData.ScrollBtns[Side].GlyphIndex;}
      cxbkComboBtn:     glIndex := DefaultManager.CommonSkinData.ComboBtn.GlyphIndex;
{$ENDIF}
      cxbkCloseBtn:     s := 'X';
      cxbkEditorBtn:    s := '';
      cxbkEllipsisBtn:  s := s_Ellipsis;
    end;
    if glIndex >= 0 then
      DrawSkinGlyph(TmpBmp, Point((WidthOf(R) - DefaultManager.ma[glIndex].Width) div 2,
        (HeightOf(R) - DefaultManager.ma[glIndex].Height) div 2), StateValues[AState], 1, DefaultManager.ma[glIndex], MakeCacheInfo(TmpBmp))
    else
      case AButtonKind of
        cxbkCloseBtn, cxbkEllipsisBtn: begin
          State := mini(StateValues[AState], ac_MaxPropsIndex);
          if (sIndex >= 0) and (DefaultManager.gd[sIndex].Props[State].Transparency < 80) then
            TmpBmp.Canvas.Font.Color := DefaultManager.gd[sIndex].Props[State].FontColor.Color
          else
            TmpBmp.Canvas.Font.Color := DefaultManager.GetActiveEditFontColor;

          TmpBmp.Canvas.Font.Style := [fsBold];
          TmpBmp.Canvas.Brush.Style := bsClear;
          R := MkRect(TmpBmp);
          DrawText(TmpBmp.Canvas.Handle, PChar(s), Length(s), R, DT_VCENTER + DT_CENTER + DT_SINGLELINE);
        end;

{$IFNDEF VER14_1_2}
        cxbkSpinUpBtn, cxbkSpinDownBtn, cxbkComboBtn: begin
          R := MkRect(TmpBmp);
          State := mini(StateValues[AState], ac_MaxPropsIndex);
          if (sIndex >= 0) and (DefaultManager.gd[sIndex].Props[State].Transparency < 80) then
            C := DefaultManager.gd[sIndex].Props[State].FontColor.Color
          else
            C := DefaultManager.GetActiveEditFontColor;

          if AButtonKind = cxbkSpinUpBtn then
            sGraphUtils.DrawArrow(TmpBmp, C, clNone, R, asTop, 0, 0, 0, DefaultManager.Options.ActualArrowStyle)
          else
            sGraphUtils.DrawArrow(TmpBmp, C, clNone, R, asBottom, 0, 0, 0, DefaultManager.Options.ActualArrowStyle);
        end;
{$ENDIF}
      end;

    BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    FreeAndNil(TmpBmp);
  end
  else
    inherited;
end;


{$IFDEF VER14_1_2}
{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledEditorButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition = cxbpRight);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawEditorButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind; AState: TcxButtonState; APosition: TcxEditBtnPosition);
{$ENDIF}
var
  TmpBmp: TBitmap;
  R: TRect;
  C: TColor;
  Side: TacSide;
  h, w, Offset, glIndex, sIndex, State: integer;
begin
  if Skinned then begin
    w := WidthOf(ARect);
    h := HeightOf(ARect);
    glIndex := -1;
    case AButtonKind of
      cxbkSpinUpBtn: begin
        if w < h then
          Side := asRight
        else
          Side := asTop;

        sIndex := DefaultManager.CommonSkinData.UpDownBtns[Side].SkinIndex;
      end;

      cxbkSpinDownBtn: begin
        if w < h then
          Side := asLeft
        else
          Side := asBottom;

        sIndex := DefaultManager.CommonSkinData.UpDownBtns[Side].SkinIndex;
      end;

      cxbkComboBtn: begin
        sIndex := DefaultManager.CommonSkinData.ComboBtn.SkinIndex;
        glIndex := DefaultManager.CommonSkinData.ComboBtn.GlyphIndex;
        Side := asBottom;
        if sIndex < 0 then
          sIndex := DefaultManager.CommonSkinData.Sections[ssUpDown];
      end

      else
        Exit;
    end;
    if sIndex < 0 then
      sIndex := DefaultManager.CommonSkinData.Sections[ssButton];

    Offset := 0;
    case AState of
      cxbsPressed: begin
        State := 2;
        Offset := 1;
      end;
      cxbsHot:
        State := 1
      else
        State := 0;
    end;

    State := mini(State, ac_MaxPropsIndex);
    C := DefaultManager.gd[sIndex].Props[State].FontColor.Color;

    TmpBmp := CreateBmp32(ARect);
    BitBlt(TmpBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, ARect.Left, ARect.Top, SRCCOPY);
    R := MkRect(TmpBmp);
    if glIndex >= 0 then
      DrawSkinGlyph(TmpBmp,
                    Point((WidthOf(R)  - DefaultManager.ma[glIndex].Width) div 2,
                          (HeightOf(R) - DefaultManager.ma[glIndex].Height) div 2),
                    State, 1, DefaultManager.ma[glIndex], MakeCacheInfo(TmpBmp))
    else
      sGraphUtils.DrawArrow(TmpBmp, C, clNone, R, Side, 0, 0, 0, DefaultManager.Options.ActualArrowStyle);

    BitBlt(ACanvas.Handle, ARect.Left + Offset, ARect.Top + Offset, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    FreeAndNil(TmpBmp);
  end
  else
    inherited;
end;
{$ENDIF}


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault{$IFDEF VER18}; AState: TcxExpandButtonState = cebsNormal{$ENDIF});
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AColor: TColor);
{$ENDIF}
var
  ARect: TRect;
begin
  if Skinned then begin
    ARect := R;
{$IFDEF VER17_1_4}
    DrawScaledButton(ACanvas, ARect, '', cxbsNormal, AScaleFactor, True, AColor);
{$ELSE}
    DrawButton(ACanvas, ARect, '', cxbsNormal, True, AColor);
{$ENDIF}
    InflateRect(ARect, -1, -1);
    DrawExpandButtonCross(ACanvas, ARect, AExpanded, DefaultManager.GetGlobalFontColor{$IFDEF VER17_1_4}, AScaleFactor{$ENDIF});
    ACanvas.ExcludeClipRect(R);
  end
  else
    inherited;
end;


function TcxACLookAndFeelPainter.DrawExpandButtonFirst: Boolean;
begin
  Result := inherited DrawExpandButtonFirst;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean);
{$ENDIF}
var
  State, i, NewLeft, NewTop: integer;
  TmpBmp: TBitmap;
  Size: TSize;
begin
  if Skinned then begin
    if AChecked then
      i := DefaultManager.CommonSkinData.SmallCheckBox[cbChecked]
    else
      i := DefaultManager.CommonSkinData.SmallCheckBox[cbUnChecked];

    if DefaultManager.IsValidImgIndex(i) then begin
      Size := MkSize(DefaultManager.ma[i]);
      TmpBmp := CreateBmp32(Size);
      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Size.cx, Size.cy, ACanvas.Handle, R.Left, R.Top, SRCCOPY);
      State := StateValues[AState];
      if State >= DefaultManager.ma[i].ImageCount then
        State := DefaultManager.ma[i].ImageCount - 1;

      NewLeft := (WidthOf(R) - Size.cx) div 2;
      Newtop := (HeightOf(R) - Size.cy) div 2;
      DrawSkinGlyph(TmpBmp, Point(NewLeft, NewTop), State, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      BitBlt(ACanvas.Handle, R.Left, R.Top, Size.cx, Size.cy, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else
    inherited
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState; AChecked, AFocused: Boolean; ABrushColor: TColor; AScaleFactor: TdxScaleFactor; AIsDesigning: Boolean = False);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState; AChecked, AFocused: Boolean; ABrushColor: TColor;  AIsDesigning: Boolean = False);
{$ENDIF}
var
  State, i: integer;
  TmpBmp: TBitmap;
  Size: TSize;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.RadioButton[AChecked];
    if DefaultManager.IsValidImgIndex(i) then begin
      Size := MkSize(DefaultManager.ma[i]);
      TmpBmp := CreateBmp32(Size);
      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Size.cx, Size.cy, ACanvas.Handle, X, Y, SRCCOPY);
      State := StateValues[AButtonState];
      if State >= DefaultManager.ma[i].ImageCount then
        State := DefaultManager.ma[i].ImageCount - 1;

      DrawSkinGlyph(TmpBmp, MkPoint, State, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      BitBlt(ACanvas.Handle, X, Y, Size.cx, Size.cy, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else
    inherited;
end;


{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.ScaledRadioButtonSize(AScaleFactor: TdxScaleFactor): TSize;
{$ELSE}
function TcxACLookAndFeelPainter.RadioButtonSize: TSize;
{$ENDIF}
var
  i: integer;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.RadioButton[True];
    if DefaultManager.IsValidImgIndex(i) then
      Result := MkSize(DefaultManager.ma[i])
    else
      Result := inherited;
  end
  else
    Result := inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
{$ENDIF}
var
  i: integer;
  TmpBmp: TBitmap;
  CI: TCacheInfo;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.TitleGlyphs[tgSmallClose];
    if i < 0 then
      i := DefaultManager.CommonSkinData.TitleGlyphs[tgClose];

    if DefaultManager.IsValidImgIndex(i) then begin
      TmpBmp := CreateBmp32(R);
      FillDC(TmpBmp.Canvas.Handle, MkRect(TmpBmp), DefaultManager.GetGlobalColor);
      CI := MakeCacheInfo(TmpBmp);
      DrawSkinGlyph(TmpBmp, MkPoint, StateValues[AState], 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else
    inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean);
{$ENDIF}
var
  i, State: integer;
  CI: TCacheInfo;
  TmpBmp: TBitmap;
  sSection: string;
begin
  if Skinned then begin
    i := DefManager.CommonSkinData.Sections[ssUpDown];
    if not DefManager.IsValidSkinIndex(i) then begin
      i := DefManager.CommonSkinData.Sections[ssButton];
      sSection := s_Button;
    end
    else
      sSection := s_UpDown;

    if DefManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(R);
      BitBlt(TmpBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, R.Left, R.Top, SRCCOPY);

      CI := MakeCacheInfo(TmpBmp);
      PaintItem(i, CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefManager.CommonSkinData);
      State := mini(StateValues[AState], ac_MaxPropsIndex);
      sGraphUtils.DrawArrow(TmpBmp, DefManager.gd[i].Props[State].FontColor.Color, clNone, MkRect(TmpBmp), asBottom, 0, 0, 0, DefaultManager.Options.ActualArrowStyle);
      BitBlt(aCanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawFilterPanel(ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: {$IFNDEF VER17_1_4}TBitmap{$ELSE}TGraphic{$ENDIF});
begin
  ABackgroundColor := DefaultManager.GetGlobalColor;
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect);
begin
  if Skinned then
    ACanvas.FrameRect(R, DefaultManager.Palette[pcBorder], 1)
  else
    inherited DrawFooterBorder(ACanvas, R)
end;


procedure TcxACLookAndFeelPainter.DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect);
begin
  if Skinned then
    ACanvas.FrameRect(R, DefaultManager.GetGlobalColor, 1)
  else
    inherited DrawFooterBorder(ACanvas, R)
end;


procedure TcxACLookAndFeelPainter.DrawFooterContent(ACanvas: TcxCanvas; const ARect: TRect; const AViewParams: TcxViewParams);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawFooterSeparator(ACanvas: TcxCanvas; const R: TRect);
begin
  if Skinned then
    ACanvas.FillRect(R, DefaultManager.GetGlobalColor)
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawGroupBoxBackground(ACanvas: TcxCanvas; ABounds, ARect: TRect);
begin
  inherited;
end;


{$IFDEF VER26}
procedure TcxACLookAndFeelPainter.DrawGroupBoxCaption(ACanvas: TcxCanvas; const ACaptionRect, ATextRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawGroupBoxCaption(ACanvas: TcxCanvas; ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition);
{$ENDIF}
var
  aBord: TcxBorders;
begin
  if Skinned then begin
    aBord := cxBordersAll;
    case ACaptionPosition of
      cxgpTop, cxgpCenter: aBord := aBord - [bBottom];
      cxgpBottom:          aBord := aBord - [bTop];
      cxgpLeft:            aBord := aBord - [bRight];
      cxgpRight:           aBord := aBord - [bLeft];
    end;
    ACanvas.FillRect(ACaptionRect, BlendColors(DefaultManager.GetGlobalColor, DefaultManager.Palette[pcBorder], 178));
    ACanvas.FrameRect(ACaptionRect, DefaultManager.Palette[pcBorder], 1, aBord);
    ACanvas.FrameRect(ACaptionRect, BlendColors(DefaultManager.GetGlobalColor, DefaultManager.Palette[pcBorder], 102), 1, cxBordersAll - aBord);
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawGroupBoxContent(ACanvas: TcxCanvas; ABorderRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition; ABorders: TcxBorders = cxBordersAll);
var
  aBord: TcxBorders;
begin
  if Skinned then begin
    aBord := cxBordersAll;
    case ACaptionPosition of
      cxgpTop, cxgpCenter: aBord := aBord - [bTop];
      cxgpBottom:          aBord := aBord - [bBottom];
      cxgpLeft:            aBord := aBord - [bLeft];
      cxgpRight:           aBord := aBord - [bRight];
    end;
    ACanvas.FillRect(ABorderRect, DefaultManager.GetGlobalColor);
    ACanvas.FrameRect(ABorderRect, DefaultManager.Palette[pcBorder], 1, aBord);
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawGroupByBox(ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap);
begin
  ABackgroundColor := DefaultManager.GetGlobalColor;
  inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False; AIsGroup: Boolean = False);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawHeader;
{$ENDIF}
const
  AlignmentsHorz: array [TAlignment]       of Integer = (cxAlignLeft, cxAlignRight, cxAlignHCenter);
  AlignmentsVert: array [TcxAlignmentVert] of Integer = (cxAlignTop, cxAlignBottom, cxAlignVCenter);
  MultiLines: array [Boolean] of Integer = (cxSingleLine, cxWordBreak);
  ShowEndEllipsises: array [Boolean] of Integer = (0, cxShowEndEllipsis);
var
  Section: string;
  TmpBmp: TBitmap;
  i, State: integer;
begin
  if Skinned then begin
    if AState in [cxbsDefault, cxbsNormal, cxbsHot, cxbsPressed] then begin
      Section := s_ColHeader;
      AOnDrawBackground := nil;

      TmpBmp := CreateBmp32(ABounds);
      i := PaintSection(TmpBmp, s_ColHeader, s_Button, StateValues[AState], DefaultManager.CommonSkinData, ABounds.TopLeft, DefaultManager.GetGlobalColor);
      BitBlt(ACanvas.Handle, ABounds.Left, ABounds.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndnil(TmpBmp);

      if AFont <> nil then
        ACanvas.Font.Assign(AFont);

      if i >= 0 then begin
        State := mini(StateValues[AState], ac_MaxPropsIndex);
        ACanvas.Font.Color := DefaultManager.gd[i].Props[State].FontColor.Color;
      end;

      ACanvas.Brush.Style := bsClear;
      ACanvas.DrawText(AText, ATextAreaBounds, AlignmentsHorz[AAlignmentHorz] or
          AlignmentsVert[AAlignmentVert] or MultiLines[AMultiLine] or ShowEndEllipsises[AShowEndEllipsis]);
    end;
  end
  else
    inherited
end;


procedure TcxACLookAndFeelPainter.DrawHeaderBorder(ACanvas: TcxCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders);
begin
  if not Skinned then
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState);
var
  Section: string;
  aBmp: TBitmap;
begin
  if Skinned then begin
    if AState in [cxbsDefault, cxbsNormal, cxbsHot, cxbsPressed] then begin
      Section := s_ColHeader;
      if (WidthOf(R, True) > 0) and (HeightOf(R, True) > 0) then begin
        aBmp := CreateBmp32(R);
        PaintSection(aBmp, s_ColHeader, s_Button, StateValues[AState], DefaultManager.CommonSkinData, R.TopLeft, DefaultManager.GetGlobalColor);
        BitBlt(ACanvas.Handle, R.Left, R.Top, aBmp.Width, aBmp.Height, aBmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndnil(aBmp);
      end;
    end;
  end
  else
    inherited DrawHeaderControlSectionBorder(ACanvas, R, ABorders, AState)
end;


procedure TcxACLookAndFeelPainter.DrawHeaderControlSectionContent(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor);
const
  AlignmentsHorz: array [TAlignment] of Integer = (cxAlignLeft, cxAlignRight, cxAlignHCenter);
  AlignmentsVert: array [TcxAlignmentVert] of Integer = (cxAlignTop, cxAlignBottom, cxAlignVCenter);
  MultiLines: array [Boolean] of Integer = (cxSingleLine, cxWordBreak);
  ShowEndEllipsises: array [Boolean] of Integer = (0, cxShowEndEllipsis);
var
  Section: string;
  i, State: integer;
begin
  if Skinned then begin
    if AState in [cxbsDefault, cxbsNormal, cxbsHot, cxbsPressed] then begin
      Section := s_ColHeader;
      if AFont <> nil then
        ACanvas.Font.Assign(AFont);

      i := DefaultManager.GetSkinIndex(Section);
      if i >= 0 then begin
        State := integer(StateValues[AState] <> 0);
        ACanvas.Font.Color := DefaultManager.gd[i].Props[State].FontColor.Color;
      end;

      ACanvas.Brush.Style := bsClear;
      ACanvas.DrawText(AText, ATextAreaBounds, AlignmentsHorz[AAlignmentHorz] or
            AlignmentsVert[AAlignmentVert] or MultiLines[AMultiLine] or ShowEndEllipsises[AShowEndEllipsis]);
    end;
  end
  else
    inherited
end;


procedure TcxACLookAndFeelPainter.DrawHeaderControlSectionText(ACanvas: TcxCanvas; const ATextAreaBounds: TRect; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor: TColor);
begin
  inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
  ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent);
{$ENDIF}
begin
  if Skinned then
    DrawHeader(ACanvas, ABounds, ATextAreaBounds, ANeighbors, ABorders, AState, AAlignmentHorz, AAlignmentVert,
               AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, AOnDrawBackground, False)
  else
    inherited
end;


procedure TcxACLookAndFeelPainter.DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  if not Skinned then
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawHeaderSeparator(ACanvas: TcxCanvas; const ABounds: TRect; AIndentSize: Integer; AColor: TColor; AViewParams: TcxViewParams);
begin
  if Skinned then
    AColor := DefaultManager.Palette[pcBorder];

  inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledIndicatorCustomizationMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawIndicatorCustomizationMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
{$ENDIF}
begin
  if Skinned then
    AColor := DefaultManager.GetGlobalFontColor;

  inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
      const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer; AScaleFactor: TdxScaleFactor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
  const AViewParams: TcxViewParams;
  AArrows: {$IFDEF VER23} TcxArrowDirections {$ELSE} TcxHeaderArrows {$ENDIF}; ASideWidth: Integer; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
{$ENDIF}
var
  rText: TRect;
  i: integer;
begin
  if Skinned then begin
    rText := HeaderContentBounds(ABounds, []);
    DrawHeader(ACanvas, ABounds, rText, ANeighbors, [], cxbsNormal, taCenter, vaCenter, False, False, AText, ACanvas.Font, clNone, clNone);
    i := DefaultManager.CommonSkinData.Sections[ssColHeader];
    if i < 0 then
      i := DefaultManager.CommonSkinData.Sections[ssButton];

    if i >= 0 then
      DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, DefaultManager.gd[i].Props[0].FontColor.Color)
    else
      DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, clWindowText);
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawPanelBackground(ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect; AColorFrom, AColorTo: TColor);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawPanelBorders(ACanvas: TcxCanvas; const ABorderRect: TRect);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawPanelCaption(ACanvas: TcxCanvas; const ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawPanelContent(ACanvas: TcxCanvas; const ABorderRect: TRect; ABorder: Boolean);
var
  Bmp: TBitmap;
begin
  if Skinned then
    if ABorder then begin
      Bmp := CreateBmp32(ABorderRect);
      PaintSection(Bmp, s_Panel, '', 0, DefaultManager.CommonSkinData, ABorderRect.TopLeft, DefaultManager.GetGlobalColor);
      BitBlt(ACanvas.Handle, ABorderRect.Left, ABorderRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(Bmp);
    end
    else
      ACanvas.FillRect(ABorderRect, DefaultManager.GetGlobalColor)
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawProgressBarBorder(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean);
var
  i: integer;
  TmpBmp: TBitmap;
  CI: TCacheInfo;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.Sections[ssGauge];
    if DefaultManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(ARect);
      CI.Bmp := nil;
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      PaintItem(i, CI, True, 0, MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
      BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else
    inherited
end;


procedure TcxACLookAndFeelPainter.DrawProgressBarChunk(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean);
var
  i: integer;
  TmpBmp, BGBmp: TBitmap;
begin
  if Skinned then begin
    i := iff(AVertical, DefaultManager.CommonSkinData.Sections[ssProgressV], DefaultManager.CommonSkinData.Sections[ssProgressH]);
    if DefaultManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(ARect);
      BGBmp  := CreateBmpLike(TmpBmp);
      BitBlt(BgBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, ARect.Left, ARect.Top, SRCCOPY);
      PaintItem(i, MakeCacheInfo(BgBmp), True, 0, MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
      BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
      FreeAndNil(BgBmp);
    end;
  end
  else
    inherited
end;


procedure TcxACLookAndFeelPainter.DrawSchedulerBorder(ACanvas: TcxCanvas; R: TRect);
begin
  if Skinned then
    ACanvas.FillRect(R, DefaultManager.GetGlobalColor)
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawSchedulerEventProgress(ACanvas: TcxCanvas; const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawSchedulerNavigationButton(ACanvas: TcxCanvas; const ARect: TRect; AIsNextButton: Boolean;
  AState: TcxButtonState; const AText: string; const ATextRect, AArrowRect: TRect{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF});
var
  TmpBmp: TcxBitmap;
  cBmp: TBitmap;
  Ndx: integer;
  R: TRect;

  function RotateTextRect(const ATextRect: TRect): TRect;
  begin
    Result.Left := ARect.Bottom - ATextRect.Bottom;
    Result.Top := ATextRect.Left - ARect.Left;
    Result.Right := Result.Left + ATextRect.Bottom - ATextRect.Top;
    Result.Bottom := Result.Top + ATextRect.Right - ATextRect.Left;
  end;

begin
  if Skinned then begin
    TmpBmp := TcxBitmap.CreateSize(WidthOf(ARect), HeightOf(ARect));
    TmpBmp.PixelFormat := pf32bit;
    cBmp := CreateBmp32(TmpBmp.Width, TmpBmp.Height);
    BitBlt(cBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, ARect.Left, ARect.Top, SRCCOPY);
    if AIsNextButton then begin
      Ndx := DefaultManager.CommonSkinData.Tabs[tlSingle][asLeft].SkinIndex;
      if Ndx < 0 then
        Ndx := DefaultManager.CommonSkinData.Sections[ssButton];

      if Ndx >= 0 then
        PaintItem(Ndx, MakeCacheInfo(cBmp), True, GetState[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData) // Transparency is not needed
    end
    else begin
      Ndx := DefaultManager.CommonSkinData.Tabs[tlSingle][asRight].SkinIndex;
      if Ndx < 0 then
        Ndx := DefaultManager.CommonSkinData.Sections[ssButton];

      if Ndx >= 0 then
        PaintItem(Ndx, MakeCacheInfo(cBmp), True, GetState[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData) // Transparency is not needed
    end;
    cBmp.Free;

    TmpBmp.Rotate(raMinus90);
    with TmpBmp.Canvas do begin
      Brush.Style := bsClear;
      Font.Assign(ACanvas.Font);
      Font.Color := ButtonSymbolColor(AState, Font.Color);
      R := RotateTextRect(ATextRect);
      cxDrawText(Handle, AText, R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
    TmpBmp.Rotate(raPlus90);
    BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    DrawSchedulerNavigationButtonArrow(ACanvas, AArrowRect, AIsNextButton, ButtonSymbolColor(AState));
    FreeAndNil(TmpBmp);
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawSchedulerNavigationButtonArrow(ACanvas: TcxCanvas; const ARect: TRect; AIsNextButton: Boolean; AColor: TColor{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF});
begin
  if Skinned then
    AColor := DefaultManager.GetGlobalFontColor;

  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean);
begin
  inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledScrollBarPart(ACanvas: TcxCanvas; AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawScrollBarPart(ACanvas: TcxCanvas; AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState);
{$ENDIF}
var
  TmpBmp, BGBmp: TBitmap;
  CI: TCacheInfo;
  BtnSize: integer;

  procedure PaintGlyph(MaskIndex: integer);
  var
    p: TPoint;
  begin
    with DefaultManager do
      if IsValidImgIndex(MaskIndex) then begin
        p.x := (WidthOf(R)  - ma[MaskIndex].Width) div 2;
        p.y := (HeightOf(R) - ma[MaskIndex].Height) div 2;
        if (p.x < 0) or (p.y < 0) then
          Exit;

        DrawSkinGlyph(TmpBmp, p, StateValues[AState], 1, ma[MaskIndex], MakeCacheInfo(TmpBmp));
      end
  end;

  procedure PaintArrow(Side: TacSide);
  var
    C: TColor;
    gR: TRect;
    State: integer;
  begin
    with DefaultManager do
      if IsValidImgIndex(CommonSkinData.ScrollBtns[Side].GlyphIndex) then
        PaintGlyph(CommonSkinData.ScrollBtns[Side].GlyphIndex)
      else begin
        State := mini(StateValues[AState], ac_MaxPropsIndex);
        C := gd[CommonSkinData.ScrollBtns[Side].SkinIndex].Props[State].FontColor.Color;
        gR := MkRect(TmpBmp);
        if (StateValues[AState] > 1) and ButtonsOptions.ShiftContentOnClick then
          OffsetRect(gR, 1, 1);

        sGraphUtils.DrawArrow(TmpBmp, C, clNone, gR, Side, 0, 0, 0, DefaultManager.Options.ActualArrowStyle);
      end;
  end;

  procedure PaintPage(APart: TcxScrollBarPart; w, h: integer; NewBmp: TBitmap = nil; IsBtn: boolean = False);
  var
    Bmp: TBitmap;
    CI: TCacheInfo;
  begin
    if NewBmp = nil then
      NewBmp := TmpBmp;

    BtnSize := integer(not IsBtn) * GetSystemMetrics(SM_CYVSCROLL);
    Bmp := CreateBmp32(w, h);
    CI.Ready := False;
    CI.FillColor := DefaultManager.GetGlobalColor;
    with DefaultManager.CommonSkinData do
      if AHorizontal then begin
        Bmp.Width := w + BtnSize;
        if APart = sbpPageUp then
          with Scrolls[asLeft] do begin
            PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True,
                          StateValues[AState], MkRect(Bmp.Width, h), MkPoint, Bmp, DefaultManager.CommonSkinData);
            BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, BtnSize, 0, SRCCOPY);
          end
        else
          with Scrolls[asRight] do begin
            PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True,
                          StateValues[AState], MkRect(Bmp.Width, NewBmp.Height), MkPoint, Bmp, DefaultManager.CommonSkinData);
            BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
          end;
      end
      else begin
        Bmp.Height := h + BtnSize;
        if APart = sbpPageUp then
          with Scrolls[asTop] do begin
            PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True,
                          StateValues[AState], MkRect(w, Bmp.Height), MkPoint, Bmp, DefaultManager.CommonSkinData);
            BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, 0, BtnSize, SRCCOPY);
          end
        else
          with Scrolls[asBottom] do begin
            PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True,
                          StateValues[AState], MkRect(w, Bmp.Height), MkPoint, Bmp, DefaultManager.CommonSkinData);
            BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
          end;
      end;

    FreeAndNil(Bmp);
  end;
begin
  if IsRectEmpty(R) or ((APart = sbpThumbnail) and (AState = cxbsDisabled)) then
    Exit;

  if Skinned then begin
    TmpBmp := CreateBmp32(R);
    with DefaultManager.CommonSkinData do begin
      if AHorizontal then
        case APart of
          sbpThumbnail: begin
            BGBmp := CreateBmp32(WidthOf(R) + 60, HeightOf(R));
            PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp);
            CI := MakeCacheInfo(BGBmp);
            CI.X := 30;
            with Sliders[False] do begin
              PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
              FreeAndNil(BGBmp);
              PaintGlyph(GlyphIndex);
            end;
          end;

          sbpLineUp: begin
            BGBmp := CreateBmp32(R);
            PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp, True);
            CI := MakeCacheInfo(BGBmp);
            with ScrollBtns[asLeft] do begin
              if DefaultManager.gd[SkinIndex].ReservedBoolean and (MaskIndex >= 0) then
                TmpBmp.Width := math.max(GetSystemMetrics(SM_CXHSCROLL), DefaultManager.ma[MaskIndex].Width);

              PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
              FreeAndNil(BGBmp);
              PaintArrow(asLeft);
            end;
          end;

          sbpLineDown: begin
            BGBmp := CreateBmp32(R);
            PaintPage(sbpPageDown, BGBmp.Width, BGBmp.Height, BGBmp, True);
            CI := MakeCacheInfo(BGBmp);
            with ScrollBtns[asRight] do begin
              if DefaultManager.gd[SkinIndex].ReservedBoolean and (MaskIndex >= 0) then
                TmpBmp.Width := math.max(GetSystemMetrics(SM_CXHSCROLL), DefaultManager.ma[MaskIndex].Width);

              PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
              FreeAndNil(BGBmp);
              BitBlt(TmpBmp.Canvas.Handle, 0, 0, WidthOf(R), HeightOf(R), TmpBmp.Canvas.Handle, TmpBmp.Width - WidthOf(R), 0, SRCCOPY);
              PaintArrow(asRight);
              TmpBmp.Width := WidthOf(R);
            end;
          end;

          sbpPageUp, sbpPageDown:
            PaintPage(APart, TmpBmp.Width, TmpBmp.Height);
        end
      else
        case APart of
          sbpThumbnail: begin
            BGBmp := CreateBmp32(WidthOf(R), HeightOf(R) + 60);
            PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp);
            CI := MakeCacheInfo(BGBmp);
            CI.Y := 30;
            with Sliders[True] do begin
              PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
              FreeAndNil(BGBmp);
              PaintGlyph(GlyphIndex);
            end;
          end;

          sbpLineUp: begin
            BGBmp := CreateBmp32(R);
            PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp, True);
            CI := MakeCacheInfo(BGBmp);
            with ScrollBtns[asTop] do begin
              if DefaultManager.gd[SkinIndex].ReservedBoolean and (MaskIndex >= 0) then
                TmpBmp.Height := math.max(GetSystemMetrics(SM_CXHSCROLL), DefaultManager.ma[MaskIndex].Height);

              PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
              FreeAndNil(BGBmp);
              PaintArrow(asTop);
            end;
          end;

          sbpLineDown: begin
            BGBmp := CreateBmp32(R);
            PaintPage(sbpPageDown, BGBmp.Width, BGBmp.Height, BGBmp, True);
            CI := MakeCacheInfo(BGBmp);
            with ScrollBtns[asBottom] do begin
              if DefaultManager.gd[SkinIndex].ReservedBoolean and (MaskIndex >= 0) then
                TmpBmp.Height := math.max(GetSystemMetrics(SM_CXHSCROLL), DefaultManager.ma[MaskIndex].Height);

              PaintItemFast(SkinIndex, MaskIndex, BGIndex[0], BGIndex[1], CI, True, StateValues[AState], MkRect(TmpBmp), MkPoint, TmpBmp, DefaultManager.CommonSkinData);
              FreeAndNil(BGBmp);
              BitBlt(TmpBmp.Canvas.Handle, 0, 0, WidthOf(R), HeightOf(R), TmpBmp.Canvas.Handle, 0, TmpBmp.Height - HeightOf(R), SRCCOPY);
              PaintArrow(asBottom);
              TmpBmp.Height := HeightOf(R);
            end;
          end;

          sbpPageUp, sbpPageDown:
            PaintPage(APart, TmpBmp.Width, TmpBmp.Height);
        end;
    end;
    BitBlt(ACanvas.Handle, R.Left, R.Top, WidthOf(R), HeightOf(R), TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    FreeAndNil(TmpBmp);
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor = clDefault; ACorner: TdxCorner = coBottomRight);
var
  i: integer;
  TmpBmp: TBitmap;
  p: TPoint;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.GripRightBottom;
    if DefaultManager.IsValidImgIndex(i) then begin
      TmpBmp := CreateBmp32(WidthOf(ARect), HeightOf(ARect));

      p.x := (WidthOf (ARect) - DefaultManager.ma[i].Width);
      p.y := (HeightOf(ARect) - DefaultManager.ma[i].Height);

      FillDC(TmpBmp.Canvas.Handle, ARect, DefaultManager.GetGlobalColor);
      DrawSkinGlyph(TmpBmp, p, 0, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp)
    end
  end
  else
    inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean);
{$ENDIF}
var
  State: integer;
  TmpBmp: TBitmap;

  procedure PaintGlyph(Side: TacSide);
  var
    p: TPoint;
    C: TColor;
    gR: TRect;
  begin
    with DefaultManager do
      if DefaultManager.IsValidImgIndex(CommonSkinData.ScrollBtns[Side].GlyphIndex) then begin
        p.x := (WidthOf(R)  - ma[CommonSkinData.ScrollBtns[Side].GlyphIndex].Width)  div 2;
        p.y := (HeightOf(R) - ma[CommonSkinData.ScrollBtns[Side].GlyphIndex].Height) div 2;
        if p.y < 0 then
          p.y := 0;

        if (p.x >= 0) and (p.y >= 0) then
          DrawSkinGlyph(TmpBmp, p, State, 1, ma[CommonSkinData.ScrollBtns[Side].GlyphIndex], MakeCacheInfo(TmpBmp));
      end
      else begin
        C := GetGlobalFontColor;
        gR := MkRect(TmpBmp);
        if (State > 1) and ButtonsOptions.ShiftContentOnClick then
          OffsetRect(gR, 1, 1);

        sGraphUtils.DrawArrow(TmpBmp, C, clNone, gR, Side, 0, 0, 0, DefaultManager.Options.ActualArrowStyle);
      end;
  end;

begin
  if Skinned then begin
    TmpBmp := CreateBmp32(R);
    BitBlt(TmpBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, R.Left, R.Top, SRCCOPY);
    if not AAscendingSorting then
      PaintGlyph(asBottom)
    else
      PaintGlyph(asTop);

    BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    FreeAndNil(TmpBmp)
  end
  else
    inherited;
end;


{$IFDEF VER17_1_4}
procedure TcxACLookAndFeelPainter.DrawScaledSplitter(ACanvas: TcxCanvas; const ARect: TRect; AHighlighted, AClicked, AHorizontal: Boolean; AScaleFactor: TdxScaleFactor);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawSplitter(ACanvas: TcxCanvas; const ARect: TRect; AHighlighted, AClicked, AHorizontal: Boolean);
{$ENDIF}
begin
  if Skinned then begin
    if AHighlighted then
      ACanvas.FillRect(ARect, DefaultManager.GetHighLightColor(False));
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawTab(ACanvas: TcxCanvas; R: TRect; ABorders: TcxBorders; const AText: string;
  AState: TcxButtonState; AVertical: Boolean; AFont: TFont; ATextColor, ABkColor: TColor; AShowPrefix: Boolean);
var
  i, State: integer;
  Bmp: TBitmap;
  CI: TCacheInfo;
begin
  if Skinned then begin
    i := iff(AVertical, DefaultManager.CommonSkinData.Tabs[tlSingle][asLeft].SkinIndex, DefaultManager.CommonSkinData.Tabs[tlSingle][asTop].SkinIndex);
    if DefaultManager.IsValidSkinIndex(i) then begin
      Bmp := CreateBmp32(R);
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      if StateValues[AState] <> 2 then
        dec(R.Bottom);

      PaintItem(i, CI, True, StateValues[AState], R, MkPoint, ACanvas.Handle, DefaultManager.CommonSkinData);
      FreeAndNil(Bmp);
    end;
    ACanvas.Font.Assign(AFont);
    State := mini(StateValues[AState], ac_MaxPropsIndex);
    ACanvas.Font.Color := DefaultManager.gd[i].Props[State].FontColor.Color;
    ACanvas.Brush.Style := bsClear;
    DrawText(ACanvas.Handle, PChar(AText), Length(AText), R, DT_EXPANDTABS + DT_VCENTER + DT_CENTER + DT_SINGLELINE);
  end
  else
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean);
begin
  if not Skinned then
    inherited;
end;


procedure TcxACLookAndFeelPainter.DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean);
var
  i: integer;
  Bmp: TBitmap;
  CI: TCacheInfo;
begin
  if Skinned then begin
    CI.Ready := False;
    CI.FillColor := DefaultManager.GetGlobalColor;
    CI.Bmp := nil;
    if not AVertical then begin
      i := DefaultManager.GetSkinIndex(s_PageControl);
      if DefaultManager.IsValidSkinIndex(i) then begin
        Bmp := CreateBmp32(WidthOf(R), 15);
        PaintItem(i, CI, False, 0, MkRect(Bmp), MkPoint, Bmp, DefaultManager.CommonSkinData);
        BitBlt(ACanvas.Handle, R.Left, R.Top, Bmp.Width, 2, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndNil(Bmp);
      end
      else
        FillDC(ACanvas.Handle, R, DefaultManager.GetGlobalColor);
    end
    else begin
      i := DefaultManager.GetSkinIndex(s_PageControl + sTabPositions[tpLeft]);
      if DefaultManager.IsValidSkinIndex(i) then
        PaintItem(i, CI, False, 0, R, MkPoint, ACanvas.Handle, DefaultManager.CommonSkinData)
      else
        FillDC(ACanvas.Handle, R, DefaultManager.GetGlobalColor);
    end;
  end
  else
    inherited DrawTabsRoot(ACanvas, R, ABorders, AVertical);
end;

procedure TcxACLookAndFeelPainter.CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect);
begin
  inherited;
end;


{$IFDEF VER14_1_2}
procedure TcxACLookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas; const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: dxCore.TPoints);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas; const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPointArray);
{$ENDIF}
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect);
begin
  inherited;
end;


procedure TcxACLookAndFeelPainter.DrawWindowContent(ACanvas: TcxCanvas; const ARect: TRect);
begin
  if Skinned then begin
    FillDC(ACanvas.Handle, Rect(ARect.Left + 1, ARect.Top + 1, ARect.Right - 1, ARect.Bottom - 1), DefaultManager.GetGlobalColor);
    FillDCBorder(ACanvas.Handle, ARect, 1, 1, 1, 1, DefaultManager.Palette[pcBorder]);
  end
  else
    inherited;
end;


function TcxACLookAndFeelPainter.EditButtonSize: TSize;
begin
  if Skinned then
    Result := cxClasses.Size(12, 12)
  else
    Result := inherited EditButtonSize;
end;


function TcxACLookAndFeelPainter.EditButtonTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited EditButtonTextColor
end;


function TcxACLookAndFeelPainter.EditButtonTextOffset: Integer;
begin
  Result := inherited EditButtonTextOffset
end;


{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
{$ELSE}
function TcxACLookAndFeelPainter.ExpandButtonSize: Integer;
{$ENDIF}
begin
  Result := inherited;
  if Skinned then
    Inc(Result, 2);
end;

{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.ScaledFilterActivateButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
{$ELSE}
function TcxACLookAndFeelPainter.FilterActivateButtonSize: TPoint;
{$ENDIF}
var
  i: integer;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.SmallCheckBox[cbChecked];
    if i < 0 then
      i := DefaultManager.CommonSkinData.CheckBox[cbChecked];

    if DefaultManager.IsValidImgIndex(i) then begin
      Result.x := DefaultManager.ma[i].Width;
      Result.y := DefaultManager.ma[i].Height;
    end
    else
      Result := inherited;
  end
  else
    Result := inherited;
end;

{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
{$ELSE}
function TcxACLookAndFeelPainter.FilterCloseButtonSize: TPoint;
{$ENDIF}
var
  i: integer;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.TitleGlyphs[tgSmallClose];
    if i < 0 then
      i := DefaultManager.CommonSkinData.TitleGlyphs[tgClose];

    if DefaultManager.IsValidImgIndex(i) then begin
      Result.x := DefaultManager.ma[i].Width;
      Result.y := DefaultManager.ma[i].Height;
    end
    else
      Result := inherited;
  end
  else
    Result := inherited;
end;


function TcxACLookAndFeelPainter.FooterBorders: TcxBorders;
begin
  Result := inherited FooterBorders;
end;


function TcxACLookAndFeelPainter.FooterBorderSize: Integer;
begin
  if Skinned then
    Result := 0
  else
    Result := inherited FooterBorderSize
end;


function TcxACLookAndFeelPainter.FooterCellBorderSize: Integer;
begin
  Result := inherited FooterCellBorderSize
end;


function TcxACLookAndFeelPainter.FooterCellOffset: Integer;
begin
  Result := inherited FooterCellOffset
end;


function TcxACLookAndFeelPainter.FooterDrawCellsFirst: Boolean;
begin
  Result := inherited FooterDrawCellsFirst
end;


function TcxACLookAndFeelPainter.FooterSeparatorColor: TColor;
begin
  if Skinned then
    Result := BlendColors(DefaultManager.GetGlobalFontColor, DefaultManager.GetGlobalColor, 127)
  else
    Result := inherited FooterSeparatorColor
end;


function TcxACLookAndFeelPainter.FooterSeparatorSize: Integer;
begin
  Result := inherited FooterSeparatorSize
end;


function TcxACLookAndFeelPainter.GetContainerBorderColor(AIsHighlightBorder: Boolean): TColor;
begin
  if Skinned then
    Result := DefaultManager.Palette[pcBorder]
  else
    Result := inherited GetContainerBorderColor(AIsHighlightBorder);
end;


{$IFDEF VER14_1_2}
function TcxACLookAndFeelPainter.GetGalleryGroupTextColor: TColor;
var
  i: integer;
begin
  if Skinned then begin
    i := DefaultManager.CommonSkinData.Sections[ssColHeader];
    if i < 0 then
      i := DefaultManager.CommonSkinData.Sections[ssButton];

    if i < 0 then
      Result := DefaultManager.GetGlobalFontColor
    else
      Result := DefaultManager.gd[i].Props[0].FontColor.Color;
  end
  else
    Result := inherited GetGalleryGroupTextColor
end;


procedure TcxACLookAndFeelPainter.DrawGalleryBackground(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  if Skinned then
    ACanvas.FillRect(ABounds, DefaultManager.GetGlobalColor)
  else
    inherited;
end;
{$ENDIF}

{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.GetScaledSplitterSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize;
{$ELSE}
function TcxACLookAndFeelPainter.GetSplitterSize(AHorizontal: Boolean): TSize;
{$ENDIF}
begin
  Result := cxClasses.Size(8, 8);
end;


function TcxACLookAndFeelPainter.GroupBoxBorderSize(ACaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TRect;
begin
  if Skinned then
    Result := Rect(1, integer(ACaption) + 1, 1, 1)
  else
    Result := inherited GroupBoxBorderSize(ACaption, ACaptionPosition)
end;


function TcxACLookAndFeelPainter.GroupBoxTextColor(AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited GroupBoxTextColor(AEnabled, ACaptionPosition)
end;


function TcxACLookAndFeelPainter.HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders;
begin
  Result := cxBordersAll;
end;


function TcxACLookAndFeelPainter.HeaderBorderSize: Integer;
begin
  if Skinned then
    Result := 2
  else
    Result := inherited HeaderBorderSize
end;


function TcxACLookAndFeelPainter.HeaderBounds(const ABounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders): TRect;
begin
  Result := inherited HeaderBounds(ABounds, ANeighbors, ABorders)
end;


function TcxACLookAndFeelPainter.HeaderControlSectionBorderSize(AState: TcxButtonState): Integer;
begin
  Result := inherited HeaderControlSectionBorderSize(AState)
end;


function TcxACLookAndFeelPainter.HeaderControlSectionContentBounds(const ABounds: TRect; AState: TcxButtonState): TRect;
begin
  Result := inherited HeaderControlSectionContentBounds(ABounds, AState)
end;


function TcxACLookAndFeelPainter.HeaderControlSectionTextAreaBounds(ABounds: TRect; AState: TcxButtonState): TRect;
begin
  Result := inherited HeaderControlSectionTextAreaBounds(ABounds, AState)
end;


function TcxACLookAndFeelPainter.HeaderDrawCellsFirst: Boolean;
begin
  Result := inherited HeaderDrawCellsFirst
end;


function TcxACLookAndFeelPainter.IndicatorDrawItemsFirst: Boolean;
begin
  Result := inherited IndicatorDrawItemsFirst
end;


function TcxACLookAndFeelPainter.IsButtonHotTrack: Boolean;
begin
  if Skinned then
    Result := True
  else
    Result := inherited IsButtonHotTrack
end;


function TcxACLookAndFeelPainter.IsDrawTabImplemented(AVertical: Boolean): Boolean;
begin
  if Skinned then
    Result := True
  else
    Result := inherited IsDrawTabImplemented(AVertical)
end;


function TcxACLookAndFeelPainter.IsGroupBoxTransparent(AIsCaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean;
begin
  if Skinned then
    Result := False
  else
    Result := inherited IsGroupBoxTransparent(AIsCaption, ACaptionPosition)
end;


function TcxACLookAndFeelPainter.IsHeaderHotTrack: Boolean;
begin
  if Skinned then
    Result := False
  else
    Result := inherited IsHeaderHotTrack
end;


function TcxACLookAndFeelPainter.IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean;
begin
  Result := inherited IsPointOverGroupExpandButton(R, P)
end;


function TcxACLookAndFeelPainter.IsTabHotTrack(AVertical: Boolean): Boolean;
begin
  if Skinned then
    Result := True
  else
    Result := inherited IsTabHotTrack(AVertical)
end;


function TcxACLookAndFeelPainter.LookAndFeelName: string;
begin
  Result := s_AlphaSkins;
end;


function TcxACLookAndFeelPainter.PanelBorderSize: TRect;
begin
  Result := inherited PanelBorderSize
end;


function TcxACLookAndFeelPainter.PanelTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited PanelTextColor
end;


function TcxACLookAndFeelPainter.PopupBorderStyle: TcxPopupBorderStyle;
begin
  if Skinned then
    Result := pbsFlat
  else
    Result := inherited PopupBorderStyle
end;


function TcxACLookAndFeelPainter.ProgressBarBorderSize(AVertical: Boolean): TRect;
begin
  Result := inherited ProgressBarBorderSize(AVertical)
end;


function TcxACLookAndFeelPainter.ProgressBarTextColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited ProgressBarTextColor
end;


function TcxACLookAndFeelPainter.SchedulerEventProgressOffsets: TRect;
begin
  Result := inherited SchedulerEventProgressOffsets
end;


procedure TcxACLookAndFeelPainter.SchedulerNavigationButtonSizes(AIsNextButton: Boolean; var ABorders: TRect; var AArrowSize: TSize; var AHasTextArea: Boolean{$IFDEF VER16_2_2}; const AIsVertical: boolean = True{$ENDIF});
begin
  inherited;
end;


{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.ScaledSizeGripSize(AScaleFactor: TdxScaleFactor): TSize;
{$ELSE}
function TcxACLookAndFeelPainter.SizeGripSize: TSize;
{$ENDIF}
begin
  if Skinned then begin
    if DefaultManager.IsValidImgIndex(DefaultManager.CommonSkinData.GripRightBottom) then
      Result := MkSize(DefaultManager.ma[DefaultManager.CommonSkinData.GripRightBottom])
    else
      Result := cxClasses.Size(GetSystemMetrics(SM_CXVSCROLL), GetSystemMetrics(SM_CYHSCROLL));
  end
  else
    Result := cxClasses.Size(GetSystemMetrics(SM_CXVSCROLL), GetSystemMetrics(SM_CYHSCROLL));
end;


function TcxACLookAndFeelPainter.TabBorderSize(AVertical: Boolean): Integer;
begin
  Result := inherited TabBorderSize(AVertical);
  if Skinned then
    inc(Result)
end;

{$IFDEF VER17_1_4}
function TcxACLookAndFeelPainter.TrackBarScaledThumbSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize;
{$ELSE}
function TcxACLookAndFeelPainter.TrackBarThumbSize(AHorizontal: Boolean): TSize;
{$ENDIF}
begin
  Result := MkSize(11, 21);
end;


function TcxACLookAndFeelPainter.TrackBarTicksColor(AText: Boolean): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalFontColor
  else
    Result := inherited TrackBarTicksColor(AText)
end;


procedure _RefreshDevEx;
begin
  RootLookAndFeel.Refresh;
end;


procedure _InitDevEx(const Active: boolean);
var
 vPainter: TcxCustomLookAndFeelPainter;
begin
{$IFNDEF VER12_1_6}
  if GetExtendedStylePainters <> nil then begin
{$ENDIF}
    vPainter := nil;
    if Active then begin
      if not cxLookAndFeelPaintersManager.GetPainter(s_AlphaSkins, vPainter) then begin
        cxLookAndFeelPaintersManager.Register(TcxACLookAndFeelPainter.Create);
{$IFDEF VER12_1_6}
        RegisterPCPainterClass(TcxACPCPainter);
  {$IFDEF EXPRESSBARS}
        dxStatusBarSkinPainterClass := TdxACStatusBarSkinPainter;
        dxBarSkinPainterClass := TdxACBarPainter;
  {$ENDIF}
{$ENDIF}
        RootLookAndFeel.Kind := lfStandard;
        RootLookAndFeel.SkinName := s_AlphaSkins;
      end;
    end
    else
      if (cxLookAndFeelPaintersManager <> nil) then // Added by Witcher 28.12.2012 10:41:58
        if cxLookAndFeelPaintersManager.GetPainter(s_AlphaSkins, vPainter) then begin
{$IFDEF VER12_1_6}
          UnregisterPCPainterClass(TcxPCTabsPainter);
  {$IFDEF EXPRESSBARS}
          dxStatusBarSkinPainterClass := nil;
          dxBarSkinPainterClass := nil;
  {$ENDIF}
{$ENDIF}
          RootLookAndFeel.SkinName := '';
          cxLookAndFeelPaintersManager.Unregister(s_AlphaSkins);
        end;
{$IFNDEF VER12_1_6}
  end;
{$ENDIF}
end;


function _CheckDevEx(const Control: TControl): boolean;
begin
  if (RootLookAndFeel.SkinName = s_AlphaSkins) then begin
    if Control.ClassName = 'TcxGrid' then begin
      TAccesscxControl(Control).Loaded;
      Result := True;
    end
    else
      if (Control.ClassName = 'TcxPivotGrid') or (Control.ClassName = 'TcxDBPivotGrid') then begin
        TAccesscxControl(Control).FontChanged;
        Result := True;
      end
      else
        if Control.ClassName = 'TcxScheduler' then begin
          TAccesscxControl(Control).Loaded;
          Result := True;
        end
        else
          if Control is TcxControl then begin
            TAccesscxControl(Control).Invalidate;
            Result := True;
          end
          else
            Result := False;
  end
  else
    Result := False;
end;


{$IFDEF VER12_1_6}
function TcxACPCPainter.AlwaysColoredTabs: Boolean;
begin
  Result := True;
end;


type
  TAccessTabControlProperties = class(TcxCustomTabControlProperties);


procedure TcxACPCPainter.DrawTabImageAndText(ACanvas: TcxCanvas; ATabVisibleIndex: Integer);

  function NeedDrawImage: Boolean;
  var
    ATabViewInfo: TcxTabViewInfo;
    AHasHotImage, AHasImage, AHotImagesAssigned: Boolean;
  begin
    ATabViewInfo := TabViewInfo[ATabVisibleIndex];
    AHasImage := IsImageAssigned(TAccessTabControlProperties(ViewInfo.Properties).Images, ATabViewInfo.ImageIndex);
    AHasHotImage := IsImageAssigned(TAccessTabControlProperties(ViewInfo.Properties).HotImages, ATabViewInfo.ImageIndex);
    AHotImagesAssigned := TAccessTabControlProperties(ViewInfo.Properties).HotImages <> nil;

    Result := not ATabViewInfo.IsHotTrack and AHasImage or
      ATabViewInfo.IsHotTrack and (AHotImagesAssigned and AHasHotImage or not AHotImagesAssigned and AHasImage);
  end;

var
  ATabViewInfo: TcxTabViewInfo;
  AIsTabEnabled: Boolean;
  ABackgroundColor: TColor;
  Ndx, State: integer;
begin
  if Skinned then begin
    ATabViewInfo := TabViewInfo[ATabVisibleIndex];
    ViewInfo.PrepareTabCanvasFont(ATabViewInfo, ACanvas);
    ABackgroundColor := GetTabBodyColor(ATabVisibleIndex);
    AIsTabEnabled := ATabViewInfo.ActuallyEnabled;
    if NeedDrawImage then
      DrawTabImage(ACanvas, ATabViewInfo.ImageRect, ATabViewInfo.ImageIndex,
        AIsTabEnabled, ABackgroundColor, ATabVisibleIndex);

    if ATabViewInfo.HasCaption then begin
      Ndx := DefaultManager.CommonSkinData.Tabs[tlSingle][asTop].SkinIndex;
      if Ndx >= 0 then begin
        State := integer(ATabViewInfo.IsActive);
        ACanvas.Font.Color := DefaultManager.gd[Ndx].Props[State].FontColor.Color;
      end;
      DrawTabText(ACanvas, ATabViewInfo.TextRect, ATabViewInfo.Caption,
        AIsTabEnabled, ABackgroundColor, ATabVisibleIndex);
    end;

{$IFDEF VER14_1_2}
    if ATabViewInfo.HasButtons then
      DrawTabButtons(ACanvas, ATabVisibleIndex);
{$ENDIF}
  end
  else
    inherited;
end;


function TcxACPCPainter.GetClientColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited GetClientColor;
end;


function TcxACPCPainter.GetFreeSpaceColor: TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited GetFreeSpaceColor;
end;


class function TcxACPCPainter.GetStyleID: TcxPCStyleID;
begin
  Result := 12;
end;


class function TcxACPCPainter.GetStyleName: TCaption;
begin
  Result := s_AlphaSkins;
end;


function TcxACPCPainter.GetTabBodyColor(TabVisibleIndex: Integer): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited GetClientColor;
end;


procedure TcxACPCPainter.InternalPaintTab(ACanvas: TcxCanvas; ATabVisibleIndex: Integer);
var
  ATabViewInfo: TcxTabViewInfo;
  ABitmap: TcxBitmap;
  ATabOrigin: TPoint;
  i, State: integer;
  ATabRect: TRect;
  CI: TCacheInfo;
begin
  if Skinned(Self.ViewInfo.IControl.GetControl) then begin
    ATabViewInfo := TabViewInfo[ATabVisibleIndex];
    ATabRect := ATabViewInfo.FullRect;
    if ATabViewInfo.IsMainTab then
      ATabRect := GetExtendedRect(ATabRect, MkRect(0, -1), ATabViewInfo.PaintingPosition);

    ABitmap := TcxBitmap.CreateSize(0, 0, pf32bit);
    ABitmap.Canvas.Lock;
    try
      ABitmap.SetSize(ATabRect);
      ATabOrigin := ATabRect.TopLeft;
      if ATabViewInfo.IsActive then
        State := 2
      else
        State := integer(ATabViewInfo.IsHighlighted);

      i := iff(TAccessTabControlProperties(ATabViewInfo.Properties).TabPosition in [cxPC.tpTop, cxPC.tpBottom], DefaultManager.CommonSkinData.Tabs[tlSingle][asTop].SkinIndex, DefaultManager.CommonSkinData.Tabs[tlSingle][asLeft].SkinIndex);
      if DefaultManager.IsValidSkinIndex(i) then begin
        CI.Bmp := nil;
        CI.Ready := False;
        CI.FillColor := DefaultManager.GetGlobalColor;
        PaintItem(i, CI, True, State, MkRect(ABitmap), MkPoint, ABitmap, DefaultManager.CommonSkinData);
      end;
      ABitmap.cxCanvas.WindowOrg := ATabOrigin;
      DrawTabImageAndText(ABitmap.cxCanvas, ATabVisibleIndex);
      DrawFocusRect(ABitmap.cxCanvas, ATabVisibleIndex);
      cxBitBlt(ACanvas.Handle, ABitmap.Canvas.Handle, ATabRect, ATabRect.TopLeft, SRCCOPY);
    finally
      ABitmap.Canvas.Unlock;
      FreeAndNil(ABitmap);
    end;
  end
  else
    inherited;
end;


procedure TcxACPCPainter.PaintFrameBorder(ACanvas: TcxCanvas; R: TRect);
var
  i: integer;
  Bmp: TBitmap;
  CI: TCacheInfo;
begin
  if Skinned then begin
    CI.Ready := False;
    CI.FillColor := DefaultManager.GetGlobalColor;
    CI.Bmp := nil;
    i := DefaultManager.GetSkinIndex(s_PageControl);
    if DefaultManager.IsValidSkinIndex(i) then begin
      Bmp := CreateBmp32(R);
      PaintItem(i, CI, False, 0, MkRect(Bmp), MkPoint, Bmp, DefaultManager.CommonSkinData);
      BitBlt(ACanvas.Handle, R.Left, R.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(Bmp);
    end
    else
      FillDC(ACanvas.Handle, R, DefaultManager.GetGlobalColor);
  end
  else
    inherited;
end;

{$IFDEF EXPRESSBARS}
class procedure TdxACStatusBarSkinPainter.AdjustTextColor(AStatusBar: TdxCustomStatusBar; var AColor: TColor; Active: Boolean);
begin
  if Skinned then
    AColor := DefaultManager.GetGlobalFontColor
  else
    inherited AdjustTextColor(AStatusBar, AColor, Active);
end;


procedure GetAcBG(ParentHandle: THandle; DC: hdc; Offset: TPoint; R: TRect);
var
  bg: TacBGInfo;
begin
  bg.Bmp := nil;
  GetBGInfo(@bg, ParentHandle);
  if bg.BgType = btCache then
    BitBlt(DC, R.Left, R.Top, WidthOf(R), HeightOf(R), bg.Bmp.Canvas.Handle, R.Left + bg.Offset.X + Offset.X, R.Top + bg.Offset.Y + Offset.Y, SRCCOPY)
  else
    FillDC(DC, R, bg.Color);
end;


class procedure TdxACStatusBarSkinPainter.DrawPanelBorder(AStatusBar: TdxCustomStatusBar; ABevel: TdxStatusBarPanelBevel; ACanvas: TcxCanvas; var R: TRect);
begin
  if Skinned then
    GetAcBG(AStatusBar.Parent.Handle, ACanvas.Handle, Point(AStatusBar.Left, AStatusBar.Top), R)
  else
    inherited;
end;


class procedure TdxACStatusBarSkinPainter.DrawPanelSeparator(AStatusBar: TdxCustomStatusBar; ACanvas: TcxCanvas; const R: TRect);
begin
  if Skinned then
    ACanvas.FillRect(R, DefaultManager.Palette[pcBorder])
  else
    inherited;
end;


class procedure TdxACStatusBarSkinPainter.DrawSizeGrip(AStatusBar: TdxCustomStatusBar; ACanvas: TcxCanvas; R: TRect{$IFNDEF VER14_1_2}; AOverlapped: Boolean{$ENDIF});
var
  Bmp: TBitmap;
begin
  if Skinned then
    with DefaultManager do
      if IsValidImgIndex(CommonSkinData.GripRightBottom) then begin
        Bmp := CreateBmp32(R);
        Bmp.Canvas.Lock;
        GetAcBG(AStatusBar.Parent.Handle, Bmp.Canvas.Handle, Point(AStatusBar.Left + R.Left, AStatusBar.Top + R.Top), MkRect(Bmp));
        DrawSkinGlyph(Bmp, MkPoint, 0, 1, ma[CommonSkinData.GripRightBottom], MakeCacheInfo(Bmp));
        Bmp.Canvas.UnLock;
        BitBlt(ACanvas.Handle, R.Left, R.Top, WidthOf(R), HeightOf(R), Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        Bmp.Free;
      end
      else
        inherited
  else
    inherited;
end;


class procedure TdxACStatusBarSkinPainter.DrawTopBorder(AStatusBar: TdxCustomStatusBar; ACanvas: TcxCanvas; const R: TRect);
begin
  if Skinned then
    ACanvas.FillRect(R, DefaultManager.Palette[pcBorder])
  else
    inherited DrawTopBorder(AStatusBar, ACanvas, R);
end;


class function TdxACStatusBarSkinPainter.GetPanelColor(AStatusBar: TdxCustomStatusBar; APanel: TdxStatusBarPanel): TColor;
begin
  if Skinned then
    Result := DefaultManager.GetGlobalColor
  else
    Result := inherited GetPanelColor(AStatusBar, APanel);
end;


class function TdxACStatusBarSkinPainter.GripAreaSize{$IFDEF VER17_1_4}(AStatusBar: TdxCustomStatusBar){$ENDIF}: TSize;
begin
  if Skinned then
    with DefaultManager do
      if IsValidImgIndex(CommonSkinData.GripRightBottom) then
        Result := MkSize(ma[CommonSkinData.GripRightBottom])
      else
        Result := inherited
  else
    Result := inherited
end;


class function TdxACStatusBarSkinPainter.SeparatorSize{$IFDEF VER17_1_4}(AStatusBar: TdxCustomStatusBar){$ENDIF}: Integer;
begin
  if Skinned then
    Result := 1
  else
    Result := inherited;
end;


class function TdxACStatusBarSkinPainter.TopBorderSize: Integer;
begin
  if Skinned then
    Result := 1
  else
    Result := inherited TopBorderSize;
end;

{$ENDIF} // EXPRESSBARS
{$ENDIF}


initialization
  InitDevEx := _InitDevEx;
  CheckDevEx := _CheckDevEx;
  RefreshDevEx := _RefreshDevEx;
//  ThirdPartySkipForms.Add('TcxGridFilterPopup');
//  ThirdPartySkipForms.Add('TcxShellComboBoxPopupWindow');
//  ThirdPartySkipForms.Add('TdxfmColorPalette');
//  ThirdPartySkipForms.Add('TcxPopupCalendar');

end.