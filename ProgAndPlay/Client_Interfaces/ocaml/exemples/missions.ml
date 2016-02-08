#load "pp.cma";;
#use "constantListKP41.ml";;

(*
 * MISSION 1
 *)
(* Déplace la première unité à la bonne coordonnée *)
let mission1 = function () -> Pp.actionOnPosition ((List.hd (Pp.getEntities Pp.MyCoalition)), aMove, (1983.0, 1279.0));;

(*
 * MISSION 2
 *)
(* Déplace la première unité à la bonne coordonnée *)
let mission2 = function () -> 
	let u = List.hd (Pp.getEntities Pp.MyCoalition) in
	let (x, y) = Pp.getPosition(u) in
	Pp.actionOnPosition (u, aMove, (x-.927., y+.513.))
;;

(*
 * MISSION 3
 *)
(* Attendre l'arrivée de l'ennemi *)
let rec attendreEnnemi = function
	[] -> attendreEnnemi (Pp.getEntities Pp.EnemyCoalition)
	| t::q -> t;;
(* Attaque l'ennemi dès qu'il est visible *)
let mission3 = function () -> 
	let u = List.hd (Pp.getEntities Pp.MyCoalition) in
	Pp.actionOnEntity (u, aAttack, attendreEnnemi(Pp.getEntities Pp.EnemyCoalition))
;;

(*
 * MISSION 4
 *)
