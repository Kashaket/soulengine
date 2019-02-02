{-------------------------------------------------------------}
{----Purpose : ProgressForm like MS Installation Progress     }
{    By      : Ir. G.W. van der Vegt                          }
{    For     : Myself                                         }
{-------------------------------------------------------------}
{ ddmmyy comment                                              }
{ ------ -----------------------------------------------------}
{ 21021999-Initial version.                                   }
{ 22021999-Turned into a dynamical form, created from a vcl.  }
{         -Removed richedit control and started painting      }
{          into the canvas directly.                          }
{ 26021999-Renamed to Progress.                               }
{ 02031999-Fixed always showing of component and it becoming  }
{          the apps mainform (because it was the first call   }
{          to Application.CreateForm). Now use                }
{          TForm.CreateNew instead. Also removed call to      }
{          FForm.Show.                                        }
{         -Also fixed dual dialogs and protection fault when  }
{          form was visible at designtime.                    }
{         -Removed creation of ImageList.                     }
{         -Moved images to upper left corner.                 }
{         -Added bullets.                                     }
{         -Adjusted font and linespacing so it looks like     }
{          the microsoft setup one.                           }
{         -Added Height and Width of form.                    }
{         -Added Top and Left of form.                        }
{         -Moved screen painting code to onpaint handler.     }
{         -Added caption and title.                           }
{         -Prevented white bitmaps when ImageList had less    }
{          items than there were lines on the screen.         }
{         -Aligned bitmap with title.                         }
{ 03031999-Fixed no images at initial show. Was caused by     }
{          the fact that there was no setimagelist procedure  }
{          that repainted the form.                           }
{         -Added and removed offset, didn't work as expected. }
{          first line and image now (again) dependend on      }
{          font size.                                         }
{         -Corrected shifting of vcl placeholder when         }
{          recompiling it by renaming left,top,width and      }
{          height. Perhaps rename some more like progress,    }
{          min,max and position.                              }
{         -Added AutoSize. Still not 100% perfect if          }
{          various parts are missing (like text).             }
{         -Added AlwaysOnTop                                  }
{ 10041999-Added option to have a single image for all steps. }
{ 07101999-Added a prompt button, well actually a panel       }
{          because it looks better.                           }
{          Showing and Hiding of the Panel is still a bit     }
{          tricky.                                            }
{ 28022002-Added Read-only Form Property so we can access     }
{          sendtoback/bringtfront.                            }
{ 15052001-Added polling eventhandler for waitprompt.         }
{ 28502001-Renamed Pressed and Down to fPressed and fDown     }
{          and added Pressed and Down read-only properties.   }
{ 29062001-Changed TPanel into a TFlatButton (same look but   }
{          responds to keyboard as well).                     }
{         -Added Cancelled property, set when Esc is pressed. }
{ 21032002-Added code to destructor to elimate resourceleaks. }
{ 14072002-Added Form Handle Property.                        }
{ 07102003-Added support for transparent Images.              }
{         -Added OffsetX and OffsetY for placing the Image.   }
{ 01122003-Added Optional Transparency when inactive.         }
{         -Added Bevel property to disable bevel when themed. }
{         -Minimized use of Transparency when Percentage is 0.}
{         -Repaired Prompt Placement.                         }
{ 23092004-Removed all defines so it's effectively VERSION6.  }
{         -Added a Cancel Button.                             }
{         -Changed WaitPrompt into a function returning false }
{          if Cancelled.                                      }
{         -Added an Arrow between the Progress and Buttons.   }
{         -Moved OkBtn.SetFocus from ShowButtons to           }
{          WaitPrompt. CannotFocus bug is now gone.           }
{         -Switched to D7's AlphaBlending.                    }
{ 24092004-Added Ok & CancelCaption so the buttons can be     }
{          made to look like Yes & No.                        }
{ 16122004-Safeguarded foxussing ok button so pressing        }
{          cancel doesn't give a focussing error.             }
{ 03022007-Added Options instead of Booleans.                 }
{         -Recoded logic a bit so arrows are only shown when  }
{          appropriate.                                       }
{         -Aligned Button.                                    }
{         -Added ButtonWidth property.                        }
{         -Removed old TPanel Code.                           }
{         -Made sure buttonclick visually presses the buttons.}
{ 05022007-Disabled poAnimate code (faded from black somehow).}
{         -Added ImageIndex property to select Image when     }
{          poFixedImage is in Options.                        }
{          Otherwise the progress is used for the ImageIndex  }
{          of the Images.                                     }
{         -Made sure the buttons are always visible at        }
{          designtime to prevent focussing errors.            }
{         -Introduced an overloaded version of WaitPrompt.    }
{         -Added poShowPrompt to TNxProgressOption.           }
{         -Looked into OffsetX/Y, it's the position of the    }
{          Image.                                             }
{         -Added SendToBack and BringToFront.                 }
{ 14052007-Swapped FOptions for Option in WaitPrompt routines }
{          so the Progress dialog gets repainted when         }
{          restoring Options,                                 }
{ 15052007-Fixed poAnimate mode.                              }
{ 09062007-Fixed long standing problem with XpManifest and    }
{          ProgressBar.                                       }
{         -This problem also occured on Vista.                }
{ 27062007-Removed a application.provessmessages after the    }
{          waitprompt is finished. This probably lead to      }
{          race conditions where the application continued    }
{          without properly finishing the waitprompt          }
{          procedure call.                                    }
{ 06082007-Did some serious rework on the DoWaitPrompt. It    }
{          was possible to close the dialog when the loop was }
{          still waiting. Now ShowModal is mimic'ed a bit     }
{          so it's not possible to create havoc in other      }
{          windows.                                           }
{          Tested a TTimer in the mainform and it keeps       }
{          running nicely.                                    }
{         -Note: this changes the behaviour and need to be    }
{          tested in applications.                            }
{ 07082007-Changed the Show code a bit. The window however    }
{          is still black on the Zune Theme between the Show  }
{          and the RealignButtons call.                       }
{ 18092007-Repaired bug in SetVisible.                        }
{         -Added poModal to Options. Uses the new Pseudomodal }
{          code.                                              }
{         -Renamed DoWaitPrompt work routine to               }
{          InternalWaitPrompt.                                }
{         -Fixed pressing space when cancel button is         }
{          focussed.                                          }
{         -Added Color Property and set Color and             }
{          TransparentColorValue accordingly.                 }
{         -Swapped TNXButton.KeyPressed for KeyUp as this     }
{          one can stop the key pressed from reaching the     }
{          main application.                                  }
{         -Disabled TProgressBar to prevent focus.            }
{ 19022008-Rearranged show code to call SetVisible.           }
{         -Rearranged transparent code to get rid of black    }
{          colored paint of window the first time it's shown. }
{ 22042008-Added Next/Previous/First/Last/None.               }
{ 23042008-Addded NextIf.                                     }
{         -Added Increment/Decrement.                         }
{ 01052008-Added WaitPrompt with a Callback function to allow }
{          the application to press the Ok/Cancel Buttons.    }
{ 14072008-Changed Waitprompt logic a bit. The Internal one   }
{          now adds poShowButtons and thus forces the         }
{          visibility of at least the Ok button.              }
{         -Corrected a nasty DEFINE bug in InternalWaitPrompt }
{          preventing the non modal from working.             }
{         -Combined WaitPrompt calls into a single one with   }
{          added and substaracted options.                    }
{         -Added support for enabling and disabling mainform  }
{          on hide/show so no interaction can take place      }
{          outside the NxProgress form.                       }
{ 15072008-Added LineChanged Code so the form is repainted    }
{          properly when a line is changed.                   }
{ 08092008-New Input Code added (poShowInput).                }
{         -Changed MODAL define code.                         }
{         -Changed AlwaysOnTop Code a bit (always call win32).}
{-------------------------------------------------------------}
{ Todo :                                                      }
{ 1. Execute Method...                                        }
{    Together with a callback that signals the position?      }
{ 2. Still some small problem with Initial Transparent Mode.  }
{ 3. Small repaint error in cancel button when waitprompt     }
{    is used for the second time.                             }
{ 4. NOTE: TnxFocus also walks the dialog.                    }
{-------------------------------------------------------------}

  {----Old Code:
    var
       fUser32Dll: HMODULE;

    fUser32dll := LoadLibrary('USER32.DLL');
    if fUser32dll <> 0 then
      @_SetLayeredWindowAttributes := GetProcAddress(fUser32dll, 'SetLayeredWindowAttributes')
    else
      _SetLayeredWindowAttributes := nil;
  }

  {----Old Code:
    if Assigned(_SetLayeredWindowAttributes) and IsWindow(Handle) then
      begin
        old := GetWindowLongA(Handle, GWL_EXSTYLE);
        SetWindowLongA(Handle, GWL_EXSTYLE, old or WS_EX_LAYERED);
        _SetLayeredWindowAttributes(Handle, 0, (255 * (100 - Value)) div 100, LWA_ALPHA)
      end;
  }

unit NxProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ImgList, Math, NxEdit, NxCollection;

{-------------------------------------------------------------}

{$DEFINE ANIMATE}
{$IFDEF ANIMATE}
{$MESSAGE HINT 'TNxProgress Compiled with Fading Animation Option.'}
{$ENDIF ANIMATE}
{$DEFINE MODAL}
{$IFDEF MODAL}
{$MESSAGE HINT 'TNxProgress Compiled with Modal Emulation Option.'}
{$ENDIF MODAL}

type
  TNxProgressNotifyEvent = procedure(Sender: TObject; const tag: Integer; var Pressed: Boolean) of object;

  TNxProgressOption = (poAllowCancel, poShowButtons, poShowArrow, poShowPrompt, poFixedImage{$IFDEF ANIMATE}, poAnimate{$ENDIF ANIMATE}{$IFDEF MODAL}, poModal{$ENDIF MODAL}, poDisableMainForm, poShowEdit);
  TNxProgressOptions = set of TNxProgressOption;

  TNxProgress = class(TComponent)
  private
    FAlphaBlendValue: Byte;
    FAlphaDelayValue: Integer;
    FAlwaysOnTop: Boolean;
    FAnimate: Boolean;                                                          //Animate transparancy when focus changes.
    FAutoSize: Boolean;
    FButtonWidth: Integer;
    FCancel: TNxButton;                                                         //The Buttons
    FForm: TForm;                                                               //The Tricky VCL Form.
    FImageIndex: Integer;
    FImageList: TImageList;                                                     //The Images for the Textlines
    FIsCancelled: Boolean;
    FIsDown: Boolean;
    FLines: TStringList;                                                        //Textlines
    FOffsetX: Integer;
    FOffsetY: Integer;
    FOk: TNxButton;                                                             //The Buttons
    FOnProgressNotifyEvent: TNxProgressNotifyEvent;
    FOptions: TNxProgressOptions;                                               //Title (on the form)
    FPressed: Boolean;
    FProgress: Word;                                                            //0 is off.
    FInput: TNxEdit;                                                            //The Input Edit Field
    FProgressBar: TProgressBar;                                                 //The Progressbar
    FPrompt: string;                                                            //Prompt for Buttons
    FTitle: string;
    function GetCancelCaption: string;
    function GetCaption: TCaption;                                              //FForm.Caption
    function GetColor: TColor;
    function GetFont: TFont;                                                    //FForm.FFont
    function GetHandle: THandle;                                                //FForm.Handle
    function GetHeight: Integer;                                                //FForm.Height
    function GetInput: string;
    function GetLeft: Integer;                                                  //FForm.Left
    function GetMax: Integer;                                                   //FProgressBar.Max
    function GetMin: Integer;                                                   //FProgressBar.Min
    function GetOkCaption: string;
    function GetPosition: Integer;                                              //FProgressBar.Position
    function GetPrompt: string;                                                 //FPrompt.Caption
    function GetSmooth: Boolean;                                                //FProgressBar.Smooth
    function GetTop: Integer;                                                   //FForm.Top
    function GetVisible: Boolean;                                               //FForm.Visible
    function GetWidth: Integer;                                                 //FForm.Width
    procedure ReAlignButtons;
    procedure SetAlphaBlendValue(const Value: Byte);                            //FForm.AlphaBlendValue
    procedure SetAlwaysOnTop(Value: Boolean);                                   //FAlwaysOnTop
    procedure SetAutoSize(Value: Boolean);                                      //FAutoSize
    procedure SetButtonWidth(const Value: Integer);
    procedure SetCancelCaption(const Value: string);
    procedure SetCaption(Value: TCaption);                                      //FForm.Caption
    procedure SetColor(const Value: TColor);
    procedure SetFont(Value: TFont);                                            //FForm.Font
    procedure SetHeight(Value: Integer);                                        //FForm.Height
    procedure SetImageIndex(const Value: Integer);
    procedure SetImageList(Value: TImageList);                                  //FImageList
    procedure SetLeft(Value: Integer);                                          //FForm.Left
    procedure SetLines(Value: TStringList);                                     //FLines
    procedure SetMax(Value: Integer);                                           //FProgressBar.Max
    procedure SetMin(Value: Integer);                                           //FProgressBar.Min
    procedure SetOkCaption(const Value: string);
    procedure SetOptions(const Value: TNxProgressOptions);                      //FForm.Width
    procedure SetPosition(Value: Integer);                                      //FProgressBar.Position
    procedure SetProgress(Value: Word);                                         //FProgress
    procedure SetPrompt(Value: string);                                         //FPrompt.Caption
    procedure SetSmooth(Value: Boolean);                                        //FProgressBar.Smooth
    procedure SetTitle(Value: string);                                          //FForm.Title
    procedure SetTop(Value: Integer);                                           //FForm.Top
    procedure SetVisible(value: Boolean);                                       //FForm.Visible
    procedure SetWidth(Value: Integer);                                         //FForm.Width
    procedure SetInput(const Value: string);                                    //FForm.FInput.Text
  protected
    procedure CancelClick(Sender: TObject);                                     //FForm.FCancel.OnClick event handler
    procedure FormActivate(Sender: TObject);                                    //FForm.OnActivate event handler
    procedure FormDeactivate(Sender: TObject);                                  //FForm.OnDeActivate event handler
    procedure FormPaint(Sender: TObject);                                       //FForm.OnPaint event handler
    function InternalWaitPrompt(aTag: Integer): Boolean;                        //Here the actual work for WaitPrompt is done.
    procedure LinesChanged(Sender: TObject);                                    //FLines.OnChange Handler
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OkClick(Sender: TObject);                                         //FForm.FOk.OnClick event handler
    procedure InputKeyPressed(Sender: TObject; var Key: Char);
    procedure PromptKeyPressed(Sender: TObject; var Key: Char);                 //FForm.FOk.OnKeyPressed & FForm.FCancel.OnKeyPressed event handler
    procedure PromptKeyUp(Sender: TObject; var Key: Word; Shift:                //FForm.FOk.OnKeyUp & FForm.FCancel.OnKeyUp event handler
      TShiftState);
    procedure PromptMouseDown(Sender: TObject; Buttons: TMouseButton;           //FForm.FOk.OnMouseDown & FForm.FCancel.OnMouseDown event handler
      Shift: TShiftState; X, Y: Integer);
    procedure PromptMouseUp(Sender: TObject; Buttons: TMouseButton;             //FForm.FOk.OnMouseUp & FForm.FCancel.OnMouseUp event handler
      Shift: TShiftState; X, Y: Integer);
    procedure SetTransparent(const Value: Byte);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BringToFront;
    procedure None;
    procedure First;
    procedure Decrement(const aDecrement: Integer = 1);
    procedure Increment(const aIncrement: Integer = 1);
    procedure Last;
    procedure Next;
    procedure NextIf(const condition: Boolean);
    procedure Previous;
    procedure PreviousIf(const condition: Boolean);
    procedure SendToBack;
    procedure Hide;
    procedure Show;
    { Display a prompt and an OK Button. OnNotify is called repeatedly so the application can 'Press' a button too.
      PlusOptions are added to already present Designtime options.
      MinusOptions are added to already present Designtime options. }
    function WaitPrompt(const aTag: Integer = 0; const PlusOptions: TNxProgressOptions = []; const MinusOptions: TNxProgressOptions = []): Boolean;
    { The actual Form. }
    property Form: TForm read fForm;
    property Handle: THandle read GetHandle;
    { True when Cancel Button or Escape is pressed. }
    property IsCancelled: Boolean read FIsCancelled;
    property IsDown: Boolean read FIsDown;
    { True when Cancel or Ok Button or Escape, Space or Return  is pressed. }
    property Pressed: Boolean read fPressed;
  published
    property AlphaBlendValue: Byte read FAlphaBlendValue write SetAlphaBlendValue stored True default 255;
    property AlphaDelayValue: Integer read FAlphaDelayValue write FAlphaDelayValue stored True default 100;
    property AlwaysOnTop: Boolean read FAlwaysOnTop write SetAlwaysOnTop stored True default False;
    property AutoSize: Boolean read FAutoSize write SetAutoSize stored True default False;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth stored True default 75;
    property CancelCaption: string read GetCancelCaption write SetCancelCaption stored True;
    property Caption: TCaption read GetCaption write SetCaption stored True;
    property Color: TColor read GetColor write SetColor;                        //Tested only with clBtnFace
    property Font: TFont read GetFont write SetFont stored True;
    property FormHeight: Integer read GetHeight write SetHeight stored True default 240;
    property FormLeft: Integer read GetLeft write SetLeft stored True default 8;
    property FormTop: Integer read GetTop write SetTop stored True default 8;
    property FormWidth: Integer read GetWidth write SetWidth stored True default 280;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Images: TImageList read FImageList write SetImageList stored True;
    property Input: string read GetInput write SetInput;
    property Lines: TStringList read FLines write SetLines stored True;
    property Max: Integer read GetMax write SetMax stored True default 100;     //FForm.ProgresBar
    property Min: Integer read GetMin write SetMin stored True default 0;       //FForm.ProgresBar
    property OffsetX: Integer read FOffsetX write FOffsetX stored True;
    property OffsetY: Integer read FOffsetY write FOffsetY stored True;
    property OkCaption: string read GetOkCaption write SetOkCaption stored True;
    property Options: TNxProgressOptions read FOptions write SetOptions stored True;
    property Position: Integer read GetPosition write Setposition stored True default 0; //FForm.ProgresBar
    property Progress: Word read FProgress write SetProgress stored True default 0;
    property Prompt: string read GetPrompt write SetPrompt stored True;
    property Smooth: Boolean read GetSmooth write SetSmooth stored True default False;
    property Title: string read FTitle write SetTitle stored True;
    property Visible: Boolean read GetVisible write SetVisible stored True default False;
    property OnNotify: TNxProgressNotifyEvent read FOnProgressNotifyEvent write FOnProgressNotifyEvent;
  end;

  {-------------------------------------------------------------}

implementation

uses
  StrUtils;

{-------------------------------------------------------------}

constructor TNxProgress.Create(AOwner: TComponent);
const
  crlf                          = ^M^J;
begin
  inherited Create(AOwner);

  FLines := TStringList.Create;
  FLines.Text :=
    'Importing old Tweak UI settings' + crlf +
    'Introducing Tweak UI' + crlf +
    'System Configuration';
  FLines.OnChange := LinesChanged;
  FTitle := 'Windows is now setting up the follwing items:';

  FForm := TForm.CreateNew(Application);
  FForm.FreeNotification(Self);

  with FForm do
    begin
      //Style of window
      BorderStyle := bsDialog;
      BorderIcons := [];

      OnPaint := FormPaint;
      Hide;

      FForm.Color := clBtnFace;
      FForm.TransparentColorValue := FForm.Color;
      FForm.AlphaBlendValue := 255;
      FForm.AlphaBlend := True;

      DoubleBuffered := True;

      FormWidth := 320;
      FormHeight := 240;
      FormLeft := 10;
      FormTop := 10;

      Canvas.Font.Name := 'MS Sans Serif';
      Canvas.Font.Charset := DEFAULT_CHARSET;
      Canvas.Font.Pitch := fpDefault;
      Canvas.Font.Size := 8;
      Canvas.Font.Style := [];
      Canvas.Font.Color := clBlack;
      Canvas.Refresh;

      //Style of Progressbar component
      FProgressBar := TProgressBar.Create(Self);
      FProgressBar.Parent := FForm;
      FProgressBar.DoubleBuffered := True;                                      //veg:Solves problems when theming!
      FProgressBar.Align := alBottom;
      FProgressBar.Repaint;
      FProgressBar.TabStop := False;
      FProgressBar.Enabled := False;

      FPrompt := 'Press me';

      FOk := TNxButton.Create(Self);
      FOk.Parent := FForm;
      FOk.DoubleBuffered := True;
      FOk.Caption := 'Ok';
      FOk.Visible := True;

      FCancel := TNxButton.Create(Self);
      FCancel.Parent := FForm;
      FCancel.DoubleBuffered := True;
      FCancel.Caption := 'Cancel';
      FCancel.Visible := True;

      //veg: 08-09-2008 New Input Code
      FInput := TNxEdit.Create(Self);
      FInput.Parent := FForm;
      FInput.DoubleBuffered := True;
      FInput.Visible := True;

      FButtonWidth := 75;

      FOptions := [poFixedImage];

      OffsetX := Round(1.5 * 1 * FForm.Canvas.TextExtent('ghX').cy);
      OffsetY := OffsetX;

      Caption := 'Window 98 Setup';

      Repaint;
    end;

  case FAlwaysOnTop of
    True: SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE);
    False: SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE)
  end;

  FAlphaBlendValue := 255;
  FAlphaDelayValue := 25;
  FAnimate := False;
  FForm.AlphaBlendValue := FAlphaBlendValue;

  SetTransparent(FAlphaBlendValue);
end;

{-------------------------------------------------------------}

destructor TNxProgress.Destroy;
begin
  Hide;

  FreeAndNil(FLines);
  SetLength(fTitle, 0);

  inherited Destroy;
end;

{-------------------------------------------------------------}

procedure TNxProgress.BringToFront;
begin
  if assigned(FForm) and (FForm.Visible) then
    FForm.BringToFront;
end;

{-------------------------------------------------------------}

procedure TNxProgress.CancelClick(Sender: TObject);
begin
  FPressed := True;
  FIsCancelled := True;

  FCancel.Repaint;
end;

{-------------------------------------------------------------}

procedure TNxProgress.FormActivate(Sender: TObject);
{$IFDEF ANIMATE}
var
  i                             : Byte;
{$ENDIF ANIMATE}
begin
{$IFDEF ANIMATE}
  //FForm.AlphaBlendValue := FAlphaBlendValue;
  if (poAnimate in FOptions) then
    for i := FForm.AlphaBlendValue to 255 do
      if (i mod 4) = 0 then
        begin
          FForm.AlphaBlendValue := i;
          Sleep(FAlphaDelayValue);
        end;
  FForm.AlphaBlendValue := 255;
{$ELSE ANIMATE}
  if (FAlphaBlendValue <> 255) then
    FForm.AlphaBlendValue := 255;
{$ENDIF ANIMATE}
end;

{-------------------------------------------------------------}

procedure TNxProgress.FormDeactivate(Sender: TObject);
{$IFDEF ANIMATE}
var
  i                             : Byte;
{$ENDIF ANIMATE}
begin
{$IFDEF ANIMATE}
  //FForm.AlphaBlendValue := 255;
  if (poAnimate in FOptions) then
    for i := FForm.AlphaBlendValue downto FAlphaBlendValue do
      if (i mod 4) = 0 then
        begin
          FForm.AlphaBlendValue := i;
          Sleep(FAlphaDelayValue);
        end;
  SetTransparent(FAlphaBlendValue);
{$ELSE ANIMATE}
  if (FAlphaBlendValue <> 255) then
    FForm.AlphaBlendValue := FAlphaBlendValue;
{$ENDIF ANIMATE}
end;

{-------------------------------------------------------------}
{ OnPaint event handler                                       }
{-------------------------------------------------------------}

procedure TNxProgress.FormPaint(Sender: TObject);

{-------------------------------------------------------------}

  procedure DrawTransparentBitmap(DC: HDC; hBmp: HBITMAP;
    xStart: Integer; yStart: Integer; cTransparentColor: COLORREF);
  var
    bm                          : BITMAP;
    cColor                      : COLORREF;
    bmAndBack, bmAndObject, bmAndMem, bmSave: HBITMAP;
    bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBITMAP;
    hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave: HDC;
    ptSize                      : TPOINT;

  begin
    hdcTemp := CreateCompatibleDC(dc);
    SelectObject(hdcTemp, hBmp);                                                // Select the bitmap
{$WARNINGS OFF}
    GetObject(hBmp, sizeof(BITMAP), @bm);
{$WARNINGS ON}
    ptSize.x := bm.bmWidth;                                                     // Get width of bitmap
    ptSize.y := bm.bmHeight;                                                    // Get height of bitmap
    DPtoLP(hdcTemp, ptSize, 1);                                                 // Convert from device
    // to logical points

// Create some DCs to hold temporary data.
    hdcBack := CreateCompatibleDC(dc);
    hdcObject := CreateCompatibleDC(dc);
    hdcMem := CreateCompatibleDC(dc);
    hdcSave := CreateCompatibleDC(dc);

    // Create a bitmap for each DC. DCs are required for a number of
    // GDI functions.

    // Monochrome DC
    bmAndBack := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

    // Monochrome DC
    bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

    bmAndMem := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);
    bmSave := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);

    // Each DC must select a bitmap object to store pixel data.
    bmBackOld := SelectObject(hdcBack, bmAndBack);
    bmObjectOld := SelectObject(hdcObject, bmAndObject);
    bmMemOld := SelectObject(hdcMem, bmAndMem);
    bmSaveOld := SelectObject(hdcSave, bmSave);

    // Set proper mapping mode.
    SetMapMode(hdcTemp, GetMapMode(dc));

    // Save the bitmap sent here, because it will be overwritten.
    BitBlt(hdcSave, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);

    // Set the background color of the source DC to the color.
    // contained in the parts of the bitmap that should be transparent
    cColor := SetBkColor(hdcTemp, cTransparentColor);

    // Create the object mask for the bitmap by performing a BitBlt
    // from the source bitmap to a monochrome bitmap.
    BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0,
      SRCCOPY);

    // Set the background color of the source DC back to the original
    // color.
    SetBkColor(hdcTemp, cColor);

    // Create the inverse of the object mask.
    BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0,
      NOTSRCCOPY);

    // Copy the background of the main DC to the destination.
    BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, dc, xStart, yStart,
      SRCCOPY);

    // Mask out the places where the bitmap will be placed.
    BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);

    // Mask out the transparent colored pixels on the bitmap.
    BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);

    // XOR the bitmap with the background on the destination DC.
    BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCPAINT);

    // Copy the destination to the screen.
    BitBlt(dc, xStart, yStart, ptSize.x, ptSize.y, hdcMem, 0, 0,
      SRCCOPY);

    // Place the original bitmap back into the bitmap sent here.
    BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcSave, 0, 0, SRCCOPY);

    // Delete the memory bitmaps.
    DeleteObject(SelectObject(hdcBack, bmBackOld));
    DeleteObject(SelectObject(hdcObject, bmObjectOld));
    DeleteObject(SelectObject(hdcMem, bmMemOld));
    DeleteObject(SelectObject(hdcSave, bmSaveOld));

    // Delete the memory DCs.
    DeleteDC(hdcMem);
    DeleteDC(hdcBack);
    DeleteDC(hdcObject);
    DeleteDC(hdcSave);
    DeleteDC(hdcTemp);
  end;

  {-------------------------------------------------------------}

