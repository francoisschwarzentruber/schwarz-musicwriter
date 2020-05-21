unit MusicSystem_Composition_Avec_Paroles;

interface


uses MusicSystem_CompositionBase,
    MusicHarmonie;




    


type TParoles = record
    ivoix: integer;
    Paroles: string;
end;




type TCompositionAvecParoles = class(TCompositionBase)
   private
        private_paroles: array of TParoles;
        Function Paroles_Chercheri(i_voix: integer): integer;

        
   protected


        procedure Portee_Ajouter(indice, a_instru: integer; a_clef: TClef);
        Procedure Paroles_CalculerTout;

        Procedure Paroles_SaveOrLoad;
        
   public
        Procedure Paroles_Set(i_voix: integer; txt: string);
        Function Paroles_Get(i_voix: integer): string;
        Function Voix_IsParoles(i_voix: integer): Boolean;

end;





implementation

uses MusicWriter_Erreur, MusicSystem_Composition_Portees_Liste,
     MusicSystem_Curseur {pour TCurseur},
     MusicSystem_Voix,
     MusicSystem_ElMusical,
     FileSystem;



const SYLLABE_SEPARATOR = #9;




procedure TCompositionAvecParoles.Portee_Ajouter(indice, a_instru: integer; a_clef: TClef);
Begin
    inherited Portee_Ajouter(indice, a_instru, a_clef);
End;




Procedure TCompositionAvecParoles.Paroles_Set(i_voix: integer; txt: string);
var l, i: integer;
Begin
     i := Paroles_Chercheri(i_voix);

     if i = -1 then
     Begin
          l := length(private_paroles);
          Setlength(private_paroles, l+1);

          With private_paroles[l] do
          Begin
               ivoix := i_voix;
               Paroles := txt;

          End;     


     End
     else
          private_paroles[i].Paroles := txt;
End;



Function TCompositionAvecParoles.Paroles_Chercheri(i_voix: integer): integer;
var i: integer;
Begin
     for i := 0 to high(private_paroles) do
          if private_paroles[i].ivoix = i_voix then
          Begin
               result := i;
               Exit;
          End;


     result := -1;
End;


Function TCompositionAvecParoles.Voix_IsParoles(i_voix: integer): Boolean;
Begin
    result := (Paroles_Chercheri(i_voix) >= 0);
End;


Function TCompositionAvecParoles.Paroles_Get(i_voix: integer): string;
var i: integer;
Begin
     i := Paroles_Chercheri(i_voix);

     if i = -1 then
          result := ''

     else
          result := private_paroles[i].Paroles;
End;




procedure TCompositionAvecParoles.Paroles_SaveOrLoad;
var i, l, temp: integer;
Begin
          temp := 0;
          
          FichierDoSection('paroles');
          FichierDoInt(l, length(private_paroles));//////////////////

          if EnLecture then
           Begin
               Setlength(private_paroles, l);
           end;


          for i := 0 to high(private_paroles) do
          Begin

                 FichierDoInt(private_paroles[i].ivoix);
                 FichierDoInt(temp);
                 FichierDoInt(temp);
                 FichierDoInt(temp);
                 FichierDoStr(private_paroles[i].Paroles);

          End;
End;



Procedure TCompositionAvecParoles.Paroles_CalculerTout;
var i,j: integer;

    voix_courante: integer;
    
    c_mes,
    c_ind: integer;

    c_Voix: TVoix;


    Procedure Paroles_Init;
    var m, v, i: integer;
    Begin
         for m := 0 to high(Mesures) do
          With Mesures[m] do
            for v := 0 to high(Voix) do
            With Voix[v] do
               for i := 0 to high(ElMusicaux) do
                   ElMusicaux[i].Paroles_Syllabe_Set('');
    End;


    Function Voix_IsEOF: Boolean;
    Begin
        result := (c_mes > high(Mesures));
    End;

    Procedure Voix_PlacerSuivant;

        procedure Voix_AllerDebutMesure(m: integer);
        Begin
            c_mes := m;

            if Voix_IsEOF then exit;
            
            c_ind := 0;
            c_Voix := GetMesure(m).VoixNum(voix_courante);
        End;



    Begin
        inc(c_ind);
        
        if c_mes < 0 then
             Voix_AllerDebutMesure(0);
             
        While c_mes <= high(Mesures) do
        Begin
             if c_ind <= high(c_Voix.ElMusicaux) then
             Begin
                   if c_Voix.ElMusicaux[c_ind].IsSilence then
                        inc(c_ind)
                   else
                        exit;
             End
             else
                   Voix_AllerDebutMesure(c_mes + 1);
        End;


    End;

    procedure Voix_PlacerDebut;
    Begin
        c_mes := -1;
        Voix_PlacerSuivant;
        
    End;


    Function Voix_GetElMusical: TElmusical;
    Begin
        result := c_voix.ElMusicaux[c_ind];
    End;

    var i_debut_syllabe, longueur_syllabe: integer;
        syllabe_courante: string;
        
Begin


     Paroles_Init;
     
     for j := 0 to high(private_paroles) do
     With private_paroles[j] do
     Begin
           voix_courante := ivoix;
           Voix_PlacerDebut;

           i := 1;
           i_debut_syllabe := 0;
           syllabe_courante := '';
           While (i <= length(Paroles)) and not Voix_IsEOF do

           Begin
                 syllabe_courante := '';
                 i_debut_syllabe := i;
                 longueur_syllabe := 0;

                 for i := i to length(Paroles) do
                 Begin
                      if Paroles[i] = SYLLABE_SEPARATOR then
                      Begin

                           Break;
                      End
                      else
                          inc(longueur_syllabe);
                 End;
                 inc(i);

                 Voix_GetElMusical.Paroles_Syllabe_Set(
                 copy(Paroles, i_debut_syllabe, longueur_syllabe));

                 Voix_PlacerSuivant;
           End;
           


     End;
End;



end.
