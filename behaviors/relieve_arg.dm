% Relieve Task Dialogue Model
%
% 	Description	The robot relieves an object to a person or put it on a place
%	
%	Arguments	Hand: label of arm which will relieve and object, and could be 'left' or 'right'
%				Ang: angle to relieve at
%				Dist: distance to relieve at
%
%			Status:	
%				ok .- if the object was correctly relieved
%				not_relieved .- the object could not be relieved

diag_mod(relieve_arg(Ang, Dist, Hand, Status),
[

		[
		 id ==> relieving,
		 type ==> neutral,
		 arcs ==> [		
                 	empty:[
					       switcharm( apply(get_number_of_arm(A), [Hand]) ), 
					       offer(Ang,Dist),
					       close_grip,
					       apply(reset_hand(H), [Hand])
					      ] => success
				]
		 ],

		[
		 id ==> success,
		 type ==> final,
		 diag_mod ==> relieve_arg(_, _, _, ok)
        ],

		[
		 id ==> error,
		 type ==> final,
		 diag_mod ==> relieve_arg(_, _, _, not_relieved)
		]	     
		

	    ], 

	% List of Local Variables
	[]

   ). 
