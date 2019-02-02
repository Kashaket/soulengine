object acRootPathEditDlg: TacRootPathEditDlg
  Left = 361
  Top = 321
  Width = 340
  Height = 244
  BorderStyle = bsSizeToolWin
  Caption = 'Select Root Path'
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 340
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TsBitBtn
    Left = 150
    Top = 176
    Width = 77
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 0
    OnClick = Button1Click
    ShowFocus = False
    ImageIndex = 0
    Images = acDM.sCharImageList1
  end
  object Button2: TsBitBtn
    Left = 229
    Top = 176
    Width = 77
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 1
    OnClick = Button2Click
    ShowFocus = False
    ImageIndex = 12
    Images = acDM.sCharImageList1
  end
  object GroupBox1: TsGroupBox
    Left = 10
    Top = 7
    Width = 319
    Height = 80
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    object cbFolderType: TsComboBox
      Left = 20
      Top = 34
      Width = 279
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Alignment = taLeftJustify
      VerticalAlignment = taAlignTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = -1
      TabOrder = 0
    end
  end
  object rbUseFolder: TsRadioButton
    Left = 20
    Top = 6
    Width = 133
    Height = 17
    Caption = 'Use Standard &Folder'
    TabOrder = 2
    OnClick = rbUseFolderClick
  end
  object GroupBox2: TsGroupBox
    Left = 10
    Top = 95
    Width = 319
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    object ePath: TsDirectoryEdit
      Left = 20
      Top = 30
      Width = 277
      Height = 21
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 255
      TabOrder = 0
      CheckOnExit = True
      SkinData.SkinSection = 'EDIT'
      GlyphMode.Grayed = False
      GlyphMode.Blend = 0
      Root = 'rfDesktop'
    end
  end
  object rbUsePath: TsRadioButton
    Left = 20
    Top = 95
    Width = 78
    Height = 17
    Caption = 'Use &Path'
    TabOrder = 5
    OnClick = rbUsePathClick
  end
  object OpenDialog1: TsOpenDialog
    Left = 8
    Top = 160
  end
  object sSkinProvider1: TsSkinProvider
    ShowAppIcon = False
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    GripMode = gmRightBottom
    TitleButtons = <>
    Left = 220
    Top = 3
  end
end
