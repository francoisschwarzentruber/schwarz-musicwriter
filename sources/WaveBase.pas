unit WaveBase;

interface

uses
  SysUtils,Windows,Classes,SyncObjs,MMSystem;

type
  TBufferEvent=class(TEvent)        //Just because I'm lazzy
    FIndex:Integer;
  end;

  TAPIDeviceOpenProc=function(HandlePtr:PInteger;DeviceID:UINT;pwfx:PWAVEFORMATEX;dwCallBack,dwCallBackInstance:DWORD;fdwOpen:DWORD):MMRESULT;stdcall;
  TAPIDeviceCloseProc=function(Handle:Integer):MMResult;stdcall;

  TWaveBase=class;      //Base class

  TWaveThread=class(TThread)
  private
    FWave:TWaveBase;
  protected
    procedure Execute;override;
  public
    constructor Create(AWave:TWaveBase);virtual;

    destructor Destroy;override;
  end;

  TWaveThreadClass=class of TWaveThread;

  TWaveBuffer=TWaveHdr;

  TOnBufferEvent=procedure(Buffer:Pointer;Length:Cardinal;BufferQueueLength:Integer) of object;

  TWaveBase=class(TComponent)
  private
    FHandleNeeded: Boolean;
    FBits16: Boolean;
    FStereo: Boolean;
    FFrequency: Cardinal;
    FDeviceID: Integer;
    FPlaying: Boolean;
    FThread: TWaveThread;
    FBufferSize: Cardinal;
    FOnBuffer: TOnBufferEvent;
    FSynchronizedBufferEvent: Boolean;

    procedure CloseHandle;
    function GetHandleAllocated: Boolean;
    function GetHandleNeeded: Boolean;
    procedure SetBits16(const Value: Boolean);
    procedure SetFrequency(const Value: Cardinal);
    procedure SetStereo(const Value: Boolean);
    procedure SetDeviceID(const Value: Integer);
    procedure SetPlaying(const Value: Boolean);
    function GetHandle:THandle;
    procedure PrepareBuffers;
    procedure CloseBuffers;
    procedure SetBufferCount(const Value:Integer);virtual;
    procedure SetBufferSize(const Value: Cardinal);
    procedure SetOnBuffer(const Value: TOnBufferEvent);
    function GetBufferQueueLength:Integer;
    procedure SetSynchronizedBufferEvent(const Value: Boolean);
  protected
    FHandle:Integer;
    FCriticalSection:TCriticalSection;
    FBuffers:array of TWaveBuffer;
    FBufferCount:Integer;
    FCurrentClientBufferIndex,FCurrentServerBufferIndex:Integer;

    procedure CreateHandle(Test:Boolean=False);virtual;
    property HandleNeeded:Boolean read GetHandleNeeded write FHandleNeeded;
    property HandleAllocated:Boolean read GetHandleAllocated;
    procedure MMCheck(r:MMResult);

    class function GetAPIDeviceOpenProc:TAPIDeviceOpenProc;virtual;abstract;             //Device driver initialization proc (depending only on the class)
    class function GetAPIDeviceCloseProc:TAPIDeviceCloseProc;virtual;abstract;           //Device driver finalization proc (depending only on the class)
    class function GetErrorMSG(ErrorID:MMResult):string;virtual;abstract;                //For translating messages
    class function GetThreadClass:TWaveThreadClass;virtual;                              //Useless for the moment, but perhaps usefull in future implementations
    procedure DoStop;virtual;abstract;                                                   
    procedure DoStart;virtual;abstract;
    procedure DoCallBack(uMsg:UINT;dwParam1,dwParam2:DWORD);virtual;abstract;
    procedure PrepareBuffer(var Buffer:TWaveBuffer);virtual;abstract;
    procedure UnPrepareBuffer(var Buffer:TWaveBuffer);virtual;abstract;
    procedure PreBuffering;virtual;
    procedure AddBuffer(var Buffer:TWaveBuffer);virtual;abstract;
    procedure PostBuffering;virtual;

    property APIDeviceOpenProc:TAPIDeviceOpenProc read GetAPIDeviceOpenProc;
    property APIDeviceCloseProc:TAPIDeviceCloseProc read GetAPIDeviceCloseProc;
  public
    constructor Create(AOwner:TComponent);override;

    property Stereo:Boolean read FStereo write SetStereo;
    property Bits16:Boolean read FBits16 write SetBits16;
    property Frequency:Cardinal read FFrequency write SetFrequency;
    property DeviceID:Integer read FDeviceID write SetDeviceID;
    property Playing:Boolean read FPlaying write SetPlaying;
    property Handle:Cardinal read GetHandle;
    property BufferCount:Integer read FBufferCount write SetBufferCount;
    property BufferSize:Cardinal read FBufferSize write SetBufferSize;                   //Buffer size, in Byte.
    property OnBuffer:TOnBufferEvent read FOnBuffer write SetOnBuffer;                   //Event called when data is ready to read/write
    property CurrentClientBufferIndex:Integer read FCurrentClientBufferIndex;            //Buffer index in RAM
    property CurrentServerBufferIndex:Integer read FCurrentServerBufferIndex;            //Buffer index in APU
    property BufferQueueLength:Integer read GetBufferQueueLength;                        //Buffers already sent
    property SynchronizedBufferEvent:Boolean read FSynchronizedBufferEvent write SetSynchronizedBufferEvent;   //Set to true if we want to synchronize the events with the application's main thread (no synchronization work needed       ;)
    procedure Test;      //Quick test
    procedure Start;
    procedure Stop;

    destructor Destroy;override;
  end;

  TStandardWaveInFormat=record
    Stereo:Boolean;
    Bits16:Boolean;
    Freq:Cardinal;
    ID:Cardinal;
  end;

