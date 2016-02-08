-- entr�eSortie.spec
-- Interface avec les m�thodes natives de la biblioth�que standard de Compalgo v2.
--
-- Ajoute la lecture et l'�criture de donn�es � la biblioth�que standard de Compalgo.
--

-- �crit un bool�en sur la sortie standard.
proc�dure �crire( entr�e e <Bool�en> );
-- �crit un cha�ne sur la sortie standard.
proc�dure �crire( entr�e e <Cha�ne> );
-- �crit un entier sur la sortie standard.
proc�dure �crire( entr�e e <Entier> );
-- �crit un r�el sur la sortie standard.
proc�dure �crire( entr�e e <R�el> );
-- �crit un caract�re sur la sortie standard.
proc�dure �crire( entr�e e <Caract�re> );

-- retourne � la ligne.
proc�dure �crirenl;
-- �crit un bool�en sur la sortie standard et retourne � la ligne.
proc�dure �crirenl( entr�e e <Bool�en> );
-- �crit une cha�ne sur la sortie standard et retourne � la ligne.
proc�dure �crirenl( entr�e e <Cha�ne> );
-- �crit un entier sur la sortie standard et retourne � la ligne.
proc�dure �crirenl( entr�e e <Entier> );
-- �crit un r�el sur la sortie standard et retourne � la ligne.
proc�dure �crirenl( entr�e e <R�el> );
-- �crit un caract�re sur la sortie standard et retourne � la ligne.
proc�dure �crirenl( entr�e e <Caract�re> );

-- lit un bool�en depuis l'entr�e standard.
proc�dure lire( sortie s <Bool�en> );
-- lit un entier depuis l'entr�e standard.
proc�dure lire( sortie s <Entier> );
-- lit un r�el depuis l'entr�e standard.
proc�dure lire( sortie s <R�el> );
-- lit une cha�ne depuis l'entr�e standard.
proc�dure lire( sortie s <Cha�ne> );
-- lit un caract�re depuis l'entr�e standard.
proc�dure lire( sortie s <Caract�re> );


-- Effecue une pause dans la console. Attend un retour chariot pour continuer.
proc�dure pause;
