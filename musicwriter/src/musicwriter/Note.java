/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import org.jdom.Element;



/**
 *
 * @author proprietaire
 */
public class Note extends ElementMusicalSurVoix {
    private HampeDirection hampeDirection = HampeDirection.AUTOMATIC;
    private boolean lieeALaSuivante;

    /**
     *
     * @return la direction de la hampe. (vers le haut ou vers le bas)
     */
    public HampeDirection getHampeDirection() {
        return hampeDirection;
    }

    public void setHampeDirection(HampeDirection hampeDirection) {
        this.hampeDirection = hampeDirection;
    }



    public enum HampeDirection{
        AUTOMATIC(0), HAUT(1), BAS(2);
        
        private int numero = 0;

        private HampeDirection(int numero)
        {
            this.numero = numero;
        }
    }

    Note(Moment moment, Partie partie, int divisions, Element element) {
        super(moment, partie, divisions, element);
        setHauteur(new Hauteur(element.getChild("pitch")));

        if(element.getChild("tie") != null)
        {
            String a = element.getChild("tie").getAttributeValue("type");

            if(a != null)
                if(a.equals("start"))
                    setLieeALaSuivante(true);
        }
        
    }



    public void setHauteur(Hauteur hauteur) {
        this.hauteur = hauteur;
    }

    
    public void transposer(Intervalle intervalle)
    {
        setHauteur(intervalle.getHauteur2(hauteur));
    }

    public Hauteur getHauteur() {
        return hauteur;
    }
    

    public Hauteur getHauteurEntendue()
    {
        return getPortee().getPartie().getTransposition().getHauteur2(hauteur);
    }



    public boolean isLieeALaSuivante()
    {
        return lieeALaSuivante;
    }


    public void setLieeALaSuivante(boolean ouinon)
    {
        lieeALaSuivante = ouinon;
    }
        
        
    private Hauteur hauteur = null;
    
    
    Note(Moment departMoment, Duree duree, Hauteur hauteur, Portee portee)
    {
        super(departMoment, duree, portee);
        this.hauteur = hauteur;
        
    }
    
    Note(Moment departMoment, Duree duree, Hauteur hauteur, Portee portee, Voix voix)
    {
        super(departMoment, duree, portee);
        this.hauteur = hauteur;
        setVoix(voix);
        
    }
    
    @Override
    public Curseur getCurseur()
    {
        Curseur curseur = new Curseur(getDebutMoment(), hauteur, getPortee());
        curseur.declarerSurElementMusical(this);
        return curseur;
    }

    
    
   
    
    
    
    int getCoordonneeVerticaleSurPortee()
    {
         return getPortee().getCoordonneeVerticale(getDebutMoment(), hauteur);
    }
    
    



    
    
    


    
    
    
    

    @Override
    Element sauvegarder()
    {
        Element elementNote = super.sauvegarder();
        
        Element elementPitch = getHauteur().sauvegarder();   
        elementNote.addContent(elementPitch);
        elementNote.addContent(getPortee().sauvegarderNumero());

        if(isLieeALaSuivante())
        {
            Element elementTie = new Element("tie");
            elementTie.setAttribute("type", "start");
            elementNote.addContent(elementTie);
        }

        return elementNote;
        

    }
    
    
    
    @Override
    public String toString()
    {
        return "note " + hauteur.toString() + ", début moment : " + getDebutMoment().toString() + ", durée : " + getDuree();
    }


}
