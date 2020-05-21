unit MusicSystem;


interface

uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,

     MusicSystem_CompositionBase,
     MusicSystem_CompositionAvecPagination,
     MusicSystem_CompositionAvecSelection,
     MusicSystem_CompositionAvecSelectionApplication,
     MusicSystem_CompositionSub,

     MusicSystem_Curseur;





type TComposition1 = class(TCompositionSub)
     function Selection_GetDescription: string;
     procedure MettreAJourNotesADeplacees(IntervalleDeplacement: TIntervalle;
                                                  DiffPorteeDeplacement: integer;
                                                  Deplacement_IsSurTablature: Boolean;
                                                  Deplacement_Tablature_Corde_Deplacement: integer;
                                                  ajouter, modetonalpur: Boolean);
     procedure Selection_DeplacerPauses(HauteurDeplace: integer);

     Function Curseur_Obtenir: TCurseur;
     
private


end;







Function ClefToStr(Clef: TClef): String;















implementation

uses ChildWin, MusicGraph,
     MusicGraph_Portees {pour IGP...},
     MusicGraph_Images {pour avoir accès aux images des pauses...},
     MusicGraph_System {pour prec},
     MusicGraph_CouleursVoix {pour CouleurNoteDansVoixInactive...},
     MusicGraph_CercleNote {pour rayonnotes},
     MusicWriter_Erreur, MusicWriterToMIDI,
     Main, Dialogs {pour ShowMessage}, instruments {pour GetInstrumentNom},
     MusicUser, MusicSystem_CompositionBaseAvecClef {ModeNuances...},
     tablature_system{pour Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature};













Function ClefToStr(Clef: TClef): String;
Begin
      case Clef of
             ClefSol: result := 'Clef de sol';
             ClefFa: result := 'Clef de fa';
             ClefUt3: result := 'Clef d''ut';
             ClefSol8: result := 'Clef de sol 8';
      end;
End;




















































Function TComposition1.Curseur_Obtenir: TCurseur;
Begin
    result := TCurseur.Create(self);
End;


function TComposition1.Selection_GetDescription: string;
Begin
    If Selection_IsToutDeselectionner then
           result := 'Pas de sélection'
     else
     Begin
         if Selection_Getimesdebutselection = Selection_Getimesfinselection then
                 result := 'Sélection mes. n° ' + inttostr(Selection_Getimesdebutselection + 1)
           else
                 result := 'Sélection mes. n° ' +
                         inttostr(Selection_Getimesdebutselection + 1) +
                         ' à ' +
                         inttostr(Selection_Getimesfinselection + 1);

             result := result + ' (' + InfoSelectionToStr + ')';
     End;
End;






procedure TComposition1.MettreAJourNotesADeplacees(IntervalleDeplacement: TIntervalle;
                                                  DiffPorteeDeplacement: integer;
                                                  Deplacement_IsSurTablature: Boolean;
                                                  Deplacement_Tablature_Corde_Deplacement: integer;
                                                  ajouter, modetonalpur: Boolean);
{Met à jour la partition lors d'un déplacement de note
(se produit qd toi, le bonhomme, lève le bouton gauche de la souris)

"ajouter" vaut (ssCtrl in Shift) and not DeplacerAutrePart
si modetonalpur = true, alors les altérations sont celles imposées par la tonalité courante

le déplacement est paramétré par 2 variables :
 - DiffPorteeDeplacement qui reflète le déplacement de portée
    (si pour une note est amené à sortir de l'intervalle admissible des portées
     celle-ci est ramené dans la portée la plus proche via l'appel à
     NumPorteeValide. lol cela évite bien des plantages !!!)

 - IntervalleDeplacement qui est l'intervalle de transposition

}

var m, i, v, j:integer;
    infoclef: TInfoClef;
    hn: THauteurNote;
    pos: TPosition;
    nouveauiportee: integer;
    numcorde_souhaitee: integer;
    

Begin

    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    with GetMesure(m) do
          For v := 0 to high(Voix) do with Voix[v] do
          Begin
                 For i := 0 to high(ElMusicaux) do
                 With ElMusicaux[i] do
                           if not IsSilence then
                           Begin
                                for j := 0 to NbNotes - 1 do
                                Begin
                                       if IsNoteSelectionnee(j) then
                                             Begin
                                                 infoclef := InfoClef_Detecter(Notes[j].position.portee,
                                                          m, SurTemps(i));

                                                 hn := HauteurNoteGraphiqueToAbs(infoclef, Notes[j]);
                                                 GetHauteurNote(IntervalleDeplacement, hn, hn);

                                                 pos := Notes[j].position;

                                                 nouveauiportee := Notes[j].position.portee + DiffPorteeDeplacement;
                                                 NumPorteeValide(nouveauiportee);
                                                 infoclef := InfoClef_Detecter( nouveauiportee, m,
                                                                      SurTemps(j));

                                                 pos.hauteur := HauteurAbsToHauteurGraphique(infoclef, hn.hauteur);

                                                 {ça dépend du mode !!!!!!}

                                                 {mode tonal pur}
                                                 if modetonalpur then
                                                       hn.alteration := AlterationAvecTonalite(hn.Hauteur, TonaliteCourante);



                                                 if ajouter then
                                                         AddNote2(pos, hn)
                                                 else
                                                 With Notes[j] do
                                                 Begin
                                                     hauteurnote := hn;
                                                     position := pos;
                                                     position.portee := nouveauiportee;

                                                     if not IsIntervalleTrivial(IntervalleDeplacement) then

                                                     if not Deplacement_IsSurTablature then
                                                         Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(Notes[j])
                                                         
                                                     else
                                                         numcorde_souhaitee :=
                                                         Tablature_System_CordeNum_Get(Notes[j])
                                                         + Deplacement_Tablature_Corde_Deplacement;

                                                         Tablature_CordeNum_Arrondir(numcorde_souhaitee);

                                                         Tablature_System_NumCorde_Set_OuEnDessous(Notes[j],
                                                           numcorde_souhaitee);
                                                 end;

                                             End;
                                 End;

                                 ClasserBoules;



                           End;
          End;

End;





procedure TComposition1.Selection_DeplacerPauses(HauteurDeplace: integer);
var m, v, i: integer;
    nn: TElMusical;
    
Begin
    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    With GetMesure(m) do
        For v := 0 to high(Voix) do
        Begin
               For i := 0 to high(Voix[v].ElMusicaux) do
                         if Voix[v].ElMusicaux[i].IsSilence then
                         Begin
                              nn := Voix[v].ElMusicaux[i];

                              if nn.IsSelectionne then
                                     inc(nn.position.hauteur, HauteurDeplace);


                         End;
        End;
End;































end.
