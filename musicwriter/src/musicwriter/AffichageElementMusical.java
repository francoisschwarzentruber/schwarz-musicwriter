/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Shape;

/**
 *
 * @author proprietaire
 */
abstract class AffichageElementMusical implements Affichage {

    private ElementMusical elementMusical = null;

    public ElementMusical getElementMusical() {
        return elementMusical;
    }

    
    AffichageElementMusical(ElementMusical element)
    {
        elementMusical = element;
    }
    
    
    public ElementMusical getElementMusical(Point point)
    {
        if(getArea().contains(point))
            return getElementMusical();
        else
            return null;
    }


    protected Moment getDebutMoment()
    {
        return getElementMusical().getDebutMoment();
    }

    static protected void dessinerCercle(Graphics2D g, double cercleCentreX, double cercleCentreY, double cercleRayon) {
        final double angle = -0.5;
        g.rotate(angle, cercleCentreX, cercleCentreY);
        g.drawOval((int) (cercleCentreX - cercleRayon - 1.5f),
                   (int) (cercleCentreY - cercleRayon),
                   (int) (2 * cercleRayon + 3),
                   (int) (2 * cercleRayon - 1));
        g.rotate(-angle, cercleCentreX, cercleCentreY);
        
    }
    
    static protected void dessinerDisque(Graphics2D g, double cercleCentreX, double cercleCentreY, double cercleRayon) {
        final double angle = -0.3;
        g.rotate(angle, cercleCentreX, cercleCentreY);
        g.fillOval((int) (cercleCentreX - cercleRayon - 1.5f),
                   (int) (cercleCentreY - cercleRayon),
                   (int) (2 * cercleRayon + 3),
                   (int) (2 * cercleRayon));
        g.rotate(-angle, cercleCentreX, cercleCentreY);
        
    }

    public Selection getSelection(Shape area) {
         if(area.contains(getRectangle()))
             return new Selection(getElementMusical());
         else
             return new Selection();
    }

}
