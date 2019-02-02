object OneWireWrapper: TOneWireWrapper
  OldCreateOrder = False
  Version = '0.0'
  Functions = <
    item
      FunctionName = 'blah'
      Tag = 0
      Parameters = <
        item
          Name = 'i'
          ParamType = tpInteger
        end
        item
          Name = 'a'
          ParamType = tpArray
        end>
      OnExecute = OneWireWrapperFunctions0Execute
      Description = 'Test function for passing arrays'
    end>
  ModuleName = 'rarp'
  Left = 192
  Top = 114
  Height = 150
  Width = 215
end
