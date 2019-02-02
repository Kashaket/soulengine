object Form1: TForm1
  Left = 490
  Top = 294
  BorderStyle = bsDialog
  Caption = 'Array demo'
  ClientHeight = 160
  ClientWidth = 256
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
    Left = 16
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 108
    Top = 4
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 1
  end
  object psvPHP1: TpsvPHP
    Variables = <>
    Left = 20
    Top = 16
  end
  object PHPLibrary1: TPHPLibrary
    LibraryName = 'ArrayLib'
    Functions = <
      item
        FunctionName = 'get_php_array'
        Tag = 0
        Parameters = <>
        OnExecute = ExecuteGetArray
      end>
    Left = 52
    Top = 16
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 44
    Top = 112
  end
end
