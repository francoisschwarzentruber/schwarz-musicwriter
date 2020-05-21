unit nuances;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons;

type
  TfrmNuances = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    imgDe: TImage;
    trkDebut: TTrackBar;
    cmdApply: TButton;
    cmdCancel: TButton;
    trkFin: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    imgDegradeNuance: TImage;
    btnEchanger: TBitBtn;
    Label8: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    lblApartirDe: TLabel;
    lblJusqua: TLabel;
    procedure cmdApplyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnEchangerClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmNuances: TfrmNuances;



  procedure frmNuances_Show;




  
implementation

uses main,  QSystem, MusicSystem_CompositionListeObjetsGraphiques,
     MusicUser_PlusieursDocuments;

{$R *.DFM}



procedure frmNuances_Show;
Begin
    if frmNuances = nil then
        frmNuances := TfrmNuances.Create(nil);

    frmNuances.ShowModal;
End;

procedure TfrmNuances.cmdApplyClick(Sender: TObject);

    Function VelociteToNuance(v: integer): TNuanceValeur;
    Begin
        result := TNuanceValeur(integer(nvRebus) * v div 128);
    End;

    
begin
if not MusicWriter_IsFenetreDocumentCourante then exit;

if PageControl.ActivePageIndex = 0 then
       actchild.GraphicObjet_SousCurseur_Get.Nuance_Set(VelociteToNuance(trkDebut.Position))

else
Begin
    actchild.GraphicObjet_SousCurseur_Get.Crescendo_Set;

End;

actchild.ReaffichageComplet;
end;

procedure TfrmNuances.FormShow(Sender: TObject);
begin
    if not MusicWriter_IsFenetreDocumentCourante then exit;

    with actchild.GraphicObjet_SousCurseur_Get.Pts[0] do
        lblApartirDe.Caption := 'à partir de la mesure n° ' +
           inttostr(imesure + 1) +
           ', au temps ' + QToStr(temps);

    if actchild.GraphicObjet_SousCurseur_Get.IsCrescendoOrDecrescendo then
    with actchild.GraphicObjet_SousCurseur_Get.Pts[1] do
        lblJusqua.Caption := 'jusqu''à la mesure n° ' +
           inttostr(imesure + 1) +
           ', au temps ' + QToStr(temps)
    else
        lblJusqua.Caption := '';
        
    actchild.ReaffichageComplet;
end;

procedure TfrmNuances.FormHide(Sender: TObject);
begin
    if not MusicWriter_IsFenetreDocumentCourante then exit;

    actchild.ReaffichageComplet;
end;



procedure TfrmNuances.btnEchangerClick(Sender: TObject);
var tmp: integer;
begin
   tmp := trkDebut.Position;
   trkDebut.Position := trkFin.Position;
   trkFin.Position := tmp;
end;

procedure TfrmNuances.cmdCancelClick(Sender: TObject);
begin
    Close;
end;

end.
