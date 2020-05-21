/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionElementMusicalSupprimer implements PartitionAction {
    private ElementMusical noteASupprimer = null;
    
    PartitionActionElementMusicalSupprimer(ElementMusical noteASupprimer)
    {
        this.noteASupprimer = noteASupprimer;
    }

    public void executer(PartitionDonnees partitionDonnees) {
        partitionDonnees.elementMusicalSupprimer(noteASupprimer);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        partitionDonnees.elementMusicalAjouter(noteASupprimer);
    }
}