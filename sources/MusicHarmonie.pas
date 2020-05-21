unit MusicHarmonie;

interface


uses Sysutils, Math;








const f0 = 261.625565300599;//fréquence du do (hauteur = 0)

const hOctave = 7;
      hDo = 0;
      hRe = 1;
      hMi = 2;
      hFa = 3;
      hSol = 4;
      hLa = 5;
      hSi = 6;

      cTonaliteDeLaMesureCourante = -123;


type TClef = (ClefSol, ClefFa, ClefUt3, ClefSol8);

const CLEF_PAR_DEFAUT = ClefSol;


type TInfoClef = integer;

type TAlteration = (aDbBemol, aBemol, aNormal, aDiese, aDbDiese, aIndefini);

{ce type modèlise la hauteur d'une note...via}
type
THauteurNote = record
        Hauteur: integer;
         {la hauteur : do central = 0, ré = 1, ... do1 = 7 ...}
        alteration: TAlteration;
         {si #, b...}

End; {utilisé notamment dans la propriété "transposition" de PorteesGlobales}



{ce type est utilisé pour modéliser un intervalle}
TIntervalle = THauteurNote;
 {ex : sol0 ====> quinte, fa1 =====> une octave + une quarte ...}


TFiltreNoteSouris = array of THauteurNote; 


TTonalite = ShortInt;



const
      hn0: THauteurNote = (Hauteur: 0; alteration: aNormal);
      {intervalle trivial (nul)}


      intervalle0: TIntervalle = (Hauteur: 0; alteration: aNormal);

//quelques autres intervalles
      intSecondeH: THauteurNote = (Hauteur: 1; alteration: aNormal);
      intSiMoins1: THauteurNote = (Hauteur: -1; alteration: aNormal);
      intSecondeB: THauteurNote = (Hauteur: -1; alteration: aBemol);
      intQuinte: THauteurNote = (Hauteur: 4; alteration: aNormal);
      intQuinteAugmentee: THauteurNote = (Hauteur: 4; alteration: aDiese);
      intTierceMajeure: THauteurNote = (Hauteur: 2; alteration: aNormal);
      intTierceMineure: THauteurNote = (Hauteur: 2; alteration: aBemol);
      intSeptiemeDiminue: THauteurNote = (Hauteur: 6; alteration: aBemol);
      intQuinteH: THauteurNote = (Hauteur: 4; alteration: aNormal);
      intQuinteB: THauteurNote = (Hauteur: -4; alteration: aNormal);
      intOctaveH: THauteurNote = (Hauteur: 7; alteration: aNormal);
      intOctaveB: THauteurNote = (Hauteur: -7; alteration: aNormal);
      hnTierceMineureB: THauteurNote = (Hauteur: -2; alteration: aNormal);



      NbDemiTonDepuisDo0:   array[0..6] of integer = (0,2,4,5,7,9,11);

Function HauteursNotesEgales(h1, h2: THauteurNote): Boolean;
{renvoie vrai si h1 et h2 représentent la même note}

Function Octave(Hauteur: integer): integer;
{renvoie le numéro de l'octave}

Function IndiceNote(Hauteur: integer): integer;
{renvoie 0 (do), 1 (ré), ... 6 (si)}

//Function AlterationToInt(a:TAlteration): integer;


Function ClefToInfoClef(c: TClef): TInfoClef;


Function HauteurGraphiqueToHauteurAbs(infoclef: TInfoClef; hg: integer): integer;
Function HauteurAbsToHauteurGraphique(infoclef: TInfoClef; ha: integer): integer;


Function CompterDemiTonOreille(hn1, hn2: THauteurNote): integer;
Function Intervalle(hn1, hn2: THauteurNote): TIntervalle;

Procedure GetHauteurNote_Sans_Erreur(int: TIntervalle; hn1: THauteurNote; var hn2: THauteurNote);
Procedure GetHauteurNote(int: TIntervalle; hn1: THauteurNote; var hn2: THauteurNote);
Function IntervalleToStr(int: TIntervalle):string;
Function IsIntervalleTrivial(int: TIntervalle): Boolean;

Function HauteurAbsToStr(h:integer): string;
Function HauteurNoteToStr(hn: THauteurNote): string;
Function HauteurNoteToStrNomNoteJuste(hn: THauteurNote):string;
Function AlterationIncorrecteToStr(a: TAlteration): string;


Function StrToHauteurNote(s: string): THauteurNote;
{convertit par exemple "C5" en 5e do}

Function IsHauteurNote1InfHauteurNote2(hn1, hn2: THauteurnote): Boolean;
{renvoie vrai ssi hn1 est une note plus grave que hn2}

Function IsHauteursNotesEgales(hn1, hn2: THauteurNote): Boolean;
Function IsHauteursNotesEgales_Modulo_L_Octave_Et_Modulo_L_Alteration(hn1, hn2: THauteurNote): Boolean;

Function AjouterQuinte(hn: THauteurNote; nbquinte: integer): THauteurNote;
Function AlterationAvecTonalite(habs: integer; tonalite: shortint): TAlteration;

Function NbDemiTonProchePourMemeNote(nbref, nb: integer): integer;

Function HauteurNoteAvecHauteurEtAlteration(h: integer; a: TAlteration): THauteurNote;
Function NbDemiTonToHauteurNote(nbdemiton: integer): THauteurNote; overload;
Function NbDemiTonToHauteurNote(nbdemiton: integer; tonalite: Shortint): THauteurNote; overload;
Function HauteurNoteToNbDemiTon(hn: THauteurNote): integer;
Function HauteurNoteToFreq(hn: THauteurNote): real;

Function NbDemiTonInHauteurNote(hn: THauteurNote): integer;
Function NbDemiTonEntre(hn1, hn2: THauteurNote): integer;

Function HauteurNoteAvecFreq(freq: real): THauteurNote;
Function NbDemiTonToFreq(nbdemiton: integer): real;

Function TonaliteToTonique(tonalite: ShortInt): THauteurNote;
Function TonaliteToToniqueSansVerifier(tonalite: ShortInt): THauteurNote;
Function Tonalite_NoteSensible_Get(tonalite: TTonalite): THauteurNote;

Function Tonalite(tonique: THauteurNote): shortint;

Function TonalitePlusAlteration(tonalite: TTonalite; alt:TAlteration): TTonalite;

procedure SimplifierHauteurNote(var hn: THauteurNote);

Function hnplusproche(h: integer): THauteurNote;
{recherche dans letableau FiltreNoteSouris la hauteur de note la plus proche
 de celle donné par h}

Procedure Enharmoniquer(var hn: THauteurNote); overload;
Function Enharmoniquer(hn: THauteurNote; TonaliteCourante: TTonalite): THauteurNote; overload;


Procedure VerifierTonalite(var tonalite: ShortInt);

procedure RemplirFiltreNoteSouris(var FiltreNoteSouris: TFiltreNoteSouris;
                                  TonaliteCourante: TTonalite);


Function IsAlterationCorrecte(a: TAlteration): boolean;
procedure VerifierAlteration(var a: TAlteration; info: string);
procedure VerifierHauteurNote(var hn: THauteurNote; info: string);

Function AlterationSuivante(a: TAlteration): TAlteration;
Function AlterationPrecedente(a: TAlteration): TAlteration;

Function TonaliteToStr(tonalite: TTonalite): string;


var FiltreNoteSouris: TFiltreNoteSouris;
{a priori, la souris pourrait aller sur toutes les notes... mais dans
 Musicwriter, il y a une surcouche entre la souris la note sous le curseur :
 c'est le tableau FiltreNoteSouris.
 Par défaut, FiltreNoteSouris contient "do, ré, mi, fa, sol, la, si". Ainsi,
 on a accès à toutes les notes. Mais si on ne met que "do mi sol" alors on ne
 pourra écrire que les notes de l'accord de do majeur (pratique pour écrire des
 arpèges)}












implementation

 uses MusicWriter_Erreur {pour MessageErreur}, langues;


 const ClefHauteurAbs: array[TClef] of integer = (6 {clef de sol},
                                                 -6 {clef de fa},
                                                 0   {clef d'ut3},
                                                 6+7 {clef de sol8});
{contient les hauteurs absolues de la note situé sur le trait central
  remarque hauteur absolue : hauteur où hauteur = 0 correspond au Do central

  exemple : pour la clé de sol, le "6", signifie que sur le trait central (3e
              ligne), on a la note de hauteur 6, ie le si}


    Function AlterationToInt(a:TAlteration): integer;
    Begin
    result := Ord(a) - 2;

    {-2 : ddbémol
     -1 : bémol
     0 : normal
     1 : dièse
     2 : double-dièse}
    End;


    Function IntToAlteration(i: integer): TAlteration;
    Begin
        result := TAlteration(i + 2);

    End;


            
  Function IsAlterationCorrecte(a: TAlteration): boolean;
  Begin
      result := (abs(AlterationToInt(a)) <= 2);
  End;


  Function AlterationSuivante(a: TAlteration): TAlteration;
  Begin
      if AlterationToInt(a) < 2 then
           result := IntToAlteration(AlterationToInt(a) + 1)
      else
           result := a;
  End;


  Function AlterationPrecedente(a: TAlteration): TAlteration;
  Begin
      if AlterationToInt(a) > -2 then
           result := IntToAlteration(AlterationToInt(a) - 1)
      else
           result := a;
  End;

  procedure VerifierAlteration(var a: TAlteration; info: string);
  Begin
  if not IsAlterationCorrecte(a) then
  Begin
          MessageErreur('Altération incorrecte. ' + info);
          a := aNormal;
  End;
  End;

 procedure VerifierHauteurNote(var hn: THauteurNote; info: string);
 Begin
     VerifierAlteration(hn.Alteration, info + ' (vérification altération)');

     if abs(hn.Hauteur) > 1000 then
     Begin
           MessageErreur(info + 'VerifierHauteurNote : la hauteur est énorme ! elle est mise à 0');
           hn.Hauteur := 0;
     End;
 End;

 procedure VerifierIntervalle(var hn: TIntervalle; info: string);
 Begin


     if abs(hn.Hauteur) > 1000 then
     Begin
           MessageErreur(info + 'VerifierHauteurNote : la hauteur est énorme ! elle est mise à 0');
           hn.Hauteur := 0;
     End;
 End;

 procedure VerifierHauteur(var h: integer; info: string);
 Begin
      if abs(h) > 1000 then
      Begin
            MessageErreur(info + 'hauteur énorme !!! -> mise à 0');
            h := 0;
      End;
 End;

 procedure VerifierInfoClef(var h: TInfoClef; info: string);
 Begin
      if abs(h) > 1000 then
      Begin
            MessageErreur(info + 'info clef énorme !!! -> mise à 0');
            h := 0;
      End;
 End;

Function HauteursNotesEgales(h1, h2: THauteurNote): Boolean;
Begin
    result := (h1.Hauteur = h2.Hauteur) and (h1.alteration = h2.alteration);
End;




Function ClefToInfoClef(c: TClef): TInfoClef;
Begin
    result := ClefHauteurAbs[c];
End;




Function HauteurGraphiqueToHauteurAbs(infoclef: TInfoClef; hg: integer): integer;
Begin
   VerifierInfoClef(infoclef, 'info clef HauteurGraphiqueToHauteurAbs');
   VerifierHauteur(hg, 'hg HauteurGraphiqueToHauteurAbs');
   

   result := hg + infoclef;
End;


Function HauteurAbsToHauteurGraphique(infoclef: TInfoClef; ha: integer): integer;
Begin
   VerifierInfoClef(infoclef, 'HauteurGraphiqueToHauteurAbs');
   VerifierHauteur(ha, 'ha HauteurGraphiqueToHauteurAbs');

   result := ha - infoclef;
End;







Function Octave(Hauteur: integer): integer;
Begin
    if Hauteur < 0 then
    Begin
          if Hauteur mod 7 = 0 then
                 result := Hauteur div 7
          else
                 result := Hauteur div 7 - 1;
    End


    else
           result := Hauteur div 7;
End;


Function IndiceNote(Hauteur: integer): integer;
var m: integer;
{0 = do, 1 = ré...}
Begin
    m := Hauteur mod 7;

    if m < 0 then
         result := m + 7
    else
         result := m;
End;


Function hnplusproche(h: integer): THauteurNote;
{recherche dans letableau FiltreNoteSouris la hauteur de note la plus proche
 de celle donné par h}
var i, imieux, dist, hh, ndist, v1, v2: integer;
    hn: THauteurNote;


        Function disthauteur(h1, h2: integer): integer;
        Begin
            result := min(abs(h1 - h2), abs(h1 - h2 - 7));
        End;


Begin
    hh := IndiceNote(h);

    dist := 1000;

    imieux := 0; //valeur initiale (au cas où)

    for i := 0 to high(FiltreNoteSouris) do
    Begin
            ndist := disthauteur(FiltreNoteSouris[i].Hauteur, hh);
            if ndist < dist then
            Begin
                 imieux := i;
                 dist := ndist;
            End;

    End;

    v1 := 7*Octave(h) + FiltreNoteSouris[imieux].Hauteur;
    v2 := 7*Octave(h) + FiltreNoteSouris[imieux].Hauteur - 7;

    if abs(v1 - h) > abs(v2 - h) then
          v1 := V2;

    hn.Hauteur := v1;
    hn.alteration := FiltreNoteSouris[imieux].alteration;

    result := hn;

End;


procedure RemplirFiltreNoteSouris(var FiltreNoteSouris: TFiltreNoteSouris;
                                  TonaliteCourante: TTonalite);
var i : integer;
Begin
    Setlength(FiltreNoteSouris, 7);

    for i := 0 to 6 do
    Begin
        FiltreNoteSouris[i].Hauteur := i; (* i = 0, do; i = 1, ré*)
        FiltreNoteSouris[i].alteration := AlterationAvecTonalite(i, TonaliteCourante);
    End;
End;



Function HauteurAbsToStr(h:integer): string;
Begin
    result := Langues_NomNote_Get(IndiceNote(h)) + inttostr(Octave(h));
End;


Function HauteurAbsToNomNoteJuste(h:integer): string;
Begin
    result := Langues_NomNote_Get(IndiceNote(h));
End;


Function StrToHauteurNote(s: string): THauteurNote;
var note, octave: integer;
Begin
case s[1] of
    'A': note := 5;
    'B': note := 6;
    'C': note := 0;
    'D': note := 1;
    'E': note := 2;
    'F': note := 3;
    'G': note := 4;
    else
       Begin
            MessageErreur('Problème de formatage dans le texte d''une hauteur de note : ' + s +
                          '. On renvoie "do".');
            note := 0;
       End;
end;

s := copy(s, 2, 10000);

if s = '' then
     octave := 0
else
     octave := StrToInt(s);

result.Hauteur := note + 7*octave;
result.alteration := aNormal;
End;


Function IsHauteurNote1InfHauteurNote2(hn1, hn2: THauteurnote): Boolean;
Begin
    result := HauteurNoteToNbDemiTon(hn1) <= HauteurNoteToNbDemiTon(hn2);
End;


Function IsHauteursNotesEgales_Modulo_L_Octave_Et_Modulo_L_Alteration(hn1, hn2: THauteurNote): Boolean;
Begin
    result := (hn1.Hauteur - hn2.Hauteur) mod 7 = 0;
ENd;


Function IsHauteursNotesEgales(hn1, hn2: THauteurNote): Boolean;
Begin
    result := (hn1.Hauteur = hn2.Hauteur) and (hn1.alteration = hn2.alteration);
End;

Function AlterationToStr(a: TAlteration): string;
Begin
       case a of
         aDbBemol: result := 'bb';
         aBemol: result := 'b';
         aNormal: result := '';
         aDiese: result := '#';
         aDbDiese: result := 'x';
         else
            MessageErreur('Altération incorrecte dans AlterationToStr');
            result := '???';
    end;
End;


Function AlterationIncorrecteToStr(a: TAlteration): string;
var i: integer;

Begin
    i := AlterationToInt(a);

    if i > 0 then
         result := IntToStr(i) + ' dièses'
    else
         result := inttostr(-i) + ' bémols';

End;

Function HauteurNoteAvecHauteurEtAlteration(h: integer; a: TAlteration): THauteurNote;
Begin
    result.Hauteur := h;
    result.alteration := a;
End;




Function HauteurNoteToStr(hn: THauteurNote):string;
var s, t: string;
Begin

    s := HauteurAbsToStr(hn.Hauteur);
    t := AlterationToStr(hn.alteration);


    if t = '' then
          result := s
    else
          result := s + ' ' + t;


End;


Function HauteurNoteToStrNomNoteJuste(hn: THauteurNote):string;
var s, t: string;
Begin

    s := HauteurAbsToNomNoteJuste(hn.Hauteur);
    t := AlterationToStr(hn.alteration);

    if t = '' then
          result := s
    else
          result := s + ' ' + t;


End;





Function NbDemiTonApres(hauteur: integer): integer;
Begin
case IndiceNote(Hauteur) of
      0,1,3,4,5: result := 2;
      2,6: result := 1;
      else
      Begin
         MessageErreur('Pb dans NbDemiTonApres');
         result := 1;
      End;
end;
End;



procedure SimplifierHauteurNote(var hn: THauteurNote);
Begin
if hn.alteration = aDbDiese then
Begin
    case IndiceNote(hn.hauteur) of
          0,1,3,4,5: hn.alteration := aNormal;
          2,6: hn.alteration := aDiese;
    end;
    inc(hn.hauteur);
End else if hn.alteration = aDbBemol then
Begin
    case IndiceNote(hn.hauteur-1) of
          0,1,3,4,5: hn.alteration := aNormal;
          2,6: hn.alteration := aBemol;
    end;
    dec(hn.hauteur);
End

End;


Function CompterDemiTonOreilleH(h1, h2: integer): integer;
var compt, i: integer;
Begin
    compt := 0;

    if h1 < h2 then
    Begin
        for i := h1 to h2-1 do
                 inc(compt, NbDemiTonApres(i));
    end
    else
    if h1 > h2 then
    Begin
        for i := h1-1 downto h2 do
                 dec(compt, NbDemiTonApres(i));
    end;

    result := compt;
End;




Function CompterDemiTonOreille(hn1, hn2: THauteurNote): integer;
{compte le nb de demi-tons entre les deux notes (tempérées)}
var compt: integer;

Begin
    compt := -AlterationToInt(hn1.alteration);
    inc(compt, AlterationToInt(hn2.alteration));

    inc(compt, CompterDemiTonOreilleH(hn1.Hauteur, hn2.Hauteur));

    result := compt;
End;




Function Intervalle(hn1, hn2: THauteurNote): TIntervalle;
{mesure l'intervalle entre deux notes}
var int: TIntervalle;
    compthn, comptint, diff: integer;

Begin
    int.Hauteur := hn2.Hauteur - hn1.Hauteur;

    compthn := CompterDemiTonOreille(hn1, hn2);
    comptint := CompterDemiTonOreilleH(0,int.Hauteur);


    diff := compthn - comptint;

    int.alteration := IntToAlteration(diff);


    result := int;

    VerifierIntervalle(int, 'fonction Intervalle');
End;



Procedure GetHauteurNote_Sans_Erreur(int: TIntervalle; hn1: THauteurNote; var hn2: THauteurNote);
{renvoit hn2 de manière à ce que hn1-hn2 est l'intervalle int}
var diffhauteur,
    compthn, comptint   : integer;
Begin
    VerifierIntervalle(int, 'int dans GetHauteurNote (précondition)');
    VerifierHauteurNote(hn1, 'hn1 dans GetHauteurNote (précondition)');

    diffhauteur := int.hauteur;

    hn2.Hauteur := hn1.Hauteur + diffhauteur;
    hn2.alteration := aNormal;

    compthn := CompterDemiTonOreille(hn1, hn2);
    comptint := CompterDemiTonOreille(hn0,int);

    hn2.alteration := IntToAlteration(comptint - compthn);


End;

Procedure GetHauteurNote(int: TIntervalle; hn1: THauteurNote; var hn2: THauteurNote);
Begin
    GetHauteurNote_Sans_Erreur(int, hn1, hn2);

    VerifierHauteurNote(hn2, 'hn2 dans GetHauteurNote (postcondition)');

End;



Function IsIntervalleTrivial(int: TIntervalle): Boolean;
Begin
   result := (int.Hauteur = 0) and (int.alteration = aNormal);
End;


Function IntervalleToStr(int: TIntervalle):string;
var o, n, altint: integer;
    s0, s, s1, s2: string;
    neg: boolean;

Begin
    neg := (CompterDemiTonOreille(hn0, int) < 0);

    {on se ramène toujours au cas d'un intervalle "orienté vers le haut"
     ie int.Hauteur >= 0}
    if neg then
    Begin
        int := Intervalle(int, hn0);
        s0 := '- '
    End
    else s0 := '';
    {ici, int.Hauteur >= 0}
     
    o := Octave(int.Hauteur);



    case o of
         0: s := '';
         1: s := 'un intervalle d''une octave';
         else s := 'un intervalle de ' + inttostr(o) + ' octaves';
    end;

    n := int.Hauteur mod 7;
    case n of
         0: s1 := '';
         1: s1 := 'une seconde';
         2: s1 := 'une tierce';
         3: s1 := 'une quarte';
         4: s1 := 'une quinte';
         5: s1 := 'une sixte';
         6: s1 := 'une septième';
    end;

    altint := AlterationToInt(int.alteration);

    case n of
         2,5: {tierce et sixte}
            Begin
                case altint of
                      -2: s2 := 'sur diminuée';
                      -1: s2 := 'mineure';
                      0: s2 := 'majeure';
                      1: s2 := 'augmentée';
                      2: s2 := 'sur augmentée';
                      else s2 := 'arfe';
                end;

            End;

         1, 3,4,6: {les autres...où on a pas de notion de mode}
            Begin
                case altint of
                      -2: s2 := 'sur diminuée';
                      -1: s2 := 'diminuée';
                      0: s2 := '';
                      1: s2 := 'augmentée';
                      2: s2 := 'sur augmentée';
                      else s2 := 'arfe';
                end;

            End;

         0:
            if o = 0 then
            Begin
                case altint of
                      0: s1 := 'un intervalle nul';
                      1: s1 := 'un demi-ton-chromatique';
                      2: s2 := 'un ton chromatique';
                      else s2 := 'arf';
                end;


            End
            else s1 := '';


    end;


if (o = 0) or (o = -1) then
       s := s1 + ' ' + s2
else if s1 <> '' then
       s := s + ' + ' + s1 + ' ' + s2;

result := s0 + ' ' + s;
End;






Function AjouterQuinte(hn: THauteurNote; nbquinte: integer): THauteurNote;
var i: integer;
Begin
if nbquinte > 0 then
Begin
     for i := 1 to nbquinte do
            GetHauteurNote(intQuinteH, hn, hn);
End
Else
     for i := 1 to -nbquinte do
            GetHauteurNote(intQuinteB, hn, hn);

result := hn;
End;


Function TonaliteToTonique(tonalite: ShortInt): THauteurNote;
Begin
      VerifierTonalite(tonalite);

      result := hn0;
      result := AjouterQuinte(result, tonalite);

      VerifierHauteurNote(result, 'postcondition dans TonaliteToTonique');
End;



Function TonaliteToToniqueSansVerifier(tonalite: ShortInt): THauteurNote;
Begin
      result := hn0;
      result := AjouterQuinte(result, tonalite);

      VerifierHauteurNote(result, 'postcondition dans TonaliteToTonique');
End;



Function Tonalite_NoteSensible_Get(tonalite: TTonalite): THauteurNote;
Begin
     result := TonaliteToTonique(tonalite);
         {là, on a la tonique de la gamme majeure}

     GetHauteurNote(hnTierceMineureB, result, result);
         {pour obtenir la tonique de la gamme mineure}
     
     GetHauteurNote(intSiMoins1, result, result);
     {et pouf on récupère la note sensible}
End;


Function AlterationAvecTonalite(habs: integer; tonalite: shortint): TAlteration;
const NoteDiese: array[1..7] of integer = (hFa, hDo, hSol, hRe, hLa, hMi, hSi);
      NoteBemol: array[1..7] of integer = (hSi, hMi, hLa, hRe, hSol, hDo, hFa);

var i: integer;
Begin
    {par défaut, (do majeur), les notes ne sont pas altérées}
    result := aNormal;

    {ramène la hauteur dans l'intervalle 0-6}
    habs := IndiceNote(habs);


    if tonalite >= 0 then
    Begin
           for i := 1 to tonalite do
                if habs = NoteDiese[i] then
                       Begin
                           result := aDiese;
                           Exit;
                       End;
    end
    else
    if tonalite < 0 then
           for i := 1 to -tonalite do
                if habs = NoteBemol[i] then
                       Begin
                           result := aBemol;
                           Exit;
                       End;



End;


Function NbDemiTonProchePourMemeNote(nbref, nb: integer): integer;
{considère une note référence où le nombre de demi-ton vaut nbref.
 considère une note (modulo une octave). Par exemple un fa#/sol b, représentée
 par nb, le nombre de demi-ton par rapport au do central.
 (spécif : nb entre 0 et 11)

 Cette fonction le fa#/sol b le plus proche de la note référence}
 var solreelle : real;
     k1, k2: integer; 
Begin
     solreelle := (nbref - nb) / 12;

     k1 := floor {partie entière}(solreelle);
     k2 := k1 + 1;
     if abs(nb + 12 * k1 - nbref) < abs(nb + 12 * k2 - nbref) then
          result := nb + 12 * k1
     else
          result := nb + 12 * k2;

End;


Function NbDemiTonToHauteurNote(nbdemiton: integer): THauteurNote; overload;
var hn: THauteurNote;
    nboctave, restedemiton: integer;
Begin


    if nbdemiton < 0 then
          nboctave := (nbdemiton + 1) div 12 - 1
    else
          nboctave := nbdemiton div 12;

    restedemiton := nbdemiton - nboctave * 12;

    case restedemiton of
           0:  Begin hn.Hauteur := 0; hn.Alteration := aNormal; End;
           1:  Begin hn.Hauteur := 0; hn.Alteration := aDiese; End;
           2:  Begin hn.Hauteur := 1; hn.Alteration := aNormal; End;
           3:  Begin hn.Hauteur := 1; hn.Alteration := aDiese; End;
           4:  Begin hn.Hauteur := 2; hn.Alteration := aNormal; End;
           5:  Begin hn.Hauteur := 3; hn.Alteration := aNormal; End;
           6:  Begin hn.Hauteur := 3; hn.Alteration := aDiese; End;
           7:  Begin hn.Hauteur := 4; hn.Alteration := aNormal; End;
           8:  Begin hn.Hauteur := 4; hn.Alteration := aDiese; End;
           9:  Begin hn.Hauteur := 5; hn.Alteration := aNormal; End;
           10: Begin hn.Hauteur := 5; hn.Alteration := aDiese; End;
           11: Begin hn.Hauteur := 6; hn.Alteration := aNormal; End;
           else Begin hn.Hauteur := 0; hn.Alteration := aNormal; End;
    end;

    inc(hn.Hauteur,nboctave * 7);
    result := hn;

    VerifierHauteurNote(hn, 'post condition HauteurNoteAvecNbDemiTon');

End;



Function NbDemiTonToHauteurNote(nbdemiton: integer; tonalite: Shortint): THauteurNote; overload;
{ex d'utilisations :
   entrée : nbdemiton := 3 (ré#/mib)
            tonalite = 0 (do majeur)

            => renvoie ré#

   entrée : nbdemiton := 3 (ré#/mib)
            tonalite = -3 (do mineur)

            => renvoie mib
}
var tonique : THauteurNote;

Begin
     tonique := TonaliteToTonique(tonalite);

     nbdemiton := nbdemiton - NbDemiTonInHauteurNote(tonique);

     result := NbDemiTonToHauteurNote(nbdemiton);

     GetHauteurNote(tonique, result, result);

     VerifierHauteurNote(result, 'post condition HauteurNoteAvecNbDemiTon');

End;


Function HauteurNoteAvecFreq(freq: real): THauteurNote;
Begin
     result := NbDemiTonToHauteurNote(round(12 * ln(freq / f0) / ln(2)));
End;

Function HauteurNoteToNbDemiTon(hn: THauteurNote): integer;
var o, nbdemiton:integer;
Begin
    VerifierHauteurNote(hn, 'HauteurNoteToNbDemiTon');

    o := Octave(hn.Hauteur);

    case IndiceNote(hn.Hauteur) of
          0: nbdemiton := 0;
          1: nbdemiton := 2;
          2: nbdemiton := 4;
          3: nbdemiton := 5;
          4: nbdemiton := 7;
          5: nbdemiton := 9;
          6: nbdemiton := 11;
          else
          Begin
              MessageErreur('problème dans HauteurNoteToNbDemiTon');
              nbdemiton := 0;
          End;
    end;


    result := o * 12 + nbdemiton + AlterationToInt(hn.alteration);
End;




Function HauteurNoteToFreq(hn: THauteurNote): real;
Begin
     result := NbDemiTonToFreq(HauteurNoteToNbDemiTon(hn));
End;


Function NbDemiTonToFreq(nbdemiton: integer): real;
Begin
    result := f0 * Power(2, nbdemiton / 12);

End;



Function Tonalite(tonique: THauteurNote): shortint;
{à partir de la note tonique (1er degré), renvoit le nombre de dièse (si >0) ou
 de bémol (si < 0) à la clé pour la tonalité de la tonique en majeur}

Begin
    if tonique.hauteur = 0 then
        result := 0
    else
        result := -2;

End;




Function NbDemiTonInHauteurNote(hn: THauteurNote): integer;
Begin
    result := Octave(hn.Hauteur) * 12 + NbDemiTonDepuisDo0[IndiceNote(hn.Hauteur)];

    result := result + AlterationToInt(hn.alteration);
End;



Function NbDemiTonEntre(hn1, hn2: THauteurNote): integer;
Begin
    result := NbDemiTonInHauteurNote(Intervalle(hn1, hn2));
End;


Procedure Enharmoniquer(var hn: THauteurNote);
Begin
    if hn.alteration = aDiese then
    Begin
       if NbDemiTonApres(hn.Hauteur) = 2 then
            hn.alteration := aBemol
       else
            hn.alteration := aNormal;

       inc(hn.Hauteur);
    End else

    if hn.alteration = aBemol then
    Begin
       if NbDemiTonApres(hn.Hauteur-1) = 2 then
            hn.alteration := aDiese
       else
            hn.alteration := aNormal;

       dec(hn.Hauteur);
    End;


End;


Function Enharmoniquer(hn: THauteurNote; TonaliteCourante: TTonalite): THauteurNote; overload;
var nb_demiton: integer;
Begin
     nb_demiton := HauteurNoteToNbDemiTon(hn);
     result := NbDemiTonToHauteurNote(nb_demiton, TonaliteCourante);

End;


Function TonaliteToStr(tonalite: TTonalite): string;
{ex : si tonalite = <un dièse> (ie 1), alors
        renvoie "sol majeur / mi mineur"}
var hn: THauteurNote;
begin
       hn := TonaliteToTonique(tonalite);
       result := HauteurNoteToStrNomNoteJuste(hn) + ' ' + Langues_Traduire('majeur');

       GetHauteurNote(hnTierceMineureB, hn, hn);
       result := result + ' / ' + HauteurNoteToStrNomNoteJuste(hn) + ' ' + Langues_Traduire('mineur');
End;

Procedure VerifierTonalite(var tonalite: ShortInt);
Begin
    if not (abs(tonalite) in [0..7]) then
    Begin
          MessageErreur('Tonalité incorecte ! Ici, la valeur de tonalité est ' +
          inttostr(tonalite) + ' et c''est pas bon ! On met à 0 (do majeur)');
          tonalite := 0;

    End;

End;



Function TonalitePlusAlteration(tonalite: TTonalite; alt:TAlteration): TTonalite;
Begin
   result := Tonalite + AlterationToInt(alt);
   if result > 7 then result := 7;
   if result < -7 then result := -7;
End;


end.

