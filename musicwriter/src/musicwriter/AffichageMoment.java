/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.geom.Area;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 *
 * @author proprietaire
 */
public class AffichageMoment extends AffichageEnsemble {
    final private Systeme systeme;
    final private Moment moment;
    private double accordsdebutx = 0;
    private double barrex = 0;

    final private AffichageEnsemble affichageSilenceSurTouteLaMesureTouteLaPortee = new AffichageEnsemble();
    private boolean contientAccordsOuSilences = false;

    AffichageMoment(Systeme systeme, double x, Moment moment, Set<ElementMusical> elementsMusicaux) {
            
        super(x);
        accordsdebutx = x;
        double clefsx = x;
        barrex = x-16; // pour l'affichage si jamais il n'y a pas de barre ;)
        this.systeme = systeme;
        this.moment = moment;
        boolean autreChoseQueNotes = false;

        traiterAffichageSilenceSurTouteLaMesureTouteLaPortee();

        for(ElementMusical element : elementsMusicaux)
        {
                if(element instanceof ElementMusicalClef)
                {
                    AffichageElementMusicalClef a = new AffichageElementMusicalClef(systeme, clefsx, (ElementMusicalClef) element);
                    add(a);
                    x = a.getRectangle().getMaxX();
                    autreChoseQueNotes = true;
                }
        }

                
        for(ElementMusical element : elementsMusicaux)
        {
                if(element instanceof ElementMusicalChangementTonalite)
                {
                    AffichageChangementTonalite a = new AffichageChangementTonalite(systeme, x, (ElementMusicalChangementTonalite) element);
                    add(a);
                    x = a.getRectangle().getMaxX();
                    autreChoseQueNotes = true;
                }
        }


        for(ElementMusical element : elementsMusicaux)
        {
                if(element instanceof BarreDeMesure)
                {
                    add(new AffichageBarreDeMesure(systeme, x, (BarreDeMesure) element));
                    barrex = x;
                    x = x + 0.4 * systeme.interligneGet();
                    autreChoseQueNotes = true;

                }
        }


        for(ElementMusical element : elementsMusicaux)
        {
                if(element instanceof ElementMusicalTempo)
                {
                    add(new AffichageElementMusicalTempo(systeme, x, (ElementMusicalTempo) element));
                    autreChoseQueNotes = true;

                }
        }

        for(ElementMusical element : elementsMusicaux)
        {
                if(element instanceof ElementMusicalChangementMesureSignature)
                {
                    add(new AffichageChangementMesureSignature(systeme, x, (ElementMusicalChangementMesureSignature) element));
                    x = x + 1.6 * systeme.interligneGet();
                    autreChoseQueNotes = true;
                }
        }
        x = x + 0.8 * systeme.interligneGet();

        if(autreChoseQueNotes)
            x = x + 0.8 * systeme.interligneGet();
        
        accordsdebutx = x;
        
            for(ElementMusical element : elementsMusicaux)
            {
                if(element instanceof Accord)
                {
                    double xc = accordsdebutx;
                    AffichageAccord aa = new AffichageAccord(systeme, xc, (Accord) element);
                    
                    Area i = getArea();
                    i.intersect(new Area(aa.getRectangle()));
                    while(!i.isEmpty())
                    {
                        aa = new AffichageAccord(systeme, xc, (Accord) element);
                        xc += systeme.interligneGet()/2;
                        i = getArea();
                        i.intersect(new Area(aa.getRectangle()));
                    }
                    add(new AffichageAccord(systeme, xc, (Accord) element));
                    contientAccordsOuSilences = true;
                }
            }

            
            for(ElementMusical element : elementsMusicaux)
            {
                if(element instanceof Silence)
                {
                    add(new AffichageSilence(systeme, accordsdebutx, (Silence) element));
                    contientAccordsOuSilences = true;
                }

            }

            hampesHautBasDecider();
            hampesHautBasDecider();
            
            for(ElementMusical element : elementsMusicaux)
            {
                if(element instanceof Accord)
                {                   
                    add(new AffichageAccordFin(systeme, (Accord) element));
                }
            }

            
            
    }
    


    void traiterAffichageSilenceSurTouteLaMesureTouteLaPortee()
    {
        if(systeme.getPartitionDonnees().isDebutMesure(getMoment()))
        {
            for(Portee p : systeme.getPortees())
            {
                if(systeme.getPartitionDonnees().porteeIsMesureVide(p, getMoment() ))
                    affichageSilenceSurTouteLaMesureTouteLaPortee.add(new AffichageSilenceSurTouteLaMesureTouteLaPortee(systeme, getMoment(), p ));
            }
        }

    }
    
    AffichageAccord getAffichageAccord(Point point, Duree dureeDemandee)
    {
        for(Affichage a : this)
        {
            if(a instanceof AffichageAccord)
            {
                AffichageAccord affichageAccord = (AffichageAccord) a;
                
                Rectangle r = affichageAccord.getRectangle();
                r.y = (int) (r.y - systeme.interligneGet() * 4);
                r.height = (int) (r.height + systeme.interligneGet() * 8);
                
                if(r.contains(point) && affichageAccord.getDuree().equals(dureeDemandee))
                    return affichageAccord;
            }
        }
        return null;
    }


