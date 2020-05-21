unit UModeles;

interface

uses MusicSystem_Composition,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_Types {pour TNote},
     MusicSystem_ElMusical,
     MusicHarmonie;



type


TModeleMode = (mmAccord, mmArpegeMontante, mmArpegeDescendante);


TModele = record
    posref: integer;
    mode: TModeleMode;
    Voix: TVoix;
    Nom: string;

end;


TRythme = TVoix;


const indModeleIntervalle = 2;

var
      Modeles: array of TModele;
      Rythmes: array of TRythme;

      RythmeEnCours: TRythme;

      ModeleSousCurseur: integer;


procedure ChargerRythmes;
procedure CalcRythmes;
procedure CalcModeles;
Procedure AjouterModele(var indm: integer);
procedure ChargerModeles(numpage: integer);
procedure PreparerVoix(v: TVoix);
Procedure SwitchModeleMode(var Modele: TModele; mode:TModeleMode);
procedure ModelesVerifier;

Function ModeleCourant_Description_Get(hn: THauteurNote): string;

implementation

uses QSystem, FileSystem, MusicUser, MusicGraph, MusicGraph_System {pour C...},
     MusicGraph_Portees {pour GetY(...)},
     Main,
     DureeCourante_Gestion,
     SysUtils,
     MusicWriter_Erreur;



Function ModeleCourant_Description_Get(hn: THauteurNote): string;
Begin
     result := Modeles[ModeleSousCurseur].Nom;

     if ModeleSousCurseur <> 1 then
          result := result + ' (' + HauteurNoteToStr(hn) + ')';
End;




