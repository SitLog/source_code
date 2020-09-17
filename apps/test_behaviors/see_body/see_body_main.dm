diag_mod(see_body_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello my name is Golem and I will see a body in front of me'),apply(initialize_KB,[])] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		    %embedded_dm ==> see_body(detect,_,nearest,5,Body_Position,Status),
		    %embedded_dm ==> see_body(memorize,james,nearest,10,Body_Position,Status),
		    %embedded_dm ==> see_body(recognize,X,nearest,10,Body_Position,Status),
		    embedded_dm ==> see_body(recognize,james,nearest,10,Body_Position,Status),
      		arcs ==> [
        			success : [say('I see a body')] => fs,
        			error : [say('I did not see a body')] => fs				
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

