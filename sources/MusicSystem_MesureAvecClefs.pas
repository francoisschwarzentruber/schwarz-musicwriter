unit MusicSystem_MesureAvecClefs;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Types,
     MusicHarmonie,
     MusicSystem_MesureBase;



type

{Ce type modélise une clef insérée dans le document (et pas en début de portée}
TClefInseree = record
    pixx:integer;
    temps: TDuree;
    Clef: TClef;
    portee: integer;

end;


     

TMesureAvecClefs = class(TMesureBase)
  ClefsInserees: array of TClefInseree;


  Function Clefs_GetIndice(x: integer; iportee: integer): integer;
  
  procedure Clefs_Add(Clef: TClef; portee: integer; Temps: TDuree);

  Procedure Clefs_Del1(indice: integer);
  Function Clefs_Del(portee: integer; Temps: TDuree): Boolean;
end;



implementation

uses MusicGraph_Portees {pour IGP};


Procedure TMesureAvecClefs.Clefs_Add(Clef: TClef; portee: integer; Temps: TDuree);
//Insère une clé, les clés sont triées par Temps dans la mesure
var s,i,h: integer;
Begin
//préconditions
      IGP.VerifierIndicePortee(portee, 'AddClef');

      h := high(ClefsInserees);

      if h = -1 then
      Begin
             i := 0;
      end else
              for i := 0 to h do
                     if IsQ1InfQ2(Temps, CLefsInserees[i].Temps) then
                     Begin
                            if (IsQEgal(Temps, CLefsInserees[i].Temps)) and
                                         (portee = CLefsInserees[i].portee) then
                                         {si on trouve une clef au même endroit,
                                          on en profite}
                                       Begin
                                           CLefsInserees[i].Clef := Clef;
                                           Exit;
                                       End;


                            break;

                     end;

      setlength(ClefsInserees, length(ClefsInserees) + 1);

      for s := high(ClefsInserees) downto i+1 do
              ClefsInserees[s] := ClefsInserees[s-1];

      CLefsInserees[i].Clef := Clef;
      CLefsInserees[i].portee := portee;
      CLefsInserees[i].Temps := Temps;

End;





Procedure TMesureAvecClefs.Clefs_Del1(indice: integer);
var h, j: integer;
Begin
    h := high(ClefsInserees);
    for j := indice to h-1 do
                 CLefsInserees[j] := CLefsInserees[j+1];

    setlength(CLefsInserees, h);
End;




Function TMesureAvecClefs.Clefs_Del(portee: integer; Temps: TDuree): Boolean;
var h, i: integer;
Begin
//préconditions
      IGP.VerifierIndicePortee(portee, 'DelClef');

      h := high(ClefsInserees);
      for i := h downto 0 do
             if (IsQEgal(Temps, CLefsInserees[i].Temps)) and
                (portee = CLefsInserees[i].portee) then
                     Break;

      if (i = -1) or (h = -1) then
           result := false
      else
      Begin
           Clefs_Del1(i);
           result := true;

      End;
End;



Function TMesureAvecClefs.Clefs_GetIndice(x: integer; iportee: integer): integer;
var i: integer;

Begin
      result := -1;

      for i := 0 to high(CLefsInserees) do
            With CLefsInserees[i] do
                 if (pixx <= x) and (x <= pixx + 200) and (portee = iportee) then
                      result := i;      
End;




end.
