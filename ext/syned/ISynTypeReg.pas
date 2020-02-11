unit ISynTypeReg;

interface

uses
  //System.ShareMem,
  System.Classes,
  SynEditHighlighter,

  SynHighlighterPHP,

  SynHighlighterSQL, SynHighlighterHtml,
  SynHighlighterPas, SynHighlighterXML, SynHighlighterCSS,
  SynHighlighterJScript,
  SynHighlighterCpp,
  SynHighlighterEiffel,
  SynHighlighterFortran,
  SynHighlighterJava,
  SynHighlighterM3,
  SynHighlighterVB,
  SynHighlighterCobol,
  SynHighlighterCS,
  SynHighlighterVBScript,
  SynHighlighterJson,
  SynHighlighterAWK,
  SynHighlighterBAT,
  SynHighlighterDWS,
  SynHighlighterKix,
  SynHighlighterPerl,
  SynHighlighterPython,
  SynHighlighterTclTk,
  SynHighlighterGWS,
  SynHighlighterRuby,
  SynHighlighterUNIXShellScript,
  SynHighlighterCAC,
  SynHighlighterCache,
  SynHighlighterFoxpro,
  SynHighlighterSDD,
  SynHighlighterADSP21xx,
  SynHighlighterASM,
  SynHighlighterHC11,
  SynHighlighterHP48,
  SynHighlighterST,
  SynHighlighterAsmMASM,
  SynHighlighterDML,
  SynHighlighterModelica,
  SynHighlighterSML,
  SynHighlighterDFM,
  SynHighlighterINI,
  SynHighlighterInno,
  SynHighlighterBaan,
  SynHighlighterGalaxy,
  SynHighlighterProgress,
  SynHighlighterMsg,
  SynHighlighterIdl,
  SynHighlighterUnreal,
  SynHighlighterCPM,
  SynHighlighterTeX,
  SynHighlighterHaskell,
  SynHighlighterLDraw,
  SynHighlighterURI,
  SynHighlighterDOT,
  SynHighlighterRC,
  SynHighlighterVrml97,
  SynHighlighterGeneral,
  SynEdit,
  SynCompletionProposal;
function ComponentToStringProc(id: integer): string;
function StringToComponentProc(Instance: integer; Value: string): TComponent;
implementation
function ComponentToStringProc(id: integer): string;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
  s: string;
  Component: TComponent;
begin
  Component := TComponent(TObject(id));
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function StringToComponentProc(Instance: integer; Value: string): TComponent;
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
  Component: TComponent;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(TComponent(TObject(Instance)));
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;
initialization
  registerClasses([
    TSynEdit, TSynPHPSyn,
     TSynGeneralSyn, TSynCppSyn, TSynCssSyn, TSynHTMLSyn, TSynSQLSyn,
    TSynJScriptSyn, TSynXMLSyn, TSynEiffelSyn,
    //startmy
    TSynFortranSyn, TSynJavaSyn, TSynM3Syn, TSynPasSyn, TSynVBSyn, TSynCobolSyn,
    TSynCSSyn, TSynVBScriptSyn, TSynJsonSyn, TSynDWSSyn, TSynBATSyn, TSynAWKSyn,
    TSynKIXSyn, TSynPerlSyn, TSynPythonSyn, TSynGWScriptSyn, TSynRubySyn,
    TSynUNIXShellScriptSyn, TSynCACSyn, TSynCacheSyn, TSynFoxproSyn, TSynSDDSyn,
    TSynADSP21xxSyn, TSynASMSyn, TSynAsmMASMSyn, TSynHC11Syn, TSynHP48Syn,
    TSynSTSyn, TSynDMLSyn, TSynModelicaSyn, TSynDFMSyn, TSynINISyn, TSynINNOSyn,
    TSynBaanSyn, TSynGalaxySyn,
    TSynProgressSyn, TSynMSGSyn,
    TSynIDLSyn, TSynUnrealSyn, TSynCPMSyn, TSynTeXSyn, TSynHaskellSyn, TSynLDRSyn,
    TSynURISyn, TSynDotSyn, TSynRCSyn,
    //endmy
    TSynCompletionProposal, TSynHighlighterAttributes
    ]);
end.