var
  offset,                                                                       //the offset of the image to the top&left of the form.
  shift,                                                                        //the offset of the text to the left of the form.
  x, y, h,
    i, j,
    //ih,
  fw, fh                        : Integer;                                      //used for autosizing of the form.
  b                             : TBitmap;
  lx, ly                        : Integer;
  ix                            : Integer;
begin
  inherited;

  fw := 240;
  fh := 180;

  lx := -1;
  ly := -1;

  with FForm.Canvas do
    begin
      shift := 0;

      Brush.Color := FForm.Color;
      FillRect(FForm.Clientrect);

      //get the textheight of something.
      if (FTitle <> '') then
        h := TextExtent(FTitle).cy
      else
        h := TextExtent('ghX').cy;
      offset := Round(1.5 * 1 * h);

      //paint the image if it's there
      if Assigned(FImageList) then
        begin
          shift := offset + FImageList.Width;
          b := TBitmap.Create;
          try
            case (poFixedImage in Options) of
              True:
                begin
                  if (FImageList.Count > 0) and (FImageIndex <> -1) and (FImageIndex < FImageList.Count) then
                    begin
                      FImageList.GetBitmap(FImageIndex, b);
                      if (FImageList.DrawingStyle = dsTransparent) then
                        DrawTransparentBitmap(Handle, b.Handle, offsetX, offsetY, b.TransparentColor)
                      else
                        Draw(offsetX, offsetY, b);
                      fh := Math.Max(fh, 2 * offset + FImageList.Height);       //3?
                      fw := Math.Max(fw, 2 * offset + FImageList.Width);
                    end;
                end;

              False:
                begin
                  if (Progress < FImageList.Count) then
                    begin
                      FImageList.GetBitmap(Progress, b);
                      if (FImageList.DrawingStyle = dsTransparent) then
                        DrawTransparentBitmap(Handle, b.Handle, offsetX, offsetY, b.TransparentColor)
                      else
                        Draw(offsetX, offsetY, b);
                      fh := Math.Max(fh, 2 * offset + FImageList.Height);       //3?
                      fw := Math.Max(fw, 2 * offset + FImageList.Width);
                    end;
                end;
            end;
          finally
            b.Free;
          end;
        end;

      //print the title next to the upper right corner of the image
      //or at the upper left corner of where there would be an image.
      x := shift + 10;
      y := offset;

      Font.Style := [];
      if (FTitle <> '') then
        begin
          TextOut(x, y, FTitle);
          fw := Math.Max(fw, x + TextExtent(FTitle).cx);
          fh := Math.Max(fh, y);
          j := 2;
        end
      else
        j := 0;

      //start the text at either the position of the title (if thats missing)
      //or a single line below the title. In both cases shift it a bit to
      //the right to make room for the bullets.
      for i := 1 to FLines.Count do
        begin
          x := shift + 30;
          h := TextExtent(FLines[i - 1]).cy;
          y := Round(1.5 * (i + j) * h);

          //be sure to calc autosize for bold ones...
          Font.Style := [fsBold];
          fw := Math.Max(fw, x + TextExtent(FLines[i - 1]).cx);

          if (i = progress) then
            begin
              //paint a triangular bullet.
              Brush.Color := clBlack;
              Font.Style := [fsBold];
              Polygon([Point(x - 10, y + (h div 2)),
                Point(x - 13, y - 3 + (h div 2)),
                  Point(x - 13, y + 3 + (h div 2)),
                  Point(x - 10, y + (h div 2))]);
              Brush.Color := FForm.Color;

              lx := x + (TextExtent(FLines[i - 1]).cx + 10);
              ly := y + (TextExtent(FLines[i - 1]).cy div 2);
            end
          else
            Font.Style := [];
          fh := Math.Max(fh, y + 2 * h);
          TextOut(x, y, FLines[i - 1]);
          Font.Style := [];
        end;

      //Allow for a Prompt above the buttons.
      Inc(fh, 3 * TextExtent('X').cy);                                          //3 lines extra for Prompt.
      Inc(fw, 30);                                                              //30 Extra for Arrows.
    end;

  //Try to AutoSize
  if Fautosize then
    begin
      formwidth := fw + offset;
      formheight := fh + offset + FProgressBar.Height;
    end;

  //Paint Progressbar
  //if (FProgressBar.Visible) then                                              //veg:Problems when theming!
  //  FProgressBar.Invalidate;

  //Prevent Designtime errors.
  FOK.Visible := (poShowButtons in Options) or (csDesigning in ComponentState);

  //Paint Prompt & Buttons
  FForm.Canvas.Lock;

  if (FOk.Visible) then
    with FForm.Canvas do
      begin
        //Draw an Arrow.
        if (poShowArrow in Options) and (poShowButtons in Options) and (lx <> -1) and (ly <> -1) and (Progress <> 0) then
          begin
            MoveTo(lx, ly);

            x := FForm.Width - 20 - (TextExtent('X').cy div 2);

            h := 5;

            //veg:08-09-2008 - New Input Code Added
            Font.Style := [fsBold];
            ix := TextExtent(FPrompt).cx + FInput.Left;
            if (poShowPrompt in Options) or ((poShowEdit in Options) and (ix > x - (3 * h div 2))) then
              y := FOk.BoundsRect.Top - Round(2.5 * TextExtent(FPrompt).cy)
            else
              y := FOk.BoundsRect.Top - TextExtent(FPrompt).cy;
            Font.Style := [];

            LineTo(lx, ly - h);
            LineTo(lx, ly + h);
            LineTo(lx, ly);
            LineTo(x, ly);
            LineTo(x, y);

            Brush.Color := clBlack;
            Polygon([Point(x, y),
              Point(x - h, y - h),
                Point(x + h, y - h),
                Point(x, y)]);
            Brush.Color := FForm.Color;
          end;

        //Draw Prompt.
        if (poShowButtons in Options) and (poShowPrompt in Options) and (Progress <> 0) then
          begin
            Font.Style := [fsBold];

            //veg: 08-09-2008 New Input Code
            if (poShowEdit in Options) then
              TextOut(FInput.Left,
                FOk.BoundsRect.Top - 2 * TextExtent(FPrompt).cy,
                FPrompt)
            else
              TextOut(FForm.Width - TextExtent(FPrompt).cx - 20,
                FOk.BoundsRect.Top - 2 * TextExtent(FPrompt).cy,
                FPrompt);

            Font.Style := [];
          end;

        //Position Ok Buttons.
        FOk.SetBounds(
          FForm.Width - ButtonWidth - 20,
          FProgressBar.Top - FOk.Height - 10,
          ButtonWidth,
          FOk.Height);

        //Position Cancel Buttons.
        FCancel.SetBounds(
          FOk.Left - ButtonWidth - 10,
          FOk.Top,
          ButtonWidth,
          FOk.Height);

        //Prevent Designtime errors.
        FCancel.Visible := (poAllowCancel in Options) or (csDesigning in ComponentState);
      end;

  FInput.Visible := (poShowEdit in Options) and FOk.Visible;

  FForm.Canvas.Unlock;
