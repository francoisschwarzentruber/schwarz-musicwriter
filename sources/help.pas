unit help;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmHelp = class(TForm)
    txtMess: TRichEdit;
    Image1: TImage;
    Shape: TShape;
    tmrAfficher: TTimer;
    procedure txtMessMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormHide(Sender: TObject);
    procedure tmrAfficherTimer(Sender: TObject);

    procedure HideAMoi;
    procedure FormCreate(Sender: TObject);

    Function VisibleAMoi:Boolean;

    
  private
    { Déclarations privées }
  public

    { Déclarations publiques }
  end;

var
  frmHelp: TfrmHelp = nil;

implementation

uses Main, MusicWriter_Aide;

{$R *.dfm}

procedure TfrmHelp.HideAMoi;
Begin
    Top := 2000;//Hide;
    FormHide(self);
End;


Function TfrmHelp.VisibleAMoi:Boolean;
Begin
    result := Visible and (Top < 2000);
End;


procedure TfrmHelp.txtMessMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   HideAMoi;
end;

procedure TfrmHelp.FormHide(Sender: TObject);
begin
      lastHelp := '';
end;

procedure TfrmHelp.tmrAfficherTimer(Sender: TObject);
begin
    visible := true;
    MainForm.SetFocus;
    tmrAfficher.enabled := false;
end;

procedure TfrmHelp.FormCreate(Sender: TObject);
begin
    DoubleBuffered := true;
end;

end.
