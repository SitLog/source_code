% See Person Task Dialogue Model
%
% 	Description	The robot sees a person in its current field of view
%	
%	Arguments	Name:	Label which will be used as an identificator for the learned/sought person. If is a variable in mode 'recognize'
%                       or'recognize_with_approach', it will search for any person in the scene and retrieve its label if the person is %                       known, or 'unknown' if the person is not in the database. 
%
%			    Modes: 
%                   detect_body
%                   memorize_body
%                   recognize_body    
%                   detect_body_with_approach
%                   memorize_body_with_approach
%                   recognize_body_with_approach    
%
%                   detect_face
%                   memorize_face
%                   recognize_face           
%               
%               detect .- the robot detects a head
%				memorize .- the robot detects a head and memorize the face
%				recognize .- the robot detects a head and recognize the face
%				detect_with_approach.- the robot detects a head, approach to it and detects the face to verify 
%				memorize_with_approach.-  the robot detects a head, approach to it, detects the face to verify and memorize the face
%				recognize_with_approach.-  the robot detects a head, approach to it, detects the face to verify and recognize the face
%				
%			Status:	
%				ok .- if a face was correctly detected/memorized/recognized or someone has found when searching for anybody
%				not_detected .- if the detection of a face failed
%				lost_user .- if the face dissapears during the learning/recognition process
%				not_found .- the sought person wasn't found
%			       	camera_error .- if there is a problem with the camera 


