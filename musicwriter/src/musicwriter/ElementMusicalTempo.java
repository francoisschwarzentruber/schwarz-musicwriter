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
public class ElementMusicalTempo extends ElementMusical {
    private int nbNoireEnUneMinute;
    private String nom;

    static private String getWords(Element elementDirection)
    {
        if(elementDirection.getChild("direction-type") != null)
        {
            if(elementDirection.getChild("direction-type").getChild("words") != null)
                return elementDirection.getChild("direction-type").getChild("words").getText();
        }
              
        return "";

    }

    ElementMusicalTempo(Moment moment, Element elementDirection) {
        this(moment,
             Integer.parseInt(elementDirection.getChild("sound").getAttributeValue("tempo")),
              getWords(elementDirection));
    }

    public int getNbNoiresEnUneMinute() {
        return nbNoireEnUneMinute;
    }

    public void setNbNoireEnUneMinute(int nbNoireEnUneMinute) {
        this.nbNoireEnUneMinute = nbNoireEnUneMinute;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public ElementMusicalTempo(Moment debutMoment, int nbNoireEnUneMinute, String nom)
    {
        super(debutMoment);
        this.nbNoireEnUneMinute = nbNoireEnUneMinute;
        this.nom = nom;
    }

    @Override
    Element sauvegarder() {
        Element elementDirection = new Element("direction");
        Element elementDirectionType = new Element("direction-type");
        Element elementDirectionTypeWords = new Element("words");
        elementDirectionTypeWords.setText(getNom());
        elementDirection.addContent(elementDirectionType);
        elementDirectionType.addContent(elementDirectionTypeWords);
        elementDirection.addContent(new Element("sound").setAttribute("tempo", String.valueOf(getNbNoiresEnUneMinute())));
        
        return elementDirection;
    }

    
}
