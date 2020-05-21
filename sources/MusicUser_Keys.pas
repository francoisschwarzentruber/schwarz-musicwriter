unit MusicUser_Keys;

interface

uses MusicSystem, MusicHarmonie;

{ancienne touche...'v', 'b', 'n', '#', '''}
{const KEY_DbBemol = 86;
      KEY_Bemol   = 66;
      KEY_Becar   = 78;
      KEY_Diese   = 51;
      KEY_DbDiese = 52; }




Function IsClavierElectroniqueActive: Boolean;
Procedure ClavierElectronique_ActiverOuPas(b: Boolean);


Function KeyToAlteration(key: word; var a: TAlteration): boolean;
Function KeyToNombreDemiTonPourHauteurNote(key: word; var nb: integer): Boolean;

Function IsKeyGuitare(key: word; var numero_case: integer):Boolean;
Function IsKeyNormalNumerique(key: word; var  i: integer): Boolean;
Function IsKeyPaveNumerique(key: word; var i: integer): Boolean;




implementation



uses Options_SaveAndLoad, DIalogs, SysUtils, MusicUser {pour Outil_MettreNoteIsModeClavier};

const 
      KEY_DbBemol = 222;
      KEY_Bemol   = 49;
      KEY_Becar   = 50;
      KEY_Diese   = 51;
      KEY_DbDiese = 52;

      KEY_Do = 226;
      KEY_Re = 87;
      KEY_Mi = 88;
      KEY_Fa = 67;
      KEY_Sol = 86;
      KEY_La = 66;
      KEY_Si = 78;

      KEY_DoDiese = 81;
      KEY_ReDiese = 83;
      KEY_FaDiese = 70;
      KEY_SolDiese = 71;
      KEY_LaDiese = 72;



      KEY_Do2 = 188;
      KEY_Re2 = 190;
      KEY_Mi2 = 191;
      KEY_Fa2 = 223;
      KEY_Sol2 = 16;

      KEY_DoDiese2 = 75;
      KEY_ReDiese2 = 76;
      KEY_FaDiese2 = 192;


Function KeyToAlteration(key: word; var a: TAlteration): boolean;
{renvoie vrai si la  touche du clavier appuyé correspond à une altération}

var yab: boolean;

Begin
      yab := true;
      case Key of
          KEY_Bemol: a := aBemol;
          KEY_DbBemol: a := aDbBemol;
          KEY_Becar: a := aNormal;
          KEY_Diese: a := aDiese;
          KEY_DbDiese: a := aDbDiese;
          else yab := false;
      end;

      result := yab;
End;




Function IsClavierElectroniqueActive: Boolean;
Begin
      result := Outil_MettreNoteIsModeClavier and option_ClavierElectroniqueActive;
      
End;



Procedure ClavierElectronique_ActiverOuPas(b: Boolean);
Begin
    option_ClavierElectroniqueActive := b;
End;


Function KeyToNombreDemiTonPourHauteurNote(key: word; var nb: integer): Boolean;
{renvoie vrai si la touche appuyée correspond à une touche du "clavier piano"
  Dans ce cas, remplit hn

 sinon renvoie faux et hn est arbitraire}
Begin
    //ShowMessage(inttostr(key));
    result := true;
    case key of
        KEY_Do: nb := 0;
        KEY_DoDiese: nb := 1;
        KEY_Re: nb := 2;
        KEY_ReDiese: nb := 3;
        KEY_Mi: nb := 4;
        KEY_Fa: nb := 5;
        KEY_FaDiese: nb := 6;
        KEY_Sol: nb := 7;
        KEY_SolDiese: nb := 8;
        KEY_La: nb := 9;
        KEY_LaDiese: nb := 10;
        KEY_Si: nb := 11;
        KEY_Do2: nb := 12;
        KEY_DoDiese2: nb := 13;
        KEY_Re2: nb := 12+2;
        KEY_ReDiese2: nb := 12+3;
        KEY_Mi2: nb := 12+4;
        KEY_Fa2: nb := 12+5;
        KEY_FaDiese2: nb := 12+6;
        KEY_Sol2: nb := 12+7;
        else result := false;
    end;

End;



Function IsKeyGuitare(key: word; var numero_case: integer):Boolean;
Begin
      result := true;
      case Key of
           222: numero_case := 0;
           49..57: numero_case := Key - 48;
           else
                result := false;
      end;

End;



Function IsKeyPaveNumerique(key: word; var  i: integer): Boolean;
Begin
    result := true;

    {pavé numérique pour mon ordi portable}
    case Key of
        word('J'): i := 1;
        word('K'): i := 2;
        word('L'): i := 3;
        word('U'): i := 4;
        word('I'): i := 5;
        word('O'): i := 6;
        word('7'): i := 7;
        word('8'): i := 8;
        word('9'): i := 9;
        else result := false;
    end;
    
    if result then exit;

    result := (96 <= Key) and (Key <= 105);
    if result then
           i := Key - 96;
End;


Function IsKeyNormalNumerique(key: word; var  i: integer): Boolean;
Begin
    result := (48 <= Key) and (Key <= 57);
    if result then
           i := Key - 48;
End;







end.
