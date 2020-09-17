% Follow Task Dialogue Model
%
% 	Description	The robot follows a person until an event happens (lost the user or detect a stop gesture, an oclusion, an elevator or a crowd)
%	
%	Arguments	Mode: 
%				learn.- the robot learn a new person and start following
%				continue.- the robot follows a previously learned person
%
%			Expected_Event: 
%				Hypothetic event that must happen when the robot follow the person
%				gesture.- the robot follows the person until he/she make a stop gesture
%				oclusion.- the robot follows the person until a second person blocks the way between the robot and the user
%				elevator.- the robot follows the person until he/she is in the door of an elevator
%				crowd.- the robot follows the person until he/she crosses a crowd
%				Other option, is consider only a specific event and do not verify the other possible events
%				gesture_only
%
%
%			Happened_Event:
%				Real event that happens when the robot is following the user. 
%				gesture.- the person made a stop gesture
%				oclusion.- a second person blocked the way between the robot and the user
%				elevator(R1,A1,A2).- the person is in the door of an elevator with cylindrical coordinates semi-entry in (R1,A1,0), and with an
%					angle A2 to adjust the position of the robot to face the door of the elevator.
%				crowd(X,Y,R).- the person crossed a crowd with cartesian coordinates center in (X,Y,0) and ratio R, all in meters			
%	
%			Status:	
%				ok .- if Expected_Event and Happened_Event are the same
%			       	unexpected_event .- if Expected_Event and Happened_Event are different
%				not_detected .- if the user is not detected to be learned/followed (an internal recovery procedure is performed before ending the dialogue model)

