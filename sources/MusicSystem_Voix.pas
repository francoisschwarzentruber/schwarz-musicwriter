unit MusicSystem_Voix;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_Types {pour TPosition},
     MusicSystem_ElMusical_Duree, {pour IsDureeAffichable}
     MusicSystem_ElMusical,
     MusicHarmonie;



const
         nbmaxvoixparportees = 4; {si par hasard, un jour tu veux augmenter le nb
                                 max de voix par portees, tu peux...
                                 inconvénient : l'interface est plus lourde}

const
     SepSyllabe = #9;     {caractère qui sépare les syllabes dans les paroles}
     N_VOIX_INDEFINI = -1;

                                      
type

{une voix c'est une succession d'él. musicaux}
TVoix = class(TObject)
public
   N_Voix:integer;
   {numéro de la voix}


   

   Paroles_Mais_Sert_Plus: string;

   ElMusicaux: array of TElMusical;
   {listes des éléments musicaux}

   Function Get_N_Voix_Portee: integer;
   Function Get_N_Voix_NumVoix_Dans_Portee: integer;

   Procedure Set_N_Voix(iportee, inum: integer);

   Function SurTemps(indice: integer): TRationnel;
   {renvoie le temps sur l'élément en question...
 rem : SurTemps(0) renvoit 1
       SurTemps(indice trop grand) = temps à la fin de la voix}

   Function DureeTotale: TRationnel;
   {renvoie la durée totale de la voix
     ex : si la voix contient une noire et une croche, ça renvoie 3/2}

   Function IndiceSurTemps(t: TRationnel): integer;
   {à partir du temps écoulé depuis le début de la voix, renvoie l'indice
 ex : si t = 1/1, renvoie 0
      si la contient 3 croches, t = 2/1, renvoie 2}

   Function FindElMusicalApres(pixx:integer; var indice: integer): Boolean;
   {renvoit vrai si dessus
          faux si avant

   place dans i, l'indice qu'aurait un élément en x si inséré

   S'il n'y a pas d'él. musicaux, renvoit false et met indice à 0}


   Function FindElMusicalApresTemps(temps: TDuree; var indice: integer): Boolean;
   {calcule l'indice de l'él. mus. situé "à peu près" sur le temps temps
 renvoie vrai ssi l'élément est pile dessus

 ex : si t = 1/1, calcule 0, renvoie vrai
      si la contient 3 croches, t = 2/1, calcule 2, renvoie vrai
      si la contient 3 croches, t = 3/4, calcule 2, renvoie faux}

   Function NbElMusicaux: integer;

   Procedure AddElMusical(indice: integer; elmusical: TElMusical);
   {insère elmusical dans la voix à l'emplacement indice (au final, elmusical
 aura pour indice indice)

 rem : elmusical doit <> nil, initialisé
       AddElmusical ne fait pas de copie de elmusical mais ajoute en fait
       en interne un pointeur }


    procedure AddElMusicalFin(elmusical: TElMusical);
{ajoute un él. musical à la fin de la voix
 --> cette procédure sert surtout pour les scripts... car elle n'a qu'un
     argument. C'est plus pratique !!

 rem : même spécification que AddMusical
       + si elmusical = nil, alors ne fait rien }

   Function DelElMusical(indice: integer):Boolean;
   {supprime l'él. musical d'indice indice
    renvoie vrai ssi l'indice est correct, ie ssi il y a bien eu supression}







   Procedure InsererContenuVoix(i: integer; voix2: TVoix;  inverser: Boolean);
   {insère le contenu de la voix2 dans la voix courante
     le premier élément de voix2 aura l'indice de i dans la voix}

   Procedure InsererContenuVoixRel(i: integer; voix2: TVoix; portee: integer; inverser: Boolean);
   {comme InsererContenuVoix... mais il y a des décalages de portées.
     en gros, le premier élément de la voix2 sert de référence et sera placé
               dans la portee portee}


   procedure InsererContenuVoixAlaFin(voix2: TVoix; inverser: Boolean);



   Procedure DecalePosX(apartirde: integer; dediffx: integer);
   {ajoute dediffx aux pixx des él. musicaux de la voix, s'il se trouve au delà de
    apartirde (si pixx >= apartirde
    (ça sert pour insérer les clefs)}

   Function IsVide:Boolean;
   {renvoie vrai ssi la voix est vide (pas d'él. mus.)}

   Function IsAffichee: Boolean;
   {renvoie vrai ssi elle est affichée}

   Function IsEntendue: Boolean;
   {renvoie vrai ssi la voix est jouée}


   Procedure Trainees_Draw;

   Procedure DrawFond(liseraiuniquement: Boolean; Width: integer);
   {dessine une bande (de couleur) qui suit les él. mus. de la voix
     liseraiuniquement vrai => on ne dessine que un pourtoir en pointillé
     Width = longueur de la mesure}

   Function DrawVoix(dureemes: TRationnel): TRationnel;
   {dessine la voix (él. mus. + paroles, mais PAS le fond des voix)
    on renseigne la fonction de la durée de la mesure}

   Function DistPointFondVoix(i, Y, Width:integer): integer;

   Function PointInFondVoix(X, Y, Width:integer): Boolean;
   {est ce que le point X, Y (coord. dans la mesure) se trouve dans la bande
    de couleur ? (Width = longueur de la mesure)}


   procedure Save;
   {sauve ou lit la voix dans un fichier}

   Procedure CalcGrpNotes(const DureeGrpNote: TRationnel);
   {calcule les "groupes de notes" (les reliages de croches par barre...)
    DureeGrpNote désigne la durée d'un groupe de notes

     ex : pour une mesure en 4/4, 3/4, DureeGrpNote = 1/1
          pour une mesure en 6/8, DureeGrpNote = 3/2

    }

   Procedure InsererDesPauses_EnFin(P: TListeRationnel; portee: integer);
   {insére en fin de voix, sur la portée portee, une liste de pauses dont les
 durées sont écrites dans P}

   Function PorteeApprox: integer;
   {en gros, indique sur quelle portée se trouve la voix}

   Procedure TorrentAlterer(pos: TPosition; x: integer; alt: TAlteration);
   {altère toutes les notes, qui ont pour position pos, à partir de l'abscisse x
   (dans le repère de la mesure)}

   procedure TranslationPortee(dp: integer);
   {translate la portée
  ex : si la voix ne contient que des éléments de la portée 0 et 1, dont le
        premier élément est sur la portée p0 = 1
       faire un appel à TranslationPortee(2) revient à placer
         les éléments de la portée 0 sur la portée p0 + 0 = 1
         les éléments de la portée 1 sur la portée p0 + 1 = 2

      rem : si portee = 0, TranslationPortee ne fait rien}


   procedure SelectionnerTout;
   Function Selection_Valider: Boolean;


   Destructor Destroy; override;

   Function CreerElMusicalGrosAccord: TElMusical;

 {procédure de test-vérification pour les pré-post cond}
   procedure VerifierIntegrite(const info: string);

   procedure SupprimerTousLesElMusicaux;

   procedure NoteSilence_Fusionner_Si_SilenceCourt;
   procedure SimplifierEcriture;

   Function Is_QueDesSilences :Boolean;

   Function GetNbNotes: integer;

   Function Is_Compatible_A_L_Insertion(t1, duree: TRationnel): boolean;
   {sert pas pour l'instant}

   procedure ElMusicaux_Queues_Calculer;

   Procedure Inserer_CopieElMusical_AuTemps(temps: TRationnel; el: TElMusical);

   procedure Inserer_ElMusical_AuTemps_A_La_Fin(temps: TRationnel; el: TElMusical);
   Function Inserer_ElMusical_AuTemps_A_La_Fin_Get_Score(temps: TRationnel; el: TElMusical): integer;

   Function VerifierIndiceElMusical(var i: integer; mess: string): Boolean;
   Procedure VerifierIndiceElMusicalOuFin(var i: integer; mess: string);

   Procedure RegleMesure_DeplacerTic(temps1, temps2: TRationnel);
   Procedure RegleMesure_Etirer(temps_debut, temps1, temps2: TRationnel);

   procedure Durees_Inferences_Inferer(t1, t2: TRationnel);

   Function DernierElementMusical_Get: TElMusical;
   Function IsVoixBrouillon: Boolean;

   
   private
      Function Essayer_D_Inserer_ElMusical_AuTemps_A_La_Fin(temps: TRationnel; el: TElMusical; test_seulement: Boolean): integer;

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
     MusicGraph_CouleursUser,
     MusicSystem_Constantes,
     QSystem_Inference,
     Interface_Questions;

var private_Points: array of TPoint;
{variable pour dessiner les polygones
 elle est globale pour éviter les réalocations mémoires}


 
//Voix
//******************************************************************************



Function TVoix.Get_N_Voix_Portee: integer;
Begin
     result := IGP.Voix_Indice_To_Portee(N_Voix);
End;



Function TVoix.Get_N_Voix_NumVoix_Dans_Portee: integer;
Begin
    result := IGP.Voix_Indice_To_NumVoixDansPortee(N_Voix);
End;


Procedure TVoix.Set_N_Voix(iportee, inum: integer);
Begin
     N_Voix := inum * IGP.NbPortees + iportee;
End;




Function TVoix.NbElMusicaux: integer;
Begin
      result := length(ElMusicaux);
End;




procedure TVoix.AddElMusical(indice: integer; elmusical: TElMusical);
{insère elmusical dans la voix à l'emplacement indice (au final, elmusical
 aura pour indice indice)

 rem : elmusical doit <> nil, initialisé
       AddElmusical ne fait pas de copie de elmusical mais ajoute en fait
       en interne un pointeur }

var i: integer;
Begin
    if indice > length(ElMusicaux) then
    Begin
           MessageErreur('Un indice trop grand a été donné à TVoix.AddElMusical !' +
             ' Les paramètres sont (' + inttostr(indice) + ', ' +
             ElMusicalToStr(elmusical, true) + ')' );
           indice := length(ElMusicaux);
    End;

    setlength(ElMusicaux, length(ElMusicaux)+1);
    for i := high(ElMusicaux) downto indice + 1 do
            ElMusicaux[i] := ElMusicaux[i-1];

    elmusical.NumVoix := N_Voix;
    
    ElMusicaux[indice] := elmusical;

End;



procedure TVoix.AddElMusicalFin(elmusical: TElMusical);
{ajoute un él. musical à la fin de la voix
 --> cette procédure sert surtout pour les scripts... car elle n'a qu'un
     argument. C'est plus pratique !!

 rem : même spécification que AddMusical
       + si elmusical = nil, alors ne fait rien }
var l: integer;

Begin
    if elmusical <> nil then
    Begin
          elmusical.VerifierIntegrite('AddElMusicalFin');
          l := length(ElMusicaux);
          setlength(ElMusicaux, l+1);
          ElMusicaux[l] := elmusical;
    End;
End;




Procedure TVoix.InsererContenuVoix(i: integer; voix2: TVoix; inverser: Boolean);
{le premier élément de voix2 aura l'indice de i dans la voix

rem : cette fonction fait des copies ! ouf !}

var nbel2, j: integer;


Begin
    if i > high(ElMusicaux) then
           i := high(ElMusicaux)+1;

    if i < 0 then
          i := 0 ;

    nbel2 := length(voix2.ElMusicaux);

    //fait de la place dans la voix courante
    setlength(ElMusicaux, length(ElMusicaux)+nbel2);
    for j := high(ElMusicaux) downto i + nbel2 do
            ElMusicaux[j] := ElMusicaux[j-nbel2];

    //insère
    for j := 0 to nbel2-1 do
        if inverser then
             ElMusicaux[i+nbel2-1-j] := CopieElMusical(voix2.elmusicaux[j])
        else
             ElMusicaux[i+j] := CopieElMusical(voix2.elmusicaux[j]);

    for j := 0 to nbel2-1 do
        ElMusicaux[i+j].NumVoix := N_Voix;  
End;




procedure TVoix.InsererContenuVoixAlaFin(voix2: TVoix; inverser: Boolean);
Begin
    InsererContenuVoix(NbElMusicaux, voix2, inverser);
End;




procedure TVoix.TranslationPortee(dp: integer);
{translate la portée
  ex : si la voix ne contient que des éléments de la portée 0 et 1, dont le
        premier élément est sur la portée p0 = 1
       faire un appel à TranslationPortee(2) revient à placer
         les éléments de la portée 0 sur la portée p0 + 0 = 1
         les éléments de la portée 1 sur la portée p0 + 1 = 2}
var n, j: integer;
Begin
      for j := 0 to high(ElMusicaux) do
      Begin
               With elmusicaux[j] do
               if IsSilence then
                     inc(position.portee,dp)
               else
                     for n := 0 to high(Notes) do
                           inc(Notes[n].position.portee,dp);
      End;

End;







Procedure TVoix.InsererContenuVoixRel(i: integer; voix2: TVoix; portee: integer; inverser: Boolean);
{le premier élément de voix2 aura l'indice de i dans la voix}

var nbel2, j, n: integer;
    porteeref: integer;
    el: TElMusical;
Begin
      if i < 0 then
            MessageErreur('i négatif dans InsererContenuVoixRel');

      if i > high(ElMusicaux) then
             i := high(ElMusicaux)+1;



      porteeref := voix2.PorteeApprox;      
      nbel2 := length(voix2.ElMusicaux);
      setlength(ElMusicaux, length(ElMusicaux)+nbel2);

      for j := high(ElMusicaux) downto i + nbel2 do
              ElMusicaux[j] := ElMusicaux[j-nbel2];

      for j := 0 to high(voix2.ElMusicaux) do
      Begin
               el := CopieElMusical(voix2.elmusicaux[j]);
               if inverser then
                   ElMusicaux[i+nbel2-1-j] := el
               else
                   ElMusicaux[i+j] := el;

               With el do
               if IsSilence then
                     inc(position.portee, portee - porteeref)
               else
                     for n := 0 to high(Notes) do
                           inc(Notes[n].position.portee, portee - porteeref);
      End;

End;


Function TVoix.FindElMusicalApres(pixx:integer; var indice: integer): Boolean;
const miniwith = nbpixlign;
{renvoit vrai si dessus
          faux si avant

 place dans indice, l'indice qu'aurait un élément en x si inséré

 S'il n'y a pas d'él. musicaux, renvoit false et met indice à 0

 post-conditions : indice est compris entre 0 et length(ElMusicaux) inclus
                   indice = length(ElMusicaux) ===> renvoie false
                     (car on ne peut pas être sûr à un él. mus. dont
                      l'indice n'est pas valide)
                   }
var i:integer;
Begin
    if length(ElMusicaux) = 0 then
    Begin
              indice := 0;
              result := false;
    End else
    Begin
          For i := 0 to high(ElMusicaux) do
                  if abs(ElMusicaux[i].pixx - pixx) <= ElMusicaux[i].pixwidth div 2 then
                        Begin
                               indice := i;
                               result := true;
                               Exit;
                        End;


          For i := 0 to high(ElMusicaux) do
                  if ElMusicaux[i].pixx > pixx then
                           Break;


          indice := i;
          result := false;

    end;
End;



Function TVoix.FindElMusicalApresTemps(temps: TDuree; var indice: integer): Boolean;
{calcule l'indice de l'él. mus. situé "à peu près" sur le temps temps
 renvoie vrai ssi l'élément est pile dessus

 ex : si t = 1/1, calcule 0, renvoie vrai
      si la contient 3 croches, t = 2/1, calcule 2, renvoie vrai
      si la contient 3 croches, t = 3/4, calcule 2, renvoie faux}

var r:TRationnel;
    i:integer;
Begin
    r := Qel(1);

    For i := 0 to high(ElMusicaux) do
    Begin
            if IsQ1InfQ2(temps, r) then
                    Break;
            QInc(r, ElMusicaux[i].Duree_Get);
    end;


    result := IsQEgal(r ,temps);
    indice := i;

End;

Function TVoix.SurTemps(indice: integer): TRationnel;
{renvoit le temps sur l'élément en question...
 rem : SurTemps(0) renvoit 1
       SurTemps(indice trop grand) = temps à la fin de la voix}

var r:TRationnel;
    i:integer;
Begin
     r := Qel(1);

     if indice > high(ElMusicaux) then
            indice := high(ElMusicaux)+1; 
     for i := 0 to indice-1 do
          QInc(r, ElMusicaux[i].Duree_Get);

     result := r;


End;



Function TVoix.DureeTotale: TRationnel;
var r:TRationnel;
    i:integer;
Begin
     r := Qel(0);

     for i := 0 to high(ElMusicaux) do
     Begin
          QVerifierQPasTropBizarre(r, 'r');


          QVerifierQPasTropBizarre(ElMusicaux[i].Duree_Get, 'ElMusicaux[i].Duree');
          QInc(r, ElMusicaux[i].Duree_Get);
          r := QPasTropGrandDenominateur(r);
     End;

     result := r;

End;



Function TVoix.IndiceSurTemps(t: TRationnel): integer;
{à partir du temps écoulé depuis le début de la voix, renvoie l'indice
 ex : si t = 1/1, renvoie 0
      si la contient 3 croches, t = 2/1, renvoie 2}
var r:TRationnel;
    i:integer;

Begin
     r := Qel(1);

     for i := 0 to high(ElMusicaux) do
     Begin
          if IsQ1InfQ2(t, r) then
                Break;
                
          QInc(r, ElMusicaux[i].Duree_Get);
     End;

     if high(ElMusicaux) = -1 then
            i := 0;

     result := i;



End;


Procedure TVoix.DecalePosX(apartirde: integer; dediffx: integer);
{ajoute dediffx aux pixx des él. musicaux de la voix, s'il se trouve au delà de
    apartirde (si pixx >= apartirde}

var i:integer;
Begin
    For i := 0 to high(ElMusicaux) do
    Begin
        if Elmusicaux[i].pixx >= apartirde then
                inc(Elmusicaux[i].pixx, dediffx);

    End;

End;


Function TVoix.DelElMusical(indice: integer):Boolean;
var i:integer;
Begin
    if (indice < 0) or (indice > high(ElMusicaux)) then
           result := false
    else
    Begin
         ElMusicaux[indice].free;
         For i := indice to high(ElMusicaux)-1 do
               ElMusicaux[i] := ElMusicaux[i+1];

         Setlength(ElMusicaux, high(ElMusicaux));
         result := true;
    end;
End;




Procedure TVoix.InsererDesPauses_EnFin(P: TListeRationnel; portee: integer);
{insére en fin de voix, sur la portée portee, une liste de pauses dont les
 durées sont écrites dans P}

var i,j:integer;
Begin
      i := length(ElMusicaux);
      Setlength(ElMusicaux, i + length(P));

      for j := 0 to high(P) do
             ElMusicaux[i+j] := CreerElMusicalPause(P[j], portee);


End;



Function  TVoix.PorteeApprox: integer;
Begin
      if high(Elmusicaux) = -1 then
           result := 0
      else
           result := ElMusicaux[0].PorteeApprox;


End;




Function TVoix.IsVide:Boolean;
Begin
    if (N_Voix < 0) and Is_QueDesSilences then
        result := true
    else
        result := (high(ElMusicaux) = -1);
End;




Function TVoix.IsAffichee: Boolean;
{renvoit vrai si la voix doit être affiché (enfin Schwarz MusicWriter permet
 de masquer des voix...)}
Begin
    if (ViewCourant = nil) then
        result := true
    else if IGP = nil then
        result := true
    else if (N_Voix >= 0) and (N_Voix <= high(ViewCourant^.VoixAffichee)) then
        result := ViewCourant^.VoixAffichee[N_Voix] and
                  IGP.Portee_IsVisible(Get_N_Voix_Portee)
    else if N_Voix = N_VOIX_INDEFINI then
         result := true
    else if N_Voix < 0 then
         result := true
    else
        result := false;

End;


Function TVoix.IsEntendue: Boolean;
Begin
    if (N_Voix < 0) or (N_Voix > high(ViewCourant^.VoixEntendue)) then
        result := true
    else
          result := ViewCourant^.PorteeEntendue[Get_N_Voix_Portee] and
                    ViewCourant^.VoixEntendue[N_Voix];

End;


Procedure TVoix.TorrentAlterer(pos: TPosition; x: integer; alt: TAlteration);
var i: integer;
Begin
      FindElMusicalApres(X, i);

      for i := i to high(ElMusicaux) do
           if not ElMusicaux[i].IsSilence then
                ElMusicaux[i].Alterer(pos, alt);
End;


Procedure TVoix.Trainees_Draw;
var i: integer;
Begin
     for i := 0 to high(ElMusicaux) do
          ElMusical_Trainee_Draw(IGP, IGiLigne, ElMusicaux[i]);
End;


Procedure TVoix.DrawFond(liseraiuniquement: boolean; Width: integer);
{dessine une bande (de couleur) qui suit les él. mus. de la voix
     liseraiuniquement vrai => on ne dessine que un pourtoir en pointillé
     Width = longueur de la mesure}
     
var he, le, nbpoints: integer;
    i:integer;
    miny, maxy: integer;

Begin
      he := high(ElMusicaux);
      if he = -1 then
             Exit;

      le := he + 1;

    nbpoints := 2 * le + 4;

    if length(private_Points) < nbpoints then
        setlength(private_Points,nbpoints);

      {P[0..le+1] : courbe du haut de g à droite
       P[le+2..2*le+3] : courbe du bas de droite à g}
      private_Points[0] := ScrPoint(pixxorigin, pixyorigin + ElMusicaux[0].pixyhaut - largfondvoix2);
      private_Points[2*le+3] := ScrPoint(pixxorigin, pixyorigin + ElMusicaux[0].pixybas + largfondvoix2);

      miny := min(private_Points[0].y, private_Points[2*le+3].y);
      maxy := min(private_Points[0].y, private_Points[2*le+3].y);

      private_Points[le+1] := ScrPoint(pixxorigin + Width,
                          pixyorigin + ElMusicaux[he].pixyhaut - largfondvoix2);

      private_Points[le+2] := ScrPoint(pixxorigin + Width,
                          pixyorigin + ElMusicaux[he].pixybas + largfondvoix2);

      miny := min(private_Points[le+1].y, miny);
      maxy := max(private_Points[le+1].y, maxy);
      miny := min(private_Points[le+2].y, miny);
      maxy := max(private_Points[le+2].y, maxy);

      for i := 0 to he do
      Begin
             private_Points[1+i] := ScrPoint(pixxorigin + ElMusicaux[i].pixx,
                                pixyorigin + ElMusicaux[i].pixyhaut - largfondvoix2);
             miny := min(private_Points[1+i].y, miny);
             maxy := max(private_Points[1+i].y, maxy);
             private_Points[2*le + 2 - i] := ScrPoint(pixxorigin + ElMusicaux[i].pixx,
                                         pixyorigin + ElMusicaux[i].pixybas + largfondvoix2);
             miny := min(private_Points[2*le + 2 - i].y, miny);
             maxy := max(private_Points[2*le + 2 - i].y, maxy);

      End;

      if miny > CHeight then
            exit
      else if maxy < 0 then
            exit;

      if liseraiuniquement then
      Begin
          if liseraijoliencourbe then
          Begin
             PolyBezier(C.Handle, private_Points[0],le+2);
             PolyBezier(C.Handle, private_Points[le+2],le+2);
          End
          else
          Begin
              Polyline(C.Handle, private_Points[0],le+2);
              Polyline(C.Handle, private_Points[le+2],le+2);
          End;
      End
      else
          Polygon(C.Handle, private_Points[0],nbpoints);



End;

Function TVoix.DistPointFondVoix(i, Y, Width:integer): integer;
{renvoie un entier qui indique la distance du point (X, Y) (dans le repère de la
 mesure) par rapport à la voix

 si ça renvoie 0, on est en gros dans le "polygone" en filigrane
 sinon, plus la fonction renvoie un entier grand, plus on est loin
}

var  y1, y2 : integer;

Begin
//pré-conditions :
    If IsVide then
         MessageErreur('Arf ! "DistPointFondVoix" a été appelé alors que la voix est vide !');



//normalement, i est bien un bon indice d'él. mus.
    With ElMusicaux[i] do
    Begin
        y1 := pixyhaut - largfondvoixtest2;
        y2 := pixybas + largfondvoixtest2;

        if (y1 <= y) and (y <= y2) then
            result := 0
        else
            result := min(abs(y - y1), abs(y - y2));

    End;
    
End;

Function TVoix.PointInFondVoix(X, Y, Width:integer): Boolean;
{renvoie vrai ssi le point (X, Y) (coord. de la mesure) se trouve dans le
 polygone en filigrane de la voix

 width = largeur de la mesure}

var
    he, le, nbpoints: integer;
    i:integer;
    r : HRGN;
    err: integer;

Begin

    he := high(ElMusicaux);
    le := he + 1;
    if he = -1 then
    Begin
           result := false;
           Exit;
    End;

    nbpoints := 2 * le + 4;

    if length(private_Points) < nbpoints then
        setlength(private_Points,nbpoints);

    private_Points[0] := Point(0, ElMusicaux[0].pixyhaut - largfondvoixtest2);
    private_Points[2*le+3] := Point(0, ElMusicaux[0].pixybas + largfondvoixtest2);

    private_Points[le+1] := Point(Width, ElMusicaux[he].pixyhaut - largfondvoixtest2);
    private_Points[le+2] := Point(Width, ElMusicaux[he].pixybas + largfondvoixtest2);

    for i := 0 to he do
    Begin
           private_Points[1+i] := Point(ElMusicaux[i].pixx,
                              ElMusicaux[i].pixyhaut - largfondvoixtest2);
           private_Points[2*le + 2 - i] := Point(ElMusicaux[i].pixx,
                                       ElMusicaux[i].pixybas + largfondvoixtest2);
    End;



    r := CreatePolygonRgn(private_Points[0], nbpoints, ALTERNATE );
    {c'est très important de mettre ALTERNATE (depuis xp)
    mais 0 ça marchait dans win 98}
    err := GetLastError;

{    if err = 0 then
       MessageErreur('Erreur dans PointInFondVoix...');  } //A REVOIR
        
    result := PtInRegion(r, X, Y);

    DeleteObject(r);

End;






Procedure TVoix.Save;
var e, l:integer;
Begin
      FichierDoInt(N_Voix);



      if VFF >= 3 then
           FichierDoStr(Paroles_Mais_Sert_Plus);

      FichierDoInt(l, length(ElMusicaux));

      if EnLecture then
      Begin
               Setlength(ElMusicaux, l);
               for e := 0 to high(ElMusicaux) do
               Begin
                     ElMusicaux[e] := TElMusical.Create;
                     ElMusicaux[e].NumVoix := N_Voix;
               End;

      end;
      for e := 0 to high(ElMusicaux) do
            ElMusicaux[e].Save;

End;




Function TVoix.DrawVoix(dureemes: TRationnel): TRationnel;
{dureemes est la durée de la mesure...

 cet argument permet de dessiner les éléments musicaux en rouge, à part du moment
  qu'il dépasse de la durée de la mesure

  renvoie la durée totale de la voix}

var el_courant_i {indice de l'él. mus. courant},
    j:integer;
    nbTraitRelie: integer;
    posInParole, posInParoleNext: integer;
    dureedepuisdebut: TRationnel;
    mn: boolean;

    
    iDebutGroupe, iFinGroupe, iDebutSousGroupe: integer;
    {indice du premier et du dernier él. du groupe}

    Pente: real;
    {pente des traits dans le groupe}


    NbTraitsCourants: integer;

    iDepartTrait: array[1..5] of integer;
    {pour chaque trait, 1 de croche, 2 de double-croche... indique l'él. de départ
     seul les données en 1..NbTraitsCourants sont valables}

    NbTraitsNouveau: integer;
    {variable tampon}





    function DrawVoix_Erreur_Resume_Get: string;
    Begin
        result := 'ETAT DES VARIABLES : ' +
                   ' ; el_courant_i = ' + inttostr(el_courant_i) +
                   '; iDebutGroupe = ' + inttostr(iDebutGroupe) +
                   ' ; iFinGroupe = ' + inttostr(iFinGroupe) +
                   ' ; iDebutSousGroupe = ' + inttostr(iDebutSousGroupe) +
                   ' ; NbTraitsNouveau = ' + inttostr(NbTraitsNouveau) +
                   ' ; NbTraitsCourants = ' + inttostr(NbTraitsCourants) +
                   ' ; iDepartTrait[1] = ' + inttostr(iDepartTrait[1]) +
                   ' ; iDepartTrait[2] = ' + inttostr(iDepartTrait[2]) +
                   ' ; iDepartTrait[3] = ' + inttostr(iDepartTrait[3]);

    End;
     
    Function PasTraitY(QueueVersBas: Boolean): integer;
    Begin
    if QueueVersBas then
    //les queues sont le bas, on commence à tracer du bout par en bas
           result := -nbpixdifftrait
    Else
           result := nbpixdifftrait;
    End;





    Procedure RelierCrocheNote(el1, el2: TElMusical; NumTrait: integer);
    {relie les el. mus. el1,el2 avec un trait au niveau NumTrait}


    var x1, x2,
        pasy, yor1, yor2: integer;
    Begin
          dec(NumTrait);
          x1 := el1.GetXQueue + 1;
          x2 := el2.GetXQueue;
          yor1 := el1.YExtremiteQueue;
          pasy := PasTraitY(el1.QueueVersBas);

          if el1.QueueVersbas <> el2.QueueVersbas then
                 yor2 := el2.YExtremiteQueue + PasTraitY(el2.QueueVersBas) * NbTraitRelie
          else
                 yor2 := el2.YExtremiteQueue;

          SetGrosseurTrait(EpaisseurTraitCroche[el1.TailleNote]);
          TraitDeCroche(x1, yor1 + pasy * NumTrait, x2, yor2 + pasy * NumTrait);

          SetGrosseurTrait(0);

    End;



    Procedure TraitVersLaGauche(el2: TElMusical; NumTrait : integer);
    {dessine les petits traits vers la gauche}

    var  x2, y,
        pasy, yor2: integer;
    Begin
          dec(NumTrait);
          x2 := el2.GetXQueue;

          pasy := PasTraitY(el2.QueueVersBas);
          yor2 := el2.YExtremiteQueue;
          SetGrosseurTrait(EpaisseurTraitCroche[el2.TailleNote]);

          y := yor2 + pasy * NumTrait;
          TraitDeCroche(x2, y, x2 - longXPetitTrait, y - round(Pente * longXPetitTrait));

          SetGrosseurTrait(0);
    End;


     Procedure TraitVersLaDroite(el2: TElMusical; NumTrait : integer);
    {dessine les petits traits vers la droite}

    var x2, y,
        pasy, yor2: integer;
    Begin
          dec(NumTrait);
          x2 := el2.GetXQueue;

          pasy := PasTraitY(el2.QueueVersBas);
          yor2 := el2.YExtremiteQueue;
          SetGrosseurTrait(EpaisseurTraitCroche[el2.TailleNote]);

          y := yor2 + pasy * NumTrait;
          TraitDeCroche(x2, y, x2 + longXPetitTrait, y + round(Pente * longXPetitTrait));

          SetGrosseurTrait(0);
    End;




    procedure DebutDeTrait(nbTrait: integer);
    {informe que le trait n° nbtrait démarre de l'él. musical courant}
    Begin
         VerifierIndiceElMusical(el_courant_i, 'DebutDeTrait dans DrawVoix');
         iDepartTrait[nbTrait] := el_courant_i;

    End;


    procedure FinirTraitSur(t, i: integer);
    {trace le trait n° t, jusqu'à l'el. musical}
    Begin
      {concrétement il s'agit de relier l'élément n° iDepartTrait[nbTrait] au n° i}
      VerifierIndiceElMusical(i, 'FinirTraitSur dans DrawVoix : i pas bon + DrawVoix_Erreur_Resume_Get');
      if not (t in [1..5]) then
      Begin
         MessageErreur('FinirTraitSur dans DrawVoix : t pas bon... il vaut ' + inttostr(t) + DrawVoix_Erreur_Resume_Get);
         t := 1;
      End;

      VerifierIndiceElMusical(iDepartTrait[t], 'FinirTraitSur dans DrawVoix : iDepartTrait[t] pas bon' + DrawVoix_Erreur_Resume_Get);

      if i = iDepartTrait[t] then
       {si le "reliage se fait sur le même el. musical, il faut juste mettre
           une petite marque}
           Begin
             {
  Si un trait doit être dessiné que sur UN el. musical, alors :
  - il est fait vers la droite ssi c'est le premier el. musical du groupe
  - sinon bah il est fait vers la gauche
  }
                 if i = iDebutGroupe then
                       TraitVersLaDroite(ElMusicaux[i], t)
                 else
                       TraitVersLaGauche(ElMusicaux[i], t);

           End
       else
             RelierCrocheNote(elMusicaux[iDepartTrait[t]], elMusicaux[i], t);

    End;


    procedure AfficherIndiceDeTrioletAuBesoin;
    {affiche si ya besoin, genre un 3 si ya un triolet dans le groupe
      iDebutSousGroupe - i}
    const DECALY_TEXT_CHIFFRE_TRIOLET_QUEUE_VERS_LE_BAS = 0;
          DECALY_TEXT_CHIFFRE_TRIOLET_QUEUE_VERS_LE_HAUT = -130;
          TEXT_CHIFFRE_TRIOLET_FONT_SIZE = 7;

    var x1, x2, y, j, chiffre, iportee,
        idebut, ifin                 : integer;
        q: TDuree; 
    Begin
          idebut := iDebutSousGroupe;
          ifin := el_courant_i;
          q := ElMusicaux[idebut].Duree_Get;

          for j := idebut+1 to ifin do
                if not IsQEgal(q, ElMusicaux[el_courant_i].Duree_Get) then
                 Begin
                       {MessageErreur('Problème d''affichage dans truc de triolet...' +
                       ' les durées des el. mus ne sont pas égales...'); }
                       exit;
                 End;
                 
          x1 := ElMusicaux[idebut].GetXQueue;
          x2 := ElMusicaux[ifin].GetXQueue;

          y := ElMusicaux[idebut].YExtremiteQueue + round(pente * (x2 - x1)) div 2;

          iportee := ElMusicaux[idebut].PorteeApprox;

          if ElMusicaux[idebut].QueueVersBas then
               y := y + AuZoomPortee(DECALY_TEXT_CHIFFRE_TRIOLET_QUEUE_VERS_LE_BAS, iportee)
          else
               y := y + AuZoomPortee(DECALY_TEXT_CHIFFRE_TRIOLET_QUEUE_VERS_LE_HAUT, iportee);

          chiffre := 0;

          if not IsPowerOf2(q.denom) then
                 chiffre := iFin - iDebut + 1;

          if chiffre <> 0 then
          Begin
                C.Brush.Style := bsClear;
                setFontSize(TEXT_CHIFFRE_TRIOLET_FONT_SIZE*ZoomPortee(PorteeApprox) div ZoomMaxPrec);
                TextOut((x1 + x2) div 2, y, inttostr(chiffre));
          End;



    
    End;



    procedure GestionSousGroupes;
    var j: integer;
    Begin
          VerifierIndiceElMusical(el_courant_i, 'GestionSousGroupes : i pas bon' + DrawVoix_Erreur_Resume_Get);



          if (el_courant_i < iFinGroupe) then
          Begin
            j := el_courant_i+1;
            VerifierIndiceElMusical(j, 'GestionSousGroupes : i+1 pas bon' + DrawVoix_Erreur_Resume_Get);
            el_courant_i := j-1;


            if (not IsQEgal(ElMusicaux[el_courant_i].Duree_Get, ElMusicaux[el_courant_i+1].Duree_Get)) then
            //non... c'est plutôt... est-ce que la décompo est pareil ??
            //A REVOIR !!!!!
            //si nouveau sous-groupe
            Begin
                 if ElMusicaux[el_courant_i].NbQueueAUtiliser
                     = ElMusicaux[el_courant_i+1].NbQueueAUtiliser then
                 Begin
                      FinirTraitSur(NbTraitsNouveau, el_courant_i);
                      dec(NbTraitsNouveau);
                      dec(NbTraitsCourants);
                 End;
                 AfficherIndiceDeTrioletAuBesoin;
                 iDebutSousGroupe := el_courant_i+1;
            End;



          End;
    End;




Begin {DrawVoix}

//préconditions
 // => on ne peut lancer DrawVoix que si la voix s'affiche !!!!!!!
      if Not IsAffichee then
            MessageErreur('NON et NON et NON !! Cette voix ne devrait pas s''afficher (voix numéro '
                                + inttostr(N_Voix) + ') !');


      setFontSize(10*ZoomPortee(PorteeApprox) div ZoomMaxPrec);

      posInParole := 1;

      dureedepuisdebut := Qel(0);
      mn := IsModeNuances;

          For el_courant_i := 0 to high(ElMusicaux) do
          with ElMusicaux[el_courant_i] do
          Begin
                  {=======réglage de la couleur==============}

                  if (CouleurDessin <> CouleurNoteDansVoixInactive)
                     and IsQ1InfQ2(dureemes, dureedepuisdebut)
                     and (CDevice = devEcran)
                     and IsModeCorrection then
                  //on imprime les notes qui dépasse de la mesure d'une autre couleur
                         CouleurDessin := CouleurStyloCorrection;

                  if mn and not (CouleurDessin = CouleurNoteDansVoixInactive) then
                  Begin
                         CouleurDessin := CouleurNuances(ElMusicaux[el_courant_i].attributs.Volume);
                         C.Pen.Color := CouleurDessin;
                  End;


                 { else
                         CouleurDessin := CouleurStylo;  }

                  if NvGroupe then
                  {si l'on commence un nouveau groupe}
                  Begin
                        iDebutGroupe := el_courant_i;
                        iDebutSousGroupe := el_courant_i;
                        iFinGroupe := high(ElMusicaux);
                        NbTraitsCourants := NbQueueAUtiliser;
                        NbTraitsNouveau := NbTraitsCourants;
                        for j := 1 to NbTraitsCourants do
                                DebutDeTrait(j);

                        for j := iDebutGroupe+1 to high(ElMusicaux) do
                                if ElMusicaux[j].NvGroupe then
                                Begin
                                     iFinGroupe := j-1;
                                     Break;
                                End;

                        {cas exceptionnel : le groupe ne fait qu'un el. mus.
                            ==> on le dessine tel quel}
                        if iDebutGroupe = iFinGroupe then
                        Begin
                             if not(ElMusicaux[el_courant_i].IsSilence and (N_Voix < 0)) then
                                 DrawElMusical(IGP, IGiLigne, ElMusicaux[el_courant_i], true, false);

                        End
                        else
                        {le groupe fait au moins deux éléments}
                        Begin
                             pente := (ElMusicaux[iFinGroupe].YExtremiteQueue
                                          - ElMusicaux[iDebutGroupe].YExtremiteQueue)
                                      / (ElMusicaux[iFinGroupe].GetXQueue
                                          - ElMusicaux[iDebutGroupe].GetXQueue);


                             DrawElMusical(IGP, IGiLigne, ElMusicaux[el_courant_i], false, false);
                             GestionSousGroupes;
                        End;
                  End
                  else
                  Begin






                  {iDebutGroupe et iFinGroupe représente les indices
                     respectifs du premier et du dernier élément du groupe

                   invariant : i appartient au segment [iDebutGroupe, iFinGroupe] }



                        DrawElMusical(IGP, IGiLigne, ElMusicaux[el_courant_i], false, false);
                        if not ElMusicaux[el_courant_i].IsSilence then
                        Begin
                            NbTraitsNouveau := NbQueueAUtiliser;

                            //if NbTraitsNouveau < NbTraitsCourants then
                                  {des traits finissaient sur l'ancien el. musical}
                                for j := NbTraitsNouveau+1 to NbTraitsCourants do
                                        FinirTraitSur(j, el_courant_i-1);

                            //if NbTraitsCourants < NbTraitsNouveau then
                            for j := NbTraitsCourants+1 to NbTraitsNouveau do
                                 DebutDeTrait(j);


                            {pas sûr !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
                            {gestion des sous-groupes}
                            GestionSousGroupes;


                            if el_courant_i = iFinGroupe then
                            Begin
                              for j := 1 to NbTraitsNouveau do
                                 FinirTraitSur(j, el_courant_i);
                              AfficherIndiceDeTrioletAuBesoin;
                            End;


                            NbTraitsCourants := NbTraitsNouveau;
                        End;




                  End;

            







                  QInc(dureedepuisdebut, ElMusicaux[el_courant_i].Duree_Get);
                  {compte la durée depuis le début de la mesure pour pouvoir
                   écrire en rouge quand on sort de la mesure}
        End;


        {Affichage des PAROLES =================}
        SetFontSize(10);
        C.Brush.style := bsclear;
        For el_courant_i := 0 to high(ElMusicaux) do
        With ElMusicaux[el_courant_i] do
          Begin
                  TextOut(ElMusicaux[el_courant_i].pixx,
                          GetY(IGiLigne, ElMusicaux[el_courant_i].PorteeApprox,
                               hauteurdesparoles),
                              Paroles_Syllabe);


          End;


      result := dureedepuisdebut;

End;





Procedure TVoix.CalcGrpNotes(const DureeGrpNote: TRationnel);
{s'occupe de remplir la propriété NvGroupe des TElMusical}

var tempsencours {où on en est dans la voix}: TRationnel;
    i {l'indice de l'el. courant},
    nbgroupecourant {numéro du groupe courant... on les compte comme ça on
                    peut bien découper}: integer;
    suivNvGroupe: Boolean;
    {variable qui dit si l'el. musical suivant sera le premier d'un nouveau groupe
     (cela se produit si l'él. courant est une pause...)}


Begin
    tempsencours := QZero;
    nbgroupecourant := 0;

    i := 0;
    while (i <= high(ElMusicaux)) do
    Begin
           ElMusicaux[i].NvGroupe := true;
           QInc(tempsencours, ElMusicaux[i].Duree_Get);
           suivNvGroupe := false;
           if ElMusicaux[i].IsSilence then
                 suivNvGroupe := true;
           inc(i);



           while (i <= high(ElMusicaux)) and
                 (QToInt(QDiv(tempsencours, DureeGrpNote)) = nbgroupecourant) do
           Begin
           {on reste dans cette boucle tant qu'on ne bouge de groupe...
            disons en fait, on peut créer des p'tits groupes quand même mais
            c'est dû à des événements pas très intéressants :
                - une pause (donc le reliage est interrompu)
                - une noire (donc pas de reliage)}
                
                  QInc(tempsencours, ElMusicaux[i].Duree_Get);
                  if suivNvGroupe then
                  Begin
                           ElMusicaux[i].NvGroupe := true;
                           suivNvGroupe := false;
                  End
                  else
                         ElMusicaux[i].NvGroupe := false;

                  if (ElMusicaux[i].NbQueueAUtiliser = 0)
                      or ElMusicaux[i].IsSilence then
                  Begin
                  {une pause, une noire, une blanche, une ronde...
                   sont toujours seul dans un groupe... autrement dit
                         Nvgroupe = true pour eux, et également
                         pour l'él. musical qui suit}
                         ElMusicaux[i].NvGroupe := true;
                         suivNvGroupe := true;
                  End;


                  inc(i);
           End;

           nbgroupecourant := QToInt(QDiv(tempsencours, DureeGrpNote));

    end;




    for i := 1 to high(ElMusicaux) do
    Begin
        if ElMusicaux[i].TailleNote <> ElMusicaux[i-1].TailleNote then
             ElMusicaux[i].NvGroupe := true;

        if ElMusicaux[i-1].Duree_IsApproximative then
        Begin
              ElMusicaux[i-1].NvGroupe := true;
              ElMusicaux[i].NvGroupe := true;
        End;
    End;
End;



procedure TVoix.SelectionnerTout;
var i :integer;

Begin
     for i := 0 to high(ElMusicaux) do
         ElMusicaux[i].SelectionnerElMusical;
End;



Function TVoix.Selection_Valider: Boolean;
var i :integer;
Begin
     result := false;
     for i := 0 to high(ElMusicaux) do
         if ElMusicaux[i].Selection_Valider then
               result := true;
End;

Destructor TVoix.Destroy;
var i: integer;
Begin
    for i := 0 to high(ElMusicaux) do
           ElMusicaux[i].Free;
           
    inherited Destroy;
End;




procedure TVoix.VerifierIntegrite(const info: string);
var i: integer;
Begin
    if length(ElMusicaux) = 0 then
          MessageErreur('Une voix est vide et n''a donc pas de raison d''exister !' + '. ' + info)
    else
    for i := 0 to high(ElMusicaux) do
           if ElMusicaux[i] = nil then
                 MessageErreur('L''élément musical n°' + inttostr(i) + ' n''est pas'
                                + 'initialisé !' + '. ' + info)
           else
                 ElMusicaux[i].VerifierIntegrite('Elément musical n° ' + inttostr(i) + '. ' + info);
End;








Function TVoix.GetNbNotes: integer;
var s, i: integer;
Begin
    s := 0;
    
    for i := 0 to high(ElMusicaux) do
        if not ElMusicaux[i].IsSilence then
          inc(s, ElMusicaux[i].NbNotes);

    result := s;
End;




Function TVoix.VerifierIndiceElMusical(var i: integer; mess: string): Boolean;
Begin
    if not ((0 <= i) and ( i <= high(ElMusicaux) )) then
    Begin
        MessageErreur('indice d''él. mus. qui vaut ' + inttostr(i)
                                     + '. C''est mal. On le met à 0. ' + mess);
        i := 0;
        result := false;
    End
    else
        result := true;
    
End;



Procedure TVoix.VerifierIndiceElMusicalOuFin(var i: integer; mess: string);
Begin
    if not ((0 <= i) and ( i <= length(ElMusicaux) )) then
    Begin
        MessageErreur('indice d''él. mus. qui vaut ' + inttostr(i)
                                     + '. C''est mal. On le met à 0. ' + mess);
        i := 0;
    End;
    
End;




Function TVoix.CreerElMusicalGrosAccord: TElMusical;
var duree: TRationnel;
var duree_approximative: Boolean;
var el: TElMusical;
    i: integer;
    
Begin
    duree_approximative := false;
    duree := Qel(0);
    el := TElMusical.Create;
    
    for i := 0 to high(ElMusicaux) do
    Begin
         el.AddNotesAutreElMusical(ElMusicaux[i]);
         duree := QAdd(duree, ElMusicaux[i].Duree_Get);

         if ElMusicaux[i].Duree_IsApproximative then
             duree_approximative := true;
    End;

    el.Duree_Set(duree);

    if duree_approximative then
         el.Duree_Approximative_SwitchTo;

    result := el;
    
End;




procedure TVoix.SupprimerTousLesElMusicaux;
var i :integer;

Begin
     for i := 0 to high(ElMusicaux) do
          ElMusicaux[i].Free;

     Finalize(ElMusicaux);
End;



procedure TVoix.NoteSilence_Fusionner_Si_SilenceCourt;
const DureePauseApproximativeParRapportNotesApproximativeTolerance = 1;

var i: integer;
    duree_somme: TRationnel;
Begin
     i := 1;

     while i<= high(ElMusicaux) do
     Begin
          duree_somme := QAdd(ElMusicaux[i-1].Duree_Get,
                              ElMusicaux[i].Duree_Get);
          {une note indéterminée avec un pause indéterminée très courte... pouf on rassemble}
          if ElMusicaux[i].IsSilence and
              ElMusicaux[i].Duree_IsApproximative and
              ElMusicaux[i].Duree_IsApproximative and
              (QToReal(ElMusicaux[i].Duree_Get) / QToReal(duree_somme)
                 < DureePauseApproximativeParRapportNotesApproximativeTolerance) then
           Begin
                DelElMusical(i);
                dec(i);
                ElMusicaux[i].DureeApproximative_Set(duree_somme);
           End;
           inc(i);
     End;
End;


Function TVoix.Is_QueDesSilences :Boolean;
var i: integer;
Begin
    result := true;

    for i := 0 to high(ElMusicaux) do
        if not ElMusicaux[i].IsSilence then
        Begin
            result := false;
            exit;
        End;
End;



procedure TVoix.SimplifierEcriture;


var i : integer;
    QueDesPauses: boolean;
    duree_somme: TRationnel;

Begin
    i := 0;

    QueDesPauses := true;

    while i<= high(ElMusicaux) do
       Begin
           if ElMusicaux[i].IsSilence and IsQNul(ElMusicaux[i].Duree_Get) then
                DelElMusical(i)
           else
           Begin

                 if not ElMusicaux[i].IsSilence then
                      QueDesPauses := false;

                 if i > 0 then
                 Begin
                     duree_somme := QAdd(ElMusicaux[i-1].Duree_Get,
                                               ElMusicaux[i].Duree_Get);


                     {o ~ o des notes liées pouf on rassemble}
                     if IsElMusicaux_MemeNotes(ElMusicaux[i-1], ElMusicaux[i]) and
                        ElMusicaux[i-1].QueDesLieesAlaSuivante and
                        IsDureeAffichable(duree_somme) then
                     Begin
                        DelElMusical(i-1);
                        dec(i);
                        ElMusicaux[i].Duree_Set(duree_somme);

                     End;



                 End;

                 inc(i);
             End;
       End;

    if QueDesPauses then
        SupprimerTousLesElMusicaux;

End;




Function TVoix.Is_Compatible_A_L_Insertion(t1, duree: TRationnel): boolean;

                  
    Function Is_IntersectionDe2Segments_Non_Vide(A1, A2, B1, B2: TRationnel): Boolean;
    Begin
          result := not (IsQ1StrInfQ2(A2, B1) or IsQ1StrInfQ2(B2, A1));
    End;


var t, t2, tfin: TRationnel;
    i: integer;


Begin
     {une voix est en gros une union d'intervalles dit "remplis" :
      ce sont les intervalles de temps où il y a effectivement des notes jouées...

      il faut regarder si cette union intersecte [t1, t1 + duree]}


    t := Qel(0);
    t2 := QAdd(t1, duree);

    For i := 0 to high(ElMusicaux) do
    Begin
            tfin := QAdd(t, ElMusicaux[i].Duree_Get);

            if IsQEgal(t, t1) and IsQEgal(tfin, t2) then
            Begin
                  result := true;
                  Exit;
            End;



            if Is_IntersectionDe2Segments_Non_Vide(t, tfin,
                                                   t1, t2) then
            Begin
                  result := true;
                  Exit;
            End;

            t := tfin;
    end;

    result := false;

End;







procedure TVoix.Inserer_ElMusical_AuTemps_A_La_Fin(temps: TRationnel; el: TElMusical);
Begin
   //  AddElMusicalFin(CreerElMusicalPause_Duree_Approximative(temps, PorteeApprox));
   //  AddElMusicalFin(CopieElMusical(el));
     Essayer_D_Inserer_ElMusical_AuTemps_A_La_Fin(temps, el, false);
End;


Function TVoix.Inserer_ElMusical_AuTemps_A_La_Fin_Get_Score(temps: TRationnel; el: TElMusical): integer;
Begin
     result := Essayer_D_Inserer_ElMusical_AuTemps_A_La_Fin(temps, el, true);
End;


Function TVoix.Essayer_D_Inserer_ElMusical_AuTemps_A_La_Fin(temps: TRationnel; el: TElMusical; test_seulement: boolean): integer;
var duree_totale, dt, t_el_dernier: TRationnel;
    el_dernier: TElmusical;

   procedure Inserer_Silence_Duree_Approximative_Fin(silence_duree: TRationnel);
    var duree_extraite: TRationnel;

   Begin
         {  //Essayer d'allonger l'él. mus. d'avant
           if length(ElMusicaux) > 0 then
                 With ElMusicaux[high(ElMusicaux)] do
                 Begin
                     if not IsQNul(Duree_Get) then
                     if (QToReal(silence_duree)) / QToReal(Duree_Get) < 2 then
                     //si le silence dure peu par rapport à la note précédente, on mixe les deux
                     Begin
                           DureeApproximative_Set(QAdd(Duree_Get, silence_duree));
                           exit;
                     End;

                 End;   }

           AddElMusicalFin( CreerElMusicalPause_Duree_Approximative(silence_duree, el.PorteeApprox) );

   End;



   Function IsIntervallesAssezBienSupperposes(a, b, c, d: TRationnel): boolean;
         Function IsIntervallesAssezBienSupperposesR(a, b, c, d: real): Boolean;

                procedure Switch(var v, w: real);
                var t: real;
                Begin
                   t := v;
                   v := w;
                   w := t;
                End;

                
         Begin
                b := a + b;
                d := c + d;

                if c <= a then
                Begin
                     Switch(a, c);
                     Switch(b, d);
                End;

                {ON A par hypothèse a <= c}

                if a = b then
                     result := false //un des intervalles est vide
                else

                if b <= c then
                     result := false // intervalles disjoints
                else
                if d <= b then {[c, d] inclus dans [a, b]}
                     result := (d-c) / (b - a) > 0.8
                else {à cheval}
                     result := (b-c) / (d-a) > 0.8;

                if result then
                       result := result;

         End;


   Begin
       result := IsIntervallesAssezBienSupperposesR(QToReal(a), QToReal(b), QToReal(c), QToreal(d));
   End;




   
Begin
    {temps = le temps où on a envie d'insérer l'élément musical el
     testseulement = true ssi on ne fait juste évaluer l'insertion mais on ne l'a fait pas }

    duree_totale := DureeTotale;
    if IsQ1StrInfQ2(temps, DureeTotale) then
    Begin
          //ici, il y a forcément un él.musical dans la voix

          el_dernier := ElMusicaux[high(ElMusicaux)];


          t_el_dernier := QDiff(duree_totale, el_Dernier.Duree_Get);

          if IsIntervallesAssezBienSupperposes(temps, el.Duree_Get,
                                           t_el_dernier, el_Dernier.Duree_Get) then
          Begin
                  if not test_seulement then
                        el_dernier.AddNotesAutreElMusical(el);

                  if el_dernier.IsSilence then
                         result := 0
                  else
                        result := -abs(ElMusical_Dist_AlgebriqueAvecHauteurNote(el_dernier, el));
          End
          else
                   result := -1000;
    End
    else
    Begin


         if not test_seulement then
         Begin
               dt := QDiff(temps, DureeTotale);
               Inserer_Silence_Duree_Approximative_Fin(dt);
               AddElMusicalFin(CopieElMusical(el));
         End;


         if IsVide then
            result := 0
         else
         Begin
               el_dernier := ElMusicaux[high(ElMusicaux)];
               if el_dernier.IsSilence then
                    result := 0
               else
                    result := -abs(ElMusical_Dist_AlgebriqueAvecHauteurNote(el_dernier, el));


         End;


    End;





End;






Procedure TVoix.RegleMesure_DeplacerTic(temps1, temps2: TRationnel);
var temps_debut: TRationnel;

Begin
    temps2 := QDiff(temps2, Qel(1));
    RegleMesure_Etirer(QDiff(temps2, Qel(1)) {temps_debut}, temps1, temps2);
End;

Procedure TVoix.RegleMesure_Etirer(temps_debut, temps1, temps2: TRationnel);
{l'élément sur le temps temps1 est déplacé et rammené au temps2}

var rapport: TRationnel;
    t_i_debut_avant_traitement, t_i_fin_avant_traitement: TRationnel;
    t_i_debut_apres_traitement, t_i_fin_apres_traitement: TRationnel;
    i: integer;


    i1, i2: integer;
    temps_i1: TRationnel; duree_i1i2: integer;
    el_i_duree_avant_traitement: TRationnel;









    procedure ElMusical_i_ModifierDuree(q_calcule: TRationnel);
    Begin
         if ElMusicaux[i].Duree_IsApproximative then
              ElMusicaux[i].DureeApproximative_Set(
                          QPasTropGrandDenominateur(q_calcule)
                                             );

    End;

Begin
      {but : le temps1 est désormais le temps2}


      if IsQStrNegatif(temps_debut) then
         temps_debut := QZero;


      if IsQEgal(temps1, temps_debut) then
      Begin
           AddElMusical(IndiceSurTemps(temps1)+1, CreerElMusicalPause(QDiff(temps2, temps1),
                                                                    PorteeApprox));
          exit;
      end;

      //(temps2 - temps_debut) / temps1 - temps_debut)
      rapport := QDiv( QDiff(temps2, temps_debut),
                       QDiff(temps1, temps_debut)
                      );

      t_i_debut_avant_traitement := Qel(0); //sert à rien
      t_i_fin_avant_traitement := Qel(0);
      t_i_debut_apres_traitement := Qel(0); //sert à rien
      t_i_fin_apres_traitement := Qel(0);

      for i := 0 to high(ElMusicaux) do
      Begin

             t_i_debut_avant_traitement := t_i_fin_avant_traitement;

             el_i_duree_avant_traitement := ElMusicaux[i].Duree_Get;
             t_i_fin_avant_traitement := QAdd(t_i_debut_avant_traitement,
                                              el_i_duree_avant_traitement);

             t_i_debut_apres_traitement := t_i_fin_apres_traitement;


             if IsQ1InfQ2(temps1, t_i_debut_avant_traitement) then break;


             if IsQ1InfQ2(t_i_debut_avant_traitement, temps_debut) then
             Begin
                  i1 := i;
                  temps_i1 := t_i_debut_avant_traitement;
             End;

             {à la fin, i1 = le premier élément modifié}



             if IsQ1StrInfQ2(t_i_debut_avant_traitement, temps_debut)
                and IsQ1StrInfQ2(temps_debut, t_i_fin_avant_traitement)
                and IsQ1InfQ2(t_i_fin_avant_traitement, temps1) then
              {l'élément courant est à cheval sur l'intervalle [temps_debut, temps1]

                          [temps_debut,          temps1]
                 [t_i_debut         t_i_fin]
              }    ElMusical_i_ModifierDuree(QAdd(QDiff(temps_debut, t_i_debut_avant_traitement),
                                             QMul(QDiff(t_i_fin_avant_traitement, temps_debut),
                                                  rapport)
                                                 ))


             else
             if IsQ1InfQ2(temps_debut, t_i_debut_avant_traitement) and
                IsQ1InfQ2(t_i_fin_avant_traitement, temps1) then
             Begin
                  {si l'él. mus. se trouve dans [temps_debut, temps1]}
                  {
                             [temps_debut,                   temps1]
                              [t_i_debut         t_i_fin]
                  }

                   ElMusical_i_ModifierDuree(
                                                 QMul(el_i_duree_avant_traitement, rapport)
                                                 );

             End
             else
             if IsQ1InfQ2(temps_debut, t_i_debut_avant_traitement) and
                IsQ1StrInfQ2(temps1, t_i_fin_avant_traitement) then
             Begin
                  {
                                      [temps_debut,   temps1]
                                               [t_i_debut      t_i_fin]
                  }


                    ElMusical_i_ModifierDuree( QAdd(
                                                 QMul(QDiff(temps1, t_i_debut_avant_traitement), rapport),
                                                 QDiff(t_i_fin_avant_traitement, temps1)
                                                   )
                                               );


             End
             else
             if IsQ1StrInfQ2(t_i_debut_avant_traitement, temps_debut) and
                IsQ1StrInfQ2(temps1, t_i_fin_avant_traitement) then
             Begin
                  {
                             [temps_debut,       temps1]
                      [t_i_debut                           t_i_fin]
                  }

                  ElMusical_i_ModifierDuree(
                      QAdd( QDiff(temps_debut, t_i_debut_avant_traitement),
                            QAdd( QMul(QDiff(temps1, temps_debut), rapport),
                                  QDiff(t_i_fin_avant_traitement, temps1)
                                  )
                            )
                            );

             End;


             t_i_fin_apres_traitement := QAdd(t_i_debut_apres_traitement,
                                              ElMusicaux[i].Duree_Get);

      End;

      i2 := i-1;








End;




procedure TVoix.Durees_Inferences_Inferer(t1, t2: TRationnel);
var i1, i2: integer;

    Function PremierIndiceDanst1t2: integer;
    var i: integer;
        t: TRationnel;

    Begin
         t := QEl(0);

         for i := 0 to high(ElMusicaux) do
         Begin
              if IsQ1InfQ2(t1, t) then
                  break;

              t := QAdd(t, ElMusicaux[i].Duree_Get);
         End;
         result := i;
    End;


    Function DernierIndiceDanst1t2: integer;
    var i: integer;
        t: TRationnel;

    Begin
         t := QEl(0);

         for i := 0 to high(ElMusicaux) do
         Begin
              t := QAdd(t, ElMusicaux[i].Duree_Get);

              if IsQ1InfQ2(t2, t) then
                  break;
         End;
         result := i-1;
    End;

    var i: integer;
        r: array of TRationnel;
        tout_fixee: boolean;
    
Begin
    i1 := PremierIndiceDanst1t2;
    i2 := DernierIndiceDanst1t2;

    for i1 := i1 to i2 do
        if ElMusicaux[i1].Duree_IsApproximative then break;


    if i2 < i1 then exit;


   Setlength(r, i2 - i1 + 1);

   tout_fixee := true;
   for i := i1 to i2 do
         if ElMusicaux[i].Duree_IsApproximative then
         Begin
                r[i-i1] := QTrouverFractionSimpleProche(ElMusicaux[i].Duree_Get)[1].q;
                tout_fixee := false;

         End else r[i-i1] := ElMusicaux[i].Duree_Get;

   if not tout_fixee then
       Interface_Questions_RegleMesure_AjouterQuestion(Interface_Questions_RegleMesure_iMesure_Get,
                                                                N_Voix,
                                                                i1,i2,r);
    
End;



Procedure TVoix.Inserer_CopieElMusical_AuTemps(temps: TRationnel; el: TElMusical);
{utilisé pour le déplaçage de notes dans une voix}

var travailler_avec_durees_approximatives: Boolean;


    procedure Inserer_Silences(i: integer; silences_duree: TRationnel);


         Function GetDureeAExtraire(duree: TRationnel): TRationnel;
         var resultat : TRationnel;


             Function test(d: TRationnel): boolean;
             Begin
                  result := IsQ1InfQ2(d, duree);
                  resultat := d;

             End;



         var i, p: integer;

         label fin;

         Begin



              if test(Qel(4, 1)) then goto fin;

              p := 1;
              for i := 1 to 4 do
              Begin
                  if test(Qel(3, p)) then goto fin;
                  if test(Qel(2, p)) then goto fin;
                  p := 2*p;
              End;

              resultat := duree;

              fin: result := resultat;
         End;


    var duree_extraite: TRationnel;

   Begin
           if el.Duree_IsApproximative then
                AddElMusical(i, CreerElMusicalPause_Duree_Approximative(silences_duree, el.PorteeApprox))
           else
           while IsQ1StrInfQ2(Qel(0), silences_duree) do
           Begin
                duree_extraite := GetDureeAExtraire(silences_duree);
                silences_duree := QDiff(silences_duree, duree_extraite);
                AddElMusical(i,  CreerElMusicalPause(duree_extraite, el.PorteeApprox)  );
           End;  
   End;



var i: integer;
    duree_jusqu_au_indice_i_moins_un, duree_jusqu_au_indice_i, dti: TRationnel;
    el_insere: TElMusical;



Begin

    duree_jusqu_au_indice_i_moins_un := Qel(0);
    duree_jusqu_au_indice_i := Qel(0);


    for i := 0 to high(ElMusicaux) do
    Begin
          if IsQ1InfQ2(temps, duree_jusqu_au_indice_i) then   {(*)}
               break;

          duree_jusqu_au_indice_i_moins_un := duree_jusqu_au_indice_i;
          QInc(duree_jusqu_au_indice_i, ElMusicaux[i].Duree_Get);
    End;


    if IsQ1StrInfQ2(duree_jusqu_au_indice_i, temps) then
    {cas dégénéré où la voix actuelle est trop petite :
       {la boucle n'a pas été quitté par (*)}
    Begin
         Inserer_Silences(length(ElMusicaux), QDiff(temps, duree_jusqu_au_indice_i));
         AddElMusicalFin(CopieElMusical(el));
    End
    else
    {ATTENTION : dans la suite, la boucle n'a pas forcément été quitté par (*) !
     Mais j'ai préféré traiter les cas où i valide et invalide en ^m temps
      car c'est similaire}

    if IsQEgal(temps, duree_jusqu_au_indice_i) then
    Begin
    {l'élément i se trouve au temps temps}

         if i > high(ElMusicaux) then
               AddElMusicalFin( CopieElMusical(el) )
         else
               ElMusicaux[i].AddNotesAutreElMusical(el);


    End
    else
    Begin
    {l'élément d'indice i-1 est avant le temps temps et
     l'élément d'indice i s'il existe (ie si i <= high(ElMusicaux))
       s'y trouve après strictement.

       Le cas dégénéré i = length(ElMusicaux) ne pose pas de problème.}

         travailler_avec_durees_approximatives := ElMusicaux[i - 1].Duree_IsApproximative or el.Duree_IsApproximative;
                
         ElMusicaux[i-1].Duree_Set(QDiff(temps, duree_jusqu_au_indice_i_moins_un));
         {rem : forcément on diminue la durée de ElMusicaux[i-1]}

         if travailler_avec_durees_approximatives then
               ElMusicaux[i-1].Duree_Approximative_SwitchTo;


         el_insere := CopieElMusical(el);
         dti := QDiff(duree_jusqu_au_indice_i, temps);

         if i < length(ElMusicaux) then
         if IsQ1InfQ2(dti, el_insere.Duree_Get) then
                el_insere.Duree_Set(dti);

         if travailler_avec_durees_approximatives then
             el_insere.Duree_Approximative_SwitchTo;

         if IsQ1StrInfQ2(el_insere.Duree_Get, dti) then
               Inserer_Silences(i, QDiff(dti, el_insere.Duree_Get));

         AddElMusical(i, el_insere);


     End;

End;




procedure TVoix.ElMusicaux_Queues_Calculer;
var v, j:integer;
    jdeb, jfin, ydeb, xdeb, cury, maxy, p: integer;

    yab: boolean;

    monotonie, paquet: integer;
    pente: real;

const    factpente = 50;


Begin
     for j := 0 to high(ElMusicaux) do
                 if not ElMusicaux[j].IsSilence then
                   With ElMusicaux[j] do
                   Begin
                        if not IsSilence then
                               Begin
                                      p := PorteeApprox;
                                      if QueueVersBas then
                                      Begin
                                              YExtremiteQueue := GetY(IGiLigne, PosNoteBas);
                                              inc(YExtremiteQueue, hauteurdefautqueue*ZoomPortee(p) div ZoomMaxPrec);
                                      End
                                      Else
                                      Begin
                                              YExtremiteQueue := GetY(IGiLigne, PosNoteHaut);
                                              dec(YExtremiteQueue, hauteurdefautqueue*ZoomPortee(p) div ZoomMaxPrec);
                                      End;



                               End;



                   End;






     j := 0;
          while j <= high(ElMusicaux) do
          Begin


              {s'arrange pour que le premier élément "jdeb" soit une grappe de note
                    et non une pause !!!}
              jdeb := j;
              for j := jdeb to high(ElMusicaux) do
                    if not ElMusicaux[j].IsSilence then
                          Break;
              jdeb := j;

              //s'il ne reste que des pauses jusqu'à la fin, autant sortir
              if jdeb > high(ElMusicaux) then
                   break;

              jfin := -1;
              for j := jdeb+1 to high(ElMusicaux) do
                    if ElMusicaux[j].NvGroupe then
                    Begin
                          jfin := j - 1;
                          Break;
                    End;


              if jfin = -1 then
                  {si jfin = -1 jusqu'ici, c'est qu'aucun élément marqué "nouveau groupe"
                  n'a été trouvé}
                  jfin := high(ElMusicaux);






              {on traite un groupe de notes de jdeb à jfin inclus}


              {on peut regarder si monotone ou pas pour avoir la pente}

              monotonie := 0;

              for paquet := 1 to 2 do
              Begin
                   if jfin-paquet-jdeb < 0 then
                        yab := false
                   else
                   Begin
                         yab := true; //par défaut c croissant
                                 for j := jdeb to jfin-paquet do
                                        if GetY(ElMusicaux[j].PosNoteHaut) > GetY(ElMusicaux[j+paquet].PosNoteHaut) then
                                                 yab := false;
                   End;
                   if yab then
                         break;

              End;

              if yab then
                    monotonie := 1;

              if not yab then
              Begin
                    for paquet := 1 to 2 do
                    Begin
                         yab := true; //par défaut c croissant
                                 for j := jdeb to jfin-paquet do
                                        if GetY(ElMusicaux[j].PosNoteHaut) < GetY(ElMusicaux[j+paquet].PosNoteHaut) then
                                                 yab := false;
                         if yab then
                               break;

                    End;

                    if yab then
                        monotonie := -1;

              End;

              if (jfin = jdeb) or (ElMusicaux[jfin].pixx
                                               - ElMusicaux[jdeb].pixx = 0) then
                    pente := 0
              else
                    pente := monotonie * factpente / (ElMusicaux[jfin].pixx
                                               - ElMusicaux[jdeb].pixx);



              xdeb := ElMusicaux[jdeb].GetXQueue;

              p := ElMusicaux[jdeb].PorteeApprox;

              {ensuite, on calcule le ydeb de départ pour l'ajuster}
              if ElMusicaux[jdeb].QueueVersBas then
              Begin
                      ydeb := GetY(ElMusicaux[jdeb].PosNoteBas);
                      inc(ydeb, hauteurdefautqueue*ZoomPortee(p) div ZoomMaxPrec);
              End
              Else
              Begin
                      ydeb := GetY(ElMusicaux[jdeb].PosNoteHaut);
                      dec(ydeb, hauteurdefautqueue*ZoomPortee(p) div ZoomMaxPrec);
              End;


              maxy := 0;
              for j := jdeb to jfin do
              Begin
                      {y avec le ydeb au pif actuel - le y minimum possible}
                      cury := ydeb + Round(pente * (ElMusicaux[j].GetXQueue - xdeb));

                      p := ElMusicaux[j].PorteeApprox;

                      if ElMusicaux[jdeb].QueueVersBas then
                            cury := cury
                              - (GetY(ElMusicaux[j].PosNoteBas) + hauteurdefautqueue*ZoomPortee(p) div (ZoomMaxPrec))
                      else
                            cury := cury
                              - (GetY(ElMusicaux[j].PosNoteHaut) - hauteurdefautqueue*ZoomPortee(p) div (ZoomMaxPrec));


                      if ElMusicaux[jdeb].QueueVersBas then
                      Begin
                               if maxy > cury then maxy := cury;
                      end
                      else
                               if maxy < cury then maxy := cury;


              End;

              ydeb := ydeb - maxy;



              {desdes}
              for j := jdeb to jfin do
              Begin
                      ElMusicaux[j].YExtremiteQueue := ydeb +
                                Round(pente * (ElMusicaux[j].GetXQueue - xdeb));

              End;


          End;



End;



Function TVoix.DernierElementMusical_Get: TElMusical;
Begin
    if high(ElMusicaux) = -1 then
    Begin
         MessageErreur('pas d''élément dans la voix : erreur dans DernierElementMusical_Get');
         result := nil;
    end
    else
         result := ElMusicaux[high(ElMusicaux)];
End;



Function TVoix.IsVoixBrouillon: Boolean;
Begin
    result := (N_Voix < 0);
End;

end.
