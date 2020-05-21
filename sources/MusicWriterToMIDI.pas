unit MusicWriterToMIDI;

interface

uses MusicSystem_Composition,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_ElMusical,
     MusicSystem_Constantes,
     MusicHarmonie {pour THauteurNote},
     MusicSystem_CompositionLectureMIDI;

const NB_INSTRUMENTS_MIDI = 128;
const delayuneminute = 480*60;
const factordelaynoire = 1.0415;
{factordelaynoire est une constante de bidouille
 normalement, elle devrait valoir un...
 mais si elle vaut un, le curseur qui suit la lecture sur la partition avance trop
  vite... en donnant une valeur plus grande que 1, cela ralentit le défilement du curseur
  (ou plutôt cela ralentit la lecture du MIDI... ce qui est presque équivalent...)

  avant, c'était à 1.045 et là, le curseur de lecture étant à la fin des morceaux
  à peine en retard sur la lecture MIDI}


Function HauteurNoteToMIDINote(HauteurNote: THauteurNote): integer;
procedure WriteMIDI(Comp: TComposition; ListeDeLecture: TListeDeLecture; filename: string);
procedure Preparern_voixdpistes(Comp: TComposition);

var delaynoire: integer = 150;

var n_voixdpistes: array of integer;

    m_instr: array of integer;
    
    transpoportees: array of integer;
    {tableau des transpositions matérielles à effectuer
    ex : clarinettes...}

    delay: integer;

implementation

uses UMidiFile, QSystem, MusicWriter_Erreur {pour MessageErreur},
     MusicUser {truc de métronome},
      SysUtils {pour inttostr},
      MusicGraph_Portees {pour IGP};

    

Function HauteurNoteToMIDINote(HauteurNote: THauteurNote): integer;
Begin
result := 60 + HauteurNoteToNbDemiTon(HauteurNote);

if result < 0 then
    result := 0
else if result > 255 then
   result := 255;

End;





procedure Preparern_voixdpistes(Comp: TComposition);
{calcule le tableau des instruments m_instr}

var m, v, i, newvoix: integer;
    dejapresent: boolean;

