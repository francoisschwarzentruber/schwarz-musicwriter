/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.Stack;

/**
 *
 * @author proprietaire
 */
public class Histoire {
    Stack<PartitionAction> actionsPassees = new Stack<PartitionAction>();
    Stack<PartitionAction> actionsFutures = new Stack<PartitionAction>();
    PartitionDonnees partitionDonnees = null;
    private PartitionVue partitionVue;
    
    Histoire(PartitionDonnees partitionDonnees,
             PartitionVue partitionVue)
    {
        this.partitionDonnees = partitionDonnees;
        this.partitionVue = partitionVue;
    }
    
    
    public void executer(PartitionAction action)
    {
        action.executer(partitionDonnees);
        actionsPassees.push(action);
        actionsFutures = new Stack<PartitionAction>();
    }
    
    
    
    public boolean isAnnulerPossible()
    {
        return !actionsPassees.isEmpty();
    }
    
    
    
    public boolean isRefairePossible()
    {
        return !actionsFutures.isEmpty();
    }
    
    
    
    public void annulerLaDerniereAction()
    {
        PartitionAction action = actionsPassees.pop();
        action.executerInverse(partitionDonnees);
        actionsFutures.push(action);
        partitionVue.calculer();
    }
    
    
    public void refaireLaDerniereAction()
    {
        PartitionAction action = actionsFutures.pop();
        action.executer(partitionDonnees);
        actionsPassees.push(action);
        partitionVue.calculer();
        
    }
    

}
