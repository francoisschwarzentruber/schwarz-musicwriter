/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.BasicStroke;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;
import java.awt.geom.Rectangle2D;

/**
 * Cette classe représente l'affichage d'une barre de mesure.
 * @author François Schwarzentruber
 */
class AffichageBarreDeMesure extends AffichageElementMusical implements Affichage {
    private Systeme systeme = null;
    private double x;

    public AffichageBarreDeMesure(Systeme systeme, double x, BarreDeMesure barreDeMesure) {
        super(barreDeMesure);
        this.systeme = systeme;
        this.x = x;
    }

    public void draw(Graphics2D g) {
        g.setStroke(new BasicStroke(1.2f));
        systeme.afficherBarre(g, x);
    }


    public Shape getShape()
    {
        return new Rectangle2D.Double(x - 2,
                               systeme.getYHaut(),
                               4,
                               systeme.getYBas() - systeme.getYHaut());
    }
    
    public Rectangle getRectangle()
    {
        return new Rectangle((int) x - 0,
                             (int)  systeme.getYHaut(),
                               0,
                             (int)  (systeme.getYBas() - systeme.getYHaut()));
    }
    
    
    @Override
    public Selection getSelection(Shape area) {
         if(area.contains(getRectangle()))
             return new Selection(getElementMusical());
         else
             return new Selection();

    }

    public Area getArea() {
        return new Area(getShape());
    }

    public void setX(double x) {
        this.x = x;
    }

    public double getX() {
        return x;
    }

}