(* Déplacer l'unité numéro num à la bonne coordonnée en fonction de son type *)
let mission4 = fun num ->
	let e = List.nth (Pp.getEntities Pp.MyCoalition) num in
	if Pp.getType e = idBit then
		Pp.actionOnPosition (e, aMove, (1400.0, 1371.0))
	else
		if Pp.getType e = idByte then
			Pp.actionOnPosition (e, aMove, (479.0, 1825.0))
		else
			failwith "type d'unite non pris en compte pour la mission 4";;

(*
 * MISSION 5
 *)
(* Déplace toutes les unités à la même position *)
let rec deplaceGroupe = function
	[] -> true
	| t::q -> Pp.actionOnPosition (t, aMove, (256.0, 1024.0)) & deplaceGroupe q;;
let mission5 = function () -> deplaceGroupe (Pp.getEntities Pp.MyCoalition);;

(*
 * MISSION 6
 *)
(* Déplace l'assembleur et uniquement lui à une position précise *)
let rec deplaceAsm = function
	[] -> true
	| t::q -> if Pp.getType t = idAssembler then
							Pp.actionOnPosition (t, aMove, (256.0, 811.0))
						else
							deplaceAsm q;;
let mission6 = function () -> deplaceAsm (Pp.getEntities Pp.MyCoalition);;

(*
 * MISSION 7
 *)
(* recherche un assembleur dans une liste d'unité (un assembleur doit
 * nécessairement être présent) *)
let rec rechercheAssembleur = function
	[] -> failwith "impossible de trouver un assembleur"
	| t::q ->
		if Pp.getType t = idAssembler then
			t
		else
			rechercheAssembleur q;;

(* Vérifie si l'unité e est toujours présente dans la liste courante *)
let rec toujoursPresent = function
	(e, []) -> false;
	| (e, t::q) -> e = t or toujoursPresent (e, q);;

(* Attendre que l'unité e soit totallement réparée *)
let rec attendreReparation = fun e ->
	if Pp.getHealth e < Pp.getMaxHealth e then
		if toujoursPresent (e, (Pp.getEntities Pp.MyCoalition)) then
			attendreReparation e
		else
			false
	else
		true;;

(* Réparer toutes les entités de la liste courante à l'aide de l'assembleur a *)
let rec reparerArmee = function
	([], a) -> true;
	| (t::q, a) ->
		if Pp.actionOnEntity (a, aRepair, t) then
			attendreReparation t & reparerArmee (q, a)
		else
			false;;

(* Réparer toutes les unités du jeu *)
let mission7 = fun () ->
	let liste = Pp.getEntities Pp.MyCoalition in
	reparerArmee (liste, (rechercheAssembleur liste));;

(*
 * MISSION 8
 *)
(* positionne tous les bytes à leur coordonnée et toutes les autres unités aux
 * coordonnées des bits *)
let trierUnites = fun posBytes posBits ->
	let rec parcoursUnite = function
		[] -> true;
		|t::q -> Pp.actionOnPosition (t, aMove, (if Pp.getType t = idByte then posBytes else posBits)) & parcoursUnite q in
	parcoursUnite (Pp.getEntities Pp.MyCoalition);;

(* Vérifier si au moins une unité est en déplacement *)
let rec auMoinsUneEnDeplacement = function
	[] -> false;
	| t::q -> (List.length (Pp.getPendingCommands t)) > 0 or auMoinsUneEnDeplacement q;;

(* Attend que toutes les unités soient arrivées *)
let rec attendreRassemblement = fun liste ->
	if auMoinsUneEnDeplacement liste then
		attendreRassemblement (Pp.getEntities Pp.MyCoalition)
	else
		true;;

(* Attend que toutes les unités soient arrivées *)
let rec attendreDepart = fun liste ->
	if auMoinsUneEnDeplacement liste then
		true
	else
		attendreDepart (Pp.getEntities Pp.MyCoalition);;
		
(* Recherche dans la liste liste tous les assembleurs et tous les bytes *)
let chercheAssembleurBytes = fun liste ->
	let rec recherche = function
		([], (assembleur, bytes)) -> (assembleur, bytes)
		|(t::q, (assembleur, bytes)) -> recherche (q, if Pp.getType t = idAssembler then (t::assembleur, bytes) else if Pp.getType t = idByte then (assembleur, t::bytes) else (assembleur, bytes)) in
	recherche (liste, ([], []));;

(* Ordonne à toutes les unités de commencer à progresser vers le but *)
let lancerMarche = fun liste byte posAttaque ->
	let rec parcoursListe = function
		[] -> true
		| t::q -> parcoursListe q & if Pp.getType t = idByte then Pp.actionOnPosition (t, aFight, posAttaque) else Pp.actionOnEntity (t, aGuard, byte) in
	parcoursListe liste;;

(* Attendre jusqu'à ce que l'ennemi soit détecté *)
let rec attendreDetectionEnnemi = function
	[] -> attendreDetectionEnnemi (Pp.getEntities Pp.EnemyCoalition)
	| _ -> true;;

(* Lancement de l'attaque à proprement dit *)
let toutLacher = fun posAttaque liste ->
	let rec parcoursListe = function
		[] -> true;
		| t::q ->
			if Pp.getType t = idAssembler then
				parcoursListe q
			else
				(Pp.actionOnPosition (t, aFight, posAttaque) & parcoursListe q) in
	parcoursListe liste;;

(* supprime toutes les entités de la première liste non présentent dans la seconde *)
let rec supprimeEntitesInvalides = function
	([], _) -> []
	| (eT::eQ, listeComplete) ->
		if toujoursPresent (eT, listeComplete) then
			eT::supprimeEntitesInvalides (eQ, listeComplete)
		else
			supprimeEntitesInvalides (eQ, listeComplete);;

(* recherche le byte le plus endomagé dans une liste de Byte valide *)
let rec chercheBytePrioritaire = function
	[] -> failwith "liste vide"
	| b::[] -> b
	| b::queue ->
		let byteFaible = chercheBytePrioritaire queue in
		let bHealth = try (Pp.getHealth b) with _ -> -1.0 in
		let byteFaibleHealth = try (Pp.getHealth byteFaible) with _ -> -1.0 in
		if byteFaibleHealth = -1.0 then
			b
		else
			if bHealth = -1.0 then
				byteFaible
			else
				if bHealth < byteFaibleHealth then
					b
				else
					byteFaible;;

(* ordonne au premier assembleur de réparer le byte le plus nécessiteux *)
let rec reparerBytes = fun listeAsm listeByte derniereUrgence ->
	let listeEntities = Pp.getEntities Pp.MyCoalition in
	let nvLlisteAsm = supprimeEntitesInvalides (listeAsm, listeEntities) in
	let nvListeByte = supprimeEntitesInvalides (listeByte, listeEntities) in
	if Pp.isGameOver() then
		true
	else
		match nvLlisteAsm with
			[] -> true;
			| asmT::asmQ ->
				let urgence = chercheBytePrioritaire nvListeByte in
				if urgence <> derniereUrgence or (List.length (Pp.getPendingCommands asmT)) = 0 then
					(try(Pp.actionOnEntity (asmT, aRepair, urgence)) with _ -> true) & reparerBytes nvLlisteAsm nvListeByte urgence
				else
					reparerBytes nvLlisteAsm nvListeByte urgence;;

(* lancement de l'attaque *)
let lancerAttaque = fun posAttaque ->
	let listeEntities = Pp.getEntities Pp.MyCoalition in
	let (lAsm, lBytes) = chercheAssembleurBytes listeEntities in
	lancerMarche listeEntities (List.hd lBytes) posAttaque & attendreDetectionEnnemi (Pp.getEntities Pp.EnemyCoalition) & toutLacher posAttaque listeEntities & reparerBytes lAsm lBytes (List.hd lBytes);;

(* startégie pour la mission 8 *)
let mission8 = fun () ->
	trierUnites (478.0, 255.0) (255.0, 255.0) & attendreDepart (Pp.getEntities Pp.MyCoalition) & attendreRassemblement (Pp.getEntities Pp.MyCoalition) & lancerAttaque (1792.0, 256.0);;