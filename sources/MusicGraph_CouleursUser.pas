unit MusicGraph_CouleursUser;

interface


uses Graphics;

const

      //CouleurRectSelectionFond = $FFF0F0;//$FFE0E0;
      CouleurFondEcran = $FFFFFF;
      {couleur du fond de l'écran... par défaut blanc, car le papier c'est blanc}

      CouleurStylo = 0;
      {couleur du stylo... on écrit noir}
      
      CouleurStyloCorrection = 255;
      {par défaut, les trucs faux sont écrit en rouge}


      {à quoi ressemble le cadre de sélection :}                           
      SelectionRectangle_Couleur = $888080;
      SelectionRectangle_Style = psDashDotDot;
      SelectionRectangle_Epaisseur = 1;

      {à quoi ressemble le cadre autour de la mesure courante}
      CouleurCadreAutourMesureSousCurseur = $DD77EE;

      CouleurCadreMiseEnPage = $CCCC88;

      couleurfondmodelesouscurseur = $FFA0C0;

      CouleurLignesQuandZoomPetit = $AAAAAA;

      CouleurPenElMusicalSousCurseur = $005500;
      CouleurPenElMusicalQueue = $00CC00;
      CouleurBrushElMusicalSousCurseur = $00CC00;

      {couleur de fond d'une mesure sélectionnée... en mode sélectionnage de mesure}
      CouleurFondSelectionMesure = $AADD88;


      
implementation

end.
