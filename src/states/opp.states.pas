unit OPP.States;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

type
{ EStatesStackEmpty }
  EStatesStackEmpty = class(Exception);

{ TTokenState }
  TTokenState = (
    tsUndefined
    , tsWhiteSpace
    , tsMaybeCRLF
  );

resourcestring
  rsTokenStateInvalid    = 'Token State Invalid';
  rsTokenStateUndefined  = 'Token State Undefined';
  rsTokenStateWhiteSpace = 'Token State White Space';
  rsTokenStateMaybeCRLF  = 'Token State Maybe CRLF';

function TokenStateToString(const ATokenState:TTokenState): String;

type
{ TLexerState }
  TLexerState = (tlUndefined);

implementation

function TokenStateToString(const ATokenState: TTokenState): String;
begin
  Result:= EmptyStr;
  case ATokenState of
    tsUndefined: Result := rsTokenStateUndefined;
    tsWhiteSpace: Result:= rsTokenStateWhiteSpace;
    tsMaybeCRLF: Result :=  rsTokenStateMaybeCRLF;
    otherwise
    Result:= rsTokenStateInvalid;
  end;
end;

end.

