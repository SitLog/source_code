diag_mod(see_face_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will see a face')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		%embedded_dm ==> see_face(_, detect, Position, Status),
      		%embedded_dm ==> see_face(antonio, memorize, Position, Status),
      		embedded_dm ==> see_face(X, recognize, Position, Status),
      		arcs ==> [
        			success : [say('I finish')] => fs,
        			error : [say('There is something wrong')] => fs
				
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

