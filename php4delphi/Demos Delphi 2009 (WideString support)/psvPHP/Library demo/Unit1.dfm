object frmLibDemo: TfrmLibDemo
  Left = 395
  Top = 303
  BorderStyle = bsDialog
  Caption = 'PHP Demo'
  ClientHeight = 209
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 185
    Height = 189
    Lines.Strings = (
      'formcaption("Hello from PHP");'
      'buttonclick();'
      'my_createcontrol();')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 292
    Top = 172
    Width = 75
    Height = 25
    Caption = 'Click'
    TabOrder = 1
    OnClick = Button1Click
  end
  object btnExecute: TButton
    Left = 292
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 2
    OnClick = btnExecuteClick
  end
  object psvPHP1: TpsvPHP
    Variables = <>
    Left = 32
    Top = 28
  end
  object PHPLibrary1: TPHPLibrary
    LibraryName = 'SimpleLib'
    Functions = <
      item
        FunctionName = 'formcaption'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpString
          end>
        OnExecute = PHPLibrary1Functions0Execute
      end
      item
        FunctionName = 'buttonclick'
        Tag = 0
        Parameters = <>
        OnExecute = PHPLibrary1Functions1Execute
      end>
    Left = 88
    Top = 108
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 212
    Top = 64
  end
end
