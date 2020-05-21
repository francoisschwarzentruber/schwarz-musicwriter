unit MusicSystem_ElMusical_Duree;


interface

uses QSystem {pour pouvoir parler d'une durée d'un él. musical};

type

TElMusical_Duree = class(TObject)
protected
      Duree:TRationnel;
      private_is_duree_approximative: Boolean;
      PointDuree: integer; {croche : 0,
                          croche-pointée : 1,
                          croche-double pointée : 2}

public
     Function NbQueueAUtiliser: integer;
     {renvoie le nombre de queue à accrocher à la hampe pour représenter
     l'élément musical
      ex : une croche, 1
           une double-croche 2
     }

     Procedure Duree_Set(nv_duree: TRationnel);
     Procedure Duree_Fixee_Set(nv_duree: TRationnel);

     Function Duree_Get: TRationnel;
     Function Duree_IsApproximative: Boolean;
     Procedure DureeApproximative_Set(nv_duree: TRationnel);
     procedure Duree_Approximative_SwitchTo;
     Function GetNbPointsDuree: integer;

end;

Function IsDureeAffichable(d: TRationnel): Boolean;




implementation


uses MusicWriter_Erreur;





Function TElMusical_Duree.Duree_IsApproximative: Boolean;
Begin
     result := private_is_duree_approximative;
End;


procedure TElMusical_Duree.Duree_Approximative_SwitchTo;
Begin
    private_is_duree_approximative := true;
End;


Procedure TElMusical_Duree.DureeApproximative_Set(nv_duree: TRationnel);
Begin
    private_is_duree_approximative := true;
    nv_duree := QPasTropGrandDenominateur(nv_duree);

    if IsQStrNegatif(nv_duree) then
           MessageErreur('on affectue une durée négative via TElMusical_Duree.SetDuree, c''est mal');

    Duree := nv_duree;
    PointDuree := 0;
End;


Function TElMusical_Duree.NbQueueAUtiliser: integer;
{renvoie le nombre de queue à utiliser pour représenter l'él. mus.

ex : si l'el. mus. est une noire, une blanche, renvoie 0
     si l'el. mus. est une croche, un triolet de croche... renvoie 1
     si l'el. mus. est une double-croche, un triolet de double-croche...
                                                                  renvoie 2

}
Begin
    result := QNbQueueAUtiliser(Duree);


End;



Procedure TElMusical_Duree.Duree_Set(nv_duree: TRationnel);
Begin
    QVerifierQPasTropBizarre(nv_duree, 'Duree_Set');
    //private_is_duree_approximative := false;
    nv_duree := QPasTropGrandDenominateur(nv_duree);

    if IsQStrNegatif(nv_duree) then
           MessageErreur('on affectue une durée négative via TElMusical_Duree.SetDuree, c''est mal');

    Duree := nv_duree;
    PointDuree := CombienPointDuree(nv_duree);
End;


Procedure TElMusical_Duree.Duree_Fixee_Set(nv_duree: TRationnel);
Begin
    QVerifierQPasTropBizarre(nv_duree, 'Duree_Set');
    private_is_duree_approximative := false;
    nv_duree := QPasTropGrandDenominateur(nv_duree);

    if IsQStrNegatif(nv_duree) then
           MessageErreur('on affectue une durée négative via TElMusical_Duree.SetDuree, c''est mal');

    Duree := nv_duree;
    PointDuree := CombienPointDuree(nv_duree);
End;


Function TElMusical_Duree.Duree_Get: TRationnel;
Begin
   result := Duree;
End;



Function TElMusical_Duree.GetNbPointsDuree: integer;
Begin
    Result := PointDuree;
End;


Function IsDureeAffichable(d: TRationnel): Boolean;
Begin
    if IsQStrNegatif(d) then
           MessageErreur('durée négative dans IsDureeAffichable');

    result := IsQEgal(d, Qel(1)) or
              IsQEgal(d, Qel(1, 2)) or
              IsQEgal(d, Qel(1, 4)) or
              IsQEgal(d, Qel(1, 3)) or
              IsQEgal(d, Qel(3, 2)) or
              IsQEgal(d, Qel(1)) or
              IsQEgal(d, Qel(2)) or
              IsQEgal(d, Qel(3)) or
              IsQEgal(d, Qel(4));
              
End;



end.
