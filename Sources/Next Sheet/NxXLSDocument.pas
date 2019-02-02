unit NxXLSDocument;

interface

uses
  Classes;

type
  PByte = ^byte;
  PWord = ^word;

  TNxXLSDocument = class(TObject)
  public
    constructor Create();
    destructor Destroy(); override;
    procedure SaveToFile(const FileName : string);
    procedure IntegerNumber(const Row, Column: integer; Value : int64; const Alignment : TAlignment = taCenter; const FontName : string = 'Arial'; const FontHeight : word = 10; const Format: string = 'General');
    procedure FloatingNumber(const Row, Column : word; const Value : double; const Alignment : TAlignment = taCenter; const FontName : string = 'Arial'; const FontHeight : word = 10; const Format: string = 'General');
    procedure Text(const Row, Column : word; const Text : string; const Alignment : TAlignment = taCenter; const FontName : string = 'Arial'; const FontHeight : word = 10; const Format: string = 'General');
    procedure Note(const Row, Column : word; Note : string);
    procedure ColWidth(const FirstColumn, LastColumn, Width : word; const Hiden : boolean = false);
    procedure RowHeight(const RowIndex : word; const Height : word; const Hiden : boolean = false);
  private
    cells         : ^byte;    //written cells
    cellsSize     : integer;
    cellsIdx      : integer;
    fonts         : ^byte;    //used fonts
    fontsSize     : integer;
    fontsIdx      : integer;
    xfs           : ^byte;    //defined cells' formats
    xfsSize       : integer;
    xfsIdx        : integer;
    ColWidths     : ^byte;    //defined columns parameters
    ColWidthSize  : integer;
    ColWidthIdx   : integer;
    RowHeights    : ^byte;    //defined columns parameters
    RowHeightSize : integer;
    RowHeightIdx  : integer;
    Formats       : ^byte;    //defined columns parameters
    FormatsSize   : integer;
    FormatsIdx    : integer;

    procedure   CopyBytes(var DestPtr : pointer; var DestIdx, DestSize : integer; const SrcPtr : pointer; const Count : integer);
 //   function    FindCellPositionInStream(const Col, Row : word; const StartPtr : pointer; const Size : Integer) : pointer;

    procedure   Font(const Height : word; const FontName : string);
    procedure   XF(const Alignment : TAlignment; const FontName : string; const FontHeight : word; const Format: string);
    procedure   Format(const NewFormat: string);

    function    FindFont(Height : word; const FontName : string) : byte;
    function    FindFormat(const WantedFormat: string) : byte;
    function    FindXF(const Alignment : TAlignment; const FontName : string; const FontHeight : word; const Format: string) : word;

end;

implementation

uses
  windows;

procedure TNxXLSDocument.CopyBytes(var DestPtr : pointer; var DestIdx, DestSize : integer; const SrcPtr : pointer; const Count : integer);
var
  cnt, i : integer;
  newPtr : pointer;
begin
  if DestIdx + Count >= DestSize then
  begin
    newPtr := GetMemory(DestSize * 2);
    i := 0;
    CopyBytes(newPtr, i, destSize, DestPtr, DestIdx);
    FreeMem(DestPtr, DestSize);
    DestSize := destSize * 2;
    DestPtr := newPtr;
  end;
  for cnt := 0 to Count - 1 do begin
    Pbyte(integer(DestPtr) + DestIdx)^ := Pbyte(integer(srcPtr) + cnt)^;
    DestIdx := DestIdx + 1;
  end;
end;

procedure TNxXLSDocument.SaveToFile(const FileName : string);
var
  data : array[0..3] of word;
  f : file;
begin
//open file
  AssignFile(f, FileName);
  Rewrite(f, 1);
//write bof record - beginning of file
  data[0] := $209;             //header
  data[1] := 6;
  data[2] := 3;                //version 3.00 - not used in fact
  data[3] := 10;               //worksheet
  //data[4] := 0;              //not used
  BlockWrite(f, data[0], 10);
//write codepage record - actual code page
  data[0] := $42;
  data[1] := 2;
  data[2] := GetACP;
  BlockWrite(f, data[0], 6);
//write precision information (CalcMode, CalcCount, Precision)
  data[0] := $0D;        //CalcMode
  data[1] := 2;
  data[2] := 1;          //1 = automatic, 0 = manual, -1 = Automatic, no tables
  BlockWrite(f, data[0], 6);
  data[0] := $0C;        //CalcCount
  data[1] := 2;
  data[2] := 20;
  BlockWrite(f, data[0], 6);
  data[0] := $0E;        //Precision
  data[1] := 2;
  data[2] := 1;          //0 = precision as displayed, 1 = full precision
  BlockWrite(f, data[0], 6);
