% Main dialogue model for the Take out the garbage test of the RoboCup@Home 
% Competition, Rulebook 2019
%
% Copyright (C) 2019 UNAM (Universidad Nacional Autónoma de México)
% Ivan Torres (ivantr18@hotmail.com)
% 
%	roscore
%	rosserial
%	torso
%	rosaria
%	golem_navigation_wo_follow
%	rviz
%	En windows : WinASR
%	
%%
diag_mod(where_is_main,
[
    %%Initial situation
    [
	id ==> is,	
	type ==> neutral,
	arcs ==> [
		empty : [assign(Odometry,apply(get_amcl,[])),set(waiting_position,Odometry),say('Hello, please stand in front of me'),sleep,sleep,sleep,tiltv(-18.0),set(last_tilt,-18.0)] => recognize
	]
    ],
    [
	id ==> offer_help,	
	type ==> neutral,
	arcs ==> [
		empty : [say('Hello, please stand in front of me'),sleep,sleep,sleep,tiltv(-18.0),set(last_tilt,-18.0)] => recognize
		
	]
    ],
    [
	id ==> go_to_inf,	
	type ==> recursive,
	embedded_dm ==> move(get(waiting_position,_),Status),
	%embedded_dm ==> say(['Moving to',get(waiting_position,_)],Status),
	arcs ==> [
		success : [say('Hello, please stand in front of me'),sleep,sleep,sleep,tiltv(-18.0),set(last_tilt,-18.0)] => recognize,
		error : [say('Sorry I cannot reach the information point')] =>go_to_inf
	]
    ],
    [
      			id ==> recognize,	
      			type ==> recognize_follow,
      			arcs ==> [
        				success : [say('I recognize you, please speak loud and after the beep, How can I help you')] => get_location,
        				error : empty => recognize
      				]
    	], 
    %listening for location
    [
	 id ==> get_location,
	 type ==> listening(whereisthis),
	 arcs ==> [
	                said(X): [apply( wii_parser(_X,_Y), [X,Y] ) ] => confirm(Y),
	                said(nothing): [say('Sorry I did not hear you, please speak louder and after the beep')] => get_location
		  ]
    ],
    [
	 id ==> confirm(X),
	 type ==> neutral,
	 arcs ==> [
	                empty: [say(['You ask for',X]),inc(count,C)] => apply(whereis_count(_C,_X),[C,X])
	                
		  ]
    ],
    %%Explain a place-where I am
    [
	id ==> explain_place(X),	
	type ==> whereiam,
	%type ==> whereiam_dummy,
	arcs ==> [
		text(Init) : empty => explain_place_2(X,Init),
		text(outside) : [say('Sorry I am outside the arena')] =>explain_place(X)
	]
    ],
    
    %%Explain a place-2
    [
	id ==> explain_place_2(X,Init),	
	type ==> recursive,
	embedded_dm ==> give_directions(X,Init,Status),
	arcs ==> [
		success : [say('I will wait for the next person'),sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep,get(count,C)] => apply(whereis_check_final(_C),[C]),
		error : [say('Sorry I cannot give you the directions')] =>explain_place_2(X,Init)
	]
    ],
    
    %%ask follow
    [
	id ==> ask_follow(X),	
	type ==> neutral,
	
	arcs ==> [
		empty : [say(['Please follow me to the',X])] => going_to_place(apply(whereis_get_room(_Object),[Object]))
		
	]
    ],
    
    %%Moving to place
    [
	id ==> going_to_place(X),	
	type ==> recursive,
	embedded_dm ==> move(X,Status),
	%embedded_dm ==> say('move to location',_),
	arcs ==> [
		success : [say(['We arrived here is the',X]),get(count,C)] => apply(whereis_check_final_move(_C),[C]),
		error : [say('Sorry I cannot reach the place')] =>going_to_place(X)
	]
    ],
    

    %final situation
    [
	id ==> fs,
	type ==> final
    ]
  ],
  
  [
  	waiting_position ==> [0,0,0],
  	count ==> 0
  ]
).	

