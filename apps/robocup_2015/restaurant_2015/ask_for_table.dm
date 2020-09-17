% Dialogue model for asking for table to take orders from.
%
% Copyright (C) 2016 UNAM (Universidad Nacional Autónoma de México)
% Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)
%
diag_mod(ask_for_table(TableNumber,Status),
 [% list of situations

 [% getting name of the table to 
   id ==> ask_for_table,

   type ==> recursive,

   out_arg ==> [AskStatus],

   embedded_dm ==> ask('which table do you want me to attend',restaurant_tables,true,2,TableToVisit,AskStatus),

   arcs ==> [
  	     success : empty => move(TableToVisit),
  		       
  	     error : [ 
	              say('I could not understand')
  		     ] => ask_for_table_recovery
  	    ]
  ],

 [% getting name of the table to 
   id ==> ask_for_table_recovery,

   type ==> recursive,

   out_arg ==> [AskStatus],

   embedded_dm ==> ask('which table do you want me to attend',restaurant_tables,true,2,TableToVisit,AskStatus),

   arcs ==> [
  	     success : empty => move(TableToVisit),
  		       
  	     error : [ 
	              say('I am sorry I could not understand')
  		     ] => ask_for_table
  	    ]
  ],

  [% initial situation
   id ==> move(TableToVisit),

   type ==> recursive,

   out_arg ==> [TableToVisit,MoveStatus],

   embedded_dm ==> move(TableToVisit,MoveStatus),

   arcs ==> [
  	     success : empty => success,

  	     error : [
  		      say(['I could not reach table ', TableToVisit])
  		     ] => move_recovery(TableToVisit)
  	    ]
  ],

  [% initial situation
   id ==> move_recovery(TableToVisit),

   type ==> recursive,

   out_arg ==> [TableToVisit,MoveStatus],

   embedded_dm ==> move(TableToVisit,MoveStatus),

   arcs ==> [
  	     success : empty => success,

  	     error : [
  		      say(['I could not arrive properly to table ', TableToVisit])
  		     ] => error
  	    ]
  ],

  % final situations
  [
   id ==> success,
   type ==> final,
   in_arg ==> [TableToVisit,FinalStatus],
   diag_mod ==> ask_for_table(TableToVisit,ok)
  ],
  
  [
   id ==> error,
   type ==> final,
   in_arg ==> [TableToVisit,FinalStatus],
   diag_mod ==>  ask_for_table(TableToVisit,FinalStatus)
  ]
 ],
 % local variables
 [
 ]
).
