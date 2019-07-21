unit dsUtils;
{$I PHP.inc}
{$ifdef fpc}
{$mode delphi}{$H+}
{$endif}

interface

uses
  Classes, SysUtils, Dialogs, Controls, Forms, ShellAPI, ClipBrd, Windows, ShlObj,
  Graphics, Vcl.Imaging.pngimage, svgimage, GifImage2, Jpeg, exemod,

  {$ifdef fpc}
  LCLType,
  {$endif}
  {$IFDEF PHP7} hzend_types, {$ENDIF}
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  phpUtils,
  php4delphi;

  procedure InitializeDsUtils(PHPEngine: TPHPEngine);

  procedure clipboard_setFiles(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_getFiles(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_assign(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_get(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_checkformat(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
  procedure clipboard_assignpic(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;

              procedure exemod_count(ht : integer; return_value: pzval; return_value_ptr: pzval; this_ptr : pzval;
            return_value_used : integer; TSRMLS_DC : pointer); cdecl;
implementation

procedure CopyFilesToClipboard( FileList: string );
var
  DropFiles: PDropFiles;
  hGlobal: THandle;
  iLen: Integer;
begin
   iLen := Length( FileList ) + 2;
   FileList := FileList + #0#0;
   hGlobal := GlobalAlloc( GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf( TDropFiles ) + iLen );
   if ( hGlobal = 0 ) then raise Exception.Create( 'Could not allocate memory.' );
   begin
      DropFiles := GlobalLock( hGlobal );
      DropFiles^.pFiles := SizeOf( TDropFiles );
      Move( FileList[1], ( PChar( DropFiles ) + SizeOf( TDropFiles ) )^, iLen );
      GlobalUnlock( hGlobal);
      Clipboard.SetAsHandle( CF_HDROP, hGlobal );
   end;
end;

function GetFilesFromClipboard(): String;
var
  f: THandle;
  Buffer: array [0..1024] of char;
  i, numFiles: Integer;
begin
   Clipboard.Open;
   try
      f := Clipboard.GetAsHandle( CF_HDROP ) ;
      if f <> 0 then
      begin
         numFiles := DragQueryFile( f, $FFFFFFFF, nil, 0 ) ;

         for i := 0 to numFiles-1 do
         begin
            Buffer[0] := #0;
            DragQueryFile( f, i, Buffer, SizeOf( Buffer ) ) ;
            if i <> 0 then
              Result := Result + #13#10;

            Result := Result + Buffer;
         end;
      end;
   finally
      Clipboard.Close;
   end;
end;

procedure clipboard_setFiles;
  var p: pzval_array;
  FileList: String;
  arr: {$IFDEF PHP7}Pzend_array{$ELSE}PHashTable{$ENDIF};
  tmp: ^ppzval;
   i, cnt: integer;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_ex(ht, p);

  FileList := '';
  {$IFDEF PHP7}
  if p[0]^.u1.v._type = IS_ARRAY then
  {$ELSE}
  if p[0]^._type = IS_ARRAY then
  {$ENDIF}
  begin
    {$IFDEF PHP7}
     arr := p[0]^.value.arr;
    {$ELSE}
     arr := p[0]^.value.ht;
    {$ENDIF}
     cnt := zend_hash_num_elements(arr);
     New(tmp);
     for i := 0 to cnt - 1 do
     begin
         zend_hash_index_find(arr, i, tmp);
         if Z_STRLEN(tmp^^) = 0 then
          Continue;

        if i = 0 then
            FileList := FileList + (Z_STRVAL(tmp^^))
        else
            FileList := FileList + #0 + (Z_STRVAL(tmp^^));
     end;
     Dispose(tmp);


     CopyFilesToClipboard( FileList );
  end else
     CopyFilesToClipboard( Z_STRVAL(p[0]^) );

  dispose_pzval_array(p);
end;


procedure clipboard_getFiles;
  var
  FileList: TStrings;
  i: integer;
begin
  FileList := TStringList.Create;
  FileList.Text := GetFilesFromClipboard;

  _array_init( return_value, nil, 0 );
  for i := 0 to FileList.Count - 1 do
    add_index_stringl(return_value, i, zend_pchar(FileList[i]), Length(FileList[i]), 1);

  FileList.Destroy;
end;


procedure clipboard_assign;
  var p: pzval_array;
  format: String;
  M: TMemoryStream;
  PNG: TPNGImage;
  JPG: TJPEGImage;
  GIF: GifImage2.TGIFImage;
  SVG: TSVGGraphic;
  Pic: TPicture;
begin
  if ht < 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_ex(ht, p);
{$IFDEF PHP7}
if (ht > 1) and (p[1]^.u1.v._type <> IS_NULL) then
{$ELSE}
if (ht > 1) and (p[1]^._type <> IS_NULL) then
{$ENDIF}
begin
  Pic := TPicture.Create;
  M := TMemoryStream.Create;
  format := LowerCase(Z_STRVAL(p[1]^));

  try

    String2Stream( Z_STRVAL(p[0]^), M );
  if ( format = 'png' )  then
  begin
       PNG := TPNGImage.Create;
       with PNG do
       begin
           LoadFromStream( M );
           Pic.Assign(PNG);

       end;
       PNG.Destroy;
  end
  else if ( (format = 'jpeg') or (format = 'jpg') ) then
  begin
       JPG := TJPEGImage.Create;
       with JPG do
       begin
           LoadFromStream( M );
           Pic.Assign(JPG);
       end;
       JPG.Destroy;
  end
  else if ( format = 'gif' ) then
  begin
       GIF := GifImage2.TGIFImage.Create;
       with GIF do
       begin
           LoadFromStream( M );
           Pic.Assign(GIF);
       end;
       GIF.Destroy;
  end
  else if ( format = 'svg' ) then
  begin
       SVG := TSVGGraphic.Create();
       with SVG do
       begin
           LoadFromStream( M );
           Pic.Assign(SVG);
       end;
       SVG.Destroy;
  end
  else if ( format = 'ico' ) then
       Pic.Icon.LoadFromStream( M )
  else if ( format = 'bmp' ) then
       Pic.Bitmap.LoadFromStream( M );

       Clipboard.Assign( Pic );
  finally
     M.Destroy;
     Pic.Free;
  end;

end else
  Clipboard.Assign( TObject(Z_LVAL(p[0]^)) as TPersistent );
  dispose_pzval_array(p);
end;

procedure clipboard_get;
begin
   ZVAL_LONG(return_value, Integer(Clipboard));
end;

procedure clipboard_checkformat;
var p: pzval_array;
format: zend_ustr;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_ex(ht, p);
  format := LowerCase(Z_STRVAL(p[0]^));
  if (format = 'text') or (format = 'word') or (format = '1') then
  ZVAL_BOOL( return_value, Clipboard.HasFormat( CF_TEXT ) or Clipboard.HasFormat( CF_OEMTEXT )
  or Clipboard.HasFormat( CF_UNICODETEXT ) or Clipboard.HasFormat( CF_LOCALE )
  or Clipboard.HasFormat( CF_DSPTEXT ) )
  else if (format = 'pic') or (format = 'picture') or (format = '2') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_GIF ) or Clipboard.HasFormat( CF_BITMAP )
  or Clipboard.HasFormat( CF_METAFILEPICT ) or Clipboard.HasFormat( CF_TIFF )
  or Clipboard.HasFormat( CF_DIB ) or Clipboard.HasFormat( CF_DIBV5 )
  or Clipboard.HasFormat( CF_DSPBITMAP ) or Clipboard.HasFormat( CF_DSPMETAFILEPICT )
  or Clipboard.HasFormat( CF_DSPENHMETAFILE ) or Clipboard.HasFormat( CF_PICTURE ))
  else if (format = 'c') or (format='component') or (format='3') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_COMPONENT ) )
  else if (format = 'aud') or (format='audio') or (format='sound') or (format='4') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_WAVE ) or Clipboard.HasFormat( CF_RIFF ) )
  else if (format = 'hdrop') or (format='drop') or (format='dragdrop') or (format='5') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_HDROP ) )
  else if (format = 'gdi') or (format = 'gdiobj') or (format='6') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_GDIOBJFIRST ) and Clipboard.HasFormat( CF_GDIOBJLAST ))
  else if (format = 'palette') or (format = 'pal') or (format='hpalette') or (format='7') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat(CF_PALETTE))
  else if (format = 'pen') or (format='hpen') or (format='pendata') or (format='8') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_PENDATA ) )
  else if (format = 'cust') or (format='custom') or (format='9') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_PRIVATEFIRST ) or Clipboard.HasFormat( CF_PRIVATELAST ) )
  else if (format = 'ownerdisplay') or (format = 'ownerdisp') or (format='display') or (format='10') then
  ZVAL_BOOL(return_value, Clipboard.HasFormat( CF_OWNERDISPLAY ))
  else
  ZVAL_LONG(return_value, -1);
  dispose_pzval_array(p);
