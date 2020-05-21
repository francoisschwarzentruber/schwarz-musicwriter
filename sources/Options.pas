unit Options;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, CheckLst, ExtCtrls, ColorGrd, Grids, ImgList, ToolWin;



type
  TfrmOptions = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    chkCurseurDeplaceApresMiseDeNote: TCheckBox;
    TabSheet3: TTabSheet;
    chkCompleterAutomatiquementAvecPausesEnDebut: TCheckBox;
    TabSheet4: TTabSheet;
    chkRedessinerQuandScrollBar: TCheckBox;
    TabSheet5: TTabSheet;
    chkToutDessinerDansBitmapScrDabord: TCheckBox;
    Label5: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    chkHelp: TCheckBox;
    TabSheet8: TTabSheet;
    ColorDialog: TColorDialog;
    panCouleurCadreMesureCourante: TPanel;
    panCouleurFondMesureSelectionnee: TPanel;
    TreeView: TTreeView;
    chkTracerFondVoix: TCheckBox;
    chkAfficherCouleursNotes: TCheckBox;
    Label2: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    DrawGrid: TStringGrid;
    chkAfficherGriseeNoteDansVoixInactive: TCheckBox;
    Image1: TImage;
    TabSheet9: TTabSheet;
    tlbNumerotationMesures: TToolBar;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Label13: TLabel;
    TabSheet10: TTabSheet;
    Label1: TLabel;
    tlbAffichage_Nom_Portees: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ImageList2: TImageList;
    TabSheet11: TTabSheet;
    Label3: TLabel;
    tlbAffichage_Barres_Mesures: TToolBar;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ImageList3: TImageList;
    chkAffichage_Portees_Inactives_Grisees: TCheckBox;
    chkClavierElectroniqueActive: TCheckBox;
    Image2: TImage;
    imgClavierElectronique_Barre: TImage;
    chkCopierColler_AlaUnix_Utiliser_La_Fonctionnalite: TCheckBox;
    chkVoixInactive_ToujoursFondPlusClair: TCheckBox;
    ImageList4: TImageList;
    TabSheet2: TTabSheet;
    tlbPorteeCourante_ZoomActive_Quand_PartitionOrchestre: TToolBar;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    Label4: TLabel;
    Image3: TImage;
    imgSilencesAvantCurseur_Barre: TImage;
    tlbNotes_Ellipses_ou_Cercles: TToolBar;
    ToolButton13: TToolButton;
    ToolButton15: TToolButton;
    ImageList5: TImageList;
    Label6: TLabel;
    TabSheet12: TTabSheet;
    Label14: TLabel;
    tlbNoteAInsererAUneGrappe_Souris_Curseur: TToolBar;
    ToolButton14: TToolButton;
    ToolButton16: TToolButton;
    ImageList6: TImageList;
    TabSheet13: TTabSheet;
    Label15: TLabel;
    chkDemarrage_Jingle: TCheckBox;
    TabSheet14: TTabSheet;
    Label16: TLabel;
    TabSheet15: TTabSheet;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Label20: TLabel;
    Label21: TLabel;
    tkbSensibilite: TTrackBar;
    tkbTransposition: TTrackBar;
    procedure cmdOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure panCouleurCadreMesureCouranteClick(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkClavierElectroniqueActiveClick(Sender: TObject);
    procedure chkCompleterAutomatiquementAvecPausesEnDebutClick(
      Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmOptions: TfrmOptions;
  AToolBars: array[0..3] of TToolBar;


  procedure Options_BoiteDeDialogue_Afficher;
  procedure Options_BoiteDeDialogue_Afficher_EntreeMicrophone;



implementation

{$R *.DFM}

uses MusicUser, Main, Options_SaveAndLoad,
     MusicGraph_CouleursVoix, MusicWriter_Erreur, langues,
          MusicUser_PlusieursDocuments;



procedure Options_BoiteDeDialogue_Afficher;
Begin
    frmOptions.ShowModal;
End;

procedure Options_BoiteDeDialogue_Afficher_EntreeMicrophone;
Begin
    frmOptions.PageControl.ActivePageIndex := 14;
    frmOptions.ShowModal;
End;



procedure TfrmOptions.cmdOKClick(Sender: TObject);
begin
      INISave;
      if MusicWriter_IsFenetreDocumentCourante then
          actchild.ReaffichageComplet;
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
    INILoad;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
    procedure TreeViewExpand;
    var i: integer;
    Begin
           With TreeView.Items do
           for i := 0 to Count  - 1 do
               Item[i].Expand(true);


    End;

    procedure PageControl_Init;
    var i :integer;
    Begin
        for i := 0 to PageControl.PageCount - 1 do
             PageControl.Pages[i].TabVisible := false;
    End;
begin
    Langues_TraduireFenetre(self);

    AToolBars[0] := MainForm.tlbGeneral;
    AToolBars[1] := MainForm.tlbVoix ;
    AToolBars[2] := MainForm.tlbClefs ;
    AToolBars[3] := MainForm.tlbNuances ;

    TreeViewExpand;

    DrawGrid.Cells[1, 0] := 'Fond des listes';
    DrawGrid.Cells[2, 0] := 'Fond dans la part.';
    DrawGrid.Cells[3, 0] := 'Fond d''une voix non accessible';
    DrawGrid.Cells[4, 0] := 'Couleur des notes';

    DrawGrid.Cells[0, 1] := '1_1';
    DrawGrid.Cells[0, 2] := '1_2';
    DrawGrid.Cells[0, 3] := '1_3';
    DrawGrid.Cells[0, 4] := '1_4';

    DrawGrid.Cells[0, 5] := '2_1';
    DrawGrid.Cells[0, 6] := '2_2';
    DrawGrid.Cells[0, 7] := '2_3';
    DrawGrid.Cells[0, 8] := '2_4';

    PageControl_Init;
end;

procedure TfrmOptions.panCouleurCadreMesureCouranteClick(Sender: TObject);
var P: TPanel;
begin
       P := TPanel(Sender);

       ColorDialog.Color := P.Color;
       if ColorDialog.Execute then
             P.Color := ColorDialog.Color;
end;



procedure TfrmOptions.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
     PageControl.ActivePageIndex := Node.StateIndex;
end;


type PColor = ^TColor;

Function CellCoordToColorPointer(ACol, ARow: Integer): PColor;
Begin
    if Arow <= 0 then
       result := nil
    else

    case ACol of
         0: result := nil;

         1: result := @MusicGraph_CouleursVoix_tabCouleursVoixFondList[(Arow - 1) div 4,
                                                                  (Arow - 1) mod 4];

         2: result := @MusicGraph_CouleursVoix_tabCouleursVoixFond[(Arow - 1) div 4,
                                                                  (Arow - 1) mod 4];

         3: result := @MusicGraph_CouleursVoix_tabCouleursVoixNonAccessibleFond[(Arow - 1) div 4,
                                                                  (Arow - 1) mod 4];


         4: result := @MusicGraph_CouleursVoix_tabCouleursVoixNote[(Arow - 1) div 4,
                                                                  (Arow - 1) mod 4];
    end;
End;


procedure TfrmOptions.DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var p: PColor;

begin

    p := CellCoordToColorPointer(Acol, Arow);
    if p = nil then
     exit;
          
    DrawGrid.Canvas.Brush.color := p^;
    DrawGrid.Canvas.FillRect(Rect);
end;

procedure TfrmOptions.DrawGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Acol, ARow: integer;
    p: PColor;

begin
    DrawGrid.MouseToCell(X, Y, Acol, ARow);
    p := CellCoordToColorPointer(Acol, Arow);

    if p = nil then exit;

    ColorDialog.Color := P^;
    if ColorDialog.Execute then
             P^ := ColorDialog.Color;

    DrawGrid.Refresh; 
end;

procedure TfrmOptions.chkClavierElectroniqueActiveClick(Sender: TObject);
begin
    imgClavierElectronique_Barre.Visible := not chkClavierElectroniqueActive.Checked;
end;

procedure TfrmOptions.chkCompleterAutomatiquementAvecPausesEnDebutClick(
  Sender: TObject);
begin
     imgSilencesAvantCurseur_Barre.Visible := not chkCompleterAutomatiquementAvecPausesEnDebut.Checked;
end;

end.
