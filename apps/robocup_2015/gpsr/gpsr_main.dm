% GPSR Main Dialogue Model
diag_mod(gpsr_main, 
[

    	[
      		id ==> is,	
      		type ==> neutral,
      		arcs ==> [
        		empty : [
				%tiltv(0),set(last_tilt,0),
				%tilth(0),set(last_scan,0),
				apply(initialize_KB,[]),
				say('Hello I am Golem, and I will wait here')] 
				% => add_to_kb_actual_position
                                => solve
      			]
    	],

	%The actual position is stored as the 'waiting position'in the kb
	[
 		id ==> add_to_kb_actual_position,
		type ==> positionxyz,
		arcs ==> [
		  		pos(X,Y,Z): apply(register_waiting_position(Xpos,Ypos,Zpos),[X,Y,Z]) => solve
		    	]
	],

	[  
      		id ==> solve,
      		type ==> recursive,
      		embedded_dm ==> gpsr_solve_command,
      		arcs ==> [
        			success : empty => fs,
        			error : empty => fs
				
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
