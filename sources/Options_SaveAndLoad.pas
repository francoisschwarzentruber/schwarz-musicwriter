unit Options_SaveAndLoad;

interface

Procedure INISave;
Procedure INILoad;
procedure INILoadProprieteDemarrage;


type
TPresentation_NumerotationDesMesures = (pnmAucune,
                                        pnmToutesles5mesures,
                                        pnmEnDebutDeLignes,
                                        pnmToutes
                                        );

TPresentation_Affichage_Noms_Portees = (panpAucune,
                                        panpJusteSurLaPremiereLigne,
                                        panpToutes);

TPresentation_Affichage_Barres_Mesures = (pabmToutLeLong,
                                          pabmParInstrument,
                                          pabmParPortee);


var {variable configurable enregistré dans le fichier INI}
    CompleterAutomatiquementAvecPausesEnDebut: Boolean = true;

    CurseurDeplaceApresMiseDeNote: Boolean = true;

    option_RedessinerQuandScrollBar: Boolean = true;
      {qd vaut true, qd on bouge les barres de défilement ça redessine tout illico}

    AfficherBulleDaide: Boolean;

    option_NavigateurAfficher: Boolean = true;
    option_Presentation_NumerotationDesMesures: TPresentation_NumerotationDesMesures;
    option_Presentation_Affichage_Noms_Portees: TPresentation_Affichage_Noms_Portees;
    option_Presentation_Affichage_Barres_Mesures: TPresentation_Affichage_Barres_Mesures;


    option_ClavierElectroniqueActive: Boolean = false;
    option_CopierColler_AlaUnix_Utiliser_La_Fonctionnalite: Boolean = true;
    option_PorteeCourante_ZoomActive_Quand_PartitionOrchestre: Boolean = true;

    option_VoixInactive_ToujoursFondPlusClair: Boolean = true;
    
implementation

uses inifiles, StdCtrls, MusicUser, Options,
     MusicGraph_CercleNote {NotesEnEllipse},
     MusicGraph {ToutDessinerDansBitmapScrDabord},
     Graphics {pour le type TColor},
     MusicGraph_CouleursVoix {pour MusicGraph_CouleursVoix_tabCouleursVoixFondList},
     SysUtils {pour inttostr},
     ComCtrls {pour TToolBar},
     CurseursSouris,
     Intro,
     Ouvrir;


var SectionCourante: string;


procedure ToolBar_GetIndiceBoutonEnfonce(tb: TToolBar; var v: integer);
var i: integer;
Begin
    v := -1;
    
    for i := 0 to tb.ButtonCount - 1 do
        if tb.Buttons[i].Down then
        Begin
            v := i;
            exit;
        End;
End;


procedure ToolBar_SetBoutonEnfonce(tb: TToolBar; v: integer);
var i: integer;
Begin
    for i := 0 to tb.ButtonCount - 1 do
        tb.Buttons[i].Down := (i = v);
End;




procedure INILoadProprieteDemarrage;
var IniFile: TIniFile;
Begin
    INIFile := TIniFile.Create(DossierRacine + 'config\music.ini');
    option_Demarrage_Jingle := INIFile.ReadBool('Demarrage', 'Jingle', true);
    INIFile.Free;
End;




Procedure INISaveOrLoad(IniEnLecture: Boolean);
{cette procédure concerne le fichier INI music.ini. Si IniEnLecture est vraie,
  elle charge le fichier pour configurer MusicWriter...
  Sinon, elle enregistre la configuration courante}

