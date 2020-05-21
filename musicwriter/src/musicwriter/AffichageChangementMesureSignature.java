/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;

/**
 *
 * @author Ancmin
 */
public class AffichageChangementMesureSignature extends AffichageElementMusical implements Affichage {
    private final Systeme systeme;
    private double x;


    AffichageChangementMesureSignature(Systeme systeme, double x, ElementMusicalChangementMesureSignature element)
    {
          super(element);
          this.systeme = systeme;
          this.x = x;
    }


    private ElementMusicalChangementMesureSignature getChangementMesureSignature()
    {
        return (ElementMusicalChangementMesureSignature) getElementMusical();
    }

    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }

    public void draw(Graphics2D g) {
        g.setFont(new Font(g.getFont().getName(), Font.BOLD, systeme.getFontSize(22)));
        for(Portee p : systeme.getPortees())
        {
            g.drawString(String.valueOf(getChangementMesureSignature().getSignature().getNumerateur()),
                         (int) x,
                         (int) systeme.getY(p, 0));
            g.drawString(String.valueOf(getChangementMesureSignature().getSignature().getDenominateur()),
                         (int) x,
                         (int) systeme.getY(p, -4));
        }
    }


    public Rectangle getRectangle() {
        return new Rectangle((int) getX(), 
                             (int) systeme.getYHaut(),
                             (int) getWidth(),
                             (int) (systeme.getYBas() - systeme.getYHaut()));
    }

    @Override
    public Selection getSelection(Shape area) {
         if(area.contains(getRectangle()))
             return new Selection(getElementMusical());
         else
             return new Selection();
    }

    public Area getArea() {
        Area a = new Area();
        for(Portee p : systeme.getPortees())
        {
            a.add(new Area(new Rectangle((int) getX(),
                    (int) systeme.getPorteeYHaut(p),
                    (int) getWidth(),
                    (int) systeme.getPorteeHeight(p))));
        }
        return a;
    }

    private double getWidth() {
        return systeme.interligneGet() * 1.6;
    }


}
