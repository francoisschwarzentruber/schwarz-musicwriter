/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

/**
 *
 * @author proprietaire
 */
interface MachineSortie {
   public void traiterNoteEnfoncee(Hauteur hauteur, int velocite, int tempsEnMilliSecondes, Instrument instrument);
   public void traiterNoteRelachee(Hauteur hauteur, int velocite, int tempsEnMilliSecondes, Instrument instrument);

   public void demarrer();
   public void arreter();
}
