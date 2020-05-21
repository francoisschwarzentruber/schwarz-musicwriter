/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 *
 * @author Ancmin
 */
public class AffichageLectureBarre {

    private final PartitionVue partitionVue;
    private Moment moment = null;
    private Color couleur;

    AffichageLectureBarre(PartitionVue partitionVue) {
        this.partitionVue = partitionVue;
        setLectureBarre();
    }

    void setMoment(Moment momentActuelGet) {
        this.moment = momentActuelGet;
    }



    void setLectureBarre()
    {
        couleur = new Color(0, 222, 0);
    }

    void setEnregistrementLectureBarre()
    {
        couleur = new Color(255, 0, 0);
    }



    void draw(Graphics2D g) {
        MomentNotesSurLeFeu momentNotesSurLeFeu = getPartitionDonnees().getMomentNotesSurLeFeu(moment);

        Set<Note> notesQuiPerdurent = momentNotesSurLeFeu.getNotesQuiPerdurent();
        courbeDessiner(g, notesQuiPerdurent);
        notesJoueesSurImprimer(g, notesQuiPerdurent);

        
    }


    


    private PartitionDonnees getPartitionDonnees() {
        return partitionVue.getPartitionDonnees();
    }

    private void notesJoueesSurImprimer(Graphics2D g, Set<Note> notesQuiPerdurent) {
        for(ElementMusical note : notesQuiPerdurent)
        {
            ((AffichageNote) partitionVue.getAffichageElementMusical(note))
                    .dessinerFleur(g, moment);
        }
    }

    private void courbeDessiner(Graphics2D g, Set<Note> notesQuiPerdurent) {

        g.setColor(couleur);
        g.setStroke(new BasicStroke(2.5f));

        
        SortedSet<Note> notes = new TreeSet<Note>(new ComparatorNoteHauteurPortee());
        notes.addAll(notesQuiPerdurent);
        Systeme systeme = partitionVue.getSysteme(moment);

        if(systeme == null)
        {
            Erreur.message("AffichageLectureBarre : courbeDessiner, pas de système");
            return;
        }

        if(notes.isEmpty())
            systeme.afficherBarre(g, moment);
        else
        {
            ControlCurve p = new NatCubic();

            double yavant = systeme.getYBas()+50;
            for(Note n : notes)
            {
               AffichageNote a = ((AffichageNote) partitionVue.getAffichageElementMusical(n));

               if(a == null)
               {
                   Erreur.message("AffichageLectureBarre : courbeDessiner, pas d'affichage pour un élement musical");
                   return;
               }
               if(yavant == systeme.getYBas()+50)
               if(yavant >  a.getNoteCentreY())
                   p.addPoint((int) systeme.getXNotes(moment), (int) (yavant + a.getNoteCentreY()) / 2 );

               if(n.getDuree().isStrictementInferieur(new Duree(new Rational(2, 1))))
                    p.addPoint( (int) a.getX(), (int)  a.getNoteCentreY());
               else
                    p.addPoint( (int) systeme.getXNotes(moment), (int)  a.getNoteCentreY());
               yavant = a.getNoteCentreY();
            }

            if(yavant > systeme.getYHaut()-50)
                 p.addPoint( (int) systeme.getXNotes(moment),  (int) (systeme.getYHaut()-50 + yavant) / 2);

            p.paint(g);
        }
    }

}
