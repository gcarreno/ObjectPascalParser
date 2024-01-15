unit TestObjectPascalParserTokenizingTokenizerEOF;

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
, OPP.Tokenizing.Tokens
, OPP.Tokenizing.Tokenizer
;

type

  { TTestObjectPascalParserTokenizingTokenizerEOF }

  TTestObjectPascalParserTokenizingTokenizerEOF= class(TTestCase)
  private
    FTokenisingTokenizer: TTokenizingTokenizer;
    FSourceFile: TTextSourceFile;
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

uses
  OPP.Tests
;

const
  cSpace = ' ';
  cTab = #9;
  cEOLCR = #13;
  cEOLLF = #10;
  cEOLCRLF = cEOLCR + cEOLLF;
//  cAlpha = 'a';
//  cEndInstruction = ';';

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFEmpty;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(EmptyStr));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 0', 0, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFSpace;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSpace));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 1', 1, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFTab;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cTab));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 1', 1, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFSpaceTab;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSpace + cTab));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 2', 2, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFTabSpace;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cTab + cSpace));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 1', 1, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 2', 2, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFLineFeed;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cEOLLF));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOL', TokenTypeToString(ttEOL), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is LF', UnicodeString(cEOLLF), FToken.Element);
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFCarriageReturn;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cEOLCR));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOL', TokenTypeToString(ttEOL), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is CR', UnicodeString(cEOLCR), FToken.Element);
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTokenizingTokenizerEOF.TestTokenizingTokenizerEOFCarriageReturnLineFeed;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cEOLCR + cEOLLF));
  FTokenisingTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
  try
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOL', TokenTypeToString(ttEOL), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is CRLF', UnicodeString(cEOLCRLF), FToken.Element);
    FToken:= FTokenisingTokenizer.GetNextToken;
    AssertEquals('Tokenizing Tokenizer Token Error is None', TokenErrorToString(teNone), TokenErrorToString(FToken.Error));
    AssertEquals('Tokenizing Tokenizer Token Type is EOF', TokenTypeToString(ttEOF), TokenTypeToString(FToken.&Type));
    AssertEquals('Tokenizing Tokenizer Token Line is 2', 2, FToken.Line);
    AssertEquals('Tokenizing Tokenizer Token Row is 0', 0, FToken.Row);
    AssertEquals('Tokenizing Tokenizer Token Element is Empty', UnicodeString(EmptyStr), FToken.Element);
  finally
    FTokenisingTokenizer.Free;
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;



initialization

  RegisterTest(TTestObjectPascalParserTokenizingTokenizerEOF);
end.

