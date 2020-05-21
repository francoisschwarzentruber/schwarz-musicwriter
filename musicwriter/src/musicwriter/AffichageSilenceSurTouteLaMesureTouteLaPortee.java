/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;
import javax.swing.ImageIcon;

/**
 *
 * @author Ancmin
 */
public class AffichageSilenceSurTouteLaMesureTouteLaPortee implements Affichage {

    final Systeme systeme;
    final Moment debutMesure;
    final Moment finMesure;
    final Portee portee;

    public Portee getPortee() {
        return portee;
    }

    static ImageIcon img = new ImageIcon(AffichageSilence.class.getResource("resources/pause.png"));
    


    AffichageSilenceSurTouteLaMesureTouteLaPortee(Systeme systeme, Moment debutMesure, Portee portee) {
        this.systeme = systeme;
        this.debutMesure = debutMesure;
        this.finMesure = systeme.getPartitionDonnees().getMomentMesureFin(debutMesure);
        this.portee = portee;
        
    }



    private double getWidth()
    {
        return (img.getIconWidth()*systeme.interligneGet()/50);
    }
    
    public double getX() {
       return (systeme.getXNotes(debutMesure) + systeme.getXBarreAuDebut(finMesure)) / 2
                - getWidth();
    }

    public void setX(double x) {
        
    }

    public void draw(Graphics2D g) {
        Rectangle r = getRectangle();

        if(!g.getColor().equals(Color.BLACK))
             g.fillRect(r.x, r.y, r.width, r.height);

        g.drawImage(img.getImage(),
                    r.x,
                    r.y,
                    r.width,
                    r.height,
                    null);



    }

    public Area getArea() {
        return new Area(getRectangle());
    }

    public Rectangle getRectangle() {
        double ytroisiemeligne = systeme.getPorteeTroisiemeLigneY(getPortee());
        int coordonneVerticale = 1;
        double y =  systeme.getY(ytroisiemeligne, coordonneVerticale);

        return new Rectangle(
            (int) getX(),
            (int) (y -  (img.getIconHeight() / 2)*systeme.interligneGet()/50),
            (int) getWidth(),
            (int) (img.getIconHeight()*systeme.interligneGet()/50));
    }

    public Selection getSelection(Shape area) {
        return new Selection();
    }

    public ElementMusical getElementMusical(Point point) {
        return null;
    }

}
