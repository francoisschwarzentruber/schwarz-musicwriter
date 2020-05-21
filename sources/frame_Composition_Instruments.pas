{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P-,Q+,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit frame_Composition_Instruments;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MusicSystem_Composition;

type

  TOnChange = procedure of Object;

  TframeComposition_Instruments = class(TFrame)
    list: TListBox;
    procedure listDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure listClick(Sender: TObject);
    procedure listMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure listMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
      
  private
    FOnChange: TOnChange;
    private_compositionlecture: Boolean;
    private_Is_Oreille, private_Is_Oeil: Boolean;
    Function CompositionGet: TComposition;
    { Déclarations privées }

    procedure LancerOnChange;

    
  public

    procedure MettreAJour;
    Function GetInstrument_Portee: integer;
    procedure GetPortees(out p1, p2: integer);
    Function GetPortees_To_Str: string;
    Function GetInstrument_To_Str: string;

    Procedure AvecOeilEtOreille;
    Procedure AvecOreille;

    Procedure Informer_CompositionLecture;


    constructor Create;


  published
     property OnChange: TOnChange Read FOnChange Write FOnChange;
    { Déclarations publiques }
  end;

  
implementation

uses MusicSystem_Composition_Portees_Liste, Main,
     MusicGraph_Images, Message_Vite_Fait,
     Magnetophone,
     MusicGraph, MusicSystem_CompositionBase,
          MusicUser_PlusieursDocuments;

{$R *.dfm}


procedure TframeComposition_Instruments.AvecOeilEtOreille;
Begin
     private_Is_Oreille := true;
     private_Is_Oeil := true;
End;



procedure TframeComposition_Instruments.AvecOreille;
Begin
     private_Is_Oreille := true;
End;



constructor TframeComposition_Instruments.Create;
Begin
     private_Is_Oreille := false;
     private_Is_Oeil := true;
     private_compositionlecture := false;
End;



Procedure TframeComposition_Instruments.Informer_CompositionLecture;
Begin
     private_compositionlecture := true;
End;

procedure TframeComposition_Instruments.MettreAJour;
var ip: integer;
    last_list_ItemIndex: integer;
    
    function Portees_Numero_To_Str: string;
    var p1, p2: integer;
    Begin
        p1 := ip;
        p2 := p1 + CompositionGet.Portee_GetNbPorteesInGroupe(ip);

        if p1 = p2 then
             result := inttostr(p1 + 1)
        else
             result := inttostr(p1 + 1) + ' - ' + inttostr(p2 + 1);
             
    End;


Begin
    last_list_ItemIndex := list.ItemIndex;
    list.clear;

    if CompositionGet = nil then
          exit;
          
    ip := 0;
    With CompositionGet do
    while ip <= NbPortees - 1 do
    Begin
        
        list.AddItem( Portees_Numero_To_Str + '. ' +
                      Portee_Groupe_Instrument_NomAAfficher(ip), TObject(ip)
                      ); 
        Inc(ip, Portee_GetNbPorteesInGroupe(ip) + 1);
        
    End;

    list.ItemIndex := last_list_ItemIndex;
    if list.ItemIndex = -1 then
        list.ItemIndex := 0;
End;




procedure TframeComposition_Instruments.GetPortees(out p1, p2: integer);
var i:integer;
Begin
    i := list.ItemIndex;

    p1 := integer(list.Items.Objects[i]);
    p2 := p1 + CompositionGet.Portee_GetNbPorteesInGroupe(p1);
End;



Function TframeComposition_Instruments.GetInstrument_Portee: integer;
Begin
    if list.ItemIndex = -1 then
         result := -1
    else
         result := integer(list.Items.Objects[list.ItemIndex]);
End;


Function TframeComposition_Instruments.GetPortees_To_Str: string;
var p1, p2: integer;
Begin
     GetPortees(p1, p2);

     if p1 = p2 then
          result := 'de la portée ' + inttostr(p1 + 1)
     else
         result := 'des portées ' + inttostr(p1 + 1) + ' - ' + inttostr(p2 + 1);
ENd;


Function TframeComposition_Instruments.GetInstrument_To_Str: string;
Begin
     result := list.Items[list.ItemIndex]
End;

Function TframeComposition_Instruments.CompositionGet: TComposition;
Begin
    if private_compositionlecture then
    Begin
         if not Magnetophone_IsConnected then
                result := nil
         else
                result := Magnetophone_actPlayChild_Get.Composition;
    End
    else
    Begin
        if not MusicWriter_IsFenetreDocumentCourante then
             result := nil
        else
        result := actchild.Composition;
    End;
End;



procedure TframeComposition_Instruments.listDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
  var i_instru_portee, i_instrument: integer;
begin
      if CompositionGet = nil then exit;

      i_instru_portee := integer(list.Items.Objects[Index]);
      i_instrument := CompositionGet.Portee_InstrumentMIDINum[i_instru_portee];
      list.Canvas.Pen.Color := rgb(255,255,255);
      list.Canvas.Rectangle(Rect);
      MainForm.imgIconesInstruments.Draw(list.Canvas,Rect.Left, Rect.top,i_instrument+1);
      list.Canvas.TextOut(Rect.Left+20, Rect.top+1, list.Items[index]);


      if private_Is_Oreille and private_Is_Oeil then
      Begin
          list.Canvas.Draw(Rect.Right - 35, Rect.Top+1, imgOeil);

          if not actchild.View.PorteeAffichee[i_instru_portee] then
               list.Canvas.Draw(Rect.Right - 35, Rect.Top+1, imgCroix);
      End;

      if private_Is_Oreille then
      Begin
          list.Canvas.Draw(Rect.Right - 19, Rect.Top+1, imgOreille);

          if not actchild.View.PorteeEntendue[i_instru_portee] then
               list.Canvas.Draw(Rect.Right - 19, Rect.Top+1, imgCroix);
      End;
end;

procedure TframeComposition_Instruments.listClick(Sender: TObject);
begin
    LancerOnChange;



end;


procedure TframeComposition_Instruments.LancerOnChange;
Begin
    if @FOnChange <> nil then
       OnChange;
End;

procedure TframeComposition_Instruments.listMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    if ssLeft in Shift then
         LancerOnChange;
end;

procedure TframeComposition_Instruments.listMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const largeurcase = 16;
var n_instru_portee: integer;
    ip: integer;
    valeur_booleenne: Boolean;




    Function View_Gestionnaire_Affichage_Portee_GetDescription(View: TView; Composition: TComposition): string;
    const Gestionnaire_Affichage_Portee_Toutes = -1;

    var j, nb_portees_affichees: integer;
        seule_portee_affichee_siya: integer;

    Begin

           for j := 0 to list.Items.Count - 1 do
            Begin
                  ip := integer(list.Items.Objects[j]);

                  if actchild.View.PorteeAffichee[ip] then
                  Begin
                       inc(nb_portees_affichees);
                       seule_portee_affichee_siya := ip;

                  End;

            End;


            if nb_portees_affichees = 1 then
                 result := Composition.Portee_Groupe_Instrument_NomAAfficher_DansGestionnaireAffichage(seule_portee_affichee_siya)
            else if nb_portees_affichees = list.Items.Count then
                 result := Composition.Portee_Groupe_Instrument_NomAAfficher_DansGestionnaireAffichage(Gestionnaire_Affichage_Portee_Toutes)
            else
                 result := 'affichage personnalisée';

    End;





    Function Regarder_Si_Instrument_Courant_Le_Seul_Affiche(instrument_courant: integer): Boolean;
    var j, ip: integer;
    Begin
            result := true;
            for j := 0 to list.Items.Count - 1 do
            Begin
                  ip := integer(list.Items.Objects[j]);
                  if ip <> instrument_courant then
                  if actchild.View.PorteeAffichee[ip] then
                      result := false;  
            End;
    End;
    
begin
      if list.ItemIndex = -1 then exit;

      n_instru_portee := integer(list.Items.Objects[list.ItemIndex]);

      if (X > list.ClientWidth - largeurcase) and private_Is_Oreille then
      Begin
          valeur_booleenne := not actchild.View.PorteeEntendue[n_instru_portee];

          for ip := n_instru_portee to
                    n_instru_portee + CompositionGet.Portee_GetNbPorteesInGroupe(n_instru_portee) do
                 actchild.View.PorteeEntendue[ip] := valeur_booleenne;




      End
      else if (X > list.ClientWidth - 2*largeurcase) and private_Is_Oeil and private_Is_Oreille then
      {on clique pour dire que l'instrument est ou n'est pas affiché}
      Begin
          valeur_booleenne := not actchild.View.PorteeAffichee[n_instru_portee];

          {on vérifie que ce n'est pas le seul instrument visible}
          if Regarder_Si_Instrument_Courant_Le_Seul_Affiche(n_instru_portee) and not valeur_booleenne then
                Message_Vite_Fait_Beep_Et_Afficher('Non! Si tu rends invisible cet instrument, il n''y aura plus rien à afficher à l''écran. C''est stupide !')
          else
          Begin

              for ip := n_instru_portee to
                        n_instru_portee + CompositionGet.Portee_GetNbPorteesInGroupe(n_instru_portee) do
                     actchild.View.PorteeAffichee[ip] := valeur_booleenne;



              actChild.panInstruments_Portees.Caption := View_Gestionnaire_Affichage_Portee_GetDescription(actchild.View, CompositionGet);
              actChild.Composition.CalcTout(true);
              actChild.ReaffichageComplet;
          End;
      End;

      list.Repaint;
end;

end.
