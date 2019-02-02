object FormInternalSkins: TFormInternalSkins
  Left = 552
  Top = 239
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Internal skins'
  ClientHeight = 320
  ClientWidth = 424
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 430
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 35
    Width = 424
    Height = 285
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object sPanel3: TsPanel
      Left = 195
      Top = 8
      Width = 221
      Height = 269
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object sGroupBox1: TsGroupBox
        Left = 8
        Top = 0
        Width = 211
        Height = 152
        Caption = 'Skin info:'
        TabOrder = 0
        object sLabel10: TsLabel
          Left = 18
          Top = 96
          Width = 181
          Height = 45
          AutoSize = False
          Caption = 'Description:'
          WordWrap = True
        end
        object sLabel11: TsLabel
          Left = 52
          Top = 77
          Width = 23
          Height = 13
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'Size:'
          ParentBiDiMode = False
        end
        object sLabel12: TsLabel
          Left = 78
          Top = 77
          Width = 42
          Height = 13
          Caption = 'sLabel12'
        end
        object sLabel9: TsLabel
          Left = 78
          Top = 58
          Width = 36
          Height = 13
          Caption = 'sLabel9'
        end
        object sLabel5: TsLabel
          Left = 26
          Top = 58
          Width = 49
          Height = 13
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'File name:'
          ParentBiDiMode = False
        end
        object sLabel4: TsLabel
          Left = 38
          Top = 39
          Width = 37
          Height = 13
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'Author:'
          ParentBiDiMode = False
        end
        object sLabel8: TsLabel
          Left = 78
          Top = 39
          Width = 36
          Height = 13
          Caption = 'sLabel8'
        end
        object sLabel7: TsLabel
          Left = 78
          Top = 20
          Width = 36
          Height = 13
          Caption = 'sLabel7'
        end
        object sLabel3: TsLabel
          Left = 36
          Top = 20
          Width = 39
          Height = 13
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'Version:'
          ParentBiDiMode = False
        end
      end
      object sBitBtn1: TsBitBtn
        Left = 143
        Top = 242
        Width = 73
        Height = 27
        Anchors = [akLeft, akBottom]
        Cancel = True
        Caption = 'Exit'
        Default = True
        Spacing = 6
        TabOrder = 1
        OnClick = sBitBtn1Click
        Blend = 30
        ImageIndex = 13
        Images = acDM.sCharImageList1
      end
      object sGroupBox2: TsGroupBox
        Left = 8
        Top = 156
        Width = 213
        Height = 81
        Caption = 'External storage:'
        TabOrder = 2
        object sLabel1: TsLabel
          Left = 7
          Top = 19
          Width = 199
          Height = 27
          AutoSize = False
          Caption = 'sLabel1'
          WordWrap = True
        end
        object sButton6: TsBitBtn
          Left = 5
          Top = 49
          Width = 203
          Height = 25
          Caption = 'Update internal skins from storage'
          Spacing = 6
          TabOrder = 0
          OnClick = sButton6Click
          Blend = 30
          ImageIndex = 24
          Images = acDM.sCharImageList1
        end
      end
    end
    object ListBox1: TsListBox
      Left = 8
      Top = 8
      Width = 187
      Height = 269
      Align = alClient
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      Sorted = True
      TabOrder = 1
      OnClick = ListBox1Click
      SkinData.SkinSection = 'EDIT'
    end
  end
  object sPanel6: TsPanel
    Left = 0
    Top = 0
    Width = 424
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object sSpeedButton1: TsSpeedButton
      Left = 8
      Top = 6
      Width = 73
      Height = 27
      Caption = 'Add...'
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton1Click
      Images = acDM.sCharImageList1
      ImageIndex = 2
    end
    object sSpeedButton2: TsSpeedButton
      Left = 81
      Top = 6
      Width = 79
      Height = 27
      Caption = 'Rename'
      Enabled = False
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton2Click
      Images = acDM.sCharImageList1
      ImageIndex = 14
    end
    object sSpeedButton3: TsSpeedButton
      Left = 160
      Top = 6
      Width = 79
      Height = 27
      Caption = 'Delete'
      Enabled = False
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton3Click
      Images = acDM.sCharImageList1
      ImageIndex = 3
    end
    object sSpeedButton4: TsSpeedButton
      Left = 239
      Top = 6
      Width = 73
      Height = 27
      Caption = 'Clear'
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton4Click
      Images = acDM.sCharImageList1
      ImageIndex = 22
    end
    object sSpeedButton5: TsSpeedButton
      Left = 312
      Top = 6
      Width = 79
      Height = 27
      Caption = 'Extract'
      Enabled = False
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton5Click
      Images = acDM.sCharImageList1
      ImageIndex = 15
    end
  end
  object sSkinProvider1: TsSkinProvider
    ShowAppIcon = False
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    TitleIcon.Visible = False
    Left = 104
    Top = 95
  end
end
