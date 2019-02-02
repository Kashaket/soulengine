unit NxCaptionDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCaptionDlg = class(TForm)
    Memo: TMemo;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CaptionDlg: TCaptionDlg;

implementation

{$R *.dfm}

end.
