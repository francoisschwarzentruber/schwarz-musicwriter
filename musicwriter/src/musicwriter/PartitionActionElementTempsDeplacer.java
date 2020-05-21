/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
class PartitionActionElementTempsDeplacer implements PartitionAction {
    ElementMusical element = null;
    Moment debutMomentPasse = null;
    Moment debutMomentFutur = null;
    final PartitionActionElementMusicalAjouter
            partitionActionElementMusicalAjouterMomentFutur;
    
    PartitionActionElementTempsDeplacer(ElementMusical element, Duree dureeDeplacement)
    {
        this.element = element;
        
        debutMomentPasse = element.getDebutMoment();
        debutMomentFutur = dureeDeplacement.getFinMoment(debutMomentPasse);
        partitionActionElementMusicalAjouterMomentFutur = (new PartitionActionElementMusicalAjouter(element));
        
    }
    
    public void executer(PartitionDonnees partitionDonnees) {
        (new PartitionActionElementMusicalSupprimer(element)).executer(partitionDonnees);
        element.deplacer(debutMomentFutur);
        partitionActionElementMusicalAjouterMomentFutur.executer(partitionDonnees);
        //partitionDonnees.elementMusicalDeplacer(element, debutMomentFutur);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        partitionActionElementMusicalAjouterMomentFutur.executerInverse(partitionDonnees);
        element.deplacer(debutMomentPasse);
        (new PartitionActionElementMusicalAjouter(element)).executer(partitionDonnees);
    }

}
