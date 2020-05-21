/*
 * DureeEntreeFractionPanel.java
 *
 * Created on 8 janvier 2010, 17:57
 */

package musicwriter;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import javax.swing.Timer;


/**
 *
 * @author  proprietaire
 */
public class DureeEntreeFractionPanel extends javax.swing.JPanel {
    private Duree duree = null;
    private PartitionPanel partitionPanel = null;
    private Timer finSaisieTimer = null;
    
   private void createFinSaisieTimer ()
   {
    // Création d'une instance de listener 
    // associée au timer
    ActionListener action = new ActionListener ()
      {
        int c = 0;
        // Méthode appelée à chaque tic du timer
        public void actionPerformed (ActionEvent event)
        {
            if(c > 0)
            {
                partitionPanel.dureeEntreeTraiter(duree);
                partitionPanel.removeAll();
                partitionPanel.repaint();
                partitionPanel.requestFocus();
                finSaisieTimer.stop();
            }
            c++;
        }
      };
      
    // Création d'un timer qui génère un tic
    // chaque 50 millième de seconde
    finSaisieTimer = new Timer(200, action);
    finSaisieTimer.start();
  } 
    
    
    DureeEntreeFractionPanel(PartitionPanel partitionPanel, Duree duree) {
        initComponents();
        
        this.partitionPanel = partitionPanel;
       // setDuree(duree);
        setDureeQueNumerateur(duree);
        createFinSaisieTimer();
    }
    
    

    public Duree getDuree() {
        return duree;
    }

    void setDuree(Duree duree)
    {
        this.duree = duree;
        txtDuree.setText(duree.toString());
    }
    

    /** Creates new form DureeEntreeFractionPanel */
    public DureeEntreeFractionPanel() {
        initComponents();
    }
    
    public static int getNumber(KeyEvent evt)
    {
        switch(evt.getKeyChar())
        {   
            case 'j': return 1;
            case 'k': return 2;
            case 'l': return 3;
            case 'u': return 4;
            case 'i': return 5;
            case 'o': return 6;
            case 'è': return 7;
            case '_': return 8;
            case 'ç': return 9;
            case '1': return 1;
            case '2': return 2;
            case '3': return 3;
            case '4': return 4;
            case '5': return 5;
            case '6': return 6;
            case '7': return 7;
            case '8': return 8;
            case '9': return 9;
            default: return 0;
                   
        }
    }
    
    
      
    
    static void tryDureePanel(KeyEvent evt, PartitionPanel partitionPanel) {
        int n = DureeEntreeFractionPanel.getNumber(evt);
         if(n > 0)
         {
             DureeEntreeFractionPanel dureePanel = new DureeEntreeFractionPanel(partitionPanel, new Duree(new Rational(n, 1)));
             partitionPanel.add(dureePanel);
             dureePanel.setVisible(true);
            // partitionPanel.setLayout(null);
             dureePanel.setBounds(0, 0, 150, 50);
             partitionPanel.validate();
             partitionPanel.dureeEntreeTraiter(new Duree(new Rational(n, 1)));
             partitionPanel.repaint();
             dureePanel.requestFocus();
             
         }
            
    }


    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        txtDuree = new javax.swing.JLabel();

        setName("Form"); // NOI18N
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
        });
        addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                formKeyPressed(evt);
            }
        });
        setLayout(new java.awt.BorderLayout());

        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getResourceMap(DureeEntreeFractionPanel.class);
        txtDuree.setFont(resourceMap.getFont("txtDuree.font")); // NOI18N
        txtDuree.setText(resourceMap.getString("txtDuree.text")); // NOI18N
        txtDuree.setName("txtDuree"); // NOI18N
        add(txtDuree, java.awt.BorderLayout.CENTER);
    }// </editor-fold>//GEN-END:initComponents

private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed

}//GEN-LAST:event_formMousePressed

private void formKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyPressed
    int denominateur = getNumber(evt);
    if (denominateur == 0)
        return;
    setDuree(new Duree(new Rational(duree.getRational().getNumerateur(), denominateur)));
}//GEN-LAST:event_formKeyPressed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel txtDuree;
    // End of variables declaration//GEN-END:variables

    private void setDureeQueNumerateur(Duree duree) {
        this.duree = duree;
        txtDuree.setText(duree.getRational().getNumerateur() + "/...");
    }

}
