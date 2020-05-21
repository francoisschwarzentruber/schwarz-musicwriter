/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.*;
import java.awt.print.*;
import javax.print.attribute.PrintRequestAttribute;
import javax.swing.JOptionPane;
import javax.swing.JPanel;


/**
 *
 * @author proprietaire
 */
public class PartitionImpression {

    private double facteurPrecision = 5;
    
    class ObjetAImprimer extends JPanel implements Printable {

        private PartitionVue partitionVue = null;
        
        public ObjetAImprimer(PartitionDonnees partitionDonnees) 
        {
            partitionVue = new PartitionVue(partitionDonnees);
            
        }
        
        
        
        private void mettreEnPage(PageFormat pageFormat)
        {
            int systemesEcart = (int) ((pageFormat.getImageableHeight() / 8.0) * facteurPrecision);
            int porteesEcart = (int) ((pageFormat.getImageableHeight() / 10.0)  * facteurPrecision);
            int systemeLongueur = (int)(( pageFormat.getImageableWidth()) * facteurPrecision);
            //- 55 c'est du biddouillage... je sais pas comment faire autrement...
            //si - 0 : il y a des notes qui sont bouffées à droite
            //si - 100 : la zone horizontale devient toute petite
            
            partitionVue.setSystemeLongueur(systemeLongueur);
            partitionVue.setSystemesEcart(systemesEcart);
            
            partitionVue.setPremierSystemePremierePorteeTroisiemeLigneY((pageFormat.getImageableY() + 100) * facteurPrecision);
            partitionVue.setInterLigne(4 * facteurPrecision);
            partitionVue.setPorteesEcart(porteesEcart);
            
            partitionVue.calculer();
            
            
            
            
        }
        
        
        

      public int print( Graphics graphic, PageFormat pageFormat, int numeroPage)
      //return NO_SUCH_PAGE ou PAGE_EXISTS
      {
          Graphics2D g = ((Graphics2D) graphic);
          g.setStroke(new BasicStroke((float) facteurPrecision /2.0f));
          g.translate(0, -numeroPage * pageFormat.getImageableHeight());
          g.translate(pageFormat.getImageableX(),0);
          g.scale(1.0f / facteurPrecision, 1.0f /facteurPrecision);
        //  g.translate(120 * facteurPrecision, 0);
          
          
          mettreEnPage(pageFormat);
          
          
          if(numeroPage > partitionVue.getSystemesNombre() / 2)
              return NO_SUCH_PAGE;
          
          partitionVue.afficherPartition(g);          
          
          return PAGE_EXISTS;

      }

    }

    
    
    ObjetAImprimer objetAImprimer = null;
    
    PartitionImpression(PartitionDonnees partitionDonnees)
    {
        objetAImprimer = new ObjetAImprimer(partitionDonnees);
    }
    
    
    
    public void imprimer()
    {
        PrinterJob printJob = PrinterJob.getPrinterJob();
        PageFormat fmtP = printJob.defaultPage();
        //PageFormat pageFormat = printJob.pageDialog(fmtP);
        //printJob.defaultPage(fmtP);

        PageFormat pageFormat = printJob.defaultPage();
//        PageFormat pageFormat = new PageFormat();
//        Paper paper = new Paper();
//        pageFormat.setPaper(paper);
//        paper.setImageableArea(0D, 0D, Double.MAX_VALUE, Double.MAX_VALUE);
//        pageFormat = printJob.validatePage(pageFormat);
        printJob.setPrintable( objetAImprimer, pageFormat);
        //printJob.defaultPage(pageFormat);

        if (printJob.printDialog())
        { // le dialogue d’impression

              try
              {
                    printJob.print();
              }
              catch (PrinterException exception) {
                    JOptionPane.showMessageDialog(objetAImprimer, exception);

              }

        }
    }
    
}
