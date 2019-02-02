object FormSkinSelect: TFormSkinSelect
  Left = 555
  Top = 522
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Select skin'
  ClientHeight = 348
  ClientWidth = 507
  Color = clBtnFace
  Constraints.MinHeight = 360
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sListBox1: TsListBox
    Left = 16
    Top = 53
    Width = 130
    Height = 281
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnClick = sListBox1Click
    OnDblClick = sListBox1DblClick
    BoundLabel.Caption = 'Available skins:'
    BoundLabel.Layout = sclTopLeft
    SkinData.SkinSection = 'EDIT'
  end
  object sBitBtn1: TsBitBtn
    Left = 340
    Top = 313
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
    ImageIndex = 9
  end
  object sBitBtn2: TsBitBtn
    Left = 420
    Top = 313
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    ImageIndex = 10
  end
  object sPanel1: TsPanel
    Left = 163
    Top = 53
    Width = 330
    Height = 251
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'Skin preview'
    Enabled = False
    TabOrder = 3
  end
  object sDirectoryEdit1: TsDirectoryEdit
    Left = 128
    Top = 16
    Width = 365
    Height = 21
    AutoSize = False
    MaxLength = 255
    TabOrder = 4
    Text = ''
    OnChange = sDirectoryEdit1Change
    CheckOnExit = True
    BoundLabel.Active = True
    BoundLabel.Caption = 'Directory with skins :'
    SkinData.SkinSection = 'EDIT'
    Root = 'rfDesktop'
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 448
    Top = 8
  end
end
