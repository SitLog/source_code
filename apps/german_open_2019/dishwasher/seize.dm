% Seize Task Dialogue Model
%
% Robot seizes an object or multiple objects in a given location
%
% The Arguments of Seize are:
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
%		Objects_Seized: List of seized objects
%
%		RestObjects: List of seized objects
%
%		RestPositions: the positions left to be explored when an object or face was founded
%
%		Status: 'ok' if the task concludes succesfully
%			'not_found' if no object is not found (last observation)
%			'empty_scene' if scene is empty (last observation)
%			'move_error' a move operation in find task could not be accomplished succesfully
%
diag_mod(seize(Entity, Places, Orientations, Tilts, FindMode, SeizedObjects, RestObjects, RestPositions, Status), 	    
[
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
			empty : empty => seize(Places,get(left_arm, LeftArm),get(right_arm, RightArm))
		]
	],

	[% search path has been exhausted
		id ==> seize([],_,_),
		type ==> neutral,
		arcs ==> [
			empty : empty => error
		]
	],

	[% at least the right hand is free
		id ==> seize(SearchPath,free,_),
		type ==> neutral,
		arcs ==> [
		empty : empty => find(SearchPath,left)
		]
	],

	[% left hand is free
		id ==> seize(SearchPath,_,free),
		type ==> neutral,
		arcs ==> [
		empty : empty => find(SearchPath,right)
		]
	],

	[% both hands are busy, assuming it has already seized the objects
		id ==> seize(_,_,_),
		type ==> neutral,
		arcs ==> [
			empty : empty => success
		]
	],

	[% find objects
		id ==> find(SearchPath,Arm),
		type ==> recursive,
		out_arg ==> [ObjectList, FoundObjects, UnexploredPos, FindStatus],
		embedded_dm ==> find(object, ObjectList, SearchPath, Orientations, Tilts, FindMode, FoundObjects, UnexploredPos, false, false, false, FindStatus),
		arcs ==> [
			success : empty => take(FoundObjects,Arm),
			error : empty => find_recovery(UnexploredPos, Arm, FindStatus)
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
				get(seized,PrevSeized),
				append([ObjTaken],PrevSeized,CurrSeized),
				set(seized,CurrSeized)
			] => seize(Places,get(left_arm, LeftArm),get(right_arm, RightArm)),
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
				get(seized,PrevSeized),
				append([ObjTaken],PrevSeized,CurrSeized),
				set(seized,CurrSeized)
			] => seize(Places,get(left_arm, LeftArm),get(right_arm, RightArm)),
			error : empty => error
		]
	],

	[
		id ==> success,
		type ==> final,
		in_arg ==> [_, RestObjs, Positions, Final_Status],
		diag_mod ==> seize(_, _, _, _, _, get(seized,Seized), RestObjs, Positions, Final_Status)
	],

	[
		id ==> error,
		type ==> final,
		in_arg ==> [_, RestObjs, Positions, Final_Status],
		diag_mod ==> seize(_, _, _, _, _, get(seized,Seized), RestObjs, Positions, Final_Status)
	]

], % En situation list

% List of Local Variables
[
	take_tries ==> 0,
	seized ==>[]
]

). % End Get Task DM
