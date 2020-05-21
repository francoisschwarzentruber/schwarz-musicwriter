unit MusicGraph_User;

interface

uses MusicSystem_Composition,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_ElMusical,
     MusicSystem_Types,
     MusicSystem_CompositionBase {pour les accolades},
     MusicSystem_CompositionAvecPagination {pour les MusicWriterCalcule},
     MusicSystem_CompositionListeObjetsGraphiques,
     MusicGraph_System,

     MusicGraph_CouleursUser,

     MusicSystem_Curseur,


     RectList,

     Graphics, Types{rect},

     Qsystem,

     MusicHarmonie;




type
     TSourisCurseur_Clignotement_Etat = (scceCouleurVoixNote, scceGrise);


procedure DrawBarreLectureMIDI(C:TCanvas;
                               Composition: TComposition; BlitRectsApres: TRectList;
                               MesurePlayed: integer;
                               TempsPlayed: TRationnel;
                               excitation: integer);


procedure Ictus_Draw(C:TCanvas;
                               Composition: TComposition; BlitRectsApres: TRectList;
                               MesurePlayed: integer;
                               TempsPlayed: TRationnel);

procedure DrawNotesSelectionnees(C: TCanvas;
                                 Composition: TComposition;
                                 optlignehaut, optlignebas: integer);

procedure DrawRectangleSelection(C: TCanvas;
                       BlitRectsApres: TRectList;
                       ClientRect,
                       SelectionRect: TRect);

procedure DrawNotesDeplacements(BlitRectsApres: TRectList;
                                const Composition: TComposition;
                                const optlignehaut, optlignebas: integer;
                                const IntervalleDeplacement: TIntervalle;
                                const DiffPorteeDeplacement: integer;
                                
                                const LigneCourante: integer;
                                const Deplacement_Tablature_Corde_Deplacement: integer;
                                var BlitterToutDuBackBuffer: Boolean);


procedure DrawPausesDeplacements(Composition: TComposition;
                                optlignehaut, optlignebas: integer;
                                HauteurDeplace: integer);



procedure DrawFondSelectionMesures(C:TCanvas;
                         Composition: TComposition;
                         DebMes: integer; FinMes: integer);


procedure DrawFondVoixNonPresente(C: TCanvas;
                             Composition: TComposition;
                             BlitRectsAvant: TRectList;
                             VoixSelectionnee: integer;
                             possscur: TPosition;
                             MesureCourante: integer);                         


procedure DrawCadreAutourMesureCourante(C: TCanvas;
                                        Composition: TComposition;
                                        AncienneMesureCourante: integer;
                                        AncienneLigneCourante: integer;
                                        MesureCourante: integer;
                                        LigneCourante: integer);

procedure DrawLiseraiSelectionVoix(C: TCanvas;
                                   Composition: TComposition;
                                   optlignehaut: integer;
                                   optlignebas: integer;
                                   x1: integer;
                                   x2: integer;
                                   VoixSelectionnee: integer);


procedure DrawBarreDeMesureSousCurseur(C: TCanvas;
                                       Composition: TComposition;
                                       BlitRectsApres: TRectList;
                                       imesure: integer);

procedure Draw_CurseurClavier(C: TCanvas;
                              Composition: TComposition;
                              BlitRectsApres: TRectList;
                              Curseur: TCurseur);

                                       
procedure DrawContourRythme(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    iligne,
                    imesure,
                    iportee: integer);


procedure DrawContourTonalite(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    iligne,
                    imesure,
                    iportee: integer);

procedure DrawContourTonaliteAvantBarreDeMesureSousCurseur(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    iligne,
                    imesure,
                    iportee: integer);
                    
procedure DrawContourClef(C: TCanvas;
                Composition: TComposition;
                BlitRectsApres: TRectList;
                iligne, imesure, x, iportee: integer);

procedure DrawPortees_Instrument_Nom_Zone_SousCurseur(C: TCanvas;
                                                       Composition: TComposition;
                                                       BlitRectsApres: TRectList;
                                                       Portees_Instruments_Noms_Zone_iLigne,
                                                       Portees_Instruments_Noms_Zone_iPortee
                                                       : integer);
                                                           
procedure DrawContourOctavieur(C: TCanvas;
                               Composition: TComposition;
                               BlitRectsApres: TRectList;
                               LigneCourante,
                               iportee,
                               indice: integer);


procedure DrawContourObjetGraphique(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    GraphicObjet_SousCurseur_Get: TGraphicObjet);

                    
procedure Draw_Tablature_PetitRectangle(C: TCanvas;
                      Composition: TComposition;
                      BlitRectsApres: TRectList;
                      VoixSelectionnee: integer;
                      a_pixxorigin : integer;
                      iligne: integer;
                      MesureCourante: integer;
                      possscur: TPosition;
                      Xdansmesure: integer;
                      ClientHeight: integer);


procedure Draw_Tablature_Curseur(C: TCanvas;
                      Composition: TComposition;
                      BlitRectsApres: TRectList;
                      VoixSelectionnee: integer;
                      a_pixxorigin : integer;
                      iligne: integer;
                      MesureCourante: integer;
                      possscur: TPosition;
                      Xdansmesure: integer;
                      ClientHeight: integer);

                                                                                                            
procedure DrawCurseur_Modele(C: TCanvas;
                      Composition: TComposition;
                      BlitRectsApres: TRectList;
                      VoixSelectionnee: integer;
                      Curseur_IsExcite: Boolean;
                      a_pixxorigin : integer;
                      iligne: integer;
                      MesureCourante: integer;
                      possscur: TPosition;
                      Xdansmesure: integer;
                      ModelesVoix: TVoix;
                      IntervalleDeplacement: TIntervalle;
                      ClientHeight: integer;
                      SourisCurseur_Clignotement_Etat: TSourisCurseur_Clignotement_Etat);

