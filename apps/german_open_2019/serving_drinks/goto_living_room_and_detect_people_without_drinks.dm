diag_mod(goto_living_room_and_detect_people_without_drinks(FinalStatus),
[% list of situations
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
			 empty : empty   => get_places
			 ]
	],
	[% Get places  
		id ==> get_places,	
		type ==> neutral,
		arcs ==> [
			 empty : get(list_of_places_sd,ListaDeLugares) => goto_places(ListaDeLugares)
		         ]
	],
	[
		id ==> goto_places([Place|Rest]),
		type ==> recursive,
		embedded_dm ==> move(Place, _),
		arcs ==> [
			 success : [tiltv(-10.0), set(last_tilt,-10.0)]   => search_people_without_drinks(Rest),
			 error : empty => goto_places([Place|Rest]) %No ha llegado al punto
		         ]
	],
		
	[% search people y ver si tienen bebida y estan en la arena
		id ==> search_people_without_drinks([]),	
		type ==> yolo_object_detection(last_tilt,people_and_drinks),
		arcs ==> [
			 objects(ObjectList) : 	say('I see a person without a drink') => recorrer_arreglo(ObjectList),
			 status(_)      :	say('There are no more places to explore. Finished task.') => finish
		         ]
	],
	[% search people y ver si tienen bebida y estan en la arena
		id ==> search_people_without_drinks(Rest),	
		type ==> yolo_object_detection(last_tilt,people_and_drinks),
		arcs ==> [
			 objects(ObjectList) : 	say('I see a person without a drink') => recorrer_arreglo(ObjectList),
			 status(_)      :	say('I do not see people without drinks Trying again from another point') => goto_places(Rest)
		         ]
	],
	
	[% recorrer arreglo de personas
		id ==> recorrer_arreglo([]),	
		type ==> neutral,
		arcs ==> [
			 empty : empty => error
			 ]
	],
	
	[% recorrer arreglo de personas
		id ==> recorrer_arreglo([object(_,X,Y,Z,_,_,_,_,_)|More]),	
		type ==> neutral,
		arcs ==> [
			 empty : [
			     
			     apply( convert_cartesian_to_cylindrical_yolo(X_,Z_,Y_,R_,O_),[X,Z,Y,R,O]),
			     assign(Odom, apply(get_person_odometry_yolo(P_,L_),[[R,O,1],80])),
			     apply(add_location_kb(L,P),[customer,Odom])
			      ]	 => success
		         ]
	],
	
	% final situations
	[
		id ==> success,
		type ==> final,
		diag_mod ==> goto_living_room_and_detect_people_without_drinks(ok)
	],

	[
		id ==> error,
		type ==> final,
		diag_mod ==>  goto_living_room_and_detect_people_without_drinks(error)
	],
	[
		id ==> finish,
		type ==> final,
		diag_mod ==>  goto_living_room_and_detect_people_without_drinks(finish)
	]
],

% local variables
[
	
]
).
