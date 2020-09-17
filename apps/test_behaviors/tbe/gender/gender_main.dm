diag_mod(gender_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [tiltv(-10.0), set(last_tilt, -10.0), tilth(0.0), set(last_scan, 0.0), say('I will detect your gender')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,  
      		embedded_dm ==> gender(Genero,_),
		arcs ==> [
        			success : [say(['Got it, you are a ', Genero]), say('I finished')] =>fs,
        			error : [say('I am sorry')] => fs
				
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

