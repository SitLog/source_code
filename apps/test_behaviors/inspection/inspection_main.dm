diag_mod(inspection_main, 
[

       	[
      		id ==> is,	
      		type ==> neutral,
      		arcs ==> [
        		empty : [
				tiltv(-10.0),set(last_tilt,-10.0),
				tilth(0.0),set(last_scan,0.0)
			        %robotheight(1.35),set(last_height,1.35)
				]
                                => interrupt_speech
      			]
    	],
    	
    	[  
      		id ==> interrupt_speech,
      		type ==> recursive,
      		embedded_dm ==> interrupting_speech(speech_location, Status),
      		arcs ==> [
        			success : empty => move_exit,
        			error : empty => interrupt_speech				
      			]
        ],
        

        [  
      		id ==> move_exit,
      		type ==> recursive,
			embedded_dm ==> move(exit,Status),
		  		arcs ==> [
        			success : empty => fs,
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
