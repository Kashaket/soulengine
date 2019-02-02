{
 SquallSound 1.2
 Author: CH@$ER
 E-mail: aleksandr_chaser@mail.ru
 http://freefly.mirgames.ru
 (C) FreeFly

 Based on Squall system. (C) AntiTank
 Author: Гилязетдинов Марат (Марыч)
 E-Mail marat@antitank.net

 Free for use. Just put my name in your credits information ;)
}
unit SquallSound;

interface

uses Windows, SysUtils, Classes, Squall;

type
  TSoundVec = array[0..2] of Single;

  function SoundVec(X, Y, Z: Single): TSoundVec;

type
  TLogProc = procedure(const Text: string) of object;
  TSoundType = (st3D, st2D, stMusic);

  TSystemParams = packed record
    RolloffFactor, DistanceFactor, DopplerFactor: Single;
  end;

  PSound = ^TSound;
  TSound = class;
  TSoundManager = class;

  TSoundSystem = class(TObject)
  private
    FList, FManagerList: TList;
    FPause: SmallInt;
    FDoLog: TLogProc;
    FSystemParams: TSystemParams;
    FFront: TSoundVec;
    FVelocity: TSoundVec;
    FTop: TSoundVec;
    FPosition: TSoundVec;
    function GetCount: Integer;
    procedure SetSystemParams(const Value: TSystemParams);
    function GetItem(Index: Integer): TSound;
    procedure Log(const Text: string);
    procedure Add(const AObj: TObject; const AType: byte);
    procedure Remove(const AObj: TObject; const AType: byte);
    procedure ClearDead;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update;
    procedure Pause;
    procedure Stop;
    procedure UnloadGroup(const AGroup: Integer);
    function AddSound(const FileName: String; const ASType: TSoundType;
      AGroup: Integer): TSound;
    function FindByFileName(const FileName: string): TSound;
    property DoLog: TLogProc read FDoLog write FDoLog;
    property Items[Index: Integer]: TSound read GetItem; default;
    property Position: TSoundVec read FPosition write FPosition;
    property Velocity: TSoundVec read FVelocity write FVelocity;
    property Front: TSoundVec read FFront write FFront;
    property Top: TSoundVec read FTop write FTop;
    property SystemParams: TSystemParams read FSystemParams write SetSystemParams;
    property Count: Integer read GetCount;
  end;

  TSound = class
  private
    FID: Integer;
    FEngine: TSoundSystem;
    Channel: Integer;
    FVelocity: TSoundVec;
    FSType: TSoundType;
    FFrequency: Integer;
    FPosition: TSoundVec;
    FLoop: Boolean;
    FMaxDist: Integer;
    FMinDist: Integer;
    FVolume: Integer;
    FName: string;
    FGroup: Integer;
    FLoaded: boolean;
    function GetFileFrequency: Integer;
    procedure SetMaxDist(const Value: Integer);
    procedure SetMinDist(const Value: Integer);
    procedure SetFrequency(const Value: Integer);
    procedure SetVelocity(const Value: TSoundVec);
    procedure SetPosition(const Value: TSoundVec);
  public
    constructor Create(const SoundSystem: TSoundSystem);
    destructor Destroy; override;
    function Play(const APosition, AVelocity: TSoundVec; DoLoop: boolean): Integer; overload;
    function Play(const APosition: TSoundVec; DoLoop: boolean): Integer; overload;
    function Play(const DoLoop: boolean): Integer; overload;
    procedure Pause(const Paused: boolean);
    procedure Stop;
    procedure LoadFromFile(const FileName: string; ASType: TSoundType;
      AGroup: Integer);
    procedure Unload;
    //Channel status: 0 - stoped; 1 - playing; 2 - paused;
    function Status: Byte;
    //True if playing
    function IsPlaying: boolean;
    property ID: Integer read FID;
    property Name: string read FName;
    property Engine: TSoundSystem read FEngine;
    property Group: Integer read FGroup write FGroup;
    property Volume: Integer read FVolume write FVolume;
    property MinDist: Integer read FMinDist write SetMinDist;
    property MaxDist: Integer read FMaxDist write SetMaxDist;
    property Position: TSoundVec read FPosition write SetPosition;
    property Velocity: TSoundVec read FVelocity write SetVelocity;
    property Frequency: Integer read FFrequency write SetFrequency;
    //Returns frequency of sound file
    property FileFrequency: Integer read GetFileFrequency;
    property Loop: Boolean read FLoop write FLoop;
    property SType: TSoundType read FSType;
  end;

  TSoundManager = class
  private
    FChannels: array of Word;
    FChannelsCount: Byte;
    FMaxChannels: Byte;
    FPosition: TSoundVec;
    FEngine: TSoundSystem;
    FStopOnPlay: Boolean;
    FSample: TSound;
    FMaxDist: Integer;
    FVelocity: TSoundVec;
    FMinDist: Integer;
    FFrequency: Integer;
    FVolume: Integer;
    procedure SetFrequency(const Value: Integer);
    procedure SetMaxDist(const Value: Integer);
    procedure SetMinDist(const Value: Integer);
    procedure SetVelocity(const Value: TSoundVec);
    procedure SetSample(const Value: TSound);
    procedure SetMaxChannels(const Value: Byte);
    procedure SetSource(const Value: TSoundVec);
    procedure CheckChannelsCount;
    procedure DeleteChannel(const IDX: Byte);
  public
    constructor Create(const SoundSystem: TSoundSystem);
    destructor Destroy; override;
    procedure Play(const APosition, AVelocity: TSoundVec; DoLoop: boolean); overload;
    procedure Play(const APosition: TSoundVec; DoLoop: boolean); overload;
    procedure Stop(const AID: Byte);
    procedure StopAll;
    function IsPlaying: Boolean;
    property Engine: TSoundSystem read FEngine;
    property Sample: TSound read FSample write SetSample;
    property MaxChannels: Byte read FMaxChannels write SetMaxChannels;
    property StopOnPlay: Boolean read FStopOnPlay write FStopOnPlay;
    property Volume: Integer read FVolume write FVolume;
    property MinDist: Integer read FMinDist write SetMinDist;
    property MaxDist: Integer read FMaxDist write SetMaxDist;
    property Position: TSoundVec read FPosition write SetSource;
    property Velocity: TSoundVec read FVelocity write SetVelocity;
    property Frequency: Integer read FFrequency write SetFrequency;
    property ChannelsCount: Byte read FChannelsCount;
  end;

