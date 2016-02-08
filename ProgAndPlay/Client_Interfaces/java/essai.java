//import pp.PPNative;

public class essai {
	public static void main (String[] args){
/*		System.out.println ("ouverture");
		PPNative.Open();
		System.out.println ("début attente");
		try {
			Thread.sleep(5000);
		} catch (InterruptedException e) {
			System.out.println("(délai - Erreur : attente interrompu.)");
		}
		System.out.println ("fin attente");
		System.out.println ("refresh");
		PPNative.Refresh();
		System.out.println ("action");
		PPNative.Unit_GetHealth(1);
		System.out.println ("fermeture");
		PPNative.Close();*/
		float [] tmp = null;
		if (tmp == null || tmp.length == 1){
			System.out.println("ça plante pas");
			//System.out.println("pourtant "+tmp.length);
		}
		else{
			System.out.println ("ça passe pas... "+tmp);
		}
	}
}
 
