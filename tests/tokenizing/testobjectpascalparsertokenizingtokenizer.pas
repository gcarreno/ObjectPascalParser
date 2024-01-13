unit TestObjectPascalParserTokenizingTokenizer;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
//, OPP.States
//, OPP.Tokenizing.Tokens
, OPP.Tokenizing.Tokenizer
;

type

  TTestObjectPascalParserTokenizingTokenizer= class(TTestCase)
  private
    FTokenisingTokenizer: TTokenizingTokenizer;
    FStringStream: TStringStream;
  published
    procedure TestTokeninzingTokenizerCreate;
  end;

implementation

procedure TTestObjectPascalParserTokenizingTokenizer.TestTokeninzingTokenizerCreate;
begin
  FStringStream:= TStringStream.Create(EmptyStr);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    AssertNotNull('Tokenizing Tokenizer not null', FTokenisingTokenizer);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

initialization

  RegisterTest(TTestObjectPascalParserTokenizingTokenizer);
end.

