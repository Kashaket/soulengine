{-----------------------------------------------------------}
{----Purpose : Pure Virtual Dataset.                        }
{    By      : Ir. G.W. van der Vegt                        }
{    For     : Myself                                       }
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 19032001-Created.                                         }
{         -Based on TextDataSet Sample by Borland.          }
{         -Added Events for retrieving data and field       }
{          definitions.                                     }
{         -Added OleVariant as exchange datatype.           }
{         -Separated proptotypes for record & field count   }
{          events.                                          }
{ 20032001-Init data inside constructor.                    }
{         -Added Bitmaps as Blob.                           }
{         -Corrected RowNumber retrieval for blobs to       }
{          be the RecNo instead of buffer content.          }
{ 21032001-Blob Sync problem seem to be cured when toggling }
{          active off/on an extra time. It also seems to be }
{          related to the -1 crack recordnumber.            }
{         -Better fix seems to set the current record to 0  }
{          if there are records.                            }
{         -No more retrieval of blobs in GetFieldData       }
{          (target buffer is nil in such case).             }
{         -Found source of startup errors to be the fact    }
{          that TDBImage had a DataSet property but no      }
{          DataField property. Setting them both on runtime }
{          cured the problem.                               }
{ 20102006-Fixed minor bug in GetFieldData (type of         }
{          variant for word was wrong).                     }
{         -Renamed to NxVirtualDataSet.                     }
{         -Started on Write Support.                        }
{ 24102006-Changed parameters of SetField events and        }
{          splitted them into two separate ones, one for    }
{          fieldcaching and one for the operation.          }
{          This eliminates invalid paramters.               }
{-----------------------------------------------------------}
{ nr.    todo                                               }
{ ------ -------------------------------------------------- }
{ 1.     -Bind with RTTI and other (TPersistent) objects.   }
{ 2.     -Have a look into Calculated Fields.               }
{ 3.     -Precision for BCD Datatypes.                      }
{ 4.     -Add Filtering.                                    }
{ 5.     -Add Write Support.                                }
{-----------------------------------------------------------}

{: TNxVirtualDataSet, a totally virtual descendant of TDataSet implements a
   totally Virtual Dataset. Where other 'Virtual' Datasets still
   need the table to be defined at designtime, TNxVirtualDataSet also virtualizes
   that. So besides virtualizing data, TNxVirtualDataSet also virtualizes
   FieldCount, Field Defintion and RecordCount.

   Note that TNxVirtualDataSet has no notion of rows & buffering, it just calls
   the supplier for data whever it needs data for a particular field of a record. }
unit NxVirtualDataSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ComCtrls, ActiveX, Variants;

{$DEFINE VER200}
{$DEFINE RW}
{$IFDEF RW}
{$MESSAGE HINT 'TNxVirtualDataSet Experimental, Unsupported and Unfinished Read/Write mode.'}
{$ELSE RW}
{$MESSAGE HINT 'TNxVirtualDataSet in Read-only mode.'}
{$ENDIF RW}

{$IFDEF VER200}
  {$DEFINE DELPHI2009}
{$ENDIF}

type
{$IFDEF VER200}
  TNxRecordBuffer = TRecordBuffer;
{$ELSE}
  TNxRecordBuffer = PChar;
{$ENDIF}

  {: Used for Bookmarks. }
  PRecInfo = ^TRecInfo;
  {: Used for Bookmarks. }
  TRecInfo = packed record
    Bookmark: Integer;
    BookmarkFlag: TBookmarkFlag;
  end;

  {: Used for Bookmarks. }
  PRec = ^TRec;

  {: Used for Buffering Records. }
  TRec = packed record
    Index: Integer;
    Info: TRecInfo;
  end;

type
  {: This function needs to return the number of
     records present in the VirtualDataset. }
  TNxOnRecordCount = function(Sender: TObject): Integer of object;
  {: This function needs to return the fieldcount. }
  TNxOnFieldCount = function(Sender: TObject): Integer of object;
  {: This function needs to return valid TFieldDef data as required by
   other Delphi Database Components. }
  TNxOnAddField = procedure(Sender: TObject; const fieldIndex: Integer; var
    fieldName: string; var fieldSize: Integer; var DataType: TFieldType) of
    object;
  {: This function should return all non Blob Data. }
  TNxOnGetFieldData = function(Sender: TObject; const rowIndex, fieldIndex:
    Integer): OleVariant of object;
  {: This function should return Blob Data. }
  TNxOnGetBlobData = function(Sender: TObject; const rowIndex, fieldIndex:
    Integer): TStream of object;

  TNxDbUpdateMode = (umBrowse, umEdit, umInsert, umAppend, umCancel, umPost,
    umDelete);
  TNxDbUpdateModes = set of TNxDbUpdateMode;

