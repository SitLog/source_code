diag_mod(recognize_face_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will recognize a face')] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		embedded_dm ==> recognize_face(coord3(0.18,0.16,1.18),X,Status),
		    %embedded_dm ==> recognize_face(X,Status),
      		arcs ==> [
        			success : [say('I found '), say(X)] => fs,
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

