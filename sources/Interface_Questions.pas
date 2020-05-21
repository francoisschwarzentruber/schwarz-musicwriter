unit Interface_Questions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QSystem_Inference, StdCtrls, ExtCtrls, QSystem;

type
  TfrmInterfaceQuestions = class(TForm)
    lstQuestions: TListBox;
    imgSupprimer: TImage;
    procedure lstQuestionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstQuestionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstQuestionsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmInterfaceQuestions: TfrmInterfaceQuestions;



procedure Interface_Questions_RegleMesure_AjouterQuestion(imesure: integer;
                                                          ivoix: integer;
                                                          i1, i2: integer;
                                                          durees_choix: array of TRationnel);

procedure Interface_Questions_Reset;
Procedure Interface_Questions_RegleMesure_iMesure_Set(imesure: integer);
Function Interface_Questions_RegleMesure_iMesure_Get: integer;
procedure Interface_Questions_Afficher;




implementation

{$R *.dfm}


uses Main, MusicGraph_CouleursVoix, MusicGraph, MusicSystem_Voix, MusicSystem_ElMusical,
  MusicSystem_ElMusical_Liste_Notes,
  MusicGraph_System,
  MusicWriter_Erreur,
  MusicSystem_CompositionAvecSelection,
  MusicUser_PlusieursDocuments;



type TInterface_Question = record
      imesure: integer;
      ivoix: integer;
      i1, i2: integer;
      durees_choix: array of TRationnel;
end;


var  private_imesure_traitee_courante: integer;
    tabInterface_Questions: array of TInterface_Question;

const Question_Choix_X_Debut = 48;
const Question_Choix_Largeur = 80;


Procedure Interface_Questions_RegleMesure_iMesure_Set(imesure: integer);
{prévient l'interface de questionnement sur les durées que les questions
 concernent la mesure n° imesure}
Begin
     private_imesure_traitee_courante := imesure;
End;

procedure Interface_Questions_Afficher;
Begin
    if length(tabInterface_Questions) = 0 then exit;
    if not frmInterfaceQuestions.Visible then
        frmInterfaceQuestions.ShowModal;


End;


Function Interface_Questions_RegleMesure_iMesure_Get: integer;
Begin
    result := private_imesure_traitee_courante ;
End;




Procedure tabInterface_Questions_i1i2_Get(num_question: integer; var i1, i2: integer);
Begin
     With actchild.Composition.GetMesure(tabInterface_Questions[num_question].imesure).VoixNum(tabInterface_Questions[num_question].ivoix) do
     Begin
           i1 := tabInterface_Questions[num_question].i1;
           i2 := tabInterface_Questions[num_question].i2;
     End;

     if i2 - i1 =-1 then exit;
     
     if i2 - i1 <> high(tabInterface_Questions[num_question].durees_choix) then
              MessageErreur('BOUBOUBOUBOU i1 = !' + inttostr(i1) + '; i2 = ' +
              inttostr(i2) +'; nb_choix = ' + inttostr(length(tabInterface_Questions[num_question].durees_choix)) );

End;




procedure Notes_Concernees_Par_Le_Choix_Selectionner(num_question: integer);
  var i, i1, i2: integer;
  Begin
      tabInterface_Questions_i1i2_Get(num_question, i1, i2);
      With actchild.Composition do
      Begin
            Selection_ToutDeselectionner;
            With tabInterface_Questions[num_question] do
            Begin
                With GetMesure(imesure).VoixNum(ivoix) do
                     for i := i1 to i2 do
                     With ElMusicaux[i] do
                     Begin
                            SelectionnerElMusical;
                            Selection_Valider;
                     End;

                 Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(imesure);
            End;
      End;

      actchild.ReaffichageComplet;
  End;



procedure Notes_Concernees_Aucune;
Begin
     With actchild do
     Begin
         Composition.Selection_ToutDeselectionner;
         actchild.ReaffichageComplet;
     End;
End;



procedure Interface_Questions_Reset;
Begin
     setlength(tabInterface_Questions, 0);
     frmInterfaceQuestions.lstQuestions.Clear;
End;



procedure Interface_Questions_RegleMesure_AjouterQuestion(imesure: integer;
                                                          ivoix: integer;
                                                          i1, i2: integer;
                                                          durees_choix: array of TRationnel);




          
