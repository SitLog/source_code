% See Body Task Dialogue Model
%
% 	Description	The robot sees a body in its current field of view
%	
%	Arguments	
%
%			Mode: 	
%                   detect .- the robot detects a face
%				    memorize .- the robot detects and memorize a face
%				    recognize .- the robot detects and recognize a face
%
%           Name:   Label which will be used as an identificator for the learned/sought person. If is a variable in mode 'recognize', it %                   will search for any person in the scene and retrieve its label if the person is known, or 'unknown' if the person is %                   not in the database.
%           
%           Focused_person:
%                   nearest.- retrieves the bodies in the scene arranging them from the nearest to the farthest
%                   innermost.- retrieves the bodies in the scene arranging them from the most central to the less central
%                   leftright.- retrieves the bodies in the scene arranging them from left to right
%                   rightleft.- retrieves the bodies in the scene arranging them from right to left
%
%           Time_observation: time of an observation in seconds. When the time finishes, the robot determines if there are 
%                   bodies in the scene
%
%           Body_positions: 
%                   In detection mode is a list [ person1, person2, ..., personN ] where each person is a functor of the form
%                   person(id,r,o,w), where id is the identificator of the person, (r,o) is the polar coordinate in the XY plane, and w 
%                   is the orientation angle of the person. Persons are arranging from the nearest to the farthest
%                   In memorize and recognize mode there will be only one element in the list, corresponding to the 
%                   memorized/identified person
%				
%			Status:	
%				    ok .- if there is at least one person in the scene
%			       	not_detected .- otherwise


diag_mod(see_body(Mode,Name,Focused_person,Time_observation,Body_positions,Status), 
[
		
		[
		    id ==> is,
		    type ==> neutral,
		    arcs ==> [		
					empty:empty => see_body(Mode)
				    ]
		],
		
		%Detect body mode
		[
		    id ==> see_body(detect),
		    type ==> recursive,
		    out_arg ==> [_, Detected_Persons, Detect_Status],
	 	    embedded_dm ==> detect_body(Focused_person,Time_observation,Detected_Persons,Detect_Status),
		    arcs ==> [		
					    success:empty => success,
					    error:empty => error
			  	    ]
		],		
		
		%Memorize body mode
		[
		    id ==> see_body(memorize),
		    type ==> recursive,
		    out_arg ==> [_, Detected_Persons, Detect_Status],
	 	    embedded_dm ==> memorize_body(Focused_person,Time_observation,Name,Detected_Persons,Detect_Status),
		    arcs ==> [		
					    success:empty => success,
					    error:empty => error
			  	    ]
		],
		
		%Recognize body mode
		[
		    id ==> see_body(recognize),
		    type ==> recursive,
		    out_arg ==> [Name, Detected_Persons, Detect_Status],
	 	    embedded_dm ==> recognize_body(Focused_person,Time_observation,Name,Detected_Persons,Detect_Status),
		    arcs ==> [		
					    success:empty => success,
					    error:empty => error
			  	    ]
		],		
	
		% Final Situations

		[
		    id ==> success, 
		    type ==> final,
		    in_arg ==> [Name, Body_positions,Status],
		    diag_mod ==> see_body(_,Name,_,_,Body_positions,Status)
		],

		[
            id ==> error, 
		    type ==> final,
		    in_arg ==> [Name, Body_positions,Status],
		    diag_mod ==> see_body(_,Name,_,_,Body_positions,Status)
		]

	    ], 

	% List of Local Variables
	[]

   ). 















