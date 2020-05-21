/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;
import java.awt.geom.Ellipse2D;
import javax.swing.ImageIcon;
import musicwriter.Hauteur.Alteration;

/**
 *
 * @author proprietaire
 */
public class AffichageNote extends AffichageElementMusical implements Affichage {

    static ImageIcon imgVerte = new ImageIcon(AffichageSilence.class.getResource("resources/note-verte.png"));
    static ImageIcon imgFleur = new ImageIcon(AffichageSilence.class.getResource("resources/note-fleur.png"));
    static ImageIcon imgPacMan = new ImageIcon(AffichageSilence.class.getResource("resources/note-pacman.png"));

    Systeme systeme = null;
    double notecentrex;
    private final Alteration alterationParDefaut;
    
    AffichageNote(Systeme systeme, Note note, double notecentrex) {
        super(note);
        this.systeme = systeme;
        this.notecentrex = notecentrex;

        alterationParDefaut = systeme
                .getPartitionDonnees()
                .getAlterationParDefaut
                (note.getDebutMoment(),
                systeme.getDebutMoment(),
                note.getPortee(),
                note.getHauteur());
        
    }
    
    
    private Note getNote()
    {
        return (Note) getElementMusical();
    }


    private Moment getFinMoment()
    {
        return getNote().getFinMoment();
    }

    private Shape getShape() {
        double cercleRayon = getNoteRayon();
        double cercleCentreY = systeme.getY(getNote().getPortee(), getNote().getCoordonneeVerticaleSurPortee());

        return new Ellipse2D.Double(notecentrex - cercleRayon - 1, 
                                                       cercleCentreY - cercleRayon,
                                                         2 * cercleRayon + 2,
                                                         2 * cercleRayon);
    }


    private double getNoteRayon()
    {
        return systeme.noteRayonGet();
    }
    
    
    private double interligneGet()
    {
        return systeme.interligneGet();
    }
    
    
    private void afficherLigneSupplementaire(Graphics2D g, double xcentrenote, double yLigneSupplementaire) {
            /* affiche UNE ligne supplémentaire*/
            g.drawLine((int) (xcentrenote - systeme.ligneSupplementaireLongueurGet() / 2),
                       (int) yLigneSupplementaire, 
                       (int) (xcentrenote + systeme.ligneSupplementaireLongueurGet() / 2), 
                       (int) yLigneSupplementaire);
        }
    
    

    /**
     *
     * @param g
     * @param xcentrenote
     * @param ytroisiemeligne
     * @param coordonneVerticale
     *
     * Dessine les lignes supplémentaires si jamais la note est trop aigu ou trop grave
     * ytroisiemeligne = le y de la 3e ligne centrale de la portée concernée
     */
    private void afficherLignesSupplementaires(Graphics2D g,
                                                   double xcentrenote,
                                                   double ytroisiemeligne,
                                                   int coordonneVerticale) {
        
          g.setStroke(new BasicStroke(1.8f));
          //si une note est trop aigue
            for(int ligneSupplementaireCoordonneeVerticale = 6;
                 ligneSupplementaireCoordonneeVerticale <= coordonneVerticale;
                 ligneSupplementaireCoordonneeVerticale+=2)
            {
                afficherLigneSupplementaire(g,
                                            xcentrenote, 
                                            systeme.getY(ytroisiemeligne,
                                      ligneSupplementaireCoordonneeVerticale));
            }

            //si une note est trop grave
            //(ce qui est suit c'est ce qui a au dessus avec tous les signes opposés)
            for(int ligneSupplementaireCoordonneeVerticale = -6;
                 ligneSupplementaireCoordonneeVerticale >= coordonneVerticale;
                 ligneSupplementaireCoordonneeVerticale-=2)
            {
                afficherLigneSupplementaire(g,
                                            xcentrenote, 
                                            systeme.getY(ytroisiemeligne, 
                                            ligneSupplementaireCoordonneeVerticale));
            }
        }


    
    
    

    
    
    
        
    
    
    private void drawPetitPoint(Graphics2D g)
    {
        double y = getNoteCentreY();

        if(isSurLigne())
            y -= interligneGet()*0.4;
        
        dessinerDisque(g, notecentrex + 2.2*getNoteRayon(),
                          y, 0.4*getNoteRayon());
    }
    
    private void drawDeuxiemePetitPoint(Graphics2D g)
    {
        double y = getNoteCentreY();

        if(isSurLigne())
            y += interligneGet()*0.4;
        
        dessinerDisque(g, notecentrex + 2.2*getNoteRayon(),
                          y, 0.4*getNoteRayon());
    }




    private void drawLangue(Graphics2D g, int x1, int y, int x2, double ranimation)
    {
        int n = (int) ((x2 - x1) / systeme.interligneGet());
        int epaisseur = (int) ((systeme.interligneGet()/8) * (1.2+Math.cos(ranimation*5)));
        for(int i = 0; i<n; i++)
        {
            int x = x1 + (int) (i*systeme.interligneGet());
            g.drawLine(x, y - epaisseur,
                    x + (int) (systeme.interligneGet()/2),
                    y + epaisseur);
            g.drawLine(x + (int) systeme.interligneGet(), y - epaisseur,
                    x + (int) (systeme.interligneGet()/2),
                    y + epaisseur);
        }
    }

