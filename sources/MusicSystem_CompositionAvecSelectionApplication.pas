unit MusicSystem_CompositionAvecSelectionApplication;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicSystem_Constantes {naLieALaSuivante},
     MusicHarmonie,

     MusicSystem_CompositionBase,
     MusicSystem_CompositionAvecPagination,
     MusicSystem_CompositionAvecRoutinesDeTraitement,
     MusicSystem_CompositionAvecSelection;


type TArpegerSelectionArgument = (asVersLeHaut, asVersLeBas);




    TCompositionAvecGestionSelectionApplication = class(TCompositionAvecGestionSelection)
    public
      procedure Selection_EnharmoniquerNotesSelectionnees;
      procedure Selection_LierNotesSelectionneesAuxSuivantes;

      procedure Selection_DeplacerDUneOctaveVersLeHautNotesSelectionnees;
      procedure Selection_DeplacerDUneOctaveVersLeBasNotesSelectionnees;
      
      procedure Selection_Transposer(int: TIntervalle);
      Function Selection_Transposer_Is_Erreur(int: TIntervalle; out texte_erreur_precis: string): Boolean;


      procedure Selection_Alterer(a: TAlteration);
      procedure Selection_Alterer_Selon_Une_Tonalite(tonalite: TTonalite;
                                              is_notessensibles_respecter: Boolean);

      procedure Selection_Enharmoniquer_Selon_Une_Tonalite(tonalite: TTonalite);


      procedure Selection_OctavierVersLeBas;
      procedure Selection_OctavierVersLeHaut;

      procedure Selection_Arpeger(arg: TArpegerSelectionArgument);

      procedure Selection_MultiplierDuree(lambda: TRationnel);

      procedure Selection_DeSelectionnerNoteQuiNeSontPasDes(hauteur: integer);

      procedure Selection_FusionnerLesNotesEnUnElementMusical;
      procedure Selection_FusionnerLesNotesEtEnFaireDesPleinsPareil;

      procedure Selection_Tablature_Corde_De_Guitare_Set(corde_numero: integer);

      procedure Selection_Parkinsonner(duree_min: TRationnel);

      Function Selection_NbNotes_Get: integer;

      Function Selection_ProprietesCommunes_GetDuree(out DureeCommune: TDuree): Boolean;
      Function Selection_ProprietesCommunes_GetTailleNote(out ValeurCommune: Boolean): Boolean;

      procedure Selection_VoixListe_TString(s: TStrings);

      Function Selection_TonaliteQuiColleLePlus_Get: TTonalite;
      
    private
      Function Selection_FonctionGeneriqueExtractionValeurCommuneAuxElMusicauxSelectionnees
(premier_valeur_lecture: TProcedureTraitementElMusical; test_egalite_valeur_suivante: TFonctionBoolenneElMusical): Boolean;

      procedure AppliquerAuxNotesSelectionnees(f: TProcedureTraitementNote);
      procedure AppliquerAuxElMusicauxSelectionnees(f: TProcedureTraitementElMusical);

end;




implementation

uses ChildWin, MusicGraph,
     MusicGraph_Portees {pour IGP...},
     MusicGraph_Images {pour avoir accès aux images des pauses...},
     MusicGraph_System {pour prec},
     MusicGraph_CouleursVoix {pour CouleurNoteDansVoixInactive...},
     MusicGraph_CercleNote {pour rayonnotes},
     MusicWriter_Erreur, MusicWriterToMIDI,
     Main, Dialogs {pour ShowMessage}, instruments {pour GetInstrumentNom},
     MusicUser {ModeNuances...},
     tablature_system{Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature}
     ;


var int_prive: TIntervalle;
    alteration_prive: TAlteration;
    lambda_prive: TRationnel;
    NoteSousCurseur_HauteurNote_Hauteur_prive: integer;

procedure traitement_liealasuivante(var n: TNote);
    Begin
          InverserPr(n.BouleADroite,naLieALaSuivante);
    End;


