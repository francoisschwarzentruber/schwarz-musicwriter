unit UModeles;

interface

uses MusicSystem;

type
TModele = record
    posref: integer;
    Voix: TVoix;

end;

var
Modeles: array of TModele;

implementation


procedure ChargerModeles;
Begin
Setlength(Modeles, 2);

Modeles[0].Voix := TVoix.Create;

Modeles[0].Voix



End;


end.
