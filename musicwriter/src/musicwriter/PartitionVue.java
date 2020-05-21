/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Polygon;
import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author proprietaire
 */
public class PartitionVue {
    private double margeDroiteX = 500;
    private double porteesEcart = 120;
    private double systemeLongueur = 400;
    private double systemesEcart = 140;
    private double interligne = 10;

    public void afficherContexte(Graphics2D g, Curseur curseur) {
        MomentNotesSurLeFeu momentNotesSurLeFeu = partitionDonnees.getMomentNotesSurLeFeu(curseur.getMoment());
        Set<ElementMusicalDuree> elementsMusicauxQuiSontRelachees = momentNotesSurLeFeu.getElementsMusicauxQuiSontRelachees();

       // Curseur curseurPrecedent = partitionDonnees.getCurseurPrecedentMemeVoix(curseur);
        for(ElementMusicalDuree el : elementsMusicauxQuiSontRelachees)
        {
            if(el instanceof ElementMusicalSurVoix)
            {
                ElementMusicalSurVoix elv = (ElementMusicalSurVoix) el;
                
                if(elv.getVoix().equals(curseur.getVoix()))
                {
                    g.setColor(new Color(0.0f, 0.0f, 0.5f));
                    afficherElementMusical(g, elv);
                }
            }
        }
        

        //affiche l'accord
        AffichageAccord accordCourant = getAffichageAccord(curseur);
        if(accordCourant != null)
        {
            g.setColor(new Color(0.0f, 0.6f, 0.0f));
            accordCourant.draw(g);
            
//            Duree dureeMin = accordCourant.getDuree();
//            if(dureeCourante.isStrictementInferieur(dureeMin))
//                dureeMin = dureeCourante;
//
//            for(int i = 1; i <= dureeMin.getNombreTraitsCroche(); i++)
//            {
//                g.drawLine(accordCourant.getHampeX(), i, i, i)
//            }
//            accordCourant.getHampeX();
        }

        getSysteme(curseur.getMoment()).afficherContexte(g, curseur);

        if(curseur.isSurElementMusical())
        {
            g.setColor(new Color(0.6f, 0.2f, 0.0f));
            afficherElementMusical(g, curseur.getElementMusical());
            
        }
        
    }



    
    Set<Systeme> getSystemeInPolygone(Polygon polygon) {
        Set<Systeme> set = new HashSet<Systeme>();
        
        for(Systeme systeme : systemes)
        {
            if(polygon.intersects(systeme.getRectangle()))
                set.add(systeme);
            
        }
        return set;
    }
    
    Selection getSelectionPolygone(Polygon polygon) {
       Selection selection = new Selection();

        for(Systeme systeme : getSystemeInPolygone(polygon))
        {
            selection.ajouterSelection(systeme.getSelectionPolygone(polygon));
        }

        return selection;
        
    }
    
    
    
    private final PartitionDonnees partitionDonnees;
    
    double PremierSystemePremierePorteeTroisiemeLigneY;
    
    private ArrayList<Systeme> systemes = null;


    AffichageElementMusical getAffichageElementMusical(ElementMusical el)
    {
        
        Set<Systeme> systemesSet = getSystemes(el.getDebutMoment());
        for(Systeme systeme : systemesSet)
        {
            AffichageElementMusical a = systeme.getAffichageElementMusical(el);
            if(a != null)
                return a;
        }
        return null;
    }

    void afficherKaraoke(Graphics2D g, Moment karaokeMoment) {
        /*affiche les notes à jouer et les notes qui perdurent en vert*/

        
        
    }

    void afficherPartition(Graphics2D g, Rectangle visibleRect) {
        systemesAfficher(g, visibleRect);
    }

    void afficherSelection(Graphics2D g, Selection selection) {
        /* affiche les notes d'une sélection en rouge*/
       for(ElementMusical element : selection)
       {
          afficherElementMusical(g, element);
       }
    }
    
    void afficherSelectionDehors(Graphics2D g, Selection selection) {
        /* affiche les notes d'une sélection en rouge*/
        
       for(ElementMusical element : selection)
       {
          afficherElementMusicalDehors(g, element);
       }
    }

    int getSystemesNombre() {
        return systemes.size();
    }


    void setSystemeLongueur(int systemeLongueur) {
       this.systemeLongueur = systemeLongueur;
    }

    public void afficherElementMusical(Graphics2D g, ElementMusical note) {
        Set<Systeme> systemesSet = getSystemes(note.getDebutMoment());
        
        for(Systeme systeme : systemesSet)
        {
            systeme.afficherElementMusical(g, note);
        }
    }

    private void afficherBarre(Graphics2D g, Moment moment) {
        Set<Systeme> systemesSet = getSystemes(moment);
        
        for(Systeme systeme : systemesSet)
        {
            systeme.afficherBarre(g, moment);
        }
        
    }

