%%
diag_mod(follow_main,
[
    [
	id ==> is,	
	type ==> neutral,
	arcs ==> [
		empty : [tiltv(-18.0),set(last_tilt,-18.0),say('Say follow me when you want to start')] => asktofollow
	]
    ],

    [
	 id ==> asktofollow,
	 type ==> listening(follow),
	 arcs ==> [
	                said(H): empty => followperson,
	                said(nothing): empty => asktofollow
		  ]
    ],

    %following person
    [  
	id ==> followperson,
        type ==> recursive,
        embedded_dm ==> follow(learn,gesture_only,Happened_Event,Status),
	arcs ==> [
		success : [assign(Odometry,apply(get_amcl,[])),set(car_pos,Odometry),
		           say('I see the stop gesture. Do you want me to stop following you?')] => voice_confirmation,
		error : [say('Something went wrong. Attempting to keep following human.'),say('Please hand me the bag.')] => followperson
		]
    ],
    
    %% Golem starts this task when he is told to do so
    [	
	id ==> voice_confirmation,
	type ==> listening(yesno),
	arcs ==> [
                  said(yes) : empty => graspbag,
                  said(no)  : [say('Say follow me when you want to start')] => asktofollow,
                  said(nothing):[say('Sorry I could not hear you. Do you want me to stop following you?')] => voice_confirmation
                 ]
    ],

    %grabbing bag
    [  
	id ==> graspbag,
	type ==> neutral,
	arcs ==> [
		empty : [switcharm(2),say('Please put the bag in my hand.'),grasp_bag(0.0,0.5,Result),say('Please tell me the location where you want me to deliver it.')] => getlocation
		]
    ],

    %listening for location
    [
	 id ==> getlocation,
	 type ==> listening(location),
	 arcs ==> [
	                said(H): [say(['Delivering to ', H]),lasertiltv(-60.0)] => going_to_door(H),
	                said(nothing): empty => getlocation
		  ]
    ],
    %going to door
    [  
       id ==> going_to_door(H),
       type ==> recursive,
       embedded_dm ==> move(exit, _),
       arcs ==> [
                success : empty => detect_door(H),
                error   : empty => going_to_door(H)
                ]
    ],
    %Detect door
    [  
       id ==> detect_door(H),
       type ==> recursive,
       embedded_dm ==> detect_door(_),
       arcs ==> [
                success : empty => deliverto(H),
                error   : [say('Open the door please')] => detect_door				
                ]
    ],
    %going to location
    [  
	id ==> deliverto(Loc),
	type ==> recursive,
	embedded_dm ==> move(Loc,Status),
	arcs ==> [
		success : [say('Reached deliver position. Leaving the bag here.')] => leavebag,
		error : [say('Could not reach deliver position. Replanning.')] => deliverto(Loc)
		]
    ],

    %relieving bag
    [  
        id ==> leavebag,
      	type ==> recursive,
        embedded_dm ==> relieve_arg(-22.0,0.5,right, Status),
        arcs ==> [
        	success : [say('Looking for person.')] => lookforperson,
        	error : [say('I did not relieve bag. Retrying.')] => leavebag
      		]
    ],

    %looking for person ADD PERSON RECOGNITION HERE
    [  
	id ==> lookforperson,
      	type ==> recursive,
      	embedded_dm ==> approach_person(body,Final_Position,Status),
      	arcs ==> [
                success : [say('I found you. Please follow me to the car.'),get(car_pos, Odometry)] => guidetocar(Odometry),
                error : [say('I did not found you. If you are here, please follow me to the car.'),get(car_pos, Odometry)] => guidetocar(Odometry)
      	        ]
    ],

    %guide to car
    [  
	id ==> guidetocar(Loc),
	type ==> recursive,
	embedded_dm ==> move(Loc,Status),
	arcs ==> [
		success : [lasertiltv(0.0),say('Reached car. Finished with test.')] => fs,
		error : [say('Could not reach car. Replanning.')] => guidetocar(Loc)
		]
    ],

    %final situation
    [
	id ==> fs,
	type ==> final
    ]
  ],

  % Second argument: list of local variables
  [
  	car_pos ==> [0,0,0]
  ]

).	

