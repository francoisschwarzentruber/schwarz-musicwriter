unit piano;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MusicHarmonie, MusicSystem_ElMusical, Menus, ExtCtrls;

const TOUCHES_INDICE_MIN = -50;
      TOUCHES_INDICE_MAX = 50;
      TOUCHE_POURRIE = 190;
      DECAL_X = 270;

      
type TMainHumaine = (MainGauche, MainDroite);
     TToucheIntervalle = TOUCHES_INDICE_MIN..TOUCHES_INDICE_MAX;
     TTouche = integer;
     TNumDoigt = 1..5;

     
type
  TfrmPiano = class(TForm)
    PopupMenu1: TPopupMenu;
    Rinitialiser1: TMenuItem;
    tmrRelever: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure Rinitialiser1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrReleverTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;



var
  frmPiano: TfrmPiano;
  
  procedure frmPiano_Show;


  procedure Piano_Touches_Enfoncer(el: TElMusical; color : TColor; main: TMainHumaine);
  procedure Piano_Touches_Relever(el: TElMusical);

  procedure Piano_Touches_Enfoncer_Puis_Relever(hn: THauteurNote);

  procedure Piano_Touche_Enfoncer(nb_demiton: integer; color: TColor; main: TMainHumaine; num_doigts: integer); overload;
  procedure Piano_Touche_Enfoncer(hn: THauteurNote; color : TColor; main: TMainHumaine; num_doigts: integer); overload;

  procedure Piano_Touche_Relever(num_touche:integer); overload;
  procedure Piano_Touche_Relever(hn: THauteurNote); overload;
  procedure Piano_Touches_ReleverToutes;










implementation



{$R *.dfm}

uses Main, Childwin {pour actchild},
     MusicGraph_Portees {pour IGP...},
     Magnetophone {pour Magnetophone_IsPlaying},
     MusicUser {pour Outil_IsModeClavier},
     QSystem {pour Divdiveucl},
          MusicUser_PlusieursDocuments;

     
const TOUCHE_RELEVE = 0;

const toucheblanche_largeur = 12;
      toucheblanche_hauteur = 48;
      octave_largeur = toucheblanche_largeur*7;

      touchenoire_largeur2 = 4;
      touchenoire_hauteur = 32;

      toucheblanche_couleur_enfonce = $00EE88;
      toucheblanche_couleur = $FFFFFF;

      touchenoire_couleur_enfonce = $00EE88;
      touchenoire_couleur = $000000;

      piano_touche_texte_decal_x = 2;




var touches_tab: array[TToucheIntervalle] of TColor;
    mains: array[TMainHumaine, TNumDoigt] of TTouche;
    mains_utile: array[TMainHumaine, TNumDoigt] of Boolean;
    scr_piano: TBitmap;

  
procedure frmPiano_Show;
Begin
    if frmPiano = nil then
        frmPiano := TfrmPiano.Create(nil);

    frmPiano.Show;
End;


//dessin de touches



procedure Main_Init;
var doigt: TNumDoigt;
    main: TMainHumaine;
    
Begin
    for doigt := 1 to 5 do
       for main := MainGauche to MainDroite do
       Begin
            mains_utile[main, doigt] := false;
            mains[main, doigt] := 0;
       End;
End;




Procedure Main_Set(main: TMainHumaine; doigt: TNumDoigt; touche: TTouche);
var id: integer;
    touche_davant: integer;
    
Begin
     mains[main, doigt] := touche;
     mains_utile[main, doigt] := true;

     touche_davant := TOUCHES_INDICE_MIN;
     
     for id := 1 to 5 do
     Begin
          if not mains_utile[main, id] then
               mains[main, id] := touche_davant + 2;

          touche_davant := mains[main, id];
     End;

     inc(touche_davant, 2);
     
     for id := 5 downto 1 do
     Begin
          if not mains_utile[main, id] then
               mains[main, id] := touche_davant - 2;
          touche_davant := mains[main, id];
     End;

               
