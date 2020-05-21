unit MusicGraph_System;

interface


uses Windows, Graphics, MusicSystem, QSystem, Classes, Sysutils, FileSystem;


const MaxIndVoix = 1024;  //qu'est ce uqe ça fout là ?

      prec = 10;
      ZoomParDefaut = 100;
      ZoomMaxPrec = 100*prec;
      ZoomRefPortee = 100;

      Nepasafficherdutout = false;//////////////////////



type TDeviceType = (devEcran, devImprimante, devApercu, devEcranPasEdition);
     TCoordEcran = integer;
     TCoord = integer;
     TCoordEx = single;

     TPointEx = record
                       x, y: single;
     end;












var  factimprimantePourlesPolices: real = 12.0;
     {3 c'est la valeur par défaut...
       12 c'est avec pdf creator}

     CDevice: TDeviceType;


    C:TCanvas;

    CHeight: integer;
    pixxdeb, pixydeb: integer; //en pixel écran
    pixXorigin, pixyorigin:integer; //en pixel logique
    Zoom: integer;


    PrintInFile: boolean;
    CouleurDessin: TColor;

    BrushStyleCourant: TBrushStyle;
    DessinerOpaque: Boolean;




//Routine de "bas-niveau"
Function PointInRect(x, y:integer; r:TRect): Boolean;
Function ScrX(x: TCoordEx):integer;
Function ScrY(y: TCoordEx):integer;
Function ScrPoint(x, y: TCoordEx):TPoint;

Function RectPlus1(r: TRect): TRect;
Function ScrRect(r:TRect):TRect;
Function ScrRectPlus1(r:TRect):TRect;
Function ScrRectAO(r:TRect):TRect;

Function GetX(scrX: integer):TCoord;
Function GetY(scrY: integer):TCoord; overload;
Procedure Line(x1, y1, x2, y2: TCoord);

Procedure Rectangle(x1, y1, x2, y2: TCoord); overload;
Procedure Rectangle(r: TRect); overload;
Procedure FillRect(x1, y1, x2, y2: TCoord); overload;
Procedure FillRect(r: TRect); overload;

Procedure Ellipse(x1, y1, x2, y2: TCoord);

Procedure LineHorizontal(x1, x2, y: TCoord);
Procedure LineVertical(x, y1, y2: TCoord);
Procedure Cercle(cx, cy, r:TCoord);

Procedure SetFontSize(pts: integer);
Procedure SetFontSizeToMeasure(pts: integer);
Procedure SetGrosseurTrait(w: integer);
Procedure TextOut(x, y:TCoord; s: string);
Procedure Spline(x1, y1, x2, y2, x3, y3, x4, y4: single);



Procedure ChangerBrushStyle(newbstyle: TBrushStyle);
Procedure RechangerBrushSolid(coul: TColor);

Procedure DrawBitmapCentre(x, y: integer; b: TGraphic; zz: integer);


procedure DrawBitmap(x, y: integer; b: TGraphic; zz:integer);
procedure DrawGraphic(x1, y1, x2, y2: integer; img: TGraphic);




Procedure DessinerFiligrane;
Procedure DessinerNoir;
Procedure DessinerCouleur(color: TColor);

procedure MusicGraph_System_Trait_SansFond_Couleur(color: TColor);


procedure SetViewCourantPixDeb(pixx, pixy: integer);
procedure SetViewCourantPixDebModeImpression(pixx, pixy: integer);
procedure SetPixOrigin(x, y: integer);

procedure MusicGraph_Canvas_Set(Canvas: TCanvas);
procedure MusicGraph_Canvas_Lock;
procedure MusicGraph_Canvas_UnLock;
Function MusicGraph_Canvas_IsLocked: Boolean;














implementation


uses MusicWriter_Erreur {pour MessageErreur},
     MusicUser {IsEnTrainDimprimer};

const CouleurFiligrane = $888888;
      CouleurFiligraneFond = $C0C0C0;




var private_canvas_is_locked: integer = 0;



procedure MusicGraph_Canvas_Set(Canvas: TCanvas);
Begin
     if private_canvas_is_locked <> 0 then
         MessageErreur('impossible de changer de canvas, car on dessine dedans')
     else
         C := Canvas;
End;


procedure MusicGraph_Canvas_Lock;
Begin
    inc(private_canvas_is_locked);
End;

                 
procedure MusicGraph_Canvas_UnLock;
Begin
    dec(private_canvas_is_locked);

    if private_canvas_is_locked < 0 then
    Begin
        MessageErreur('MusicGraph_Canvas_UnLock en trop! on met private_canvas_is_locked à 0');
        private_canvas_is_locked := 0;
    End;
End;


Function MusicGraph_Canvas_IsLocked: Boolean;
Begin
    result := (private_canvas_is_locked > 0);
End;


procedure SetViewCourantPixDeb(pixx, pixy: integer);
Begin
    if CDevice = devImprimante then
           MessageErreur('SetViewCourantPixDeb : Le programme est en train de modifier des paramètres d''affichage' +
                         'qu''il ne devrait pas modifier vu qu''on est en train d''imprimer!')
    else
    Begin
        pixxdeb := pixx;
        pixydeb := pixy;
    End;
End;


procedure SetViewCourantPixDebModeImpression(pixx, pixy: integer);
Begin
    pixxdeb := pixx;
    pixydeb := pixy;
End;


procedure SetPixOrigin(x, y: integer);
Begin
    pixXorigin := x;
    pixYorigin := y;
End;







procedure DrawGraphic(x1, y1, x2, y2: integer; img: TGraphic);
Begin
      if Nepasafficherdutout then Exit;
      x1 := scrX(pixXorigin + x1);
      x2 := scrX(pixXorigin + x2);

      y1 := scrY(pixYorigin + y1);
      y2 := scrY(pixYorigin + y2);

      C.CopyMode := cmWhiteness;//cmBlackness;
      C.StretchDraw(Rect(x1, y1, x2, y2), img);
      C.CopyMode := cmSrcCopy;
End;





Procedure DrawBitmap(x, y: integer; b: TGraphic; zz: integer);
{zz = ZoomMaxPrec c'est le truc normal}
Begin

      if Nepasafficherdutout then Exit;
      if b = nil then
      Begin
          MessageErreur('Le programme tente d''afficher une image non chargée : il faut débuguer !!');
          Exit;
      End;
      y := scrY(pixYorigin + Y);

      if y > CHeight then
            exit
      else if y + b.Height * Zoom div ZoomParDefaut < 0 then
            exit;

      x := scrX(pixXorigin + X);

      C.CopyMode := cmWhiteness;//cmBlackness;
      C.StretchDraw(Rect(x, y, x + b.Width * Zoom * zz div (ZoomParDefaut*ZoomMaxPrec),
                               y + b.Height * Zoom * zz div (ZoomParDefaut*ZoomMaxPrec)), b);
      C.CopyMode := cmSrcCopy;
End;


Procedure DrawBitmapCentre(x, y: integer; b: TGraphic; zz: integer);
Begin
    y := scrY(pixYorigin + Y);

    if y > CHeight then
          exit
    else if y + b.Height * Zoom div ZoomParDefaut < 0 then
          exit;

    x := scrX(pixXorigin + X);

    C.CopyMode := cmWhiteness;//cmBlackness;
    C.StretchDraw(Rect(x - b.Width * Zoom * zz div (2*ZoomParDefaut*ZoomMaxPrec),
                       y - b.Height * Zoom * zz div (2*ZoomParDefaut*ZoomMaxPrec),
                       x + b.Width * Zoom * zz div (ZoomParDefaut*ZoomMaxPrec),
                       y + b.Height * Zoom * zz div (ZoomParDefaut*ZoomMaxPrec)), b);
    C.CopyMode := cmSrcCopy;

End;













Procedure RechangerBrushSolid(coul: TColor);
Begin
    {if bsSolid <> BrushStyleCourant then
    Begin}
           C.Brush.Style := bsSolid;
           C.Brush.Color := coul;
           {BrushStyleCourant := bsSolid;
    End;  }
End;




Procedure ChangerBrushStyle(newbstyle: TBrushStyle);
Begin
    {if newbstyle <> BrushStyleCourant then
    Begin    }
           C.Brush.Style := newbstyle;
           if newbstyle <> bsClear then
           C.Brush.Color := CouleurDessin;
    {       BrushStyleCourant := newbstyle;
    End; }
End;





Function PointInRect(x, y:integer; r:TRect): Boolean;
Begin
result := (r.left <= x) and (x <= r.right) and
                          (r.top <= y) and (y <= r.bottom);

End;






Function ScrX(x: TCoordEx):integer;
Begin
      result := round((x - pixxdeb) * Zoom / ZoomMaxPrec);
End;

Function ScrY(y: TCoordEx):integer;
Begin
      result := round((y - pixydeb) * Zoom / ZoomMaxPrec);
End;

Function ScrPoint(x, y: TCoordEx):TPoint;
Begin
     result := Point(ScrX(X), ScrY(Y));
End;


Function GetX(scrX: integer):TCoord;
Begin
       result := (scrX) * ZoomMaxPrec div Zoom  + pixxdeb;
End;


Function GetY(scrY: integer):TCoord; overload;
{à partir des coordonnées écrans, retrouve la coordonnée logique}
Begin
       result := (scrY) * ZoomMaxPrec div Zoom  + pixydeb;
End;



Function ScrRect(r:TRect):TRect;
var scrr: TRect;
Begin
  scrr.left := ScrX(r.left);
  scrr.top := ScrY(r.top);
  scrr.Right := ScrX(r.Right);
  scrr.Bottom := ScrY(r.Bottom);
  result := scrr;
End;


Function RectPlus1(r: TRect): TRect;
const eps = 3;

var scrr: TRect;
Begin
  scrr.left := r.left - eps;
  scrr.top := r.top- eps;
  scrr.Right := r.Right+ eps;
  scrr.Bottom := r.Bottom+ eps;
  result := scrr;

End;


Function ScrRectPlus1(r:TRect):TRect;
const eps = 30;

var scrr: TRect;
Begin
  scrr.left := ScrX(r.left) - eps;
  scrr.top := ScrY(r.top) - eps;
  scrr.Right := ScrX(r.Right) + eps;
  scrr.Bottom := ScrY(r.Bottom) + eps;
  result := scrr;
End;


Function ScrRectAO(r:TRect):TRect;
{AO = avec origin}
var scrr: TRect;
Begin
  scrr.left := ScrX(r.left + pixxorigin);
  scrr.top := ScrY(r.top + pixyorigin);
  scrr.Right := ScrX(r.Right + pixxorigin);
  scrr.Bottom := ScrY(r.Bottom + pixyorigin);
  result := scrr;
End;





Procedure Line(x1, y1, x2, y2: TCoord);
var xx1, xx2, yy1, yy2: TCoordEcran;
Begin
      if Nepasafficherdutout then Exit;
      xx1 := scrX(pixXorigin + x1);
      xx2 := scrX(pixXorigin + x2);
      yy1 := scrY(pixYorigin + y1);
      yy2 := scrY(pixYorigin + y2);
      C.MoveTo(xx1, yy1);
      C.LineTo(xx2, yy2);

End;


Procedure Rectangle(x1, y1, x2, y2: TCoord); overload;
var xx1, xx2, yy1, yy2: TCoordEcran;
Begin
      xx1 := scrX(pixXorigin + x1);
      xx2 := scrX(pixXorigin + x2);
      yy1 := scrY(pixYorigin + y1);
      yy2 := scrY(pixYorigin + y2);
      C.Rectangle(xx1, yy1, xx2, yy2);
End;


Procedure Ellipse(x1, y1, x2, y2: TCoord);
var xx1, xx2, yy1, yy2: TCoordEcran;
Begin
      xx1 := scrX(pixXorigin + x1);
      xx2 := scrX(pixXorigin + x2);
      yy1 := scrY(pixYorigin + y1);
      yy2 := scrY(pixYorigin + y2);
      C.Ellipse(xx1, yy1, xx2, yy2);
End;

Procedure FillRect(x1, y1, x2, y2: TCoord); overload;
var xx1, xx2, yy1, yy2: TCoordEcran;
Begin
      xx1 := scrX(pixXorigin + x1);
      xx2 := scrX(pixXorigin + x2);
      yy1 := scrY(pixYorigin + y1);
      yy2 := scrY(pixYorigin + y2);
      C.FillRect(Rect(xx1, yy1, xx2, yy2));
End;



Procedure Rectangle(r: TRect); overload;
Begin
      inc(r.Top, pixYorigin);
      inc(r.Bottom, pixYorigin);
      inc(r.Left, pixXorigin);
      inc(r.Right, pixXorigin);

      C.Rectangle(ScrRect(r));
End;


Procedure FillRect(r: TRect); overload;
Begin
      inc(r.Top, pixYorigin);
      inc(r.Bottom, pixYorigin);
      inc(r.Left, pixXorigin);
      inc(r.Right, pixXorigin);

      C.FillRect(ScrRect(r));
End;


Procedure LineHorizontal(x1, x2, y: TCoord);
var xx1, xx2, yy: TCoordEcran;
const xmax = 2000;
Begin
      yy := scrY(pixYorigin + Y);
      xx1 := scrX(pixXorigin + X1);

      if xx1 < 0 then xx1 := 0;

      if x2 = -1000 then //-1000 : codage du +inf
          xx2 := 2000
      else
      Begin
              xx2 := scrX(pixXorigin + x2);
              if (xx2 > xmax) and (CDevice = devEcran) then xx2 := xmax;
      End;

      C.MoveTo(xx1, yy);
      C.LineTo(xx2, yy);


End;


Procedure Spline(x1, y1, x2, y2, x3, y3, x4, y4: single);
var i:integer;
var P: array[0..3] of TPoint;
Begin
      for i := 0 to 6 do
      Begin
          P[0] := ScrPoint(pixXorigin + x1, pixYorigin + y1);
          P[1] := ScrPoint(pixXorigin + x2, pixYorigin + y2 - i * 2);
          P[2] := ScrPoint(pixXorigin + x3, pixYorigin + y3 - i * 2);
          P[3] := ScrPoint(pixXorigin + x4, pixYorigin + y4);
          C.PolyBezier(P);
      End;
End;



Procedure LineVertical(x, y1, y2: TCoord);
var xx, yy1, yy2: TCoordEcran;
const ymax = 2000;
Begin
      xx := scrX(pixxorigin + x);
      yy1 := scrY(pixyorigin + y1);
      yy2 := scrY(pixyorigin + y2);

      if not IsEnTrainDImprimer then
      Begin
       {si on est en train d'afficher à l'écran... on calme le jeu... et on limite
        la taille des traits}

        {rem : oui, si on imprime par contre, on ne fait pas ça... car c'est bcp plus précis}
          if yy1 < 0 then yy1 := 0;
          if yy2 > ymax then yy2 := ymax;
      End;
      
      C.MoveTo(xx, yy1);
      C.LineTo(xx, yy2);


End;

Procedure Cercle(cx, cy, r:TCoord);
Begin
     C.Ellipse(scrX(pixXorigin + cx - r), scrY(pixYorigin + cy - r),
               scrX(pixXorigin + cx + r), scrY(pixYorigin + cy + r));
End;




















Procedure SetFontSize(pts: integer);
Begin
    If (Cdevice = devImprimante) and not PrintInFile then
          C.Font.Size := round(pts * Zoom / (ZoomParDefaut * factimprimantePourlesPolices))
    else
          C.Font.Size := pts * Zoom div ZoomParDefaut;

End;

Procedure SetFontSizeToMeasure(pts: integer);
{on utilise cette procédure pour mesurer des tailles de textes avec TextWidth
 et TextHeight... cela équivaut en gros à un SetFontSize avec un Zoom grandeur
 réelle}
Begin
    If (Cdevice = devImprimante) and not PrintInFile then
          C.Font.Size := round(pts / factimprimantePourlesPolices)
    else
          C.Font.Size := pts;

End;


Procedure SetGrosseurTrait(w: integer);
Begin
    if w = 0 then
    Begin
        if cDevice = devImprimante then
            C.Pen.Width := 2
        else
            C.Pen.Width := 1;
    end
    else
        C.Pen.Width := w * Zoom div (ZoomMaxPrec);

End;



Procedure TextOut(x, y:TCoord; s: string);
Begin
     C.TextOut(ScrX(pixXorigin + X), ScrY(pixYorigin + Y), s);

End;









Procedure DessinerFiligrane;
Begin
  CouleurDessin := CouleurFiligraneFond;
  C.Pen.Color := CouleurFiligrane;
  C.Font.Color := CouleurFiligrane;
  RechangerBrushSolid(CouleurFiligraneFond);
  C.Pen.Style := psSolid;
End;


Procedure DessinerNoir;
Begin
CouleurDessin := 0;
C.Pen.Color := 0;
RechangerBrushSolid(0);
C.Pen.Style := psSolid;
End;


Procedure DessinerCouleur(color: TColor);
Begin
  CouleurDessin := color;
  C.Pen.Color := color;
  C.Font.Color := color;
  RechangerBrushSolid(color);
  C.Pen.Style := psSolid;
End;


procedure MusicGraph_System_Trait_SansFond_Couleur(color: TColor);
Begin
  CouleurDessin := color;
  C.Pen.Color := color;
  C.Font.Color := color;
  C.Brush.Style := bsClear;
  C.Pen.Style := psSolid;
End;

end.
