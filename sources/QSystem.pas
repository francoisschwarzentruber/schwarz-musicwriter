unit QSystem;

{cette unité s'occupe de fournir une interface pour manipuler des rationnels}

interface


type


TRationnel = record
          num, denom: integer;
end;

TDuree = TRationnel;
TListeRationnel = array of TRationnel;

Function QIrreductible(q:TRationnel): TRationnel;

Function ResteDivEucl(a, b: integer): integer;
Function DivDivEucl(a, b: integer): integer;

Function QToReal(q:TRationnel):real;
Function QToInt(q:TRationnel):integer;
Function RealToQ(r: real; denom: integer): TRationnel;

Function min(a, b:integer):integer;
Function max(a, b:integer):integer;
Function IsPowerOf2(i: integer): Boolean;

Function QMin(a, b: TRationnel): TRationnel;
Function QMax(a, b: TRationnel): TRationnel;

Function Qel(num, denom:integer):TRationnel; overload;
Function Qel(n:integer):TRationnel; overload;
Function QelReally(num, denom:integer):TRationnel;

Procedure QInc(var q1: TRationnel; q2: TRationnel);
Function QAdd(q1, q2: TRationnel):TRationnel;
Function QDiff(q1, q2: TRationnel):TRationnel;

Function QMul(q1, q2: TRationnel):TRationnel;  overload;
Function QMul(q1: integer; q2: TRationnel):TRationnel; overload;
Function QMul2(q1: integer; q2: TRationnel):integer;
Function QDiv(q1: TRationnel; q2: TRationnel):TRationnel;
Function QDiv2(q: TRationnel): TRationnel;

Function IsQNul(q: TRationnel): Boolean;
Function IsQ1InfQ2(q1, q2: TRationnel): Boolean;
Function IsQ1StrInfQ2(q1, q2: TRationnel): Boolean;
Function IsQEgal(q1, q2: TRationnel):Boolean;

Function IsQEgalEnviron(q1, q2: TRationnel): Boolean;

Function IsQStrNegatif(q: TRationnel): Boolean;

Function QNbQueueAUtiliser(q:TRationnel):integer;

Function QMinTab(var T:array of TRationnel):TRationnel;
Function QToStr(q:TRationnel): string;

Function CombienPointDuree(D: TDuree): integer;
Procedure GloutonPause(Duree: TRationnel; var DP: TListeRationnel);

Procedure QVerifierQPasTropBizarre(q: TRationnel; mess: string);

procedure VerifierRationnel(var q: TRationnel; mess: string);

Function QPasTropGrandDenominateur(q: TRationnel): TRationnel;

Function QFractionPlusProcheAvecDenominateurFixe(q: TRationnel; denom: integer):TRationnel;



const IntegerInfini = 32768;
      denom_max = 2096;
      QZero: TRationnel = (num:0;denom:1);
      QUn: TRationnel = (num:1;denom:1);
      QInfini: TRationnel = (num:IntegerInfini;denom:1);

implementation


uses Sysutils, math {pour sign},
      MusicWriter_Erreur;





Function QPasTropGrandDenominateur(q: TRationnel): TRationnel;

Begin
      if not ( (q.denom in [1..16]) or (q.denom in [32, 64, 128]) or (q.denom = denom_max) ) then
      Begin
          q.num := Int64(denom_max) * Int64(q.num) div Int64(q.denom);
          q.denom := denom_max;
      End;


      result := q;
End;






Procedure QVerifierQPasTropBizarre(q: TRationnel; mess: string);
const denom_max_sinon_bizarre = 15000;
Begin
    if (abs(q.num) > 10000000) or (abs(q.denom) > denom_max_sinon_bizarre) then
         MessageErreur('Rationnel trop bizarre... enfin je pense... q = '
                       + QToStr(q) + ' dans ' + mess);
End;



Function ResteDivEucl(a, b: integer): integer;
Begin
if a >= 0 then
      result := a mod b
else
      result := a mod b + b;

End;



Function DivDivEucl(a, b: integer): integer;
Begin
    if a >= 0 then
        result := a div b
    else
        result := a div b - 1;
        
End;



Function min(a, b:integer):integer;
Begin
if a < b then
      result := a
else
      result := b;

End;


Function max(a, b:integer):integer;
Begin
if a > b then
      result := a
else
      result := b;

End;



Function IsPowerOf2(i: integer): Boolean;
Begin
    result := i in [0, 1, 2, 4, 8, 16, 32, 64, 128];
End;

Function QMin(a, b: TRationnel): TRationnel;
Begin
    if IsQ1InfQ2(a, b) then
           result := a
    else
        result := b;
End;


Function QMax(a, b: TRationnel): TRationnel;
Begin
    if IsQ1InfQ2(a, b) then
           result := b
    else
        result := a;
End;



Function QToReal(q:TRationnel):real;
Begin
     result := q.num / q.denom;

End;


Function QToInt(q:TRationnel):integer;
Begin
     result := q.num div q.denom;

End;

Function pgcd(a, b:integer):integer;
var r:integer;
Begin
r := b;
while r <> 0 do
  Begin
       r := a mod b;
       a := b;
       b := r;
  end;

  result := a;
End;



Function ppcm(a, b: integer): integer;
Begin
    result := a * b div pgcd(a, b);
End;


Function QIrreductible(q:TRationnel): TRationnel;
var d:integer;
Begin
   d := pgcd(q.num, q.denom);
   q.num := q.num div d;
   q.denom := q.denom div d;
   result := q;
End;




Function Qel(num, denom:integer):TRationnel; overload;
var q:TRationnel;
Begin
    q.num := num;
    q.denom := denom;
    q := QIrreductible(q);
    result := q;
End;



Function QelReally(num, denom:integer):TRationnel;
var q:TRationnel;
Begin
    q.num := num;
    q.denom := denom;
    result := q;
End;



Function Qel(n:integer):TRationnel; overload;
var s:TRationnel;
Begin
s.num := n;
s.denom := 1;
result := s;

End;

Function QAdd(q1, q2: TRationnel):TRationnel;
var s:TRationnel;
    
Begin
      {if q1.denom = q2.denom then
      Begin
           s.denom := q1.denom;
           s.num := q1.num + q2.num;
      End
      else
      Begin
           s.denom := q1.denom * q2.denom;
           s.num := q1.num * q2.denom + q2.num * q1.denom;
      End;}

      s.denom := ppcm(q1.denom, q2.denom);
      s.num := q1.num * (s.denom div q1.denom) + q2.num * (s.denom div q2.denom);
      
      s := QIrreductible(s);
      result := s;
End;




Function QFractionPlusProcheAvecDenominateurFixe(q: TRationnel; denom: integer):TRationnel;
Begin
      result := QEl(Round(QToReal(q) * denom), denom);
End;

Procedure QInc(var q1: TRationnel; q2: TRationnel);
Begin
    q1 := QAdd(q1, q2);
End;

Function QDiff(q1, q2: TRationnel):TRationnel;
Begin
    q2.num := -q2.num;
    result := QAdd(q1, q2);
End;



Function QMul(q1, q2: TRationnel):TRationnel; overload;
var s:TRationnel;
Begin
    s.denom := q1.denom * q2.denom;
    s.num := q1.num * q2.num;
    s := QIrreductible(s);
    result := s;
End;


Function QMul(q1: integer; q2: TRationnel):TRationnel; overload;
var s:TRationnel;
Begin
      s.denom := 1 * q2.denom;
      s.num := q1 * q2.num;
      s := QPasTropGrandDenominateur(s);
      s := QIrreductible(s);
      result := s;
End;





Function QDiv(q1: TRationnel; q2: TRationnel):TRationnel;
var s: TRationnel;
Begin
      s.denom := q1.denom * q2.num;
      s.num := q1.num * q2.denom;
      s := QIrreductible(s);
      result := s;
End;

Function QMul2(q1: integer; q2: TRationnel):integer;
Begin
     result := q1 * q2.num div q2.denom;
End;



Function QDiv2(q: TRationnel): TRationnel;
Begin
    q.denom := q.denom * 2;
    q := QIrreductible(q);
    result := q;
End;



Function IsQNul(q: TRationnel): Boolean;
Begin
        result := (q.num = 0);
End;


Function IsQ1InfQ2(q1, q2: TRationnel): Boolean;
Begin

result := QToReal(q1) <= QToReal(q2);{sign(q1.num * q2.denom - q2.num * q1.denom) *
             sign(q1.denom * q2.denom) <= 0;    }

{on utilise sign pour éviter les débordements d'entiers ...
  faire 1*-1 c'est plus simple que 4564123*-789456221 :) }

End;


Function IsQ1StrInfQ2(q1, q2: TRationnel): Boolean;
Begin
      result := QToReal(q1) < QToReal(q2);
//result := (q1.num * q2.denom - q2.num * q1.denom) < 0;

End;


Function IsQEgal(q1, q2: TRationnel):Boolean;
Begin
result := (q1.num = q2.num) and (q1.denom = q2.denom);

End;




Function IsQEgalEnviron(q1, q2: TRationnel): Boolean;
Begin
    result := QToReal(q1) - QToReal(q2) < 0.05;
End;




Function IsQStrNegatif(q: TRationnel): Boolean;
Begin
     result := (q.num * q.denom < 0);
End;

Function QMinTab(var T:array of TRationnel):TRationnel;
var TMin: TRationnel;
    v: integer; 
Begin
Tmin := QInfini;
for v := 0 to high(T) do
    if IsQ1InfQ2(T[v], Tmin) then
            Tmin := T[v];

result := Tmin;
End;




Function QNbQueueAUtiliser(q:TRationnel):integer;
{donne le nombre de queue à utiliser pour représenter un el. mus. qui dure
 une durée de q

 ex : q = 1, 2, 3 : renvoie 0
      q = 1/3, 1/2, 3/4 : renvoie 1
      q = 1/4, 1/6 : renvoie 2
      q = 1/8 : renvoie 3
 }

var r:Real;
Begin
r := QToReal(q);

if IsQEgal(q, Qel(3, 8)) then
     result := 2
else
if r >= 1 then
        result := 0
else if IsQEgal(q, Qel(2, 3)) then
       result := 0
else if (0.3 < r) and (r <= 1) then
       result := 1
else if (0.125 < r) and (r < 0.3) then
       result := 2
else if (1/16 < r) and (r <= 1/8) then
       result := 3
else if (r = 0) then
      result := 2
else
       result := 4;


End;




Function QToStr(q:TRationnel): string;
Begin
    result := inttostr(q.num) + '/' + inttostr(q.denom);

End;

Function IsPuiss2(n: integer): boolean;
var p: integer;
    yab: boolean;
Begin
yab := false;
p := 1;
while (p <= n) and not yab do
Begin
      if n = p then yab := true;
      p := p * 2;
End;

result := yab;
End;


Function CombienPointDuree(D: TDuree): integer;
Begin
if IsQEgal(D, Qel(3,4)) then
       result := 1
else if IsQEgal(D, Qel(3,1)) then
       result := 1
else if IsQEgal(D, Qel(3,2)) then
       result := 1
else if IsQEgal(D, Qel(3,8)) then
       result := 1
else if IsQEgal(D, Qel(7,8)) then
       result := 2
else if IsQEgal(D, Qel(7,2)) then
       result := 2
else
       result := 0;
End;







Procedure GloutonPause(Duree: TRationnel; var DP: TListeRationnel);

var DR: TRationnel; {durée restante à une étape}
    i,j: integer;

      Procedure BoufferDR(d: TRationnel);
      Begin
          Setlength(DP, i+1);
          DP[i] := d;
          inc(i);

          d.num := -d.num;
          DR := QAdd(DR, d);
          

      End;
Begin
i := 0;
setlength(DP, 0);
DR := Duree;
while DR.num > 0 do
Begin
     if IsQ1InfQ2(Qel(4), DR) then
           BoufferDR(Qel(4))
     else if IsQ1InfQ2(Qel(3), DR) then
           BoufferDR(Qel(3))
     else if IsQ1InfQ2(Qel(2), DR) then
           BoufferDR(Qel(2))
     else if IsQ1InfQ2(Qel(3,2), DR) then
           BoufferDR(Qel(3,2))
     else if IsQ1InfQ2(Qel(1), DR) then
           BoufferDR(Qel(1))
     else if IsPuiss2(DR.denom) then
     Begin
         if IsQ1InfQ2(Qel(3,4), DR) then
               BoufferDR(Qel(3,4))
         else if IsQ1InfQ2(Qel(1,2), DR) then
               BoufferDR(Qel(1,2))
         else if IsQ1InfQ2(Qel(1,4), DR) then
               BoufferDR(Qel(1,4))
         else if IsQ1InfQ2(Qel(1,8), DR) then
               BoufferDR(Qel(1,8))
         else
               BoufferDR(DR);

     End
     else
         for j := 1 to DR.num do
               BoufferDR(Qel(1,DR.denom));




End;

End;


procedure VerifierRationnel(var q: TRationnel; mess: string);
Begin
    if q.denom = 0 then
    Begin
       MessageErreur('dénominateur nul : on le met à 1 ! ' + mess);
       q.denom := 1;
    End;
    QVerifierQPasTropBizarre(q, mess);
End;


Function RealToQ(r: real; denom: integer): TRationnel;
Begin
    result.denom := denom;
    result.num := Round(r * denom);
End;


end.
