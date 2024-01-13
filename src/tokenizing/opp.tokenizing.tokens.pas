unit OPP.Tokenizing.Tokens;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

type
{ TTokenError }
  TTokenError = (
    teNone
  );

resourcestring
  rsTokenErrorInvalid = 'Token Error Invalid';
  rsTokenErrorNone    = 'Token Error None';

function TokenErrorToString(const ATokenError: TTokenError): String;

type
{ TTokenType }
  TTokenType = (
    ttUndefined
    , ttEOL
    , ttEOF
  );

resourcestring
  rsTokenTypeInvalid   = 'Token Type Invalid';
  rsTokenTypeUndefined = 'Token Type Undefined';
  rsTokenTypeEOL       = 'Token Type End of Line';
  rsTokenTypeEOF       = 'Token Type End of File';

function TokenTypeToString(const ATokenType: TTokenType): String;

  type
{ TToken }
  TToken = record
    Error: TTokenError;
    &Type: TTokenType;
    Line: Int64;
    Row: Int64;
    Element: String;
  end;


implementation

function TokenErrorToString(const ATokenError: TTokenError): String;
begin
  Result:= EmptyStr;
  case ATokenError of
    teNone:Result := rsTokenErrorNone;
    otherwise
      Result:= rsTokenErrorInvalid;
  end;
end;

function TokenTypeToString(const ATokenType: TTokenType): String;
begin
  Result:= EmptyStr;
  case ATokenType of
    ttUndefined:Result := rsTokenTypeUndefined;
    ttEOL:Result       := rsTokenTypeEOL;
    ttEOF:Result       := rsTokenTypeEOF;
    otherwise
      Result:= rsTokenTypeInvalid;
  end;
end;

end.

