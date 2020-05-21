unit Imprimer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MusicSystem_Composition, MusicGraph, MusicGraph_System,
  Printers, ExtCtrls, ComCtrls, Buttons, CheckLst;

type
  TfrmImprimer = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label5: TLabel;
    txtPageFrom: TEdit;
    txtPageTo: TEdit;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    txtZoomImpression: TEdit;
    Label3: TLabel;
    Label10: TLabel;
    txtResolutionHorizontale: TEdit;
    Label11: TLabel;
    txtResolutionVerticale: TEdit;
    PrinterSetupDialog: TPrinterSetupDialog;
    Button6: TButton;
    chkPrintInFile: TCheckBox;
    BitBtn3: TBitBtn;
    Label12: TLabel;
    txtImprimanteNom: TEdit;
    Panel1: TPanel;
    CheckListBox1: TCheckListBox;
    ComboBox1: TComboBox;
    Button1: TButton;
    Label13: TLabel;
    Label14: TLabel;
    procedure MettreAJour;
    
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmImprimer: TfrmImprimer;


implementation



uses Main, MusicUser, Childwin, MusicGraph_Portees {pour margehaut},
     MusicSystem_Composition_Portees_Liste {pour les accolades},
          MusicUser_PlusieursDocuments;


{$R *.DFM}
var ResolutionHorizontale, ResolutionVerticale, ZoomImpression: integer;
    b: TBitmap;
    Imprimante: TPrinter;
  ListePages: array of integer;
  comp: TComposition;

