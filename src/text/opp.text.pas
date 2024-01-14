unit OPP.Text;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
;

type
{ TTextFileType }
  TTextFileType = (tftUnknnown, tftAnsi, tftUTF8, tftUTF16, tftUTF32);

{ TTextCharType }
  TTextCharType = (tctUnknown, tctAnsi, tctUTF8, tctUTF16, tctUTF32);

{ #todo 999 -ogcarreno : Determine if a union is possible or best }
{ TTextCharacter }
  TTextCharacter = record
    &Type: TTextCharType;
    Ansi: Char;
    UTF8: String;
    UTF16: String;
    UTF32: String;
  end;

implementation

end.

