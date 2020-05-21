/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.BasicStroke;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Polygon;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;
import java.util.ArrayList;

/**
 *
 * @author proprietaire
 */
public class AffichageCrocheReliee implements Affichage {

    final ArrayList<AffichageAccord> accords;
    final private Systeme systeme;
    private double pente;

    final int traitepaisseur;
    final int traitespacement;

    public double getPente() {
        return pente;
    }


    static private ArrayList<AffichageAccord> arrayListSingleton(AffichageAccord a){
         ArrayList<AffichageAccord> T = new ArrayList<AffichageAccord>();
         T.add(a);
         return T;
    }

    
    AffichageCrocheReliee(Systeme systeme, AffichageAccord a) {
        this(systeme, arrayListSingleton(a));
         
    }
    
    
    AffichageCrocheReliee(Systeme systeme, ArrayList<AffichageAccord> accords) {
        this.systeme = systeme;
        this.accords = accords;
        
        if(accords.get(0).isHampeVersLeHaut())
        {
            for(AffichageAccord a : accords)
            {
                a.setHampeVersLeHaut();
            }
        }
        else
        {
            for(AffichageAccord a : accords)
            {
                a.setHampeVersLeBas();
            }
        }

        if(accords.size() > 1)
            calculerHampesY();

        traitepaisseur = (int) (systeme.interligneGet() * 0.5);
        traitespacement = (int) (systeme.interligneGet() * 0.8);
    }
    
    


    public void draw(Graphics2D g) {
        if(accords.size() == 1)
            drawQueue(g, accords.get(0));
        else
            drawTraits(g, accords);

        
    }

    public Area getArea() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Rectangle getRectangle() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Selection getSelection(Shape area) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ElementMusical getElementMusical(Point point) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    
    private int n()
    {
        return accords.size()-1;
    }
    
    
    private double getHampeX(int i)
    {
        return accords.get(i).getHampeX();
    }
    
    
    private double getHampeYFin(int i)
    {
        return accords.get(i).getHampeYFin();
    }
        
        
    private int getNombreTraits(int i)
    {
        return accords.get(i).getNombreTraitsCroche();
    }

    private int getImaxY()
    {
        double maxy = -50;
        int imax = -1;
        for(int i = 0; i <= n(); i++)
        {
            if(accords.get(i).getMaxY() > maxy)
            {
                  maxy = accords.get(i).getMaxY();
                  imax = i;
            }
        }
        return imax;
    }


    private int getIminY()
    {
        double miny = 5e99;
        int imin = -1;
        for(int i = 0; i <= n(); i++)
        {
            if(accords.get(i).getMinY() < miny)
            {
                  miny = accords.get(i).getMaxY();
                  imin = i;
            }
        }
        return imin;
    }


    private double penteCalculer()
    {
        final double  penteLimite = 0.3;

        pente = (accords.get(n()).getHampeYFin() - accords.get(0).getHampeYFin())
                  / (accords.get(n()).getHampeX() - accords.get(0).getHampeX());

        if(pente < -penteLimite)
            return -penteLimite;
        else if (pente > penteLimite)
            return penteLimite;
        else
            return pente;
    }

    private void calculerHampesY() {
       
        pente = penteCalculer();


        if(accords.get(0).isHampeVersLeHaut())
        {
            int i = getIminY();
            accords.get(0).setHampeYFin(accords.get(i).getMinY() - 3*systeme.interligneGet() + pente
                    * (accords.get(0).getHampeX() - accords.get(i).getHampeX()));
            
            
        }
        else
        {
            int i = getImaxY();
            accords.get(0).setHampeYFin(accords.get(i).getMaxY() + 3*systeme.interligneGet() + pente
                    * (accords.get(0).getHampeX() - accords.get(i).getHampeX()));
        }

        for(int i = 0; i <= n(); i++)
        {
            accords.get(i).setHampeYFin(accords.get(0).getHampeYFin()
                    + pente * (accords.get(i).getHampeX() - accords.get(0).getHampeX()));
        }
        
    }

    

    private void drawQueue(Graphics2D g, AffichageAccord a) {
        double y1 = a.getHampeYFin();
        double x = a.getHampeX();

        g.setStroke(new BasicStroke(3.0f));
        for(int i = 0; i < a.getNombreTraitsCroche();i++)
            g.drawLine((int) x, 
                       (int) y1+i*6*a.get1SiHampeVersHaut(),
                       (int) (x + 8),
                       (int) y1 + (16 + i*6)*a.get1SiHampeVersHaut());
    }




    private void drawTraitSurUnSeul(Graphics2D g, int i, int traitnumero, int signe) {
        traitnumero--;

        int directionx;

        if(i == 0)
            directionx = 1;
        else
            directionx = -1;

        int x1 = (int) getHampeX(i);
        int y1 = (int) getHampeYFin(i) - 1 + traitespacement * traitnumero * signe;

        int x2 = (int) (getHampeX(i) + directionx * systeme.interligneGet());
        int y2 = (int) (getHampeYFin(i) - 1 + traitespacement * traitnumero * signe + directionx * getPente() * systeme.interligneGet());

        Polygon P = new Polygon();

        P.addPoint(x1, y1);
        P.addPoint(x2, y2);
        P.addPoint(x2, y2 + traitepaisseur);
        P.addPoint(x1, y1 + traitepaisseur);
        g.fillPolygon(P);
    }

    private void drawTrait(Graphics2D g,
                           int accorddebuti,
                           int accordfini,
                           int traitnumero,
                           int signe)
    {
        if(accorddebuti == accordfini)
        {
             drawTraitSurUnSeul(g, accorddebuti, traitnumero, signe);
        }
        else
        {
            traitnumero--;
            int x1 = (int) getHampeX(accorddebuti);
            int y1 = (int) getHampeYFin(accorddebuti) - 1 + traitespacement * traitnumero * signe;

            int x2 = (int) getHampeX(accordfini);
            int y2 = (int) getHampeYFin(accordfini) - 1 + traitespacement * traitnumero * signe;

            Polygon P = new Polygon();

            P.addPoint(x1, y1);
            P.addPoint(x2, y2);
            P.addPoint(x2, y2 + traitepaisseur);
            P.addPoint(x1, y1 + traitepaisseur);
            g.fillPolygon(P);
        }
        
    }
    
    private void drawTraits(Graphics2D g, ArrayList<AffichageAccord> accords) {
        //g.setStroke(new BasicStroke(4));

        int signe = accords.get(0).get1SiHampeVersHaut();

        for(int t = 1; t < 5; t++)
        {
            int debuti = -1;
            for(int i = 0; i <= n(); i++)
            {
                if(debuti == -1)
                {
                    if(getNombreTraits(i) >= t)
                        debuti = i;
                }

                if(debuti > -1)
                {
                    if(getNombreTraits(i) < t)
                    {
                        drawTrait(g, debuti, i-1, t, signe);
                        debuti = -1;
                    }
                    else
                    {
                        if(i == n())
                        {
                            drawTrait(g, debuti, i, t, signe);
                        }
                    }
                }
                
            }
        }
    }

    public void setX(double x) {}

    public double getX() {return 0;}


        
}
