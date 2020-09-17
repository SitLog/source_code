diag_mod(deliver_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        %empty : [apply(initialize_KB,[]),say('Hello I am Golem and I will take an deliver objects'),tiltv(-30.0),set(last_tilt,-30.0),tilth(0.0),set(last_scan,0.0),robotheight(1.20),set(last_height,1.20)] => behavior
        empty : empty => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		    embedded_dm ==> see_object([kellogs],object,[FirstObject|Rest],Status),
      		arcs ==> [
        			success : [say('I found something')] => behavior2(FirstObject),
        			error : [say('I did not find objects')] => fs
				
      			]
    ],
    
    [  
      		id ==> behavior2(Object),
      		type ==> recursive,
      		%embedded_dm ==> take(Object, left, ObjTaken, Status),
      		embedded_dm ==> take(Object, right, ObjTaken, Status),
      		arcs ==> [
        			success : [say('I took it')] => behavior3(Object),
        			error : [say('I do not take it')] => fs				
      			]
    ],
    
 
    [  
      		id ==> behavior3(Object),
      		type ==> recursive,
      		%embedded_dm ==> deliver(kellogs, turn=>90.0, handle, Status),
      		embedded_dm ==> deliver(kellogs, shelf_snacks, shelf_snacks, put, Status),
      		arcs ==> [
        			success : [say('I deliver it')] => fs,
        			error : [say('I did not deliver it')] => fs				
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