End;






Function Piano_IsTouche_Enfonce(indice: integer): Boolean;
Begin
     indice := indice;
     if (TOUCHES_INDICE_MIN <= indice) and (indice <= TOUCHES_INDICE_MAX) then
         result := (touches_tab[indice] <> TOUCHE_RELEVE)
     else
         result := false;


End;


Function Piano_Touche_Couleur(indice: integer): TColor;
Begin
     indice := indice;
     if (TOUCHES_INDICE_MIN <= indice) and (indice <= TOUCHES_INDICE_MAX) then
         result := touches_tab[indice]
     else
         result := 0;
End;


    procedure ToucheBlanche_Partielle(Canvas: TCanvas; x: integer; num_touche: integer);
    var s: string;

    Begin
        x := DECAL_X + x;
        if Piano_IsTouche_Enfonce(num_touche) then
             Canvas.Brush.Color := Piano_Touche_Couleur(num_touche)
        else
             Canvas.Brush.Color := toucheblanche_couleur;
             
        Canvas.FillRect(Rect(x+1, touchenoire_hauteur+1, x + toucheblanche_largeur-1, toucheblanche_hauteur-1));

        case num_touche of
            0: s := '<';
            2: s := 'w';
            4: s := 'x';
            5: s := 'c';
            7: s := 'v';
            9: s := 'b';
            11: s := 'n';
            else s := '';
        end;

        Canvas.TextOut(x+piano_touche_texte_decal_x, touchenoire_hauteur+1, s);
    End;


    procedure ToucheBlanche(Canvas: TCanvas; x: integer; num_touche: integer);
    Begin
        x := DECAL_X + x;
        Canvas.Brush.Color := toucheblanche_couleur;

        Canvas.Rectangle(x, 0, x + toucheblanche_largeur, toucheblanche_hauteur);
        ToucheBlanche_Partielle(Canvas, x - DECAL_X, num_touche);


    End;




    procedure ToucheNoire(Canvas: TCanvas; x: integer; num_touche: integer);
    var s: string;
    Begin
        x := DECAL_X + x;
        if Piano_IsTouche_Enfonce(num_touche) then
             Canvas.Brush.Color := Piano_Touche_Couleur(num_touche)
        else
             Canvas.Brush.Color := touchenoire_couleur;

        Canvas.Rectangle(x - touchenoire_largeur2, 0,
                         x + touchenoire_largeur2, touchenoire_hauteur);


        case num_touche of
            1: s := 'q';
            3: s := 's';
            6: s := 'f';
            8: s := 'g';
            10: s := 'h';
            else s := '';
        end;

        Canvas.TextOut(x - touchenoire_largeur2+piano_touche_texte_decal_x, 1, s);
    End;



    Function Piano_Touche_GetHauteurNote(x_ecran, y_ecran: integer): THauteurNote;
    Begin
        if y_ecran > touchenoire_hauteur then
        Begin
             result.alteration := aNormal;
             result.Hauteur := DivDivEucl( (x_ecran - DECAL_X), toucheblanche_largeur)
        End
        else
        Begin
            result.alteration := aDiese;
            result.Hauteur := DivDivEucl( (x_ecran - DECAL_X - touchenoire_largeur2),
                                          toucheblanche_largeur);
        End;

    End;




Function Piano_Touche_IsToucheNoire(num_touche: integer; out x: integer): Boolean;
var hn: THauteurNote;
Begin
    hn := NbDemiTonToHauteurNote(num_touche, 0);
    result := (hn.alteration <> aNormal);
    
    if result then
        x := hn.Hauteur * toucheblanche_largeur + toucheblanche_largeur
    else
        x := hn.Hauteur * toucheblanche_largeur;
End;

