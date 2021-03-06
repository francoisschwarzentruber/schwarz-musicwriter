/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * DureePanelExperimental.java
 *
 * Created on 17 févr. 2010, 15:37:51
 */

package musicwriter;

import java.awt.event.ActionListener;
import javax.swing.ImageIcon;

/**
 *
 * @author Ancmin
 */
public class DureePanelExperimental extends javax.swing.JPanel {

    private Rational r = new Rational(1, 1);
    
    private ImageIcon iconTeteBlanche = new ImageIcon(AffichageSilence.class.getResource("resources/duree_noteblanche.png"));
    private ImageIcon iconTeteNoire = new ImageIcon(AffichageSilence.class.getResource("resources/duree_notenoire.png"));

    private ImageIcon iconHampe = new ImageIcon(AffichageSilence.class.getResource("resources/duree_hampe.png"));
    private ImageIcon iconHampeAucune = new ImageIcon(AffichageSilence.class.getResource("resources/duree_hampe_aucun.png"));

    private ImageIcon iconTrait = new ImageIcon(AffichageSilence.class.getResource("resources/duree_crochetrait.png"));
    private ImageIcon iconTraitAucun = new ImageIcon(AffichageSilence.class.getResource("resources/duree_crochetrait_aucun.png"));

    private ImageIcon iconPoint = new ImageIcon(AffichageSilence.class.getResource("resources/duree_point.png"));
    private ImageIcon iconPointAucun = new ImageIcon(AffichageSilence.class.getResource("resources/duree_point_aucun.png"));
    private ActionListener actionListener = null;



    /** Creates new form DureePanelExperimental */
    public DureePanelExperimental() {
        initComponents();
        r = new Rational(1, 1);
        afficherRational();
    }



    public Duree getDuree()
    {
        return new Duree(r);
    }



    

    public void addListener(ActionListener a)
    {
        this.actionListener = a;
    }


    private boolean isTeteBlanche()
    {
        return r.isSuperieur(new Rational(2, 1));
    }

    private boolean isHampe()
    {
        return r.isStrictementInferieur(new Rational(4, 1));
    }

