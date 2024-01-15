unit OPP.Parser;

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
, OPP.Text.SourceFile
, OPP.Tokenizing.Tokenizer
;

type
{ TOPPParser }
  TOPPParser = class(TObject)
  private
    FSourceFile: TTextSourceFile;
    FTokenizer: TTokenizingTokenizer;
  protected
  public
    constructor Create(const AFilename: String);
    destructor Destroy; override;

    procedure Parse;
  published
  end;

implementation

{ TOPPParser }

constructor TOPPParser.Create(const AFilename: String);
begin
  FSourceFile:= TTextSourceFile.Create(AFilename);
  FTokenizer:= TTokenizingTokenizer.Create(FSourceFile);
end;

destructor TOPPParser.Destroy;
begin
  FTokenizer.Free;
  FSourceFile.Free;
  inherited Destroy;
end;

procedure TOPPParser.Parse;
begin
  { #todo 999 -ogcarreno : Kick start all the parsing }
end;

end.

