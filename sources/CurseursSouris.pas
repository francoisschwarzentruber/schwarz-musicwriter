unit CurseursSouris;

interface

uses MusicHarmonie, Controls {pour TCursor};

const
      crClefDeSol = 1;
      crClefDeFa = 2;
      crDiese = 3;
      crBecar = 4;
      crBemol = 5;
      crFlecheRetournee = 6;
      crtaillerliaisoncroche = 7;
      crtaillerqueue = 8;
      crDeplacer = 9;
      crDeplacerPause = 10;
      crDeplacerPlus = 11;
      crNothing = 12;
      crAddNote = 13;

      crOctavieur1 = 14;
      crOctavieur0 = 15;
      crOctavieur_1 = 16;

      crCurseurSourisSpecial = 17;

      crCurseurNormal = 18;
      crCurseurNormal_VoixFixe = 19;
      
      crCurseur_Magnetophone_Lecture = 20;
      crCurseur_Magnetophone_Pause = 21;




      
procedure CurseursSouris_Charger;
Function ClefToCursor(c: TClef): TCursor;
Function OctavieurToCursor(o: integer): TCursor;
Function AlterationToCursor(a: TAlteration): integer;

Function CurseursSouris_AddNote_Curseur_Get: integer;




var option_NoteAInsererAUneGrappe_Souris_Curseur: integer;





implementation


uses Forms {pour Screen}, Windows {pour LoadCursorFromFile}, MusicWriter_Erreur;



procedure CurseursSouris_Charger;
Begin
          {chargement des curseurs}

      Screen.Cursors[crClefDeSol]               := LoadCursorFromFile('interface_curseurs\001.clef de sol.cur');
      Screen.Cursors[crClefDeFa]                := LoadCursorFromFile('interface_curseurs\002.clef de fa.cur');
      Screen.Cursors[crDiese]                   := LoadCursorFromFile('interface_curseurs\003.dièse.cur');
      Screen.Cursors[crBecar]                   := LoadCursorFromFile('interface_curseurs\004.bécar.cur');
      Screen.Cursors[crBemol]                   := LoadCursorFromFile('interface_curseurs\005.bémol.cur');
      Screen.Cursors[crFlecheRetournee]         := LoadCursorFromFile('interface_curseurs\006.flecheretournee.cur');
      Screen.Cursors[crtaillerliaisoncroche]    := LoadCursorFromFile('interface_curseurs\007.taillerliaisoncroche.cur');
      Screen.Cursors[crtaillerqueue]            := LoadCursorFromFile('interface_curseurs\008.taillerqueue.cur');
      Screen.Cursors[crDeplacer]                := LoadCursorFromFile('interface_curseurs\009.Deplacer.cur');
      Screen.Cursors[crDeplacerPause]           := LoadCursorFromFile('interface_curseurs\010.DeplacerPause.cur');
      Screen.Cursors[crDeplacerPlus]            := LoadCursorFromFile('interface_curseurs\011.Deplacer+.cur');
      Screen.Cursors[crNothing]                 := LoadCursorFromFile('interface_curseurs\012.Nothing.cur');
      Screen.Cursors[crAddNote]                 := LoadCursorFromFile('interface_curseurs\013.Addnote.cur');

      Screen.Cursors[crOctavieur0]              := LoadCursorFromFile('interface_curseurs\014.Octavieur0.cur');
      Screen.Cursors[crOctavieur1]              := LoadCursorFromFile('interface_curseurs\015.Octavieur1.cur');
      Screen.Cursors[crOctavieur_1]             := LoadCursorFromFile('interface_curseurs\016.Octavieur_1.cur');
      Screen.Cursors[crCurseurSourisSpecial]    := LoadCursorFromFile('interface_curseurs\017.curseur_special.cur');
      Screen.Cursors[crCurseurNormal]           := LoadCursorFromFile('interface_curseurs\018.curseur_normal.cur');

      Screen.Cursors[crCurseurNormal_VoixFixe]  := LoadCursorFromFile('interface_curseurs\019.curseur_normal_voix_fixe.cur');

      Screen.Cursors[crCurseur_Magnetophone_Lecture]  := LoadCursorFromFile('interface_curseurs\020.enlecture.cur');
      Screen.Cursors[crCurseur_Magnetophone_Pause]  := LoadCursorFromFile('interface_curseurs\021.enpause.cur');
End;



Function ClefToCursor(c: TClef): TCursor;
{à partir d'une clef, rend un numéro de curseur souris

 ex : avec une clé de sol (c = ClefSol), renvoie l'image du curseur de clé de sol
       identifié par crClefDeSol
       }

Begin
    if c = ClefSol then
           result := crClefDeSol
    else
           result := crClefDeFa;
End;



Function OctavieurToCursor(o: integer): TCursor;
Begin
    case o of
       0: result := crOctavieur0;
       1: result := crOctavieur1;
       -1: result := crOctavieur_1;
       else
       Begin
            MessageErreur('Arf !! Cas non géré dans OctavieurToCursor');
            result := crFlecheRetournee;
       End;
    end;

End;



Function AlterationToCursor(a: TAlteration): integer;
Begin
    case a of
         aNormal: result := crBecar;
         aBemol: result := crBemol;
         aDiese: result := crDiese;
         else
         Begin
              MessageErreur('Arf !! Cas non géré dans AlterationToCursor');
              result := crBecar;
         End;
    end
End;



Function CurseursSouris_AddNote_Curseur_Get: integer;
Begin
    if option_NoteAInsererAUneGrappe_Souris_Curseur = 0 then
         result := crCurseurNormal
    else
         result := crAddNote;
End;

end.
