unit Entree_WaveIn_FFT_Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Entree_WaveIn_FFT, Entree_WaveIn, ComCtrls, ToolWin, ImgList, ExtCtrls;

type
  TfrmEntree_Wavein_FFT = class(TForm)
    ToolBar1: TToolBar;
    tbnEditer: TToolButton;
    img: TImageList;
    ToolButton1: TToolButton;
    cmdActiver: TToolButton;
    cmdDesactiver: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure cmdActiverClick(Sender: TObject);
    procedure cmdDesactiverClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Déclarations privées }

     Function Spectre_Afficher_IFreqToX(ifreq: integer): integer;
     Function Spectre_Afficher_XToIFreq(x: integer): integer;
     Function Spectre_Afficher_GrapheYBase: integer;
     procedure Spectre_Afficher;
  public
     procedure MettreAJour;
     procedure Boucle;
    { Déclarations publiques }
  end;

const i1 = -12*2;
      i2 = 12*3;



var
  frmEntree_Wavein_FFT: TfrmEntree_Wavein_FFT;

  sortieR, SortieI: TSpectre;
  spectre: TSpectrePuiss;




  option_Entree_WaveIn_Sensibilite: real = -50;



   Function Entree_WaveIn_IsExcite: Boolean;



implementation


uses MusicHarmonie, MusicSystem, Main, MusicUser,
  MusicSystem_CompositionAvecPagination,
  options, Entree_WaveIn_SortieMIDI,
       MusicUser_PlusieursDocuments;
{$R *.DFM}




const Spectre_iFreqMaxAffichee = FFT_MaxIFreq div 4;

var hn_courant_depuis: integer = 0;
    hn_courant: THauteurNote;
    private_entree_wavein_excite: Boolean = false;







Function Entree_WaveIn_IsExcite: Boolean;
Begin
     result := private_entree_wavein_excite;
End;


procedure Entree_WaveIn_JaireconnuHauteurNote(hn_nouveau: THauteurNote);
Begin
    if Entree_WaveIn_IsExcite and IsHauteursNotesEgales(hn_courant, hn_nouveau) then
          inc(hn_courant_depuis)
    else
          hn_courant_depuis := 0;

    private_entree_wavein_excite := true;
    hn_courant := hn_nouveau;
End;


procedure Entree_WaveIn_JaiTraiteUneNote;
Begin
     hn_courant_depuis := -10;
End;


Function Entree_WaveIn_IsHauteurNoteStable: Boolean;
Begin
     result := (hn_courant_depuis > 0) and private_entree_wavein_excite;
End;



procedure Entree_WaveIn_RienNeMexcite;
Begin
     hn_courant_depuis := 0;
     private_entree_wavein_excite := false;
End;






Function TfrmEntree_Wavein_FFT.Spectre_Afficher_IFreqToX(ifreq: integer): integer;
Begin
     result := ifreq * ClientWidth div (Spectre_iFreqMaxAffichee);
End;


Function TfrmEntree_Wavein_FFT.Spectre_Afficher_XToIFreq(x: integer): integer;
Begin
     result := x * Spectre_iFreqMaxAffichee div ClientWidth;
End;


Function TfrmEntree_Wavein_FFT.Spectre_Afficher_GrapheYBase: integer;
Begin
    result := ClientHeight -3;
End;

procedure TfrmEntree_Wavein_FFT.Spectre_Afficher;

      procedure Spectre_AxeX_Afficher;
      const pas_hertz = 100;

      var i, x: integer;
      Begin
          Canvas.Pen.Style := psDash;
          Canvas.Pen.Color := $888888;
          for i := 1 to 10 do
          Begin
                 x := Spectre_Afficher_IFreqToX(i * pas_hertz);
                 Canvas.MoveTo(x, 0);
                 Canvas.LineTo(x, ClientHeight);
                 Canvas.TextOut(x, ClientHeight - 20, inttostr(i * pas_hertz) + 'Hz');

          End;
      End;


      procedure Spectre_Graphique_Afficher;
      const factzoomysp = 3;
      var i, grhy: integer;
      Begin
            Canvas.Pen.Color := 0;
            Canvas.Pen.Style := psSolid;
            grhy := Spectre_Afficher_GrapheYBase;
            Canvas.moveTo(0, grhy - round(spectre[Spectre_Afficher_XToIFreq(0)]*factzoomysp));
            for i := 0 to ClientWidth-1 do
                  Canvas.lineTo(i, grhy - round(spectre[Spectre_Afficher_XToIFreq(i)]*factzoomysp));
      End;
