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

    function DumpToTempFile(const AContent: String): String;

    procedure TestSourceFileCreateException;
  published
    procedure TestObjectPascalParserTextSourceFileCreate;
    procedure TestObjectPascalParserTextSourceFileCreateError;
    procedure TestObjectPascalParserTextSourceFileFilename;
  end;

implementation

const
  cSourceFileContentUTF8 = 'program Test🌟';

function TTestObjectPascalParserTextSourceFile.DumpToTempFile(
  const AContent: String): String;
var
  tmpFilename: String;
  stringStream: TstringStream;
begin
  Result:= EmptyStr;
  stringStream:= TStringStream.Create(cSourceFileContentUTF8);
  try
    tmpFilename:= GetTempFileName;
    stringStream.SaveToFile(tmpFilename);
  finally
    stringStream.Free;
  end;
  Result:= tmpFilename;
end;

procedure TTestObjectPascalParserTextSourceFile.TestSourceFileCreateException;
begin
  FSourceFile:= TTextSourceFile.Create('');
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceFileCreate;
begin
  FSourceFile:= TTextSourceFile.Create(DumpToTempFile(cSourceFileContentUTF8));
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



initialization

  RegisterTest(TTestObjectPascalParserTextSourceFile);
end.

