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
    procedure TestObjectPascalParserTextSourceFileCreateError;
    procedure TestObjectPascalParserTextSourceFileFilename;
    procedure TestObjectPascalParserTextSourceGetNextCharAnsi;
    procedure TestObjectPascalParserTextSourceGetNextCharUTF8;
  end;

implementation

uses
  OPP.Tests
;

const
  cSourceFileContentAnsi = 'program';
  cSourceFileContentUTF8 = 'program Test🌟';

procedure TTestObjectPascalParserTextSourceFile.TestSourceFileCreateException;
begin
  FSourceFile:= TTextSourceFile.Create('');
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceFileCreate;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(''));
  try
    AssertNotNull('Text Source File is not null', FSourceFile);
    // Assert file is of type tftUTF8
  finally
    DeleteFile(FSourceFile.Filename);
    FSourceFile.Free;
  end;
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceFileCreateError;
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
    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is p', 'p', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is o', 'o', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is g', 'g', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is a', 'a', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is m', 'm', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is empty', EmptyStr, nextChar.Value);
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
    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', Ord(tctAnsi), Ord(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is p', 'p', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is o', 'o', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is g', 'g', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is r', 'r', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is a', 'a', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is m', 'm', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is Space', ' ', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is T', 'T', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is e', 'e', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is s', 's', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Ansi', TextCharTypeToString(tctAnsi), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is t', 't', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is UTF8', TextCharTypeToString(tctUTF8), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is 🌟', '🌟', nextChar.Value);
    AssertFalse('Text Source File Next Char Not EOF', nextChar.EOF);

    nextChar:= FSourceFile.GetNextChar;
    AssertEquals('Text Source File Next Char Type is Unknown', TextCharTypeToString(tctUnknown), TextCharTypeToString(nextChar.&Type));
    AssertEquals('Text Source File Next Char Char is empty', EmptyStr, nextChar.Value);
    AssertTrue('Text Source File Next Char is EOF', nextChar.EOF);
  finally
    FSourceFile.Free;
  end;
end;

initialization

  RegisterTest(TTestObjectPascalParserTextSourceFile);
end.

