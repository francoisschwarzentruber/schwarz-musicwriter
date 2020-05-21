unit Selection_Deplacer_Voix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmSelection_Deplacer_Voix = class(TForm)
    lstVoix: TListBox;
    lblVoix: TLabel;
    panVoixSelectionnee: TPaintBox;
    panVoix: TPanel;
    Image1: TImage;
    BitBtn3: TBitBtn;
    procedure panVoixSelectionneePaint(Sender: TObject);
    procedure lstVoixDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstVoixMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lstVoixClick(Sender: TObject);
  private
    Voix_Ou_On_Deplace: integer;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmSelection_Deplacer_Voix: TfrmSelection_Deplacer_Voix;


 procedure frmSelection_Deplacer_Voix_ShowModal;




implementation

uses MusicGraph, MusicGraph_CouleursVoix,
     Main, MusicSystem_Composition_Portees_Liste,
     Voix {pour nbvoixparportee},
          MusicUser_PlusieursDocuments;

{$R *.dfm}
const COULEUR_QUAND_PAS_DE_VOIX_SOUS_CURSEUR = $888888;



procedure frmSelection_Deplacer_Voix_ShowModal;
Begin
     if frmSelection_Deplacer_Voix = nil then
           frmSelection_Deplacer_Voix := TfrmSelection_Deplacer_Voix.Create(nil);

     frmSelection_Deplacer_Voix.ShowModal;

End;




procedure TfrmSelection_Deplacer_Voix.panVoixSelectionneePaint(
  Sender: TObject);
begin
      if Voix_Ou_On_Deplace = -1 then
      Begin
            panVoixSelectionnee.Canvas.Brush.Color := COULEUR_QUAND_PAS_DE_VOIX_SOUS_CURSEUR;
            panVoixSelectionnee.Canvas.FillRect(panVoixSelectionnee.ClientRect);

      End
      else DrawCadrePresentationVoix(actChild.Composition, panVoixSelectionnee.Canvas,
                              Rect(0,0,panVoixSelectionnee.Width,panVoixSelectionnee.Height),
                              Voix_Ou_On_Deplace,1, true, true);
end;

procedure TfrmSelection_Deplacer_Voix.lstVoixDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
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
                              strtoint(lstVoix.Items[Index]),0, false, false);
end;

procedure TfrmSelection_Deplacer_Voix.FormActivate(Sender: TObject);
var p1: integer;
begin
   lstVoix.Clear;

   With actchild.Composition do
   Begin
       p1 := Selection_Instrument_Portee_Get;
       VerifierIndicePortee(p1, 'TfrmSelection_Deplacer_Voix.FormActivate : ' +
                      ' je n''arrive pas à trouver un instrument correct');
        I_Instruments_VoixListe_TString(p1, lstVoix.Items);

   End;

   lstVoix.ItemIndex := 0;
   lstVoixMouseMove(nil, [], -1, -10);


end;

procedure TfrmSelection_Deplacer_Voix.FormCreate(Sender: TObject);
begin
     panVoix.DoubleBuffered := true;
end;

procedure TfrmSelection_Deplacer_Voix.lstVoixMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);

var item: integer;

begin
      item := lstVoix.ItemAtPos(Point(X, Y), true);

      if item = -1 then
      Begin
            Voix_Ou_On_Deplace := -1;
            panVoix.Color := COULEUR_QUAND_PAS_DE_VOIX_SOUS_CURSEUR;
      End
      else
      Begin
            Voix_Ou_On_Deplace := strtoint(lstVoix.Items[item]);
            panVoix.Color := CouleursVoixFondList(actchild.Composition,
                                            Voix_Ou_On_Deplace);
      End;

      //panVoixSelectionneePaint(nil);
end;

procedure TfrmSelection_Deplacer_Voix.lstVoixClick(Sender: TObject);
begin
    if Voix_Ou_On_Deplace = -1 then
          beep
    else
    Begin
          actchild.I_Selection_PlacerDansVoix(Voix_Ou_On_Deplace);
          Close;
    End;
end;

end.
