diag_mod(approach_person_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will approach to a person')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		embedded_dm ==> approach_person(body,Final_Position,Status),
      		%embedded_dm ==> approach_person(coord(0.261225,2.359,0.128762),X,Status),
      		%embedded_dm ==> approach_person(coord3(0.261225,-0.959,0.128762),X,Status),
      		arcs ==> [
        			success : [say('I am near to the person')] => fs,
        			error : [say('I lost the person')] => fs
				
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

