/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sound.midi.InvalidMidiDataException;
import javax.sound.midi.MidiDevice;
import javax.sound.midi.MidiDevice.Info;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.MidiUnavailableException;
import javax.sound.midi.Receiver;
import javax.sound.midi.ShortMessage;

/**
 *
 * @author proprietaire
 */
public class MachineSortieMIDI  implements MachineSortie {


    HashMap<Instrument, Byte> instrumentToCanal = new HashMap<Instrument, Byte>();
    Receiver receiver = null;
    MidiDevice inputDevice = null;
    
    MachineSortieMIDI(MidiDevice machineSortieMIDI)
    {
        inputDevice = machineSortieMIDI;
    }
    

    private void receiverSend(ShortMessage message, long timeStamp)
    {
        if(receiver == null)
        {
             System.out.println("erreur midi, pas de receiver, j'envoie rien!");
        }
        else if(inputDevice.isOpen())
             receiver.send(message, timeStamp);
        else
            System.out.println("erreur midi, inputDevice fermé !");
    }


    private void changerInstrument(int canalMIDI, int instrumentNumero)
    {
        ShortMessage message = new ShortMessage();
        try {
            message.setMessage(0xC0 + canalMIDI, instrumentNumero, 0);
            receiverSend(message, -1);
        } catch (InvalidMidiDataException ex) {
            System.out.println("erreur midi, changement d'instrument, canal " + canalMIDI);
            Logger.getLogger(MachineSortieMIDI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    private int hauteurToNumeroMIDI(Hauteur hauteur)
    {
        return 12*5 + hauteur.getNbDemiTonsParRapportAuDoCentral();
        
    }
    
    public void traiterNoteEnfoncee(Hauteur hauteur, int velocite, int tempsEnMilliSecondes, Instrument instrument) {
        ShortMessage message = new ShortMessage();
        try {
            message.setMessage(0x90 + getNumeroCanalMIDIInstrument(instrument), hauteurToNumeroMIDI(hauteur), velocite);
            receiverSend(message, tempsEnMilliSecondes);
        } catch (InvalidMidiDataException ex) {
            Erreur.message("Désolé, je n'arrive pas à jouer la note... trop haute ou trop basse pour la machine MIDI...");
        }
          catch (java.lang.IllegalStateException ex) {
              Erreur.message("Désolé, je n'arrive pas à jouer la note... j'ai des problèmes diplomatiques avec la machine MIDI : en fait la machine MIDI est apparemment pas ouverte... bon... ben j'essaie de l'ouvrir...");
        }
    }    
        
    public void traiterNoteRelachee(Hauteur hauteur, int velocite, int tempsEnMilliSecondes, Instrument instrument) {
        ShortMessage message = new ShortMessage();
        try {
            message.setMessage(0x80 + getNumeroCanalMIDIInstrument(instrument), hauteurToNumeroMIDI(hauteur), 0);
            receiverSend(message, tempsEnMilliSecondes);
        } catch (InvalidMidiDataException ex) {
            Logger.getLogger(MachineSortieMIDI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private Info getMidiDeviceInfo(int index) {
        MidiDevice.Info[] aInfos = MidiSystem.getMidiDeviceInfo();
        if ((index < 0) || (index >= aInfos.length)) {
                    return null;
            }
            return aInfos[index];
    }

    private MidiDevice machineMIDIcreer(Info info) {
        MidiDevice inputDeviceEnCreation = null;
        try
        {
            inputDeviceEnCreation = MidiSystem.getMidiDevice(info);
            inputDeviceEnCreation.open();
            return inputDeviceEnCreation;
        }
        catch (MidiUnavailableException e)
        {
                System.out.println("Erreur de création de la machine MIDI");
                return null;
        }
    }
    
    
    public void demarrer()
    {
        if(!isDemarre())
            try {
                inputDevice.open();
                receiver = inputDevice.getReceiver();
                if(receiver == null)
                {
                    System.out.println("pas de receiver au démarrage de la machine MIDI!!");
                }
                instrumentToCanal.clear();
            } catch (MidiUnavailableException ex) {
                Erreur.message("Désolé, je n'arrive pas à ouvrir la machine MIDI.");
            }
    }
        
        
    public void arreter()
    {
        inputDevice.close();
    }


    public boolean isDemarre()
    {
        return inputDevice.isOpen();
    }

    private byte getNumeroCanalMIDIInstrument(Instrument instrument) {
        if(instrumentToCanal.containsKey(instrument))
            return instrumentToCanal.get(instrument);
        else
        {
            byte canalMIDI = (byte) instrumentToCanal.size();
            if(canalMIDI >= 10)
                canalMIDI++;
            instrumentToCanal.put(instrument, canalMIDI);
            changerInstrument(canalMIDI, instrument.getNumeroMIDI());
            return canalMIDI;
        }
    }


}
