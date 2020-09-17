% Detect Head Task Dialogue Model
%
% 	Description	The robot detects a head in its current field of view
%	
%	Arguments	Head_position: A list [h_1,h_2,...,h_n] where each h_i is a functor coord3(x,z,y) with the cartesian coordinate
%           of the detected head (in meters) arranged from the nearest to the farthest			
%	
%			Status:	
%				ok .- if a head is detected
%			    not_detected .- otherwise

diag_mod(detect_head(Head_position,Status), 
	    
	    [
		% Detect head
		[
		 id ==> detect,
		 type ==> detect_head,

		 arcs ==> [		
					heads(X) : empty => check_status(ok,X),
					status(Status) : empty => check_status(Status)
			  ]
		 ],

		% Check status detect
		[
		 id ==> check_status(ok,[coord3(X,Z,Y)|T]),
		 type ==> neutral,

		 arcs ==> [		
					empty : empty => success
			  ],

		 diag_mod ==> detect_head([coord3(X,Z,Y)|T],ok)

		 ],

		[
		 id ==> check_status(Error),
		 type ==> neutral,

		 arcs ==> [		
					empty : empty => error
				    ],

		 diag_mod ==> detect_head(_,Error)

		 ],

		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[]

   ). 