procedure TCompositionAvecGestionSelectionApplication.Selection_LierNotesSelectionneesAuxSuivantes;
Begin
    AppliquerAuxNotesSelectionnees(traitement_liealasuivante);
End;







procedure TCompositionAvecGestionSelectionApplication.Selection_EnharmoniquerNotesSelectionnees;
Begin
    AppliquerAuxNotesSelectionnees(EnharmoniquerNote);
End;

procedure traitement_transposer(var n: TNote);
    Begin
          GetHauteurNote(int_prive,  n.HauteurNote, n.HauteurNote);
          Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);
    End;

procedure TCompositionAvecGestionSelectionApplication.Selection_Transposer(int: TIntervalle);
Begin
      int_prive := int;
      AppliquerAuxNotesSelectionnees(traitement_transposer);
End;




Function TCompositionAvecGestionSelectionApplication.Selection_Transposer_Is_Erreur(int: TIntervalle; out texte_erreur_precis: string): Boolean;
var m, v, i, j: integer;
    HauteurNoteCourante: THauteurNote;
    
Begin
         For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              with Mesures[m] do
                 For v := 0 to high(Voix) do
                     with Voix[v] do
                     if IsAffichee then
                     For i := 0 to high(ElMusicaux) do
                           with ElMusicaux[i] do
                                  For j := 0 to high(notes) do
                                    if notes[j].Selectionne <> svDeSelectionnee then
                                    Begin
                                          GetHauteurNote_Sans_Erreur(int,  notes[j].HauteurNote, HauteurNoteCourante);

                                          if not IsAlterationCorrecte(HauteurNoteCourante.Alteration) then
                                          Begin

                                              texte_erreur_precis := 'Une transposition de ' + IntervalleToStr(int) + ' n''est pas possible ! En effet, ' +
                                                       'on forcerait la note ' +  HauteurNoteToStr(notes[j].HauteurNote) +
                                                       ' à devenir ' +
                                                       HauteurAbsToStr(HauteurNoteCourante.hauteur) + ' avec ' +
                                                       AlterationIncorrecteToStr(HauteurNoteCourante.alteration) +
                                                       '.'
                                                       ;
                                              result := true;
                                              exit;
                                          End;

                                    End;

          result := false;
                                        
End;


procedure traitement_uneoctaveverslehaut(var n: TNote);
    Begin
          inc(n.HauteurNote.hauteur,7);
          Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);
    End;
    
procedure TCompositionAvecGestionSelectionApplication.Selection_DeplacerDUneOctaveVersLeHautNotesSelectionnees;
Begin
    AppliquerAuxNotesSelectionnees(traitement_uneoctaveverslehaut);
End;



procedure traitement_desselectionnernotesdifferentesdenotesouscurseur(var n: TNote);
    Begin
         if (n.HauteurNote.Hauteur
                  - NoteSousCurseur_HauteurNote_Hauteur_prive) mod 7 <> 0 then
                  n.Selectionne := svDeSelectionnee;
    End;

procedure TCompositionAvecGestionSelectionApplication.Selection_DeSelectionnerNoteQuiNeSontPasDes(hauteur: integer);
Begin
    NoteSousCurseur_HauteurNote_Hauteur_prive := hauteur;
    AppliquerAuxNotesSelectionnees(traitement_desselectionnernotesdifferentesdenotesouscurseur);
End;

procedure traitement_uneoctaveverslebas(var n: TNote);
    Begin
          dec(n.HauteurNote.hauteur,7);
          Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);
    End;
    
procedure TCompositionAvecGestionSelectionApplication.Selection_DeplacerDUneOctaveVersLeBasNotesSelectionnees;
Begin
    AppliquerAuxNotesSelectionnees(traitement_uneoctaveverslebas);
End;



procedure traitement_alterer(var n: TNote);
    Begin
          n.hauteurnote.Alteration := alteration_prive;
          Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);
    End;

    
procedure TCompositionAvecGestionSelectionApplication.Selection_Alterer(a: TAlteration);
Begin
    VerifierAlteration(a, 'TCompositionAvecGestionSelectionApplication.AltererSelection');
    
    alteration_prive := a;
    AppliquerAuxNotesSelectionnees(traitement_alterer);
