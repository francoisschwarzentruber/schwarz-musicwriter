/*
 * PartitionPanel.java
 *
 * Created on 2 septembre 2008, 17:45
 */

package musicwriter;

import musicwriter.dialogs.MesureSignatureChangementDialog;
import musicwriter.dialogs.TonaliteDialog;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Point;
import java.awt.Polygon;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import musicwriter.dialogs.ClefDialog;
import musicwriter.dialogs.TempoDialog;
import org.jdesktop.application.Action;

/**
 *
 * @author  proprietaire
 */
public class PartitionPanel extends javax.swing.JPanel {

    private PartitionVue partitionVue = null;
    StyloEsquisse styloEsquisse = null;
    Selection selection = null;
    Set<Polygon> selectionPolygones = null;

    private ElementMusical sourisCurseurNote = null;
    
    private NotesDeplacementSouris notesDeplacementSouris = null;
    private PartitionLecteur partitionLecteur = null;
    private PartitionScribe partitionScribe = null;

    private Duree curseurNoteDuree = new Duree(new Rational(1, 1));
    private Curseur curseurSouris = null;
    private Moment curseurSourisMomentBarre = null;
    private MachineSortie machineSortie = null;
    private AffichageLectureBarre affichageLectureBarre = null;


    
    public Curseur getCurseurSouris() {
        return curseurSouris;
    }
    
    
    public Moment getCurseurSourisMomentBarre()
    {
        return curseurSourisMomentBarre;
    }
    

    void calculer() {
        partitionVue.calculer();
        selectionAffichageCalculer();
        repaint();
    }
    
    
    
    void calculer(Moment aPartirDuMoment) {
        partitionVue.calculer(aPartirDuMoment);
        selectionAffichageCalculer();
        repaint();
    }
    
    
    public void dureeEntreeTraiter(Duree d)
    {
        curseurNoteDuree = d;

        if(isSelection())
        {
            histoire.executer(new PartitionActionSelectionDureeChanger(selection, d));
            calculer();
        }
        repaint();
    }


    public void setCurseurSourisDuree(Duree d)
    {
        curseurNoteDuree = d;
        repaint();
    }


    public void selectionElementsMusicauxDureeSet(Duree d)
    {
        if(isSelection())
        {
            histoire.executer(new PartitionActionSelectionDureeChanger(selection, d));
            calculer();
        }
        repaint();
    }



    void setSelection(Selection selection) {
        if(selection.isVide())
        {
            return;
        }
        else
        {
            this.selection = selection;
            this.selectionPolygones = getSelectionArea(selection);
            selectionEntamer();
        }
    }


    private void selectionAffichageCalculer()
    {
        this.selectionPolygones = getSelectionArea(selection);
    }

    
    private Set<Polygon> getSelectionArea(Selection selection)
    {
        Set<Polygon> polygons = new HashSet<Polygon>();

        if(selection != null)
            for(ElementMusical el : selection)
            {
                AffichageElementMusical aem = partitionVue.getAffichageElementMusical(el);

                if(aem == null)
                {
                    System.out.println("getSelectionArea : partitionVue.getAffichageElementMusical(el) == null");
                    return polygons;
                }

                Rectangle r = aem.getRectangle();
                r.grow(12, 8);
                Polygon p = new Polygon();
                p.addPoint((int) r.getMinX(), (int) r.getMinY());
                p.addPoint((int) r.getCenterX(), (int) r.getMinY() - 8);
                p.addPoint((int) r.getMaxX(), (int) r.getMinY());
                p.addPoint((int) r.getMaxX(), (int) r.getMaxY());
                p.addPoint((int) r.getCenterX(), (int) r.getMaxY() + 8);
                p.addPoint((int) r.getMinX(), (int) r.getMaxY());

                polygons.add(p);
            }
            
        return polygons;
        
    }

    private void drawSelectionFond(Graphics2D g) {
        g.setColor(new Color(1.0f,0.7f,0.7f));
        
        if(selectionPolygones != null)
        {
            for(Polygon p : selectionPolygones)
            {
                g.fillPolygon(p);
            }
        }
    }

    public PartitionDonnees getPartitionDonnees() {
        return partitionVue.getPartitionDonnees();
    }

    private PartitionVue getPartitionVue() {
        return partitionVue;
    }

    void setMachineSortieMIDI(MachineSortie machineSortieMIDI) {
        this.machineSortie = machineSortieMIDI;
    }

    private void dessinerSelection(Graphics2D g) {
        if(isSelection())
        {
            if(notesDeplacementSouris == null)
            {
                g.setColor(Color.RED);
                g.setStroke(new BasicStroke(2));
            }
            else
            {
                g.setColor(Color.GRAY);
                g.setStroke(new BasicStroke(1));
            }
            partitionVue.afficherSelection(g, selection);
        }
    }
    
    
    class NotesDeplacementSouris
    {
        private final Curseur referenceCurseur;
        private final Selection selection;
        private Curseur referenceCurseurFutur = null;





        
        
