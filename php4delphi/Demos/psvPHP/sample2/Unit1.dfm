object Form1: TForm1
  Left = 414
  Top = 391
  BorderStyle = bsDialog
  Caption = 'Calculator'
  ClientHeight = 120
  ClientWidth = 336
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
  object Label1: TLabel
    Left = 40
    Top = 36
    Width = 6
    Height = 13
    Margins.Bottom = 0
    Caption = '+'
  end
  object Label2: TLabel
    Left = 140
    Top = 36
    Width = 6
    Height = 13
    Margins.Bottom = 0
    Caption = '='
  end
  object Label3: TLabel
    Left = 156
    Top = 36
    Width = 3
    Height = 13
    Margins.Bottom = 0
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '2'
  end
  object Edit2: TEdit
    Left = 8
    Top = 52
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '2'
  end
  object Button1: TButton
    Left = 244
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Calculate'
    TabOrder = 2
    OnClick = Button1Click
  end
  object psvPHP1: TpsvPHP
    Variables = <
      item
        Name = 'x'
      end
      item
        Name = 'y'
      end
      item
        Name = 'z'
        Value = '0'
      end>
    Left = 20
    Top = 80
  end
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 76
    Top = 84
  end
end
