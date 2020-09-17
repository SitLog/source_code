diag_mod(follow_with_clothes_main,
[

    [  
      		id ==> is,
      		type ==> neutral,
      		arcs ==> [
        			%empty : start_gmapping => start
				    empty : empty => start
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
		                        say('Please stand in front of me two meters away showing me your back. Put your hands up and wave them to memorize you')		                        
		                    ] => detect_gesture
                    ]
    ],
    
    [  
      		id ==> detect_gesture,
      		type ==> recursive,
   		    embedded_dm ==> see_gesture(waving,nearest,5,Body_Positions,Status),
		    arcs ==> [
        			success : [say('Keep waving your hands')] => memorize1,
        			error : [say('Put your hands up and wave them')] => detect_gesture			
      			]
    ],
    
    [  
      		id ==> memorize1,
      		type ==> recursive,
		    embedded_dm ==> find(person, james, [turn=>(0.0),turn=>(10.0),turn=>(-5.0)], [0.0,-20.0,20.0], [-40.0,-20.0], memorize_body, Found_Persons, Remaining_Positions, false, false, false, Status),
      		arcs ==> [
        			success : [say('Ready. I memorized you')] => search([displace=>(0.1),displace=>(0.1),displace=>(0.1)]), 
        			error : [say('I could not memorize you. Wave your hands. I will try again')] => memorize1			
      			]
    ],
    
    [  
      		id ==> search(SearchingSpots),
      		type ==> recursive,
		    embedded_dm ==> find(person, james, SearchingSpots, [0.0], [-30.0,-20.0], recognize_body, Found_Persons, Remaining_Positions, false, false, false, Status),
      		arcs ==> [
        			success : [say('Now I will follow')] => approach,
        			error : [say('Wait a moment')] => search([displace=>(0.1),displace=>(0.1),displace=>(0.1)])		
      			]
    ],
    
 	[  
      		 id ==> approach,
      		 type ==> recursive,
		     embedded_dm ==> approach_person_with_clothes_verification(body,Body_Position,Detect_Status),
      		 arcs ==> [
        			    success:empty => point,
        			    error: empty => point				
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

