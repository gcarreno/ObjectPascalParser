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
    FHasBOM: Boolean;

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
    property HasBOM: Boolean
      read FHasBOM;
  published
  end;

resourcestring
  rsETextSourceFileDoesNotExist = 'File "%s" does not exist';
  rsETextSourceFilePrematureEOF = 'File "%s" reached premature EOF';

implementation

{ TTextSourceFile }

constructor TTextSourceFile.Create(const AFileName: String);
var
  buffer: TBytes;
begin
  FSourceFileStream:= nil;
  if not FileExists(AFileName) then raise ETextSourceFileDoesNotExist.Create(
    Format(
      rsETextSourceFileDoesNotExist,
      [ AFileName ]
    )
  );

  FFilename:= AFileName;
  FSourceFileStream:= TFileStream.Create(AFileName, fmOpenRead);

  FFileType:= tftUnknown;
  FHasBOM:= False;

  // For UTF8
  if (FFileType = tftUnknown) and (FSourceFileStream.Size >= cBOMUTF8Len) then
  begin
    FSourceFileStream.Position:= 0; // Just in case

    SetLength(buffer, cBOMUTF8Len);
    FSourceFileStream.Read(buffer[0], cBOMUTF8Len);

    if CompareByte(buffer[0], cBOMUTF8[0], cBOMUTF8Len) = 0 then
    begin
      FFileType:= tftUTF8;
      FHasBOM:= True;
    end;
  end;

  // For UTF16
  if (FFileType = tftUnknown) and (FSourceFileStream.Size >= cBOMUTF16Len) then
  begin
    FSourceFileStream.Position:= 0; // Just in case

    SetLength(buffer, cBOMUTF16Len);
    FSourceFileStream.Read(buffer[0], cBOMUTF16Len);

    if CompareByte(buffer[0], cBOMUTF16BE[0], cBOMUTF16Len) = 0 then
    begin
      FFileType:= tftUTF16BE;
      FHasBOM:= True;
    end
    else
    if CompareByte(buffer[0], cBOMUTF16LE[0], cBOMUTF16Len) = 0 then
    begin
      FFileType:= tftUTF16LE;
      FHasBOM:= True;
    end;
  end;

  // For UTF32
  if (FFileType = tftUnknown) and (FSourceFileStream.Size >= cBOMUTF32Len) then
  begin
    FSourceFileStream.Position:= 0;

    SetLength(buffer, cBOMUTF32Len);
    FSourceFileStream.Read(buffer[0], cBOMUTF32Len);

    if CompareByte(buffer[0], cBOMUTF32BE[0], cBOMUTF32Len) = 0 then
    begin
      FFileType:= tftUTF32BE;
      FHasBOM:= True;
    end
    else
    if CompareByte(buffer[0], cBOMUTF32LE[0], cBOMUTF32Len) = 0 then
    begin
      FFileType:= tftUTF32LE;
      FHasBOM:= True;
    end;
  end;

  case FFileType of
      tftUnknown: begin
        { #todo 999 -ogcarreno : We are assuming this for the time being }
        FFileType:= tftUTF8;
        FSourceFileStream.Position:= 0;
      end;
      tftUTF8: begin
        FSourceFileStream.Position:= cBOMUTF8Len;
      end;
      tftUTF16BE, tftUTF16LE: begin
        FSourceFileStream.Position:= cBOMUTF16Len;
      end;
      tftUTF32BE, tftUTF32LE: begin
        FSourceFileStream.Position:= cBOMUTF32Len;
      end;
  end;


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
    case FFileType of
      tftUnknown:begin
        // ?!?
      end;
      tftAnsi:begin
        // ?!?
      end;
      tftUTF8:begin
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
          otherwise
            Result.&Type:= tctAnsi;
            Result.Value := Char(buffer);
        end;
      end;
      tftUTF16BE:begin
        Result.&Type:= tctUTF16BE;
        // Need to read the next byte of the character
      end;
      tftUTF16LE:begin
        Result.&Type:= tctUTF16LE;
        // Need to read the next byte of the character
      end;
      tftUTF32BE:begin
        Result.&Type:= tctUTF32BE;
        // Need to read the next 3 bytes of the character
      end;
      tftUTF32LE:begin
        Result.&Type:= tctUTF32LE;
        // Need to read the next 3 bytes of the character
      end;
    end;

  end;
end;

end.

