object Form1: TForm1
  Left = 484
  Top = 330
  BorderStyle = bsDialog
  Caption = 'Shell Demo'
  ClientHeight = 160
  ClientWidth = 235
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
  object Button1: TButton
    Left = 12
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = Button1Click
  end
  object psvPHP: TpsvPHP
    Variables = <>
    Left = 24
    Top = 20
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 24
    Top = 72
  end
end