diag_mod(follow(Mode,Expected_Event,Happened_Event,Status), 
	    
	    [
		%Verify Mode
		[
      			id ==> is,	
      			type ==> neutral,
      			arcs ==> [
        				empty : empty => start(Mode)
      				]
    		],
      
		%Learn Mode
		[
      			id ==> start(learn),	
      			type ==> neutral,
      			arcs ==> [
        				empty : [apply(initialize_KB,[]),robotheight(1.10),set(last_height,1.10),tiltv(-10.0),set(last_tilt,-10.0),say('Stand in front of me six feet away, turn your back on me, and wave your hands')] => detect_gesture
        		
      				]
    		],
    	
		[  
      			id ==> detect_gesture,
      			type ==> recursive,
			out_arg ==> [_, StatusGesture],
			embedded_dm ==> see_gesture(waving, nearest, 3, Gesture_Value, StatusGesture),
      			arcs ==> [
        			success : say('Perfect.') => memorize,
        			error : [say('Keep waving your hands'),inc(count,C)] =>  detect
        			%apply(when(If,TrueVal,FalseVal),[C>5,error,detect_gesture])  				
      			]
    		],
    		
    		[  
      		id ==> detect,
      		type ==> recursive,
		    embedded_dm ==> detect_body(nearest,1,Body_Positions,Status),
      		arcs ==> [
        			success : say('Wait a moment, I am memorizing you') =>memorize,
        			error : [say('I did not find a body')] => follow_until_event(Expected_Event)				
      			]
    ],
    [  
      		id ==> memorize,
      		type ==> neutral,
      		arcs ==> [
        			empty : [sleep,sleep,say('I memorized you'),switchpose('nav'),tiltv(-10.0),set(last_tilt,-10.0),say('Perfect, I am following you now.'),say('Wave one hand if you want me to stop.')] => start(continue)%follow_until_event(Expected_Event),
        						
      			]
    ],

		%Continue Mode
		[
      			id ==> start(continue),
      			type ==> neutral,
      			arcs ==> [
        				empty : [switchpose('nav'),avanzar(1.00)] => follow_until_event(Expected_Event)
      				]
    		],
		
		%Follow the person until a gesture is detected
%		[
%      			id ==> follow_until_event(gesture_only),
%      			type ==> following,			
%      			arcs ==> [
%        			gesture : [detener,say('I see you are making a gesture')] => expected_event(gesture),
%				user_lost : [detener,say('Wait a moment. I lost the user')] => internal_recover
%      			]
%    		],
                [  
      			id ==> follow_until_event(gesture_only),
      			type ==> recursive,
			out_arg ==> [_, StatusGesture],
			embedded_dm ==> see_gesture(hand_up, nearest, 3, Gesture_Value, StatusGesture),
      			arcs ==> [
        			success : empty => gesture_confirmation, %expected_event(gesture),
        			error : [sleep] =>  follow_until_event(gesture_only)
        			%error : empty =>  check_follow_status
      			]
    		],
		

		[  
      			id ==> gesture_confirmation,
      			type ==> recursive,
			out_arg ==> [_, StatusGesture],
			embedded_dm ==> see_gesture(hand_up, nearest, 3, Gesture_Value, StatusGesture),
      			arcs ==> [
        			success : [detener,say('I see you are making a gesture'),switchpose('grasp')] => success, %expected_event(gesture),
        			error : [sleep] =>  follow_until_event(gesture_only)
        			%error : empty =>  check_follow_status
      			]
    		],

		[  
      			id ==> check_follow_status,
      			type ==> follow_status,
      			arcs ==> [
        			follow : empty => follow_until_event(gesture_only),
        			stopped : [say('I lost you.')] =>  follow_until_event(gesture_only)
      			]
    		],

		%Follow the person until an event occurs, and compare the expected event with the happened event, using the apply function (which returns
		%expected_event(Happened_Event) or unexpected_event(Happened_Event)
		[
      			id ==> follow_until_event(X),
      			type ==> following,			
      			arcs ==> [
        			gesture : [detener,say('I see you are making a gesture')] => apply(compare_follow_events(E1,E2),[Expected_Event,gesture]),
				oclusion : [detener,say('Somebody is passing between you and me')] => apply(compare_follow_events(E1,E2),[Expected_Event,oclusion]),
				elevator(R1,A1,A2) : [detener,say('I see you are in the door of an elevator')] => apply(compare_follow_events_3(E1,E2,P1,P2,P3),[Expected_Event,elevator,R1,A1,A2]),
				crowd(Xp,Yp,R) : [detener,say('I see you are crossing a crowd')] => apply(compare_follow_events_3(E1,E2,P1,P2,P3),[Expected_Event,crowd,Xp,Yp,R]),				
        			user_lost : [detener,say('Wait a moment. I lost the user')] => internal_recover
      			]
    		],

		[
      			id ==> expected_event(Event),	
      			type ==> neutral,
			out_arg ==> [Event, ok],
      			arcs ==> [
        				empty : empty => success
      				]
    		],

		[
      			id ==> unexpected_event(Event),	
      			type ==> neutral,
			out_arg ==> [Event, unexpected_event],
      			arcs ==> [
        				empty : empty => error
      				]
    		],

		%Internal recover for lost user

		[
      			id ==> internal_recover,
      			type ==> neutral,
      			arcs ==> [
        				empty : empty => recover([message1,message2,message3,message1,message2,message3])		
      				 ]
    		],

		[
      			id ==> recover([]),
      			type ==> neutral,
			out_arg ==> [_, not_detected],
      			arcs ==> [
        				empty : empty => error		
      				 ]
    		],
    		
    		[
      			id ==> recover([Message|Rest]),
      			type ==> following,
      			arcs ==> [
        				user_seen : [avanzar(1.00),say('I see you again. You can start walking again')] => follow_until_event(Expected_Event),
        				user_lost : [say( apply(get_follow_recover_message(M),[Message]) ),sleep,sleep,sleep,sleep,sleep] => recover(Rest)		
      				]
    		],
		
		
		%Continue Mode
		[
      			id ==> start(continue),	
      			type ==> neutral,
      			arcs ==> [
        				empty : say('Keep walking') => success
      				]
    		],

		% Final Situations
		[
			id ==> success, 
			type ==> final,
			in_arg ==> [Event,StatusFollow],
			diag_mod ==> follow(_, _, Event, StatusFollow)
		],

		[
			id ==> error, 
			type ==> final,
			in_arg ==> [Event,StatusFollow],
			diag_mod ==> follow(_, _, Event, StatusFollow)
		]

		
	    ], 

	% List of Local Variables
	[
		count ==> 0
	]

   ). 
