/*
 * MusicwriterView.java
 */

package musicwriter;

import java.io.File;
import javax.swing.event.ChangeEvent;
import musicwriter.dialogs.PartitionPartiesDialog;
import java.awt.CardLayout;
import java.awt.Cursor;
import java.awt.Toolkit;
import java.awt.event.KeyEvent;
import java.io.IOException;
import org.jdesktop.application.Action;
import org.jdesktop.application.ResourceMap;
import org.jdesktop.application.SingleFrameApplication;
import org.jdesktop.application.FrameView;
import org.jdesktop.application.TaskMonitor;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Timer;
import javax.swing.Icon;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.event.ChangeListener;
import javax.swing.filechooser.FileFilter;
import musicwriter.Hauteur.Alteration;
import org.jdom.JDOMException;

/**
 * The application's main frame.
 */
public class MusicwriterView extends FrameView {

    PartitionVue partitionVue = null;
    MachineEntreeMIDI machineEntreeMIDI = null;
    Histoire histoire = null;
    PartitionSauvegarde sauvegarde = null;
    private MachineSortie machineSortieMIDI = null;
    private PartitionLecteur partitionLecteur = null;
    private DialogConfiguration dialogueConfiguration = new DialogConfiguration(getFrame(), true);
    private Selection pressePapier = null;
    
    String fichierNom = null;
    
    
    private void machineSortieMIDI_creer(int machineSortieMIDInumero)
    {
          machineSortieMIDI = new MachineSortieMIDI(
                InterfaceMIDI.getMIDIDeviceAvecNumero(machineSortieMIDInumero));
          getPartitionPanel().setMachineSortieMIDI(machineSortieMIDI);
    }
    
    
    
    private PartitionPanel getPartitionPanel()
    {
        return (PartitionPanel) partitionPanel;
    }
    
    
    
    public void modeEcriture()
    {
        ((CardLayout) (panBarreOutils.getLayout())).show(panBarreOutils, "modeEcriture");
        helpPanel.page_show("ecriture.html");
    }
    
    public void modeSelection()
    {
        ((CardLayout) (panBarreOutils.getLayout())).show(panBarreOutils, "modeSelection");
        helpPanel.page_show("selection.html");
    }


    

    void modeSelectionPasPlus() {
        lblSelectionPlus.setOpaque(false);
        lblSelectionPlus.repaint();

    }

    void modeSelectionPlus() {
        lblSelectionPlus.setOpaque(true);
         lblSelectionPlus.repaint();
    }

    private void modeLecture() {
       ((CardLayout) (panBarreOutils.getLayout())).show(panBarreOutils, "modeLecture");
        helpPanel.page_show("lecture.html");
    }

    public void modeEnregistrementMIDI()
    {
        ((CardLayout) (panBarreOutils.getLayout())).show(panBarreOutils, "modeLecture");
        helpPanel.page_show("enregistrement.html");
    }
    
    public void declarerPartitionDonnees(PartitionDonnees partitionDonnees)
    {
        partitionVue = new PartitionVue(partitionDonnees);
        histoire = new Histoire(partitionDonnees, partitionVue);
        sauvegarde = new PartitionSauvegarde(partitionDonnees);
        
        getPartitionPanel().setPartitionVueEtHistoire(partitionVue, histoire);
        
 
        
    }
    
    
    public void partitionVueAdapterALEcran()
    {
        ((PartitionPanel) partitionPanel).setSystemeLongueur(jScrollPane.getSize().width - 50);

    }
    



    
    public PartitionDonnees getPartitionDonneesNouvellePourPiano()
    {
        PartitionDonnees partitionDonneesPourPiano = new PartitionDonnees();
        Partie partiePiano = new Partie(new Instrument(0));
        partitionDonneesPourPiano.partieAjouter(0, partiePiano);
        partitionDonneesPourPiano.partieClefsInstaller(partiePiano);
        partitionDonneesPourPiano.elementMusicalAjouter(new ElementMusicalChangementMesureSignature(partitionDonneesPourPiano.getMomentDebut(), new MesureSignature(4, 4)));
        partitionDonneesPourPiano.elementMusicalAjouter(new ElementMusicalChangementTonalite(partitionDonneesPourPiano.getMomentDebut(),  new Tonalite(2)));
        partitionDonneesPourPiano.elementMusicalAjouter(new ElementMusicalTempo(partitionDonneesPourPiano.getMomentDebut(), 120, "Allegro"));
        partitionDonneesPourPiano.setPasDeModification();
        return partitionDonneesPourPiano;
    }



    public void exit() {
        if(getPartitionDonnees().isModifie())
        {
            String[] choix = {"On sauvegarde et on quitte", "On quitte sans sauvegarder", "Je reste !"};
	    int reponse = JOptionPane.showOptionDialog(getFrame(),
			       "Vous vous apprêtez à quitter. Que faire ?",
			       "Schwarz Musicwriter",
			       JOptionPane.YES_NO_CANCEL_OPTION,
			       JOptionPane.QUESTION_MESSAGE,
			       null,
			       choix,
                               choix[2]);
            switch(reponse)
            {
                case JOptionPane.YES_OPTION:
                    if(save())
                        System.exit(0);
                case JOptionPane.NO_OPTION: System.exit(0);
                case JOptionPane.CANCEL_OPTION:
            }

        }
        else
            System.exit(0);
        
   }

    private void nomFichier_Aucun() {
        fichierNom = null;
        this.getFrame().setTitle("Schwarz Musicwriter - Nouvelle partition");
    }