//date mode
  data[0] := $22;        //DateMode
  data[1] := 2;
  data[2] := 0;          //0 - base date is 1899-Dec-31
  BlockWrite(f, data[0], 6);
//save defined fonts
  BlockWrite(f, Fonts^, fontsIdx);
//save defined formats
  BlockWrite(f, Formats^, FormatsIdx);
//save defined styles
  BlockWrite(f, xfs^, xfsIdx);
//save defined columns' parameters
  BlockWrite(f, ColWidths^, ColWidthIdx);
//save writen cells
  BlockWrite(f, cells^, cellsIdx);
//write eof record - end of file
  data[0] := $0A;
  data[1] := 0;
  BlockWrite(f, data[0], 4);
//close file
  CloseFile(f);
end;

constructor TNxXLSDocument.Create();
begin
// Get memory for some data.
// Every memory block will be automatically incresed if necessairy.
  cells     := GetMemory(1000); //get memory for cells
  cellsSize := 1000;
  cellsIdx  := 0;
  xfs := GetMemory(160);        //get memory for 10 styles
  xfsSize := 160;
  xfsIdx := 0;
  fonts := GetMemory(200);      //get memory for fonts
  fontsSize := 200;
  fontsIdx := 0;
  ColWidths := GetMemory(160);  //get memory for 10 columns parameters
  ColWidthSize := 160;
  ColWidthIdx := 0;
  RowHeights := GetMemory(160); //get memory for 10 rows parameters
  RowHeightSize := 160;
  RowHeightIdx  := 0;
  Formats := GetMemory(300);    //get memory for defined formats
  FormatsSize := 300;
  FormatsIdx := 0;
//Save some default values.
  Format('General');//idx = 0   //define default formats
  Format('0');      //idx = 1
  Format('0.00');   //idx = 2
  Format('#,##0');
  Format('#,##0.00');
  Format('#,##0\ "z�";\-#,##0\ "z�"');
  Format('#,##0\ "z�";[Red]\-#,##0\ "z�"');
  Format('#,##0.00\ "z�";\-#,##0.00\ "z�"');
  Format('#,##0.00\ "z�";[Red]\-#,##0.00\ "z�"');
  Format('0%');
  Format('0.00%');
  Format('0.00E+00');
  Format('#" "?/?');
  Format('#" "??/??');
  Format('yyyy/mm/dd');
  Format('dd/mmm/yy');
  Format('dd/mmm');
  Format('mmm/yy');
  Format('h:mm\ AM/PM');
  Format('h:mm:ss\ AM/PM');
  Format('hh:mm');
  Format('hh:mm:ss');
  Format('yyyy/mm/dd\ hh:mm');
  XF(taCenter, 'Arial', 10, 'General'); //define default style (it creates also default font: Arial size 10)
end;

destructor TNxXLSDocument.destroy();
begin
  FreeMem(Cells, CellsSize);
  FreeMem(fonts, fontsSize);
  FreeMem(xfs, xfsSize);
  FreeMem(ColWidths, ColWidthSize);
  FreeMem(RowHeights, RowHeightSize);
  FreeMem(Formats, FormatsSize);
  inherited;
end;

//*******************************************
//*             cells records               *
//*******************************************

procedure TNxXLSDocument.IntegerNumber(const Row, Column: integer; Value : int64;
                                     const Alignment : TAlignment = taCenter;
                                     const FontName : string = 'Arial'; const FontHeight : word = 10;
                                     const Format: string = 'General');  //signed integer OK
var
  data : array[0..4] of word;
begin
  if (value and $FFFFFFFFC0000000) <> 0 then begin  //if biger then 30bits value then save as FloatingNumber
    FloatingNumber(Row, Column, Value, Alignment, FontName, FontHeight, Format);
    exit;
  end;
  value := (value shl 2) or 2; //'or 2' for marking as a integer value
  data[0] := $027E;
  data[1] := 10;
  data[2] := row;
  data[3] := column;
  data[4] := FindXf(Alignment, FontName, FontHeight, Format);   //index to XF record
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @data[0], 10);
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @value,   4);
end;

procedure TNxXLSDocument.Text(const Row, Column : word; const Text : string;
                            const Alignment : TAlignment = taCenter;
                            const FontName : string = 'Arial'; const FontHeight : word = 10;
                            const Format: string = 'General');  //text
