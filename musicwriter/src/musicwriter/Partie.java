/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.util.ArrayList;
import org.jdom.*;
/**
 * représente une partie dans une partition. Une partie... j'entends une partie
 * piano ou une partie violon etc.
 * @author François Schwarzentruber
 */
public class Partie extends ArrayList<Portee> {
    private Instrument instrument;
    private int numero = 0;
    private Intervalle transposition = Intervalle.getIntervalleNul();

    public Intervalle getTransposition() {
        return transposition;
    }


    public Tonalite getTonaliteTransposee(Tonalite tonalite)
    {
        Hauteur hauteurNoteTonaliteSiDO
                = getTransposition().getHauteur1(new Hauteur(0, Hauteur.NoteNom.DO,
                                                            Hauteur.Alteration.NATUREL
                ));

        Tonalite tonaliteSiDO = new Tonalite(hauteurNoteTonaliteSiDO);
        return new Tonalite(tonalite.getDiesesNombre() + tonaliteSiDO.getDiesesNombre() );
    }

    public void setTransposition(Intervalle transposition) {
        this.transposition = transposition;
    }

    
    
    public Partie(Instrument instrument)
    {
        super();
        this.instrument = instrument;
        if(instrument.getPorteesNombreStandard() == 2)
        {
            add(new Portee(this));
            add(new Portee(this));
            get(0).setNumero(1);
            get(1).setNumero(2);
        }
        else
        {
            add(new Portee(this));
            get(0).setNumero(1);
        }
    }



    

    void setInstrument(Instrument instrument)
    {
        this.instrument = instrument;
    }

    public Instrument getInstrument() {
        return instrument;
    }


    void setNumero(int numero)
    {
        this.numero = numero;
    }



    

    Element sauvegarder()
    {
        Element racine = new Element("score-part");
        racine.setAttribute("id", "P" + numero);

        Element scoreInstrument = new Element("score-instrument");
        scoreInstrument.setAttribute("id", "P" + numero + "I" + numero);

        racine.addContent(scoreInstrument);

        Element midiInstrument = new Element("midi-instrument");
        midiInstrument.setAttribute("id", "P" + numero + "I" + numero);
        Element midiChannel = new Element("midi-channel");
        midiChannel.setText(String.valueOf(numero));
        midiInstrument.addContent(midiChannel);

        Element midiProgram = new Element("midi-program");
        midiProgram.setText(String.valueOf(getInstrument().getNumeroMIDI()));
        midiInstrument.addContent(midiProgram);

        racine.addContent(midiInstrument);

        return racine;


    }



    public int getPorteesNombre()
    {
        return size();
    }

    public int getNumero() {
        return numero;
    }

/**
 *
 * @param numeroPortee
 * @return retourne la portée n° numeroPortee. numeroPortee est compris entre 1 et le nombre de portée.
 *
 * La première portée est n° 1.
 */
    public Portee getPortee(int numeroPortee)
    {
        return get(numeroPortee-1);
    }

    public Portee getPorteePremiere() {
        return get(0);
    }


    public Portee getPorteeDerniere() {
        return get(size() - 1);
    }



}
