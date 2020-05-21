/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionPorteeChanger extends PartitionActionActionComposee implements PartitionAction {

    PartitionActionSelectionPorteeChanger(PartitionDonnees partitionDonnees, Selection selection, int porteeChangement)
    {
        for(ElementMusicalSurPortee note : selection.getElementsMusicauxSurPortee())
        {
            actionAjouter(new PartitionActionElementMusicalPorteeChanger(partitionDonnees, note, porteeChangement));
        }
        
    }

}
