unit Musicwriter_langue;

interface

function Langue_ArticleDefini_lapostrophe_ou_les_nombre_et_espace(nb: integer): string;
function Langue_MettreSSiPluriel(str: string; nb: integer): string;

function Langue_Nombre_NomMasculin_SSiPluriel(nb: integer; str: string): string;
function Langue_Nombre_NomFeminin_SSiPluriel(nb: integer; str: string): string;




implementation

uses SysUtils,
     MusicWriter_Erreur;


function Langue_ArticleDefini_lapostrophe_ou_les_nombre_et_espace(nb: integer): string;
Begin
    if nb = 1 then
        result := 'l'''
    else
        result := 'les ' + inttostr(nb) + ' ';
End;


function Langue_MettreSSiPluriel(str: string; nb: integer): string;
Begin
    if nb = 1 then
        result := str
    else
        result := str + 's';
End;



function Langue_Nombre_NomMasculin_SSiPluriel(nb: integer; str: string): string;
Begin
     if nb > 1 then
        result := inttostr(nb) + ' ' + str + 's'
     else if nb = 1 then
        result := 'un ' + str
     else if nb = 0 then
        result := 'zéro ' + str
     else
        MessageErreur('Langue_Nombre_NomMasculin_SSiPluriel : erreur car nombre négatif');
End;


function Langue_Nombre_NomFeminin_SSiPluriel(nb: integer; str: string): string;
Begin
     if nb > 1 then
        result := inttostr(nb) + ' ' + str + 's'
     else
        result := 'une ' + str;
End;


end.
 