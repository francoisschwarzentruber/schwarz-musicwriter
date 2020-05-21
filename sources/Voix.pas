unit Voix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Menus, ComCtrls, ToolWin, ExtCtrls,
  frame_Composition_Instruments;






                                 
type
  TfrmVoix = class(TForm)
    lstVoix: TListBox;
    BitBtn1: TBitBtn;
    PopupMenu: TPopupMenu;
    Voixsolo1: TMenuItem;
    Portesolo1: TMenuItem;
    N1: TMenuItem;
    Entendrelavox1: TMenuItem;
    Entendrelaporte1: TMenuItem;
    N2: TMenuItem;
    Chutlavoix1: TMenuItem;
    Chutlaporte1: TMenuItem;
    N3: TMenuItem;
    Voirlavoix1: TMenuItem;
    Voirlaporte1: TMenuItem;
    N4: TMenuItem;
    Cacherlavoix1: TMenuItem;
    Cacherlaporte1: TMenuItem;
    N5: TMenuItem;
    Voirtout1: TMenuItem;
    N6: TMenuItem;
    Entendretout1: TMenuItem;
    ToolBar1: TToolBar;
    tbnVoixAutomatique: TToolButton;
    tbnNvVoix: TToolButton;
    lblVoix: TLabel;
    cmdAllerDansLaVoix: TBitBtn;
    Panel1: TPanel;
    lblInfo: TLabel;
    panVoixSelectionnee: TPaintBox;
    frameComposition_Instruments: TframeComposition_Instruments;
    Label2: TLabel;
    ToolButton1: TToolButton;
    procedure FormActivate(Sender: TObject);
    procedure lstVoixDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstVoixMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Voixsolo1Click(Sender: TObject);
    procedure tbnVoixAutomatiqueClick(Sender: TObject);
    procedure tbnNvVoixClick(Sender: TObject);
    procedure cmdAllerDansLaVoixClick(Sender: TObject);
    procedure lstVoixDblClick(Sender: TObject);
    procedure panVoixSelectionneePaint(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
     procedure Liste_Voix_MettreAJour;
    { Déclarations privées }
  public
    Function GetVoixSelectionneeDansLaListe: integer;
    { Déclarations publiques }
  end;

  Procedure frmVoix_Afficher;

  
var
  frmVoix: TfrmVoix;


const nbvoixparportee = 4; //par convention c'est le max















implementation

uses Main, MusicSystem_Composition, MusicSystem_Voix, MusicGraph, MusicUser, Voix_Gestion,
  Paroles, Message_Vite_Fait, langues,     MusicUser_PlusieursDocuments;





{$R *.dfm}




Procedure frmVoix_Afficher;
Begin
    if frmVoix = nil then
         frmVoix := TfrmVoix.Create(nil);

    frmVoix.Show;
End;




procedure TfrmVoix.FormActivate(Sender: TObject);
begin
      if not MusicWriter_IsFenetreDocumentCourante then
      Begin
           lstVoix.Clear;
           frameComposition_Instruments.MettreAJour;
      End
      else
      Begin
           actchild.VerifierIntegrite('activation de la fenêtre de voix');
           
           frameComposition_Instruments.MettreAJour;
            Liste_Voix_MettreAJour;
      End;

end;









procedure TfrmVoix.lstVoixDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);

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
                              strtoint(lstVoix.Items[Index]),0, true, true);




end;



Function TfrmVoix.GetVoixSelectionneeDansLaListe: integer;
Begin
     if lstVoix.ItemIndex = -1 then
          result := -1
     else
          result := strtoint(lstVoix.Items[lstVoix.ItemIndex]);
End;


procedure TfrmVoix.lstVoixMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const largeurcase = 16;
var n_voix: integer;
begin
      if lstVoix.ItemIndex = -1 then exit;
      n_voix := strtoint(lstVoix.Items[lstVoix.ItemIndex]);
      if X > lstVoix.ClientWidth - largeurcase then
          actchild.View.VoixEntendue[n_voix] := not actchild.View.VoixEntendue[n_voix]
      else if X > lstVoix.ClientWidth - 2*largeurcase then
      {dis on clique pour dire si oui ou non, on voit une voix}
      Begin
          actchild.View.VoixAffichee[n_voix] := not actchild.View.VoixAffichee[n_voix];

          {pour éviter qu'on puisse écrire dans une voix qui n'est pas affiché}
          if actchild.Curseur.GetiVoixSelectionnee = n_voix then
               Voix_Gestion_ModeAutomatique_Set(true);

          actChild.Composition.CalcTout(true);
          actChild.ReaffichageComplet;
      End;

      lstVoix.Repaint;
end;

procedure TfrmVoix.FormResize(Sender: TObject);
begin
lstVoix.Repaint;
end;

procedure TfrmVoix.FormCreate(Sender: TObject);
begin
   Langues_TraduireFenetre(self);
   ToolBar1.Images := MainForm.imgList;
   lstVoix.DoubleBuffered := true;
   frameComposition_Instruments.OnChange := Liste_Voix_MettreAJour;
end;

