unit alterer_selon_une_tonalite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frame_Tonalite, Buttons, MusicHarmonie, ExtCtrls;

type
  TfrmAlterer_Selon_Une_Tonalite = class(TForm)
    chkNoteSensible: TCheckBox;
    cmdOK: TButton;
    BitBtn3: TBitBtn;
    lblNoteSensible: TLabel;
    frameTonalite: TframeTonalite_Anneau;
    Image1: TImage;
    Label1: TLabel;
    procedure frameTonalitePaintBoxTonaliteClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAlterer_Selon_Une_Tonalite: TfrmAlterer_Selon_Une_Tonalite;




  procedure frmAlterer_Selon_Une_Tonalite_Show(tonalite_courante : TTonalite);








  
implementation




procedure frmAlterer_Selon_Une_Tonalite_Show(tonalite_courante : TTonalite);
Begin
     if frmAlterer_Selon_Une_Tonalite = nil then
         frmAlterer_Selon_Une_Tonalite := TfrmAlterer_Selon_Une_Tonalite.Create(nil); 

     With frmAlterer_Selon_Une_Tonalite do
     Begin
         frameTonalite.Tonalite_Set(
                 tonalite_courante)
                 ;

         frameTonalitePaintBoxTonaliteClick(nil);

         ShowModal;
     End;
End;

{$R *.dfm}

procedure TfrmAlterer_Selon_Une_Tonalite.frameTonalitePaintBoxTonaliteClick(
  Sender: TObject);
begin
    lblNoteSensible.Caption := '(' +
               HauteurNoteToStrNomNoteJuste(
                   Tonalite_NoteSensible_Get(frameTonalite.Tonalite_Get)
                                )
                                + ')';

end;

end.
