unit MusicGraph_CouleursUser;

interface


uses Graphics;

const

      //CouleurRectSelectionFond = $FFF0F0;//$FFE0E0;
      CouleurFondEcran = $FFFFFF;
      {couleur du fond de l'�cran... par d�faut blanc, car le papier c'est blanc}

      CouleurStylo = 0;
      {couleur du stylo... on �crit noir}
      
      CouleurStyloCorrection = 255;
      {par d�faut, les trucs faux sont �crit en rouge}


      {� quoi ressemble le cadre de s�lection :}                           
      SelectionRectangle_Couleur = $888080;
      SelectionRectangle_Style = psDashDotDot;
      SelectionRectangle_Epaisseur = 1;

      {� quoi ressemble le cadre autour de la mesure courante}
      CouleurCadreAutourMesureSousCurseur = $DD77EE;

      CouleurCadreMiseEnPage = $CCCC88;

      couleurfondmodelesouscurseur = $FFA0C0;

      CouleurLignesQuandZoomPetit = $AAAAAA;

      CouleurPenElMusicalSousCurseur = $005500;
      CouleurPenElMusicalQueue = $00CC00;
      CouleurBrushElMusicalSousCurseur = $00CC00;

      {couleur de fond d'une mesure s�lectionn�e... en mode s�lectionnage de mesure}
      CouleurFondSelectionMesure = $AADD88;


      
implementation

end.