const
  TabStandardFormats:array[0..11] of TStandardWaveInFormat=(                  //Standard formats, this might be usefull someday...
    (Stereo:False;
     Bits16:False;
     Freq:11025;
     ID:WAVE_FORMAT_1M08),
    (Stereo:True;
     Bits16:False;
     Freq:11025;
     ID:WAVE_FORMAT_1S08),
    (Stereo:False;
     Bits16:True;
     Freq:11025;
     ID:WAVE_FORMAT_1M16),
    (Stereo:True;
     Bits16:True;
     Freq:11025;
     ID:WAVE_FORMAT_1S16),
    (Stereo:False;
     Bits16:False;
     Freq:22050;
     ID:WAVE_FORMAT_2M08),
    (Stereo:True;
     Bits16:False;
     Freq:22050;
     ID:WAVE_FORMAT_2S08),
    (Stereo:False;
     Bits16:True;
     Freq:22050;
     ID:WAVE_FORMAT_2M16),
    (Stereo:True;
     Bits16:True;
     Freq:22050;
     ID:WAVE_FORMAT_2S16),
    (Stereo:False;
     Bits16:False;
     Freq:44100;
     ID:WAVE_FORMAT_4M08),
    (Stereo:True;
     Bits16:False;
     Freq:44100;
     ID:WAVE_FORMAT_4S08),
    (Stereo:False;
     Bits16:True;
     Freq:44100;
     ID:WAVE_FORMAT_4M16),
    (Stereo:True;
     Bits16:True;
     Freq:44100;
     ID:WAVE_FORMAT_4S16)
  );

implementation

{ TWaveBase }

procedure TWaveBase.CloseBuffers;
var
  a:Integer;
begin
  FCriticalSection.Enter;
  try
    for a:=0 to High(FBuffers) do begin
      UnPrepareBuffer(FBuffers[a]);
      FreeMem(FBuffers[a].lpData);
      TBufferEvent(FBuffers[a].dwUser).Destroy;
    end;
    SetLength(FBuffers,0);
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TWaveBase.CloseHandle;
var
  Proc:TAPIDeviceCloseProc;
begin
  if HandleAllocated then begin
    Proc:=APIDeviceCloseProc;
    MMCheck(Proc(FHandle));
  end;
  FHandle:=0;
