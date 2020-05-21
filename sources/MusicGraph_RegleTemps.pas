unit MusicGraph_RegleTemps;

interface


uses MusicSystem_Composition, QSystem {pour Trationnel...};


type TRegleTemps_DrawBarSelectionnee_type = (rtdbstNoteSelectionnee,
                                             rtdbstSousCurseur);   



Function IsRegleTemps_Curseur_Dessus(Comp: TComposition; iligne, m, x_in_mes, y_in_mes: integer; var temps: TRationnel): boolean;
procedure RegleTemps_Partition_Afficher(Comp: TComposition; l1, l2, x1, x2: integer);
procedure RegleTemps_DrawBarSelectionnee_AvecTemps(comp: TComposition;
       iligne: integer ; imesure: integer; temps: TRationnel;
                            typ: TRegleTemps_DrawBarSelectionnee_type);



implementation



uses MusicGraph_Portees {pour GetY(...)},
     MusicGraph_System {pour line...},
     Graphics, MusicSystem_Mesure,
     SysUtils,
     MusicWriter_Erreur;


const RegleTemps_decaly = 480;



Function RegleTemps_YHaut(comp: TComposition; iLigne: integer): integer;
Begin
    result := Comp.Portee_YHaut_Barre_InRepere_Ligne(iLigne, comp.PremierePorteeAffichee(iLigne)) - RegleTemps_decaly;

End;




procedure RegleTemps_DrawBar(x:integer; comp: TComposition; iligne: integer ; num_temps: integer);
var y1, y2:integer;
    s: string;

    x_texte, y_texte: integer;

Begin
     if comp = nil then
     Begin
          y1 := GetY(nil, 0, 0, 4);
          y2 := GetY(nil, 0, 0, -4);
     End
     else
     Begin
         y1 := RegleTemps_YHaut(Comp, iLigne);
         y2 := Comp.Portee_YBas_Barre_InRepere_Ligne(iLigne, comp.DernierePorteeAffichee(iLigne));


         s := inttostr(num_temps) + 't';

         x_texte := x+20;
         y_texte := y1;

         SetFontSize(8);
         TextOut(x_texte, y_texte, s);

     End;

     Line(x, y1, x, y2);
End;





procedure RegleTemps_Partition_Afficher(Comp: TComposition; l1, l2, x1, x2: integer);
const RegleTemps_Barre_Couleur = $888888;

var l, m, x: integer;
    num_temps: integer;
    t, duree_totale: TRationnel;

Begin
      C.Pen.Width := 1;
      C.Pen.Color := RegleTemps_Barre_Couleur;
      C.Pen.Style := psDash;

      C.Brush.Style := bsSolid;
      C.Brush.Color := clWhite;
         

      With Comp do
      for l := l1 to l2 do
             Begin
                 IGiLigne := l;
                       m := GetMesureSurLigne(l, x1);
                       while m <= GetMesureSurLigne(l, x2) do
                       With GetMesure(m) do
                          Begin
                                SetOriginMesure(m);

                                duree_totale := DureeTotale;
                                t := Qel(0);
                                num_temps := 1;
                                While IsQ1InfQ2(t, duree_totale) do
                                Begin
                                     x := XATempsOuEntre(QAdd(t, Qel(1)));
                                     RegleTemps_DrawBar(x, Comp, l, num_temps);

                                     t := QAdd(t, Qel(1));
                                     inc(num_temps);


                                End;

                                inc(m);
                          End;
             End;
End;






Function IsRegleTemps_Curseur_Dessus(Comp: TComposition; iligne, m, x_in_mes, y_in_mes: integer; var temps: TRationnel): boolean;
const ecart_max = 80;
Begin
    if not Comp.IsIndiceLigneValide(iligne) then
    Begin
          result := false;
          exit;
    End;

    if not Comp.IsIndiceMesureValide(m) then
    Begin
          result := false;
          exit;
    End;
    
    if abs(Comp.Portee_YHaut_Barre_InRepere_Ligne(iLigne, comp.PremierePorteeAffichee(iLigne)) - RegleTemps_decaly - y_in_mes) < ecart_max then
    Begin
         result := true;
         temps := Comp.GetMesure(m).TempsAX(x_in_mes);
         temps := Qel(Round(QToReal(temps)));

    End
    else
         result := false;
End;



procedure RegleTemps_DrawBarSelectionnee_AvecTemps(comp: TComposition; iligne: integer ;
                            imesure: integer; temps: TRationnel;
                            typ: TRegleTemps_DrawBarSelectionnee_type);
{temps du début = Qel(1)}
var y: integer;
    x: integer;

const taille = 100;
Begin


      With comp do
      Begin

            x := GetMesure(imesure).XATempsOuEntre(temps);
            SetOriginMesure(imesure);

      End;



      y := RegleTemps_YHaut(Comp, iLigne);

      case typ of
         rtdbstNoteSelectionnee:
          Begin
               C.Pen.Color := clRed;
               C.Pen.Width := 4;
          End;
         rtdbstSousCurseur:
          Begin
               C.Pen.Color := $4444EE;
               C.Pen.Width := 3;
          End;
         else MessageErreur('pb de type avec rtdbst');
     end;

         
      Line(x, y + taille, x, y);
      Line(x, y, x + taille, y);

      C.Pen.Width := 1;
End;



end.
