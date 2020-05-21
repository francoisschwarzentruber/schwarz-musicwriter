unit Voix_Gestion;

{Unité : Voix_Gestion
 Fonction : gérer l'état du système de voix (automatique, nouvelle voix..)
 Auteur : François Schwarzentruber}

interface



{mode nouvelle voix}
procedure Voix_Gestion_ModeNouvelleVoix_Set;
procedure Voix_Gestion_ModeNouvelleVoix_Arreter;


procedure Voix_Gestion_ModeAutomatique_Set(b: Boolean);

Procedure Voix_Gestion_MettreAJourPanneau;




{avoir l'état du système de gestion}
Function Voix_Gestion_IsModeNouvelleVoix: Boolean;
Function Voix_Gestion_IsModeAutomatique: Boolean;




implementation

uses Main, Voix, StdCtrls,
      Graphics {pour fsBold...},
      MusicGraph {pour Portees_Actives_Toutes},
      Message_Vite_Fait,
           MusicUser_PlusieursDocuments;


var ModeVoixAuto : Boolean = true;



Procedure interne_Voix_Gestion_MettreAJourLabelInfo;
{met à jour le label frmVoix.lblInfo}
Begin
    if frmVoix <> nil then
    with frmVoix.lblInfo do
    Begin
        if Voix_Gestion_IsModeNouvelleVoix then
        Begin
             Font.Style := [];
             Caption := 'Vous écrivez dans une nouvelle voix qui sera :';
        End
        else if Voix_Gestion_IsModeAutomatique then
        Begin
            Font.Style := [fsItalic];  
             Caption := 'La voix courante est la plus proche du curseur, ie :';
        End
        else
        Begin
            Font.Style := [];  
            Caption := 'Votre voix courante est fixée et vous écrivez dans la voix :';
        End;



    End;
End;






procedure Voix_Gestion_ModeAutomatique_Set(b: Boolean);
var ip, p1, p2: integer;
Begin
    if b <> ModeVoixAuto then
    Begin

         ModeVoixAuto := b;
         if MusicWriter_IsFenetreDocumentCourante then
         Begin
              if b then
              Begin
                  Portees_Actives_Toutes;
//                  Message_Super_Vite_Fait_Afficher('Mode voix automatique !');
              End
              else
              Begin

                  ip := actchild.Composition.Voix_Indice_To_Portee(
                                      actchild.Curseur.GetiVoixSelectionnee
                                      );

                  actchild.Composition.GetGroupePortees(ip, p1, p2);
                  Portees_Actives_Set(p1, p2);

              End;



              actchild.ReaffichageComplet;
         End;
    End;


    MainForm.actionVoixAutomatique.Visible := not b;
//    MainForm.actionVoixSpecifique.Visible := b;
    MainForm.tbnVoixSpecifique.Visible := b;

    if frmVoix <> nil then
        frmVoix.tbnVoixAutomatique.Down := b;

    
    if b then
       Voix_Gestion_ModeNouvelleVoix_Arreter;

    Voix_Gestion_MettreAJourPanneau;
    interne_Voix_Gestion_MettreAJourLabelInfo;
    
End;



    procedure interne_Voix_Gestion_ModeNouvelleVoix_Set(b: Boolean);
    {s'occupe de gérer le mode nouvelle voix mais sans tenir compte
     de l'éventuel changement à faire au niveau de l'état du
     "mode automatique" etc.}
    Begin
        MainForm.tbnNvVoix.Down := b;

        if frmVoix <> nil then
           frmVoix.tbnNvVoix.Down := b;

        interne_Voix_Gestion_MettreAJourLabelInfo;
    End;


    
procedure Voix_Gestion_ModeNouvelleVoix_Set;
Begin
    Voix_Gestion_ModeAutomatique_Set(false);

    interne_Voix_Gestion_ModeNouvelleVoix_Set(true);

End;


procedure Voix_Gestion_ModeNouvelleVoix_Arreter;
Begin
    interne_Voix_Gestion_ModeNouvelleVoix_Set(false);

End;



Function Voix_Gestion_IsModeNouvelleVoix: Boolean;
Begin
     result := MainForm.tbnNvVoix.Down;
End;



Function Voix_Gestion_IsModeAutomatique: Boolean;
{est vrai si on est en mode automatique pour la voix...
(ie on écrit dans la voix par défaut de la portée courante) }
Begin
        result := ModeVoixAuto;


End;






Procedure Voix_Gestion_MettreAJourPanneau;
Begin
     MainForm.panVoixSelectionnee.Repaint;

     if frmVoix <> nil then
          frmVoix.panVoixSelectionnee.Repaint;
End;

end.
