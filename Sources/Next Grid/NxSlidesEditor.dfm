object SlidesForm: TSlidesForm
  Left = 508
  Top = 387
  Caption = 'SlidesForm'
  ClientHeight = 269
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 76
    Top = 100
    object AlignToGri1: TMenuItem
      Caption = 'Align to &Grid'
      OnClick = AlignToGri1Click
    end
  end
end
