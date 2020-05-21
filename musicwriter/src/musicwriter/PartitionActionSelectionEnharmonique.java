/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionEnharmonique extends PartitionActionActionComposee implements PartitionAction {

    PartitionActionSelectionEnharmonique(Selection selection)
    {
        for(Note note : selection.getNotes())
        {
            actionAjouter(new PartitionActionNoteEnharmonique(note));
        }
        
    }
    

}
