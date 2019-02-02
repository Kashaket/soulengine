object FormFontStore: TFormFontStore
  Left = 521
  Top = 284
  BorderStyle = bsSingle
  Caption = 'Embedded fonts'
  ClientHeight = 478
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sSpeedButton1: TsSpeedButton
    Left = 475
    Top = 28
    Width = 74
    Height = 21
    Caption = 'Search'
    OnClick = sSpeedButton1Click
    Images = acDM.sCharImageList1
    ImageIndex = 4
  end
  object sListBox1: TsListBox
    Left = 24
    Top = 55
    Width = 161
    Height = 370
    Enabled = False
    TabOrder = 0
    OnClick = sListBox1Click
    BoundLabel.Caption = 'Embedded fonts:'
    BoundLabel.Layout = sclTopLeft
    SkinData.VertScrollData.ButtonsSize = 0
  end
  object sDirectoryEdit1: TsEdit
    Left = 200
    Top = 28
    Width = 269
    Height = 21
    AutoSize = False
    MaxLength = 255
    TabOrder = 1
    OnChange = sDirectoryEdit1Change
    AddedGlyph.Images = acDM.sCharImageList1
    AddedGlyph.ImageIndex = 25
    BoundLabel.Active = True
    BoundLabel.Caption = 'Path to fonts:'
    BoundLabel.Layout = sclTopLeft
    Padding.Left = 2
    VerticalAlignment = taVerticalCenter
  end
  object sPanel1: TsPanel
    Left = 200
    Top = 256
    Width = 409
    Height = 169
    SkinData.SkinSection = 'EDIT'
    OnPaint = sPanel1Paint
    BevelOuter = bvLowered
    TabOrder = 2
  end
  object sCheckBox1: TsCheckBox
    Left = 565
    Top = 33
    Width = 18
    Height = 16
    TabStop = False
    Enabled = False
    TabOrder = 3
    OnMouseUp = sCheckBox1MouseUp
    ImgChecked = 4
    ImgUnchecked = 3
    ReadOnly = True
    ShowFocus = False
  end
  object sCheckBox2: TsCheckBox
    Left = 589
    Top = 33
    Width = 18
    Height = 16
    TabStop = False
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 4
    OnMouseUp = sCheckBox2MouseUp
    ImgChecked = 4
    ImgUnchecked = 3
    ReadOnly = True
    ShowFocus = False
  end
  object sButton1: TsBitBtn
    Left = 453
    Top = 436
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
    ImageIndex = 0
    Images = acDM.sCharImageList1
  end
  object sButton2: TsBitBtn
    Left = 534
    Top = 436
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
    ImageIndex = 12
    Images = acDM.sCharImageList1
  end
  object sListView1: TsListView
    Left = 200
    Top = 55
    Width = 409
    Height = 174
    SkinData.VertScrollData.ButtonsSize = 0
    SkinData.HorzScrollData.ButtonsSize = 0
    HighlightHeaders = False
    Columns = <
      item
        Caption = 'Font name'
        Width = 230
      end
      item
        Caption = 'File name'
        Width = 150
      end>
    ColumnClick = False
    Enabled = False
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 7
    ViewStyle = vsReport
    OnChange = sListView1Change
  end
  object sButton3: TsBitBtn
    Left = 200
    Top = 436
    Width = 141
    Height = 25
    Caption = 'Add marked fonts'
    Enabled = False
    TabOrder = 8
    OnClick = sButton3Click
    ImageIndex = 7
    Images = acDM.sCharImageList1
  end
  object sButton4: TsBitBtn
    Left = 24
    Top = 24
    Width = 80
    Height = 25
    Caption = 'Delete'
    Enabled = False
    TabOrder = 9
    OnClick = sButton4Click
    ImageIndex = 8
    Images = acDM.sCharImageList1
  end
  object sButton5: TsBitBtn
    Left = 110
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Clear'
    Enabled = False
    TabOrder = 10
    OnClick = sButton5Click
    ImageIndex = 9
    Images = acDM.sCharImageList1
  end
  object sCheckBox3: TsCheckBox
    Left = 32
    Top = 431
    Width = 114
    Height = 16
    Caption = 'The font is built-in'
    AllowGrayed = True
    Enabled = False
    State = cbGrayed
    TabOrder = 11
    OnClick = sCheckBox3Click
    ImgChecked = 11
    ImgUnchecked = 10
    Images = acDM.sCharImageList1
  end
  object sEdit1: TsEdit
    Left = 208
    Top = 235
    Width = 401
    Height = 21
    TabOrder = 12
    Text = 'sEdit1'
    Visible = False
    OnChange = sEdit1Change
    SkinData.SkinSection = 'TRANSPARENT'
  end
  object sFontStore1: TsFontStore
    Fonts = <>
    Left = 456
    Top = 100
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 496
    Top = 100
  end
end
