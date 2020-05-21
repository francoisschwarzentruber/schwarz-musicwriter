unit QSystem_Inference;

interface

uses QSystem;



type TRationnelChoix = record
                                q: TRationnel;
                                note: real;
                       end;



const nb_rationnel_choix = 3;

type TRationnelChoixs = array[1..nb_rationnel_choix] of TRationnelChoix;


Function QTrouverFractionSimpleProche(q: TRationnel): TRationnelChoixs;

Function RationnelChoixs_MeilleurChoix_Extraire(qc: TRationnelChoixs): TRationnel;
Function RationnelChoixs_IsInference_Vraiment_Reussie(qc: TRationnelChoixs): Boolean;






implementation


uses Math {pour ln};




Function RationnelChoixs_MeilleurChoix_Extraire(qc: TRationnelChoixs): TRationnel;
Begin
     result := qc[1].q;
End;



Function RationnelChoixs_IsInference_Vraiment_Reussie(qc: TRationnelChoixs): Boolean;
Begin
    result := qc[1].note < 0.05;
End;


Function QTrouverFractionSimpleProche(q: TRationnel): TRationnelChoixs;

    procedure Result_Init;
    var i : integer;
    Begin
         for i := 1 to nb_rationnel_choix do
         With result[i] do
         Begin
               q := QZero;
               note := 10000; //infini
         end;
         
    End;



    procedure Result_Inserer(nv_q: TRationnel; nv_note: Real);
    var i, j: integer;
    Begin
           for i := 1 to nb_rationnel_choix do
                  if result[i].note > nv_note then
                       break;

           for j := nb_rationnel_choix downto i+1 do
                 result[j] := result[j-1];

           if i <= nb_rationnel_choix then
           With result[i] do
           Begin
               q := nv_q;
               note := nv_note;
           End;
    End;


    Function penalite_intrinseque_rationnel_modele(qq: TRationnel): real;
    const epsilon = 1.34;

    Function poids_num(n: integer): integer;
    Begin
        case n of
            0: result := 1;
            1: result := 0;
            3: result := 2;
            else result := 4;
        end;
    End;

    Function poids_denom(d: integer): integer;
    Begin
       case d of
             1, 2, 4, 8, 16: result := 0;
             3, 6: result := 1;
             5: result := 3;
             else result := 6;
       end;
    End;

    Begin
         result := epsilon * (poids_num(qq.num) + poids_denom(qq.denom));
    End;

    procedure Tenter(qq: TRationnel);
    var nouvelle_note: real;
    
    Begin
        nouvelle_note := abs((QToReal(qq) - QToReal(q)) / QToReal(q)) * (1 + penalite_intrinseque_rationnel_modele(qq));
        Result_Inserer(qq, nouvelle_note);
    End;



    procedure TenterClassesDurees(q_classe: TRationnel);
    {exemple : si q_classe, on essaie de matcher la durée q passée en paramètre
                à QTrouverFractionSimpleProche avec q_classe, q_classe div 2,
                 q_classe div 4, etc.}
    var qq: TRationnel;
        i: integer;
    Begin

       qq := q_classe;

       for i := 0 to 6 do
       Begin
            Tenter(qq);
            qq := QDiv2(qq);
       End;

   End;    

Begin
       Result_Init;

       if IsQNul(q) then
       Begin
           Result_Inserer(QZero, 0);
           Exit;
       End;

       Tenter(Qel(0));
       TenterClassesDurees(Qel(4));
       TenterClassesDurees(Qel(3));
       TenterClassesDurees(Qel(1, 3));

End;                      


end.
 