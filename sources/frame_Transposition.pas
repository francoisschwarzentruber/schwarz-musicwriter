unit frame_Transposition;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TframeTransposition = class(TFrame)
    lblExpliquer: TLabel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox2: TComboBox;
    cboVers: TComboBox;
    Label2: TLabel;
    ComboBox3: TComboBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

end.
