unit MusicGraph_GestionImage;




interface

uses Graphics;

    Function BMPLFF(nom: string): TBitmap;
    Function BMPTransparentLoadFromFile(nom: string): TBitmap;
    Function WMFLoadFromFile(nom: string): TMetafile;


implementation

uses MusicWriter_Erreur {pour MessageErreur},
     MusicUser {pour dossierracine};

Function BMPLFF(nom: string): TBitmap;
{bitmap load from file}
var b: TBitmap;
Begin
    b := TBitmap.Create;
    try
        b.LoadFromFile(nom);
    except else
         MessageErreur('Impossible d''ouvrir le fichier image (bitmap) suivant : ' +
                               nom + '. Si tu continues à utiliser le logiciel, ' +
                       'il se peut que des images n''apparaissent pas...' +
                       ' C''est bizarre... je pense qu''il te manque des fichiers...');
    end;
    result := b;
End;





Function BMPTransparentLoadFromFile(nom: string): TBitmap;
{la couleur de transparence c'est le blanc}
var b: TBitmap;
Begin
    b := TBitmap.Create;
    try
         b.LoadFromFile(DossierRacine + nom);
    except else
          MessageErreur('Impossible d''ouvrir le fichier image (transparence = blanc) (bitmap) suivant : ' +
                           DossierRacine + nom + '. Si tu continues à utiliser le logiciel, ' +
                       'il se peut que des images n''apparaissent pas...' +
                       ' C''est bizarre... je pense qu''il te manque des fichiers...');
    end;
    b.Transparent := true;
    b.TransparentColor := $FFFFFF;
    result := b;
End;




Function WMFLoadFromFile(nom: string): TMetafile;
var img: TMetafile;
Begin
   img := TMetafile.Create;

   try
         img.LoadFromFile(DossierRacine + nom);
   except else
         MessageErreur('Impossible d''ouvrir le fichier image (métafichier) suivant : ' +
                       DossierRacine + nom + '. Si tu continues à utiliser le logiciel, ' +
                       'il se peut que des images n''apparaissent pas...' +
                       ' C''est bizarre... je pense qu''il te manque des fichiers...');
   end;
   
   result := img;
End;

end.
