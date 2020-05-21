/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import org.jdom.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.TreeMap;

/**
 *
 * @author proprietaire
 */
public class PartitionDonnees {
    private boolean is_modifie = false;

    private TreeMap<Moment, HashSet<ElementMusical>> elementsMusicaux = new TreeMap<Moment, HashSet<ElementMusical>>();
    private ArrayList<Partie> parties = new ArrayList<Partie>();
    private ArrayList<Portee> portees = new ArrayList<Portee>();
    private TreeMap<Moment, ElementMusicalChangementTonalite> elementsMusicauxChangementTonalite
            = new TreeMap<Moment, ElementMusicalChangementTonalite>();
    private TreeMap<Moment, BarreDeMesure> elementsMusicauxBarreDeMesure
            = new TreeMap<Moment, BarreDeMesure>();
    private TreeMap<Moment, ElementMusicalChangementMesureSignature> elementsMusicauxChangementMesureSignature
            = new TreeMap<Moment, ElementMusicalChangementMesureSignature>();
    private TreeMap<Moment, ElementMusicalTempo> elementsMusicauxTempo
            = new TreeMap<Moment, ElementMusicalTempo>();


//***********************************************************************************
// ACCEDER AUX DONNEES DE MA PARTITION
    //*******************************************************************************


    // Les moments

    public Moment getMomentDebut()
    {
        return new Moment(new Rational(0, 1));
        
    }

/**
 * @return le dernier moment de la partition. Certifié comme "ne retourne JAMAIS null" :).
 */
    Moment getMomentFin() {
        if(elementsMusicaux.isEmpty())
            return getMomentDebut();
        else
        {
            Moment moment = elementsMusicaux.lastKey();

            Moment lastmoment = moment;
            while(moment != null)
            {
                lastmoment = moment;
                moment = getMomentSuivant(moment);
            }
            return lastmoment;
        }
    }


    
    Moment getMomentMesureDebut(Moment moment)
    {
        Moment momentD = elementsMusicauxBarreDeMesure.floorKey(moment);

        if(momentD != null)
        {
            return momentD;
        }
        else
        {
            return getMomentDebut();
        }
    }


    Moment getMomentMesureFin(Moment moment)
    {
        Moment momentD = elementsMusicauxBarreDeMesure.higherKey(moment);

        if(momentD != null)
        {
            return momentD;
        }
        else
        {
            return getMomentFin();
        }
    }



/**
 *
 * @param p
 * @param debut
 * @param fin
 * @return retourne true ssi il n'y a aucun élément musical sur la portée p entre le moment debut inclus et le moment fin exclus
 */
    public boolean porteeIsVide(Portee p, Moment debut, Moment fin)
    {
        Moment moment = elementsMusicaux.ceilingKey(debut);

        if(moment == null)
             return true;
        
        while(moment.isStrictementAvant(fin))
        {
            HashSet<ElementMusical> els = elementsMusicaux.get(moment);
            for(ElementMusical el : els)
            {
                if(el instanceof ElementMusicalSurPortee)
                {
                    ElementMusicalSurPortee elp = (ElementMusicalSurPortee) el;
                    if(elp.getPortee().equals(p))
                    {
                        return false;
                    }
                }
            }
            moment = elementsMusicaux.higherKey(moment);
            if(moment == null)
                return true;
        }
        return true;
        
    }


    boolean isVide() {
        return elementsMusicaux.isEmpty();
    }

    
    
    public Moment getMomentSuivantAvecElementsMusicauxQuiDebutent(Moment momentactuel)
    {
        return elementsMusicaux.higherKey(momentactuel);
    }

    /*donne le moment suivant*/
    public Moment getMomentSuivant(Moment momentactuel)
    {
        Moment moment_candidat = elementsMusicaux.higherKey(momentactuel);
        
        MomentNotesSurLeFeu momentNotesSurLeFeu = getMomentNotesSurLeFeu(momentactuel);
        
        Set<ElementMusicalDuree> elementsMusicauxConcernees = momentNotesSurLeFeu.getElementsMusicauxAvecDureeConcernees();
        for(ElementMusicalDuree element : elementsMusicauxConcernees)
        {
            Moment fin = element.getFinMoment();
            
            if(fin.isStrictementApres(momentactuel))
            {
                if(moment_candidat == null)
                {
                    moment_candidat = fin;
                }
                else
                if(moment_candidat.isApres(fin))
                {
                     moment_candidat = fin;
                }
            }
        }


       return moment_candidat;
        
    }


