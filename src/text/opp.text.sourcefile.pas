unit OPP.Text.SourceFile;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, OPP.Text
;

type
{ ETextSourceFileDoesNotExist }
  ETextSourceFileDoesNotExist = class(Exception);

{ TTextSourceFile }
  TTextSourceFile = class(TObject)
  private
    FSourceFileStream: TFileStream;
  protected
  public
    constructor Create(const AFileName: String);
    destructor Destroy; override;

    function GetNextChar: TTextCharacter;
  published
  end;

resourcestring
  rsETextSourceFileDoesNotExist = 'File "%s" does not exist';

implementation

{ TTextSourceFile }

constructor TTextSourceFile.Create(const AFileName: String);
begin
  FSourceFileStream:= nil;
  if not FileExists(AFileName) then raise ETextSourceFileDoesNotExist.Create(
    Format(
      rsETextSourceFileDoesNotExist,
      [ AFileName ]
    )
  );

  FSourceFileStream:= TFileStream.Create(AFileName, fmOpenRead);
end;

destructor TTextSourceFile.Destroy;
begin
  if Assigned(FSourceFileStream) then FSourceFileStream.Free;
  inherited Destroy;
end;

function TTextSourceFile.GetNextChar: TTextCharacter;
begin
  Result.&Type:= tctUnknown;
  Result.Ansi := #0;
  Result.UTF8 := '';
  Result.UTF16:= '';
  Result.UTF32:= '';

  // Get next char(s) and fill record
end;

end.

