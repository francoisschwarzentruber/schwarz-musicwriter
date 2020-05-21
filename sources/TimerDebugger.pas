unit TimerDebugger;

interface

{Cette unit� permet de savoir combien de temps dure des actions

   TimerDebugger_Init : � appeler au d�but
   TimerDebugger_FinEtape(...) : � appeler pour dire qu'une �tape s'est finie
   (l'unit� enregistre alors le temps mis pour cette �tape)

   TimerDebugger_GetTexte : permet d'obtenir un r�sum�, un sorte de rapport
    de ce qui s'est pass�

    rem : TimerDebugger_Init d�truit le rapport courant}





procedure TimerDebugger_Init;
procedure TimerDebugger_FinEtape(nom_etape: string);
Function TimerDebugger_GetTexte: string;



implementation


uses Classes, Windows, SysUtils;



var t_init: int64;
    t_dernier: int64;
    strings: TStrings = nil;



    
procedure TimerDebugger_Init;
Begin
    if strings = nil then
          strings := TStringList.Create;

    strings.Clear;
    t_init := gettickcount;
    t_dernier := gettickcount;
    
End;


procedure TimerDebugger_FinEtape(nom_etape: string);
var t_nouveau: Int64;
Begin
   t_nouveau := gettickcount;

   if strings <> nil then
   strings.add(nom_etape + ' : ' + inttostr(t_nouveau - t_dernier) + ', ' +
                inttostr(t_nouveau - t_init)
                );

   t_dernier := t_nouveau;

End;



Function TimerDebugger_GetTexte: string;
Begin
     result := Strings.Text;
End;


end.
