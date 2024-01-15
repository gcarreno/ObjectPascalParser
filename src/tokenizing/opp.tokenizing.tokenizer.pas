unit OPP.Tokenizing.Tokenizer;

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
, OPP.Text
, OPP.Text.SourceFile
, OPP.States
, OPP.States.StackTokens
, OPP.Tokenizing.Tokens
;

type
{ ETokenizingTokenizerStackNotEmpty }
  ETokenizingTokenizerStackNotEmpty = class(Exception);

{ ETokenizingTokenizerUnknownCharType }
  ETokenizingTokenizerUnknownCharType = class(Exception);

resourcestring
  rsETokenizingTokenizerStackNotEmpty = 'Tokenizing Tokenizer Stack Not Empty';
  rsETokenizingTokenizerUnknownCharType = 'Tokenizing Tokenizer Unknown Char type';

type
{ TTokenizingTokenizer }
  TTokenizingTokenizer = class(Tobject)
  type
  { TLoopFlow }
    TLoopFlow = (lfNone, lfBreak, lfContinue);
  private
    FSSourceFile: TTextSourceFile;
    FCurrentChar: TTextCharacter;
    FCurrentToken: TToken;
    FLine: Int64;
    FRow: Int64;
    FStackTokens: TStatesStackTokens;

    procedure FillTokenWithReset;
    procedure FillTokenWithEOL(const ADoIncrement: Boolean = True);
    procedure FillTokenWithEOF;

    function ProcessCharacter: TLoopFlow;
  protected
  public
    constructor Create(const ASourceFile: TTextSourceFile);
    destructor Destroy; override;

    function GetNextToken: TToken;
  published
  end;

implementation

{ TTokenizingTokenizer }

constructor TTokenizingTokenizer.Create(const ASourceFile: TTextSourceFile);
begin
  FSSourceFile:= ASourceFile;
  FCurrentChar.&Type:= tctUnknown;
  FCurrentChar.Value:= '';
  FCurrentChar.EOF:= False;
  FLine:= 0;
  FRow:= 0;
  FStackTokens:= TStatesStackTokens.Create;
end;

destructor TTokenizingTokenizer.Destroy;
begin
  if Assigned(FStackTokens) then FStackTokens.Free;
  inherited Destroy;
end;

procedure TTokenizingTokenizer.FillTokenWithReset;
begin
  FCurrentToken.Error:= teNone;
  FCurrentToken.&Type:= ttUndefined;
  FCurrentToken.Line:= FLine;
  FCurrentToken.Row:= FRow;
  FCurrentToken.Element:= UnicodeString(EmptyStr);
end;

procedure TTokenizingTokenizer.FillTokenWithEOL(const ADoIncrement: Boolean);
begin
  FCurrentToken.Error:= teNone;
  FCurrentToken.&Type:= ttEOL;
  if ADoIncrement then
  begin
    Inc(FLine);
    FRow:= 0;
  end;
  FCurrentToken.Line:= FLine;
  FCurrentToken.Row:= FRow;
end;

procedure TTokenizingTokenizer.FillTokenWithEOF;
begin
  FCurrentToken.Error:= teNone;
  FCurrentToken.&Type:= ttEOF;
  FCurrentToken.Line:= FLine;
  FCurrentToken.Row:= FRow;
  FCurrentToken.Element:= UnicodeString(EmptyStr);
end;

function TTokenizingTokenizer.ProcessCharacter: TLoopFlow;
begin
  Result:= lfNone;
  case FCurrentChar.Value of
    // White Spaces
    #9, ' ':begin
      if not (FStackTokens.Peek = tsWhiteSpace) then FStackTokens.Push(tsWhiteSpace);
    end;

    #10, #13:begin
      case FStackTokens.Peek of
        tsUndefined:begin
          if FCurrentChar.Value = #10 then
          begin
            FillTokenWithEOL;
            FCurrentToken.Element:= FCurrentChar.Value;
            Result:= lfBreak;
          end;
          if FCurrentChar.Value = #13 then
          begin
            FillTokenWithEOL(False);
            FCurrentToken.Element:= FCurrentChar.Value;
            FStackTokens.Push(tsMaybeCRLF);
            Result:= lfContinue;
          end;
        end;
        tsMaybeCRLF:begin
          if FCurrentChar.Value = #10 then
          begin
            FillTokenWithEOL;
            FCurrentToken.Element:= FCurrentToken.Element + FCurrentChar.Value;
            FStackTokens.Pop;
            Result:= lfBreak;
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
end;

function TTokenizingTokenizer.GetNextToken: TToken;
begin
  FillTokenWithReset;

  // Exit early if nothing to do
  if FSSourceFile.Size = 0 then
  begin
    FillTokenWithEOF;
    Result:= FCurrentToken;
    exit;
  end;

  FStackTokens.Push(tsUndefined);
  repeat
    FCurrentChar:= FSSourceFile.GetNextChar;

    // This is EOF
    if FCurrentChar.EOF then
    begin
      case FStackTokens.Peek of
        tsUndefined:begin
          FillTokenWithEOF;
          break;
        end;
        tsWhiteSpace:begin
          FStackTokens.Pop;
          FillTokenWithEOF;
          break;
        end;
        tsMaybeCRLF:begin
          FStackTokens.Pop;
          FillTokenWithEOL;
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

    case FCurrentChar.&Type of
      tctUnknown:begin
        raise ETokenizingTokenizerUnknownCharType.Create(rsETokenizingTokenizerUnknownCharType);
      end;
      tctAnsi:begin
        case ProcessCharacter of
          lfNone:begin
            // Do Nothing
          end;
          lfBreak:begin
            break;
          end;
          lfContinue:begin
            continue;
          end;
        end;
      end;
      tctCodePoint:begin
        case ProcessCharacter of
          lfNone:begin
            { #todo 999 -ogcarreno : This needs to be re-evaluated with state }
            FCurrentToken.Element:= FCurrentToken.Element + FCurrentChar.Value;
            continue;
          end;
          lfBreak:begin
            break;
          end;
          lfContinue:begin
            continue;
          end;
        end;
      end;
    end;


  until  FStackTokens.Peek = tsUndefined;
  if FStackTokens.Count > 1 then
    raise ETokenizingTokenizerStackNotEmpty.Create(rsETokenizingTokenizerStackNotEmpty);
  FStackTokens.Pop;
  Result:= FCurrentToken;
end;

end.

