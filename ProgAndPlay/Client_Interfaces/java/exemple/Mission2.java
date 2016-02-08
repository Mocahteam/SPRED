package exemple;

import exemple.ConstantList_KP_4_1;

import pp.PP;
import pp.Unit;

import java.awt.geom.Point2D;

public class Mission2 {
	public static void main (String[] args){
		try {
			// creer une interface avec le jeu
			PP pp = new PP();
			// ouverture du jeu
			pp.open();
			// recuperation de l'unite courante
			Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, 0);
			// calcul de la coordonnee a atteindre
			Point2D depart = u.getPosition();
			Point2D.Double posArrivee = new Point2D.Double();
			posArrivee.x = depart.getX() - 927;
			posArrivee.y = depart.getY() + 513;
			// ordonner à cette unite de se deplacer sur la cible
			u.command(ConstantList_KP_4_1.MOVE, posArrivee);
			// fermer le jeu
			pp.close();
		} catch (Exception e){
			System.out.println (e.getMessage());
		}
	}
}
