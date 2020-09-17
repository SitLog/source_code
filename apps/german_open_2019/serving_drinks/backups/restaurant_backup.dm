% Main dialogue model for the Restaurant test of the RoboCup@Home 
% Competition, Rulebook 2017
%
% Copyright (C) 2017 UNAM (Universidad Nacional Autónoma de México)
% Caleb Rascon (http://calebrascon.info)
% Based on the 2016 work of:
%       Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)
%
diag_mod(serving_drinks_main,
[
	[% start   
		id ==> starte,	
		type ==> neutral,
		arcs ==> [
			empty : [		% initializing everything
				say('Hello everybody my name is Golem'),
				say('I first need to ask, is the bar on my left?')
			] => fs
		]
	],

	[% ask which side is the bar   
		id ==> askbar,	
		type ==> listening(yesno),
		arcs ==> [
			said(yes) : [
				turn(-90.0,Result)
			] => storepoint(90.0),
			said(no) : [
				turn(90.0,Result)
			] => storepoint(-90.0),
			said(nothing) : [
				say('I could not hear you.'),
				say('Is the bar on my left?.')
			] => askbar
		]
	],

	[% store point
		id ==> storepoint(FinalTurn),	
		type ==> neutral,
		arcs ==> [
			empty : [		% initializing everything
				assign(Odometry,apply(get_odometry,[])),
				set(origin,Odometry), %storing origin location, ASSUMPTION: THIS IS WHERE WE PICK UP EVERYTHING
				say('I am going to assume that here is the bar.'),
				turn(FinalTurn,Result)
			] => guide
		]
	],

	[% find waving/calling person
		id ==> guide,
		type ==> recursive,
		embedded_dm ==> guided_tour(GuideStatus),
		arcs ==> [
			success : [
				say('I understood that you want me to attend customer.')
			] => ask_for_table,
			error : [
				say('Reached an impossible situation. Abandoning task.')
			] => fs
		]
	],

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

	[% if the order is a combo
		id ==> order_recovery(Loc,1,[combo(Obj1,Obj2)]),
		type ==> neutral,
		arcs ==> [
			empty : [
				say('I will go for your combo.')
			] => dispense(Loc,[combo(Obj1,Obj2)])
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
			] => goto_wait_position(WaitPos),
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
