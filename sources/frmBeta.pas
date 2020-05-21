unit frmBeta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmBetaMessage = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    txtEMail: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    Shape1: TShape;
    Shape2: TShape;
    Label10: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
     procedure WMDropFiles(Var Mesg: TWMDropFiles); message WM_DROPFILES;
  public
    { Déclarations publiques }
  end;

var
  frmBetaMessage: TfrmBetaMessage;


  procedure frmBetaMessage_ShowModal;






  
implementation


uses ShellAPI, Main;


procedure frmBetaMessage_ShowModal;
Begin
    if frmBetaMessage = nil then
        frmBetaMessage := TfrmBetaMessage.Create(nil);

    frmBetaMessage.ShowModal;
End;
{$R *.dfm}


procedure TfrmBetaMessage.WMDropFiles(Var Mesg: TWMDropFiles);
Begin
    MainForm.WMDropFiles(Mesg);
    Close;
End;

procedure TfrmBetaMessage.FormCreate(Sender: TObject);
begin
     DragAcceptFiles(handle, true);
end;

end.
