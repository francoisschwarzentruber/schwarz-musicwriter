unit MusicSystem_Composition;
{interface TComposition qui utilise l'outil d'annulation}


interface

uses cancellation, QSystem,
     MusicSystem_CompositionGestionBarresDeMesure {pour TBarreTypes},
     MusicSystem_Composition_I_Portees,
     MusicHarmonie, Classes;


type TComposition = class(TComposition_I_Portees)


     procedure I_Mesures_Ajouter_Mesure_Vide(m: integer; blabla: string);
     Function I_Mesures_Mettre_Barre_De_Mesures_Et_GetFinMes(m1, m2: integer;
                                                              rythme: TRationnel): integer;


     procedure I_Mesures_Tonalite_Set(m1, m2: integer; tonalite: TTonalite);
     procedure I_Mesures_Rythme_Set(m1, m2: integer; rythme: TRationnel);
     procedure I_Mesures_Metronome_Set(m1, m2: integer; metronome: integer);

     procedure I_BarreDeMesure_Set(m: integer; barre_type: TBarreType);

     procedure I_Selection_Supprimer(blabla : string);

     procedure I_Selection_Duree_Approximative_SwitchTo;
     procedure I_Selection_ChangerRythme(duree: TRationnel);
     procedure I_Selection_ChangerDuree(duree: TRationnel);
     
     procedure I_Selection_Deplacer_Voix(iVoix_Ou_On_Deplace: integer);

     procedure I_Selection_FusionnerNotesEtSilences;
     procedure I_Selection_DureesDiviserParDeuxPuisSilence;

     procedure I_Selection_Attributs_Supprimer;
     procedure I_Selection_Attributs_Appliquer(attrib: integer);

     procedure I_Selection_Notes_Taille_Set(petites_notes: Boolean);
     procedure I_Selection_Trilles_Supprimer;
     procedure I_Selection_Trilles_Appliquer(attrib: integer);

     procedure I_BarreDeMesure_Ajouter(m: integer; temps: TRationnel; blabla: string);


     procedure I_Instruments_Supprimer(ip: integer);
     procedure I_Instruments_DeplacerVersLeHaut(ip: integer);
     procedure I_Instruments_DeplacerVersLeBas(ip: integer);

     procedure I_Instruments_Ajouter_Instrument_Une_Portee(ip: integer; instru: integer);
     procedure I_Instruments_Ajouter_Instrument_Portees_Clavier(ip: integer; instru: integer);


     procedure I_Instruments_Portee_Ajouter(instru_ip, ip: integer);
     procedure I_Instruments_Portee_Supprimer(instru_ip, ip: integer);

     procedure I_Instruments_Instrument_Num_Set(ip: integer; instru_num: integer);
     procedure I_Instruments_Nom_Set(ip: integer; instru_nom: string);

     procedure I_Instruments_VoixListe_TString(ip_instru: integer; s: TStrings);

     procedure Durees_Deviner(m: integer);

     procedure I_Selection_Duree_Inferer;
End;





















implementation


uses SysUtils, MusicSystem_CompositionBase,
  MusicSystem_Composition_Portees_Liste,
  MusicSystem_CompositionListeObjetsGraphiques {inttostr},
  MusicWriter_Erreur, MusicSystem_ElMusical,
  MusicSystem_Voix, MusicSystem_MesureBase, MusicSystem_Mesure,
  MusicSystem_CompositionAvecSelection,
  MusicSystem_CompositionAvecPagination,
  TimerDebugger,
  instruments ,
  Interface_Questions,
  QSystem_Inference, MusicSystem_ElMusical_Liste_Notes
  ;


  

procedure TComposition.I_Mesures_Ajouter_Mesure_Vide(m: integer; blabla: string);
Begin
      Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, m);
      Cancellation_Etape_Ajouter_FinDescription('Ajout d''une mesure ' + blabla,
                                                'mesure n° ' + inttostr(m + 1),
                                                VOIX_PAS_D_INFORMATION);

      AddMesureVide(m);
      PaginerLaMesureEtApresSiBesoin(m, false);   //A REVOIR