{$IFDEF RW}
  {: This function should return all non Blob Data. }
  TNxOnSetFieldMode = procedure(Sender: TObject; const rowIndex: Integer; const
    updateModes: TNxDbUpdateModes) of object;
  TNxOnSetFieldData = procedure(Sender: TObject; const fieldIndex: Integer; const
    value: OleVariant) of object;
{$ENDIF}

type
  {: TNxVirtualDataSet implements a totally Virtual Dataset.
     Where other 'Virtual' Datasets still need the table to be defined at designtime,
     TNxVirtualDataSet also virtualizes that.
     So besides virtualizing data, TNxVirtualDataSet also virtualizes FieldCount, Field Defintion
     and RecordCount.}
  TNxVirtualDataSet = class(TDataSet)
  private
    FUpdateModes: TnxDbUpdateModes;
    FCurRec: Integer;
    FLastBookmark: Integer;
    FOnAddField: TNxOnAddField;
    FOnGetBlobData: TNxOnGetBlobData;
    FOnFieldCount: TNxOnFieldCount;
    FOnGetFieldData: TNxOnGetFieldData;
    FOnRecordCount: TNxOnRecordCount;
{$IFDEF RW}
    FOnSetFieldData: TNxOnSetFieldData;
    FOnSetFieldMode: TNxOnSetFieldMode;
    FReadOnly: boolean;
{$ENDIF}
  protected
    {: For internal use. See TDataSet. }
    function AllocRecordBuffer: TNxRecordBuffer; override;
    {: For internal use. See TDataSet. }
    procedure FreeRecordBuffer(var Buffer: TNxRecordBuffer); override;
    {: For internal use. See TDataSet. }
    procedure GetBookmarkData(Buffer: TNxRecordBuffer; Data: Pointer); override;
    {: For internal use. See TDataSet. }
    function GetBookmarkFlag(Buffer: TNxRecordBuffer): TBookmarkFlag; override;
    {: Additional overrides (optional). TNxVirtualDataSet signals a Read-only DataSet. }
    function GetCanModify: Boolean; override;
    {: Additional overrides (optional). TNxVirtualDataSet returns its internal RecordCounter. }
    function GetRecNo: Integer; override;
    {: For internal use. See TDataSet. }
    function GetRecord(Buffer: TNxRecordBuffer; GetMode: TGetMode; DoCheck: Boolean):
      TGetResult; override;
    {: Additional overrides (optional). TNxVirtualDataSet calls its OnRecorCount event here. }
    function GetRecordCount: Integer; override;
    {: For internal use. See TDataSet. }
    function GetRecordSize: Word; override;
    {: For internal use. See TDataSet. }
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    {: For internal use. See TDataSet. }
    procedure InternalCancel; override;
    {: For internal use. See TDataSet. }
    procedure InternalClose; override;
    {: For internal use. See TDataSet. }
    procedure InternalDelete; override;
    {: For internal use. See TDataSet. }
    procedure InternalEdit; override;
    {: For internal use. See TDataSet. }
    procedure InternalFirst; override;
    {: For internal use. See TDataSet. }
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    {: For internal use. See TDataSet. }
    procedure InternalHandleException; override;
    {: For internal use. See TDataSet. }
    procedure InternalInitFieldDefs; override;
    {: For internal use. See TDataSet. }
    procedure InternalInitRecord(Buffer: TNxRecordBuffer); override;
    {: For internal use. See TDataSet. }
    procedure InternalInsert; override;
    {: For internal use. See TDataSet. }
    procedure InternalLast; override;
    {: For internal use. See TDataSet. }
    procedure InternalOpen; override;
    {: For internal use. See TDataSet. }
    procedure InternalPost; override;
    {: For internal use. See TDataSet. }
    procedure InternalSetToRecord(Buffer: TNxRecordBuffer); override;
    {: For internal use. See TDataSet. }
    function IsCursorOpen: Boolean; override;
    {: For internal use. See TDataSet. }
    procedure SetBookmarkData(Buffer: TNxRecordBuffer; Data: Pointer); override;
    {: For internal use. See TDataSet. }
    procedure SetBookmarkFlag(Buffer: TNxRecordBuffer; Value: TBookmarkFlag); override;
    {: For internal use. See TDataSet. }
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    {: Additional overrides (optional). TNxVirtualDataSet set its internal RecordCounter. }
    procedure SetRecNo(Value: Integer); override;
  public
    {: Contructor. }
    constructor Create(AOwner: TComponent); override;
    {: Additional overrides. See TDataSet. }
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
      override;
    {: Additional overrides. See TDataSet. }
    function GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData):
      Integer; override;
    {: Additional overrides. See TDataSet. }
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    {: Additional overrides. See TDataSet. }
    function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat:
      Boolean): Boolean; override;
    {: Additional overrides. See TDataSet. }
    procedure SetFieldData(Field: TField; Buffer: Pointer; NativeFormat:
      Boolean); overload; override;
  published
    {: Activates or deactivaties the TNxVirtualDataSet. }
    property Active;
{$IFDEF RW}
    property ReadOnly: boolean read FReadOnly write FReadOnly default True;
{$ENDIF}
    {: Called once for each field in the VirtualDataset. It needs to return
       valid TFieldDef as required by other Delphi Database Components. }
    property OnAddField: TNxOnAddField read FOnAddField write FOnAddField;
    {: Called whenever Blob Data is needed. This function can be called
       frequently so needs to be efficient. The basis way to turn for instance
       an image into a blob is:

       Result := TMemoryStream.Create;
       try
          b:=TBitmap.Create;
          b.Width      :=640;
          b.Height     :=240;
          b.PixelFormat:=pf32bit;

           //Fill the Bitmap here.

          b.SaveToStream(Result);
          b.Free;
       finally
     end; }
    property OnGetBlobData: TNxOnGetBlobData read FOnGetBlobData write
      FOnGetBlobData;
    {: Called whenever the fieldcount is needed.
       This function is called directly after the VirtualDataset is opened and
       is followed by a number of OnAddField calls. }
    property OnFieldCount: TNxOnFieldCount read FOnFieldCount write
      FOnFieldCount;
    {: Called whenever Non Blob Data is needed. This function can be called
       frequently so needs to be efficient. }
    property OnGetFieldData: TNxOnGetFieldData read FOnGetFieldData write
      FOnGetFieldData;
    {: Called whenever the recordcount is needed. It needs to return the number of
       records present in the VirtualDataset. }
    property OnRecordCount: TNxOnRecordCount read FOnRecordCount write
      FOnRecordCount;
{$IFDEF RW}
    {: Called whenever Non Blob Data is written. This function can be called
       frequently so needs to be efficient. }
    property OnSetFieldData: TNxOnSetFieldData read FOnSetFieldData write
      FOnSetFieldData;
    {: Called whenever Non Blob Data is written to signal the Mode of operation. }
    property OnSetFieldMode: TNxOnSetFieldMode read FOnSetFieldMode write
      FOnSetFieldMode;
{$ENDIF}
  end;

