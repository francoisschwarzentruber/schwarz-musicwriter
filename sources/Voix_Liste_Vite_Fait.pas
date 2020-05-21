unit Voix_Liste_Vite_Fait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmVoixListeViteFait = class(TForm)
    tmr: TTimer;
    lstVoix: TListBox;
    procedure lstVoixDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure tmrTimer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmVoixListeViteFait: TfrmVoixListeViteFait;









  procedure Voix_Liste_Vite_Fait_Reset;
  procedure Voix_Liste_Vite_Fait_Voix_Ajouter(iv: integer);
  procedure Voix_Liste_Vite_Fait_Voix_Show;


implementation

uses Main {actchild},
     MusicGraph {pour DrawCadrePresentationVoix},
     MusicUser_PlusieursDocuments;

{$R *.dfm}

var etat : integer = 0;
    etat1_compteur: integer = 0;

    
procedure Voix_Liste_Vite_Fait_Reset;
Begin
     if frmVoixListeViteFait = nil then
         frmVoixListeViteFait := TfrmVoixListeViteFait.Create(nil);

     frmVoixListeViteFait.lstVoix.Clear;
End;



procedure Voix_Liste_Vite_Fait_Voix_Ajouter(iv: integer);
Begin
     if frmVoixListeViteFait = nil then
         frmVoixListeViteFait := TfrmVoixListeViteFait.Create(nil);

     frmVoixListeViteFait.lstVoix.AddItem(inttostr(iv), nil);


     frmVoixListeViteFait.lstVoix.Height := frmVoixListeViteFait.lstVoix.Count * frmVoixListeViteFait.lstVoix.ItemHeight;
     frmVoixListeViteFait.Height := frmVoixListeViteFait.lstVoix.Count * frmVoixListeViteFait.lstVoix.ItemHeight;

End;


procedure Voix_Liste_Vite_Fait_Voix_Show;
Begin
    etat1_compteur := 10;
    etat := 0;
    frmVoixListeViteFait.AlphaBlendValue := 128;
    frmVoixListeViteFait.Show;
    MainForm.SetFocus;                 
    frmVoixListeViteFait.Left := MainForm.Left + MainForm.Modes_PageControl.Left
                                + MainForm.ControlBarLeft.Left 
                                + MainForm.panelVoixSelectionnee_Indicateur.Left
                                + MainForm.panVoixSelectionnee.Left + 4;

    frmVoixListeViteFait.Top := MainForm.Top + MainForm.Modes_PageControl.Top
                                + MainForm.ControlBarLeft.Top
                                + MainForm.panelVoixSelectionnee_Indicateur.Top
                                + 48;
    frmVoixListeViteFait.tmr.Interval := 200;
    frmVoixListeViteFait.tmr.Enabled := true;

End;


procedure TfrmVoixListeViteFait.lstVoixDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
    if not MusicWriter_IsFenetreDocumentCourante then exit;
    actchild.VerifierIntegrite('affichage d''un élément de la liste des voix');

    {on affiche un cadre blanc pour éviter les bugs d'affichage :
    - fond qui devient noir
    - rectangle de sélection qui reste
    }
    lstVoix.Canvas.Brush.Style := bsSolid;
    lstVoix.Canvas.Brush.Color := clWhite;
    lstVoix.Canvas.FillRect(Rect);


    DrawCadrePresentationVoix(actChild.Composition,
                              lstVoix.Canvas,
                              Rect,
                              strtoint(lstVoix.Items[Index]),1, true, true);
end;

procedure TfrmVoixListeViteFait.tmrTimer(Sender: TObject);
begin
     if etat = 0 then
     Begin
         tmr.Interval := 10;
         etat1_compteur := 20;
         etat := 1;
     End;

     if etat = 1 then
     Begin
        dec(etat1_compteur);
        Top := Top - 1;
        if etat1_compteur <= 0 then
             etat := 2;
     End;

     if etat = 2 then
     Begin
        tmr.Interval := 10;
        etat := 3;
     End

     else if etat = 3 then
     Begin
          AlphaBlendValue := AlphaBlendValue - 4;
          if AlphaBlendValue < 30 then
               etat := 4;
     End

     else if etat = 4 then
     Begin
         Hide;
         tmr.Enabled := false;
         etat := 0;
     End;
end;

end.
