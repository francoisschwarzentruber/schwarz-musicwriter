unit MusicSystem_CompositionGestionMesure;

interface

uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicSystem_CompositionBase,
     MusicSystem_CompositionBaseAvecClef,
     MusicSystem_CompositionAvecSelection,
     MusicHarmonie,
     cancellation;


     


type

TCompositionGestionMesure = class(TCompositionAvecCancellation)
protected
       procedure BarreMesureAjouter(m : integer; temps: TRationnel);


public
       procedure BarreMesureSupprimer(m_gauche: integer);
       {supprime la barre de mesure entre ma mesure n° m_gauche
        et m_gauche + 1... en somme fusionne les deux mesures...}

       procedure FusionnerMesures(mdeb, mfin: integer);

       Function BarresMesuresMettre(mdeb, mfin: integer;
                             rythme_souhaite_mesure: TRationnel): integer;

       Function MettreBarresMesures(m :integer; comportement: integer): integer;

       Function Is_Mesure_ChangementTonaliteApres(imesure: integer): boolean;
       
End;



implementation

uses MusicWriter_Erreur,
     MusicUser;





Function TCompositionGestionMesure.Is_Mesure_ChangementTonaliteApres(imesure: integer): boolean;
Begin
      if imesure = NbMesures - 1 then
             result := false
      else
             result := GetMesure(imesure).GetTonalite <> GetMesure(imesure+1).GetTonalite;
End;


     
procedure TCompositionGestionMesure.BarreMesureAjouter(m : integer; temps: TRationnel);
{remarque : - faire MettreBarreMesure(m, infinity) est équivalent à faire
              AddMesureVide(m+1)

            - faire MettreBarreMesure(m, 0) est équivalent à faire
              AddMesureVide(m)
            temps = durée de la premiere partie

            ex : si la mesure m contient 4 noires et temps = 3,
                 ça sépare la mesure en 2 :
                   - une partie avec 3 noires
                   - l'autre avec 1 noire}
                   
const Facteur_ElementMusicalDureeApproxACouperMaisPresqueRienDansMesureSuivante = 0.05;

var mesure, mesure_suiv: TMesure;
    v, iff, i: integer;
    duree_voix, duree_dernier_el, duree_surplus: TRationnel;
    nouveau_el: TElMusical;

Begin

         Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, m);
         
         AddMesureVide(m);
          {état actuel : l'ancienne mesure en m est en en m+1
                         en m, il y a une mesure vide}

          {but : bourrer la mesure m tant qu'on peut}

          mesure := Mesures[m];
          mesure_suiv := Mesures[m + 1];

          Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, m);
          Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, m+1);

         Setlength(mesure.Voix, length(mesure_suiv.Voix));

         for v := 0 to high(mesure_suiv.Voix) do
         Begin
               mesure.Rythme := mesure_suiv.Rythme;
               mesure.Voix[v] := TVoix.Create;
               mesure.Voix[v].N_Voix := mesure_suiv.Voix[v].N_Voix;

               iff := mesure_suiv.Voix[v].IndiceSurTemps(QAdd(Qel(1), temps));

               {but : mettre les él. d'indice < iff qui sont dans la mesure suivante,
                dans la mesure courante}

               Setlength(mesure.Voix[v].ElMusicaux, iff);

               for i := 0 to iff-1 do
                        mesure.Voix[v].ElMusicaux[i] := mesure_suiv.Voix[v].ElMusicaux[i];


               for i := iff to high(mesure_suiv.Voix[v].ElMusicaux) do
                        mesure_suiv.Voix[v].ElMusicaux[i-iff] := mesure_suiv.Voix[v].ElMusicaux[i];

               setlength(mesure_suiv.Voix[v].ElMusicaux, length(mesure_suiv.Voix[v].ElMusicaux) - iff);

               duree_voix := mesure.Voix[v].DureeTotale;




               if IsQ1StrInfQ2(temps, duree_voix) then
               Begin
               {s'occupe de couper l'élément musical qui est à cheval sur
               les deux mesures}
                   duree_dernier_el := mesure.Voix[v].ElMusicaux[iff - 1].Duree_Get;
                   duree_surplus := QDiff(duree_voix, temps);

                   if (QToReal(duree_surplus) / (QToReal(duree_surplus) + QToReal(duree_dernier_el)) <
                             Facteur_ElementMusicalDureeApproxACouperMaisPresqueRienDansMesureSuivante) and
                       mesure.Voix[v].ElMusicaux[iff - 1].Duree_IsApproximative then
                       {on ne coupe pas vraiment si il y a très peu dans la mesure
                        suivante.}
                   Begin
                        mesure.Voix[v].ElMusicaux[iff - 1].Duree_Set(
                               QDiff(duree_dernier_el, duree_surplus));

                        nouveau_el := CreerElMusicalPause_Duree_Approximative(duree_surplus,
                                                          mesure.Voix[v].ElMusicaux[iff - 1].PorteeApprox);

                        mesure_suiv.Voix[v].AddElMusical(0, nouveau_el);

                   End
                   else
                   {autre cas : on coupe vraiment}
                   Begin

                         mesure.Voix[v].ElMusicaux[iff - 1].Duree_Set(
                               QDiff(duree_dernier_el, duree_surplus));

                         nouveau_el := CopieElMusical(mesure.Voix[v].ElMusicaux[iff - 1]);
                         nouveau_el.Duree_Set(duree_surplus);

                         mesure_suiv.Voix[v].AddElMusical(0, nouveau_el);

                         mesure.Voix[v].ElMusicaux[iff - 1].ToutLierALaSuivante;
                   End;
                   
               End;


               


         End;





         

