/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.Comparator;

/**
 * Cette classe sert à comparer deux affichages d'accords.
 * @author François Schwarzentruber
 */
class ComparatorAffichageAccord implements Comparator {

    public ComparatorAffichageAccord() {
    }

    public int compare(Object o1, Object o2) {
        AffichageAccord a1 = (AffichageAccord) o1;
        AffichageAccord a2 = (AffichageAccord) o2;
        
        int c = a1.getMomentDebut().compareTo(a2.getMomentDebut());
        if(c == 0)        
        {
            return a1.getVoix().compareTo(a2.getVoix());
        }
        return c;
    }

}
