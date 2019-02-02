object frmMain: TfrmMain
  Left = 457
  Top = 410
  BorderStyle = bsDialog
  Caption = 'Thread Management'
  ClientHeight = 225
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
    Width = 157
    Height = 25
    Caption = 'Run in threads'
    TabOrder = 0
    OnClick = btnRunClick
  end
  object btnClose: TButton
    Left = 280
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object MemoCode: TMemo
    Left = 8
    Top = 8
    Width = 177
    Height = 89
    Lines.Strings = (
      '<?php'
      '   print nb_test("Nils War Hier");'
      '?>')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object MemoOut: TMemo
    Left = 8
    Top = 108
    Width = 177
    Height = 89
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object btnNoThreads: TButton
    Left = 192
    Top = 108
    Width = 157
    Height = 25
    Caption = 'Run no threads'
    TabOrder = 4
    OnClick = btnNoThreadsClick
  end
  object Pool: TIdThreadMgrPool
    PoolSize = 200
    Left = 272
    Top = 12
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 232
    Top = 12
  end
  object PHPLibrary1: TPHPLibrary
    Functions = <
      item
        FunctionName = 'nb_test'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpString
          end>
        OnExecute = PHPLibrary1Functions0Execute
      end>
    Left = 48
    Top = 140
  end
  object psvPHP: TpsvPHP
    Variables = <>
    Left = 288
    Top = 148
  end
end
