unit cancellation;

interface

uses MusicSystem, MusicSystem_Mesure,
      MusicSystem_CompositionGestionBarresDeMesure {pour TBarreType},
      MusicSystem_Composition_Portees_Liste {pour TPorteGlobale},
      QSystem,
      StdCtrls {pour ListBox};


const nbEtapesAnnulationMax = 40;


const VOIX_PAS_D_INFORMATION = -1;


type TTypAnnulation = (taSupprimerMes, taRemplacerMes, taAjouterMes, taModifierBarreMesureType,
                       taModificationProprietesSimplesPortee,
                       taOctavieur_Supprimer,
                       taOctavieur_Ajouter);


type TAnnulationStep = record
          str: string;
          localisation: string;
          ivoix: integer;

          typ: TTypAnnulation;
           {si typ = taAjouterMes,
           et qu'on annule, alors le programme doit virer la mesure}

          imes: integer;
          Mesure: TMesure;

          action_modifier_barremesure_type_barre_avant,
          action_modifier_barremesure_type_barre_apres: TBarreType;


          action_modifier_portee_proprietes_simples_iportee: integer;
          action_modifier_portee_proprietes_simples_portee_info: TPorteeGlobale;

          action_octavieur_iportee: integer;
          action_octavieur_temps: TRationnel;
          action_octavieur_combien: integer;
          action_octavieur_indice: integer;

End;
type TAnnulation = array of TAnnulationStep;





type TCompositionAvecCancellation = class(TComposition1)
    private
        EtapesAnnulation: array of TAnnulation;
        iEtapeAnnulation: integer;
        iMaxEtapeAnnulationCourant: integer;
        private_c_est_le_premier_push: Boolean;


        Procedure Cancellation_IncIndAnnul;
        Procedure Cancellation_DecIndAnnul;




        Function Cancellation_Pile_Is_Fond: Boolean;
        Function Cancellation_Pile_Is_Apres_Sommet: Boolean;

        Function Cancellation_Pile_Texte_Get: string;
        Function Cancellation_Pile_Voix_Information_Get: integer;

        Procedure Cancellation_PushMiniEtapesSurSelectionAnnuler;


    public //normalement il faudrait un jour mettre ça en protected



        Procedure Cancellation_Etape_Ajouter_FinDescription(s, localisation: string; ivoix: integer);


        Procedure Cancellation_PushMiniEtapeAAnnuler(typannul: TTypAnnulation; m: integer);

        procedure Cancellation_PushMiniEtapeAAnnuler_Octavieurs_Ajouter(
                      iportee, imesure: integer; temps: TRationnel; combien, indice: integer);

        procedure Cancellation_PushMiniEtapeAAnnuler_Octavieurs_Supprimer(
                      iportee, imesure: integer; temps: TRationnel; combien, indice: integer);



    protected
        procedure Cancellation_PushMiniEtapeAAnuller_ModificationPorteeProprietesSimples(
                    iportee: integer);

        procedure Cancellation_PushMiniEtapeAAnuller_ModificationBarreMesure_Type(
                    m: integer;
                    barretype_nouveau: TBarreType);

     public
        Procedure Cancellation_Etape_Ajouter_Selection(s: string);




    public
        constructor Create;
        Procedure Cancellation_GererMenuAnnuler;
        Procedure Cancellation_Remplir_ListBox(lst: TListBox);

        Function Cancellation_Annuler_Texte: string;
        Function Cancellation_Refaire_Texte: string;


        Procedure Cancellation_Reset;
        Procedure Cancellation_Annuler;
        Procedure Cancellation_Refaire;
end;




var CompCancellationCourant: TCompositionAvecCancellation;
    CompCancellationiPorteeCourant: integer;


implementation


uses Main {pour avoir accès aux menus Annuler, Refaire...},
     MusicWriter_Erreur,
     Cancellation_Window ;















Procedure TCompositionAvecCancellation.Cancellation_Reset;
{initialise le moteur d'annulation}
var i,j:integer;
Begin
   {libère la mémoire éventuellement occupée}
    for i := 0 to high(EtapesAnnulation) do
    Begin
        for j := high(EtapesAnnulation[i]) downto 0 do
            EtapesAnnulation[i][j].Mesure.Free;
        Setlength(EtapesAnnulation[i], 0);
    End;



    {met à 0 le système d'annulation}
    Setlength(EtapesAnnulation, nbEtapesAnnulationMax);
    iEtapeAnnulation := 0;
    iMaxEtapeAnnulationCourant := 0;

    {met à jour le menu "annuler"}
    Cancellation_GererMenuAnnuler;


End;









constructor TCompositionAvecCancellation.Create;
Begin
    inherited Create;

    Cancellation_Reset;

End;








Procedure TCompositionAvecCancellation.Cancellation_IncIndAnnul;
Begin
     inc(iEtapeAnnulation);
     if iEtapeAnnulation >= nbEtapesAnnulationMax then
         iEtapeAnnulation := 0;
End;



Procedure TCompositionAvecCancellation.Cancellation_DecIndAnnul;
Begin
    dec(iEtapeAnnulation);

    if iEtapeAnnulation < 0 then
          iEtapeAnnulation := nbEtapesAnnulationMax-1;
End;











{Annuler / Refaire}

procedure EchangerPorteeGlobale(var p1_partition: TPorteeGlobale;
                                var p2: TPorteeGlobale);

var ptampon: TPorteeGlobale;
Begin
     ptampon := p1_partition;

     p1_partition := p2;
     p1_partition.Octavieurs_Liste := ptampon.Octavieurs_Liste;

     p2 := ptampon;
     p2.Octavieurs_Liste := nil;

End;

Procedure TCompositionAvecCancellation.Cancellation_Annuler;
{commande "annuler"}
var m: TMesure;
    imes_plus_petit: integer;
    i: integer;
Begin
    imes_plus_petit := 10000;
    Selection_ToutDeselectionner;
    Cancellation_DecIndAnnul;

    if high(EtapesAnnulation[iEtapeAnnulation]) = -1 then
    Begin
        Cancellation_IncIndAnnul;
        exit;
    End;

    for i := high(EtapesAnnulation[iEtapeAnnulation]) downto 0 do
       {oui, les actions sont effectué en sens contraire...}

         With EtapesAnnulation[iEtapeAnnulation][i] do
         Begin
              Case typ of
                    taRemplacerMes:
                    {on restaure l'état de la mesure précédente, stockée dans
                       EtapesAnnulation[iEtapeAnnulation][i].Mesure }
                    Begin
                          m := GetMesure(imes);
                          SetMesure(imes, Mesure);
                          Mesure := m;
                    End;

                    taSupprimerMes:
                    {on annule la suppression d'une mesure}
                    Begin
                          AddMesureVide(imes);
                    End;

                    taAjouterMes:
                    Begin
                          DelMesure(imes);
                    End;

                    taModifierBarreMesureType:
                          BarreDeMesure_Set(imes,
                                            action_modifier_barremesure_type_barre_avant);

                    taModificationProprietesSimplesPortee:
                           EchangerPorteeGlobale(PorteesGlobales[action_modifier_portee_proprietes_simples_iportee],
                                                 action_modifier_portee_proprietes_simples_portee_info);

                    taOctavieur_Ajouter:
                           PorteesGlobales[action_octavieur_iportee]
                            .Octavieurs_Liste.Supprimer(action_octavieur_indice);

                    taOctavieur_Supprimer:
                           PorteesGlobales[action_octavieur_iportee].Octavieurs_Liste
                              .Ajouter(imes, action_octavieur_temps, action_octavieur_combien);

                    else
                       MessageErreur('erreur dans l''opération "annuler" : type d''annulation incorrect.');

              End;
              imes_plus_petit := imes;

         End;

    PaginerAPartirMes(imes_plus_petit, true);

    Cancellation_GererMenuAnnuler;

End;

Procedure TCompositionAvecCancellation.Cancellation_Refaire;
{commande "refaire" (c'est l'inverse d' "annuler") }

var m: TMesure;
    i: integer;


Begin
    Selection_ToutDeselectionner;


    for i := 0 to high(EtapesAnnulation[iEtapeAnnulation]) do

         With EtapesAnnulation[iEtapeAnnulation][i] do
         Begin
              Case typ of
                    taRemplacerMes:
                    Begin
                          m := GetMesure(imes);
                          SetMesure(imes, Mesure);
                          Mesure := m;
                    End;

                    taSupprimerMes:
                    Begin
                          DelMesure(imes);
                    End;

                    taAjouterMes:
                    Begin
                          AddMesureVide(imes);
                    End;

                    taModifierBarreMesureType:
                          BarreDeMesure_Set(imes,
                                            action_modifier_barremesure_type_barre_apres);


                    taModificationProprietesSimplesPortee:
                           EchangerPorteeGlobale(PorteesGlobales[action_modifier_portee_proprietes_simples_iportee],
                                                 action_modifier_portee_proprietes_simples_portee_info); 


                    taOctavieur_Supprimer:
                           PorteesGlobales[action_octavieur_iportee].Octavieurs_Liste.Supprimer(action_octavieur_indice);

                    taOctavieur_Ajouter:
                           PorteesGlobales[action_octavieur_iportee].Octavieurs_Liste
                              .Ajouter(imes, action_octavieur_temps, action_octavieur_combien);

                    else
                       MessageErreur('erreur dans l''opération "refaire" : type d''annulation incorrect.');



              End;
              PaginerAPartirMes(imes, true);
         End;
    Cancellation_IncIndAnnul;
    Cancellation_GererMenuAnnuler;

End;













Function TCompositionAvecCancellation.Cancellation_Refaire_Texte: string;
Begin
    if iMaxEtapeAnnulationCourant = iEtapeAnnulation then
    Begin
         MessageErreur('erreur dans Cancellation_Refaire_Texte car ya rien à refaire');
         result := 'rien';
    End
    else
         result := EtapesAnnulation[iEtapeAnnulation][0].str;
End;

Function TCompositionAvecCancellation.Cancellation_Annuler_Texte: string;
Begin
    Cancellation_DecIndAnnul;
    if high(EtapesAnnulation[iEtapeAnnulation]) = -1 then
    Begin
         MessageErreur('erreur dans Cancellation_Annuler_Texte car ya rien à annuler');
         result := 'rien';
    End
    else
         result := EtapesAnnulation[iEtapeAnnulation][0].str;
    Cancellation_IncIndAnnul;
End;





Procedure TCompositionAvecCancellation.Cancellation_Remplir_ListBox(lst: TListBox);
var i, nb: integer;

Begin
     lst.Clear;
     
     nb := 1;
     Cancellation_DecIndAnnul;
     while not Cancellation_Pile_Is_Fond do
     Begin
          lst.Items.Insert(0, 'Annuler ' + Cancellation_Pile_Texte_Get);
          lst.Items.Objects[0] := TObject(Cancellation_Pile_Voix_Information_Get+1);
          Cancellation_DecIndAnnul;
          inc(nb);
     End;

     for i := 1 to nb do
         Cancellation_IncIndAnnul;


     lst.AddItem('-----------------(maintenant)-------------------', nil);
     lst.Tag := nb-1;

     nb := 0;
     while not Cancellation_Pile_Is_Apres_Sommet do
     Begin
          lst.AddItem('Refaire ' + Cancellation_Pile_Texte_Get, TObject(Cancellation_Pile_Voix_Information_Get+1));
          Cancellation_IncIndAnnul;
          inc(nb);
     End;


     for i := 1 to nb do
         Cancellation_DecIndAnnul;
End;



Function TCompositionAvecCancellation.Cancellation_Pile_Is_Fond: Boolean;
Begin
     result := (high(EtapesAnnulation[iEtapeAnnulation]) = -1);
End;

Function TCompositionAvecCancellation.Cancellation_Pile_Is_Apres_Sommet: Boolean;
Begin
     result := iMaxEtapeAnnulationCourant = iEtapeAnnulation;
End;


Function TCompositionAvecCancellation.Cancellation_Pile_Texte_Get: string;
Begin
     result := EtapesAnnulation[iEtapeAnnulation][0].str + #9 +
               EtapesAnnulation[iEtapeAnnulation][0].localisation;
End;


Function TCompositionAvecCancellation.Cancellation_Pile_Voix_Information_Get: integer;
Begin
     result := EtapesAnnulation[iEtapeAnnulation][0].ivoix;
End;



Procedure TCompositionAvecCancellation.Cancellation_GererMenuAnnuler;
{met à jour le menu "annuler"...

 ex : si on vient d'ajouter une note
       met en place la commande "annuler ajout de notes"}

       var Annuler_Texte, Refaire_Texte: string;
           Annuler_Enabled, Refaire_Enabled: Boolean;

Begin
    Cancellation_DecIndAnnul;

    Annuler_Enabled := not Cancellation_Pile_Is_Fond;

    if Annuler_Enabled then
            Annuler_Texte := 'Annuler ' + Cancellation_Pile_Texte_Get
    else
            Annuler_Texte := 'Rien à annuler';


    Cancellation_IncIndAnnul;


    Refaire_Enabled := not Cancellation_Pile_Is_Apres_Sommet;

    if Refaire_Enabled then
              Refaire_Texte := 'Refaire ' + Cancellation_Pile_Texte_Get
    else
              Refaire_Texte := 'Rien à refaire';



    MainForm.actionEditUndo.Enabled := Annuler_Enabled;
    MainForm.actionEditRedo.Enabled := Refaire_Enabled;

    MainForm.mnuCancel.Caption := Annuler_Texte;
    MainForm.tbnAnnuler.Hint := Annuler_Texte;

    MainForm.mnuRefaire.Caption := Refaire_Texte;
    MainForm.tbnRefaire.Hint := Refaire_Texte;

    IF frmCancellation_Window_IsVisible then
    With frmCancellation_Window do
    Begin
          lstOperations_MettreAJour;
          tbnAnnuler.Enabled := Annuler_Enabled;
          tbnRefaire.Enabled := Refaire_Enabled;
    End;
End;














Procedure TCompositionAvecCancellation.Cancellation_Etape_Ajouter_Selection(s: string);
Begin
    Cancellation_PushMiniEtapesSurSelectionAnnuler;
    Cancellation_Etape_Ajouter_FinDescription(s, Selection_GetDescription, VOIX_PAS_D_INFORMATION);
End;


Procedure TCompositionAvecCancellation.Cancellation_Etape_Ajouter_FinDescription(s, localisation: string; ivoix: integer);
var i:integer;
Begin
    if high(EtapesAnnulation[iEtapeAnnulation]) < 0 then
    {si l'étape en cours n'a rien à annuler}
    Begin
        MessageErreur('L''étape en cours n''a rien à annuler... C''est bizarre... mais pas très grave ! :)');
        exit;
    End;



    EtapesAnnulation[iEtapeAnnulation][0].str := s;
    EtapesAnnulation[iEtapeAnnulation][0].localisation := localisation;
    EtapesAnnulation[iEtapeAnnulation][0].ivoix := ivoix;

    Cancellation_IncIndAnnul;
    iMaxEtapeAnnulationCourant := iEtapeAnnulation;
    {libère la mémoire de l'action d'ici}

    {on écrase l'étape iEtapeAnnulation (qui est soit vide ou soit
     une étape trop ancienne que l'on peut jeter car trop vieille}
    for i := high(EtapesAnnulation[iEtapeAnnulation]) downto 0 do
         EtapesAnnulation[iEtapeAnnulation][i].Mesure.Free;

    setlength(EtapesAnnulation[iEtapeAnnulation], 0);
    Cancellation_GererMenuAnnuler;

    private_c_est_le_premier_push := true;

End;




















procedure TCompositionAvecCancellation.Cancellation_PushMiniEtapeAAnnuler_Octavieurs_Ajouter(
              iportee, imesure: integer; temps: TRationnel; combien, indice: integer);
var l: integer;
Begin

    if private_c_est_le_premier_push then
          Setlength(EtapesAnnulation[iEtapeAnnulation], 0);

    private_c_est_le_premier_push := false;


    l := length(EtapesAnnulation[iEtapeAnnulation]);
    Setlength(EtapesAnnulation[iEtapeAnnulation], l+1);

    With EtapesAnnulation[iEtapeAnnulation][l] do
    Begin
        typ := taOctavieur_Ajouter;
        imes := imesure;
        action_octavieur_iportee := iportee;
        action_octavieur_temps := temps;
        action_octavieur_combien := combien;
        action_octavieur_indice := indice;
        Mesure := nil;
    End;
End;




procedure TCompositionAvecCancellation.Cancellation_PushMiniEtapeAAnnuler_Octavieurs_Supprimer(
                      iportee, imesure: integer; temps: TRationnel; combien: integer; indice: integer);
var l: integer;
Begin

    if private_c_est_le_premier_push then
          Setlength(EtapesAnnulation[iEtapeAnnulation], 0);

    private_c_est_le_premier_push := false;


    l := length(EtapesAnnulation[iEtapeAnnulation]);
    Setlength(EtapesAnnulation[iEtapeAnnulation], l+1);

    With EtapesAnnulation[iEtapeAnnulation][l] do
    Begin
        typ := taOctavieur_Supprimer;
        imes := imesure;
        action_octavieur_iportee := iportee;
        action_octavieur_temps := temps;
        action_octavieur_combien := combien;
        action_octavieur_indice := indice;
        Mesure := nil;
    End;

End;




procedure TCompositionAvecCancellation.Cancellation_PushMiniEtapeAAnuller_ModificationPorteeProprietesSimples(
                    iportee: integer);

   Function CopiePorteeGlobale(p: TPorteeGlobale): TPorteeGlobale;
   Begin
        result := p;
        result.Octavieurs_Liste := nil;
   End;

var l: integer;
Begin

    if private_c_est_le_premier_push then
          Setlength(EtapesAnnulation[iEtapeAnnulation], 0);

    private_c_est_le_premier_push := false;

    l := length(EtapesAnnulation[iEtapeAnnulation]);
    Setlength(EtapesAnnulation[iEtapeAnnulation], l+1);

    With EtapesAnnulation[iEtapeAnnulation][l] do
    Begin
        typ := taModificationProprietesSimplesPortee;
        imes := -1;
        action_modifier_portee_proprietes_simples_iportee := iportee;
        action_modifier_portee_proprietes_simples_portee_info := CopiePorteeGlobale(PorteesGlobales[iportee]);
        Mesure := nil;
    End;

End;


procedure TCompositionAvecCancellation.Cancellation_PushMiniEtapeAAnuller_ModificationBarreMesure_Type(
                    m: integer;
                    barretype_nouveau: TBarreType);
var l: integer;
Begin
    if private_c_est_le_premier_push then
          Setlength(EtapesAnnulation[iEtapeAnnulation], 0);

    private_c_est_le_premier_push := false;


    l := length(EtapesAnnulation[iEtapeAnnulation]);
    Setlength(EtapesAnnulation[iEtapeAnnulation], l+1);

    With EtapesAnnulation[iEtapeAnnulation][l] do
    Begin
        typ := taModifierBarreMesureType;
        imes := m;
        action_modifier_barremesure_type_barre_avant := BarreDeMesure_Get(imes);
        action_modifier_barremesure_type_barre_apres := barretype_nouveau;
        Mesure := nil;
    End;

End;

Procedure TCompositionAvecCancellation.Cancellation_PushMiniEtapeAAnnuler(typannul: TTypAnnulation; m: integer);
var l: integer;
Begin
    if private_c_est_le_premier_push then
          Setlength(EtapesAnnulation[iEtapeAnnulation], 0);

    private_c_est_le_premier_push := false;

    l := length(EtapesAnnulation[iEtapeAnnulation]);
    Setlength(EtapesAnnulation[iEtapeAnnulation], l+1);

    With EtapesAnnulation[iEtapeAnnulation][l] do
    Begin
        typ := typannul;
        imes := m;
        if typ = taRemplacerMes then
            GetMesure(imes).CopieObjectMesureEnDeselectionnant(Mesure);
    End;
End;


Procedure TCompositionAvecCancellation.Cancellation_PushMiniEtapesSurSelectionAnnuler;
var m:integer;
Begin
for m := Selection_Getimesdebutselection to Selection_Getimesfinselection do
         Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, m);

End;

end.
