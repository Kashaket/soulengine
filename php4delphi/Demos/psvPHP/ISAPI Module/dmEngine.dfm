object EngineModule: TEngineModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 562
  Top = 381
  Height = 150
  Width = 215
  object PHPEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 72
    Top = 24
  end
  object PHPLibrary: TPHPLibrary
    Functions = <
      item
        FunctionName = 'nb_test'
        Tag = 0
        Parameters = <
          item
            Name = 'nb_pointer'
            ParamType = tpString
          end>
        OnExecute = PHPLibraryFunctions0Execute
      end>
    Left = 120
    Top = 32
  end
end
