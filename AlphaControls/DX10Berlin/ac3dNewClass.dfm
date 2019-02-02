object FormNewThirdClass: TFormNewThirdClass
  Left = 405
  Top = 430
  BorderStyle = bsDialog
  Caption = 'New third-party control'
  ClientHeight = 141
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sEdit1: TsEdit
    Left = 112
    Top = 24
    Width = 190
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    TabOrder = 0
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Class name:'
  end
  object sComboBox1: TsComboBox
    Left = 112
    Top = 56
    Width = 190
    Height = 21
    Alignment = taLeftJustify
    BoundLabel.Active = True
    BoundLabel.Caption = 'Type of skin:'
    VerticalAlignment = taAlignTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Style = csDropDownList
    ItemIndex = -1
    TabOrder = 1
  end
  object sBitBtn1: TsBitBtn
    Left = 88
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    ImageIndex = 0
    Images = acDM.sCharImageList1
  end
  object sBitBtn2: TsBitBtn
    Left = 168
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    ImageIndex = 12
    Images = acDM.sCharImageList1
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 288
    Top = 8
  end
end
