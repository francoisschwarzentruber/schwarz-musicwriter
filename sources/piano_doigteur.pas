unit piano_doigteur;

interface

uses MusicSystem_Composition;


Procedure Piano_Doigteur_Doigter(Composition: TComposition);



implementation

uses MusicSystem_ElMusical_Liste_Notes;


Procedure Piano_Doigteur_Doigter(Composition: TComposition);
var m, i, v, n: integer;

Begin
    With Composition do
    for m := 0 to NbMesures - 1 do
        With GetMesure(m) do
             for v := 0 To High(Voix) do
             With Voix[v] do
                  for i := 0 to NbElMusicaux - 1 do
                       with ElMusicaux[i] do
                          if Not IsSilence then
                          Begin
                              if NbNotes = 1 then
                                  Notes[0].piano_doigtee := 1
                              else
                                  for n := 0 to NbNotes- 1 do
                                      Notes[n].piano_doigtee := 1 + 4*(n) div (NbNotes - 1);
                          End;

                               
End;




end.
