/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;

/**
 *
 * @author proprietaire
 */
public class AffichageSysteme implements Affichage {

    Systeme systeme = null;
    TreeMap<Moment, AffichageMoment> affichages = new TreeMap<Moment, AffichageMoment>();
    AffichageEnsemble croches_affichages = new AffichageEnsemble();
    PartitionDonnees partitionDonnees = null;
    
    
    void add(AffichageMoment affichageMoment) {
        affichages.put(affichageMoment.getMoment(), affichageMoment);
    }
    
    
    
    AffichageSysteme(Systeme systeme, PartitionDonnees partitionDonnees)
    {
        this.systeme = systeme;
        this.partitionDonnees = partitionDonnees;
    }
    
    
    AffichageElementMusical getAffichageElementMusical(ElementMusical element)
    {
        return affichages.get( element.getDebutMoment() ).getAffichageElementMusical(element);
    }
    
    void afficher(Graphics2D g, ElementMusical element)
    {
        AffichageElementMusical a = getAffichageElementMusical(element);

        if(a != null)
            a.draw(g);
    }
    
    
    
    

    public void draw(Graphics2D g) {
        for(Affichage a : affichages.values())
        {
            a.draw(g);
        }
        
        croches_affichages.draw(g);
    }

    public Area getArea() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Rectangle getRectangle() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Selection getSelection(Shape area) {
        Selection selection = new Selection();
        for(Affichage a : affichages.values())
        {
            selection.ajouterSelection(a.getSelection(area));
        }
        return selection;
    }

    public ElementMusical getElementMusical(Point point) {
        for(Affichage a : affichages.values())
        {
            ElementMusical el = a.getElementMusical(point);
            if(el != null)
                return el;
        }
        return null;
    }

    /**
     * 
     * @return le dernier moment présent dans ce système.
     */
    public Moment getFinMoment() {
        return affichages.lastKey();
    }

    
    Moment getMoment(Point point) {
          

              Moment resultat = affichages.firstKey();
              double distance = 10000;
          
              for(Moment moment = affichages.firstKey(); moment != null; moment = affichages.higherKey(moment) )
              {
                      double distancecourante = Math.abs(point.x - systeme.interligneGet()/2
                               - (affichages.get(moment).getX() + affichages.get(moment).getXFin()) / 2);

                      if(distancecourante < distance)
                      {
                          resultat = moment;
                          distance = distancecourante;
                      }

              }
              return resultat; 
          


          
          
    }



    Moment getMomentBarre(Point point) {
          Moment momentPlusProche = getMoment(point);

          if(!getAffichageMoment(momentPlusProche).isContientAccordsOuSilences())
          {
              return momentPlusProche;
          }
          else
          { 
              for(Moment moment = affichages.firstKey(); moment != null; moment = affichages.higherKey(moment) )
              {
                      if(affichages.get(moment).getXFin() > point.getX())
                      {
                          return moment;
                      }
              }
          }
          return affichages.lastKey();
    }
    
    
    
    AffichageAccord getAffichageAccord(Point point, Duree dureeDemandee)
    {
        Moment moment = getMoment(point);

        return getAffichageMoment(moment).getAffichageAccord(point, dureeDemandee);
    }
    
    
    AffichageAccord getAffichageAccord(Curseur curseur)
    {
        if(affichages.containsKey(curseur.getMoment()))
            return getAffichageMoment(curseur.getMoment()).getAffichageAccord(curseur);
        else
            return null;
    }

    double getXNotes(Moment moment) {
        if(affichages.lastKey().isAvant(moment))
        {
            //moment est après la fin de la partition
            //bref, il faut improviser !
            Moment dernierMoment = affichages.lastKey();
               return affichages.get(dernierMoment).getXNotes()
                                + (new Duree(dernierMoment, moment)).getRational().getRealNumber() * systeme.nbpixelDureeNoireParDefaut;
        }
        else if(moment.isStrictementAvant(affichages.firstKey()))
        {
            return 0;
        }
        else
        {
            Moment moment1 = affichages.floorKey(moment);
            Moment moment2 = affichages.higherKey(moment);
            
            double r1 = moment1.getRational().getRealNumber();
            double r2 = moment2.getRational().getRealNumber();
            double m = moment.getRational().getRealNumber();
            double lambda = (m - r1) / (r2 - r1);
            return affichages.get(moment1).getXNotes() * (1 - lambda) + affichages.get(moment2).getXNotes() * lambda;
        }
        
    }

    public AffichageMoment getAffichageMoment(Moment moment) {
        return affichages.get(moment);
    }

    boolean isTermineParUnMomentARepeterSurSystemeSuivant() {
        if(getDernierAffichageMoment().getXFin() <= 0.9*systeme.getXFin())
            return false;
        else
        return getDernierAffichageMoment().isBienPourCouperSysteme();
    }

    private boolean isTientDansLeSysteme() {
        return getDernierAffichageMoment().getXFin() <= 0.9*systeme.getXFin();
    }
    
    
    
    private AffichageAccord pop(SortedSet<AffichageAccord> accords )
    { 
        if(accords.isEmpty())
            return null;
        else
        {
            AffichageAccord a = accords.first();
            accords.remove(a);
            return a;
        }
//        for(AffichageAccord a : accords)
//        {
//            accords.remove(a);
//            return a;
//        }
//        return null;
    }
    
