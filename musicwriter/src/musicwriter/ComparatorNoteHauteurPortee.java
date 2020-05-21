/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.Comparator;

/**
 *
 * @author Ancmin
 */
public class ComparatorNoteHauteurPortee implements Comparator<Note> {

        public int compare(Note note1, Note note2) {
            if(note2 == note1)
                return 0;
            else if(note2.getPortee().getPartie().getNumero() < note1.getPortee().getPartie().getNumero())
            {
                return -1;
            }
            else if(note2.getPartie().getNumero() > note1.getPartie().getNumero())
            {
                return 1;
            }
            else if(note2.getPortee().getNumero() < note1.getPortee().getNumero())
                return -1;
            else if((note2.getPortee().getNumero() == note1.getPortee().getNumero())
                     && note1.getHauteur().isStrictementPlusGrave(note2.getHauteur()))
                return -1;
//            else if ((note2.getPortee().getNumero() == note1.getPortee().getNumero())
//                     && note1.getHauteur().equals(note2.getHauteur()))
//                    return 0;
            else
                     return 1;

        }
    }
