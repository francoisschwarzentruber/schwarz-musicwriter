unit MusicSystem_CompositionListeObjetsGraphiques;

interface

uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicHarmonie,

     MusicSystem_Composition_Portees_Liste,
     MusicSystem_CompositionBase,
     MusicSystem_CompositionLectureMIDI,
     MusicSystem_CompositionAvecPagination,

     Types;



type TTypeGraphicObjet = (tgZoneTexte, tgCrescendo, tgDeCrescendo, tgCourbe);


{Ce type modélise un point dans le document. Il est utile pour repérer des objets
 graphiques dans le document}
TPointInPartition = record
      iligne, imesure: integer;
      temps: TRationnel;
      pos: TPosition;

      x_indoc, y_indoc: integer; {+ coordonnées dans la mesure}


end;




TNuanceValeur = (nvPPPP, nvPPP, nvPP, nvP, nvMP, nvMF, nvF, nvFF, nvFFF, nvFFFF, nvRebus);

TGraphicObjet = class
private
    Function DrawSubCourbe(XinDoc, YIndoc: integer; afficher: Boolean): Boolean;

public
    typ: TTypeGraphicObjet;

    str: string;
    velocity_depart, velocity_fin: integer;


    Pts:array[0..2] of TPointInPartition;

    constructor ZoneTexteCreate(x_indoc, y_indoc: integer; texte: string);
    constructor NuanceCreate(x_indoc, y_indoc: integer; nuance: TNuanceValeur);

    procedure PosInPartition_CalculerMesuresTempsEtc(Composition: TCompositionAvecPagination);
    procedure PosInPartition_CalculerXYInDoc(Composition: TCompositionAvecPagination);
    procedure RenommerNumerosMesures(apartirde, quoiajouter: integer);
    Function GetRectangle: TRect;

    procedure Nuance_Set(nuance: TNuanceValeur);
    Procedure Draw;
    Function Points_DrawCercles: TRect;

    Function IsSousCurseur(XInDoc, YInDoc: integer): Boolean;
    Function IndicePointSousCurseur(XInDoc, YInDoc: integer): integer;

    procedure Translater(dx, dy: integer);

    Function IsCrescendoOrDecrescendo: Boolean;
    Function IsNuanceSimple: Boolean;

    Function NbPointsADefinir: integer;

    Procedure SaveOrLoad;

    procedure Crescendo_Set;
    procedure DeCrescendo_Set;


End;




PGraphicObjet = ^TGraphicObjet;


type TCompositionListeObjetsGraphiques = class(TCompositionAvecPagination)
protected
    private_GraphicObjets: array of TGraphicObjet;

private
    procedure VerifierIndiceObjetsGraphiques(var i: integer; mess: string);
    procedure RenommerNumerosMesures(apartirde, quoiajouter: integer);


public
    Function NbObjetsGraphiques: integer;
    procedure ObjetGraphique_Supprimer(indice: integer);
    Procedure ObjetGraphique_Ajouter(obj: TGraphicObjet);
    Function ObjetGraphique_SousCurseur_GetIndice(x_indoc, y_indoc: integer): integer;
    Function ObjetGraphique_Get(indice: integer): TGraphicObjet;

    Procedure Paginer(iligne, lignefin_apriori: integer;
                      optimisation_calculer_graphe_info_verticalite_notes: Boolean);

    procedure PaginerApartirMes(m: integer;
                                optimisation_calculer_graphe_info_verticalite_notes: Boolean);

    procedure PaginerLesMesuresEtApresSiBesoin(m: integer;
                                m2_apriori: integer;
                                optimisation_calculer_graphe_info_verticalite_notes: Boolean);



    procedure PaginerLaMesureEtApresSiBesoin(m: integer;
                              optimisation_calculer_graphe_info_verticalite_notes: Boolean);
                              

    procedure CalcTout(
                 optimisation_calculer_graphe_info_verticalite_notes: Boolean);

    procedure AddMesureVide(indice: integer);
    Function DelMesure(m: integer): Boolean;
    Procedure ObjetsGraphiques_Boucle;
    
end;




implementation

uses MusicGraph_System {pour SetFontSizeToMeasure},
     MusicGraph,
     MusicUser,
     MusicGraph_Portees,
     MusicWriter_Erreur;

//     TimerDebugger;




constructor TGraphicObjet.ZoneTexteCreate(x_indoc, y_indoc: integer; texte: string);
Begin
    typ := tgZoneTexte;

    Pts[0].x_indoc := x_indoc;
    Pts[0].y_indoc := Y_indoc;

    str := texte;
