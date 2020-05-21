/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.geom.Area;

/**
 *
 * @author Ancmin
 */
public class AffichageElementMusicalTempo extends AffichageElementMusical {

    private final Systeme  systeme;
    private double x;

    public AffichageElementMusicalTempo(Systeme systeme, double x, ElementMusicalTempo T)
    {
        super(T);
        this.systeme = systeme;
        this.x = x;
    }


    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }

    public void draw(Graphics2D g) {
        g.setFont(new Font(g.getFont().getName(), Font.BOLD, systeme.getFontSize(16)));
        g.drawString(getElementMusicalTempo().getNom(), (int) x, (int) getY());
    }

    public Area getArea() {
        return new Area(getRectangle());
    }


    private double getY()
    {
        return systeme.getYHaut() - 30;
    }

    public Rectangle getRectangle() {
        int height = 16;
        return new Rectangle((int) x, (int) getY() - height, 64, height);
    }


    private ElementMusicalTempo getElementMusicalTempo() {
        return (ElementMusicalTempo) getElementMusical();
    }







}
