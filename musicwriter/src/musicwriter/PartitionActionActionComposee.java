/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.ArrayList;

/**
 *
 * @author proprietaire
 */
public class PartitionActionActionComposee implements PartitionAction {
    private ArrayList<PartitionAction> actions = new ArrayList<PartitionAction>();

    public void actionAjouter(PartitionAction action)
    {
        actions.add(action);
    }
    
    public void executer(PartitionDonnees partitionDonnees) {
        for(int i = 0; i < actions.size(); i++)
        {
            actions.get(i).executer(partitionDonnees);
        }
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        for(int i = actions.size() - 1; i >= 0 ; i--)
        {
            actions.get(i).executerInverse(partitionDonnees);
        }
    }
}
