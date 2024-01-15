unit TestObjectPascalParserTokenizingTokenizer;

{$I objectpascalparser.inc}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, OPP.Text.SourceFile
//, OPP.States
//, OPP.Tokenizing.Tokens
, OPP.Tokenizing.Tokenizer
;

type

  TTestObjectPascalParserTokenizingTokenizer= class(TTestCase)
  private
    FTokenisingTokenizer: TTokenizingTokenizer;
    FSourceFile: TTextSourceFile;
  published
    procedure TestTokeninzingTokenizerCreate;
  end;

implementation

uses
  OPP.Tests
;

procedure TTestObjectPascalParserTokenizingTokenizer.TestTokeninzingTokenizerCreate;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(EmptyStr));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    AssertNotNull('Tokenizing Tokenizer not null', FTokenisingTokenizer);
  finally
    FTokenisingTokenizer.Free;
    FSourceFile.Free;
  end;
end;

initialization

  RegisterTest(TTestObjectPascalParserTokenizingTokenizer);
end.

