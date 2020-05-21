unit MusicSystem_Mesure;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Types,
     MusicHarmonie,
     MusicSystem_MesureBase,
     MusicSystem_MesureAvecClefs;







type




T1MGOInfo = class(TObject)
{un objet T1MGOInfo recense tous les el. musicaux qui sont sur le même temps.
 Très souvent, tout cela est stockée dans le tableau elms[0].
 Mais très rarement, il arrive que deux él. musicaux sont sur le même temps
 et se chevauchent (un do et un ré sur deux voix différentes par exemple...)
 le do et le ré sont alors référencé dans deux plans différents :
      elms[0] et elms[1] par exemple}

      t: TRationnel;
      elms: array of array of TElMusical;

      Procedure AddElMusical(el: TElMusical);
      {ajoute de manière intelligente l'objet musical au T1MGOInfo
      intelligence, ça signifie que ça gère les chevauchements}
      Function GetX_in_mes: integer;

      Procedure Silences_Position_Corriger;


end;


{représente dans quel ordre en x afficher les el. musicaux}
TMesureGraphOrdreInfo = array of T1MGOInfo;


TBarre = (bBarreSimple, bBarreDouble, bBarreReprise);


TTonalites = array of Shortint;



TMesure = class(TMesureAvecClefs)
private
      enlargment: integer;


