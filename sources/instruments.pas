unit instruments;

interface



uses MusicHarmonie, Classes {pour TStringlist};

const INSTRUMENTS_INDICE_MAX  = 126;
      INSTRUMENT_PAR_DEFAUT = 0;
      instrumentPIANO = 0;
      instrumentGUITARE = 24;



type TIndiceInstrument = integer{0..126};

    Procedure VerifierIndiceInstrument(var i: integer;  mess: string); overload;
    Procedure VerifierIndiceInstrument(var i: word;  mess: string); overload;
    
    procedure GetInstrumentStringList(sl : TStrings);
    Function GetInstrumentNom(i : TIndiceInstrument): string;
    Function GetInstrumentNomCourt(i : TIndiceInstrument): string;
    procedure GetInstrumentTessiture(i : TIndiceInstrument; var n1, n2: THauteurnote);
    {renvoie la tessiture de l'instrument n° i
     rem : c'est la tessiture "vue" et non celle entendu
     ex : clarinette en si b : mi-1 ... et non ré-1...}
    Function Is_Instrument_Clavier(i : TIndiceInstrument): Boolean;

    Function Is_Instrument_Guitare(i : TIndiceInstrument): Boolean;
    
    Function GetInstrument_ClefParDefaut(i : TIndiceInstrument): TClef;
    procedure InstrumentsInitialize;

    Function IsInstrument_DansListeStandard(i : TIndiceInstrument): Boolean;
    {renvoie vrai ssi l'instrument est un instrument standard
    le violon est "standard"
    le sitar des neiges joué en himalaya n'est pas "standard"}

    

implementation

uses MusicUser {DossierRacine},
     MusicWriter_Erreur,
     SysUtils {pour inttostr},
     langues;



type TInstrument = record
       nom: string;
       nom_court: string;
       tessitureB, tessitureH: THauteurNote;
end;




var instrumentstab: array[0..INSTRUMENTS_INDICE_MAX] of TInstrument;


  procedure GetInstrumentStringList(sl : TStrings);
  var i :integer;
  Begin
        sl.Clear;

        for i := 0 to 126 do
        Begin
              sl.Add(inttostr(i + 1) + '    ' + instrumentstab[i].nom)
        End;

  End;


  Procedure VerifierIndiceInstrument(var i: integer; mess: string); overload;
  Begin
      if not (i in [0..126]) then
      Begin
           MessageErreur('Indice d''instrument incorrect : '
                          + inttostr(i) + ' n''est pas valide ! On le met à 0.');

           i := 0;
      End;
  End;

  Procedure VerifierIndiceInstrument(var i: word;  mess: string); overload;
  Begin
      if not (i in [0..126]) then
      Begin
           MessageErreur('Indice d''instrument incorrect : '
                          + inttostr(i) + ' n''est pas valide ! On le met à 0.');

           i := 0;
      End;
  End;


  Function GetInstrumentNom(i : TIndiceInstrument): string;
  Begin
       VerifierIndiceInstrument(i, 'GetInstrumentNom');
       result := Instrumentstab[i].nom;
  End;

  Function GetInstrumentNomCourt(i : TIndiceInstrument): string;
  Begin
       VerifierIndiceInstrument(i, 'GetInstrumentNomCourt');
       result := Instrumentstab[i].nom_court;
  End;

  procedure GetInstrumentTessiture(i : TIndiceInstrument; var n1, n2: THauteurnote);
  Begin
      VerifierIndiceInstrument(i, 'GetInstrumentTessiture');
      n1 := Instrumentstab[i].tessitureB;
      n2 := Instrumentstab[i].tessitureH;

      VerifierHauteurNote(n1, 'tessiture B dans GetInstrumentTessiture');
      VerifierHauteurNote(n2, 'tessiture H dans GetInstrumentTessiture');
  End;




  procedure InstrumentsInitialize;
  var     sl: TStringlist;
          s, mot: string;
          p, i: integer;
          tessitureindefini: Boolean;

    Function ExtractMotAndPass: boolean;
    {extrait le mot puis passe}
    Begin
         if s = '' then
         Begin
              mot := '';
              result := false;
         End
         else
         Begin
             p := pos(#9, s);
             if p > 0 then
             Begin
                  mot := Copy(s, 1, p-1);
                  s := Copy(s, p+1, 10000);
                  result := true;
             End
             else
             Begin
                 mot := s;
                 s := '';
                 result := true;
             End;
         End;
    End;

    Procedure VerifierMotInstrumentValide;
    Begin
        if length(mot) = 0 then
            MessageErreur('nom d''instrument vide !! ' + 'N° d''instrument : ' + inttostr(i))
        else if mot[length(mot)] = ' ' then
            MessageErreur('nom d''instrument terminant par un espace : " ' + mot + '" '
                            + 'N° d''instrument : ' + inttostr(i));

    End;

  Begin
       sl := TStringList.Create;

       try
           sl.LoadFromFile(DossierRacine + 'interface_instruments\instruments.txt');
       except else
           MessageErreur('Erreur dans le chargement de la base de données des instruments MIDI.' +
                   'Autrement dit, le fichier ' +
                   DossierRacine + 'Instruments\instruments.txt' +
                   ' doit être absent !');
       end;


       if sl.Count <> 128 then
           MessageErreur('Erreur dans la base de données des instruments MIDI.' +
                         'Il faut exactement 127 lignes dedans !')
       else
       for i := 0 to 126 do
       Begin
          s := sl[i];
          tessitureindefini := false;

          ExtractMotAndPass;
          ExtractMotAndPass;

          VerifierMotInstrumentValide;
          instrumentstab[i].nom := Langues_Traduire(mot);

          if ExtractMotAndPass then
          Begin
              instrumentstab[i].nom_court := mot;

              if ExtractMotAndPass then
              Begin
                  if mot = '' then
                      tessitureindefini := true
                  else
                  Begin

                      instrumentstab[i].tessitureB := StrToHauteurNote(mot);
                      if ExtractMotAndPass then
                            instrumentstab[i].tessitureH := StrToHauteurNote(mot)

                      else
                            MessageErreur('Le fichier interface_instruments\instruments.txt est corrompu !!'
                             + 'L''instrument n°' + inttostr(i) + ' n''a pas de tessiture complète !');
                  End;
              end
              else tessitureindefini := true;

          End
              else tessitureindefini := true;


          if tessitureindefini then
          //si la tessiture n'est pas défini, on invente un truc bien large...
          Begin
               With instrumentstab[i].tessitureB do
               Begin
                   Hauteur := -10*7;
                   alteration := aNormal;
               End;

               With instrumentstab[i].tessitureH do
               Begin
                   Hauteur := 10*7;
                   alteration := aNormal;
               End;
          End;

       End;
       sl.Free;
  End;




Function IsInstrument_DansListeStandard(i : TIndiceInstrument): Boolean;
Begin

    result := i in [0, 6, 8, 9, 13, 19, 24,
                    40, 41, 42, 43, 47,
                    56, 57, 58, 60,
                    68, 69, 70, 71, 72, 73, 74, 75,
                    104, 105,109];

End;


Function Is_Instrument_Clavier(i : TIndiceInstrument): Boolean;
Begin
    result := i in [0..8] + [19];
End;


Function Is_Instrument_Guitare(i : TIndiceInstrument): Boolean;
Begin
    result := i in [24];
End;


Function GetInstrument_ClefParDefaut(i : TIndiceInstrument): TClef;
Begin
    result := ClefSol;
End;


end.
