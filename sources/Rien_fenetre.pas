unit Rien_fenetre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfrmFenetreRien = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  frmFenetreRien: TfrmFenetreRien;

implementation

{$R *.dfm}

procedure TfrmFenetreRien.FormPaint(Sender: TObject);
begin
    hide;
end;

end.