End;




procedure TCompositionGestionMesure.BarreMesureSupprimer(m_gauche: integer);
{supprime la barre de mesure entre ma mesure n° m_gauche
        et m_gauche + 1... en somme fusionne les deux mesures...}

{ça sert pour FusionnerMesures}


var MesG, MesD: TMesure;
    v: integer;
    NumVoix: integer;
    dureeMesG, duree_grosse_pause_devant: TRationnel;

Begin
    VerifierIndiceMesure(m_gauche, 'SupprimerBarreMesure');

    if m_gauche = High(Mesures) then
         exit;

    MesG := GetMesure(m_gauche);
    MesD := GetMesure(m_gauche + 1);

    Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, m_gauche);
    Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, m_gauche+1);
    
    dureeMesG := MesG.DureeTotale;

    QVerifierQPasTropBizarre(dureeMesG, 'dureeMesG dans SupprimerBarreMesure');
    for v := 0 to high(MesD.Voix) do
    Begin
         NumVoix := MesD.Voix[v].N_Voix;

         With MesG.VoixNum(NumVoix) do
         Begin
             duree_grosse_pause_devant :=
                              QDiff(dureeMesG, DureeTotale);
                              
             if not IsQEgal(Qel(0), duree_grosse_pause_devant) then
                              AddElMusicalFin(
                                CreerElMusicalPause(duree_grosse_pause_devant,
                                                    MesD.Voix[v].PorteeApprox));


             InsererContenuVoixAlaFin(MesD.Voix[v], false);
         End;
    End;


    DelMesure(m_gauche + 1);
    Cancellation_PushMiniEtapeAAnnuler(taSupprimerMes, m_gauche+1);

    
End;





procedure TCompositionGestionMesure.FusionnerMesures(mdeb, mfin: integer);
var nb: integer;
Begin
    VerifierIndiceMesure(mdeb, 'mdeb dans TCompositionGestionMesure.FusionnerMesures');
    VerifierIndiceMesure(mfin, 'mfin dans TCompositionGestionMesure.FusionnerMesures');

    if mdeb > mfin then
        MessageErreur('C''est pas très grave mais c''est bizarre que ' +
          'mdeb > mfin dans TCompositionGestionMesure.FusionnerMesures');
    
    nb := mfin - mdeb;


    while nb > 0 do
    Begin
        BarreMesureSupprimer(mdeb);
        dec(nb);
        MusicUser_Pourcentage_Informer((mfin - nb) / (mfin - mdeb));

    End;
    
End;





Function TCompositionGestionMesure.BarresMesuresMettre(mdeb, mfin: integer;
                                              rythme_souhaite_mesure: TRationnel): integer;
var dureetotale, dureetotale_a_traiter: TRationnel;
    duree_mesure_souhaitee: TRationnel;
