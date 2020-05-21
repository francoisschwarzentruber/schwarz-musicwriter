unit choix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmChoix = class(TForm)
    lstList: TListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    Image1: TImage;
    lblBlabla: TMemo;
  private
    { Déclarations privées }
  public
     Procedure Reset;
     procedure SetBlabla(s: string);
     procedure AjouterChoix(s :string);
     function AfficherChoix: integer;
    { Déclarations publiques }
  end;

var
  frmChoix: TfrmChoix;





  Procedure Choix_Reset;
  Procedure Choix_SetBlabla(s:string);
  Procedure Choix_Ajouter(s:string);
  Function Choix_Afficher: integer;

  Function Choix_IsCancelled(choix: integer): Boolean;



implementation

{$R *.dfm}


procedure Choix_Assurer_Que_Fenetre_Chargee;
Begin
    if frmChoix = nil then
         frmChoix := TfrmChoix.Create(nil);
End;


Procedure Choix_Reset;
Begin
    Choix_Assurer_Que_Fenetre_Chargee;
    frmChoix.Reset;

End;



Procedure Choix_Ajouter(s:string);
Begin
    Choix_Assurer_Que_Fenetre_Chargee;
    frmChoix.AjouterChoix(s);

End;


Procedure Choix_SetBlabla(s:string);
Begin
    Choix_Assurer_Que_Fenetre_Chargee;
    frmChoix.SetBlabla(s);
End;



Function Choix_Afficher: integer;
Begin
    Choix_Assurer_Que_Fenetre_Chargee;
    result := frmChoix.AfficherChoix;
End;


Function Choix_IsCancelled(choix: integer): Boolean;
Begin
     result := choix < 0;
End;


Procedure TfrmChoix.Reset;
Begin
  lstList.Clear;
End;

procedure TfrmChoix.SetBlabla(s: string);
Begin
    lblBlabla.text := s;
End;


procedure TfrmChoix.AjouterChoix(s :string);
Begin
    lstList.AddItem(s, nil);
End;


function TfrmChoix.AfficherChoix: integer;
Begin
    lstList.ItemIndex := 0; 
    if ShowModal = mrCancel then
       result := -1
    else
       result := lstList.ItemIndex;
End;

end.
