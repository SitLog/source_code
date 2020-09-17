%   See gesture Task Dialogue Model
%
% 	Description	The robot detects bodies making a specific gesture in its current field of view. 
%	
%	Arguments	
%
%               Type:
%				    hand_up .- the person is handing up one of his/her hands
%                   waving .- the person is waving both hands over his/her head 
%	    			pointing .- the person is pointing with one of his/her hands
%                   if is a variable, the system will collect all the gesture of a kind, choosing the gesture of the nearest person
%                   observed according to the mode
%
%               Mode:
%                   nearest.- retrieves the bodies making the gesture in the scene arranging them from the nearest to the farthest
%                   innermost.- retrieves the bodies making the gesture in the scene arranging them from the most central to the less %                         central
%                   leftright.- retrieves the bodies making the gesture in the scene arranging them from left to right
%                   rightleft.- retrieves the bodies making the gesture in the scene arranging them from right to left
%
%               Time_observation: time of an observation in seconds. When the time finishes, the robot determines if there are 
%                   bodies making the gesture in the scene
%
%               Body_positions: A list [ person1, person2, ..., personN ] where each person is a functor of the form
%                   person(id,r,o,p), where id is the identificator of the person, (r,o) is the polar coordinate in the XY plane, and p 
%                   is the gesture parameter (for hand_up if the gesture is done with left/right hand, and for pointing the angle)
%	
%			    Status:	
%				    ok .- if there is at least one person doing the gesture in the scene
%			       	not_detected .- otherwise

diag_mod(see_gesture(Type,Mode,Time_observation,Body_position,Status), 
[

	    %Keeps count of the number of observations before Time_observation
	    [
		 id ==> wait,
		 type ==> neutral,
		 arcs ==> [		
					empty:[inc(count,C),sleep]=>  
						apply(when(If,TrueVal,FalseVal),[C>Time_observation,nothing_detected,gesture_detection( apply(detect_gesture_mode(T),[Type]) , apply(detect_body_mode(M),[Mode]) )])
			  ]
		],
		
		%In this case, any gesture is needed
		[
		    id ==> gesture_detection(0,NumericalMode2),
		    type ==> detect_any_gesture(NumericalMode2),
		    arcs ==> [
                                detected(X): empty => check_result_any_gesture(X)	  	
		             ]
        ],
	    
	    %Verifies if there is a body in scene
		[
		    id ==> gesture_detection(NumericalMode1,NumericalMode2),
		    type ==> detect_gesture(NumericalMode1,NumericalMode2),
		    arcs ==> [
                                detected(X): empty => check_result(X)	  	
		             ]
        ],
        
        %Case 1 No body is detected, try again
        [
		    id ==> check_result(no_gesture_detected),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => wait
			  ]
		],
        
        %Case 2 A body is detected, we're done
        [
		    id ==> check_result(DetectedGestures),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => success
			  ],
			  diag_mod ==> see_gesture(_,_,_,DetectedGestures,success)
		],
		
		%Case 3 No body is detected, try again
        [
		    id ==> check_result_any_gesture(no_gesture_detected),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => wait
			  ]
		],
        
        %Case 4 A body is detected, we're done
        [
		    id ==> check_result_any_gesture([GestureValue|DetectedGestures]),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => check_result_any_gesture2(apply(get_name_of_gesture(GV),[GestureValue]),DetectedGestures)
			  ]
		],
		
		[
		    id ==> check_result_any_gesture2(GestureType,DetectedGestures),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => success
			  ],
			  diag_mod ==> see_gesture(GestureType,_,_,DetectedGestures,success)
		],
		
		%Nothing was detected in the Time_observations, get out with error
        [
		    id ==> nothing_detected,
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => error
			  ],
			diag_mod ==> see_gesture(_,_,_,_,not_detected)
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
