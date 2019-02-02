object sPopupCalendar: TsPopupCalendar
  Tag = 256
  Left = 512
  Top = 268
  BorderStyle = bsNone
  Caption = 'Mgn'
  ClientHeight = 170
  ClientWidth = 230
  Color = clBtnFace
  KeyPreview = True
  OldCreateOrder = True
  Scaled = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sMonthCalendar1: TsMonthCalendar
    Left = 0
    Top = 0
    Width = 230
    Height = 170
    SkinData.SkinSection = 'PANEL'
    Align = alClient
    BevelOuter = bvNone
    BevelWidth = 1
    BorderWidth = 3
    Caption = ' '
    TabOrder = 0
  end
end
