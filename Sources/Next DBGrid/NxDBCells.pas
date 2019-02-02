unit NxDBCells;

interface

uses
  Classes, Types, DB, NxColumns;

type
  TNxDBCells = class
  public
    FDataSet: TDataSet;
  public
    procedure SortColumn(ACol: Integer; ASortType: TSortType; ASortKind: TSortKind);
    procedure SwapRows(FromPos, ToPos: Integer);
  end;

implementation

{ TNxDBCells }

procedure TNxDBCells.SortColumn(ACol: Integer; ASortType: TSortType;
  ASortKind: TSortKind);
begin

end;

procedure TNxDBCells.SwapRows(FromPos, ToPos: Integer);
begin

end;

end.
