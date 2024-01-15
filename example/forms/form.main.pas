unit Form.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, Forms
, Controls
, Graphics
, Dialogs
, Menus
, ActnList
, StdActns
, PairSplitter
, StdCtrls
, ExtCtrls
, ComCtrls
, OPP.Parser
;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actParserParse: TAction;
    alMain: TActionList;
    actFileExit: TFileExit;
    btnParserParse: TButton;
    memTopSourceCode: TMemo;
    mnuParser: TMenuItem;
    MenuItem2: TMenuItem;
    mnuFile: TMenuItem;
    mnuFileExit: TMenuItem;
    mmMain: TMainMenu;
    panTopButtons: TPanel;
    psMain: TPairSplitter;
    pssTop: TPairSplitterSide;
    pssBottom: TPairSplitterSide;
    tvBottomCodeTree: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure actParserParseExecute(Sender: TObject);
 private
    FParser: TOPPParser;
    procedure InitShortcuts;
    function DumpToTempFile(const AContent: String): String;
  public

  end;

var
  frmMain: TfrmMain;

resourcestring
  rsFormCaption = 'Object Pascal Parser Example';

implementation

uses
  LCLType
;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption:= rsFormCaption;
  InitShortcuts;
  FParser:= nil;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FParser) then FParser.Free;
end;

procedure TfrmMain.InitShortcuts;
begin
{$IFDEF UNIX}
  actFileExit.ShortCut := KeyToShortCut(VK_Q, [ssCtrl]);
{$ENDIF}
{$IFDEF WINDOWS}
  actFileExit.ShortCut := KeyToShortCut(VK_X, [ssAlt]);
{$ENDIF}
end;

function TfrmMain.DumpToTempFile(const AContent: String): String;
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

procedure TfrmMain.actParserParseExecute(Sender: TObject);
begin
  psMain.Enabled:= False;
  Application.ProcessMessages;

  MessageDlg(
    'Object Pascal Parser',
    'Parsing is not implemented yet!',
    mtWarning,
    [mbOK],
    0
  );
  (*FParser:= TOPPParser.Create(DumpToTempFile(memTopSourceCode.Text));
  try
    FParser.Parse;
    { #todo 999 -ogcarreno : Read the code tree and dump it on the tree view }
  finally
    FreeAndNil(FParser);
  end;*)

  Application.ProcessMessages;
  psMain.Enabled:= False;
end;

end.