end;

{-------------------------------------------------------------}

procedure TNxProgress.Hide;
begin
  if assigned(FForm) and FForm.Visible then
    Visible := False;
end;

function TNxProgress.InternalWaitPrompt(aTag: Integer): Boolean;
var
  //Always Show Buttons.
{$IFDEF MODAL}
  WindowList                    : Pointer;
{$ENDIF MODAL}
  fo                            : TNxProgressOptions;
begin
  //Store Options
  fo := Options;                                                                //veg:14-07-2007

  //We need to ensure at least the OK Button is visible.
  Options := Options + [poShowButtons];                                         //veg:14-07-2007

  FPressed := False;
  FIsDown := False;

  FIsCancelled := False;

  //Attach EventHandlers
  FCancel.OnKeyUp := PromptKeyUp;
  FCancel.OnKeyPress := PromptKeyPressed;
  FCancel.OnClick := CancelClick;
  FCancel.OnMouseDown := PromptMouseDown;
  FCancel.OnMouseUp := PromptMouseUp;

  //FOk.OnKeyDown := PromptKeyDown;
  //FOk.OnKeyUp := PromptKeyUp;
  FOk.OnKeyUp := PromptKeyUp;
  FOk.OnKeyPress := PromptKeyPressed;
  FOk.OnClick := OkClick;
  FOk.OnMouseDown := PromptMouseDown;
  FOk.OnMouseUp := PromptMouseUp;

  FInput.OnKeyPress := InputKeyPressed;

  if FForm.Visible and FForm.Enabled and FOk.Visible and FOk.Enabled then
    begin
      if (atag <> 0) and Assigned(FOnProgressNotifyEvent) then
        FOnProgressNotifyEvent(Self, aTag, FPressed);

      FForm.BringToFront;

      //veg: 08-09-2008 New Input Code
      if FInput.Visible then
        begin
          FInput.SetFocus;
          FInput.SelectAll;
        end
      else
        FOk.SetFocus;
      //??    Application.ProcessMessages;
    end;

  ReAlignButtons;

  FOk.Repaint;
  FCancel.Repaint;

