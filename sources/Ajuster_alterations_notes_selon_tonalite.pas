unit Ajuster_alterations_notes_selon_tonalite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_Tonalite, Buttons, StdCtrls, MusicHarmonie;

type
  TfrmAjuster_Alterations_Notes_Selon_Une_Tonalite = class(TForm)
    cmdOK: TButton;
    BitBtn3: TBitBtn;
    frameTonalite: TframeTonalite_Anneau;
    Image1: TImage;
    Label1: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

  end;

var
  frmAjuster_Alterations_Notes_Selon_Une_Tonalite: TfrmAjuster_Alterations_Notes_Selon_Une_Tonalite;


  procedure Ajuster_alterations_notes_selon_tonalite_Show(tonalite_courante : TTonalite);




implementation

{$R *.dfm}


procedure Ajuster_alterations_notes_selon_tonalite_Show(tonalite_courante : TTonalite);
Begin
     if frmAjuster_Alterations_Notes_Selon_Une_Tonalite = nil then
         frmAjuster_Alterations_Notes_Selon_Une_Tonalite := TfrmAjuster_Alterations_Notes_Selon_Une_Tonalite.Create(nil); 

     With frmAjuster_Alterations_Notes_Selon_Une_Tonalite do
     Begin
         frameTonalite.Tonalite_Set(
                 tonalite_courante)
                 ;


         ShowModal;
     End;
End;

end.
