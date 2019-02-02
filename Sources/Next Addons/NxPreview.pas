{-----------------------------------------------------------}
{----Purpose : Print Preview Dialog                         }
{    By      : Ir. G.W. van der Vegt                        }
{    Based on:                                              }
{    For     : MySelf                                       }
{    Depends :                                              }
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 20031999-Initial version, based on ideas from             }
{          pageprinter & ryprinter shareware print preview  }
{          systems.                                         }
{         -Added selected printer's name to the caption.    }
{ 24031999-Found that fixed pitch fonts widths are          }
{          calculated correctly. So we switch to 'Courier   }
{          New'.                                            }
{         -Made table rows twice as high as textheigth (see }
{          mainform...).                                    }
{ 25031999-Moved code for white background & printable      }
{          area into OnPaint routine.                       }
{         -Subclassed TMetaFileCanvas, so default font goes }
{          in there.                                        }
{ 26031999-Added a first version fo a header/footer.        }
{         -Added a perforation marker.                      }
{ 14041999-Corrected dimensions. Now based on physical      }
{          width/height and offset.                         }
{         -Moved most of the properties to the form.        }
{         -Added mergable header & footer text.             }
{         -Added (fixed sized) left margin.                 }
{ 15041999-Aligned even pagenumbers with body's left edge.  }
{ 13061999-Added LineHeigth property.                       }
{ 12102000-Added Default Printer (and it's save to ini).    }
{ 23102000-Added Saving of printer + orientation.           }
{         -Removed DebugDlg and mainform from uses clause.  }
{ 31052001-Added PrintInColor Property (doesn't work well   }
{          yet).                                            }
{ 27052002-Changed way the Preview Dialog is called. It now }
{          works with a OnRender Event and supports changed }
{          previews due to printer or report setup changes. }
{ 07012002-Added default values when creating the form.     }
{ 04042003-Removed a Visible check in Print routine so      }
{          the renderer is always called if it exists.      }
{         -Added safeguard for calling PrintSetup during    }
{          printing.                                        }
{ 13102003-Added T_PrintItems to suppress certain printouts }
{          pdHeader, pdFooter, pdPerforator and             }
{          pdLeftMargin.                                    }
{ 18102003-Added ReportBtn again and a eventhandler that    }
{          does the work so the selectdlg is ommitted here. }
{ 24102003-Non-printable area now on a white background.    }
{ 15102004-Converted to Component.                          }
{         -Renamed a lot of internal stuff.                 }
{         -Added safeguards to OnPaint so it works without  }
{          printer and metapages.                           }
{ 16102004-Added safeguard against no printers installed.   }
{         -Sorted Code.                                     }
{         -Made devcaps & header/body/footer dynamic.       }
{ 17102004-Fixed Painting of header and footer.             }
{         -Added update of statusbar to loaded.             }
{         -Load and set selected printer at startup.        }
{         -Fixed left margin code.                          }
{         -Moved CharWidth/Height into TNxPage.               }
{ 18102004-Changed sizes of GetPrinter arrays.              }
{         -Seem to have fixed FormName, it's buggy on some  }
{          printers so we return Default if we can't read it}
{          and the source is default or as a last resort    }
{          an empty string.                                 }
{         -Erase FormName if empty.                         }
{         -Added OnResize to Dialog so preview is centered  }
{          when Preview Dialog is maximized.                }
{         -Disabled PaintBox.OnResize as it does not do     }
{          much it seems.                                   }
{         -Can't draw left margin as body is not available  }
{          yet as there is no metapage and no charwidth.    }
{ 29102004-Added ResetPrinter.                              }
{         -Added Jobs Property.                             }
{         -Added OnJob Event that is called when the        }
{          Jobs property is                                 }
{ 24022207-Changed to support NextSuite.                    }
{         -Disabled GlobalInstanceCount.                    }
{         -Made Spinner 1 Based.                            }
{         -Removed old deprecated code.                     }
{         -Tied CurrentPage directly to SpinControl.        }
{ 28022207-Added Assigned(Printer.Printers) checks to       }
{          prevent problems with missing printers.          }
{ 06042007-Fixed small problem with Max of NxSpinner after  }
{          PrintSetup dialog had been shown.                }
{         -Set minimum value of NxSpinner.Max to 1.         }
{ 26062007-Added extra safeguards when selected printer is  }
{          no longer available. GetPrinter inside           }
{          Get/SetPrintInColor would crash.                 }
{         -Safeguarded all GetPrinter calls.                }
{ 27062007-Changed length of devicename to match printer    }
{          unit (so no longer CCHDEVICENAME but 1024 bytes).}
{         -Made PrintInColor not stored.                    }
{ 04092007-Moved 3 read-only properties to Public section to}
{          prevent problems when matacanvas is empty.       }
{         -Moved MetaCanvas to public section as it's only  }
{          confusing at designtime.                         }
{         -Added safeguards to CharHeight/CharWidth &       }
{          LineHeight.                                      }
{         -Derived CharHeigth and CharWidth from MetaPages  }
{          instead of actual pages.                         }
{ 05092007-Improved Header/Footer and Body code a bit.      }
{         -Added Lissajou to NxPreview Demo.                }
{         -Removed Header/Footer/Perforator/LeftMargin from }
{          ini file.                                        }
{         -Added ini file property (for Vista               }
{          Compatability).                                  }
{         -Improved saving and loading of settings.         }
{         -Settings is not public as it's not usefull at    }
{          designtime (and points to Delphi32.exe).         }
{         -Added BodyWith and BodyHeight properties.        }
{ 07092007-Reverted safeguards for CharWidth/Height as they }
{          do not work properly (MetaCanvas not assigned).  }
{         -Added ghost areas for Header/Body/Footer.        }
{         -Added pdAreas.                                   }
{         -Removed LineHeight property.                     }
{ 21112007-Added LineHeight like CharHeight to TNxPage.        }
{          It's calculated as the charheight of 'Jj'.       }
{ 19022008-Combined all test versions into a single source  }
{          and deleted obsoleted & commented code.          }
{         -Added PrintLines routine foir easy printing      }
{          a TStrings/TStringList.                          }
{-----------------------------------------------------------}
{ nr.    todo                                               }
{ ------ -------------------------------------------------- }
{ 1.     Add code to paint larger amounts of text with line }
{        & page breaks.                                     }
{ 2.     Debugmode with extra bordermarkers on printout.    }
{ 3.     On large screens, right border of paper is still   }
{        clipped a bit (1024*768). So why does *4 help?     }
{ 4.     Add fake pagewidth & height to reflect body size.  }
{ 5.     Add screen to printer pixel multiplier.            }
{-----------------------------------------------------------}
{  Pagewidths etc.                                          }
{                                                           }
{  Theorie now is that it goes like this:                   }
{                                                           }
{      /DevCap.Physical_PageWidth                           }
{  |<---------------------------------------------->|       }
{      /DevCap.Physical_Offset                              }
{  |<--->|                                                  }
{           /DevCap.HorzRes & Printer.Pagewidth             }
{        |<---------------------------------->|             }
{                                                           }
{                                             |<--->|       }
{                                                           }
{  There is also a non printable area but that may be       }
{  close to 0 (zero).                                       }
{                                                           }
{  Result is that the metafilecanvas will be smaller than   }
{  the paintbox we're painting it to. The paintbox will     }
{  hold all borders etc.                                    }
{                                                           }
{  Metacanvas becomes:                                      }
{                                                           }
{           /DevCap.HorzRes & Printer.Pagewidth             }
{        |<---------------------------------->|             }
{                                                           }
{-----------------------------------------------------------}
{
type
  TForm1 = class(TForm)
    Label1: TLabel;
  private
    procedure WM_SpoolerStatus(var Msg: TWMSPOOLERSTATUS);
      message WM_SPOOLERSTATUS;
  public
  end;

...

procedure TForm1.WM_SpoolerStatus(var Msg: TWMSpoolerStatus);
begin
  Label1.Caption:=IntToStr(Msg.JobsLeft);
end;
}
{-----------------------------------------------------------}

unit NxPreview;
{$DEFINE VER200}
interface

uses
  Windows, Messages, SysUtils, Classes, Forms, StdCtrls,
  ExtCtrls, ComCtrls, Dialogs, Graphics,
  NxCollection, NxEdit;

type
  TNxReportSetupEvent = function(Sender: TObject): Boolean of object;

  TNxJobEvent = procedure(Sender: TObject; const Job: Integer;
    const PrinterName, MachineName, UserName,
    Document, DataType, Status: string) of object;

  TNxPrintOperation = (poPreview, poPrintSetup, poReportSetup, poPrint);

  TNxPreview = class;
  TNxPage = class;

  TNxMetaFileCanvas = class(TMetaFileCanvas)
    constructor Create(APage: TNxPage; ReferenceDevice: HDC); reintroduce;
  private
  public
  end;

  TNxPage = class(TCollectionItem)
    FPage: TMetaFile;
  private
    { Private declarations }
    FCharHeight: Integer;
    FCharWidth: Integer;
    FLineHeight: Integer;
  public
    { Public declarations }
    constructor Create(Collection: TCollection); override;
  published
    { Published declarations }
    property Page: TMetaFile read FPage write FPage;
    property CharHeight: Integer read FCharHeight;
    property CharWidth: Integer read FCharWidth;
    property LineHeight: Integer read FLineHeight;
  end;

  TNxPrintItems = set of (pdHeader, pdFooter, pdPerforator, pdLeftMargin, pdAreas);

  TNxPages = class(TCollection)
  protected
    { Protected declarations }
    function GetItem(Index: Integer): TNxPage;
    procedure SetItem(Index: Integer; Value: TNxPage);
  public
    { Public declarations }
    function Add: TNxPage;
    property Items[Index: Integer]: TNxPage read GetItem write SetItem; default;
  end;

  TNxPreview = class(TComponent)
  private
    fCloseBtn: TNxButton;
    fDialog: TForm;
    fFooterText: string;
    fHeaderText: string;
    fMeta: TNxPages;
    fMetaCanvas: TNxMetaFileCanvas;
    fOnJob: TNxJobEvent;
    fOnRender: TNotifyEvent;
    fOnReportSetup: TNxReportSetupEvent;
    fPageLbl: TNxLabel;
    fPageSpinner: TNxSpinEdit;
    fPaintBox: TPaintBox;
    fPanel: TNxPanel;
    fParameters: TStringList;
    fPrintBtn: TNxButton;
    fPrintDialog: TPrintDialog;
    fPrintDlgCaption: string;                                                   //veg todo
    FPrintItems: TNxPrintItems;
    fReportBtn: TNxButton;
    fScreenHeight: Integer;
    fScreenWidth: Integer;
    fScrollBox: TScrollBox;
    FSettings: string;
    fSetupBtn: TNxButton;
    fStatusBar: TStatusBar;
    fZoom: Integer;
    fZoomInBtn: TNxButton;
    fZoomOutBtn: TNxButton;
    procedure CloseBtnClick(Sender: TObject);
    procedure DialogResize(Sender: TObject);
    procedure DoDrawDecoration(Sender: TObject);
    function DoExpand(pattern: string): string;
    function DoGetPrinterCap(cap: Integer): Integer;
    function DoGetScreenCap(cap: Integer): Integer;
    procedure DoZoom(no: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function GetBody: TRect;
    function GetBodyHeight: Integer;
    function GetBodyWidth: Integer;
    function GetCaption: string;
    function GetCharHeight: Integer;
    function GetCharWidth: Integer;
    function GetCurrentPage: Integer;
    function GetFooter: TRect;
    function GetFormName: string;
    function GetHeader: TRect;
    function GetHorizontalPageResolution: Integer;
    function GetHorizontalScreenResolution: Integer;
    function GetInstanceCount: Integer;
    function GetJobs: Integer;
    function GetLeftMargin: Integer;
    function GetMargin: TRect;
    function GetLineHeight: Integer;
    function GetPageHeight: Integer;
    function GetPageWidth: Integer;
    function GetPaperSize: Integer;
    function GetPhysicalPageHeight: Integer;
    function GetPhysicalPageOffsetX: Integer;
    function GetPhysicalPageOffsetY: Integer;
    function GetPhysicalPageWidth: Integer;
    function GetPrintInColor: Boolean;
    function GetVerticalPageResolution: Integer;
    function GetVerticalScreenResolution: Integer;
    function GetVisible: Boolean;
    procedure LoadSettings;
    procedure PageSpinnerChange(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure PrintDialogShow(Sender: TObject);
    procedure ReportBtnClick(Sender: TObject);
    procedure SaveSettings;
    procedure SetCaption(const Value: string);
    procedure SetCurrentPage(const Value: Integer);
    procedure SetFormName(const Value: string);
    procedure SetInstanceCount(const Value: Integer);
    procedure SetJobs(const Value: Integer);
    procedure SetPaperSize(const Value: Integer);
    procedure SetPrintInColor(const Value: Boolean);
    procedure SetPrintItems(const Value: TNxPrintItems);
    procedure SetReportSetup(const Value: TNxReportSetupEvent);
    procedure SetSettings(const Value: string);
    procedure SetupBtnClick(Sender: TObject);
    procedure SetVisible(const Value: Boolean);
    procedure WMSpoolerStatus(var Msg: TWMSpoolerStatus);
      message WM_SPOOLERSTATUS;
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Abort;
    procedure BeginDoc;
    procedure EndDoc;
    function Execute(Operation: TNxPrintOperation): Boolean;
    procedure NewPage;
    procedure PrintText(const Lines: TStrings; const WrapText: Boolean = True);
    procedure ResetPrinter;
    property BodyHeight: Integer read GetBodyHeight;
    property BodyWidth: Integer read GetBodyWidth;
    property CharHeight: Integer read GetCharHeight;
    property CharWidth: Integer read GetCharWidth;
    property LineHeight: Integer read GetLineHeight;
    property MetaCanvas: TNxMetaFileCanvas read FMetaCanvas write FMetaCanvas stored False;
    property Settings: string read FSettings write SetSettings;
  published
    property Body: TRect read GetBody;
    property Caption: string read GetCaption write SetCaption;
    property CurrentPage: Integer read GetCurrentPage write SetCurrentPage stored
      False;
    property Footer: TRect read GetFooter;
    property FooterText: string read FFooterText write FFooterText;
    property FormName: string read GetFormName write SetFormName stored False;
    property Header: TRect read GetHeader;
    property HeaderText: string read FHeaderText write fHeaderText;
    property HorizontalPageResolution: Integer read GetHorizontalPageResolution;
    property HorizontalScreenResolution: Integer read GetHorizontalScreenResolution;
    property InstanceCount: Integer read GetInstanceCount write SetInstanceCount stored False;
    property Jobs: Integer read GetJobs write SetJobs stored False;
    property LeftMargin: Integer read GetLeftMargin;
    property Margin: TRect read GetMargin;
    property PageHeight: Integer read GetPageHeight;
    property PageWidth: Integer read GetPageWidth;
    property PaperSize: Integer read GetPaperSize write SetPaperSize stored False;
    property Parameters: TStringList read FParameters write FParameters;
    property PhysicalPageHeight: Integer read GetPhysicalPageHeight;
    property PhysicalPageOffsetX: Integer read GetPhysicalPageOffsetX;
    property PhysicalPageOffsetY: Integer read GetPhysicalPageOffsetY;
    property PhysicalPageWidth: Integer read GetPhysicalPageWidth;
    property PrintDlgCaption: string read FPrintDlgCaption write FPrintDlgCaption;
    property PrintInColor: Boolean read GetPrintInColor write SetPrintInColor stored False;
    property PrintItems: TNxPrintItems read FPrintItems write SetPrintItems;
    property ScreenHeight: Integer read fScreenHeight;
    property ScreenWidth: Integer read fScreenWidth;
    property VerticalPageResolution: Integer read GetVerticalPageResolution;
    property VerticalScreenResolution: Integer read GetVerticalScreenResolution;
    property Visible: Boolean read GetVisible write SetVisible;
    property OnJob: TNxJobEvent read fOnJob write fOnJob;
    property OnRender: TNotifyEvent read FOnRender write FOnRender;
    property OnReportSetup: TNxReportSetupEvent read FOnReportSetup write SetReportSetup;
  end;

  {-----------------------------------------------------------}

implementation

uses
  Controls, Printers, Math, IniFiles, WinSpool, Types;

const
  normsize                      = 250;
  voffset                       = 10;

type
  EMultipleInstanceException = class(Exception);

var
  // counter to prevent a second TDebugDlg instance
  GlobalInstanceCount           : Integer = 0;

  {-----------------------------------------------------------}

  { TNxMetaFileCanvas }

constructor TNxMetaFileCanvas.Create({AMetafile: TMetafile; }APage: TNxPage; ReferenceDevice: HDC);
begin
  inherited Create(APage.Page, ReferenceDevice);

  //MetaFile gets pagewidth/pageheight, no physical width/height.
  //BUT it get the same physicaloffsets

  //veg:Delphi makes bad previews with variable fonts, the textwidth doesn't
  //    match the size on some printers and zoom in/out is bad too.
  font.PixelsPerInch := GetDeviceCaps(ReferenceDevice, LOGPIXELSX);
  font.Name := 'Courier New';                                                   //'MS Sans Serif';
  font.Pitch := fpFixed;                                                        //fpVariable;
  font.CharSet := DEFAULT_CHARSET;
  font.Style := [];
  font.Size := 8;                                                               //8;
  font.Color := clBlack;

  APage.FCharHeight := inherited TextHeight('X');
  APage.FCharWidth := inherited TextWidth('X');
  APage.FLineHeight := inherited TextHeight('Jj');

  Brush.Color := clWhite;
  Brush.Style := Graphics.bsSolid;
  Pen.Color := clBlack;
  Pen.Style := psSolid;
end;

{-----------------------------------------------------------}

{ TNxPage }

constructor TNxPage.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

{-----------------------------------------------------------}

{ TNxPages }

function TNxPages.Add: TNxPage;
begin
  Result := TNxPage(inherited Add);
  Result.page := TMetaFile.Create;
end;

{-----------------------------------------------------------}

function TNxPages.GetItem(Index: Integer): TNxPage;
begin
  Result := TNxPage(inherited GetItem(Index));
end;

{-----------------------------------------------------------}

procedure TNxPages.SetItem(Index: Integer; Value: TNxPage);
begin
  inherited SetItem(Index, Value);
end;

{-----------------------------------------------------------}

{ TNxPreview }

constructor TNxPreview.Create(AOwner: TComponent);
begin
  fDialog := TForm.Create(nil);
  fDialog.Height := 480;
  fDialog.Width := 640;
  fDialog.Visible := False;
  fDialog.AutoSize := False;
  fDialog.KeyPreview := True;
  fDialog.BorderWidth := 4;
  fDialog.FormStyle := fsStayOnTop;
  fDialog.Position := poScreenCenter;
  fDialog.OnKeyPress := FormKeyPress;
  fDialog.Caption := '[appname] - Print Preview';

  //Insert Component Creation Here
  fPanel := TNxPanel.Create(Self);
  fPageLbl := TNxLabel.Create(fDialog);
  fCloseBtn := TNxButton.Create(fDialog);
  fPageSpinner := TNxSpinEdit.Create(fDialog);
  fPrintBtn := TNxButton.Create(fDialog);
  fSetupBtn := TNxButton.Create(fDialog);
  fZoomOutBtn := TNxButton.Create(fDialog);
  fZoomInBtn := TNxButton.Create(fDialog);
  fReportBtn := TNxButton.Create(fDialog);
  fScrollBox := TScrollBox.Create(fDialog);
  fPaintBox := TPaintBox.Create(fDialog);
  fPrintDialog := TPrintDialog.Create(fDialog);
  fStatusBar := TStatusBar.Create(fDialog);

  //Insert Component Property Settings
  // Except OnChange Handlers that might Fire accidently and get in the way of
  // normal property loading.
  // Move them to Loaded!

  with fPanel do
    begin
      Name := 'Panel';
      //    Caption := 'x';
      DoubleBuffered := True;
      Caption := '';
      Parent := fDialog;
      Left := 0;
      Top := 0;
      Width := 608;
      Height := 41;
      Align := alTop;
      TabOrder := 2;
    end;
  with fPageSpinner do
    begin
      Name := 'PageSpinner';
      DoubleBuffered := True;
      Parent := fPanel;
      Left := 368;
      Top := 8;
      Width := 40;
      Height := 25;
      //    ArrowKeys := False;
      //    Orientation := udHorizontal;
      TabOrder := 3;
      //    Thousands := False;
      AsInteger := 1;
      Min := 1;
      Max := 1;
      OnChange := PageSpinnerChange;
    end;
  with fPageLbl do
    begin
      Name := 'PageLbl';
      Parent := fPanel;
      Left := 329;
      Top := 13;
      Width := 34;
      Height := 13;
      Caption := 'Page:';
      Font.Charset := DEFAULT_CHARSET;
      Font.Color := clWindowText;
      Font.Height := -11;
      Font.Name := 'MS Sans Serif';
      Font.Style := [fsBold];
      ParentFont := False;
      Associate := fPageSpinner;
      InnerHorizontal := False;
      InnerMargins.Horizontal := 2;
      InnerMargins.Vertical := 4;
      InnerVertical := True;
    end;
  with fCloseBtn do
    begin
      Name := 'CloseBtn';
      Parent := fPanel;
      Left := 8;
      Top := 8;
      Width := 75;
      Height := 25;
      Cancel := True;
      Caption := '&Close';
      ModalResult := 2;
      TabOrder := 0;
      OnClick := CloseBtnClick;
    end;
  with fPrintBtn do
    begin
      Name := 'PrintBtn';
      Parent := fPanel;
      Left := 248;
      Top := 8;
      Width := 75;
      Height := 25;
      Caption := 'Print';
      TabOrder := 2;
      Enabled := False;
      OnClick := PrintBtnClick;
    end;
  with fSetupBtn do
    begin
      Name := 'SetupBtn';
      Parent := fPanel;
      Left := 88;
      Top := 8;
      Width := 75;
      Height := 25;
      Caption := 'Printer &Setup';
      TabOrder := 1;
      OnClick := SetupBtnClick;
    end;
  with fZoomOutBtn do
    begin
      Name := 'ZoomOut';
      Parent := fPanel;
      Left := 504;
      Top := 8;
      Width := 75;
      Height := 25;
      Caption := 'Zoom Out';
      Enabled := False;
      TabOrder := 4;
      OnClick := ZoomOutClick;
    end;
  with fZoomInBtn do
    begin
      Name := 'ZoomIn';
      Parent := fPanel;
      Left := 424;
      Top := 8;
      Width := 75;
      Height := 25;
      Caption := 'Zoom In';
      TabOrder := 5;
      OnClick := ZoomInClick;
    end;
  with fReportBtn do
    begin
      Name := 'ReportBtn';
      Parent := fPanel;
      Left := 168;
      Top := 8;
      Width := 75;
      Height := 25;
      Caption := 'Report &Setup';
      TabOrder := 6;
      Enabled := False;
      OnClick := ReportBtnClick;
    end;
  with fScrollBox do
    begin
      Name := 'ScrollBox';
      DoubleBuffered := True;
      BevelKind := bkFlat;
      BorderStyle := bsNone;
      Parent := fDialog;
      Left := 0;
      Top := 41;
      Width := 608;
      Height := 378;
      Align := alClient;
      Color := clInfoBk;
      ParentColor := False;
      TabOrder := 0;
      //    OnResize := ScrollBoxResize;
    end;
  with fPaintBox do
    begin
      Name := 'PaintBox';
      Parent := fScrollBox;
      Left := 112;
      Top := 8;
      Width := 305;
      Height := 353;
      Color := clFuchsia;
      ParentColor := False;
    end;
  with fPrintDialog do
    begin
      Name := 'PrintDialog';
      OnShow := PrintDialogShow;
      Options := [poDisablePrintToFile];
    end;
  with fStatusBar do
    begin
      Name := 'StatusBar';
      Parent := fDialog;
      Left := 0;
      Top := 419;
      Width := 608;
      Height := 19;
      with Panels.Add do
        begin
          Width := 120;
        end;
      with Panels.Add do
        begin
          Width := 200;
        end;
      with Panels.Add do
        begin
          Width := 120;
        end;
      with Panels.Add do
        begin
          Width := 50;
        end;
    end;

  fMeta := TNxPages.Create(TNxPage);

  fParameters := TStringList.Create;

  fOnRender := nil;
  fOnReportSetup := nil;
  fOnJob := nil;

  fFooterText := 'P. [Page]';

  fSettings := ChangeFileExt(Application.ExeName, '.ini');
  fPrintItems := [pdHeader, pdFooter, pdPerforator, pdLeftMargin, pdAreas];

  inherited Create(AOwner);

  //Stored Properties are red after this call.

  if not (csDesigning in ComponentState) then
    begin
      Inc(GlobalInstanceCount);
      //    if GlobalInstanceCount > 1 then
      //      raise EMultipleInstanceException.Create('Only one ' + ClassName + ' allowed per program');
    end;
end;

{-----------------------------------------------------------}

destructor TNxPreview.Destroy;
begin
  Dec(GlobalInstanceCount);

  //Free Non Child Components Here

  FreeAndNil(fDialog);

  inherited;
end;

{-----------------------------------------------------------}

procedure TNxPreview.Abort;
begin
  FreeAndNil(fMetaCanvas);                                                      //At least free this one...

  fMeta.Clear;                                                                  //And this one...

  fPageSpinner.Max := fPageSpinner.Min;
end;

{-----------------------------------------------------------}

procedure TNxPreview.BeginDoc;
begin
  //Belongs in SetPrinter....
  if Assigned(fMeta) and (fMeta.Count > 0) then
    fMeta.Clear;

  //fPageSpinner.AsInteger := Trunc(fPageSpinner.Min);
  fPageSpinner.Max := fPageSpinner.Min;

  fMeta.Add;                                                                    //Add 1st page

  fPrintBtn.Enabled := fMeta.Count > 0;
  fPageSpinner.Max := fMeta.Count;

  MetaCanvas := TNxMetaFileCanvas.Create(fMeta[Pred(CurrentPage)], Printer.Handle);

  DoDrawDecoration(Self);

  //Store
end;

{-----------------------------------------------------------}

procedure TNxPreview.CloseBtnClick(Sender: TObject);
begin
  fDialog.Close;
end;

{-----------------------------------------------------------}

procedure TNxPreview.DialogResize(Sender: TObject);
begin
  //Force Repaint
  LockWindowUpdate(fDialog.Handle);
  DoZoom(FZoom);
  fPaintBox.Invalidate;
  LockWindowUpdate(0);
end;

{-----------------------------------------------------------}

procedure TNxPreview.DoDrawDecoration(Sender: TObject);
begin
  with MetaCanvas do
    begin
      //Draw header
      if (pdHeader in fPrintItems) then
        begin
          MoveTo(Header.Left, Header.Bottom - CharHeight);
          LineTo(Header.Right, Header.Bottom - CharHeight);
          TextOut((Header.Left + Header.Right - TextWidth(DoExpand(HeaderText))) div 2, Header.Top + CharHeight, DoExpand(HeaderText));
        end;

      //Draw footer
      if (pdFooter in fPrintItems) then
        begin
          MoveTo(Footer.Left, Footer.Top + CharHeight);
          LineTo(Footer.Right, Footer.Top + CharHeight);
          if Odd(CurrentPage) then
            TextOut(Footer.Right - TextWidth(DoExpand(FooterText)) - CharWidth, Footer.Top + 2 * CharHeight, DoExpand(FooterText))
          else
            TextOut(Body.Left + CharWidth, Footer.Top + 2 * CharHeight, DoExpand(FooterText));
        end;

      //Draw perforator marker
      if (pdPerforator in fPrintItems) then
        begin
          MoveTo(0, (Body.Top + Body.Bottom) div 2);
          LineTo(Body.Left div 2, (Body.Top + Body.Bottom) div 2);
        end;
    end;
end;

{-----------------------------------------------------------}

function TNxPreview.DoExpand(pattern: string): string;
var
  s                             : string;
  i                             : Integer;
begin
  s := Pattern;
  s := StringReplace(s, '[Page]', IntToStr(fMeta.Count), [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '[Date]', DateToStr(Now), [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '[DateTime]', DateTimeToStr(Now), [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '[LDate]', FormatDateTime('dddddd', Now), [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '[Time]', TimeToStr(Now), [rfReplaceAll, rfIgnoreCase]);

  for i := 0 to Parameters.Count - 1 do
    with Parameters do
      s := StringReplace(s, '[' + Names[i] + ']', Values[Names[i]], [rfReplaceAll, rfIgnoreCase]);

  Result := s;
end;

{-----------------------------------------------------------}

function TNxPreview.DoGetPrinterCap(cap: Integer): Integer;
begin
  if Assigned(Printer.Printers) and (Printer.Printers.Count > 0) then
    Result := GetDeviceCaps(Printer.Handle, cap)
  else
    Result := 0;
end;

{-----------------------------------------------------------}

function TNxPreview.DoGetScreenCap(cap: Integer): Integer;
begin
  if Assigned(fDialog) then
    Result := GetDeviceCaps(fDialog.Canvas.Handle, cap)
  else
    Result := 0;
end;

{-----------------------------------------------------------}

procedure TNxPreview.DoZoom(no: Integer);
var
  z,
    w2, vc                      : Integer;
begin
  //here we us the Tscroller to scroll around,
  //but the rect showed here defines the way it's shown, ie
  //full page, zoomed, zoomed to width etc.
  fZoom := no;

  z := 250;
  case no of
    0: z := 250;
    1: z := 500;
    2: z := 750;
    4:
      begin
        z := fScrollBox.ClientWidth - 2 * voffset - 2 * voffset;                //page width (correct for vertscrollbar ruining the clientarea too).
        if (printer.orientation = poLandscape) then
          z := trunc((z / PhysicalPageWidth) * PhysicalPageHeight);             //don't forget to calculate the other side...
      end;
    5: case printer.orientation of
        poLandscape: z := PhysicalPageHeight;
        poPortrait: z := PhysicalPageWidth;
      end;
    6:
      begin
        case printer.orientation of
          poLandscape: z := Round((PhysicalPageHeight / VerticalPageResolution) * HorizontalScreenResolution);
          poPortrait: z := Round((PhysicalPageWidth / HorizontalPageResolution) * VerticalScreenResolution);
        end;
      end;
  else
    exit;
  end;

  case printer.orientation of
    poPortrait:
      begin
        fScreenWidth := z;
        fScreenHeight := trunc((fScreenWidth / PhysicalPageWidth) * PhysicalPageHeight);
      end;
    poLandscape:
      begin
        fScreenHeight := z;
        fScreenWidth := trunc((fScreenHeight / PhysicalPageHeight) * PhysicalPageWidth);
      end;
  end;

  //center on page, be sure not to fire repaints from within here...
  //so adjust only when there are changes, and lock the windowupdate
  //this also prevents that the user sees the background of the graph
  //flash when it changes to white momentarily.

  LockWindowUpdate(fDialog.Canvas.Handle);
  if (fPaintBox.Width <> fScreenWidth + 4 * voffset) then
    fPaintBox.Width := fScreenWidth + 4 * voffset;                              //why 2*
  if fScrollBox.ClientWidth > fScreenWidth + 2 * voffset then
    fScrollBox.ClientWidth := fScreenWidth + 2 * voffset;                       //why 2*
  vc := fScrollBox.ClientWidth div 2;                                           //ClientWidth only grows...
  w2 := fScreenWidth div 2;

  //beware that we have to correct for the horizontal scrollbar too...
  if (fPaintBox.Left <> vc - w2 - fScrollBox.HorzScrollBar.Position) then
    fPaintBox.Left := Max(voffset - fScrollBox.HorzScrollBar.Position, vc - w2 - fScrollBox.HorzScrollBar.Position);
  if (fPaintBox.Height <> fScreenHeight + 4 * voffset) then
    fPaintBox.Height := fScreenHeight + 4 * voffset;                            //why 4*
  LockWindowUpdate(0);
end;

{-----------------------------------------------------------}

procedure TNxPreview.EndDoc;
begin
  //Seems to be neccesary to be able to paint it.
  FreeAndNil(fMetaCanvas);
end;

{-----------------------------------------------------------}

function TNxPreview.Execute(Operation: TNxPrintOperation): Boolean;
var
  Start,
    Stop,
    i, j                        : Integer;
  ini                           : TIniFile;
begin
  Result := False;

  if not (Assigned(Printer.Printers) or (Printer.Printers.Count = 0)) then
    begin
      ShowMessage('No Printer installed, can''t setup the printing.');
      Exit;
    end;

  if Assigned(fDialog) then
    case Operation of
      poPrintSetup:
        begin
          PrintDlgCaption := ChangeFileExt(ExtractFileName(Application.ExeName), '') + ' - Printer Setup';

          if (fMeta.Count = 0) then
            fPrintDialog.Options := []
          else
            fPrintDialog.Options := [poPageNums];

          fPrintDialog.MinPage := 1;
          fPrintDialog.MaxPage := Max(1, fMeta.Count);

          fPrintDialog.FromPage := fPrintDialog.MinPage;
          fPrintDialog.ToPage := fPrintDialog.MaxPage;

          { TODO -oVeg -cBugreport :
          Calls upto CheckPrinting in Printers unit.
           Seems like we try to call the setup before the EndDoc is issued. }

          if fPrintDialog.Execute and
            fDialog.Visible and
            Assigned(fOnRender) then
            begin
              //First page is safe....
              fPageSpinner.AsInteger := 1;

              fOnRender(Self);

              fZoomInBtn.Enabled := True;
              fZoomOutBtn.Enabled := False;
              fPageSpinner.Max := Max(1, fMeta.Count);                          //veg:06-04-2007

              DoZoom(0);

              CurrentPage := 1;                                                 //Make sure we end up on page 1
            end;

          { TODO -oveg -ctoto : Write Back all important values like color and papersize too. }

          ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

          ini.WriteInteger('Printer', 'Orientation', Ord(Printer.Orientation));
          ini.WriteBool('Printer', 'Color', PrintInColor);
          ini.WriteString('Printer', 'Selected', Printer.Printers[Printer.PrinterIndex]);
          ini.WriteInteger('Printer', 'PaperSize', PaperSize);
          if (FormName <> '') then
            ini.WriteString('Printer', 'FormName', FormName)
          else if ini.ValueExists('Printer', 'FormName') then
            ini.DeleteKey('Printer', 'FormName');
          ini.UpdateFile;

          fStatusBar.Panels[0].Text := Format('Page %d of %d', [CurrentPage, fMeta.Count]);
          fStatusBar.Panels[1].Text := Printer.Printers[Printer.PrinterIndex];
          try
            fStatusBar.Panels[2].Text := FormName;
          except
            { Nothing }
          end;
          fStatusBar.Panels[3].Text := '';

          fPaintBox.Invalidate;                                                 //Force a full repaint or dialog might leave an artifact

          Result := True;
        end;                                                                    //poReport

      poReportSetup:
        begin
          if Assigned(fOnReportSetup) then
            fOnReportSetup(Self);
        end;

      poPreview:
        begin
          if Assigned(fOnRender) then
            fOnRender(Self);

          //Eliminates excessive repaints...
          fScrollBox.DoubleBuffered := True;

          fPageSpinner.Max := Max(1, fMeta.Count);
          CurrentPage := 1;

          fZoomInBtn.Enabled := True;
          fZoomOutBtn.Enabled := False;
          DoZoom(0);

          Result := (fDialog.ShowModal = mrOk)
        end;                                                                    //poPreview

      poPrint:
        begin
          if (Printer.Printing) then
            begin
              ShowMessage('Printer is busy, can''t print now.');
              Exit;
            end;

          if Assigned(fOnRender) then
            fOnRender(Self);

          if (fMeta.Count = 0) then
            begin
              ShowMessage('Nothing to print.');
              Exit;
            end;

          PrintDlgCaption := ChangeFileExt(ExtractFileName(Application.ExeName), '') + ' - print report';

          fPrintDialog.Options := [poPageNums, poHelp, poWarning];

          fPrintDialog.MinPage := 1;
          fPrintDialog.MaxPage := Max(1, fMeta.Count);

          fPrintDialog.FromPage := fPrintDialog.MinPage;
          fPrintDialog.ToPage := fPrintDialog.MaxPage;

          if (fPrintDialog.Execute) then
            begin
              fStatusBar.Panels[1].Text := Printer.Printers[Printer.PrinterIndex];

              with fPrintDialog do
                {----See what we've selected}
                begin
                  case PrintRange of
                    prAllPages:
                      begin
                        Start := MinPage - 1;
                        Stop := MaxPage - 1;
                      end;
                    prPageNums:
                      begin
                        Start := FromPage - 1;
                        Stop := ToPage - 1;
                      end;
                  else
                    exit;
                  end;

                  Printer.Title := Application.Title;
                  Printer.BeginDoc;
                  for j := 1 to Copies do
                    for i := Start to Stop do
                      begin
                        fStatusBar.Panels[3].Text := Format('Printing page %d of copy %d', [i + 1, j]);

                        Printer.Canvas.Draw(0, 0, fMeta[i].Page);
                        { TODO -oVeg -cBugreport :
                        Calls TStatusBar.SimpleText and then line 415 of this unit
                        Seems like Meta isn't valid yet. }
                        if not ((i = Stop) and (j = Copies)) then
                          Printer.NewPage;
                      end;
                  Printer.EndDoc;

                  fPaintBox.Invalidate;                                         //Force a full repaint or dialog might leave an artifact

                  fStatusBar.Panels[3].Text := 'Ready printing';
                end;
            end;
        end;                                                                    //poPrint
    end;                                                                        //case
end;

{-----------------------------------------------------------}

procedure TNxPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
    fDialog.Close
  else
    inherited;
end;

{-----------------------------------------------------------}

function TNxPreview.GetBody: TRect;
begin
  Result := Rect(Header.Left, Header.Top,
    Footer.Right, Footer.Bottom);

  if (pdLeftMargin in fPrintItems) then
    Inc(Result.Left, LeftMargin);

  if (pdHeader in fPrintItems) then
    Result.Top := Header.Bottom;

  if (pdFooter in fPrintItems) then
    Result.Bottom := Footer.Top;
end;

function TNxPreview.GetBodyHeight: Integer;
begin
  Result := Body.Bottom - Body.Top;
end;

function TNxPreview.GetBodyWidth: Integer;
begin
  Result := Body.Right - Body.Left;
end;

function TNxPreview.GetCaption: string;
begin
  if Assigned(fDialog) then
    Result := fDialog.Caption;
end;

{-----------------------------------------------------------}

function TNxPreview.GetCharHeight: Integer;
begin
  if (fMeta.Count > Pred(CurrentPage)) then
    Result := fMeta[Pred(CurrentPage)].CharHeight
  else
    Result := 0;
end;

{-----------------------------------------------------------}

function TNxPreview.GetCharWidth: Integer;
begin
  if (fMeta.Count > Pred(CurrentPage)) then
    Result := fMeta[Pred(CurrentPage)].CharWidth
  else
    Result := 0;
end;

{-----------------------------------------------------------}

function TNxPreview.GetCurrentPage: Integer;
begin
  Result := fPageSpinner.AsInteger;
end;

{-----------------------------------------------------------}

function TNxPreview.GetFooter: TRect;
begin
  Result := Rect(0, PageHeight, PageWidth, PageHeight);

  if (pdFooter in fPrintItems) then
    Dec(Result.Top, 4 * CharHeight);
end;

{-----------------------------------------------------------}

function TNxPreview.GetFormName: string;
var
  Device                        : array[0..Pred(1024)] of Char;                 //See Printer.SetToDefaultPrinter
  Driver                        : array[0..Pred(MAX_PATH)] of Char;
  Port                          : array[0..32] of Char;
  hDeviceMode                   : THandle;
  PDMode                        : PDEVMODE;
begin
  with Printer do
    if (Printers.Count > 0) and InRange(PrinterIndex, 0, Pred(Printers.Count)) then
      try
        ZeroMemory(@Device, SizeOf(Device));
        ZeroMemory(@Driver, SizeOf(Driver));
        ZeroMemory(@Port, SizeOf(Port));
        hDeviceMode := 0;
        GetPrinter(Device, Driver, Port, hDeviceMode);
        if hDeviceMode <> 0 then
          begin
            pDMode := GlobalLock(hDeviceMode);
            if pDMode <> nil then
              try
                if ((pDMode^.dmFields and dm_FormName) = dm_FormName) then
                  Result := PChar(@(pDMode^.dmFormName))
                else if ((pDMode^.dmFields and DM_DEFAULTSOURCE) = DM_DEFAULTSOURCE) then
                  Result := 'Default'
                else
                  Result := '';
              finally
                GlobalUnlock(hDeviceMode);
              end;
          end;
      except
        { Nothing }
      end;
end;

{-----------------------------------------------------------}

function TNxPreview.GetHeader: TRect;
begin
  Result := Rect(0, 0, PageWidth, 0);

  if (pdHeader in fPrintItems) then
    Inc(Result.Bottom, 4 * CharHeight);
end;

{-----------------------------------------------------------}

function TNxPreview.GetHorizontalPageResolution: Integer;
begin
  Result := DoGetPrinterCap(LOGPIXELSX);
end;

{-----------------------------------------------------------}

function TNxPreview.GetHorizontalScreenResolution: Integer;
begin
  Result := DoGetScreenCap(LOGPIXELSX);
end;

{-----------------------------------------------------------}

function TNxPreview.GetInstanceCount: Integer;
begin
  Result := GlobalInstanceCount;
end;

{-----------------------------------------------------------}

function TNxPreview.GetJobs: Integer;

//Based on code of  P. Below [TeamB]

  function A2S(p: {$IFDEF VER200}PWideChar{$ELSE}PAnsiChar{$ENDIF}): string;
  const
    error                       = 'n/a';
  begin
    if not Assigned(p) then
      Result := error
    else
      Result := string(p);
  end;

  function GetCurrentPrinterHandle: THandle;
  var
    Device                      : array[0..Pred(1024)] of Char;                 //See Printer.SetToDefaultPrinter
    Driver                      : array[0..Pred(MAX_PATH)] of Char;
    Port                        : array[0..32] of Char;
    hDeviceMode                 : THandle;
  begin
    with Printer do
      if (Printers.Count > 0) and InRange(PrinterIndex, 0, Pred(Printers.Count)) then
        try
          ZeroMemory(@Device, SizeOf(Device));
          ZeroMemory(@Driver, SizeOf(Driver));
          ZeroMemory(@Port, SizeOf(Port));
          hDeviceMode := 0;
          GetPrinter(Device, Driver, Port, hDeviceMode);
          if (hDeviceMode = 0) or not OpenPrinter(@Device, Result, nil) then
            Result := INVALID_HANDLE_VALUE;
        except
          Result := INVALID_HANDLE_VALUE;
        end;
  end;

var
  hPrinter                      : THandle;
  bytesNeeded,
    numJobs                     : Cardinal;
  PJob                          : ^JOB_INFO_1;
begin
  Result := 0;

  hPrinter := GetCurrentPrinterHandle;
  if (hPrinter <> INVALID_HANDLE_VALUE) then
    try
      EnumJobs(hPrinter, 0, 1, 1, nil, 0, bytesNeeded,
        numJobs);
      PJob := AllocMem(bytesNeeded);

      while EnumJobs(hPrinter, Result, 1, 1, PJob, bytesNeeded,
        bytesNeeded, numJobs) and (numJobs = 1) do
        begin
          Inc(Result);                                                          //PJob^ contains the Spooler Entries.
          if Assigned(fOnJob) then
            with PJob^ do
              fOnJob(Self, Result, A2S(pPrinterName), A2S(pMachineName), A2S(pUserName), A2S(pDocument), A2S(pDatatype), A2S(pStatus));
        end;
    finally
      ClosePrinter(hPrinter);
    end;
end;

{-----------------------------------------------------------}

function TNxPreview.GetLeftMargin: Integer;
begin
  if (pdLeftMargin in PrintItems) then
    Result := 6 * CharWidth
  else
    Result := 0;
end;

function TNxPreview.GetMargin: TRect;
begin
  Result := Rect(0, Header.Top,
    LeftMargin, Footer.Bottom);

  if (pdHeader in fPrintItems) then
    Result.Top := Header.Bottom;

  if (pdFooter in fPrintItems) then
    Result.Bottom := Footer.Top;
end;

{-----------------------------------------------------------}

function TNxPreview.GetLineHeight: Integer;
begin
  if (fMeta.Count > Pred(CurrentPage)) then
    Result := fMeta[Pred(CurrentPage)].LineHeight
  else
    Result := 0;
end;

{-----------------------------------------------------------}

function TNxPreview.GetPageHeight: Integer;
begin
  Result := DoGetPrinterCap(VERTRES);
end;

{-----------------------------------------------------------}

function TNxPreview.GetPageWidth: Integer;
begin
  Result := DoGetPrinterCap(HORZRES);
end;

{-----------------------------------------------------------}

function TNxPreview.GetPaperSize: Integer;
var
  Device                        : array[0..Pred(1024)] of Char;                 //See Printer.SetToDefaultPrinter
  Driver                        : array[0..Pred(MAX_PATH)] of Char;
  Port                          : array[0..32] of Char;
  hDeviceMode                   : THandle;
  PDMode                        : PDEVMODE;
begin
  Result := DMPAPER_USER;
  with Printer do
    if (Printers.Count > 0) and InRange(PrinterIndex, 0, Pred(Printers.Count)) then
      try
        ZeroMemory(@Device, SizeOf(Device));
        ZeroMemory(@Driver, SizeOf(Driver));
        ZeroMemory(@Port, SizeOf(Port));
        hDeviceMode := 0;
        GetPrinter(Device, Driver, Port, hDeviceMode);
        if hDeviceMode <> 0 then
          begin
            pDMode := GlobalLock(hDeviceMode);
            if pDMode <> nil then
              try
                Result := pDMode^.dmPaperSize;
              finally
                GlobalUnlock(hDeviceMode);
              end;
          end;
      except
        { Nothing }
      end;
end;

{-----------------------------------------------------------}

function TNxPreview.GetPhysicalPageHeight: Integer;
begin
  Result := DoGetPrinterCap(PHYSICALHEIGHT);
end;

{-----------------------------------------------------------}

function TNxPreview.GetPhysicalPageOffsetX: Integer;
begin
  Result := DoGetPrinterCap(PHYSICALOFFSETX);
end;

{-----------------------------------------------------------}

function TNxPreview.GetPhysicalPageOffsetY: Integer;
begin
  Result := DoGetPrinterCap(PHYSICALOFFSETY);
end;

{-----------------------------------------------------------}

function TNxPreview.GetPhysicalPageWidth: Integer;
begin
  Result := DoGetPrinterCap(PHYSICALWIDTH);
end;

{-----------------------------------------------------------}

function TNxPreview.GetPrintInColor: Boolean;
var
  Device                        : array[0..Pred(1024)] of Char;                 //See Printer.SetToDefaultPrinter
  Driver                        : array[0..Pred(MAX_PATH)] of Char;
  Port                          : array[0..32] of Char;
  hDeviceMode                   : THandle;
  PDMode                        : PDEVMODE;
begin
  Result := False;
  with Printer do
    if (Printers.Count > 0) and InRange(PrinterIndex, 0, Pred(Printers.Count)) then
      try
        ZeroMemory(@Device, SizeOf(Device));
        ZeroMemory(@Driver, SizeOf(Driver));
        ZeroMemory(@Port, SizeOf(Port));
        hDeviceMode := 0;
        GetPrinter(Device, Driver, Port, hDeviceMode);
        if hDeviceMode <> 0 then
          begin
            pDMode := GlobalLock(hDeviceMode);
            if pDMode <> nil then
              try
                //Check also if the Colorfield is Initialized by the Printer.
                Result := ((pDMode^.dmFields and dm_Color) = dm_Color) and (pDMode^.dmColor = DMCOLOR_COLOR);
              finally
                GlobalUnlock(hDeviceMode);
              end;
          end;
      except
        { Nothing }
      end;
end;

{-----------------------------------------------------------}

function TNxPreview.GetVerticalPageResolution: Integer;
begin
  Result := DoGetPrinterCap(LOGPIXELSY);
end;

{-----------------------------------------------------------}

function TNxPreview.GetVerticalScreenResolution: Integer;
begin
  Result := DoGetScreenCap(LOGPIXELSY);
end;

{-----------------------------------------------------------}

function TNxPreview.GetVisible: Boolean;
begin
  Result := Assigned(fDialog) and fDialog.Visible;
end;

{-----------------------------------------------------------}

procedure TNxPreview.Loaded;
begin
  LoadSettings;

  inherited;
end;

procedure TNxPreview.LoadSettings;
var
  ini                           : TIniFile;
  i                             : Integer;
begin
  //Setup Calculated Properties.

  //Make sure we got default (non-zero) values!
  //Otherwise we get a divide by 0 when changing XP themes when
  //preview dialog hasn't been used yet.

  //New error on winxp! Crashes when network printer is not available!
  if Assigned(Printer.Printers) and (Printer.Printers.Count > 0) then
    try
      ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

      Printer.PrinterIndex := -1;                                               //veg:26-6-2007 - Start with Default one in case the Selected one is no longer..
      for i := 0 to Pred(Printer.Printers.Count) do
        if CompareText(Printer.Printers[i], ini.ReadString('Printer', 'Selected', '')) = 0 then
          Printer.PrinterIndex := i;

      Printer.Orientation := TPrinterOrientation(ini.ReadInteger('Printer', 'Orientation', Ord(Printer.Orientation)));

      if ini.ReadBool('Printer', 'Header', True) then
        Include(fPrintItems, pdHeader);

      if ini.ReadBool('Printer', 'Footer', True) then
        Include(fPrintItems, pdFooter);

      if ini.ReadBool('Printer', 'Perforator', True) then
        Include(fPrintItems, pdPerforator);

      if ini.ReadBool('Printer', 'LeftMargin', True) then
        Include(fPrintItems, pdLeftMargin);

      if ini.ReadBool('Printer', 'Areas', True) then
        Include(fPrintItems, pdAreas);

      PrintInColor := ini.ReadBool('Printer', 'Color', PrintInColor);

      FreeAndNil(ini);

      fStatusBar.Panels[0].Text := Format('Page %d of %d', [CurrentPage, fMeta.Count]);
      fStatusBar.Panels[1].Text := Printer.Printers[Printer.PrinterIndex];
      fStatusBar.Panels[2].Text := GetFormName;
      fStatusBar.Panels[3].Text := '';

      SaveSettings;

      fPaintBox.OnPaint := PaintBoxPaint;
      fDialog.OnResize := DialogResize;

      DoZoom(0);
    except
      //ShowMessage('Printer seems unavailable, printing will be disabled.');
    end;

end;

{-----------------------------------------------------------}

procedure TNxPreview.NewPage;
begin
  //Seems to be neccesary to be able to paint it.
  MetaCanvas.Free;

  fMeta.Add;                                                                    //Add next page
  fPrintBtn.Enabled := fMeta.Count > 0;
  fPageSpinner.Max := Pred(fMeta.Count);

  CurrentPage := CurrentPage + 1;

  MetaCanvas := TNxMetaFileCanvas.Create(fMeta[CurrentPage], Printer.Handle);

  DoDrawDecoration(Self);
end;

{-----------------------------------------------------------}

procedure TNxPreview.PageSpinnerChange(Sender: TObject);
begin
  CurrentPage := fPageSpinner.AsInteger;

  if Visible then
    fPaintBox.Invalidate;
end;

{-----------------------------------------------------------}

procedure TNxPreview.PaintBoxPaint(Sender: TObject);

  function PrintertoScreen(p: TPoint): TPoint;
  begin
    Result := Point(ScreenWidth * (PhysicalPageOffsetX + p.X) div PhysicalPageWidth,
      ScreenHeight * (PhysicalPageOffsetY + p.Y) div PhysicalPageHeight + vOffset)
  end;

var
  lt, rb                        : TPoint;
begin
  if fDialog.Visible and Assigned(Printer.Printers) and (Printer.Printers.Count > 0) then
    begin
      with fPaintBox.Canvas do
        begin
          //Beware 0,0 w,h are relative to metafile = printable area
          lt := PrintertoScreen(Point(-PhysicalPageOffsetX, -PhysicalPageOffsetY));
          rb := PrintertoScreen(Point(PhysicalPageWidth, PhysicalPageHeight));

          //Totally white background please...
          Brush.Color := clWhite;
          Brush.Style := Graphics.bsSolid;
          FillRect(Rect(lt.X, lt.Y, rb.X, rb.Y));

          //Clear & Shade non-printable area
          Brush.Color := clGray;
          Brush.Style := bsBDiagonal;
          Rectangle(Rect(lt.X, lt.Y, rb.X, rb.Y));

          //Draw a rectangle around the paper.
          Brush.Color := clGray;
          Brush.Style := Graphics.bsSolid;
          FrameRect(Rect(lt.X, lt.Y, rb.X, rb.Y));

          //Clear the prinatble area
          Brush.Color := clWhite;
          Brush.Style := Graphics.bsSolid;
          Pen.Color := clGray;
          Pen.Style := psSolid;
          lt := PrintertoScreen(Point(0, 0));
          rb := PrintertoScreen(Point(PageWidth, PageHeight));
          FillRect(Rect(lt.X, lt.Y, rb.X, rb.Y));

          //Do the page to be printed here
          lt := PrintertoScreen(Point(0, 0));
          rb := PrintertoScreen(Point(PageWidth, PageHeight));
          if (fMeta.Count > 0) and (CurrentPage > 0) and (CurrentPage <= fMeta.Count) then
            StretchDraw(Rect(lt.X, lt.Y, rb.X, rb.Y), fMeta[Pred(CurrentPage)].Page);

          //Add an outline of where the print area will be
          Brush.Color := clGray;
          Brush.Style := bsClear;
          Pen.Color := clGray;
          Pen.Style := psDot;
          lt := PrintertoScreen(Point(0, 0));
          rb := PrintertoScreen(Point(PageWidth, PageHeight));
          Rectangle(lt.X, lt.Y, rb.X, rb.Y);

          //Draw area markers
          if (pdAreas in fPrintItems) and not (csDesigning in ComponentState) then
            begin
              Brush.Color := clLtGray;
              Brush.Style := Graphics.bsSolid;
              Pen.Style := psSolid;
              Pen.Color := clLtGray;

              if (fMeta.Count > 0) and (pdLeftmargin in PrintItems) and not (csDesigning in ComponentState) then
                begin
                  lt := PrintertoScreen(Point(Body.Left, Body.Top));
                  rb := PrintertoScreen(Point(Body.Left, Body.Bottom));
                  MoveTo(lt.X, lt.Y);
                  LineTo(rb.X, rb.Y);
                end;
              lt := PrintertoScreen(Header.TopLeft);
              rb := PrintertoScreen(Header.BottomRight);
              MoveTo(lt.X, rb.Y);
              LineTo(rb.X, rb.Y);

              lt := PrintertoScreen(Footer.TopLeft);
              rb := PrintertoScreen(Footer.BottomRight);

              MoveTo(lt.X, lt.Y);
              LineTo(rb.X, lt.Y);
            end;
        end;

      //Paint a page number below..
      if fMeta.Count = 0 then
        fStatusBar.Panels[0].Text := 'No Pages'
      else
        fStatusBar.Panels[0].Text := Format('Page %d of %d', [CurrentPage, fMeta.Count]);
    end;
end;

{-----------------------------------------------------------}

procedure TNxPreview.PrintBtnClick(Sender: TObject);
var
  Start,
    Stop,
    i, j                        : Integer;
begin
  if not Assigned(Printer.Printers) or (Printer.Printers.Count = 0) then
    begin
      ShowMessage('No Printer installed, can''t print.');
      Exit;
    end;

  PrintDlgCaption := ChangeFileExt(ExtractFileName(Application.ExeName), '') + ' - print report';

  fPrintDialog.Options := [poPageNums, poHelp, poWarning];

  fPrintDialog.MinPage := 1;
  fPrintDialog.MaxPage := Max(1, fMeta.Count);

  fPrintDialog.FromPage := fPrintDialog.MinPage;
  fPrintDialog.ToPage := fPrintDialog.MaxPage;

  if (fPrintDialog.Execute) then
    begin
      fStatusBar.Panels[1].Text := Printer.Printers[Printer.PrinterIndex];

      with fPrintDialog do
        {----See what we've selected}
        begin
          case PrintRange of
            prAllPages:
              begin
                Start := MinPage - 1;
                Stop := MaxPage - 1;
              end;
            prPageNums:
              begin
                Start := FromPage - 1;
                Stop := ToPage - 1;
              end;
          else
            exit;
          end;

          Printer.Title := Application.Title;
          Printer.BeginDoc;
          for j := 1 to Copies do
            for i := Start to Stop do
              begin
                fStatusBar.Panels[3].Text := Format('Printing page %d of copy %d', [i + 1, j]);
                Printer.Canvas.Draw(0, 0, fMeta[i].Page);
                if not ((i = Stop) and (j = Copies)) then
                  Printer.NewPage;
              end;
          Printer.EndDoc;
          fStatusBar.Panels[3].Text := 'Ready printing';
        end;
    end;
end;

{-----------------------------------------------------------}

procedure TNxPreview.PrintDialogShow(Sender: TObject);
begin
{$WARNINGS OFF}
  SetWindowText(fPrintDialog.Handle, PChar(PrintDlgCaption));
{$WARNINGS ON}
end;

procedure TNxPreview.PrintText(const Lines: TStrings; const WrapText: Boolean =
  True);

  procedure Newline;
  begin
    MetaCanvas.MoveTo(Body.Left, MetaCanvas.PenPos.Y + LineHeight);
    if MetaCanvas.PenPos.Y > Body.Bottom then
      begin
        NewPage;
        MetaCanvas.MoveTo(Body.Left, Body.Top + LineHeight);
      end;
  end;

var
  l                             : string;
  s                             : string;
  i                             : Integer;
begin
  BeginDoc;
  
  MetaCanvas.MoveTo(Body.Left, Body.Top + LineHeight);

  for i := 0 to pred(Lines.Count) do
    begin
      l := Lines[i];

      if (MetaCanvas.TextWidth(l) > (Body.Right - Body.Left - CharWidth)) then
        repeat
          s := '';
          while (length(l) > 0) and (MetaCanvas.TextWidth(s) < (Body.Right - Body.Left) - CharWidth) do
            begin
              s := s + l[1];
              Delete(l, 1, 1);
            end;

          MetaCanvas.TextOut(MetaCanvas.PenPos.X, MetaCanvas.PenPos.Y, s);
          NewLine;
        until (Length(l) = 0) or not WrapText
      else
        begin
          MetaCanvas.TextOut(MetaCanvas.PenPos.X, MetaCanvas.PenPos.Y, l);
          NewLine;
        end;
    end;

  EndDoc;
end;

{-----------------------------------------------------------}

procedure TNxPreview.ReportBtnClick(Sender: TObject);
begin
  if (Assigned(fOnRender) and Assigned(fOnReportSetup) and fOnReportSetup(Sender)) then
    begin
      //First page is safe....
      fPageSpinner.AsInteger := 1;

      fOnRender(Self);

      fZoomInBtn.Enabled := True;
      fZoomOutBtn.Enabled := False;

      fPageSpinner.Max := fMeta.Count;

      DoZoom(0);

      CurrentPage := 1;                                                         //Make sure we end up on page 1
    end;
end;

{-----------------------------------------------------------}

procedure TNxPreview.ResetPrinter;
var
  Device                        : array[0..Pred(1024)] of Char;                 //See Printer.SetToDefaultPrinter
  Driver                        : array[0..Pred(MAX_PATH)] of Char;
  Port                          : array[0..32] of Char;
  DevMode                       : THandle;
begin
  try
    Printer.GetPrinter(Device, Driver, Port, DevMode);
    Printer.SetPrinter(Device, Driver, Port, 0)
  except
    { Nothing }
  end;
end;

procedure TNxPreview.SaveSettings;
var
  ini                           : TIniFile;
begin
  if Assigned(Printer.Printers) and (Printer.Printers.Count > 0) then
    try
      ini := TIniFile.Create(Settings);

      ini.WriteString('Printer', 'Selected', Printer.Printers[Printer.PrinterIndex]);
      ini.WriteInteger('Printer', 'Orientation', Ord(Printer.Orientation));
      ini.WriteBool('Printer', 'Header', pdHeader in fPrintItems);
      ini.WriteBool('Printer', 'Footer', pdFooter in fPrintItems);
      ini.WriteBool('Printer', 'Perforator', pdPerforator in fPrintItems);
      ini.WriteBool('Printer', 'LeftMargin', pdLeftMargin in fPrintItems);
      ini.WriteBool('Printer', 'Color', PrintInColor);
      ini.WriteInteger('Printer', 'PaperSize', PaperSize);
      if (FormName <> '') then
        ini.WriteString('Printer', 'FormName', FormName)
      else if ini.ValueExists('Printer', 'FormName') then
        ini.DeleteKey('Printer', 'FormName');

      ini.UpdateFile;
      FreeAndNil(ini);
    except
      //ShowMessage('Printer seems unavailable, printing will be disabled.');
    end;
end;

procedure TNxPreview.SetCaption(const Value: string);
begin
  if Assigned(fDialog) then
    fDialog.Caption := Value;
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetCurrentPage(const Value: Integer);
begin
  if (FPageSpinner.AsInteger <> Value) then
    begin
      fPageSpinner.AsInteger := Value;

      if Visible then
        fPaintBox.Invalidate;
    end;
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetFormName(const Value: string);
begin
  //Read-Only Property
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetInstanceCount(const Value: Integer);
begin
  //Read-Only property
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetJobs(const Value: Integer);
begin
  //Read-Only Property
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetPaperSize(const Value: Integer);
var
  Device                        : array[0..Pred(1024)] of Char;                 //See Printer.SetToDefaultPrinter
  Driver                        : array[0..Pred(MAX_PATH)] of Char;
  Port                          : array[0..32] of Char;
  hDeviceMode                   : THandle;
  PDMode                        : PDEVMODE;
begin
  with Printer do
    if (Printers.Count > 0) and InRange(PrinterIndex, 0, Pred(Printers.Count)) then
      try
        ZeroMemory(@Device, SizeOf(Device));
        ZeroMemory(@Driver, SizeOf(Driver));
        ZeroMemory(@Port, SizeOf(Port));
        hDeviceMode := 0;
        GetPrinter(Device, Driver, Port, hDeviceMode);
        if hDeviceMode <> 0 then
          begin
            pDMode := GlobalLock(hDeviceMode);
            if pDMode <> nil then
              try
                pDMode^.dmPaperSize := Value;
                pDMode^.dmFields := pDMode^.dmFields or DM_PAPERSIZE;           //Signal PaperSize is Initialized
              finally
                GlobalUnlock(hDeviceMode);
              end;
          end;
      except
        { Nothing }
      end;
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetPrintInColor(const Value: Boolean);
var
  Device                        : array[0..Pred(1024)] of Char;                 //See Printer.SetToDefaultPrinter
  Driver                        : array[0..Pred(MAX_PATH)] of Char;
  Port                          : array[0..32] of Char;
  hDeviceMode                   : THandle;
  PDMode                        : PDEVMODE;
begin
  with Printer do
    if (Printers.Count > 0) and InRange(PrinterIndex, 0, Pred(Printers.Count)) then
      try
        ZeroMemory(@Device, SizeOf(Device));
        ZeroMemory(@Driver, SizeOf(Driver));
        ZeroMemory(@Port, SizeOf(Port));
        hDeviceMode := 0;
        GetPrinter(Device, Driver, Port, hDeviceMode);
        if hDeviceMode <> 0 then
          begin
            pDMode := GlobalLock(hDeviceMode);
            if pDMode <> nil then
              try
                case Value of
                  True: pDMode^.dmColor := DMCOLOR_COLOR;
                  False: pDMode^.dmColor := DMCOLOR_MONOCHROME;
                end;
                pDMode^.dmFields := pDMode^.dmFields or dm_Color;               //Signal the ColorField is Initialized.
              finally
                GlobalUnlock(hDeviceMode);
              end;
          end;
      except
        { Nothing }
      end;
end;

procedure TNxPreview.SetPrintItems(const Value: TNxPrintItems);
begin
  FPrintItems := Value;

  SaveSettings;
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetReportSetup(const Value: TNxReportSetupEvent);
begin
  FOnReportSetup := Value;
  fReportBtn.Enabled := Assigned(FOnReportSetup);
end;

procedure TNxPreview.SetSettings(const Value: string);
begin
  FSettings := Value;

  SaveSettings;
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetupBtnClick(Sender: TObject);
begin
  Execute(poPrintSetup);
end;

{-----------------------------------------------------------}

procedure TNxPreview.SetVisible(const Value: Boolean);
begin
  if Assigned(fDialog) then
    fDialog.Visible := Value;
end;

{-----------------------------------------------------------}

procedure TNxPreview.WMSpoolerStatus(var Msg: TWMSpoolerStatus);
begin
  OutputDebugString(PChar('Now in the spooler a ' + IntToStr(msg.JobsLeft) + ' jobs'));
  msg.Result := 0;
end;

{-----------------------------------------------------------}

procedure TNxPreview.ZoomInClick(Sender: TObject);
begin
  if not (fZoomOutBtn.Enabled) then
    begin
      fZoomOutBtn.Enabled := True;
      DoZoom(1);
    end
  else
    begin
      fZoomInBtn.Enabled := False;
      DoZoom(2);
    end;
end;

{-----------------------------------------------------------}

procedure TNxPreview.ZoomOutClick(Sender: TObject);
begin
  if not (fZoomInBtn.Enabled) then
    begin
      fZoomInBtn.Enabled := True;
      DoZoom(1);
    end
  else
    begin
      fZoomOutBtn.Enabled := False;
      DoZoom(0);
    end;
end;

end.
