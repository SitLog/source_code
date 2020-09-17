% Main dialogue model for the Restaurant test of the RoboCup@Home 
% Competition, Rulebook 2016
%
% Copyright (C) 2016 UNAM (Universidad Nacional Autónoma de México)
% Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)
%
diag_mod(restaurant_main,
 [
   [% start   
    id ==> is,	
    type ==> neutral,
    arcs ==> [
              empty : [		% Running follow agents 
		       apply(initialize_KB,[]),
		       tilth(0.0),
		       tiltv(-15.0),				
		       say('Hello everybody my name is Golem')
     	     	      ] => guide
       ]
 ],

 [% phase where a user guides the robot through the environment
   id ==> guide,
   type ==> recursive,
   embedded_dm ==> guided_tour(GuideStatus),
   arcs ==> [
	     success : [
		        say('we are finished')
	               ] => ask_for_table,
	     
	     error : [
		      say('sorry i am lost and can not continue with the test')
		     ] => finish
	    ]
  ],

 [% getting name of the table to 
   id ==> ask_for_table,

   type ==> recursive,

   embedded_dm ==> ask_for_table(TableNumber,Status),

   arcs ==> [
  	     success : empty => order(TableNumber),
  	     error : empty => order(TableNumber)
  	    ]
  ],


  [% ordering phase
   id ==> order(TableNumber),
   type ==> recursive,
   embedded_dm ==> take_orders(2,TableNumber,OrdersTaken,OrderList,OrderStatus),
   arcs ==> [
	     success : [
		        say('ok i will for your orders now')
		       ] => move(OrderList),
	    
	    error : empty => order_recovery(OrdersTaken,OrderList)
	    ]
  ],

  [% ordering phase
   id ==> move(OrderList),
   type ==> recursive,
   embedded_dm ==> move(food,Status),
   arcs ==> [
	     success : [
		        say(['ok i will for your orders now', ObjectList])
		       ] => dispense(OrderList),
	    
	    error : empty => dispense(OrderList)
	    ]
  ],

  [% if the order is a drink
   id ==> order_recovery(1,[drink(Drink)]),
   type ==> neutral,

   arcs ==> [
   	     empty : [
		        say('I will go for your drink')
		     ] => dispense([drink(Drink)])
	    ]
  ],

  [% if the order is a combo
   id ==> order_recovery(1,[combo(Obj1,Obj2)]),
   type ==> neutral,

   arcs ==> [
   	     empty : [
		        say('I will go for your combo')
		     ] => dispense([combo(Obj1,Obj2)])
	    ]
  ],

  [% if no orders were taken
   id ==> order_recovery(_,_),
   type ==> neutral,

   arcs ==> [
   	     empty : [
		        say('Sorry I could not take your order trying again')
		     ] => order
	    ]
  ],


  [% fetching and carrying the orders phase
   id ==> dispense(Orders),
   type ==> recursive,
   embedded_dm ==> fetch_and_carry(origin, handle, object, Orders, Places, [0.0, -20.0, 20.0], [-30.0], _, _, _, _),
   arcs ==> [
	     success : [
		        say('I finished attending the table')
		       ] => ask_for_table,

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
 ]
).