var IniFile: TIniFile;
    v: integer;



    procedure NouvelleSection(s: string);
    Begin
         SectionCourante := s;
    end;
    
    procedure INIBool(var variable: Boolean; Control: TCheckBox; nom: string);
    Begin
         if IniEnLecture then
         Begin
            variable := INIFile.ReadBool(SectionCourante, nom, true);
            Control.Checked := variable;
         End
         else
         Begin
            variable := Control.Checked;
            INIFile.WriteBool(SectionCourante, nom, variable);
         End;
     End;


     procedure INIStr(var str: string; nom: string);
     Begin
         If IniEnLecture then
         Begin
             str := INIFile.ReadString(SectionCourante, nom, str);
         end
         else
         Begin
             INIFile.WriteString(SectionCourante, nom, str);
         End;
     End;


     procedure INIBoolToolBar(var variable: Boolean; Control: TToolbar; nom: string);
    Begin
         if IniEnLecture then
         Begin
            variable := INIFile.ReadBool(SectionCourante, nom, true);

             Control.Buttons[0].Down := variable;
             Control.Buttons[1].Down := not variable;
         End
         else
         Begin
            variable := Control.Buttons[0].Down;
            INIFile.WriteBool(SectionCourante, nom, variable);
         End;
     End;


     procedure INIInt(var variable: integer; nom: string);
     Begin
         if IniEnLecture then
            variable := INIFile.ReadInteger(SectionCourante, nom, 0)
         else
            INIFile.WriteInteger(SectionCourante, nom, variable);

     End;
     

     type PColor = ^TColor;

     procedure INIColor(var variable: Pcolor; nom: string);
    Begin
         if IniEnLecture then
            variable^ := INIFile.ReadInteger(SectionCourante, nom, $FFFFFF)
         else
            INIFile.WriteInteger(SectionCourante, nom, variable^);
     End;

     
    procedure INI_Voix_Couleurs;
    var ip: integer;
        iv: integer;
        p: PColor;
        
    Begin
         NouvelleSection('Voix_Couleurs');

         for ip := 0 to 1 do
            for iv := 0 to 3 do
            Begin
                 p := @MusicGraph_CouleursVoix_tabCouleursVoixFondList[ip, iv];
                 INIColor(p, 'FondList_' + inttostr(ip) + '_' + inttostr(iv));
            End;

         for ip := 0 to 1 do
            for iv := 0 to 3 do
            Begin
                 p := @MusicGraph_CouleursVoix_tabCouleursVoixFond[ip, iv];
                 INIColor(p, 'Fond_' + inttostr(ip) + '_' + inttostr(iv));
            End;

         for ip := 0 to 1 do
            for iv := 0 to 3 do
            Begin
                 p := @MusicGraph_CouleursVoix_tabCouleursVoixNonAccessibleFond[ip, iv];
                 INIColor(p, 'Fond_NonAccessible' + inttostr(ip) + '_' + inttostr(iv));
            End;

         for ip := 0 to 1 do
            for iv := 0 to 3 do
            Begin
                 p := @MusicGraph_CouleursVoix_tabCouleursVoixNote[ip, iv];
                 INIColor(p, 'Notes_' + inttostr(ip) + '_' + inttostr(iv));
            End;


         MusicGraph_CouleursVoix_CalculerTables;
    End;




