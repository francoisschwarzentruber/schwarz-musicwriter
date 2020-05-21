unit frame_Duree_Choix;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, frame_Duree_Entree, ComCtrls, ToolWin, QSystem, StdCtrls;

type

  TOnChange = procedure of Object; 

  TframeDureeChoix = class(TFrame)
    tlbNotes: TToolBar;
    tbnRonde: TToolButton;
    tbnBlanche: TToolButton;
    tbnNoire: TToolButton;
    tbnCroche: TToolButton;
    tbnDbCroche: TToolButton;
    frameDureeEntree: TframeDureeEntree;
    tlbNotes_PointsDuree: TToolBar;
    btn2PointDuree: TToolButton;
    btn1PointDuree: TToolButton;
    Label1: TLabel;
    procedure btn2PointDureeClick(Sender: TObject);
    procedure tbnCrocheClick(Sender: TObject);
  private
    private_Duree: TRationnel;
    procedure AppuyerSurLesBoutons_Selon_Duree;
    procedure CalculerDuree_A_Partir_Des_Boutons;
    procedure private_InterfaceImageIndexLoad(a: integer);
    { Déclarations privées }
  public
    { Déclarations publiques }
    OnChange: TOnChange;

    Function Duree_Get: TRationnel;
    Procedure Duree_SetNumSeulementPourLinstant(num: integer);
    Procedure Duree_Set(q: TRationnel);
    procedure Duree_SetIndefini;
    procedure Init;
    procedure InterfaceNotes;
    procedure InterfaceSilences;
  end;

implementation

uses Main, langues;

{$R *.dfm}

procedure TframeDureeChoix.btn2PointDureeClick(Sender: TObject);
begin
        if Sender = btn2PointDuree then
             btn1PointDuree.Down := false;
        if Sender = btn1PointDuree then
             btn2PointDuree.Down := false;

        CalculerDuree_A_Partir_Des_Boutons;
        OnChange;
end;


procedure TframeDureeChoix.CalculerDuree_A_Partir_Des_Boutons;
Begin
    if tbnRonde.Down then
        private_Duree := Qel(4)
    else if tbnBlanche.Down then
        private_Duree := Qel(2)
    else if tbnNoire.Down then
        private_Duree := Qel(1)
    else if tbnCroche.Down then
        private_Duree := Qel(1,2)
    else if tbnDbCroche.Down then
        private_Duree := Qel(1,4);

    if btn1PointDuree.Down then
          private_Duree := Qmul(Qel(3,2), private_Duree)
    else if btn2PointDuree.Down then
          private_Duree := Qmul(Qel(7,4), private_Duree);


End;


procedure TframeDureeChoix.AppuyerSurLesBoutons_Selon_Duree;
     procedure TesterDuree(duree: TRationnel; toolbutton: TToolButton);
     Begin
          if IsQEgal(private_Duree, duree) then
          Begin
              btn1PointDuree.Down := false;
              btn2PointDuree.Down := false;
              toolbutton.Down := true;
          End
          else if IsQEgal(private_Duree, QMul(duree, Qel(3, 2))) then
          Begin
             btn1PointDuree.Down := true;
             btn2PointDuree.Down := false;
             toolbutton.Down := true;

          End
          else if IsQEgal(private_Duree, QMul(duree, Qel(7, 4))) then
          Begin
             btn1PointDuree.Down := false;
             btn2PointDuree.Down := true;
             toolbutton.Down := true;
          End;
     End;
Begin
      TesterDuree(Qel(4), tbnRonde);
      TesterDuree(Qel(2), tbnBlanche);
      TesterDuree(Qel(1), tbnNoire);
      TesterDuree(Qel(1, 2), tbnCroche);
      TesterDuree(Qel(1, 4), tbnDbCroche);

End;


procedure TframeDureeChoix.tbnCrocheClick(Sender: TObject);
begin
      btn1PointDuree.Down := false;
      btn2PointDuree.Down := false;

      CalculerDuree_A_Partir_Des_Boutons;
      OnChange;
end;


Function TFrameDureeChoix.Duree_Get: TRationnel;
Begin
     result := private_Duree;
End;


Procedure TFrameDureeChoix.Duree_SetNumSeulementPourLinstant(num: integer);
Begin
    frameDureeEntree.Duree_SetNumSeulementPourLinstant(num);
    private_Duree := Qel(num);
    AppuyerSurLesBoutons_Selon_Duree;
End;



Procedure TFrameDureeChoix.Duree_Set(q: TRationnel);
Begin
    frameDureeEntree.Duree_Set(q);
    private_Duree := q;

    AppuyerSurLesBoutons_Selon_Duree;
End;


procedure TFrameDureeChoix.Duree_SetIndefini;
    Procedure tlbNotes_Indefini;
    var i :integer;
    Begin
         for i := 0 to tlbNotes.ButtonCount - 1 do
               tlbNotes.Buttons[i].Down := false;
               
    End;

Begin
    frameDureeEntree.Duree_Indefini_Set;
    tlbNotes_Indefini;


End;




procedure TFrameDureeChoix.Init;
Begin
    tlbNotes.Images := MainForm.imgNotes;
    tlbNotes_PointsDuree.Images := MainForm.imgNotes;
    Duree_Set(Qel(1));
    InterfaceNotes;
End;


procedure TFrameDureeChoix.private_InterfaceImageIndexLoad(a: integer);
Begin
    tbnRonde.ImageIndex := 0 + a;
    tbnBlanche.ImageIndex := 1 + a;
    tbnNoire.ImageIndex := 2 + a;
    tbnCroche.ImageIndex := 3 + a;
    tbnDbCroche.ImageIndex := 4 + a;
End;


procedure TFrameDureeChoix.InterfaceNotes;
Begin
     private_InterfaceImageIndexLoad(1);

     tbnRonde.Caption := Langues_Traduire('Ronde (4)');
     tbnBlanche.Caption := Langues_Traduire('Blanche (2)');
     tbnNoire.Caption := Langues_Traduire('Noire (1)');
     tbnCroche.Caption := Langues_Traduire('Croche (1, 2)');
     tbnDbCroche.Caption := Langues_Traduire('Db-croche (1, 4)');

     
End;


procedure TFrameDureeChoix.InterfaceSilences;
Begin
    private_InterfaceImageIndexLoad(14);

    tbnRonde.Caption := Langues_Traduire('Pause (4)');
    tbnBlanche.Caption := Langues_Traduire('Demi-pause (2)');
    tbnNoire.Caption := Langues_Traduire('Soupir (1)');
    tbnCroche.Caption := Langues_Traduire('Demi-soupir (1, 2)');
    tbnDbCroche.Caption := Langues_Traduire('Qt de soupir (1, 4)');
End;

end.
