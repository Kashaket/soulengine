unit FileExists;

interface

uses Winapi.Windows;

const
  faInvalid     = -1;
  faReadOnly    = $00000001;
  faHidden      = $00000002 platform; // only a convention on POSIX
  faSysFile     = $00000004 platform; // on POSIX system files are not regular files and not directories
  faVolumeID    = $00000008 platform deprecated;  // not used in Win32
  faDirectory   = $00000010;
  faArchive     = $00000020 platform;
  faNormal      = $00000080;
  faTemporary   = $00000100 platform;
  faSymLink     = $00000400 platform; // Available on POSIX and Vista and above
  faCompressed  = $00000800 platform;
  faEncrypted   = $00004000 platform;
  faVirtual     = $00010000 platform;
  faAnyFile     = $000001FF;

function FileExists_(const FileName: string; FollowLink: Boolean = True): Boolean;
implementation


function FileExists_(const FileName: string; FollowLink: Boolean = True): Boolean;
  function ExistsLockedOrShared(const Filename: string): Boolean;
  var
    FindData: TWin32FindData;
    LHandle: THandle;
  begin
    LHandle := FindFirstFile(PChar(Filename), FindData);
    if LHandle <> INVALID_HANDLE_VALUE then
    begin
      Winapi.Windows.FindClose(LHandle);
      Result := FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0;
    end else
      Result := False;
  end;

var
  Flags: Cardinal;
  Handle: THandle;
  LastError: Cardinal;
begin
  Flags := GetFileAttributes(PChar(FileName));

  if Flags <> INVALID_FILE_ATTRIBUTES then
  begin
    if faSymLink and Flags <> 0 then
    begin
      if not FollowLink then
        Exit(True)
      else
      begin
        if faDirectory and Flags <> 0 then
          Exit(False)
        else
        begin
          Handle := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil,
            OPEN_EXISTING, 0, 0);
          if Handle <> INVALID_HANDLE_VALUE then
          begin
            CloseHandle(Handle);
            Exit(True);
          end;
          LastError := GetLastError;
          Exit(LastError = ERROR_SHARING_VIOLATION);
        end;
      end;
    end;

    Exit(faDirectory and Flags = 0);
  end;
  LastError := GetLastError;
  Result := (LastError <> ERROR_FILE_NOT_FOUND) and
    (LastError <> ERROR_PATH_NOT_FOUND) and
    (LastError <> ERROR_INVALID_NAME) and ExistsLockedOrShared(Filename);
end;

end.
