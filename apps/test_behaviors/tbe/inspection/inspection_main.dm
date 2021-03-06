% GPSR Main Dialogue Model
diag_mod(inspection_main, 
[

       	[
      		id ==> is,	
      		type ==> neutral,
      		arcs ==> [
        		empty : [
				tiltv(-10.0),set(last_tilt,-10.0),
				tilth(0.0),set(last_scan,0.0),
			        robotheight(1.35),set(last_height,1.35),
				apply(initialize_KB,[]),
				%apply(initialize_parser,[]),
				say('Open the door please')] 
				% => add_to_kb_actual_position
                                => detect_door
      			]
    	],
    	
    	[  
      		id ==> detect_door,
      		type ==> recursive,
      		embedded_dm ==> detect_door(Status),
      		arcs ==> [
        			success : empty => move_waiting_pos,
        			error : empty => detect_door				
      			]
        ],
        
        
        [  
      		id ==> move_waiting_pos,
      		type ==> recursive,
			embedded_dm ==> move(inspection_point,Status),
		  		arcs ==> [
        			success : say('Hello my name is golem three and I will wait for the inspection.') => wait_continue,
        			error : empty => move_waiting_pos
			]
        ],
    	
    	
    	[
    		id ==> wait_continue,
      		type ==> recursive,
      		embedded_dm ==> ask('Tell me wake up after the beep when you want me to exit.',wakeup,true,100,Order,Status),
      		arcs ==> [
        			success : say('Going to exit now.') => move_exit,
        			error : empty => wait_continue				
      			    ]
    	],
    	
    	
    	

        [  
      		id ==> move_exit,
      		type ==> recursive,
			embedded_dm ==> move(exit,Status),
		  		arcs ==> [
        			success : say('Reached exit. Inspection done.') => fs,
        			error : empty => move_exit
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
