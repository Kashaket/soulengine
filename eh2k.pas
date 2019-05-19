unit eh2k;

interface

uses
  Generics.Collections,
  Rtti,
  TypInfo,
  System.SysUtils{$IFNDEF ADD_VEVENT}
  , dwsHashtables, System.Classes, zendAPI, phpApi, ZENDTypes, php4delphi
  , uPhpEvents
  {$ENDIF};

type
  TBaseEvent = class;           //класс псевдо-события(ИЙЫЫ)
  PPVarRec = ^PVarRec;          //указатель на указатель на  TVarRec
                              //TVarRec - запись переменной, используется Delphi в событиях
                              //Фролов видимо про неё не подумал...
  TEventBeforeNotify = reference to procedure(Base: TBaseEvent;
    var Params: TArray<PVarRec>); //Наше псевдо-событие(заданное пользователем)

  TBaseEvent = class
  private
   {$IFDEF ADD_VEVENT}
    {Количество}
    ListEventsCallCount: Cardinal;   //Список обработчиков, я вырезал для дс
                                    //т.к всё равно он ни к чему
    ListEventsCall: array [0 .. 255] of TEventBeforeNotify;
    {Сам список}
   {$ELSE}
//    procedure PreparePHPArgs(RArgs: array of PVarRec);
//    procedure CallPHP(PHPFuncPointer: pointer);
   {$ENDIF}
   {Настоящие обработчики событий, вызывающий псевдо-обработчик(и)}
    Procedure EventCall();
    Procedure EventCall1(A1: PVarRec);
    Procedure EventCall2(A1, A2: PVarRec);
    Procedure EventCall3(A1, A2, A3: PVarRec);
    Procedure EventCall4(A1, A2, A3, A4: PVarRec);
    Procedure EventCall5(A1, A2, A3, A4, A5: PVarRec);
    Procedure EventCall6(A1, A2, A3, A4, A5, A6: PVarRec);
    Procedure EventCall7(A1, A2, A3, A4, A5, A6, A7: PVarRec);
    Procedure EventCall8(A1, A2, A3, A4, A5, A6, A7, A8: PVarRec);
    Procedure EventCall9(A1, A2, A3, A4, A5, A6, A7, A8, A9: PVarRec);
    Procedure EventCall10(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10: PVarRec);
    Procedure EventCall11(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10,
      A11: PVarRec);
    Procedure EventCall12(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12: PVarRec);
    Procedure EventCall13(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13: PVarRec);
    Procedure EventCall14(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14: PVarRec);
    Procedure EventCall15(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15: PVarRec);
    Procedure EventCall16(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16: PVarRec);
    Procedure EventCall17(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17: PVarRec);
    Procedure EventCall18(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18: PVarRec);
    Procedure EventCall19(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19: PVarRec);
    Procedure EventCall20(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20: PVarRec);
    Procedure EventCall21(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21: PVarRec);
    Procedure EventCall22(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22: PVarRec);
    Procedure EventCall23(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23: PVarRec);
    Procedure EventCall24(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24: PVarRec);
    Procedure EventCall25(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24,
      A25: PVarRec);
    Procedure EventCall26(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25,
      A26: PVarRec);
    Procedure EventCall27(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27: PVarRec);
    Procedure EventCall28(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28: PVarRec);
    Procedure EventCall29(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29: PVarRec);
    Procedure EventCall30(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29, A30: PVarRec);
    Procedure EventCall31(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29, A30, A31: PVarRec);
    Procedure EventCall32(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29, A30, A31, A32: PVarRec);
    Procedure EventCall33(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29, A30, A31, A32, A33: PVarRec);
    Procedure EventCall34(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29, A30, A31, A32, A33, A34: PVarRec);
    Procedure EventCall35(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29, A30, A31, A32, A33, A34, A35: PVarRec);
    Procedure EventCall36(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28, A29, A30, A31, A32, A33, A34, A35, A36: PVarRec);
    Procedure EventCall37(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37: PVarRec);
    Procedure EventCall38(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38: PVarRec);
    Procedure EventCall39(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39: PVarRec);
    Procedure EventCall40(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39, A40: PVarRec);
    Procedure EventCall41(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41: PVarRec);
   Procedure EventCall42(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42: PVarRec);
   Procedure EventCall43(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43: PVarRec);
   Procedure EventCall44(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44: PVarRec);
   Procedure EventCall45(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45: PVarRec);
   Procedure EventCall46(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46: PVarRec);
   Procedure EventCall47(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46, A47: PVarRec);
   Procedure EventCall48(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46, A47, A48: PVarRec);
   Procedure EventCall49(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46, A47, A48, A49: PVarRec);
   Procedure EventCall50(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46, A47, A48, A49, A50: PVarRec);
   Procedure EventCall51(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46, A47, A48, A49,
A50, A51: PVarRec);
  Procedure EventCall52(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46, A47, A48, A49,
A50, A51, A52: PVarRec);
  Procedure EventCall53(A1, A2, A3, A4, A5, A6, A7, A8, A9,
A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
A30, A31, A32, A33, A34, A35, A36, A37, A38, A39,
A40, A41, A42, A43, A44, A45, A46, A47, A48, A49,
A50, A51, A52, A53: PVarRec);
    {обработчик вызова события}
    procedure Handler(PointArgs: Array of PPVarRec);
  public
    {Оригинальный объект вызова события}
    Sender: TObject;
    {Информация об параметрах события}
    InfoArgs: TArray<TRttiParameter>;
    {Длина (количество) параметров события}
    LengthArgs: Byte;
    {RTTI-события(одного,да)}
    PropType: TRttiProperty;
    {Имя события}
    EventName: string;
    {$IFNDEF ADD_VEVENT}
    FImportClasses: boolean;
    FImportConstants: boolean;
    TSRMLS_DC: Pointer;
    PHPReturn: Pointer;
    CallBack: TList;

    procedure addPHP(Data: pointer);
    function GetCallback(Data: pointer): pointer;
    {$ENDIF}
    {Конструктор класса обработчика}
    constructor Create(aSender: TObject; _PropType: TRttiProperty);
    {Деструктор класса}
    destructor Destroy;
  end;

  TEventHook = class
  private
    RttiContext: TRttiContext;
    FlList: TDictionary<String, TBaseEvent>;
    FOnBefore: TEventBeforeNotify;
  public
  //  procedure fphpEvent(Base: TBaseEvent;var Params: TArray<PVarRec>);
    property OnBefore: TEventBeforeNotify read FOnBefore write FOnBefore;// Default fPhpEvent;

    function IsSet(aSender: TObject; PropName: string; var Base: TBaseEvent)
      : Boolean; overload;
    function IsSet(aSender: TObject; Prop: TRttiProperty; var Base: TBaseEvent)
      : Boolean; overload;

    function IsSet(aSender: TObject; PropName: string): Boolean; overload;
    function IsSet(aSender: TObject; Prop: TRttiProperty): Boolean; overload;

    function ESet(aSender: TObject; PropName: string{$IFDEF ADD_VEVENT};p: pzval{$ENDIF})
      : Boolean; overload;
    function ESet(aSender: TObject; Prop: TRttiProperty{$IFDEF ADD_VEVENT};p: pzval{$ENDIF}): Boolean; overload;
    {$IFDEF ADD_VEVENT}
    function EAdd(aSender: TObject; PropName: string; Event: TEventBeforeNotify): Boolean; overload;
    function EAdd(aSender: TObject; Prop: TRttiProperty;
      Event: TEventBeforeNotify): Boolean; overload;
    {$ENDIF}
    function ERem(aSender: TObject; PropName: string): Boolean;
    constructor Create();
    destructor Destroy;
  end;

