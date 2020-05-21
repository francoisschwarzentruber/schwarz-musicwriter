/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;

/**
 *
 * @author proprietaire
 */
public class AffichageNoteFin implements Affichage {

    Systeme systeme = null;
    Note note = null;

    AffichageNoteFin(Systeme systeme, Note note) {
        this.systeme = systeme;
        this.note = note;
        
    }
    
    
    public void draw(Graphics2D g) {
        double finx = systeme.getXNotes(note.getFinMoment());
        double ycentrenote =  systeme.getY(note.getPortee(), note.getCoordonneeVerticaleSurPortee());

        g.setStroke(new BasicStroke(0.9f));
        g.setColor(new Color(0.8f, 0.8f, 0.8f));
            g.drawLine((int) finx, 
                        (int) (ycentrenote - systeme.interligneGet()/3),
                        (int) finx,
                        (int) (ycentrenote + systeme.interligneGet()/3));
            g.setColor(Color.BLACK);
    }

    public Selection getSelection(Shape area) {
        return null;
    }

    
    
    public Rectangle getRectangle() {
        double finx = systeme.getXNotes(note.getFinMoment());
        double ycentrenote =  systeme.getY(note.getPortee(), note.getCoordonneeVerticaleSurPortee());

            return new Rectangle((int) finx - 2, 
                        (int) ycentrenote - 2, 
                        (int) finx + 2,
                        (int) 4);
    }

    public Area getArea() {
        return new Area(getRectangle());
    }

    public ElementMusical getElementMusical(Point point) {
        return null;
    }

    public double getX() {return 0;}

    public void setX(double x) {}

    
    
}
