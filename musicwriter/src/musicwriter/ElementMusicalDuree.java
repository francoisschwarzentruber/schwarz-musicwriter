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
abstract public class ElementMusicalDuree extends ElementMusicalSurPortee {
    private Duree duree = null;
    
    
    ElementMusicalDuree(Moment moment, Partie partie, int divisions, Element element) {
        super(moment, partie, element);
        setDuree(new Duree(divisions, element.getChild("duration")));

        if(element.getChild("vague") != null)
            duree.setVague();

    }
    
    
    ElementMusicalDuree(Moment departMoment, Duree duree, Portee portee)
    {
        super(departMoment, portee);
        this.duree = duree;
    }
    

    public Duree getDuree() {
        return duree;
    }
    
    public void setDuree(Duree duree)
    {
        this.duree = duree;
    }


    void setDureeVague() {
        this.duree.setVague();
    }

    
    Moment getFinMoment() {
        return new Moment(getDebutMoment().getRational().plus(duree.getRational()));
    }
    
    void setFinMoment(Moment finMomentNouveau) {
        duree = new Duree(getDebutMoment(), finMomentNouveau);
        
    }
    




    @Override
    Element sauvegarder()
    {
        Element elementNote = new Element("note");
        Element elementDuree = getDuree().sauvegarder();
        
        elementNote.addContent(elementDuree);

        /* là on ajoute de la décoration*/

        if(getDuree().musicXMLgetType() != null)
            elementNote.addContent(new Element("type").setText(getDuree().musicXMLgetType()));

        if(getDuree().isPetitPoint())
        {
            elementNote.addContent(new Element("dot"));
        }

        if(getDuree().isDeuxiemePetitPoint())
        {
            elementNote.addContent(new Element("dot"));
        }

        if(getDuree().isVague())
        {
            elementNote.addContent(new Element("vague"));
        }
        
        return elementNote;
        

    }
    
    
}
