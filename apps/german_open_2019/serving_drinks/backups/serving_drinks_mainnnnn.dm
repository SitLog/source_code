% Main dialogue model for the Serving Drinks test of the RoboCup@Home 
% Competition, Rulebook 2019
%
% Copyright (C) 2019 UNAM (Universidad Nacional Autónoma de México)
% Dennis Mendoza (dms.albertmend@gmail.com)
% 
diag_mod(serving_drinks_main,
[
	[% start   
		id ==> is,	
		type ==> neutral,
		arcs ==> [
			empty : [		% initializing everything
				apply(initialize_KB,[]),
				tilth(0.0),
				set(last_scan,0.0),
				tiltv(-15.0),
				set(last_tilt,-15.0),
			] => gotobar
		]
	],

	[% going to the bar (known location)   
		id ==> goto_bar,	
		type ==> recursive,
		embedded_dm ==> move('bar', MoveStatus),
		arcs ==> [
			success : empty ==> see_objects
			error : empty => goto_bar
		]
	],
	[% see objects in the bar && save to KB
		id ==> see_objects,
		type ==> neutral,
		embedded_dm ==> see_object('drinks',category,Found_Objects,Status),
		arcs ==> [
			success : say('I see some drinks') => goto_living_room,
			error : empty => fs
		]
	],

	[% going to the living room (known location)   
		id ==> goto_living_room,	
		type ==> recursive,
		embedded_dm ==> move('living_room', MoveStatus),
		arcs ==> [
			success : empty ==> search_people
			error : empty => goto_living_room
		]
	],

	[% search people
		id ==> search_people,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => tiene_bebida
		]
	],
	
	[% vetificar si tiene bebida
		id ==> tiene_bebida,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	[% acercarse a la primer persona sin bebida
		id ==> goto_person,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	
	[% preguntar y guardar nombre y cara
		id ==> tiene_bebida,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	[% tomar orden
		id ==> take_order,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	[% ir al bar y tomar la bebida
		id ==> take_drink,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	[% going to the living room   
		id ==> goto_living_room,	
		type ==> recursive,
		embedded_dm ==> move('living_room', MoveStatus),
		arcs ==> [
			success : empty ==> search_people
			error : empty => goto_living_room
		]
	],
	[% Search for X with face verification
		id ==> take_drink,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	[% Move to X
		id ==> take_drink,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	[% Deliver drink to X
		id ==> take_drink,	
		type ==> neutral,
		arcs ==> [
			empty : [
			] => guide
		]
	],
	%Repeat for all customers without drink
	
	[% go to wait position
		id ==> goto_wait_position(Position),
		type ==> recursive,
		embedded_dm ==> move(Position, MoveStatus),
		arcs ==> [
			success : empty => guide,
			error : empty => goto_wait_position(Position)
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
  	origin ==> [0.0,0.0,0.0],
  	wait_position ==> [0.0,0.0,0.0]
  	
 ]
).
