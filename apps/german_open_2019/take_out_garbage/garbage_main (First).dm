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
diag_mod(garbage_main,
[
    %%Initial situation
    %Detect door
    [  
       id ==> detect,
       type ==> recursive,
       embedded_dm ==> detect_door(_),
       arcs ==> [
                success : empty => is,
                error   : [say('Open the door please')] => detect				
                ]
    ],
    [
	id ==> is,	
	type ==> neutral,
	arcs ==> [
		empty : [say('Hello, I will take out the garbage')] => move_to_bag1
	]
    ],
    
    %%Moving to the first bag
    [
	id ==> move_to_bag1,	
	type ==> recursive,
	embedded_dm ==> move(bin1,Status),
	arcs ==> [
		success : [say('Please put the bag in my hand'),robotheight(1.40),set(last_height,1.40),switcharm(2),grasp(0.0,0.5,Result)] => move_to_bag2,
		error : [say('Sorry I cannot reach the first bin, I will try it again')] =>move_to_bag1
	]
    ],
    
    %%Prepare the following situation
    [
	id ==> move_to_bag2,	
	type ==> recursive,
	embedded_dm ==> move(bin2,Status),
	arcs ==> [
		success : [say('Please put the bag in my hand'),switcharm(1),grasp(0.0,0.5,Result)] => move_to_collect,
		error : [say('sorry I cannot reach the second bin, I will try it again')] =>move_to_bag2
	]
    ],
    
    %%Following situation
    [
	id ==> move_to_collect,	
	type ==> recursive,
	embedded_dm ==> move(collect_zone,Status),
	arcs ==> [
		success : [say('I will put the trash in this area'),sleep,switcharm(1),offer,switcharm(2),offer,say('Good, I have finished my task')] => fs,
		error : [say('sorry I cannot reach the collection zone, I will try it again')] =>move_to_collect
	]
    ],


    

    %final situation
    [
	id ==> fs,
	type ==> final
    ]
  ],
  
  [
  	init_pos ==> [0,0,0]
  ]


).	

