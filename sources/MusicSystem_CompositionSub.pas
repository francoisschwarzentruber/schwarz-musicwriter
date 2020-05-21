unit MusicSystem_CompositionSub;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,

     MusicSystem_Composition_Portees_Liste,
     MusicSystem_CompositionBase,
     MusicSystem_CompositionAvecPagination,
     MusicSystem_CompositionAvecSelection,
     MusicSystem_CompositionAvecSelectionApplication,
     MusicSystem_CompositionListeObjetsGraphiques,

     MusicSystem_Octavieurs_Liste;


type TCompositionSub = class(TCompositionAvecGestionSelectionApplication)
       Procedure NouvellePartitionPiano;
       Procedure NouvellePartitionGuitare;
       Procedure NouvellePartitionSolo(instru: integer);



       procedure OuvrirApercu;
       {Charge le fichier courant, mais que la première ligne}

       Function Save: Boolean;
       {Charge le fichier courant dans cet objet ou écrit cette objet
        sur le disque}


private
       Function SaveP(JusteLaPremiereLigne: Boolean): Boolean;

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
     tablature_system, MusicSystem_Composition_Avec_Paroles;
     


Procedure TCompositionSub.NouvellePartitionPiano;
Begin
    Portees_Reset;
    Portees_AjouterGroupePorteesClavier_Fin(instrumentPIANO);

    Selection_ToutDeselectionner;
    CalcTout(true);
End;



Procedure TCompositionSub.NouvellePartitionGuitare;
Begin
    Portees_Reset;
    Portees_AjouterGroupePorteesNormalPlusTablature_Fin(instrumentGUITARE);

    Selection_ToutDeselectionner;
    CalcTout(true);    
End;


Procedure TCompositionSub.NouvellePartitionSolo(instru: integer);
Begin
//préconditions
    VerifierIndiceInstrument(instru, 'NouvellePartitionSolo');

    Portees_Reset;
    Portee_Ajouter(0, instru, CLEF_PAR_DEFAUT);

    Selection_ToutDeselectionner;
    CalcTout(true);
End;





















Function TCompositionSub.Save: Boolean;
Begin
    result := SaveP(false);

    if EnLecture then
        Selection_ToutDeselectionner;


//post-conditions
    if EnLecture then
        Selection_VerifierSelectionValide;
End;



procedure TCompositionSub.OuvrirApercu;
Begin
    SaveP(true);
End;

