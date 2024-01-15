unit OPP.Tests;

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
;

function DumpToTempFile(const AContent: String): String;


implementation

function DumpToTempFile(const AContent: String): String;
var
  tmpFilename: String;
  stringStream: TstringStream;
begin
  Result:= EmptyStr;
  stringStream:= TStringStream.Create(aContent);
  try
    tmpFilename:= GetTempFileName;
    stringStream.SaveToFile(tmpFilename);
  finally
    stringStream.Free;
  end;
  Result:= tmpFilename;
end;

end.

