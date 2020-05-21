unit DureeCourante_Gestion;

{Unité : DureeCourante_Gestion
 Fonction : gérer l'état du système de durée courante)
 Auteur : François Schwarzentruber}

interface


uses QSystem;

procedure DureeCourante_Boucle;
procedure DureeCourante_SetSub(q: TRationnel);

procedure DureeCourante_SetNumSeulementPourLInstant(num: integer);
procedure DureeCourante_Set(q: TRationnel);
procedure DureeCourante_Indefini_Set;

function DureeCourante_Get: TRationnel;


procedure DureeCourante_ModificationDureeClavierDansfrmDuree_Begin;
procedure DureeCourante_ModificationDureeClavierDansfrmDuree_End;







implementation

uses Main, UModeles, Duree,
     SysUtils {pour inttostr},
     ComCtrls {pour le type TToolButton};


var DureeSelectionnee: TRationnel;
    private_modifier_txtDureeNum: boolean;


procedure DureeCourante_SetSub(q: TRationnel);
Begin
     q := QIrreductible(q);
     MainForm.frameEcrireDureeChoix.Duree_Set(q);
     DureeSelectionnee := q;
End;



procedure DureeCourante_Set(q: TRationnel);
Begin
   DureeCourante_SetSub(q);
   DureeCourante_Boucle;
End;


procedure DureeCourante_Indefini_Set;
Begin
    MainForm.frameEcrireDureeChoix.Duree_SetIndefini;

End;


procedure DureeCourante_SetNumSeulementPourLInstant(num: integer);
Begin
     MainForm.frameEcrireDureeChoix.Duree_SetNumSeulementPourLinstant(num);
     DureeSelectionnee := QEl(num);
     DureeCourante_Boucle;
End;






procedure DureeCourante_Boucle;






Begin

    CalcRythmes;
    CalcModeles;

    


    if frmDuree <> nil then
    Begin
        if private_modifier_txtDureeNum then
        Begin
            frmDuree.txtDureeNum.text := inttostr(DureeSelectionnee.num);
            frmDuree.txtDureeDenom.text := inttostr(DureeSelectionnee.denom);
        End;
    End;
End;


function DureeCourante_Get: TRationnel;
Begin
    result := DureeSelectionnee;
End;

procedure DureeCourante_ModificationDureeClavierDansfrmDuree_Begin;
Begin
    private_modifier_txtDureeNum := false;
End;


procedure DureeCourante_ModificationDureeClavierDansfrmDuree_End;
Begin
    private_modifier_txtDureeNum := true;
End;


end.
