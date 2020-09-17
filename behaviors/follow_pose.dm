diag_mod(follow_pose(StopMode,Status),
	[

		[
      			id ==> is,	
      			type ==> neutral,
      			out_arg ==> [ok],
      			arcs ==> [
        				empty : empty => recognize_and_follow
      				]
    		],
    		
        [
      			id ==> recognize_and_follow,	
      			type ==> recognize_follow,
      			arcs ==> [
        				success : [robotheight(1.40),set(last_height,1.40),switchpose('nav'),say('Now I am following you, please when you reach the car raise your hand making a stop sign'),avanzar(1.0),say('please walk slow')] => check_status,
        				error : [say('I did not see you, can you stand in front of me please')] => recognize_and_follow
      				]
    	],
    	
    	[
      			id ==> check_status,	
      			type ==> follow_status,
      			arcs ==> [
        				follow : [sleep] => check_stop,
        				stopped : [detener] => find 
      				]
    	],
    	
    	
    	[
      			id ==> check_stop,	
      			type ==> see_gesture_op(StopMode),
      			arcs ==> [
        				success : [sleep] => recheck_stop,
        				error : empty => check_status 
      				]
    	],
    	
    	[
      			id ==> recheck_stop,	
      			type ==> see_gesture_op(StopMode),
      			arcs ==> [
        				success : [say('I see the stop gesture'),detener] => success,
        				error : empty => check_status 
      				]
    	],
    	
    	[
      			id ==> find,	
      			type ==> find_follow,
      			arcs ==> [
        				success : [robotheight(1.30),set(last_height,1.30),switchpose('nav'),say('I found you, Now I am following you'),avanzar(1.0),sleep] => check_status,
        				error : [say('I did not see you, can you stand in front of me please')] => find,
        				crowd: [say('I see too many people, please disperse')] => find
      				]
    	],
    	 
    		
    		% Final Situations
		[
			id ==> success, 
			type ==> final,
			in_arg ==> [StatusFollow],
			diag_mod ==> follow_pose(_,StatusFollow)
		],

		[
			id ==> error, 
			type ==> final,
			in_arg ==> [StatusFollow],
			diag_mod ==> follow_pose(_,StatusFollow)
		]
	],
		
	[]
).
