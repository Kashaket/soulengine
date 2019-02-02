{
  Next DBGrid
  Copyright (C) 1996-2006 by Berg
  All rights reserved.

  $id:NxDBCommon.pas bn
}

{$I ..\NxSuite.inc}

unit NxDBCommon;

interface

uses
  Classes, Graphics, DB, {ADODB,} Jpeg;

function GetADOBlobGraphic(Field: TBlobField; AScale: TJPEGScale; APerformance: TJPEGPerformance): TGraphic;
function GetBlobGraphic(Field: TBlobField): TGraphic;

implementation

uses SysUtils;

function GetBlobGraphic(Field: TBlobField): TGraphic;
var
  DrawPict: TPicture;
  MemStream: TMemoryStream;
begin
  {$IFDEF DELPHI2009UP}
  if Pos('JFIF', Copy(Field.AsString, 1, 10)) = 7 then { jpeg? }
  {$ELSE}
  if Pos('JFIF', Copy(Field.Value, 1, 10)) = 7 then { jpeg? }
  {$ENDIF}
  begin
    MemStream := TMemoryStream.Create;
    Field.SaveToStream(MemStream);
    MemStream.Seek(soFromBeginning, 0);
    Result := TJPEGImage.Create;
    Result.LoadFromStream(MemStream);
  end else
  begin
    DrawPict := TPicture.Create;
    DrawPict.Assign(TBlobField(Field));
    Result := DrawPict.Graphic;
  end;
end;

function JpegStartsInBlob(PicField: TBlobField): Integer;
var
  BlobStream: TStream;
  buffer: Word;
  hx: string;
begin
  Result := -1;
  BlobStream := PicField.DataSet.CreateBlobStream(PicField, bmRead);
  try
    while (Result = -1) and (BlobStream.Position + 1 < BlobStream.Size) do
    begin
      BlobStream.ReadBuffer(buffer, 1);
      hx := IntToHex(buffer, 2);
      if hx = 'FF' then
      begin
        BlobStream.ReadBuffer(buffer, 1);
        hx := IntToHex(buffer, 2);
        if hx = 'D8' then Result := BlobStream.Position - 2
        else if hx = 'FF' then BlobStream.Position := BlobStream.Position - 1;
      end;
    end;
  finally
    BlobStream.Free;
  end;
end;

function GetADOBlobGraphic(Field: TBlobField; AScale: TJPEGScale;
  APerformance: TJPEGPerformance): TGraphic;
var
  BlobStream: TStream; // TADOBlobStream;
begin
  BlobStream := Field.DataSet.CreateBlobStream(Field, bmRead); //  BlobStream := TADOBlobStream.Create(Field, bmRead);
  try
    BlobStream.Seek(JpegStartsInBlob(Field), soFromBeginning);
    try
      Result := TJPEGImage.Create;
      Result.LoadFromStream(BlobStream);
      with Result as TJPEGImage do
      begin
        Performance := APerformance;
        Scale := AScale;
      end;
    finally
      Result := nil;
    end;
  finally
    BlobStream.Free
  end;
end;

end.
