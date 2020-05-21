/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSilenceDeplacerHauteur implements PartitionAction {

    Silence silence = null;
    Hauteur hauteurPassee = null;
    Hauteur hauteurFuture = null;
    
    
    PartitionActionSilenceDeplacerHauteur(Silence silence, Intervalle intervalle)
    {
        this.silence = silence;
        hauteurPassee = silence.getHauteur();
        hauteurFuture = intervalle.getHauteur2(hauteurPassee);
    }
    
    public void executer(PartitionDonnees partitionDonnees) {
        silence.setHauteur(hauteurFuture);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        silence.setHauteur(hauteurPassee);
    }

}