End;



constructor TGraphicObjet.NuanceCreate(x_indoc, y_indoc: integer; nuance: TNuanceValeur);
Begin
    typ := tgZoneTexte;

    Pts[0].x_indoc := x_indoc;
    Pts[0].y_indoc := Y_indoc;

    Nuance_Set(nuance);
End;



Procedure TGraphicObjet.SaveOrLoad;
var l: integer;
Begin

     FichierDo(typ, 4);
     FichierDoStr(str);

     FichierDoInt(velocity_depart);
     FichierDoInt(velocity_fin);

     FichierDoInt(l, 3);
     FichierDo(Pts, 3 * sizeof( TPointInPartition ) );


End;




procedure Integer_Echanger(var i, j: integer);
var t:integer;
Begin
    t := i;
    i := j;
    j := t;
End;


procedure TGraphicObjet.Crescendo_Set;
Begin
    Typ := tgCrescendo;

    If velocity_depart > velocity_fin then Integer_Echanger(velocity_depart, velocity_fin); 

End;


procedure TGraphicObjet.DeCrescendo_Set;
Begin
    Typ := tgDeCrescendo;

    If velocity_depart < velocity_fin then Integer_Echanger(velocity_depart, velocity_fin);
End;

Function TGraphicObjet.IsSousCurseur(XInDoc, YInDoc: integer): Boolean;
Begin
    case typ of
       tgCourbe:
           result := DrawSubCourbe(XinDoc, YInDoc, false);
       else
           result := PointInRect(XinDoc, YInDoc, GetRectangle);
    end;
End;


Function TGraphicObjet.IndicePointSousCurseur(XInDoc, YInDoc: integer): integer;
const prec_souscurseur = 70;
var i: integer;
Begin
    result := -1;

    for i := 0 to NbPointsADefinir - 1 do
        if (abs(pts[i].x_indoc - XInDoc) + abs(pts[i].y_indoc - YInDoc) < prec_souscurseur) then
            result := i;

End;


Function TGraphicObjet.IsNuanceSimple: Boolean;
Begin
    result := typ = tgZoneTexte;

End;


Function TGraphicObjet.IsCrescendoOrDecrescendo: Boolean;
Begin
    result := (typ = tgCrescendo) or (typ = tgDeCrescendo);

End;



Function TGraphicObjet.DrawSubCourbe(XinDoc, YIndoc: integer; afficher: Boolean): Boolean;
{Dessin des zones de texte etc...}
const prec = 50; //précision des courbes
      prec_souscurseur_courbe = 50;

Function ParaboleCoupe(sommet, chp, t: real): real;
Begin
     if abs(t - sommet) > chp then
          result := 0
     else
          result := -(t - sommet - chp) * (t - sommet + chp);
End;


var x, y, t, c0, c1, c2, s: real;
    i, j: integer;
    p: array[0..2] of TPoint;
    j_max: integer;

Begin
    result := false;

    for i := 0 to 2 do
        p[i] := Point(Pts[i].x_indoc, Pts[i].y_indoc);


       if afficher then
           j_max := effetplume
       else
           j_max := 0;

       for j := 0 to j_max do
       Begin
           if afficher then
           C.MoveTo(ScrX(P[0].x),
                    ScrY(P[0].y));

           if not afficher and (abs(P[0].x - XInDoc) + abs(P[0].y - YInDoc) < prec_souscurseur_courbe) then
           Begin
                result := true;
                exit;
           End;

           for i := 1 to prec do
                 Begin
                     t := i / prec;

                     {c0 := ParaboleCoupe(0,0.5,t); //sqr(1 - t);
                     c1 := ParaboleCoupe(0.5,0.5,t);
                     c2 := ParaboleCoupe(1,0.5,t); }

                     c0 := sqr(1 - t);
                     c1 := sqrt((1 - t) * t);
                     c2 := sqr(t);

                     s := c0 + c1 + c2;

                     x := (p[0].x * c0 +
                          p[2].x * c1 +
                          p[1].x * c2)
                                                / s;

                     y := (p[0].y * c0 +
                          (p[2].y - j) * c1 +
                          p[1].y * c2)
                                                / s;

                     if not afficher and (abs(x - XInDoc) + abs(y - YInDoc) < prec_souscurseur_courbe) then
                     Begin
                           result := true;
                           exit;
                     End;

                     if afficher then
                     C.LineTo(ScrX(x),
                              ScrY(y));
                 End;
       End;
End;



Procedure TGraphicObjet.Draw;


