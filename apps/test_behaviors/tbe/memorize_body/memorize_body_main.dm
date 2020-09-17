diag_mod(memorize_body_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [
                %tiltv(-40.0),set(last_tilt,-40.0),
				%tilth(0.0),set(last_scan,0.0),
		        %robotheight(1.42),set(last_height,1.42),
		        say('Hello I am Golem and I will memorize a person'),apply(initialize_KB,[])] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		    embedded_dm ==> memorize_body(nearest,2,michael,Body_Positions,Status),
      		arcs ==> [
        			success : [say('I memorize a person')] => fs,
        			error : [say('I did not memorize the person')] => fs				
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

