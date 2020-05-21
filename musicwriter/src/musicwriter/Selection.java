/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author proprietaire
 */
public class Selection implements Iterable<ElementMusical>, Cloneable {
    Set<ElementMusical> elements = new HashSet<ElementMusical>();

    
    Selection() {}
    
    Selection(ElementMusical elementMusical) {
        ajouterElementMusical(elementMusical);
    }
    
    public void ajouterElementMusical(ElementMusical element)
    {
        elements.add(element);
    }

    public Iterator<ElementMusical> iterator() {
        return elements.iterator();
    }
    
    public Set<ElementMusical> getElementsMusicaux()
    {
        return elements;
    }

    public void ajouterSelection(Selection selection) {
        if(selection == null)
            return;
        
        for(ElementMusical el : selection)
        {
            ajouterElementMusical(el);  
        }
    }

    boolean contains(ElementMusical element) {
        return elements.contains(element);
    }

    Moment getDebutMoment() {
        Moment m = new Moment(new Rational(1000, 1));
        for(ElementMusical el : elements)
        {
            if(el.getDebutMoment().isAvant(m))
                m = el.getDebutMoment();
        }
        return m;
    }

    Iterable<ElementMusicalSurPortee> getElementsMusicauxSurPortee() {
        ArrayList<ElementMusicalSurPortee> N = new ArrayList<ElementMusicalSurPortee>();
        
        for(ElementMusical el : getElementsMusicaux())
        {
            if(el instanceof ElementMusicalSurPortee)
            {
                N.add((ElementMusicalSurPortee) el);
            }
        }
        
        return N;
    }

    Iterable<Note> getNotes() {
        ArrayList<Note> N = new ArrayList<Note>();
        
        for(ElementMusical el : getElementsMusicaux())
        {
            if(el instanceof Note)
            {
                N.add((Note) el);
            }
        }
        
        return N;
        
    }

    boolean isVide() {
        return elements.isEmpty();
    }
    

    public Selection clone()
    {
        Selection nouvelleSelection = new Selection();
        
        for(ElementMusical el : elements)
        {
            nouvelleSelection.ajouterElementMusical((ElementMusical) el.clone());
        }
        return nouvelleSelection;
        
    }

    void ajouterSelection(Set<ElementMusical> E) {
        elements.addAll(E);
    }

    Selection getSelectionMemeHauteur(Hauteur hauteur) {
        Selection nouvelleSelection = new Selection();

        for(ElementMusical el : elements)
        {
            if(el instanceof Note)
            {
                Note note = (Note) el;

                if(note.getHauteur().getNumeroModuloOctave() == hauteur.getNumeroModuloOctave())
                      nouvelleSelection.ajouterElementMusical(el);
            }
            
        }
        return nouvelleSelection;
    }

}