    public MusicwriterView(SingleFrameApplication app) {
        super(app);
        
        initComponents();

        dureePanel.addListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                getPartitionPanel().setCurseurSourisDuree(dureePanel.getDuree());
            }
        });

        selectionDureePanel.addListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                getPartitionPanel().selectionElementsMusicauxDureeSet(selectionDureePanel.getDuree());
            }
        });

        jSliderLectureVitesse.addChangeListener(new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
                vitesseInterfaceToPartitionLecteur();
            }
        });
        
        this.getPartitionPanel().requestFocus();
        
        boutonMIDIStop.setVisible(false);
        boutonSortieMIDIReprendre.setVisible(false);
        boutonPause.setVisible(false);
        
        

        modeEcriture();
        
        declarerPartitionDonnees( getPartitionDonneesNouvellePourPiano() );

        machineSortieMIDI_creer(InterfaceMIDI.machineSortieMIDIStandardNumeroGet());
        
        
        getFrame().addKeyListener(new java.awt.event.KeyAdapter() {
            @Override
            public void keyPressed(java.awt.event.KeyEvent evt) {
                partitionPanelKeyPressed(evt);
            }
        });
        

        // status bar initialization - message timeout, idle icon and busy animation, etc
        ResourceMap resourceMap = getResourceMap();
        int messageTimeout = resourceMap.getInteger("StatusBar.messageTimeout");
        messageTimer = new Timer(messageTimeout, new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                statusMessageLabel.setText("");
            }
        });
        messageTimer.setRepeats(false);
        int busyAnimationRate = resourceMap.getInteger("StatusBar.busyAnimationRate");
        for (int i = 0; i < busyIcons.length; i++) {
            busyIcons[i] = resourceMap.getIcon("StatusBar.busyIcons[" + i + "]");
        }
        busyIconTimer = new Timer(busyAnimationRate, new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                busyIconIndex = (busyIconIndex + 1) % busyIcons.length;
                statusAnimationLabel.setIcon(busyIcons[busyIconIndex]);
            }
        });
        idleIcon = resourceMap.getIcon("StatusBar.idleIcon");
        statusAnimationLabel.setIcon(idleIcon);
        progressBar.setVisible(false);

        // connecting action tasks to status bar via TaskMonitor
        TaskMonitor taskMonitor = new TaskMonitor(getApplication().getContext());
        taskMonitor.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                String propertyName = evt.getPropertyName();
                if ("started".equals(propertyName)) {
                    if (!busyIconTimer.isRunning()) {
                        statusAnimationLabel.setIcon(busyIcons[0]);
                        busyIconIndex = 0;
                        busyIconTimer.start();
                    }
                    progressBar.setVisible(true);
                    progressBar.setIndeterminate(true);
                } else if ("done".equals(propertyName)) {
                    busyIconTimer.stop();
                    statusAnimationLabel.setIcon(idleIcon);
                    progressBar.setVisible(false);
                    progressBar.setValue(0);
                } else if ("message".equals(propertyName)) {
                    String text = (String)(evt.getNewValue());
                    statusMessageLabel.setText((text == null) ? "" : text);
                    messageTimer.restart();
                } else if ("progress".equals(propertyName)) {
                    int value = (Integer)(evt.getNewValue());
                    progressBar.setVisible(true);
                    progressBar.setIndeterminate(false);
                    progressBar.setValue(value);
                }
            }
        });
    }

    @Action
    public void showAboutBox() {
        if (aboutBox == null) {
            JFrame mainFrame = MusicwriterApp.getApplication().getMainFrame();
            aboutBox = new MusicwriterAboutBox(mainFrame);
            aboutBox.setLocationRelativeTo(mainFrame);
        }
        MusicwriterApp.getApplication().show(aboutBox);
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        menuBar = new javax.swing.JMenuBar();
        javax.swing.JMenu fileMenu = new javax.swing.JMenu();
        mnuNew = new javax.swing.JMenuItem();
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenuItem5 = new javax.swing.JMenuItem();
        jMenuItem6 = new javax.swing.JMenuItem();
        jMenuItem7 = new javax.swing.JMenuItem();
        javax.swing.JMenuItem exitMenuItem = new javax.swing.JMenuItem();
        jMenu2 = new javax.swing.JMenu();
        mnuAnnuler = new javax.swing.JMenuItem();
        mnuRefaire = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JSeparator();
        mnuCut = new javax.swing.JMenuItem();
        mnuCopy = new javax.swing.JMenuItem();
        mnuPaste = new javax.swing.JMenuItem();
        jSeparator3 = new javax.swing.JPopupMenu.Separator();
        mnuEditionSupprimer = new javax.swing.JMenuItem();
        jMenuItem2 = new javax.swing.JMenuItem();
        mnuSelectAll = new javax.swing.JMenuItem();
        mnuDeselectAll = new javax.swing.JMenuItem();
        jMenuNoteDuree = new javax.swing.JMenu();
        mnuTripleCroche = new javax.swing.JMenuItem();
        mnuDoubleCroche = new javax.swing.JMenuItem();
        jMenuItemCroche = new javax.swing.JMenuItem();
        jMenuItemNoire = new javax.swing.JMenuItem();
        jMenuItemBlanche = new javax.swing.JMenuItem();
        mnuRonde = new javax.swing.JMenuItem();
        jMenu4 = new javax.swing.JMenu();
        mnuAlterationDoubleBemol = new javax.swing.JMenuItem();
        mnuAlterationBemol = new javax.swing.JMenuItem();
        mnuAlterationBecarre = new javax.swing.JMenuItem();
        mnuAlterationDiese = new javax.swing.JMenuItem();
        mnuAlterationDoubleDiese = new javax.swing.JMenuItem();
        jSeparator2 = new javax.swing.JPopupMenu.Separator();
        mnuAlterationEnharmonique = new javax.swing.JMenuItem();
        mnuAlterationViaTonalite = new javax.swing.JMenuItem();
        jMenu3 = new javax.swing.JMenu();
        mnuNouvelleVoix = new javax.swing.JMenuItem();
        jMenuItem4 = new javax.swing.JMenuItem();
        mnuVoixNotesIndependantes = new javax.swing.JMenuItem();
        jMenu5 = new javax.swing.JMenu();
        mnuConfiguration = new javax.swing.JMenuItem();
        javax.swing.JMenu helpMenu = new javax.swing.JMenu();
        javax.swing.JMenuItem aboutMenuItem = new javax.swing.JMenuItem();
        jMenuItem8 = new javax.swing.JMenuItem();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        mnuRepaint = new javax.swing.JMenuItem();
        statusPanel = new javax.swing.JPanel();
        javax.swing.JSeparator statusPanelSeparator = new javax.swing.JSeparator();
        statusMessageLabel = new javax.swing.JLabel();
        statusAnimationLabel = new javax.swing.JLabel();
        progressBar = new javax.swing.JProgressBar();
        panelGeneral = new javax.swing.JPanel();
        panelTravail = new javax.swing.JPanel();
        panBarreOutils = new javax.swing.JPanel();
        jToolBar3 = new javax.swing.JToolBar();
        boutonSortieMIDIReprendre = new javax.swing.JButton();
        boutonPause1 = new javax.swing.JButton();
        boutonMIDIStop1 = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jSliderLectureVitesse = new javax.swing.JSlider();
        jLabel5 = new javax.swing.JLabel();
        toolBarSelection = new javax.swing.JToolBar();
        lblSelectionPlus = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        selectionDureePanel = new musicwriter.DureePanelExperimental();
        toolBarEcriture = new javax.swing.JToolBar();
        boutonOuvrir = new javax.swing.JButton();
        boutonSauvegarder = new javax.swing.JButton();
        boutonImprimer = new javax.swing.JButton();
        boutonAnnuler = new javax.swing.JButton();
        boutonRefaire = new javax.swing.JButton();
        boutonEntreeMIDIEnregistrer = new javax.swing.JButton();
        boutonSortieMIDILecture = new javax.swing.JButton();
        boutonPause = new javax.swing.JButton();
        boutonMIDIStop = new javax.swing.JButton();
        dureePanel = new musicwriter.DureePanelExperimental();
        jPanel1 = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jScrollPane = new javax.swing.JScrollPane();
        partitionPanel = new PartitionPanel(this, partitionVue, histoire);
        panAide = new javax.swing.JPanel();
        helpPanel = new musicwriter.HelpPanel();

        menuBar.setName("menuBar"); // NOI18N

        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getResourceMap(MusicwriterView.class);
        fileMenu.setText(resourceMap.getString("fileMenu.text")); // NOI18N
        fileMenu.setName("fileMenu"); // NOI18N

        mnuNew.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_N, java.awt.event.InputEvent.CTRL_MASK));
        mnuNew.setIcon(resourceMap.getIcon("mnuNew.icon")); // NOI18N
        mnuNew.setText(resourceMap.getString("mnuNew.text")); // NOI18N
        mnuNew.setName("mnuNew"); // NOI18N
        mnuNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuNewActionPerformed(evt);
            }
        });
        fileMenu.add(mnuNew);

        jMenuItem3.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_O, java.awt.event.InputEvent.CTRL_MASK));
        jMenuItem3.setIcon(resourceMap.getIcon("jMenuItem3.icon")); // NOI18N
        jMenuItem3.setText(resourceMap.getString("jMenuItem3.text")); // NOI18N
        jMenuItem3.setName("jMenuItem3"); // NOI18N
        jMenuItem3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem3ActionPerformed(evt);
            }
        });
        fileMenu.add(jMenuItem3);

        jMenuItem5.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_S, java.awt.event.InputEvent.CTRL_MASK));
        jMenuItem5.setIcon(resourceMap.getIcon("jMenuItem5.icon")); // NOI18N
        jMenuItem5.setText(resourceMap.getString("jMenuItem5.text")); // NOI18N
        jMenuItem5.setName("jMenuItem5"); // NOI18N
        jMenuItem5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem5ActionPerformed(evt);
            }
        });
        fileMenu.add(jMenuItem5);

        jMenuItem6.setIcon(resourceMap.getIcon("jMenuItem6.icon")); // NOI18N
        jMenuItem6.setText(resourceMap.getString("jMenuItem6.text")); // NOI18N
        jMenuItem6.setName("jMenuItem6"); // NOI18N
        jMenuItem6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem6ActionPerformed(evt);
            }
        });
        fileMenu.add(jMenuItem6);

        jMenuItem7.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_P, java.awt.event.InputEvent.CTRL_MASK));
        jMenuItem7.setIcon(resourceMap.getIcon("jMenuItem7.icon")); // NOI18N
        jMenuItem7.setText(resourceMap.getString("jMenuItem7.text")); // NOI18N
        jMenuItem7.setName("jMenuItem7"); // NOI18N
        fileMenu.add(jMenuItem7);

        javax.swing.ActionMap actionMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getActionMap(MusicwriterView.class, this);
        exitMenuItem.setAction(actionMap.get("quit")); // NOI18N
        exitMenuItem.setText(resourceMap.getString("exitMenuItem.text")); // NOI18N
        exitMenuItem.setName("exitMenuItem"); // NOI18N
        fileMenu.add(exitMenuItem);

        menuBar.add(fileMenu);

        jMenu2.setText(resourceMap.getString("jMenu2.text")); // NOI18N
        jMenu2.setName("jMenu2"); // NOI18N

        mnuAnnuler.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_Z, java.awt.event.InputEvent.CTRL_MASK));
        mnuAnnuler.setIcon(resourceMap.getIcon("mnuAnnuler.icon")); // NOI18N
        mnuAnnuler.setText(resourceMap.getString("mnuAnnuler.text")); // NOI18N
        mnuAnnuler.setName("mnuAnnuler"); // NOI18N
        mnuAnnuler.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAnnulerActionPerformed(evt);
            }
        });
        jMenu2.add(mnuAnnuler);

        mnuRefaire.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_Y, java.awt.event.InputEvent.CTRL_MASK));
        mnuRefaire.setIcon(resourceMap.getIcon("mnuRefaire.icon")); // NOI18N
        mnuRefaire.setText(resourceMap.getString("mnuRefaire.text")); // NOI18N
        mnuRefaire.setName("mnuRefaire"); // NOI18N
        mnuRefaire.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuRefaireActionPerformed(evt);
            }
        });
        jMenu2.add(mnuRefaire);

        jSeparator1.setName("jSeparator1"); // NOI18N
        jMenu2.add(jSeparator1);

        mnuCut.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_X, java.awt.event.InputEvent.CTRL_MASK));
        mnuCut.setIcon(resourceMap.getIcon("mnuCut.icon")); // NOI18N
        mnuCut.setText(resourceMap.getString("mnuCut.text")); // NOI18N
        mnuCut.setName("mnuCut"); // NOI18N
        mnuCut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuCutActionPerformed(evt);
            }
        });
        jMenu2.add(mnuCut);

        mnuCopy.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_C, java.awt.event.InputEvent.CTRL_MASK));
        mnuCopy.setIcon(resourceMap.getIcon("mnuCopy.icon")); // NOI18N
        mnuCopy.setText(resourceMap.getString("mnuCopy.text")); // NOI18N
        mnuCopy.setName("mnuCopy"); // NOI18N
        mnuCopy.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuCopyActionPerformed(evt);
            }
        });
        jMenu2.add(mnuCopy);

        mnuPaste.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_V, java.awt.event.InputEvent.CTRL_MASK));
        mnuPaste.setIcon(resourceMap.getIcon("mnuPaste.icon")); // NOI18N
        mnuPaste.setText(resourceMap.getString("mnuPaste.text")); // NOI18N
        mnuPaste.setName("mnuPaste"); // NOI18N
        mnuPaste.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuPasteActionPerformed(evt);
            }
        });
        jMenu2.add(mnuPaste);

        jSeparator3.setName("jSeparator3"); // NOI18N
        jMenu2.add(jSeparator3);

        mnuEditionSupprimer.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_DELETE, 0));
        mnuEditionSupprimer.setIcon(resourceMap.getIcon("mnuEditionSupprimer.icon")); // NOI18N
        mnuEditionSupprimer.setText(resourceMap.getString("mnuEditionSupprimer.text")); // NOI18N
        mnuEditionSupprimer.setName("mnuEditionSupprimer"); // NOI18N
        mnuEditionSupprimer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuEditionSupprimerActionPerformed(evt);
            }
        });
        jMenu2.add(mnuEditionSupprimer);

        jMenuItem2.setIcon(resourceMap.getIcon("jMenuItem2.icon")); // NOI18N
        jMenuItem2.setText(resourceMap.getString("jMenuItem2.text")); // NOI18N
        jMenuItem2.setName("jMenuItem2"); // NOI18N
        jMenuItem2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem2ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem2);

        mnuSelectAll.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_A, java.awt.event.InputEvent.CTRL_MASK));
        mnuSelectAll.setText(resourceMap.getString("mnuSelectAll.text")); // NOI18N
        mnuSelectAll.setName("mnuSelectAll"); // NOI18N
        mnuSelectAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuSelectAllActionPerformed(evt);
            }
        });
        jMenu2.add(mnuSelectAll);

        mnuDeselectAll.setAction(actionMap.get("selectionDeselectionnerTout")); // NOI18N
        mnuDeselectAll.setText(resourceMap.getString("mnuDeselectAll.text")); // NOI18N
        mnuDeselectAll.setName("mnuDeselectAll"); // NOI18N
        mnuDeselectAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuDeselectAllActionPerformed(evt);
            }
        });
        jMenu2.add(mnuDeselectAll);

        menuBar.add(jMenu2);

        jMenuNoteDuree.setText(resourceMap.getString("jMenuNoteDuree.text")); // NOI18N
        jMenuNoteDuree.setName("jMenuNoteDuree"); // NOI18N

        mnuTripleCroche.setIcon(resourceMap.getIcon("mnuTripleCroche.icon")); // NOI18N
        mnuTripleCroche.setText(resourceMap.getString("mnuTripleCroche.text")); // NOI18N
        mnuTripleCroche.setName("mnuTripleCroche"); // NOI18N
        mnuTripleCroche.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuTripleCrocheActionPerformed(evt);
            }
        });
        jMenuNoteDuree.add(mnuTripleCroche);

        mnuDoubleCroche.setIcon(resourceMap.getIcon("mnuDoubleCroche.icon")); // NOI18N
        mnuDoubleCroche.setText(resourceMap.getString("mnuDoubleCroche.text")); // NOI18N
        mnuDoubleCroche.setName("mnuDoubleCroche"); // NOI18N
        mnuDoubleCroche.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuDoubleCrocheActionPerformed(evt);
            }
        });
        jMenuNoteDuree.add(mnuDoubleCroche);

        jMenuItemCroche.setIcon(resourceMap.getIcon("jMenuItemCroche.icon")); // NOI18N
        jMenuItemCroche.setText(resourceMap.getString("jMenuItemCroche.text")); // NOI18N
        jMenuItemCroche.setName("jMenuItemCroche"); // NOI18N
        jMenuItemCroche.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCrocheActionPerformed(evt);
            }
        });
        jMenuNoteDuree.add(jMenuItemCroche);

        jMenuItemNoire.setIcon(resourceMap.getIcon("jMenuItemNoire.icon")); // NOI18N
        jMenuItemNoire.setText(resourceMap.getString("jMenuItemNoire.text")); // NOI18N
        jMenuItemNoire.setName("jMenuItemNoire"); // NOI18N
        jMenuItemNoire.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemNoireActionPerformed(evt);
            }
        });
        jMenuNoteDuree.add(jMenuItemNoire);

        jMenuItemBlanche.setIcon(resourceMap.getIcon("jMenuItemBlanche.icon")); // NOI18N
        jMenuItemBlanche.setText(resourceMap.getString("jMenuItemBlanche.text")); // NOI18N
        jMenuItemBlanche.setName("jMenuItemBlanche"); // NOI18N
        jMenuItemBlanche.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemBlancheActionPerformed(evt);
            }
        });
        jMenuNoteDuree.add(jMenuItemBlanche);

        mnuRonde.setIcon(resourceMap.getIcon("mnuRonde.icon")); // NOI18N
        mnuRonde.setText(resourceMap.getString("mnuRonde.text")); // NOI18N
        mnuRonde.setName("mnuRonde"); // NOI18N
        mnuRonde.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuRondeActionPerformed(evt);
            }
        });
        jMenuNoteDuree.add(mnuRonde);

        menuBar.add(jMenuNoteDuree);

        jMenu4.setText(resourceMap.getString("jMenu4.text")); // NOI18N
        jMenu4.setName("jMenu4"); // NOI18N

        mnuAlterationDoubleBemol.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_V, 0));
        mnuAlterationDoubleBemol.setIcon(resourceMap.getIcon("mnuAlterationDoubleBemol.icon")); // NOI18N
        mnuAlterationDoubleBemol.setText(resourceMap.getString("mnuAlterationDoubleBemol.text")); // NOI18N
        mnuAlterationDoubleBemol.setName("mnuAlterationDoubleBemol"); // NOI18N
        mnuAlterationDoubleBemol.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAlterationDoubleBemolActionPerformed(evt);
            }
        });
        jMenu4.add(mnuAlterationDoubleBemol);

        mnuAlterationBemol.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_B, 0));
        mnuAlterationBemol.setIcon(resourceMap.getIcon("mnuAlterationBemol.icon")); // NOI18N
        mnuAlterationBemol.setText(resourceMap.getString("mnuAlterationBemol.text")); // NOI18N
        mnuAlterationBemol.setName("mnuAlterationBemol"); // NOI18N
        mnuAlterationBemol.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAlterationBemolActionPerformed(evt);
            }
        });
        jMenu4.add(mnuAlterationBemol);

        mnuAlterationBecarre.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_N, 0));
        mnuAlterationBecarre.setIcon(resourceMap.getIcon("mnuAlterationBecarre.icon")); // NOI18N
        mnuAlterationBecarre.setText(resourceMap.getString("mnuAlterationBecarre.text")); // NOI18N
        mnuAlterationBecarre.setName("mnuAlterationBecarre"); // NOI18N
        mnuAlterationBecarre.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAlterationBecarreActionPerformed(evt);
            }
        });
        jMenu4.add(mnuAlterationBecarre);

        mnuAlterationDiese.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_3, 0));
        mnuAlterationDiese.setIcon(resourceMap.getIcon("mnuAlterationDiese.icon")); // NOI18N
        mnuAlterationDiese.setText(resourceMap.getString("mnuAlterationDiese.text")); // NOI18N
        mnuAlterationDiese.setName("mnuAlterationDiese"); // NOI18N
        mnuAlterationDiese.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAlterationDieseActionPerformed(evt);
            }
        });
        jMenu4.add(mnuAlterationDiese);

        mnuAlterationDoubleDiese.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_4, 0));
        mnuAlterationDoubleDiese.setIcon(resourceMap.getIcon("mnuAlterationDoubleDiese.icon")); // NOI18N
        mnuAlterationDoubleDiese.setText(resourceMap.getString("mnuAlterationDoubleDiese.text")); // NOI18N
        mnuAlterationDoubleDiese.setName("mnuAlterationDoubleDiese"); // NOI18N
        mnuAlterationDoubleDiese.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAlterationDoubleDieseActionPerformed(evt);
            }
        });
        jMenu4.add(mnuAlterationDoubleDiese);

        jSeparator2.setName("jSeparator2"); // NOI18N
        jMenu4.add(jSeparator2);

        mnuAlterationEnharmonique.setAccelerator(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_E, java.awt.event.InputEvent.CTRL_MASK));
        mnuAlterationEnharmonique.setText(resourceMap.getString("mnuAlterationEnharmonique.text")); // NOI18N
        mnuAlterationEnharmonique.setName("mnuAlterationEnharmonique"); // NOI18N
        mnuAlterationEnharmonique.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAlterationEnharmoniqueActionPerformed(evt);
            }
        });
        jMenu4.add(mnuAlterationEnharmonique);

        mnuAlterationViaTonalite.setText(resourceMap.getString("mnuAlterationViaTonalite.text")); // NOI18N
        mnuAlterationViaTonalite.setName("mnuAlterationViaTonalite"); // NOI18N
        mnuAlterationViaTonalite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuAlterationViaTonaliteActionPerformed(evt);
            }
        });
        jMenu4.add(mnuAlterationViaTonalite);

        menuBar.add(jMenu4);

        jMenu3.setText(resourceMap.getString("jMenu3.text")); // NOI18N
        jMenu3.setName("jMenu3"); // NOI18N

        mnuNouvelleVoix.setIcon(resourceMap.getIcon("mnuNouvelleVoix.icon")); // NOI18N
        mnuNouvelleVoix.setText(resourceMap.getString("mnuNouvelleVoix.text")); // NOI18N
        mnuNouvelleVoix.setName("mnuNouvelleVoix"); // NOI18N
        mnuNouvelleVoix.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuNouvelleVoixActionPerformed(evt);
            }
        });
        jMenu3.add(mnuNouvelleVoix);

        jMenuItem4.setText(resourceMap.getString("jMenuItem4.text")); // NOI18N
        jMenuItem4.setName("jMenuItem4"); // NOI18N
        jMenu3.add(jMenuItem4);

        mnuVoixNotesIndependantes.setIcon(resourceMap.getIcon("mnuVoixNotesIndependantes.icon")); // NOI18N
        mnuVoixNotesIndependantes.setText(resourceMap.getString("mnuVoixNotesIndependantes.text")); // NOI18N
        mnuVoixNotesIndependantes.setName("mnuVoixNotesIndependantes"); // NOI18N
        mnuVoixNotesIndependantes.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuVoixNotesIndependantesActionPerformed(evt);
            }
        });
        jMenu3.add(mnuVoixNotesIndependantes);

        menuBar.add(jMenu3);

        jMenu5.setText(resourceMap.getString("jMenu5.text")); // NOI18N
        jMenu5.setName("jMenu5"); // NOI18N

        mnuConfiguration.setIcon(resourceMap.getIcon("mnuConfiguration.icon")); // NOI18N
        mnuConfiguration.setText(resourceMap.getString("mnuConfiguration.text")); // NOI18N
        mnuConfiguration.setName("mnuConfiguration"); // NOI18N
        mnuConfiguration.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuConfigurationActionPerformed(evt);
            }
        });
        jMenu5.add(mnuConfiguration);

        menuBar.add(jMenu5);

        helpMenu.setIcon(resourceMap.getIcon("helpMenu.icon")); // NOI18N
        helpMenu.setText(resourceMap.getString("helpMenu.text")); // NOI18N
        helpMenu.setName("helpMenu"); // NOI18N

        aboutMenuItem.setAction(actionMap.get("showAboutBox")); // NOI18N
        aboutMenuItem.setText(resourceMap.getString("aboutMenuItem.text")); // NOI18N
        aboutMenuItem.setName("aboutMenuItem"); // NOI18N
        helpMenu.add(aboutMenuItem);

        jMenuItem8.setIcon(resourceMap.getIcon("jMenuItem8.icon")); // NOI18N
        jMenuItem8.setText(resourceMap.getString("jMenuItem8.text")); // NOI18N
        jMenuItem8.setName("jMenuItem8"); // NOI18N
        jMenuItem8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem8ActionPerformed(evt);
            }
        });
        helpMenu.add(jMenuItem8);

        menuBar.add(helpMenu);

        jMenu1.setIcon(resourceMap.getIcon("jMenu1.icon")); // NOI18N
        jMenu1.setText(resourceMap.getString("jMenu1.text")); // NOI18N
        jMenu1.setName("jMenu1"); // NOI18N

        jMenuItem1.setText(resourceMap.getString("jMenuItem1.text")); // NOI18N
        jMenuItem1.setName("jMenuItem1"); // NOI18N
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem1);

        mnuRepaint.setText(resourceMap.getString("mnuRepaint.text")); // NOI18N
        mnuRepaint.setName("mnuRepaint"); // NOI18N
        mnuRepaint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mnuRepaintActionPerformed(evt);
            }
        });
        jMenu1.add(mnuRepaint);

        menuBar.add(jMenu1);

        statusPanel.setName("statusPanel"); // NOI18N
        statusPanel.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                statusPanelKeyTyped(evt);
            }
        });

        statusPanelSeparator.setName("statusPanelSeparator"); // NOI18N

        statusMessageLabel.setName("statusMessageLabel"); // NOI18N

        statusAnimationLabel.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        statusAnimationLabel.setName("statusAnimationLabel"); // NOI18N

        progressBar.setName("progressBar"); // NOI18N

        javax.swing.GroupLayout statusPanelLayout = new javax.swing.GroupLayout(statusPanel);
        statusPanel.setLayout(statusPanelLayout);
        statusPanelLayout.setHorizontalGroup(
            statusPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(statusPanelSeparator, javax.swing.GroupLayout.DEFAULT_SIZE, 577, Short.MAX_VALUE)
            .addGroup(statusPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(statusMessageLabel)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 403, Short.MAX_VALUE)
                .addComponent(progressBar, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(statusAnimationLabel)
                .addContainerGap())
        );
        statusPanelLayout.setVerticalGroup(
            statusPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(statusPanelLayout.createSequentialGroup()
                .addComponent(statusPanelSeparator, javax.swing.GroupLayout.PREFERRED_SIZE, 2, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(statusPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(statusMessageLabel)
                    .addComponent(statusAnimationLabel)
                    .addComponent(progressBar, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(3, 3, 3))
        );

        panelGeneral.setName("panelGeneral"); // NOI18N
        panelGeneral.setLayout(new javax.swing.BoxLayout(panelGeneral, javax.swing.BoxLayout.LINE_AXIS));

        panelTravail.setName("panelTravail"); // NOI18N
        panelTravail.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                panelTravailKeyPressed(evt);
            }
        });
        panelTravail.setLayout(new javax.swing.BoxLayout(panelTravail, javax.swing.BoxLayout.Y_AXIS));

        panBarreOutils.setMaximumSize(new java.awt.Dimension(2147483647, 63));
        panBarreOutils.setMinimumSize(new java.awt.Dimension(531, 63));
        panBarreOutils.setName("panBarreOutils"); // NOI18N
        panBarreOutils.setLayout(new java.awt.CardLayout());

        jToolBar3.setFloatable(false);
        jToolBar3.setRollover(true);
        jToolBar3.setName("jToolBar3"); // NOI18N

        boutonSortieMIDIReprendre.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonSortieMIDIReprendre.setIcon(resourceMap.getIcon("boutonSortieMIDIReprendre.icon")); // NOI18N
        boutonSortieMIDIReprendre.setText(resourceMap.getString("boutonSortieMIDIReprendre.text")); // NOI18N
        boutonSortieMIDIReprendre.setToolTipText(resourceMap.getString("boutonSortieMIDIReprendre.toolTipText")); // NOI18N
        boutonSortieMIDIReprendre.setFocusable(false);
        boutonSortieMIDIReprendre.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonSortieMIDIReprendre.setName("boutonSortieMIDIReprendre"); // NOI18N
        boutonSortieMIDIReprendre.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonSortieMIDIReprendre.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonSortieMIDIReprendreActionPerformed(evt);
            }
        });
        jToolBar3.add(boutonSortieMIDIReprendre);

        boutonPause1.setFont(resourceMap.getFont("boutonPause1.font")); // NOI18N
        boutonPause1.setIcon(resourceMap.getIcon("boutonPause1.icon")); // NOI18N
        boutonPause1.setText(resourceMap.getString("boutonPause1.text")); // NOI18N
        boutonPause1.setToolTipText(resourceMap.getString("boutonPause1.toolTipText")); // NOI18N
        boutonPause1.setFocusable(false);
        boutonPause1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonPause1.setName("boutonPause1"); // NOI18N
        boutonPause1.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonPause1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonPauseActionPerformed(evt);
            }
        });
        jToolBar3.add(boutonPause1);

        boutonMIDIStop1.setFont(resourceMap.getFont("boutonMIDIStop1.font")); // NOI18N
        boutonMIDIStop1.setIcon(resourceMap.getIcon("boutonMIDIStop1.icon")); // NOI18N
        boutonMIDIStop1.setText(resourceMap.getString("boutonMIDIStop1.text")); // NOI18N
        boutonMIDIStop1.setToolTipText(resourceMap.getString("boutonMIDIStop1.toolTipText")); // NOI18N
        boutonMIDIStop1.setFocusable(false);
        boutonMIDIStop1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonMIDIStop1.setName("boutonMIDIStop1"); // NOI18N
        boutonMIDIStop1.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonMIDIStop1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonMIDIStopActionPerformed(evt);
            }
        });
        jToolBar3.add(boutonMIDIStop1);

        jLabel1.setText(resourceMap.getString("jLabel1.text")); // NOI18N
        jLabel1.setName("jLabel1"); // NOI18N
        jToolBar3.add(jLabel1);

        jLabel4.setIcon(resourceMap.getIcon("jLabel4.icon")); // NOI18N
        jLabel4.setText(resourceMap.getString("jLabel4.text")); // NOI18N
        jLabel4.setName("jLabel4"); // NOI18N
        jToolBar3.add(jLabel4);

        jSliderLectureVitesse.setMaximum(200);
        jSliderLectureVitesse.setMinimum(1);
        jSliderLectureVitesse.setValue(100);
        jSliderLectureVitesse.setMaximumSize(new java.awt.Dimension(150, 23));
        jSliderLectureVitesse.setName("jSliderLectureVitesse"); // NOI18N
        jToolBar3.add(jSliderLectureVitesse);

        jLabel5.setIcon(resourceMap.getIcon("jLabel5.icon")); // NOI18N
        jLabel5.setText(resourceMap.getString("jLabel5.text")); // NOI18N
        jLabel5.setName("jLabel5"); // NOI18N
        jToolBar3.add(jLabel5);

        panBarreOutils.add(jToolBar3, "modeLecture");

        toolBarSelection.setFloatable(false);
        toolBarSelection.setRollover(true);
        toolBarSelection.setName("toolBarSelection"); // NOI18N

        lblSelectionPlus.setBackground(resourceMap.getColor("lblSelectionPlus.background")); // NOI18N
        lblSelectionPlus.setText(resourceMap.getString("lblSelectionPlus.text")); // NOI18N
        lblSelectionPlus.setName("lblSelectionPlus"); // NOI18N
        toolBarSelection.add(lblSelectionPlus);

        jButton1.setIcon(resourceMap.getIcon("jButton1.icon")); // NOI18N
        jButton1.setText(resourceMap.getString("jButton1.text")); // NOI18N
        jButton1.setFocusable(false);
        jButton1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton1.setName("jButton1"); // NOI18N
        jButton1.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        toolBarSelection.add(jButton1);

        jButton2.setIcon(resourceMap.getIcon("jButton2.icon")); // NOI18N
        jButton2.setText(resourceMap.getString("jButton2.text")); // NOI18N
        jButton2.setFocusable(false);
        jButton2.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton2.setName("jButton2"); // NOI18N
        jButton2.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });
        toolBarSelection.add(jButton2);

        selectionDureePanel.setMaximumSize(new java.awt.Dimension(60, 2147483647));
        selectionDureePanel.setName("selectionDureePanel"); // NOI18N
        toolBarSelection.add(selectionDureePanel);

        panBarreOutils.add(toolBarSelection, "modeSelection");

        toolBarEcriture.setFloatable(false);
        toolBarEcriture.setRollover(true);
        toolBarEcriture.setFont(resourceMap.getFont("toolBarEcriture.font")); // NOI18N
        toolBarEcriture.setMaximumSize(new java.awt.Dimension(811, 63));
        toolBarEcriture.setMinimumSize(new java.awt.Dimension(767, 63));
        toolBarEcriture.setName("toolBarEcriture"); // NOI18N
        toolBarEcriture.setPreferredSize(new java.awt.Dimension(811, 63));

        boutonOuvrir.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonOuvrir.setIcon(resourceMap.getIcon("boutonOuvrir.icon")); // NOI18N
        boutonOuvrir.setText(resourceMap.getString("boutonOuvrir.text")); // NOI18N
        boutonOuvrir.setToolTipText(resourceMap.getString("boutonOuvrir.toolTipText")); // NOI18N
        boutonOuvrir.setFocusable(false);
        boutonOuvrir.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonOuvrir.setName("boutonOuvrir"); // NOI18N
        boutonOuvrir.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonOuvrir.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonOuvrirActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonOuvrir);

        boutonSauvegarder.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonSauvegarder.setIcon(resourceMap.getIcon("boutonSauvegarder.icon")); // NOI18N
        boutonSauvegarder.setText(resourceMap.getString("boutonSauvegarder.text")); // NOI18N
        boutonSauvegarder.setToolTipText(resourceMap.getString("boutonSauvegarder.toolTipText")); // NOI18N
        boutonSauvegarder.setFocusable(false);
        boutonSauvegarder.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonSauvegarder.setName("boutonSauvegarder"); // NOI18N
        boutonSauvegarder.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonSauvegarder.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonSauvegarderActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonSauvegarder);

        boutonImprimer.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonImprimer.setIcon(resourceMap.getIcon("boutonImprimer.icon")); // NOI18N
        boutonImprimer.setText(resourceMap.getString("boutonImprimer.text")); // NOI18N
        boutonImprimer.setToolTipText(resourceMap.getString("boutonImprimer.toolTipText")); // NOI18N
        boutonImprimer.setFocusable(false);
        boutonImprimer.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonImprimer.setName("boutonImprimer"); // NOI18N
        boutonImprimer.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonImprimer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonImprimerActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonImprimer);

        boutonAnnuler.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonAnnuler.setIcon(resourceMap.getIcon("boutonAnnuler.icon")); // NOI18N
        boutonAnnuler.setText(resourceMap.getString("boutonAnnuler.text")); // NOI18N
        boutonAnnuler.setToolTipText(resourceMap.getString("boutonAnnuler.toolTipText")); // NOI18N
        boutonAnnuler.setFocusable(false);
        boutonAnnuler.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonAnnuler.setName("boutonAnnuler"); // NOI18N
        boutonAnnuler.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonAnnuler.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonAnnulerActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonAnnuler);

        boutonRefaire.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonRefaire.setIcon(resourceMap.getIcon("boutonRefaire.icon")); // NOI18N
        boutonRefaire.setText(resourceMap.getString("boutonRefaire.text")); // NOI18N
        boutonRefaire.setToolTipText(resourceMap.getString("boutonRefaire.toolTipText")); // NOI18N
        boutonRefaire.setFocusable(false);
        boutonRefaire.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonRefaire.setName("boutonRefaire"); // NOI18N
        boutonRefaire.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonRefaire.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonRefaireActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonRefaire);

        boutonEntreeMIDIEnregistrer.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonEntreeMIDIEnregistrer.setIcon(resourceMap.getIcon("boutonEntreeMIDIEnregistrer.icon")); // NOI18N
        boutonEntreeMIDIEnregistrer.setText(resourceMap.getString("boutonEntreeMIDIEnregistrer.text")); // NOI18N
        boutonEntreeMIDIEnregistrer.setToolTipText(resourceMap.getString("boutonEntreeMIDIEnregistrer.toolTipText")); // NOI18N
        boutonEntreeMIDIEnregistrer.setFocusable(false);
        boutonEntreeMIDIEnregistrer.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonEntreeMIDIEnregistrer.setName("boutonEntreeMIDIEnregistrer"); // NOI18N
        boutonEntreeMIDIEnregistrer.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonEntreeMIDIEnregistrer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonEntreeMIDIEnregistrerActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonEntreeMIDIEnregistrer);

        boutonSortieMIDILecture.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonSortieMIDILecture.setIcon(resourceMap.getIcon("boutonSortieMIDILecture.icon")); // NOI18N
        boutonSortieMIDILecture.setText(resourceMap.getString("boutonSortieMIDILecture.text")); // NOI18N
        boutonSortieMIDILecture.setToolTipText(resourceMap.getString("boutonSortieMIDILecture.toolTipText")); // NOI18N
        boutonSortieMIDILecture.setFocusable(false);
        boutonSortieMIDILecture.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonSortieMIDILecture.setName("boutonSortieMIDILecture"); // NOI18N
        boutonSortieMIDILecture.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonSortieMIDILecture.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonSortieMIDILectureActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonSortieMIDILecture);

        boutonPause.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonPause.setIcon(resourceMap.getIcon("boutonPause.icon")); // NOI18N
        boutonPause.setText(resourceMap.getString("boutonPause.text")); // NOI18N
        boutonPause.setToolTipText(resourceMap.getString("boutonPause.toolTipText")); // NOI18N
        boutonPause.setFocusable(false);
        boutonPause.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonPause.setName("boutonPause"); // NOI18N
        boutonPause.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonPause.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonPauseActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonPause);

        boutonMIDIStop.setFont(resourceMap.getFont("boutonRefaire.font")); // NOI18N
        boutonMIDIStop.setIcon(resourceMap.getIcon("boutonMIDIStop.icon")); // NOI18N
        boutonMIDIStop.setText(resourceMap.getString("boutonMIDIStop.text")); // NOI18N
        boutonMIDIStop.setToolTipText(resourceMap.getString("boutonMIDIStop.toolTipText")); // NOI18N
        boutonMIDIStop.setFocusable(false);
        boutonMIDIStop.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonMIDIStop.setName("boutonMIDIStop"); // NOI18N
        boutonMIDIStop.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonMIDIStop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonMIDIStopActionPerformed(evt);
                boutonEntreeMIDIStopActionPerformed(evt);
            }
        });
        toolBarEcriture.add(boutonMIDIStop);

        dureePanel.setMaximumSize(new java.awt.Dimension(60, 2147483647));
        dureePanel.setName("dureePanel"); // NOI18N
        toolBarEcriture.add(dureePanel);

        jPanel1.setName("jPanel1"); // NOI18N
        jPanel1.setLayout(new javax.swing.BoxLayout(jPanel1, javax.swing.BoxLayout.PAGE_AXIS));

        jLabel2.setText(resourceMap.getString("jLabel2.text")); // NOI18N
        jLabel2.setName("jLabel2"); // NOI18N
        jPanel1.add(jLabel2);

        jLabel3.setText(resourceMap.getString("jLabel3.text")); // NOI18N
        jLabel3.setName("jLabel3"); // NOI18N
        jPanel1.add(jLabel3);

        toolBarEcriture.add(jPanel1);

        panBarreOutils.add(toolBarEcriture, "modeEcriture");

        panelTravail.add(panBarreOutils);

        jScrollPane.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane.setName("jScrollPane"); // NOI18N
        jScrollPane.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                jScrollPaneComponentResized(evt);
            }
        });

        partitionPanel.setName("jPanel"); // NOI18N
        partitionPanel.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                partitionPanelMouseClicked(evt);
            }
        });
        partitionPanel.addInputMethodListener(new java.awt.event.InputMethodListener() {
            public void caretPositionChanged(java.awt.event.InputMethodEvent evt) {
            }
            public void inputMethodTextChanged(java.awt.event.InputMethodEvent evt) {
                partitionPanelInputMethodTextChanged(evt);
            }
        });
        partitionPanel.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                partitionPanelKeyPressed(evt);
            }
        });

        javax.swing.GroupLayout partitionPanelLayout = new javax.swing.GroupLayout(partitionPanel);
        partitionPanel.setLayout(partitionPanelLayout);
        partitionPanelLayout.setHorizontalGroup(
            partitionPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 969, Short.MAX_VALUE)
        );
        partitionPanelLayout.setVerticalGroup(
            partitionPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 349, Short.MAX_VALUE)
        );

        jScrollPane.setViewportView(partitionPanel);

        panelTravail.add(jScrollPane);

        panelGeneral.add(panelTravail);

        panAide.setMaximumSize(new java.awt.Dimension(200, 22000000));
        panAide.setMinimumSize(new java.awt.Dimension(200, 290));
        panAide.setName("panAide"); // NOI18N
        panAide.setPreferredSize(new java.awt.Dimension(200, 400));
        panAide.setLayout(new java.awt.BorderLayout());

        helpPanel.setMaximumSize(new java.awt.Dimension(200, 2147483647));
        helpPanel.setName("helpPanel"); // NOI18N
        panAide.add(helpPanel, java.awt.BorderLayout.CENTER);

        panelGeneral.add(panAide);

        setComponent(panelGeneral);
        setMenuBar(menuBar);
    }// </editor-fold>//GEN-END:initComponents

private void boutonEntreeMIDIEnregistrerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonEntreeMIDIEnregistrerActionPerformed
// TODO add your handling code here:
    if(!InterfaceMIDI.isMIDIDeviceEntreeDisponible())
    {
        Erreur.message("Je ne trouve pas de clavier, synthétiseur ou autres branché à l'ordinateur.");
        return;
    }


    debuterLecture(getPartitionDonnees().getMomentDebut());
    partitionLecteur.setPasArretFinPartition();
    

    machineEntreeMIDI = new MachineEntreeMIDI(
                            InterfaceMIDI.getMIDIDeviceEntreeAuPif(),
                           new PartitionScribe(getPartitionDonnees(), (PartitionPanel) partitionPanel, partitionLecteur));
    
    boutonMIDIStop.setVisible(true);
    boutonEntreeMIDIEnregistrer.setVisible(false);
    boutonSortieMIDILecture.setVisible(false);

    modeEnregistrementMIDI();

}//GEN-LAST:event_boutonEntreeMIDIEnregistrerActionPerformed


public void midiStop()
{
     if(machineEntreeMIDI != null)
    {
        machineEntreeMIDI.arreter();
        getPartitionPanel().enregistrementArreter();
    }

    if(partitionLecteur != null)
    {
         partitionLecteur.arreter();
    }

    modeEcriture();
    boutonMIDIStop.setVisible(false);
    boutonPause.setVisible(false);
    boutonSortieMIDIReprendre.setVisible(false);
    boutonEntreeMIDIEnregistrer.setVisible(true);
    boutonSortieMIDILecture.setVisible(true);
}


