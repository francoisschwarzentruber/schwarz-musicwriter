unit Enregistrer_Source;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, StdCtrls, ImgList, Qsystem,
  MusicSystem_Types {pour TNote};





  
type

  Tenregistreur_peripherique_entree = (epeAucun, epePeripheriqueEntreeMIDI, epeClavierOrdinateur);

  TfrmEnregistreur = class(TForm)
    tmrEnregistreurMetronome: TTimer;
    Memo: TMemo;
    tmrJecoute_Animation: TTimer;
    ImageListSource: TImageList;
    GroupBox1: TGroupBox;
    PaintBoxMetronome: TPaintBox;
    lblMSParTemps: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    trkTempo: TTrackBar;
    cmdTester: TButton;
    procedure tbnStopClick(Sender: TObject);
    procedure tbnEnregistrerMicrophoneClick(Sender: TObject);
    procedure tmrEnregistreurMetronomeTimer(Sender: TObject);
    procedure trkTempoChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmdTesterClick(Sender: TObject);
    procedure tmrJecoute_AnimationTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmEnregistreur: TfrmEnregistreur;



Procedure Enregistreur_Enregistrer;
Procedure Enregistreur_Stop;

Function Enregistreur_IsEnTrainDEnregistrer: Boolean;

Function Enregistreur_Note_Construire(nb_demiton: integer; itemps: TRationnel): TNote;

Procedure frmEnregistreur_Show;
procedure frmEnregistreur_Hide;


implementation


uses Main,
     Midi_In {pour la gestion midi},
     MusicWriter_MidiIn,
     MusicHarmonie {THauteurNote},
     MusicSystem_ElMusical,
     MusicGraph_System,
     Childwin {TNote},
     MMSystem,
     Message_Vite_Fait,
     MusicUser_Keys,

     piano,
          MusicUser_PlusieursDocuments;


     

const magnetophone_prec = 2096;


var tableau_notes: array[0..1000] of integer;
    itemps_reference: Int64 = 0;
    UnTempsToiTemps: integer = 500;
    {plus UnTempsToiTemps est petit, plus l'écoute d'une portion enregistrée est lente}

var Enregistreur_Mesure : integer = 0;
    num_temps: integer = 0;
    enregistreur_peripherique_entree: Tenregistreur_peripherique_entree;

var itemps_debut: integer = -1000;


function KeyToNbDemiTonPourEnregistreur(key: integer; var n: integer): boolean;
Begin
      result := KeyToNombreDemiTonPourHauteurNote(key, n);
      n := n + 60;
End;


Procedure frmEnregistreur_Show;
Begin
    if frmEnregistreur = nil then
         frmEnregistreur := TfrmEnregistreur.Create(nil);

    //frmEnregistreur.Show;
End;


procedure frmEnregistreur_Hide;
Begin
   if frmEnregistreur <> nil then
      frmEnregistreur.Hide;

   if frmPiano <> nil then
      frmPiano.Hide;
End;






Function itemps_to_rationnel( itemps: integer): TRationnel;
Begin
     result := Qel( Round( (magnetophone_prec * itemps) / UnTempsToiTemps),
                    magnetophone_prec);

End;




procedure Enregistreur_Message_Note_Enfoncee(n, itemps: integer);
const temps_pour_debut_tolerance = 100;
Begin
      Piano_Touche_Enfoncer(n - 60, clRed, MainDroite, 3);

      if abs(itemps_debut - itemps) < temps_pour_debut_tolerance then
           itemps := itemps_debut
      else
      Begin
           itemps_debut := itemps;
      End;


      tableau_notes[n] := itemps;



      actchild.Enregistreur_Note_Enfoncer(Enregistreur_Mesure,
                                          itemps_to_rationnel(tableau_notes[n]),
                                          MIDINoteToNbDemiTon(n)
                                          );

      actchild.FormPaint(nil);

End;






Function Enregistreur_Note_Construire(nb_demiton: integer; itemps: TRationnel): TNote;
var pos: TPosition;
    hn: THauteurnote;
