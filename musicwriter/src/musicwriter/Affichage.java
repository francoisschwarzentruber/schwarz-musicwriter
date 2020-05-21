/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package musicwriter;

import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Area;

/**
 * Cette interface sert à représenter toute zone à l'écran qui sera affiché.
 *
 * Exemple : une note à l'écran, une barre de mesure, un changement de tonalité etc.
 * @author François Schwarzentruber
 */
interface Affichage {

    public double getX();
    void setX(double x);
    
    /**
     * Cette fonction dessine l'objet dans l'objet g.
     * @param g
     */
    void draw(Graphics2D g);
    /**
     *
     * @return la région où il y a affiché quelque chose.
     */
    Area getArea();


    /**
     *
     * @return le plus petit rectangle contenant la région où il y a affiché quelque chose.
     */
    Rectangle getRectangle();

    /**
     *
     * @param area
     * @return la sélection (ensemble d'éléments musicaux) qui intersecte la région area.
     */
    public Selection getSelection(Shape area);
    
    
    ElementMusical getElementMusical(Point point);
    
}
