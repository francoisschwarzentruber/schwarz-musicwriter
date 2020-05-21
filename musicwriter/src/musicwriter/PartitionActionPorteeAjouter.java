/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionPorteeAjouter implements PartitionAction {
    private final Partie partie;
    private final int position;
    
    PartitionActionPorteeAjouter(int position, Partie partie)
    {
        this.position = position;
        this.partie = partie;
    }

    public void executer(PartitionDonnees partitionDonnees) {
        partitionDonnees.partieAjouter(position, partie);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        partitionDonnees.partieSupprimer(partie);
    }




}