implementation

uses
  FmtBcd, SqlTimSt;

const
  SUsupportedFieldType = 'Unsupported field type (%s) in field %s';

function VarDataSize(const Value: OleVariant): Integer;
begin
  if VarIsNull(Value) then
    Result := -1
  else if VarIsArray(Value) then
    Result := VarArrayHighBound(Value, 1) + 1
  else if TVarData(Value).VType = varOleStr then
    Result := Length(PWideString(@TVarData(Value).VOleStr)^)
  else
    Result := SizeOf(OleVariant);
end;

{ TNxVirtualDataSet }

constructor TNxVirtualDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCurRec := -1;
  FUpdateModes := [umBrowse];

  FLastBookmark := 0;

  FOnRecordCount := nil;
  FOnFieldCount := nil;
  FOnAddField := nil;
  FOnGetFieldData := nil;
  FOnGetBlobData := nil;

  Active := False;
end;

{: TDataSet calls this method to allocate the record buffer.  Here we use
   FRecBufSize which is equal to the size of the data plus the size of the
   TRecInfo structure. }

function TNxVirtualDataSet.AllocRecordBuffer: TNxRecordBuffer;
begin
  GetMem(Result, SizeOf(TRec));
  ZeroMemory(Result, Sizeof(TRec));
end;