    AffichageAccord getAffichageAccord(Curseur curseur)
    {
        for(Affichage a : this)
        {
            if(a instanceof AffichageAccord)
            {
                AffichageAccord affichageAccord = (AffichageAccord) a;

                if(affichageAccord.getVoix().equals(curseur.getVoix()))
                    return affichageAccord;
            }
        }
        return null;
            
    }
    

    
    
    @Override
    public void setX(double x)
    {
        double ancienx = this.getX();
        super.setX(x);
        accordsdebutx = accordsdebutx + x - ancienx;
        barrex = barrex + x - ancienx;
    }

    
    Moment getMoment()
    {
        return moment;
    }
    
    
    
    public Set<AffichageAccord> getAffichageAccords()
    {
        Set<AffichageAccord> S = new HashSet<AffichageAccord>();
        for(Affichage a : this)
        {
            if(a instanceof AffichageAccord)
                S.add((AffichageAccord) a);
  
        }
        
        return S;
        
    }
    
    AffichageElementMusical getAffichageElementMusical(ElementMusical element)
    {
        for(Affichage a : this)
        {
            if(a instanceof AffichageElementMusical)
            {
                AffichageElementMusical ael = (AffichageElementMusical) a;
                if(ael.getElementMusical() == element)
                {
                    return ael;
                }
            }
            else if((a instanceof AffichageAccord) && (element instanceof Note))
            {
                if(((AffichageAccord) a).getAccord().contains((Note) element))
                    return ((AffichageAccord) a).getAffichageNote((Note) element);
            }
        }
        return null;
    }



    private boolean isContientAccords()
    {
        for(Affichage a : this)
        {
            if(a instanceof AffichageAccord)
                return true;
        }
        return false;
    }

    
    @Override
    public Rectangle getRectangle() {
        Rectangle rectangle = null;

        if(isContientAccords())
        {
            for(Affichage a : this)
            {
                if(!(a instanceof AffichageAccordFin)
                   & !(a instanceof AffichageSilence)
                   & !(a instanceof AffichageElementMusicalTempo) )
                {
                    if(rectangle == null)
                    {
                        rectangle = a.getRectangle();
                    }
                    else
                        rectangle.add(a.getRectangle());
                }
            }
        }
        else
        {
            for(Affichage a : this)
            {
                if(!(a instanceof AffichageAccordFin))
                {
                    if(rectangle == null)
                    {
                        rectangle = a.getRectangle();
                    }
                    else
                        rectangle.add(a.getRectangle());
                }
            }
        }
        return rectangle;
    }


    public double getWidth()
    {
        return getRectangle().getWidth();
    }
    
    
    
    public double getXFin() {
        Rectangle rectangle = getRectangle();
        
        if(rectangle == null)
            return getX();
        else       
            return getRectangle().getMaxX();
    }
    
    
    
    public boolean isBienPourCouperSysteme()
    {
        for(Affichage a : this)
        {
            if(a instanceof AffichageBarreDeMesure)
                return true;
        }
        return false;
    }



    public boolean isContientAccordsOuSilences()
    {
        return contientAccordsOuSilences;
    }
    

    public void removeAllAccordsEtSilences() {
        for(Iterator<Affichage>it = this.iterator() ; it.hasNext() ; )
        {
            Affichage a = it.next();

            if(a instanceof AffichageAccord)
            {
                it.remove();
            }
            
            if(a instanceof AffichageSilence)
            {
                it.remove();
            }
            
            if(a instanceof AffichageAccordFin)
            {
                it.remove();
            }
            
        }
    }

    double getXNotes() {
        return accordsdebutx;
    }


    double getXBarreAuDebut()
    {
        return barrex;
    }

    @Override
    public void draw(Graphics2D g) {
        super.draw(g);
        affichageSilenceSurTouteLaMesureTouteLaPortee.draw(g);
    }



    private Area getAreaPriveDe(AffichageAccord aaaNePasCompter) {
        Area area = new Area();

        for(Affichage a : this)
        if(a != aaaNePasCompter)
        {
            if(a instanceof AffichageAccord)
            {
                area.add(new Area(((AffichageAccord) a).getHampeRectangle()));
            }
            else
                area.add(a.getArea());
        }
        return area;
    }

    
    private void hampesHautBasDecider()
    {
        for(AffichageAccord a : getAffichageAccords())
        {
                hampeHautBasDecider(a);
        }
    }


    private void hampeHautBasDecider(AffichageAccord a) {

           Note.HampeDirection sauvegarde = a.getHampeDirection();

           a.setHampeVersLeHaut();
           Area i = getAreaPriveDe(a);
           i.intersect(new Area(a.getHampeRectangle()));
           double evalSiHaut = i.getBounds().getHeight()*i.getBounds().getWidth();

           a.setHampeVersLeBas();
           i = getAreaPriveDe(a);
           i.intersect(new Area(a.getHampeRectangle()));
           double evalSiBas = i.getBounds().getHeight()*i.getBounds().getWidth();

           if(evalSiBas < evalSiHaut)
           {
               a.setHampeVersLeBas();
           }
           else if(evalSiHaut < evalSiBas)
           {
               a.setHampeVersLeHaut();
           }
           else
           {
               a.setHampeDirection(sauvegarde);
           }

    }


    
}
