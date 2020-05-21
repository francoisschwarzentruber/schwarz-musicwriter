unit bienvenue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TfrmBienvenue = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    ProductName: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    MemoTips: TMemo;
    Shape1: TShape;
    imgCadre: TImage;
    Label1: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    imgLangue_Changer: TImage;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgCadreClick(Sender: TObject);
    procedure imgLangue_ChangerClick(Sender: TObject);
    procedure imgLangue_ChangerMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
  private
    imgImageSelectionnee: TImage;
    { Déclarations privées }
    procedure WMDropFiles(Var Mesg: TWMDropFiles); message WM_DROPFILES;
    procedure imgCadre_Placer(img: TImage);

    procedure Tips_Next;
    procedure Tips_Show;
    procedure Tips_Last;


  public
    { Déclarations publiques }
  end;

var
  frmBienvenue: TfrmBienvenue;

  procedure frmBienvenue_ShowModal;









implementation

uses Main, Nouveau_Assistant, SHellAPI, langues, MusicWriter_Erreur,
  langue_fenetre;

const private_tips_num = 10;

    private_tips_text: array[0..private_tips_num - 1] of string
       = ('Vous pouvez copier-coller une sélection directement avec le bouton du milieu de la souris.',
          'Pour créer une nouvelle voix, faites Alt + V, N.',
          'Pour laisser deviner Schwarz Musicwriter dans quel voix vous souhaitez écrire, faites Alt V, V.',
          'Pour forcer l''écriture dans une voix différente déjà existente, faites (plusieurs fois si besoin) Alt C.',
          'Pour changer la durée (noire, blanche...), appuyez sur 1, 2... sur le pavé numérique.',
          'Pour écrire des croches ou des doubles-croches, faites 1, 2 tout vite, ou 1, 4 tout vite sur le pavé numérique.',
          'Pour écrire des triolets, faites 1, 3 tout vite sur le pavé numérique',
          'Pour altérer une note, placez le curseur sous elle et appuyez sur ², &, é, #, ou ''.',
          'Pour éplucher des pommes de terre, utilisez un économe.',
          'Dans le mode "souris", pour entrer une note dans une tablature, placez le curseur puis faites ², &, é, ", ''...');


var private_tips_i: integer = 0;


{$R *.dfm}

procedure TfrmBienvenue.Tips_Show;
Begin
     MemoTips.Text := private_tips_text[private_tips_i];
End;


procedure TfrmBienvenue.Tips_Next;
Begin
    inc(private_tips_i);
    if private_tips_i >= private_tips_num then
       private_tips_i := 0;
    Tips_Show;
End;


procedure TfrmBienvenue.Tips_Last;
Begin
    dec(private_tips_i);
    if private_tips_i < 0 then
       private_tips_i := private_tips_num - 1;
    Tips_Show;
End;

procedure frmBienvenue_ShowModal;
Begin
    if frmBienvenue = nil then
        frmBienvenue := TfrmBienvenue.Create(nil);

    frmBienvenue.Show;

End;

procedure TfrmBienvenue.Image1Click(Sender: TObject);
begin
     MainForm.Fichier_NouveauDocumentViteFait_Piano;
//     Close;
end;

procedure TfrmBienvenue.Image2Click(Sender: TObject);
begin
    MainForm.Fichier_Ouvrir_Document;
//        Close;
end;

procedure TfrmBienvenue.Image3Click(Sender: TObject);
begin
   frmNouveauAssistant_Afficher;
   //Close;
end;

procedure TfrmBienvenue.Image4Click(Sender: TObject);
begin
     MainForm.Fichier_NouveauDocumentViteFait_Guitare;
     //Close;
end;

procedure TfrmBienvenue.Image5Click(Sender: TObject);
begin
  // Close;
end;

procedure TfrmBienvenue.BitBtn1Click(Sender: TObject);
begin
   Tips_Next;
end;

procedure TfrmBienvenue.BitBtn2Click(Sender: TObject);
begin
    Tips_Last;
end;

procedure TfrmBienvenue.FormShow(Sender: TObject);
begin
    Tips_Show;
end;

procedure TfrmBienvenue.FormCreate(Sender: TObject);
begin
    Langues_TraduireFenetre(self);
    DragAcceptFiles(handle, true);
end;



procedure TfrmBienvenue.WMDropFiles(Var Mesg: TWMDropFiles);
Begin
    MainForm.WMDropFiles(Mesg);
    //Close;
End;

procedure TfrmBienvenue.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    {if Key = VK_ESCAPE then
         Close;}
end;


procedure TfrmBienvenue.imgCadre_Placer(img: TIMage);
Begin
      imgCadre.SetBounds(img.left, img.Top, img.Width, img.Height);
      imgCadre.Visible := true;
      imgImageSelectionnee := img;
End;




procedure TfrmBienvenue.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
       imgCadre_Placer(Image1);
end;

procedure TfrmBienvenue.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
    imgCadre.Visible := false;
end;

procedure TfrmBienvenue.Image3MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    imgCadre_Placer(Image3);
end;

procedure TfrmBienvenue.Image4MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
        imgCadre_Placer(Image4);
end;

procedure TfrmBienvenue.Image2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
     imgCadre_Placer(Image2);
end;

procedure TfrmBienvenue.Image5MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
     imgCadre_Placer(Image5);
end;

procedure TfrmBienvenue.imgCadreClick(Sender: TObject);
begin
     imgImageSelectionnee.OnClick(nil);
end;

procedure TfrmBienvenue.imgLangue_ChangerClick(Sender: TObject);
begin
     if frmLangue_Choix.ShowModal = mrOk then
     Begin
         MainForm.Close;
         Shellexecute(Application.Handle,nil,PChar(Application.exename),nil,nil,SW_SHOW);
     End;
end;

procedure TfrmBienvenue.imgLangue_ChangerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
     imgCadre_Placer(imgLangue_Changer);
end;

end.