    private Moment getMomentPrecedent(Moment moment) {
        Moment momentPrecedent = elementsMusicaux.lowerKey(moment);

        if(momentPrecedent == null)
            return getMomentDebut();
        else
            return momentPrecedent;
    }
    
    
    
    
    
    public Curseur voixDeviner(Curseur curseur, Duree dureeProposee)
    {
        MomentNotesSurLeFeu momentNotesSurLeFeu = getMomentNotesSurLeFeu(curseur.getMoment());
        Set<Note> notesrelachees = momentNotesSurLeFeu.getNotesQuiSontRelachees();
        
        Voix voix = null;

        int distancecourante = 1000;
        for(Note note : notesrelachees)
        {
            int nouvelledistance = Math.abs(note.getHauteur().getNumero() - curseur.getHauteur().getNumero());
            if(note.getPortee().equals(curseur.getPortee()) & (nouvelledistance < distancecourante))
            {
                voix = note.getVoix();
                distancecourante = nouvelledistance;
            }
        }
        
        
        if(voix == null)
        {
            voix = new Voix();
        }
        else
        {
            ElementMusicalSurVoix el = momentNotesSurLeFeu.getElementMusicalSurVoix(voix);

            if(el != null)
            {
                if(!el.getDuree().equals(dureeProposee))
                    voix = new Voix();
            }
        }




        return new Curseur(curseur.getMoment(),  curseur.getHauteur(), curseur.getPortee(), voix);
    }
    
    
    
    public MomentNotesSurLeFeu getMomentNotesSurLeFeu(Moment momentActuel)
    {
        MomentNotesSurLeFeu notesSurLeFeu = new MomentNotesSurLeFeu(momentActuel);
        
        Moment moment = elementsMusicaux.floorKey(momentActuel);
        
        for(int i = 0; (i<30) & (moment != null); i++)
        {
            Set<ElementMusical> c = elementsMusicaux.get(moment);
            for(ElementMusical n : c)
            {
                if(n.getDebutMoment().isEgal(momentActuel))
                {
                    notesSurLeFeu.NotesAJouerAjouter(n);
                }
                else if(n instanceof ElementMusicalDuree)
                {
                    ElementMusicalDuree nd = (ElementMusicalDuree) n;
                    if(nd.getDebutMoment().isStrictementAvant(momentActuel) &&
                            momentActuel.isStrictementAvant(nd.getFinMoment()))
                    {
                        notesSurLeFeu.NotesQuiPerdurentAjouter(nd);
                    }
                    else if(nd.getFinMoment().isEgal(momentActuel))
                    {
                        notesSurLeFeu.NotesQuiSontRelachees(nd);
                    }
                }

            }
            
            moment = elementsMusicaux.lowerKey(moment);
        }
        
        return notesSurLeFeu;
        
    }
    
    

    

    
    

    
    
    
    
    public Set<ElementMusical> getElementsMusicauxQuiCommencent(Moment moment)
    {
        if(elementsMusicaux.containsKey(moment))
            //faire une copie pour éviter les effets de bords
            return (Set<ElementMusical>) elementsMusicaux.get(moment).clone();
        else
            return new HashSet<ElementMusical>();
    }



    public Set<ElementMusical> getElementsMusicauxPartieQuiCommencent(Moment moment, Partie partie)
    {
        if(elementsMusicaux.containsKey(moment))
        {
            HashSet<ElementMusical> els = new HashSet<ElementMusical>();
            for(ElementMusical el : elementsMusicaux.get(moment))
            {
                if(el instanceof ElementMusicalSurPortee)
                {
                    if(((ElementMusicalSurPortee) el).getPortee().getPartie() == partie)
                    {
                        els.add(el);
                    }
                }
                else
                {
                    els.add(el);
                }
            }
            //faire une copie pour éviter les effets de bords
            return els;
        }
        else
            return new HashSet<ElementMusical>();
    }



    public Set<Note> getNotesPorteeQuiCommencent(Moment moment, Portee portee)
    {
        if(elementsMusicaux.containsKey(moment))
        {
            HashSet<Note> els = new HashSet<Note>();
            for(ElementMusical el : elementsMusicaux.get(moment))
            {
                if(el instanceof Note)
                {
                    Note note = (Note) el;
                    if(note.getPortee().equals(portee))
                    {
                        els.add(note);
                    }
                }
            }
            //faire une copie pour éviter les effets de bords
            return els;
        }
        else
            return new HashSet<Note>();
    }
    
    
    public BarreDeMesure getMesureBarreDeMesureDebut(Moment moment)
    {
        if(elementsMusicauxBarreDeMesure.containsKey(moment))
            return elementsMusicauxBarreDeMesure.get(moment);
        else
            return null;
    }



