diag_mod(recognize_body_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [
                %tiltv(-40.0),set(last_tilt,-40.0),
				%tilth(0.0),set(last_scan,0.0),
		        %robotheight(1.42),set(last_height,1.42),
		        say('Hello I am Golem and I will recognize a person'),apply(initialize_KB,[])] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		    %embedded_dm ==> recognize_body(nearest,3,linda,Body_Positions,Status),
		    embedded_dm ==> recognize_body(nearest,1,X,Body_Positions,Status),
      		arcs ==> [
        			success : [say('I recognize a person')] => fs,
        			error : [say('I did not recognize the person')] => fs				
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

