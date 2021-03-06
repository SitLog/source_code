% Main dialogue model for the Serving Drinks test of the RoboCup@Home 
% Competition, Rulebook 2019
%
% Copyright (C) 2019 UNAM (Universidad Nacional Autónoma de México)
% Dennis Mendoza (dms.albertmend@gmail.com)
% 
%	roscore
%	rosserial
%	torso
%	rosaria
%	golem_navigation_followmap.launch
%	rviz
%	En windows : yolo, WinASR, WinASR-custom
%	


diag_mod(serving_drinks_main,
[
	[% start   
		id ==> is,	
		type ==> neutral,
		arcs ==> [
			 empty : [
				 apply(initialize_KB,[]),		
				 tiltv(-20.0),
				 set(last_tilt,-20.0)
				 say('Hello I am golem, and I will be serving drinks today'),
				 say('I will first go to the bar')
			         ] 
			        => goto_bar
		         ]
	],
	
	[% going to the bar (known location)   
		id ==> goto_bar,	
		type ==> recursive,
		embedded_dm ==> move(bar, _),
		arcs ==> [
			 success : empty => voltear_abajo,
			 error   : empty => goto_bar
		         ]
	],
	
	[% voltear abajo   
		id ==> voltear_abajo,	
		type ==> neutral,
		arcs ==> [
			 empty : [
			         tiltv(-30.0),
				 set(last_tilt,-30.0),
				 assign(Odometry,apply(get_odometry,[])),
				 set(origin,Odometry) 
				 ]
				 => see_drinks(-30.0)
		]
	],
	
	[% see drinks in the bar && save to KB
		id ==> see_drinks(Tilt),
		type ==> yolo_object_detection(Tilt,drinks),
		arcs ==> [
			 %Que aquí yolo solo identifique drinks, pesos custom
			 objects(ObjectList) : 	[
			                        tiltv(0.0),
			                        set(last_tilt,0.0),
	                                        say('I see some drinks'),
	                                        say('Now I will go to the living room')
	                                        ] 
	                                        => save_objects(ObjectList),
			status(Status)       :	[say('I did not see any drinks')] => fs
			
		]
	],
	
	[
		id ==> save_objects([]),
		type ==> neutral,
		arcs ==> [
			 empty : empty => goto_living_room	
		         ]
	],
	
	[
		id ==> save_objects([object(Name,Rq1,Rq2,Rq3,Rq4,Score,X,Y,Z)|More]),
		type ==> neutral,
		arcs ==> [
			 empty: [
				assign(ListaAntes,get(drinkList,_)),
				append([Name],ListaAntes,ListaDespues),
				set(drinkList,ListaDespues),
				say(['I see ',Name])
				] 
				=> save_objects(More)	
		         ]
	],

	[% going to the living room (known location)   
		id ==> goto_living_room,	
		type ==> recursive,
		embedded_dm ==> move(l1, _),
		arcs ==> [
			 success : [
			            get(last_tilt, Tilt),
			            assign(Amcl,apply(get_amcl,[])),
			            set(wait_position,Amcl), %storing origin location, ASSUMPTION: THIS IS WHERE WE PICK UP EVERYTHING
			            tiltv(-10.0),
			            set(last_tilt,-10.0)
				   ] 
				   => search_people_without_drinks(-10.0),
			 error : empty => goto_living_room
		         ]
	],
	
	[% search people y ver si tienen bebida y estan en la arena
		%comando find? openpose? yolo?
		%--> yolo -> Servicio que identifique personas y bebidas, las proyecte en 2d y calcule la distancia
		%openpose -> Keypoints de las manos de las personas, proyeccion en 2d y calcular distancia
		%Eliminar personas fuera de la arena
		id ==> search_people_without_drinks(Tilt),	
		type ==> yolo_object_detection(Tilt,people_and_drinks),
		arcs ==> [
			 objects(ObjectList) : 	say('I see some people without drinks.') => recorrer_arreglo(ObjectList),
			 status(_)      :	say('I do not see people without drinks. Finished the task.') => fs
		         ]
	],
	
	[% recorrer arreglo de personas
		id ==> recorrer_arreglo([]),	
		type ==> neutral,
		arcs ==> [
			 empty : empty => fs
		         ]
	],
	
	[% recorrer arreglo de personas
		id ==> recorrer_arreglo([object(Name,X,Y,Z,_,_,_,_,_)|More]),	
		type ==> neutral,
		arcs ==> [
			 empty : [
			         apply( convert_cartesian_to_cylindrical_yolo(X_,Z_,Y_,R_,O_),[X,Z,Y,R,O])
				 ]
				 => odometria(R,O)
		         ]
	],
	
	[
		id ==> odometria(R,O),	
		type ==> neutral,
		arcs ==> [
			empty : [
				
				assign(Odom, apply(get_person_odometry_yolo(P_,L_),[[R,O,1],80]))
				] 
				=> add_client_kb(Odom)%add_client_kb([-1.10266206277,-0.679910932601,99.9872491386])
		]
	],
	
	[
		id ==> add_client_kb(Odometry),	
		type ==> neutral,
		arcs ==> [
			 empty : [
				 apply(add_location_kb(L,P),[customer,Odometry])
				 ]
				=> get_close
		         ]
	],
		
	[
		id ==> get_close,	
		type ==> neutral,
		arcs ==> [
			  empty : [say('Asking for table')] => ask_for_table
		         ]
	],
	
	[% going to customer
		id ==> ask_for_table,
		type ==> recursive,
		embedded_dm ==> ask_for_table(Status),
		arcs ==> [
			success : empty => askname,
			error : [
				say('Attempting to continue the task from here.')
			] => detect_face
		]
	],
	[  
      		id ==> askname,
      		type ==> recursive,
      		embedded_dm ==> ask('Please, tell me your name',human,true,2,Res,Status), 
      		
      		arcs ==> [
        			success : [say(['Hi',Res,'let me memorize your face']),
				 set(client_name,Res)] => detect_face,
        			error : [say('I did not understood')] => behavior
				
      			]
       ],
	[%detect_face
		id ==> detect_face,
		type ==> detect_face_cognitive(detect),
		arcs ==> [		
				faceId(X) : [say(['I memorized your face']),set(client_id,X),set(face_id_cg,X)] => order,
				faceId('no detected') : empty => error
		  ]
	],
	

	[% taking the orders
		id ==> order,
		type ==> recursive,
		embedded_dm ==> take_orders(1,OrdersTaken,OrderList,OrderStatus),
		arcs ==> [
			success : [
				say('Ok. I will go for your orders now.'),get(origin, Origin)
			] => dispense(bar,OrderList),
			error : [get(origin, Origin)] => order_recovery(Origin,OrdersTaken,OrderList)
		]
	],

	[% if the order is a drink
		id ==> order_recovery(Loc,1,[drink(Drink)]),
		type ==> neutral,
		arcs ==> [
			empty : [
				say('I will go for your drink.')
			] => dispense(Loc,[drink(Drink)])
		]
	],
	[% if no orders were taken
		id ==> order_recovery(_,_,_),
		type ==> neutral,
		arcs ==> [
		empty : [
			say('Sorry. I could not take your order. Trying again.')
		] => order
		]
	],


	[% fetching and carrying the orders phase
		id ==> dispense(Loc,Orders),
		type ==> recursive,
		embedded_dm ==> fetch_and_carry(Loc, handle, object, Orders, [Loc], [0.0, -20.0, 20.0], [-30.0], _, _, _, _),
		arcs ==> [
			success : [
				say('I finished attending the table.'),
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
  	wait_position ==> [0.0,0.0,0.0],
  	client_name ==> [],
  	client_id ==> [],
  	peopleLst ==> [],
  	drinkList ==> [],
  	count ==> 0,
  	orders ==> []
 ]
).
