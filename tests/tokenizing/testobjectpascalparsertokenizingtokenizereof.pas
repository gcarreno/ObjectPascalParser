unit TestObjectPascalParserTokenizingTokenizerEOF;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
//, OPP.States
, OPP.Tokenizing.Tokens
, OPP.Tokenizing.Tokenizer
;

type

  { TTestObjectPascalParserTokenizingTokenizerEOF }

  TTestObjectPascalParserTokenizingTokenizerEOF= class(TTestCase)
  private
    FTokenisingTokenizer: TTokenizingTokenizer;
    FStringStream: TStringStream;
    FToken: TToken;
  published
    procedure TestTokenizingTokenizerEOFEmpty;
    procedure TestTokenizingTokenizerEOFSpace;
    procedure TestTokenizingTokenizerEOFTab;
    procedure TestTokenizingTokenizerEOFSpaceTab;
    procedure TestTokenizingTokenizerEOFTabSpace;
    procedure TestTokenizingTokenizerEOFLineFeed;
    procedure TestTokenizingTokenizerEOFCarriageReturn;
    procedure TestTokenizingTokenizerEOFCarriageReturnLineFeed;
  end;

implementation

const
  cSpace = ' ';
  cTab = #9;
  cEOLCR = #13;
  cEOLLF = #10;
  cEOLCRLF = cEOLCR + cEOLLF;
  cAlpha = 'a';
  cEndInstruction = ';';

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFEmpty;
begin
  FStringStream:= TStringStream.Create(EmptyStr);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 0', 0, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFSpace;
begin
  FStringStream:= TStringStream.Create(cSpace);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 1', 1, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFTab;
begin
  FStringStream:= TStringStream.Create(cTab);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 1', 1, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFSpaceTab;
begin
  FStringStream:= TStringStream.Create(cSpace + cTab);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 2', 2, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFTabSpace;
begin
  FStringStream:= TStringStream.Create(cTab + cSpace);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 2', 2, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFLineFeed;
begin
  FStringStream:= TStringStream.Create(cEOLLF);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOL', TokenTypeToString(ttEOL), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is LF', cEOLLF, FToken.Element);
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFCarriageReturn;
begin
  FStringStream:= TStringStream.Create(cEOLCR);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOL', TokenTypeToString(ttEOL), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is CR', cEOLCR, FToken.Element);
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFCarriageReturnLineFeed;
begin
  FStringStream:= TStringStream.Create(cEOLCR+cEOLLF);
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FStringStream);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOL', TokenTypeToString(ttEOL), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is CRLF', cEOLCRLF, FToken.Element);
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', EmptyStr, FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    FStringStream.Free;
  end;
end;



initialization

  RegisterTest(TTestObjectPascalParserTokenizingTokenizerEOF);
end.

