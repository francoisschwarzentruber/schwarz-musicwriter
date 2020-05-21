/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.Iterator;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * Un accord est un ensemble de notes. Il est calculé avant l'affichage en prenant
 * l'ensemble des notes de la partition qui tombe en même temps et qui sont dans
 * la même voix.
 * @author François Schwarzentruber
 */
public class Accord extends ElementMusicalSurVoix implements Iterable<Note> {
     SortedSet<Note> notes = new TreeSet<Note>(new ComparatorNoteHauteurPortee());
     
    public Iterator<Note> iterator() {
        return notes.iterator();
    }

    boolean contains(Note note) {
        return notes.contains(note);
    }
    
    
    
     
     
     
     Accord(Note note)
     {
         super(note.getDebutMoment(), note.getDuree(), note.getPortee());
         ajouterNote(note);
     }
     
     /**
      * Ajoute la note note à l'accord
      * @param note
      */
     public void ajouterNote(Note note)
     {
         notes.add(note);
     }
     

     /**
      *
      * @return l'ensemble des notes qui sont dans l'accord
      */
     public Set<Note> getNotes()
     {
         return notes;
     }
     
     
     
     public Note noteLaPlusHaute()
     {
         return notes.last();
     }
     
     public Note noteLaPlusBasse()
     {
         return notes.first();
     }
     
     
     @Override
     public Duree getDuree()
     {
         return notes.first().getDuree();
     }
     
     
     
     
    @Override
     public Voix getVoix()
     {
         return notes.first().getVoix();
     }
     
     
     public boolean isNoteHautDessusNoteMoinsUn(Note note)
     {
         SortedSet<Note> noteavant = notes.headSet(note);
         
         if(noteavant.size() == 0)
             return false;
         else
         {
             Note notejusteavant = noteavant.last();
             return (notejusteavant.getPortee() == note.getPortee())
                     && (notejusteavant.getHauteur().getNumero() == note.getHauteur().getNumero() - 1);
         }
         
     }
     
}
