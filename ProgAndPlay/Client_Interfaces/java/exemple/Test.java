package exemple;

import exemple.ConstantList_KP_4_1;

import pp.PP;
import pp.Unit;
import pp.exceptions.*;

import java.awt.geom.Point2D;

public class Test {
	public static void main (String[] args){
		// définition de la coordonnée cible à atteindre
		Point2D.Float p = new Point2D.Float (100, 100);
		try {
			// créer une interface avec le jeu
			PP pp = new PP();
			// ouverture du jeu
			pp.open();
			while (!pp.isGameOver()){
				for (int i = 0 ; i < pp.getNumUnits (PP.Coalition.MY_COALITION) ; i++){
					Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
					System.out.print(u.getId()+" - ");
					for (int j = 0 ; j < u.getPendingCommands().size() ; j++){
						System.out.print(u.getPendingCommands().get(j).getCode()+" (");
						for (int k = 0 ; k < u.getPendingCommands().get(j).getParams().size() ; k++)
							System.out.print(" "+u.getPendingCommands().get(j).getParams().get(k));
						System.out.print(")");
					}
					// if (u.getPendingCommands().size() > 8){
						// System.out.println("STOP_BUILDING");
						// u.command(ConstantList_KP_4_1.STOP_BUILDING, (float)-1.0);
					// }
					System.out.println();
				}
			}
			// fermer le jeu
			pp.close();
		} catch (Exception e){
			System.out.println (e.getMessage());
		}
	}
}