    ElementMusicalChangementMesureSignature getElementMusicalMesureSignature(Moment moment) {
        Moment momentChangementSignature = elementsMusicauxChangementMesureSignature.floorKey(moment);

        if(momentChangementSignature == null)
            return null;
        else
            return elementsMusicauxChangementMesureSignature.get(momentChangementSignature);
    }




    public int getNbNoiresParMinute(Moment moment) {
        Moment momentChangementTempo = elementsMusicauxTempo.floorKey(moment);

        if(momentChangementTempo == null)
            return 120;
        else
            return elementsMusicauxTempo.get(momentChangementTempo).getNbNoiresEnUneMinute();
    }

    public MesureSignature getMesureSignature(Moment moment)
    {
        Moment momentChangementSignature = elementsMusicauxChangementMesureSignature.floorKey(moment);

        if(momentChangementSignature == null)
            return new MesureSignature(4, 4);
        else
            return elementsMusicauxChangementMesureSignature.get(momentChangementSignature).getSignature();
    }



    public ElementMusical getElementMusical(Moment moment, Class<? extends ElementMusical> elementMusicalSousClasse)
    {
        Set<ElementMusical> els = getElementsMusicauxQuiCommencent(moment);

        for(ElementMusical el : els)
        {
            if(el.getClass().equals(elementMusicalSousClasse))
            {
                return el;
            }
        }

        return null;
    }

    /**
     *
     * @param moment
     * @param portee
     * @return retourne l'élement musical qui est une clef placé sur la portée portee
     * et au moment moment EXACTEMENT.
     */
    public ElementMusicalClef getElementMusicalClefPileDessus(Moment moment, Portee portee)
    {
        ElementMusicalClef emc = portee.getElementMusicalClef(moment);
        
        if(emc == null)
        {
            return null;
        }
        else
        {
            if(emc.getDebutMoment().equals(moment))
                 return emc;
            else
                 return null;
        }
        
    }

    public ElementMusicalChangementTonalite getElementMusicalChangementTonaliteCourant(Moment moment)
    {
        Moment momentChangementTonalite = elementsMusicauxChangementTonalite.floorKey(moment);

        if(momentChangementTonalite == null)
            return null;
        else
            return elementsMusicauxChangementTonalite.get(momentChangementTonalite);
    }

    public Tonalite getTonalite(Moment moment)
    {
        Moment momentChangementTonalite = elementsMusicauxChangementTonalite.floorKey(moment);

        if(momentChangementTonalite == null)
            return new Tonalite(0);
        else
            return elementsMusicauxChangementTonalite.get(momentChangementTonalite).getTonalite();
    }


    public Tonalite getTonaliteJusteAvant(Moment moment)
    {
        Moment momentChangementTonalite = elementsMusicauxChangementTonalite.lowerKey(moment);

        if(momentChangementTonalite == null)
            return new Tonalite(0);
        else
            return elementsMusicauxChangementTonalite.get(momentChangementTonalite).getTonalite();
    }


    public Tonalite getTonalite(Moment moment, Partie partie)
    {
        return partie.getTonaliteTransposee(getTonalite(moment));
    }



    public Tonalite getTonaliteJusteAvant(Moment moment, Partie partie)
    {
        return partie.getTonaliteTransposee(getTonaliteJusteAvant(moment));
    }


    public Hauteur.Alteration getAlterationParDefaut(Moment moment, Moment momentOnRegardePasAvant, Portee portee, Hauteur hauteur)
    {
        Moment momentMesureDebut = getMomentMesureDebut(moment);

        if(!moment.equals(momentMesureDebut))
        {
            moment = getMomentPrecedent(moment);

            while(moment.isApres(momentMesureDebut) && momentOnRegardePasAvant.isAvant(moment))
            {
                for(Note note : getNotesPorteeQuiCommencent(moment, portee))
                {
                    if(note.getHauteur().getNumero() == hauteur.getNumero())
                        return note.getHauteur().getAlteration();
                }



                moment = getMomentPrecedent(moment);

                if(isMomentDebut(moment))
                    break;

            }
        }
        
         return getTonalite(moment, portee.getPartie()).getAlteration(hauteur);
    }






    

