unit frmMesuresSignatureTemporelle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, frame_Rythme;

type
  TfrmMesures_Signature_Temporelle = class(TForm)
    Label4: TLabel;
    frameRythme: TframeRythme;
    chkTaillerMesure: TCheckBox;
    cmdApply: TButton;
    Annuler: TButton;
    procedure cmdApplyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMesures_Signature_Temporelle: TfrmMesures_Signature_Temporelle;

implementation

uses Main, MusicHarmonie,
     MusicSystem,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicGraph_Portees,
     ChildWin, MusicWriter_Erreur,
     MusicUser {pour les TEdit avec des entiers dedans},
     Math {pour min, max},
     QSystem,
     Cancellation,
     Message_Vite_Fait,
     langues,
     MusicUser_PlusieursDocuments,
     MusicUser_Mode_Mesures;
{$R *.dfm}

procedure TfrmMesures_Signature_Temporelle.cmdApplyClick(Sender: TObject);
begin
MessageErreurSiPasDeFenetreActive('MettreAJourMesures');

      actchild.Composition.I_Mesures_Rythme_Set(Mode_Mesures_GetDebMes, Mode_Mesures_GetFinMes, frameRythme.Rythme);

    if chkTaillerMesure.Checked then
    Begin
        MusicUser_Pourcentage_Init('Tailler les mesures');
        MessageErreurSiPasDeFenetreActive('cmdAppliquerRythmeClick');

        Mode_Mesures_SetFinMes(actchild.Composition.I_Mesures_Mettre_Barre_De_Mesures_Et_GetFinMes(
                                  Mode_Mesures_GetDebMes,
                                                                           Mode_Mesures_GetFinMes,
                                                                           frameRythme.Rythme));

        MusicUser_Pourcentage_Free;
    End;

    actchild.ReaffichageComplet;

end;

procedure TfrmMesures_Signature_Temporelle.FormShow(Sender: TObject);
begin
       With actchild.Composition.GetMesure(Mode_Mesures_GetDebMes) do
             frameRythme.Rythme := Rythme;
end;

end.