{: Here we copy the data from the record buffer into a field's buffer.
   This function, and SetFieldData, are more complex when supporting
   calculated fields, filters, and other more advanced features.
   See TBDEDataSet for a more complete example. }

function TNxVirtualDataSet.CreateBlobStream(Field: TField; Mode:
  TBlobStreamMode): TStream;
var
  rowIndex: Integer;
begin
  { TODO -oveg -curgent : Problem here, what is the correct recordnumber? }
  rowIndex := GetRecNo() - 1;
  //OutputDebugString(PChar(Format('Creating BlobStream[%d,%d]', [rowIndex, Field.Index])));
  if Assigned(FOnGetBlobData) and (Mode = bmRead) then
    Result := FOnGetBlobData(Self, rowIndex, Field.Index)
  else
    Result := nil;
end;

{: Again, TDataSet calls this method to free the record buffer.
   Note: Make sure the value of FRecBufSize does not change before all
   allocated buffers are freed. }

procedure TNxVirtualDataSet.FreeRecordBuffer(var Buffer: TNxRecordBuffer);
begin
  FreeMem(Buffer, SizeOf(TRec));
end;

function TNxVirtualDataSet.GetBlobFieldData(FieldNo: Integer;
  var Buffer: TBlobByteData): Integer;
begin
  Result := inherited GetBlobFieldData(FieldNo, Buffer);
end;

{: These methods provide a way to read and write bookmark data into the
   record buffer without actually repositioning the current record }
{$IFDEF DELPHI2009}
procedure TNxVirtualDataSet.GetBookmarkData(Buffer: TRecordBuffer;
  Data: Pointer);
{$ELSE}
procedure TNxVirtualDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
{$ENDIF}
begin
  PInteger(Data)^ := PRec(Buffer)^.Info.Bookmark;
end;

{: Bookmark flags are used to indicate if a particular record is the first
   or last record in the dataset.  This is necessary for "crack" handling.
   If the bookmark flag is bfBOF or bfEOF then the bookmark is not actually
   used; InternalFirst, or InternalLast are called instead by TDataSet. }

function TNxVirtualDataSet.GetBookmarkFlag(Buffer: TNxRecordBuffer): TBookmarkFlag;
begin
  Result := PRec(Buffer)^.Info.BookmarkFlag;
end;

function TNxVirtualDataSet.GetCanModify: Boolean;
begin
{$IFDEF RW}
  Result := not FReadOnly;
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TNxVirtualDataSet.GetFieldData(Field: TField; Buffer: Pointer):
  Boolean;
begin
  Result := GetFieldData(Field, Buffer, True);
end;

function TNxVirtualDataSet.GetFieldData(Field: TField; Buffer: Pointer;
  NativeFormat: Boolean): Boolean;
var
  Data: OleVariant;
  aRec: PRec;

  procedure CurrToBuffer(const C: Currency);
  begin
    if NativeFormat then
      DataConvert(Field, @C, Buffer, True)
    else
      Currency(Buffer^) := C;
  end;

  procedure VarToBuffer;
  begin
    with tagVariant(Data) do
      case Field.DataType of
        ftGuid, ftFixedChar, ftString:
          begin
            PChar(Buffer)[Field.Size] := #0;
            WideCharToMultiByte(0, 0, bStrVal, SysStringLen(bStrVal) + 1,
              Buffer, Field.Size, nil, nil);
          end;
        ftWideString:
          begin
            VarDataSize(Data);
            WideString(Buffer^) := bStrVal;
          end;
        ftSmallint:
          SmallInt(Buffer^) := iVal;
        ftWord:
          Word(Buffer^) := uiVal;
        ftAutoInc, ftInteger:
          Integer(Buffer^) := lVal;
        ftFloat, ftCurrency:
          if vt = VT_R8 then
            Double(Buffer^) := dblVal
          else
            Double(Buffer^) := Data;
        ftBCD:
          if vt = VT_CY then
            CurrToBuffer(cyVal)
          else
            CurrToBuffer(Data);
        ftBoolean:
          WordBool(Buffer^) := vbool;
        ftDate, ftTime, ftDateTime:
          if NativeFormat then
            DataConvert(Field, @date, Buffer, True)
          else
            TOleDate(Buffer^) := date;
        ftBytes, ftVarBytes:
          if NativeFormat then
            DataConvert(Field, @Data, Buffer, True)
          else
            OleVariant(Buffer^) := Data;
        ftInterface: IUnknown(Buffer^) := Data;
        ftIDispatch: IDispatch(Buffer^) := Data;
        ftLargeInt: LargeInt(Buffer^) := Decimal(Data).Lo64;
        ftBlob..ftTypedBinary, ftVariant: OleVariant(Buffer^) := Data;
      else
        DatabaseErrorFmt(SUsupportedFieldType, [FieldTypeNames[Field.DataType],
          Field.DisplayName]);
      end;
  end;

