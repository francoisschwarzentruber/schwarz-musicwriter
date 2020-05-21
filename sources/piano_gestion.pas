unit piano_gestion;

interface

uses MusicSystem_Composition, QSystem;

procedure Piano_Gestion_Init(Composition: TCOmposition; apartirde_imesure: integer; apartirde_temps: TRationnel);
procedure Piano_Gestion_Jouer(Composition: TCOmposition; jusqua_imesure: integer; jusqua_temps: TRationnel);


implementation

uses MusicSystem_Voix, MusicSystem_CompositionBase, piano,
     MusicGraph_CouleursVoix,
     MusicGraph_Portees {pour IGP};

type 
TCurseurVoix = record
    imesure: integer;
    indice: integer;
    temps: TRationnel;
end;

const voix_indice_max = 1000;


var curseur_voix: array[0..voix_indice_max] of TCurseurVoix;



procedure Piano_Gestion_Init(Composition: TCOmposition; apartirde_imesure: integer; apartirde_temps: TRationnel);
var i: integer;
Begin
     for i := 0 to voix_indice_max do
         curseur_voix[i].imesure := -1;
End;


procedure Piano_Gestion_Jouer(Composition: TCOmposition; jusqua_imesure: integer; jusqua_temps: TRationnel);
var iv, indice_courant, num_voix: integer;

   Function NumVoixToMain(portee: integer): TMainHumaine;
   Begin
       if portee > 1 then
          result := MainDroite
       else
          result := TMainHumaine(portee);

   End;

Begin
     IGP := Composition;
     With Composition do
     With GetMesure(jusqua_imesure) do
     for iv := 0 to high(Voix) do
     With Voix[iv] do
          Begin
               num_voix := Voix[iv].N_Voix;

               if num_voix >= 0 then
               Begin
                   indice_courant := IndiceSurTemps(QAdd(Qel(1), jusqua_temps))-1;

                   if indice_courant < 0 then
                       if high(ElMusicaux) >= 0 then
                           indice_courant := 0;

                   With curseur_voix[num_voix] do
                   Begin
                       if (imesure <> jusqua_imesure) or (indice <> indice_courant) then
                       Begin
                           if (imesure <> -1) and (indice <> -1)  then
                                Piano_Touches_Relever(GetMesure(imesure).VoixNum(num_voix).ElMusicaux[indice]);

                       End
                       else
                          if indice_courant >= 0 then
                           Piano_Touches_Enfoncer(ElMusicaux[indice_courant],
                                                  CouleursVoixNote(Composition, num_voix ),
                                                  NumVoixToMain(Get_N_Voix_Portee));


                       imesure := jusqua_imesure;
                       indice := indice_courant;

                   End;
               End;

          End;

     if frmPiano <> nil then
        frmPiano.FormPaint(nil);     
     
End;



end.