var
  EventHookObject: TEventHook;

implementation

constructor TEventHook.Create();
begin
  FlList := TDictionary<String, TBaseEvent>.Create();
end;

procedure TBaseEvent.Handler(PointArgs: Array of PPVarRec);
var
  I: Byte;
  Args: TArray<PVarRec>;
begin
  SetLength(Args, 0);
  if LengthArgs > 0 then    //если параметров у события больше нуля
  for I := 0 to LengthArgs-1 do
  begin
    SetLength(Args, I+1);
    Args[I] := PointArgs[I]^;
  end;
  //вызываем процедуру обработки события от TEventHook
  //(если таковая имеется)
  if Assigned(EventHookObject.OnBefore) then begin
    EventHookObject.OnBefore(self, Args);
  end;
  {$IFDEF ADD_VEVENT}
  if ListEventsCallCount > 0 then
  for I := Low(ListEventsCall) to ListEventsCallCount - 1 do
    ListEventsCall[I](self, Args);
  {$ELSE}
   // CallPHP(Args);
  {$ENDIF}
  //Тут происходит самое интересное - магия указателей
  //Задаём значение параметру события так, как будто оно было задано
  //Прямо из него
  if LengthArgs > 0 then   //если параметров у события больше нуля
  for I := Low(InfoArgs) to High(InfoArgs) do //пробегаемся по массиву переменных
  //в данном случае это - указатели на параметры
  begin
  if InfoArgs[I].Flags * [pfVar, pfOut] <> [] then //тут нам и нужно инфо события
  //и его параметров - для проверки того, не является ли параметр переменной или
  //<<выходными данными>> - outer data
    PointArgs[I]^ := @Args[I]; //модифицируем параметр по указателю, сменив его
    //Предыдущий указатель автоматически уничтожается, высвобождать его не требуется
  end;
  Args := nil;
