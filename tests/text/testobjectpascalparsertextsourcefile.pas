unit TestObjectPascalParserTextSourceFile;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, OPP.Text
, OPP.Text.SourceFile
;

type

  { TTestObjectPascalParserTextSourceFile }

  TTestObjectPascalParserTextSourceFile= class(TTestCase)
  private
    FSourceFile: TTextSourceFile;


    procedure TestSourceFileCreateException;
  published
    procedure TestObjectPascalParserTextSourceFileCreate;
    procedure TestObjectPascalParserTextSourceFileCreateException;
    procedure TestObjectPascalParserTextSourceFileFilename;
    procedure TestObjectPascalParserTextSourceGetNextCharAnsi;
    procedure TestObjectPascalParserTextSourceGetNextCharUTF8;
    procedure TestObjectPascalParserTextSourceGetNextCharUTF16BE;
    procedure TestObjectPascalParserTextSourceGetNextCharUTF16LE;
    procedure TestObjectPascalParserTextSourceGetNextCharUTF32BE;
    procedure TestObjectPascalParserTextSourceGetNextCharUTF32LE;
    procedure TestObjectPascalParserTextSourceGetNextCharBOMUTF8;
    procedure TestObjectPascalParserTextSourceGetNextCharBOMUTF16BE;
    procedure TestObjectPascalParserTextSourceGetNextCharBOMUTF16LE;
    procedure TestObjectPascalParserTextSourceGetNextCharBOMUTF32BE;
    procedure TestObjectPascalParserTextSourceGetNextCharBOMUTF32LE;
  end;

implementation

uses
  OPP.Tests
;

const
  cSourceFileContentAnsi       = 'program';
  cSourceFileContentUTF8       = 'program Test🌟';
  cSourceFileContentUTF16BE    = #0'p'#0'r'#0'o'#0'g'#0'r'#0'a'#0'm';
  cSourceFileContentUTF16LE    = 'p'#0'r'#0'o'#0'g'#0'r'#0'a'#0'm'#0;
  cSourceFileContentUTF32BE    = #0#0#0'p'#0#0#0'r'#0#0#0'o'#0#0#0'g'#0#0#0'r'#0#0#0'a'#0#0#0'm';
  cSourceFileContentUTF32LE    = 'p'#0#0#0'r'#0#0#0'o'#0#0#0'g'#0#0#0'r'#0#0#0'a'#0#0#0'm'#0#0#0;

  cSourceFileContentBOMUTF8    = #$EF#$BB#$BF'program Test🌟';
  cSourceFileContentBOMUTF16BE = #$FE#$FF;
  cSourceFileContentBOMUTF16LE = #$FF#$FE;
  cSourceFileContentBOMUTF32BE = #$00#$00#$FE#$FF;
  cSourceFileContentBOMUTF32LE = #$00#$00#$FF#$FE;

procedure TTestObjectPascalParserTextSourceFile.TestSourceFileCreateException;
begin
  FSourceFile:= TTextSourceFile.Create('');
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceFileCreate;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(''));
  try
    AssertNotNull('Text Source File is not null', FSourceFile);
    AssertEquals('Text Source File is UTF8', TextFileTypeToString(tftUTF8), TextFileTypeToString(FSourceFile.FileType));
    AssertFalse('Text Source File Has BOM is False', FSourceFile.HasBOM);
  finally
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceFileCreateException;
begin
  FSourceFile:= nil;
  AssertException(
    'Text Source File Doesn Not Exists Exception',
    ETextSourceFileDoesNotExist,
    @TestSourceFileCreateException,
    Format(
      rsETextSourceFileDoesNotExist,
      [ '' ]
    )
  );
  if Assigned(FSourceFile) then FSourceFile.Free;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceFileFilename;
var
  tmpFilename: String;
