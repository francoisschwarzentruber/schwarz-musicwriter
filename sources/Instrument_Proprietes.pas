unit Instrument_Proprietes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, frame_Instruments_Choix, Buttons, ImgList,
  ToolWin, ExtCtrls, Menus;

type
  TfrmInstrument_Proprietes = class(TForm)
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    BitBtn3: TBitBtn;
    p: TPageControl;
    TabSheet3: TTabSheet;
    lstPortees: TListBox;
    Label3: TLabel;
    txtNom: TEdit;
    Label7: TLabel;
    txtMiniNom: TEdit;
    cboTransposition: TComboBox;
    Label1: TLabel;
    ToolBar1: TToolBar;
    tbnAddPortee: TToolButton;
    tbnAddPortee2: TToolButton;
    tbnDelPortee: TToolButton;
    ImageList: TImageList;
    frameInstruments_Choix: TframeInstruments_Choix;
    Panel1: TPanel;
    Image1: TImage;
    Label2: TLabel;
    PopupMenuClef: TPopupMenu;
    PopupMenuClef_Titre: TMenuItem;
    Clefdesol2: TMenuItem;
    Clefdefa2: TMenuItem;
    Clefdut2: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure lstPorteesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure tbnAddPorteeClick(Sender: TObject);
    procedure tbnAddPortee2Click(Sender: TObject);
    procedure tbnDelPorteeClick(Sender: TObject);
    procedure frameInstruments_ChoixChange;
    procedure FormCreate(Sender: TObject);
    procedure txtNomChange(Sender: TObject);
    procedure mnuClefClick(Sender: TObject);
    procedure PopupMenuClefPopup(Sender: TObject);
    procedure PopupMenuClef_TitreDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure BitBtn3Click(Sender: TObject);
    procedure frameInstruments_ChoixtxtInstrumentSubStrChange(
      Sender: TObject);
  private
    Function Instrument_Portee_Get: integer;
    Function Portees_Liste_Portee_Selectionnee: integer;
    procedure MettreAJourFenetre;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmInstrument_Proprietes: TfrmInstrument_Proprietes;

  procedure frmInstrument_Proprietes_ShowModal;

implementation