{$IFDEF MODAL}
  if (poModal in Options) then
    begin
      //06082007 - New Safeguard
      if FForm.Visible and FForm.Enabled and
        Assigned(FOk) and Assigned(FCancel) and
        (FOk.Visible or FCancel.Visible) then
        begin
          //06082007 - Disable all other Windows when we're waiting for the button press.
          ReleaseCapture;
          SetCaptureControl(FForm);
          WindowList := DisableTaskWindows(FForm.Handle);
          EnableWindow(FForm.Handle, True);
          SendMessage(FOk.Handle, CM_ACTIVATE, 0, 0);

          FForm.Repaint;

          while FForm.Visible and FForm.Enabled and
            Assigned(FOk) and Assigned(FCancel) and
            (FOk.Visible or FCancel.Visible) and
            not (FPressed) do
            begin
              if (aTag <> 0) and Assigned(FOnProgressNotifyEvent) then
                FOnProgressNotifyEvent(Self, aTag, FPressed);
              //06082007 - Handle instead of Processmessages
              Application.HandleMessage;
              //06082007 - Added Sleep
              //Sleep(0);
            end;

          //06082007 - Reenable other windows.
          EnableTaskWindows(WindowList);
          ReleaseCapture;
        end
    end;
{$ENDIF MODAL}

