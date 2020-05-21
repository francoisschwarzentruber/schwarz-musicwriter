/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import musicwriter.Hauteur.Alteration;
import musicwriter.Portee.Clef;

/**
 *
 * @author Ancmin
 */
public class Tonalite {
    private final int diesesNombre;

    public Tonalite(int diesesNombre)
    {
        this.diesesNombre = diesesNombre;
    }


    static int toniqueMajeurToDiesesNombre(Hauteur hauteurNoteToniqueMajeur)
    {
        int[] T = {0, 2, 4, -1, 1, 3, 5};
        return T[hauteurNoteToniqueMajeur.getNumeroModuloOctave()]
                + hauteurNoteToniqueMajeur.getAlteration().getNumero()*7;
    }

    public static String getNom(int diesesNombre)
    {
        switch(diesesNombre)
        {
            case -7: return "dob majeur/lab mineur";
            case -6: return "solb majeur/mib mineur";
            case -5: return "réb majeur/sib mineur";
            case -4: return "lab majeur/fab mineur";
            case -3: return "mib majeur/dob mineur";
            case -2: return "sib majeur/solb mineur";
            case -1: return "fa majeur/réb mineur";
            case 0: return "do majeur/la mineur";
            case 1: return "sol majeur/mi mineur";
            case 2: return "ré majeur/si mineur";
            case 3: return "la majeur/fa# mineur";
            case 4: return "mi majeur/do# mineur";
            case 5: return "si majeur/sol# mineur";
            case 6: return "fa# majeur/ré# mineur";
            case 7: return "do# majeur/la# mineur";
            default: return "";
        }
    }




    Tonalite(Hauteur hauteurNoteToniqueMajeur) {
        this(toniqueMajeurToDiesesNombre(hauteurNoteToniqueMajeur));
    }

/**
 *
 * @return le nombre de dièse de cette tonalité. Par exemple ré majeur => la fonction retourne 2.
 * Pour mib majeur, la fonction retourne -3. (nombre négatif = nombre de bémol).
 * Pour do majeur, la fonction retourne 0.
 */
    public int getDiesesNombre()
    {
        return diesesNombre;
    }


    private ArrayList<Hauteur> getHauteursAlterees()
    {
        ArrayList<Hauteur> hauteurs = new ArrayList<Hauteur>();

        Hauteur h = new Hauteur(0, Hauteur.NoteNom.FA, Hauteur.Alteration.DIESE);
        for(int i = 1; i <= getDiesesNombre(); i++)
        {
            hauteurs.add(0, h);
            h = Intervalle.getIntervalleQuinte().getHauteur2(h);
        }


        h = new Hauteur(-1, Hauteur.NoteNom.SI, Hauteur.Alteration.BEMOL);
        for(int i = -1; i >= getDiesesNombre(); i--)
        {
            hauteurs.add(0, h);
            h = Intervalle.getIntervalleQuarte().getHauteur2(h);
        }

        return hauteurs;
    }

    
    public ArrayList<Hauteur> getHauteursAltereesAffichees(Clef clef) {
        ArrayList<Hauteur> hauteurs = getHauteursAlterees();

        if(clef.equals(Clef.ClefDeSol))
        {
            for(Hauteur hauteur : hauteurs)
            {
                if(hauteur.getNumeroModuloOctave() < 4)
                    hauteur.setOctave(1);
                else
                    hauteur.setOctave(0);
            }
        }
        else
        {
            for(Hauteur hauteur : hauteurs)
            {
                    hauteur.setOctave(-1);
            }
        }

        return hauteurs;
    }

    Alteration getAlteration(Hauteur hauteur) {
        for(Hauteur h : getHauteursAlterees())
        {
              if(h.getNumeroModuloOctave() == hauteur.getNumeroModuloOctave())
                  return h.getAlteration();
        }
        return Alteration.NATUREL;
    }

}
