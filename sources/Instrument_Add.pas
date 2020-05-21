unit Instrument_Add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, frame_Instruments_Choix;

type
  TfrmInstrument_Add = class(TForm)
    frameInstruments_Choix: TframeInstruments_Choix;
    cmdAjouter: TButton;
    cmdAnnuler: TButton;
    Label1: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmInstrument_Add: TfrmInstrument_Add;


Function frmInstrument_Add_ShowModal: integer;





implementation

{$R *.dfm}


uses langues;

Function frmInstrument_Add_ShowModal: integer;
Begin
     if frmInstrument_Add = nil then
          frmInstrument_Add := TfrmInstrument_Add.Create(nil);

    result := frmInstrument_Add.ShowModal;
End;

procedure TfrmInstrument_Add.FormCreate(Sender: TObject);
begin
        Langues_TraduireFenetre(self);
end;

end.
