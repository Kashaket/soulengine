unit EventHook;

interface

uses
  Generics.Collections,
  Rtti,
  TypInfo,
  System.SysUtils, vcl.dialogs;

type
  TEventObject = class;

  TEventObjectNotify = reference to procedure(Base: TEventObject;
    Params: TArray<TValue>);

  TOldCallEvent = procedure of object varargs;

  TEventObject = class
  private
    MethodDefault: TMethod;
    StackSize: Byte;
    ListEventsCallCount: Cardinal;
    ListEventsCall: array [0 .. 255] of TEventObjectNotify;

    Procedure Ec1(A1: NativeUInt);
    Procedure Ec2(A1, A2: NativeUInt);
    Procedure Ec3(A1, A2, A3: NativeUInt);
    Procedure Ec4(A1, A2, A3, A4: NativeUInt);
    Procedure Ec5(A1, A2, A3, A4, A5: NativeUInt);
    Procedure Ec6(A1, A2, A3, A4, A5, A6: NativeUInt);
    Procedure Ec7(A1, A2, A3, A4, A5, A6, A7: NativeUInt);
    Procedure Ec8(A1, A2, A3, A4, A5, A6, A7, A8: NativeUInt);
    Procedure Ec9(A1, A2, A3, A4, A5, A6, A7, A8, A9: NativeUInt);
    Procedure Ec10(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10: NativeUInt);
    Procedure Ec11(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11: NativeUInt);
    Procedure Ec12(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12: NativeUInt);
    Procedure Ec13(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12,
      A13: NativeUInt);
    Procedure Ec14(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13,
      A14: NativeUInt);
    Procedure Ec15(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15: NativeUInt);
    Procedure Ec16(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16: NativeUInt);
    Procedure Ec17(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17: NativeUInt);
    Procedure Ec18(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18: NativeUInt);
    Procedure Ec19(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19: NativeUInt);
    Procedure Ec20(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20: NativeUInt);
    Procedure Ec21(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21: NativeUInt);
    Procedure Ec22(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22: NativeUInt);
    Procedure Ec23(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23: NativeUInt);
    Procedure Ec24(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24: NativeUInt);
    Procedure Ec25(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25: NativeUInt);
    Procedure Ec26(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26: NativeUInt);
    Procedure Ec27(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27: NativeUInt);
    Procedure Ec28(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27,
      A28: NativeUInt);
    Procedure Ec29(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28,
      A29: NativeUInt);
    Procedure Ec30(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
      A30: NativeUInt);
    Procedure Ec31(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
      A30, A31: NativeUInt);
    Procedure Ec32(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
      A30, A31, A32: NativeUInt);
    Procedure Ec33(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
      A30, A31, A32, A33: NativeUInt);
    Procedure Ec34(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
      A30, A31, A32, A33, A34: NativeUInt);
    Procedure Ec35(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
      A30, A31, A32, A33, A34, A35: NativeUInt);
    Procedure Ec36(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14,
      A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
      A30, A31, A32, A33, A34, A35, A36: NativeUInt);

    procedure Handler;
  public
    PointArgs: array [0 .. 35] of Pointer;
    ListDopArgs: array [0 .. 15] of Pointer; // Дополнительные аргументы

    Sender: TObject;
    InfoArgs: TArray<TRttiParameter>;
    LengthArgs: Byte;
    PropType: TRttiProperty;
    EventName: string;
    OrigCall: Boolean;
    constructor Create(aSender: TObject; _PropType: TRttiProperty;
      _OrigCall: Boolean = false);
    destructor Destroy;
  end;

  TEventHook = class
  private
    RttiContext: TRttiContext;
    FlList: TDictionary<String, TEventObject>;
    FOnBefore: TEventObjectNotify;
    ListDopArgs: array [0 .. 15] of Pointer;
  public
    property OnBefore: TEventObjectNotify read FOnBefore write FOnBefore;

    procedure SetArgsAdd(Args: Array of Pointer);
    procedure FreeArgs();

    function IsSet(aSender: TObject; PropName: string; var Base: TEventObject)
      : Boolean; overload;
    function IsSet(aSender: TObject; Prop: TRttiProperty;
      var Base: TEventObject): Boolean; overload;

    function IsSet(aSender: TObject; PropName: string): Boolean; overload;
    function IsSet(aSender: TObject; Prop: TRttiProperty): Boolean; overload;

    function ESet(aSender: TObject; PropName: string; OrigCall: Boolean = false)
      : Boolean; overload;
    function ESet(aSender: TObject; Prop: TRttiProperty;
      OrigCall: Boolean = false): Boolean; overload;

    function EAdd(aSender: TObject; PropName: string; Event: TEventObjectNotify;
      OrigCall: Boolean = false): Boolean; overload;
    function EAdd(aSender: TObject; Prop: TRttiProperty;
      Event: TEventObjectNotify; OrigCall: Boolean = false): Boolean; overload;

    function ERem(aSender: TObject; PropName: string): Boolean;
    constructor Create();
    destructor Destroy;
  end;

