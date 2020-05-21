unit Instrument_Portee;


interface




uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frame_Composition_Instruments, Buttons, ImgList,
  ComCtrls, ToolWin, ExtCtrls;

type
  TfrmComposition_Instruments = class(TForm)
    frameComposition_Instruments: TframeComposition_Instruments;
    BitBtn3: TBitBtn;
    ToolBar1: TToolBar;
    tlbSuppr: TToolButton;
    tlbVersleHaut: TToolButton;
    tlbVersleBas: TToolButton;
    ImageList: TImageList;
    tbnInstrument_Add: TToolButton;
    tlbProprietes: TToolButton;
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frameComposition_InstrumentslistClick(Sender: TObject);
    procedure tlbSupprClick(Sender: TObject);
    procedure tlbVersleHautClick(Sender: TObject);
    procedure tlbVersleBasClick(Sender: TObject);
    procedure tbnInstrument_AddClick(Sender: TObject);
    procedure tlbProprietesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Déclarations privées }

  public
    { Déclarations publiques }
    procedure MettreAJourFenetre;
  end;

var
  frmComposition_Instruments: TfrmComposition_Instruments;

  procedure frmComposition_Instruments_Show;
  procedure frmComposition_Instruments_Hide;

  
implementation


{$R *.dfm}

uses Main, Instrument_Add, Instruments {pour Is_Instrument_Clavier},
     MusicGraph_Portees, Instrument_Proprietes {pour IGP},
     Musicwriter_Erreur, langues,
          MusicUser_PlusieursDocuments;


procedure frmComposition_Instruments_Show;
Begin
    if frmComposition_Instruments = nil then
           frmComposition_Instruments := TfrmComposition_Instruments.Create(nil);

    frmComposition_Instruments.ShowModal;
End;


procedure frmComposition_Instruments_Hide;
Begin
    if frmComposition_Instruments <> nil then
           frmComposition_Instruments.Hide
    else
           MessageErreur('erreur : on veut fermer la fenêtre qui liste les instruments alors qu''elle n''est pas chargée');
End;

procedure TfrmComposition_Instruments.FormActivate(Sender: TObject);
begin
    if MusicWriter_IsFenetreDocumentCourante then
           MettreAJourFenetre;

end;

procedure TfrmComposition_Instruments.FormCreate(Sender: TObject);
begin
     Langues_TraduireFenetre(self);   
     frameComposition_Instruments.AvecOeilEtOreille;
end;







procedure TfrmComposition_Instruments.frameComposition_InstrumentslistClick(
  Sender: TObject);
begin
  frameComposition_Instruments.listClick(Sender);
  With frameComposition_Instruments.list do
  Begin
      tlbVersleHaut.Enabled := (ItemIndex > 0);
      tlbVersleBas.Enabled := (ItemIndex < Count-1);
  End;
  
end;








procedure TfrmComposition_Instruments.tlbSupprClick(Sender: TObject);
begin
       if not MusicWriter_IsFenetreDocumentCourante then exit;

       case MessageDlg('Etes-vous sûr de vouloir supprimer l''instrument sélectionné (' +
                       frameComposition_Instruments.GetInstrument_To_Str + ') ?' +
                      ' (attention, tu ne peux plus annuler après coup !!)'
                          , mtWarning, [mbYes, mbNo], 0) of
              mrYes:
              Begin
                  actchild.Composition.I_Instruments_Supprimer(
                            frameComposition_Instruments.GetInstrument_Portee);
                  actchild.ReaffichageComplet;
              End;
      end;

       MettreAJourFenetre;
end;



procedure TfrmComposition_Instruments.MettreAJourFenetre;
Begin
     frameComposition_Instruments.MettreAJour;

     tlbSuppr.Enabled := (frameComposition_Instruments.List.Items.Count > 1);

     frameComposition_InstrumentslistClick(nil);

End;






procedure TfrmComposition_Instruments.tlbVersleHautClick(Sender: TObject);
begin
       if not MusicWriter_IsFenetreDocumentCourante then exit;

       actchild.Composition.I_Instruments_DeplacerVersLeHaut(
                         frameComposition_Instruments.GetInstrument_Portee);

       With frameComposition_Instruments.list do
              ItemIndex := ItemIndex - 1;

       actchild.ReaffichageComplet;

       MettreAJourFenetre;

       
end;

procedure TfrmComposition_Instruments.tlbVersleBasClick(Sender: TObject);
begin
       if not MusicWriter_IsFenetreDocumentCourante then exit;

       actchild.Composition.I_Instruments_DeplacerVersLeBas(
                          frameComposition_Instruments.GetInstrument_Portee);

       With frameComposition_Instruments.list do
              ItemIndex := ItemIndex + 1;

       actchild.ReaffichageComplet;

       MettreAJourFenetre;

       
end;





procedure TfrmComposition_Instruments.tbnInstrument_AddClick(
  Sender: TObject);

  procedure I_Instruments_Ajouter(p, instru: integer);
  Begin
      IGP := actchild.Composition;

      if Is_Instrument_Clavier(instru) then
             actchild.Composition.I_Instruments_Ajouter_Instrument_Portees_Clavier(
                   p,
                   instru)
      else
            actchild.Composition.I_Instruments_Ajouter_Instrument_Une_Portee(
                   p,
                   instru);

                   
  End;


begin
      if frmInstrument_Add_ShowModal = mrOk then
      Begin

          I_Instruments_Ajouter(
                   frameComposition_Instruments.GetInstrument_Portee,
                   frmInstrument_Add.frameInstruments_Choix.InstrumentNumero_Get);

          actchild.ReaffichageComplet;
          MettreAJourFenetre;

      End;



end;

procedure TfrmComposition_Instruments.tlbProprietesClick(Sender: TObject);
begin
       frmInstrument_Proprietes_ShowModal;
end;

procedure TfrmComposition_Instruments.FormResize(Sender: TObject);
begin
      frameComposition_Instruments.list.Repaint;
end;

procedure TfrmComposition_Instruments.BitBtn3Click(Sender: TObject);
begin
    Close;
end;

end.
