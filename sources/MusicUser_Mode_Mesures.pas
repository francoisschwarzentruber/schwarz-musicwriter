unit MusicUser_Mode_Mesures;

interface

function Mode_Mesures_GetDebMes: integer;
function Mode_Mesures_GetFinMes: integer;
procedure Mode_Mesures_SetDebMes(m: integer);
procedure Mode_Mesures_SetFinMes(m: integer);

procedure Mode_Mesures_SassurerDesValeursDeDebMesEtFinMes;
procedure Mode_Mesures_SetDebFinMes(m1, m2: integer);




implementation

uses SysUtils//pour strtoint
     , Main, MusicUser_PlusieursDocuments, Math //pour min
     ;

function Mode_Mesures_GetDebMes: integer;
Begin

   result := strtoint(MainForm.txtMesDeb.text) - 1;

   if result < 0 then result := 0;
   if result > actchild.Composition.NbMesures-1 then
        result := actchild.Composition.NbMesures-1;
End;



function Mode_Mesures_GetFinMes: integer;
Begin
   result := strtoint(MainForm.txtMesFin.text)-1;

   if result < 0 then result := 0;
   if result > actchild.Composition.NbMesures-1 then
        result := actchild.Composition.NbMesures-1;
End;



procedure Mode_Mesures_SetDebMes(m: integer);
Begin
   actchild.Composition.VerifierIndiceMesure(m, 'SetDebMes');

   MainForm.txtMesDeb.Text := inttostr(m+1);
End;



procedure Mode_Mesures_SetFinMes(m: integer);
Begin
   actchild.Composition.VerifierIndiceMesure(m, 'SetFinMes');
   actChild.ModeSelectionMesureiFin := m;
   MainForm.txtMesFin.Text := inttostr(m+1);
End;


procedure Mode_Mesures_SassurerDesValeursDeDebMesEtFinMes;
Begin
    Mode_Mesures_SetDebMes(Mode_Mesures_GetDebMes);
    Mode_Mesures_SetFinMes(Mode_Mesures_GetFinMes);
End;



procedure Mode_Mesures_SetDebFinMes(m1, m2: integer);
Begin
    Mode_Mesures_SetDebMes(min(min(m1, m2), actchild.Composition.NbMesures - 1));
    Mode_Mesures_SetFinMes(min(max(m1, m2), actchild.Composition.NbMesures - 1) );
End;

end.
