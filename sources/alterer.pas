unit alterer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, StdCtrls, Buttons, ImgList;

type
  TfrmSelectionAlterer = class(TForm)
    BitBtn1: TBitBtn;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ImageListAlterations: TImageList;
    procedure SelectionAlterer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmSelectionAlterer: TfrmSelectionAlterer;

implementation

uses MusicUser_PlusieursDocuments, MusicHarmonie;

{$R *.dfm}

procedure TfrmSelectionAlterer.SelectionAlterer(Sender: TObject);
begin
     actchild.I_Selection_Alterer(TAlteration((Sender as TToolButton).Tag));
     Close;
end;

end.
