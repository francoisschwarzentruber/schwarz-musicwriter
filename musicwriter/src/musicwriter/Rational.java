/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */

public class Rational {
    private long numerateur = 0;
    private long denominateur = 1;
    
    
    
    public Rational(long numerateur, long denominateur)
    {
         this.numerateur = numerateur;
         this.denominateur = denominateur;
         
         if(this.denominateur == 0)
         {
             Erreur.message("Création d'un nombre rational avec un dénominateur nul.");
             this.denominateur = 1;
         }
         reduire();
    }

    boolean isZero() {
        return numerateur == 0;
    }

    

    Rational moins(Rational rational) {
        return new Rational(numerateur * rational.getDenominateur()
                    - rational.getNumerateur() * denominateur,
                    denominateur * rational.getDenominateur());
    }


    Rational plus(Rational rational) {
        return new Rational(numerateur * rational.getDenominateur()
                    + rational.getNumerateur() * denominateur,
                    denominateur * rational.getDenominateur());
    }

    
    
    private long pgcd(long a, long b)
    {
        long q = a / b;
        long r = a % b;
        
        if(r == 0)
        {
            return b;
        }
        else
        {
            return pgcd(b, r);
        }

    }
    
    
    
    private void reduire()
    {
        long d = pgcd(numerateur, denominateur);
        numerateur = numerateur / d;
        denominateur = denominateur / d;
    }
    
    

    public long getDenominateur() {
        return denominateur;
    }

    public long getNumerateur() {
        return numerateur;
    }


    public double getRealNumber()
    {
        return ((double) numerateur) / ((double) denominateur);
    }

    boolean isEgal(Rational rational) {
        return (numerateur == rational.getNumerateur()) 
                && (denominateur == rational.getDenominateur());
    }
    
    boolean isInferieur(Rational rational) {
         return (getRealNumber() <= rational.getRealNumber());
    }
    
    
    boolean isStrictementInferieur(Rational rational) {
        return (getRealNumber() < rational.getRealNumber());
    }

    boolean isSuperieur(Rational rational) {
        return (getRealNumber() >= rational.getRealNumber());
    }
    
    boolean isStrictementSuperieur(Rational rational) {
        return (getRealNumber() > rational.getRealNumber());
    }
    
    
    @Override
    public String toString()
    {
        return numerateur + "/" + denominateur;
    }
    
    
    @Override
    public boolean equals(Object o)
    {
        if(!(o instanceof Rational))
        {
            return false;
        }
        else
        {
            return isEgal((Rational) o);
        }
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 83 * hash + (int) (this.numerateur ^ (this.numerateur >>> 32));
        hash = 83 * hash + (int) (this.denominateur ^ (this.denominateur >>> 32));
        return hash;
    }

    Rational multiplier(Rational rational) {
        return new Rational(numerateur * rational.getNumerateur(), denominateur * rational.getDenominateur());
        
    }
    
}

