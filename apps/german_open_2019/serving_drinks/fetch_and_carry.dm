% Fetch and Carry Dialogue Model
%
% Robot fetches an object or multiple objects and carries and delivers them to their correspoding locations
%
% Arguments:
%
%        Origin: Position where to return once finished
%
%			DeliverMode: 	handle.- the object is handled to a person
%				            put.- the object is placed on a surface 

%		   Delivers: Objects to fetch, carry and deliver
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
%		Objects_Fetched: List of fetched objects
%
%		Rest_Objects: List of fetched objects
%
%		Remaining_Positions: the positions left to be explored when an object or face was founded
%
%		Status: 
%
%        LeftLocation:  name of the position where to carry and deliver the object in the left hand
%
%        LeftLocation:  name of the position where to carry and deliver the object in the right hand
%
%        CarriedObjects: list of the objects that were successfully carried and delivered
%
%			Status:	
%				   'ok' if the task concludes succesfully
%			      'not_found' if no object is not found (last observation)
%			      'empty_scene' if scene is empty (last observation)
%			      'move_error' a move operation in find task could not be accomplished succesfully
%			       not_delivered- the object could not be delivered
%				    object_not_in_hands .- the requested object to be delivered is not in hands
diag_mod(fetch_and_carry(Origin, DeliverMode, FindMode, Delivers, Places, Orientations, Tilts, Carried_Objects, Rest_Objects, Remaining_Positions, Status), 	    
[
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
			empty : empty => fetch(Delivers, apply(extract_objects(D),[Delivers]),Places)
		]
	],

	[
		id ==> fetch(_,[],_),
		type ==> neutral,
		arcs ==> [
			%empty : say('I have carried the objects') => goto_origin(Origin)
			empty : say('I have carried the objects') => success
		]
	],

	[
		id ==> fetch([],_,_),
		type ==> neutral,
		arcs ==> [	
			%empty : say('I have carried the objects') => goto_origin(Origin)
			empty : say('I have carried the objects') => success
		]
	],

	[
		id ==> fetch(Orders, ObjectList, SearchPath),
		type ==> recursive,
		out_arg ==> [RestSeen, UnexploredPos, FindStatus],
		embedded_dm ==> fetch(ObjectList, SearchPath, Orientations, Tilts, FindMode, FetchedObjects, RestSeen, UnexploredPos, FindStatus),
		arcs ==> [
			success : [
				say('I have fetched the objects now i will carry them to the designated locations'),tilth(0.0),tiltv(-15.0)
			] => carry(Orders, ObjectList,FetchedObjects, apply(find_destination(L,O), [get(left_arm,LeftArm),Orders]), apply(find_destination(R,O), [get(right_arm,RightArm),Orders])),
			error : empty => choose_next_action(Orders, ObjectList, SearchPath, FetchedObjects)
		]
	],

	[
		id ==> choose_next_action(Orders,ObjectList, SearchPath,[]),
		type ==> neutral,
		arcs ==> [
			empty : empty => fetch(Orders, ObjectList,SearchPath)
		]
	],

	[
		id ==> choose_next_action(Orders,ObjectList, SearchPath,FetchedObjects),
		type ==> neutral,
		arcs ==> [
			empty : [get(face_id_cg,X)] => goto_l1(X,Orders, ObjectList, FetchedObjects)
		]
	],
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[% go to living_room
		id ==> goto_l1(X,Orders, ObjectList, FetchedObjects),
		type ==> recursive,
		embedded_dm ==> move(l1, MoveStatus),
		arcs ==> [
			success : empty => identify(X,Orders, ObjectList, FetchedObjects),
			error : empty => goto_l1(Orders, ObjectList, FetchedObjects)
		]
	],
	[% Identify
		 id ==> identify(X,Orders, ObjectList, FetchedObjects),
		 type ==> identify_face_cognitive(identify,X),
		 arcs ==> [		
					identified_face(A,B,C,D,E) : [say(['I identified somebody'])] => create_point(A,B,C,D,E,Orders, ObjectList, FetchedObjects),
					status(Status) : [say('Error empty scene')] => success
			  ]
	],
	[% Create customer location point
		 id ==> create_point(_,_,DX,DY,DZ,Orders, ObjectList, FetchedObjects),
		 type ==> neutral,
		 arcs ==> [		
					empty : [
							apply( convert_cartesian_to_cylindrical_yolo(X_,Z_,Y_,R_,O_),[DX,DZ,DY,R,O]),
							assign(Odom, apply(get_person_odometry_yolo(P_,L_),[[R,O,1],80])),
							apply(add_location_kb(L,P),[customer1,Odometry])
				 		] => carry(Orders, ObjectList, FetchedObjects, customer1, customer1)
			  ]
	],
	

%%%%%%%%%%%%%%%%%%%%%%
	[% Carry objects to customer
	id ==> carry(Orders, ObjectList, FetchedObjects, LeftDest, RightDest),
	type ==> recursive,
	in_arg ==> [RestSeen, UnexploredPos, _],
	out_arg ==> [RestSeen, UnexploredPos, CarryStatus],
	embedded_dm ==> carry(LeftDest, RightDest, Carried, DeliverMode, CarryStatus),
	arcs ==> [
		success : [
			get(carried ,PrevCarried),
			append(Carried,PrevCarried,CurrCarried),
			set(carried ,CurrCarried),
			assign(OrdersLeft, apply(extract_orders(C,D), [CurrCarried, Delivers])),
			assign(ObjectsLeft, apply(extract_objects(O),[OrdersLeft]))
		] => fetch(OrdersLeft, ObjectsLeft, Places),
		error : empty => error
		]
	],

	[
		id ==> goto_origin(Position),
		type ==> recursive,      
		in_arg ==> [RestSeen, UnexploredPos, _],
		out_arg ==> [RestSeen, UnexploredPos, MoveStatus],
		embedded_dm ==> move(Position, MoveStatus),
		arcs ==> [
			success : empty => success,
			error : empty => goto_origin_recovery(Position)
		]     
	],	

	[
		id ==> goto_origin_recovery(Position),
		type ==> recursive,
		in_arg ==> [RestSeen, UnexploredPos, _],
		out_arg ==> [RestSeen, UnexploredPos, MoveStatus],
		embedded_dm ==> move(Position, MoveStatus),
		arcs ==> [
			success : empty => success,
			error : empty => success
		]
	],

	[
		id ==> success,
		type ==> final,
		in_arg ==> [RestSeen, UnexporedPos, FinalStatus],
		diag_mod ==> fetch_and_carry(_,_,_,_,_,_,_,get(carried,Carried),RestSeen, UnexporedPos, FinalStatus)
	],

	[
		id ==> error,
		type ==> final,
		in_arg ==> [_, _, UnexporedPos, FinalStatus],
		diag_mod ==> fetch_and_carry(_,_,_,_,_,_,_,get(carried,Carried),RestSeen, UnexporedPos, FinalStatus)
	]
], % En situation list

% List of Local Variables
[
	take_tries ==> 0,
	carried ==> []
]

). % End Get Task DM
