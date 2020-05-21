unit frmMesuresBarres;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfrmMesures_Barres = class(TForm)
    Label10: TLabel;
    btnDebutSimple: TSpeedButton;
    btnDebutReprise: TSpeedButton;
    Label11: TLabel;
    btnSimple: TSpeedButton;
    btnDouble: TSpeedButton;
    btnRepriseFin: TSpeedButton;
    cmdApply: TButton;
    Annuler: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMesures_Barres: TfrmMesures_Barres;

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

procedure TfrmMesures_Barres.FormShow(Sender: TObject);
begin
     With actchild.Composition.GetMesure(Mode_Mesures_GetDebMes) do
     Begin
         case BarreDebut of
                          bBarreSimple:  btnDebutSimple.Down := true;
                          bBarreReprise: btnDebutReprise.Down := true;
                 End;


                 case BarreFin of
                          bBarreSimple:  btnSimple.Down := true;
                          bBarreDouble:  btnDouble.Down := true;
                          bBarreReprise: btnRepriseFin.Down := true;
                 End;
     End;
end;

end.