var
  data : array[0..5] of word;
begin
  data[0] := $204;
  data[1] := 8 + length(text);
  data[2] := Row;
  data[3] := Column;
  data[4] := FindXf(Alignment, FontName, FontHeight, Format);   //index to XF record
  data[5] := length(text);  //16 bit
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @data[0], 12);
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @text[1], length(text));
end;

procedure TNxXLSDocument.FloatingNumber(const Row, Column : word; const Value : double;
                                      const Alignment : TAlignment = taCenter;
                                      const FontName : string = 'Arial'; const FontHeight : word = 10;
                                      const Format: string = 'General');  //floating point number
var
  data : array[0..4] of word;
begin
  data[0] := $203;
  data[1] := 14;
  data[2] := row;
  data[3] := column;
  data[4] := FindXf(Alignment, FontName, FontHeight, Format);   //index to XF record
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @data[0], 10);
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @value,   8);
end;

procedure TNxXLSDocument.Note(const Row, Column : word; Note : string);  //OK
var
  s : string;
  data : array[0..4] of word;
begin
  if length(Note) > 2048 then begin             //if note's length is biger than 2048, then we have to split it into few records.
    s := copy(Note, 2049, length(Note) - 2048);
    delete(Note, 1, 2048)
  end
  else
    s := '';
  data[0] := $1C;
  data[1] := 6 + length(Note);
  data[2] := row;
  data[3] := column;
  data[4] := length(Note) + length(s);
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @data[0], 10);
  CopyBytes(pointer(cells), cellsIdx, cellsSize, @Note[1], length(Note));
  data[2] := $FFFF;
  while s <> '' do begin         //next records if necessary
    Note := s;
    if length(Note) > 2048 then begin
      s := copy(Note, 2049, length(Note) - 2048);
      delete(Note, 1, 2048)
    end
    else
      s := '';
    data[4] := length(Note);
    CopyBytes(pointer(cells), cellsIdx, cellsSize, @data[0], 10);
    CopyBytes(pointer(cells), cellsIdx, cellsSize, @Note[1], length(Note));
  end;
end;

//*******************************************
//*            formatting records           *
//*******************************************

procedure TNxXLSDocument.Format(const NewFormat: string); //And new format of cell (digits, currency etc...)
var
  data : array[0..2] of word;
begin
  data[0] := $1E;
  data[1] := 1 + length(NewFormat);
  data[2] := length(NewFormat);   //8 bit
  CopyBytes(pointer(Formats), FormatsIdx, FormatsSize, @data[0], 5);
  CopyBytes(pointer(Formats), FormatsIdx, FormatsSize, @NewFormat[1], length(NewFormat));
end;

procedure TNxXLSDocument.Font(const height : word; const FontName : string);  //add new font
var
  data : array[0..5] of word;
begin
  data[0] := $231;
  data[1] := 7 + length(FontName);   
  data[2] := height * 20; //unit = 1/20 of point
  data[3] := 0;  //mask
  data[4] := 0;  //color index of black
  data[5] := length(FontName);  //8 bit
  CopyBytes(pointer(fonts), fontsIdx, fontsSize, @data[0], 11);
  CopyBytes(pointer(fonts), fontsIdx, fontsSize, @FontName[1], length(FontName));
end;

procedure TNxXLSDocument.XF(const Alignment : TAlignment;
                          const FontName : string; const FontHeight : word;
                          const Format: string);  //Add new style
var
  data : array[0..7] of word;
begin
  data[0] := $243;
  data[1] := 12;
  data[2] := FindFormat(Format) shl 8 + FindFont(FontHeight, FontName); //index to format record(High Byte), font index (Low Byte)
  data[3] := $1001; //some stuff (flags)
  case Alignment of
    taLeftJustify :  data[4] := 1;
    taRightJustify : data[4] := 3;
    taCenter :       data[4] := 2;
  end;
  data[5] := $CE00; //cell background
  data[6] := 0;     //border lines
  data[7] := 0;
  CopyBytes(pointer(xfs), xfsIdx, xfsSize, @data[0], 16);
end;

procedure TNxXLSDocument.ColWidth(const FirstColumn, LastColumn, Width : word; const Hiden : boolean = false); //set columns' parameters
var
  data : array[0..7] of word;
