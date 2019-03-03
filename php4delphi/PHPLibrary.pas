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
  phpCustomLibrary,
  phpFunctions;

type
  TPHPLibrary = class(TCustomPHPLibrary)
  published
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
    procedure RegisterMethod(AName : AnsiString; ADescription : AnsiString; AProc : TDispatchProc; AParams : array of TParamType); virtual;
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
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

procedure TPHPSimpleLibrary.RegisterMethod(AName: AnsiString; ADescription : AnsiString;
  AProc: TDispatchProc; AParams: array of TParamType);
var
 Func  : TPHPFunction;
 Param : TFunctionParam;
 cnt   : integer;
 O     : TDispatchObject;
begin
  Func := TPHPFunction(Functions.Add);
  Func.FunctionName := AnsiLowerCase(AName);
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

end.