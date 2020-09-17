diag_mod(move_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
        empty : [
		        %say('Hello I am Golem and I will perform a sequence of movements'),apply(initialize_KB,[])
		        say('hi'),apply(initialize_KB,[])
        	] => behavior
      ]
    ],
    
    [  
      		id ==> move_origin,
      		type ==> recursive,
			embedded_dm ==> move([0.01,0.01,0.01],Status),
		  		arcs ==> [
        			success : empty => fs,
        			error : empty => fs
			]
    ],
    [  
      		id ==> behavior,
      		type ==> recursive,
		%embedded_dm ==> move([],Status),
		embedded_dm ==> move([0.0,0.0,0.0],Status),
		%embedded_dm ==> move([0.0,0.0,0.0],Status),		
		%embedded_dm ==> move([[0.0,0.0,0.0],[1.0,0.0,45.0],[0.0,0.5,45.0]],Status),
		%embedded_dm ==> move(living,Status),
		%embedded_dm ==> move([table],Status),
		%embedded_dm ==> move(point1,Status),
		%embedded_dm ==> move([bookcase,sideboard],Status),
		%embedded_dm ==> move(displace=>(0.50),Status),
		%embedded_dm ==> move(displace_precise=>0.24419999999999994,Status),
		%embedded_dm ==> move(turn=>(90.0),Status),
		%embedded_dm ==> move(turn_precise=>0.0,Status),
		%embedded_dm ==> move([turn_precise=>(-45.0),turn_precise=>(45.0)],Status),
		%embedded_dm ==> move([displace=>(0.32),turn=>(-36.0),displace=>(0.20)],Status),
		%embedded_dm ==> move([turn=>(-56.0),displace=>(0.25),turn=>(62.0)],Status),
		%embedded_dm ==> move([displace=>(1.10),turn=>(-90),turn=>(45),displace=>(0.54)],Status),
		%embedded_dm ==> move([displace_precise=>(0.25),displace=>(0.25),turn_precise=>(90.0),turn=>(-90.0)],Status),
		%embedded_dm ==> move([face_towards=>shelf],Status),
      		arcs ==> [
        			%success : [ say('I finish my movements')] => fs,
        			success : [ say('yes')] => fs,
        			error : [say('I could not finish')] => fs
				
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

