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
public class Silence extends ElementMusicalDuree {

    Hauteur hauteur = null;

    Silence(Moment departMoment, Partie partie, int divisions, Element element) {
        super(departMoment, partie, divisions, element);
        
        if(element.getChild("pitch") != null)
            setHauteur(new Hauteur(element.getChild("pitch")));
        else
            setHauteur(new Hauteur(2, Hauteur.Alteration.NATUREL));
    }
    
    Silence(Moment departMoment, Duree duree, Portee portee, Hauteur hauteur)
    {
        super(departMoment, duree, portee);
        this.hauteur = hauteur;
        
    }

    int getCoordonneeVerticaleSurPortee() {
        return getPortee().getCoordonneeVerticale(getDebutMoment(), hauteur);
    }

    Hauteur getHauteur() {
        return hauteur;
    }
    
    void setHauteur(Hauteur hauteur)
    {
        this.hauteur = hauteur;
    }
    
    
    @Override
    Element sauvegarder()
    {
        Element elementSilence = super.sauvegarder();
        
        Element elementPitch = getHauteur().sauvegarder();   
        elementSilence.addContent(elementPitch);
        elementSilence.addContent(new Element("rest"));
        elementSilence.addContent(getPortee().sauvegarderNumero());
        
        return elementSilence;
        

    }
    
    
    
    
    
}
