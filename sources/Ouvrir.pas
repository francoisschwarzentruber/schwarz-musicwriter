unit Ouvrir;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MusicSystem_Composition, FileSystem, MusicGraph, StdCtrls, Math, FileCtrl, ComCtrls,
  ExtCtrls, ShellCtrls;

type
  TfrmOuvrir = class(TForm)
    Button1: TButton;
    Button2: TButton;
    OpenDialog: TOpenDialog;
    lstFichiers: TListBox;
    TabControl: TTabControl;
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    cmdOK: TButton;
    ShellComboBox: TShellComboBox;
    ShellTreeView: TShellTreeView;
    procedure AssurerQueApercuYabon(j: integer);
    procedure ListerRep(rep: string);
    procedure Button2Click(Sender: TObject);
    procedure lstFichiersDrawItem(Control: TWinControl; Index: Integer;
      R: TRect; State: TOwnerDrawState);
    procedure lstFichiersDblClick(Sender: TObject);
    procedure lstFichiersMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure ShellTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure FormClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    FileName: string;
    OpenAsModel: boolean;
    { Déclarations publiques }
  end;


  TApercu = record
               Comp: TComposition;
               dejaapercu: boolean;
               is_erreur: Boolean;
               filename: string;
  end;

  
var
  frmOuvrir: TfrmOuvrir;
  Apercus: array of TApercu;
  Ouvrir_Partition_CheminParDefaut: string = '';
  Dossier: string; //dossier qui est affiché
  tmpB: TBitmap;

implementation

uses Main, MusicUser, Types,
     MusicGraph_System {pour Zoom},
     MusicGraph_Portees {pour IGP},
     langues;

const h = 100;
      ZoomPourApercu = 40;

