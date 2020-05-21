unit Correction;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmCorrection = class(TForm)
    lstErreurs: TListBox;
    cmdFermer: TButton;
    cmdYAller: TButton;
    Label1: TLabel;
    cmdCorriger: TButton;
    procedure ListerErreurs;
    procedure FormActivate(Sender: TObject);
    procedure cmdYAllerClick(Sender: TObject);
    procedure lstErreursDblClick(Sender: TObject);
    procedure cmdCorrigerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;


  procedure frmCorrection_Afficher;


  
var
  frmCorrection: TfrmCorrection;










  
implementation

{$R *.dfm}
uses Main, MusicWriter_Erreur, MusicUser, QSystem,      MusicUser_PlusieursDocuments;


procedure frmCorrection_Afficher;
Begin
    if frmCorrection = nil then
         frmCorrection := TfrmCorrection.Create(nil);

    frmCorrection.Show;
End;


procedure TfrmCorrection.ListerErreurs;
var i: integer;
Begin

    lstErreurs.Clear;
    for i := 0 to actchild.Composition.NbMesures - 1 do
        if actchild.Composition.GetMesure(i).ErreurDansMesure then
              lstErreurs.AddItem('Erreur à la mesure n° ' + inttostr(i + 1), TObject(i));
End;



procedure TfrmCorrection.FormActivate(Sender: TObject);
begin
    if not MusicWriter_IsFenetreDocumentCourante then
        EnableFenetre(Self, false)
    else
    Begin
        EnableFenetre(self, true);

        actchild.ReaffichageComplet;
        ListerErreurs;

    End;
end;

procedure TfrmCorrection.cmdYAllerClick(Sender: TObject);
begin
      MessageErreurSiPasDeFenetreActive('cmdYAllerClick');

      if lstErreurs.ItemIndex < 0 then exit;


      actchild.FaireVoirMesure(integer(lstErreurs.Items.
                                           Objects[lstErreurs.ItemIndex]));
      actchild.ReaffichageComplet;

end;

procedure TfrmCorrection.lstErreursDblClick(Sender: TObject);
begin
    cmdYAllerClick(nil);
end;

procedure TfrmCorrection.cmdCorrigerClick(Sender: TObject);
var m :integer;
begin
      MessageErreurSiPasDeFenetreActive('cmdYAllerClick');

      if lstErreurs.ItemIndex < 0 then exit;

      m := integer(lstErreurs.Items.Objects[lstErreurs.ItemIndex]);

     MusicUser_Pourcentage_Init('Corriger : mettre barres');
   MessageErreurSiPasDeFenetreActive('cmdCorrigerClick');


   actchild.Composition.I_Mesures_Mettre_Barre_De_Mesures_Et_GetFinMes(m, m, 
                                                    actchild.Composition.GetMesure(m).Rythme);


    MusicUser_Pourcentage_Free;

    actchild.ReaffichageComplet;

    ListerErreurs;
end;

end.


