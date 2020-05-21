unit Magnetophone_System;

interface

uses Magnetophone_Curseur_Init, Graphics;


procedure Magnetophone_Gestion_Jouer(Magnetophone_Curseur_Ancien,
                                     Magnetophone_Curseur_Apres: TMagnetophone_Curseur);

procedure Magnetophone_Gestion_JouerOrgueDeBarbarie(Magnetophone_Curseur_Ancien,
                                     Magnetophone_Curseur_Apres: TMagnetophone_Curseur);

                                     
procedure Magnetophone_Gestion_Reset;

procedure Magnetophone_Gestion_EteindreTout;

procedure Magnetophone_NotesEntenduees_Dessiner(Canvas: TCanvas; Magnetophone_Curseur: TMagnetophone_Curseur);



implementation

uses MusicGraph_Portees, MusicSystem_Mesure {pour IGP},
    MusicWriter_Erreur,
    MusicSystem_ElMusical,
    MusicWriterToMIDI,
    MidiNow,
    QSystem, MusicSystem_ElMusical_Liste_Notes, MusicWriter_Console,
    MusicGraph, MusicGraph_System;




type TBouchon = record
    el_a_eteindre: TElMusical;
    moment: TMagnetophone_Curseur;
end;


type TProcedureTraitementElMusical = procedure(el: TElMusical);


var Bouchons: array of TBouchon;


procedure Bouchon_Ajouter(a_el_a_eteindre: TElMusical; m: integer; temps: TRationnel);
var l: integer;
Begin
    l := length(Bouchons);

    Setlength(Bouchons, l+1);

    Bouchons[l].el_a_eteindre := a_el_a_eteindre;
    Bouchons[l].moment.imesure := m;
    Bouchons[l].moment.temps := temps;
End;



procedure Bouchon_Supprimer(i: integer);
var j: integer;
Begin
    for j := i to high(Bouchons)-1 do
         Bouchons[j] := Bouchons[j+1];

    Setlength(Bouchons, high(Bouchons));
End;


procedure Bouchons_Reset;
Begin
    Setlength(Bouchons, 0);
End;



procedure Magnetophone_Gestion_Reset;
Begin
    Bouchons_Reset;
End;


procedure Magnetophone_ElMusical_Eteindre_OrgueDeBarbarie(el: TElMusical);
Begin

End;



procedure Magnetophone_ElMusical_Allumer_OrgueDeBarbarie(el: TElMusical);
    Begin
        el.Ecouter;
    End;




procedure Magnetophone_Gestion_EteindreTout;
var p, hmidi: integer;
Begin
    Console_AjouterLigne('Magnetophone_Gestion_EteindreTout');
    Bouchons_Reset;
    for p := 0 to 15 do
    for hmidi := 0 to 128 do
    MidiNow_Hard_NoteOff(p,
                 hmidi, 127);
End;



procedure Magnetophone_ElMusical_Eteindre_Classique(el: TElMusical);
    var p: integer;
    n: integer;
    Begin
          p := el.PorteeApprox;
          if p > 15 then p := 15;
          With el do
            for n := 0 to high(Notes) do
            if not el.IsNoteLieeALaSuivante(n) then
                MidiNow_Hard_NoteOff(p,
                 HauteurNoteToMIDINote(Notes[n].HauteurNote), 127);
End;



procedure Magnetophone_ElMusical_Allumer_Classique(el: TElMusical);
    var n: integer;
    p: integer;
    is_allumer: Boolean;
    Begin
        p := el.PorteeApprox;
        if p > 15 then p := 15;
        MidiNow_Hard_ChangerInstrument(p, IGP.Portee_InstrumentMIDINum[p]);
        With el do
            for n := 0 to high(Notes) do
            Begin
                  is_allumer := true;
                  if el.elementmusical_precedent <> nil then
                       is_allumer := not el.elementmusical_precedent.HauteurNoteIsPresentEtLieeALaSuivante(el.Notes[n].HauteurNote)
                  else
                       is_allumer := true;

                if is_allumer then
                MidiNow_Hard_NoteOn(p,
                 HauteurNoteToMIDINote(Notes[n].HauteurNote), 127);
            End;
    End;




