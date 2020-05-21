/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;
import javax.swing.ImageIcon;

/**
 *
 * @author Ancmin
 */
public class AffichageElementMusicalClef extends AffichageElementMusical {

    private double x;
    private final Systeme systeme;
    private final ImageIcon img = getElementMusicalClef().getClef().getImageIcon();

    public AffichageElementMusicalClef(Systeme systeme, double x, ElementMusicalClef elementMusicalClef) {
        super(elementMusicalClef);
        this.systeme = systeme;
        this.x = x;
        
    }



    public AffichageElementMusicalClef(Systeme systeme, ElementMusicalClef elementMusicalClef) {
        this(systeme, systeme.getXBarreAuDebut(elementMusicalClef.getDebutMoment()),
                elementMusicalClef);

        if(systeme.getPartitionDonnees().isBarreDeMesure(getDebutMoment())   )
        {
            deplacerX(-getWidth());
        }


    }

    void deplacerX(double delta) {
        setX(getX() + delta);
    }
        

    public ElementMusicalClef getElementMusicalClef()
    {
        return (ElementMusicalClef) getElementMusical();
    }
    

    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }

    public void draw(Graphics2D g) {
        
        Rectangle r = getRectangle();

        if(g.getColor().equals(Color.RED))
        {
            g.fillRect(r.x, r.y, r.width, r.height);
        }


        g.drawImage(img.getImage(),
                    (int) r.x,
                    (int) r.y,
                    (int) r.width,
                    (int) r.height,
                    null);
    }



    public double getWidth()
    {
        return getRectangle().width;
    }

    public Area getArea() {
        return new Area(getRectangle());
    }

    public Rectangle getRectangle() {
        int yCoordonneeVerticale = (int) systeme.getY(getElementMusicalClef().getPortee(), 0);
        return new Rectangle((int) x,
                    (int) (yCoordonneeVerticale -  (img.getIconHeight() / 2)*systeme.interligneGet() /50),
                    (int) (img.getIconWidth()*systeme.interligneGet()/50),
                    (int) (img.getIconHeight()*systeme.interligneGet()/50));
    }

    public Selection getSelection(Shape area) {
         if(area.contains(getRectangle()))
             return new Selection(getElementMusical());
         else
             return new Selection();
    }





}
