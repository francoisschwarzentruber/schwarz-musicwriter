unit Nouveau_Assistant;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, ExtCtrls, ToolWin, MusicSystem_Composition,
  frame_Rythme, frame_Tonalite, frame_Instruments_Choix;

type
  TfrmNouveau_Assistant = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    lstInstruments: TListView;
    Label1: TLabel;
    Label2: TLabel;
    txtInstrumentSubStr: TEdit;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    cmdPasser: TButton;
    Label5: TLabel;
    Label6: TLabel;
    txtTitre: TEdit;
    cmdSuivant: TButton;
    cmdPrecedent: TButton;
    Label8: TLabel;
    ToolBar1: TToolBar;
    tlbSuppr: TToolButton;
    tlbSupprTout: TToolButton;
    tlbVersleHaut: TToolButton;
    tlbVersleBas: TToolButton;
    PaintBox: TPaintBox;
    Button1: TButton;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    Label11: TLabel;
    ImageList: TImageList;
    lstMesInstruments: TListBox;
    frameTonalite: TframeTonalite_Anneau;
    frameRythme: TframeRythme;
    Panel1: TPanel;
    Image1: TImage;
    imgDrapeau1: TImage;
    imgDrapeau2: TImage;
    imgDrapeau3: TImage;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Image3: TImage;
    procedure txtInstrumentSubStrChange(Sender: TObject);
    procedure lstMesInstrumentsDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure lstMesInstrumentsDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cmdPasserClick(Sender: TObject);
    procedure cmdPrecedentClick(Sender: TObject);
    procedure cmdSuivantClick(Sender: TObject);
    procedure tlbSupprClick(Sender: TObject);
    procedure tlbSupprToutClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure txtTitreChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lstInstrumentsDblClick(Sender: TObject);

    procedure tlbVersleHautClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstMesInstrumentsDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure tlbVersleBasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    CompositionEnCreation: TComposition;

    procedure Precedent_Suivant_Gerer;

    procedure lstMesInstruments_Vider;
    Function lstMesInstruments_IsVide: Boolean;

    procedure lstInstruments_Actualiser;
    procedure lstMesInstruments_AjouterInstrument(i, pos_in_mesinstruments: integer);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmNouveau_Assistant: TfrmNouveau_Assistant;


procedure frmNouveauAssistant_Afficher;







implementation

uses MusicGraph_Images,
     instruments,
     MusicGraph,
     MusicGraph_System {pour C}, Main,
     MusicHarmonie {pour CLEF_PAR_DEFAUT},
     MusicGraph_Portees{pour IGP}, MusicSystem_Mesure ,
     QSystem, MusicSystem_MesureBase {pour DivDivEucl},

     Message_Vite_Fait,
     langues;



const lstMesInstruments_Message_QuandVide = '(déposer des instruments ici)';
      lstMesInstruments_Message_QuandVide_Indice = 19023;
{$R *.dfm}



procedure frmNouveauAssistant_Afficher;
Begin
   if frmNouveau_Assistant = nil then
       frmNouveau_Assistant := TfrmNouveau_Assistant.Create(nil);

   frmNouveau_Assistant.ShowModal;
End;



procedure TfrmNouveau_Assistant.lstInstruments_Actualiser;
var item : TListItem;
    i: integer;
    s: string;
    substr: string;
Begin
     lstInstruments.Items.BeginUpdate;

     lstInstruments.Clear;

     substr := LowerCase(txtInstrumentSubStr.Text);
     for i := 0 to INSTRUMENTS_INDICE_MAX do
     if IsInstrument_DansListeStandard(i) then
     Begin
         s := GetInstrumentNom(i);

         if (substr = '') or (Pos(substr, LowerCase(s)) <> 0) then
         Begin
               item := lstInstruments.Items.Add;
               item.ImageIndex := i + 1;
               item.Caption := s;
         End;

     End;
     lstInstruments.Items.EndUpdate;
ENd;


procedure TfrmNouveau_Assistant.txtInstrumentSubStrChange(Sender: TObject);
begin
    lstInstruments_Actualiser;

end;


procedure TfrmNouveau_Assistant.lstMesInstruments_AjouterInstrument(i, pos_in_mesinstruments : integer);


Begin
     if lstMesInstruments_IsVide then
          lstMesInstruments.Clear;

     if pos_in_mesinstruments > lstMesInstruments.Items.Count then
                pos_in_mesinstruments := lstMesInstruments.Items.Count ;

     if pos_in_mesinstruments < 0 then
         pos_in_mesinstruments := 0;
         
     lstMesInstruments.Items.InsertObject(pos_in_mesinstruments, GetInstrumentNom(i), TObject(i));

End;


