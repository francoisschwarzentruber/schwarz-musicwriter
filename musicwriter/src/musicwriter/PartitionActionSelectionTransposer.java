/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionTransposer extends PartitionActionActionComposee
                                                implements PartitionAction {

    PartitionActionSelectionTransposer(Selection selection, Intervalle intervalle)
    {
        for(Note note : selection.getNotes())
        {
            actionAjouter(new PartitionActionNoteTransposer(note, intervalle));
        }
        
    }
    

}
