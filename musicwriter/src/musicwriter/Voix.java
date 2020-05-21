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
public class Voix {
    int numero = 0;

    Voix(Element child) {
        this(Integer.parseInt(child.getValue()));
    }

    public int getNumero() {
        return numero;
    }
    
    static int nouveaunumero = 0;

    
    Voix(int numero)
    {
        this.numero = numero;
        nouveaunumero++;
    }
    
    
    Voix()
    {
        this(nouveaunumero);
    }

    int compareTo(Voix voix) {
        if(getNumero() < voix.getNumero())
            return -1;
        else if(getNumero() == voix.getNumero())
            return 0;
        else
            return 1;
    }
    
    
    
    @Override
    public boolean equals(Object voix)
    {
        if(voix instanceof Voix)
        {
             return (getNumero() == ((Voix) voix).getNumero());
        }
        else
            return false;
    }

    @Override
    public int hashCode() {
        return getNumero();
    }






    
    
    Element sauvegarder()
    {
        Element element = new Element("voice");
        element.addContent(String.valueOf( getNumero() ));
        return element;
    }
}
