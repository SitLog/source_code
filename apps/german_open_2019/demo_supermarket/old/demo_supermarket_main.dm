% 	Demo Supermarket
%
% Based on the 2017 work of:
%	Caleb Rascón y Dennis Mendoza       
%	Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)
%
diag_mod(demo_supermarket_main,
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
				assign(Odometry,apply(get_odometry,[])),
				set(wait_position,Odometry)
				%say('Hello everybody my name is Golem')%,
				%say('I first need to ask, is the bar on my left?')
			] => move_to_welcome_point
		]
	],
	[% go to wait position
		id ==> move_to_welcome_point,
		type ==> recursive,
		embedded_dm ==> move(welcome_point, MoveStatus),
		arcs ==> [
			success : empty => order,
			error : empty => move_to_welcome_point
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
				say('Your order is complete.'),
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
  	origin ==> shelf_location,
  	wait_position ==> welcome_point
  	
 ]
).