begin
  tmpFilename:= DumpToTempFile('');
  FSourceFile:= TTextSourceFile.Create(tmpFilename);
  try
    AssertEquals('Text Source File is UTF8', TextFileTypeToString(tftUTF8), TextFileTypeToString(FSourceFile.FileType));
    AssertFalse('Text Source File Has BOM is False', FSourceFile.HasBOM);
    AssertEquals('Text Source File Filename', tmpFilename, FSourceFile.Filename);
  finally
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharAnsi;
var
  nextChar: TTextCharacter;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentAnsi));
  try
    AssertEquals('Text Source File is UTF8', TextFileTypeToString(tftUTF8), TextFileTypeToString(FSourceFile.FileType));
    AssertFalse('Text Source File Has BOM is False', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is p', 'p', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is o', 'o', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is g', 'g', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is a', 'a', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is m', 'm', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is empty', Unicodestring(EmptyStr), nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharUTF8;
var
  nextChar: TTextCharacter;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentUTF8));
  try
    AssertEquals('Text Source File is UTF8', TextFileTypeToString(tftUTF8), TextFileTypeToString(FSourceFile.FileType));
    AssertFalse('Text Source File Has BOM is False', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', Ord(tctAnsi), Ord(nextChar.&Type));
    AssertEquals('Text Source File Next Char is p', 'p', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is o', 'o', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is g', 'g', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is a', 'a', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is m', 'm', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is Space', ' ', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is T', 'T', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is e', 'e', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is s', 's', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is t', 't', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is CodePoint', TextCharTypeToString(tctCodePoint), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is 🌟', UnicodeString('🌟'), nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is empty', UnicodeString(EmptyStr), nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharUTF16BE;
//var
//  nextChar: TTextCharacter;
begin
  //Fail('Implement Next Char UTF16BE');
  {FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentUTF16BE));
  try
    AssertEquals('Text Source File is UTF16BE', TextFileTypeToString(tftUTF16BE), TextFileTypeToString(FSourceFile.FileType));
    AssertFalse('Text Source File Has BOM is False', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', Ord(tctAnsi), Ord(nextChar.&Type));
    AssertEquals('Text Source File Next Char is p', 'p', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;}
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharUTF16LE;
begin
  //Fail('Implement Next Char UTF16LE');
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharUTF32BE;
begin
  //Fail('Implement Next Char UTF32BE');
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharUTF32LE;
begin
  //Fail('Implement Next Char UTF32LE');
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharBOMUTF8;
var
  nextChar: TTextCharacter;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentBOMUTF8));
  try
    AssertEquals('Text Source File is UTF8', TextFileTypeToString(tftUTF8), TextFileTypeToString(FSourceFile.FileType));
    AssertTrue('Text Source File Has BOM', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is p', 'p', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is o', 'o', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is g', 'g', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is a', 'a', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is m', 'm', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is Space', ' ', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is T', 'T', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is e', 'e', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is s', 's', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is t', 't', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is UTF8', TextCharTypeToString(tctCodePoint), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is 🌟', UnicodeString('🌟'), nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is empty', UnicodeString(EmptyStr), nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharBOMUTF16BE;
var
  nextChar: TTextCharacter;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentBOMUTF16BE));
  try
    AssertEquals('Text Source File is UTF16BE', TextFileTypeToString(tftUTF16BE), TextFileTypeToString(FSourceFile.FileType));
    AssertTrue('Text Source File Has BOM', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is empty', UnicodeString(EmptyStr), nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharBOMUTF16LE;
var
  nextChar: TTextCharacter;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentBOMUTF16LE));
  try
    AssertEquals('Text Source File is UTF16LE', TextFileTypeToString(tftUTF16LE), TextFileTypeToString(FSourceFile.FileType));
    AssertTrue('Text Source File Has BOM', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is empty', UnicodeString(EmptyStr), nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharBOMUTF32BE;
var
  nextChar: TTextCharacter;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentBOMUTF32BE));
  try
    AssertEquals('Text Source File is UTF32BE', TextFileTypeToString(tftUTF32BE), TextFileTypeToString(FSourceFile.FileType));
    AssertTrue('Text Source File Has BOM', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is empty', UnicodeString(EmptyStr), nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceGetNextCharBOMUTF32LE;
var
  nextChar: TTextCharacter;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentBOMUTF32LE));
  try
    AssertEquals('Text Source File is UTF32LE', TextFileTypeToString(tftUTF32LE), TextFileTypeToString(FSourceFile.FileType));
    AssertTrue('Text Source File Has BOM', FSourceFile.HasBOM);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char is empty', UnicodeString(EmptyStr), nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

initialization

  RegisterTest(TTestObjectPascalParserTextSourceFile);
end.

