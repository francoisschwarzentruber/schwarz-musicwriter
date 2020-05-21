unit Lettre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmLettre = class(TForm)
    txtLettre: TEdit;
    lblResultat: TLabel;
    procedure txtLettreChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmLettre: TfrmLettre;

procedure frmLettre_show;








implementation

uses MusicHarmonie, MusicWriter_Erreur;

{$R *.dfm}


procedure frmLettre_show;
Begin
    if frmLettre = nil then
        frmLettre := TfrmLettre.Create(nil);

    frmLettre.show;
End;
procedure TfrmLettre.txtLettreChange(Sender: TObject);
var hn: THauteurNote;
begin
    if length(txtLettre.text) = 0 then
        txtLettre.text := 'A';

    txtLettre.SelectAll;
    hn.Hauteur := Ord(txtLettre.text[1]) - 65 - 2;
    hn.alteration := aNormal;

    lblResultat.caption := HauteurNoteToStr(hn);
end;

end.