Begin
    MusicUser_Pourcentage_Init('Mettre des barres : fusion (1/2)');
    duree_mesure_souhaitee := QMul(4, rythme_souhaite_mesure);

    FusionnerMesures(mdeb, mfin);
    MusicUser_Pourcentage_Informer(0.0);

    dureetotale := Mesures[mdeb].DureeTotale;
    dureetotale_a_traiter := dureetotale;

    MusicUser_Pourcentage_Init('Mettre des barres : découpage (2/2)');
    While IsQ1StrInfQ2(duree_mesure_souhaitee, dureetotale_a_traiter) do
         Begin
             if not Mesures[mdeb].IsDureePasDeDureeApproximativeAvant(duree_mesure_souhaitee) then
                  break;

             BarreMesureAjouter(mdeb, duree_mesure_souhaitee);
             Mesures[mdeb].SimplifierEcriture;
             Mesures[mdeb].Rythme := rythme_souhaite_mesure;

             inc(mdeb);
             dureetotale_a_traiter := QDiff(dureetotale_a_traiter, duree_mesure_souhaitee);
             MusicUser_Pourcentage_Informer(1.0 - QToReal(QDiv(dureetotale_a_traiter, dureetotale)));
             
         End;

    result := mdeb;
    VerifierIndiceMesure(result, 'resultat de BarresMesuresMettre');
End;


Function TCompositionGestionMesure.MettreBarresMesures(m :integer; comportement: integer): integer;
{éclate la mesure m en plusieurs mesures... afin que toutes les mesures
 ont bien des durées correctes
 => renvoie le numéro de la dernière mesure

 ex : une mesure à 4 quatres temps de numéro 27 qui contient 5 noires
       ==> s'éclate en 2 mesures... la première avec les 4 premières noires
           puis la deuxième avec la dernière noire

           revoie 27+1 = 28


comportement affine le comportement de cette fonction :
 si = 0, itou
 si = 2, fait rien

}

var v,iff,i: integer;

Begin
     if comportement = 2 then
     Begin
          result := m;
          exit;
     end;

{$IF defined(PRECOND)}
      VerifierIndiceMesure(m, 'MettreBarresMesures : m incorrect');

{$IFEND}

     while not IsQ1InfQ2(Mesures[m].DureeTotale, Mesures[m].NbTempsEscomptes) do
     {pendant que la mesure courante m dépasse de la durée qu'elle devrait avoir}
     Begin

         Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, m);
         AddMesureVide(m);
          {état actuel : l'ancienne mesure en m est en en m+1
                         en m, il y a une mesure vide}

          {but : bourrer la mesure m tant qu'on peut}

         Cancellation_PushMiniEtapeAAnnuler(taAjouterMes, m+1);
         Setlength(Mesures[m].Voix, length(Mesures[m+1].Voix));
         for v := 0 to high(Mesures[m+1].Voix) do
         Begin
               Mesures[m].Rythme := Mesures[m+1].Rythme;
               Mesures[m].Voix[v] := TVoix.Create;
               Mesures[m].Voix[v].N_Voix := Mesures[m+1].Voix[v].N_Voix;
               iff := Mesures[m+1].Voix[v].IndiceSurTemps(QAdd(Qel(1), QMul(4, Mesures[m+1].Rythme)));

               Setlength(Mesures[m].Voix[v].ElMusicaux, iff);

               for i := 0 to iff-1 do
                        Mesures[m].Voix[v].ElMusicaux[i] := Mesures[m+1].Voix[v].ElMusicaux[i];

               for i := iff to high(Mesures[m+1].Voix[v].ElMusicaux) do
                        Mesures[m+1].Voix[v].ElMusicaux[i-iff] := Mesures[m+1].Voix[v].ElMusicaux[i];

               setlength(Mesures[m+1].Voix[v].ElMusicaux, length(Mesures[m+1].Voix[v].ElMusicaux) - iff);


         End;
         Cancellation_PushMiniEtapeAAnnuler(taRemplacerMes, m+1);

         inc(m);
     End;

     result := m;

{$IF defined(POSTCOND)}
     if IndiceMesureValide(result) then
              MessageErreur('MettreBarresMesures : résultat incorrect');

{$IFEND}
End;



end.
