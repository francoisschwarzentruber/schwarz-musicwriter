unit MusicGraph_CouleursVoix;

interface

uses MusicSystem_CompositionAvecPagination {pour TCompositionAvecPagination},
     Graphics {pour TColor} ;

const NbCouleurDeVoix = 4;

      var OPTION_AfficherCouleursNotes: Boolean = false;
      var OPTION_AfficherGriseeNoteDansVoixInactive: Boolean = true;
      var OPTION_AfficherPortees_Inactives_Grisees: Boolean = true;

      
      var MusicGraph_CouleursVoix_tabCouleursVoixFondList: array[0..1,0..NbCouleurDeVoix-1] of TColor;


      var MusicGraph_CouleursVoix_tabCouleursVoixFond: array[0..1,0..NbCouleurDeVoix-1] of TColor;

      var MusicGraph_CouleursVoix_tabCouleursVoixNonAccessibleFond: array[0..1,0..NbCouleurDeVoix-1] of TColor;

      var MusicGraph_CouleursVoix_tabCouleursVoixNote: array[0..1,0..NbCouleurDeVoix-1] of TColor;
      var MusicGraph_CouleursVoix_ModeSelection_tabCouleursVoixNote_NonSelectionnees: array[0..1,0..NbCouleurDeVoix-1] of TColor;

      var MusicGraph_CouleursVoix_tabCouleursVoixFondInactiveMaisAccessible: array[0..1,0..NbCouleurDeVoix-1] of TColor;




const CouleurNoteDansVoixInactive = $CCCCCC;
      {affichage des voix}


      LiseraieVoix_Couleur = $AAAAAA;
      LiseraieVoix_ps = psSolid;



      
Function CouleursVoixFondList(Comp: TCompositionAvecPagination; Index: integer): TColor;
Function CouleursVoixNote(Comp: TCompositionAvecPagination; Index: integer): TColor;
Function CouleursVoixFond(Comp: TCompositionAvecPagination; Index: integer): TColor;
Function CouleursVoixNonAccessibleFond(Comp: TCompositionAvecPagination; Index: integer): TColor;
Function CouleursVoixFondInactiveMaisAccessible(Comp: TCompositionAvecPagination; Index: integer): TColor;
Function CouleursVoixTrainees(Comp: TCompositionAvecPagination; Index: integer): TColor;


Function CouleurDessinVoixNote(IGP: TCompositionAvecPagination;
                               voix_num: integer;
                               voix_is_accessible: boolean): TColor;


procedure MusicGraph_CouleursVoix_CalculerTables;









implementation


uses MusicGraph_System {pour CDevice},
     MusicGraph_CouleursUser {pour CouleurStylo},
     Windows,
     MusicUser {pour MusicUser_MusicWriter_IsMode_Selection};




Function CouleursVoixFondList(Comp: TCompositionAvecPagination; Index: integer): TColor;
var iportee, inum: integer;
Begin
    if Index < 0 then
         result := clWhite
    else
    Begin
        iportee := Comp.Voix_Indice_To_Portee(Index);
        inum := Comp.Voix_Indice_To_NumVoixDansPortee(Index);

        result := MusicGraph_CouleursVoix_tabCouleursVoixFondList[iportee mod 2, inum mod NbCouleurDeVoix];
    End;
End;



Function CouleursVoixFond(Comp: TCompositionAvecPagination; Index: integer): TColor;
var iportee, inum: integer;
Begin
    if Index < 0 then
         result := clWhite
    else
    Begin
        iportee := Comp.Voix_Indice_To_Portee(Index);
        inum := Comp.Voix_Indice_To_NumVoixDansPortee(Index);

        result := MusicGraph_CouleursVoix_tabCouleursVoixFond[iportee mod 2, inum mod NbCouleurDeVoix];
    End;
End;




Function CouleursVoixTrainees(Comp: TCompositionAvecPagination; Index: integer): TColor;
const CouleurVoixTraineesVoixNonAffectee = $AAAAAA;
var iportee, inum: integer;
Begin
    if Index < 0 then
         result := CouleurVoixTraineesVoixNonAffectee
    else
    Begin
        iportee := Comp.Voix_Indice_To_Portee(Index);
        inum := Comp.Voix_Indice_To_NumVoixDansPortee(Index);

        result := MusicGraph_CouleursVoix_ModeSelection_tabCouleursVoixNote_NonSelectionnees[iportee mod 2, inum mod NbCouleurDeVoix];
    End;
