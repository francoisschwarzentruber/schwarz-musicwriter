unit MusicUser;

interface

uses QSystem,
     MusicSystem,
     MusicSystem_Mesure,
     MusicSystem_ElMusical,
     MusicSystem_Types {pour TNote},
     Windows, MusicHarmonie, stdctrls, Error,
     MusicSystem_CompositionListeObjetsGraphiques,
     MusicUser_Keys,
     Menus,
     ComCtrls {pour TToolBar},
     Graphics;


const METRONOME_DEFAULT = 120;

      PORTEE_NOM_PAR_DEFAUT = '%i';



      
      option_DesFoisDessinerFondVoixQuandVoixNonEncorePresente = true;
      {si à true, affiche une fond de voix même si la voix dans laquelle on va
      écrire n'existe pas encore. Cela ralentit l'affichage :( }

      RayonCerclePointDessinCourbe = 40;
      {rayon des p'tits points clés d'une courbe de liaison}
      
      infinity = 2200000;

      ChgtDureeSelectionQuandDureeEntreeAuClavier = true;
       {si ChgtDureeSelectionQuandDureeEntreeAuClavier = false,
       il faut appuyer sur Ctrl pour changer la durée des éléments sélectionnés}

      ChgtAlterationSelectionQuandEntreeAuClavier = false;
       {de même, si ChgtAlterationSelectionQuandEntreeAuClavier = false,
       il faut appuyer sur Ctrl pour changer l'altération de toutes la sélection}

      RacourciClavierCtrlNPourChgtModele = false;
      {vaut vrai, si on utilise les raccourci Ctrl + 1 pour le 1er modèle,
                                              Ctrl + 2 pour le 2e modèle ... }




      UtiliserMidiNow = true;

      AfficherDureeSelectionneeSansDelai = false;



      AfficherNumMesureToutesLes = 5;
      AfficherCadreAutourMesureCourante = false;


      CurseurSouris_Deplace_NbPixelX = 18;
      bordureZoneTexte = 30;
      enplusZoneTexte = 160;
      hauteurCaractereZoneTexte = 160;

      BarreDOutilEpaisseur = 29;



      Modele_Zoom = 50;





      
type


TMusicWriter_Mode = (mw_mode_Fichier,
                     mw_mode_MettreNote,
                     mw_mode_Selection,
                     mw_mode_MettreClef,
                     mw_mode_MettreNuances,
                     mw_mode_Mesure,
                     mw_mode_Affichage,
                     mw_mode_Ecouter,
                     mw_mode_Enregistrer,
                     mw_mode_Options,
                     mw_mode_Paroles);

TOutil = (PlacerCurseur, MettreNote, MettreClef, MettreAlteration, MettreParoles,
          MettreNuance, MettreCourbe, Stylet, MettreOctavieur, MettreCrescendo, MettreDeCrescendo);

TOutilPlus = (opRien, opSelection, opDeplacer, opDeplacerPause,
              opDeplacerObjet, opDeplacerClavier, opDeplacerObjet_Point);





const modes_quand_pas_de_document = [mw_mode_Fichier, mw_mode_Options];



var ToucheCtrlEnfonce : Boolean;

    Outil: TOutil;
    OutilPlus: TOutilPlus;

    ModeClef_Outil_Clef_ClefSelectionnee: TClef;
    ModeClef_Outil_Octavieur_OctavieurSelectionnee: integer;

    ModeAlteration_Outil_Alteration_Selectionnee: TAlteration;



    NoteRefpixx: integer;
    NoteRefDeplacement: TNote;
    NoteRefDeplacementMesure: integer;
    DeplaceVersMesure: integer;
    DeplaceAuTemps: TRationnel;
    NoteRefDeplacementTemps: TRationnel;

    PorteeDeplacementRef: integer;
    Deplacement_Tablature_Corde_Ref: integer;
    
    DiffPorteeDeplacement: integer;

    
    Deplacement_IsSurTablature: boolean;
    Deplacement_Tablature_Corde_Deplacement: integer;
    Deplacement_Tablature_numcase: integer;
    
    DeplacerAutrePart: Boolean;
    PausesAvantCurseur: TListeRationnel;

    PressePapier: TMesure;

    TonaliteCourante: TTonalite = cTonaliteDeLaMesureCourante;
    iPorteeCourant: integer = 0;
    DossierRacine: string = '';
    MusicWriter_IsOnQuitteleprogramme: boolean = false;
    BoutonCtrlActive: Boolean;

    NuanceCourante: TNuanceValeur;

    private_MusicUser_Pourcentage_Init_gettickcount: Int64;
    private_MusicUser_Pourcentage_Informer_Et_Afficher_gettickcount: Int64;


procedure DossierRacine_Init;

Function IsVoixAccessibleEdition(n_v: integer): Boolean;
Procedure InitialiserVariable;


Function IsModeNuances: Boolean;
Function IsModeCorrection: Boolean;
Function CouleurNuances(vol: integer): integer;

procedure MeasureItemGeneriquePourListeInstruments(
          substr, nom_instru: string; var Height: Integer);


Function IsEnTrainDImprimer: Boolean;


Procedure MusicUser_Pourcentage_Init(titre: string);
Procedure MusicUser_Pourcentage_Free;
Procedure MusicUser_Pourcentage_Informer(pourcentage: real);

procedure MusicUser_MusicWriter_DeclarerPasDeModePrecedent;

procedure MusicUser_MusicWriter_Mode_Set(ms: TMusicWriter_Mode);
Function MusicUser_MusicWriter_IsMode_Selection: Boolean;
procedure MusicUser_MusicWriter_Mode_RevenirAuModeEcritureSiYavait;
procedure MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
procedure MusicUser_MusicWriter_ModeSelectionActive_ViteFait;

Function MusicUser_MusicWriter_Mode_Get: TMusicWriter_Mode;

Function MusicUser_MusicSystem_Mode_IsModeAvecVoixCourante: Boolean;
Function MusicUser_MusicWriter_Mode_IsModeAvecElementSousCurseur: Boolean;

Procedure MusicUser_MusicWriter_Modes_Deballer_SiBesoin;
Procedure MusicUser_MusicWriter_Modes_Remballer;

Function IsOutilMettreObjetGraphiqueDemandePoint: Boolean;

Function Outil_MettreNoteIsModeSouris: boolean;
Function Outil_MettreNoteIsModeClavier: boolean;


  



implementation



uses Main {pour ModeVoixAuto}, Forms, Options, controls, MusicGraph, Nuances,
     Help, SysUtils {pour Inttostr}, Dialogs {pour ShowMessage}, Correction,
     MusicGraph_System {pour CDevice},
     MusicGraph_CercleNote {pour NoteEnEllipse},
     MusicWriter_Erreur,
     Pourcentage,
     Childwin,
     Voix_Gestion,
     DureeCourante_Gestion,
     Options_SaveAndLoad {AfficherBulleDaide},
     MusicGraph_Portees,
     MusicSystem_CompositionAvecPagination,
     Instrument_Portee,
     Enregistrer_Source,
     piano,
     MusicUser_PlusieursDocuments,
     UOperation_Voix_Selectionner_Dans_Partition,
     InterfaceGraphique_Complements;



var
    MusicWriter_Mode: TMusicWriter_Mode = mw_mode_MettreNuances;
    MusicWriter_ModePrecedent: TMusicWriter_Mode = mw_mode_MettreNuances;

 Function IsOutilMettreObjetGraphiqueDemandePoint: Boolean;
 Begin
     result := (Outil = MettreCourbe) or (Outil = MettreCrescendo) or (Outil = MettreDeCrescendo);
 End;


 
  procedure DossierRacine_Init;
  Begin
      DossierRacine := ExtractFilePath(Application.EXEName); 
  End;



Function Outil_MettreNoteIsModeSouris: boolean;
Begin
    result := MainForm.mnuEcrireAvecSouris.Checked;
End;




Function Outil_MettreNoteIsModeClavier: boolean;
Begin
    result := MainForm.mnuEcrireAvecClavier.Checked;
End;


Function IsEnTrainDImprimer: Boolean;
{renvoie vrai ssi le logiciel est actuellement en train d'imprimer
 (ie de dessiner des choses qu'il envoie à l'imprimante)}
Begin
     result := CDevice = devImprimante;
End;


Function IsVoixAccessibleEdition(n_v: integer): Boolean;
Begin



    {soit on se trouve en mode auto, auquel cas toutes les voix sont accessibles
     soit la voix est sélectionnée}
     if not MusicWriter_IsFenetreDocumentCourante then
             result := Voix_Gestion_IsModeAutomatique
     else
           result := Voix_Gestion_IsModeAutomatique or (n_v = actchild.Curseur.GetiVoixSelectionnee);

    if ViewCourant <> nil then
    Begin
          if n_v < 0 then
                 result := Voix_Gestion_IsModeAutomatique
          else

          if not ViewCourant^.VoixAffichee[n_v] then
                result := false;
    End
    else
         result := true;
End;

Procedure InitialiserVariable;
Begin
      Outil := MettreNote;
      OutilPlus := opRIen;
      ModeClef_Outil_Clef_ClefSelectionnee := ClefSol;
      ModeClef_Outil_Octavieur_OctavieurSelectionnee := 0;
      ModeAlteration_Outil_Alteration_Selectionnee := aNormal;

      PressePapier := TMesure.Create;

End;














Function IsModeNuances: Boolean;
{renvoie vrai si l'utilisateur est en train d'éditer des nuances (p, mp ...)}
Begin
    if frmNuances = nil then
        result := false
    else
         result := frmNuances.visible;
End;


Function IsModeCorrection: Boolean;
{renvoie vrai si l'utilisateur est en train de corriger les erreurs dans sa partition}
Begin
      if frmCorrection = nil then
          result := false
      else
          result := frmCorrection.Visible;
End;


Function CouleurNuances(vol: integer): integer;
Begin
    result := frmNuances.imgDegradeNuance.Canvas.Pixels[vol * 129 div 128,2];
End;










procedure MeasureItemGeneriquePourListeInstruments(
          substr, nom_instru: string; var Height: Integer);
var p: integer;

Begin
  if substr = '' then
       p := 1
  else
      p := Pos(LowerCase(substr),
               LowerCase(nom_instru));
  if (p <> 0) then
     Height := 18
  else
     Height := 0;
End;


Procedure MusicUser_Pourcentage_Init(titre: string);
Begin
    private_MusicUser_Pourcentage_Init_gettickcount := GetTickCount;
    private_MusicUser_Pourcentage_Informer_Et_Afficher_gettickcount := private_MusicUser_Pourcentage_Init_gettickcount-5000;
    if frmPourcentage = nil then
        frmPourcentage := TfrmPourcentage.Create(nil);

    frmPourcentage.lblName.Caption := titre;
    
    MusicUser_Pourcentage_Informer(0.0);
End;


Procedure MusicUser_Pourcentage_Informer(pourcentage: real);
var IGPsav: TCompositionAvecPagination;

Begin
    if frmPourcentage = nil then
    Begin
          MessageErreur('Erreur : fenêtre Pourcentage à nil alors qu''on veut informer ! Et Init alors !?!?! Bon, je charge la fenêtre...');
          frmPourcentage := TfrmPourcentage.Create(nil);
          frmPourcentage.lblName.Caption := 'Je fais quelquechose (mais quoi je sais pas... car il y a une erreur dans le logiciel)';
          exit;
    End;

    
    if ((pourcentage = 0.0) and frmPourcentage.Visible) or
       ((not frmPourcentage.Visible) and
        (GetTickCount - private_MusicUser_Pourcentage_Init_gettickcount > 500)) then
        Begin
                IGPsav := IGP;
                if MusicWriter_IsFenetreDocumentCourante then
                      if IGP = actchild.Composition then
                            IGPsav := IGP;

                With frmPourcentage do
                Begin
                     Show;
                     Refresh;
                End;

                if IGPsav <> nil then
                     IGP := IGPsav;
        End;

    if (GetTickCount - private_MusicUser_Pourcentage_Informer_Et_Afficher_gettickcount > 200) then
    Begin
          frmPourcentage.ProgressBar.Position := Round(pourcentage * 1000);
          private_MusicUser_Pourcentage_Informer_Et_Afficher_gettickcount := GetTickCount;

    End;
    frmPourcentage.ProgressBar.Refresh;
End;


Procedure MusicUser_Pourcentage_Free;
Begin
    if frmPourcentage = nil then exit;
    frmPourcentage.Hide;
End;





Function MusicUser_MusicWriter_IsMode_Selection: Boolean;
Begin
    result := (MusicWriter_Mode = mw_mode_Selection);
End;



procedure MusicUser_MusicWriter_Mode_Set(ms: TMusicWriter_Mode);
      procedure panelVoixSelectionnee_Indicateur_RegarderSiVisible;
      var b: Boolean;
      Begin
           {tout l'indicateur de voix sélectionnée}
           b := false;

           if MusicWriter_Mode in [mw_mode_MettreNote,
                                   mw_mode_Selection] then
              b := true;

           MainForm.panelVoixSelectionnee_Indicateur.Visible := b;



           {bouton Nouvelle voix}
           b := false;

           if MusicWriter_Mode in [mw_mode_MettreNote] then
                 b := true;

           MainForm.tbnNvVoix.Visible := b;

           if b then
                 Voix_Gestion_ModeNouvelleVoix_Arreter;

      End;



      procedure panelBarre_Duree_RegarderSiVisible;
      Begin
          MainForm.panelBarre_Duree.Visible :=
                      MusicWriter_Mode in [mw_mode_MettreNote];
      End;


      procedure Mode_Fichier_Init;
      Begin
      End;

      
      procedure Mode_MettreNote_Init;
      Begin
           MainForm.frameEcrireDureeChoix.Enabled := true;
           MainForm.frameEcrireDureeChoix.OnChange;
           DureeCourante_Boucle;


      End;


      procedure Mode_Selection_Init;
      Begin
          if MusicWriter_IsFenetreDocumentCourante then
              actchild.I_Selection_MettreAJourInfo;
      End;


      procedure Mode_MettreClef_Init;
      Begin
           ToolBar_AppuyerSurBoutonsSelectionnes(MainForm.tlbClefs);
      End;

      procedure Mode_MettreNuances_Init;
      Begin
          ToolBar_AppuyerSurBoutonsSelectionnes(MainForm.tlbNuances);

      End;



      procedure Mode_Mesure_Init;
      Begin
           
      End;


      procedure Mode_Affichage_Init;
      Begin
      End;
      
      procedure Mode_Ecouter_Init;
      Begin
      End;


      procedure Mode_Enregistrer_Init;
      Begin
           frmEnregistreur_Show;
           //frmPiano_Show;
      End;

      procedure Mode_Options_Init;
      Begin
           frmOptions.show;
      End;

      procedure Mode_Paroles_Init;
      Begin
          Voix_Selectionner_Dans_Partition_Init('Clique sur la voix pour laquelle tu veux ajouter des paroles.');
          Voix_Selectionner_Dans_Partition_PasBesoinDuBoutonAnnuler;
      End;


      procedure Mode_Fichier_OnClose;
      Begin
      End;


      procedure Mode_MettreNote_OnClose;
      Begin
      End;


      procedure Mode_Selection_OnClose;
      Begin
      End;


      procedure Mode_MettreClef_OnClose;
      Begin
      End;


      procedure Mode_MettreNuances_OnClose;
      Begin
      End;


      procedure Mode_Mesure_OnClose;
      Begin
      End;



      procedure Mode_Affichage_OnClose;
      Begin
      End;


      procedure Mode_Ecouter_OnClose;
      Begin
      End;

      procedure Mode_Enregistrer_OnClose;
      Begin
          frmEnregistreur_Hide;
      End;

      procedure Mode_Options_OnClose;
      Begin
          frmOptions.Hide;
      End;

      procedure Mode_Paroles_OnClose;
      Begin
      End;




begin
      if (not MusicWriter_IsFenetreDocumentCouranteOuFenetreEnTrainDeSOuvrir) then
           if not (ms in modes_quand_pas_de_document) then
           Begin
                  MessageErreur('Le logiciel veut aller dans un mode dans lequel il ne peut aller car il n''y a pas de document ouvert.');
                  exit;
           End;

      if ms = MusicWriter_Mode then
            exit;


      case MusicWriter_Mode of
           mw_mode_Fichier: Mode_Fichier_OnClose;
           mw_mode_MettreNote: Mode_MettreNote_OnClose;
           mw_mode_Selection: Mode_Selection_OnClose;
           mw_mode_MettreClef: Mode_MettreClef_OnClose;
           mw_mode_MettreNuances: Mode_MettreNuances_OnClose;
           mw_mode_Mesure: Mode_Mesure_OnClose;
           mw_mode_Affichage: Mode_Affichage_OnClose;
           mw_mode_Ecouter: Mode_Ecouter_OnClose;
           mw_mode_Enregistrer: Mode_Enregistrer_OnClose;
           mw_mode_Options: Mode_Options_OnClose;
           mw_mode_Paroles: Mode_Paroles_OnClose;

           else
                MessageErreur('Mode incorrect dans MusicUser_MusicWriter_Mode_Set');
      end;

      MusicWriter_ModePrecedent := MusicWriter_Mode;
      MusicWriter_Mode := ms;


      MainForm.Modes_PageControl.ActivePageIndex := integer(MusicWriter_Mode);
      MainForm.Modes_PageControlChange(nil);
      panelVoixSelectionnee_Indicateur_RegarderSiVisible;
      panelBarre_Duree_RegarderSiVisible;



      if ms <> mw_mode_Selection then
      if MusicWriter_IsFenetreDocumentCourante then
      With actchild do With Composition do
             if Selection_YaUneSelection then
             Begin
                  Selection_ToutDeselectionner;
                  ReaffichageComplet;
             End;

      Voix_Selectionner_Dans_Partition_Close;       
      case ms of
           mw_mode_Fichier: Mode_Fichier_Init;
           mw_mode_MettreNote: Mode_MettreNote_Init;
           mw_mode_Selection: Mode_Selection_Init;
           mw_mode_MettreClef: Mode_MettreClef_Init;
           mw_mode_MettreNuances: Mode_MettreNuances_Init;
           mw_mode_Mesure: Mode_Mesure_Init;
           mw_mode_Affichage: Mode_Affichage_Init;
           mw_mode_Ecouter: Mode_Ecouter_Init;
           mw_mode_Enregistrer: Mode_Enregistrer_Init;
           mw_mode_Options: Mode_Options_Init;
           mw_mode_Paroles: Mode_Paroles_Init;

           else
                MessageErreur('Mode incorrect dans MusicUser_MusicWriter_Mode_Set');
      end;

      if MusicWriter_IsFenetreDocumentCourante then
          actchild.ReaffichageComplet;
End;




procedure MusicUser_MusicWriter_DeclarerPasDeModePrecedent;
Begin
      MusicWriter_ModePrecedent := MusicWriter_Mode;
End;

procedure MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
Begin
    MusicUser_MusicWriter_Mode_Set(MusicWriter_ModePrecedent);
End;


procedure MusicUser_MusicWriter_Mode_RevenirAuModeEcritureSiYavait;
Begin
    if (MusicWriter_ModePrecedent = mw_mode_MettreNote) then
         MusicUser_MusicWriter_Mode_Set(MusicWriter_ModePrecedent);
End;


procedure MusicUser_MusicWriter_ModeSelectionActive_ViteFait;
var MusicWriter_Mode_Ancien : TMusicWriter_Mode;
Begin
    MusicWriter_Mode_Ancien := MusicWriter_Mode;
    
    MusicUser_MusicWriter_Mode_Set(mw_mode_Selection);

    if MusicWriter_Mode <> MusicWriter_Mode_Ancien then
            MusicWriter_ModePrecedent := MusicWriter_Mode_Ancien;
End;



Function MusicUser_MusicWriter_Mode_Get: TMusicWriter_Mode;
Begin
    Result := MusicWriter_Mode;
End;



Function MusicUser_MusicSystem_Mode_IsModeAvecVoixCourante: Boolean;
{renvoie vrai si on se trouve dans un mode où le numéro de voix courant est important
  ex : pour mettre une nuance, ou pour mettre une clef on s'en fout}
Begin
    result := (MusicWriter_Mode in [mw_mode_MettreNote, mw_mode_Selection])
                and not actchild.IsModeSelectionMesure;
End;



Function MusicUser_MusicWriter_Mode_IsModeAvecElementSousCurseur: Boolean;
Begin
    result := MusicWriter_Mode in [mw_mode_MettreNote];
End;



Function private_MusicUser_MusicWriter_Modes_IsDejaToutDeballe: Boolean;
Begin
    result := MainForm.Modes_PageControl_MettreNote.TabVisible;
End;


Procedure private_MusicUser_MusicWriter_Modes_Deballer;
Begin
    MainForm.Modes_PageControl_Traiter(true);
End;


Procedure MusicUser_MusicWriter_Modes_Deballer_SiBesoin;
Begin
     if not private_MusicUser_MusicWriter_Modes_IsDejaToutDeballe then
          Begin
               private_MusicUser_MusicWriter_Modes_Deballer;
               MusicUser_MusicWriter_Mode_Set(mw_mode_MettreNote);
          End;
End;



Procedure MusicUser_MusicWriter_Modes_Remballer;
Begin
    MainForm.Modes_PageControl_Traiter(false);
End;








end.
