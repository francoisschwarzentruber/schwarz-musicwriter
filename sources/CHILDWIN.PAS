unit Childwin;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,

     MusicSystem_Composition,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_Types {pour TPosition},
     MusicSystem_ElMusical {pour pouvoir parler de l'élément musical sous la souris},
     MusicSystem_CompositionAvecPagination,
     MusicSystem_CompositionLectureMIDI {pour le type TListeDeLecture},

     MusicGraph,
     MusicGraph_User,
     QSystem, Sysutils, musicuser, MusicUser_Keys, MusicHarmonie, UModeles,
     ExtCtrls, Dialogs, FileSystem, MusicWriterTOMIDI, ComCtrls, MusicStylet,
     Menus, ToolWin, Cancellation,

     RectList, utils,
     MusicSystem_Curseur,

     Options_SaveAndLoad, Buttons,
     MusicSystem_CompositionListeObjetsGraphiques, navigateur,
     Magnetophone_Curseur_Init;

type

  TEnregistreur_Notes_Enfoncees = record
       imesure: integer;
       temps: TRationnel;
       nb_demiton: integer;
  end;


  TMDIChild = class(TForm)
    HScrollBar: TScrollBar;
    VScrollBar: TScrollBar;
    tmrKeyWait: TTimer;
    tmrSourisCurseur_Clignotement_Timer: TTimer;
    tmrAffichageClignotant: TTimer;
    tmrDemarrerAnimationEditionMesure: TTimer;
    tmrDefilTimer: TTimer;
    PopupMenuSelection: TPopupMenu;
    Couper1: TMenuItem;
    Coper1: TMenuItem;
    Supprimer1: TMenuItem;
    Sousslectionner1: TMenuItem;
    Noteduhaut1: TMenuItem;
    Notesdubas1: TMenuItem;
    Dplacer1: TMenuItem;
    Duneoctaveverslehaut1: TMenuItem;
    Duneoctaveverslebas1: TMenuItem;
    PopupMenuCurseur: TPopupMenu;
    Coller1: TMenuItem;
    Collereninversant1: TMenuItem;
    Lirepartirdici1: TMenuItem;
    PopupMenuLecture: TPopupMenu;
    Arrterlalecture1: TMenuItem;
    Apparences1: TMenuItem;
    Queueverslehaut1: TMenuItem;
    Queueverslebas1: TMenuItem;
    Notesquisontdessi1: TMenuItem;
    Altrer1: TMenuItem;
    Dise1: TMenuItem;
    Doublebmol1: TMenuItem;
    bmol1: TMenuItem;
    Diser1: TMenuItem;
    Doublediser1: TMenuItem;
    Reprendrelalecturepartirdici1: TMenuItem;
    Affichage1: TMenuItem;
    mnuJusteCettePortee: TMenuItem;
    outeslesportes1: TMenuItem;
    Voix1: TMenuItem;
    mnuEcrireDansUneNouvelleVoix: TMenuItem;
    mnuEcrireDansLaVoixSousLeCurseur: TMenuItem;
    Placerlecurseurici1: TMenuItem;
    Extraireunmodle1: TMenuItem;
    Voixautomatiquecriredanslesvoixpardfaut1: TMenuItem;
    Insrer1: TMenuItem;
    Clefs1: TMenuItem;
    Clefdesol1: TMenuItem;
    Clefdefa1: TMenuItem;
    Clefdut1: TMenuItem;
    PopupMenuClef: TPopupMenu;
    Clefdesol2: TMenuItem;
    Clefdefa2: TMenuItem;
    Clefdut2: TMenuItem;
    Mesures1: TMenuItem;
    Insrerunemesureavant1: TMenuItem;
    Insrerunemesureaprs1: TMenuItem;
    mnuProprietedelaportee: TMenuItem;
    CoinDroitBas: TPanel;
    Octavier1: TMenuItem;
    Duneoctaveverslehaut2: TMenuItem;
    Duneoctaveverslebas2: TMenuItem;
    Continuerlcritureavecunemontechromatique1: TMenuItem;
    Continuerlcritureavecunedescentechromatique1: TMenuItem;
    mnuCyclerlesvoix: TMenuItem;
    mnuCyclerlesvoix_DansMenuSelection: TMenuItem;
    mnuSupprimerlamesure: TMenuItem;
    PopupMenuRythmeEtTonalite: TPopupMenu;
    ToolBarVue: TToolBar;
    tbnModeRuban: TToolButton;
    tbnModePageEditer: TToolButton;
    tbnModePageClean: TToolButton;
    panStatusBar: TPanel;
    tmrFormResizing: TTimer;
    Calculerlarrache1: TMenuItem;
    mnuTransposer: TMenuItem;
    Unlmentmusicalsur21: TMenuItem;
    Arpger1: TMenuItem;
    ArpegerVerslehaut1: TMenuItem;
    ArpegerVerslebas1: TMenuItem;
    Fusionner1: TMenuItem;
    Collerdesgrosaccords1: TMenuItem;
    Dure1: TMenuItem;
    Multiplierlesdurespar21: TMenuItem;
    Diviserlesdurespar21: TMenuItem;
    Rendrejolilamesure1: TMenuItem;
    Simplifierlcrituredelamesure1: TMenuItem;
    Enfairepleinpareil1: TMenuItem;
    mnuI_Selection_FusionnerNotesEtSilences: TMenuItem;
    mnuI_Selection_DureesDiviserParDeuxPuisSilence: TMenuItem;
    Fusionner2: TMenuItem;
    cmdMettreBarreMesures: TBitBtn;
    pupMenuMettreBarreMesures: TPopupMenu;
    Laissertelquel1: TMenuItem;
    Mettrebarresdemesures1: TMenuItem;
    Mettrebarresdemesuresencrivantsurlasuite1: TMenuItem;
    PopupBarreDeMesure: TPopupMenu;
    Barredemesuresimple1: TMenuItem;
    Barredereprise1: TMenuItem;
    Doublebarre1: TMenuItem;
    mnuBarreDeMesure_Supprimer: TMenuItem;
    mnuBarreDeMesures_Rythme_grp: TMenuItem;
    mnuBarreDeMesure_Tonalites_grp: TMenuItem;
    DobmajeurLabmineur1: TMenuItem;
    SolbmajeurMibmineur1: TMenuItem;
    RbmajeurSibmineur1: TMenuItem;
    LabmajeurFamineur1: TMenuItem;
    MibmajeurDomineur1: TMenuItem;
    SibmajeurSolmineur1: TMenuItem;
    Famajeurrmineur1: TMenuItem;
    Domajeurlamineur1: TMenuItem;
    SolmajeurMimineur1: TMenuItem;
    RmajeurLamajeur1: TMenuItem;
    LamajeurFamineur1: TMenuItem;
    MimajeurDomineur1: TMenuItem;
    SimajeurSolmineur1: TMenuItem;
    FamajeurRmineur2: TMenuItem;
    Domajeur1: TMenuItem;
    PopupMenuClefInseree: TPopupMenu;
    Clefdesol3: TMenuItem;
    Clefdefa3: TMenuItem;
    Clefdut3: TMenuItem;
    Supprimerlaclef1: TMenuItem;
    Jusqulonreprend1: TMenuItem;
    Apartirdelonreprend1: TMenuItem;
    Jusqueletpartirdelonreprend1: TMenuItem;
    PopupMenuOctavieur: TPopupMenu;
    Supprimerloctavieur1: TMenuItem;
    mnuMenuTonalite_DuMenuClef: TMenuItem;
    DobmajeurLabmineur2: TMenuItem;
    SolbmajeurMibmineur2: TMenuItem;
    RbmajeurSibmineur2: TMenuItem;
    LabmajeurFamineur2: TMenuItem;
    MibmajeurDomineur2: TMenuItem;
    SibmajeurSolmineur2: TMenuItem;
    Famajeurrmineur3: TMenuItem;
    Domajeurlamineur2: TMenuItem;
    SolmajeurMimineur2: TMenuItem;
    RmajeurLamajeur2: TMenuItem;
    LamajeurFamineur2: TMenuItem;
    MimajeurDomineur2: TMenuItem;
    SimajeurSolmineur2: TMenuItem;
    FamajeurRmineur4: TMenuItem;
    Domajeur2: TMenuItem;
    Rythme2: TMenuItem;
    N442: TMenuItem;
    N342: TMenuItem;
    N242: TMenuItem;
    N681: TMenuItem;
    mnuMenuTonalite_DuMenuRythmesEtTonalites: TMenuItem;
    DomajeurLamineur3: TMenuItem;
    FamajeurRmineur5: TMenuItem;
    SimajeurSolmineur3: TMenuItem;
    MimajeurDomineur3: TMenuItem;
    LamajeurFamineur3: TMenuItem;
    RmajeurSimineur1: TMenuItem;
    SolmajeurMimineur3: TMenuItem;
    Domajeurlamineur4: TMenuItem;
    Famajeurrmineur6: TMenuItem;
    SibmajeurSolmineur3: TMenuItem;
    MibmajeurDomineur3: TMenuItem;
    LabmajeurFamineur3: TMenuItem;
    RbmajeurSibmineur3: TMenuItem;
    SolbmajeurMibmineur3: TMenuItem;
    DobmajeurLabmineur3: TMenuItem;
    Rythme3: TMenuItem;
    N682: TMenuItem;
    N243: TMenuItem;
    N343: TMenuItem;
    N443: TMenuItem;
    N441: TMenuItem;
    N341: TMenuItem;
    N241: TMenuItem;
    N683: TMenuItem;
    PopupMenuNuances: TPopupMenu;
    p1: TMenuItem;
    mp1: TMenuItem;
    mf1: TMenuItem;
    f1: TMenuItem;
    ff1: TMenuItem;
    pp1: TMenuItem;
    Supprimer2: TMenuItem;
    AfficherlabotededialoguedeNuances1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    PopupMenuCrescendo: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    PopupMenuPhrase: TPopupMenu;
    MenuItem6: TMenuItem;
    tmrCurseurClavier: TTimer;
    Cordedeguitare1: TMenuItem;
    Corden11: TMenuItem;
    Corden12: TMenuItem;
    Corden13: TMenuItem;
    Corden14: TMenuItem;
    Corden15: TMenuItem;
    Corden16: TMenuItem;
    Parkinsonner1: TMenuItem;
    PopupBarreDeMesure_Titre: TMenuItem;
    PopupMenuClef_Titre: TMenuItem;
    PopupMenuClefInseree_Titre: TMenuItem;
    Slection1: TMenuItem;
    PopupMenuSelection_Quoi: TMenuItem;
    Navigateur: TframeNavigateur;
    PopupMenuCurseur_Titre: TMenuItem;
    PopupMenuRythmeEtTonalite_Titre: TMenuItem;
    Altrerselonunetonalit1: TMenuItem;
    PopupMenuPortees_Instruments_Noms_Zone: TPopupMenu;
    PopupMenuPortees_Instruments_Noms_Zone_Titre: TMenuItem;
    mnuProprietesdelaportee: TMenuItem;
    panInstruments_Portees: TPanel;
    PopupMenuInstruments_Portees: TPopupMenu;
    mnuBarredemesure_Inserer: TMenuItem;
    mnuSelection_Deplacer_Voix: TMenuItem;
    Lirepartirdicipourladeuximefois1: TMenuItem;
    mnuParolesEcrire: TMenuItem;
    tlbAfficherRegleTemps: TToolButton;
    mnuDuree_Approximative: TMenuItem;
    Ajusternotesetaltrationsselonunetonalit1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    mnuSelection_PlacerDansVoixCourante: TMenuItem;
    N6: TMenuItem;
    mnuSelection_PlacerDansVoixNouvelle: TMenuItem;
    Placerlaslectiondanslavoix1: TMenuItem;
    Slectionnertouteslesnotessilencesdelapore1: TMenuItem;

    procedure I_Coller(PressePapier: TMesure);

    Function GraphicObjet_PointSousCurseur_Indice_Get: integer;
    Function Is_GraphicObjet_Point_SousCurseur: Boolean;

    Function Is_GraphicObjet_SousCurseur: Boolean;
    Function GraphicObjet_SousCurseur_Get: TGraphicObjet;
    procedure GraphicObjet_SousCurseur_Supprimer;

    Function Is_MettreNoteAvecBoutonGaucheSouris: Boolean;

    Function IsBarreDeMesureSousCurseur: boolean;
    Procedure BarreDeMesureSousCurseur_YenAPlus;

    Function Is_Portees_Instruments_Noms_Zone: Boolean;
    Function Portees_Instruments_Noms_Zone_iLigne: integer;
    Function Portees_Instruments_Noms_Zone_iPortee: integer;

    procedure MettreBarreMesuresBouton_Placer(imesure : integer);
    procedure MettreBarreMesures_RegarderSiBesoin(imesure: integer);
    procedure MettreBarreMesuresBouton_Desactiver;
    procedure MettreBarreMesuresBouton_Boucle;

    Function GetRythmeOUTonalite_iMesure: integer;
    Function Is_TonaliteSousCurseur: Boolean;
    Function Is_TonaliteAvantBarreDeMesureSousCurseur: Boolean;
    Function Is_RythmeSousCurseur: Boolean;


    Procedure AfficherLeToutClignotant;

    Procedure Scr_Init;

    {pour les préconditions}
    Function VerifierIntegrite(msg: string): Boolean;

    procedure I_Tonalite_Modifier(apartirdelamesure : integer;
                                        tonalite: TTonalite);
                                        
    procedure I_Rythme_Modifier(apartirdelamesure : integer;
                                      rythme: TRationnel);
    procedure I_Selection_MettreAJourInfo;

    Function IsModeSelectionMesure: Boolean;

    procedure SetCurrentView;

    Procedure I_Mesure_Supprimer(mes: integer);
    Procedure I_Mesures_Supprimer(mes_debut, mes_fin: integer);


    procedure InitAnimDefil(newcurrentHscr, newcurrentVscr: integer);

    Function FaireVoirPoint(x,y: integer): Boolean;
    Function FaireVoirMesure(m: integer): Boolean;
    Function FaireVoirMesureEtTemps(m: integer; temps: TRationnel): Boolean;

    Procedure FaireVoirBandeVerticale(x1, x2: integer);
    Procedure FaireVoirBandeHorizontale(y1, y2: integer);
    procedure FaireVoirXToutAGaucheSaufSiCBon(x: integer);

    procedure DefilerPartitionUnePageEnArriere;
    procedure DefilerPartitionUnePageEnAvant;

    Procedure DrawMisePage(optlignehaut, optlignebas: integer);
    procedure DrawElMusicalSousCurseur;

    procedure FormPaint(Sender: TObject);

    Function Is_CurseurClavier_Affichage_Condition: Boolean;

    Function Is_CurseurSouris_Affichage_Condition: Boolean;
    procedure CurseurSouris_Visible_Set(v: boolean);



    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CalcCurseur(changerportee, changerposition: boolean);

    procedure FaireLaPaginationEtLesCalculsPuisAffichageComplet(apartirdelamesure: integer;
                                                            jusquamesure: integer;
                                                            afficheraussi: boolean);

    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure Selection_Transposition_Tester_EtSiPasBonRevenirEtatPrecedent(intervalle_deplacement_a_tester, intervalle_deplacement_correct: TIntervalle);
    Procedure MettreAJourAffNoteDeplacementSouris(X, Y, m:integer; AlterationDefaut: Boolean);
    Procedure MettreAJourAffNoteDeplacement;
    procedure MettreAJourNotesADeplacees(ajouter, modetonalpur,
                                         Deplacement_IsSurTablature: Boolean);
    procedure MettreAJourCentrageScrollBar;
    procedure VoixSelectionnee_Changer(newvoixselectionnee: integer);
    procedure VoixSelectionnee_DetecterPuisChanger(imesure, x_in_mes: integer; pos: TPosition);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure tmrKeyWaitTimer(Sender: TObject);
    Function TenterEnregistrer(ForcerEnregistrerSous: Boolean): Boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReaffichageComplet;
    procedure FormActivate(Sender: TObject);
    Procedure DemarrerAnimationMesure(mes: integer);

    Function I_InsererModeleCourantDansVoixCourante(a_hn: THauteurNote): Boolean; overload;




    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrSourisCurseur_Clignotement_TimerTimer(Sender: TObject);
    procedure tmrAffichageClignotantTimer(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure VScrollBarChange(Sender: TObject);
    procedure VScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure tmrDemarrerAnimationEditionMesureTimer(Sender: TObject);
    procedure tmrDefilTimerTimer(Sender: TObject);
    procedure Aide_AfficherDansComposition(mess: string; x, y, ecart: integer);
    procedure Aide_AfficherDansChildWin(mess: string; x, y, ecart: integer);
    procedure FormDblClick(Sender: TObject);
    procedure Couper1Click(Sender: TObject);
    procedure Coper1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Noteduhaut1Click(Sender: TObject);
    procedure Notesdubas1Click(Sender: TObject);
    procedure Duneoctaveverslehaut1Click(Sender: TObject);
    procedure Duneoctaveverslebas1Click(Sender: TObject);
    procedure Coller1Click(Sender: TObject);
    procedure Collereninversant1Click(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure Lirepartirdici1Click(Sender: TObject);
    procedure mnuJusteCettePorteeClick(Sender: TObject);
    procedure outeslesportes1Click(Sender: TObject);
    procedure mnuEcrireDansLaVoixSousLeCurseurClick(Sender: TObject);
    procedure mnuEcrireDansUneNouvelleVoixClick(Sender: TObject);
    procedure Notesquisontdessi1Click(Sender: TObject);
    procedure PopupMenuSelectionPopup(Sender: TObject);
    procedure Voixautomatiquecriredanslesvoixpardfaut1Click(
      Sender: TObject);
    procedure ModifClefPortee(Sender: TObject);
    procedure ModifRythme(Sender: TObject);
    procedure Insrerunemesureavant1Click(Sender: TObject);
    procedure Insrerunemesureaprs1Click(Sender: TObject);
    procedure Queueverslehaut1Click(Sender: TObject);
    procedure Queueverslebas1Click(Sender: TObject);
    procedure I_Selection_Alterer(a: TAlteration);
    procedure I_Selection_Supprimer;
    procedure MnuAltererSelection(Sender: TObject);
    procedure mnuProprietedelaporteeClick(Sender: TObject);
    procedure Extraireunmodle1Click(Sender: TObject);
    procedure tbnModePageEditerClick(Sender: TObject);
    procedure tbnModeRubanClick(Sender: TObject);
    procedure tbnModePageCleanClick(Sender: TObject);
    procedure Duneoctaveverslehaut2Click(Sender: TObject);
    procedure Duneoctaveverslebas2Click(Sender: TObject);
    procedure Continuerlcritureavecunemontechromatique1Click(
      Sender: TObject);
    procedure UserChroma(nbdemitondiff: integer);
    Function VerifierQueVoixSelectionneePeutEcrireDansPortee(portee: integer): Boolean;
    procedure Selection_Transposer(int: TIntervalle);
    procedure ArpegerVerslehaut1Click(Sender: TObject);
    procedure CyclerVoixCourante;
    procedure mnuCyclerlesvoixClick(Sender: TObject);
    procedure mnuCyclerlesvoix_DansMenuSelectionClick(Sender: TObject);
    Function DessinerUnFondPourVoixVide: Boolean;
    procedure mnuSupprimerlamesureClick(Sender: TObject);
    procedure Modifierlatonalit1Click(Sender: TObject);
    procedure tmrFormResizingTimer(Sender: TObject);
    procedure Calculerlarrache1Click(Sender: TObject);
    procedure mnuTransposerClick(Sender: TObject);
    procedure Unlmentmusicalsur21Click(Sender: TObject);
    procedure ArpegerVerslebas1Click(Sender: TObject);
    procedure Collerdesgrosaccords1Click(Sender: TObject);
    procedure Fusionner1Click(Sender: TObject);
    procedure Multiplierlesdurespar21Click(Sender: TObject);
    procedure Diviserlesdurespar21Click(Sender: TObject);
    procedure Rendrejolilamesure1Click(Sender: TObject);
    procedure Simplifierlcrituredelamesure1Click(Sender: TObject);
    procedure Enfairepleinpareil1Click(Sender: TObject);
    
    procedure Multiplierlesdurespar21MeasureItem(Sender: TObject;
      ACanvas: TCanvas; var Width, Height: Integer);
    procedure Multiplierlesdurespar21DrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure Mettrebarresdemesures1Click(Sender: TObject);
    procedure Laissertelquel1Click(Sender: TObject);
    procedure Mettrebarresdemesuresencrivantsurlasuite1Click(
      Sender: TObject);
    procedure cmdMettreBarreMesuresClick(Sender: TObject);
    procedure mnuBarreDeMesure_SupprimerClick(Sender: TObject);
    procedure ChangerTonaliteApartirDeBarreDeMesure(Sender: TObject);
    procedure ClefInseree_Modifier(Sender: TObject);
    procedure ClefInseree_Supprimer(Sender: TObject);
    procedure Doublebarre1Click(Sender: TObject);
    procedure Barredemesuresimple1Click(Sender: TObject);
    procedure Supprimerloctavieur1Click(Sender: TObject);
    procedure ChangerTonaliteAuDebut(Sender: TObject);
    procedure ChangerRythmeDepuisDebut(Sender: TObject);
    procedure ChangerTonalite(Sender: TObject);
    procedure ChangerTonaliteRT(Sender: TObject);
    procedure ChangerRythme(Sender: TObject);
    procedure ChangerRythmeRT(Sender: TObject);
    procedure Jusqulonreprend1Click(Sender: TObject);
    procedure Apartirdelonreprend1Click(Sender: TObject);
    procedure Jusqueletpartirdelonreprend1Click(Sender: TObject);
    procedure mnuNuance_Supprimer(Sender: TObject);
    procedure AfficherlabotededialoguedeNuances1Click(Sender: TObject);
    procedure mnuNuance_Set(Sender: TObject);
    procedure objet_graphique_crescendo_transformer(Sender: TObject);
    procedure objet_graphique_decrescendo_transformer(Sender: TObject);
    procedure tmrCurseurClavierTimer(Sender: TObject);
    procedure panStatusBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tbnModePageEditerMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure tbnModeRubanMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tbnModePageCleanMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuCorde_De_Guitare_Corde_Numero_Click(Sender: TObject);
    procedure Parkinsonner1Click(Sender: TObject);
    procedure PopupMenu_AfficherTitre(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure PopupBarreDeMesurePopup(Sender: TObject);
    procedure PopupMenuClefPopup(Sender: TObject);
    procedure PopupMenuClefInsereePopup(Sender: TObject);
    procedure PopupMenuCurseurPopup(Sender: TObject);
    procedure PopupMenuRythmeEtTonalitePopup(Sender: TObject);

    procedure I_ModeAffichage_Set(ma: TModeAffichage);
    procedure I_ModeAffichage_Set_SansAfficher(ma: TModeAffichage);
    procedure I_ModeAffichage_MettreAJourInterface;

    procedure I_AltererSelonUneTonalite(Sender: TObject);
    procedure mnuMenuGeneriqueAvecInfoVoixMeasureItem(Sender: TObject;
      ACanvas: TCanvas; var Width, Height: Integer);
    procedure mnuMenuGeneriqueAvecInfoVoixDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure PopupMenuPortees_Instruments_Noms_ZonePopup(Sender: TObject);
    procedure mnuProprietesdelaporteeClick(Sender: TObject);
    procedure CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
    procedure PopupMenuInstruments_PorteesPopup(Sender: TObject);
    procedure PopupMenuInstruments_Portees_Element_Click(Sender: TObject);
    procedure Arrterlalecture1Click(Sender: TObject);
    procedure mnuBarredemesure_InsererClick(Sender: TObject);
    procedure mnuSelection_Deplacer_VoixClick(Sender: TObject);
    procedure mnuParolesEcrireClick(Sender: TObject);
    procedure tlbAfficherRegleTempsClick(Sender: TObject);
    procedure mnuDuree_ApproximativeClick(Sender: TObject);
    procedure I_AjusterNotesEtAlterationsSelonUneTonalite(
      Sender: TObject);
    procedure mnuSelection_PlacerDansVoixCouranteClick(Sender: TObject);
    procedure mnuSelection_PlacerDansVoixNouvelleClick(Sender: TObject);

    procedure I_Selection_PlacerDansVoix(ivoix: integer);
    procedure I_Selection_FusionnerNotesEtSilences(Sender: TObject);
    procedure I_Selection_DureesDiviserParDeuxPuisSilence(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Enregistreur_NotesEnfonces_Reset;
    procedure Enregistreur_Note_Enfoncer(imesure: integer; itemps: TRationnel; a_demiton: integer);
    procedure Enregistreur_Note_Relacher(n: integer);
    procedure Enregistreur_NotesEnfonces_Afficher;
    procedure Slectionnertouteslesnotessilencesdelapore1Click(
      Sender: TObject);




  private  { Private declarations }

     SelectionRect: TRect;

     enregistreur_notes_enfoncees: array of TEnregistreur_Notes_Enfoncees;


     regletemps_temps_ancien: TRationnel;
     private_GraphicObjet_indice: integer;
     private_GraphicObjet_point_indice: integer;

     MettreBarreMesuresBouton_iMesure: integer;

     Silences_Deplacer_HauteurDeplace: integer;
     BackBuffer, Scr: TBitmap;

     Souris_Curseur_Position : TPosition;  //position sous le curseur souris
     Souris_Curseur_ScrX, Souris_Curseur_ScrY: integer;
     Souris_Curseur_X, Souris_Curseur_Y:integer;
     Souris_Curseur_Ancien_X, Souris_Curseur_Ancien_Y: integer;


     Souris_Curseur_MouseDown_X, Souris_Curseur_MouseDown_Y: integer;
     Souris_Curseur_Xdansmesure, Souris_Curseur_Ydansmesure,
     AncienneMesureCourante, MesureCourante,
     AncienneLigneCourante, LigneCourante : integer;


     RedessinerTout: Boolean;
     BlitterToutDuBackBuffer: Boolean;

     BlitRectsApres, BlitRectsAvant: TRectList;

     IctusListe: array of TMagnetophone_Curseur;


     VerouillerLeReaffichage: Boolean;


     GraphicObjet_ObjetEnCours: TGraphicObjet;
     GraphicObjet_iPts: integer; {indice du point qui se modifie en cours d'une courbe
                                         GraphicObjet}



     AffichageClignotant_Indice:integer; {valeur qui spécifie le temps pour tmrAffichageClignotant}

     Optimisation_Affichage_ilignehaut, Optimisation_Affichage_ilignebas : integer;

     {optlignehaut contient la ligne affichée en haut
        optlignebas contient la ligne affichée en bas

        ces deux valeurs sont calculées à chaque FormPaint(nil)

        elles sont utilisées dans FormPaint(nil) mais aussi dans tmrAffichageClignotant

        }



     BoutonControleDejaActif: Boolean;

     {animation de défilement}
     AnimDefil_Indice: integer;
     AnimDefil_lastHscr, AnimDefil_lastVscr: integer;
     AnimDefil_currentHScr, AnimDefil_currentVscr: integer;

     DessinerFondVoixNonPresente: Boolean;

     Optimisation_Affichage_ModeRuban_ChangementPorteeCourante: Boolean;
     {en mode dessiner tout, si ça ça vaut vrai... ça essaie de ne pas dessiner tout...}

     Optimisation_Ancien_iPorteeCourant: integer;

     NoteSousCurseur: TPNote; //pointeur sur la note sous le curseur souris

     ElSC: TElMusical;// = nil; //élément musical sous le curseur souris

     BarreDeMesureSousCurseur_iMesure: integer;

     private_Voix_Selectionner_voixsouscurseur: integer;

     private_clef_debut_iportee: integer;

     private_clef_inseree_iportee,
     private_clef_inseree_imesure,
     private_clef_inseree_indice: integer;

     private_octavieur_indice,
     private_octavieur_iportee: integer;

     private_rythme_tonalite_imesure_apartirde: integer;

     private_is_portees_instruments_noms_zone: Boolean;

     private_entree_hauteurnote_last_temps: integer;

     
     CurseurClavier_Clignotant_VisibleEnCemoment: boolean;

     MouseDown_Pour_MouseUp_ModeSelection_OnACliqueSurUneNoteQuOnASelectionnee: Boolean;

     SourisCurseur_IsVisible: Boolean;
     SourisCurseur_Clignotement_Etat: TSourisCurseur_Clignotement_Etat;

     private_VScrollBarChange_IgnorerEvenement: Boolean;
     private_Magnetophone_Curseur_Excitation: integer;
     procedure GraphicObjet_ObjetEnCours_Nouveau_Creer;
     procedure GraphicObjet_ObjetEnCours_Courbe_Init;
     procedure GraphicObjet_ObjetEnCours_Crescendo_Init;
     procedure GraphicObjet_ObjetEnCours_DeCrescendo_Init;
     
     Function Is_Octavieur_SousCurseur: boolean;

     Function ClefInseree_Is_SousCurseur: boolean;
     Procedure ClefInseree_SousCurseur_DireQueYenAPas;

     procedure I_AfficherQuunePortee(p: integer);
     procedure I_AfficherToutesLesPortees;
     Function IsCurseurDansBandeNomsPorteesDuModeRuban(X: integer): Boolean;

     Function IsGestionPorteeCouranteActivee: Boolean;


    Function Is_ClefDebut_PorteeSousCurseur: Boolean;
    Function ClefDebut_iPortee: integer;

    Function Is_el_mus_Pause_PourPortees_Sous_Curseur: Boolean;

    Function I_InsererModeleCourantDansVoixCourante(mes, ind: integer;
                                                a_hn: THauteurNote;
                                                portee, x: integer): Boolean; overload;
    Function RegleTemps_IsAffiche: Boolean;

    procedure Zoom_Set(zoom: integer);
    procedure Zoom_Set_VersScrXScrY(zoom: integer; scrX, scrY: integer);
    Function Curseur_Entree_WaveIn_IsExcite: Boolean;

    Function I_InsererNoteDansVoixCourante(mes, ind: integer;
                                                         a_hn: THauteurNote;
                                                         portee, x: integer): Boolean; overload;



    Function I_InsererNoteDansVoixCourante(a_hn: THauteurNote): Boolean; overload;

    Function IsEntrainDeJouer: Boolean;

   public
     FileName: string;
     {nom du fichier .mus}

     Composition: TComposition;
     {la composition qu'affiche la fenêtre}

     View: TView;
     {les informations sur la vue courante de l'objet composition}

     ModeSelectionMesureiDeb, ModeSelectionMesureiFin: integer;
     {mesure de début et de fin de sélection (mode sélection de mesure)}

     Curseur, Curseur_Souris: TCurseur;

     LectureMIDI_ListeDeLecture: TListeDeLecture;

     Magnetophone_Curseur: TMagnetophone_Curseur;
     {rem : LectureMIDI_MesurePlayed et LectureMIDI_TempsPlayed sont modifiés
            par l'extérieur...
            la fenêtre les utilise juste pour tracer la barre bleu, curseur qui
            suit la lecture}


      Function CycleVoix_ProchaineVoixCourante(voix_courante: integer): integer;
      Function Selection_NouvelleVoixIndice_Get: integer;

      procedure Zoom_Set_AuMilieu(zoom: integer);
      procedure Zoom_MettreAJourMainForm;

      Function Zoom_Get: integer;

      Procedure Curseur_Entree_WaveIn_Exciter(hn: THauteurNote);
      procedure CurseurSouris_RecalculerPositionAPartirDeLaPositionCurseurInterne;

      procedure Entree_HauteurNote_Traiter(hn: THauteurNote);

      Function Curseur_XDansFenetre_Get: integer;
      Function Curseur_YDansFenetre_Get: integer;


      Function Composition_Enregistrement_IsABesoinDEtreEnregistre: Boolean;

      procedure Composition_Enregistrement_ABesoinDEtreEnregistre;

      procedure Composition_Enregistrement_VientDEtreEnregistre;

      procedure Magnetophone_Curseur_Exciter_Bcp;
      procedure Magnetophone_Curseur_Exciter_Un_Peu;

      procedure Magnetophone_Ictus_Poser;
      procedure Magnetophone_Ictus_Reset;

    { Public declarations }
  end;





















implementation

uses Main,
      MusicWriter_Console, Doigtes, help,
  choix, transposition,
  MusicGraph_System {pour SetFontSizeToMeasure},
  MusicGraph_CouleursVoix {pour CouleurLiseraieVoix...},
  MusicGraph_Portees {pour GetY(...)},
  MusicWriter_Erreur, MusicSystem_CompositionAvecSelectionApplication,
  MusicSystem_CompositionGestionBarresDeMesure,
  MusicGraph_Images, MusicSystem_CompositionAvecSelection {pour l'image de l'ancre},
  MusicGraph_CouleursUser,
  MusicGraph_GestionImage{BMPTransparentLoadFromFile},
  Voix_Gestion,
  DureeCourante_Gestion,
  CurseursSouris,
  MusicWriter_Aide, nuances, piano,
  tablature_system {pour Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature},
  CurseurSouris_Busy,
  Musicwriter_langue,
  MusicSystem_CompositionBase {pour const VOIX_TOUTES_LES_VOIX = -1;},
  alterer_selon_une_tonalite, MusicSystem_Composition_Portees_Liste,
  Magnetophone, Magnetophone_System,
  MusicSystem, Selection_Deplacer_Voix {pour ClefToStr},
  Message_Vite_Fait, Paroles,
  TimerDebugger,
  Voix_Liste_Vite_Fait,
  MusicGraph_RegleTemps,
  Interface_Questions,

  Ajuster_alterations_notes_selon_tonalite, Rien_fenetre,
  Entree_WaveIn, Entree_WaveIn_FFT_Form, Enregistrer_Source,
  EnregistrerAvertissement,
  langues,
  MusicUser_PlusieursDocuments,
  USauvegarde_Cayest,
  UOperation_Voix_Selectionner_Dans_Partition, MusicSystem_MesureBase,
  MusicUser_Mode_Mesures, frmMesuresTonalite, FonctionsAcess,
  UTransposerNotesALaSouris, ProprietesPortee,
  InterfaceGraphique_Complements;



 const
      indMesureQuiDitPasDeDeplacementAutrePart = -2;




 var actchildDerniereSelection: TMDIChild = nil;
    {désigne la fenêtre-document dans laquelle il y a une sélection
      rem : utile pour la commande "bouton-milieu", copier-coller rapide
             qui n'effectue le traitement qu'après le clic}



     private_is_element_exactement_sous_curseur: Boolean = false;
     private_is_element_selectionnee_sous_curseur: Boolean = false;

{$R *.DFM}






Function Selection_Rectangle_IsEnTrainDeSelectionner: Boolean;
Begin
    result := (OutilPlus = opSelection);
End;

procedure TMDIChild.Magnetophone_Curseur_Exciter_Bcp;
Begin
    private_Magnetophone_Curseur_Excitation := 10;
End;


procedure TMDIChild.Magnetophone_Curseur_Exciter_Un_Peu;
Begin
    private_Magnetophone_Curseur_Excitation := 0;
End;


procedure TMDIChild.Enregistreur_NotesEnfonces_Reset;
Begin
    setlength(enregistreur_notes_enfoncees, 0);
End;


procedure TMDIChild.Enregistreur_Note_Enfoncer(imesure: integer; itemps: TRationnel; a_demiton: integer);
var l: integer;
Begin
    l := length(enregistreur_notes_enfoncees);
    setlength(enregistreur_notes_enfoncees, l+1);

    enregistreur_notes_enfoncees[l].imesure := imesure;
    enregistreur_notes_enfoncees[l].temps := itemps;
    enregistreur_notes_enfoncees[l].nb_demiton := a_demiton;
End;



procedure TMDIChild.Enregistreur_Note_Relacher(n: integer);
var i, j: integer;
Begin
    for i := 0 to high(enregistreur_notes_enfoncees) do
          if enregistreur_notes_enfoncees[i].nb_demiton = n then
          Begin
               for j := i to high(enregistreur_notes_enfoncees)-1 do
                      enregistreur_notes_enfoncees[j] := enregistreur_notes_enfoncees[j+1];
               setlength(enregistreur_notes_enfoncees, high(enregistreur_notes_enfoncees));
          End;
End;




procedure TMDIChild.Enregistreur_NotesEnfonces_Afficher;
var el: TElMusical;
    i: integer;
    ligne: integer;
    note: TNote;
    
Begin
     IGP := Composition;
     C.Pen.Color := 255;
     C.Pen.Style := psSolid;
     C.Pen.Width := 2;

     for i := 0 to high(enregistreur_notes_enfoncees) do
     Begin
         ligne := Composition.LigneAvecMes(enregistreur_notes_enfoncees[i].imesure);
         Composition.SetOriginMesure(enregistreur_notes_enfoncees[i].imesure);
         note := Enregistreur_Note_Construire(enregistreur_notes_enfoncees[i].nb_demiton,
                                              enregistreur_notes_enfoncees[i].temps);

     
         el := CreerElMusical1Note_DureeApproximative(Qel(1), note);
         
         el.pixx := Composition.GetMesure(enregistreur_notes_enfoncees[i].imesure)
                       .XATemps(enregistreur_notes_enfoncees[i].temps);

         DrawElMusical(Composition, ligne, el, false, false);
         ElMusical_Trainee_Draw(Composition, ligne, el);

         el.Free;
     End;



     
End;



    
procedure TMDIChild.Composition_Enregistrement_VientDEtreEnregistre;
Begin
     Composition.AEteModifieDepuisEnregistrement := false;
     MainForm.TabControlChildWin.Refresh;

End;

procedure TMDIChild.Composition_Enregistrement_ABesoinDEtreEnregistre;
Begin
     Composition.AEteModifieDepuisEnregistrement := true;
     MainForm.TabControlChildWin.Refresh;
     
End;

Function TMDIChild.Composition_Enregistrement_IsABesoinDEtreEnregistre: Boolean;
Begin
    result := Composition.AEteModifieDepuisEnregistrement;
End;


var delay_accorde_pour_lenteur: integer = 0;

procedure TMDIChild.Entree_HauteurNote_Traiter(hn: THauteurNote);
{cette procédure "insère une note de hauteur hn dans la partition
 Cette procédure est appelé par le gestionnaire midi mais aussi par
  le module qui s'occupe du clavier électronique}

const delai_max_pour_interpreter_un_accord = 50;

var temps: integer;
    pos: TPosition;
    el: TElMusical;
    
Begin
     temps :=  GetTickCount;
     MusicGraph_Canvas_Set(Canvas);
     SetCurrentView;
     if temps - private_entree_hauteurnote_last_temps < delai_max_pour_interpreter_un_accord + delay_accorde_pour_lenteur then
     Begin
        pos := Curseur.GetPosition;
        pos.hauteur := HauteurAbsToHauteurGraphique(Curseur.GetInfoClefCourante,
                                                    hn.Hauteur);

        el := Curseur.GetElementMusicalPrecedent;

        if el <> nil then
             el.AddNote2(pos, hn);
             
        Composition.PaginerApartirMes( max(0, Curseur.GetiMesure-1) , true);
        Curseur.CalculerXY_CurseurClavier;
        ReaffichageComplet;
     end
     else
     Begin
         I_InsererNoteDansVoixCourante(hn);
         Composition.PaginerApartirMes(Curseur.GetiMesure, true);
         Curseur.CalculerXY_CurseurClavier;
         ReaffichageComplet;
     End;

     private_entree_hauteurnote_last_temps := temps;
     delay_accorde_pour_lenteur := GetTickCount - temps;
End;




Function TMDIChild.Selection_NouvelleVoixIndice_Get: integer;
Begin
    if Composition.Selection_IsToutDeselectionner then
         MessageErreur('Selection_NouvelleVoixIndice_Get appelé alors que tout désélectionné!');

    result := Composition.Voix_Nouvel_Indice(Composition.Selection_GetIMesDebutSelection,
                                                        Composition.Selection_PorteeApprox);
End;


Procedure TMDIChild.Curseur_Entree_WaveIn_Exciter(hn: THauteurNote);
Begin
    Curseur.SetHauteurNote(hn);
    CalcCurseur(false, false);

End;



Function TMDIChild.Curseur_Entree_WaveIn_IsExcite: Boolean;
Begin
    if Entree_WaveIn_IsActive then
           result := Entree_WaveIn_IsExcite
    else
           result := false;
End;


Function TMDIChild.Is_GraphicObjet_SousCurseur: Boolean;
Begin
    result := (private_GraphicObjet_indice >= 0);
End;


Function TMDIChild.Is_GraphicObjet_Point_SousCurseur: Boolean;
Begin
    result := (private_GraphicObjet_point_indice >= 0);
End;


Function TMDIChild.GraphicObjet_PointSousCurseur_Indice_Get: integer;
Begin
    result := private_GraphicObjet_point_indice;
End;

procedure TMDIChild.GraphicObjet_ObjetEnCours_Nouveau_Creer;
Begin
     GraphicObjet_ObjetEnCours := TGraphicObjet.Create;
     GraphicObjet_Ipts := 0;
End;



procedure TMDIChild.GraphicObjet_ObjetEnCours_Courbe_Init;
Begin
    GraphicObjet_ObjetEnCours.typ := tgCourbe;
End;



procedure TMDIChild.GraphicObjet_ObjetEnCours_Crescendo_Init;
Begin
    GraphicObjet_ObjetEnCours.typ := tgCrescendo;
    GraphicObjet_ObjetEnCours.velocity_depart := 20;
    GraphicObjet_ObjetEnCours.velocity_fin := 127;
End;

procedure TMDIChild.GraphicObjet_ObjetEnCours_DeCrescendo_Init;
Begin
    GraphicObjet_ObjetEnCours.typ := tgDeCrescendo;
    GraphicObjet_ObjetEnCours.velocity_depart := 127;
    GraphicObjet_ObjetEnCours.velocity_fin := 20;
End;
     
procedure TMDIChild.GraphicObjet_SousCurseur_Supprimer;
Begin
     Composition.ObjetGraphique_Supprimer(private_GraphicObjet_indice);
     private_GraphicObjet_indice := -1;
End;


Function TMDIChild.GraphicObjet_SousCurseur_Get: TGraphicObjet;
Begin
    result := Composition.ObjetGraphique_Get(private_GraphicObjet_indice);
End;


Function TMDIChild.GetRythmeOUTonalite_iMesure: integer;
Begin
     result := private_rythme_tonalite_imesure_apartirde;
End;

Function TMDIChild.Is_TonaliteSousCurseur: Boolean;
Begin
     if Composition.IsIndiceMesureValide(MesureCourante) then
     Begin
         private_rythme_tonalite_imesure_apartirde := MesureCourante;
         result := (0 <= Souris_Curseur_Xdansmesure) and
     (Souris_Curseur_Xdansmesure <= Composition.GetMesure(MesureCourante).pixXApresTonaliteDebut)
     End
     else
     Begin
         result := false;
     End;
         
End;



Function TMDIChild.Is_TonaliteAvantBarreDeMesureSousCurseur: Boolean;
Begin

     if Composition.IsIndiceMesureValide(MesureCourante) then
     Begin
         if not Composition.Is_Mesure_ChangementTonaliteApres(MesureCourante) then
                result := false
         else
         Begin
             private_rythme_tonalite_imesure_apartirde := MesureCourante + 1;
             result := (Composition.GetMesure(MesureCourante).pixWidthWithoutTonalitesFin < Souris_Curseur_Xdansmesure)
         End;
     End
     else
     Begin
         result := false;
     End;
         
End;



Function TMDIChild.Is_RythmeSousCurseur: Boolean;
Begin
     if Composition.IsIndiceMesureValide(MesureCourante) then
     Begin
          private_rythme_tonalite_imesure_apartirde := MesureCourante;
          result :=
     (Composition.GetMesure(MesureCourante).pixXApresTonaliteDebut <= Souris_Curseur_Xdansmesure)
     and (Souris_Curseur_Xdansmesure <= Composition.GetMesure(MesureCourante).pixXApresTonaliteDebutEtRythme)
     End
     else
     Begin
         result := false;
     End;

End;




Function TMDIChild.ClefInseree_Is_SousCurseur: boolean;
Begin
     result := private_clef_inseree_indice > -1;
End;



Procedure TMDIChild.ClefInseree_SousCurseur_DireQueYenAPas;
Begin
     private_clef_inseree_indice := -1;
End;

Function TMDIChild.Is_Octavieur_SousCurseur: boolean;
Begin
     result := private_octavieur_indice > -1; 
End;


procedure TMDIChild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
Begin
      Curseur.DR_MiniDRCarModif;
      Curseur_Souris.DR_MiniDRCarModif;

      ClefInseree_SousCurseur_DireQueYenAPas;
      {en cas de suppresion de mesures etc... on préfère dire que ya plus de clef sous le curseur}

      private_octavieur_indice := -1;

      Composition.RendreIndiceMesureValide(MesureCourante);

      ElSC := nil;
      NoteSousCurseur := nil;
      
End;


Function IsCurseurSourisExactementSousElMusical: Boolean;
{renvoie vrai ssi le curseur souris se trouve exactement sous un el. mus.}
Begin
     result := private_is_element_exactement_sous_curseur;
End;


Function IsCurseurSourisExactementSousElMusicalSelectionne: Boolean;
{renvoie vrai ssi le curseur souris se trouve exactement sous un el. mus. sélectionné}
Begin
     result := private_is_element_selectionnee_sous_curseur;
End;



Function TMDIChild.Is_ClefDebut_PorteeSousCurseur: Boolean;
Begin
     result := (private_clef_debut_iportee > -1);
End;


Function TMDIChild.ClefDebut_iPortee: integer;
Begin
    result := private_clef_debut_iportee;
End;




Function TMDIChild.IsBarreDeMesureSousCurseur: boolean;
Begin
     result := BarreDeMesureSousCurseur_iMesure >= 0;
End;


Procedure TMDIChild.BarreDeMesureSousCurseur_YenAPlus;
Begin
    BarreDeMesureSousCurseur_iMesure := -1;
End;


Function TMDIChild.Is_Portees_Instruments_Noms_Zone: Boolean;
Begin
     result := private_is_portees_instruments_noms_zone;
End;

Function TMDIChild.Portees_Instruments_Noms_Zone_iLigne: integer;
Begin
    result := Curseur_Souris.GetiLigne;
End;

Function TMDIChild.Portees_Instruments_Noms_Zone_iPortee: integer;
Begin
    result := Souris_Curseur_Position.Portee;
End;


Function TMDIChild.Is_MettreNoteAvecBoutonGaucheSouris: Boolean;
Begin
    result := (MusicUser_MusicWriter_Mode_Get = mw_mode_MettreNote)
               and Outil_MettreNoteIsModeSouris
               and not IsBarreDeMesureSousCurseur
               and not Is_ClefDebut_PorteeSousCurseur
               and not ClefInseree_Is_SousCurseur
               and not Is_Octavieur_SousCurseur
               and not Is_TonaliteSousCurseur
               and not Is_RythmeSousCurseur
               and not Is_TonaliteAvantBarreDeMesureSousCurseur
               and not Is_GraphicObjet_SousCurseur;
End;






procedure TMDIChild.MettreBarreMesuresBouton_Placer(imesure : integer);
Begin
    cmdMettreBarreMesures.Visible := true;

    MettreBarreMesuresBouton_iMesure := imesure;
    MettreBarreMesuresBouton_Boucle;
End;

procedure TMDIChild.MettreBarreMesures_RegarderSiBesoin(imesure: integer);
Begin
     if Composition.GetMesure(imesure).MesureQuiDeborde then
                      MettreBarreMesuresBouton_Placer(imesure);
End;

procedure TMDIChild.MettreBarreMesuresBouton_Desactiver;
Begin
    cmdMettreBarreMesures.Visible := false;
End;




procedure TMDIChild.MettreBarreMesuresBouton_Boucle;
var x, y: integer;

Begin
    if cmdMettreBarreMesures.Visible then
    Begin
        x := Composition.Mesure_XGauche(MettreBarreMesuresBouton_iMesure);

        With Composition.GetMesure(MettreBarreMesuresBouton_iMesure) do
            x := x + XATemps(QMul(Qel(4), Rythme));
            
        y := Composition.Mesure_YBas(MettreBarreMesuresBouton_iMesure);

        cmdMettreBarreMesures.Left := ScrX(x);
        cmdMettreBarreMesures.Top := ScrY(y);
    End;

End;




Function IsModeStyletAvecShift(shift: TShiftState; button: TMouseButton): Boolean;
{fonction qui dit, à partir de l'argument d'un MouseDown, MouseUp, MouseMove,
   si on est en train de trifouiller le stylet}
Begin
         result := (ssRight in shift) or (mbRight = button);
End;












Function TMDIChild.Is_CurseurSouris_Affichage_Condition: Boolean;
{renvoie vrai ssi le logiciel est dans un état dans lequel le curseur souris
 s'affiche}
Begin
   result := SourisCurseur_IsVisible and
             (MusicUser_MusicWriter_Mode_Get = mw_mode_MettreNote)
             and
             not IsModeSelectionMesure
             and (MesureCourante > -1)
             and not IsCurseurSourisExactementSousElMusical
             and not frmParoles.Visible;
End;



Function TMDIChild.Is_CurseurClavier_Affichage_Condition: Boolean;
Begin
    result := (not Outil_MettreNoteIsModeSouris) and not IsModeSelectionMesure;
End; 





Function TMDIChild.Is_el_mus_Pause_PourPortees_Sous_Curseur: Boolean;
var h: integer;
Begin
    if Curseur_Souris.Is_SurMesure_FinaleAAjouter then
          result := false
    else
    Begin
         h := Curseur_Souris.GetPosition.hauteur;
         result := (abs(Curseur_Souris.GetPixx_in_mesure -
                          Curseur_Souris.GetMesure.pixWidthWithoutTonalitesFin div 2) < 100) and
                   (0 <= h) and (h < 3) and
                   not Curseur_Souris.Is_Curseur_Sur_Tablature and
                   not Curseur_Souris.GetMesure.Is_Portee_Utile(Curseur_Souris.GetiPortee);

    End;

End;

procedure TMDIChild.I_Selection_MettreAJourInfo;
{met à jour le p'tit truc dans la barre d'état qui dit s'il y a une sélection
 dans la fenêtre courante ou non...}
 var s: string;
     proprietes_communes_duree: TDuree;
     proprietes_communes_petitesnotes: Boolean;
     var selection_ip: integer;

     procedure ActiverOuPasToolBarProprietesCommunes(b: Boolean);
     {b = true : il y a une sélection,
      b = false : rien n'est sélectionné}
     Begin
         MainForm.tbnSelection_ChangerDurees.Enabled := b;
         ToolBar_Enabled(MainForm.tlbDuree_Approximative, b);
         ToolBar_Enabled(MainForm.tlbAttributsEtc, b);
         ToolBar_Enabled(MainForm.tlbSubSelection, b);
         ToolBar_Enabled(MainForm.tlbDeplacerNotesPortees, b);
     End;





Begin
     if MusicUser_MusicWriter_Mode_Get <> mw_mode_Selection then
            Exit; //ERREUR ?

     if not VerifierIntegrite('I_MettreAJourInfoSelection') then
          Exit;




     MainForm.txtModeSelection_Info.Text := Composition.Selection_GetDescription
                                                                      + s;

     ActiverOuPasToolBarProprietesCommunes(not Composition.Selection_IsToutDeselectionner);
     if Composition.Selection_IsToutDeselectionner then
     Begin
           With MainForm.txtModeSelection_Info do
           Begin
               Color := clWhite;
               Font.color := clBlack;
           End;

           MainForm.lstSelection_VoixListe.Clear;
           MainForm.lstSelection_Voix_PlacerDans.Clear;
     End
     else
     Begin

           With MainForm.txtModeSelection_Info do
           Begin
               Color := clRed;
               Font.Color := clWhite;
           End;

           if Composition.Selection_ProprietesCommunes_GetDuree(proprietes_communes_duree) then
                 DureeCourante_Set(proprietes_communes_duree)
           Else
                 DureeCourante_Indefini_Set;


          if Composition.Selection_ProprietesCommunes_GetTailleNote(proprietes_communes_petitesnotes) then
          Begin
                MainForm.tbnTailleNotes.Indeterminate := false;

                if proprietes_communes_petitesnotes then
                      ToolBarButtonFromMenuItem(MainForm.tbnTailleNotes, MainForm.mnuPetitesNotes)
                else
                      ToolBarButtonFromMenuItem(MainForm.tbnTailleNotes, MainForm.mnuGrandesNotes);


          End
          else
          Begin
                MainForm.tbnTailleNotes.Indeterminate := true;
          End;


          Composition.Selection_VoixListe_TString(MainForm.lstSelection_VoixListe.Items);

          MainForm.lstSelection_Voix_PlacerDans.Clear;

          selection_ip := Composition.Selection_Instrument_Portee_Get;

          if selection_ip <> -1 then
          Composition.I_Instruments_VoixListe_TString(selection_ip,
                                                      MainForm.lstSelection_Voix_PlacerDans.Items);

     {          With MainForm.lstSelection_VoixListe do
               Height := (Count div 3 + 1) * 20;}
               
     End;



     SetCurrentView; {car tout ce qui a avant appelle SetViewNil}
End;



procedure TMDIChild.Scr_Init;
{initialise la variable Scr... (en gros le backbuffer}
Begin
   Scr := TBitmap.Create;
   Scr.Canvas.Font.Name := 'Arial';
   Scr.Width := ClientWidth;
   Scr.Height := ClientHeight;

End;

Function TMDIChild.VerifierIntegrite(msg: string): Boolean;
Begin
    result := true;
    if Composition = nil then
    Begin
         MessageErreur('Erreur d''intégrité d''une fenêtre document : l''objet '
             + 'interne "composition" est nil ! ' + msg);
         result := false;
    End
    else
    if ToutDessinerDansBitmapScrDabord and (Scr = nil) then
    Begin
        MessageErreur('Erreur ! Scr est vide alors que l''on ne veut pas de clignotement !! On le crée...');
        Scr_Init;
        result := true;

    End;

    if not ToutDessinerDansBitmapScrDabord and (Scr <> nil) then
    Begin
        MessageErreur('Erreur ! Scr contient un bitmap alors qu''on s''en fout des clignotements !! On le détruit...');
        Scr.Free;
        Scr := nil;
        result := true;
    End;

End;









Procedure TMDIChild.I_Mesure_Supprimer(mes: integer);

      procedure I_Mesure_Supprimer_Traiter_Cas_Une_Mesure;
      const COMPORTEMENT_RIEN_FAIRE = 0;
      const COMPORTEMENT_MESURE_SUPPRIMER_NOTES = 1;
      var comportement: integer;
      Begin
           if Composition.GetMesure(0).IsVide then
           Begin
               Message_Vite_Fait_Beep_Et_Afficher('Vous voulez supprimer une mesure. Or la partition contient qu''une seule mesure :' +
                         ' Vous ne pouvez pas physiquement la supprimer. ' +
                         'Par ailleurs, elle ne contient pas de notes. ' +
                         'Je ne peux rien faire.');

           End
           Else
           Begin

               Choix_Reset;
               Choix_SetBlabla('Vous voulez supprimer une mesure. Or la partition contient qu''une seule mesure.' +
                             ' Vous ne pouvez pas physiquement la supprimer. ' +
                             'Voulez-vous peut-être supprimer les notes qu''elle contient ?');
               Choix_Ajouter('Non, non, ne rien faire.');
               Choix_Ajouter('Oui, supprime toutes les notes à l''intérieur de la ' +
                             'seule mesure de la partition');
               comportement := Choix_Afficher;

               if Choix_IsCancelled(comportement) then exit;
               if comportement = COMPORTEMENT_RIEN_FAIRE then exit;

               if comportement = COMPORTEMENT_MESURE_SUPPRIMER_NOTES then
               Begin
                   With Composition do
                   Begin
                         Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, mes);
                         GetMesure(0).Vider;
                         PaginerAPartirMes(mes-1, true);
                         Cancellation_Etape_Ajouter_FinDescription('Vidage de la seule mesure de la composition',
                                                                   'mes n°1',
                                                                   VOIX_PAS_D_INFORMATION); 
                   End;
                   CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
                   ReaffichageComplet;

               End;
           End;
      End;






Begin
      With Composition do
      Begin
           VerifierIndiceMesure(mes, 'TMDIChild.I_Mesure_Supprimer');


            if (NbMesures <= 1)  then
                I_Mesure_Supprimer_Traiter_Cas_Une_Mesure
            else
            Begin
                ElSC := nil;
                {oui... l'élément sous le curseur va peut être être supprimé !!!}

                Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, mes);
                Cancellation_PushMiniEtapeAAnnuler(taSupprimerMes, mes);
                Cancellation_Etape_Ajouter_FinDescription('Suppression de la mesure n° ' + inttostr(mes+1), '',
                                                           VOIX_PAS_D_INFORMATION);




                DelMesure(mes);
                CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;

                PaginerAPartirMes(mes-1, false);
                {on commence à paginer à partir de mes-1 et non de
                 mes!!! En fait, "mes" (sans -1)
                 peut provoquer un plantage atroce : imaginez 2 lignes de musiques dont la
                 2e ligne ne contient qu'une mesure. La suppression de cette dernière
                 n'entrainant dans ce cas pas de calcul de pagination, la 2e ligne subsiste,
                 or elle ne contient plus de mesures !! ---> POUF !}

                  Magnetophone_Ictus_Reset;

                ReaffichageComplet;
            end;
       End; //With Composition

End;




Procedure TMDIChild.I_Mesures_Supprimer(mes_debut, mes_fin: integer);
var mes: integer;

Begin
      if mes_debut = mes_fin then
              I_Mesure_Supprimer(mes_debut)
      else
      With Composition do
      Begin
           VerifierIndiceMesure(mes_debut, 'TMDIChild.I_Mesures_Supprimer');
           VerifierIndiceMesure(mes_fin, 'TMDIChild.I_Mesures_Supprimer');

                ElSC := nil;
                {oui... l'élément sous le curseur va peut être être supprimé !!!}

                for mes := mes_debut to mes_fin do
                Begin
                      Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, mes_debut);
                      Cancellation_PushMiniEtapeAAnnuler(taSupprimerMes, mes_debut);
                      DelMesure(mes_debut);
                End;


                Cancellation_Etape_Ajouter_FinDescription('Suppression des mesures',
                      'mes n° ' + inttostr(mes_debut+1) + ' à ' + inttostr(mes_fin+1),
                                                           VOIX_PAS_D_INFORMATION);

                CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;

                PaginerAPartirMes(mes_debut-1, false);
                {on commence à paginer à partir de mes-1 et non de
                 mes!!! En fait, "mes" (sans -1)
                 peut provoquer un plantage atroce : imaginez 2 lignes de musiques dont la
                 2e ligne ne contient qu'une mesure. La suppression de cette dernière
                 n'entrainant dans ce cas pas de calcul de pagination, la 2e ligne subsiste,
                 or elle ne contient plus de mesures !! ---> POUF !}



                ReaffichageComplet;
       End; //With Composition

End;













Function Norme1(x1, y1, x2, y2: integer):integer;
Begin
    result := abs(x1 - x2) + abs(y1 - y2);
End;







Function TMDIChild.FaireVoirPoint(x,y: integer): Boolean;
{soit (x, y) la coord. d'un point dans la page (espace virtuel)
 s'arrange pour que ce dernier soit sur l'écran}
var widthecran, heightecran, lastHscrPos, lastVscrPos: integer;
Begin
    lastVscrPos := VScrollBar.Position;
    lastHscrPos := HScrollBar.position;

    widthecran := ClientWidth * ZoomMaxPrec div Zoom;
    heightecran := ClientHeight * ZoomMaxPrec div Zoom;
    if y < pixydeb then
         VScrollBar.Position := y + 32
    else if y > pixydeb + heightecran then
         VScrollBar.Position := y - heightecran + 32;

    if x < pixxdeb then
         HScrollBar.Position := x + 32
    else if x > pixxdeb + widthecran then
         HScrollBar.Position := x - widthecran + 32;

    result := (lastVscrPos <> VScrollBar.Position) or (lastHscrPos <> HScrollBar.Position);

End;




Procedure TMDIChild.FaireVoirBandeVerticale(x1, x2: integer);
var lastHscrPos, widthecran: integer;
    bande_width: integer;
    ecranx1, ecranx2: integer;
Begin
      lastHscrPos := HScrollBar.position;

      widthecran := ClientWidth * ZoomMaxPrec div Zoom;

      ecranx1 := pixxdeb;
      ecranx2 := ecranx1 + widthecran;

      bande_width := x2 - x1;

      if (ecranx1 <= x1) and (x2 <= ecranx2) then
           exit // ok
      else if (bande_width > widthecran) and (x1 <= ecranx1) and (ecranx2 <= x2) then
           exit //ok
      else if {(bande_width > widthecran) or }(x1 < pixxdeb) then
           HScrollBar.Position := x1 + 32
      else if x2 > pixxdeb + widthecran then
           HScrollBar.Position := x2 - widthecran + 32;




End;



procedure TMDIChild.FaireVoirXToutAGaucheSaufSiCBon(x: integer);
var lastHscrPos, widthecran: integer;
    ecranx1, ecranx2: integer;
Begin
      lastHscrPos := HScrollBar.position;

      widthecran := ClientWidth * ZoomMaxPrec div Zoom;

      ecranx1 := pixxdeb + 1000;
      ecranx2 := ecranx1 + widthecran - 2000;

      if (ecranx1 <= x) and (x <= ecranx2) then
           exit // ok
      else
           HScrollBar.Position := x + 32 - 1002;




End;




Procedure TMDIChild.FaireVoirBandeHorizontale(y1, y2: integer);
var lastHscrPos, widthecran: integer;
    bande_width: integer;
    ecranx1, ecranx2: integer;
Begin
      lastHscrPos := VScrollBar.position;

      widthecran := ClientHeight * ZoomMaxPrec div Zoom;

      ecranx1 := pixydeb;
      ecranx2 := ecranx1 + widthecran;

      bande_width := y2 - y1;

      if (ecranx1 <= y1) and (y2 <= ecranx2) then
           exit // ok
      else if (bande_width > widthecran) and (y1 <= ecranx1) and (ecranx2 <= y2) then
           exit //ok
      else if {(bande_width > widthecran) or }(y1 < pixydeb) then
           VScrollBar.Position := y1 + 32
      else if y2 > pixydeb + widthecran then
           VScrollBar.Position := y2 - widthecran + 32;



      
End;






procedure TMDIChild.DefilerPartitionUnePageEnAvant;
var heightecran: integer;
Begin
   heightecran := ClientHeight * ZoomMaxPrec div Zoom;
   InitAnimDefil(0, pixydeb + heightecran);
End;


procedure TMDIChild.DefilerPartitionUnePageEnArriere;
var heightecran: integer;
Begin
   heightecran := ClientHeight * ZoomMaxPrec div Zoom;
   InitAnimDefil(0, pixydeb - heightecran);
End;




Function TMDIChild.FaireVoirMesureEtTemps(m: integer; temps: TRationnel): Boolean;
var l, x : integer;
Begin
  if m >= Composition.NbMesures then
       m := Composition.NbMesures - 1;

  if m < 0 then
  Begin
       result := false;
       Exit;
  End;

  MesureCourante := m;


  l := Composition.LigneAvecMes(m);
  MesureCourante := m;

  FaireVoirBandeHorizontale(Composition.Ligne_YHaut(l)-1000, Composition.Ligne_YBas(l)+1000);
  x := Composition.Mesure_XGauche(m) + Composition.GetMesure(m).XATemps(temps);
  FaireVoirXToutAGaucheSaufSiCBon(x);


End;



Function TMDIChild.FaireVoirMesure(m: integer): Boolean;
{fait que la mesure n° m soit à l'écran
 par ailleurs, la mesure n° m devient la mesure courante}

var h, y1, l : integer;
    widthecran, heightecran, deltaX: integer;
    newcurrentVscr, newcurrentHscr, r, rgd: integer;

    bas, haut, gauche, droite: Boolean;
    mesure: TMesure;

Begin

  if m >= Composition.NbMesures then
       m := Composition.NbMesures - 1;

  if m < 0 then
  Begin
       result := false;
       Exit;
  End;

  MesureCourante := m;


  l := Composition.LigneAvecMes(m);
  MesureCourante := m;

  FaireVoirBandeHorizontale(Composition.Ligne_YHaut(l)-1000, Composition.Ligne_YBas(l)+1000);
  FaireVoirBandeVerticale(Composition.Mesure_XGauche(m), Composition.Mesure_XDroite(m));

  exit;
  result := false;

  if ModeAffichage = maRuban then
        deltaX := GetDeltaBandeNomsPorteesDuModeRuban(Composition)
  else
        deltaX := 0;


  
  l := Composition.LigneAvecMes(m);

  {l est la ligne à faire voir, m la mesure à faire voir}

  y1 := Composition.Lignes[l].pixy;
  h :=  Composition.minHauteurLigne(l);

  heightecran := ClientHeight * ZoomMaxPrec div Zoom;
  widthecran := ClientWidth * ZoomMaxPrec div Zoom;
  {largeur et hauteur de l'écran virtuel}

  haut := ((y1 - pixydeb) <= 0);
  {vaut vrai si le haut de la ligne est dehors de l'écran (vers le haut)}

  bas := (y1 + h - pixydeb) >= heightecran;
  {itou si le bas de la ligne est dehors de l'écran (vers le bas)}

  mesure := Composition.GetMesure(m);
  
  gauche := ((mesure.pixx - (pixxdeb + deltaX)) <= 0);
  {itou si la mesure est trop vers la gauche
  (dans le cas du mode ruban, la bande verticale des noms des portées est prise en compte
   via deltaX}


  droite := ((mesure.pixx + mesure.pixWidth - pixxdeb) >= widthecran);

  if haut and bas then
  {si ça dépasse en bas et en haut, on ne peut rien faire pour afficher la ligne sur l'écran}
        r := 0
  else if haut then
        r := -1
  else if bas then
        r := 1
  else
  {si rien ne dépasse, ne rien changer}
        r := 0;


  if gauche and droite then
  {si ça dépasse en bas et en haut, on ne peut rien faire pour afficher la ligne sur l'écran}
        rgd := 0
  else if gauche then
        rgd := -1
  else if droite then
        rgd := 1
  else
  {si rien ne dépasse, ne rien changer}
        rgd := 0;

  {si r = -1, la ligne est trop en haut, on cale le bas de la ligne sur le bas de l'écran}
  if r = -1 then //la ligne est plus en haut
        newcurrentVscr := y1 - heightecran + h

  {si r = 1, la ligne est trop en bas, on cale le bas de la ligne sur le bas de l'écran}
  else if r = 1 then
         newcurrentVscr := y1
  else newcurrentVscr := VScrollBar.Position;



  if rgd = -1 then
      newcurrentHscr := mesure.pixx - widthecran
  else if rgd = 1 then
      newcurrentHscr := mesure.pixx - deltaX
  else
      newcurrentHscr := HScrollBar.Position;

  if (VScrollBar.Position <> newcurrentVscr) or (HScrollBar.Position <> newcurrentHscr) then
  Begin
      Console_AjouterLigne('Faire voir ligne ' + inttostr(l) + ' effectivement lancé : ' +
                   inttostr(VScrollBar.Position) + ', ' + inttostr(AnimDefil_currentVScr) + ', ' + inttostr(newcurrentVscr));

      result := AnimDefil_lastVscr <> VScrollBar.Position ;
      InitAnimDefil(newcurrentHscr, newcurrentVscr);

  End;

  {if result then
       VScrollBarScroll(nil,scEndScroll,y1);    }

  //
End;


procedure TMDIChild.InitAnimDefil(newcurrentHscr, newcurrentVscr: integer);
Begin
    AnimDefil_currentVScr := newcurrentVscr;
    AnimDefil_lastVscr := VScrollBar.Position;

    AnimDefil_currentHScr := newcurrentHscr;
    AnimDefil_lastHscr := HScrollBar.Position;

    AnimDefil_indice := NbFrameAnim - 1;
    {le -1 est important car ça permet d'initialiser l'animation !
    (avant, quand yavè "AnimDefil := NbFrameAnim", des fois, l'animation ne
     partait pas)}

    tmrDefilTimer.Enabled := true;

    Console_Defil(cdAllume);
End;





procedure TMDIChild.Aide_AfficherDansChildWin(mess: string; x, y, ecart: integer);
Begin
    Aide_Afficher(mess, MainForm.Left + MainForm.ControlBarLeft.width + Left + x,
                   MainForm.Top + MainForm.panMenu.Height + Top + y, ecart);
End;

procedure TMDIChild.Aide_AfficherDansComposition(mess: string; x, y, ecart: integer);
Begin
    Aide_AfficherDansChildWin(mess, ScrX(x),ScrY(y), ecart);
End;


procedure TMDIChild.SetCurrentView;
{en gros, ça fait un "setview(view)" mais ça gère aussi par ex
 qd on sélectionne des mesures, ça met en zoom plus petit}
const ZoomSelectionMesure = 50;
      HScrollBar_MIN_DEFAULT = -2000;

var v: TView;
Begin
  if View.ModeAffichage = maRuban then
  Begin
      AncienneLigneCourante := 0;
      LigneCourante := 0;
      HScrollBar.Min := 60;
  End
  else
      HScrollBar.Min := HScrollBar_MIN_DEFAULT;

  v := View;
  SetView(View);

  if IsModeSelectionMesure then
       Zoom := ZoomSelectionMesure;


End;

procedure TMDIChild.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Note: TPNote;
    elm: TElMusical;
    infoclef1: TInfoClef;
    MouseDown_iMesure: integer;

    procedure MouseDown_SelectionMesure_Traiter;
    {mode où on sélectionne des mesures
      quand on appuie sur le bouton gauche}
    var SelectionMesure_iMesure: integer;

    Begin
        if Composition.FindMesure(X, Y, SelectionMesure_iMesure) then
        Begin
              ModeSelectionMesureiDeb := SelectionMesure_iMesure;
              ModeSelectionMesureiFin := SelectionMesure_iMesure;

              Mode_Mesures_SetDebFinMes(SelectionMesure_iMesure, SelectionMesure_iMesure);
              ReaffichageComplet;
        End;
     End;



     procedure MouseDown_mode_Ecouter;
     var m: integer;
         temps: TRationnel;

         procedure MouseDown_mode_Ecouter_QuandPasLecture;
          Begin
                Magnetophone_JouerOrgueDeBarbarieEtReset(Magnetophone_Curseur, Magnetophone_Curseur);
                MainForm.tmrFinMidiNow.Enabled := true;
                FaireVoirMesure(m);

         End;
         
     Begin
         if Composition.FindMesure(X, Y, m) then
         Begin
              temps := Composition.GetMesure(m).TempsAX(X);
              temps := QDiff(temps, Qel(1));
              Magnetophone_Curseur_Deplacer(m, temps);

              if Magnetophone_IsConnectedAndPlaying then
              Begin
                  Magnetophone_Stop_SansChangerMode;
                  Magnetophone_Lecture;
                  Magnetophone_Curseur_Exciter_Bcp;
              End
              else
                  MouseDown_mode_Ecouter_QuandPasLecture;

         End
         else
               beep;

     End;



     procedure MouseDown_mode_Enregistrer;
     var m: integer;
         temps: TRationnel;
     Begin
         if Enregistreur_IsEnTrainDEnregistrer then exit;

         if Composition.FindMesurePourModif(X, Y, m) then
         Begin
              if Composition.Is_Mesure_Indice_MesureAAjouter(m) then
                   temps := Qel(0)
              else
              temps := Composition.GetMesure(m).TempsAX(X);

              Magnetophone_Curseur_Deplacer(m, temps);

         End
         else
               beep;

     End;







begin
if Voix_Selectionner_IsDansCeMode then exit;
MouseDown_Pour_MouseUp_ModeSelection_OnACliqueSurUneNoteQuOnASelectionnee := false;

if ssRight in Shift then
     MouseDown_Pour_MouseUp_ModeSelection_OnACliqueSurUneNoteQuOnASelectionnee := true;

MouseMove([], X, Y);



MettreBarreMesuresBouton_Desactiver;
Note := nil;

//mousedown
SetCurrentView;

Souris_Curseur_ScrX := x;
Souris_Curseur_ScrY := y;

X := Round(GetX(X));
Y := Round(GetY(Y));

Souris_Curseur_MouseDown_X := X;
Souris_Curseur_MouseDown_Y := Y;


if self <> MainForm.ActiveMDIChild then
Begin
      self.setFocus;
      MainForm.CapterQueYaOuNonFenetreActive(true);
End;




{mousedown}
if IsModeSelectionMesure then
Begin
    MouseDown_SelectionMesure_Traiter;
    exit;
End;

Composition_Enregistrement_ABesoinDEtreEnregistre;





SelectionRect.Left := X;
SelectionRect.Top := Y;



if MusicUser_MusicWriter_Mode_Get = mw_mode_Enregistrer then
Begin
      if ssLeft in Shift then
          MouseDown_mode_Enregistrer;
End;

if MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter then
Begin
      if ssLeft in Shift then
          MouseDown_mode_Ecouter;
End
else
if Is_GraphicObjet_SousCurseur then
Begin
     private_GraphicObjet_point_indice := GraphicObjet_SousCurseur_Get.IndicePointSousCurseur(Souris_Curseur_X,
                                                                                              Souris_Curseur_Y);

     If Is_GraphicObjet_Point_SousCurseur then
           OutilPlus := opDeplacerObjet_Point
     else
           OutilPlus := opDeplacerObjet;

     Souris_Curseur_Ancien_X := Souris_Curseur_X;
     Souris_Curseur_Ancien_Y := Souris_Curseur_Y;

End
else {mousedown}
{mousedown}
if (MusicUser_MusicWriter_Mode_Get in [mw_mode_MettreNote, mw_mode_Selection]) and
{Curseur_Souris.GetNoteSousCurseur(note)}
   Composition.NoteSousCurseur(X, Y, ElSC, note) then
{si on appuie et que ya une note sous le curseur,
    par défaut on "déplace"}
Begin
    Aide_AfficherDansChildWin('Deplace2', Souris_Curseur_ScrX, Souris_Curseur_ScrY, 0);

    if Note <> nil then
          NoteRefDeplacement := Note^
    else
    Begin
         NoteRefDeplacement.position := Souris_Curseur_Position;
         NoteRefDeplacement.HauteurNote.Alteration := aNormal;
    End;
    Composition.FindMesure(x, y, MouseDown_iMesure);

    if Note <> nil then
    Begin
        NoteRefDeplacementMesure := Curseur_Souris.GetiMesure;
        NoteRefDeplacementTemps := Curseur_Souris.GetTempsDepuisDebutMesure;
    End
    else
    Begin
        NoteRefDeplacementMesure := indMesureQuiDitPasDeDeplacementAutrePart;
        NoteRefDeplacementTemps := Qel(0);

    End;


    infoclef1 := Composition.InfoClef_DetecterAvecrelX(NoteRefDeplacement.position.Portee, MouseDown_iMesure , X);
    HauteurNoteRefDeplacement := HauteurNoteGraphiqueToAbs(infoclef1, NoteRefDeplacement);

    {on informe les afficheurs de notes sur piano et flute etc. que l'on a sélectionné
     une note (on a cliqué dessus)}
    Piano_Touches_ReleverToutes;
    Piano_Touche_Enfoncer(HauteurNoteRefDeplacement, $0000FF, MainDroite, 3);
    frmDoigtes.Traiter(HauteurNoteRefDeplacement);

    if note <> nil then
    if note^.Selectionne = svDeSelectionnee then
    {si on a cliqué sur une note qui n'était pas sélectionné, on la sélectionne,
     mais elle seulement (on désélectionne le reste)}
    Begin
          if not (ssCtrl in Shift) then
              Composition.Selection_ToutDeselectionner;
                                      
          note^.Selectionne := svSelectionnee;

          Composition.Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(MesureCourante);

          MusicUser_MusicWriter_ModeSelectionActive_ViteFait;


          MouseDown_Pour_MouseUp_ModeSelection_OnACliqueSurUneNoteQuOnASelectionnee := true;
          IGP := COmposition;

          regletemps_temps_ancien := Composition.Selection_TempsDebut;
          ReaffichageComplet;
    end;


    OutilPlus := opDeplacer;
    Deplacement_Tablature_numcase := Tablature_System_NumeroCase_Get(NoteRefDeplacement);
    Deplacement_Tablature_Corde_Ref := NoteRefDeplacement.tablature_position.hauteur;
    PorteeDeplacementRef := NoteRefDeplacement.position.portee;
    DiffPorteeDeplacement := 0;

    IntervalleDeplacement_Init;

End

else if Composition.PauseSousCurseur(X, Y, elm) then
{sinon, si on a une pause sous le curseur}

Begin
    Aide_AfficherDansChildWin('Deplacepause2',Souris_Curseur_ScrX,Souris_Curseur_ScrY,16);
    if not elm.IsSelectionne then
    {si on a cliqué sur une pause, qui n'était pas sélectionnée}
     Begin
          if not (ssCtrl in Shift) then
                Composition.Selection_ToutDeselectionner;

          elm.SelectionnerElMusical;
          elm.Selection_Valider;

          Composition.Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(MesureCourante);
          MusicUser_MusicWriter_ModeSelectionActive_ViteFait;
          IGP := Composition;
          regletemps_temps_ancien := Composition.Selection_TempsDebut;
     end;
     Souris_Curseur_MouseDown_Y := Y;
     Silences_Deplacer_HauteurDeplace := 0;
     OutilPlus := opDeplacerPause;

End
else if (not Composition.Selection_IsToutDeselectionner) and
         not (ssCtrl in Shift) and (Button <> mbMiddle) then
{on désélectionne ssi :
    on a une sélection
    le bouton Ctrl non appuyé (à cause des sélections multiples)
    le bouton du milieu non appuyé (copier-coller rapide)}


Begin
          Composition.Selection_ToutDeselectionner;
          I_Selection_MettreAJourInfo;

          ReaffichageComplet;
End;


{stylet}
if IsModeStyletAvecShift(Shift, Button) then
Begin
     MusicStylet_Points_Reset;
     MusicStylet_Points_Add(x, y);
     Exit;
End;

end;
{fin mousedown}








Function TMDIChild.TenterEnregistrer(ForcerEnregistrerSous: Boolean): Boolean;
{tente d'enregistrer le fichier.
     ForcerEnregistrerSous = true  ====> on affiche une boite de dialogue pour
       dire où on enregistre

                         = false  ===> on affiche une boite QUE si le logiciel
                         ne sait pas où enregistrer

     renvoie vrai ssi l'enregistrement a eu lieu

     }

Begin
   result := false;
   EnLecture := false;
   if (FileName <> '') and not ForcerEnregistrerSous then
   Begin
        MusicUser_Pourcentage_Init('Enregistrement de fichier');
        OuvrirFichier(FileName);
        if not Composition.Save then
             ShowMessage('La sauvegarde du fichier s''est mal déroulée.');
        FermerFichier;
        MusicUser_Pourcentage_Free;
        Composition_Enregistrement_VientDEtreEnregistre;
        result := true;

   End
   else if MainForm.SaveDialog.Execute then
   Begin
        EnLecture := false;
        FileName := MainForm.SaveDialog.FileName;
        Caption := Filename;
        MusicUser_Pourcentage_Init('Enregistrement de fichier');
        OuvrirFichier(MainForm.SaveDialog.FileName);
        Composition.Save;
        FermerFichier;
        MusicUser_Pourcentage_Free;
        Composition_Enregistrement_VientDEtreEnregistre;
        result := true;
   end;


   if result then
         Sauvegarde_Cayest;

End;




Function TMDIChild.IsEntrainDeJouer: Boolean;
Begin
    result := (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) and
                (Magnetophone_actPlayChild_Get = self);
End;





Procedure TMDIChild.DrawMisePage(optlignehaut, optlignebas: integer);
var i:integer;
Begin
    pixxOrigin := 0;
    pixyOrigin := 0;

    {bord qui n'est pas du papier}
    C.Brush.Color := RGB(128,128,128);
    C.FillRect(Rect(-10,-1,ScrX(-feuillemargegauche),1000));
    C.FillRect(Rect(ScrX(largutilisable + feuillemargegauche),-1,2000,1000));

    C.Pen.Style := psSolid;
    C.Pen.Color := CouleurCadreMiseEnPage;

    {les bords verticaux du papier}
    LineVertical(0,-100,20000);
    LineVertical(largutilisable,-100,20000);

    {les traits qui séparent les pages}
    {Ce sont des traits horizontaux aux ordonnées logiques "i*HauteurPage"
     La page n° i est entourée du trait "i*HauteurPage" et "(i+1)*HauteurPage"}
    for i := Composition.Lignes[optlignehaut].pixy div HauteurPage to
             (Composition.Lignes[optlignebas].pixy div HauteurPage) + 1 do
                 LineHorizontal(0,largutilisable,
                      i*HauteurPage);

End;





procedure TMDIChild.DrawElMusicalSousCurseur;
{Dessine l'éventuel élément musical sous le curseur désigné
    (une référence à ce dernier est ElSC)

}
var rct: TRect;
    ElSC: TElMusical;
    mesure_pixx: integer;
    ElMusical_SousCurseur_iMesure: integer;
    


    procedure DrawQueueVerticaleSupplementaire;
    var cur_pos, pos_up, pos_down: TPosition;
    Begin
         cur_pos := Curseur.GetPosition;
         pos_up := ElSC.PosNoteHaut;
         pos_down := ElSC.PosNoteBas;

         C.Pen.Color := CouleurPenElMusicalQueue;

         
         if IsPosition1Inf2(cur_pos, pos_down) then
             LineVertical(ElSC.GetXQueue, GetY(LigneCourante, pos_down),
                                          GetY(LigneCourante, cur_pos));

         if IsPosition1Inf2(pos_up, cur_pos) then
             LineVertical(ElSC.GetXQueue, GetY(LigneCourante, pos_up),
                                          GetY(LigneCourante, cur_pos));


    End;

    
Begin

      if not MusicUser_MusicWriter_Mode_IsModeAvecElementSousCurseur then
          Exit;

      if Curseur.Is_ElementMusical_Dessus then
          ElSC := Curseur.GetElementMusical
      else
          ElSC := nil;
    
      if ElSC = nil then exit;
      //préconditions
      ElMusical_SousCurseur_iMesure := Curseur.GetiMesure;
      Composition.VerifierIndiceMesure(ElMusical_SousCurseur_iMesure, 'Vérification de MesureCourante dans DrawElMusicalSousCurseur');

      try

          Composition.SetOriginMesure(ElMusical_SousCurseur_iMesure);

          C.Pen.Style := psSolid;
          C.Pen.Color := CouleurPenElMusicalSousCurseur;
          C.Pen.Width := 1;
          CouleurDessin := CouleurBrushElMusicalSousCurseur;;

          IGiLigne := LigneCourante; {pour pouvoir se servir de pixRect}
          DrawElMusical(Composition, LigneCourante,
                        ElSC,
                        false,
                        false);

          if not Curseur.Is_Curseur_Sur_Tablature then
               DrawQueueVerticaleSupplementaire;




          rct := ElSC.pixRect;

          mesure_pixx := Composition.GetMesure(ElMusical_SousCurseur_iMesure).pixX;

          inc(rct.Left, mesure_pixx);
          inc(rct.Right, mesure_pixx);

          inc(rct.Top, Composition.Lignes[LigneCourante].pixy);
          inc(rct.Bottom, Composition.Lignes[LigneCourante].pixy);

          BlitRectsApres.AjouterNextBlitRect(ScrRect(rct));

          CouleurDessin := 0;

      except
          ElSC := nil;
          {on le met pas à NIL car on en a besoin ailleurs
          (dans IsCurseurSourisSousElMusicalSelectionne)}
          {l'élément sous le curseur a été dessiné. On a plus besoin de l'information
           ElSC car elle est de toute façon remise à jour sur un MouseMove...
           Pourquoi mettre ElSC := nil ?? En fait, en cas d'erreur, si ça plante,
           car une routine exterieure a mis ElSC n'importe comment, au moins comme ça,
           ça remet à nil}
          //Canvas.Draw(0,0,Scr);
      end;

End;




procedure TMDIChild.FormPaint(Sender: TObject);


var i,iligne, x1, x2 : integer;
    LastDessinerFondVoixNonPresente: Boolean;



      xmin, xmax: integer;

      Procedure InitXMinXMax;
      Begin
           xmin := 100000;
           xmax := -100000;
      End;

      
      Procedure MettreAJourXMinetMax(x: integer);
      Begin
          if x < xmin then
                xmin := x;

          if x > xmax then
              xmax := x;
      End;

      var Optimisation_Affichage_ModeRuban_Rectangle: TRect;
      
      procedure Gerer_Optimisation_Affichage_ModeRuban_ChangementPorteeCourante;
      var ip1, ip2, y1, y2: integer;
      
      Begin
          ip1 := min(Optimisation_Ancien_iPorteeCourant, iPorteeCourant);
          ip2 := max(Optimisation_Ancien_iPorteeCourant, iPorteeCourant);

          y1 := GetY(ip1, 20);
          y2 := GetY(ip2, -20);

          y1 := ScrY(y1);
          y2 := ScrY(y2);

          Optimisation_Affichage_ModeRuban_Rectangle := Rect(0, y1, ClientWidth, y2);
          //BlitRectsApres.AjouterNextBlitRect(Rect(0, y1, ClientWidth, y2));
          BlitterToutDuBackBuffer := true;
          //Optimisation_Affichage_ModeRuban_ChangementPorteeCourante := false;
      End;


      procedure TraiterBlitRectsApres;
      var i: integer;
          R: TRect;

          Function Rectangle_ElargirUnPeuSiTropFin(r: TRect): TRect;
          var a: TRect;
          Begin
              a := r;

              if a.Left = a.Right then
                  a.Left := a.Right - 1;

              if a.Top = a.Bottom then
                  a.Top := a.Bottom - 1;

              result := a;
          End;
      
      Begin
          for i := 0 to high(BlitRectsApres.BlitRects) do
          Begin
              R := Rectangle_ElargirUnPeuSiTropFin(BlitRectsApres.BlitRects[i]);
              C.CopyRect(R, BackBuffer.Canvas, R);
          End;
      End;





      procedure IctusListe_Afficher;
      var i: integer;
      Begin
          for i := 0 to high(IctusListe) do
               Ictus_Draw(C, Composition, BlitRectsApres, IctusListe[i].imesure, IctusListe[i].temps);
          C.Pen.Width := 1;
      End;


      procedure ModePage_ScrollBarVisible_Gerer;
      var ecran_width, feuille_width : integer;
      Begin
           ecran_width := ClientWidth * ZoomMaxPrec div Zoom;
           feuille_width := largutilisable + 2*feuillemargegauche;
           HScrollBar.Visible := feuille_width > ecran_width;
           VScrollBar.Visible := true;
      End;


      procedure ModeRuban_ScrollBarVisible_Gerer;
      Begin
           VScrollBar.Visible := true;
           HScrollBar.Visible := true;
      End;



      Function ConditionPourAfficherBarreAvancement : Boolean;
      Begin
           result := IsEnTrainDeJouer Or
                    ((not Enregistreur_IsEnTrainDEnregistrer)
                      and (MusicUser_MusicWriter_Mode_Get = mw_mode_Enregistrer)
                      and (not Selection_Rectangle_IsEnTrainDeSelectionner));
      End;


      procedure DessinerBarreAvancement;
      Begin
             if Magnetophone_actPlayChild_Get <> self then
             Begin
                  MessageErreur('bizarre : la fenêtre lue est pas la fenêtre dans DessinerBarreAvancement');
                  exit;
             end;
             if Magnetophone_iMesure_Get <= Composition.NbMesures then
             Begin
                  BlitterToutDuBackBuffer := true;
                  Magnetophone_NotesEntenduees_Dessiner(C, Magnetophone_Curseur);
                  DrawBarreLectureMIDI(C,
                                       Composition,
                                       BlitRectsApres,
                                       Magnetophone_iMesure_Get,
                                       Magnetophone_TempsInMesure_Get,
                                       private_Magnetophone_Curseur_Excitation);

                  if private_Magnetophone_Curseur_Excitation > 0 then
                       dec(private_Magnetophone_Curseur_Excitation);
             end
             else
                 Composition.VerifierIndiceMesureOuDerniere(Magnetophone_Curseur.imesure, 'LectureMIDI_MesurePlayed est incorrect ! dans FormPaint_LectureMIDI')

       End;

begin
    panInstruments_Portees.Visible := (Composition.NbInstruments > 1); 



    if MusicWriter_Erreur_IsEtatErreur then
    Begin
        Canvas.Brush.Style := bsFDiagonal;
        Canvas.Brush.Color := $888888;
        Canvas.FillRect(ClientRect);
        exit;
    End;


    if CDevice = devImprimante then
    {si on est en train d'imprimer, on quitte TOUT DE SUITE (car sinon, ça
     va faire des interférences}
            Exit;

    if MusicGraph_Canvas_IsLocked then
         exit;

    if VerouillerLeReaffichage then
          exit;
          
    if not VerifierIntegrite('FormPaint') then
          exit;

          
    InitXMinXMax;


    CDevice := devEcran;


     {par défaut, on est en mode "écran" normal et non pas devEcranPasEdition
       comme quand on écoute ou quand on choisit une mesure}
    LastDessinerFondVoixNonPresente := DessinerFondVoixNonPresente;


    if RedessinerTout then
          Console_FormPaint(cfpAfficherTout)
    else
          Console_FormPaint(cfpAfficher);





    CHeight := ClientHeight;


    IGP := Composition;

//formpaint
    SetCurrentView;



    if View.ModeAffichage = maRuban then
    Begin
        FaireVoirBandeHorizontale(0, Composition.Ligne_YBas(0));
        ModeRuban_ScrollBarVisible_Gerer;
    End
    else
    Begin
         FaireVoirBandeVerticale(-feuillemargegauche, largutilisable + feuillemargegauche);
         ModePage_ScrollBarVisible_Gerer;
    End;


    if Sender <> nil then
            BlitterToutDuBackBuffer := true;

    MettreAJourCentrageScrollBar;

    VScrollBar.Max := 6400 + Composition.Lignes[high(Composition.Lignes)].pixy;
    HScrollBar.Max := max(6000 {pour le mode page},
    {pour le mode ruban -->} Composition.GetMesure(Composition.NbMesures - 1).pixX +
                             Composition.GetMesure(Composition.NbMesures - 1).pixWidth +
                                                                            + 600);

    x1 := GetX(0);
    x2 := GetX(ClientWidth);


    Optimisation_Affichage_ilignehaut := Composition.LignePlusProcheAvecY(GetY(0));
    Optimisation_Affichage_ilignebas := Composition.LignePlusProcheAvecY(GetY(ClientHeight));

    if Navigateur.Visible then
    if View.ModeAffichage = maRuban then
          Navigateur.Mesures_Affichees_Set(Composition.GetMesureSurLigne(0, x1),
                                           Composition.GetMesureSurLigne(0, x2))
    else
          Navigateur.Mesures_Affichees_Set(Composition.LignesMDeb(Optimisation_Affichage_ilignehaut),
                                     Composition.LignesMFin(Optimisation_Affichage_ilignebas));


     {regarde s'il y a à dessiner un fond de voix non présent}
     DessinerFondVoixNonPresente := false;

     if not (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) then
     Begin

         if MesureCourante = Composition.NbMesures then
               DessinerFondVoixNonPresente := true
         else if Composition.IsIndiceMesureValide(MesureCourante) then
            if not Composition.GetMesure(MesureCourante)
                         .IsVoixNumPresente(Curseur.GetiVoixSelectionnee) then
              DessinerFondVoixNonPresente := true;
     End
     else
     {si on est train de jouer, pas besoin de montrer les trucs graphiques
       destinés uniquement à l'édition}
          CDevice := devEcranPasEdition;

     if not option_DesFoisDessinerFondVoixQuandVoixNonEncorePresente then
          DessinerFondVoixNonPresente := false;

     {formpaint}
     if LastDessinerFondVoixNonPresente <> DessinerFondVoixNonPresente then
            RedessinerTout := true;

     if not MusicUser_MusicSystem_Mode_IsModeAvecVoixCourante then
           DessinerFondVoixNonPresente := false;

     if OutilPlus = opSelection then
           DessinerFondVoixNonPresente := false;

     if not Outil_MettreNoteIsModeSouris then
           DessinerFondVoixNonPresente := false;



if ReafficherToutToutleTemps or RedessinerTout or DessinerFondVoixNonPresente then
Begin
     if UtiliserBackBuffer then
          MusicGraph_Canvas_Set(BackBuffer.Canvas)
     else
          MusicGraph_Canvas_Set(Canvas);


     C.Brush.Color := CouleurFondEcran;

     if not DessinerFondVoixNonPresente or RedessinerTout then
         C.FillRect(ClientRect)
     else with BlitRectsavant do
        for i := 0 to high(NextBlitRects) do
              C.FillRect(NextBlitRects[i]);

     BlitRectsavant.ViderNextBlitRects;

     if IsModeSelectionMesure then
         DrawFondSelectionMesures(C,
                                  Composition,
                                  Mode_Mesures_GetDebMes,
                                  Mode_Mesures_GetFinMes);


     {dessin du fond de voix non présente}
     {formpaint}
     if DessinerFondVoixNonPresente and Composition.IsIndiceLigneValide(LigneCourante) then
     Begin
          IGP := Composition;
          IGiLigne := LigneCourante;  
          DrawFondVoixNonPresente(C,
                             Composition,
                             BlitRectsAvant,
                             Curseur.GetiVoixSelectionnee,
                             Souris_Curseur_Position,
                             MesureCourante);
     End;

     if (View.ModeAffichage <> maRuban) then
        DrawMisePage(Optimisation_Affichage_ilignehaut, Optimisation_Affichage_ilignebas);
        {mise à part, l'affichage en ruban, les autres sont des affichages
         de type "page" et donc ça fait plus joli si on affiche les cadres des pages}



     if DessinerFondVoixNonPresente and not RedessinerTout
          and Composition.IsIndiceMesureValide(MesureCourante) then
     With Composition.GetMesure(MesureCourante) do
     Begin

            AfficherPartition(Composition, LigneCourante, LigneCourante,
                     pixX, pixX + pixWidth);

            IctusListe_Afficher;
            if RegleTemps_IsAffiche then
                 RegleTemps_Partition_Afficher(Composition, LigneCourante, LigneCourante,
                        pixX, pixX + pixWidth);

     end

     else
     Begin
            AfficherPartition(Composition, Optimisation_Affichage_ilignehaut,
                                Optimisation_Affichage_ilignebas, x1, x2);

            IctusListe_Afficher;
            if RegleTemps_IsAffiche then
                  RegleTemps_Partition_Afficher(Composition, Optimisation_Affichage_ilignehaut,
                                Optimisation_Affichage_ilignebas, x1, x2);
     End;

     if Optimisation_Affichage_ModeRuban_ChangementPorteeCourante then
            Gerer_Optimisation_Affichage_ModeRuban_ChangementPorteeCourante
     else
            BlitterToutDuBackBuffer := true;
            
     RedessinerTout := false;
end;

     If ToutDessinerDansBitmapScrDabord then
           MusicGraph_Canvas_Set(Scr.Canvas)
     else
           MusicGraph_Canvas_Set(Canvas);

     if UtiliserBackBuffer then
     Begin

        if BlitterToutDuBackBuffer or (not BlittageIntelligent) then
           C.Draw(0, 0, BackBuffer)
        else
            TraiterBlitRectsApres;

     End;

     BlitterToutDuBackBuffer := false;

BlitRectsApres.ViderNextBlitRects;

//si on est en train de jouer... (et vous en train d'écouter du MIDI)
//**************************************************************************
{Formpaint}
if ConditionPourAfficherBarreAvancement then
   DessinerBarreAvancement
Else
Begin


     {trace les notes sélectionnées (et en rouge svp !!)}

     DrawNotesSelectionnees(C, Composition, Optimisation_Affichage_ilignehaut,
                                            Optimisation_Affichage_ilignebas);

     Enregistreur_NotesEnfonces_Afficher;

     
     if RegleTemps_IsAffiche and Composition.Selection_YaUneSelection then
     Begin
            regletemps_temps_ancien := Composition.Selection_TempsDebut; 
            RegleTemps_DrawBarSelectionnee_AvecTemps(Composition,
                                                     Composition.LigneAvecMes(Composition.Selection_GetIMesDebutSelection),
                                                     Composition.Selection_GetIMesDebutSelection,
                                                     QAdd(regletemps_temps_ancien, Qel(1)), rtdbstNoteSelectionnee);
     End;

     
     {formpaint}
     if OutilPlus = opSelection then
         DrawRectangleSelection(C, BlitRectsApres, ClientRect, SelectionRect)

     else if (OutilPlus = opDeplacer) or (OutilPlus = opDeplacerClavier) then
     Begin
     {on est en cours de déplacement de notes}
            DrawNotesDeplacements(BlitRectsApres,
                                Composition,
                                Optimisation_Affichage_ilignehaut,
                                Optimisation_Affichage_ilignebas,
                                IntervalleDeplacement_Get,
                                DiffPorteeDeplacement,
                                LigneCourante,
                                Deplacement_Tablature_Corde_Deplacement,
                                {var} BlitterToutDuBackBuffer);



     End
     else if OutilPlus = opDeplacerPause then
     {on est en cours de déplacement de pauses}
     Begin
            DrawPausesDeplacements(Composition,
                                Optimisation_Affichage_ilignehaut,
                                Optimisation_Affichage_ilignebas,
                                Silences_Deplacer_HauteurDeplace);
            BlitterToutDuBackBuffer := true;
     end


     {Formpaint}
     else if (0 <= LigneCourante) and (LigneCourante <= high(Composition.Lignes)) then
     Begin
         C.Pen.Style := psDash;
         C.Brush.Style := bsClear;

         DrawCadreAutourMesureCourante(C, Composition,
                                       AncienneMesureCourante,
                                       AncienneLigneCourante, MesureCourante,
                                       LigneCourante);



         if MusicUser_MusicSystem_Mode_IsModeAvecVoixCourante then
         {affichage du liserai de sélection des voix}
         DrawLiseraiSelectionVoix(C, Composition,
                                  Optimisation_Affichage_ilignehaut,
                                  Optimisation_Affichage_ilignebas,
                                  x1, x2,
                                  Curseur.GetiVoixSelectionnee);




           {**** dessine éventuellement l'el musical sous le curseur}
           DrawElMusicalSousCurseur;


           If CurseurClavier_Clignotant_VisibleEnCemoment
              and Is_CurseurClavier_Affichage_Condition then
               Draw_CurseurClavier(C,
                                   Composition,
                                   BlitRectsApres,
                                   Curseur);

           if IsBarreDeMesureSousCurseur then
               DrawBarreDeMesureSousCurseur(C,
                                            Composition,
                                            BlitRectsApres,
                                            BarreDeMesureSousCurseur_iMesure)
                                            
           else if Is_ClefDebut_PorteeSousCurseur then
               DrawContourClef(C,
                               Composition,
                               BlitRectsApres,
                               0,
                               0,
                               - margepourmesure,
                               ClefDebut_iPortee)

           else if Is_Portees_Instruments_Noms_Zone then
               DrawPortees_Instrument_Nom_Zone_SousCurseur(C,
                                                           Composition,
                                                           BlitRectsApres,
                                                           Portees_Instruments_Noms_Zone_iLigne,
                                                           Portees_Instruments_Noms_Zone_iPortee
                                                           )
                               


           else if ClefInseree_Is_SousCurseur then
           try
               DrawContourClef(C,
                               Composition,
                               BlitRectsApres,
                               LigneCourante,
                               MesureCourante,
                               Composition.GetMesure(MesureCourante).ClefsInserees[private_clef_inseree_indice].pixx,
                               private_clef_inseree_iportee)

             except
                 MessageErreur('Dans Formpaint, il y a un problème lors de l''appel à DrawContourClef');
                 ClefInseree_SousCurseur_DireQueYenAPas; {ne devrait jamais arrivé normalement}
                 
          end 
          else if Is_Octavieur_SousCurseur then
          try
              DrawContourOctavieur(C,
                                   Composition,
                                   BlitRectsApres,
                                   LigneCourante,
                                   private_octavieur_iportee,
                                   private_octavieur_indice)

              except
                  MessageErreur('Dans Formpaint, il y a un problème lors de l''appel à DrawContourOctavieur');
                  private_octavieur_indice := -1;
          end

          else if Is_TonaliteSousCurseur then
              DrawContourTonalite(C,
                                   Composition,
                                   BlitRectsApres,
                                   LigneCourante,
                                   MesureCourante,
                                   Souris_Curseur_Position.portee)

          else if Is_TonaliteAvantBarreDeMesureSousCurseur then
             DrawContourTonaliteAvantBarreDeMesureSousCurseur(C,
                                   Composition,
                                   BlitRectsApres,
                                   LigneCourante,
                                   MesureCourante,
                                   Souris_Curseur_Position.portee)

          else if Is_RythmeSousCurseur then
              DrawContourRythme(C,
                                   Composition,
                                   BlitRectsApres,
                                   LigneCourante,
                                   MesureCourante,
                                   Souris_Curseur_Position.portee)


          else if Is_GraphicObjet_SousCurseur then
             DrawContourObjetGraphique(C,
                                       Composition,
                                       BlitRectsApres,
                                       GraphicObjet_SousCurseur_Get)
          else
          {Formpaint}
//          FormPaint_CurseurSouris_Gerer;
          {condition pour afficher le modèle "curseur souris" :}
          if Is_CurseurSouris_Affichage_Condition then
          Begin
              {affiche le modèle "curseur" à l'emplacement courant du curseur}

                if (Outil = PlacerCurseur) then
                Begin
                     pixxorigin := Curseur.GetPixx_in_doc;
                     iligne := Composition.LigneAvecMes(Curseur.GetiMesure);
                End
                else
                Begin
                     pixxorigin := Souris_Curseur_X;
                     iligne := LigneCourante;
                End;


                Begin
                    if Composition.Portee_IsTablature(Souris_Curseur_Position.portee) then
                         Draw_Tablature_Curseur(C,
                                                Composition,
                                                BlitRectsApres,
                                                Curseur.GetiVoixSelectionnee,
                                                pixxorigin{},
                                                iligne,
                                                MesureCourante,
                                                Souris_Curseur_Position,
                                                0,
                                                ClientHeight)
                    else
                          DrawCurseur_Modele(C,
                                      Composition,
                                      BlitRectsApres,
                                      Curseur.GetiVoixSelectionnee,
                                      Curseur_Entree_WaveIn_IsExcite,
                                      pixxorigin {},
                                      iligne,
                                      MesureCourante,
                                      Souris_Curseur_Position,
                                      Souris_Curseur_Xdansmesure,
                                      Modeles[ModeleSousCurseur].Voix,
                                      Curseur.GetHauteurNote,
                                      ClientHeight,
                                      SourisCurseur_Clignotement_Etat);

                End;



                    {Formpaint}
                    if CompleterAutomatiquementAvecPausesEnDebut and
                       Composition.IsIndiceMesureValide(MesureCourante) then
                    Begin
                          {affiche les pauses grisées qui complète la voix avant
                           le curseur}
                        DrawPauseAInserer(C,
                                          Composition,
                                          BlitRectsApres,
                                          LigneCourante,
                                          MesureCourante,
                                          Curseur.GetiVoixSelectionnee,
                                          Souris_Curseur_Position);
                        BlitRectsApres.AjouterNextBlitRect(ClientRect);
                    End;


              end;
                DessinerNoir;


     End;


End;

     BlitRectsApres.BlitRects := BlitRectsApres.NextBlitRects;





     {formpaint}
     {si on utilise l'outil pour placer des courbes (phrasés...}
     if IsOutilMettreObjetGraphiqueDemandePoint then
     Begin
            SetPixOrigin(0, 0);
            With GraphicObjet_ObjetEnCours do
            Begin
                 Points_DrawCercles;
                 Draw;
            End;
     End;

     AfficherLeToutClignotant;

     If ToutDessinerDansBitmapScrDabord then
     Begin
         if Optimisation_Affichage_ModeRuban_ChangementPorteeCourante then
         Begin
            {Canvas.CopyRect(Optimisation_Affichage_ModeRuban_Rectangle,
                            Scr.Canvas,
                            Optimisation_Affichage_ModeRuban_Rectangle); }
            Optimisation_Affichage_ModeRuban_ChangementPorteeCourante := false;
         End
         else
              Canvas.Draw(0,0,Scr);


     ENd;


     MettreBarreMesuresBouton_Boucle;


end; {{formpaint}












Procedure TMDIChild.MettreAJourAffNoteDeplacementSouris(X, Y, m:integer; AlterationDefaut: Boolean);
var pos:TPosition;
    NouvelleHauteurNoteDeLaNoteDeRef: THauteurNote;
    infoclef2: TInfoClef;
    ancienIntervalle: TIntervalle;
    IntervalleDeplacement_Pas_Erreur: TIntervalle;

Begin
    {chope la position}
    GetPosition(Y, Composition, Composition.LigneAvecMes(m), pos);

    ancienIntervalle := IntervalleDeplacement_Get;
    
    if Composition.Portee_IsTablature(pos.portee) then
    Begin
          DiffPorteeDeplacement := pos.Portee - 1 - PorteeDeplacementRef;

          Deplacement_IsSurTablature := true;
          Deplacement_Tablature_Corde_Deplacement := pos.hauteur - Deplacement_Tablature_Corde_Ref;
          IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(
                         Tablature_System_NumCordeNumCaseToHauteurNote(
                             Tablature_System_PositionHauteurToCordeNum(pos.Hauteur) ,
                             Deplacement_Tablature_numcase));
    End
    else
    Begin
          Deplacement_IsSurTablature := false;
          Deplacement_Tablature_Corde_Deplacement := 0;

          
          infoclef2 := Composition.InfoClef_DetecterAvecrelX(pos.Portee, m, X);

          DiffPorteeDeplacement := pos.Portee - PorteeDeplacementRef;
          NouvelleHauteurNoteDeLaNoteDeRef.Hauteur := HauteurGraphiqueToHauteurAbs(infoclef2, pos.hauteur);

          if AlterationDefaut then
              IntervalleDeplacement_Pas_Erreur := intervalle0
          else
              IntervalleDeplacement_Pas_Erreur := IntervalleDeplacement_Get;

          if AlterationDefaut then
          Begin
             if NouvelleHauteurNoteDeLaNoteDeRef.Hauteur = HauteurNoteRefDeplacement.Hauteur then
                     NouvelleHauteurNoteDeLaNoteDeRef.alteration := HauteurNoteRefDeplacement.alteration
             else
                     NouvelleHauteurNoteDeLaNoteDeRef.alteration := AlterationAvecTonalite(NouvelleHauteurNoteDeLaNoteDeRef.Hauteur, Curseur.GetTonaliteCourante);
          end;

          IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(NouvelleHauteurNoteDeLaNoteDeRef);
    End;

    
    if not HauteursNotesEgales(ancienIntervalle, IntervalleDeplacement_Get) then
    Begin

          Selection_Transposition_Tester_EtSiPasBonRevenirEtatPrecedent(IntervalleDeplacement_Get,
                                                              IntervalleDeplacement_Pas_Erreur);
          //FormPaint(nil);

          //écrit l'intervalle de déplacement
          MainForm.StatusBar.Panels[0].Text := IntervalleToStr(IntervalleDeplacement_Get);
    End;


End;


Procedure TMDIChild.Selection_Transposition_Tester_EtSiPasBonRevenirEtatPrecedent(intervalle_deplacement_a_tester, intervalle_deplacement_correct: TIntervalle);
var texte_erreur_precis: string;
    NouvelleHauteurNote: THauteurNote;
    selection_nb_notes_restants: integer;
        
Begin
     if Composition.Selection_Transposer_Is_Erreur(intervalle_deplacement_a_tester, texte_erreur_precis) then
     Begin
         GetHauteurNote(IntervalleDeplacement_Get, HauteurNoteRefDeplacement, NouvelleHauteurNote);

         selection_nb_notes_restants := Composition.Selection_NbNotes_Get - 1;

         Aide_Params_Ajouter('Vous voulez transformer le ' +
                             HauteurNoteToStr(HauteurNoteRefDeplacement) + ' en ' +
                             HauteurNoteToStr(NouvelleHauteurNote) + ', et transposer ' +
                             Langue_ArticleDefini_lapostrophe_ou_les_nombre_et_espace(selection_nb_notes_restants) +
                             Langue_MettreSSiPluriel('autre', selection_nb_notes_restants) + ' ' +
                             Langue_MettreSSiPluriel('note', selection_nb_notes_restants) +
                             ' de la sélection de ' +
                             IntervalleToStr(intervalle_deplacement_a_tester) + '. ' +
                             texte_erreur_precis);

         Aide_Params_Ajouter('transposer de ' + IntervalleToStr(intervalle_deplacement_correct));
         Aide_MessageInformation_Afficher('alteration_erreur');
         IntervalleDeplacement_Definir(intervalle_deplacement_correct);
     End
     else
           Aide_Cacher;
End;


Procedure TMDIChild.MettreAJourAffNoteDeplacement;
{appelé par MettreAJourAffNoteDeplacementSouris appelé par MouseMove...}

var IntervalleDeplacement_Pas_Erreur: THauteurNote;


Begin

    Selection_Transposition_Tester_EtSiPasBonRevenirEtatPrecedent(IntervalleDeplacement_Get,
                                                                  IntervalleDeplacement_Pas_Erreur);

    FormPaint(nil);
    MainForm.StatusBar.Panels[0].Text := IntervalleToStr(IntervalleDeplacement_Get);
End;




procedure TMDIChild.MettreAJourNotesADeplacees(ajouter, modetonalpur, Deplacement_IsSurTablature: Boolean);
Begin

    Composition.MettreAJourNotesADeplacees(IntervalleDeplacement_Get, DiffPorteeDeplacement,
                                           Deplacement_IsSurTablature, Deplacement_Tablature_Corde_Deplacement div 2,
                                           ajouter, modetonalpur);

    With Composition do
        PaginerLesMesuresEtApresSiBesoin(Selection_Getimesdebutselection,
                                                 Selection_Getimesfinselection,
                                                 false);

    IntervalleDeplacement_Init;
End;





procedure TMDIChild.CurseurSouris_Visible_Set(v: boolean);
Begin
    SourisCurseur_IsVisible := v;

    With tmrSourisCurseur_Clignotement_Timer do
    Begin
         enabled := false; //pour être sûr que ça s'affiche tout de suite
         enabled := v;
    End;

End;







Function TMDIChild.IsCurseurDansBandeNomsPorteesDuModeRuban(X: integer): Boolean;
var x1, x2: integer;
Begin
    if ModeAffichage = maRuban then
    Begin
           GetAbscisseBandeNomsPorteesDuModeRuban(Composition, x1, x2);

           result := (x1 <= X) and (x <= x2);
    End
    else
          result := false;
End;





Function TMDIChild.IsGestionPorteeCouranteActivee: Boolean;
{renvoie VRAI ssi on gère le phénomène des portées actives
 PS : portée active = portée là où ya le curseur qui s'agrandit}
Begin
    result := (ModeAffichage = maRuban) and Composition.IsPartitionDOrchestre
               and option_PorteeCourante_ZoomActive_Quand_PartitionOrchestre;

End;





procedure TMDIChild.Magnetophone_Ictus_Reset;
Begin
    setlength(IctusListe, 0);
    ReaffichageComplet;
End;

procedure TMDIChild.Magnetophone_Ictus_Poser;
var l: integer;
Begin
    l := length(IctusListe);

    setlength(IctusListe, l+1);

    IctusListe[l] := Magnetophone_Curseur;

    ReaffichageComplet;
End;

procedure TMDIChild.FormMouseMove(Sender: TObject; Shift: TShiftState;
                                  X,  Y: Integer);

const seuilTailleRectSelection = 10*prec; {lorsqu'on maintient le bouton gauche appuyé,
       et que l'on bouge de plus de seuilTailleRectSelection pixels logiques à partir de la
       position d'origine, le rectangle de sélection apparaît}

       
var infoclef: TInfoClef;
    i:integer;
    NSC, PauseSC, ESC, QSC, yab, yabf:Boolean;
    IndiceElMusicalCourant: integer;
    Xdansmesure, Ydansmesure: integer;


    procedure ModifierPorteeCourante(iportee: integer);
    {informe de qui est la portée active}
    Begin

         Composition.VerifierIndicePortee(iportee, 'ModifierPorteeCourante');

         if (iPorteeCourant <> iPortee) then
          Begin
               Console_AjouterLigne('ModifierPorteeCourante : ' + inttostr(iportee));

              Optimisation_Ancien_iPorteeCourant := iPorteeCourant;
              iPorteeCourant := iportee;
              {iPorteeCourant est une variable globale, qui est utilisée
               pour l'affichage de la partition}

              SetMusicWriterAffiche;
              {oui, on dit qu'on affiche car par ex, les pixy des portées
               sont vraiment celles affichées...}

              IGP := Composition;
              IGiLigne := 0;
              Composition.CalcPorteesPixy(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN);
              //rem : ici on est forcément en mode ruban

              Composition.CalcQueue(0, 0);

              Optimisation_Affichage_ModeRuban_ChangementPorteeCourante := true;
              ReaffichageComplet;
          End;
    End;



    Function IsModeSelectionPossible(Shift: TShiftState) : Boolean;
    Begin
             result := (MusicUser_MusicWriter_Mode_Get in [mw_mode_MettreNote, mw_mode_Selection, mw_mode_Enregistrer])
                       and (ssLeft in Shift);
    End;






    procedure Stylet_MouseMove_Afficher_Trait;
    var pt_prec: TPoint;

    Begin
            pt_prec := Music_Stylet_Points_Precedent_Get;

            Canvas.Pen.Color := MusicStylet_Couleur;
            Canvas.MoveTo(ScrX(pt_prec.x),
                          ScrY(pt_prec.y));
            Canvas.LineTo(Souris_Curseur_ScrX, Souris_Curseur_ScrY);
    End;



    Function Stylet_MouseMove: Boolean;
   {retourne VRAI ssi elle a fait qch
    {ça permettra à la fonction principale de quitter éventuellement en fonction
     de cette valeur}

    Begin
        result := false;
            {Si on est en mode stylet}
        if IsModeStyletAvecShift(Shift, TMouseButton(10)) then
            MusicStylet_Points_Add(Souris_Curseur_X, Souris_Curseur_Y);

        if MusicStylet_Stylet_AEteUtilise then
        Begin
             PopupMenu := nil;
             Stylet_MouseMove_Afficher_Trait;
             MusicStylet_Points_Informer;
             result := true;
        End;

    End;




    procedure MouseMove_CalculerIndiceElMusicalCourant;
    Begin
         if yab then
          with Composition.GetMesure(MesureCourante) do
            yabf := VoixNum(Curseur.GetiVoixSelectionnee).FindElMusicalApres(X,
                                                                             IndiceElMusicalCourant);
    End;

    procedure MouseMove_CalculerPausesGloutonsAMettre;
    var dt: TDuree;
    Begin
       if yab then
       with Composition.GetMesure(MesureCourante) do
       Begin
            if CompleterAutomatiquementAvecPausesEnDebut and
               (IndiceElMusicalCourant = length(VoixNum(Curseur.GetiVoixSelectionnee).ElMusicaux)) then
            {Pour le phénomène des pauses gloutons, il faut que le curseur se situe
             à la FIN de la voix courante}
            Begin
                dt := Qdiff(QDiff(TempsAX2(X),
                                   VoixNum(Curseur.GetiVoixSelectionnee).DureeTotale), Qel(1));

                if IsQ1InfQ2(dt, Qel(0)) then
                     dt := Qel(0);

                GloutonPause(dt, PausesAvantCurseur);
                {on place les durées des pauses à mettre avant le curseur
                 pour insérer le prochain modèle
                 -> l'affichage se fait dans FormPaint}

            End else PausesAvantCurseur := nil;
       End else PausesAvantCurseur := nil;
    End;



    Function ElMusicalToStrQuiFaitPartiDe(ElSC: TElMusical): string;
    var s: string;
    Begin
             s := ElMusicalToStr(ElSC, true);

             if (s <> '') and (length(ElSC.Notes) > 1) then
                   s := ', qui fait parti d''' + s
             else
                  s := '';

             result := s;

    End;




    Function MouseMove_RegleTemps_Gerer: Boolean;
    var temps_nouveau: TRationnel;
    
    Begin

            result := false;

            if not RegleTemps_IsAffiche then exit;

            

            if IsRegleTemps_Curseur_Dessus(Composition, LigneCourante, MesureCourante,
                                             X, Y, temps_nouveau) then
            Begin
                   FormPaint(nil);
                   MusicGraph_Canvas_Set(Canvas);
                   RegleTemps_DrawBarSelectionnee_AvecTemps(Composition,
                                                  LigneCourante, MesureCourante,
                                                           temps_nouveau, rtdbstSousCurseur);

                  result := true;
           End;
    End;

    procedure MouseMove_StatusBar_Traiter;
    //var //s: string;
        //tps: TRationnel;

    Begin
          With MainForm.StatusBarPosition do
          Begin
              Panels[0].text := 'page ' + inttostr(1 + Composition.iPageFromiLigne(LigneCourante)) +
                    '/' + inttostr(1 + Composition.iPageFromiLigne(high(Composition.Lignes)));

              Panels[1].text := 'ligne ' + inttostr(1 + LigneCourante)
                               + '/' + inttostr((length(Composition.Lignes)));

              if yab then
                    Panels[2].text := 'mesure ' + inttostr(1 + MesureCourante)
                                      + '/' + inttostr(Composition.NbMesures) +', ' +
                                     'temps : ' + QToStr(Curseur_Souris.GetTempsDepuisDebutMesure)

              else
                   Panels[2].text := 'mesure ' + inttostr(1 + MesureCourante)
                                       + ' (fin de partition)';



              Panels[3].text := 'portée : ' + inttostr(Souris_Curseur_Position.portee);

              Panels[4].text := 'Note : ' + HauteurNoteToStr(IntervalleDeplacement_Get);

             { if false then
              Begin
                    s :=    {  ' | po : ' + inttostr(Souris_Curseur_Position.portee) +
                           ' | hauteur : ' + inttostr(Souris_Curseur_Position.hauteur) +
                           ' | mes ' + inttostr(1 + MesureCourante) + '/' + inttostr(Composition.NbMesures) }
                           {' | X dans la mes. : ' + inttostr(X) +
                           ' | Voix : ' + inttostr(VoixSelectionnee) + }
                           {' | pixydeb : ' + inttostr(pixydeb)+ }
                          { ' | Note : ' + HauteurNoteToStr(IntervalleDeplacement)+     }
                        {    '| X : ' + inttostr(Souris_Curseur_X) +
                            '| Y : ' + inttostr(Souris_Curseur_Y)
                             + '| scrX : ' + inttostr(Souris_Curseur_ScrX)
                             + '| scrY : ' + inttostr(Souris_Curseur_ScrY)     }
                            { +
                           ' | Début sélection : ' + QToStr(Composition.TempsDebutSelection) +
                           ' | Fin sélection : ' + QToStr(Composition.TempsFinSelection);  }
                           ;

                   { if yab {yab c'est Composition.FindMesure(X, Y, MesureCourante)} {then
                    Begin
                         tps := Curseur_Souris.GetTempsDepuisDebutMesure;


                         s := s + ' | ' + inttostr(infoclef);
                         s := s + ' | X_in_mes : ' + inttostr(Curseur_Souris.GetPixx_in_mesure);
                    end
                    else
                         tps := Qel(1);



                    Panels[5].text := s;
              end; }
          End;

          MainForm.Tonalite_Mettre_A_Jour;
    End;





    procedure MouseMove_CurseurSouris_AspectGraphique_Traitement;

       procedure CurseurNormal_Mode_MettreNote;
       Begin
           if Voix_Gestion_IsModeAutomatique then
                    Cursor := crCurseurNormal
                else
                    Cursor := crCurseurNormal_VoixFixe;
       End;


    Begin
        private_is_portees_instruments_noms_zone :=
        (Souris_Curseur_X < Composition.Ligne_XGauche(Curseur_Souris.GetiLigne));

        if Is_Portees_Instruments_Noms_Zone then
        Begin
              Cursor := crCurseurSourisSpecial;
              PopupMenu := PopupMenuPortees_Instruments_Noms_Zone;
        End

        
        else if OutilPlus = opSelection then
               Cursor := crCross
               
        else if (Souris_Curseur_X < -16) or IsCurseurDansBandeNomsPorteesDuModeRuban(Souris_Curseur_X) then
            Cursor := crFlecheRetournee
        else
        case MusicUser_MusicWriter_Mode_Get of
             mw_mode_MettreNote:
             Begin
                  if NSC then
                  //pointeur de déplacement de note quand on est sous une note
                  Begin
                          CurseurSouris_Visible_Set(false);
                          if ssCtrl in Shift then
                                Cursor := crDeplacerPlus
                          else
                                Cursor := crDeplacer;
                  End
                  else
                  if PauseSC then
                  Begin
                  //pointeur de déplacement de pause
                        CurseurSouris_Visible_Set(false);
                        Cursor := crDeplacerPause;
                  End
                  else
                        CurseurNormal_Mode_MettreNote;
                  
            End;



             mw_mode_Selection:
                  if OutilPlus = opDeplacer then
                  //on déplace une sélection
                  Begin
                            if ssCtrl in Shift then
                                  Cursor := crDeplacerPlus
                            else
                                  Cursor := crDeplacer;
                  End
                  else
                  if NSC then
                  //pointeur de déplacement de note quand on est sous une note
                  Begin
                          CurseurSouris_Visible_Set(false);
                          if ssCtrl in Shift then
                                Cursor := crDeplacerPlus
                          else
                                Cursor := crDeplacer;
                  End
                  else
                  if PauseSC then
                  Begin
                  //pointeur de déplacement de pause
                        CurseurSouris_Visible_Set(false);
                        Cursor := crDeplacerPause;
                  End
                  else
                        Cursor := crArrow;


             mw_mode_MettreClef:
                   if Outil = MettreClef then
                        Cursor := ClefToCursor(ModeClef_Outil_Clef_ClefSelectionnee)
                    else if Outil = MettreOctavieur then
                        Cursor := OctavieurToCursor(ModeClef_Outil_Octavieur_OctavieurSelectionnee)
                    else
                        MessageErreur('Erreur d''interface : En mode clef, soit on met des clefs, soit on met des octavieurs ! Ca va pas dans MouseMove_CurseurSouris_Traitement');


             mw_mode_MettreNuances:
                    Cursor := crCurseurNormal;




        end;


    End;  //fin MouseMove_CurseurSouris_Traitement








    procedure MouseMove_Curseur_ReglerAlteration_SuivantContexte_SiDeplacement_Calculer;
    var temps_in_mes: TRationnel;
        nh: integer;
        hn: THauteurNote;
        
    Begin
           if Curseur_Entree_WaveIn_IsExcite then exit;
           //if not NSC then Cursor := crNothing;


          {Rappel : ici on est dans MouseMove}
          if not IsPositionsEgales(Curseur.GetPosition, Souris_Curseur_Position) then
          {on ne modifie à jour l'altération courante que si on a bougé}
          Begin
             // RemplirFiltreNoteSouris(FiltreNoteSouris, Curseur.GetTonaliteCourante);

              Curseur.SetPositionGraphique(Souris_Curseur_Position);

              if TonaliteCourante = cTonaliteDeLaMesureCourante then
                   Curseur.SetHauteurNoteAlterationParDefaut;


          End;
      End;



      Procedure MouseMove_modeEcouter_AvecBoutonGauche;
       var m: integer;
           temps: TRationnel;
           Magnetophone_Curseur_Ancien: TMagnetophone_Curseur;
       Begin
           Magnetophone_Curseur_Ancien := Magnetophone_Curseur;

           if Composition.FindMesure(X, Y, m) then
           Begin
                temps := Composition.GetMesure(m).TempsAX(X);
                temps := QDiff(temps, Qel(1));
                Magnetophone_Curseur_Deplacer(m, temps);
                if (MainForm.tmrFinMidiNow.Enabled) and (IsMagnetophoneCurseurmc1Infmc2(Magnetophone_Curseur_Ancien, Magnetophone_Curseur)) then
                     Magnetophone_JouerOrgueDeBarbarie(Magnetophone_Curseur_Ancien, Magnetophone_Curseur)
                else
                     Magnetophone_JouerOrgueDeBarbarieEtReset(Magnetophone_Curseur_Ancien, Magnetophone_Curseur);
                MainForm.tmrFinMidiNow.Enabled := true;
                FaireVoirMesure(m);
           End;

       End;




       Function MouseMove_IsVoixSousCurseur(out voixsouscurseur: integer): Boolean;
       Begin
           result := Composition.GetMesure(MesureCourante).DonnerNumVoixSousCurseur(Xdansmesure, YdansMesure, voixsouscurseur);
       End;



       procedure MouseMove_CurseurSouris_EtatMainSousUnTrucImportant;
       Begin
            Cursor := crHandPoint;
       End;

       procedure MouseMove_CurseurSouris_EtatNormal;
       Begin
            Cursor := crDefault;
       End;

       procedure MouseMove_Voix_Selectionner_Dans_Partition;
            procedure Voix_Selectionner_Dans_Partition_MessageUtilisateur(msg: string);
            Begin

            End;


       var voixsouscurseur: integer;
       Begin
              private_Voix_Selectionner_voixsouscurseur := -1;
              if Composition.FindMesure(X, Y, MesureCourante) then
              Begin
                   Xdansmesure := X;
                   Ydansmesure := Y;
                   if MouseMove_IsVoixSousCurseur(voixsouscurseur) then
                   Begin
                           Voix_Selectionner_Dans_Partition_MessageUtilisateur('Cliquez pour valider la voix !');
                           private_Voix_Selectionner_voixsouscurseur := voixsouscurseur;
                           MouseMove_CurseurSouris_EtatMainSousUnTrucImportant;
                   End
                   else
                   Begin
                           Voix_Selectionner_Dans_Partition_MessageUtilisateur('Placez le curseur sous une voix.');
                           MouseMove_CurseurSouris_EtatNormal;
                   End;

              End
              else
              Begin
                   Voix_Selectionner_Dans_Partition_MessageUtilisateur('Pointez le curseur dans la partition.');
                   MouseMove_CurseurSouris_EtatNormal;
              End;

       End;


Begin
        if tmrFormResizing.Enabled then exit;

        Console_AjouterLigne('Form_Mouse appelé');

        if MusicGraph_Canvas_IsLocked then exit;

        MusicGraph_Canvas_Set(Canvas);
        IGP := Composition;

    //mousemove
    SetCurrentView;
    {on sauvegarde les coordonnées pixels pour pouvoir afficher la bulle d'aide
     au bout endroit}
    Souris_Curseur_ScrX := X;
    Souris_Curseur_ScrY := Y;

    X := GetX(X);
    Y := GetY(Y);

    Souris_Curseur_X := X;
    Souris_Curseur_Y := Y;


    if (OutilPlus <> opDeplacerObjet) and (OutilPlus <> opDeplacerObjet_Point) then
          private_GraphicObjet_indice := Composition.ObjetGraphique_SousCurseur_GetIndice
                                                (Souris_Curseur_X, Souris_Curseur_Y);


    if Voix_Selectionner_IsDansCeMode then
    Begin
           MouseMove_Voix_Selectionner_Dans_Partition;
           exit;
    End;


    {form_mouse}
    if (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) then
    {si l'on est en train de jouer le fichier midi, alors ne rien faire !!!}
    Begin
        if Magnetophone_IsConnectedAndPlaying then
            Cursor := crCurseur_Magnetophone_Lecture
        else
            Cursor := crCurseur_Magnetophone_Pause;

        PopupMenu := PopupMenuLecture;

        {même en mode lecture, on peut faire un zoom sur uniquement une portée}
        if IsGestionPorteeCouranteActivee then
        Begin
            //trouver la position sous le curseur
             LigneCourante := 0;
             Composition.FindMesure(X, Y, MesureCourante);
             GetPosition(Y, Composition, LigneCourante, Souris_Curseur_Position);

            ModifierPorteeCourante(Souris_Curseur_Position.portee);
        End;



        if ssLeft in Shift then
        Begin
            MouseMove_modeEcouter_AvecBoutonGauche;
        End;

        Exit;
    End;





    if Stylet_MouseMove then exit;



    {mousemove}
    if IsModeSelectionMesure then
    Begin
       if ssLeft In Shift then
       Begin
            FaireVoirPoint(x, y);
            if Composition.FindMesure(X, Y, MesureCourante) then
                  ModeSelectionMesureiFin := MesureCourante;

            Mode_Mesures_SetDebFinMes(ModeSelectionMesureiDeb,
                                              ModeSelectionMesureiFin);

            ReaffichageComplet;
       end;
       exit;
    End;



{mousemove}
if IsOutilMettreObjetGraphiqueDemandePoint then
Begin
     if (Outil = MettreCourbe) then
         GraphicObjet_ObjetEnCours_Courbe_Init
     else if (Outil = MettreCrescendo) then 
         GraphicObjet_ObjetEnCours_Crescendo_Init
     else
         GraphicObjet_ObjetEnCours_DeCrescendo_Init;
    
     with GraphicObjet_ObjetEnCours do
     for i := GraphicObjet_ipts to NbPointsADefinir - 1 do
         Begin
               Pts[i].x_indoc := Souris_Curseur_X;
               Pts[i].y_indoc := Souris_Curseur_Y;
         End;

     ReaffichageComplet;
     exit;


End;



{affichage de l'aide==========================================================}


{mousemove}
if not (ssLeft in Shift) then
Begin

     PauseSC := Composition.PauseSousCurseur(X, Y, ElSC);
     NSC := Composition.NoteSousCurseur(X, Y, ElSC, NoteSousCurseur);
     BarreDeMesureSousCurseur_iMesure := Composition.GetBarreDeMesureSousXY_iMesure(X, Y);

     QSC := false; //Composition.QueueSousCurseur(X, Y, ElSC); //à gérer un jour


     private_is_element_exactement_sous_curseur := false;
     private_is_element_selectionnee_sous_curseur := false;

     if PauseSC then
     Begin
           private_is_element_exactement_sous_curseur := true;
           if ElSC.IsSelectionne then
               private_is_element_selectionnee_sous_curseur := true;
     End;

                
      if (Outil = MettreAlteration) then
      Begin
             if NSC then
                   Aide_AfficherDansChildWin('altérationnote',Souris_Curseur_ScrX,Souris_Curseur_ScrY,32)
             else
                   Aide_Afficher('altération',0,0,0)
      End
      {else if Outil = MettreParoles then
           Aide_Afficher('Paroles')   }
      else if NSC and not (ssLeft in Shift) then
      Begin
             {on se trouve sous une note...}

             {si elle est sélectionnée, on informe le moteur que l'on se trouve sous
              qch de sélectionné}

             private_is_element_exactement_sous_curseur := true;

             if NoteSousCurseur^.Selectionne <> svDeselectionnee then
                     private_is_element_selectionnee_sous_curseur := true;

             Aide_Params_Ajouter(HauteurNoteToStr(NoteSousCurseur.HauteurNote));
             Aide_Params_Ajouter(ElMusicalToStrQuiFaitPartiDe(ElSC));
             Aide_AfficherDansChildWin('Deplace1',Souris_Curseur_ScrX,Souris_Curseur_ScrY,0)
      End
      else
             Aide_Cacher_Apriori;

      if ESC or NSC then
          PopupMenu := PopupMenuSelection
      else
          PopupMenu := PopupMenuCurseur;

      
End;





       MouseMove_CurseurSouris_AspectGraphique_Traitement;





{mousemove}
if ssLeft in Shift then
{si le bouton gauche est enfoncé quand on bouge (MouseMove) la souris}
Begin
     if (OutilPlus = opDeplacerObjet_Point) and Is_GraphicObjet_SousCurseur then
      With GraphicObjet_SousCurseur_Get do
      Begin
          With pts[GraphicObjet_PointSousCurseur_Indice_Get] do
          Begin
              x_indoc := Souris_Curseur_X;
              y_indoc := Souris_Curseur_Y;
          End;

          PosInPartition_CalculerMesuresTempsEtc(Composition);
          ReaffichageComplet;
          exit;
      end
      else
     if (OutilPlus = opDeplacerObjet) and Is_GraphicObjet_SousCurseur then
      {on vérifie qd ^m "IsAGraphicObjetSelectionne" au cas où l'objet a
           disparu par appui sur suppr en cours d'appui du bouton gauche}

      With GraphicObjet_SousCurseur_Get do
      Begin
          Translater(Souris_Curseur_X - Souris_Curseur_Ancien_X,
                     Souris_Curseur_Y - Souris_Curseur_Ancien_Y);

          Souris_Curseur_Ancien_X := Souris_Curseur_X;
          Souris_Curseur_Ancien_Y := Souris_Curseur_Y;
          //pts[0].y_indoc := Souris_Curseur_Y - Souris_Curseur_Ancien_Y;

          PosInPartition_CalculerMesuresTempsEtc(Composition);
          ReaffichageComplet;
          exit;
      end
      else

    {mousemove}  
    if OutilPlus = opDeplacer then
    {gère le déplacement de notes}
    Begin
         if Composition.FindMesurePourModif2(x, y, LigneCourante, MesureCourante) then
         Begin
         { if LigneCourante = -1 then
              ShowMessage('blabla');   }
             if Composition.IsIndiceMesureValide(MesureCourante) then
                 DeplaceAuTemps := Composition.GetMesure(MesureCourante).TempsAX(x)
             else DeplaceAuTemps := Qel(1);

             if NoteRefDeplacementMesure = indMesureQuiDitPasDeDeplacementAutrePart then
                 DeplacerAutrePart := false
             else if MesureCourante <> NoteRefDeplacementMesure then
                DeplacerAutrePart := true
             else {ici, m est forcément l'indice d'une mesure existante vu
                           qu'il est égal à NoteRefDeplacementMesure}
                DeplacerAutrePart := not
                   IsQEgal(DeplaceAuTemps, NoteRefDeplacementTemps);



             DeplaceVersMesure := MesureCourante;

             if DeplacerAutrePart then
             Begin
                  IntervalleDeplacement_Init;
                  DiffPorteeDeplacement := 0;

             End
             else
                 MettreAJourAffNoteDeplacementSouris(X, Y, MesureCourante, true);

             FormPaint(nil);
             Exit;
         End
         else
             DeplaceVersMesure := -1;
             {par convention, DeplaceVersMesure = -1 signifie que le curseur
              est n'importe où}
    End
    else if OutilPlus = opDeplacerPause then
    Begin
         Silences_Deplacer_HauteurDeplace := (Souris_Curseur_MouseDown_Y - Y) div nbpixlign;
         FormPaint(nil);
         Exit;
    end
    Else if IsModeSelectionPossible(Shift) then//Peut-être une sélection rectangulaire ??
    Begin

            SelectionRect.Right := X;
            SelectionRect.Bottom := Y;

            FaireVoirPoint(X,Y);
            if Norme1(X, Y, SelectionRect.Left, SelectionRect.Top) > seuilTailleRectSelection then
            //si on a bougé assez, c'est qu'on est en train de sélectionner
            Begin
                 OutilPlus := opSelection;
                 //Aide_Afficher('sélectionencours')
            End;

            if OutilPlus = opSelection then
            {on bouge la souris en maintenant le bouton enfoncé et le
             mode sélection est déjà enclenché}
            Begin
                 if Voix_Gestion_IsModeAutomatique then
                 //on sélectionne dans toutes les voix en même temps
                        Composition.Selection_Selectionner(SelectionRect, VOIX_TOUTES_LES_VOIX)
                 else
                 //on ne sélectionne que dans la voix courante
                        Composition.Selection_Selectionner(SelectionRect, Curseur.GetiVoixSelectionnee);



                 Console_AjouterLigne('sélection qui se trouve entre la mesure n°' +
                       inttostr(Composition.Selection_Getimesdebutselection) + ' et '
                       + inttostr(Composition.Selection_Getimesfinselection));
                       
                 actchildDerniereSelection := self;
                 FormPaint(nil);
                 Exit;
            end;
            {si l'on est là, c'est qu'en fait, on n'est pas en train de
            sélectionner (écart de souris trop petit)}
   End;





End;

{quand on bouge la souris, on est met à jour les variables LigneCourante,
  MesureCourante, qui représentent la position du curseur souris}
{mousemove}
      AncienneMesureCourante := MesureCourante;
      AncienneLigneCourante := LigneCourante;

      yab := Composition.FindMesure2(X, Y, LigneCourante, MesureCourante);
      Souris_Curseur_Xdansmesure := X;
      Souris_Curseur_Ydansmesure := Y;

      if IsCurseurDansBandeNomsPorteesDuModeRuban(Souris_Curseur_X) then
      Begin
          yab := false;
          MesureCourante := -1;

      End;


      if MouseMove_RegleTemps_Gerer then
           exit;


           
   Composition.Octavieurs_SousCurseur(Souris_Curseur_X, Souris_Curseur_Y,
                                       private_octavieur_iportee,
                                       private_octavieur_indice);


private_clef_debut_iportee := -1;


{mousemove}
If LigneCourante > -1 then
Begin
     GetPosition(Souris_Curseur_Ydansmesure, Composition, LigneCourante, Souris_Curseur_Position);


     private_clef_inseree_iportee := Souris_Curseur_Position.portee;
     private_clef_inseree_imesure := MesureCourante;

     if Composition.IsIndiceMesureValide(MesureCourante) then
            private_clef_inseree_indice := Composition.GetMesure(MesureCourante)
                                        .Clefs_GetIndice(Souris_Curseur_Xdansmesure,
                                                         private_clef_inseree_iportee)
     else
           ClefInseree_SousCurseur_DireQueYenAPas;

End;


{mousemove}
if yab then
     If (MesureCourante = 0) and (x < 0) then
     Begin
     {si on est au tout début de la première ligne, le curseur sous une clef,
       alors un clic droit propose de changer de clef}
          private_clef_debut_iportee := Souris_Curseur_Position.portee;
          CurseurSouris_Visible_Set(false);
          Aide_AfficherDansChildWin('clef',Souris_Curseur_ScrX,Souris_Curseur_ScrY,0);
          OutilPlus := opRien;
          Cursor := crCurseurSourisSpecial;
          PopupMenu := PopupMenuClef;
     End
     else if ClefInseree_Is_SousCurseur then
     Begin
          Cursor := crCurseurSourisSpecial;
          PopupMenu := PopupMenuClefInseree;
     End
     else if Is_GraphicObjet_SousCurseur then
     Begin
          Cursor := crCurseurSourisSpecial;

          With GraphicObjet_SousCurseur_Get do
          Begin
              if IsNuanceSimple then
                   PopupMenu := PopupMenuNuances
              else if IsCrescendoOrDecrescendo then
                   PopupMenu := PopupMenuCrescendo
              else
                   PopupMenu := PopupMenuPhrase;
          End;

     End
     else if Is_Octavieur_SousCurseur then
     Begin
          Cursor := crCurseurSourisSpecial;
          PopupMenu := PopupMenuOctavieur;
     End
     else if IsBarreDeMesureSousCurseur then
     Begin
           Cursor := crCurseurSourisSpecial;
           PopupMenu := PopupBarreDeMesure;

           if BarreDeMesureSousCurseur_iMesure = Composition.NbMesures then
                  Aide_AfficherDansChildWin('barre_de_mesure_fin',Souris_Curseur_ScrX,Souris_Curseur_ScrY,0)
           else
           Begin
               Aide_Params_Ajouter(inttostr(BarreDeMesureSousCurseur_iMesure));
               Aide_Params_Ajouter(inttostr(BarreDeMesureSousCurseur_iMesure + 1));
               Aide_AfficherDansChildWin('barre_de_mesure',Souris_Curseur_ScrX,Souris_Curseur_ScrY,0);
           End;
           
     End
     else if Is_TonaliteSousCurseur or Is_TonaliteAvantBarreDeMesureSousCurseur then
     Begin
         CurseurSouris_Visible_Set(false);
         Aide_AfficherDansChildWin('tonalité',Souris_Curseur_ScrX,Souris_Curseur_ScrY,0);
         Cursor := crCurseurSourisSpecial;
         PopupMenu := PopupMenuRythmeEtTonalite;

     end
     {mousemove}
     else if Is_RythmeSousCurseur then
     Begin
         CurseurSouris_Visible_Set(false);
         Aide_Params_Ajouter(QToStr(Composition.GetMesure(MesureCourante).Rythme));
         Aide_AfficherDansChildWin('rythme',Souris_Curseur_ScrX,Souris_Curseur_ScrY,0);
         Cursor := crCurseurSourisSpecial;
         PopupMenu := PopupMenuRythmeEtTonalite;

     End
     else
     Begin
           if Is_el_mus_Pause_PourPortees_Sous_Curseur then
           Begin
                  Aide_Params_Ajouter(inttostr(Curseur_Souris.GetiMesure + 1));
                  Aide_Params_Ajouter(inttostr(Curseur_Souris.GetiPortee + 1));
                  Aide_AfficherDansChildWin('el_mus_Pause_PourPortee_Vide',Souris_Curseur_ScrX,Souris_Curseur_ScrY,0);
           End;
          OutilPlus := opRien;

     End;








{stade expérimental}

if IsGestionPorteeCouranteActivee and (LigneCourante > -1) then
Begin
        ModifierPorteeCourante(Souris_Curseur_Position.portee);
        GetPosition(Y, Composition, LigneCourante, Souris_Curseur_Position);
End;







{mousemove}
if (OutilPlus = opRien) and
   (MusicUser_MusicWriter_Mode_Get = mw_mode_MettreNote) and
    Outil_MettreNoteIsModeSouris and
       (yab or (MesureCourante >= Composition.NbMesures)) then
Begin
    MouseMove_Curseur_ReglerAlteration_SuivantContexte_SiDeplacement_Calculer;
    CurseurSouris_Visible_Set(true);
end
else
    CurseurSouris_Visible_Set(false);



{mousemove}
{calcul du numéro de voix ===================================================}
{mode automatique = ...}
if Outil_MettreNoteIsModeSouris and (Outil <> MettreParoles) then
Begin
    {calcul de la voix automatique}
    VoixSelectionnee_DetecterPuisChanger(MesureCourante,
                                         Souris_Curseur_Xdansmesure,
                                         Souris_Curseur_Position);
    {ici, il se peut qu'il y ait un affichage, on s'assure que :
        Souris_Curseur_Xdansmesure,
        Souris_Curseur_Position,
        IntervalleDeplacement etc. sont à jour}

End;



if (OutilPlus = opRien) and (Outil = MettreNote) and
       (yab or (MesureCourante >= Composition.NbMesures)) then
Begin
       //if not NSC then Cursor := crNothing;

       {calcul les pauses à mettre}

       MouseMove_CalculerPausesGloutonsAMettre;
       {nécessite que le num de voix courant soit à jour}

End;



if yab or (MesureCourante >= Composition.NbMesures) then
     MouseMove_CalculerIndiceElMusicalCourant;









{mousemove}

MouseMove_StatusBar_Traiter;


{mousemove}
if yab or (MesureCourante >= Composition.NbMesures) then
Begin
    Curseur_Souris.DA_SetAvecXMesure(Curseur.GetiVoixSelectionnee,
                          MesureCourante,
                          Souris_Curseur_Xdansmesure,
                          Souris_Curseur_Position);

    if (Outil <> PlacerCurseur) and (Outil <> MettreParoles) and Outil_MettreNoteIsModeSouris then
{on met à jour les données du curseur souris vers le curseur "standard" clavier}
      Curseur.DA_SetAvecXMesure(Curseur.GetiVoixSelectionnee,
                          MesureCourante,
                          Souris_Curseur_Xdansmesure,
                          Souris_Curseur_Position);
End;



If yab then
Begin
      ElSC := nil;

      if MusicUser_MusicWriter_Mode_Get = mw_mode_MettreNote then
      if Composition.GetMesure(MesureCourante).VoixNum(Curseur.GetiVoixSelectionnee).FindElMusicalApres(X, i) then
               {si on se trouve sur un élément musical, on le dessine
                    avec un liserai rouge autour de lui}
                Begin
                      ElSC := Composition.GetMesure(MesureCourante).VoixNum(Curseur.GetiVoixSelectionnee).ElMusicaux[i];
                      if not NSC and not Composition.GetMesure(MesureCourante).VoixNum(Curseur.GetiVoixSelectionnee).ElMusicaux[i].IsSilence then
                           Cursor := CurseursSouris_AddNote_Curseur_Get;

                End
                else
                    ElSC := nil;

      if Outil_MettreNoteIsModeSouris then
          Curseur.DR_ElementMusical_AllerDessusOuPas(ElSC <> nil);

      Curseur_Souris.DR_ElementMusical_AllerDessusOuPasSansChangerX(ElSC <> nil);

end;
      Aide_Boucle;
      
      FormPaint(nil);

end; {mousemove}

















Function TMDIChild.IsModeSelectionMesure: Boolean;
Begin
   result := (MusicUser_MusicWriter_Mode_Get = mw_mode_Mesure);

End;


procedure TMDIChild.FormCreate(Sender: TObject);

          procedure PopupMenu_Regler_Images;
          var lst: TImageList;
          Begin
             lst := MainForm.imgList;

             PopupMenuPortees_Instruments_Noms_Zone.Images := lst;

             PopupMenuSelection.Images := lst;
             PopupMenuCurseur.Images := lst;
             PopupMenuClefInseree.Images := lst;
             PopupMenuClef.Images := lst;
             PopupMenuInstruments_Portees.Images := MainForm.imgIconesInstruments;
             PopupMenuRythmeEtTonalite.Images := lst;
             pupMenuMettreBarreMesures.Images := lst;

             PopupMenuPhrase.IMages := lst;
             PopupMenuNuances.Images := lst;
             PopupMenuCrescendo.Images := lst;

             PopupMenuLecture.Images := lst;

             PopupBarreDeMesure.Images := MainForm.imgBarres;

             mnuMenuTonalite_DuMenuClef.SubMenuImages := MainForm.imgDiesesEtBemols;
             mnuMenuTonalite_DuMenuRythmesEtTonalites.SubMenuImages := MainForm.imgDiesesEtBemols;
             mnuBarreDeMesure_Tonalites_grp.SubMenuImages := MainForm.imgDiesesEtBemols;

             ToolBarVue.Images := lst;

          End;




          procedure InitBlitRects;
          Begin
                BlitRectsAvant := TRectList.Create;
                BlitRectsApres := TRectList.Create;

                BlitRectsAvant.ViderNextBlitRects;
                BlitRectsAvant.AjouterNextBlitRect(ClientRect);

                BlitRectsApres.ViderNextBlitRects;
                BlitRectsApres.AjouterNextBlitRect(ClientRect);
          End;


          procedure View_Init;
          var i :integer;

          Begin
                  View.Zoom := ZoomParDefaut;
                  for i := 0 to MaxIndVoix do
                  Begin
                        View.VoixAffichee[i] := true;
                        View.VoixEntendue[i] := true;

                        View.PorteeAffichee[i] := true;
                        View.PorteeEntendue[i] := true;
                  End;

                  Portees_Actives_Toutes;

          End;


          procedure ScrAndBuffer_Init;
          Begin
                VerouillerLeReaffichage := false;
                if ToutDessinerDansBitmapScrDabord then
                    Scr_Init
                else
                    Scr := nil;

                BackBuffer := TBitmap.Create;
                BackBuffer.Canvas.Font.Name := 'Arial';
          End;


          procedure MettreCourbe_Init;
          Begin
                GraphicObjet_ObjetEnCours_Nouveau_Creer;
                GraphicObjet_ObjetEnCours.typ := tgCourbe;
          End;





          Procedure InitImagesDaidesDesMenus;
              Procedure MenuItemAvecImage(menuitem: TMenuItem; nom_fichier_image: string);
              Begin
                 menuitem.OnDrawItem := Multiplierlesdurespar21DrawItem;
                 menuitem.OnMeasureItem := Multiplierlesdurespar21MeasureItem;

                 menuitem.Bitmap := BMPTransparentLoadFromFile('interface_images\menus\' + nom_fichier_image);
              End;



              
          Begin
            MenuItemAvecImage(Multiplierlesdurespar21, 'Menu_MultiplierDureeParDeux.bmp');
            MenuItemAvecImage(Diviserlesdurespar21, 'Menu_DiviserDureeParDeux.bmp');

            MenuItemAvecImage(mnuI_Selection_FusionnerNotesEtSilences,
                                 'Menu_AlongerNotes.bmp');


            MenuItemAvecImage(mnuI_Selection_DureesDiviserParDeuxPuisSilence,
                                'Menu_DiviserDureeParDeuxEtMettrePauses.bmp');


            MenuItemAvecImage(Fusionner1,
                              'Menu_Fusionner.bmp'
                              );

            MenuItemAvecImage(Fusionner1,
                              'Menu_Fusionner.bmp'
                              );

            MenuItemAvecImage(Enfairepleinpareil1,
                              'Menu_Fusionner_enfairepareil.bmp'
                              );
            MenuItemAvecImage(ArpegerVerslehaut1,
                              'Menu_arpeger_haut.bmp'
                              );
            MenuItemAvecImage(ArpegerVerslebas1,
                              'Menu_arpeger_bas.bmp'
                              );
            MenuItemAvecImage(Duneoctaveverslehaut2,
                              'Menu_Octavier_haut.bmp'
                              );
            MenuItemAvecImage(Duneoctaveverslebas2,
                              'Menu_Octavier_bas.bmp'
                              );
            MenuItemAvecImage(Duneoctaveverslebas1,
                              'Menu_deplacer_bas.bmp'
                              );
            MenuItemAvecImage(Duneoctaveverslehaut1,
                              'Menu_deplacer_haut.bmp'
                              );
            {
            MenuItemAvecImage(Enfairepleinpareil1,
                              ''
                              );
                              }
          End;

begin
      Langues_TraduireFenetre(self);
      private_Magnetophone_Curseur_Excitation := 0;
      private_VScrollBarChange_IgnorerEvenement := false;
      SelectionRect := Rect(0, 0, 0, 0);
      
      ElSC := nil;
      BarreDeMesureSousCurseur_iMesure := -1;
      AffichageClignotant_Indice := 0;
      
      {préparation de gestion de courbes}
      MettreCourbe_Init;

      View_Init;
      ScrAndBuffer_Init;

      pixxdeb := 0;

      RedessinerTout := true;
      FormResize(nil);

      InitBlitRects;
      InitImagesDaidesDesMenus;

      CurseurClavier_Clignotant_VisibleEnCemoment := true;

      private_GraphicObjet_indice := -1;
      private_clef_debut_iportee := -1;
      private_clef_inseree_imesure := -1;
      ClefInseree_SousCurseur_DireQueYenAPas;
      private_octavieur_indice := -1;
      private_rythme_tonalite_imesure_apartirde := -1;

      Navigateur.DoubleBuffered := true;
      Navigateur.Visible := option_NavigateurAfficher;

      Souris_Curseur_Xdansmesure := -10;
      {pour que ça n'affiche pas de cercle vert n'importe où}


      Magnetophone_Prevenir_l_ouverture_d_une_fenetre;

      PopupMenu_Regler_Images;
      IntervalleDeplacement_Init;
end;






procedure TMDIChild.FormResize(Sender: TObject);
var topvscr, bottomy: integer;

begin
    tmrFormResizing.Enabled := true;
    if ToutDessinerDansBitmapScrDabord then
        if Scr <> nil then
        Begin
              Scr.Width := ClientWidth;
              Scr.Height := ClientHeight;
        end;

    if BackBuffer <> nil then
    Begin
          BackBuffer.Width := ClientWidth;
          BackBuffer.Height := ClientHeight;
    end;

    //if Navigateur.Visible = false then
         topvscr := 0 ;
    //else
    //     topvscr := Navigateur.Height;

    if Navigateur.Visible then
        bottomy := ClientHeight - 16
    else
         bottomy := ClientHeight;
    
    VScrollBar.SetBounds(ClientWidth - 16, topvscr,
                         16, bottomy - 16 - topvscr);
    {HScrollBar}
    HScrollBar.SetBounds(panStatusBar.Left + panStatusBar.Width, bottomy - 16,
                         ClientWidth - panStatusBar.Width - panStatusBar.Left - CoinDroitBas.Width, 16);

    CoinDroitBas.SetBounds(ClientWidth - 16, bottomy - 16,16,16);
    panStatusBar.Top := bottomy - panStatusBar.Height;
    panInstruments_Portees.Top := bottomy - panInstruments_Portees.Height;
    RedessinerTout := true;

    if Composition <> nil then
         FormPaint(nil);
end;



procedure TMDIChild.FaireLaPaginationEtLesCalculsPuisAffichageComplet(apartirdelamesure: integer;
                                                            jusquamesure: integer;
                                                            afficheraussi: boolean);
Begin

    SetView(View);
    IGP := Composition;
    IGiLigne := 0;
    Composition.PaginerLesMesuresEtApresSiBesoin(apartirdelamesure, jusquamesure, true);


    if IsGestionPorteeCouranteActivee then
    Begin
           IGP := Composition;
           IGiLigne := 0;
           SetMusicWriterAffiche;
           {oui, on dit qu'on affiche car par ex, les pixy des portées
               sont vraiment celles affichées...

              si on exécute pas "SetMusicWriterAffiche" avant
              "CalcPorteesPixy", alors le calcul sera incorrect
              car tous les ZoomPortees sont faux... et pouf... ça clignote
              à l'écran, et ça fait n'imp au point que l'édition devient
              difficile
              bug résolu le 31 octobre 2005 à 23:58
               }

           Composition.CalcPorteesPixy(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN);
           Composition.CalcQueue(0, 0);
    End;

    Composition.RendreIndiceLigneValide(AncienneLigneCourante);
    Composition.RendreIndiceLigneValide(LigneCourante);


    if afficheraussi then
          ReaffichageComplet;
End;




procedure TMDIChild.I_Coller(PressePapier: TMesure);
var temps: TDuree;
    oncolle: Boolean;
    dp: integer;
    iv: integer;
    
Begin
     if PressePapier.IsVide then
         Message_Vite_Fait_Beep_Et_Afficher('Impossible de coller : le presse-papier est vide ! Il faut d''abord copier ou couper quelquechose !')
     else
     Begin
         CurseurSouris_Busy_Begin;
         With Curseur do
         Begin
             oncolle := true;
             temps := GetTempsDepuisDebutMesure;

             if high(PressePapier.Voix) = 0 then
             {si le presse-papier ne contient qu'une voix, le traitement de collage
              est différent :}
             Begin
             {le collage peut s'effectuer :}
                 With PressePapier.Voix[0] do
                        TranslationPortee(Getposition.portee - PorteeApprox);

                 oncolle := Composition.EstCompatibleAvecLesPortees(PressePapier.Voix[0]);
                 {- dans une autre portée (l'interface donne ce numéro de portée dans
                    position.portee}

                 PressePapier.Voix[0].N_Voix := GetiVoixSelectionnee;
                 {- dans une autre voix (c'est pourquoi on renomme la voix du presse-
                    papier en VoixSelectionnee avant collage}

             End
             else
             Begin
                  dp := Getposition.portee - PressePapier.GetPortee_Utile_Min_iPortee;

                  IGP := Composition;
                  for iv := 0 to high(PressePapier.Voix) do
                  With PressePapier.Voix[iv] do
                  Begin
                       TranslationPortee(dp);
                       Set_N_Voix(Get_N_Voix_Portee + dp, Get_N_Voix_NumVoix_Dans_Portee);
                       oncolle := oncolle and Composition.EstCompatibleAvecLesPortees(PressePapier.Voix[iv]);
                  End;



             End;

             {on colle effectivement}
             if oncolle then
             Begin
                Composition.Selection_ToutDeselectionner;

                if GetiMesure >= Composition.NbMesures then
                Begin
                   Composition.Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, GetiMesure);
                   Composition.AddMesureFin;
                End;

                   Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, GetiMesure);


                Composition.Coller(PressePapier, GetiMesure, temps);


                Composition.Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(GetiMesure);
                //actchild.Composition.imesdebutselection := iMesure;

                 MettreBarreMesures_RegarderSiBesoin(GetiMesure);

                 {on étale le collage sur éventuellement plusieurs mesures}
                { if actchild.Composition.GetMesure(iMesure).MesureQuiDeborde then
                 with frmChoix do
                 Begin
                     Reset;
                     SetBlabla('Coller le contenu du presse-papier...');
                     AjouterChoix('...en répartissant sur plusieurs mesures');
                     AjouterChoix('...en répartissant sur plusieurs mesures, sans empiéter sur la suite');
                     AjouterChoix('...en mettant tout dans cette même mesure');
                     comportement := AfficherChoix;
                 End;



           //      actchild.Composition.imesfinselection :=
                 actchild.Composition.DeclarerMesureCommeContenantDesChosesSelectionnees(
                   actchild.Composition.MettreBarresMesures(iMesure, comportement)); }

                 Composition.Selection_VerifierSelectionValide;


             {calcul de l'affichage}

             FaireLaPaginationEtLesCalculsPuisAffichageComplet(GetiMesure, GetiMesure,
                                                               true);
                                
             I_Selection_MettreAJourInfo;
             Composition.Cancellation_Etape_Ajouter_FinDescription('coller ',
                                  'dans la mes. n°' + inttostr(GetiMesure + 1) + ' au temps ' + QToStr(temps),
                                  VOIX_PAS_D_INFORMATION);
           End
           else
           Begin
                Aide_MessageInformation_Afficher('info_coller_pb_portees');
                beep;
           End;
        end;
        CurseurSouris_Busy_End;
     End;
End;










procedure TMDIChild.CurseurSouris_RecalculerPositionAPartirDeLaPositionCurseurInterne;
Begin
    SetCurrentView;

    Curseur.CalculerXY_CurseurClavier;
    
    With  Curseur.GetPoint_Pix_in_Document do
    Begin
          Souris_Curseur_X := X;
          Souris_Curseur_Y := Y;
    End;

    FormPaint(nil);

End;





procedure TMDIChild.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var
    yab: Boolean;
    chgportee: Boolean;




    
    Procedure CurseurSouris_DeplacerLegerementADroite;
    {déplacer le curseur de la souris légèrement à droite
                                 (pour le confort d'utilisation}
    var ptcur: TPoint;
    Begin
        if CurseurDeplaceApresMiseDeNote then
          Begin
              With  Curseur.GetPoint_Pix_in_Document do
                     ptcur := ScrPoint(X, Y);

              SetCurrentView;


              inc(ptcur.x, ClientOrigin.x);
              inc(ptcur.y, ClientOrigin.y);


              SetCursorPos(ptcur.X, ptcur.y);
              //SetCursorPos(ptcur.x + CurseurSouris_Deplace_NbPixelX, ptcur.y);
          End;
    end;



    {===========================}
    procedure MouseUp_Stylet_Traitement;
    Begin
          OutilPlus := opRien;

          if MusicStylet_Traiter(Composition, Curseur.GetiVoixSelectionnee) then
              ReaffichageComplet
          else
              Message_Vite_Fait_Beep_Et_Afficher('Vous avez voulu dessiner quelque chose au stylet ! Mais je n''ai rien à compris à ce que t''as dessiné ! PS : Pour copier-coller bouge un peu moins la souris.');

          MusicStylet_Points_Reset;
    End;


    {===========================}
    procedure MouseUp_SelectionRectangulaire_Traitement;
    {l'utilisateur a levé le bouton de la souris après avoir tracé un
      rectangle de sélection}
    Begin


            {met la sélection sur 1}
            Composition.Selection_Valider;
            I_Selection_MettreAJourInfo;
            if Composition.Selection_YaUneSelection then
                 MusicUser_MusicWriter_ModeSelectionActive_ViteFait;



            ReaffichageComplet;
            OutilPlus := opRien;
    End;



    {===========================}
    procedure MouseUp_Deplacement_Traitement;
    var temps: TRationnel;
        m: integer;
        Selection_Getimesdebutselection_ancien,
        Selection_Getimesfinselection_ancien: integer;
    
    Begin
          if (not DeplacerAutrePart) and IntervalleDeplacement_IsNothingToDo then
          {cas où on ne fait rien : on évite de faire qch pour ne pas empiler
           une annulation etc.}
                 Exit;


          Composition.Cancellation_Etape_Ajouter_Selection('déplacement de notes');

          {déplace les notes... mouseup}
          if (not DeplacerAutrePart) then
          MettreAJourNotesADeplacees({est-ce qu'on recopie ?}
                                     (ssCtrl in Shift) and not DeplacerAutrePart,
                                     {est-ce que les altérations sont dûes à la tonalité courante ?}
                                      ssShift in Shift,
                                      {est-ce qu'on calcule manuellement les positions sur la tablature ?}
                                      Deplacement_IsSurTablature);

          with Composition do
          Begin
              if DeplacerAutrePart then
              {on déplace les notes "horizontalement"}
              Begin
                  if DeplaceVersMesure = -1 then
                       Message_Vite_Fait_Beep_Et_Afficher('Aucun déplacement n''a été effectué... ' +
                       'car tu as déposé les notes sélectionnées n''importe où !')
                  else
                  Begin
                        Selection_Getimesdebutselection_ancien := Composition.Selection_GetIMesDebutSelection;
                        Selection_Getimesfinselection_ancien := Composition.Selection_GetIMesFinSelection;
                        PressePapier.Free;
                        PressePapier := TMesure.Create;
                        Composition.Selection_CopieToPressePapier(PressePapier);

                        PressePapier.SelectionnerTout;


                        Composition.FindMesurePourModif(x, y, m);

                        temps := Composition.prtgMesures(m).TempsAX(x);

                        {on déplace ou on recopie (ça dépend) dans la mesure m, au
                         temps temps}
                        Composition.Coller(PressePapier, m, temps);

                        if not (ssCtrl in Shift) then
                               Composition.Selection_Supprimer;

                        {on sélectionne correctement les éléments qui viennent d'être
                         déplacé dans la mesure m}
                         GetMesure(m).Selection_Valider;

                        CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
                         
                        Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(m);
                   end;


              End;

              ElSC := nil;
              OutilPlus := opRien;

              Composition.PaginerLesMesuresEtApresSiBesoin(Selection_Getimesdebutselection_ancien, Selection_Getimesfinselection_ancien,
                                                           true);
              FaireLaPaginationEtLesCalculsPuisAffichageComplet(Selection_Getimesdebutselection,
                                                                Selection_Getimesfinselection,
                                                                true);

          End;
    End;


    {===========================}
    procedure MouseUp_DeplacementPauses_Traitement;
    Begin
        with Composition do
          Begin
              Selection_DeplacerPauses(Silences_Deplacer_HauteurDeplace);
              OutilPlus := opRien;
              FaireLaPaginationEtLesCalculsPuisAffichageComplet(Selection_Getimesdebutselection,
                                                                Selection_Getimesfinselection,
                                                                true);
          End;
    End;


    {===========================}
    Procedure MouseUp_CopierColler_AlaUnix_Traitement;
    var BoutonMilieu_PressePapier: TMesure;
        num_voix: integer;

          procedure CopierColler_AlaUnix_Message_ViteFait_Erreur;
          Begin
              Message_Vite_Fait_Beep_Et_Afficher('Vous avez certainement voulu copier-coller la sélection courante. Or il n''y a pas de sélection courante.');
          End;

    Begin

            if Voix_Gestion_IsModeAutomatique then
            Begin
                 if Composition.IsIndiceMesureValide(MesureCourante) then
                 Begin
                     Composition.GetMesure(MesureCourante).DonnerNumVoixPresCurseur(
                                        X, Souris_Curseur_Position, num_voix);
                     Curseur.DR_Voix_Changer(num_voix);
                 End
                 else
                 Begin
                     if View.VoixAffichee[Souris_Curseur_Position.portee] then
                          VoixSelectionnee_Changer(Souris_Curseur_Position.portee);
                 End;
            End;


            Curseur.DA_SetAvecXMesure(Curseur.GetiVoixSelectionnee,
                                     MesureCourante,
                                     X,
                                     Souris_Curseur_Position);

            if actchildDerniereSelection <> nil then
            Begin
                if not actchildDerniereSelection.Composition.Selection_IsToutDeselectionner then
                Begin
                    BoutonMilieu_PressePapier := TMesure.Create;
                    actchildDerniereSelection.Composition.Selection_CopieToPressePapier(BoutonMilieu_PressePapier);

                    I_Coller(BoutonMilieu_PressePapier);
                    BoutonMilieu_PressePapier.Free;
                End
                else if option_CopierColler_AlaUnix_Utiliser_La_Fonctionnalite then
                    CopierColler_AlaUnix_Message_ViteFait_Erreur;
            End
            else if option_CopierColler_AlaUnix_Utiliser_La_Fonctionnalite then
                    CopierColler_AlaUnix_Message_ViteFait_Erreur
    End;



    {===========================}
    procedure MouseUp_MettreNuance_Traitement;
    var GO: TGraphicObjet;
    
    Begin
       IGP := Composition;
       GO := TGraphicObjet.NuanceCreate(Souris_Curseur_X, Souris_Curseur_Y, NuanceCourante);

       Composition.ObjetGraphique_Ajouter(GO);

       MusicUser_MusicWriter_Mode_RevenirAuPrecedent;

       ReaffichageComplet;


    End;


    {===========================}
    procedure MouseUp_MettreObjetGraphic_Traitement;
    Begin
           inc(GraphicObjet_iPts);
           if GraphicObjet_ipts = GraphicObjet_ObjetEnCours.NbPointsADefinir then
           Begin
                 Composition.ObjetGraphique_Ajouter(GraphicObjet_ObjetEnCours);
                 GraphicObjet_ObjetEnCours_Nouveau_Creer;
                 MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
                 ReaffichageComplet;
           End;

    End;



    {===========================}
    procedure MouseUp_MettreClef_Traitement;
    var tempsssx: TRationnel;
    
    Begin
          if yab then
          Begin

                 if not Composition.IsIndiceMesureValide(MesureCourante) then
                 Begin
                       Message_Vite_Fait_Beep_Et_Afficher(Langues_Traduire('On ne peut pas insérer de clef ici... on est en dehors de la partition.'));
                       Exit;
                 End;

                 Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, MesureCourante);
                 Composition.Cancellation_Etape_Ajouter_FinDescription('insertion d''une clé : '
                                           + ClefToStr(ModeClef_Outil_Clef_ClefSelectionnee),
                                            'mesure n° ' + inttostr(MesureCourante + 1),
                                            VOIX_PAS_D_INFORMATION);

                 
                 If (MesureCourante = 0) and (x < 0) then
                         Composition.I_Portee_Clef[Souris_Curseur_Position.portee] := ModeClef_Outil_Clef_ClefSelectionnee
                 else
                 Begin
                       tempsssx := Composition.GetMesure(MesureCourante).TempsAX(X);
                         if Composition.Clefs_DetecterAvecrelX(Souris_Curseur_Position.portee,MesureCourante, X)
                                                               = ModeClef_Outil_Clef_ClefSelectionnee then
                         Begin
                            if Composition.GetMesure(MesureCourante).Clefs_Del(Souris_Curseur_Position.portee, tempsssx) then
                                  Message_Vite_Fait_Beep_Et_Afficher('On a supprimé la clef sous le curseur.')
                            else

                                  Message_Vite_Fait_Beep_Et_Afficher('On ne fait rien car insérer cette clef est complétement débile !');

                         end
                         else
                              Composition.GetMesure(MesureCourante).Clefs_Add(ModeClef_Outil_Clef_ClefSelectionnee,
                                                                Souris_Curseur_Position.portee, tempsssx);
                 end;

                 ClefInseree_SousCurseur_DireQueYenAPas;
                 
                 RedessinerTout := true;
                 FaireLaPaginationEtLesCalculsPuisAffichageComplet(MesureCourante,
                                                                        MesureCourante,
                                                                         false);
                 MusicUser_MusicWriter_Mode_RevenirAuPrecedent;

          end
          else
                 Message_Vite_Fait_Beep_Et_Afficher('Oulà ! Tu essaies d''insérer une clef en dehors de la partition !');

    End;


    {===========================}
    procedure MouseUp_MettreOctavieur_Traitement;
    var tempsssx: TRationnel;

    Begin
        tempsssx := Composition.GetMesure(MesureCourante).TempsAX(X);
        Composition.I_Portee_Octavieur_Ajouter(Souris_Curseur_Position.portee, MesureCourante, tempsssx, ModeClef_Outil_Octavieur_OctavieurSelectionnee);
        RedessinerTout := true;
        FaireLaPaginationEtLesCalculsPuisAffichageComplet(MesureCourante, MesureCourante,
                                                                false);
        MusicUser_MusicWriter_Mode_RevenirAuModeEcritureSiYavait;
    End;



    {===========================}
    procedure MouseUp_PlacerCurseur_Traitement;
    {procédure qui se charge de placer le curseur...}
    var num_voix: integer;

    Begin
        VoixSelectionnee_DetecterPuisChanger(MesureCourante,
                                             X,
                                             Souris_Curseur_Position);

        Curseur.DA_SetAvecXMesure(Curseur.GetiVoixSelectionnee,
                                  MesureCourante,
                                  X,
                                  Souris_Curseur_Position);



              

              if Outil = MettreParoles then
              {il faut qu'on puisse changer de voix qd on veut rajouter des paroles}
              Begin
                  if MesureCourante < Composition.NbMesures then
                   Begin
                          Composition.GetMesure(MesureCourante).DonnerNumVoixPresCurseur(X, Y, num_voix);
                          VoixSelectionnee_Changer(num_voix);
                          frmParoles.SetVoixNum(num_voix);
                          frmParoles.ShowModal;
                   End
                   else
                    Message_Vite_Fait_Beep_Et_Afficher('Tu veux mettre des paroles. Pour cela clique DANS la partition pour ' +
                    ' que je sache dans quel voix tu veux écrire !');
              End;

        Composition.Selection_ToutDeselectionner;

        if MusicUser_MusicWriter_Mode_Get = mw_mode_Selection then
             MusicUser_MusicWriter_Mode_RevenirAuModeEcritureSiYavait;

        RedessinerTout := true;

        CalcCurseur(chgportee, true);

    End;


    {===========================}
    procedure MouseUp_EntrerNote_Traitement;
    var keykey: word;


    Begin
        keykey := 13;

        if not Curseur.Is_SurMesure_FinaleAAjouter then
        Begin
               if PausesAvantCurseur <> nil then
               Begin
                  Curseur_Souris.GetVoixMesure.InsererDesPauses_EnFin(
                           PausesAvantCurseur ,Souris_Curseur_Position.portee);
                  Curseur.DR_MemeVoixFinMesure;
               End;

        End;
                           
        FormKeyDown(nil, keykey, []);

        if not Curseur.Is_ElementMusical_Dessus then
             CurseurSouris_DeplacerLegerementADroite;


    End;






      Function VoixSelectionnee_Str: string;
      var iportee, num_voix_in_portee, n_voix: integer;
      Begin
             n_voix := Curseur.GetiVoixSelectionnee;
             iportee := n_voix mod Composition.NbPortees;
             num_voix_in_portee := n_voix div Composition.NbPortees;

             result := inttostr(iportee+1) + '_' + inttostr(num_voix_in_portee+1);
      End;


      Function VoixSelectionnee_EtenduePortee_Str: string;
      var iportee, p1, p2: integer;

      Begin
          iportee := Curseur.GetiVoixSelectionnee mod Composition.NbPortees;
          Composition.GetGroupePortees(iportee, p1, p2);

          if p1 = p2 then
              result := 'la portée n°' + inttostr(p1+1)
          else
              result := 'les portées n°' + inttostr(p1+1) + ' à ' + inttostr(p2+1);
      End;


      Function MouseUp_RegleTemps_Gerer: Boolean;
      var temps_nouveau: TRationnel;
      Begin
             result := false;
             if not RegleTemps_IsAffiche then exit;


             if IsRegleTemps_Curseur_Dessus(Composition, LigneCourante, MesureCourante,
                                     X, Y, temps_nouveau) then
             Begin
                         //ShowMessage(QToStr(regletemps_temps_ancien) + ' à ' + QToStr(temps_nouveau));

                         Interface_Questions_RegleMesure_iMesure_Set(MesureCourante);
                         Composition.GetMesure(MesureCourante)
                          .RegleMesure_DeplacerTic(
                             regletemps_temps_ancien,
                             temps_nouveau);
                         Composition.CalcTout(true);
                         ReaffichageComplet;

                         result := true;

             End;
      End;



      procedure MouseUp_Voix_Selectionner;

          procedure MouseUp_Voix_Selectionner_QuandOnCliquePasSurUneVoix;
          Begin
              if MusicUser_MusicWriter_Mode_Get <> mw_mode_Paroles then
                  Voix_Selectionner_Dans_Partition_Close
              else
                  Beep;
          End;


          procedure MouseUp_Voix_Selectionner_QuandOnCliqueSurUneVoix(voixsouscurseur: integer);
          Begin
                if MusicUser_MusicWriter_Mode_Get = mw_mode_Paroles then
                        frmParoles_Afficher(private_Voix_Selectionner_voixsouscurseur)
                else
                Begin
                        Voix_Gestion_ModeAutomatique_Set(false);
                        IGP := Composition;
                        VoixSelectionnee_Changer(voixsouscurseur);
                        Voix_Selectionner_Dans_Partition_Close;
                End;
          End;

     Begin
          if private_Voix_Selectionner_voixsouscurseur = -1 then
          Begin
              MouseUp_Voix_Selectionner_QuandOnCliquePasSurUneVoix;
          End
          else
          Begin
              MouseUp_Voix_Selectionner_QuandOnCliqueSurUneVoix(private_Voix_Selectionner_voixsouscurseur);

          End;
     End;


begin
      {mouseup}


      {si on est en train de redimensionner la fenêtre, fo pas que ça touche à
        la partition !! c'est assez énervant de voir une note qui apparait alors
        qu'on voulait juste redimensionner la fenêtre}
      if tmrFormResizing.Enabled then exit;

      
      if (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) then Exit;



      Souris_Curseur_ScrX := X;
      Souris_Curseur_ScrY := y;

      X := GetX(X);
      Y := GetY(Y);



      {mouseup}


      if Voix_Selectionner_IsDansCeMode then
      Begin
            if Button = mbLeft then
                 MouseUp_Voix_Selectionner;
            exit;
      End;



      if (OutilPlus = opDeplacerObjet) or (OutilPlus = opDeplacerObjet_Point)  then
      Begin
            GraphicObjet_SousCurseur_Get.PosInPartition_CalculerMesuresTempsEtc(Composition);
            Composition.ObjetsGraphiques_Boucle;
            ReaffichageComplet;
            OutilPlus := opRien;
            Exit;
      End;


   {   if IsModeSelectionMesure then
      //mode sélection de mesures
      Begin
         frmProprietesMesures.MettreAJourFenetre(nil);
         exit;
      End;  }

      if MusicStylet_Stylet_AEteUtilise then
      Begin
          MouseUp_Stylet_Traitement;
          exit;
      End;
      {fin Stylet}




      //On lâche le bouton gauche lors d'un mode sélection
      If OutilPlus = opSelection then
      Begin
            MouseUp_SelectionRectangulaire_Traitement;
            Exit;
      End

      else if (OutilPlus <> opDeplacer) and (OutilPlus <> opDeplacerPause) then
      {par défaut, il n'y a pas de sélection lorsqu'on lâche le bouton...
          sauf si :
             - on était en train de sélectionner (premier point du if)
             - ou alors qu'on était en train de :
                  * déplacer des notes
                  * déplacer des pauses
                    (négation de ce point là)
                    }
            I_Selection_MettreAJourInfo;




      if MusicUser_MusicWriter_Mode_Get = mw_mode_Selection then
      Begin
            {mouseup}
            if (OutilPlus = opDeplacer) and (Outil <> MettreAlteration) then
            {on lâche le curseur : on effectue donc le déplacement}
            Begin
                 MouseUp_Deplacement_Traitement;
                 Exit;

            End;

            {mouseup}
            if OutilPlus = opDeplacerPause then
            Begin
                MouseUp_DeplacementPauses_Traitement;
                Exit;
            End;
      End;


      if IsCurseurDansBandeNomsPorteesDuModeRuban(Souris_Curseur_X) then
      Begin
         LigneCourante := 0;
         MesureCourante := -1;
         yab := false;
         {BEEP : clic dans la bande des noms de portées}
         beep;
      End
      else
           yab := Composition.FindMesurePourModif2(X, Y, LigneCourante, MesureCourante);

      if not yab then exit;

      {à partir de là, yab est vrai, ie on est en train d'éditer le document
       (le curseur est soit dans une mesure, soit en fin de document}

       {mouseup}
      GetPosition(Y, Composition, LigneCourante, Souris_Curseur_Position);


      if MouseUp_RegleTemps_Gerer then exit;

      //On vérifie que l'on écrit pas dans une portée qui n'est pas faite pour cette voix,
      if MusicUser_MusicSystem_Mode_IsModeAvecVoixCourante then
      if not (Outil_MettreNoteIsModeClavier and Voix_Gestion_IsModeAutomatique)
         and not VerifierQueVoixSelectionneePeutEcrireDansPortee(Souris_Curseur_Position.portee) then
      Begin
           Console_AjouterLigne('voixpaspourcetteportee');

           IGP := Composition;
           Aide_Params_Ajouter(VoixSelectionnee_Str);
           Aide_Params_Ajouter(VoixSelectionnee_EtenduePortee_Str);
           Aide_Params_Ajouter(inttostr(Souris_Curseur_Position.portee+1)); //portée erreur


           Aide_AfficherDansChildWin('voixpaspourcetteportee',Souris_Curseur_ScrX, Souris_Curseur_ScrY, 32);
           exit;
      End;






      chgportee := (Curseur.Getposition.portee <> Souris_Curseur_Position.portee);




      {mouseup}

      if MusicUser_MusicWriter_Mode_Get = mw_mode_MettreNuances then
      Begin
           if Outil = MettreNuance then
               MouseUp_MettreNuance_Traitement;

           exit;
      End;


      if IsOutilMettreObjetGraphiqueDemandePoint then
          MouseUp_MettreObjetGraphic_Traitement
      else



      if MusicUser_MusicWriter_Mode_Get = mw_mode_MettreClef then
      Begin

            {mouseup}
            if (Outil = MettreClef) and (Button = mbLeft) then
                MouseUp_MettreClef_Traitement

            {mouseup}
            else if (Outil = MettreOctavieur) and (Button = mbLeft) then
                MouseUp_MettreOctavieur_Traitement;

            Exit;
      End;


      if MusicUser_MusicWriter_Mode_Get = mw_mode_MettreNote then
      Begin
          if Button = mbMiddle then
               Message_Vite_Fait_Beep_Et_Afficher(
                     'Le bouton du milieu sert à copier-coller une sélection. ' +
                     'Pour cela, il faut être en mode sélection et avoir sélectionné ' +
                     'des notes ou des silences.')
          else 
          if (Outil = PlacerCurseur) or (not Outil_MettreNoteIsModeSouris) or (Outil = MettreParoles) or (mbRight = Button) and yab then
          {Le bouton droit, le mode PlacerCurseur a priori, place le curseur}
          Begin
                MouseUp_PlacerCurseur_Traitement;
                Exit;

          end
          Else if yab and Is_MettreNoteAvecBoutonGaucheSouris and (Outil_MettreNoteIsModeSouris) then
                MouseUp_EntrerNote_Traitement;

      End;



      if MusicUser_MusicWriter_Mode_Get = mw_mode_selection then
      Begin
          if (Button = mbMiddle) and option_CopierColler_AlaUnix_Utiliser_La_Fonctionnalite then
          {le bouton du milieu a une fonction de copier coller comme dans les unix}
               MouseUp_CopierColler_AlaUnix_Traitement

          else
          if not MouseDown_Pour_MouseUp_ModeSelection_OnACliqueSurUneNoteQuOnASelectionnee then
          Begin
              Composition.Selection_ToutDeselectionner;
              MusicUser_MusicWriter_Mode_RevenirAuModeEcritureSiYavait;
          End;
      End;



      CalcCurseur(chgportee, false); //contient formpaint(nil)
end;
{fin mouseup}













Procedure TMDIChild.MettreAJourCentrageScrollBar;
Begin
    View.pixxdeb := HScrollBar.Position - 80;
    View.pixydeb := VScrollBar.Position - 320;

    SetViewCourantPixDeb(View.pixxdeb, View.pixydeb);
    
end;




procedure TMDIChild.CalcCurseur(changerportee, changerposition: boolean);
    procedure LectureMIDI_MettreAJour;
    Begin
                        {c'est pt un peu bourrin}
          LectureMIDI_ListeDeLecture := Composition.LectureMIDI_GetListeiMesuresDeLecture;
    End;

Begin
    Console_AjouterLigne('Calccurseur appelé');

    IGP := Composition;

    Curseur.CalculerXY_CurseurClavier;

    if Curseur.Is_ElementMusical_Dessus then
        ElSC := Curseur.GetElementMusical
    else
        ElSC := nil;

    Souris_Curseur_Position := Curseur.GetPosition;
                       {hn était IntervalleDeplacement avant... pourquoi ?}
    if changerposition then
             Curseur.SetHauteurNoteAlterationParDefaut;



    FormPaint(nil);

    if changerportee then
          frmProprietesPortee.MettreAJourFenetre(nil);


    if not Curseur.Is_SurMesure_FinaleAAjouter then
          LectureMIDI_MettreAJour;


End;


Function TMDIChild.DessinerUnFondPourVoixVide: Boolean;
Begin
    result := false;
        if MesureCourante = Composition.NbMesures then
               result := true
         else if Composition.IsIndiceMesureValide(MesureCourante) then
            if not Composition.GetMesure(MesureCourante)
                         .IsVoixNumPresente(Curseur.GetiVoixSelectionnee) then
              result := true;
End;


procedure TMDIChild.VoixSelectionnee_Changer(newvoixselectionnee: integer);
{enclenche le changement de voix courante}

var p1, p2: integer;
Begin
{préconditions}
    if not View.VoixAffichee[newvoixselectionnee] then
          exit;
        { MessageErreur('Bizarre !! Le logiciel essaye d''afficher une voix qu''il ' +
                'n''a pas le droit d''afficher... pas le droit car elle est normalement ' +
                'invisible... pour info c''est la voix numéro ' + inttostr(newvoixselectionnee) +
                '...');  }



    if newvoixselectionnee <> Curseur.GetiVoixSelectionnee then
    Begin

          {on va s'occuper du curseur}
          Curseur.DR_Voix_Changer(newvoixselectionnee);

          BlitterToutDuBackBuffer := true;
          Voix_Gestion_MettreAJourPanneau;


          //View.VoixAffichee[VoixSelectionnee] := true;

          if not Voix_Gestion_IsModeAutomatique then
          Begin
              IGP := Composition;
              Composition.GetGroupePortees(Composition.Voix_Indice_To_Portee(newvoixselectionnee),
                                           p1, p2);
              Portees_Actives_Set(p1, p2);
              ReaffichageComplet
          End
          else
          Begin
              Portees_Actives_Toutes;

              if OPTION_VoixInactive_ToujoursFondPlusClair then
                    ReaffichageComplet
              else
                    FormPaint(nil);


          End;
    End;

End;


procedure TMDIChild.VoixSelectionnee_DetecterPuisChanger(imesure,
                                                         x_in_mes: integer;
                                                         pos: TPosition);
var i, portee_editee, num_voix_preferee: integer;

Begin
   portee_editee := pos.portee;
   IGP := Composition;

   if IGP.Portee_IsTablature(portee_editee) then
        dec(portee_editee);

   IGP.VerifierIndicePortee(portee_editee,
                            'portée éditée dans CalcVoixSelectionnee');



   if Outil = MettreParoles then exit;

   if Voix_Gestion_IsModeNouvelleVoix then
   Begin
          if imesure >= Composition.NbMesures then
          {par défaut, qd on écrit dans une future mesure,
              c'est comme si on utilise la précédente mesure}
                 imesure := Composition.NbMesures - 1

          else if imesure < 0 then
              imesure := 0;

              
          VoixSelectionnee_Changer(Composition.Voix_Nouvel_Indice(imesure, portee_editee));

                             
   end
   else if Voix_Gestion_IsModeAutomatique then
   Begin
          num_voix_preferee := VOIX_TOUTES_LES_VOIX;


          { C'est pas très pratique en fait (surtout pour le copier-coller)
          if Composition.Selection_YaUneSelection then
                num_voix_preferee := Composition.Selection_GetNumVoix;

          if not Composition.Num_Voix_CompatibleAvecPortee(num_voix_preferee, portee_editee)  then
                num_voix_preferee := VOIX_TOUTES_LES_VOIX;  }


          if num_voix_preferee <> VOIX_TOUTES_LES_VOIX then
                 VoixSelectionnee_Changer(num_voix_preferee)
          else

          if Composition.IsIndiceMesureValide(imesure) then
          Begin
          {voix sous le curseur}
              if Composition.Portee_IsTablature(pos.portee) then
                  VoixSelectionnee_Changer(portee_editee)
              else
              Begin
                  Composition.GetMesure(imesure).DonnerNumVoixPresCurseur(Souris_Curseur_Xdansmesure, pos, i);
                  Console_AjouterLigne('VoixSelectionnee_DC : ' + IntToStr(pos.portee) +', ' + IntToStr(pos.hauteur) + ', ' + inttostr(i));
                  VoixSelectionnee_Changer(i);
              End;
              
          end
          else
          Begin
              if View.VoixAffichee[portee_editee] then
                VoixSelectionnee_Changer(portee_editee);
          End;


   End;
   {else : on est en mode manuel... ie on ne fait rien... car se déplacer
           dans la partition ne fait pas changer de voix} 
          
End;


procedure TMDIChild.I_Selection_Alterer(a: TAlteration);
Begin
 Composition.Cancellation_Etape_Ajouter_Selection('changement d''altération d''une sélection');

 Composition.Selection_Alterer(a);
 FaireLaPaginationEtLesCalculsPuisAffichageComplet(Composition.Selection_Getimesdebutselection,
                                                   Composition.Selection_Getimesfinselection,
                                                   true);
End;




procedure TMDIChild.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

var
    key_down_chiffre: integer;
    {sert pour choper le chiffre du pavé numérique}

    chgportee: Boolean;
    keypressed_tablature_numero_case: integer;

    alteration: TAlteration;

      procedure KeyDown_Voix_Gerer_NouvelleVoix;
      Begin
            if Voix_Gestion_IsModeNouvelleVoix then
            Begin
                   VoixSelectionnee_DetecterPuisChanger(Curseur.GetiMesure,
                                                        Curseur.GetPixx_in_mesure,
                                                        Curseur.GetPosition);
                   Voix_Gestion_ModeNouvelleVoix_Arreter;

            End;
      End;


      
      procedure Tablature_ElMusical_Note_Ajouter_Curseur(keypressed_tablature_numero_case: integer);
      var n: TPNote;
          note: TNote;
          el: TElMusical;
      Begin
           Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, Curseur.GetiMesure);


           el := Curseur.GetElementMusical;
           n := Curseur.GetNoteSousCurseur;
           

           if n = nil then
           Begin
              Composition.Cancellation_Etape_Ajouter_FinDescription('Ajout d''une note dans la tablature',
                                                   Curseur.InfoTxtGet_Mesure_Temps,
                                                   Curseur.GetiVoixSelectionnee);

              note := CreerNote(Curseur.GetiPorteeEditee);

              Tablature_System_CordeNum_Set(note, Curseur.Tablature_CordeNum_Get);
              Tablature_System_NumeroCase_Set(note, keypressed_tablature_numero_case);
              Note_MettreAJourPositionHauteurPartition(note, Curseur.GetInfoClefCourante);

              el.AddNote(note);
              
           End
           else
           Begin
              Composition.Cancellation_Etape_Ajouter_FinDescription('Modification d''une note dans la tablature',
                                                   Curseur.InfoTxtGet_Mesure_Temps,
                                                   Curseur.GetiVoixSelectionnee);

              Tablature_System_NumeroCase_Set(n^, keypressed_tablature_numero_case);
              Note_MettreAJourPositionHauteurPartition(n^, Curseur.GetInfoClefCourante);
           End;



      End;

      
      Function Is_Clavier_Etat_Curseur_Deplacer_PorteeDuHaut: Boolean;
      Begin
          result := (Key = 38) and (ssShift in Shift);
      End;
      

      Function Is_Clavier_Etat_Curseur_Deplacer_PorteeDuBas: Boolean;
      Begin
          result := (Key = 40) and (ssShift in Shift);
      End;

      
      procedure KeyDown_PaveNumeriqueGerer(i: integer);
      var DureeSelectionnee: TRationnel;
      
      Begin
        DureeSelectionnee := DureeCourante_Get;
        
        if tmrKeyWait.Enabled then
        {on chope le numérateur}
        Begin
            if i = 0 then
                  i := 1;
            DureeSelectionnee.denom := i;
            DureeCourante_SetSub(DureeSelectionnee);

            if not AfficherDureeSelectionneeSansDelai then
               tmrKeyWaitTimer(nil);

            tmrKeyWait.Enabled := false;

        End
        else
        Begin
        {on a que le numérateur}

            DureeCourante_SetNumSeulementPourLInstant(i);
            tmrKeyWait.Enabled := true;

        End;

        ToucheCtrlEnfonce := (ssCtrl in Shift);

        if AfficherDureeSelectionneeSansDelai then
        Begin
              DureeCourante_Boucle;
              MainForm.Duree_Courante_Faire;


        End;
    End;



    procedure KeyDown_Traiter_SupprimerNoteOuElementMusicalOuMesure;
    var eln: TElMusical;

    Begin
           if Curseur.Is_ElementMusical_Dessus then //rem : dessus !! on est forcément sur un groupe de notes et yabon pour l'indice !
           Begin
                   if Curseur.GetVoixMesure.IsVide then
                         Message_Vite_Fait_Beep_Et_Afficher('ETRANGE ')
                   else
                   Begin
                         eln := Curseur.GetElementMusical;
                         if not eln.DelNote(Curseur.Getposition) then
                         Begin
                                 if high(eln.Notes) = -1 then
                                 Begin
                                     Curseur.GetVoixMesure.DelElMusical(Curseur.GetiIndice);
                                     ElSC := nil;
                                 End;
                                 CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;

                         End;
                   End;
           end
           Else
           Begin
                   if not Curseur.GetVoixMesure.DelElMusical(Curseur.GetiIndice) then
                   Begin
                         if Composition.IsMesureVide(Curseur.GetiMesure) then
                         {eh oui !! avec suppr, on peut supprimer des mesures}
                             I_Mesure_Supprimer(Curseur.GetiMesure)
                         else
                              Message_Vite_Fait_Beep_Et_Afficher('Tu te trouves à la fin de la mesure. Je n''ai rien à supprimer.');
                   End;
                   CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;

           End;
           FaireLaPaginationEtLesCalculsPuisAffichageComplet(Curseur.GetiMesure,
                                                             Curseur.GetiMesure,
                                                             false);
    End;


    procedure KeyDown_RenversementAccord_SelectionOuModele(j: integer);
    var m, v, i: integer;
    Begin

         {j contient le sens de renversement de l'accord courant}

         if Composition.Selection_YaUneSelection then
         Begin
         with Composition  do
            for m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
            With GetMesure(m) do
             for v := 0 to high(Voix) do
                     for i := 0 to high(Voix[v].ElMusicaux) do
                            if Voix[v].ElMusicaux[i].IsSelectionne then
                                Voix[v].ElMusicaux[i].Renversement(j);
         End
         else
         Begin
             Modeles[ModeleSousCurseur].Voix.ElMusicaux[0].Renversement(j);
             MainForm.IntChangerModeleCourant(ModeleSousCurseur);

         End;

         RedessinerTout := true;
         formpaint(nil);     {si l'on supprime ces deux lignes, ya un appel "calcCurseur" qui est effectué...
                              et le curseur est replacé à la position clavier}
    End;


    procedure KeyDown_EntreeNotes;
    var imesure_entree_notes: integer;

    Begin
         CurseurSouris_Busy_Begin;
         imesure_entree_notes := Curseur.GetiMesure;
         
         KeyDown_Voix_Gerer_NouvelleVoix;

         if not Curseur.Is_ElementMusical_Dessus then
         {on est pas sur un élément musical}
         Begin
              if Curseur.Is_SurMesure_FinaleAAjouter then
              Begin
                      Composition.Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, Curseur.GetiMesure);
                      Composition.AddMesureFin;
                      Curseur.DA_Mesure_Debut(Composition.NbMesures - 1);

              end;

              if Curseur.Is_Curseur_Sur_Tablature then
                  Curseur.SetHauteurNote(Tablature_System_NumCordeNumCaseToHauteurNote(
                          Curseur.Tablature_CordeNum_Get,
                          keypressed_tablature_numero_case));
                                                         
              I_InsererModeleCourantDansVoixCourante(Curseur.GetHauteurNote);


         end
         else {on est dessus
            (ps : on ne peut pas être dans la dernière mesure (celle à ajouter)}
            Begin
                 //pré-cond
                 Curseur.Verifier('appui sur entrée quand on est sur un él. mus.');
                //fin précond

                if Curseur.Is_Curseur_Sur_Tablature then
                Begin
                    Tablature_ElMusical_Note_Ajouter_Curseur(keypressed_tablature_numero_case)


                End
                else
                Begin
                    Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, Curseur.GetiMesure);

                    {hn := HauteurNoteAvecHauteurEtAlteration(
                                  HauteurGraphiqueToHauteurAbs(
                                  Composition.InfoClef_DetecterAvecrelX(
                                      Curseur.GetiPorteeEditee,Curseur.GetiMesure,
                                      Curseur.GetPixx_in_mesure),

                                  Curseur.Getposition.hauteur),

                                  AlterationCourante); }

                    Composition.Cancellation_Etape_Ajouter_FinDescription('Ajout d''une note : ' +
                                             HauteurNoteToStr(Curseur.GetHauteurNote) +
                                             ' dans ' +
                                             ElMusicalToStr(Curseur.GetElementMusical, true),
                                             Curseur.InfoTxtGet_Mesure_Temps,
                                             Curseur.GetiVoixSelectionnee);

                    if not Curseur.GetElementMusical.AddNote2(Curseur.GetPosition,
                                                              Curseur.GetHauteurNote) then
                                           Message_Vite_Fait_Beep_Et_Afficher('Impossible d''ajouter la note : celle-ci est déjà présente !');

                 End;

            End;
                                
       Composition.PaginerLaMesureEtApresSiBesoin(imesure_entree_notes, true);
       RedessinerTout := true;
       CurseurSouris_Busy_End;

    End;



    procedure KeyDown_ClavierElectronique_Traiter(key_down_chiffre: integer);
    Begin
        key_down_chiffre := NbDemiTonProchePourMemeNote(NbDemiTonInHauteurNote(Curseur.GetHauteurNote), key_down_chiffre);
        Curseur.SetHauteurNote(NbDemiTonToHauteurNote(key_down_chiffre, Curseur.GetTonaliteCourante));
        Entree_HauteurNote_Traiter(Curseur.GetHauteurNote);
    End;


    procedure KeyDown_DeplacementNote_Gerer;
    var alteration: TAlteration;
    Begin
         if (OutilPlus <> opDeplacer) and
                (OutilPlus <> opDeplacerClavier) then
      Begin
          {initialise le déplacement de notes au clavier}
          IntervalleDeplacement_Init;

          Composition.Selection_HauteurNotePremiereNote_Get(HauteurNoteRefDeplacement);
          OutilPlus := opDeplacerClavier;
      End;

      if key = 38 then // /\ haut
             IntervalleDeplacement_DeplacerUnefoisVersLeHautEnAccordAvecTonalite(Curseur.GetTonaliteCourante)

      else if key = 40 then // \/ bas
             IntervalleDeplacement_DeplacerUnefoisVersLeBasEnAccordAvecTonalite(Curseur.GetTonaliteCourante)
      else if key = 33 then //page up
          IntervalleDeplacement_DeplacerUnefoisDUneOctaveVersLeHaut
      else if key = 34 then //page down
          IntervalleDeplacement_DeplacerUnefoisDUneOctaveVersLeBas
      else if KeyToAlteration(Key, alteration) then
           IntervalleDeplacement_FaireEnSorteQueAlterationDeLaNoteRefVaut(alteration);

      MettreAJourAffNoteDeplacement;
    End;


    procedure KeyDown_Alteration_Gerer(alteration: TAlteration);
    Begin
        if NoteSousCurseur <> nil then
        Begin
                Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, MesureCourante);
                Composition.Cancellation_Etape_Ajouter_FinDescription('changement d''altération d''une note',
                                                                      Curseur.InfoTxtGet_Mesure_Temps,
                                                                      Curseur.GetiVoixSelectionnee);
                NoteSousCurseur^.hauteurnote.alteration := alteration;
                Composition.PaginerApartirMes(MesureCourante, false); //pas sûr
        end
        else if Composition.Selection_YaUneSelection and (ChgtAlterationSelectionQuandEntreeAuClavier or (ssCtrl in Shift)) then
        Begin
             I_Selection_Alterer(alteration);
             Exit;
        End
        else if Curseur.Is_ElementMusical_Dessus and (Outil = PlacerCurseur) then
        Begin
              if not Curseur.GetElementMusical.Alterer(Curseur.GetPosition, alteration) then
                       Message_Vite_Fait_Beep_Et_Afficher('Impossible d''altérer la note (A REVOIR)')
              else
                    Composition.PaginerApartirMes(Curseur.GetiMesure, false); //A REVOIR
        End;
        Curseur.SetHauteurNoteAlteration(alteration);

      ReaffichageComplet;
    End;

    
Begin

keypressed_tablature_numero_case := 0;

if MusicUser_MusicWriter_Mode_Get = mw_mode_Selection then
Begin
    if Key = VK_ESCAPE then
    Begin
          Composition.Selection_ToutDeselectionner;
          MusicUser_MusicWriter_Mode_RevenirAuModeEcritureSiYavait;
          FormPaint(nil);
          Exit;
    End;
End;


if MusicUser_MusicWriter_Mode_Get = mw_mode_Enregistrer then
Begin
    frmEnregistreur.FormKeyDown(Sender, Key, Shift);
    exit;
End;


if ((Key = 70) and (ssCtrl in Shift)) then
Begin
   Fusionner1Click(nil);
   exit;
End;


if MusicUser_MusicSystem_Mode_IsModeAvecVoixCourante then
Begin
      if  ((Key = 67) and (ssAlt in Shift)) {'c'} then
      Begin
          CyclerVoixCourante;
          Exit;
      End;
End;

if  ((Key = 84) and (ssAlt in Shift)) {alt + t} then
Begin
    MainForm.pmnuTonalites.Popup(0, 0);
    Exit;
End;

if (Key = 93) or ((Key = 88) and (ssAlt in Shift)) {x} then {touche méta (93 = touche menu déroulant) pour accéder
                  au menu super puissant}
Begin
    if Composition.Selection_YaUneSelection then
             PopupMenuSelection.Popup(0,0)
    else
             PopupMenuCurseur.Popup(0,0);
    exit;
End;

if Key = VK_MENU then exit;

if ssAlt in Shift then
    exit;

Console_AjouterLigne('Form_KeyDown appelé');

if (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) or (Outil = MettreParoles) then Exit;
Composition_Enregistrement_ABesoinDEtreEnregistre;
chgportee := false;

if ssCtrl in Shift then
     BoutonCtrlActive := true;


if (Key = VK_CONTROL) and not BoutonControleDejaActif and (OutilPlus <> opDeplacer) then
Begin
     IntervalleDeplacement_Init;
     BoutonControleDejaActif := true;
     Exit;
End;

if Key = VK_SHIFT then exit;
if Key = VK_MENU then exit;

{Pourquoi quitter quand Key = VK_CONTROL ?? Tout simplement, pour éviter un
 rafraichissement de l'écran qui ralentirait la sélection...}
if Key = VK_CONTROL then exit;

if (OutilPlus = opDeplacer) or (BoutonCtrlActive and
                                 ((Key in [33,34,38,40]))) then
                                  //or KeyToAlteration(Key, AlterationCourante))) then
Begin
      KeyDown_DeplacementNote_Gerer;
      Exit;
end
else if key = 33 then //page up
          DefilerPartitionUnePageEnArriere
      else if key = 34 then //page down
          DefilerPartitionUnePageEnAvant
else
if Curseur.Is_Curseur_Sur_Tablature and
   IsKeyGuitare(key, keypressed_tablature_numero_case) then
     Key := 13
else
if IsKeyPaveNumerique(key, key_down_chiffre) then
Begin
    KeyDown_PaveNumeriqueGerer(key_down_chiffre);
    Exit;
End

else


if (ssCtrl in Shift) and IsKeyNormalNumerique(Key, key_down_chiffre) and RacourciClavierCtrlNPourChgtModele then
Begin
    if not MainForm.IntChangerModeleCourant(key_down_chiffre-1) then
         Message_Vite_Fait_Beep_Et_Afficher('Numéro de modèle incorrect');
         
    CalcCurseur(chgportee,true);
    exit;

End else


if Key = 39 then //->
Begin
      if Curseur.DR_AllerADroite then
         FaireVoirMesure(Curseur.GetiMesure)
      else
         Message_Vite_Fait_Beep_Et_Afficher(Langues_Traduire('On ne peut pas aller plus à droite : on est déjà à la fin de la partition.'));


End else


if Key = 37 then //<-
Begin
    if Curseur.DR_AllerAGauche then
         FaireVoirMesure(Curseur.GetiMesure)
      else
         Message_Vite_Fait_Beep_Et_Afficher(Langues_Traduire('On ne peut aller plus à gauche : on est déjà au début du document.'));

End else

if Is_Clavier_Etat_Curseur_Deplacer_PorteeDuHaut then
       chgportee := Curseur.DR_Deplacer_PorteeDuHaut
else

if Is_Clavier_Etat_Curseur_Deplacer_PorteeDuBas then
       chgportee := Curseur.DR_Deplacer_PorteeDuBas
else
if Key = 38 then // /\ haut
       Curseur.DR_DeplacerVersLeHaut

else
if Key = 40 then // \/ bas
       Curseur.DR_DeplacerVersLeBas
else



if (Key = 107) or (Key = 109) then // + et -
Begin
     if Key = 107 then
           KeyDown_RenversementAccord_SelectionOuModele(1)
     else
           KeyDown_RenversementAccord_SelectionOuModele(-1);

     exit;
End;







{keydown}
if KeyToAlteration(Key, alteration) then
Begin
      KeyDown_Alteration_Gerer(alteration);
      Exit;
end;


{keydown}
if Outil_MettreNoteIsModeClavier then
     VoixSelectionnee_DetecterPuisChanger(Curseur.GetiMesure,
                                          Curseur.GetPixx_in_mesure,
                                          Curseur.Getposition);


if IsClavierElectroniqueActive and KeyToNombreDemiTonPourHauteurNote(Key, key_down_chiffre) then
{le clavier "électronique"}
Begin
        KeyDown_ClavierElectronique_Traiter(key_down_chiffre);
        Exit;
End;

if Key = 13 then //entrée
         KeyDown_EntreeNotes
else



If Key = 32 then //espace
Begin
      if MusicUser_MusicWriter_Mode_Get = mw_mode_MettreNote then
      Begin

            KeyDown_Voix_Gerer_NouvelleVoix;

            if not Curseur.Is_SurMesure_FinaleAAjouter then
                Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, Curseur.GetiMesure);




            if not Outil_MettreNoteIsModeClavier  then
            Begin
                if MesureCourante < 0 then
                     Message_Vite_Fait_Beep_Et_Afficher('On ne peut pas mettre de note en dehors du document ! (A REVOIR)')
                else
                Begin
                      if Curseur.Is_SurMesure_FinaleAAjouter then
                      Begin
                              Composition.Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, MesureCourante);
                              Composition.AddMesureFin;
                              Composition.PaginerApartirMes(MesureCourante, true);
                      end;

                      Composition.GetMesure(Curseur.GetiMesure).VoixNum(Curseur.GetiVoixSelectionnee).AddElMusical(
                                     Curseur.GetiIndice,
                                     CreerElMusicalPause(DureeCourante_Get,
                                                         Curseur.GetiPorteeEditee));
                End;
            End
            else if Outil_MettreNoteIsModeClavier then
            {on appuie sur espace}
            Begin
                  if Curseur.Is_SurMesure_FinaleAAjouter then
                  Begin
                          Composition.Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, Curseur.GetiMesure);
                          Composition.AddMesureFin;
                          Curseur.DA_Mesure_Debut(Composition.NbMesures - 1);
                          Composition.PaginerApartirMes(Curseur.GetiMesure, true);//POURQUOI CA ?
                  end;

                 Composition.GetMesure(Curseur.GetiMesure).VoixNum(Curseur.GetiVoixSelectionnee).AddElMusical(
                 Curseur.GetiIndice,
                 CreerElMusicalPause(DureeCourante_Get,
                                     Curseur.GetiPorteeEditee));
            End;


            Composition.Cancellation_Etape_Ajouter_FinDescription('Ajout d''une pause au clavier',
                                                                  Curseur.InfoTxtGet_Mesure_Temps,
                                                                  Curseur.GetiVoixSelectionnee);


             FaireLaPaginationEtLesCalculsPuisAffichageComplet(Curseur.GetiMesure,
                                                               Curseur.GetiMesure,
                                                               false);

             Curseur.DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante;

             {rem : DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante est à faire
             après le FaireLaPaginationEtLesCalculsPuisAffichageComplet...
             car DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante est suceptible de modifier
              Curseur.GetiMesure et donc... on repaginera pas tout !!}
             RedessinerTout := true;
        End;

End else


{keydown}
{on a appuyé sur retour arrière}
if Key = 8 then
Begin

     if not Curseur.Is_SurMesure_FinaleAAjouter then
     Begin
            If Curseur.Is_ElementMusical_Dessus then
                   Key := 46 //comme suppr
            else
                   if Curseur.GetiIndice > 0 then
                   Begin
                         Curseur.GetVoixMesure.DelElMusical(Curseur.GetiIndice-1);
                         CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
                         DemarrerAnimationMesure(Curseur.GetiMesure);

                         FaireLaPaginationEtLesCalculsPuisAffichageComplet(Curseur.GetiMesure,
                                                                           Curseur.GetiMesure, true);
                   End
                   else
                         Message_Vite_Fait_Beep_Et_Afficher('On se trouve en début de mesure : Ret Arr ne supprime rien.');








     End else
            Message_Vite_Fait_Beep_Et_Afficher('On se trouve après la dernière mesure de la partition : ' +
             'il n''y a rien à supprimer avec la touche Ret Arr.');







End else
{keydown}
{on a appuyé sur suppr}
if Key = 46 then //suppr
Begin
     if Is_GraphicObjet_SousCurseur then
           GraphicObjet_SousCurseur_Supprimer
     else
     if Composition.Selection_YaUneSelection then
     Begin
           I_Selection_Supprimer
     end
     else if Curseur.Is_SurMesure_FinaleAAjouter then
          Message_Vite_Fait_Beep_Et_Afficher('A la toute fin de la partition, il n''y a rien à supprimer avec Suppr.')
     else
           KeyDown_Traiter_SupprimerNoteOuElementMusicalOuMesure;



      RedessinerTout := true;

End;


{keydown}
CalcCurseur(chgportee,true);
CurseurSouris_RecalculerPositionAPartirDeLaPositionCurseurInterne;
                                     


end;







procedure TMDIChild.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

    procedure Zoom_Regler;
    var z, za, x, y: integer;
        newpixxdeb, newpixydeb: integer;

    const option_Zoom_Min = 15;
    const option_Zoom_Max = 800;

    Begin
        za := Zoom_Get;
        z :=  za + WheelDelta div 20;

        if z < option_Zoom_Min then
             z := option_Zoom_Min;

        if z > option_Zoom_Max then
              z := option_Zoom_Max;

        SetCurrentView;
        x := GetX(Souris_Curseur_ScrX);
        y := GetY(Souris_Curseur_ScrY);

        newpixxdeb := -(za * (x - View.pixxdeb) div z - x);
        newpixydeb := -(za * (y - View.pixydeb) div z - y);

        private_VScrollBarChange_IgnorerEvenement := true;
        HScrollBar.Position := newpixxdeb + 80;
        VScrollBar.Position := newpixydeb + 320;
        private_VScrollBarChange_IgnorerEvenement := false;

        Zoom_Set(z);

        SetCurrentView;
        {
        if abs(GetX(Souris_Curseur_ScrX) - x) > 3 then
             MessageErreur('x = ' + inttostr(x) + ' ; nx = ' + inttostr(GetX(MousePos.X)));

        if abs(GetY(Souris_Curseur_ScrY) - y) > 3 then
             MessageErreur('y = ' + inttostr(y) + ' ; ny = ' + inttostr(GetY(Souris_Curseur_ScrY)));

        Ce tes marche pas bien à cause des approximations dues aux ScrollBar (aux bords)
        }
    End;


    procedure Document_FaireDefiler;
    Begin
        if View.ModeAffichage = maRuban then
                    HScrollBar.Position := HScrollBar.Position - WheelDelta*5
            else
                    VScrollBar.Position := VScrollBar.Position - WheelDelta*5;
    End;



    procedure IntervalleDeplacer_AlterationGerer;
    Begin
         If WheelDelta > 0 then
              IntervalleDeplacement_Alteration_UneDePlus
         else
              IntervalleDeplacement_Alteration_UneDeMoins;

         MettreAJourAffNoteDeplacement;
    End;

begin
//roulette pour faire défiler le doc


      if ssCtrl in Shift then
           Zoom_Regler
      else
      if OutilPlus = opDeplacer then
           IntervalleDeplacer_AlterationGerer
      else
           Document_FaireDefiler;

      Handled := true;
end;

procedure TMDIChild.tmrKeyWaitTimer(Sender: TObject);
begin
      if not tmrKeyWait.Enabled then
        exit;

      DureeCourante_Set(DureeCourante_Get);
      MainForm.Duree_Courante_Faire;
      Formpaint(nil);
      tmrKeyWait.Enabled := false;

end;


Function TMDIChild.RegleTemps_IsAffiche: Boolean;
Begin
    result := tlbAfficherRegleTemps.Down;
End;


procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
var resultat: TModalResult;
    tab_index: integer;

begin
  Action := caFree;

{ à entourer de if}
  if Composition.AEteModifieDepuisEnregistrement then
  Begin
      frmEnregistrerAvertissement.TitreSet(FileName);
      
      resultat := frmEnregistrerAvertissement.ShowModal;
      case resultat of

           mrYes: if not TenterEnregistrer(false) then
                         Action := caNone;
           //mrNo: CanClose := true;
           mrCancel: Action := caNone;
      end
  end;


{}

  if Action = caFree then
  Begin
      {là, on est sûr que l'on quitte se document}

      {on supprime les références à cette fenêtre, qui va mourir}

      Magnetophone_Prevenir_la_fermeture_d_une_fenetre(self);

      if actchildDerniereSelection = self then
              actchildDerniereSelection := nil;

      if ToutDessinerDansBitmapScrDabord then
      Begin
          scr.free;
          scr := nil;
      end;
      backbuffer.free;
      backbuffer := nil;
      tmrAffichageClignotant.Enabled := false;
      tmrSourisCurseur_Clignotement_Timer.Enabled := false;
      FreeAndNil(Composition);

      With Mainform do
      Begin
         tab_index := TabControlChildWinIndice_Get(self);
         TabControlChildWin.Tabs.Delete(TabControlChildWinIndice_Get(self));
         TabControlChildWin.TabIndex := min(tab_index, TabControlChildWin.Tabs.Count - 1);
         TabControlChildWin_Redimensionner;
      End;

      MainForm.CapterQueYaOuNonFenetreActive(false);
  End
  else MusicWriter_IsOnQuitteleprogramme := false;

end;


procedure TMDIChild.ReaffichageComplet;
Begin
    RedessinerTout := true;
    BlitterToutDuBackBuffer := true;
    FormPaint(nil);
End;



procedure TMDIChild.FormActivate(Sender: TObject);
begin
{petite sécurité car FormActivate est appelé par TMDIChild.Create...
 alors que Composition est encore à nil}
      if Composition <> nil then
      Begin
          MainForm.CapterQueYaOuNonFenetreActive(true);
          Composition.Cancellation_GererMenuAnnuler;
      End;

          
      tmrAffichageClignotant.Enabled := true;
      tmrCurseurClavier.Enabled := true;
      

end;

Procedure TMDIChild.DemarrerAnimationMesure(mes: integer);
Begin
If Composition.IsIndiceMesureValide(mes) then
Begin
  Composition.GetMesure(mes).RemplirLastPixx;
  Animation_ElMusicaux_Indice := NbFrameAnim;
  Animation_ElMusicaux_iMesure := mes;
  tmrDemarrerAnimationEditionMesure.Enabled := true;
End;
End;




Function TMDIChild.VerifierQueVoixSelectionneePeutEcrireDansPortee(portee: integer): Boolean;
Begin
    result := Composition.Num_Voix_CompatibleAvecPortee(Curseur.GetiVoixSelectionnee,
                                                        portee);
    result := Composition.DansMemeGroupePortee(
                     Curseur.GetiVoixSelectionnee mod Composition.NbPortees {portée de la voix},
                     portee);

    if not result then
    {    BEEP : on a cliqué dans une portée dans laquelle on ne peut pas écrire (car le num.
     de voix est incompatible}
         Message_Vite_Fait_Beep_Et_Afficher('Tu as cliqué dans une portée qui n''est pas compatible avec la voix courante.');

End;



Function TMDIChild.I_InsererModeleCourantDansVoixCourante(a_hn: THauteurNote): Boolean;
Begin
   if Curseur.Is_SurMesure_FinaleAAjouter then
          I_InsererModeleCourantDansVoixCourante(Curseur.GetiMesure,
                                     Curseur.GetiIndice,
                                     a_hn,
                                     Curseur.GetiPorteeEditee,
                                     0)
   else
      I_InsererModeleCourantDansVoixCourante(Curseur.GetiMesure,
                                     Curseur.GetiIndice,
                                     a_hn,
                                     Curseur.GetiPorteeEditee,
                                     Composition.GetMesure(Curseur.GetiMesure).pixWidth);

    Curseur.DR_ElementMusicalSuivantPasDessus;
//    Curseur.DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante;

    FaireVoirMesure(Curseur.GetiMesure);

    MusicGraph_Canvas_Set(Canvas); //PAS PROPRE

End;




Function TMDIChild.I_InsererNoteDansVoixCourante(a_hn: THauteurNote): Boolean;
Begin
   if Curseur.Is_SurMesure_FinaleAAjouter then
          I_InsererNoteDansVoixCourante(Curseur.GetiMesure,
                                     Curseur.GetiIndice,
                                     a_hn,
                                     Curseur.GetiPorteeEditee,
                                     0)
   else
      I_InsererNoteDansVoixCourante(Curseur.GetiMesure,
                                     Curseur.GetiIndice,
                                     a_hn,
                                     Curseur.GetiPorteeEditee,
                                     Composition.GetMesure(Curseur.GetiMesure).pixWidth);

    Curseur.DR_ElementMusicalSuivantPasDessus;
//    Curseur.DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante;

//    FaireVoirMesure(Curseur.GetiMesure);

    MusicGraph_Canvas_Set(Canvas); //PAS PROPRE!!

End;





Function TMDIChild.I_InsererNoteDansVoixCourante(mes, ind: integer;
                                                         a_hn: THauteurNote;
                                                         portee, x: integer): Boolean;
{insère, à la position définie dans "possscur", le modèle sélectionné, dans la
 voix courante (désignée par la variable VoixSelectionnee), dans la mesure "mes",
 à l'indice "ind", dans la portée "portee",
 "x" désigne la position du curseur souris dans la mesure (c là pour l'animation)

 renvoie vrai en cas de succès}


var
    newNote: TNote;
    newnotes: TElMusical;
    infoclef : TInfoClef;

Begin
      Composition.VerifierIndiceMesureOuDerniere(mes, 'I_InsererModeleCourantDansVoixCourante');
      VerifierHauteurNote(a_hn, 'I_InsererModeleCourantDansVoixCourante');

      Piano_Touches_Enfoncer_Puis_Relever(a_hn);
      result := true;

      if mes = Composition.NbMesures then
      Begin
          Composition.AddMesureFin;
          Composition.Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, mes);
      End;

      Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, mes);
      Composition.Cancellation_Etape_Ajouter_FinDescription('insertion d''une note (sans durée)',
                                                            Curseur.InfoTxtGet_Mesure_Temps,
                                                            Curseur.GetiVoixSelectionnee );
      With Composition.GetMesure(mes) do
      Begin
            infoclef := Composition.InfoClef_DetecterAvecrelX(
                                       Curseur.GetiPorteeEditee,
                                       Curseur.GetiMesure,
                                       Curseur.GetPixx_in_mesure);
                                       
            newNote.Selectionne := svDeSelectionnee;
            newNote.hauteurnote := a_hn;
            newNote.position.portee := portee;
            newNote.position.hauteur := HauteurAbsToHauteurGraphique(infoclef, a_hn.hauteur);

            newNote.BouleADroite := 0;

            Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(newNote);

      
            newnotes := CreerElMusical1Note(DureeCourante_Get, newNote );

            newnotes.Ecouter;
            VoixNum(Curseur.GetiVoixSelectionnee).AddElMusical(ind, newnotes);
      End;

      //DemarrerAnimationMesure(mes);


end;




Function TMDIChild.I_InsererModeleCourantDansVoixCourante(mes, ind: integer;
                                                         a_hn: THauteurNote;
                                                         portee, x: integer): Boolean;
{insère, à la position définie dans "possscur", le modèle sélectionné, dans la
 voix courante (désignée par la variable VoixSelectionnee), dans la mesure "mes",
 à l'indice "ind", dans la portée "portee",
 "x" désigne la position du curseur souris dans la mesure (c là pour l'animation)

 renvoie vrai en cas de succès}


var j, k:integer;
    newNote: TNote;
    nn, newnotes: TElMusical;
    infoclef : TInfoClef;
    hn, hnnew: THauteurNote;
Begin
      Composition.VerifierIndiceMesureOuDerniere(mes, 'I_InsererModeleCourantDansVoixCourante');
      VerifierHauteurNote(a_hn, 'I_InsererModeleCourantDansVoixCourante');

      Piano_Touches_Enfoncer_Puis_Relever(a_hn);
      result := true;

      if mes = Composition.NbMesures then
      Begin
          Composition.AddMesureFin;
          Composition.Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, mes);
      End;

      Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, mes);
      Composition.Cancellation_Etape_Ajouter_FinDescription('insertion d''' + ModeleCourant_Description_Get(a_hn),
                                                            Curseur.InfoTxtGet_Mesure_Temps,
                                                            Curseur.GetiVoixSelectionnee );
      With Composition.GetMesure(mes) do
      Begin
      For k := 0 to high(Modeles[ModeleSousCurseur].Voix.ElMusicaux) do
      Begin
            nn := Modeles[ModeleSousCurseur].Voix.ElMusicaux[k];
            newnotes := CopieElMusicalSaufNote(nn);
            newnotes.pixx := nn.pixx - Modeles[ModeleSousCurseur].Voix.ElMusicaux[0].pixx + x;

             if Modeles[ModeleSousCurseur].Voix.ElMusicaux[k].IsSilence then {insertion d'une pause}
             {pour une pause, on l'insère à la position verticale du curseur}
                      newnotes.position := Souris_Curseur_Position;

                      {I_InsererModeleCourantDansVoixCourante}
            {insertion d'un groupe de notes (si pause high(nn.Notes) = -1 et rien se passe}
            for j := 0 to high(nn.Notes) do
            Begin

                   infoclef := Composition.InfoClef_DetecterAvecrelX(
                                       Souris_Curseur_Position.portee, MesureCourante, Souris_Curseur_Xdansmesure);

                   hn.hauteur := HauteurGraphiqueToHauteurAbs(ClefToInfoClef(clefSol),
                                                              nn.Notes[j].position.hauteur);
                   hn.alteration := nn.Notes[j].hauteurnote.alteration;
                   GetHauteurNote(a_hn, hn, hnnew);
                   newNote.Selectionne := svDeSelectionnee;
                   newNote.hauteurnote := hnnew;
                   newNote.position.portee := portee;
                   newNote.position.hauteur := HauteurAbsToHauteurGraphique(infoclef, hnnew.hauteur);

                   newNote.BouleADroite := 0;

                   Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(newNote);

                   newnotes.AddNote(newNote);


            end;

            {on écoute le premier él. musical du modèle}
            if k = 0 then
                newnotes.Ecouter;
            VoixNum(Curseur.GetiVoixSelectionnee).AddElMusical(ind + k, newnotes);

      end;
      DemarrerAnimationMesure(mes);
      end;

end;





procedure TMDIChild.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) then Exit;
    Console_AjouterLigne('Form_KeyUp appelé');

    if MusicUser_MusicWriter_Mode_Get = mw_mode_Enregistrer then
          frmEnregistreur.FormKeyUp(Sender, Key, Shift);

    if Key = VK_CONTROL then
    Begin
       BoutonControleDejaActif := false;
       if OutilPlus = opDeplacerClavier then
         Begin
            MettreAJourNotesADeplacees(false, false, Deplacement_IsSurTablature);
            OutilPlus := opRien;
            ReaffichageComplet;

         End;
    end;

    if ssCtrl in Shift then
    Begin
         BoutonCtrlActive := false;
         if OutilPlus <> opDeplacerClavier then
              OutilPlus := opRien;
    End;

end;












procedure TMDIChild.tmrSourisCurseur_Clignotement_TimerTimer(Sender: TObject);
begin
        if SourisCurseur_Clignotement_Etat = scceCouleurVoixNote then
               SourisCurseur_Clignotement_Etat := scceGrise
        else
               SourisCurseur_Clignotement_Etat := scceCouleurVoixNote;


        FormPaint(nil);

end;






Procedure TMDIChild.AfficherLeToutClignotant;
const pas = 3;
      pas2 = pas * 2;
      
var i,l,m,x1,x2: integer;
    a: integer;
Begin
      IGP := Composition;
      i := AffichageClignotant_Indice mod pas2;

      x1 := GetX(0);
      x2 := GetX(ClientWidth);
      if i > pas then
           i := pas-(i-pas);

      a :=round(255 * i div pas);

      With Composition do
      for l := Optimisation_Affichage_ilignehaut to Optimisation_Affichage_ilignebas do
      Begin
           IGiLigne := l;
        
              For m := max(GetMesureSurLigne(l, x1),
                           Lignes[Optimisation_Affichage_ilignehaut].mdeb)
                    to min(GetMesureSurLigne(l, x2),
                           LignesMFin(Optimisation_Affichage_ilignebas)) do
                 With GetMesure(m) do
                 if ErreurDansMesure then
                 Begin
                       SetOriginMesure(m);
                       C.Pen.Color := RGB(255, a, a);
                       DrawBarZigZag(pixWidth, Composition,l);

                 End;
      End;
End;


procedure TMDIChild.tmrAffichageClignotantTimer(Sender: TObject);
begin
      {on évite tout affichage si on est en train d'imprimer}
      if IsEnTrainDImprimer then
           exit;


      inc(AffichageClignotant_Indice);
      if MusicGraph_Canvas_IsLocked then exit;
      
      MusicGraph_Canvas_Set(Canvas);
      MettreAJourCentrageScrollBar;
      AfficherLeToutClignotant;

end;

procedure TMDIChild.FormDeactivate(Sender: TObject);
begin
    tmrAffichageClignotant.Enabled := false;
    tmrCurseurClavier.Enabled := false;
    IGP := nil;

    if Screen.ActiveForm <> MainForm then
       Magnetophone_Stop_SansChangerMode;
    {if ActiveMDIChild <> self then
        Magnetophone_Stop_SansChangerMode;  }
end;


procedure TMDIChild.VScrollBarChange(Sender: TObject);
var deltax, deltay, deltascrx, deltascry
     : integer;

begin
    if private_VScrollBarChange_IgnorerEvenement then
        exit;
    if (Sender <> nil) and not option_RedessinerQuandScrollBar then
              Exit;
    {Si on change la valeur de la scrollbar, et qu'on est en train d'y toucher,
     (en train de faire joujou avec, mais qu'on a pas fini) ET que en plus
     on ne permet de redessiner entre temps pour des raisons d'optimisatino
     alors on s'en va... (cf VScrollBarScroll)}

    deltax := HScrollBar.Position - (View.pixxdeb + 80);
    deltay := VScrollBar.Position - (View.pixydeb + 320);

    deltascrx := deltax * Zoom div ZoomMaxPrec;
    deltascry := deltay * Zoom div ZoomMaxPrec;

    if UtiliserBackBuffer then
    Begin
          BlitterToutDuBackBuffer := true;
          MusicGraph_Canvas_Set(BackBuffer.canvas);
          C.Draw(-deltascrx, -deltascry, BackBuffer);

          MettreAJourCentrageScrollBar;

          ReaffichageComplet;


    end;


       FormPaint(nil);






end;

procedure TMDIChild.VScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
   if (ScrollCode = scEndScroll) then
       VScrollBarChange(nil);
end;

procedure TMDIChild.tmrDemarrerAnimationEditionMesureTimer(
  Sender: TObject);
begin
    if MusicWriter_Erreur_IsEtatErreur then
        exit;
    
    dec(Animation_ElMusicaux_Indice);
    if Animation_ElMusicaux_Indice <= 0 then
    Begin
        //DEBUT DEBUG
        if not Composition.IsIndiceMesureValide(Animation_ElMusicaux_iMesure) then
               MessageErreur('DEBUG : Animation_ElMusicaux_iMesure n''est pas une indice valide' +
                                   'dans tmrDemarrerAnimationEditionMesureTimer')
        else
        //FIN DEBUG
             Composition.GetMesure(Animation_ElMusicaux_iMesure).RemplirLastPixx;


        Animation_ElMusicaux_iMesure := -1;
        tmrDemarrerAnimationEditionMesure.enabled := false;
    End;
    ReaffichageComplet;
end;

procedure TMDIChild.tmrDefilTimerTimer(Sender: TObject);
{s'occupe de faire défiler (scrollbar) l'affichage avec une animation}
begin
        VScrollBar.Position := (AnimDefil_lastVscr * AnimDefil_Indice + AnimDefil_currentVScr *
                                     (NbFrameAnim - AnimDefil_Indice)) div NbFrameAnim;
        HScrollBar.Position := (AnimDefil_lastHscr * AnimDefil_Indice + AnimDefil_currentHScr
                                   * (NbFrameAnim - AnimDefil_Indice)) div NbFrameAnim;

        AnimDefil_lastVscr := VScrollBar.Position;
        AnimDefil_lastHscr := HScrollBar.Position;
        
        if AnimDefil_Indice = 0 then
        Begin
             tmrDefilTimer.Enabled := false;
             Console_Defil(cdEteint);
        End
        else
             dec(AnimDefil_Indice);
end;

procedure TMDIChild.FormDblClick(Sender: TObject);
begin

if NoteSousCurseur <> nil then
     Notesquisontdessi1Click(nil)
else
     Begin
              OutilPlus := opRien;
              If Is_GraphicObjet_SousCurseur then
                  frmNuances_Show;

     End;

end;

procedure TMDIChild.Couper1Click(Sender: TObject);
begin
MainForm.CutItemClick(Sender);
end;

procedure TMDIChild.Coper1Click(Sender: TObject);
begin
MainForm.CopyItemClick(Sender);
end;

procedure TMDIChild.FormKeyPress(Sender: TObject; var Key: Char);



begin

              if Key = 'f' then
                  frmFonctionsAccess.ShowModal;

              if Key = 'u' then
              Begin
                 //une note
                 ModeleSousCurseur := 0;
                 FormPaint(nil);
              End
              else if Key = 'p' then
              Begin
                 ModeleSousCurseur := 1;
                 FormPaint(nil);
              End
              else if key = 'm' then
                      UserChroma(1)
              else if key = 'd' then
                      UserChroma(-1);



end;

procedure TMDIChild.Noteduhaut1Click(Sender: TObject);
begin
Composition.Selection_FaireSubSelection(1);
ReaffichageComplet;
end;

procedure TMDIChild.Notesdubas1Click(Sender: TObject);
begin
Composition.Selection_FaireSubSelection(0);
ReaffichageComplet;
end;




procedure TMDIChild.Duneoctaveverslehaut1Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Déplacer les notes d''une octave vers le haut');
    With Composition do
    Begin
        Selection_DeplacerDUneOctaveVersLeHautNotesSelectionnees;
        PaginerApresModifSelection(false);
    end;

    ReaffichageComplet;
end;







    
procedure TMDIChild.Duneoctaveverslebas1Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Déplacer les notes d''une octave vers le bas');
    With Composition do
    Begin
        Selection_DeplacerDUneOctaveVersLeBasNotesSelectionnees;
        PaginerApresModifSelection(false);
    end;

    ReaffichageComplet;
end;

procedure TMDIChild.Coller1Click(Sender: TObject);
begin
MainForm.PasteItemClick(sender);
end;

procedure TMDIChild.Collereninversant1Click(Sender: TObject);
begin
MainForm.Collereninversant1Click(sender);
end;



procedure TMDIChild.I_Selection_Supprimer;
var imesdebutselection: integer;
    itempsdebutselection: TRationnel;

begin
    imesdebutselection := Composition.Selection_Getimesdebutselection;
    {on sauvegarde la valeur de la première mesure dans laquelle il y a une
    sélection... en fait ça sert...
    car DelSelection va tout déselectionner...et du coup on perd cette valeur
    qui est importante pour faire la pagination...
    et il est important que la pagination soit faite... sinon
    mgoi n'est pas à jour... et alterationlocale plante....}
    itempsdebutselection := Composition.Selection_TempsDebut;

    TimerDebugger_Init;
    Composition.I_Selection_Supprimer('Suppression de la sélection');



    CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
    TimerDebugger_FinEtape('CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc');

    I_Selection_MettreAJourInfo;
    TimerDebugger_FinEtape('I_Selection_MettreAJourInfo');

    {Supprimer1Click}
    Curseur.DA_SetAvecTemps(Curseur.GetiVoixSelectionnee,
                            imesdebutselection,
                            itempsdebutselection,
                            Position_Creer(0, 0));
    TimerDebugger_FinEtape('Curseur.DA_SetAvecTemps');

    ReaffichageComplet;
    TimerDebugger_FinEtape('ReaffichageComplet');

    DemarrerAnimationMesure(imesdebutselection);
    {rem : pas besoin de réafficher l'écran, étant donné qu'on a initialisé
     une animation !!}

     MusicUser_MusicWriter_Mode_RevenirAuModeEcritureSiYavait;

     Console_AjouterLigne(TimerDebugger_GetTexte);


End;

procedure TMDIChild.Supprimer1Click(Sender: TObject);
Begin
    I_Selection_Supprimer;
end;

procedure TMDIChild.Lirepartirdici1Click(Sender: TObject);
begin
     Magnetophone_Curseur := TMagnetophone_Curseur_Creer(Composition,
                                    Curseur_Souris.GetiMesure,
                                    Curseur_Souris.GetTempsDepuisDebutMesure);
     Magnetophone_Lecture;
end;




procedure TMDIChild.I_AfficherQuunePortee(p: integer);
var i: integer;
Begin
    Composition.VerifierIndicePortee(p, 'I_AfficherQuunePortee');


    for i := 0 to high(View.VoixAffichee) do
       View.VoixAffichee[i] := (i mod Composition.NbPortees) = p;

//    View.ModeAffichage := maPage;
    LesPorteesSontDessinesAZoomDefaut := true;
    SetCurrentView;

    tbnModePageClean.Down := true;
    tbnModePageCleanClick(nil);
    

End;

procedure TMDIChild.I_AfficherToutesLesPortees;
var i: integer;
Begin

      LesPorteesSontDessinesAZoomDefaut := false;

      for i := 0 to high(View.VoixAffichee) do
           View.VoixAffichee[i] := true;

      SetCurrentView;
      Composition.CalcTout(true);
      ReaffichageComplet;
End;


procedure TMDIChild.mnuJusteCettePorteeClick(Sender: TObject);
begin
   I_AfficherQuunePortee(Curseur.GetiPortee);

end;

procedure TMDIChild.outeslesportes1Click(Sender: TObject);
begin
     I_AfficherToutesLesPortees;

end;

procedure TMDIChild.mnuEcrireDansLaVoixSousLeCurseurClick(Sender: TObject);
begin
      Voix_Gestion_ModeAutomatique_Set(false);
      VoixSelectionnee_Changer(mnuEcrireDansLaVoixSousLeCurseur.Tag);
      MainForm.panVoixSelectionnee.Repaint;


end;

procedure TMDIChild.mnuEcrireDansUneNouvelleVoixClick(Sender: TObject);
begin
    Voix_Gestion_ModeNouvelleVoix_Set;
end;






procedure TMDIChild.Notesquisontdessi1Click(Sender: TObject);
{nom de la procédure : "Notes qui sont des si"
 déselectionne les notes qui ne sont pas pareil que NoteSousCurseur

 ex: si NoteSousCurseur pointe sur un "si", ne reste sélectionné que les "si"}

begin

    {Composition.AppliquerAuxNotesSelectionnees(
               traitement_desselectionnernotesdifferentesdenotesouscurseur);}
    if NoteSousCurseur = nil then
          MessageErreur('erreur :  NoteSousCurseur à nil !')
    else
    Composition.Selection_DeSelectionnerNoteQuiNeSontPasDes(
                                         NoteSousCurseur^.HauteurNote.Hauteur);
    ReaffichageComplet;
end;


procedure TMDIChild.PopupMenuSelectionPopup(Sender: TObject);



Begin

      PopupMenuSelection_Quoi.Caption := Composition.InfoSelectionToStr;

      if NoteSousCurseur <> nil then
      Begin
            Notesquisontdessi1.Caption := Langues_Traduire_Avec_Args('Notes qui sont des "%s"',
                                                [HauteurNoteToStrNomNoteJuste(NoteSousCurseur^.hauteurNote)]);

            Notesquisontdessi1.Visible := true;
      End
      else
             Notesquisontdessi1.Visible := false;

      mnuSelection_Deplacer_Voix.Enabled :=
                         (Composition.Selection_Instrument_Portee_Get > -1);

      mnuCyclerlesvoix_DansMenuSelection.Tag := CycleVoix_ProchaineVoixCourante(Curseur.GetiVoixSelectionnee);


      mnuSelection_PlacerDansVoixCourante.Tag := Curseur.GetiVoixSelectionnee;
      mnuSelection_PlacerDansVoixNouvelle.Tag := Composition.Voix_Nouvel_Indice(Curseur.GetiMesure, Curseur.GetiPortee);;




end;



procedure TMDIChild.Voixautomatiquecriredanslesvoixpardfaut1Click(
  Sender: TObject);
begin
    Voix_Gestion_ModeAutomatique_Set(true);
end;



procedure TMDIChild.ModifClefPortee(Sender: TObject);
begin
    Composition.I_Portee_Clef[Souris_Curseur_Position.portee] := TClef(TMenuItem(Sender).Tag);
    Composition.CalcTout(false);
    ReaffichageComplet;
end;




procedure TMDIChild.I_Tonalite_Modifier(apartirdelamesure : integer;
                                        tonalite: TTonalite);
const
   comportementJUSQU_A_LA_FIN_DE_LA_SECTION = 0;
   comportementJUSQU_A_LA_FIN_DU_DOCUMENT = 1;
   comportementJUSTE_CETTE_MESURE = 2;

var valcourante: TTonalite;
    m: integer;
    comportement: integer;


Begin
    valcourante := Composition.GetMesure(apartirdelamesure).GetTonalite;

    m := apartirdelamesure+1;
    {oui, on affecte une valeur à m car sinon, m est peut
     être indéfini}
    for m := apartirdelamesure+1 to Composition.NbMesures - 1 do
          if not (Composition.GetMesure(m).GetTonalite = valcourante) then
               break;


    if m = Composition.NbMesures then
        comportement := comportementJUSQU_A_LA_FIN_DE_LA_SECTION
    else
    Begin
        Choix_Reset;
        Choix_SetBlabla('Appliquer la modification de tonalité ' + TonaliteToStr(tonalite) + '...');
        Choix_Ajouter('...jusqu''à la prochaine section (ie jusqu''à la mesure n° ' + inttostr(m) + ' incluse)');
        Choix_Ajouter('...jusqu''à la fin du document');
        Choix_Ajouter('...juste à cette mesure (mesure n° ' + inttostr(MesureCourante+1) + ')');
        comportement := Choix_Afficher;

        if Choix_IsCancelled(comportement) then exit;
    End;

    if comportement = comportementJUSQU_A_LA_FIN_DU_DOCUMENT then
       m := Composition.NbMesures;

    if comportement = comportementJUSTE_CETTE_MESURE then
       m := apartirdelamesure+1;


    Composition.I_Mesures_Tonalite_Set(apartirdelamesure, m-1, tonalite);

    
    ReaffichageComplet;

End;




procedure TMDIChild.I_Rythme_Modifier(apartirdelamesure : integer;
                                      rythme: TRationnel);
var valcourante: TRationnel;
    m: integer;
    comportement: integer;

Begin
    valcourante := Composition.GetMesure(apartirdelamesure).Rythme;

    m := MesureCourante+1;
    {oui, on affecte une valeur à m car sinon, m est peut
     être indéfini}
    for m := apartirdelamesure+1 to Composition.NbMesures - 1 do
          if not IsQEgal(Composition.GetMesure(m).Rythme, valcourante) then
               break;

    
    if MesureCourante = Composition.NbMesures then
        comportement := 2
    else if m = Composition.NbMesures then
        comportement := 0
    else
    Begin
        Choix_Reset;
        Choix_SetBlabla('Appliquer la modification de rythme en ' + QToStr(rythme) + '...');
        Choix_Ajouter('...jusqu''à la prochaine section (ie jusqu''à la mesure n° ' + inttostr(m) + ' incluse)');
        Choix_Ajouter('...jusqu''à la fin du document');
        Choix_Ajouter('...juste à cette mesure (mesure n° ' + inttostr(MesureCourante+1) + ')');
        comportement := Choix_Afficher;
        
        if comportement < 0 then exit;
    End;

    if comportement = 1 then
       m := Composition.NbMesures;

    if comportement = 2 then
       m := apartirdelamesure+1;


    Composition.I_Mesures_Rythme_Set(apartirdelamesure, m-1, rythme);

    ReaffichageComplet;
End;



Function SenderTagToRationnel(tag: integer): TRationnel;
Begin
    case tag of
        0: result := QelReally(4, 4);
        1: result := QelReally(3, 4);
        2: result := QelReally(2, 4);
        3: result := QelReally(6, 8);
        else
           MessageErreur('Erreur dans SenderTagToRationnel');
           result := QelReally(1, 1);
    end;
End;



procedure TMDIChild.ModifRythme(Sender: TObject);
Begin
    I_Rythme_Modifier(GetRythmeOUTonalite_iMesure, SenderTagToRationnel(TControl(Sender).Tag));

End;


procedure TMDIChild.Insrerunemesureavant1Click(Sender: TObject);
begin
    Composition.I_Mesures_Ajouter_Mesure_Vide(Curseur.GetiMesure, '(insertion avant)');
    ReaffichageComplet;
end;

procedure TMDIChild.Insrerunemesureaprs1Click(Sender: TObject);
begin
    Composition.I_Mesures_Ajouter_Mesure_Vide(Curseur.GetiMesure+1, '(insertion après)');
    ReaffichageComplet;
end;

procedure TMDIChild.Queueverslehaut1Click(Sender: TObject);
var m, v, i: integer;
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Queue vers le haut');
    With Composition do
    Begin
        For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
         With GetMesure(m) do
              For v := 0 to high(Voix) do With Voix[v] do if IsAffichee then
                 For i := 0 to high(ElMusicaux) do
                      if ElMusicaux[i].IsSelectionne then
                              ElMusicaux[i].QueueVersBas := false;

           PaginerApresModifSelection(false);
    end;

    ReaffichageComplet;
end;

procedure TMDIChild.Queueverslebas1Click(Sender: TObject);
var m, v, i: integer;
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Queue vers le bas');
    With Composition do
    Begin
        For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
        With GetMesure(m) do
              For v := 0 to high(Voix) do With Voix[v] do if IsAffichee then
                 For i := 0 to high(ElMusicaux) do
                      if ElMusicaux[i].IsSelectionne then
                              ElMusicaux[i].QueueVersBas := true;

           PaginerApresModifSelection(false);
    end;

    ReaffichageComplet;
end;

procedure TMDIChild.MnuAltererSelection(Sender: TObject);
begin
     I_Selection_Alterer(TAlteration(TMenuItem(Sender).Tag));
end;

procedure TMDIChild.mnuProprietedelaporteeClick(Sender: TObject);
begin
     frmProprietesPortee_Afficher;

     frmProprietesPortee.SetPorteeSelectionneeDebutEtFin(Curseur.GetiPortee);
    // frmProprietesPortee.

end;

procedure TMDIChild.Extraireunmodle1Click(Sender: TObject);
var im, m, i: integer;
begin
    MessageErreur('TODO : à refaire');
    AjouterModele(im);
    With Composition do
    for m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
         With GetMesure(m).VoixNum(Curseur.GetiVoixSelectionnee) do
            for i := 0 to high(Elmusicaux) do
                Modeles[im].Voix.AddElMusicalFin(ElMusicaux[i].ExtrairePartieSelectionnee);


    if Modeles[im].Voix.IsVide then
    Begin
       setlength(Modeles, im);
    End;
end;

procedure TMDIChild.tbnModePageEditerClick(Sender: TObject);
begin
    I_ModeAffichage_Set(maPageTouteLesPortees);
end;

procedure TMDIChild.tbnModeRubanClick(Sender: TObject);
begin
    I_ModeAffichage_Set(maRuban);
end;

procedure TMDIChild.I_ModeAffichage_Set(ma: TModeAffichage);
Begin
    I_ModeAffichage_Set_SansAfficher(ma);
    FaireLaPaginationEtLesCalculsPuisAffichageComplet(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);

End;



procedure TMDIChild.I_ModeAffichage_Set_SansAfficher(ma: TModeAffichage);
Begin
    View.ModeAffichage := ma;
    SetCurrentView;
    I_ModeAffichage_MettreAJourInterface;
End;


procedure TMDIChild.I_ModeAffichage_MettreAJourInterface;
Begin
    case View.ModeAffichage of
        maPageTouteLesPortees:
                tbnModePageEditer.Down := true;

        maPage:
                tbnModePageClean.Down := true;

        maRuban:
                tbnModeRuban.Down := true;
    end;

    if actchild = Self then
    With MainForm do
    Begin
        case View.ModeAffichage of
            maPageTouteLesPortees:
                    tbnModePageEditer.Down := true;

            maPage:
                    tbnModePageClean.Down := true;

            maRuban:
                    tbnModeRuban.Down := true;
        end;
    End;
    
    if actchild = Self then
    With MainForm do
    case View.ModeAffichage of
        maPageTouteLesPortees:
                mnuModeAffichage_Modepageavectouteslesportes1.Checked := true;

        maPage:
                mnuModeAffichage_Modepage.Checked := true;

        maRuban:
                mnuModeAffichage_Moderuban.Checked := true;
    end;    
    
End;


procedure TMDIChild.tbnModePageCleanClick(Sender: TObject);
begin
    I_ModeAffichage_Set(maPage);
end;

procedure TMDIChild.Duneoctaveverslehaut2Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Octavier les notes d''une octave vers le haut');
    Composition.Selection_OctavierVersLeHaut;
    FaireLaPaginationEtLesCalculsPuisAffichageComplet(Composition.Selection_Getimesdebutselection,
                                                      Composition.Selection_GetIMesFinSelection,
                                                         true);

end;

procedure TMDIChild.Duneoctaveverslebas2Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Octavier les notes d''une octave vers le bas');
    Composition.Selection_OctavierVersLeBas;
    FaireLaPaginationEtLesCalculsPuisAffichageComplet(Composition.Selection_Getimesdebutselection,
                                                          Composition.Selection_GetIMesFinSelection,
                                                           true);


end;


procedure TMDIChild.UserChroma(nbdemitondiff: integer);
Begin
  Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, Curseur.GetiMesure);
  Composition.Cancellation_Etape_Ajouter_FinDescription('Ajout d''un élément avec l''outil chromatique',
                                                         Curseur.InfoTxtGet_Mesure_Temps,
                                                         Curseur.GetiVoixSelectionnee);

  if MesureCourante < 0 then
       Message_Vite_Fait_Beep_Et_Afficher('On est en dehors de la partition')
  else
  Begin
        if Curseur.Is_SurMesure_FinaleAAjouter or Curseur.Is_Mesure_DebutDeMesure then
                Message_Vite_Fait_Beep_Et_Afficher('On est en début de mesures : on a pas de groupe précédent')
        else with Curseur.GetVoixMesure do
        Begin
                AddElMusical(Curseur.GetiIndice,
                       CreerElMusicalChroma(Curseur.GetElementMusicalPrecedent,
                                            nbdemitondiff,
                                            DureeCourante_Get,
                                            Curseur.GetiPorteeEditee));

                Curseur.DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante;
        End;
        FaireLaPaginationEtLesCalculsPuisAffichageComplet(Curseur.GetiMesure,
                                                                Curseur.GetiMesure,
                                                                true);
  End;
End;




procedure TMDIChild.Continuerlcritureavecunemontechromatique1Click(
  Sender: TObject);
begin
  UserChroma(TMenu(Sender).Tag);

end;





procedure TMDIChild.Selection_Transposer(int: TIntervalle);
var mess: string;
begin

    With Composition do
    Begin
        if Composition.Selection_Transposer_Is_Erreur(int, mess) then
             Message_Vite_Fait_Beep_Et_Afficher(mess)
        else
        Begin

            Cancellation_Etape_Ajouter_Selection('Transposer les notes...');
            Selection_Transposer(int);
            FaireLaPaginationEtLesCalculsPuisAffichageComplet(Selection_Getimesdebutselection,
                                                          Selection_GetIMesFinSelection,
                                                          true);
        End;
    end;

End;



procedure TMDIChild.ArpegerVerslehaut1Click(Sender: TObject);
begin
   ElSC := nil;
   Composition.Cancellation_Etape_Ajouter_Selection('Arpéger !');
   Composition.Selection_Arpeger(asVersLeHaut);

   Composition.CalcTout(true);
   ReaffichageComplet;
end;




Function TMDIChild.CycleVoix_ProchaineVoixCourante(voix_courante: integer): integer;
{Renvoie une autre voix courante parmi un ensemble voix admissibles}
var ens_voix_admissibles: set of byte;
    portee_editee: integer;
    p1, p2: integer;
    p, n: integer;
    voixtrouvee: integer;
Begin

     portee_editee := Souris_Curseur_Position.portee;

     if Composition.Portee_IsTablature(portee_editee) then
         dec(portee_editee);


     Composition.GetGroupePortees(portee_editee, p1, p2);

     ens_voix_admissibles := [];

     {on fait ens_voix_admissibles := ens_voix_admissibles + [p1, p2];
      mais il faut éviter de rajouter les voix des portées de tablatures}
     for p := p1 to p2 do
         if not Composition.Portee_IsTablature(p) then
               ens_voix_admissibles := ens_voix_admissibles + [p];




     if Composition.IsIndiceMesureValide(MesureCourante) then
     Begin

         for p := p1 to p2 do
         if not Composition.Portee_IsTablature(p) then
         Begin
             for n := 0 to 3 do
                  if Composition.GetMesure(MesureCourante)
                     .IsVoixNumPresente(p + n * Composition.NbPortees) then
                          ens_voix_admissibles := ens_voix_admissibles
                                          + [p + n * Composition.NbPortees];

             ens_voix_admissibles := ens_voix_admissibles
             + [Composition.Voix_Nouvel_Indice(MesureCourante, p)];

         End;

           IGP := Composition;
           IGiLigne := LigneCourante;

           {on change de voix dans l'opération de cyclage les voix}
           if not Composition.Portee_IsTablature(Souris_Curseur_Position.portee) then
           if Composition.GetMesure(MesureCourante).DonnerNumVoixSousCurseur(Souris_Curseur_Xdansmesure, Souris_Curseur_Ydansmesure, voixtrouvee) then
            if (voixtrouvee <> voix_courante) and (voixtrouvee in ens_voix_admissibles) then
                   Begin
                        result := voixtrouvee;
                        exit;

                   End;

     End;

     n := voix_courante div Composition.NbPortees + 1;
     p := voix_courante mod Composition.NbPortees;

     while true do
     Begin
         while(p <= p2) do
         Begin
             while(n < 4) do
             Begin
                  if n * Composition.NbPortees + p in ens_voix_admissibles then
                  Begin
                       result := n * Composition.NbPortees + p;
                       exit;
                  End;
                  inc(n);
             End;
             n := 0;
             inc(p);

         End;
         n := 0;
         p := p1;
     End;


End;




procedure TMDIChild.CyclerVoixCourante;
{Choisit une autre voix courante parmi un ensemble voix admissibles}
var iv: integer;
    i: integer;
Begin
     Voix_Liste_Vite_Fait_Reset;
     iv := Curseur.GetiVoixSelectionnee;
     Voix_Liste_Vite_Fait_Voix_Ajouter(iv);
     for i := 0 to 1 do
     Begin
           iv := CycleVoix_ProchaineVoixCourante(iv);
           Voix_Liste_Vite_Fait_Voix_Ajouter(iv);
     End;

     Voix_Liste_Vite_Fait_Voix_Show;

     Voix_Gestion_ModeAutomatique_Set(false);
     IGP := Composition;
     VoixSelectionnee_Changer(CycleVoix_ProchaineVoixCourante(Curseur.GetiVoixSelectionnee));

End;

procedure TMDIChild.mnuCyclerlesvoixClick(Sender: TObject);
begin
      CyclerVoixCourante;
end;

procedure TMDIChild.mnuCyclerlesvoix_DansMenuSelectionClick(Sender: TObject);
begin
       CyclerVoixCourante;
end;



procedure TMDIChild.mnuSupprimerlamesureClick(Sender: TObject);
begin
     I_Mesure_Supprimer(MesureCourante);
end;

procedure TMDIChild.Modifierlatonalit1Click(Sender: TObject);
begin
    frmMesures_Tonalite.ShowModal;
end;



procedure TMDIChild.tmrFormResizingTimer(Sender: TObject);
begin
{le composant tmrFormResizing est une feinte :
 => pour éviter que ça mette une note, quand on redimensionne la fenêtre...
 cf mouseup au début}

      tmrFormResizing.Enabled := false;
end;

procedure TMDIChild.Calculerlarrache1Click(Sender: TObject);
begin
if GetRythmeOUTonalite_iMesure = Composition.NbMesures then
     exit;

Composition.GetMesure(GetRythmeOUTonalite_iMesure).CalculerALarracheLeRythme;
ReaffichageComplet;
end;

procedure TMDIChild.mnuTransposerClick(Sender: TObject);
begin
    frmTransposition_Showmodal;
end;

procedure TMDIChild.Unlmentmusicalsur21Click(Sender: TObject);
begin
    Composition.Selection_FaireSubSelection1elmusSur2;
    ReaffichageComplet;
end;

procedure TMDIChild.ArpegerVerslebas1Click(Sender: TObject);
begin
   ElSC := nil;
   Composition.Cancellation_Etape_Ajouter_Selection('Arpéger !');
   Composition.Selection_Arpeger(asVersLeBas);

   Composition.CalcTout(true);
   ReaffichageComplet;
end;





procedure TMDIChild.Collerdesgrosaccords1Click(Sender: TObject);


begin
     if PressePapier.IsVide then
         Message_Vite_Fait_Beep_Et_Afficher('Impossible de coller : le presse-papier est vide ! Il faut d''abord copier ou couper quelquechose !')
     else
     Begin
         Composition.Cancellation_Etape_Ajouter_Selection('Collage fusion !');
         Composition.CollerGrosAccord(PressePapier, Curseur.GetiMesure,
                                      Curseur.GetTempsDepuisDebutMesure);
         Composition.CalcTout(true);

         ReaffichageComplet;
     End;
end;

procedure TMDIChild.Fusionner1Click(Sender: TObject);
begin
    ElSC := nil;
    Composition.Cancellation_Etape_Ajouter_Selection('Fusionner des notes !');

    Composition.Selection_FusionnerLesNotesEnUnElementMusical;
    CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
    Composition.CalcTout(true);
    ReaffichageComplet;

    Composition.Selection_VerifierSelectionValide;

    
end;

procedure TMDIChild.Multiplierlesdurespar21Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Multiplier les durées par 2 !');

    Composition.Selection_MultiplierDuree(Qel(2));
    Composition.CalcTout(true);
    ReaffichageComplet;
end;

procedure TMDIChild.Diviserlesdurespar21Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Diviser les durées par 2 !');

    Composition.Selection_MultiplierDuree(Qel(1,2));
    Composition.CalcTout(true);
    ReaffichageComplet;
end;

procedure TMDIChild.Rendrejolilamesure1Click(Sender: TObject);
begin
    Composition.GetMesure(MesureCourante).CalcQueuePositionAutomatiquement;
    Composition.CalcTout(true);
    ReaffichageComplet;
end;

procedure TMDIChild.Simplifierlcrituredelamesure1Click(Sender: TObject);
begin
    Composition.GetMesure(MesureCourante).SimplifierEcriture;
    Composition.CalcTout(true);
    ReaffichageComplet;
end;

procedure TMDIChild.Enfairepleinpareil1Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Fusionner des notes et faire tout plein de bonhommes !');

    Composition.Selection_FusionnerLesNotesEtEnFaireDesPleinsPareil;

    Composition.CalcTout(true);
    ReaffichageComplet;

    Composition.Selection_VerifierSelectionValide;
end;

procedure TMDIChild.Multiplierlesdurespar21MeasureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
begin
   Width := ACanvas.TextWidth(TMenuItem(Sender).Caption) +
            TMenuItem(Sender).Bitmap.Width + 70;
   Height := 40;
end;







procedure TMDIChild.Multiplierlesdurespar21DrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
      //pour dessiner le cadre de sélection
      ACanvas.FillRect(ARect);

      ACanvas.TextOut(20 + ARect.Left, 13 + ARect.Top, TMenuItem(Sender).Caption);

      ACanvas.Draw(60 + ACanvas.TextWidth(TMenuItem(Sender).Caption) + ARect.Left,
                   0 + ARect.Top, TMenuItem(Sender).Bitmap);
end;

procedure TMDIChild.Mettrebarresdemesures1Click(Sender: TObject);
var nv_fin_mes: integer;
begin
   MusicUser_Pourcentage_Init('Mettre des barres');

   Composition.Selection_ToutDeselectionner;
   MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
   nv_fin_mes := actchild.Composition.BarresMesuresMettre(
                     MettreBarreMesuresBouton_iMesure,
                     MettreBarreMesuresBouton_iMesure,
                     Composition.GetMesure(MettreBarreMesuresBouton_iMesure).Rythme);


    CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
    Composition.PaginerApartirMes(MettreBarreMesuresBouton_iMesure, true);

    Composition.Cancellation_Etape_Ajouter_FinDescription('Modification du rythme des mesures' +
                                                          ' et placement des barres de la mesure',
                            'mes. n°'
                            + inttostr(MettreBarreMesuresBouton_iMesure) + ' à n°' +
                            inttostr(MettreBarreMesuresBouton_iMesure),
                            VOIX_PAS_D_INFORMATION);

    MusicUser_Pourcentage_Free;

    ReaffichageComplet;

    MettreBarreMesuresBouton_Desactiver;
end;

procedure TMDIChild.Laissertelquel1Click(Sender: TObject);
begin
    MettreBarreMesuresBouton_Desactiver;
end;

procedure TMDIChild.Mettrebarresdemesuresencrivantsurlasuite1Click(
  Sender: TObject);
begin
    MettreBarreMesuresBouton_Desactiver;
end;

procedure TMDIChild.cmdMettreBarreMesuresClick(Sender: TObject);
begin
    Mettrebarresdemesures1Click(nil);
end;

procedure TMDIChild.mnuBarreDeMesure_SupprimerClick(Sender: TObject);
begin
     actchild.Composition.Cancellation_Etape_Ajouter_FinDescription('Supprimer la barre de mesure',
                                         'Barre entre la mes. n°' + inttostr(BarreDeMesureSousCurseur_iMesure) +
                                         ' et ' + inttostr(BarreDeMesureSousCurseur_iMesure + 1),
                                         VOIX_PAS_D_INFORMATION);
     Composition.FusionnerMesures(BarreDeMesureSousCurseur_iMesure-1, BarreDeMesureSousCurseur_iMesure);
     BarreDeMesureSousCurseur_YenAPlus;
     actchild.Composition.PaginerApartirMes(MettreBarreMesuresBouton_iMesure, true);
     actchild.ReaffichageComplet;
end;

procedure TMDIChild.ChangerTonaliteApartirDeBarreDeMesure(Sender: TObject);
begin
   I_Tonalite_Modifier(BarreDeMesureSousCurseur_iMesure, TMenuItem(Sender).Tag);

end;

procedure TMDIChild.ClefInseree_Modifier(Sender: TObject);
begin
     Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, private_clef_inseree_imesure);
     Composition.Cancellation_Etape_Ajouter_FinDescription('Changement de clef',
                      'mesure ' +
                      inttostr(private_clef_inseree_imesure + 1),
                      VOIX_TOUTES_LES_VOIX);


     Composition.GetMesure(private_clef_inseree_imesure)
       .ClefsInserees[private_clef_inseree_indice].Clef := TClef(TMenuItem(Sender).Tag);

     Composition.PaginerApartirMes(private_clef_inseree_imesure, false);

     ReaffichageComplet;
end;

procedure TMDIChild.ClefInseree_Supprimer(Sender: TObject);
begin
//PRECOND
    if not ClefInseree_Is_SousCurseur then
    Begin
          MessageErreur('ClefInseree_Supprimer : pas de clef sous curseur !');
          Exit;
    End;



    Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, private_clef_inseree_imesure);
    Composition.Cancellation_Etape_Ajouter_FinDescription('Suppression d''une clef',
                     'mesure ' +
                      inttostr(private_clef_inseree_imesure + 1),
                      VOIX_PAS_D_INFORMATION);


    Composition.GetMesure(private_clef_inseree_imesure)
       .Clefs_Del1(private_clef_inseree_indice);

    ClefInseree_SousCurseur_DireQueYenAPas;

    Composition.PaginerApartirMes(private_clef_inseree_imesure, false);

    ReaffichageComplet;
end;

procedure TMDIChild.Doublebarre1Click(Sender: TObject);
begin
    Composition.I_BarreDeMesure_Set(BarreDeMesureSousCurseur_iMesure, btBarreDouble);
    ReaffichageComplet;
end;

procedure TMDIChild.Barredemesuresimple1Click(Sender: TObject);
begin
    Composition.I_BarreDeMesure_Set(BarreDeMesureSousCurseur_iMesure, btBarreSimple);
    ReaffichageComplet;
end;

procedure TMDIChild.Supprimerloctavieur1Click(Sender: TObject);
begin
     Composition.I_Portee_Octavieur_Supprimer(private_octavieur_iportee,
                                              private_octavieur_indice);
     private_octavieur_indice := -1;
     Composition.PaginerApartirMes(MesureCourante, false);
     ReaffichageComplet;
end;

procedure TMDIChild.ChangerTonaliteAuDebut(Sender: TObject);
begin
     I_Tonalite_Modifier(0, TMenuItem(Sender).Tag);

end;

procedure TMDIChild.ChangerRythmeDepuisDebut(Sender: TObject);
begin
      I_Rythme_Modifier(0, SenderTagToRationnel(TControl(Sender).Tag));
end;

procedure TMDIChild.ChangerTonalite(Sender: TObject);
begin
       I_Tonalite_Modifier(GetRythmeOUTonalite_iMesure, TMenuItem(Sender).Tag);
end;

procedure TMDIChild.ChangerRythme(Sender: TObject);
begin
      I_Rythme_Modifier(BarreDeMesureSousCurseur_iMesure, SenderTagToRationnel(TControl(Sender).Tag));
end;


procedure TMDIChild.ChangerTonaliteRT(Sender: TObject);
begin
      I_Tonalite_Modifier(private_rythme_tonalite_imesure_apartirde, TMenuItem(Sender).Tag);
end;


procedure TMDIChild.ChangerRythmeRT(Sender: TObject);
begin
      I_Rythme_Modifier(private_rythme_tonalite_imesure_apartirde, SenderTagToRationnel(TControl(Sender).Tag));
end;

procedure TMDIChild.Jusqulonreprend1Click(Sender: TObject);
begin
    Composition.I_BarreDeMesure_Set(BarreDeMesureSousCurseur_iMesure, btBarreRepriseVersGauche);
    ReaffichageComplet;
end;

procedure TMDIChild.Apartirdelonreprend1Click(Sender: TObject);
begin
   Composition.I_BarreDeMesure_Set(BarreDeMesureSousCurseur_iMesure, btBarreRepriseVersDroite);
    ReaffichageComplet;
end;

procedure TMDIChild.Jusqueletpartirdelonreprend1Click(Sender: TObject);
begin
   Composition.I_BarreDeMesure_Set(BarreDeMesureSousCurseur_iMesure, btBarreRepriseDesDeuxCotes);
    ReaffichageComplet;
end;

procedure TMDIChild.mnuNuance_Supprimer(Sender: TObject);
begin
     GraphicObjet_SousCurseur_Supprimer;
     ReaffichageComplet;
end;

procedure TMDIChild.AfficherlabotededialoguedeNuances1Click(
  Sender: TObject);
begin
    frmNuances_Show;
end;

procedure TMDIChild.mnuNuance_Set(Sender: TObject);
begin
     GraphicObjet_SousCurseur_Get.Nuance_Set(TNuanceValeur(TMenuItem(Sender).Tag));
     ReaffichageComplet;
end;

procedure TMDIChild.objet_graphique_crescendo_transformer(Sender: TObject);
begin
      GraphicObjet_SousCurseur_Get.Crescendo_Set;
      ReaffichageComplet;
end;

procedure TMDIChild.objet_graphique_decrescendo_transformer(
  Sender: TObject);
begin
      GraphicObjet_SousCurseur_Get.DeCrescendo_Set;
      ReaffichageComplet;
end;

procedure TMDIChild.tmrCurseurClavierTimer(Sender: TObject);
begin
     //CurseurClavier_Clignotant_VisibleEnCemoment := not CurseurClavier_Clignotant_VisibleEnCemoment;
     //FormPaint(nil);
end;

procedure TMDIChild.panStatusBarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    Aide_AfficherDansChildWin('mode_affichage', 0, 0, 0);
end;

procedure TMDIChild.tbnModePageEditerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
panStatusBarMouseMove(Sender, Shift, X, Y);
end;

procedure TMDIChild.tbnModeRubanMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
panStatusBarMouseMove(Sender, Shift, X, Y);
end;

procedure TMDIChild.tbnModePageCleanMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
panStatusBarMouseMove(Sender, Shift, X, Y);
end;

procedure TMDIChild.mnuCorde_De_Guitare_Corde_Numero_Click(
  Sender: TObject);
begin
     Composition.Cancellation_Etape_Ajouter_Selection('Changer le numéro de corde des notes');
     Composition.Selection_Tablature_Corde_De_Guitare_Set(TComponent(Sender).Tag);
     ReaffichageComplet;
end;

procedure TMDIChild.Parkinsonner1Click(Sender: TObject);
begin
    Composition.Cancellation_Etape_Ajouter_Selection('Parkinsonner la sélection !');

    Composition.Selection_Parkinsonner(DureeCourante_Get);
    Composition.CalcTout(true);
    ReaffichageComplet;
end;

procedure TMDIChild.PopupMenu_AfficherTitre(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
     MusicUser_PopupMenu_AfficherTitre(Sender,
                                       ACanvas, ARect, Selected);

end;



procedure TMDIChild.PopupBarreDeMesurePopup(Sender: TObject);
var is_barre_fin: Boolean;
begin
   is_barre_fin := BarreDeMesureSousCurseur_iMesure >= Composition.NbMesures;

   
   if not is_barre_fin then
        PopupBarreDeMesure_Titre.Caption := Langues_Traduire_Avec_Args('Barre entre la mesure n°%d et %d',
                                                        [BarreDeMesureSousCurseur_iMesure,
                                                        BarreDeMesureSousCurseur_iMesure + 1])
                         else
       PopupBarreDeMesure_Titre.Caption := Langues_Traduire('Barre finale de la partition');


   Apartirdelonreprend1.Enabled := not is_barre_fin;
   Jusqueletpartirdelonreprend1.Enabled := not is_barre_fin;

   mnuBarreDeMesure_Supprimer.Enabled := not is_barre_fin;
   mnuBarreDeMesure_Tonalites_grp.Enabled := not is_barre_fin;
   mnuBarreDeMesures_Rythme_grp.Enabled := not is_barre_fin;
   Doublebarre1.Enabled := not is_barre_fin;


end;

procedure TMDIChild.PopupMenuClefPopup(Sender: TObject);
var ip: integer;
begin

   ip := Curseur_Souris.GetiPortee;

   PopupMenuClef_Titre.Caption := 
         ClefToStr(
            Composition.I_Portee_Clef[ip]
             )
             +
           ' de la portée n° ' +
           inttostr(ip + 1);
end;

procedure TMDIChild.PopupMenuClefInsereePopup(Sender: TObject);
begin

    PopupMenuClefInseree_Titre.Caption := 'Clef insérée, mes. '
           +
           inttostr(private_clef_inseree_imesure + 1)
           +
           ', portée ' +
           inttostr(private_clef_inseree_iportee + 1);


end;



procedure TMDIChild.PopupMenuCurseurPopup(Sender: TObject);
var affichage_num_mesure: integer;
    affichage_num_portee: integer;


    procedure mnuEcrireDansLaVoixSousLeCurseur_Tag_MettreAJour;
    var X, Y, n_voix, imesure: integer;
    
    Begin
        X := Souris_Curseur_X;
        Y := Souris_Curseur_Y;
        if Composition.FindMesure(x, y, imesure) then
          Begin
                  Composition.GetMesure(imesure).DonnerNumVoixPresCurseur(X, Y, n_voix);
                  mnuEcrireDansLaVoixSousLeCurseur.Tag := n_voix;
                  mnuParolesEcrire.Tag := n_voix;
                  mnuEcrireDansLaVoixSousLeCurseur.Enabled := true;
                  mnuParolesEcrire.Enabled := true;
          End
          else
          Begin
                  mnuEcrireDansLaVoixSousLeCurseur.Enabled := false;
                  mnuParolesEcrire.Enabled := false;
          End;
                  
   End;
begin
     affichage_num_mesure := Curseur.GetiMesure + 1;
     affichage_num_portee := Curseur.GetiPortee + 1;
     
     PopupMenuCurseur_Titre.Caption := Langues_Traduire_Avec_Args('Ici, mesure n°%d, portée n°%d',
                                                [affichage_num_mesure, affichage_num_portee]);

     mnuSupprimerlamesure.Caption := Langues_Traduire_Avec_Args('Supprimer la mesure n°%d', [affichage_num_mesure]);

     mnuProprietedelaportee.Caption := Langues_Traduire_Avec_Args('Propriété de la portée n°%d', [affichage_num_portee]);

     mnuJusteCettePortee.Caption := Langues_Traduire_Avec_Args('Juste cette portée (portée n°%d) (+ bascule en mode page)', [affichage_num_portee]);



     mnuBarredemesure_Inserer.Caption := Langues_Traduire_Avec_Args('Barre de mesure, ie on coupe au temps %s de la mesure n°%d',
                           [QToStr(Curseur_Souris.GetTempsDepuisDebutMesure), Curseur_Souris.GetiMesure+1]);
                                                   
     mnuEcrireDansUneNouvelleVoix.Tag := Composition.Voix_Nouvel_Indice(Curseur.GetiMesure, Curseur.GetiPortee);

     mnuCyclerlesvoix.Tag := CycleVoix_ProchaineVoixCourante(Curseur.GetiVoixSelectionnee);
     
     mnuEcrireDansLaVoixSousLeCurseur_Tag_MettreAJour;



end;

procedure TMDIChild.PopupMenuRythmeEtTonalitePopup(Sender: TObject);
begin
    PopupMenuRythmeEtTonalite_Titre.Caption := Langues_Traduire_Avec_Args('A partir d''ici, mesure n°%d',
                [private_rythme_tonalite_imesure_apartirde + 1]);
end;

procedure TMDIChild.I_AltererSelonUneTonalite(Sender: TObject);
var tonalite:TTonalite;

begin
      frmAlterer_Selon_Une_Tonalite_Show(
          Composition.Tonalites(Curseur.GetiMesure, Curseur.GetiPortee));


      if frmAlterer_Selon_Une_Tonalite.ModalResult = mrOK then
      Begin
           tonalite := frmAlterer_Selon_Une_Tonalite.frameTonalite.Tonalite_Get;
           Composition.Cancellation_Etape_Ajouter_Selection('changement d''altération d''une sélection via la tonalité ' +
                                              TonaliteToStr(tonalite));

           Composition.Selection_Alterer_Selon_Une_Tonalite(tonalite,
                         frmAlterer_Selon_Une_Tonalite.chkNoteSensible.Checked);

           FaireLaPaginationEtLesCalculsPuisAffichageComplet(Composition.Selection_Getimesdebutselection,
                                                                Composition.Selection_GetIMesFinSelection,
                                                                true);

      End;
end;

procedure TMDIChild.mnuMenuGeneriqueAvecInfoVoixMeasureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
begin
//de la place pour indiquer le num de voix
   Width := ACanvas.TextWidth(TMenuItem(Sender).Caption) +
            100 + 70;

end;

procedure TMDIChild.mnuMenuGeneriqueAvecInfoVoixDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var menu: TMenuItem;
begin
      menu := Sender as TMenuItem;

      //pour dessiner le cadre de sélection
      ACanvas.FillRect(Rect(ARect.Left + 16, ARect.top, ARect.Right, AREct.Bottom));


      MainForm.imgList.Draw(ACanvas, ARect.Left, ARect.Top+2, menu.ImageIndex );

      ACanvas.TextOut(20 + ARect.Left, ARect.Top + 2, menu.Caption);

      ACanvas.Font.Style := [fsBold];
      ACanvas.Font.Color := 0;
      
      DrawCadrePresentationVoix(Composition, ACanvas,
                              Rect(10 + ACanvas.TextWidth(menu.Caption) + ARect.Left,
                                   ARect.Top,
                                   ARect.Right - 32,
                                   ARect.Bottom),
                                   menu.Tag,1, false, false);
end;

procedure TMDIChild.PopupMenuPortees_Instruments_Noms_ZonePopup(
  Sender: TObject);
  var p1, p2: integer;

begin
     Composition.GetGroupePortees(Portees_Instruments_Noms_Zone_iPortee, p1, p2);

     if p1 = p2 then
          PopupMenuPortees_Instruments_Noms_Zone_Titre.Caption := Langues_Traduire_Avec_Args('Portée n°%d, nom : %s',
                [p1 + 1,
                Composition.Portee_Groupe_Instrument_NomAAfficher(p1)])
     else
          PopupMenuPortees_Instruments_Noms_Zone_Titre.Caption := Langues_Traduire_Avec_Args('Portées n°%d à %d, nom : %s',
                        [p1 + 1,
                         p2 + 1,
                         Composition.Portee_Groupe_Instrument_NomAAfficher(p1)]);
           
end;

procedure TMDIChild.mnuProprietesdelaporteeClick(Sender: TObject);
       var p1, p2: integer;

begin
     Composition.GetGroupePortees(Portees_Instruments_Noms_Zone_iPortee, p1, p2);

     frmProprietesPortee_Afficher;
     frmProprietesPortee.SetPorteeSelectionneeDebutEtFin(p1, p2);
end;

procedure TMDIChild.PopupMenuInstruments_PorteesPopup(Sender: TObject);
const Gestionnaire_Affichage_Portee_Toutes = -1;

var ip: integer;
    item: TMenuItem;

begin
     PopupMenuInstruments_Portees.Items.Clear;

     ip := 0;
     while ip<Composition.NbPortees do
     Begin
         item := TMenuItem.Create(nil);

         item.Caption := 'Afficher '
                         + Composition.Portee_Groupe_Instrument_NomAAfficher_DansGestionnaireAffichage(ip)
                         + ' seulement';

         item.Tag := ip;

         item.OnClick := PopupMenuInstruments_Portees_Element_Click;
         
         item.ImageIndex := Composition.Portee_InstrumentMIDINum[ip] + 1;
         PopupMenuInstruments_Portees.Items.Add(item);

         inc(ip, Composition.Portee_GetNbPorteesInGroupe(ip) + 1);
     End;

     item := TMenuItem.Create(nil);
     item.Caption := '-';
     PopupMenuInstruments_Portees.Items.Add(item);

     item := TMenuItem.Create(nil);
     item.Caption := 'Afficher ' + Composition.Portee_Groupe_Instrument_NomAAfficher_DansGestionnaireAffichage(Gestionnaire_Affichage_Portee_Toutes);
     item.Tag := -1;
     item.OnClick := PopupMenuInstruments_Portees_Element_Click;
     PopupMenuInstruments_Portees.Items.Add(item);
     


end;



procedure TMDIChild.PopupMenuInstruments_Portees_Element_Click(Sender: TObject);
var menuitem: TMenuItem;


  procedure Partition_Recalcul;
  var v: integer;

      Function Get_Indice_Portee_Visible: integer;
      var ip: integer;
      Begin
          result := 0;
          With View do
          for ip := 0 to High(PorteeAffichee) do
                if PorteeAffichee[ip] then
                Begin
                     result := ip;
                     exit;
                End;

          MessageErreur('Erreur dans PopupMenuInstruments_Portees_Element_Click, ' +
                     'Get_Indice_Portee_Visible !!! Il n''y a donc aucune portée visible ?!');
      End;
      
  Begin
      v := Curseur.GetiVoixSelectionnee;
      if not View.PorteeAffichee[Composition.Voix_Indice_To_Portee(v)] then
           VoixSelectionnee_Changer(Get_Indice_Portee_Visible);

      Composition.CalcTout(true);
      ReaffichageComplet;
  End;



  
  procedure Instruments_Portees_Afficher_Toutes;
  var ip: integer;
  Begin
      With View do
          for ip := 0 to High(PorteeAffichee) do
                PorteeAffichee[ip] := True;

      Partition_Recalcul;
  End;

  procedure Instruments_Portees_Afficher_Que_Instrument(ip1: integer);
  var ip: integer;
  Begin
      With View do
      Begin
          for ip := 0 to High(PorteeAffichee) do
                PorteeAffichee[ip] := False;

          for ip := ip1 to ip1 + Composition.Portee_GetNbPorteesInGroupe(ip1) do
                PorteeAffichee[ip] := True;
      End;

      Partition_Recalcul;
  End;

begin
  menuitem := Sender as TMenuItem;

  if menuitem.Tag = -1 then
       Instruments_Portees_Afficher_Toutes
  else
       Instruments_Portees_Afficher_Que_Instrument(menuitem.Tag);

  panInstruments_Portees.Caption := Composition.Portee_Groupe_Instrument_NomAAfficher_DansGestionnaireAffichage(menuitem.Tag);
end;




procedure TMDIChild.Arrterlalecture1Click(Sender: TObject);
begin
    Magnetophone_Stop;
end;






procedure TMDIChild.mnuBarredemesure_InsererClick(Sender: TObject);
begin
      Composition.I_BarreDeMesure_Ajouter(Curseur_Souris.GetiMesure,
                                          QDiff(Curseur_Souris.GetTempsDepuisDebutMesure, Qel(1)),
                                          '');

      CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
      ReaffichageComplet;
end;

procedure TMDIChild.mnuSelection_Deplacer_VoixClick(Sender: TObject);
begin
      frmSelection_Deplacer_Voix_ShowModal;
end;

procedure TMDIChild.mnuParolesEcrireClick(Sender: TObject);
begin
     frmParoles.SetVoixNum(TMenuItem(Sender).Tag);
     frmParoles.ShowModal;
end;



procedure TMDIChild.Zoom_Set_AuMilieu(zoom: integer);
Begin
     Zoom_Set_VersScrXScrY(zoom, ClientWidth div 2, ClientHeight div 2);
End;




procedure TMDIChild.Zoom_Set_VersScrXScrY(zoom: integer; scrX, scrY: integer);
var za, x, y: integer;
    newpixxdeb, newpixydeb: integer;

const option_Zoom_Min = 20;
const option_Zoom_Max = 800;

Begin
    za := Zoom_Get;

    if zoom < option_Zoom_Min then
         zoom := option_Zoom_Min;

    if zoom > option_Zoom_Max then
          zoom := option_Zoom_Max;

    SetCurrentView;
    x := GetX(Souris_Curseur_ScrX);
    y := GetY(Souris_Curseur_ScrY);

    newpixxdeb := -(za * (x - View.pixxdeb) div zoom - x);
    newpixydeb := -(za * (y - View.pixydeb) div zoom - y);

    private_VScrollBarChange_IgnorerEvenement := true;
    HScrollBar.Position := newpixxdeb + 80;
    VScrollBar.Position := newpixydeb + 320;
    private_VScrollBarChange_IgnorerEvenement := false;

    Zoom_Set(zoom);

    SetCurrentView;
    {
    if abs(GetX(Souris_Curseur_ScrX) - x) > 3 then
         MessageErreur('x = ' + inttostr(x) + ' ; nx = ' + inttostr(GetX(MousePos.X)));

    if abs(GetY(Souris_Curseur_ScrY) - y) > 3 then
         MessageErreur('y = ' + inttostr(y) + ' ; ny = ' + inttostr(GetY(Souris_Curseur_ScrY)));

    Ce tes marche pas bien à cause des approximations dues aux ScrollBar (aux bords)
    }

End;



procedure TMDIChild.Zoom_Set(zoom: integer);
Begin

     View.Zoom := zoom;
     ReaffichageComplet;

     Zoom_MettreAJourMainForm;


End;


procedure TMDIChild.Zoom_MettreAJourMainForm;
   Function ZoomToComposantTick(zoom: integer): integer;
   const tick_de_zoom100 = 50;
    const zoom_min = 20;
    var private_zoom_beta: real;
   
   Begin
       private_zoom_beta := ((1/tick_de_zoom100) * ln(100 / zoom_min));
       result := Round((1 / private_zoom_beta) * ln(zoom / zoom_min));
   End;

   
Begin
    MainForm.trkZoom.Position := ZoomToComposantTick(actchild.View.Zoom);
End;

Function TMDIChild.Zoom_Get: integer;
Begin
    result := View.Zoom;
End;

procedure TMDIChild.tlbAfficherRegleTempsClick(Sender: TObject);
begin
     ReaffichageComplet;
end;

procedure TMDIChild.mnuDuree_ApproximativeClick(Sender: TObject);
begin
    Composition.I_Selection_Duree_Approximative_SwitchTo;

    Composition.CalcTout(true);
    ReaffichageComplet;
end;





procedure TMDIChild.I_AjusterNotesEtAlterationsSelonUneTonalite(
  Sender: TObject);
var tonalite:TTonalite;

begin
      Ajuster_alterations_notes_selon_tonalite_Show(
            Composition.Selection_TonaliteQuiColleLePlus_Get);


      if frmAjuster_Alterations_Notes_Selon_Une_Tonalite.ModalResult = mrOK then
      Begin
           tonalite := frmAjuster_Alterations_Notes_Selon_Une_Tonalite.frameTonalite.Tonalite_Get;
           Composition.Cancellation_Etape_Ajouter_Selection('Enharmoniquer selon la tonalité ' +
                                              TonaliteToStr(tonalite));

           Composition.Selection_Enharmoniquer_Selon_Une_Tonalite(tonalite);

           FaireLaPaginationEtLesCalculsPuisAffichageComplet(Composition.Selection_Getimesdebutselection,
                                                                Composition.Selection_GetIMesFinSelection,
                                                                true);

      End;
end;


procedure TMDIChild.I_Selection_PlacerDansVoix(ivoix: integer);
Begin
    Composition.I_Selection_Deplacer_Voix(ivoix);
    CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
    ReaffichageComplet;

    I_Selection_MettreAJourInfo;
End;


procedure TMDIChild.mnuSelection_PlacerDansVoixCouranteClick(
  Sender: TObject);
begin
    I_Selection_PlacerDansVoix(actchild.Curseur_Souris.GetiVoixSelectionnee);

end;




procedure TMDIChild.mnuSelection_PlacerDansVoixNouvelleClick(Sender: TObject);
var ind_voix: integer;

begin
    ind_voix := Composition.Voix_Nouvel_Indice(Curseur.GetiMesure,
                                               Curseur.GetiPortee);
    I_Selection_PlacerDansVoix(ind_voix);

end;

procedure TMDIChild.I_Selection_FusionnerNotesEtSilences(
  Sender: TObject);
begin
     Composition.I_Selection_FusionnerNotesEtSilences;

     CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
     ReaffichageComplet;
end;

procedure TMDIChild.I_Selection_DureesDiviserParDeuxPuisSilence(
  Sender: TObject);
begin
     Composition.I_Selection_DureesDiviserParDeuxPuisSilence;

     ReaffichageComplet;
end;


Function TMDIChild.Curseur_XDansFenetre_Get: integer;
Begin
    Result := ScrX(Curseur.GetPixx_in_doc);
End;

Function TMDIChild.Curseur_YDansFenetre_Get: integer;
Begin
   Result := ScrY(Curseur.GetPixy_in_doc);
End;


procedure TMDIChild.FormShow(Sender: TObject);
begin
    MusicUser_MusicWriter_Modes_Deballer_SiBesoin;
end;

procedure TMDIChild.Slectionnertouteslesnotessilencesdelapore1Click(
  Sender: TObject);
begin
      Composition.Selection_SelectionnerPortees(Souris_Curseur_Position.portee, Souris_Curseur_Position.portee);
      ReaffichageComplet;
end;

End.