        NotesDeplacementSouris(Curseur referenceCurseur, Selection selection)
        {
            this.referenceCurseur = referenceCurseur;
            this.referenceCurseurFutur = referenceCurseur;
            this.selection = selection;
        }



        private Selection getSelection() {
            return selection;
        }
        
        
        public void setReferenceCurseurFutur(Curseur referenceCurseurFutur)
        {
            this.referenceCurseurFutur = referenceCurseurFutur;
        }
        
        
        
        public Intervalle getIntervalle()
        {
            return new Intervalle(this.referenceCurseur.getHauteur(),
                                  this.referenceCurseurFutur.getHauteur());
        }
        
        
        public Duree getDureeDeplacement()
        {
            return new Duree(this.referenceCurseur.getMoment(),
                             this.referenceCurseurFutur.getMoment());
        }
        
        
        
        public int getPorteeDeplacement()
        {
            return this.referenceCurseurFutur.getPortee().getNumeroAffichage()
                        - this.referenceCurseur.getPortee().getNumeroAffichage();
        }

        
        private void effectuer() {
            if(!isTrivial())
            {
                histoire.executer(
                        new PartitionActionSelectionDeplacement(partitionVue.getPartitionDonnees(),
                        getSelection(), getIntervalle(), getDureeDeplacement(), getPorteeDeplacement()));
                calculer();
            }
        }
        
        
        private void effectuerCopie() {
            if(!isTrivial())
            {
                Selection selectionFutur = getSelectionFutur();
                histoire.executer(
                        new PartitionActionPaste( selectionFutur ));
                calculer();
            }
        }
        
        
        private Selection getSelectionFutur()
        {
            Selection selectionfutur = new Selection();
            
            Intervalle intervalle = getIntervalle();
            Duree dureeDeplacement = getDureeDeplacement();

            
            for(ElementMusical el : getSelection().getElementsMusicaux())
            {
                ElementMusical elnouveau = (ElementMusical) el.clone();
                
                if(elnouveau instanceof Note)
                {
                    Note note = (Note) elnouveau;
                    note.setHauteur(intervalle.getHauteur2(note.getHauteur()));
                }
                
                
                if(elnouveau instanceof Silence)
                {
                    Silence note = (Silence) elnouveau;
                    note.setHauteur(intervalle.getHauteur2(note.getHauteur()));
                }

                if(elnouveau instanceof ElementMusicalSurPortee)
                {
                    PartitionActionElementMusicalPorteeChanger a =
                        new PartitionActionElementMusicalPorteeChanger(
                              partitionVue.getPartitionDonnees(),
                              (ElementMusicalSurPortee) elnouveau,
                              getPorteeDeplacement()); 
                    
                    a.executer(partitionVue.getPartitionDonnees());
                }
                
                
                
                elnouveau.deplacer(dureeDeplacement
                                        .getFinMoment(el.getDebutMoment()));
                
                selectionfutur.ajouterElementMusical(elnouveau);
                
                
                
                
            }
            
            return selectionfutur;
            
            
        }
        
        
        
        public void afficher(Graphics2D g)
        {
            g.setColor(Color.RED);
            g.setStroke(new BasicStroke(2));
            partitionVue.afficherSelectionDehors(g, getSelectionFutur());
        }
        
        

        private boolean isTrivial() {
            return getIntervalle().isNull() && 
               getDureeDeplacement().isZero() &&
               (getPorteeDeplacement() == 0);
        }
    }
            
    
    
    public void setSourisCurseurNote(ElementMusical note)
    {
        sourisCurseurNote = note;
    }
    
    public void sourisCurseurNoteAucune()
    {
        sourisCurseurNote = null;
        
    }
    
    
    public void sourisCurseurNoteAfficher(Graphics2D g)
    {
        if(sourisCurseurNote != null)
        {
            g.setColor(Color.GRAY);
            partitionVue.afficherElementMusicalDehors(g, sourisCurseurNote);
        }
            
    }
    
    
    private Histoire histoire = null;
    private MusicwriterView fenetrePrincipale;
    
     
     public void modifierSourisCurseur(String img, Point hotSpot){
         //recupere le Toolkit
         Toolkit tk = Toolkit.getDefaultToolkit();
         //sur ce dernier lire le fichier avec "getClass().getRessource" pour
         //pouvoir l'ajouter a un .jar
         Image image= tk.getImage(getClass().getResource(img));
         //modifi le curseur avec la nouvelle image,en le posissionant grace hotSpot
         //et en lui donnant le nom "X"
         Cursor c = tk.createCustomCursor(image,hotSpot,"X");
         //puis on l'associe au Panel
         setCursor(c);
     }
     
     
     
     public Selection getSelection()
     {
         if(selection == null)
         {
             Erreur.message("Tu veux une sélection alors qu'il n'y en a pas ?");
             return new Selection();
         }
         else
             return selection;
     }
     
     
     public boolean isSelection()
     {
         if(selection == null)
             return false;
         else
             return !selection.isVide();
     }
     
     
     public void selectionAbandonner()
     {
         selection = null;
         selectionPolygones = null;
         fenetrePrincipale.modeEcriture();
     }
     
     
     
