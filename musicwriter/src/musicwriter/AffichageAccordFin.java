/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Point;

/**
 *
 * @author proprietaire
 */
public class AffichageAccordFin extends AffichageEnsemble implements Affichage {

    public AffichageAccordFin(Systeme systeme, Accord accord) {
        super(0);

        for(Note note : accord)
        {
            add(new AffichageNoteFin(systeme, note));
        }
    }

    @Override
    public ElementMusical getElementMusical(Point point) {
        return null;
    }

    @Override
    public void setX(double x) {}
    
    
    
     
}