begin
  data[0] := $7D;
  data[1] := 12;
  data[2] := FirstColumn;
  data[3] := LastColumn;
  data[4] := 37 * Width;
  data[5] := 0;
  if Hiden then
    data[6] := 1
  else
    data[6] := 0;
  //data[7] := 0;  //not used
  CopyBytes(pointer(ColWidths), ColWidthIdx, ColWidthSize, @data[0], 16);
end;

procedure TNxXLSDocument.RowHeight(const RowIndex : word; const Height : word; const Hiden : boolean);
//  var
//    data : array[0..9] of word;
  begin
{    data[0] := $208;
    data[1] := 16;
    data[2] := RowIndex;
    data[3] := 0;
    data[4] := 1;
    data[5] := (Height * 20) or ($8000);
//  data[6] := 0;  //not used
    data[7] := 0;  //this is not quiet correct :-/
    if hiden then
      data[8] := $0100
    else
      data[8] := $0120;
    data[9] := 0;
    CopyBytes(pointer(RowHeights), RowHeightIdx, RowHeightSize, @data[0], 20);}
  end;

//*******************************************
//*            formatting finders           *
//*******************************************

function TNxXLSDocument.FindXF(const Alignment : TAlignment;
                             const FontName : string; const FontHeight : word;
                             const Format: string) : word;    //find style
  var
    idx : integer;
    FormatFont : word;
    AlignmentValue : word;
  begin
    case Alignment of
      taLeftJustify :  AlignmentValue := 1;
      taRightJustify : AlignmentValue := 3;
      else       AlignmentValue := 2;
    end;
    FormatFont := FindFormat(Format) shl 8 + FindFont(FontHeight, FontName);
    idx := 0;
    result := 0;
    while idx < xfsIdx do begin
      if (Pword(integer(xfs) + idx + 4)^ = formatFont) and  //check format and font
         (Pword(integer(xfs) + idx + 8)^ and 7 = AlignmentValue) then //check horizontal Alignment
        exit;
      result := result + 1; //point at next style, witch will be checked in next iteration.
      idx := idx + 16; //point at next style record.
      if result = 0 then    //if result = 0 then there's no place for next styles. Default will be used.
        exit;
    end;
    XF(Alignment, FontName, FontHeight, Format);  //add new style and exit;
  end;

function TNxXLSDocument.FindFont(Height : word; const FontName : string) : byte;
  var
    idx : integer;
    b   : byte;
  begin
    result := 0;
    idx := 0;
    height := height * 20;
    while idx < fontsIdx do begin
      if (Pword(integer(fonts) + idx + 4)^ = height) and (length(FontName) = Pbyte(integer(fonts) + idx + 10)^) then  //check height and names' lengths
        for b := 1 to Pbyte(integer(fonts) + idx + 10)^ do begin  //check font name
          if chr(Pbyte(integer(fonts) + idx + 10 + b)^) <> FontName[b] then  //if letters are different, then go to next font
            break;
          if (b = Pbyte(integer(fonts) + idx + 10)^) then //if letters are the same, and it's last letter, then we've got our font! :)
            exit;
        end;
      result := result + 1; //point to next font, witch will be checked in next iteration.
      if result = 4 then  //font 4 is skipped
        result := 5;
      idx := idx + 11 + Pbyte(integer(fonts) + idx + 10)^; //point at next font record.
      if result = 0 then    //if result = 0 then there's no place for next fonts. Default will be used.
        exit;
    end;
    Font(Height div 20, FontName) //add new font and exit.
  end;

function TNxXLSDocument.FindFormat(const WantedFormat: string) : byte;
  var
    idx : integer;
    b   : byte;
  begin
    result := 0;
    idx := 0;
    while idx < FormatsIdx do begin
      if length(WantedFormat) = Pbyte(integer(Formats) + idx + 4)^ then  //check names' lengths
        for b := 1 to Pbyte(integer(Formats) + idx + 4)^ do begin  //check format name
          if chr(Pbyte(integer(Formats) + idx + 4 + b)^) <> WantedFormat[b] then  //if letters are different, then go to next format
            break;
          if (b = Pbyte(integer(Formats) + idx + 4)^) then //if letters are the same, and it's last letter, then we've got our format! :)
            exit;
        end;
      result := result + 1; //point to next format, witch will be checked in next iteration
      idx := idx + 5 + Pbyte(integer(Formats) + idx + 4)^; //point at next format record
      if result = 0 then    //if result = 0 then there's no place for next formats. Default will be used.
        exit;
    end;
    Format(WantedFormat) //add new format and exit.
  end;

end.
