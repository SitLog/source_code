% Guide Dialogue Model
%
% 	Description	The robot guides a person whom is located at specific place to another specific place
%
%	Arguments	
%			Person: The name of the person to lead
%			Place: Place where the person is guided. Can be specified as
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

diag_mod(find_and_say(Person,Location,Instruction,Status),
[		
		[  
      			id ==> is,
      			type ==> neutral,
			arcs ==> [
        			empty : empty => type_instruction(Instruction)
        							
      			]
    		],
		[  
      			id ==> type_instruction(ask_to_leave),
      			type ==> recursive,
      			embedded_dm ==> move(Location,Status),
			arcs ==> [
        			success : [say(['Hello', Person, 'could you leave the house please'])] => confirm,
        			error: [say('I cannot reach the person location')] => type_instruction2(ask_to_leave)				
      			]
    		],
    		[
	 		id ==> confirm,
	 		type ==> listening(yesno),
	 		arcs ==> [
	                	said(yes): [say('Perfect')] => success,
	                	said(no): empty => type_instruction(ask_to_leave),
	                	said(nothing): empty => confirm
		  	]
    		],
    		[  
      			id ==> type_instruction2(ask_to_leave),
      			type ==> recursive,
      			embedded_dm ==> move(Location,Status),
			arcs ==> [
        			success : [say(['Hello', Person, 'could you leave the house please'])] => confirm,
        			error: [say('I cannot reach the person location')] => error				
      			]
    		],
	    		
		

  	        [
		 id ==> success, 
		 type ==> final,
		 diag_mod ==> find_and_say(_,_,_,ok)
		],

		[
                 id ==> error, 
		 type ==> final,
		 diag_mod ==> find_and_say(_,_,_,error)
		]

  ],
  % Second argument: list of local variables
  [
  ]
).


