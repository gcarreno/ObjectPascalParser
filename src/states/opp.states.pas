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
  TTokenState = (tsUndefined);

{ TLexerState }
  TLexerState = (tlUndefined);

implementation

end.

