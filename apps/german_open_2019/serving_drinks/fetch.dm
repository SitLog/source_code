% Fetch Task Dialogue Model
%
% Robot fetches an object or multiple objects in a given location
%
% The Arguments of Fetch are:
%
%		Entity: Id of object or face to be found or variable (in case the goal is to find any object of the kind)
%
%		Places: Location of search (e.g., kitchen, livingroom, etc.) or a list of positions.  When Places is not defined the search location is retreived from the robot's knowledge base.
%
%		Orientations: List of scanning orientations at every search position  (e.g., left, right, etc.)
%
%		Tilts: the list of tilt directtion attended at every scanning position (e.g. up, down, etc.)
%
%		FindMode:	object .- search objects listed in the argument 'Entity' 
%				      category .- search objects belonging to the category indicated in the argument 'Entity'
%
%		Objects_Fetched: List of fetched objects
%
%		RestObjects: List of fetched objects
%
%		RestPositions: the positions left to be explored when an object or face was founded
%
%		Status: 'ok' if the task concludes succesfully
%			'not_found' if no object is not found (last observation)
%			'empty_scene' if scene is empty (last observation)
%			'move_error' a move operation in find task could not be accomplished succesfully
%
diag_mod(fetch(Entity, Places, Orientations, Tilts, FindMode, FetchedObjects, RestObjects, RestPositions, Status), 	    
[
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
			empty : empty => fetch(Entity,Places,get(left_arm, LeftArm),get(right_arm, RightArm))
		]
	],
	

	[% all objects have been fetched
		id ==> fetch([],_,_,_),
		type ==> neutral,
		arcs ==> [
			empty : empty => success
		]
	],

	[% search path has been exhausted
		id ==> fetch(_,[],_,_),
		type ==> neutral,
		arcs ==> [
			empty : empty => error
		]
	],

	[% at least the right hand is free
		id ==> fetch(ObjectList,SearchPath,free,_),
		type ==> neutral,
		arcs ==> [
		empty : empty => find(ObjectList,SearchPath,right)
		]
	],

	[% left hand is free
		id ==> fetch(ObjectList,_,_,free),
		type ==> neutral,
		arcs ==> [
		empty : empty => find(ObjectList, SearchPath,left)
		]
	],

	[% both hands are busy, assuming it has already fetched the objects
		id ==> fetch(_,_,_,_),
		type ==> neutral,
		arcs ==> [
			empty : empty => success
		]
	],

	[% find objects
		id ==> find(ObjectList,SearchPath,Arm),
		type ==> recursive,
		out_arg ==> [ObjectList, _, [], MvStatus],
		embedded_dm ==> move(SearchPath, MvStatus),
		arcs ==> [
			success : [say('Bartender, the order is '),say(ObjectList),sleep,sleep] => actual_scan(ObjectList,Arm),
			error : empty => find(ObjectList,SearchPath,Arm)
		]     
	],
	
	[% find objects
		id ==> actual_scan(ObjectList,Arm),
		type ==> recursive,
		out_arg ==> [ObjectList, FoundObjects, [], ScanStatus],
		embedded_dm ==> scan(object, ObjectList, Orientations, Tilts, ScanMode, FoundObjects, false, false, ScanStatus),
		arcs ==> [
			success : empty => take(FoundObjects,Arm),
			error : empty => find_recovery(ObjectList, [], Arm, ScanStatus)
		]     
	],

	[% find objects
		id ==> find_recovery(ObjectList,SearchPath,Arm,FindError),
		type ==> recursive,
		out_arg ==> [ObjectList, FoundObjects, UnexploredPos, FindStatus],
		embedded_dm ==> find(object, ObjectList, SearchPath, Orientations, Tilts, FindMode, FoundObjects, UnexploredPos, true, true, true, FindStatus),
		arcs ==> [
			success : empty => take(FoundObjects,Arm),
			error : empty => error
		]     
	],	

	[
		id ==> take([FirstObject|RestObjects],Arm),
		type ==> recursive,
		in_arg ==> [ObjectList, _, UnexploredPos, _],
		out_arg ==> [_, RestObjects, UnexploredPos, TakeStatus],
		embedded_dm ==> take(FirstObject, Arm, ObjTaken, TakeStatus),
		prog ==> [inc(take_tries,TakeTries)],
		arcs ==> [
			success : [
				get(fetched,PrevFetched),
				append([ObjTaken],PrevFetched,CurrFetched),
				set(fetched,CurrFetched)
			] => success,
			error : empty => take_recovery([FirstObject|RestObjects],Arm)
		]
	],

	[
		id ==> take_recovery([FirstObject|RestObjects],Arm),
		type ==> recursive,
		in_arg ==> [ObjectList, _, UnexploredPos, _],
		out_arg ==> [_, RestObjects, UnexploredPos, TakeStatus],
		embedded_dm ==> take(FirstObject, Arm, ObjTaken, TakeStatus),
		prog ==> [inc(take_tries,TakeTries)],
		arcs ==> [
			success : [
				get(fetched,PrevFetched),
				append([ObjTaken],PrevFetched,CurrFetched),
				set(fetched,CurrFetched)
			] => success,
			error : empty => error
		]
	],

	[
		id ==> success,
		type ==> final,
		in_arg ==> [_, RestObjs, Positions, Final_Status],
		diag_mod ==> fetch(_, _, _, _, _, get(fetched,Fetched), RestObjs, Positions, Final_Status)
	],

	[
		id ==> error,
		type ==> final,
		in_arg ==> [_, RestObjs, Positions, Final_Status],
		diag_mod ==> fetch(_, _, _, _, _, get(fetched,Fetched), RestObjs, Positions, Final_Status)
	]

], % En situation list

% List of Local Variables
[
	take_tries ==> 0,
	fetched ==>[]
]

). % End Get Task DM