procedure TfrmNouveau_Assistant.lstMesInstruments_Vider;
Begin
    lstMesInstruments.Clear;
    lstMesInstruments.Items.InsertObject(0,
                                         Langues_Traduire(lstMesInstruments_Message_QuandVide),
                                         TObject(lstMesInstruments_Message_QuandVide_Indice));
End;



Function TfrmNouveau_Assistant.lstMesInstruments_IsVide: Boolean;
Begin
    result := (lstMesInstruments.Items.Count = 1) and
              (lstMesInstruments.Items[0] = Langues_Traduire(lstMesInstruments_Message_QuandVide));
End;



procedure TfrmNouveau_Assistant.lstMesInstrumentsDragDrop(Sender,
  Source: TObject; X, Y: Integer);
  var nouvelle_pos: integer;
  
begin
     nouvelle_pos := lstMesInstruments.ItemAtPos(Point(X, Y), false);

     nouvelle_pos := max(0, min(nouvelle_pos, lstMesInstruments.Count));

     if Source is TListBox then
     Begin
         if lstMesInstruments.ItemIndex >= 0 then
         lstMesInstruments.Items.Move(lstMesInstruments.ItemIndex,
                                      nouvelle_pos)
     End
     else

     lstMesInstruments_AjouterInstrument((Source as TListView).ItemFocused.ImageIndex - 1,
                                           nouvelle_pos);

          
end;



procedure TfrmNouveau_Assistant.lstMesInstrumentsDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
      if Source is TListView then Accept := true;
end;





procedure TfrmNouveau_Assistant.cmdPasserClick(Sender: TObject);
begin
    if lstInstruments.ItemFocused = nil then
        Message_Vite_Fait_Beep_Et_Afficher('Vous devez sélectionner un instrument dans la liste de gauche pour l''ajouter dans votre future partition.')
    else
    lstMesInstruments_AjouterInstrument(lstInstruments.ItemFocused.ImageIndex - 1, 10000);
end;

procedure TfrmNouveau_Assistant.cmdPrecedentClick(Sender: TObject);
begin
    PageControl.ActivePageIndex := PageControl.ActivePageIndex - 1;

    Precedent_Suivant_Gerer;
end;

procedure TfrmNouveau_Assistant.cmdSuivantClick(Sender: TObject);

   procedure CompositionEnCreation_Portees_Gerer;
   var i, instru: integer;
   Begin
       CompositionEnCreation.Portees_Reset;

       for i := 0 to lstMesInstruments.Items.Count - 1 do
       Begin
           instru := integer(lstMesInstruments.Items.Objects[i]);

            if Is_Instrument_Guitare(instru) then
               CompositionEnCreation.Portees_AjouterGroupePorteesNormalPlusTablature_Fin(instru)
            else if Is_Instrument_Clavier(instru) then
               CompositionEnCreation.Portees_AjouterGroupePorteesClavier_Fin(instru)
            else
               CompositionEnCreation.Portees_AjouterFin(instru, GetInstrument_ClefParDefaut(instru));
       End;

       MusicGraph_Canvas_Set(Canvas);
       IGP := CompositionEnCreation;
       CompositionEnCreation.CalcTout(true);
   End;

