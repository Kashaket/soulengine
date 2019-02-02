object PathDialogForm: TPathDialogForm
  Left = 434
  Top = 310
  Caption = 'Select directory'
  ClientHeight = 415
  ClientWidth = 370
  Color = clBtnFace
  Constraints.MinHeight = 415
  Constraints.MinWidth = 370
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel1: TsLabel
    Left = 18
    Top = 3
    Width = 3
    Height = 13
  end
  object sBitBtn1: TsBitBtn
    Left = 196
    Top = 375
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = sBitBtn1Click
    ShowFocus = False
    ImageIndex = 9
  end
  object sBitBtn2: TsBitBtn
    Left = 279
    Top = 375
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = sBitBtn2Click
    ShowFocus = False
    ImageIndex = 10
  end
  object sBitBtn3: TsBitBtn
    Left = 15
    Top = 375
    Width = 101
    Height = 25
    Caption = 'Create'
    Enabled = False
    TabOrder = 3
    OnClick = sBitBtn3Click
    ShowFocus = False
    ImageIndex = 11
  end
  object sShellTreeView1: TsShellTreeView
    Left = 15
    Top = 20
    Width = 345
    Height = 349
    Indent = 19
    ShowRoot = False
    TabOrder = 0
    OnChange = sShellTreeView1Change
    BoundLabel.Active = True
    BoundLabel.Indent = 4
    BoundLabel.Caption = ' '
    BoundLabel.Layout = sclTopLeft
    SkinData.SkinSection = 'EDIT'
    ObjectTypes = [otFolders, otHidden]
    Root = 'rfDesktop'
    UseShellImages = True
    AutoRefresh = True
    ShowExt = seSystem
  end
  object sScrollBox1: TsScrollBox
    Left = 15
    Top = 20
    Width = 101
    Height = 349
    VertScrollBar.Tracking = True
    TabOrder = 4
    Visible = False
    SkinData.SkinSection = 'BAR'
  end
  object sSkinProvider1: TsSkinProvider
    ShowAppIcon = False
    SkinData.SkinSection = 'DIALOG'
    GripMode = gmRightBottom
    TitleButtons = <>
    Left = 219
    Top = 168
  end
  object ImageList1: TsAlphaImageList
    ShareImages = True
    Items = <>
    Left = 184
    Top = 168
  end
end
