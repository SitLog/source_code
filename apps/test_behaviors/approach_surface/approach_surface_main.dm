diag_mod(approach_surface_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [initSpeech,say('Hello I am Golem and I will detect a face'),execute('scripts/personvisual.sh')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		embedded_dm ==> detect_face(Status),
      		arcs ==> [
        			success : [say('I see a face'),execute('scripts/killvisual.sh')] => fs,
        			error : [say('I do not see a face'),execute('scripts/killvisual.sh')] => fs
				
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

