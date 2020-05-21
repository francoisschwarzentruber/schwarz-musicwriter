unit langues;

interface

uses Forms, Classes;

type TLangue = (langueFrancais, langueEnglish);


Function Langues_LangueCourante_ChoperDeLaConfigurationCourante: TLangue;
procedure Langues_LangueCourante_EcrireDansLaConfiguration(langue: TLangue);


procedure Langues_Traduction_Charger;
procedure Langues_LangueCourante_Set(langue: TLangue);
procedure Langues_TraduireFenetre(fenetre: TForm);
Function Langues_Traduire(s: string): string;
Function Langues_Traduire_Avec_Args(s: string; const Args: array of const): string;

Function Langues_NomNote_Get(note_i: integer): string;

Function Langues_Debug_MotsNonTraduits_Get: TStrings;


implementation


uses Controls, StdCtrls, ComCtrls, ExtCtrls, Menus, SysUtils,
     MusicUser {pour DossierRacine},
     MusicWriter_Erreur;

var traductions: array of array[TLangue] of string;
    langue_courante: TLangue = langueFrancais;
    motsnontraduits: TStringList;


const langues_noms: array[0..1] of string = ('Français', 'English');
const Langues_Fichier = 'interface_langues\langue_courante.txt';



Function Langues_Debug_MotsNonTraduits_Get: TStrings;
Begin
    result := motsnontraduits;
End;

procedure Langues_LangueCourante_EcrireDansLaConfiguration(langue: TLangue);
var s: TStringList;
begin
     s := TStringList.Create;

     s.Add(langues_noms[integer(langue)]);

     s.SaveToFile(DossierRacine + Langues_Fichier);

End;




Function Langues_LangueCourante_ChoperDeLaConfigurationCourante: TLangue;
var s: TStringList;
    i: integer;
begin
     motsnontraduits := TStringList.Create;
     s := TStringList.Create;

     result := langueFrancais;

     if not FileExists(DossierRacine + Langues_Fichier) then
            Exit;

     s.LoadFromFile(DossierRacine + Langues_Fichier);


     for i := 0 to 1 do
           if s.Strings[0] = langues_noms[i] then
           Begin
                langue_courante := TLangue(i);
                result := langue_courante;
                exit;
           End;

     s.Free;

End;

procedure Langues_Traduction_Charger;
var s: TStringList;
    t: string;
    i, p: integer;

    procedure Traductions_Init;
    Begin
        setlength(traductions, 0);
    End;

    procedure Traductions_Ajouter(francais, english: string);
    var l: integer;
    Begin
        l := length(traductions);
        setlength(traductions, l+1);
        traductions[l][langueFrancais] := francais;
        traductions[l][langueEnglish] := english;
    End;


Begin
     s := TStringList.Create;
     try
          s.LoadFromFile(DossierRacine + 'interface_langues\traductions.txt');
     except
          MessageErreur('Impossible de charger le fichier qui contient les traductions !! (' +
                         DossierRacine + 'interface_langues\traductions.txt)');
     end;
     Traductions_Init;

     for i := 0 to s.Count - 1 do
     Begin
           t := s.Strings[i];
           p := pos(Chr(9), t);
           if (p > 0) then
                   Traductions_Ajouter(Copy(t, 1, p-1), Copy(t, p+1, 10000));
     End;

     s.Free;
End;



procedure Langues_LangueCourante_Set(langue: TLangue);
Begin
    langue_courante := langue;
end;




procedure TraductionNonDisponiblePour(s: string);
Begin
      motsnontraduits.Add(s);

End;



Function Langues_Traduire(s: string): string;
var i: integer;
Begin
      result := s;
      for i := 0 to high(traductions) do
            if s = traductions[i][langueFrancais] then
            Begin
                   result := traductions[i][langue_courante];
                   exit;
            End;

      TraductionNonDisponiblePour(s);
End;





procedure Langues_TraduireControle(c: TComponent);
var i: integer;
Begin
     if c is TLabel then
           (c as TLabel).Caption := Langues_Traduire((c as TLabel).Caption)
     else if c is TCheckbox then
           (c as TCheckbox).Caption := Langues_Traduire((c as TCheckbox).Caption)
     else if c is TTabSheet then
           (c as TTabSheet).Caption := Langues_Traduire((c as TTabSheet).Caption)
     else if c is TToolButton then
           (c as TToolButton).Caption := Langues_Traduire((c as TToolButton).Caption)
     else if c is TMenuItem then
           (c as TMenuItem).Caption := Langues_Traduire((c as TMenuItem).Caption)
     else if c is TButton then
           (c as TButton).Caption := Langues_Traduire((c as TButton).Caption)
     else if (c is TTreeView) then
     Begin
           With (c as TTreeView) do
                  for i := 0 to Items.Count - 1 do
                         Items.Item[i].Text := Langues_Traduire(Items.Item[i].Text);
     End
     else if (c is TCoolBar) then
     Begin
         With (c as TCoolBar) do
            for i := 0 to Bands.Count - 1 do
                Bands[i].Text := Langues_Traduire(Bands[i].Text);
     end
     else if (c is TWinControl) then
     Begin
         if c is TPanel then
           (c as TPanel).Caption := Langues_Traduire((c as TPanel).Caption);

          With (c as TWinControl) do
          Begin
              for i := 0 to ComponentCount - 1 do
                   Langues_TraduireControle(Components[i]);
          End
     End



End;


procedure Langues_TraduireFenetre(fenetre: TForm);
var i: integer;
Begin
      fenetre.Caption := Langues_Traduire(fenetre.Caption);

      for i := 0 to fenetre.ComponentCount - 1 do
            Langues_TraduireControle(fenetre.Components[i]);

                                                                
End;




Function Langues_Traduire_Avec_Args(s: string; const Args: array of const): string;
Begin
    result := Format(Langues_Traduire(s), Args);
End;



Function Langues_NomNote_Get(note_i: integer): string;
const NomNote: array[0..6] of string = ('do', 'ré', 'mi', 'fa', 'sol', 'la', 'si');
const NoteName: array[0..6] of string = ('C', 'D', 'E', 'F', 'G', 'A', 'B');
Begin
     case langue_courante of
        langueFrancais: result := NomNote[note_i];
        langueEnglish: result := NoteName[note_i];
     end;
End;

end.
