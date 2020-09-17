diag_mod(see_gesture_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will detect a gesture')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		    %embedded_dm ==> see_gesture(waving,nearest,5,Body_Positions,Status),
		    %embedded_dm ==> see_gesture(pointing,nearest,5,Body_Positions,Status),
		    %embedded_dm ==> see_gesture(hand_up,nearest,5,Body_Positions,Status),
		    embedded_dm ==> see_gesture(sitting,nearest,5,Body_Positions,Status),
		    %embedded_dm ==> see_gesture(X,nearest,5,Body_Positions,Status),
      		arcs ==> [
        			success : [say('I found a gesture')] => fs,
        			error : [say('I did not find a body')] => fs				
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


