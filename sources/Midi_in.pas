unit Midi_in;
{unité interface pour gérer le midi_in... dans ce truc, IL N Y A PAS DE CODE QUI A AVOIR
 AVEC LA STRUCTURE TComposition etc.}

interface




type
   TMidiFunction = procedure (msg, n, vel, temps: integer);
   

procedure Midi_in_Start;
Function Midi_in_Is_Usable: Boolean;
Function Midi_in_Open(midi_in_device_num: integer): Boolean;
procedure Midi_in_Close;
Function Midi_In_Opened: Boolean;
procedure Midi_in_Set_MessageReceiver(f: TMidiFunction);



implementation

uses MMSystem, Windows {pour les types à la c_ _ comme UINT ...},
     MusicWriter_Console,
     SysUtils {pour inttostr},
     MusicWriter_Erreur;

var MidiHandle:integer = 0;
var SysExHeader: TmidiHdr;
var MessageReceiver: TMidiFunction = nil;
var midiHandler_deja_appele: integer = 0;



procedure Midi_in_Set_MessageReceiver(f: TMidiFunction);
Begin
     MessageReceiver := f;
End;



procedure midiHandler(
		  hMidiIn: HMidiIn;
		  wMsg: UINT;
		  dwInstance: DWORD;
		  dwParam1: DWORD;
		  dwParam2: DWORD); stdcall;
Begin
   {Console_AjouterLigne('midi in ok : ' +
                        inttostr(hMidiIn) + ', ' +
                        inttostr(wMsg) + ', ' +
                        inttostr(dwInstance) + ', ' +
                        inttostr(dwParam1) + ', ' +
                        inttostr(dwParam2));     }
   if midiHandler_deja_appele > 0 then
      midiHandler_deja_appele := midiHandler_deja_appele;
      
   inc(midiHandler_deja_appele);

   if @MessageReceiver = nil then
          MessageErreur('midiHandler car MessageReceiver à nil')
   else
          MessageReceiver(dwParam1 and $000000FF,
                   (dwParam1 and $0000FF00) shr 8,
                   (dwParam1 and $00FF0000) shr 16, dwParam2);
                   
   dec(midiHandler_deja_appele);
End;


function midiinErrorString( WError: Word ): String;
var
	errorDesc: PChar;
begin
     errorDesc := Nil;
	try
		errorDesc := StrAlloc(MAXERRORLENGTH);
		if midiinGetErrorText(WError, errorDesc, MAXERRORLENGTH) = 0 then
			result := StrPas(errorDesc)
		else
			result := 'Specified error number is out of range';
	finally
		If errorDesc <> Nil Then StrDispose(errorDesc);
	end;
end;




Function Midi_in_Is_Usable: Boolean;
Begin
    result := (midiInGetNumDevs > 0);
End;





Function Midi_in_Open(midi_in_device_num: integer): Boolean;
var ErrorMidi: integer;
Begin
     result := true;

     if not Midi_in_Is_Usable then
     Begin
         result := false;
         exit;
     End;


     MidiHandle := 0;
     ErrorMidi := midiinOpen(@MidiHandle, midi_in_device_num,
			cardinal(@midiHandler),
			midi_in_device_num,
			CALLBACK_FUNCTION);

     If (ErrorMidi <> 0) then
     Begin
          MessageErreur('Erreur dans Midi_in_Open : ' + midiinErrorString(ErrorMidi));
          result := false;
     End;

    SysExHeader.dwFlags := 0;

    ErrorMidi := midiInPrepareHeader(MidiHandle, @SysExHeader, SizeOf(TMidiHdr));
    ErrorMidi := midiInAddBuffer(MidiHandle, @SysExHeader, SizeOf(TMidiHdr));
    ErrorMidi := midiInStart(MidiHandle);
    If (ErrorMidi <> 0) then
    Begin
          MessageErreur('Erreur dans Midi_in_Open : ' + midiinErrorString(ErrorMidi));
          result := false;
    End;

    
End;



procedure Midi_in_Start;
var ErrorMidi: integer;
Begin
    if MidiHandle = 0 then
          MessageErreur('Midi_in_Start')
    else
    Begin
          ErrorMidi := midiInStart(MidiHandle);

          If (ErrorMidi <> 0) then
                  MessageErreur('Erreur dans midiInStart : ' + midiinErrorString(ErrorMidi));
    End;
End;



procedure Midi_in_Close;
const messsuppl = ' Peut-être que vous avez débranché le synthétiseur avant de fermer Musicwriter ?... c''est pas grave...';
var ErrorMidi: integer;
Begin
    if MidiHandle = 0 then exit;
            
    ErrorMidi := midiinStop(MidiHandle);

    if ErrorMidi <> 0 then
        MessageErreur('Erreur dans Midi_in_Close (midiinStop) : ' + MidiInErrorString(ErrorMidi) + messsuppl);

    ErrorMidi := midiInReset(MidiHandle);
    ErrorMidi := midiInUnprepareHeader(MidiHandle, @SysExHeader, SizeOf(TMidiHdr));

    ErrorMidi := midiinClose(MidiHandle);

    if ErrorMidi <> 0 then
        MessageErreur('Erreur dans Midi_in_Close (midiinClose) : ' + MidiInErrorString(ErrorMidi) + messsuppl);

	MidiHandle := 0;
End;



Function Midi_In_Opened: Boolean;
Begin
    result := (MidiHandle <> 0);
End;

end.
