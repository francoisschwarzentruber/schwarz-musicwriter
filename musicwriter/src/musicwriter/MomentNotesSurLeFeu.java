/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author proprietaire
 */
public class MomentNotesSurLeFeu {
    private Set<ElementMusical> tabNotesAJouer = new HashSet<ElementMusical>();
    private Set<ElementMusicalDuree> tabNotesQuiPerdurent = new HashSet<ElementMusicalDuree>();
    private Set<ElementMusicalDuree> tabNotesQuiSontRelachees = new HashSet<ElementMusicalDuree>();
    
    private Moment moment = null;
    
    
    MomentNotesSurLeFeu(Moment moment)
    {
        this.moment = moment;
    }
    
    public Set<ElementMusical> getElementsMusicauxAJouer() {
        return tabNotesAJouer;
    }
    
    
    public Set<ElementMusical> getElementsMusicauxRassemblesEnAccordsAJouer() {
        Set<ElementMusical> els = new HashSet<ElementMusical>();
        
        Map<Voix, Accord> accords = new HashMap<Voix, Accord>();
        
        for(ElementMusical el : tabNotesAJouer)
        {
             if(el instanceof Note)
             {
                 Note note = (Note) el;

                 if(accords.containsKey(note.getVoix()))
                 {
                     accords.get(note.getVoix()).ajouterNote(note);
                 }
                 else
                 {
                     accords.put(note.getVoix(), new Accord(note));
                 }

             }
             else
                 els.add(el);
        }
        els.addAll(accords.values());
        return els;
    }

    Set<ElementMusicalDuree> getElementsMusicauxAvecDureeConcernees() {
        
        Set<ElementMusicalDuree> s = getElementsMusicauxDureeAJouer();
        s.addAll(getElementsMusicauxQuiPerdurent());
        return s;
    }
    
    
    private Set<ElementMusicalDuree> getElementsMusicauxDureeAJouer() {
        Set<ElementMusicalDuree> N = new HashSet<ElementMusicalDuree>();
        
        for(ElementMusical el : tabNotesAJouer)
        {
            if(el instanceof ElementMusicalDuree)
            {
                N.add((ElementMusicalDuree) el);
            }
        }
        return N;
    }
    
    
    
    public Set<Note> getNotesAJouer() {
        Set<Note> N = new HashSet<Note>();
        
        for(ElementMusical el : tabNotesAJouer)
        {
            if(el instanceof Note)
            {
                N.add((Note) el);
            }
        }
        return N;
    }

    public Set<ElementMusicalDuree> getElementsMusicauxQuiPerdurent() {
        return tabNotesQuiPerdurent;
    }
    
    
    public Set<Note> getNotesQuiPerdurent() {
        Set<Note> N = new HashSet<Note>();
        
        for(ElementMusical el : tabNotesQuiPerdurent)
        {
            if(el instanceof Note)
            {
                N.add((Note) el);
            }
        }
        return N;
    }
    
    public Set<Note> getNotesQuiSontRelachees() {
        Set<Note> N = new HashSet<Note>();
        
        for(ElementMusical el : tabNotesQuiSontRelachees)
        {
            if(el instanceof Note)
            {
                N.add((Note) el);
            }
        }
        return N;
    }
    
    
    public Set<ElementMusicalDuree> getElementsMusicauxQuiSontRelachees() {
        return tabNotesQuiSontRelachees;
    }
    
    
    public void NotesAJouerAjouter(ElementMusical note)
    {
        tabNotesAJouer.add(note);
    }
    
    
    public void NotesQuiPerdurentAjouter(ElementMusicalDuree note)
    {
        tabNotesQuiPerdurent.add(note);
    }

    public Moment getMoment() {
        return moment;
    }

    
    void NotesQuiSontRelachees(ElementMusicalDuree note) {
        tabNotesQuiSontRelachees.add(note);
    }

    Duree getElementsMusicauxAJouerDureeMinimum() {
        Set<ElementMusicalDuree> T = getElementsMusicauxDureeAJouer();
        
        if(T.isEmpty())
            return new Duree(new Rational(0, 1));
        
        Duree d = new Duree(new Rational(100, 1));
        for(ElementMusicalDuree el : T)
        {
            if(d.getRational().isSuperieur(el.getDuree().getRational()))
            {
                d = el.getDuree();
            }
            
        }
        return d;
    }

    ElementMusicalSurVoix getElementMusicalSurVoix(Voix voix) {
        for(ElementMusical el : getElementsMusicauxRassemblesEnAccordsAJouer())
        {
            if(el instanceof Accord)
            {
                Accord accord = (Accord) el;
                if(accord.getVoix().equals(voix))
                    return accord;
            }
        }
        return null;
    }
    
    
    
    
    
    
    
    
}
