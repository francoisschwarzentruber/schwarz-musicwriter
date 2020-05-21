unit AideGenerale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, MusicUser;

type
  TfrmAideGenerale = class(TForm)
    RichEdit: TRichEdit;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAideGenerale: TfrmAideGenerale;


procedure AideGenerale_Afficher(mode: TMusicWriter_Mode);



implementation

{$R *.dfm}




procedure AideGenerale_Afficher(mode: TMusicWriter_Mode);

   function NomFichierGet(mode: TMusicWriter_Mode): string;
   Begin
       case mode of
             mw_mode_Fichier: result := 'mode_fichier';
             mw_mode_MettreNote: result := 'mode_ecrire';
             else result := 'mode_inconnu';
       end;

   End;

Begin
    frmAideGenerale.RichEdit.Lines.LoadFromFile(DossierRacine + '\interface_aidegenerale\' + NomFichierGet(mode) + '.rtf');
    frmAideGenerale.Show;
End;


end.
