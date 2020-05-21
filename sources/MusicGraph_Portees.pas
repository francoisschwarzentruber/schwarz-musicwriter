unit MusicGraph_Portees;

interface


uses MusicSystem,
     MusicSystem_ElMusical,
     MusicSystem_Types,
     MusicGraph_System,
     MusicSystem_CompositionAvecPagination;


const
      nbpixlign = 4*prec;
      nbpixlignentrepointduree = 4*prec;

      nbpixentreportee2 = 48*prec;
      nbpixentreportee = nbpixentreportee2*2;
      margehaut = 64*prec;

        Function GetY_TOUTESLESPORTEES(comp: TCompositionAvecPagination;
                               iPortee, iHauteur : integer) :integer;

        Function GetY(comp: TCompositionAvecPagination; iLigne, iPortee, iHauteur : integer):integer; overload;
        Function GetY(iLigne, iPortee, iHauteur : integer):integer; overload;
        Function GetY(iPortee, iHauteur : integer):integer; overload;

        Function GetY(comp: TCompositionAvecPagination; iLigne: integer; pos:TPosition):integer; overload;
        Function GetY(iLigne: integer; pos:TPosition):integer; overload;
        Function GetY(pos:TPosition):integer; overload;

        Function ZoomPortee(iportee: integer): integer;

        Function AuZoomPortee(x,iportee: integer): integer;
        Function AuZoomGeneralPortee(x: integer): integer;
        Function AuZoom(x,zz: integer): integer;
        Function Cnbpixlign(iportee: integer): integer;

        Procedure GetPosition(y:integer;
                      comp:TCompositionAvecPagination;
                      iLigne: integer;
                      var pos: TPosition);

var     IGP: TCompositionAvecPagination; {Info Graphique sur Portée
                            lorsqu'on dessine, il est conseillé de mettre dans IGP
                            l'objet Composition qui contient les objets dessinés

    SINON, si IGP = nil, toutes les portées sont supposées être de taille ZoomRefPortee}

         IGiLigne: integer; {Info Graphique sur le n° ligne courante...}


         

