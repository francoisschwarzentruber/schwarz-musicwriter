/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionElementMusicalPorteeChanger implements PartitionAction {
    private ElementMusicalSurPortee note;

    private int debutPorteeNumero = 0;
    private int finPorteeNumero = 0;
    
    PartitionActionElementMusicalPorteeChanger(PartitionDonnees partitionDonnees, ElementMusicalSurPortee note, int porteeChangement)
    {
        this.note = note;
        
        debutPorteeNumero = note.getPortee().getNumeroAffichage();
        finPorteeNumero = debutPorteeNumero + porteeChangement;
        
        if(finPorteeNumero < 0)
        {
            finPorteeNumero = 0;
        }
        else if (finPorteeNumero > partitionDonnees.getPorteesNombre()-1)
        {
            finPorteeNumero = partitionDonnees.getPorteesNombre()-1;
        }

    }
    
    
    
    public void executer(PartitionDonnees partitionDonnees) {
        this.note.setPortee(partitionDonnees.getPortee(finPorteeNumero));
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        this.note.setPortee(partitionDonnees.getPortee(debutPorteeNumero));
    }

}
