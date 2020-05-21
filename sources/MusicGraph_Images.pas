unit MusicGraph_Images;

interface

uses MusicHarmonie, Graphics, MusicGraph_GestionImage,
     SysUtils {pour inttostr},
     QSystem {pour NumeroDessinPause};

const nombreimgpause = 5;


var
    imgClefs: array[TClef] of TGraphic;
    imgClefsPortees: array[TClef] of TGraphic;
    imgPausesG: array[0..nombreimgpause] of TBitmap;
    imgPauses: array[0..nombreimgpause] of TGraphic;
    imgAlteration: array[0..1 {noir-gris},TAlteration] of TGraphic;
    imgPizzicato: TGraphic;
    imgNoteBlanche: TGraphic;
    imgQueueCrocheDessus: TGraphic;
    imgAccolade: TGraphic;
    imgMesureSaturee: TGraphic;
    imgSeperationOrchestre: TGraphic;

    imgCroix, imgOreille, imgOeil,imgBlabla : TBitmap;
    imgSelectionAncre: TBitmap;



    procedure ChargerBitmaps;
    procedure ChargerBitmaps_Secondaires;

Function NumeroDessinPause(d: TRationnel): integer;
Function GetInstrument_Dessin(num_instrument: integer): TGraphic;
Function GetInstrument_Dessin_Bitmap(num_instrument: integer): TBitmap;
    
implementation

uses MusicUser {pour DossierRacine},
     jpeg,
     instruments;


Function NumeroDessinPause(d: TRationnel): integer;
Begin
   if IsQEgal(d, Qel(4)) then
           result := 0
   else if IsQEgal(d, Qel(2)) or IsQEgal(d, Qel(3)) then
           result := 1
   else if IsQEgal(d, Qel(1)) or IsQEgal(d, Qel(3,2)) then
           result := 2
   else if IsQEgal(d, Qel(1,2)) or IsQEgal(d, Qel(1,3)) or IsQEgal(d, Qel(3,4)) then
           result := 3
   else if IsQEgal(d, Qel(1,4)) then
           result := 4
   else //if IsQEgal(d, Qel(1,8)) then
           result := 5;

End;


procedure ChargerBitmaps_Secondaires;

