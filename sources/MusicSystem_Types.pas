unit MusicSystem_Types;

interface

uses MusicHarmonie;


type TArrayBool = array of Boolean;




{ce type modélise la position graphique d'une note}
TPosition = record
    portee, //indice de la portée où se trouve l'objet
    hauteur :integer;
      {position, dans la portee.
      ex : En clef de sol, le si moyen a pour hauteur 0
                           le do1 a pour hauteur 1
                           le do central a pour hauteur -6}

end;


      {type du champ qui dit si un objet est sélectionné ou pas}
TSelectionValeur = (svDeselectionnee, svSelectionnee, svFraichementSelectionnee);



{une note}
TNote = record
    position: TPosition; {la partie "hauteur" se calculera à partir de HauteurNote
                              dans CalcGraph    }

    tablature_position: TPosition;
    
    HauteurNote: THauteurNote;
    AfficherAlteration: Boolean; {doit-on afficher l'altération ?
                                ==> se calcule dans CalcGraphMesure}

    BouleADroite: Byte;
    {bit 1 : BouleADroite si boule à droite de la hampe
     bit 2 : lié à la suivante
    }

    doigtee: Byte;
    piano_doigtee: Byte;
    
    Selectionne: TSelectionValeur; {la note est-elle sélectionnée ?}
end;



TPNote = ^TNote;

{type qui dit de quel côté de la hampe se trouve la note}
TBouleCote = (bcDroite, bcGauche, bcMixte);




TAttributsElMusical = record
         Style1: Byte;
         Style2: Byte;
         Volume: Byte;
         PetitesNotes: ByteBool;
end;




Function Position_Creer(ip, ih: integer): TPosition;

Function IsPositionsEgales(p1, p2: TPosition): Boolean;
Function IsPositionsTresProches(p1, p2: TPosition): Boolean;
Function IsNotesEgales(n1, n2: TNote): Boolean;

Function IsPosition1Inf2(p1, p2: TPosition): Boolean;

Function IsPositionSurLigne(p: TPosition): Boolean;
Function Position_DeplacerPourEviterSurLigne(p: TPosition): TPosition;


Procedure Note_MettreAJourPositionHauteurPartition(var n: TNote; infoclef: TInfoClef);




implementation


Function IsPositionsEgales(p1, p2: TPosition): Boolean;
//renvoie vrai quand "p1 = p2"
Begin
result := (p1.portee = p2.portee) and (p1.hauteur = p2.hauteur);

End;



Function IsPositionsTresProches(p1, p2: TPosition): Boolean;
//renvoie vrai quand p1, p2 sont proches (ex : bouboules pour décaler)
Begin
result := (p1.portee = p2.portee) and (abs(p1.hauteur - p2.hauteur) = 1);

End;


Function IsNotesEgales(n1, n2: TNote): Boolean;
Begin
result := (n1.hauteurnote.alteration = n2.hauteurnote.alteration) and
               IsPositionsEgales(n1.position, n2.position);
               

End;


Function IsPosition1Inf2(p1, p2: TPosition): Boolean;
//renvoit vrai quand "p1 < p2"
Begin
result := (p1.portee > p2.portee) or
                      ((p1.portee = p2.portee) and (p1.hauteur < p2.hauteur));

End;


Function Position_Creer(ip, ih: integer): TPosition;
Begin
    result.portee := ip;
    result.hauteur := ih;
End;




Function IsPositionSurLigne(p: TPosition): Boolean;
Begin
     result := (p.hauteur mod 2 = 0);
End;



Function Position_DeplacerPourEviterSurLigne(p: TPosition): TPosition;
Begin
    if p.hauteur mod 2 = 0 then
       inc(p.hauteur);
    result := p;
    
End;




Procedure Note_MettreAJourPositionHauteurPartition(var n: TNote; infoclef: TInfoClef);
Begin
    n.position.hauteur := HauteurAbsToHauteurGraphique(infoclef, n.HauteurNote.Hauteur);
    
End;

end.
