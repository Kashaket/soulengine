object StrEditDlg: TStrEditDlg
  Left = 403
  Top = 399
  BorderStyle = bsSizeToolWin
  Caption = 'String list editor'
  ClientHeight = 278
  ClientWidth = 434
  Color = clBtnFace
  Constraints.MinHeight = 305
  Constraints.MinWidth = 450
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = True
  OnCreate = FormCreate
  object Bevel1: TsPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 237
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'TRANSPARENT'
    object LineCount: TsLabel
      Left = 12
      Top = 5
      Width = 169
      Height = 17
      AutoSize = False
      Caption = '0 lines'
    end
    object Memo: TsMemo
      Left = 8
      Top = 21
      Width = 418
      Height = 209
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = UpdateStatus
      OnKeyDown = MemoKeyDown
    end
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 237
    Width = 434
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object OKBtn: TsBitBtn
      Left = 187
      Top = 9
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ImageIndex = 0
      Images = acDM.sCharImageList1
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TsBitBtn
      Left = 267
      Top = 9
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ImageIndex = 12
      Images = acDM.sCharImageList1
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBtn: TsBitBtn
      Left = 347
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 2
      OnClick = HelpBtnClick
    end
    object LoadBtn: TsBitBtn
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Load...'
      ImageIndex = 16
      Images = acDM.sCharImageList1
      TabOrder = 3
      OnClick = FileOpen
    end
    object SaveBtn: TsBitBtn
      Left = 92
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Save...'
      ImageIndex = 15
      Images = acDM.sCharImageList1
      TabOrder = 4
      OnClick = FileSave
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'TXT'
    Filter = 
      'Text files (*.TXT)|*.TXT|Config files (*.SYS;*.INI)|*.SYS;*.INI|' +
      'Batch files (*.BAT)|*.BAT|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofFileMustExist]
    Title = 'Load string list'
    Left = 364
  end
  object SaveDialog: TSaveDialog
    Filter = 
      'Text files (*.TXT)|*.TXT|Config files (*.SYS;*.INI)|*.SYS;*.INI|' +
      'Batch files (*.BAT)|*.BAT|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofShowHelp, ofPathMustExist]
    Title = 'Save string list'
    Left = 392
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    GripMode = gmRightBottom
    TitleButtons = <>
    Left = 236
  end
end