End;



Function TComposition.I_Mesures_Mettre_Barre_De_Mesures_Et_GetFinMes(m1, m2: integer; rythme: TRationnel): integer;
Begin
    Selection_ToutDeselectionner;
    result := BarresMesuresMettre(m1, m2, Rythme);


    PaginerApartirMes(m1, true);


    Cancellation_Etape_Ajouter_FinDescription('Modification du rythme des mesures' +
                            ' et placement des barres',
                            'mes. n°'
                            + inttostr(m1) + ' à n°' +
                            inttostr(result),
                            VOIX_PAS_D_INFORMATION);
End;





procedure TComposition.I_BarreDeMesure_Set(m: integer; barre_type: TBarreType);
Begin
    Cancellation_PushMiniEtapeAAnuller_ModificationBarreMesure_Type
             (m,
              barre_type);

    Cancellation_Etape_Ajouter_FinDescription('Modification de la barre de mesures de la mesure n° ' +
                       inttostr(m) + ' : ' + BarreTypeToStr(BarreDeMesure_Get(m)) +
                       ' => ' + BarreTypeToStr(barre_type), '',
                       VOIX_PAS_D_INFORMATION);

    BarreDeMesure_Set(m, barre_type);
End;



procedure TComposition.I_Selection_Supprimer(blabla : string);
{Supprime la sélection en gérant l'annulation etc.
 blabla = texte additionnel pour l'annulation justement !}

var m1, m2: integer;
Begin
    Cancellation_Etape_Ajouter_Selection(blabla);
    m1 := Selection_Getimesdebutselection;
    m2 := Selection_Getimesfinselection;


    Selection_Supprimer;
    TimerDebugger_FinEtape('Selection_Supprimer');

    PaginerLesMesuresEtApresSiBesoin(m1, m2, true);
    TimerDebugger_FinEtape('PaginerLesMesuresEtApresSiBesoin');
End;



procedure TComposition.I_Selection_ChangerRythme(duree: TRationnel);
Begin
    I_Selection_ChangerDuree(duree);


End;



procedure TComposition.I_Selection_ChangerDuree(duree: TRationnel);
var m, v, i: integer;
    t: TRationnel;
Begin
    Cancellation_Etape_Ajouter_Selection('changement de rythme : toute les notes durent ' + QToStr(duree) );

            
            For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
            With GetMesure(m) do
            Begin
                  For v := 0 to high(Voix) do
                  Begin
                         t := QEl(0);

                         For i := 0 to high(Voix[v].ElMusicaux) do
                         Begin
                                if Voix[v].ElMusicaux[i].IsSelectionne then
                                Begin
                                    Voix[v].ElMusicaux[i].Duree_Approximative_SwitchTo;
                                    RegleMesure_Etirer(t, QAdd(t, Voix[v].ElMusicaux[i].Duree_Get),
                                                          QAdd(t, duree));

                                    Voix[v].ElMusicaux[i].Duree_Fixee_Set(duree);

                                End;
                                t := QAdd(t, Voix[v].ElMusicaux[i].Duree_Get);
                         End;
                  End;
                  //Durees_Inferences_Inferer;
            End;

            //Interface_Questions_Afficher;

End;


procedure TComposition.I_Selection_Duree_Approximative_SwitchTo;
var m, v, i: integer;
Begin
    Cancellation_Etape_Ajouter_Selection('changement de rythme : notes avec durées approximatives !');

            For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
            With GetMesure(m) do
                  For v := 0 to high(Voix) do
                         For i := 0 to high(Voix[v].ElMusicaux) do
                                        if Voix[v].ElMusicaux[i].IsSelectionne then
                                        Begin
                                            Voix[v].ElMusicaux[i].Duree_Approximative_SwitchTo;

                                        End;

            PaginerApresModifSelection(false);

End;

procedure TComposition.I_Selection_Attributs_Supprimer;
var m, v, i: integer;
Begin
    Cancellation_Etape_Ajouter_Selection('Suppression des attributs');
    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    With GetMesure(m) do
          For v := 0 to high(Voix) do
             For i := 0 to high(Voix[v].ElMusicaux) do
                  if Voix[v].ElMusicaux[i].IsSelectionne then
                        Voix[v].ElMusicaux[i].attributs.Style1 := 0;
End;



procedure TComposition.I_Selection_Attributs_Appliquer(attrib: integer);
var m, v, i: integer;
Begin
     Cancellation_Etape_Ajouter_Selection('Modification d''attribut');
     For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
        With GetMesure(m) do
              For v := 0 to high(Voix) do
                 For i := 0 to high(Voix[v].ElMusicaux) do
                      if Voix[v].ElMusicaux[i].IsSelectionne then
                            Voix[v].ElMusicaux[i].SetAttrib(attrib, true);

End;




procedure TComposition.I_Selection_Trilles_Supprimer;
var m, v, i: integer;
Begin
    Cancellation_Etape_Ajouter_Selection('Suppression des attributs');
    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    With GetMesure(m) do
          For v := 0 to high(Voix) do
             For i := 0 to high(Voix[v].ElMusicaux) do
                  if Voix[v].ElMusicaux[i].IsSelectionne then
                        Voix[v].ElMusicaux[i].attributs.Style2 := 0;
End;



procedure TComposition.I_Selection_Trilles_Appliquer(attrib: integer);
var m, v, i: integer;
Begin
     Cancellation_Etape_Ajouter_Selection('Modification d''attribut');
     For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
        With GetMesure(m) do
              For v := 0 to high(Voix) do
                 For i := 0 to high(Voix[v].ElMusicaux) do
                      if Voix[v].ElMusicaux[i].IsSelectionne then
                            Voix[v].ElMusicaux[i].attributs.Style2 := attrib;
End;



procedure TComposition.I_Selection_Deplacer_Voix(iVoix_Ou_On_Deplace: integer);
var m, v, i: integer;
    duree_depuis_debut_mesure: TRationnel;
    el_insere: TElMusical;
    Voix_Ou_On_Deplace: TVoix;


Begin
                                       
    Cancellation_Etape_Ajouter_Selection('Déplacement de la sélection vers la voix');

    Cancellation_Etape_Ajouter_Selection('Déplacement de la sélection vers la voix');



    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    With GetMesure(m) do
    Begin
          Voix_Ou_On_Deplace := VoixNum(iVoix_Ou_On_Deplace);

          For v := 0 to high(Voix) do
          With Voix[v] do
          Begin
                 duree_depuis_debut_mesure := Qel(0);
                 For i := 0 to high(ElMusicaux) do
                 With ElMusicaux[i] do
                 Begin
                          if IsSelectionne then
                          Begin
                               el_insere := ExtrairePartieSelectionnee;
                               Notes_Selectionnees_Supprimer;
                               Voix_Ou_On_Deplace.Inserer_CopieElMusical_AuTemps(duree_depuis_debut_mesure,
                                                                                 el_insere);
                               el_insere.Free;
                          End;
                          QInc(duree_depuis_debut_mesure, Duree_Get);
                 End;
          End;

//          NoteSilence_Fusionner_Si_SilenceCourt;  //SERT A RIEN
          SimplifierEcriture;
    End;

    PaginerApresModifSelection(true);

    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
           With GetMesure(m) do
                  Durees_Deviner(m);

End;






procedure TComposition.I_Selection_FusionnerNotesEtSilences;
var m, v, i: integer;

Begin
     Cancellation_Etape_Ajouter_Selection('Alonger les notes avec les silences');


    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    With GetMesure(m) do
    Begin

          For v := 0 to high(Voix) do
          With Voix[v] do
          Begin

                 i := 0;

                 While ( i < high(ElMusicaux) ) do
                 Begin
                       With ElMusicaux[i] do
                       if IsSelectionne then
                       Begin
                                if ElMusicaux[i+1].IsSilence and ElMusicaux[i+1].IsSelectionne then
                                Begin
                                     ElMusicaux[i].Duree_Set(QAdd(ElMusicaux[i].Duree_Get, ElMusicaux[i+1].Duree_Get));
                                     DelElMusical(i+1);
                                     dec(i);

                                End;
                       End;

                       inc(i);
                 End;
          End;


          SimplifierEcriture;
    End;

    PaginerApresModifSelection(true);
End;



procedure TComposition.I_Selection_DureesDiviserParDeuxPuisSilence;
var m, v, i: integer;
    duree: TRationnel;
    silencequonajoute: TElMusical;

Begin
     Cancellation_Etape_Ajouter_Selection('Diviser la durée par deux et ajouter des silences');


    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    With GetMesure(m) do
    Begin

          For v := 0 to high(Voix) do
          With Voix[v] do
          Begin

                 i := 0;

                 While ( i <= high(ElMusicaux) ) do
                 Begin
                       With ElMusicaux[i] do
                       if not IsSilence then
                       if IsSelectionne then
                       Begin
                                duree := Duree_Get;
                                ElMusicaux[i].Duree_Set(QDiv2(duree));
                                silencequonajoute := CreerElMusicalPause(QDiv2(duree), ElMusicaux[i].PorteeApprox);
                                silencequonajoute.SelectionnerElMusical;
                                silencequonajoute.Selection_Valider;
                                AddElMusical(i+1, silencequonajoute);

                       End;
                       inc(i);
                 End;
          End;


          SimplifierEcriture;
    End;

    PaginerApresModifSelection(true);
End;

procedure TComposition.I_BarreDeMesure_Ajouter(m: integer; temps: TRationnel; blabla: string);
Begin
    BarreMesureAjouter(m, temps);
    GetMesure(m).Nettoyer;
    GetMesure(m).Durees_Inferences_EtirerAuRythmeMesure_Et_Inferer;

   // Durees_Deviner(m);
    //Interface_Questions_Afficher;

    Cancellation_Etape_Ajouter_FinDescription('Ajout d''une barre de mesure' + blabla,
                       'mes. n°' + inttostr(m + 1) + ', temps ' + QToStr(temps),
                       VOIX_PAS_D_INFORMATION);
    PaginerApartirMes(m, true);
End;


procedure TComposition.I_Selection_Duree_Inferer;
var m: integer;
Begin
    for m :=  Selection_GetIMesDebutSelection to Selection_GetIMesFinSelection do
         Durees_Deviner(m);

    Interface_Questions_Afficher;
End;







procedure TComposition.I_Instruments_Supprimer(ip: integer);
var p1, p2: integer;
Begin
    Cancellation_Reset;

    p1 := ip;
    p2 := ip + Portee_GetNbPorteesInGroupe(ip);
    for ip := p1 to p2 do
            Portee_Supprimer(p1);

    Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);