begin
  if Assigned(FOnGetFieldData) and (Buffer <> nil) and ( Buffers[ ActiveRecord ] > -1 ) then
    //Don't bother fetching if the target buffer is nil!
  begin
    { TODO -oveg -ctodo : We have some troubles with TNextDbGrid here. }
    aRec := PRec(ActiveBuffer);
    Data := FOnGetFieldData(Self, aRec.Index, Field.Index);
    Result := not VarIsNull(Data);
    if Result then
    begin
      //OutputDebugString(Pchar(Format('Field[%d,%d]=%s',[PRec(ActiveBuffer)^.Index,Field.Index,Data])));
      VarToBuffer;
    end;
  end
  else
    Result := (Buffer = nil); //For IsNull test.
end;

function TNxVirtualDataSet.GetRecNo: Longint;
begin
  UpdateCursorPos;
  if (FCurRec = -1) and (RecordCount > 0) then
    Result := 1
  else
    Result := FCurRec + 1;
end;

{: This multi-purpose function does 3 jobs.  It retrieves data for either
   the current, the prior, or the next record.  It must return the status
   (TGetResult), and raise an exception if DoCheck is True. }

{$IFDEF DELPHI2009}
function TNxVirtualDataSet.GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
{$ELSE}
function TNxVirtualDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
{$ENDIF}
begin
  if (RecordCount < 1) then
    Result := grEOF
  else
  begin
    Result := grOK;
    case GetMode of
      gmNext:
        if FCurRec >= RecordCount - 1 then
          Result := grEOF
        else
          Inc(FCurRec);
      gmPrior:
        if FCurRec <= 0 then
          Result := grBOF
        else
          Dec(FCurRec);
      gmCurrent:
        if (FCurRec < 0) or (FCurRec >= RecordCount) then
          Result := grError;
    end;
    if Result = grOK then
    begin
      PRec(Buffer)^.Index := FCurRec;
      with PRec(Buffer)^.Info do
      begin
        BookmarkFlag := bfCurrent;
        Bookmark := FCurRec;
      end;
    end
    else if (Result = grError) and DoCheck then
      DatabaseError('No Records');
  end;
end;

{ Optional Methods }
{ ================ }

{: The following methods are optional.  When provided they will allow the
   DBGrid and other data aware controls to track the current cursor postion
   relative to the number of records in the dataset.  Because we are dealing
   with a small, static data store (a stringlist), these are very easy to
   implement.  However, for many data sources (SQL servers), the concept of
   record numbers and record counts do not really apply. }

function TNxVirtualDataSet.GetRecordCount: Longint;
begin
  if Assigned(fOnRecordCount) then
    Result := fOnRecordCount(Self)
  else
    Result := 0; //-1 is same as inherited count
  //Result := FData.Items.Count;
end;

{ Record / Field Access }
{ ===================== }

{: This method returns the size of just the data in the record buffer.
   Do not confuse this with RecBufSize which also includes any additonal
   structures stored in the record buffer (such as TRecInfo). }

function TNxVirtualDataSet.GetRecordSize: Word;
begin
  Result := SizeOf(Integer);
end;

{: This method is similar to InternalPost above, but the operation is always
   an insert or append and takes a pointer to a record buffer as well. }

procedure TNxVirtualDataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
{$IFDEF RW}
  { TODO -oveg -cComment : Unused, never called! }
  { TODO -oveg -cComment : Ignored, Raise Exception if called }
  {
    FSaveChanges := True;
    Inc(FLastBookmark);
    if Append then InternalLast;
    FData.InsertObject(FCurRec, PChar(Buffer), Pointer(FLastBookmark));
  }
  if Append then
    InternalLast;

  if Append then
    FUpdateModes := [umAppend]
  else
    FUpdateModes := [umEdit];

  FCurRec := CurrentRecord;
{$ENDIF RW}
end;

{: Write any edits to disk and free the managing string list. }

