diag_mod(tilt_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will see something using tilts')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		%embedded_dm ==> tilt(person,_,[30.0,20.0,10.0,0.0,-10.0,-20.0,-30.0], detect_body, Found_Persons, true, Status),
      		%embedded_dm ==> tilt(person,james,[-10.0,-20.0,-30.0], memorize_body, Found_Persons, true, Status),
      		embedded_dm ==> tilt(person,X,[-10.0,-20.0,-30.0], recognize_body, Found_Persons, true, Status),
      		
		    %embedded_dm ==> tilt(object,X,[30.0,20.0,10.0,0.0,-10.0,-20.0,-30.0], object, Found_Objects, true, Status),
      		%embedded_dm ==> tilt(person,X,[90,0,-90], memorize, Found_Objects, true, Status),
		    %embedded_dm ==> tilt(gesture,waving,[90,0,-90], 15, Found_Objects, false, Status),
      		arcs ==> [
        			success : [say('I found it')] => fs,
        			error : [say('Is not here')] => fs				
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

