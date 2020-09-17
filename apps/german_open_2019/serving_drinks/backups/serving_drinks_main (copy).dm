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
			empty : [		
				tiltv(0.0),
				set(last_tilt,0.0),
				get(last_tilt, LastTilt),
				%tilth(0),set(last_scan,0),
				%say('Hello I am golem, and I will be serving drinks today.'),
				%say('I will first go to the bar.')
			] => ask_start%goto_bar(LastTilt)
		]
	],
	[% going to the bar (known location)   
		id ==> goto_bar(LastTilt),	
		type ==> recursive,
		embedded_dm ==> move(bar, MoveStatus),
		arcs ==> [
			success : [tiltv(-30.0),
				set(last_tilt,-30.0),
				get(last_tilt, LastTilt)] => see_drinks(LastTilt),
			error : empty => goto_bar(LastTilt)
		]
	],
	[% see drinks in the bar && save to KB
		id ==> see_drinks(LastTilt),
		type ==> yolo_object_detection(LastTilt,drinks),%or see_object?
		arcs ==> [
			%Que aquí yolo solo identifique drinks, pesos custom
			objects(ObjectList) : 	[tiltv(0.0),
				set(last_tilt,0.0),
				get(last_tilt, LastTilt),say('I see some drinks.'),say('Now I will go to the living room.')] => goto_living_room(LastTilt),
			status(Status):		[say('I did not see any drinks')] => fs
			
		]
	],
	[% going to the living room (known location)   
		id ==> goto_living_room(LastTilt),	
		type ==> recursive,
		embedded_dm ==> move(living_room, MoveStatus),
		arcs ==> [
			success : empty => search_people_without_drinks(LastTilt),
			error : empty => goto_living_room(LastTilt)
		]
	],
	[% search people y ver si tienen bebida y estan en la arena
		%comando find? openpose? yolo?
		%--> yolo -> Servicio que identifique personas y bebidas, las proyecte en 2d y calcule la distancia
		%openpose -> Keypoints de las manos de las personas, proyeccion en 2d y calcular distancia
		%Eliminar personas fuera de la arena
		id ==> search_people_without_drinks(LastTilt),	
		type ==> yolo_object_detection(LastTilt,people_and_drinks),
		arcs ==> [
			objects(ObjectList) : 	say('I see some people without drinks.') => recorrer_arreglo(ObjectList),
			status(Status):		say('I do not see people without drinks') => fs
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
		id ==> recorrer_arreglo([object(Name,Rq1,Rq2,Rq3,Rq4,Score,X,Y,Z)|More]),	
		type ==> neutral,
		arcs ==> [
			empty : [set(PeopleLst,More),apply( convert_cartesian_to_cylindrical(Xval,Yval,Zval,Rval,Oval),[X,Y,Z,R,O]),get_close(R,O)] => askname
		]
	],
	% acercase a la primera persona sin bebida
	%[
	%        id ==> approach_person(X,Y,Z),
	%        type ==> recursive,
	        %Transformar coordenadas relativas a absolutas
	%        embedded_dm ==> [apply( convert_cartesian_to_cylindrical(Xval,Yval,Zval,Rval,Oval) , [X,Y,Z,R,O] )
	%					,get_close(R,O)],
	%        arcs ==> [
	%                 success : [] => askname,
	%                 error   : [] => approach_person(X,Y)
	%                 ]
	%],
	 [
      id ==> ask_start,	
      type ==> neutral,
      arcs ==> [
        empty : [initSpeech] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		embedded_dm ==> ask('Please, tell me your name',human,true,100,Res,Status), 
      		
      		arcs ==> [
        			success : [say('Hi',Res)] => ask_for_table,
        			error : [say('I did not understood')] => fs
				
      			]
     ],
	[% getting name of the person 
		id ==> askname,
		type ==> recursive,
		%out_arg ==> [Status],
	 	embedded_dm ==> ask('Please, tell me your name',human,false,1,Res,Status),
		arcs ==> [
	  		 success : say(['Hi',Res,'let me memorize your face'],get(last_tilt, LastTilt)) => ask_for_table,%memorizar_persona(Res,LastTilt),
	  		 error : [ 
		              say('I am sorry I could not understand')
  			     ] => ask_for_table
  		    ]
  	],
  	%% Memorize face
  	%Detectar a la persona que queremos memorizar
	[% search people y ver si tienen bebida y estan en la arena
		id ==> memorizar_persona(Res,LastTilt),	
		type ==> yolo_object_detection(LastTilt,closest_person),
		arcs ==> [
			objects(ObjectList) : 	empty => solicitar_color(ObjectList,LastTilt),
			status(Status):		say('I see nobody. Trying again') => memorizar_persona(Res,LastTilt)
		]
	],
  	
  	%Solicitar el color de los keypoints y guardarlos en una variable local
  	[
		id ==> solicitar_color([object(Name,Rq1,Rq2,Rq3,Rq4,Score,X,Y,Z)|More],LastTilt),	
		type ==> neutral,%ask_for_color([object(Name,Rq1,Rq2,Rq3,Rq4,Score,X,Y,Z)|More),
		arcs ==> [
			objects(ColorList) : 	save_color => take_order,
			status(Status):		empty => fs
		]
	],
  	%Tomar la orden
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TOMADO DE RESTAURANT
  		[% getting name of the table to 
		id ==> ask_for_table,
		type ==> recursive,
		embedded_dm ==> ask_for_table(Status),
		arcs ==> [
			success : empty => order,
			error : [
				say('Attempting to continue the task from here.')
			] => order
		]
	],


	[% taking the orders
		id ==> order,
		type ==> recursive,
		embedded_dm ==> take_orders(1,OrdersTaken,OrderList,OrderStatus),
		arcs ==> [
			success : [
				say('Ok. I will go for your orders now.'),get(origin, Origin)
			] => dispense(Origin,OrderList),
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TOMADO DE REST
  	
  	%Ir al bar por la orden
  	
  	%Ir al living room
  	
  	%buscar personas sin bebida
  	
  	%Ver cuál de ellas encaja con el color
  	
  	%Darle el drink
  	
  	%Volver al living room
	[
	       id ==> memorizar_face(Name),
	       type ==> memorize_face(Name),
	       arcs ==> [
	                empty : empty => takeorder
	                ]
	],
	[% take order
		id ==> takeorder,
		type ==> recursive,
		embedded_dm ==> ask_restaurant_commands('which is your order',restaurant_command,true,2,OrderTaken,AskStatus),
		arcs ==> [
  		     success : empty => dispense(OrderTaken),
  		     error : [
  			      say('I could not understand')
  			     ] => ask_order_recovery
  		]
  	],
  	[% fetching and carrying the orders phase
   		id ==> dispense(OrderTaken),
   		type ==> recursive,
   		%de donde sale object?
   		embedded_dm ==> fetch_and_carry(living_room, handle, object, [OrderTaken], bar, [0.0, -20.0, 20.0], [-30.0], _, _, _, _),
   		arcs ==> [
			     	success : [
			     			say('I finished attending the table'),get(PeopleLst,MorePeople)
			     			%Repetir el proceso
			     		] => search_people_without_drinks,%recorrer_arreglo(MorePeople),
	
				error : [
			     			say('sorry i could not dispense all the orders trying again')
			    		] => dispense(Orders)

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
  	PeopleLst ==> [],
  	count ==> 0,
  	LastTilt ==> 0,-
  	orders ==> []
 
 ]
).
