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

procedure TTestSates.TestStatesStackCreate;
begin
  FStatesStack:= TStatesStack.Create;
  try
    AssertEquals('State Stack Count is 0', 0, FStatesStack.Count);
  finally
    FStatesStack.Free;
  end;
end;

procedure TTestSates.TestStatesStackPush;
begin
  FStatesStack:= TStatesStack.Create;
  try
    FStatesStack.Push(0);
    AssertEquals('State Stack Count is 1', 1, FStatesStack.Count);
  finally
    FStatesStack.Free;
  end;
end;

procedure TTestSates.TestStatesStackPop;
var
  state: Cardinal;
begin
  FStatesStack:= TStatesStack.Create;
  try
    FStatesStack.Push(1);
    AssertEquals('State Stack Count is 1', 1, FStatesStack.Count);
    state:= FStatesStack.Pop;
    AssertEquals('State Stack Count is 0', 0, FStatesStack.Count);
    AssertEquals('State Stack State is 1', 1, state);
  finally
    FStatesStack.Free;
  end;
end;

procedure TTestSates.TestStatesStackPopException;
begin
  FStatesStack:= TStatesStack.Create;
  try
    AssertException('State Stack Exception Empty',
      EStatesStackEmpty,
      @RunPopException,
      rsEStatesStackEmpty
    );
  finally
    FStatesStack.Free;
  end;
end;

procedure TTestSates.TestStatesStackPeek;
var
  state: Cardinal;
begin
  FStatesStack:= TStatesStack.Create;
  try
    FStatesStack.Push(2);
    AssertEquals('State Stack Count is 1', 1, FStatesStack.Count);
    state:= FStatesStack.Peek;
    AssertEquals('State Stack Count is 1', 1, FStatesStack.Count);
    AssertEquals('State Stack State is 2', 2, state);
  finally
    FStatesStack.Free;
  end;
end;


initialization

  RegisterTest(TTestSates);
end.

