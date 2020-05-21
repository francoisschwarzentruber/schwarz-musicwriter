/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.io.FileOutputStream;
import java.io.IOException;
import org.jdom.Document;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

/**
 *
 * @author proprietaire
 */
public class PartitionSauvegarde {
    
    private PartitionDonnees partitionDonnees = null;
    
    PartitionSauvegarde(PartitionDonnees partitionDonnees)
    {
        this.partitionDonnees = partitionDonnees;
    }
    
    
    
    void sauvegarder(String fichierNom) throws IOException
    {
        XMLOutputter sortie = new XMLOutputter(Format.getPrettyFormat());
        Document document = partitionDonnees.sauvegarder();
        
        sortie.output(document, new FileOutputStream(fichierNom));
        partitionDonnees.setPasDeModification();
        
    }

}
