unit MusicWriter_Console;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls;

type
  TcfpValeur = (cfpAfficher, cfpAfficherTout);
  TcdValeur = (cdAllume, cdEteint);


  TfrmConsole = class(TForm)
    Memo: TMemo;
    MainMenu1: TMainMenu;
    Texte: TMenuItem;
    Test1: TMenuItem;
    TesterLigneAvecY1: TMenuItem;
    AffichageComplet1: TMenuItem;
    AffichageCompletdelcran1: TMenuItem;
    Touteffacer1: TMenuItem;
    Infomesure1: TMenuItem;
    Vrification1: TMenuItem;
    Infoslection1: TMenuItem;
    Gestiondeserreurs1: TMenuItem;
    Neplusignorerleserreurs1: TMenuItem;
    Gnreruneerreur1: TMenuItem;
    Panel1: TPanel;
    lblFormPaint: TLabel;
    tmrEteindreLumiere: TTimer;
    lblDefil: TLabel;
    Insertiondemillelementsmusicauxalatoires1: TMenuItem;
    Ecrirelesmotsnontraduits1: TMenuItem;
    mnuStopper: TMenuItem;
    procedure Console_AjouterLigne(s: string);
    procedure Touteffacer1Click(Sender: TObject);
    procedure TesterLigneAvecY1Click(Sender: TObject);
    procedure AffichageComplet1Click(Sender: TObject);
    procedure AffichageCompletdelcran1Click(Sender: TObject);
    procedure Infomesure1Click(Sender: TObject);
    procedure Infoslection1Click(Sender: TObject);
    procedure Neplusignorerleserreurs1Click(Sender: TObject);
    procedure Gnreruneerreur1Click(Sender: TObject);
    procedure tmrEteindreLumiereTimer(Sender: TObject);
    procedure MainFormFermer1Click(Sender: TObject);
    procedure Insertiondemillelementsmusicauxalatoires1Click(
      Sender: TObject);
    procedure Ecrirelesmotsnontraduits1Click(Sender: TObject);
    procedure mnuStopperClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    dernierligneajoute: string;
    nbderniereligne: integer;
    { Déclarations publiques }
  end;


  procedure Console_Afficher;
  procedure Console_AjouterLigne(s: string);
  procedure Console_FormPaint(valeur: TcfpValeur);
  procedure Console_Defil(valeur: TcdValeur);


var
  frmConsole: TfrmConsole;














implementation


{$R *.DFM}

uses Main, MusicGraph, MusicGraph_System {pour C},
     QSystem {pour QToStr}, error {IgnorerMessageErreur}, MusicWriter_Erreur,
     MusicHarmonie {pour HauteurNote},
     MusicUser_PlusieursDocuments,
     langues;

const NbMaxLigneDansConsole = 1000;

      LUMIERE_NONE = $00FF00;
      

procedure Console_Afficher;
Begin
    if frmConsole = nil then
        frmConsole := TfrmConsole.Create(nil);

    frmConsole.Show;
End;



procedure Console_FormPaint(valeur: TcfpValeur);
Begin
   if frmConsole = nil then exit;
   if not frmConsole.visible then exit;

   case valeur of
       cfpAfficher: frmConsole.lblFormPaint.Color := $00FFFF;
       cfpAfficherTout: frmConsole.lblFormPaint.Color := $FF;
       else
           MessageErreur('erreur dans Console_FormPaint');
   end;

   frmConsole.tmrEteindreLumiere.enabled := true;

End;


procedure Console_Defil(valeur: TcdValeur);
Begin
   if frmConsole = nil then exit;
   if not frmConsole.visible then exit;

   case valeur of
       cdAllume: frmConsole.lblDefil.Color := $FF;
       cdEteint: frmConsole.lblDefil.Color := $F8F8F8;
       else
           MessageErreur('erreur dans Console_FormPaint');
   end;

   frmConsole.tmrEteindreLumiere.enabled := true;

End;



procedure Console_AjouterLigne(s: string);
Begin
    if frmConsole = nil then exit;

    frmConsole.Console_AjouterLigne(s);
End;

