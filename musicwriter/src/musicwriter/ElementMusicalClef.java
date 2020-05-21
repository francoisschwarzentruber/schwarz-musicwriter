/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import musicwriter.Portee.Clef;
import org.jdom.Element;

/**
 *
 * @author Ancmin
 */
public class ElementMusicalClef extends ElementMusicalSurPortee {
     private final Portee.Clef clef;


     static Portee getPorteePartieElementNumber(Partie partie, Element elementAttribut)
     {
        if(elementAttribut.getAttributeValue("number") == null)
        {
             return partie.getPorteePremiere();
        }
             return partie.getPortee(Integer.parseInt(elementAttribut.getAttributeValue("number")));
     }

     
    ElementMusicalClef(Moment moment, Partie partie, Element elementAttribut) {
        this(moment,
              getPorteePartieElementNumber(partie, elementAttribut),
              Portee.Clef.Clef(elementAttribut));
    }

    public Clef getClef() {
        return clef;
    }

     ElementMusicalClef(Moment moment, Portee portee, Portee.Clef clef)
     {
          super(moment, portee);
          this.clef = clef;
     }



    @Override
    public Element sauvegarder()
    {
        Element elementClef = new Element("clef");
        elementClef.setAttribute("number", String.valueOf(getPortee().getNumero()));

        if(getClef().equals(Clef.ClefDeSol))
        {
              elementClef.addContent(new Element("sign").addContent("G"));
              elementClef.addContent(new Element("line").addContent("2"));
        }
        else
        {
            elementClef.addContent(new Element("sign").addContent("F"));
            elementClef.addContent(new Element("line").addContent("4"));
        }

        return elementClef;
    }

}