var LesPorteesSontDessinesAZoomDefaut: boolean = false;
    {on active LesPorteesSontDessinesAZoomDefaut pour chaque partie d'orchestre}

implementation

uses MusicWriter_Erreur {pour MessageErreur},
     MusicUser {pour iPorteeCourant},
     MusicGraph, MusicSystem_Composition_Portees_Liste;


{GetY !! But : partir de la portée et de la hauteur, retrouver la position
 en pixel logique
 rem : les GetY renvoit un Y dans le repère de la portée (et non du du document)
//*****************************************************************************}


Function GetY_TOUTESLESPORTEES(comp: TCompositionAvecPagination;
                               iPortee, iHauteur : integer) :integer;
Begin
    if comp = nil then
        MessageErreur('comp à NIL dans GetY_TOUTESLESPORTEES');
        
    comp.VerifierIndicePortee(iPortee, 'GetY_TOUTESLESPORTEES');

    IGP := comp;
    result := margehaut + iPortee * nbpixentreportee - iHauteur * Cnbpixlign(iportee);
End;


Function GetY(comp: TCompositionAvecPagination; iLigne, iPortee, iHauteur : integer):integer; overload;
var nb_pixlign: integer;

Begin
if comp = nil then {utilise un truc par défaut}
    result := margehaut + iPortee * nbpixentreportee - iHauteur * nbpixlign
else {utilise les infos d'un objet composition}
with comp do
Begin
                                     //préconditions
    comp.VerifierIndiceLigne(iLigne, 'GetY');
    comp.VerifierIndicePortee(iPortee, 'GetY');

    if comp.PorteesPixy = nil then
    Begin
          MessageErreur('Dans GetY, le tableau PorteesPixy n''est pas initialisé. On tente de le calculer !');
          CalcPorteesPixy(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN);
          //si on est là, ce n'est pas normal
    End;

    if high(comp.PorteesPixy) < high(Lignes) then
    Begin
          MessageErreur('Dans GetY, le tableau PorteesPixy n''est pas assez initialisé. On tente de le calculer !');
          CalcPorteesPixy(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN);
          //si on est là, ce n'est pas normal
    End;

    if high(comp.PorteesPixy[iLigne]) < comp.NbPortees-1 then
    Begin
          MessageErreur('Dans GetY, le tableau comp.PorteesPixy[iLigne] n''est mal initialisé. On tente de le calculer !');
          CalcPorteesPixy(0, PAGINER_ABSOLUMENT_JUSQU_A_LA_FIN);
          //si on est là, ce n'est pas normal
    End;


   // nb_pixlign := Cnbpixlign(iportee);
//    result := comp.Porteespixy[iLigne][iportee] - iHauteur * nb_pixlign;
    IGP := comp;
    result := comp.Porteespixy[iLigne][iportee] - iHauteur * nbpixlign * ZoomPortee(iportee) div ZoomMaxPrec;

End;

End;





Function GetY(comp: TCompositionAvecPagination; iLigne: integer; pos:TPosition):integer; overload;
Begin
result := GetY(comp, iLigne, pos.portee, pos.hauteur);
End;

Function GetY(iLigne: integer; pos:TPosition):integer; overload;
Begin
 result := GetY(IGP, iLigne, pos);
End;

Function GetY(pos:TPosition):integer; overload;
Begin
 result := GetY(IGP, IGiLigne, pos);
End;

Function GetY(iLigne, iPortee, iHauteur : integer):integer; overload;
Begin
   result := GetY(IGP, iLigne, iportee,ihauteur);
End;


Function GetY(iPortee, iHauteur : integer):integer; overload;
Begin
   result := GetY(IGP, IGiLigne, iportee,ihauteur);
End;

Function ZoomPortee(iportee: integer): integer;
{zoom de la portée numéro iportee
 re : zoom normal : renvoit ZoomMaxPrec}
Begin

if (IGP = nil) or LesPorteesSontDessinesAZoomDefaut then
           result := ZoomMaxPrec
else
Begin
       IGP.VerifierIndicePortee(iportee, 'ZoomPortee');

       if IsMusicWriterCalcule and (ModeAffichage = maRuban) and IGP.IsPartitionDOrchestre then
       {en mode orchestre-ruban, on calcule comme si tout était en grand}
        Begin
              result := ZoomMaxPrec;
              exit;
        End;

       if (iportee = iPorteeCourant) and (ModeAffichage = maRuban) and IGP.IsPartitionDOrchestre then
       {si on est sur la portée courante... on affiche en grand}
             result := ZoomMaxPrec
       else
             result := IGP.Portee_Taille[iportee]*ZoomMaxPrec div ZoomRefPortee;
End;

End;






Function AuZoomPortee(x,iportee: integer): integer;
Begin
   result := x * ZoomPortee(iportee) div ZoomMaxPrec;
End;


Function AuZoomGeneralPortee(x: integer): integer;
var zpmax, ip : integer;
Begin
   if IGP = nil then
       result := x
   else
   Begin
         zpmax := 0;
         for ip := 0 to IGP.NbPortees-1 do
              if zpmax < ZoomPortee(ip) then zpmax := ZoomPortee(ip);

         result := x * zpmax div ZoomMaxPrec;
   End;
End;

Function AuZoom(x,zz: integer): integer;
Begin
   result := x * zz div ZoomMaxPrec;
End;



Function Cnbpixlign(iportee: integer): integer;
{renvoit l'espacement entre
 2 lignes de la portée iportee en nombre de pixels logiques}

Begin
    result := AuZoomPortee(nbpixlign, iportee);
End;



Procedure GetPosition(y:integer;
                      comp:TCompositionAvecPagination;
                      iLigne: integer;
                      var pos: TPosition);
{convertit "y" en coordonnées position}
var iportee, ihauteur, distporteemin, nbpixlign, hp, i: integer;
    P: TArrayBool;

Begin
      //if iLigne = -1 then exit;
      comp.VerifierIndiceLigne(iLigne, 'GetPosition');

      hp := comp.NbPortees - 1;


      iportee := 0;

      P := comp.PorteesVisibles(iLigne);

      distporteemin := 100000;
      for i := 0 to hp do
          if P[i] then
              if abs(comp.PorteesPixy[iLigne][i] - y) < distporteemin then
              Begin
                   iportee := i;
                   distporteemin := abs(comp.PorteesPixy[iLigne][i] - y);
              End;

        nbpixlign := Cnbpixlign(iportee);

        if (y - comp.PorteesPixy[iLigne][iportee]) <= 0 then
             ihauteur := -(y - comp.PorteesPixy[iLigne][iportee] - nbpixlign div 2)
                                                                div nbpixlign
        else
             ihauteur := -(y - comp.PorteesPixy[iLigne][iportee] + nbpixlign div 2)
                                                                div nbpixlign;



        pos.portee := iportee;
        pos.Hauteur := ihauteur;
        comp.Position_Arrondir(pos);

End;








end.