End;



var private_tonalite: TTonalite;
    private_notessensibles_respecter: boolean;
    private_notesensible: THauteurNote;

procedure traitement_alterer_selon_une_tonalite(var n: TNote);
    Begin
          if private_notessensibles_respecter and
             IsHauteursNotesEgales_Modulo_L_Octave_Et_Modulo_L_Alteration(n.Hauteurnote, private_notesensible) then
                  n.hauteurnote.Alteration := private_notesensible.alteration
          else
               n.hauteurnote.Alteration := AlterationAvecTonalite(n.hauteurnote.Hauteur, private_tonalite);


          Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);
    End;

    
procedure TCompositionAvecGestionSelectionApplication.Selection_Alterer_Selon_Une_Tonalite(tonalite: TTonalite;
                                             is_notessensibles_respecter: Boolean );
Begin
      VerifierTonalite(tonalite);

      private_tonalite := tonalite;
      private_notesensible := Tonalite_NoteSensible_Get(tonalite);
      private_notessensibles_respecter := is_notessensibles_respecter;
      AppliquerAuxNotesSelectionnees(traitement_alterer_selon_une_tonalite);
End;



procedure traitement_enharmoniquer_selon_une_tonalite(var n: TNote);
    Begin
          n.hauteurnote := Enharmoniquer(n.hauteurnote, private_tonalite);
          Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);
    End;



procedure TCompositionAvecGestionSelectionApplication.Selection_Enharmoniquer_Selon_Une_Tonalite(tonalite: TTonalite);
Begin
    VerifierTonalite(tonalite);

    private_tonalite := tonalite;
    AppliquerAuxNotesSelectionnees(traitement_enharmoniquer_selon_une_tonalite);
End;


procedure TCompositionAvecGestionSelectionApplication.AppliquerAuxNotesSelectionnees(f: TProcedureTraitementNote);
{applique la fonction f sur chaque note sélectionnée}
var m, v, i, j: integer;
Begin
         For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              with Mesures[m] do
                 For v := 0 to high(Voix) do
                     with Voix[v] do
                     if IsAffichee then
                     For i := 0 to high(ElMusicaux) do
                           with ElMusicaux[i] do
                                  For j := 0 to high(notes) do
                                    if notes[j].Selectionne <> svDeSelectionnee then
                                          f(notes[j]);
End;



Function TCompositionAvecGestionSelectionApplication.Selection_FonctionGeneriqueExtractionValeurCommuneAuxElMusicauxSelectionnees
(premier_valeur_lecture: TProcedureTraitementElMusical; test_egalite_valeur_suivante: TFonctionBoolenneElMusical): Boolean;
{applique la fonction f sur chaque note sélectionnée}

var valeur_encore_indefini: Boolean;

var m, v, i: integer;
Begin
         if Selection_IsToutDeselectionner then
               MessageErreur('Message pas très grave : Selection_FonctionGeneriqueExtractionValeurCommuneAuxElMusicauxSelectionnees alors qu''il n''y a pas de sélection active!');


         valeur_encore_indefini := true;

         For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              with Mesures[m] do
                 For v := 0 to high(Voix) do
                     with Voix[v] do
                     if IsAffichee then
                     For i := 0 to high(ElMusicaux) do
                     if ElMusicaux[i].IsSelectionne then
                     Begin
                         if valeur_encore_indefini then
                         Begin
                              premier_valeur_lecture(ElMusicaux[i]);
                              valeur_encore_indefini := false;
                         End
                         else
                         Begin
                             if not test_egalite_valeur_suivante(ElMusicaux[i]) then
                             Begin
                                 result := false;
                                 Exit;
                             End;
                         End;


                     End;

        result := not valeur_encore_indefini; {normalement on dirait vrai...true};

End;



