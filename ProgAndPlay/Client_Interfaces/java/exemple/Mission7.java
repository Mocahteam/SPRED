package exemple;

import exemple.ConstantList_KP_4_1;

import pp.PP;
import pp.Unit;

public class Mission7 {
	public static void main (String[] args){
		try {
			// creer une interface avec le jeu
			PP pp = new PP();
			// ouverture du jeu
			pp.open();
			// recherche de l'assembleur
			int i = 0;
			Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
			while (i < pp.getNumUnits(PP.Coalition.MY_COALITION) && u.getType() != ConstantList_KP_4_1.ASSEMBLER){
				// passer a l'unite suivante
				i = i + 1;
				u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
			}
			if (u.getType() == ConstantList_KP_4_1.ASSEMBLER){
				Unit assembleur = u;
				// reparation des unites
				for (i = 0 ; i < pp.getNumUnits(PP.Coalition.MY_COALITION) ; i++){
					u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
					if (u.getHealth() < u.getMaxHealth()){
						assembleur.command(ConstantList_KP_4_1.REPAIR, u);
						while (u.getHealth() < u.getMaxHealth()){
							System.out.println("Sante de l'unite "+u.getId()+" : "+u.getHealth()+"/"+u.getMaxHealth());
						}
					}
				}
			}
			// fermer le jeu
			pp.close();
		} catch (Exception e){
			System.out.println (e.getMessage());
		}
	}
}