End;





procedure TComposition.I_Instruments_DeplacerVersLeHaut(ip: integer);

    Function Instrument_Avant_Get:integer;
    var i, i_last: integer;
    Begin
         i := 0;
         i_last := -1;
         
         while(i<ip) do
         Begin
               i_last := i;
               Inc(i, Portee_GetNbPorteesInGroupe(i) + 1);
         End;

         result := i_last;
    End;


var p1, p2: integer;
    instru_avant : integer;


Begin

    if ip <= 0 then
           MessageErreur('I_Instruments_DeplacerVersLeHaut, erreur d''entrée')
    else
    Begin
          Cancellation_Reset;
          instru_avant := Instrument_Avant_Get;

          p1 := ip;
          p2 := ip + Portee_GetNbPorteesInGroupe(ip);

          Portees_Deplacer(p1, p2, instru_avant);


          Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);
    End;
End;



procedure TComposition.I_Instruments_DeplacerVersLeBas(ip: integer);
var p1, p2, instru_apres: integer;
Begin
    p1 := ip;
    p2 := ip + Portee_GetNbPorteesInGroupe(ip);

    if p2 >= high(PorteesGlobales) then
           MessageErreur('I_Instruments_DeplacerVersLeBas, erreur d''entrée')
    else
    Begin
          ;
          Cancellation_Reset;
          instru_apres := p2 + 1 + Portee_GetNbPorteesInGroupe(p2 + 1) + 1;




          Portees_Deplacer(p1, p2, instru_apres);


          Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);
    End;
