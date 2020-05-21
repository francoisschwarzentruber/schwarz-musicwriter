unit MusicUser_PlusieursDocuments;

interface


uses ChildWin;


Function MusicUser_NbDocumentsOuverts: integer;
Function MusicWriter_IsFenetreDocumentCouranteOuFenetreEnTrainDeSOuvrir: Boolean;
Function MusicWriter_IsFenetreDocumentCouranteOuPasEnTrainDeSeFermer: Boolean;
Function MusicWriter_IsFenetreDocumentCourante: Boolean;

Function actchild : TMDIChild; {pointe vers la fenêtre fille MDI active
                                       ...et celle qui joue le MIDI actif}



implementation

uses Main, MusicWriter_Erreur;


Function MusicUser_NbDocumentsOuverts: integer;
Begin
      result := MainForm.TabControlChildWin.Tabs.Count;
End;





Function MusicWriter_IsFenetreDocumentCourante: Boolean;
var mdi: TMDIChild;
Begin

     result := (MusicUser_NbDocumentsOuverts > 0);
     exit;
     mdi := (MainForm.ActiveMDIChild as TMDIChild);

     if mdi = nil then
     Begin
          result := false;

     End
     else if mdi.Composition = nil then
        //là, ça veut dire que la fenêtre est en train de se fermer !
         result := false
     else
         result := true;
End;




Function MusicWriter_IsFenetreDocumentCouranteOuFenetreEnTrainDeSOuvrir: Boolean;
var mdi: TMDIChild;
    i: integer;
Begin
     if (MusicUser_NbDocumentsOuverts > 1) then
     Begin
           result := true;
           Exit;
     end;


     result := false;

     for i := 0 to MainForm.MDIChildCount - 1 do
     Begin
         if (MainForm.MDIChildren[i] is TMDIChild) then
         Begin
              result := true;
              exit;
         end;

     End;

     exit;

     if not (MainForm.ActiveMDIChild is TMDIChild) then
     Begin
          result := false;
          Exit;
     End;


     mdi := (MainForm.ActiveMDIChild as TMDIChild);

     if mdi = nil then
     Begin
           if MainForm.MDIChildCount = 1 then
               result := (MainForm.MDIChildren[0] is TMDIChild)
           else
               result := false;

     End
     else if mdi.Composition = nil then
        //là, ça veut dire que la fenêtre est en train de se fermer !
         result := false
     else
         result := true;
End;




Function MusicWriter_IsFenetreDocumentCouranteOuPasEnTrainDeSeFermer: Boolean;
var mdi: TMDIChild;
Begin
     if not (MainForm.ActiveMDIChild is TMDIChild) then
     Begin
         result := false;
         exit;
     end;

     mdi := (MainForm.ActiveMDIChild as TMDIChild);

     if mdi = nil then
           result := false
     else if mdi.Composition = nil then
         result := false
     else
         result := true;
End;



Function actchild : TMDIChild; {pointe vers la fenêtre fille MDI active
                                       ...et celle qui joue le MIDI actif}
Begin
//    result := (MainForm.ActiveMDIChild as TMDIChild);


    if MainForm.TabControlChildWin.TabIndex = -1 then
    Begin
        result := nil 
    End
    else
    Begin
        result := MainForm.TabControlChildWin.Tabs.Objects[MainForm.TabControlChildWin.TabIndex] as TMDIChild;

    End;


    if (result = nil) and (MainForm.MDIChildCount > 0) then
         MessageErreur('bizarre...');

    if result <> nil then
        if result.Composition = nil then
           result := nil;
    {petite bidouille...}
    
    if result = nil then
          MessageErreur('Erreur ! actchild est nil ! Il faut faire un test avant !');


End;






end.
