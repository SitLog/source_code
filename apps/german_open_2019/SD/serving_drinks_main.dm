% Main dialogue model for the Serving Drinks test of the RoboCup@Home 
% Competition, Rulebook 2019
%
% Copyright (C) 2019 UNAM (Universidad Nacional Autónoma de México)
% Dennis Mendoza (dms.albertmend@gmail.com)
% 

diag_mod(serving_drinks_main(ListaDeLugares),
[
	[% start   
		id ==> is,	
		type ==> neutral,
		arcs ==> [
			 empty : [
				 apply(initialize_KB,[]),		
				 tiltv(-20.0),
				 set(last_tilt,-20.0),
				 set(available_drinks,[]),
				 set(face_id_cg, 0),
				 set(list_of_places,ListaDeLugares),
				 say('Hello I am golem, and I will be serving drinks today'),
				 say('I will first go to the bar')
				 ] 
			        => goto_bar_and_detect_objects
		         ]
	],
	[% Go to bar and detect objects  
		id ==> goto_bar_and_detect_objects,	
		type ==> recursive,
		embedded_dm ==> goto_bar_and_detect_objects(FinalStatus),
		arcs ==> [
			 success : [say('I have detected the available drinks. Now I will go to the living room.')] => goto_living_room_and_detect_people_without_drinks,
			 error : empty => goto_bar_and_detect_objects
		         ]
	],
	[% Go to living room and detect people without drinks  
		id ==> goto_living_room_and_detect_people_without_drinks,	
		type ==> recursive,
		embedded_dm ==> goto_living_room_and_detect_people_without_drinks(ListaDeLugares,FinalStatus),
		arcs ==> [
			 success : [say('I will attend a guest.')] => attend_guest,
			 error : empty => goto_living_room_and_detect_people_without_drinks
		         ]
	],
	[% Attend guest  
		id ==> attend_guest,	
		type ==> recursive,
		embedded_dm ==> attend_guest(FinalStatus),
		arcs ==> [
			 success : [say('I finished attending a guest.')] => goto_living_room_and_detect_people_without_drinks,
			 error : empty => fs
		         ]
	],
	
      % final situation
	[
		id ==> fs,
		type ==> final
	]
 ],
 %List of local variables
 [
 
 ]
).
