% Main dialogue model for the Restaurant test of the RoboCup@Home 
% Competition, Rulebook 2019
%
% Copyright (C) 2019 UNAM (Universidad Nacional Autónoma de México)
% Dennis Mendoza (http://calebrascon.info)
% Based on the 2017 work of:
%	Caleb Rascón
%       Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)
%
diag_mod(deliver_gpsr_2019(Object_category,Person_category,Location),
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
			] => goto_location
		]
	],
	[% going to Location   
		id ==> goto_location,	
		type ==> recursive,
		embedded_dm ==> move(Location, _),
		arcs ==> [
			 success : empty => search_people_without_drinks,
			 error   : empty => goto_bar
		         ]
	],
	[% search people y ver si tienen bebida y estan en la arena
		id ==> search_people_without_drinks,	
		type ==> yolo_object_detection(last_tilt,people_and_drinks),
		arcs ==> [
			 objects(ObjectList) : 	say('I see some people without drinks') => recorrer_arreglo(ObjectList),
			 status(_)      :	say('I do not see people without drinks. Finished task') => fs
		         ]
	],
	[% recorrer arreglo de personas
		id ==> recorrer_arreglo([object(Name,X,Y,Z,_,_,_,_,_)|More]),	
		type ==> neutral,
		arcs ==> [
			 empty : [
			     apply( convert_cartesian_to_cylindrical_yolo(X_,Z_,Y_,R_,O_),[X,Z,Y,R,O])
			     assign(V1,R),
			     assign(V2,O)
				 ]
				 => odometria(V1,V2)
		         ]
	],
	[
		id ==> odometria(R,O),	
		type ==> neutral,
		arcs ==> [
			empty : [
				
				assign(Odom, apply(get_person_odometry_yolo(P_,L_),[[R,O,1],80]))
				] 
				=> add_client_kb(Odom)
		]
	],
	
	[
		id ==> add_client_kb(Odom),	
		type ==> neutral,
		arcs ==> [
			 empty : [
				 apply(add_location_kb(L,P),[customer,Odom])
				 ]
				=> ask_for_table
		         ]
	],
	[% going to customer
		id ==> ask_for_table,
		type ==> recursive,
		embedded_dm ==> ask_for_table(Status),
		arcs ==> [
			success : empty => askname,
			error : [
				say('Attempting to continue the task from here')
			] => detect_face
		]
	],
	
	[% taking the orders
		id ==> order,
		type ==> recursive,
		embedded_dm ==> take_orders(1,OrdersTaken,OrderList,OrderStatus),
		arcs ==> [
			success : [say('Ok I will go for your orders now')] => dispense(bar,OrderList),
			error : [get(origin, Origin)] => order_recovery(Origin,OrdersTaken,OrderList)
		]
	],

	[% if the order is a drink
		id ==> order_recovery(Loc,1,[drink(Drink)]),
		type ==> neutral,
		arcs ==> [
			empty : [
				say('I will go for your drink')
			] => dispense(Loc,[drink(Drink)])
		]
	],
	[% if no orders were taken
		id ==> order_recovery(_,_,_),
		type ==> neutral,
		arcs ==> [
		empty : [
			say('Sorry I could not take your order Trying again')
		] => order
		]
	],


	[% fetching and carrying the orders phase
		id ==> dispense(Loc,Orders),
		type ==> recursive,
		embedded_dm ==> fetch_and_carry(Loc, handle, object, Orders, [Loc], [0.0, -20.0, 20.0], [-30.0], _, _, _, _),
		arcs ==> [
			success : [
				say('I delivered a drink to a guest'),
				apply(remove_customer(C),[customer]),
				get(wait_position, WaitPos)
			] => goto_wait_position(l1),
			error : [
				say('Sorry. I could not dispense all the orders. Trying again.')
			] => dispense(Loc,Orders)
		]
	],

	[% go to wait position
		id ==> goto_wait_position(Position),
		type ==> recursive,
		embedded_dm ==> move(Position, MoveStatus),
		arcs ==> [
			success : empty => search_people_without_drinks(Tilt),
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
