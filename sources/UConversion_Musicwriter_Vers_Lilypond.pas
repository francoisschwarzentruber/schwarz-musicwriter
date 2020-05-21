unit UConversion_Musicwriter_Vers_Lilypond;

interface

uses MusicHarmonie, MusicSystem_Composition;


procedure WriteLilypond(Comp: TComposition; fichier_nom: string);




implementation

uses MusicSystem_MesureBase, MusicSystem_Voix, MusicSystem_ElMusical, SysUtils,
     MusicWriter_Erreur, QSystem;

const Alaligne = #13 + #10;

type TIntArray = array of integer;


Function CompositionGetVoixPresentes(Comp: TComposition): TIntArray;
{calcule le tableau des instruments m_instr}

var voix_tab: TIntArray;


    Procedure Voix_Tab_Init;
    Begin
         setlength(voix_tab, 0);
    End;


    Function Voix_Tab_IsContientNumVoix(num_voix: integer): Boolean;
    var i: integer;
    Begin
       result := false;

       for i := 0 to high(voix_tab) do
               if voix_tab[i] = num_voix then
               Begin
                   result := true;
                   Break;

               End;


    End;



    procedure Voix_Tab_Ajouter(num_voix: integer);
    Begin
          Setlength(voix_tab, length(voix_tab)+1);
          voix_tab[high(voix_tab)] := num_voix;

    end;


var m, v, newvoix: integer;

