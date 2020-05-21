unit WaveIn;

interface


{Utilisation :
   création d'un objet WaveIn...
   WaveIn:=TWaveIn.Create(Self);
   WaveIn.OnBuffer:=WaveInBuffer;

   où WaveInBuffer est une méthode d'une fenêtre déclaré comme ça
      procedure WaveInBuffer(Buffer:Pointer;Length:Cardinal;BufferQueueLength:Integer);



   réglage des paramètres...
    WaveIn.DeviceID:= //numéro du device (0 ça marche)
    WaveIn.Stereo:= false ou true;
    WaveIn.Bits16:= false ou true;
    WaveIn.Frequency:= la fréquence
    WaveIn.BufferCount:=1+2 par exemple
    WaveIn.BufferSize:=Round(TabSizeMultiply[FWaveIn.Stereo,FWaveIn.Bits16] * nbmillesec * Integer(FWaveIn.Frequency)/1000);
                      c'est la taille du buffer en octets
}



{dans WaveInBuffer :
  function SampleValue(SampleIndex:Integer):Integer;               //Extract sample value from index
  begin
    if FWaveIn.Stereo then begin
      if FWaveIn.Bits16 then          //If 16bit then take the mean of the 2 channels
        Result:=(High(Word)+(Integer(SmallInt(PWordArray(Buffer)[2*SampleIndex]))+Integer(SmallInt(PWordArray(Buffer)[2*SampleIndex+1])))) div 2
      else
        Result:=(Integer(PByteArray(Buffer)[2*SampleIndex])+Integer(PByteArray(Buffer)[2*SampleIndex+1]))*128;
    end else begin
      if FWaveIn.Bits16 then
        Result:=(High(Word) div 2)+Smallint(PWordArray(Buffer)[SampleIndex])
      else
        Result:=PByteArray(Buffer)[SampleIndex]*256;
    end;
  end;

  n:= Integer(Length) div TabSizeMultiply[FWaveIn.Stereo,FWaveIn.Bits16]; // nombre de valuers dans le buffer


  }

uses
  SysUtils,MMSystem,Windows,Classes,SyncObjs,WaveBase;

type
  TWaveIn=class(TWaveBase)      //Nothing new, just overriden methods
  private
  protected
    class function GetAPIDeviceOpenProc:TAPIDeviceOpenProc;override;
    class function GetAPIDeviceCloseProc:TAPIDeviceCloseProc;override;
    class function GetErrorMSG(ErrorID:MMResult):string;override;
    procedure DoStop;override;
    procedure DoStart;override;
    procedure DoCallBack(uMSG:UINT;dwParam1,dwParam2:DWORD);override;

    procedure PrepareBuffer(var Buffer:TWaveBuffer);override;
    procedure UnPrepareBuffer(var Buffer:TWaveBuffer);override;
    procedure PreBuffering;override;
    procedure AddBuffer(var Buffer:TWaveBuffer);override;
    procedure PostBuffering;override;
  public
    constructor Create(AOwner:TComponent);override;
  end;

implementation

{ TWaveIn }

procedure TWaveIn.AddBuffer(var Buffer: TWaveBuffer);
begin
  MMCheck(waveInAddBuffer(Handle,@Buffer,SizeOf(Buffer)));
end;

constructor TWaveIn.Create(AOwner: TComponent);
begin
  inherited;
  DeviceID:=-1;
end;

procedure TWaveIn.DoCallBack(uMsg: UINT; dwParam1, dwParam2: DWORD);
begin
  case uMsg of
    WIM_DATA:begin
      TBufferEvent(PWaveHdr(dwParam1).dwUser).SetEvent;
      FCurrentServerBufferIndex:=TBufferEvent(PWaveHdr(dwParam1).dwUser).FIndex;
    end;
  end;
end;

procedure TWaveIn.DoStart;
begin
  MMCheck(waveInStart(Handle));
end;

procedure TWaveIn.DoStop;
begin
  MMCheck(waveInStop(Handle));
end;

class function TWaveIn.GetAPIDeviceCloseProc: TAPIDeviceCloseProc;
begin
  Result:=WaveInClose;
end;

class function TWaveIn.GetAPIDeviceOpenProc: TAPIDeviceOpenProc;
begin
  @Result:=@WaveInOpen;
end;

class function TWaveIn.GetErrorMSG(ErrorID: MMResult): string;
var
  p:array[0..MAXERRORLENGTH] of Char;
begin
  if WaveInGetErrorText(ErrorID,@p,MAXERRORLENGTH)=0 then
    Result:=p
  else
    Result:='Recursive error';
end;

procedure TWaveIn.PostBuffering;
begin
  if Assigned(OnBuffer) then
    with FBuffers[FCurrentClientBufferIndex] do
      OnBuffer(lpData,dwBytesRecorded,BufferQueueLength);
end;

procedure TWaveIn.PreBuffering;
begin

end;

procedure TWaveIn.PrepareBuffer(var Buffer: TWaveBuffer);
begin
  MMCheck(waveInPrepareHeader(Handle,@Buffer,SizeOf(Buffer)));
end;

procedure TWaveIn.UnPrepareBuffer(var Buffer: TWaveBuffer);
begin
  MMCheck(waveInUnprepareHeader(Handle,@Buffer,SizeOf(Buffer)));
end;

end.