const
  SysParamsDef: TSystemParams = (RolloffFactor: 0.003; DistanceFactor: 0.032;
    DopplerFactor: 1);

implementation

function SoundVec(X, Y, Z: Single): TSoundVec;
begin
  Result[0]:= X;
  Result[1]:= Y;
  Result[2]:= Z;
end;

{ TSoundSystem }

procedure TSoundSystem.ClearDead;
var
  i: integer;
begin
  for i:= FList.Count - 1 downto 0 do
    with TSound(FList[i]) do
      if not FLoaded then Free;
end;

constructor TSoundSystem.Create;
var
  ErrorCode: Integer;
begin
  FList:= TList.Create;
  FManagerList:= TList.Create;
  FPosition:= SoundVec(0, 0, 0);
  FVelocity:= SoundVec(0, 0, 0);
  FFront:= SoundVec(0, 0, 0);
  FTop:= SoundVec(0, 0, 0);
  SystemParams:= SysParamsDef;
  ErrorCode:= Squall_Init(nil);
  if ErrorCode < 0 then
  begin
    Log(ClassName + ': Unable init sound system. ErrorCode: ' +
      IntToStr(ErrorCode));
    FreeAndNil(Self);
  end;
  FPause:= 0;
end;

destructor TSoundSystem.Destroy;
begin
  while FList.Count > 0 do
    TSound(FList[FList.Count - 1]).Free;
  while FManagerList.Count > 0 do
    TSoundManager(FManagerList[FManagerList.Count - 1]).Free;
  FList.Free;
  FManagerList.Free;
  Squall_Free();
  inherited;
end;

procedure TSoundSystem.Add(const AObj: TObject; const AType: byte);
begin
  case AType of
    0: FList.Add(AObj);
    1: FManagerList.Add(AObj);
  end;
end;

function TSoundSystem.AddSound(const FileName: String;
  const ASType: TSoundType; AGroup: Integer): TSound;
begin
  Result:= TSound.Create(Self);
  with Result do LoadFromFile(FileName, ASType, AGroup);
end;

function TSoundSystem.FindByFileName(const FileName: string): TSound;
var
  I: integer;
begin
  Result:= nil;
  for i:= 0 to FList.Count - 1 do
    with TSound(FList[i]) do
      if AnsiLowerCase(FName) = FileName then
        Result:= TSound(FList[i]);
end;

function TSoundSystem.GetCount: Integer;
begin
  Result:= FList.Count;
end;

function TSoundSystem.GetItem(Index: Integer): TSound;
begin
  Result:= nil;
  if (Index >= 0) and (Index < FList.Count) then
    Result:= TSound(FList[Index]);
