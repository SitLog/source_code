% Guide Dialogue Model
%
% 	Description	The robot guides a person to a specific place
%
%	Arguments	Place: Place where the person is guided. Can be specified as
%				A single coordinate [x,y,r] , where x and y are in meters and r is in grades
%				A single label corresponding to a coordinate point in the knowledge base 
%				A single instruction of the form type=>(value) where type corresponds to the kind of movement, and can be 'displace', 'turn', %				'displace_precise' or 'turn_precise' and the value is the magnitud of the movement (in meters for advance, in grades for %				turn).		   
%				A list of coordinates [ [x_1,y_1,r_1] , [x_2,y_2,r_2] , ... , [x_n,y_n,r_n] ] 
%				A list of labels [ label_1, label_2 , ... , label_n ]
%				A list of instructions [type_1=>(value_1), type_2=>(value_2), ..., type_n=>(value_n)]
%				Coordinates and labels corresponds to absolut movements (where the origin corresponds to the topological map)
%				Instructions corresponds to relative movements (where the origin corresponds to the actual position of the robot)
%	
%			Status:	
%				ok .- if the robot completes successfully the sequence of movements
%			       	navigation_error .- otherwise

diag_mod(guide(Place,Status),
[
    
		[  
      			id ==> is,
      			type ==> neutral,
			arcs ==> [
        			empty : [say('Please, Follow Me')] => move				
      			]
    		],
	    		
		[  
      			id ==> move,
      			type ==> recursive,
			embedded_dm ==> move(Place,Status),
	      		arcs ==> [
        			success : [say('We arrived')] => success,
        			error : [say('I could not arrive')] => error				
      			]
    		],

  	        [
		 id ==> success, 
		 type ==> final,
		 diag_mod ==> guide(_, ok)
		],

		[
                 id ==> error, 
		 type ==> final,
		 diag_mod ==> guide(_, navigation_error)
		]

  ],
  % Second argument: list of local variables
  [
  ]
).


