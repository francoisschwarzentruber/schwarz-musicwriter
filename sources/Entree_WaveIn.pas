unit Entree_WaveIn;

{Cette unité gère le service "entrée microphone". Voici :

   Entree_WaveIn_Activer : active le service
   Entree_WaveIn_Desactiver : déactive le service
   Entree_WaveIn_IsActive : renvoie VRAI ssi le service est activé}








interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WaveIn, Entree_WaveIn_Signal_Type, ComCtrls, ExtCtrls;

type
  TfrmEntree_WaveIn = class(TForm)
    Label5: TLabel;
  private
    procedure Boucle(Buffer:Pointer;Length:Cardinal;BufferQueueLength:Integer);
    { Déclarations privées }
  public
    
    { Déclarations publiques }
  end;



var
  frmEntree_WaveIn: TfrmEntree_WaveIn;

  WaveIn_Objet: TWaveIn;
  Entree_WaveIn_Signal: TEntree_WaveIn_Signal;





  Function Entree_WaveIn_IsActive: Boolean;
  procedure Entree_WaveIn_Activer;
  procedure Entree_WaveIn_Desactiver;


  
implementation

{$R *.dfm}

uses Math, Entree_WaveIn_FFT_Form, Main;




Function Entree_WaveIn_IsActive: Boolean;
Begin
     result :=  WaveIn_Objet <> nil;
End;







procedure Entree_WaveIn_Activer;
Begin
      //Création
      if WaveIn_Objet <> nil then
          exit;

      WaveIn_Objet := TWaveIn.Create(nil);

      if frmEntree_WaveIn = nil then
           frmEntree_WaveIn := TfrmEntree_WaveIn.Create(nil);

      if frmEntree_WaveIn_FFT = nil then
           frmEntree_WaveIn_FFT := TfrmEntree_WaveIn_FFT.Create(nil);

                
      WaveIn_Objet.OnBuffer:= frmEntree_WaveIn.Boucle;

      //Réglages des paramètres
      WaveIn_Objet.DeviceID:= 0;//numéro du device (0 ça marche)
      WaveIn_Objet.Stereo:= false;
      WaveIn_Objet.Bits16:= true;
      WaveIn_Objet.Frequency:= 22050;
      WaveIn_Objet.BufferCount:=1+2;
      WaveIn_Objet.BufferSize:= 2 * Entree_WaveIn_Tampon_NbEchantillons;
                      {c'est la taille du buffer en octets  }


      WaveIn_Objet.Start;


      //interface
      frmEntree_Wavein_FFT.MettreAJour;
      MainForm.mnuEntree_WaveIn_Activer.Enabled := false;
      MainForm.mnuEntree_WaveIn_DesActiver.Enabled := true;
End;







procedure Entree_WaveIn_Desactiver;
Begin
     if WaveIn_Objet = nil then
          exit;
          
     WaveIn_Objet.Stop;
     WaveIn_Objet.Free;
     WaveIn_Objet := nil;


     if frmEntree_Wavein_FFT <> nil then
         frmEntree_Wavein_FFT.MettreAJour;

     MainForm.mnuEntree_WaveIn_Activer.Enabled := true;
     MainForm.mnuEntree_WaveIn_DesActiver.Enabled := false;
End;






{le truc qui suit est moche et geek !}
procedure TfrmEntree_WaveIn.Boucle(Buffer:Pointer;Length:Cardinal;BufferQueueLength:Integer);

  function SampleValue(SampleIndex:Integer):Integer;               //Extract sample value from index
  begin
    if WaveIn_Objet.Stereo then begin
      if WaveIn_Objet.Bits16 then          //If 16bit then take the mean of the 2 channels
        Result:=(High(Word)+(Integer(SmallInt(PWordArray(Buffer)[2*SampleIndex]))+Integer(SmallInt(PWordArray(Buffer)[2*SampleIndex+1])))) div 2
      else
        Result:=(Integer(PByteArray(Buffer)[2*SampleIndex])+Integer(PByteArray(Buffer)[2*SampleIndex+1]))*128;
    end else begin
      if WaveIn_Objet.Bits16 then
        Result:={(High(Word) div 2)+}Smallint(PWordArray(Buffer)[SampleIndex])
      else
        Result:=PByteArray(Buffer)[SampleIndex]*256;
    end;
  end;

var n, i: integer;
  
Begin
  n:= min(Entree_WaveIn_Tampon_NbEchantillons, Integer(Length) div 2); // nombre de valuers dans le buffer

  for i := 0 to n -1 do
      Entree_WaveIn_Signal[i] := SampleValue(i);

  frmEntree_WaveIn_FFT.Boucle;

End;









end.
