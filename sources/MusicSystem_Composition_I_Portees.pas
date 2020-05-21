unit MusicSystem_Composition_I_Portees;

interface

uses MusicSystem_CompositionGestionMesure,
     MusicHarmonie {clef},
     QSystem;


type TComposition_I_Portees = class(TCompositionGestionMesure)
private
        function Portee_Clef_read(iportee: integer): TClef;
        procedure Portee_Clef_write(iportee: integer; val: TClef);

public
      property I_Portee_Clef[iportee: integer] : TClef
        read Portee_Clef_read
        write Portee_Clef_write;


      procedure I_Portee_Octavieur_Ajouter(iportee, imesure: integer; temps: TRationnel; combien: integer);
      procedure I_Portee_Octavieur_Supprimer(iportee, indice: integer);
end;

implementation

uses SysUtils {pour inttostr},
     MusicSystem {pour ClefToStr},
     Cancellation,
     MusicSystem_Octavieurs_Liste {pour OctavieurCombienToStr};


function TComposition_I_Portees.Portee_Clef_read(iportee: integer): TClef;
Begin
    result := PorteesGlobales[iportee].clef;
End;



procedure TComposition_I_Portees.Portee_Clef_write(iportee: integer; val: TClef);
Begin
    With PorteesGlobales[iportee] do
    if clef <> val then
    Begin
         Cancellation_PushMiniEtapeAAnuller_ModificationPorteeProprietesSimples(iportee);
         Cancellation_Etape_Ajouter_FinDescription('Modification de la clé en début de portée' +
                                ClefToStr(clef) + ' => ' + ClefToStr(val),
                                'portée n°' + inttostr(iportee + 1),
                                        VOIX_PAS_D_INFORMATION);

         clef := val;
    End;
End;




procedure TComposition_I_Portees.I_Portee_Octavieur_Ajouter(iportee, imesure: integer; temps: TRationnel; combien: integer);
Begin
    VerifierIndicePortee(iPortee, 'Octavieurs_Ajouter');

    CompCancellationCourant := self;
    CompCancellationiPorteeCourant := iportee;

    PorteesGlobales[iPortee].Octavieurs_Liste.I_Ajouter(iMesure, temps, combien);

    Cancellation_Etape_Ajouter_FinDescription('Ajout d''un octavieur de type '
                      + OctavieurCombienToStr(combien),
                       'portée n° '
                      + inttostr(iportee + 1)
                      + ', mesure n° '
                      + inttostr(imesure + 1),
                      VOIX_PAS_D_INFORMATION);
    
End;

procedure TComposition_I_Portees.I_Portee_Octavieur_Supprimer(iportee, indice: integer);
Begin

    CompCancellationCourant := self;
    CompCancellationiPorteeCourant := iportee;


    With PorteesGlobales[iPortee].Octavieurs_Liste do
    Begin
          With private_liste[indice] do
          Cancellation_Etape_Ajouter_FinDescription('Supression d''un octavieur de type '
                + OctavieurCombienToStr(combien),
                              ' à la portée n° '
                            + inttostr(iportee + 1)
                            + ', mesure n° '
                            + inttostr(imesure + 1),
                            VOIX_PAS_D_INFORMATION);

          I_Supprimer(indice);
    End;

End;

end.
