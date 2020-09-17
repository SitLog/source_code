% Main dialogue model for the Serving Drinks test of the RoboCup@Home 
% Competition, Rulebook 2019
%
% Copyright (C) 2019 UNAM (Universidad Nacional Autónoma de México)
% Dennis Mendoza (dms.albertmend@gmail.com)
% 
% ----- LEVANTAR EN LINUX   --------------
%
%	roscore
%	rosserial
%	torso
%	rosaria
%	golem_navigation_followmap.launch
%	rviz
%
% ----- LEVANTAR EN WINDOWS --------------
%
%	darknet
%	WinASR
%	yolo rosservice
%	
% ----- Debug:
%
%	*Filtro de personas si están dentro o fuera de la arena
%	*Calibrar la distancia a los objetos para saber si tiene drink o no
%	*Configurar que se usen los pesos custom para las bebidas
%	*Protocolo de búsqueda en living room
%	*Configurar distancia a la que debe llegar el robot respecto a la persona
%	*Probar que haga bien los grasps
%	*Probar conversiones de coordenadas
%	*Revisar acumulación de error en odom

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
				 %set(list_of_places,ListaDeLugares),
				 say('Hello I am golem, and I will be serving drinks today'),
				 say('I will first go to the bar')
				 %inc(count1,Count),
				 %screen(Count)
			         ] 
			        => goto_bar
		         ]
	],
	
	[% going to the bar (known location)   
		id ==> goto_bar,	
		type ==> recursive,
		embedded_dm ==> move(bar, _),
		arcs ==> [
			 success : [
			 	 tiltv(-30.0),
				 set(last_tilt,-30.0)
				 ] => see_drinks,
			 error   : empty => goto_bar
		         ]
	],
	
	[% see drinks in the bar 
		id ==> see_drinks,
		type ==> yolo_object_detection(last_tilt,drinks),
		arcs ==> [
			 objects(ObjectList) : 	[
			                        tiltv(0.0),
			                        set(last_tilt,0.0),
	                                        say('I see some drinks'),
	                                        say('Now I will go to the living room')
	                                        ] 
	                                        => save_objects(ObjectList),
			status(Status)       :	[say('I did not see any drinks. The task is finished.')] => fs
			
		]
	],
	% save object list
	[
		id ==> save_objects([]),
		type ==> neutral,
		arcs ==> [
			 empty : empty => goto_places(ListaDeLugares)	
		         ]
	],
	[
		id ==> save_objects([object(Name,Rq1,Rq2,Rq3,Rq4,Score,X,Y,Z)|More]),
		type ==> neutral,
		arcs ==> [
			 empty: [
				assign(ListaAntes,get(available_drinks,_)),
				append([Name],ListaAntes,ListaDespues),
				set(available_drinks,ListaDespues)
				] 
				=> save_objects(More)	
		         ]
	],
	[
		id ==> goto_places([]),
		type ==> neutral,
		arcs ==> [
			 empty : empty   => fs
			 ]
	],
	[
		id ==> goto_places([Place|Rest]),
		type ==> recursive,
		embedded_dm ==> move(Place, _),
		arcs ==> [
			 success : [tiltv(-10.0), set(last_tilt,-10.0)]   => search_people_without_drinks(Rest),
			 error : empty => goto_places([Place|Rest])
		         ]
	],
	[% search people y ver si tienen bebida y estan en la arena
		id ==> search_people_without_drinks(Rest),	
		type ==> yolo_object_detection(last_tilt,people_and_drinks),
		arcs ==> [
			 objects(ObjectList) : 	say('I see some people without drinks') => recorrer_arreglo(ObjectList),
			 status(_)      :	say('I do not see people without drinks Trying again from another point') => goto_places(Rest)
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
		id ==> recorrer_arreglo([object(_,X,Y,Z,_,_,_,_,_)|More]),	
		type ==> neutral,
		arcs ==> [
			 empty : [
			     
			     apply( convert_cartesian_to_cylindrical_yolo(X_,Z_,Y_,R_,O_),[X,Z,Y,R,O]),
			     assign(Odom, apply(get_person_odometry_yolo(P_,L_),[[R,O,1],80])),
			     apply(add_location_kb(L,P),[customer,Odom])
			      ]
				 => approach_customer
		         ]
	],
	
	[% going to customer
		id ==> approach_customer,
		type ==> recursive,
		embedded_dm ==> approach_customer_sd(Status),
		arcs ==> [
			success : empty => askname,
			error : [
				say('Attempting to continue the task from here')
			] => detect_face
		]
	],
	[% ask customer name  
      		id ==> askname,
      		type ==> recursive,
      		embedded_dm ==> ask('Please, tell me your name',human,false,0,Res,Status), 
      		
      		arcs ==> [
        			success : [say(['Hi',Res,'let me memorize your face']),
        					 set(client_name,Res)
        			] 
        			=> detect_face,
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
			success : [say('Ok I will go for your orders now')] => dispense(bar,OrderList),
			error : empty => order_recovery(bar,OrdersTaken,OrderList)
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
				apply(remove_customer(C),[customer1]),
				set(count,0),
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
  	wait_position ==> [0.0,0.0,0.0],
  %	list_of_places ==> [],
  	client_name ==> [],
  	client_id ==> [],
  	count ==> 0,
  	count1 ==> 0,
  	orders ==> []
 ]
).
