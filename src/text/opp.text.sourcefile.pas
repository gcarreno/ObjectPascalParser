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

{ ETextSourceFilePrematureEOF }
  ETextSourceFilePrematureEOF = class(Exception);

{ TTextSourceFile }
  TTextSourceFile = class(TObject)
  private
    FFilename: String;
    FSourceFileStream: TFileStream;
    FFileType: TTextFileType;

    function GetStreamSize: Int64;
  protected
  public
    constructor Create(const AFileName: String);
    destructor Destroy; override;

    function GetNextChar: TTextCharacter;

    property Filename: String
      read FFilename;
    property FileType: TTextFileType
      read FFileType;
    property Size: Int64
      read GetStreamSize;
  published
  end;

resourcestring
  rsETextSourceFileDoesNotExist = 'File "%s" does not exist';
  rsETextSourceFilePrematureEOF = 'File "%s" reached premature EOF';

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

  { #todo 999 -ogcarreno : This needs to be BOM and UTF aware!! }
  FFilename:= AFileName;
  FSourceFileStream:= TFileStream.Create(AFileName, fmOpenRead);
  { #todo 999 -ogcarreno : This need to change, but for the current code it will do }
  FFileType:= tftAnsi;
end;

destructor TTextSourceFile.Destroy;
begin
  if Assigned(FSourceFileStream) then FSourceFileStream.Free;
  inherited Destroy;
end;

function TTextSourceFile.GetStreamSize: Int64;
begin
  Result:= FSourceFileStream.Size;
end;

function TTextSourceFile.GetNextChar: TTextCharacter;
var
  { #todo 999 -ogcarreno : This need to change, but for the current code it will do }
  buffer: Byte;
  bytesRead: Int64;
begin
  Result.&Type:= tctUnknown;
  Result.Value := '';
  Result.EOF:= False;

  buffer:= 0;

  // Get next char(s) and fill record
  bytesRead:= FSourceFileStream.Read(buffer, SizeOf(buffer));
  if bytesRead = 0 then
  begin
    Result.EOF:= True;
  end
  else
  begin
    case buffer of
      $00..$7F:begin
        Result.&Type:= tctAnsi;
        Result.Value := Char(buffer);
      end;
      $C2..$DF:begin
        Result.&Type:= tctUTF8;
        Result.Value := Char(buffer);
        bytesRead:= FSourceFileStream.Read(buffer, SizeOf(buffer));
        if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(rsETextSourceFilePrematureEOF);
        Result.Value := Result.Value + Char(buffer);
      end;
      $E0, $E1..$EF:begin
        Result.&Type:= tctUTF8;
        Result.Value := Char(buffer);
        bytesRead:= FSourceFileStream.Read(buffer, SizeOf(buffer));
        if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(rsETextSourceFilePrematureEOF);
        Result.Value := Result.Value + Char(buffer);
        bytesRead:= FSourceFileStream.Read(buffer, SizeOf(buffer));
        if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(rsETextSourceFilePrematureEOF);
        Result.Value := Result.Value + Char(buffer);
      end;
      $F0, $F1..$F3, $F4:begin
        Result.&Type:= tctUTF8;
        Result.Value := Char(buffer);
        bytesRead:= FSourceFileStream.Read(buffer, SizeOf(buffer));
        if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(rsETextSourceFilePrematureEOF);
        Result.Value := Result.Value + Char(buffer);
        bytesRead:= FSourceFileStream.Read(buffer, SizeOf(buffer));
        if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(rsETextSourceFilePrematureEOF);
        Result.Value := Result.Value + Char(buffer);
        bytesRead:= FSourceFileStream.Read(buffer, SizeOf(buffer));
        if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(rsETextSourceFilePrematureEOF);
        Result.Value := Result.Value + Char(buffer);
      end;
    end;
  end;
end;

end.