    public void afficherElementMusicalDehors(Graphics2D g, ElementMusical element) {
         Set<Systeme> systemesSet = getSystemes(element.getDebutMoment());
        
         for(Systeme systeme : systemesSet)
        {
            systeme.afficherElementMusicalDehors(g, element);
        }
    }


    
    public Systeme getSysteme(Moment moment)
    {


        for(int systemeNumero = systemes.size() - 1;
            systemeNumero >= 0 ;
            systemeNumero--)
        {
            if(systemes.get(systemeNumero).getDebutMoment().isAvant(moment) &
               ( (systemeNumero == systemes.size() - 1) || systemes.get(systemeNumero).getFinMoment().isApres(moment) ))
            {
                return systemes.get(systemeNumero);
            }
        }
        return null;
    }
    
    private Set<Systeme> getSystemes(Moment moment) {
        
        Set<Systeme> systemesSet = new HashSet<Systeme>();
        for(int systemeNumero = systemes.size() - 1;
            systemeNumero >= 0;
            systemeNumero--)
        {
            if(systemes.get(systemeNumero).getDebutMoment().isAvant(moment) &
               ( (systemeNumero == systemes.size() - 1) || systemes.get(systemeNumero).getFinMoment().isApres(moment) ))
            {
                systemesSet.add(systemes.get(systemeNumero));
            }
        }
        return systemesSet;
    }
    
    
    
    

