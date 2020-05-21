unit tablature_system;

interface

uses MusicSystem_Types, MusicHarmonie;


Function Tablature_System_CordeNumToPositionHauteur(corde_num: integer): integer;
Function Tablature_System_PositionHauteurToCordeNum(hauteur: integer): integer;

Function Tablature_System_CordeNum_Get(n: TNote): Byte;
procedure Tablature_System_CordeNum_Set(var n: TNote; numero_corde: Byte);

Procedure Tablature_CordeNum_Arrondir(var numcorde: integer);

procedure Tablature_System_NumeroCase_Set(var n: TNote; numero_case: Byte);
Function Tablature_System_NumeroCase_Get(n: TNote): Byte;


procedure Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(var n: TNote);
procedure Tablature_System_NumCorde_Set_OuEnDessous(var n: TNote; numero_corde: integer);

Function Tablature_System_NumCordeToHauteurNoteCordeAVide(numero_corde: integer): THauteurnote;
Function Tablature_System_NumCordeNumCaseToHauteurNote(numero_corde, numero_case: integer): THauteurNote;







implementation

uses MusicWriter_Erreur,
     SysUtils;


const Cordes_Nb_Total = 6;

const Corde_A_Vide_HN: array[0..Cordes_Nb_Total - 1] of THauteurNote =

        ( (Hauteur: hMi - hOctave ; alteration: aNormal),
          (Hauteur: hLa - hOctave ; alteration: aNormal),
          (Hauteur: hRe           ; alteration: aNormal),
          (Hauteur: hSol          ; alteration: aNormal),
          (Hauteur: hSi           ; alteration: aNormal),
          (Hauteur: hMi + hOctave ; alteration: aNormal)

        );






Function Tablature_System_PositionHauteurToCordeNum(hauteur: integer): integer;
Begin
    result := hauteur div 2 + 3;
End;

Function Tablature_System_CordeNumToPositionHauteur(corde_num: integer): integer;
Begin
    result := (corde_num - 3) * 2;
End;


Function Tablature_System_CordeNum_Get(n: TNote): Byte;
Begin
    result := Tablature_System_PositionHauteurToCordeNum(n.tablature_position.hauteur);
End;



Procedure Tablature_CordeNum_Arrondir(var numcorde: integer);
Begin
    if numcorde < 0 then
         numcorde := 0
    else
    if numcorde >= Cordes_Nb_Total then
         numcorde := Cordes_Nb_Total - 1;
         
End;


Function Tablature_System_NumCordeToHauteurNoteCordeAVide(numero_corde: integer): THauteurnote;
Begin
    result := Corde_A_Vide_HN[numero_corde];
End;



Function Tablature_System_NumCordeNumCaseToHauteurNote(numero_corde, numero_case: integer): THauteurNote;
Begin

    Result := NbDemiTonToHauteurNote(NbDemiTonInHauteurNote(Tablature_System_NumCordeToHauteurNoteCordeAVide(numero_corde))
                                                 + numero_case ,
                                       0);
End;


procedure Tablature_System_CordeNum_Set(var n: TNote; numero_corde: Byte);
var numero_case: integer;

Begin
    if numero_corde > Cordes_Nb_Total - 1 then
    Begin
        MessageErreur('Numéro de corde incorrect dans Tablature_System_CordeNum_Set : ' +
                       inttostr(numero_corde) + '. On met à 0.');
        numero_corde := 0;
    End;

    n.tablature_position.portee := n.position.portee + 1;
    n.tablature_position.hauteur := Tablature_System_CordeNumToPositionHauteur(numero_corde);

    numero_case := NbDemiTonEntre(Corde_A_Vide_HN[numero_corde], n.HauteurNote);

    if (numero_case < 0) or (numero_case > 255) then
        n.doigtee := 255
    else
    n.doigtee := numero_case;
End;


procedure Tablature_System_NumeroCase_Set(var n: TNote; numero_case: Byte);
Begin
    n.doigtee := numero_case;

    n.HauteurNote := Tablature_System_NumCordeNumCaseToHauteurNote(
       Tablature_System_CordeNum_Get(n),
       numero_case);
End;



Function Tablature_System_NumeroCase_Get(n: TNote): Byte;
Begin
    result := n.doigtee;
End;

procedure Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(var n: TNote);
var numero_corde, numero_case: integer;

Begin
    Tablature_System_NumCorde_Set_OuEnDessous(n, Cordes_Nb_Total-1);
    {on tente la corde la plus aigu...si pas possible, on descendra en fait
     de cordes, vers des cordes plus graves}
End;


procedure Tablature_System_NumCorde_Set_OuEnDessous(var n: TNote; numero_corde: integer);
var numero_case: integer;

Begin
    inc(numero_corde); //en fait, on commence toujours d'une corde dans laquelle c'est "pas possible"
                         //ou pas "voulu"

    numero_case := -1000;

    while (numero_case < 0) and (numero_corde > 0) do
    Begin
        dec(numero_corde);

        numero_case := NbDemiTonEntre(Corde_A_Vide_HN[numero_corde], n.HauteurNote);
    End;

    n.tablature_position.portee := n.position.portee + 1;
    n.tablature_position.hauteur := Tablature_System_CordeNumToPositionHauteur(numero_corde);

    if numero_case < 0 then
        n.doigtee := 0
    else
    if numero_case > 255 then
        n.doigtee := 255
    else
        n.doigtee := numero_case;

    
    
End;

end.
