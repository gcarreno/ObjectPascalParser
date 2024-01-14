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
  end;

implementation

const
  cSourceFileContentUTF8 = 'program Test🌟';

procedure TTestObjectPascalParserTextSourceFile.TestSourceFileCreateException;
begin
  FSourceFile:= TTextSourceFile.Create('');
end;

procedure TTestObjectPascalParserTextSourceFile.TestObjectPascalParserTextSourceFileCreate;
var
  stringStream: TstringStream;
  tmpFilename: String;
begin
  stringStream:= TStringStream.Create(cSourceFileContentUTF8);
  try
    tmpFilename:= GetTempFileName;
    stringStream.SaveToFile(tmpFilename);
    try

      FSourceFile:= TTextSourceFile.Create(tmpFilename);
      AssertNotNull('Text Source File is not null', FSourceFile);
      // Assert file is of type tftUTF8

    finally
      DeleteFile(tmpFilename);
    end;
  finally
    stringStream.Free;
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



initialization

  RegisterTest(TTestObjectPascalParserTextSourceFile);
end.

