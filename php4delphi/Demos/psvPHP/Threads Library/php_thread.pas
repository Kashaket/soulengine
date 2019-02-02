unit php_thread;

interface

uses
  Windows, Classes, Forms, PHPCommon, php4Delphi, PHPTypes, ZendTypes, ZENDAPI, PHPAPI,
  idThread, IdBaseComponent, IdThreadMgr,
  IdThreadMgrPool;

type
  TPHPThread = class(TidThread)
  private
    { Private declarations }
    PHP : TpsvPHP;
    S : string;
    procedure Report;
  public
    Pool: TIdThreadMgrPool;
    Code : string;
    constructor Create(ACreateSuspended: Boolean = True); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure AfterRun; override;
  end;

implementation

uses
  frm_Main;

{ TPHPThread }

procedure TPHPThread.AfterRun;
begin
  inherited;
  Pool.ReleaseThread(Self);
end;

constructor TPHPThread.Create(ACreateSuspended: Boolean);
begin
  inherited;
  PHP := TpsvPHP.Create(nil);
end;

destructor TPHPThread.Destroy;
begin
  PHP.Free;
  inherited;
end;

procedure TPHPThread.Report;
begin
  Application.ProcessMessages;
  frmMain.MemoOut.Lines.Add(S);
  Application.ProcessMessages;
end;

procedure TPHPThread.Run;
var
 cnt : integer;
begin
  for cnt := 1 to 100 do
   begin
     S := PHP.RunCode(Code);
     Synchronize(Report);
   end;
  Stop;
  //We will not destroy thread resources of TSRM
  //(PHP thread safe resource manager)
  //because theads will be reused
  //It's faster then create new thread every time
  //for a new request and all web-servers also do it
  //if you change your php.ini file and add
  // max_execution_time = 0 - Maximum execution time
  //of each script, in seconds
  // max_input_time = 0	- Maximum amount of time each
  //script may spend parsing request data
  //PHP will work faster
end;

end.
