unit frame_Tonalite;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ImgList, MusicHarmonie, StdCtrls;

type

  TEtat = record
      caption: string;
      image_i: integer;
      tonalite: TTonalite;
      x, y, w: integer;
  end;


  TframeTonalite_Anneau = class(TFrame)
    lblTonaliteCourante_Nom: TLabel;
    lstNotes: TListBox;
    scrTonalite: TScrollBar;
    panNotes: TPaintBox;
    lblAddDiese: TLabel;
    lblAddBemol: TLabel;
    procedure panNotesPaint(Sender: TObject);
    procedure scrTonaliteChange(Sender: TObject);
    procedure lblAddDieseClick(Sender: TObject);
    procedure lblAddBemolClick(Sender: TObject);

  public
    { Déclarations publiques }

        Function Tonalite_Get: TTonalite;
        procedure Tonalite_Set(tonalite: TTonalite);
  end;

implementation

{$R *.dfm}

uses Main, MusicUser, Math {pour min}, langues;













Function TframeTonalite_Anneau.Tonalite_Get: TTonalite;
Begin
    result := -scrTonalite.Position;
End;


procedure TframeTonalite_Anneau.Tonalite_Set(tonalite: TTonalite);
Begin
    VerifierTonalite(tonalite);

    scrTonalite.Position := -tonalite;
End;





procedure TframeTonalite_Anneau.panNotesPaint(Sender: TObject);
var i: integer;
    s: string;
    
begin
       panNotes.Canvas.brush.Color := clWhite;
       panNotes.Canvas.FillRect(panNotes.ClientRect);

       for i := 0 to 6 do
       Begin
            s := HauteurNoteToStrNomNoteJuste(
                               TonaliteToToniqueSansVerifier((5-i) + Tonalite_Get)
                                             );

            panNotes.Canvas.TextOut(0, i * 15, s);
       End;

end;

procedure TframeTonalite_Anneau.scrTonaliteChange(Sender: TObject);
begin
    lblTonaliteCourante_Nom.Caption := TonaliteToStr(Tonalite_Get);
    panNotes.Repaint;

    if Tonalite_Get > 0 then
        lblAddBemol.Caption := Langues_Traduire('supprimer un dièse à la clef')
    else
        lblAddBemol.Caption := Langues_Traduire('ajouter un bémol à la clef');

    if Tonalite_Get < 0 then
        lblAddDiese.Caption := Langues_Traduire('supprimer un bémol à la clef')
    else
        lblAddDiese.Caption := Langues_Traduire('ajouter un dièse à la clef');


end;

procedure TframeTonalite_Anneau.lblAddDieseClick(Sender: TObject);
begin
       scrTonalite.Position := scrTonalite.Position - 1;
end;

procedure TframeTonalite_Anneau.lblAddBemolClick(Sender: TObject);
begin
     scrTonalite.Position := scrTonalite.Position + 1;
end;

end.