     public void selectionEntamer()
     {
         fenetrePrincipale.modeSelection();
         
     }
     
     
     public void modifierSourisCurseurCrayon()
     {
         modifierSourisCurseur("resources/crayon.png", new Point(2, 30));
     }

     public void modifierSourisCurseurGomme()
     {
         modifierSourisCurseur("resources/gomme.png", new Point(8, 26));
     }  
     
     
     public void modifierSourisCurseurMain()
     {
         modifierSourisCurseur("resources/main.png", new Point(4, 0));
     } 
     
     
     public void modifierSourisCurseurMainAbandonner()
     {
         modifierSourisCurseur("resources/mainabandonner.png", new Point(4, 0));
     } 
     
     public void modifierSourisCurseurLecturePosition()
     {
         modifierSourisCurseur("resources/curseur_lecture_position.png", new Point(4, 2));
     }
    
    /** Creates new form PartitionPanel */
    public PartitionPanel(MusicwriterView fenetrePrincipale, PartitionVue partitionVue, Histoire histoire) {
        initComponents();
        this.fenetrePrincipale = fenetrePrincipale;
        setPartitionVueEtHistoire(partitionVue, histoire);
        affichageLectureBarre = new AffichageLectureBarre(partitionVue);
        modifierSourisCurseurCrayon();
    }
    
    
    
    public void setPartitionVueEtHistoire(PartitionVue partitionVue, Histoire histoire)
    {
        this.partitionVue = partitionVue;
        affichageLectureBarre = new AffichageLectureBarre(partitionVue);
        this.histoire = histoire;
    }        

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPopupMenu1 = new javax.swing.JPopupMenu();
        mnuLecture = new javax.swing.JMenuItem();
        mnuTempsInserer = new javax.swing.JMenuItem();
        mnuTempsSupprimer = new javax.swing.JMenuItem();
        mnuClefInserer = new javax.swing.JMenuItem();
        mnuInsererChangementTonalite = new javax.swing.JMenuItem();
        mnuMesure = new javax.swing.JMenu();
        mnuMesureCorriger = new javax.swing.JMenuItem();
        mnuMesureSignatureChanger = new javax.swing.JMenuItem();
        mnuInsererTempo = new javax.swing.JMenuItem();
        mnuNotes = new javax.swing.JMenu();
        mnuNotesLierAuxSuivantes = new javax.swing.JMenuItem();
        mnuNotesNePasLierAuxSuivantes = new javax.swing.JMenuItem();
        mnuSelection = new javax.swing.JMenu();
        jMenuItem2 = new javax.swing.JMenuItem();