private void boutonMIDIStopActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonMIDIStopActionPerformed
// TODO add your handling code here:
   midiStop();
}//GEN-LAST:event_boutonMIDIStopActionPerformed

private void partitionPanelMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_partitionPanelMouseClicked
// TODO add your handling code here:
}//GEN-LAST:event_partitionPanelMouseClicked


public void debuterLecture(Moment moment)
{
    partitionLecteur = new PartitionLecteur(getPartitionDonnees(),
                                            getPartitionDonnees().getMomentDebut(),
                                            machineSortieMIDI,
                                            getPartitionPanel(), this);

   vitesseInterfaceToPartitionLecteur();

   partitionLecteur.setMomentActuel(moment);
   partitionLecteur.start();

   modeLecture();
   boutonMIDIStop.setVisible(true);
   boutonPause.setVisible(true);
   boutonSortieMIDIReprendre.setVisible(false);
   boutonEntreeMIDIEnregistrer.setVisible(false);
   boutonSortieMIDILecture.setVisible(false);
}




private void boutonSortieMIDILectureActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonSortieMIDILectureActionPerformed
   debuterLecture(getPartitionDonnees().getMomentDebut());
  
}//GEN-LAST:event_boutonSortieMIDILectureActionPerformed

private void jScrollPaneComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_jScrollPaneComponentResized
// TODO add your handling code here:
   partitionVueAdapterALEcran();
   
}//GEN-LAST:event_jScrollPaneComponentResized

