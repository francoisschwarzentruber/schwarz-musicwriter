unit Magnetophone;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, MPlayer, ExtCtrls, StdCtrls, ChildWin,
  frame_Composition_Instruments {pour TMDIChild}, QSystem, Magnetophone_Curseur_init;

type
  TfrmMagnetophone = class(TFrame)
    tmrMagnetophone: TTimer;
    lblNom: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblPosition: TLabel;
    lblMesureCourante: TLabel;
    lblTemps: TLabel;
    lblDureeTotale: TLabel;
    lblNombreDeMesures: TLabel;
    frameComposition_Instruments: TframeComposition_Instruments;
    procedure tmrMagnetophoneTimer(Sender: TObject);
    procedure tbnLectureClick(Sender: TObject);
    procedure tbnPauseClick(Sender: TObject);
    procedure tbnStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure frameComposition_InstrumentslistClick(Sender: TObject);
    procedure frameComposition_InstrumentslistMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;



  
Function Magnetophone_IsConnected: Boolean;
Function Magnetophone_IsConnectedAndPlaying: Boolean;

procedure Magnetophone_Lecture;
procedure Magnetophone_Pause;
procedure Magnetophone_Stop_SansChangerMode;
procedure Magnetophone_Stop;
procedure Magnetophone_EteindreTout;
procedure Magnetophone_JouerOrgueDeBarbarieEtReset(Magnetophone_Curseur_Ancien, Magnetophone_Curseur: TMagnetophone_Curseur);
procedure Magnetophone_JouerOrgueDeBarbarie(Magnetophone_Curseur_Ancien, Magnetophone_Curseur: TMagnetophone_Curseur);
procedure Magnetophone_AllerAuDebut;
procedure Magnetophone_AllerALaFin;

Procedure Magnetophone_Prevenir_la_fermeture_d_une_fenetre(fenetre: TMDIChild);
Procedure Magnetophone_Prevenir_l_ouverture_d_une_fenetre;

Function Magnetophone_actPlayChild_Get: TMDIChild;

Function Magnetophone_iMesure_Get: integer;
Function Magnetophone_TempsInMesure_Get: TRationnel;

Procedure Magnetophone_Curseur_Deplacer(m: integer; temps: TRationnel);

Function Magnetophone_VitesseEnPourcentage_Get(trkVitesse_Position: integer): integer;






implementation


uses MidiNow {pour MidiNow_CloseMidiDevice},
     Main {CompilerFichierMIDI},
     piano_doigteur {Piano_Doigteur_Doigter},
     Piano_Gestion {pour Piano_Gestion_Init},
     MusicWriter_Erreur, Doigtes,
     MusicSystem_Voix {pour TVoix},
     MusicUser,
     Magnetophone_System,
          MusicUser_PlusieursDocuments;



var Magnetophone_Curseur_Ancien_Barbarie: TMagnetophone_Curseur;




Function Magnetophone_iMesure_Get: integer;
Begin
    result := Magnetophone_actPlayChild_Get.Magnetophone_Curseur.imesure;
End;


Function Magnetophone_TempsInMesure_Get: TRationnel;
Begin
    result := Magnetophone_actPlayChild_Get.Magnetophone_Curseur.temps;
End;

Function Magnetophone_actPlayChild_Get: TMDIChild;
Begin
    {if actPlayChild = nil then
         MessageErreur('NON, on accède pas à actPlayChild si on lit rien !'); }

    result := actchild;
    //result := actPlayChild;
End;

Function Magnetophone_IsConnected: boolean;
Begin
      result := (Magnetophone_actPlayChild_Get <> nil);
End;


Function Magnetophone_IsConnectedAndPlaying: Boolean;
Begin
    result := Magnetophone_IsConnected and (MainForm.actionMagnetophoneLecture.Enabled = false);
End;



