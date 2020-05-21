unit MusicSystem_MesureBase;


interface

uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Types,
     MusicHarmonie;


type

     TMesureBase = class(TObject)
      public // à mettre en protected
         Voix: array of TVoix;

      public
        Rythme: TRationnel;

         Function NbTempsEscomptes: TRationnel;
       {renvoie le nombre de temps qu'il y a dans une mesure
 ex : une mesure où Rythme = (4, 4) renvoie (4, 1)
      une mesure où Rythme = (6, 8) renvoie (3, 1)}

       Function IsDureePasDeDureeApproximativeAvant(tfin: TRationnel): Boolean;
       Function MesureQuiDeborde: Boolean;
       {renvoie vrai si une des voix contient trop de notes !}


       Function DureeTotale: TRationnel;
       Procedure CalculerALarracheLeRythme;

       

       Function VoixNum(num: integer): TVoix;
       Function VoixNumInd(num: integer): integer;
       Function IsVoixNumPresente(num: integer): Boolean;


       Procedure Nettoyer;

       
       Function NvIndiceVoix(nbportees, PourPortee: integer):integer;

       Function GetNbNotes: integer;


       procedure Vider;
       Function IsVide: Boolean;

      private
         Procedure DelVoix(indv: integer);

         
     End;


implementation



Function TMesureBase.NbTempsEscomptes: TRationnel;
{renvoie le nombre de temps qu'il y a dans une mesure
 ex : une mesure où Rythme = (4, 4) renvoie (4, 1)
      une mesure où Rythme = (6, 8) renvoie (3, 1)}

Begin
    result := QMul(4, Rythme);
End;


Function TMesureBase.IsDureePasDeDureeApproximativeAvant(tfin: TRationnel): Boolean;
var iv, iel: integer;
    duree_dans_voix_depuis_debut: TRationnel;
Begin
   result := true;
   for iv := 0 to high(Voix) do
     with Voix[iv] do
     Begin
          duree_dans_voix_depuis_debut := QZero;
          for iel := 0 to high(Elmusicaux) do
          Begin
                 if ElMusicaux[iel].Duree_IsApproximative then
                 Begin
                     result := false;
                     exit;
                 End;
                 duree_dans_voix_depuis_debut := QAdd(duree_dans_voix_depuis_debut, ElMusicaux[iel].Duree_Get);

                 if IsQ1InfQ2(tfin, duree_dans_voix_depuis_debut) then
                        break;
          End;
     End;
End;

Function TMesureBase.MesureQuiDeborde: Boolean;
Begin
    result := IsQ1StrInfQ2(NbTempsEscomptes, DureeTotale) and IsDureePasDeDureeApproximativeAvant(NbTempsEscomptes);

End;





Function TMesureBase.VoixNum(num: integer): TVoix;
{retourne la voix de numéro num.
 Si elle n'existe pas physiquement dans la mesure, on la crée}

var i:integer;

Begin
    i := VoixNumInd(num);
    if i > -1 then
            result := Voix[i]
    else
    Begin
        i := length(Voix);
        setlength(Voix, i+1);
        Voix[i] := TVoix.Create;
        Voix[i].N_Voix := num;

        result := Voix[i];
    End;
End;


Function TMesureBase.IsVoixNumPresente(num: integer): Boolean;
{renvoie vrai si il existe une voix de numéro num dans la mesure}
Begin
   result := not VoixNum(num).IsVide;

End;


Function TMesureBase.NvIndiceVoix(nbportees, PourPortee: integer):integer;
var i, v:integer;
    yab: boolean;
Begin
    for i := 0 to nbmaxvoixparportees-1 do
           Begin
               result := PourPortee + i * nbportees;

               yab := true;
               for v := 0 to high(Voix) do
                        if (Voix[v].N_Voix = result) then
                        Begin
                                 if length(Voix[v].ElMusicaux) > 0 then
                                           yab := false;
                                 Break;
                        End;

               if yab = true then
               {si la voix n° result n'existe pas, result fait un bon nouvel indice}
                   Break;

           End;
End;





Function TMesureBase.VoixNumInd(num: integer): integer;
var i:integer;
Begin
      result := -1;

      for i := 0 to high(Voix) do
            if Voix[i].N_Voix = num then
            Begin
                result := i;
                Exit;
            End;
End;


Procedure TMesureBase.CalculerALarracheLeRythme;
Begin
    Rythme := QMul(DureeTotale, Qel(1, 4));
End;




Function TMesureBase.DureeTotale: TRationnel;
{renvoit le nombre de temps qu'il y a dans la mesure
ex: un 6/8 bien rempli --> renvoit 3}
var v: integer;
    r, rmax: TRationnel;

Begin
      rmax := QZero;
      For v := 0 to high(Voix) do
      Begin
          r := Voix[v].DureeTotale;
          if IsQ1InfQ2(rmax, r) then
                rmax := r;

      End;
      result := rmax;

End;


Function TMesureBase.IsVide: Boolean;
{renvoit vrai si la mesure est vraiment vide
 (on regarde également les voix non affichées...)}
var v: integer;
Begin
      result := true;

      v := 0;
      while (v <= high(Voix)) and result do
      Begin
             result := Voix[v].IsVide;
             inc(v);
      End;


End;



Procedure TMesureBase.DelVoix(indv: integer);
var i: integer;

Begin

      For i := indv to high(Voix) -1 do
               Voix[i] := Voix[i+1];

      Setlength(Voix, high(Voix));

End;


Function TMesureBase.GetNbNotes: integer;
var s, v: integer;
Begin
    s := 0;
    
    for v := 0 to high(Voix) do
          inc(s, Voix[v].GetNbNotes);

    result := s;
End;




Procedure TMesureBase.Nettoyer;
{supprime les objets TVoix inutiles de la mesure courante}

var v: integer;

Begin

      v := 0;

      while v <= high(Voix) do
      Begin
          if Voix[v] = nil then
               DelVoix(v)
          else if Voix[v].IsVide then
          Begin
               Voix[v].Free;
               DelVoix(v);
          end
          else
               inc(v);


      End;


End;




procedure TMesureBase.Vider;
var v: integer;
Begin
     for v := 0 to high(Voix) do
          Voix[v].Free;

     Finalize(Voix);
End;

end.
