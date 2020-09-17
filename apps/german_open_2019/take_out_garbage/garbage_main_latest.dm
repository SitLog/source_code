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
       %embedded_dm ==> detect_door(_),
       embedded_dm ==> say('SAY: Detect DOOR',Status),
       arcs ==> [
                success : [say('Thank you')] => is,
                error   : [say('Open the door please')] => detect				
                ]
    ],
    [
	id ==> is,	
	type ==> neutral,
	arcs ==> [
		empty : [say('Hello, I will take out the garbage')] => move_to_bag(bin1,2)
	]
    ],
    
    %%Moving to the first bag
    [
	id ==> move_to_bag(Point,Arm),	
	type ==> recursive,
	%embedded_dm ==> move_follow_garbage(Point,Status),
	embedded_dm ==> say(['SAY: Move ',Point],Status),
	arcs ==> [
		success : [
			say('I need someone to hand me the bag, please stand in front of me, I will grasp it')]
			%robotheight(1.40),set(last_height,1.40)]
		 => detect_person(Point,Arm),
		error : [say('Sorry I cannot reach the bin, I will try it again')] =>move_to_bag(Point,Arm)
	]
    ],
    
    %%Detect person
    [
	id ==> detect_person(Point,Arm),	
	type ==> person_pose_op,
	%%embedded_dm ==> move_follow_garbage(Point,Status),
	arcs ==> [
		person_pose_op(0,0,0,0) : [say('Sorry I did not see you, please stand in front of me')] => fs,
		%person_pose_op(0,0,0,0) : [say('Sorry I did not see you, please stand in front of me')] => detect_person(Point,Arm)
		person_pose_op(Ang,X,Y,Z) : [
			Dist is (X**2 + Y**2)**(1/2)-50, %% (X^2 + Y^2)^1/2
			Turn_ang is atan(Y/X)* (180/pi), %%problem with X=0
			turn(Turn_ang,_),
			advance_fine(Dist,Res),
			
			say('please wait until I close my hand'),
			switcharm(Arm),
			sleep,sleep,sleep,
			grasp(0.0,0.5,Result)
		] => apply(next_location_tog(P_),[Point])
		
		
	]
    ],
    
    
    
    %%Following situation
    [
	id ==> move_to_collect,	
	type ==> recursive,
	%embedded_dm ==> move_follow_garbage(collect_zone,Status),
	embedded_dm ==> say('SAY: Move COLLECT',Status),
	arcs ==> [
		success : [say('I will put the trash in this area'),robotheight(1.40),set(last_height,1.40),sleep,switcharm(1),offer,switcharm(2),offer,say('Good, I have finished my task')] => fs,
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

