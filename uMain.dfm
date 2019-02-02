object __fMain: T__fMain
  Left = 397
  Top = 148
  Caption = 'Soul Engine'
  ClientHeight = 464
  ClientWidth = 532
  Color = 16250613
  Constraints.MinHeight = 224
  Constraints.MinWidth = 270
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = n
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  DesignSize = (
    532
    464)
  PixelsPerInch = 96
  TextHeight = 13
  object fr: TBevel
    Left = 0
    Top = 428
    Width = 532
    Height = 2
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Anchors = [akTop, akRight]
    Shape = bsBottomLine
    ExplicitTop = 433
    ExplicitWidth = 576
  end
  object b_R1: TButton
    Left = 449
    Top = 434
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Run'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = b_R1Click
  end
  object b_R0: TButton
    Left = 368
    Top = 434
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Reset'
    TabOrder = 1
    OnClick = b_R0Click
  end
  object M1: TSynMemo
    Left = 0
    Top = 0
    Width = 532
    Height = 428
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = True
    ParentCtl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    TabOrder = 2
    BorderStyle = bsNone
    Gutter.AutoSize = True
    Gutter.BorderStyle = gbsRight
    Gutter.BorderColor = clCream
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.LeftOffset = 8
    Gutter.RightOffset = 4
    Gutter.ShowLineNumbers = True
    Gutter.Width = 28
    Gutter.Gradient = True
    Highlighter = sps
    Options = [eoAutoIndent, eoDragDropEditing, eoDropFiles, eoHalfPageScroll, eoHideShowScrollbars, eoScrollPastEof, eoShowScrollHint, eoSmartTabDelete, eoTabIndent]
    TabWidth = 4
    WantTabs = True
    OnDropFiles = M1DropFiles
  end
  object n: TMainMenu
    Left = 504
    Top = 144
    object fi: TMenuItem
      Caption = 'File'
      object o1: TMenuItem
        Caption = 'Open'
        ShortCut = 16463
        OnClick = o1Click
      end
      object s: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
        OnClick = sClick
      end
      object s1: TMenuItem
        Caption = 'Save as..'
        ShortCut = 49235
        OnClick = s1Click
      end
      object sc: TMenuItem
        Caption = 'Save && Close'
        OnClick = scClick
      end
      object Close: TMenuItem
        Caption = 'Close'
        OnClick = CloseClick
      end
      object Exits: TMenuItem
        Caption = 'Exit'
        OnClick = ExitsClick
      end
    end
    object Script1: TMenuItem
      Caption = 'Script'
      object r: TMenuItem
        Caption = 'Run'
        ShortCut = 120
        OnClick = b_R1Click
      end
      object R2: TMenuItem
        Caption = 'Run File'
        ShortCut = 49222
        OnClick = R2Click
      end
      object r1: TMenuItem
        Caption = 'Reset'
        ShortCut = 116
        OnClick = b_R0Click
      end
    end
  end
  object od: TOpenDialog
    Filter = 
      'PHP Scripts|*.php|All files (*.*)|*.*|PHP SoulEngine File|*.pse|' +
      'PHP SoulEngine Extras|*.psex|PHP SoulEngine Include|*.psec|PHP 5' +
      '.3 File|*.php3'
    Options = [ofHideReadOnly, ofFileMustExist, ofCreatePrompt, ofEnableSizing]
    Left = 504
  end
  object ApplicationEvents: TApplicationEvents
    Left = 504
    Top = 192
  end
  object sd: TSaveDialog
    Filter = 'PHP Scripts|*.php|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 504
    Top = 48
  end
  object sps: TSynPHPSyn
    CommentAttri.Foreground = clGreen
    IdentifierAttri.Foreground = 1710618
    KeyAttri.Foreground = clHighlight
    NumberAttri.Foreground = clHotLight
    StringAttri.Foreground = clPurple
    SymbolAttri.Foreground = 592383
    VariableAttri.Foreground = 1495863
    Left = 504
    Top = 96
  end
end
