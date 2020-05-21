/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author Ancmin
 */
public class PartitionActionSelectionNotesLierAuxSuivantes  extends PartitionActionActionComposee implements PartitionAction {

    PartitionActionSelectionNotesLierAuxSuivantes(Selection selection, boolean ouinon)
    {
        for(Note note : selection.getNotes())
        {
                actionAjouter(new PartitionActionNoteLierALaSuivante(note, ouinon));
        }

    }

}