Begin

    INIFile := TIniFile.Create(DossierRacine + 'config\music.ini');

    NouvelleSection('Ouvrir');
    INIStr(Ouvrir_Partition_CheminParDefaut, 'Partition_CheminParDefaut');

    NouvelleSection('Edition');

    INIBool(CompleterAutomatiquementAvecPausesEnDebut,
            frmOptions.chkCompleterAutomatiquementAvecPausesEnDebut,
            'CompleterAutomatiquementAvecPausesEnDebut');

    INIBool(option_ClavierElectroniqueActive,
            frmOptions.chkClavierElectroniqueActive,
            'ClavierElectroniqueAuClavier');

    INIBoolToolBar(option_PorteeCourante_ZoomActive_Quand_PartitionOrchestre,
                   frmOptions.tlbPorteeCourante_ZoomActive_Quand_PartitionOrchestre,
                   'PorteeCourante_ZoomActive_Quand_PartitionOrchestre');


    NouvelleSection('Demarrage');
    
    INIBool(option_Demarrage_Jingle,
            frmOptions.chkDemarrage_Jingle,
            'Jingle');

    NouvelleSection('Souris');

    INIBool(CurseurDeplaceApresMiseDeNote,
            frmOptions.chkCurseurDeplaceApresMiseDeNote,
            'CurseurDeplaceApresMiseDeNote');

    INIBool(option_CopierColler_AlaUnix_Utiliser_La_Fonctionnalite,
             frmOptions.chkCopierColler_AlaUnix_Utiliser_La_Fonctionnalite,
             'CopierColler_AlaUnix_Utiliser_La_Fonctionnalite');

    ToolBar_GetIndiceBoutonEnfonce(frmOptions.tlbNoteAInsererAUneGrappe_Souris_Curseur, option_NoteAInsererAUneGrappe_Souris_Curseur);
    INIInt(option_NoteAInsererAUneGrappe_Souris_Curseur, 'NoteAInsererAUneGrappe_Souris_Curseur');
    ToolBar_SetBoutonEnfonce(frmOptions.tlbNoteAInsererAUneGrappe_Souris_Curseur, v);

    NouvelleSection('Optimisation');

    INIBoolToolBar(NoteEnEllipse,
            frmOptions.tlbNotes_Ellipses_ou_Cercles,
            'NoteEnEllipse');
    INIBool(option_RedessinerQuandScrollBar,
            frmOptions.chkRedessinerQuandScrollBar,
            'RedessinerQuandScrollBar');
    INIBool(ToutDessinerDansBitmapScrDabord,
            frmOptions.chkToutDessinerDansBitmapScrDabord,
            'ToutDessinerDansBitmapScrDabord');


    NouvelleSection('Affichage');
    INIBool(option_TracerFondVoix,
            frmOptions.chkTracerFondVoix,
            'TracerFondVoix');
    INIBool(OPTION_AfficherCouleursNotes,
            frmOptions.chkAfficherCouleursNotes,
            'AfficherCouleursNotes');
    INIBool(OPTION_AfficherGriseeNoteDansVoixInactive,
            frmOptions.chkAfficherGriseeNoteDansVoixInactive,
            'AfficherGriseeNoteDansVoixInactive');
    INIBool(OPTION_AfficherPortees_Inactives_Grisees,
            frmOptions.chkAffichage_Portees_Inactives_Grisees,
            'Afficher_Portees_Inactives_Grisees');

    INIBool(AfficherBulleDaide,
            frmOptions.chkHelp,
            'CompleterAutomatiquementAvecPausesEnDebut');

    INIBool(OPTION_VoixInactive_ToujoursFondPlusClair,
            frmOptions.chkVoixInactive_ToujoursFondPlusClair,
            'VoixInactive_ToujoursFondPlusClair');

    NouvelleSection('Presentation');



    v := integer(option_Presentation_NumerotationDesMesures);
    ToolBar_GetIndiceBoutonEnfonce(frmOptions.tlbNumerotationMesures, v);

    INIInt(v, 'Numerotation_Des_Mesures');
    option_Presentation_NumerotationDesMesures := TPresentation_NumerotationDesMesures(v);

    ToolBar_SetBoutonEnfonce(frmOptions.tlbNumerotationMesures, v);






    v := integer(option_Presentation_Affichage_Noms_Portees);
    ToolBar_GetIndiceBoutonEnfonce(frmOptions.tlbAffichage_Nom_Portees, v);

    INIInt(v, 'Affichage_Noms_Portees');
    option_Presentation_Affichage_Noms_Portees := TPresentation_Affichage_Noms_Portees(v);

    ToolBar_SetBoutonEnfonce(frmOptions.tlbAffichage_Nom_Portees, v);




    
    v := integer(option_Presentation_Affichage_Barres_Mesures);
    ToolBar_GetIndiceBoutonEnfonce(frmOptions.tlbAffichage_Barres_Mesures, v);

    INIInt(v, 'Affichage_Barres_Mesures');
    option_Presentation_Affichage_Barres_Mesures := TPresentation_Affichage_Barres_Mesures(v);

    ToolBar_SetBoutonEnfonce(frmOptions.tlbAffichage_Barres_Mesures, v);










    INI_Voix_Couleurs;







    INIFile.Free;
End;

{interface pour le fichier INI}
Procedure INISave;
Begin
    INISaveOrLoad(false);
End;

Procedure INILoad;
Begin
    INISaveOrLoad(true);
End;



end.
