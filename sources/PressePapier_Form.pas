unit PressePapier_Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfrmPressePapier = class(TForm)
    Image1: TImage;
    panPressePapier: TPaintBox;
    Shape1: TShape;
    tmrAffichage: TTimer;
    procedure panPressePapierPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure panPressePapierMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tmrAffichageTimer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;



  procedure frmPressePapier_Show;


  
var
  frmPressePapier: TfrmPressePapier;

implementation

{$R *.dfm}

uses MusicUser {pour PressePapier},
     MusicGraph_Portees {pour IGP},
     MusicGraph_System {pour C},
     QSystem,
     MusicHarmonie;



procedure frmPressePapier_Show;
Begin
       frmPressePapier.Show;
       frmPressePapier.tmrAffichage.Enabled := false;
       frmPressePapier.tmrAffichage.Enabled := true;
       frmPressePapier.Refresh;
End;



procedure TfrmPressePapier.panPressePapierPaint(Sender: TObject);
var v: integer;
    AncienZoom: integer;
begin
       MusicGraph_Canvas_Set(panPressePapier.Canvas);
       IGP := nil;
       PressePapier.CalcQueue;
       PressePapier.CalcGraphSub(0, 0, true);
       C.Brush.Color := clCream;
       C.Brush.Style := bsSolid;
       C.FillRect(ClientRect);
       C.Brush.Color := clBlack;
       C.Pen.Color := clBlack;
       SetPixOrigin(0, 0);
       pixxdeb := 0;
       pixydeb := 0;
       AncienZoom := Zoom;
       Zoom := 80;
       for v := 0 to high(PressePapier.Voix) do
             PressePapier.Voix[v].DrawVoix(QInfini);

       Zoom := AncienZoom;
end;

procedure TfrmPressePapier.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   Close;
end;

procedure TfrmPressePapier.panPressePapierMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   Close;
end;

procedure TfrmPressePapier.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
      Close;
end;

procedure TfrmPressePapier.tmrAffichageTimer(Sender: TObject);
begin
      tmrAffichage.Enabled := false;
      hide; 
end;

end.