procedure TCompositionAvecGestionSelectionApplication
         .AppliquerAuxElMusicauxSelectionnees(f: TProcedureTraitementElMusical);
{applique la fonction f sur chaque note sélectionnée}
var m, v, i: integer;
Begin
         For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              with Mesures[m] do
                 For v := 0 to high(Voix) do
                     with Voix[v] do
                     if IsAffichee then
                     For i := 0 to high(ElMusicaux) do
                          if ElMusicaux[i].IsSelectionne then
                               f(ElMusicaux[i]);
                              

End;




procedure TCompositionAvecGestionSelectionApplication.Selection_OctavierVersLeHaut;
var m, v, i: integer;
    pos: TPosition;
    hn: THauteurNote;

Begin
        For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              For v := 0 to high(Mesures[m].Voix) do With Mesures[m].Voix[v] do if IsAffichee then
                 For i := 0 to high(ElMusicaux) do with ElMusicaux[i] do
                 if high(Notes) > -1 then
                 if Notes[0].Selectionne <> svDeSelectionnee then
                 Begin
                      pos := Notes[0].position;
                      hn := Notes[0].HauteurNote;
                      inc(hn.Hauteur , 7);
                      inc(pos.hauteur, 7);
                      AddNote2(pos, hn);
                 End;

End;


procedure TCompositionAvecGestionSelectionApplication.Selection_OctavierVersLeBas;
var m, v, i: integer;
    pos: TPosition;
    hn: THauteurNote;
    
Begin
        For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              For v := 0 to high(Mesures[m].Voix) do With Mesures[m].Voix[v] do if IsAffichee then
                 For i := 0 to high(ElMusicaux) do with ElMusicaux[i] do
                 if high(Notes) > -1 then
                 if Notes[0].Selectionne <> svDeSelectionnee then
                 Begin
                      pos := Notes[0].position;
                      hn := Notes[0].HauteurNote;
                      inc(hn.Hauteur , -7);
                      inc(pos.hauteur, -7);
                      AddNote2(pos, hn);
                 End;

End;



procedure TCompositionAvecGestionSelectionApplication.Selection_Arpeger(arg: TArpegerSelectionArgument);
var notes_traitees, m, v, i, n: integer;



    procedure PutNote(note: TNote;
                      Duree: TRationnel);
    var nv_el: TElMusical;
    
    Begin
        if note.Selectionne <> svDeselectionnee then
        Begin
             nv_el := CreerElMusical1Note(Duree, Note);

             nv_el.SelectionnerElMusical;
             nv_el.Selection_Valider;

             Mesures[m].Voix[v].AddElMusical(i + 1,
                          nv_el);

             inc(notes_traitees);
        End;
    End;

Begin



    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              For v := 0 to high(Mesures[m].Voix) do With Mesures[m].Voix[v] do if IsAffichee then
                 Begin
                     i := 0;

                     while i <= high(ElMusicaux) do with ElMusicaux[i] do
                     Begin
                         if IsSelectionne and not IsSilence then
                         Begin
                             notes_traitees := 0;

                             if asVersLeHaut = arg then
                             Begin
                                 for n := NbNotes - 1 downto 0 do
                                      PutNote(GetNote(n), Duree_Get);

                             End
                             else
                             Begin
                                 for n := 0 to NbNotes - 1 do
                                      PutNote(GetNote(n), Duree_Get);
                                      
                             End;

                                  
                             DelElMusical(i);
                             inc(i, notes_traitees);

                         End
                         else
                             inc(i);
                         

                     End;


                 End;



End;








        procedure MultiplierDureeLambda(var el: TElMusical);
        Begin
            el.Duree_Set(QMul(lambda_prive, el.Duree_Get));
        End;

procedure TCompositionAvecGestionSelectionApplication.Selection_MultiplierDuree(lambda: TRationnel);
Begin
     lambda_prive := lambda;
     AppliquerAuxElMusicauxSelectionnees(MultiplierDureeLambda);
End;