Begin
    setlength(m_instr, 0);
    setlength(n_voixdpistes, 0);
    
    for m := 0 to Comp.NbMesures - 1 do
        With Comp.GetMesure(m) do
        for v := 0 to high(Voix) do with Voix[v] do if IsEntendue then
        if not Voix[v].IsVide then
        Begin

                 newvoix := Voix[v].N_Voix;

                 dejapresent := false;

                 for i := 0 to high(n_voixdpistes) do
                         if n_voixdpistes[i] = newvoix then
                         Begin
                             dejapresent := true;
                             Break;
                             
                         End;

                 if not dejapresent then
                 {si la voix courante n'est pas déjà présente}
                 Begin
                     Setlength(n_voixdpistes, length(n_voixdpistes)+1);
                     n_voixdpistes[high(n_voixdpistes)] := newvoix;
                     Setlength(m_instr, length(m_instr)+1);
                     if high(Voix[v].ElMusicaux) > -1 then
                          m_instr[high(n_voixdpistes)] :=
                           Comp.Portee_InstrumentMIDINum[Voix[v].ElMusicaux[0].PorteeApprox];

                 End;


        end;
End;


Procedure WriteTrille(note1, note2, tps, vol: integer);
const ticktrillemin  = 30;
      amplifluctu = 5;
      tempscarac = 100;

var t: integer;
    note, numnote, miniduree: integer;
Begin
        //réduction de volume pour un trille
        vol := vol div 2;

        t := 0;


        numnote := 1;

        while t < tps do
        Begin
             if numnote = 1 then
                  note := note1
             else
                  note := note2;

             numnote := 3-numnote;

             miniduree := min(ticktrillemin + round(amplifluctu * cos(t / tempscarac)), tps - t);
             m_AddDelayTime(Delay);
             Delay := 0;
             m_AddNote(true, note, vol);
             m_AddDelayTime(miniduree);
             m_AddNote(false, note, vol);

             inc(t, miniduree);

        End;

        Delay := 0;
End;




procedure WriteMIDI(Comp: TComposition; ListeDeLecture: TListeDeLEcture; filename: string);

var m, p, i, n, ildl: integer;
    numvoix: integer;
    Tick, DelayNote, DelayDureeNote, DelayRestant, DelayMesure: LongWord;
    V: TVoix;
    clef: TClef;
    anclaissersonner, laissersonner: set of Byte;
    midii: Byte;
    InstrumentMIDICourant: Byte;
    hautenotesecondaire: THauteurNote;


    procedure ChangerInstrumentMIDISiNecessaire(nvinstru: Byte);
    Begin
        if nvinstru <> InstrumentMIDICourant then
        Begin
           m_AddDelayTime(Delay);
           m_AddInstrument(nvinstru);
           Delay := 0;
           InstrumentMIDICourant := nvinstru;
        End;
    End;

    Function GetNumCanalPourInstrumentNonPercussif(p : integer): integer;
    {le but de cette fonction est d'éviter le canal 10...}
    Begin
       if p < 0 then
       Begin
           MessageErreur('NON ! Argument négatif dans ' + 'GetNumCanalPourInstrumentNonPercussif');
           p := 0;
       End;

       if p < 9 then
             result := p
       else
             result := p +1;
    End;

Begin
    //MusicUser_Pourcentage_Init;
    IGP := Comp;
    laissersonner := [];

    Comp.NuancesMIDI_Calculer;
    
    Preparern_voixdpistes(Comp);

    setlength(transpoportees, Comp.NbPortees);

    for p := 0 to high(transpoportees) do
        transpoportees[p] :=
            HauteurNoteToMIDINote(Comp.Portee_Transposition[p])-60;

    assignfile(f, filename);
    rewrite(f);

    m_channel := 0;
    m_WriteEntete(1+length(n_voixdpistes));

    m_ResetPiste;

    m_AddDelayTime(0);
    m_AddMetronome;

    m_AddDelayTime(0);
    m_AddTempo($07A120);

    for p := 0 to high(n_voixdpistes) do
    Begin
          m_channel := GetNumCanalPourInstrumentNonPercussif(p);
          m_AddDelayTime(0);
          m_AddInstrument(m_instr[p]);
    End;

    m_AddDelayTime(0);
    m_AddFinDePiste;

    m_WritePiste;


    for p := 0 to high(n_voixdpistes) do
    Begin
           //MusicUser_Pourcentage_Informer(p / length(n_voixdpistes));
           m_channel := GetNumCanalPourInstrumentNonPercussif(p);


           
           delay := 0;
           m_ResetPiste;
           numvoix := n_voixdpistes[p];
           InstrumentMIDICourant := m_instr[p];

           for ildl := 0 to high(ListeDeLecture) do
           Begin
           m := ListeDeLecture[ildl].iMesure;
           With Comp.GetMesure(m) do
           Begin
                 //calcul de delaynoire...
                 if Metronome <= 0 then
                 Begin
                       {au cas où, histoire que ça fasse pas div 0}
                       MessageErreur('Dans WriteMIDI, Metronome de la mesure n° ' +
                           inttostr(m) + ' vaut 0 ou moins');
                       Metronome := METRONOME_DEFAULT;
                 end;
                 delaynoire := (delayuneminute) div Metronome;


                 Tick := 0;
                 DelayMesure := QMul2(DelayNoire, DureeTotale);

                 if VoixNumInd(numvoix) > -1 then
                 Begin
                       V := VoixNum(numvoix);

                       for i := 0 to high(V.ElMusicaux) do with V.ElMusicaux[i] do
                       Begin
                           if GetAttrib(as1_Pizzicato) then
                                ChangerInstrumentMIDISiNecessaire(46)
                           else
                                ChangerInstrumentMIDISiNecessaire(m_instr[p]);

                           if IsSilence then
                           {pour les pauses, on écrit rien...}
                           Begin
                                 if i = high(V.ElMusicaux) then
                                 {si on est sur le dernier élément musical on complète la mesure
                                       (ceci évite les effets de retards...)}
                                     DelayNote := DelayMesure - Tick
                                 else
                                     DelayNote := QMul2(delaynoire, Duree_Get);

                                 inc(Delay, DelayNote);
                           End
                           else
                           Begin
                                 if attributs.Style2 in aSetTrille then
                                 with GetNote(0) do
                                 Begin
                                      //prépare la hauteur de la note secondaire nécessaire pour effectuer le trille
                                      GetHauteurNote_Sans_Erreur(intSecondeH, HauteurNote, hautenotesecondaire);

                                      DelayNote := QToInt(QMul(delaynoire, Duree_Get));
                                      WriteTrille(HauteurNoteToMIDINote(HauteurNote)
                                                   +transpoportees[position.portee],
                                                  HauteurNoteToMIDINote(hautenotesecondaire)
                                                   +transpoportees[position.portee],
                                                  DelayNote, V.ElMusicaux[i].attributs.volume);




                                 End
                                 else
                                 Begin

                                       anclaissersonner := laissersonner;
                                       laissersonner := [];


                                       for n := NbNotes - 1 downto 0 do with GetNote(n) do
                                       Begin
                                              midii := HauteurNoteToMIDINote(HauteurNote)
                                                             +transpoportees[position.portee];

                                              if (BouleADroite and naLieALaSuivante <> 0) then
                                                  laissersonner := laissersonner + [midii];

                                              if not (midii in anclaissersonner) then
                                              {si la note n'était pas sonné dans un précédent el. music. alors on joue}
                                              Begin
                                                  m_AddDelayTime(Delay);
                                                  {if Tick mod delaynoire = 0 then    //temps vrai = volume au plus fort
                                                     m_AddNote(true, midii, 127)
                                                  else
                                                  m_AddNote(true, midii, attributs.Volume*64 div 127);  }
                                                   m_AddNote(true, midii, attributs.Volume*127 div 127);

                                                  Delay := 0;
                                              End;


                                       End;





                                       if i = high(V.ElMusicaux) then
                                       {si on est sur le dernier élément musical on complète la mesure
                                             (ceci évite les effets de retards...)}
                                           DelayNote := DelayMesure - Tick
                                       else
                                           DelayNote := QToInt(QMul(delaynoire, V.ElMusicaux[i].Duree_Get));


                                       if GetAttrib(as1_Pique) then
                                       {si la note est piquée}
                                           DelayDureeNote := DelayNote div 8
                                       else
                                           DelayDureeNote := DelayNote;

                                       {Tick contient le temps entre le début de la mesure et le début de la note en cours
                                        Delay
                                        DelayNote contient le temps normalement donné à la note
                                        DelayDureeNote est le temps effectif durant lequel on entend la note
                                        DelayRestant est le silence qui suit la note mais qui fait parti d'elle}

                                       DelayRestant := DelayNote - DelayDureeNote;

                                       inc(Delay, DelayDureeNote);

                                       for n := NbNotes - 1 downto 0 do with GetNote(n) do
                                       Begin
                                              //clef := Comp.DetecterClefAvecRelX(m, position.portee, pixx);
                                              //h := HauteurClefToAbs(clef, position.Hauteur);

                                              midii := HauteurNoteToMIDINote(hauteurnote)
                                                             +transpoportees[position.portee];

                                              if not (midii in laissersonner) then
                                              Begin
                                                       m_AddDelayTime(Delay);

                                                  m_AddNote(false, midii, attributs.Volume);

                                                  Delay := 0;
                                              End;






                                       End;

                                       inc(Delay, DelayRestant);
                                  {     else
                                             Delay := DelayRestant + DelayDureeNote; }

                                       //Delay := DelayRestant;

                                 End;

                           End; //if IsSilence then
                           Tick := Tick + DelayNote;

                       End; //for i := 0 to high(V.ElMusicaux) do with V.ElMusicaux[i] do

                       {if high(V.ElMusicaux) = -1 then
                             inc(delay, DelayMesure);}

                       inc(delay, DelayMesure - Tick);


                 End
                 else
                     inc(delay, QToInt(QMul(delaynoire, DureeTotale)));



           End;
           End;
           m_AddDelayTime(delay+delaynoire);
           m_AddFinDePiste;
           m_WritePiste;
    End;




CloseFile(f);


End;

end.