uses Instrument_Portee,
     MusicGraph_System {pour C},
     MusicGraph_Images {pour imgClefsPortees},
     MusicGraph_Portees,
     MusicGraph,
     MusicHarmonie,
     Main,
     MusicWriter_Erreur,
     MusicUser, MusicSystem_Composition_Portees_Liste {pour MusicWriter_IsOnQuitteleprogramme... c'est pour une bidouille},
     MusicSystem,
     langues,     MusicUser_PlusieursDocuments,
     InterfaceGraphique_Complements;

{$R *.dfm}





procedure frmInstrument_Proprietes_ShowModal;
Begin
     if frmInstrument_Proprietes = nil then
           frmInstrument_Proprietes := TfrmInstrument_Proprietes.Create(nil);
     frmInstrument_Proprietes.ShowModal;
End;


Function TfrmInstrument_Proprietes.Instrument_Portee_Get: integer;
Begin
     result := frmComposition_Instruments.frameComposition_Instruments.GetInstrument_Portee;
End;


procedure TfrmInstrument_Proprietes.MettreAJourFenetre;
var p1, p2, ip: integer;
Begin
      Caption := 'Propriétés de l''instrument ' +
            frmComposition_Instruments.frameComposition_Instruments.GetInstrument_To_Str;

      frmComposition_Instruments.frameComposition_Instruments.GetPortees(p1, p2);


      txtNom.Text := actchild.Composition.Portee_Nom[p1];
      frameInstruments_Choix.InstrumentNumero_Set(
            actchild.Composition.Portee_InstrumentMIDINum[p1]
                                                 );



      lstPortees.Clear;



      for ip := p1 to p2 do
            lstPortees.AddItem('', TObject(ip));


      tbnDelPortee.Enabled := not (p1 = p2);

End;


procedure TfrmInstrument_Proprietes.FormActivate(Sender: TObject);
begin
     MettreAJourFenetre;
     lstPortees.ItemIndex := 0;
end;



Function TfrmInstrument_Proprietes.Portees_Liste_Portee_Selectionnee: integer;
Begin

      With lstPortees do
      Begin
           if ItemIndex = -1 then
           Begin
               MessageErreur('arf');
               ItemIndex := 0;
           End;
           result := integer(Items.Objects[ItemIndex]);
      End;
End;



procedure TfrmInstrument_Proprietes.lstPorteesDrawItem(
  Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);

  const Clef_X = 5;
        PORTEE_LIGNE_PAS = 5;
        Zoom = 700;
  
  var ip: integer;


      
  Function GetY(i: integer): integer;
  Begin
      result := Rect.Top + 12 + i * 2*nbpixlign * Zoom div (prec* ZoomMaxPrec);
  End;



  procedure Lignes_Draw;
  var il: integer;
  Begin
     C.Pen.Color := 0; 
     for il := 1 to 5 do
     Begin
         C.MoveTo(Rect.Left, GetY(il));
         C.LineTo(Rect.Right, GetY(il));
     End;
  End;

  procedure Clef_Draw;
  var clef: TClef;
  Begin
       clef := actchild.Composition.I_Portee_Clef[ip] ;
       DrawBitmap(Clef_X*10, GetY(3)*10
                - DecalageClefPortee[clef]* Zoom div ZoomMaxPrec,
                imgClefsPortees[clef], Zoom);
  End;




begin


     ip := integer(lstPortees.Items.Objects[Index]);
     MusicGraph_Canvas_Set(lstPortees.Canvas);

     C.Brush.Style := bsSolid;
     C.Brush.Color := clWhite;
     C.FillRect(Rect);
    


     Lignes_Draw;


     SetPixOrigin(0, 0);
     pixxdeb := 0;
     pixydeb := 0;

     Clef_Draw;


end;

procedure TfrmInstrument_Proprietes.tbnAddPorteeClick(Sender: TObject);
var ip: integer;
begin
     ip := Portees_Liste_Portee_Selectionnee;
     actchild.Composition.I_Instruments_Portee_Ajouter(Instrument_Portee_Get,
                               Portees_Liste_Portee_Selectionnee);

     actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
     actchild.ReaffichageComplet;
     MettreAJourFenetre;
     lstPortees.ItemIndex := ip;
end;

procedure TfrmInstrument_Proprietes.tbnAddPortee2Click(Sender: TObject);
var ip: integer;
begin
     ip := Portees_Liste_Portee_Selectionnee + 1;
     actchild.Composition.I_Instruments_Portee_Ajouter(Instrument_Portee_Get,
                               Portees_Liste_Portee_Selectionnee + 1);
     actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
     actchild.ReaffichageComplet;
     frmComposition_Instruments.MettreAJourFenetre;
     MettreAJourFenetre;
     lstPortees.ItemIndex := ip;
end;


procedure TfrmInstrument_Proprietes.tbnDelPorteeClick(Sender: TObject);
var ip: integer;
begin
     ip := Portees_Liste_Portee_Selectionnee;
     actchild.Composition.I_Instruments_Portee_Supprimer(Instrument_Portee_Get,
                               Portees_Liste_Portee_Selectionnee);
     actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
     actchild.ReaffichageComplet;
     frmComposition_Instruments.MettreAJourFenetre;
     MettreAJourFenetre;
     lstPortees.ItemIndex := ip;
     if lstPortees.ItemIndex = -1 then
           lstPortees.ItemIndex := ip-1; 
end;











procedure TfrmInstrument_Proprietes.frameInstruments_ChoixChange;
var ip: integer;
begin
     if MusicWriter_IsOnQuitteleprogramme then exit;
     //bidouille, c'est un peu moche mais ça évite un plantage en fin de programme
     
     MessageErreurSiPasDeFenetreActive('frameInstruments_ChoixChange');

     ip := Instrument_Portee_Get;

     if ip < 0 then ip := 0;


     actchild.Composition.I_Instruments_Instrument_Num_Set(ip,
                          frameInstruments_Choix.InstrumentNumero_Get);
     frmComposition_Instruments.MettreAJourFenetre;
end;













procedure TfrmInstrument_Proprietes.FormCreate(Sender: TObject);
begin
    Langues_TraduireFenetre(self);
    frameInstruments_Choix.OnChange := frameInstruments_ChoixChange;
end;











procedure TfrmInstrument_Proprietes.txtNomChange(Sender: TObject);
begin
      actchild.Composition.I_Instruments_Nom_Set(Instrument_Portee_Get, txtNom.Text);
      frmComposition_Instruments.MettreAJourFenetre;
end;

procedure TfrmInstrument_Proprietes.mnuClefClick(Sender: TObject);
begin
     actchild.Composition.I_Portee_Clef[Portees_Liste_Portee_Selectionnee] :=
                                              TClef(TMenuItem(Sender).Tag);

     actchild.ReaffichageComplet;

     lstPortees.Refresh;

     
end;

procedure TfrmInstrument_Proprietes.PopupMenuClefPopup(Sender: TObject);
var ip: integer;
begin
      ip := Portees_Liste_Portee_Selectionnee;

         PopupMenuClef_Titre.Caption := 
         ClefToStr(
            actchild.Composition.I_Portee_Clef[ip]
             )
             +
           ' de la portée n° ' +
           inttostr(ip + 1);
end;

procedure TfrmInstrument_Proprietes.PopupMenuClef_TitreDrawItem(
  Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
        MusicUser_PopupMenu_AfficherTitre(Sender, ACanvas, ARect, Selected);
end;

procedure TfrmInstrument_Proprietes.BitBtn3Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmInstrument_Proprietes.frameInstruments_ChoixtxtInstrumentSubStrChange(
  Sender: TObject);
begin
  frameInstruments_Choix.txtInstrumentSubStrChange(Sender);

end;

end.