End;





procedure TComposition.I_Instruments_Ajouter_Instrument_Une_Portee(ip: integer; instru: integer);
Begin
     Cancellation_Reset;
     Portee_Ajouter(ip, instru, ClefSol);
     Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);
End;


procedure TComposition.I_Instruments_Ajouter_Instrument_Portees_Clavier(ip: integer; instru: integer);
Begin
    Cancellation_Reset;
    
    Portee_Ajouter(ip, instru, ClefSol);
    Portee_Ajouter(ip + 1, instru, ClefFa);

    Portees_Accolade_Mettre(ip, ip + 1);

    Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);
End;



procedure TComposition.I_Instruments_Instrument_Num_Set(ip: integer; instru_num: integer);
var p, p2: integer;
    ancien_num: integer;
    
Begin
    ancien_num := Portee_InstrumentMIDINum[ip];

    p2 := ip + Portee_GetNbPorteesInGroupe(ip);
    for p := ip to p2 do
    Begin
          Cancellation_PushMiniEtapeAAnuller_ModificationPorteeProprietesSimples(p);
          Portee_InstrumentMIDINum[p] := instru_num;
    End;

    Cancellation_Etape_Ajouter_FinDescription('Changement d''instrument : "' + GetInstrumentNom(ancien_num)
                                              + '" devient "' + GetInstrumentNom(instru_num) + '"',
                                              'portées ' + inttostr(ip + 1) + ' à ' + inttostr(p2 + 1),
                                          VOIX_PAS_D_INFORMATION);

