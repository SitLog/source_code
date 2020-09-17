diag_mod(guide_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ initSpeech,say('Hello I am Golem and I will guide you to a place'),apply(initialize_KB,[]) ] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
		embedded_dm ==> guide(p1,Status),
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

