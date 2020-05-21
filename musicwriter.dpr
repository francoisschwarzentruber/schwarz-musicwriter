program Mdiapp;

{$DEFINE PRECOND}      
{$DEFINE POSTCOND}
{%ToDo 'mdiapp.todo'}





uses
  Forms,
  Main in 'sources\MAIN.PAS' {MainForm},
  Childwin in 'sources\CHILDWIN.PAS' {MDIChild},
  MusicSystem in 'sources\MusicSystem.pas',
  QSystem in 'sources\QSystem.pas',
  MusicGraph in 'sources\MusicGraph.pas',
  MusicUser in 'sources\MusicUser.pas',
  MusicHarmonie in 'sources\MusicHarmonie.pas',
  sauveimg in 'sources\sauveimg.pas' {frmSauvegardeImage},
  FileSystem in 'sources\FileSystem.pas',
  UModeles in 'sources\UModeles.pas',
  Intro in 'sources\Intro.pas' {frmIntro},
  MusicWriterToMIDI in 'sources\MusicWriterToMIDI.pas',
  UMidiFile in 'sources\UMidiFile.pas',
  ProprietesPortee in 'sources\ProprietesPortee.pas' {frmProprietesPortee},
  MusicWriter_Console in 'sources\MusicWriter_Console.pas' {frmConsole},
  Imprimer in 'sources\Imprimer.pas' {frmImprimer},
  Ouvrir in 'sources\Ouvrir.pas' {frmOuvrir},
  Proprietes in 'sources\Proprietes.pas' {frmProprietes},
  MusicStylet in 'sources\MusicStylet.pas',
  Doigtes in 'sources\Doigtes.pas' {frmDoigtes},
  Duree in 'sources\Duree.pas' {frmDuree},
  Options in 'sources\Options.pas' {frmOptions},
  nuances in 'sources\nuances.pas' {frmNuances},
  MidiNow in 'sources\MidiNow.pas',
  help in 'sources\help.pas' {frmHelp},
  Voix in 'sources\Voix.pas' {frmVoix},
  About in 'sources\About.pas' {AboutBox},
  MusicWriterToWAV in 'sources\MusicWriterToWAV.pas',
  musictowave in 'sources\musictowave.pas',
  choix in 'sources\choix.pas' {frmChoix},
  error in 'sources\error.pas' {frmError},
  instruments in 'sources\instruments.pas',
  transposition in 'sources\transposition.pas' {frmTransposition},
  Correction in 'sources\Correction.pas' {frmCorrection},
  MusicUser_Keys in 'sources\MusicUser_Keys.pas',
  MusicGraph_System in 'sources\MusicGraph_System.pas',
  MusicGraph_CouleursVoix in 'sources\MusicGraph_CouleursVoix.pas',
  MusicGraph_Portees in 'sources\MusicGraph_Portees.pas',
  MusicGraph_CercleNote in 'sources\MusicGraph_CercleNote.pas',
  MusicGraph_GestionImage in 'sources\MusicGraph_GestionImage.pas',
  MusicGraph_Images in 'sources\MusicGraph_Images.pas',
  MusicSystem_ElMusical in 'sources\MusicSystem_ElMusical.pas',
  MusicWriter_Erreur in 'sources\MusicWriter_Erreur.pas',
  MusicSystem_Voix in 'sources\MusicSystem_Voix.pas',
  MusicSystem_Mesure in 'sources\MusicSystem_Mesure.pas',
  MusicSystem_Types in 'sources\MusicSystem_Types.pas',
  MusicSystem_CompositionBase in 'sources\MusicSystem_CompositionBase.pas',
  MusicSystem_CompositionAvecPagination in 'sources\MusicSystem_CompositionAvecPagination.pas',
  MusicSystem_CompositionAvecSelection in 'sources\MusicSystem_CompositionAvecSelection.pas',
  cancellation in 'sources\cancellation.pas',
  MusicSystem_CompositionAvecSelectionApplication in 'sources\MusicSystem_CompositionAvecSelectionApplication.pas',
  RectList in 'sources\RectList.pas',
  utils in 'sources\utils.pas',
  MusicGraph_User in 'sources\MusicGraph_User.pas',
  MusicSystem_CompositionSub in 'sources\MusicSystem_CompositionSub.pas',
  MusicSystem_CompositionGestionMesure in 'sources\MusicSystem_CompositionGestionMesure.pas',
  MusicSystem_ElMusical_Duree in 'sources\MusicSystem_ElMusical_Duree.pas',
  MusicSystem_ElMusical_Liste_Notes in 'sources\MusicSystem_ElMusical_Liste_Notes.pas',
  MusicSystem_Constantes in 'sources\MusicSystem_Constantes.pas',
  Pourcentage in 'sources\Pourcentage.pas' {frmPourcentage},
  MusicGraph_CouleursUser in 'sources\MusicGraph_CouleursUser.pas',
  jeu in 'sources\jeu.pas' {frmJeu},
  Voix_Gestion in 'sources\Voix_Gestion.pas',
  Lettre in 'sources\Lettre.pas' {frmLettre},
  DureeCourante_Gestion in 'sources\DureeCourante_Gestion.pas',
  MusicSystem_CompositionBaseAvecClef in 'sources\MusicSystem_CompositionBaseAvecClef.pas',
  MusicSystem_MesureBase in 'sources\MusicSystem_MesureBase.pas',
  MusicSystem_MesureAvecClefs in 'sources\MusicSystem_MesureAvecClefs.pas',
  MusicSystem_Octavieurs_Liste in 'sources\MusicSystem_Octavieurs_Liste.pas',
  MusicSystem_Curseur in 'sources\MusicSystem_Curseur.pas',
  CurseursSouris in 'sources\CurseursSouris.pas',
  Options_SaveAndLoad in 'sources\Options_SaveAndLoad.pas',
  MusicWriter_Aide in 'sources\MusicWriter_Aide.pas',
  MusicSystem_Composition_Portees_Liste in 'sources\MusicSystem_Composition_Portees_Liste.pas',
  Windows,
  MusicWriter_Chargement_Thread in 'sources\MusicWriter_Chargement_Thread.pas',
  MusicSystem_CompositionGestionBarresDeMesure in 'sources\MusicSystem_CompositionGestionBarresDeMesure.pas',
  MusicSystem_CompositionLectureMIDI in 'sources\MusicSystem_CompositionLectureMIDI.pas',
  MusicSystem_CompositionListeObjetsGraphiques in 'sources\MusicSystem_CompositionListeObjetsGraphiques.pas',
  MusicSystem_CompositionAvecGestionNuances in 'sources\MusicSystem_CompositionAvecGestionNuances.pas',
  MusicSystem_CompositionAvecRoutinesDeTraitement in 'sources\MusicSystem_CompositionAvecRoutinesDeTraitement.pas',
  piano in 'sources\piano.pas' {frmPiano},
  piano_gestion in 'sources\piano_gestion.pas',
  bienvenue in 'sources\bienvenue.pas' {frmBienvenue},
  Nouveau_Assistant in 'sources\Nouveau_Assistant.pas' {frmNouveau_Assistant},
  tablature_system in 'sources\tablature_system.pas',
  frmBeta in 'sources\frmBeta.pas' {frmBetaMessage},
  navigateur in 'sources\navigateur.pas' {frameNavigateur},
  frame_Rythme in 'sources\frame_Rythme.pas' {frameRythme: TFrame},
  CurseurSouris_Busy in 'sources\CurseurSouris_Busy.pas',
  piano_doigteur in 'sources\piano_doigteur.pas',
  Musicwriter_langue in 'sources\Musicwriter_langue.pas',
  alterer_selon_une_tonalite in 'sources\alterer_selon_une_tonalite.pas' {frmAlterer_Selon_Une_Tonalite},
  MidiNowInstrument in 'sources\MidiNowInstrument.pas',
  Midi_in in 'sources\Midi_in.pas',
  Musicwriter_MidiIn in 'sources\Musicwriter_MidiIn.pas',
  Instrument_Portee in 'sources\Instrument_Portee.pas' {frmComposition_Instruments},
  frame_Composition_Instruments in 'sources\frame_Composition_Instruments.pas' {frameComposition_Instruments: TFrame},
  Magnetophone in 'sources\Magnetophone.pas' {frmMagnetophone},
  MusicSystem_Composition in 'sources\MusicSystem_Composition.pas',
  Enregistrer_Source in 'sources\Enregistrer_Source.pas' {frmEnregistreur},
  Instrument_Add in 'sources\Instrument_Add.pas' {frmInstrument_Add},
  frame_Instruments_Choix in 'sources\frame_Instruments_Choix.pas' {frameInstruments_Choix: TFrame},
  Instrument_Proprietes in 'sources\Instrument_Proprietes.pas' {frmInstrument_Proprietes},
  Selection_Deplacer_Voix in 'sources\Selection_Deplacer_Voix.pas' {frmSelection_Deplacer_Voix},
  Message_Vite_Fait in 'sources\Message_Vite_Fait.pas' {frmMessageViteFait},
  MusicSystem_Composition_I_Portees in 'sources\MusicSystem_Composition_I_Portees.pas',
  Paroles in 'sources\Paroles.pas' {frmParoles},
  MusicSystem_Composition_Avec_Paroles in 'sources\MusicSystem_Composition_Avec_Paroles.pas',
  TimerDebugger in 'sources\TimerDebugger.pas',
  frame_Tonalite in 'sources\frame_Tonalite.pas' {frameTonalite_Anneau: TFrame},
  frame_Duree_Entree in 'sources\frame_Duree_Entree.pas' {frameDureeEntree: TFrame},
  I_Trilles_Et_Attributs in 'sources\I_Trilles_Et_Attributs.pas',
  Voix_Liste_Vite_Fait in 'sources\Voix_Liste_Vite_Fait.pas' {frmVoixListeViteFait},
  Miditype in 'sources\MIDITYPE.PAS',
  Mididefs in 'sources\MIDIDEFS.PAS',
  Circbuf in 'sources\CIRCBUF.PAS',
  Delphmcb in 'sources\DELPHMCB.PAS',
  Midicons in 'sources\MIDICONS.PAS',
  Cancellation_Window in 'sources\Cancellation_Window.pas' {frmCancellation_Window},
  Magnetophone_Curseur_Init in 'sources\Magnetophone_Curseur_Init.pas',
  MusicGraph_RegleTemps in 'sources\MusicGraph_RegleTemps.pas',
  QSystem_Inference in 'sources\QSystem_Inference.pas',
  peripherique_entree in 'sources\peripherique_entree.pas' {frmPeripheriqueEntree},
  Interface_Questions in 'sources\Interface_Questions.pas' {frmInterfaceQuestions},
  Ajuster_alterations_notes_selon_tonalite in 'sources\Ajuster_alterations_notes_selon_tonalite.pas' {frmAjuster_Alterations_Notes_Selon_Une_Tonalite},
  Rien_fenetre in 'sources\Rien_fenetre.pas' {frmFenetreRien},
  Entree_WaveIn in 'sources\Entree_WaveIn.pas' {frmEntree_WaveIn},
  Entree_WaveIn_Signal_Type in 'sources\Entree_WaveIn_Signal_Type.pas',
  WaveIn in 'sources\WaveIn.pas',
  WaveBase in 'sources\WaveBase.pas',
  Entree_WaveIn_FFT_Form in 'sources\Entree_WaveIn_FFT_Form.pas' {frmEntree_Wavein_FFT},
  Entree_WaveIn_FFT in 'sources\Entree_WaveIn_FFT.pas',
  frame_Transposition in 'sources\frame_Transposition.pas' {frameTransposition: TFrame},
  Entree_WaveIn_SortieMIDI in 'sources\Entree_WaveIn_SortieMIDI.pas',
  frame_Duree_Choix in 'sources\frame_Duree_Choix.pas' {frameDureeChoix: TFrame},
  PressePapier_Form in 'sources\PressePapier_Form.pas' {frmPressePapier},
  Magnetophone_System in 'sources\Magnetophone_System.pas',
  EnregistrerAvertissement in 'sources\EnregistrerAvertissement.pas' {frmEnregistrerAvertissement},
  langues in 'sources\langues.pas',
  typestableaux in 'sources\typestableaux.pas',
  AideGenerale in 'sources\AideGenerale.pas' {frmAideGenerale},
  MusicUser_PlusieursDocuments in 'sources\MusicUser_PlusieursDocuments.pas',
  alterer in 'sources\alterer.pas' {frmSelectionAlterer},
  USauvegarde_Cayest in 'sources\USauvegarde_Cayest.pas' {frmSauvegarde_Cayest},
  UOperation_Voix_Selectionner_Dans_Partition in 'sources\UOperation_Voix_Selectionner_Dans_Partition.pas',
  UConversion_Musicwriter_Vers_Lilypond in 'sources\UConversion_Musicwriter_Vers_Lilypond.pas',
  langue_fenetre in 'sources\langue_fenetre.pas' {frmLangue_Choix},
  frmMesuresTempo in 'sources\frmMesuresTempo.pas' {frmMesures_Tempo},
  frmMesuresMetronome in 'sources\frmMesuresMetronome.pas' {frmMesures_Metronome},
  frmMesuresSignatureTemporelle in 'sources\frmMesuresSignatureTemporelle.pas' {frmMesures_Signature_Temporelle},
  frmMesuresTonalite in 'sources\frmMesuresTonalite.pas' {frmMesures_Tonalite},
  frmMesuresBarres in 'sources\frmMesuresBarres.pas' {frmMesures_Barres},
  MusicUser_Mode_Mesures in 'sources\MusicUser_Mode_Mesures.pas',
  FonctionsAcess in 'sources\FonctionsAcess.pas' {frmFonctionsAccess},
  UTransposerNotesALaSouris in 'sources\UTransposerNotesALaSouris.pas',
  InterfaceGraphique_Complements in 'sources\InterfaceGraphique_Complements.pas';

