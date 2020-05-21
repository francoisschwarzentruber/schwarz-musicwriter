unit MusicSystem_CompositionAvecSelection;

interface



uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,

     MusicSystem_CompositionBase,
     MusicSystem_CompositionAvecPagination,
     MusicSystem_CompositionListeObjetsGraphiques,
     MusicSystem_CompositionAvecGestionNuances;



  




type TCompositionAvecGestionSelection = class(TCompositionAvecGestionNuances)
  public
       constructor Create;

      {gestion de la sélection}
       procedure Selection_ToutDeselectionner;

       procedure Selection_Selectionner(selection_rectangle: TRect; n_voix_privilege: integer);
      {sélectionne les éléments musicaux
       - qui sont dans selection_rectangle (repère du document)
       - si n_voix >= 0, ET qui sont dans la voix n_voix  }

       procedure Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(m:integer);
       {indique que la mesure m contient des el. mus. sélectionnés}

       Procedure Selection_Supprimer;
       {supprime (efface) les el. mus. sélectionnés}

       Function Selection_PorteeApprox: integer;

       Function Selection_Instrument_Portee_Get: integer;
       {indique dans quel instrument se trouve la sélection
       si la sélection est sur plusieurs instruments ou si il n'y a pas de sélection,
         renvoie -1}

       Function Selection_YaUneSelection: Boolean;
       Function Selection_IsToutDeselectionner: Boolean;
       {y-a-t-il une sélection active ?
       ces deux fonctions sont copines  }

       Function Selection_TempsDebut: TRationnel;
       {modifie éventuellement imesdebutselection
        puis retourne le temps du premier élément sélectionnée dans la mesure
        n° imesdebutselection

        ex : Si le premier élément est sélectionnée se trouve tout au début
             de la mesure n° *, renvoie 0/1

        remarque : s'il n'y a pas de sélection active le résultat est
                   indéfini}


       Function Selection_TempsFin: TRationnel;
       {itou fin}

       Function Selection_GetNumVoix: integer;
       {donne le numéro de voix des él. sélectionnées...
        si il n'y a pas de sélection ou que la sélection est répartie sur plusieurs
         voix, retourne VOIX_TOUTES_LES_VOIX}

       Function Selection_GetIMesDebutSelection: integer;
       Function Selection_GetIMesFinSelection: integer;


       Function InfoSelectionToStr: string;


       Procedure Selection_SelectionnerPortees(iDePortee, iAPortee: integer);
       {sélectionne (en plus de la sélection actuelle...) toutes les notes des portées
         iDePortee à iAPortee}

       Procedure Selection_SelectionnerMesures(mdeb, mfin: integer);

       procedure Selection_SelectionnerTout;

       
       Procedure Selection_FaireSubSelection(info: integer);
       {Faire une sous-sélection
    info = 0 : que les notes du bas
    info = 1, que les notes du haut
}

       procedure Selection_FaireSubSelectionQueVoixNum(voix_num: integer);


       Procedure Selection_FaireSubSelection1elmusSur2;
       procedure Selection_CopieToPressePapier(PP: TMesure);

