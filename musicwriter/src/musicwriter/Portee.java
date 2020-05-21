/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.TreeMap;
import javax.swing.ImageIcon;
import org.jdom.Element;

/**
 *
 * @author proprietaire
 */
public class Portee {

    private TreeMap<Moment, ElementMusicalClef> elementsMusicauxClefs
            = new TreeMap<Moment, ElementMusicalClef>();
    
    static private Clef StringToClef(String texte)
    {
        if(texte.equals("clefDeSol"))
            return Clef.ClefDeSol;
        else if(texte.equals("clefDeFa"))
            return Clef.ClefDeFa;
        else
        {
            System.out.print("Erreur dans stringToClef");
            return Clef.ClefDeSol;
        }
        
    }

    
    private Partie partie;
    
    
//    Portee(Element element) {
//        this(
//              Integer.parseInt(element.getChild("porteeNumero").getText()),
//              StringToClef(element.getChild("clef").getText())
//              );
//
//    }

    public int getCoordonneeVerticale(Moment debutMoment, Hauteur hauteur) {
        return getClef(debutMoment).getCoordonneeVerticale(hauteur);
        
    }





    public Hauteur getHauteur(Moment moment, int coordonneeVerticale) {
        return getClef(moment).getHauteur(coordonneeVerticale);
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    Partie getPartie() {
        return this.partie;
    }



    public void clefSupprimer(ElementMusicalClef elementClef) {
        elementsMusicauxClefs.remove(elementClef.getDebutMoment());
    }

    public void clefAjouter(ElementMusicalClef elementClef) {
        elementsMusicauxClefs.put(elementClef.getDebutMoment(), elementClef);
    }


    public Clef getClef(Moment moment)
    {
        ElementMusicalClef elementMusicalClef = getElementMusicalClef(moment);

        if(elementMusicalClef == null)
            return Clef.ClefDeSol;
        else
        {
            return elementMusicalClef.getClef();
        }
    }


    /**
     *
     * @param moment
     * @return retourne l'élement musical clef qui "gouverne" au moment moment.
     * L'élement musical n'est pas forcément placé au moment moment, mais cette fonction
     * retourne la plus proche clef qui précède le moment moment.
     */
    ElementMusicalClef getElementMusicalClef(Moment moment) {
        moment = elementsMusicauxClefs.floorKey(moment);

        if(moment == null)
            return null;
        else
        {
            return elementsMusicauxClefs.get(moment);
        }
    }




    public enum Clef {
        ClefDeSol(-6), ClefDeFa(6);


        private static Clef lettreClefToClef(String lettre)
        {
            if(lettre.equals("F"))
                return ClefDeFa;
            else
                return ClefDeSol;
        }

        public static Clef Clef(Element element)
        {
            return lettreClefToClef(element.getChild("sign").getText());
        }



         Clef(int decalageEntreHauteurNumeroEtCoordonneeVerticale)
        {
            this.decalageEntreHauteurNumeroEtCoordonneeVerticale
                    = decalageEntreHauteurNumeroEtCoordonneeVerticale;

            if(decalageEntreHauteurNumeroEtCoordonneeVerticale == -6)
            {
                img = new ImageIcon(this.getClass().getResource("resources/clef_sol.png"));
            }
            else if(decalageEntreHauteurNumeroEtCoordonneeVerticale == 6)
            {
                img = new ImageIcon(this.getClass().getResource("resources/clef_fa.png"));
            }
        }




        private int decalageEntreHauteurNumeroEtCoordonneeVerticale = 0;
        private ImageIcon img = null;
        
        
        
        
        
        private int getCoordonneeVerticale(Hauteur hauteur) {
            return hauteur.getNumero() + decalageEntreHauteurNumeroEtCoordonneeVerticale;
            
            // ex : un do avec une clef de sol
            // do => hauteur.getNumero() = 0
            //clef de sol => decalageEntreHauteurNumeroEtCoordonneeVerticale = -6
            // ==> on écrit sur la coordonnée verticale = -6.

        }
        
        
        
        
        public ImageIcon getImageIcon()
        {
            return img;
        }



        /**
         *
         * @param coordonneeVerticale
         * @return Par exemple, si clefSol désigne la clef de sol,
         * clefSol.getHauteur(0) donne si0.
         * clefSol.getHauteur(2) donne ré1.
         */
        private Hauteur getHauteur(int coordonneeVerticale)
        {
            return new Hauteur(coordonneeVerticale - decalageEntreHauteurNumeroEtCoordonneeVerticale, 
                               Hauteur.Alteration.NATUREL);
        }
        
        

        


       
        
        public Element sauvegarder()
        {
            Element elementClef = new Element("clef");
            
            switch(decalageEntreHauteurNumeroEtCoordonneeVerticale)
            {
                    case -6:   elementClef.addContent("clefDeSol");
                               break;
                               
                    case 6:   elementClef.addContent("clefDeFa");
                               break;           
                               
                default:
                    System.out.println("erreur dans Clef.sauvegarder()");
            }
            
            return elementClef;
            
        }
        
        
    }
    
    
    private int numero = 0;
    private int numeroAffichage = 0;

    public int getNumeroAffichage() {
        return numeroAffichage;
    }

    public void setNumeroAffichage(int numeroAffichage) {
        this.numeroAffichage = numeroAffichage;
    }
    
    Portee(Partie partie)
    {
        this.numero = 0;
        this.partie = partie;
        
    }
    
    
    
    int getNumero()
    {
        return numero;
    }
    
    
    
    Element sauvegarderNumero()
    {
        Element elementPorteeNumero = new Element("staff");
        elementPorteeNumero.addContent(String.valueOf(numero));
        return elementPorteeNumero;
    }
    
    
    

    
    
    
}
