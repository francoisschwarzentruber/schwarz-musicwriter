unit Main;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
     StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
     ActnList, ToolWin, ImgList, printers,

     MusicSystem_Composition,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_ElMusical,
     
     MusicGraph, MusicUser,
     QSystem, FileSystem, ChildWin, UModeles, MusicHarmonie, MusicWriterToMIDI,
     MusicWriterToWAV,
     MPlayer, MidiNow,
     instruments,
     Ouvrir, frame_Duree_Entree, Magnetophone, frame_Duree_Choix;



     
type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    FileSaveItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    WindowTileItem2: TMenuItem;
    imgNotes: TImageList;
    FilePrintItem: TMenuItem;
    SaveDialog: TSaveDialog;
    Enregistrersous1: TMenuItem;
    imgTrilles: TImageList;
    Mesures: TMenuItem;
    Voix1: TMenuItem;
    ModeVoixautomatique1: TMenuItem;
    Modenouvellevoix1: TMenuItem;
    tmrDbClick: TTimer;
    Notes1: TMenuItem;
    Queueverslehaut1: TMenuItem;
    Queueverslebas1: TMenuItem;
    Porte1: TMenuItem;
    mnuPropPortee: TMenuItem;
    mnuPropMesure: TMenuItem;
    mnuCompilerenfichierMIDI: TMenuItem;
    PrintDialog: TPrintDialog;
    pmnuTonalites: TPopupMenu;
    Domajeurlamineur1: TMenuItem;
    SolmajeurMimineur1: TMenuItem;
    RmajeurLamajeur1: TMenuItem;
    LamajeurFamineur1: TMenuItem;
    MimajeurDomineur1: TMenuItem;
    SimajeurSolmineur1: TMenuItem;
    FamajeurRmineur1: TMenuItem;
    Domajeur1: TMenuItem;
    Famajeurrmineur2: TMenuItem;
    SibmajeurSolmineur1: TMenuItem;
    MibmajeurDomineur1: TMenuItem;
    LabmajeurFamineur1: TMenuItem;
    RbmajeurSibmineur1: TMenuItem;
    SolbmajeurMibmineur1: TMenuItem;
    DobmajeurLabmineur1: TMenuItem;
    N2: TMenuItem;
    TonaliteMilieu: TMenuItem;
    Renverserverslehaut1: TMenuItem;
    mnuRenverserverslebas1: TMenuItem;
    Enharmoniques1: TMenuItem;
    pmnuModeles: TPopupMenu;
    mnuModeleMode: TMenuItem;
    Arpgemontante1: TMenuItem;
    Arpgedescendante1: TMenuItem;
    Recopierenchromatique1: TMenuItem;
    imgDiesesEtBemols: TImageList;
    Passeren1: TMenuItem;
    Lilasuivante1: TMenuItem;
    Affichage1: TMenuItem;
    Pleincran1: TMenuItem;
    Rparerlefichier1: TMenuItem;
    mnuCancel: TMenuItem;
    mnuRefaire: TMenuItem;
    N5: TMenuItem;
    Doigtes1: TMenuItem;
    Nouvellefentre1: TMenuItem;
    pmnuTrilles: TPopupMenu;
    mnuTrilles: TMenuItem;
    Trillebmol1: TMenuItem;
    Trilledise1: TMenuItem;
    mnuTrillesRien: TMenuItem;
    Barredoutils1: TMenuItem;
    mnuDuree: TMenuItem;
    Options1: TMenuItem;
    imgList: TImageList;
    tmrFinMidiNow: TTimer;
    Proprits1: TMenuItem;
    SaveDialogMIDI: TSaveDialog;
    Collereninversant1: TMenuItem;
    imgIconesInstruments: TImageList;
    N3: TMenuItem;
    mnuModeAffichage_Modepage: TMenuItem;
    mnuModeAffichage_Moderuban: TMenuItem;
    Recopierlegroupeprcdent1: TMenuItem;
    mnuModeAffichage_Modepageavectouteslesportes1: TMenuItem;
    pmnuAttrib: TPopupMenu;
    mnuAttributsToutVirer: TMenuItem;
    mnuPique: TMenuItem;
    mnuPizzicato: TMenuItem;
    Gestiondesvoix1: TMenuItem;
    PopupMenuVoix: TPopupMenu;
    Voixautomatiquecriredanslesvoixpardfaut1: TMenuItem;
    Gestiondesvoix2: TMenuItem;
    Ecriredansunenouvellevoix1: TMenuItem;
    tmrHelp: TTimer;
    Cyclervoix1: TMenuItem;
    CompilerenfichierWAV1: TMenuItem;
    N6: TMenuItem;
    mnuCorriger: TMenuItem;
    mnuGenerer: TMenuItem;
    Untrucalatoire1: TMenuItem;
    Outils1: TMenuItem;
    Lettre1: TMenuItem;
    imgNuances: TImageList;
    Clavier1: TMenuItem;
    imgBarres: TImageList;
    Navigateurdepartition1: TMenuItem;
    mnuMidiin: TMenuItem;
    mnuMidiIn_Open: TMenuItem;
    mnuMidiIn_Close: TMenuItem;
    mnuInstruments: TMenuItem;
    StatusBarPosition: TStatusBar;
    mnuBarreEtatPosition: TMenuItem;
    N7: TMenuItem;
    Mettredesparoles1: TMenuItem;
    ControlBarLeft: TPanel;
    cboRythme: TComboBox;
    ImageListMode: TImageList;
    TabSheetFichier: TTabSheet;
    TabSheetNotes: TTabSheet;
    TabSheetSelection: TTabSheet;
    TabSheetClef: TTabSheet;
    TabSheetNuances: TTabSheet;
    tlbNuances: TToolBar;
    tbnNuanceP: TToolButton;
    tbnNuanceMP: TToolButton;
    tbnNuanceMF: TToolButton;
    tbnNuanceF: TToolButton;
    tbnCrescendo: TToolButton;
    tbnDeCrescendo: TToolButton;
    tbnCourbe: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    tmrChangerDown_BoutonChiantDropDown: TTimer;
    mnuConsole: TMenuItem;
    AfficherfentreAnnulerRefaire1: TMenuItem;
    Fentreenregistreurtempsrel1: TMenuItem;
    PopupMenuSelectionVoix: TPopupMenu;
    Sousslectionnerlesnotesdelavoix1: TMenuItem;
    Placerlesnotesdanscettevoix1: TMenuItem;
    N8: TMenuItem;
    Slectionnertout1: TMenuItem;
    Fentredecontrledufluxmicrophone1: TMenuItem;
    mnuEntree_WaveIn_Activer: TMenuItem;
    mnuEntree_WaveIn_Desactiver: TMenuItem;
    N9: TMenuItem;
    ImageListDuree_Approximative: TImageList;
    panMenu: TPanel;
    Modes_PageControl: TPageControl;
    Modes_PageControl_Fichier: TTabSheet;
    Modes_PageControl_MettreNote: TTabSheet;
    Modes_PageControl_Selection: TTabSheet;
    Modes_PageControl_Clef: TTabSheet;
    Modes_PageControl_Nuances: TTabSheet;
    Modes_PageControl_Mesures: TTabSheet;
    tlbFichier: TToolBar;
    tbnNouveau: TToolButton;
    tbnOpen: TToolButton;
    tbnSave: TToolButton;
    panTabControlChildWin: TPanel;
    TabControlChildWin: TTabControl;
    Modes_PageControl_Affichage: TTabSheet;
    Modes_PageControl_Ecouter: TTabSheet;
    Modes_PageControl_Enregistrer: TTabSheet;
    TabSheetMesures: TTabSheet;
    TabSheetAffichage: TTabSheet;
    TabSheetEcouter: TTabSheet;
    TabSheetEnregistrer: TTabSheet;
    tlbAttributsEtc: TToolBar;
    tbnTrilles: TToolButton;
    tbnAttributs: TToolButton;
    txtModeSelection_Info: TMemo;
    panEcrireAvecMicrophone: TPanel;
    Label23: TLabel;
    panelBarre_Duree: TPanel;
    lblNotesDuree: TLabel;
    Modes_PageControl_Complementaire: TPageControl;
    panEcrireAvecClavier2: TPanel;
    Label4: TLabel;
    Image10: TImage;
    StatusBar: TStatusBar;
    tlbCopierColler: TToolBar;
    tbnCut: TToolButton;
    tbnCopy: TToolButton;
    tlbZoom: TToolBar;
    tlbZoomArriere: TToolButton;
    trkZoom: TTrackBar;
    tlbZoomAvant: TToolButton;
    panEcrireAvecSouris2: TPanel;
    Label8: TLabel;
    tabModeles: TTabControl;
    lstModeles: TListBox;
    tlbImprimer: TToolButton;
    tbnFichier_Separateur: TToolButton;
    panEcrireAvecClavier: TPanel;
    tlbEcrireAvecClavier: TToolBar;
    tbnPaste: TToolButton;
    frameEcrireDureeChoix: TframeDureeChoix;
    PopupMenuFenetre: TPopupMenu;
    Enregistrer1: TMenuItem;
    Fermer1: TMenuItem;
    ActionList: TActionList;
    actionNotesLierALaSuivante: TAction;
    actionEditUndo: TEditUndo;
    actionEditRedo: TAction;
    actionEditCut: TEditCut;
    actionEditCopy: TEditCopy;
    actionEditPaste: TEditPaste;
    actionFileNew: TAction;
    imgfichiertab_courant_fond: TImage;
    tbnSaveAs: TToolButton;
    actionFileOpen: TAction;
    actionFileSave: TAction;
    actionFileSaveAs: TAction;
    actionFilePrint: TAction;
    Modes_PageControl_Options: TTabSheet;
    tlbEnregistreur: TToolBar;
    tbnEnregistreurEnregistrer: TToolButton;
    tbnEnregistreurStop: TToolButton;
    panJecoute: TPanel;
    imgEnregistreur2: TImage;
    imgEnregistreur1: TImage;
    lblBlablaEnregistrerAPartirDe: TLabel;
    cboPeripheriqueEntree: TComboBox;
    PopupMenuEcrireAvec: TPopupMenu;
    mnuEcrireAvecSouris: TMenuItem;
    mnuEcrireAvecClavier: TMenuItem;
    mnuEcrireAvecMicrophone: TMenuItem;
    tlbEcrireAvec: TToolBar;
    tbnEcrireAvec: TToolButton;
    tbnTailleNotes: TToolButton;
    PopupMenuTailleNotes: TPopupMenu;
    mnuGrandesNotes: TMenuItem;
    mnuPetitesNotes: TMenuItem;
    TabSheetOptions: TTabSheet;
    TabSheetAide: TTabSheet;
    PopupMenuNouveau: TPopupMenu;
    Nouvellepartitionpiano1: TMenuItem;
    Nouvellepartitionguitare1: TMenuItem;
    Nouvellepartitionpersonalise1: TMenuItem;
    actionFileClose: TAction;
    actionMagnetophoneIctusPoser: TAction;
    actionMagnetophoneIctusToutEffacer: TAction;
    tbnFileExporterMIDI: TToolButton;
    tlbClefs: TToolBar;
    tbnClefSol: TToolButton;
    tbnClefFa: TToolButton;
    tbnClefOctaveSup: TToolButton;
    tbnClefOctaveInf: TToolButton;
    tbnClefOctaveFin: TToolButton;
    Label11: TLabel;
    lblBlablaVitesse: TLabel;
    ShapeSelectionRectangleArrondi: TShape;
    trkMagnetophoneVitesse: TTrackBar;
    Image1: TImage;
    Image4: TImage;
    Image5: TImage;
    tlbMagnetophone: TToolBar;
    tbnMagnetophone_Lecture: TToolButton;
    tbnMagnetophone_Pause: TToolButton;
    tbnMagnetophone_Stop: TToolButton;
    ToolBar1: TToolBar;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    frmMagnetophone: TfrmMagnetophone;
    Shape1: TShape;
    actionMagnetophoneLecture: TAction;
    Memo1: TMemo;
    panEcrireAvecSouris: TPanel;
    cmdRebus: TButton;
    panelVoixSelectionnee_Indicateur: TPanel;
    panVoixSelectionnee: TPaintBox;
    lblBlablaVoixCourante: TLabel;
    tlbVoix: TToolBar;
    tbnVoixAutomatique: TToolButton;
    tbnNvVoix: TToolButton;
    tlbGeneral: TToolBar;
    tbnAnnuler: TToolButton;
    tbnRefaire: TToolButton;
    cmdProperties: TToolButton;
    ToolBar2: TToolBar;
    tbnEcrireNotes: TToolButton;
    tbnEcrireSilences: TToolButton;
    Label22: TLabel;
    Label9: TLabel;
    tbnMagnetophone_Debut: TToolButton;
    tbnMagnetophone_Fin: TToolButton;
    imgTabModeActive: TImage;
    cmdHelp: TBitBtn;
    Selection_CoolBar: TCoolBar;
    panSelection_Durees: TPanel;
    ToolBar4: TToolBar;
    ToolButton4: TToolButton;
    tlbDuree_Approximative: TToolBar;
    tbnSelection_ChangerDurees: TToolButton;
    tlbDureeApproximative_Set: TToolButton;
    tbnDurees_Deviner: TToolButton;
    panSelection_Voix: TPanel;
    Label1: TLabel;
    panSelection_Operations: TPanel;
    Label15: TLabel;
    tlbSubSelection: TToolBar;
    tbnNoteDuBas: TToolButton;
    tbnNoteDuHaut: TToolButton;
    panSelection_Alteration: TPanel;
    ToolBar3: TToolBar;
    tlbSelectionAlterer: TToolButton;
    tbnAltererSelonTonalite: TToolButton;
    ToolBarVue: TToolBar;
    tbnModeRuban: TToolButton;
    tbnModePageEditer: TToolButton;
    tbnModePageClean: TToolButton;
    Label2: TLabel;
    tlbSelectionEnharmoniquer: TToolButton;
    Modes_PageControl_Paroles: TTabSheet;
    Label3: TLabel;
    panVoixSelectionner: TPanel;
    lblpanelVoixSelectionner_CliqueSurUneVoix: TLabel;
    lblVoixSelectionnerTexte: TLabel;
    cmdVoixSelectionnerAnnuler: TBitBtn;
    tbnVoixSpecifique: TToolButton;
    actionVoixSpecifique: TAction;
    actionVoixAutomatique: TAction;
    actionVoixNouvelle: TAction;
    Label7: TLabel;
    lstSelection_VoixListe: TListBox;
    Label16: TLabel;
    tlbDeplacerNotesPortees: TToolBar;
    tbnDescendrePortee: TToolButton;
    tbnMonterPortee: TToolButton;
    lstSelection_Voix_PlacerDans: TListBox;
    tbnSelection_FusionnerNotesEtSilences: TToolButton;
    tbnI_Selection_DureesDiviserParDeuxPuisSilence: TToolButton;
    ToolBar5: TToolBar;
    tbnMicrophone: TToolButton;
    tbnExporterLilypond: TToolButton;
    SaveDialogLilypond: TSaveDialog;
    ToolButton1: TToolButton;
    ToolBar: TToolBar;
    tbnMesureGAdd: TToolButton;
    tbnMesureDAdd: TToolButton;
    tbnMesuresSuppr: TToolButton;
    Panel1: TPanel;
    Label6: TLabel;
    Label10: TLabel;
    txtMesDeb: TEdit;
    txtMesFin: TEdit;
    ModeMesures_ToutAlaFin: TBitBtn;
    ModeMesures_ToutDebut: TBitBtn;
    ToolBar6: TToolBar;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    tlbFichierPLUS: TToolBar;
    cmdPartition_Instruments: TToolButton;
    ImageListFichier: TImageList;
    ImageListMesurePLUS: TImageList;
    panTop: TPanel;
    cmdDebug: TBitBtn;

    procedure Fichier_FinActionModeFichier;
    Function Fichier_Ouvrir_Document: Boolean;
    procedure Fichier_NouveauDocument(Comp: TComposition);
    procedure Fichier_NouveauDocumentViteFait_Guitare;
    procedure Fichier_NouveauDocumentViteFait_Piano;

    
    procedure Instruments_Icones_Charger;
    procedure Chargement_Temps_Informer(nbmillisec: integer);

    Function IntChangerModeleCourant(m:integer): Boolean;
    procedure FileNew1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FilePrintItemClick(Sender: TObject);

    procedure I_AppliquerRythme;
    procedure FormCreate(Sender: TObject);
    procedure ToButton18Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButon18Click(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure Enregistrersous1Click(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure PasteItemClick(Sender: TObject);
    procedure tbnModeSourisClick(Sender: TObject);
    procedure FileSaveItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrDbClickTimer(Sender: TObject);
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    procedure WindowTileItemClick(Sender: TObject);
    procedure WindowTileItem2Click(Sender: TObject);
    procedure tbnDescendrePorteeClick(Sender: TObject);
    procedure tbnMonterPorteeClick(Sender: TObject);
    procedure Queueverslehaut1Click(Sender: TObject);
    procedure Queueverslebas1Click(Sender: TObject);

    procedure Modes_PageControl_Traiter(ya_un_document: boolean);
    procedure CapterQueYaOuNonFenetreActive(ya_un_document: boolean);
    procedure FormActivate(Sender: TObject);
    procedure lblFreqClick(Sender: TObject);
    procedure CompilerFichierMIDI;
    procedure mnuCompilerenfichierMIDIClick(Sender: TObject);
    procedure mnuPropPorteeClick(Sender: TObject);
    procedure trkMediaPlayerTrackChange(Sender: TObject);
    procedure tbnLectureClick(Sender: TObject);
    procedure tabModelesChange(Sender: TObject);
    procedure TonaliteFixeClick(Sender: TObject);
    procedure TonaliteMilieuClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Enharmoniques1Click(Sender: TObject);
    procedure mnuModeleModeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure tbnGrandesNotesClick(Sender: TObject);
    procedure tbnPetitesNotesClick(Sender: TObject);
    procedure Recopierlegroupeprcdent1Click(Sender: TObject);
    procedure Recopierenchromatique1Click(Sender: TObject);
    procedure Accordmajeur1Click(Sender: TObject);
    procedure Accordmineur1Click(Sender: TObject);
    procedure Ncrirequunenote1Click(Sender: TObject);

    procedure EcrireUneQchClick(hauteur: integer; alteration: TAlteration);
    procedure EcrireunesecondeClick(Sender: TObject);
    procedure Ecriredesquintes1Click(Sender: TObject);
    procedure Ecriredessixtes1Click(Sender: TObject);
    procedure Ecriredesoctaves1Click(Sender: TObject);
    procedure Ecrireunetierce2Click(Sender: TObject);
    procedure Pleincran1Click(Sender: TObject);
    procedure tbnNuancePClick(Sender: TObject);
    procedure tbnCourbeClick(Sender: TObject);
    procedure Rparerlefichier1Click(Sender: TObject);
    procedure mnuCancelClick(Sender: TObject);
    procedure mnuRefaireClick(Sender: TObject);
    procedure Doigtes1Click(Sender: TObject);
    procedure Nouvellefentre1Click(Sender: TObject);
    procedure Accorddedominante1Click(Sender: TObject);
    procedure Ecriredestiercesmineures1Click(Sender: TObject);
    procedure cboRythmeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cboRythmeChange(Sender: TObject);
    procedure mnuTrillesClick(Sender: TObject);
    procedure CoolBarTopDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Barredoutils1Click(Sender: TObject);
    procedure panModelesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mnuDureeClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure tmrFinMidiNowTimer(Sender: TObject);
    procedure Proprits1Click(Sender: TObject);
    procedure Collereninversant1Click(Sender: TObject);
    procedure tbnNoteDuBasClick(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure mnuModeAffichage_ModepageClick(Sender: TObject);
    procedure mnuModeAffichage_ModerubanClick(Sender: TObject);
    procedure mnuModeAffichage_Modepageavectouteslesportes1Click(Sender: TObject);
    procedure tlbNuancesResize(Sender: TObject);
    procedure tlbSubSelectionClick(Sender: TObject);
    procedure tlbClefsClick(Sender: TObject);
    procedure mnuAttribClick(Sender: TObject);
    procedure mnuAttributsToutVirerClick(Sender: TObject);
    procedure tbnModeClavierClick(Sender: TObject);
    procedure tbnNoteDuHautClick(Sender: TObject);
    procedure panVoixSelectionneePaint(Sender: TObject);
    procedure Voixautomatiquecriredanslesvoixpardfaut1Click(
      Sender: TObject);
    procedure Gestiondesvoix2Click(Sender: TObject);
    procedure Ecriredansunenouvellevoix1Click(Sender: TObject);
    procedure panVoixSelectionneeMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrHelpTimer(Sender: TObject);
    procedure Cyclervoix1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure CompilerenfichierWAV1Click(Sender: TObject);
    procedure OuvrirPartitionExistante(a_FileName: string; OpenAsModel: boolean);
    Function CreateMDIChild(const Name: string): TMDIChild;
    procedure mnuCorrigerClick(Sender: TObject);
    procedure FileCloseItemClick(Sender: TObject);
    procedure Untrucalatoire1Click(Sender: TObject);
    procedure panVoixSelectionneeClick(Sender: TObject);
    procedure Lettre1Click(Sender: TObject);
    procedure tbnClefOctaveSupClick(Sender: TObject);
    procedure tbnClefOctaveFinClick(Sender: TObject);
    procedure tbnClefOctaveInfClick(Sender: TObject);
    procedure tbnCrescendoClick(Sender: TObject);
    procedure tbnDeCrescendoClick(Sender: TObject);
    procedure tbnNuanceMFClick(Sender: TObject);
    procedure tbnNuanceFClick(Sender: TObject);
    procedure tbnNuanceMPClick(Sender: TObject);
    procedure Clavier1Click(Sender: TObject);
    procedure ToolBar2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tlbNotesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FileOpenItemClick(Sender: TObject);
    procedure Navigateurdepartition1Click(Sender: TObject);
    procedure WMDropFiles(Var Mesg: TWMDropFiles); message WM_DROPFILES;
    procedure mnuMidiIn_OpenClick(Sender: TObject);
    procedure mnuMidiIn_CloseClick(Sender: TObject);
    procedure mnuMidiinClick(Sender: TObject);
    procedure mnuInstrumentsClick(Sender: TObject);
    procedure tbnMagnetophone_PauseClick(Sender: TObject);
    procedure tbnStopClick(Sender: TObject);
    procedure mnuBarreEtatPositionClick(Sender: TObject);
    procedure Mettredesparoles1Click(Sender: TObject);
    procedure Modes_PageControlChange(Sender: TObject);
    procedure tmrChangerDown_BoutonChiantDropDownTimer(Sender: TObject);
    procedure BoutonChiantDropDownMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbnAttributsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbnTrillesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuTrillesRienClick(Sender: TObject);
    procedure mnuConsoleClick(Sender: TObject);
    procedure AfficherfentreAnnulerRefaire1Click(Sender: TObject);
    procedure lstModelesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstModelesClick(Sender: TObject);
    procedure lstSelection_VoixListeDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure PopupMenuSelectionVoixPopup(Sender: TObject);
    procedure Sousslectionnerlesnotesdelavoix1Click(Sender: TObject);
    procedure Placerlesnotesdanscettevoix1Click(Sender: TObject);
    procedure trkZoomChange(Sender: TObject);
    procedure tlbZoomArriereClick(Sender: TObject);
    procedure tlbZoomAvantClick(Sender: TObject);
    procedure Slectionnertout1Click(Sender: TObject);
    procedure Fentredecontrledufluxmicrophone1Click(Sender: TObject);
    procedure mnuEntree_WaveIn_ActiverClick(Sender: TObject);
    procedure mnuEntree_WaveIn_DesactiverClick(Sender: TObject);
    procedure tlbDureeApproximative_SetClick(Sender: TObject);
    procedure panPlacerDansNouvelleVoixClick(Sender: TObject);
    procedure tbnModeMicrophoneClick(Sender: TObject);
    procedure frameDureeChoixOnChange;
    procedure TabControlChildWinChange(Sender: TObject);
    procedure tlbImprimerClick(Sender: TObject);
    procedure tbnPasteMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actionNotesLierALaSuivanteExecute(Sender: TObject);
    procedure Modes_PageControlDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure TabControlChildWinDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure cboPeripheriqueEntreeDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure tbnEnregistreurEnregistrerClick(Sender: TObject);
    procedure tbnEnregistreurStopClick(Sender: TObject);
    procedure mnuEcrireAvecGeneriqueClick(Sender: TObject);
    procedure frmMagnetophonetbnStopClick(Sender: TObject);
    procedure tbnTailleNotesClick(Sender: TObject);
    procedure mnuPetitesNotesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TabControlChildWinMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TabControlChildWinMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure Nouvellepartitionpersonalise1Click(Sender: TObject);
    procedure Nouvellepartitionpiano1Click(Sender: TObject);
    procedure Nouvellepartitionguitare1Click(Sender: TObject);
    procedure actionFileCloseExecute(Sender: TObject);
    procedure actionMagnetophoneIctusPoserExecute(Sender: TObject);
    procedure actionMagnetophoneIctusToutEffacerExecute(Sender: TObject);
    procedure tbnDurees_DevinerClick(Sender: TObject);
    procedure tbnFileExporterMIDIClick(Sender: TObject);
    procedure tbnNouveauMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actionMagnetophoneLectureExecute(Sender: TObject);
    procedure Modes_PageControlMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure tbnSelection_ChangerDureesClick(Sender: TObject);
    procedure cmdPropertiesClick(Sender: TObject);
    procedure tbnEcrireNotesClick(Sender: TObject);
    procedure tbnEcrireSilencesClick(Sender: TObject);
    procedure tbnMagnetophone_DebutClick(Sender: TObject);
    procedure tbnMagnetophone_FinClick(Sender: TObject);
    procedure cmdHelpClick(Sender: TObject);
    procedure tbnAltererSelonTonaliteClick(Sender: TObject);
    procedure tlbSelectionAltererClick(Sender: TObject);
    procedure tbnModeRubanClick(Sender: TObject);
    procedure tbnModePageEditerClick(Sender: TObject);
    procedure tbnModePageCleanClick(Sender: TObject);
    procedure tlbSelectionEnharmoniquerClick(Sender: TObject);
    procedure cmdDebugClick(Sender: TObject);
    procedure cmdVoixSelectionnerAnnulerClick(Sender: TObject);
    procedure actionVoixSpecifiqueExecute(Sender: TObject);
    procedure actionVoixAutomatiqueExecute(Sender: TObject);
    procedure tbnVoixSpecifiqueClick(Sender: TObject);
    procedure actionVoixNouvelleExecute(Sender: TObject);
    procedure lstSelection_VoixListeClick(Sender: TObject);
    procedure lstSelection_Voix_PlacerDansClick(Sender: TObject);
    procedure tbnSelection_FusionnerNotesEtSilencesClick(Sender: TObject);
    procedure tbnI_Selection_DureesDiviserParDeuxPuisSilenceClick(
      Sender: TObject);
    procedure tbnMicrophoneClick(Sender: TObject);
    procedure cboPeripheriqueEntreeClick(Sender: TObject);
    procedure tbnExporterLilypondClick(Sender: TObject);
    procedure actionVoixSpecifiqueQuandModeSpecifiqueExecute(
      Sender: TObject);
    procedure ModeMesures_ToutAlaFinClick(Sender: TObject);
    procedure ModeMesures_ToutDebutClick(Sender: TObject);
    procedure txtMesDebChange(Sender: TObject);
    procedure txtMesFinChange(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure tbnMesureDAddClick(Sender: TObject);
    procedure tbnMesuresSupprClick(Sender: TObject);
    procedure cmdPartition_InstrumentsClick(Sender: TObject);
  private
    { Private declarations }
//    Function CreateMDIChildAccordingTo(MDIChildSource: TMDIChild): TMDIChild;
    private_bienvenue_afficher: Boolean;

    private_TabControlChildWin_NumTab_Courant: integer;
    private_TabControlChildWin_Button_Courant: integer;

    procedure TailleNotes_Traiter(petitesnotes: Boolean);
    procedure Focus_ToutVirer;
    procedure TabControlChildWin_NouvelleOngletEtYAller(titre: string; fenetre: TMDIChild);
    procedure TabControlChildWin_GetNumTabEtButton(X: integer; var ouput_numtab: integer; var output_button: integer);

  public
    procedure Tonalite_Mettre_A_Jour;
    procedure Duree_Courante_Faire;

    Function TabControlChildWinIndice_Get(child: TMDIChild): integer;
    procedure TabControlChildWin_Redimensionner;
    { Public declarations }
  end;

  Procedure EnableFenetre(F: TForm; oui: boolean);
  Function frmOuvrir: TfrmOuvrir;

var
  MainForm: TMainForm;
  tmrMediaPlayerCompteur: integer = 0;
  modelePretAEtreSelectionne: integer;
  AncienmodelePretAEtreSelectionne: integer;


































implementation

{$R *.DFM}

uses About, ShellAPI {pour le drag and drop},
     ProprietesPortee,
     MusicWriter_Console, Imprimer,
     Doigtes, Duree, Options, nuances, Proprietes, Voix, help,
     choix, Correction,
     MusicSystem_Types {TNote},
     MusicGraph_System {pour CHeight},
     MusicGraph_Portees {pour IGP},
     MusicGraph_CercleNote {pour CreerCerclePtsStandard},
     MusicGraph_Images {pour ChargerBitmaps},
     MusicWriter_Erreur,
     MusicGraph_CouleursUser,
     Cancellation,
     Voix_Gestion, Lettre,
     DureeCourante_Gestion, MusicSystem_CompositionAvecPagination,
     CurseursSouris,
     MusicWriter_Aide,MusicWriter_Chargement_Thread,
     MusicSystem_CompositionListeObjetsGraphiques,
     piano, piano_gestion, MusicSystem_Curseur, bienvenue,
     Nouveau_Assistant, frmBeta, navigateur,
     Options_SaveAndLoad {pour option_NavigateurAfficher},
     piano_doigteur, Musicwriter_MidiIn,
     Intro, Instrument_Portee, Enregistrer_Source,

     Message_Vite_Fait, Paroles,
     I_Trilles_Et_Attributs,
     CurseurSouris_Busy, Cancellation_Window,
     Midi_IN, Rien_fenetre,
     Entree_WaveIn_FFT_Form,
     Entree_WaveIn, PressePapier_Form,
     Magnetophone_Curseur_Init, frame_Composition_Instruments,
     langues,
     AideGenerale,
     MusicUser_PlusieursDocuments, alterer,
     UOperation_Voix_Selectionner_Dans_Partition,
     UConversion_Musicwriter_Vers_Lilypond,
     MusicUser_Mode_Mesures, frmMesuresTempo, frmMesuresMetronome,
  frmMesuresSignatureTemporelle, frmMesuresTonalite, frmMesuresBarres,
  UTransposerNotesALaSouris, InterfaceGraphique_Complements;








{truc chiant car l'interface proposée par delphi est pourri...
 les boutons des barres d'outils dropdown ne peuvent pas servir
 comme case à cocher à la base... avec cette bidouille terrible qui utilise
 aussi un timer (tmrChangerDown_BoutonChiantDropDown), ça marche!
 (pff...)}
var BoutonChiantDropDown: TToolButton = nil;
    BoutonChiantDropDown_NouvelleValeurdeDown: Boolean = false;




procedure Fichier_MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
Begin
     if MusicUser_MusicWriter_Mode_Get = mw_mode_Fichier then
           MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
           
End;





Function frmDoigtes: TfrmDoigtes;
Begin
  if Doigtes.frmDoigtes = nil then
          Application.CreateForm(TfrmDoigtes, Doigtes.frmDoigtes);

  result := Doigtes.frmDoigtes;
End;


Function frmNuances: TfrmNuances;
Begin
  if Nuances.frmNuances = nil then
          Application.CreateForm(TfrmNuances, Nuances.frmNuances);

  result := Nuances.frmNuances;
End;



Function frmOptions: TfrmOptions;
Begin
  if Options.frmOptions = nil then
          Application.CreateForm(TfrmOptions, Options.frmOptions);

  result := Options.frmOptions;
End;


Function frmDuree: TfrmDuree;
Begin
  if Duree.frmDuree = nil then
          Application.CreateForm(TfrmDuree, Duree.frmDuree);

  result := Duree.frmDuree;
End;








Function frmImprimer: TForm;
Begin
  if Imprimer.frmImprimer = nil then
          Application.CreateForm(TfrmImprimer, Imprimer.frmImprimer);

  result := Imprimer.frmImprimer;
End;


Function frmOuvrir: TfrmOuvrir;
Begin
  if Ouvrir.frmOuvrir = nil then
          Application.CreateForm(TfrmOuvrir, Ouvrir.frmOuvrir);

  result := Ouvrir.frmOuvrir;
End;





Procedure EnableFenetre(F: TForm; oui: boolean);
var i: integer;
Begin
    if F = nil then exit;

    for i := 0 to F.ControlCount-1 do
          F.Controls[i].Visible := oui;

End;







Function TMainForm.CreateMDIChild(const Name: string): TMDIChild;
const option_MODE_AFFICHAGE_PAR_DEFAUT = maPage;

var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  MusicGraph_Canvas_Set(Child.Canvas);
  Child.Composition := TComposition.Create;
  Child.Curseur := Child.Composition.Curseur_Obtenir;
  Child.Curseur_Souris := Child.Composition.Curseur_Obtenir;
  Child.Magnetophone_Curseur := TMagnetophone_Curseur_Creer(Child.Composition,
                                                            0,
                                                            Qel(0));
  Child.FileName := Name;
  Child.Caption := Name;
  TabControlChildWin_NouvelleOngletEtYAller(ExtractFileName(Name), Child);
  Child.I_ModeAffichage_Set_SansAfficher(option_MODE_AFFICHAGE_PAR_DEFAUT);




  result := Child;
end;

procedure TMainForm.FileNew1Execute(Sender: TObject);
begin
    frmNouveauAssistant_Afficher;

end;



procedure TMainForm.Fichier_FinActionModeFichier;
Begin
    MusicUser_MusicWriter_Mode_Set(mw_mode_MettreNote);
End;

Function TMainForm.Fichier_Ouvrir_Document: Boolean;
Begin
    CurseurSouris_Busy_Begin;
    CHeight := 200000;
    frmOuvrir.TabControl.TabIndex := 1;
    frmOuvrir.TabControlChange(nil);
    CurseurSouris_Busy_End;
    result := frmOuvrir.showmodal <> mrCancel;
    if result then
          OuvrirPartitionExistante(frmOuvrir.filename, frmOuvrir.OpenAsModel);
End;


procedure TMainForm.TabControlChildWin_Redimensionner;
const TabControlChildWin_TabWidth_Min = 64;

var nv_taille : integer;
Begin
     if TabControlChildWin.Tabs.Count > 0 then
     Begin
         nv_taille := TabControlChildWin.Width  div TabControlChildWin.Tabs.Count - 16;

         if nv_taille < TabControlChildWin_TabWidth_Min then
                nv_taille := TabControlChildWin_TabWidth_Min;

         TabControlChildWin.TabWidth := nv_taille;

     End;
End;



procedure TMainForm.TabControlChildWin_NouvelleOngletEtYAller(titre: string; fenetre: TMDIChild);
Begin
      TabControlChildWin.Tabs.AddObject(titre, fenetre);
      TabControlChildWin.TabIndex := TabControlChildWin.Tabs.Count - 1;
      TabControlChildWin_Redimensionner;

End;

procedure TMainForm.Fichier_NouveauDocument(Comp: TComposition);
var Child: TMDIChild;
begin
  { create a new MDI child window }
      Child := TMDIChild.Create(Application);
      Child.Composition := Comp;
      Child.Curseur := Child.Composition.Curseur_Obtenir;
      Child.Curseur_Souris := Child.Composition.Curseur_Obtenir;
      (ActiveMDIChild as TMDIChild).FileName := '';
      Child.Magnetophone_Curseur := TMagnetophone_Curseur_Creer(Child.Composition,
                                                            0,
                                                            Qel(0));

      TabControlChildWin_NouvelleOngletEtYAller(Langues_Traduire('<<Nouvelle partition non enregistrée>>'), Child);

      Child.Caption := Name;
      MusicGraph_Canvas_Set(Child.Canvas);
      Child.SetCurrentView;
      Child.Composition.CalcTout(true);

      MusicUser_MusicWriter_Modes_Deballer_SiBesoin;
      Fichier_FinActionModeFichier;

End;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(nil);
  AboutBox.ShowModal;
  AboutBox.Free;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;






procedure TMainForm.FilePrintItemClick(Sender: TObject);
begin
frmImprimer.showmodal;

end;







procedure TMainForm.Instruments_Icones_Charger;
var i: integer;
    b : TBitmap;

Begin
    //charger les icônes des instruments
    for i := 0 to 128 do
    Begin
        if MusicWriter_IsOnQuitteleprogramme then exit;

        b := TBitmap.Create;
        if FileExists(DossierRacine + 'interface_instruments\' +inttostr(i) + '.bmp') then
             b.LoadFromFile(DossierRacine + 'interface_instruments\' +inttostr(i) + '.bmp')
        else
             b.LoadFromFile(DossierRacine + 'interface_instruments\generic.bmp');

        if MusicWriter_IsOnQuitteleprogramme then exit;
        imgIconesInstruments.AddMasked(b, clSilver);
        
        b.Free;
    End;
End;





procedure TMainForm.FormCreate(Sender: TObject);
var i:integer;

      procedure Magnetophone_Init;
      Begin
            //frameMagnetophone_Composition_Instruments.Informer_CompositionLecture;
           // frameMagnetophone_Composition_Instruments.AvecOreille;
      End;



begin
      cmdDebug.Visible := DirectoryExists('sources');
//      tlbGeneral.Top := panMenu.Top + 27;
//      panelVoixSelectionnee_Indicateur.Top := panMenu.Top + 27;
      panelVoixSelectionnee_Indicateur.Top := 20;
      tlbGeneral.Top := 20;
      panVoixSelectionner.Top := 20;

      Langues_TraduireFenetre(self);
      TabControlChildWin.DoubleBuffered := true;

      frameEcrireDureeChoix.OnChange := frameDureeChoixOnChange;
      frameEcrireDureeChoix.Init;


      Navigateurdepartition1Click(nil);
      MusicUser_MusicWriter_Modes_Remballer;
      MusicUser_MusicWriter_Mode_Set(mw_mode_Fichier);
      MusicUser_MusicWriter_DeclarerPasDeModePrecedent;
      BoutonCtrlActive := false;
      TonaliteMilieuClick(nil);

      cmdRebus.top := -5000;
      CDevice := devEcran;
      ModeleSousCurseur := 0;

      {on évite les scintillements}
      tabModeles.DoubleBuffered := true;

      FenetreIntro_Texte('chargement du midi-in...');
      Midi_In_Demarrage_Essai;

      
      FenetreIntro_Texte('chargement des bitmaps...');
      ChargerBitmaps;


      FenetreIntro_Texte('chargement des modèles...');
      MusicGraph_Canvas_Set(lstModeles.Canvas);
      ChargerModeles(0);

      FenetreIntro_Texte('chargement des rythmes...');
      ChargerRythmes;
      for i := 1 to length(Rythmes) do
          cboRythme.Items.Add('');

      cboRythme.ItemIndex := 0;
      RythmeEnCours := Rythmes[0];


      Zoom := ZoomParDefaut;

      InitialiserVariable;
      MusicGraph_CercleNote_Init;


      MusicWriter_Chargement_Thread_ExecuterDansThreadPrincipal;
      //MusicWriter_Chargement_Thread_Lancer;



      {ça ! ça permet de faire du glisser déposer dans la fenêtre}
      DragAcceptFiles(handle, true);

      Voix_Gestion_ModeAutomatique_Set(true);

      Magnetophone_Init;

      ToolBar.Images := MainForm.imgList;
      {
      Midi_In_Init(0);
       }

end;





procedure TMainForm.Chargement_Temps_Informer(nbmillisec: integer);
Begin
    Caption := 'Schwarz MusicWriter [chargé en ' + inttostr(nbmillisec) + ' ms]';
End;


procedure TMainForm.ToButton18Click(Sender: TObject);
begin
    Outil := MettreClef;
    ModeClef_Outil_Clef_ClefSelectionnee := ClefSol;


end;

procedure TMainForm.ToolButton17Click(Sender: TObject);
begin
    Outil := MettreClef;
    ModeClef_Outil_Clef_ClefSelectionnee := ClefFa;
end;



procedure TMainForm.ToolButton19Click(Sender: TObject);
begin
      Outil := MettreAlteration;
      ModeAlteration_Outil_Alteration_Selectionnee := aDiese;
end;

procedure TMainForm.ToolButon18Click(Sender: TObject);
begin
    Outil := MettreAlteration;
    ModeAlteration_Outil_Alteration_Selectionnee := aNormal;
end;

procedure TMainForm.ToolButton18Click(Sender: TObject);
begin
    Outil := MettreAlteration;
    ModeAlteration_Outil_Alteration_Selectionnee := aBemol;
end;

procedure TMainForm.Enregistrersous1Click(Sender: TObject);
begin
    (ActiveMDIChild as TMDIChild).TenterEnregistrer(true);
end;

procedure TMainForm.CopyItemClick(Sender: TObject);
begin
    if actchild.Composition.Selection_IsToutDeselectionner then exit;
    PressePapier.Free;
    PressePapier := TMesure.Create;
    actchild.Composition.Selection_CopieToPressePapier(PressePapier);
end;

procedure TMainForm.PasteItemClick(Sender: TObject);

    
begin

    actchild.I_Coller(PressePapier);

end;








Function TMainForm.IntChangerModeleCourant(m:integer): Boolean;
{retourne vrai si le modèle courant a bien changé}
Begin
      if ((m < 0) or (m > high(Modeles))) then
          result := false
      else
      Begin
          ModeleSousCurseur := m; 
          lstModeles.Repaint;
          result := true;
      End;
End;




procedure TMainForm.I_AppliquerRythme;
Begin
    MessageErreurSiPasDeFenetreActive('I_AppliquerRythme');

    actchild.VerifierIntegrite('appliquer rythme');

    
    if actchild.Composition.Selection_IsToutDeselectionner then
          Message_Vite_Fait_Beep_Et_Afficher(
              'Il n''y a pas de sélection active : on applique pas le rythme!')
    else
    Begin

        actchild.Composition.I_Selection_ChangerRythme(DureeCourante_Get);
        actchild.MettreBarreMesures_RegarderSiBesoin(actchild.Composition.Selection_GetIMesDebutSelection);
        MusicGraph_Canvas_Set(actchild.canvas);
        SetView(actchild.View);
        actchild.FaireLaPaginationEtLesCalculsPuisAffichageComplet(
                       actchild.Composition.Selection_Getimesdebutselection,
                       actchild.Composition.Selection_Getimesfinselection,
                       true);
    End;

End;




procedure TMainForm.frameDureeChoixOnChange;
Begin
    DureeCourante_Set(frameEcrireDureeChoix.Duree_Get);
    Duree_Courante_Faire;
end;





procedure TMainForm.Duree_Courante_Faire;
      procedure RienFaire;
       Begin
       End;
Begin
    DureeCourante_Set(frameEcrireDureeChoix.Duree_Get);
    case MusicUser_MusicWriter_Mode_Get of
             mw_mode_MettreNote: RienFaire;
             mw_mode_Selection: I_AppliquerRythme;
             else
                 MessageErreur('Erreur de mode... pourquoi ces boutons de durées sont-ils affichés ?');
        end;

End;









procedure TMainForm.tbnModeSourisClick(Sender: TObject);
begin
     Entree_WaveIn_Desactiver;
     panEcrireAvecSouris.BringToFront;
//Outil_RevenirModeStandard;
end;



procedure TMainForm.FileSaveItemClick(Sender: TObject);
begin
     (ActiveMDIChild as TMDIChild).TenterEnregistrer(false);

     Fichier_MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
end;


procedure TMainForm.CutItemClick(Sender: TObject);
begin
    if actchild.Composition.Selection_IsToutDeselectionner then
        exit;
        
    CopyItemClick(nil);

    actchild.Composition.I_Selection_Supprimer('Suppression de la sélection lors d''un coupage');
    actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;

    actChild.ReaffichageComplet;


end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if MusicWriter_IsFenetreDocumentCourante then
          actchild.FormKeyDown(Sender, Key, Shift);
end;

procedure TMainForm.tmrDbClickTimer(Sender: TObject);
begin
tmrDbClick.Enabled := false;
end;

procedure TMainForm.WindowCascadeItemClick(Sender: TObject);
begin
Cascade;
end;

procedure TMainForm.WindowArrangeItemClick(Sender: TObject);
begin
ArrangeIcons;
end;

procedure TMainForm.WindowTileItemClick(Sender: TObject);
begin
TileMode := tbHorizontal;
Tile;

end;

procedure TMainForm.WindowTileItem2Click(Sender: TObject);
begin
TileMode := tbVertical;
Tile;
end;

procedure TMainForm.tbnDescendrePorteeClick(Sender: TObject);
begin
    actchild.Composition.Selection_DeplacerNotesSelectionneesPortee(1);
    actchild.Composition.PaginerApresModifSelection(true);
    actchild.ReaffichageComplet;
end;

procedure TMainForm.tbnMonterPorteeClick(Sender: TObject);
begin
actchild.Composition.Selection_DeplacerNotesSelectionneesPortee(-1);
actchild.Composition.PaginerApresModifSelection(true);
actchild.ReaffichageComplet;
end;


procedure TMainForm.OuvrirPartitionExistante(a_FileName: string; OpenAsModel: boolean);
var NewMdiChild: TMDIChild;

Begin
NewMdiChild := nil;

EnLecture := true;
try
    if not OuvrirFichier(a_Filename) then
    Begin
         MessageDlg('Erreur dans l''ouverture du fichier. "' + a_FileName +
                      '". Est-ce bien un fichier ? un fichier correct ? Je n''arrive' +
                      ' même pas à voir ce qu''il y a dedans !',
         mtError, [mbOK], 0);
         CapterQueYaOuNonFenetreActive(false);
         Exit;
    End;

    CurseurSouris_Busy_Begin;
    MusicUser_Pourcentage_Init('Ouverture d''un fichier');

    NewMdiChild := CreateMDIChild(a_FileName);

    With NewMdiChild do
    Begin
         MusicGraph_Canvas_Set(Canvas);
         {on affecte un canvas pour faire les calculs}

         if not Composition.Save then
         Begin
                Free;
                CapterQueYaOuNonFenetreActive(false);
                Magnetophone_Prevenir_la_fermeture_d_une_fenetre(NewMdiChild);
                MessageDlg('Erreur dans l''ouverture du fichier. "' + a_FileName +
                      '". Ce fichier n''est pas un fichier Schwarz MusicWriter !',
                       mtError, [mbOK], 0);
         End
         else
         Begin
               Composition.CalcTout(true);

               CalcCurseur(true, true);

               if OpenAsModel then
               Begin
                  Caption := 'Nouvelle partition créé à partir du modèle ' + Caption;
                  FileName := '';
               End;


               CapterQueYaOuNonFenetreActive(true);

               MusicUser_MusicWriter_Modes_Deballer_SiBesoin;

         End;
    End;
except
    NewMdiChild.Free;
    MessageDlg('Erreur bizarre dans l''ouverture du fichier "' + a_FileName +
     '". Vérifiez que ce fichier est bien un fichier Schwarz MusicWriter !',
     mtError, [mbOK], 0);
    MusicUser_Pourcentage_Free;

end;


FermerFichier;
MusicUser_Pourcentage_Free;
CurseurSouris_Busy_End;
end;


{ça c'est la procédure qui s'exécute quand on a fait déposé-glissé (par l'opération
du glisser déposer sur la fenêtre) une icône depuis l'explorateur par exemple}
procedure TMainForm.WMDropFiles(Var Mesg: TWMDropFiles);
Var NameOfFile : array[0..255] of Char;
    NbFiles, i : integer;

begin
  private_bienvenue_afficher := false;

  //Nombre de fichiers sélectionnés dans l'opération de Drag and Drop
  NbFiles:=DragQueryFile(Mesg.drop, $FFFFFFFF, NameOfFile, SizeOf(NameOfFile));
  //Pour chaque itération ...
  For i:=0 to NbFiles - 1 do begin
    //Recherche le nom du fichier i
    DragQueryFile(Mesg.drop, i, NameOfFile, SizeOf(NameOfFile));
    //Ajoute le fichier dans la liste
    OuvrirPartitionExistante(NameOfFile, false);
    end;
  
  Mesg.result:=0; //Le message a été traité
end;


procedure TMainForm.Queueverslehaut1Click(Sender: TObject);
begin
actchild.Queueverslehaut1Click(Sender); 
end;

procedure TMainForm.Queueverslebas1Click(Sender: TObject);
begin
actchild.Queueverslebas1Click(Sender);
end;


procedure TMainForm.Modes_PageControl_Traiter(ya_un_document: boolean);
Begin
    Modes_PageControl_MettreNote.TabVisible := ya_un_document;
    Modes_PageControl_Selection.TabVisible := ya_un_document;
    Modes_PageControl_Clef.TabVisible := ya_un_document;
    Modes_PageControl_Nuances.TabVisible := ya_un_document;
    Modes_PageControl_Mesures.TabVisible := ya_un_document;
    Modes_PageControl_Affichage.TabVisible := ya_un_document;
    Modes_PageControl_Ecouter.TabVisible := ya_un_document;
    Modes_PageControl_Enregistrer.TabVisible := ya_un_document;
    Modes_PageControl_Paroles.TabVisible := ya_un_document;
    Modes_PageControl_Options.TabVisible := false;

    if not ya_un_document then
         MusicUser_MusicWriter_Mode_Set(mw_mode_Fichier);

    panMenu.Visible := ya_un_document;
    ControlBarLeft.Visible := ya_un_document;

End;




procedure TMainForm.CapterQueYaOuNonFenetreActive(ya_un_document: boolean);


    Function LectureMIDI_IsPlaying: BOolean;
    Begin
        result := false;//Magnetophone_IsPlaying;
    End;







Begin
      if not ya_un_document then
           //ya := MDIChildCount > 1;
           ya_un_document := MusicWriter_IsFenetreDocumentCouranteOuPasEnTrainDeSeFermer;

      {if (MDIChildCount > 0) then
           ya_un_document := true;    }

      if MusicUser_NbDocumentsOuverts > 0 then
           ya_un_document := true;



      {if MusicWriter_IsFenetreDocumentCouranteOuPasEnTrainDeSeFermer then
           ya := MDIChildCount > 1
      else
           ya := (MDIChildCount <> 0);  }


      actionFileSave.Enabled := ya_un_document;
      actionFileSaveAs.Enabled := ya_un_document;
      actionFilePrint.Enabled := ya_un_document;
      actionFileClose.Enabled := ya_un_document;
      FileSaveItem.Enabled := ya_un_document;
      cmdPartition_Instruments.Enabled := ya_un_document;
      tbnFileExporterMIDI.Enabled := ya_un_document;
      tbnExporterLilypond.Enabled := ya_un_document;
      cmdProperties.Enabled := ya_un_document;
      Enregistrersous1.ENabled := ya_un_document;
      FilePrintItem.Enabled := ya_un_document;
      tbnDescendrePortee.Enabled := ya_un_document;
      tbnMonterPortee.Enabled := ya_un_document;
      Rparerlefichier1.Enabled := ya_un_document;
      mnuCompilerenfichierMIDI.Enabled := ya_un_document;
      FileCloseItem.Enabled := ya_un_document;
      Proprits1.Enabled := ya_un_document;

      trkZoom.Enabled := ya_un_document;
      tlbZoomArriere.ENabled := ya_un_document;
      tlbZoomAvant.ENabled := ya_un_document;

      mnuDuree.Enabled := ya_un_document;

      tbnCut.Enabled := ya_un_document;
      tbnCopy.Enabled := ya_un_document;
      tbnPaste.Enabled := ya_un_document;
      Collereninversant1.Enabled := ya_un_document;
      Queueverslehaut1.Enabled := ya_un_document;
      Queueverslebas1.Enabled := ya_un_document;
      Renverserverslehaut1.Enabled := ya_un_document;
      mnuRenverserverslebas1.Enabled := ya_un_document;
      Enharmoniques1.Enabled := ya_un_document;
      mnuPropMesure.Enabled := ya_un_document;
      mnuPropPortee.Enabled := ya_un_document;

      actionEditCut.Enabled := ya_un_document;
      actionEditCopy.Enabled := ya_un_document;
      actionEditPaste.Enabled := ya_un_document;

      Recopierlegroupeprcdent1.Enabled := ya_un_document;
      Recopierenchromatique1.Enabled := ya_un_document;
      Lilasuivante1.Enabled := ya_un_document;

      actionNotesLierALaSuivante.Enabled := ya_un_document;

      tbnTrilles.enabled := ya_un_document;
      tbnAttributs.enabled := ya_un_document;

      tbnTailleNotes.Enabled := ya_un_document;
      Passeren1.Enabled := ya_un_document;


      actionEditUndo.Enabled := ya_un_document;
      actionEditRedo.Enabled := ya_un_document;

      mnuCorriger.Enabled := ya_un_document;


      mnuModeAffichage_Modepageavectouteslesportes1.Enabled := ya_un_document;
      mnuModeAffichage_Modepage.Enabled := ya_un_document;
      mnuModeAffichage_Moderuban.Enabled := ya_un_document;

      mnuGenerer.Enabled := ya_un_document;

      tbnNoteDuHaut.Enabled := ya_un_document;
      tbnNoteDuBas.Enabled := ya_un_document;

      
      if MusicWriter_IsFenetreDocumentCourante and ya_un_document then
      Begin
          actchild.Composition.Cancellation_GererMenuAnnuler;
          actchild.I_Selection_MettreAJourInfo;
      End;


      EnableFenetre(frmProprietesPortee, ya_un_document);

      if ya_un_document then
      With actchild do
      Begin
            Zoom_MettreAJourMainForm;
            I_ModeAffichage_MettreAJourInterface;
      End;





      if frmProprietesPortee <> nil then
            frmProprietesPortee.MettreAJourFenetre(nil);

      if (MusicUser_NbDocumentsOuverts > 1) then
      Begin
            TabControlChildWin.TabIndex := TabControlChildWinIndice_Get(actchild);
            panTabControlChildWin.Visible := true;
      End
      else
            panTabControlChildWin.Visible := false;

      panVoixSelectionnee.Repaint;
      Modes_PageControl_Traiter(ya_un_document);
End;



procedure TMainForm.FormActivate(Sender: TObject);
begin
    CapterQueYaOuNonFenetreActive(MusicUser_NbDocumentsOuverts > 0);
    
end;

procedure TMainForm.lblFreqClick(Sender: TObject);
begin
    CapterQueYaOuNonFenetreActive(true);
end;

procedure TMainForm.mnuCompilerenfichierMIDIClick(Sender: TObject);
begin
if MainForm.SaveDialogMIDI.Execute then
Begin
   actchild.LectureMIDI_ListeDeLecture := actchild.Composition.LectureMIDI_GetListeiMesuresDeLecture;
   WriteMIDI(actchild.Composition, actchild.LectureMIDI_ListeDeLecture, MainForm.SaveDialogMIDI.FileName);
End;
end;


procedure TMainForm.CompilerFichierMIDI;
var midifile: string;
Begin

  if actchild.FileName <> '' then
       midifile := Copy(actchild.FileName , 1, length(actchild.FileName) - 4)
                        + '.mid'
  else
       midifile := DossierRacine + 'fichier_pas_encore_enregistre.mid';

  actchild.LectureMIDI_ListeDeLecture := actchild.Composition.LectureMIDI_GetListeiMesuresDeLecture;
  WriteMIDI(actchild.Composition, actchild.LectureMIDI_ListeDeLecture, midifile);

  MusicUser_Pourcentage_Free;
End;



procedure TMainForm.mnuPropPorteeClick(Sender: TObject);
begin
     frmProprietesPortee_Afficher;
end;



procedure TMainForm.trkMediaPlayerTrackChange(Sender: TObject);
begin
{if MediaPlayer.Position <> trkMediaPlayerTrack.Position then
     MediaPlayer.Position := trkMediaPlayerTrack.Position;}
end;





procedure TMainForm.tbnLectureClick(Sender: TObject);
begin
    Magnetophone_Lecture;

end;




procedure TMainForm.tabModelesChange(Sender: TObject);
begin
     ChargerModeles(tabModeles.TabIndex);
     lstModeles.Repaint;
end;


procedure TMainForm.TonaliteFixeClick(Sender: TObject);
var i: integer;
begin
    for i := 0 to pmnuTonalites.Items.Count - 1 do
          pmnuTonalites.Items.Items[i].Checked := false;

    With TMenuItem(Sender) do
    Begin
         Checked := true;
         TonaliteCourante := Tag;
     
    End;

    Tonalite_Mettre_A_Jour;
    


TonaliteMilieu.Checked := false;
//eeee;
end;



procedure TMainForm.Tonalite_Mettre_A_Jour;
Begin
     StatusBar.Refresh;
End;


procedure TMainForm.TonaliteMilieuClick(Sender: TObject);
var i:integer;
begin

    for i := 0 to pmnuTonalites.Items.Count - 1 do
          pmnuTonalites.Items.Items[i].Checked := false;

    TonaliteCourante := cTonaliteDeLaMesureCourante;

    TonaliteMilieu.Checked := true;

    Tonalite_Mettre_A_Jour;
//eeee;
end;








   {remarque : pas besoin d'appeler CapterQueYaOuNonFenetreActive
    car c'est géré dans les méthodes FormActive des fenêtres filles}

    procedure TMainForm.Fichier_NouveauDocumentViteFait_Piano;
    var NewMdiChild: TMDIChild;

    begin

          NewMdiChild := MainForm.CreateMDIChild(Langues_Traduire('<<Partition piano seul non enregistrée>>'));
          NewMdiChild.Composition.NouvellePartitionPiano;

          NewMdiChild.FileName := '';

          MusicUser_MusicWriter_Modes_Deballer_SiBesoin;
          Fichier_FinActionModeFichier;
          CapterQueYaOuNonFenetreActive(true);
    End;


    procedure TMainForm.Fichier_NouveauDocumentViteFait_Guitare;
    var NewMdiChild: TMDIChild;
    begin

          NewMdiChild := MainForm.CreateMDIChild(Langues_Traduire('<<Partition guitare seule non enregistrée>>'));
          NewMdiChild.Composition.NouvellePartitionGuitare;

          NewMdiChild.FileName := '';

          MusicUser_MusicWriter_Modes_Deballer_SiBesoin;
          Fichier_FinActionModeFichier;
          CapterQueYaOuNonFenetreActive(true);
    End;



procedure TMainForm.FormShow(Sender: TObject);
var FileNameParam: string;
    i :integer;





    

begin
{on reconstitue la chaîne passée par ligne de commande}
for i := 1 to ParamCount do
Begin
     FileNameParam := FileNameParam + ParamStr(i);
     if i < ParamCount then
           FileNameParam := FileNameParam + ' ';
End;

  { FileNameParam :=
'C:\Documents and Settings\proprietaire\Bureau\compositions\pour piano seul\idée1.mus';
}


if FileNameParam <> '' then
Begin
      OuvrirPartitionExistante(FileNameParam, false);
      private_bienvenue_afficher := false;
End
else
    private_bienvenue_afficher := true;

   //Fichier_NouveauDocumentViteFait_Piano;
end;




procedure TMainForm.Enharmoniques1Click(Sender: TObject);
begin
With actchild.Composition do
Begin
       Selection_EnharmoniquerNotesSelectionnees;
       PaginerApresModifSelection(false);
end;

actchild.ReaffichageComplet;
       
end;

procedure TMainForm.mnuModeleModeClick(Sender: TObject);
begin
    SwitchModeleMode(Modeles[ModeleSousCurseur], TModeleMode(TMenu(Sender).Tag));
    lstModeles.Repaint;
end;





procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
    MusicWriter_IsOnQuitteleprogramme := true;
    for i := MDIChildCount-1 downto 0 do
         MDIChildren[i].Close;


    if MusicWriter_IsOnQuitteleprogramme then
    Begin
        MusicWriter_Chargement_Thread_Terminer;
        MidiNow_CloseMidiDevice;
        Midi_In_Free;
    End
    else
          Action := caNone;
end;





procedure TMainForm.mnuConsoleClick(Sender: TObject);
begin
      Console_Afficher;
end;



procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
//roulette pour les intervalles
{inc(Modeles[2].Voix.ElMusicaux[0].Notes[1].Position.Hauteur, WheelDelta div abs(WheelDelta));
panModeles.Repaint; }
     if MusicWriter_IsFenetreDocumentCourante then
             actchild.FormMouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);
end;




procedure TMainForm.tbnGrandesNotesClick(Sender: TObject);
var m, i: integer;
begin
      if MusicUser_Musicwriter_Mode_Get = mw_mode_Selection then
           actchild.Composition.I_Selection_Notes_Taille_Set(false);

      for m := 0 to high(Modeles) do with Modeles[m] do
           for i := 0 to high(Voix.ElMusicaux) do with Voix.ElMusicaux[i] do
                  attributs.PetitesNotes := false;
      lstModeles.Refresh;
      actchild.ReaffichageComplet;
end;



procedure TMainForm.tbnPetitesNotesClick(Sender: TObject);
var m, i: integer;
begin
    if MusicUser_Musicwriter_Mode_Get = mw_mode_Selection then
        actchild.Composition.I_Selection_Notes_Taille_Set(true);

    for m := 0 to high(Modeles) do with Modeles[m] do
         for i := 0 to high(Voix.ElMusicaux) do with Voix.ElMusicaux[i] do
                attributs.PetitesNotes := true;

    lstModeles.Refresh;
    actchild.ReaffichageComplet;
end;








procedure TMainForm.Recopierlegroupeprcdent1Click(Sender: TObject);
var P: TMesure;
    V: TVoix;

begin
with actchild do
Begin
       if Curseur.Is_SurMesure_FinaleAAjouter then
             Message_Vite_Fait_Beep_Et_Afficher('Il n''y a pas de groupe précédent car on est après la dernière mesure.')
       else
       if Composition.Selection_IsToutDeselectionner then
       Begin
             V := Curseur.GetVoixMesure;
             if V.IsVide then
                     Message_Vite_Fait_Beep_Et_Afficher('La voix est vide : il n''y a pas de groupe précédent')
            else if (Curseur.GetiIndice > 0) then
             Begin
                  V.AddElMusical(Curseur.GetiIndice,
                                   CopieElMusical(V.ElMusicaux[Curseur.GetiIndice-1]));
                  Curseur.DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante;
            End
            else
              Message_Vite_Fait_Beep_Et_Afficher('On se trouve au début de la mesure : il n''y a pas de groupe précédent.');


       End
       else
       Begin
           P := TMesure.Create;
           actchild.Composition.Selection_CopieToPressePapier(P);

           With actchild.Curseur do
              actchild.Composition.Coller(P, GetiMesure, GetTempsDepuisDebutMesure);

       End;

       actchild.FaireLaPaginationEtLesCalculsPuisAffichageComplet(Curseur.GetiMesure, Curseur.GetIMesure, true);

End;
end;

procedure TMainForm.Recopierenchromatique1Click(Sender: TObject);
var modEl, newEl: TElMusical;
    note: TNote;
    j: integer;
    infoclef: TInfoClef;
    hn: THauteurNote;
begin

with actchild do
Begin
       if Curseur.Getposition.hauteur >= 0 then
            IntervalleDeplacement_Definir(HauteurNoteAvecHauteurEtAlteration(0, aDiese) )
       else
           IntervalleDeplacement_Definir(HauteurNoteAvecHauteurEtAlteration(0, aBemol) );


       if Curseur.Is_SurMesure_FinaleAAjouter then
             Message_Vite_Fait_Beep_Et_Afficher('Il n''y a pas de groupe précédent car on est après la dernière mesure.')
       else if Curseur.GetVoixMesure.IsVide then
                     Message_Vite_Fait_Beep_Et_Afficher('La voix est vide : il n''y a pas de groupe précédent')
       else if Curseur.GetiIndice > 0 then
       Begin
              modEl := Curseur.GetElementMusicalPrecedent;

              newEl := TElMusical.Create;

              for j := 0 to modEl.NbNotes-1 do
              Begin
                   note := modEl.GetNote(j);

                   infoclef := Composition.InfoClef_DetecterAvecrelX(note.position.portee,
                                                           Curseur.GetiMesure,
                                                           modEl.pixx);

                   hn := HauteurNoteGraphiqueToAbs(infoclef, note);
                   GetHauteurNote(IntervalleDeplacement_Get, hn, hn);

                   SimplifierHauteurNote(hn);
                   note.position.hauteur := HauteurAbsToHauteurGraphique(infoclef, hn.hauteur);
                   note.hauteurnote.alteration := hn.alteration;

                   newEl.AddNote(note);

               End;

               newEl.ClasserBoules;
               newEl.CalcGDBoules;

               Curseur.GetVoixMesure.AddElMusical(Curseur.GetiIndice, newEl);

               Curseur.DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante;

       End
       else
              Message_Vite_Fait_Beep_Et_Afficher('On se trouve au début de la mesure : il n''y a pas de groupe précédent.');

       actchild.FaireLaPaginationEtLesCalculsPuisAffichageComplet(Curseur.GetiMesure,
        Curseur.GetIMesure+1, true);

End;
end;

procedure TMainForm.Accordmajeur1Click(Sender: TObject);
begin
IntChangerModeleCourant(3);
end;

procedure TMainForm.Accordmineur1Click(Sender: TObject);
begin
IntChangerModeleCourant(4);
end;

procedure TMainForm.Ncrirequunenote1Click(Sender: TObject);
begin
IntChangerModeleCourant(0);
end;


procedure TMainForm.EcrireUneQchClick(hauteur: integer; alteration: TAlteration);
var note: TNote;
Begin
    ModeleSousCurseur := indModeleIntervalle;
    With Modeles[indModeleIntervalle].Voix.ElMusicaux[0] do
      Begin
          note := GetNote(1);

          note.position.hauteur := hauteur;
          note.hauteurnote.alteration := alteration;

          DelNote2(1);

          AddNote(note);

      End;
    lstModeles.Repaint;
End;



procedure TMainForm.EcrireunesecondeClick(Sender: TObject);
begin
       EcrireUneQchClick(1-6, aNormal);

end;

procedure TMainForm.Ecriredesquintes1Click(Sender: TObject);
begin
     EcrireUneQchClick(4-6, aNormal);
end;

procedure TMainForm.Ecriredessixtes1Click(Sender: TObject);
begin
     EcrireUneQchClick(5-6, aNormal);
end;

procedure TMainForm.Ecriredesoctaves1Click(Sender: TObject);
begin
    EcrireUneQchClick(7-6, aNormal);
end;

procedure TMainForm.Ecrireunetierce2Click(Sender: TObject);
begin
     EcrireUneQchClick(2-6, aNormal);
end;







procedure TMainForm.Pleincran1Click(Sender: TObject);
begin
      Pleincran1.Checked := not Pleincran1.Checked;

      if Pleincran1.Checked then
      Begin
           ShowMessage(inttostr(MDIChildCount));
          // f := MDIChildren[0];
          if MDIChildren[0].Parent <> self then
                 ShowMessage('NON');
                 //MDIChildren[0].Parent := self;

            ShowMessage(inttostr(handle));
           BorderStyle := bsNone;
           WinDowState := wsMaximized;
           ShowMessage(inttostr(handle));

           MDIChildren[0].SetBounds(100,100,100,100);
           MDIChildren[0].FormStyle := fsMDIChild;

           FormStyle := fsMDIForm;
           //f.Parent := self;
           ShowMessage(inttostr(MDIChildCount));

      End
      else
      Begin
           WinDowState := wsNormal;
           BorderStyle := bsSizeable;

      End;
end;

procedure TMainForm.tbnNuancePClick(Sender: TObject);
begin
     Outil := MettreNuance;
     NuanceCourante := nvP;
end;

procedure TMainForm.tbnCourbeClick(Sender: TObject);
begin
    Outil := MettreCourbe;
end;

procedure TMainForm.Rparerlefichier1Click(Sender: TObject);
{multiple trucs de changement de format, des p'tits détails à régler}
var m, v, i, n: integer;
begin
MessageErreur('TODO : à virer un jour');
With actchild.Composition do
Begin
        For m := 0 to NbMesures - 1 do
        With GetMesure(m) do
              For v := 0 to high(Voix) do
                     For i := 0 to high(Voix[v].ElMusicaux) do
                     with Voix[v].ElMusicaux[i] do
                     Begin
                          attributs.Volume := 127;
                          for n := 0 to NbNotes - 1 do
                                SetNoteLieALaSuivanteOuPas(n);


                          Voix[v].ElMusicaux[i].CalcGDBoules;

                     End;
       PaginerApartirMes(0, true);

end;
actchild.ReaffichageComplet;
end;

procedure TMainForm.mnuCancelClick(Sender: TObject);
begin
    if not (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) then
    Begin
      CurseurSouris_Busy_Begin;

      Message_Vite_Fait_Afficher('J''annule ton ' + actchild.Composition.Cancellation_Annuler_Texte + '.');
      actchild.Composition.Cancellation_Annuler;
      actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
      actchild.ReaffichageComplet;
      CurseurSouris_Busy_End;
    End;
end;

procedure TMainForm.mnuRefaireClick(Sender: TObject);
begin
if not (MusicUser_MusicWriter_Mode_Get = mw_mode_Ecouter) then
Begin
  CurseurSouris_Busy_Begin;

  Message_Vite_Fait_Afficher('Je refais ton ' + actchild.Composition.Cancellation_Refaire_Texte + '.');
  actchild.Composition.Cancellation_Refaire;
  actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
  actchild.ReaffichageComplet;
  CurseurSouris_Busy_End;
End;
end;

procedure TMainForm.Doigtes1Click(Sender: TObject);
begin
frmDoigtes.Show;
end;

procedure TMainForm.Nouvellefentre1Click(Sender: TObject);
begin
//CreateMDIChildAccordingTo(actchild);
end;

procedure TMainForm.Accorddedominante1Click(Sender: TObject);
begin
IntChangerModeleCourant(5);
end;

procedure TMainForm.Ecriredestiercesmineures1Click(Sender: TObject);
begin
      EcrireUneQchClick(2-6, aBemol);

end;

procedure TMainForm.cboRythmeDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
      IGP := nil;
      Zoom := 75;
      CHeight := 20000;
      pixxorigin := 0;
      pixyorigin := 0;
                         //Rect.Left;
      SetViewCourantPixDeb(0, -(Rect.Top-margehaut+nbpixentreportee2-8)*100 div Zoom);


      cboRythme.Canvas.Brush.Color := clWhite;
      cboRythme.Canvas.FillRect(Rect);
      MusicGraph_Canvas_Set(cboRythme.Canvas);
      DessinerNoir;
      Rythmes[index].DrawVoix(QInfini);
      //Zoom := strtoint(cboZoom.Text); A REVOIR
end;

procedure TMainForm.cboRythmeChange(Sender: TObject);
begin
      RythmeEnCours := Rythmes[cboRythme.ItemIndex];
      CalcModeles;

end;


procedure TMainForm.mnuTrillesClick(Sender: TObject);
begin
    I_Trille_Courant_Set((Sender as TMenuItem).Tag);

end;

procedure TMainForm.CoolBarTopDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
with TToolBar(Sender) do
    setBounds(0, 0,width, height);
end;

procedure TMainForm.Barredoutils1Click(Sender: TObject);
begin
frmOptions.PageControl.ActivePageIndex := 5;
frmOptions.ShowModal;
end;





procedure TMainForm.mnuAttributsToutVirerClick(Sender: TObject);
begin
      I_Attribut_Courant_Desactiver;


End;

procedure TMainForm.panModelesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);

begin

modelePretAEtreSelectionne := (Y) div (ZoomParDefaut * Modele_Zoom div ZoomParDefaut);
if modelePretAEtreSelectionne <= high(Modeles) then
   Aide_Params_Ajouter(ElMusicalToStr(Modeles[modelePretAEtreSelectionne].Voix.ElMusicaux[0], false))
else
   Aide_Params_Ajouter('(pas de modèle sous le curseur)');


   if AncienmodelePretAEtreSelectionne <> modelePretAEtreSelectionne then
   Begin
       AncienmodelePretAEtreSelectionne := modelePretAEtreSelectionne;

       if frmHelp <> nil then //moche
           frmHelp.Hide;
   End;


//Aide_AfficherSurMainForm('Modèles',ControlBarRight.Left + tabModeles.Left,
                      //          ControlBarRight.Top + tabModeles.Top,0);
end;

procedure TMainForm.mnuDureeClick(Sender: TObject);
begin
    frmDuree.Show;
end;


procedure TMainForm.Options1Click(Sender: TObject);
begin
frmOptions.showMODAL;
end;

procedure TMainForm.tmrFinMidiNowTimer(Sender: TObject);
begin
//    MidiNow_Shut;
    Magnetophone_EteindreTout;
    //MidiNow_CloseMidiDevice;
    tmrFinMidiNow.Enabled := false;
end;

procedure TMainForm.Proprits1Click(Sender: TObject);
begin
      frmProprietes_Afficher;
end;

procedure TMainForm.Collereninversant1Click(Sender: TObject);
var temps: TDuree;

begin
     if PressePapier.IsVide then
         Message_Vite_Fait_Beep_Et_Afficher('Impossible de coller : le presse-papier est vide ! Il faut d''abord copier ou couper quelquechose !')
     else
With actchild.Curseur do
Begin
     actchild.Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, GetiMesure);
     actchild.Composition.Cancellation_Etape_Ajouter_FinDescription('coller en inversant',
                       'dans la mes. n°' + inttostr(GetiMesure + 1) + ' au temps ' + QToStr(temps),
                       VOIX_PAS_D_INFORMATION);

     temps := GetTempsDepuisDebutMesure;

     {ici, ça risque de planter car GetImesre pas bon}
     if high(PressePapier.Voix) = 0 then
     {s'il n'y a qu'une voix dans le presse-papier, on peut se permettre
      de faire un collage relatif à la portée}
           actchild.Curseur.GetVoixMesure
                   .InsererContenuVoixRel(GetiIndice,
                                          PressePapier.Voix[0],
                                          Getposition.portee, true)

     else
           actchild.Composition.CollerEnInversant(PressePapier, GetiMesure, temps);

     actchild.FaireLaPaginationEtLesCalculsPuisAffichageComplet(GetiMesure, GetiMesure, true);

     actchild.Composition.Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(GetiMesure);
     {actchild.Composition.imesdebutselection := iMesure;
     actchild.Composition.imesfinselection := iMesure; }

                 //post-conditions
      actchild.Composition.Selection_VerifierSelectionValide;
end;

end;

procedure TMainForm.tbnNoteDuBasClick(Sender: TObject);
begin
   With actchild do
   Begin
        Composition.Selection_FaireSubSelection(0);
        I_Selection_MettreAJourInfo;
        ReaffichageComplet;
   End;
end;

procedure TMainForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);

  procedure TextOut(str: string);
  Begin
       StatusBar.Canvas.TextOut(Rect.Left+20, Rect.Top+2,
                     str);
  End;

  procedure IconeTonalite(tonalite: integer);
  var num: integer;
  Begin
       if Tonalite = 0 then exit;

       if Tonalite > 0 then
             num := (Tonalite - 1) * 2
       else
             num := (-Tonalite - 1) * 2 + 1;

       imgDiesesEtBemols.Draw(StatusBar.Canvas,
                           Rect.Left+2,
                           Rect.Top+2,num);
  End;



begin

      if Panel = StatusBar.Panels[0] then
      Begin
           if TonaliteCourante = cTonaliteDeLaMesureCourante then
           Begin
                StatusBar.Canvas.Font.Style := [fsItalic];


                           
                if not MusicWriter_IsFenetreDocumentCourante then
                       TextOut('Pas de fenêtre active')
                else
                Begin
                       IconeTonalite(actchild.Curseur.GetTonaliteCourante);
                       TextOut( TonaliteToStr(actchild.Curseur.GetTonaliteCourante) +
                              '(mes. n° ' + inttostr(actchild.Curseur.GetiMesure + 1) + ')');

                End;

           End
           else
           Begin
                StatusBar.Canvas.Font.Style := [fsBold];
                IconeTonalite(TonaliteCourante);
                TextOut(  TonaliteToStr(TonaliteCourante)  );


           ENd;


      End;
end;

procedure TMainForm.mnuModeAffichage_ModepageClick(Sender: TObject);
begin
      actChild.I_ModeAffichage_Set(maPage);
end;

procedure TMainForm.mnuModeAffichage_ModerubanClick(Sender: TObject);
begin
      actChild.I_ModeAffichage_Set(maRuban);

end;

procedure TMainForm.mnuModeAffichage_Modepageavectouteslesportes1Click(Sender: TObject);
begin
     actChild.I_ModeAffichage_Set(maPageTouteLesPortees);
end;

procedure TMainForm.tlbNuancesResize(Sender: TObject);
begin
tlbNuances.Width := BarreDOutilEpaisseur;
end;

procedure TMainForm.tlbSubSelectionClick(Sender: TObject);
begin
tlbSubSelection.Width := BarreDOutilEpaisseur;
end;

procedure TMainForm.tlbClefsClick(Sender: TObject);
begin
tlbClefs.Width := BarreDOutilEpaisseur;
end;


procedure TMainForm.mnuAttribClick(Sender: TObject);
begin
    I_Attribut_Courant_Set(TMenuItem(Sender).Tag);

end;



procedure TMainForm.tbnModeClavierClick(Sender: TObject);
begin
    Entree_WaveIn_Desactiver;
    panEcrireAvecClavier.BringToFront;
end;

procedure TMainForm.tbnNoteDuHautClick(Sender: TObject);
begin
   With actchild do
   Begin
        Composition.Selection_FaireSubSelection(1);
        I_Selection_MettreAJourInfo;
        ReaffichageComplet;
   End;
end;




procedure TMainForm.panVoixSelectionneePaint(Sender: TObject);
{on affiche le cadre de voix au dessus}
begin
    With panVoixSelectionnee do
    if not MusicWriter_IsFenetreDocumentCourante then
        Begin
             Canvas.Brush.Color := clGray;
             Canvas.Brush.Style := bsSolid;
             Canvas.FillRect(ClientRect);
             
             {Canvas.Brush.Color := clWhite;
             Canvas.Brush.Style := bsFDiagonal;
             Canvas.FillRect(ClientRect);}
             exit;
        End
    else
    Begin
          Canvas.Brush.Style := bsSolid;
          actchild.VerifierIntegrite('Dessin du truc de sélection de voix');

          if Voix_Gestion_IsModeAutomatique then
             Font.Style := [fsItalic]
          else
             Font.Style := [fsBold];

          DrawCadrePresentationVoix(actChild.Composition, Canvas,
                                    Rect(0,0,Width,Height),
                                    actChild.Curseur.GetiVoixSelectionnee,1, false, false);
     End;

end;

procedure TMainForm.Voixautomatiquecriredanslesvoixpardfaut1Click(
  Sender: TObject);
begin
    Voix_Gestion_ModeAutomatique_Set(true);

    if MusicWriter_IsFenetreDocumentCourante then actchild.ReaffichageComplet;
end;

procedure TMainForm.Gestiondesvoix2Click(Sender: TObject);
begin
     frmVoix_Afficher;
end;

procedure TMainForm.Ecriredansunenouvellevoix1Click(Sender: TObject);
begin
       Voix_Gestion_ModeNouvelleVoix_Set;

end;



procedure TMainForm.panVoixSelectionneeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var nbportees: integer;
begin
    if MusicWriter_IsFenetreDocumentCourante then
    With actchild do
    Begin
       nbportees := Composition.NbPortees;
       Aide_Params_Ajouter(inttostr(Curseur.GetiVoixSelectionnee mod nbportees+1));
       Aide_Params_Ajouter(inttostr(Curseur.GetiVoixSelectionnee div nbportees+1));

       Aide_AfficherSurMainForm('Voix',tlbVoix.left +  panVoixSelectionnee.Left,
                                tlbVoix.top + panVoixSelectionnee.Top,0);
    End;
end;



procedure TMainForm.tmrHelpTimer(Sender: TObject);
begin
   tmrHelp.enabled := false;
end;

procedure TMainForm.Cyclervoix1Click(Sender: TObject);
begin
if MusicWriter_IsFenetreDocumentCourante then
    actchild.CyclerVoixCourante;
end;

procedure TMainForm.FormClick(Sender: TObject);
begin
//{$IF Defined(PRECOND)}
  Console_AjouterLigne('Test des préconditions effectuées');
  tbnAttributs.Down := true;
//{$IFEND}
end;

procedure TMainForm.CompilerenfichierWAV1Click(Sender: TObject);
begin
if MainForm.SaveDialogMIDI.Execute then
   WriteWAV(actchild.Composition, MainForm.SaveDialogMIDI.FileName);
end;



procedure TMainForm.mnuCorrigerClick(Sender: TObject);
begin
    frmCorrection_Afficher;

end;

procedure TMainForm.FileCloseItemClick(Sender: TObject);
begin
     MessageErreurSiPasDeFenetreActive('FileCloseItemClick');
     actchild.Close;
end;

procedure TMainForm.Untrucalatoire1Click(Sender: TObject);
var p, i, m: integer;
    hn: THauteurNote;

    Function HauteurAleatoire: THauteurNote;
    var j: integer;
        hn: THauteurNote;
    Begin
        if i mod 2 = 0 then
        begin
            case random(3) of
                 0: j := 0;
                 1: j := 2;
                 2: j := 4;
                 else j := 4;
                 
            end;
            hn.Hauteur := (random(4) - 2) * 7 + j;
            hn.alteration := aNormal;

        end
        else
        Begin

            hn.Hauteur := random(40) - 20;
            hn.alteration := TAlteration(random(5));
        End;
        result := hn;
    End;
    
begin
    With actchild.Composition do

      for m := 0 to 10 do
      Begin
          AddMesureFin;
          With GetMesure(m) do
          for p := 0 to NbPortees - 1 do
          for i := 1 to 4 do
          Begin
              hn := HauteurAleatoire;
              VoixNum(p).AddElMusicalFin(CreerElMusical1Note(Qel(1,1),
                                                             CreerNote(hn.hauteur,
                                                                       p,
                                                                       hn.alteration
                                                                       )
                                                             )
                                        );

          End;

    End;
    actchild.Composition.VerifierIntegriteMesure(0, 'BOUH');
    actchild.FaireLaPaginationEtLesCalculsPuisAffichageComplet(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN,
                                                               true);
end;

procedure TMainForm.panVoixSelectionneeClick(Sender: TObject);
begin
   frmVoix_Afficher;

end;

procedure TMainForm.Lettre1Click(Sender: TObject);
begin
    frmLettre_show;
end;

procedure TMainForm.tbnClefOctaveSupClick(Sender: TObject);
begin
    Outil := MettreOctavieur;
    ModeClef_Outil_Octavieur_OctavieurSelectionnee := 1;

end;

procedure TMainForm.tbnClefOctaveFinClick(Sender: TObject);
begin
    Outil := MettreOctavieur;
    ModeClef_Outil_Octavieur_OctavieurSelectionnee := 0;
end;

procedure TMainForm.tbnClefOctaveInfClick(Sender: TObject);
begin
    Outil := MettreOctavieur;
    ModeClef_Outil_Octavieur_OctavieurSelectionnee := -1;
end;

procedure TMainForm.tbnCrescendoClick(Sender: TObject);
begin
Outil := MettreCrescendo;
end;

procedure TMainForm.tbnDeCrescendoClick(Sender: TObject);
begin
    Outil := MettreDeCrescendo;
end;

procedure TMainForm.tbnNuanceMFClick(Sender: TObject);
begin
    Outil := MettreNuance;
    NuanceCourante := nvMF;
end;

procedure TMainForm.tbnNuanceFClick(Sender: TObject);
begin
    Outil := MettreNuance;
    NuanceCourante := nvF;
end;

procedure TMainForm.tbnNuanceMPClick(Sender: TObject);
begin
    Outil := MettreNuance;
    NuanceCourante := nvMP;
end;

procedure TMainForm.Clavier1Click(Sender: TObject);
begin
     frmPiano_Show;
end;

procedure TMainForm.ToolBar2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
    Aide_AfficherSurMainForm('mode_edition', 0, 0, 0);
end;

procedure TMainForm.tlbNotesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
    Aide_AfficherSurMainForm('notes_durees', 0, 0, 0);
end;

procedure TMainForm.FormPaint(Sender: TObject);

      Function IsBetaMessage_Affichage_Condition: Boolean;
      Begin
            result := FileExists('sources');
      End;

begin
    if private_bienvenue_afficher then
    Begin
        private_bienvenue_afficher := false;

        if IsBetaMessage_Affichage_Condition then
             frmBetaMessage_ShowModal;

        if MDIChildCount = 0 then
            frmBienvenue_ShowModal;

        {attention : l'ordre de ces deux instructions est importante car
                     frmBienvenue_ShowModal rappelle TMainForm.FormPaint
                     pour une raison bizarre}

    End;
end;

procedure TMainForm.FileOpenItemClick(Sender: TObject);
begin
     Fichier_Ouvrir_Document;
     Fichier_MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
end;

procedure TMainForm.Navigateurdepartition1Click(Sender: TObject);
var i: integer;
begin
   option_NavigateurAfficher := not option_NavigateurAfficher;

    for i := MDIChildCount-1 downto 0 do
    With (MDIChildren[i] as TMdiChild) do
    Begin
         Navigateur.VIsible := option_NavigateurAfficher;
         FormResize(nil);
    End;
end;



procedure TMainForm.mnuMidiIn_OpenClick(Sender: TObject);
begin
      Midi_In_Init_Basique(0);    
end;

procedure TMainForm.mnuMidiIn_CloseClick(Sender: TObject);
begin
    Midi_in_Free;
end;

procedure TMainForm.mnuMidiinClick(Sender: TObject);
begin
     mnuMidiIn_Close.Enabled := Midi_In_Is_Used;
     mnuMidiIn_Open.Enabled := (not mnuMidiIn_Close.Enabled) and Midi_in_Is_Usable;
end;

procedure TMainForm.mnuInstrumentsClick(Sender: TObject);
begin
    frmComposition_Instruments_Show;
end;

procedure TMainForm.tbnMagnetophone_PauseClick(Sender: TObject);
begin
       Magnetophone_Pause;
end;

procedure TMainForm.tbnStopClick(Sender: TObject);
begin
    Magnetophone_Stop;
end;



procedure TMainForm.mnuBarreEtatPositionClick(
  Sender: TObject);
begin
      StatusBarPosition.visible := not StatusBarPosition.visible;
      mnuBarreEtatPosition.Checked := StatusBarPosition.visible;
end;

procedure TMainForm.Mettredesparoles1Click(Sender: TObject);
begin
      Outil := MettreParoles;
end;



procedure TMainForm.Modes_PageControlChange(Sender: TObject);
      procedure ControlBarLeft_GererVisible;
      Begin
           if (MusicUser_MusicWriter_Mode_Get in [mw_mode_MettreNote,
                                                mw_mode_Selection]) then
           Begin
               ControlBarLeft.Visible := true;
               TabControlChildWin.Left := ControlBarLeft.Width;
               //panPourColmater.Visible := true;

           End
           else
           Begin
               ControlBarLeft.Visible := false;
               TabControlChildWin.Left := 0;
               //panPourColmater.Visible := false;
           End;


      End;



begin
       Modes_PageControl_Complementaire.ActivePageIndex := Modes_PageControl.ActivePageIndex;
       MusicUser_MusicWriter_Mode_Set(TMusicWriter_Mode(Modes_PageControl.ActivePageIndex));

       if (not (MusicUser_MusicWriter_Mode_Get = mw_mode_Fichier)) and not (Sender = nil) then
             MusicUser_MusicWriter_DeclarerPasDeModePrecedent;




       TabControlChildWin.Width := panTabControlChildWin.Width - TabControlChildWin.Left;

       TabControlChildWin_Redimensionner;

//       ControlBarLeft_GererVisible;

       tlbGeneral.Visible := not (MusicUser_MusicWriter_Mode_Get in
                                        [mw_mode_Fichier,
                                         mw_mode_Affichage,
                                         mw_mode_Ecouter,
                                         mw_mode_Options]);
end;

procedure TMainForm.tmrChangerDown_BoutonChiantDropDownTimer(
  Sender: TObject);
begin
     BoutonChiantDropDown.Down := BoutonChiantDropDown_NouvelleValeurdeDown;
     tmrChangerDown_BoutonChiantDropDown.Enabled := false;
end;

procedure TMainForm.BoutonChiantDropDownMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     BoutonChiantDropDown := (Sender as TToolButton);
     BoutonChiantDropDown_NouvelleValeurdeDown := (Sender as TToolButton).Down;
     {oui, oui, c'est chiant... et en plus ça a déjà changé de valeur...
     c'est pour ça que il n'y a pas de not}
end;

procedure TMainForm.tbnAttributsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     tmrChangerDown_BoutonChiantDropDown.Enabled := true;

     if BoutonChiantDropDown_NouvelleValeurdeDown then
           I_Attribut_Courant_Activer
     else
           I_Attribut_Courant_Desactiver;
end;

procedure TMainForm.tbnTrillesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     tmrChangerDown_BoutonChiantDropDown.Enabled := true;

     if BoutonChiantDropDown_NouvelleValeurdeDown then
           I_Trille_Courant_Activer
     else
           I_Trille_Courant_Desactiver;
end;

procedure TMainForm.mnuTrillesRienClick(Sender: TObject);
begin
     I_Trille_Courant_Desactiver;
end;

procedure TMainForm.AfficherfentreAnnulerRefaire1Click(Sender: TObject);
begin
       frmCancellation_Window.Show;
end;

procedure TMainForm.lstModelesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var Modele_largeurcasemodele: integer;
    Modele_Texte_X, Modele_Texte_Y: integer;
begin
    ModelesVerifier;
    Zoom := Modele_Zoom;
    MusicGraph_Canvas_Set(lstModeles.Canvas);
    C.Brush.Color := CouleurFondEcran;


    IGP := nil;
    CHeight := 20000;

    Modele_largeurcasemodele := prec*lstModeles.Width * ZoomParDefaut div Modele_Zoom;

    Modele_Texte_X := Rect.Left + lstModeles.Width div 3;
    Modele_Texte_Y := Rect.Top + (ZoomParDefaut)div 5;

    SetViewCourantPixDeb(Rect.Left * ZoomMaxPrec div Zoom,  -(Rect.Top-4) * ZoomMaxPrec div Zoom);
    SetPixOrigin(0, 0);

    if ModeleSousCurseur = Index then
          C.Brush.Color := couleurfondmodelesouscurseur
    else
          C.Brush.Color := CouleurFondEcran;

    C.FillRect(Rect);
    DessinerNoir;
    SetPixOrigin(320, 0);
    DrawLinesPour1Portee(nil {l'affichage d'un modèle se fait hors contexte
                              d'un quelconque objet TComposition...
                              on met nil},
                         0 {comme nil, le paramètre "n° ligne" est ignoré}
                         ,0,Modele_largeurcasemodele,0);

    Modeles[Index].Voix.DrawVoix(QInfini);
    
    C.Brush.color := clWhite;

    C.Font.Color := 0;
    if ModeleSousCurseur = Index then
           C.Font.Size := 8
    else
           C.Font.Size := 7;
           
    C.TextOut(Modele_Texte_X, Modele_Texte_Y, Modeles[Index].Nom);





   { if cboZoom.Text = '' then
    Begin
          MessageErreur('cboZoom.Text = ''''');
          cboZoom.Text := '100';
          Zoom := 100;
    End
    else
           Zoom := strtoint(cboZoom.Text);     }// A REVOIR
end;

procedure TMainForm.lstModelesClick(Sender: TObject);
begin
       IntChangerModeleCourant(lstModeles.ItemIndex);
       Focus_ToutVirer;

end;



procedure TMainForm.Focus_ToutVirer;
begin
       cmdRebus.setfocus;
       DefocusControl(cmdRebus, true);


       if MusicWriter_IsFenetreDocumentCourante then
           actchild.SetFocus;

       frmFenetreRien.Show;
end;



procedure TMainForm.lstSelection_VoixListeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
     if not MusicWriter_IsFenetreDocumentCourante then exit;
         actchild.VerifierIntegrite('affichage d''un élément de la liste des voix');

    {on affiche un cadre blanc pour éviter les bugs d'affichage :
    - fond qui devient noir
    - rectangle de sélection qui reste
    }
    With Control as TListBox do
    Begin
         Canvas.Brush.Style := bsSolid;
         Canvas.Brush.Color := clBtnFace;
         Canvas.FillRect(Rect);


         DrawCadrePresentationVoix(actChild.Composition,
                                   Canvas,
                                   Rect,
                                   strtoint(Items[Index]),1, false, false);
    End;
end;





procedure TMainForm.PopupMenuSelectionVoixPopup(Sender: TObject);
begin
With lstSelection_VoixListe do
      Begin
          if ItemIndex = -1 then
          Begin
               Sousslectionnerlesnotesdelavoix1.Enabled := false;
               Placerlesnotesdanscettevoix1.Enabled := false;
          End
          else
          Begin
               Sousslectionnerlesnotesdelavoix1.Enabled := true;
               Placerlesnotesdanscettevoix1.Enabled := true;
               PopupMenuSelectionVoix.Tag := strtoint(Items[ItemIndex]);
          End;

      End;
end;

procedure TMainForm.Sousslectionnerlesnotesdelavoix1Click(Sender: TObject);
var voix_num: integer;
begin
       voix_num := PopupMenuSelectionVoix.Tag;

       With actchild do
      Begin
           Composition.Selection_FaireSubSelectionQueVoixNum(voix_num);
           I_Selection_MettreAJourInfo;
           ReaffichageComplet;
      End;
end;

procedure TMainForm.Placerlesnotesdanscettevoix1Click(Sender: TObject);
var voix_num: integer;
begin
       voix_num := PopupMenuSelectionVoix.Tag;
       actchild.I_Selection_PlacerDansVoix(voix_num);

end;

procedure TMainForm.trkZoomChange(Sender: TObject);
    Function ComposantTickToZoom(tick: integer): integer;
    const tick_de_zoom100 = 50;
    const zoom_min = 20;
    Begin
         result := Round(zoom_min*exp( 1/tick_de_zoom100 * ln(100 / zoom_min) * tick));
    End;

begin
     actChild.Zoom_Set_AuMilieu(ComposantTickToZoom(trkZoom.Position));

     Focus_ToutVirer;
end;

procedure TMainForm.tlbZoomArriereClick(Sender: TObject);
begin
   actChild.Zoom_Set_AuMilieu(Round(actChild.Zoom_Get * 0.8));
end;

procedure TMainForm.tlbZoomAvantClick(Sender: TObject);
begin
     actChild.Zoom_Set_AuMilieu(Round(actChild.Zoom_Get * 1.2));
end;

procedure TMainForm.Slectionnertout1Click(Sender: TObject);
begin
        actchild.Composition.Selection_SelectionnerTout;
        actchild.ReaffichageComplet;
end;

procedure TMainForm.Fentredecontrledufluxmicrophone1Click(Sender: TObject);
begin
    frmEntree_wavein_fft.show;
end;

procedure TMainForm.mnuEntree_WaveIn_ActiverClick(Sender: TObject);
begin
      Entree_WaveIn_Activer;
end;

procedure TMainForm.mnuEntree_WaveIn_DesactiverClick(Sender: TObject);
begin
    Entree_WaveIn_Desactiver;
end;

procedure TMainForm.tlbDureeApproximative_SetClick(Sender: TObject);
begin
     actchild.Composition.I_Selection_Duree_Approximative_SwitchTo;
     actchild.ReaffichageComplet;
end;



procedure TMainForm.panPlacerDansNouvelleVoixClick(Sender: TObject);
begin
      if actchild.Composition.Selection_IsToutDeselectionner then
          beep
      else
          actchild.I_Selection_PlacerDansVoix(actchild.Selection_NouvelleVoixIndice_Get);
end;



procedure TMainForm.tbnModeMicrophoneClick(Sender: TObject);
begin
      panEcrireAvecMicrophone.BringToFront;
      Entree_WaveIn_Activer;
end;

procedure TMainForm.TabControlChildWinChange(Sender: TObject);
begin
     (TabControlChildWin.Tabs.Objects[TabControlChildWin.TabIndex] as TMDIChild).Show;
     Magnetophone_Stop;
end;

procedure TMainForm.tlbImprimerClick(Sender: TObject);
begin
      frmImprimer.showmodal;
end;

Function TMainForm.TabControlChildWinIndice_Get(child: TMDIChild): integer;
var i:integer;

Begin
      result := -1;
      for i := 0 to TabControlChildWin.Tabs.Count - 1 do
            if TabControlChildWin.Tabs.Objects[i] = child then
            Begin
                result := i;
                exit;
            End;

      if result = -1 then
            MessageErreur('TabControlChildWinIndice_Get');

End;

procedure TMainForm.tbnPasteMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
      if MusicWriter_IsFenetreDocumentCourante and not PressePapier.IsVide then
      Begin
           actchild.SetCurrentView;
           frmPressePapier.Left := Left +
                                   Modes_PageControl_Complementaire.Width +
                                   actchild.Curseur_XDansFenetre_Get;
           frmPressePapier.Top := Top +
                                 Modes_PageControl.Height +
                                 panTabControlChildWin.Height +
                                   actchild.Curseur_YDansFenetre_Get;
           frmPressePapier_Show;

      End;
end;

procedure TMainForm.actionNotesLierALaSuivanteExecute(Sender: TObject);
begin
     With actchild.Composition do
      Begin
             Selection_LierNotesSelectionneesAuxSuivantes;
             PaginerApresModifSelection(false);
      end;

actchild.ReaffichageComplet;
end;

procedure TMainForm.Modes_PageControlDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var Canvas: TCanvas;
    s: string;
    TextW, TextH, X, Y: integer;

    Function Caption_Get: string;
    var i, ind : integer;
    Begin
          ind := -1;
          for i := 0 to Modes_PageControl.PageCount - 1 do
          Begin
               if Modes_PageControl.Pages[i].TabVisible then
                  inc(ind);

               if ind = TabIndex then
               Begin
                   result :=  Modes_PageControl.Pages[i].Caption;
                   Exit;
               End;
          End;

          MessageErreur('Erreur dans Modes_PageControlDrawTab :: Caption_Get');
          result := '';
    End;

    const TabModeActive_CouleurFond = $4400EE;//clBtnFace;
          TabModeActive_CouleurTexte = $CCFFFF;

{          TabModeActive_CouleurFond = clBtnFace;
          TabModeActive_CouleurTexte = $88;}

          TabModeDesactive_CouleurFond = $BBBBBB;
          TabModeDesactive_CouleurTexte = 0;

begin
      Canvas := Modes_PageControl.Canvas;

      s := Caption_Get;

      if Active then
      Begin
           Canvas.Font.Style := [fsBold];
           Canvas.Font.Size := 10;
           Canvas.Font.Color := TabModeActive_CouleurTexte;
           Canvas.Brush.Color := TabModeActive_CouleurFond;
           Canvas.StretchDraw(Rect, imgTabModeActive.Picture.Graphic);
           //Canvas.FillRect(Rect);

      End
      else
      Begin
           Canvas.Font.Style := [];
           Canvas.Font.Size := 8;
           Canvas.Font.Color := TabModeDesactive_CouleurTexte;
           Canvas.Brush.Color := TabModeDesactive_CouleurFond;
           Canvas.FillRect(Rect);
      End;


      TextW := Canvas.TextWidth(s);
      TextH := Canvas.TextHeight(s);


      X := (Rect.Left + Rect.Right) div 2 - TextW div 2;
      Y := (Rect.Top + Rect.Bottom) div 2 - TextH div 2;

      if not Active then
         inc(Y, 3);
      Canvas.Brush.Style := bsClear;
      Canvas.TextOut(X, Y, s);
end;

procedure TMainForm.TabControlChildWinDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var Canvas: TCanvas;

begin
    Canvas := Control.Canvas;

    if Active then
    Begin
        Canvas.StretchDraw(Rect, imgfichiertab_courant_fond.Picture.Graphic);
        Canvas.Brush.Style := bsClear;
    End;
        //C.Font.Style := [];


    Canvas.TextOut(Rect.left + 2, Rect.Top + 3, TabControlChildWin.Tabs[TabIndex]);

    if TMDIChild( TabControlChildWin.Tabs.Objects[TabIndex] ).Composition_Enregistrement_IsABesoinDEtreEnregistre then
    Begin
        if (private_TabControlChildWin_NumTab_Courant = TabIndex) and (private_TabControlChildWin_Button_Courant = 0) then
               imgList.Draw(Canvas, Rect.Right - 22 - 22, Rect.Top + 4, 77)
        else
              imgList.Draw(Canvas, Rect.Right - 22 - 22, Rect.Top + 4, 8);
        {Canvas.Brush.Style := bsSolid;    77
        Canvas.Brush.Color := 0;
        Canvas.Ellipse(Rect.Right - 10, Rect.Top + 10, Rect.Right - 5, Rect.Top + 5);   }
    End;

    //croix de fermeture                   78

    if (private_TabControlChildWin_NumTab_Courant = TabIndex) and (private_TabControlChildWin_Button_Courant = 1) then
           imgList.Draw(Canvas, Rect.Right - 22, Rect.Top + 4, 78)
    else
            imgList.Draw(Canvas, Rect.Right - 22, Rect.Top + 4, 5);

end;

procedure TMainForm.cboPeripheriqueEntreeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
     if frmEnregistreur = nil then exit;
     
     frmEnregistreur.ImageListSource.Draw(cboPeripheriqueEntree.Canvas, Rect.left, Rect.Top, Index);
     cboPeripheriqueEntree.Canvas.TextOut(Rect.Left + 20, Rect.Top, cboPeripheriqueEntree.Items[Index]);
end;

procedure TMainForm.tbnEnregistreurEnregistrerClick(Sender: TObject);
begin
     Enregistreur_Enregistrer;
end;

procedure TMainForm.tbnEnregistreurStopClick(Sender: TObject);
begin
       Enregistreur_Stop;
end;


procedure TMainForm.mnuEcrireAvecGeneriqueClick(Sender: TObject);
begin
      mnuEcrireAvecSouris.Checked := false;
      mnuEcrireAvecClavier.Checked := false;
      mnuEcrireAvecMicrophone.Checked := false;

      With (Sender as TMenuItem) do
      Begin
          Checked := true;
          tbnEcrireAvec.Caption := Caption;
          tbnEcrireAvec.ImageIndex := ImageIndex;
      End;

      panEcrireAvecSouris.Visible := false;
      panEcrireAvecClavier.Visible := false;
      panEcrireAvecClavier2.Visible := false;
      panEcrireAvecMicrophone.visible := false;
      
      if Outil_MettreNoteIsModeSouris then
      Begin
         Entree_WaveIn_Desactiver;
         panEcrireAvecSouris.Visible := true;
      End
      else if Outil_MettreNoteIsModeClavier then
      Begin
         Entree_WaveIn_Desactiver;
         panEcrireAvecClavier.Visible := true;
         panEcrireAvecClavier2.visible := true;
      End
      else
      Begin
         Entree_WaveIn_Activer;
         panEcrireAvecMicrophone.visible := true;
      End;
            
end;

procedure TMainForm.frmMagnetophonetbnStopClick(Sender: TObject);
begin
  Magnetophone_Stop;

end;



procedure TMainForm.TailleNotes_Traiter(petitesnotes: Boolean);
var m, i: integer;
    Begin
          if MusicUser_Musicwriter_Mode_Get = mw_mode_Selection then
              actchild.Composition.I_Selection_Notes_Taille_Set(petitesnotes);

          for m := 0 to high(Modeles) do with Modeles[m] do
               for i := 0 to high(Voix.ElMusicaux) do with Voix.ElMusicaux[i] do
                      attributs.PetitesNotes := petitesnotes;

          lstModeles.Refresh;
          actchild.ReaffichageComplet;
    End;


procedure TMainForm.tbnTailleNotesClick(Sender: TObject);


begin
    TailleNotes_Traiter((Sender as TToolButton).Tag = 1);

end;

procedure TMainForm.mnuPetitesNotesClick(Sender: TObject);
begin
        ToolBarButtonFromMenuItem(tbnTailleNotes, (Sender as TMenuItem));
        tbnTailleNotes.Indeterminate := false;
        TailleNotes_Traiter((Sender as TMenuItem).Tag = 1);

end;

procedure TMainForm.FormResize(Sender: TObject);
    procedure panTopResize;
    Begin
        Modes_PageControl.Width := panTop.Width;
        cmdHelp.Left := panTop.Width - cmdHelp.Width;
        cmdDebug.Left := panTop.Width - cmdHelp.Width - cmdDebug.Width;
    End;


begin
    TabControlChildWin_Redimensionner;
    panTopResize;
end;



procedure TMainForm.TabControlChildWin_GetNumTabEtButton(X: integer; var ouput_numtab: integer; var output_button: integer);
Begin
    ouput_numtab := X div TabControlChildWin.TabWidth;
    if ouput_numtab > TabControlChildWin.Tabs.Count - 1 then
         ouput_numtab := -1
    else
    Begin
        X := X mod TabControlChildWin.TabWidth;

        output_button := -1;
        if X > TabControlChildWin.TabWidth - 19 then
             output_button := 1
        else if X > TabControlChildWin.TabWidth - 38 then
             output_button := 0;

    End;

End;



procedure TMainForm.TabControlChildWinMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var numtab, num_button : integer;
begin
    TabControlChildWin_GetNumTabEtButton(X, numtab, num_button);
    numtab := X div TabControlChildWin.TabWidth;

    if numtab = -1 then
        beep
    else
    Begin
        if num_button = 0 then
              (TabControlChildWin.Tabs.Objects[TabControlChildWin.TabIndex] as TMDIChild)
                  .TenterEnregistrer(false)
        else if num_button = 1 then
             (TabControlChildWin.Tabs.Objects[TabControlChildWin.TabIndex] as TMDIChild)
                  .Close;

    End;
end;

procedure TMainForm.TabControlChildWinMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    TabControlChildWin_GetNumTabEtButton(X, private_TabControlChildWin_NumTab_Courant, private_TabControlChildWin_Button_Courant);
    TabControlChildWin.Refresh;
end;

procedure TMainForm.Nouvellepartitionpersonalise1Click(Sender: TObject);
begin
       frmNouveauAssistant_Afficher;
end;

procedure TMainForm.Nouvellepartitionpiano1Click(Sender: TObject);
begin
     Fichier_NouveauDocumentViteFait_Piano;
end;

procedure TMainForm.Nouvellepartitionguitare1Click(Sender: TObject);
begin
       Fichier_NouveauDocumentViteFait_Guitare;
end;



procedure TMainForm.actionFileCloseExecute(Sender: TObject);
begin
      if MusicWriter_IsFenetreDocumentCourante then
          (TabControlChildWin.Tabs.Objects[TabControlChildWin.TabIndex] as TMDIChild)
              .Close
              
      else
            Message_Vite_Fait_Afficher('Aucun document n''est ouvert : je n''ai rien à fermer.');

            
end;

procedure TMainForm.actionMagnetophoneIctusPoserExecute(Sender: TObject);
begin
    actchild.Magnetophone_Ictus_Poser;
    actchild.Magnetophone_Curseur_Exciter_Bcp;
end;

procedure TMainForm.actionMagnetophoneIctusToutEffacerExecute(
  Sender: TObject);
begin
      actchild.Magnetophone_Ictus_Reset;
end;

procedure TMainForm.tbnDurees_DevinerClick(Sender: TObject);
begin
    actchild.Composition.I_Selection_Duree_Inferer;
end;

procedure TMainForm.tbnFileExporterMIDIClick(Sender: TObject);
begin
     mnuCompilerenfichierMIDIClick(Sender);
end;

procedure TMainForm.tbnNouveauMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
      tbnNouveau.CheckMenuDropdown;
end;

procedure TMainForm.actionMagnetophoneLectureExecute(Sender: TObject);
begin
      Magnetophone_Lecture;
end;

procedure TMainForm.Modes_PageControlMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var i: integer;
begin
      if ssLeft in Shift then
      for i := 0 to Modes_PageControl.PageCount-1 do
           if Modes_PageControl.Pages[i].TabVisible then
           if PointInRect(x, y, Modes_PageControl.TabRect(i) ) then
           Begin
                   Modes_PageControl.ActivePageIndex := i;
                   Modes_PageControlChange(nil);
           End;
end;

procedure TMainForm.tbnSelection_ChangerDureesClick(Sender: TObject);
begin
      frmDuree.ShowModal;
end;

procedure TMainForm.cmdPropertiesClick(Sender: TObject);
begin
     frmProprietes_Afficher;
end;

procedure TMainForm.tbnEcrireNotesClick(Sender: TObject);
begin
    IntChangerModeleCourant(0);
    lblNotesDuree.Caption := Langues_Traduire('Durée des notes :');
    frameEcrireDureeChoix.InterfaceNotes;
end;

procedure TMainForm.tbnEcrireSilencesClick(Sender: TObject);
begin
        IntChangerModeleCourant(1);
        lblNotesDuree.Caption := Langues_Traduire('Durée des silences :');
        frameEcrireDureeChoix.InterfaceSilences;
end;

procedure TMainForm.tbnMagnetophone_DebutClick(Sender: TObject);
begin
     Magnetophone_AllerauDebut;
end;

procedure TMainForm.tbnMagnetophone_FinClick(Sender: TObject);
begin
    Magnetophone_AlleralaFin;
end;

procedure TMainForm.cmdHelpClick(Sender: TObject);
begin
    AideGenerale_Afficher(MusicUser_MusicWriter_Mode_Get);
end;

procedure TMainForm.tbnAltererSelonTonaliteClick(Sender: TObject);
begin
      actchild.I_AltererSelonUneTonalite(nil);
end;

procedure TMainForm.tlbSelectionAltererClick(Sender: TObject);
begin
       frmSelectionAlterer.ShowModal;
end;

procedure TMainForm.tbnModeRubanClick(Sender: TObject);
begin
     actChild.I_ModeAffichage_Set(maRuban);
end;

procedure TMainForm.tbnModePageEditerClick(Sender: TObject);
begin
      actChild.I_ModeAffichage_Set(maPageTouteLesPortees);
end;

procedure TMainForm.tbnModePageCleanClick(Sender: TObject);
begin
      actChild.I_ModeAffichage_Set(maPage);
end;

procedure TMainForm.tlbSelectionEnharmoniquerClick(Sender: TObject);
begin
     actchild.I_AjusterNotesEtAlterationsSelonUneTonalite(nil);
end;

procedure TMainForm.cmdDebugClick(Sender: TObject);
begin
    Console_Afficher;
end;

procedure TMainForm.cmdVoixSelectionnerAnnulerClick(Sender: TObject);
begin
    Voix_Selectionner_Dans_Partition_Close;
end;

procedure TMainForm.actionVoixSpecifiqueExecute(Sender: TObject);
begin
    if Voix_Gestion_IsModeAutomatique then
         Voix_Gestion_ModeAutomatique_Set(false)
    else
    Begin
         Voix_Gestion_ModeAutomatique_Set(true);
         actchild.FormMouseMove(nil, [], actchild.Curseur_XDansFenetre_Get, actchild.Curseur_YDansFenetre_Get);
         Voix_Gestion_ModeAutomatique_Set(false);

    End;
end;

procedure TMainForm.actionVoixAutomatiqueExecute(Sender: TObject);
begin
     Voix_Gestion_ModeAutomatique_Set(true);
end;

procedure TMainForm.tbnVoixSpecifiqueClick(Sender: TObject);
begin
    Voix_Gestion_ModeAutomatique_Set(true);
    Voix_Selectionner_Dans_Partition_Init('Dans quel voix veux-tu écrire ?');
end;

procedure TMainForm.actionVoixNouvelleExecute(Sender: TObject);
begin
     Voix_Gestion_ModeNouvelleVoix_Set;
end;

procedure TMainForm.lstSelection_VoixListeClick(Sender: TObject);
var voix_num: integer;
begin
       if lstSelection_VoixListe.ItemIndex = -1 then
       Begin
              beep;
              exit;
       End;

       voix_num := strtoint(lstSelection_VoixListe.Items[lstSelection_VoixListe.ItemIndex]);

       With actchild do
      Begin
           Composition.Selection_FaireSubSelectionQueVoixNum(voix_num);
           I_Selection_MettreAJourInfo;
           ReaffichageComplet;
      End;

end;

procedure TMainForm.lstSelection_Voix_PlacerDansClick(Sender: TObject);
var voix_num: integer;
begin
       if lstSelection_Voix_PlacerDans.ItemIndex = -1 then
       Begin
              beep;
              exit;
       End;

       voix_num := strtoint(lstSelection_Voix_PlacerDans.Items[lstSelection_Voix_PlacerDans.ItemIndex]);

       actchild.I_Selection_PlacerDansVoix(voix_num);
      


end;

procedure TMainForm.tbnSelection_FusionnerNotesEtSilencesClick(
  Sender: TObject);
begin
     actchild.I_Selection_FusionnerNotesEtSilences(nil);
end;

procedure TMainForm.tbnI_Selection_DureesDiviserParDeuxPuisSilenceClick(
  Sender: TObject);
begin
       actchild.I_Selection_DureesDiviserParDeuxPuisSilence(nil);
end;

procedure TMainForm.tbnMicrophoneClick(Sender: TObject);
begin
       if Entree_WaveIn_IsActive then
       Begin
             Entree_WaveIn_Desactiver;
             tbnMicrophone.Down := false;
       End
       else
             Entree_WaveIn_Activer;

end;

procedure TMainForm.cboPeripheriqueEntreeClick(Sender: TObject);
begin
     Focus_ToutVirer;
end;

procedure TMainForm.tbnExporterLilypondClick(Sender: TObject);
begin
     if MainForm.SaveDialogLilypond.Execute then
      Begin
         WriteLilypond(actchild.Composition, MainForm.SaveDialogLilypond.FileName);
      End; 
end;

procedure TMainForm.actionVoixSpecifiqueQuandModeSpecifiqueExecute(
  Sender: TObject);
begin
   Voix_Gestion_ModeAutomatique_Set(true);
   Voix_Gestion_ModeAutomatique_Set(false);
end;

procedure TMainForm.ModeMesures_ToutAlaFinClick(Sender: TObject);
begin
    Mode_Mesures_SetFinMes(actchild.Composition.NbMesures - 1);
    actchild.ReaffichageComplet;
end;


procedure TMainForm.ModeMesures_ToutDebutClick(Sender: TObject);
begin
    Mode_Mesures_SetDebMes(0);
    actchild.ReaffichageComplet;
end;

procedure TMainForm.txtMesDebChange(Sender: TObject);
var k:char;
begin

     MessageErreurSiPasDeFenetreActive('txtMesDebChange');


    IntegerEditBoxKeyPress(TEdit(Sender), k);
    if Sender = txtMesDeb then
        actchild.ReaffichageComplet;
end;

procedure TMainForm.txtMesFinChange(Sender: TObject);
var k:char;
begin
    MessageErreurSiPasDeFenetreActive('txtMesFinChange');

    IntegerEditBoxKeyPress(TEdit(Sender), k);
    if Sender = txtMesFin then
        actchild.ReaffichageComplet;
end;

procedure TMainForm.ToolButton3Click(Sender: TObject);
begin
      frmMesures_Tempo.ShowModal;
end;

procedure TMainForm.ToolButton5Click(Sender: TObject);
begin
      frmMesures_Metronome.ShowModal;
end;

procedure TMainForm.ToolButton6Click(Sender: TObject);
begin
     frmMesures_Signature_Temporelle.ShowModal;
end;

procedure TMainForm.ToolButton9Click(Sender: TObject);
begin
    frmMesures_Tonalite.ShowModal;
end;

procedure TMainForm.ToolButton10Click(Sender: TObject);
begin
     frmMesures_Barres.ShowModal;
end;

procedure TMainForm.tbnMesureDAddClick(Sender: TObject);
begin
    MessageErreurSiPasDeFenetreActive('tbnMesureDAddClick');

     actchild.Composition.I_Mesures_Ajouter_Mesure_Vide( Mode_Mesures_GetFinMes+1, '(ajout à droite)');
     actchild.ReaffichageComplet;
end;

procedure TMainForm.tbnMesuresSupprClick(Sender: TObject);
begin
   MessageErreurSiPasDeFenetreActive('tbnMesureSupprClick');

  actchild.I_Mesures_Supprimer(Mode_Mesures_GetDebMes, Mode_Mesures_GetFinMes);

  Mode_Mesures_SetDebFinMes(Mode_Mesures_GetDebMes, Mode_Mesures_GetDebMes);
  Mode_Mesures_SassurerDesValeursDeDebMesEtFinMes;
end;

procedure TMainForm.cmdPartition_InstrumentsClick(Sender: TObject);
begin
     frmComposition_Instruments_Show;
end;

end.