    private void systemesAfficher(Graphics2D g) {
        g.setColor(Color.black);
        
        if(systemes == null)
        {
            calculer();
        }
        
        for(Systeme systeme : systemes)
        {
            systeme.afficher(g);
        }
        
    }
    
    
    
    
    private void systemesAfficher(Graphics2D g, Rectangle visibleRect) {
        g.setColor(Color.black);
        
        if(systemes == null)
        {
            calculer();
        }
        
        Systeme systemeEnHaut
                = getSystemeContenantPoint(
                new Point((int) visibleRect.getMinX(), 
                          (int) visibleRect.getMinY())
                                          );
        Systeme systemeEnBas
                = getSystemeContenantPoint(
                new Point((int) visibleRect.getMinX(), 
                          (int) visibleRect.getMaxY())
                                          );
        
        
        for(int systemei = systemeEnHaut.getNumeroSysteme();
               systemei <= systemeEnBas.getNumeroSysteme();
               systemei++ )
        {
            systemes.get(systemei).afficher(g);
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    public void setMargeDroiteX(double margeDroiteX)
    {
        this.margeDroiteX = margeDroiteX;
    }
    
    PartitionVue(PartitionDonnees partitionDonnees)
    {
        this.partitionDonnees = partitionDonnees;
        systemes = new ArrayList<Systeme>();

        PremierSystemePremierePorteeTroisiemeLigneY = 100;
        double ytroisiemeLignePremierePortee = PremierSystemePremierePorteeTroisiemeLigneY;
        int systemeNumero = 0;
        
        
        Moment systemeCourantMomentDebut = partitionDonnees.getMomentDebut();
        Systeme systeme = new Systeme(systemeNumero, partitionDonnees,
                                      ytroisiemeLignePremierePortee,
                                      porteesEcart,
                                      margeDroiteX,
                                      interligne,
                                      systemeCourantMomentDebut
                                      );
        systemes.add(systeme);
    }
    
    
    public void calculer()
    {
        systemesDistribuerPartition(systemeLongueur);
    }
    
    
    
    public void calculer(Moment moment)
    {
        systemesDistribuerPartition(systemeLongueur, moment);
    }
    
    
    
    public void afficherPartition(Graphics2D g)
    {
        systemesAfficher(g);
        
    }

    


    

    public Systeme getSystemeContenantPoint(Point point)
     //je lui donne un point (x, y).
     // la fonction me dit dans quel système se trouve le point
    {
        for(int numeroSysteme = 0; numeroSysteme < systemes.size(); numeroSysteme++)
        {
            if(point.y < 50 + systemes.get(numeroSysteme)
                    .getPorteeTroisiemeLigneY(partitionDonnees
                                 .getPorteeDerniere()
                               ) )
                return systemes.get(numeroSysteme);
        }
        
        return systemes.get(systemes.size() - 1);
        
    }
    

    
    Curseur getCurseur(Point point) {
        return getCurseur(point, new Duree(new Rational(0, 1))); // la durée est bidon
    }


    public Moment getMomentBarre(Point point) {
        Systeme systeme = getSystemeContenantPoint(point);
        return systeme.getMomentBarre(point);
    }



    public Curseur getCurseur(Point point, Duree dureeDemandee) {
        Systeme systeme = getSystemeContenantPoint(point);
              
        Voix voix = systeme.getVoix(point, dureeDemandee);
             
        ElementMusical note = systeme.getElementMusical(point);
        
        if(note instanceof Note)
        if(note != null)
        {
            Curseur curseur = new Curseur(note.getDebutMoment(),
                                          ((Note) note).getHauteur(),
                                          ((Note) note).getPortee(),
                                           ((Note) note).getVoix());
            curseur.declarerSurElementMusical(note);
            
            return curseur;
        }
        
        
        
        Portee portee = systeme.getPortee(point);
        Hauteur hauteur = systeme.getHauteur(portee, point);
        //je connais tout ce qui est "vertical"
        
        Moment moment = systeme.getMoment(point);

        
        Curseur curseur = new Curseur(moment, hauteur, portee, voix);
        
        if(voix == null)
        {
            curseur = partitionDonnees.voixDeviner(curseur, dureeDemandee);
        }
        
        if(note != null)
            curseur.declarerSurElementMusical(note);
        return curseur;

        
    }

    

    public PartitionDonnees getPartitionDonnees() {
        return partitionDonnees;
    }
    
    
    
    public void setPorteesEcart(double ecart)
    {
        porteesEcart = ecart;
        
        for(Systeme s : systemes)
        {
             s.setPorteesEcart(ecart);
        }
    }
    
    
    
    public void setSystemesEcart(double ecart)
    {
        systemesEcart = ecart;
    }
    
    
    
    public void setInterLigne(double interligne)
    {
        this.interligne = interligne;
        
        for(Systeme s : systemes)
        {
             s.setInterLigne(interligne);
        }
    }
    
    
    
    
    public void setPremierSystemePremierePorteeTroisiemeLigneY(double v)
    {
        PremierSystemePremierePorteeTroisiemeLigneY = v;
    }

    
    private void systemesDistribuerPartition(double margeDroiteX) {
        systemes = new ArrayList<Systeme>();
        
        double ytroisiemeLignePremierePortee = PremierSystemePremierePorteeTroisiemeLigneY;
        int systemeNumero = 0;
        
        
        Moment systemeCourantMomentDebut = partitionDonnees.getMomentDebut();
        Systeme systeme = new Systeme(systemeNumero, partitionDonnees,
                                      ytroisiemeLignePremierePortee,
                                      porteesEcart,
                                      margeDroiteX,
                                      interligne,
                                      systemeCourantMomentDebut);
        systemes.add(systeme);
        systemeCourantMomentDebut = systeme.getMomentApresLaFinDuSysteme();
        
        
        while(systemeCourantMomentDebut != null)
        {
            systemeNumero++;
            ytroisiemeLignePremierePortee += systeme.getHeight() + systemesEcart;
            systeme = new Systeme(systemeNumero, partitionDonnees,
                                      ytroisiemeLignePremierePortee,
                                      porteesEcart,
                                  margeDroiteX,
                                  interligne,
                                  systemeCourantMomentDebut
                                  );
            
            systemes.add(systeme);
            systemeCourantMomentDebut = systeme.getMomentApresLaFinDuSysteme();
            
        }
        
        
    }
    
    
    
    
    private void systemesDistribuerPartition(double margeDroiteX, Moment moment) {
        Systeme systemeDebut = getSysteme(moment);

        if(systemeDebut == null)
        {
            calculer();
            return;

        }

        
        int systemeNumero = systemeDebut.getNumeroSysteme();
        double ytroisiemeLignePremierePortee = getSysteme(systemeNumero).getYTroisiemeLignePremierePortee();


        Moment systemeCourantMomentDebut = systemeDebut.getDebutMoment();
        Systeme systeme = new Systeme(systemeNumero, partitionDonnees,
                                      ytroisiemeLignePremierePortee,
                                      porteesEcart,
                                  margeDroiteX,
                                  interligne,
                                  systemeCourantMomentDebut
                                  );
        systemes.set(systemeNumero, systeme);
        systemeCourantMomentDebut = systeme.getMomentApresLaFinDuSysteme();
        
        while(systemeCourantMomentDebut != null)
        {
            systemeNumero++;
            
            if(systemeNumero < systemes.size())
            if(systemeCourantMomentDebut.isEgal(systemes.get(systemeNumero).getDebutMoment()))
                return;
            
            ytroisiemeLignePremierePortee += systeme.getHeight() + systemesEcart;
            systeme = new Systeme(systemeNumero, partitionDonnees,
                                      ytroisiemeLignePremierePortee,
                                      porteesEcart, 
                                  margeDroiteX,
                                  interligne,
                                  systemeCourantMomentDebut
                                  );
            
            if(systemeNumero < systemes.size())
                 systemes.set(systemeNumero, systeme);
            else
                 systemes.add(systeme);
            
            systemeCourantMomentDebut = systeme.getMomentApresLaFinDuSysteme();
            
        }
        
    }
        
    Dimension getDimension()
    {
        return new Dimension((int) systemeLongueur+100, 
                             (int) (systemes
                              .get(systemes.size() - 1)
                               .getY(partitionDonnees.getPorteeDerniere(),
                                     -50)));
    }

    private Systeme getSysteme(int systemeNumero) {
        return systemes.get(systemeNumero);
    }

    AffichageAccord getAffichageAccord(Curseur curseur) {
        Systeme systeme = getSysteme(curseur.getMoment());
        return systeme.getAffichageAccord(curseur);

    }





    
    
    
    
    

}
