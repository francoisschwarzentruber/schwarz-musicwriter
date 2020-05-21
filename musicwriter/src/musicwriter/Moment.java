/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import org.jdom.Element;

/**
 * Un moment représente un "moment" dans une partition. Par exemple, après le moment
 * "après avoir joué en temps 10 noire + une croche".
 * @author proprietaire
 */
public class Moment implements Comparable {
    private Rational r = null;
    
    public Rational getRational()
    {
        return r;
    }


    public double getRealNumber()
    {
        return r.getRealNumber();
    }

    
    public Moment(Rational r)
    {
        this.r = r;
    }

    boolean isApres(Moment autreMoment) {
        return ( this.r.isSuperieur(autreMoment.getRational() ) );
    }
    
    
    
    boolean isAvant(Moment autreMoment) {
        return ( this.r.isInferieur(autreMoment.getRational() ) );
    }

    boolean isEgal(Moment autreMoment) {
        return ( this.r.isEgal(autreMoment.getRational()) );
    }
    
    
    boolean isStrictementAvant(Moment autreMoment) {
        return ( this.r.isStrictementInferieur(autreMoment.getRational() ) );
    }
    
    boolean isStrictementApres(Moment autreMoment) {
    return ( this.r.isStrictementSuperieur(autreMoment.getRational() ) );
    }
    
    
    Element sauvegarder()
    {
        Element elementMoment = new Element("moment");
        
        Element elementNbMillisecondesDepuisDebut = new Element("nbMillisecondesDepuisDebut");
        //elementNbMillisecondesDepuisDebut.addContent(String.valueOf(nbMillisecondesDepuisDebut));
        
        elementMoment.addContent(elementNbMillisecondesDepuisDebut);
        
        return elementMoment;
        
        
    }

    public int compareTo(Object o) {
        Moment m = (Moment) o;
        
        if(this.isStrictementAvant(m))
        {
            return -1;
        }
        else if(isEgal(m))
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    
    
    
    @Override
    public boolean equals(Object o)
    {
        if(!(o instanceof Moment))
            return false;
        else
            return isEgal((Moment) o);
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 97 * hash + (this.r != null ? this.r.hashCode() : 0);
        return hash;
    }
    
    @Override
    public String toString()
    {
        return r.toString();
    }
    
}
