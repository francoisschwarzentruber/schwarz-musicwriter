unit transposition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons;

type
  TfrmTransposition = class(TForm)
    TabControl: TTabControl;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmdPlus: TSpeedButton;
    cmdMoins: TSpeedButton;
    BitBtn3: TBitBtn;
    procedure cmdPlusClick(Sender: TObject);
    procedure cmdMoinsClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmTransposition: TfrmTransposition;

  procedure frmTransposition_Showmodal;







  
implementation

uses MusicSystem {pour le type TIntervalle}, Main {pour actchild}, MusicHarmonie,
     MusicWriter_Erreur,     MusicUser_PlusieursDocuments;

{$R *.dfm}



procedure frmTransposition_Showmodal;
Begin
 if frmTransposition = nil then
       frmTransposition := TfrmTransposition.Create(nil);

 frmTransposition.ShowModal;
End;


procedure TfrmTransposition.cmdPlusClick(Sender: TObject);
var intervalle: TIntervalle;
begin
      MessageErreurSiPasDeFenetreActive('cmdPlusClick');

      case TabControl.TabIndex of
           0: intervalle := intOctaveH;
           1: intervalle := intQuinteH;
           2: intervalle := intSecondeH;
      end;

      actchild.Selection_Transposer(intervalle);
end;

procedure TfrmTransposition.cmdMoinsClick(Sender: TObject);
var intervalle: TIntervalle;
begin
      MessageErreurSiPasDeFenetreActive('cmdMoinsClick');
            

      case TabControl.TabIndex of
           0: intervalle := intOctaveB;
           1: intervalle := intQuinteB;
           2: intervalle := intSecondeB;
      end;

      actchild.Selection_Transposer(intervalle);
end;

procedure TfrmTransposition.BitBtn3Click(Sender: TObject);
begin
    Close;
end;

end.
