% Seize and Carry Dialogue Model
%
% Robot seizes an object or multiple objects and carries and delivers them to their correspoding locations
%
% Arguments:
%
%        Origin: Position where to return once finished
%
%			DeliverMode: 	handle.- the object is handled to a person
%				            put.- the object is placed on a surface 

%		   Delivers: Objects to seize, place and deliver
%
%		   Places: Location of search (e.g., kitchen, livingroom, etc.) or a list of positions.  When Places is not defined the search location is retreived from the robot's knowledge base.
%
%		   Orientations: List of scanning orientations at every search position  (e.g., left, right, etc.)
%
%		   Tilts: the list of tilt directtion attended at every scanning position (e.g. up, down, etc.)
%
%		   FindMode:	object .- search objects listed in the argument 'Entity' 
%			   	      category .- search objects belonging to the category indicated in the argument 'Entity'
%
%		Objects_Seized: List of seized objects
%
%		Rest_Objects: List of seized objects
%
%		Remaining_Positions: the positions left to be explored when an object or face was founded
%
%		Status: 
%
%        LeftLocation:  name of the position where to place and deliver the object in the left hand
%
%        LeftLocation:  name of the position where to place and deliver the object in the right hand
%
%        PlacedObjects: list of the objects that were successfully placed and delivered
%
%			Status:	
%				   'ok' if the task concludes succesfully
%			      'not_found' if no object is not found (last observation)
%			      'empty_scene' if scene is empty (last observation)
%			      'move_error' a move operation in find task could not be accomplished succesfully
%			       not_delivered- the object could not be delivered
%				    object_not_in_hands .- the requested object to be delivered is not in hands
diag_mod(seize_and_place(Origin, DeliverMode, FindMode, Places, Orientations, Tilts, Placed_Objects, Rest_Objects, Remaining_Positions, Status), 	    
[
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
			empty : empty => seize
		]
	],

	[
		id ==> seize,
		type ==> recursive,
		out_arg ==> [RestSeen, UnexploredPos, FindStatus],
		embedded_dm ==> seize(ObjectList, Places, Orientations, Tilts, FindMode, SeizedObjects, RestSeen, UnexploredPos, FindStatus),
		arcs ==> [
			success : [
				say('I have seized the objects now i will place them to the designated locations'),tilth(0.0),tiltv(-15.0)
			] => place,
			error : empty => choose_next_action(SeizedObjects)
		]
	],

	[
		id ==> choose_next_action([]),
		type ==> neutral,
		arcs ==> [
			empty : empty => seize
		]
	],

	[
		id ==> choose_next_action(SeizedObjects),
		type ==> neutral,
		arcs ==> [
			empty : empty => place
		]
	],

	[
	id ==> place,
	type ==> recursive,
	in_arg ==> [RestSeen, UnexploredPos, _],
	out_arg ==> [RestSeen, UnexploredPos, PlaceStatus],
	embedded_dm ==> place(dishwasher, dishwasher, Placed, DeliverMode, PlaceStatus),
	arcs ==> [
		success : empty => seize,
		error : empty => error
		]
	],

	[
		id ==> success,
		type ==> final,
		in_arg ==> [RestSeen, UnexporedPos, FinalStatus],
		diag_mod ==> seize_and_place(_,_,_,_,_,_,get(placed,Placed),RestSeen, UnexporedPos, FinalStatus)
	],

	[
		id ==> error,
		type ==> final,
		in_arg ==> [_, _, UnexporedPos, FinalStatus],
		diag_mod ==> seize_and_place(_,_,_,_,_,_,get(placed,Placed),RestSeen, UnexporedPos, FinalStatus)
	]
], % En situation list

% List of Local Variables
[
	take_tries ==> 0,
	placed ==> []
]

). % End Get Task DM