End;





Function CouleursVoixFondInactiveMaisAccessible(Comp: TCompositionAvecPagination; Index: integer): TColor;
var iportee, inum: integer;
Begin
    if Index < 0 then
          result := clWhite
    else
    Begin
        iportee := Comp.Voix_Indice_To_Portee(Index);
        inum := Comp.Voix_Indice_To_NumVoixDansPortee(Index);

        result := MusicGraph_CouleursVoix_tabCouleursVoixFondInactiveMaisAccessible[iportee mod 2, inum mod NbCouleurDeVoix];
    End;
End;

Function CouleursVoixNonAccessibleFond(Comp: TCompositionAvecPagination; Index: integer): TColor;
var iportee, inum: integer;
Begin
    if Index < 0 then
          result := clWhite
    else
    Begin
        iportee := Comp.Voix_Indice_To_Portee(Index);
        inum := Comp.Voix_Indice_To_NumVoixDansPortee(Index);

        result := MusicGraph_CouleursVoix_tabCouleursVoixNonAccessibleFond[iportee mod 2, inum mod NbCouleurDeVoix];
    End;
End;



Function CouleursVoixNote(Comp: TCompositionAvecPagination; Index: integer): TColor;
var iportee, inum: integer;
Begin
    if Index < 0 then
         result := clBlack
    else
    Begin
        iportee := Comp.Voix_Indice_To_Portee(Index);
        inum := Comp.Voix_Indice_To_NumVoixDansPortee(Index);

        result := MusicGraph_CouleursVoix_tabCouleursVoixNote[abs(iportee mod 2),   abs(inum mod NbCouleurDeVoix)];
    End;
End;

Function CouleursVoixNote_ModeSelection_Notes_Deselectionnees(Comp: TCompositionAvecPagination; Index: integer): TColor;
var iportee, inum: integer;
Begin
    if Index < 0 then
         result := clBlack
    else
    Begin

        iportee := Comp.Voix_Indice_To_Portee(Index);
        inum := Comp.Voix_Indice_To_NumVoixDansPortee(Index);

        result := MusicGraph_CouleursVoix_ModeSelection_tabCouleursVoixNote_NonSelectionnees[abs(iportee mod 2),   abs(inum mod NbCouleurDeVoix)];
    End;
End;




Function CouleurDessinVoixNote(IGP: TCompositionAvecPagination; voix_num: integer; voix_is_accessible: boolean): TColor;
Begin
    if cDevice = devEcran then
    Begin
          if OPTION_AfficherCouleursNotes then
          Begin
               if MusicUser_MusicWriter_IsMode_Selection then
                      result := CouleursVoixNote_ModeSelection_Notes_Deselectionnees(IGP, voix_num)
               else
                      result := CouleursVoixNote(IGP, voix_num);
          End
          else
               result := CouleurStylo;

          if OPTION_AfficherGriseeNoteDansVoixInactive then
          Begin
               if not voix_is_accessible then
                      result := CouleurNoteDansVoixInactive;
          end;
    End
    else
          result := CouleurStylo;
End;




Function Couleur_Eclaircir(c: TColor; combien: integer): TColor;
var r, g, b: integer;
Begin
   r := GetRValue(c);
   g := GetGValue(c);
   b := GetBValue(c);

   inc(r, Round(combien * 1.2));
   inc(g, combien);
   inc(b, combien);

   if r > 255 then r := 255;
   if g > 255 then g := 255;
   if b > 255 then b := 255;

   result := RGB(r, g, b);
End;

procedure MusicGraph_CouleursVoix_CalculerTables;
var i, j: integer;
Begin
    for i := 0 to 1 do
         for j := 0 to NbCouleurDeVoix-1 do
    MusicGraph_CouleursVoix_tabCouleursVoixFondInactiveMaisAccessible[i, j] :=
           Couleur_Eclaircir(MusicGraph_CouleursVoix_tabCouleursVoixFond[i,j], 16);

    for i := 0 to 1 do
         for j := 0 to NbCouleurDeVoix-1 do
    MusicGraph_CouleursVoix_ModeSelection_tabCouleursVoixNote_NonSelectionnees[i, j] :=
           Couleur_Eclaircir(MusicGraph_CouleursVoix_tabCouleursVoixNote[i,j], 48);

End;


end.

