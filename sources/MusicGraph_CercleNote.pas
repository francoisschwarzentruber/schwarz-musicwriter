unit MusicGraph_CercleNote;

interface

uses MusicGraph_System;

var NoteEnEllipse: Boolean = true;
    rayonnotes: array[0..1] of integer = (45, 25);


Procedure MusicGraph_CercleNote_Init;
Procedure CercleNote_Draw(cx, cy:TCoord; taille: integer; zp: integer);
procedure CercleNote_Duree_Approximative_Draw(cx, cy:TCoord; xfin: TCoord; taille: integer; zp: integer);
procedure Trainee_Draw(cx, cy:TCoord; xfin: TCoord; taille: integer; zp: integer);

implementation


uses Types {pour TPoint}, Classes, Graphics, MusicGraph_Images,
     MusicGraph_Portees {nblign};
const {plus ce nombre est grand, plus l'affichage des notes est précis (et lent)
        rem : histoire de fixer les idées :
              si on affecte 100, ça rame pas
              si on affecte 1000, ça rame mais rien de catastrophique !}
      nbcerclepts = 12;


      //paramètre de pour tracer l'ellipse d'une note
      drayoncercle = 1;
      angledecal = 0.4;


var      
    cerclepts: array[0..nbcerclepts] of TPoint;
    cercleptsstd: array[0..1, 0..nbcerclepts] of TPointEx;





    
Procedure MusicGraph_CercleNote_Init;
{initialisation de l'unité MusicGraph_CercleNote :
 s'occupe de créer le tableau cercleptsstd qui sert à dessiner des notes}
var i, t: integer;
    x, y, xx, yy: real;
    angle: real;
Begin
for i := 0 to 1 do
    for t := 0 to nbcerclepts do
      Begin
           angle := 2 * PI * t / nbcerclepts;
           x := rayonnotes[i] * cos(angle);
           y := 0.6*rayonnotes[i] * sin(angle);
           xx := x * cos(angledecal) + y * sin(angledecal);
           yy := -x * sin(angledecal) + y * cos(angledecal);
           cercleptsstd[i][t].x := xx;
           cercleptsstd[i][t].y := yy;

      end;

End;




procedure CercleNote_Duree_Approximative_Draw(cx, cy:TCoord; xfin: TCoord; taille: integer; zp: integer);
var cercle_note_approximative: array[0..4] of TPoint;
    r: single;

Begin
     r := zp * nbpixlign / ZoomMaxPrec;

     cercle_note_approximative[0] :=
        ScrPoint(pixXorigin + cx - r,
                 pixYorigin + cy);

     cercle_note_approximative[1] :=
        ScrPoint(pixXorigin + cx,
                 pixYorigin + cy - r);

     cercle_note_approximative[2] :=
        ScrPoint(pixXorigin + cx + r,
                 pixYorigin + cy);

     cercle_note_approximative[3] :=
        ScrPoint(pixXorigin + cx,
                 pixYorigin + cy + r);

     cercle_note_approximative[4] := cercle_note_approximative[0];

     

     C.PolyLine(cercle_note_approximative);




End;




procedure Trainee_Draw(cx, cy:TCoord; xfin: TCoord; taille: integer; zp: integer);
var r: single;

    x, decalx: single;
    signe: integer;
Begin
     //Trainée
     //C.Pen.Color := Trainee_Couleur;
     r := zp * nbpixlign / ZoomMaxPrec;
     cx := cx + Round(r);
     x := cx;
     signe := 1;
     decalx := 1.5*r;
     r := r / 4;
     
     C.moveto(ScrX(pixXorigin + cx), ScrY(pixYorigin + cy));
     x := x + decalx;
     while x < xfin do
     Begin
         signe := -signe;
         C.lineto(ScrX(pixXorigin + x), ScrY(pixYorigin + cy + signe*r));
         x := x + decalx;




     End;

    // C.Pen.Color := 0;  
End;



Procedure CercleNote_Draw(cx, cy:TCoord; taille: integer; zp: integer);
var t: integer;
Begin

      if Nepasafficherdutout then Exit;




      if NoteEnEllipse then
      Begin
            {si brush en clear, alors dessin d'une blanche ou ronde...
             c'est une image spéciale}

            if (C.Brush.Style = bsClear) and (C.Pen.Color = 0) and (Zoom * zp > ZoomParDefaut * ZoomMaxPrec) then
              DrawBitmap(cx - (imgNoteBlanche.Width*prec div 2)*zp div ZoomMaxPrec,
                         cy - (imgNoteBlanche.Height*prec div 2)*zp div ZoomMaxPrec, imgNoteBlanche, zp )
            else
            Begin

              for t := 0 to nbcerclepts do
                   cerclepts[t] := ScrPoint(pixXorigin + cx + zp * cercleptsstd[taille][t].x / ZoomMaxPrec,
                                            pixYorigin + cy + zp * cercleptsstd[taille][t].y / ZoomMaxPrec);


              if DessinerOpaque then
                   C.PolyGon(cerclepts)
              else
                   C.PolyLine(cerclepts);
            end;
      end
      else
          Cercle(cx, cy, nbpixlign);



End;



end.