procedure PreparerVoix(v: TVoix);
{s'occupe de rentre joli la voix v}
var Mes: TMesure;
Begin
    IGP := nil;
    SetViewNil;
    Mes := TMesure.Create;
    setlength(Mes.Voix, 1);
    Mes.Voix[0] := v;
    Mes.affTonalitesDebut := false;
    Mes.affChgtTonalitesFin := false;

    Mes.affRythmeDebut := false;
    Mes.CreerGraphOrdreInfo;
    Mes.CalcGraphSub(0, 0, true);
    Mes.CalcQueue;


End;

procedure PasserEnEtalon(v: TVoix);
var i:integer;
Begin

  for i := 0 to high(v.elmusicaux) do
         v.elmusicaux[i].DureeEtalon := v.elmusicaux[i].Duree_Get;


End;


procedure ChargerRythmes;
var Comp: TComposition;
    i: integer;
Begin
    EnLecture := true;
    Comp := TComposition.Create;
    OuvrirFichier(DossierRacine + 'interface_rythmes\rythmes.mus');
    MusicUser_Pourcentage_Init('Chargement des rythmes');
    Comp.Save;
    MusicUser_Pourcentage_Free;
    FermerFichier;

    setlength(Rythmes, Comp.NbMesures);

    for i := 0 to Comp.NbMesures - 1 do
    Begin
          Rythmes[i] := Comp.GetMesure(i).VoixNum(0);
          PasserEnEtalon(Rythmes[i]);
    End;


End;





procedure CalcRythmes;
var r, i:integer;
Begin
for r := 0 to high(Rythmes) do
    for i := 0 to high(Rythmes[r].elmusicaux) do
            with Rythmes[r].elmusicaux[i] do
                  Duree_Fixee_Set(QMul(DureeEtalon, DureeCourante_Get));

End;


procedure CalcModeles;
{met à jour la durée des notes dans les modèles à partir de RythmeEnCours}

   var m, i, j: integer;
Begin
    IGP := nil;
    ModelesVerifier;
    MusicGraph_Canvas_Set(MainForm.lstModeles.Canvas);
    for m := 0 to high(Modeles) do
    Begin
            for i := 0 to high(Modeles[m].Voix.ElMusicaux) do
            Begin
                   j := i mod length(RythmeEnCours.Elmusicaux);
                   Modeles[m].Voix.ElMusicaux[i].Duree_Fixee_Set(RythmeEnCours.Elmusicaux[j].Duree_Get);

            End;
            PreparerVoix(Modeles[m].Voix);
    End;
    MainForm.lstModeles.Repaint;
End;



Procedure AjouterModele(var indm: integer);
{ajoute un modèle à la liste de modèles. Et renvoit l'indice de  ce dernier.
 L'objet Voix associé est déjà créé}
Begin
    indm := length(Modeles);
    Setlength(Modeles, indm+1);
    Modeles[indm].Voix := TVoix.Create;
    Modeles[indm].Voix.N_Voix := N_VOIX_INDEFINI;
    MainForm.lstModeles.AddItem('', nil);
End;



procedure ModelesVerifier;
var m: integer;
Begin
     for m := 0 to high(Modeles) do
        Modeles[m].Voix.VerifierIntegrite('modele n°' + inttostr(m) + ' pas bon');

      if not Modeles[1].Voix.ElMusicaux[0].IsSilence then
               MessageErreur('modele 1 : c''est pas un silence!');
End;


procedure ChargerModeles(numpage: integer);
var n: TNote;
    el: TElMusical;
    m, i: integer;



    procedure AjouterModeleUneNote;
    Begin
         AjouterModele(m);
         //une note
         Modeles[m].Nom := 'une note';
         Modeles[m].Voix.AddElMusicalFin(CreerElMusical1Note(Qel(1), CreerNote(0-6,0,aNormal)));
         inc(m);
    End;


    procedure AjouterModelePause;
    Begin
         AjouterModele(m);
         //un silence
         Modeles[m].Nom := 'un silence';
         Modeles[m].Voix.AddElMusicalFin(CreerElMusicalPause(Qel(1), 0));
         inc(m);
    End;

    
Begin
for m := 0 to high(Modeles) do
     Modeles[m].Voix.Free;

ModeleSousCurseur := 0;

Setlength(Modeles, 0);
MainForm.lstModeles.Clear;


m := 0;

case numpage of
       0:
       Begin
                AjouterModeleUneNote;
                AjouterModelePause;
                ModelesVerifier;
             {  //accord majeur
                AjouterModele(m);
                el := CreerElMusical1Note(Qel(1), CreerNote(0-6,0,aNormal));
                el.AddNote(CreerNote(2-6,0,aNormal));
                el.AddNote(CreerNote(4-6,0,aNormal));
                Modeles[m].Voix.AddElMusicalFin(el);
                Modeles[m].Nom := 'un accord majeur';
                Modeles[m].Voix.VerifierIntegrite('accord majeur');
                inc(m);

                //accord mineur
                AjouterModele(m);
                el := CreerElMusical1Note(Qel(1), CreerNote(0-6,0,aNormal));
                el.AddNote(CreerNote(2-6,0,aBemol));
                el.AddNote(CreerNote(4-6,0,aNormal));
                Modeles[m].Voix.AddElMusicalFin(el);
                Modeles[m].Nom := 'un accord mineur';
                Modeles[m].Voix.VerifierIntegrite('accord mineur');


                //accord de 7-me diminué
                AjouterModele(m);
                el := CreerElMusical1Note(Qel(1), CreerNote(-1-6,0,aNormal));
                el.AddNote(CreerNote(1-6,0,aNormal));
                el.AddNote(CreerNote(3-6,0,aNormal));
                el.AddNote(CreerNote(4-6,0,aNormal));
                Modeles[m].Voix.AddElMusicalFin(el);
                Modeles[m].Nom := 'un accord 7e diminué';
                Modeles[m].Voix.VerifierIntegrite('accord 7e diminué');

               //accord de 7-me diminué
                AjouterModele(m);
                el := CreerElMusical1Note(Qel(1), CreerNote(-1-6,0,aNormal));
                el.AddNote(CreerNote(1-6,0,aNormal));
                el.AddNote(CreerNote(3-6,0,aNormal));
                el.AddNote(CreerNote(5-6,0,aBemol));
                Modeles[m].Voix.AddElMusicalFin(el);
                Modeles[m].Nom := 'un accord 7e diminué';
                Modeles[m].Voix.VerifierIntegrite('accord 7me diminué');   }


       End;
       1:
       Begin
              AjouterModeleUneNote;
                AjouterModelePause;


              //gamme majeure
              AjouterModele(m);
              for i := 0 to 7 do
                  Modeles[m].Voix.AddElMusicalFin(CreerElMusical1Note(Qel(1), CreerNote(i,0,aNormal)));

              Modeles[m].Nom := 'une gamme majeure';
              Modeles[m].Voix.VerifierIntegrite('gamme majeure');


              //gamme mineure
              AjouterModele(m);
              for i := 0 to 6 do
              Begin
                  if (i = 2) or (i = 5) then
                        n.hauteurnote.alteration := aBemol
                  else
                        n.hauteurnote.alteration := aNormal;
                  n.position.portee := 0;
                  n.HauteurNote.Hauteur := i;
                  n.position.hauteur := -6 + i;
                  n.AfficherAlteration := (n.hauteurnote.alteration <> aNormal);
                  Modeles[m].Voix.AddElMusicalFin(CreerElMusical1Note(Qel(1), n));
              End;
              Modeles[m].Nom := 'une gamme mineure';
              Modeles[m].Voix.VerifierIntegrite('gamme mineure');


              {note répété}
              AjouterModele(m);
              for i := 0 to 3 do
              Begin
                  n := CreerNote(0,0,aNormal);
                  Modeles[m].Voix.AddElMusicalFin(CreerElMusical1Note(Qel(1), n));
              End;
              Modeles[m].Nom := 'notes répétées';
              Modeles[m].Voix.VerifierIntegrite('notes répétées');


       End;

       2:
       Begin
                AjouterModeleUneNote;
            
                for i := 1 to 7 do
                Begin
                    {octave}
                    AjouterModele(m);
                    el := CreerElMusical1Note(Qel(1), CreerNote(0,0,aNormal));
                    el.AddNote(CreerNote(i,0,aNormal));
                    Modeles[m].Voix.AddElMusicalFin(el);
                    Modeles[m].Nom := 'tierce';
                    Modeles[m].Voix.VerifierIntegrite('modèle octave');
                    inc(m);
                End;

       End;


end;


ModelesVerifier;
for m := 0 to high(Modeles) do
      PreparerVoix(Modeles[m].Voix);
ModelesVerifier;

End;

Procedure SwitchModeleModeAccord(var Modele: TModele);
var i: integer;
Begin
With Modele do
Begin
    for i := 0 to high(Voix.ElMusicaux) do
        Voix.ElMusicaux[0].AddNote(Voix.ElMusicaux[i].Notes[0]);
    repeat until not Voix.DelElMusical(1);

End;
End;


Procedure SwitchModeleMode(var Modele: TModele; mode:TModeleMode);
var i: integer;
Begin
SwitchModeleModeAccord(Modele);

if mode <> mmAccord then
Begin
         With Modele.Voix do
         Begin
               if mode = mmArpegeMontante then
                     for i := 0 to high(ElMusicaux[0].Notes) do
                           Modele.Voix.AddElMusicalFin(
                           CreerElMusical1Note(ElMusicaux[0].Duree_Get,
                                               ElMusicaux[0].Notes[i]));

               if mode = mmArpegeDescendante then
                     for i := high(ElMusicaux[0].Notes) downto 0 do
                           Modele.Voix.AddElMusicalFin(
                           CreerElMusical1Note(ElMusicaux[0].Duree_Get,
                                               ElMusicaux[0].Notes[i]));

               DelElMusical(0);
         End;



End;

PreparerVoix(Modele.Voix);

End;






end.