end;

procedure TSoundSystem.Log(const Text: string);
begin
  if Assigned(FDoLog) then
    DoLog(Text);
end;

procedure TSoundSystem.Pause;
begin
  Squall_Pause(FPause xor 1);
end;

procedure TSoundSystem.Remove(const AObj: TObject; const AType: byte);
begin
  case AType of
    0: FList.Remove(AObj);
    1: FManagerList.Remove(AObj);
  end;
end;

procedure TSoundSystem.Stop;
begin
  Squall_Stop();
end;

procedure TSoundSystem.SetSystemParams(const Value: TSystemParams);
var
  ErrorCode: Integer;
begin
  FSystemParams:= Value;
  ErrorCode:= Squall_Listener_SetRollOffFactor(FSystemParams.RolloffFactor);
  if ErrorCode < 0 then
  begin
    Log(ClassName + ': Unable to set RolloffFactor. ErrorCode: ' +
      IntToStr(ErrorCode));
    Squall_Listener_GetRollOffFactor(FSystemParams.RolloffFactor);
  end;
  ErrorCode:= Squall_Listener_SetDistanceFactor(FSystemParams.DistanceFactor);
  if ErrorCode < 0 then
  begin
    Log(ClassName + ': Unable to set DistanceFactor. ErrorCode: ' +
      IntToStr(ErrorCode));
    Squall_Listener_GetDistanceFactor(FSystemParams.DistanceFactor);
  end;
  ErrorCode:= Squall_Listener_SetDopplerFactor(FSystemParams.DopplerFactor);
  if ErrorCode < 0 then
  begin
    Log(ClassName + ': Unable to set DopplerFactor. ErrorCode: ' +
      IntToStr(ErrorCode));
    Squall_Listener_GetDopplerFactor(FSystemParams.DopplerFactor);
  end;
end;

procedure TSoundSystem.UnloadGroup(const AGroup: Integer);
var
  i: integer;
begin
  for i:= 0 to FList.Count - 1 do
    with TSound(FList[i]) do
      if (FGroup = AGroup) or (AGroup = -1) then
        Unload;
end;

procedure TSoundSystem.Update;
begin
  Squall_Listener_SetParameters(@FPosition, @FFront, @FTop, @FVelocity);
  ClearDead;
end;

{ TSound }

constructor TSound.Create(const SoundSystem: TSoundSystem);
begin
  if SoundSystem = nil then
  begin
    FreeAndNil(Self);
    Exit;
  end;
  FEngine:= SoundSystem;
  FEngine.Add(Self, 0);
  FID:= 0;
  FName:= '';
  Channel:= 0;
  FSType:= st3D;
  FFrequency:= 0;
  FVolume:= 80;
  FMinDist:= 400;
  FMaxDist:= 4000;
  FPosition:= SoundVec(0, 0, 0);
  FVelocity:= SoundVec(0, 0, 0);
  FLoop:= false;
  FLoaded:= false;
  FGroup:= 0;
end;

destructor TSound.Destroy;
begin
  if FLoaded then Unload;
  FEngine.Remove(Self, 0);
  inherited;
end;

function TSound.GetFileFrequency: Integer;
begin
  Result:= Squall_Sample_GetFileFrequency(FID);
end;

function TSound.IsPlaying: boolean;
begin
  Result:= Status = 1;
end;

procedure TSound.LoadFromFile(const FileName: string; ASType: TSoundType;
  AGroup: Integer);
var
  MemFlag: Byte;
  Snd: TSound;
begin
  if FLoaded then Unload;
  if not FileExists(FileName) then
  begin
    FEngine.Log('Sound not loaded: File "' + FileName + '" doesnt exists');
    exit;
  end;
  Snd:= FEngine.FindByFileName(FileName);
  if snd <> nil then
  begin
    if Snd.SType = ASType then
    begin
      FID:= Snd.FID;
      FName:= Snd.FName;
      FSType:= Snd.SType;
      FGroup:= AGroup;
      FLoaded:= true;
      exit;
    end;
  end;
  FSType:= ASType;
  FName:= AnsiLowerCase(FileName);
  FGroup:= AGroup;
  if ASType = stMusic then MemFlag:= 0 else MemFlag:= 1;
  FID:= Squall_Sample_LoadFile(PChar(FileName), MemFlag, nil);
  if FID > 0 then
  begin
    FEngine.Log('Sound loaded: ' + FileName);
    FLoaded:= true;
  end
  else FEngine.Log('Sound not loaded: ' + FileName + '. ErrorCode: ' +
    IntToStr(FID));
end;

