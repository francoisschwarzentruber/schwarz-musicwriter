unit sauveimg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList;

type
  TfrmSauvegardeImage = class(TForm)
    imgNotes: TImageList;
    ImageList1: TImageList;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  frmSauvegardeImage: TfrmSauvegardeImage;

implementation

{$R *.DFM}

end.