Begin

    case typ of
         tgZoneTexte:
         Begin
               SetFontSize(FontSizeZoneTexte);
               C.Font.Style := [fsBold, fsItalic];
               C.Brush.style := bsClear;
               TextOut(Pts[0].x_indoc, Pts[0].y_indoc, str);
               C.Brush.style := bsSolid;
         end;

         tgCourbe:
             DrawSubCourbe(0, 0, true);

         tgDeCrescendo:
            Begin
             SetGrosseurTrait(20);
             C.MoveTo(ScrX(Pts[0].x_indoc),
                      ScrY(Pts[0].y_indoc));

             C.LineTo(ScrX(Pts[1].x_indoc),
                      ScrY(
                         (Pts[0].y_indoc + Pts[1].y_indoc) div 2)
                     );

             C.LineTo(ScrX(Pts[0].x_indoc),
                      ScrY(Pts[1].y_indoc));
             SetGrosseurTrait(0);
            End;

         tgCrescendo:
            Begin
             SetGrosseurTrait(20);
             C.MoveTo(ScrX(Pts[1].x_indoc),
                      ScrY(Pts[1].y_indoc));

             C.LineTo(ScrX(Pts[0].x_indoc),
                      ScrY(
                         (Pts[0].y_indoc + Pts[1].y_indoc) div 2)
                     );

             C.LineTo(ScrX(Pts[1].x_indoc),
                      ScrY(Pts[0].y_indoc));
             SetGrosseurTrait(0);
            End;
    end;


End;



procedure VerifierVelocite(v: integer);
Begin
    if ((v <= 0) or (v > 127) ) then
        MessageErreur('Vélocité holà !!! t''es trop grande ou trop petite!' );
End;


procedure TGraphicObjet.Nuance_Set(nuance: TNuanceValeur);

        Function NuanceToStr(nuance : TNuanceValeur): string;
        Begin
           case nuance of
               nvPPPP: result := 'pppp';
               nvPPP: result := 'ppp';
               nvPP: result := 'pp';
               nvP: result := 'p';
               nvMP: result := 'mp';
               nvMF: result := 'mf';
               nvF: result := 'f';
               nvFF: result := 'ff';
               nvFFF: result := 'fff';
               nvFFFF: result := 'ffff';
               else
                  MessageErreur('cas non traité dans NuanceToStr');
           end;
        end;


        Function NuanceToVelocity(nuance : TNuanceValeur): integer;
        const velo_min = 32;
              velo_max = 127;
        Begin
           result := velo_min + integer(nuance) * (velo_max-velo_min) div integer(nvRebus);

           VerifierVelocite(result);
        end;



Begin
     typ := tgZoneTexte;
     str := NuanceToStr(nuance);
     velocity_depart := NuanceToVelocity(nuance);

End;

Function TGraphicObjet.GetRectangle: TRect;
Begin
     if typ = tgZoneTexte then
          result := Rect(Pts[0].x_indoc,
                         Pts[0].y_indoc,
                         Pts[0].x_indoc + C.TextWidth(str)*prec + enplusZoneTexte,
                         Pts[0].y_indoc + hauteurCaractereZoneTexte)

     else
          result := Rect(Pts[0].x_indoc,
                         Pts[0].y_indoc,
                         Pts[1].x_indoc,
                         Pts[1].y_indoc);
End;


Function TGraphicObjet.NbPointsADefinir: integer;
Begin
    case typ of
        tgZoneTexte: result := 1;
        tgCourbe : result := 3;
        else result := 2;
    end;
End;

Function TGraphicObjet.Points_DrawCercles: TRect;
var i: integer;
Begin
   for i := 0 to NbPointsADefinir - 1 do
       Cercle(Pts[i].x_indoc, Pts[i].y_indoc, RayonCerclePointDessinCourbe);
End;



procedure TGraphicObjet.Translater(dx, dy: integer);
var i: integer;
Begin
   for i := 0 to 2 do
       Begin
           inc(pts[i].x_indoc, dx);
           inc(pts[i].y_indoc, dy);
       End;

End;


procedure TGraphicObjet.RenommerNumerosMesures(apartirde, quoiajouter: integer);

    procedure RenommerMesure(var m: integer);
    Begin
         if m >= apartirde then
             inc(m, quoiajouter);
    End;

    var i: integer;

Begin
    for i := 0 to 2 do
        RenommerMesure(pts[i].imesure);
End;

