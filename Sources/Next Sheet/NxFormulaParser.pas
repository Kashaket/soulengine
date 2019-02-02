{-----------------------------------------------------------}
{----Purpose : Text Formula Parser                          }
{    By      : Ir. G.W. van der Vegt                        }
{    For     : Myself.                                      }
{    Depends : Nothing                                      }
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 30051990 -Creatie (function call/exits removed).          }
{ 31051990 -Revisie (Boolean expressions).                  }
{ 01041991 -Revisie (HEAP Function Storage).                }
{ 27031991 -External Real string vars (tfp_realstr)         }
{           are corrected the same way as the parser        }
{           corrects them before using TURBO's VAL.         }
{ 29081991 -Support added for recursion with string         }
{           variables so they may contain formula's         }
{           now.                                            }
{ 11041994 -Hyperbolic, reciproke & inverse                 }
{           goniometric objects added,                      }
{           Type of tfp_lnr changed to Byte.                }
{           Bug fixed in tfp_check (tfp_lnr not always      }
{           initialized to 0)                               }
{ 19101994 -new of statepointer moved to                    }
{           tfp_parse2real, so calling tfp_parse2real       }
{           from within objects is possible                 }
{ 13031999 -Converted to delphi4 and used open arrays       }
{           to parse the N reals.                           }
{          -Removed function name length limit.             }
{          -Put function in a collection.                   }
{          -Removed parameter limit on nreal function.      }
{          -Modeled parser into a class.                    }
{          -Modeled parsestate into an open array.          }
{          -Raised formula length to string/integer         }
{           limit.                                          }
{          -Remove Noobj and Init as they can be            }
{           done with the collection itself.                }
{ 13031999 -Renamed to Tfp.                                 }
{          -Changed fiearr into objects.                    }
{          -Removed tfp_erpos.                              }
{          -Simplyfied names a bit.                         }
{          -Added AVG and STD.                              }
{          -Had to remove WITH statement on some            }
{           points due to fact that it gave errors          }
{           when modified within the function.              }
{          -Added a _parser variable to the                 }
{           functions as we need to be able to support      }
{           more than one and we must be able to find       }
{           the correct parsestate.                         }
{          -Changed _parser into _parser, all               }
{           internal classes now start with an _.           }
{          -Turned it into a VCL.                           }
{          -Added contructor & destructor.                  }
{          -Moved gluepointer as a last global variable     }
{           into TNxFormulaParser.                          }
{          -Used result in functions.                       }
{          -Added user definable errormessages.             }
{          -Added all internal functions at creation time.  }
{           This will allow designtime evaluations.         }
{          -Added some new errormessages for new features.  }
{          -Added Clearernr to clear the last error.        }
{ 18031999 -Added single string function Length(string).    }
{          -Added strings to parsing. Quotes can be         }
{           either ' ' or " " as long as they match.        }
{ 07041999 -Added 2 & nstring functions.                    }
{ 13041999 -Added tfp_usermsg base.                         }
{          -Added tfp_ok constant.                          }
{ 02061999 -Reinserted inherited create and destroy.        }
{           VCL couldn't live without them.                 }
{          -For OuNL I have to disable the VCL stuff.       }
{          -Added If(boolexpr,trueval,falseval) function.   }
{          -Added Sum function.                             }
{          -Syntax of existing Boolean functions AND,OR &   }
{           XOR is spreadsheet compatible.                  }
{          -Added Rnd(n), returns integer value >=0 and <n. }
{          -Added Rand,   returns real value >=0 and <1.    }
{          -Combined all three sources (VCL, STANDALONE and }
{           ACTIVEX).                                       }
{ 07102001 -Added Designtime Evaluation.                    }
{          -Removed ACTIVEX & STANDALONE Stuff.             }
{          -Turned ErrorMessages into an array property.    }
{          -Removed Error 31 'Errormessages already exists'.}
{          -Converted all reals to Extented type.           }
{          -Changed checks on Csc(), Tan(), Cot() and Sec() }
{           functions so it no longer depends on Cos/Sin    }
{           Values.                                         }
{ 03032008 -Started on transition to methods instead of     }
{           far calls.                                      }
{          -Added Abs2 method to test with.                 }
{          -Method must be published and have a 'm' prefix. }
{          -Variables must be published properties.         }
{          -Swapped _fieptr collection for TStringList as   }
{           name=type (+object).                            }
{          -Ported Variables as Properties.                 }
{          -Turned ErrorMessages into ResourceStrings.      }
{                                                           }
{          -TODO Use RTTI to determine prototype.           }
{          -TODO Turn ErrorMsg into a Stringlist and        }
{           return indexes instead of hardcoded numbers.    }
{-----------------------------------------------------------}
{ TO DO                                                     }
{ 1. Renumber internal errormessages below 0.               }
{ 2. Remove obsoleted errormessages.                        }
{ 3. Scan for matching string quotes before starting to     }
{    parse (like counting brackets).                        }
{ 6. Cos(pi/2) <> 0.                                        }
{-----------------------------------------------------------}

unit NxFormulaParser;

interface

uses
  Windows, SysUtils, Classes;

{---------------------------------------------------------}

const
  tfp_true                      = 1.0;                                          {----Extended value for BOOLEAN TRUE }
  tfp_false                     = 0.0;                                          {----Extended value for BOOLEAN FALSE}
  tfp_maxreal                   = +9.99999999e37;                               {----Internal maxreal                }
  tfp_maxlongint                = maxlongint - 1;                               {----Internal longint                }
  tfp_usermsg                   = 100;                                          {----Start of user error messages    }
  tfp_ok                        = 0;                                            {----No Error                        }

  {---------------------------------------------------------}

type
  //the types of add-on functions and variables supported.
  FType = (
    tfp_m_noparm,                                                               {----Function or Function()          }
    tfp_m_1real,                                                                {----Function (VAR r : Extended)     }
    tfp_m_2real,                                                                {----Function(VAR r1,r2 : Extended)  }
    tfp_m_nreal,                                                                {----Function(VAR r)                 }
    tfp_realvar,                                                                {----Real VAR                        }
    tfp_intvar,                                                                 {----Integer VAR                     }
    tfp_boolvar,                                                                {----Boolean VAR                     }
    tfp_strvar,                                                                 {----String VAR (Formula)            }
    tfp_m_1str,                                                                 {----Function(VAR s : String)        }
    tfp_m_2str,                                                                 {----Function(VAR s1,s2 : String)    }
    tfp_m_nstr);                                                                {----Function(VAR s)                 }

  FStateRec = record                                                            {----Stack for recursive parsing     }
    //Copy of string to Parse
    line: string;
    //Parsing Pointer into Line
    lp: Integer;
    //Character at Lp Postion
    nextchar: CHAR;
  end;

  {---------------------------------------------------------}

  TNxFormulaParser = class(TComponent)
  private
    FErnr: Integer;
    FErrmsgs: TStringList;
    FExpression: string;
    FObjectReference: TObject;
    //Array of objects & method/function names & types.
    FObjects: TStringList;
    //The State of the Parser when recursing for String Variables.
    FState: array of FStateRec;
    function GetBoolResult: Boolean;
    function GetErmsg: string;
    function GetErrorMessage(Index: Integer): string;
    function GetExpression: string;
    function GetRealResult: Extended;
    procedure SetBoolDummy(const Value: Boolean);
    procedure SetErMsgDummy(const Value: string);
    procedure SetErnrDummy(const Value: Integer);
    procedure SetErrorMessage(Index: Integer; const Value: string);
    procedure SetExpression(const Value: string);
    procedure SetRealDummy(const Value: Extended);
  protected
    function Evaluate(s: string): Extended;
    procedure Tfp_AddInternals;
    procedure Tfp_check(s: string);
    function Tfp_eval_b_expr: Extended;
    function Tfp_eval_factor: Extended;
    function Tfp_eval_number: Extended;
    function Tfp_eval_r_expr: Extended;
    function Tfp_eval_subterm: Extended;
    function Tfp_eval_term: Extended;
    procedure Tfp_newchar;
    procedure Tfp_skip;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddErmsg(nr: Integer; msg: string);
    procedure Addobject(obj: TObject; name: string; typ: Ftype);
    procedure Clearernr;
    procedure Seternr(Value: integer);
    //The list of possible errormessages.
    property ErrorMessages[Index: Integer]: string read GetErrorMessage write SetErrorMessage;
  published
    function mAbs(var context: TNxFormulaParser; var r: Extended): Extended;
    function mAnd(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mArccosh(var context: TNxFormulaParser; var r: Extended): Extended;
    function mArccoth(var context: TNxFormulaParser; var r: Extended): Extended;
    function mArccsch(var context: TNxFormulaParser; var r: Extended): Extended;
    function mArcsech(var context: TNxFormulaParser; var r: Extended): Extended;
    function mArcsinh(var context: TNxFormulaParser; var r: Extended): Extended;
    function mArctan(var context: TNxFormulaParser; var r: Extended): Extended;
    function mArctanh(var context: TNxFormulaParser; var r: Extended): Extended;
    function mAvg(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mAverage(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mCos(var context: TNxFormulaParser; var r: Extended): Extended;
    function mCosh(var context: TNxFormulaParser; var r: Extended): Extended;
    function mCot(var context: TNxFormulaParser; var r: Extended): Extended;
    function mCoth(var context: TNxFormulaParser; var r: Extended): Extended;
    function mCsc(var context: TNxFormulaParser; var r: Extended): Extended;
    function mCsch(var context: TNxFormulaParser; var r: Extended): Extended;
    function mDeg(var context: TNxFormulaParser; var r: Extended): Extended;
    function mE(var context: TNxFormulaParser): Extended;
    function mExp(var context: TNxFormulaParser; var r: Extended): Extended;
    function mFalse(var context: TNxFormulaParser): Extended;
    function mFrac(var context: TNxFormulaParser; var r: Extended): Extended;
    function mIf(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mInt(var context: TNxFormulaParser; var r: Extended): Extended;
    function mIor(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mLength(var context: TNxFormulaParser; var s: string): Extended;
    function mLn(var context: TNxFormulaParser; var r: Extended): Extended;
    function mLog(var context: TNxFormulaParser; var r: Extended): Extended;
    function mMax(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mMean(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mMin(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mNot(var context: TNxFormulaParser; var r: Extended): Extended;
    function Mpi(var context: TNxFormulaParser): Extended;
    function mRad(var context: TNxFormulaParser; var r: Extended): Extended;
    function mRand(var context: TNxFormulaParser): Extended;
    function mRnd(var context: TNxFormulaParser; var r: Extended): Extended;
    function mRound(var context: TNxFormulaParser; var r: Extended): Extended;
    function mSec(var context: TNxFormulaParser; var r: Extended): Extended;
    function mSech(var context: TNxFormulaParser; var r: Extended): Extended;
    function mSgn(var context: TNxFormulaParser; var r: Extended): Extended;
    function mSin(var context: TNxFormulaParser; var r: Extended): Extended;
    function mSinh(var context: TNxFormulaParser; var r: Extended): Extended;
    function mSqr(var context: TNxFormulaParser; var r: Extended): Extended;
    function mSqrt(var context: TNxFormulaParser; var r: Extended): Extended;
    function mStd(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mStdDev(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mStrComp(var context: TNxFormulaParser; var s1, s2: string): Extended;
    function mSum(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
    function mTan(var context: TNxFormulaParser; var r: Extended): Extended;
    function mTanh(var context: TNxFormulaParser; var r: Extended): Extended;
    function mTrue(var context: TNxFormulaParser): Extended;
    function mXor(var context: TNxFormulaParser; var r1, r2: Extended): Extended;
    //Evaluates and returns the Result as a Boolean.
    property BoolResult: Boolean read GetBoolResult write SetBoolDummy stored False;
    //First error message encountered.
    property Ermsg: string read GetErmsg write SetErMsgDummy stored False;
    //First error number encountered.
    property Ernr: Integer read Fernr write SetErnrDummy stored False;
    //The Expression being parsed.
    property Expression: string read GetExpression write SetExpression;
    //Reference to an Object of choice.
    property ObjectReference: TObject read FObjectReference write FObjectReference;
    //Evaluates and returns the Result as a Floating Point.
    property RealResult: Extended read GetRealResult write SetRealDummy stored False;
  end;

  //prototypes for add-on functions & variables.
  TFunction_no_parm = function(var context: TNxFormulaParser): Extended of object;
  TFunction_1_Real = function(var context: TNxFormulaParser; var lu_r: Extended): Extended of object;
  TFunction_2_real = function(var context: TNxFormulaParser; var lu_r1, lu_r2: Extended): Extended of object;
  TFunction_n_real = function(var context: TNxFormulaParser; var lu_r: array of Extended): Extended of object;
  TFunction_1_str = function(var context: TNxFormulaParser; var lu_s: string): Extended of object;
  TFunction_2_str = function(var context: TNxFormulaParser; var lu_s1, lu_s2: string): Extended of object;
  TFunction_n_str = function(var context: TNxFormulaParser; var lu_s: array of string): Extended of object;

implementation

uses
  TypInfo;

resourcestring
  SObjectNotFound               = 'Object not found';
  SFunctionNotFound             = 'Function not found';
  SIfConditionsNeedsToBeBoolean = 'if conditions needs to be boolean';
  SIfNeedsExact3Parameters      = 'if needs exact 3 parameters';
  SStandardDeviationNotDefinedForLe = 'Standard deviation not defined for less than two items';
  SRNDRangeToLarge              = 'RND range to large';
  SAverageNotDefinedForZeroItems = 'Average not defined for zero items';
  SArccothXNotDefinedForAbsX1   = 'Arccoth(x) not defined for Abs(x)<=1';
  SArcsechXNotDefinedForX0OrX1  = 'Arcsech(x) not defined for x<=0 or x>1';
  SArccsch0NotDefined           = 'Arccsch(0) not defined';
  SArcTanhXNotDefinedForAbsX1   = 'ArcTanh(x) not defined for Abs(x)=>1';
  SArcCoshXNotDefinedForX1      = 'ArcCosh(x) not defined for x<1';
  SCoth0NotDefined              = 'Coth(0) not defined';
  SCsch0NotDefined              = 'Csch(0) not defined';
  SParameterToLarge             = 'Parameter to large';
  SCotNPINotDefined             = 'Cot( n*PI ) not defined';
  SSec2n1PI2NotDefined          = 'Sec( (2n+1)*PI/2 ) not defined';
  SCscNPINotDefined             = 'Csc( n*PI ) not defined';
  SSQRTXForX0ComplexNumber      = 'SQRT(x) for x<0 -> complex number';
  SLNXOrLOGXForX0ComplexNumber  = 'LN(x) or LOG(x) for x<=0 -> complex number';
  SNotABooleanExpression        = 'Not a boolean expression';
  STAN2n1PI2NotDefined          = 'TAN( (2n+1)*PI/2 ) not defined';
  SMatchingEndStringQuoteNotFound = 'Matching end string quote not found';
  SMissingStringQuote           = 'Missing string quote';
  SFunctionNotFullyImplementedYet = 'Function not fully implemented yet';
  SFunctionAlreadyAdded         = 'Function already added';
  SNotEnoughObjectsOrConstants  = 'Not enough objects or constants';
  SMemoryProblems               = 'Memory problems';
  SWrongNumberOfParameters      = 'Wrong number of parameters';
  SIllegalCharactersInFunctionname = 'Illegal characters in functionname';
  SIntermediateResultOutOfRange = 'Intermediate result out of range';
  SToManyFunctionOrConstants    = 'To many function or constants';
  SDivideByZero                 = 'Divide by zero';
  SEmptyString                  = 'Empty string';
  SRealExponentComplexNumber    = 'Real exponent -> complex number';
  SMismatch                     = '( ) mismatch';
  SUnkownFunction               = 'Unkown function';
  SInvalidFormatOfANumber       = 'Invalid format of a number';
  SResultOk                     = 'Result ok';

  {---------------------------------------------------------}
  {----TP round function not useable                        }
  {---------------------------------------------------------}

function Tfp_round(var r: Extended): LONGINT;
begin
  if (r < 0) then
    Tfp_round := Trunc(r - 0.5)
  else
    Tfp_round := Trunc(r + 0.5);
end;                                                                            {of Tfp_round}

{---------------------------------------------------------}

constructor TNxFormulaParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FExpression := '0';

  ClearErnr;

  Fobjects := TStringList.Create();                                             // _fieptr.Create(_fie_typ);
  Ferrmsgs := TStringList.Create();

  //veg:Be sure to get random numbers with RAND & RND...
  Randomize;

  Tfp_AddInternals();
end;

{---------------------------------------------------------}

destructor TNxFormulaParser.Destroy;
begin
  FObjects.Destroy;
  FObjects := nil;

  FErrmsgs.Destroy;
  FErrmsgs := nil;

  inherited Destroy;                                                            //veg:untested??
end;

{---------------------------------------------------------}

procedure TNxFormulaParser.AddErmsg(nr: Integer; msg: string);
begin
  ErrorMessages[nr] := msg;
end;

procedure TNxFormulaParser.Addobject(obj: TObject; name: string;
  typ: Ftype);
var
  i                             : INTEGER;
  Fname                         : string;
begin
  if (Fobjects.IndexOfName(name) <> -1) then
    Seternr(30)
  else
    begin
      Fname := name;

      for i := 1 to Length(Fname) do
        if (Upcase(Fname[i]) in ['0'..'9', '_', 'A'..'Z']) then
          Fname[i] := Upcase(Fname[i])
        else
          Seternr(12);

      if (Length(Fname) > 0) and not (Fname[1] in ['A'..'Z']) then
        Seternr(12);

      FObjects.AddObject(Format('%s=%d', [Fname, Ord(typ)]), obj);
    end;
end;

{---------------------------------------------------------}

procedure TNxFormulaParser.Clearernr;
begin
  Fernr := 0;
end;

{---------------------------------------------------------}

function TNxFormulaParser.Evaluate(s: string): Extended;
var
  value                         : Extended;
begin
  value := 0;

  Fernr := 0;

  SetLength(Fstate, 1);

  Tfp_check(s);

  if (ernr = tfp_ok) then
    value := Tfp_eval_b_expr;

  Fstate := nil;

  if (ernr <> tfp_ok) then
    Result := 0.0
  else
    Result := value;

end;                                                                            {of Tfp_Parse2Real}

{---------------------------------------------------------}

function TNxFormulaParser.GetBoolResult: Boolean;
begin
  Result := Evaluate(FExpression) <> tfp_false;
end;

{---------------------------------------------------------}

function TNxFormulaParser.Getermsg: string;
begin
  Result := Ferrmsgs.Values[Format('%d', [ernr])];
  if (Result = '') then
    Result := 'Unknown error message';
end;                                                                            {of Tfp_ermsg}

{---------------------------------------------------------}

function TNxFormulaParser.GetErrorMessage(Index: Integer): string;
begin
  Result := Ferrmsgs.Values[Format('%d', [Index])];
end;

{---------------------------------------------------------}

function TNxFormulaParser.GetExpression: string;
begin
  Result := FExpression;
end;

{---------------------------------------------------------}

function TNxFormulaParser.GetRealResult: Extended;
begin
  Result := Evaluate(FExpression);
end;

{---------------------------------------------------------}

function TNxFormulaParser.mAbs(var context: TNxFormulaParser;
  var r: Extended): Extended;
begin
  Result := Abs(r);
end;

{---------------------------------------------------------}
{----Internal objects                                     }
{---------------------------------------------------------}

function TNxFormulaParser.mAnd(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
var
  r                             : Extended;
  i                             : INTEGER;
begin
  r := 0;

  for i := Low(lu_r) to High(lu_r) do
    if (lu_r[i] <> tfp_false) and
      (lu_r[i] <> tfp_true) then
      begin
        if (context.ernr = tfp_ok) then
          context.Seternr(13);
      end;

  if (context.ernr = tfp_ok) and (Length(lu_r) > 0) then
    begin
      r := tfp_true * Ord(lu_r[Low(lu_r)] = tfp_true);
      for i := Low(lu_r) + 1 to High(lu_r) do
        r := tfp_true * Ord((r = tfp_true) and (lu_r[i] = tfp_true))
    end
  else
    context.Seternr(14);

  if context.ernr = tfp_ok then
    Result := r
  else
    Result := 0.0;
end;                                                                            {of xAND}

{---------------------------------------------------------}

function TNxFormulaParser.mArccosh(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) < SQRT(tfp_maxreal)) then
    begin
      if (r >= 1) then
        Result := ln(r + Sqrt(Sqr(r) - 1))
      else
        context.Seternr(23);
    end
  else
    context.Seternr(20)
end;                                                                            {of xArccosh}

{---------------------------------------------------------}

function TNxFormulaParser.mArccoth(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > 1) then
    Result := Ln((r + 1) / (r - 1)) / 2
  else
    context.Seternr(27)
end;                                                                            {of xArccoth}

{---------------------------------------------------------}

function TNxFormulaParser.mArccsch(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (r < SQRT(Tfp_maxreal)) then
    begin
      if (r <> 0) then
        Result := Ln((1 / r) + SQRT((1 / SQR(r)) + 1))
      else
        context.Seternr(25)
    end
  else
    context.Seternr(20);
end;                                                                            {of xArccsch}

{---------------------------------------------------------}

function TNxFormulaParser.mArcsech(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (r < SQRT(Tfp_maxreal)) then
    begin
      if (r > 0) and (r <= 1) then
        Result := Ln((1 / r) + SQRT((1 / SQR(r)) - 1))
      else
        context.Seternr(26)
    end
  else
    context.Seternr(20)
end;                                                                            {of xArcsech}

{---------------------------------------------------------}

function TNxFormulaParser.mArcsinh(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) < SQRT(tfp_maxreal)) then
    Result := Ln(r + Sqrt(Sqr(r) + 1))
  else
    context.Seternr(20)
end;                                                                            {of xArcsinh}

{---------------------------------------------------------}

function TNxFormulaParser.mArctan(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := Arctan(r);
end;                                                                            {of xArctan}

{---------------------------------------------------------}

function TNxFormulaParser.mArctanh(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) < 1) then
    Result := ln((1 + r) / (1 - r)) / 2
  else
    context.Seternr(24)
end;                                                                            {of xArctanh}

{---------------------------------------------------------}
{----Simple statistics.                                   }
{---------------------------------------------------------}

function TNxFormulaParser.mAvg(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
var
  i                             : INTEGER;
begin
  Result := 0;

  for i := Low(lu_r) to High(lu_r) do
    Result := Result + lu_r[i];

  if (Length(lu_r) > 0) then
    Result := Result / Length(lu_r)
  else
    context.Seternr(28);
end;

{---------------------------------------------------------}

function TNxFormulaParser.mAverage(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
begin
  Result:=mAvg(context, lu_r);
end;                                                                            {of xAvg}

{---------------------------------------------------------}

function TNxFormulaParser.mCos(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := Cos(r);
end;                                                                            {of xCos}

{---------------------------------------------------------}

function TNxFormulaParser.mCosh(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > Ln(tfp_maxreal)) then
    context.Seternr(20)
  else
    Result := (Exp(r) + Exp(-r)) / 2;
end;                                                                            {of xCosh}

{---------------------------------------------------------}

function TNxFormulaParser.mCot(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Int(r / pi) = r / pi) then
    context.Seternr(19)
  else
    Result := Cos(r) / Sin(r);
end;                                                                            {xCot}

{---------------------------------------------------------}

function TNxFormulaParser.mCoth(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > Ln(tfp_maxreal)) then
    context.Seternr(20)
  else
    begin
      if (r = 0) then
        context.Seternr(22)
      else
        Result := (Exp(r) + Exp(-r)) / (Exp(r) - Exp(-r))
    end;
end;                                                                            {of xCoth}

{---------------------------------------------------------}
{----Hyperbolic, reciproce and inverse goniometric        }
{    objects                                              }
{---------------------------------------------------------}

function TNxFormulaParser.mCsc(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Int(r / pi) = r / pi) then
    context.Seternr(17)
  else
    Result := 1 / Sin(r);
end;                                                                            {xCsc}

{---------------------------------------------------------}

function TNxFormulaParser.mCsch(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > Ln(tfp_maxreal)) then
    context.Seternr(20)
  else
    begin
      if (r = 0) then
        context.Seternr(21)
      else
        Result := 2 / (Exp(r) - Exp(-r))
    end;
end;                                                                            {of xCsch}

{---------------------------------------------------------}

function TNxFormulaParser.mDeg(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := (r / pi) * 180;
end;                                                                            {of xDEG}

{---------------------------------------------------------}

function TNxFormulaParser.mE(var context: TNxFormulaParser): Extended;
begin
  Result := Exp(1);
end;                                                                            {of xE}

{---------------------------------------------------------}

function TNxFormulaParser.mExp(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) < Ln(tfp_maxreal)) then
    Result := Exp(r)
  else
    context.Seternr(11);
end;                                                                            {of xExp}

{---------------------------------------------------------}

function TNxFormulaParser.mFalse(var context: TNxFormulaParser): Extended;
begin
  Result := tfp_false;
end;                                                                            {of xFalse}

{---------------------------------------------------------}

function TNxFormulaParser.mFrac(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := Frac(r);
end;                                                                            {of xFrac}

{---------------------------------------------------------}

function TNxFormulaParser.mIf(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
begin
  Result := tfp_false;

  if (Length(lu_r) <> 3) then
    context.Seternr(35)
  else
    begin
      if ((lu_r[Low(lu_r)] <> tfp_true) and (lu_r[Low(lu_r)] <> tfp_false)) then
        context.Seternr(36)
      else
        begin
          if (lu_r[Low(lu_r)] = tfp_true) then                                  //ifpart
            Result := lu_r[Low(lu_r) + 1]                                       //truepart
          else
            Result := lu_r[Low(lu_r) + 2];                                      //falsepart
        end;
    end;
end;                                                                            {of xIf}

{---------------------------------------------------------}

function TNxFormulaParser.mInt(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := Int(r);
end;                                                                            {of xInt}

{---------------------------------------------------------}

function TNxFormulaParser.mIor(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
var
  r                             : REAL;
  i                             : INTEGER;
begin
  r := 0;

  for i := Low(lu_r) to High(lu_r) do
    if (lu_r[i] <> tfp_false) and
      (lu_r[i] <> tfp_true) then
      begin
        if (context.ernr = tfp_ok) then
          context.Seternr(13);
      end;

  if (context.ernr = tfp_ok) and
    (Length(lu_r) > 0) then
    begin
      r := tfp_true * Ord(lu_r[Low(lu_r)] = tfp_true);
      for i := Low(lu_r) + 1 to High(lu_r) do
        r := tfp_true * Ord((r = tfp_true) or (lu_r[i] = tfp_true))
    end
  else
    context.Seternr(14);

  if context.ernr = tfp_ok then
    Result := r
  else
    Result := Tfp_false;
end;                                                                            {of xIor}

{---------------------------------------------------------}
{----String Functions                                     }
{---------------------------------------------------------}

function TNxFormulaParser.mLength(var context: TNxFormulaParser; var s: string): Extended;
begin
  Result := Length(s);
end;                                                                            {xLength}

{---------------------------------------------------------}

function TNxFormulaParser.mLn(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (r > 0) then
    Result := Ln(r)
  else
    context.Seternr(7);
end;                                                                            {of xLn}

{---------------------------------------------------------}

function TNxFormulaParser.mLog(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (r > 0) then
    Result := Ln(r) / ln(10)
  else
    context.Seternr(7);
end;                                                                            {of xLog}

{---------------------------------------------------------}

function TNxFormulaParser.mMax(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
var
  i                             : INTEGER;
begin
  Result := lu_r[Low(lu_r)];
  for i := Low(lu_r) + 1 to High(lu_r) do
    if (lu_r[i] > Result) then
      Result := lu_r[i];
end;                                                                            {of xMax}

{---------------------------------------------------------}

function TNxFormulaParser.mMean(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
begin
  Result := 0;

  Context.Seternr(32);
end;                                                                            {of xMean}

{---------------------------------------------------------}

function TNxFormulaParser.mMin(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
var
  i                             : INTEGER;
begin
  Result := lu_r[Low(lu_r)];
  for i := Low(lu_r) + 1 to High(lu_r) do
    if (lu_r[i] < Result) then
      Result := lu_r[i];
end;                                                                            {of xMin}

{---------------------------------------------------------}

function TNxFormulaParser.mNot(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := tfp_false;
  if ((r <> tfp_false) and (r <> tfp_true)) then
    begin
      if (context.ernr = tfp_ok) then
        context.Seternr(13);
    end
  else
    Result := tfp_true * Ord(not (r = tfp_true));
end;                                                                            {of xNOT}

{---------------------------------------------------------}

function TNxFormulaParser.mPi(var context: TNxFormulaParser): Extended;
begin
  Result := Pi;
end;                                                                            {of xPi}

{---------------------------------------------------------}

function TNxFormulaParser.mRad(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := (r / 180) * Pi;
end;                                                                            {of xRad}

{---------------------------------------------------------}

function TNxFormulaParser.mRand(var context: TNxFormulaParser): Extended;
begin
  Result := Random;
end;                                                                            {of xRand}

{---------------------------------------------------------}

function TNxFormulaParser.mRnd(var context: TNxFormulaParser; var r: Extended): Extended;
var
  i, e                          : Integer;
begin
  Result := 0;
  Val(FloatToStr(r), i, e);
  if (e > 0) then
    context.SetErnr(37)
  else
    Result := Random(i);
end;                                                                            {of xRand}

{---------------------------------------------------------}

function TNxFormulaParser.mRound(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  if (Abs(r) < tfp_maxlongint) then
    Result := Tfp_round(r)
  else
    Result := r;
end;                                                                            {of xRound}

{---------------------------------------------------------}

function TNxFormulaParser.mSec(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Int(2 * r / pi) = 2 * r / pi) then
    context.Seternr(18)
  else
    Result := 1 / Cos(r);
end;                                                                            {xSec}

{---------------------------------------------------------}

function TNxFormulaParser.mSech(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > Ln(tfp_maxreal)) then
    context.Seternr(20)
  else
    Result := 2 / (Exp(r) + Exp(-r));
end;                                                                            {of xSech}

{---------------------------------------------------------}

function TNxFormulaParser.mSgn(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  if (r >= 0) then
    Result := +1
  else
    Result := -1;
end;                                                                            {of xSgn}

{---------------------------------------------------------}

function TNxFormulaParser.mSin(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := Sin(r);
end;                                                                            {of xSin}

{---------------------------------------------------------}

function TNxFormulaParser.mSinh(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > Ln(tfp_maxreal)) then
    context.Seternr(20)
  else
    Result := (Exp(r) - Exp(-r)) / 2;
end;                                                                            {of xSinh}

{---------------------------------------------------------}

function TNxFormulaParser.mSqr(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > 0) then
    begin
      if (Abs(2 * Ln(Abs(r)))) < Ln(tfp_maxreal) then
        Result := Exp(2 * Ln(Abs(r)))
      else
        context.Seternr(11);
    end;
end;                                                                            {of xSqr}

{---------------------------------------------------------}

function TNxFormulaParser.mSqrt(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (r >= 0) then
    Result := Sqrt(r)
  else
    context.Seternr(8);
end;                                                                            {of xSqrt}

{---------------------------------------------------------}

function TNxFormulaParser.mStd(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
var
  i                             : INTEGER;
begin
  Result := 0;

  for i := Low(lu_r) to High(lu_r) do
    Result := Result + mSqr(context, lu_r[i]);

  if (Length(lu_r) > 1) then
    Result := SQRT(Result - SQR(mAvg(context, lu_r) / Length(lu_r)) / (Length(lu_r) - 1))
  else
    Context.Seternr(29);
end;

{---------------------------------------------------------}

function TNxFormulaParser.mStdDev(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
begin
  Result:=mStd(context, lu_r);
end;                                                                            {of xStd}

{---------------------------------------------------------}

function TNxFormulaParser.mStrComp(var context: TNxFormulaParser; var s1, s2: string): Extended;
begin
  if (s1 = s2) then
    Result := tfp_true
  else
    Result := tfp_false;
end;                                                                            {of xStrComp}

{---------------------------------------------------------}

function TNxFormulaParser.mSum(var context: TNxFormulaParser; var lu_r: array of Extended): Extended;
var
  i                             : INTEGER;
  value,
    dummy                       : Extended;
begin
  value := 0;
  for i := Low(lu_r) to High(lu_r) do
    begin
      dummy := lu_r[i];
      {----Overflow Protected}
      if (Abs((value / 10) + (dummy / 10)) < (tfp_maxreal / 10)) then
        value := value + dummy
      else
        context.Seternr(11);
    end;
  Result := value;
end;                                                                            {of xSum}

{---------------------------------------------------------}

function TNxFormulaParser.mTan(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Int(2 * r / pi) = 2 * r / pi) then
    context.Seternr(5)
  else
    Result := Sin(r) / cos(r);
end;                                                                            {of xTan}

{---------------------------------------------------------}

function TNxFormulaParser.mTanh(var context: TNxFormulaParser; var r: Extended): Extended;
begin
  Result := 0;
  if (Abs(r) > Ln(tfp_maxreal)) then
    context.Seternr(20)
  else
    Result := (Exp(r) - Exp(-r)) / (Exp(r) + Exp(-r));
end;                                                                            {of xTanh}

{---------------------------------------------------------}

function TNxFormulaParser.mTrue(var context: TNxFormulaParser): Extended;
begin
  Result := tfp_true;
end;                                                                            {of xTrue}

{---------------------------------------------------------}

function TNxFormulaParser.mXor(var context: TNxFormulaParser; var r1, r2: Extended): Extended;
begin
  Result := tfp_false;
  if ((r1 <> tfp_false) and (r1 <> tfp_true)) or
    ((r2 <> tfp_false) and (r2 <> tfp_true)) then
    begin
      if (context.ernr = tfp_ok) then
        context.Seternr(13);
    end
  else
    Result := tfp_true * Ord((r1 = tfp_true) xor (r2 = tfp_true));
end;                                                                            {of xXOR}

{---------------------------------------------------------}

procedure TNxFormulaParser.SetBoolDummy(const Value: Boolean);
begin
  //Dummy
end;

{---------------------------------------------------------}

procedure TNxFormulaParser.SetErMsgDummy(const Value: string);
begin
  //Dummy
end;

{---------------------------------------------------------}
{----This routine set the ernr if not set already         }
{---------------------------------------------------------}

procedure TNxFormulaParser.Seternr(Value: INTEGER);
begin
  if (Fernr = tfp_ok) then
    Fernr := Value;
end;                                                                            {of Seternr}

{---------------------------------------------------------}

procedure TNxFormulaParser.SetErnrDummy(const Value: Integer);
begin
  //
end;

{---------------------------------------------------------}

procedure TNxFormulaParser.SetErrorMessage(Index: Integer;
  const Value: string);
begin
  if (Ferrmsgs.Values[Format('%d', [Index])] = '') then
    Ferrmsgs.Add(Format('%d=%s', [Index, Value]))
  else
    Ferrmsgs.Values[Format('%d', [Index])] := Value;
end;

{---------------------------------------------------------}

procedure TNxFormulaParser.SetExpression(const Value: string);
begin
  FExpression := Value;
end;

{---------------------------------------------------------}

procedure TNxFormulaParser.SetRealDummy(const Value: Extended);
begin
  //Dummy
end;

{---------------------------------------------------------}

procedure TNxFormulaParser.Tfp_AddInternals;
begin
  //Global error messages
  Addermsg(00, SResultOk);                                                      {Error 00}
  Addermsg(01, SInvalidFormatOfANumber);                                        {Error 01}
  Addermsg(02, SUnkownFunction);                                                {Error 02}
  Addermsg(03, SMismatch);                                                      {Error 03}
  Addermsg(04, SRealExponentComplexNumber);                                     {Error 04}
  Addermsg(06, SEmptyString);                                                   {Error 06}
  Addermsg(09, SDivideByZero);                                                  {Error 09}
  Addermsg(10, SToManyFunctionOrConstants);                                     {Error 10}
  Addermsg(11, SIntermediateResultOutOfRange);                                  {Error 11}
  Addermsg(12, SIllegalCharactersInFunctionname);                               {Error 12}
  Addermsg(14, SWrongNumberOfParameters);                                       {Error 14}
  //Addermsg(15, SMemoryProblems);                                              {Error 15} //Obsoleted
  //Addermsg(16, SNotEnoughObjectsOrConstants);                                 {Error 16} //Obsoleted
  //New error messages for Delphi port...
  Addermsg(30, SFunctionAlreadyAdded);                                          {Error 30}
  //Addermsg(31,'Errormessage already added');                                  {Error 31} //obsoleted
  Addermsg(32, SFunctionNotFullyImplementedYet);                                {Error 32}
  Addermsg(33, SMissingStringQuote);                                            {Error 33}
  Addermsg(34, SMatchingEndStringQuoteNotFound);                                {Error 34}

  Addobject(Self, 'ARCTAN', tfp_m_1real);
  Addobject(Self, 'COS', tfp_m_1real);
  Addobject(Self, 'DEG', tfp_m_1real);
  Addobject(Self, 'PI', tfp_m_noparm);
  Addobject(Self, 'RAD', tfp_m_1real);
  Addobject(Self, 'SIN', tfp_m_1real);
  Addobject(Self, 'TAN', tfp_m_1real);
  Addermsg(05, STAN2n1PI2NotDefined);                                           {Error 05}

  Addobject(Self, 'AND', tfp_m_nreal);
  Addobject(Self, 'FALSE', tfp_m_noparm);
  Addobject(Self, 'OR', tfp_m_nreal);
  Addobject(Self, 'TRUE', tfp_m_noparm);
  Addobject(Self, 'XOR', tfp_m_2real);
  Addobject(Self, 'NOT', tfp_m_1real);
  Addermsg(13, SNotABooleanExpression);                                         {Error 13}

  Addobject(Self, 'EXP', tfp_m_1real);
  Addobject(Self, 'E', tfp_m_noparm);
  Addobject(Self, 'LN', tfp_m_1real);
  Addobject(Self, 'LOG', tfp_m_1real);
  Addermsg(07, SLNXOrLOGXForX0ComplexNumber);                                   {Error 07}
  Addobject(Self, 'SQR', tfp_m_1real);
  Addobject(Self, 'SQRT', tfp_m_1real);
  Addermsg(08, SSQRTXForX0ComplexNumber);                                       {Error 08}

  Addobject(Self, 'ABS', tfp_m_1real);
  Addobject(Self, 'FRAC', tfp_m_1real);
  Addobject(Self, 'INT', tfp_m_1real);
  Addobject(Self, 'MAX', tfp_m_nreal);
  Addobject(Self, 'MIN', tfp_m_nreal);
  Addobject(Self, 'ROUND', tfp_m_1real);
  Addobject(Self, 'SGN', tfp_m_1real);

  Addobject(Self, 'CSC', tfp_m_1real);
  Addobject(Self, 'SEC', tfp_m_1real);
  Addobject(Self, 'COT', tfp_m_1real);
  Addermsg(17, SCscNPINotDefined);                                              {Error 17}
  Addermsg(18, SSec2n1PI2NotDefined);                                           {Error 18}
  Addermsg(19, SCotNPINotDefined);                                              {Error 19}

  Addobject(Self, 'SINH', tfp_m_1real);
  Addobject(Self, 'COSH', tfp_m_1real);
  Addobject(Self, 'TANH', tfp_m_1real);
  Addermsg(20, SParameterToLarge);                                              {Error 20}

  Addobject(Self, 'CSCH', tfp_m_1real);
  Addobject(Self, 'SECH', tfp_m_1real);
  Addobject(Self, 'COTH', tfp_m_1real);
  Addermsg(21, SCsch0NotDefined);                                               {Error 21}
  Addermsg(22, SCoth0NotDefined);                                               {Error 22}

  Addobject(Self, 'ARCSINH', tfp_m_1real);
  Addobject(Self, 'ARCCOSH', tfp_m_1real);
  Addobject(Self, 'ARCTANH', tfp_m_1real);
  Addermsg(23, SArcCoshXNotDefinedForX1);                                       {Error 23}
  Addermsg(24, SArcTanhXNotDefinedForAbsX1);                                    {Error 24}

  Addobject(Self, 'ARCCSCH', tfp_m_1real);
  Addobject(Self, 'ARCSECH', tfp_m_1real);
  Addobject(Self, 'ARCCOTH', tfp_m_1real);
  Addermsg(25, SArccsch0NotDefined);                                            {Error 25}
  Addermsg(26, SArcsechXNotDefinedForX0OrX1);                                   {Error 26}
  Addermsg(27, SArccothXNotDefinedForAbsX1);                                    {Error 27}

  Addobject(Self, 'AVG', tfp_m_nreal);
  Addobject(Self, 'AVGERAGE', tfp_m_nreal); // AVG Alias
  Addobject(Self, 'STD', tfp_m_nreal);
  Addobject(Self, 'STDEV', tfp_m_nreal); // STD Alias
  Addobject(Self, 'MEAN', tfp_m_nreal);
  Addobject(Self, 'SUM', tfp_m_nreal);
  Addobject(Self, 'RAND', tfp_m_noparm);
  Addobject(Self, 'RND', tfp_m_1real);
  Addermsg(28, SAverageNotDefinedForZeroItems);                                 {Error 28}
  Addermsg(29, SStandardDeviationNotDefinedForLe);                              {Error 29}
  Addermsg(37, SRNDRangeToLarge);                                               {Error 37}

  Addobject(Self, 'LENGTH', tfp_m_1str);
  Addobject(Self, 'STRCOMP', tfp_m_2str);

  Addobject(Self, 'IF', tfp_m_nreal);
  Addermsg(35, SIfNeedsExact3Parameters);                                       {Error 35}
  Addermsg(36, SIfConditionsNeedsToBeBoolean);                                  {Error 36}

  Addermsg(38, SFunctionNotFound);                                              {Error 38}
  Addermsg(39, SObjectNotFound);                                                {Error 39}

  //Error 40 is next


end;                                                                            {of Tfp_addall}

{---------------------------------------------------------}
{----This Routine does some trivial check.                }
{---------------------------------------------------------}

procedure TNxFormulaParser.Tfp_check(s: string);
var
  i, j                          : INTEGER;
begin
  with Fstate[High(Fstate)] do
    begin
      lp := 0;

      {----Test for match on numbers of ( and ) }
      j := 0;
      for i := 1 to Length(s) do
        case s[i] of
          '(': Inc(j);
          ')': Dec(j);
        end;

      if (j = 0) then
        {----Continue init}
        begin
          {----Add a CHR(0) as an EOLN marker}
          line := s + #00;
          Tfp_skip;

          {----Try parsing if any characters left}
          if (line[lp] = #00) then
            Seternr(6);
        end
      else
        Seternr(3);
    end;
end;                                                                            {of Tfp_Check}

{---------------------------------------------------------}
{  Boolean Expr  = R_Expr <  R_Expr                       }
{                  R_Expr <= R_Expr                       }
{                  R_Expr <> R_Expr                       }
{                  R_Expr =  R_Expr                       }
{                  R_Expr >= R_Expr                       }
{                  R_Expr >  R_Expr                       }
{---------------------------------------------------------}

function TNxFormulaParser.Tfp_eval_b_expr: Extended;
var
  tmpval,
    value                       : Extended;
begin
  with Fstate[High(Fstate)] do
    begin
      value := Tfp_eval_r_expr;

      //veg:added & + |
      if (ernr = tfp_ok) and (nextchar in ['<', '>', '=', '&', '|']) then
        case nextchar of

          '<':
            begin
              Tfp_skip;
              if (nextchar in ['>', '=']) then
                case nextchar of
                  '>':
                    begin
                      Tfp_skip;
                      if (value <> Tfp_eval_r_expr) then
                        value := tfp_true
                      else
                        value := tfp_false;
                    end;

                  '=':
                    begin
                      Tfp_skip;
                      if (value <= Tfp_eval_r_expr) then
                        value := tfp_true
                      else
                        value := tfp_false;
                    end;
                end
              else
                begin
                  if (value < Tfp_eval_r_expr) then
                    value := tfp_true
                  else
                    value := tfp_false;
                end;
            end;

          '>':
            begin
              Tfp_skip;
              if (nextchar = '=') then
                begin
                  Tfp_skip;
                  if (value >= Tfp_eval_r_expr) then
                    value := tfp_true
                  else
                    value := tfp_false;
                end
              else
                begin
                  if (value > Tfp_eval_r_expr) then
                    value := tfp_true
                  else
                    value := tfp_false;
                end;
            end;

          '=':
            begin
              Tfp_skip;
              if (value = Tfp_eval_r_expr) then
                value := tfp_true
              else
                value := tfp_false;
            end;

          //veg:added & + |
          //veg:beware of short circuit evaluation here...
          '&':
            begin
              Tfp_skip;
              tmpval := Tfp_eval_b_expr;

              if ((value <> tfp_true) and (value <> tfp_false)) or
                ((tmpval <> tfp_true) and (tmpval <> tfp_false)) then
                Seternr(13)
              else if ((tmpval = tfp_true) and (value = tfp_true)) then
                value := tfp_true
              else
                value := tfp_false;
            end;

          //veg:added & + |
          //veg:beware of short circuit evaluation here...
          '|':
            begin
              Tfp_skip;
              tmpval := Tfp_eval_b_expr;
              if ((value <> tfp_true) and (value <> tfp_false)) or
                ((tmpval <> tfp_true) and (tmpval <> tfp_false)) then
                Seternr(13)
              else if ((tmpval = tfp_true) or (value = tfp_true)) then
                value := tfp_true
              else
                value := tfp_false;
            end;
        end;
    end;

  if (ernr = tfp_ok) then
    Tfp_eval_b_expr := value
  else
    Tfp_eval_b_expr := 0.0;
end;                                                                            {of Tfp_Eval_B_Expr}

{---------------------------------------------------------}
{  Factor     = Number                                    }
{    (External) Function()                                }
{    (External) Function(Expr)                            }
{    (External) Function(Expr,Expr)                       }
{     External  Var Real                                  }
{     External  Var Integer                               }
{     External  Var Boolean                               }
{     External  Var realstring                            }
{               (R_Expr)                                  }
{---------------------------------------------------------}

function TNxFormulaParser.Tfp_eval_factor: Extended;
var
  ferr                          : Boolean;
  quote                         : Char;
  value                         : Extended;
  rarg1                         : Extended;
  rarg2                         : Extended;
  rargs                         : array of Extended;
  sarg1                         : string;
  sarg2                         : string;
  sargs                         : array of string;
  sexpr                         : string;
  function_name                 : string;
  aMethod                       : TMethod;
  aNdx                          : Integer;
  aTyp                          : integer;
  aNam                          : string;
  aObj                          : TObject;
begin
  value := 0;
  quote := #0;

  //beware we can extend/shrink Fstate,
  //so 'with Fstate[High(Fstate)] do' turned oout to dangerous here...
  case Fstate[High(Fstate)].nextchar of
    '+':
      begin
        Tfp_newchar;
        value := +Tfp_eval_factor;
      end;

    '-':
      begin
        Tfp_newchar;
        value := -Tfp_eval_factor;
      end;

    '0'..
      '9',
      '.': value := Tfp_eval_number;

    'A'..
      'Z':
      begin
        ferr := True;
        function_name := Fstate[High(Fstate)].nextchar;
        Tfp_skip;
        while Fstate[High(Fstate)].nextchar in ['0'..'9', '_', 'A'..'Z'] do
          begin
            function_name := function_name + Fstate[High(Fstate)].nextchar;
            Tfp_skip;
          end;

{$R-}
{----Seek function and CALL it}
        aNdx := FObjects.IndexOfName(function_name);
        if (aNdx = -1) then
          Seternr(38);                                                          //Function not found

        if (Ernr = tfp_ok) then
          begin
            Ferr := False;

            aTyp := StrToInt(FObjects.Values[function_name]);
            aNam := FObjects.Names[aNdx];
            aObj := Fobjects.Objects[aNdx];

            case Ftype(aTyp) of

              {----Function or Function()}
              tfp_m_noparm: if (Fstate[High(Fstate)].nextchar = '(') then
                  begin
                    Tfp_skip;

                    if (Fstate[High(Fstate)].nextchar <> ')') then
                      Seternr(14);

                    Tfp_skip;
                  end;

              {----Function(r)}
              tfp_m_1real: if (Fstate[High(Fstate)].nextchar = '(') then
                  begin
                    Tfp_skip;

                    rarg1 := Tfp_eval_b_expr;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ')') then
                      Seternr(14);

                    Tfp_skip;                                                   {----Dump the ')'}
                  end
                else
                  Seternr(14);

              {----Function(r1,r2)}
              tfp_m_2real: if (Fstate[High(Fstate)].nextchar = '(') then
                  begin
                    Tfp_skip;

                    rarg1 := Tfp_eval_b_expr;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ',') then
                      Seternr(14);

                    Tfp_skip;                                                   {----Dump the ','}
                    rarg2 := Tfp_eval_b_expr;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ')') then
                      Seternr(14);

                    Tfp_skip;                                                   {----Dump the ')'}
                  end
                else
                  Seternr(14);

              {----Function(r,n)}
              tfp_m_nreal: if (Fstate[High(Fstate)].nextchar = '(') then
                  begin
                    Tfp_skip;

                    //extend open array by 1
                    SetLength(rargs, Length(rargs) + 1);
                    rargs[High(rargs)] := Tfp_eval_b_expr;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ',') then
                      Seternr(14)
                    else
                      while (ernr = tfp_ok) and
                        (Fstate[High(Fstate)].nextchar = ',') do
                        begin
                          Tfp_skip;                                             {----Dump the ','}
                          //extend open array by 1
                          SetLength(rargs, Length(rargs) + 1);
                          rargs[High(rargs)] := Tfp_eval_b_expr;
                        end;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ')') then
                      Seternr(14);

                    Tfp_skip;                                                   {----Dump the ')'}
                  end
                else
                  Seternr(14);

              {----Real Var}
              tfp_realvar: rarg1 := Extended(GetPropValue(aObj, 'm' + Fobjects.Names[aNdx], False)); //Get the Value through RTTI

              {----Integer Var}
              tfp_intvar: rarg1 := 1.0 * Integer(GetPropValue(aObj, 'm' + Fobjects.Names[aNdx], False)); //Get the Value through RTTI

              {----Boolean Var}
              tfp_boolvar: rarg1 := 1.0 * Ord(Boolean(GetPropValue(aObj, 'm' + Fobjects.Names[aNdx], False))); //Get the Value through RTTI

              {----Real string Var}
              tfp_strvar:                                                       //Get the Value through RTTI and Evaluate it!
                begin
                  sexpr := string(GetPropValue(aObj, 'm' + Fobjects.Names[aNdx], True));

                  SetLength(FState, Length(FState) + 1);

                  Tfp_check(sexpr);
                  rarg1 := Tfp_eval_b_expr;

                  FState := Copy(FState, Low(FState), High(FState));
                end;

              {----Function(s)}
              tfp_m_1str: if (Fstate[High(Fstate)].nextchar = '(') then
                  begin
                    Tfp_skip;

                    if not (Fstate[High(Fstate)].nextchar in [Chr(39), '"']) then
                      Seternr(33)
                    else
                      begin
                        quote := Fstate[High(Fstate)].nextchar;
                        Tfp_skip;
                      end;

                    if (ernr = tfp_ok) then
                      while (Fstate[High(Fstate)].nextchar <> quote) do
                        begin
                          sarg1 := sarg1 + Fstate[High(Fstate)].nextchar;
                          Tfp_skip;
                        end;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> quote) then
                      Seternr(34)
                    else
                      Tfp_skip;

                    Tfp_skip;                                                   {----Dump the ')'}
                  end;

              {----Function(s1,s2)}
              tfp_m_2str: if (Fstate[High(Fstate)].nextchar = '(') then
                  begin
                    Tfp_skip;

                    if not (Fstate[High(Fstate)].nextchar in [Chr(39), '"']) then
                      Seternr(33)
                    else
                      begin
                        quote := Fstate[High(Fstate)].nextchar;
                        Tfp_skip;
                      end;

                    if (ernr = tfp_ok) then
                      while (Fstate[High(Fstate)].nextchar <> quote) do
                        begin
                          sarg1 := sarg1 + Fstate[High(Fstate)].nextchar;
                          Tfp_skip;
                        end;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> quote) then
                      Seternr(34)
                    else
                      Tfp_skip;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ',') then
                      Seternr(14)
                    else
                      Tfp_skip;                                                 {----Dump the ','}

                    if not (Fstate[High(Fstate)].nextchar in [Chr(39), '"']) then
                      Seternr(33)
                    else
                      begin
                        quote := Fstate[High(Fstate)].nextchar;
                        Tfp_skip;
                      end;

                    if (ernr = tfp_ok) then
                      while (Fstate[High(Fstate)].nextchar <> quote) do
                        begin
                          sarg2 := sarg2 + Fstate[High(Fstate)].nextchar;
                          Tfp_skip;
                        end;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> quote) then
                      Seternr(34)
                    else
                      Tfp_skip;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ')') then
                      Seternr(14);

                    Tfp_skip;                                                   {----Dump the ')'}
                  end
                else
                  Seternr(14);

              {----Function(s,n)}
              tfp_m_nstr: if (Fstate[High(Fstate)].nextchar = '(') then
                  begin
                    Tfp_skip;

                    //extend open array by 1
                    SetLength(sargs, Length(sargs) + 1);
                    if not (Fstate[High(Fstate)].nextchar in [Chr(39), '"']) then
                      Seternr(33)
                    else
                      begin
                        quote := Fstate[High(Fstate)].nextchar;
                        Tfp_skip;
                      end;

                    if (ernr = tfp_ok) then
                      while (Fstate[High(Fstate)].nextchar <> quote) do
                        begin
                          sargs[High(sargs)] := sargs[High(sargs)] + Fstate[High(Fstate)].nextchar;
                          Tfp_skip;
                        end;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> quote) then
                      Seternr(34)
                    else
                      Tfp_skip;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ',') then
                      Seternr(14)
                    else
                      while (ernr = tfp_ok) and
                        (Fstate[High(Fstate)].nextchar = ',') do
                        begin
                          Tfp_skip;                                             {----Dump the ','}
                          //extend open array by 1
                          SetLength(sargs, Length(sargs) + 1);

                          if not (Fstate[High(Fstate)].nextchar in [Chr(39), '"']) then
                            Seternr(33)
                          else
                            begin
                              quote := Fstate[High(Fstate)].nextchar;
                              Tfp_skip;
                            end;

                          if (ernr = tfp_ok) then
                            while (Fstate[High(Fstate)].nextchar <> quote) do
                              begin
                                sargs[High(sargs)] := sargs[High(sargs)] + Fstate[High(Fstate)].nextchar;
                                Tfp_skip;
                              end;

                          if (ernr = tfp_ok) and
                            (Fstate[High(Fstate)].nextchar <> quote) then
                            Seternr(34)
                          else
                            Tfp_skip;
                        end;

                    if (ernr = tfp_ok) and
                      (Fstate[High(Fstate)].nextchar <> ')') then
                      Seternr(14);

                    Tfp_skip;                                                   {----Dump the ')'}
                  end
                else
                  Seternr(14);
            end;

            if not Assigned(aObj) then
              Seternr(39);                                                      //object not found

            //For Methods: load the TMethod with the appropriate values.
            if (ernr = tfp_ok) then
              begin
                case Ftype(aTyp) of
                  tfp_m_noparm,
                    tfp_m_1real,
                    tfp_m_2real,
                    tfp_m_nreal,
                    tfp_m_1str,
                    tfp_m_2str,
                    tfp_m_nstr:
                    begin
                      aMethod.Code := aObj.MethodAddress('m' + function_name);  //Returns the address of a published method.
                      if (aMethod.Code = nil) then
                        Seternr(38)                                             //Function not found
                      else
                        begin
                          aMethod.Data := aObj;                                 //Was Pointer(Instance);
                        end;
                    end
                  else
                    Seternr(38)                                                 //Function not found
                end
              end;

            //Finally Fetch the value, either by TMethod Call or RTTI.
            if (ernr = tfp_ok) then
              case Ftype(aTyp) of
                tfp_m_noparm: value := TFunction_no_parm(aMethod)(self);
                tfp_m_1real: value := TFunction_1_real(aMethod)(self, rarg1);
                tfp_m_2real: value := TFunction_2_real(aMethod)(self, rarg1, rarg2);
                tfp_m_nreal:
                  begin
                    value := TFunction_n_real(aMethod)(self, rargs);
                    //cleanup open array.
                    rargs := nil;
                  end;
                tfp_realvar,
                  tfp_intvar,
                  tfp_boolvar,
                  tfp_strvar: value := rarg1;                                   //We got the variable value already.
                tfp_m_1str: value := TFunction_1_str(aMethod)(self, sarg1);
                tfp_m_2str: value := TFunction_2_str(aMethod)(self, sarg1, sarg2);
                tfp_m_nStr:
                  begin
                    value := TFunction_n_str(aMethod)(self, sargs);
                    //cleanup open array.
                    sargs := nil;
                  end;
              end;
          end;
{$R+}

        if (ferr = True) then
          Seternr(2);
      end;

    '(':
      begin
        Tfp_skip;

        value := Tfp_eval_b_expr;

        if (ernr = tfp_ok) and
          (Fstate[High(Fstate)].nextchar <> ')') then
          Seternr(3);

        Tfp_skip;                                                               {----Dump the ')'}
      end;

    else
      Seternr(2);
  end;

  if (ernr = tfp_ok) then
    Tfp_eval_factor := value
  else
    Tfp_eval_factor := 0;

end;

{---------------------------------------------------------}
{  Number     = Real    (Bv 23.4E-5)                      }
{               Integer (Bv -45)                          }
{---------------------------------------------------------}

function TNxFormulaParser.Tfp_eval_number: Extended;
var
  temp                          : string;
  err                           : INTEGER;
  value                         : Extended;
begin
  with Fstate[High(Fstate)] do
    begin
      {----Correct .xx to 0.xx}
      if (nextchar = '.') then
        temp := '0' + nextchar
      else
        temp := nextchar;

      Tfp_newchar;

      {----Correct ñ.xx to ñ0.xx}
      if (Length(temp) = 1) and
        (temp[1] in ['+', '-']) and
        (nextchar = '.') then
        temp := temp + '0';

      while nextchar in ['0'..'9', '.', 'E'] do
        begin
          temp := temp + nextchar;
          if (nextchar = 'E') then
            begin
              {----Correct ñxxx.E to ñxxx.0E}
              if (temp[Length(temp) - 1] = '.') then
                Insert('0', temp, Length(temp));
              Tfp_newchar;
              if (nextchar in ['+', '-']) then
                begin
                  temp := temp + nextchar;
                  Tfp_newchar;
                end;
            end
          else
            Tfp_newchar;
        end;

      {----Skip trailing spaces}
      if (nextchar = ' ') then
        Tfp_skip;

      {----Correct ñxx. to ñxx.0 but NOT ñxxEñyy.}
      if (temp[Length(temp)] = '.') and
      (Pos('E', temp) = 0) then
        temp := temp + '0';

      Val(temp, value, err);

      if (err <> 0) then
        Seternr(1);
    end;

  if (ernr = tfp_ok) then
    Tfp_eval_number := value
  else
    Tfp_eval_number := 0;

end;                                                                            {of Tfp_Eval_Number}

{---------------------------------------------------------}
{  Real Expr  = Subterm + Subterm                         }
{               Subterm - Subterm                         }
{---------------------------------------------------------}

function TNxFormulaParser.Tfp_eval_r_expr: Extended;
var
  dummy,
    dummy2,
    value                       : Extended;
begin
  with Fstate[High(Fstate)] do
    begin
      value := Tfp_eval_subterm;

      while (ernr = tfp_ok) and (nextchar in ['+', '-']) do
        case nextchar of

          '+':
            begin
              Tfp_skip;

              dummy := Tfp_eval_subterm;

              if (ernr = tfp_ok) then
                begin

                  {----Overflow Protected}
                  if (Abs((value / 10) + (dummy / 10)) < (tfp_maxreal / 10)) then
                    value := value + dummy
                  else
                    Seternr(11);
                end;
            end;

          '-':
            begin
              Tfp_skip;
              dummy2 := value;

              dummy := Tfp_eval_subterm;

              if (ernr = tfp_ok) then
                begin

                  {----Overflow Protected}
                  if (Abs((value / 10) - (dummy / 10)) < (tfp_maxreal / 10)) then
                    value := value - dummy
                  else
                    Seternr(11);

                  {----Underflow Protected}
                  if (value = tfp_ok) and (dummy <> dummy2) then
                    Seternr(11);
                end;
            end;
        end;

      {----at this point the current char must be }
      {       1. the eoln marker or               }
      {       2. a right bracket                  }
      {       3. start of a boolean operator      }

    end;

  with Fstate[High(Fstate)] do
    //veg:added & + |
    if not (nextchar in [#00, ')', '>', '<', '=', ',', '&', '|']) then
      Seternr(2);

  if (ernr = tfp_ok) then
    Tfp_eval_r_expr := value
  else
    Tfp_eval_r_expr := 0;
end;                                                                            {of Tfp_Eval_R_Expr}

{---------------------------------------------------------}
{----Subterm  = Term * Term                               }
{               Term / Term                               }
{---------------------------------------------------------}

function TNxFormulaParser.Tfp_eval_subterm: Extended;
var
  value,
    dummy                       : Extended;
begin
  with Fstate[High(Fstate)] do
    begin
      value := Tfp_eval_term;

      while (ernr = tfp_ok) and (nextchar in ['*', '/']) do
        case nextchar of

          {----Over/Underflow Protected}
          '*':
            begin
              Tfp_skip;

              dummy := Tfp_eval_term;

              if (ernr <> 0) or
                (value = 0) or
                (dummy = 0) then
                value := 0
              else if (Abs(Ln(Abs(value)) +
                Ln(Abs(dummy))) < Ln(tfp_maxreal)) then
                value := value * dummy
              else
                Seternr(11);
            end;

          {----Over/Underflow Protected}
          '/':
            begin
              Tfp_skip;

              dummy := Tfp_eval_term;

              if (ernr = tfp_ok) then
                begin

                  {----Division by ZERO Protected}
                  if (dummy <> 0) then
                    begin

                      {----Underflow Protected}
                      if (value <> 0) then
                        begin
                          if (Abs(Ln(Abs(value)) -
                            Ln(Abs(dummy))) < Ln(tfp_maxreal)) then
                            value := value / dummy
                          else
                            Seternr(11)
                        end
                      else
                        value := 0;
                    end
                  else
                    Seternr(9);
                end;
            end;
        end;
    end;

  if (ernr = tfp_ok)
    then
    Tfp_eval_subterm := value
  else
    Tfp_eval_subterm := 0;
end;                                                                            {of Tfp_Eval_subterm}

{---------------------------------------------------------}
{  Term       = Factor ^ Factor                           }
{---------------------------------------------------------}

function TNxFormulaParser.Tfp_eval_term: Extended;
var
  value,
    exponent,
    dummy,
    base                        : Extended;
begin
  with Fstate[High(Fstate)] do
    begin
      value := Tfp_eval_factor;

      while (ernr = tfp_ok) and (nextchar = '^') do
        begin
          Tfp_skip;

          exponent := Tfp_eval_factor;

          base := value;
          if (ernr = tfp_ok) and (base = 0) then
            value := 0
          else
            begin

              {----Over/Underflow Protected}
              dummy := exponent * Ln(Abs(base));
              if (dummy <= Ln(tfp_maxreal)) then
                value := Exp(dummy)
              else
                Seternr(11);
            end;

          if (ernr = tfp_ok) and (base < 0) then
            begin
              {----Allow only whole number exponents,
                   others will result in complex numbers}
              if (Int(exponent) <> exponent) then
                Seternr(4);

              if (ernr = tfp_ok) and Odd(Tfp_round(exponent)) then
                value := -value;
            end;
        end;
    end;

  if (ernr = tfp_ok) then
    Tfp_eval_term := value
  else
    Tfp_eval_term := 0;

end;                                                                            {of Tfp_Eval_term}

{---------------------------------------------------------}
{----This routine skips one character                     }
{---------------------------------------------------------}

procedure TNxFormulaParser.Tfp_newchar;
begin
  with Fstate[High(Fstate)] do
    begin
      if (lp < Length(line)) then
        Inc(lp);
      nextchar := Upcase(line[lp]);
    end;
end;                                                                            {of Tfp_Newchar}

{---------------------------------------------------------}
{----This routine skips one character and                 }
{    all folowing spaces from an expression               }
{---------------------------------------------------------}

procedure TNxFormulaParser.Tfp_skip;
begin
  with Fstate[High(Fstate)] do
    repeat
      Tfp_newchar;
    until (nextchar <> ' ');
end;                                                                            {of Tfp_Skip}

end.