end;

constructor TWaveBase.Create;
begin
  inherited;
  FDeviceID:=-1;
  FFrequency:=22050;
  FCriticalSection:=TCriticalSection.Create;
  FBufferCount:=3;
  FBufferSize:=512;
  FSynchronizedBufferEvent:=True;
end;

procedure CallBackProc(hwi:THandle;uMsg:UINT;dwInstance,dwParam1,dwParam2:DWORD);stdcall;
begin
  with TWaveBase(dwInstance) do
    DoCallBack(uMsg,dwParam1,dwParam2);
end;

procedure TWaveBase.CreateHandle(Test: Boolean);
var
  Format:TWaveFormatEx;
  p:PInteger;
  c:Cardinal;
  Proc:TAPIDeviceOpenProc;
begin
  ZeroMemory(@Format,SizeOf(Format));
  Format.wFormatTag:=WAVE_FORMAT_PCM;        //Only PCM, but perhaps more to come...
  if Stereo then
    Format.nChannels:=2
  else
    Format.nChannels:=1;
  Format.nSamplesPerSec:=Frequency;
  if Bits16 then
    Format.wBitsPerSample:=16
  else
    Format.wBitsPerSample:=8;
  Format.nBlockAlign:=(Format.nChannels*Format.wBitsPerSample) div 8;
  Format.nAvgBytesPerSec:=Format.nSamplesPerSec*Format.nBlockAlign;
  Format.cbSize:=0;
  if Test then begin
    c:=WAVE_FORMAT_QUERY;
    p:=nil
  end else begin
    c:=CALLBACK_FUNCTION;
    p:=@FHandle;
  end;
  Proc:=APIDeviceOpenProc;
  MMCheck(Proc(p,Cardinal(DeviceID),@Format,Cardinal(@CallBackProc),Cardinal(Self),c));
  if not Test then
    Assert(FHandle<>0);
end;

destructor TWaveBase.Destroy;
begin
  if FPlaying then
    Stop;
  CloseHandle;
  FCriticalSection.Destroy;
  inherited;
end;

function TWaveBase.GetBufferQueueLength: Integer;
begin
  if FCurrentClientBufferIndex<=FCurrentServerBufferIndex then
    Result:=FCurrentClientBufferIndex+High(FBuffers)+1-FCurrentServerBufferIndex
  else
    Result:=FCurrentClientBufferIndex-FCurrentServerBufferIndex;
end;

function TWaveBase.GetHandle: THandle;
begin
  if HandleNeeded then begin
    if HandleAllocated then
      CloseHandle;
    CreateHandle(False);
  end;
  FHandleNeeded:=False;
  Result:=FHandle;
end;

function TWaveBase.GetHandleAllocated: Boolean;
begin
  Result:=FHandle<>0;
end;

function TWaveBase.GetHandleNeeded: Boolean;
begin
  Result := FHandleNeeded or not HandleAllocated;
end;

class function TWaveBase.GetThreadClass: TWaveThreadClass;
begin
  Result:=TWaveThread;
end;

procedure TWaveBase.MMCheck(r: MMResult);
begin
  if r<>0 then
    raise Exception.Create(GetErrorMSG(r));
end;

procedure TWaveBase.PostBuffering;
begin

end;

procedure TWaveBase.PreBuffering;
begin

end;

procedure TWaveBase.PrepareBuffers;
var
  a:Integer;
begin
  if not FPlaying then
    Exit;
  FCriticalSection.Enter;
  try
    CloseBuffers;
    SetLength(FBuffers,FBufferCount);
    for a:=0 to High(FBuffers) do begin
      ZeroMemory(@FBuffers[a],SizeOf(FBuffers[a]));
      GetMem(FBuffers[a].lpData,FBufferSize);
      FillMemory(FBuffers[a].lpData,FBufferSize,128);
      FBuffers[a].dwBufferLength:=FBufferSize;
      FBuffers[a].dwUser:=Cardinal(TBufferEvent.Create(nil,False,False,''));
      TBufferEvent(FBuffers[a].dwUser).FIndex:=a;
      PrepareBuffer(FBuffers[a]);
    end;
    FCurrentClientBufferIndex:=0;
    for a:=0 to FBufferCount-1 do
      AddBuffer(FBuffers[a]);
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TWaveBase.SetBits16(const Value: Boolean);
begin
  FBits16 := Value;
  FHandleNeeded:=True;