{$IFNDEF MODAL}
  while Assigned(FOk) and Assigned(FCancel) and not (FPressed) do
    begin
      if (atag <> 0) and Assigned(FOnProgressNotifyEvent) then
        FOnProgressNotifyEvent(Self, aTag, FPressed);
      Application.ProcessMessages;
    end;
{$ENDIF MODAL}

  //Detach EventHandlers
  FOk.OnClick := nil;
  FOk.OnMouseDown := nil;
  FOk.OnMouseUp := nil;
  FOk.OnMouseMove := nil;
  FOk.OnKeyPress := nil;
  //FOk.OnKeyDown := nil;
  FOk.OnKeyUp := nil;

  FCancel.OnClick := nil;
  FCancel.OnMouseDown := nil;
  FCancel.OnMouseUp := nil;
  FCancel.OnMouseMove := nil;
  FCancel.OnKeyPress := nil;
  //FCancel.OnKeyDown := nil;
  //FCancel.OnKeyUp := nil;

  FInput.OnKeyPress := nil;

  FPressed := False;
  FIsDown := False;

  //Restore Options
  Options := fo;                                                                //veg:14-07-2007

  Result := not FIsCancelled;
end;

procedure TNxProgress.Loaded;
begin
  inherited;

end;

{-------------------------------------------------------------}