diag_mod(see_person(Name, Mode, Person_Positions,Status), 
[
		
		%Verify mode
		[
		    id ==> is,
		    type ==> neutral,
		    arcs ==> [		
					empty:empty => check_mode(Mode)
				    ]
		],	
		
		%%%BODY%%%
		
		%Case detect_body
		[  
      		 id ==> check_mode(detect_body),
      		 type ==> recursive,
		     out_arg ==> [Body_Position, _, Detect_Status],
      		 embedded_dm ==> see_body(detect,_,nearest,3,Body_Position,Detect_Status),
      		 arcs ==> [
        			    success:empty => success,
        			    error: empty => error				
      		          ]
	    ],
	    
	    %Case memorize_body
		[  
      		 id ==> check_mode(memorize_body),
      		 type ==> recursive,
		     out_arg ==> [Body_Position, _, Detect_Status],
      		 embedded_dm ==> see_body(memorize,Name,nearest,3,Body_Position,Detect_Status),
      		 arcs ==> [
        			    success:empty => success,
        			    error: empty => error				
      		          ]
	    ],
	    
	    %Case recognize_body
		[  
      		 id ==> check_mode(recognize_body),
      		 type ==> recursive,
		     out_arg ==> [Body_Position, Name, Detect_Status],
      		 embedded_dm ==> see_body(recognize,Name,nearest,3,Body_Position,Detect_Status),
      		 arcs ==> [
        			    success:empty => success,
        			    error: empty => error				
      		          ]
	    ],
	    
	    %Case detect_body_with_approach
		[  
      		 id ==> check_mode(detect_body_with_approach),
      		 type ==> recursive,
		     out_arg ==> [Body_Position, _, Detect_Status],
		     embedded_dm ==> approach_person(body,Body_Position,Detect_Status),
      		 arcs ==> [
        			    success:empty => success,
        			    error: empty => error				
      		          ]
	    ],
	    
	    %Case memorize_body_with_approach
		[  
      		 id ==> check_mode(memorize_body_with_approach),
      		 type ==> recursive,
		     out_arg ==> [Body_Position, _, Detect_Status],
		     embedded_dm ==> approach_person(body,Body_Position,Detect_Status),
      		 arcs ==> [
        			    success:empty => check_mode(memorize_body),
        			    error: empty => error				
      		          ]
	    ],
	    
	    %Case recognize_body_with_approach
		[  
      		 id ==> check_mode(recognize_body_with_approach),
      		 type ==> recursive,
		     out_arg ==> [Body_Position, _, Detect_Status],
		     embedded_dm ==> approach_person(body,Body_Position,Detect_Status),
      		 arcs ==> [
        			    success:empty => check_mode(recognize_body),
        			    error: empty => error				
      		          ]
	    ],
	    
	    %%%FACE%%%
	    
	    %Case detect_face
		[  
      		 id ==> check_mode(detect_face),
      		 type ==> recursive,
		     out_arg ==> [Face_Position, _, Detect_Status],
      		 embedded_dm ==> see_face(_, detect, Face_Position, Detect_Status),
      		 arcs ==> [
        			    success:empty => success,
        			    error: empty => error				
      		          ]
	    ],
	    
	    %Case memorize_face
		[  
      		 id ==> check_mode(memorize_face),
      		 type ==> recursive,
		     out_arg ==> [Face_Position, _, Detect_Status],
      		 embedded_dm ==> see_face(Name, memorize, Face_Position, Status),
      		 arcs ==> [
        			    success:empty => success,
        			    error: empty => error				
      		          ]
	    ],
	    
	    %Case recognize_face
		[  
      		 id ==> check_mode(recognize_face),
      		 type ==> recursive,
		     out_arg ==> [Face_Position, Name, Detect_Status],
      		 embedded_dm ==> see_face(Name, recognize, Face_Position, Status),
      		 arcs ==> [
        			    success:empty => success,
        			    error: empty => error				
      		          ]
	    ],
	    
	    
	    
	    %%%OLD VERSION CODE%%%
	
		%Detect Head in all cases
		[  
      		 id ==> check_mode(Other),
      		 type ==> recursive,
		     out_arg ==> [Head_Position, _, Detect_Status],
      		 embedded_dm ==> detect_head(Head_Position,Detect_Status),
      		 arcs ==> [
        			success:empty => see_head(Mode),
        			error: empty => error				
      		          ]
	    ],

		[
		 id ==> see_head(detect),
		 type ==> neutral,
		 arcs ==> [		
					empty:empty => success
				    ]
		 ],

		[
		 id ==> see_head(memorize),
		 type ==> recursive,
	 	 out_arg ==> [_, Name, Face_Status],
		 embedded_dm ==> memorize_face(Name,Face_Status),
		 arcs ==> [		
					success:empty => success,
					error:empty => error
				    ]
		 ],

		[
		 id ==> see_head(recognize),
		 type ==> recursive,
	 	 out_arg ==> [_, Name, Face_Status],
		 embedded_dm ==> recognize_face(Name,Face_Status),
		 arcs ==> [		
					success:empty => success,
					error:empty => error
				    ]
		 ],

		[  
      		 id ==> see_head(ModeWithApproach),
      		 type ==> recursive,
		 in_arg ==> [Head_Position, _, _],
                 out_arg ==> [_, _, Approach_Status],
      		 embedded_dm ==> approach_person(Head_Position,Final_Head_Position,Approach_Status),
      		 arcs ==> [
        			success : [say('See my camera please')] => verify_face(Mode),
        			error : empty => error
			  ]
                ],


		[  
      		 id ==> verify_face(detect_with_approach),
      		 type ==> recursive,
		 out_arg ==> [_, _, Verify_Status],
      		 embedded_dm ==> see_face(X, detect, Verify_Status),
      		 arcs ==> [
        			success : empty => success,
        			error : empty => error				
      		          ]
    		],

		[  
      		 id ==> verify_face(memorize_with_approach),
      		 type ==> recursive,
		 out_arg ==> [_, Name, Verify_Status],
      		 embedded_dm ==> see_face(Name, memorize, Verify_Status),
      		 arcs ==> [
        			success : empty => success,
        			error : empty => error				
      		          ]
    		],

		[  
      		 id ==> verify_face(recognize_with_approach),
      		 type ==> recursive,
		     out_arg ==> [_, Name, Verify_Status],
      		 embedded_dm ==> see_face(Name, recognize, Verify_Status),
      		 arcs ==> [
        			success : empty => success,
        			error : empty => error				
      		          ]
    	],

	
		% Final Situations

		[
		    id ==> success, 
		    type ==> final,
		    in_arg ==> [Position , Name, Face_Status],
		    diag_mod ==> see_person(Name, _, Position, Face_Status)
		],

		[
            id ==> error, 
		    type ==> final,
		    in_arg ==> [Position , Name, Face_Status],
		    diag_mod ==> see_person(Name, _, Position, Face_Status)
		]

	    ], 

	% List of Local Variables
	[]

   ). 























