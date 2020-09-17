diag_mod(memorize_face_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will memorize a face'),sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep,sleep] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		embedded_dm ==> memorize_face(coord3(0.18,0.16,1.18),arturo,Status),
      		arcs ==> [
        			success : [say('I memorize the user')] => fs,
        			error : [say('I did not find the user')] => fs
				
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

