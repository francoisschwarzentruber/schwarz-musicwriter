unit MusicSystem_Curseur;

interface

uses MusicSystem_Types,
     MusicSystem_CompositionSub,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_CompositionAvecPagination,
     MusicSystem_Mesure,
     QSystem,
     MusicHarmonie,
     Types {pour TPoint};


type



{ce type modélise un curseur dans le document}
TCurseur = class(TObject)
private
    Composition: TCompositionSub;

    iMesure: integer;
    iIndice: integer;
    voix_courante: integer;
    Dessus: Boolean;

    pixx_in_mesure,
    pixy_in_doc: integer;
    position: TPosition;

    AlterationCourante: TAlteration;



public


{accès à la position du curseur}
    Function GetiMesure: integer;
    Function GetiIndice: integer;
    Function GetPosition: TPosition;
    
    Function GetiPortee: integer;
    Function GetiPorteeEditee: integer;
    
    Function GetiVoixSelectionnee: integer;
    Function GetTempsDepuisDebutMesure: TRationnel;
    Function GetiLigne: integer;

    Function GetPixx_in_doc: integer;
    Function GetPixy_in_doc: integer;
    Function GetPixx_in_mesure: integer;
    Function GetPoint_Pix_in_Document: TPoint;

    Function Tablature_CordeNum_Get: integer;


{accès à des infos supplémentaires}
    Function GetElementMusical: TElMusical;
    Function GetElementMusicalPrecedent: TElMusical;
    
    Function GetNoteSousCurseur(out note: TPNote): Boolean; overload;
    Function GetNoteSousCurseur: TPNote; overload;
    Function GetVoixMesure: TVoix;
    Function GetMesure: TMesure;
    Function GetInfoClefCourante: TInfoClef;
    Function GetTonaliteCourante: TTonalite;
    Function GetHauteurNote: THauteurNote;


{test de position}
    Function Is_SurMesure_FinaleAAjouter: Boolean;

    Function Is_Mesure_DebutDeMesure: Boolean;
    Function Is_Mesure_FinDeMesure: Boolean;

    Function Is_ElementMusical_Dessus: Boolean;

    Function Is_Curseur_Sur_Tablature: Boolean;

    
{modification de position relative}
    Function DR_AllerADroite: Boolean;
    Function DR_AllerAGauche: Boolean;

    procedure DR_DeplacerVersLeHaut;
    procedure DR_DeplacerVersLeBas;

    Function DR_Deplacer_PorteeDuHaut: Boolean;
    Function DR_Deplacer_PorteeDuBas: Boolean;


    Function DR_ElementMusicalPrecedentPasDessus: Boolean;
    Function DR_ElementMusicalSuivantPasDessus: Boolean;

    Function DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante: Boolean;
    
    Procedure DR_ElementMusical_AllerDessusOuPas(b: Boolean);
    Procedure DR_ElementMusical_AllerDessusOuPasSansChangerX(b: Boolean);
    Procedure DR_Voix_Changer(newvoixselectionnee: integer);

    Procedure DR_MiniDRCarModif;

    procedure DR_MemeVoixFinMesure;


{modification de position absolue}
    procedure DA_Mesure_Debut(imes: integer);
    procedure DA_Set(voix, imes, iind: integer; pos: TPosition);
    procedure DA_SetAvecXMesure(voix, m, a_pixx_in_mesure: integer; pos: TPosition);
    procedure DA_SetAvecTemps(voix, imes: integer; temps: TRationnel; pos: TPosition);

    procedure CalculerXY_CurseurClavier;
    constructor Create(C: TCompositionSub);

    procedure Verifier(mess: string);
    procedure VerifieriMesureVraieIndice(mess: string);

    procedure SetPositionHauteur(hauteur_graphique: integer);
    procedure SetPositionGraphique(pos: TPosition);
    procedure SetHauteurNote(hauteurnote: THauteurNote);
    procedure SetHauteurNoteAlteration(alteration: TAlteration);
    procedure SetHauteurNoteAlterationParDefaut;