        jPopupMenu1.setComponentPopupMenu(jPopupMenu1);
        jPopupMenu1.setName("jPopupMenu1"); // NOI18N

        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getResourceMap(PartitionPanel.class);
        mnuLecture.setIcon(resourceMap.getIcon("mnuLecture.icon")); // NOI18N
        mnuLecture.setText(resourceMap.getString("mnuLecture.text")); // NOI18N
        mnuLecture.setName("mnuLecture"); // NOI18N
        mnuLecture.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuLectureActionPerformed(evt);
            }
        });
        jPopupMenu1.add(mnuLecture);

        javax.swing.ActionMap actionMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getActionMap(PartitionPanel.class, this);
        mnuTempsInserer.setAction(actionMap.get("tempsInserer")); // NOI18N
        mnuTempsInserer.setIcon(resourceMap.getIcon("mnuTempsInserer.icon")); // NOI18N
        mnuTempsInserer.setText(resourceMap.getString("mnuTempsInserer.text")); // NOI18N
        mnuTempsInserer.setName("mnuTempsInserer"); // NOI18N
        jPopupMenu1.add(mnuTempsInserer);

        mnuTempsSupprimer.setIcon(resourceMap.getIcon("mnuTempsSupprimer.icon")); // NOI18N
        mnuTempsSupprimer.setText(resourceMap.getString("mnuTempsSupprimer.text")); // NOI18N
        mnuTempsSupprimer.setName("mnuTempsSupprimer"); // NOI18N
        mnuTempsSupprimer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuTempsSupprimerActionPerformed(evt);
            }
        });
        jPopupMenu1.add(mnuTempsSupprimer);

        mnuClefInserer.setAction(actionMap.get("clefInserer")); // NOI18N
        mnuClefInserer.setIcon(resourceMap.getIcon("mnuClefInserer.icon")); // NOI18N
        mnuClefInserer.setText(resourceMap.getString("mnuClefInserer.text")); // NOI18N
        mnuClefInserer.setName("mnuClefInserer"); // NOI18N
        jPopupMenu1.add(mnuClefInserer);

        mnuInsererChangementTonalite.setIcon(resourceMap.getIcon("mnuInsererChangementTonalite.icon")); // NOI18N
        mnuInsererChangementTonalite.setText(resourceMap.getString("mnuInsererChangementTonalite.text")); // NOI18N
        mnuInsererChangementTonalite.setName("mnuInsererChangementTonalite"); // NOI18N
        mnuInsererChangementTonalite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuInsererChangementTonaliteActionPerformed(evt);
            }
        });
        jPopupMenu1.add(mnuInsererChangementTonalite);

        mnuMesure.setIcon(resourceMap.getIcon("mnuMesure.icon")); // NOI18N
        mnuMesure.setText(resourceMap.getString("mnuMesure.text")); // NOI18N
        mnuMesure.setName("mnuMesure"); // NOI18N

        mnuMesureCorriger.setIcon(resourceMap.getIcon("mnuMesureCorriger.icon")); // NOI18N
        mnuMesureCorriger.setText(resourceMap.getString("mnuMesureCorriger.text")); // NOI18N
        mnuMesureCorriger.setName("mnuMesureCorriger"); // NOI18N
        mnuMesureCorriger.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuMesureCorrigerActionPerformed(evt);
            }
        });
        mnuMesure.add(mnuMesureCorriger);

        mnuMesureSignatureChanger.setIcon(resourceMap.getIcon("mnuMesureSignatureChanger.icon")); // NOI18N
        mnuMesureSignatureChanger.setText(resourceMap.getString("mnuMesureSignatureChanger.text")); // NOI18N
        mnuMesureSignatureChanger.setName("mnuMesureSignatureChanger"); // NOI18N
        mnuMesureSignatureChanger.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuMesureSignatureChangerActionPerformed(evt);
            }
        });
        mnuMesure.add(mnuMesureSignatureChanger);

        jPopupMenu1.add(mnuMesure);

        mnuInsererTempo.setAction(actionMap.get("tempoInserer")); // NOI18N
        mnuInsererTempo.setIcon(resourceMap.getIcon("mnuInsererTempo.icon")); // NOI18N
        mnuInsererTempo.setText(resourceMap.getString("mnuInsererTempo.text")); // NOI18N
        mnuInsererTempo.setName("mnuInsererTempo"); // NOI18N
        jPopupMenu1.add(mnuInsererTempo);

        mnuNotes.setIcon(resourceMap.getIcon("mnuNotes.icon")); // NOI18N
        mnuNotes.setText(resourceMap.getString("mnuNotes.text")); // NOI18N
        mnuNotes.setName("mnuNotes"); // NOI18N

        mnuNotesLierAuxSuivantes.setAction(actionMap.get("notesLierAuxSuivantes")); // NOI18N
        mnuNotesLierAuxSuivantes.setIcon(resourceMap.getIcon("mnuNotesLierAuxSuivantes.icon")); // NOI18N
        mnuNotesLierAuxSuivantes.setText(resourceMap.getString("mnuNotesLierAuxSuivantes.text")); // NOI18N
        mnuNotesLierAuxSuivantes.setName("mnuNotesLierAuxSuivantes"); // NOI18N
        mnuNotes.add(mnuNotesLierAuxSuivantes);

        mnuNotesNePasLierAuxSuivantes.setAction(actionMap.get("notesNePasLierAuxSuivantes")); // NOI18N
        mnuNotesNePasLierAuxSuivantes.setIcon(resourceMap.getIcon("mnuNotesNePasLierAuxSuivantes.icon")); // NOI18N
        mnuNotesNePasLierAuxSuivantes.setText(resourceMap.getString("mnuNotesNePasLierAuxSuivantes.text")); // NOI18N
        mnuNotesNePasLierAuxSuivantes.setName("mnuNotesNePasLierAuxSuivantes"); // NOI18N
        mnuNotes.add(mnuNotesNePasLierAuxSuivantes);

        jPopupMenu1.add(mnuNotes);

        mnuSelection.setIcon(resourceMap.getIcon("mnuSelection.icon")); // NOI18N
        mnuSelection.setText(resourceMap.getString("mnuSelection.text")); // NOI18N
        mnuSelection.setName("mnuSelection"); // NOI18N

        jMenuItem2.setText(resourceMap.getString("jMenuItem2.text")); // NOI18N
        jMenuItem2.setName("jMenuItem2"); // NOI18N
        jMenuItem2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem2ActionPerformed(evt);
            }
        });
        mnuSelection.add(jMenuItem2);

        jPopupMenu1.add(mnuSelection);

        setBackground(resourceMap.getColor("Form.background")); // NOI18N
        setComponentPopupMenu(jPopupMenu1);
        setName("Form"); // NOI18N
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                formMouseClicked(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                formMouseReleased(evt);
            }
        });
        addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                formMouseDragged(evt);
            }
            public void mouseMoved(java.awt.event.MouseEvent evt) {
                formMouseMoved(evt);
            }
        });
        addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                formKeyPressed(evt);
            }
            public void keyReleased(java.awt.event.KeyEvent evt) {
                formKeyReleased(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                formKeyTyped(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 479, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 395, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    
    
    
    private boolean isPointInSelectionPolygones(Point pt)
    {
        if(selectionPolygones == null)
        {
            return false;
        }
        else
        {
            for(Polygon p : selectionPolygones)
            {
                if(p.contains(pt))
                    return true;
            }
            return false;
        }
    }
private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed
// quand on appuie sur un bouton de la souris
    
    Curseur curseur = getCurseur(evt.getPoint());

    

    if(isLecture())
    {
        partitionLecteur.setMomentActuel(partitionVue.getCurseur(evt.getPoint()).getMoment());
        repaint();
        return;

    }
    else
    if(curseur.isSurElementMusical())
    {
        if(selection == null)
        {
           selection = new Selection();
           System.out.print(curseur.getElementMusical());
           selection.ajouterElementMusical(curseur.getElementMusical());
        }   
        else if(!selection.contains(curseur.getElementMusical()))
        {
            if(!evt.isControlDown())
                 selection = new Selection();
            

            selection.ajouterElementMusical(curseur.getElementMusical());
        }    

        setSelection(selection);
        notesDeplacementSouris = new NotesDeplacementSouris(curseur, selection);
    }
    else if(isPointInSelectionPolygones(evt.getPoint()))
    {
        notesDeplacementSouris = new NotesDeplacementSouris(curseur, selection);
    }
    
    

    
    styloEsquisse = new StyloEsquisse();
    styloEsquisse.styloPointAjouter(evt.getPoint(),
                                    getCurseur(evt.getPoint()));
}//GEN-LAST:event_formMousePressed



private void traiterSelectionPolygon()
{
    if(styloEsquisse == null)
        return;

    if(styloEsquisse.isPolygon())
    {
        if(selection == null)
            selection = new Selection();
        
        selection.ajouterSelection(partitionVue
                .getSelectionPolygone(styloEsquisse.getPolygon()));
        setSelection(selection);
    }
}



private void formMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseReleased
// TODO add your handling code here:
    
    if(isLecture())
    {
        return;
         
    }
    else if(notesDeplacementSouris != null)
    {
        if(!notesDeplacementSouris.isTrivial())
        {
            if(evt.isControlDown())
                notesDeplacementSouris.effectuerCopie();
            else
            {
                notesDeplacementSouris.effectuer();
            }
            
            
            
            
        }

        
        notesDeplacementSouris = null;
        
        
    }
    else if(isSelection())
    {        
        if(!evt.isControlDown())
             selectionAbandonner();
        
        traiterSelectionPolygon();


        
    }
    else if(styloEsquisse != null)
    {
        if(styloEsquisse.isGribouilli())
        {
            ArrayList<ElementMusical> notes = new ArrayList<ElementMusical>();

            for(Curseur curseur : styloEsquisse.getCurseurs())
            {
                if(curseur.isSurElementMusical())
                {
                    if(!notes.contains(curseur.getElementMusical()))
                        notes.add(curseur.getElementMusical());

                }
            }
            for(ElementMusical note : notes)
            {
                     histoire.executer(
                             new PartitionActionElementMusicalSupprimer(
                                        note
                                            )
                                      );
                     
            }
            partitionVue.calculer();
        }


        if(styloEsquisse.isPoint())
        {
                Curseur curseur = getCurseur(evt.getPoint());

                if(curseur.isSurElementMusical())
                {
                    if(selection == null)
                        selection = new Selection();

                    selection.ajouterElementMusical(curseur.getElementMusical());
                    setSelection(selection);
                }
                else
                {
                    if(selection != null)
                        return;

                    Note noteAAjouter = new Note(curseur.getMoment(),
                                                            curseurNoteDuree,
                                                            curseur.getHauteur(), 
                                                            curseur.getPortee(),
                                                            curseur.getVoix());

                    (new NoteEcoute(noteAAjouter, machineSortie)).ecouter();
                    histoire.executer(new PartitionActionElementMusicalAjouter(noteAAjouter));
                    partitionVue.calculer(curseur.getMoment());
                }
        }
        
        
        
        if(styloEsquisse.isSegmentVertical() && styloEsquisse.getSegmentLongueur() > 50)
        {
            Moment barreMoment = getMomentBarre(styloEsquisse.getSegmentPremierPoint());
            if(partitionVue.getPartitionDonnees().isBarreDeMesure(barreMoment))
            {
                 Moment momentFin = new Duree(new Rational(4, 1)).getFinMoment(barreMoment);
                 histoire.executer(new PartitionActionInsererTemps(barreMoment,
                            momentFin));
                 histoire.executer(new PartitionActionElementMusicalAjouter(new BarreDeMesure(barreMoment)));

            }
            else
            {
                  histoire.executer(new PartitionActionElementMusicalAjouter(new BarreDeMesure(barreMoment)));
            }
            partitionVue.calculer(barreMoment);
        }
        
        traiterSelectionPolygon();
    }
    
    styloEsquisse = null;
    modifierSourisCurseurCrayon();
    
    if(isSelection())
        selectionEntamer();
    else
        selectionAbandonner();
    
    
    repaint();
}//GEN-LAST:event_formMouseReleased

private void formMouseMoved(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseMoved
// quand on bouge la souris sans qu'aucun bouton n'est appuyé
    if(isLecture())
    {
        modifierSourisCurseurLecturePosition();
        return;
    }
    
    curseurSouris = getCurseur(evt.getPoint());
    curseurSourisMomentBarre = getMomentBarre(evt.getPoint());
    
    if(isSelection())
    {
        sourisCurseurNoteAucune();
        
        if(getCurseurSouris().isSurElementMusical() || isPointInSelectionPolygones(evt.getPoint()))
            modifierSourisCurseurMain();
        else
            modifierSourisCurseurMainAbandonner(); 
    }
    else
    {
        if(getCurseurSouris().isSurElementMusical())
        {
            sourisCurseurNoteAucune();
            modifierSourisCurseurMain();
        }
        else
        {
            Note note = new Note(getCurseurSouris().getMoment(), curseurNoteDuree,
                                          getCurseurSouris().getHauteur(), curseurSouris.getPortee());
            if(getPartitionVue().getAffichageAccord(curseurSouris) != null)
            {
                note.setHampeDirection(getPartitionVue().getAffichageAccord(curseurSouris).getHampeDirection());
            }

            setSourisCurseurNote(note);
            modifierSourisCurseurCrayon(); 
        }
    }
    
    
    repaint();

    
}//GEN-LAST:event_formMouseMoved

private void formMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseDragged
// TODO add your handling code here:
    if(isLecture())
        return;
    
        sourisCurseurNoteAucune();
        
        if(notesDeplacementSouris != null)
        {
            curseurSouris = partitionVue.getCurseur(evt.getPoint());
            notesDeplacementSouris.setReferenceCurseurFutur(curseurSouris);
        }
        else if(styloEsquisse != null)
        {
            styloEsquisse.styloPointAjouter(evt.getPoint(),
                                    getCurseur(evt.getPoint()));
        
            if(styloEsquisse.isGribouilli())
                modifierSourisCurseurGomme();
        }
        
        repaint();
}//GEN-LAST:event_formMouseDragged

