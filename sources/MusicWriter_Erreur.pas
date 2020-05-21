unit MusicWriter_Erreur;

interface

Function MusicWriter_Erreur_IsEtatErreur: Boolean;
Procedure MessageErreur(s: string);
procedure MessageErreurSiPasDeFenetreActive(mess: string);

procedure MessageErreur_Si_Negatif(v: integer; s: string);
Function PointeurMalFichu(P: Pointer): Boolean;




implementation

uses Error, Main, SysUtils {pour inttostr},
     MusicUser_PlusieursDocuments;

var etat_erreur: Boolean;





Function PointeurMalFichu(P: Pointer): Boolean;
Begin
    result := integer(P) < 512;

End;

Function MusicWriter_Erreur_IsEtatErreur: Boolean;
Begin
    result := etat_erreur;
End;



procedure MessageErreur_Si_Negatif(v: integer; s: string);
Begin
    if v < 0 then
       MessageErreur(s + ' Pour information, la valeur est ' + inttostr(v) + ' !!!');
End;

Procedure MessageErreur(s: string);

var fen: TfrmError;

    procedure AfficherErreur_Si_Pas_frmError(s: string);
    Begin
       fen := TfrmError.Create(nil);
       fen.txtMessage.Text := s;
       fen.ShowModal;
       fen.Free;
    End;

Begin

    if IgnorerMessageErreur then
           exit;

    etat_erreur := true;


    if frmError = nil then
          AfficherErreur_Si_Pas_frmError(s)
    else
    Begin
          frmError.txtMessage.Text := s;
          if not frmError.Visible then
                 frmError.ShowModal
          else
          Begin
                 AfficherErreur_Si_Pas_frmError(s)
          End;
    End;
    etat_erreur := false;
End;






procedure MessageErreurSiPasDeFenetreActive(mess: string);
Begin
     if not MusicWriter_IsFenetreDocumentCourante then
         MessageErreur('Fenêtre active à nil dans ' + mess + '.');
End;




end.
