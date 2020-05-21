unit MusicSystem_Composition_Portees_Liste;



interface

uses MusicHarmonie {clef},
     MusicSystem_Octavieurs_Liste,
     MusicSystem_Types;





const
      tpPortee5Lignes = 0;
      tpPortee1Ligne = 1;

      tpPorteeTablatureGuitare = 2;
      tpPorteeTablatureBasse = 3;



      taRien = 0;
      taAccolade = 1;
      taCrochet = 2;




type

TPorteeGlobale_v1 = record
         instrument: string;
         Clef: TClef;
end;




{Visibilité d'une portée :
 - toujours
 - seulement quand non vide
 - seulement quand non vide sauf sur la première ligne, où elle est toujours affichée
 - jamais (option qui sert à rien)}
TPorteeVisibility = (pvAlways, pvHiddenWhenEmpty, pvHiddenWhenEmptyExceptOnFirstLine, pvHiddenAlways);

TPorteeGlobale = record
         Nom: string;
         m_instrument: word; //numéro de l'instrument midi
         taille: word;
         englobe: integer;
         typeportee,
         typeAccolade,
         nbPorteesGroupe {pour une portée seule, vaut 0},
         reserved: Byte;
         Visible: TPorteeVisibility;
         Transposition: THauteurNote;
         Clef: TClef;
         Octavieurs_Liste: TOctavieurs_Liste;
end;
{ça vaut 100 octets à peu près par portées.
une partition fait au max 20 portées, soit... 2ko de perdu pour chaque propriété
 modifiée}


TPorteesGlobales = array of TPorteeGlobale;


TComposition_Portees_Liste = class(TObject)
public //but : à mettre en protected
protected
   PorteesGlobales: TPorteesGlobales;

protected

   function Portee_Transposition_read(iportee: integer): THauteurNote;
   procedure Portee_Transposition_write(iportee: integer; val: THauteurNote);

   function Portee_Taille_read(iportee: integer): integer;
   procedure Portee_Taille_write(iportee: integer; val: integer);




   function Portee_Type_read(iportee: integer): integer;
   procedure Portee_Type_write(iportee: integer; val: integer);

   function Portee_Visible_read(iportee: integer): TPorteeVisibility;
   procedure Portee_Visible_write(iportee: integer; val: TPorteeVisibility);

   function Portee_Nom_read(iportee: integer): string;
   procedure Portee_Nom_write(iportee: integer; val: string);

   function Portee_InstrumentMIDINum_read(iportee: integer): integer;
   procedure Portee_InstrumentMIDINum_write(iportee: integer; val: integer);




public

    property Portee_InstrumentMIDINum[iportee: integer] : integer
        read Portee_InstrumentMIDINum_read
        write Portee_InstrumentMIDINum_write;

    property Portee_Transposition[iportee: integer] : THauteurNote
        read Portee_Transposition_read
        write Portee_Transposition_write;

    property Portee_Taille[iportee: integer] : integer
        read Portee_Taille_read
        write Portee_Taille_write;



    property Portee_Type[iportee: integer] : integer
        read Portee_Type_read
        write Portee_Type_write;

    property Portee_Visible[iportee: integer] : TPorteeVisibility
        read Portee_Visible_read
        write Portee_Visible_write;

    property Portee_Nom[iportee: integer] : string
        read Portee_Nom_read
        write Portee_Nom_write;


   Function Portee_Octavieurs_Liste(ip: integer): TOctavieurs_Liste;

   
   procedure Portees_Accolade_Mettre(ip1, ip2: integer);
   procedure Portees_Crochet_Mettre(ip1, ip2: integer);
   procedure Portees_AccoladesCrochets_Enlever(ip1, ip2: integer);

   Function Portee_GetNbPorteesInGroupe(ip: integer): integer;
   Function Portee_GetTypeAccolade(ip: integer): integer;


   Function Portee_IsTablature(ip: integer): Boolean;
   Function Portee_IsTablature_Et_PasDehors(ip: integer): Boolean;

   Function Portee_IsVisible(ip: integer): Boolean;

   Function NbPortees: integer;
   Function NbInstruments: integer;

   Function Voix_Indice_To_Portee(N_Voix: integer): integer;
   Function Voix_Indice_To_NumVoixDansPortee(N_Voix: integer): integer;


   procedure VerifierIndicePortee(var iPortee: integer; mess_err: string);
   Function IsIndicePorteeValide(portee: integer): Boolean;
   procedure Position_Arrondir(var pos: TPosition);