procedure TNxVirtualDataSet.InternalClose;
begin
  //if FSaveChanges then FData.SaveToFile(FileName);

    { Destroy the TField components if no persistent fields }
  if DefaultFields then
    DestroyFields;

  { Reset these internal flags }
  FLastBookmark := 0;
  FCurRec := -1;
end;

{: This method is called by TDataSet.Delete to delete the current record. }

procedure TNxVirtualDataSet.InternalDelete;
begin
{$IFDEF RW}
  { TODO -oveg -cComment : Ignored, Raise Exception if called }
  (*
    FSaveChanges := True;
    FData.Delete(FCurRec);
    if FCurRec >= FData.Count then
      Dec(FCurRec);
  *)
  fUpdateModes := [umDelete];
  if Assigned(FOnSetFieldMode) then
    FOnSetFieldMode(Self, FCurRec, FUpdateModes);

  if FCurRec >= RecordCount then
    Dec(FCurRec);

  fUpdateModes := [umBrowse];
{$ENDIF RW}
end;

{ Record Navigation / Editing }
{ =========================== }

{: This method is called by TDataSet.First.  Crack behavior is required.
   That is we must position to a special place *before* the first record.
   Otherwise, we will actually end up on the second record after Resync
   is called. }

procedure TNxVirtualDataSet.InternalFirst;
begin
  FCurRec := -1;
  FLastBookmark := FCurRec; //test!
end;

{ Bookmarks }
{ ========= }

{: In this sample the bookmarks are stored in the Object property of the
   TStringList holding the data.  Positioning to a bookmark just requires
   finding the offset of the bookmark in the TStrings.Objects and using that
   value as the new current record pointer. }

procedure TNxVirtualDataSet.InternalGotoBookmark(Bookmark: Pointer);
begin
  if Assigned(BookMark) then
    FCurRec := PInteger(BookMark)^
  else
    DatabaseError('Bookmark not found');
end;

{: This is the exception handler which is called if an exception is raised
   while the component is being stream in or streamed out.  In most cases this
   should be implemented useing the application exception handler as follows. }

procedure TNxVirtualDataSet.InternalHandleException;
begin
  Application.HandleException(Self);
end;

{: For this simple example we just create one FieldDef, but a more complete
   TDataSet implementation would create multiple FieldDefs based on the
   actual data. }

procedure TNxVirtualDataSet.InternalInitFieldDefs;

  procedure AddFieldDef(fieldName: string; fieldSize: Integer;
    {fieldPrecision: Integer; }fieldType: TFieldType; FieldDefs: TFieldDefs);
  var
    FieldDef: TFieldDef;
    I: Integer;
    FName: string;
    FSize: Integer;
    FPrecision: Integer;
  begin
    if FieldType <> ftUnknown then
    begin
      FSize := 0;
      FPrecision := 0;
      FieldDef := FieldDefs.AddFieldDef;
      with FieldDef do
      begin
        FieldNo := FieldDefs.Count;
        I := 0;
        FName := fieldName;
        while (FName = '') or (FieldDefs.IndexOf(FName) >= 0) do
        begin
          Inc(I);
          if fieldName = '' then
            FName := Format('COLUMN%d', [I])
          else { Do not localize }
            FName := Format('%s_%d', [fieldName, I]);
        end;
        Name := FName;
        case FieldType of
          ftString, ftWideString, ftBytes, ftVarBytes, ftFixedChar:
            FSize := fieldSize; //F.DefinedSize;
          ftBCD:
            begin
              {
                            FPrecision := fieldPrecision;
                            FSize := ShortInt(F.NumericScale);
                            if FSize < 0 then FSize := 4;
              }
            end;
          ftInteger:
            begin
              {
                            if HasAutoIncProp and (F.Properties[SIsAutoInc].Value = True) then
                              FieldType := ftAutoInc;
              }
            end;
          ftGuid:
            FSize := 38;
        end;
        DataType := FieldType;
        Size := FSize;
        Precision := FPrecision;
        Attributes := Attributes + [faRequired];
        if (DataType = ftDataSet) and (Fields.Count = 0) then
          ObjectView := True;
      end;
    end;
  end;

var
  I: Integer;
  fieldName: string;
  fieldDataType: TFieldType;
  fieldSize: Integer;
