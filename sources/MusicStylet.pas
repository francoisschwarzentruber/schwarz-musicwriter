unit MusicStylet;

interface

uses Windows, Classes,

     MusicSystem_Composition,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_Types {pour TPosition},
     MusicSystem_Constantes {pour as1_Pique},
     MusicSystem_ElMusical,

     MusicUser, MusicGraph, QSystem, Math;



const MusicStylet_Couleur = $888800;




Procedure MusicStylet_Points_Add(x, y: integer);
{ajoute un point}

Procedure MusicStylet_Points_Reset;
{détruit tous les points entrés.. (par ex, on recommence une saisie}

Function MusicStylet_Traiter(Comp: TComposition; VoixSelectionnee: integer): Boolean;
{traiter les points enregistrés... tente de reconnaitre qch}

Procedure MusicStylet_Points_Informer;

Function MusicStylet_Stylet_AEteUtilise: Boolean;
{est ce qu'actuellement, la liste des points est assez remplie pour dire que
 l'utilisateur utilise le stylet ?}


Function Music_Stylet_Points_Precedent_Get: TPoint;
{renvoie le point précédent (pratique pour afficher}




















implementation

uses Main, MusicGraph_System {pour PointInRect},
     MusicGraph_Portees {pour GetY(...)},
     Cancellation,
     MusicWriter_Erreur,
     SysUtils {pour inttostr},
     MusicUser_PlusieursDocuments;


type
TVector = record
              l, teta: real;
          end;




TStyletActionType = (satRien,
                     satInsererBarreMesure,
                     satAjouterPointDuree,
                     satAjouterPointPique,
                     satDiviserPar2Duree,
                     satInsererSoupir,
                     satInsererDemiSoupir,
                     satTransformerSoupirEnDemiSoupir
                     );

TStyletAction = record
    typ: TStyletActionType;

    m: integer;
    temps: TRationnel;
    el_mus_indice, el_mus_indice1, el_mus_indice2: integer;
    pos: TPosition;

end;

const
      NbPointsMinPourDireQueLeStyletEstUtilise = 2;



var StyletPts: array of TPoint;
    Vectors: array of TVector;





Function Music_Stylet_Points_Precedent_Get: TPoint;
Begin
    result := StyletPts[max(0, high(StyletPts) - 1)]; 
End;


    
Procedure MusicStylet_Points_Add(x, y: integer);
var l:integer;
Begin
    l := length(StyletPts);
    setlength(StyletPts, l+1);
    StyletPts[l] := Point(x, y);
End;



Procedure MusicStylet_Points_Reset;
Begin
   setlength(StyletPts, 0);
   setlength(Vectors,0);
End;




Function isTraitVertical: Boolean;
const prec = 320;
var i:integer;

Begin
    result := true;
    for i := 0 to high(StyletPts) do
           if abs(StyletPts[i].x - StyletPts[0].x) > prec then
           Begin
               result := false;
               exit;

           End;


End;




Function TresTresProche(a, b:integer): Boolean;
const prec = 80;
Begin
     result := abs(a - b) < prec;
End;


Function TresProche(a, b:real): Boolean;
const prec = 160;
Begin
     result := abs(a - b) < prec;
End;


Function Proche(a, b:real): Boolean;
const prec = 320;
Begin
     result := abs(a - b) < prec;
End;


Function ProcheApprox(a, b:real): Boolean;
const prec = 640;
Begin
     result := abs(a - b) < prec;
End;




Function IsAngleProcheP(r1, r2, seuilang: real):Boolean;
Begin
    result := false;

    r1 := r2 - r1;

    if (abs(r1) < seuilang) or (abs(r1 - 2*PI) < seuilang) or (abs(r1 + 2*PI) < seuilang) then
           result := true;

End;

Function IsAngleProche(r1, r2: real):Boolean;
Begin
result := IsAngleProcheP(r1, r2, 0.3);

End;

Function IsAngleTresProche(r1, r2: real):Boolean;
Begin
result := IsAngleProcheP(r1, r2, 0.2);

End;


Function IsAngleQuasiPareil(r1, r2: real):Boolean;
Begin
result := IsAngleProcheP(r1, r2, 0.2);

End;


Function IsAngleIn(r1, rmin, rmax: real): Boolean;
Begin
    result := (r1 >= rmin) and (r1 <= rmax);
End;

Function TrouverIndiceElQueue(V: TVoix; x, y: integer; var id: integer): Boolean;
var i:integer;
Begin
result := false;
for i := 0 to high(V.ElMusicaux) do
      if not V.Elmusicaux[i].IsSilence then
      Begin
          if TresTresProche(V.Elmusicaux[i].pixx, x) and
             TresProche(V.Elmusicaux[i].YExtremiteQueue, y) then
          Begin
                id := i;
                result := true;
          End;
      End;


End;


Procedure AjouterVector(l, teta: real);
var i: integer;
Begin
i := high(Vectors);
if i > -1 then
Begin
     if IsAngleQuasiPareil(Vectors[i].teta,teta) then
     Begin
              Vectors[i].l := Vectors[i].l + l;
              exit;
     End;

End;

i := length(Vectors);

Setlength(Vectors, i+1);
Vectors[i].l := l;
Vectors[i].teta := teta;

End;

Procedure TraiterVecteur;
const precteta = 0.3;
      seuilL = 50;

var tetasum, norme: real;
    i,j,k: integer;
    a: array of real;
    flop: Boolean;
Begin
      setlength(Vectors, 0);

      setlength(a, length(StyletPts));

      j := 0;
      tetasum := 0;
      for i := 0 to high(StyletPts) do
      Begin
          a[i] := arctan2(StyletPts[i].y - StyletPts[j].y,
                          StyletPts[i].x - StyletPts[j].x);
          tetasum := tetasum + a[i];
          flop := false;
          for k := j to i-1 do
                if not IsAngleTresProche(a[i], a[k]) then
                       flop := true;

          if i = high(StyletPts) then
               flop := true;
          if flop then
          Begin
              norme := sqrt(sqr(StyletPts[i].x - StyletPts[j].x) +
                            sqr(StyletPts[i].y - StyletPts[j].y));

              if norme > seuilL then
                    AjouterVector(norme, tetasum / (i - j){a[i]});

              j := i;
              tetasum := 0;

          End;
      End;





End;


Function TacheDeRayon(r: integer): Boolean;
var sx, sy, i: integer;
Begin
   if length(StyletPts) <= 5 then //2 traits ne peuvent faire une tâche
   Begin
         result := false;
         exit;
   End;

   sx := 0;
   sy := 0;
   for i := 0 to high(StyletPts) do
   Begin
           inc(sx, StyletPts[i].x);
           inc(sy, StyletPts[i].y);
   End;
   sx := sx div length(StyletPts);
   sy := sy div length(StyletPts);

   r := sqr(r);

   result := true;

   for i := 0 to high(StyletPts) do
           if sqr(StyletPts[i].x - sx) + sqr(StyletPts[i].y - sy) > r then
                   result := false;

End;



Function Is_PauseEnFormeAngleDroit(el: TElMusical): Boolean;
Begin
    result := el.IsSilence and (IsQEGal(el.Duree_Get, Qel(1,2)) or
                              IsQEGal(el.Duree_Get, Qel(3,4)) or
                              IsQEGal(el.Duree_Get, Qel(1,4)) or
                              IsQEGal(el.Duree_Get, Qel(3,8)));
End;



Function MusicStylet_Stylet_AEteUtilise: Boolean;
Begin
    result := (high(StyletPts) > NbPointsMinPourDireQueLeStyletEstUtilise);
End;










Function MusicStylet_Deviner(Comp: TComposition; VoixSelectionnee: integer): TStyletAction;
{A partir des points recueillis dans le tableau StyletPts, essaie de regarder
 si le gribouilli dessiné représente qch

 revoie vrai ssi le programme a su interprêter le gribouilli}
 
var x1, y1, x2, y2, yh, yb, i, i1, i2: integer;
    l1, l2, m1, m2: integer;
    V: TVoix;
    pos: TPosition;
    temps: TRAtionnel;
    yab1, yab2: Boolean;

    Label FinTraitement;

    
Begin

      Comp := actchild.Composition;
      result.typ := satRien;

      if high(StyletPts) <= 0 then
          Exit;

      x1 := StyletPts[0].x;
      y1 := StyletPts[0].y;
      x2 := StyletPts[high(StyletPts)].x;
      y2 := StyletPts[high(StyletPts)].y;

      Comp.FindMesure2(x1,y1,l1, m1);
      Comp.FindMesure2(x2,y2,l2, m2);

      if (l1 = -1) or (l2 = -1) then
         Exit;

      yh := GetY(Comp, l1, 0,4);
      yb := GetY(Comp, l1, Comp.NbPortees - 1, -4);
      {yh et hb servent pour voir si on a tracé un train de mesure...}

      if TacheDeRayon(40) and Comp.IsIndiceMesureValide(m1) then
      With Comp.GetMesure(m1).VoixNum(VoixSelectionnee) do
      Begin
            FindElMusicalApres(x1, i);

            if i > 0 then
              with Elmusicaux[i-1] do
              Begin
                  if ((x1 - pixx) < 120) then
                  Begin //point de durée
                       result.typ := satAjouterPointDuree;
                       result.m := m1;
                       result.el_mus_indice := i-1;
                       exit;
                  End;

              End;

            if i <= high(Elmusicaux) then
            Begin                                                              //piquée
                  if abs((x1 - Elmusicaux[i].pixx)) < 40 then
                  Begin
                       result.typ := satAjouterPointPique;
                       result.m := m1;
                       result.el_mus_indice := i;
                       exit;


                  End;


            End;



      End //Fin With 
      else
      if isTraitVertical and Proche(y1, yh) and ProcheApprox(y2, yb) and not Proche((y2-y1),0) then
      Begin

          {actchild.Cancellation.PushMiniEtapeAAnnuler(taAjouterMes, m1+1);
          actchild.Cancellation.PushNvEtapeAAnnuler('Ajout d''une mesure au stylet');
          Comp.AddMesureVide(m1+1);
          Comp.PaginerApartirMes(m1+1);
          result := true;       }
          if not Comp.IsIndiceMesureValide(m1) then
               m1 := Comp.NbMesures - 1;

          temps := QDiff(Comp.GetMesure(m1).TempsAX(x1), Qel(1));

          {rem : oui x1 est déjà les coordonnées dans la mesure m1}

          result.typ := satInsererBarreMesure;
          result.m := m1;
          result.temps := temps;
      End
      else if (m1 = m2) and Comp.IsIndiceMesureValide(m1) then
      Begin
          V := Comp.GetMesure(m1).VoixNum(VoixSelectionnee);

          yab1 := TrouverIndiceElQueue(V, x1, y1, i1);
          yab2 := TrouverIndiceElQueue(V, x2, y2, i2);
    
          if yab1 and yab2 then
          Begin
                     result.typ := satDiviserPar2Duree;
                     result.m := m1;
                     result.el_mus_indice1 := i1;
                     result.el_mus_indice2 := i2;

          End
          else if yab1 then
          Begin
                   result.typ := satDiviserPar2Duree;
                   result.m := m1;
                   result.el_mus_indice1 := i1;
                   result.el_mus_indice2 := i1;

          end
          else if V.FindElMusicalApres(x1, i) then
          Begin
              if i <= high(V.ElMusicaux) then
              With V.ElMusicaux[i] do 
                 if PointInRect(x1, y1,pixRect) and Is_PauseEnFormeAngleDroit(V.ElMusicaux[i]) then
                 Begin
                      result.typ := satTransformerSoupirEnDemiSoupir;
                      result.m := m1;
                      result.el_mus_indice := i;

                 End;

          End
          else
          Begin
              TraiterVecteur;

            if (length(Vectors) = 2) then
             Begin
               if Proche(Vectors[0].l, 160) and
                  IsAngleProche(Vectors[0].teta, 0) and
                  Proche(Vectors[1].l, 160) and
                  IsAngleIn(Vectors[1].teta, PI/2, PI) then
               Begin
                           GetPosition(y1, Comp, l1, pos);

                           result.typ := satInsererDemiSoupir;
                           result.m := m1;
                           result.el_mus_indice := i;
                           result.pos := pos;
               End;

            End;

            if (length(Vectors) <= 2) and (length(Vectors) >= 1) then
             Begin
               if Proche(Vectors[0].l, 160) and
                  IsAngleProche(Vectors[0].teta, PI/2- PI/8) then
               Begin
                          V.FindElMusicalApres(x1, i);
                          GetPosition(y1, Comp, l1, pos);

                           result.typ := satInsererSoupir;
                           result.m := m1;
                           result.el_mus_indice := i;
                           result.pos := pos;
               End;

            End



          End;
      End;


End;





procedure MusicStylet_Points_Informer;
var Comp: TComposition;
var sa: TStyletAction;
Begin
    Comp :=  actchild.Composition;
    sa := MusicStylet_Deviner(Comp, actchild.Curseur.GetiVoixSelectionnee);

    if sa.typ = satRien then
         Exit;


    case sa.typ of
         satInsererBarreMesure:
         Begin
               MusicGraph_Canvas_Set(actchild.Canvas);
               Comp.SetOriginMesure(sa.m);
               DrawBar(Comp.GetMesure(sa.m).X_Entre_ATemps(sa.temps),
                       Comp,
                       Comp.LigneAvecMes(sa.m));

         End;
    End;
End;




Function MusicStylet_Traiter(Comp: TComposition; VoixSelectionnee: integer): Boolean;
{A partir des points recueillis dans le tableau StyletPts, essaie de regarder
 si le gribouilli dessiné représente qch

 revoie vrai ssi le programme a su interprêter le gribouilli}
 
var sa: TStyletAction;
    i: integer;
    Label FinTraitement;

    
Begin
    Comp := actchild.Composition;
    sa := MusicStylet_Deviner(Comp, VoixSelectionnee);

    if sa.typ = satRien then
    Begin
         result := false;
         Exit;
    End;

    result := true;


    case sa.typ of
         satInsererBarreMesure:
         Begin
               Comp.I_BarreDeMesure_Ajouter(sa.m, sa.temps, ' au stylet');
               actchild.CurseurEtc_Ajuster_EnCasDe_Ajout_MesureEtc;
         End;
         satAjouterPointDuree:
         Begin
               With Comp.GetMesure(sa.m).VoixNum(VoixSelectionnee).
                                  ElMusicaux[sa.el_mus_indice] do
               Duree_Set(QAdd(Duree_Get, QMul(Duree_Get, Qel(1,2))));
         End;
         satAjouterPointPique:
         Begin
              Comp.GetMesure(sa.m).VoixNum(VoixSelectionnee).
                                  ElMusicaux[sa.el_mus_indice].
                             SetAttrib(as1_Pique, true);
         End;
         satDiviserPar2Duree:
         Begin
               actchild.Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, sa.m);
               actchild.Composition.Cancellation_Etape_Ajouter_FinDescription('Diviser la durée de notes par 2, au stylet',
                                                                               'mesure ' + inttostr(sa.m + 1),
                                                                               VoixSelectionnee);
               With Comp.GetMesure(sa.m).VoixNum(VoixSelectionnee) do
               for i := sa.el_mus_indice1 to sa.el_mus_indice2 do
                  With ElMusicaux[i] do Duree_Set(QDiv2(Duree_Get));
         End;
         satInsererSoupir:
         Begin
                actchild.Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, sa.m);
               actchild.Composition.Cancellation_Etape_Ajouter_FinDescription('Ajouter une soupir au stylet',
                                                                              'mesure ' + inttostr(sa.m),
                                                                              VoixSelectionnee);

               With Comp.GetMesure(sa.m).VoixNum(VoixSelectionnee) do
                        AddElMusical(sa.el_mus_indice,
                        CreerElMusicalPause(Qel(1),sa.pos.portee));

         End;
         satInsererDemiSoupir:
         Begin
               actchild.Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, sa.m);
               actchild.Composition.Cancellation_Etape_Ajouter_FinDescription('Ajouter une demi-soupir au stylet',
                                                                                'mesure ' + inttostr(sa.m),
                                                                              VoixSelectionnee);

               With Comp.GetMesure(sa.m).VoixNum(VoixSelectionnee) do
                        AddElMusical(sa.el_mus_indice,
                        CreerElMusicalPause(Qel(1,2),sa.pos.portee));
         End;
         satTransformerSoupirEnDemiSoupir:
         Begin

                actchild.Composition.Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, sa.m);
                actchild.Composition.Cancellation_Etape_Ajouter_FinDescription('Transformer demi-soupir en quart de soupir au stylet',
                                                                                'mesure ' + inttostr(sa.m),
                                                                              VoixSelectionnee);
                With Comp.GetMesure(sa.m).VoixNum(VoixSelectionnee) do
                With ElMusicaux[sa.el_mus_indice] do
                     Duree_Set(QDiv2(Duree_Get));
         End;
         else
                 MessageErreur('MusicStylet_Traiter : erreur de cas');
    end;




    Comp.PaginerApartirMes(sa.m, true);



End;







end.
