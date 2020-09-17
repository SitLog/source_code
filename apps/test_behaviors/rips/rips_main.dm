% GPSR Main Dialogue Model
diag_mod(rips_main, 
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
				apply(initialize_parser,[]),
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
			embedded_dm ==> move(rips_wait,Status),
		  		arcs ==> [
        			success : say('Reached waiting position. Tell me wake up after the beep when you want me to exit.') => wait_continue,
        			error : empty => move_waiting_pos
			]
        ],
    	
       

	%The actual position is stored as the 'waiting position'in the kb
	[
		 id ==> wait_continue,
		 type ==> listening(wakeup),
		 arcs ==> [
                    said(wakeup): say('Going to exit now.') => move_exit,
                    said(nothing): empty =>	wait_continue
		          ]
    ],

        [  
      		id ==> move_exit,
      		type ==> recursive,
			embedded_dm ==> move(exit,Status),
		  		arcs ==> [
        			success : say('Reached exit. RIPS done.') => fs,
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
