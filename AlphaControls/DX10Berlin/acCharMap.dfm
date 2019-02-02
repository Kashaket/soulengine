object FormCharMap: TFormCharMap
  Left = 410
  Top = 338
  BorderStyle = bsNone
  Caption = 'FormCharMap'
  ClientHeight = 396
  ClientWidth = 598
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 0
    Top = 0
    Width = 598
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object sPanel2: TsPanel
      Left = 4
      Top = 354
      Width = 590
      Height = 38
      SkinData.SkinSection = 'TRANSPARENT'
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object sLabel1: TsLabel
        Left = 432
        Top = 14
        Width = 56
        Height = 13
        Caption = 'Char code: '
      end
      object sLabel2: TsLabel
        Left = 494
        Top = 14
        Width = 6
        Height = 13
        Caption = '0'
      end
      object sComboBox1: TsComboBox
        Left = 68
        Top = 10
        Width = 123
        Height = 21
        BoundLabel.Active = True
        BoundLabel.ParentFont = False
        BoundLabel.Caption = 'Charset:'
        DropDownCount = 20
        Style = csDropDownList
        ItemIndex = -1
        TabOrder = 0
        OnChange = sComboBox1Change
        Items.Strings = (
          'ANSI_CHARSET'
          'DEFAULT_CHARSET'
          'SYMBOL_CHARSET'
          'SHIFTJIS_CHARSET'
          'HANGEUL_CHARSET'
          'GB2312_CHARSET'
          'CHINESEBIG5_CHARSET'
          'OEM_CHARSET'
          'JOHAB_CHARSET'
          'HEBREW_CHARSET'
          'ARABIC_CHARSET'
          'GREEK_CHARSET'
          'TURKISH_CHARSET'
          'VIETNAMESE_CHARSET'
          'THAI_CHARSET'
          'EASTEUROPE_CHARSET'
          'RUSSIAN_CHARSET'
          'MAC_CHARSET'
          'BALTIC_CHARSET'
          'Embedded Fonts')
      end
      object sComboBox2: TsComboBox
        Left = 268
        Top = 10
        Width = 135
        Height = 21
        BoundLabel.Active = True
        BoundLabel.ParentFont = False
        BoundLabel.Caption = 'Font name:'
        Style = csDropDownList
        ItemIndex = -1
        TabOrder = 1
        OnChange = sComboBox2Change
      end
    end
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'EDIT'
    TitleButtons = <>
    ThirdParty.ThirdGrids = 'TacCharGrid'#13#10
    OnSkinItemEx = sSkinProvider1SkinItemEx
    Left = 320
    Top = 120
  end
end