private void formMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseClicked
// TODO add your handling code here:
    requestFocus();

    if(evt.getClickCount() > 1)
    {
        if(getCurseurSouris().getElementMusical() instanceof ElementMusicalChangementMesureSignature)
        {
             MesureSignatureChangementDialog d = new MesureSignatureChangementDialog(null, true);
             d.setVisible(true);

             if(d.getSignature() != null)
             {
                 histoire.executer(new PartitionActionElementMusicalSupprimer(getCurseurSouris().getElementMusical()));
                 histoire.executer(new PartitionActionElementMusicalAjouter(
                         new ElementMusicalChangementMesureSignature(getCurseurSouris().getMoment(),
                         d.getSignature())));
                 selectionAbandonner();
                 calculer(getCurseurSouris().getMoment());
                 repaint();
             }
        }
        else if(getCurseurSouris().getElementMusical() instanceof ElementMusicalChangementTonalite)
        {
             TonaliteDialog d = new TonaliteDialog(null, true);
             d.setVisible(true);

             if(d.getTonalite() != null)
             {
                 histoire.executer(new PartitionActionElementMusicalSupprimer(getCurseurSouris().getElementMusical()));
                 histoire.executer(new PartitionActionElementMusicalAjouter(
                         new ElementMusicalChangementTonalite(getCurseurSouris().getMoment(),
                         d.getTonalite())));
                 selectionAbandonner();
                 calculer(getCurseurSouris().getMoment());
                 repaint();
             }
        }
        else if(getCurseurSouris().getElementMusical() instanceof ElementMusicalTempo)
        {
             TempoDialog d = new TempoDialog(null, true);
             d.setVisible(true);

             if(d.getTempo() != null)
             {
                 histoire.executer(new PartitionActionElementMusicalSupprimer(getCurseurSouris().getElementMusical()));
                 histoire.executer(new PartitionActionElementMusicalAjouter(
                         new ElementMusicalTempo(getCurseurSouris().getMoment(),
                         d.getTempo().getNbNoiresEnUneMinute(), d.getTempo().getNom())));
                 selectionAbandonner();
                 calculer(getCurseurSouris().getMoment());
                 repaint();
             }
        }
        else if(getCurseurSouris().getElementMusical() instanceof ElementMusicalClef)
        {
             ClefDialog d = new ClefDialog(null, true);
             d.setVisible(true);

             if(d.getClef() != null)
             {
                 histoire.executer(new PartitionActionElementMusicalSupprimer(getCurseurSouris().getElementMusical()));
                 histoire.executer(new PartitionActionElementMusicalAjouter(
                         new ElementMusicalClef(getCurseurSouris().getMoment(),
                         getCurseurSouris().getPortee(),
                         d.getClef())));
                 selectionAbandonner();
                 calculer(getCurseurSouris().getMoment());
                 repaint();
             }
        }
        else if(getCurseurSouris().getElementMusical() instanceof Note)
        {
            if(isSelection())
            {
                setSelection(getSelection().getSelectionMemeHauteur(getCurseurSouris().getHauteur()));
                repaint();
            }
        }
    }
    
}//GEN-LAST:event_formMouseClicked

