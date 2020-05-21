unit MusicSystem_CompositionGestionBarresDeMesure;

interface

uses QSystem, Graphics, Windows, FileSystem, Classes, Sysutils, MusicWriter_Console, Math,
     MusicSystem_ElMusical,
     MusicSystem_Voix,
     MusicSystem_Mesure,
     MusicSystem_Types,
     MusicSystem_CompositionBase,
     MusicSystem_CompositionBaseAvecClef,
     MusicHarmonie;

     

type

TBarreType = (btBarreSimple, btBarreDouble, btBarreRepriseVersGauche,
              btBarreRepriseVersDroite, btBarreRepriseDesDeuxCotes);





TCompositionGestionBarresDeMesure = class(TCompositionBaseAvecClef)
protected
     procedure BarreDeMesure_Set(m: integer; barre_type: TBarreType);


public
     Function BarreDeMesure_Get(m: integer): TBarreType;
     Procedure VerifierBarreDeMesureIndice(var m: integer; s: string);


     Function Is_Mesure_Reprise_Debut(im: integer): Boolean;
     Function Is_Mesure_Reprise_Fin(im: integer): Boolean;


end;




Function BarreTypeToStr(barre_type: TBarreType) : string;



implementation

uses  Main,
     Cancellation {oui.. un moment j'en ai besoin, c'est très crade...
     c'est à refaire !!!!!!},

     MusicWriter_Erreur,
     MusicUser;







Procedure TCompositionGestionBarresDeMesure.VerifierBarreDeMesureIndice(var m: integer; s: string);
Begin
    if not ( (0 <= m) and (m <= NbMesures) ) then
    Begin
          MessageErreur('Indice de barre de mesures incorrect ' + s);
          m := 0;
    End;

End;





Function TCompositionGestionBarresDeMesure.BarreDeMesure_Get(m: integer): TBarreType;
    Function GetInfoMesureG: TBarre;
    Begin
          if not Is_Mesure_Indice_PremiereMesure(m) then
               result := GetMesure(m - 1).BarreFin
          else
               result := bBarreSimple;
    End;

    Function GetInfoMesureD: TBarre;
    Begin
         if not Is_Mesure_Indice_MesureAAjouter(m) then
             result := GetMesure(m).BarreDebut
         else
             result := bBarreSimple;

    End;

Begin
     case GetInfoMesureG of
         bBarreSimple:
            case GetInfoMesureD of
                bBarreSimple: result := btBarreSimple;
                bBarreDouble: result := btBarreDouble;
                bBarreReprise: result := btBarreRepriseVersGauche;
            end;

         bBarreDouble:
            case GetInfoMesureD of
                bBarreSimple: result := btBarreDouble;
                bBarreDouble: result := btBarreDouble;
                bBarreReprise: MessageErreur('Erreur dans BarreDeMesure_Get : barredouble+ reprise?!?!');
            end;

         bBarreReprise:
            case GetInfoMesureD of
                bBarreSimple: result := btBarreRepriseVersDroite;
                bBarreDouble: MessageErreur('Erreur dans BarreDeMesure_Get : reprise+barredouble?!');
                bBarreReprise: result := btBarreRepriseDesDeuxCotes;
            end;

     end;
End;



procedure TCompositionGestionBarresDeMesure.BarreDeMesure_Set(m: integer;  barre_type: TBarreType);
     procedure SetBarreFinMesureG(b: TBarre);
     Begin
         if not Is_Mesure_Indice_PremiereMesure(m) then
                 GetMesure(m - 1).BarreFin := b;
     End;

     procedure SetBarreDebutMesureD(b: TBarre);
     Begin
         if not Is_Mesure_Indice_MesureAAjouter(m) then
                 GetMesure(m).BarreDebut := b;
     End;

Begin
     VerifierBarreDeMesureIndice(m, 'BarreDeMesure_Set');

     case barre_type of
         btBarreSimple:
             Begin
                  SetBarreFinMesureG(bBarreSimple);
                  SetBarreDebutMesureD(bBarreSimple);
             End;

         btBarreDouble:
             Begin
                  SetBarreFinMesureG(bBarreDouble);
                  SetBarreDebutMesureD(bBarreDouble);
             End;

         btBarreRepriseVersGauche:
             Begin
                  SetBarreFinMesureG(bBarreReprise);
             End;

         btBarreRepriseVersDroite:
             Begin
                  SetBarreDebutMesureD(bBarreReprise);
             End;

         btBarreRepriseDesDeuxCotes:
             Begin
                  SetBarreFinMesureG(bBarreReprise);
                  SetBarreDebutMesureD(bBarreReprise);
             End;

         else
             MessageErreur('cas non traité dans BarreDeMesure_Set');

     end;

End;








Function TCompositionGestionBarresDeMesure.Is_Mesure_Reprise_Debut(im: integer): Boolean;
Begin
    VerifierIndiceMesure(im, 'Mesure_Is_Reprise_Debut');

    result := GetMesure(im).BarreDebut = bBarreReprise;
End;


Function TCompositionGestionBarresDeMesure.Is_Mesure_Reprise_Fin(im: integer): Boolean;
Begin
    VerifierIndiceMesure(im, 'Mesure_Is_Reprise_Fin');

    result := GetMesure(im).BarreFin = bBarreReprise;
End;






Function BarreTypeToStr(barre_type: TBarreType) : string;
Begin
    case barre_type of
        btBarreSimple: result := 'Barre simple';
        btBarreDouble: result := 'Double-barre';
        btBarreRepriseVersGauche: result := 'Reprise vers la gauche';
        btBarreRepriseVersDroite: result := 'Reprise vers la droite';
        btBarreRepriseDesDeuxCotes: result := 'Double-reprise';
        else MessageErreur('Erreur dans BarreTypeToStr');
    end;
End;


end.