public
       mgoi: TMesureGraphOrdreInfo;

       pixX,
       pixXApresTonaliteDebut,
       pixXApresTonaliteDebutEtRythme,
       pixWidthWithoutTonalitesFin, pixWidth: integer;





       Tempo: string;
       Metronome: integer;

       BarreDebut, BarreFin: TBarre;

       Tonalites: TTonalites;
       affTonalitesDebut, affChgtTonalitesFin, affRythmeDebut: boolean;


       ErreurDansMesure: Boolean; {vaut vrai si des voix ne sont pas complétés
                                   etc...}

       NbMesuresCompressees: integer; //par défaut vaut 1 !!!




       Function mgoi_TempsToIndicemgoiApres(temps: TRationnel): integer;
       Function mgoi_TempsToIndicemgoiAvant(temps: TRationnel): integer;
       
       procedure CalcGraphSub(margefinalepourtonalitesuivante: integer; mesure_numero: integer;
                             optimisation_is_groupes_notes_calculer: Boolean);

       Procedure CalcQueue;
       procedure CalcBoules;

       Function TempsAX(x: integer): TRationnel;

       Function TempsAX2(x: integer): TRationnel;

       Function XATemps(t: TRationnel): integer;
       {sert pour :
             - afficher la barre MIDI
             - afficher la barre pour déplacer des notes complétement ailleurs
             - Deviner ou va se mettre la barre de mesures qu'on veut insérer
             }

       Function XATempsOuEntre(t: TRationnel): integer;


       Function X_Entre_ATemps(t: TRationnel): integer;

       procedure Save(nbporteecourant: integer);
       Procedure CopieSelectionToPressePapier(PP: TMesure);
       Procedure CopieObjectMesureEnDeselectionnant(var M: TMesure);


       Procedure GraphEtirer(rapport: real);
       Procedure CalcGrpNotes(DureeGrpNote: TRationnel);

       Procedure CreerGraphOrdreInfo;

       Function NoteSousCurseur(X, Y:integer; var el: TElMusical;
                                               var n:TPNote): Boolean;

       Function PauseSousCurseur(X, Y: integer; var elm: TElMusical): Boolean;

       Function DonnerNumVoixSousCurseur(X, Y: integer; out Voixtrouvee: integer): Boolean;
       Procedure DonnerNumVoixPresCurseur(X, Y: integer; out Voixtrouvee: integer); overload;
       Procedure DonnerNumVoixPresCurseur(X: integer; pos: TPosition; out Voixtrouvee: integer); overload;

       Function RienAAfficher: Boolean;

       Function MemeStyleQue(m: TMesure): Boolean;


       Function PorteesUtiles(nbporteecourant: integer): TArrayBool;
       
       Function Is_Portee_Utile(iportee: integer): Boolean;
       {renvoie vrai ssi il y a des trucs écrits dans la portée iportee
        en somme ça renvoie PorteesUtiles(...)[iportee]... mais c'est plus rapide}

       Function GetPortee_Utile_Min_iPortee: integer;
       {renvoie l'indice de portées le plus petit utilisé dans les él. musicaux présents
 dans la mesure}

 
       Procedure RemplirLastPixx;

       Procedure CalcQueuePositionAutomatiquement;

       
       procedure SelectionnerTout;
       Function Selection_Valider: Boolean;

       procedure NoteSilence_Fusionner_Si_SilenceCourt;
       procedure SimplifierEcriture;

       procedure SetTonalite(tona: TTonalite);
       Function GetTonalite: TTonalite;

       procedure InsererElMusicalAuTemps_AlaFin(t1: TRationnel; el: TElMusical);

       Procedure RegleMesure_DeplacerTic(temps1, temps2: TRationnel);
       Procedure RegleMesure_Etirer(temps_debut, temps1, temps2: TRationnel);

       Procedure Durees_Inferences_EtirerAuRythmeMesure_Et_Inferer;
       Procedure Durees_Inferences_Inferer;

       constructor Create;
       Destructor Destroy; override;



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
  MusicSystem_ElMusical_Duree {ModeNuances...},
  Interface_Questions;


     
//T1MGOInfo (type abstrait pour calculer l'affichage}
//******************************************************************************

Function T1MGOInfo.GetX_in_mes: integer;
Begin
     result := 0;
     if Length(elms) = 0 then
         MessageErreur('T1MGOInfo.GetX_in_mes : Length(elms) = 0')
     else
     Begin
          if Length(elms[0]) = 0 then
                  MessageErreur('T1MGOInfo.GetX_in_mes : Length(elms[0]) = 0')
          else
               Result := elms[0][0].pixx;
     End;
End;

Procedure T1MGOInfo.AddElMusical(el: TElMusical);
var i,j: integer;
    creernvboite: boolean;
Begin
    VerifierElMusical(el, 'AddElMusical');


    if high(elms) = -1 then
          creernvboite := true
    else
    Begin

          //on parcourt les "plans"
          for i := 0 to high(elms) do
          Begin
              creernvboite := false;

              //on parcourt les éléments du plan n° i
              for j := 0 to high(elms[i]) do
                     if not ElMusicauxCanBeDrawnOnSameX(el, elms[i][j]) then
                     Begin
                             creernvboite := true; // a priori il faut créer une nouvelle boite
                             Break;
                     End;

              if not creernvboite then
                   Break;        {si creernvboite = false, alors on peut placer
                                     l'él. musical el dans le plan n° i}
          End;

    End;

    if creernvboite then
    //si l'él. musical chevauche avec un autre, on le stocke sur un nouveau "plan"
    Begin
           setlength(elms, length(elms)+1);
           i := high(elms);
    End;

    {on ajoute l'élément el au plan n° i}
    setlength(elms[i], length(elms[i])+1);
    elms[i][high(elms[i])] := el;



End;


Procedure T1MGOInfo.Silences_Position_Corriger;
{évite que des silences se superposent à des notes ou à d'autres silences}
const max_score_poureviter_boucler = 10;

var i, j, k:integer;
    bon: boolean;

    position_initiale, pos_vers_lehaut: TPosition;
    score_vers_lehaut: integer;

    pos_vers_lebas: TPosition;
    score_vers_lebas: integer;

    Function SilenceElMusicalCanBeDrawnOnSameX(silence, elmus: TElMusical): Boolean;
    var silence_pos1, silence_pos2: TPosition;
        elmus_pos1, elmus_pos2: TPosition;
    Begin
          silence_pos1 := silence.position;
          inc(silence_pos1.hauteur, 5);

          silence_pos2 := silence.position;
          dec(silence_pos2.hauteur, 5);

          elmus_pos1 := elmus.PosNoteHaut;
          elmus_pos2 := elmus.PosNoteBas;



          if (IsPosition1Inf2(silence_pos2, elmus_pos1) and IsPosition1Inf2(elmus_pos2, silence_pos1))
            or (IsPosition1Inf2(elmus_pos2, silence_pos1) and IsPosition1Inf2(silence_pos2, elmus_pos1)) then
               result := false
          else
               result := true;
    End;



Begin
     if high(elms) = -1 then
             exit;


     for i := 0 to high(Elms[0]) do
     If Elms[0][i].IsSilence then
     Begin
           position_initiale := Elms[0][i].position;
           bon := false;
           score_vers_lebas := 0;
           while (not bon) and (score_vers_lebas < max_score_poureviter_boucler) do
           Begin
               bon := true;
               for j := 0 to high(elms) do
                       for k := 0 to high(elms[j]) do
                               if Elms[0][i] <> elms[j][k] then
                               if not SilenceElMusicalCanBeDrawnOnSameX(Elms[0][i], elms[j][k]) then
                               Begin
                                     inc(score_vers_lebas);
                                     dec(Elms[0][i].position.hauteur);
                                     bon := false;
                               End;
           End;

           pos_vers_lebas := Elms[0][i].position;

           Elms[0][i].position := position_initiale;
           bon := false;
           score_vers_lehaut := 0;
           while (not bon) and (score_vers_lebas < max_score_poureviter_boucler) do
           Begin
               bon := true;
               for j := 0 to high(elms) do
                       for k := 0 to high(elms[j]) do
                               if Elms[0][i] <> elms[j][k] then
                               if not SilenceElMusicalCanBeDrawnOnSameX(Elms[0][i], elms[j][k]) then
                               Begin
                                     inc(score_vers_lehaut);
                                     inc(Elms[0][i].position.hauteur);
                                     bon := false;
                               End;
           End;
           
           pos_vers_lehaut := Elms[0][i].position;


           if score_vers_lehaut < score_vers_lebas then
                  Elms[0][i].position := pos_vers_lehaut
           else
                  Elms[0][i].position := pos_vers_lebas;



     End;
     
End;










//Mesure
//*******************************************************************************


constructor TMesure.Create;
Begin
    NbMesuresCompressees := 1;
End;


Procedure TMesure.CalcGrpNotes(DureeGrpNote: TRationnel);
var v: integer;

Begin
    VerifierRationnel(DureeGrpNote, 'CalcGrpNotes');

    for v := 0 to high(Voix) do
           Voix[v].CalcGrpNotes(DureeGrpNote);


End;




Procedure TMesure.CreerGraphOrdreInfo;
{calcule l'ordre des él. musicaux dans une mesure, calcule l'alignement
 des notes jouées ensemble...

  Le résultat du calcul de cette procédure est stockée dans le tableau "mgoi".

 }


var i_mgoi, v, hvoix: integer;


    //temps en cours
    T: array of TRationnel;

    Tmin: TRationnel;

    //indices en cours
    I:array of integer;


    procedure CreerGraphOrdreInfo_Init;
    var v: integer;
    Begin
          hvoix := high(Voix);

          setlength(T, hvoix + 1);
          setlength(I, hvoix + 1);
          SetLength(mgoi, 0);

          for v := 0 to hvoix do
          Begin
               T[v] := QUn; //au début, on est à l'instant "1" sur toutes les voix
               I[v] := 0; //on va traiter le premier él. musical de la voix (indice 0)
          end;
    End;



    Function T_Calculer_Min: TRationnel;
    {calcul du minimum Tmin du tableau T en regardant que les voix visibles}

    var v: integer;
        
    Begin
          result := QInfini;
          for v := 0 to high(T) do if Voix[v].IsAffichee then
                if IsQ1InfQ2(T[v], result) then
                        result := T[v];
    End;


    Function OnAFini: Boolean;
    {on finit dès lors que toutes les voix ont été visitées}
    
    var v: integer;
    
    Begin

            result := true;
            for v := 0 to hvoix do if Voix[v].IsAffichee then
                  result := result and (I[v] > high(Voix[v].ElMusicaux));


    End;

    


Begin
      CreerGraphOrdreInfo_Init;

      i_mgoi := 0;

//      repeat
      while not OnAFini do
      Begin
            SetLength(mgoi, i_mgoi+1);
            mgoi[i_mgoi] := T1MGOInfo.Create;
            { mgoi[imgoi] représentera tous les él. musicaux sur un même temps}

            Tmin := T_Calculer_Min;

            mgoi[i_mgoi].t := TMin; {ce temps, c'est celui qui correspond à (aux)
                       él. musicaux les plus proches}

            for v := 0 to hvoix do with Voix[v] do if IsAffichee then
            Begin

                  if (I[v] <= high(ElMusicaux)) then
                  Begin
                          if IsQEgal(T[v],Tmin) then
                          Begin
                          {on recence tous les él. musicaux "Voix[v].ElMusicaux[I[v]]"
                           à ce temps minimum. On l'ajoute à mgoi[imgoi]}
                                 mgoi[i_mgoi].AddElMusical(ElMusicaux[I[v]]);
                                 QInc(T[v], ElMusicaux[I[v]].Duree_Get);

                                 inc(I[v]);
                          end;
                  end Else  //si on finit de parser une voix, on déclare le temps infini pour elle
                          T[v] := QInfini;

            end;


            if length(mgoi[i_mgoi].elms) > 0 then    {(*)}
                  inc(i_mgoi);

            {rem : length(mgoi[i_mgoi].elms) = 0 ça peut arriver.
             ex : voix 0 : 1 noire, 1 noire
                  voix 1 : 1 croche}
            
       End;

       if length(mgoi) > 0 then
       if length(mgoi[high(mgoi)].elms) = 0 then
            Setlength(mgoi, high(mgoi));
       {si c'est pas vide, mais que la dernière case de mgoi est vide, on
        la supprime}
        {cela peut être possible à cause de (*)}
      

End;














Procedure TMesure.CalcQueuePositionAutomatiquement;
{regarde pour tous les élements musicaux, si c'est plutôt queue vers le bas ou
 queue vers le haut}
{requiert que mgoi soit initialisé}

    
   procedure ExaminerLesSouhaits;
   var i, j, k, i1, j1, k1: integer;
       nb, inb:integer;
    dist: integer;
    
   Begin
      for i := 0 to high(mgoi) do
          //là en fait, on parcourt un peu les temps
          Begin
             for j := 0 to high(mgoi[i].elms) do
             {là on est sur le temps correspondant à i, et on parcourt
             les "plan" d'el. mus (généralement, il n'y a qu'un plan)}
             for k := high(mgoi[i].elms[j]) downto 0 do
             Begin
                    mgoi[i].elms[j][k].InitSouhaitQueueVersBas;
                    
                    for i1 := max(i-1, 0) to min(high(mgoi), i+1) do
                    for j1 := 0 to high(mgoi[i1].elms) do
                        for k1 := high(mgoi[i1].elms[j1]) downto 0 do
                        if (j1 <> j) or (k1 <> k) or ((i1 <> i) and
                           ( mgoi[i].elms[j][k].NumVoix <> mgoi[i1].elms[j1][k1].NumVoix) ) then
                        Begin
                           dist := ElMusical_Dist_Algebrique(mgoi[i].elms[j][k],
                                                             mgoi[i1].elms[j1][k1]);
                           if abs(dist) < 900 then
                           Begin
                                 if i = i1 then
                                     nb := 2
                                 else nb := 1;

                                 for inb := 1 to nb do
                                 Begin

                                     if dist < 0 then
                                     {j,k est au dessus...queue vers le haut}
                                         mgoi[i].elms[j][k].SouhaiterQueueVersBas(false)
                                     else if dist > 0 then
                                         mgoi[i].elms[j][k].SouhaiterQueueVersBas(true);
                                 End;

                           End;
                        End;
             End;

          End;
   End;



   procedure TenterAppliquerSouhaits;
   var v, i, j, ideb_groupe: integer;
       votepourqueueverslebas: integer;
       nouveau_groupe_ou_dernier_el: Boolean;
       queueverslebas_courant, queueverslebas_avant: Boolean;

       
   Begin

      queueverslebas_avant := false;
      
      for v := 0 to high(Voix) do
      With Voix[v] do
      Begin
            ideb_groupe := 0;
            
            for i := 0 to length(ElMusicaux) do
            Begin
                nouveau_groupe_ou_dernier_el := (i = length(ElMusicaux));

                if not nouveau_groupe_ou_dernier_el then
                     nouveau_groupe_ou_dernier_el := ElMusicaux[i].NvGroupe;


                if nouveau_groupe_ou_dernier_el then
                Begin
                     votepourqueueverslebas := 0;
                     for j := ideb_groupe to i-1 do
                               inc(votepourqueueverslebas, ElMusicaux[j].GetSouhaitQueueVersBas);


                     if votepourqueueverslebas > 0 then
                          queueverslebas_courant := true
                     else if votepourqueueverslebas < 0 then
                          queueverslebas_courant := false
                     else
                          queueverslebas_courant := queueverslebas_avant;


                     for j := ideb_groupe to i-1 do
                            ElMusicaux[j].QueueVersBas := queueverslebas_courant;

                     queueverslebas_avant := queueverslebas_courant;  
                     ideb_groupe := i;

                End;
                
            End;
      End;
   End;


Begin

        ExaminerLesSouhaits;
        TenterAppliquerSouhaits;



End;



Procedure TMesure.CalcBoules;
var v, i: integer;

Begin
    for v := 0 to high(Voix) do with Voix[v] do
       for i := 0 to high(ElMusicaux) do
            ElMusicaux[i].CalcGDBoules;
            
End;

Procedure TMesure.CalcGraphSub(margefinalepourtonalitesuivante: integer; mesure_numero: integer;
                       optimisation_is_groupes_notes_calculer: Boolean);
{

 margefinalepourtonalitesuivante : contient le nombre de pixel que l'on prévoit
 pour afficher l'éventuel changement de tonalité à la fin de cette mesure

Cette procédure requiert :
 que le champ mgoi soit calculé


Cette procédure :
 calcule les champs pixWidth, pixWidthdroite puis pixx des éléments musicaux
 gère les clés insérées
 calcule pixWidth, largeur de la mesure en cours


}
     procedure Pixx_Fin_TraineeDuree_Calculer;
     var v, i: integer;
         t : TRationnel;
     Begin

          for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
          Begin
              t := Qel(0);
              for i := 0 to high(ElMusicaux) do
              With ElMusicaux[i] do
              Begin
                    t := QAdd(t, ElMusicaux[i].Duree_Get);
                    if not IsSilence then
                    if Duree_IsApproximative then
                    Begin
                         trainee_duree_pixxdroite := XATemps(QAdd(Qel(1),t));

                    End;

              End;
          End;
     End;

var v, i, j, k, zz:integer;
    hvoix : integer;
    ecart_suppl_du_a_la_duree: integer;
    entre2elmusicaltempsdiff, entre2elmusicalmmtemps: integer;
    x:integer;
    MaxDuree: TRationnel;
    x2min,x1max, x1, x2:integer;
    pos1, pos2: integer;
    s: string;
    newpixWidth: integer; {sert à donner de nouvelles propositions de valeurs
                             à pixWidth, la largeur de la mesure}
    largclefici: integer; {stocke la largeur de la clef, en prenant en compte
                           la taille de la portée}

Begin
      hvoix := high(Voix);


      if optimisation_is_groupes_notes_calculer then
            CalcGrpNotes(GetDureeGrpNote(Rythme));


      { ******Calcul des largeurs des el. musicaux ************
      Largeurs dû à :
      - la présence de boules de part et d'autre de la tige qui augmente la largeur
         de l'él. musical
      - les paroles. Chaque syllabe peut augmenter la largeur de l'él musical
        correspondant.

      }
      for v := 0 to hvoix do with Voix[v] do if IsAffichee then
      Begin
            
            for j := 0 to high(ElMusicaux) do
            Begin

                With ElMusicaux[j] do
                Begin
                       if IsSilence then
                          pixWidth := 4*nbpixlign

                      else
                               if GetBoulesCotes = bcMixte then
                                      pixWidth := 4*rayonnotes[taillenote]
                               else
                                     pixWidth := 4*rayonnotes[taillenote] div 2;

                  pixWidthdroite := pixwidth * ZoomPortee(PorteeApprox) div ZoomMaxPrec;
                  pixwidth := pixWidthdroite;
                  if Paroles_Syllabe <> '' then
                         pixWidthdroite := C.TextWidth(Paroles_Syllabe)*ZoomMaxPrec div ZoomParDefaut+DecalageParole
                  else
                         pixWidthDroite := 0;

                  if (pixWidthdroite < pixWidth) or (pos1 = 0) then
                       pixWidthdroite := pixWidth;
               End;



            End;
      End;


      {****Calcul des positions (sans clés)******************************
      - On se sert du tableau mgoi préalablement créé


      }


      {x représente l'abcisse courante... elle va augmenter au cours de l'algo}
      x := 0;

      if affTonalitesDebut then
      Begin
            v := DeltaXTonalites(Tonalites);
            if v > 0 then
                  pixXApresTonaliteDebut := v + MargeEntreAlterationALaCleEtRythme
            else
                  pixXApresTonaliteDebut := 0;
      end
      else
            pixXApresTonaliteDebut := 0;


      inc(x, pixXApresTonaliteDebut);

      if affRythmeDebut then
             inc(x, largeurrythme);

      pixXApresTonaliteDebutEtRythme := x;


      {calcule les .pixx des él. mus.}
      inc(x, AuZoomGeneralPortee(margeinitiale));
      entre2elmusicaltempsdiff := 0;
      entre2elmusicalmmtemps := 0;

      {mgoi contient toutes les info de comment afficher les notes...
       cf. T1MGOInfo, CreerGraphOrdreInfo}

      for i := 0 to high(mgoi) do
      //là en fait, on parcourt un peu les temps
      Begin
         inc(x, entre2elmusicaltempsdiff);
         
         for j := 0 to high(mgoi[i].elms) do
         {là on est sur le temps correspondant à i,
         on parcourt les "plan" d'el. mus (généralement, il n'y a qu'un plan)}
         Begin
                 inc(x, entre2elmusicalmmtemps);

                 
                 entre2elmusicalmmtemps := 0;
                 for k := 0 to high(mgoi[i].elms[j]) do
                 {on parcourt les el. musicaux du même plan}
                        entre2elmusicalmmtemps := max(mgoi[i].elms[j][k].pixWidthgauche,
                                                      entre2elmusicalmmtemps);

                 inc(x, entre2elmusicalmmtemps);
                 entre2elmusicalmmtemps := 0;


                 {là on calcule :
                      MaxDuree : le minimum des durées des él. dans le plan n° j
                      zz : le zoom de la portée la plus grosse dans le plan n° j}  
                 MaxDuree := QInfini;
                 zz := 0;
                 for k := 0 to high(mgoi[i].elms[j]) do
                 Begin
                          mgoi[i].elms[j][k].pixx := x;

                          zz := max(zz, ZoomPortee(mgoi[i].elms[j][k].PorteeApprox)); 

                          entre2elmusicalmmtemps := max(mgoi[i].elms[j][k].pixWidthdroite,
                                                        entre2elmusicalmmtemps*zz div ZoomMaxPrec);
                          MaxDuree := QMin(MaxDuree,
                                           mgoi[i].elms[j][k].Duree_Get);
                 End; //for k

                 

               {  if j = high(mgoi[i].elms) then
                            entre2elmusicaltempsdiff := 8 * zz div ZoomMaxPrec
                 else    }
                 Begin
                      if IsQStrNegatif(MaxDuree) then
                              MessageErreur('Erreur : MaxDuree dans CalcGraphSub est négatif (mesure n° ' +
                                           inttostr(mesure_numero) + ') ! Il vaut ' +
                                      QToStr(MaxDuree) +' ! Cela est dû à pb de pointeur et a priori, ' +
                                      'le logiciel Schwarz Musicwriter risque malheureusement de ne '+
                                      ' plus marcher correctement. Redémarre le !')
                      else
                      if MaxDuree.num = 0 then
                            ecart_suppl_du_a_la_duree := 0
                      else
                            ecart_suppl_du_a_la_duree := max(0,
                                                             round( 5*prec*ln(
                                                                            4*QtoReal(MaxDuree)
                                                                            )
                                                                   )
                                                             );
                             //ecart_suppl_du_a_la_duree := Round(100*QtoReal(MaxDuree));

                             
                      entre2elmusicaltempsdiff := (ecartsuppl + ecart_suppl_du_a_la_duree)
                                                                  * zz div ZoomMaxPrec;
                 End; //if
         End; //for j
      End; //for i


      //calcul final de pixwidthdroite
      for v := 0 to hvoix do
            for j := 0 to high(Voix[v].ElMusicaux)-1 do
            Begin
                 Voix[v].ElMusicaux[j].pixWidthdroite :=
                   Voix[v].ElMusicaux[j+1].pixX - Voix[v].ElMusicaux[j+1].pixwidthgauche
                                  - Voix[v].ElMusicaux[j].pixX;
            End;



      {*****calcul des clés*****************************}
      for j := 0 to high(ClefsInserees) do
      Begin
               With ClefsInserees[j] do
               Begin
                     x2min := IntegerInfini;
                     x1max := 0;
                     for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
                     Begin
                             FindElMusicalApresTemps(Temps, k);
                             if k <= high(ElMusicaux) then

                                   if ElMusicaux[k].IsSurPortee(portee) then
                                          Begin
                                              x2 := ElMusicaux[k].pixx
                                                - ElMusicaux[k].pixwidth div 2;
                                               if x2min > x2 then x2min := x2;
                                          End;

                             if (k > 0) and (high(ElMusicaux) >= 0) then
                             Begin
                                  dec(k);
                                  x1 := ElMusicaux[k].pixx + ElMusicaux[k].pixwidth div 2;
                                  if x1max < x1 then
                                          x1max := x1;
                             end;
                     end;

                     inc(x1max, ecartsuppl);
                     dec(x2min, ecartsuppl);
                     ClefsInserees[j].pixx := x1max;


                    if x2min - x1max <= largclef then
                         for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
                             DecalePosX(x1max+1, AuZoomPortee(largclef, portee) - (x2min - x1max));


               end;






      End;


      {calcule la largeur pixWidth de la mesure en cours}

      pixWidth := pixXApresTonaliteDebut + largeurrythme + margeinitiale;
             {cette valeur est celle si il n'y a aucun élément musical dans la mesure}

      for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
      Begin
             i := high(ElMusicaux);

             {on consulte les derniers élém. mus. de chaque voix pour minorer pixWidth}
             if i > -1 then
                 if pixWidth < ElMusicaux[i].pixx +
                             ElMusicaux[i].pixWidthdroite then
                          pixWidth := Voix[v].ElMusicaux[i].pixx +
                                    Voix[v].ElMusicaux[i].pixWidthdroite;
      End;

      Pixx_Fin_TraineeDuree_Calculer;

      


      for k := 0 to high(ClefsInserees) do
      Begin
          newpixWidth := ClefsInserees[k].pixx + AuZoomPortee(30, ClefsInserees[k].portee);
               if pixWidth < newpixWidth then
                         pixWidth := newpixWidth;
      End;


      inc(pixWidth, AuZoomGeneralPortee(margefinale2));
      pixWidthWithoutTonalitesFin := pixWidth;
      inc(pixWidth, margefinalepourtonalitesuivante);
      pixWidth := pixWidth + AuZoomGeneralPortee(margefinale2);

      for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
      Begin
           j := high(ElMusicaux);
             if j > -1 then
                  ElMusicaux[j].pixWidthdroite := pixWidth - ElMusicaux[j].pixX + 3*nbpixlign;
      End;


End; {CalcGraphSub}




Procedure TMesure.CalcQueue;
{s'occupe de calculer les YExtremiteQueue et de gérer les groupes de notes...
  de comment lier les croches etc..}
var v:integer;

Begin
      //calcul des queues
      for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
             ElMusicaux_Queues_Calculer;
             



      for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
      Begin

      End;

End;   {CalcQueue}








Function TMesure.TempsAX(x: integer): TRationnel;
{si on fait après tout, ça rend infini}
var v, i: integer;
    t, tmin: TRationnel;

Begin
     tmin := Qadd(Qel(1), DureeTotale);
     for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
         Begin
               Voix[v].FindElMusicalApres(x, i);

               if i <= high(Voix[v].ElMusicaux) then
               Begin
                   t := Voix[v].SurTemps(i);
                   if IsQ1InfQ2(t, tmin)  then
                          tmin := t;
               End;

         end;

     result := tmin;
     //ici

End;



Function TMesure.TempsAX2(x: integer): TRationnel;
{renvoie (explication approximative) le temps à l'abscisse x
 cette fonction est utilisé dans le calcul des pauses gloutonnes

 ex : une mesure contient 4 noires
      si on se place au début => renvoie 0/1
      si on se place sur la première noire, => renvoie 1/1
      si on se place entre la première noire et la 2e => renvoie 1/1
      si on se place sur la 2e noire, => renvoie 2/1
      si on se place entre la 2e noire et la 3e => renvoie 2/1
      :
      :
     si on se place après tout, => renvoie la durée totale, ici 4/1}

var v {indice de voix},
    i {indice de él. mus. trouvé}                    : integer;

    t {temps trouvé dans la voix},
    tmax {temps maximal}                             : TRationnel;

Begin
     tmax := Qel(0);//Qadd(Qel(1),DureeTotale);
     for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
         Begin
               if not Voix[v].FindElMusicalApres(x, i) then
                     dec(i);

               if i>=0 then
               Begin
                   {on est sûr que i est dans [0, high(Elmusicaux)]
                    (indice valide d'él. mus. qui désigne l'él. dessus
                     ou l'él. qui précède (qui est vers la gauche)}
                     
                   t := Voix[v].SurTemps(i);

                   if IsQ1InfQ2(tmax, t)  then
                          tmax := t;
               End;
               {rem : si i = -1, cela signifie que le curseur se trouvait AVANT
                       tous les él. mus.}

         end;

     result := tmax;

End;


Function TMesure.XATemps(t: TRationnel): integer;
{t =0, un x au début}
var i {indice dans mgoi} : integer;

Begin
     result := IntegerInfini;
     
     for i := 0 to high(mgoi) do
         if IsQ1InfQ2(t, mgoi[i].t) then
         Begin
              result := mgoi[i].GetX_in_mes;
              Break;
         End;

         {pour éviter que ça part complétement vers l'infini}
     if result > pixWidth-EcartPlacageXATemps then
          result := pixWidth-EcartPlacageXATemps;
     //ici

End;



Function TMesure.X_Entre_ATemps(t: TRationnel): integer;
{t =0, un x au début}
Var i {indice dans mgoite au temps t} : integer;

Begin
     result := IntegerInfini;

     if IsQNul(t) then
          result := 30
     else
     Begin
           t := QAdd(t, Qel(1));
           for i := 0 to high(mgoi) do
           if IsQ1InfQ2(t, mgoi[i].t) then
           Begin
                result := (mgoi[i-1].GetX_in_mes + mgoi[i].GetX_in_mes) div 2;
                Break;
           End;
     End;

     if result > pixWidth-EcartPlacageXATemps then
          result := pixWidth-EcartPlacageXATemps;
     //ici

End;



Function TMesure.XATempsOuEntre(t: TRationnel): integer;
{renvoie :
   pile poil le x du temps t si ya une note dessus
   un truc approximatif, entre deux notes, si le temps t tombe entre}

{t =0, un x au début}
var i {indice dans mgoi} : integer;
    lambda: real;
    
Begin
     t := QAdd(t, Qel(1));
     result := infinity;
     for i := 0 to high(mgoi) do
         if IsQ1InfQ2(t, mgoi[i].t) then
         Begin
              if IsQEgal(t, mgoi[i].t) then
                  result := mgoi[i].GetX_in_mes
              else
              Begin
                  if IsQEgal(mgoi[i].t, mgoi[i-1].t) then
                      result := (mgoi[i-1].GetX_in_mes + mgoi[i].GetX_in_mes) div 2
                  else
                  Begin
                       lambda := 1-QToReal(QDiv(
                                      QDiff(t, mgoi[i-1].t),
                                      QDiff(mgoi[i].t, mgoi[i-1].t)
                                      ));
                       result := Round((mgoi[i-1].GetX_in_mes * lambda + (1 - lambda) * mgoi[i].GetX_in_mes));
                  End;
              End;
              Break;
         End;

         {pour éviter que ça part complétement vers l'infini}
     if result > pixWidth-EcartPlacageXATemps then
          result := pixWidth-EcartPlacageXATemps;
     //ici

End;




Procedure TMesure.RegleMesure_DeplacerTic(temps1, temps2: TRationnel);
var v: integer;
Begin
     for v := 0 to high(Voix) do
           Voix[v].RegleMesure_DeplacerTic(temps1, temps2);
           
End;


Procedure TMesure.RegleMesure_Etirer(temps_debut, temps1, temps2: TRationnel);
var v: integer;
Begin
     for v := 0 to high(Voix) do
           Voix[v].RegleMesure_Etirer(temps_debut, temps1, temps2);
           
End;




Procedure TMesure.Durees_Inferences_EtirerAuRythmeMesure_Et_Inferer;


    Function IsQueDesTrucsDeDureesIndeterminees: Boolean;
    var v, i: integer;
    Begin
         result := true;
         for v := 0 to high(Voix) do
         With Voix[v] do
         Begin
              for i := 0 to high(Elmusicaux) do
                   if not ElMusicaux[i].Duree_IsApproximative then
                         Begin
                             result := false;
                             exit;
                         End;
         End;
    End;

    
    procedure Durees_Inferences_Etirer(rapport: real);
    const prec = 2096;
    
    var v, i: integer;
    Begin
         for v := 0 to high(Voix) do
         With Voix[v] do
         Begin
              for i := 0 to high(Elmusicaux) do
                   ElMusicaux[i].Duree_Set(
                      Qel(
                          Round((QToReal(ElMusicaux[i].Duree_Get) * rapport) * prec),
                          prec
                          )
                      );
         End;
    End;

    var rapport: real;
        duree_totale: TRationnel;

Begin
      duree_totale := DureeTotale;

      if IsQNul(duree_totale) then
          exit;

      if not IsQueDesTrucsDeDureesIndeterminees then
          exit;

          
      rapport := QToreal(QMul(4, Rythme)) / QToReal(duree_totale);

      Metronome := Round(Metronome * rapport);
      Durees_Inferences_Etirer(rapport);


End;




Procedure TMesure.Durees_Inferences_Inferer;
    Procedure Traiter(t1, t2: TRationnel);
    var v: integer;
    Begin
         for v := 0 to high(Voix) do
            Voix[v].Durees_Inferences_Inferer(t1, t2);
    End;



var v, i: integer;
    t1, t: TRationnel;
    etat: integer;





Begin
    etat := 0;
    for v := 0 to high(Voix) do
    With Voix[v] do
    Begin

         t := Qel(0);
         for i := 0 to high(ElMusicaux) do
         Begin
              if not ElMusicaux[i].Duree_IsApproximative then
              Begin
                   if etat = 0 then
                       t1 := t;

                   etat := 1;
              End
              else
              Begin
                  if etat = 1 then
                        Traiter(t1, t);

                  etat := 0;
              End;
                  

              t := QAdd(t, ElMusicaux[i].Duree_Get);

              if i = high(ElMusicaux) then
              Begin
                    if etat = 1 then
                        Traiter(t1, t);
              End;
         End;

    End;


    
End;



Procedure TMesure.CopieSelectionToPressePapier(PP: TMesure);
var v, n_v, i: integer;

Begin
{on parcourt les voix...
 et on ajoute les pauses sélectionnées, ou l'extraction des notes qui sont sélectionnées}
      for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
      Begin
          n_v := N_Voix;
          for i := 0 to high(Voix[v].ElMusicaux) do
              PP.VoixNum(n_v).AddElMusicalFin(ElMusicaux[i].ExtrairePartieSelectionnee);

          PP.Nettoyer;
    

      End;

End;



Procedure TMesure.CopieObjectMesureEnDeselectionnant(var M: TMesure);
var v, n_v,
    i: integer;

Begin
        M := TMesure.Create;

        for v := 0 to high(Voix) do
        Begin
            n_v := Voix[v].N_Voix;
            for i := 0 to high(Voix[v].ElMusicaux) do
                  M.VoixNum(n_v).AddElMusicalFin(
                     CopieElMusicalEnDeselectionnant(Voix[v].ElMusicaux[i]))

        End;

        M.pixx := pixx;
        M.pixXApresTonaliteDebut := pixXApresTonaliteDebut;
        M.pixXApresTonaliteDebutEtRythme := pixXApresTonaliteDebutEtRythme;
        M.pixWidthWithoutTonalitesFin := pixWidthWithoutTonalitesFin;
        M.pixWidth := pixWidth;
        M.enlargment := enlargment;

        Setlength(M.ClefsInserees, length(ClefsInserees));
        if length(ClefsInserees) > 0 then
              Move(ClefsInserees[0], M.ClefsInserees[0], length(ClefsInserees) * SizeOf(TClefInseree));

        M.Tempo := Tempo;
        M.Metronome := Metronome;
        M.Rythme := Rythme;
        M.BarreDebut := BarreDebut;
        M.BarreFin := BarreFin;
        M.affTonalitesDebut := affTonalitesDebut;
        M.affChgtTonalitesFin := affChgtTonalitesFin;
        M.affRythmeDebut := affRythmeDebut;

        Setlength(M.Tonalites, length(Tonalites));
        if length(Tonalites) > 0 then
              Move(Tonalites[0], M.Tonalites[0], length(Tonalites) * SizeOf(Shortint));



End;





Procedure TMesure.Save(nbporteecourant: integer);
var v, l:integer;

Begin
     FichierDoInt(pixX);


     FichierDoInt(pixXApresTonaliteDebut);
     FichierDoInt(pixXApresTonaliteDebutEtRythme);
     FichierDoInt(pixWidthWithoutTonalitesFin);

     //FichierDoInt(pixY);
     FichierDoInt(pixWidth);

     FichierDoInt(enlargment);
     //FichierDoInt(pixHeight);

     FichierDo(Rythme, SizeOf(TRationnel));

     if Rythme.Denom = 0 then
     Begin
          Rythme.Num := 4;
          Rythme.Denom := 4;
     End;

     FichierDo(affRythmeDebut, 1);
          
     FichierDoStr(Tempo);

    FichierDoInt(Metronome); //on stocke un tempo de base

    if Metronome <= 0 then
    Begin
          //MessageErreur('Dans TMesure.Save, Metronome était négatif ou nul. => par défaut à 120.');
          Metronome := METRONOME_DEFAULT;
    End;                  
    l := 0;
    FichierDoInt(l); //stocke des tempos étendus (ici 0)
//    FichierDoInt(l); //barre de début

    FichierDo(l, 2);
    FichierDo(BarreDebut, 1);
    FichierDo(BarreFin, 1);
    FichierDo(l, 4);

     if EnLecture then
     Begin
         Tonalites := nil;
         Setlength(Tonalites, nbporteecourant);
         for v := 0 to nbporteecourant-1 do
              Tonalites[v] := 0;
     End;

    
    FichierDo(Tonalites[0], nbporteecourant);
    FichierDo(affTonalitesDebut, 1);
    FichierDo(affChgtTonalitesFin, 1);



     FichierDoInt(l, length(ClefsInserees));
     if EnLecture then
         Setlength(ClefsInserees, l);

     FichierDo(ClefsInserees[0], length(ClefsInserees) * SizeOf(TClefInseree));


     FichierDoInt(l, length(Voix));

     if EnLecture then {en lecture, il faut créer les objets TVoix au préalable,
      avant de les charger à partir du fichier}
     Begin
         Setlength(Voix, l);
         for v := 0 to high(Voix) do
            Voix[v] := TVoix.Create;
     end;

     for v := 0 to high(Voix) do
            Voix[v].Save;


End;


procedure TMesure.SetTonalite(tona: TTonalite);
var p: integer;

Begin
   for p := 0 to IGP.NbPortees - 1 do
          Tonalites[p] :=
               tona - Tonalite(IGP.Portee_Transposition[p]);

End;



Function TMesure.GetTonalite: TTonalite;
Begin
   result := Tonalites[0] + Tonalite(IGP.Portee_Transposition[0]);

End;



Procedure TMesure.GraphEtirer(rapport: real);
{les positions des él. mus et des clés sont supposé correct
    cette procédure étire tout ça d'un certain rapport

    rem : si rapport = 1, elle ne fait rien} 

var v, i: integer;
    diff: integer;
Begin
//préconditions
      if rapport <= 0 then
            MessageErreur('Le rapport d''étirement dans GraphEtirer doit être positif !!');

      for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
            for i := 0 to high(ElMusicaux) do
            With ElMusicaux[i] do
            Begin
                  pixx := round(pixx * rapport);
                  trainee_duree_pixxdroite := round(trainee_duree_pixxdroite * rapport);
                  {oui, on étire aussi la "partie droite" qui suit l'élément musical...
                   sinon, par ex, le dessin des traits de liaison est très moche}
                  pixWidthdroite := round(pixWidthdroite * rapport);
            End;

      for i := 0 to high(ClefsInserees) do
             ClefsInserees[i].pixx := round(ClefsInserees[i].pixx * rapport);

      diff := pixwidth - pixWidthWithoutTonalitesFin;
      pixwidth := round(pixwidth * rapport);

      pixWidthWithoutTonalitesFin := pixwidth - diff;
End;



Function TMesure.NoteSousCurseur(X, Y:integer; var el: TElMusical;
                                               var n:TPNote): Boolean;
var m, v, i, j: integer;
    pos: TPosition;
    ns: TElMusical;
Begin
      result := false;

      GetPosition(Y, IGP, IGiLigne, pos);

      {on cherche l'éventuelle note qui serait sous le curseur}
      For v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
            if IsVoixAccessibleEdition(N_Voix) then
            For i := 0 to high(ElMusicaux) do
                 if not ElMusicaux[i].IsSilence then
                 Begin
                      ns := ElMusicaux[i];

                      if (ns.pixx - ns.pixWidth div 2+1 <= X) and
                          (X <= ns.pixx + ns.pixWidth div 2-1) then
                      Begin
                          el := ns;
                                for j := 0 to high(ns.Notes) do
                                 Begin
                                       if IsPositionsEgales(ns.Notes[j].position, pos) then
                                       Begin
                                           n := @ns.Notes[j];
                                           result := true;
                                           Exit;
                                       end;

                                       if IGP.Portee_IsTablature_Et_PasDehors(el.Notes[j].tablature_position.portee) then
                                        if IsPositionsEgales(el.Notes[j].tablature_position, pos) then
                                        Begin
                                             n := @ns.Notes[j];
                                             result := true;
                                             exit;
                                        End;
                                 End;
                      End;
            End;


End;



Function TMesure.PauseSousCurseur(X, Y: integer; var elm: TElMusical): Boolean;
var m, v, i: integer;
Begin
     result := false;
     elm := nil;

    {on cherche l'éventuelle pause sous le curseur}
    For v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
          if IsVoixAccessibleEdition(N_Voix) then
          For i := 0 to high(ElMusicaux) do
               if (ElMusicaux[i].IsSilence) and
                   PointInRect(X, Y, ElMusicaux[i].pixRect) then
               Begin
                    elm := ElMusicaux[i];
                    result := true;
                    exit;
               End;

End;


Function TMesure.DonnerNumVoixSousCurseur(X, Y: integer; out Voixtrouvee: integer): Boolean;
{on donne (x, y) dans le repère de la mesure,
puis il faut trouver la voix sous le curseur

renvoie vrai ssi on a trouvé une voix sous le curseur
        rem : une voix trouvée est forcément affichée}
var v:integer;
    el: TElMusical;
    n: TPNote;

Begin
    result := true;


    if PauseSousCurseur(X, Y, el) then
    Begin
        result := true;
        Voixtrouvee := el.NumVoix;
    End
    else
    if NoteSousCurseur(X, Y, el, n) then
    Begin
        result := true;
        Voixtrouvee := el.NumVoix;
    End
    else
    Begin
        for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
              if PointInFondVoix(X, Y, pixWidth) then
              Begin
                   Voixtrouvee := N_Voix;
                   result := true;
                   Exit;
              End;
    End;


    result := false;

End;


Procedure TMesure.DonnerNumVoixPresCurseur(X: integer; pos: TPosition; out Voixtrouvee: integer);
var Y: integer;
Begin
    Y := GetY(pos);
    DonnerNumVoixPresCurseur(X, Y, Voixtrouvee);
End;



Procedure TMesure.DonnerNumVoixPresCurseur(X, Y: integer; out Voixtrouvee: integer);
{on donne (x, y) dans le repère de la mesure,
 puis il faut trouver la voix sous le curseur

 rem : une voix trouvée est forcément affichée
       renvoie une voix "positive"}

var i, v, dist_min_voix, dist_voix :integer;
    pos: TPosition;

Begin
    dist_min_voix := 100000;

    GetPosition(Y, IGP, IGiLigne, pos);
    Voixtrouvee := pos.portee;
    
    for v := 0 to high(Voix) do with Voix[v] do if IsAffichee and (N_Voix >= 0) then
    Begin
          FindElMusicalApres(X, i);
          dec(i);
          if i < 0 then i := 0;

          if not IsVide then
          Begin
              if ElMusicaux[i].IsSurPortee(pos.portee) then
              Begin
                  dist_voix := DistPointFondVoix(i, Y, pixWidth);
                  if dist_voix < dist_min_voix then
                  Begin
                       Voixtrouvee := N_Voix;
                       dist_min_voix := dist_voix;
                  End;
              End;
          End;
    End;


End;





Function TMesure.RienAAfficher: Boolean;
{renvoit vrai si il n'y a rien à afficher dans la mesure
 rem : cela a à peu près le même fonctionnement que IsVide, sauf qu'il
       ne prend en compte que les voix réellement affichées

 --> cette fonction sert à effectuer les compressions de mesures}
var v: integer;
Begin
      result := true;

      v := 0;
      while (v <= high(Voix)) and result do
      Begin
             if Voix[v].IsAffichee then
                  result := Voix[v].IsVide;
             inc(v);
      End;


End;


Function TMesure.MemeStyleQue(m: TMesure): Boolean;
{renvoit vrai ssi la mesure courante et m se compresse s'il est sont toutes
 les deux vide
 revoit faux ssi elle diffère de tonalité, de rythme auquel cas
 il faudra de tte façon le signaler à l'exécutant ; donc on ne pourra
 compresser les mesures.}
var i: integer;
Begin
     if high(Tonalites) <> high(m.Tonalites) then
          result := false
     else
     Begin
         for i := 0 to high(Tonalites) do
             if Tonalites[i] <> m.Tonalites[i] then
             Begin
                  result := false;
                  exit;  
             End;

         result := IsQEgal(Rythme, m.Rythme);
     End;
End;


Function TMesure.PorteesUtiles(nbporteecourant: integer): TArrayBool;
{Renvoit un tableau P
   P[i] est vrai si la portée est utile (contient des notes --> on l'affiche}
var P: TArrayBool;
    i, v, n: integer;
Begin
    setlength(P, nbporteecourant);

    {initialise le tableau P à false} 
    for i := 0 to nbporteecourant-1 do
          P[i] := false;


    {si une note s'affiche dans une portée, la portée est déclarée comme utile
          (P[portee] := true)}
    for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
         for i := 0 to high(Voix[v].Elmusicaux) do with Elmusicaux[i] do
               if IsSilence then
                    P[position.portee] := true
               else
                  for n := 0 to high(Notes) do
                      P[Notes[n].position.portee] := true;

    result := P;
End;



Function TMesure.Is_Portee_Utile(iportee: integer): Boolean;
var v, i, n: integer;
Begin
    result := false;
    for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
         for i := 0 to high(Voix[v].Elmusicaux) do with Elmusicaux[i] do
               if IsSilence then
               Begin
                    if position.portee = iportee then
                    Begin
                           result := true;
                           Exit;
                    End;
               End
               else
                  for n := 0 to high(Notes) do
                      if Notes[n].position.portee = iportee then
                    Begin
                           result := true;
                           Exit;
                    End;
End;



Procedure TMesure.RemplirLastPixx;
{met à jour les champs lastpixx des objets contenus dans la mesure}

var v, i: integer;
Begin
    for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
         for i := 0 to high(ElMusicaux) do with ElMusicaux[i] do
                  lastpixx := pixx;

End;




procedure TMesure.SelectionnerTout;
var v: integer;
Begin
   for v := 0 to high(Voix) do
        Voix[v].SelectionnerTout;
End;



Function TMesure.Selection_Valider: Boolean;
var v: integer;
Begin
   result := false;
   for v := 0 to high(Voix) do
        if Voix[v].Selection_Valider then
                result := true;
End;

procedure TMesure.NoteSilence_Fusionner_Si_SilenceCourt;
var v: integer;
Begin
   for v := 0 to high(Voix) do
   if Voix[v].N_Voix >= 0 then
       Voix[v].NoteSilence_Fusionner_Si_SilenceCourt;

End;




procedure TMesure.SimplifierEcriture;
var v: integer;
Begin
   for v := 0 to high(Voix) do
       Voix[v].SimplifierEcriture;

   Nettoyer;
End;

Destructor TMesure.Destroy;
var v: integer;
Begin
    for v := 0 to high(Voix) do
        Voix[v].Free;

    for v := 0 to high(mgoi) do
        mgoi[v].Free;
    
    inherited Destroy;
End;



Function TMesure.GetPortee_Utile_Min_iPortee: integer;
{renvoie l'indice de portées le plus petit utilisé dans les él. musicaux présents
 dans la mesure}

var v, i: integer;

Begin
    result := infinity;

    for v := 0 to high(Voix) do
       with Voix[v] do
          for i := 0 to high(ELmusicaux) do
              with ElMusicaux[i] do
                 if IsSilence then
                 Begin
                      if result > position.portee then
                            result := position.portee;
                 End
                 else
                     If result > GetNoteHaut.position.portee then
                           result := GetNoteHaut.position.portee;
End;





procedure TMesure.InsererElMusicalAuTemps_AlaFin(t1: TRationnel; el: TElMusical);
var v: integer;
var v_meilleure: integer;
var meilleur_score: integer;
    score_courant: integer;

const flop = -1000;
    
Begin
     v_meilleure := -1;
     meilleur_score := flop;
     for v := 0 to high(Voix) do
     If Voix[v].N_Voix < 0 then
     Begin
         score_courant := Voix[v].Inserer_ElMusical_AuTemps_A_La_Fin_Get_Score(t1, el);

         if score_courant > meilleur_score then
         Begin
               meilleur_score := score_courant;
               v_meilleure := v;
         End;
     End;


     if meilleur_score > flop then
           Voix[v_meilleure].Inserer_ElMusical_AuTemps_A_La_Fin(t1, el)
     else
           VoixNum(-length(Voix) - 1).Inserer_ElMusical_AuTemps_A_La_Fin(t1, el);
           //VoixNum(length(Voix) + 1).Inserer_ElMusical_AuTemps_A_La_Fin(t1, el);

End;




Function TMesure.mgoi_TempsToIndicemgoiApres(temps: TRationnel): integer;
var i: integer;
Begin
    result := high(mgoi)+34;
    temps := QAdd(temps , Qel(1));
    for i := 0 to high(mgoi) do
          if IsQ1InfQ2(temps, mgoi[i].t) then
          Begin
                result := i;
                Exit;
          End;

End;



Function TMesure.mgoi_TempsToIndicemgoiAvant(temps: TRationnel): integer;
var i: integer;
Begin
    result := -1;
    temps := QAdd(temps , Qel(1));
    for i := high(mgoi) downto 0 do
          if IsQ1StrInfQ2(mgoi[i].t, temps) then
          Begin
                result := i;
                Exit;
          End;

End;






end.
