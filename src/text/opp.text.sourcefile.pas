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
    FFileHasBOM: Boolean;

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
    property FileHasBOM: Boolean
      read FFileHasBOM;
  published
  end;

resourcestring
  rsETextSourceFileDoesNotExist = 'File "%s" does not exist';
  rsETextSourceFilePrematureEOF = 'File "%s" reached premature EOF';

implementation

{ TTextSourceFile }

constructor TTextSourceFile.Create(const AFileName: String);
var
  buffer: Byte;
  bytesread: Int64;
  BOMTest: String;
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
  { #todo 999 -ogcarreno : This needs to be BOM and UTF aware!! }
  BOMTest:= EmptyStr;

  FFileType:= tftUnknown;
  FFileHasBOM:= False;
  buffer:= 0;

  // For UTF32
  FSourceFileStream.Position:= 0; // Just in case
  BOMTest:= EmptyStr;
  if FSourceFileStream.Size >= 4 then
  begin
    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    if BOMTest = cBOMUTF32BE then
    begin
      FFileType:= tftUTF32BE;
      FFileHasBOM:= True;
    end
    else
    if BOMTest = cBOMUTF16LE then
    begin
      FFileType:= tftUTF32LE;
      FFileHasBOM:= True;
    end
  end;

  // For UTF8
  FSourceFileStream.Position:= 0; // Just in case
  BOMTest:= EmptyStr;
  if FSourceFileStream.Size >= 3 then
  begin
    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    if Copy(BOMTest, 1, 3) = cBOMUTF8 then
    begin
      FFileType:= tftUTF8;
      FFileHasBOM:= True;
    end;
  end;

  // For UTF16
  FSourceFileStream.Position:= 0; // Just in case
  BOMTest:= EmptyStr;
  if FSourceFileStream.Size >= 2 then
  begin
    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    bytesread:= FSourceFileStream.Read(buffer, SizeOf(buffer));
    if bytesRead = 0 then raise ETextSourceFilePrematureEOF.Create(
      Format(
        rsETextSourceFilePrematureEOF,
        [ FFilename ]
      )
    );
    BOMTest:= BOMTest + Char(buffer);

    if Copy(BOMTest, 1, 2) = cBOMUTF16BE then
    begin
      FFileType:= tftUTF16BE;
      FFileHasBOM:= True;
    end
    else
    if Copy(BOMTest, 1, 2) = cBOMUTF16LE then
    begin
      FFileType:= tftUTF16LE;
      FFileHasBOM:= True;
    end;
  end;

  case FFileType of
      tftUnknown: begin
        { #todo 999 -ogcarreno : We are assuming this for the time being }
        FFileType:= tftUTF8;
        FSourceFileStream.Position:= 0;
      end;
      tftUTF8: begin
        FSourceFileStream.Position:= 3;
      end;
      tftUTF16BE, tftUTF16LE: begin
        FSourceFileStream.Position:= 2;
      end;
      tftUTF32BE, tftUTF32LE: begin
        FSourceFileStream.Position:= 4;
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
        { #todo 999 -ogcarreno : This is temporary since it does not account for UTF16 nor UTF32 }
        Result.&Type:= tctAnsi;
        Result.Value := Char(buffer);
    end;
  end;
end;

end.

