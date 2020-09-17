diag_mod(approach_object_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will approach to an object'),tiltv(-30.0),set(last_tilt,-30.0),tilth(0.0),set(last_scan,0.0),robotheight(1.20),set(last_height,1.20)] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
    		embedded_dm ==> see_object(X,object,[FirstObject|Rest],Status),
      		arcs ==> [
        			success : [say('I found something')] => behavior2(FirstObject),
        			error : [say('I did not find objects')] => fs
				
      			]
    ],
    
    [  
      		id ==> behavior2(Object),
      		type ==> recursive,
      		embedded_dm ==> approach_object(Object, Out_Parameters, Status),
      		arcs ==> [
        			success : [say('I am near of it')] => fs,
        			error : [say('I could not approach to the object')] => fs				
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
