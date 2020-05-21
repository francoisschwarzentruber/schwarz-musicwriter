unit FileSystem;

interface

var VFF : integer; //version format fichier
    EnLecture: Boolean;
    NomFichier: string;

Function OuvrirFichier(nom: string): Boolean;
procedure FichierDo(var v; l:integer);
//procedure FichierDoSmallInt(var i:integer);
procedure FichierDoInt(var i:integer; ifix:integer); overload;
procedure FichierDoInt(var i:integer); overload;

procedure FichierDoByte(var i:Byte; ifix:integer); overload;
procedure FichierDoByte(var i:Byte); overload;

procedure FichierDoWord(var i:word);
//Procedure FichierDoSmallStr(var s:string);
procedure FichierDoStr(var s:string);
Function FichierEnTete(s: string): Boolean;
Function FichierDoSection(s: string): Boolean;

Function FileSystem_IsFinFichier: Boolean;
procedure FermerFichier;

Function GetPr(b: integer; pr: integer): Boolean; overload;
Procedure SetPr(var b: integer; pr: integer; value: Boolean); overload;
Procedure InverserPr(var b: integer; pr: integer); overload;

Function GetPr(b: byte; pr: integer): Boolean; overload;
Procedure SetPr(var b: byte; pr: integer; value: Boolean); overload;
Procedure InverserPr(var b: byte; pr: integer); overload;









implementation

uses MusicSystem;

var VarFile: File of Byte;



Function OuvrirFichier(nom: string): Boolean;
Begin
  result := true;
  NomFichier := Nom;
  AssignFile(VarFile,nom);

  try
        if EnLecture then
        Begin
           FileMode := 0; //lecture seule
           Reset(VarFile);
        End
        else
        Begin
            FileMode := 1; //écriture-lecture
            Rewrite(VarFile);
        End;
   except
   else
        result := false;
   end;
End;



procedure FichierDo(var v; l: integer);
Begin
if l > 0 then
Begin
    if EnLecture then
           BlockRead(VarFile,v,l)
    else
           BlockWrite(VarFile,v,l);
End;
End;



{procedure FichierDoSmallInt(var i:integer);
var ii: SmallInt;
Begin
    ii := i; //transtypage
    if EnLecture then
    Begin
            BlockRead(VarFile,ii,2);
            i := ii;
    End
    else
            BlockWrite(VarFile,ii,2);
End;      }




procedure FichierDoInt(var i:integer; ifix:integer); overload;
Begin
    if EnLecture then
            BlockRead(VarFile,i,4)
    else
            BlockWrite(VarFile,ifix,4);
End;

procedure FichierDoWord(var i:word);
Begin
    if EnLecture then
            BlockRead(VarFile,i,2)
    else
            BlockWrite(VarFile,i,2);
End;


procedure FichierDoByte(var i:Byte);
Begin
    if EnLecture then
            BlockRead(VarFile,i,1)
    else
            BlockWrite(VarFile,i,1);
End;


procedure FichierDoByte(var i:Byte; ifix:integer); overload;
Begin
    if EnLecture then
            BlockRead(VarFile,i,1)
    else
            BlockWrite(VarFile,ifix,1);
End;


procedure FichierDoInt(var i:integer); overload;
Begin
    if EnLecture then
            BlockRead(VarFile,i,4)
    else
            BlockWrite(VarFile,i,4);
End;



{Procedure FichierDoSmallStr(var s:string);
var i, j:integer;
Begin
    i := length(s);
    FichierDoSmallInt(i);

    if EnLecture then
    Begin


            for j := 1 to i do
                    s := s + ' ';

            if i > 0 then
                  BlockRead(VarFile,s[1],i);
            for j := 1 to i do
                  BlockRead(VarFile,s[j],1);
    end
    else
            if length(s) > 0 then
                     BlockWrite(VarFile,s[1],length(s));



End;           }


                    
procedure FichierDoStr(var s:string);
var i :integer;

Begin
    FichierDoInt(i, length(s));

    if EnLecture then
    Begin
            setlength(s, i);

            if i > 0 then
                  BlockRead(VarFile,s[1],i); 
            {for j := 1 to i do
                  BlockRead(VarFile,s[j],1); }
    end
    else
            if length(s) > 0 then
                     BlockWrite(VarFile,s[1],length(s));

End;




Function FichierDoSection(s: string): Boolean;
var v: string;
Begin
    If EnLecture then
    Begin
        FichierDoStr(v);
        result := (v = s);
    End
    else
    Begin
        v := s;
        FichierDoStr(v);
        result := true;
    End;
    
End;


Function FichierEnTete(s: string): Boolean;
{renvoit vrai en cas de succès}
var t: string;
Begin
t := s;
result := true;
if EnLecture then
Begin
      BlockRead(VarFile,t[1],length(t));
      result := (s = t);
end
else
      BlockWrite(VarFile,s[1],length(s));

End;




Function FileSystem_IsFinFichier: Boolean;
Begin
       result := EOF(VarFile);
End;



procedure FermerFichier;
Begin
  CloseFile(VarFile);

End;


Function GetPr(b: integer; pr: integer): Boolean; overload;
Begin
result := ((b and pr) <> 0);
End;


Procedure SetPr(var b: integer; pr: integer; value: Boolean); overload;
Begin
if value then
    b := b or pr
else
    b := b and (not pr);

End;


Procedure InverserPr(var b: integer; pr: integer); overload;
Begin
    b := b xor pr;
End;

Function GetPr(b: byte; pr: integer): Boolean; overload;
Begin
result := ((b and pr) <> 0);
End;


Procedure SetPr(var b: byte; pr: integer; value: Boolean); overload;
Begin
if value then
    b := b or pr
else
    b := b and (not pr);

End;


Procedure InverserPr(var b: byte; pr: integer); overload;
Begin
    b := b xor pr;
End;

end.