Procedure Piano_Touche_Dessiner(Canvas: TCanvas; num_touche: integer);
var x:integer;
Begin
    if Piano_Touche_IsToucheNoire(num_touche, x) then
        ToucheNoire(Canvas, x, num_touche)
    else
        ToucheBlanche_Partielle(Canvas, x, num_touche)
End;




Function HauteurNoteToTouche(hn: THauteurNote): integer;
Begin
    result := NbDemiTonInHauteurNote(hn);
End;


procedure Piano_Touches_Enfoncer(el: TElMusical; color: TColor; main: TMainHumaine); overload;
var n: integer;
Begin
    if el.IsSilence then exit;

    for n := 0 to el.NbNotes - 1 do
        Piano_Touche_Enfoncer(el.GetNote(n).HauteurNote, color, main, el.GetNote(n).piano_doigtee);

End;


procedure Piano_Touches_Relever(el: TElMusical);
var n: integer;
Begin
    if el.IsSilence then exit;

    for n := 0 to el.NbNotes - 1 do
        Piano_Touche_Relever(el.GetNote(n).HauteurNote);


End;



procedure Piano_Touches_Enfoncer_Puis_Relever(hn: THauteurNote);
Begin
     Piano_Touches_ReleverToutes;
     Piano_Touche_Enfoncer(hn, 255, MainDroite, 3);

     if frmPiano <> nil then
         frmPiano.tmrRelever.Enabled := true;
End;




procedure Piano_Touche_Enfoncer(nb_demiton: integer; color: TColor; main: TMainHumaine; num_doigts: integer); overload;
Begin
     if (TOUCHES_INDICE_MIN <= nb_demiton) and (nb_demiton <= TOUCHES_INDICE_MAX) then
         touches_tab[nb_demiton] := color;

     if frmPiano <> nil then
          Piano_Touche_Dessiner(frmPiano.Canvas, nb_demiton);

     Main_Set(main, num_doigts, nb_demiton);
End;





procedure Piano_Touche_Enfoncer(hn: THauteurNote; color: TColor; main: TMainHumaine; num_doigts: integer); overload;
Begin
     Piano_Touche_Enfoncer(HauteurNoteToTouche(hn),
                                color,
                                main, num_doigts);

End;






procedure Piano_Touche_Relever(num_touche:integer); overload;
var main: TMainHumaine;
    doigt: TNumDoigt;
Begin

     if (TOUCHES_INDICE_MIN <= num_touche) and (num_touche <= TOUCHES_INDICE_MAX) then
         touches_tab[num_touche] := TOUCHE_RELEVE;

     if frmPiano <> nil then
          Piano_Touche_Dessiner(frmPiano.Canvas, num_touche);




    for main := MainGauche to MainDroite do
        for doigt := 1 to 5 do
            if mains[main, doigt] = num_touche then
             mains_utile[main, doigt] := false;
End;



procedure Piano_Touche_Relever(hn: THauteurNote); overload;
Begin
     Piano_Touche_Relever( HauteurNoteToTouche(hn) );
     
End;


procedure Piano_Touches_ReleverToutes;
var i :integer;

Begin
    for i := TOUCHES_INDICE_MIN to TOUCHES_INDICE_MAX do
         touches_tab[i] := TOUCHE_RELEVE;

    if frmPiano <> nil then
          frmPiano.FormPaint(nil);
End;





Procedure Main_Affichage_Calculer(Canvas: TCanvas);
const POIGNET_Y = 58;

var main: TMainHumaine;
    bary_x, i: integer;
    x, y: integer;


    procedure ToucheToXY(touche: TTouche; out x, y: integer);
    Begin
         if Piano_Touche_IsToucheNoire(touche, x) then
         Begin
             y := 24
         End
         else
         Begin
             x := x + toucheblanche_largeur div 2;
             y := 32;
         End;

         x := DECAL_X + x;
    End;

    Function ToucheToX(touche: TTOuche): integer;
    var x, y: integer;
    Begin
         ToucheToXY(touche, x, y);
         result := x;
    End;

