package exemple;

import exemple.ConstantList_KP_4_1;

import pp.PP;
import pp.Unit;

import java.awt.geom.Point2D;

public class Mission4 {
	public static void main (String[] args){
		try {
			// definition des positions
			Point2D.Double bits = new Point2D.Double(1400, 1371);
			Point2D.Double bytes = new Point2D.Double(479, 1825);
			// creer une interface avec le jeu
			PP pp = new PP();
			// ouverture du jeu
			pp.open();
			// reuperation de la premiere unite
			Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, 0);
			if (u.getType() == ConstantList_KP_4_1.BIT){
				// ordonner a mon unite courante de se deplacer
				u.command(ConstantList_KP_4_1.MOVE, bits);
				// passer a l'unite suivante
				u = pp.getUnitAt(PP.Coalition.MY_COALITION, 1);
				// lui ordonner de rejoindre sa position
				u.command(ConstantList_KP_4_1.MOVE, bytes);
			}
			else {
				// ordonner a mon unite courante de se deplacer
				u.command(ConstantList_KP_4_1.MOVE, bytes);
				// passer a l'unite suivante
				u = pp.getUnitAt(PP.Coalition.MY_COALITION, 1);
				// lui ordonner de rejoindre sa position
				u.command(ConstantList_KP_4_1.MOVE, bits);
			}
			// fermer le jeu
			pp.close();
		} catch (Exception e){
			System.out.println (e.getMessage());
		}
	}
}
