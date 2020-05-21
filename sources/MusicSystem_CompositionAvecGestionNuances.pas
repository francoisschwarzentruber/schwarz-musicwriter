unit MusicSystem_CompositionAvecGestionNuances;

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
     MusicSystem_CompositionAvecRoutinesDeTraitement,
     Types;



type




     TCompositionAvecGestionNuances = class(TCompositionAvecRoutinesDeTraitement)
     public
        procedure NuancesMIDI_Calculer;
        
end;



implementation

var private_velocite_valeur, private_velocite_valeur_2 : integer;


procedure private_traitement_appliquer_velocite(var el: TElmusical);
Begin
     el.attributs.volume := private_velocite_valeur;
End;


procedure private_traitement_appliquer_cresc(var el: TElMusical; r : real);
Begin
     el.attributs.volume := Round(private_velocite_valeur * (1 - r) + private_velocite_valeur_2 * r);
End;



procedure TCompositionAvecGestionNuances.NuancesMIDI_Calculer;
      procedure SetVelocity(velo: integer;
                            apartirde_imesure: integer;
                            apartirde_temps: TRationnel);
      Begin

      End;

    const velocite_pardefaut = 100;
    var i: integer;
    
Begin

    private_velocite_valeur := velocite_pardefaut;

    Traitement_Appliquer_Zone_JusquaFin(0,
                                        Qel(0),
                                        private_traitement_appliquer_velocite);

                                               
    for i := 0 to NbObjetsGraphiques - 1 do
      With ObjetGraphique_Get(i) do
      If IsNuanceSimple then 
      Begin
           private_velocite_valeur := velocity_depart;

           Traitement_Appliquer_Zone_JusquaFin(Pts[0].imesure,
                                               Pts[0].temps,
                                               private_traitement_appliquer_velocite);

      End;


    for i := 0 to NbObjetsGraphiques - 1 do
      With ObjetGraphique_Get(i) do
      if IsCrescendoOrDecrescendo then
      Begin
           private_velocite_valeur := velocity_depart;
           private_velocite_valeur_2 := velocity_fin;

           Traitement_Appliquer_Zone(Pts[0].imesure,
                                     Pts[0].temps,
                                     Pts[1].imesure,
                                     Pts[1].temps,
                                     private_traitement_appliquer_cresc);
      
      End;
      
End;



end.
 