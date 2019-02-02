unit dmMain;

interface

uses
  SysUtils, Classes, HTTPApp, PHPCommon, php4delphi;

type
  TMainModule = class(TWebModule)
    psvPHP: TpsvPHP;
    procedure WebModuleCreate(Sender: TObject);
    procedure MainModuleWebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
    FEvent : TDateTime;
  public
    { Public declarations }
    function EventString : string;
  end;

var
  MainModule: TMainModule;

implementation

{$R *.dfm}

{ TMainModule }

function TMainModule.EventString: string;
begin
   Result := DateTimeToStr(FEvent);
end;

procedure TMainModule.WebModuleCreate(Sender: TObject);
begin
   FEvent := Now;
end;

procedure TMainModule.MainModuleWebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
 S : string;
begin
   psvPHP.VariableByName('nb').AsInteger := integer(Self);
   S := psvPHP.RunCode('<? print nb_test($nb); ?>');
   Response.Content := S;
end;

end.
