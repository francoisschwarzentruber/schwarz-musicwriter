/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Polygon;
import java.awt.Rectangle;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import javax.swing.ImageIcon;

/**
 *
 * @author proprietaire
 */
public class Systeme
    {
        static ImageIcon imgAccolade = new ImageIcon(AffichageSilence.class.getResource("resources/accolade.png"));
        private ImageIcon imgDiese = new ImageIcon(AffichageSilence.class.getResource("resources/diese.png"));
        private ImageIcon imgDoubleDiese = new ImageIcon(AffichageSilence.class.getResource("resources/double-diese.png"));
        private ImageIcon imgDoubleBemol = new ImageIcon(AffichageSilence.class.getResource("resources/double-bemol.png"));
        private ImageIcon imgBemol = new ImageIcon(AffichageSilence.class.getResource("resources/bemol.png"));
        private ImageIcon imgBecarre = new ImageIcon(AffichageSilence.class.getResource("resources/becarre.png"));
        public final double nbpixelDureeNoireParDefaut = 48;
        private double interligne_pixel;
        private double porteesEcart;
        
        private final int numero;
        private Moment momentApresLaFinDuSysteme = null;
        private final AffichageSysteme affichage;
        private final double margeGaucheX;
        HashMap<Portee, Double> porteeTroisiemeLigneY = new HashMap<Portee, Double>();




        Systeme(int numero,
        PartitionDonnees partitionDonnees,
        double premierePorteeTroisiemeLigneY,
        double porteesEcart,
        double margeDroiteX,
        double interligne,
        Moment systemeCourantMomentDebut
        )
        {
            this.affichage = new AffichageSysteme(this, partitionDonnees);
            this.numero = numero;
            this.partitionDonnees = partitionDonnees;
            this.premierePorteeTroisiemeLigneY = premierePorteeTroisiemeLigneY;
            this.systemeCourantMomentDebut = systemeCourantMomentDebut;
            this.margeDroiteX = margeDroiteX;
            this.interligne_pixel = interligne;
            this.porteesEcart = porteesEcart;
            this.margeGaucheX = 1.5*interligne;

             int i = 0;
             for(Portee portee : partitionDonnees.getPortees())
             {
                 porteeTroisiemeLigneY.put(portee, premierePorteeTroisiemeLigneY + i*porteesEcart);
                 i++;
             }
            this.momentApresLaFinDuSysteme = remplirJusquALaMarge();
            


        }
        public int getNumeroSysteme() {
            return numero;
        }



        public double noteRayonGet()
        {
            return (interligne_pixel / 2) * 0.95;
        }

    public Rectangle getRectangle() {
        double y = getY(partitionDonnees.getPorteePremiere(), 15);
        return new Rectangle(0,
                             (int) y,
                             (int) margeDroiteX,
                             (int) (getY(partitionDonnees.getPorteeDerniere(), -15) - y));
    }

    public double getXFin() {
        return margeDroiteX;
    }

    Voix getVoix(Point point, Duree dureeDemandee) {
        AffichageAccord a = affichage.getAffichageAccord(point, dureeDemandee);
        if(a == null)
            return null;
        else
            return a.getVoix();
    }

        double interligneGet() {
            return interligne_pixel;
        }
        
        
        public double ligneSupplementaireLongueurGet()
        {
            return 1.4 * interligne_pixel;
        }
        
        
        public void setInterLigne(double distanceInterligne)
        {
            interligne_pixel = distanceInterligne;
        }

        
        
        public Moment getMomentApresLaFinDuSysteme() {
            return momentApresLaFinDuSysteme;
        }
        
        
        Selection getSelectionPolygone(Polygon polygon)
        {
            return affichage.getSelection(polygon);
        }
        
        
    
        
        private PartitionDonnees partitionDonnees = null;

        public Moment getMoment(Point point) {
            return affichage.getMoment(point);
        }


        public Moment getMomentBarre(Point point) {
             return affichage.getMomentBarre(point);
        }




    void afficherBarre(Graphics2D g, Moment moment) {
        double x = getXNotes(moment);
        
        double y1 = getYHaut();
        double y2 = getYBas();
        
        g.drawLine((int) x,
                   (int) y1,
                   (int) x,
                   (int) y2);
        
        
    }
    
    
    
    double getYHaut()
    {
        return getY(partitionDonnees.getPorteePremiere(), 4);
    }
    
    
    
    double getYBas()
    {
        return getY(partitionDonnees.getPorteeDerniere(), -4);
    }
    
    void afficherBarre(Graphics2D g, double x) {
        g.drawLine((int) x,
                   (int) getYHaut(),
                   (int) x,
                   (int) getYBas());
        
        
    }

    public void afficherElementMusical(Graphics2D g, ElementMusical el) {
        affichage.afficher(g, el);
    }

    public void afficherElementMusicalDehors(Graphics2D g, ElementMusical el) {
        if(el instanceof Note)
        {
             AffichageAccord affichageAccord = (new AffichageAccord(this, getXNotes(el.getDebutMoment()), new Accord((Note) el)));
             affichageAccord.draw(g);
             (new AffichageCrocheReliee(this, affichageAccord)).draw(g);
        }
        else if(el instanceof Silence)
        {
             (new AffichageSilence(this, getXNotes(el.getDebutMoment()), (Silence) el)).draw(g);
        }
        else if(el instanceof BarreDeMesure)
        {
            (new AffichageBarreDeMesure(this, getXBarreAuDebut(el.getDebutMoment()), (BarreDeMesure) el)).draw(g);
        }
        else if(el instanceof ElementMusicalChangementMesureSignature)
        {
            ElementMusicalChangementMesureSignature ms = partitionDonnees.getElementMusicalMesureSignature(el.getDebutMoment());

            if(ms != null)
                if(ms.getDebutMoment().equals(el.getDebutMoment()))
                {
                    new AffichageChangementMesureSignature(this,
                         affichage.getAffichageElementMusical(ms).getX(),
                        (ElementMusicalChangementMesureSignature) el).draw(g);
                    return;
                }
                    
            new AffichageChangementMesureSignature(this
                        , getXBarreAuDebut(el.getDebutMoment()),
                        (ElementMusicalChangementMesureSignature) el).draw(g);
                

        }
        else if(el instanceof ElementMusicalChangementTonalite)
        {
            ElementMusicalChangementTonalite ct = partitionDonnees.getElementMusicalChangementTonaliteCourant(el.getDebutMoment());

            if(ct != null)
                if(ct.getDebutMoment().equals(el.getDebutMoment()))
                {
                    new AffichageChangementTonalite(this,
                         affichage.getAffichageElementMusical(ct).getX(),
                        (ElementMusicalChangementTonalite) el).draw(g);
                    return;
                }



            AffichageChangementTonalite A =
                    new AffichageChangementTonalite(this,
                    (ElementMusicalChangementTonalite) el);


            A.draw(g);

        }
        else if(el instanceof ElementMusicalClef)
        {
            ElementMusicalClef elc = (ElementMusicalClef) el;
            ElementMusicalClef ct = elc.getPortee().getElementMusicalClef(el.getDebutMoment());

            if(ct != null)
                if(ct.getDebutMoment().equals(el.getDebutMoment()))
                {
                    new AffichageElementMusicalClef(this,
                         affichage.getAffichageElementMusical(ct).getX(),
                        elc).draw(g);
                    return;
                }



            AffichageElementMusicalClef A =
                    new AffichageElementMusicalClef(this,
                    elc);


            A.draw(g);

        }
        else if(el instanceof ElementMusicalTempo)
        {
            (new AffichageElementMusicalTempo(this,
                                              getXNotes(el.getDebutMoment()),
                                              (ElementMusicalTempo) el)).draw(g);
        }
        
    }

        
        
        
        
        
        
        
        private double premierePorteeTroisiemeLigneY = 0;
        private double margeDroiteX = 0;
        private Moment systemeCourantMomentDebut = null;
        
        public Moment getDebutMoment() {
            /* retourne le moment au tout début du système (complétement
               à gauche) */
            return systemeCourantMomentDebut;
        }
        
        
        
        public Moment getFinMoment() {
            /* retourne le moment au tout début du système (complétement
               à gauche) */
            return affichage.getFinMoment();
        }
        
        


        public void afficher(Graphics2D g) {
            /* afficher un système =
             *  1. afficher les lignes des portées
             *  2. afficher les notes qu'il y a dessus
             */
           afficherAccolades(g);
           afficherPorteesLignes(g);
           
           afficherElementsMusicaux(g);
           
        }
        
        


        public Hauteur getHauteur(Portee portee, Point point) {
            /* Donne la hauteur (sans altération) en fonction de la portée
               et du point
               ex : si portée = une portée avec clef de sol,
                     et point sur la 2e ligne,
                    renvoie "sol0" */
            Moment moment = getMoment(point);
            double ydanslaportee = (point.y - getPorteeTroisiemeLigneY(portee));
            ydanslaportee = -ydanslaportee;
            
            int coordonneeVerticale = Arithmetique.divisionReelleVersEntier(
                    ydanslaportee + interligne_pixel / 4,
                    (interligne_pixel / 2));
            
            Hauteur hauteur = portee.getHauteur(moment, coordonneeVerticale);

            hauteur.setAlteration(partitionDonnees.getAlterationParDefaut(getMoment(point), getDebutMoment(), portee, hauteur));
            return hauteur;
        }

        
        
        //renvoie la note qui est sous le point point
        //si il n'y a pas de notes, renvoie null
        public ElementMusical getElementMusical(Point point) {
            return affichage.getElementMusical(point);
            
        }

        
        
        

        
        
        private Moment remplirJusquALaMarge()
        {
                Moment momentactuel = systemeCourantMomentDebut;
                Moment momentsuivant = momentactuel;
                double x = margeGaucheX;
                for(;
                    (momentactuel != null) && (x < margeDroiteX);
                    momentactuel = momentsuivant)
                {
                      MomentNotesSurLeFeu notesSurLeFeu = partitionDonnees.getMomentNotesSurLeFeu(momentactuel);
                      
                      Set<ElementMusical> elementsMusicaux = notesSurLeFeu.getElementsMusicauxRassemblesEnAccordsAJouer();

                      if(momentactuel.equals(systemeCourantMomentDebut))
                      {
                          ElementMusicalChangementTonalite ct = partitionDonnees.getElementMusicalChangementTonaliteCourant(momentactuel);
                          if(ct != null)
                              if(!ct.getDebutMoment().equals(momentactuel))
                                  elementsMusicaux.add(ct);

                          for(Portee p : getPortees())
                          {
                              ElementMusicalClef elc = p.getElementMusicalClef(momentactuel);

                              if(elc != null)
                                  if(!elc.getDebutMoment().equals(momentactuel))
                                      elementsMusicaux.add(elc);
                          }
                      }

                      if(momentactuel.isEgal(getDebutMoment()))
                      {
                           for(Iterator<ElementMusical>it = elementsMusicaux.iterator() ; it.hasNext() ; )
                            {
                                    ElementMusical el = it.next();
                                    if(el instanceof BarreDeMesure)
                                    {
                                        it.remove();
                                    }
                            }
                      }
                      
                      
                      
                      AffichageMoment affichageMoment = new AffichageMoment(this,
                                                                            x,
                                                                            momentactuel,
                                                                            elementsMusicaux);
                      
                      
                      affichage.add(affichageMoment);

                      
                      momentsuivant = partitionDonnees.getMomentSuivant(momentactuel);
                      
                      if(momentsuivant != null)
                      {
                          x = affichageMoment.getXFin()
                                  + interligne_pixel * (
                                     Math.max(0,
                                              1.0*Math.log(7*(new Duree(momentactuel, momentsuivant).getRational().getRealNumber()))));
                          
                          if(partitionDonnees.isBarreDeMesure(momentsuivant))
                              x += interligne_pixel*1.7;

                          if(!affichageMoment.isContientAccordsOuSilences())
                              x += 20 + (new Duree(momentactuel, momentsuivant).getRational().getRealNumber()) * nbpixelDureeNoireParDefaut;
                      }
                      
                }
                
                affichage.miseEnPage();
                affichage.calculerCrochesReliees();
                
                if(affichage.isTermineParUnMomentARepeterSurSystemeSuivant())
                    return affichage.getDernierAffichageMoment().getMoment();
                else
                    return partitionDonnees.getMomentSuivant(affichage.getDernierAffichageMoment().getMoment());
                
            }
        
        
        
        
        public double getPorteeTroisiemeLigneY(Portee portee)
        {
            if(porteeTroisiemeLigneY.containsKey(portee))
            {
                return porteeTroisiemeLigneY.get(portee);
            }
            else
            {
                Erreur.message("ne trouve pas la portée qu'il faut afficher");
                return porteeTroisiemeLigneY.get(partitionDonnees.getPorteePremiere());
            }
        }
        
        
        
        public Portee getPortee(Point point)
        // on est dans ce système, et on renvoie la portée où le point est.
        {
            int i = (int) Math.round((point.y - premierePorteeTroisiemeLigneY)/porteesEcart);
            if(i < 0) i = 0;
            if(i > partitionDonnees.getPorteesNombre() - 1) i = partitionDonnees.getPorteesNombre() - 1;

            return partitionDonnees.getPortee(i);
                       
        }


        public int getFontSize(int nbpoint)
        {
            return (int) ((nbpoint * interligneGet()) / 10.0);
        }

        private String alterationToTexte(Hauteur.Alteration alteration)
        {
             switch(alteration)
            {
                case DIESE: return "♯";
                case DOUBLEDIESE:
                     return "x";
                case BEMOL:
                     return "♭";
                case DOUBLEBEMOL:
                     return "bb";
                case NATUREL:
                     return "♮";
                 default: return "";
            }
        }



        private ImageIcon getAlterationImageIcon(Hauteur.Alteration alteration)
        {
             switch(alteration)
            {
                case DIESE: return imgDiese;
                case DOUBLEDIESE: return imgDoubleDiese;
                case BEMOL: return imgBemol;
                case DOUBLEBEMOL: return imgDoubleBemol;
                case NATUREL: return imgBecarre;
                 default: return null;
            }
        }



        public void dessinerAlterationADroite(Graphics2D g,
                                    Hauteur.Alteration alteration,
                                    double x,
                                    double y) {

//            g.setFont(new Font(g.getFont().getName(), Font.BOLD, getFontSize(16) ));
           // String alteration_texte = alterationToTexte(alteration);

            ImageIcon img = getAlterationImageIcon(alteration);
          //  if(alteration_texte != null)
               if(g.getColor().equals(Color.RED))
               {
                   g.fillRect(
                            (int) x,
                            (int) (y -  (img.getIconHeight() / 2)*interligneGet()/20),
                            (int) (img.getIconWidth()*interligneGet()/20),
                            (int) (img.getIconHeight()*interligneGet()/20));
               }

               g.drawImage(img.getImage(),
                            (int) x,
                            (int) (y -  (img.getIconHeight() / 2)*interligneGet()/20),
                            (int) (img.getIconWidth()*interligneGet()/20),
                            (int) (img.getIconHeight()*interligneGet()/20), null);
//                g.drawString(alteration_texte,
//                             (int) (x),
//                             (int) (y +  interligneGet() * 0.6));

        }


        public void dessinerAlterationGauche(Graphics2D g,
                                    Hauteur.Alteration alteration,
                                    double x,
                                    double y) {

          //  String alteration_texte =  alterationToTexte(alteration);
            //g.setFont(new Font(g.getFont().getName(), Font.BOLD, getFontSize(16) ));

            ImageIcon img = getAlterationImageIcon(alteration);
        //    int alteration_longueur_pixel = (int) g.getFontMetrics().getStringBounds(alteration_texte, g).getWidth();
           // if(alteration_texte != null)

            if(g.getColor().equals(Color.RED))
            {
                g.fillRect(
                           (int) (x - ((img.getIconWidth()+2)*interligneGet()/20)),
                (int) (y -  (img.getIconHeight() / 2)*interligneGet()/20),
                (int) (img.getIconWidth()*interligneGet()/20),
                (int) (img.getIconHeight()*interligneGet()/20));

            }
                   g.drawImage(img.getImage(),
                (int) (x - ((img.getIconWidth()+2)*interligneGet()/20)),
                (int) (y -  (img.getIconHeight() / 2)*interligneGet()/20),
                (int) (img.getIconWidth()*interligneGet()/20),
                (int) (img.getIconHeight()*interligneGet()/20), null);
//                g.drawString(alteration_texte,
//                             (int) (x - alteration_longueur_pixel),
//                             (int) (y +  interligneGet() * 0.6));

        }


    private void afficherElementsMusicaux(Graphics2D g) {
        affichage.draw(g);


    }

    private void afficherPorteeLignes(Graphics2D g, double xdebut, double xfin, double ytroisiemeligne) {
        g.setStroke(new BasicStroke(1.0f));
        for(int coordonneeVerticale = -4;
            coordonneeVerticale <= 4;
            coordonneeVerticale+=2)
        {
            double yCoordonneeVerticale = getY(ytroisiemeligne, coordonneeVerticale);
            g.drawLine((int) xdebut, (int) yCoordonneeVerticale, (int) xfin, (int) yCoordonneeVerticale);
        }
    }
    
    
    
    

    

    private void afficherPorteesLignes(Graphics2D g) {
        for(int iportee = 0; iportee < partitionDonnees.getPorteesNombre(); iportee++)
            afficherPorteeLignes(g, margeGaucheX, margeDroiteX, getPorteeTroisiemeLigneY(partitionDonnees.getPortee(iportee)));
            
    }

     
    
         private void noteFinDessiner(Graphics2D g, Note n) {
            //symbole de fin
            double finx = getXNotes(n.getFinMoment());
            double ycentrenote =  getY(n.getPortee(), n.getCoordonneeVerticaleSurPortee());

            g.drawLine((int) finx, 
                        (int) ycentrenote - 2, 
                        (int) finx,
                        (int) ycentrenote + 2);

        }
    
        public double getY(double ytroisiemeligne, int coordonneeVerticale)
        {
            return ytroisiemeligne - coordonneeVerticale * interligne_pixel / 2;
        }
    
        
        
        public double getY(Portee portee, int coordonneeVerticale)
        {
            return getY(getPorteeTroisiemeLigneY(portee), coordonneeVerticale);
        }

    AffichageElementMusical getAffichageElementMusical(ElementMusical el) {
        return affichage.getAffichageElementMusical(el);
    }

    Iterable<Portee> getPortees() {
        return partitionDonnees.getPortees();
    }

    public double getXNotes(Moment moment) {
        return affichage.getXNotes(moment);
    }

    public double getXBarreAuDebut(Moment moment) {
        return affichage.getXBarreAuDebut(moment);
    }

    double getYTroisiemeLignePremierePortee() {
        return premierePorteeTroisiemeLigneY;
    }
        
        
        
        
    public double getHeight()
    {
         return getYBas() - getYHaut();
    }

    private void afficherAccolades(Graphics2D g) {
        for(Partie partie : partitionDonnees.getParties())
        {
            if(partie.getPorteesNombre() > 1)
            {
                double y1 = getY(partie.getPorteePremiere(), 4);
                double y2 = getY(partie.getPorteeDerniere(), -4);

                g.drawImage(imgAccolade.getImage(), 0, (int) y1, (int) (margeGaucheX - 0.2*interligneGet()), (int) (y2 - y1), null);
            }
        }
    }

    void setPorteesEcart(double ecart) {
        porteesEcart = ecart;
        affichage.calculerCrochesReliees();
    }

    PartitionDonnees getPartitionDonnees() {
        return partitionDonnees;
    }

    void afficherContexte(Graphics2D g, Curseur curseur) {
        Moment moment = curseur.getMoment();
        Moment momentDebutMesure = partitionDonnees.getMomentMesureDebut(moment);
        Duree dureeDepuisDebutMesure = new Duree(momentDebutMesure, moment);
        double x = getXNotes(moment);
        double y1 = getYHaut();
        double y2 = getYBas();

        g.setColor(new Color(0.6f, 0.6f, 0.6f));
        g.setStroke(new BasicStroke(0.3f));

        g.drawLine((int) x,
                   (int) y1-32,
                   (int) x,
                   (int) y2+32);

        Polygon p = new Polygon();
        p.addPoint((int) (x - 4.0f / dureeDepuisDebutMesure.getRational().getDenominateur()), (int) (y2 + 40));
        p.addPoint((int) (x + 4.0f / dureeDepuisDebutMesure.getRational().getDenominateur()), (int) (y2 + 40));
        p.addPoint((int) x, (int) y2 + 32);
        g.fillPolygon(p);

        double xdebut = getXNotes(momentDebutMesure);
        g.drawLine((int) xdebut,
                   (int) y1-32,
                   (int) xdebut,
                   (int) y1);

        double y = y1-30;
        g.drawLine((int) xdebut,
                   (int) y,
                   (int) x,
                   (int) y);



        double dureeDouble =
               dureeDepuisDebutMesure.getRational().getRealNumber();

        
       
        g.setFont(new Font(g.getFont().getName(), 0, getFontSize(12)));
        g.drawString(curseur.getHauteur().toString(), (int) x, (int) y-16);
        
        if(dureeDouble > 0)
             g.drawString(String.valueOf(dureeDouble), (int) (x + xdebut) / 2-16, (int) y-1);

    }

    AffichageAccord getAffichageAccord(Curseur curseur) {
        return affichage.getAffichageAccord(curseur);
    }

        
        
    public double getPorteeYHaut(Portee p)
    {
        return getY(p, 4);
    }



    public double getPorteeHeight(Portee p)
    {
        return interligneGet() * 4;
    
    }


        
} //fin systeme
    