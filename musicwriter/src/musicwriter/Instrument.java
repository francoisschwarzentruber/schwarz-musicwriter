/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Image;
import java.net.URL;
import javax.swing.ImageIcon;

/**
 *
 * @author Ancmin
 */
public class Instrument {
    private final int numeroMIDI;

    Instrument(int numeroMIDI)
    {
        this.numeroMIDI = numeroMIDI;
    }



    String getNom()
    {
         return "piano";
    }


    public ImageIcon getImageIcon()
    {
        URL url = AffichageSilence.class.getResource("resources/instruments/" + (numeroMIDI+1) + ".jpg");
        
        if(url != null)
             return (new ImageIcon(url));
        else
             return null;
    }
    


    public ImageIcon getImageIconSmall()
    {
        ImageIcon imgI = getImageIcon();

        if(imgI == null)
            return null;
        else
            if(imgI.getIconHeight() < 128)
                return imgI;
            else
            {
                double scale = 128.0f / imgI.getIconHeight();
                Image img = getImageIcon().getImage().getScaledInstance((int) (imgI.getIconWidth() * scale),
                             (int) (imgI.getIconHeight() * scale), Image.SCALE_DEFAULT);
                return new ImageIcon(img);
            }


    }


    int getPorteesNombreStandard()
    {
        if(numeroMIDI < 5)
            return 2;
        else
            return 1;
    }

    int getNumeroMIDI() {
        return numeroMIDI;
    }






}