end;
procedure exemod_count;
begin
   ZVAL_LONG(return_value, exemod.getcnt);
end;
procedure clipboard_assignpic;
var p: pzval_array; o: TObject;
label e1;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  zend_get_parameters_ex(ht, p);
  ZVAL_FALSE(return_value);
    o := TObject(Z_LVAL(p[0]^));
    if Clipboard.FormatCount = 0  then goto e1;
    if not Assigned(o) then goto e1;
    if not (o is TPicture) then goto e1;

   (TObject(Z_LVAL(p[0]^)) as TPicture).Assign(Clipboard);
   ZVAL_TRUE(return_value);
  e1:
    dispose_pzval_array(p);
end;

procedure InitializeDsUtils(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('clipboard_setFiles', @clipboard_setFiles);
  PHPEngine.AddFunction('clipboard_getFiles', @clipboard_getFiles);
  PHPEngine.AddFunction('clipboard_assign', @clipboard_assign);
  PHPEngine.AddFunction('clipboard_get', @clipboard_get);
  PHPEngine.AddFunction('clipboard_checkformat', @ clipboard_checkformat);
  PHPEngine.AddFunction('clipboard_assignpic', @clipboard_assignpic);

  PHPEngine.AddFunction('exemod_count', @exemod_count);
end;




end.

