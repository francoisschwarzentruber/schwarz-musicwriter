/*
 * DialogErreur.java
 *
 * Created on 5 septembre 2008, 13:32
 */

package musicwriter;

/**
 *
 * @author  proprietaire
 */
public class DialogErreur extends javax.swing.JDialog {

    /** Creates new form DialogErreur */
    public DialogErreur(java.awt.Frame parent, boolean modal) {
        super(parent, modal);
        initComponents();
        txtMessage.setLineWrap(true);
    }

    void setMessage(String texte) {
        txtMessage.setText(texte);
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        txtMessage = new javax.swing.JTextArea();
        boutonOK = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getResourceMap(DialogErreur.class);
        setTitle(resourceMap.getString("Form.title")); // NOI18N
        setMinimumSize(new java.awt.Dimension(300, 200));
        setName("Form"); // NOI18N
        getContentPane().setLayout(new javax.swing.BoxLayout(getContentPane(), javax.swing.BoxLayout.Y_AXIS));

        jScrollPane1.setName("jScrollPane1"); // NOI18N

        txtMessage.setColumns(20);
        txtMessage.setEditable(false);
        txtMessage.setRows(5);
        txtMessage.setWrapStyleWord(true);
        txtMessage.setName("txtMessage"); // NOI18N
        jScrollPane1.setViewportView(txtMessage);

        getContentPane().add(jScrollPane1);

        boutonOK.setText(resourceMap.getString("boutonOK.text")); // NOI18N
        boutonOK.setName("boutonOK"); // NOI18N
        boutonOK.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonOKActionPerformed(evt);
            }
        });
        getContentPane().add(boutonOK);

        pack();
    }// </editor-fold>//GEN-END:initComponents

private void boutonOKActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonOKActionPerformed
    setVisible(false);
}//GEN-LAST:event_boutonOKActionPerformed

    /**
    * @param args the command line arguments
    */
    public static void main(String args[]) {
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                DialogErreur dialog = new DialogErreur(new javax.swing.JFrame(), true);
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
    private javax.swing.JButton boutonOK;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextArea txtMessage;
    // End of variables declaration//GEN-END:variables

}
