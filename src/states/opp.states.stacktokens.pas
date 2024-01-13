unit OPP.States.StackTokens;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, OPP.States
, OPP.States.Stack
;

type
{ TStatesStackTokens }
  TStatesStackTokens = class(TStatesStack)
  private
  protected
  public
    procedure Push(const AState: TTokenState);
    function Pop: TTokenState;
    function Peek: TTokenState;
  published
  end;

implementation

{ TStatesStackTokens }

procedure TStatesStackTokens.Push(const AState: TTokenState);
begin
  inherited Push(Ord(AState));
end;

function TStatesStackTokens.Pop: TTokenState;
begin
  Result:= TTokenState(inherited Pop);
end;

function TStatesStackTokens.Peek: TTokenState;
begin
  Result:= TTokenState(inherited Peek);
end;

end.

