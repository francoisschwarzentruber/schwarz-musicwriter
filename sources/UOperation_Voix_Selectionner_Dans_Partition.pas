unit UOperation_Voix_Selectionner_Dans_Partition;

interface

procedure Voix_Selectionner_Dans_Partition_Init(texte: string);
Function Voix_Selectionner_IsDansCeMode: Boolean;
procedure Voix_Selectionner_Dans_Partition_Close;

procedure Voix_Selectionner_Dans_Partition_PasBesoinDuBoutonAnnuler;

implementation

uses Main, langues;

procedure Voix_Selectionner_Dans_Partition_Init(texte: string);
Begin
    MainForm.lblVoixSelectionnerTexte.Caption := Langues_Traduire(texte);
    MainForm.panVoixSelectionner.Visible := true;
    MainForm.cmdVoixSelectionnerAnnuler.Visible := true;
End;



procedure Voix_Selectionner_Dans_Partition_PasBesoinDuBoutonAnnuler;
Begin
    MainForm.cmdVoixSelectionnerAnnuler.Visible := false;
End;

Function Voix_Selectionner_IsDansCeMode: Boolean;
Begin
    result := MainForm.panVoixSelectionner.Visible;
End;


procedure Voix_Selectionner_Dans_Partition_Close;
Begin
    MainForm.panVoixSelectionner.Visible := false;
End;


end.
