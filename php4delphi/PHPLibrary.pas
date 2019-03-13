{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: PHPLibrary.pas,v 7.4 10/2009 delphi32 Exp $ }

unit phpLibrary;

interface
 uses
  Windows, SysUtils, Classes,
  {$IFDEF VERSION6}
  Variants,
  {$ENDIF}
  ZendTypes, ZendAPI,
  PHPTypes,
  PHPAPI,
  php4delphi,
  phpFunctions;

type
  TPHPLibrary = class(TCustomPHPLibrary)
  published
    property Executor;
    property LibraryName;
    property Functions;
  end;

  TDispatchProc = procedure of object;

  TDispatchObject = class
  Proc : TDispatchProc;
  end;

  TPHPSimpleLibrary = class(TCustomPHPLibrary)
  private
     FRetValue : variant;
     FParams   : TFunctionParams;
     FMethods  : TStringList;
  protected
     procedure _Execute(Sender: TObject; Parameters: TFunctionParams; var ReturnValue: Variant;
                        ZendVar: TZendVariable; TSRMLS_DC: Pointer);
    procedure ReturnOutputArg(AValue:variant);
    function GetInputArg(AIndex:integer):variant;
    function GetInputArgAsString(AIndex:integer):string;
    function GetInputArgAsInteger(AIndex:integer):integer;
    function GetInputArgAsBoolean(AIndex:integer):boolean;
    function GetInputArgAsFloat(AIndex:integer):double;
    function GetInputArgAsDateTime(AIndex:integer):TDateTime;
  public
    procedure RegisterMethod(AName : zend_ustr; ADescription : zend_ustr; AProc : TDispatchProc; AParams : array of TParamType); virtual;
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
  end;

  TPHPSystemLibrary = class(TPHPSimpleLibrary)
  protected
     {System procedures}
     procedure RoundProc;
     procedure TruncProc;
     procedure CopyProc;
     procedure PosProc;
     procedure LengthProc;
     {SysUtils procedures}
     procedure UpperCaseProc;
     procedure LowerCaseProc;
     procedure CompareStrProc;
     procedure CompareTextProc;
     procedure AnsiUpperCaseProc;
     procedure AnsiLowerCaseProc;
     procedure AnsiCompareStrProc;
     procedure AnsiCompareTextProc;
     procedure IsValidIdentProc;
     procedure IntToStrProc;
     procedure IntToHexProc;
     procedure StrToIntProc;
     procedure StrToIntDefProc;
     procedure FloatToStrProc;
     procedure FormatFloatProc;
     procedure StrToFloatProc;
     procedure EncodeDateProc;
     procedure EncodeTimeProc;
     procedure DayOfWeekProc;
     procedure DateProc;
     procedure TimeProc;
     procedure NowProc;
     procedure IncMonthProc;
     procedure IsLeapYearProc;
     procedure DateToStrProc;
     procedure TimeToStrProc;
     procedure DateTimeToStrProc;
     procedure StrToDateProc;
     procedure StrToTimeProc;
     procedure StrToDateTimeProc;
     procedure BeepProc;
     procedure RandomProc;
    public
     procedure Refresh; override;
    published
     property Executor;
    end;
implementation

{ TPHPSimpleLibrary }

function VarToInteger(v:variant):integer;
begin
   case VarType(v) of
      varSmallint, varInteger, varByte, varError: result:=v;
      varSingle, varDouble, varCurrency, varDate: result:=round(v);
      varBoolean: if v=true then result:=1 else result:=0;
      varString, varOleStr: result:=round(StrToFloat (v));
      varUnknown, varDispatch : result := 0;
      else
         if VarIsNull(v) then
            result := 0
         else
            result := VarAsType(v,varInteger);
   end;
end;

function VarToFloat(v:variant):double;
begin
   case VarType(v) of
    varSmallint,
    varInteger,
    varByte,
    varError,
    varSingle,
    varDouble,
    varCurrency,
    varDate:   Result:=v;
    varBoolean: if v=true then result:=1 else result:=0;
    varString,varOleStr: result:= StrToFloat(v);
    varUnknown, varDispatch : result := 0;
      else
         if VarIsNull(v) then
            result := 0
         else
            result := VarAsType(v,varDouble);
   end;
end;

function VarToBoolean(v:variant):boolean;
begin
   result:=(VarToInteger(v)<>0);
end;

procedure TPHPSimpleLibrary._Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar : TZendVariable;
  TSRMLS_DC: Pointer);
var
 ActiveFunctionName : string;