procedure TfrmOuvrir.AssurerQueApercuYabon(j: integer);
//charge la première ligne du fichier numéro j
Begin
if not Apercus[j].dejaapercu then
Begin
     try
           Apercus[j].dejaapercu := true;
           Apercus[j].is_erreur := false;
           OuvrirFichier(dossier + '\' + Apercus[j].filename);
           Apercus[j].Comp := TComposition.Create;

           IGP := Apercus[j].Comp;
           MusicGraph_Canvas_Set(lstFichiers.Canvas);

           Apercus[j].Comp.OuvrirApercu;
           Apercus[j].Comp.CalcTout(true);
           FermerFichier;
     except
            Apercus[j].is_erreur := true;
     end;
End;
End;

procedure TfrmOuvrir.ListerRep(rep: string);
var sr:TSearchRec;
    v, j:integer;
    EstDossier: Boolean;

Begin
if rep[length(rep)] = '\' then
      Dossier := Copy(rep,1, length(rep)-1)
else
     Dossier := rep;
   setlength(Apercus, 0);

v := FindFirst(dossier + '\*.mus', faAnyFile, sr);

j := 0;
lstFichiers.Clear;
EnLecture := true;
while v = 0 do Begin
      if (sr.name <> '.') and (sr.name <> '..') then Begin
            EstDossier := (((sr.attr and faDirectory) = faDirectory) or ((sr.attr and faVolumeID) = faVolumeID));

            if not EstDossier then
            Begin
                  setlength(Apercus, j+1);

                  Apercus[j].filename := sr.name;
                  Apercus[j].dejaapercu := false;


                  lstFichiers.Items.Add(Apercus[j].filename);
                  inc(j);

            End;

      End;
      v := FindNext(sr);
End;


End;




{$R *.DFM}




procedure TfrmOuvrir.Button2Click(Sender: TObject);
begin
if OpenDialog.Execute then
Begin
    filename := OpenDialog.filename;
    Close;
    ModalResult := mrOk;
End;
end;

procedure TfrmOuvrir.lstFichiersDrawItem(Control: TWinControl;
  Index: Integer; R: TRect; State: TOwnerDrawState);
var h: integer;

begin
      Zoom := ZoomPourApercu;
      CDevice := devApercu;

      tmpB.Height := R.Bottom -  R.Top;

      MusicGraph_Canvas_Set(tmpB.Canvas);

      C.Brush.Style := bsSolid;
      C.Brush.Color := clWhite;
      C.FillRect(Rect(-1,-1,1000,1000));

      if Apercus[index].is_erreur then
            C.Font.Color := clRed
      else
            C.Font.Color := clBlue;
      C.Font.Size := 10;
      C.TextOut(10,0, Apercus[index].filename);

      C.Brush.Color := clWhite;
      lstFichiersMeasureItem(lstFichiers, index, h);

      if not Apercus[index].is_erreur then
      Begin
          try
                CDevice := devApercu;
                C.Font.Color := clBlack;
                SetViewCourantPixDeb(0, (8)*ZoomMaxPrec div Zoom);
                SetViewNil;
                AfficherPartitionToutesLesLignes(Apercus[index].Comp, 0,0);
                {rem : on appelle AfficherPartitionToutesLesLignes
                   mais la partition n'a qu'une ligne !!}
          except
                Apercus[index].is_erreur := true
          end;
      End;

      //Zoom := strtoint(MainForm.cboZoom.Text); A REVOIR
      CDevice := devEcran;

      lstFichiers.Canvas.Draw(R.Left,R.Top,tmpB);


end;

procedure TfrmOuvrir.lstFichiersDblClick(Sender: TObject);
begin
     FileName := Dossier + '\' + Apercus[lstFICHIERS.itemindex].filename;
     OpenAsModel := (TabControl.TabIndex = 0);
     Close;
     ModalResult := mrOk;
end;

procedure TfrmOuvrir.lstFichiersMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
  //donne la bonne dimension d'un item de la liste

begin
SetViewNil;
AssurerQueApercuYabon(index);
if not Apercus[index].is_erreur then
      try
            Height := Apercus[index].Comp.minHauteurLigne(0) * ZoomPourApercu div  ZoomMaxPrec + 32
      except
            Apercus[index].is_erreur := true;
      end
else
      Height := 64;
      {if Height > lstFichiers.Height then
    Height := lstFichiers.Height; }
end;

procedure TfrmOuvrir.FormClose(Sender: TObject; var Action: TCloseAction);
var j:integer;
begin
for j := 0 to high(Apercus) do
     Apercus[j].Comp.Free;

setlength(Apercus,0);
lstFichiers.Clear;
end;

procedure TfrmOuvrir.FormCreate(Sender: TObject);
begin
    Langues_TraduireFenetre(self);
    TabControl.DoubleBuffered := true;
    tmpB := TBitmap.Create;
    tmpB.Canvas.Font := lstFichiers.Font;
    tmpB.Width := lstFichiers.Width;
    ShellTreeView.Path := Ouvrir_Partition_CheminParDefaut;
    ShellComboBox.Path := Ouvrir_Partition_CheminParDefaut;
    ShellTreeViewChange(nil, nil);
    ListerRep(Ouvrir_Partition_CheminParDefaut);
//lstFichiers.DoubleBuffered := true;
end;

procedure TfrmOuvrir.TabControlChange(Sender: TObject);
var b: boolean;
Begin
b := TabControl.TabIndex = 0;
if TabControl.TabIndex = 0 then
Begin
     ListerRep(DossierRacine + 'interface_modeles');
     cmdOK.Caption := Langues_Traduire('Nouvelle partition');
     Caption := Langues_Traduire('Nouvelle partition...');
End
else
Begin
     ShellTreeView.Path := Ouvrir_Partition_CheminParDefaut;
     ShellTreeViewChange(nil, nil);
     Caption := Langues_Traduire('Ouvrir une partition existante...');
     cmdOK.Caption := Langues_Traduire('Ouvrir');
End;

ShellComboBox.Visible := not b;
ShellTreeView.Visible := not b;
end;

procedure TfrmOuvrir.cmdOKClick(Sender: TObject);
begin
     FileName := Dossier + '\' + Apercus[lstFICHIERS.itemindex].filename;
     OpenAsModel := (TabControl.TabIndex = 0);
end;

procedure TfrmOuvrir.ShellTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
   ListerRep(ShellTreeView.Path);
end;

procedure TfrmOuvrir.FormClick(Sender: TObject);
begin
      ShellComboBox.Path := Ouvrir_Partition_CheminParDefaut;
      ShellTreeView.Path := Ouvrir_Partition_CheminParDefaut;
      ShellTreeView.SetFocus;
end;

end.