procedure DrawPauseAInserer(C: TCanvas;
                            Composition: TComposition;
                            BlitRectsApres: TRectList;
                            LigneCourante,
                            MesureCourante,
                            VoixSelectionnee: integer;
                            possscur: TPosition);







implementation

uses MusicGraph,
     MusicGraph_Portees {IGiLigne},
     MusicUser {IsVoixAccessibleEdition},
     MusicGraph_CouleursVoix;


     
const Qch_Sous_Curseur_Selection_Trait_Couleur = $00BB00;
      Qch_Sous_Curseur_Selection_Trait_Epaisseur = 3;

      cteHauteurRythme = 7;
      cteHauteurTonalite = 8;

      Tonalite_Ellipse_Marge_Gauche = 60;
      Tonalite_Ellipse_Marge_Droite = 0;

      Tonalite_AvantBarreDeMesure_Ellipse_Marge_Gauche = 40;
      Tonalite_AvantBarreDeMesure_Ellipse_Marge_Droite = 60;

      Rythme_Ellipse_Marge = 40;


const BarreLecture_Epaisseur = 6;
      BarreLecture_Couleur = clRed;

      Ictus_Epaisseur = 4;
      Ictus_Couleur = BarreLecture_Couleur;

      
procedure Ictus_Draw(C:TCanvas;
                               Composition: TComposition; BlitRectsApres: TRectList;
                               MesurePlayed: integer;
                               TempsPlayed: TRationnel);
const epaisseur_clip = 160;

var x: integer;
    iLignePlayed: integer;
    
Begin
     Composition.SetOriginMesure(MesurePlayed);
        x := Composition.GetMesure(MesurePlayed).XATempsOuEntre(TempsPlayed);
        C.Pen.Width := Ictus_Epaisseur; //+ excitation;
        C.Pen.Color := Ictus_Couleur;
        //C.TextOut(0,0,'Temps : ' + QToStr(TempsPlayed));
        iLignePlayed := Composition.LigneAvecMes(MesurePlayed);
        DrawIctus(x, Composition, iLignePlayed);
        BlitRectsApres.AjouterNextBlitRect(ScrRect(Rect(pixxorigin + x - epaisseur_clip,
                                     pixyorigin - epaisseur_clip,
                                     pixxorigin + x + epaisseur_clip,
                                     pixyorigin + Composition.minHauteurLigne(iLignePlayed)  + epaisseur_clip)));
End;


procedure DrawBarreLectureMIDI(C:TCanvas;
                               Composition: TComposition; BlitRectsApres: TRectList;
                               MesurePlayed: integer;
                               TempsPlayed: TRationnel;
                               excitation: integer);

const epaisseur_clip = 150;

var x: integer;
    iLignePlayed: integer;

Begin
        Composition.SetOriginMesure(MesurePlayed);

        if Composition.Is_Mesure_Indice_MesureAAjouter(MesurePlayed) then
            x := 0
        else
            x := Composition.GetMesure(MesurePlayed).XATempsOuEntre(TempsPlayed);
        C.Pen.Width := BarreLecture_Epaisseur; //+ excitation;
        C.Pen.Color := BarreLecture_Couleur;
        //C.TextOut(0,0,'Temps : ' + QToStr(TempsPlayed));
        iLignePlayed := Composition.LigneAvecMes(MesurePlayed);
        DrawBarToutlelongAvecExcitation(x, Composition, iLignePlayed, excitation*10);
        BlitRectsApres.AjouterNextBlitRect(ScrRect(Rect(pixxorigin + x - epaisseur_clip,
                                     pixyorigin - epaisseur_clip,
                                     pixxorigin + x + epaisseur_clip,
                                     pixyorigin + Composition.minHauteurLigne(iLignePlayed)  + epaisseur_clip)));
End;




procedure DrawNotesSelectionnees(C: TCanvas;
                                 Composition: TComposition;
                                 optlignehaut, optlignebas: integer);


      procedure Mesure_Tablatures_Afficher_Selection(mes: integer);
      var p, v, i, i_n, yy, dx1, dy1, dx2, dy2: integer;
      Begin
          C.Brush.Style := bsClear;
          //C.Brush.Color := CouleurFondEcran;
          SetFontSize(8);
          
          With Composition do
          for p := 0 to NbPortees - 1 do
               if Portee_IsTablature(p) then
               With GetMesure(mes) do
               for v := 0 to high(Voix) do with Voix[v] do if IsAffichee then
                    if Get_N_Voix_Portee = p - 1 then
                    Begin
                        C.Pen.Width := 1;
                        for i := 0 to high(ElMusicaux) do
                        with ElMusicaux[i] do
                          if (not IsSilence) then
                              for i_n := 0 to NbNotes - 1 do
                              if IsNoteSelectionneePasForcementValide(i_n) then
                              With GetNote(i_n) do
                              if position.portee = p - 1 then
                              // test supplémentaire pour éviter les bugs
                              Begin
                                  yy := GetY(tablature_position);

                                  dy1 := AuZoomPortee(45, p);
                                  dy2 := AuZoomPortee(45, p);

                                  dx1 := AuZoomPortee(40, p);
                                  dx2 := AuZoomPortee(80, p);

                                  Rectangle(pixx-dx1, yy-dy1, pixx+dx2, yy+dy2);
                              End;

                        C.Pen.Width := 2;
                    End;
      End;
                      
var l, m, v, i: integer;

