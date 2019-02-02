object frmMain: TfrmMain
  Left = 513
  Top = 399
  BorderStyle = bsDialog
  Caption = 'PHP Multithread sample'
  ClientHeight = 81
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnRun: TButton
    Left = 136
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = btnRunClick
  end
  object btnClose: TButton
    Left = 220
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 12
    Top = 12
  end
end