private void formKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyPressed
// TODO add your handling code here:
     if(evt.getKeyChar() == ' ')
     {
         histoire.executer(
                 new PartitionActionElementMusicalAjouter(
                      new Silence(getCurseurSouris().getMoment(),
                                  curseurNoteDuree,
                                  getCurseurSouris().getPortee(),
                                  getCurseurSouris().getHauteur())));
         
         calculer(getCurseurSouris().getMoment());
         repaint();
                 
     }
     
     if(evt.isControlDown())
     {
         fenetrePrincipale.modeSelectionPlus();
     }

     DureeEntreeFractionPanel.tryDureePanel(evt, this);
     
}//GEN-LAST:event_formKeyPressed

private void formKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyTyped
// TODO add your handling code here:
 
}//GEN-LAST:event_formKeyTyped

private void formKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyReleased
    // TODO add your handling code here:
     if(!evt.isControlDown())
     {
         fenetrePrincipale.modeSelectionPasPlus();
     }
}//GEN-LAST:event_formKeyReleased

private void mnuInsererChangementTonaliteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuInsererChangementTonaliteActionPerformed
     TonaliteDialog d = new TonaliteDialog(null, true);
     d.setVisible(true);

     if(d.getTonalite() != null)
     {
         histoire.executer(new PartitionActionElementMusicalAjouter(
                 new ElementMusicalChangementTonalite(getCurseurSouris().getMoment(),
                 d.getTonalite())));
         selectionAbandonner();
         calculer(getCurseurSouris().getMoment());
         repaint();
     }

}//GEN-LAST:event_mnuInsererChangementTonaliteActionPerformed

