unit Cancellation_Window;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CheckLst, StdCtrls, ComCtrls, ToolWin;

type
  TAnnulerOuRefaireAction = (aoraAnnuler, aoraRefaire);

  TfrmCancellation_Window = class(TForm)
    lstOperations: TListBox;
    cmdAnnulerOuRefaire: TButton;
    Label1: TLabel;
    tlbGeneral: TToolBar;
    tbnAnnuler: TToolButton;
    tbnRefaire: TToolButton;
    tbnAnnulation_Reset: TToolButton;
    procedure lstOperationsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstOperationsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure cmdAnnulerOuRefaireClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lstOperationsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure tbnAnnulerClick(Sender: TObject);
    procedure tbnRefaireClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tbnAnnulation_ResetClick(Sender: TObject);
  private
    { Déclarations privées }
    Function lstOperations_MaintenantItem_Indice_Get: integer;
  public
    { Déclarations publiques }
    procedure lstOperations_MettreAJour;
  end;

var
  frmCancellation_Window: TfrmCancellation_Window;


Function frmCancellation_Window_IsVisible: Boolean;

implementation

uses Main, CurseurSouris_Busy, Message_Vite_Fait,
     MusicGraph {pour DrawCadrePresentationVoix},
     Types {pour Rect},
          MusicUser_PlusieursDocuments;

var frmCancellation_action: TAnnulerOuRefaireAction;
    frmCancellation_action_combien: integer = 0;

{$R *.dfm}

Function frmCancellation_Window_IsVisible: Boolean;
Begin
      if frmCancellation_Window = nil then
          result := false
      else
           result := frmCancellation_Window.Visible;
End;


procedure TfrmCancellation_Window.lstOperations_MettreAJour;
Begin
     if MusicWriter_IsFenetreDocumentCourante then
     Begin

         actchild.Composition.Cancellation_Remplir_ListBox(lstOperations);
         lstOperations.ItemIndex := lstOperations_MaintenantItem_Indice_Get;
         cmdAnnulerOuRefaire.Enabled := false;
         cmdAnnulerOuRefaire.Caption := '(rien à annuler ou refaire)';
         EnableFenetre(self, true)
     end
     Else
         EnableFenetre(self, false);
End;



Function TfrmCancellation_Window.lstOperations_MaintenantItem_Indice_Get: integer;
Begin
    result := lstOperations.Tag;
End;





procedure TfrmCancellation_Window.lstOperationsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var item_end_i, i: integer;
begin
     item_end_i := lstOperations.ItemAtPos(Point(x, y), false);

     if item_end_i < 0 then
          item_end_i := 0;

     if item_end_i >= lstOperations.Count then
           item_end_i := lstOperations.Count - 1;
           


     frmCancellation_action_combien := lstOperations_MaintenantItem_Indice_Get -1 - item_end_i;

     if frmCancellation_action_combien >= 0 then
     Begin
        frmCancellation_action := aoraAnnuler;
        inc(frmCancellation_action_combien);
        
     End;
     if frmCancellation_action_combien < 0 then
     Begin
        frmCancellation_action := aoraRefaire;
        frmCancellation_action_combien := - frmCancellation_action_combien - 1;
     End;


     lstOperations.ClearSelection;
     for i := item_end_i to lstOperations_MaintenantItem_Indice_Get-1 do
         lstOperations.Selected[i] := true;

     for i := lstOperations_MaintenantItem_Indice_Get+1 to item_end_i do
         lstOperations.Selected[i] := true;



     if frmCancellation_action_combien = 0 then
     Begin
          cmdAnnulerOuRefaire.Enabled := false;
          cmdAnnulerOuRefaire.Caption := '(rien à annuler ou refaire)';
     End
     else
     Begin
         cmdAnnulerOuRefaire.Enabled := true;
         if frmCancellation_action = aoraAnnuler then
         Begin
              if frmCancellation_action_combien = 1 then
                    cmdAnnulerOuRefaire.Caption := 'Annuler une opération : ' + actchild.Composition.Cancellation_Annuler_Texte
              else
              cmdAnnulerOuRefaire.Caption := 'Annuler ces ' + IntToStr(frmCancellation_action_combien) + ' opérations'
         End
         else
         Begin
              if frmCancellation_action_combien = 1 then
                    cmdAnnulerOuRefaire.Caption := 'Refaire une opération : ' + actchild.Composition.Cancellation_Refaire_Texte
              else
                    cmdAnnulerOuRefaire.Caption := 'Refaire ces ' + IntToStr(frmCancellation_action_combien) + ' opérations';
         End;
     End;