    // les portées

    public int getPorteesNombre()
    {
        return portees.size();
    }

    public Portee getPortee(int i) {
        return portees.get(i);
    }


    public Portee getPorteePremiere()
    {
        return portees.get(0);
    }

    public Portee getPorteeDerniere()
    {
        return portees.get(portees.size() - 1);
    }

    Iterable<Portee> getPortees() {
        return portees;
    }


    public ArrayList<Partie> getParties() {
        return parties;
    }


    Selection getSelectionTout()
    {
        Selection s = new Selection();
        for(Set<ElementMusical> E : elementsMusicaux.values())
        {
            s.ajouterSelection(E);
        }
        return s;
    }


    Selection getSelectionToutApresMoment(Moment moment)
    {
        Selection s = new Selection();
        moment = elementsMusicaux.ceilingKey(moment);
        for(; moment != null; moment = elementsMusicaux.higherKey(moment))
        {
            s.ajouterSelection(elementsMusicaux.get(moment));
        }
        
        return s;
    }


    Selection getSelectionToutPartie(Partie partie)
    {
        Selection s = new Selection();
        for(Set<ElementMusical> E : elementsMusicaux.values())
        {
            for(ElementMusical el : E)
            {
                if(el instanceof ElementMusicalSurPortee)
                {
                    if(((ElementMusicalSurPortee) el).getPortee().getPartie() == partie)
                    {
                        s.ajouterElementMusical(el);
                    }
                }
            }
            
            
        }
        return s;
    }


//***************************************************************************
//  LA SAUVEGARDE EN MusicXML
//*****************************************************************************




    private Element partiesStructureSauvegarder()
    {
        Element racine = new Element("part-list");

        for(Partie partie : getParties())
        {
            racine.addContent(partie.sauvegarder());
        }
        return racine;
    }



    Element partieContenuSauvegarder(Partie partie)
    {
        Element elementPart = new Element("part");
        elementPart.setAttribute("id", "P" + partie.getNumero());

        Element elementMesure = new Element("measure");
        elementPart.addContent(elementMesure);

        Element elementAttributes = new Element("attributes");
        elementMesure.addContent(elementAttributes);

        Element elementStaves = new Element("staves");
        elementStaves.setText(String.valueOf(partie.getPorteesNombre()));
        elementAttributes.addContent(elementStaves);
        elementAttributes.addContent(new Element("divisions").setText(String.valueOf(Duree.divisionsStandard)));

        if(!partie.getTransposition().isNull())
        {
            Element elementTranspose = new Element("transpose");
            Element elementTransposeDiatonic = new Element("diatonic");
            elementTransposeDiatonic.setText(String.valueOf(partie.getTransposition().getNumero()));

            Element elementTransposeChromatic = new Element("chromatic");
            elementTransposeChromatic.setText(String.valueOf(partie.getTransposition().getNbDemiTonsParRapportAuDoCentral()));

            elementTranspose.addContent(elementTransposeDiatonic);
            elementTranspose.addContent(elementTransposeChromatic);
            elementAttributes.addContent(elementTranspose);

        }

        elementMesure.addContent(new Element("direction").addContent(new Element("sound").setAttribute("tempo", "80")));
        
        for(Moment moment = getMomentDebut(); moment != null; moment = getMomentSuivantAvecElementsMusicauxQuiDebutent(moment))
        {
            Set<ElementMusical> els = getElementsMusicauxPartieQuiCommencent(moment, partie);

            BarreDeMesure barreDeMesure = getMesureBarreDeMesureDebut(moment);
            if(barreDeMesure != null)
            {
                elementMesure = new Element("measure");
                elementPart.addContent(elementMesure);
                elementAttributes = new Element("attributes");
                elementMesure.addContent(elementAttributes);
                els.remove(barreDeMesure);
            }

            for(ElementMusical el : els)
            {
                if(el instanceof ElementMusicalChangementTonalite)
                {
                    elementMesure.addContent(new Element("attributes").addContent(el.sauvegarder()));
                }
                else
                if(el instanceof ElementMusicalChangementMesureSignature)
                {
                    elementMesure.addContent(new Element("attributes").addContent(el.sauvegarder()));
                }
                else
                if(el instanceof ElementMusicalChangementMesureSignature)
                {
                    elementMesure.addContent(new Element("attributes").addContent(el.sauvegarder()));
                }
                else
                if(el instanceof ElementMusicalClef)
                {
                    elementMesure.addContent(new Element("attributes").addContent(el.sauvegarder()));
                }
                else
                    elementMesure.addContent(el.sauvegarder());
                
                if(el instanceof ElementMusicalDuree)
                       elementMesure.addContent(((ElementMusicalDuree) el).getDuree().getElementBackUp());

            }

            if(getMomentSuivant(moment) != null)
            {
                 elementMesure.addContent((new Duree(moment, getMomentSuivant(moment))).getElementForward());
            }
        }

        return elementPart;
    }


