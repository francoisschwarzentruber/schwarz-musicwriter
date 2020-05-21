/*
 * Un Curseur c'est un endroit dans la partition
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class Curseur {
    private final Moment moment;
    private final Hauteur hauteur;
    private final Portee portee;
    private ElementMusical element = null;
    private final Voix voix;

    /**
     * Construit un curseur (ie un objet qui dit où on se trouve dans la
     * partition).
     * @param moment
     * @param hauteur
     * @param portee
     */
    Curseur(Moment moment, Hauteur hauteur, Portee portee)
    {
        this.moment = moment;
        this.hauteur = hauteur;
        this.portee = portee;
        this.voix = new Voix();
    }

    /**
     * Construit un curseur (ie un objet qui dit où on se trouve dans la
     * partition).
     * @param moment
     * @param hauteur
     * @param portee
     * @param voix
     */
    Curseur(Moment moment, Hauteur hauteur, Portee portee, Voix voix)
    {
        this.moment = moment;
        this.hauteur = hauteur;
        this.portee = portee;
        this.voix = voix;
    }
    
    /**
     *
     * @return retourne la hauteur (do#3, ou réb4 etc.) spécifiée par le curseur.
     */
    public Hauteur getHauteur() {
        return hauteur;
    }

    public Moment getMoment() {
        return moment;
    }

    public Portee getPortee() {
        return portee;
    }

    public Partie getPartie()
    {
        return portee.getPartie();
    }

    void declarerSurElementMusical(ElementMusical n) {
        element = n;
    }
    
    
    boolean isSurElementMusical()
    {
        return (element != null);
    }

    boolean isSurNote()
    {
        return (element != null) & (element instanceof Note);
    }



    public ElementMusical getElementMusical() {
        return element;
    }


    public Note getNote()
    {
        return (Note) element;
    }
    
    
    int getCoordonneeVerticaleSurPortee()
    {
         return portee.getCoordonneeVerticale(moment, hauteur);
    }
    
    
    public Voix getVoix()
    {
        return this.voix;
    }
    

}
