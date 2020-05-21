unit Entree_WaveIn_SortieMIDI;

interface

uses MusicHarmonie;


procedure Entree_WaveIn_SortieMIDI_Stop;
procedure Entree_WaveIn_SortieMIDI_Play(hn: THauteurNote);


implementation

uses MidiNow, MusicWriterToMIDI {HauteurNoteToMIDINote};


var hn_ancien: THauteurNote;
    yaunson: Boolean= false;


procedure Entree_WaveIn_SortieMIDI_Stop;
Begin
      yaunson := false;
      MidiNow_ShutTout;
End;



Procedure Entree_WaveIn_SortieMIDI_Play(hn: THauteurNote);
Begin
      if (not yaunson) or not IsHauteursNotesEgales(hn, hn_ancien) then
      Begin
            yaunson := true;
            hn_ancien := hn;
            MidiNow_ShutTout;
            MidiNow_ChangerInstrument(73);
            MidiNow_PlayNoteQuiDure(HauteurNoteToMIDINote(hn), 128);
      End;
End;

end.
