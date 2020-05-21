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
 * @author proprietaire
 */
public class AffichageSilence extends AffichageElementMusical {
    
    private Systeme systeme;
    private double x;
    static ImageIcon imgSoupir = new ImageIcon(AffichageSilence.class.getResource("resources/soupir.png"));
    static ImageIcon imgPause = new ImageIcon(AffichageSilence.class.getResource("resources/pause.png"));
    static ImageIcon imgDemiPause = new ImageIcon(AffichageSilence.class.getResource("resources/demi-pause.png"));
    static ImageIcon imgDemiSoupir = new ImageIcon(AffichageSilence.class.getResource("resources/demi-soupir.png"));
    static ImageIcon imgQuartDeSoupir = new ImageIcon(AffichageSilence.class.getResource("resources/quart-de-soupir.png"));
    
    ImageIcon img;
    
    
    AffichageSilence(Systeme systeme, double x, Silence silence)
    {
        super(silence);
        this.systeme = systeme;
        this.x = x;
        
        if(getDuree().isStrictementInferieur(new Duree(new Rational(1, 2))))
            this.img = imgQuartDeSoupir;
        else if(getDuree().isStrictementInferieur(new Duree(new Rational(1, 1))))
            this.img = imgDemiSoupir;
        else if(getDuree().isStrictementInferieur(new Duree(new Rational(2, 1))))
            this.img = imgSoupir;
        else if(getDuree().isStrictementInferieur(new Duree(new Rational(4, 1))))
            this.img = imgDemiPause;
        else
            this.img = imgPause;

        
    }
    
    Silence getSilence()
    {
        return (Silence) getElementMusical();
    }
    
    
    
    private double noteRayonGet()
    {
        return systeme.noteRayonGet();
    }
    
    
    private double getYMiddle()
    {
        Rectangle r = getRectangle();
        return (r.getMaxY() + r.getMinY()) / 2;
    }
    
    
    private void drawPetitPoint(Graphics2D g)
    {
        Rectangle r = getRectangle();
        dessinerDisque(g, r.getMaxX() + noteRayonGet(),
                          getYMiddle(), 0.4*noteRayonGet());
    }
    
    private void drawDeuxiemePetitPoint(Graphics2D g)
    {
        Rectangle r = getRectangle();
        dessinerDisque(g, r.getMaxX() + noteRayonGet(),
                          getYMiddle(), 0.4*noteRayonGet());
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
        
        
        if(getDuree().isPetitPoint())
        {
            drawPetitPoint(g);
        }
        
        
        if(getDuree().isDeuxiemePetitPoint())
        {
            drawDeuxiemePetitPoint(g);
        }
    }

    public Area getArea() {
        return new Area(getRectangle());
    }





    public Rectangle getRectangle() {
        double ytroisiemeligne = systeme.getPorteeTroisiemeLigneY(getSilence().getPortee());
        int coordonneVerticale = getSilence().getCoordonneeVerticaleSurPortee();
        double y =  systeme.getY(ytroisiemeligne, coordonneVerticale);
        
        return new Rectangle(
            (int) getX(),
            (int) (y -  (img.getIconHeight() / 2)*systeme.interligneGet()/50),
            (int) (img.getIconWidth()*systeme.interligneGet()/50),
            (int) (img.getIconHeight()*systeme.interligneGet()/50));
    }

    public Selection getSelection(Shape area) {
        if(area.intersects(getRectangle()))
            return new Selection(getElementMusical());
        else
            return new Selection();
    }


    public void setX(double x) {
        this.x = x;
    }

    private Duree getDuree() {
        return getSilence().getDuree();
    }

    public double getX() {
        return x;
    }

}
