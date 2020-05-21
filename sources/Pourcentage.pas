unit Pourcentage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmPourcentage = class(TForm)
    ProgressBar: TProgressBar;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    lblName: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmPourcentage: TfrmPourcentage;

implementation

{$R *.dfm}

end.
