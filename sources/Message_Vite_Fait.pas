unit Message_Vite_Fait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmMessageViteFait = class(TForm)
    Label1: TLabel;
    tmr: TTimer;
    procedure tmrTimer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMessageViteFait: TfrmMessageViteFait;


 //procedure Message_Vite_Fait_Afficher(s: string);
 procedure Message_Vite_Fait_Beep_Et_Afficher(s: string);
 procedure Message_Vite_Fait_Afficher(s: string);
 procedure Message_Super_Vite_Fait_Afficher(s: string);

 Function PointeurMalFichu(P: Pointer): Boolean;


 
implementation

uses Main;


{$R *.dfm}
var etat : integer = 0;




Function PointeurMalFichu(P: Pointer): Boolean;
Begin
    result := integer(P) < 512;

End;


procedure Message_Vite_Fait_Afficher_Sub(s: string; duree: integer);
Begin
    etat := 0;

    if frmMessageViteFait = nil then
          frmMessageViteFait := TfrmMessageViteFait.Create(nil);


    frmMessageViteFait.Label1.Caption := s;
    frmMessageViteFait.AlphaBlendValue := 192;
    frmMessageViteFait.Show;
    if MainForm.Visible then MainForm.SetFocus;
    frmMessageViteFait.tmr.Interval := duree;
    frmMessageViteFait.tmr.Enabled := true;
End;


procedure Message_Vite_Fait_Afficher(s: string);
Begin
    Message_Vite_Fait_Afficher_Sub(s, 1000);

End;




procedure Message_Super_Vite_Fait_Afficher(s: string);
Begin
    Message_Vite_Fait_Afficher_Sub(s, 300);

End;

procedure Message_Vite_Fait_Beep_Et_Afficher(s: string);
Begin
    Beep;
    Message_Vite_Fait_Afficher(s);

End;



procedure TfrmMessageViteFait.tmrTimer(Sender: TObject);
begin
     if etat = 0 then
     Begin
        tmr.Interval := 10;
        etat := 1;
     End

     else if etat = 1 then
     Begin
          AlphaBlendValue := AlphaBlendValue - 8;
          if AlphaBlendValue < 30 then
               etat := 2;
     End

     else if etat = 2 then
     Begin
         Hide;
         tmr.Enabled := false;
         etat := 0;
     End;
end;

end.
