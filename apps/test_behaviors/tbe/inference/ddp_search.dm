diag_mod(ddp_search(Object),
[

     [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    %empty : [tiltv(-30.0),set(last_tilt,-30.0),say(['I will search the',Object])] => see_shelf
                    empty : [tiltv(-30.0),set(last_tilt,-30.0)] => see_shelf
                    ]
     ], 
     
     [  
      		id ==> see_shelf,
      		type ==> recursive,
	        embedded_dm ==> see_object([Object],object,Found_Objects,_),
       		arcs ==> [
        			success : [tiltv(0.0),set(last_tilt,0.0),mood(feliz),say('Here is the object'),tiltv(-30.0),set(last_tilt,-30.0)] => success,
        			error :   [tiltv(0.0),set(last_tilt,0.0),mood(triste),say(['I do not see the',Object]),tiltv(-30.0),set(last_tilt,-30.0)] => error
      			]
     ],
           
     [
            id ==> success,
            type ==> final
     ],
     
     [
            id ==> error,
            type ==> final
     ]
     
  ],

  % Second argument: list of local variables
  [
  
  ]

).	