end;

constructor TBaseEvent.Create(aSender: TObject; _PropType: TRttiProperty);
begin
  Sender := aSender;
  PropType := _PropType;
  EventName := PropType.Name;
  InfoArgs := TRttiInvokableType(PropType.PropertyType).GetParameters;
  LengthArgs := _PropType.PropertyType.Handle.TypeData.ParamCount;
  {$IFDEF ADD_VEVENT}ListEventsCallCount := 0;{$ENDIF}
end;

destructor TBaseEvent.Destroy;
begin
  SetLength(InfoArgs, 0);
  {$IFDEF ADD_VEVENT}ListEventsCallCount := 0;{$ENDIF}
end;
{$IFNDEF ADD_VEVENT}
function TBaseEvent.GetCallback(Data: Pointer): Pointer;
begin
  Result := Data;
end;
procedure TBaseEvent.addPHP(Data: pointer);
begin
  Data := GetCallback(Data);
  CallBack.Add(Data);
end;
{$ENDIF}
function TEventHook.IsSet(aSender: TObject; Prop: TRttiProperty;
  var Base: TBaseEvent): Boolean;
begin
  Result := Prop <> nil;
  if Result then
    Result := FlList.TryGetValue(IntToStr(NativeUInt(aSender)) + '_' +
      Prop.Name, Base);
end;

function TEventHook.IsSet(aSender: TObject; PropName: string;
  var Base: TBaseEvent): Boolean;
begin
  Result := FlList.TryGetValue(IntToStr(NativeUInt(aSender)) + '_' +
    PropName, Base);
end;

function TEventHook.IsSet(aSender: TObject; Prop: TRttiProperty): Boolean;
var
  Base: TBaseEvent;
begin
  Result := IsSet(aSender, string(Prop), TBaseEvent(Base));
end;

function TEventHook.IsSet(aSender: TObject; PropName: string): Boolean;
var
  Base: TBaseEvent;
begin
  Result := IsSet(aSender, PropName, Base);
end;

function TEventHook.ESet(aSender: TObject; Prop: TRttiProperty{$IFDEF ADD_VEVENT};p: pzval{$ENDIF}): Boolean;
var
  m: TMethod;
  Base: TBaseEvent;
  NameCase, PropName: string;
