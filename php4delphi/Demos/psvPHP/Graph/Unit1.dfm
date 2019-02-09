object Form1: TForm1
  Left = 404
  Top = 217
  BorderStyle = bsDialog
  Caption = 'PHP Graph demo'
  ClientHeight = 531
  ClientWidth = 630
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
  object PaintBox: TPaintBox
    Left = 4
    Top = 9
    Width = 512
    Height = 512
    OnPaint = PaintBoxPaint
  end
  object btnExecute: TButton
    Left = 524
    Top = 4
    Width = 97
    Height = 25
    Caption = '&Execute'
    TabOrder = 0
    OnClick = btnExecuteClick
  end
  object Button1: TButton
    Left = 524
    Top = 32
    Width = 97
    Height = 25
    Caption = 'Use Library'
    TabOrder = 1
    OnClick = Button1Click
  end
  object psvPHP: TpsvPHP
    Variables = <
      item
        Name = 'X'
        Value = '0'
      end
      item
        Name = 'Y'
        Value = '0'
      end
      item
        Name = 'T'
        Value = '0'
      end>
    Left = 236
    Top = 36
  end
  object PHPEngine: TPHPEngine
    HandleErrors = False
    Constants = <
      item
        Name = 'MinT'
        Value = '0'
      end
      item
        Name = 'MaxT'
        Value = '82'
      end
      item
        Name = 'Steps'
        Value = '2000'
      end>
    ReportDLLError = False
    Left = 172
    Top = 212
  end
  object PHPLibrary: TPHPLibrary
    Functions = <
      item
        FunctionName = 'gr_prepare'
        Tag = 0
        Parameters = <>
        OnExecute = PHPLibrary1Functions0Execute
      end
      item
        FunctionName = 'gr_paint'
        Tag = 0
        Parameters = <
          item
            Name = 'X'
            ParamType = tpFloat
          end
          item
            Name = 'Y'
            ParamType = tpFloat
          end>
        OnExecute = PHPLibraryFunctions1Execute
      end
      item
        FunctionName = 'gr_move'
        Tag = 0
        Parameters = <
          item
            Name = 'X'
            ParamType = tpFloat
          end
          item
            Name = 'Y'
            ParamType = tpFloat
          end>
        OnExecute = PHPLibraryFunctions2Execute
      end>
    Left = 288
    Top = 196
  end
end