var l, i: integer;

Begin

    l := length(tabInterface_Questions);

    setlength(tabInterface_Questions, l + 1);

    tabInterface_Questions[l].imesure := imesure;
    tabInterface_Questions[l].ivoix := ivoix;
    tabInterface_Questions[l].i1 := i1;
    tabInterface_Questions[l].i2 := i2;

    Setlength(tabInterface_Questions[l].durees_choix, length(durees_choix));

    for i := 0 to high(tabInterface_Questions[l].durees_choix) do
            tabInterface_Questions[l].durees_choix[i] := durees_choix[i];



           
    frmInterfaceQuestions.lstQuestions.AddItem('', nil);

End;






procedure TfrmInterfaceQuestions.lstQuestionsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var elms: TVoix;
    i2_min_affichee: integer;


    procedure ElMusicaux_Preparer;
    var i, n: integer;
        ecart_x, ecart_pixx: integer;
    Begin
         elms := TVoix.Create;

         With tabInterface_Questions[Index] do
         Begin
             elms.N_Voix := ivoix;

             ecart_x := (Question_Choix_Largeur * 10 * 80 div 100) div (i2 - i1 + 1);

             if ecart_x < 100 then ecart_x := 100;
             ecart_pixx := ecart_x * 100 div 800;

             i2_min_affichee := i1 + min(i2 - i1, Question_Choix_Largeur div ecart_pixx);


             With actchild.Composition.GetMesure(imesure).VoixNum(ivoix) do
              for i := i1 to i2_min_affichee do
              Begin
                  elms.AddElMusicalFin(CopieElMusicalEnDeselectionnant(ElMusicaux[i]));
                  elms.ElMusicaux[i-i1].pixx := (i-i1)*200;

                  if elms.ElMusicaux[i-i1].IsSilence then
                       elms.ElMusicaux[i-i1].position.portee := 0
                  else
                      for n := 0 to elms.ElMusicaux[i-i1].NbNotes - 1 do
                           elms.ElMusicaux[i-i1].Notes[n].position.portee := 0;

              End;


              elms.ElMusicaux[0].NvGroupe := true;


              elms.ElMusicaux_Queues_Calculer;

         End;
    End;


    procedure ElMusicaux_Preparer_PourChoix;
    var i: integer;
    Begin
         for i := 0 to high(Elms.Elmusicaux) do
         With elms.ElMusicaux[i] do
            Begin
                QueueVersBas := false;
                CalcGDBoules;
            End;
    End;



    procedure ElMusicaux_Afficher(x, y: integer);
    const margeX = 6;
    const MargeY = -00;
    Begin
         MusicGraph_Canvas_Set(lstQuestions.Canvas);
         Zoom := 80;
         //à revoir
         SetViewCourantPixDeb(-ZoomMaxPrec * (Rect.Left + x + MargeX) div Zoom,
                              -ZoomMaxPrec * (Rect.Top + y + MargeY) div Zoom);
         SetPixOrigin(0, 0);
         elms.DrawVoix(QInfini);

         C.FillRect(Classes.Rect(Rect.Left + x + Question_Choix_Largeur + 1,
                         Rect.Top, 1500, Rect.Bottom) );
    End;




    procedure ElMusicaux_AfficherChoix;
    var i, x: integer;

    Begin
          With tabInterface_Questions[Index] do
                for i := 0 to high(Elms.Elmusicaux) do
                      elms.ElMusicaux[i].Duree_Fixee_Set(durees_choix[i]);

          elms.CalcGrpNotes(Qel(1));
          elms.ElMusicaux_Queues_Calculer;


          x := Question_Choix_X_Debut;
          lstQuestions.Canvas.Rectangle(Rect.Left + x, Rect.Top, Rect.Left + x + Question_Choix_Largeur, Rect.Bottom);
          ElMusicaux_Afficher(Question_Choix_X_Debut, 1);

    End;




    procedure BoutonSupprimer_Afficher;
    Begin
        lstQuestions.Canvas.Draw(Rect.Right - imgSupprimer.Width, 10, imgSupprimer.Picture.Graphic);

    End;


    
