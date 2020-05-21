/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author proprietaire
 */
public class PartitionScribe {
    
    private PartitionDonnees partitionDonnees = null;
    private PartitionPanel partitionPanel = null;
    private Set<Note> notesQuiDurent = new HashSet<Note>();
    
    long tempsEnMilliSecondesAvant = -10000;
    private final PartitionLecteur partitionLecteur;
    
    
    PartitionScribe(PartitionDonnees partitionDonnees, PartitionPanel partitionPanel, PartitionLecteur partitionLecteur)
    {
        this.partitionDonnees = partitionDonnees;
        this.partitionPanel = partitionPanel;
        this.partitionLecteur = partitionLecteur;

        this.partitionPanel.setPartitionScribe(this);
    }
    
    
    
    private Moment getMoment(long tempsEnMilliSecondes)
    {
         return (new Duree(tempsEnMilliSecondes, partitionDonnees.getNbNoiresParMinute(partitionDonnees.getMomentDebut()))).getFinMoment(partitionDonnees.getMomentDebut());
    }
    


    private Moment getMoment()
    {
        Moment momentRecu = partitionLecteur.momentActuelGet();
        return new Duree(200, partitionDonnees.getNbNoiresParMinute(momentRecu)).getDebutMoment(momentRecu);
    }

     public void traiterNoteEnfoncee(Hauteur hauteur, int velocite, long tempsEnMilliSecondes) {
       //     System.out.println("traiterNoteEnfoncee appelée : " + hauteur.toString() + "," +
       //                         " velocité : " + String.valueOf(velocite));

            

            if(Math.abs(tempsEnMilliSecondesAvant - tempsEnMilliSecondes) < 50)
                tempsEnMilliSecondes = tempsEnMilliSecondesAvant;
            
            if(getNoteQuiPerdure(hauteur) != null)
                return;

            Portee porteeDansLaQuelleJEcris = null;
            if(hauteur.isPlusGrave(new Hauteur(0, Hauteur.NoteNom.DO, Hauteur.Alteration.NATUREL)))
            {
                porteeDansLaQuelleJEcris = partitionDonnees.getPortee(1);
            }
            else
            {
                 porteeDansLaQuelleJEcris = partitionDonnees.getPortee(0);
            }
            
            Note note = new Note(getMoment(),
                                                   new Duree(0, 1), 
                                                   hauteur,
                                                   porteeDansLaQuelleJEcris);
                    
            notesQuiDurent.add(note);
            partitionDonnees.elementMusicalAjouter(note);

            partitionPanel.calculer(note.getDebutMoment());
           partitionPanel.repaint();
        
           tempsEnMilliSecondesAvant = tempsEnMilliSecondes;
        }

    
    private Note getNoteQuiPerdure(Hauteur hauteur)
    {
          for(Note n : notesQuiDurent)
          {
              if(n.getHauteur().isEgale(hauteur))
              {
                  return n;
              }
          }
          
          return null;
    }
    
    
    
    
    public void traiterNoteRelachee(Hauteur hauteur, int velocite, long tempsEnMilliSecondes) {
        Moment momentactuel = getMoment();

        Note noteAArreter = getNoteQuiPerdure(hauteur);
        notesQuiDurent.remove(noteAArreter);
       // System.out.println("traiterNoteRelachee appelée : " + hauteur.toString());
        if(noteAArreter == null)
        {
            System.out.println("Erreur dans traiterNoteRelachee : je ne trouve pas la note que tu veux arrêter");
        }
        else
        {
            noteAArreter.setFinMoment(momentactuel);
            noteAArreter.setDureeVague();
            //partitionPanel.calculer(noteAArreter.getDebutMoment());
            partitionPanel.repaint();
            
        }
        
        
    }
    
    
    
    
}