begin
 Result := false;
  if (@aSender <> nil) and (Prop <> nil) then
  begin
    PropName := Prop.Name;
    NameCase := IntToStr(NativeUInt(aSender)) + '_' + PropName;
    if not FlList.TryGetValue(NameCase, Base) then
    begin
      Result := true;

      case Prop.PropertyType.Handle.TypeData.ParamCount of
        0:
          m.Code := @TBaseEvent.EventCall;
        1:
          m.Code := @TBaseEvent.EventCall1;
        2:
          m.Code := @TBaseEvent.EventCall2;
        3:
          m.Code := @TBaseEvent.EventCall3;
        4:
          m.Code := @TBaseEvent.EventCall4;
        5:
          m.Code := @TBaseEvent.EventCall5;
        6:
          m.Code := @TBaseEvent.EventCall6;
        7:
          m.Code := @TBaseEvent.EventCall7;
        8:
          m.Code := @TBaseEvent.EventCall8;
        9:
          m.Code := @TBaseEvent.EventCall9;
        10:
          m.Code := @TBaseEvent.EventCall10;
        11:
          m.Code := @TBaseEvent.EventCall11;
        12:
          m.Code := @TBaseEvent.EventCall12;
        13:
          m.Code := @TBaseEvent.EventCall13;
        14:
          m.Code := @TBaseEvent.EventCall14;
        15:
          m.Code := @TBaseEvent.EventCall15;
        16:
          m.Code := @TBaseEvent.EventCall16;
        17:
          m.Code := @TBaseEvent.EventCall17;
        18:
          m.Code := @TBaseEvent.EventCall18;
        19:
          m.Code := @TBaseEvent.EventCall19;
        20:
          m.Code := @TBaseEvent.EventCall20;
        21:
          m.Code := @TBaseEvent.EventCall21;
        22:
          m.Code := @TBaseEvent.EventCall22;
        23:
          m.Code := @TBaseEvent.EventCall23;
        24:
          m.Code := @TBaseEvent.EventCall24;
        25:
          m.Code := @TBaseEvent.EventCall25;
        26:
          m.Code := @TBaseEvent.EventCall26;
        27:
          m.Code := @TBaseEvent.EventCall27;
        28:
          m.Code := @TBaseEvent.EventCall28;
        29:
          m.Code := @TBaseEvent.EventCall29;
        30:
          m.Code := @TBaseEvent.EventCall30;
        31:
          m.Code := @TBaseEvent.EventCall31;
        32:
          m.Code := @TBaseEvent.EventCall32;
        33:
          m.Code := @TBaseEvent.EventCall33;
        34:
          m.Code := @TBaseEvent.EventCall34;
        35:
          m.Code := @TBaseEvent.EventCall35;
        36:
          m.Code := @TBaseEvent.EventCall36;
        37:
          m.Code := @TBaseEvent.EventCall37;
        38:
          m.Code := @TBaseEvent.EventCall38;
        39:
          m.Code := @TBaseEvent.EventCall39;
        40:
          m.Code := @TBaseEvent.EventCall40;
        41:
          m.Code := @TBaseEvent.EventCall41;
        42:
          m.Code := @TBaseEvent.EventCall42;
        43:
          m.Code := @TBaseEvent.EventCall43;
        44:
          m.Code := @TBaseEvent.EventCall44;
        45:
          m.Code := @TBaseEvent.EventCall45;
        46:
          m.Code := @TBaseEvent.EventCall46;
        47:
          m.Code := @TBaseEvent.EventCall47;
        48:
          m.Code := @TBaseEvent.EventCall48;
        49:
          m.Code := @TBaseEvent.EventCall49;
        50:
          m.Code := @TBaseEvent.EventCall50;
        51:
          m.Code := @TBaseEvent.EventCall51;
        52:
          m.Code := @TBaseEvent.EventCall52;
        53:
          m.Code := @TBaseEvent.EventCall53;
      else
        Exit;
      end;

        Base := TBaseEvent.Create(aSender, Prop);

        TObject(m.Data) := Base;
        setMethodProp(aSender, PropName, m);
        {$IFDEF ADD_VEVENT}
        Base.addPHP(c);
        {$ENDIF}
        FlList.Add(NameCase, Base);
    end;
  end;
end;

function TEventHook.ESet(aSender: TObject; PropName: string{$IFDEF ADD_VEVENT}
;p: pzval{$ENDIF}): Boolean;
begin
  if @aSender <> nil then
    Result := ESet(aSender, RttiContext.GetType(aSender.ClassInfo)
      .GetProperty(PropName){$IFDEF ADD_VEVENT}, p{$ENDIF})
  else
    Result := false;
end;
{$IFDEF ADD_VEVENT}
function TEventHook.EAdd(aSender: TObject; Prop: TRttiProperty;
  Event: TEventBeforeNotify): Boolean;
var
  Base: TBaseEvent;
