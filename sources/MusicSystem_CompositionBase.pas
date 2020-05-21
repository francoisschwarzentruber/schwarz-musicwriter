unit MusicSystem_CompositionBase;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,
     MusicSystem_Octavieurs_Liste,
     MusicSystem_Composition_Portees_Liste,
     typestableaux;


const VFFLaPlusRecente = 5;

      Portee_Tablature_ZoomParDefaut = 120;

      VOIX_TOUTES_LES_VOIX = -1;
      

type
      






TCompositionBase = class(TComposition_Portees_Liste)
private
      procedure GetGroupeGraphiquePortees(p: integer; var pdebut, pfin: integer);



protected
       Mesures: array of TMesure;
       
public
{informations générales}
       Nom, Auteur: string;
       AEteModifieDepuisEnregistrement: Boolean;

{PORTEES...}




       constructor Create;



{PORTEES...}

       {gestion des portées}
       procedure Portee_Ajouter(indice, a_instru: integer; a_clef: TClef);
       procedure Portee_Ajouter_Tablature(ip: integer);

       
       Function Portee_Supprimer(indice: integer): Boolean;
       {la portée 1 reste en 1
        la portée 2 reste en 2
        :
        la portée indice est viré
        la portée indice+1 devient la indice ieme
        :
        la portée n devient la n-1 ieme (toujours dernier)

        renvoie vrai ssi il y avait strictement plus d'une portée, ssi il y a bien
        eu suppression de la portée}

       Function Portees_Deplacer(de, a, nvpos: integer): integer;
       {on déplace les portées de "de" à "a" (incluse) pour les insérer entre l'actuelle
 portée n° nvpos-1 et n° nvpos.

 ex : avec DeplacerPortees(0, 1, 2), la portée n° 0 devient la n° 1
                                     la portée n° 1 devient la n° 2
                                     la portée n° 2 devient la n° 0

       <= retourne l'indice qu'aura la portée n° "de" après l'opération}


       {informations globales : nombre de portées, nombresde mesures}


       procedure NumPorteeValide(var portee: integer);
       {modifie portee (si vaut -1, -2...) pour en faire un indice de portée
        valide}



{MESURES... mais vraiment que les trucs de base !}


       {gestion des mesures}
       Function NbMesures: integer;



       procedure AddMesureVide(indice: integer);
       procedure AddMesureFin;
       Function DelMesure(m: integer): Boolean;



       Function GetMesure(m: integer): TMesure;
       Function prtgMesures(m: integer): TMesure;

       Function NbNotesParPortees: TArrayInteger;


protected
       procedure SetMesure(m: integer; mes: TMesure);

public

       Function IsMesureVide(m: integer): Boolean;

       Procedure RendreIndiceMesureValide(var m : integer);


       Function IsIndiceMesureValide(imesure: integer): Boolean;

       Function Is_Mesure_Indice_PremiereMesure(imesure: integer): Boolean;
       Function Is_Mesure_Indice_MesureAAjouter(imesure: integer): Boolean;



       Function Voix_Nouvel_Indice(imesure: integer; iportee: integer): integer;


       Function DeltaTempsEntre(m1: integer; t1: TRationnel;
                                m2: integer; t2: TRationnel): TRationnel;
       {retourne le temps qu'il y a entre deux moments

       les temps sont indiqués de façon à ce que 0/1 corresponde au début
       de mesure

       ex : une partition en C (du 4/4 classique...)
            DeltaTempsEntre(2, 2/1, 4, 3/1) retourne
                  2+4+3 = 9/1 !!}




       Function Tonalites(m, p: integer): ShortInt;



       Function DansMemeGroupePortee(p1, p2: integer): Boolean;

       Function Num_Voix_CompatibleAvecPortee(num_voix, iportee: integer): Boolean;
       
       procedure GetGroupePortees(p: integer; var pdebut, pfin: integer);
       Function Portee_Groupe_PremierePortee(p: integer): integer;


       Function EstCompatibleAvecLesPortees(v: TVoix): Boolean;

       Function IsPartitionDOrchestre: Boolean;

       Function GetNbNotes: integer;

       Function Portee_Groupe_Instrument_NomAAfficher(portee: integer): string;
       {renvoie le nom de la portée n° portée
        (en fait, ça prend le nom interne, et ça remplace les "%i" par l'instrument
         et pouf)}


       Function Portee_Groupe_Instrument_NomAAfficher_DansGestionnaireAffichage(iportee: integer): string;

       procedure Portees_AjouterGroupePorteesClavier_Fin(instru: integer);
       procedure Portees_AjouterGroupePorteesNormalPlusTablature_Fin(instru: integer);

       
       procedure Portees_AjouterFin(instru: integer; clef: TClef);
       
       procedure Portees_AjouterGroupePortees_Fin(instru: integer; nb_portees: integer);
       procedure Portees_Reset;

{procédure de vérification}
       procedure VerifierFlagsMesure;
       procedure VerifierPosition(var pos: TPosition; mess_err: string);
       Function VerifierIndiceMesureOuDerniere(var m: integer; mess_err: string): Boolean;
       Function VerifierIndiceMesureOuDerniereOuNOP(var m: integer; mess_err: string): Boolean;
       Function VerifierIndiceMesure(var m: integer; mess_err: string): Boolean;
       procedure VerifierIntegriteMesure(m: integer; mess_err: string);

       Destructor Destroy; override;










end;
{fin TCompositionBase}



implementation

uses ChildWin, MusicGraph,
     MusicGraph_Portees {pour IGP...},
     MusicGraph_Images {pour avoir accès aux images des pauses...},
     MusicGraph_System {pour prec},
     MusicGraph_CouleursVoix {pour CouleurNoteDansVoixInactive...},
     MusicGraph_CercleNote {pour rayonnotes},
     MusicWriter_Erreur,
     Dialogs {pour ShowMessage}, instruments {pour GetInstrumentNom},
     MusicUser, MusicSystem_MesureAvecClefs {ModeNuances...},
     langues;

     
//Composition de base
//******************************************************************************

constructor TCompositionBase.Create;
Begin
    inherited Create;

    Portee_Ajouter(0, INSTRUMENT_PAR_DEFAUT, CLEF_PAR_DEFAUT);
    AddMesureFin;

End;



Function TCompositionBase.Is_Mesure_Indice_PremiereMesure(imesure: integer): Boolean;
Begin
       result := (imesure = 0);
End;



Function TCompositionBase.Is_Mesure_Indice_MesureAAjouter(imesure: integer): Boolean;
Begin
       result := (imesure = length(Mesures));
End;






Function TCompositionBase.NbMesures: integer;
Begin
    result := length(Mesures);
End;



procedure TCompositionBase.AddMesureVide(indice: integer);
{ajoute une nouvelle mesure vide qui sera à l'indice indice}

var i, p: integer;
    mesmodele: TMesure; {mesure à partir de laquelle on copie les caractéristiques
                         par exemple si on rajoute une mesure après une autre,
                         qui est écrit en 6/8, cette autre sera modèle et
                         la nouvelle sera également écrite en 6/8 par défaut}


Begin
      for p := 0 to NbPortees - 1 do
             PorteesGlobales[p].Octavieurs_Liste.RenommerNumerosMesures(indice, 1);

      mesmodele := nil;
      if indice >= length(Mesures) then
      Begin
             indice := length(Mesures);
             if high(Mesures) > -1 then mesmodele := Mesures[high(Mesures)];
      end
      else
             mesmodele := Mesures[indice];

      setlength(Mesures, length(Mesures)+1);
      for i := high(Mesures) downto indice + 1 do
              Mesures[i] := Mesures[i-1];

      Mesures[indice] := TMesure.Create;
      Setlength(Mesures[indice].Tonalites, length(PorteesGlobales));

      if mesmodele = nil then
      Begin
            Mesures[indice].Rythme.num := 4;
            Mesures[indice].Rythme.denom := 4;

            Mesures[indice].Metronome := METRONOME_DEFAULT;
      end
      else
      {on copie les caractéristiques de la mesure modèle dans la nouvelle mesure}
      Begin
          Mesures[indice].Rythme.num := mesmodele.Rythme.num;
          Mesures[indice].Rythme.denom := mesmodele.Rythme.denom;
          Mesures[indice].Metronome := mesmodele.Metronome;

          for i := 0 to high(PorteesGlobales) do
               Mesures[indice].Tonalites[i] := mesmodele.Tonalites[i];
      End;


      VerifierIntegriteMesure(indice, 'AddMesureVide');



End;



procedure TCompositionBase.AddMesureFin;
{ajoute une mesure en fin de composition}
Begin
      AddMesureVide(length(Mesures));
End;


Function TCompositionBase.DelMesure(m: integer): Boolean;
{supprime la mesure d'indice m

 la propriété "imesfinselection in [-1, high(Mesures)]" reste conservée}
var i, p, hmes:integer;
Begin
      for p := 0 to NbPortees - 1 do
             PorteesGlobales[p].Octavieurs_Liste.RenommerNumerosMesures(m, -1);

      hmes := high(Mesures);

      if (m > hmes) or (hmes = 0) then
           result := false
      else
      Begin
            Mesures[m].Free;
            for i := m to hmes-1 do
              Mesures[i] := Mesures[i+1];
            setlength(Mesures, hmes);

            result := true;
      end;




end;


Function TCompositionBase.GetMesure(m: integer): TMesure;
Begin
    VerifierIndiceMesure(m, 'GetMesure');

    result := Mesures[m];
End;



procedure TCompositionBase.SetMesure(m: integer; mes: TMesure);
Begin
    VerifierIndiceMesure(m, 'SetMesure');

    Mesures[m] := mes;
End;


Function TCompositionBase.prtgMesures(m: integer): TMesure;
{permet d'accéder aux mesures en "mode protégé".
 Si l'indice m est "invalide", la fonction essaye de comprendre
 ce que veut l'utilisateur.}
Begin
    if m < 0 then
    {indice trop faible --> premier mesure}
           result := Mesures[0]
    else if m > high(Mesures) then
    {indice trop grand --> on renvoit une mesure rajoutée en fin de document}
    Begin
           AddMesureFin;
           result := Mesures[high(Mesures)]
    end
    else
    {si c'est bon, pourquoi se priver ?? on renvoit la mesure}
           result := Mesures[m];

End;



procedure TCompositionBase.Portee_Ajouter(indice, a_instru: integer; a_clef: TClef);
{on rajoute une portée dont l'indice sera indice}

var i, j, k,n,  nbportee, anbportee:integer;

      Procedure RenommerPortee(var i: integer);
      Begin
           if i >= indice then
                  inc(i);
      End;


Begin
      anbportee := length(PorteesGlobales);
      nbportee := anbportee+1;
      setlength(PorteesGlobales, nbportee);
      for i := nbportee-1 downto indice + 1 do
              PorteesGlobales[i] := PorteesGlobales[i-1];

      for i := 0 to high(Mesures) do
              Setlength(Mesures[i].Tonalites, nbportee);

      for i := 0 to high(Mesures) do
      with Mesures[i] do
      Begin
          Setlength(Tonalites, nbportee);
          Tonalites[indice] := Mesures[i].Tonalites[0];
          for j := nbportee-1 downto indice+1 do
                  Tonalites[j] := Mesures[i].Tonalites[j-1];

          for j := 0 to high(ClefsInserees) do
               RenommerPortee(ClefsInserees[j].portee);

          for j := 0 to high(Voix) do
          with Voix[j] do
          Begin
                          {renumérotage des voix}
                          k := N_Voix div anbportee;

                          n := N_Voix mod anbportee;

                          if n >= indice then
                                  inc(n);

                          N_Voix := k * nbportee + n;

                          for k := 0 to high(ElMusicaux) do
                          with ElMusicaux[k] do
                                   if IsSilence then
                                             RenommerPortee(position.portee)
                                   else
                                           for n := 0 to high(Notes) do
                                                     RenommerPortee(Notes[n].position.portee);

          End;
      End;

      With PorteesGlobales[indice] do
      Begin
          Clef := a_clef;
          m_instrument := a_instru;
          taille := ZoomParDefaut;
          englobe := 1; 
          typeportee := tpPortee5Lignes;
          typeAccolade := taRien;
          nbPorteesGroupe := 0;
          reserved := 0;
          visible := pvAlways;
          Transposition.hauteur := 0;
          Transposition.alteration := aNormal;
          Nom := PORTEE_NOM_PAR_DEFAUT;
          Octavieurs_Liste := TOctavieurs_Liste.Create;
      End;


End;



procedure TCompositionBase.Portee_Ajouter_Tablature(ip: integer);
Begin
    VerifierIndicePortee(ip, 'AddPortee_Tablature');
    Portee_Ajouter(ip+1, 0, ClefSol);

    With PorteesGlobales[ip+1] do
    Begin
         typeportee := tpPorteeTablatureGuitare;
         taille := Portee_Tablature_ZoomParDefaut;
    End;
End;





Function TCompositionBase.Portee_Supprimer(indice: integer): Boolean;
{la portée 1 reste en 1
 la portée 2 reste en 2
 :
 la portée indice est viré
 la portée indice+1 devient la indice ieme
 :
 la portée n devient la n-1 ieme (toujours dernier)

 renvoie vrai ssi il y avait strictement plus d'une portée, ssi il y a bien
  eu suppression de la portée}


var i, j, k, n, nbportee, anbportee:integer;

      Function RenommerPortee(var i: integer): Boolean;
      {renommer la portée....si i = indice, renvoit true}
      Begin
           result := false;
           if i > indice then
                  dec(i)
           else
                  result := true;
      End;


Begin
      VerifierIndicePortee(indice, 'SupprimerPortee');

      anbportee := length(PorteesGlobales);
      nbportee := high(PorteesGlobales);

      result := true;

      if nbportee = 0 then
      Begin
             result := false;
             Exit;
      End;


      for i := indice to nbportee-1 do
              PorteesGlobales[i] := PorteesGlobales[i+1];

      setlength(PorteesGlobales, nbportee);

      for i := 0 to high(Mesures) do
      with Mesures[i] do
      Begin
          for j := indice to nbportee-1 do
                  Tonalites[j] := Mesures[i].Tonalites[j+1];
          Setlength(Tonalites, nbportee);

          j := 0;
          While j <= high(ClefsInserees) do
          Begin
              if ClefsInserees[j].portee = indice then
                  Clefs_Del1(indice)
              else
              Begin
                  RenommerPortee(ClefsInserees[j].portee);
                  inc(j);
              End;
          End;




          {renumérote les voix
           décalle les élements musicaux
           supprime les éléments musicaux qui sont sur la portée que l'on supprime}
          for j := 0 to high(Voix) do
          with Voix[j] do
          Begin
                  if N_Voix mod anbportee = indice then
                  Begin
                               Free;
                               Voix[j] := nil;
                  End
                  else
                  Begin
                          {renumérotage des voix}
                          k := N_Voix div anbportee;

                          n := N_Voix mod anbportee;

                          if n > indice then
                                  dec(n);

                          N_Voix := k * nbportee + n;

                          k := 0;
                          while k <= high(ElMusicaux) do
                          with ElMusicaux[k] do
                                   if IsSilence then
                                   Begin
                                             if position.portee = indice then
                                                     DelElMusical(k)
                                             else
                                             Begin
                                                 if position.portee > indice then
                                                         dec(position.portee);
                                                 inc(k);
                                             End;
                                   End
                                   else
                                   Begin
                                           n := 0;
                                           while n <= high(Notes) do
                                                  if Notes[n].position.portee = indice then
                                                     DelNote2(n)
                                                  else
                                                   Begin
                                                     if Notes[n].position.portee > indice then
                                                            dec(Notes[n].position.portee);
                                                    inc(n);
                                                    End;

                                           if high(Notes) = -1 then
                                                   DelElMusical(k)
                                           else
                                                   inc(k);


                                   End;
                  End;
          End;

          Mesures[i].Nettoyer;
      end;


      If Portee_IsTablature(0) then
          Portee_Type[0] := tpPortee5Lignes;
End;




Function TCompositionBase.Portees_Deplacer(de, a, nvpos: integer): integer;
{on déplace les portées de "de" à "a" (incluse) pour les insérer entre l'actuelle
 portée n° nvpos-1 et n° nvpos.

 retourne l'indice qu'aura la portée n° "de" après l'opération}

var i, j, k, n, nbportees, hportees, nvnvpos:integer;

{variables de sauvegardes qui vont stockées les anciennes valeurs du tableau
    PorteesGlobales et du tableau Tonalites pour chaque mesure}
    savPorteesGlobales: TPorteesGlobales;
    savTonalites: TTonalites;

    Function NvIndicePortee(i: integer): integer;
    {renvoit le nouveau numéro de portée de la portée n° i}
    Begin
        if i in [de..a] then
            result := (i - de) + nvnvpos
              {de ---> nvnvpos
               de+1 ---> nvnvpos + 1
               :
               }
        else
        Begin
            result := i;

             if i >= nvpos then
                  result := i + (a - de + 1);

              if i > a then
                  result := result - (a - de + 1);

        End;


    End;


    Procedure RenommerPortee(var i:integer);
    {remplace un indice de portée par le nouvel indice de portée}
    Begin
        i := NvIndicePortee(i);
    End;


Begin

    {préconditions}
    if not IsIndicePorteeValide(De) then
          MessageErreur('La valeur "de" dans "déplacerportees" est incorrecte !');

    if not IsIndicePorteeValide(A) then
          MessageErreur('La valeur "A" dans "déplacerportees" est incorrecte !');

    if not (IsIndicePorteeValide(nvpos) or (nvpos = Length(PorteesGlobales)))  then
          MessageErreur('La valeur "nvpos" dans "déplacerportees" est incorrecte !');



    {calcul de nvnvpos...}
    if nvpos > a then
    //il faut décaller si la position se trouve après le paquet à déplacer
          nvnvpos := nvpos - (a - de + 1)
    else if nvpos < de then
          nvnvpos := nvpos
    else //si nvpos est entre de et à, alors nvpos = de
          nvnvpos := de;
    {...nvnvpos désigne bien l'indice qu'aura l'actuelle portée n° "de"}


    nbportees := length(PorteesGlobales);
    hportees := high(PorteesGlobales);

    //on copie le tableau PorteesGlobales dans savPorteesGlobales
    Setlength(savPorteesGlobales, nbportees);
    for i := 0 to hportees do
          savPorteesGlobales[i] := PorteesGlobales[i];

    {on réalise le déplacement}
    for i := 0 to hportees do
          PorteesGlobales[NvIndicePortee(i)] := savPorteesGlobales[i];

    Setlength(savTonalites, nbportees);



    for i := 0 to high(Mesures) do
    with Mesures[i] do
    Begin
        //on sauvegarde le tableau Tonalites dans savTonalites
        for j := 0 to hportees do
              savTonalites[j] := Tonalites[j];

        for j := 0 to hportees do
                Tonalites[NvIndicePortee(j)] := savTonalites[j];

        {on met à jour les indices des clés insérées}
        for j := 0 to high(ClefsInserees) do
             RenommerPortee(ClefsInserees[j].portee);


        {renumérote les voix
         décalle les élements musicaux
         supprime les éléments musicaux qui sont sur la portée que l'on supprime}
        for j := 0 to high(Voix) do
        with Voix[j] do
        Begin
                {renumérotage des voix}
                N_Voix := (N_Voix div nbportees) * nbportees
                                      + NvIndicePortee(N_Voix mod nbportees);

                        k := 0;
                        while k <= high(ElMusicaux) do
                        with ElMusicaux[k] do
                                 if IsSilence then
                                 Begin
                                 //détruire la pause.... (à revoir pour suppr)
                                     RenommerPortee(position.portee);
                                     inc(k);
                                 End
                                 else
                                 Begin
                                      n := 0;
                                      while n <= high(Notes) do
                                      Begin
                                            {if Notes[n].position.portee = indice then
                                                   DelNote2(n)
                                            else
                                                 Begin     }
                                                   RenommerPortee(Notes[n].position.portee);
                                                  //End;
                                            inc(n);
                                      End;
                                         if high(Notes) = -1 then
                                                 DelElMusical(k)
                                         else
                                                 inc(k);


                                 End;

        End;

        Mesures[i].Nettoyer;
    end;

    result := nvnvpos;

    If Portee_IsTablature(0) then
          Portee_Type[0] := tpPortee5Lignes;

End;









Function TCompositionBase.DeltaTempsEntre(m1: integer; t1: TRationnel;
                                       m2: integer; t2: TRationnel): TRationnel;
var T: TRationnel;
    m: integer;
Begin
//préconditions
   VerifierIndiceMesure(m1, 'm1 dans DeltaTempsEntre');
   VerifierIndiceMesure(m2, 'm2 dans DeltaTempsEntre');

   if m1 = m2 then
          result := QDiff(t2, t1)
   else
   Begin
      T := Qdiff(Mesures[m1].DureeTotale, t1);

      for m := m1 + 1 to m2 - 1 do
          QInc(T, Mesures[m].DureeTotale);

      QInc(T, t2);
      result := T;
   End;


End;






Function TCompositionBase.DansMemeGroupePortee(p1, p2: integer): Boolean;
var pdebut1, pdebut2, pfin1, pfin2: integer;

Begin
//préconditions
    VerifierIndicePortee(p1,'Argument p1 de DansMemeGroupePortee');
    VerifierIndicePortee(p2,'Argument p2 de DansMemeGroupePortee');

    GetGroupePortees(p1, pdebut1, pfin1);
    GetGroupePortees(p2, pdebut2, pfin2);

    result := (pdebut1 = pdebut2) and (pfin1 = pfin2);

End;



Function TCompositionBase.Num_Voix_CompatibleAvecPortee(num_voix, iportee: integer): Boolean;
Begin
    if num_voix = VOIX_TOUTES_LES_VOIX then
        result := true
    else
        result := DansMemeGroupePortee(
                     num_voix mod NbPortees {portée de la voix},
                     iportee);
End;

procedure TCompositionBase.GetGroupeGraphiquePortees(p: integer; var pdebut, pfin: integer);
{étant donné une portée p, cette procédure écrit dans pdebut et pfin
  les numéros de portées tel que
   [pdebut, pfin] forme un groupe de portées solidaires
   p dans [pdebut, pfin]
}

var ip:integer;
Begin
     VerifierIndicePortee(p,'Argument de GetGroupePortees');

     pdebut := -1; 
     for ip := p downto 0 do
          if p in [ip..ip + PorteesGlobales[ip].nbPorteesGroupe] then
          Begin
                pdebut := ip;
                pfin := ip + PorteesGlobales[ip].nbPorteesGroupe;
          End;

    VerifierIndicePortee(pdebut,'Erreur de sortie : pdebut incorrect dans GetGroupePortees');
    VerifierIndicePortee(pfin,'Erreur de sortie : pfin incorrect dans GetGroupePortees');

End;


procedure TCompositionBase.GetGroupePortees(p: integer; var pdebut, pfin: integer);
{étant donné une portée p, cette procédure écrit dans pdebut et pfin
  les numéros de portées tel que
   [pdebut, pfin] forme un groupe de portées solidaires
   p dans [pdebut, pfin]

   Un groupe de portées c'est en gros... une accolade... pas des crochets !!}

Begin
     VerifierIndicePortee(p,'Argument de GetGroupePortees');

     GetGroupeGraphiquePortees(p, pdebut, pfin);

    if PorteesGlobales[pdebut].typeAccolade = taCrochet then
    Begin
          pdebut := p;
          pfin := p;
    end;

    VerifierIndicePortee(pdebut,'Erreur de sortie : pdebut incorrect dans GetGroupePortees');
    VerifierIndicePortee(pfin,'Erreur de sortie : pfin incorrect dans GetGroupePortees');

End;



Function TCompositionBase.Portee_Groupe_PremierePortee(p: integer): integer;
var pdeb, pfin: integer;
Begin
     GetGroupePortees(p, pdeb, pfin);
     result := pdeb;
End;


procedure TCompositionBase.VerifierPosition(var pos: TPosition; mess_err: string);
Begin
     VerifierIndicePortee(Pos.portee, '(vérification de la position graphique) ' + mess_err);
     if abs(Pos.Hauteur) > 1000 then
     Begin
          pos.Hauteur := 0; 
          MessageErreur('Hauteur super grande dans le test de position graphique. ' +mess_err);
     End;
End;


procedure TCompositionBase.VerifierIntegriteMesure(m: integer; mess_err: string);
var v: integer;
Begin
with Mesures[m] do
Begin
    Nettoyer;

    For v := 0 to High(Voix) do
         if Voix[v] = nil then
                MessageErreur('La voix n°' + inttostr(v) +  ' n''est pas initialisée !!!')
         else
                Voix[v].VerifierIntegrite('Voix n° ' + inttostr(v) +
                                          'Mesure n° ' + inttostr(m) + '. ' +
                                          mess_err);
    End;
End;


procedure TCompositionBase.VerifierFlagsMesure;
Begin
    if not Mesures[0].affRythmeDebut then
          MessageErreur('Dans la première mesure, on affiche plus le rythme de début !!');
End;




Function TCompositionBase.Tonalites(m, p: integer): ShortInt;
var mes: TMesure;
Begin
VerifierIndicePortee(p, 'TComposition.tonalites');

if m > high(Mesures) then
       mes := Mesures[high(Mesures)]
else
       mes := Mesures[m];

result := mes.Tonalites[p];

//post-conditions

VerifierTonalite(result);

End;





Function TCompositionBase.Voix_Nouvel_Indice(imesure: integer; iportee: integer): integer;
Begin
    VerifierIndiceMesureOuDerniere(imesure, 'Voix_Nouvel_Indice');
    VerifierIndicePortee(iportee, 'Voix_Nouvel_Indice');

    If imesure > high(Mesures) then
        dec(imesure);

    result := Getmesure(imesure).NvIndiceVoix(NbPortees, iportee);
End;














Function TCompositionBase.VerifierIndiceMesure(var m: integer; mess_err: string): Boolean;
{indique si l'indice de mesure donné est l'indice d'une mesure existante}
Begin
    result := (0 <= m) and (m <= high(Mesures));

    if not result then
    Begin
           MessageErreur('Un indice de mesure (' + inttostr(m) + ') est incorrect.' +
                    ' Les indices de mesures doivent être compris entre 0 et ' +
                     inttostr(high(Mesures)) + '. ' + mess_err +
                     'PS : On met l''indice de mesure à 0.');
           m := 0;
    End;
End;


Function TCompositionBase.VerifierIndiceMesureOuDerniereOuNOP(var m: integer; mess_err: string): Boolean;
{indique si l'indice de mesure donné est l'indice d'une mesure existante}
Begin
    result := (-1 <= m) and (m <= length(Mesures));

    if not result then
    Begin
           MessageErreur('Un indice de mesure (' + inttostr(m) + ') est incorrect.' +
                    ' Les indices de mesures doivent être compris entre 0 et ' +
                     inttostr(length(Mesures)) + '. ' + mess_err +
                     'PS : On met l''indice de mesure à 0. (on autorise ici la valeur pour une dernière mesure et pour pas de num de mesure aussi!)');
           m := 0;
    End;
End;

Function TCompositionBase.VerifierIndiceMesureOuDerniere(var m: integer; mess_err: string): Boolean;
{indique si l'indice de mesure donné est l'indice d'une mesure existante}
Begin
    result := (0 <= m) and (m <= length(Mesures));

    if not result then
    Begin
           MessageErreur('Un indice de mesure (' + inttostr(m) + ') est incorrect.' +
                    ' Les indices de mesures doivent être compris entre 0 et ' +
                     inttostr(length(Mesures)) + '. ' + mess_err +
                     'PS : On met l''indice de mesure à 0. (on autorise ici la valeur pour une dernière mesure)');
           m := 0;
    End;
End;


Procedure TCompositionBase.RendreIndiceMesureValide(var m : integer);
Begin
    if m < 0 then
        m := 0;

    if m > high(Mesures) then
        m := high(Mesures);
End;

Function TCompositionBase.IsMesureVide(m: integer): Boolean;
Begin
   if IsIndiceMesureValide(m) then
        result := Mesures[m].IsVide
   else
        result := true;
End;



procedure TCompositionBase.NumPorteeValide(var portee: integer);
{si jamais portee sort de l'intervalle des portées de la partition,
        le remet dedans...(s'utilise, si jamais le curseur pointe sur une portée supprimée...)}
Begin
    If portee < 0 then
        portee := 0
        else if portee > High(PorteesGlobales) then
         portee := High(PorteesGlobales);
End;





Function TCompositionBase.IsIndiceMesureValide(imesure: integer): Boolean;
Begin
    result := (0  <= imesure) and (imesure <= High(Mesures));
End;

Function TCompositionBase.EstCompatibleAvecLesPortees(v: TVoix): Boolean;
var j, i_n: integer;
Begin
      With v do
      for j := 0 to high(ElMusicaux) do
           with ElMusicaux[j] do
                if IsSilence then
                Begin
                      if not IsIndicePorteeValide(position.portee) then
                      Begin
                            result := false;
                            Exit;
                      End;
                End
                else
                For i_n := 0 to high(Notes) do
                Begin
                     if not IsIndicePorteeValide(Notes[i_n].position.portee) then
                      Begin
                            result := false;
                            Exit;
                      End;


                End;

      result := true;

End;




Function TCompositionBase.IsPartitionDOrchestre: Boolean;
{renvoie vrai ssi la partition est une partition d'orchestre...
 - mais qu'est ce qu'une partition d'orchestre ?? (cf. déf dans l'implémentation !)
 - à quoi ça sert ? ==> à modifier le comportement du logiciel notamment portée sous le curseur
         affichée plus gros...}

Begin
    Result := NbPortees > 8;
End;



Function TCompositionBase.GetNbNotes: integer;
var s, m: integer;
Begin
    s := 0;
    
    for m := 0 to high(Mesures) do
          inc(s, Mesures[m].GetNbNotes);

    result := s;
End;


Function TCompositionBase.Portee_Groupe_Instrument_NomAAfficher(portee: integer): string;

    Function RechercherRemplacer(dans, chercheca, etremplacerpar: string): string;
    var p: integer;
        resultat: string;

    Begin
         p := pos(chercheca, dans);
         resultat := '';

         while (p <> 0) do
         Begin
             resultat := resultat + Copy(dans, 1, p-1) + etremplacerpar;
             dans := Copy(dans, p + length(chercheca), 10000);
             p := pos(chercheca, dans);
         End;

         resultat := resultat + dans;

         result := resultat;
    End;

    
Begin
      VerifierIndicePortee(portee, 'Portee_Groupe_Instrument_NomAAfficher');
                       
      result := RechercherRemplacer(PorteesGlobales[portee].Nom,
                                    '%i',
                   GetInstrumentNom(Portee_InstrumentMIDINum[portee]));
End;




Function TCompositionBase.Portee_Groupe_Instrument_NomAAfficher_DansGestionnaireAffichage(iportee: integer): string;
const Gestionnaire_Affichage_Portee_Toutes = -1;

    Function Portee_Num_To_Str: string;
        var p1, p2: integer;
        Begin
            p1 := iportee;
            p2 := iportee + Portee_GetNbPorteesInGroupe(iportee);

            if p1 = p2 then
                      result := 'portée n°' + inttostr(p1+1)
                  else
                      result := 'portées n°' + inttostr(p1+1) + ' à ' + inttostr(p2+1);


        End;
Begin
    if iportee = Gestionnaire_Affichage_Portee_Toutes then
          result := Langues_Traduire('toutes les portées')
    else
          result := 'partie ' + Portee_Groupe_Instrument_NomAAfficher(iportee) + ' : ' +
                         Portee_Num_To_Str;
End;




procedure TCompositionBase.Portees_AjouterGroupePortees_Fin(instru: integer; nb_portees: integer);
var id_prem, i: integer;
Begin
    id_prem := length(PorteesGlobales);
    
    for i := 0 to nb_portees - 1 do
        Portee_Ajouter(id_prem + i, instru, CLEF_PAR_DEFAUT);

    Portees_Accolade_Mettre(id_prem, id_prem + nb_portees - 1);
End;



procedure TCompositionBase.Portees_AjouterGroupePorteesClavier_Fin(instru: integer);
var id_prem: integer;
Begin
    id_prem := length(PorteesGlobales);
    
    Portee_Ajouter(id_prem, instru, ClefSol);
    Portee_Ajouter(id_prem + 1, instru, ClefFa);

    Portees_Accolade_Mettre(id_prem, id_prem + 1);
End;


procedure TCompositionBase.Portees_AjouterGroupePorteesNormalPlusTablature_Fin(instru: integer);
var id_prem: integer;
Begin
    id_prem := length(PorteesGlobales);
    
    Portee_Ajouter(id_prem, instru, ClefSol);
    Portee_Ajouter_Tablature(id_prem);

    Portees_Accolade_Mettre(id_prem, id_prem + 1);
End;



procedure TCompositionBase.Portees_AjouterFin(instru: integer; clef: TClef);
Begin

    Portee_Ajouter(length(PorteesGlobales), instru, clef);

End;



procedure TCompositionBase.Portees_Reset;
Begin
    Setlength(PorteesGlobales, 0);
End;



Function TCompositionBase.NbNotesParPortees: TArrayInteger;
var m, i, v, n, p: integer;
    r: TArrayinteger;

Begin
      setlength(r, length(PorteesGlobales));

      for p := 0 to high(r) do
           r[p] := 0;
           
      for m := 0 to high(Mesures) do
      with Mesures[m] do
           for v := 0 to high(Voix) do
           with Voix[v] do
                 for i := 0 to high(ElMusicaux) do
                 With ElMusicaux[i] do
                        for n := 0 to high(Notes) do
                         inc(r[Notes[n].position.portee]);

      result := r;
End;


Destructor TCompositionBase.Destroy;
var m: integer;
Begin
    for m := 0 to high(Mesures) do
          Mesures[m].Free;

    inherited Destroy;
End;






end.