function TSound.Play(const APosition: TSoundVec; DoLoop: boolean): Integer;
begin
  Result:= Play(APosition, SoundVec(0, 0, 0), DoLoop);
end;

function TSound.Play(const APosition, AVelocity: TSoundVec;
  DoLoop: boolean): Integer;
begin
  FPosition:= APosition;
  FVelocity:= AVelocity;
  FLoop:= DoLoop;
  case FSType of
    st3D: Channel:= Squall_Sample_Play3DEx(FID, Byte(FLoop), 0, 1,
      @FPosition, @FVelocity, 50, FVolume, FFrequency, FMinDist, FMaxDist);
    stMusic, st2D: Channel:= Squall_Sample_PlayEx(FID, Byte(FLoop), 0, 1,
      128, FVolume, FFrequency, 50);
  end;
  Result:= Channel;
end;

procedure TSound.SetFrequency(const Value: Integer);
begin
  FFrequency:= Value;
  if Channel > 0 then
    Squall_Channel_SetFrequency(Channel, FFrequency);
end;

procedure TSound.SetMaxDist(const Value: Integer);
begin
  FMaxDist:= Value;
  {if (Channel > 0) and (FSType = st3D) then
    Squall_Channel_SetMinMaxDistance(Channel, FMinDist, FMaxDist);}
end;

procedure TSound.SetMinDist(const Value: Integer);
begin
  FMinDist:= Value;
  {if (Channel > 0) and (FSType = st3D) then
    Squall_Channel_SetMinMaxDistance(Channel, FMinDist, FMaxDist);}
end;

procedure TSound.SetPosition(const Value: TSoundVec);
begin
  FPosition:= Value;
  {if (Channel > 0) and (FSType = st3D) then
    Squall_Channel_Set3DPosition(Channel, @FPosition);}
end;

procedure TSound.SetVelocity(const Value: TSoundVec);
begin
  FVelocity:= Value;
  {if (Channel > 0) and (FSType = st3D) then
    Squall_Channel_SetVelocity(Channel, @FVelocity);}
end;

function TSound.Status: Byte;
begin
  case Squall_Channel_Status(Channel) of
    0, 3: Result:= 0;
    1: Result:= 1;
    2: Result:= 2;
  end;
end;

procedure TSound.Stop;
begin
  Squall_Sample_Stop(FID);
  Channel:= 0;
end;

procedure TSound.Unload;
var
  i: integer;
begin
  Squall_Sample_Unload(FID);
  FLoaded:= false;
  FEngine.Log('Sound unloaded: ' + FName);
  if FSType = st3D then
    for i:= 0 to FEngine.FManagerList.Count - 1 do
      with TSoundManager(FEngine.FManagerList[i]) do
        if FSample = Self then
          FSample:= nil
end;

procedure TSound.Pause(const Paused: boolean);
begin
  if FLoaded and (Channel > 0) then
    Squall_Channel_Pause(Channel, Byte(Paused));
end;

function TSound.Play(const DoLoop: boolean): Integer;
begin
  Result:= Play(SoundVec(0, 0, 0), SoundVec(0, 0, 0), DoLoop);
end;

{ TSoundManager }

procedure TSoundManager.CheckChannelsCount;
var
  i: Integer;
begin
  if FChannelsCount > FMaxChannels then
  begin
    for i:= 0 to FChannelsCount - FMaxChannels - 1 do
      Stop(i);
    for i:= 0 to FMaxChannels do
      FChannels[i]:= FChannels[i + FChannelsCount - FMaxChannels];
    SetLength(FChannels, FMaxChannels);
    FChannelsCount:= FMaxChannels;
  end;
end;

constructor TSoundManager.Create(const SoundSystem: TSoundSystem);
begin
  FEngine:= SoundSystem;
  if FEngine = nil then
  begin
    FreeAndNil(Self);
    exit;
  end;
  FEngine.Add(Self, 1);
  FSample:= nil;
  FMaxChannels:= 8;
  FStopOnPlay:= false;
  FPosition:= SoundVec(0, 0, 0);
  FChannelsCount:= 0;
  SetLength(FChannels, 0);
end;

procedure TSoundManager.DeleteChannel(const IDX: Byte);
var
  i: Integer;
begin
  if IDX < FChannelsCount  then
  begin
    for i:= IDX to FChannelsCount - 2 do
      FChannels[i]:= FChannels[i + 1];
    Dec(FChannelsCount);
    SetLength(FChannels, FChannelsCount);
  end;
end;

destructor TSoundManager.Destroy;
begin
  FEngine.Remove(Self, 1);
  inherited;