var
  HEventObj: TEventHook;

implementation

procedure TEventHook.SetArgsAdd(Args: Array of Pointer);
var
  i: Integer;
begin
  for i := Low(Args) to High(Args) do
    ListDopArgs[i] := Args[i];
end;

procedure TEventHook.FreeArgs();
var
  i: Integer;
begin
  for i := Low(ListDopArgs) to High(ListDopArgs) do
    ListDopArgs[i] := nil;
end;

constructor TEventHook.Create();
begin
  FlList := TDictionary<String, TEventObject>.Create();
end;

procedure TEventObject.Handler;
var
  i: Integer;
  Params: TArray<TValue>;
  P: Pointer;
begin
  SetLength(Params, LengthArgs);
  for i := Low(InfoArgs) to High(InfoArgs) do
  begin
    P := self.PointArgs[i];
    if InfoArgs[i].Flags * [pfVar, pfOut] <> [] then
      P := PPointer(P)^;

    TValue.Make(P, InfoArgs[i].ParamType.Handle, Params[i]);
  end;

  if @HEventObj.OnBefore <> nil then
    HEventObj.OnBefore(self, Params);

  for i := Low(ListEventsCall) to ListEventsCallCount - 1 do
    ListEventsCall[i](self, Params);
end;

constructor TEventObject.Create(aSender: TObject; _PropType: TRttiProperty;
  _OrigCall: Boolean = false);
begin
  OrigCall := _OrigCall;
  Sender := aSender;
  PropType := _PropType;
  EventName := PropType.Name;
  InfoArgs := TRttiInvokableType(PropType.PropertyType).GetParameters;
  LengthArgs := _PropType.PropertyType.Handle.TypeData.ParamCount;
  ListEventsCallCount := 0;
  MethodDefault := GetMethodProp(aSender, EventName);
end;

destructor TEventObject.Destroy;
begin
  if @Sender <> nil then
    setMethodProp(Sender, EventName, MethodDefault);
  SetLength(InfoArgs, 0);
  ListEventsCallCount := 0;
end;

function TEventHook.IsSet(aSender: TObject; Prop: TRttiProperty;
  var Base: TEventObject): Boolean;
begin
  Result := Prop <> nil;
  if Result then
    Result := FlList.TryGetValue(IntToStr(NativeUInt(aSender)) + '_' +
      Prop.Name, Base);
end;

function TEventHook.IsSet(aSender: TObject; PropName: string;
  var Base: TEventObject): Boolean;
begin
  Result := FlList.TryGetValue(IntToStr(NativeUInt(aSender)) + '_' +
    PropName, Base);
end;

function TEventHook.IsSet(aSender: TObject; Prop: TRttiProperty): Boolean;
var
  Base: TEventObject;
begin
  Result := IsSet(aSender, string(Prop), TEventObject(Base));
end;

function TEventHook.IsSet(aSender: TObject; PropName: string): Boolean;
var
  Base: TEventObject;
begin
  Result := IsSet(aSender, PropName, Base);
end;

function TEventHook.ESet(aSender: TObject; Prop: TRttiProperty;
  OrigCall: Boolean = false): Boolean;
var
  m: TMethod;
  Base: TEventObject;
  NameCase, PropName: string;
  i: Integer;