    public Document sauvegarder()
    {
        Element racine = new Element("score-partwise");
        Document document = new Document(racine);
        
        racine.addContent(partiesStructureSauvegarder());

        for(Partie partie : getParties())
        {
              racine.addContent(partieContenuSauvegarder(partie));
        }

        
        return document;
    
    }



    
    









//************************************************************************************
// MODIFICATION DE LA PARTITION
//************************************************************************************

    // modifier la structure de ma partition


    private void porteesCalculer() {

        for(int i = 0; i <= parties.size() - 1; i++)
        {
            parties.get(i).setNumero(i);
        }

        portees = new ArrayList<Portee>();

        for(Partie partie : parties)
        {
            portees.addAll(partie);
        }

        for(int i = 0; i <= portees.size() - 1; i++)
        {
            portees.get(i).setNumeroAffichage(i);
        }

    }

    public void partieSupprimer(int index) {
        parties.remove(index);
        porteesCalculer();
    }

    public void partieAjouter(Partie partie)
    {
        parties.add(partie);
        porteesCalculer();
    }



    public void partieAjouter(int i, Partie partie)
    {
        parties.add(i, partie);
        porteesCalculer();
    }


    public void partieSupprimer(Partie partie)
    {
        parties.remove(partie);
    }











    // modification de la partition

    void elementMusicalDeplacer(ElementMusical element, Moment debutMomentFutur) {
        elementMusicalSupprimer(element);
        element.deplacer(debutMomentFutur);
        elementMusicalAjouter(element);
    }



    public void elementMusicalAjouter(ElementMusical element)
    {
        Moment moment = element.getDebutMoment();

        if(element instanceof ElementMusicalChangementTonalite)
        {
            if(elementsMusicauxChangementTonalite.containsKey(element.getDebutMoment()))
                return;
            
            elementsMusicauxChangementTonalite.put(moment, (ElementMusicalChangementTonalite) element);

        }

        if(element instanceof ElementMusicalTempo)
        {
            if(elementsMusicauxTempo.containsKey(element.getDebutMoment()))
                return;

            elementsMusicauxTempo.put(moment, (ElementMusicalTempo) element);

        }

        if(element instanceof ElementMusicalChangementMesureSignature)
        {
            if(elementsMusicauxChangementMesureSignature.containsKey(element.getDebutMoment()))
                return;

            elementsMusicauxChangementMesureSignature.put(moment, (ElementMusicalChangementMesureSignature) element);

        }


        if(element instanceof ElementMusicalClef)
        {
            if(((ElementMusicalClef) element).getPortee().getElementMusicalClef(moment) != null)
            {
                if(((ElementMusicalClef) element).getPortee().getElementMusicalClef(moment).getDebutMoment().equals(moment))
                    return;
            }
                

            ElementMusicalClef elementClef = (ElementMusicalClef) element;
            elementClef.getPortee().clefAjouter(elementClef);
        }
            

        
        if(element instanceof BarreDeMesure)
        {
            if(element.getDebutMoment().equals(getMomentDebut()))
                return;

            if(elementsMusicauxBarreDeMesure.containsKey(element.getDebutMoment()))
                return;

            elementsMusicauxBarreDeMesure.put(moment, (BarreDeMesure) element);
        }

        if(elementsMusicaux.containsKey(moment))
        {
            Set<ElementMusical> els = elementsMusicaux.get(element.getDebutMoment());
            els.add(element);
        }
        else
        {
             HashSet<ElementMusical> els = new HashSet<ElementMusical>();
             els.add(element);
             elementsMusicaux.put(moment, els);
        }

        modificationOui();


    }



