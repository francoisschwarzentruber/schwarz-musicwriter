unit Magnetophone_Curseur_Init;

interface

uses MusicSystem_Composition, QSystem;


type TMagnetophone_Curseur = record
    Comp: TComposition;
    imesure : integer;
    temps: TRationnel;
    fini: Boolean;

end;





Function TMagnetophone_Curseur_Creer(a_Comp: TComposition; a_imesure: integer; a_temps: TRationnel): TMagnetophone_Curseur;
Function TMagnetophone_Curseur_Avancer(Curseur: TMagnetophone_Curseur; idtemps: integer):TMagnetophone_Curseur;

Function IsMagnetophoneCurseurmc1StrInfmc2(mc1, mc2: TMagnetophone_Curseur): Boolean;
Function IsMagnetophoneCurseurmc1Infmc2(mc1, mc2: TMagnetophone_Curseur): Boolean;
Function IsMagnetophoneCurseurmc1Egalmc2(mc1, mc2: TMagnetophone_Curseur): Boolean;
Function Magnetophone_Curseur_IsFini(mc: TMagnetophone_Curseur): Boolean;

implementation

uses Musicwriter_Erreur, Main, Magnetophone {pour Magnetophone_VitesseEnPourcentage_Get};


Function TMagnetophone_Curseur_Creer(a_Comp: TComposition; a_imesure: integer; a_temps: TRationnel): TMagnetophone_Curseur;
Begin
     result.Comp := a_Comp;
     result.imesure := a_imesure;
     result.temps := a_temps;
     result.fini := false;
End;


Function TMagnetophone_Curseur_Avancer(Curseur: TMagnetophone_Curseur; idtemps: integer):TMagnetophone_Curseur;
var duree_totale: TRationnel;
      Function Metronome_Get(Curseur: TMagnetophone_Curseur): integer;
      Begin
          result := Curseur.Comp.GetMesure(Curseur.imesure).Metronome div 5;
      End;
Begin
     result := Curseur;
     result.temps := QAdd(Curseur.temps, Qel(idtemps * Metronome_Get(Curseur) * Magnetophone_VitesseEnPourcentage_Get(MainForm.trkMagnetophoneVitesse.Position), 102400));

     result.temps  := QFractionPlusProcheAvecDenominateurFixe(result.temps , 102400);

     duree_totale := Curseur.Comp.GetMesure(Curseur.imesure).DureeTotale;
     if IsQ1InfQ2(duree_totale, result.temps) then
     Begin
             if Curseur.imesure = Curseur.Comp.NbMesures - 1 then
             Begin
                   result.fini := true;
                   result.temps := QAdd(duree_totale, QEl(4));
             End
             else
             Begin
                 inc(result.imesure);
                 result.temps := QDiff(result.temps, duree_totale);
             End;
     End;
     result.temps  := QFractionPlusProcheAvecDenominateurFixe(result.temps , 1024);
     If IsQStrNegatif(result.temps) then
           MessageErreur('erreur dans TMagnetophone_Curseur_Avancer : temps négatif !');


End;



Function IsMagnetophoneCurseurmc1StrInfmc2(mc1, mc2: TMagnetophone_Curseur): Boolean;
Begin
         result := (mc1.imesure < mc2.imesure) or
                    ((mc1.imesure = mc2.imesure) and IsQ1StrInfQ2(mc1.temps, mc2.temps) );
End;

Function IsMagnetophoneCurseurmc1Infmc2(mc1, mc2: TMagnetophone_Curseur): Boolean;
Begin
         result := (mc1.imesure < mc2.imesure) or
                    ((mc1.imesure = mc2.imesure) and IsQ1InfQ2(mc1.temps, mc2.temps) );
End;

Function IsMagnetophoneCurseurmc1Egalmc2(mc1, mc2: TMagnetophone_Curseur): Boolean;
Begin
       result := (mc1.imesure = mc2.imesure) and IsQEgal(mc1.temps, mc2.temps) ;
End;


Function Magnetophone_Curseur_IsFini(mc: TMagnetophone_Curseur): Boolean;
Begin
    result := ((mc.Comp.Is_Mesure_Indice_MesureAAjouter(mc.imesure)) or mc.fini);
End;

end.
 