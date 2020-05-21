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
abstract public class ElementMusicalSurVoix extends ElementMusicalDuree {
    private Voix voix = new Voix();
    
    ElementMusicalSurVoix(Moment moment, Partie partie, int divisions, Element element) {
        super(moment, partie,divisions, element);
        setVoix(new Voix(element.getChild("voice")));
        

    }
    
    
    
    ElementMusicalSurVoix(Moment departMoment, Duree duree, Portee portee)
    {
        super(departMoment, duree, portee);
    }
    
    
    
    
    public void setVoix(Voix voix)
    {
        this.voix = voix;
    }
    
    
    
    public Voix getVoix()
    {
        return voix;
    }
    
    
    
    @Override
    Element sauvegarder()
    {
        Element element = super.sauvegarder();
        element.addContent(getVoix().sauvegarder());
        return element;
        
    }
    
}