procedure TfrmConsole.Console_AjouterLigne(s: string);
Begin

      if not visible then exit;

      if mnuStopper.Checked then
           exit;
      
      if Memo.Lines.Count > NbMaxLigneDansConsole then
            Memo.Lines.Clear;
            {rem : faire Memo.Lines.Delete(0) ça fait ramer !!!!}

      if s = dernierligneajoute then
      Begin
            inc(nbderniereligne);
            Memo.Lines.strings[Memo.lines.count-1] := s + ' (' + inttostr(nbderniereligne) + ')';
      End
      else
      Begin
            nbderniereligne := 1;
            Memo.Lines.Add(s);
            dernierligneajoute := s;
      End;




      Caption := 'Terminal (' + inttostr(Memo.lines.Count) + ' lignes)';
    
End;

procedure TfrmConsole.Touteffacer1Click(Sender: TObject);
begin
Memo.clear;
end;

procedure TfrmConsole.TesterLigneAvecY1Click(Sender: TObject);
var i:integer;
    t: int64;
begin

t := GetTickCount;
for i := 0 to 100000 do
     actchild.Composition.LigneAvecY(0);

t := GetTickCount - T;

Memo.Clear;
Memo.Lines.add('LigneAvecY (100000 fois)');
Memo.Lines.add(inttostr(t) + ' ms');
end;

procedure TfrmConsole.AffichageComplet1Click(Sender: TObject);
var i:integer;
    t: int64;
begin
t := GetTickCount;
for i := 0 to 50 do
Begin
     MusicGraph_Canvas_Set(actchild.canvas);
     AfficherPartitionToutesLesLignes(actchild.composition, 0, high(actchild.Composition.Lignes));


End;

t := GetTickCount - T;

Memo.Clear;
Memo.Lines.add('Affichage complet (50 fois)');
Memo.Lines.add(inttostr(t) + ' ms');
end;

procedure TfrmConsole.AffichageCompletdelcran1Click(Sender: TObject);
var i:integer;
    t: int64;
begin
t := GetTickCount;
for i := 0 to 50 do
     actchild.ReaffichageComplet;


t := GetTickCount - T;

Memo.Clear;
Memo.Lines.add('Affichage complet (50 fois)');
Memo.Lines.add(inttostr(t) + ' ms');
end;

procedure TfrmConsole.Infomesure1Click(Sender: TObject);
begin
with actchild do
      Console_AjouterLigne(inttostr(length(Composition.GetMesure(actchild.curseur.Getimesure).Voix))
                    + ' voix dans la mesure n°' + inttostr(actchild.curseur.Getimesure));
end;

procedure TfrmConsole.Infoslection1Click(Sender: TObject);
var t1, t2: TRationnel;
begin

With actchild.Composition do
Begin
      t1 := Selection_TempsDebut;
      t2 := Selection_TempsFin;
      Console_AjouterLigne('La sélection courante s''étend de la mesure n°'
           + inttostr(Selection_Getimesdebutselection) + ' (au temps ' + QToStr(t1) +
           ') jusqu''à la mesure n°'
           + inttostr(Selection_Getimesfinselection) + ' (au temps ' + QToStr(t2));
End;

end;

procedure TfrmConsole.Neplusignorerleserreurs1Click(Sender: TObject);
begin
IgnorerMessageErreur := false;
end;

procedure TfrmConsole.Gnreruneerreur1Click(Sender: TObject);
begin
       MessageErreur('Ceci n''est pas une vraie erreur.');
end;





procedure TfrmConsole.tmrEteindreLumiereTimer(Sender: TObject);
begin
     lblFormPaint.Color := LUMIERE_NONE;
     tmrEteindreLumiere.Enabled := false;
end;

procedure TfrmConsole.MainFormFermer1Click(Sender: TObject);
begin
     Close;
end;

procedure TfrmConsole.Insertiondemillelementsmusicauxalatoires1Click(
  Sender: TObject);
  var i: integer;
      hn: THauteurNote;
begin
    if not MusicWriter_IsFenetreDocumentCourante then exit;

    for i := 0 to 99 do
    Begin
        hn.Hauteur := random(10);
        hn.alteration := aNormal;
        actchild.I_InsererModeleCourantDansVoixCourante(hn);
        actchild.Composition.PaginerApartirMes(actchild.Curseur.GetiMesure, true);
        actchild.ReaffichageComplet;
    End;
end;

procedure TfrmConsole.Ecrirelesmotsnontraduits1Click(Sender: TObject);
begin
       Memo.Lines.AddStrings(Langues_Debug_MotsNonTraduits_Get);

end;

procedure TfrmConsole.mnuStopperClick(Sender: TObject);
begin
      mnuStopper.Checked := not mnuStopper.Checked;
end;

end.