end;

procedure TWaveBase.SetBufferCount(const Value: Integer);
begin
  Assert(Value>0,'Buffer count must be positive.');
  FBufferCount:=Value;
  PrepareBuffers;
end;

procedure TWaveBase.SetBufferSize(const Value: Cardinal);
begin
  Assert(Value>0,'Buffer size must be positive.');
  FBufferSize := Value;
  PrepareBuffers;
end;

procedure TWaveBase.SetDeviceID(const Value: Integer);
begin
  FDeviceID := Value;
  FHandleNeeded:=True;
end;

procedure TWaveBase.SetFrequency(const Value: Cardinal);
begin
  FFrequency := Value;
  FHandleNeeded:=True;
end;

procedure TWaveBase.SetOnBuffer(const Value: TOnBufferEvent);
begin
  FOnBuffer := Value;
end;

procedure TWaveBase.SetPlaying(const Value: Boolean);
begin
  if Value then
    Start
  else
    Stop;
end;

procedure TWaveBase.SetStereo(const Value: Boolean);
begin
  FStereo := Value;
  FHandleNeeded:=True;
end;

procedure TWaveBase.SetSynchronizedBufferEvent(const Value: Boolean);
begin
  FSynchronizedBufferEvent := Value;
end;

procedure TWaveBase.Start;
begin
  if not FPlaying then begin
    FPlaying:=True;
    try
      DoStart;
      try
        PrepareBuffers;
        FThread:=GetThreadClass.Create(Self);
        FThread.Resume;
      except
        DoStop;
        FPlaying:=False;
      end;
    except
      FPlaying:=False;
    end;
  end;
end;

procedure TWaveBase.Stop;
begin
  if FPlaying then begin
    FPlaying:=False;
    FThread.Destroy;
    CloseBuffers;
    DoStop;
    CloseHandle;
  end;
end;

procedure TWaveBase.Test;
begin
  if HandleNeeded then
    CreateHandle(True); 
end;

{ TWaveThread }

constructor TWaveThread.Create(AWave: TWaveBase);
begin
  inherited Create(True);
  FWave:=AWave;
  Priority:=tpHigher;
end;

destructor TWaveThread.Destroy;
begin
  Terminate;
  WaitFor;
  inherited;
end;

procedure TWaveThread.Execute;
var
  p:PWOHandleArray;
  a:Integer;
begin
  while not Terminated do begin
    with FWave do begin
      FCriticalSection.Enter;
      try
        TBufferEvent(FBuffers[FCurrentClientBufferIndex].dwUser).WaitFor(INFINITE);
        if FSynchronizedBufferEvent then
          SynChronize(PreBuffering)
        else
          PreBuffering;
        AddBuffer(FBuffers[FCurrentClientBufferIndex]);
        if FSynchronizedBufferEvent then
          SynChronize(PostBuffering)
        else
          PostBuffering;
        FCurrentClientBufferIndex:=(FCurrentClientBufferIndex+1) mod (High(FBuffers)+1);
      finally
        FCriticalSection.Leave;
      end;
    end;
  end;
  with FWave do begin
    FCriticalSection.Enter;
    GetMem(p,(High(FBuffers)+1)*SizeOf(THandle));
    try
      for a:=0 to High(FBuffers) do
        p[a]:=TBufferEvent(FBuffers[a].dwUser).Handle;
      WaitForMultipleObjects(High(FBuffers)+1,p,True,INFINITE);
    finally
      FreeMem(p);
      FCriticalSection.Leave;
    end;
  end;
end;

end.