Begin
    Voix_Tab_Init;


    for m := 0 to Comp.NbMesures - 1 do
        With Comp.GetMesure(m) do
        for v := 0 to high(Voix) do with Voix[v] do if IsEntendue then
        if not Voix[v].IsVide then
        Begin
                 newvoix := Voix[v].N_Voix;
                 if not Voix_Tab_IsContientNumVoix(newvoix) then
                 {si la voix courante n'est pas déjà présente}
                     Voix_Tab_Ajouter(newvoix);
        end;

    result := voix_tab;
End;



Function TCompositionToLilypondStructureGlobale(Comp: TComposition): string;
Begin
     result := '';
End;




Function SuiteDeChiffreTransformerPourQuePlusDeChiffres(s: string): string;
     var i: integer;
     Begin
         for i := 1 to length(s) do
               s[i] := Chr(65 + strtoint(s[i]));

         result := s; 
     End;


Function VoixLibelleLilypond(voix_num: integer): string;
Begin
    result := 'voix' + SuiteDeChiffreTransformerPourQuePlusDeChiffres(inttostr(voix_num));
End;



Function PorteeLibelleLilypond(ip: integer): string;
Begin
    result := 'portee' + SuiteDeChiffreTransformerPourQuePlusDeChiffres(inttostr(ip));
End;



Function THauteurNoteToLilypondSansTenirCompteDeLOctave(hn: THauteurnote): string;
    Function HauteurToStr(hauteur: integer): string;
     Begin
         case hauteur mod 7 of
            0: result := 'c';
            1: result := 'd';
            2: result := 'e';
            3: result := 'f';
            4: result := 'g';
            5: result := 'a';
            6: result := 'b';
         end;
     End;


     Function AlterationToStr(a: TAlteration): string;
     Begin
          case a of
              aDbBemol: result := 'eses';
              aBemol: result := 'es';
              aNormal: result := '';
              aDiese: result := 'is';
              aDbDiese: result := 'isis';
              else
                 MessageErreur('AlterationToStr');
          end;
     End;

     var hinoct, oct: integer;
Begin
    hinoct := IndiceNote(hn.Hauteur);
    result := HauteurToStr(hinoct) + AlterationToStr(hn.alteration);
End;


Function THauteurNoteToLilypond(hn: THauteurnote): string;


     Function OctaveToStr(oct: integer): string;
     Begin
         case oct of
             -1: result := '';
             0: result := '''';
             1: result := '''''';
             2: result := '''''''';
             3: result := '''''''''';
             4: result := '''''''''''';
             -2: result := ',';
             -3: result := ',,';
             -4: result := ',,,';
             else
                 MessageErreur('OctaveToStr');

         end;
     End;




     var hinoct, oct: integer;
Begin

    oct := Octave(hn.Hauteur);
    hinoct := IndiceNote(hn.Hauteur);
    result := THauteurNoteToLilypondSansTenirCompteDeLOctave(hn) + OctaveToStr(oct);
End;



Function DurationToLiLypond(q: TRationnel): string;
   Begin
       if IsQEgal(q, Qel(4)) then
             result := '1'
       else if IsQEgal(q, Qel(2)) then
             result := '2'
       else if IsQEgal(q, Qel(1)) then
             result := '4'
       else if IsQEgal(q, Qel(1, 2)) then
             result := '8'
       else if IsQEgal(q, Qel(1, 4)) then
             result := '16'
       else if IsQEgal(q, Qel(1, 8)) then
             result := '32'
       else if IsQEgal(q, Qel(1, 16)) then
             result := '64'
       else if IsQEgal(q, Qel(6)) then
             result := '1.'
       else if IsQEgal(q, Qel(3)) then
             result := '2.'
       else if IsQEgal(q, Qel(3, 2)) then
             result := '4.'
       else if IsQEgal(q, Qel(3, 4)) then
             result := '8.'
       else if IsQEgal(q, Qel(3, 8)) then
             result := '16.'

       else
       Begin
           MessageErreur('DurationToStr : durée non géré (' + QToStr(q) + ')');
           result := '';
       End;

   End;


Function ElMusicalToLilypond(el: TElMusical): string;
   Function ElMusicalNotesToLilypond(el: TElMusical): string;
   var n: integer;
       iportee: integer;
   Begin
       iportee := el.PorteeApprox;
       result := ' \change Staff=' + PorteeLibelleLilypond(iportee) + ' ';

       if el.QueueVersBas then
                  result := result + ' \voiceTwo '
       else
                  result := result + ' \voiceOne ';


       if el.NbNotes = 1 then
       Begin
             result := result + THauteurNoteToLilypond( el.GetNote(0).HauteurNote)  + DurationToLiLypond(el.Duree_Get);
             if el.IsNoteLieeALaSuivante(0) then
                  result := result + ' ~ ';
       End
       else
       Begin
             result := result + '<';
             for n := 0 to el.NbNotes - 1 do
                     result := result + THauteurNoteToLilypond( el.GetNote(n).HauteurNote) + ' ';
             result := result + '>'  + DurationToLiLypond(el.Duree_Get);
       End;
   End;




   
Begin
    if el.IsSilence then
        result := 'r' + DurationToLiLypond(el.Duree_Get)
    else
         result := ElMusicalNotesToLilypond(el) ;
End;












Function PorteeClefToLilypond(clef: TClef): string;
Begin
    if clef = ClefSol then
        result := '\clef violin'
    else if clef = ClefFa then
        result := '\clef bass'
    else
    Begin
       result := '';
       MessageErreur('PorteeClefToLilypond : clef non gérée');
    End;
End;


Function CompositionInformationsPorteesEtReferencesVoix(Comp: TComposition; voix_tab: TIntArray): string;

    Function PorteeToLilypond(ip: integer): string;
    var i: integer;
    Begin
        result := '\new Staff = "' + PorteeLibelleLilypond(ip) + '" <<' +
                  PorteeClefToLilypond(Comp.I_Portee_Clef[ip]) + ' ';

        result := result + '\' + 'global' + ' ';
        for i := 0 to high(voix_tab) do
            if Comp.Voix_Indice_To_Portee(voix_tab[i]) = ip then
                 result := result + '\' + VoixLibelleLilypond(voix_tab[i]) + ' ';

        result := result + ' >>' + Alaligne;
    End;


    Function GroupePorteesToLilypond(ip: integer): string;
    var i: integer;
    Begin
       result := '\context PianoStaff <<';

       for i := ip to Comp.Portee_GetNbPorteesInGroupe(ip) do
              Result := result + PorteeToLilypond(i) + Alaligne;

       result := result + '>>' + AlaLigne;

    End;

var ip: integer;
Begin
    result := '';
    result := result + '\score { <<';

    ip := 0;
    while ip <= Comp.NbPortees - 1 do
    Begin
        if Comp.Portee_GetNbPorteesInGroupe(ip) = 0 then
              result := result + PorteeToLilypond(ip)
        else
              result := result + GroupePorteesToLilypond(ip); 

        inc(ip, Comp.Portee_GetNbPorteesInGroupe(ip) + 1);
    End;
    result := result + '>>' + ALaligne;

   { result := result + '\layout { \context { \Score ' + Alaligne;
    result := result + '\override Staff.NoteCollision #''merge-differently-headed = ##t';
    result := result + Alaligne;
    result := result + '\override SpacingSpanner #''spacing-increment = #3';
    result := result + '}{ }{';
    }

    result := result + ' }';

End;



Function CompositionMesureInfosGlobalesToLilypond(Comp: TComposition): string;
var m: integer;

   procedure EcrireChangementRythme;
   Begin
        result := result + '\time ' + inttostr(Comp.GetMesure(m).Rythme.num) + '/' + inttostr(Comp.GetMesure(m).Rythme.denom) + Alaligne;

   End;

   procedure EcrireChangementTonalite;
   Begin
       result := result + '\key ' + THauteurNoteToLilypondSansTenirCompteDeLOctave(TonaliteToTonique(Comp.GetMesure(m).GetTonalite)) + ' \major'  + Alaligne;
                           //\key a \minor

   End;

Begin
    result := 'global = {' + Alaligne;

    for m := 0 to Comp.NbMesures - 1 do
    Begin
        if m = 0 then
             EcrireChangementRythme
        else
             if not IsQEgal(Comp.GetMesure(m-1).Rythme, Comp.GetMesure(m).Rythme) then
                   EcrireChangementRythme;

        if m = 0 then
             EcrireChangementTonalite
        else
             if not (Comp.GetMesure(m-1).GetTonalite = Comp.GetMesure(m).GetTonalite) then
                   EcrireChangementTonalite;

        result := result + 's' + DurationToLiLypond(Comp.GetMesure(m).DureeTotale) + ' ';

    End;
    result := result + Alaligne;
    result := result + '\bar "|."' + Alaligne;
    result := result + '}' + Alaligne;
End;


Function TCompositionToLilypond(Comp: TComposition): string;
    const LilyPondVersion = '\version "2.10.33"';

    Function InstructionPourLesDirectionsDesQueues(voix_num: integer): string;
    var i: integer;
    Begin
         i := Comp.Voix_Indice_To_NumVoixDansPortee(voix_num);

         case i of
                0: result := '\voiceOne';
                1: result := '\voiceTwo';
                2: result := '\voiceThree';
                3: result := '\voiceFour';
                else
                Begin
                    result := '';
                    MessageErreur('trop de voix');

                End;
         end;
    End;

    Function VoixCompositionToLilypond(voix_num: integer): string;
    var ip: integer;
          Function VoixToLilypond(v: TVoix): string;
          var i : integer;
          Begin
               result := '';

               for i := 0 to high(v.ElMusicaux) do
               Begin
                     if ip <> v.ElMusicaux[i].PorteeApprox then
                     Begin
                         ip := v.ElMusicaux[i].PorteeApprox; 

                     End; 
                     result := result + ElMusicalToLilypond(v.ElMusicaux[i]) + ' ';

               End;

          End;


    var m : integer;
    Begin
         ip := Comp.Voix_Indice_To_Portee(voix_num);
         result := VoixLibelleLilypond(voix_num) + ' = \new Voice {';
         result := result + InstructionPourLesDirectionsDesQueues(voix_num) + Alaligne;


         for m := 0 to Comp.NbMesures - 1 do
                With Comp.GetMesure(m) do
                Begin
                    If IsVoixNumPresente(voix_num) then
                         result := result + VoixToLilypond(VoixNum(voix_num))
                    else
                         result := result + '\skip ' + DurationToLiLypond(DureeTotale);

                    if m < Comp.NbMesures - 1 then
                            result := result + '|';

                End;

         result := result + '}' + Alaligne;

    End;


    Function CompositionInformationsGlobalesToLilypondHeader(comp: TComposition): string;
    Begin
          result := '\header {' + Alaligne +
                          'title = ""' + Alaligne
                          + 'composer = ""' + Alaligne +
                          '}' + Alaligne;

          {
    \header {
  title = "Petite Ouverture à danser"
  subtitle = "4"
  source = ""
  composer = "Erik Satie (1866-1925)"
  enteredby = "jcn"
  copyright = "Public Domain"
}
    End;




var voix_tab: TIntArray;
    i : integer;

Begin
    result := LilypondVersion + AlaLigne;
    result := result + CompositionInformationsGlobalesToLilypondHeader(Comp) + Alaligne;

    result := result + CompositionMesureInfosGlobalesToLilypond(Comp) + Alaligne;

    voix_tab := CompositionGetVoixPresentes(Comp);

    for i := 0 to high(voix_tab) do
         result := result + VoixCompositionToLilypond(voix_tab[i]);

    result := result + CompositionInformationsPorteesEtReferencesVoix(Comp, voix_tab);




End;





procedure WriteLilypond(Comp: TComposition; fichier_nom: string);
var f: TextFile;
Begin
    assignfile(f, fichier_nom);
    rewrite(f);
    Write(f, TCompositionToLilypond(Comp));
    Closefile(f);
End;

end.
