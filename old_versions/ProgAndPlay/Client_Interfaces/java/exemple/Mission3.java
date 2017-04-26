package exemple;

import exemple.ConstantList_KP_4_1;

import pp.PP;
import pp.Unit;

public class Mission3 {
	public static void main (String[] args){
		try {
			// creer une interface avec le jeu
			PP pp = new PP();
			// ouverture du jeu
			pp.open();
			// recuperation de l'unite courante
			Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, 0);
			// attendre l'ennemi
			while (pp.getNumUnits(PP.Coalition.ENEMY_COALITION) == 0)
				System.out.println("En attente de l'arrivée de l'ennemi");
			// recuperer l'unte ennemie
			Unit e = pp.getUnitAt(PP.Coalition.ENEMY_COALITION, 0);
			// attaquer
			u.command(ConstantList_KP_4_1.ATTACK, e);
			// fermer le jeu
			pp.close();
		} catch (Exception e){
			System.out.println (e.getMessage());
		}
	}
}
