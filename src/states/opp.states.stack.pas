unit OPP.States.Stack;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, OPP.States
;

type
{ TStatesStack }
  TStatesStack = class(TObject)
  private
    function GetCount: Integer;
  protected
    FStack: array of Cardinal;
    FTail: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Push(const AState: Cardinal);
    function Pop: Cardinal;
    function Peek: Cardinal;

    property Count: Integer
      read GetCount;
  published
  end;

resourcestring
  rsEStatesStackEmpty = 'The states stack is empty';

implementation

{ TStatesStack }

constructor TStatesStack.Create;
begin
  FTail:= -1;
  SetLength(FStack, FTail + 1);
end;

destructor TStatesStack.Destroy;
begin
  SetLength(FStack, 0);
  inherited Destroy;
end;

function TStatesStack.GetCount: Integer;
begin
  Result:= FTail + 1;
end;

procedure TStatesStack.Push(const AState: Cardinal);
begin
  Inc(FTail);
  SetLength(FStack, FTail + 1);
  FStack[FTail]:= AState;
end;

function TStatesStack.Pop: Cardinal;
begin
  if FTail > -1 then
  begin
    Result:= FStack[FTail];
    Dec(FTail);
    SetLength(FStack, FTail + 1);
  end
  else
    raise EStatesStackEmpty.Create(rsEStatesStackEmpty);
end;

function TStatesStack.Peek: Cardinal;
begin
  Result:= FStack[FTail];
end;

end.

