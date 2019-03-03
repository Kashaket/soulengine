object fmMain: TfmMain
  Left = -8888
  Top = 0
  ClientHeight = 70
  ClientWidth = 122
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object psvPHP: TpsvPHP
    Variables = <>
    Left = 80
    Top = 8
  end
  object PHPEngine: TPHPEngine
    OnScriptError = PHPEngineScriptError
    Constants = <>
    ReportDLLError = False
    Left = 16
    Top = 8
  end
end
