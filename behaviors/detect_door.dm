% Detect Door Dialogue Model
%
% 	Description	The robot detects a door in its current field of view
%
%	Arguments	Status:	
%				ok .- when the door is open
%			       	error .- otherwise

diag_mod(detect_door(Status),
  [
    
    		[
      		 id ==> wait,	
     		 type ==> waiting_door,
     		 arcs ==> [
      		  	error : empty => wait,
      		  	closed : empty => wait,
     		   	open : empty => success
      			]
   		],

  	        [
		 id ==> success, 
		 type ==> final,
		 diag_mod ==> detect_door(ok)
		],

		[
                 id ==> error, 
		 type ==> final,
		 diag_mod ==> detect_door(error)
		]

  ],
  % Second argument: list of local variables
  [
  ]
).


