procedure TGraphicObjet.PosInPartition_CalculerMesuresTempsEtc(Composition: TCompositionAvecPagination);

 procedure Point_CalculerMesuresTempsEtc(var p: TPointInPartition);
 var x, y: integer;
 Begin
     x := p.x_indoc;
     y := p.y_indoc;

     if Composition.FindMesure2(x, y, p.iligne, p.imesure) then
     Begin
         p.temps := Composition.GetMesure(p.imesure).TempsAX(x);
         GetPosition(y, Composition, p.iligne, p.pos);
     End
     else
     Begin
         p.imesure := 0;
         p.iligne := 0;
         p.pos.portee := 0;
         p.pos.hauteur := 0;
     End;
 End;
 const ecart = 100;
 var i:integer;
 
Begin
   if pts[0].x_indoc > pts[1].x_indoc then
      pts[1].x_indoc := pts[0].x_indoc + ecart;

   if pts[0].y_indoc > pts[1].y_indoc then
      pts[1].y_indoc := pts[0].y_indoc + ecart;

   for i := 0 to 2 do
       Point_CalculerMesuresTempsEtc(pts[i]);
End;





procedure TGraphicObjet.PosInPartition_CalculerXYInDoc(Composition: TCompositionAvecPagination);
 procedure Point_CalculerXYInDoc(var p: TPointInPartition);
 var x, y: integer;
 Begin
     VerifierRationnel(p.temps, 'Point_CalculerXYInDoc');

     x := Composition.GetMesure(p.imesure).XATemps(p.temps);
     y := GetY(Composition, p.iligne, p.pos);

     inc(x, Composition.Mesure_XGauche(p.imesure));
     inc(y, Composition.Ligne_YHaut(p.iligne));

     p.x_indoc := x;
     p.y_indoc := y;
 End;

 var i:integer;
 
Begin
   for i := 0 to 2 do
       Point_CalculerXYInDoc(pts[i]);

End;




procedure TCompositionListeObjetsGraphiques.VerifierIndiceObjetsGraphiques(var i: integer;
                                                                                mess: string);
Begin
    if not ((0 <= i) and (i <= high(private_GraphicObjets))) then
    Begin
         MessageErreur('problème d''indice pour accéder aux objets graphiques ' + mess);
         i := 0;
         
    End;
    
End;


Function TCompositionListeObjetsGraphiques.NbObjetsGraphiques: integer;
Begin
    result := length(private_GraphicObjets);
End;



procedure TCompositionListeObjetsGraphiques.RenommerNumerosMesures(apartirde, quoiajouter: integer);
    var i: integer;

Begin
    for i := 0 to high(private_GraphicObjets) do
        private_GraphicObjets[i].RenommerNumerosMesures(apartirde, quoiajouter);
End;



Procedure TCompositionListeObjetsGraphiques.ObjetGraphique_Supprimer(indice: integer);
var h, i:integer;
Begin
    VerifierIndiceObjetsGraphiques(indice, 'ObjetGraphique_Supprimer');

    h := high(private_GraphicObjets);
    For i := indice to h-1 do
        private_GraphicObjets[i] := private_GraphicObjets[i+1];

    setlength(private_GraphicObjets, h);

End;


Procedure TCompositionListeObjetsGraphiques.ObjetGraphique_Ajouter(obj: TGraphicObjet);
var l: integer;

Begin
      l := length(private_GraphicObjets);
      setlength(private_GraphicObjets, l+1);

      obj.PosInPartition_CalculerMesuresTempsEtc(self);
      private_GraphicObjets[l] := obj;

      ObjetsGraphiques_Boucle;

End;



Function TCompositionListeObjetsGraphiques.ObjetGraphique_Get(indice: integer): TGraphicObjet;
Begin
    VerifierIndiceObjetsGraphiques(indice, 'ObjetGraphique_Get');

    result := private_GraphicObjets[indice]; 
End;




Function TCompositionListeObjetsGraphiques.ObjetGraphique_SousCurseur_GetIndice(x_indoc, y_indoc: integer): integer;
var i: integer;
    b: Boolean;
    