procedure TNxProgress.Next;
begin
  Progress := Math.Min(Progress + 1, Lines.Count);

  FForm.Repaint;
end;

{-------------------------------------------------------------}

procedure TNxProgress.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent = FForm) then
    FForm := nil;
end;

{-------------------------------------------------------------}

procedure TNxProgress.OkClick(Sender: TObject);
begin
  fPressed := True;

  FOk.Repaint;
end;

{-------------------------------------------------------------}

procedure TNxProgress.Previous;
begin
  Progress := Math.Max(Progress - 1, 0);

  FForm.Repaint;
end;

{-------------------------------------------------------------}

procedure TNxProgress.PromptKeyPressed(Sender: TObject; var Key: Char);
begin
  {
    case (Key) of
      #27:
        if poAllowCancel in Options then
          begin
            FIsCancelled := True;
            FPressed := True;

            Key := #0;

            inherited;
          end;
      #32,
        #13:
        begin
          FPressed := True;
          if FCancel.Focused then
            FIsCancelled := True;

          Key := #0;

          inherited;
        end;
    else
      inherited;
    end;
  }
end;

procedure TNxProgress.PromptKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case (Key) of
    VK_ESCAPE:
      if poAllowCancel in Options then
        begin
          FIsCancelled := True;
          FPressed := True;

          Key := 0;
        end;
    VK_SPACE,
      VK_RETURN:
      begin
        FPressed := True;
        if FCancel.Focused then
          FIsCancelled := True;

        Key := 0;
      end;
  else
    inherited;
  end;