{$R *.RES}

var chargement_temps: Int64;

begin
  chargement_temps := gettickcount;

  DossierRacine_Init;
  Langues_Traduction_Charger;
  //Langues_LangueCourante_Set(langueEnglish);
//  Langues_LangueCourante_Set(langueFrancais);
  Langues_LangueCourante_ChoperDeLaConfigurationCourante;
  
  frmIntro := TfrmIntro.Create(nil);
  With frmIntro do
  Begin
        Show;
        Update;

        Application.Initialize;
        //InstrumentsInitialize;
        FenetreIntro_Texte('chargement de la fenêtre principale...');
        Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmParoles, frmParoles);
  Application.CreateForm(TfrmCancellation_Window, frmCancellation_Window);
  Application.CreateForm(TfrmPeripheriqueEntree, frmPeripheriqueEntree);
  Application.CreateForm(TfrmInterfaceQuestions, frmInterfaceQuestions);
  Application.CreateForm(TfrmAjuster_Alterations_Notes_Selon_Une_Tonalite, frmAjuster_Alterations_Notes_Selon_Une_Tonalite);
  Application.CreateForm(TfrmFenetreRien, frmFenetreRien);
  Application.CreateForm(TfrmEntree_WaveIn, frmEntree_WaveIn);
  Application.CreateForm(TfrmEntree_Wavein_FFT, frmEntree_Wavein_FFT);
  Application.CreateForm(TfrmPressePapier, frmPressePapier);
  Application.CreateForm(TfrmEnregistrerAvertissement, frmEnregistrerAvertissement);
  Application.CreateForm(TfrmAideGenerale, frmAideGenerale);
  Application.CreateForm(TfrmSelectionAlterer, frmSelectionAlterer);
  Application.CreateForm(TfrmSauvegarde_Cayest, frmSauvegarde_Cayest);
  Application.CreateForm(TfrmLangue_Choix, frmLangue_Choix);
  Application.CreateForm(TfrmMesures_Tempo, frmMesures_Tempo);
  Application.CreateForm(TfrmMesures_Metronome, frmMesures_Metronome);
  Application.CreateForm(TfrmMesures_Signature_Temporelle, frmMesures_Signature_Temporelle);
  Application.CreateForm(TfrmMesures_Tonalite, frmMesures_Tonalite);
  Application.CreateForm(TfrmMesures_Barres, frmMesures_Barres);
  Application.CreateForm(TfrmFonctionsAccess, frmFonctionsAccess);
  FenetreIntro_Texte('boîte d''options...');
        Application.CreateForm(TfrmOptions, frmOptions);
        Application.CreateForm(TfrmBetaMessage, frmBetaMessage);
        Application.CreateForm(TfrmHelp, frmHelp);
        INILoad;

        chargement_temps := gettickcount - chargement_temps;
        MainForm.Chargement_Temps_Informer(chargement_temps);
        FenetreIntro_Cacher;
        Application.Run;
  end;

end.

