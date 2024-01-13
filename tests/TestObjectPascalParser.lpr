program TestObjectPascalParser;

{$mode objfpc}{$H+}

uses
  Classes
, consoletestrunner
, TestObjectPascalParserStatesStack
, TestObjectPascalParserStatesStackTokens
;

type

{ TTestObjectPascalParserRunner }
  TTestObjectPascalParserRunner = class(TTestRunner)
  protected
  // override the protected methods of TTestRunner to customize its behavior
  end;

var
  Application: TTestObjectPascalParserRunner;

begin
  DefaultRunAllTests:=True;
  DefaultFormat:=fPlain;
  Application := TTestObjectPascalParserRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'Object Pascal Parser Console test runner';
  Application.Run;
  Application.Free;
end.