Function TCompositionSub.SaveP(JusteLaPremiereLigne: Boolean): Boolean;
{charge le fichier courant et met les données musicales dans l'objet
TComposition courant. Si JusteLaPremiereLigne est vraie, ne charge que la
première  ligne (pratique pour les aperçus dans la fenêtre ouvrir...

renvoie vrai si ça a réussi}


const option_JusteLaPremiereLigne_NbMesures_Max = 5;

var i, l: integer;
    infoclef: TInfoClef;
    t: TRationnel;
    nbporteecourant: integer;
    nb_mesures_au_total: integer;


    procedure CalculerPositionAbsolu;
    {appelé quand en lecture}
    {c'est assez bourrin, à revoir un jour}
    var i, v, e, n: integer;
    Begin
        for i := 0 to high(Mesures) do
           if EnLecture then
               //à partir des position graphiques, on devine les hauteurs absolues des notes
                with Mesures[i] do
                  for v := 0 to high(Voix) do with Voix[v] do
                  Begin
                      t := QUn;
                      for e := 0 to high(ElMusicaux) do with ElMusicaux[e] do
                      Begin
                          for n := 0 to high(Notes) do with Notes[n] do
                                Begin
                                      infoclef := InfoClef_Detecter(position.portee, i, t);
                                      HauteurNote.Hauteur := HauteurGraphiqueToHauteurAbs(infoclef, position.hauteur);
                                      Tablature_System_CordeNum_Set(Notes[n], doigtee);
                                End;
                          QInc(t, duree_get);
                      End;
                  End;

    End;

    label label_Partition_Calcul;



Begin
result := true;
AEteModifieDepuisEnregistrement := false;
if not FichierEnTete('MUS') then
Begin
    result := false;
    Exit;
End;
VFF := VFFLaPlusRecente;
FichierDoInt(VFF, VFFLaPlusRecente); //n° de version
{à ce stade, VFF contient la version du fichier en cours (que ce soit
    en lecture ou en écriture (en écriture VFF = VFFLaPlusRecente)}

FichierDoStr(Nom);
FichierDoStr(Auteur);

nbporteecourant := length(PorteesGlobales);
FichierDoInt(nbporteecourant, length(PorteesGlobales));
if EnLecture then
         Setlength(PorteesGlobales, nbporteecourant);
         
for i := 0 to high(PorteesGlobales) do
Begin
      FichierDoStr(PorteesGlobales[i].Nom);

      FichierDoWord(PorteesGlobales[i].m_instrument);  //pas sûr

      FichierDoWord(PorteesGlobales[i].taille);

      if PorteesGlobales[i].taille = 0 then
            PorteesGlobales[i].taille := ZoomParDefaut;

      FichierDoByte(PorteesGlobales[i].typeportee);
      FichierDoByte(PorteesGlobales[i].typeAccolade);
      FichierDoByte(PorteesGlobales[i].nbPorteesGroupe);
      FichierDoByte(PorteesGlobales[i].reserved);
      if (VFF >= 2) then
      Begin
          FichierDoByte(PorteesGlobales[i].reserved);
          FichierDoByte(PorteesGlobales[i].reserved);
          FichierDoByte(PorteesGlobales[i].reserved);
          FichierDo(PorteesGlobales[i].Visible,SizeOf(TPorteeVisibility)); //1 octet

          FichierDo(PorteesGlobales[i].Transposition, SizeOf(THauteurNote));
      End
      else
      Begin
          PorteesGlobales[i].Visible := pvAlways;
          PorteesGlobales[i].Transposition.hauteur := 0;
          PorteesGlobales[i].Transposition.alteration := aNormal;
      End;
      FichierDo(PorteesGlobales[i].Clef, SizeOf(TClef));

      if EnLecture then
         PorteesGlobales[i].Octavieurs_Liste := TOctavieurs_Liste.Create;
end;


FichierDoInt(l, length(Lignes));
if EnLecture then
         Setlength(lignes, l);

FichierDo(Lignes[0], length(Lignes) * SizeOf(TLigne));
FichierDoInt(l, NbMesures);


if JusteLaPremiereLigne and (high(Lignes) > 0) then
        l := min(option_JusteLaPremiereLigne_NbMesures_Max, Lignes[1].mdeb);

if JusteLaPremiereLigne then
{qd on ouvre un aperçu, seul la première ligne est affichée
  antant libérer la mémoire et ne garder que les infos de la première ligne
   (ça évite que ça plante dans CalcPorteesPixy aussi...}
     SetLength(Lignes, 1);


      if EnLecture then
           Begin
               Setlength(Mesures, l);
               for i := 0 to high(Mesures) do
                  Mesures[i] := TMesure.Create;
           end;


      nb_mesures_au_total := high(Mesures);


      for i := 0 to nb_mesures_au_total do
      Begin
            Mesures[i].Save(nbporteecourant);
            MusicUser_Pourcentage_Informer(i / length(Mesures));
      End;


      if not JusteLaPremiereLigne then
      Begin

              FichierDoInt(l, 0); //pas de paroles

              if (not FileSystem_IsFinFichier or not EnLecture) and not JusteLaPremiereLigne then
              Begin
                  if not FichierDoSection('octavieurs') then
                  Begin
                       MessageErreur('problème dans la section octavieurs');
                       goto label_Partition_Calcul;
                  End;

                  for i := 0 to high(PorteesGlobales) do
                         PorteesGlobales[i].Octavieurs_Liste.SaveOrLoad;
              End;


              if (not FileSystem_IsFinFichier or not EnLecture) and not JusteLaPremiereLigne then
              Begin
                  FichierDoSection('graphics');
                  FichierDoInt(l, NbObjetsGraphiques);//////////////////

                  if EnLecture then
                   Begin
                       Setlength(private_GraphicObjets, l);
                       for i := 0 to high(private_GraphicObjets) do
                          private_GraphicObjets[i] := TGraphicObjet.Create;
                   end;
                  for i := 0 to high(private_GraphicObjets) do
                         private_GraphicObjets[i].SaveOrLoad;
              End;


              if  (not FileSystem_IsFinFichier or not EnLecture) then

              Paroles_SaveOrLoad;
      End;



      label_Partition_Calcul:
      CalculerPositionAbsolu;
      CalcPorteesPixy(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN);

End;


end.


