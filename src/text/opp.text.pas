unit OPP.Text;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

const
  cBOMUTF8    : TBytes = ($EF, $BB, $BF);
  cBOMUTF16BE : TBytes = ($FE, $FF);
  cBOMUTF16LE : TBytes = ($FF, $FE);
  cBOMUTF32BE : TBytes = ($00, $00, $FE, $FF);
  cBOMUTF32LE : TBytes = ($00, $00, $FF, $FE);
  cBOMUTF8Len  = 3;
  cBOMUTF16Len = 2;
  cBOMUTF32Len = 4;

type
{ TTextFileType }
  TTextFileType = (tftUnknown, tftAnsi, tftUTF8, tftUTF16BE, tftUTF16LE, tftUTF32BE, tftUTF32LE);

function TextFileTypeToString(const ATextFileType: TTextFileType): String;

resourcestring
  rsTextFileTypeUnknown = 'Text File Type Unknown';
  rsTextFileTypeAnsi    = 'Text File Type Ansi';
  rsTextFileTypeUTF8    = 'Text File Type UTF8';
  rsTextFileTypeUTF16BE = 'Text File Type UTF16 Big Endian';
  rsTextFileTypeUTF16LE = 'Text File Type UTF16 Little Endian';
  rsTextFileTypeUTF32BE = 'Text File Type UTF32 Big Endian';
  rsTextFileTypeUTF32LE = 'Text File Type UTF32 Little Endian';

type
{ TTextBOMType }
  TTextBOMType = (tbtUnknown, tbtUTF8, tbtUTF16BE, tbtUTF16LE, tbtUTF32BE, tbtUTF32LE);

function TextBOMTypeToString(const ATextBOMType: TTextBOMType): String;

resourcestring
  rsTextBOMTypeUnknown   = 'Text BOM Type Unknown';
  rsTextBOMTypeUTF8      = 'Text BOM Type UTF8';
  rsTextBOMTypeUTF16BE   = 'Text BOM Type UTF16 Big Endian';
  rsTextBOMTypeUTF16LE   = 'Text BOM Type UTF16 Little Endian';
  rsTextBOMTypeUTF32BE   = 'Text BOM Type UTF32 Big Endian';
  rsTextBOMTypeUTF32LE   = 'Text BOM Type UTF32 Little Endian';

type
{ TTextCharType }
  TTextCharType = (tctUnknown, tctAnsi, tctUTF8, tctUTF16, tctUTF32);

function TextCharTypeToString(const ATextCharType: TTextCharType): String;

resourcestring
  rsTextCharTypeUnknown = 'Text Char Type Unknown';
  rsTextCharTypeAnsi    = 'Text Char Type Ansi';
  rsTextCharTypeUTF8    = 'Text Char Type UTF8';
  rsTextCharTypeUTF16   = 'Text Char Type UTF16';
  rsTextCharTypeUTF32   = 'Text Char Type UTF32';

type
{ TTextCharacter }
  TTextCharacter = record
    &Type: TTextCharType;
    Value: String;
    EOF: Boolean;
  end;

implementation

function TextFileTypeToString(const ATextFileType: TTextFileType): String;
begin
  case ATextFileType of
    tftUnknown:           Result:= rsTextFileTypeUnknown;
    tftAnsi:              Result:= rsTextFileTypeAnsi;
    tftUTF8:              Result:= rsTextFileTypeUTF8;
    tftUTF16BE:    Result:= rsTextFileTypeUTF16BE;
    tftUTF16LE: Result:= rsTextFileTypeUTF16LE;
    tftUTF32BE:    Result:= rsTextFileTypeUTF32BE;
    tftUTF32LE: Result:= rsTextFileTypeUTF32LE;
  end;
end;

function TextBOMTypeToString(const ATextBOMType: TTextBOMType): String;
begin
  case ATextBOMType of
    tbtUnknown:           Result:= rsTextBOMTypeUnknown;
    tbtUTF8:              Result:= rsTextBOMTypeUTF8;
    tbtUTF16BE:    Result:= rsTextBOMTypeUTF16BE;
    tbtUTF16LE: Result:= rsTextBOMTypeUTF16LE;
    tbtUTF32BE:    Result:= rsTextBOMTypeUTF32BE;
    tbtUTF32LE: Result:= rsTextBOMTypeUTF32LE;
  end;
end;

function TextCharTypeToString(const ATextCharType: TTextCharType): String;
begin
  case ATextCharType of
    tctUnknown: Result:= rsTextCharTypeUnknown;
    tctAnsi:    Result:= rsTextCharTypeAnsi;
    tctUTF8:    Result:= rsTextCharTypeUTF8;
    tctUTF16:   Result:= rsTextCharTypeUTF16;
    tctUTF32:   Result:= rsTextCharTypeUTF32;
  end;
end;

end.

