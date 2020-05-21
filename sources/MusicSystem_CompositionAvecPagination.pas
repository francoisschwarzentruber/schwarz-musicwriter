unit MusicSystem_CompositionAvecPagination;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,

     MusicSystem_Composition_Portees_Liste,
     MusicSystem_CompositionBase,
     MusicSystem_CompositionLectureMIDI;


     
const PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN = 1000;



type




{une ligne (ou système)}
TLigne = record
    mdeb, {mesure de début}
    pixy: integer; {ordonnée}

end;





     

type TCompositionAvecPagination = class(TCompositionAvecLectureMIDI)
  private


  public

        PorteesPixy: array of array of integer;
        Lignes: array of TLigne;

        constructor Create;

        
        Function NbLignes: integer;


        Function PointInMesureToPointInPage(m: integer; p: TPoint): TPoint;
               {convertit un point dont les coord. sont exprimés dans le repère de la
                mesure n° m, dans le repère virtuel de tout le document}

        Function RectInMesureToRectInPage(m: integer; r: TRect): TRect;



        
        {Les "FindMesure"
                on donne à manger des coord. dans le repère du document (déjà virtuelles)
                puis ces fonctions renvoie vraie si elle renvoie des données corrects
                (ie si on est pas en dehors du document, et donnent le numéro de mesure
                que le point survole ainsi que les coord. du point dans la mesure
                correspondante}

        {les "pourmodif" accepte d'être à la fin du document et renvoie alors
         l'indice qu'aurait la nouvelle dernière mesure, encore inexistante}

       Function FindMesure(var X, Y:integer; var indice: integer): Boolean;
       Function FindMesurePourModif(var X, Y:integer; var indice: integer): Boolean;

       {là, en plus on a le numéro de ligne :) }
       Function FindMesure2(var X, Y:integer; var iLigne, iMesure: integer): Boolean;
       Function FindMesurePourModif2(var X, Y:integer; var iLigne, iMesure: integer): Boolean;

       Procedure Octavieurs_SousCurseur(X, Y: integer; out iportee: integer; out indice: integer);
       Function Octavieurs_GetY(iligne, iportee, combien: integer): integer;

       
       Function Clefs_DetecterAvecrelX(iPortee, iMesure:integer; x: integer): TClef;
       Function Clefs_DetecterAvecpixX(iPortee:integer; x, y: integer): TClef;

       Function InfoClef_DetecterAvecrelX(iPortee, iMesure:integer; x: integer): TInfoClef;
       Function InfoClef_DetecterAvecpixX(iPortee:integer; x, y: integer): TInfoClef;

       
       Function Getmargepourinscrirenomdeportee(iligne: integer): integer;
       procedure Paginer(lignedebut, lignefin_apriori: integer;
                         optimisation_calculer_graphe_info_verticalite_notes: Boolean);




       procedure CalcGraphMesure(m: integer;
               optimisation_calculer_graphe_info_verticalite_notes: Boolean);
       procedure CalcQueue(l1, l2: integer);

       procedure DrawMesure(mes:integer);

       Function GetBarreDeMesureSousXY_iMesure(X, Y: integer): integer;
       Function PauseSousCurseur(X, Y: integer; var elm: TElMusical): Boolean;
       Function QueueSousCurseur(X, Y:integer; var el:TElmusical): Boolean;
       Function NoteSousCurseur(X, Y:integer; var el : TElMusical; var n:TPNote): Boolean;


       {fonctions qui permettent de retrouver un numéro de ligne}
       Function LignePlusProcheAvecY(y: integer): integer;
       {recherche de la ligne en cours
 renvoie TOUJOURS un indice de ligne valide}

       Function LigneAvecY(y: integer): integer;
       {recherche de la ligne en cours
renvoie -1 ssi on est dans la zone de titre...}

       Function LigneAvecMes(m: integer): integer;

       Function LignesMDeb(l: integer): integer;
       Function LignesMFin(l: integer): integer;
       {renvoie l'indice de la dernière mesure présente sur la ligne n° l}

       Procedure SetOriginMesure(m: integer);

       Procedure CalcPorteesPixy(iligne1, iligne2: integer);
       Procedure EtirerPorteesPixxY(l: integer; e: real);

       Function PremierePorteeAffichee(iLigne: integer): integer;
       {normalement renvoie 0... sauf si des portées au début sont invisibles !!}

       Function DernierePorteeAffichee(iLigne: integer): integer;
       {normalement renvoie NbPortees-1 sauf si des portées à la fin sont invisibles !!}


       Function Ligne_XGauche(iLigne: integer): integer;
       Function Ligne_XDroite(iLigne: integer): integer;
       
       Function Ligne_YHaut(iLigne: integer): integer;
       Function Ligne_YBas(iLigne: integer): integer;


       Function Mesure_XGauche(iMesure: integer): integer;
       Function Mesure_XDroite(iMesure: integer): integer;
       
       Function Mesure_YHaut(iMesure: integer): integer;
       Function Mesure_YBas(iMesure: integer): integer;

       Function BarreDeMesure_Gauche_X(im: integer): integer;
       Function BarreDeMesure_Droite_X(im: integer): integer;

       Function Portee_YHaut(iLigne: integer; iPortee: integer): integer;
       Function Portee_YBas(iLigne: integer;  iPortee: integer): integer;

       Function Portee_YHaut_Barre_InRepere_Ligne(iLigne: integer; iPortee: integer): integer;
       Function Portee_YBas_Barre_InRepere_Ligne(iLigne: integer; iPortee: integer): integer;

       Function Portee_Groupe_Instrument_NomAAfficher_Y(l, p: integer): integer;

       Function PorteesVisibles(iLigne: integer): TArrayBool;

       Function minHauteurLigne(iLigne: integer): integer;
       Function iPageFromiLigne(iLigne: integer): integer;
       Procedure IntervalleiLignesurPage(iPage: integer; var iLigne1, iLigne2: integer);

       Function GetMesureSurLigne(l, x: integer):integer;
{renvoit toujours un indice entre Lignes[l].mdeb to LignesMFin(l)
 cette procédure sert à optimiser l'affichage}

       Function AlterationLocale(m: integer; temps: TRationnel; pos: TPosition): TAlteration;
       {calcule l'alteration qu'aurait une note sans altération visible
       (pas de # apparent) etc si elle était en position pos, au temps temps
       dans la mesure m.

       Cette procédure l'appel préalable de CreerGraphOrdreInfo car elle utilise mgoi.

       Cette procédure utilise les informations de :
         - Clés insérées pour savoir qd arrêter l'information des altérations
         - mgoi pour savoir les notes déjà insérées et donc déduire l'altération
           courante
         - la tonalité courante à la clef

         t = QUn correspond au début de mesure}
      Function IsIndiceLigneValide(iLigne: integer): Boolean;

      procedure RendreIndiceLigneValide(var iligne: integer);
      procedure VerifierIndiceLigne(var iLigne: integer; mess: string);
      procedure VerifierIndiceLigneOrNOP(var iLigne: integer; mess: string);
end;


{état du logiciel}
Function IsMusicWriterCalcule: Boolean;
Function IsMusicWriterAffiche: Boolean;
Procedure SetMusicWriterCalcule;
Procedure SetMusicWriterAffiche;

































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
     MusicGraph_CouleursUser, MusicSystem_CompositionBaseAvecClef,
     MusicSystem_Octavieurs_Liste, MusicSystem_ElMusical_Liste_Notes,
     MusicSystem_MesureBase,
     Options_SaveAndLoad {pour les options comme la numérotation des mesures},

     TimerDebugger;


     

var
    bMusicWriterCalcule: Boolean;

var el_mus_Pause_PourPorteesVide: TElMusical;



{*****************Comportements calcul/affichage****************}


Function IsMusicWriterCalcule: Boolean;
Begin
    result := bMusicWriterCalcule;
End;


Function IsMusicWriterAffiche: Boolean;
Begin
    result := not bMusicWriterCalcule;
End;



Procedure SetMusicWriterCalcule;
{prévient que Musicwriter fait un calcul de partition}
Begin
     bMusicWriterCalcule := true;
End;


Procedure SetMusicWriterAffiche;
{prévient que Musicwriter affiche une partition}
Begin
     bMusicWriterCalcule := false;
End;

{les deux précédentes procédures changent notamment le comportement
 de ZoomPortees}






 
constructor TCompositionAvecPagination.Create;
Begin
    inherited Create;
    Setlength(Lignes, 1);
    Lignes[0].mdeb := 0;
End;


Function TCompositionAvecPagination.BarreDeMesure_Gauche_X(im: integer): integer;
Begin
    VerifierBarreDeMesureIndice(im, 'BarreDeMesure_X');

    If Is_Mesure_Indice_MesureAAjouter(im) then
        result := Mesure_XDroite(im - 1)
    else
        result := Mesure_XGauche(im);

End;


Function TCompositionAvecPagination.BarreDeMesure_Droite_X(im: integer): integer;
Begin
    VerifierBarreDeMesureIndice(im, 'BarreDeMesure_X');

    result := Mesure_XDroite(im);


End;


Function TCompositionAvecPagination.NbLignes: integer;
Begin
    result := length(Lignes);
End;



Function TCompositionAvecPagination.FindMesure(var X, Y:integer; var indice: integer): Boolean;
var l: integer; //variable rebus
Begin
    result := FindMesure2(X, Y, l, indice);
End;



Function TCompositionAvecPagination.FindMesure2(var X, Y:integer; var iLigne, iMesure: integer): Boolean;
{renvoit vrai si on est vraiment dans une mesure existante}
var i,
    pixy        :integer;
Begin
      IGP := Self;

      iMesure := -1;


      iLigne := LigneAvecY(y);

      if iLigne = -1 then
      Begin
            result := false;
            Exit;
      End;

      IGiLigne := iLigne;
      pixy := Lignes[iLigne].pixy;



      //TODO : FAIRE CETTE RECHERCHE PAR DICHOTOMIE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      for i := Lignes[iLigne].mdeb to LignesMFin(iLigne) do
             if (Mesures[i].pixx - margegauche <= x) and (x <= Mesures[i].pixx + Mesures[i].pixWidth) then
             Begin
                  iMesure := i; //mesure dedans
                  Break;
             end;


      i := high(Mesures);

      if iMesure = -1 then
      Begin
          result := false;
          if (iLigne = high(Lignes)) and (x > (Mesures[i].pixx + Mesures[i].pixWidth)) then
          //Si en fait, on est "sur la mesure à ajouter"}
          Begin
                        iMesure := i + 1;
                        X := x - Mesures[i].pixx - Mesures[i].pixWidth;

          End;
          Y := y - pixy;

      end
      else
      Begin
            X := x - Mesures[iMesure].pixx;
            Y := y - pixy;
            result := true;
      End;


End;

Function TCompositionAvecPagination.GetMesureSurLigne(l, x: integer):integer;
{renvoit toujours un indice entre Lignes[l].mdeb to LignesMFin(l)
 cette procédure sert à optimiser l'affichage}
var indice,i: integer;

Begin
//préconditions
     VerifierIndiceLigne(l, 'GetMesureSurLigne');

     indice := Lignes[l].mdeb;
     //à faire : de la dichotomie !!!!!!!!!!!!!!! lol
     for i := Lignes[l].mdeb to LignesMFin(l) do
           if (Mesures[i].pixx - margegauche <= x) and (Mesures[i].NbMesuresCompressees > 0) then
                indice := i; //mesure dedans

     result := indice;
     
End;

Function TCompositionAvecPagination.FindMesurePourModif(var X, Y:integer; var indice: integer): Boolean;
var l: integer; //variable rebus
Begin
    result := FindMesurePourModif2(X, Y, l, indice);
End;

Function TCompositionAvecPagination.FindMesurePourModif2(var X, Y:integer; var iLigne, iMesure: integer): Boolean;
{renvoit vrai si on se trouve :
    soit dans une mesure qui existe
    soit à la fin du document (dernière mesure, qui n'existe pas encore}

Begin
      result := FindMesure2(X, Y, iLigne, iMesure);
      if iMesure = length(Mesures) then
            result := true;
End;



Procedure TCompositionAvecPagination.Octavieurs_SousCurseur(X, Y: integer; out iportee: integer; out indice: integer);
var imesure, iligne: integer;
    pos: TPosition;
    Ydansdoc: integer;
    cc: integer;
Begin
     Ydansdoc := Y;
     FindMesure2(X, Y, iligne, imesure);

     if iLigne = -1 then
     Begin
         indice := -1;
         exit;
     End;
     GetPosition(Y, self, iligne, pos);

     iportee := pos.portee;
     
     indice := PorteesGlobales[iportee].Octavieurs_Liste.GetIndice(imesure, x);

     if indice > -1 then
     Begin
            cc := PorteesGlobales[iportee]
                      .Octavieurs_Liste.private_liste[indice].combien;

            if cc = 0 then
                 cc := PorteesGlobales[iportee]
                      .Octavieurs_Liste.private_liste[indice-1].combien;
                      
            if abs(Ydansdoc - Octavieurs_GetY(iligne, iportee, cc)) > 100 then indice := -1;

     End;
End;







Function TCompositionAvecPagination.Clefs_DetecterAvecrelX(iPortee, iMesure:integer; x: integer): TClef;
{détecte la clef courante qu'il y a en la mesure iMesure, sur la portée iPortee,
 à l'abcisse x (abscisse dans le repère de la mesure iMesure).}

var m, k: integer;
Begin
//préconditions
    VerifierIndicePortee(iPortee, 'DetecterClefAvecrelX');

    if iMesure > high(Mesures) then
    Begin
           iMesure := high(Mesures);
           x := IntegerInfini;
    end;

    for m := iMesure downto 0 do
    Begin
         for k := high(Mesures[m].ClefsInserees) downto 0 do
                with Mesures[m].ClefsInserees[k] do
                      if (portee = iportee) and (pixx + AuZoomPortee(largclef, portee) <= x) then
                               Begin
                                   result := Clef;
                                   Exit;
                               End;




         x := IntegerInfini;

    End;

    result := PorteesGlobales[iPortee].Clef;

End;


Function TCompositionAvecPagination.Clefs_DetecterAvecpixX(iPortee:integer; x, y: integer): TClef;
{détecter la clé courante sur la portée iPortée, à l'aide (x, y), coordonnées
 dans le document}
var pixx, m:integer;

Begin
//préconditions
      VerifierIndicePortee(iPortee, 'DetecterClefAvecpixX');

      FindMesure(x, y, m);
      {on trouve le numéro de la mesure m}

      if m < 0 then
      Begin
            m := 0;
            pixx := Mesures[m].pixX;
            x := pixx;
      End
      else
      if m <= high(Mesures) then
           pixx := Mesures[m].pixX
      else
      Begin
           m := high(Mesures);
           pixx := 0;
           x := IntegerInfini;
      End;

      {on détecte alors la clé à l'aide de DetecterClefAvecrelX}
      result := Clefs_DetecterAvecrelX(iPortee, m, x - pixx);

End;



Function TCompositionAvecPagination.InfoClef_DetecterAvecrelX(iPortee, iMesure:integer; x: integer): TInfoClef;
var clef: TClef;
    m: integer; 
Begin
    IGP := self;
    clef := Clefs_DetecterAvecrelX(iPortee, iMesure, x);

    if iMesure > high(Mesures) then
        m := high(Mesures)
    else
        m := iMesure;

    if iMesure < 0 then
    Begin
        iMesure := 0;
        m := 0;
        x := 0;
    End;

    Result := ClefToInfoClef(clef)
                 + 7 * Octavieurs_Detecter(iPortee, iMesure, GetMesure(m).TempsAX(x));
End;


Function TCompositionAvecPagination.InfoClef_DetecterAvecpixX(iPortee:integer; x, y: integer): TInfoClef;
var m, pixx: integer;

Begin
//préconditions
      VerifierIndicePortee(iPortee, 'DetecterClefAvecpixX');

      FindMesure(x, y, m);
      {on trouve le numéro de la mesure m}

      if m < 0 then
      Begin
            m := 0;
            pixx := Mesures[m].pixX;
            x := pixx;
      End
      else
      if m <= high(Mesures) then
           pixx := Mesures[m].pixX
      else
      Begin
           m := high(Mesures);
           pixx := 0;
           x := IntegerInfini;
      End;

      {on détecte alors la clé à l'aide de DetecterClefAvecrelX}
      result := InfoClef_DetecterAvecrelX(m, iPortee, x - pixx);
End;


Function TCompositionAvecPagination.LignesMDeb(l: integer): integer;
{renvoit la dernier mesure affichée sur la ligne}
Begin
//préconditions
    VerifierIndiceLigne(l, 'LignesMDeb');

    result := Lignes[l].mdeb;
End;


Function TCompositionAvecPagination.LignesMFin(l: integer): integer;
{renvoit la dernier mesure affichée sur la ligne}
Begin
//préconditions
    VerifierIndiceLigne(l, 'LignesMFin');

    if l = high(Lignes) then
    {sur la dernière ligne, la dernier mesure affichée est tout simplement
     la dernière mesure}
           result := high(Mesures)
    else
    {sinon, on déduit l'info de la ligne suivante}
           result := Lignes[l+1].mdeb - 1;


End;



Function TCompositionAvecPagination.Portee_Groupe_Instrument_NomAAfficher_Y(l, p: integer): integer;
Begin
    VerifierIndiceLigne(l, 'Portee_Groupe_Instrument_NomAAfficher_Y');
    VerifierIndicePortee(p, 'Portee_Groupe_Instrument_NomAAfficher_Y');

    result := (GetY(self, l, p, 2) + GetY(self, l, p+Portee_GetNbPorteesInGroupe(p), 2))
                                                                 div 2;
End;



Function TCompositionAvecPagination.Getmargepourinscrirenomdeportee(iligne: integer): integer;
var ip, marge, nouvel_marge_pt:integer;

Begin

    if not Portees_Is_Portees_Noms_Affiches(iligne) then

          result := 0
    else   {panpToutes ou alors panpJusteSurLaPremiereLigne et première ligne}

    Begin

          marge := 0;
          SetFontSizeToMeasure(12);
          for ip := 0 to NbPortees - 1 do
          Begin
               nouvel_marge_pt := C.TextWidth( Portee_Groupe_Instrument_NomAAfficher(ip) )
                                                 *ZoomMaxPrec div ZoomParDefaut;
               if PorteesGlobales[ip].nbPorteesGroupe > 0 then //ie ya une accolade
                   inc(nouvel_marge_pt, DximgAccolade1);

               if marge < nouvel_marge_pt then marge := nouvel_marge_pt;

               if marge > 6100 then
                  MessageErreur('Getmargepourinscrirenomdeportee va être super grand !');
          End;
          result := marge;

    End;
End;


Function TCompositionAvecPagination.Octavieurs_GetY(iligne, iportee, combien: integer): integer;
Begin
   VerifierIndicePortee(iportee, 'Octavieurs_GetY');

   if combien = 1 then
        result := Portee_YHaut(iligne, iportee)
   else
        result := Portee_YBas(iligne, iportee);
End;



procedure TCompositionAvecPagination.Paginer(lignedebut, lignefin_apriori: integer;
                                             optimisation_calculer_graphe_info_verticalite_notes: Boolean);
{on met en page les mesures et tout ça à partir de la ligne n° lignedebut

Si ModeAffichage = maPage,
          alors cette procédure compresse aussi les mesures vides en une seule.

}
const COMPOSITION_VIDE_MESURE_SEULE_TAILLE = 4000;

var  m_max_a_priori: integer;
    hmes :integer;







    Procedure Octavieurs_CalculerPosition;
    var ip, i: integer;
    Begin
      for ip := 0 to NbPortees - 1 do
        With PorteesGlobales[ip].Octavieurs_Liste do
             for i := 0 to high(private_liste) do
                  with private_liste[i] do
                        pixx := GetMesure(imesure).XATemps(temps);

    End;


      procedure Compression_Mesures_Calculer;
      var mm: integer;
          m: integer;
      Begin
      {on remplit les Mesures[m].NbMesuresCompressee

       Par defaut, Mesures[m].NbMesuresCompressee = 1. Mais si par exemple la mesure
       n° m et n° m+1 sont vides et ont même caractéristique, on peut les compresser
       en une seule. On a compresser 2 mesures et Mesures[m].NbMesuresCompressee = 2
       etc... }

            m := 0; //A optimiser
            while (m <= hmes) and (m <= m_max_a_priori) do
            Begin
                 if Mesures[m].RienAAfficher and (ModeAffichage = maPage) and (m < hmes) then
                 Begin
                      {on avance tant que les mesures sont vides et pareils...}
                      for mm := m+1 to hmes do
                          if not (Mesures[mm].RienAAfficher
                                and Mesures[mm].MemeStyleQue(Mesures[m])) then
                                break
                          else
                                Mesures[mm].NbMesuresCompressees := 0;
                                {par défaut, une mesure compressée et donc qu'on ne voit pas
                                 se promène avec son NbMesuresCompressees = 0}


                      {puis on compresse les mesures n° m à n°(mm-1) en "une seule"}
                      Mesures[m].NbMesuresCompressees := mm - m;
                 End
                 else
                     Mesures[m].NbMesuresCompressees := 1;

                 inc(m, Mesures[m].NbMesuresCompressees);
            End;
      End;














     procedure Paginer_CalculerLesMesuresEtLesPlacerSurDesLignes;
     var m, l: integer;
         mdeb, mfin: integer;
         x, lx: integer;
         largvraimentutilisable: integer;
         rapport: real;

     Begin
      IGP := self;
      l := lignedebut;
      m := Lignes[l].mdeb;
      while (m <= hmes) do
      Begin
           mdeb := m;
           MusicUser_Pourcentage_Informer(m / (hmes + 1));

           largvraimentutilisable := largutilisable
                                   - margepourmesure - Getmargepourinscrirenomdeportee(l);

           MessageErreur_Si_Negatif(largvraimentutilisable, 'largvraimentutilisable est négatif ! ' +
                   'Voici les valeurs des différents trucs :' +
                   'largutilisable = ' + inttostr(largutilisable) + ', ' +
                   'margepourmesure = ' + inttostr(margepourmesure) + ', ' +
                   'Getmargepourinscrirenomdeportee = ' + inttostr(Getmargepourinscrirenomdeportee(l)) + ', ');


           //if l = 0 then
                {lx = last x = précédente valeur de x}
                lx := 0;
                x := 0;//margepourinscrirenomdeportee;
           //else
           //     x := 0;

           while ((x <= largutilisable) or (ModeAffichage = maRuban)) and (m <= hmes) do
           Begin
                 {on met à jour la précédente valeur}
                  lx := x;

                  Mesures[m].affTonalitesDebut := (m = mdeb);



                  if m < hmes then
                        Mesures[m].affChgtTonalitesFin := (Mesures[m+1].GetTonalite <>
                                                           Mesures[m].GetTonalite);

                  if m > 0 then
                        Mesures[m].affRythmeDebut := not IsQEgal(Mesures[m-1].Rythme,
                                                                 Mesures[m].Rythme);

                  {là on lance le calcul de l'affichage de la mesure m}
                  CalcGraphMesure(m, optimisation_calculer_graphe_info_verticalite_notes);

                  inc(x, Mesures[m].pixwidth);
                  if (x > largvraimentutilisable) and (ModeAffichage <> maRuban) then
                        Break;

                  inc(m);

           End;

           mfin := m-1;

           if mfin < mdeb then mfin := mdeb;

           if (m = mdeb) or (m > hmes) then
           {s'il n'y a qu'une mesure sur la ligne}
                 lx := x;

           if (m <= high(Mesures)) then
           Begin
                 MessageErreur_Si_Negatif(largvraimentutilisable,
                                  'largvraimentutilisable est négatif !');

                 MessageErreur_Si_Negatif(lx,
                                  'lx est négatif !');



                 rapport := (largvraimentutilisable) / lx;
                 m := mdeb;

                 while (m <= mfin) do
                 Begin
                       Mesures[m].GraphEtirer(rapport);
                       inc(m, Mesures[m].NbMesuresCompressees);
                 End;

           end;

           //if l = 0 then
                x := margepourmesure + Getmargepourinscrirenomdeportee(l);
           {else
                x := margepourmesure;    }

           {à partir de ce point, les mesures d'indice mdeb à mfin vont dans la ligne
            et sont étirés}


           if l > high(Lignes) then
               setlength(Lignes, l+1);

           Lignes[l].mdeb := mdeb;


           IGiLigne := l;

           for m := mdeb to mfin do
           Begin
               Mesures[m].pixx := x;
               inc(x, Mesures[m].pixwidth);
           End;


           m := mfin+1;

           inc(l);



               if (l > lignefin_apriori) then
               Begin
                   if l <= high(Lignes) then
                        if (Lignes[l].mdeb = m) then
                 {si a priori, on a plus à calculer, et qu'on retombe sur nos pas,
                   on arrête là !! (on termine complétement la procédure}
                                exit;

                   lignefin_apriori := l;
           End;



      end;  {end while sur m}


      {si jamais le tableau Lignes est trop grand, on le rétrécit !}
      if l < length(Lignes) then
           SetLength(Lignes, l);


      if lignefin_apriori > high(Lignes) then
             lignefin_apriori := high(Lignes);


     End;









       procedure Paginer_PlacerLesLignesSurDesPages;
       var l, m, ll, ydeb, y, ipage: integer;
           lignedebutpage,lignefinpage,esp,minHauteurs: integer;
           OnPagineLaPageCarPlusDePlace ,
            OnPagineLaPageCarFinDuDocument : Boolean;
            SommeMinHauteurLignes: integer;

       Begin

       
            {but de la boucle : parcourir les lignes, les placer dans les pages

            invariant :
            - ipage désigne le numéro de la page courante
            - lignedebutpage désigne le numéro de ligne au début de la page ipage
            - y désigne l'ordonnée courante dans l'essai de placer les lignes collées
               les unes aux autres comme des sardines
            - SommeMinHauteurLignes désigne la somme des minHauteurLigne des lignes n°
              lignedebutpage à n° l

            }

            ipage := Lignes[lignedebut].pixy div hauteurpage;
            {page de la ligne courante}

            {BUT : recalculer les positions "y" des lignes à partir de la page courante ipage}

            IntervalleiLignesurPage(ipage, lignedebutpage, lignefinpage);
            {on cherche la ligne du début de la page}


            if lignedebutpage = 0 then
                y := YTitre + HTitre
            else
                y := Lignes[lignedebutpage].pixy;

            SommeMinHauteurLignes := 0;

            IGP := Self;
            for l := lignedebutpage to min(lignefin_apriori, high(Lignes)) {high(Lignes)} do
            Begin
                IGiLigne := l;
                for m := Lignes[l].mdeb to LignesMFin(l) do
                    With GetMesure(m) do
                         Begin

                             if optimisation_calculer_graphe_info_verticalite_notes then
                             Begin
                                 CalcQueuePositionAutomatiquement;
                                 CalcBoules;
                             End;
                       
                             CalcQueue;
                         End;


                Lignes[l].pixy := y;
                inc(y,minHauteurLigne(l));
                {algo glouton : on essaye de serrer les lignes au max (des minHauteurLigne's)
                                puis de voir combien on en met au max dans la page ipage}

                OnPagineLaPageCarPlusDePlace := (y >= (ipage + 1) * hauteurpage);

                if not OnPagineLaPageCarPlusDePlace then
                       inc(SommeMinHauteurLignes, minHauteurLigne(l));

                {cas exceptionnel du ruban}
                if ModeAffichage = maRuban then
                          OnPagineLaPageCarPlusDePlace := false;
                          {ya toujours de la place en mode ruban!!}

                if OnPagineLaPageCarPlusDePlace then
                      OnPagineLaPageCarFinDuDocument := false
                else
                      OnPagineLaPageCarFinDuDocument := (l = high(Lignes));


                if OnPagineLaPageCarPlusDePlace or OnPagineLaPageCarFinDuDocument then
                {si on sort de la page ipage, on en recrée une nouvelle}
                Begin

                    if OnPagineLaPageCarPlusDePlace then
                          lignefinpage := l-1
                    else
                          lignefinpage := l;

                    {à ce stade, on sait que dans la page ipage, on imprime les lignes
                    de lignedebutpage à lignefinpage
                    SommeMinHauteurLignes désigne la somme des MinHauteurLigne des lignes
                    d'indice de lignedebutpage à lignefinpage}

                    if IsPartitionDOrchestre then
                    if SommeMinHauteurLignes > 0 then
                    for ll := lignedebutpage to lignefinpage do
                           EtirerPorteesPixxY(ll, max(1, 0.9*hauteurpage / SommeMinHauteurLignes));




                    {là, on va uniformiser en y l'espacement de ces lignes pour que la mise
                     en page soit bien centré sur la page ipage

                     (on le fait pas si on est sur la dernière page}
                    if not OnPagineLaPageCarFinDuDocument then
                    if (lignefinpage > lignedebutpage) then
                    Begin
                        ydeb := (ipage) * hauteurpage;
                        //yfin := (ipage+1) * hauteurpage - minHauteurLigne(lignefinpage);

                        {on place alors un espacement constant entre les lignes, esp, qui vérifie
                          (n-1)*esp + somme des minhauteligne = hauteurpage}

                        minHauteurs := 0;
                        for ll := lignedebutpage to lignefinpage do
                              inc(minHauteurs,minHauteurLigne(ll));

                        esp := (HauteurPage - minHauteurs - (Lignes[lignedebutpage].pixy - ydeb))
                                                        div (lignefinpage - lignedebutpage);


                        {on déplace légerement les lignes...
                         - la première de rien du tout
                         - la deuxième de esp
                         - la troisième de 2 * esp
                         ...
                        }
                        for ll := lignedebutpage+1 to lignefinpage do
                             inc(Lignes[ll].pixy, (ll-lignedebutpage) * esp);

                        //Lignes[lignefinpage].pixy := (ipage+1) * hauteurpage - minHauteurLigne(lignefinpage);


                    End;

                    {on a fini de paginer la page ipage... passe à la page suivante}

                    if not OnPagineLaPageCarFinDuDocument then
                    Begin
                          inc(ipage);
                          y := (ipage) * hauteurpage;
                          lignedebutpage := l;
                          Lignes[l].pixy := y;
                          inc(y,minHauteurLigne(l));
                          SommeMinHauteurLignes := minHauteurLigne(l);
                    End;
                End;


            End;
       End;




     procedure Paginer_Verifier_PostConditions;
     var l: integer;
     Begin
          VerifierFlagsMesure;
          //post-conditions
          for l := 0 to high(Lignes) do
               VerifierIndiceMesure(Lignes[l].mdeb, 'Pagination !');
     End;




Begin
//préconditions
      MusicUser_Pourcentage_Init('Pagination');


      if lignefin_apriori > high(Lignes) then
            m_max_a_priori := high(Mesures)
      else
            m_max_a_priori := LignesMFin(lignefin_apriori);

      VerifierIndiceLigne(lignedebut, 'Paginer');
//fin préconditions


      SetMusicWriterCalcule;

      IGP := self;



      hmes := high(Mesures);

      //if optimisation_calculer_graphe_info_verticalite_notes then
      {bug ! non non,  on lance Compression_Mesures_Calculer tout le temps...
       en fait, ça buguait quand on supprimait des mesures au sein d'un groupe qui est compressé... flop...
       en effet, dans ce cas, on ne calcule pas mgoi mais bon... fo quand même recalculer les
       compressions de mesures}
           Compression_Mesures_Calculer;



      {on affiche toujours le rythme au début}
      Mesures[0].affRythmeDebut := true;



      {on place ici les mesures sur les lignes...
       Combien de mesures tiennent sur la première ligne ? la deuxième etc ? héhé ! :)}

      Paginer_CalculerLesMesuresEtLesPlacerSurDesLignes;
      TimerDebugger_FinEtape('calcmes');

      CalcPorteesPixy(lignedebut, lignefin_apriori {PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN});
      TimerDebugger_FinEtape('portees');

      Paginer_PlacerLesLignesSurDesPages;


      
      TimerDebugger_FinEtape('lignes');
      {on est dans Paginer}

      CalcQueue(lignedebut, lignefin_apriori); {A REVOIR... dans les partitions pianos, ya pa besoin
                     dans les partitions orchestres ya besoin
                     ça a certainement à voir avec le redispatchage des portées
                     au sein d'une ligne}




      {calcul des positions des octavieurs}
      Octavieurs_CalculerPosition;









      if (NbMesures = 1) then
      With GetMesure(0) do
          if IsVide then
          Begin
              pixWidth := COMPOSITION_VIDE_MESURE_SEULE_TAILLE;
              pixWidthWithoutTonalitesFin := pixWidth;
          End;


      Paginer_Verifier_PostConditions;
      MusicUser_Pourcentage_Free;

End;








procedure TCompositionAvecPagination.DrawMesure(mes: integer);
var p, v, i, voix_traitee, voix_premier_plan:integer;
    voix_is_accessible: Boolean;
    d: TRationnel;
    zp: integer;
    PU, PV: TArrayBool;


    procedure TextOut_CentreVerticalement(x, y: integer; str: string);
    Begin
        TextOut(x, y - 65, str);
    End;

    
    procedure Mesure_Tablatures_Afficher;
    var p, v, i, i_n, yy: integer;
    Begin
        C.Brush.Style := bsClear;
        //C.Brush.Color := CouleurFondEcran;
        SetFontSize(8);
        for p := 0 to NbPortees - 1 do
             if Portee_IsTablature(p) then
             With Mesures[mes] do
             for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
             Begin
                  if Get_N_Voix_Portee = p - 1 then
                  Begin
                      C.Font.Color := CouleurDessinVoixNote(IGP, Voix[v].N_Voix,
                                                            IsVoixAccessibleEdition(Voix[v].N_Voix));
                      
                      for i := 0 to high(ElMusicaux) do
                      with ElMusicaux[i] do
                        if not IsSilence then
                            for i_n := 0 to NbNotes - 1 do
                            With GetNote(i_n) do
                            if position.portee = p - 1 then
                            // test supplémentaire pour éviter les bugs
                            Begin
                                yy := GetY(tablature_position);
                                C.Brush.Style := bsSolid;
                                FillRect(pixx, yy-10, pixx+60, yy+10);
                                C.Brush.Style := bsClear;
                                TextOut_CentreVerticalement(pixx, yy,
                                                            inttostr(doigtee));
                            End;


                  End;
             End;
                 

                  

    End;



    Function Is_Presentation_NumerotationDesMesures(imes: integer): Boolean;
    Begin
        case option_Presentation_NumerotationDesMesures of
            pnmAucune: result := false;
            pnmToutesles5mesures: result := ((mes+1) mod AfficherNumMesureToutesLes = 0);
            pnmEnDebutDeLignes: result := imes = LignesMDeb(IGiLigne);
            pnmToutes: result := true;
            else
            Begin
                  MessageErreur('Erreur : Is_Presentation_NumerotationDesMesures !' +
                                'option_Presentation_NumerotationDesMesures a une valeur incorrecte !');
                  result := true;
            End;

        end;
    End;







Begin
    IGP := self;

    //préconditions
    VerifierIndiceMesure(mes, 'DrawMesure');
    VerifierIntegriteMesure(mes, 'DrawMesure');

    AfficherAvecUneAnimation := (mes = Animation_ElMusicaux_iMesure);

    CouleurDessin := CouleurStylo;
    C.Pen.Style := psSolid;
    C.Pen.Color := CouleurDessin;
    C.Brush.Style := bsSolid;
    C.Brush.Color := CouleurDessin;
    C.Font.Color := CouleurDessin;

    {barre de début de mesure}
    case Mesures[mes].BarreDebut of
         bBarreReprise:
             Begin
                   DrawBarBar(-15,15,self,IGiLigne);
                   SetGrosseurTrait(0);
                   DrawBar(40, self, IGiLigne);
                   for i := 0 to high(PorteesGlobales) do
                   Begin
                        Cercle(70, GetY(i,1),10);
                        Cercle(70, GetY(i,-1),10);
                   End;
             end;
    end;

    {si mesures compressés, on affiche le nombre de mesures}
    C.Brush.Style := bsClear;
    if Is_Presentation_NumerotationDesMesures(mes)
            and (Mesures[mes].NbMesuresCompressees > 0) then
    Begin
        SetFontSize(6);
        TextOut(0,0,inttostr(mes+1));

    End;

    With Mesures[mes] do
    Begin
        PU := PorteesUtiles(IGP.NbPortees);
        PV := IGP.PorteesVisibles(IGiLigne);

        if affRythmeDebut then
        Begin
            for p := 0 to high(Tonalites) do
            if not Portee_IsTablature(p) and PV[p] then
            Begin
                 zp :=  ZoomPortee(p);
                 SetFontSize(14 * zp div ZoomMaxPrec);
                 TextOut(pixXApresTonaliteDebut,
                         GetY(p, 4)-decalchiffrerythme * zp div ZoomMaxPrec,
                         inttostr(Rythme.num));

                 TextOut(pixXApresTonaliteDebut,
                         GetY(p, 0)-decalchiffrerythme * zp div ZoomMaxPrec,
                         inttostr(Rythme.denom));

            End;
        End;

        if affTonalitesDebut then
        Begin
                for p := 0 to high(Tonalites) do
                if not Portee_IsTablature(p) and PV[p] then
                     DrawTonalite(self, IGiLigne, 0, p, Clefs_Detecter( p, mes,Qel(1)), Tonalites[p], 0);

        end;

          ErreurDansMesure := false;

          CouleurDessin := CouleurStylo;



          voix_premier_plan := -1;
          //la variable voix_premier_plan est calculée dans la boucle !

          {affichage des différentes voix}
          For v := 0 to high(Voix) do with Voix[v] do
          if ((v = high(Voix)) and (voix_premier_plan > -1) ) or IsAffichee then
          Begin
                { le code entre les (*) sert à afficher la voix courante en dernier
                  pour qu'elle soit au premier plan.}

                {(*)}
                voix_is_accessible := IsVoixAccessibleEdition(Voix[v].N_Voix);
                voix_traitee := v;

                {le code place l'indice de la voix courante dans voix_premier_plan,
                 puis affiche a priori la dernière voix high(Voix)}
                if voix_premier_plan = -1 then
                     if voix_is_accessible then
                     Begin
                          voix_premier_plan := v;
                          voix_traitee := high(Voix);
                     End;

                {à la fin, on affiche la voix traitée à la place de la dernière,
                 déjà affichée}
                if (v = high(Voix)) and (voix_premier_plan > -1) then
                      voix_traitee := voix_premier_plan;

                {résumé : l'ordre d'affichage des voix n'est pas
                                 0, 1, ... voix_premier_plan... high(Voix)
                                 mais
                                 0, 1, ... high(Voix)... voix_premier_plan}
                {(*)}






                voix_is_accessible := IsVoixAccessibleEdition(Voix[voix_traitee].N_Voix);

                //TODO : faire que les notes non sélectionnés soient plus discrètes        
                CouleurDessin := CouleurDessinVoixNote(self, Voix[voix_traitee].N_Voix, voix_is_accessible);

                C.Brush.Style := bsSolid;
                C.Brush.Color := CouleurDessin;
                C.Pen.Color := CouleurDessin;
                C.Font.Color := CouleurDessin;

                {on affiche si la portée est visible}
                With Voix[voix_traitee] do
                    If IsAffichee then
                        D := DrawVoix(QMul(Mesures[mes].Rythme, Qel(4)));

                if(CDevice = devEcran) and IsModeCorrection then
                {affichage du petit panneau interdit qd ça dépasse...}
                if IsQ1StrInfQ2(QMul(Mesures[mes].Rythme, Qel(4)), D) then//si on a dépassé la mesure
                Begin
                    DrawBitmap(XATemps(QAdd(Qel(1),QMul(Mesures[mes].Rythme, Qel(4))))-80,
                               GetY(0,15),imgMesureSaturee,ZoomMaxPrec);
                End;
            
                if IsModeCorrection and
                   not IsQEgal(D, QMul(Mesures[mes].Rythme, Qel(4))) and
                   not IsQEgal(D, Qel(0))  then
                       ErreurDansMesure := true;
          End;

        {affichage des clefs intermédiaires}
        for i := 0 to high(ClefsInserees) do
            if PV[ClefsInserees[i].portee] then
            {on affiche que la clé que si elle repose sur une porté qui est affichée}
                 DrawClef(self, IGiLigne, ClefsInserees[i].pixx,
                          ClefsInserees[i].portee, ClefsInserees[i].clef);


        if affChgtTonalitesFin and (mes < high(Mesures)) then //dans ce cas, la mesure ne peut être la dernière mesure
        Begin
          C.Brush.Style := bsClear;
          for p := 0 to high(Tonalites) do if PV[p] then
                DrawTonalite(self, IGiLigne, pixWidthWithoutTonalitesFin, p, Clefs_Detecter(p, mes, Qel(1000)),Mesures[mes+1].Tonalites[p],
                                                                                             Tonalites[p]);

        end;


           CouleurDessin := CouleurStylo;
            C.Pen.Style := psSolid;
            C.Pen.Color := CouleurDessin;
            C.Brush.Style := bsSolid;
            C.Brush.Color := CouleurDessin;

            {barre de fin de mesure}
            if ErreurDansMesure and (cDevice = devEcran) then
            Begin
                C.Pen.Color := 255;
                DrawBarZigZag(Mesures[mes].pixWidth, self, IGiLigne);
                C.Pen.Color := 0;
            End
            else
            Begin
                  C.Pen.Color := 0;
                  case Mesures[mes].BarreFin of
                       bBarreSimple: DrawBar(Mesures[mes].pixWidth, self, IGiLigne);
                       bBarreDouble:
                           Begin
                                 DrawBar(Mesures[mes].pixWidth, self, IGiLigne);
                                 DrawBar(Mesures[mes].pixWidth-30, self, IGiLigne);
                           end;

                       bBarreReprise:
                           Begin
                                 DrawBarBar(Mesures[mes].pixWidth-15,Mesures[mes].pixWidth+15,self,IGiLigne);
                                 SetGrosseurTrait(0);
                                 DrawBar(Mesures[mes].pixWidth-40, self, IGiLigne);
                                 for i := 0 to high(PorteesGlobales) do
                                 Begin
                                      Cercle(Mesures[mes].pixWidth-70, GetY(i,1),10);
                                      Cercle(Mesures[mes].pixWidth-70, GetY(i,-1),10);
                                 End;
                           end;
                  end;
            end;

            AfficherAvecUneAnimation := false;
            {à partir de là, plus rien est animé
             (et surtout pas les pauses qui complètent les portées vides !!!}

            if NbMesuresCompressees > 1 then
            {affiche le nombre de mesures compressées}
            Begin
                C.Brush.style := bsClear;
                C.Font.Style := [fsBold];
                for p := 0 to high(Tonalites) do if PV[p] then
                Begin
                         SetFontSize(AuZoomPortee(16,p));
                         TextOut(pixWidth div 2,
                                 GetY(p,3),
                                 inttostr(NbMesuresCompressees));
                End;
                C.Font.Style := [];
            End
            else
                {on dessine les pauses qui complètent les portées vides}

                    if IGP = nil then
                    Begin
                        MessageErreur('Erreur : IGP = nil... on remet...');
                        IGP := self;
                    End;

                    
                    For p := 0 to high(PorteesGlobales) do
                    if PV[p] and not PU[p] and not Portee_IsTablature(p) then
                          Begin
                              el_mus_Pause_PourPorteesVide.position.Portee := p;
                              el_mus_Pause_PourPorteesVide.pixx := pixWidthWithoutTonalitesFin div 2;
                              DrawElMusical(self, IGiLigne, el_mus_Pause_PourPorteesVide, false, false);

                          End;

            Mesure_Tablatures_Afficher;

    end; {with Mesures[mes]}

    Finalize(PU);
    Finalize(PV);


End;



Function TCompositionAvecPagination.PointInMesureToPointInPage(m: integer; p: TPoint): TPoint;
{le point p représente des coordonnées dans le repère de la mesure m.
 Cette fonction transforme "p" en coordonnées dans la page}
var mespixy: integer;
Begin
    if IsIndiceMesureValide(m) then
    Begin
        result.x := p.x + Mesures[m].pixX;

        mespixy := Lignes[LigneAvecMes(m)].pixY;
        result.y := p.y + mespixy;
    end
    else
        result := p;
End;


Function TCompositionAvecPagination.RectInMesureToRectInPage(m: integer; r: TRect): TRect;
{même principe que PointInMesureToPointInPage sauf que c'est pour un rectangle r}
var mespixy: integer;
Begin
    if IsIndiceMesureValide(m) then
    Begin
          result.Left := r.Left + Mesures[m].pixX;
          result.Right := r.Right + Mesures[m].pixX;

          mespixy := Lignes[LigneAvecMes(m)].pixY;
          result.Top := r.Top + mespixy;
          result.Bottom := r.Bottom + mespixy;
    end
    else
          result := r;

End;





Function TCompositionAvecPagination.PauseSousCurseur(X, Y: integer; var elm: TElMusical): Boolean;
{on lui donne X et Y dans le doc virtuel}
var m: integer;

Begin
      elm := nil;
      IGP := self;

      if FindMesure2(X, Y, IGiLigne, m) then
          result := GetMesure(m).PauseSousCurseur(X, Y, elm)

      Else
          result := false;


End;




Function TCompositionAvecPagination.QueueSousCurseur(X, Y:integer; var el:TElmusical): Boolean;
{on lui donne X et Y dans le doc virtuel
         renvoit true si une note est trouvée

 Attention : la note doit figurer dans une voix accessible à l'édition

         }

var iligne, m, v, i: integer;
    pos: TPosition;
    ns: TElMusical;
Begin

if FindMesure2(X, Y, iligne, m) then
Begin
      GetPosition(Y, self, iligne, pos);

      For v := 0 to high(Mesures[m].Voix) do with Mesures[m].Voix[v] do if IsAffichee then
            if IsVoixAccessibleEdition(N_Voix) then
            For i := 0 to high(ElMusicaux) do
                 if not ElMusicaux[i].IsSilence then
                 Begin
                      ns := ElMusicaux[i];

                      if (abs(ns.GetXQueue - X) < 3) and
                            (abs(ns.YExtremiteQueue - Y) < 3) then
                      Begin
                           el := ns;
                           result := true;
                           Exit;
                      end;
                 End;

End;

result := false;

End;


Function TCompositionAvecPagination.NoteSousCurseur(X, Y:integer; var el: TElMusical;
                                                    var n:TPNote): Boolean;
{on lui donne X et Y dans le doc virtuel
         renvoit true si une note est trouvée

 Attention : la note doit figurer dans une voix accessible à l'édition

         }

var iligne, m, v, i, j: integer;
    pos: TPosition;
    ns: TElMusical;
Begin

n := nil;

if FindMesure2(X, Y, iligne, m) then
Begin
      IGP := self;
      IGiLigne := iligne;
      result := GetMesure(m).NoteSousCurseur(X, Y, el, n);
End
else
      result := false;

End;




Function TCompositionAvecPagination.GetBarreDeMesureSousXY_iMesure(X, Y: integer): integer;
const epsilon = 23;

var iligne, m:integer;
Begin
     if FindMesure2(X, Y, iligne, m) then
     Begin
          if abs(X) < epsilon then
              result := m
          else if ( abs(X - GetMesure(m).pixWidth) < epsilon ) then
              result := m+1
          else
              result := -1;
     End
     else
          result := -1;

     if result = 0 then
         result := -1;
End;





procedure TCompositionAvecPagination.VerifierIndiceLigne(var iLigne: integer;
                                                         mess: string);
Begin
      if (iLigne < 0) or (iLigne > High(Lignes)) then
      Begin
            MessageErreur('Indice de ligne incorrect : iLigne = '
                        + IntToStr(iLigne) +' alors que les indices '
                        + 'valides vont de 0 à ' + inttostr(high(Lignes)) +
                        '. On le met à 0. ' + mess);
            iLigne := 0;
      End;

End;


Function TCompositionAvecPagination.IsIndiceLigneValide(iLigne: integer): Boolean;
Begin
    result := (0 <= iligne) and (iligne <= high(Lignes));
End;

procedure TCompositionAvecPagination.VerifierIndiceLigneOrNOP(var iLigne: integer;
                                                         mess: string);
Begin
      if (iLigne < -1) or (iLigne > High(Lignes)) then
      Begin
            MessageErreur('Indice de ligne incorrect : iLigne = '
                        + IntToStr(iLigne) +' alors que les indices '
                        + 'valides vont de 0 à ' + inttostr(high(Lignes)) +
                        '. On le met à 0. ' + mess + '(rem : on autorise ici les indices à -1)');
            iLigne := 0;
      End;

End;



procedure TCompositionAvecPagination.RendreIndiceLigneValide(var iligne: integer);
Begin
     if iLigne > high(Lignes) then
          iLigne := high(Lignes)
     else if iLigne < 0 then
          iLigne := 0;
          
     VerifierIndiceLigne(iLigne, 'postcondition dans TCompositionAvecPagination.RendreIndiceLigneValide');
End;

Function TCompositionAvecPagination.LignePlusProcheAvecY(y: integer): integer;
{recherche de la ligne en cours
 renvoie TOUJOURS un indice de ligne valide}
Begin
     result := max(0, LigneAvecY(y));

     VerifierIndiceLigne(result, 'postcondition LignePlusProcheAvecY');
End;


Function TCompositionAvecPagination.LigneAvecY(y: integer): integer;
{recherche de la ligne en cours
renvoie -1 ssi on est dans la zone de titre...}



var lm:integer;
    b, d, moybd: integer;
Begin

        {rem : cette recherche est faite de manière dichotomique}
        lm := -1;
        if y > YTitre + HTitre div 2 then
        //if y < Lignes[high(Lignes)].pixy + minhauteurligne(high(Lignes)) then
        Begin
            b := 0;
            d := high(Lignes);
            //par dichotomie
            while d - b > 1 do
            Begin
                moybd := (b + d) div 2;
                if (y >= Lignes[moybd].pixy) then
                      b := moybd
                else
                      d := moybd;

            End;

            if (y >= Lignes[d].pixy) then
                  lm := d
            else
                  lm := b;

            {for l := high(Lignes) downto 0 do
                    if (y >= Lignes[l].pixy) then
                    Begin
                           lm := l;
                           Break;
                    end;  }
        End;

        result := lm;
End;




Function TCompositionAvecPagination.LigneAvecMes(m: integer): integer;
{à partir de l'indice m d'une mesure, on retrouve le n° de la ligne dans
 laquelle elle se trouve}
var l, lm:integer;
Begin
lm := -1;
//TODO : DICHOTOMIE !!!!!!!!!!!!!
for l := high(Lignes) downto 0 do
        if (m >= Lignes[l].mdeb) then
        Begin
               lm := l;
               Break;
        end;
result := lm;
End;

Procedure TCompositionAvecPagination.SetOriginMesure(m: integer);
var lm: integer;
Begin
      if m >= length(Mesures) then
      Begin
            m := high(Mesures);
            pixxorigin := Mesures[m].pixX + Mesures[m].pixWidth;
            lm := LigneAvecMes(m);
            pixyorigin := Lignes[lm].pixy;
      End
      else if IsIndiceMesureValide(m) then
      Begin
            pixxorigin := Mesures[m].pixX;
            lm := LigneAvecMes(m);
            pixyorigin := Lignes[lm].pixy;
      End
      else
      //si l'indice de mesure est invalide
      Begin
            pixxorigin := 0;
            pixyorigin := 0;
      End;

End;









Function TCompositionAvecPagination.AlterationLocale(m: integer; temps: TRationnel;
                                       pos: TPosition): TAlteration;
{calcule l'alteration qu'aurait une note sans altération visible
 (pas de # apparent) etc si elle était en position pos, au temps temps
 dans la mesure m.

 Cette procédure l'appel préalable de CreerGraphOrdreInfo car elle utilise mgoi.

 Cette procédure utilise les informations de :
   - Clés insérées pour savoir qd arrêter l'information des altérations
   - mgoi pour savoir les notes déjà insérées et donc déduire l'altération
     courante
   - la tonalité courante à la clef}

var clef: TClef;
    portee, i, j, k, n: integer;
    tempsdepart: TRationnel;
    alt: TAlteration;
    yab: Boolean;

Begin
       try
       {si on se trouve à la toute fin de la partition,
        on fait comme si on était à la fin de la dernière mesure}
       if not IsIndiceMesureValide(m) then
       Begin
           m := high(Mesures);
           temps := QInfini;
       End;

       if pos.portee < 0 then pos.portee := 0;

       //détecter la clé, et son temps
       portee := pos.portee;
       clef :=  Clefs_Detecter(portee, m, Qel(1));
       tempsdepart := Qel(1);


       with GetMesure(m) do
       Begin
               for i := high(ClefsInserees) downto 0 do
                       if (ClefsInserees[i].portee = portee) and
                                  IsQ1InfQ2(ClefsInserees[i].temps, temps) then
                                      Begin
                                          tempsdepart := ClefsInserees[i].temps;
                                          clef := ClefsInserees[i].Clef;
                                          Break;
                                      End;




               {D'après la tonalité dans la mesure, on en déduit l'altération
               par défaut. Par exemple en sol majeur, un fa sans dièse apparent
               est diésé.}
               alt := AlterationAvecTonalite(HauteurGraphiqueToHauteurAbs(ClefToInfoClef(clef), pos.hauteur),
                                             Tonalites[pos.portee]);


               //du temps en cours vers le temps de départ, on regarde l'altération courante
               yab := false;
               for i := high(mgoi) downto 0 do
               Begin
                   if IsQ1StrInfQ2(mgoi[i].t, tempsdepart) then
                            Break;

                   if IsQ1StrInfQ2(mgoi[i].t, temps) then
                   Begin
                       for j := 0 to high(mgoi[i].elms) do
                       Begin
                            for k := high(mgoi[i].elms[j]) downto 0 do
                               for n := 0 to high(mgoi[i].elms[j][k].notes) do
                                         if IsPositionsEgales(mgoi[i].elms[j][k].notes[n].position, pos) then
                                         Begin
                                                 alt := mgoi[i].elms[j][k].notes[n].hauteurnote.alteration;
                                                 yab := true;
                                                 Break;
                                         end;
                             if yab then break;
                       End;

                   End;

                   if yab then break;
         End;

       End;



result := alt;
        except
       end;
End;




procedure TCompositionAvecPagination.CalcGraphMesure(m: integer;
               optimisation_calculer_graphe_info_verticalite_notes: Boolean);
var t: TRationnel;
    v, i, n: integer;
    altmilieu: TAlteration; //altération du "milieu" en cours
    infoclef: TInfoClef;
    optimisation_is_groupes_notes_calculer: Boolean;

const pixWidthMesureCompressee = 1000;

Begin

optimisation_is_groupes_notes_calculer := optimisation_calculer_graphe_info_verticalite_notes;
{optimisation_calculer_graphe_info_verticalite_notes est vrai en gros si on a modifié
  des notes dans cette mesure

  Si on a pas modifier les notes, pas besoin de recalculer les groupes de notes}



VerifierIndiceMesure(m, 'CalcGraphMesure');

IGP := self;
IGiLigne := LigneAvecMes(m);


    with GetMesure(m) do
    Begin


          {la mesure s'affiche et NbMesuresCompressees = 1}

          if optimisation_calculer_graphe_info_verticalite_notes then
          Begin
              Nettoyer;
              CreerGraphOrdreInfo; //à appeler pour avoir la base de calcul dans "mgoi"
          End;
          //calcule l'affichage ou non des #, b, bécar...
          for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
          Begin
                t := QUn;

                for i := 0 to high(ElMusicaux) do
                Begin
                       for n := 0 to high(ElMusicaux[i].Notes) do
                       Begin
                              altmilieu := AlterationLocale(m, t,
                                                ElMusicaux[i].Notes[n].Position);
                              ElMusicaux[i].Notes[n].AfficherAlteration :=
                                  altmilieu <> ElMusicaux[i].Notes[n].hauteurnote.Alteration;
                       End;
                       QInc(t, ElMusicaux[i].Duree_Get);
                End;



          End;





    {Calcul des position.hauteur (position graphique) à partir de la hauteur
     véritable des notes. Pour cela on utilise HauteurAbsToClef

     -> pour cela utilise l'information des clés}


     for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
          Begin
                t := Qun;
                for i := 0 to high(ElMusicaux) do
                with ElMusicaux[i] do
                Begin
                      for n := 0 to high(Notes) do
                      with Notes[n] do
                      Begin
                           infoclef := InfoClef_Detecter( position.portee, m,t);
                           position.hauteur := HauteurAbsToHauteurGraphique(infoclef, hauteurNote.Hauteur);

                      End;
                      QInc(t, Duree_Get);
                End;
          End;

          for i := 0 to high(mgoi) do
              mgoi[i].Silences_Position_Corriger;

          if (m < high(Mesures)) and AffChgtTonalitesFin then
                CalcGraphSub(DeltaXTonalites(Mesures[m+1].Tonalites, Tonalites), m,
                             optimisation_is_groupes_notes_calculer)
          else

                CalcGraphSub(0, m,
                             optimisation_is_groupes_notes_calculer);


          {correction d'un bug le 5 janvier 2007 !!
           je mets ça à la fin... tant pis ça fait avant
           peut-être des calculs pour rien... mais c'est du 0(1)
           si NbMesuresCompressees > 1 ou NbMesuresCompressees = 0
           puisqu'il n'y a pas de notes dans ces mesures !!

           le bug était le suivant : mgoi était erroné !
           et ça faisait planter AlterationLocale... un truc qui n'a rien à voir !}

          if NbMesuresCompressees > 1 then
          {cette mesure et les NbMesuresCompressees-1 mesures suivantes sont
           compressées en une seule qui fait pixWidthMesureCompressee de large}
               pixWidth := pixWidthMesureCompressee

          else if NbMesuresCompressees = 0 then
          {le contenu de cette mesure ne s'affiche pas puisqu'elle fait partie
           d'un pack de mesures compressées ensemble et que ce n'est pas la première
           du pack}
          Begin
               pixWidth := 0;

               if m < high(Mesures) then
                   pixWidthWithoutTonalitesFin := -margefinale2
                           - DeltaXTonalites(Mesures[m+1].Tonalites, Tonalites);


          End;

    End; //with GetMesure(m) do
End;




Function TCompositionAvecPagination.minHauteurLigne(iLigne: integer): integer;
var hp: integer;
Begin
    VerifierIndiceLigne(iLigne, 'minHauteurLigne');

    hp := high(PorteesGlobales);
    result := PorteesPixy[iLigne][hp+1];

    {la hauteur de la ligne est stockée dans PorteesPixy[iLigne][hp+1]. Cela est
     calculé dans CalcPorteesPixy}

    //PorteesPixy[iLigne][hp] - PorteesPixy[iLigne][0] + nbpixentreportee2 + margehaut;
End;


Procedure TCompositionAvecPagination.IntervalleiLignesurPage(iPage: integer;
                                               var iLigne1, iLigne2: integer);
{permet de savoir quelles portées sont affichées sur la page iPage...
 cette procédure renvoie iLigne1, iLigne2 qui représente respectivement
 la première ligne de la page et la dernière ligne de la page}

var i:integer;
Begin
     iLigne1 := -1;
     iLigne2 := -1;
     for i := 0 to high(Lignes) do
     Begin
         if Lignes[i].pixy < (iPage+1) * HauteurPage then
               iLigne2 := i;

         if (Lignes[i].pixy >= (iPage) * HauteurPage) and (iLigne1 = -1) then
              iLigne1 := i;
     End;

End;


Function TCompositionAvecPagination.iPageFromiLigne(iLigne: integer): integer;
Begin


    if iLigne < 0 then
         result := -1
    else
    Begin
         VerifierIndiceLigne(iLigne, 'iPageFromiLigne');
         result := Lignes[iLigne].pixy div HauteurPage;
    End;
End;










Function TCompositionAvecPagination.PorteesVisibles(iLigne: integer): TArrayBool;
var P,Q: TArrayBool;
    i,m,nbp: integer;
    b: Boolean;

    Function IsVoixAffiche(i: integer): Boolean;
    Begin
         if ViewCourant = nil then
              result := true
         else
              result := ViewCourant^.VoixAffichee[i];
    End;

    
Begin
    VerifierIndiceLigne(iLigne, 'PorteesVisibles');

    nbp := length(PorteesGlobales);
    SetLength(Q, nbp);

    if (ModeAffichage = maPage) and (CDevice <> devApercu) then
    Begin

        for i := 0 to nbp-1 do
        Begin
            if ((PorteesGlobales[i].Visible = pvAlways) or
            ((PorteesGlobales[i].Visible = pvHiddenWhenEmptyExceptOnFirstLine))
            and (iLigne = 0))
            and IsVoixAffiche(i) then

                   Q[i] := true
            else
                  Q[i] := false;


        End;


        for m := Lignes[iLigne].mdeb to LignesMFin(iLigne) do
        Begin
             P := Mesures[m].PorteesUtiles(nbp);
             for i := 0 to nbp-1 do
                  Q[i] := Q[i] or P[i];

             Finalize(P);
        End;



    End
    else {dans le mode ruban ou le mode page pour l'édition, on ne tient pas
         compte des notes pour dire si une portée est visible ou non...
         par défaut elle l'est}
        for i := 0 to nbp-1 do
              Q[i] := true;



    {test de globalité pour savoir si une portée est visible ou non}
    for i := 0 to nbp-1 do
            if not Portee_IsVisible(i) then
                Q[i] := false;

                
    {si tout Q est rempli de faux, met un true dans Q[0]... pour afficher qd même
     quelque chose de la ligne !! (si tu supprimes ça, le reste du programme plante
     car il suppose que pour toute ligne, au moins une portée est affichée.. (hypothèse
     pas totalement débile) }
    b := false;
    for i := 0 to nbp-1 do
    Begin
            b := Q[i] or b;
            if b then break;
    End;
    if not b then
      Q[0] := true;


    result := Q;
End;


Procedure TCompositionAvecPagination.CalcPorteesPixy(iligne1, iligne2: integer);
{calcule les positions y des portées}
const decalporteesiqueue = 7;
      decalporteesipasqueue = 1;


var i, ifingroupe, l, m, v, y,
    hp {nb de portées},
    pp: integer;
    PV: TArrayBool;
    incapres: integer; {incrémentation à "retardement"}
    //premierporteeaffichee: Boolean;
    minpos, maxpos : array of integer;

    
Begin
      IGP := Self;
      hp := high(PorteesGlobales);

      if length(PorteesPixy) <> length(Lignes) then
          Setlength(PorteesPixy, length(Lignes));

      Setlength(minpos, hp+1);
      Setlength(maxpos, hp+1);

      for l := iligne1 to min(iligne2, high(Lignes)) do
      Begin
          {calcul la position des portées sur la ligne n° l}
          PV := PorteesVisibles(l);

          if ModeAffichage = maRuban then
          {dans le mode ruban, mode d'édition par excellence, les portées sont
           espacés uniformément}
                for i := 0 to hp do
                Begin
                   if (ModeAffichage = maRuban) and IsPartitionDOrchestre then
                   Begin
                       if (i = iPorteeCourant){ and not IsMusicWriterCalcule}  then
                       Begin
                           minpos[i] := -20;
                           maxpos[i] := 20;
                       End
                       else
                       Begin
                           minpos[i] := -10;
                           maxpos[i] := 10;
                       End;
                   End
                   else
                   Begin
                       minpos[i] := -20;
                       maxpos[i] := 20;

                   End;

                End
          else
          Begin
              for i := 0 to hp do
              Begin
                       minpos[i] := -10;
                       maxpos[i] := 10;
              End;

              for m := Lignes[l].mdeb to LignesMFin(l) do with Mesures[m] do
                  for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
                        for i := 0 to High(ElMusicaux) do with ElMusicaux[i] do
                        if IsSilence then
                        Begin
                              if minpos[position.portee] > position.hauteur then
                                        minpos[position.portee] := position.hauteur;

                                   if maxpos[position.portee] < position.hauteur then
                                        maxpos[position.portee] := position.hauteur;

                        end
                        else
                        Begin
                              if QueueVersBas then
                                   pp := -decalporteesiqueue
                              else
                                   pp := -decalporteesipasqueue;

                              with Notes[0] do
                              Begin
                                   if minpos[position.portee] > position.hauteur + pp then
                                        minpos[position.portee] := position.hauteur + pp;
                              End;

                              if QueueVersBas then
                                   pp := decalporteesipasqueue
                              else
                                   pp := decalporteesiqueue;

                              with Notes[high(Notes)] do
                              Begin
                                   if maxpos[position.portee] < position.hauteur + pp then
                                        maxpos[position.portee] := position.hauteur + pp;
                              End;


                        End;

          End;
          {à partir de là, les tableaux minpos et maxpos sont calculés}


          if length(PorteesPixy[l]) <> hp+2 then
               setlength(PorteesPixy[l], hp+2);
          { PorteesPixy[l][hp+1] contient la hauteur de la portée}

          y := 0;
          //premierporteeaffichee := true;
          incapres := 0;
          ifingroupe := -1;

          for i := 0 to hp do
          Begin

              if PV[i] or (i > ifingroupe) then
              Begin
                    inc(y, incapres);
                    incapres := 0;

                    if i > ifingroupe then
                         ifingroupe := i + PorteesGlobales[i].nbPorteesGroupe;
              End;

              if {(not premierporteeaffichee) and} PV[i] then
                  inc(y, maxpos[i] * nbpixlign * ZoomPortee(i) div ZoomMaxPrec);

              PorteesPixy[l][i] := y;

              if PV[i] then
              Begin
                    incapres := -minpos[i] * nbpixlign * ZoomPortee(i) div ZoomMaxPrec;
                    {on incrémentera plus tard}
                    //premierporteeaffichee := false;
              End;
          End;

          inc(y, incapres);
          PorteesPixy[l][hp+1] := y;

          Finalize(PV);

      End;


      Finalize(minpos);
      Finalize(maxpos);

End;


Procedure TCompositionAvecPagination.EtirerPorteesPixxY(l: integer; e: real);
var i: integer;
Begin
//préconditions
      VerifierIndiceLigne(l, 'EtirerPorteesPixxY');

      
      if e < 1.0 then
           MessageErreur('facteur d''étirement dans EtirerPorteesPixxY est plus petit que 1');

      for i := 0 to NbPortees do
          PorteesPixy[l][i] := round(e * PorteesPixy[l][i]);

      {oui i = NbPortees est possible car PorteesPixy[l][NbPortees] code la hauteur
       de la ligne (calculée dans CalcPorteesPixy}

End;







Function TCompositionAvecPagination.PremierePorteeAffichee(iLigne: integer): integer;
var P: TArrayBool;
    i:integer;
Begin
   VerifierIndiceLigne(iLigne, 'PremierePorteeAffichee');

   result := -1;
   P := PorteesVisibles(iLigne);
   for i := 0 to high(PorteesGlobales) do
         if P[i] then
         Begin
             result := i;
             Break
         End;
end;


Function TCompositionAvecPagination.DernierePorteeAffichee(iLigne: integer): integer;
var P: TArrayBool;
    i:integer;
Begin
   VerifierIndiceLigne(iLigne, 'DernierePorteeAffichee');

   result := -1;
   P := PorteesVisibles(iLigne);
   for i := high(PorteesGlobales) downto 0 do
         if P[i] then
         Begin
             result := i;
             Break
         End;
end;



Function TCompositionAvecPagination.Portee_YHaut(iLigne: integer; iPortee: integer): integer;
Begin
   VerifierIndiceLigne(iLigne, 'Portee_YHaut');
   result := Lignes[iLigne].pixy;//; + GetY(self, iLigne, iPortee, 10);
End;


Function TCompositionAvecPagination.Portee_YBas(iLigne: integer; iPortee: integer): integer;
Begin
   VerifierIndiceLigne(iLigne, 'Portee_YBas');
   result := Lignes[iLigne].pixy + GetY(self, iLigne, iPortee, -10);
End;



Function TCompositionAvecPagination.Portee_YHaut_Barre_InRepere_Ligne(iLigne: integer; iPortee: integer): integer;
Begin
   VerifierIndiceLigne(iLigne, 'Portee_YHaut_Barre_InRepere_Ligne');
   result := GetY(self, iLigne, iPortee, 4);
End;



Function TCompositionAvecPagination.Portee_YBas_Barre_InRepere_Ligne(iLigne: integer; iPortee: integer): integer;
Begin
   VerifierIndiceLigne(iLigne, 'Portee_YBas_Barre_InRepere_Ligne');

   if Portee_IsTablature(iPortee) then
       result := GetY(self, iLigne, iPortee, -6)
   else
       result := GetY(self, iLigne, iPortee, -4);
End;


{lignes...}

Function TCompositionAvecPagination.Ligne_YHaut(iLigne: integer): integer;
Begin
   VerifierIndiceLigne(iLigne, 'Ligne_YHaut');
   result := Portee_YHaut(iLigne, PremierePorteeAffichee(iLigne));
End;


Function TCompositionAvecPagination.Ligne_YBas(iLigne: integer): integer;
Begin
   VerifierIndiceLigne(iLigne, 'Ligne_YBas');
   result := Portee_YBas(iLigne, DernierePorteeAffichee(iLigne));
End;


Function TCompositionAvecPagination.Ligne_XGauche(iLigne: integer): integer;
Begin
    VerifierIndiceLigne(iLigne, 'Ligne_XGauche');
     result := GetMesure(Lignes[iLigne].mdeb).pixx - margepourmesure;
End;


Function TCompositionAvecPagination.Ligne_XDroite(iLigne: integer): integer;
Begin
     result := largutilisable;
End;



{mesures...}

Function TCompositionAvecPagination.Mesure_XGauche(iMesure: integer): integer;
Begin
    result := GetMesure(iMesure).pixx;
End;


Function TCompositionAvecPagination.Mesure_XDroite(iMesure: integer): integer;
Begin
    with GetMesure(iMesure) do
        result := pixx + pixWidth;
End;



Function TCompositionAvecPagination.Mesure_YHaut(iMesure: integer): integer;
Begin
    result := Ligne_YHaut(LigneAvecMes(iMesure));
End;


Function TCompositionAvecPagination.Mesure_YBas(iMesure: integer): integer;
Begin
    result := Ligne_YBas(LigneAvecMes(iMesure));;
End;




procedure TCompositionAvecPagination.CalcQueue(l1, l2: integer);
var l,m:integer;
Begin


    for l := l1 to l2 do
    Begin
          IGiLigne := l;
          for m := Lignes[l].mdeb to LignesMFin(l) do
                    Mesures[m].CalcQueue;
    End;
End;













initialization
      el_mus_Pause_PourPorteesVide := CreerElMusicalPause(Qel(4), 0);


finalization
      el_mus_Pause_PourPorteesVide.Free;

end.