{Durée commune}

       var private_Selection_GetDureeCommune_DureeCommune: TDuree;

       procedure Selection_ProprietesCommunes_GetDuree_Premiere_Valeur_Lecture(var el: TElMusical);
       Begin
            private_Selection_GetDureeCommune_DureeCommune := el.Duree_Get;
       End;


       Function Selection_ProprietesCommunes_GetDuree_Test_Egalite_Valeur_Suivante(var el: TElMusical): Boolean;
       Begin
            result := IsQEgal(private_Selection_GetDureeCommune_DureeCommune, el.Duree_Get);
       End;


Function TCompositionAvecGestionSelectionApplication.Selection_ProprietesCommunes_GetDuree(out DureeCommune: TDuree): Boolean;
Begin
      result := Selection_FonctionGeneriqueExtractionValeurCommuneAuxElMusicauxSelectionnees
         (Selection_ProprietesCommunes_GetDuree_Premiere_Valeur_Lecture,
          Selection_ProprietesCommunes_GetDuree_Test_Egalite_Valeur_Suivante);

      DureeCommune := private_Selection_GetDureeCommune_DureeCommune;
End;








{Durée commune}

       var private_Selection_GetTailleNote_TailleNote: Boolean;

       procedure Selection_ProprietesCommunes_TailleNote_Premiere_Valeur_Lecture(var el: TElMusical);
       Begin
            private_Selection_GetTailleNote_TailleNote := el.attributs.PetitesNotes;
       End;


       Function Selection_ProprietesCommunes_TailleNote_Test_Egalite_Valeur_Suivante(var el: TElMusical): Boolean;
       Begin
            result := private_Selection_GetTailleNote_TailleNote = el.attributs.PetitesNotes;
       End;


Function TCompositionAvecGestionSelectionApplication.Selection_ProprietesCommunes_GetTailleNote(out ValeurCommune: Boolean): Boolean;
Begin
      result := Selection_FonctionGeneriqueExtractionValeurCommuneAuxElMusicauxSelectionnees
         (Selection_ProprietesCommunes_TailleNote_Premiere_Valeur_Lecture,
          Selection_ProprietesCommunes_TailleNote_Test_Egalite_Valeur_Suivante);

      ValeurCommune := private_Selection_GetTailleNote_TailleNote;
End;



procedure TCompositionAvecGestionSelectionApplication.Selection_VoixListe_TString(s: TStrings);
var voix_ens: set of 0..255;

        procedure Voix_Init;
        Begin
             s.Clear;
             voix_ens := [];
        End;


        Function Is_Voix_Deja_Trouve_Qch(v_num: integer): Boolean;
        Begin
            result := (v_num in voix_ens);
        End;


        procedure Voix_Trouver(v_num: integer);
        Begin
            if v_num < 0 then exit;
            
            s.Add(inttostr(v_num));
            voix_ens := voix_ens + [v_num];
        End;



var m, v, i: integer;
Begin
         Voix_Init;


         if Selection_IsToutDeselectionner then
               MessageErreur('Message pas très grave : Selection_FonctionGeneriqueExtractionValeurCommuneAuxElMusicauxSelectionnees alors qu''il n''y a pas de sélection active!');


         For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              with Mesures[m] do
                 For v := 0 to high(Voix) do
                     if not Is_Voix_Deja_Trouve_Qch(Voix[v].N_Voix) then
                     with Voix[v] do
                     if IsAffichee then
                     For i := 0 to high(ElMusicaux) do
                     if ElMusicaux[i].IsSelectionne then
                            Begin
                                Voix_Trouver(Voix[v].N_Voix);
                                Break;
                            End;

End;





procedure TCompositionAvecGestionSelectionApplication.Selection_FusionnerLesNotesEnUnElementMusical;
var PressePapier: TMesure;
    mes: integer;
    temps : TRationnel;
    
Begin
    PressePapier := TMesure.Create;
    Selection_CopieToPressePapier(PressePapier);


    temps := Selection_TempsDebut;
    mes := Selection_GetIMesDebutSelection;
    
    Selection_Supprimer;

    CollerGrosAccord(PressePapier, mes,
                                 QAdd(Qel(1), temps));

    Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(mes);

    PressePapier.Free;
    
