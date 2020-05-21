unit Musicwriter_MidiIn;

interface


Function Midi_In_Init_Basique(num_device: integer): Boolean;
Function Midi_In_Is_Used: Boolean;
procedure Midi_In_Free;

Function MIDINoteToNbDemiTon(midinote: integer): integer;

procedure Midi_In_Demarrage_Essai;













implementation

uses Midi_In {pour la gestion midi},
     MusicHarmonie {THauteurNote},
     MusicWriter_Console {pour Console},
     SysUtils {pour inttostr},
     Main{pour actchild},
     MusicSystem_types,
     Math,
     MusicGraph_System,
     MusicSystem_ElMusical,
     Message_Vite_Fait,
     Intro,
     MusicUser {pour Outil_MettreNoteIsModeSouris},
          MusicUser_PlusieursDocuments;



Function MIDINoteToNbDemiTon(midinote: integer): integer;
Begin
     result := midinote - 60;

End;






procedure MessageReceiver_Basique(msg, n, vel, temps: integer);
var nb_demiton: integer;
    hn: THauteurNote;
    
Begin
    if msg = 248 then
        exit;
        
    Console_AjouterLigne('midi in : ' +
                        inttostr(msg) + ', ' +
                        inttostr(n) + ', ' +
                        inttostr(vel) + ', ' +
                        inttostr(temps));

    if (vel > 0) and (msg = 144) and (MusicWriter_IsFenetreDocumentCourante) and
        (not Outil_MettreNoteIsModeSouris) then
      With actchild do
      Begin
           nb_demiton := MIDINoteToNbDemiTon(n);
           hn := NbDemiTonToHauteurNote(nb_demiton, Curseur.GetTonaliteCourante);

           Entree_HauteurNote_Traiter(hn);

      End;
End;




Function Midi_In_Init_Basique(num_device: integer): Boolean;
Begin
   Midi_in_Set_MessageReceiver(MessageReceiver_Basique);
   result := true;
   if not Midi_In_Is_Used then
        result := Midi_in_Open(0);



End;








Function Midi_In_Is_Used: Boolean;
Begin
    result := Midi_In_Opened;
End;




procedure Midi_In_Free;
Begin
    Midi_in_Close;
End;







procedure Midi_In_Demarrage_Essai;
Begin
      if Midi_in_Is_Usable then
      Begin
          Intro_PeripheriqueMIDIDetecte;
          Midi_In_Init_Basique(0);
      End;
End;






end.
