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
       embedded_dm ==> detect_door(_),
       arcs ==> [
                success : empty => go_to_inf,
                error   : [say('Open the door please')] => is				
                ]
    ],
    %%Moving to information_point
    [
	id ==> go_to_inf,	
	type ==> recursive,
	embedded_dm ==> move(get(waiting_position,_),Status),
	arcs ==> [
		success : [say('Hello, how can I help you')] => get_location,
		error : [say('Sorry I cannot reach the information point')] =>go_to_inf
	]
    ],
    %listening for location
    [
	 id ==> get_location,
	 type ==> listening(location),
	 arcs ==> [
	                said(X): [say(['Do you want to know where is the ',X])] => confirm(X),
	                said(nothing): [say('Sorry I did not hear you')] => get_location
		  ]
    ],
    [
	 id ==> confirm(X),
	 type ==> listening(yesno),
	 arcs ==> [
	                said(yes): [say(['Please follow me to the',X])] => going_to_place(X),
	                said(no): [say('Please ask me again')] => get_location,
	                said(nothing): empty => confirm(X)
		  ]
    ],
    %%Moving to place
    [
	id ==> going_to_place(X),	
	type ==> recursive,
	embedded_dm ==> move(X,Status),
	arcs ==> [
		success : [say(['We arrived here is the',X])] => go_to_inf,
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
  	waiting_position ==> information_point
  ]
).	

