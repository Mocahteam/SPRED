package exemple;

import exemple.ConstantList_KP_4_1;

import pp.PP;
import pp.Unit;

import java.awt.geom.Point2D;

public class Mission5 {
	public static void main (String[] args){
		try {
			// definition de la cible
			Point2D.Double pos = new Point2D.Double(256, 1024);
			// creer une interface avec le jeu
			PP pp = new PP();
			// ouverture du jeu
			pp.open();
			// parcourir toutes les unites
			for (int i = 0 ; i < pp.getNumUnits(PP.Coalition.MY_COALITION) ; i++){
				// recuperer l'unite courante
				Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
				// ordonner a mon unite courante de se deplacer
				u.command(ConstantList_KP_4_1.MOVE, pos);
			}
			// fermer le jeu
			pp.close();
		} catch (Exception e){
			System.out.println (e.getMessage());
		}
	}
}
