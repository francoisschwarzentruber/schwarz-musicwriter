unit MusicSystem_CompositionAvecRoutinesDeTraitement;

interface

uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,

     MusicSystem_Composition_Portees_Liste,
     MusicSystem_CompositionBase,
     MusicSystem_CompositionLectureMIDI,
     MusicSystem_CompositionAvecPagination,
     MusicSystem_CompositionListeObjetsGraphiques,
     Types;


type

     {types fonctionnels}
TProcedureTraitementNote = procedure(var n: TNote);
TProcedureTraitementElMusical = procedure(var el: TElMusical);
TFonctionBoolenneElMusical = function(var el: TElMusical): Boolean;
TProcedureTraitementElMusicalAvecReel = procedure(var el: TElMusical; r: real);


TCompositionAvecRoutinesDeTraitement = class(TCompositionListeObjetsGraphiques)
        procedure Traitement_Appliquer_Zone_JusquaFin(
                                            apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            f: TProcedureTraitementNote); overload;


        procedure Traitement_Appliquer_Zone(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            jusqua_imesure: integer;
                                            jusqua_temps: TRationnel;

                                            f: TProcedureTraitementNote); overload;

        procedure Traitement_Appliquer_Zone_JusquaFin(
                                            apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            f: TProcedureTraitementElMusical); overload;


        procedure Traitement_Appliquer_Zone(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            jusqua_imesure: integer;
                                            jusqua_temps: TRationnel;

                                            f: TProcedureTraitementElMusical); overload;

procedure Traitement_Appliquer_Zone(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            jusqua_imesure: integer;
                                            jusqua_temps: TRationnel;

                                            f: TProcedureTraitementElMusicalAvecReel); overload;


end;



implementation


procedure TCompositionAvecRoutinesDeTraitement.Traitement_Appliquer_Zone_JusquaFin(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            f: TProcedureTraitementNote);
Begin
      Traitement_Appliquer_Zone(apartirde_imesure, apartirde_temps, NbMesures - 1, QInfini, f);
End;



procedure TCompositionAvecRoutinesDeTraitement.Traitement_Appliquer_Zone_JusquaFin(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            f: TProcedureTraitementElMusical);
Begin
      Traitement_Appliquer_Zone(apartirde_imesure, apartirde_temps, NbMesures - 1, QInfini, f);
End;





procedure TCompositionAvecRoutinesDeTraitement.Traitement_Appliquer_Zone(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            jusqua_imesure: integer;
                                            jusqua_temps: TRationnel;

                                            f: TProcedureTraitementNote);
{applique f aux notes situés entre deux points temporels (donné via mesure + temps dans la mesure)
 (utilisé pour les nuances)}

var im, v, i, n: integer;
    traiter: boolean;
    q: TRationnel;

Begin
    for im := apartirde_imesure to jusqua_imesure do
         With GetMesure(im) do
             for v := 0 to high(Voix) do
             With Voix[v] do
             Begin
                q := Qel(0); // ou 1 ????

                for i := 0 to high(ElMusicaux) do
                With ElMusicaux[i] do
                  Begin
                      traiter := true;

                      if (im = apartirde_imesure) and (IsQ1StrInfQ2(q, apartirde_temps)) then
                         traiter := false;


                      if (im = jusqua_imesure) and (IsQ1StrInfQ2(jusqua_temps, q)) then
                         break;

                      if traiter then
                           for n := 0 to NbNotes - 1 do
                                f(Notes[n]);

                      QInc(q, ElMusicaux[i].Duree_Get);

                  End;


             End;
End;



procedure TCompositionAvecRoutinesDeTraitement.Traitement_Appliquer_Zone(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            jusqua_imesure: integer;
                                            jusqua_temps: TRationnel;

                                            f: TProcedureTraitementElMusical);

var im, v, i: integer;
    traiter: boolean;
    q: TRationnel;

Begin
    for im := apartirde_imesure to jusqua_imesure do
         With GetMesure(im) do
             for v := 0 to high(Voix) do
             With Voix[v] do
             Begin
                q := Qel(1);

                for i := 0 to high(ElMusicaux) do
                With ElMusicaux[i] do
                  Begin
                      traiter := true;
                                     
                      if (im = apartirde_imesure) and (IsQ1StrInfQ2(q, apartirde_temps)) then
                         traiter := false;

                         
                      if (im = jusqua_imesure) and (IsQ1StrInfQ2(jusqua_temps, q)) then
                         break;
                         
                      if traiter then
                          f(ElMusicaux[i]);

                      QInc(q, ElMusicaux[i].Duree_Get);

                  End;


             End;
End;




procedure TCompositionAvecRoutinesDeTraitement.Traitement_Appliquer_Zone(apartirde_imesure: integer;
                                            apartirde_temps: TRationnel;

                                            jusqua_imesure: integer;
                                            jusqua_temps: TRationnel;

                                            f: TProcedureTraitementElMusicalAvecReel);

var im, v, i: integer;
    traiter: boolean;
    q: TRationnel;

    T, TDeb, TFin, TTot: TRationnel;
Begin


        TDeb := QDiff(apartirde_temps, Qel(1));
        TFin := QDiff(jusqua_temps, Qel(1));
        
        TTot := DeltaTempsEntre(apartirde_imesure, TDeb,
                                jusqua_imesure, TFin);
                                
        T := QDiff(Qel(0), TDeb); //ie T := -TDeb !                           
    for im := apartirde_imesure to jusqua_imesure do
         With GetMesure(im) do
         Begin
             TDeb := T;
         
             for v := 0 to high(Voix) do
             With Voix[v] do
             Begin
                T := TDeb;
                q := Qel(1);

                for i := 0 to high(ElMusicaux) do
                With ElMusicaux[i] do
                  Begin
                      traiter := true;

                      if (im = apartirde_imesure) and (IsQ1StrInfQ2(q, apartirde_temps)) then
                         traiter := false;

                         
                      if (im = jusqua_imesure) and (IsQ1StrInfQ2(jusqua_temps, q)) then
                         break;

                      if traiter then
                          f(ElMusicaux[i], QToReal(QDiv(T, TTot)));

                      QInc(q, ElMusicaux[i].Duree_Get);
                      QInc(T, Duree_Get);
                  End;


             End; //Voix
             T := QAdd(TDeb, DureeTotale);   
        End;
End;

end.
