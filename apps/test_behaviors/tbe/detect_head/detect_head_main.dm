diag_mod(detect_head_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will see a head')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
			embedded_dm ==> detect_head(X,Status),
      		arcs ==> [
        			success : [say('I detected a head')] => fs,
        			error : [say('I did not detect a head')] => fs
				
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

