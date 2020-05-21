/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionNoteEnharmonique implements PartitionAction {

    Note note = null;
    Hauteur hauteurPassee = null;
    Hauteur hauteurFuture = null;
    
    
    PartitionActionNoteEnharmonique(Note note)
    {
        this.note = note;
        hauteurPassee = note.getHauteur();
        hauteurPassee.getNbDemiTonsParRapportAuDoCentral();
        
        Hauteur hauteur = new Hauteur(hauteurPassee.getNumero() + 1, Hauteur.Alteration.NATUREL);
        
        int diff = hauteurPassee.getNbDemiTonsParRapportAuDoCentral() - hauteur.getNbDemiTonsParRapportAuDoCentral();
        
        if(diff >= -2)
            hauteur.setAlteration(diff); 
        else
        {
            hauteur = new Hauteur(hauteurPassee.getNumero() - 2, Hauteur.Alteration.NATUREL);
            diff = hauteurPassee.getNbDemiTonsParRapportAuDoCentral() - hauteur.getNbDemiTonsParRapportAuDoCentral();
            
            if(diff <= 2)
                hauteur.setAlteration(diff);
            else
            {
                hauteur = new Hauteur(hauteurPassee.getNumero() - 1, Hauteur.Alteration.NATUREL);
                diff = hauteurPassee.getNbDemiTonsParRapportAuDoCentral() - hauteur.getNbDemiTonsParRapportAuDoCentral();
                hauteur.setAlteration(diff);
            }
        }
        
        
        
        hauteurFuture = hauteur;
    }
    
    public void executer(PartitionDonnees partitionDonnees) {
        note.setHauteur(hauteurFuture);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        note.setHauteur(hauteurPassee);
    }

}
