unit InterfaceGraphique_Complements;

interface

uses ComCtrls, Menus, StdCtrls, Graphics, Types;

procedure CBOBOXSelectionner(cbo: TComboBox; s: string);

procedure ToolBar_AppuyerSurBoutonsSelectionnes(tb: TToolBar);
procedure ToolBar_Enabled(tb: TToolBar; enabled: boolean);
procedure ToolBarButtonFromMenuItem(tbn: TToolButton; mnu: TMenuItem);

procedure MusicUser_PopupMenu_AfficherTitre(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);




Procedure IntegerEditBoxKeyPress(var EditBx: TEdit; var Key: Char);

Procedure IntegerNonNulEditBoxKeyPress(var EditBx: TEdit; var Key: Char);


Procedure IntegerEditBoxKeyDown(var EditBx: TEdit; var Key: Word);

procedure IntegerNonNulEditBoxKeyDown(var EditBx: TEdit; var Key: Word);



  
implementation


uses Windows {pour VK_DELETE};

procedure ToolBar_AppuyerSurBoutonsSelectionnes(tb: TToolBar);
{appuie sur les boutons d'une barre d'outil (ça sert à réinitialiser des modes}

var i: integer;
Begin
    
    for i := 0 to tb.ButtonCount - 1 do
        if tb.Buttons[i].Down then
        Begin
            tb.Buttons[i].Click;
        End;
End;


procedure ToolBar_Enabled(tb: TToolBar; enabled: boolean);

var i: integer;
Begin
    
    for i := 0 to tb.ButtonCount - 1 do
        tb.Buttons[i].Enabled := enabled;

End;



procedure ToolBarButtonFromMenuItem(tbn: TToolButton; mnu: TMenuItem);
Begin
    tbn.Caption := mnu.Caption;
    tbn.ImageIndex := mnu.ImageIndex;
    tbn.Tag := mnu.Tag;
End;


procedure CBOBOXSelectionner(cbo: TComboBox; s: string);
var i:integer;
Begin
    for i := 0 to cbo.Items.Count-1 do
          if cbo.Items[i] = s then
          Begin
                cbo.ItemIndex := i;
                Exit;
          End;
End;



procedure MusicUser_PopupMenu_AfficherTitre(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
  Begin
     ACanvas.Brush.Color := $009900;
     ACanvas.FillRect(ARect);

     ACanvas.Font.Color := $FFFFFF;
     ACanvas.TextOut(ARect.Left, ARect.Top + 2, (Sender as TMenuItem).Caption);

  End;





  


Procedure IntegerEditBoxKeyPress(var EditBx: TEdit; var Key: Char);
Begin

      if Key = #8 then
      Begin
             if length(EditBx.Text) = 1 then
             Begin
                   EditBx.Text := '0';
                   EditBx.SelStart := 0;
                   EditBx.SelLength := 1;
                   Key := #0;
             End;

      End
      else if not (Key in ['0'..'9']) then
             Key := #0
      else
            if EditBx.Text = '0' then
            Begin
                  EditBx.Text := Key;
                  EditBx.SelStart := 1;
                  Key := #0;
            End;




End;



Procedure IntegerNonNulEditBoxKeyPress(var EditBx: TEdit; var Key: Char);
Begin

      if Key = #8 then
      Begin
             if length(EditBx.Text) = 1 then
             Begin
                   EditBx.Text := '1';
                   EditBx.SelStart := 0;
                   EditBx.SelLength := 1;
                   Key := #0;
             End;

      End
      else if not (Key in ['0'..'9']) then
             Key := #0;




End;



Procedure IntegerEditBoxKeyDown(var EditBx: TEdit; var Key: Word);
Begin
if Key = VK_DELETE then
       Key := 0;

End;



procedure IntegerNonNulEditBoxKeyDown(var EditBx: TEdit; var Key: Word);
Begin
    IntegerEditBoxKeyDown(EditBx, Key);
End;

end.
