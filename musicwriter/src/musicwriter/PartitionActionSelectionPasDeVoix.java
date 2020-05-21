/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionPasDeVoix extends PartitionActionActionComposee
                                                implements PartitionAction {
    PartitionActionSelectionPasDeVoix(Selection selection)
    {
        for(ElementMusical element : selection.getElementsMusicaux())
        {
            if(element instanceof ElementMusicalSurVoix)
            {
                actionAjouter(new PartitionActionElementVoixSet(((ElementMusicalSurVoix) element), new Voix()));
            }
            
        }
        
    }
}
