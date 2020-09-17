diag_mod(follow_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [initSpeech,say('Hello I am Golem and I will follow a person')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		%embedded_dm ==> follow(learn,crowd,Happened_Event,Status),
      		%embedded_dm ==> follow(continue,Expected_Event,Happened_Event,Status),
      		embedded_dm ==> follow(learn,gesture_only,Happened_Event,Status),
      		arcs ==> [
        			%success : [say('I finish. Put your hands down. I will follow you again')] => behavior2,
        			success : [say('I finish.')] => fs,
        			error : [say('Something is wrong')] => fs				
      			]
    ],
    
     [  
      		id ==> behavior2,
      		type ==> recursive,
      		%embedded_dm ==> follow(learn,gesture,Happened_Event,Status),
      		%embedded_dm ==> follow(continue,Expected_Event,Happened_Event,Status),
      		embedded_dm ==> follow(continue,gesture_only,Happened_Event,Status),
      		arcs ==> [
        			success : [say('I finish')] => fs,
        			error : [say('Something is wrong')] => fs				
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