private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
    setSelection(getPartitionDonnees().getSelectionToutPartie(curseurSouris.getPartie()));
    repaint();
}//GEN-LAST:event_jMenuItem2ActionPerformed

private void mnuMesureCorrigerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuMesureCorrigerActionPerformed
    Moment moment = getCurseurSouris().getMoment();
    Moment debutMesure = getPartitionDonnees().getMomentMesureDebut(moment);
    Moment finMesure = getPartitionDonnees().getMomentMesureFin(moment);

    Duree dureeMesure = new Duree(debutMesure, finMesure);

    Duree dureeEscomptees = getPartitionDonnees().getMesureSignature(moment).getMesuresDuree();

    histoire.executer(new PartitionActionInsererTemps(finMesure, dureeEscomptees.getFinMoment(debutMesure)));
    calculer();

    repaint();

}//GEN-LAST:event_mnuMesureCorrigerActionPerformed

private void mnuLectureActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuLectureActionPerformed
    fenetrePrincipale.debuterLecture(getCurseurSouris().getMoment());

}//GEN-LAST:event_mnuLectureActionPerformed

private void mnuMesureSignatureChangerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuMesureSignatureChangerActionPerformed
   MesureSignatureChangementDialog d = new MesureSignatureChangementDialog(null, true);
   d.setVisible(true);

   if(d.getSignature() != null)
   {
       histoire.executer(new PartitionActionElementMusicalAjouter(
                         new ElementMusicalChangementMesureSignature(getCurseurSouris().getMoment(),
                         d.getSignature())));
       selectionAbandonner();
       calculer(getCurseurSouris().getMoment());
       repaint();
   }

}//GEN-LAST:event_mnuMesureSignatureChangerActionPerformed

