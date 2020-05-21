/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author Ancmin
 */
public class PartitionActionNoteLierALaSuivante implements PartitionAction {
    private final boolean anciennevaleur;
    private final Note note;
    private final boolean nouvellevaleur;

    PartitionActionNoteLierALaSuivante(Note note, boolean ouinon)
    {
        this.note = note;
        this.nouvellevaleur = ouinon;
        anciennevaleur = note.isLieeALaSuivante();
    }


    public void executer(PartitionDonnees partitionDonnees) {
        note.setLieeALaSuivante(nouvellevaleur);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        note.setLieeALaSuivante(anciennevaleur);
    }



}
