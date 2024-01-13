unit OPP.Tokenizing.Tokenizer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, OPP.States
, OPP.States.StackTokens
, OPP.Tokenizing.Tokens
;

type
{ ETokenizingTokenizerStackNotEmpty }
  ETokenizingTokenizerStackNotEmpty = class(Exception);

resourcestring
  rsETokenizingTokenizerStackNotEmpty = 'Tokenizing Tokenizer Stack Not Empty';

type
{ TTokenizingTokenizer }
  TTokenizingTokenizer = class(Tobject)
  private
    FStream: TStringStream;
    FCurrentChar: Char;
    FLine: Int64;
    FRow: Int64;
    FStackTokens: TStatesStackTokens;

    procedure FillReset(var AToken: TToken);
    procedure FillEOL(var AToken: TToken; const ADoIncrement: Boolean = True);
    procedure FillEOF(var AToken: TToken);
  protected
  public
    constructor Create(const AStream: TStream);
    destructor Destroy; override;

    function GetNextToken: TToken;
  published
  end;

implementation

{ TTokenizingTokenizer }

constructor TTokenizingTokenizer.Create(const AStream: TStream);
begin
  FStream:= TStringStream.Create;
  FStream.CopyFrom(AStream, AStream.Size);
  FStream.Position:= 0;
  FCurrentChar:= #0;
  FLine:= 0;
  FRow:= 0;
  FStackTokens:= TStatesStackTokens.Create;
end;

destructor TTokenizingTokenizer.Destroy;
begin
  if Assigned(FStream) then FStream.Free;
  if Assigned(FStackTokens) then FStackTokens.Free;
  inherited Destroy;
end;

procedure TTokenizingTokenizer.FillReset(var AToken: TToken);
begin
  AToken.Error:= teNone;
  AToken.&Type:= ttUndefined;
  AToken.Line:= FLine;
  AToken.Row:= FRow;
  AToken.Element:= EmptyStr;
end;

procedure TTokenizingTokenizer.FillEOL(var AToken: TToken;
  const ADoIncrement: Boolean);
begin
  AToken.Error:= teNone;
  AToken.&Type:= ttEOL;
  if ADoIncrement then
  begin
    Inc(FLine);
    FRow:= 0;
  end;
  AToken.Line:= FLine;
  AToken.Row:= FRow;
end;

procedure TTokenizingTokenizer.FillEOF(var AToken: TToken);
begin
  AToken.Error:= teNone;
  AToken.&Type:= ttEOF;
  AToken.Line:= FLine;
  AToken.Row:= FRow;
  AToken.Element:= EmptyStr;
end;

function TTokenizingTokenizer.GetNextToken: TToken;
var
  bytesRead: Integer = 0;
begin
  FillReset(Result);

  // Exit early if nothing to do
  if FStream.Size = 0 then
  begin
    Result.&Type:= ttEOF;
    exit;
  end;

  FStackTokens.Push(tsUndefined);
  repeat
    // Read one char at a time
    { #todo 999 -ogcarreno : This needs to be BOM and UTF aware!! }
    bytesRead:= FStream.ReadData(FCurrentChar, 1);

    // This is EOF
    if bytesRead = 0 then
    begin
      case FStackTokens.Peek of
        tsUndefined:begin
          FillEOF(Result);
          break;
        end;
        tsWhiteSpace:begin
          FStackTokens.Pop;
          FillEOF(Result);
          break;
        end;
        tsMaybeCRLF:begin
          FStackTokens.Pop;
          FillEOL(Result);
          break;
        end;
        otherwise
          // Do Nothing
      end;
    end
    else
    begin
      // We read something so we increase the row
      Inc(FRow);
    end;

    // We read something witout error, and we initialize the Line number
    if FLine = 0 then FLine:= 1;

    // Decide per caracter
    case FCurrentChar of
      // White Spaces
      #9, ' ':begin
        if not (FStackTokens.Peek = tsWhiteSpace) then FStackTokens.Push(tsWhiteSpace);
      end;

      #10, #13:begin
        case FStackTokens.Peek of
          tsUndefined:begin
            if FCurrentChar = #10 then
            begin
              FillEOL(Result);
              Result.Element:= FCurrentChar;
              break;
            end;
            if FCurrentChar = #13 then
            begin
              FillEOL(Result, False);
              Result.Element:= FCurrentChar;
              FStackTokens.Push(tsMaybeCRLF);
              continue;
            end;
          end;
          tsMaybeCRLF:begin
            if FCurrentChar = #10 then
            begin
              FillEOL(Result);
              Result.Element:= Result.Element + FCurrentChar;
              FStackTokens.Pop;
              break;
            end;
          end;
          otherwise
            // Do Nothing ?!?!?!
        end;
      end;

      // If everything else does not match
      otherwise
        FStackTokens.Pop;
    end;

writeln('State: ', TokenStateToString(FStackTokens.Peek), ' Char: ', FCurrentChar);

  until  FStackTokens.Peek = tsUndefined;
  if FStackTokens.Count > 1 then
    raise ETokenizingTokenizerStackNotEmpty.Create(rsETokenizingTokenizerStackNotEmpty);
  FStackTokens.Pop;
end;

end.

