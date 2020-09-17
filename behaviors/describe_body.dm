% Describe Body Task Dialogue Model
%
% 	Description	The robot detects and describes a body in its current field of view. 
%	
%	Arguments	
%
%               Mode:  (preference in identification is given to first in list)
%                   nearest.- retrieves the bodies in the scene arranging them from the nearest to the farthest
%                   innermost.- retrieves the bodies in the scene arranging them from the most central to the less central
%                   leftright.- retrieves the bodies in the scene arranging them from left to right
%                   rightleft.- retrieves the bodies in the scene arranging them from right to left
%
%               Time_observation: time of an observation in seconds. When the time finishes, the robot determines if there are 
%                   bodies in the scene
%
%               Body_description: Description of the person 
%
%               Body_position: A functor of the form person(id,r,o,w), where id is the kinect id of the person, (r,o) is the polar
%                   coordinate in the XY plane, and w is the orientation angle of the person, with information of the recognized person
%	
%	        Status:	
%		    ok .- if the person was detected and recognized
%		    not_detected .- if no person was detected
%                   not_found.- if the persons in scene are not the searched person
%                   invalid_name.- the requested name is not declared in the knowledge base

diag_mod(describe_body(Mode,Time_observation,Body_description,Body_position,Status), 
[

        %Detect bodies
        [  
      		id ==> detect_body,
      		type ==> recursive,
		embedded_dm ==> detect_body(Mode,Time_observation,Detected_Bodies,Detect_Status),
      		arcs ==> [
        			success : empty => analyzing_person(Detected_Bodies),
        			error : empty => not_detected				
      			]
        ],
        
        %In case no body is detected
        [
		    id ==> not_detected,
		    type ==> neutral,
		    arcs ==> [		
					empty : empty => error
			  ],
		    diag_mod ==> describe_body(_,_,_,_,not_detected)
	],
	
	[
	        id ==> analyzing_person([person(ID,R,O,W)|T]),
		type ==> describe_body(ID,W),
		arcs ==> [
                            description(X): say('I am analyzing the person') => success	
		         ]
        ],
        
          
			
	% Final Situations
	
	[id ==> success, type ==> final],

	[id ==> error, type ==> final]

	], 

	% List of Local Variables
	[
	    
	]

   ). 