    public void elementMusicalSupprimer(ElementMusical element)
    {
        Moment moment = element.getDebutMoment();
        Set<ElementMusical> els = elementsMusicaux.get(moment);
        els.remove(element);
        if(els.isEmpty())
        {
            elementsMusicaux.remove(moment);
        }

        if(element instanceof ElementMusicalChangementTonalite)
        {
           ElementMusicalChangementTonalite eltonalite = (ElementMusicalChangementTonalite) element;
           elementsMusicauxChangementTonalite.remove(eltonalite.getDebutMoment());
        }

        if(element instanceof ElementMusicalTempo)
        {
           ElementMusicalTempo eltempo = (ElementMusicalTempo) element;
           elementsMusicauxTempo.remove(eltempo.getDebutMoment());
        }

        if(element instanceof BarreDeMesure)
        {
           BarreDeMesure barre = (BarreDeMesure) element;
           elementsMusicauxBarreDeMesure.remove(barre.getDebutMoment());
        }

        if(element instanceof ElementMusicalChangementMesureSignature)
        {
           ElementMusicalChangementMesureSignature barre = (ElementMusicalChangementMesureSignature) element;
           elementsMusicauxChangementMesureSignature.remove(barre.getDebutMoment());
        }

        if(element instanceof ElementMusicalClef)
        {
            ElementMusicalClef elementClef = (ElementMusicalClef) element;
            elementClef.getPortee().clefSupprimer(elementClef);
        }


        modificationOui();

    }

    public boolean isBarreDeMesure(Moment moment) {
        return elementsMusicauxBarreDeMesure.containsKey(moment);
    }

    public boolean isModifie() {
        return is_modifie;
    }


    public void setPasDeModification()
    {
        is_modifie = false;
    }


    private void modificationOui()
    {
        is_modifie = true;
    }

    private boolean isMomentDebut(Moment moment) {
        return moment.equals(getMomentDebut());
    }


    private boolean isMomentFin(Moment moment) {

        return moment.equals(getMomentFin());
    }

    boolean porteeIsMesureVide(Portee p, Moment debutMoment) {
        return porteeIsVide(p, debutMoment, getMomentMesureFin(debutMoment));
    }

    boolean isDebutMesure(Moment moment) {
        return (isMomentDebut(moment) | isBarreDeMesure(moment)) & !isMomentFin(moment);
    }

    /**
     *
     * @param moment
     * @return true ssi le moment ne contient pas d'élément musical dessus
     */
    public boolean isMomentVide(Moment moment) {
        return !elementsMusicaux.containsKey(moment);
    }


    /**
     *
     * @param moment
     * @return true ssi le moment ne contient pas de notes
     */
    public boolean isMomentPasDeNotes(Moment moment) {
        if(elementsMusicaux.containsKey(moment))
        {
            for(ElementMusical el : elementsMusicaux.get(moment))
            {
                if(el instanceof Note)
                    return false;
            }
            return true;
        }
        else
        {
            return true;
        }
    }



    public void partieClefsInstaller(Partie partie) {
        if(partie.size() == 2)
        {
            elementMusicalAjouter(new ElementMusicalClef(getMomentDebut(), partie.get(0), Portee.Clef.ClefDeSol));
            elementMusicalAjouter(new ElementMusicalClef(getMomentDebut(), partie.get(1), Portee.Clef.ClefDeFa));
        }
        else
        {
            elementMusicalAjouter(new ElementMusicalClef(getMomentDebut(), partie.get(0), Portee.Clef.ClefDeSol));
        }

    }


    /**
     *
     * @param curseur
     * @return retourne un nouveau curseur qui est placé à peu près
     * sur l'élément musical qui précède
     * le curseur dans la même voix que celle spécifiée dans curseur.
     * Si un tel élément musical n'existe pas, cette fonction retourne null.
     */
    Curseur getCurseurPrecedentMemeVoix(Curseur curseur) {
        Set<ElementMusicalDuree> elementsMusicauxQuiSontRelachees = getMomentNotesSurLeFeu(curseur.getMoment()).getElementsMusicauxQuiSontRelachees();

        for(ElementMusicalDuree el : elementsMusicauxQuiSontRelachees)
        {
            if(el instanceof ElementMusicalSurVoix)
            {
                ElementMusicalSurVoix elv = (ElementMusicalSurVoix) el;

                if(elv.getVoix().equals(curseur.getVoix()))
                {
                    return new Curseur(elv.getDebutMoment(), curseur.getHauteur(), elv.getPortee(), curseur.getVoix());
                }
            }
        }
        return null;

    }



}