end;

{-------------------------------------------------------------}

procedure TNxProgress.PromptMouseDown(Sender: TObject; Buttons: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Buttons = mbLeft) then
    begin
      if (Sender = FOK) then
        FOK.Down := True;

      if (Sender = FCancel) then
        FCancel.Down := True;

      FIsDown := True;
    end;
end;

{-------------------------------------------------------------}

procedure TNxProgress.PromptMouseUp(Sender: TObject; Buttons: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Buttons = mbLeft) then
    begin
      if (Sender = FOK) then
        FOK.Down := False;

      if (Sender = FCancel) then
        FCancel.Down := False;

      FIsDown := False;
    end;
end;

procedure TNxProgress.InputKeyPressed(Sender: TObject; var Key: Char);
begin
  case (Key) of
    #27:
      if poAllowCancel in Options then
        begin
          FCancel.Click;

          Key := #0;

          inherited;
        end;
    #13:
      begin
        if FCancel.Focused then
          FCancel.Click
        else
          FOk.Click;

        Key := #0;

        inherited;
      end;
  else
    inherited;
  end;
end;

procedure TNxProgress.ReAlignButtons;
begin
  if assigned(FForm) then
    begin
      FOk.SetBounds(
        FForm.Width - ButtonWidth - 20,
        FProgressBar.Top - FOk.Height - 10,
        ButtonWidth,
        FOk.Height);

      FCancel.SetBounds(
        FOk.Left - ButtonWidth - 10,
        FOk.Top,
        ButtonWidth,
        FOk.Height);

      if Fcancel.Visible then
        FInput.SetBounds(
          10,
          FOk.Top + FOk.Height - FInput.Height,
          FCancel.Left - 2 * 10,
          FInput.Height)
      else
        FInput.SetBounds(
          10,
          FOk.Top + FOk.Height - FInput.Height,
          FOk.Left - 2 * 10,
          FInput.Height);

      if FForm.Visible then
        FForm.Repaint;
    end;
end;

procedure TNxProgress.SendToBack;
begin
  if assigned(FForm) and (FForm.Visible) then
    FForm.SendToBack;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetTransparent(const Value: Byte);
begin
  if Assigned(FForm) and (FForm.AlphaBlendValue <> Value) then
    FForm.AlphaBlendValue := Value;
end;

{-------------------------------------------------------------}

procedure TNxProgress.Show;
begin
  if assigned(FForm) and not (FForm.Visible) then
    Visible := True;
end;

function TNxProgress.WaitPrompt(const aTag: Integer = 0; const PlusOptions: TNxProgressOptions = []; const MinusOptions: TNxProgressOptions = []): Boolean;
var
  fo                            : TNxProgressOptions;
begin
  //Store Options
  fo := Options;                                                                //veg:14-05-2007

  //Use new Options
  Options := Options - MinusOptions;                                            //First Substract to allow WaitPrompt(tag,[poShowButtons],Options); alike calls
  Options := Options + PlusOptions;

  Result := InternalWaitPrompt(aTag);

  //Restore Options
  Options := fo;                                                                //veg:14-05-2007
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetAlphaBlendValue(const Value: Byte);
begin
  FAlphaBlendValue := Value;

  SetTransparent(Value);
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetAlwaysOnTop(value: Boolean);
begin
  if assigned(FForm) {and (FAlwaysOnTop <> Value)} then
    begin
      FAlwaysOnTop := Value;

      case FAlwaysOnTop of
        True: SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE);
        False: SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE)
      end;

      SetForegroundWindow(FForm.Handle);

      FForm.Repaint;
    end;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetAutoSize(value: Boolean);
begin
  if (FAutoSize <> Value) then
    begin
      FAutoSize := Value;

      if Assigned(FForm) then
        ReAlignButtons;
    end;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;

  ReAlignButtons;
end;

{-------------------------------------------------------------}

function TNxProgress.GetCancelCaption: string;
begin
  if Assigned(FCancel) then
    Result := FCancel.Caption
  else
    Result := 'Cancel';
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetCancelCaption(const Value: string);
begin
  if Assigned(FCancel) then
    FCancel.Caption := Value;
end;

{-------------------------------------------------------------}

function TNxProgress.GetCaption: TCaption;
begin
  Result := FForm.Caption;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetCaption(Value: TCaption);
begin
  if Assigned(FForm) and (FForm.Caption <> Value) then
    FForm.Caption := Value;
end;

function TNxProgress.GetColor: TColor;
begin
  if Assigned(FForm) then
    Result := FForm.Color
  else
    Result := clBtnFace;
end;

procedure TNxProgress.SetColor(const Value: TColor);
begin
  if Assigned(FForm) then
    begin
      FForm.Color := Value;
      FForm.TransparentColorValue := Value;
    end;
end;

{-------------------------------------------------------------}
{ Misc stuff                                                  }
{-------------------------------------------------------------}

function TNxProgress.GetFont: TFont;
begin
  Result := FForm.Canvas.Font;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetFont(Value: TFont);
begin
  if Assigned(FForm) and (FForm.Canvas.Font <> Value) then
    begin
      FForm.Canvas.Font := Value;

      ReAlignButtons;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetHeight: Integer;
begin
  Result := FForm.Height;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetHeight(Value: Integer);
begin
  if Assigned(FForm) and (FForm.Height <> Value) then
    begin
      FForm.Height := Value;

      ReAlignButtons;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetLeft: Integer;
begin
  Result := FForm.Left;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetLeft(Value: Integer);
begin
  if Assigned(FForm) and (FForm.Left <> Value) then
    begin
      FForm.Left := Value;

      FForm.Repaint;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetTop: Integer;