{extraction d'information textuelle}
    Function InfoTxtGet_Mesure_Temps: string;
    
end;



implementation


uses MusicWriter_Erreur, MusicGraph,
     MusicGraph_Portees {pour nbpixlign...},
     SysUtils {pour inttostr},
     tablature_system,
     MusicUser {pour TonaliteCourante},
     navigateur,
     Main,

     Message_Vite_Fait,
     MusicUser_PlusieursDocuments;


procedure private_ya_eu_deplacement_de_curseur;
Begin

    actchild.Navigateur.Refresh;
End;



constructor TCurseur.Create(C: TCompositionSub);
Begin
    Composition := C;

    position.portee := 0;
    position.hauteur := 0;
    
    iMesure := 0;
    iIndice := 0;
    
    voix_courante := 0;
    dessus := false;

    pixx_in_mesure := 0;
    pixy_in_doc := 0;

    AlterationCourante := aNormal;

    
End;




procedure TCurseur.Verifier(mess: string);
      Function ResumeDuCurseur: string;
      Begin
         result := '(mes = ' + inttostr(imesure) + ', ' +
                   'voix = ' + inttostr(voix_courante) + ', ' +
                   'el_ind = ' + inttostr(iindice) + ') ';

         if Not Is_SurMesure_FinaleAAjouter then
              result := result +
                   'dans la voix, il y a ' + inttostr(GetVoixMesure.NbElMusicaux)
                   + ' éléments musicaux';
      End;

Begin
   if self = nil then
   Begin
          MessageErreur('erreur grave dans TCurseur.Verifier : curseur à nil');
          Exit;
   End;

   if PointeurMalFichu(Composition) then
         MessageErreur('erreur grave dans TCurseur.Verifier : Composition mal fichu');

   Composition.VerifierIndiceMesureOuDerniere(imesure, 'TCurseur.Verifier : ' + ResumeDuCurseur + mess);
   Composition.VerifierPosition(position,  'TCurseur.Verifier : ' + ResumeDuCurseur + mess);

   if iMesure < Composition.NbMesures then
   Begin
       Composition.GetMesure(iMesure)
                  .VoixNum(voix_courante)
                  .VerifierIndiceElMusicalOuFin(iindice,
                                                'TCurseur.Verifier : ' + ResumeDuCurseur + mess);

       if Dessus then
       Begin
          if not Composition.GetMesure(iMesure)
                     .VoixNum(voix_courante)
                     .VerifierIndiceElMusical(iindice,
                                 'TCurseur.Verifier (dessus = true) : ' + ResumeDuCurseur + mess
                                 + ' On met dessus = false.') then
                                  dessus := false;
       End;

   End
   else
   Begin
       if Dessus then
           MessageErreur('Dessus = true alors qu''on est dans la mesure finale à ajouter !');

       if iIndice > 0 then
           MessageErreur('L''indice est positif alors qu''on est dans la mesure finale à ajouter !');

   End;
   
End;




procedure TCurseur.VerifieriMesureVraieIndice(mess: string);
Begin
      Composition.VerifierIndiceMesure(iMesure, mess);

End;



procedure TCurseur.CalculerXY_CurseurClavier;
var hcm,hcmve,cmpixx,
    x, x1, x2, i, l: integer;
    V: TVoix;

Begin
    hcm := Composition.NbMesures - 1;
    if Is_SurMesure_FinaleAAjouter then
              x := {Composition.GetMesure(hcm).pixx +
                    Composition.GetMesure(hcm).pixWidth + } EcartCurseurClavier
    else
    Begin
              V := Composition.GetMesure(GetiMesure).VoixNum(voix_courante);
              cmpixx := Composition.GetMesure(GetiMesure).pixx;
              hcmve := high(V.ElMusicaux);

              if hcmve = -1 then
                 {s'il n'y a pas d'éléments musicaux dans la voix en cours}
                     x := Composition.GetMesure(GetiMesure).pixXApresTonaliteDebutEtRythme
                                          + EcartCurseurClavier

              else if Is_Mesure_FinDeMesure then
              {en fin de mesure}
                     //x := Composition.Mesures[Curseur.iMesure].pixWidth - ecart;
                     x := Composition.GetMesure(GetiMesure).XATemps(QAdd(V.DureeTotale,Qel(1)))

              else if Is_Mesure_DebutDeMesure then
              {en début de mesure}

                     x := Composition.GetMesure(GetiMesure).pixXApresTonaliteDebutEtRythme
              else if Is_ElementMusical_Dessus then
              {sur un élément musical}

                     x := V.ElMusicaux[GetiIndice].pixx
                          - V.ElMusicaux[GetiIndice].pixWidth div 2 - miniecartCurseurClavier
              else
              {entre deux éléments musicaux}
                  Begin
                       x1 := V.ElMusicaux[GetiIndice-1].pixx + V.ElMusicaux[GetiIndice-1].pixWidth div 2;
                       x2 := V.ElMusicaux[GetiIndice].pixx - V.ElMusicaux[GetiIndice].pixWidth div 2;
                       x := (x1 + x2) div 2;
                  End;

              {si le curseur ne se trouve pas pile sur un él. musical, évite
                que le curseur se trouve pile poil affiché sur une clef (c'est
                vraiment pas bo :) ) }
              if not Is_ElementMusical_Dessus then
              With Composition.GetMesure(GetiMesure) do
              for i := 0 to high(ClefsInserees) do
                          With ClefsInserees[i] do
                                if (pixx <=  x) and (x <= pixx + largclef) then
                                       x := pixx + largclef;

              {ici x représente la position du curseur dans la mesure}

    End;

    l := Composition.LigneAvecMes(iMesure);
    pixy_in_doc := Composition.Lignes[l].pixy;

    pixx_in_mesure := x + nbpixlign;


End;



Function TCurseur.GetiMesure: integer;
Begin
    result := iMesure;
End;


Function TCurseur.GetiIndice: integer;
Begin
    result := iIndice;
End;



Function TCurseur.GetPosition: TPosition;
Begin
    Verifier('au début de TCurseur.GetPosition');
    result := Position;
End;


Function TCurseur.GetiPortee: integer;
Begin
    result := position.portee;
End;



Function TCurseur.GetiPorteeEditee: integer;
Begin
     if Is_Curseur_Sur_Tablature then
         result := position.portee - 1
     else
         result := position.portee;

     Composition.VerifierIndicePortee(result, 'TCurseur.GetiPorteeEditee');
End;


Function TCurseur.GetPixy_in_doc: integer;
Begin
    result := Composition.Portee_YBas(GetiLigne, GetiPorteeEditee);

End;



Function TCurseur.GetPixx_in_doc: integer;
Begin
    if Is_SurMesure_FinaleAAjouter then
        result := Composition.GetMesure(iMesure-1).pixX + Composition.GetMesure(iMesure-1).pixWidth
    else
        result := Composition.GetMesure(iMesure).pixX;

        
    result := result + pixx_in_mesure;
End;


Function TCurseur.GetPixx_in_mesure: integer;
Begin
    result := pixx_in_mesure;
End;


Function TCurseur.GetPoint_Pix_in_Document: TPoint;
var iligne: integer;

Begin
    result.x := GetPixx_in_doc;
    iligne := GetiLigne;
    result.y := Composition.Ligne_YHaut(iligne) +
                GetY(Composition, iligne, position);
End;




Function TCurseur.GetTempsDepuisDebutMesure: TRationnel;
Begin
    if Composition.Is_Mesure_Indice_MesureAAjouter(iMesure) then
         result := Qel(1)
    else
         result :=  Composition.GetMesure(iMesure).TempsAX(pixx_in_mesure);
              // VoixNum(voix_courante).SurTemps(iIndice);
End;



Function TCurseur.GetiVoixSelectionnee: integer;
Begin
    result := voix_courante;
End;


Function TCurseur.GetiLigne: integer;
Begin
    result := Composition.LigneAvecMes(imesure);
End;



Function TCurseur.GetVoixMesure: TVoix;
Begin
    result := Composition.GetMesure(imesure).VoixNum(voix_courante);
End;



Function TCurseur.GetMesure: TMesure;
Begin
    result := Composition.GetMesure(imesure);
End;

Function TCurseur.Tablature_CordeNum_Get: integer;
Begin
    result := Tablature_System_PositionHauteurToCordeNum(position.hauteur);
End;


Function TCurseur.GetInfoClefCourante: TInfoClef;
Begin
    result := Composition.InfoClef_DetecterAvecrelX(GetiPorteeEditee,
                                                    GetiMesure,
                                                    GetPixx_in_mesure);
End;


Function TCurseur.GetHauteurNote: THauteurNote;
var nh: integer;

Begin
    nh := HauteurGraphiqueToHauteurAbs(GetInfoClefCourante, position.hauteur);
    result := HauteurNoteAvecHauteurEtAlteration(nh, AlterationCourante);
End;


Procedure TCurseur.SetHauteurNote(hauteurnote: THauteurNote);
Begin
     AlterationCourante := hauteurnote.alteration;
     position.hauteur := HauteurAbsToHauteurGraphique(GetInfoClefCourante, hauteurNote.Hauteur);
End;



procedure TCurseur.SetHauteurNoteAlteration(alteration: TAlteration);
Begin
     AlterationCourante := alteration;
End;



procedure TCurseur.SetHauteurNoteAlterationParDefaut;
Begin
     AlterationCourante := Composition.AlterationLocale(GetiMesure,
                                                    GetTempsDepuisDebutMesure,
                                                    GetPosition);
End;


Function TCurseur.GetElementMusical: TElMusical;
Begin
    if not Dessus then
         MessageErreur('appel à TCurseur.GetElementMusical alors que Dessus = false');

    Verifier('préconditions de TCurseur.GetElementMusical');
    
    result := GetVoixMesure.ElMusicaux[iindice];
End;



Function TCurseur.GetElementMusicalPrecedent: TElMusical;
Begin
    if iindice = 0 then
    Begin
       if iMesure = 0 then
       Begin
           MessageErreur('appel à TCurseur.GetElementMusicalPrecedent alors qu''on est au début de partition!');
           result := nil;
       end
       else
           With Composition.GetMesure(iMesure - 1).VoixNum(GetiVoixSelectionnee) do
                If IsVide then
                   Begin
                       MessageErreur('appel à TCurseur.GetElementMusicalPrecedent ' +
                                 ': la mesure précédente a la voix correspondante');
                       result := nil;
                   End
                   else
                         result := ElMusicaux[high(ElMusicaux)];

    End
    
    else
          result := GetVoixMesure.ElMusicaux[iindice-1];
End;




Function TCurseur.GetNoteSousCurseur(out note: TPNote): Boolean;
Begin
    note := GetNoteSousCurseur;
    result := (note <> nil);
End;

Function TCurseur.GetNoteSousCurseur: TPNote;
var el: TElMusical;
    pos: TPosition;
    j: integer;
    
Begin
    result := nil;

    if not Dessus then
    Begin
       result := nil;
       exit;
    End;

    Verifier('préconditions de TCurseur.GetNoteSousCurseur');

    el := GetElementMusical;
    pos := GetPosition;
    
    if el.IsSilence then
        result := nil

    else if Is_Curseur_Sur_Tablature then
    Begin
         for j := 0 to high(el.Notes) do
                if IsPositionsEgales(el.Notes[j].tablature_position, pos) then
                     result := @el.Notes[j];

    End
    else
    Begin
         for j := 0 to high(el.Notes) do
                if IsPositionsEgales(el.Notes[j].position, pos) then
                     result := @el.Notes[j];

    End;

End;


Function TCurseur.GetTonaliteCourante : TTOnalite;
Begin
    if TonaliteCourante = cTonaliteDeLaMesureCourante then
          result := Composition.Tonalites(GetiMesure, GetiPorteeEditee)
    else
          result := TonaliteCourante;
End;

Function TCurseur.Is_SurMesure_FinaleAAjouter: Boolean;
Begin
     result := (iMesure = Composition.NbMesures);
End;



Function TCurseur.Is_Mesure_DebutDeMesure: Boolean;
Begin
    result := (iindice = 0) and not dessus;
End;


Function TCurseur.Is_Mesure_FinDeMesure: Boolean;
Begin
    if Is_SurMesure_FinaleAAjouter then
        MessageErreur('Curseur.Is_Mesure_FinDeMesure : non, tu es sur la mesure finale à ajouter... la question ne se pose pas!');

    result := (iindice >= Composition.GetMesure(imesure).VoixNum(voix_courante).NbElMusicaux);

End;


Function TCurseur.Is_ElementMusical_Dessus: Boolean;
Begin
    result := dessus;
End;



Function TCurseur.Is_Curseur_Sur_Tablature: Boolean;
Begin
    Result := Composition.Portee_IsTablature(position.portee);
End;



Function TCurseur.DR_AllerADroite: Boolean;
{renvoie vrai qd ça marche}
var hvelmu: integer;

Begin
    result := not Is_SurMesure_FinaleAAjouter;

    if result then
    Begin
        hvelmu := high(Composition.GetMesure(iMesure).VoixNum(voix_courante).ElMusicaux);
        if (not Dessus) and (iIndice <= hvelmu) then
               Dessus := true
        else
        Begin
            if iIndice <= hvelmu then
                         inc(iIndice)
                 else
                        Begin
                              inc(iMesure);
                              iIndice := 0;
                        End;
           Dessus := false;
        End;
    end;
   CalculerXY_CurseurClavier;
   Verifier('post-conditions de DR_AllerADroite');
End;


Function TCurseur.DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante: Boolean;
Begin
    result := DR_ElementMusicalSuivantPasDessus;

    if result then
    with Composition.GetMesure(imesure) do
        if Is_Mesure_FinDeMesure and
           IsQ1InfQ2(NbTempsEscomptes, VoixNum(voix_courante).DureeTotale) then
                 DA_Mesure_Debut(imesure + 1);

    CalculerXY_CurseurClavier;
    Verifier('post-conditions de DR_ElementMusicalSuivantPasDessusAvecPassageMesureSuivante');
        
End;



Function TCurseur.DR_ElementMusicalSuivantPasDessus: Boolean;
{renvoie vrai qd ça marche}
var hvelmu: integer;

Begin
    result := not Is_SurMesure_FinaleAAjouter;

    if result then
    Begin
        hvelmu := high(Composition.GetMesure(iMesure).VoixNum(voix_courante).ElMusicaux);
            if iIndice <= hvelmu then
                    inc(iIndice)
            else
                Begin
                      inc(iMesure);
                      iIndice := 0;
                End;
           Dessus := false;

    end;
   CalculerXY_CurseurClavier;
   Verifier('post-conditions de DR_ElementMusicalSuivantPasDessus');
   private_ya_eu_deplacement_de_curseur;
End;



Function TCurseur.DR_ElementMusicalPrecedentPasDessus: Boolean;
Begin
   result := true;

   if iMesure >= Composition.NbMesures then
    Begin
         iMesure := Composition.NbMesures - 1;
         iIndice := length(Composition.GetMesure(iMesure).VoixNum(voix_courante).ElMusicaux);
    end
    else
    if Dessus then
            Dessus := false
    else
    Begin
            if iIndice > 0 then
                      dec(iIndice)
            else
            Begin
                     if iMesure = 0 then
                          result := false
                     else
                     Begin
                          dec(iMesure);
                          iIndice := length(Composition.GetMesure(iMesure).VoixNum(voix_courante).ElMusicaux);
                     End;
            end;

    end;
    CalculerXY_CurseurClavier;

    Verifier('post-conditions de DR_ElementMusicalPrecedentPasDessus');
    private_ya_eu_deplacement_de_curseur;
End;

Function TCurseur.DR_AllerAGauche: Boolean;
Begin
   result := true;

   if iMesure >= Composition.NbMesures then
    Begin
         iMesure := Composition.NbMesures - 1;
         iIndice := length(GetVoixMesure.ElMusicaux);
    end
    else
    if Dessus then
                    Dessus := false
    else
    Begin
            if iIndice > 0 then
            Begin
                      dec(iIndice);
                      Dessus := true;
            end else
            Begin
                     if iMesure = 0 then
                          result := false
                     else
                     Begin
                          dec(iMesure);
                          iIndice := length(GetVoixMesure.ElMusicaux);
                     End;
            end;

    end;
    CalculerXY_CurseurClavier;
    Verifier('post-conditions de DR_AllerAGauche');
End;

Procedure TCurseur.DR_ElementMusical_AllerDessusOuPas(b: Boolean);
Begin
   Dessus := b;
   CalculerXY_CurseurClavier;
   Verifier('post-conditions de DR_ElementMusical_AllerDessusOuPas');
End;


Procedure TCurseur.DR_ElementMusical_AllerDessusOuPasSansChangerX(b: Boolean);
Begin
   Dessus := b;
   Verifier('post-conditions de DR_ElementMusical_AllerDessusOuPasSansChangerX');
End;

Procedure TCurseur.DR_Voix_Changer(newvoixselectionnee: integer);
var t: TRationnel;

Begin
    if Composition.IsIndiceMesureValide(iMesure) then
    Begin
           t := Composition.GetMesure(iMesure)
                  .VoixNum(voix_courante).SurTemps(iIndice);

           iIndice := Composition.GetMesure(iMesure)
                  .VoixNum(newvoixselectionnee).IndiceSurTemps(t);

           Dessus := false;
    End;
      {else : bah... si l'indice de mesure n'est pas valide, c'est qu'on se
   trouve en fin de document... et alors c'est pas grave :) }

    voix_courante := newvoixselectionnee;

    
    CalculerXY_CurseurClavier;
    Verifier('post-conditions de DR_Voix_Changer');
End;



      Function IncM(var x:integer; max:integer): Boolean;
      Begin
          inc(x);
          result := (x <= max);
          if x > max then
          Begin
               Message_Vite_Fait_Beep_Et_Afficher('On ne peut pas écrire plus haut. (sécurité)');
               x := max;
          end;
      end;


      Function DecM(var x:integer; min:integer): Boolean;
      Begin
          dec(x);
          result := x >= min;
          if x < min then
          Begin
               Message_Vite_Fait_Beep_Et_Afficher('On ne peut pas écrire plus bas. (sécurité)');
               x := min;
          end;
      end;


const maxhauteur = 160;
      
procedure TCurseur.DR_DeplacerVersLeHaut;
Begin
    incM(position.hauteur, maxhauteur);

    if Is_Curseur_Sur_Tablature then
        incM(position.hauteur, maxhauteur);

    Composition.Position_Arrondir(position);
End;


procedure TCurseur.DR_DeplacerVersLeBas;
Begin
    decM(position.hauteur, -maxhauteur);

    if Is_Curseur_Sur_Tablature then
        decM(position.hauteur, -maxhauteur);
        
    Composition.Position_Arrondir(position);
End;


Function TCurseur.DR_Deplacer_PorteeDuHaut: Boolean;
Begin
    result := DecM(position.Portee, 0);
    Composition.Position_Arrondir(position);
End;


Function TCurseur.DR_Deplacer_PorteeDuBas: Boolean;
Begin
    result := incM(position.Portee, Composition.NbPortees - 1);
    Composition.Position_Arrondir(position);
End;


procedure TCurseur.DR_MiniDRCarModif;
Begin
    Dessus := false;

    if iMesure > Composition.NbMesures then
       iMesure := Composition.NbMesures;
       
    if Is_SurMesure_FinaleAAjouter then
        iindice := 0
    else
       if iindice >= GetVoixMesure.NbElMusicaux then
            iindice := max(0, GetVoixMesure.NbElMusicaux);
            
    private_ya_eu_deplacement_de_curseur;
End;





procedure TCurseur.DA_Mesure_Debut(imes: integer);
Begin
    imesure := imes;
    iIndice := 0;
    Dessus := false;
    CalculerXY_CurseurClavier;
    Verifier('post-conditions de DA_Mesure_Debut');

    private_ya_eu_deplacement_de_curseur;
End;



procedure TCurseur.DR_MemeVoixFinMesure;
Begin
    if not Is_SurMesure_FinaleAAjouter then
    Begin
         iIndice := GetVoixMesure.NbElMusicaux;
         Dessus := false;
    End;
    CalculerXY_CurseurClavier;
    Verifier('post-conditions de DR_MemeVoixFinMesure');
End;


procedure TCurseur.DA_Set(voix, imes, iind: integer; pos: TPosition);
Begin
      Composition.VerifierPosition(pos, 'pré dans DA_Set');
      voix_courante := voix;
      position := pos;

      if imes < 0 then imes := 0;
      iMesure := imes;

      if Is_SurMesure_FinaleAAjouter then
          iIndice := 0
      else
          iIndice := max(0, min(iind, GetVoixMesure.NbElMusicaux));
          
      Dessus := false; //par défaut
      CalculerXY_CurseurClavier;
      Verifier('post-conditions de DA_Set');

      private_ya_eu_deplacement_de_curseur;
End;


procedure TCurseur.DA_SetAvecTemps(voix, imes: integer; temps: TRationnel; pos: TPosition);
Begin
     DA_Set(voix, imes, Composition.GetMesure(imes)
                                   .VoixNum(voix_courante)
                                   .IndiceSurTemps(temps), pos);

     CalculerXY_CurseurClavier;
End;



procedure TCurseur.DA_SetAvecXMesure(voix, m, a_pixx_in_mesure: integer; pos: TPosition);
var i: integer;
Begin
     Composition.VerifierPosition(pos, 'pré dans DA_SetAvecXMesure');

     voix_courante := voix;
     iMesure := m;
     position := pos;

     if iMesure >= Composition.NbMesures then
      Begin
            Dessus := false;
            iIndice := 0;
      end
      else
      Begin
            Dessus := Composition.GetMesure(m).VoixNum(voix_courante).FindElMusicalApres(a_pixx_in_mesure, i);
            IIndice := i;
      End;

      CalculerXY_CurseurClavier;
      pixx_in_mesure := a_pixx_in_mesure;

      Verifier('post-conditions de DA_SetAvecXMesure');
      private_ya_eu_deplacement_de_curseur;

End;





Function TCurseur.InfoTxtGet_Mesure_Temps: string;
Begin
    result := 'mes. n°' + inttostr(GetiMesure) + ', temps ' + QTostr(GetTempsDepuisDebutMesure);
End;




procedure TCurseur.SetPositionHauteur(hauteur_graphique: integer);
Begin
    position.hauteur := hauteur_graphique;
End;



procedure TCurseur.SetPositionGraphique(pos: TPosition);
Begin
    position := pos;
End;


end.
