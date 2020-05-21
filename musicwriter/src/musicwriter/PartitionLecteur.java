/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;


import java.util.ArrayList;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.SwingUtilities;


/**
 *
 * @author François Schwarzentruber
 * 
 * PartitionLecteur s'occupe de lire la partition passée en entrée
 * et d'appeler les méthodes traiterNoteEnfoncee et 
 * traiterNoteRelachee d'une machine machineSortie.
 * 
 * Par exemple, PartitionLecteur est le pont entre la partition et une machine
 * de sortie qui joue les notes avec l'interface MIDI.
 */
public class PartitionLecteur extends Thread {

    private MusicwriterView view = null;
    private PartitionDonnees partitionALire = null;
    private MachineSortie machineSortie = null;
    private final PartitionPanel partitionPanel;
    private boolean isArretDemande = false;
    private boolean isEnPause = false;
    private Moment momentActuelBut = null;
    private Moment momentActuelSuivi = null;
    private double vitesse = 1.0;

    private ArrayList<Note> notesANePasRejouer = new ArrayList<Note>();
    private boolean arretFinPartition = true;
    
    
    PartitionLecteur(
                     PartitionDonnees partitionALire,
                     Moment momentDebut,
                     MachineSortie machineSortie,
                     PartitionPanel partitionPanelA,
                     MusicwriterView view)
    {
        this.partitionALire = partitionALire;
        this.machineSortie = machineSortie;
        this.partitionPanel = partitionPanelA;
        this.isArretDemande = false;
        this.momentActuelSuivi = momentDebut;
        this.momentActuelBut = momentDebut;
        this.view = view;

        final PartitionLecteur partitionLecteur = this;
            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
                    partitionPanel.setPartitionLecteur(partitionLecteur);
                }
            });
    }

    public void pause() {
        isEnPause = true;
    }

    
    public void reprendre() {
        isEnPause = false;
    }
    
    
    
    private void attendre(Moment momentdebut, Duree duree) {
        int nbNoiresParMinute = getPartitionDonnees().getNbNoiresParMinute(momentdebut);
        long nbmillisecondes_a_attendre = Math.round(duree.getNbMilliSecondes(nbNoiresParMinute));
        long tare = System.currentTimeMillis();

        partitionPanel.setPartitionLecteur(this);
        while(((System.currentTimeMillis() - tare) * vitesse < nbmillisecondes_a_attendre) && !isArretDemande)
        {
            Duree dureeactuelsuivi = new Duree((long) ((System.currentTimeMillis() - tare) * vitesse), nbNoiresParMinute);
            momentActuelSuivi = new Moment(momentdebut.getRational().plus(dureeactuelsuivi.getRational()));
            try {
                sleep(10);
            } catch (InterruptedException ex) {
                Logger.getLogger(PartitionLecteur.class.getName()).log(Level.SEVERE, null, ex);
            }

            
            SwingUtilities.invokeLater(new Runnable() {
                public void run() {
                    partitionPanel.repaint();
                }
            });
             

        }
    }
    
    
    
    private void fireNoteEnfoncee(Hauteur hauteur, int velocite, int tempsEnMilliSecondes, Instrument instrument)
    {
        machineSortie.traiterNoteEnfoncee(hauteur, velocite, tempsEnMilliSecondes, instrument);
    }
    
    
    
    private void fireNoteRelachee(Hauteur hauteur, int velocite, int tempsEnMilliSecondes, Instrument instrument)
    {
        machineSortie.traiterNoteRelachee(hauteur, velocite, tempsEnMilliSecondes, instrument);
    }
    
    
    
    
    
    
    public void setMomentActuel(Moment momentactuel)
    {
        momentRelacherNotes(this.momentActuelBut);
        this.momentActuelBut = momentactuel;
        this.momentActuelSuivi = momentactuel;
    }
    
    
    public Moment momentActuelGet()
    {
        return momentActuelSuivi;
    }
    
    
    private void momentRelacherNotes(Moment momentactuel)
    {
        Set<Note> notesQuiSontRelachees = partitionALire.getMomentNotesSurLeFeu(momentactuel).getNotesQuiSontRelachees();
        notesRelacher(notesQuiSontRelachees);
    }
    
    private void traiterNotes(Moment momentactuel) {
        Set<Note> notesAJouer = partitionALire.getMomentNotesSurLeFeu(momentactuel).getNotesAJouer();
        momentRelacherNotes(momentactuel);
        notesEnfoncer(notesAJouer);

        
    }
    
    @Override
    public void run()
            //ceci est le programme pour lire une partition
    {
        machineSortie.demarrer();
        
        
        Moment momentprecedent = momentActuelBut;
        
        for(;
            (momentActuelBut != null) && (!isArretDemande);
            momentActuelBut = partitionALire.getMomentSuivant(momentActuelBut))
        {

            attendre(momentprecedent,
                     new Duree(momentprecedent,
                               momentActuelBut)
                     );
            
            if(isArretDemande)
                break;
            
            
            while(isEnPause) {}
            
            traiterNotes(momentActuelBut);
            
            momentprecedent = momentActuelBut; 
        }


        if(!arretFinPartition)
        {
            attendre(momentprecedent,
                     new Duree(new Rational(1000000, 1)));
        }

        
        
        arreter();
        
    }

    private void notesEnfoncer(Set<Note> notesAJouer) {
        for(Note noteAJouer : notesAJouer)
        {
            if(!isNoteQuiSuitUneLieeALaSuivante(noteAJouer))
                 fireNoteEnfoncee(noteAJouer.getHauteurEntendue(),
                             64,
                             0,
                             noteAJouer.getPortee().getPartie().getInstrument());
                             //noteAJouer.getDebutMoment().getNbMillisecondesDepuisDebut());
        }
    }

    private void notesRelacher(Set<Note> notesQuiSontRelachees) {
        for(Note noteQuiEstRelachee : notesQuiSontRelachees)
        {
            if(!noteQuiEstRelachee.isLieeALaSuivante())
            {
                 fireNoteRelachee(noteQuiEstRelachee.getHauteurEntendue(),
                             64,
                             0,
                             noteQuiEstRelachee.getPortee().getPartie().getInstrument());
                             //noteQuiEstRelachee.getDebutMoment().getNbMillisecondesDepuisDebut());
            }
            else
            {
                notesANePasRejouer.add(noteQuiEstRelachee);
            }
        }
    }

    
    
    
    public void arreter()
    {
        if(isArretDemande)
            return;

        machineSortie.arreter();
        partitionPanel.lectureArreter();
        notesANePasRejouer = new ArrayList();
        isArretDemande = true;
        isEnPause = false;
        view.midiStop();
    }



    public void setPasArretFinPartition()
    {
        arretFinPartition = false;
    }

    void setVitesse(double vitesse) {
        this.vitesse = vitesse;
    }

    private PartitionDonnees getPartitionDonnees() {
        return partitionALire;
    }

    private boolean isNoteQuiSuitUneLieeALaSuivante(Note noteAJouer) {
        for(Note noteANePasReJouer : notesANePasRejouer)
        {
            if(noteANePasReJouer.getVoix().equals(noteAJouer.getVoix()) &
               noteANePasReJouer.getHauteur().equals(noteAJouer.getHauteur())  )
            {
                notesANePasRejouer.remove(noteANePasReJouer);
                return true;
            }
        }
        return false;
    }
    
}
