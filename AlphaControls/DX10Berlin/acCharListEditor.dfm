object FormCharListEditor: TFormCharListEditor
  Left = 393
  Top = 304
  Caption = 'FormCharListEditor'
  ClientHeight = 474
  ClientWidth = 784
  Color = clBtnFace
  Constraints.MinHeight = 430
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel1: TsPanel
    Left = 493
    Top = 0
    Width = 291
    Height = 455
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object sPanel2: TsPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 291
      Height = 455
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object sPageControl1: TsPageControl
        Left = 12
        Top = 4
        Width = 265
        Height = 259
        ActivePage = sTabSheet1
        Anchors = [akLeft, akTop, akBottom]
        Images = acDM.sCharImageList1
        TabHeight = 26
        TabOrder = 0
        OnChange = sPageControl1Change
        AccessibleDisabledPages = False
        TabPadding = 2
        object sTabSheet1: TsTabSheet
          BorderWidth = 3
          Caption = 'System fonts'
          ImageIndex = 5
          object sListBox1: TsListBox
            Left = 0
            Top = 29
            Width = 251
            Height = 188
            Align = alBottom
            Anchors = [akLeft, akTop, akRight, akBottom]
            Columns = 2
            TabOrder = 0
            OnClick = sListBox1Click
            BoundLabel.Caption = 'Font name:'
            BoundLabel.Layout = sclLeftTop
          end
          object sComboBox1: TsComboBox
            Left = 0
            Top = 0
            Width = 251
            Height = 21
            Align = alTop
            BoundLabel.Caption = 'Charset:'
            DropDownCount = 20
            Style = csDropDownList
            ItemIndex = -1
            TabOrder = 1
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
              'BALTIC_CHARSET')
          end
        end
        object sTabSheet2: TsTabSheet
          BorderWidth = 3
          Caption = 'Embedded fonts'
          ImageIndex = 1
          object sListBox2: TsListBox
            Left = 0
            Top = 29
            Width = 251
            Height = 188
            Align = alClient
            TabOrder = 0
            OnClick = sListBox2Click
            BoundLabel.Layout = sclLeftTop
            OnBeforeItemDraw = sListBox2BeforeItemDraw
          end
          object sPanel4: TsPanel
            Left = 0
            Top = 0
            Width = 251
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object sSpeedButton5: TsSpeedButton
              Left = 0
              Top = 0
              Width = 105
              Height = 25
              Align = alClient
              Caption = 'Add fonts...'
              Flat = True
              OnClick = sSpeedButton5Click
              Images = acDM.sCharImageList1
              ImageIndex = 2
            end
            object sSpeedButton6: TsSpeedButton
              Left = 172
              Top = 0
              Width = 79
              Height = 25
              Align = alRight
              Caption = 'Clear all'
              Flat = True
              OnClick = sSpeedButton6Click
              Images = acDM.sCharImageList1
              ImageIndex = 6
            end
            object sSpeedButton7: TsSpeedButton
              Left = 105
              Top = 0
              Width = 67
              Height = 25
              Align = alRight
              Caption = 'Delete'
              Enabled = False
              Flat = True
              OnClick = sSpeedButton7Click
              Images = acDM.sCharImageList1
              ImageIndex = 3
            end
          end
          object sPanel5: TsPanel
            Left = 0
            Top = 25
            Width = 251
            Height = 4
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
          end
        end
      end
      object sPanel7: TsPanel
        Left = 0
        Top = 265
        Width = 291
        Height = 190
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 4
        TabOrder = 1
        object sGroupBox1: TsGroupBox
          Left = 12
          Top = 4
          Width = 265
          Height = 140
          Caption = 'Char options'
          TabOrder = 0
          object sLabel1: TsLabel
            Left = 68
            Top = 69
            Width = 23
            Height = 13
            Alignment = taRightJustify
            Caption = 'Size:'
          end
          object sLabel2: TsLabel
            Left = 35
            Top = 104
            Width = 56
            Height = 13
            Alignment = taRightJustify
            Caption = 'Vert offset:'
          end
          object sLabel3: TsLabel
            Left = 221
            Top = 69
            Width = 15
            Height = 13
            Caption = 'x 1'
          end
          object sLabel4: TsLabel
            Left = 221
            Top = 104
            Width = 6
            Height = 13
            Caption = '0'
          end
          object sTrackBar1: TsTrackBar
            Left = 92
            Top = 65
            Width = 129
            Height = 27
            Max = 100
            Min = -100
            TabOrder = 0
            TickStyle = tsNone
            OnChange = sTrackBar1Change
            OnUserChange = sTrackBar1Change
          end
          object sTrackBar2: TsTrackBar
            Left = 92
            Top = 100
            Width = 129
            Height = 27
            Min = -10
            TabOrder = 1
            TickStyle = tsNone
            OnChange = sTrackBar2Change
          end
          object sColorBox1: TsColorBox
            Left = 99
            Top = 30
            Width = 146
            Height = 22
            BoundLabel.Active = True
            BoundLabel.Indent = 3
            BoundLabel.Caption = 'Default color:'
            Style = [cbIncludeNone, cbCustomColor, cbSkinColors]
            Selected = clNone
            NoneColorColor = clNone
            TabOrder = 2
            OnChange = sColorBox1Change
          end
        end
        object sButton1: TsBitBtn
          Left = 111
          Top = 154
          Width = 81
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'OK'
          Default = True
          ModalResult = 1
          TabOrder = 1
          OnClick = sButton1Click
          ImageIndex = 0
          Images = acDM.sCharImageList1
        end
        object sButton2: TsBitBtn
          Left = 196
          Top = 154
          Width = 81
          Height = 25
          Anchors = [akRight, akBottom]
          Cancel = True
          Caption = 'Cancel'
          ModalResult = 2
          TabOrder = 2
          ImageIndex = 12
          Images = acDM.sCharImageList1
        end
      end
    end
  end
  object sStatusBar1: TsStatusBar
    Left = 0
    Top = 455
    Width = 784
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Panels = <
      item
        Alignment = taRightJustify
        Text = 'Size:'
        Width = 46
      end
      item
        Width = 80
      end
      item
        Alignment = taRightJustify
        Text = 'CharCode:'
        Width = 80
      end
      item
        Width = 70
      end
      item
        Alignment = taRightJustify
        Text = 'Font name:'
        Width = 110
      end
      item
        Width = 1000
      end>
    UseSystemFont = False
  end
  object sPanel3: TsPanel
    Left = 0
    Top = 0
    Width = 493
    Height = 455
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object sPanel6: TsPanel
      Left = 0
      Top = 0
      Width = 493
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 4
      TabOrder = 0
      object sSpeedButton1: TsSpeedButton
        Left = 4
        Top = 4
        Width = 101
        Height = 25
        Align = alLeft
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'Add new'
        Flat = True
        Spacing = 6
        OnMouseDown = sSpeedButton1MouseDown
        OnMouseUp = sSpeedButton1MouseUp
        ButtonStyle = tbsDropDown
        Images = acDM.sCharImageList1
        Blend = 25
        ImageIndex = 2
      end
      object sSpeedButton2: TsSpeedButton
        Left = 202
        Top = 4
        Width = 92
        Height = 25
        Align = alLeft
        Caption = 'Delete'
        Enabled = False
        Flat = True
        Spacing = 6
        OnClick = sSpeedButton2Click
        Images = acDM.sCharImageList1
        Blend = 25
        ImageIndex = 3
      end
      object sSpeedButton4: TsSpeedButton
        Left = 294
        Top = 4
        Width = 92
        Height = 25
        Align = alLeft
        Caption = 'Remove all'
        Enabled = False
        Flat = True
        Spacing = 6
        OnClick = sSpeedButton4Click
        Images = acDM.sCharImageList1
        Blend = 25
        ImageIndex = 6
      end
      object sSpeedButton3: TsSpeedButton
        Tag = 1
        Left = 105
        Top = 4
        Width = 97
        Height = 25
        Align = alLeft
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Replace'
        Flat = True
        Spacing = 6
        OnMouseDown = sSpeedButton3MouseDown
        OnMouseUp = sSpeedButton1MouseUp
        ButtonStyle = tbsDropDown
        Images = acDM.sCharImageList1
        Blend = 25
        ImageIndex = 19
      end
    end
    object sListView1: TsListView
      Left = 4
      Top = 34
      Width = 489
      Height = 417
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <>
      DragMode = dmAutomatic
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      TabOrder = 1
      OnClick = sListView1Click
      OnDragDrop = sListView1DragDrop
      OnDragOver = sListView1DragOver
      OnResize = sListView1Resize
    end
  end
  object CharImageList: TsCharImageList
    EmbeddedFonts = <>
    Items = <>
    Left = 202
    Top = 129
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 230
    Top = 129
  end
  object sOpenDialog1: TsOpenDialog
    DefaultExt = '*.ttf'
    Filter = 
      'Supported fonts|*.ttf;*.otf|TrueType fonts|*.ttf|OpenType fonts|' +
      '*.otf'
    Options = [ofAllowMultiSelect, ofEnableSizing]
    Left = 259
    Top = 129
  end
end
