unit frame_Rythme;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, QSYstem;

type
  TframeRythme = class(TFrame)
    txtRythmeNum: TEdit;
    txtRythmeDenom: TEdit;
    procedure txtRythmeNumChange(Sender: TObject);
    procedure txtRythmeDenomChange(Sender: TObject);

      procedure txtIntegerLocalKeyPressed(Sender: TObject;   var Key: Char);
      procedure txtIntegerLocalKeyDown(Sender: TObject;
        var Key: Word; Shift: TShiftState);
        
  private
    Function Rythme_read: TRationnel;
    Procedure Rythme_write(nv_rythme: TRationnel);

    { Déclarations privées }
  public


  property Rythme : TRationnel
        read Rythme_read
        write Rythme_write;
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

uses MusicUser {pour IntegerEditBoxKeyPress..}, InterfaceGraphique_Complements;

Function TframeRythme.Rythme_read: TRationnel;
Begin
   result.num := strtoint(txtRythmeNum.Text);
   result.denom := strtoint(txtRythmeDenom.Text);
End;


Procedure TframeRythme.Rythme_write(nv_rythme: TRationnel);
Begin
   txtRythmeNum.Text := inttostr(nv_rythme.Num);
   txtRythmeDenom.Text := inttostr(nv_rythme.Denom);
End;


    
procedure TframeRythme.txtRythmeNumChange(Sender: TObject);
begin
     Tag := 1;
end;

procedure TframeRythme.txtRythmeDenomChange(Sender: TObject);
begin
    Tag := 1;
end;


procedure TframeRythme.txtIntegerLocalKeyPressed(Sender: TObject;
  var Key: Char);
begin
   IntegerEditBoxKeyPress(TEdit(Sender), Key);
end;


procedure TframeRythme.txtIntegerLocalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    IntegerEditBoxKeyDown(TEdit(Sender), Key);


end;


end.