End;



procedure TComposition.I_Instruments_Nom_Set(ip: integer; instru_nom: string);
var p, p2: integer;
    ancien_nom: string;
Begin
    ancien_nom := Portee_Nom[ip];
    
    p2 := ip + Portee_GetNbPorteesInGroupe(ip);
    for p := ip to p2 do
    Begin
          Cancellation_PushMiniEtapeAAnuller_ModificationPorteeProprietesSimples(p);
          Portee_Nom[p] := instru_nom;
    End;
    Cancellation_Etape_Ajouter_FinDescription('L''instrument change de nom : "' + ancien_nom + '" devient "' + instru_nom + '"',
                                          'portées ' + inttostr(ip + 1) + ' à ' + inttostr(p2 + 1),
                                          VOIX_PAS_D_INFORMATION);
End;





procedure TComposition.I_Instruments_Portee_Ajouter(instru_ip, ip: integer);
Begin
      Cancellation_Reset;
      Portee_Ajouter(ip, Portee_InstrumentMIDINum[instru_ip], ClefSol);

      if ip = instru_ip then
      Begin
           PorteesGlobales[ip].nbPorteesGroupe := PorteesGlobales[ip+1].nbPorteesGroupe + 1;
           PorteesGlobales[ip].typeAccolade := taAccolade;
           PorteesGlobales[ip+1].typeAccolade := taRien;

      End
      else
           inc(PorteesGlobales[instru_ip].nbPorteesGroupe);

      Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);

End;