private void mnuTempsSupprimerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuTempsSupprimerActionPerformed
    if(getPartitionDonnees().isMomentPasDeNotes(curseurSouris.getMoment()))
    {
        histoire.executer(
                new PartitionActionInsererTemps(
                getPartitionDonnees().getMomentSuivant(curseurSouris.getMoment()),
                curseurSouris.getMoment() ));

        partitionVue.calculer(curseurSouris.getMoment());
        repaint();
    }
}//GEN-LAST:event_mnuTempsSupprimerActionPerformed



    private void graphics2Dconfigure(Graphics2D g2)
    {
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
        RenderingHints.VALUE_ANTIALIAS_ON);
        g2.setRenderingHint(RenderingHints.KEY_RENDERING,
        RenderingHints.VALUE_RENDER_QUALITY);
    }
    
    
    
    private void dessinerArrierePlan(Graphics2D g)
    {
        g.setColor(Color.white);
        g.fillRect(g.getClipBounds().x, g.getClipBounds().y, g.getClipBounds().width, g.getClipBounds().height);
        
    }

    @Override
    protected void paintComponent(Graphics graphics) {
        Graphics2D g = (Graphics2D) graphics;
        graphics2Dconfigure(g);
        
        dessinerArrierePlan(g);
        drawSelectionFond(g);

        g.setColor(Color.BLACK);
        partitionVue.afficherPartition(g, getVisibleRect());
        
        if(curseurSouris != null)
            partitionVue.afficherContexte(g, curseurSouris);

        dessinerSelection(g);

        if(styloEsquisse != null)
            styloEsquisse.afficher(g);
        
        if(isLecture())
        {
            affichageLectureBarre.setMoment(partitionLecteur.momentActuelGet());
            affichageLectureBarre.draw(g);
            Rectangle systemeRectangle =
               partitionVue.getSysteme(partitionLecteur.momentActuelGet()).getRectangle();
            if(!getVisibleRect().contains(systemeRectangle))
                 scrollRectToVisible(partitionVue.getSysteme(partitionLecteur.momentActuelGet()).getRectangle());
        }

        if(notesDeplacementSouris != null)
            notesDeplacementSouris.afficher(g);
        
        if(!isLecture())
            sourisCurseurNoteAfficher(g);
        
        //pour que la taille se redimensionne tout le temps
        //(pour que la barre de défilement dès qu'on en a besoin)
        setSize(getPreferredSize());
        
    }
    
    
    
    public Curseur getCurseur(Point point)
    {
        return partitionVue.getCurseur(point, curseurNoteDuree);
    }
    
    private Moment getMomentBarre(Point point)
    {
        return partitionVue.getMomentBarre(point);
    }



    
    @Override
    public Dimension getPreferredSize()
    {
        return partitionVue.getDimension();
    } 
    
    
    
    public void setSystemeLongueur(int systemeLongueur)
    {
        partitionVue.setSystemeLongueur(systemeLongueur);
        partitionVue.calculer();
    }
    
    

    
    
    
    public boolean isLecture()
    {
        return (partitionLecteur != null);
    }


    public boolean isEnregistrement()
    {
        return (partitionScribe != null);
    }
    
    
    public void setPartitionLecteur(PartitionLecteur partitionLecteur)
    {
        this.partitionLecteur = partitionLecteur;
        if(partitionScribe == null)
            affichageLectureBarre.setLectureBarre();
        repaint();
    }


    public void setPartitionScribe(PartitionScribe partitionScribe)
    {
        this.partitionScribe = partitionScribe;
        affichageLectureBarre.setEnregistrementLectureBarre();
        repaint();
    }
    
    
    public void lectureArreter()
    {
        partitionLecteur = null;
        repaint();
    }


    public void enregistrementArreter()
    {
        partitionScribe = null;
        repaint();
    }


    @Action
    public void tempoInserer() {
         TempoDialog d = new TempoDialog(null, true);
         d.setVisible(true);

         if(d.getTempo() != null)
         {
             histoire.executer(new PartitionActionElementMusicalAjouter(
                     new ElementMusicalTempo(getCurseurSouris().getMoment(),
                     d.getTempo().getNbNoiresEnUneMinute(), d.getTempo().getNom())));
             selectionAbandonner();
             calculer(getCurseurSouris().getMoment());
             repaint();
         }
        
    }

    @Action
    public void clefInserer() {
         ClefDialog d = new ClefDialog(null, true);
         d.setVisible(true);

         if(d.getClef() != null)
         {
             selectionAbandonner();
             histoire.executer(new PartitionActionElementMusicalAjouter(
                     new ElementMusicalClef(getCurseurSouris().getMoment(),
                     getCurseurSouris().getPortee(),
                     d.getClef())));
             
             calculer(getCurseurSouris().getMoment());
             repaint();
         }
    }

    @Action
    public void tempsInserer() {
        histoire.executer(new PartitionActionInsererTemps(getCurseurSourisMomentBarre(), new Duree(new Rational(1, 1)).getFinMoment(getCurseurSourisMomentBarre())));
        partitionVue.calculer(getCurseurSourisMomentBarre());
        repaint();
    }

    @Action
    public void notesLierAuxSuivantes() {
        histoire.executer(new PartitionActionSelectionNotesLierAuxSuivantes(getSelection(), true));
        partitionVue.calculer(getCurseurSourisMomentBarre());
        repaint();
    }

    @Action
    public void notesNePasLierAuxSuivantes() {
        histoire.executer(new PartitionActionSelectionNotesLierAuxSuivantes(getSelection(), false));
        partitionVue.calculer(getCurseurSourisMomentBarre());
        repaint();
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JMenuItem mnuClefInserer;
    private javax.swing.JMenuItem mnuInsererChangementTonalite;
    private javax.swing.JMenuItem mnuInsererTempo;
    private javax.swing.JMenuItem mnuLecture;
    private javax.swing.JMenu mnuMesure;
    private javax.swing.JMenuItem mnuMesureCorriger;
    private javax.swing.JMenuItem mnuMesureSignatureChanger;
    private javax.swing.JMenu mnuNotes;
    private javax.swing.JMenuItem mnuNotesLierAuxSuivantes;
    private javax.swing.JMenuItem mnuNotesNePasLierAuxSuivantes;
    private javax.swing.JMenu mnuSelection;
    private javax.swing.JMenuItem mnuTempsInserer;
    private javax.swing.JMenuItem mnuTempsSupprimer;
    // End of variables declaration//GEN-END:variables

}
