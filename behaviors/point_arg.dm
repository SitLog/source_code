% Point Task Dialogue Model
%
% 	Description	The robot points with his arm
%	
%	Arguments	Hand: label of arm which will be used to point, and could be 'left' or 'right'
%				
%			Status:	
%				ok .- if the movement with the hand was done correctly
%				error .- if the movement with the hand was not performed

diag_mod(point_arg(Ang, Dist, Hand, Status),
[

		[
		 id ==> pointing,
		 type ==> neutral,
		 arcs ==> [		
					empty:[
					       switcharm( apply(get_number_of_arm(A), [Hand]) ), 
					       offer(Ang, Dist),
					       close_grip
					      ] => success
				]
        ],

		[
		 id ==> success,
		 type ==> final,
		 diag_mod ==> point(_, ok)
        ],

		[
		 id ==> error,
		 type ==> final,
		 diag_mod ==> point(_, error)
		]	     
		
	    ], 

	% List of Local Variables
	[]

   ). 
