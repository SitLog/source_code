
diag_mod(take_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will take an object'),tiltv(-30.0),set(last_tilt,-30.0),tilth(0.0),set(last_scan,0.0),
		robotheight(1.25),set(last_height,1.25)] => behavior
      ]
    ],
    
    
    [  
      		id ==> mv,
      		type ==> recursive,
		embedded_dm ==>  move(table,_),
      		arcs ==> [
        			success : empty => behavior,
        			error : empty => fs
				
      			]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		    embedded_dm ==>  see_object(X,object,[FirstObject|More], St),
      		arcs ==> [
        			success : [say('I found something')] => behavior2(FirstObject),
        			error : [say('I did not find objects')] => fs
				
      			]
    ],
    
    [  
      		id ==> behavior2(Object),
      		type ==> recursive,
      		embedded_dm ==> take(Object, left, ObjTaken, Status),
      		%embedded_dm ==> take(Object, right, ObjTaken, Status),
      		arcs ==> [
        			success : [advance_fine(-0.15, Res), say('I took it')] => fs,
        			error : [advance_fine(-0.15, Res), say('I do not take it')] => fs				
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

