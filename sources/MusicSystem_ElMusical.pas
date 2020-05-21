unit MusicSystem_ElMusical;

interface


uses QSystem {pour pouvoir parler d'une durée d'un él. musical},
     MusicHarmonie {pour TAlteration},
     Types {pour TRect},
     MusicSystem_Types,
     MusicSystem_Constantes {pour naLieALaSuivante},
     MusicSystem_ElMusical_Duree,
     MusicSystem_ElMusical_Liste_Notes;







      
type















{un élément musical, c'est une pause, une note ou un accord}
TElMusical = class(TElMusical_Liste_Notes)
private
      Selectionne: TSelectionValeur;


public
    //données calculées à l'affichage
      pixx,
      pixWidth: integer;
      pixWidthdroite,
      trainee_duree_pixxdroite: integer;

    //pas stocké dans le .mus, pour l'animation des mesures
     lastpixx: integer;

    DureeEtalon: TRationnel;
    //utilisé uniquement pour les rythmes...n'est pas enregistré dans le fichier

    NumVoix: integer;

    NvGroupe: Boolean; {-->pour les reliage des croches et tout et tout
                           vaut true pour le début d'élément d'un nouveau groupe}

    elementmusical_precedent: TElMusical;
    YExtremiteQueue: integer;
    {se calcule dans CalcStandardQueueHaut}



    volume: integer;

    attributs: TAttributsElMusical;

    Paroles_Syllabe: string;

    constructor Create;



    {sélection ********************************************}
    
    procedure SelectionnerNote(n: integer);
    procedure SelectionnerElMusical;


    Function Selection_Valider: Boolean;
    procedure DeSelectionnerElMusicalSiSelectionNonValidee;
    procedure DeSelectionnerNoteSiSelectionNonValidee(n: integer);

    Function IsNoteSelectionnee(n : integer): boolean;
    Function IsNoteSelectionneePasForcementValide(n : integer): Boolean;

    Function IsSelectionne: Boolean;
    {renvoie vrai ssi l'él. mus. est sélectionnée, ou si, tout au moins,
     il contient une note qui l'est}

    Function  IsSelectionnePasForcementValide: Boolean;
    {itou mais on est pas obligé d'avoir validé}

    Function NbNotesSelectionnees: integer;

    procedure Notes_Selectionnees_Supprimer;




    procedure SetNoteLieALaSuivanteOuPas(n : integer);
    Function IsNoteLieeALaSuivante(n: integer): Boolean;
    Function HauteurNoteIsPresentEtLieeALaSuivante(hn: THauteurNote): Boolean;

    Function TailleNote: integer;
    {renvoie 0 pour grande note (note normale en fait)
             1 pour petite note (cadences, apogiatures...etc...)}

    Function IsSurPortee(portee: integer): Boolean;
    {renvoie vrai ssi l'él. mus. se trouve sur la portée portee, ou contient
     une note qui s'y trouve}



    Function pixRect: TRect;
    {renvoie grosso modo un rectangle qui entoure l'él. mus.
     ce dernier est exprimé dans le repère de la mesure}





    Function pixyhaut: integer;
    {renvoie dans le repère de la mesure (ou de la ligne), l'ordonnée
     du point le plus haut de l'élément musical
         cette fonction sert :
                  - au dessin des polygones des voix
                  - pour dessiner le point d'une note ou accord piqué}
                  
    Function pixybas: integer;
    {itou en bas}

    {lecture et écrire d'attribut}
    Function GetAttrib(attrib: integer): Boolean;
    Procedure SetAttrib(attrib: integer; val: Boolean);

    Procedure Deselectionner;
    {déselectionne l'élément musical}


    Function pixWidthgauche: integer;
    {calcule le nombre de pixel logique entre la partie la plus à gauche de
     l'él. mus. et la droite d'abscisse 0.
       cet espacement grandit si il y a des altérations par exemple}

    Function pixxdevantboule: integer;

    Procedure Save;
    {lit ou enregistre l'él. mus. dans un fichier}


    Function Alterer(pos: TPosition; alteration: TAlteration): Boolean;
    {tente d'altérer une note présente à la position pos
       renvoie vrai ssi il y avait effectivement une note}



    Function GetXQueue: integer;
    {renvoie dans le repère de l'él. musical, l'abscisse de la hampe}

    


    


    Function PorteeApprox: integer;
    {indique à peu près dans quel portée se trouve l'él. mus.
    si l'él. mus. contient deux notes dans des portées différentes... le résultat
     n'est pas trop spécifié}


    Procedure Renversement(rel: integer);
    {renverse l'accord. Le signe de rel indique le sens du renversement
    ex : si l'él. mus. est un accord do-mi-sol
          - l'appel avec rel > 0 le transforme en mi-sol-do1
          - l'appel avec rel < 0 le transforme en sol(-1)-do-mi}

    
    Procedure CalcStandardQueueHaut;
    {calcul un affichage correct pour une hampe vers le haut}

    Destructor Destroy; override;

    Function ExtrairePartieSelectionnee: TElmusical;
    {renvoie un nouvel él. mus. qui ne contient que les notes sélectionnées
     ex : si l'él. mus est un accord de do majeur ou seulle sol est sélectionnée
             cette méthode renvoie un él. mus. qui est un sol seul}

    Procedure Ecouter;
    {offre un aperçu sonore de l'él. mus.}

    procedure VerifierIntegrite(info: string);
    {teste si l'él. musical est "correct"}

    Function GetXBoules(i: integer): integer;
    {renvoie l'abscisse, dans le repère courant de l'élément musical, du centre
     de la boule de la note n° i}

     procedure ToutLierALaSuivante;
     Function QueDesLieesAlaSuivante: Boolean;


     procedure InitSouhaitQueueVersBas;
     procedure SouhaiterQueueVersBas(souhaitqueueverslebas: boolean);
     Function GetSouhaitQueueVersBas: integer;

     Function Y_Haut_InRepMesure: integer;

     Procedure Paroles_Syllabe_Set(syl: string);

private
    souhait_queue_vers_lebas: integer;

    

    {calcule la valeur de la propriété BoulesCotes}



end;



Function GetDureeGrpNote(Rythme: TRationnel): TRationnel;


Function HauteurNoteGraphiqueToAbs(infoclef: TInfoClef; N: TNote) :THauteurNote;

Function ElMusicalToStr(el: TElMusical; precnote: boolean): string;
Function ElMusicalEtSelectionToStr(el: TElMusical): string;

procedure EnharmoniquerNote(var n: TNote);

Function CreerElMusical1Note(Duree: TRationnel; Note: TNote): TElMusical;
Function CreerElMusical1Note_DureeApproximative(Duree: TRationnel; Note: TNote): TElMusical;

Function CreerElMusicalPause(Duree: TRationnel; portee: integer): TElMusical;
Function CreerElMusicalPause_Duree_Approximative(Duree: TRationnel; portee: integer): TElMusical;


Function CopieElMusicalSaufNote(el: TElMusical): TElMusical;
Function CopieElMusical(el: TElMusical): TElMusical;
Function CopieElMusicalEnDeselectionnant(const el: TElMusical): TElMusical;
Function CreerElMusicalChroma(elmodele: TElMusical; nbdemitondiff: integer;
                              Duree: TRationnel;
                              portee: integer): TElMusical;

Function CreerNote(iportee: integer): TNote; overload;
Function CreerNote(h, p: integer; a: TAlteration): TNote; overload;
Function ElMusicauxCanBeDrawnOnSameX(const el1, el2: TElMusical): boolean;

Function ElMusical_Dist_Algebrique(const e1, e2: TElMusical): integer;
Function ElMusical_Dist_AlgebriqueAvecHauteurNote(const e1, e2: TElMusical): integer;


Function IsElMusicaux_MemeNotes(const e1, e2: TElMusical): Boolean;







procedure VerifierElMusical(el: TElMusical; mess: string);










implementation

uses MusicWriter_Erreur {pour MessageErreur},
     SysUtils {pour inttostr},
     FileSystem {pour SetPr},
     MusicGraph_Portees,
     MusicGraph_Images {dans pixWidthgauche, on a besoin des images...},
     MusicGraph_System {pour prec},
     MusicGraph_CercleNote {pour rayonnotes},
     MusicGraph,
     MidiNow, MusicWriterToMIDI {pour pouvoir écouter un el. musical} ,
     Main {ça c'ets aussi pour pouvoir écouter... à cause d'un timer} ,
     MusicUser{pour UtiliserMidiNow},
     tablature_system
     ;










Function GetDureeGrpNote(Rythme: TRationnel): TRationnel;
{De manière générales, on relies les croches successives qui appartiennent à
 un même temps. Dans un 2/4, 3/4 etc, ce temps est de 1. Dans un 6/8, il est de 3/2.
 Cette fonction retourne le "temps d'un temps" dans une mesure de Rythme Rythme.}
Begin
    if IsQEgal(Rythme, QelReally(3,8)) then
        result := Qel(3,2)
    else if IsQEgal(Rythme, QelReally(6,8)) then
        result := Qel(3,2)
    else if IsQEgal(Rythme, QelReally(9,8)) then
        result := Qel(3,2)
    else if IsQEgal(Rythme, QelReally(12,8)) then
        result := Qel(3,2)
    else
        result := QUn;

End;


Function HauteurNoteGraphiqueToAbs(infoclef: TInfoClef; N: TNote) :THauteurNote;
var hn: THauteurNote;
Begin
hn.Hauteur := HauteurGraphiqueToHauteurAbs(infoclef, N.position.hauteur);
hn.Alteration := N.hauteurNote.alteration;

result := hn;

End;


//TElMusical
//******************************************************************************


constructor TElMusical.Create;
Begin
    DureeApproximative_Set(Qel(1));
    
End;









procedure TElMusical.SetNoteLieALaSuivanteOuPas(n : integer);
Begin
     VerifierIndiceNote(n);
     SetPr(Notes[n].BouleADroite, naLieALaSuivante, false);
End;


procedure TElMusical.SelectionnerNote(n: integer);
Begin
    VerifierIndiceNote(n);
    Notes[n].Selectionne := svFraichementSelectionnee;

End;


Function TElMusical.IsNoteSelectionnee(n : integer): Boolean;
Begin
    VerifierIndiceNote(n);
    result := Notes[n].Selectionne = svSelectionnee;
End;

Function TElMusical.IsNoteSelectionneePasForcementValide(n : integer): Boolean;
Begin
   VerifierIndiceNote(n);
    result := Notes[n].Selectionne <> svDeSelectionnee;
End;




Procedure TElMusical.Deselectionner;
var i:integer;
Begin
      if IsSilence then
             Selectionne := svDeSelectionnee
      else
            for i := 0 to high(Notes) do
                    Notes[i].Selectionne := svDeSelectionnee;

End;


Function TElMusical.IsSelectionne: Boolean;
{renvoit vrai ssi
   - la pause est sélectionnée
   - le groupe de notes contient au moins une note sélectionnée}
var n: Integer;
Begin
    if IsSilence then
        result := (Selectionne = svSelectionnee)
    else
    Begin
        for n := 0 to high(Notes) do
        Begin
            if Notes[n].Selectionne = svSelectionnee then
            Begin
                result := true;
                exit;
            End;


        End;

        result := false;
    end;

End;



Function TElMusical.IsSelectionnePasForcementValide: Boolean;
{renvoit vrai ssi
   - la pause est sélectionnée
   - le groupe de notes contient au moins une note sélectionnée
   (mais que la sélection n'a pas forcément été validé...
    cette fonction est utile pour l'affichage)}
var n: Integer;
Begin
    if IsSilence then
        result := (Selectionne <> svDeSelectionnee)
    else
    Begin
        for n := 0 to high(Notes) do
        Begin
            if Notes[n].Selectionne <> svDeSelectionnee then
            Begin
                result := true;
                exit;
            End;


        End;

        result := false;
    end;

End;


Function TElMusical.NbNotesSelectionnees: integer;
var n: Integer;
Begin
    result := 0; 
    if IsSilence then
        result := 0
    else
    Begin
        for n := 0 to high(Notes) do
        Begin
            if Notes[n].Selectionne = svSelectionnee then
                inc(result);

        End;

    end;

End;



procedure TElMusical.Notes_Selectionnees_Supprimer;
var n: integer;
Begin
   n := 0;
   While n <= High(Notes) do
         if Notes[n].Selectionne = svSelectionnee then
             DelNote2(n)
         else
             inc(n);

End;




procedure TElMusical.SelectionnerElMusical;
var n: integer;
Begin
     Selectionne := svFraichementSelectionnee;

     for n := 0 to high(Notes) do
           Notes[n].Selectionne := svFraichementSelectionnee;
End;



Function TElMusical.Selection_Valider: Boolean;
{renvoie vrai si yavè qch de sélectionnée un peu dedans}
var j: integer;
Begin
    result := false;

    if IsSilence then
    Begin
          if Selectionne <> svDeSelectionnee then
          Begin
                Selectionne := svSelectionnee;
                result := true;
          End;
    End
    Else
        for j := 0 to high(Notes) do
            if Notes[j].Selectionne <> svDeSelectionnee then
            Begin
                   result := true;
                   Notes[j].Selectionne := svSelectionnee;
            End;

End;



procedure TElMusical.DeSelectionnerElMusicalSiSelectionNonValidee;
Begin
     if Selectionne = svFraichementSelectionnee then
           Selectionne := svDeSelectionnee;
End;


procedure TElMusical.DeSelectionnerNoteSiSelectionNonValidee(n: integer);
Begin
     VerifierIndiceNote(n);

     if Notes[n].Selectionne = svFraichementSelectionnee then
           Notes[n].Selectionne := svDeSelectionnee; 
End;







Function TElMusical.pixyhaut: integer;
Begin
if IsSilence then
        result := GetY(IGP, IGiLigne, Position) - 16
else
       result := GetY(IGP, IGiLigne, Notes[high(Notes)].Position);


End;





Function TElMusical.pixybas: integer;
Begin
if IsSilence then
        result := GetY(IGP, IGiLigne, Position) + 16
else
       result := GetY(IGP, IGiLigne, Notes[0].Position);


End;






Function TElMusical.pixWidthgauche: integer;
var i, max:integer;

Begin
      if IsSilence then
          result := 0
      else
      Begin
          max := 0;
          for i := 0 to high(Notes) do
                 if Notes[i].AfficherAlteration then
                 Begin
                     VerifierAlteration(Notes[i].hauteurnote.Alteration, 'pixWidthgauche');
                     max := imgAlteration[0,Notes[i].hauteurnote.Alteration].Width*prec;
                 End;

          result := max;

      End;

End;



Function TElMusical.pixxdevantboule: integer;
Begin
      case GetBoulesCotes of
             bcGauche: result := pixx;
             bcMixte: result := pixx - nbpixlign div 2;
             bcDroite: result := pixx;
             else
             Begin
                 MessageErreur('Problème dans pixxdevantboule');
                 result := pixx;
             End;
      end;
End;



Procedure TElMusical.Save;
var l, i:integer;
    rebus_byte: Byte;

Begin
      rebus_byte := 0;

      FichierDoInt(pixx);
      FichierDoInt(pixWidth);
      FichierDoInt(pixWidthdroite);
      FichierDo(Selectionne, SizeOf(TSelectionValeur));
      if EnLecture then
           Selectionne := svDeselectionnee;

      FichierDo(Duree, SizeOf(TRationnel));
      If EnLecture then
           Duree_Set(duree);

      if Duree.denom = 0 then
          Duree.denom := 1;

      FichierDoInt(PointDuree);

      FichierDo(NvGroupe, SizeOf(Boolean));

      FichierDo(position, SizeOf(TPosition));

      FichierDoInt(l, length(Notes));

      if EnLecture then
               Setlength(Notes, l);

      if not IsSilence then
      Begin
         FichierDoInt(YExtremiteQueue);
         FichierDo(QueueVersBas, SizeOf(Boolean));
         FichierDo(BoulesCotes, SizeOf(TBouleCote));


             
         FichierDo(private_is_duree_approximative, SizeOf(Boolean));

         if EnLecture and (VFF <= 3) then
             private_is_duree_approximative := false; //car sinon pb

         FichierDo(attributs, SizeOf(TAttributsElMusical));

         //FichierDo(Notes[0], SizeOf(TNote) * length(Notes));
         for i := 0 to high(Notes) do with Notes[i] do
         Begin
              FichierDo(position, Sizeof(TPosition));
              FichierDo(hauteurnote.alteration, SizeOf(TAlteration));

              VerifierAlteration(hauteurnote.alteration, ' erreur de lecture ou d''écriture (fichier corrompu ?)');

              FichierDo(AfficherAlteration, SizeOf(Boolean));
              FichierDoByte(BouleADroite);

              if not EnLecture then
                   FichierDoByte(doigtee, Tablature_System_CordeNum_Get(Notes[i]) )
              else
                   FichierDoByte(doigtee);
              {récupère les trucs de doigtées}

              if EnLecture then
                     Selectionne := svDeselectionnee;
      //        FichierDoByte(Selectionne);
         End;


      End;



End;









Function TElMusical.GetAttrib(attrib: integer): Boolean;
Begin
    result := (attributs.Style1 and (1 shl attrib)) <> 0;
End;




Procedure TElMusical.SetAttrib(attrib: integer; val: Boolean);
Begin
   if val then
         attributs.Style1 := attributs.Style1 or (1 shl attrib)
   else
         attributs.Style1 := attributs.Style1 and not (1 shl attrib);
End;















Function TElMusical.GetXQueue: integer;
var queueplus:integer;
    r: integer;

Begin

      r := rayonnotes[TailleNote] * ZoomPortee(PorteeApprox) div ZoomMaxPrec;

      case BoulesCotes of
                  bcMixte: queueplus := 0;
                  bcGauche: queueplus := r;
                  bcDroite: queueplus := -r;
                  else
                  Begin
                      MessageErreur('C''est bizarre dans GetXQueue');
                      queueplus := 0;
                  End;
      end;

      result := pixx + queueplus;
End;


Function TElMusical.GetXBoules(i: integer): integer;
var xrel:integer;
Begin
    case BoulesCotes of
                bcMixte:
                Begin
                    if GetPr(Notes[i].BouleADroite, naBouleADroite) then
                    {boule à droite}
                            xrel := rayonnotes[TailleNote]
                    else
                            xrel := -rayonnotes[TailleNote];


                End;
                bcGauche: xrel := 0;
                bcDroite: xrel := 0;
                else
                 Begin
                    MessageErreur('C''est bizarre dans GetXBoules');
                    xrel := 0;
                 End;
     end;

     result := pixx + xrel;
     
End;



Function TElMusical.TailleNote: integer;
{convertit l'attribut "NotePetite" en indice de taille de note

renvoit 0 pour grande note (note normale en fait)
        1 pour petite note (cadences, apogiatures...etc...)

}
Begin
   if attributs.PetitesNotes or IsQNul(Duree) then
        result := 1
   else
        result := 0;


End;


Function TElMusical.IsSurPortee(portee: integer): Boolean;
{renvoie vraie ssi l'élément musical a au moins une des notes sur la portée portee}
var b:Boolean;
    i:integer;
Begin

    if IsSilence then
          b := (portee = position.portee)
    else
    Begin
        b := false;
        for i := 0 to high(Notes) do
             if Notes[i].position.portee = portee then
                   Begin
                        b := true;
                        Break;
                   End;
    End;

    result := b;
End;





Function TElMusical.pixRect: TRect;
{renvoie un rectangle qui entoure l'élément musical
  (dans le repère de la mesure)}
var r: TRect;
    pausedessin: integer;
    zz: integer;
    taille: integer;
Begin
    if IsSilence then
    Begin
        if Duree_IsApproximative then
        Begin
              zz := ZoomPortee(position.portee);
              taille := zz*2*nbpixlign div ZoomMaxPrec;
               
              r.Left := pixx;
              r.Top := GetY(IGiLigne, Position);
              r.Right := r.Left + taille;
              r.Bottom := r.Top + taille;
        End
        else
        Begin

              r.Left := pixx;

              pausedessin := NumeroDessinPause(Duree);

              zz := ZoomPortee(position.portee);

              r.Top := GetY(IGiLigne, Position) - decalypause[pausedessin]*zz div ZoomMaxPrec;
              r.Right := r.Left + imgPauses[pausedessin].Width*zz div ZoomParDefaut;
              r.Bottom := r.Top + imgPauses[pausedessin].Height*zz div ZoomParDefaut;
        End;
    End
    else
    Begin
        r.Top := GetY(IGiLigne, Notes[high(Notes)].position) - nbpixlign;
        r.Bottom := GetY(IGiLigne, Notes[0].position) + nbpixlign;
        r.Left := pixx - 2*nbpixlign;
        r.Right := pixx + 2*nbpixlign;
    End;
    result := r;
End;



Function TElMusical.Alterer(pos: TPosition; alteration: TAlteration): Boolean;
var i: integer;

Begin
    for i := 0 to high(Notes) do
         if IsPositionsEgales(Notes[i].Position, pos) then
             Begin
                 Notes[i].hauteurnote.alteration := alteration;
                 result := true; 
                 Exit;
             End;

    result := false;

End;


Function TElMusical.PorteeApprox: integer;
{cette fonction permet par la suite,
        de détecter l'instrument qui joue cet élément musical}
Begin
  if IsSilence then
        result := position.portee
  else
        result := Notes[0].position.portee;

End;



Procedure TElMusical.Renversement(rel: integer);
Begin
if not IsSilence then
Begin
    if rel > 0 then
         inc(Notes[0].position.hauteur, 7)
    else
         dec(Notes[high(Notes)].position.hauteur, 7);

    ClasserBoules;
    
end;
End;


Procedure TElMusical.CalcStandardQueueHaut;
Begin
    if not IsSilence then
        YExtremiteQueue := GetY(IGiLigne, Notes[high(Notes)].position)
        - hauteurdefautqueue*ZoomPortee(Notes[high(Notes)].position.portee) div ZoomMaxPrec;

End;


Function TElMusical.ExtrairePartieSelectionnee: TElmusical;
{renvoit un elmusical tout frai qui ne contient que les notes sélectionnés, ou
 le cas échéant si c'est une pause, la copie de cette pause

 Si rien n'est sélectionné, renvoit nil (pratique avec TVoix.ElMusicalFin)} 
var newnotes: TElmusical;
    yab: Boolean;
    j: integer;

Begin
      if IsSilence and (Selectionne <> svDeselectionnee) then
            result := CopieElMusical(self)
      else if not IsSilence then
         Begin
              newnotes := CopieElMusicalSaufNote(self);

              yab := false;
              for j := 0 to high(Notes) do
              Begin
                     if Notes[j].Selectionne <> svDeselectionnee then
                           Begin
                               newnotes.AddNote(Notes[j]);
                               yab := true;
                           End;


               End;

               {yab = true... si newnotes contient au moins une note}
               if yab then
                        result := newnotes
               else
               Begin
                      newnotes.Free;
                      result := nil;
               End;

         End
      else result := nil;

End;


procedure TElMusical.Ecouter;
{offre un aperçu sonore de l'élément musical}
var i:integer;
Begin
    if UtiliserMidiNow then
    Begin
        MidiNow_ChangerInstrument(IGP.Portee_InstrumentMIDINum[PorteeApprox]);


        {on balance les notes à "MidiNow"}
        for i := 0 to High(Notes) do
             MidiNow_PlayNote(HauteurNoteToMIDINote(Notes[i].HauteurNote), 127);

        MainForm.tmrFinMidiNow.Enabled := true;

    End;
End;


Function TElMusical.Y_Haut_InRepMesure: integer;
Begin
    if IsSilence then
        result := GetY(position)
    else

        result := GetY(GetNoteHaut.position);
End;



Destructor TElMusical.Destroy;
Begin

   Finalize(Notes);
   inherited Destroy;

End;



procedure TElMusical.VerifierIntegrite(info: string);
var n: integer;
Begin
     if Duree.denom = 0 then
     Begin
           MessageErreur('Un élément musical a une durée dont le dénominateur est ... nul ! Je la mets à 1/1.' + info);
           Duree.denom := 1;
     End;

     for n := 0 to high(Notes) do
     Begin
        VerifierHauteurNote(Notes[n].HauteurNote, 'note n° ' + inttostr(n) + '. ' + info);
        if IGP <> nil then
            IGP.VerifierIndicePortee(position.portee, 'Verification d''intégrité du document');
     End;
End;



procedure TElMusical.ToutLierALaSuivante;
var n: integer;

Begin
    for n := 0 to high(Notes) do
       SetPr(Notes[n].BouleADroite,naLieALaSuivante, true);
End;


Function TElMusical.QueDesLieesAlaSuivante: Boolean;
var n: integer;

Begin
    result := true;
    
    for n := 0 to high(Notes) do
        if not GetPr(Notes[n].BouleADroite,naLieALaSuivante) then
        Begin
            result := false;
            Break;
        End;
        
End;




Function TElMusical.HauteurNoteIsPresentEtLieeALaSuivante(hn: THauteurNote): Boolean;
var n: integer;
Begin
    for n := 0 to high(Notes) do
           if IsHauteursNotesEgales(Notes[n].HauteurNote, hn) and IsNoteLieeALaSuivante(n) then
           Begin
               result := true;
               Exit;
           End;
    result := false;
End;

procedure TElMusical.InitSouhaitQueueVersBas;
Begin
    souhait_queue_vers_lebas := 0;
End;

procedure TElMusical.SouhaiterQueueVersBas(souhaitqueueverslebas: boolean);
Begin
   if souhaitqueueverslebas then
       inc(souhait_queue_vers_lebas)
   else
       dec(souhait_queue_vers_lebas);
End;


Function TElMusical.GetSouhaitQueueVersBas: integer;
Begin
   result := souhait_queue_vers_lebas;
End;


Function TElMusical.IsNoteLieeALaSuivante(n: integer): Boolean;
Begin
    result := GetPr(Notes[n].BouleADroite,naLieALaSuivante);
End;

Procedure TElMusical.Paroles_Syllabe_Set(syl: string);
Begin
    Paroles_Syllabe := syl;
End;


Function ElMusicalToStr(el: TElMusical; precnote: Boolean): string;
{renvoie un libellé (texte) qui décrit l'élément musical el

 si precnote, donne également des précisions sur la note que c'est, ou sur la
   tonalité d'un accord

 ex : un élément musical qui est un fa
                 si precnote = false, renvoie "une note seule"
                 si precnote = true, renvoie "un fa"

 ex : un élément musical qui est un accord de do majeur
                 si precnote = false, renvoie "un accord majeur"
                 si precnote = true, renvoie "un accord de do majeur"

}


var Tonique: THauteurNote;
    ints: array of TIntervalle;

        Function TesterAccord: Boolean;
        var i, j, k: integer;
            intc : TIntervalle;
            yabints: array of Boolean;
            flop : Boolean;
        Begin
          setlength(yabints, length(ints));
          with el do
          for i := 0 to high(Notes) do
          Begin
                   Tonique := Notes[i].HauteurNote;
                   {tester si on a affaire à un accord qui ne contient
                    que des notes qui font des intervalles (ramenés dans l'octave)
                    présents dans ints}

                   {rem : yabints[k] est vrai ssi on a trouvé une note tel qu'elle
                          fasse un intervalle ints[k] avec Tonique}
                   for k := 0 to high(yabints) do
                       yabints[k] := false;

                   flop := false;
                   for j := 0 to high(el.Notes) do
                   Begin
                         intc := Intervalle(Tonique, el.Notes[j].HauteurNote);
                         intc.Hauteur := IndiceNote(intc.Hauteur);

                         if not HauteursNotesEgales(intc, hn0) then
                         Begin
                             flop := true;
                             for k := 0 to high(ints) do
                                if HauteursNotesEgales(intc, ints[k]) then
                                 Begin
                                     flop := false;
                                     yabints[k] := true;
                                     break;
                                 End;
                                 if flop then break;
                         End;
                   End;

                   if not flop then
                   Begin
                        {si toutes les notes trouvés forment des intervalles valides,
                         teste encore si tous les intervalles sont bien présents
                         dans l'accord. flop joue ici une variable temporaire
                         pour savoir si tous les yabints[k] sont à vrai}
                        flop := true;
                        for k := 0 to high(ints) do
                             flop := flop and yabints[k];
                        if flop then
                        Begin
                             {si oui, c'est gagné : on a bien affaire à un accord
                              de ce type}
                             result := true;
                             Exit;
                        End;
                        {si non, on retente avec une autre tonique s'il en reste
                         et sinon, tant pis...}
                   End;


          End;


           result := false;
        End;  {fin testeraccord}

Begin
    with el do
    case length(notes) of
        0: {pause}
            result := 'un silence';
        1: {une note}
            if precnote then
                 result := 'un ' + HauteurNoteToStr(notes[0].HauteurNote)
            else result := 'une note seule';
        2: {un intervalle}
            result := IntervalleToStr(Intervalle(notes[0].HauteurNote,
                                                 notes[1].HauteurNote));
        else {un accord plus compliqué}
        Begin

       {teste si c un accord de septième de dominante}
            setlength(ints, 3);
            ints[0] := intTierceMajeure;
            ints[1] := intQuinte;
            ints[2] := intSeptiemeDiminue;
            if TesterAccord then
            Begin

                    result := 'un accord de septième de dominante';
                    if precnote then result := result + ' en '
                              + HauteurNoteToStr(Tonique);
                    Exit;
            End;


            setlength(ints, 2);
            ints[0] := intTierceMajeure;
            ints[1] := intSeptiemeDiminue;
            if TesterAccord then
            Begin
                    result := 'un accord de septième (avec tierce seulement) de dominante';
                    if precnote then result := result + ' en '
                              + HauteurNoteToStr(Tonique);
                    Exit;
            End;

            setlength(ints, 2);
            ints[0] := intQuinte;
            ints[1] := intSeptiemeDiminue;
            if TesterAccord then
            Begin
                    result := 'un accord de septième "à la quinte seulement" de dominante';
                    if precnote then result := result + ' en '
                              + HauteurNoteToStr(Tonique);
                    Exit;
            End;

            setlength(ints, 2);
            ints[0] := intTierceMajeure;
            ints[1] := intQuinte;
            if TesterAccord then
            Begin
                    if precnote then
                     result := 'un accord ' + HauteurNoteToStr(TOnique) + ' majeur'
                    else result := 'un accord majeur';
                    Exit;
            End;

            setlength(ints, 2);
            ints[0] := intTierceMineure;
            ints[1] := intQuinte;
            if TesterAccord then
            Begin
                    if precnote then
                     result := 'un accord ' + HauteurNoteToStr(TOnique) + ' mineur'
                    else result := 'un accord mineur';
                    Exit;
            End;

            setlength(ints, 2);
            ints[0] := intTierceMajeure;
            ints[1] := intQuinteAugmentee;
            if TesterAccord then
            Begin
                    if precnote then
                     result := 'un accord ' + HauteurNoteToStr(TOnique) + ' augmenté'
                    else result := 'un accord augmenté';
                    Exit;
            End;

            setlength(ints, 1);
            ints[0] := intTierceMajeure;
            if TesterAccord then
            Begin
                    result := 'un truc bourrin à la tierce majeure-sixte mineure';
                    Exit;
            End;

            setlength(ints, 1);
            ints[0] := intTierceMineure;
            if TesterAccord then
            Begin
                    result := 'un truc bourrin à la tierce mineure-sixte majeure';
                    Exit;
            End;


            result := 'un gros accord bizarre';
        End;
    end;

End;


Function ElMusicalEtSelectionToStr(el: TElMusical): string;
var n, nb_sel: integer;
    hn: THauteurNote;
    
Begin
    nb_sel := 0;
    for n := 0 to high(el.Notes) do
        if el.IsNoteSelectionnee(n) then
        Begin
             hn := el.GetNote(n).HauteurNote;
             inc(nb_sel);
        End;


        if el.NbNotes = nb_sel then
            result := ElMusicalToStr(el, true)
        else if nb_sel > 1 then
            result := ' quelques notes dans ' + ElMusicalToStr(el, true)
        else                  
            result := 'un ' + HauteurNoteToStr(hn) + ' dans '  + ElMusicalToStr(el, true);



End;










procedure EnharmoniquerNote(var n: TNote);
Begin
   Enharmoniquer(n.hauteurnote);
End;













//*******************************************************************************


Function CreerNote(h, p: integer; a: TAlteration): TNote;
{h = hauteur de la note
    0 = do
    1 = ré...
 p = numéro de la portée
 a = alteration}

var n: TNote;
Begin
 VerifierAlteration(a, 'CreerNote');

 n.position.hauteur := h; //en clef de sol
 n.position.portee := p;
 n.hauteurnote.Hauteur := h;
 n.hauteurnote.alteration := a;
 n.AfficherAlteration := (a <> aNormal);
 n.doigtee := 0;
 n.piano_doigtee := 1;
 n.Selectionne := svDeSelectionnee;
 n.BouleADroite := 0;

 Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);

 result := n;


End;





Function CreerNote(iportee: integer): TNote;
Begin
   result := CreerNote(6, iportee, aNormal);
End;





Function CreerElMusical1Note(Duree: TRationnel; Note: TNote): TElMusical;
var elm: TElMusical;
Begin
    elm := TElMusical.Create;
    elm.attributs.Style1 := 0;
    elm.attributs.Style2 := 0;
    elm.attributs.Volume := 127;
    elm.attributs.PetitesNotes := false;

    Note.Selectionne := svDeSelectionnee;
    elm.AddNote(Note);
    elm.NvGroupe := false;

    elm.YExtremiteQueue := 400;
    elm.Duree_Fixee_Set(Duree);
    result := elm;

End;




Function CreerElMusical1Note_DureeApproximative(Duree: TRationnel; Note: TNote): TElMusical;
Begin
      result := CreerElMusical1Note(Duree, Note);
      result.DureeApproximative_Set(duree);
End;




Function CreerElMusicalPause(Duree: TRationnel; portee: integer): TElMusical;
var elm: TElMusical;
Begin
    QVerifierQPasTropBizarre(Duree, 'durée dans CreerElMusicalPause');

    elm := TElMusical.Create;
    elm.Selectionne := svDeSelectionnee;
    if ISQEgal(Duree, Qel(4)) then
         elm.position.hauteur := 2
    else
         elm.position.hauteur := 0;
    elm.position.portee := portee;

    elm.Duree_Fixee_Set(Duree);

    elm.attributs.Style1 := 0;
    elm.attributs.Style2 := 0;
    elm.attributs.Volume := 127;
    elm.attributs.PetitesNotes := false;
    elm.NvGroupe := true;
    result := elm;
End;




Function CreerElMusicalPause_Duree_Approximative(Duree: TRationnel; portee: integer): TElMusical;
Begin
     result := CreerElMusicalPause(duree, portee);

     result.DureeApproximative_Set(duree);
End;





Function CreerElMusicalChroma(elmodele: TElMusical; nbdemitondiff: integer;
                              Duree: TRationnel;
                              portee: integer): TElMusical;
var i:integer;
    el: TElMusical;
Begin
el := CopieElMusical(elmodele);


for i := 0 to high(el.Notes) do
      el.Notes[i].HauteurNote := NbDemiTonToHauteurNote(
               NbDemiTonInHauteurNote(el.Notes[i].HauteurNote) + nbdemitondiff); 


result := el;
End;


Function CopieElMusicalSaufNote(el: TElMusical): TElMusical;
var el2:TElMusical;

Begin
    el2 := TElMusical.Create;

    With el2 do
    Begin
        private_is_duree_approximative := el.private_is_duree_approximative;
        pixx := el.Pixx;
        pixWidth := el.Pixwidth;
        pixWidthdroite := el.pixWidthdroite;
        Selectionne := el.Selectionne;
        Duree := el.Duree;
        PointDuree := el.PointDuree;
        NvGroupe := el.NvGroupe;
        position := el.position;
        attributs := el.attributs;
        YExtremiteQueue := el.YExtremiteQueue;
        QueueVersBas := el.QueueVersBas;
        BoulesCotes := el.BoulesCotes;

    End;
    result := el2;

end;


Function CopieElMusical(el: TElMusical): TElMusical;
var el2:TElMusical;
    i, h: integer;

Begin
      el2 := CopieElMusicalSaufNote(el);
      h := high(el.Notes);

      SetLength(el2.Notes, h+1);

      for i := 0 to high(el.Notes) do
            el2.Notes[i] := el.Notes[i];

      result := el2;
End;


Function CopieElMusicalEnDeselectionnant(const el: TElMusical): TElMusical;
var el2: TElMusical;
Begin
     el2 := CopieElMusical(el);
     el2.Deselectionner;

     result := el2;
End;




Function ElMusicauxCanBeDrawnOnSameX(const el1, el2: TElMusical): boolean;
{renvoit vrai si on peut dessiner les deux éléments musicaux au ^m niveau sur x
  ex : sur do-sol, elle renvoit vrai.. sur do-ré : elle renvoit faux car les
  notes se chevaucheraient et on arriverait plus à lire !!!
     sur do-do : elle renvoit vrai, les notes se chevauchent mais on arrive à lire !
                   (sauf si le remplissage est différent ex : blanche, noire
   en gros, c'est une étude de cas !!!!}

var yab: boolean;
    i, j: integer;

    Function ArePosDiffDe1(const pos1, pos2: TPosition): Boolean;
    Begin
        result := (pos1.portee = pos2.portee) and
                  (abs(pos1.hauteur - pos2.hauteur) = 1);

    End;


 
Begin
      yab := true;

      for i := 0 to high(el1.Notes) do
            for j := 0 to high(el2.Notes) do
            Begin
                  if ArePosDiffDe1(el1.Notes[i].position, el2.Notes[j].position) then
                          yab := false;

                  if IsPositionsEgales(el1.Notes[i].position, el2.Notes[j].position) and
                           ((el1.Notes[i].hauteurnote.alteration <> el2.Notes[j].hauteurnote.alteration) or
                           (((QToReal(el1.Duree) >= 2) and (QToReal(el2.Duree) < 2)) or
                            ((QToReal(el1.Duree) < 2) and (QToReal(el2.Duree) >= 2)))) then
                  {si les positions sont égales, mais que les conditions ne sont pas propice à l'affichage l'un sur l'autre...}

                                   yab := false;
            End;

      result := yab;
End;



Function Position_Dist_Algebrique(p1, p2: TPosition): integer;
{rend un truc positif qd p1 sous p2, ie p1 en dessous p2}
Begin
      if p1.portee < p2.portee then
          result := -1000
      else if p1.portee > p2.portee then
          result := 1000
      else
          result := p2.hauteur - p1.hauteur;

End;



Function HauteurNote_Dist_Algebrique(p1, p2: THauteurNote): integer;
{rend un truc positif qd p1 sous p2, ie p1 en dessous p2}
Begin
          result := p2.hauteur - p1.hauteur;

End;


Function ElMusical_Dist_Algebrique(const e1, e2: TElMusical): integer;
{rend un truc positif qd e1 est sous e2}
var pda12: integer;

Begin
{    e1                e2
     O                 O
     O
                       O
                       O
     O
     }

    pda12 := Position_Dist_Algebrique(e1.PosNoteHaut, e2.PosNoteBas);

    if pda12 > 0 then
        result := pda12
    else
    {là normalement(si ya pa de recoupement...), e2 est sous e1...}

    {    e1                e2
          O                  
          O
                            O
                            O
          O
     }
     
         result := -Position_Dist_Algebrique(e2.PosNoteHaut, e1.PosNoteHaut)



End;




Function ElMusical_Dist_AlgebriqueAvecHauteurNote(const e1, e2: TElMusical): integer;
{rend un truc positif qd e1 est sous e2}
var pda12: integer;

Begin
{    e1                e2
     O                 O
     O
                       O
                       O
     O
     }

    pda12 := HauteurNote_Dist_Algebrique(e1.HauteurNoteNoteHaut, e2.HauteurNoteNoteBas);

    if pda12 > 0 then
        result := pda12
    else
    {là normalement(si ya pa de recoupement...), e2 est sous e1...}

    {    e1                e2
          O                  
          O
                            O
                            O
          O
     }
     
         result := -HauteurNote_Dist_Algebrique(e2.HauteurNoteNoteHaut, e1.HauteurNoteNoteHaut)





End;

Function IsElMusicaux_MemeNotes(const e1, e2: TElMusical): Boolean;
var n: integer;

Begin
    if e1.IsSilence then
         result := e2.IsSilence
         
    else if e2.IsSilence then
         result := false

    else
    if e1.NbNotes <> e2.NbNotes then
         result := false
    else
    Begin
        result := true;
        for n := 0 to e1.NbNotes - 1 do
            if not IsNotesEgales(e1.GetNote(n), e2.GetNote(n)) then
            Begin
                  result := false;
                  Break;
            End;

    End;


End;



procedure VerifierElMusical(el: TElMusical; mess: string);
Begin
    if el = nil then
        MessageErreur('élément musical à NULL... arf...' + mess);

    el.VerifierIntegrite(mess);
End;
      
end.
 