End;


implementation

uses MusicWriter_Erreur,
     SysUtils {pour inttostr},
     instruments {pour VerifierIndiceInstrument},
     tablature_system{pour Tablature_System_CordeNumToPositionHauteur},
     MusicGraph {pour ViewCourant},
     MusicGraph_Portees {pour IGP};


Function TComposition_Portees_Liste.NbPortees: integer;
Begin
    if self = nil then
    Begin
        MessageErreur('Bizarre... Pas d''objet ! dans NbPortees');
        result := 0;
        eXit;
    End;

    result := length(PorteesGlobales);

    if result <= 0 then
        MessageErreur('Problème dans NbPortees... il y a 0 portée !!!!');
End;



Function TComposition_Portees_Liste.NbInstruments: integer;
    Function Compter: integer;
    var n, i: integer;
    Begin
         n := 0;
         i := 0;
         while i <= high(PorteesGlobales) do
         Begin
             inc(n);
             inc(i, Portee_GetNbPorteesInGroupe(i) + 1);
         End;
         result := n;
    End;
Begin
    if self = nil then
    Begin
        MessageErreur('Bizarre... Pas d''objet ! dans NbInstruments');
        result := 0;
        eXit;
    End;

    result := compter;

    if result <= 0 then
        MessageErreur('Problème dans NbInstruments... il y a 0 portée !!!!');
End;



Function TComposition_Portees_Liste.Voix_Indice_To_Portee(N_Voix: integer): integer;
Begin
      result := N_Voix mod NbPortees;
End;



Function TComposition_Portees_Liste.Voix_Indice_To_NumVoixDansPortee(N_Voix: integer): integer;
Begin
      result := N_Voix div NbPortees;
End;



procedure TComposition_Portees_Liste.VerifierIndicePortee(var iPortee: integer; mess_err: string);
Begin
      if (iPortee < 0) or (iPortee >= NbPortees) then
      Begin
            MessageErreur('Indice de portée incorrect : iPortée = '
                        + IntToStr(iPortee) +' alors que les indices '
                        + 'valides vont de 0 à ' + inttostr(NbPortees-1) +
                        mess_err +
                        'PS : On le met à 0.' );
            iPortee := 0;
      End;
End;


Function TComposition_Portees_Liste.IsIndicePorteeValide(portee: integer): Boolean;
Begin
    result := (0  <= portee) and (portee <= High(PorteesGlobales));
End;


Function TComposition_Portees_Liste.Portee_GetNbPorteesInGroupe(ip: integer): integer;
Begin
   result := PorteesGlobales[ip].nbPorteesGroupe;
End;


Function TComposition_Portees_Liste.Portee_GetTypeAccolade(ip: integer): integer;
Begin
   result := PorteesGlobales[ip].typeaccolade;
End;


Function TComposition_Portees_Liste.Portee_Octavieurs_Liste(ip: integer): TOctavieurs_Liste;
Begin
    result := PorteesGlobales[ip].Octavieurs_Liste;
End;


Function TComposition_Portees_Liste.Portee_InstrumentMIDINum_read(iportee: integer): integer;
Begin
    VerifierIndicePortee(iportee, 'Portee_InstrumentMIDINum_read');
    VerifierIndiceInstrument(PorteesGlobales[iportee].m_instrument, 'Portee_InstrumentMIDINum_read');
    result := PorteesGlobales[iportee].m_instrument;
End;


procedure TComposition_Portees_Liste.Portee_InstrumentMIDINum_write(iportee: integer; val: integer);
Begin
   VerifierIndicePortee(iportee, 'Portee_InstrumentMIDINum_write');
   VerifierIndiceInstrument(val, 'Portee_InstrumentMIDINum_write');

   PorteesGlobales[iportee].m_instrument := val;