Begin
     C.Pen.Color := 255;
     C.Pen.Style := psSolid;

     
     SetGrosseurTrait(30);
     C.Brush.Style := bsClear;
     CouleurDessin := 255;

     with Composition do
         For l := optlignehaut to optlignebas do //on parcourt les lignes à l'écran
         Begin
          IGiLigne := l;
          For m := max(LignesMDeb(l), Selection_Getimesdebutselection)
                to min(LignesMFin(l), Selection_Getimesfinselection) do with GetMesure(m) do
                {en fait, on parcourt toutes les mesures de la ligne l, qui sont
                 également dans l'intervalle
                 [imesdebutselection, imesfinselection]}
               Begin
                  SetOriginMesure(m);
                  For v := 0 to high(Voix) do
                       //if IsVoixAccessibleEdition(Voix[v].N_Voix) then
                           //rem : car pas de sélection dans une voix non éditable
                       For i := 0 to high(Voix[v].ElMusicaux) do
                       With Voix[v] do
                             if not (ElMusicaux[i].IsSilence and (N_Voix < 0)) then
                              DrawElMusical(Composition, l,
                                            ElMusicaux[i],
                                            false,
                                            true);
                                    //trace la sélection (cf. dernier argument sur true)

                       Mesure_Tablatures_Afficher_Selection(m);
               End;
          End;




     CouleurDessin := 0;

     C.Pen.Width := 1;

End;



procedure DrawRectangleSelection(C: TCanvas;
                       BlitRectsApres: TRectList;
                       ClientRect,
                       SelectionRect: TRect);
Begin
         with BlitRectsApres do
         Begin
              C.Brush.Style := bsClear;
              C.Pen.Color := SelectionRectangle_Couleur;
              C.Pen.Style := SelectionRectangle_Style;
              C.Pen.Width := SelectionRectangle_Epaisseur;
              //AjouterNextBlitRect(ScrRect(SelectionRect));
              {on a viré cette ligne à cause des tablatures...
              il peut y avoir des notes sélectionnées très loin du rectangle de sélection...}

              AjouterNextBlitRect(ClientRect);

              SetPixOrigin(0, 0);
              Rectangle(SelectionRect);

              {MettreleftEtTopBonOrdreInRect(NextBlitRects[0]);

              dec(NextBlitRects[0].Left, 16);
              dec(NextBlitRects[0].Top, 16);
              inc(NextBlitRects[0].Right, 16);
              inc(NextBlitRects[0].Bottom, 16);   }



         End;
End;



procedure DrawNotesDeplacements(BlitRectsApres: TRectList;
                                const Composition: TComposition;
                                const optlignehaut, optlignebas: integer;
                                const IntervalleDeplacement: TIntervalle;
                                const DiffPorteeDeplacement: integer;
                                const LigneCourante: integer;
                                const Deplacement_Tablature_Corde_Deplacement: integer;
                                var BlitterToutDuBackBuffer: Boolean);
var l, m, v, i, j: integer;
    x: integer;
    n, newnotes: TElMusical;
    yaadessine: boolean;
    infoclef: TInfoClef;
    hn, hnnew: THauteurNote;
    nouveauiportee: integer;
    newNote: TNote;

    
