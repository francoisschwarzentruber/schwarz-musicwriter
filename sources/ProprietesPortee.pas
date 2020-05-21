unit ProprietesPortee;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, ComCtrls, ToolWin, ImgList, instruments, MusicSystem_Composition,
  Buttons, Menus;

type

  TModeEditionPortee = (mepDeplacerPortee, mepSelectionnerPortee);

  TfrmProprietesPortee = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    txtNom: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    cboZoom: TComboBox;
    ImageInstrument: TImage;
    Panel1: TPanel;
    panPortees: TPaintBox;
    ToolBar1: TToolBar;
    tbnAccolade: TToolButton;
    ToolButton2: TToolButton;
    ImageList: TImageList;
    tbnAddPortee: TToolButton;
    tbnDelPortee: TToolButton;
    ToolButton4: TToolButton;
    ToolButton1: TToolButton;
    Label7: TLabel;
    txtMiniNom: TEdit;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    cboInstruments: TListBox;
    panInstruments: TPaintBox;
    tbnSelectElMusicaux: TToolButton;
    ToolButton5: TToolButton;
    ToolButton3: TToolButton;
    ToolButton6: TToolButton;
    panClefEtTransposition: TPanel;
    txtInstrumentSubStr: TEdit;
    Image2: TImage;
    BitBtn3: TBitBtn;
    PopupMenu1: TPopupMenu;
    Ajouteruneporteenhaut1: TMenuItem;
    Ajouteruneporteenbas1: TMenuItem;
    N1: TMenuItem;
    Supprimerlesportesslectionnes1: TMenuItem;
    Relierparuneaccoladelesportesslectionnes1: TMenuItem;
    Relierparuncrochetlesportesslectionnes1: TMenuItem;
    N2: TMenuItem;
    Supprimerlesaccoladesetlescrochetsprsentsdanslesportesslectionnes1: TMenuItem;
    N3: TMenuItem;
    Slectionnerlesnotesdanslesportesslectionnes1: TMenuItem;
    panPortees_Normales: TPanel;
    Label6: TLabel;
    Label1: TLabel;
    cboTransposition: TComboBox;
    cboClef: TComboBox;
    rdgTypePortee: TRadioGroup;
    cmdTablature_Add: TButton;
    cboVisibility: TComboBox;
    Label4: TLabel;
    cmdTablature_Suppr: TButton;
    lblTitle: TLabel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure MettreAJourFenetre(Sender: TObject);
    procedure MettreAJourPortee(Sender: TObject);
    procedure InstrumentAChanger(Sender: TObject);
    procedure cboTranspositionChange(Sender: TObject);
    procedure cboInstrumentsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure cboZoomChange(Sender: TObject);
    procedure Init_Utilisation_panPortees;
    procedure panPorteesPaint(Sender: TObject);
    procedure panPorteesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cboInstrumentsClick(Sender: TObject);
    procedure cboInstrumentsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure panPorteesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tbnAccoladeClick(Sender: TObject);
    procedure Portees_Relier_Crochet(Sender: TObject);
    procedure Portee_Ajouter_En_Haut(Sender: TObject);
    procedure Portee_Supprimer(Sender: TObject);
    procedure Portee_Ajouter_En_Bas(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cboVisibilityChange(Sender: TObject);
    function GetPorteeSelectionnee(y:integer): integer;
    function GetPorteeSelectionnee2(y:integer): integer;

    procedure cboClefChange(Sender: TObject);
    procedure panInstrumentsPaint(Sender: TObject);
    procedure panInstrumentsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure panPorteesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbnSelectElMusicauxClick(Sender: TObject);
    procedure Portees_Virer_Accolades(Sender: TObject);
    procedure txtNomChange(Sender: TObject);
    procedure rdgTypePorteeClick(Sender: TObject);
    procedure cboInstrumentsMeasureItem(Control: TWinControl;
      Index: Integer; var Height: Integer);
    procedure txtInstrumentSubStrChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure cmdTablature_AddClick(Sender: TObject);
    procedure cmdTablature_SupprClick(Sender: TObject);
  private
    CompEnCours: TComposition;
    PorteeSelectionnee1, PorteeSelectionnee2: integer;
    NEPASLancerMiseAJourPortee: Boolean;

    OnChargeLaListeDesInstruments: Boolean;
    bmpPortees: TBitmap;
    { Déclarations privées }
  public

    Procedure SetPorteeSelectionneeDebutEtFin(portee: integer); overload;
    Procedure SetPorteeSelectionneeDebutEtFin(portee1, portee2: integer); overload;
    
    Function GetPorteeSelectionneeDebut: integer;
    Function GetPorteeSelectionneeFin: integer;
    { Déclarations publiques }
  end;

  Procedure frmProprietesPortee_Afficher;

  
var
  frmProprietesPortee: TfrmProprietesPortee;











  


  
implementation

{$R *.DFM}

uses Main, MusicUser, MusicWriter_Console, MusicGraph, MusicGraph_System,
     MusicGraph_Portees {pour GetY(...)},
     Math, choix, MusicHarmonie, MusicSystem_Types {pour TPosition},
     MusicSystem_CompositionBase {pour les visibilités des portées},
     CurseursSouris, MusicSystem_Composition_Portees_Liste,
     MusicGraph_Images,
     MidiNowInstrument,
          MusicUser_PlusieursDocuments,
          InterfaceGraphique_Complements;

const decalinstrnumber = 0;
      ZoomPourApercuChoixPortee = 40;
      decalrectangle = 0;


var  InstrumentsPositionInImage: array[0..127] of TPoint;
  ModeEditionPortee: TModeEditionPortee = mepSelectionnerPortee;
  PorteeSousCurseur: integer = 0;


Procedure frmProprietesPortee_Afficher;
Begin
    if frmProprietesPortee = nil then
         frmProprietesPortee := TfrmProprietesPortee.Create(nil);

    frmProprietesPortee.Show;
End;

procedure MettreAJourFenetreEtPartition;
Begin
  frmProprietesPortee.MettreAJourFenetre(nil);
  actchild.ReaffichageComplet;

End;


Function TfrmProprietesPortee.GetPorteeSelectionneeDebut: integer;
Begin
    result := min(PorteeSelectionnee1, PorteeSelectionnee2);
End;

Function TfrmProprietesPortee.GetPorteeSelectionneeFin: integer;
Begin
     result := max(PorteeSelectionnee1, PorteeSelectionnee2);
End;


Procedure TfrmProprietesPortee.SetPorteeSelectionneeDebutEtFin(portee: integer);
Begin
    PorteeSelectionnee1 := portee;
    PorteeSelectionnee2 := portee;

    MettreAJourFenetre(nil);
End;


Procedure TfrmProprietesPortee.SetPorteeSelectionneeDebutEtFin(portee1, portee2: integer);
Begin
    PorteeSelectionnee1 := portee1;
    PorteeSelectionnee2 := portee2;

    MettreAJourFenetre(nil);
End;


procedure TfrmProprietesPortee.MettreAJourFenetre(Sender: TObject);
var reafficher: boolean;
    PorteeEnCours: integer;

    Function PorteesSelectionnees_IsUneTablature: Boolean;
    var ip: integer;
    Begin
         result := false;
         for ip := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do
             if CompEnCours.Portee_IsTablature(ip) then
                 result := true;
    End;


    procedure lblTitle_Regler_Affichage;
    Begin
         if GetPorteeSelectionneeDebut = GetPorteeSelectionneeFin then
             lblTitle.Caption := 'Propriété de la portée n° ' + inttostr(GetPorteeSelectionneeDebut + 1)
         else
             lblTitle.Caption := 'Propriétés communes aux portées n°' + inttostr(GetPorteeSelectionneeDebut + 1)
                                 + ' à ' + inttostr(GetPorteeSelectionneeFin + 1);
    End;



Begin
    if self = nil then exit;

    NEPASLancerMiseAJourPortee := true;

    if not MusicWriter_IsFenetreDocumentCourante then
    Begin
           EnableFenetre(self, false);
           CompEnCours := nil;
    End
    else
    Begin
           actchild.VerifierIntegrite('mettre à jour la fenêtre de portées');
           EnableFenetre(self, true);
           PorteeEnCours := GetPorteeSelectionneeDebut;
           CompEnCours := actchild.Composition;

           lblTitle_Regler_Affichage;

           
       With CompEnCours do
       Begin
//              With CompEnCours.PorteesGlobales[PorteeEnCours] do Begin
           if CompEnCours = nil then
               reafficher := true
           else
               reafficher := (Portee_InstrumentMIDINum[PorteeEnCours] - 1 <> cboInstruments.ItemIndex)
                                            or (CompEnCours <> actchild.Composition);

           CompEnCours := actchild.Composition;
           if reafficher then
           {si nécessaire, réaffiche l'image de l'instrument}
           Begin
                 cboInstruments.ItemIndex := Portee_InstrumentMIDINum[PorteeEnCours] - decalinstrnumber;
                 InstrumentAChanger(nil);
           End;
           panPorteesPaint(nil);
           txtNom.Text := Portee_Nom[PorteeEnCours];

           CBOBOXSelectionner(cboZoom, inttostr(Portee_Taille[PorteeEnCours]));

           if PorteesSelectionnees_IsUneTablature then
           Begin
                NEPASLancerMiseAJourPortee := false;
                panPortees_Normales.VIsible:= false;
                exit;
           End
           else
               panPortees_Normales.VIsible:= true;

           rdgTypePortee.ItemIndex := Portee_Type[PorteeEnCours];

           case Portee_Transposition[PorteeEnCours].hauteur of
                 0: cboTransposition.ItemIndex := 0;
                 -1: cboTransposition.ItemIndex := 1;
           end;

           cboVisibility.ItemIndex := Integer(Portee_Visible[PorteeEnCours]);
           cboClef.ItemIndex := integer(I_Portee_Clef[PorteeEnCours]);
       End;
    End;
    NEPASLancerMiseAJourPortee := false;
End;







procedure TfrmProprietesPortee.MettreAJourPortee(Sender: TObject);
var PorteeEnCours: integer;
Begin
    if NEPASLancerMiseAJourPortee then exit;

    if cboInstruments.ItemIndex < 0 then
           cboInstruments.ItemIndex := 0; //par défaut, piano

    for PorteeEnCours := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do
    With CompEnCours do
    Begin
        //Nom
        if Sender = txtNom then
             Portee_Nom[PorteeEnCours] := txtNom.Text;

        //Instrument
        if Sender = cboInstruments then
            Portee_InstrumentMIDINum[PorteeEnCours] := decalinstrnumber + cboInstruments.ItemIndex;

        //Zoom
        if Sender = cboZoom then
              Portee_Taille[PorteeEnCours] := strtoint(cboZoom.text);

        //transposition
        if Sender = cboTransposition then
        With Portee_Transposition[PorteeEnCours] do
        Begin
              if cboTransposition.Text = 'Do' then
              Begin
                    Hauteur := 0;
                    alteration := aNormal;
              end
              else if cboTransposition.Text = 'Si b' then
              Begin
                  Hauteur := -1;
                  alteration := aBemol;

              End;
        End;

        //visibilité
        if Sender = cboVisibility then
               Portee_Visible[PorteeEnCours] := TPorteeVisibility(cboVisibility.ItemIndex);

        //clef
        if Sender = cboClef then
             I_Portee_Clef[PorteeEnCours] := TClef(cboClef.ItemIndex);
    End;
    MettreAJourFenetreEtPartition;
End;





procedure TfrmProprietesPortee.FormCreate(Sender: TObject);
var i:integer;
    x0, y0, r: integer;

  procedure PlacerInstrumentImage(i: integer; x0, y0, r: integer; angle: real);
  Begin
     InstrumentsPositionInImage[i-1] := Point(x0 + round(r*sin(angle)),y0 - round(r*cos(angle)));
  End;


begin
      for i := 0 to 127 do
         InstrumentsPositionInImage[i].X := -1;

      x0 := 100;
      y0 := 150;
      r := 80;

      {le piano}
      PlacerInstrumentImage(1, 40, 120, 0, 0.5);

      {les cordes}
      PlacerInstrumentImage(41, x0, y0, r, -0.8);
      PlacerInstrumentImage(42, x0, y0, r, -0.3);
      PlacerInstrumentImage(43, x0, y0, r, 0.1);
      PlacerInstrumentImage(44, x0, y0, r, 0.5);

      r := 100;
      for i := 0 to 10 do
              PlacerInstrumentImage(65+i, x0, y0, r, 1-i/5);

      r := 120;
      for i := 0 to 4 do
              PlacerInstrumentImage(57+i, x0, y0, r, -0.5+i/5);

      OnChargeLaListeDesInstruments := true;
      GetInstrumentStringList(cboInstruments.Items);//.LoadFromFile(DossierRacine + 'Instruments\GeneralMIDI.txt');
      OnChargeLaListeDesInstruments := false;
      bmpPortees := TBitmap.Create;
      bmpPortees.Width := panPortees.Width;
      bmpPortees.Height := panPortees.Height;
      bmpPortees.Canvas.Font.Name := 'Arial';
end;

procedure TfrmProprietesPortee.InstrumentAChanger(Sender: TObject);
begin
      


if cboInstruments.ItemIndex + 1 <> ImageInstrument.tag then
Begin
      ImageInstrument.tag := cboInstruments.ItemIndex + 1;



       With ImageInstrument do
       Begin
             Picture.Graphic := GetInstrument_Dessin(cboInstruments.ItemIndex);
             SetBounds(Left, Top, Picture.Width div 2, Picture.Height div 2);
       End;


      panInstrumentsPaint(nil);
End;

if Sender = cboInstruments then
       MettreAJourPortee(cboInstruments);

end;

procedure TfrmProprietesPortee.cboTranspositionChange(Sender: TObject);
var comportement: integer;
    PorteeEnCours: integer;
    interval, lastTransposition: TIntervalle;
begin

if Sender = cboTransposition then
Begin

         Choix_Reset;
         Choix_SetBlabla('Transposer la portée...');
         Choix_Ajouter('...en déplaçant graphiquement les notes, afin de ne pas changer ce qu''on entend');
         Choix_Ajouter('...sans déplacer les notes. Je m''étais trompé ou j''avais oublié de transposer avant.');
         comportement := Choix_Afficher;
         lastTransposition := CompEnCours.Portee_Transposition[ GetPorteeSelectionneeDebut];
         for PorteeEnCours := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do

          With CompEnCours do With Portee_Transposition[PorteeEnCours] do
          Begin
              if cboTransposition.Text = 'Do' then
              Begin
                    Portee_Transposition[PorteeEnCours] := HauteurNoteAvecHauteurEtAlteration(0,aNormal);
              end
              else if cboTransposition.Text = 'Si b' then
              Begin
                  Portee_Transposition[PorteeEnCours] := HauteurNoteAvecHauteurEtAlteration(-1,aBemol);

              End;

              if comportement = 0 then
              {si on demande de déplacer les notes}
               Begin
                   //on sélectionne les notes de la portée
                   tbnSelectElMusicauxClick(nil);

                   //on les déplace
                   interval := Intervalle(Portee_Transposition[PorteeEnCours], lastTransposition);
                   actchild.Selection_Transposer(interval);
               End;





          End;



     MettreAJourPortee(cboTransposition);
End;
actchild.Composition.CalcTout(true);
actchild.ReaffichageComplet;
end;

procedure TfrmProprietesPortee.cboInstrumentsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
if ssLeft in Shift then
       InstrumentAChanger(nil);
end;


procedure TfrmProprietesPortee.cboZoomChange(Sender: TObject);
var PorteeEnCours: integer;
begin
if Sender = cboZoom then
Begin
    for PorteeEnCours := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do
        CompEnCours.Portee_Taille[PorteeEnCours] := strtoint(cboZoom.text);
    MettreAJourFenetreEtPartition;
End;
end;



procedure TfrmProprietesPortee.Init_Utilisation_panPortees;
begin
      Zoom := ZoomPourApercuChoixPortee;
      CDevice := devApercu;
      SetViewCourantPixDeb(0, 0);
      ///SetViewCourantPixDeb(-140, 700);
      SetPixOrigin(0, 0);
      CompEnCours := actchild.Composition;
      
End;



procedure TfrmProprietesPortee.panPorteesPaint(Sender: TObject);

 procedure AfficherPortees;
 var p: integer;
     y1, y2: integer;
 
 Begin
      SetPixOrigin(0, 0);

      DrawLines_TOUTESLESPORTEES(CompEnCours, 0, 2500);

      for p := 0 to CompEnCours.NbPortees - 1 do
      Begin
           DrawClefDebutPortee_TOUTESLESPORTEES(CompEnCours, 220, p, CompEnCours.I_Portee_Clef[p]);
           SetFontSize(24);

           if CompEnCours.Portee_IsTablature(p) then
                 TextOut(500, GetY_TOUTESLESPORTEES(CompEnCours, p, 5),
                         'TAB : ' + CompEnCours.Portee_Groupe_Instrument_NomAAfficher(p))
           else
                 TextOut(500, GetY_TOUTESLESPORTEES(CompEnCours, p, 5),
                         CompEnCours.Portee_Groupe_Instrument_NomAAfficher(p));

           {l'affichage est approximatif dans le cas des tablatures etc... tant pis !}
           y1 := GetY_TOUTESLESPORTEES(CompEnCours, p, 4);
           y2 := GetY_TOUTESLESPORTEES(CompEnCours, p + CompEnCours.Portee_GetNbPorteesInGroupe(p), -4);

           DrawAccolade(200, y1, y2, ZoomPortee(p),
                        CompEnCours.Portee_GetTypeAccolade(p));


      End;

 End;


begin
  if CompEnCours <> nil then
  Begin
      Init_Utilisation_panPortees;

      MusicGraph_Canvas_Set(bmpPortees.Canvas);
      C.Brush.Color := clBtnFace;
      C.Brush.Style := bsSolid;
      C.FillRect(Rect(-1,-1,1000,1000));
      C.Brush.Color := clWhite;

      //on affiche un rectangle autour de la portée courante
      C.Pen.Width := 1;
      C.Pen.Color := 255;


      actchild.Composition.NumPorteeValide(PorteeSelectionnee1);
      actchild.Composition.NumPorteeValide(PorteeSelectionnee2);

      Rectangle(0,decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours,
                       GetPorteeSelectionneeDebut, 10),
                6400, decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours,
                       GetPorteeSelectionneeFin, -10));

      C.Pen.Color := 128;
      LineVertical(40,decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours, GetPorteeSelectionneeDebut, 9),
                     decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours, GetPorteeSelectionneeFin, -9) );

      C.Pen.Color := 192;
      LineVertical(80,decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours, GetPorteeSelectionneeDebut, 9),
                     decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours, GetPorteeSelectionneeFin, -9) );
      //on affiche la partition

      AfficherPortees;




    if ModeEditionPortee = mepDeplacerPortee then
    //on est en train de déplacer un amas de portées
    Begin
        C.Pen.Width := 2;
        C.Pen.Color := clBlue;

        if PorteeSousCurseur = CompEnCours.NbPortees then
        {si PorteeSousCurseur est en dehors de l'intervalle admissible,
        on affiche à l'ancienne :)}
             LineHorizontal(-600,6000,decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours, CompEnCours.NbPortees-1, -9))
             {pas de decalrectangle car AfficherPartition a fait un changement de repère}
        else
             LineHorizontal(-600,6000, decalrectangle + GetY_TOUTESLESPORTEES(CompEnCours, PorteeSousCurseur, 9));

    End;









     // Zoom := strtoint(MainForm.cboZoom.Text); à REVOIR
      CDevice := devEcran;

      panPortees.Canvas.Draw(0,0,bmpPortees);
  End;
