/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;

/**
 *
 * @author Ancmin
 */
public class AffichageChangementTonalite extends AffichageElementMusical implements Affichage {
    private Systeme systeme;
    private double x;

    AffichageChangementTonalite(Systeme systeme, double x, ElementMusicalChangementTonalite element)
    {
          super(element);
          this.systeme = systeme;
          this.x = x;
    }

    AffichageChangementTonalite(Systeme systeme, ElementMusicalChangementTonalite elementMusicalChangementTonalite) {
        this(systeme, systeme.getXBarreAuDebut(elementMusicalChangementTonalite.getDebutMoment()),
                elementMusicalChangementTonalite);

        if(systeme.getPartitionDonnees().isBarreDeMesure(getDebutMoment())   )
        {
            deplacerX(-getWidth());
        }
        
        
    }

    private int getNombreDieses(Portee portee)
    {
        return getTonalite(portee).getDiesesNombre();
    }

    private int getNombreDiesesJusteAvant(Portee portee)
    {
        return getTonaliteJusteAvant(portee).getDiesesNombre();
    }


    private boolean isAfficheBecarres(Portee portee)
    {
        return getNombreDieses(portee) * getNombreDiesesJusteAvant(portee) <= 0;
    }



    private Tonalite getTonalite(Portee portee)
    {
        return portee.getPartie().getTonaliteTransposee(getElementMusicalChangementTonalite().getTonalite());
    }


    private Tonalite getTonaliteJusteAvant(Portee portee)
    {
        return systeme.getPartitionDonnees().getTonaliteJusteAvant(getDebutMoment(),
                                                                   portee.getPartie());
    }


    private ElementMusicalChangementTonalite getElementMusicalChangementTonalite()
    {
        return ((ElementMusicalChangementTonalite) getElementMusical());
    }




    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }


    private double getEspaceEntreAlteration()
    {
        return 0.6*systeme.interligneGet();
    }

    public void draw(Graphics2D g) {

        
        for(Portee p : systeme.getPortees())
        {
            double xcourant = getX();

            if(isAfficheBecarres(p))
                for(Hauteur hauteur : getTonaliteJusteAvant(p).getHauteursAltereesAffichees(p.getClef(getDebutMoment())))
                {
                    systeme.dessinerAlterationADroite(g,
                            Hauteur.Alteration.NATUREL,
                            xcourant,
                            systeme.getY(p, p.getCoordonneeVerticale(
                                getDebutMoment(),
                                hauteur)));
                    xcourant += getEspaceEntreAlteration();
                }


            for(Hauteur hauteur : getTonalite(p).getHauteursAltereesAffichees(p.getClef(getDebutMoment())))
            {
                systeme.dessinerAlterationADroite(g,
                        hauteur.getAlteration(),
                        xcourant,
                        systeme.getY(p, p.getCoordonneeVerticale(
                            getDebutMoment(),
                            hauteur)));
                xcourant += getEspaceEntreAlteration();
            }
        }
    }


    public int getWidth()
    {
        int width = 0;
        for(Portee p : systeme.getPortees())
        {
            int nvwidth = (int) (getEspaceEntreAlteration() * Math.abs(getNombreDieses(p)) + systeme.interligneGet());

            if(isAfficheBecarres(p))
                nvwidth += (int) (getEspaceEntreAlteration() * Math.abs(getNombreDiesesJusteAvant(p)));

            if(nvwidth > width)
                width = nvwidth;
        }
        return width;
    }

    public Rectangle getRectangle() {
        return new Rectangle((int) getX(),
                             (int) systeme.getYHaut(),
                             getWidth(),
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
                    (int) ( systeme.getPorteeYHaut(p) - systeme.interligneGet() ),
                    getWidth(),
                    (int) ( systeme.getPorteeHeight(p) + 2*systeme.interligneGet()) )));
        }
        return a;
    }

    void deplacerX(double delta) {
        setX(getX() + delta);
    }

}
