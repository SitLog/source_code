% Dialogue model for taking orders
%
% Copyright (C) 2014 UNAM (Universidad Nacional Autónoma de México)
% Gibran Fuentes Pineda (http://turing.iimas.unam.mx/~gibranfp)
%
diag_mod(take_orders(OrderNumber,CurrLoc,OrdersTaken,OrderList,OrderStatus),
 [% list of situations

  [% initial situation
   id ==> ask_first,

   type ==> recursive,

   embedded_dm ==> ask_restaurant_commands('which is your first order',restaurant_command,true,2,OrderTaken,AskStatus),

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
   
   embedded_dm ==> ask_restaurant_commands('which is your next order',restaurant_command,true,2,OrderTaken,AskStatus),
 
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
  
   embedded_dm ==> ask_restaurant_commands('could you repeat the order',restaurant_command,true,2,OrderTaken,AskStatus),
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
  			append(CurrentOrders,[order(Drink,CurrLoc)],NewOrders),
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
  			append(CurrentOrders,[order(Obj1,CurrLoc)],NewOrders),
			append(NewOrders,[order(Obj2,CurrLoc)],ComboOrders),	
  			set(orders,ComboOrders),
  			inc(count,Count)
  		       ] => ask_next(apply(missing_orders(N,C),[OrderNumber,Count]))
  	    ]
  ],

  % final situations
  [
   id ==> success,
   type ==> final,
   diag_mod ==> take_orders(_, _, get(count,Count),get(orders,Orders), ok)
  ],
  
  [
   id ==> error,
   type ==> final,
   in_arg ==> [FinalStatus],
   diag_mod ==>  take_orders(_, _, get(count,Count),get(orders,Orders), FinalStatus)
  ]
 ],
 % local variables
 [
  count ==> 0,
  orders ==> []
 ]
).
