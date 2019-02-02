object FormImgListEditor: TFormImgListEditor
  Left = 289
  Top = 196
  ClientHeight = 143
  ClientWidth = 600
  Color = clBtnFace
  Constraints.MinHeight = 220
  Constraints.MinWidth = 612
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TsSpeedButton
    Left = 9
    Top = 5
    Width = 74
    Height = 30
    Caption = 'Add'
    Flat = True
    OnClick = SpeedButton1Click
    Images = acDM.sCharImageList1
    ImageIndex = 2
  end
  object SpeedButton2: TsSpeedButton
    Left = 86
    Top = 5
    Width = 74
    Height = 30
    Caption = 'Delete'
    Enabled = False
    Flat = True
    OnClick = SpeedButton2Click
    Images = acDM.sCharImageList1
    ImageIndex = 3
  end
  object SpeedButton3: TsSpeedButton
    Left = 240
    Top = 5
    Width = 74
    Height = 30
    Caption = 'Clear'
    Flat = True
    OnClick = SpeedButton3Click
    Images = acDM.sCharImageList1
    ImageIndex = 22
  end
  object SpeedButton4: TsSpeedButton
    Left = 424
    Top = 5
    Width = 113
    Height = 30
    Caption = 'Extract all'
    Enabled = False
    Flat = True
    OnClick = SpeedButton4Click
    Images = acDM.sCharImageList1
    ImageIndex = 21
  end
  object SpeedButton5: TsSpeedButton
    Left = 163
    Top = 5
    Width = 74
    Height = 30
    Caption = 'Replace'
    Enabled = False
    Flat = True
    OnClick = SpeedButton5Click
    Images = acDM.sCharImageList1
    ImageIndex = 19
  end
  object SpeedButton6: TsSpeedButton
    Left = 317
    Top = 5
    Width = 104
    Height = 30
    Caption = 'Extract as...'
    Enabled = False
    Flat = True
    OnClick = SpeedButton6Click
    Images = acDM.sCharImageList1
    ImageIndex = 20
  end
  object sBitBtn6: TsBitBtn
    Left = 506
    Top = 71
    Width = 86
    Height = 29
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = sBitBtn6Click
    ImageIndex = 12
    Images = acDM.sCharImageList1
  end
  object sBitBtn7: TsBitBtn
    Left = 506
    Top = 102
    Width = 86
    Height = 29
    Caption = 'Apply'
    TabOrder = 3
    OnClick = sBitBtn7Click
    ImageIndex = 18
    Images = acDM.sCharImageList1
  end
  object sBitBtn5: TsBitBtn
    Left = 506
    Top = 40
    Width = 86
    Height = 29
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = sBitBtn5Click
    ImageIndex = 0
    Images = acDM.sCharImageList1
  end
  object ListView1: TsListView
    Left = 8
    Top = 40
    Width = 490
    Height = 68
    SkinData.SkinSection = 'EDIT'
    Columns = <>
    DragMode = dmAutomatic
    LargeImages = ImageList1
    SmallImages = ImageList1
    TabOrder = 0
    OnClick = ListView1Click
    OnDragDrop = ListView1DragDrop
    OnDragOver = ListView1DragOver
    OnKeyDown = ListView1KeyDown
  end
  object sEdit1: TsEdit
    Left = 78
    Top = 114
    Width = 287
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    OnChange = sEdit1Change
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Item text:'
  end
  object ImageList1: TsAlphaImageList
    DrawingStyle = dsTransparent
    Height = 32
    Width = 32
    Items = <>
    Left = 276
    Top = 56
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All (*.png, *.ico)|*.png;*.ico|Icons (*.ico)|*.ico|Png (*.png)|*' +
      '.png'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = 'Add image'
    Left = 308
    Top = 56
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    GripMode = gmRightBottom
    TitleButtons = <>
    Left = 212
    Top = 56
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Icons|*.ico|Portable Network Graphics|*.png'
    Title = 'Save glyph as ...'
    Left = 340
    Top = 56
  end
end
