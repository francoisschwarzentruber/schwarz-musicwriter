/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionDureeChanger extends PartitionActionActionComposee
                                                implements PartitionAction {

    PartitionActionSelectionDureeChanger(Selection selection, Duree duree)
    {
        for(ElementMusical element : selection.getElementsMusicaux())
        {
            if(element instanceof ElementMusicalDuree)
            {
                 actionAjouter(new PartitionActionElementMusicalDureeChanger((ElementMusicalDuree) element, duree));
            }
        }

    }

}
