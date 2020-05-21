unit MusicWriterToWAV;

interface

uses MusicSystem_Composition,
     MusicSystem_Constantes,
     MusicSystem_Mesure,
     MusicSystem_Voix,
     MusicSystem_ElMusical;


procedure WriteWAV(Comp: TComposition; filename: string);

implementation

uses MusicToWAVe, MusicWriterToMIDI {pour le tableau des voix},
QSystem, MusicHarmonie, MusicWriter_Erreur, MusicUser {pour MessageErreur},
      SysUtils {pour inttostr};


Function InstrumentToTimbre(i:integer): TFonctionTimbre;
Begin
case i+1 of
     1: result := TimbrePiano;
     58: result := TimbreTrompette;
     72: result := TimbreClarinette;
     74: result := TimbreFlute;
     else result := TimbrePiano;
end;
End;

procedure WriteWAV(Comp: TComposition; filename: string);
var m, p, i, n, h: integer;
    numvoix: integer;
    Tick, DelayNote, DelayDureeNote, DelayRestant, DelayMesure: LongWord;
    V: TVoix;
    clef: TClef;
    anclaissersonner, laissersonner: set of Byte;
    midii: Byte;
    InstrumentMIDICourant: Byte;
    hautenotesecondaire: THauteurNote;

    temps,tempsduree : integer;


    mw: TMusicToWave;


Begin
mw := TMusicToWave.Create(10000000);

//mw.AddDing();


    laissersonner := [];

    Preparern_voixdpistes(Comp);

    setlength(transpoportees, Comp.NbPortees);

    for p := 0 to high(transpoportees) do
        transpoportees[p] :=
            HauteurNoteToMIDINote(Comp.Portee_Transposition[p])-60;



    for p := 0 to high(n_voixdpistes) do
    Begin
           delay := 0;
           temps := 0;
           numvoix := n_voixdpistes[p];
           InstrumentMIDICourant := m_instr[p];

           for m := 0 to Comp.NbMesures - 1 do
           With Comp.GetMesure(m) do
           Begin
                 //calcul de delaynoire...
                 if Metronome <= 0 then
                 Begin
                       {au cas où, histoire que ça fasse pas div 0}
                       MessageErreur('Dans WriteWAV, Metronome de la mesure n° ' +
                           inttostr(m) + ' vaut 0 ou moins');
                       Metronome := 120;
                 end;
                 delaynoire := (delayuneminute) div Metronome;


                 Tick := 0;
                 DelayMesure := QMul2(DelayNoire, DureeTotale);

                 if VoixNumInd(numvoix) > -1 then
                 Begin
                       V := VoixNum(numvoix);

                       for i := 0 to high(V.ElMusicaux) do with V.ElMusicaux[i] do
                       Begin
                           {if GetAttrib(as1_Pizzicato) then
                                ChangerInstrumentMIDISiNecessaire(46)
                           else
                                ChangerInstrumentMIDISiNecessaire(m_instr[p]); }


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
                                 inc(temps, DelayNote);
                           End
                           else
                           Begin
                                 if attributs.Style2 in aSetTrille then
                                 Begin
                                      //prépare la hauteur de la note secondaire nécessaire pour effectuer le trille
                                      hautenotesecondaire := GetNote(0).HauteurNote;
                                      inc(hautenotesecondaire.hauteur, 1);
                                      DelayNote := QToInt(QMul(delaynoire, Duree_Get));
                                      {WriteTrille(HauteurNoteToMIDINote(Notes[0].HauteurNote)
                                                   +transpoportees[Notes[0].position.portee],
                                                  HauteurNoteToMIDINote(hautenotesecondaire)
                                                   +transpoportees[Notes[0].position.portee],
                                                  DelayNote, V.ElMusicaux[i].attributs.volume);  }




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
                                                  Delay := 0;



                                       End;





                                       if i = high(V.ElMusicaux) then
                                       {si on est sur le dernier élément musical on complète la mesure
                                             (ceci évite les effets de retards...)}
                                           DelayNote := DelayMesure - Tick
                                       else
                                           DelayNote := QToInt(QMul(delaynoire, V.ElMusicaux[i].Duree_Get));

                                       tempsduree := DelayNote;
                                       for n := NbNotes - 1 downto 0 do with GetNote(n) do
                                            mw.AddDing(temps*100, (temps + tempsduree)*100, HauteurNoteToFreq(HauteurNote), 500, InstrumentToTimbre(InstrumentMIDICourant));

                                       temps := temps + tempsduree;
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
                                             // h := HauteurClefToAbs(clef, position.Hauteur);

                                              midii := HauteurNoteToMIDINote(hauteurnote)
                                                             +transpoportees[position.portee];

                                              if not (midii in laissersonner) then
                                                  Delay := 0;






                                       End;

                                       inc(Delay, DelayRestant);
                                  {     else
                                             Delay := DelayRestant + DelayDureeNote; }

                                       //Delay := DelayRestant;

                                 End;

                           End;
                           Tick := Tick + DelayNote;

                       End;

                       if high(V.ElMusicaux) = -1 then
                             inc(delay, DelayMesure);


                 End
                 else
                     inc(delay, QToInt(QMul(delaynoire, DureeTotale)));



           End;
         //  m_AddDelayTime(delay+delaynoire);
         //  m_AddFinDePiste;
         //  m_WritePiste;
    End;



mw.WriteOnDisk(filename);
End;
end.
