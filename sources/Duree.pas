unit Duree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, frame_Duree_Choix, Buttons;

type
  TfrmDuree = class(TForm)
    Label4: TLabel;
    Bevel1: TBevel;
    txtDureeNum: TEdit;
    txtDureeDenom: TEdit;
    frameDureeChoix: TframeDureeChoix;
    cmdApply: TBitBtn;
    Fermer: TBitBtn;
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdApplyClick(Sender: TObject);
    procedure txtDureeDenomChange(Sender: TObject);
    procedure txtDureeNumChange(Sender: TObject);
    procedure txtDureeNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtDureeNumKeyPress(Sender: TObject; var Key: Char);
    procedure txtDureeDenomKeyPress(Sender: TObject; var Key: Char);
    procedure txtDureeDenomKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure frameDureeChoix_Change;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmDuree: TfrmDuree;

implementation


{$R *.DFM}


uses QSystem, Main, MusicSystem, MusicUser, DureeCourante_Gestion,
     MusicSystem_ElMusical, MusicGraph, MusicGraph_System, langues,
          MusicUser_PlusieursDocuments, InterfaceGraphique_Complements;

procedure TfrmDuree.cmdCancelClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmDuree.cmdApplyClick(Sender: TObject);
begin
    actchild.Composition.I_Selection_ChangerRythme(DureeCourante_Get);
    actchild.MettreBarreMesures_RegarderSiBesoin(actchild.Composition.Selection_GetIMesDebutSelection);
    actChild.ReaffichageComplet;
end;





procedure TfrmDuree.txtDureeDenomChange(Sender: TObject);
var q: TRationnel;
begin
    if Sender = nil then exit;
    
    q := Qel(strtoint(txtDureeNum.text), strtoint(txtDureeDenom.text));    
    DureeCourante_Set(q);
end;

procedure TfrmDuree.txtDureeNumChange(Sender: TObject);
begin
    DureeCourante_ModificationDureeClavierDansfrmDuree_Begin;
    txtDureeDenomChange(Sender);
    DureeCourante_ModificationDureeClavierDansfrmDuree_End;
end;

procedure TfrmDuree.txtDureeNumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   IntegerEditBoxKeyDown(TEdit(Sender), Key);
end;

procedure TfrmDuree.txtDureeNumKeyPress(Sender: TObject; var Key: Char);
begin
     IntegerEditBoxKeyPress(TEdit(Sender), Key);
end;

procedure TfrmDuree.txtDureeDenomKeyPress(Sender: TObject; var Key: Char);
begin
     IntegerNonNulEditBoxKeyPress(TEdit(Sender), Key);
end;

procedure TfrmDuree.txtDureeDenomKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    IntegerNonNulEditBoxKeyDown(TEdit(Sender), Key);
end;

procedure TfrmDuree.FormCreate(Sender: TObject);
begin
   Langues_TraduireFenetre(self);
   frameDureeChoix.OnChange := frameDureeChoix_Change;
   frameDureeChoix.Init;
end;

procedure TfrmDuree.frameDureeChoix_Change;
var q: TRationnel;
Begin
      q := frameDureeChoix.Duree_Get;

      txtDureeNum.Text := inttostr(q.num);
      txtDureeDenom.Text := inttostr(q.denom);
End;

end.