Procedure Magnetophone_Prevenir_l_ouverture_d_une_fenetre;
Begin
{si une fenêtre s'ouvre, et que tous les boutons du magnétophone étaient désactivés
 alors on active le bouton de lecture pour permettre de lire !!}

    if (not MainForm.actionMagnetophoneLecture.Enabled) and
       (not MainForm.tbnMagnetophone_Pause.Enabled) and
       (not MainForm.tbnMagnetophone_Stop.Enabled )
       then
    Begin
         MainForm.actionMagnetophoneLecture.Enabled := true;
    End;

End;



procedure Magnetophone_Reset;
Begin

End;


Procedure Magnetophone_Curseur_Deplacer(m: integer; temps: TRationnel);
Begin
    Magnetophone_actPlayChild_Get.Magnetophone_Curseur := TMagnetophone_Curseur_Creer(Magnetophone_actPlayChild_Get.Composition, m, temps);
    Magnetophone_Reset;
    Magnetophone_actPlayChild_Get.Magnetophone_Curseur_Exciter_Un_Peu;
    Magnetophone_actPlayChild_Get.FaireVoirMesureEtTemps(m, temps);
    Magnetophone_actPlayChild_Get.FormPaint(nil);
End;


procedure Magnetophone_BasculerModeMagnetophone;
Begin
     MusicUser_MusicWriter_Mode_Set(mw_mode_Ecouter);
End;


procedure Magnetophone_DebasculerModeMagnetophoneSiYaveAutreModeAvant;
Begin
    MusicUser_MusicWriter_Mode_RevenirAuPrecedent;
End;



procedure Magnetophone_AllerauDebut;
Begin
     Magnetophone_Curseur_Deplacer(0, Qel(0));
End;


procedure Magnetophone_AlleralaFin;
Begin
     With Magnetophone_actPlayChild_Get.Composition do
        Magnetophone_Curseur_Deplacer(NbMesures-1, GetMesure(NbMesures - 1).DureeTotale);


End;

procedure Magnetophone_Lecture;

    procedure Magnetophone_Lecture_Gerer_Boutons;
    Begin
          With MainForm do
          Begin
              actionMagnetophoneLecture.Enabled := false;
              tbnMagnetophone_Pause.Enabled := true;
              tbnMagnetophone_Stop.Enabled := true;

          End;



    End;

Begin


            MidiNow_CloseMidiDevice;



            Magnetophone_Lecture_Gerer_Boutons;

            //actPlayChild := actChild;

            Piano_Doigteur_Doigter(Magnetophone_actPlayChild_Get.Composition);

            Magnetophone_actPlayChild_Get.Magnetophone_Curseur_Exciter_Bcp;


            Piano_Gestion_Init(nil, 0, Qel(0));

            if MusicUser_MusicWriter_Mode_Get <> mw_mode_Ecouter then
            Begin
                    With Magnetophone_actPlayChild_Get do
                         Magnetophone_Curseur := TMagnetophone_Curseur_Creer(Composition,
                                                                             Curseur_Souris.GetiMesure,
                                                                             Curseur_Souris.GetTempsDepuisDebutMesure);
            End
            else
            Begin
                  With Magnetophone_actPlayChild_Get do
                  If Magnetophone_Curseur_IsFini(Magnetophone_Curseur) then
                       Magnetophone_Curseur := TMagnetophone_Curseur_Creer(Magnetophone_actPlayChild_Get.Composition, 0, Qel(0));
            End;
            
            MainForm.frmMagnetophone.tmrMagnetophone.Enabled := true;

            Magnetophone_actPlayChild_Get.ReaffichageComplet;
            Magnetophone_BasculerModeMagnetophone;
            Magnetophone_Gestion_Reset;
End;


procedure Magnetophone_Pause;
Begin
   With MainForm do
   Begin
       tbnMagnetophone_Pause.Enabled := false;
       actionMagnetophoneLecture.Enabled := true;
       tbnMagnetophone_Stop.Enabled := true;
       frmMagnetophone.tmrMagnetophone.Enabled := false;
   End;


