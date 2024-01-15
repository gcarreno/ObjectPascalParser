unit TestObjectPascalParserStatesStackTokens;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
  {$IFNDEF WINDOWS}
    {$codepage UTF8}
  {$ENDIF}
{$ENDIF}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, OPP.States
, OPP.States.StackTokens
;

type

  { TTestObjectPascalParserStatesStackTokens }

  TTestObjectPascalParserStatesStackTokens= class(TTestCase)
  private
    FStackTokens: TStatesStackTokens;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStatesStackTokensCreate;
    procedure TestStatesStackTokensPush;
    procedure TestStatesStackTokensPop;
    procedure TestStatesStackTokensPeek;
  end;

implementation

procedure TTestObjectPascalParserStatesStackTokens.SetUp;
begin
  inherited Setup;
  FStackTokens:= TStatesStackTokens.Create;
end;

procedure TTestObjectPascalParserStatesStackTokens.TearDown;
begin
  inherited TearDown;
  FStackTokens.Free;
end;

procedure TTestObjectPascalParserStatesStackTokens.TestStatesStackTokensCreate;
begin
  AssertEquals('States Stack Tokens Count is 0', 0, FStackTokens.Count);
end;

procedure TTestObjectPascalParserStatesStackTokens.TestStatesStackTokensPush;
begin
  FStackTokens.Push(tsUndefined);
  AssertEquals('States Stack Tokens Count is 1', 1, FStackTokens.Count);
end;

procedure TTestObjectPascalParserStatesStackTokens.TestStatesStackTokensPop;
var
  state: TTokenState;
begin
  FStackTokens.Push(tsUndefined);
  AssertEquals('States Stack Tokens Count is 1', 1, FStackTokens.Count);
  state:= FStackTokens.Pop;
  AssertEquals('States Stack Tokens Count is 0', 0, FStackTokens.Count);
  AssertEquals('States Stack Tokens Pop is tsUndefined', Ord(tsUndefined), Ord(state));
end;

procedure TTestObjectPascalParserStatesStackTokens.TestStatesStackTokensPeek;
var
  state: TTokenState;
begin
  FStackTokens.Push(tsUndefined);
  AssertEquals('States Stack Tokens Count is 1', 1, FStackTokens.Count);
  state:= FStackTokens.Peek;
  AssertEquals('States Stack Tokens Count is 1', 1, FStackTokens.Count);
  AssertEquals('States Stack Tokens Peek is tsUndefined', Ord(tsUndefined), Ord(state));
end;


initialization

  RegisterTest(TTestObjectPascalParserStatesStackTokens);
end.

