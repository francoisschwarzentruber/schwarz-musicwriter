unit frmMesuresMetronome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmMesures_Metronome = class(TForm)
    txtMetronome: TEdit;
    Image1: TImage;
    Label5: TLabel;
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
  frmMesures_Metronome: TfrmMesures_Metronome;

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

procedure TfrmMesures_Metronome.cmdApplyClick(Sender: TObject);
begin
      MessageErreurSiPasDeFenetreActive('MettreAJourMesures');

      actchild.Composition.I_Mesures_Metronome_Set(Mode_Mesures_GetDebMes, Mode_Mesures_GetFinMes, strtoint(txtMetronome.Text));

end;

procedure TfrmMesures_Metronome.FormShow(Sender: TObject);
begin
      With actchild.Composition.GetMesure(Mode_Mesures_GetDebMes) do
             txtMetronome.Text := inttostr(Metronome);
end;

end.
