unit Paroles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, ToolWin;

type
  TfrmParoles = class(TForm)
    Memo: TMemo;
    Label1: TLabel;
    panVoixAvecParoles: TPaintBox;
    BitBtn1: TBitBtn;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    Label2: TLabel;
    procedure MemoChange(Sender: TObject);
    procedure panVoixAvecParolesPaint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    ivoix: integer;

  public
    { Déclarations publiques }
       procedure SetVoixNum(v: integer);
  end;




  procedure frmParoles_Afficher(ivoix: integer);


  
var
  frmParoles: TfrmParoles;





implementation


uses Main,
     MusicGraph {pour DrawCadrePresentationVoix},
     TimerDebugger,
     MusicWriter_Console,
     langues,
          MusicUser_PlusieursDocuments;




{$R *.dfm}


procedure frmParoles_Afficher(ivoix: integer);
Begin
    frmParoles.SetVoixNum(ivoix);
    frmParoles.ShowModal;
End;

procedure TfrmParoles.MemoChange(Sender: TObject);
begin

    TimerDebugger_Init;
    actchild.Composition.Paroles_Set(ivoix, Memo.Text);
    TimerDebugger_FinEtape('paroles_set');
    actchild.Composition.CalcTout(false);
    TimerDebugger_FinEtape('CalcTout');
    actchild.ReaffichageComplet;
    TimerDebugger_FinEtape('ReaffichageComplet');

    Console_AjouterLigne(TimerDebugger_GetTexte);

end;

procedure TfrmParoles.panVoixAvecParolesPaint(Sender: TObject);
begin
      DrawCadrePresentationVoix(actChild.Composition, panVoixAvecParoles.Canvas,
                              Rect(0,0,panVoixAvecParoles.Width,panVoixAvecParoles.Height),
                              ivoix,1, false, false);
end;



procedure TfrmParoles.SetVoixNum(v: integer);
Begin
     ivoix := v;
End;

procedure TfrmParoles.FormActivate(Sender: TObject);
begin
   Memo.Text := actchild.Composition.Paroles_Get(ivoix);
   actchild.FormPaint(nil);
end;

procedure TfrmParoles.ToolButton1Click(Sender: TObject);
begin
    Memo.SelText := Chr(9);
end;

procedure TfrmParoles.FormCreate(Sender: TObject);
begin
         Langues_TraduireFenetre(self);
end;

end.