End;




procedure Magnetophone_Stop_SansChangerMode;
Begin
     MainForm.frmMagnetophone.tmrMagnetophone.Enabled := false;
     MidiNow_Stop;
     //Hide;
     Magnetophone_Gestion_Reset;

      With MainForm do
      Begin
          tbnMagnetophone_Pause.Enabled := false;
          tbnMagnetophone_Stop.Enabled := false;
          actionMagnetophoneLecture.Enabled := true;
      End;

End;



procedure Magnetophone_Stop;
begin
      Magnetophone_Stop_SansChangerMode;
      Magnetophone_DebasculerModeMagnetophoneSiYaveAutreModeAvant;

end;


procedure Magnetophone_EteindreTout;
Begin
    Magnetophone_Gestion_EteindreTout;
End;



Procedure Magnetophone_Prevenir_la_fermeture_d_une_fenetre(fenetre: TMDIChild);
Begin
      if Magnetophone_actPlayChild_Get = fenetre then
      Begin
            Magnetophone_Stop;
            //actPlaychild := nil;
      end;

      if MainForm.MDIChildCount <= 1 then
      Begin
          With MainForm do
           Begin             
               tbnMagnetophone_Pause.Enabled := false;
               actionMagnetophoneLecture.enabled := false;
               tbnMagnetophone_Stop.Enabled := false;
               frmMagnetophone.tmrMagnetophone.Enabled := false;
           End;


      End;
End;


{$R *.dfm}









procedure Magnetophone_JouerOrgueDeBarbarieEtReset(Magnetophone_Curseur_Ancien, Magnetophone_Curseur: TMagnetophone_Curseur);
Begin
     Magnetophone_Curseur_Ancien.temps := Qel(0, 1);
     Magnetophone_EteindreTout;
     Magnetophone_Curseur_Ancien_Barbarie.imesure := -1; //pour être sûr que ça va jouer qch !
     Magnetophone_JouerOrgueDeBarbarie(Magnetophone_Curseur_Ancien, Magnetophone_Curseur);
End;

procedure Magnetophone_JouerOrgueDeBarbarie(Magnetophone_Curseur_Ancien, Magnetophone_Curseur: TMagnetophone_Curseur);
var tampon: TMagnetophone_Curseur;
Begin
      if IsMagnetophoneCurseurmc1StrInfmc2(Magnetophone_Curseur, Magnetophone_Curseur_Ancien) then
       Begin
            tampon  := Magnetophone_Curseur;
            Magnetophone_Curseur := Magnetophone_Curseur_Ancien;
            Magnetophone_Curseur_Ancien := tampon;
       End;


{            Magnetophone_Curseur_Ancien :=  RealToQ(Magnetophone_Curseur_Ancien);
            inc(Magnetophone_Curseur_Ancien.num);}

            Magnetophone_Curseur.temps :=  RealToQ(QToreal(Magnetophone_Curseur.temps), 1028);
            inc(Magnetophone_Curseur.temps.num);

            if not IsMagnetophoneCurseurmc1Egalmc2(Magnetophone_Curseur, Magnetophone_Curseur_Ancien_Barbarie) then
            Begin
                  Magnetophone_Gestion_JouerOrgueDeBarbarie(Magnetophone_Curseur_Ancien, Magnetophone_Curseur);
                  Magnetophone_Gestion_JouerOrgueDeBarbarie(Magnetophone_Curseur, Magnetophone_Curseur);
            End;

      Magnetophone_Curseur_Ancien_Barbarie := Magnetophone_Curseur;
End;



