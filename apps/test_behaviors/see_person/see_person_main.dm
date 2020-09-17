diag_mod(see_person_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will see a person')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		%embedded_dm ==> see_person(_, detect_body, Position, Status),
      		%embedded_dm ==> see_person(james, memorize_body, Position, Status),
      		%embedded_dm ==> see_person(X, recognize_body, Position, Status),
      		embedded_dm ==> see_person(_, detect_body_with_approach, Position, Status),
      		%embedded_dm ==> see_person(james, memorize_body_with_approach, Position, Status),
      		%embedded_dm ==> see_person(james, recognize_body_with_approach, Position, Status),
      		%embedded_dm ==> see_person(_, detect_face, Position, Status),
      		%embedded_dm ==> see_person(antonio, memorize_face, Position, Status),
      		%embedded_dm ==> see_person(X, recognize_face, Position, Status),
      		      		
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