    public void dessinerFleur(Graphics2D g, Moment moment)
    {
        Rectangle r = getRectangle();
        r.grow((int) (0.3*systeme.interligneGet()), (int) (0.3*systeme.interligneGet()));

        if(getNote().getDuree().isStrictementInferieur(new Duree(new Rational(2, 1))))
        {
            double angle = moment.getRational().getRealNumber()*2;
            g.rotate(angle, getNoteCentreX(), getNoteCentreY());
//            g.setColor(Color.red);
//            g.fillOval((int) (getNoteCentreX()  - systeme.getNoteRayon() - 3f),
//                   (int) (getNoteCentreY() - systeme.getNoteRayon()),
//                   (int) (2 * systeme.getNoteRayon() + 6),
//                   (int) (2 * systeme.getNoteRayon() - 1));
//            g.setColor(Color.black);
            g.drawImage(imgFleur.getImage(), r.x, r.y, r.width, r.height, null);
            g.rotate(-angle, getNoteCentreX(), getNoteCentreY());
        }
        else
        {
            g.drawImage(imgPacMan.getImage(), r.x, r.y, r.width, r.height, null);
            g.setStroke(new BasicStroke(2.0f));
            g.setColor(Color.RED);

            drawLangue(g, (int) r.getCenterX(),
                       (int) r.getCenterY(),
                       (int) systeme.getXNotes(moment),
                       moment.getRealNumber());
        }

    }



    private boolean isSurLigne()
    {
        return (getNote().getCoordonneeVerticaleSurPortee() % 2 == 0);
    }


    @Override
    public void draw(Graphics2D g) {        
        afficherLignesSupplementaires(g,
                                      notecentrex,
                                       systeme.getPorteeTroisiemeLigneY(getNote().getPortee()),
                                      getNote().getCoordonneeVerticaleSurPortee());

        //affiche les altérations #, b, etc.
        if(!getNote().getHauteur().getAlteration().equals(alterationParDefaut))
            systeme.dessinerAlterationGauche(g,
                               getNote().getHauteur().getAlteration(),
                               getNoteCentreX() - getNoteRayon(),
                               getNoteCentreY());
        
        
        if(getNote().getDuree().getRational().isZero()
                || getNote().getDuree().isVague())
        {
            for(int i = -2; i<=2; i++)
               g.drawLine((int)(getNoteCentreX() - getNoteRayon()),
                          (int)(getNoteCentreY() + i * interligneGet()/4),
                          (int)(getNoteCentreX() + getNoteRayon()),
                          (int)(getNoteCentreY() + i * interligneGet()/3));
            return;
        }

        


        
        if(getNote().getDuree().getRational().isSuperieur(new Rational(2, 1)))
            dessinerCercle(g, getNoteCentreX(), getNoteCentreY(), getNoteRayon());
        else
            dessinerDisque(g, getNoteCentreX(), getNoteCentreY(), getNoteRayon());
        
        
        if(getNote().getDuree().isPetitPoint())
        {
            drawPetitPoint(g);
        }
        
        
        if(getNote().getDuree().isDeuxiemePetitPoint())
        {
            drawDeuxiemePetitPoint(g);
        }
        
        
        

        if(getNote().isLieeALaSuivante())
            drawLieeALaSuivante(g);

        
        
        
    }


    @Override
    public Selection getSelection(Shape area) {
        Area a = new Area(getShape());
        a.intersect(new Area(area));
        
        if(!a.isEmpty())
        {
            return new Selection(getNote());
        }
        else
            return null;
        
    }

    public Area getArea() {
        return new Area(getRectangle());
    }
    
    public Rectangle getRectangle()
    {
        double cercleRayon = getNoteRayon();

        return new Rectangle((int) (getNoteCentreX() - cercleRayon),
                             (int) (getNoteCentreY() - cercleRayon),
                             (int) (2 * cercleRayon)+1,
                             (int) (2 * cercleRayon)+1);
    }


    public double getNoteCentreY()
    {
        return  systeme.getY(getNote().getPortee(), getNote().getCoordonneeVerticaleSurPortee());
    }


    private double getNoteCentreX()
    {
        return notecentrex;
    }

    public double getX() {
        return notecentrex;
    }

    public void setX(double x) {
        notecentrex = x;
    }

    private void drawLieeALaSuivante(Graphics2D g) {
        ControlCurve p = new NatCubic();
        double xdebut = (getNoteCentreX() + getNoteRayon() + interligneGet() * 0.2 );
        double xfin = systeme.getXNotes(getFinMoment()) - getNoteRayon()  - interligneGet() * 0.2;
        double y = getNoteCentreY() + getNoteRayon();
        p.addPoint( (int) xdebut, (int) y);
        p.addPoint( (int) (xdebut + xfin) / 2, (int) (y + interligneGet() * 0.5));
        p.addPoint( (int) xfin, (int) (y));
        p.paint(g);
    }



}