private void boutonAnnulerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonAnnulerActionPerformed
// TODO add your handling code here:
    if(histoire.isAnnulerPossible())
    {
        histoire.annulerLaDerniereAction();
        partitionPanel.repaint();
    }
    else
        Toolkit.getDefaultToolkit().beep(); 
    
}//GEN-LAST:event_boutonAnnulerActionPerformed

private void boutonRefaireActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonRefaireActionPerformed
// TODO add your handling code here:
    if(histoire.isRefairePossible())
    {
        histoire.refaireLaDerniereAction();
        partitionPanel.repaint();
    }
    else
        Toolkit.getDefaultToolkit().beep(); 
}//GEN-LAST:event_boutonRefaireActionPerformed

private void panelTravailKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_panelTravailKeyPressed
// TODO add your handling code here:

}//GEN-LAST:event_panelTravailKeyPressed

private void partitionPanelInputMethodTextChanged(java.awt.event.InputMethodEvent evt) {//GEN-FIRST:event_partitionPanelInputMethodTextChanged
// TODO add your handling code here:
}//GEN-LAST:event_partitionPanelInputMethodTextChanged

private void partitionPanelKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_partitionPanelKeyPressed
// TODO add your handling code here:

    if(evt.getKeyCode() == KeyEvent.VK_DOWN)//enharmonie
    {
        if(getPartitionPanel().isSelection())
        {
            histoire.executer(
                    new PartitionActionSelectionPorteeChanger(
                          getPartitionDonnees(),
                          getPartitionPanel().getSelection(),
                          1));
            partitionVue.calculer();
            getPartitionPanel().repaint();
        }         
    }
    
    
    if(evt.getKeyCode() == KeyEvent.VK_UP)//enharmonie
    {
        if(getPartitionPanel().isSelection())
        {
            histoire.executer(
                    new PartitionActionSelectionPorteeChanger(
                          getPartitionDonnees(),
                          getPartitionPanel().getSelection(),
                          -1));
            partitionVue.calculer();
            getPartitionPanel().repaint();
        }         
    }
   
    
    

}//GEN-LAST:event_partitionPanelKeyPressed

