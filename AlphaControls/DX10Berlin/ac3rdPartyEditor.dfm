object Form3rdPartyEditor: TForm3rdPartyEditor
  Left = 260
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '3rd-party controls names'
  ClientHeight = 524
  ClientWidth = 746
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 440
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sBitBtn2: TsSpeedButton
    Left = 26
    Top = 487
    Width = 62
    Height = 25
    Caption = 'New'
    Flat = True
    OnClick = sBitBtn2Click
    Images = acDM.sCharImageList1
    ImageIndex = 2
  end
  object sBitBtn3: TsSpeedButton
    Left = 151
    Top = 487
    Width = 73
    Height = 25
    Caption = 'Delete'
    Flat = True
    OnClick = sBitBtn3Click
    Images = acDM.sCharImageList1
    ImageIndex = 3
  end
  object sSpeedButton1: TsSpeedButton
    Left = 90
    Top = 487
    Width = 58
    Height = 25
    Caption = 'Edit'
    Enabled = False
    Flat = True
    OnClick = sSpeedButton1Click
    Images = acDM.sCharImageList1
    ImageIndex = 14
  end
  object sSpeedButton4: TsSpeedButton
    Left = 380
    Top = 487
    Width = 110
    Height = 25
    Caption = 'Save to file'
    Flat = True
    OnClick = sSpeedButton4Click
    Images = acDM.sCharImageList1
    ImageIndex = 15
  end
  object sSpeedButton5: TsSpeedButton
    Left = 494
    Top = 487
    Width = 110
    Height = 25
    Caption = 'Load from file'
    Flat = True
    OnClick = sSpeedButton5Click
    Images = acDM.sCharImageList1
    ImageIndex = 16
  end
  object sSpeedButton6: TsSpeedButton
    Left = 227
    Top = 487
    Width = 74
    Height = 25
    Hint = 'Remove all rows from list'
    Caption = 'Clear all'
    Flat = True
    OnClick = sSpeedButton6Click
    Images = acDM.sCharImageList1
    ImageIndex = 21
  end
  object sListView1: TsListView
    Left = 24
    Top = 24
    Width = 333
    Height = 453
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    BoundLabel.Active = True
    BoundLabel.Indent = 2
    BoundLabel.Caption = 
      'List of controls which will be skinned automatically (register s' +
      'ensitive):'
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclTopLeft
    SkinData.SkinSection = 'EDIT'
    Columns = <
      item
        Caption = 'Control class name'
        Width = 160
      end
      item
        AutoSize = True
        Caption = 'Type of skin'
      end>
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu1
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = sListView1Change
    OnColumnClick = sListView1ColumnClick
    OnDblClick = sListView1DblClick
  end
  object sBitBtn1: TsBitBtn
    Left = 656
    Top = 487
    Width = 67
    Height = 25
    Cancel = True
    Caption = 'Exit'
    TabOrder = 1
    OnClick = sBitBtn1Click
    ImageIndex = 13
    Images = acDM.sCharImageList1
  end
  object sPanel1: TsPanel
    Left = 380
    Top = 24
    Width = 343
    Height = 453
    TabOrder = 2
    object sSpeedButton2: TsSpeedButton
      Left = 175
      Top = 416
      Width = 150
      Height = 25
      Caption = 'Add/use selected items'
      Enabled = False
      OnClick = sSpeedButton2Click
      Images = acDM.sCharImageList1
      ImageIndex = 7
    end
    object sListBox1: TsListBox
      Left = 16
      Top = 32
      Width = 150
      Height = 409
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      Items.Strings = (
        'Standard VCL'
        'Standard DB-aware'
        'TNT Controls'
        'Woll2Woll'
        'Virtual Controls'
        'EhLib'
        'Fast/Quick Report'
        'RXLib'
        'JVCL'
        'TMS edits'
        'SynEdits'
        'mxEdits'
        'RichViews'
        'Raize'
        'ImageEn')
      ParentFont = False
      TabOrder = 0
      OnClick = sListBox1Click
      BoundLabel.Active = True
      BoundLabel.Indent = 2
      BoundLabel.Offset = 4
      BoundLabel.Caption = 'Packages:'
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclTopLeft
      SkinData.SkinSection = 'EDIT'
    end
    object sListBox2: TsCheckListBox
      Left = 175
      Top = 32
      Width = 150
      Height = 354
      BorderStyle = bsSingle
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
      BoundLabel.Active = True
      BoundLabel.Indent = 2
      BoundLabel.Offset = 4
      BoundLabel.Caption = 'Supported controls:'
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclTopLeft
      SkinData.SkinSection = 'EDIT'
    end
    object sCheckBox1: TsCheckBox
      Tag = 1
      Left = 185
      Top = 392
      Width = 114
      Height = 17
      Caption = 'Select/deselect all'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 2
      OnClick = sCheckBox1Click
      ImgChecked = 0
      ImgUnchecked = 0
    end
  end
  object sPanel2: TsPanel
    Left = 388
    Top = 12
    Width = 327
    Height = 21
    Caption = 'Predefined controls sets'
    TabOrder = 3
    SkinData.SkinSection = 'TOOLBAR'
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 368
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 420
    Top = 4
    object Addnew1: TMenuItem
      Caption = 'Add new'
      ShortCut = 45
      OnClick = sBitBtn2Click
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      Enabled = False
      OnClick = Edit1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      Enabled = False
      ShortCut = 46
      OnClick = sBitBtn3Click
    end
    object Defaultsettings1: TMenuItem
      Caption = 'Default settings'
      Visible = False
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      ShortCut = 27
      OnClick = sBitBtn1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'Ini-files (*.ini)|*.ini|All files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 220
    Top = 308
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'Ini-files (*.ini)|*.ini|All files|*.*'
    Left = 248
    Top = 308
  end
end
