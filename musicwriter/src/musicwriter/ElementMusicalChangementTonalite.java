/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import org.jdom.Element;

/**
 *
 * @author Ancmin
 */
public class ElementMusicalChangementTonalite extends ElementMusical {
    Tonalite tonalite;

    ElementMusicalChangementTonalite(Moment moment, Element element) {
        this(moment, new Tonalite(Integer.parseInt(element.getChild("fifths").getText())));

        
    }

    public Tonalite getTonalite() {
        return tonalite;
    }

    ElementMusicalChangementTonalite(Moment departMoment, Tonalite tonalite)
    {
        super(departMoment);
        this.tonalite = tonalite;
    }


    @Override
    Element sauvegarder()
    {
        return new Element("key")
                .addContent(new Element("fifths")
                .addContent(String.valueOf(tonalite.getDiesesNombre())));
    }



}
