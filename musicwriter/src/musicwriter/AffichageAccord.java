/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Graphics2D;
import java.awt.Rectangle;

/**
 * Cette classe représente l'affichage d'un accord (ensemble de notes jouées en même temps et appartenant à la même voix).
 * @author François Schwarzentruber
 */
public class AffichageAccord extends AffichageEnsemble {
    private double hampeybas;
    private double hampeyhaut;
    private double hampeyfin;
    private boolean hampeisaffiche = true;
    private Accord accord = null;
    private Systeme systeme = null;
    private boolean isContientDeuxNotesTresProches = false;

    public Accord getAccord() {
        return accord;
    }


    Note.HampeDirection hampeDirection = Note.HampeDirection.HAUT;






    public AffichageAccord(Systeme systeme, double x, Accord accord) {
        super(x);
        
        this.systeme = systeme;
        this.accord = accord;
        
        notesEnregistrer();
        hampeDirectionDefaut();
        calculerHampePositions();
        
    }



    private void notesEnregistrer()
    {
        for(Note note : accord)
        {
            if(accord.isNoteHautDessusNoteMoinsUn(note))
            {
                add(new AffichageNote(systeme, note, getX() + systeme.noteRayonGet() * 2));
                isContientDeuxNotesTresProches = true;
            }
            else
                add(new AffichageNote(systeme, note, getX()));

        }
    }
        

    @Override
    public void draw(Graphics2D g) {
        super.draw(g);
        
        if(hampeisaffiche)
            afficherHampe(g);
    }


    public int get1SiHampeVersHaut()
    {
        if(isHampeVersLeHaut())
            return 1;
        else
            return -1;
    }

    public double getHampeX() {
        if(hampeDirection == Note.HampeDirection.BAS)
        {
               if(isContientDeuxNotesTresProches)
                     return getX() + systeme.noteRayonGet();
               else
                   return getX() - systeme.noteRayonGet();
        }
        else
              return getX() + systeme.noteRayonGet();
    }

    public double getHampeYFin() {
        return hampeyfin;
    }
    
    public void setHampeYFin(double hampeyfin)
    {
        this.hampeyfin = hampeyfin;
    }

    public int getNombreTraitsCroche() {
        return getDuree().getNombreTraitsCroche();
    }

    Moment getMomentDebut() {
        return getAccord().getDebutMoment();
    }

    Moment getMomentFin() {
        return getAccord().getFinMoment();
    }

    Voix getVoix() {
        return accord.getVoix();
    }



    private void afficherHampe(Graphics2D g) {
             g.drawLine((int) getHampeX(), 
                        (int) Math.min(hampeyfin, hampeyhaut), 
                        (int) getHampeX(), 
                        (int) Math.max(hampeyfin, hampeybas));    

    }

    
    public AffichageNote getAffichageNote(Note note)
    {
        for(Affichage a : this)
        {
            if(((AffichageNote) a).getElementMusical() == note)
            {
                return ((AffichageNote) a);
            }
        }
        return null;
    }

    public Duree getDuree() {
        return getAccord().getDuree();
    }

    public boolean isHampeVersLeHaut() {
        return hampeDirection == Note.HampeDirection.HAUT;
    }


    public void setHampeVersLeHaut()
    {
        hampeDirection = Note.HampeDirection.HAUT;
        calculerHampePositions();

    }


    public void setHampeVersLeBas()
    {
        hampeDirection = Note.HampeDirection.BAS;
        calculerHampePositions();
    }
    

    public void setHampeDirection(Note.HampeDirection hampeDirection)
    {
        this.hampeDirection = hampeDirection;
        calculerHampePositions();
    }


    public Note.HampeDirection getHampeDirection()
    {
        return this.hampeDirection;
    }


    public Rectangle getHampeRectangle()
    {
        double hampeyfinaccentue = hampeYFinCalculer(5 * systeme.interligneGet());

        return new Rectangle((int) (getHampeX() - 1.5*systeme.interligneGet()),
                             (int) (Math.min(hampeyfinaccentue, hampeyhaut)),
                             (int) ( 3*systeme.interligneGet() ),
                             (int) (Math.max(hampeyfinaccentue, hampeybas) - Math.min(hampeyfinaccentue, hampeyhaut)));


        
    }

    void flipHampe() {
        if(hampeDirection.equals(Note.HampeDirection.BAS))
            hampeDirection = Note.HampeDirection.HAUT;
        else
            hampeDirection = Note.HampeDirection.BAS;

        calculerHampePositions();
    }


    private void hampeDirectionDefaut()
    {
        Note notelaplusbasse = accord.noteLaPlusBasse();
        int notelaplusbasse_coordVerticale = notelaplusbasse.getCoordonneeVerticaleSurPortee();
        if(notelaplusbasse_coordVerticale > 2)
            hampeDirection = Note.HampeDirection.BAS;
    }



    private double hampeYFinCalculer(double longueur)
    {
        if(isHampeVersLeHaut())
                return hampeyhaut - longueur;
        else
                return hampeybas + longueur;
    }

    
    private void calculerHampePositions() {
        
        Note notelaplusbasse = accord.noteLaPlusBasse();
        Note notelaplushaute = accord.noteLaPlusHaute();

        hampeybas = systeme.getY(notelaplusbasse.getPortee(),
                                 notelaplusbasse.getCoordonneeVerticaleSurPortee());

        hampeyhaut = systeme.getY(notelaplushaute.getPortee(),
                                 notelaplushaute.getCoordonneeVerticaleSurPortee());

        hampeyfin = hampeYFinCalculer(3 * systeme.interligneGet());


        hampeisaffiche = (accord.getDuree().getRational().isStrictementInferieur(new Rational(4, 1)));
    }
    
    
    public double getMaxY()
    {
        return getRectangle().getMaxY();
    }

    
    public double getMinY()
    {
        return getRectangle().getMinY();
    }

}
