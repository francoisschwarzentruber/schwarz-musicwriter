unit MusicWriter_Aide;

interface


Procedure Aide_MessageInformation_Afficher(str: String);

Procedure Aide_Afficher(str: String; x, y, ecart: integer);
procedure Aide_Params_Ajouter(str: string);

Procedure Aide_Cacher;
procedure Aide_Cacher_Apriori;

procedure Aide_AfficherSurMainForm(str: string; x, y, ecart: integer);

procedure Aide_Boucle;


var lastHelp: string;




implementation

uses Main, Options_SaveAndLoad, help, musicUser {pour dossierracine},
     SysUtils {pour inttostr},
     MusicWriter_Console;


var ParamAide : array of string;
    AideCachee: Boolean = false;



procedure Aide_AfficherSurMainForm(str: string; x, y, ecart: integer);
Begin

    Aide_Afficher(str, x + MainForm.Left,
    y + MainForm.Top + 40 {ecart du à la barre de titre et de menus}, ecart);

End;



Function Is_Aide_Affichee: Boolean;
Begin
    if frmHelp = nil then
        result := false
    else
        result := (not AideCachee) and frmHelp.VisibleAMoi;
End;



procedure Aide_Params_Reset;
Begin
       Setlength(ParamAide, 0);
End;

procedure Aide_Params_Ajouter(str: string);
Begin
    Setlength(ParamAide, length(ParamAide)+1);
    ParamAide[high(ParamAide)] := str;
End;





Procedure Aide_Afficher_Sub(str: String; x, y, ecart: integer);
var i,p: integer;



   procedure Regler_Taille_Fenetre;
   var nx, ny, newheight: integer;
   Begin
     With frmHelp do
     Begin
     newheight := txtMess.Lines.Count * 16 + 10;

     Shape.Height := newheight;
     txtMess.Height := newheight - 15;
     if x + Width > MainForm.Left + MainForm.Width then
     Begin
    //     Top := y;
         nx := x - Width - 16;
         if nx < 0 then
            nx := x + 16;

         SetBounds(nx, y, Width, newheight);
  //       Left := nx;
     End
     else
     Begin

     //    Left := x;

         ny := y - Height - 64;
         if ny < 0 then
             ny := y + 128;
        // Top := ny;

         SetBounds(x, ny, Width, newheight);
     End;
     End;
   End;

Begin





       if frmHelp = nil then
            frmHelp := TfrmHelp.Create(nil);  

       if not ((lastHelp = str) and Is_Aide_Affichee) then
          Begin

                 if lastHelp <> str then
                 Begin
                     frmHelp.txtMess.Lines.LoadFromFile(DossierRacine + 'interface_help\' + str + '.rtf');

                      for i := 1 to length(ParamAide) do
                      Begin
                          repeat
                              p := Pos('##' + inttostr(i), Copy(frmHelp.txtMess.Text,1,100000));
                              if p > 0 then
                              Begin
                                  frmHelp.txtMess.SelStart := p-1;
                                  frmHelp.txtMess.SelLength := 3;
                                  frmHelp.txtMess.SelText := ParamAide[i-1];
                              End;
                          until p = 0;

                      End;
                 End;

                 Regler_Taille_Fenetre;

                 MainForm.tmrHelp.Enabled := true;
                 AideCachee := false;
                 lastHelp :=  str;
                 frmHelp.tmrAfficher.enabled := true;
            End;

       Aide_Params_Reset;


End;


Procedure Aide_MessageInformation_Afficher(str: String);
Begin
     Aide_Afficher_Sub(str, 0, 0, 0);

     frmHelp.visible := true;
    MainForm.SetFocus;
End;

Procedure Aide_Afficher(str: String; x, y, ecart: integer);
Begin
     if AfficherBulleDaide then
          Aide_Afficher_Sub(str, x, y, ecart)
     else
          Aide_Params_Reset;
End;


Procedure Aide_Cacher;
Begin
     if frmHelp = nil then exit;
     //frmHelp.Hide;
     frmHelp.HideAMoi;
     AideCachee := true;
End;


Procedure Aide_Cacher_Apriori;
Begin
   if not MainForm.tmrHelp.Enabled then
       AideCachee := true;

   if frmHelp.tmrAfficher.Enabled then
       AideCachee := false;

   {if frmHelp <> nil then
       frmHelp.tmrAfficher.Enabled := false; }
End;


procedure Aide_Boucle;
Begin
    if AideCachee then
      Begin
            Console_AjouterLigne('on cache l''aide');

            if frmHelp <> nil then
                 frmHelp.HideAMoi;
                // frmHelp.Hide;
      End;
End;




end.
