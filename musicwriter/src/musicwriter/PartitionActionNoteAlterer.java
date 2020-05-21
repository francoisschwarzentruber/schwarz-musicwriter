/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionNoteAlterer implements PartitionAction {

    Hauteur.Alteration alterationAncienne;
    Hauteur.Alteration alterationNouvelle;
    
    Note note = null;
    
    PartitionActionNoteAlterer(Note note, Hauteur.Alteration alteration)
    {
        this.alterationAncienne = note.getHauteur().getAlteration();
        this.alterationNouvelle = alteration;
        
        this.note = note;
        
    }
    
    
    public void executer(PartitionDonnees partitionDonnees) {
        note.getHauteur().setAlteration(alterationNouvelle);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        note.getHauteur().setAlteration(alterationAncienne);
    }

}
