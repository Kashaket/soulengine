object MainModule: TMainModule
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      Name = 'WebActionItem1'
      PathInfo = '/'
      OnAction = MainModuleWebActionItem1Action
    end>
  Left = 513
  Top = 319
  Height = 254
  Width = 333
  object psvPHP: TpsvPHP
    Variables = <
      item
        Name = 'nb'
      end>
    Left = 64
    Top = 56
  end
end