Begin
{m désigne la mesure dans lequel se trouve l'objet}
     result := -1;
     
     SetFontSizeToMeasure(FontSizeZoneTexte);
     
     for i := 0 to high(private_GraphicObjets) do
         if private_GraphicObjets[i].IsSousCurseur(x_indoc, y_indoc) then
           Begin
                result := i;
                exit;
           End;

End;




Procedure TCompositionListeObjetsGraphiques.Paginer(iligne, lignefin_apriori: integer;
                                          optimisation_calculer_graphe_info_verticalite_notes: Boolean);
var i: integer;


     procedure ELMusicaux_ListeChainee_MettreAJourPointeurs;
     var m, v, i, v_last: integer;
     Begin
          For m := 0 to high(Mesures) do
          With Mesures[m] do
                 for v := 0 to high(Voix) do
                 With Voix[v] do
                 Begin
                     if high(ElMusicaux) >= 0 then
                     if m = 0 then
                          ElMusicaux[0].elementmusical_precedent := nil
                     else
                     Begin
                          v_last := Mesures[m-1].VoixNumInd(N_Voix);

                          if v_last = -1 then
                              ElMusicaux[0].elementmusical_precedent := nil
                          else
                          Begin
                             if Mesures[m-1].Voix[v_last].IsVide then
                                ElMusicaux[0].elementmusical_precedent := nil
                             else
                                   ElMusicaux[0].elementmusical_precedent :=
                                      Mesures[m-1].Voix[v_last].DernierElementMusical_Get;
                          End;
                     End;

                     for i := 1 to high(ElMusicaux) do
                     Begin
                         ElMusicaux[i].elementmusical_precedent := ElMusicaux[i-1];
                     End;
                 End;


     End;


Begin
     Paroles_CalculerTout;

     ELMusicaux_ListeChainee_MettreAJourPointeurs;
     {j'ai mis un TimerDebugger_FinEtape('Paroles_CalculerTout')
      et j'ai vérifié que Paroles_CalculerTout ne prend vraiment,
      mais alors !! vraiment pas beaucoup de temps !
      (0 ms)}

     inherited Paginer(iligne, lignefin_apriori,
                       optimisation_calculer_graphe_info_verticalite_notes);

     for i := 0 to high(private_GraphicObjets) do
             private_GraphicObjets[i].PosInPartition_CalculerXYInDoc(self);
End;








Procedure TCompositionListeObjetsGraphiques.ObjetsGraphiques_Boucle;
var i, j: integer;
    tmp: TGraphicObjet;

    Function IsO1InfO2(o1, o2: TGraphicObjet): Boolean;
    var p1, p2: TPointInPartition;
    Begin
        p1:= o1.pts[0];
        p2:= o2.pts[0];

        result := (p1.imesure < p2.imesure) or
                  ((p1.imesure = p2.imesure) and (IsQ1InfQ2(p1.temps, p2.temps)));
    End;

    
Begin

    for i := 0 to high(private_GraphicObjets) do
         for j := i+1 to high(private_GraphicObjets) do
               if IsO1InfO2(private_GraphicObjets[j], private_GraphicObjets[i]) then
                Begin
                    tmp := private_GraphicObjets[j];
                    private_GraphicObjets[j] := private_GraphicObjets[i];
                    private_GraphicObjets[i] := tmp;
                End;    
End;






procedure TCompositionListeObjetsGraphiques.PaginerApartirMes(m: integer;
                        optimisation_calculer_graphe_info_verticalite_notes: Boolean);
{on pagine à partir d'une certaine mesure}
Begin
    if m <= 0 then
         Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN,
                 optimisation_calculer_graphe_info_verticalite_notes)
    else
         Paginer(LigneAvecMes(m), PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN,
                 optimisation_calculer_graphe_info_verticalite_notes);
End;






procedure TCompositionListeObjetsGraphiques.PaginerLesMesuresEtApresSiBesoin(m: integer;
                                m2_apriori: integer;
                                optimisation_calculer_graphe_info_verticalite_notes: Boolean);
Begin
         Paginer(LigneAvecMes(m), LigneAvecMes(m2_apriori),
                 optimisation_calculer_graphe_info_verticalite_notes);
End;




 procedure TCompositionListeObjetsGraphiques.PaginerLaMesureEtApresSiBesoin(m: integer;
                              optimisation_calculer_graphe_info_verticalite_notes: Boolean);
 var l: integer;

 Begin
       l := LigneAvecMes(m);
       Paginer(l, l+1,
               optimisation_calculer_graphe_info_verticalite_notes);
 End;


procedure TCompositionListeObjetsGraphiques.CalcTout(
                       optimisation_calculer_graphe_info_verticalite_notes: boolean);
Begin
      Paginer(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN,
              optimisation_calculer_graphe_info_verticalite_notes);
end;




procedure TCompositionListeObjetsGraphiques.AddMesureVide(indice: integer);
var i: integer;

Begin
    inherited AddMesureVide(indice);

    RenommerNumerosMesures(indice, 1);
End;


Function TCompositionListeObjetsGraphiques.DelMesure(m: integer): Boolean;
var i: integer;

Begin
    result := inherited DelMesure(m);

    RenommerNumerosMesures(m, -1);
End;

end.
