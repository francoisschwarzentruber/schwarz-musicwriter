unit langue_fenetre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmLangue_Choix = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    langue_list: TListBox;
    cmdOK: TBitBtn;
    BitBtn1: TBitBtn;
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmLangue_Choix: TfrmLangue_Choix;

implementation

{$R *.dfm}



uses langues;

procedure TfrmLangue_Choix.cmdOKClick(Sender: TObject);
begin
     Langues_LangueCourante_EcrireDansLaConfiguration(TLangue(langue_list.ItemIndex));
     ModalResult := mrOk;

end;



procedure TfrmLangue_Choix.FormCreate(Sender: TObject);
begin
     langue_list.ItemIndex := integer(Langues_LangueCourante_ChoperDeLaConfigurationCourante);
     Close;
end;

procedure TfrmLangue_Choix.BitBtn1Click(Sender: TObject);
begin
    ModalResult := mrCancel;

end;

end.
