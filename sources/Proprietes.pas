unit Proprietes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ComCtrls;

type
  TfrmProprietes = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    txtNom: TEdit;
    txtAuteur: TEdit;
    Label2: TLabel;
    TabSheet2: TTabSheet;
    lst: TListView;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormActivate(Sender: TObject);
    procedure txtNomChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

procedure frmProprietes_Afficher;

var
  frmProprietes: TfrmProprietes;











implementation

uses Main,mplayer, MusicWriter_Erreur, Magnetophone, typestableaux,
         MusicUser_PlusieursDocuments;

{$R *.DFM}



procedure frmProprietes_Afficher;
Begin
    if frmProprietes = nil then
        frmProprietes := TfrmProprietes.Create(nil);

    frmProprietes.ShowModal;
End;

procedure TfrmProprietes.FormActivate(Sender: TObject);
var i: integer;

    nbnotes_tableau: TArrayInteger;
    nb_notes_totale: integer;


    
    procedure AjouterProprietes(quoi,valeur: string);
    Begin
           With lst.Items.Add do
            Begin
                Caption := quoi;
                SubItems.Add(valeur);
            End;
    End;


    
begin
 MessageErreurSiPasDeFenetreActive('FormActivate de Propriétés');

  actchild.VerifierIntegrite('propriétés');
  txtNom.text := actchild.Composition.Nom;
  lst.Items.Clear;

  AjouterProprietes('nombre de mesures :', inttostr(actchild.Composition.NbMesures));
  AjouterProprietes('nombre de portées :', inttostr(actchild.Composition.NbPortees));
  AjouterProprietes('nombre de systèmes :', inttostr(actchild.Composition.NbLignes));
  AjouterProprietes('nombre d''instruments :', inttostr(actchild.Composition.NbInstruments));

  nbnotes_tableau := actchild.Composition.NbNotesParPortees;
  for i := 0 to high(nbnotes_tableau) do
        AjouterProprietes('nombre de notes dans la portée n°' + inttostr(i+1) + ' :', inttostr(nbnotes_tableau[i]));
  ;

  nb_notes_totale := 0;
  for i := 0 to high(nbnotes_tableau) do
      nb_notes_totale := nb_notes_totale + nbnotes_tableau[i];
        AjouterProprietes('nombre total de notes :', inttostr(nb_notes_totale));

  //MainForm.CompilerFichierMIDI;

end;

procedure TfrmProprietes.txtNomChange(Sender: TObject);
begin
   MessageErreurSiPasDeFenetreActive('txtNomChange de Propriétés');

if Sender = txtNom then
      actchild.Composition.Nom := txtNom.text;
end;

end.