Begin

      Canvas.Brush.Color := RGB(255,255,255);
      Canvas.FillRect(ClientRect);

      Spectre_AxeX_Afficher;
      Spectre_Graphique_Afficher;
End;



procedure TfrmEntree_Wavein_FFT.Boucle;
{est exécuté à chaque fois que le tampon du son a besoin d'être vidé
on traite alors les données}

var i, ifreqchante: integer;
    v, maxv: real;
    hn_entendue, hn_aecouter, hn_aecrire: THauteurNote;


    Function Entree_WaveIn_Sensibilite_Get: real;
    Begin
        result := option_Entree_WaveIn_Sensibilite;
    End;




Begin


      fft(0, Entree_WaveIn_Signal, sortieR, SortieI);
      CreerSpectrePuiss(sortieR,SortieI, spectre);

      Spectre_Afficher;



      {teste les fréquences : on cherche ifreqchante}
      maxv := -100000;
      ifreqchante := -1000;
      for i := i1 to i2 do
      Begin


           v := Frequence_DansSpectre_Evaluer(spectre, NbDemiTonToFreq(i));


           if v > maxv then
           Begin
                 maxv := v;
                 ifreqchante := i;
           End;

      End;

      //Canvas.TextOut(0,64,floattostr(maxv));

      hn_entendue := NbDemiTonToHauteurNote(ifreqchante);


      if (maxv > Entree_WaveIn_Sensibilite_Get) {and FreqStable(ifreqchante)} then
      Begin
            hn_entendue := NbDemiTonToHauteurNote(ifreqchante);
            Entree_WaveIn_JaireconnuHauteurNote(hn_entendue);

            GetHauteurNote_Sans_Erreur(intervalle0, hn_entendue, hn_aecouter);

            Entree_WaveIn_SortieMIDI_Play(hn_aecouter);


            if MusicWriter_IsFenetreDocumentCourante then
            Begin
                  GetHauteurNote_Sans_Erreur(intervalle0, hn_entendue, hn_aecrire);
                  hn_aecrire := Enharmoniquer(hn_aecrire, actchild.Curseur.GetTonaliteCourante);
                  Canvas.TextOut(20, 150, HauteurNoteToStr(hn_aecrire));
                  actchild.Curseur_Entree_WaveIn_Exciter(hn_aecrire);

                  if Entree_WaveIn_IsHauteurNoteStable then
                  Begin

                      if tbnEditer.Down and (not Outil_MettreNoteIsModeSouris) then
                      Begin
                            actchild.Entree_HauteurNote_Traiter(hn_aecrire);
                            {w := 13;
                            actchild.FormKeyDown(nil, w, []); }
                      End;

                      Entree_WaveIn_JaiTraiteUneNote;
                 end;
            End;

      End
      else //si on ne perçoit aucun son... on rétablit qu'on peut à nouveau entrer des notes
      Begin
            Entree_WaveIn_RienNeMexcite;
            Entree_WaveIn_SortieMIDI_Stop;
      End;


End;









procedure TfrmEntree_Wavein_FFT.ToolButton1Click(Sender: TObject);
begin
    Options_BoiteDeDialogue_Afficher_EntreeMicrophone;
end;

procedure TfrmEntree_Wavein_FFT.cmdActiverClick(Sender: TObject);
begin
      Entree_WaveIn_Activer;
end;

procedure TfrmEntree_Wavein_FFT.cmdDesactiverClick(Sender: TObject);
begin
       Entree_WaveIn_Desactiver;
end;



procedure TfrmEntree_Wavein_FFT.MettreAJour;
Begin
       if Entree_WaveIn_IsActive then
       Begin
           cmdActiver.Enabled := false;
           cmdDesactiver.Enabled := true;

       End
       else
       Begin
           cmdActiver.Enabled := true;
           cmdDesactiver.Enabled := false;

       End;

       FormPaint(nil);
End;

procedure TfrmEntree_Wavein_FFT.FormPaint(Sender: TObject);
begin
      if not Entree_WaveIn_IsActive then
      Begin
        Canvas.Brush.Color := $888888;
        Canvas.Brush.Style := bsSolid;

        Canvas.FillRect(ClientRect);
      End;
end;

end.
