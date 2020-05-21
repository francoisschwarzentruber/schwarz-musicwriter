/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
public class PartitionActionElementMusicalDureeChanger implements PartitionAction {
    private final Duree ancienne_duree;
    private final Duree nouvelle_duree;
    private final ElementMusicalDuree element;

    PartitionActionElementMusicalDureeChanger(ElementMusicalDuree element, Duree duree)
    {
        this.element = element;
        this.ancienne_duree = element.getDuree();
        this.nouvelle_duree = duree;
    }



    public void executer(PartitionDonnees partitionDonnees) {
        element.setDuree(nouvelle_duree);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        element.setDuree(ancienne_duree);
    }

}
