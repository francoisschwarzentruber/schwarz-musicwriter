unit RectList;

interface

uses Types;

type

  TRectList = class(TObject)
      NextBlitRects, BlitRects: array of TRect;

      Procedure AjouterNextBlitRect(R: TRect);
      Procedure ViderNextBlitRects;

  End;


procedure MettreleftEtTopBonOrdreInRect(var R: TRect);






implementation

procedure MettreleftEtTopBonOrdreInRect(var R: TRect);
//Formate une structure Rect
var t: integer;
Begin
     if R.Left > R.Right then
     Begin
         t := R.Left;
         R.Left := R.Right;
         R.Right := t;
     End;

     if R.top > R.bottom then
     Begin
         t := R.top;
         R.top := R.bottom;
         R.bottom := t;
     End;
End;


Procedure TRectList.ViderNextBlitRects;
Begin
setlength(NextBlitRects, 0);
End;


Procedure TRectList.AjouterNextBlitRect(R: TRect);
{ajoute une nouvelle zone qui sera à effacer plus tard}
var i: integer;
Begin
    i := length(NextBlitRects);
    Setlength(NextBlitRects, i+1);
    NextBlitRects[i] := R;
End;



end.
