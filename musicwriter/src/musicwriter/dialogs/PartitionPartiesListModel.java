/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter.dialogs;

import javax.swing.AbstractListModel;
import musicwriter.PartitionDonnees;

/**
 *
 * @author Ancmin
 */
class PartitionPartiesListModel extends AbstractListModel {
    private final PartitionDonnees partitionDonnees;

    public PartitionPartiesListModel(PartitionDonnees partitionDonnees) {
        this.partitionDonnees = partitionDonnees;
    }

    public int getSize() {
        return partitionDonnees.getParties().size();
    }

    public Object getElementAt(int index) {
        return partitionDonnees.getParties().get(index);
    }


}