begin
  if (@aSender <> nil) and (Prop <> nil) then
  begin
    PropName := Prop.Name;
    NameCase := IntToStr(NativeUInt(aSender)) + '_' + PropName;
    if not FlList.TryGetValue(NameCase, Base) then
    begin
      Result := true;

      case Prop.PropertyType.Handle.TypeData.ParamCount of
        0:
          m.Code := @TEventObject.Handler;
        1:
          m.Code := @TEventObject.Ec1;
        2:
          m.Code := @TEventObject.Ec2;
        3:
          m.Code := @TEventObject.Ec3;
        4:
          m.Code := @TEventObject.Ec4;
        5:
          m.Code := @TEventObject.Ec5;
        6:
          m.Code := @TEventObject.Ec6;
        7:
          m.Code := @TEventObject.Ec7;
        8:
          m.Code := @TEventObject.Ec8;
        9:
          m.Code := @TEventObject.Ec9;
        10:
          m.Code := @TEventObject.Ec10;
        11:
          m.Code := @TEventObject.Ec11;
        12:
          m.Code := @TEventObject.Ec12;
        13:
          m.Code := @TEventObject.Ec13;
        14:
          m.Code := @TEventObject.Ec14;
        15:
          m.Code := @TEventObject.Ec15;
        16:
          m.Code := @TEventObject.Ec16;
        17:
          m.Code := @TEventObject.Ec17;
        18:
          m.Code := @TEventObject.Ec18;
        19:
          m.Code := @TEventObject.Ec19;
        20:
          m.Code := @TEventObject.Ec20;
        21:
          m.Code := @TEventObject.Ec21;
        22:
          m.Code := @TEventObject.Ec22;
        23:
          m.Code := @TEventObject.Ec23;
        24:
          m.Code := @TEventObject.Ec24;
        25:
          m.Code := @TEventObject.Ec25;
        26:
          m.Code := @TEventObject.Ec26;
        27:
          m.Code := @TEventObject.Ec27;
        28:
          m.Code := @TEventObject.Ec28;
        29:
          m.Code := @TEventObject.Ec29;
        30:
          m.Code := @TEventObject.Ec30;
        31:
          m.Code := @TEventObject.Ec31;
        32:
          m.Code := @TEventObject.Ec32;
        33:
          m.Code := @TEventObject.Ec33;
        34:
          m.Code := @TEventObject.Ec34;
        35:
          m.Code := @TEventObject.Ec35;
        36:
          m.Code := @TEventObject.Ec36;
      else
        Result := false;
      end;
      if Result then
      begin
        Base := TEventObject.Create(aSender, Prop, OrigCall);
        for i := Low(ListDopArgs) to High(ListDopArgs) do
        begin
          Base.ListDopArgs[i] := ListDopArgs[i];
          ListDopArgs[i] := nil;
        end;

        TObject(m.Data) := Base;
        setMethodProp(aSender, PropName, m);

        FlList.Add(NameCase, Base);
      end;
    end;
  end;
end;

function TEventHook.ESet(aSender: TObject; PropName: string;
  OrigCall: Boolean = false): Boolean;
begin
  if @aSender <> nil then
    Result := ESet(aSender, RttiContext.GetType(aSender.ClassInfo)
      .GetProperty(PropName), OrigCall)
  else
    Result := false;
end;

function TEventHook.EAdd(aSender: TObject; Prop: TRttiProperty;
  Event: TEventObjectNotify; OrigCall: Boolean = false): Boolean;
var
  Base: TEventObject;
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
    Base.OrigCall := OrigCall;
  end;
end;

function TEventHook.EAdd(aSender: TObject; PropName: string;
  Event: TEventObjectNotify; OrigCall: Boolean = false): Boolean;
var
  Base: TEventObject;
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
    Base.OrigCall := OrigCall;
  end;
end;

function TEventHook.ERem(aSender: TObject; PropName: string): Boolean;
var
  Base: TEventObject;
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
  Item: TPair<String, TEventObject>;
begin
  for Item in FlList do
    Item.Value.Destroy;

  FlList.Free;
end;

Procedure TEventObject.Ec1;
begin
  PointArgs[0] := @A1;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1);
end;

Procedure TEventObject.Ec2;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2);
end;

Procedure TEventObject.Ec3;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3);
end;

Procedure TEventObject.Ec4;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4);
end;

Procedure TEventObject.Ec5;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5);
end;

Procedure TEventObject.Ec6;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6);
end;

Procedure TEventObject.Ec7;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7);
end;

Procedure TEventObject.Ec8;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8);
end;

