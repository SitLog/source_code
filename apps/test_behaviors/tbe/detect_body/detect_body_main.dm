diag_mod(detect_body_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will see a body')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		    embedded_dm ==> detect_body(nearest,5,Body_Positions,Status),
      		arcs ==> [
        			success : [say('I found a body')] => fs,
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