Begin
     //notes en filigranes (les notes fantômes) "rouges" de déplacement
     with Composition do
     Begin
          For l := optlignehaut to optlignebas do //on parcourt les lignes à l'écran
          For m := max(LignesMDeb(l), Selection_Getimesdebutselection)
               to min(LignesMFin(l), Selection_Getimesfinselection) do with GetMesure(m) do
                 {en fait, on parcourt toutes les mesures de la ligne l, qui sont
                 également dans l'intervalle
                 [imesdebutselection, imesfinselection]}

                 {Intuitivement, on parcourt les indices de
                 [imesdebutselection, imesfinselection] dont les mesures sont à
                 l'écran}

                For v := 0 to high(Voix) do
                Begin
                       SetOriginMesure(m);
                       For i := 0 to high(Voix[v].ElMusicaux) do
                                 if not Voix[v].ElMusicaux[i].IsSilence then
                                 Begin
                                      n := Voix[v].ElMusicaux[i];
                                      newnotes := TElMusical.Create;
                                      {Sémantiquement, les notes ne durent pas 4 temps
                                       mais leur affichage doit ressembler à des rondes}
                                      newnotes.Duree_Fixee_Set(Qel(4));
                                      yaadessine := false;
                                      for j := 0 to n.NbNotes-1 do
                                      Begin
                                             if n.IsNoteSelectionnee(j) then
                                                   Begin
                                                       newNote := n.GetNote(j);

                                                       infoclef := Composition.InfoClef_DetecterAvecrelX(
                                                                        n.GetNote(j).position.portee,
                                                                         m,
                                                                         x);


                                                       hn := HauteurNoteGraphiqueToAbs(infoclef, n.GetNote(j));
                                                       GetHauteurNote(IntervalleDeplacement, hn, hnnew);
                                                       nouveauiportee := n.GetNote(j).position.portee + DiffPorteeDeplacement;
                                                       NumPorteeValide(nouveauiportee);
                                                       
                                                       infoclef := Composition.InfoClef_DetecterAvecrelX(nouveauiportee, m, x);
                                                       newNote.position.hauteur := HauteurAbsToHauteurGraphique(infoclef, hnnew.hauteur);

                                                       newNote.hauteurnote := hnnew;
                                                       newNote.AfficherAlteration := (newNote.hauteurnote.alteration <> aNormal);
                                                       newNote.position.portee := nouveauiportee;
                                                       newNote.BouleADroite := 0;

                                                       inc(newNote.tablature_position.hauteur,
                                                           Deplacement_Tablature_Corde_Deplacement);



                                                       newnotes.AddNote(newNote);
                                                       newnotes.pixx := n.pixx;
                                                       yaadessine := true;

                                                       if Composition.Portee_IsTablature_Et_PasDehors(newNote.tablature_position.portee) then
                                                       Begin
                                                           Composition.Position_Arrondir(newNote.tablature_position);

                                                           Draw_Tablature_PetitRectangle(C,
                                                                  Composition,
                                                                  BlitRectsApres,
                                                                  0,
                                                                  pixxorigin{},
                                                                  l,
                                                                  m,
                                                                  newNote.tablature_position,
                                                                  n.pixx,
                                                                  1000);



                                                       End;

                                                   End;
                                       End;
                                       {DrawNotesDeplacements}
                                       if yaadessine then
                                       Begin
                                           DrawElMusical(Composition, l, newnotes, false, false);
                                           //AjouterNextBlitRect(ScrRectAO(newnotes.pixRect));
                                       End;
                                       newnotes.Free;



                                 End;

                End;

           {DrawNotesDeplacements}     
           if DeplacerAutrePart and (DeplaceVersMesure <> -1) then
           Begin
               BlitterToutDuBackBuffer := false;
               SetOriginMesure(DeplaceVersMesure);
               if DeplaceVersMesure = Composition.NbMesures then
               Begin
                   LineVertical(10,10,minHauteurLigne(LigneCourante)-10);
                   BlitRectsApres.AjouterNextBlitRect(
                      ScrRectAO(Rect(9,10,11,minHauteurLigne(LigneCourante)-10)));
               End
               else
               Begin
                   x := GetMesure(DeplaceVersMesure).XATemps(DeplaceAuTemps)-10;
                   LineVertical(x,10,minHauteurLigne(LigneCourante)-10);
                   BlitRectsApres.AjouterNextBlitRect(ScrRectAO(Rect(x - 10,10,x + 10,minHauteurLigne(LigneCourante)-10)));
               End;

           End
           else
                BlitterToutDuBackBuffer := true;

     End;


end;






procedure DrawPausesDeplacements(Composition: TComposition;
                                optlignehaut, optlignebas: integer;
                                HauteurDeplace: integer);

var l, m, v, i: integer;
    Rct: TRect;

Begin
            C.Brush.Style := bsClear;

            {on affiche les cadres des pauses qui sont sélectionnées
             et en déplacement
             --> "pauses fantômes" (cadres rouges)}
            with Composition do
            Begin
                For l := optlignehaut to optlignebas do //on parcourt les lignes à l'écran
                Begin
                     IGiLigne := l;
                     For m := max(LignesMDeb(l), Selection_Getimesdebutselection)
                              to min(LignesMFin(l), Selection_Getimesfinselection) do
                     with GetMesure(m) do
                        For v := 0 to high(Voix) do
                        Begin
                               SetOriginMesure(m);
                               For i := 0 to high(Voix[v].ElMusicaux) do
                                         if Voix[v].ElMusicaux[i].IsSilence and
                                         (Voix[v].ElMusicaux[i].IsSelectionne) then
                                         Begin
                                                Rct := Voix[v].ElMusicaux[i].pixRect;
                                                dec(Rct.Top, HauteurDeplace * nbpixlign);
                                                dec(Rct.Bottom, HauteurDeplace * nbpixlign);

                                                Rectangle(Rct);
                                         End;
                        End;
               End;

            End;

End;




procedure DrawFondSelectionMesures(C:TCanvas;
                         Composition: TComposition;
                         DebMes: integer; FinMes: integer);
var m, l: integer;

Begin

     Composition.VerifierIndiceMesure(DebMes, 'DebMes dans DrawFondSelectionMesures');
     Composition.VerifierIndiceMesure(FinMes, 'FinMes dans DrawFondSelectionMesures');



     CDevice := devEcranPasEdition;
     C.Brush.Color := CouleurFondSelectionMesure;

     pixxorigin := 0;
     pixyorigin := 0;


     with composition do
         for m := DebMes to FinMes do
         With GetMesure(m) do
         Begin
               l := LigneAvecMes(m);

               FillRect(pixx,            Ligne_YHaut(l),
                        pixx + pixWidth, Ligne_YBas(l));
         End;

End;




procedure DrawFondVoixNonPresente(C: TCanvas;
                             Composition: TComposition;
                             BlitRectsAvant: TRectList;
                             VoixSelectionnee: integer;
                             possscur: TPosition;
                             MesureCourante: integer);

const LargeurNvVoix_FinDuDocument = 500;

var i: integer;
    Rct: TRect;

Begin

         C.Pen.Color := LiseraieVoix_Couleur;
         C.Pen.Style := psClear;//LiseraieVoix_ps;

         C.Brush.Color := CouleursVoixFond(Composition, VoixSelectionnee);
         C.Brush.Style := bsSolid;
         if MesureCourante = Composition.NbMesures then
             Begin
                 C.Brush.Color := CouleursVoixFond(Composition, VoixSelectionnee);
                  C.Brush.Style := bsSolid;
                  Composition.SetOriginMesure(Composition.NbMesures - 1);
                  i := Composition.GetMesure(Composition.NbMesures - 1).pixWidth;

                  Rct := Rect(i, GetY(possscur.portee, possscur.hauteur -3),
                            i + LargeurNvVoix_FinDuDocument, GetY(possscur.portee, possscur.hauteur + 3));
                  FillRect(Rct);

                  BlitRectsAvant.AjouterNextBlitRect(ScrRectAO(Rct));
             End
         else
         Begin


             Composition.SetOriginMesure(MesureCourante);

             Rct := Rect(10,
                         GetY(possscur.portee ,possscur.hauteur -3),
                         Composition.GetMesure(MesureCourante).pixwidth - 10,
                         GetY(possscur.portee ,possscur.hauteur+ 3));
             FillRect(Rct);

             BlitRectsAvant.AjouterNextBlitRect(ScrRectAO(Rct));

         End;


End;




procedure DrawCadreAutourMesureCourante(C: TCanvas;
                                        Composition: TComposition;
                                        AncienneMesureCourante: integer;
                                        AncienneLigneCourante: integer;
                                        MesureCourante: integer;
                                        LigneCourante: integer);
Begin
     Composition.RendreIndiceMesureValide(AncienneMesureCourante);
     Composition.VerifierIndiceMesureOuDerniereOuNOP(MesureCourante, 'MesureCourante DrawCadreAutourMesureCourante');

     Composition.VerifierIndiceLigneOrNOP(LigneCourante, 'LigneCourante dans DrawCadreAutourMesureCourante');


     
     if AfficherCadreAutourMesureCourante then
     Begin
           //on gère le contour autour de la mesure courante


           {on s'occupe d'effacer l'ancien cadre}
           if (AncienneMesureCourante <> MesureCourante) and
              Composition.IsIndiceMesureValide(AncienneMesureCourante)
              and Composition.IsIndiceLigneValide(LigneCourante) then
            Begin
                Composition.SetOriginMesure(AncienneMesureCourante);
                C.Pen.Color := clWhite;
                Rectangle(0,0,Composition.GetMesure(AncienneMesureCourante).pixWidth,
                    Composition.minhauteurligne(AncienneLigneCourante));

                C.Pen.Color := clBlack;
                C.Pen.Style := psSolid;
                if AncienneMesureCourante > 0 then
                     DrawBar(0, Composition, LigneCourante);  //pas sûr
                DrawBar(Composition.GetMesure(AncienneMesureCourante).pixWidth, Composition, LigneCourante);
            end;


           C.Pen.Style := psDash;
           if Composition.IsIndiceMesureValide(MesureCourante) then
           Begin
               Composition.SetOriginMesure(MesureCourante);
               C.Pen.Color := CouleurCadreAutourMesureSousCurseur;
               Rectangle(0,0,Composition.GetMesure(MesureCourante).pixWidth,
                  Composition.minhauteurligne(LigneCourante));
          end;
     End;
End;


procedure DrawLiseraiSelectionVoix(C: TCanvas;
                                   Composition: TComposition;
                                   optlignehaut: integer;
                                   optlignebas: integer;
                                   x1: integer;
                                   x2: integer;
                                   VoixSelectionnee: integer);
var l, i, v: integer;
Begin
         Composition.VerifierIndiceLigne(optlignehaut, 'DrawLiseraiSelectionVoix');
         Composition.VerifierIndiceLigne(optlignebas, 'DrawLiseraiSelectionVoix');
         exit;
         C.Pen.Color := LiseraieVoix_Couleur;
         C.Pen.Style := LiseraieVoix_ps;

         for l := optlignehaut to optlignebas do
         Begin
               IGiLigne := l;

               With Composition do
               for i := GetMesureSurLigne(l,x1) to GetMesureSurLigne(l,x2) do
                 with GetMesure(i) do
                       Begin
                              SetOriginMesure(i);
                              for v := 0 to high(Voix) do
                                    if Voix[v].N_Voix = VoixSelectionnee then
                                            Voix[v].DrawFond(true,
                                                             pixWidth);
                       end;
         End;

End;




procedure DrawBarreDeMesureSousCurseur(C: TCanvas;
                                       Composition: TComposition;
                                       BlitRectsApres: TRectList;
                                       imesure: integer);
var iligne, x: integer;
Begin


     iligne := Composition.LigneAvecMes(imesure - 1);

     Composition.VerifierIndiceLigne(iligne, 'DrawBarreDeMesureSousCurseur');
     Composition.VerifierBarreDeMesureIndice(imesure, 'DrawBarreDeMesureSousCurseur');


     C.Pen.Color := Qch_Sous_Curseur_Selection_Trait_Couleur;
     C.Pen.Width := Qch_Sous_Curseur_Selection_Trait_Epaisseur;

     SetPixOrigin(0, Composition.Ligne_YHaut(iligne));

     x := Composition.BarreDeMesure_Droite_X(imesure-1);
     DrawBar(x,
             Composition,
             iligne);


      BlitRectsApres.AjouterNextBlitRect(ScrRectPlus1(Rect(x,
                                              Composition.Ligne_YHaut(iligne),
                                              x + 50,
                                              Composition.Ligne_YBas(iligne)
                                              ))
                                        );

End;



procedure Draw_CurseurClavier(C: TCanvas;
                              Composition: TComposition;
                              BlitRectsApres: TRectList;
                              Curseur: TCurseur);

const PenWidth_CouleursVoix = 6;
      PenWidth_CouleursVoix_Dessus = 3;

      PenWidth_Noir = 8;
      PenWidth_Noir_Dessus = 5;

var x, y1, y2, y11, y22: integer;
Begin
    C.Pen.Style := psSolid;
    C.Pen.Color := CouleursVoixFond(Composition, Curseur.GetiVoixSelectionnee);

    if Curseur.Is_ElementMusical_Dessus then
         C.Pen.Width := PenWidth_CouleursVoix_Dessus
    Else
         C.Pen.Width := PenWidth_CouleursVoix; 


    IGP := Composition;
    IGiLigne := Curseur.GetiLigne;

    pixxorigin := 0;
    pixyorigin := Composition.Ligne_YHaut(IGiLigne);
    
    x := Curseur.GetPixx_in_doc;

    With Curseur.GetPosition do
    Begin
         y1 := GetY(portee, hauteur - 3);
         y2 := GetY(portee, hauteur + 3);

         y11 := GetY(portee, hauteur)- 10;
         y22 := GetY(portee, hauteur) + 10;

         LineVertical(x, y1, y2);



         if Curseur.Is_ElementMusical_Dessus then
         Begin
             C.Pen.Color := $008800;
             C.Pen.Width := PenWidth_Noir_Dessus;
         End
         else
         Begin
             C.Pen.Color := CouleursVoixNote(Composition, Curseur.GetiVoixSelectionnee);
             C.Pen.Width := PenWidth_Noir;
         End;    
         LineVertical(x, y11, y22);

    End;

    inc(x, pixXorigin);
    inc(y1, pixYorigin);
    inc(y2, pixYorigin);

    BlitRectsApres.AjouterNextBlitRect(ScrRectPlus1(Rect(x,
                                              y1,
                                              x,
                                              y2
                                              ))
                                        );


End;


procedure DrawCoutourQchAvecEllipseX1Y1X2Y2(BlitRectsApres: TRectList;
                                            x1, y1, x2, y2: integer);
Begin
    C.Pen.Color := Qch_Sous_Curseur_Selection_Trait_Couleur;
    C.Pen.Width := Qch_Sous_Curseur_Selection_Trait_Epaisseur;
    C.Brush.Style := bsClear;

    Ellipse(x1, y1, x2, y2);

    inc(x1, pixXorigin);
    inc(x2, pixXorigin);

    inc(y1, pixYorigin);
    inc(y2, pixYorigin);

    //BlitRectsApres.AjouterNextBlitRect(ScrRectPlus1(Rect(x1, y1, x2, y2)));
    BlitRectsApres.AjouterNextBlitRect(Rect(-1, -1, 1000, 1000));
End;

procedure DrawCoutourQchAvecEllipse(C: TCanvas;
                Composition: TComposition;
                BlitRectsApres: TRectList;
                iligne, imesure, iportee, x1, h1, x2, h2: integer);
var y1, y2: integer;

Begin
    Composition.VerifierIndiceLigne(iligne, 'DrawContourClef');
    Composition.VerifierIndiceMesure(imesure, 'DrawContourClef');
    Composition.VerifierIndicePortee(iportee, 'DrawContourClef');

    Composition.SetOriginMesure(imesure);

    y1 := GetY(Composition, iLigne, iportee, h1);
    y2 := GetY(Composition, iLigne, iportee, h2);
    
    DrawCoutourQchAvecEllipseX1Y1X2Y2(BlitRectsApres, x1, y1, x2, y2);

    
End;



procedure DrawContourRythme(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    iligne,
                    imesure,
                    iportee: integer);
Begin
    DrawCoutourQchAvecEllipse(C, Composition, BlitRectsApres,
                              iligne, imesure, iportee,
                              -Rythme_Ellipse_Marge + Composition.GetMesure(imesure).pixXApresTonaliteDebut,
                              -cteHauteurRythme,
                              +Rythme_Ellipse_Marge + Composition.GetMesure(imesure).pixXApresTonaliteDebutEtRythme,
                              cteHauteurRythme);

End;



procedure DrawContourObjetGraphique(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    GraphicObjet_SousCurseur_Get: TGraphicObjet);
const GraphicObjet_Points_Cercle_Couleur = $0077EE;
const GraphicObjet_Points_Cercle_Epaisseur = 2;

var r: TRect;
Begin
   SetPixOrigin(0, 0);

   with GraphicObjet_SousCurseur_Get do
   Begin
        C.Pen.Color := GraphicObjet_Points_Cercle_Couleur;
        C.Pen.Style := psSolid;
        C.Pen.Width := GraphicObjet_Points_Cercle_Epaisseur;
        Points_DrawCercles;
        case typ of
              tgZoneTexte:
              Begin
                  r := GraphicObjet_SousCurseur_Get.GetRectangle;

                  inc(r.Left, -80);
                  inc(r.Right, -80);
                  inc(r.Bottom, 50);
   
                  DrawCoutourQchAvecEllipseX1Y1X2Y2(BlitRectsApres, r.Left, r.Top, r.Right, r.Bottom);
              End;
              
              tgCourbe:
              Begin
                   C.Pen.Color := Qch_Sous_Curseur_Selection_Trait_Couleur;
                   C.Pen.Width := 1;
                   Draw;

                   BlitRectsApres.AjouterNextBlitRect(Rect(-1, -1, 1000, 1000));
              End;

              else
              Begin
                   r := GraphicObjet_SousCurseur_Get.GetRectangle;
                   C.Pen.Color := Qch_Sous_Curseur_Selection_Trait_Couleur;
                   Draw;

                   BlitRectsApres.AjouterNextBlitRect(Rect(-1, -1, 1000, 1000));
                   //BlitRectsApres.AjouterNextBlitRect(r);
              End;

        End;
   End;


End;



procedure DrawContourTonalite(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    iligne,
                    imesure,
                    iportee: integer);
Begin
    DrawCoutourQchAvecEllipse(C, Composition, BlitRectsApres,
                              iligne, imesure, iportee,
                              -Tonalite_Ellipse_Marge_Gauche + 0,
                              -cteHauteurTonalite,
                              +Tonalite_Ellipse_Marge_Droite + Composition.GetMesure(imesure).pixXApresTonaliteDebut,
                              cteHauteurTonalite);

End;



procedure DrawContourTonaliteAvantBarreDeMesureSousCurseur(C: TCanvas;
                    Composition: TComposition;
                    BlitRectsApres: TRectList;
                    iligne,
                    imesure,
                    iportee: integer);
Begin
    DrawCoutourQchAvecEllipse(C, Composition, BlitRectsApres,
                              iligne, imesure, iportee,
                              -Tonalite_AvantBarreDeMesure_Ellipse_Marge_Gauche
                                  + Composition.GetMesure(imesure).pixWidthWithoutTonalitesFin,
                              -cteHauteurTonalite,
                              +Tonalite_AvantBarreDeMesure_Ellipse_Marge_Droite
                                  + Composition.GetMesure(imesure).pixWidth,
                              cteHauteurTonalite);

End;








procedure DrawContourClef(C: TCanvas;
                Composition: TComposition;
                BlitRectsApres: TRectList;
                iligne, imesure, x, iportee: integer);
Begin
    DrawCoutourQchAvecEllipse(C, Composition, BlitRectsApres,
                              iligne, imesure, iportee,
                              x - 20, -11,
                              x + 220, 11);


End;



procedure DrawPortees_Instrument_Nom_Zone_SousCurseur(C: TCanvas;
                                                       Composition: TComposition;
                                                       BlitRectsApres: TRectList;
                                                       Portees_Instruments_Noms_Zone_iLigne,
                                                       Portees_Instruments_Noms_Zone_iPortee
                                                       : integer);
                                                       
var y1, p: integer;

Begin
      if Portees_Is_Portees_Noms_Affiches(Portees_Instruments_Noms_Zone_iLigne) then
      Begin

            SetPixOrigin(0, 0);

            Instruments_Noms_SetFontSize(Portees_Instruments_Noms_Zone_iLigne);
            
            p := Composition.Portee_Groupe_PremierePortee(Portees_Instruments_Noms_Zone_iPortee);
            y1 := Composition.Ligne_YHaut(Portees_Instruments_Noms_Zone_iLigne) +
                  Composition.Portee_Groupe_Instrument_NomAAfficher_Y(Portees_Instruments_Noms_Zone_iLigne,
                                                             p);

            C.Font.Color := Qch_Sous_Curseur_Selection_Trait_Couleur;
            TextOut(0, y1, Composition.Portee_Groupe_Instrument_NomAAfficher(p) );

      End;

      
End;





procedure DrawContourOctavieur(C: TCanvas;
                               Composition: TComposition;
                               BlitRectsApres: TRectList;
                               LigneCourante,
                               iportee,
                               indice: integer);

var x1, x2, y2, y1: integer;
Begin
    Composition.VerifierIndiceLigne(LigneCourante, 'DrawContourOctavieur');
    Composition.VerifierIndicePortee(iportee, 'DrawContourOctavieur');

    C.Pen.Color := Qch_Sous_Curseur_Selection_Trait_Couleur;
    C.Pen.Width := Qch_Sous_Curseur_Selection_Trait_Epaisseur;
    C.Brush.Style := bsClear;

    With Composition.Portee_Octavieurs_Liste(iportee) do
    With private_liste[indice] do
    Begin
        SetPixOrigin(Composition.GetMesure(imesure).pixX, 0);
        x1 := pixx - 100;

        if combien = 0 then
              y1 := Composition.Octavieurs_GetY(LigneCourante, iportee, private_liste[indice-1].combien)
        else
              y1 := Composition.Octavieurs_GetY(LigneCourante, iportee, combien);

        y1 := y1 - 50;
    End;
 

    x2 := x1 + 220;
    y2 := y1 + 240;
    
    Ellipse(x1, y1, x2, y2);

    inc(x1, pixXorigin);
    inc(x2, pixXorigin);

    inc(y1, pixYorigin);
    inc(y2, pixYorigin);
    
    BlitRectsApres.AjouterNextBlitRect(ScrRectPlus1(Rect(x1, y1, x2, y2)));
End;




procedure Draw_Tablature_Curseur(C: TCanvas;
                      Composition: TComposition;
                      BlitRectsApres: TRectList;
                      VoixSelectionnee: integer;
                      a_pixxorigin : integer;
                      iligne: integer;
                      MesureCourante: integer;
                      possscur: TPosition;
                      Xdansmesure: integer;
                      ClientHeight: integer);
Begin
     MusicGraph_System_Trait_SansFond_Couleur(CouleursVoixNote(Composition, VoixSelectionnee));
     Draw_Tablature_PetitRectangle(C,
                                  Composition,
                                  BlitRectsApres,
                                  VoixSelectionnee,
                                  a_pixxorigin{},
                                  iligne,
                                  MesureCourante,
                                  possscur,
                                  Xdansmesure,
                                  ClientHeight);
                                  
End;


procedure Draw_Tablature_PetitRectangle(C: TCanvas;
                      Composition: TComposition;
                      BlitRectsApres: TRectList;
                      VoixSelectionnee: integer;
                      a_pixxorigin : integer;
                      iligne: integer;
                      MesureCourante: integer;
                      possscur: TPosition;
                      Xdansmesure: integer;
                      ClientHeight: integer);


const tablature_curseur_taille_x2 = 50;
var rct: TRect;

Begin
      Composition.VerifierIndiceLigne(iligne, 'DrawCurseur');
      Composition.VerifierIndiceMesureOuDerniere(MesureCourante, 'DrawCurseur');
      Composition.VerifierPosition(possscur, 'DrawCurseur');

      C.Pen.Width := 1;
      C.Brush.Style := bsClear;

      


      pixxorigin := a_pixxorigin;
      pixyorigin := Composition.Lignes[iligne].pixy;

      rct := Rect(Xdansmesure-tablature_curseur_taille_x2,   GetY(possscur.portee, possscur.hauteur - 1),
                  Xdansmesure+tablature_curseur_taille_x2, GetY(possscur.portee, possscur.hauteur + 1));
                  
      Rectangle(rct);

      BlitRectsApres.AjouterNextBlitRect(ScrRectAO(rct));
      
End;



procedure DrawCurseur_Modele(C: TCanvas;
                      Composition: TComposition;
                      BlitRectsApres: TRectList;
                      VoixSelectionnee: integer;
                      Curseur_IsExcite: Boolean;
                      a_pixxorigin : integer;
                      iligne: integer;
                      MesureCourante: integer;
                      possscur: TPosition;
                      Xdansmesure: integer;
                      ModelesVoix: TVoix;
                      IntervalleDeplacement: TIntervalle;
                      ClientHeight: integer;
                      SourisCurseur_Clignotement_Etat: TSourisCurseur_Clignotement_Etat);

const Curseur_Souris_Texte_Libelle_Note_FontSize = 8;

Function CouleurAuPif_Get: TColor;
Begin
      result := (64 + Random(192)) * 256 * 256 +
                (64 + Random(192)) * 256 +
                (64 + Random(192));
End;


var infoclef: TInfoClef;
    i, j :integer;
    n, newnotes: TElMusical;
    hn, hnnew: THauteurNote;
    newNote: TNote;
    Rct: TRect;

                      
Begin
      Composition.VerifierIndiceLigne(iligne, 'DrawCurseur');
      Composition.VerifierIndiceMesureOuDerniere(MesureCourante, 'DrawCurseur');
      Composition.VerifierPosition(possscur, 'DrawCurseur');
      VerifierHauteurNote(IntervalleDeplacement, 'DrawCurseur');

      C.Pen.Width := 1;

      if Curseur_IsExcite then
             DessinerCouleur(CouleurAuPif_Get)
      else
      if SourisCurseur_Clignotement_Etat = scceCouleurVoixNote then
                   DessinerCouleur(CouleursVoixNote(Composition, VoixSelectionnee))
      else
           DessinerFiligrane;


      pixxorigin := a_pixxorigin;
      pixyorigin := Composition.Lignes[iligne].pixy;


      infoclef := Composition.InfoClef_DetecterAvecRelX(
                            possscur.portee, MesureCourante,Xdansmesure);


            IGiLigne := iligne; //avant c t LigneCourante

            For i := 0 to high(ModelesVoix.ElMusicaux) do
            Begin
             n := ModelesVoix.ElMusicaux[i];
             newnotes := CopieElMusicalSaufNote(n);
             newnotes.pixx := n.pixx - ModelesVoix.ElMusicaux[0].pixx;;
             if ModelesVoix.ElMusicaux[i].IsSilence then
              //affichage d'une pause
                     newnotes.position := possscur
             else

              {affichage de notes pour le curseur souris (le plus lourd)}
               Begin
                  for j := 0 to n.NbNotes - 1 do
                  Begin
                       hn.hauteur := HauteurGraphiqueToHauteurAbs(
                                              ClefToInfoClef(clefSol),
                                              n.GetNote(j).position.hauteur);
                       hn.alteration := n.GetNote(j).hauteurnote.alteration;
                       GetHauteurNote(IntervalleDeplacement, hn, hnnew);
                       newNote.Selectionne := svDeselectionnee;
                       newNote.position.hauteur := HauteurAbsToHauteurGraphique(
                                                      infoclef, hnnew.hauteur);
                       newNote.HauteurNote := hnnew;
                       newNote.AfficherAlteration := (newNote.hauteurnote.alteration <> aNormal);
                       newNote.position.portee := possscur.portee;
                       newNote.BouleADroite := 0;
                       newnotes.AddNoteSub(newNote);

                  end;
               end;
                  newnotes.CalcGDBoules;
                  newnotes.CalcStandardQueueHaut;
                  DrawElMusical(Composition, iligne, newnotes, true, false);
                  newnotes.Free;

            End;

            SetFontSize(Curseur_Souris_Texte_Libelle_Note_FontSize);
            ChangerBrushStyle(bsClear);
            TextOut(0,0,HauteurAbsToStr(IntervalleDeplacement.Hauteur));

            Rct := ScrRect(Rect(pixxorigin-MargeGaucheBlitRectCurseur,
                                    pixyorigin-MargeHautBlitRectCurseur,
            pixxorigin + ModelesVoix.
                     ElMusicaux[high(ModelesVoix.ElMusicaux)].pixx
                                      + MargeDroiteBlitRectCurseur,
            pixyorigin + Composition.minhauteurligne(iLigne) + MargeBasBlitRectCurseur ));

            Rct.Bottom := ClientHeight;
            BlitRectsApres.AjouterNextBlitRect(Rct);
End;






procedure DrawPauseAInserer(C: TCanvas;
                            Composition: TComposition;
                            BlitRectsApres: TRectList;
                            LigneCourante,
                            MesureCourante,
                            VoixSelectionnee: integer;
                            possscur: TPosition);
var t: TRationnel;
    i, x: integer;
    mesure: TMesure;

Begin
        Composition.VerifierIndiceLigne(LigneCourante, 'DrawPauseAInserer');
        Composition.VerifierIndiceMesure(MesureCourante, 'DrawPauseAInserer');
        Composition.VerifierPosition(possscur, 'DrawPauseAInserer');


        mesure := Composition.GetMesure(MesureCourante); 
                        Composition.SetOriginMesure(MesureCourante);
                        t := QAdd(mesure.VoixNum(VoixSelectionnee).DureeTotale, Qel(1));

                        //PausesAvantCurseur est global (c moche)
                        for i := 0 to high(PausesAvantCurseur) do
                        Begin
                              x := mesure.XATemps(t);
                              DrawIndependantPause(Composition,
                                                   LigneCourante,
                                                   PausesAvantCurseur[i],
                                                   x,
                                                   possscur.portee);
                                                   
                              BlitRectsApres.AjouterNextBlitRect(ScrRect(Rect(pixxorigin + x - 30,
                                                               pixyorigin + GetY(Composition, LigneCourante, possscur) - 30,
                                                               pixxorigin +  x + 30,
                                                               pixyorigin + GetY(Composition, LigneCourante, possscur) + 30)));
                              QInc(t, PausesAvantCurseur[i]);

                        End;

                        
End;



end.
