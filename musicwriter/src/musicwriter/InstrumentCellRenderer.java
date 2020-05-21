/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Color;
import java.awt.Component;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.ListCellRenderer;

/**
 *
 * @author Ancmin
 */
class InstrumentCellRenderer extends JLabel implements ListCellRenderer {
private static final Color HIGHLIGHT_COLOR = new Color(0, 0, 128);
    public InstrumentCellRenderer() {
        setOpaque(true);
        setIconTextGap(12);
        setHorizontalAlignment(CENTER);
    }


    public Component getListCellRendererComponent(JList list, Object value, int index, boolean isSelected, boolean cellHasFocus) {
        Instrument instrument = (Instrument) value;

        setIcon(instrument.getImageIconSmall());
      //  setText(instrument.getNom());
        if (isSelected) {
              setBackground(HIGHLIGHT_COLOR);
              setForeground(Color.white);
            } else {
              setBackground(Color.white);
              setForeground(Color.black);
            }
        return this;
    }



}
