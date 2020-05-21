/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author Ancmin
 */
public class MesureSignature {
    private long numerateur = 0;
    private long denominateur = 1;



    public MesureSignature(long numerateur, long denominateur)
    {
         this.numerateur = numerateur;
         this.denominateur = denominateur;
    }



    public long getDenominateur() {
        return denominateur;
    }

    public long getNumerateur() {
        return numerateur;
    }

    public double getGroupe() {
        if(numerateur == 6 && denominateur == 8)
            return 1.5;
        else
            return 1;

    }

    Duree getMesuresDuree() {
        return new Duree(new Rational(numerateur * 4, denominateur));
    }


}
