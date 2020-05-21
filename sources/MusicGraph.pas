unit MusicGraph;

interface

uses MusicGraph_System,
     MusicGraph_Portees {pour nbpixlign...},
     MusicGraph_GestionImage,
     MusicGraph_CercleNote,

     MusicSystem_Composition,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_Constantes {naBouleADroite},
     MusicSystem_ElMusical,
     MusicSystem_Types,
     MusicSystem_CompositionListeObjetsGraphiques,
     MusicSystem_CompositionBase {pour les accolades},
     MusicSystem_CompositionAvecPagination {pour les MusicWriterCalcule},

     MusicHarmonie {pour le type TClef, dans les décl. de tableaux...},
     Graphics {pour psDot...},
     Types {pour TPoint},
     SysUtils {pour inttostr},
     QSystem {pour TRationnel},
     MusicGraph_Images;


const

      DECAL_imgSeperationOrchestre_X = 1000;
      DECAL_imgSeperationOrchestre_Y = - 500;


      DximgAccolade1 = 200;
      DximgAccolade2 = 30;

      {case d'un modèle (barre sur la droite)}
      HauteurCaseModele = 1000;
      LargeurCaseModele = 2000;



      effetplume = 50;

      NbFrameAnim = 4;
      {nombre d'images dans une animation
       - de défilement
       - de mesures}


      YTitre = 200;
      HTitre = 600;
      FontSizeTitre = 24;


      rayonpointduree = 2*prec;

      

      longXPetitTrait = nbpixlign;
      nbpixdifftrait = 4*prec;
             {nb de pixels entre 2 traits épais qui lie les croches, doubles...}
      EpaisseurTraitCroche: array[0..1] of integer = (25, 15); //pour pen.Width en zoom = 100




      hauteurdefautqueue = 6 * nbpixlign;

      {pour imprimante}
      feuillemargegauche = 32*prec+32*prec;
      feuillemargehaut = 70*prec;

      
      largclef = 20*prec;
      ydecaltextealteration = 9*prec;
      largeurrythme = 10*prec;
      MargeEntreAlterationALaCleEtRythme = 16*prec;


      distpique = 7*prec;
      rayonpointpique = 2*prec;

      hauteurpage = 1040*prec;//26 * 96;

      //mode page
      largutilisable = 700*prec;

      margepourmesure = 20*prec;
           {espace pour mettre les clefs de début de portee}


      decalypause: array[0..nombreimgpause] of integer = (0, 3*prec, 16*prec, 12*prec,12*prec,12*prec);
      DecalageClefPortee: array[TClef] of integer = (38*prec {sol},
                                                     16*prec {fa},
                                                     18*prec {ut3},
                                                     38*prec {sol8});

      {nombre positif = décalage vers le haut}


//(aDbBemol, aBemol, aNormal, aDiese, aDbDiese, aIndefini)
      ecartalteration = 4*prec;
      DecalXAlteration: array[TAlteration] of integer = (180,
                                                         3*ecartalteration,
                                                         3*ecartalteration,
                                                         3*ecartalteration,
                                                         3*ecartalteration,
                                                         3*ecartalteration);

      DecalYAlteration: array[TAlteration] of integer = (20,23,20,10,55,20);
      DecalageClef = 38*prec;

      hauteurdesparoles = -8;
      {position exprimée en ligne de portées par rapport au centre de la portée}

      TextHeight = 16*prec; {hauteur du texte par défaut}

      {pour graphsub}
      margeinitiale = 16*prec;
      margefinale2 = 8*prec;
      ecartsuppl = 8*prec;
      DecalageParole = 6*prec;


      {pour les voix*******************************************************}
      largfondvoix2 = 3*prec; //demi-largeur au tracé (TVoix.DrawFond)
      largfondvoixtest2 = 8*prec; //demi-largeur au test (TVoix.PointInFondVoix)

      {quand le curseur clavier est entre 2 notes,
      il est à EcartCurseurClavier pixel logique en avant de la première}
      EcartCurseurClavier=8*prec;
      miniecartCurseurClavier = 0;

      EcartPlacageXATemps = 8*prec;

      margegauche = 32*prec;




      {dessin des queues des croches**************************************************}
      longqueue = 16*prec;
      larqueue = 8*prec;


      {ZigZag en cas d'erreurs}
      zig = 4*prec;
      zig2 = zig * 2;
      largzigzag = 2*prec;

      decalchiffrerythme = 20;







      HauteurLiasonALaSuivante = 50;

      {marge supplémentaire d'effacement du curseur à l'écran}
      MargeGaucheBlitRectCurseur = 200;
      MargeHautBlitRectCurseur = 1000;
      MargeDroiteBlitRectCurseur = 200;
      MargeBasBlitRectCurseur = 200;




      {mode ruban}
      PETITE_MARGE_DETECTION_CLEF_MODE_RUBAN = 100;
      COULEUR_FOND_NOMS_PORTEES_EN_MODE_RUBAN = $E8E8E8;
      DEMI_HAUTEUR_BANDE_PORTEE = 12;







      //variable d'optimisation
      UtiliserBackBuffer = true; {si à false, il faut :
                                             ReafficherToutToutleTemps = true,
                                             ToutDessinerDansBitmapScrDabord = true}
      ReafficherToutToutleTemps = false or not UtiliserBackBuffer;


      BlittageIntelligent = true;



      FontSizeZoneTexte = 12;




      factprintinfile = 2;






type TModeAffichage = (maPageTouteLesPortees, maPage, maRuban);

     TGraphInfoLigne = record
           nbPortees: integer;
           PorteeVisible: array of integer;

     end;

     TView = record
          pixxdeb, pixydeb: integer;
          Zoom: integer;
          ModeAffichage: TModeAffichage;
          VoixAffichee: array[0..MaxIndVoix] of Boolean;
          VoixEntendue: array[0..MaxIndVoix] of Boolean;

          PorteeAffichee: array[0..MaxIndVoix] of Boolean;
          PorteeEntendue: array[0..MaxIndVoix] of Boolean;
     end;


     procedure SetView(var View:TView);
     procedure SetViewNil;
     Function Portees_Is_Portees_Noms_Affiches(iligne: integer): Boolean;


     procedure Instruments_Noms_SetFontSize(iligne: integer);







var

     ViewCourant: ^TView;
     ModeAffichage: TModeAffichage;



     //variables sauvées dans le fichier INI
     ToutDessinerDansBitmapScrDabord: Boolean = false or not UtiliserBackBuffer;
       {qd ToutDessinerDansBitmapScrDabord est vrai,
           ça dessine vraiment tout d'abord dans Scr, puis ça blitte à l'écran
           cela supprime totalement les clignotements, mais ça bouffe de la mémoire}


    liseraijoliencourbe: Boolean = false;


    option_TracerFondVoix: Boolean = true;






    {animation de mesure}
    Animation_ElMusicaux_Indice: integer = 0;
    Animation_ElMusicaux_iMesure: integer; {pour quelle mesure ??}


    AfficherAvecUneAnimation: boolean;
    {vaut true si actuellement toutes les appels à DrawElMusical conduise au calcul d'animation}



    Procedure DrawCadrePresentationVoix(Comp: TComposition; Canvas: TCanvas;
                    Rect: TRect; n_voix: integer; style :integer;
                    is_afficher_oeil, is_afficher_oreille: Boolean);


    Function GetDeltaBandeNomsPorteesDuModeRuban(Comp: TComposition): integer;
    Procedure GetAbscisseBandeNomsPorteesDuModeRuban(Comp: TComposition;
                                                    var x1, x2: integer);
    procedure AfficherPartition(Comp: TComposition; l1, l2,x1,x2: integer);
    
    procedure AfficherPartitionToutesLesLignes(Comp: TComposition; l1, l2:integer);

    procedure DrawLinesPour1Portee(Comp: TComposition; iligne, x1, x2, portee: integer);
    procedure DrawLines(comp: TComposition; iligne, x1, x2: integer);

    procedure DrawLines_TOUTESLESPORTEES(comp: TComposition; x1, x2 : integer);
//Function GetY(pos:TOrdonnee):integer; overload;

Procedure TraitDeCroche(x1, y1, x2, y2: TCoord);




Function DeltaXTonalites(tonalites: TTonalites): integer; overload;
Function DeltaXTonalites(tonalites, anciennestonalites: TTonalites): integer; overload;

Procedure DrawQueueDeCroche(cx, cy: integer; QueueVersBas: Boolean;
                            zoom: integer);


Procedure DrawElMusicalQueuesIndependantes(Comp: TCompositionAvecPagination;
                        iligne: integer;
                        elm: TElMusical);

Procedure DrawElMusical(Comp: TCompositionAvecPagination;
                        iligne: integer;
                        elm: TElMusical;
                        DrawQueueCroche:Boolean;
                        onlyselected: Boolean);

Procedure ElMusical_Trainee_Draw(Comp: TCompositionAvecPagination;
                        iligne: integer;
                        elm: TElMusical);


Procedure DrawBar(x:integer; comp: TCompositionAvecPagination; iligne: integer);
Procedure DrawBarBar( x1, x2 :integer; comp: TCompositionAvecPagination; iligne: integer);

Procedure DrawBarToutlelong(x:integer; comp: TCompositionAvecPagination; iligne: integer);
Procedure DrawBarBarToutlelong( x1, x2 :integer; comp: TCompositionAvecPagination; iligne: integer);
procedure DrawBarToutlelongAvecExcitation(x:integer; comp: TCompositionAvecPagination; iligne: integer; excitation: integer);

procedure DrawIctus(x:integer; comp: TCompositionAvecPagination; iligne: integer);

Procedure DrawBarZigZag(x:integer; comp: TCompositionAvecPagination; iligne: integer);


Procedure DrawClefDebutPortee_TOUTESLESPORTEES(comp: TCompositionAvecPagination;
                              x, portee:integer; clef: TClef);

Procedure DrawClefDebutPortee(comp: TCompositionAvecPagination; iligne: integer;
                              x, portee:integer; clef: TClef);

Procedure DrawClef(comp: TCompositionAvecPagination; iligne: integer;
                   x, portee:integer; clef: TClef);



Procedure DrawArrete(Comp: TCompositionAvecPagination; iligne: integer; cx: integer; Pos: TPosition; taillearrete: integer);

Procedure DrawIndependantPause(comp: TComposition;
                               iligne: integer;
                               Duree: TRationnel;
                               x,
                               portee: integer);

Procedure DrawTonalite(comp: TCompositionAvecPagination;
                       iligne: integer;
                       xdeb,
                       portee: integer;
                       clef: TClef;
                       tonalite,
                       anciennetonalite: ShortInt);


procedure DrawAccolade(x, y1, y2, zp: integer;
                       typeAccolade: Byte);




procedure Portees_Actives_Set(p1, p2: integer);
procedure Portees_Actives_Toutes;
















implementation


uses MusicGraph_CouleursVoix,
     MusicUser {pour IsEnTrainDImprimer},
     MusicWriter_Erreur,
     MusicWriter_Console,
     Main {pour MainForm},
     instruments,
     FileSystem {pour GetPr} ,
     MusicGraph_CouleursUser,
     MusicSystem_Composition_Portees_Liste,
     Options_SaveAndLoad {option_Presentation_Affichage_Noms_Portees},
     MusicSystem_Octavieurs_Liste {pour OctavieurCombienToStr},
     Voix_Gestion, MusicSystem_MesureBase{pour Voix_Gestion_IsModeAutomatique},
     MusicUser_PlusieursDocuments;




var iportees_actives_1, iportees_actives_2: integer;


procedure Portees_Actives_Set(p1, p2: integer);
Begin
    iportees_actives_1 := p1;
    iportees_actives_2 := p2;
End;




procedure Portees_Actives_Toutes;
Begin
    iportees_actives_1 := 0;
    iportees_actives_2 := 255;
End;




procedure SetView(var View:TView);
Begin
    pixxdeb := View.pixxdeb;
    pixydeb := View.pixydeb;
    Zoom := View.Zoom;
    ModeAffichage := View.ModeAffichage;
    ViewCourant := @View;
End;



procedure SetViewNil;
//vue "par défaut" où tout est affiché (on utilise ça pour afficher les modèles}
Begin
    ViewCourant := nil;
End;





Procedure TraitDeCroche(x1, y1, x2, y2: TCoord);
const epaisseurtraitdecroche2 = 10;
var p:  array[0..3] of TPoint;
Begin
      p[0] := ScrPoint(pixXorigin + x1, pixYorigin + y1 - epaisseurtraitdecroche2);
      p[1] := ScrPoint(pixXorigin + x2, pixYorigin + y2 - epaisseurtraitdecroche2);
      p[2] := ScrPoint(pixXorigin + x2, pixYorigin + y2 + epaisseurtraitdecroche2);
      p[3] := ScrPoint(pixXorigin + x1, pixYorigin + y1 + epaisseurtraitdecroche2);
      inc(p[1].X);
      inc(p[2].X);
      C.Pen.Style := psClear;
      C.Polygon(p);
      C.Pen.Style := psSolid;
End;

Procedure DrawCadrePresentationVoix(Comp: TComposition; Canvas: TCanvas;
                                    Rect: TRect; n_voix: integer; style :integer;
                                    is_afficher_oeil, is_afficher_oreille: Boolean );
{style = 0 : cadre de voix complet...dans la fenêtre "gestion des voix"
 style = 1 : cadre de voix abrégé (dans la barre d'outils)}

var  iportee, num_voix_in_portee, x: integer;
     decalinstrument: integer;

     Function Oeil_X: integer;
     Begin
        result := Rect.Right - 19;
        if is_afficher_oreille then
             result := result - 17;

     End;

     Function Oreille_X: integer;
     Begin
         result := Rect.Right - 19;
     End;

     Function Paroles_X: integer;
     Begin
        result := Rect.Right - 19;
        if is_afficher_oreille then
             result := result - 17;
        if is_afficher_oeil then
             result := result - 17;
     End;


     Function Y_Get: integer;
     Begin
         result := Rect.Top+max(1, 1 + (Rect.Bottom - Rect.Top - 20) div 2);
     End;
     
Begin
      Canvas.Brush.Color := CouleursVoixFondList(Comp, n_voix);

      iportee := n_voix mod Comp.NbPortees;
      num_voix_in_portee := n_voix div Comp.NbPortees;

      if n_voix < Comp.NbPortees then
      Begin
          Canvas.Pen.Style := psSolid;
          decalinstrument := 5;
      End
      else
      Begin
          Canvas.Pen.Style := psClear;
          decalinstrument := 24;
      End;

      if style > 0 then decalinstrument := 5;

      Canvas.RoundRect(Rect.Left + decalinstrument - 5, Rect.Top,
                       Rect.Right, Rect.Bottom,16,16);

      MainForm.imgIconesInstruments.Draw(Canvas,
                     Rect.Left+decalinstrument,
                     Y_Get,Comp.Portee_InstrumentMIDINum[iportee]+1 );

      Canvas.Font.Color := clBlack;
      if style = 0 then
              Canvas.TextOut(Rect.left + decalinstrument + 25,
                             Y_Get, 'Portée n° ' + inttostr(iportee+1) +
                             ' (' + Comp.Portee_Groupe_Instrument_NomAAfficher(iportee) + '), voix n° ' + inttostr(num_voix_in_portee+1));
      {else
              Canvas.TextOut(Rect.left + decalinstrument + 25,
                             Y_Get,
                             'p' + inttostr(iportee+1) + ', v' + inttostr(num_voix_in_portee+1));}

      x := Paroles_X;
      if Comp.Voix_IsParoles(n_voix) then
          Canvas.Draw(x, Y_Get, imgBlabla);

      if is_afficher_oeil then
      Begin
             x := Oeil_X; 
             Canvas.Draw(x, Rect.Top+1, imgOeil);
             if not actchild.View.VoixAffichee[n_voix] then
                   Canvas.Draw(x, Y_Get, imgCroix);
      End;

      if is_afficher_oreille then
      Begin
           x := Oreille_X;
           Canvas.Draw(x, Rect.Top+1, imgOreille);
           if not actchild.View.VoixEntendue[n_voix] then
                  Canvas.Draw(x, Y_Get, imgCroix);
      End;
End;





Function GetDeltaBandeNomsPorteesDuModeRuban(Comp: TComposition): integer;
Begin
      result := Comp.GetMesure(0).pixx - margepourmesure + 200;
End;


Procedure GetAbscisseBandeNomsPorteesDuModeRuban(Comp: TComposition;
                                                var x1, x2: integer);
Begin
      x1 := GetX(0);
      x2 := x1 + GetDeltaBandeNomsPorteesDuModeRuban(Comp);
End;



procedure DrawAccolade(x, y1, y2, zp: integer;
                       typeAccolade: Byte);
const dxaccolade = 40;
      dyaccolade = 50;

Begin

     If typeAccolade = taAccolade then
     Begin
        DrawGraphic(x-DximgAccolade1*zp div ZoomMaxPrec,y1,x-DximgAccolade2,y2,imgAccolade);

     End
     else if typeAccolade = taCrochet then
     Begin
        SetGrosseurTrait(20);
        LineVertical(x-dxaccolade,y1,y2);
        Line(x-dxaccolade,y1,x,y1-dyaccolade);
        Line(x-dxaccolade,y2,x,y2+dyaccolade);
        SetGrosseurTrait(0);
     End;
End;





Function Portees_Is_Portees_Noms_Affiches(iligne: integer): Boolean;
Begin
     result :=
       (option_Presentation_Affichage_Noms_Portees = panpToutes)
       or
        (
        (option_Presentation_Affichage_Noms_Portees = panpJusteSurLaPremiereLigne)
          and (iligne = 0)
        );
End;




procedure Instruments_Noms_SetFontSize(iligne: integer);
Begin
    C.Font.Color := 0;
    if iligne = 0 then
    {si on affiche la première ligne, affiche également les noms
       des portées en entier et en "grand"}
       setFontSize(8)
    else
       setFontSize(6);

End;





procedure AfficherPartition(Comp: TComposition; l1, l2, x1, x2: integer);
const XTitre = 1000;

var l, i, v, x, y1, y2: integer;
    PU: TArrayBool;
    Caudebut: TCanvas;


    procedure AfficherLesNomsDesPorteesDevant;
    var l: integer;
    Begin


      if option_Presentation_Affichage_Noms_Portees = panpAucune then
           exit;

      With Comp do Begin
          C.Brush.Style := bsClear;
          C.Font.Color := 0;
          For l := l1 to l2 do
          Begin
              if (l > 0) and (option_Presentation_Affichage_Noms_Portees = panpJusteSurLaPremiereLigne) then
                  break;

              pixyorigin := Lignes[l].pixy;

              Instruments_Noms_SetFontSize(l);

              PU := PorteesVisibles(l);
             {
              For i := 0 to high(PorteesGlobales) do if PU[i] then
                    TextOut(0, GetY(l, i, 2), PorteesGlobales[i].Nom);  }

              i := 0;
              while i <= NbPortees - 1 do
              Begin
                  if Portee_GetTypeAccolade(i) = taAccolade then
                  {si l'accolade est {, le nom est commun à tout le groupe de portées
                   le nom est centré verticalement}
                  Begin
                      if PU[i] then

                        TextOut(0, Portee_Groupe_Instrument_NomAAfficher_Y(l, i),
                                        Portee_Groupe_Instrument_NomAAfficher(i) );

                      inc(i, Portee_GetNbPorteesInGroupe(i)+1);
                  End
                  else
                  {sinon, on affiche les noms pour la portée seule}
                  Begin
                      if PU[i] then
                        TextOut(0, (GetY(l, i, 2) + GetY(l, i, 2)) div 2,
                                        Portee_Groupe_Instrument_NomAAfficher(i));

                      inc(i, 1);
                  End;
              End;
          End;
      End; //with
    End;


    procedure AfficherClefsAccoladesTraits(a_clefs, a_accolades, a_traits: boolean; useinfoclefsx: Boolean; x_clef: integer);
      var l, ip: integer;
          clef : TClef;

    Begin
      With Comp do
      Begin
         C.Brush.Style := bsSolid;
         C.Brush.Color := CouleurDessin;
         For l := l1 to l2 do
         Begin
                 IGiLigne := l;
                 x := Ligne_XGauche(l);
                 pixyorigin := Lignes[l].pixy;

                 DrawBarToutlelong(x, comp,l);
                 PU := PorteesVisibles(l);
                 For ip := 0 to NbPortees - 1 do
                 if PU[ip] then
                 Begin
                       if a_clefs then
                       Begin
                             if useinfoclefsx then
                                   clef := Clefs_DetecterAvecpixX(ip,x_clef, Lignes[0].pixy)
                             else
                                   clef := Clefs_Detecter(ip, Lignes[l].mdeb, Qel(0,1));

                             DrawClefDebutPortee(comp,
                                           l,
                                           x + 2,
                                           ip,
                                           clef);
                       End;

                       y1 := Comp.Portee_YHaut_Barre_InRepere_Ligne(l, ip);
                       y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(l, ip + Portee_GetNbPorteesInGroupe(ip));


                       if a_accolades then
                             DrawAccolade(x, y1, y2, ZoomPortee(ip),
                                          Portee_GetTypeAccolade(ip) );

                 End;

                 if a_traits then
                 Begin
                       if (ModeAffichage = maRuban) then
                             DrawLines(Comp, l, x, -1000)
                             {euh... en mode maRuban, normalement, l = 0,
                             sinon ya craquage... normal, c'est parce qu'il n'y a
                             qu'une ligne}
                       else
                             DrawLines(Comp, l, x, largutilisable);
                 End;


         End;
        End;
   End;





   Function AfficherSeperationOrchestre: Boolean;
   Begin
       result := Comp.IsPartitionDOrchestre
                  and (LesPorteesSontDessinesAZoomDefaut = false);
       {on affiche les // si...
        1) on a une partition d'orchestre
        2) (LesPorteesSontDessinesAZoomDefaut = false) est équivalent à
             on affiche un conducteur}
   End;



   Procedure Octavieurs_Afficher;
   var p: integer;

          procedure Octavieur_Afficher(combien: integer; m1: integer; t1: TRationnel;
                                       m2: integer; t2: TRationnel);
          var l, l1,l2: integer;
              y, x1, x2: integer;

          const octavieur_equerre_taille = 80;

          Begin
               if Combien = 0 then exit;

               
               l1 := Comp.LigneAvecMes(m1);
               l2 := Comp.LigneAvecMes(m2);
               //on fait comme si tout était sur la ^m lige pour l'instant

               SetPixOrigin(0, 0);
               C.Pen.Width := 0;
               C.Pen.Style := psDot;

               C.Brush.Style := bsClear; //en rajoutant ça, la ligne d'au dessus marche !!
               for l := l1 to l2 do
               if Comp.PorteesVisibles(l)[p] then
               Begin
                   y := Comp.Octavieurs_GetY(l, p, combien);


                   if l = l1 then
                   Begin
                         x1 := Comp.GetMesure(m1).pixX + Comp.GetMesure(m1).XATemps(t1);
                         TextOut(x1, y, OctavieurCombienToStr(combien));
                   End
                   else
                         x1 := Comp.Ligne_XGauche(l);

                   if l = l2 then
                         x2 := Comp.GetMesure(m2).pixX + Comp.GetMesure(m2).XATemps(t2)
                   else
                         x2 := Comp.Ligne_XDroite(l);

                         
                   LineHorizontal(x1, x2, y);

               End;

               C.Pen.Style := psSolid;

               LineHorizontal(x2 - octavieur_equerre_taille, x2, y);

               if combien = 1 then
                      LineVertical(x2, y, y+octavieur_equerre_taille)
               else
                      LineVertical(x2, y, y-octavieur_equerre_taille);
          End;

   var i, imesfin: integer;
       tempsfin: TRationnel;
       
   Begin
       for p := 0 to Comp.NbPortees - 1 do
       with Comp.Portee_Octavieurs_Liste(p) do
            for i := 0 to high(private_liste) do
            Begin
                 if i < high(private_liste) then
                 Begin
                     imesfin := private_liste[i+1].imesure;
                     tempsfin := private_liste[i+1].Temps;

                 End
                 else
                 Begin
                     imesfin := Comp.NbMesures - 1;
                     tempsfin := QInfini;
                 End;

                 Octavieur_Afficher(private_liste[i].combien,
                                    private_liste[i].imesure, private_liste[i].Temps,
                                    imesfin, tempsfin);

            End;
   End;



   Function IsVoix_FondAfficheeCouleurReelle(N_Voix: integer): Boolean;
   Begin
        if option_VoixInactive_ToujoursFondPlusClair then
               result := (N_Voix = actchild.Curseur.GetiVoixSelectionnee)
        else
               result := Voix_Gestion_IsModeAutomatique or (N_Voix = actchild.Curseur.GetiVoixSelectionnee);
   End;



    procedure Partition_Titre_Afficher;
    var zz: integer;

    Begin
         pixXorigin := 0;
         pixYorigin := 0;
         C.Font.Color := 0;
         setFontSize(FontSizeTitre);
         C.Brush.Style := bsClear;
         if (CDevice = devImprimante) then
             zz := 100
         else
             zz := ZoomMaxPrec;
         TextOut((largutilisable - C.TextWidth(Comp.Nom) * zz div ZoomParDefaut) div 2,
                 YTitre,
                 Comp.Nom);

    End;




    procedure Trainees_Draw;
    var l, m, v: integer;
    Begin
            C.Pen.Style := psSolid;
            With Comp do
            for l := l1 to l2 do
                  Begin
                      IGP := Comp;
                      IGiLigne := l;

                      for m := GetMesureSurLigne(l, x1) to GetMesureSurLigne(l, x2) do
                      With GetMesure(m) do
                            Begin
                                 SetOriginMesure(m);
                                 for v := 0 to high(Voix) do
                                       with Voix[v] do
                                        if IsAffichee then
                                        Begin
                                              if IsVoixAccessibleEdition(N_Voix) then
                                              Begin
                                                        C.Pen.Color := CouleursVoixTrainees(Comp, N_Voix);
                                                        Trainees_Draw;
                                              End;

                                        End;
                            End;
                  End;
  End;

Begin
    MusicGraph_Canvas_Lock;

    SetMusicWriterAffiche;

    Console_AjouterLigne('Afficher Partition :');

    IGP := Comp;

    Caudebut := C;


    With Comp do Begin
        if l1 < 0 then
           l1 := 0;

        {fond de portées quand ya le mode "Portée Courante"}
        if (ModeAffichage = maRuban) and IsPartitionDOrchestre then {if mode portée courante}
        Begin
            IGiLigne := 0;

            SetPixOrigin(0, Lignes[0].pixy);

            y1 := GetY(iPorteeCourant, -DEMI_HAUTEUR_BANDE_PORTEE);
            y2 := GetY(iPorteeCourant, DEMI_HAUTEUR_BANDE_PORTEE);

            C.Brush.Color := COULEUR_FOND_NOMS_PORTEES_EN_MODE_RUBAN;
            C.Brush.Style := bsSolid;


            FillRect(x1, y1, x2, y2);


        End;


        {affichage du titre de la partition
        exemple : Sonate en ré majeur ou Symphonie fantastique}
        if l1 = 0 then
              Partition_Titre_Afficher;






        if l2 > high(Lignes) then
             l2 := high(Lignes);

             //Fond des voix
             if option_TracerFondVoix and (CDevice = devEcran) then
             Begin
                   C.Pen.Color := 0;
                   C.Pen.Style := psClear;
                   for l := l1 to l2 do
                   Begin
                         IGiLigne := l;
                         for i := GetMesureSurLigne(l, x1) to GetMesureSurLigne(l, x2) do
                         With GetMesure(i) do
                                 Begin
                                        SetOriginMesure(i);
                                        for v := 0 to high(Voix) do
                                        with Voix[v] do
                                        if IsAffichee then
                                        if N_Voix >= 0 then
                                        Begin
                                              if Voix_Gestion_IsModeAutomatique then
                                              Begin
                                                    if option_VoixInactive_ToujoursFondPlusClair then
                                                    Begin
                                                           if N_Voix <> actchild.Curseur.GetiVoixSelectionnee then
                                                                C.Brush.Color := CouleursVoixFondInactiveMaisAccessible(Comp, N_Voix)
                                                           else
                                                                C.Brush.Color := CouleursVoixFond(Comp, N_Voix);

                                                    End
                                                    else
                                                           C.Brush.Color := CouleursVoixFond(Comp, N_Voix);


                                              End
                                              else
                                              Begin
                                                   if IsVoixAccessibleEdition(N_Voix) then
                                                        C.Brush.Color := CouleursVoixFond(Comp, N_Voix)
                                                   else
                                                        C.Brush.Color := CouleursVoixNonAccessibleFond(Comp, N_Voix);

                                              End;

                                                   
                                              DrawFond(false, pixWidth);
                                        end;
                                 end;
                   End;
             End;





              Trainees_Draw;

              C.Pen.Style := psSolid;
              C.Pen.Color := 0;
              //clef en début de ligne, et lignes des portées
              pixxorigin := 0;

              {s'occupe d'afficher les noms des portées devant...}
              AfficherLesNomsDesPorteesDevant;

             {dessine les portées des lignes concernées ie :
               - les clés en début de lignes
               - les éventuels accolades de décorations
               - les traits de portées ("5 lignes")}

             if ModeAffichage = maRuban then
                    //AfficherClefsAccoladesTraits(false, false, true, false, 0)
             else
                    AfficherClefsAccoladesTraits(true, true, true, false, 0);


             if C <> Caudebut then
                  MessageErreur('C a changé !');

             {affiche les mesures}
             for l := l1 to l2 do
             Begin
                   Console_AjouterLigne('    ligne n°' + inttostr(l));
                   Console_AjouterLigne('        de la mesure n°' + inttostr(GetMesureSurLigne(l, x1))
                                                             + ' à ' + inttostr(GetMesureSurLigne(l, x2)));
                   IGiLigne := l;

                   if AfficherSeperationOrchestre then
                   if (Lignes[l].pixy div hauteurpage
                           = Lignes[max(l-1, 0)].pixy div hauteurpage) and (l > 0) then
                   Begin
                          SetPixOrigin(0, 0);
                          DrawBitmap(DECAL_imgSeperationOrchestre_X, (Lignes[l].pixy + (Lignes[l-1].pixy + PorteesPixY[l-1][NbPortees]) ) div 2,
                                     imgSeperationOrchestre, ZoomMaxPrec);
                   End;



                   i := GetMesureSurLigne(l, x1);
                   while i <= GetMesureSurLigne(l, x2) do
                   With GetMesure(i) do
                         Begin
                                IGP := Comp;
                                SetOriginMesure(i);
                                DrawMesure(i);

                                {barre de fin de composition si on affiche la toute
                                 dernière mesure}
                                if i = NbMesures - 1 then
                                Begin
                                       DrawBarBar(pixWidth-15, pixWidth+15, Comp, IGiLigne);
                                       SetGrosseurTrait(0);
                                       DrawBar(pixWidth-40, Comp, IGiLigne);
                                End;


                                if NbMesuresCompressees < 1 then
                                Begin
                                      MessageErreur('NbMesuresCompressees vaut moins que 1 !!' +
                                             ' Est-ce que ça a été calculé ? On est met à 1' +
                                            '(on est dans AfficherPartition)');
                                      NbMesuresCompressees := 1;
                                End;


                                inc(i, NbMesuresCompressees);
                         end;
             End;

                      {en mode ruban... on affiche les noms des instruments devant et la clé...}
             if ModeAffichage = maRuban then
             Begin
                   C.Brush.Color := COULEUR_FOND_NOMS_PORTEES_EN_MODE_RUBAN;
                   C.Brush.Style := bsSolid;
                   SetPixOrigin(0, 0);
                   GetAbscisseBandeNomsPorteesDuModeRuban(Comp, x1, x2);
                   y1 := -1000;
                   y2 := 100000;
                   FillRect(x1, y1, x2, y2);

                   pixxorigin := x1;

                   AfficherLesNomsDesPorteesDevant;
                   AfficherClefsAccoladesTraits(True, true, true, true, x2 + PETITE_MARGE_DETECTION_CLEF_MODE_RUBAN);
             End;

             SetPixOrigin(0, 0);
             for i := 0 to NbObjetsGraphiques - 1 do
                    ObjetGraphique_Get(i).Draw;


    End; //With Comp

    Octavieurs_Afficher;

    MusicGraph_Canvas_UnLock;
End;












procedure AfficherPartitionToutesLesLignes(Comp: TComposition; l1, l2:integer);
Begin
    AfficherPartition(Comp, l1, l2, -infinity, +infinity);
End;



Procedure LinesPourPortee_GetBorneInf_BorneSup(typeportee: integer; out borneinf, bornesup: integer);
Begin
     case typeportee of
        tpPortee5Lignes:
        Begin
            borneinf := -2;
            bornesup := 2;
        End;
        tpPortee1Ligne:
        Begin
            borneinf := 0;
            bornesup := 0;
        End;
        tpPorteeTablatureGuitare:
        Begin
            borneinf := -3;
            bornesup := 2;
        End;
        tpPorteeTablatureBasse:
        Begin
            borneinf := -2;
            bornesup := 1;
        End;

    end;
End;


//mode bande
procedure DrawLinesPour1Portee_TOUTESLESPORTEES(Comp: TComposition; x1, x2, portee: integer);
var i, y:integer;
    typeportee, borneinf, bornesup: integer;
Begin
    if Nepasafficherdutout then Exit;

    if ScrY(pixYorigin + GetY_TOUTESLESPORTEES(Comp, portee, 2 * 2)) > CHeight then
          exit
    else if ScrY(pixYorigin + GetY_TOUTESLESPORTEES(Comp, portee, 2 * -2)) < 0 then
          exit;

{l'affichage du type de portées !!!}
    if Comp = nil then
         typeportee := tpPortee5Lignes
    else
         typeportee := Comp.Portee_Type[PORTEE];

    LinesPourPortee_GetBorneInf_BorneSup(typeportee, borneinf, bornesup);

    for i := borneinf to bornesup do
         Begin
                y := GetY_TOUTESLESPORTEES(Comp, portee, 2 * i);
                LineHorizontal(x1,x2,y);
         End;

End;




//mode bande
procedure DrawLinesPour1Portee(Comp: TComposition; iligne, x1, x2, portee: integer);
var i, y:integer;
    typeportee, borneinf, bornesup: integer;
Begin
    if Nepasafficherdutout then Exit;

    if ScrY(pixYorigin + GetY(Comp, iligne, portee, 2 * 2)) > CHeight then
          exit
    else if ScrY(pixYorigin + GetY(Comp, iligne, portee, 2 * -2)) < 0 then
          exit;

{l'affichage du type de portées !!!}
    if Comp = nil then
         typeportee := tpPortee5Lignes
    else
         typeportee := Comp.Portee_Type[PORTEE];

    LinesPourPortee_GetBorneInf_BorneSup(typeportee, borneinf, bornesup);

    for i := borneinf to bornesup do
         Begin
                y := GetY(Comp, iligne, portee, 2 * i);
                LineHorizontal(x1,x2,y);
         End;

End;



procedure DrawLines(comp: TComposition; iligne, x1, x2 : integer);
var p:integer;
    PU: TArrayBool;

const CouleurStyloLignesPorteesInactives = $BBBBBB;
Begin
if Nepasafficherdutout then Exit;
With comp do
Begin
      PU := PorteesVisibles(iligne);

      for p := 0 to Comp.NbPortees - 1 do
            if PU[p] then
            Begin

                if Zoom < 50 then
                      C.Pen.Color := CouleurLignesQuandZoomPetit
                else
                Begin
                    if OPTION_AfficherPortees_Inactives_Grisees then
                    Begin
                        if p in [iportees_actives_1..iportees_actives_2] then
                            C.Pen.Color := CouleurStylo
                        else
                            C.Pen.Color := CouleurStyloLignesPorteesInactives;
                    End
                    else
                            C.Pen.Color := CouleurStylo;

                End;

                DrawLinesPour1Portee(Comp, iligne, x1, x2, p);

            End;


end;
End;



procedure DrawLines_TOUTESLESPORTEES(comp: TComposition; x1, x2 : integer);
var p:integer;
Begin
if Nepasafficherdutout then Exit;
With comp do
Begin
      if Zoom < 50 then
            C.Pen.Color := CouleurLignesQuandZoomPetit;

      for p := 0 to Comp.NbPortees - 1 do
                DrawLinesPour1Portee_TOUTESLESPORTEES(Comp, x1, x2, p);


end;
End;







Procedure DrawArrete(Comp: TCompositionAvecPagination;
                     iligne: integer;
                     cx: integer;
                     Pos: TPosition;
                     taillearrete: integer);

{dessine les eventuels traits de portées qu'on rajoute pour lire la note situé à
 la position graphique pos, en l'ascisse cx, sur la ligne iligne de la
 composition Comp. taillearrete est une estimtion de la largeur des lignes.
 taillarrete = rayon de la note}

const pixwfactor = 1.5;

var iPortee, iHauteur, i, y: integer;
Begin
if Nepasafficherdutout then Exit;

iHauteur := Pos.hauteur;
iPortee := Pos.portee;

for i := 3 to iHauteur div 2 do //demi-hauteur
            Begin
                 y := GetY(Comp, iligne, iPortee, i * 2);
                 Line(cx-round(taillearrete*pixwfactor), y, cx+round(taillearrete*pixwfactor), y);

            End;

for i := -3 downto iHauteur div 2 do //demi-hauteur
            Begin
                 y := GetY(Comp, iligne, iPortee, i * 2);
                 Line(cx-round(taillearrete*pixwfactor), y, cx+round(taillearrete*pixwfactor), y);

            End;

End;


Procedure DrawAlteration(x,y:integer; a: TAlteration; zp: integer);
Begin
      if (integer(a) > 5) then
           Exit;
      DrawBitmap(x - (DecalXAlteration[a]) * zp div ZoomMaxPrec,
                 y+DecalYAlteration[a] * zp div ZoomMaxPrec,imgAlteration[0, a], zp);

End;


Procedure DrawQueueDeCroche(cx, cy: integer;
                            QueueVersBas: Boolean;
                            zoom: integer);
var sign: integer;
Begin
if Nepasafficherdutout then Exit;
if QueueVersBas then
   sign := -1
else sign := 1;

DrawGraphic(cx, cy,
            cx + AuZoom(imgQueueCrocheDessus.Width*prec,zoom),
            cy + AuZoom(prec*imgQueueCrocheDessus.Height*sign,zoom),
            imgQueueCrocheDessus);

End;






procedure DrawPause_DureeApproximative(Comp: TCompositionAvecPagination;
                    iligne: integer;
                    gris: boolean;
                    x:integer;
                    pos:TPosition);
const Pause_Duree_Approximative_Taille = 2* nbpixlign;
var y:integer;
Begin
    if Nepasafficherdutout then Exit;

    y := gety(Comp, iligne, pos);

    Line(x, y, x + Pause_Duree_Approximative_Taille, y + Pause_Duree_Approximative_Taille);

End;






Procedure DrawPause(Comp: TCompositionAvecPagination;
                    iligne: integer;
                    typ:integer;
                    gris: boolean;
                    x:integer;
                    pos:TPosition);

var y, zz:integer;
Begin
if Nepasafficherdutout then Exit;
    zz := ZoomPortee(pos.portee);

    y := gety(Comp, iligne, pos) - decalypause[typ] * zz div ZoomMaxPrec;

    if gris then
         DrawBitmap(x, y, imgPausesG[typ], zz)
    else
         DrawBitmap(x, y, imgPauses[typ], zz);

End;


Procedure DrawElMusicalQueuesIndependantes(Comp: TCompositionAvecPagination;
                        iligne: integer;
                        elm: TElMusical);
var j, xqueue, qq: integer;
Begin
      if elm.Duree_IsApproximative then exit;

      
      xqueue := elm.GetXQueue;

      if elm.QueueVersBas then
             qq := -1
      else
             qq := 1;

     for j := 1 to QNbQueueAUtiliser(elm.Duree_Get) do
         DrawQueueDeCroche(xqueue,
                           elm.YExtremiteQueue + qq*60*(j-1),
                           elm.QueueVersBas,
                           ZoomPortee(elm.PorteeApprox));

End;





Procedure ElMusical_Trainee_Draw(Comp: TCompositionAvecPagination;
                        iligne: integer;
                        elm: TElMusical);
var rpixx, n, rayonnote, decalxboule, y: integer;
Begin
     elm.VerifierIntegrite('DrawElMusical');

      if not elm.Duree_IsApproximative then
           exit;

     rpixx := elm.pixx;

    {rpixx correspond au "pixx" réellement affiché
    dans le cas d'une animation notamment, c'est un barycentre de lastpixx et pixx}

    if ScrY(pixYorigin + elm.pixyhaut) > CHeight then
          exit
    else if ScrY(pixYorigin + elm.pixybas) < 0 then
          exit;



    for n := 0 to high(elm.Notes) do
    With elm.Notes[n] do
    Begin
            rayonnote := RayonNotes[elm.TailleNote] *
                           ZoomPortee(elm.Notes[n].Position.portee)
                                                            div ZoomMaxPrec;

            if elm.GetBoulesCotes = bcMixte then
            Begin
                   if GetPr(elm.Notes[n].BouleADroite, naBouleADroite) then
                          decalxboule := rayonnote
                   else
                          decalxboule := -rayonnote
            End
            else
            Begin
                    decalxboule := 0;
            End;

            y := GetY(Comp, iligne, elm.Notes[n].Position);




            Trainee_Draw(rpixx + decalxboule,
                         y,
                         elm.trainee_duree_pixxdroite,
                         elm.TailleNote,
                         ZoomPortee(elm.Notes[n].Position.portee));
     End;


End;




Procedure DrawElMusical(Comp: TCompositionAvecPagination;
                        iligne: integer;
                        elm: TElMusical;
                        DrawQueueCroche: Boolean;
                        onlyselected: boolean);
{dessine l'élément musical elm, appartenant à la composition Comp, présent dans
 la ligne iligne.
  Dessine la queue de croche ssi DrawQueueCroche est activé
  dessine que ce qui est nécessaire (ou un cadre dans le cas des silences) ssi
  onlyselected = true}
var decalxboule: integer;
        rpixx,rayonnote,y: integer;

         procedure Dessiner_LiaisonALaNoteSuivante;
         var p: integer;
         var yautre: integer;
          Begin
              //trace la liaison à la note suivante
              p := decalxboule + elm.pixWidthdroite - rayonnote;


              if elm.QueueVersBas then
                     yautre := y + HauteurLiasonALaSuivante
              else
                     yautre := y - HauteurLiasonALaSuivante;

              if elm.Duree_IsApproximative then
              Begin
                  p := decalxboule + rpixx + elm.pixWidthdroite - elm.trainee_duree_pixxdroite;
                  Spline(decalxboule + elm.trainee_duree_pixxdroite, y,
                         decalxboule + elm.trainee_duree_pixxdroite + 1*p / 2, yautre,
                         decalxboule + elm.trainee_duree_pixxdroite + 4*p / 5, yautre,
                         rpixx +  elm.pixWidthdroite - 1.5*rayonnote, y);


              End
              else
              Begin
                   p := decalxboule + elm.pixWidthdroite - rayonnote;
                   Spline(rpixx + decalxboule + 1.5*rayonnote, y,
                         rpixx + 1*p / 2, yautre,
                         rpixx + 4*p / 5, yautre,
                         rpixx +  elm.pixWidthdroite - 1.5*rayonnote, y);
              End;

          End;



var n,p,
    xqueue,
    decalxpointduree,
    point_duree_y,
    zp: integer;
    ErreurTessiture: Boolean;
    Tessi1, Tessi2: THauteurNote;


Begin

elm.VerifierIntegrite('DrawElMusical');
IGP := Comp;
IGiLigne := iligne;
if AfficherAvecUneAnimation then
    rpixx := (Animation_ElMusicaux_Indice * elm.lastpixx
            + (nbframeAnim - Animation_ElMusicaux_Indice) * elm.pixx) div nbframeAnim

else
     rpixx := elm.pixx;

{rpixx correspond au "pixx" réellement affiché
dans le cas d'une animation notamment, c'est un barycentre de lastpixx et pixx}

if ScrY(pixYorigin + elm.pixyhaut) > CHeight then
      exit
else if ScrY(pixYorigin + elm.pixybas) < 0 then
      exit;

//if Nepasafficherdutout then Exit;
if not elm.IsSilence then
Begin
    //dessin de la queue (ligne)
    if not elm.Duree_IsApproximative then
    if IsQ1StrInfQ2(elm.Duree_Get, Qel(4)) and not onlyselected then
    Begin
            xqueue := elm.GetXQueue;
            if not onlyselected then
                  if elm.QueueVersBas then
                          Line(xqueue, GetY(Comp, iligne, elm.PosNoteHaut),
                               xqueue, elm.YExtremiteQueue)
                  Else
                          Line(xqueue, GetY(Comp, iligne, elm.PosNoteBas),
                               xqueue, elm.YExtremiteQueue);
    End;

    if DrawQueueCroche and not onlyselected then
            DrawElMusicalQueuesIndependantes(comp, iligne, elm);



    for n := 0 to high(elm.Notes) do
    With elm.Notes[n] do
    if (not onlyselected) or (Selectionne <> svDeSelectionnee) then
    Begin
            zp := ZoomPortee(elm.Notes[n].Position.portee);
            rayonnote := RayonNotes[elm.TailleNote] *
                           ZoomPortee(elm.Notes[n].Position.portee)
                                                            div ZoomMaxPrec;

            if elm.GetBoulesCotes = bcMixte then
            Begin
                   decalxpointduree := rayonnote;
                   if GetPr(elm.Notes[n].BouleADroite, naBouleADroite) then
                          decalxboule := rayonnote
                   else
                          decalxboule := -rayonnote
            End
            else
            Begin
                    decalxboule := 0;
                    decalxpointduree := 0;
            End;

            y := GetY(Comp, iligne, elm.Notes[n].Position);




            if (not onlyselected) then
            {règle si l'intérieur de la note est opaque ou non}
            Begin
                  DessinerOpaque := not IsQ1InfQ2(Qel(2), elm.Duree_Get);
                  if DessinerOpaque then
                        ChangerBrushStyle(bsSolid)
                  else
                        ChangerBrushStyle(bsClear);
            End;

            //changer la couleur (en rouge) en cas d'erreur de tessiture
//            GetInstrumentTessiture(...)

            ErreurTessiture := false;
            if (CouleurDessin = CouleurStylo) and (Comp <> nil) and (not onlyselected) then
            Begin
                Comp.VerifierIndicePortee(position.portee, 'position correcte pour calcul de tessiture...');

                GetInstrumentTessiture(Comp.Portee_InstrumentMIDINum[position.portee],
                                       Tessi1, Tessi2);

                if not (IsHauteurNote1InfHauteurNote2(Tessi1, HauteurNote) and
                        IsHauteurNote1InfHauteurNote2(HauteurNote, Tessi2)) then
                                ErreurTessiture := true;

            End;

            if ErreurTessiture then
            Begin
                  CouleurDessin := CouleurStyloCorrection;
                  C.Brush.Color := CouleurDessin;
                  C.Pen.Color := CouleurDessin;
            End;


            if elm.Duree_IsApproximative then
                   CercleNote_Duree_Approximative_Draw(rpixx + decalxboule,
                                                       y,
                                                       elm.trainee_duree_pixxdroite,
                                                       elm.TailleNote,
                                 ZoomPortee(elm.Notes[n].Position.portee))
            else
                   CercleNote_Draw(rpixx + decalxboule, y, elm.TailleNote,
                   ZoomPortee(elm.Notes[n].Position.portee));

            if ErreurTessiture then
            Begin
                  CouleurDessin := CouleurStylo;
                  C.Brush.Color := CouleurDessin;
                  C.Pen.Color := CouleurDessin;
            End;

            if not onlyselected then
            Begin
                  DrawArrete(Comp, iligne, rpixx + decalxboule,
                             elm.Notes[n].Position, rayonnote);

                  if GetPr(elm.Notes[n].BouleADroite, naLieALaSuivante) then
                         Dessiner_LiaisonALaNoteSuivante;




                  //Dessine le "PointDuree" (note pointée...)
                  //RechangerBrushSolid(CouleurDessin);
                  if not elm.Duree_IsApproximative then
                  Begin
                      ChangerBrushStyle(bsSolid);
                      if elm.GetNbPointsDuree > 0 then
                      Begin
                          if IsPositionSurLigne(elm.Notes[n].Position) then
                                point_duree_y := y - rayonnote div 2
                          else
                                point_duree_y := y;
                          //RechangerBrushSolid(CouleurDessin);
                          for p := 1 to elm.GetNbPointsDuree do
                                Cercle(rpixx + decalxpointduree + nbpixlign + p * nbpixlignentrepointduree,
                                       point_duree_y,
                                       rayonpointduree * zp div ZoomMaxPrec);
                      End;
                  End;





                  if elm.Notes[n].AfficherAlteration then
                  Begin
                      y := y - ydecaltextealteration * zp div ZoomMaxPrec;
                      if elm.Notes[n].hauteurnote.Alteration <> aNormal then
                          ChangerBrushStyle(bsClear);
                          //setFontSize(10);

                      
                      {decalxboule c'est le décalage pour être devant la boule
                       elm.pixxdevantboule c'est l'écart supplémentaire, sorte
                        de marge}
                      DrawAlteration(elm.pixxdevantboule + decalxboule * zp div ZoomMaxPrec,
                                     y,
                                     elm.Notes[n].hauteurnote.Alteration,
                                     zp);
                      

                      RechangerBrushSolid(CouleurDessin);
                  End;


                  {notes piquées}
                  if elm.GetAttrib(as1_Pique) then
                  Begin
                      if elm.QueueVersBas then
                              Cercle(elm.pixx, elm.pixyhaut - distpique,
                                   rayonpointpique * zp div ZoomMaxPrec)
                      else
                              Cercle(elm.pixx, elm.pixybas + distpique,
                                   rayonpointpique * zp div ZoomMaxPrec);

                  End;


                  if elm.GetAttrib(as1_Pizzicato) then
                  Begin
                      if elm.QueueVersBas then
                              DrawBitmapCentre(elm.pixx, elm.pixyhaut - distpique,
                                   imgPizzicato, zp)
                      else
                              DrawBitmapCentre(elm.pixx, elm.pixybas + distpique,
                                   imgPizzicato, zp);


                  End;

                  {trilles}
                  if elm.attributs.Style2 in aSetTrille then
                  Begin
                      ChangerBrushStyle(bsClear);
                      if elm.QueueVersBas then
                              TextOut(elm.pixx-3, elm.pixyhaut - distpique - TextHeight, 'tr')
                      else
                              TextOut(elm.pixx-3, elm.pixybas + distpique, 'tr');

                  End;
            End;
    end;

End
else //PAUSE: DrawElMusical
     //************
Begin
   zp := ZoomPortee(elm.PorteeApprox);

   if not onlyselected then
   Begin
         if elm.Duree_IsApproximative then
             DrawPause_DureeApproximative(Comp, iligne,
                                          (CouleurDessin = CouleurNoteDansVoixInactive),
                                          rpixx,
                                          elm.Position)
         else
             DrawPause(Comp, iligne, NumeroDessinPause(elm.Duree_Get),
                  (CouleurDessin = CouleurNoteDansVoixInactive), rpixx, elm.Position);

         if elm.GetNbPointsDuree > 0 then
                  Begin
                      //RechangerBrushSolid(CouleurDessin);
                      y := elm.pixyhaut+16;
                      n := elm.pixRect.Right - elm.pixRect.Left;
                      for p := 1 to elm.GetNbPointsDuree do
                            Cercle(rpixx + n + p * nbpixlignentrepointduree* zp
                                                                div ZoomMaxPrec,
                                   y,
                                   rayonpointduree * zp div ZoomMaxPrec);
                  End;
   End;

   
   if (elm.IsSelectionnePasForcementValide) and (CDevice = devEcran) then
   {affiche un cadre rectangle autour de la pause}
   Begin
         ChangerBrushStyle(bsClear);
         C.Pen.Color := 255;
         Rectangle(elm.pixRect);
         C.Pen.Color := CouleurDessin;
   End;





End;

End;



procedure DrawBarToutlelong(x:integer; comp: TCompositionAvecPagination; iligne: integer);
var y1, y2:integer;
Begin
     if comp = nil then
     Begin
          y1 := GetY(nil, 0, 0, 4);
          y2 := GetY(nil, 0, 0, -4);
     End
     else
     Begin
         y1 := Comp.Portee_YHaut_Barre_InRepere_Ligne(iLigne, comp.PremierePorteeAffichee(iLigne));
         y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(iLigne, comp.DernierePorteeAffichee(iLigne));
     End;

     Line(x, y1, x, y2);
End;

procedure DrawBarToutlelongAvecExcitation(x:integer; comp: TCompositionAvecPagination; iligne: integer; excitation: integer);
const barre_lecture_debordage = 20;
var y1, y2, x1, x2:integer;
Begin
     if comp = nil then
     Begin
          y1 := GetY(nil, 0, 0, 4);
          y2 := GetY(nil, 0, 0, -4);
     End
     else
     Begin
         y1 := Comp.Portee_YHaut_Barre_InRepere_Ligne(iLigne, comp.PremierePorteeAffichee(iLigne));
         y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(iLigne, comp.DernierePorteeAffichee(iLigne));
     End;

     x1 := x + Random(excitation*2) - excitation;
     x2 := x + Random(excitation*2) - excitation;
     y1 := y1 + Random(excitation*2) - excitation - barre_lecture_debordage;
     y2 := y2 + Random(excitation*2) - excitation + barre_lecture_debordage;
     Line(x1, y1, x2, y2);
End;


procedure DrawIctus(x:integer; comp: TCompositionAvecPagination; iligne: integer);
const ictus_hauteur = 160;
var y1, y2, x1, x2:integer;
Begin
     if comp = nil then
     Begin
          y2 := GetY(nil, 0, 0, 4);
          y2 := y1 - ictus_hauteur;
     End
     else
     Begin
         y2 := Comp.Portee_YHaut_Barre_InRepere_Ligne(iLigne, comp.PremierePorteeAffichee(iLigne));
         y1 := y2 - ictus_hauteur;
     End;

     x1 := x;
     x2 := x;
     y1 := y1;
     y2 := y2;
     Line(x1, y1, x2, y2);
End;

Procedure DrawBar(x:integer; comp: TCompositionAvecPagination; iligne: integer);
var PV: TArrayBool;
var y1, y2, i, i_fin:integer;
Begin
   if (option_Presentation_Affichage_Barres_Mesures = pabmToutLeLong)
      or LesPorteesSontDessinesAZoomDefaut then
        DrawBarToutlelong(x, comp, iLigne)
   else
   Begin
        PV := comp.PorteesVisibles(iLigne);

        i := 0;

        while i <= Comp.NbPortees - 1 do
        Begin
             if option_Presentation_Affichage_Barres_Mesures = pabmParPortee then
                    i_fin := i
             else
                    i_fin := i + comp.Portee_GetNbPorteesInGroupe(i);

             while (i <= i_fin) and not PV[i] do
                inc(i);       

             if i <= i_fin then
             Begin
                    y1 := Comp.Portee_YHaut_Barre_InRepere_Ligne(iligne, i);
                    y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(iligne, i_fin);
                    
                    Line(x, y1, x, y2);
             End;

             i := i_fin + 1;


        End;
        Finalize(PV);
   End;

End;


Procedure DrawBarBarToutlelong( x1, x2 :integer; comp: TCompositionAvecPagination; iligne: integer);
var y1, y2:integer;
Begin
   y1 := Comp.Portee_YHaut_Barre_InRepere_Ligne(iLigne, comp.PremierePorteeAffichee(iLigne));
   y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(iLigne, comp.DernierePorteeAffichee(iLigne));

   Rectangle(x1, y1, x2, y2);
End;


Procedure DrawBarBar( x1, x2 :integer; comp: TCompositionAvecPagination; iligne: integer);
var PV: TArrayBool;
var y1, y2, i:integer;
Begin
   if (option_Presentation_Affichage_Barres_Mesures = pabmToutLeLong)
      or LesPorteesSontDessinesAZoomDefaut then
        DrawBarBarToutlelong(x1, x2, comp, iLigne)
   else
   Begin
        PV := comp.PorteesVisibles(iLigne);

        i := 0;
        C.Brush.Color := CouleurStylo;
        
        while i <= Comp.NbPortees - 1 do
        Begin
             if PV[i] then
             Begin
                    y1 := Comp.Portee_YHaut_Barre_InRepere_Ligne(iligne, i);
                    y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(iligne,
                                      comp.Portee_GetNbPorteesInGroupe(i) + i);
                    Rectangle(x1, y1, x2, y2);
             End;

             inc(i, comp.Portee_GetNbPorteesInGroupe(i) + 1);

        End;
        Finalize(PV);
   End;

End;


Procedure DrawBarZigZag(x:integer; comp: TCompositionAvecPagination; iligne: integer);
var y1, y2:integer;
    i: integer; 
Begin
   y1 := Comp.Portee_YHaut_Barre_InRepere_Ligne(iLigne, comp.PremierePorteeAffichee(iLigne));
   y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(iLigne, comp.DernierePorteeAffichee(iLigne));

   for i := 0 to (y2 - y1) div zig2-1 do
   Begin
           Line(x-largzigzag, y1 + i*zig2, x+largzigzag, y1 + i*zig2+zig);
           Line(x+largzigzag, y1 + i*zig2+zig, x-largzigzag,y1 + i*zig2+zig2);
   End;

End;


Procedure DrawClefDebutPortee(comp: TCompositionAvecPagination; iligne: integer;
                              x, portee:integer; clef: TClef);

const Tablature_TAB_Clef_Decalage_X = 40;

var zz: integer;
Begin
    if Comp = nil then
            MessageErreur('Comp = nil dans DrawClefDebutPortee !!');

    if Comp.Portee_Type[portee] = tpPorteeTablatureGuitare then
    Begin
        C.Brush.Style := bsClear;
        SetFontSize(11);
        C.Font.Style := [fsBold];
        TextOut(x + Tablature_TAB_Clef_Decalage_X, GetY(comp, iligne, portee, 4), 'T');
        TextOut(x + Tablature_TAB_Clef_Decalage_X, GetY(comp, iligne, portee, 1), 'A');
        TextOut(x + Tablature_TAB_Clef_Decalage_X, GetY(comp, iligne, portee, -2), 'B');
        C.Font.Style := [];
    End;

    if Comp.Portee_Type[portee] <> tpPortee5Lignes then
          exit;

    zz := ZoomPortee(portee);
    DrawBitmap(x, GetY(comp, iligne, portee, 0) - DecalageClefPortee[clef] * zz div ZoomMaxPrec,
              imgClefsPortees[clef], zz);


End;



Procedure DrawClefDebutPortee_TOUTESLESPORTEES(comp: TCompositionAvecPagination;
                              x, portee:integer; clef: TClef);
var zz: integer;
Begin
    if Comp = nil then
            MessageErreur('Comp = nil dans DrawClefDebutPortee_TOUTESLESPORTEES !!');

    if Comp.Portee_Type[portee] <> tpPortee5Lignes then
          exit;

    zz := ZoomPortee(portee);
    DrawBitmap(x, GetY_TOUTESLESPORTEES(comp, portee, 0) - DecalageClefPortee[clef] * zz div ZoomMaxPrec,
              imgClefsPortees[clef], zz);


End;

Procedure DrawClef(comp: TCompositionAvecPagination; iligne: integer;
                   x, portee:integer; clef: TClef);
var zz: integer;
Begin
      zz := ZoomPortee(portee);

      DrawBitmap(x, GetY(comp, iligne, portee, 0) - DecalageClefPortee[clef] * zz div ZoomMaxPrec,
                    imgClefs[clef], zz);


End;








Procedure DrawIndependantPause(comp: TComposition;
                               iligne: integer;
                               Duree: TRationnel;
                               x,
                               portee: integer);
var pos: TPosition;
    pausedessin, p, zp: integer;
Begin
   pos.portee := portee;
   pos.hauteur := 0;

   pausedessin := NumeroDessinPause(Duree);
   DrawPause(Comp, iligne, pausedessin, true, x, pos);


    zp := ZoomPortee(portee);
    for p := 1 to CombienPointDuree(Duree) do
          Cercle( x + imgPauses[pausedessin].Width *zp div ZoomParDefaut + p * nbpixlignentrepointduree* zp div ZoomMaxPrec,
                 GetY(comp, iligne, pos), rayonpointduree * zp div ZoomMaxPrec);
End;

Function DeltaXTonalite(tonalite: ShortInt): integer; overload;
Begin
    //préconditions
    VerifierTonalite(tonalite);
    
    result := abs(tonalite * ecartalteration);
End;



Function DeltaXTonalite(tonalite, anciennetonalite: ShortInt): integer; overload;
Begin
if tonalite * anciennetonalite < 0 then
       result := (abs(tonalite) + abs(anciennetonalite)) * ecartalteration
else
Begin
      if abs(tonalite) < abs(anciennetonalite) then
          result := (abs(anciennetonalite - tonalite) + abs(tonalite)) * ecartalteration
      else
          result := (abs((tonalite) * ecartalteration));
end;
End;




Function DeltaXTonalites(tonalites: TTonalites): integer; overload;
var i, max: integer;
Begin
max := 0;

for i := 0 to high(tonalites) do
      if max < DeltaXTonalite(tonalites[i]) then
              max := DeltaXTonalite(tonalites[i]);

result := max;
End;



Function DeltaXTonalites(tonalites, anciennestonalites: TTonalites): integer; overload;
var i, max: integer;
Begin
max := 0;

for i := 0 to high(tonalites) do
      if max < DeltaXTonalite(tonalites[i], anciennestonalites[i]) then
              max := DeltaXTonalite(tonalites[i], anciennestonalites[i]);

result := max;
End;


Procedure DrawTonalite(comp: TCompositionAvecPagination;
                       iligne: integer;
                       xdeb,
                       portee: integer;
                       clef: TClef;
                       tonalite,
                       anciennetonalite: ShortInt);

{position des altérations à la clé de sol}
const posaltclefsol: array[0..1 , 1..7] of Shortint
                           {0 = des dièses, 1 = des bémols}
                   = ((4, 1, 5, 2, -1, 3, 0),
                      (0, 3, -1, 2, -2, 1, -3));
     decalXTonaliteAlaCle = 100;
var i, decallageposdeclef: ShortInt;
    ind1, nbbecar: integer;
//    ch: char;
    alter: TAlteration;
    zp: integer;

        Function Ind1DieseBemol(signtonalite: integer): integer;
        Begin
            {un truc positif ou nul renvoit 0, un truc nég renvoit 1}

            if signtonalite >= 0 then
                  result := 0
            else
                    result := 1;
        End;


        Function DieseOuBemolALaCle(signtonalite: integer): TAlteration;
        Begin
            {un truc positif ou nul renvoit 0, un truc nég renvoit 1}

            if signtonalite >= 0 then
                  result := aDiese
            else
                  result := aBemol;
        End;



Begin
//préconditions
if comp <> nil then
Begin
    comp.VerifierIndiceLigne(iLigne, 'DrawTonalite');
    comp.VerifierIndicePortee(portee, 'DrawTonalite');
End;

VerifierTonalite(tonalite);

zp := ZoomPortee(portee);

if Clef = ClefFa then
    decallageposdeclef := -2
else
    decallageposdeclef := 0;


if tonalite * anciennetonalite < 0 then
Begin
       Ind1 := Ind1DieseBemol(anciennetonalite);
       for i := 1 to min(abs(anciennetonalite),7) do
          DrawAlteration(xdeb + decalXTonaliteAlaCle + (i-1) * ecartalteration,
                         GetY(comp,
                              iligne,
                              portee,
                              posaltclefsol[Ind1, i]+decallageposdeclef)-ydecaltextealteration,
                         aNormal,zp);


       inc(xdeb, abs(anciennetonalite * ecartalteration));

       {ch := CharDieseBemol(tonalite);
       Ind1 := Ind1DieseBemol(anciennetonalite);

       for i := 1 to min(abs(tonalite),7) do
             TextOut(xdeb + i * ecartalteration,
             GetY(comp, portee, posaltclefsol[Ind1, i]+decallageposdeclef)-ydecaltextealteration,
             ch);}

       alter := DieseOuBemolALaCle(tonalite);
       Ind1 := Ind1DieseBemol(anciennetonalite);

       for i := 1 to min(abs(tonalite),7) do
            DrawAlteration(xdeb + decalXTonaliteAlaCle + i * ecartalteration,
                           GetY(comp,
                                iligne,
                                portee,
                                posaltclefsol[Ind1, i]+decallageposdeclef),
                           alter,zp);

end
Else //tonalite et ancienne tonalite sont du ^m signe
Begin
      alter := DieseOuBemolALaCle(tonalite);

      if tonalite <> 0 then
           Ind1 := Ind1DieseBemol(tonalite)
      else
           Ind1 := Ind1DieseBemol(anciennetonalite);

      nbbecar := abs(anciennetonalite) - abs(tonalite);
      for i := 0 to nbbecar-1 do
            DrawAlteration(xdeb + decalXTonaliteAlaCle + i * ecartalteration,
                           GetY(comp,
                                iligne,
                                portee,
                                posaltclefsol[Ind1, abs(tonalite) + 1 + i]
                                     +decallageposdeclef)-ydecaltextealteration,
                           aNormal,zp);

      if nbbecar > 0 then
           inc(xdeb, nbbecar * ecartalteration);


      for i := 1 to min(abs(tonalite),7) do //le min(..,7) est une sécurité (cf. transposition d'une clarinette...)
             DrawAlteration(xdeb + decalXTonaliteAlaCle + i * ecartalteration,
                            GetY(comp,
                                 iligne,
                                 portee,
                                 posaltclefsol[Ind1, i]
                                    +decallageposdeclef)-ydecaltextealteration,
                            alter,zp);



End;



End;















end.

