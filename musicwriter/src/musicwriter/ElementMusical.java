/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;



import java.util.logging.Level;
import java.util.logging.Logger;
import org.jdom.Element;

/**
 *
 * @author proprietaire
 */
public class ElementMusical implements Cloneable {
    private Moment debutMoment = null;

    public Moment getDebutMoment() {
        return debutMoment;
    }


    
    ElementMusical(Moment departMoment)
    {
        this.debutMoment = departMoment;
        
    }
    
    
    
    public Curseur getCurseur()
    {
        Curseur curseur = new Curseur(debutMoment,
                new Hauteur(0, Hauteur.Alteration.NATUREL), null);
        curseur.declarerSurElementMusical(this);
        return curseur;
    }

    
    
    
    
    
    public void deplacer(Moment debutMoment) {
        this.debutMoment = debutMoment;
    }

    
    
    
    Element sauvegarder()
    {
        return new Element("cannot-save");
        

    }
    
    
    
    @Override
    public Object clone()
    {
        try {
            return super.clone();
        } catch (CloneNotSupportedException ex) {
            Logger.getLogger(ElementMusical.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    

}