begin
  Result := FForm.Top;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetTop(Value: Integer);
begin
  if Assigned(FForm) and (FForm.Top <> Value) then
    begin
      FForm.Top := Value;

      FForm.Repaint;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetWidth: Integer;
begin
  Result := FForm.Width;
end;

{-------------------------------------------------------------}

{ R *.dcr}
{
const
  LWA_ALPHA         = $2;
const
  GWL_EXSTYLE       = (-20);
const
  WS_EX_LAYERED     = $80000;
const
  WS_EX_TRANSPARENT = $20;
var
  _SetLayeredWindowAttributes: function(hwnd: THandle; crey: Byte; bAlpha: Byte; dwFlags: Longint): Longint; stdcall;
}
{-------------------------------------------------------------}
{ FForm stuff                                                 }
{-------------------------------------------------------------}

procedure TNxProgress.SetWidth(Value: Integer);
begin
  if Assigned(FForm) and (FForm.Width <> Value) then
    begin
      FForm.Width := Value;
      ReAlignButtons;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetHandle: THandle;
begin
  if Assigned(FForm) then
    Result := FForm.Handle
  else
    Result := INVALID_HANDLE_VALUE;
end;

procedure TNxProgress.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;

  ReAlignButtons;
end;

{-------------------------------------------------------------}
{ ImageList stuff                                             }
{-------------------------------------------------------------}

procedure TNxProgress.SetImageList(Value: TImageList);
begin
  if (FImageList <> Value) then
    begin
      FImageList := Value;

      ReAlignButtons;
    end;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetLines(Value: TStringList);
begin
  if (FLines.Text <> Value.Text) then
    begin
      Flines.Text := Value.Text;

      ReAlignButtons;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetMax: Integer;
begin
  Result := FProgressBar.Max;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetMax(Value: Integer);
begin
  if Assigned(FProgressBar) and (FProgressBar.Max <> Value) then
    FProgressBar.Max := Value;
end;

{-------------------------------------------------------------}
{ FProgressBar stuff                                          }
{-------------------------------------------------------------}

function TNxProgress.GetMin: Integer;
begin
  Result := FProgressBar.Min;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetMin(Value: Integer);
begin
  if Assigned(FProgressBar) and (FProgressBar.Min <> Value) then
    FProgressBar.Min := Value;
end;

{-------------------------------------------------------------}

function TNxProgress.GetOkCaption: string;
begin
  if Assigned(FOk) then
    Result := FOk.Caption
  else
    Result := 'Ok';
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetOkCaption(const Value: string);
begin
  if Assigned(FOk) then
    FOk.Caption := Value;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetOptions(const Value: TNxProgressOptions);
begin
  if (FOptions <> Value) then
    FOptions := Value;

  ReAlignButtons;

  FOk.Visible := (poShowButtons in FOptions) or (csDesigning in ComponentState);
  FCancel.Visible := (poShowButtons in FOptions) and (poAllowCancel in FOptions) or (csDesigning in ComponentState);

  FForm.Repaint;
end;

{-------------------------------------------------------------}

function TNxProgress.GetPosition: Integer;
begin
  Result := FProgressBar.Position;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetPosition(Value: Integer);
begin
  if Assigned(FProgressBar) and (FProgressBar.Position <> Value) then
    FProgressBar.Position := Value;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetProgress(Value: Word);
begin
  if (FProgress <> Value) and (Value <= Lines.Count) then
    begin
      FProgress := Value;

      FForm.Repaint;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetPrompt: string;
begin
  if Assigned(FForm) then
    Result := FPrompt;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetPrompt(Value: string);
begin
  if (FPrompt <> Value) then
    FPrompt := Value;

  if Assigned(FForm) then
    FForm.Repaint;
end;

{-------------------------------------------------------------}

function TNxProgress.GetSmooth: Boolean;
begin
  Result := FProgressBar.Smooth;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetSmooth(Value: Boolean);
var
  p                             : Integer;
begin
  if Assigned(FProgressBar) and (FProgressBar.Smooth <> Value) then
    begin
      p := FProgressBar.Position;
      FProgressBar.Smooth := Value;
      FProgressBar.Position := p;
    end;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetTitle(Value: string);
begin
  if (FTitle <> Value) then
    begin
      FTitle := Value;

      if assigned(FForm) then
        FForm.Repaint;
    end;
end;

{-------------------------------------------------------------}

function TNxProgress.GetVisible: Boolean;
begin
  if assigned(FForm) then
    Result := FForm.Visible
  else
    Result := False;
end;

{-------------------------------------------------------------}

procedure TNxProgress.SetVisible(value: Boolean);
begin
  if assigned(FForm) and (value <> FForm.Visible) then
    begin
      FForm.OnActivate := nil;
      FForm.OnDeActivate := nil;

      ReAlignButtons;

      if (value) then
        begin
          FForm.AlphaBlendValue := 255;
          FForm.TransparentColor := True;
        end;

      FForm.Visible := value;
      FForm.Repaint;

      if (value) then
        begin
          FForm.OnActivate := FormActivate;
          FForm.OnDeActivate := FormDeActivate;
        end;

      if (poDisableMainForm in Options) and Assigned(Application.MainForm) then //veg:14-07-2008 Added.
        Application.MainForm.Enabled := not FForm.Visible;
    end;
end;

procedure TNxProgress.First;
begin
  Progress := 1;
end;

procedure TNxProgress.Last;
begin
  Progress := Lines.Count;
end;

procedure TNxProgress.None;
begin
  Progress := 0;
end;

procedure TNxProgress.NextIf(const condition: Boolean);
begin
  if condition then
    Next;
end;

procedure TNxProgress.PreviousIf(const condition: Boolean);
begin
  if condition then
    Previous;
end;

procedure TNxProgress.Decrement(const aDecrement: Integer = 1);
var
  i                             : Integer;
begin
  for i := 1 to aDecrement do
    Previous;
end;

function TNxProgress.GetInput: string;                                          //veg: 08-09-2008 New Input Code
begin
  if Assigned(FInput) then
    Result := FInput.Text;
end;

procedure TNxProgress.Increment(const aIncrement: Integer = 1);
var
  i                             : Integer;
begin
  for i := 1 to aIncrement do
    Next;
end;

procedure TNxProgress.LinesChanged(Sender: TObject);
begin
  if Assigned(FForm) then
    FForm.Repaint;
end;

procedure TNxProgress.SetInput(const Value: string);                            //veg: 08-09-2008 New Input Code
begin
  if Assigned(FInput) and (FInput.Text <> Value) then
    begin
      FInput.Text := Value;

      if assigned(FForm) then
        FForm.Repaint;
    end;
end;

end.

