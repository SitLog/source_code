
diag_mod(attend_guest(FinalStatus),
[% list of situations
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
			 empty : empty   => approach_customer
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
        			error : [say('I did not understood')] => askname
				
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
				apply(remove_customer(C),[customer])
			] => success,
			error : [
				say('Sorry. I could not dispense all the orders. Trying again.')
			] => dispense(Loc,Orders)
		]
	],
	% final situations
	[
		id ==> success,
		type ==> final,
		diag_mod ==> attend_guest(ok)
	],

	[
		id ==> error,
		type ==> final,
		diag_mod ==>  attend_guest(error)
	]
],

% local variables
[
	
]
).