    private AffichageAccord getSuivant(Set<AffichageAccord> accords, AffichageAccord accord)
    {
        for(AffichageAccord a : accords)
        {
            if(a.getVoix().equals(accord.getVoix()))
            {
                if(a.getMomentDebut().equals(accord.getMomentFin()))
                {
                    return a;
                }
            }
        }

        return null;
    }
    
    public void calculerCrochesReliees()
    {
        SortedSet<AffichageAccord> accords = getAffichageAccords();
        
        while(!accords.isEmpty())
        {
            calculerUnPaquetCrochesReliees(accords);
        }
    }
    
    
    private void calculerUnPaquetCrochesReliees(SortedSet<AffichageAccord> accords)
    {
        ArrayList<AffichageAccord> liste = new ArrayList<AffichageAccord>();

        AffichageAccord premieraccord = pop(accords);
        Moment momentDebutMesure = partitionDonnees.getMomentMesureDebut(premieraccord.getMomentDebut());
        MesureSignature signature = systeme.getPartitionDonnees().getMesureSignature(premieraccord.getMomentDebut());
        
        int T = (int) Math.floor((premieraccord.getMomentDebut().getRealNumber() - momentDebutMesure.getRealNumber())/signature.getGroupe());
        for(AffichageAccord a = premieraccord;
            a != null &&
            a.getNombreTraitsCroche() > 0 &&
            (((a.getMomentDebut().getRealNumber() - momentDebutMesure.getRealNumber())/signature.getGroupe()) < T + 1)
            && (partitionDonnees.getMomentMesureDebut(a.getMomentDebut()).equals(momentDebutMesure));
            a = getSuivant(accords, a))
        {
            accords.remove(a);
            liste.add(a);
        }

        if(!liste.isEmpty())
            croches_affichages.add(new AffichageCrocheReliee(systeme, liste));
    }

    
    
    private SortedSet<AffichageAccord> getAffichageAccords() {
        SortedSet<AffichageAccord> affichageAccords = new TreeSet<AffichageAccord>(new ComparatorAffichageAccord());
        
        for(AffichageMoment am : this.affichages.values())
        {
            affichageAccords.addAll(am.getAffichageAccords());
        }
        
        return affichageAccords;
    }

    public double getX() {
        return 0;
    }

    public void setX(double x) {
        x = 0;
    }
    
    public AffichageMoment getDernierAffichageMoment()
    {
        return affichages.get(affichages.lastKey());
    }
    
    private AffichageMoment getAffichageMomentACouper()
    {
        if(affichages.isEmpty())
            return null;
        else
        {
             Moment moment = affichages.lastKey();
             
             while(moment != null)
             {
                 if(affichages.get(moment).isBienPourCouperSysteme())
                     return affichages.get(moment);
                 moment = affichages.lowerKey(moment);
             }
             
             return null;
        }
        
    }
    
    
   
    private void etirer()
    {
        double xdebut = affichages.firstEntry().getValue().getX();

        double facteur = (systeme.getXFin() - xdebut) / (getDernierAffichageMoment().getXFin() - xdebut);
        
        for(AffichageMoment a : affichages.values())
        {
            a.setX((a.getX() - xdebut) * facteur  + xdebut);
        }
        
        getDernierAffichageMoment().setX(systeme.getXFin() - getDernierAffichageMoment().getWidth());
        
    }


    
    private void momentsAjouterFin()
    {
         Moment moment = getFinMoment();
         Duree mesuresDuree = systeme.getPartitionDonnees().getMesureSignature(moment).getMesuresDuree();
         moment = mesuresDuree.getFinMoment(moment);
         while(getXNotes(moment) < systeme.getXFin())
         {
             add(new AffichageMoment(systeme, getXNotes(moment), moment, new HashSet<ElementMusical>()));
             moment = mesuresDuree.getFinMoment(moment);
         }
    }




    
    
    public void miseEnPage()
    {
        if(isTientDansLeSysteme())
        {
            momentsAjouterFin();
            return;
        }

        if(isPeuRempli())
        {
            return;
        }
        AffichageMoment dernierAffichageMoment = getAffichageMomentACouper();
        
        if(dernierAffichageMoment != null)
        {
            removeAllStrictementApresMoment(dernierAffichageMoment.getMoment());
            dernierAffichageMoment.removeAllAccordsEtSilences();
            etirer();
            
        }
         
    }

    private void removeAllStrictementApresMoment(Moment moment) {
        while(affichages.lastKey().isStrictementApres(moment))
        {
            affichages.remove(affichages.lastKey());
        }
    }

    public double getXBarreAuDebut(Moment moment) {
       if(affichages.lastKey().isStrictementAvant(moment))
        {
            //moment est après la fin de la partition
            //bref, il faut improviser !
           return getXNotes(moment);
        }
        else 
        {
            moment = affichages.floorKey(moment);

           if(moment == null)
               return 0;
           else
               return affichages.get(moment).getXBarreAuDebut();
        }
    }

    private boolean isPeuRempli() {
        return affichages.size() < 16;
    }



    
    
}