procedure Magnetophone_Gestion_Jouer_Sub(Magnetophone_Curseur_Ancien,
                                     Magnetophone_Curseur_Apres: TMagnetophone_Curseur;
                                     Eteindre, Allumer: TProcedureTraitementElMusical);

    
    procedure Bouchons_Traiter;
    var i : integer;
    Begin
          i := 0;

          while i <= high(Bouchons) do
          Begin
              if IsMagnetophoneCurseurmc1StrInfmc2(Bouchons[i].moment, Magnetophone_Curseur_Apres) then
              Begin
                       Eteindre(Bouchons[i].el_a_eteindre);
                       Bouchon_Supprimer(i);
              End
              else
                 inc(i);

          End;

    End;







    procedure Traiter(el: TElmusical; m: integer; t: TRationnel);
    Begin
        t := QDiff(t, QEl(1));

        Bouchon_Ajouter(el, m, QAdd(t, el.Duree_Get));
        Allumer(el);

    End;


                                     
var i1, i2, i, j, k: integer;


Begin
     IGP := Magnetophone_Curseur_Ancien.Comp;
     With IGP do
     Begin
         With GetMesure(Magnetophone_Curseur_Ancien.imesure) do
         Begin
               i1 := mgoi_TempsToIndicemgoiApres(Magnetophone_Curseur_Ancien.temps);
         End;

         if i1 < 0 then
             MessageErreur('arf');

         With GetMesure(Magnetophone_Curseur_Apres.imesure) do
         Begin
               i2 := mgoi_TempsToIndicemgoiAvant(Magnetophone_Curseur_Apres.temps);

               if Magnetophone_Curseur_Apres.fini then
                     i2 := high(mgoi);


         End;



         Bouchons_Traiter;

         if Magnetophone_Curseur_Ancien.imesure = Magnetophone_Curseur_Apres.imesure then
         With GetMesure(Magnetophone_Curseur_Ancien.imesure) do
         Begin
             for i := i1 to i2 do
             for j := 0 to high(mgoi[i].elms) do
                 for k := 0 to high(mgoi[i].elms[j]) do
                        Traiter(mgoi[i].elms[j][k], Magnetophone_Curseur_Ancien.imesure, mgoi[i].t);
         End
         else
         Begin
             With GetMesure(Magnetophone_Curseur_Ancien.imesure) do
             for i := i1 to high(mgoi) do
             for j := 0 to high(mgoi[i].elms) do
                 for k := 0 to high(mgoi[i].elms[j]) do
                        Traiter(mgoi[i].elms[j][k], Magnetophone_Curseur_Ancien.imesure, mgoi[i].t);

             With GetMesure(Magnetophone_Curseur_Apres.imesure) do
             for i := 0 to i2 do
             for j := 0 to high(mgoi[i].elms) do
                 for k := 0 to high(mgoi[i].elms[j]) do
                        Traiter(mgoi[i].elms[j][k], Magnetophone_Curseur_Apres.imesure, mgoi[i].t);
         End;

         //Bouchons_Traiter;

     End;

     
End;





procedure Magnetophone_Gestion_Jouer(Magnetophone_Curseur_Ancien,
                                     Magnetophone_Curseur_Apres: TMagnetophone_Curseur);
Begin
     Magnetophone_Gestion_Jouer_Sub(Magnetophone_Curseur_Ancien, Magnetophone_Curseur_Apres,
                                   Magnetophone_ElMusical_Eteindre_Classique,
                                   Magnetophone_ElMusical_Allumer_Classique);
End;

procedure Magnetophone_Gestion_JouerOrgueDeBarbarie(Magnetophone_Curseur_Ancien,
                                     Magnetophone_Curseur_Apres: TMagnetophone_Curseur);
Begin
    { Magnetophone_Gestion_Jouer_Sub(Magnetophone_Curseur_Ancien, Magnetophone_Curseur_Apres,
                                   Magnetophone_ElMusical_Eteindre_OrgueDeBarbarie,
                                   Magnetophone_ElMusical_Allumer_OrgueDeBarbarie);}
     Magnetophone_Gestion_Jouer_Sub(Magnetophone_Curseur_Ancien, Magnetophone_Curseur_Apres,
                                   Magnetophone_ElMusical_Eteindre_Classique,
                                   Magnetophone_ElMusical_Allumer_Classique);
End;




procedure Magnetophone_NotesEntenduees_Dessiner(Canvas: TCanvas; Magnetophone_Curseur: TMagnetophone_Curseur);
var b: integer;
Begin
    MusicGraph_Canvas_Set(Canvas);
    Canvas.Pen.Color := 255;
    Canvas.Pen.Width := 2;
    IGP := Magnetophone_Curseur.Comp;
    IGP.SetOriginMesure(Magnetophone_Curseur.imesure);
    for b := 0 to high(Bouchons) do
       DrawElMusical(IGP, IGP.LigneAvecMes(Magnetophone_Curseur.imesure), Bouchons[b].el_a_eteindre, false, false);

End;


end.
