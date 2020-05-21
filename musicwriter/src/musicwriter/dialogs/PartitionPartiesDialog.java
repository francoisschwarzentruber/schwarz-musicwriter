/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * PartitionPartiesDialog.java
 *
 * Created on 18 janv. 2010, 21:07:00
 */

package musicwriter.dialogs;

import musicwriter.InstrumentTranspositionDialog;
import musicwriter.InstrumentsDialog;
import musicwriter.Partie;
import musicwriter.PartitionDonnees;

/**
 *
 * @author Ancmin
 */
public class PartitionPartiesDialog extends javax.swing.JDialog {
    private final PartitionDonnees partitionDonnees;
    private PartitionPartiesListModel model = null;
    private boolean annule = true;

    /** Creates new form PartitionPartiesDialog */
    public PartitionPartiesDialog(java.awt.Frame parent, boolean modal, PartitionDonnees partitionDonnees) {
        super(parent, modal);
        initComponents();
        this.partitionDonnees = partitionDonnees;
        jListPartitionParties.setCellRenderer(new PartitionPartiesCellRenderer());
        jListPartitionParties.setModel(new PartitionPartiesListModel(partitionDonnees));
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jToolBar1 = new javax.swing.JToolBar();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jListPartitionParties = new javax.swing.JList();
        jPanel1 = new javax.swing.JPanel();
        cmdOK = new javax.swing.JButton();
        cmdAnnuler = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getResourceMap(PartitionPartiesDialog.class);
        setTitle(resourceMap.getString("Form.title")); // NOI18N
        setMinimumSize(new java.awt.Dimension(400, 600));
        setName("Form"); // NOI18N
        getContentPane().setLayout(new javax.swing.BoxLayout(getContentPane(), javax.swing.BoxLayout.PAGE_AXIS));

        jToolBar1.setFloatable(false);
        jToolBar1.setRollover(true);
        jToolBar1.setName("jToolBar1"); // NOI18N

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
        jToolBar1.add(jButton1);

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
        jToolBar1.add(jButton2);

        jButton3.setIcon(resourceMap.getIcon("jButton3.icon")); // NOI18N
        jButton3.setText(resourceMap.getString("jButton3.text")); // NOI18N
        jButton3.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton3.setName("jButton3"); // NOI18N
        jButton3.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton3);

        getContentPane().add(jToolBar1);

        jScrollPane1.setName("jScrollPane1"); // NOI18N

        jListPartitionParties.setModel(new javax.swing.AbstractListModel() {
            String[] strings = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" };
            public int getSize() { return strings.length; }
            public Object getElementAt(int i) { return strings[i]; }
        });
        jListPartitionParties.setName("jListPartitionParties"); // NOI18N
        jScrollPane1.setViewportView(jListPartitionParties);

        getContentPane().add(jScrollPane1);

        jPanel1.setName("jPanel1"); // NOI18N
        jPanel1.setLayout(new javax.swing.BoxLayout(jPanel1, javax.swing.BoxLayout.LINE_AXIS));

        cmdOK.setIcon(resourceMap.getIcon("cmdOK.icon")); // NOI18N
        cmdOK.setText(resourceMap.getString("cmdOK.text")); // NOI18N
        cmdOK.setName("cmdOK"); // NOI18N
        cmdOK.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cmdOKActionPerformed(evt);
            }
        });
        jPanel1.add(cmdOK);

        cmdAnnuler.setIcon(resourceMap.getIcon("cmdAnnuler.icon")); // NOI18N
        cmdAnnuler.setText(resourceMap.getString("cmdAnnuler.text")); // NOI18N
        cmdAnnuler.setName("cmdAnnuler"); // NOI18N
        cmdAnnuler.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cmdAnnulerActionPerformed(evt);
            }
        });
        jPanel1.add(cmdAnnuler);

        getContentPane().add(jPanel1);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        InstrumentsDialog d = new InstrumentsDialog(null, true);
        d.setVisible(true);
        if(d.getInstrument() != null)
        {
            Partie partie = new Partie(d.getInstrument());
            partitionDonnees.partieAjouter(partie);
            partitionDonnees.partieClefsInstaller(partie);
            jListPartitionParties.setModel(new PartitionPartiesListModel(partitionDonnees));
        }

    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        // TODO add your handling code here:
        if(jListPartitionParties.getSelectedIndex() >= 0)
        {
            partitionDonnees.partieSupprimer(jListPartitionParties.getSelectedIndex());
             jListPartitionParties.repaint();
        }


    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        InstrumentTranspositionDialog d = new InstrumentTranspositionDialog(null, true);
        d.setVisible(true);
        if(d.getIntervalleTransposition() != null)
        {
              partitionDonnees.getParties().get(jListPartitionParties.getSelectedIndex()).setTransposition(d.getIntervalleTransposition());
        }
    }//GEN-LAST:event_jButton3ActionPerformed

    private void cmdOKActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cmdOKActionPerformed
        setVisible(false);
        annule = false;
}//GEN-LAST:event_cmdOKActionPerformed

    private void cmdAnnulerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cmdAnnulerActionPerformed
        setVisible(false);
}//GEN-LAST:event_cmdAnnulerActionPerformed

    /**
    * @param args the command line arguments
    */
    public static void main(String args[]) {
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                PartitionPartiesDialog dialog = new PartitionPartiesDialog(new javax.swing.JFrame(), true, new PartitionDonnees());
                dialog.addWindowListener(new java.awt.event.WindowAdapter() {
                    public void windowClosing(java.awt.event.WindowEvent e) {
                        System.exit(0);
                    }
                });
                dialog.setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton cmdAnnuler;
    private javax.swing.JButton cmdOK;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JList jListPartitionParties;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JToolBar jToolBar1;
    // End of variables declaration//GEN-END:variables

    public boolean isAnnule() {
        return annule;
    }

}
