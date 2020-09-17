diag_mod(detect_face_cognitive_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will detect a face')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> neutral,
      		embedded_dm ==> detect_face_cognitive(detect),
      		arcs ==> [
        			success : [say('I see a face')] => fs,
        			error : [say('I do not see a face')] => fs				
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