procedure Magnetophone_Gestion_Jouer_Un_Peu(idtemps: integer);
var new_curseur : TMagnetophone_Curseur;
Begin
    new_curseur := TMagnetophone_Curseur_Avancer(Magnetophone_actPlayChild_Get.Magnetophone_Curseur, idtemps);
    Magnetophone_Gestion_Jouer(Magnetophone_actPlayChild_Get.Magnetophone_Curseur, new_curseur);
    Magnetophone_actPlayChild_Get.Magnetophone_Curseur := new_curseur;
End;





procedure TfrmMagnetophone.tmrMagnetophoneTimer(Sender: TObject);
const Delay_Pour_Faire_Genre_Cest_Rapide = 150;

var V: TVoix;
    i:integer;

begin
      if not MusicWriter_IsFenetreDocumentCourante then
      Begin
           tmrMagnetophone.Enabled := false;
           Exit;
      End;

      inc(tmrMediaPlayerCompteur);

      {actPlayChild.Composition.LectureMIDI_GetMesuresEtTemps(actPlayChild.LectureMIDI_ListeDeLecture,
                                              MainForm.frmMagnetophone.trkMediaPlayerTrack.Position + Delay_Pour_Faire_Genre_Cest_Rapide,
                                              actPlayChild.LectureMIDI_MesurePlayed,
                                              actPlayChild.LectureMIDI_TempsPlayed);  }



      V := Magnetophone_actPlayChild_Get.Composition.GetMesure(Magnetophone_iMesure_Get).VoixNum(Magnetophone_actPlayChild_Get.Curseur.GetiVoixSelectionnee);

      i := V.IndiceSurTemps(QAdd(Qel(1), Magnetophone_TempsInMesure_Get))-1;


      if (i >= 0) and (i <= high(V.ElMusicaux)) then
      with V.ElMusicaux[i] do
             if not IsSilence then
                         frmDoigtes.Traiter(GetNote(0).hauteurnote);

      if tmrMediaPlayerCompteur mod 5 = 0 then
      Begin
          Magnetophone_actPlayChild_Get.FaireVoirMesureEtTemps(Magnetophone_iMesure_Get, Magnetophone_TempsInMesure_Get);
          Magnetophone_actPlayChild_Get.FormPaint(nil);
      End;

      Magnetophone_Gestion_Jouer_Un_Peu(1);


      Piano_Gestion_Jouer(Magnetophone_actPlayChild_Get.Composition, Magnetophone_iMesure_Get,
                                                    Magnetophone_TempsInMesure_Get);

      if Magnetophone_actPlayChild_Get.Magnetophone_Curseur.fini then
           Magnetophone_Stop;

end;







procedure TfrmMagnetophone.tbnLectureClick(Sender: TObject);
begin
      Magnetophone_Lecture;
end;

procedure TfrmMagnetophone.tbnPauseClick(Sender: TObject);
begin
    Magnetophone_Pause;
end;

procedure TfrmMagnetophone.tbnStopClick(Sender: TObject);
begin
    Magnetophone_Stop;
end;

procedure TfrmMagnetophone.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if Magnetophone_IsConnected then
       Magnetophone_Stop;
end;



procedure TfrmMagnetophone.FormActivate(Sender: TObject);
begin
       frameComposition_Instruments.MettreAJour;
end;

procedure TfrmMagnetophone.frameComposition_InstrumentslistClick(
  Sender: TObject);
begin
  frameComposition_Instruments.listClick(Sender);
  
end;

procedure TfrmMagnetophone.frameComposition_InstrumentslistMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  frameComposition_Instruments.listMouseUp(Sender, Button, Shift, X,
  Y);

end;

Function Magnetophone_VitesseEnPourcentage_Get(trkVitesse_Position: integer): integer;
    Function ComposantTickToZoom(tick: integer): integer;
    const tick_de_zoom100 = 50;
    const zoom_min = 20;
    Begin
         result := Round(zoom_min*exp( 1/tick_de_zoom100 * ln(100 / zoom_min) * tick));
    End;
Begin
     result := ComposantTickToZoom(trkVitesse_Position);
End;

end.
