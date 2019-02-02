object frmMain: TfrmMain
  Left = 457
  Top = 410
  BorderStyle = bsDialog
  Caption = 'Thread Management'
  ClientHeight = 110
  ClientWidth = 358
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
    Left = 192
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = btnRunClick
  end
  object btnClose: TButton
    Left = 272
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 177
    Height = 89
    TabOrder = 2
  end
  object Pool: TIdThreadMgrPool
    PoolSize = 200
    Left = 16
    Top = 8
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 16
    Top = 64
  end
end
