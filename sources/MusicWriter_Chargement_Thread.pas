unit MusicWriter_Chargement_Thread;

interface

uses Classes;

type

TChargementThread = class(TThread)
   procedure Execute; override;

   constructor Create;
  

end;


procedure MusicWriter_Chargement_Thread_Lancer;
procedure MusicWriter_Chargement_Thread_ExecuterDansThreadPrincipal;
procedure MusicWriter_Chargement_Thread_Terminer;








implementation

uses Main, instruments, MusicGraph_images, CurseursSouris, Intro, MusicUser;

var T: TChargementThread;
    T_fini: boolean = false;


constructor TChargementThread.Create;
Begin
    FreeOnTerminate := True;
    
    inherited Create(false);
End;



procedure TChargementThread.Execute;
begin
     MusicWriter_Chargement_Thread_ExecuterDansThreadPrincipal;
     T_fini := true;
end;




procedure MusicWriter_Chargement_Thread_Lancer;
Begin
    T := TChargementThread.Create;
    T.Priority := tpTimeCritical;

End;

procedure MusicWriter_Chargement_Thread_ExecuterDansThreadPrincipal;
Begin
   FenetreIntro_Texte('chargement de la liste des instruments...');
   InstrumentsInitialize;

   FenetreIntro_Texte('chargement des images d''instruments...');
   if MusicWriter_IsOnQuitteleprogramme then exit;
   MainForm.Instruments_Icones_Charger;

   FenetreIntro_Texte('chargement des curseurs...');
   CurseursSouris_Charger;

   FenetreIntro_Texte('chargement des bitmaps secondaires...');
   ChargerBitmaps_Secondaires;
   
End;

procedure MusicWriter_Chargement_Thread_Terminer;
Begin

End;

end.
