% Competition, Rulebook 2017
%
% Copyright (C) 2017 UNAM (Universidad Nacional Autónoma de México)
% Caleb Rascon (http://calebrascon.info)
% Based on the 2016 work of:
%       Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)

% 1.- Take order from customer
% 2.- Decide how to arrange it

diag_mod(take_orders(OrderNumber,OrdersTaken,OrderList,OrderStatus),
[% list of situations

	[% initial situation
		id ==> ask_first,
		type ==> recursive,
		embedded_dm ==> ask_restaurant_commands('Which is your first order.',restaurant_command,true,2,OrderTaken,AskStatus),
		arcs ==> [
			success : empty => form_order(OrderTaken),
			error : [
				say('I could not understand')
			] => ask_order_recovery
		]
	],

	[% asking next order
		id ==> ask_next(true),
		type ==> recursive,
		embedded_dm ==> ask_restaurant_commands('Which is your next order.',restaurant_command,true,2,OrderTaken,AskStatus),
		arcs ==> [
			success : empty => form_order(OrderTaken),
			error : [
				say('I could not understand')
			] => ask_order_recovery
		]
	],

	[% no missing orders
		id ==> ask_next(false),
		type ==> neutral,
		arcs ==> [
			empty : empty => success
		]
	],

	[% recovery of ask label
		id ==> ask_order_recovery,
		type ==> recursive,
		out_arg ==> [AskStatus],
		embedded_dm ==> ask_restaurant_commands('Could you repeat the order.',restaurant_command,true,2,OrderTaken,AskStatus),
		arcs ==> [
			success : empty => form_order(OrderTaken),
			error : empty => error
		]
	],


	[% forming order
		id ==> form_order(drink(Drink)),
		type ==> neutral,
		arcs ==> [
			empty : [
				get(orders,CurrentOrders),
				append(CurrentOrders,[order(Drink,customer)],NewOrders),
				set(orders,NewOrders),
				inc(count,Count)
			] => ask_next(apply(missing_orders(N,C),[OrderNumber,Count]))
		]
	],

	[% forming order
		id ==> form_order(combo(Obj1,Obj2)),
		type ==> neutral,
		arcs ==> [
			empty : [
				get(orders,CurrentOrders),
				append(CurrentOrders,[order(Obj1,customer)],NewOrders),
				append(NewOrders,[order(Obj2,customer)],ComboOrders),	
				set(orders,ComboOrders),
				inc(count,Count)
			] => ask_next(apply(missing_orders(N,C),[OrderNumber,Count]))
		]
	],

	% final situations
	[
		id ==> success,
		type ==> final,
		diag_mod ==> take_orders(_, get(count,Count),get(orders,Orders), ok)
	],

	[
		id ==> error,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==>  take_orders(_, get(count,Count),get(orders,Orders), FinalStatus)
	]
],

% local variables
[
	count ==> 0,
	orders ==> []
]
).