private void statusPanelKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_statusPanelKeyTyped
// TODO add your handling code here:
           
}//GEN-LAST:event_statusPanelKeyTyped


private String demanderFichierNomPourSauvegarder()
{
    JFileChooser fc = new JFileChooser();
    fc.setDialogTitle("Sauvegarder la partition dans un fichier...");
    fc.setFileFilter(getFileFilter());
    if(fc.showSaveDialog(null) == JFileChooser.APPROVE_OPTION)
    {
        return fc.getSelectedFile().getAbsolutePath();
    }
    else
        return null;
}



private FileFilter getFileFilter()
{
   return new FileFilter() {
            @Override
            public boolean accept(File f) {
                if(f.isDirectory())
                    return true;
                else
                    return f.getName().endsWith(".xml");
            }

            @Override
            public String getDescription() {
                return "Fichier MusicXML (*.xml)";
            }
        };
}


private void open()
{
    JFileChooser fc = new JFileChooser();
    
    fc.setDialogTitle("Ouvrir une partition d'un fichier...");
    fc.setFileFilter(getFileFilter());
    if(fc.showOpenDialog(null) == JFileChooser.APPROVE_OPTION)
    {
        String fichierNomAOuvrir = fc.getSelectedFile().getAbsolutePath();

        try {
            cursorTravail();
            declarerPartitionDonnees(
               PartitionDonneesChargement.getPartitionDonneesDuFichier(fichierNomAOuvrir)
                        );
            partitionVueAdapterALEcran();
            getPartitionPanel().repaint();
            setFichierNom(fichierNomAOuvrir);
            cursorRepos();
        } catch (JDOMException ex) {
            cursorRepos();
            Erreur.message("Je suis désolé : ton fichier existe mais je n'arrive pas à l'interpréter.");
        } catch (IOException ex) {
            cursorRepos();
            Erreur.message("Je suis désolé : je n'ai pas réussi à lire le fichier.");
        }

        
    }    
        
    
    
}



private void cursorTravail()
{
    getFrame().setCursor(new Cursor(Cursor.WAIT_CURSOR));
}

private void cursorRepos()
{
    getFrame().setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
}


