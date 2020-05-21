/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionPaste extends PartitionActionActionComposee {
   PartitionActionPaste(Selection selection)
   {
       for(ElementMusical element : selection.getElementsMusicaux())
        {
                actionAjouter(new PartitionActionElementMusicalAjouter(element));
        }
   }
}
