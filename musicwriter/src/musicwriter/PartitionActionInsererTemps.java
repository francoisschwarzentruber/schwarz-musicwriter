/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author Ancmin
 */
public class PartitionActionInsererTemps implements PartitionAction {
    private final Moment momentAvant;
    private final Moment momentNouveau;

    PartitionActionInsererTemps(Moment moment, Moment nouveauMoment)
    {
        momentAvant = moment;
        momentNouveau = nouveauMoment;
    }


    public void executer(PartitionDonnees partitionDonnees) {

        Duree d = new Duree(momentAvant, momentNouveau);
        for(ElementMusical e : partitionDonnees.getSelectionToutApresMoment(momentAvant))
        {
            partitionDonnees.elementMusicalDeplacer(e, d.getFinMoment(e.getDebutMoment() ));
        }
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        Duree d = new Duree(momentAvant, momentNouveau);
        for(ElementMusical e : partitionDonnees.getSelectionToutApresMoment(momentNouveau))
        {
            partitionDonnees.elementMusicalDeplacer(e, d.getDebutMoment(e.getDebutMoment() ));
        }
    }

}
