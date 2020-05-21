/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter.dialogs;

import java.awt.Color;
import java.awt.Component;
import java.awt.dnd.DropTargetDragEvent;
import java.awt.dnd.DropTargetDropEvent;
import java.awt.dnd.DropTargetEvent;
import java.awt.dnd.DropTargetListener;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.ListCellRenderer;
import musicwriter.Partie;

/**
 *
 * @author Ancmin
 */
class PartitionPartiesCellRenderer implements ListCellRenderer, DropTargetListener {
    private static final Color HIGHLIGHT_COLOR = new Color(0, 0, 164);
    public PartitionPartiesCellRenderer() {

    }
    
    
    public Component getListCellRendererComponent(JList list, Object value, int index, boolean isSelected, boolean cellHasFocus) {
        JLabel label = new JLabel();

        Partie partie = (Partie) value;
        label.setOpaque(true);
        label.setHorizontalAlignment(JLabel.CENTER);
        label.setTransferHandler(new PartitionPartiesTransferHandler());
        label.setIcon(partie.getInstrument().getImageIcon());
       // setText(partie.getInstrument().getNom());
        if (isSelected) {
              label.setBackground(HIGHLIGHT_COLOR);
              label.setForeground(Color.white);
            } else {
              label.setBackground(Color.white);
              label.setForeground(Color.black);
            }
        return label;
    }

    public void dragEnter(DropTargetDragEvent dtde) {
        //throw new UnsupportedOperationException("Not supported yet.");
    }

    public void dragOver(DropTargetDragEvent dtde) {
        
    }

    public void dropActionChanged(DropTargetDragEvent dtde) {
       // throw new UnsupportedOperationException("Not supported yet.");
    }

    public void dragExit(DropTargetEvent dte) {
       //throw new UnsupportedOperationException("Not supported yet.");
    }

    public void drop(DropTargetDropEvent dtde) {
       System.out.println(dtde.getSource());
    }

}