end;

function TSoundManager.IsPlaying: Boolean;
begin
  Result:= FChannelsCount > 0;
end;

procedure TSoundManager.Play(const APosition, AVelocity: TSoundVec;
  DoLoop: boolean);
var
  i, j: integer;
  CID: Word;
begin
  if FSample = nil then exit;
  if FStopOnPlay then StopAll;
  FPosition:= APosition;
  FVelocity:= AVelocity;
  CID:= Squall_Sample_Play3DEx(FSample.FID, Byte(DoLoop), 0, 1,
      @FPosition, @FVelocity, 50, FVolume, FFrequency, FMinDist, FMaxDist);
  if CID > 0 then
  begin
    Inc(FChannelsCount);
    SetLength(FChannels, FChannelsCount);
    FChannels[FChannelsCount - 1]:= CID;
    CheckChannelsCount;
  end;
  for i:= FChannelsCount - 1 downto 0 do
    if Squall_Channel_Status(FChannels[i]) = SQUALL_CHANNEL_STATUS_NONE then
      DeleteChannel(i);
end;

procedure TSoundManager.Play(const APosition: TSoundVec;
  DoLoop: boolean);
begin
  Play(APosition, SoundVec(0, 0, 0), DoLoop);
end;

procedure TSoundManager.SetFrequency(const Value: Integer);
var
  i: Integer;
  CID: Word;
begin
  if FSample = nil then exit;
  if FFrequency = Value then exit;
  FFrequency:= Value;
  for i:= 0 to FChannelsCount - 1 do
  begin
    CID:= FChannels[i];
    if CID > 0 then Squall_Channel_SetFrequency(CID, FFrequency);
  end;
end;

procedure TSoundManager.SetMaxChannels(const Value: Byte);
begin
  if FSample = nil then exit;
  FMaxChannels:= Value;
  CheckChannelsCount;
end;

procedure TSoundManager.SetMaxDist(const Value: Integer);
var
  i: Integer;
  CID: Word;
begin
  if FSample = nil then exit;
  if FMaxDist = Value then exit;
  FMaxDist:= Value;
  for i:= 0 to FChannelsCount - 1 do
  begin
    CID:= FChannels[i];
    if CID > 0 then Squall_Channel_SetMinMaxDistance(CID, FMinDist, FMaxDist);
  end;
end;

procedure TSoundManager.SetMinDist(const Value: Integer);
var
  i: Integer;
  CID: Word;
begin
  if FSample = nil then exit;
  if FMinDist = Value then exit;
  FMinDist:= Value;
  for i:= 0 to FChannelsCount - 1 do
  begin
    CID:= FChannels[i];
    if CID > 0 then Squall_Channel_SetMinMaxDistance(CID, FMInDist, FMaxDist);
  end;
end;


procedure TSoundManager.SetSample(const Value: TSound);
begin
  if Value = nil then exit;
  if Value.FSType <> st3D then exit;
  FSample:= Value;
  FFrequency:= FSample.FFrequency;
  FVolume:= FSample.FVolume;
  FMaxDist:= FSample.FMaxDist;
  FMinDist:= FSample.FMinDist;
end;

procedure TSoundManager.SetSource(const Value: TSoundVec);
var
  i: Integer;
  CID: Word;
begin
  if FSample = nil then exit;
  if (FPosition[0] = Value[0]) and (FPosition[1] = Value[1])
    and (FPosition[2] = Value[2]) then exit;
  FPosition:= Value;
  for i:= 0 to FChannelsCount - 1 do
  begin
    CID:= FChannels[i];
    if CID > 0 then Squall_Channel_Set3DPosition(CID, @FPosition);
  end;
end;

procedure TSoundManager.SetVelocity(const Value: TSoundVec);
var
  i: Integer;
  CID: Word;
begin
  if FSample = nil then exit;
  FVelocity:= Value;
  for i:= 0 to FChannelsCount - 1 do
  begin
    CID:= FChannels[i];
    if CID > 0 then SQUALL_Channel_SetVelocity(CID, @FVelocity);
  end;
end;

procedure TSoundManager.Stop(const AID: Byte);
var
  i: Integer;
begin
  if AID < FChannelsCount  then
  begin
    Squall_Channel_Stop(FChannels[AID]);
    DeleteChannel(AID);
  end;
end;

procedure TSoundManager.StopAll;
var
  i: integer;
begin
  for i:= 0 to FChannelsCount - 1 do
    Squall_Channel_Stop(FChannels[i]);
  FChannelsCount:= 0;
  SetLength(FChannels, 0);
end;

end.
