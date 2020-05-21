/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Polygon;
import java.util.ArrayList;

/**
 *
 * @author proprietaire
 */
public class StyloEsquisse {
    ArrayList<StyloPoint> points = null;

    boolean isPoint() {
        return points.size() < 2;
    }
    
    class StyloPoint
    {
        private Point point = null;

        public Curseur getCurseur() {
            return curseur;
        }

        public Point getPoint() {
            return point;
        }
        
        
        private Curseur curseur = null;

        StyloPoint(Point point, Curseur curseur) 
        {
            this.point = point;
            this.curseur = curseur;
        }
 
    }
    
    
    StyloEsquisse() 
        {
            points = new ArrayList<StyloPoint>();
        }
    
    
    void styloPointAjouter(Point point, Curseur curseur)
    {
        points.add(new StyloPoint(point, curseur));
    }
    
    
    
    public ArrayList<Curseur> getCurseurs()
    {
        ArrayList<Curseur> curseurs = new ArrayList<Curseur>();
        
        for(StyloPoint p : points)
        {
            curseurs.add(p.getCurseur());
        }
        
        return curseurs;
    }
    
    
    
    private double getAngleAuPoint(int i)
    {
        return Math.atan2(points.get(i+1).point.y - points.get(i).point.y,
                          points.get(i+1).point.x - points.get(i).point.x);
    }
    
    
    
        
    private double getAngleEntreExtremiteLaPlusLoinEtPoint(int i)
    {
        if(i < points.size() / 2)
        {
            int ifin = points.size() - 1;
            return Math.atan2(points.get(ifin).point.y - points.get(i).point.y,
                              points.get(ifin).point.x - points.get(i).point.x);
        }
        else
        {
            return Math.atan2(points.get(i).point.y - points.get(0).point.y,
                          points.get(i).point.x - points.get(0).point.x);
        }
        
    }
    
    
    private double getSegmentAngleMoyen()
    {
        double sommeangle = 0;
        for(int i = 0; i < points.size() - 2; i++)
        {
            sommeangle += getAngleAuPoint(i);
        }
        
        return sommeangle / (points.size() - 1);
    }
    
    
    public double getSegmentLongueur()
    {
        int ifin = points.size() - 1;
        return points.get(ifin).getPoint().distance(points.get(0).getPoint());
    }


    public Point getSegmentPremierPoint()
    {
        return points.get(0).getPoint();
    }
    
    
    
    public boolean isSegmentVertical()
    {
        return isSegment() && Math.abs(getSegmentAngleMoyen() - Math.PI / 2) < 0.3;
    }
    
    
    public boolean isSegment()
    {
        if(points.size() < 2)
            return false;
        
        double anglemoyen = getSegmentAngleMoyen();
        
        if(points.size() > 10)
            anglemoyen += 0;
        
        
        
        for(int i = 0; i < points.size() - 2; i++)
        {
            if(Math.abs(getAngleEntreExtremiteLaPlusLoinEtPoint(i) - anglemoyen) > 0.5)
                return false;
        }
        
        
        return true;
    }
    
    
    
    
    private float calcA(Point P, Point Q)
    {
        if(P.x == Q.x)
             return 1;
        else
            return -(P.y - Q.y) / (P.x - Q.x);
    }
    
    
    private float calcB(Point P, Point Q)
    {
        if(P.x == Q.x)
             return 0;
        else
            return 1;
    }
    
    
    
    private float calcC(Point P, Point Q)
    {
        if(P.x == Q.x)
             return -P.x;
        else
            return -(calcA(P, Q)*P.x + calcB(P, Q)*P.y);
        
        
    }
    
    
    
    
    private Point isIntersection(Point A, Point B, Point C, Point D)
    //renvoie le point d'intersection si les segments [AB] et [CD] s'intersectent
    //sinon renvoie null        
    {
        float a1 = calcA(A, B);
        float b1 = calcB(A, B);
        float c1 = calcC(A, B);
        
        float a2 = calcA(C, D);
        float b2 = calcB(C, D);
        float c2 = calcC(C, D);
        
        float delta = a1*b2 - a2*b1;
        
        
        if(delta == 0)
            return null;
        else
        {
            Point I = new Point((int) ((b2*c1 - b1*c2) / delta),
                    (int)((- a2*c1 + a1*c2)/ delta));
            
            if(((a1*C.x + b1*C.y + c1) * (a1*D.x + b1*D.y + c1) <= 0) &&
             ((a2*A.x + b2*A.y + c2) * (a2*B.x + b2*B.y + c2) <= 0))
                return I;
            else
                return null;
                       
        }

    }




    
    
    
    
    private int nbIntersectionInPoints()
    {
        int compteur = 0;
        for(int i = 0; i < points.size() - 2; i++)
        {
            for(int j = i+3; j < points.size() - 1; j++)
                    if(isIntersection(points.get(i).getPoint(),
                                      points.get(i+1).getPoint(),
                                      points.get(j).getPoint(),
                                      points.get(j+1).getPoint()) != null)
                        compteur++;
                
        }
        
        return compteur;
        
    }
    
    
    
    public boolean isGribouilli()
    {
        if(isSegment())
            return false;
        else
        return (points.size() > 5) && (nbIntersectionInPoints() > 6);
    }
    
    
    public boolean isPolygon()
    {
        return ( (points.size() > 3) && !isSegment() && (nbIntersectionInPoints() < 3) );
    }
    
    
    
    public Polygon getPolygon()
    {
        Polygon p = new Polygon();
        for(int i = 0; i < points.size() - 1; i++)
        {
            p.addPoint(points.get(i).getPoint().x,
                       points.get(i).getPoint().y);
        }
        
        return p;
    }
    
    
    void afficher(Graphics2D g)
    {
        if(points.size() == 0)
            return;
        
        StyloPoint pa = points.get(0);
        
        
        if(isGribouilli())
        {
            g.setStroke(new BasicStroke(8));
            g.setColor(Color.white);
        }
        else if(isSegment())
        {
            g.setStroke(new BasicStroke(1.5f));
            g.setColor(Color.blue);
        }
        else
        {
            g.setStroke(new BasicStroke(1.5f));
            g.setColor(Color.RED);
        }
        
        for(StyloPoint p : points)
        {
            g.drawLine(pa.getPoint().x, pa.getPoint().y, p.getPoint().x, p.getPoint().y);
            pa = p;
        }
    }
    
    
}
