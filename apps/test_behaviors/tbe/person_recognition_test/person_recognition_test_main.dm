diag_mod(person_recognition_test_main,
[

    [  
      		id ==> is,
      		type ==> neutral,
      		arcs ==> [
        			%empty : start_gmapping => move
				    empty : empty => move
      			]
    ],

    [  
      		id ==> detect_door,
      		type ==> recursive,
      		embedded_dm ==> detect_door(Status),
      		arcs ==> [
        			success : empty => move,
        			error : empty => error
				
      			]
    ],

    [  
      		id ==> move,
      		type ==> recursive,
  		    embedded_dm ==> move([displace=>(0.1),turn=>(1.0)],Status),
			arcs ==> [
        			success : empty => start,
        			error : empty => start
      			]
    ],
    
    [
            id ==> start,
            type ==> neutral,
            arcs ==> [
                    empty : [   apply(initialize_KB,[]),
                                tiltv(-10.0),set(last_tilt,-10.0),
				                tilth(0.0),set(last_scan,0.0),
		                        robotheight(1.38),set(last_height,1.38),
		                        say('Hello, my name is Golem. Please stand in front of me two meters away')		                        
		                    ] => memorize1
                    ]
    ],
    
    [  
      		id ==> detect_gesture,
      		type ==> recursive,
   		    embedded_dm ==> see_gesture(waving,nearest,10,Body_Positions,Status),
		    arcs ==> [
        			success : [say('I see you.  Now I will memorize you. Keep waving your hands')] => memorize1,
        			error : [say('Put your hands up higher and wave them')] => detect_gesture			
      			]
    ],
    
    [  
      		id ==> memorize1,
      		type ==> recursive,
		    embedded_dm ==> find(person, james, [turn=>(0.0),turn=>(10.0),turn=>(-5.0)], [0.0,-20.0,20.0], [-22.0,-20.0], memorize_body, Found_Persons, Remaining_Positions, false, false, false, Status),
      		arcs ==> [
        			success : [say('Ready. Now you can hide in the crowd')] => wait, 
        			error : [say('You are very near. Step back one feet. Wave your hands.')] => memorize1			
      			]
    ],
    
    [  
      		id ==> wait,
      		type ==> neutral,
      	    arcs ==> [
        			empty : [sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep] => turn			
      			]
    ],
    
    [  
      		id ==> turn,
      		type ==> recursive,
  		    embedded_dm ==> move([displace=>(0.4),turn=>(179.0)],Status),
			arcs ==> [
        			success : empty => search([displace=>(0.1),turn=>(20.0),turn=>(-40.0),turn=>(-10.0),turn=>(40.0),turn=>(20.0),turn=>(-15.0),turn=>(-30.0),turn=>(20.0),turn=>(-10.0),turn=>(-30.0),turn=>(90.0),turn=>(30.0),turn=>(30.0),turn=>(30.0),turn=>(-120.0),turn=>(-30.0),turn=>(-30.0),turn=>(90.0),turn=>(30.0),turn=>(30.0),turn=>(30.0),turn=>(-120.0),turn=>(-30.0),turn=>(-30.0)]),
        			error : empty => turn
      			]
    ],
    
    [  
      		id ==> search(SearchingSpots),
      		type ==> recursive,
		    embedded_dm ==> find(person, james, SearchingSpots, [0.0], [-30.0,-20.0], recognize_body, Found_Persons, Remaining_Positions, false, false, false, Status),
      		arcs ==> [
        			success : [say('Ready. I found you. I will point to you')] => approach,
        			error : [say('I could not arrive to that point')] => search(Remaining_Positions)		
      			]
    ],
    
       
    [  
      		id ==> approach,
      		type ==> recursive,
      		embedded_dm ==> see_person(_, detect_body_with_approach, Position, Status),      		      		
      		arcs ==> [
        			success : empty => point,
        			error : empty => point				
      		]
    ],
        
    [  
      		id ==> point,
      		type ==> recursive,
      		embedded_dm ==> point(right, Status),
      		arcs ==> [
        			success : empty => say_pose,
        			error : empty => error				
      			]
    ],
    
    [  
      		id ==> say_pose,
      		type ==> recursive,
		    embedded_dm ==> see_gesture(hand_up,nearest,1,Body_Positions,Status),
      		arcs ==> [
        			success : [say('You are raising one of your hands')] => say_pose2,
        			error : empty => say_pose2				
      			]
    ],
    
    [  
      		id ==> say_pose2,
      		type ==> recursive,
		    embedded_dm ==> see_gesture(waving,nearest,1,Body_Positions,Status),
      		arcs ==> [
        			success : [say('You are waving your hands')] => say_pose3,
        			error : empty => say_pose3				
      			]
    ],
    
     [  
      		id ==> say_pose3,
      		type ==> recursive,
		    embedded_dm ==> see_gesture(sitting,nearest,1,Body_Positions,Status),
      		arcs ==> [
        			success : [say('You are sitting')] => fs,
        			error : [say('You are stand up')] => fs				
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

