/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionVoixSet extends PartitionActionActionComposee
                                                implements PartitionAction {
    PartitionActionSelectionVoixSet(Selection selection, Voix voix)
    {
        for(ElementMusical element : selection.getElementsMusicaux())
        {
            if(element instanceof ElementMusicalSurVoix)
            {
                actionAjouter(new PartitionActionElementVoixSet(((ElementMusicalSurVoix) element), voix));
            }
            
        }
        
    }
}
