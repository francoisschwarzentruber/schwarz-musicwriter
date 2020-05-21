/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.io.File;
import java.io.IOException;
import java.util.List;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

/**
 *
 * @author proprietaire
 */
public class PartitionDonneesChargement {

    static private int divisions = 4800;

    private static Moment traiterElementsMesure(PartitionDonnees partitionDonnees, Moment momentDebutMesure, Partie partie, Element elementMesure) {
        List<Element> enfants = elementMesure.getChildren();

        Note ancienneNote = null;
        Moment moment = momentDebutMesure;
        for(Element element : enfants)
        {
            if(element.getName().equals("forward"))
                    moment = (new Duree(divisions, element.getChild("duration"))).getFinMoment(moment);
            else if (element.getName().equals("backup"))
                    moment = (new Duree(divisions, element.getChild("duration"))).getDebutMoment(moment);
            else if (element.getName().equals("note") && (element.getChild("rest") != null))
            {
                Silence silence = new Silence(moment, partie, divisions, element);
                partitionDonnees.elementMusicalAjouter(silence);
                moment = silence.getFinMoment();
            }
            else if (element.getName().equals("note"))
            {
                if( (element.getChild("chord") != null)   )
                {
                    if(ancienneNote != null)
                         moment = ancienneNote.getDuree().getDebutMoment(moment);
                }
                Note note = new Note(moment, partie, divisions, element);

                if( (element.getChild("grace") != null)   )
                {
                    note.setDuree(new Duree(new Rational(1, 64)));
                }
                partitionDonnees.elementMusicalAjouter(note);

                    moment = note.getFinMoment();
                ancienneNote = note;
                
            }
            else if(element.getName().equals("direction"))
            {
                if(element.getChild("sound") != null)
                    if(element.getChild("sound").getAttribute("tempo") != null)
                       partitionDonnees.elementMusicalAjouter(new ElementMusicalTempo(moment, element));
            }
            else if(element.getName().equals(("attributes")))
            {
                  List<Element> enfantsAttributs = element.getChildren();
                  for(Element elementAttribut : enfantsAttributs)
                  {
                        if(elementAttribut.getName().equals("divisions"))
                        {
                            divisions = Integer.parseInt(elementAttribut.getText());
                        }


                      if(elementAttribut.getName().equals("key"))
                      {
                          partitionDonnees.elementMusicalAjouter(
                                  new ElementMusicalChangementTonalite(moment,
                                  elementAttribut));
                      }

                      if(elementAttribut.getName().equals("clef") )
                      {
                        partitionDonnees.elementMusicalAjouter(
                                  new ElementMusicalClef(moment, partie, 
                                  elementAttribut));
                      }

                      if(elementAttribut.getName().equals("transpose"))
                      {
                          partie.setTransposition(new Intervalle(
                                  Integer.parseInt(elementAttribut.getChild("diatonic").getValue()),
                                  Integer.parseInt(elementAttribut.getChild("chromatic").getValue())));
                      }


                      if(elementAttribut.getName().equals("time"))
                      {
                          partitionDonnees.elementMusicalAjouter(
                                  new ElementMusicalChangementMesureSignature(moment,
                                  elementAttribut));
                      }
                  }
                  

                  
            }

        }

        return moment;
    }
    
    

    
    
    
    private static PartitionDonnees getPartitionDonneesDuDocument(Document document)
    {
        PartitionDonnees partitionDonnees = new PartitionDonnees();
        
        Element racine = document.getRootElement();
        
        traiterPartiesStructure(partitionDonnees, racine.getChild("part-list"));
        
        int i = 0;
        for(Object elementPartieO : racine.getChildren("part"))
        {
            traiterPartieContenu(partitionDonnees, partitionDonnees.getParties().get(i), (Element) elementPartieO);
            i++;
        }
        
        return partitionDonnees;
        
    }
    
    
    private static Document getDocumentDuFichier(String nomFichier) throws JDOMException, IOException
    {
        SAXBuilder sxb = new SAXBuilder(false);
        sxb.setValidation(false);
        return sxb.build(new File(nomFichier));

    }
    
    
    public static PartitionDonnees getPartitionDonneesDuFichier(String nomFichier) throws JDOMException, IOException
    {
        return getPartitionDonneesDuDocument(getDocumentDuFichier(nomFichier));
    }


    private static void traiterPartiesStructure(PartitionDonnees partitionDonnees, Element racinePartList) {
        for(Object partieElementO : racinePartList.getChildren())
        {
            Element partieElement = (Element) partieElementO;
            int numeroMIDI = 0;
            try
            {
               numeroMIDI = Integer.parseInt(partieElement.getChild("midi-instrument").getChild("midi-program").getText());
            }
            catch(Exception e)
            {
                System.out.println("Erreur XML : pas pu lire l'instrument MIDI");
            }
            Partie partie = new Partie(new Instrument(numeroMIDI));
            
            partitionDonnees.partieAjouter(partie);
            partitionDonnees.partieClefsInstaller(partie);
        }
    }

    private static void traiterPartieContenu(PartitionDonnees partitionDonnees, Partie partie, Element elementPart) {
        List<Element> elementMesures = elementPart.getChildren("measure");

        divisions = 4800;
        Moment moment = partitionDonnees.getMomentDebut();
        for(Element elementMesure : elementMesures)
        {
            if(!partitionDonnees.isVide())
                partitionDonnees.elementMusicalAjouter(new BarreDeMesure(moment));
            moment = traiterElementsMesure(partitionDonnees, moment, partie, elementMesure);
        }
    }
    


    
    
}