begin
  if not VarIsEmpty(FRetValue) then
   VarClear(FRetValue);
  FParams := Parameters;
  ActiveFunctionName := get_active_function_name(TSRMLS_DC);
  TDispatchObject(FMethods.Objects[FMethods.IndexOf(ActiveFunctionName)]).Proc;
  if not VarIsEmpty(FRetValue) then
   ReturnValue := FRetValue;
end;

procedure TPHPSimpleLibrary.RegisterMethod(AName: zend_ustr; ADescription : zend_ustr;
  AProc: TDispatchProc; AParams: array of TParamType);
var
 Func  : TPHPFunction;
 Param : TFunctionParam;
 cnt   : integer;
 O     : TDispatchObject;
begin
  Func := TPHPFunction(Functions.Add);
  Func.FunctionName :=
  {$IFDEF PHP_UNICE}LowerCase{$ELSE}AnsiLowerCase{$ENDIF}(AName);
  Func.Description := ADescription;

  for cnt := 0 to Length(AParams) - 1 do
   begin
      Param := TFunctionparam(Func.Parameters.Add);
      Param.ParamType := AParams[cnt];
   end;

   Func.OnExecute := _Execute;

   O := TDispatchObject.Create;
   O.Proc := Aproc;

   FMethods.AddObject(AName, O);
end;

procedure TPHPSimpleLibrary.ReturnOutputArg(AValue: variant);
begin
  FRetValue := AValue;
end;

function TPHPSimpleLibrary.GetInputArg(AIndex: integer): variant;
begin
  Result := FParams[AIndex].Value;
end;

