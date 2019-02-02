object AlphaHintsEdit: TAlphaHintsEdit
  Left = 270
  Top = 195
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Hints templates editor'
  ClientHeight = 494
  ClientWidth = 727
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object sSpeedButton3: TsSpeedButton
    Tag = 32
    Left = 548
    Top = 413
    Width = 165
    Height = 27
    Caption = 'Change font'
    Enabled = False
    OnClick = sSpeedButton3Click
    SkinData.OuterEffects.Visibility = ovAlways
    Images = acDM.sCharImageList1
    ImageIndex = 17
  end
  object sSpeedButton5: TsSpeedButton
    Left = 309
    Top = 454
    Width = 108
    Height = 27
    Caption = 'Save To file'
    OnClick = sSpeedButton5Click
    Images = acDM.sCharImageList1
    ImageIndex = 15
  end
  object sSpeedButton6: TsSpeedButton
    Left = 420
    Top = 454
    Width = 112
    Height = 27
    Caption = 'Load from file'
    OnClick = sSpeedButton6Click
    Images = acDM.sCharImageList1
    ImageIndex = 16
  end
  object sLabel1: TsLabel
    Left = 46
    Top = 449
    Width = 114
    Height = 13
    Alignment = taRightJustify
    Caption = 'Align position to center:'
  end
  object sBitBtn1: TsBitBtn
    Left = 548
    Top = 454
    Width = 81
    Height = 27
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
    ImageIndex = 0
    Images = acDM.sCharImageList1
    SkinData.OuterEffects.Visibility = ovAlways
  end
  object sBitBtn2: TsBitBtn
    Left = 632
    Top = 454
    Width = 81
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    ImageIndex = 12
    Images = acDM.sCharImageList1
    SkinData.OuterEffects.Visibility = ovAlways
  end
  object sPageControl1: TsPageControl
    Left = 12
    Top = 12
    Width = 521
    Height = 429
    ActivePage = sTabSheet1
    TabAlignment = taCenter
    TabHeight = 24
    TabOrder = 2
    OnChange = sPageControl1Change
    SkinData.OuterEffects.Visibility = ovAlways
    object sTabSheet1: TsTabSheet
      Caption = ' Default image '
      inline FrameTL: TFrameHintPage
        Left = 2
        Top = 2
        Width = 505
        Height = 388
        TabOrder = 0
      end
    end
    object sTabSheet2: TsTabSheet
      Caption = ' Right-Top '
      TabVisible = False
    end
    object sTabSheet3: TsTabSheet
      Caption = ' Left-Bottom '
      TabVisible = False
    end
    object sTabSheet4: TsTabSheet
      Caption = ' Right-Bottom '
      TabVisible = False
    end
  end
  object sCheckBox1: TsCheckBox
    Tag = 32
    Left = 392
    Top = 15
    Width = 131
    Height = 17
    Caption = 'Use additional images'
    Enabled = False
    TabOrder = 3
    OnClick = sCheckBox1Click
  end
  object sGroupBox1: TsGroupBox
    Left = 548
    Top = 31
    Width = 165
    Height = 370
    Caption = ' Templates list: '
    TabOrder = 4
    CaptionLayout = clTopCenter
    object sSpeedButton1: TsSpeedButton
      Left = 8
      Top = 20
      Width = 48
      Height = 40
      Hint = 'New'
      Flat = True
      OnClick = sSpeedButton1Click
      Images = acDM.sCharImageList1
      ImageIndex = 2
    end
    object sSpeedButton2: TsSpeedButton
      Tag = 32
      Left = 108
      Top = 20
      Width = 48
      Height = 40
      Hint = 'Delete'
      Enabled = False
      Flat = True
      OnClick = sSpeedButton2Click
      Images = acDM.sCharImageList1
      ImageIndex = 3
    end
    object sSpeedButton4: TsSpeedButton
      Tag = 32
      Left = 58
      Top = 20
      Width = 48
      Height = 40
      Hint = 'Rename'
      Enabled = False
      Flat = True
      OnClick = sSpeedButton4Click
      Images = acDM.sCharImageList1
      ImageIndex = 14
    end
    object sListBox1: TsListBox
      Left = 8
      Top = 64
      Width = 149
      Height = 297
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = sListBox1Click
      SkinData.SkinSection = 'EDIT'
    end
  end
  object sRadioButton1: TsRadioButton
    Left = 168
    Top = 449
    Width = 50
    Height = 17
    Caption = 'Horz'
    Checked = True
    TabOrder = 5
    TabStop = True
    OnClick = sRadioButton1Click
  end
  object sRadioButton2: TsRadioButton
    Left = 234
    Top = 449
    Width = 48
    Height = 17
    Caption = 'Vert'
    TabOrder = 6
    OnClick = sRadioButton2Click
  end
  object Hints: TsAlphaHints
    Templates = <>
    SkinSection = 'HINT'
    Left = 58
    Top = 54
  end
  object sSkinProvider1: TsSkinProvider
    ShowAppIcon = False
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 86
    Top = 54
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 114
    Top = 54
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.aht'
    Filter = 'AlphaHints|*.aht'
    Left = 248
    Top = 54
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.aht'
    Filter = 'AlphaHints|*.aht'
    Left = 280
    Top = 54
  end
end
