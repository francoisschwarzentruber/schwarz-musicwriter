unit MusicSystem_ElMusical_Liste_Notes;



     
interface



uses QSystem {pour pouvoir parler d'une durée d'un él. musical},
     MusicHarmonie {pour THauteurNote},
     Types {pour TRect},
     MusicSystem_Types {pour TNote},
     MusicSystem_ElMusical_Duree;



type





{un élément musical, c'est une pause, une note ou un accord}
TElMusical_Liste_Notes = class(TElMusical_Duree)
{le tableau des notes
   s'il est vide, l'el. mus. est une pause
   s'il y a un élément, l'el. mus. est une note
   s'il y a plus d'un élément, l'el. mus. est un accord}
      Notes: array of TNote;

public
    QueueVersBas: Boolean;
    position: TPosition;

    Function NbNotes: integer;

    Function GetNoteHaut: TNote;
    Function GetNote(n: integer): TNote;
    procedure SupprimerToutesLesNotes;
    Function IsSilence: Boolean;
    {renvoie vrai ssi l'él. mus. est un silence}


    Function AddNoteSub(Note:TNote): Boolean;
    { rajoute une note au groupe de note en cours,
  renvoit "vrai" si l'opération réussit
  (l'opération peut échouer si il y avait déjà une note à cette position)

    Attention : Cette fonction ne calcule pas les positions des boules...
                il faut appeler CalcGDBoules à la fin des traitements
                pour rendre l'él. mus. joli}

    Function AddNote(Note:TNote):Boolean;
    {itou mais tout est beau}

    Function AddNote2(pos:TPosition; hn: THauteurNote):Boolean;
    {itou}

    procedure AddNotesAutreElMusical(el: TElMusical_Liste_Notes);




    Procedure DelNote2(n: integer);
    {supprime la note d'indice n}

    Function DelNote(Pos: TPosition):Boolean;
    {tente de supprimer une note présente à la position Pos
     renvoie vrai ssi il y avait effectivement une note, ssi il y a bien eu
     une suppression}

    Function PosNoteBas: TPosition;
    {renvoie la position :
          - de la note la plus basse, si c'est un accord
          - de la position de la pause, si c'est une pause
          }

    Function PosNoteHaut: TPosition;
    {itou en haut}

    Procedure CalcGDBoules;
    {calcul de quel côté (par rapport à la hampe) se trouve les boules
     des différentes notes}

     Procedure ClasserBoules;
    {réalise un tri sur les positions graphiques des notes
      précondition : il faut que les positions graphiques soient remplies}

    Function GetBoulesCotes: TBouleCote;

    procedure CopierLesNotesAPartirDe(el: TElMusical_Liste_Notes);


    Function HauteurNoteNoteBas: THauteurNote;
    Function HauteurNoteNoteHaut: THauteurNote;

protected
   procedure VerifierIndiceNote(var n : integer);

protected
  BoulesCotes: TBouleCote;

private
  Procedure CalcBoulesCotes;

end;






implementation

uses MusicWriter_Erreur,
     SysUtils {pour inttostr dans les message d'erreurs},
     FileSystem {pour SetPr},
     MusicSystem_Constantes {pour naBouleADroite},
     tablature_system {Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature}
     ;

Procedure TElMusical_Liste_Notes.SupprimerToutesLesNotes;
Begin
    SetLength(Notes, 0);

End;






Function TElMusical_Liste_Notes.NbNotes: integer;
Begin
    if IsSilence then
    Begin
          MessageErreur('Erreur. C''est mal de demander combien de notes a un ' +
                       'silence.');
          result := 0;
    End
    else
          result := length(Notes);
End;



Function TElMusical_Liste_Notes.GetNote(n: integer): TNote;
Begin
    VerifierIndiceNote(n);
    result := Notes[n];
End;



Function TElMusical_Liste_Notes.GetNoteHaut: TNote;
Begin
    if IsSilence then
        MessageErreur('erreur dans GetNoteHaut, car c''est un silence');

    result := Notes[high(Notes)];
End;



procedure TElMusical_Liste_Notes.AddNotesAutreElMusical(el: TElMusical_Liste_Notes);
var n: integer;
Begin
    if not el.IsSilence then
         for n := 0 to el.NbNotes - 1 do
               AddNote(el.GetNote(n));
End;



procedure TElMusical_Liste_Notes.VerifierIndiceNote(var n : integer);
Begin
    if (n < 0) or (n > high(Notes)) then
    Begin
        MessageErreur('Erreur d''accès à une note d''un élément musical... l''indice ' +
              inttostr(n) + ' est incorrect... les indices vont de 0 à ' +
              inttostr(high(Notes)) + '.');
        n := 0;
    End;
End;

//TElMusical suite ...(l'ancien TNotes)
//******************************************************************************


Function TElMusical_Liste_Notes.AddNoteSub(Note:TNote): Boolean;
{ rajoute une note au groupe de note en cours,
  renvoit "vrai" si l'opération réussit
  (l'opération peut échouer si il y avait déjà une note à cette position)}
var s,i:integer;
Begin
    if high(Notes) = -1 then Begin
        SetLength(Notes,1);
        Notes[0] := Note;
    end else Begin

     for i := 0 to high(Notes) do
       if IsNotesEgales(Note, Notes[i]) then
           Begin
               result := false;
               Exit;
           end
       else
       if IsPosition1Inf2(Note.position, Notes[i].position) then
               Break;

      s := i;
     SetLength(Notes,high(Notes) + 2);
     for i := high(Notes) downto s+1 do
         Notes[i] := Notes[i-1];

     Notes[s] := Note;
   end;
   result := true;

end;

Function TElMusical_Liste_Notes.AddNote(Note:TNote): Boolean;
Begin
    result := AddNoteSub(Note);
    CalcGDBoules;
end;

Function TElMusical_Liste_Notes.AddNote2(pos:TPosition; hn: THauteurNote): Boolean;
{TPosition : contient les données des positions graphiques
  (quel portée, quel ligne (<-- quoique, ça ça le recalcule normalement...)
 THauteurNote : position absolue de la note. (0 = do, 1 = ré etc...)}
var n:TNote;

Begin
    n.position := pos;
    n.hauteurnote := hn;
    n.BouleADroite := 0;
    n.Selectionne := svDeselectionnee;
    {pour éviter d'entrer des notes avec des
                        caractéristiques bizarres comme des liées etc.}

                    
    Tablature_System_Note_Calculer_Position_Standard_Dans_Tablature(n);

    result := addnote(n);

End;


procedure TElMusical_Liste_Notes.DelNote2(n: integer);
var s:integer;
    portee: integer;

Begin
  VerifierIndiceNote(n);

  portee := Notes[0].position.portee;

  For s := n to high(Notes) -1 do
           Notes[s] := Notes[s+1];


  position.portee := portee;
  {oui, si on supprime les notes au point que l'élément se transforme en silence,
  il faut qu'il soit bien placé ;)}

  Setlength(Notes, high(Notes));

End;


Function TElMusical_Liste_Notes.DelNote(Pos: TPosition):Boolean;
{essaie de virer la note à la position "pos"
   renvoit "faux" si aucune note à la position "pos" n'existe}
var i:integer;
Begin
     For i := 0 to high(Notes) do
            if IsPositionsEgales(Notes[i].position, pos) then
                    Break;

     if i > high(Notes) then
              result := false
     else
     Begin
         DelNote2(i);

         if high(Notes) > -1 then
             CalcGDBoules;

         result := true;
     end;
End;






Function TElMusical_Liste_Notes.PosNoteBas: TPosition;
Begin
if IsSilence then
      result := Position
else
      result := Notes[0].position;
End;

Function TElMusical_Liste_Notes.PosNoteHaut: TPosition;
Begin
if IsSilence then
      result := Position
else
    result := Notes[high(Notes)].position;
End;


Function TElMusical_Liste_Notes.HauteurNoteNoteBas: THauteurNote;
Begin
if IsSilence then
      MessageErreur('HauteurNoteNoteHaut sur un silence')
else
      result := Notes[0].HauteurNote;
End;

Function TElMusical_Liste_Notes.HauteurNoteNoteHaut: THauteurNote;
Begin
if IsSilence then
      MessageErreur('HauteurNoteNoteHaut sur un silence')
else
    result := Notes[high(Notes)].HauteurNote;
End;


Procedure TElMusical_Liste_Notes.CalcGDBoules;
var b:Boolean;
    lastpos: TPosition;
    i:integer;

Begin
b := QueueVersBas; {si la queue est vers le bas, la première boule est à droite}

lastpos.portee := 100;

for i := 0 to high(Notes) do
Begin
       if IsPositionsTresProches(Notes[i].position, lastpos) then
               b := not b;
        SetPr(Notes[i].BouleADroite, naBouleADroite, b);
        lastpos := Notes[i].position;
end;

if high(Notes) > -1 then {au cas où c'est une pause lol}
   CalcBoulesCotes;
End;



Procedure TElMusical_Liste_Notes.CalcBoulesCotes;
{calcule la valeur de la propriété BoulesCotes}
var flop, b: Boolean;
    i:integer;
Begin
b := GetPr(Notes[0].BouleADroite, naBouleADroite);

flop := false;
for i := 1 to high(Notes) do
       if GetPr(Notes[i].BouleADroite, naBouleADroite) <> b then
              Begin
                  flop := true;
                  Break;
              End;

if flop then
      BoulesCotes := bcMixte
else
     Begin
          if b then
               BoulesCotes := bcDroite
          else
               BoulesCotes := bcGauche;
     End;
End;



Function TElMusical_Liste_Notes.IsSilence: Boolean;
{renvoie vrai si l'élément musical est une pause}
Begin
      result := (high(Notes) = -1);
      {en interne, une pause c'est un accord sans aucune note}
End;



Procedure TElMusical_Liste_Notes.ClasserBoules;
{précondition : il faut que les champs position des notes soient correctement
 mis à jour car cette fonction réalise un tri qui requiert ces champs}

var notetampon: TNote;
    posmin: TPosition;
    hn, i, k, kmin: integer;
Begin

    {on trie les notes de l'élément musical via un
        tri sélection sur la "position" des notes}
       hn := high(Notes);
       for i := 0 to hn-1 do
       Begin
           posmin.portee :=0;
           posmin.hauteur := 128;

           kmin := hn; //initialisation pipo

           for k := i+1 to hn do
                 if IsPosition1Inf2(Notes[k].position, posmin) then
                 Begin
                         posmin := Notes[k].position;
                         kmin := k;
                 End;


           if IsPosition1Inf2(posmin, Notes[i].position) then
           Begin
                notetampon := Notes[i];
                Notes[i] := Notes[kmin];
                Notes[kmin] := notetampon;

           End;

       end;
    CalcGDBoules;

End;


Function TElMusical_Liste_Notes.GetBoulesCotes: TBouleCote;
Begin
    result := BoulesCotes;
End;



procedure TElMusical_Liste_Notes.CopierLesNotesAPartirDe(el: TElMusical_Liste_Notes);
var n: integer;

Begin
   for n := 0 to el.NbNotes - 1 do
         AddNoteSub(el.GetNote(n));
   CalcGDBoules;
End;

end.
