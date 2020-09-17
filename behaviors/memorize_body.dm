% Memorize Body Task Dialogue Model
%
% 	Description	The robot detects and memorizes a body in its current field of view. 
%	
%	Arguments	
%
%               Mode:
%                   nearest.- detect and memorize the nearest body in scene 
%                   innermost.- detect and memorize the most central body in scene
%                   leftright.- detect and memorize the body most to the left in scene
%                   rightleft.- detect and memorize the body most to the right in scene
%
%               Time_observation: time of an observation in seconds. When the time finishes, the robot determines if there are 
%                   bodies in the scene
%
%               Name: Name of the person (must be declared in the knowledge base)
%
%               Body_position: A functor of the form person(id,r,o,w), where id is the identificator of the person, (r,o) is the polar %                   coordinate in the XY plane, and w is the orientation angle of the person, with information of the memorized person
%	
%			    Status:	
%				    ok .- if the person was detected and memorized
%			       	not_detected .- if the person was not detected

diag_mod(memorize_body(Mode,Time_observation,Name,Body_position,Status), 
[

        %Detect bodies
        [  
      		id ==> detect_body,
      		type ==> recursive,
		    embedded_dm ==> detect_body(Mode,Time_observation,Detected_Bodies,Detect_Status),
      		arcs ==> [
        			success : empty => memorize(Detected_Bodies , apply(get_name_numerical_id(N),[Name]) ),
        			error : empty => not_detected				
      			]
        ],

	    %Memorize first body in list
		[
		    id ==> memorize([person(ID,R,O,W)|T],Name_num),
		    type ==> memorize_body(ID,W,Name_num),
		    arcs ==> [
                                memorized(X): empty => check_result(person(ID,R,O,W))	  	
		             ]
        ],
        
        [
		    id ==> check_result(MemorizedPerson),
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => success
			  ],
			diag_mod ==> memorize_body(_,_,_,MemorizedPerson,success)
		],
        
		%In case no body is detected
        [
		    id ==> not_detected,
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => error
			  ],
			diag_mod ==> memorize_body(_,_,_,_,not_detected)
		],
		
		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[
	    
	]

   ). 
