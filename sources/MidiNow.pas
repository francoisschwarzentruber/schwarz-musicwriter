unit MidiNow;

interface



Function MidiNow_OpenMidiDevice: Boolean;
Function MidiNow_CloseMidiDevice: Boolean;


procedure MidiNow_ChangerInstrument(instru: integer);

Procedure MidiNow_PlayNote(n, vel: Longword);
Procedure MidiNow_PlayNoteQuiDure(n, vel: Longword);
Procedure MidiNow_Shut;
Procedure MidiNow_ShutTout;

procedure MidiNow_Hard_NoteOn(canal, n, vel: Longword);
procedure MidiNow_Hard_NoteOff(canal, n, vel: Longword);
procedure MidiNow_Hard_ChangerInstrument(canal, instru: integer);


procedure MidiNow_Stop;


const midiNOTEON = $90;
      midiNOTEOFF = $80;
      midiCHANGEINSTRUMENT = $C0;

implementation



uses Sysutils, MMSystem,
  MidiType, Circbuf, MidiDefs, Delphmcb, ExtCtrls, {MidiOut} Windows, MusicWriter_Erreur;




var MidiHandle:integer = 0;
{normalement, on devrait mettre  MidiHandle:THandle,
  mais ça ne compile plus sous Delphi 6 :( }
  
  PCtlInfo: PMidiCtlInfo;
  NoteEnCours: array of Byte;
  NoteEnCoursQuiDurent: array of Byte;
  ErrorMidi: integer = -1;




  
function midioutErrorString( WError: Word ): String;
var
	errorDesc: PChar;
begin
     errorDesc := Nil;
	try
		errorDesc := StrAlloc(MAXERRORLENGTH);
		if midioutGetErrorText(WError, errorDesc, MAXERRORLENGTH) = 0 then
			result := StrPas(errorDesc)
		else
			result := 'Specified error number is out of range';
	finally
		If errorDesc <> Nil Then StrDispose(errorDesc);
	end;
end;




Function MidiNow_OpenMidiDevice: Boolean;
var
	hMem: THandle;

Begin
	Result := False;
	try
		{ Create the control info for the DLL }
		if (PCtlInfo = Nil) then
			begin
			PCtlInfo := GlobalSharedLockedAlloc( Sizeof(TMidiCtlInfo), hMem );
			PctlInfo^.hMem := hMem;
			end;

		Pctlinfo^.hWindow := 0;	{ Control's window handle }

		ErrorMidi := midioutOpen(@MidiHandle, 0{FDeviceId},
						DWORD(@midiHandler),
						DWORD(PCtlInfo),
						CALLBACK_FUNCTION);
{                FError := midioutOpen(@FMidiHandle, FDeviceId,
						Handle,
						DWORD(PCtlInfo),
						CALLBACK_WINDOW); }
	       If (ErrorMidi <> 0) then
			// TODO: use CreateFmtHelp to add MIDI device name/ID to message
			//raise EmidioutputError.Create(midioutErrorString(ErrorMidi))
                        MessageErreur('Erreur dans MidiNow.MidiNow_OpenMidiDevice ' + midioutErrorString(ErrorMidi))
               else
        	    Result := True;
			//FState := mosOpen;
               Finalize(NoteEnCours);
	except
		if PCtlInfo <> Nil then
			begin
			GlobalSharedLockedFree(PCtlInfo^.hMem, PCtlInfo);
			PCtlInfo := Nil;
			end;
	end;
End;


function MidiNow_CloseMidiDevice: Boolean;
begin
        result := false;
     	if ErrorMidi <> 0 then exit;
    {	Result := False;
	if FState = mosOpen then
		begin
                              }
        { Note this sends a lot of fast control change messages which some synths can't handle.
          TODO: Make this optional. }
{		FError := midioutReset(FMidiHandle);
		if Ferror <> 0 then
			raise EMidiOutputError.Create(MidiOutErrorString(FError)); }

		ErrorMidi := midioutClose(MidiHandle);
        if ErrorMidi <> 0 then
                MessageErreur('Erreur dans MidiNow_CloseMidiDevice ' + MidiOutErrorString(ErrorMidi))
			//raise EMidiOutputError.Create(MidiOutErrorString(ErrorMidi))
        else
        	Result := True;

	MidiHandle := 0;
	//FState := mosClosed;

        if (PCtlInfo <> Nil) then
		GlobalSharedLockedFree( PCtlinfo^.hMem, PCtlInfo );

        ErrorMidi := -1;

end;




Procedure MidiNow_Msg(msg, n, vel: Longword);
Begin
if ErrorMidi <> 0 then
         MidiNow_OpenMidiDevice;
                        
if ErrorMidi = 0 then
   midiOutShortMsg(MidiHandle, msg Or
                   (n shl 8) Or
	       	(vel shl 16));


End;

Procedure MidiNow_PlayNote(n, vel: Longword);
{joue une note (et ajoute cette note jouée dans la pile NoteEnCours de MidiNow}
Begin
   Setlength(NoteEnCours, length(NoteEnCours)+1);
   NoteEnCours[high(NoteEnCours)] := n;
   MidiNow_Msg(midiNOTEON, n, vel);
End;



Procedure MidiNow_PlayNoteQuiDure(n, vel: Longword);
{joue une note (et ajoute cette note jouée dans la pile NoteEnCours de MidiNow}
Begin
   Setlength(NoteEnCoursQuiDurent, length(NoteEnCoursQuiDurent)+1);
   NoteEnCoursQuiDurent[high(NoteEnCoursQuiDurent)] := n;
   MidiNow_Msg(midiNOTEON, n, vel);
End;



procedure MidiNow_Hard_NoteOn(canal, n, vel: Longword);
Begin
     MidiNow_Msg(midiNOTEON + canal, n, vel);
End;


procedure MidiNow_Hard_NoteOff(canal, n, vel: Longword);
Begin
     MidiNow_Msg(midiNOTEOFF + canal, n, vel);
End;

procedure MidiNow_Hard_ChangerInstrument(canal, instru: integer);
Begin
    MidiNow_Msg(midiCHANGEINSTRUMENT + canal, instru, 0);
End;

Procedure MidiNow_Shut;
var i:integer;
Begin
   if ErrorMidi = 0 then
      for i := 0 to high(NoteEnCours) do
          MidiNow_Msg(midiNOTEOFF, NoteEnCours[i], 127);

   {et si ErrorMidi <> 0, on entend de tte façon rien....}
End;


Procedure MidiNow_ShutTout;
var i:integer;
Begin
   if ErrorMidi = 0 then
   Begin
      for i := 0 to high(NoteEnCours) do
          MidiNow_Msg(midiNOTEOFF, NoteEnCours[i], 127);

      for i := 0 to high(NoteEnCoursQuiDurent) do
          MidiNow_Msg(midiNOTEOFF, NoteEnCoursQuiDurent[i], 127);


   End;       
   {et si ErrorMidi <> 0, on entend de tte façon rien....}
End;

procedure MidiNow_ChangerInstrument(instru: integer);
Begin
    MidiNow_Msg(midiCHANGEINSTRUMENT, instru, 0);
End;


procedure MidiNow_Stop;
Begin
    midiOutReset(MidiHandle);
End;

end.
