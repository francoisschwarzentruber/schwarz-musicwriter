unit Doigtes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MusicHarmonie;

type
  TfrmDoigtes = class(TForm)
    lblNoteNom: TLabel;
    procedure Ellipse(x, y, rx, ry: integer; etat: integer);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
     Doigts: TStringList;
     inote: integer;
  public
    
    procedure Traiter(hn: THauteurNote);
    { Déclarations publiques }
  end;

var
  frmDoigtes: TfrmDoigtes;
  


implementation

{$R *.DFM}

uses MusicUser {pour DossierRacine};




procedure TfrmDoigtes.Traiter(hn: THauteurNote);
Begin
    if self = nil then
       exit;

    inote := CompterDemiTonOreille(hn0, hn);
    lblNoteNom.Caption := HauteurNoteToStr(hn);

    FormPaint(nil);
End;


    
procedure TfrmDoigtes.Ellipse(x, y, rx, ry: integer; etat: integer);
const TROU_BOUCHE_COULEUR = 0;
      TROU_OUVERT_COULEUR = clWhite;
      TROU_ERREUR_COULEUR = 255;


{etat = numéro du trou}
var b: Boolean;
    s: string;
Begin
    b := false;
    if (inote >= 0) and (inote <= Doigts.Count - 1) then
    Begin
        s := Doigts[inote];

        b := false;
        if etat <= length(s) then
                  b := (s[etat] = '1');

        if b then
            Canvas.Brush.Color := TROU_BOUCHE_COULEUR
        else
            Canvas.Brush.Color := TROU_OUVERT_COULEUR;

    End
    else
         Canvas.Brush.Color := TROU_ERREUR_COULEUR;



    Canvas.Ellipse(x - rx, y - ry, x + rx, y + ry);
End;


procedure TfrmDoigtes.FormPaint(Sender: TObject);
const lsup = 8;
      l = 20;
      l2 = 24;
      linf = 34;
      rayn = 8;
      ray = 4;
      mray = 2;
      esp2 = 9;
      esp = esp2 * 2;

      mesp = 12;

begin
    {on dessine le dessin de la flûte}

    Ellipse(8, linf, rayn, ray, 1);
    Ellipse(6 + esp, linf, rayn, ray, 2);

    Ellipse(8, l, rayn, rayn, 3);
    Ellipse(8 + esp, l, rayn, rayn, 4);
    Ellipse(8 + 2*esp, l, rayn, rayn, 5);
    Ellipse(16 + 2*esp, lsup, ray, rayn, 6);

    Ellipse(8 + 4*esp, l, rayn, rayn, 7);
    Ellipse(8 + 5*esp, l, rayn, rayn, 8);
    Ellipse(8 + 6*esp, l, rayn, rayn, 9);
    Ellipse(8 + 4*esp + esp2, l2, mray, ray, 10);
    Ellipse(8 + 5*esp + esp2, l2, mray, ray, 11);

    Ellipse(8 + 7*esp, l2, ray, rayn, 12);

    Ellipse(8 + 7*esp + mesp, l-6, rayn, mray, 13);
    Ellipse(8 + 7*esp + mesp, l2, rayn, rayn, 14);
end;

procedure TfrmDoigtes.FormCreate(Sender: TObject);
begin
    Doigts := TStringList.Create;
    Doigts.LoadFromFile(DossierRacine + 'doigtes.txt');
end;

end.


