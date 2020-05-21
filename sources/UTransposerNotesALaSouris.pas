unit UTransposerNotesALaSouris;

interface

uses MusicHarmonie;

var
    HauteurNoteRefDeplacement: THauteurNote;



    
Procedure IntervalleDeplacement_Init;
procedure IntervalleDeplacement_DeplacerUnefoisVersLeHautEnAccordAvecTonalite(tonalite: TTonalite);
procedure IntervalleDeplacement_DeplacerUnefoisVersLeBasEnAccordAvecTonalite(tonalite: TTonalite);
procedure IntervalleDeplacement_DeplacerUnefoisDUneOctaveVersLeHaut;
procedure IntervalleDeplacement_DeplacerUnefoisDUneOctaveVersLeBas;
procedure IntervalleDeplacement_FaireEnSorteQueAlterationDeLaNoteRefVaut(alteration: TAlteration);

procedure IntervalleDeplacement_Alteration_UneDePlus;
procedure IntervalleDeplacement_Alteration_UneDeMoins;

procedure IntervalleDeplacement_Definir(intervalle: TIntervalle);
procedure IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(NouvelleHauteurNoteDeLaNoteDeRef: THauteurNote);

Function IntervalleDeplacement_Get: TIntervalle;

Function IntervalleDeplacement_IsNothingToDo: boolean;




implementation


var IntervalleDeplacement: TIntervalle;



Function IntervalleDeplacement_IsNothingToDo: boolean;
Begin
     result := IsHauteursNotesEgales(IntervalleDeplacement, hn0);
End;

Function IntervalleDeplacement_Get: TIntervalle;
Begin
    result := IntervalleDeplacement;
End;



Procedure IntervalleDeplacement_Init;
Begin
    IntervalleDeplacement := hn0;
End;



Function NouvelleHauteurNoteDeLaNoteDeRef_Get: THauteurNote;
Begin
     GetHauteurNote(IntervalleDeplacement, HauteurNoteRefDeplacement, result);
End;



procedure IntervalleDeplacement_Definir(intervalle: TIntervalle);
Begin
    IntervalleDeplacement := intervalle;
End;


procedure IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(NouvelleHauteurNoteDeLaNoteDeRef: THauteurNote);
Begin
      IntervalleDeplacement := Intervalle(HauteurNoteRefDeplacement, NouvelleHauteurNoteDeLaNoteDeRef);
End;


procedure IntervalleDeplacement_RendreConformeALaTonalite(tonalite: TTonalite);
var NouvelleHauteurNoteDeLaNoteDeRef: THauteurNote;
var alterationstandard: TAlteration;
Begin
    NouvelleHauteurNoteDeLaNoteDeRef := NouvelleHauteurNoteDeLaNoteDeRef_Get;
    alterationstandard := AlterationAvecTonalite(NouvelleHauteurNoteDeLaNoteDeRef.Hauteur, tonalite);
    NouvelleHauteurNoteDeLaNoteDeRef.alteration := alterationstandard;
    IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(NouvelleHauteurNoteDeLaNoteDeRef);
End;



procedure IntervalleDeplacement_DeplacerUnefoisVersLeHautEnAccordAvecTonalite(tonalite: TTonalite);
Begin
     inc(IntervalleDeplacement.Hauteur);
     IntervalleDeplacement_RendreConformeALaTonalite(tonalite);
End;


procedure IntervalleDeplacement_DeplacerUnefoisVersLeBasEnAccordAvecTonalite(tonalite: TTonalite);
Begin
     dec(IntervalleDeplacement.Hauteur);
     IntervalleDeplacement_RendreConformeALaTonalite(tonalite);
End;


procedure IntervalleDeplacement_DeplacerUnefoisDUneOctaveVersLeHaut;
Begin
     inc(IntervalleDeplacement.Hauteur, 7);

End;

procedure IntervalleDeplacement_DeplacerUnefoisDUneOctaveVersLeBas;
Begin
     dec(IntervalleDeplacement.Hauteur, 7);

End;



procedure IntervalleDeplacement_FaireEnSorteQueAlterationDeLaNoteRefVaut(alteration: TAlteration);
var NouvelleHauteurNoteDeLaNoteDeRef: THauteurNote;
Begin
    NouvelleHauteurNoteDeLaNoteDeRef := NouvelleHauteurNoteDeLaNoteDeRef_Get;
    NouvelleHauteurNoteDeLaNoteDeRef.alteration := alteration;
    IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(NouvelleHauteurNoteDeLaNoteDeRef);
End;



procedure IntervalleDeplacement_Alteration_UneDePlus;
var NouvelleHauteurNoteDeLaNoteDeRef: THauteurNote;
Begin
    NouvelleHauteurNoteDeLaNoteDeRef := NouvelleHauteurNoteDeLaNoteDeRef_Get;
    NouvelleHauteurNoteDeLaNoteDeRef.alteration := AlterationSuivante(NouvelleHauteurNoteDeLaNoteDeRef.alteration);
    IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(NouvelleHauteurNoteDeLaNoteDeRef);
End;



procedure IntervalleDeplacement_Alteration_UneDeMoins;
var NouvelleHauteurNoteDeLaNoteDeRef: THauteurNote;
Begin
    NouvelleHauteurNoteDeLaNoteDeRef := NouvelleHauteurNoteDeLaNoteDeRef_Get;
    NouvelleHauteurNoteDeLaNoteDeRef.alteration := AlterationPrecedente(NouvelleHauteurNoteDeLaNoteDeRef.alteration);
    IntervalleDeplacement_DefinirPourQueHauteurNoteDeLaNoteRefVaut(NouvelleHauteurNoteDeLaNoteDeRef);
End;





end.