    private void afficherRational()
    {
        if(isTeteBlanche())
        {
            boutonTete.setIcon(iconTeteBlanche);
        }
        else
            boutonTete.setIcon(iconTeteNoire);

        if(isHampe())
        {
            boutonHampe.setIcon(iconHampe);
        }
        else
            boutonHampe.setIcon(iconHampeAucune);


       if(isTrait1())
            boutonTrait1.setIcon(iconTrait);
        else
            boutonTrait1.setIcon(iconTraitAucun);

       if(isTrait2())
            boutonTrait2.setIcon(iconTrait);
        else
            boutonTrait2.setIcon(iconTraitAucun);

        if(isTrait3())
            boutonTrait3.setIcon(iconTrait);
        else
            boutonTrait3.setIcon(iconTraitAucun);


        if(isTrait4())
            boutonTrait4.setIcon(iconTrait);
        else
            boutonTrait4.setIcon(iconTraitAucun);


        if(isPoint1())
            boutonPoint1.setIcon(iconPoint);
        else
            boutonPoint1.setIcon(iconPointAucun);


        if(isPoint2())
            boutonPoint2.setIcon(iconPoint);
        else
            boutonPoint2.setIcon(iconPointAucun);


        if(actionListener != null)
        {
            actionListener.actionPerformed(null);
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
        java.awt.GridBagConstraints gridBagConstraints;

        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jToolBar3 = new javax.swing.JToolBar();
        boutonHampe = new javax.swing.JButton();
        jToolBar1 = new javax.swing.JToolBar();
        boutonTrait1 = new javax.swing.JButton();
        boutonTrait2 = new javax.swing.JButton();
        boutonTrait3 = new javax.swing.JButton();
        boutonTrait4 = new javax.swing.JButton();
        jToolBar2 = new javax.swing.JToolBar();
        boutonTete = new javax.swing.JButton();
        boutonPoint1 = new javax.swing.JButton();
        boutonPoint2 = new javax.swing.JButton();

        setName("Form"); // NOI18N
        setLayout(new java.awt.GridBagLayout());

        jPanel1.setMaximumSize(new java.awt.Dimension(2147483647, 44));
        jPanel1.setMinimumSize(new java.awt.Dimension(49, 32));
        jPanel1.setName("jPanel1"); // NOI18N
        jPanel1.setPreferredSize(new java.awt.Dimension(57, 32));
        jPanel1.setLayout(new java.awt.GridBagLayout());

        jPanel2.setMinimumSize(new java.awt.Dimension(12, 2));
        jPanel2.setName("jPanel2"); // NOI18N
        jPanel2.setPreferredSize(new java.awt.Dimension(12, 0));

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 0;
        jPanel1.add(jPanel2, gridBagConstraints);

        jToolBar3.setBorder(null);
        jToolBar3.setFloatable(false);
        jToolBar3.setRollover(true);
        jToolBar3.setName("jToolBar3"); // NOI18N

        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(musicwriter.MusicwriterApp.class).getContext().getResourceMap(DureePanelExperimental.class);
        boutonHampe.setIcon(resourceMap.getIcon("boutonHampe.icon")); // NOI18N
        boutonHampe.setFocusable(false);
        boutonHampe.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        boutonHampe.setMaximumSize(new java.awt.Dimension(4, 32));
        boutonHampe.setMinimumSize(new java.awt.Dimension(4, 32));
        boutonHampe.setName("boutonHampe"); // NOI18N
        boutonHampe.setPreferredSize(new java.awt.Dimension(4, 32));
        boutonHampe.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        boutonHampe.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonHampeActionPerformed(evt);
            }
        });
        jToolBar3.add(boutonHampe);

        jPanel1.add(jToolBar3, new java.awt.GridBagConstraints());

        jToolBar1.setBorder(null);
        jToolBar1.setFloatable(false);
        jToolBar1.setOrientation(1);
        jToolBar1.setRollover(true);
        jToolBar1.setName("jToolBar1"); // NOI18N
        jToolBar1.setPreferredSize(new java.awt.Dimension(41, 30));

        boutonTrait1.setIcon(resourceMap.getIcon("boutonTrait1.icon")); // NOI18N
        boutonTrait1.setFocusable(false);
        boutonTrait1.setMaximumSize(new java.awt.Dimension(23, 6));
        boutonTrait1.setMinimumSize(new java.awt.Dimension(23, 6));
        boutonTrait1.setName("boutonTrait1"); // NOI18N
        boutonTrait1.setPreferredSize(new java.awt.Dimension(23, 6));
        boutonTrait1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonTrait1ActionPerformed(evt);
            }
        });
        jToolBar1.add(boutonTrait1);

        boutonTrait2.setIcon(resourceMap.getIcon("boutonTrait2.icon")); // NOI18N
        boutonTrait2.setFocusable(false);
        boutonTrait2.setMaximumSize(new java.awt.Dimension(23, 6));
        boutonTrait2.setMinimumSize(new java.awt.Dimension(23, 6));
        boutonTrait2.setName("boutonTrait2"); // NOI18N
        boutonTrait2.setPreferredSize(new java.awt.Dimension(23, 4));
        boutonTrait2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonTrait2ActionPerformed(evt);
            }
        });
        jToolBar1.add(boutonTrait2);

        boutonTrait3.setIcon(resourceMap.getIcon("boutonTrait3.icon")); // NOI18N
        boutonTrait3.setFocusable(false);
        boutonTrait3.setMaximumSize(new java.awt.Dimension(23, 6));
        boutonTrait3.setMinimumSize(new java.awt.Dimension(16, 11));
        boutonTrait3.setName("boutonTrait3"); // NOI18N
        boutonTrait3.setPreferredSize(new java.awt.Dimension(16, 4));
        boutonTrait3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonTrait3ActionPerformed(evt);
            }
        });
        jToolBar1.add(boutonTrait3);

        boutonTrait4.setIcon(resourceMap.getIcon("boutonTrait4.icon")); // NOI18N
        boutonTrait4.setFocusable(false);
        boutonTrait4.setMaximumSize(new java.awt.Dimension(23, 6));
        boutonTrait4.setName("boutonTrait4"); // NOI18N
        boutonTrait4.setPreferredSize(new java.awt.Dimension(23, 4));
        boutonTrait4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonTrait4ActionPerformed(evt);
            }
        });
        jToolBar1.add(boutonTrait4);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 2;
        gridBagConstraints.gridy = 0;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTH;
        jPanel1.add(jToolBar1, gridBagConstraints);

        add(jPanel1, new java.awt.GridBagConstraints());

        jToolBar2.setBorder(null);
        jToolBar2.setFloatable(false);
        jToolBar2.setName("jToolBar2"); // NOI18N
        jToolBar2.setPreferredSize(new java.awt.Dimension(64, 16));

        boutonTete.setIcon(resourceMap.getIcon("boutonTete.icon")); // NOI18N
        boutonTete.setText(resourceMap.getString("boutonTete.text")); // NOI18N
        boutonTete.setFocusPainted(false);
        boutonTete.setFocusable(false);
        boutonTete.setMaximumSize(new java.awt.Dimension(16, 16));
        boutonTete.setMinimumSize(new java.awt.Dimension(16, 16));
        boutonTete.setName("boutonTete"); // NOI18N
        boutonTete.setPreferredSize(new java.awt.Dimension(16, 16));
        boutonTete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonTeteActionPerformed(evt);
            }
        });
        jToolBar2.add(boutonTete);

        boutonPoint1.setIcon(resourceMap.getIcon("boutonPoint1.icon")); // NOI18N
        boutonPoint1.setFocusable(false);
        boutonPoint1.setName("boutonPoint1"); // NOI18N
        boutonPoint1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonPoint1ActionPerformed(evt);
            }
        });
        jToolBar2.add(boutonPoint1);

        boutonPoint2.setIcon(resourceMap.getIcon("boutonPoint2.icon")); // NOI18N
        boutonPoint2.setFocusable(false);
        boutonPoint2.setName("boutonPoint2"); // NOI18N
        boutonPoint2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                boutonPoint2ActionPerformed(evt);
            }
        });
        jToolBar2.add(boutonPoint2);

        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        add(jToolBar2, gridBagConstraints);
    }// </editor-fold>//GEN-END:initComponents






    private void boutonTeteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonTeteActionPerformed
        if(isTeteBlanche())
        {
            r = new Rational(1, 1);
        }
        else
        {
            r = new Rational(2, 1);
        }


        afficherRational();


        
    }//GEN-LAST:event_boutonTeteActionPerformed

    private void boutonHampeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonHampeActionPerformed
        if(isHampe())
        {
            r = new Rational(4, 1);
        }
        else
        {
            r = new Rational(2, 1);
        }


        afficherRational();
    }//GEN-LAST:event_boutonHampeActionPerformed

    private void boutonTrait1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonTrait1ActionPerformed
        r = new Rational(1, 2);
        afficherRational();
    }//GEN-LAST:event_boutonTrait1ActionPerformed

    private void boutonTrait2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonTrait2ActionPerformed
        r = new Rational(1, 4);
        afficherRational();
    }//GEN-LAST:event_boutonTrait2ActionPerformed

    private void boutonTrait3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonTrait3ActionPerformed
        r = new Rational(1, 8);
        afficherRational();
    }//GEN-LAST:event_boutonTrait3ActionPerformed

    private void boutonTrait4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonTrait4ActionPerformed
        r = new Rational(1, 16);
        afficherRational();
    }//GEN-LAST:event_boutonTrait4ActionPerformed

    private void boutonPoint1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonPoint1ActionPerformed
  
        if(isPoint1())
            dureeSansPoints();
        else
        {
            dureeSansPoints();
            r = r.multiplier(new Rational(3, 2));
        }


        afficherRational();
    }//GEN-LAST:event_boutonPoint1ActionPerformed

    private void boutonPoint2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_boutonPoint2ActionPerformed

        if(isPoint2())
            dureeSansPoints();
        else
        {
            dureeSansPoints();
            r = r.multiplier(new Rational(7, 4));
        }
            

        afficherRational();
    }//GEN-LAST:event_boutonPoint2ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton boutonHampe;
    private javax.swing.JButton boutonPoint1;
    private javax.swing.JButton boutonPoint2;
    private javax.swing.JButton boutonTete;
    private javax.swing.JButton boutonTrait1;
    private javax.swing.JButton boutonTrait2;
    private javax.swing.JButton boutonTrait3;
    private javax.swing.JButton boutonTrait4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JToolBar jToolBar1;
    private javax.swing.JToolBar jToolBar2;
    private javax.swing.JToolBar jToolBar3;
    // End of variables declaration//GEN-END:variables

    private boolean isTrait1() {
        return r.isStrictementInferieur(new Rational(1, 1));
    }

    private boolean isTrait2() {
        return r.isStrictementInferieur(new Rational(1, 2));
    }

    private boolean isTrait3() {
        return r.isStrictementInferieur(new Rational(1, 4));
    }

    private boolean isTrait4() {
        return r.isStrictementInferieur(new Rational(1, 8));
    }

    private boolean isPoint1() {
        return (r.getNumerateur() == 3) | (r.getNumerateur() == 6) | (r.getNumerateur() == 7);
    }

    private boolean isPoint2() {
        return (r.getNumerateur() == 7);
    }

    private void dureeSansPoints() {

        if(isPoint2())
        {
            r = r.multiplier(new Rational(4, 7));
        }
        else
        if(isPoint1())
        {
            r = r.multiplier(new Rational(2, 3));
        }
    }

}
