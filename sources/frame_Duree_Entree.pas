unit frame_Duree_Entree;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, QSystem;

type
  TframeDureeEntree = class(TFrame)
    lblNum: TLabel;
    Label2: TLabel;
    lblDenom: TLabel;
    lblDenomInterrogation: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
     procedure Duree_Set(duree:TRationnel);
     procedure Duree_Indefini_Set;
     procedure Duree_SetNumSeulementPourLinstant(num: integer);
     
  end;

implementation

{$R *.dfm}

procedure TframeDureeEntree.Duree_Set(duree:TRationnel);
Begin
    lblNum.Caption := inttostr(duree.num);
    lblDenom.Caption := inttostr(duree.denom);
    lblDenom.Visible := true;
    lblDenomInterrogation.Visible := false;
End;



procedure TframeDureeEntree.Duree_Indefini_Set;
Begin
    lblNum.Caption := '??';
    lblDenom.Caption := '??';
    lblDenom.Visible := true;
End;


procedure TframeDureeEntree.Duree_SetNumSeulementPourLinstant(num: integer);
Begin
    lblNum.Caption := inttostr(num);
    lblDenom.Visible := false;
    lblDenomInterrogation.Visible := true;
End;

end.
