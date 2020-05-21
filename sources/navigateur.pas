unit navigateur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, MusicSystem_Composition, MusicSystem_Curseur;

type
  TframeNavigateur = class(TFrame)
    Panel: TPaintBox;
    Function GetComposition: TComposition;
    Function GetCurseur: TCurseur;
    Function GetiMesureSousCurseurSouris(X: integer): integer;
    procedure PanelPaint(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);


  private
    { Déclarations privées }
       private_mesures_affichees_1, private_mesures_affichees_2: integer;
  public
    { Déclarations publiques }
      procedure Mesures_Affichees_Set(m1, m2: integer);
  end;





implementation

uses MusicSystem_CompositionBase, MusicWriter_Erreur, childwin,
     MusicGraph_CouleursVoix, MusicSystem_CompositionAvecSelection,
     Math {pour min, max};

{$R *.dfm}


Function TframeNavigateur.GetiMesureSousCurseurSouris(X: integer): integer;
Begin

     result := min(ClientWidth-1, max(0, X))
                    * (GetComposition.NbMesures+1) div ClientWidth;


End;


Function TframeNavigateur.GetComposition: TComposition;
Begin
   result := (Parent as TMDIChild).Composition;
ENd;


Function TframeNavigateur.GetCurseur: TCurseur;
Begin
   result := (Parent as TMDIChild).Curseur;
ENd;









procedure TframeNavigateur.PanelPaint(Sender: TObject);
var nb_mes, i, x, xsuiv, ecart: integer;
    selection_mesure1, selection_mesure2: integer;
    c_est_serre: boolean;
    comp: TComposition;

    Function GetX(imes: integer): integer;
    Begin
         result := (imes) * ClientWidth div nb_mes;
    End;

    procedure Line(x1, y1, x2, y2: integer);
    Begin
        With Panel.Canvas do
        Begin
            moveto(x1, y1);
            lineto(x2, y2);

        End;
    End;

    procedure Mesure_TextOut(str1, str2, str3: string);
    {affiche dans le navigateur de mesure, à l'abscisse x, le texte str1
     s'il est trop long pour être affiché, affiche str2...
     s'il est trop long, str3...}

    var w, xmil: integer;
    Begin
        With Panel.Canvas do
        Begin
            xmil := (x + xsuiv) div 2;

            w := TextWidth(str1);
            
            if w < ecart then
                 Panel.Canvas.TextOut(xmil - w div 2, 2, str1)
            else
            Begin
                 w := TextWidth(str2);

                  if w < ecart then
                       Panel.Canvas.TextOut(xmil - w div 2, 2, str2)
                  else
                  Begin
                       w := TextWidth(str3);

                        if w < ecart then
                             Panel.Canvas.TextOut(xmil - w div 2, 2, str3)
                        else
                        Begin

                        End;
                  End;


            End;

        End;
    End;
    
begin
        Panel.Canvas.Pen.Width := 1;
        Panel.Canvas.Pen.Color := 0;
        Panel.Canvas.Font.Size := 7;
        comp := GetComposition;
        if comp = nil then exit;

        nb_mes := comp.NbMesures+1;

        selection_mesure1 := comp.Selection_GetIMesDebutSelection;
        selection_mesure2 := comp.Selection_GetIMesFinSelection;

        ecart := ClientWidth div nb_mes;
        c_est_serre := (ecart < 5);
        xsuiv := 0;
        for i := 0 to nb_mes - 1 do
        Begin
            x := xsuiv;
            xsuiv := GetX(i+1);

            if i = GetCurseur.GetiMesure then
                Panel.Canvas.Brush.Color := CouleursVoixFondList(comp, GetCurseur.GetiVoixSelectionnee)

            else if (selection_mesure1 <= i) and (i <= selection_mesure2) then
                Panel.Canvas.Brush.Color := $AAAAFF
            else if (private_mesures_affichees_1 <= i) and (i <= private_mesures_affichees_2) then
                Panel.Canvas.Brush.Color := $AAFFAA
            else
                Panel.Canvas.Brush.Color := $FFFFFF;

             if c_est_serre then
                  Panel.Canvas.FillRect(Rect(x, 1, xsuiv, 15))
             else
                  Panel.Canvas.Rectangle(x, 0, xsuiv+
                  1, 16);

             if ((i+1) mod 10 = 0) or (i = GetCurseur.GetiMesure) then
                 Mesure_TextOut('mesure n° ' + inttostr(i + 1),
                                'mes. n° ' + inttostr(i + 1),
                                inttostr(i + 1));
        End;


        {fin de partition}
        Panel.Canvas.Pen.Width := 2;
        x := GetX(nb_mes - 1);
        Line(x, 0, x, 15);

        Panel.Canvas.Pen.Width := 1;
        dec(x, 3);
        
        Line(x, 0, x, 15);

        {zone affichée à l'écran}
        Panel.Canvas.Brush.Style := bsClear;
        Panel.Canvas.Pen.Width := 2;
        Panel.Canvas.Pen.Color := $00AA00;
        Panel.Canvas.Rectangle(
                      GetX(private_mesures_affichees_1), 0,
                      GetX(private_mesures_affichees_2+1), 16
        );

end;



procedure TframeNavigateur.FrameResize(Sender: TObject);
begin
     PanelPaint(nil);
end;

procedure TframeNavigateur.PanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i_mes: integer;

begin
     i_mes := GetiMesureSousCurseurSouris(X);
     GetCurseur.DA_Mesure_Debut(i_mes);

     (Parent as TMDIChild).FaireVoirMesure(i_mes);

     PanelPaint(nil);
end;




procedure TframeNavigateur.Mesures_Affichees_Set(m1, m2: integer);
Begin
     if (private_mesures_affichees_1 <> m1) or (private_mesures_affichees_2 <> m2) then
     Begin
         private_mesures_affichees_1 := m1;
         private_mesures_affichees_2 := m2;
         PanelPaint(nil);
     End;
End;




procedure TframeNavigateur.PanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    if ssLeft in Shift then
    PanelMouseDown(Sender, mbLeft, Shift, X, Y);
end;

end.
