unit USauvegarde_Cayest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfrmSauvegarde_Cayest = class(TForm)
    Image: TImage;
    tmr: TTimer;
    procedure tmrTimer(Sender: TObject);
  private
    procedure Init;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmSauvegarde_Cayest: TfrmSauvegarde_Cayest;


procedure Sauvegarde_Cayest;

implementation

var etat: integer;

const w = 200;
      h = 320;

procedure Sauvegarde_Cayest;
Begin
    etat := 0;
    frmSauvegarde_Cayest.Init;

End;


procedure TfrmSauvegarde_Cayest.Init;
Begin
    Image.SetBounds(w div 2, h div 2, 0, 0);
    tmr.Enabled := true;
    Show;
End;


{$R *.dfm}

procedure TfrmSauvegarde_Cayest.tmrTimer(Sender: TObject);
const nbetape = 5;
var l: real;

  procedure EtatFinal_Traiter;
  Begin
      tmr.Enabled := false;
      Hide;
  End;
begin
    inc(etat);

    if etat > 2*nbetape then
     Begin
           EtatFinal_Traiter;
           exit;
     End;

     
    if etat < nbetape then
        l := etat / nbetape
    else
        l := (2*nbetape - etat) / nbetape;

    Image.SetBounds(w div 2 - Round(l * (w div 2)),
                    h div 2 - Round(l * (h div 2)),
                    Round(l * w),
                    Round(l * h));
end;

end.