begin
  Result := IsSet(aSender, Prop, Base);
  if not Result then
  begin
    ESet(aSender, Prop);
    Result := IsSet(aSender, Prop, Base);
  end;
  if Result then
  begin
    Base.ListEventsCall[Base.ListEventsCallCount] := Event;
    inc(Base.ListEventsCallCount);
  end;
end;

function TEventHook.EAdd(aSender: TObject; PropName: string;
  Event: TEventBeforeNotify): Boolean;
var
  Base: TBaseEvent;
begin
  Result := IsSet(aSender, PropName, Base);
  if not Result then
  begin
    ESet(aSender, PropName);
    Result := IsSet(aSender, PropName, Base);
  end;
  if Result then
  begin
    Base.ListEventsCall[Base.ListEventsCallCount] := Event;
    inc(Base.ListEventsCallCount);
  end;
end;
{$ENDIF}
function TEventHook.ERem(aSender: TObject; PropName: string): Boolean;
var
  Base: TBaseEvent;
begin
  Result := IsSet(aSender, PropName, Base);

  if Result then
  begin
    Base.Destroy;
    FlList.Remove(IntToStr(NativeUInt(aSender)) + '_' + PropName);
  end;
end;

destructor TEventHook.Destroy;
var
  Item: TPair<String, TBaseEvent>;
begin
  for Item in FlList do
    Item.Value.Destroy;

  FlList.Free;
end;{
procedure TBaseEvent.CallPHP(PHPFuncPointer: pointer);
  var
  eg: pzend_executor_globals;
  cg: Pzend_compiler_globals;

  lastConstants, lastFunctions, lastClasses: PHashTable;
begin
  if self.Sender is TScriptThread then
  begin
    with TScriptThread(self.Sender) do
    begin
      try
        psv := TpsvPHP.Create(nil);
        //НИ В КОЕМ СЛУЧАЕ НЕ УБИРАТЬ ECHO 1, ДА ГОВНОКОД, НО ЭТО КАКОЙ-ТО ХИТРЫЙ КОСТЫЛЬ!
        psv.RunCode('echo 1; ' + '$GLOBALS["THREAD_SELF"] = ' +
          IntToStr(integer(self.Sender)) + ';');

        eg := GetExecutorGlobals;
        cg := GetCompilerGlobals;

        eg.current_module := executor_globals.current_module;
        //Imports all functions from main ST-TS - php secured thread
          lastFunctions := eg.function_table;
          eg.function_table := executor_globals.function_table;
        if FThread.Main.FImportClasses then
        begin
          lastClasses := eg.class_table;
          eg.class_table := executor_globals.class_table;
        end;
        if FThread.Main.FImportConstants then
        begin
          lastConstants := eg.zend_constants;
          eg.zend_constants := executor_globals.zend_constants;
        end;
        psv.thread := self.Sender;
        psv.RunCode('if (class_exists("TThread")) TThread::__init();');
        try
          call_user_function(cg.function_table, nil, PHPFuncPointer, pzval(PHPReturn),
            self.LengthArgs, self.phpArgs, psv.TSRMLS_D);
        except

        end;

        if self.FImportClasses then
          eg.class_table := lastClasses;

        if self.FImportConstants then
          eg.zend_constants := lastConstants;

        eg.function_table := lastFunctions;
        try
          psv.ShutdownRequest;
          psv.Free;
        except

        end;

      finally
        try
          ts_free_thread(); // for zend_timeout to kill timer
        except

        end;
      end;

    end;

  end
  else
  begin
    try
      call_user_function(GetExecutorGlobals.function_table, nil, PHPFuncPointer,
        pzval(PHPReturn), self.LengthArgs, self.phpArgs, self.TSRMLS_DC);
    except
      // ShowMessage(Z_STRVAL(Data));
    end;
  end;
end;
}
Procedure TBaseEvent.EventCall;
begin
  Handler([]);
end;
Procedure TBaseEvent.EventCall1;
begin
  Handler([@A1]);
end;
Procedure TBaseEvent.EventCall2;
begin
  Handler([@A1, @A2]);
end;
Procedure TBaseEvent.EventCall3;
begin
  Handler([@A1, @A2, @A3]);
end;
Procedure TBaseEvent.EventCall4;
begin
  Handler([@A1, @A2, @A3, @A4]);