private boolean save()
// commande Fichier, Sauvegarder.
// retourne TRUE ssi une sauvegarde a eu lieu
{
    String fichierNomASauvegarder = fichierNom;
    
    if(fichierNom == null)
         fichierNomASauvegarder = demanderFichierNomPourSauvegarder();
    
    if(fichierNomASauvegarder != null)
    {
            try {
                cursorTravail();
                sauvegarde.sauvegarder(fichierNomASauvegarder);
                setFichierNom(fichierNomASauvegarder);
                cursorRepos();
                return true;
            } catch (IOException ex) 
            {
                Erreur.message("Je suis désolé : je n'ai pas réussi à écrire dans le fichier.");
                cursorRepos();
                return false;
            }
        
     }
    return false;
}



private void saveAs()
{

    String fichierNomASauvegarder = demanderFichierNomPourSauvegarder();
    
    if(fichierNomASauvegarder != null)
    {
            try {
                sauvegarde.sauvegarder(fichierNomASauvegarder);
                setFichierNom(fichierNomASauvegarder);
            } catch (IOException ex)
            {
                Erreur.message("Je suis désolé : je n'ai pas réussi à écrire dans le fichier.");
            }
        
     }
}

private void boutonSauvegarderActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonSauvegarderActionPerformed
// TODO add your handling code here:
   save();
  
}//GEN-LAST:event_boutonSauvegarderActionPerformed


/**
 * S'occupe de demander s'il faut sauvegarder la partition
 * Affiche une boite de dialogue "tu veux sauvegarder ?"
 * Puis si il y a besoin, propose un lieu pour sauvegarder la partition !
 * @return true ssi il est vraiment sûr que l'on ne perd pas de données ! :)
 */
public boolean closeConfirmation()
{
    if(getPartitionDonnees().isModifie())
    {
        int option = JOptionPane.showConfirmDialog(null,
                        "Veux-tu sauvegarder la partition ?",
                        "Schwarz Musicwriter", JOptionPane.YES_NO_CANCEL_OPTION);
        
        switch(option)
        {
            case JOptionPane.YES_OPTION: return save();
            case JOptionPane.NO_OPTION: return true;
            case JOptionPane.CANCEL_OPTION: return false;
            default: return false;
        }
    }
    else
        return true;
    
}




private void boutonOuvrirActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonOuvrirActionPerformed
// TODO add your handling code here:
    open();
    
    
}//GEN-LAST:event_boutonOuvrirActionPerformed

private void boutonImprimerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonImprimerActionPerformed
// TODO add your handling code here:
    PartitionImpression impression = new PartitionImpression(getPartitionDonnees());
    impression.imprimer();
    
}//GEN-LAST:event_boutonImprimerActionPerformed

private void boutonEntreeMIDIStopActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonEntreeMIDIStopActionPerformed
// TODO add your handling code here:
}//GEN-LAST:event_boutonEntreeMIDIStopActionPerformed

private void boutonPauseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonPauseActionPerformed
// TODO add your handling code here:
    partitionLecteur.pause();
    boutonPause.setVisible(false);
    boutonSortieMIDIReprendre.setVisible(true);
}//GEN-LAST:event_boutonPauseActionPerformed

private void boutonSortieMIDIReprendreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonSortieMIDIReprendreActionPerformed
// TODO add your handling code here:
    partitionLecteur.reprendre();
    boutonPause.setVisible(true);
    boutonSortieMIDIReprendre.setVisible(false);
}//GEN-LAST:event_boutonSortieMIDIReprendreActionPerformed

private void jMenuItemCrocheActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCrocheActionPerformed
// TODO add your handling code here:
    ((PartitionPanel) partitionPanel).dureeEntreeTraiter(new Duree(new Rational(1, 2)));
}//GEN-LAST:event_jMenuItemCrocheActionPerformed

private void jMenuItemNoireActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemNoireActionPerformed
// TODO add your handling code here:
    ((PartitionPanel) partitionPanel).dureeEntreeTraiter(new Duree(new Rational(1, 1)));
}//GEN-LAST:event_jMenuItemNoireActionPerformed

private void jMenuItemBlancheActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemBlancheActionPerformed
// TODO add your handling code here:
    ((PartitionPanel) partitionPanel).dureeEntreeTraiter(new Duree(new Rational(2, 1)));
}//GEN-LAST:event_jMenuItemBlancheActionPerformed

private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
// TODO add your handling code here:
    for(int i = 0; i < 10000;i++)
    {
        Note n = new Note(new Moment(new Rational(i, 8)),
                new Duree(new Rational(1, 8)),
                new Hauteur((int) Math.round(Math.random() * 10), Alteration.NATUREL), 
                getPartitionDonnees().getPorteePremiere());
         getPartitionDonnees().elementMusicalAjouter(n);
    }
    
     partitionVue.calculer();
     partitionPanel.repaint();
}//GEN-LAST:event_jMenuItem1ActionPerformed

private void mnuNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuNewActionPerformed
// TODO add your handling code here:
    if(closeConfirmation())
    {
        PartitionDonnees nouvellePartition = getPartitionDonneesNouvellePourPiano();
        PartitionPartiesDialog d = new PartitionPartiesDialog(getFrame(), true, nouvellePartition);
        d.setVisible(true );
        if(!d.isAnnule())
        {
            declarerPartitionDonnees( nouvellePartition );
            partitionVueAdapterALEcran();
            getPartitionPanel().repaint();
            nomFichier_Aucun();
        }
    }
    
}//GEN-LAST:event_mnuNewActionPerformed



private void setFichierNom(String fichierNom)
{
    this.fichierNom = fichierNom;
    this.getFrame().setTitle("Schwarz Musicwriter - " + fichierNom);
}

private void mnuRepaintActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuRepaintActionPerformed
// TODO add your handling code here:
    getPartitionPanel().calculer();
    getPartitionPanel().repaint();
}//GEN-LAST:event_mnuRepaintActionPerformed

private void mnuCutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuCutActionPerformed
// TODO add your handling code here:
    Selection selection = getPartitionPanel().getSelection();
    
    if(selection != null)
    {
        pressePapierCopier();
        histoire.executer(new PartitionActionSelectionSupprimer(selection));

        getPartitionPanel().calculer();
        getPartitionPanel().repaint();
    }
}//GEN-LAST:event_mnuCutActionPerformed


private void pressePapierCopier()
{
    Selection selection = getPartitionPanel().getSelection();
    
    if(selection != null)
    {
        pressePapier = selection.clone();
        for(ElementMusical el : pressePapier)    
        {
            if(el instanceof Note)
                ((Note) el).transposer(Intervalle.getIntervalleOctave());
            //el.deplacer((new Duree(1, 2)).getFinMoment(el.getDebutMoment()) );

        }
        
    }
}
private void mnuCopyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuCopyActionPerformed

    pressePapierCopier();
}//GEN-LAST:event_mnuCopyActionPerformed

private void mnuPasteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuPasteActionPerformed
    histoire.executer((new PartitionActionPaste(pressePapier)));
    getPartitionPanel().calculer();
    getPartitionPanel().setSelection(pressePapier);
    getPartitionPanel().repaint();
}//GEN-LAST:event_mnuPasteActionPerformed

private void mnuDoubleCrocheActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuDoubleCrocheActionPerformed
// TODO add your handling code here:
    ((PartitionPanel) partitionPanel).dureeEntreeTraiter(new Duree(new Rational(1, 4)));
}//GEN-LAST:event_mnuDoubleCrocheActionPerformed

private void mnuTripleCrocheActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuTripleCrocheActionPerformed
// TODO add your handling code here:
    ((PartitionPanel) partitionPanel).dureeEntreeTraiter(new Duree(new Rational(1, 8)));
}//GEN-LAST:event_mnuTripleCrocheActionPerformed

private void mnuRondeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuRondeActionPerformed
// TODO add your handling code here:
    ((PartitionPanel) partitionPanel).dureeEntreeTraiter(new Duree(new Rational(4, 1)));
}//GEN-LAST:event_mnuRondeActionPerformed

private void mnuVoixNotesIndependantesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuVoixNotesIndependantesActionPerformed
// TODO add your handling code here:
    histoire.executer(new PartitionActionSelectionPasDeVoix(getPartitionPanel().getSelection()));
    getPartitionPanel().calculer();
    getPartitionPanel().repaint();
}//GEN-LAST:event_mnuVoixNotesIndependantesActionPerformed

private void mnuNouvelleVoixActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuNouvelleVoixActionPerformed
    histoire.executer(new PartitionActionSelectionVoixSet(getPartitionPanel().getSelection(), new Voix()));
    getPartitionPanel().calculer();
    getPartitionPanel().repaint();
}//GEN-LAST:event_mnuNouvelleVoixActionPerformed

private void mnuAnnulerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAnnulerActionPerformed
// TODO add your handling code here:
    if(histoire.isAnnulerPossible())
    {
        getPartitionPanel().selectionAbandonner();
        histoire.annulerLaDerniereAction();
        partitionPanel.repaint();
    }
    else
        Toolkit.getDefaultToolkit().beep(); 
    
}//GEN-LAST:event_mnuAnnulerActionPerformed

private void mnuRefaireActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuRefaireActionPerformed
// TODO add your handling code here:
    if(histoire.isRefairePossible())
    {
        getPartitionPanel().selectionAbandonner();
        histoire.refaireLaDerniereAction();
        partitionPanel.repaint();
    }
    else
        Toolkit.getDefaultToolkit().beep(); 
    
}//GEN-LAST:event_mnuRefaireActionPerformed

