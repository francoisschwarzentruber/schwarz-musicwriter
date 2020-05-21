/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Timer;

/**
 *
 * @author Ancmin
 */
class NoteEcoute {
    private final Note note;
    private final MachineSortie machineSortie;
    private Timer timer;

    /**
     * Crée un objet qui représente une note qui s'écoute. On lui donne la note à écouter
     * et la machine qui va faire que la note s'écoute.
     * @param note
     * @param machineSortie
     */
    public NoteEcoute(Note note, MachineSortie machineSortie)
    {
        this.note = note;
        this.machineSortie = machineSortie;
    }

/**
 * Joue la note (on l'entend) pendant une durée courte.
 */
    public void ecouter()
    {
       
        this.machineSortie.demarrer();
        this.machineSortie.traiterNoteEnfoncee(
                note.getHauteur(),
                64,
                0,
                note.getPortee().getPartie().getInstrument());

        ActionListener listener = new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                machineSortie.traiterNoteRelachee(
                note.getHauteur(),
                64,
                0,
                note.getPortee().getPartie().getInstrument());
                timer.stop();
               
            }
        };
        
        timer = new Timer(300, listener);
        timer.start();
    }


}
