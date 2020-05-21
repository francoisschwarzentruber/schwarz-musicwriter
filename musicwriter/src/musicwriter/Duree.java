/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import org.jdom.Element;

/**
 *
 * @author François Schwarzentruber
 */

public class Duree {
    static final public long divisionsStandard = 480*7*3;
    private Rational r = null;
    private boolean vague = false;


    Duree(Moment debutMoment, Moment finMoment)
    {
       r = finMoment.getRational().moins(debutMoment.getRational());
    }
    
    
    Duree(Rational r)
    {
        this.r = r;
    }
    

    Duree(long nbMilliSecondes, int nbNoiresParMinute) {
        this(new Rational(400 * nbMilliSecondes * nbNoiresParMinute / (60 * 1000), 400));
    }
    
    
    Moment getFinMoment(Moment debutMoment)
    {
        return new Moment(debutMoment.getRational().plus(r));
    }
    
    
    Moment getDebutMoment(Moment finMoment)
    {
        return new Moment(finMoment.getRational().moins(r));
    }

    int getNbMilliSecondes(int nbNoiresEnUneMinute) {
        double dureeNoire = 60*1000/nbNoiresEnUneMinute;
        return (int) (r.getRealNumber() * dureeNoire);
    }

    Rational getRational() {
        return r;
    }

    boolean isDeuxiemePetitPoint() {
        return r.getNumerateur() == 7;
    }


    /**
     *
     * @return true ssi la durée est vague, approximative
     */
    public boolean isVague()
    {
        return vague;
    }


    /**
     * Prévient que cette durée est approximative, vague. (nécessaire pour l'enregistrement
     * pour dire qu'il y a des imprécisions d'enregistrements, de délai informatique,
     * de mécompréhension de l'interprétation de l'exécutant)
     */
    public void setVague()
    {
        vague = true;
    }

    boolean isEgal(Duree duree) {
        return r.isEgal(duree.getRational());
    }

    boolean isPetitPoint() {
        return r.getNumerateur() == 3;
    }

    boolean isZero() {
        return r.isZero();
    }
    
    public boolean isStrictementInferieur(Duree d)
    {
        return this.getRational().isStrictementInferieur(d.getRational());
    }


    public boolean isSuperieur(Duree d) {
        return this.getRational().isSuperieur(d.getRational());
    }


    public boolean isStrictementSuperieur(Duree d) {
        return this.getRational().isStrictementSuperieur(d.getRational());
    }


    Element sauvegarder() {
        Element element = new Element("duration");
        element.addContent(String.valueOf(Math.round(divisionsStandard * r.getRealNumber() )) );
        return element;
    }




    public String musicXMLgetType()
    {
        if(isSuperieur(new Duree(new Rational(4, 1))))
        {
            return "whole";
        }
        else
        if(isSuperieur(new Duree(new Rational(2, 1))))
        {
            return "half";
        }
        else
        if(isSuperieur(new Duree(new Rational(1, 1))))
        {
            return "quarter";
        }
        else if(isStrictementSuperieur(new Duree(new Rational(1, 4))))
            return "eighth";
        else if(isStrictementSuperieur(new Duree(new Rational(1, 8))))
            return "16th";
        else if(isStrictementSuperieur(new Duree(new Rational(1, 16))))
            return "32th";
        else if(isStrictementSuperieur(new Duree(new Rational(1, 32))))
            return "64th";
        else if(isStrictementSuperieur(new Duree(new Rational(1, 64))))
            return "128th";
        else return null;

    }
    
    


    static int elementGetInteger(Element element)
    {
        if(element == null)
        {
            System.out.println("erreur d'ouverture de durée dans le fichier XML");
            return 1;
        }
        else
        {
            return Integer.parseInt(element.getValue());
        }
    }

    Duree(int divisions, Element element)
    {
          this(new Rational(elementGetInteger(element), divisions));
    }
    
    
    @Override
    public String toString()
    {
        return r.toString();
    }
    
    
    
    Element getElementBackUp()
    {
        Element element = new Element("backup");
        element.addContent(sauvegarder());
        return element;
    }
    
    
    Element getElementForward()
    {
        Element element = new Element("forward");
        element.addContent(sauvegarder());
        return element;
    }
    

    int getNombreTraitsCroche()
    {
        if(isZero())
            return 0;
        else
        if(isSuperieur(new Duree(new Rational(1, 1))))
        {
            return 0;
        }
        else if(isStrictementSuperieur(new Duree(new Rational(1, 4))))
            return 1;
        else if(isStrictementSuperieur(new Duree(new Rational(1, 8))))
            return 2;
        else if(isStrictementSuperieur(new Duree(new Rational(1, 16))))
            return 3;
        else if(isStrictementSuperieur(new Duree(new Rational(1, 32))))
            return 4;
        else if(isStrictementSuperieur(new Duree(new Rational(1, 64))))
            return 5;
        else
            return 6;

    }

    Duree moins(Duree duree) {
        return new Duree(getRational().moins(duree.getRational()));
    }

    @Override
    public boolean equals(Object obj) {
        if(obj instanceof Duree)
            return isEgal((Duree) obj);
        else
            return false;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 83 * hash + (this.r != null ? this.r.hashCode() : 0);
        return hash;
    }





    
    
}