Procedure TEventObject.Ec9;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9);
end;

Procedure TEventObject.Ec10;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10);
end;

Procedure TEventObject.Ec11;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11);
end;

Procedure TEventObject.Ec12;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10,
      A11, A12);
end;

Procedure TEventObject.Ec13;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13);
end;

Procedure TEventObject.Ec14;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14);
end;

Procedure TEventObject.Ec15;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15);
end;

Procedure TEventObject.Ec16;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16);
end;

Procedure TEventObject.Ec17;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17);
end;

Procedure TEventObject.Ec18;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18);
end;

Procedure TEventObject.Ec19;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19);
end;

Procedure TEventObject.Ec20;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20);
end;

Procedure TEventObject.Ec21;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21);
end;

Procedure TEventObject.Ec22;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22);
end;

Procedure TEventObject.Ec23;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23);
end;

Procedure TEventObject.Ec24;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24);
end;

Procedure TEventObject.Ec25;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25);
end;

Procedure TEventObject.Ec26;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24,
      A25, A26);
end;

Procedure TEventObject.Ec27;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25,
      A26, A27);
end;

Procedure TEventObject.Ec28;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  Handler;;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28);
end;

Procedure TEventObject.Ec29;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29);
end;

Procedure TEventObject.Ec30;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  PointArgs[29] := @A30;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29, A30);
end;

Procedure TEventObject.Ec31;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  PointArgs[29] := @A30;
  PointArgs[30] := @A31;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29, A30, A31);
end;

Procedure TEventObject.Ec32;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  PointArgs[29] := @A30;
  PointArgs[30] := @A31;
  PointArgs[31] := @A32;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29, A30, A31, A32);
end;

Procedure TEventObject.Ec33;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  PointArgs[29] := @A30;
  PointArgs[30] := @A31;
  PointArgs[31] := @A32;
  PointArgs[32] := @A33;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29, A30, A31, A32, A33);
end;

Procedure TEventObject.Ec34;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  PointArgs[29] := @A30;
  PointArgs[30] := @A31;
  PointArgs[31] := @A32;
  PointArgs[32] := @A33;
  PointArgs[33] := @A34;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29, A30, A31, A32, A33, A34);
end;

Procedure TEventObject.Ec35;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  PointArgs[29] := @A30;
  PointArgs[30] := @A31;
  PointArgs[31] := @A32;
  PointArgs[32] := @A33;
  PointArgs[33] := @A34;
  PointArgs[34] := @A35;
  Handler;
  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29, A30, A31, A32, A33, A34, A35);
end;

Procedure TEventObject.Ec36;
begin
  PointArgs[0] := @A1;
  PointArgs[1] := @A2;
  PointArgs[2] := @A3;
  PointArgs[3] := @A4;
  PointArgs[4] := @A5;
  PointArgs[5] := @A6;
  PointArgs[6] := @A7;
  PointArgs[7] := @A8;
  PointArgs[8] := @A9;
  PointArgs[9] := @A10;
  PointArgs[10] := @A11;
  PointArgs[11] := @A12;
  PointArgs[12] := @A13;
  PointArgs[13] := @A14;
  PointArgs[14] := @A15;
  PointArgs[15] := @A16;
  PointArgs[16] := @A17;
  PointArgs[17] := @A18;
  PointArgs[18] := @A19;
  PointArgs[19] := @A20;
  PointArgs[20] := @A21;
  PointArgs[21] := @A22;
  PointArgs[22] := @A23;
  PointArgs[23] := @A24;
  PointArgs[24] := @A25;
  PointArgs[25] := @A26;
  PointArgs[26] := @A27;
  PointArgs[27] := @A28;
  PointArgs[28] := @A29;
  PointArgs[29] := @A30;
  PointArgs[30] := @A31;
  PointArgs[31] := @A32;
  PointArgs[32] := @A33;
  PointArgs[33] := @A34;
  PointArgs[34] := @A35;
  PointArgs[35] := @A36;
  Handler;

  if OrigCall and (MethodDefault.Code <> nil) then
    TOldCallEvent(MethodDefault)(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11,
      A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26,
      A27, A28, A29, A30, A31, A32, A33, A34, A35, A36);
end;

initialization

HEventObj := TEventHook.Create;

finalization

HEventObj.Destroy;

end.
