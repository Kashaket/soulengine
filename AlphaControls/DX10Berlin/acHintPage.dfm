object FrameHintPage: TFrameHintPage
  Left = 0
  Top = 0
  Width = 505
  Height = 391
  TabOrder = 0
  object sSpeedButton3: TsSpeedButton
    Tag = 32
    Left = 40
    Top = 218
    Width = 105
    Height = 25
    Caption = 'Load image'
    Enabled = False
    Flat = True
    Spacing = 8
    OnClick = sSpeedButton3Click
    Images = acDM.sCharImageList1
    ImageIndex = 16
  end
  object sLabel21: TsLabel
    Tag = 64
    Left = 159
    Top = 224
    Width = 32
    Height = 13
    Caption = 'Width:'
    Enabled = False
  end
  object sLabel23: TsLabel
    Tag = 64
    Left = 197
    Top = 224
    Width = 4
    Height = 13
    Caption = '-'
    Enabled = False
  end
  object sLabel22: TsLabel
    Tag = 64
    Left = 232
    Top = 224
    Width = 35
    Height = 13
    Caption = 'Height:'
    Enabled = False
  end
  object sLabel24: TsLabel
    Tag = 64
    Left = 273
    Top = 224
    Width = 4
    Height = 13
    Caption = '-'
    Enabled = False
  end
  object sSpeedButton1: TsSpeedButton
    Left = 8
    Top = 8
    Width = 31
    Height = 25
    GroupIndex = 1
    Down = True
    Caption = '1:1'
    OnClick = sSpeedButton1Click
  end
  object sSpeedButton2: TsSpeedButton
    Tag = 2
    Left = 8
    Top = 32
    Width = 31
    Height = 25
    GroupIndex = 1
    Caption = '1:2'
    OnClick = sSpeedButton1Click
  end
  object sScrollBox1: TsScrollBox
    Left = 40
    Top = 8
    Width = 276
    Height = 201
    TabOrder = 6
    SkinData.SkinSection = 'EDIT'
    SkinData.OuterEffects.Visibility = ovAlways
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 272
      Height = 197
      Align = alClient
      OnPaint = PaintBox1Paint
    end
  end
  object sGroupBox3: TsGroupBox
    Tag = 64
    Left = 327
    Top = 133
    Width = 175
    Height = 123
    Caption = 'Content margins'
    Enabled = False
    TabOrder = 4
    CaptionLayout = clTopCenter
    object sLabel41: TsLabel
      Tag = 64
      Left = 24
      Top = 27
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = 'Left:'
      Enabled = False
    end
    object sLabel4: TsLabel
      Tag = 64
      Left = 53
      Top = 27
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel43: TsLabel
      Tag = 64
      Left = 24
      Top = 68
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = 'Top:'
      Enabled = False
    end
    object sLabel10: TsLabel
      Tag = 64
      Left = 52
      Top = 68
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel42: TsLabel
      Tag = 64
      Left = 96
      Top = 27
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Right:'
      Enabled = False
    end
    object sLabel15: TsLabel
      Tag = 64
      Left = 131
      Top = 27
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel144: TsLabel
      Tag = 64
      Left = 87
      Top = 68
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Bottom:'
      Enabled = False
    end
    object sLabel20: TsLabel
      Tag = 64
      Left = 131
      Top = 68
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sRangeSelector3: TsRangeSelector
      Left = 3
      Top = 42
      Width = 169
      Height = 29
      TabOrder = 0
      OnChange = sRangeSelector3Change
      ChangingMode = cmUndepended
      TickStyle = tsNone
    end
    object sRangeSelector4: TsRangeSelector
      Left = 3
      Top = 83
      Width = 169
      Height = 29
      TabOrder = 1
      OnChange = sRangeSelector4Change
      ChangingMode = cmUndepended
      TickStyle = tsNone
    end
  end
  object sGroupBox4: TsGroupBox
    Tag = 64
    Left = 8
    Top = 249
    Width = 308
    Height = 102
    Caption = ' Draw mode: '
    Enabled = False
    TabOrder = 0
    CaptionLayout = clTopCenter
    object sLabel34: TsLabel
      Tag = 64
      Left = 36
      Top = 20
      Width = 19
      Height = 13
      Caption = 'Left'
      Enabled = False
    end
    object sLabel35: TsLabel
      Tag = 64
      Left = 94
      Top = 20
      Width = 18
      Height = 13
      Caption = 'Top'
      Enabled = False
    end
    object sLabel36: TsLabel
      Tag = 64
      Left = 145
      Top = 20
      Width = 25
      Height = 13
      Caption = 'Right'
      Enabled = False
    end
    object sLabel37: TsLabel
      Tag = 64
      Left = 196
      Top = 20
      Width = 34
      Height = 13
      Caption = 'Bottom'
      Enabled = False
    end
    object sLabel38: TsLabel
      Tag = 64
      Left = 254
      Top = 20
      Width = 33
      Height = 13
      Caption = 'Center'
      Enabled = False
    end
    object sGroupBox5: TsPanel
      Left = 15
      Top = 39
      Width = 72
      Height = 52
      BevelOuter = bvNone
      TabOrder = 0
      object sRadioButton1: TsRadioButton
        Tag = 64
        Left = 4
        Top = 4
        Width = 63
        Height = 17
        Caption = 'Repeat'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton1Click
      end
      object sRadioButton2: TsRadioButton
        Tag = 65
        Left = 4
        Top = 28
        Width = 63
        Height = 17
        Caption = 'Stretch'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton1Click
      end
    end
    object sGroupBox6: TsPanel
      Left = 87
      Top = 39
      Width = 42
      Height = 52
      BevelOuter = bvNone
      TabOrder = 1
      object sRadioButton3: TsRadioButton
        Tag = 66
        Left = 4
        Top = 4
        Width = 35
        Height = 17
        Caption = 'R'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton1Click
      end
      object sRadioButton4: TsRadioButton
        Tag = 67
        Left = 4
        Top = 28
        Width = 34
        Height = 17
        Caption = 'S'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton1Click
      end
    end
    object sPanel1: TsPanel
      Left = 143
      Top = 39
      Width = 34
      Height = 52
      BevelOuter = bvNone
      TabOrder = 2
      object sRadioButton5: TsRadioButton
        Tag = 68
        Left = 4
        Top = 4
        Width = 35
        Height = 17
        Caption = 'R'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton1Click
      end
      object sRadioButton6: TsRadioButton
        Tag = 69
        Left = 4
        Top = 28
        Width = 34
        Height = 17
        Caption = 'S'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton1Click
      end
    end
    object sPanel2: TsPanel
      Left = 199
      Top = 39
      Width = 34
      Height = 52
      BevelOuter = bvNone
      TabOrder = 3
      object sRadioButton7: TsRadioButton
        Tag = 70
        Left = 4
        Top = 4
        Width = 35
        Height = 17
        Caption = 'R'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton1Click
      end
      object sRadioButton8: TsRadioButton
        Tag = 71
        Left = 4
        Top = 28
        Width = 34
        Height = 17
        Caption = 'S'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton1Click
      end
    end
    object sPanel3: TsPanel
      Left = 255
      Top = 39
      Width = 34
      Height = 52
      BevelOuter = bvNone
      TabOrder = 4
      object sRadioButton9: TsRadioButton
        Tag = 72
        Left = 4
        Top = 4
        Width = 35
        Height = 17
        Caption = 'R'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton1Click
      end
      object sRadioButton10: TsRadioButton
        Tag = 73
        Left = 4
        Top = 28
        Width = 34
        Height = 17
        Caption = 'S'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton1Click
      end
    end
  end
  object sGroupBox7: TsGroupBox
    Tag = 64
    Left = 327
    Top = 261
    Width = 175
    Height = 123
    Caption = 'Shadow size:'
    Enabled = False
    TabOrder = 5
    CaptionLayout = clTopCenter
    object sLabel1: TsLabel
      Tag = 64
      Left = 147
      Top = 24
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel3: TsLabel
      Tag = 64
      Left = 147
      Top = 48
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel5: TsLabel
      Tag = 64
      Left = 147
      Top = 72
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel6: TsLabel
      Tag = 64
      Left = 147
      Top = 96
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel7: TsLabel
      Tag = 64
      Left = 12
      Top = 24
      Width = 5
      Height = 13
      Caption = 'L'
      Enabled = False
    end
    object sLabel8: TsLabel
      Tag = 64
      Left = 12
      Top = 48
      Width = 6
      Height = 13
      Caption = 'T'
      Enabled = False
    end
    object sLabel11: TsLabel
      Tag = 64
      Left = 12
      Top = 72
      Width = 7
      Height = 13
      Caption = 'R'
      Enabled = False
    end
    object sLabel12: TsLabel
      Tag = 64
      Left = 12
      Top = 96
      Width = 6
      Height = 13
      Caption = 'B'
      Enabled = False
    end
    object sTrackBar9: TsTrackBar
      Tag = 65
      Left = 20
      Top = 19
      Width = 126
      Height = 24
      Enabled = False
      Max = 20
      TabOrder = 0
      OnChange = sTrackBar9Change
      ShowProgress = True
    end
    object sTrackBar10: TsTrackBar
      Tag = 64
      Left = 20
      Top = 43
      Width = 126
      Height = 24
      Enabled = False
      Max = 20
      TabOrder = 1
      OnChange = sTrackBar10Change
      ShowProgress = True
    end
    object sTrackBar11: TsTrackBar
      Tag = 67
      Left = 20
      Top = 67
      Width = 126
      Height = 24
      Enabled = False
      Max = 20
      TabOrder = 2
      OnChange = sTrackBar11Change
      ShowProgress = True
    end
    object sTrackBar12: TsTrackBar
      Tag = 66
      Left = 20
      Top = 91
      Width = 126
      Height = 24
      Enabled = False
      Max = 20
      TabOrder = 3
      OnChange = sTrackBar12Change
      ShowProgress = True
    end
  end
  object sSpinEdit1: TsSpinEdit
    Left = 96
    Top = 363
    Width = 57
    Height = 21
    TabOrder = 1
    OnChange = sSpinEdit1Change
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Horz offset:'
    MaxValue = 31
    MinValue = -32
  end
  object sSpinEdit2: TsSpinEdit
    Left = 232
    Top = 363
    Width = 57
    Height = 21
    TabOrder = 2
    OnChange = sSpinEdit2Change
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Vert offset:'
    MaxValue = 31
    MinValue = -32
  end
  object sGroupBox2: TsGroupBox
    Tag = 64
    Left = 327
    Top = 4
    Width = 175
    Height = 123
    Caption = 'Borders widths'
    Enabled = False
    TabOrder = 3
    CaptionLayout = clTopCenter
    object sLabel14: TsLabel
      Tag = 64
      Left = 131
      Top = 27
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel19: TsLabel
      Tag = 64
      Left = 131
      Top = 68
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel2: TsLabel
      Tag = 64
      Left = 53
      Top = 27
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel9: TsLabel
      Tag = 64
      Left = 52
      Top = 68
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel26: TsLabel
      Tag = 64
      Left = 24
      Top = 27
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = 'Left:'
      Enabled = False
    end
    object sLabel27: TsLabel
      Tag = 64
      Left = 24
      Top = 68
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = 'Top:'
      Enabled = False
    end
    object sLabel28: TsLabel
      Tag = 64
      Left = 96
      Top = 27
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Right:'
      Enabled = False
    end
    object sLabel29: TsLabel
      Tag = 64
      Left = 87
      Top = 68
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Bottom:'
      Enabled = False
    end
    object sRangeSelector1: TsRangeSelector
      Left = 3
      Top = 42
      Width = 169
      Height = 29
      TabOrder = 0
      OnChange = sRangeSelector1Change
      ChangingMode = cmUndepended
      TickStyle = tsNone
    end
    object sRangeSelector2: TsRangeSelector
      Left = 3
      Top = 83
      Width = 169
      Height = 29
      TabOrder = 1
      OnChange = sRangeSelector2Change
      ChangingMode = cmUndepended
      TickStyle = tsNone
    end
  end
  object sFrameAdapter1: TsFrameAdapter
    SkinData.SkinSection = 'TRANSPARENT'
    Left = 12
    Top = 152
  end
  object OpenPictureDialog1: TOpenPictureDialog
    DefaultExt = '*.png'
    Filter = 'Portable network graphic (AlphaControls) (*.png)|*.png'
    Left = 12
    Top = 180
  end
end
