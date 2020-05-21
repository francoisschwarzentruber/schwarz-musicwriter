unit MusicSystem_Octavieurs_Liste;

interface

uses QSystem;



type

TOctavieur = record
    imesure: integer;
    temps: TRationnel;

    pixx: integer;

    combien: integer;
    

end;

TOctavieurs_Liste = class(TObject)
public
     private_liste : array of TOctavieur;

private
     procedure I_private_FusionnerInfoRedondante;

public
     Function Ajouter(aimesure: integer; atemps: TRationnel; combien: integer): integer;

     procedure Supprimer(indice : integer);

     procedure I_Ajouter(aimesure: integer; atemps: TRationnel; combien: integer);

     procedure I_Supprimer(indice : integer);

     Function DonnerCombien(aimesure: integer; atemps: TRationnel): integer;
     procedure RenommerNumerosMesures(apartirde, quoiajouter: integer);

     Function GetIndice(m: integer; x: integer): integer;
     
     procedure SaveOrLoad;

end;



Function OctavieurCombienToStr(combien: integer): string;



implementation

uses FileSystem,
     Cancellation,
     MusicWriter_Erreur;


Function OctavieurCombienToStr(combien: integer): string;
Begin
     case combien of
         0: result := 'normal';
         1: result := '8';
         -1: result := 'Ova';
         else MessageErreur('Problème dans OctavieurCombienToStr');
     End;
End;




Function TOctavieurs_Liste.GetIndice(m: integer; x: integer): integer;
var i, h: integer;

Begin
    result := -1;
    
    h := high(private_liste);
    for i := 0 to h do
    With private_liste[i] do
        if (imesure = m) and (pixx - 100 <= x) and (x <= pixx + 200) then
        Begin
            result := i;
            break;
        End;

End;



procedure TOctavieurs_Liste.I_private_FusionnerInfoRedondante;
var i: integer;

Begin
    i := high(private_liste);

    while i > 0 do
    Begin
         if private_liste[i-1].combien =  private_liste[i].combien then
               I_Supprimer(i);
         dec(i);
    End;           
    

End;


procedure TOctavieurs_Liste.Supprimer(indice : integer);
var s: integer;
Begin
     for s := indice to high(private_liste)-1 do
              private_liste[s] := private_liste[s+1];

     setlength(private_liste, high(private_liste) );
End;



procedure TOctavieurs_Liste.I_Supprimer(indice : integer);
var s: integer;
Begin
     CompCancellationCourant.Cancellation_PushMiniEtapeAAnnuler_Octavieurs_Supprimer
                 (CompCancellationiPorteeCourant,
                  private_liste[indice].imesure,
                  private_liste[indice].temps,
                  private_liste[indice].combien,
                  indice);


     Supprimer(indice);
End;


     
Function TOctavieurs_Liste.Ajouter(aimesure: integer; atemps: TRationnel; combien: integer): integer;
var h, i, s : integer;

Begin
      h := high(private_liste);

      if h = -1 then
      Begin
             i := 0;
      end else
              for i := 0 to h do
                     if (aimesure < private_liste[i].imesure) or
                        ((aimesure = private_liste[i].imesure) and
                        IsQ1InfQ2(aTemps, private_liste[i].Temps)) then
                     Begin
                            if (aimesure = private_liste[i].imesure) and
                               (IsQEgal(aTemps, private_liste[i].Temps)) then
                                         {si on trouve une clef au même endroit,
                                          on en profite}
                                       Begin
                                           private_liste[i].combien := combien;
                                           Exit;
                                       End;


                            break;

                     end;

      setlength(private_liste, length(private_liste) + 1);

      for s := high(private_liste) downto i+1 do
              private_liste[s] := private_liste[s-1];

      private_liste[i].combien := combien;
      private_liste[i].imesure := aimesure;
      private_liste[i].Temps := aTemps;

      result := i;
      
End;




procedure TOctavieurs_Liste.I_Ajouter(aimesure: integer; atemps: TRationnel; combien: integer);
var indice: integer;
Begin
    indice := Ajouter(aimesure, atemps, combien);

    CompCancellationCourant.Cancellation_PushMiniEtapeAAnnuler_Octavieurs_Ajouter
      (CompCancellationiPorteeCourant, aimesure, atemps, combien, indice);

    I_private_FusionnerInfoRedondante;
End;


Function TOctavieurs_Liste.DonnerCombien(aimesure: integer; atemps: TRationnel): integer;
var k: integer;
Begin


         for k := high(private_liste) downto 0 do
                with private_liste[k] do
                      if (imesure < aimesure) or
                          ((imesure = aimesure) and
                           IsQ1InfQ2(temps, atemps)) then
                               Begin
                                   result := combien;
                                   Exit;
                               End;



    result := 0;


End;



procedure TOctavieurs_Liste.RenommerNumerosMesures(apartirde, quoiajouter: integer);

    procedure RenommerMesure(var m: integer);
    Begin
         if m >= apartirde then
             inc(m, quoiajouter);
    End;

    var k: integer;

Begin
     for k := high(private_liste) downto 0 do
          RenommerMesure(private_liste[k].imesure);
End;



procedure TOctavieurs_Liste.SaveOrLoad;
var l, i: integer;

Begin
    FichierDoInt(l, length(private_liste));

    if EnLecture then
           Setlength(private_liste, l);

    for i := 0 to high(private_liste) do
          FichierDo(private_liste[i], SizeOf(TOctavieur) );
           
End;


end.
