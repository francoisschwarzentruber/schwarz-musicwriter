/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionElementMusicalAjouter implements PartitionAction {
    private ElementMusical noteAAjouter = null;
    private PartitionActionElementMusicalSupprimer partitionActionElementMusicalSupprimer = null;
    
    PartitionActionElementMusicalAjouter(ElementMusical noteAAjouter)
    {
        this.noteAAjouter = noteAAjouter;
    }



    private void enregistrerElementMusicalQuOnEcrasePuisSuppression(PartitionDonnees partitionDonnees, ElementMusical elementMusicalEcrase)
    {
        if(elementMusicalEcrase != null)
            {
               partitionActionElementMusicalSupprimer =
                    new PartitionActionElementMusicalSupprimer(elementMusicalEcrase);

               partitionActionElementMusicalSupprimer.executer(partitionDonnees);
            }
    }

    public void executer(PartitionDonnees partitionDonnees) {
        if(noteAAjouter.getClass().equals(ElementMusicalChangementTonalite.class)
           | noteAAjouter.getClass().equals(ElementMusicalChangementMesureSignature.class)
           | noteAAjouter.getClass().equals(ElementMusicalTempo.class) )
        {
            enregistrerElementMusicalQuOnEcrasePuisSuppression(partitionDonnees,
                    partitionDonnees.getElementMusical(noteAAjouter.getDebutMoment(),
                                noteAAjouter.getClass()));

        }
        else if(noteAAjouter.getClass().equals(ElementMusicalClef.class))
        {
           enregistrerElementMusicalQuOnEcrasePuisSuppression(
                   partitionDonnees,
                   partitionDonnees.getElementMusicalClefPileDessus(noteAAjouter.getDebutMoment(),
                                                         ((ElementMusicalClef) noteAAjouter).getPortee()));
        }


        partitionDonnees.elementMusicalAjouter(noteAAjouter);

    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        partitionDonnees.elementMusicalSupprimer(noteAAjouter);
        if(partitionActionElementMusicalSupprimer != null)
        {
            partitionActionElementMusicalSupprimer.executerInverse(partitionDonnees);
        }
    }
}