End;


        

procedure TCompositionAvecGestionSelectionApplication.Selection_FusionnerLesNotesEtEnFaireDesPleinsPareil;
var PressePapier: TMesure;
    nv_el: TElMusical;
    n_v: integer;
    v, i, m: integer;
    
Begin
     PressePapier := TMesure.Create;
     Selection_CopieToPressePapier(PressePapier);

     
     for v := 0 to high(PressePapier.Voix) do
     Begin
           n_v := PressePapier.Voix[v].N_Voix;

           nv_el := PressePapier.Voix[v].CreerElMusicalGrosAccord;
           nv_el.SelectionnerElMusical;
           nv_el.Selection_Valider;

           For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
              with Mesures[m].VoixNum(n_v) do
                     For i := 0 to high(ElMusicaux) do
                          if ElMusicaux[i].IsSelectionne then
                               ElMusicaux[i].CopierLesNotesAPartirDe(nv_el);

           nv_el.Free;
     end;

     PressePapier.Free;
End;



var private_corde_numero: integer;

procedure private_Note_Tablature_Corde_De_Guitare(var n: TNote);
Begin
   Tablature_System_CordeNum_Set(n, private_corde_numero);
End;



procedure TCompositionAvecGestionSelectionApplication.Selection_Tablature_Corde_De_Guitare_Set(corde_numero: integer);
Begin
     private_corde_numero := corde_numero;
     AppliquerAuxNotesSelectionnees(private_Note_Tablature_Corde_De_Guitare);
End;



procedure TCompositionAvecGestionSelectionApplication.Selection_Parkinsonner(duree_min: TRationnel);
var m, v, i: integer;
    newel: TElMusical;
Begin
   For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    with Mesures[m] do
       For v := 0 to high(Voix) do
           with Voix[v] do
           if IsAffichee then
           Begin
                i := high(ElMusicaux);

                while i >= 0 do
                Begin
                    if ElMusicaux[i].IsSelectionne then
                    Begin
                        if IsQ1InfQ2(ElMusicaux[i].Duree_Get, duree_min) then
                            dec(i)
                        else
                        Begin
                            ElMusicaux[i].Duree_Set(QDiff(ElMusicaux[i].Duree_Get, duree_min));

                            newel := CopieElMusical(ElMusicaux[i]);
                            newel.Duree_Set(duree_min);
                            AddElMusical(i+1, newel);
                        End;
                    End
                    else
                        dec(i);
                End;
           End;

End;






var private_nb_notes: integer;

      procedure traitement_compter_notes(var n: TNote);
      Begin
           inc(private_nb_notes);
      End;

Function TCompositionAvecGestionSelectionApplication.Selection_NbNotes_Get: integer;
Begin
      private_nb_notes := 0;
      AppliquerAuxNotesSelectionnees(traitement_compter_notes);
      result := private_nb_notes;
End;








var tonalite_testee: TTonalite;
    note_tonalite_testee: integer;

    procedure traitement_tonalitequicolleleplus(var n: TNote);
    var hn: THauteurNote;
    Begin
         hn := Enharmoniquer(n.HauteurNote, tonalite_testee);

         if AlterationAvecTonalite(hn.Hauteur, tonalite_testee) <> hn.alteration then
                inc(note_tonalite_testee);
    End;


Function TCompositionAvecGestionSelectionApplication.Selection_TonaliteQuiColleLePlus_Get: TTonalite;
var it: TTonalite;
    meilleure_note: integer;
    tonalite_gagnante: integer;
Begin
    tonalite_gagnante := 0;
    meilleure_note := infinity;
    
    for it := -7 to 7 do
    Begin
         note_tonalite_testee := 0;

         tonalite_testee := it;
         AppliquerAuxNotesSelectionnees(traitement_tonalitequicolleleplus);

         if note_tonalite_testee < meilleure_note then
              Begin
                    meilleure_note := note_tonalite_testee;
                    tonalite_gagnante := tonalite_testee;

              End;

    End;
    result := tonalite_gagnante;
End;





end.
