unit MusicSystem_CompositionBaseAvecClef;


interface

uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,
     MusicSystem_Composition_Avec_Paroles;


type

TCompositionBaseAvecClef = class(TCompositionAvecParoles)
protected
    Function Octavieurs_Detecter(iPortee: integer; iMesure: integer; aTemps: TDuree): integer;
    
public
    Function Clefs_Detecter(iPortee, iMesure:integer; aTemps: TDuree): TClef;
    Function InfoClef_Detecter(iPortee: integer; iMesure: integer; aTemps: TDuree): TInfoClef;
end;


implementation

uses MusicSystem_Octavieurs_Liste;




Function TCompositionBaseAvecClef.InfoClef_Detecter(iPortee: integer; iMesure: integer; aTemps: TDuree): TInfoClef;
var clef: TClef;
Begin
    clef := Clefs_Detecter(iPortee, iMesure, aTemps);

    result := ClefToInfoClef(clef) + 7*Octavieurs_Detecter(iPortee, iMesure, aTemps);

End;


Function TCompositionBaseAvecClef.Clefs_Detecter(iPortee, iMesure:integer; aTemps: TDuree): TClef;
{d�tecte la clef courante qu'il y a en la mesure iMesure, sur la port�e iPortee,
 au temps aTemps. Evidement, ce calcul tient compte des clefs ins�r�es...

 -> En sachant la cl� qu'il y a � un endroit, on peut calculer la position
    graphique d'une note en fonction de sa hauteur sonore via HauteurAbsToClef

    De m�me, connaissant la position graphique (du curseur par exemple), on peut
    retrouver via HauteurClefToAbs, la hauteur sonore}

var m, k: integer;
Begin
//pr�conditions
      VerifierIndicePortee(iPortee, 'DetecterClef');


    if iMesure > high(Mesures) then
    {il y a ^m clef dans une mesure future,
          que tout � la fin de la derni�re mesure
    --> on s'est ramen� au cas o� l'indice de mesures est valide}
    Begin
           iMesure := high(Mesures);
           aTemps := QInfini;
    end;

    {on essaie de d�tecter la cl� via une �ventuelle cl� ins�r�e sur la port�e
     iPortee dans la mesure courante jusqu'au d�but du document}
    for m := iMesure downto 0 do
    Begin
         for k := high(Mesures[m].ClefsInserees) downto 0 do
                with Mesures[m].ClefsInserees[k] do
                      if (portee = iportee) and (IsQ1InfQ2(temps, atemps)) then
                               Begin
                                   result := Clef;
                                   Exit;
                               End;

                 aTemps := QInfini;

    End;

    {aucune clef ins�r�e n'a �t� trouv�, c'est donc que la cl� courante est
     tout simplement la clef de port�e}
    result := PorteesGlobales[iPortee].Clef;

End;







Function TCompositionBaseAvecClef.Octavieurs_Detecter(iPortee: integer; iMesure: integer; aTemps: TDuree): integer;
Begin
    VerifierIndicePortee(iPortee, 'Octavieurs_Ajouter');

    result := PorteesGlobales[iPortee].Octavieurs_Liste.DonnerCombien(iMesure, aTemps);
End;

end.
