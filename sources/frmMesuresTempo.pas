unit frmMesuresTempo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmMesures_Tempo = class(TForm)
    Label3: TLabel;
    Edit3: TEdit;
    cmdApply: TButton;
    Annuler: TButton;
    procedure cmdApplyClick(Sender: TObject);
    procedure AnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMesures_Tempo: TfrmMesures_Tempo;

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

procedure TfrmMesures_Tempo.cmdApplyClick(Sender: TObject);
begin
     MessageErreurSiPasDeFenetreActive('MettreAJourMesures');

     Message_Vite_Fait_Afficher('fonctionnalité pas encore disponible');
end;

procedure TfrmMesures_Tempo.AnnulerClick(Sender: TObject);
begin
Close;
end;

end.