begin


   if PageControl.ActivePageIndex = PageControl.PageCount - 1 then
   Begin
       IGP := CompositionEnCreation;

       With CompositionEnCreation.GetMesure(0) do
       Begin
            SetTonalite(frameTonalite.Tonalite_Get);
            Rythme := frameRythme.Rythme;
       End;

       MainForm.Fichier_NouveauDocument(CompositionEnCreation);
       Close;

   End;


   if PageControl.ActivePageIndex = 0 then
   {on veut valider l'entrée des instruments}
   Begin
       if lstMesInstruments_IsVide then
       Begin
            ShowMessage(Langues_Traduire('Vous n''avez pas entré d''instruments ! Qui va donc jouer votre oeuvre ?'));
            exit;
       End;
   End;
   CompositionEnCreation_Portees_Gerer;

   
   PageControl.ActivePageIndex := PageControl.ActivePageIndex + 1;

   Precedent_Suivant_Gerer;



   
end;



procedure TfrmNouveau_Assistant.Precedent_Suivant_Gerer;
Begin
   cmdPrecedent.Enabled := (PageControl.ActivePageIndex > 0);


   if PageControl.ActivePageIndex = PageControl.PageCount - 1 then
       cmdSuivant.Caption := Langues_Traduire('Créer la partition')
   else
       cmdSuivant.Caption := Langues_Traduire('Suivant >>');

   imgDrapeau2.Visible := (PageControl.ActivePageIndex >= 1);
   imgDrapeau3.Visible := (PageControl.ActivePageIndex >= 2);
End;



procedure TfrmNouveau_Assistant.tlbSupprClick(Sender: TObject);
begin
     if lstMesInstruments.ItemIndex < 0 then
          Message_Vite_Fait_Beep_Et_Afficher('Vous devez sélectionner un instrument pour le supprimer.')
     else
          lstMesInstruments.DeleteSelected;

     if lstMesInstruments.Items.Count = 0 then
            lstMesInstruments_Vider;
end;

procedure TfrmNouveau_Assistant.tlbSupprToutClick(Sender: TObject);
begin
    if lstMesInstruments_IsVide then
         Message_Vite_Fait_Beep_Et_Afficher('La liste des instruments est vide : il n''y a rien à supprimer.')
    else
         lstMesInstruments_Vider;
end;

procedure TfrmNouveau_Assistant.PaintBoxPaint(Sender: TObject);
begin
    MusicGraph_Canvas_Set(PaintBox.Canvas);
    Zoom := 30;

    pixxdeb := 0;
    pixydeb := 0;

    AfficherPartition(CompositionEnCreation, 0, 0, -10, 10000);

end;

procedure TfrmNouveau_Assistant.txtTitreChange(Sender: TObject);
begin
    CompositionEnCreation.Nom := txtTitre.text;
    PaintBox.Repaint;
end;

procedure TfrmNouveau_Assistant.Button1Click(Sender: TObject);
begin
    CHeight := 200000;

    Main.frmOuvrir.TabControl.TabIndex := 0;
    Main.frmOuvrir.TabControlChange(nil);
    if Main.frmOuvrir.showmodal <> mrCancel then
    Begin
          MainForm.OuvrirPartitionExistante(Main.frmOuvrir.filename,
                                            Main.frmOuvrir.OpenAsModel);
                                            
          Close;

    End;
end;

procedure TfrmNouveau_Assistant.lstInstrumentsDblClick(Sender: TObject);
begin
     if lstInstruments.ItemFocused = nil then
     Begin
           Message_Vite_Fait_Beep_Et_Afficher('Il faut double-cliquer sur un instrument pour l''ajouter à la future partition.');
           exit;
       End;

       
     lstMesInstruments_AjouterInstrument(lstInstruments.ItemFocused.ImageIndex - 1,
     lstMesInstruments.Count-1);
end;








procedure TfrmNouveau_Assistant.tlbVersleHautClick(Sender: TObject);
var i: integer;

begin
   i := lstMesInstruments.ItemIndex;

   if (i <= 0) or (i > lstMesInstruments.Items.Count - 1) then
     Begin
         Message_Vite_Fait_Beep_Et_Afficher('L''instrument sélectionné est déjà tout en haut');
         Exit;
     End;

    lstMesInstruments.Items.Move(i, i-1);
    lstMesInstruments.ItemIndex := i - 1;


end;

procedure TfrmNouveau_Assistant.FormShow(Sender: TObject);
begin
     CompositionEnCreation := TComposition.Create;
     PageControl.ActivePageIndex := 0; 
     lstInstruments_Actualiser;
     Precedent_Suivant_Gerer;
end;

procedure TfrmNouveau_Assistant.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
      lstMesInstruments_Vider;
end;

procedure TfrmNouveau_Assistant.lstMesInstrumentsDrawItem(
  Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
  var i_instru: integer;
begin
      i_instru := integer(lstMesInstruments.Items.Objects[Index]);
      lstMesInstruments.Canvas.Pen.Color := rgb(255,255,255);
      lstMesInstruments.Canvas.Rectangle(Rect);

      if i_instru <> lstMesInstruments_Message_QuandVide_Indice then
      Begin
            MainForm.imgIconesInstruments.Draw(lstMesInstruments.Canvas,Rect.Left, Rect.top,i_instru+1);
            lstMesInstruments.Canvas.TextOut(Rect.Left+20, Rect.top+1, lstMesInstruments.Items[index]);
      End
      else
            lstMesInstruments.Canvas.TextOut(Rect.Left, Rect.top+1, lstMesInstruments.Items[index]);
end;

procedure TfrmNouveau_Assistant.tlbVersleBasClick(Sender: TObject);
var i : integer;
begin
   i := lstMesInstruments.ItemIndex;

   if (i < 0) or (i >= lstMesInstruments.Items.Count - 1) then
     Begin
         Message_Vite_Fait_Beep_Et_Afficher('L''instrument sélectionné est déjà tout en bas');
         Exit;
     End;

    lstMesInstruments.Items.Move(i, i+1);
    lstMesInstruments.ItemIndex := i + 1;
end;

procedure TfrmNouveau_Assistant.FormCreate(Sender: TObject);
begin
      Langues_TraduireFenetre(self);

      frameTonalite.Tonalite_Set(0);

      lstInstruments.LargeImages := MainForm.imgIconesInstruments;
      lstInstruments.SmallImages := MainForm.imgIconesInstruments;
      lstMesInstruments_Vider;

end;

end.
