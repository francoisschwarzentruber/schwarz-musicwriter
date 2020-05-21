/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionSupprimer extends PartitionActionActionComposee implements PartitionAction {

    PartitionActionSelectionSupprimer(Selection selection)
    {
        for(ElementMusical note : selection.getElementsMusicaux())
        {
            actionAjouter(new PartitionActionElementMusicalSupprimer(note));
        }
        
    }
    
}
