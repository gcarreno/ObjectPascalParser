unit OPP.Text;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

type
{ TTextFileType }
  TTextFileType = (tftUnknown, tftAnsi, tftUTF8, tftUTF16, tftUTF32);

function TextFileTypeToString(const ATextFileType: TTextFileType): String;

resourcestring
  rsTextFileTypeUnknown = 'Text File Type Unknown';
  rsTextFileTypeAnsi    = 'Text File Type Ansi';
  rsTextFileTypeUTF8    = 'Text File Type UTF8';
  rsTextFileTypeUTF16   = 'Text File Type UTF16';
  rsTextFileTypeUTF32   = 'Text File Type UTF32';

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
{ #todo 999 -ogcarreno : Determine if a union is possible or best }
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
    tftUnknown: Result:= rsTextFileTypeUnknown;
    tftAnsi:     Result:= rsTextFileTypeAnsi;
    tftUTF8:     Result:= rsTextFileTypeUTF8;
    tftUTF16:    Result:= rsTextFileTypeUTF16;
    tftUTF32:    Result:= rsTextFileTypeUTF32;
  end;
end;

function TextCharTypeToString(const ATextCharType: TTextCharType): String;
begin
  case ATextCharType of
    tctUnknown: Result:= rsTextFileTypeUnknown;
    tctAnsi:     Result:= rsTextFileTypeAnsi;
    tctUTF8:     Result:= rsTextFileTypeUTF8;
    tctUTF16:    Result:= rsTextFileTypeUTF16;
    tctUTF32:    Result:= rsTextFileTypeUTF32;
  end;
end;

end.

