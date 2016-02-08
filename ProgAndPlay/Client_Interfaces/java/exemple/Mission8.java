package exemple;

import exemple.ConstantList_KP_4_1;

import pp.PP;
import pp.Unit;
import pp.exceptions.PPException;

import java.awt.geom.Point2D;

public class Mission8 {

	private PP pp;
	private static final int NBBYTES = 3;

	public Mission8 (){
		// creer une interface avec le jeu
		pp = new PP();
	}
	
	public void start () throws PPException {
		Point2D.Double attaque = new Point2D.Double(1792, 256);
		Point2D.Double bytes = new Point2D.Double(478, 255);
		Point2D.Double bits = new Point2D.Double(255, 255);
		pp.open();
		System.out.println("Trier les unites");
		trierUnites(bytes, bits);
		System.out.println("Attendre le depart");
		attendreDepart();
		System.out.println("Attendre le rassemblement");
		attendreRassemblement();
		System.out.println("Lancer l'attaque");
		lancerAttaque(attaque);
		pp.close();
	}
	
	public static void main (String[] args){
		try {
			Mission8 m8 = new Mission8();
			m8.start();
		} catch (Exception e){
			System.out.println ("Exception : "+e.getMessage());
		}
	}
	
	//trie l'ensemble des unites du joueur
	private void trierUnites (Point2D raliementBytes, Point2D raliementBits) throws PPException {
		try{
			for (int i = 0 ; i < pp.getNumUnits(PP.Coalition.MY_COALITION) ; i++){
				Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
				if (u.getType() != ConstantList_KP_4_1.BYTE)
					u.command(ConstantList_KP_4_1.MOVE, raliementBits);
				else
					u.command(ConstantList_KP_4_1.MOVE, raliementBytes);
			}
		} catch (PPException e){
			System.out.println ("Exception : "+e.getMessage());
		}
	}
	
	// attendre le depart des unites
	private void attendreDepart() throws PPException {
		boolean fini = false;
		while (!fini){
			int i = 0;
			try{
				while (i < pp.getNumUnits(PP.Coalition.MY_COALITION) && !fini){
					Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
					if (u.getPendingCommands().size() > 0)
						fini = true;
					i++;
				}
			} catch (PPException e){
				System.out.println ("Exception : "+e.getMessage());
			}
		}
	}
	
	// attendre la fin du rassemblement
	private void attendreRassemblement() throws PPException {
		boolean fini = false;
		while (!fini){
			fini = true;
			int i = 0;
			try{
				while (i < pp.getNumUnits(PP.Coalition.MY_COALITION) && fini){
					Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
					if (u.getPendingCommands().size() > 0)
						fini = false;
					i++;
				}
			} catch (PPException e){
				System.out.println ("Exception : "+e.getMessage());
				fini = false;
			}
		}
	}
	
	// lance l'attaque sur la position pos
	private void lancerAttaque (Point2D pos) throws PPException {
		// recuperer le premier assembleur et les octets
		int i = 0;
		int cpt = 0;
		boolean assembleurNonTrouve = true;
		Unit assembleur = null;
		Unit [] bytes = new Unit [NBBYTES];
		for (i = 0 ; i < pp.getNumUnits(PP.Coalition.MY_COALITION) ; i++){
			Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
			if (assembleurNonTrouve && u.getType() == ConstantList_KP_4_1.ASSEMBLER){
				assembleurNonTrouve = false;
				assembleur = u;
			}
			if (cpt < NBBYTES && u.getType() == ConstantList_KP_4_1.BYTE){
				bytes[cpt] = u;
				cpt++;
			}
		}
		
		// lancer la marche
		for (i = 0 ; i < pp.getNumUnits(PP.Coalition.MY_COALITION) ; i++){
			Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
			if (u.getType() == ConstantList_KP_4_1.BYTE)
				u.command(ConstantList_KP_4_1.FIGHT, pos);
			else
				u.command(ConstantList_KP_4_1.GUARD, bytes[0]);
		}
		
		// avancer jusqu'a trouver l'ennemi
		while (pp.getNumUnits(PP.Coalition.ENEMY_COALITION) == 0){
			//System.out.println("Avancer jusqu'a trouver l'ennemi");
		}
		
		// tout lacher (sauf l'assembleur)
		for (i = 0 ; i < pp.getNumUnits(PP.Coalition.MY_COALITION) ; i++){
			Unit u = pp.getUnitAt(PP.Coalition.MY_COALITION, i);
			if (u.getType() != ConstantList_KP_4_1.ASSEMBLER)
				u.command(ConstantList_KP_4_1.FIGHT, pos);
		}
		
		// reparer les bytes endommages
		int urgencePrecedente = -1;
		boolean assembleurToujoursVivant = true;
		try{
			assembleur.getType(); // leve une exception si l'unite a ete detruite
		} catch (PPException e){
			assembleurToujoursVivant = false;
		}
		while (!pp.isGameOver() && assembleurToujoursVivant){
			// tester si l'assembleur est toujours vivant
			try{
				assembleur.getType(); // leve une exception si l'unite a ete detruite
			} catch (PPException e){
				assembleurToujoursVivant = false;
			}
			if (assembleurToujoursVivant){
				// supprimer les octets detruits
				i = 0;
				while (i < cpt){
					try{
						bytes[i].getType(); // leve une exception si l'unite a ete detruite
						i++;
					} catch (PPException e){
						// supprimer cet octet
						int j = i;
						while (j+1 < cpt){
							bytes[j] = bytes[j+1];
							j++;
						}
						cpt--;
					}
				}
				// recherche de l'octet le plus endomage
				i = 0;
				int urgent = -1;
				while (i < cpt){
					// verifier si l'octet courant est plus prioritaire que la precedente urgence
					if (urgent == -1)
						urgent = i;
					if (i != urgent){
						try{
							if (bytes[i].getHealth() < bytes[urgent].getHealth())
								urgent = i;
						} catch (PPException e){
							System.out.println ("Exception : "+e.getMessage());
						}
					}
					i++;
				}
				if (urgent != -1){
					try{
						if (urgent != urgencePrecedente || assembleur.getPendingCommands().size() == 0){
							assembleur.command(ConstantList_KP_4_1.REPAIR, bytes[urgent]);
							urgencePrecedente = urgent;
						}
					} catch (PPException e){
						System.out.println ("Exception : "+e.getMessage());
					}
				}
			}
		}
	}
}
