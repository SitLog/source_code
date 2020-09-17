diag_mod(scan_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [say('Hello I am Golem and I will search something using scans')
		] => behavior
      ]
    ],
    
    [  
      		id ==> behavior,
      		type ==> recursive,
      		%embedded_dm ==> scan(person, _, [-20.0,0.0,20.0], [0.0,-15.0,-30.0], detect_body, Found_Persons, false, false, Status),
      		%embedded_dm ==> scan(person, james, [-20.0,0.0,20.0], [-15.0,-30.0], memorize_body, Found_Persons, false, false, Status),
      		%embedded_dm ==> scan(person, X, [-20.0,0.0,20.0], [-15.0,-30.0], recognize_body, Found_Persons, false, false, Status),
      		   		
      		%embedded_dm ==> scan(object, X, [0.0], [-30.0], object, [object(N,N1,N2,N3,N4,N5,N7,N8,N9)|More], false, false, Status),
      		embedded_dm ==> scan(object, X, [0.0], [-30.0], object, FoundObjs, false, false, Status),
		    %embedded_dm ==> scan(gesture, pointing, [-20,20], [-30,0,30], 15, Found_Objects, false, false, Status),
      		arcs ==> [
        			success : [say('I found it')] => fs,
        			error : [say('Is not here')] => fs
				
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

