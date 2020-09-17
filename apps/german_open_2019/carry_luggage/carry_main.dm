% Main dialogue model for the Carry my luggage test of the RoboCup@Home 
% Competition, Rulebook 2019
%
% Copyright (C) 2019 UNAM (Universidad Nacional Autónoma de México)
% Ivan Torres (ivantr18@hotmail.com)
% 
%	roscore
%	rosserial
%	torso
%	rosaria
%	golem_navigation_follow
%	rviz
%	En windows : WinASR, OpenPose
%	

%%
diag_mod(carry_main,
[
    %Detect door
    [  
       id ==> detect,
       type ==> recursive,
       embedded_dm ==> detect_door(_),
       arcs ==> [
                success : empty => go_to_ini,
                error   : [say('Open the door please')] => detect				
                ]
    ],
    %%Moving to initial point
    [
	id ==> go_to_ini,	
	type ==> recursive,
	embedded_dm ==> move(get(waiting_position,_),Status),
	%embedded_dm ==> say(['Moving to',get(waiting_position,_)],Status),
	arcs ==> [
		success : [tiltv(-18.0),set(last_tilt,-18.0),say('Hello my name is golem')] => looking_people_bag,
		error : [say('Sorry I cannot reach the initial point')] =>go_to_ini
	]
    ],
    
    
    %%Looking for operator and bag position
    [
	id ==> looking_people_bag,	
	type ==> recursive,
	embedded_dm ==> detecting_pointing_bag(Status),
	arcs ==> [
		success : empty => following,
		error : [say('sorry I did not see you, please stand in front of me')] =>looking_people_bag
	]
    ],
    
    %%Prepare the following situation
    %[
    %	id ==> prep_follow(Loc),	
    %	type ==> recursive,
    %	embedded_dm ==> move_follow(Loc,Status),
    %	arcs ==> [p
    %		success : empty => following,
    %		error : [say('sorry I cannot reach the follow point')] =>prep_follow(Loc)
    %	]
    %],
    
    %%Following situation
    [
	id ==> following,	
	type ==> recursive,
	embedded_dm ==> follow_pose(waving,Status),
	arcs ==> [
		success : [say('Perfect, please take the bag'),sleep,offer,get(waiting_position,Pos)] => come_back(Pos),
		error : [say('sorry I lost you, I will try to follow you again')] =>following
	]
    ],
    
    
    %%Come back situation
    [
	id ==> come_back(Loc),	
	type ==> recursive,
	embedded_dm ==> move_follow_back(Loc,Status),
	arcs ==> [
		success : [say('Good, I have finished my task')] => fs,
		error : [say('sorry I cant reach the initial position')] =>come_back(Loc)
	]
    ],
    
    



    

    %final situation
    [
	id ==> fs,
	type ==> final
    ]
  ],
  
  [
  	waiting_position ==> waiting_position
  ]


).	

