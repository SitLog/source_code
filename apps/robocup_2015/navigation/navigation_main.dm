%%
diag_mod(navigation_main,
[
    [
	id ==> is,	
	type ==> neutral,
	arcs ==> [
		empty : [say('Starting navigation test. Moving to waypoint 1.')] => nav1
	]
    ],

    %waypoint1
    [  
	id ==> nav1,
	type ==> recursive,
	embedded_dm ==> move(wp2,Status),
	arcs ==> [
		success : [say('Reached waypoint A.'),say('Going to waypoint B.')] => nav2,
		error : [say('Could not reach waypoint A.'),say('Replanning.')] => nav1
		]
    ],

    %waypoint2
    %%TODO: insert face recognition here, a person may be an obstacle
    [  
	id ==> nav2,
	type ==> recursive,
	embedded_dm ==> move(wp1,Status),
	arcs ==> [
		success : [say('Reached waypoint B.'),say('Going to waypoint C.')] => nav3,
		error : [say('Could not reach waypoint B.'),say('Replanning.')] => nav2
		]
    ],

    %waypoint3
    [  
	id ==> nav3,
	type ==> recursive,
	embedded_dm ==> move(wp3,Status),
	arcs ==> [
		%success : [say('Reached waypoint C. Done with navigation test.')] => fs,
		success : [say('Reached waypoint C. Changing navigation setting to following mode.'),tiltv(-15.0),set(last_tilt,-15.0),robotheight(1.40),set(last_height,1.40)] => followmode,
		error : [say('Could not reach waypoint C. Replanning.')] => nav3
		]
    ],

    %changing into follow mode
    %%TODO: store current position as last_position_static_map
    %%TODO: register starting position as [0,0,0] in follow mode
    [  
	id ==> followmode,
	type ==> neutral,
	arcs ==> [
		%empty : [start_gmapping,say('Following human now.')] => followperson
		empty : [say('Following human now.')] => followperson
		]
    ],

    %following person (waypoint4)
    [  
	id ==> followperson,
    type ==> recursive,
    embedded_dm ==> follow(learn,gesture_only,Happened_Event,Status),
	arcs ==> [
		success : [say('Finished following human. Reached last waypoint. Going back to arena.')] => startposition,
		error : [say('Something went wrong. Attempting to keep following human.')] => followperson
		]
    ],

    %startposition
    [  
	id ==> startposition,
	type ==> recursive,
	%embedded_dm ==> move([0.0,0.0,0.0],Status),
	embedded_dm ==> move(wp3,Status),
	arcs ==> [
		%success : [say('Reached starting position. Goodbye.')] => fs,
		success : [say('Reached arena. Changing navigation setting to static map mode.')] => mapmode,
		error : [say('Could not reach arena. Replanning.')] => startposition
		]
    ],

    %changing into follow mode (online gmapping with movement)
    %%TODO: establish the estimate of the current pose as last_position_static_map
    [  
	id ==> mapmode,
	type ==> neutral,
	arcs ==> [
		%empty : [start_amcl,say('Going to exit.')] => exit
		empty : [say('Going to exit.')] => exit
		]
    ],

    %exit
    [  
	id ==> exit,
	type ==> recursive,
	embedded_dm ==> move(start,Status),
	arcs ==> [
		success : [say('Reached exit. Done with navigation test.')] => fs,
		error : [say('Could not reach exit. Replanning.')] => exit
		]
    ],

    [
	id ==> fs,
	type ==> final
    ]
  ],

  % Second argument: list of local variables
  [
  ]

).	