begin
     if not MusicWriter_IsFenetreDocumentCourante then exit;

     With tabInterface_Questions[Index] do
     Begin
         lstQuestions.Canvas.Brush.Color := CouleursVoixFondList(actchild.Composition, ivoix);
         lstQuestions.Canvas.FillRect(Classes.Rect(Rect.Left, Rect.Top, Rect.Left + 30, Rect.Bottom));
         lstQuestions.Canvas.TextOut(Rect.Left, Rect.Top, 'mes n°' + inttostr(imesure + 1));
         lstQuestions.Canvas.TextOut(Rect.Left, Rect.Top + 16,
                         inttostr(actchild.Composition.Voix_Indice_To_Portee(ivoix) + 1) +
                         '_' + inttostr(actchild.Composition.Voix_Indice_To_NumVoixDansPortee(ivoix) + 1));

         ;

         tabInterface_Questions_i1i2_Get(Index, i1, i2);



         ElMusicaux_Preparer;

         ElMusicaux_Preparer_PourChoix;

         ElMusicaux_AfficherChoix;

         BoutonSupprimer_Afficher;
         


     End;

end;











procedure TfrmInterfaceQuestions.lstQuestionsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

var ichoix, nb_choix: integer;

  procedure SupprimerChoix(num_question: integer);
  var i: integer;
  Begin
       lstQuestions.Items.Delete(num_question);

       for i := num_question to high(tabInterface_Questions)-1 do
            tabInterface_Questions[i] := tabInterface_Questions[i+1];

       setlength(tabInterface_Questions, high(tabInterface_Questions));

  End;


  
  procedure AppliquerChoix(num_question: integer);
  var i, i1, i2: integer;
  Begin
      tabInterface_Questions_i1i2_Get(num_question, i1, i2);
      With  tabInterface_Questions[num_question] do
      Begin
           actchild.Composition.Cancellation_Etape_Ajouter_Selection('deviner durées');

           With actchild.Composition.GetMesure(imesure).VoixNum(ivoix) do
                for i := i1 to i2 do
                Begin
                       actchild.Composition.Selection_ToutDeselectionner;
                       ElMusicaux[i].SelectionnerElMusical;
                       ElMusicaux[i].Selection_Valider;
                       actchild.Composition.Selection_DeclarerMesureCommeContenantDesChosesSelectionnees(imesure);
                       actchild.Composition.I_Selection_ChangerDuree(durees_choix[i - i1]);
                end;

          // actchild.Composition.GetMesure(imesure).SimplifierEcriture;
      end;
      actchild.Composition.CalcTout(true);
      actchild.ReaffichageComplet;
      SupprimerChoix(num_question);
  End;





begin
       if not MusicWriter_IsFenetreDocumentCourante then exit;

       ichoix := lstQuestions.ItemIndex;

       if lstQuestions.ItemIndex = -1 then
       Begin
           beep;
           Exit;
       End;

       Notes_Concernees_Par_Le_Choix_Selectionner(lstQuestions.ItemIndex);

       if X > lstQuestions.Width - imgSupprimer.Width then
              SupprimerChoix(lstQuestions.ItemIndex)
       else
              
       if (Question_Choix_X_Debut < X) and (X < Question_Choix_X_Debut + Question_Choix_Largeur) then
             AppliquerChoix(lstQuestions.ItemIndex);

       if lstQuestions.Count = 0 then
       Begin
            Close;
            actchild.tmrFormResizing.Enabled := true;
       End;


end;






procedure TfrmInterfaceQuestions.lstQuestionsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var ichoix, nb_choix: integer;
begin
     if not MusicWriter_IsFenetreDocumentCourante then exit;


     ichoix := lstQuestions.ItemAtPos(Point(X, Y), true);

     if ichoix < 0 then
     Begin
         Notes_Concernees_Aucune;
         lstQuestions.Cursor := crDefault;
         exit;
     End;

     Notes_Concernees_Par_Le_Choix_Selectionner(ichoix);

     if X > lstQuestions.Width - imgSupprimer.Width then
           lstQuestions.Cursor := crHandPoint
     else if (Question_Choix_X_Debut < X) and (X < Question_Choix_X_Debut + Question_Choix_Largeur) then
           lstQuestions.Cursor := crHandPoint
     else
           lstQuestions.Cursor := crDefault;

end;

end.
