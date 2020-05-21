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
public class ElementMusicalChangementMesureSignature extends ElementMusical {
    private final MesureSignature signature;

     ElementMusicalChangementMesureSignature(Moment departMoment, MesureSignature signature)
     {
         super(departMoment);
         this.signature = signature;
     }

    ElementMusicalChangementMesureSignature(Moment moment, Element child) {
        this(moment, new MesureSignature(Integer.parseInt(child.getChildText("beats")),
                Integer.parseInt(child.getChildText("beat-type"))));
        
    }



     MesureSignature getSignature()
     {
         return signature;
     }


    @Override
     Element sauvegarder()
     {
         Element element = new Element("time");
         element.addContent((new Element("beats"))
                 .addContent(String.valueOf(signature.getNumerateur())));
         element.addContent((new Element("beat-type"))
                 .addContent(String.valueOf(signature.getDenominateur())));
         return element;
     }
}
