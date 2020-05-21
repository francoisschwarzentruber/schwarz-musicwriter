unit error;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ImgList;

type
  TfrmError = class(TForm)
    txtMessage: TMemo;
    Label1: TLabel;
    Label6: TLabel;
    Image1: TImage;
    ImageList1: TImageList;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    cmdJaiLu: TBitBtn;
    cmdIgnorer: TBitBtn;
    cmdHalt: TBitBtn;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label10: TLabel;
    txtEMail: TEdit;
    procedure cmdIgnorerClick(Sender: TObject);
    procedure cmdHaltClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmError: TfrmError;
  IgnorerMessageErreur: Boolean = false;

implementation

{$R *.dfm}




procedure TfrmError.cmdIgnorerClick(Sender: TObject);

       procedure TuerToutesLesFenetresDErreur;
       var i: integer;
       Begin
           i := 0;
           while i < Screen.FormCount do
           Begin
                  if Screen.Forms[i] is TfrmError then
                        Screen.Forms[i].Close;
                  inc(i);

           End;


       End;

begin
     IgnorerMessageErreur := true;
     TuerToutesLesFenetresDErreur;

end;

procedure TfrmError.cmdHaltClick(Sender: TObject);
begin
      Halt;
end;

end.
