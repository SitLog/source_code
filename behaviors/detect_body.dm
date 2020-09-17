% Detect Body Task Dialogue Model
%
% 	Description	The robot detects bodies in its current field of view. 
%	
%	Arguments	
%
%               Mode:
%                   nearest.- retrieves the bodies in the scene arranging them from the nearest to the farthest
%                   innermost.- retrieves the bodies in the scene arranging them from the most central to the less central
%                   leftright.- retrieves the bodies in the scene arranging them from left to right
%                   rightleft.- retrieves the bodies in the scene arranging them from right to left
%
%               Time_observation: time of an observation in seconds. When the time finishes, the robot determines if there are 
%                   bodies in the scene
%
%               Body_positions: A list [ person1, person2, ..., personN ] where each person is a functor of the form
%                   person(id,r,o,w), where id is the identificator of the person, (r,o) is the polar coordinate in the XY plane, and w 
%                   is the orientation angle of the person. Persons are arranging from the nearest to the farthest
%	
%			    Status:	
%				    ok .- if there is at least one person in the scene
%			       	not_detected .- otherwise

diag_mod(detect_body(Mode,Time_observation,Body_position,Status), 
[

	    %Waits the number of seconds of Time_observation
	    [
		 id ==> wait,
		 type ==> neutral,
		 arcs ==> [		
					empty:[inc(count,C),sleep]=>  
						apply(when(If,TrueVal,FalseVal),[C>Time_observation,body_detection( apply(detect_body_mode(M),[Mode]) ),wait])
			  ]
		],
	    
	    %Verifies if there is a body in scene
		[
		    id ==> body_detection(NumericalMode),
		    type ==> detect_body(NumericalMode),
		    arcs ==> [
                                detected(X): empty => check_result(X)	  	
		             ]
        ],
        
        %Case 1 No body is detected
        [
		    id ==> check_result(no_body_detected),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => error
			  ],
			diag_mod ==> detect_body(_,_,_,not_detected)
		],
        
        %Case 2 A body is detected
        [
		    id ==> check_result(DetectedPersons),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => success
			  ],
			  diag_mod ==> detect_body(_,_,DetectedPersons,success)
		],
		
		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[
	    count ==> 0
	]

   ). 