Begin
     hn := NbDemiTonToHauteurNote(nb_demiton, actchild.Curseur.GetTonaliteCourante);

     if hn.Hauteur < 0 then
            pos.portee := 1
     else
            pos.portee := 0;
           

     pos.hauteur := HauteurAbsToHauteurGraphique(
            actchild.Composition.InfoClef_Detecter(pos.portee,
                                   Enregistreur_Mesure,
                                   itemps),

                                   hn.Hauteur);

     result := CreerNote(pos.Hauteur, pos.portee, hn.alteration);
     result.HauteurNote := hn;

End;









procedure Enregistreur_Message_Note_Relachee(n, itemps: integer);
{procédure super importante : c'est là où on enregistre une note !}

const facteur_reduction_duree_notes_pour_eviter_supperposition = 100/100;

var t1, t2: TRationnel;
    el: TElMusical;

    note: TNote;

    nb_demiton: integer;

Begin
     Piano_Touche_Relever(n - 60);
     nb_demiton := MIDINoteToNbDemiTon(n);
     actchild.Enregistreur_Note_Relacher(nb_demiton);
     t1 := itemps_to_rationnel(tableau_notes[n]);

     itemps := tableau_notes[n] + Round( (itemps - tableau_notes[n]) * facteur_reduction_duree_notes_pour_eviter_supperposition);
     t2 := itemps_to_rationnel(itemps);




     With actchild do
     Begin
         note := Enregistreur_Note_Construire(nb_demiton, t1);

         frmEnregistreur.memo.Lines.Add('insertion : t1 = (' + inttostr(tableau_notes[n]) + ', ' + QToStr(t1) + ')' +
                                        '; t2 = (' + inttostr(itemps) + ', ' + QToStr(t2) + ')' +
                                        ', durée = ' + QToStr( QDiff(t2, t1) ));

         el := CreerElMusical1Note_DureeApproximative(QDiff(t2, t1),
                                   note );

         if Composition.Is_Mesure_Indice_MesureAAjouter(Enregistreur_Mesure) then
                Composition.AddMesureFin;
                                          
         Composition.GetMesure(Enregistreur_Mesure).InsererElMusicalAuTemps_AlaFin(t1, el);
         el.Free;
         Composition.PaginerApartirMes(Enregistreur_Mesure, true);
         ReaffichageComplet;
     End;


End;




























Function Enregistreur_Temps_Get: Int64;
Begin
     result := GetTickCount - itemps_reference;
End;

procedure Enregistreur_MessageReceiver(msg, n, vel, temps: integer);
    
Begin
    if msg = 248 then
        exit;
    if msg = 153 then
        exit;
    if not MusicWriter_IsFenetreDocumentCourante then
         exit;

    temps := Enregistreur_Temps_Get;

    if (vel > 0) and (msg = 144) then
         Enregistreur_Message_Note_Enfoncee(n, temps)
    else if (vel = 0) and (msg = 144) then
         Enregistreur_Message_Note_Relachee(n, temps);


End;



Function Enregistreur_IsEnTrainDEnregistrer: Boolean;
Begin
     result := (MainForm.tbnEnregistreurEnregistrer.Enabled = false);
End;


Procedure Enregistreur_Enregistrer;
Begin

    frmEnregistreur.Memo.Clear;

     if MainForm.cboPeripheriqueEntree.ItemIndex = 0 then
           enregistreur_peripherique_entree := epePeripheriqueEntreeMIDI
     else if MainForm.cboPeripheriqueEntree.ItemIndex = 1 then
           enregistreur_peripherique_entree := epeClavierOrdinateur;

    case enregistreur_peripherique_entree of
          epePeripheriqueEntreeMIDI:
          Begin
                if not Midi_In_Init_Basique(0) then
                Begin
                     Message_Vite_Fait_Beep_Et_Afficher('Impossible de démarrer le périphérique d''entrée MIDI. Vérifiez les branchements etc.');
                     exit;
                End;

                Midi_in_Set_MessageReceiver(Enregistreur_MessageReceiver);
          End;
    end;

//    frmEnregistreur.tmrEnregistreurMetronome.Enabled := true;

    With MainForm do
    Begin
        panJecoute.Visible := true;
        frmEnregistreur.tmrJecoute_Animation.Enabled := true;
        tbnEnregistreurEnregistrer.Enabled := false;
        tbnEnregistreurStop.Enabled := true;
        cboPeripheriqueEntree.Enabled := false;
    End;
    itemps_reference := GetTickCount;

    Enregistreur_Mesure := actchild.Magnetophone_Curseur.imesure;
    actchild.Enregistreur_NotesEnfonces_Reset;
End;


Procedure Enregistreur_Stop;
Begin

    if enregistreur_peripherique_entree = epePeripheriqueEntreeMIDI then
         if not Midi_In_Init_Basique(0) then
             Message_Vite_Fait_Beep_Et_Afficher('Impossible de démarrer le périphérique d''entrée MIDI. Vérifiez les branchements etc.');

    frmEnregistreur.tmrEnregistreurMetronome.Enabled := false;

    enregistreur_peripherique_entree := epeAucun;

    With MainForm do
    Begin
        panJecoute.Visible := false;
        frmEnregistreur.tmrJecoute_Animation.Enabled := false;
        tbnEnregistreurEnregistrer.Enabled := true;
        tbnEnregistreurStop.Enabled := false;
        cboPeripheriqueEntree.Enabled := true;
    End;

    actchild.Enregistreur_NotesEnfonces_Reset;
End;








{$R *.dfm}

procedure TfrmEnregistreur.tbnStopClick(Sender: TObject);
begin
     Enregistreur_Stop;
end;

procedure TfrmEnregistreur.tbnEnregistrerMicrophoneClick(
  Sender: TObject);
begin


     Enregistreur_Enregistrer;

end;


var rapport_last: real = 0;



procedure TfrmEnregistreur.tmrEnregistreurMetronomeTimer(Sender: TObject);
const delai_a_enlever_pour_faire_genre_cest_rapide = 100;
var x: integer;
    rapport: real;
begin
       rapport := ((GetTickCount - itemps_reference + delai_a_enlever_pour_faire_genre_cest_rapide) mod UnTempsToiTemps)
                                                        / UnTempsToiTemps;

       x := Round(PaintBoxMetronome.Width*rapport);

       if abs(rapport - rapport_last) > 0.5 then
           sndPlaySound('interface_sons\metronome_tic.wav',0);

       rapport_last := rapport;

       PaintBoxMetronome.Canvas.Brush.Color := $FF;

       PaintBoxMetronome.Canvas.Rectangle(Rect(0, 0,
                                               x, PaintBoxMetronome.Height));

       PaintBoxMetronome.Canvas.Brush.Color := $FF8888;
       PaintBoxMetronome.Canvas.Rectangle(Rect(x, 0,
                                               PaintBoxMetronome.Width,
                                               PaintBoxMetronome.Height));
end;




procedure TfrmEnregistreur.trkTempoChange(Sender: TObject);
begin
      UnTempsToiTemps := trkTempo.Position;
      lblMSParTemps.Caption := 'Une noire dure ' +
                                  inttostr(UnTempsToiTemps) + ' ms';

end;

procedure TfrmEnregistreur.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var n: integer;

begin
       if enregistreur_peripherique_entree = epeClavierOrdinateur then
           if KeyToNbDemiTonPourEnregistreur(key, n) then
                 Enregistreur_Message_Note_Enfoncee(n, Enregistreur_Temps_Get);
end;

procedure TfrmEnregistreur.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var n: integer;

begin
     if enregistreur_peripherique_entree = epeClavierOrdinateur then
         if KeyToNbDemiTonPourEnregistreur(key, n) then
              Enregistreur_Message_Note_Relachee(n, Enregistreur_Temps_Get);
end;

procedure TfrmEnregistreur.cmdTesterClick(Sender: TObject);
begin
     tmrEnregistreurMetronome.Enabled := not tmrEnregistreurMetronome.Enabled;

     case tmrEnregistreurMetronome.Enabled of
       true: cmdTester.Caption := 'Arrêter le test';
       false: cmdTester.Caption := 'Tester le métronome';
     end;
     
end;

procedure TfrmEnregistreur.tmrJecoute_AnimationTimer(Sender: TObject);
var v: Boolean;
begin
      v := Mainform.imgEnregistreur1.visible;

      Mainform.imgEnregistreur1.visible := not v;
      Mainform.imgEnregistreur2.visible := v;
end;

procedure TfrmEnregistreur.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Enregistreur_Stop;
end;

procedure TfrmEnregistreur.FormShow(Sender: TObject);
begin
    frmPiano_Show;
end;

end.


