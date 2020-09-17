
% Dialogue model for following a user and learning the environment
%
% Copyright (C) 2016 UNAM (Universidad Nacional Autónoma de México)
% Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)
%
diag_mod(guided_tour(Status),
[% situations for following a person and registering points and products

	[% initial situation
   		id ==> is,
		   type ==> neutral,
		   arcs ==> 	[
			     		empty : [
						 assign(Odometry,apply(get_odometry,[])),
						 apply(add_location_kb(L,O),[origin,Odometry])
	                                        ] => start
	    			]
  	],
  
  	[% start following the user
  		id ==> start,

	  	type ==> recursive,

	  	out_arg ==> [FollowStatus],
   
	  	embedded_dm ==> follow(learn,gesture_only,Gesture,FollowStatus),
  	
		arcs ==> [
		     		success : say('point the spot if you want me to register this place') => wait_gesture,
				error : empty => error
		    	]
	  ],
  
	  [% continue following the user
	  	id ==> continue,

		type ==> recursive,

		out_arg ==> [FollowStatus],
  
	   	embedded_dm ==> follow(continue,gesture_only,Gesture,FollowStatus),
   
		arcs ==> [
		     		success : say('point the spot if you want me to register this place') => wait_gesture,
				error : empty => error
			 ]
	  ],

	  [ % try to see the gesture
	   	id ==> wait_gesture,
   
		type ==> recursive,
   
   		embedded_dm ==> see_gesture(GestureType, nearest, 10, GestureParameters, GestureStatus),

		arcs ==> [
				success : empty => get_position(GestureType, GestureParameters),
			       	     
				error : [
				         say('sorry can not see any gesture i will continue following you')
		    			] => continue
	    		]
	],

	[ % register location based on the pointing gesture
  		id ==> get_position(pointing, [person(ID,R,O,P)|_]),

  		type ==> neutral,
   
		arcs ==> [
				empty : [
			                 assign(Odometry, apply(get_person_odometry(PersonPose),[[R,O,P]]))
					] => ask_label(Odometry)
		     	 ]
	  ],

	  [% caught finish gesture: killing navigator and user tracker and generating map
  		id ==> get_position(waving, _),

		type ==> neutral,
 
		arcs ==> [
		  		empty : empty => success
		    	]
	  ],

	  [ % caught unexpected gesture
  		id ==> get_position(_,_),
	  	type ==> neutral,
  		arcs ==> [
				empty : say('unexpected gesture i will continue following you') => continue
		      	 ]
	  ],	

	  [% approaching user for asking label
  		id ==> ask_label(Odometry),

	  	type ==> recursive,

  		embedded_dm ==> ask('which is the name of the spot',restaurant_labels,true,2,Label,AskStatus),
	
		arcs ==> [
				success : [									apply(add_location_kb(L,P),[Label,Odometry])
		       			  ] => continue,
	     
	 			error : say('Could not understand the spot name') => ask_label_recovery(Odometry)
		 	]
	  ],

	  [% recovery of ask label
  		id ==> ask_label_recovery(Odometry),

		type ==> recursive,

		embedded_dm ==> ask('please tell me again the name of the spot',restaurant_labels,true,2,Label,AskStatus),

		arcs ==> [
				success : [
					        apply(add_location_kb(L,P),[Label,Odometry])
			       		  ] => continue,
     
			   	error : say('sorry this was not a spot i will continue following you') => continue
			]
	],

	% final situations
	[
  		id ==> success,
	  	type ==> final,
  		diag_mod ==> guided_tour(ok)
	],	
  
	[
  		id ==> error,
	  	type ==> final,
  		in_arg ==> [FinalSatus],
  		diag_mod ==> guided_tour(FinalSatus)
	]
],
	 
 % local variables
[
]
).
