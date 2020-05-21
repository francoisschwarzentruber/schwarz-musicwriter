/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
class PartitionActionElementVoixSet implements PartitionAction {
    ElementMusicalSurVoix elementMusicalSurVoix = null;
    Voix nouvellevoix, anciennevoix;
    
    public PartitionActionElementVoixSet(ElementMusicalSurVoix elementMusicalSurVoix, Voix voix) {
        this.anciennevoix = elementMusicalSurVoix.getVoix();
        this.elementMusicalSurVoix = elementMusicalSurVoix;
        this.nouvellevoix = voix;
    }

    public void executer(PartitionDonnees partitionDonnees) {
        this.elementMusicalSurVoix.setVoix(nouvellevoix);
    }

    public void executerInverse(PartitionDonnees partitionDonnees) {
        this.elementMusicalSurVoix.setVoix(anciennevoix);
    }

}
