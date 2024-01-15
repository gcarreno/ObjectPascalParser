unit TestObjectPascalParser;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, OPP.Parser
;

type

  { TTestObjectPascalParser }

  TTestObjectPascalParser= class(TTestCase)
  private
    FParser: TOPPParser;
  published
    procedure TestParserCreate;
    procedure TestParserParseAnsi;
    procedure TestParserParseUTF8;
  end;

implementation

uses
 OPP.Tests
;

const
  cCodeProgramAnsi = 'program TestStar;';
  cCodeProgramUTF8 = 'program Test🌟;';

procedure TTestObjectPascalParser.TestParserCreate;
begin
  FParser:= TOPPParser.Create(DumpToTempFile(''));
  try
    AssertNotNull('OPP Parser not null', FParser);
  finally
    FParser.Free;
  end;
end;

procedure TTestObjectPascalParser.TestParserParseAnsi;
begin
  FParser:= TOPPParser.Create(DumpToTempFile(cCodeProgramAnsi));
  try
    { #todo 999 -ogcarreno : Test Ansi Parsing }
  finally
    FParser.Free;
  end;
end;

procedure TTestObjectPascalParser.TestParserParseUTF8;
begin
  FParser:= TOPPParser.Create(DumpToTempFile(cCodeProgramUTF8));
  try
    { #todo 999 -ogcarreno : Test UTF8 Parsing }
  finally
    FParser.Free;
  end;
end;



initialization

  RegisterTest(TTestObjectPascalParser);
end.

