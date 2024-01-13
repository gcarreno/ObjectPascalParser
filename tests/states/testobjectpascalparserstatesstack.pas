unit TestObjectPascalParserStatesStack;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
, OPP.States
, OPP.States.Stack
;

type

  { TTestSates }

  TTestSates= class(TTestCase)
  private
    FStatesStack: TStatesStack;

    procedure RunPopException;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStatesStackCreate;
    procedure TestStatesStackPush;
    procedure TestStatesStackPop;
    procedure TestStatesStackPopException;
    procedure TestStatesStackPeek;
  end;

implementation

procedure TTestSates.RunPopException;
begin
  FStatesStack.Pop;
end;

procedure TTestSates.SetUp;
begin
  inherited SetUp;
  FStatesStack:= TStatesStack.Create;
end;

procedure TTestSates.TearDown;
begin
  inherited TearDown;
  FStatesStack.Free;
end;

procedure TTestSates.TestStatesStackCreate;
begin
  AssertEquals('States Stack Count is 0', 0, FStatesStack.Count);
end;

procedure TTestSates.TestStatesStackPush;
begin
  FStatesStack.Push(0);
  AssertEquals('States Stack Count is 1', 1, FStatesStack.Count);
end;

procedure TTestSates.TestStatesStackPop;
var
  state: Cardinal;
begin
  FStatesStack.Push(1);
  AssertEquals('States Stack Count is 1', 1, FStatesStack.Count);
  state:= FStatesStack.Pop;
  AssertEquals('States Stack Count is 0', 0, FStatesStack.Count);
  AssertEquals('States Stack State Pop is 1', 1, state);
end;

procedure TTestSates.TestStatesStackPopException;
begin
  AssertException('States Stack Exception Empty',
    EStatesStackEmpty,
    @RunPopException,
    rsEStatesStackEmpty
  );
end;

procedure TTestSates.TestStatesStackPeek;
var
  state: Cardinal;
begin
  FStatesStack.Push(2);
  AssertEquals('States Stack Count is 1', 1, FStatesStack.Count);
  state:= FStatesStack.Peek;
  AssertEquals('States Stack Count is 1', 1, FStatesStack.Count);
  AssertEquals('States Stack State Peek is 2', 2, state);
end;


initialization

  RegisterTest(TTestSates);
end.

