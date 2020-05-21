unit MidiNowInstrument;

interface

uses
  Classes;

type
  TMidiNowInstrumentThread = class(TThread)
  private
    { Déclarations privées }
  protected
    procedure Execute; override;
  public
    constructor Create(instrument_num: integer);
  end;

implementation

uses MidiNow, Windows {pour GetTickCount};

{ Important : les méthodes et propriétés des objets de la VCL ou CLX peuvent uniquement être
  utilisées dans une méthode appelée avec Synchronize. Par exemple,

      Synchronize(UpdateCaption);

  UpdateCaption ayant l''apparence suivante :

    procedure MidiNowInstrument.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ MidiNowInstrument }


procedure Wait(milli: integer);
var t , delta: Int64;
Begin
     t := GetTickCount;
     delta := 0;
     while (0 <= delta) and (delta < milli) do
     Begin
        delta := GetTickCount - t;
     ENd;
End;


constructor TMidiNowInstrumentThread.Create(instrument_num: integer);
Begin
    MidiNow_ChangerInstrument(instrument_num);
    inherited Create(false);
End;

procedure TMidiNowInstrumentThread.Execute;
var i: integer;
begin
   for i := 0 to 2 do
   Begin
       MidiNow_PlayNote(60+random(10), 55);
       Wait(100 + random(300));
       MidiNow_Shut;
   End;

end;

end.
