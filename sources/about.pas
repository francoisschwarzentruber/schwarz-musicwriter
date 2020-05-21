unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OKButton: TButton;
    Button1: TButton;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

 {$R *.DFM}
 
uses MusicUser, frmBeta; {pour DossierRacine}



procedure TAboutBox.FormCreate(Sender: TObject);
begin
ProgramIcon.Picture.LoadFromFile(DossierRacine + 'presentation_images\musicwriter logo.bmp');
end;

procedure TAboutBox.Button1Click(Sender: TObject);
begin
   frmBetaMessage_Showmodal;
end;

end.



