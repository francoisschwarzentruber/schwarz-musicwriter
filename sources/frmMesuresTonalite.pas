unit frmMesuresTonalite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frame_Tonalite;

type
  TfrmMesures_Tonalite = class(TForm)
    frameTonalite: TframeTonalite_Anneau;
    cmdApply: TButton;
    Annuler: TButton;
    procedure FormShow(Sender: TObject);
    procedure cmdApplyClick(Sender: TObject);
    procedure AnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMesures_Tonalite: TfrmMesures_Tonalite;

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

procedure TfrmMesures_Tonalite.FormShow(Sender: TObject);
begin
     With actchild.Composition.GetMesure(Mode_Mesures_GetDebMes) do
        frameTonalite.Tonalite_Set(Tonalites[high(Tonalites)]);
end;

procedure TfrmMesures_Tonalite.cmdApplyClick(Sender: TObject);
begin
  frameTonalite.scrTonaliteChange(Sender);  

  {pas très propre, mais c'est pas grave}
  MessageErreurSiPasDeFenetreActive('MettreAJourMesures');

      IGP := actchild.Composition;
      actchild.Composition.I_Mesures_Tonalite_Set(Mode_Mesures_GetDebMes, Mode_Mesures_GetFinMes, frameTonalite.Tonalite_Get);
      actchild.ReaffichageComplet;

      Close;
end;

procedure TfrmMesures_Tonalite.AnnulerClick(Sender: TObject);
begin
    Close;
end;

end.