end;
Procedure TBaseEvent.EventCall5;
begin
  Handler([@A1, @A2, @A3, @A4, @A5]);
end;
Procedure TBaseEvent.EventCall6;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6]);
end;
Procedure TBaseEvent.EventCall7;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7]);
end;
Procedure TBaseEvent.EventCall8;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8]);
end;
Procedure TBaseEvent.EventCall9;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9]);
end;
Procedure TBaseEvent.EventCall10;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10]);
end;
Procedure TBaseEvent.EventCall11;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11]);
end;
Procedure TBaseEvent.EventCall12;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12]);
end;
Procedure TBaseEvent.EventCall13;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13]);
end;
Procedure TBaseEvent.EventCall14;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13, @A14]);
end;
Procedure TBaseEvent.EventCall15;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15]);
end;
Procedure TBaseEvent.EventCall16;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16]);
end;
Procedure TBaseEvent.EventCall17;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17]);
end;
Procedure TBaseEvent.EventCall18;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18]);
end;
Procedure TBaseEvent.EventCall19;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19]);
end;
Procedure TBaseEvent.EventCall20;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20]);
end;
Procedure TBaseEvent.EventCall21;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21]);
end;
Procedure TBaseEvent.EventCall22;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22]);
end;
Procedure TBaseEvent.EventCall23;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23]);
end;
Procedure TBaseEvent.EventCall24;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24]);
end;
Procedure TBaseEvent.EventCall25;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25]);
end;
Procedure TBaseEvent.EventCall26;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26]);
end;
Procedure TBaseEvent.EventCall27;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27]);
end;
Procedure TBaseEvent.EventCall28;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27, @A28]);
end;
Procedure TBaseEvent.EventCall29;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29]);
end;
Procedure TBaseEvent.EventCall30;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30]);
end;
Procedure TBaseEvent.EventCall31;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31]);
end;
Procedure TBaseEvent.EventCall32;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32]);
end;
Procedure TBaseEvent.EventCall33;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33]);
end;
Procedure TBaseEvent.EventCall34;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34]);
end;
Procedure TBaseEvent.EventCall35;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35]);
end;
Procedure TBaseEvent.EventCall36;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36]);
end;
Procedure TBaseEvent.EventCall37;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37]);
end;
Procedure TBaseEvent.EventCall38;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38]);
end;
Procedure TBaseEvent.EventCall39;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39]);
end;
Procedure TBaseEvent.EventCall40;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40]);
end;
Procedure TBaseEvent.EventCall41;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41]);
end;
Procedure TBaseEvent.EventCall42;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41, @A42]);
end;
Procedure TBaseEvent.EventCall43;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43]);
end;
Procedure TBaseEvent.EventCall44;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44]);
end;
Procedure TBaseEvent.EventCall45;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45]);
end;
Procedure TBaseEvent.EventCall46;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46]);
end;
Procedure TBaseEvent.EventCall47;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46, @A47]);
end;
Procedure TBaseEvent.EventCall48;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46, @A47, @A48]);
end;
Procedure TBaseEvent.EventCall49;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46, @A47, @A48, @A49]);
end;
Procedure TBaseEvent.EventCall50;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46, @A47, @A48, @A49, @A50]);
end;
Procedure TBaseEvent.EventCall51;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46, @A47, @A48, @A49, @A50, @A51]);
end;
Procedure TBaseEvent.EventCall52;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46, @A47, @A48, @A49, @A50, @A51, @A52]);
end;
Procedure TBaseEvent.EventCall53;
begin
  Handler([@A1, @A2, @A3, @A4, @A5, @A6, @A7, @A8, @A9, @A10, @A11, @A12, @A13,
@A14, @A15, @A16, @A17, @A18, @A19, @A20, @A21, @A22, @A23, @A24, @A25, @A26, @A27,
@A28, @A29, @A30, @A31, @A32, @A33, @A34, @A35, @A36, @A37, @A38, @A39, @A40, @A41,
@A42, @A43, @A44, @A45, @A46, @A47, @A48, @A49, @A50, @A51, @A52, @A53]);
end;


initialization

EventHookObject := TEventHook.Create;

finalization

EventHookObject.Destroy;

end.