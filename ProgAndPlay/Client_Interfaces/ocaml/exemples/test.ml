#load "pp.cma";;
#use "constantListKP41.ml";;

let rec displayList = function
	[] -> ""
	| (a,params)::q -> (string_of_int a)^" "^displayList q;;

let test = function () -> displayList (Pp.getPendingCommands (List.hd (Pp.getEntities Pp.MyCoalition)));;

let test2 = function () -> Pp.untargetedAction (List.hd (Pp.getEntities Pp.MyCoalition), aStopBuilding, -1.0);;
