diag_mod(point_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [initSpeech,say('Hello I am Golem and I will point something') 
                ] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		   % embedded_dm ==> point(right, Status),
		   % embedded_dm ==> point(left, Status),
		    embedded_dm ==> point_arg(30.0,0.5, right, Status),
		arcs ==> [
        			success : [say('I pointed it')] => fs,
        			error : [say('I did not point it')] => fs
				
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