Begin

    for main := MainGauche to MainDroite do
    Begin
         bary_x := (ToucheToX(mains[main, 1]) +
                   ToucheToX(mains[main, 2]) +
                   ToucheToX(mains[main, 3]) +
                   ToucheToX(mains[main, 4]) +
                   ToucheToX(mains[main, 5])) div 5;

         Canvas.Pen.Color := $5555EE;
         Canvas.Pen.Width := 24;
         Canvas.MoveTo(bary_x, POIGNET_Y);
         Canvas.LineTo(bary_x, 128);

         for i := 1 to 5 do
         Begin
              if mains_utile[main, i] then
              Begin
                   Canvas.Pen.Color := $5555EE;
                   Canvas.Pen.Width := 5;
              End
              else
              Begin
                   Canvas.Pen.Color := $8888FF;
                   Canvas.Pen.Width := 7;
              End;

              if i = 1 then
                Canvas.Pen.Width := round(1.5*Canvas.Pen.Width);
                   
              Canvas.MoveTo(bary_x, POIGNET_Y);
              
              ToucheToXY(mains[main, i], x, y);
              Canvas.LineTo(x, y);
         End;



    End;

    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := 0;
         
End;


    
procedure TfrmPiano.FormPaint(Sender: TObject);
    var o, i: integer;
begin
    With scr_piano do
    Begin
          Canvas.Brush.color := $AAAAAA;
          Canvas.Rectangle(ClientRect);

          for o := -4 to 3 do
          Begin
             for i := 0 to 6 do
             Begin
                 ToucheBlanche(Canvas, octave_largeur * o + i * toucheblanche_largeur, o*12 + NbDemiTonDepuisDo0[i] );
             End;

             ToucheNoire(Canvas, octave_largeur * o + 1 * toucheblanche_largeur, o*12 + 1);
             ToucheNoire(Canvas, octave_largeur * o + 2 * toucheblanche_largeur, o*12 + 3);
             ToucheNoire(Canvas, octave_largeur * o + 4 * toucheblanche_largeur, o*12 + 6);
             ToucheNoire(Canvas, octave_largeur * o + 5 * toucheblanche_largeur, o*12 + 8);
             ToucheNoire(Canvas, octave_largeur * o + 6 * toucheblanche_largeur, o*12 + 10);
          End;
          Main_Affichage_Calculer(Canvas);

      End;


      Canvas.Draw(0, 0, scr_piano);


end;

procedure TfrmPiano.Rinitialiser1Click(Sender: TObject);
begin
    Piano_Touches_ReleverToutes;
    Main_Init;
end;

procedure TfrmPiano.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var hn: THauteurNote;

begin
     if not (ssLeft in Shift) then exit;
     If Magnetophone_IsConnected then exit;
     if not Outil_MettreNoteIsModeSouris then exit;

     if not MusicWriter_IsFenetreDocumentCourante then exit;

                            
      hn := Piano_Touche_GetHauteurNote(X, Y);
      hn := Enharmoniquer(hn, actchild.Curseur.GetTonaliteCourante);

      With actchild do
      Begin
        IGP := Composition;
        I_InsererModeleCourantDansVoixCourante(hn);
        Composition.PaginerApartirMes(Curseur.GetiMesure, true);
        ReaffichageComplet;
      End;
end;

procedure TfrmPiano.tmrReleverTimer(Sender: TObject);
begin
     Piano_Touches_ReleverToutes;
     tmrRelever.Enabled := false;
end;

procedure TfrmPiano.FormCreate(Sender: TObject);
begin
    scr_piano := TBitmap.Create;
    FormResize(nil);
    Rinitialiser1Click(nil);
end;

procedure TfrmPiano.FormResize(Sender: TObject);
begin
    scr_piano.Width := ClientWidth;
    scr_piano.Height := ClientHeight;
end;

end.
