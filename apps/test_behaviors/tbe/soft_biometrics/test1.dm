diag_mod(test1,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [ apply(initialize_KB,[]),
                  tiltv(-25.0),set(last_tilt,-25.0),
				  robotheight(1.38),set(last_height,1.38),
		          say('Hello, my name is Golem and I will show you how I can identify people by their clothes. Please stand in front of me'),
		          tilth(0.0),set(last_scan,0.0)
		        ] => memorize1
      ]
    ],
      
    [  
      		id ==> memorize1,
      		type ==> recursive,
		    embedded_dm ==> memorize_body(nearest,5,first,Body_Positions,Status),
      		arcs ==> [
        			success : [say('Ready. Now I will learn the second person. Please, stand in front of me')] => memorize2,
        			error : [say('I could not memorize the person. Stand in front of me please')] => memorize1			
      			]
    ],
    
    [  
      		id ==> memorize2,
      		type ==> recursive,
		    embedded_dm ==> memorize_body(nearest,5,second,Body_Positions,Status),
      		arcs ==> [
        			success : [say('Ready. Now I will recognize a person. Please, stand in front of me')] => recognize1,
        			error : [say('I could not memorize the person. Stand in front of me please')] => memorize2		
      			]
    ],
    
    [  
      		id ==> recognize1,
      		type ==> recursive,
		    embedded_dm ==> recognize_body(nearest,5,X,Body_Positions,Status),
      		arcs ==> [
        			success : empty => say1(X),
        			error : [say('I did not recognize the person')] => recognize1				
      			]
    ],
    
    [  
      		id ==> say1(X),
      		type ==> recursive,
			embedded_dm ==> say(['Hello. You are the',X,'person I saw. I will recognize other person'],Status),
      		arcs ==> [
        			success : empty => recognize2,
        			error : [say('Something is wrong')] => error				
      			]
    ],
    
    [  
      		id ==> recognize2,
      		type ==> recursive,
		    embedded_dm ==> recognize_body(nearest,5,X,Body_Positions,Status),
      		arcs ==> [
        			success : empty => say2(X),
        			error : [say('I did not recognize the person')] => recognize2				
      			]
    ],
    
    [  
      		id ==> say2(X),
      		type ==> recursive,
			embedded_dm ==> say(['Hello. You are the',X,'person I saw. Good bye'],Status),
      		arcs ==> [
        			success : empty => success,
        			error : [say('Something is wrong')] => error				
      			]
    ],
       
    [
      id ==> success,
      type ==> final
    ],
    
    [
      id ==> error,
      type ==> final
    ]
    
  ],

  % Second argument: list of local variables
  [
  ]

).	