end;

procedure TfrmCancellation_Window.lstOperationsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    if ssLeft in Shift then
        lstOperationsMouseDown(Sender, mbLeft, Shift, X, Y);
end;

procedure TfrmCancellation_Window.cmdAnnulerOuRefaireClick(
  Sender: TObject);
var i: integer;
begin

      CurseurSouris_Busy_Begin;

      Message_Vite_Fait_Afficher(cmdAnnulerOuRefaire.Caption + '! Héhé!');


     if frmCancellation_action = aoraAnnuler then
     Begin
         for i := 1 to frmCancellation_action_combien do
               actchild.Composition.Cancellation_Annuler;
     End
     else
     Begin
         for i := 1 to frmCancellation_action_combien do
               actchild.Composition.Cancellation_Refaire;
     End;

     actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
     actchild.ReaffichageComplet;

     lstOperations_MettreAJour;
     CurseurSouris_Busy_End;
end;

procedure TfrmCancellation_Window.FormActivate(Sender: TObject);
begin

    actchild.Composition.Cancellation_GererMenuAnnuler;

end;

procedure TfrmCancellation_Window.lstOperationsDrawItem(
  Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
  var MaintenantItem_Indice: integer;
      p: integer;
      str_debut: string;
      str_debut_width: integer;
      str_localisation: string;
      str_localisation_width : integer;

      ivoix: integer;

begin
     MaintenantItem_Indice := lstOperations_MaintenantItem_Indice_Get;
      With lstOperations do
      Begin

          if Index = MaintenantItem_Indice then
          Begin
               Canvas.Brush.Color := $00CCFF;
               Canvas.Font.Color := 255;
               Canvas.Pen.Color := rgb(255,255,255);
               Canvas.Rectangle(Rect);
               Canvas.TextOut(20, Rect.Top, '____________(maintenant)____________');
          End
          else
          Begin
               Canvas.Pen.Color := rgb(255,255,255);
               Canvas.Rectangle(Rect);

               if Index < MaintenantItem_Indice then
                      MainForm.imgList.Draw(Canvas, Rect.Left, Rect.Top, 3 {image annuler})
               else {if Index > MaintenantItem_Indice then}
                      MainForm.imgList.Draw(Canvas, Rect.Left, Rect.Top, 4 {image refaire});

               Canvas.Font.Size := 8;
               p := pos(#9, Items[Index]);

               str_debut := Copy(Items[Index], 1, p-1);
               str_debut_width := Canvas.TextWidth(str_debut);
               str_localisation := Copy(Items[Index], p+1, 10000);

               
               Canvas.TextOut(20, Rect.Top, str_debut);

               Canvas.Font.Size := 7;
               str_localisation_width := Canvas.TextWidth(str_localisation);
               Canvas.TextOut(20 + str_debut_width + 10, Rect.Top, str_localisation);


               ivoix := integer(Items.Objects[index])-1;

               if ivoix > -1 then
                    DrawCadrePresentationVoix(actchild.Composition, Canvas,
                              Types.Rect(20 + str_debut_width + str_localisation_width + 20,
                                   Rect.top,
                                   20 + str_debut_width + str_localisation_width + 20 + 100,
                                   Rect.top + lstOperations.ItemHeight),
                                   ivoix,1, false, false);

          End;

      End;
end;

procedure TfrmCancellation_Window.tbnAnnulerClick(Sender: TObject);
begin
       MainForm.mnuCancelClick(nil);
end;

procedure TfrmCancellation_Window.tbnRefaireClick(Sender: TObject);
begin
      MainForm.mnuRefaireClick(nil);
end;

procedure TfrmCancellation_Window.FormCreate(Sender: TObject);
begin
       tlbGeneral.Images := MainForm.imgList;
end;

procedure TfrmCancellation_Window.tbnAnnulation_ResetClick(
  Sender: TObject);
begin
        actchild.Composition.Cancellation_Reset;
        
end;

end.