{******* les collages*****}

       Function Coller(PP: TMesure; m: integer; temps: TRationnel): integer;
       {Colle le contenu de PP, dans la mesure numéro m, au temps temps
 temps au début d'une mesure = 1/1 }

       Procedure CollerEnInversant(PP: TMesure; m: integer; temps: TRationnel);

       Procedure CollerGrosAccord(PP: TMesure; m: integer; temps: TRationnel);


       
       Procedure Selection_DeplacerNotesSelectionneesPortee(chgtrel: integer);


       procedure PaginerApresModifSelection(optimisation_calculer_graphe_info_verticalite_notes: Boolean);

       Function DelMesure(m: integer): Boolean;
       
       procedure Selection_Valider;



       Function Selection_VerifierSelectionValide: Boolean;

       Function Selection_Get_Ancre_Position: TPoint;

       Function Selection_HauteurNotePremiereNote_Get(var hn: THauteurNote): Boolean;
                      


  private
       imesdebutselection, imesfinselection: integer;

       Procedure Selection_Info(var nb_elmus, nb_silences, nb_notes: integer; var el_mus: TElMusical);

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
     MusicUser, MusicSystem_ElMusical_Liste_Notes,
  MusicSystem_Composition_Portees_Liste {ModeNuances...},
     Musicwriter_langue;



constructor TCompositionAvecGestionSelection.Create;
Begin
    inherited Create;

    imesdebutselection := infinity;
    imesfinselection := -1;
End;

procedure TCompositionAvecGestionSelection.Selection_ToutDeselectionner;
{déselectionne tout}
var m, v, i: integer;
Begin
//préconditions
    if not Selection_VerifierSelectionValide then
         exit;

    For m := imesdebutselection to imesfinselection do
          For v := 0 to high(Mesures[m].Voix) do
                 For i := 0 to high(Mesures[m].Voix[v].ElMusicaux) do
                           Mesures[m].Voix[v].ElMusicaux[i].Deselectionner;

    imesdebutselection := infinity;
    imesfinselection := -1;

End;







procedure TCompositionAvecGestionSelection.Selection_Selectionner(selection_rectangle: TRect;
                                                        n_voix_privilege: integer);
{sélectionne les éléments musicaux
    - qui sont dans r (repère du document)
    - si n_voix >= 0, ET qui sont dans la voix n_voix  }

var l, m, v, i, j, pixy, l1, l2, m1, m2:integer;
    okpourcettevoix, yaqchdeselectionneedanslamesure: boolean;


        procedure Swap(var x, y:integer);
        var t:integer;
        Begin
            t := x;
            x := y;
            y := t;
        End;


        
Begin
    if selection_rectangle.left > selection_rectangle.Right then
         Swap(selection_rectangle.left, selection_rectangle.Right);

    if selection_rectangle.Top > selection_rectangle.Bottom then
         Swap(selection_rectangle.Top, selection_rectangle.Bottom);


    {l1 := max(LigneAvecY(r.Top), 0);
    l2 := max(LigneAvecY(r.Bottom), 0);   }

    l1 := max(min(LigneAvecY(selection_rectangle.Top),
                  LigneAvecMes(imesdebutselection)),0);
    l2 := max(max(LigneAvecY(selection_rectangle.Bottom),
                  LigneAvecMes(imesfinselection)),0);

    {le max(...,0) c'est pour éviter les débordements (qd =-1)
     Ensuite, par exemple pour l2, a priori, l2 = LigneAvecY(r.Bottom) ie
     la dernière où il peut avoir une sélection est la ligne où finit le rectangle.
     Néanmoins, il peut se passer deux choses :
      - une sélection  déjà été faite et il faut la conserver
      - le rectangle étant plus grand avant et déjà la ligne LigneAvecY(r.Bottom).
        Il faut donc déselectionner.}



    {le rectangle de sélection se trouve entre la ligne l1 à la ligne l2 et les mesures
    concernées sont dans [m1, m2]}

    {
    //A VIRER !!!imesdebutselection := min(m1, imesdebutselection);
    imesfinselection := max(m2, imesfinselection); }


    For l := l1 to l2 do
    Begin
         pixy := Lignes[l].pixy;
        { m1 := GetMesureSurLigne(l,r.Left);
         m2 := GetMesureSurLigne(l,r.Right);    }
         m1 := Lignes[l].mdeb;
         m2 := LignesMFin(l);

         {m1 := min(Lignes[l1].mdeb, imesdebutselection);
         m2 := max(LignesMFin(l2), imesfinselection);
          c'est pas bien ???????????}

         For m := m1 to m2 do
         Begin
              yaqchdeselectionneedanslamesure := false; {a priori}
              For v := 0 to high(Mesures[m].Voix) do
              with Mesures[m].Voix[v] do
              if IsAffichee then
              Begin
                     if (n_voix_privilege = VOIX_TOUTES_LES_VOIX) then
                            okpourcettevoix := true
                     else
                            okpourcettevoix := (N_Voix = n_voix_privilege);

                     if okpourcettevoix then
                     For i := 0 to high(ElMusicaux) do
                               With ElMusicaux[i] do
                               Begin
                                 if IsSilence and (N_Voix >= 0) then
                                 {teste si le silence se trouve dans le rectangle de sélection}
                                 Begin
                                      if PointInRect(Mesures[m].pixx + pixx,
                                                     pixy + GetY(self, l, position),
                                                     selection_rectangle) then
                                      Begin
                                              SelectionnerElMusical;
                                              yaqchdeselectionneedanslamesure := true;
                                      End else DeSelectionnerElMusicalSiSelectionNonValidee;



                                 End

                                 else
                                 Begin
                                      {on teste si chaque note se trouve oui ou non dans le
                                      rectangle de sélection}
                                      for j := 0 to high(Notes) do
                                      With Notes[j] do
                                      Begin
                                        if PointInRect(Mesures[m].pixx + GetXBoules(j),
                                                        pixy + GetY(self, l, Notes[j].position),
                                                        selection_rectangle)
                                        then
                                        begin
                                                Notes[j].Selectionne := svFraichementSelectionnee;
                                                yaqchdeselectionneedanslamesure := true;
                                         end
                                         else if
                                            (Portee_IsTablature_Et_PasDehors(tablature_position.portee) and
                                            PointInRect(Mesures[m].pixx + GetXBoules(j),
                                                        pixy + GetY(self, l, Notes[j].tablature_position),
                                                        selection_rectangle)
                                            )
                                                        then
                                                        
                                         begin
                                                Notes[j].Selectionne := svFraichementSelectionnee;
                                                yaqchdeselectionneedanslamesure := true;
                                         end
                                         
                                         else if Notes[j].Selectionne = svFraichementSelectionnee then
                                                Notes[j].Selectionne := svDeSelectionnee;

                                      End;


                                 End;
                               End; //with
              End;

              if yaqchdeselectionneedanslamesure then
                    Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(m);
              {si ya qch dans cette mesure, il faut l'inclure dans l'intervalle
                 [imesdebutselection, imesfinselection]}

         End;
    End;


End;





Procedure TCompositionAvecGestionSelection.Selection_Supprimer;
{supprime la sélection (ne supprime que les notes vraiment sélectionnées
 ie celle qui ont été validées)}
var i, j, m, v:integer;
    el: TElMusical;

Begin
    for m := imesdebutselection to imesfinselection do
         for v := 0 to high(Mesures[m].Voix) do
         Begin
                 i := 0;
                 while i <= high(Mesures[m].Voix[v].ElMusicaux) do
                 Begin
                     el := Mesures[m].Voix[v].ElMusicaux[i];
                     if (el.IsSelectionne) and el.IsSilence then
                            Mesures[m].Voix[v].DelElMusical(i)
                     else if not el.IsSilence then
                     Begin
                          j := 0;
                          while j <= high(el.Notes) do
                                 if el.Notes[j].Selectionne = svSelectionnee then
                                       el.delnote2(j)
                                 else
                                       inc(j);

                          if (high(el.Notes) = -1) and not ({(*)}Mesures[m].Voix[v].IsVoixBrouillon) then
                          {si un élément musical n'a plus de notes, on le supprime
                           mais à une certain condition (*)...}
                                  Mesures[m].Voix[v].DelElMusical(i)
                          else
                               inc(i);

                     end
                     else
                          inc(i);
                 end;

         End;


{une fois qu'on a supprimé la sélection, il n'y a plus de sélection !!}
    imesdebutselection := infinity;
    imesfinselection := -1;

    Selection_VerifierSelectionValide;

End;


Function TCompositionAvecGestionSelection.Selection_IsToutDeselectionner: Boolean;
Begin
   result := (imesfinselection = -1);
End;


Function TCompositionAvecGestionSelection.Selection_YaUneSelection: Boolean;
Begin
    result := not Selection_IsToutDeselectionner;
End;

Function TCompositionAvecGestionSelection.Selection_TempsDebut: TRationnel;
var T, miniT: TRationnel;
    quitter: Boolean;
    m, v, i:integer;
Begin
    T := Qel(360);
    quitter := false;

    for m := imesdebutselection to imesfinselection do with Mesures[m] do
    Begin
          if quitter then break;

          for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
          Begin
              miniT := Qel(0);

              for i := 0 to high(ElMusicaux) do with ElMusicaux[i] do
              Begin
                     if isSelectionne then
                     Begin
                          imesdebutselection := m;
                          if IsQ1InfQ2(miniT, T) then
                                T := miniT;


                          quitter := true;
                          break;
                     End;
                     QInc(miniT, Duree_Get);
              End;
          End;
    End;
    result := T;

//post-conditions
    Selection_VerifierSelectionValide;

End;



Function TCompositionAvecGestionSelection.Selection_TempsFin: TRationnel;
var T, miniT: TRationnel;
    quitter: Boolean;
    m, v, i:integer;
Begin
    T := Qel(0);
    quitter := false;

    for m := imesfinselection downto imesdebutselection do with Mesures[m] do
    Begin
          if quitter then break;

          for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
          Begin
              miniT := Qel(0);

              for i := 0 to high(ElMusicaux) do with ElMusicaux[i] do
              Begin
                     QInc(miniT, Duree_Get);
                     if ElMusicaux[i].isSelectionne then
                     Begin
                          imesfinselection := m;
                          if IsQ1InfQ2(T, miniT) then
                                T := miniT;

                          quitter := true;
                     End;

              End;

          End;
    End;
    result := T;
    
//post-conditions
    Selection_VerifierSelectionValide;

End;




Function TCompositionAvecGestionSelection.Selection_GetNumVoix: integer;
var m, v, i: integer;

Begin
   result := VOIX_TOUTES_LES_VOIX;
   for m := imesfinselection downto imesdebutselection do with Mesures[m] do
      for v := 0 to high(Voix) do with Voix[v] do
          for i := 0 to high(ElMusicaux) do
              if ElMusicaux[i].IsSelectionne then
              Begin
                    if result = VOIX_TOUTES_LES_VOIX then
                         result := N_Voix
                    else if result <> N_Voix then
                    Begin
                         result := VOIX_TOUTES_LES_VOIX;
                         Exit;
                    End;

              End;

End;


Function TCompositionAvecGestionSelection.Selection_GetIMesDebutSelection: integer;
Begin
    result := imesdebutselection;
End;

Function TCompositionAvecGestionSelection.Selection_GetIMesFinSelection: integer;
Begin
    result := imesfinselection;
End;


Procedure TCompositionAvecGestionSelection.Selection_Info(var nb_elmus, nb_silences, nb_notes: integer; var el_mus: TElMusical);
var m, v, i: integer;
Begin
    nb_elmus := 0;
    nb_silences := 0;
    nb_notes := 0;

    IGP := self;
    
    el_mus := nil;
    for m := imesfinselection downto imesdebutselection do with Mesures[m] do
    Begin

          for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
          Begin


              for i := 0 to high(ElMusicaux) do with ElMusicaux[i] do
              Begin
                     if isSelectionne then
                     Begin
                          el_mus := ElMusicaux[i];

                          inc(nb_elmus);

                          if IsSilence then
                              inc(nb_silences)

                          else
                             inc(nb_notes, NbNotesSelectionnees);

           
                     End;

              End;

          End;
    End;

    
End;




Function TCompositionAvecGestionSelection.InfoSelectionToStr: string;
var nb_elmus, nb_silences, nb_notes: integer; var el_mus: TElMusical;
      
begin
    Selection_Info( nb_elmus, nb_silences, nb_notes, el_mus);

    if nb_elmus = 0 then
        MessageErreur('pas de sélection alors que le logiciel croit que quelquechose est sélectionnée! T''inquiètes pas : c''est pas une erreur très grave... mais quand même, c''est pas du propre tout ça !')
    else
    if (nb_elmus = nb_silences) then
         result := Langue_Nombre_NomMasculin_SSiPluriel(nb_silences, 'silence')

    else if nb_elmus = 1 then
        result := ElMusicalEtSelectionToStr(el_mus)

    else if nb_silences = 0 then
         result := Langue_Nombre_NomFeminin_SSiPluriel(nb_notes, 'note')
    else
         result := Langue_Nombre_NomFeminin_SSiPluriel(nb_notes, 'note') + ' et ' +
                   Langue_Nombre_NomMasculin_SSiPluriel(nb_silences, 'silence');
End;





Procedure TCompositionAvecGestionSelection.Selection_SelectionnerPortees(iDePortee, iAPortee: integer);
var m, v, e, n: integer;
Begin
    VerifierIndicePortee(iDePortee, 'iDePortee incorrect dans SelectionnerPortees');
    VerifierIndicePortee(iAPortee, 'iAPortee incorrect dans SelectionnerPortees');

     imesdebutselection := 0;
     imesfinselection := high(Mesures);

     for m := 0 to high(Mesures) do
           with Mesures[m] do
                for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
                      with Voix[v] do
                          for e := 0 to high(ElMusicaux) do
                                with ElMusicaux[e] do
                                Begin
                                      if IsSilence then
                                      Begin
                                           if position.portee in [iDePortee,iAPortee] then
                                                 SelectionnerElMusical;
                                      End
                                      else
                                      Begin
                                          for n := 0 to NbNotes - 1 do
                                                with GetNote(n) do
                                                  if position.portee in [iDePortee,iAPortee] then
                                                       SelectionnerNote(n);
                                      End;

                                      Selection_Valider;
                          
                                End;

     Selection_VerifierSelectionValide;
End;


Procedure TCompositionAvecGestionSelection.Selection_SelectionnerMesures(mdeb, mfin: integer);
var m, v, e: integer;
Begin
     imesdebutselection := mdeb;
     imesfinselection := mfin;

     for m := mdeb to mfin do
           with Mesures[m] do
                for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
                      with Voix[v] do
                          for e := 0 to high(ElMusicaux) do
                                with ElMusicaux[e] do
                                Begin
                                      SelectionnerElMusical;
                                      Selection_Valider;

                                End;

     Selection_VerifierSelectionValide;
End;



procedure TCompositionAvecGestionSelection.Selection_SelectionnerTout;
Begin
    Selection_SelectionnerMesures(0, high(Mesures));
End;






Function TCompositionAvecGestionSelection.Selection_VerifierSelectionValide: Boolean;
var m, v, i: integer;
Begin
result := true;

if not ( (imesfinselection = -1) or IsIndiceMesureValide(imesdebutselection) ) then
Begin
   MessageErreur('VerifierSelectionValide : erreur !!! imesdebutselection vaut ' + inttostr(imesdebutselection));
   result := false;

End;

if not (IsIndiceMesureValide(imesfinselection) or (imesfinselection = -1)) then
Begin
   MessageErreur('VerifierSelectionValide : erreur !!! imesfinselection vaut ' + inttostr(imesfinselection));
   result := false;

End;

if imesfinselection >= NbMesures then
     imesfinselection := NbMesures - 1;
     

//gros test de beuh
if Selection_IsToutDeselectionner then
Begin
      For m := 0 to high(Mesures) do with Mesures[m] do
           for v := 0 to high(Voix) do with Voix[v] do
                 for i := 0 to high(ElMusicaux) do
                         if ElMusicaux[i].IsSelectionne then
                         Begin
                             MessageErreur(
'Un élément musical est encore marqué comme "sélectionné" alors que imesfinselection = -1.' +
 ' Où ? Il se situe à la mesure m = ' + inttostr(m) + ', voix v = ' + inttostr(v) +
 ', el. mus. i = ' + inttostr(i) + '. voilà !');
                             result := false;
                             Exit;
                         End;
End;


End;




procedure TCompositionAvecGestionSelection.Selection_CopieToPressePapier(PP: TMesure);
var m: integer;
Begin
    Selection_VerifierSelectionValide;

    for m := imesdebutselection to imesfinselection do
           Mesures[m].CopieSelectionToPressePapier(PP);

End;




Function TCompositionAvecGestionSelection.Coller(PP: TMesure; m: integer; temps: TRationnel): integer;
{Colle le contenu de PP, dans la mesure numéro m, au temps temps
 temps au début d'une mesure = 1/1 }
var v, n_v, i: integer;
    //temps_initial: TRationnel;
   // m_initial, j: integer;
    //el: TElMusical;
Begin

{$IF Defined(PRECOND)}
  if IndiceMesureValide(m) then MessageErreur('Coller : m incorrect');

{$IFEND}


     for v := 0 to high(PP.Voix) do
     Begin
           n_v := PP.Voix[v].N_Voix;

           i := prtgMesures(m).VoixNum(n_v).IndiceSurTemps(temps);

           prtgMesures(m).VoixNum(n_v).InsererContenuVoix(i, PP.Voix[v], false);
     end;


   {  m_initial := m;
     temps_initial := temps;

    for v := 0 to high(PP.Voix) do
     Begin
           n_v := PP.Voix[v].N_Voix;
           m := m_initial;
           temps := temps_initial;
           i := prtgMesures(m).VoixNum(n_v).IndiceSurTemps(temps_initial);

           for j := 0 to high(PP.Voix[v].ElMusicaux) do
           Begin
                if IsQ1InfQ2(QAdd(prtgMesures(m).NbTempsEscomptes, Qel(1)), temps) then
                Begin
                    temps := QZero;
                    inc(m);
                    i := 0;
                End;

                el := PP.Voix[v].ElMusicaux[j];

                prtgMesures(m).VoixNum(n_v).AddElMusical(i, CopieElMusical(el));
                inc(i);

                QInc(temps, el.Duree);


           End;

     end;           }

     result := m;

{$IF Defined(POSTCOND)}
  if IndiceMesureValide(result) then MessageErreur('Coller : Retour de fonction incorrect');
           VerifierIntegriteMesure(m, 'coller');
{$IFEND}
End;




Procedure TCompositionAvecGestionSelection.CollerEnInversant(PP: TMesure; m: integer; temps: TRationnel);
{fait la même chose que Coller mais en copiant à l'envers}
var v, n_v, i: integer;

Begin
     for v := 0 to high(PP.Voix) do
     Begin
           n_v := PP.Voix[v].N_Voix;

           i := prtgMesures(m).VoixNum(n_v).IndiceSurTemps(temps);

           prtgMesures(m).VoixNum(n_v).InsererContenuVoix(i, PP.Voix[v], true {on spécifie qu'on inverse});
     end;
End;


Procedure TCompositionAvecGestionSelection.CollerGrosAccord(PP: TMesure; m: integer; temps: TRationnel);
{fait la même chose que Coller mais en mettant tout dans des gros accords}
var v, n_v, i: integer;
    nv_el: TElMusical;

Begin
     for v := 0 to high(PP.Voix) do
     Begin
           n_v := PP.Voix[v].N_Voix;

           i := prtgMesures(m).VoixNum(n_v).IndiceSurTemps(temps);

           nv_el := PP.Voix[v].CreerElMusicalGrosAccord;
           nv_el.SelectionnerElMusical;
           nv_el.Selection_Valider;

           prtgMesures(m).VoixNum(n_v).AddElMusical(i, nv_el);
     end;
End;



Procedure TCompositionAvecGestionSelection.Selection_DeplacerNotesSelectionneesPortee(chgtrel: integer);
var m, v, i, n,
    newportee, posabs        : integer;
    Tps: TDuree;
Begin
For m := imesdebutselection to imesfinselection do
    For v := 0 to high(Mesures[m].Voix) do
           For i := 0 to high(Mesures[m].Voix[v].ElMusicaux) do
                With Mesures[m].Voix[v].ElMusicaux[i] do
                Begin
                      Tps := Mesures[m].Voix[v].SurTemps(i);

                      If IsSilence and IsSelectionne then
                      Begin
                         newportee :=  position.portee + chgtrel;

                          if (newportee >= 0) and
                             (newportee <= high(PorteesGlobales)) then
                               position.portee := newportee;

                      End
                      else
                      for n := 0 to high(Notes) do
                               if Notes[n].Selectionne <> svDeSelectionnee then
                               Begin
                                      newportee :=  Notes[n].position.portee + chgtrel;

                                      if (newportee >= 0) and
                                         (newportee <= high(PorteesGlobales)) then
                                      Begin
                                           posabs := HauteurGraphiqueToHauteurAbs(
                                           InfoClef_Detecter(Notes[n].position.portee, m, Tps),
                                           Notes[n].position.hauteur);

                                           Notes[n].Position.Hauteur := HauteurAbsToHauteurGraphique(
                                                    InfoClef_Detecter( newportee,m, Tps),
                                                    posabs);

                                           Notes[n].Position.Portee := newportee;
                                      end;
                                      
                               end;
                 end;


End;


Procedure TCompositionAvecGestionSelection.Selection_FaireSubSelection(info: integer);
{Faire une sous-sélection
    info = 0 : que les note du bas
    info = 1, que les note du haut
}

var m, v, i, n: integer;

Begin
For m := imesdebutselection to imesfinselection do
    For v := 0 to high(Mesures[m].Voix) do
           For i := 0 to high(Mesures[m].Voix[v].ElMusicaux) do
                With Mesures[m].Voix[v].ElMusicaux[i] do
                Begin
                      if IsSelectionne and not IsSilence then
                      Begin
                         if info = 0 then  //on ne retient que la note du bas
                         Begin
                                Notes[0].Selectionne := svSelectionnee;
                                for n := 1 to high(Notes) do
                                   Notes[n].Selectionne := svDeSelectionnee;
                         end
                         else
                         Begin    //on ne retient que la note du haut
                              Notes[high(Notes)].Selectionne := svSelectionnee;
                              for n := 0 to high(Notes)-1 do
                                    Notes[n].Selectionne := svDeSelectionnee;
                         End;

                      End;
                End;

End;




procedure TCompositionAvecGestionSelection.Selection_FaireSubSelectionQueVoixNum(voix_num: integer);
var m, v, i : integer;

Begin
For m := imesdebutselection to imesfinselection do
    For v := 0 to high(Mesures[m].Voix) do
    With Mesures[m].Voix[v] do
    if voix_num <> n_voix then
    Begin

           For i := 0 to high(ElMusicaux) do
                ElMusicaux[i].Deselectionner;
    End;


End;



Procedure TCompositionAvecGestionSelection.Selection_FaireSubSelection1elmusSur2;
var compteur,
    m, v, i : integer;

Begin
For m := imesdebutselection to imesfinselection do
    For v := 0 to high(Mesures[m].Voix) do
    Begin
           compteur := 0;

           For i := 0 to high(Mesures[m].Voix[v].ElMusicaux) do
                With Mesures[m].Voix[v].ElMusicaux[i] do
                Begin
                      if IsSelectionne then
                      Begin
                          if compteur mod 2 = 1 then
                                 Deselectionner;

                          inc(compteur);

                      End;
                End;
    End;
End;




Function TCompositionAvecGestionSelection.Selection_HauteurNotePremiereNote_Get(var hn: THauteurNote): Boolean;
{renvoie vrai ssi la sélection contient une note
 si renvoie vrai alors hn = hauteur note de la première note sélectionnée rencontrée
 sinon, hn := hn0}

var m, v, i, n: integer;

Begin
     result := false;
     hn := hn0;

    For m := imesdebutselection to imesfinselection do
    For v := 0 to high(Mesures[m].Voix) do
           For i := 0 to high(Mesures[m].Voix[v].ElMusicaux) do
                With Mesures[m].Voix[v].ElMusicaux[i] do
                     if Not IsSilence then
                         for n := 0 to NbNotes - 1 do
                                 if IsNoteSelectionnee(n) then
                                       Begin
                                           hn := GetNote(n).HauteurNote;
                                           result := true;
                                           exit;
                                       End;


                     


End;

Procedure TCompositionAvecGestionSelection.Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(m:integer);
{indique que la mesure m contient des el. mus. sélectionnés}
Begin
 if imesdebutselection > m then
      imesdebutselection := m;

 if imesfinselection < m then
      imesfinselection := m;

                   //post-conditions
      Selection_VerifierSelectionValide;
End;







procedure TCompositionAvecGestionSelection.PaginerApresModifSelection(optimisation_calculer_graphe_info_verticalite_notes: Boolean);
{on pagine à partir de l'endroit où on a modifié quelque chose}
Begin
      if Selection_IsToutDeselectionner then
            MessageErreur('PaginerApresModifSelection alors que tout est désélectionné')
      else
          Paginer(LigneAvecMes(imesdebutselection),
                  LigneAvecMes(imesfinselection),
                  optimisation_calculer_graphe_info_verticalite_notes);
End;


Function TCompositionAvecGestionSelection.DelMesure(m: integer): Boolean;
{supprime la mesure d'indice m

 la propriété "imesfinselection in [-1, high(Mesures)]" reste conservée}
var hmes:integer;
Begin
      result := inherited DelMesure(m);
      hmes := high(Mesures);

      if imesfinselection > hmes then
            imesfinselection := hmes;


            //post-conditions
      Selection_VerifierSelectionValide;


end;


Function TCompositionAvecGestionSelection.Selection_Get_Ancre_Position: TPoint;
var m, v, i : integer;
    y_el : integer;
    p: TPoint;

Begin
    if Selection_IsToutDeselectionner then
         MessageErreur('précondition dans Get_Selection_Ancre_Position fait flop : ya rien de sélectionner !');

    p.x := 10000;
    p.y := 10000;

    m := Selection_GetIMesDebutSelection;
    IGP := self;
    IGiLigne := LigneAvecMes(m);
    With Mesures[m] do
    Begin
        For v := 0 to high(Voix) do
        With Voix[v] do
        Begin
               For i := 0 to high(ElMusicaux) do
                    With ElMusicaux[i] do
                    Begin
                          if IsSelectionne then
                          Begin
                              if p.x > pixx then p.x := pixx;
                              y_el := Y_Haut_InRepMesure;

                              if p.y > y_el then p.y := y_el;



                          End;
                    End;
        End;

        inc(p.x, pixX);
        inc(p.Y, Lignes[IGiLigne].pixy); 

    End;

    result := p;

End;





Function TCompositionAvecGestionSelection.Selection_PorteeApprox: integer;
var m, v, i: integer;
Begin
    result := -1;

    for m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
       for v := 0 to high(Mesures[m].Voix) do
            for i := 0 to high(Mesures[m].Voix[v].ElMusicaux) do
            With Mesures[m].Voix[v].ElMusicaux[i] do
            if IsSelectionne then
            Begin
                result := ExtrairePartieSelectionnee.PorteeApprox;
                exit;
            End;
End;

Function TCompositionAvecGestionSelection.Selection_Instrument_Portee_Get: integer;
label fini;

var m, v, i, ip, ip1_possible: integer;

      Function ipFaitPartiDelinstrumentip1_possible: Boolean;
      Begin
          result := ip in [ip1_possible, ip1_possible + Portee_GetNbPorteesInGroupe(ip1_possible)];
      End;




Begin
    ip1_possible := -1;
            
    for m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
       for v := 0 to high(Mesures[m].Voix) do
            for i := 0 to high(Mesures[m].Voix[v].ElMusicaux) do
            With Mesures[m].Voix[v].ElMusicaux[i] do
            if IsSelectionne then
            Begin
                  ip := PorteeApprox;

                  if ip1_possible = -1 then
                      ip1_possible := Portee_Groupe_PremierePortee(ip)
                  else
                  if not ipFaitPartiDelinstrumentip1_possible then
                  Begin
                      ip1_possible := -1;
                      goto fini;
                  End;
            End;



fini:
     result := ip1_possible;

End;



procedure TCompositionAvecGestionSelection.Selection_Valider;
var m, m_min, m_max: integer;
Begin
            if Selection_IsToutDeselectionner then exit;
            
            m_min := Selection_Getimesfinselection+1;
            m_max := Selection_Getimesdebutselection-1;

            for m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
            Begin
                   if Mesures[m].Selection_Valider then
                   Begin
                        m_min := min(m, m_min);
                        m_max := max(m, m_max);
                   End;
            End;

            if m_min > m_max then
            Begin
                imesdebutselection := 0;
                imesfinselection := -1;
            End
            else
            Begin
                imesdebutselection := m_min;
                imesfinselection := m_max;
            End;

End;

     
end.
