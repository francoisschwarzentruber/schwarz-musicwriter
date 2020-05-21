unit I_Trilles_Et_Attributs;

interface



      procedure I_Attribut_Courant_Set(a: integer);

      procedure I_Attribut_Courant_Desactiver;
      procedure I_Attribut_Courant_Activer;

      Function I_Attribut_Courant_Get: integer;
      Function I_Attribut_Courant_Is: Boolean;


      procedure I_Trille_Courant_Set(a: integer);

      procedure I_Trille_Courant_Desactiver;
      procedure I_Trille_Courant_Activer;

      Function I_Trille_Courant_Get: integer;
      Function I_Trille_Courant_Is: Boolean;
      
implementation

uses Main, MusicWriter_Erreur, Childwin,     MusicUser_PlusieursDocuments;

const tab_tbnAttributs_ImageIndex:array[0..1] of integer = (54, 55);
const tab_tbnTrilles_ImageIndex: array[2..4] of integer = (53, 53, 53);

var private_attribut_courant: integer = 0;
    private_attribut_is: Boolean = false;

var private_trille_courant: integer = 2;
    private_trille_is: Boolean = false;






procedure I_Attribut_Courant_Set(a: integer);
Begin
    MainForm.tbnAttributs.ImageIndex := tab_tbnAttributs_ImageIndex[a];
    private_attribut_courant := a;
    I_Attribut_Courant_Activer;
End;


procedure I_Attribut_Courant_Desactiver;
Begin
    MainForm.tbnAttributs.Down := false;
    private_attribut_is := false;

    With actchild do With Composition do
    if Selection_YaUneSelection then
    Begin
         I_Selection_Attributs_Supprimer;
         ReaffichageComplet;
    End;
End;



procedure I_Attribut_Courant_Activer;
Begin
    MainForm.tbnAttributs.Down := true;
    private_attribut_is := true;

    With actchild do With Composition do
    if Selection_YaUneSelection then
    Begin
         I_Selection_Attributs_Appliquer(private_attribut_courant);
         ReaffichageComplet;
    End;

End;


Function I_Attribut_Courant_Get: integer;
Begin
    if private_attribut_is then
          result := private_attribut_courant
    else
          MessageErreur('I_Attribut_Courant_Get : on tente de connaitre l''attribut alors que ce n''est pas activé !');
End;


Function I_Attribut_Courant_Is: Boolean;
Begin
     result := private_attribut_is;
End;




















procedure I_Trille_Courant_Set(a: integer);
Begin
    MainForm.tbnTrilles.ImageIndex := tab_tbnTrilles_ImageIndex[a];
    private_trille_courant := a;
    I_Trille_Courant_Activer;
End;


procedure I_Trille_Courant_Desactiver;
Begin
    MainForm.tbnTrilles.Down := false;
    private_trille_is := false;

    With actchild do With Composition do
    if Selection_YaUneSelection then
    Begin
         I_Selection_Trilles_Supprimer;
         ReaffichageComplet;
    End;
End;



procedure I_Trille_Courant_Activer;
Begin
    MainForm.tbnTrilles.Down := true;
    private_trille_is := true;

    With actchild do With Composition do
    if Selection_YaUneSelection then
    Begin
         I_Selection_Trilles_Appliquer(private_trille_courant);
         ReaffichageComplet;
    End;

End;


Function I_Trille_Courant_Get: integer;
Begin
    if private_trille_is then
          result := private_trille_courant
    else
          MessageErreur('I_Trille_Courant_Get : on tente de connaitre le trille alors que ce n''est pas activé !');
End;


Function I_Trille_Courant_Is: Boolean;
Begin
     result := private_trille_is;
End;

end.
 