procedure TComposition.I_Instruments_Portee_Supprimer(instru_ip, ip: integer);
var n: integer;
Begin
     Cancellation_Reset;

     if ip = instru_ip then
     Begin
         n := PorteesGlobales[instru_ip].nbPorteesGroupe;
         Portee_Supprimer(ip);
         PorteesGlobales[instru_ip].nbPorteesGroupe := n - 1;

         if PorteesGlobales[instru_ip].nbPorteesGroupe > 0 then
                PorteesGlobales[instru_ip].typeAccolade := taAccolade
         else
                PorteesGlobales[instru_ip].typeAccolade := taRien;


     End
     else
     Begin
         Portee_Supprimer(ip);
         dec(PorteesGlobales[instru_ip].nbPorteesGroupe);

         if PorteesGlobales[instru_ip].nbPorteesGroupe = 0 then
               PorteesGlobales[instru_ip].typeAccolade := taRien;
     End;

     
     Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN, true);
     
End;




procedure TComposition.I_Mesures_Tonalite_Set(m1, m2: integer; tonalite: TTonalite);
var im: integer;
Begin
    for im := m1 to m2 do
         Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, im);

    for im := m1 to m2 do
         prtgMesures(im).SetTonalite(tonalite);

    Cancellation_Etape_Ajouter_FinDescription('Changer la tonalité : ' + TonaliteToStr(tonalite),
                                      'mes. n° ' +
                                      inttostr(m1+1) +
                                      ' à ' +
                                      inttostr(m2+1),
                                       VOIX_PAS_D_INFORMATION );

    CalcTout(false);
End;



procedure TComposition.I_Mesures_Rythme_Set(m1, m2: integer; rythme: TRationnel);
var im: integer;
Begin
    for im := m1 to m2 do
         Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, im);

    for im := m1 to m2 do
         prtgMesures(im).Rythme := rythme;

    Cancellation_Etape_Ajouter_FinDescription('Changer le rythme des mesures n°  : ' + QToStr(rythme),
                                      'mes. n°' + inttostr(m1+1) +
                                      ' à ' +
                                      inttostr(m2 + 1),
                                      VOIX_PAS_D_INFORMATION);

    CalcTout(false);

End;


procedure TComposition.I_Mesures_Metronome_Set(m1, m2: integer; metronome: integer);
var im: integer;
Begin
    for im := m1 to m2 do
         Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, im);

    for im := m1 to m2 do
         prtgMesures(im).Metronome := metronome;

    Cancellation_Etape_Ajouter_FinDescription('Changer le métronome  : ' + inttostr(metronome),
                                      'mes. n°' + inttostr(m1 + 1) +
                                      ' à ' +
                                      inttostr(m2 + 1),
                                      VOIX_PAS_D_INFORMATION);

    CalcTout(false);

End;






procedure TComposition.I_Selection_Notes_Taille_Set(petites_notes: Boolean);
var m, v, i: integer;
Begin
    Cancellation_Etape_Ajouter_Selection('Modification de la taille de notes');
    For m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
    With GetMesure(m) do
          For v := 0 to high(Voix) do
             For i := 0 to high(Voix[v].ElMusicaux) do
                   with Voix[v].ElMusicaux[i] do
                        if IsSelectionne then
                             attributs.PetitesNotes := petites_notes;


End;






procedure TComposition.I_Instruments_VoixListe_TString(ip_instru: integer; s: TStrings);
const nbvoixparportee = 4;
var ip, j: integer;
Begin
    for ip := ip_instru to ip_instru + Portee_GetNbPorteesInGroupe(ip_instru) do
        if not Portee_IsTablature(ip) then
        for j := 0 to nbvoixparportee-1 do
             s.Add(inttostr(ip + j * NbPortees)); 
End;

procedure TComposition.Durees_Deviner(m: integer);
var v, i: integer;
    r: array[0..0] of Trationnel;

Begin
    Interface_Questions_Reset;

    With GetMesure(m) do
    for v := 0 to high(Voix) do
    With Voix[v] do
          if N_Voix >= 0 then
          for i := 0 to high(Elmusicaux) do
          if ElMusicaux[i].Duree_IsApproximative then
          Begin
                 r[0] := QTrouverFractionSimpleProche(ElMusicaux[i].Duree_Get)[1].q;
                 Interface_Questions_RegleMesure_AjouterQuestion(m,
                                                                 N_Voix,
                                                                 i, i, r);
          End;
End;
end.
