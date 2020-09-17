diag_mod(see_object_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will see an object'),
                 apply(initialize_KB,[]),
                 tiltv(-30.0),set(last_tilt,-30.0)] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
	        embedded_dm ==> see_object(X,object,[object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|_],Status),
      		%embedded_dm ==> see_object(drink,category,Found_Objects,Status),
		    %embedded_dm ==> see_object([coke],object,Found_Objects,Status),
		    %embedded_dm ==> see_object([coke,bottle],object,Found_Objects,Status),
      		arcs ==> [
        			success : [say('I found something'),
        			           get(last_tilt, LastTilt), 
       		                           cam2nav([X,Y,Z],[LastTilt,0.1,-0.06], Polar_Coord)
       		                          ] => fs,
        			error : [say('I did not find objects')] => fs
        			%success : empty => test_graspable(Found_Objects),
        			%error : empty => fs
				
      			]
    ],
    
    [  
      		id ==> test_graspable([object(Name,X,Y,Z,Q1,Q2,Q3,Q4,Score)|Rest]),
      		type ==> neutral,
      		arcs ==> [
        			empty : empty => apply(is_graspable(A),[[Q1,Q2,Q3,Q4]])
      			]
    ],
    
    [  
      		id ==> graspable,
      		type ==> neutral,
      		arcs ==> [
        			empty : screen('Graspable') => fs
      			]
    ],

    [  
      		id ==> not_graspable,
      		type ==> neutral,
      		arcs ==> [
        			empty : screen('NOT Graspable') => fs
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

