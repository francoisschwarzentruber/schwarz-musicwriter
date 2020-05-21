unit MusicSystem_CompositionLectureMIDI;

interface


uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicSystem_CompositionBase,
     MusicSystem_CompositionBaseAvecClef,
     MusicSystem_CompositionGestionBarresDeMesure,
     MusicHarmonie;





type



TiMesureLecture = record
    iMesure: integer;
    nbtick_depuis_debut: integer;

end;


TListeDeLecture = array of TiMesureLecture;



TCompositionAvecLectureMIDI = class(TCompositionGestionBarresDeMesure)
private
    Procedure LectureMIDI_ListeDeLectureCalculer(var ListeDeLecture: TListeDeLecture);

public


     Function LectureMIDI_GetListeiMesuresDeLecture: TListeDeLecture;
     {renvoie en gros la liste des mesures à jouer...
      si la partition ne comporte pas de mesures, ça renvoie la liste
       0..NbMesures - 1
      sinon, ça recopie les blocs correspondants etc...}

      Procedure LectureMIDI_GetMesuresEtTemps(
                                      ListeDeLecture: TListeDeLecture; 
                                      trkpos : integer;
                                      var m: integer; var t: TRationnel);


      Function LectureMIDI_GetTrackPosition(ListeDeLecture: TListeDeLecture; m: integer): integer;

      
end;

     
implementation

uses MusicWriterToMIDI,
     MusicWriter_Erreur;



     
Procedure TCompositionAvecLectureMIDI.LectureMIDI_ListeDeLectureCalculer(var ListeDeLecture: TListeDeLecture);
var ildl: integer;
    t: real;

    
Begin
        t := 0;
        for ildl := 0 to high(ListeDeLecture) do
        With GetMesure(ListeDeLecture[ildl].imesure) do
        Begin
             ListeDeLecture[ildl].nbtick_depuis_debut := round(t);
             
        //{$IF defined(PRECOND)}
             if Metronome <= 0 then
             Begin
                    MessageErreur('Dans LectureMIDI_ListeDeLectureCalculer, Metronome de la mesure n° ' +
                                   inttostr(ListeDeLecture[ildl].imesure) + ' vaut 0 ou moins');
                     delaynoire := 10;
             End
             else
        //{$IFEND}

                 delaynoire := (delayuneminute) div Metronome;
                 t := t + QToReal(QMul(Qel(delaynoire*2),
                                   DureeTotale)) * factordelaynoire;



        End;


End;




Function TCompositionAvecLectureMIDI.LectureMIDI_GetListeiMesuresDeLecture: TListeDeLecture;
var L:TListeDeLecture;
    indice, imesure, imesure_debutreprise: integer;

    procedure EcrireLaMesureEnCours;
    Begin
         L[indice].iMesure := imesure;
         inc(indice);
    End;


    procedure EcrireEncoreUneFoisTouteLaZoneReprise;
    var im: integer;

    Begin
         for im := imesure_debutreprise to imesure do
         Begin
             L[indice].iMesure := im;
             inc(indice);
         End;
    End;


Begin
   Setlength(L, 2*NbMesures);
   indice := 0;

   imesure_debutreprise := 0;

   for imesure := 0 to NbMesures - 1 do
   Begin
       EcrireLaMesureEnCours;

       if Is_Mesure_Reprise_Debut(imesure) then
             imesure_debutreprise := imesure;

       if Is_Mesure_Reprise_Fin(imesure) then
             EcrireEncoreUneFoisTouteLaZoneReprise;

   End;

   Setlength(L, indice);

   LectureMIDI_ListeDeLectureCalculer(L);
   
   result := L;
End;




Procedure TCompositionAvecLectureMIDI.LectureMIDI_GetMesuresEtTemps(
                                      ListeDeLecture: TListeDeLecture;
                                      trkpos : integer;
                                      var m: integer; var t: TRationnel);
{trkpos : position de la trackbar

 renvoit m entre 0 et high(Mesures)
         t entre 0 et ... (0 = début de mesure)

}


var ildl, trkposdebutmes: integer;
    delaynoire: integer;

    depasse: boolean;

Begin

      m := 0;
      trkposdebutmes := 0;

      for ildl := 0 to high(ListeDeLecture) do
      With ListeDeLecture[ildl] do
      Begin
{      rem : nbtick_depuis_debut est un champ de ListeDeLecture[ildl]}
              depasse := nbtick_depuis_debut > trkpos;
              if not depasse then
              Begin
                   m := iMesure;
                   trkposdebutmes := nbtick_depuis_debut;
              end
              else break;
      End;

      {m contient la mesure dans laquelle on est}


      delaynoire := (delayuneminute) div GetMesure(m).Metronome;
      t := Qel((trkpos - trkposdebutmes),(2*delaynoire));
         {if IsQ1InfQ2(QAdd(Mesures[m].DureeTotale, QEl(1)), t) then
            t := Mesures[m].DureeTotale; }

            
      VerifierIndiceMesure(m, 'postcondition dans LectureMIDI_GetMesuresEtTemps');
End;




Function TCompositionAvecLectureMIDI.LectureMIDI_GetTrackPosition(
                        ListeDeLecture: TListeDeLecture; m: integer): integer;
{renvoie la position qu'à la trackbar de lecture si on est en train de lire
 le début de la mesure m}

var i: integer;
    t: real;

    
Begin
result := ListeDeLecture[high(ListeDeLecture)].nbtick_depuis_debut;

for i := 0 to high(ListeDeLecture) do
   With ListeDeLecture[i] do
       if iMesure = m then
            result := nbtick_depuis_debut; 
exit;


t := 0;
for i := 0 to m-1 do
Begin
//{$IF defined(PRECOND)}
     if Mesures[i].Metronome <= 0 then
     Begin
            MessageErreur('Dans TrackPosition, Metronome de la mesure n° ' +
                           inttostr(i) + ' vaut 0 ou moins');
             delaynoire := 10;
     End
     else
//{$IFEND}

         delaynoire := (delayuneminute) div Mesures[i].Metronome;
         t := t + QToReal(QMul(Qel(delaynoire*2),
                           Mesures[i].DureeTotale)) * factordelaynoire;

End;

result := round(t);
End;



end.
