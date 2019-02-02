unit php_thread;

interface

uses
  Windows, Classes, PHPCommon, php4Delphi, PHPTypes, ZendTypes, ZENDAPI, PHPAPI,
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

procedure TPHPThread.Report;
begin
  frmMain.Memo1.Lines.Add(S);
end;

procedure TPHPThread.Run;
begin
  PHP := TpsvPHP.Create(nil);
  S := PHP.RunCode('echo "Threaded";');
  PHP.Free;
  Synchronize(Report);
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