private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem5ActionPerformed
    save();
}//GEN-LAST:event_jMenuItem5ActionPerformed

private void jMenuItem6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem6ActionPerformed
    saveAs();
}//GEN-LAST:event_jMenuItem6ActionPerformed

private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
// TODO add your handling code here:
    open();
}//GEN-LAST:event_jMenuItem3ActionPerformed


private void selectionAlterer(Hauteur.Alteration alteration)
{
        if(getPartitionPanel().isSelection())
            //s'il y a une sélection, on l'altère
        {
            histoire.executer(
                    new PartitionActionSelectionAlterer(
                          getPartitionPanel().getSelection(),
                          alteration));
            partitionVue.calculer();
            getPartitionPanel().repaint();
        }
        else if(getPartitionPanel().getCurseurSouris().isSurNote())
            //si le curseur est sous une note, on l'altère
        {
            histoire.executer(new PartitionActionNoteAlterer(
                    getPartitionPanel().getCurseurSouris().getNote(), alteration));
            partitionVue.calculer();
            getPartitionPanel().repaint();
        }
}
private void mnuAlterationDoubleBemolActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAlterationDoubleBemolActionPerformed
       selectionAlterer(Alteration.DOUBLEBEMOL);
}//GEN-LAST:event_mnuAlterationDoubleBemolActionPerformed

private void mnuAlterationBemolActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAlterationBemolActionPerformed
    selectionAlterer(Alteration.BEMOL);
}//GEN-LAST:event_mnuAlterationBemolActionPerformed

private void mnuAlterationBecarreActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAlterationBecarreActionPerformed
    selectionAlterer(Alteration.NATUREL);
}//GEN-LAST:event_mnuAlterationBecarreActionPerformed

private void mnuAlterationDieseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAlterationDieseActionPerformed
    selectionAlterer(Alteration.DIESE);
}//GEN-LAST:event_mnuAlterationDieseActionPerformed

private void mnuAlterationDoubleDieseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAlterationDoubleDieseActionPerformed
    selectionAlterer(Alteration.DOUBLEDIESE);
}//GEN-LAST:event_mnuAlterationDoubleDieseActionPerformed

private void mnuAlterationEnharmoniqueActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAlterationEnharmoniqueActionPerformed
        if(getPartitionPanel().isSelection())
        {
            histoire.executer(
                    new PartitionActionSelectionEnharmonique(
                          getPartitionPanel().getSelection()));

            getPartitionPanel().repaint();
        }
}//GEN-LAST:event_mnuAlterationEnharmoniqueActionPerformed

private void mnuAlterationViaTonaliteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuAlterationViaTonaliteActionPerformed
    // TODO add your handling code here:
}//GEN-LAST:event_mnuAlterationViaTonaliteActionPerformed

private void mnuEditionSupprimerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuEditionSupprimerActionPerformed
        if(getPartitionPanel().isSelection())
        {
            histoire.executer(
                    new PartitionActionSelectionSupprimer(
                          getPartitionPanel().getSelection()
                          ));
            partitionVue.calculer(getPartitionPanel().getSelection().getDebutMoment());
            getPartitionPanel().selectionAbandonner();
            getPartitionPanel().repaint();
        }
}//GEN-LAST:event_mnuEditionSupprimerActionPerformed

private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
    PartitionPartiesDialog d = new PartitionPartiesDialog(getFrame(), true, getPartitionDonnees());
    d.setVisible(true);
    partitionVue.calculer();
    getPartitionPanel().repaint();
}//GEN-LAST:event_jMenuItem2ActionPerformed

private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
    histoire.executer(new PartitionActionSelectionVoixSet(getPartitionPanel().getSelection(), new Voix()));
    getPartitionPanel().calculer();
    getPartitionPanel().repaint();
}//GEN-LAST:event_jButton1ActionPerformed



private void vitesseInterfaceToPartitionLecteur()
{
    partitionLecteur.setVitesse(((double) jSliderLectureVitesse.getValue()) / 100.0);
}


private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
    histoire.executer(new PartitionActionSelectionPasDeVoix(getPartitionPanel().getSelection()));
    getPartitionPanel().calculer();
    getPartitionPanel().repaint();
}//GEN-LAST:event_jButton2ActionPerformed

private void jMenuItem8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem8ActionPerformed
    panAide.setVisible(!panAide.isVisible());
}//GEN-LAST:event_jMenuItem8ActionPerformed

private void mnuConfigurationActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuConfigurationActionPerformed
    dialogueConfiguration.setVisible(true);
    machineSortieMIDI_creer(dialogueConfiguration.machineSortieMIDINumeroGet());
}//GEN-LAST:event_mnuConfigurationActionPerformed

private void mnuSelectAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuSelectAllActionPerformed
    getPartitionPanel().setSelection(getPartitionDonnees().getSelectionTout());
    getPartitionPanel().repaint();
}//GEN-LAST:event_mnuSelectAllActionPerformed

private void mnuDeselectAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mnuDeselectAllActionPerformed
    getPartitionPanel().selectionAbandonner();
    getPartitionPanel().repaint();
}//GEN-LAST:event_mnuDeselectAllActionPerformed






    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton boutonAnnuler;
    private javax.swing.JButton boutonEntreeMIDIEnregistrer;
    private javax.swing.JButton boutonImprimer;
    private javax.swing.JButton boutonMIDIStop;
    private javax.swing.JButton boutonMIDIStop1;
    private javax.swing.JButton boutonOuvrir;
    private javax.swing.JButton boutonPause;
    private javax.swing.JButton boutonPause1;
    private javax.swing.JButton boutonRefaire;
    private javax.swing.JButton boutonSauvegarder;
    private javax.swing.JButton boutonSortieMIDILecture;
    private javax.swing.JButton boutonSortieMIDIReprendre;
    private musicwriter.DureePanelExperimental dureePanel;
    private musicwriter.HelpPanel helpPanel;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenu jMenu4;
    private javax.swing.JMenu jMenu5;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JMenuItem jMenuItem4;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItem6;
    private javax.swing.JMenuItem jMenuItem7;
    private javax.swing.JMenuItem jMenuItem8;
    private javax.swing.JMenuItem jMenuItemBlanche;
    private javax.swing.JMenuItem jMenuItemCroche;
    private javax.swing.JMenuItem jMenuItemNoire;
    private javax.swing.JMenu jMenuNoteDuree;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JPopupMenu.Separator jSeparator2;
    private javax.swing.JPopupMenu.Separator jSeparator3;
    private javax.swing.JSlider jSliderLectureVitesse;
    private javax.swing.JToolBar jToolBar3;
    private javax.swing.JLabel lblSelectionPlus;
    private javax.swing.JMenuBar menuBar;
    private javax.swing.JMenuItem mnuAlterationBecarre;
    private javax.swing.JMenuItem mnuAlterationBemol;
    private javax.swing.JMenuItem mnuAlterationDiese;
    private javax.swing.JMenuItem mnuAlterationDoubleBemol;
    private javax.swing.JMenuItem mnuAlterationDoubleDiese;
    private javax.swing.JMenuItem mnuAlterationEnharmonique;
    private javax.swing.JMenuItem mnuAlterationViaTonalite;
    private javax.swing.JMenuItem mnuAnnuler;
    private javax.swing.JMenuItem mnuConfiguration;
    private javax.swing.JMenuItem mnuCopy;
    private javax.swing.JMenuItem mnuCut;
    private javax.swing.JMenuItem mnuDeselectAll;
    private javax.swing.JMenuItem mnuDoubleCroche;
    private javax.swing.JMenuItem mnuEditionSupprimer;
    private javax.swing.JMenuItem mnuNew;
    private javax.swing.JMenuItem mnuNouvelleVoix;
    private javax.swing.JMenuItem mnuPaste;
    private javax.swing.JMenuItem mnuRefaire;
    private javax.swing.JMenuItem mnuRepaint;
    private javax.swing.JMenuItem mnuRonde;
    private javax.swing.JMenuItem mnuSelectAll;
    private javax.swing.JMenuItem mnuTripleCroche;
    private javax.swing.JMenuItem mnuVoixNotesIndependantes;
    private javax.swing.JPanel panAide;
    private javax.swing.JPanel panBarreOutils;
    private javax.swing.JPanel panelGeneral;
    private javax.swing.JPanel panelTravail;
    private javax.swing.JPanel partitionPanel;
    private javax.swing.JProgressBar progressBar;
    private musicwriter.DureePanelExperimental selectionDureePanel;
    private javax.swing.JLabel statusAnimationLabel;
    private javax.swing.JLabel statusMessageLabel;
    private javax.swing.JPanel statusPanel;
    private javax.swing.JToolBar toolBarEcriture;
    private javax.swing.JToolBar toolBarSelection;
    // End of variables declaration//GEN-END:variables

    private final Timer messageTimer;
    private final Timer busyIconTimer;
    private final Icon idleIcon;
    private final Icon[] busyIcons = new Icon[15];
    private int busyIconIndex = 0;

    private JDialog aboutBox;

    private PartitionDonnees getPartitionDonnees() {
        return getPartitionPanel().getPartitionDonnees();
    }



}
