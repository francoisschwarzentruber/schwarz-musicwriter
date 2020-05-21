/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
class PartitionActionSelectionTempsDeplacer  extends PartitionActionActionComposee
                                                implements PartitionAction {

    
    
    public PartitionActionSelectionTempsDeplacer(Selection selection, Duree dureeDeplacement) {
        for(ElementMusical note : selection.getElementsMusicaux())
            {
                actionAjouter(new PartitionActionElementTempsDeplacer(note, dureeDeplacement));
            }
    
    
    }

}
