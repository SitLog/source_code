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
    %Detect door
    [  
       id ==> is,
       type ==> recursive,
       %embedded_dm ==> detect_door(_),
       embedded_dm ==> say('detect door',_),
       arcs ==> [
                %success : [apply(register_max_time(_MaxHrs,_MaxMins,_MaxSecs),[0,1,0])] => go_to_inf,
                success : empty => go_to_inf,
                error   : [say('Open the door please')] => is				
                ]
    ],
    %%Moving to information_point
    [
	id ==> go_to_inf,	
	type ==> recursive,
	%embedded_dm ==> move(get(waiting_position,_),Status),
	embedded_dm ==> say(['Moving to',get(waiting_position,_)],Status),
	arcs ==> [
		success : [say('Hello, how can I help you')] => get_location,
		error : [say('Sorry I cannot reach the information point')] =>go_to_inf
	]
    ],
    [
	id ==> offer_help,	
	type ==> neutral,
	arcs ==> [
		empty : [say('Hello, how can I help you')] => get_location
		
	]
    ],
    %listening for location
    [
	 id ==> get_location,
	 type ==> listening(whereisthis),
	 arcs ==> [
	                said(X): [say(['Do you want to know where is the ',apply( wii_parser(_X,_Y), [X,Y] )])] => confirm(Y),
	                said(nothing): [say('Sorry I did not hear you')] => get_location
		  ]
    ],
    [
	 id ==> confirm(X),
	 type ==> listening(yesno),
	 arcs ==> [
	                said(yes): [say('Perfect'),inc(count,C)] => apply(whereis_count(_C,_X),[C,X]),
	                said(no): [say('Please ask me again')] => get_location,
	                said(nothing): empty => confirm(X)
		  ]
    ],
    %%Explain a place-where I am
    [
	id ==> explain_place(X),	
	%type ==> whereiam,
	type ==> whereiam_dummy,
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
		success : [get(count,C)] => apply(whereis_check_final(_C),[C]),
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
	%embedded_dm ==> move(X,Status),
	embedded_dm ==> say('move to location',_),
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
  	waiting_position ==> init_where,
  	count ==> 0
  ]
).	