end;

function TfrmProprietesPortee.GetPorteeSelectionnee(y:integer): integer;
{renvoit la portée qu'il  y a à l'ordonnée y. L'entier renvoyé est toujours
 dans l'intervalle admissible des indices des portées pour la composition
 en cours}
begin
    Init_Utilisation_panPortees;
    y := GetY(y) -  decalrectangle;
    result := (y) div nbpixentreportee;

    if result > CompEnCours.NbPortees - 1 then
        result := CompEnCours.NbPortees - 1;

    if result < 0 then
        result := 0;

    CompEnCours.VerifierIndicePortee(result, 'GetPorteeSelectionnee');
end;



function TfrmProprietesPortee.GetPorteeSelectionnee2(y:integer): integer;
{renvoit la portée qu'il  y a à l'ordonnée y.. contrairement à GetPorteeSelectionnee,
 ici, l'entier renvoyé peut éventuellement être le dernier indice admissible + 1,
 si y est trop grand (sert pour déplacer des portées}
var pos :TPosition;
begin
      Init_Utilisation_panPortees;
      y := GetY(y);
      GetPosition(y, CompEnCours, 0, pos);
      if pos.hauteur < -10 then
           inc(pos.portee);
      result := pos.portee;
end;


procedure TfrmProprietesPortee.panPorteesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

var nvportee_selectionnee_eventuelle: integer;

     Function Is_PorteeSelectionnee(ip: integer): Boolean;
     Begin
         result := (GetPorteeSelectionneeDebut <= ip)
                   and (ip <= GetPorteeSelectionneeFin);
     End;


begin


      Init_Utilisation_panPortees;
      if ModeEditionPortee = mepSelectionnerPortee then
      Begin
          nvportee_selectionnee_eventuelle := GetPorteeSelectionnee(y);

          if (ssLeft in Shift) or not Is_PorteeSelectionnee(nvportee_selectionnee_eventuelle) then
          Begin
              PorteeSelectionnee1 := GetPorteeSelectionnee(y);
              PorteeSelectionnee2 := PorteeSelectionnee1;
          End;
      End;
      MettreAJourFenetre(nil);
end;




procedure TfrmProprietesPortee.cboInstrumentsClick(Sender: TObject);
var MidiNowInstrumentThread: TMidiNowInstrumentThread;
begin
      MidiNowInstrumentThread := TMidiNowInstrumentThread.Create(cboInstruments.ItemIndex);
      
      if not OnChargeLaListeDesInstruments then
          InstrumentAChanger(Sender);


end;

procedure TfrmProprietesPortee.cboInstrumentsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var cbo: TListBox;
begin
      cbo := TListBox(Control);

      cbo.Canvas.Pen.Color := rgb(255,255,255);
      cbo.Canvas.Rectangle(Rect);
      MainForm.imgIconesInstruments.Draw(cbo.Canvas,Rect.Left, Rect.top,index+1);
      cbo.Canvas.TextOut(Rect.Left+20, Rect.top+1, cbo.Items[index]);
end;



procedure TfrmProprietesPortee.panPorteesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var newPorteeSelectionneeFin: integer;
begin


        if ssleft in Shift then
        Begin
            newPorteeSelectionneeFin := GetPorteeSelectionnee(y);
            if ModeEditionPortee = mepSelectionnerPortee then
            //on est en train de sélectionner des portées
            Begin

                if newPorteeSelectionneeFin <> PorteeSelectionnee2 then
                Begin
                    PorteeSelectionnee2 := newPorteeSelectionneeFin;
                    MettreAJourFenetre(nil);
                End;
            End
            else if ModeEditionPortee = mepDeplacerPortee then
            //on est en train de déplacer un amas de portées
            Begin
               newPorteeSelectionneeFin := GetPorteeSelectionnee2(y);
               if newPorteeSelectionneeFin <> PorteeSousCurseur then
                Begin
                    PorteeSousCurseur := newPorteeSelectionneeFin;
                    MettreAJourFenetre(nil);
                End;
            End;
        End
        else
        Begin
           newPorteeSelectionneeFin := GetPorteeSelectionnee(y);
           if (X < 8) and (newPorteeSelectionneeFin <= PorteeSelectionnee2)
                      and (PorteeSelectionnee1 <= newPorteeSelectionneeFin) then
           Begin
                panPortees.Cursor := crDeplacerPause;
                ModeEditionPortee := mepDeplacerPortee;
           End
           else
           Begin
                panPortees.Cursor := crDefault;
                ModeEditionPortee := mepSelectionnerPortee;
           End;
        End;
end;

procedure TfrmProprietesPortee.tbnAccoladeClick(Sender: TObject);
begin
      CompEnCours.Portees_Accolade_Mettre(GetPorteeSelectionneeDebut, GetPorteeSelectionneeFin);
      MettreAJourFenetreEtPartition;
end;



procedure TfrmProprietesPortee.Portees_Relier_Crochet(Sender: TObject);
begin
      CompEnCours.Portees_Crochet_Mettre(GetPorteeSelectionneeDebut, GetPorteeSelectionneeFin);
      MettreAJourFenetreEtPartition;
end;




procedure TfrmProprietesPortee.Portee_Ajouter_En_Haut(Sender: TObject);
begin
      actchild.Composition.Cancellation_Reset;
      CompEnCours.Portee_Ajouter(GetPorteeSelectionneeDebut, INSTRUMENT_PAR_DEFAUT, CLEF_PAR_DEFAUT);
      CompEnCours.CalcTout(true);
      MettreAJourFenetreEtPartition;
end;

procedure TfrmProprietesPortee.Portee_Supprimer(Sender: TObject);
begin
      case MessageDlg('Etes-vous sûr de vouloir supprimer les portées sélectionnées (attention, tu ne peux plus annuler après coup !!)?'
                          , mtWarning, [mbYes, mbNo], 0) of
              mrYes: Begin
                        actchild.Composition.Cancellation_Reset;
                        actChild.Composition.Portee_Supprimer(GetPorteeSelectionneeDebut);
                        actChild.Composition.CalcTout(true);
                        actchild.Composition.NumPorteeValide(PorteeSelectionnee1);
                        actchild.Composition.NumPorteeValide(PorteeSelectionnee2);
                        MettreAJourFenetreEtPartition;
              End;
      end;
end;

procedure TfrmProprietesPortee.Portee_Ajouter_En_Bas(Sender: TObject);
begin
      actchild.Composition.Cancellation_Reset;
      CompEnCours.Portee_Ajouter(GetPorteeSelectionneeDebut+1, INSTRUMENT_PAR_DEFAUT, CLEF_PAR_DEFAUT);
      CompEnCours.CalcTout(true);
      MettreAJourFenetreEtPartition;
end;

procedure TfrmProprietesPortee.FormActivate(Sender: TObject);
begin
      MettreAJourFenetre(nil);
end;

procedure TfrmProprietesPortee.cboVisibilityChange(Sender: TObject);
var PorteeEnCours: integer;
begin
      if Sender = cboVisibility then
      Begin
           for PorteeEnCours := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do
              CompEnCours.Portee_Visible[PorteeEnCours] :=
                      TPorteeVisibility(cboVisibility.ItemIndex);

      End;

End;

procedure TfrmProprietesPortee.cboClefChange(Sender: TObject);
begin
      if Sender = cboClef then
           MettreAJourPortee(cboClef);
      actchild.Composition.CalcTout(false);
      actchild.ReaffichageComplet;
end;

procedure TfrmProprietesPortee.panInstrumentsPaint(Sender: TObject);
var i:integer;
begin
      panInstruments.Canvas.Brush.Style := bsClear;
      for i := 0 to 127 do
         With InstrumentsPositionInImage[i] do
         Begin
             if X >= 0 then
                 MainForm.imgIconesInstruments.Draw(panInstruments.Canvas,X, Y,i+1);
             if i = cboInstruments.ItemIndex then
                 panInstruments.Canvas.Pen.Color := RGB(0,0,255)
             else
                 panInstruments.Canvas.Pen.Color := panInstruments.Color ;
                 panInstruments.Canvas.Rectangle(X, Y, X+16, Y+16);
         end;
end;


Function iInstrumentsSousCurseur(xx, yy: integer): integer;
{le mini-orchestre...}
var i: integer;
Begin
      for i := 0 to 127 do
      Begin
         with InstrumentsPositionInImage[i] do
         if (X <= xx) and (xx <= X + 16)
            and (Y <=yy) and (yy <= Y + 16) then
            Begin
                      result := i;
                      Exit;
            End;

      end;
      result := -1;
ENd;





procedure TfrmProprietesPortee.panInstrumentsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
 var i:integer;
begin
       i := iInstrumentsSousCurseur(X, Y);
       if i > -1 then
       Begin
            cboInstruments.ItemIndex := i;
            InstrumentAChanger(cboInstruments);
       End;

        panInstrumentsPaint(nil);

End;





procedure TfrmProprietesPortee.panPorteesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var dep, nbporteesselctionnees: integer;

begin


    if ModeEditionPortee = mepDeplacerPortee then
    Begin
        {on déplace les portées entre PorteeSelectionneeDebut et PorteeSelectionneeFin
        incluses entre la portée PorteeSousCurseur - 1 et PorteeSousCurseur

        (en somme la portée n° PorteeSelectionneeDebut deviendrait la portée la portée
        n° PorteeSousCurseur si on le supprimait pas}

        actchild.Composition.Cancellation_Reset;
        dep := actChild.Composition.Portees_Deplacer(GetPorteeSelectionneeDebut,
                                             GetPorteeSelectionneeFin,
                                             PorteeSousCurseur);
        actChild.Composition.CalcTout(true);
        nbporteesselctionnees := GetPorteeSelectionneeFin - GetPorteeSelectionneeDebut;
        PorteeSelectionnee1 := dep;
        PorteeSelectionnee2 := nbporteesselctionnees + dep;
        ModeEditionPortee := mepSelectionnerPortee;

        MettreAJourFenetreEtPartition;
    End;
end;

procedure TfrmProprietesPortee.tbnSelectElMusicauxClick(Sender: TObject);
begin
   With actchild.Composition do
   Begin
     Selection_ToutDeselectionner;
     Selection_SelectionnerPortees(GetPorteeSelectionneeDebut, GetPorteeSelectionneeFin);

   End;
   actChild.ReaffichageComplet;
end;

procedure TfrmProprietesPortee.Portees_Virer_Accolades(Sender: TObject);
begin
    CompEnCours.Portees_AccoladesCrochets_Enlever(GetPorteeSelectionneeDebut,
                                                  GetPorteeSelectionneeFin);

    MettreAJourFenetreEtPartition;
end;

procedure TfrmProprietesPortee.txtNomChange(Sender: TObject);
var PorteeEnCours: integer;
begin
    for PorteeEnCours := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do
        CompEnCours.Portee_Nom[PorteeEnCours] := txtNom.Text;

    MettreAJourFenetreEtPartition;
end;

procedure TfrmProprietesPortee.rdgTypePorteeClick(Sender: TObject);
var PorteeEnCours: integer;
begin
      if Sender = rdgTypePortee then
      Begin
           for PorteeEnCours := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do
              CompEnCours.Portee_Type[PorteeEnCours] := rdgTypePortee.ItemIndex;

      End;

      panClefEtTransposition.Visible := (rdgTypePortee.ItemIndex = 0);
      MettreAJourFenetreEtPartition;
end;






procedure TfrmProprietesPortee.cboInstrumentsMeasureItem(
  Control: TWinControl; Index: Integer; var Height: Integer);


begin
  MeasureItemGeneriquePourListeInstruments(
          txtInstrumentSubStr.Text, cboInstruments.Items[Index], Height);

end;

procedure TfrmProprietesPortee.txtInstrumentSubStrChange(Sender: TObject);
begin
GetInstrumentStringList(cboInstruments.Items);
cboInstruments.Repaint;
end;

procedure TfrmProprietesPortee.BitBtn3Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmProprietesPortee.cmdTablature_AddClick(Sender: TObject);
begin
      actchild.Composition.Cancellation_Reset;
      CompEnCours.Portee_Ajouter_Tablature(GetPorteeSelectionneeDebut);
      CompEnCours.CalcTout(true);
      MettreAJourFenetreEtPartition;
end;




procedure TfrmProprietesPortee.cmdTablature_SupprClick(Sender: TObject);
      Function RechercheIndicePortee_Tablature: integer;
      var ip: integer;
      Begin
          result := -1;

          for ip := GetPorteeSelectionneeDebut to GetPorteeSelectionneeFin do
            if CompEnCours.Portee_IsTablature(ip) then
                 result := ip;

      End;
begin
      actchild.Composition.Cancellation_Reset;


      CompEnCours.Portee_Supprimer(RechercheIndicePortee_Tablature);
      CompEnCours.CalcTout(true);

      actchild.Composition.NumPorteeValide(PorteeSelectionnee1);
      actchild.Composition.NumPorteeValide(PorteeSelectionnee2);
      MettreAJourFenetreEtPartition;
end;

end.