End;




function TComposition_Portees_Liste.Portee_Transposition_read(iportee: integer): THauteurNote;
Begin
    result := PorteesGlobales[iportee].Transposition;
End;



procedure TComposition_Portees_Liste.Portee_Transposition_write(iportee: integer; val: THauteurNote);
Begin
   PorteesGlobales[iportee].Transposition := val;
End;



function TComposition_Portees_Liste.Portee_Taille_read(iportee: integer): integer;
Begin
    result := PorteesGlobales[iportee].taille;
End;



procedure TComposition_Portees_Liste.Portee_Taille_write(iportee: integer; val: integer);
Begin
   PorteesGlobales[iportee].taille := val;
End;











function TComposition_Portees_Liste.Portee_Type_read(iportee: integer): integer;
Begin
    result := PorteesGlobales[iportee].typeportee;
End;



procedure TComposition_Portees_Liste.Portee_Type_write(iportee: integer; val: integer);
Begin
   PorteesGlobales[iportee].typeportee := val;
End;




function TComposition_Portees_Liste.Portee_Visible_read(iportee: integer): TPorteeVisibility;
Begin
    result := PorteesGlobales[iportee].visible;
End;



procedure TComposition_Portees_Liste.Portee_Visible_write(iportee: integer; val: TPorteeVisibility);
Begin
   PorteesGlobales[iportee].visible := val;
End;


function TComposition_Portees_Liste.Portee_Nom_read(iportee: integer): string;
Begin
    result := PorteesGlobales[iportee].nom;
End;



procedure TComposition_Portees_Liste.Portee_Nom_write(iportee: integer; val: string);
Begin
   PorteesGlobales[iportee].nom := val;
End;


procedure TComposition_Portees_Liste.Portees_Accolade_Mettre(ip1, ip2: integer);
Begin
      with PorteesGlobales[ip1] do
      Begin
            typeAccolade := taAccolade;
            nbPorteesGroupe := ip2 - ip1;
      End;
End;

procedure TComposition_Portees_Liste.Portees_Crochet_Mettre(ip1, ip2: integer);
Begin
      with PorteesGlobales[ip1] do
      Begin
            typeAccolade := taCrochet;
            nbPorteesGroupe := ip2 - ip1;
      End;
End;



Function TComposition_Portees_Liste.Portee_IsTablature(ip: integer): Boolean;
Begin
    VerifierIndicePortee(ip, 'Portee_IsTablature');
    result := (PorteesGlobales[ip].typeportee = tpPorteeTablatureGuitare);
End;


Function TComposition_Portees_Liste.Portee_IsTablature_Et_PasDehors(ip: integer): Boolean;
Begin
    if IsIndicePorteeValide(ip) then
        result := Portee_IsTablature(ip)
    else
        result := false;
End;


Function TComposition_Portees_Liste.Portee_IsVisible(ip: integer): Boolean;
Begin
    VerifierIndicePortee(ip, 'Portee_IsVisible');
    result := (PorteesGlobales[ip].visible <> pvHiddenAlways);

    if ViewCourant <> nil then
        if not ViewCourant^.PorteeAffichee[ip] then
            result := false;
End;


procedure TComposition_Portees_Liste.Portees_AccoladesCrochets_Enlever(ip1, ip2: integer);
var p : integer;
Begin

    for p := ip1 to ip2 do
    Begin
        PorteesGlobales[p].typeAccolade := taRien;
        PorteesGlobales[p].nbPorteesGroupe := 0;
    End;
End;


procedure TComposition_Portees_Liste.Position_Arrondir(var pos: TPosition);
Begin
    if Portee_IsTablature(pos.portee) then
    Begin
         pos.hauteur := (pos.hauteur div 2) * 2;

         if pos.hauteur > Tablature_System_CordeNumToPositionHauteur(5) then
             pos.hauteur := Tablature_System_CordeNumToPositionHauteur(5);

         if pos.hauteur < Tablature_System_CordeNumToPositionHauteur(0) then
             pos.hauteur := Tablature_System_CordeNumToPositionHauteur(0);
    End;
End;

end.