function TPHPSimpleLibrary.GetInputArgAsBoolean(AIndex: integer): boolean;
begin
  Result := VarToBoolean(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsDateTime(
  AIndex: integer): TDateTime;
begin
   Result := VarToDateTime(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsFloat(AIndex: integer): double;
begin
  Result := VarToFloat(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsInteger(AIndex: integer): integer;
begin
  Result := VarToInteger(GetInputArg(AIndex));
end;

function TPHPSimpleLibrary.GetInputArgAsString(AIndex: integer): string;
begin
  Result := VarToStr(GetInputArg(AIndex));
end;

constructor TPHPSimpleLibrary.Create(AOwner: TComponent);
begin
  inherited;
  FMethods := TStringList.Create;
end;

destructor TPHPSimpleLibrary.Destroy;
var
 cnt : integer;
begin
  for cnt := 0 to FMethods.Count - 1 do
   Fmethods.Objects[cnt].Free;
  FMethods.Free;
  inherited;
end;


{ TPHPSystemLibrary }
procedure TPHPSystemLibrary.Refresh;
begin
  Functions.Clear;
  RegisterMethod( 'sys_UpperCase', 'System.UpperCase',
           UpperCaseProc, [tpString] ) ;
  RegisterMethod( 'sys_LowerCase',  'System.LowerCase',
          LowerCaseProc, [tpString] );
  RegisterMethod( 'sys_CompareStr',  'System.CompareStr',
         CompareStrProc, [tpString, tpString] );
  RegisterMethod( 'sys_CompareText',  'System.CompareText',
        CompareTextProc, [tpString, tpString] );
  RegisterMethod( 'sys_AnsiUpperCase', 'System.AnsiUpperCase',
       AnsiUpperCaseProc, [tpString] );
  RegisterMethod( 'sys_AnsiLowerCase', 'System.AnsiLowerCase',
       AnsiLowerCaseProc, [tpString] );
  RegisterMethod( 'sys_AnsiCompareStr', 'System.AnsiCompareStr',
      AnsiCompareStrProc, [tpString, tpString] );
  RegisterMethod( 'sys_AnsiCompareText', 'System.AnsiCompareText',
     AnsiCompareTextProc, [tpString, tpString] );
  RegisterMethod( 'sys_IsValidIdent',   'System.IsValidIndent',
      IsValidIdentProc, [tpString] );
  RegisterMethod( 'sys_IntToStr',   'System.IntToStr',
          IntToStrProc, [tpInteger] );
  RegisterMethod( 'sys_IntToHex',   'System.IntToHex',
           IntToHexProc, [tpInteger, tpInteger] );
  RegisterMethod( 'sys_StrToInt',   'System.StrToInt',
          StrToIntProc, [tpString] );
  RegisterMethod( 'sys_StrToIntDef','System.StrToIntDef',
          StrToIntDefProc, [tpString, tpInteger] );
  RegisterMethod( 'sys_FloatToStr', 'System.FloatToStr',
          FloatToStrProc, [tpFloat] );
  RegisterMethod( 'sys_FormatFloat','System.FormatFloat',
         FormatFloatProc, [tpString, tpFloat] );
  RegisterMethod( 'sys_StrToFloat', 'System.StrToFloat',
          StrToFloatProc, [tpString] );
  RegisterMethod( 'sys_EncodeDate', 'System.EncodeDate',
          EncodeDateProc, [tpInteger, tpInteger, tpInteger] );
  RegisterMethod( 'sys_EncodeTime', 'System.EncodeTime',
         EncodeTimeProc, [tpInteger, tpInteger, tpInteger, tpInteger] );
  RegisterMethod( 'sys_DayOfWeek',  'System.GetDayOfWeek',
          DayOfWeekProc, [tpFloat] );
  RegisterMethod( 'sys_Date',       'System.GetDate',
          DateProc, [] );
  RegisterMethod( 'sys_Time',       'System.GetTime',
          TimeProc, [] );
  RegisterMethod( 'sys_Now',        'System.GetDateNow',
          NowProc, [] );
  RegisterMethod( 'sys_IncMonth',   'System.IncMonth',
          IncMonthProc, [tpFloat, tpInteger] );
  RegisterMethod( 'sys_IsLeapYear', 'System.IsLeapYear',
          IsLeapYearProc, [tpInteger] );
  RegisterMethod( 'sys_DateToStr',  'System.DateToStr',
          DateToStrProc, [tpFloat] );
  RegisterMethod( 'sys_TimeToStr',  'System.TimeToStr',
          TimeToStrProc, [tpFloat] );
  RegisterMethod( 'sys_DateTimeToStr','System.DateTimeToStr',
        DateTimeToStrProc, [tpFloat] );
  RegisterMethod( 'sys_StrToDate',   'System.StrToDate',
         StrToDateProc, [tpString] );
  RegisterMethod( 'sys_StrToTime',   'System.StrToTime',
         StrToTimeProc, [tpString] );
  RegisterMethod( 'sys_StrToDateTime','System.StrToDateTime',
        StrToDateTimeProc, [tpString] );
  RegisterMethod( 'sys_Beep',         'System.MessageBeep',
        BeepProc, [] );
  RegisterMethod( 'sys_Round',        'System.Round',
        RoundProc, [tpFloat] );
  RegisterMethod( 'sys_Trunc',        'System.StrTruncate',
        TruncProc, [tpFloat] );
  RegisterMethod( 'sys_Copy',         'System.StrCopy',
        CopyProc, [tpString, tpInteger, tpInteger] );
  RegisterMethod( 'sys_Pos',          'System.StrPos',
        PosProc, [tpString, tpString] );
  RegisterMethod( 'sys_Length',       'System.Length',
        LengthProc, [tpString] );
  RegisterMethod( 'sys_Random',       'System.Random',
        RandomProc, [] );

  inherited;

end;
procedure TPHPSystemLibrary.UpperCaseProc;
begin
   ReturnOutputArg( UpperCase( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.LowerCaseProc;
begin
   ReturnOutputArg( LowerCase( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.CompareStrProc;
begin
  ReturnOutputArg( CompareStr( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) ) );
end;

procedure TPHPSystemLibrary.CompareTextProc;
begin
   ReturnOutputArg( CompareText( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) ) );
end;

procedure TPHPSystemLibrary.AnsiUpperCaseProc;
begin
  ReturnOutputArg(
    {$IFDEF PHP_UNICE}UpperCase{$ELSE}AnsiUpperCase{$ENDIF}( GetInputArgAsString( 0 ) )
  );
end;

procedure TPHPSystemLibrary.AnsiLowerCaseProc;
begin
  ReturnOutputArg(
    {$IFDEF PHP_UNICE}LowerCase{$ELSE}AnsiLowerCase{$ENDIF}( GetInputArgAsString( 0 ) )
  );
end;

procedure TPHPSystemLibrary.AnsiCompareStrProc;
begin
  ReturnOutputArg(
    {$IFDEF PHP_UNICE}CompareStr{$ELSE}AnsiCompareStr{$ENDIF}( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) )
  );
end;

procedure TPHPSystemLibrary.AnsiCompareTextProc;
begin
   ReturnOutputArg(
    {$IFDEF PHP_UNICE}CompareText{$ELSE}AnsiCompareText{$ENDIF}( GetInputArgAsString( 0 ),GetInputArgAsString( 1 ) )
   );
end;


procedure TPHPSystemLibrary.IsValidIdentProc;
begin
  ReturnOutputArg( IsValidIdent( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.IntToStrProc;
begin
  ReturnOutputArg( IntToStr( GetInputArgAsInteger( 0 ) ) );
end;

procedure TPHPSystemLibrary.IntToHexProc;
begin
  ReturnOutputArg( IntToHex( GetInputArgAsInteger( 0 ),GetInputArgAsInteger( 1 ) ) );
end;

procedure TPHPSystemLibrary.StrToIntProc;
begin
  ReturnOutputArg( StrToInt( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToIntDefProc;
begin
  ReturnOutputArg( StrToIntDef( GetInputArgAsString( 0 ),GetInputArgAsInteger( 1 ) ) );
end;

procedure TPHPSystemLibrary.FloatToStrProc;
begin
  ReturnOutputArg( FloatToStr( GetInputArgAsFloat( 0 ) ) );
end;

procedure TPHPSystemLibrary.FormatFloatProc;
begin
  ReturnOutputArg( FormatFloat( GetInputArgAsString( 0 ),GetInputArgAsFloat( 1 ) ) );
end;

procedure TPHPSystemLibrary.StrToFloatProc;
begin
  ReturnOutputArg( StrToFloat( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.EncodeDateProc;
begin
  ReturnOutputArg( EncodeDate(
         GetInputArgAsInteger( 0 ),
         GetInputArgAsInteger( 1 ),
         GetInputArgAsInteger( 2 ) ) );
end;

procedure TPHPSystemLibrary.EncodeTimeProc;
begin
  ReturnOutputArg( EncodeTime(
         GetInputArgAsInteger( 0 ),
         GetInputArgAsInteger( 1 ),
         GetInputArgAsInteger( 2 ),
         GetInputArgAsInteger( 3 ) ) );
end;



procedure TPHPSystemLibrary.DayOfWeekProc;
begin
  ReturnOutputArg( DayOfWeek( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.DateProc;
begin
  ReturnOutputArg( Date );
end;

procedure TPHPSystemLibrary.TimeProc;
begin
  ReturnOutputArg( Time );
end;

procedure TPHPSystemLibrary.NowProc;
begin
  ReturnOutputArg( Now );
end;

procedure TPHPSystemLibrary.IncMonthProc;
begin
  ReturnOutputArg( IncMonth( GetInputArgAsDateTime( 0 ),GetInputArgAsInteger( 1 ) ) );
end;

procedure TPHPSystemLibrary.IsLeapYearProc;
begin
  ReturnOutputArg( IsLeapYear( GetInputArgAsInteger( 0 ) ) );
end;

procedure TPHPSystemLibrary.DateToStrProc;
begin
  ReturnOutputArg( DateToStr( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.TimeToStrProc;
begin
  ReturnOutputArg( TimeToStr( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.DateTimeToStrProc;
begin
  ReturnOutputArg( DateTimeToStr( GetInputArgAsDateTime( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToDateProc;
begin
  ReturnOutputArg( StrToDate( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToTimeProc;
begin
  ReturnOutputArg( StrToTime( GetInputArgAsString( 0 ) ) );
end;

procedure TPHPSystemLibrary.StrToDateTimeProc;
begin
  ReturnOutputArg( StrToDateTime( GetInputArgAsString( 0 ) ) );
end;


procedure TPHPSystemLibrary.BeepProc;
begin
  Beep;
end;


procedure TPHPSystemLibrary.RoundProc;
begin
  ReturnOutputArg( Integer(Round( GetInputArgAsFloat( 0 ) )) );
end;

procedure TPHPSystemLibrary.TruncProc;
begin
  ReturnOutputArg( Integer(Trunc( GetInputArgAsFloat( 0 ) )) );
end;

procedure TPHPSystemLibrary.CopyProc;
begin
  ReturnOutputArg( Copy(
         GetInputArgAsString( 0 ),
         GetInputArgAsInteger( 1 ),
         GetInputArgAsInteger( 2 ) ) );
end;


procedure TPHPSystemLibrary.PosProc;
begin
  ReturnOutputArg( pos(GetInputArgAsString( 0 ),GetInputArgAsString( 1 )) );
end;

procedure TPHPSystemLibrary.LengthProc;
begin
  ReturnOutputArg( Length( GetInputArgAsString( 0 ) ) );
end;


procedure TPHPSystemLibrary.RandomProc;
begin
  ReturnOutputArg( Random );
end;

end.