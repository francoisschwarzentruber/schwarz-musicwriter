unit Intro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmIntro = class(TForm)
    Image1: TImage;
    lblInfo: TLabel;
    lblPeripheriqueMIDIDetecte: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Intro_Avancer;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

  procedure FenetreIntro_Cacher;
  procedure FenetreIntro_Texte(str: string);


  
var frmIntro: TfrmIntro;



var option_Demarrage_Jingle: Boolean;


procedure Intro_PeripheriqueMIDIDetecte;
















implementation

uses MusicUser,
     Musicwriter_Erreur,
     Message_VIte_Fait,
     mmsystem,
     Options_SaveAndLoad,
     langues;
{$R *.DFM}



procedure Intro_PeripheriqueMIDIDetecte;
Begin
     if frmIntro = nil then
          Message_Vite_Fait_Afficher(Langues_Traduire('Périphérique MIDI détecté !'))
     else
          frmIntro.lblPeripheriqueMIDIDetecte.VIsible := true;
End;


procedure FenetreIntro_Cacher;
Begin
    if frmIntro = nil then exit;

    frmIntro.Close;

End;


procedure FenetreIntro_Texte(str: string);
Begin
    frmIntro.Intro_Avancer;
    frmIntro.lblInfo.Caption := Langues_Traduire(str);
    frmIntro.lblInfo.Refresh;
End;



procedure TfrmIntro.FormCreate(Sender: TObject);
begin
    Langues_TraduireFenetre(self);
    INILoadProprieteDemarrage;
    if option_Demarrage_Jingle then
        sndPlaySound('interface_sons\demarrage_jingle.wav', SND_ASYNC);

        
    try
        Image1.Picture.LoadFromFile(DossierRacine + 'presentation_images\intro6.bmp');
    except
        MessageErreur('Fichier image (presentation_images\intro6.bmp) de la fenêtre d''accueil introuvable !');
    end;



    Top := Screen.Height div 2 - Height div 2;
    Left := Screen.Width div 2 - Width div 2;

end;

procedure TfrmIntro.Image1Click(Sender: TObject);
begin
     FenetreIntro_Cacher;
end;

procedure TfrmIntro.Intro_Avancer;
var newvalue : integer;
begin
      newvalue := AlphaBlendValue + 64;

      if newvalue >= 255 then
           AlphaBlendValue := 255
      else
           AlphaBlendValue := newvalue;

end;

end.
