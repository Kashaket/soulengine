object frmTest: TfrmTest
  Left = 399
  Top = 356
  BorderStyle = bsDialog
  Caption = 'Components demo'
  ClientHeight = 252
  ClientWidth = 472
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
  object Label1: TLabel
    Left = 0
    Top = 226
    Width = 472
    Height = 26
    Align = alBottom
    Caption = 
      'This demo project shows how to access published property'#13#10'of Del' +
      'phi components from PHP script'
    Color = clInfoBk
    ParentColor = False
    WordWrap = True
  end
  object memScript: TMemo
    Left = 8
    Top = 8
    Width = 369
    Height = 213
    TabOrder = 0
  end
  object btnExecute: TButton
    Left = 384
    Top = 12
    Width = 75
    Height = 25
    Caption = '&Execute'
    TabOrder = 1
    OnClick = btnExecuteClick
  end
  object PHP: TpsvPHP
    Variables = <>
    Left = 400
    Top = 136
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 408
    Top = 88
  end
end