Begin


      {image d'erreur quand une mesure est trop remplie}
      imgMesureSaturee := WMFLoadFromFile('partitions_images\panneaumesuresaturee.wmf');

      {symbole pour la fenêtre "gestion des voix"}
      imgOeil :=           BMPTransparentLoadFromFile('interface_images\oeil.bmp');
      imgOreille :=        BMPTransparentLoadFromFile('interface_images\oreille.bmp');
      imgCroix :=          BMPTransparentLoadFromFile('interface_images\croix.bmp');
      imgBlabla :=         BMPTransparentLoadFromFile('interface_images\blabla.bmp');
      imgSelectionAncre := BMPTransparentLoadFromFile('partitions_images\selectionancre.bmp');
      
End;


procedure ChargerBitmaps;
{procédure qui s'occupe de charger toutes les images nécessaires pour afficher
 les partitions :
  - images de clés
  - images de clés à insérer
  - pauses etc.}
var i:TClef;
var    x, y, j:integer;

Begin
      {clefs en début de portées}
      for i := ClefSol to high(TClef) do
      Begin
              imgClefs[i] := TMetafile.Create;
              case i of
                   ClefSol: imgClefs[i].LoadFromFile(DossierRacine + 'partitions_images\ClefSolIns.wmf');
                   ClefFa:  imgClefs[i].LoadFromFile(DossierRacine + 'partitions_images\ClefFaIns.wmf');
                   ClefUt3:  imgClefs[i].LoadFromFile(DossierRacine + 'partitions_images\clefdut.wmf');
                   ClefSol8: imgClefs[i].LoadFromFile(DossierRacine + 'partitions_images\ClefSolIns.wmf');
              end;
              imgClefs[i].Transparent := true;
      End;

      {clefs à insérer}
      for i := ClefSol to high(TClef) do
      Begin
              imgClefsPortees[i] := TMetafile.Create;
              case i of
                   ClefSol: imgClefsPortees[i].LoadFromFile(DossierRacine + 'partitions_images\ClefSol.wmf');
                   ClefFa:  imgClefsPortees[i].LoadFromFile(DossierRacine + 'partitions_images\ClefFa.wmf');
                   ClefUt3:  imgClefsPortees[i].LoadFromFile(DossierRacine + 'partitions_images\clefdut.wmf');
                   ClefSol8: imgClefsPortees[i].LoadFromFile(DossierRacine + 'partitions_images\ClefSol.wmf');
              end;
              imgClefsPortees[i].Transparent := true;
      End;

      {les images de pauses}
      imgpauses[0] := WMFLoadFromFile('partitions_images\pause0.wmf');
      imgpauses[1] := WMFLoadFromFile('partitions_images\pause1.wmf');
      imgpauses[2] := WMFLoadFromFile('partitions_images\pause2.wmf');
      imgpauses[3] := WMFLoadFromFile('partitions_images\pause3.wmf');
      imgpauses[4] := WMFLoadFromFile('partitions_images\pause4.wmf');
      imgpauses[5] := WMFLoadFromFile('partitions_images\pause5.wmf');



      {images d'altération}
      imgAlteration[0, aNormal {bécar}] := WMFLoadFromFile('partitions_images\becar.wmf');
      imgAlteration[0, aDiese] :=          WMFLoadFromFile('partitions_images\diese.wmf');
      imgAlteration[0, aDbDiese] :=        WMFLoadFromFile('partitions_images\doublediese.wmf');
      imgAlteration[0, aDbBemol] :=        WMFLoadFromFile('partitions_images\doublebemol.wmf');
      imgAlteration[0, aBemol] :=          WMFLoadFromFile('partitions_images\bemol.wmf');

      {note blanche}
      imgNoteBlanche :=                    WMFLoadFromFile('partitions_images\notenoire.wmf');

      {accolade pour regrouper des portées}
      imgAccolade :=                       WMFLoadFromFile('partitions_images\accolade.wmf');

      {queue des croches}
      imgQueueCrocheDessus :=              WMFLoadFromFile('partitions_images\QueueCrocheDessus.wmf');


      {symbole pizzicato pour le violon}
      imgPizzicato := imgAlteration[0, aDbDiese];



      imgSeperationOrchestre :=            WMFLoadFromFile('partitions_images\separationorchestre.WMF');


      {les images de pauses qui sont grises}
      for j := 0 to high(imgpauses) do
      Begin
          imgpausesG[j] := BMPLFF(DossierRacine + 'partitions_images\pause' + inttostr(j) + '.bmp');
          //imgpausesG[j] := TBitmap.Create;
          with imgpausesG[j] do
          Begin
             //LoadFromFile(DossierRacine + 'pause' + inttostr(j) + '.bmp');

              for x := 0 to Width - 1 do
                 for y := 0 to height - 1 do
                        if Canvas.Pixels[x, y] = 0 then
                               Canvas.Pixels[x, y] :=$AAAAAA;

               TransparentColor := $FFFFFF;
               Transparent := true;
          end;
      end;

end;






Function GetInstrument_Dessin(num_instrument: integer): TGraphic;
var filename: string;
    JPEGImage: TJPEGImage;

Begin
    VerifierIndiceInstrument(num_instrument, 'GetInstrument_Dessin');

    filename := DossierRacine + 'Instruments\' + inttostr(num_instrument + 1) + '.jpg';

    if FileExists(filename) then
      Begin
             JPEGImage := TJPEGImage.Create;
             JPEGImage.LoadFromFile(filename);
             result := JPEGImage;
      end
      else
             result := nil;
End;


Function GetInstrument_Dessin_Bitmap(num_instrument: integer): TBitmap;
var d: TGraphic;
    b: TBitmap;
Begin
      d := GetInstrument_Dessin(num_instrument);
      b := TBitmap.Create;
      b.width := d.Width;
      b.Height := d.Height;

      b.Canvas.Draw(0, 0, d);

      result := b;
End;

end.
