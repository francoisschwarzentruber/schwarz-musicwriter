unit EnregistrerAvertissement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmEnregistrerAvertissement = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lblTitre: TLabel;
    cmdOui: TBitBtn;
    cmdNon: TBitBtn;
    cmdQuitWithoutSaving: TBitBtn;
    Image1: TImage;
    procedure imgCancelClick(Sender: TObject);
    procedure imgNonClick(Sender: TObject);
    procedure imgOuiClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }

  public
    { Déclarations publiques }
    procedure TitreSet(titre: string);
    
  end;

var
  frmEnregistrerAvertissement: TfrmEnregistrerAvertissement;

implementation

{$R *.dfm}

uses langues;




procedure TfrmEnregistrerAvertissement.imgCancelClick(Sender: TObject);
begin
      ModalResult := mrCancel;
      Hide;
end;

procedure TfrmEnregistrerAvertissement.imgNonClick(Sender: TObject);
begin
      ModalResult := mrNo;
      Hide;
end;

procedure TfrmEnregistrerAvertissement.imgOuiClick(Sender: TObject);
begin
      ModalResult := mrYes;
      Hide;
end;



procedure TfrmEnregistrerAvertissement.TitreSet(titre: string);
Begin
    if titre = '' then
         frmEnregistrerAvertissement.lblTitre.Caption := 'sans titre (car n''a jamais été sauvegardée)'
    else
         frmEnregistrerAvertissement.lblTitre.Caption := titre;
End;

procedure TfrmEnregistrerAvertissement.FormCreate(Sender: TObject);
begin
    Langues_TraduireFenetre(self);
end;

end.