procedure TfrmVoix.Voixsolo1Click(Sender: TObject);
var num_voix, nbvoix, v: integer;
    num_portee, nbPortees: integer;

begin
if not MusicWriter_IsFenetreDocumentCourante then exit;
actchild.VerifierIntegrite('voix solo');
nbvoix := lstVoix.Count;
nbPortees := lstVoix.Count div nbmaxvoixparportees;

num_voix := strtoint(lstVoix.Items[lstVoix.ItemIndex]);
num_portee := num_voix mod nbPortees;
case TMenuItem(Sender).Tag of
    0: Begin
            For v := 0 to nbvoix-1 do
                 actchild.View.VoixEntendue[v] := false;
            actchild.View.VoixEntendue[num_voix] := true;
       End;

    1: Begin
            For v := 0 to nbvoix-1 do
                 actchild.View.VoixEntendue[v] := false;

            for v := 0 to nbmaxvoixparportees-1 do
                actchild.View.VoixEntendue[num_portee + v*nbPortees] := true;
       End;

    2: actchild.View.VoixEntendue[num_voix] := true;

    3: Begin
            for v := 0 to nbmaxvoixparportees-1 do
                actchild.View.VoixEntendue[num_portee + v*nbPortees] := true;
       End;

    4: //chut! la voix
           actchild.View.VoixEntendue[num_voix] := false;

    5: //chut! la portée
       Begin
            for v := 0 to nbmaxvoixparportees-1 do
                actchild.View.VoixEntendue[num_portee + v*nbPortees] := true;
       End;

    6: //voir la voix
           actchild.View.VoixAffichee[num_voix] := true;

    7: //voir la portée
       Begin
            for v := 0 to nbmaxvoixparportees-1 do
                actchild.View.VoixAffichee[num_portee + v*nbPortees] := true;
       End;

    8: //cacher la voix
           actchild.View.VoixAffichee[num_voix] := false;

    9: //cacher la portée
       Begin
            for v := 0 to nbmaxvoixparportees-1 do
                actchild.View.VoixAffichee[num_portee + v*nbPortees] := false;
       End;

    10: //entendre tout
        For v := 0 to nbvoix-1 do
                 actchild.View.VoixEntendue[v] := true;

    11: //voir tout
        For v := 0 to nbvoix-1 do
                 actchild.View.VoixAffichee[v] := true;

end;

    actChild.Composition.CalcTout(true);
    actChild.ReaffichageComplet;

lstVoix.Repaint;
end;

procedure TfrmVoix.tbnVoixAutomatiqueClick(Sender: TObject);
begin
     Voix_Gestion_ModeAutomatique_Set(tbnVoixAutomatique.Down);
end;

procedure TfrmVoix.tbnNvVoixClick(Sender: TObject);
begin
       Voix_Gestion_ModeNouvelleVoix_Set;
end;



procedure TfrmVoix.Liste_Voix_MettreAJour;
var p1, p2: integer;
Begin
   lstVoix.Clear;
   frameComposition_Instruments.GetPortees(p1, p2);

   lblVoix.Caption := 'Liste des voix ' + frameComposition_Instruments.GetPortees_To_Str;

    actChild.Composition.I_Instruments_VoixListe_TString(p1, lstVoix.Items);

End;


procedure TfrmVoix.cmdAllerDansLaVoixClick(Sender: TObject);
begin
    if not MusicWriter_IsFenetreDocumentCourante then exit;

    actchild.VerifierIntegrite('j''ai double-cliqué sur un élément voix');

    Voix_Gestion_ModeAutomatique_Set(false);
    actchild.VoixSelectionnee_Changer(strtoint(lstVoix.Items[lstVoix.ItemIndex]));
    MainForm.SetFocus;
    actchild.SetFocus;
end;

procedure TfrmVoix.lstVoixDblClick(Sender: TObject);
begin
    cmdAllerDansLaVoixClick(nil);
end;

procedure TfrmVoix.panVoixSelectionneePaint(Sender: TObject);
begin
    if not MusicWriter_IsFenetreDocumentCourante then exit;

    actchild.VerifierIntegrite('Dessin du truc de sélection de voix');

    if Voix_Gestion_IsModeAutomatique then
       panVoixSelectionnee.Font.Style := [fsItalic]
    else
       panVoixSelectionnee.Font.Style := [fsBold];

    DrawCadrePresentationVoix(actChild.Composition, panVoixSelectionnee.Canvas,
                              Rect(0,0,panVoixSelectionnee.Width,panVoixSelectionnee.Height),
                              actChild.Curseur.GetiVoixSelectionnee,1, true, true);
end;

procedure TfrmVoix.ToolButton1Click(Sender: TObject);
var ivoix: integer;

begin
     ivoix := GetVoixSelectionneeDansLaListe;

     if ivoix = -1 then
          Message_Vite_Fait_Beep_Et_Afficher('Pour ajouter des paroles, veuillez d''abord sélectionner la voix dans laquelle vous voulez ajouter des paroles !')
     else
     Begin
           frmParoles.SetVoixNum(GetVoixSelectionneeDansLaListe);
           frmParoles.ShowModal;
     End;
end;

end.
