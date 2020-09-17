% Main dialogue model for the  Procter & Gamble: Clean the Table [Housekeeper] test of the RoboCup@Home 
% Competition, Rulebook 2019
%
diag_mod(dishwasher_main,
[
	[% start   
		id ==> is,	
		type ==> neutral,
		arcs ==> [
			empty : [
				apply(initialize_KB,[]),
				tilth(0.0),
				set(last_scan,0.0),
				tiltv(-15.0),
				set(last_tilt,-15.0),
				assign(Odometry, apply(get_odometry,[])),
				set(origin,Odometry),
				say('Hello everybody my name is Golem and i will clean the table')
			] => clean_table
		]
	],

	[% cleaning table: taking tableware and carrying them to dishwasher 
		id ==> clean_table,
		type ==> recursive,
		embedded_dm ==> seize_and_place(origin, put, object, [kitchen_table], [20.0, 0.0, -20.0], [-30.0], Carried_Objects, Rest_Objects, Remaining_Positions, SP_Status),
		arcs ==> [
			success : [
				say('I finished cleaning the table.'),
				get(origin, Origin)
			] => goto_origin(Origin),
			error : [
				say('Sorry. I could not clean the table completely. Trying again.')
			] => clean_table
		]
	],

	[% go to origin
		id ==> goto_origin(Position),
		type ==> recursive,
		embedded_dm ==> move(Position, MoveStatus),
		arcs ==> [
			success : empty => fs,
			error : empty => goto_origin(Position)
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
