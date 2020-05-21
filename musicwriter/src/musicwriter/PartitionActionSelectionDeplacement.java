/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionDeplacement extends PartitionActionActionComposee
                                                implements PartitionAction {
    
    
    PartitionActionSelectionDeplacement(PartitionDonnees partitionDonnees, Selection selection, Intervalle intervalle, Duree dureedeplacement, int porteeChangement)
    {
        super();
        actionAjouter(new PartitionActionSelectionDeplacerHauteur(selection, intervalle));
        actionAjouter( new PartitionActionSelectionTempsDeplacer(selection, dureedeplacement));
        actionAjouter(new PartitionActionSelectionPorteeChanger(partitionDonnees, selection, porteeChangement));

    }
    

                
}
