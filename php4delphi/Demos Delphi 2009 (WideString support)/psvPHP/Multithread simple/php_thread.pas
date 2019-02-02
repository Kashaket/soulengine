unit php_thread;

interface

uses
  Windows, Classes, Forms, PHPCommon, php4Delphi, PHPTypes, ZendTypes, ZENDAPI, PHPAPI;

type
  TPHPThread = class(TThread)
  private
    { Private declarations }
    PHP : TpsvPHP;
  protected
    procedure Execute; override;
    procedure ComeBack;
  end;

implementation


{ TPHPThread }

procedure TPHPThread.ComeBack;
begin
  Application.ProcessMessages;
end;

procedure TPHPThread.Execute;
begin
  PHP := TpsvPHP.Create(nil);
  PHP.RunCode('echo "Threaded";');
  PHP.Free;
  Synchronize(ComeBack);
  sleep(250); //for zend_timeout to kill timer
  Synchronize(ComeBack);
  try
    //This will release thread allocated resources
    //The better way is to reuse existsing threads
    //to save time and memory
    ts_free_thread;
  except
  end;
end;

end.
