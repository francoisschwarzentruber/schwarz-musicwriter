/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionSelectionAlterer extends PartitionActionActionComposee implements PartitionAction {

    PartitionActionSelectionAlterer(Selection selection, Hauteur.Alteration alteration)
    {
        for(Note note : selection.getNotes())
        {
                actionAjouter(new PartitionActionNoteAlterer(note, alteration));
        }
        
    }
    
}