begin
  FieldDefs.Clear;

  { TODO -oveg -cUrgent : Bind with RTTI in EventHandler }

  if Assigned(fOnFieldCount) and Assigned(fOnAddField) then
    for I := 1 to fOnFieldCount(Self) do
    begin
      FOnAddField(Self, I - 1, fieldName, fieldSize, fieldDataType);
      AddFieldDef(fieldName, fieldSize, fieldDataType, FieldDefs);
    end;
end;

{: This routine is called to initialize a record buffer.  In this sample,
   we fill the buffer with zero values, but we might have code to initialize
   default values or do other things as well. }

procedure TNxVirtualDataSet.InternalInitRecord(Buffer: TNxRecordBuffer);
begin
  FillChar(Buffer^, RecordSize, 0);
end;

{: Again, we position to the crack *after* the last record here. }

procedure TNxVirtualDataSet.InternalLast;
begin
  FCurRec := RecordCount;
end;

procedure TNxVirtualDataSet.InternalOpen;
begin
  FLastBookMark := RecordCount;

  { Initialize our internal position.
    We use -1 to indicate the "crack" before the first record. }
{ DONE -oveg -curgent : Set Currrent Record to 0 if there are records Fixes Blob Sync Problem. }
  if (RecordCount = 0) then
    FCurRec := -1
  else
    FCurRec := 0;

  { Tell TDataSet how big our Bookmarks are (REQUIRED) }
  BookmarkSize := SizeOf(Integer); //is TRecInfo.BookMark.

  { Initialize the FieldDefs }
  InternalInitFieldDefs;

  { Create TField components when no persistent fields have been created }
  if DefaultFields then
    CreateFields;

  { Bind the TField components to the physical fields }
  BindFields(True);
end;

{: This method is called by TDataSet.Post.  Most implmentations would write
   the changes directly to the associated datasource, but here we simply set
   a flag to write the changes when we close the dateset. }

procedure TNxVirtualDataSet.InternalPost;
var
  aRec: PRec;
begin
{$IFDEF RW}
  { TODO -oveg -cComment : Ignored, Raise Exception if called}
  (*
    FSaveChanges := True;
    { For inserts, just update the data in the string list }
    if State = dsEdit then FData.Items[FCurRec] := ActiveBuffer else
    begin
      { If inserting (or appending), increment the bookmark counter and
        store the data }
      Inc(FLastBookmark);
      FData.InsertObject(FCurRec, ActiveBuffer, Pointer(FLastBookmark));
    end;
    *)

  if State = dsInsert then
    Inc(FLastBookmark);

  aRec := PRec(ActiveBuffer);

  case (State) of
    dsInsert: FCurRec := FLastBookmark;
    dsEdit: FCurRec := aRec.Index;
  end;

  if (fUpdateModes = [umAppend]) then
    FCurRec := RecordCount;

  if Assigned(FOnSetFieldMode) then
    FOnSetFieldMode(Self, FCurRec, fUpdateModes + [umPost]);

  FUpdateModes := [umBrowse];
{$ENDIF RW}
end;

{: This function does the same thing as InternalGotoBookmark, but it takes
   a record buffer as a parameter instead. }

procedure TNxVirtualDataSet.InternalSetToRecord(Buffer: TNxRecordBuffer);
begin
  InternalGotoBookmark(@PRec(Buffer)^.Info.Bookmark);
end;

{: This property is used while opening the dataset.
   It indicates if data is available even though the
   current state is still dsInActive. }

function TNxVirtualDataSet.IsCursorOpen: Boolean;
begin
  Result := Assigned(FOnRecordCount) and
    Assigned(FOnFieldCount) and
    Assigned(FOnAddField) and
    Assigned(FOnGetFieldData); //Don't bother on FOnGetBlobData here
end;

procedure TNxVirtualDataSet.SetBookmarkData(Buffer: TNxRecordBuffer; Data: Pointer);
begin
  PRec(Buffer)^.Info.Bookmark := PInteger(Data)^;
end;

procedure TNxVirtualDataSet.SetBookmarkFlag(Buffer: TNxRecordBuffer; Value:
  TBookmarkFlag);
begin
  PRec(Buffer)^.Info.BookmarkFlag := Value;
end;

procedure TNxVirtualDataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  SetFieldData(Field, Buffer, True);
end;