procedure SurCoucheBeginDoc;
{s'occupe de commencer l'impression d'un document
  cette procédure est de haut niveau : elle gère aussi bien l'impression
  réelle que l'impression dans un fichier BMP, via "PrintInFile"}
Begin
    if PrintInFile then
    Begin
        b := TBitmap.Create;
        Zoom := strtoint(frmImprimer.txtZoomImpression.Text);
//        Zoom := factprintinfile * 100;
        b.width := (largutilisable+2*margehaut)*factprintinfile div prec;
        b.Height := (hauteurpage + 2*margehaut) *factprintinfile div prec;

        MusicGraph_Canvas_Set(b.Canvas);


    End
    else
    Begin
        Imprimante := Printer;
        With Imprimante do
        Begin
           BeginDoc;
           Zoom := ZoomImpression;
           //Zoom := factimprimante * 100;
           //SetMapMode( Printer.Canvas.Handle, mm_lometric );
           MusicGraph_Canvas_Set(Imprimante.Canvas);
        end;                      

    End;
End;


procedure SurCoucheEndDoc(numpage: integer);
{termine l'impression d'un document}
Begin
     if PrintInFile then
     Begin
          b.SaveToFile(DossierRacine + 'printbmp\' + inttostr(numpage) + '.bmp');

     End
     else
        Imprimante.EndDoc;
End;



procedure SurCoucheNewPage(numpage: integer);
{permet de passer à une autre page...}
Begin
     if PrintInFile then
     Begin
          //il y a un appel à "EndDoc" pour enregistrer le fichier BMP
          SurCoucheEndDoc(numpage);

          MusicGraph_Canvas_Set(b.Canvas);
          //puis on efface tout pour recommencer à dessiner sur la nouvelle page
          C.Brush.Style := bsSolid;
          C.Brush.Color := RGB(255,255,255);
          C.FillRect(Rect(-10,-10,10000,10000));

     End
     else
     Begin
        Imprimante.NewPage;
        Zoom := ZoomImpression;
        {il vaut mieux remettre les infos du zoom... car j'ai l'impression
         que NewPage laisse traiter les événements windows et donc...
         ça rafraichit la fenêtre... et ça fausse tout...}

        MusicGraph_Canvas_Set(Imprimante.Canvas);
     End;
End;





procedure ImprimerSub( Comp: TComposition);
const ImprimerNumPage = true;
var
    i,p:integer;
    iLigne1, iLigne2: integer;


Begin
    Comp.CalcTout(true);

    for i := 0 to high(ListePages) do
    Begin
         p := ListePages[i]-1;

         SetViewCourantPixDebModeImpression(-feuillemargegauche, p*hauteurpage - feuillemargehaut);
         C.Brush.Style := bsClear;
         C.Font.Size := 10;

         if ImprimerNumPage then
               C.TextOut(feuillemargegauche*Zoom div ZoomMaxPrec + (largutilisable*Zoom div ZoomMaxPrec)*(ListePages[i] mod 2),
                         (feuillemargehaut*Zoom div ZoomMaxPrec) div 2,
                         inttostr(ListePages[i]));
                                 //à revoir...

         Comp.IntervalleiLignesurPage(p, iLigne1, iLigne2);
         if i = high(ListePages) then
         {en fin d'impression, pas besoin de sortir une nouvelle page,
         car c'est la dernière (NewPage)   }
             AfficherPartitionToutesLesLignes(Comp, iLigne1, iLigne2)
         else
         Begin
             AfficherPartitionToutesLesLignes(Comp, iLigne1, iLigne2);
             SurCoucheNewPage(p);
         End;

    End;
End;



procedure PrintPartition;
Begin
      CHeight := 200000;

      {PrintDialog.MinPage := 1;
      PrintDialog.MaxPage := high(Comp.Lignes) div nblignesparpage + 1;

      PrintDialog.FromPage := 1;
      PrintDialog.ToPage := PrintDialog.MaxPage;   }

      //if PrintDialog.Execute then

      CDevice := devImprimante;


      SurCoucheBeginDoc;
      {C'est dans SurCoucheBeginDoc que l'on associe le canvas à :
       - une imprimante
       - ou un bitmap
       (selon l'option choisi)}

      C.Pen.Color := 0;
      C.Brush.Style := bsSolid;
      C.Brush.Color := 0;



       ImprimerSub(Comp);

      SurCoucheEndDoc(32000); //la dernière page a pour numéro 32000 (très grand)
      CDevice := devEcran;


     // Zoom := strtoint(MainForm.cboZoom.Text); A REVOIR

End;







procedure TfrmImprimer.Button3Click(Sender: TObject);
var nbpage, premierepage, i: integer;

begin
premierepage := strtoint(txtPageFrom.text);
nbpage := 1 + strtoint(txtPageTo.text) - premierepage;

setlength(ListePages, (nbpage-1) div 2+1);

for i := 0 to high(ListePages) do
       Listepages[i] := premierepage + 2*i;

PrintInFile := chkPrintInFile.Checked;
PrintPartition;

end;

procedure TfrmImprimer.Button2Click(Sender: TObject);
var nbpage, premierepage, i: integer;

begin
premierepage := strtoint(txtPageFrom.text);  //doit être impair
nbpage := 1 + strtoint(txtPageTo.text) - premierepage;

setlength(ListePages, nbpage div 2);

for i := 0 to high(ListePages) do
       Listepages[i] := premierepage + 1+2*i;

PrintInFile := chkPrintInFile.Checked;
PrintPartition;
end;

procedure TfrmImprimer.Button4Click(Sender: TObject);
var nbpage, premierepage, i: integer;

begin
premierepage := strtoint(txtPageFrom.text);
nbpage := 1 + strtoint(txtPageTo.text) - premierepage;

{on crée la liste de pages à imprimer}
setlength(ListePages, nbpage);

for i := 0 to nbpage-1 do
     ListePages[i] := premierepage + i;

PrintInFile := chkPrintInFile.Checked;
PrintPartition;
end;



procedure TfrmImprimer.MettreAJour;
var px: integer;
Begin
    comp := actchild.Composition;

   txtPageTo.text := inttostr(Comp.iPageFromiLigne(Comp.NbLignes - 1) + 1);
   txtPageFrom.text := '1';

   {calcul des caractéristiques de l'imprimante}
   ResolutionHorizontale := GetDeviceCaps (Printer.handle, HORZRES);
   ResolutionVerticale := GetDeviceCaps (Printer.handle, VERTRES);

   txtImprimanteNom.Text := Printer.Printers[Printer.PrinterIndex];

   factimprimantePourlesPolices := 12 * ResolutionHorizontale / 9916; 
   px := GetDeviceCaps (Printer.handle, PHYSICALWIDTH);
   ZoomImpression := px * ZoomMaxPrec div (largutilisable + 2*feuillemargegauche);



   txtResolutionHorizontale.text := inttostr(ResolutionHorizontale);
   txtResolutionVerticale.text := inttostr(ResolutionVerticale);
   txtZoomImpression.Text := inttostr(ZoomImpression);
   
End;

procedure TfrmImprimer.FormShow(Sender: TObject);
begin
 MettreAJour;

end;

procedure TfrmImprimer.Button5Click(Sender: TObject);
var nbpage, j, i: integer;
    Comp: TComposition;
    View:TView;
    maportee: integer;
    PasDePartieIndependanteAImprimer: Boolean;
begin
    CHeight := 200000;
    CDevice := devImprimante;

    SurCoucheBeginDoc;
    {C'est dans SurCoucheBeginDoc que l'on associe le canvas à :
     - une imprimante
     - ou un bitmap
     (selon l'option choisi)}

    C.Pen.Color := 0;
    C.Brush.Style := bsSolid;
    C.Brush.Color := 0;


    {on déactive les timers}
    For j := 0 to MainForm.MDIChildCount-1 do
            (MainForm.MDIChildren[j] as TMDIChild).tmrAffichageClignotant.Enabled := true;


    View.Zoom := ZoomImpression;
    PrintInFile := chkPrintInFile.Checked;
    For j := 0 to MainForm.MDIChildCount-1 do
    Begin
    {on parcourt les fenêtres ie les documents ouverts}

        Comp := (MainForm.MDIChildren[j] as TMDIChild).Composition;

        maportee := -1;
        while( maportee < Comp.NbPortees ) do
        Begin
        {on parcourt les portées, ou plus exactement les groupes de portées}
        {la politique générale est la suivante :
           si maportee = -1, on imprime toute la partition (le conducteur en fait)
           sinon,
           si maportee est le début d'un groupe de portées avec 2,3... portées
               on n'imprime pas de parties séparées
               (en clair, genre le piano n'a pas de partie séparée mais tient le
                conducteur)
           si maportee est le début d'"un groupe de portées" avec 1 portée,
                alors on imprime effectivement une partie indépendante} 
              PasDePartieIndependanteAImprimer := false;
              View.ModeAffichage := maPage;
              if maportee = -1 then //impression du conducteur
              Begin
                   LesPorteesSontDessinesAZoomDefaut := false;

                    for i := 0 to high(View.VoixAffichee) do
                         View.VoixAffichee[i] := true;

                    maportee := 0;

              End
              else if (Comp.Portee_GetNbPorteesInGroupe(maportee) = 0) or
                      (Comp.Portee_GetTypeAccolade(maportee) = taCrochet) then
              Begin //impression de la partie "portée n° i"

                    for i := 0 to high(View.VoixAffichee) do
                         View.VoixAffichee[i] := (i mod Comp.NbPortees) = maportee;

                    LesPorteesSontDessinesAZoomDefaut := true;

                    inc(maportee,  1);
              End
              else
              Begin
                   PasDePartieIndependanteAImprimer := true;
                       inc(maportee,
                           1 + Comp.Portee_GetNbPorteesInGroupe(maportee));
              End;
                   
              if not PasDePartieIndependanteAImprimer then
              Begin
                    SetView(View);
                    Comp.CalcTout(true); //on calcule la position des objets dans la composition



                    nbpage := Comp.iPageFromiLigne(Comp.NbLignes - 1) + 1;

                    {on crée la liste de pages à imprimer}
                    setlength(ListePages, nbPage);

                    for i := 0 to nbpage-1 do
                         ListePages[i] := 1 + i;


                    ImprimerSub(Comp);

                   // if(j < MainForm.MDIChildCount  - 1) then
                        SurCoucheNewPage(32000);
              End;

        end;
     End;



    SurCoucheEndDoc(32000); //la dernière page a pour numéro 32000 (très grand)
    CDevice := devEcran;


    //Zoom := strtoint(MainForm.cboZoom.Text); A REVOIR
    LesPorteesSontDessinesAZoomDefaut := false;
End;

procedure TfrmImprimer.Button6Click(Sender: TObject);
begin
   PrinterSetupDialog.Execute;
   MettreAJour;

end;

end.