procedure TNxVirtualDataSet.SetFieldData(Field: TField; Buffer: Pointer;
  NativeFormat: Boolean);
{$IFDEF RW}
var
  Data: OleVariant;

  {: Work in progress! }

  function BufferToVar: Boolean;
  var
    Value: Currency;
    TimeStamp: TTimeStamp;
  begin
    Result := true;
    case Field.DataType of
      ftUnknown:
        DatabaseErrorFmt(SUsupportedFieldType, [FieldTypeNames[Field.DataType],
          Field.DisplayName]);
      ftString,
        ftFixedChar:
        {$IFDEF DELPHI2009}
        Data := StrPas(PWideChar(Buffer));
        {$ELSE}
        Data := StrPas(PAnsiChar(Buffer));
        {$ENDIF}
      ftWord:
        Data := Word(Buffer^);
      ftSmallint:
        Data := Smallint(Buffer^);
      ftInteger,
        ftAutoInc:
        Data := Integer(Buffer^);
      ftTime:
        begin
          TimeStamp.Time := LongInt(Buffer^);
          TimeStamp.Date := DateDelta;
          Data := TimeStampToDateTime(TimeStamp);
        end;
      ftDate:
        begin
          TimeStamp.Time := 0;
          TimeStamp.Date := Integer(Buffer^);
          Data := TimeStampToDateTime(TimeStamp);
        end;
      ftDateTime:
        begin
          TimeStamp.Time := 0;
          TimeStamp.Date := Integer(Buffer^);
          Data := TimeStampToDateTime(MSecsToTimeStamp(Double(Buffer^)));
        end;
      ftTimeStamp:
        Data := VarSQLTimeStampCreate(TSqlTimeStamp(Buffer^));
      ftBCD:
        if BCDToCurr(TBcd(Buffer^), Value) then
          Data := Value
        else
          Data := 0;
      ftFMTBcd:
        Data := VarFMTBcdCreate(TBcd(Buffer^));
      ftCurrency:
        Data := Double(Buffer^);
      ftFloat:
        Data := Double(Buffer^);
      ftBoolean:
        Data := WordBool(Buffer^);
      ftMemo:
        {$IFDEF DELPHI2009}
        Data := StrPas(PWideChar(Buffer));
        {$ELSE}
        Data := StrPas(PAnsiChar(Buffer));
        {$ENDIF}
      ftCursor:
        Data := 0;
      ftInterface:
        Data := IUnknown(Buffer^);
      ftIDispatch:
        Data := IDispatch(Buffer^);
      ftLargeInt:
        Decimal(Data).Lo64 := LargeInt(Buffer^);
      ftBlob, ftGraphic..ftTypedBinary, ftVariant:
        Data := OleVariant(Buffer^);
    else
      DatabaseErrorFmt(SUsupportedFieldType, [FieldTypeNames[Field.DataType],
        Field.DisplayName]);
    end;
  end;
{$ENDIF RW}
begin
{$IFDEF RW}
  if Assigned(FOnSetFieldData) and (Buffer <> nil) then
    //Don't bother fetching if the source buffer is nil!
  begin
    { TODO -oveg -ctodo : The RecordNumber is wrong at this point. It's always 0!
                          Data is returned properly! }
    if BufferToVar then
      FOnSetFieldData(Self, Field.Index, Data);
  end;
{$ENDIF RW}
end;

procedure TNxVirtualDataSet.SetRecNo(Value: Integer);
begin
  if (Value >= 0) and (Value < RecordCount) then
  begin
    FCurRec := Value - 1;
    Resync([]);
  end;
end;

procedure TNxVirtualDataSet.InternalInsert;
begin
  inherited;
  { TODO -oveg -ctodo : We need to cache the RecNo here to pass in the OnSetData.
                        We also need an event to signal what to do with data:
                        append/insert/edit & post.
                        append/insert/edit: occur before the data,
                        post: coccurs after receiving the data.
                        Use Getstate (dsEdit?) }
  fCurRec := RecNo;

  if Eof then
    FUpdateModes := [umAppend]
  else
    FUpdateModes := [umInsert];
end;

procedure TNxVirtualDataSet.InternalEdit;
begin
  inherited;

  fCurRec := RecNo;

  FUpdateModes := [umEdit];
end;

procedure TNxVirtualDataSet.InternalCancel;
begin
  inherited;

  FCurRec := FLastBookmark;

  FUpdateModes := FUpdateModes + [umCancel];

  if Assigned(FOnSetFieldMode) then
    FOnSetFieldMode(Self, FCurRec, fUpdateModes);

  FUpdateModes := [umBrowse];
end;

end.

